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
    FResSet : TResultPost;
    FHTTP   : THTTPSend;

    function ReadIni : Boolean;
    procedure GenCreate;
    function StoreINsInRes(Pars : TParsGet) : integer;
    function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
    procedure Docs4CurIN(IndNum, PID : string; IndNs: TStringList);
    function Post1Doc(ParsPost: TParsPost; StreamDoc : TStringStream) : TResultPost;
    function SetRetCode(Ret: Boolean; var sErr: string): integer;
  protected
  public
    // Результат запроса данных (GET)
    property ResGet : TResultGet read FResGet write FResGet;
    // Результат отправки данных (POST)
    property ResPost : TResultPost read FResSet write FResSet;

    (* Получить список документов [убытия]
    *)
    function GetDeparted(DBeg, DEnd : TDateTime; OrgCode : string = '') : TResultGet; overload;
    function GetDeparted(ParsGet : TParsGet) : TResultGet; overload;

    (* Получить документ актуальной регистрации
    *)
    function GetActualReg(INum : string) : TResultGet; overload;
    function GetActualReg(IndNs: TStringList) : TResultGet;  overload;
    function GetActualReg(ParsGet : TParsGet) : TResultGet;  overload;

    (* Записать сведения о регистрации
    *)
    function PostRegDocs(ParsPost: TParsPost) : TResultPost;

    (* Получить содержимое справочника
    *)
    function GetNSI(NsiType : integer; NsiCode : integer = 0; URL : string = ''): TResultGet;

    constructor Create(Pars : TParsExchg); overload;
    constructor Create(MName : string); overload;
    constructor Create(MetaINI : TSasaIniFile); overload;
    destructor Destroy; override;
  published
  end;

var
  BlackBox : TExchgRegCitizens = nil;

implementation

uses
  SysUtils,
  StrUtils,
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

// Общая часть для всех конструкторов
procedure TExchgRegCitizens.GenCreate;
begin
  // Установки по умолчанию
  FHost := THostReg.Create;
  FHost.URL := RES_HOST;
  FHost.GenPoint := RES_GENPOINT;
  FHost.NsiPoint := RES_NSI;
  FHost.Ver := RES_VER;
  if (NOT Assigned(FPars.Meta)) then
    if (Length(FPars.MetaName) > 0) then
      ReadIni;
end;


constructor TExchgRegCitizens.Create(Pars: TParsExchg);
begin
  inherited Create;
  FPars := Pars;
  GenCreate;
end;


constructor TExchgRegCitizens.Create(MName : string);
begin
  inherited Create;
  FPars := TParsExchg.Create(MName);
  GenCreate;
end;


constructor TExchgRegCitizens.Create(MetaINI : TSasaIniFile);
begin
  inherited Create;
  FPars := TParsExchg.Create(MetaINI);
  GenCreate;
end;


destructor TExchgRegCitizens.Destroy;
begin

end;


// Установка кодов возврата после HTTPSend
function TExchgRegCitizens.SetRetCode(Ret: Boolean; var sErr: string): integer;
var
  SOErr: ISuperObject;
  StreamDoc: TStringStream;
begin
  sErr := '';
  Result := FHTTP.ResultCode;

  try
    if (Ret = True) then begin
      if (FHTTP.ResultCode <> 200) then begin
        StreamDoc := TStringStream.Create('');
        try
          StreamDoc.Seek(0, soBeginning);
          StreamDoc.CopyFrom(FHTTP.Document, 0);
          if (FHTTP.ResultCode = 500) then begin
            SOErr := SO(Utf8Decode(StreamDoc.DataString));
            Result := SOErr.I['status'];
            sErr := SOErr.S['message'];
          end
          else
            sErr := Utf8ToAnsi(StreamDoc.DataString) + CRLF + FHTTP.Headers[0];
          raise Exception.Create(sErr);
        finally
          StreamDoc.Free;
        end;
      end;
      sErr := FHTTP.ResultString;
      Result := 0;
    end
    else begin
      Result := FHTTP.sock.LastError;
      sErr := FHTTP.sock.LastErrorDesc;
      raise Exception.Create(sErr);
    end;
  except
    on E: Exception do begin
      if (sErr <> '') then
        sErr := E.Message;
    end;
  end;
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
  Result := Pars.FIOrINs.Count;
  for i := 1 to Result do begin
    FResGet.INs.Append;
    FResGet.INs.FieldValues['IDENTIF'] := Pars.FIOrINs[i - 1];
    FResGet.INs.Post;
  end;
end;


// Перевод Num->Str
function MakeNumAsStr(const NumField, Src: string): string;
const
  NumToken = ',"%s":';
var
  TokLen,
  Offs, MaxI,
  i : Integer;
  s,
  Dst, Srch: string;

  function SelectNum: string;
  var
    iBeg, iLen : Integer;
  begin
    Result := '';
    iBeg := i;
    iLen := 0;
    while (i <= MaxI) do begin
      if not (Src[i] in ['0'..'9']) then begin
        Result := Copy(Src, iBeg, iLen);
        Break;
      end
      else
        Inc(iLen);
      i := i + 1;
    end;
  end;

begin
  Result := Src;
  Srch := Format(NumToken, [NumField]);
  // поиск строкового представления
  i := PosEx(Srch + '"', Src);
  if (i <= 0) then begin
    // строкового нет, числовое представление, его и ищем
    MaxI := Length(Src);
    TokLen := Length(Srch);
    Dst := '';
    Offs := 1;
    i := PosEx(Srch, Src, Offs);
    while (i > 0) do begin
      i := i + TokLen; // Nums start here
      Dst := Dst + Copy(Src, Offs, i - Offs);
      s := '"' + SelectNum + '"';
      Dst := Dst + s;
      Offs := i;
      i := PosEx(Srch, Src, Offs);
    end;
    Dst := Dst + Copy(Src, Offs, MaxI - Offs + 1);
    Result := Dst;
  end
end;


// Перемещение граждан за период
function GetListID(StrPars: string = ''): ISuperObject;
var
  Ret: Boolean;
  sDoc, sErr : string;
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
        sDoc := Utf8Decode(MemStream2Str(HTTP.Document));
        Result := SO(MakeNumAsStr('pid', sDoc));
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
procedure TExchgRegCitizens.Docs4CurIN(IndNum, PID : string; IndNs: TStringList);
var
  i: Integer;
  SOList: ISuperObject;
  DocDTO : TDocSetDTO;
begin
  try
    if ( Length(IndNum) >= 0) then begin
      IndNs.Clear;
      IndNs.Add(IndNum);
      IndNs.Add('');
      IndNs.Add('');
      IndNs.Add('');
      IndNs.Add(PID);
      IndNs.Add('');

      SOList := GetListDoc(FHost, IndNs);
      // должен вернуться массив установочных документов
      if Assigned(SOList) and (SOList.DataType = stArray) then begin
        DocDTO := TDocSetDTO.Create(ResGet.Docs, ResGet.Child);
        i := DocDTO.GetDocList(SOList);
      end;
    end;
  except
    on E:Exception do begin
      ShowDeb(E.Message);
    end;
  end;
end;

// Список убывших для сельсовета (период-сельсовет)
function TExchgRegCitizens.GetDeparted(DBeg, DEnd: TDateTime; OrgCode: string = ''): TResultGet;
var
  P: TParsGet;
begin
  Result := nil;
  if (OrgCode = '') then
    OrgCode := FPars.Organ;
  P := TParsGet.Create(DBeg, DEnd, OrgCode);
  try
    Result := GetDeparted(P);
  finally
    P.Free;
  end;
end;

// Список убывших для сельсовета (параметры)
function TExchgRegCitizens.GetDeparted(ParsGet: TParsGet): TResultGet;
var
  Ret: Boolean;
  nINs: Integer;
  sErr, sPars: string;
  IndNs: TStringList;
  //Docs: ISuperObject;
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
      Docs4CurIN(FResGet.INs.FieldValues['IDENTIF'], FResGet.INs.FieldValues['PID'], IndNs);
      FResGet.INs.Next;
    end;
    IndNs.Free;
    FResGet.ResCode := 0;
    Result := FResGet;
  end;
end;

// Актуальный документ регистрации для единственного ИН
function TExchgRegCitizens.GetActualReg(INum : string): TResultGet;
var
  IndNums: TStringList;
  ParsGet: TParsGet;
  Res: TResultGet;
begin
  Result := nil;
  IndNums := TStringList.Create;
  ParsGet := TParsGet.Create(IndNums, TLIST_INS);
  try
    IndNums.Add(INum);
    Result := GetActualReg(ParsGet);
  finally
    ParsGet.Free;
    IndNums.Free;
  end;
end;

// Получить актуальный документ регистрации для списка ИН
function TExchgRegCitizens.GetActualReg(IndNs: TStringList): TResultGet;
var
  ParsGet: TParsGet;
  Res: TResultGet;
begin
  try
    ParsGet := TParsGet.Create(IndNs, TLIST_INS);
    Result := GetActualReg(ParsGet);
  finally
    ParsGet.Free;
  end;
end;

// Получить актуальный документ регистрации для ИН
function TExchgRegCitizens.GetActualReg(ParsGet: TParsGet) : TResultGet;
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
      Docs4CurIN(FResGet.INs.FieldValues['IDENTIF'], '', IndNs);
      FResGet.INs.Next;
    end;
    IndNs.Free;
    FResGet.ResCode := 0;
    Result := FResGet;
  end;
end;

// Передача одного документа
function TExchgRegCitizens.Post1Doc(ParsPost: TParsPost; StreamDoc: TStringStream): TResultPost;
var
  nRet: Integer;
  sErr: string;
  Header: TStringList;
  DocDTO: TDocSetDTO;
begin
  sErr := '';
  Result := TResultPost.Create;

  try
    FHTTP.Headers.Clear;
    FHTTP.Headers.Add('sign:' + ParsPost.USign);
    FHTTP.Headers.Add('certificate:' + ParsPost.USert);
    FHTTP.MimeType := 'application/json;charset=UTF-8';
    if (ParsPost.JSONSrc = '') then begin
      DocDTO := TDocSetDTO.Create(ParsPost.Docs, ParsPost.Child);
      StreamDoc.Seek(0, soBeginning);
      if (DocDTO.MemDoc2JSON(ParsPost.Docs, ParsPost.Child, StreamDoc, False) = True) then
        FHTTP.Document.CopyFrom(StreamDoc, 0)
      else begin
        sErr := 'Error creating POST card';
        raise Exception.Create(sErr);
      end;
    end
    else
      FHTTP.Document.LoadFromFile(ParsPost.JSONSrc);

    nRet := SetRetCode(FHTTP.HTTPMethod('POST', ParsPost.FullURL), sErr);
  except
    on E: Exception do begin
      if (sErr = '') then
        sErr := E.Message;
      nRet := UERR_POST_REG;
    end;
  end;
  Result.ResCode := nRet;
  Result.ResMsg := sErr;
end;


// Передать документы регистрации
function TExchgRegCitizens.PostRegDocs(ParsPost: TParsPost): TResultPost;
var
  sErr: string;
  Header: TStringList;
  StreamDoc: TStringStream;
begin
  Result := TResultPost.Create;

  StreamDoc := TStringStream.Create('');
  FHTTP := THTTPSend.Create;
  try
    try
      ParsPost.FullURL := FullPath(FHost, POST_DOC, '');
      if (ParsPost.JSONSrc = '') then begin
        ParsPost.Docs.First;
        while not ParsPost.Docs.Eof do begin
          Result := Post1Doc(ParsPost, StreamDoc);
          if (Result.ResCode <> 0) then begin
            sErr := CRLF+Format('Инд.№=%s ID=%d',
              [ParsPost.Docs.FieldByName('LICH_NOMER').AsString, ParsPost.Docs.FieldByName('MID').AsInteger]);
            Result.ResMsg := Result.ResMsg + sErr;
            Break;
          end;
          ParsPost.Docs.Next;
        end;
      end
      else
        Result := Post1Doc(ParsPost, StreamDoc);
    except

    end;
  finally
    StreamDoc.Free;
    FHTTP.Free;
  end;

end;

// Получить содержимое справочника
function TExchgRegCitizens.GetNSI(NsiType: integer; NsiCode: integer = 0; URL: string = ''): TResultGet;
var
  nRet: Integer;
  SOList: ISuperObject;
  sType, sCode, sErr: string;
begin
  Result := TResultGet.Create(FPars, NSI_ONLY);

  if (URL = '') then begin
    if (NsiCode = 0) then
      sCode := ''
    else
      sCode := IntToStr(NsiCode);
    sType := IntToStr(NsiType);
    URL := Format('/type/%s?code=%s&active=true&first&count', [sType, sCode]);
    URL := FullPath(FHost, GET_NSI, URL);
  end;

  FHTTP := THTTPSend.Create;
  try
    try
      nRet := SetRetCode(FHTTP.HTTPMethod('GET', URL), sErr);
      if (nRet = 0) then begin
        sErr := MemStream2Str(FHTTP.Document);
        SOList := SO(Utf8Decode(sErr));
        nRet := 801;
        sErr := 'No DATA in HTTP-Document';
        if Assigned(SOList) and (SOList.DataType = stArray) then begin
          if (TDocSetDTO.GetNSI(SOList, Result.Nsi) > 0) then begin
            nRet := 0;
            sErr := '';
          end;
        end;
      end;
    except
      on E: Exception do begin
        if (sErr = '') then
          sErr := E.Message;
        nRet := UERR_GET_NSI;
      end;
    end;
  finally
    FHTTP.Free;
  end;
  Result.ResCode := nRet;
  Result.ResMsg := sErr;

end;


end.
