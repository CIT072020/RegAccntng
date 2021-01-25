unit ExchgRegBase;

interface

uses
  Classes, DB,
  adscnnct, adstable,
  kbmMemTable,
  superobject,
  httpsend,
  SasaINiFile,
  FuncPr,
  uPars,
  uDTO,
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
    Fsecure : TSecureExchg;

    function ReadIni : Boolean;
    procedure GenCreate;
    function StoreINsInRes(Pars : TParsGet) : integer;
    function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
    function Docs4CurIN(Pars4GET : string; DocDTO : TDocSetDTO) : TResultGet;
    function Post1Doc(ParsPost: TParsPost; StreamDoc : TStringStream) : TResultPost;
    function SetRetCode(Ret: Boolean; var sErr: string): integer;
    function GetDSDList(ParsGet: TParsGet): TResultGet;
  public
    // Параметры обмена
    property BBPars : TParsExchg read FPars write FPars;
    // Результат запроса данных (GET)
    property ResGet : TResultGet read FResGet write FResGet;
    // Результат отправки данных (POST)
    property ResPost : TResultPost read FResSet write FResSet;
    property Secure : TSecureExchg read Fsecure write Fsecure;

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
    function GetNSI(ParsNsi : TParsNsi) : TResultGet;
    
    (* Перегнать справочник (MemTable) в ADS-таблицу
    *)
    function CreateADST(MT: TkbmMemTable; TType: integer; Conn: TAdsConnection; ResGet : TResultGet): Integer;

    constructor Create(MName : string); overload;
    constructor Create(MetaINI : TSasaIniFile); overload;
    constructor Create(Pars : TParsExchg); overload;
    destructor Destroy; override;
  published
  end;

var
  BlackBox : TExchgRegCitizens = nil;

implementation

uses
  SysUtils,
  StrUtils,
  NativeXml;

// Заполнение параметров из INI-файла
function TExchgRegCitizens.ReadIni: Boolean;
begin
  // Установки из INI или по умолчанию
  FHost := THostReg.Create;
  FHost.URL      := FPars.Meta.ReadString(SCT_HOST, 'URL', RES_HOST);
  FHost.GenPoint := FPars.Meta.ReadString(SCT_HOST, 'RESPATH', RES_GENPOINT);
  FHost.NsiPoint := FPars.Meta.ReadString(SCT_HOST, 'NSIPATH', RES_NSI);
  FHost.Ver      := FPars.Meta.ReadString(SCT_HOST, 'VER', RES_VER);
end;


// Общая часть для всех конструкторов
procedure TExchgRegCitizens.GenCreate;
begin
  if (NOT Assigned(FPars.Meta)) then begin
    if ( NOT FileExists(FPars.MetaName) ) then
      raise Exception.Create('Bad INI-file:' + FPars.MetaName);
    FPars.Meta := TSasaIniFile.Create(FPars.MetaName);
  end;
  ReadIni;
  Secure := TSecureExchg.Create(FPars.Meta);
end;


constructor TExchgRegCitizens.Create(Pars: TParsExchg);
begin
  inherited Create;
  FPars := Pars;
  GenCreate;
end;

// Имя INI-файла
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
  FreeAndNil(FSecure);
end;

function IsJSON(const s: string): Boolean;
var
  l: Integer;
begin
  l := Length(s);
  if (l > 2) AND (LeftStr(s, 1) = '{') AND (RightStr(s, 1) = '}') then
    Result := True
  else
    Result := False;
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

        if (FHTTP.ResultCode = 502) then begin
            sErr := FHTTP.Headers[0];
            raise Exception.Create(sErr);
        end;

        StreamDoc := TStringStream.Create('');
        try
          StreamDoc.Seek(0, soBeginning);
          StreamDoc.CopyFrom(FHTTP.Document, 0);
          if ( IsJSON(StreamDoc.DataString) = True) then begin
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
function TExchgRegCitizens.StoreINsInRes(Pars: TParsGet): integer;
var
  i: Integer;
begin
  Result := Pars.FIOrINs.Count;
  if (Pars.ListType = TLIST_FIO) then begin
    ResGet.INs.Append;
    ResGet.INs.FieldValues['IDENTIF'] := Pars.FIOrINs[0];
    ResGet.INs.Post;
    Result := 1;
  end
  else
    for i := 1 to Result do begin
      FResGet.INs.Append;
      FResGet.INs.FieldValues['IDENTIF'] := Pars.FIOrINs[i - 1];
      FResGet.INs.Post;
    end;
end;

// Перевод Num->Str для PID
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


// Индивидуальные номера граждан за период
function TExchgRegCitizens.GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
var
  Ret : Integer;
  sErr : string;
  Pars : TStringList;
  SOList : ISuperObject;
begin
  if (Length(ParsGet.FullURL) = 0) then begin
    Pars := TStringList.Create;
    Pars.Add(ParsGet.Organ);
    Pars.Add(DateToStr(ParsGet.DateBeg));
    Pars.Add(DateToStr(ParsGet.DateEnd));
    Pars.Add(IntToStr(ParsGet.First));
    Pars.Add(IntToStr(ParsGet.Count));
    ParsGet.FullURL := FullPath(FHost, GET_LIST_ID, SetPars4GetIDs(Pars));
  end;

    try
       Ret := SetRetCode(FHTTP.HTTPMethod('GET', ParsGet.FullURL), sErr);
      if (Ret = 0) then begin
        sErr := Utf8Decode(MemStream2Str(FHTTP.Document));
        SOList := SO(MakeNumAsStr('pid', sErr));
        if Assigned(SOList) and (SOList.DataType = stArray) then begin
          sErr := 'Error converting INs';
          if (TIndNomDTO.GetIndNumList(SOList, MT) = 0) then
            raise Exception.Create('Departed are absent');
        end
        else
          raise Exception.Create('No departed');
      end
      else
        raise Exception.Create(sErr);
    except
      on E: Exception do begin
        if (sErr = '') then
          sErr := E.Message;
        Ret := UERR_GET_INDNOMS;
        ResGet.ResCode := Ret;
        ResGet.ResMsg  := sErr;
      end;
    end;
    Result := Ret;
end;

function SetCert(Headers : TStringList; Cert : string) : string;
var
  CertLen,
  i : Integer;
  p : string;
begin
  Result := '';
  CertLen := Length(Cert);
  for i := 0 to Headers.Count -1 do begin
    if (Pos(Cert, Headers[i]) = 1) then begin
      p := Copy(Headers[i], CertLen + 2, Length(Headers[i]) - CertLen - 1);
      Result := DecodeBase64(p);
      Break;
    end;
  end;
  //MemoRead(Cert + '64', p);
end;


// Получить документы для текущего в списке ID
function TExchgRegCitizens.Docs4CurIN(Pars4GET: string; DocDTO: TDocSetDTO): TResultGet;
var
  Ret: Integer;
  sBody: Utf8String;
  sSign, sCert, sErr, URL: string;
  SOList: ISuperObject;
begin
  Result := TResultGet.Create(FPars, NO_DATA);
  try
    URL := FullPath(FHost, GET_LIST_DOC, Pars4GET);

    FHTTP.Headers.Clear;
    Ret := SetRetCode(FHTTP.HTTPMethod('GET', URL), sErr);
    if (Ret = 0) then begin
      sBody := MemStream2Str(FHTTP.Document);
      sCert := SetCert(FHTTP.Headers, 'certificate');
      sSign := SetCert(FHTTP.Headers, 'sign');

      if (Secure.VerifyESign(sBody, sSign, sCert, sErr) = True) then begin
        SOList := SO(Utf8Decode(sBody));
        sErr := 'Нет установочных данных!';
      // должен вернуться массив установочных документов
        if Assigned(SOList) and (SOList.DataType = stArray) then begin

          if (DocDTO.GetDocList(SOList) > 0) then begin
            Ret := 0;
            sErr := '';
          end;
        end;
      end;
    end
    else begin
      if (Ret = 502) then begin
        sErr := sErr + CRLF + 'Ошибка в параметрах: ' + URL;
      end;
    end;
  except
    on E: Exception do begin
      if (sErr = '') then
        sErr := E.Message;
      Ret := UERR_GET_DEPART;
    end;
  end;
  Result.ResCode := Ret;
  Result.ResMsg := sErr;
end;








// Список убывших для сельсовета (параметры)
function TExchgRegCitizens.GetDeparted(ParsGet: TParsGet): TResultGet;
begin
  ParsGet.NeedActual := False;
  Result := GetDSDList(ParsGet);
end;

// Список убывших для сельсовета (период-сельсовет)
function TExchgRegCitizens.GetDeparted(DBeg, DEnd: TDateTime; OrgCode: string = ''): TResultGet;
var
  P: TParsGet;
begin
  if (OrgCode = '') then
    OrgCode := FPars.Organ;
  P := TParsGet.Create(DBeg, DEnd, OrgCode);
  try
    Result := GetDeparted(P);
  finally
    P.Free;
  end;
end;

// Актуальный документ регистрации для единственного ИН
function TExchgRegCitizens.GetActualReg(INum: string): TResultGet;
var
  IndNums: TStringList;
begin
  IndNums := TStringList.Create;
  try
    IndNums.Add(INum);
    Result := GetActualReg(IndNums);
  finally
    IndNums.Free;
  end;
end;


// Получить актуальный документ регистрации для списка ИН
function TExchgRegCitizens.GetActualReg(IndNs: TStringList): TResultGet;
var
  ParsGet: TParsGet;
begin
  ParsGet := TParsGet.Create(IndNs, TLIST_INS);
  try
    Result := GetActualReg(ParsGet);
  finally
    ParsGet.Free;
  end;
end;

// Получить актуальный документ регистрации для ИН
function TExchgRegCitizens.GetActualReg(ParsGet: TParsGet) : TResultGet;
begin
  ParsGet.NeedActual := True;
  Result := GetDSDList(ParsGet);
end;

// установка параметров для GET DSD: получения документов по ID
//
// identifier=3140462K000VF6
// name=
// surname=
// patronymic=
// first=
// count=
function SetPars4GetDSD(ParsGet: TParsGet;INMT : TkbmMemTable) : string;
begin
  if (ParsGet.ListType <> TLIST_FIO) then
    Result := Format('?identifier=%s&name=%s&surname=%s&patronymic=%s&pid=%s',
      [ INMT.FieldValues['IDENTIF'], '', '', '',
        INMT.FieldValues['PID'] ])
  else
    Result := Format('?identifier=%s&name=%s&surname=%s&patronymic=%s&pid=%s',
      [ '', INMT.FieldValues['IDENTIF'],
            INMT.FieldValues['ORG_WHERE_NAME'],
            INMT.FieldValues['ORG_FROM_NAME'], '' ]);
end;


function SetErr4GetDSD(ParsGet: TParsGet; INMT: TkbmMemTable): string;
begin
  if (ParsGet.ListType <> TLIST_FIO) then
  // на входе - список ИН
    Result := Format('Инд.№=%s PID=%s - ', [INMT.FieldValues['IDENTIF'], INMT.FieldValues['PID']])
  else
  // на входе - ФИО
    Result := Format('ФИО: %s %s %s - ', [ParsGet.FIOrINs[0], ParsGet.FIOrINs[1], ParsGet.FIOrINs[2]]);
end;

// Список DSD по одному/списку ИН
// актуальные/убывшие -
function TExchgRegCitizens.GetDSDList(ParsGet: TParsGet): TResultGet;
var
  nINs: Integer;
  sErr: string;
  DocDTO: TDocSetDTO;
  ResOneIN: TResultGet;
begin
  ResGet := TResultGet.Create(FPars);
  FHTTP := THTTPSend.Create;
  try

  // Fill MemTable with IndNums
    if (ParsGet.NeedActual = True) then
    // Во входном списке - ИН
    //    или ФИО (получение актуального)
      nINs := StoreINsInRes(ParsGet)
    else begin
    // Во входном списке - пусто, надо брать с сервера, нужны уехавшие
      nINs := GetINsFromSrv(ParsGet, ResGet.INs);
      if (nINs = 0) then
        nINs := ResGet.INs.RecordCount
      else begin
        Result := ResGet;
        Exit;
      end;
    end;

    if (nINs > 0) then begin
      DocDTO := TDocSetDTO.Create(ResGet.Docs, ResGet.Child);
      try
        ResGet.ResCode := 0;
        ResGet.INs.First;
        while not ResGet.INs.Eof do begin
          ResOneIN := Docs4CurIN(SetPars4GetDSD(ParsGet, ResGet.INs), DocDTO);
          if (ResOneIN.ResCode <> 0) then begin
            sErr := SetErr4GetDSD(ParsGet, ResGet.INs);
            ResGet.ResMsg := ResGet.ResMsg + CRLF + sErr + ResOneIN.ResMsg;;
            ResGet.ResCode := ResGet.ResCode + 1;
          end;
          ResGet.INs.Next;
        end;
      finally
        DocDTO.Free;
      end;
    end;
  finally
    FHTTP.Free;
  end;
  Result := ResGet;
end;

// Полученный справочник - в ADS
function TExchgRegCitizens.CreateADST(MT: TkbmMemTable; TType: integer; Conn: TAdsConnection; ResGet: TResultGet): Integer;
var
  Ret, i, MaxF, n: Integer;
  CurName, sErr, StrucInStr, TName, FName, sSQL: string;
  t: TAdsTable;
begin
  sErr := '';
  TName := Format('ROC%d', [TType]);
  FName := Conn.ConnectPath + TName;
  t := TAdsTable.Create(Conn.Owner);
  try
    try
      CurName := SafeNewNsi(Conn.ConnectPath, TName);
      sSQL := ADSTCreateOnDefs(CurName, MT.FieldDefs, StrucInStr);
      Conn.IsConnected := True;
      t.TableName := CurName;
      t.AdsConnection := Conn;
      Conn.Execute(sSQL);
      // Вариант без SQL
      //t.AdsCreateTable(FName, ttAdsADT, ANSI, 0, StrucInStr);
      t.Active := True;

      MaxF := MT.Fields.Count;
      with MT do begin
        First;
        while not Eof do begin
          t.Append;
          for i := 0 to MaxF - 1 do
            t.Fields[i].Value := Fields[i].Value;
          t.Post;
          Next;
        end;
      end;
      t.Active := False;
      Conn.IsConnected := False;
      SafeNewNsi(Conn.ConnectPath, TName, CurName);
      Ret := 0;
    except
      on E: Exception do begin
        if (sErr = '') then
          sErr := E.Message;
        Ret := UERR_CVRT_NSI;
      end;
    end;
  finally
    t.Free;
  end;
  Result := Ret;
  ResGet.ResCode := Ret;
  ResGet.ResMsg := sErr;
end;

// Получить содержимое справочника
function TExchgRegCitizens.GetNSI(ParsNsi : TParsNsi) : TResultGet;
var
  Ret: Integer;
  SOList: ISuperObject;
  URL,
  sType, sCode, sErr: string;
begin
  Result := TResultGet.Create(FPars, NSI_ONLY);
  if (ParsNsi.FullURL = '') then begin
    if (ParsNsi.NsiCode = 0) then
      sCode := ''
    else
      sCode := IntToStr(ParsNsi.NsiCode);
    sType := IntToStr(ParsNsi.NsiType);
    URL := FullPath(FHost, GET_NSI, Format('/type/%s?code=%s&active=true&first&count', [sType, sCode]));
  end
  else
    URL := ParsNsi.FullURL;

  FHTTP := THTTPSend.Create;
  try
    try
      Ret := SetRetCode(FHTTP.HTTPMethod('GET', URL), sErr);
      if (Ret = 0) then begin
        sErr := MemStream2Str(FHTTP.Document);
        SOList := SO(Utf8Decode(sErr));
        sErr := 'No DATA in HTTP-Document';
        if Assigned(SOList) and (SOList.DataType = stArray) then begin
          if (TDocSetDTO.GetNSI(SOList, Result.Nsi) > 0) then begin
            Ret := 0;
            sErr := '';
            if ((ParsNsi.ADSCopy = True) and (Result.Nsi.RecordCount > 0)) then begin

              CreateADST(Result.Nsi, ParsNsi.NsiType, ParsNsi.ConnADS, Result);
              Exit;

            end;
          end;
        end;
      end;
    except
      on E: Exception do begin
        if (sErr = '') then
          sErr := E.Message;
        Ret := UERR_GET_NSI;
      end;
    end;
  finally
    FHTTP.Free;
  end;
  Result.ResCode := Ret;
  Result.ResMsg := sErr;
  ResGet := Result;
end;


// Передача одного документа
function TExchgRegCitizens.Post1Doc(ParsPost: TParsPost; StreamDoc: TStringStream): TResultPost;
var
  Ret: Integer;
  sUTF: UTF8String;
  s,
  sErr: string;
  Header: TStringList;
  LStrings: TStringList;
  DocDTO: TDocSetDTO;
  BRet : Boolean;
begin
  sErr := '';
  Result := TResultPost.Create;

  try
    if (ParsPost.JSONSrc = '') then begin
      DocDTO := TDocSetDTO.Create(ParsPost.Docs, ParsPost.Child);
      StreamDoc.Seek(0, soBeginning);
      if (DocDTO.MemDoc2JSON(ParsPost.Docs, ParsPost.Child, StreamDoc, False) = True) then begin
        //FHTTP.Document.CopyFrom(StreamDoc, 0);
        sUTF := StreamDoc.DataString;
      end
      else begin
        sErr := 'Error creating POST card';
        raise Exception.Create(sErr);
      end;
    end
    else begin
      {
      FHTTP.Document.LoadFromFile(ParsPost.JSONSrc);
      LStrings := TStringList.Create;
      try
        LStrings.Loadfromfile(ParsPost.JSONSrc);
        sUTF := LStrings.Text;
      finally
        FreeAndNil(LStrings);
      end;
      }
      MemoRead(ParsPost.JSONSrc, AnsiString(sUTF));
    end;

    if (Secure.CreateESign(sUTF, Secure.SignMode, sErr) = True) then begin
      FHTTP.Headers.Clear;
      //FHTTP.Headers.Add('sign:');
      FHTTP.Headers.Add('sign:' + Secure.Sign);
      FHTTP.Headers.Add('certificate:' + Secure.Certif);
      FHTTP.MimeType := 'application/json;charset=UTF-8';

      s := SetCert(FHTTP.Headers, 'sign');

      StreamDoc.Seek(0, soBeginning);
      StreamDoc.WriteString(sUTF);
      FHTTP.Document.CopyFrom(StreamDoc, 0);

      BRet := Secure.VerifyESign(sUTF, Secure.SignRaw, DecodeBase64(Secure.Certif), sErr);
      //BRet := Secure.VerifyESign(sUTF, Secure.Sign, Secure.Certif, sErr);

      Ret := SetRetCode(FHTTP.HTTPMethod('POST', ParsPost.FullURL), sErr);

    end
    else
      raise Exception.Create(sErr);

  except
    on E: Exception do begin
      if (sErr = '') then
        sErr := E.Message;
      Ret := UERR_POST_REG;
    end;
  end;
  Result.ResCode := Ret;
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
  ResPost := Result;
end;


end.
