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

  // "черный €щик" обмена с REST-сервисом
  TExchgRegCitizens = class(TInterfacedObject)
  private
    FPars   : TParsExchg;
    FHost   : THostReg;
    FResGet : TResultGet;
    FResSet : TResultSet;
    FHTTP   : THTTPSend;

    //FChild,
    //FDocs,
    //FIDs : TkbmMemTable;

    function ReadIni : Boolean;
    function StoreINsInMT(Pars : TParsGet) : integer;
    function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
    procedure Docs4CurIN(IndNum : string; IndNs: TStringList);

  protected
  public
    property ResGet : TResultGet read FResGet write FResGet;
    property ResSet : TResultGet read FResGet write FResGet;
    (* ѕолучить список документов [убыти€]
    *)
    function GetRegDocs(ParsGet : TParsGet) : TResultGet;
    (* «аписать сведени€ о регистрации
    *)
    function SetRegDocs(): TResultSet;

    constructor Create(Pars : TParsExchg);
    destructor Destroy; override;
  published
  end;

var
  BlackBox : TExchgRegCitizens = nil;

implementation

uses
  SysUtils,
  NativeXml;



function TExchgRegCitizens.ReadIni: Boolean;
begin
  try
    FPars.Meta := TSasaIniFile.Create(FPars.MetaName);

    Result := True;
  except
    Result := False;
  end;
end;

constructor TExchgRegCitizens.Create(Pars : TParsExchg);
begin
  inherited Create;
  FPars := Pars;
  FHost := THostReg.Create;
  FHost.URL := RES_HOST;
  FHost.GenPoint := RES_GENPOINT;
  FHost.Ver := RES_VER;

  if (Length(FPars.MetaName) > 0) then
    ReadIni;
end;

destructor TExchgRegCitizens.Destroy;
begin

end;



// установка параметров дл€ GET : получени€ списка документов по территории
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













function TExchgRegCitizens.StoreINsInMT(Pars : TParsGet) : integer;
var
  i : Integer;
  t : TkbmMemTable;
begin
  Result := Pars.FIOrINs.Count;
  i := 1;
  while i <= Result do begin



    i := i + 1;
  end;



end;



// ѕеремещение граждан за период
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



function FillIDList(SOArr: ISuperObject; IDs: TkbmMemTable): Integer;
  function CT(s: string): string;
  begin
    Result := s;
  end;

var
  i, SOMax: Integer;
  SO: ISuperObject;
begin
  try
    IDs.EmptyTable;
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      IDs.Append;
      //IDs.FieldByName('PID').AsString := SO.S[CT('pid')];
      IDs.FieldByName('IDENTIF').AsString        := SO.S[CT('IDENTIFIER')];
      IDs.FieldByName('DATEREC').AsDateTime      := sdDateTimeFromString(SO.S[CT('REG_DATE')], false);
      IDs.FieldByName('ORG_WHERE_CODE').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('CODE')];
      IDs.FieldByName('ORG_WHERE_NAME').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('LEX')];
      IDs.FieldByName('ORG_FROM_CODE').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('CODE')];
      IDs.FieldByName('ORG_FROM_NAME').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('LEX')];
      IDs.Post;
      i := i + 1;
    end;
  except
  end;
  Result := i;
end;




// »ндивидуальные номера граждан за период
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
      Result := FillIDList(SOList, MT);
  end;
end;





// ѕолучить документы дл€ текущего в списке ID
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
      // должен вернутьс€ массив установочных документов
      if Assigned(SOList) and (SOList.DataType = stArray) then begin
        i := FillDocList(SOList, ResGet.Docs, FResGet.Child);
      end;
    end;
  except
    on E:Exception do begin
      ShowDeb(E.Message);
    end;
  end;
end;



// ѕолучить документы дл€ сельсовета за период
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
    nINs := StoreINsInMT(ParsGet)
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

// ѕередать документы регистрации
function TExchgRegCitizens.SetRegDocs(): TResultSet;
begin
  Result := TResultSet.Create;
end;

end.
