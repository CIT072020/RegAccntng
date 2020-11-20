unit ExchgRegBase;

interface

uses
  Classes, DB,
  kbmMemTable,
  superobject,
  httpsend,
  SasaINiFile,
  uPars,
  uService;

type

  // "черный ящик" обмена с REST-сервисом
  TExchgRegCitizens = class(TInterfacedObject)
  private
    FPars   : TParsExchg;
    FHost   : THostReg;
    FResGet : TResultGet;
    FResSet : TResultSet;
    FHTTP   : THTTPSend;

    function ReadIni : Boolean;
    function StoreINsInRes(Pars : TParsGet) : integer;
    function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
    procedure Docs4CurIN(IndNum : string; IndNs: TStringList);
  protected
  public
    property ResGet : TResultGet read FResGet write FResGet;
    property ResSet : TResultGet read FResGet write FResGet;
    (* Получить список документов [убытия]
    *)
    function GetRegDocs(ParsGet : TParsGet) : TResultGet;
    (* Записать сведения о регистрации
    *)
    function SetRegDocs(ParsPost: TParsPost) : TResultSet;

    constructor Create(Pars : TParsExchg);
    destructor Destroy; override;
  published
  end;

var
  BlackBox : TExchgRegCitizens = nil;

implementation

uses
  SysUtils,
  NativeXml,
  uDTO;

// Заполнение параметров из INI-файла
function TExchgRegCitizens.ReadIni: Boolean;
begin
  try
    FPars.Meta := TSasaIniFile.Create(FPars.MetaName);

    Result := True;
  except
    Result := False;
  end;
end;

constructor TExchgRegCitizens.Create(Pars: TParsExchg);
begin
  inherited Create;
  FPars := Pars;
  FHost := THostReg.Create;
  FHost.URL := RES_HOST;
  FHost.GenPoint := RES_GENPOINT;
  FHost.Ver := RES_VER;

  if (NOT Assigned(FPars.Meta)) then
    if (Length(FPars.MetaName) > 0) then
      ReadIni;
end;

destructor TExchgRegCitizens.Destroy;
begin

end;



// установка параметров для GET : получения списка документов по территории
//
// Example:
// /v1/movements/sys_organ/:sys_organ/period/:since/:till?first=1&count=1
// :sys_organ - required
// :since - required
// :till - required
// first=[0]
// count=[500]
function SetPars4GetIDs(Pars : TStringList) : string;
var
  s : string;
begin
  s := Format( '/sys_organ/%s/period/%s/%s?first=%s&count=%s',
    [Pars[0], Pars[1], Pars[2], Pars[3], Pars[4]]);
  Result := s;
end;





// Скопировать список ИН в выходную таблицу
function TExchgRegCitizens.StoreINsInRes(Pars : TParsGet) : integer;
var
  i : Integer;
begin
  i := 1;
  while i <= Result do begin
    FResGet.INs.Append;
    FResGet.INs.FieldValues['IDENTIF'] := Pars.FIOrINs[i - 1];
    FResGet.INs.Post;
    i := i + 1;
  end;
  Result := Pars.FIOrINs.Count;
end;



// Перемещение граждан за период
function GetListID(StrPars: string = ''): ISuperObject;
var
  INsCount : Integer;
  Ret: Boolean;
  sDoc, sErr : string;
  Docs: ISuperObject;
  HTTP: THTTPSend;
begin
  Result := nil;

  ShowDeb(StrPars);

  HTTP := THTTPSend.Create;
  //FHTTP := THTTPSend.Create;
  try
    try
      Ret := HTTP.HTTPMethod('GET', StrPars);
      if (Ret = True) then begin
        if (HTTP.ResultCode < 200) or (HTTP.ResultCode >= 400) then begin
          sErr := HTTP.Headers.Text;
          raise Exception.Create(sErr);
        end;
        ShowDeb(IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString);
        sDoc := MemStream2Str(HTTP.Document);
        Result := SO(Utf8Decode(sDoc));
      end
      else begin
        sErr := IntToStr(HTTP.sock.LastError) + ' ' + HTTP.sock.LastErrorDesc;
        raise Exception.Create(sErr);
      end;
    except

    end;
  finally
    HTTP.Free;
  end;

end;


// Индивидуальные номера граждан за период
function TExchgRegCitizens.GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
var
  Pars : TStringList;
  SOList : ISuperObject;
begin
  Result := 0;
  if (Length(ParsGet.FullURL) = 0) then begin
    Pars := TStringList.Create;
    Pars.Add(ParsGet.Organ);
    Pars.Add(DateToStr(ParsGet.DateBeg));
    Pars.Add(DateToStr(ParsGet.DateEnd));
    Pars.Add(IntToStr(ParsGet.First));
    Pars.Add(IntToStr(ParsGet.Count));
    ParsGet.FullURL := FullPath(FHost, GET_LIST_ID, SetPars4GetIDs(Pars));
  end;
  SOList := GetListID(ParsGet.FullURL);
  if Assigned(SOList) and (SOList.DataType = stArray) then begin
      Result := TIndNomDTO.GetIndNumList(SOList, MT);
  end;
end;


// Получить документы для текущего в списке ID
procedure TExchgRegCitizens.Docs4CurIN(IndNum : string; IndNs: TStringList);
var
  i: Integer;
  SOList: ISuperObject;
begin
  try
    if ( Length(IndNum) >= 0) then begin
      IndNs.Clear;
      IndNs.Add(IndNum);
      IndNs.Add('');
      IndNs.Add('');
      IndNs.Add('');
      IndNs.Add('');
      IndNs.Add('');

      SOList := GetListDoc(FHost, IndNs);
      // должен вернуться массив установочных документов
      if Assigned(SOList) and (SOList.DataType = stArray) then begin
        i := TDocSetDTO.GetDocList(SOList, ResGet.Docs, FResGet.Child);
      end;
    end;
  except
    on E:Exception do begin
      ShowDeb(E.Message);
    end;
  end;
end;


// Получить документы для сельсовета за период
function TExchgRegCitizens.GetRegDocs(ParsGet: TParsGet): TResultGet;
var
  Ret: Boolean;
  nINs: Integer;
  sDoc, sErr, sPars: string;
  IndNs: TStringList;
  Docs: ISuperObject;
begin
  Result := nil;
  FResGet := TResultGet.Create(FPars);

  // Fill MemTable with IDs
  if (Assigned(ParsGet.FIOrINs) and (ParsGet.ListType = TLIST_INS)) then
    nINs := StoreINsInRes(ParsGet)
  else
    nINs := GetINsFromSrv(ParsGet, FResGet.INs);
  if (nINs > 0) then begin
    IndNs := TStringList.Create;
    FResGet.INs.First;
    while not FResGet.INs.Eof do begin
      Docs4CurIN(FResGet.INs.FieldValues['IDENTIF'], IndNs);
      FResGet.INs.Next;
    end;
    IndNs.Free;
    FResGet.ResCode := 0;
    Result := FResGet;
  end;
end;

// Передать документы регистрации
function TExchgRegCitizens.SetRegDocs(ParsPost: TParsPost) : TResultSet;
begin
  Result := TResultSet.Create;
end;

end.
