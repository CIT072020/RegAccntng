unit uAvest;

interface

uses
  Windows, Classes, SysUtils, Dialogs,
  AvCryptMail, EncdDecd, DateUtils,
  QStrings, FuncPr;

const
  CHECK_CERT_DEFAULT=0;
  CHECK_CERT_NOT=1;
  CHECK_CERT_DATE=2;

  NAME_AVEST_DLL='AvCryptMail.dll';

  csCertOrgName = '2.5.4.10';
  csCertFirstName = '2.5.4.41';
  csCertLastName = '2.5.4.4';
  csCertPublicKey = '2.5.29.14';
  csCertEMAIL = '1.2.840.113549.1.9.1';

type

  TWriteTextToLog = procedure(strText : String) of object;

  TAvest=class(TObject)
  private
    FOnWriteLog:TWriteTextToLog;
    FDebug: Boolean;
    FPassword:ANSIString;
    FPublicKey:ANSIString;
    FIgnoreCOC:Boolean;
    PAR_IgnoreCOC:Integer;
    function ActivateSession(var hSession : AvCmHc; lAuth:Boolean) : DWORD;
    function DeactivateSession(var hSession : AvCmHc) : DWORD;
    procedure SetOnWriteLog(const Value: TWriteTextToLog);
    procedure SetDebug(const Value: Boolean);
  public
    DateLastSign:TDateTime;
    DateCertEnd:TDateTime;
    DateCertBegin:TDateTime;
    hDefSession: AvCmHc;
    FBase64:Boolean;
    FDeleteCRLF:Boolean;
    slAtr:TStringList;
    slSignInfo:TStringList;
    slError:TStringList;
    slLogLoad:TStringList;
    Version:String;
    property IgnoreCOC : Boolean read FIgnoreCOC;
    property Password : AnsiString read FPassword;
    property PublicKey : AnsiString read FPublicKey;
    property OnWriteLog : TWriteTextToLog read FOnWriteLog write SetOnWriteLog;
    property Debug : Boolean read FDebug write SetDebug;

    procedure SetIgnoreCOC(const Value:Boolean);
    function LoadDLL(sNameDLL:String; var sError:String):Boolean;
    function PathDLL:String;
    function IsActive:Boolean;
    function SignTextSimple(var sText : ANSIString; var sSign:ANSIString; var sKey:String; lOpenDefSession:Boolean; sAlg:String=''):DWORD;
    function VerifyTextSimple(sText : ANSIString; sSign:ANSIString; sCert:String; lOpenDefSession:Boolean; sAlg:String):DWORD;

    function SignText(var sText : ANSIString; var sSign:ANSIString; var sKey:String; lOpenDefSession:Boolean; nType:Integer; lBase64:Boolean):DWORD;
    function VerifyText(var sText : ANSIString; sSign:ANSIString):DWORD;

    function GetCert(hSession: AvCmHc; var sCert: ANSIString):DWORD;
    function GetPublicKey(hSession: AvCmHc; var sPublicKey: ANSIString):DWORD;
    function ChoicePublicKey(var sPublicKey:String; var sOpis:String) : DWORD;
    function GetOpisCert(hCert:AvCmHcert; sParam:String; var sOpis:String) : DWORD;
    function ChoiceCertAsString(var sCert:AnsiString; var sOpis:String) : DWORD;

    function GetAllAttrCert(hSession: AvCmHc; sl:TStringList):DWORD;

    function SMDOVerify(var sFile:AnsiString; slSign:TStringList; lNameFile:Boolean; nCheckCert:Integer):DWORD;
    function SMDOSign(slFiles:TStringList; slSign:TStringList; sPath:String=''):DWORD;
    function SMDOSignFile(sFile:String; var sSign:String):DWORD;
    function SMDOGetCOC(sPath: String): DWORD;
    function SMDORefreshCOC(sPath: String): DWORD;

    function SMDORefreshCOC2(sPath: String; var sErr:String; lAllSoob:Boolean; lShow:Boolean): DWORD;
    function RefreshCOC(sURL:String; lAllSoob:Boolean; var sErr:String; lShow:Boolean):Integer;

    function IsRefreshError(n:DWORD):Boolean;

    function EncodeStringEx(s:ANSIString):ANSIString;

    function GetAllAttrSign(sNameFile:String; sSign:String; var slOut:TStringList):Boolean;
//    function GetAttrSign(sName:String):String;
    function GetAttrSign(n:Integer; sName:String):String;

    procedure CreateStdAtr;
    procedure CheckMsg(Res: AvCmResult; lRaise:Boolean=false);
    function FullErrorInfo(Err: AvCmResult; lCRLF:Boolean=false): AnsiString;
    function ErrorInfo(Err: AvCmResult): AnsiString;
    function InitSession(lAuth:Boolean):DWORD;
    function LoginWithParams(sPassword:AnsiString; sPublicKey:AnsiString):DWORD;
    procedure SetLoginParams(sPassword:AnsiString; sPublicKey:AnsiString);

    function CloseSession:DWORD;


    //-------------------------------------------
    procedure CreateForAll;
    constructor Create(sNameDLL: String; var sError:String); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  Avest:TAvest;

implementation

uses StrUtils;

const
   not_load_etsp='Библиотека для работы с ЭЦП не загружена';

//-----------------------------------------------------
procedure DelChars(var S: string; const CharsToRemove: string);
begin
  Q_DelChars(S,CharsToRemove);
end;
//-----------------------------------------------------
Function FileToStr(aFile: String): AnsiString;
var
    FileRead: TFileStream;
Begin
  FileRead := TFileStream.Create(aFile, fmOpenRead or fmShareDenyNone);
  SetLength(Result, FileRead.Size);
  FileRead.ReadBuffer(Result[1], FileRead.Size);
  FileRead.Free;
End;
//-----------------------------------------------------
Function StrToFile(aFile: String; Const Str: AnsiString): boolean;
var
   hFile :THANDLE;
   dwWriten: DWORD;
//   FileStream: TFileStream;
Begin
  Result := False;
  hFile := CreateFile(PChar(aFile), GENERIC_WRITE, 0, Nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (hFile = INVALID_HANDLE_VALUE) then
     Exit;

  if not WriteFile(hFile, Str[1], Length(Str), dwWriten, Nil) Then
     Exit;
  CloseHandle(hFile);
  result := True;
End;

//-------------------------------------------------------
//-------------------------------------------------------
procedure TAvest.CreateForAll;
begin
  hDefSession:=nil;
  slError:=TStringList.Create;
  slLogLoad:=TStringList.Create;
  slAtr:=TStringList.Create;
  CreateStdAtr;
  slSignInfo:=TStringList.Create;
  FBase64:=true;
  FDeleteCRLF:=false;
  FOnWriteLog:=nil;
  FDebug:=false;
  FPassword:='';
  FPublicKey:='';
  FIgnoreCOC:=false;
  PAR_IgnoreCOC:=0;
end;
//---------------------------------------------------
constructor TAvest.Create;
begin
  inherited Create;
  CreateForAll;
end;
//---------------------------------------------------
constructor TAvest.Create(sNameDLL: String; var sError:String);
begin
  sError:='';
  inherited Create;
  CreateForAll;
  LoadDLL(sNameDLL, sError);
end;
//-----------------------------------------------------------------
function TAvest.LoadDLL(sNameDLL:String; var sError:String):Boolean;
begin
  sError:='';
  Version:='';
  slLogLoad.Clear;
  LoadAvCryptMailDLL(sNameDLL, slLogLoad);
  Result:=DLLLoaded;
  if Result then begin
    if sNameDLL=''
      then sNameDLL:=NAME_AVEST_DLL; //'AvCryptMail.dll';
    Version:=FileVersion(sNameDLL);
  end else begin
    sError:=DLLLastError;
  end;
end;
//-----------------------------------------------------------------
function TAvest.IsActive:Boolean;
begin
  Result:=DLLLoaded;
end;
//-----------------------------------------------------------------
destructor TAvest.Destroy;
begin
  if hDefSession<>nil
    then CloseSession;
  if DLLLoaded                  
    then FreeAvCryptMailDLL;       
  slError.Free;
  slLogLoad.Free;
  slAtr.Free;
  slSignInfo.Free;
  inherited;
end;
//-------------------------------------------------------------
function TAvest.FullErrorInfo(Err: AvCmResult; lCRLF:Boolean): AnsiString;
var
  delim: AnsiString;
  i:Integer;
Begin
  if slError.Count=0 then begin
    Result:=ErrorInfo(Err);
  end else begin
    Result:='';
    if lCRLF
      then delim:=#13#10
      else delim:=', ';
    for i:=0 to slError.Count-1 do begin
      Result:=Result+slError.Strings[i]+delim;
    end;
    if Result<>'' then Result:=Copy(Result,1,Length(Result)-2);
  end;
End;
//-------------------------------------------------------------
function TAvest.ErrorInfo(Err: AvCmResult): AnsiString;
var
  S: AnsiString;
  W: DWORD;
Begin
  if Err<>AVCMR_SUCCESS then begin
    AvCmGetErrorInfo(nil, err, AVCM_SHORT_STRING, Nil, W, 0);
    SetLength(S, W);
    AvCmGetErrorInfo(nil, err, AVCM_SHORT_STRING, @S[1], W, 0);
    if Copy(s,w,1)=#0
      then Result:=Copy(s,1,w-1)
      else Result:=s;
  end else begin
    Result := '';
  end;
End;
//--------------------------------------------------------------
procedure TAvest.CheckMsg(Res: AvCmResult; lRaise:Boolean);
var
  S: AnsiString;
//  W: DWORD;
begin
  if Res <> AVCMR_SUCCESS then begin
    S := ErrorInfo(Res);
    slError.Add(S);
    if lRaise then begin
      raise Exception.Create('Ошибка. ' + S);
    end;
  end
end;
//-------------------------------------------------------
function TAvest.PathDLL:String;
begin
  Result:=AvCryptMailDLLPath;
end;
//-------------------------------------------------------
procedure TAvest.CreateStdAtr;
begin
  slAtr.Clear;
  slAtr.Add('signdate=');    // дата и время подписания
  slAtr.Add('certdate_begin=');    //
  slAtr.Add('certdate_end=');    //
  slAtr.Add('2.5.4.10=');    // полное название организации ???
  slAtr.Add('2.5.4.4=');     // фамилия
  slAtr.Add('2.5.4.41=');    // имя отчество
  slAtr.Add('2.5.4.3=');     // название организации
  slAtr.Add('2.5.4.9=');     // улица, дом
  slAtr.Add('2.5.4.7=');     // нас. пункт
//  slAtr.Add('2.5.4.11=');     // Подразделение
//  slAtr.Add('2.5.4.12=');     // Должность
  slAtr.Add('*1.2.112.1.2.1.1.5.1=');     // Должность
  slAtr.Add('*1.2.112.1.2.1.1.1.1.1=');     // ИН
//  slAtr.Add('1.2.112.1.2.1.1.1.1.2=');     // УНП

//  slAtr.Add('2.5.4.8=');     // область
//  slAtr.Add('1.2.840.113549.1.9.1=');     // email
{
2.5.29.14=Идентификатор открытого ключа
1.2.112.1.2.1.1.1.1.1=Личный номер
1.2.112.1.2.1.1.1.1.2=УНП
1.2.112.1.2.1.1.5.1=Начальник отдела програмирования
2.5.4.9=пр-т Машерова, д.18
2.5.4.3=Республиканское унитарное предприятие "Центр информационных технологий Национального статистического комитета Республики Беларусь"
2.5.4.4=Мороз
1.2.840.113549.1.9.1=vc_bous@brest.by
2.5.4.6=BY
2.5.4.10=Республиканское унитарное предприятие "Центр информационных технологий Национального статистического комитета Республики Беларусь"
2.5.4.41=Виктор Анастасьевич
2.5.4.7=г.Брест
}
end;
//-------------------------------------------------------
function TAvest.GetAttrSign(n:Integer; sName:String):String;
var
  i:Integer;
  s,ss,sInd:String;
begin
  Result:='';
  if n<=0 then n:=0;
  sInd:=IntToStr(n)+'#';
  sName:=ANSIUpperCase(sName);
  if sName='ORG' then begin
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.3');   // 2.5.4.10
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if sName='ADRES' then begin
    s:='';
    ss:='';
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.7');
    if i>-1 then s:=slSignInfo.ValueFromIndex[i];
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.9');
    if i>-1 then ss:=slSignInfo.ValueFromIndex[i];
    if s='' then Result:=ss else if ss='' then Result:=s else Result:=s+', '+ss;
    Result:=Trim(s+' '+ss);
  end else if sName='FIO' then begin
    s:='';
    ss:='';
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.4');
    if i>-1 then s:=slSignInfo.ValueFromIndex[i];
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.41');
    if i>-1 then ss:=slSignInfo.ValueFromIndex[i];
    Result:=Trim(s+' '+ss);
  end else if sName='DOLG' then begin
    i:=slSignInfo.IndexOfName(sInd+'1.2.112.1.2.1.1.5.1');   // Должность
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if sName='IN' then begin
    i:=slSignInfo.IndexOfName(sInd+'1.2.112.1.2.1.1.1.1.1');   // ИН
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if sName='PODR' then begin  // Подразделение
    i:=slSignInfo.IndexOfName(sInd+'2.5.4.11');   //
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if Copy(sName,1,5)='SIGND' then begin   // signdate
    i:=slSignInfo.IndexOfName(sInd+'signdate');
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if Copy(sName,1,3)='ERR' then begin   // error
    i:=slSignInfo.IndexOfName(sInd+'error');
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else if Copy(sName,1,6)='CODE_E' then begin   // code_error
    i:=slSignInfo.IndexOfName(sInd+'code_error');
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end else begin   //  иначе цифровой код   (например "1.2.840.113549.1.9.1" email)
    i:=slSignInfo.IndexOfName(sInd+sName);
    if i>-1 then Result:=slSignInfo.ValueFromIndex[i];
  end;
end;
//-------------------------------------------------------
// вывод всех атрибутов сертификата (основные + расширенные)
function TAvest.GetAllAttrCert(hSession: AvCmHc; sl:TStringList):DWORD;
var
  w, res, main_res: DWORD;
  hCert:AvCmHcert;
  sOID,s1,sss:String;
  nCount,n:DWORD;
  MyCertPubKeyId:String;
begin
  W := SizeOf(hcert);
  main_res:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hCert, W, 0); // Получаем личный сертификат
  if main_res=0 then begin
    sl.Clear;
    res:=AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, nil, nil, W, 0);
    if res=AVCMR_SUCCESS then begin
      SetLength(MyCertPubKeyId, W);
      res:=AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, nil, @MyCertPubKeyId[1], W, 0);
      if res=AVCMR_SUCCESS
        then sl.Add('PUB_KEY_ID='+MyCertPubKeyId);
    end;
    if res<>AVCMR_SUCCESS
      then sl.Add('PUB_KEY_ID='+ErrorInfo(res));

    W:=SizeOf(nCount);
    res:=AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR_COUNT, nil, @nCount, W, 0);
    if res=AVCMR_SUCCESS then begin
      for n:=0 to nCount-1 do begin
        setlength(sOID,100);
        w:=100;
        Res:=AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR_OID, @n, @sOID[1], W, 0);
        if res=0 then begin
          sOID:=Copy(sOID,1,w-1);
          res:=AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(sOID), Nil, W, AVCMF_ATTR_BY_OID);
          SetLength(s1, W - 1);
          res:=AvCmGetCertAttr(HCert, AVCM_SUBJECT_ATTR, PAnsiChar(sOID),  @s1[1], W, AVCMF_ATTR_BY_OID);
          if res=0 then
            sl.Add(sOID+'='+s1);
        end;
      end;
    end;
    W:=SizeOf(nCount);
    res:=AvCmGetCertAttr(hCert, AVCM_EXT_COUNT, nil, @nCount, W, 0);
    if res=AVCMR_SUCCESS then begin
      for n:=0 to nCount-1 do begin
        setlength(sOID,100);
        w:=100;
        Res:=AvCmGetCertAttr(hCert, AVCM_EXT_OID, @n, @sOID[1], W, 0);
        if res=0 then begin
          sOID:=Copy(sOID,1,w-1);
          res:=AvCmGetCertAttr(hCert, AVCM_EXT_AS_STRING, PAnsiChar(sOID), Nil, W, AVCMF_ATTR_BY_OID);
          SetLength(s1, W - 1);
          res:=AvCmGetCertAttr(HCert, AVCM_EXT_AS_STRING, PAnsiChar(sOID),  @s1[1], W, AVCMF_ATTR_BY_OID);
          if res=0 then
            sl.Add(sOID+'='+s1);
        end;
      end;
    end;
  end;
  Result:=main_res;
end;
//--------------------------------------------------------
procedure TAvest.SetLoginParams(sPassword:AnsiString; sPublicKey:AnsiString);
begin
  if sPassword<>'not_change!'
    then FPassword:=sPassword;
  if sPubLicKey<>'not_change!'
    then FPublicKey:=sPubLicKey;
end;
//--------------------------------------------------------
//
function TAvest.LoginWithParams(sPassword:AnsiString; sPublicKey:AnsiString):DWORD;
var
  n:Integer;
  ArrParams: array of AvCmConnectionParam;
begin
  if (sPassword<>'') or (sPublicKey<>'') then begin
//  FPassword:=edPsw.Text;        // '28vadim5';
//  FCertPubKeyID:=edPubKey.Text; // ' 55531A211A734059B27A10304398FE9958F67F29';
//  hSession:=nil;
    if sPassword='' then begin
      SetLength(ArrParams, 1);
      ArrParams[0].param_id:=AVCM_PUB_KEY_ID;
      ArrParams[0].param:=Pointer(sPublicKey);
      n:=1;
    end else if sPublicKey='' then begin
      SetLength(ArrParams, 1);
      ArrParams[0].param_id := AVCM_PASSWORD;
      ArrParams[0].param := Pointer(sPassword);
      n:=1;
    end else begin
      SetLength(ArrParams, 2);
      ArrParams[0].param_id := AVCM_PASSWORD;
      ArrParams[0].param := Pointer(sPassword);
      ArrParams[1].param_id := AVCM_PUB_KEY_ID;
      ArrParams[1].param := Pointer(sPublicKey);
      n:=2;
    end;
    Result:=AvCmLogin(n, Pointer(ArrParams), hDefSession, 0+PAR_IgnoreCOC);
  end else begin
    Result:=AvCmLogin(0, Nil, hDefSession, 0+PAR_IgnoreCOC);
  end;
end;
//-------------------------------------------------------
function TAvest.InitSession(lAuth:Boolean):DWORD;
var
  res: DWORD;
begin
  res:=0;
  // инициализация
  if hDefSession=nil then begin
    res:=AvCmInit(AVCMF_STARTUP);
    if res=AVCMR_SUCCESS then begin
      if lAuth then begin
//        res:=AvCmLogin(0, Nil, hDefSession, 0);
        res:=LoginWithParams(FPassword,FPublicKey);  // AVCMF_FORCE_TOKEN_CONTROL - контроль наличия вставленного носителя с личным ключом
      end else begin
        // открытие сессии без атентификации пользователя
        res:=AvCmLogin(0, Nil, hDefSession, AVCMF_NO_AUTH+PAR_IgnoreCOC); //  or AVCMF_IGNORE_CRL_ABSENCE–игнорировать отсутствие СОС. ???
      end;
      if res<>AVCMR_SUCCESS then begin
        AvCmInit(AVCMF_SHUTDOWN);   // загасим сессию
        hDefSession:=nil;
      end;
    end;
  end;
  Result:=res;
end;
//-------------------------------------------------------
function TAvest.CloseSession: DWORD;
var
  res: DWORD;
begin                       
  res:=0;
  if hDefSession<>nil then begin
    res:=AvCmLogout(hDefSession, 0+PAR_IgnoreCOC);
    if res=AVCMR_SUCCESS
      then res:=AvCmInit(AVCMF_SHUTDOWN)
      else AvCmInit(AVCMF_SHUTDOWN);
    hDefSession:=nil;
  end;
  Result:=res;
end;
//-------------------------------------------------------
function TAvest.ActivateSession(var hSession : AvCmHc; lAuth:Boolean) : DWORD;
var
  res:DWORD;   
begin
  if hDefSession=nil then begin
    // инициализация
    res:=AvCmInit(AVCMF_STARTUP);
    CheckMsg(res);
    if res=AVCMR_SUCCESS then begin
      if lAuth
        then res:=AvCmLogin(0, Nil, hSession, 0+PAR_IgnoreCOC)
        else res:=AvCmLogin(0, Nil, hSession, AVCMF_NO_AUTH+PAR_IgnoreCOC);  // открытие сессии без аутентификации пользователя
      CheckMsg(res);
      if res<>AVCMR_SUCCESS then begin
        AvCmInit(AVCMF_SHUTDOWN);   // загасим сессию
      end;
    end;
  end else begin
    res:=AVCMR_SUCCESS;
    hSession:=hDefSession;
  end;
  Result:=res;
end;
//-------------------------------------------------------
function TAvest.DeactivateSession(var hSession : AvCmHc) : DWORD;
begin
  Result:=0;
  if hDefSession=nil then begin
    AvCmLogout(hSession, 0);
    Result:=AvCmInit(AVCMF_SHUTDOWN);
  end;
end;
//-------------------------------------------------------
function TAvest.EncodeStringEx(s:ANSIString):ANSIString;
begin
  Result:=EncodeString(s);
  if FDeleteCRLF
    then Q_DelChars(Result,chr(13)+chr(10));
end;
//-------------------------------------------------------
function TAvest.SignTextSimple(var sText : ANSIString; var sSign:ANSIString; var sKey: String; lOpenDefSession:Boolean; sAlg:String):DWORD;
var
  hSession: AvCmHc;
  hMsg: AvCmHmsg;
  w, res: DWORD;
  lOpen:Boolean;
//  arrCh:array of char;
begin
  slError.Clear;
  hSession:=nil;
  lOpen:=false;
  if lOpenDefSession then begin
    res:=InitSession(true);   // если сессия не открыта, то откроем, но закрывать не будем !!!
    if res=AVCMR_SUCCESS
      then hSession:=hDefSession;
  end else begin
    res:=ActivateSession(hSession,true);
  end;

  if res=AVCMR_SUCCESS then begin
    lOpen:=true;
//   AvCmResult AvCmSignRawData( AvCmHc hc, const char* hash_and_sign_oid, const void* data, size_t data_size, void * output_buffer, size_t * output_size, DWORD flags);
    W:=1024;
    SetLength(sSign, W);
    // AVCMF_RAW_SIGN - вернуть подпись без ASN.1 кодирования
//    sAlg:='1.2.112.0.2.0.34.101.45.12'; 1.2.112.0.2.0.34.101.45.12
    res:=AvCmSignRawData(hSession, nil, @sText[1], Length(sText),  @sSign[1], W, AVCMF_RAW_SIGN);
//    res:=AvCmSignRawData(hSession, nil, @sText[1], Length(sText),  @sSign[1], W, 0);
    sSign:=Copy(sSign,1,W);
//    memowrite('sign_',sSign);
//    sSign:=EncodeStringEx(sSign);  // в BASE64
    if (res=0) and (sKey='+') then begin
      sKey:='';
      res:=Avest.GetCert(hSession, sKey);
    end;
  end;
//   !!! CloseSession;   не закрываем
  Result:=res;
  if not lOpenDefSession then begin
    if lOpen
      then DeactivateSession(hSession);
  end;
end;
//-------------------------------------------------------
function TAvest.VerifyTextSimple(sText : ANSIString; sSign:ANSIString; sCert:String; lOpenDefSession:Boolean; sAlg:String):DWORD;
var
  hSession: AvCmHc;
  w, res: DWORD;
  lOpen:Boolean;
  hMycert:AvCmHcert;
//  arrCh:array of char;
begin
  slError.Clear;
  hSession:=nil;
  lOpen:=false;
  if lOpenDefSession then begin
    res:=InitSession(true);   // если сессия не открыта, то откроем, но закрывать не будем !!!
    if res=AVCMR_SUCCESS
      then hSession:=hDefSession;
  end else begin
    res:=ActivateSession(hSession,true);
  end;
  if res=AVCMR_SUCCESS then begin
    lOpen:=true;
    // AVCMF_RAW_SIGN - вернуть подпись без ASN.1 кодирования
//    res:=AvCmVerifyRawDataSign( AvCmHcert hcert, const char* hash_and_sign_oid, const void* data_to_be_verified, size_t data_size, const void * sign_value, size_t sign_size, DWORD flags);
    if sCert='' then begin
      W:=SizeOf(hMycert);
      res:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hMycert, W, 0);
    end else begin
//    AvCmResult AvCmOpenCert( AvCmHc hc,void* input_data, size_t input_size, AvCmHcert * hcert, DWORD flags);
      res:=AvCmOpenCert(hSession, @sCert[1], Length(sCert), hMycert, 0);
    end;
    if res=0 then begin
      res:=AvCmVerifyRawDataSign(hMycert, nil, @sText[1], Length(sText),  @sSign[1], Length(sSign), AVCMF_RAW_SIGN);
    end;
//    memowrite('sign_',sSign);
//    sSign:=EncodeStringEx(sSign);  // в BASE64
  end;
//   !!! CloseSession;   не закрываем
  Result:=res;
  if not lOpenDefSession then begin
    if lOpen
      then DeactivateSession(hSession);
  end;
end;

//-------------------------------------------------------
function TAvest.SignText(var sText : ANSIString; var sSign:ANSIString; var sKey:String; lOpenDefSession:Boolean; nType:Integer; lBase64:Boolean):DWORD;
var
  hSession: AvCmHc;
  hMsg: AvCmHmsg;
  w, res: DWORD;
  lOpen,lErr:Boolean;
begin
  lErr:=false;
  slError.Clear;
  hSession:=nil;
  lOpen:=false;
  if lOpenDefSession then begin
    res:=InitSession(true);   // если сессия не открыта, то откроем, но закрывать не будем !!!
    if res=AVCMR_SUCCESS
      then hSession:=hDefSession;
  end else begin
    res:=ActivateSession(hSession,true);
  end;
  if res=AVCMR_SUCCESS then begin
    lOpen:=true;
    res:=AvCmOpenMsg(hSession, @sText[1], Length(sText), hMsg, AVCMF_IN_RAW_DATA);
    if res=AVCMR_SUCCESS then begin
      // Содержимое сообщения включается в экспортируемое сообщение
      // В выходное сообщение будет включен только сертификат подписавшего.
      if (nType<0) or (nType>3)
        then nType:=1;
      case nType of
        0 : res:=AvCmMsgSign(hMsg, 0);
        1 : res:=AvCmMsgSign(hMsg, AVCMF_ADD_SIGN_CERT);
        2 : res:=AvCmMsgSign(hMsg, AVCMF_DETACHED+AVCMF_ADD_SIGN_CERT);
        3 : res:=AvCmMsgSign(hMsg, AVCMF_DETACHED);
      end;

      if res=AVCMR_SUCCESS then begin
        AvCmGetMsg(hMsg, Nil, W, 0);
        SetLength(sSign, W);
        AvCmGetMsg(hmsg, @sSign[1], W, 0);
        if lBase64
          then sSign:=EncodeStringEx(sSign);  // в BASE64
      end;
      AvCmCloseHandle(hMsg, 0);
    end;
    if res<>AVCMR_SUCCESS then begin
      lErr:=true; // в случае ошибки закроем сессию по-любому  !!!
    end;
    if (res=0) and (sKey='+') then begin
      sKey:='';
      res:=Avest.GetCert(hSession, sKey);
      if lBase64
        then sKey:=EncodeStringEx(sKey);  // в BASE64
    end;
//   !!! CloseSession;   не закрываем
  end;
  Result:=res;
  if not lOpenDefSession or lErr then begin
    if lOpen
      then DeactivateSession(hSession);
  end;
end;
//-------------------------------------------------------
function TAvest.VerifyText(var sText : ANSIString; sSign:ANSIString):DWORD;
var
  hSession: AvCmHc;
  hMsg: AvCmHmsg;
  w, res: DWORD;
  hMycert:AvCmHcert;
begin
  slError.Clear;
  res:=InitSession(true);   // если сессия не открыта, то откроем, но закрывать не будем !!!
  if res=AVCMR_SUCCESS then begin
    hSession:=hDefSession;
    // Получаем личный сертификат
    W := SizeOf(hMycert);
    res:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hMycert, W, 0);
    if res=0 then begin
//   AvCmResult AvCmVerifyRawDataSign( AvCmHcert hcert, const char* hash_and_sign_oid, const void* data_to_be_verified, size_t data_size, const void * sign_value, size_t sign_size, DWORD flags);    res:=AvCmSignRawData(hSession, 0, @sText[1], Length(sText),  @sSign[1], W, AVCMF_RAW_SIGN);
      res:=AvCmVerifyRawDataSign(hMycert, nil, @sText[1], Length(sText),  @sSign[1], Length(sSign), AVCMF_RAW_SIGN);
    end;
//   !!! CloseSession;   не закрываем
  end;
  Result:=res;
end;
//-------------------------------------------------------
function TAvest.GetCert(hSession: AvCmHc; var sCert: ANSIString):DWORD;
var
  w, res: DWORD;
  hCert:AvCmHcert;
begin
  W := SizeOf(hcert);
  res:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hCert, W, 0);  // Получаем личный сертификат
  if res=0 then begin
    W:=0;
    AvCmGetCertAttr(hCert, AVCM_BLOB, Nil, Nil, W, 0);
    SetLength(sCert, W);
    res:=AvCmGetCertAttr(hCert, AVCM_BLOB, Nil, @sCert[1], W, 0);
  end;
  Result:=res;
end;
//-------------------------------------------------------
function TAvest.GetPublicKey(hSession: AvCmHc; var sPublicKey: ANSIString):DWORD;
var
  w, res: DWORD;
  hCert:AvCmHcert;
begin
  W := SizeOf(hcert);
  res:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hCert, W, 0);  // Получаем личный сертификат
  if res=0 then begin
    W:=0;
    AvCmGetCertAttr(hCert, AVCM_PUB_KEY, Nil, Nil, W, 0);
    SetLength(sPublicKey, W-1);
    res:=AvCmGetCertAttr(hCert, AVCM_PUB_KEY, Nil, @sPublicKey[1], W, 0);   // AVCM_PUB_KEY – открытый ключ сертификата
  end;
  Result:=res;
end;
//--------------------------------------------
function TAvest.GetOpisCert(hCert:AvCmHcert; sParam:String; var sOpis:String) : DWORD;
var
  W:DWORD;
  S:AnsiString;
  st:TSystemTime;
begin
  Result:=0;
  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertLastName), nil, W, AVCMF_ATTR_BY_OID);
  SetLength(S, W - 1);
  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertLastName), @S[1], W, AVCMF_ATTR_BY_OID);
  sOpis:=S+' ';

  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertFirstName), nil, W, AVCMF_ATTR_BY_OID);
  SetLength(S, W - 1);
  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertFirstName), @S[1], W, AVCMF_ATTR_BY_OID);
  sOpis:=sOpis+S+', ';

  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertOrgName), nil, W, AVCMF_ATTR_BY_OID);
  SetLength(S, W - 1);
  AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertOrgName), @S[1], W, AVCMF_ATTR_BY_OID);
  sOpis:=sOpis+S+', ';

  // certdate_begin
  W:=SizeOf(st);
  AvCmGetCertAttr(hCert, AVCM_NOT_BEFORE , nil, @st, W, 0);
  S:=FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(st));
  sOpis:=sOpis+' с '+S+' до ';
  // certdate_end
  W:=SizeOf(st);
  Result:=AvCmGetCertAttr(hCert, AVCM_NOT_AFTER , nil, @st, W, 0);
  S:=FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(st));
  sOpis:=sOpis+S;
end;
//--------------------------------------------
function TAvest.ChoicePublicKey(var sPublicKey:String; var sOpis:String) : DWORD;
var
  hSession:AvCmHc;
  hCert:AvCmHcert;
  W:DWORD;
  S,SS,keyID:AnsiString;
  st:TSystemTime;
begin
  if hDefSession<>nil
    then CloseSession;
  Result:=InitSession(true);
  if (Result=AVCMR_SUCCESS) then begin
    hSession:=hDefSession; // !!!
    W:=SizeOf(hCert);
    Result:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hCert, W, 0);  // Получаем личный сертификат
    if (Result=AVCMR_SUCCESS) then begin
      Result:=AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, Nil, Nil, W, 0);
      if (Result=AVCMR_SUCCESS) then begin
        SetLength(keyID, W - 1);
        Result:=AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, Nil, @keyID[1], W, 0);
        if Result=AVCMR_SUCCESS then begin
          sPublicKey:=keyID;
          if sOpis='+' then begin
            GetOpisCert(hCert,'',sOpis);
            {
            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertLastName), nil, W, AVCMF_ATTR_BY_OID);
            SetLength(S, W - 1);
            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertLastName), @S[1], W, AVCMF_ATTR_BY_OID);
            sOpis:=S+' ';

            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertFirstName), nil, W, AVCMF_ATTR_BY_OID);
            SetLength(S, W - 1);
            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertFirstName), @S[1], W, AVCMF_ATTR_BY_OID);
            sOpis:=sOpis+S+', ';

            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertOrgName), nil, W, AVCMF_ATTR_BY_OID);
            SetLength(S, W - 1);
            AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR, PAnsiChar(csCertOrgName), @S[1], W, AVCMF_ATTR_BY_OID);
            sOpis:=sOpis+S+', ';

            // certdate_begin
            W:=SizeOf(st);
            AvCmGetCertAttr(hCert, AVCM_NOT_BEFORE , nil, @st, W, 0);
            S:=FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(st));
            sOpis:=sOpis+' с '+S+' до ';
            // certdate_end
            W:=SizeOf(st);
            AvCmGetCertAttr(hCert, AVCM_NOT_AFTER , nil, @st, W, 0);
            S:=FormatDateTime('dd.mm.yyyy', SystemTimeToDateTime(st));
            sOpis:=sOpis+S;
            }
          end;
        end;
      end;
    end;
  end;
  CloseSession;
end;
//--------------------------------------------
function TAvest.ChoiceCertAsString(var sCert:AnsiString; var sOpis:String) : DWORD;
var
  hSession:AvCmHc;
  hCert:AvCmHcert;
  W:DWORD;
  S:AnsiString;
  l:Boolean;
  i,n:Integer;
begin
  if hDefSession<>nil
    then CloseSession;
  Result:=InitSession(true);
  if (Result=AVCMR_SUCCESS) then begin
    hSession:=hDefSession; // !!!
    W:=SizeOf(hCert);
    Result:=AvCmGetObjectInfo(hSession, AVCM_MY_CERT, @hCert, W, 0);  // Получаем личный сертификат
    if (Result=AVCMR_SUCCESS) then begin
      W:=0;
      Result:=AvCmGetCertAttr(hCert, AVCM_BLOB, Nil, Nil, W, 0);
      if (Result=AVCMR_SUCCESS) then begin
        SetLength(S, W);
        Result:=AvCmGetCertAttr(hCert, AVCM_BLOB, Nil, @S[1], W, 0);
        if Result=AVCMR_SUCCESS then begin
          l:=FDeleteCRLF;
          FDeleteCRLF:=true;
          S:=EncodeStringEx(S);  // в BASE64
          FDeleteCRLF:=l;
          n:=1;
          while Length(Copy(S,n,64))>0 do begin
            sCert:=sCert+Copy(S,n,64)+chr(13)+chr(10);
            n:=n+64;
          end;
          sCert:='-----BEGIN CERTIFICATE-----'+chr(13)+chr(10)+sCert+'-----END CERTIFICATE-----'+chr(13)+chr(10);
          GetOpisCert(hCert,'',sOpis);
        end;
      end;
    end;
  end;
  CloseSession;
end;
//-------------------------------------------------------
function TAvest.SMDOSignFile(sFile:String; var sSign:String):DWORD;
var
  slFiles, slSign:TStringList;
begin
  slFiles:=TStringList.Create;
  slFiles.Add(sFile);
  slSign:=TStringList.Create;
  sSign:='';
  Result:=SMDOSign(slFiles, slSign, '');
  if Result=0 then
    sSign:=slSign.Strings[0];
  slFiles.Free;
  slSign.Free;
end;
//-------------------------------------------------------
function TAvest.SMDOSign(slFiles:TStringList; slSign:TStringList; sPath:String):DWORD;
var
  hSession: AvCmHc;
  hMsg: AvCmHmsg;
//  hSign: AvCmHandle;
//  hCert: AvCmHcert;
//     hStatus: AvCmHcertstat;
//     par: AvCmCertStatParam;
  w, res: DWORD;
//     statsert: DWORD;
//     i: Integer;
//  st1: TSystemTime;
  i:Integer;
  sSign,sFile:ANSIString;
begin
  if (sPath<>'') and (RightStr(sPath,1)<>'') then sPath:=sPath+'\';
  slError.Clear;
//  DateLastSign:=0;
  slSign.Clear;
  for i:=0 to slFiles.Count-1 do slSign.Add('');

  res:=ActivateSession(hSession,true);

  if res=AVCMR_SUCCESS then begin

    for i:=0 to slFiles.Count-1 do begin
      sSign:='';
      // прочитаем файл который будем подписывать
      sFile:=FileToStr(sPath+slFiles[i]);

      res:=AvCmOpenMsg(hSession, @sFile[1], Length(sFile), hMsg, AVCMF_IN_RAW_DATA);
      if res=AVCMR_SUCCESS then begin
        // Содержимое сообщения не включается в экспортируемое сообщение
        // В выходное сообщение будет включен только сертификат подписавшего.
        res:=AvCmMsgSign(hMsg, AVCMF_DETACHED+AVCMF_ADD_SIGN_CERT);
        if res=AVCMR_SUCCESS then begin
          AvCmGetMsg(hMsg, Nil, W, 0);
          SetLength(sSign, W);
          AvCmGetMsg(hmsg, @sSign[1], W, 0);
          sSign:=EncodeStringEx(sSign);  // в BASE64
        end;
        AvCmCloseHandle(hMsg, 0);
      end;
      slSign.Strings[i]:=sSign;
      if res<>AVCMR_SUCCESS then begin
        break;
      end;
    end;
    DeactivateSession(hSession);
  end;
  Result:=res;
end;

{
function TCryptMain.GetCertAttribAsString(const HCert: AvCmHcert; AttribName: AnsiString; DefValue: AnsiString = '';  const IsExtendedAttrib: Boolean = False): AnsiString;
var
  W: DWORD;
  RunResult: Cardinal;
  SearchContext: Cardinal;
begin
  if IsExtendedAttrib then
    SearchContext := AVCM_EXT_AS_STRING
  else
    SearchContext := AVCM_SUBJECT_ATTR;
  RunResult := AvCmGetCertAttr(HCert, SearchContext, PAnsiChar(AttribName),
    Nil, W, AVCMF_ATTR_BY_OID);
  if RunResult = AVCMR_NOT_FOUND then
    Exit(DefValue);
  CheckMsg(RunResult);
  SetLength(Result, W - 1);
  CheckMsg(AvCmGetCertAttr(HCert, SearchContext, PAnsiChar(AttribName),  @Result[1], W, AVCMF_ATTR_BY_OID));
end;
}
//-------------------------------------------------------
// nCheckCert=0  проверка сертификата по умолчанию
// nCheckCert=1  не проверять сертификат
// nCheckCert=2  обрабатывать ошибку "нет доверия сертификату"(AVCMR_CERT_ALREADY_EXPIRED) c учетом даты подписания и сроков действия сертификата
function TAvest.SMDOVerify(var sFile:AnsiString; slSign:TStringList; lNameFile:Boolean; nCheckCert:Integer):DWORD;
Var
     hSession: AvCmHc;
     hMsg: AvCmHmsg;
     hSign: AvCmHandle;
     hCert: AvCmHcert;
//     hStatus: AvCmHcertstat;
     S, s1, sNameFile : AnsiString;
//     par: AvCmCertStatParam;
     w, res: DWORD;
//     statsert: DWORD;
//     i: Integer;
     st1,st2: TSystemTime;
     j,m,mmm:Integer;
     nPar:Cardinal;
     SearchContext: Cardinal;
//     sFile:ANSIString;
begin
  slError.Clear;
  slSignInfo.Clear;
  DateLastSign:=0;
  DateCertEnd:=0;
  DateCertBegin:=0;
  Result:=0;
  // передано имя файла, прочитаем файл
  if lNameFile then begin
    sNameFile:=sFile;
    sFile:=FileToStr(sFile);
    if Length(sFile)=0 then begin
      sFile:=sNameFile;
      exit;
    end;
  end else begin   // передали уже считанный файл
    sNameFile:='';
  end;

  res:=ActivateSession(hSession,false);
  {
  if hDefSession=nil then begin
    // инициализация
    res:=AvCmInit(AVCMF_STARTUP);
    CheckMsg(res);
    // открытие сессии без атентификации пользователя
    if res=AVCMR_SUCCESS then begin
      res:=AvCmLogin(0, Nil, hSession, AVCMF_NO_AUTH);
      CheckMsg(res);
    end;
  end else begin
    res:=AVCMR_SUCCESS;
    hSession:=hDefSession;
  end;
  }
  if res=AVCMR_SUCCESS then begin
    for m:=0 to slSign.Count-1 do begin
//      if res<>AVCMR_SUCCESS then begin
//        Result:=res;
//        break;  // !!!  не будем проверять все оставшиеся подписи
//      end;
      S:=slSign.Strings[m];  // ЭЦП
      if FBase64     // декодировать ЭЦП из BASE64
        then S:=DecodeString(S);
      // открытие сообщения
      res:=AvCmOpenMsg(hSession, @S[1], Length(S), hMsg, AVCMF_IN_PKCS7);

      if res<>AVCMR_SUCCESS then begin
        slSignInfo.Add(Inttostr(m)+'#error='+ErrorInfo(res));
        slSignInfo.Add(Inttostr(m)+'#code_error='+inttostr(res-AVCMR_BASE));
        CheckMsg(res,false);
        if Result=0 then Result:=res; //AVCMR_BAD_FORMED_SIGN; // Неверный формат подписи
      end else begin
//        f:=SizeOf(i);
        // количетство подписей
//  берем первую      CheckMsg( AvCmGetMsgParam(hMsg, AVCM_SIGN_COUNT, @i, f, 0) );
        res:=AvCmSetMsgContent(hMsg, @sFile[1], Length(sFile), 0);
        if res<>AVCMR_SUCCESS then begin
          slSignInfo.Add(Inttostr(m)+'#error='+ErrorInfo(res));
          slSignInfo.Add(Inttostr(m)+'#code_error='+inttostr(res-AVCMR_BASE));
          CheckMsg(res,false);
        end;
        if res=AVCMR_SUCCESS then begin
//      for n:=0 to i-1 do begin
          CheckMsg( AvCmGetMsgSign(hMsg, 0, hSign, 0) );
          CheckMsg( AvCmFindCertBySign(hSign, hCert, 0) );
          for j:=0 to slAtr.Count-1 do begin
            s1:='';
            mmm:=Pos('=',slAtr.Strings[j]);
            if mmm=0
              then s:=slAtr.Strings[j]
              else s:=Copy(slAtr.Strings[j],1,mmm-1);
            s:=ANSILowerCase(s);
            slAtr.Strings[j]:=s+'=';
            SearchContext:=AVCM_SUBJECT_ATTR;
            if Copy(s,1,1)='*' then begin
              SearchContext:=AVCM_EXT_AS_STRING;
              s:=Copy(s,2,Length(s)-1);
            end;
            s1:='';
            if s='signdate' then begin   // дата и время подписания
              W:=SizeOf(st1);
              res:=AvCmGetSignAttr(hSign, AVCM_SIGN_DATE_TIME, nil, @st1, W,  0);
              if res = AVCMR_SUCCESS then begin
                s1:=FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st1));
                DateLastSign:=SystemTimeToDateTime(st1);
              end else begin
                s1:='';
              end;
            end else if s='certdate_end' then begin   //
              W:=SizeOf(st2);
              res:=AvCmGetCertAttr(hCert, AVCM_NOT_AFTER , nil, @st2, W, 0);
              if res=AVCMR_SUCCESS then begin
                s1:=FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st2));
                DateCertEnd:=SystemTimeToDateTime(st2);
              end;
            end else if s='certdate_begin' then begin   //
              W:=SizeOf(st2);
              res:=AvCmGetCertAttr(hCert, AVCM_NOT_BEFORE , nil, @st2, W, 0);
              if res=AVCMR_SUCCESS then begin
                s1:=FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st2));
                DateCertBegin:=SystemTimeToDateTime(st2);
              end;
            end else if s='sign_alg' then begin   //
              res:=AvCmGetCertAttr(hCert, AVCM_SIGN_ALG_OID, nil, nil, W, 0);
              if res=AVCMR_SUCCESS then begin
                SetLength(S1, W-1);
                res:=AvCmGetCertAttr(hCert, AVCM_SIGN_ALG_OID, nil, nil, W, 0);
              end;
            end else begin              // значения атрибутов по OID
              res:=AvCmGetCertAttr(hCert, SearchContext, PAnsiChar(s), nil, W, AVCMF_ATTR_BY_OID);
              if res=AVCMR_SUCCESS then begin
                SetLength(S1, W-1);
                res:=AvCmGetCertAttr(hCert, SearchContext, PAnsiChar(s), @S1[1], W, AVCMF_ATTR_BY_OID);
                if res<>AVCMR_SUCCESS then s1:='';
              end;
            end;

            slSignInfo.Add(Inttostr(m)+'#'+s+'='+s1);
//            slAtr.Strings[j]:=s+'='+s1;
          end;
          {
          res:=AvCmGetCertAttr(hCert, AVCM_EXT_COUNT, nil, nil, W, 0);
          if res=AVCMR_SUCCESS then begin
            ShowMessage(inttostr(w));
            Setlength(s1,100);
            W:=100;
            res:=AvCmGetCertAttr(hCert, AVCM_EXT_OID, PAnsiChar('2'), @S1[1], W, AVCMF_ATTR_BY_NUM);
            ShowMessage(s1);
//            SetLength(S1, W-1);
          end;
          }
          //------ собственно верификация ------------------------------------------------------------
// проверять ЭЦП на дату выработки                                  AVCMF_VERIFY_ON_SIGN_DATE = $1;
// не проверять отсутствие сертификата в СОС удостоверяющего центра AVCMF_NO_CRL_VERIFY       = $20;
// импор  тировать все необходимые СОС из сообщения                   AVCMF_IMPORT_CRL          = $40000
// не проверять доверие к сертификату подписавшего                  AVCMF_NO_CERT_VERIFY      = $8000000;
//          nPar:=AVCMF_VERIFY_ON_SIGN_DATE;  в версии 4.0 выдается ошибка
          nPar:=0;
          if nCheckCert=CHECK_CERT_NOT then nPar:=nPar+AVCMF_NO_CERT_VERIFY;
          res:=AvCmMsgVerifySign(hMsg, hCert, nPar);
          if res<>AVCMR_SUCCESS then begin
            if (nCheckCert=CHECK_CERT_DATE) and (res=AVCMR_CERT_ALREADY_EXPIRED) then begin
              if (DateLastSign>0) and (DateCertEnd>0)  and (DateCertBegin>0) and
                 (DateCertEnd>DateLastSign) and (DateCertBegin<DateLastSign) then begin
                res:=AVCMR_SUCCESS;
              end;
            end;
            if res<>AVCMR_SUCCESS then begin
              slSignInfo.Add(Inttostr(m)+'#error='+ErrorInfo(res));
              slSignInfo.Add(Inttostr(m)+'#code_error='+inttostr(res-AVCMR_BASE));
              CheckMsg(res,false);
            end;
          end;
          if Result=0 then Result:=res;
          {
          pSt:=@st1;

          res:=AvCmMsgVerifySignAtIndexForDate(hMsg, 0, pSt, 0);
          if res<>AVCMR_SUCCESS then begin
            slSignInfo.Add(Inttostr(m)+'#error_date='+ErrorInfo(res));
            CheckMsg(res,false);
          end;
          }
          AvCmCloseHandle(hCert, 0);
//      end;
        end else begin
          if Result=0 then Result:=res;
        end;
      end;
      AvCmCloseHandle(hMsg, 0);
    end;

  end;

  DeactivateSession(hSession);

  if lNameFile then begin
    sFile:=sNameFile;
  end;

  {
  if hDefSession=nil then begin
    AvCmLogout(hSession, 0);
    AvCmInit(AVCMF_SHUTDOWN);
  end;
  }
end;
//-------------------------------------------------------------------------------
function TAvest.SMDOGetCOC(sPath: String): DWORD;
var
  hSession: AvCmHc;
  S : AnsiString;
//  hMsg: AvCmHmsg;
//  hSign: AvCmHandle;
  hCert: AvCmHcert;
//  hAcert: AvCmHcert;
//  par: AvCmImportParam;
  pare: AvCmEnumGetParam;
  hcert_enum: AvCmHcertEnum;
  f, W, res: DWORD;
  compState, cocFlag: Integer;
  st1: TSystemTime;
  hcrl: AvCmHcrl;
  parc: AvCmFindCrlParam;
  curDate, cocDate: TDateTime;

begin
  slError.Clear;
  Result:=0;
  if not IsActive then exit;

  res:=ActivateSession(hSession,false);

  if res=AVCMR_SUCCESS then begin
    pare.param_id := AVCM_TYPE;
    w:=AVCM_TYPE_ROOT;   //AVCM_TYPE_MY;
    pare.param:=@w;
    pare.param_spec:=nil;  //0

    cocFlag := 0;

    res:=AvCmOpenCertEnum(hSession, 1, @pare, hcert_enum, AVCMF_ALL_CERT);
    f:=AVCMF_START;
//    i:=1;
    while AvCmEnumGet(hcert_enum, hCert, f) = 0 do begin
      f:=AVCMF_NEXT;
      cocFlag := 0;
      res:=AvCmGetCertAttr(hCert, AVCM_ISSUER_AS_STRING, Nil, Nil, W, 0);
      if res=AVCMR_SUCCESS then begin
        SetLength(s, W - 1);
        AvCmGetCertAttr(hcert, AVCM_ISSUER_AS_STRING, Nil, @s[1], W, 0);
      end;
      //ShowMessage(s);
//      StrToFile('ISSUER'+inttostr(i),s);
    {
    res:=AvCmGetCertAttr(hCert, AVCM_CRL_DISTRIBUTION_POINTS, Nil, Nil, W, 0);
    if res=AVCMR_SUCCESS then begin
      SetLength(s, W - 1);
      res:=AvCmGetCertAttr(hcert, AVCM_ISSUER_AS_STRING, Nil, @s[1], W, 0);
      StrToFile('path',s);
    end else begin
      StrToFile('path',ErrorInfo(res));
    end; }
//      inc(i);


      parc.param_id:=AVCM_CRL_ISSUER_CERT;
      parc.param:=@hcert;
//      hcert.
      res:=AvCmFindCrl(hSession, 1, @parc, hcrl, 0);
      //ShowMessage(inttostr(res));

      if res=AVCMR_SUCCESS then begin
        w:=SizeOf(st1);
        res:=AvCmGetCrlAttr(hcrl, AVCM_NOT_AFTER, @st1, w, 0);  // $1B
        //ShowMessage(inttostr(Res));

        cocDate:=SystemTimeToDateTime(st1)+1;
        curDate:=Date;

       //ShowMessage(FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st1)));

        compState:= CompareDate(curDate, cocDate);
        if (compState=0) or (compState=1) then begin
          cocFlag:=1;
        end;
        AvCmCloseHandle(hcrl, 0);
      end else begin
        cocFlag := 1;
      end;
    end;
    AvCmCloseHandle(hcert_enum, 0);

    if cocFlag=1 then begin
      //ShowMessage(NameX);
       if Assigned(AvCmCheckCrlDP)
         then res:=AvCmCheckCrlDP(hSession, PANSIChar(sPath), 0)
         else res:=AVCMR_NOT_IMPLEMENTED;
    end;

     //S := FileToStr('c:\ruc.crl');

     //par.param_id := AVCM_RESULT_HANDLE;
     //par.param := hSign;

     //Res := AvCmCheckCrlDP(fhc, NameX, 0);

     //Res := AvCmImport(fhc, AVCM_CRL, @S[1], Length(S), 1, @par, AVCMF_RETURN_HANDLE_IF_EXISTS);

   end;

   DeactivateSession(hSession);
   Result:=res;
end;
//----------------------------------------------------------------------------------------
function TAvest.SMDORefreshCOC(sPath: String): DWORD;
var
  hSession: AvCmHc;
begin
  slError.Clear;
  Result:=ActivateSession(hSession,false);
  if Result=AVCMR_SUCCESS then begin
     if Assigned(AvCmCheckCrlDP)
       then Result:=AvCmCheckCrlDP(hSession, PANSIChar(sPath), 0)
       else Result:=AVCMR_NOT_IMPLEMENTED;
  end;
  DeactivateSession(hSession);
end;
//----------------------------------------------------------
function TAvest.IsRefreshError(n:DWORD):Boolean;
begin
  if (n=0) or (n=AVCMR_ALREADY_EXISTS) or (n=AVCMR_OLD_CRL)
    then Result:=false // это не ошибка !!!
    else Result:=true
end;

const
  ref_coc='Обновление СОС и сертификатов УЦ';
//=================
function TAvest.SMDORefreshCOC2(sPath: String; var sErr:String; lAllSoob:Boolean; lShow:Boolean): DWORD;
var
  hSession: AvCmHc;
  arr:TArrStrings;
  i,m:Integer;
  n:DWORD;
  s:String;
begin
  slError.Clear;
  sErr:='';
  Result:=ActivateSession(hSession,false);
  if (Result=AVCMR_SUCCESS) and Assigned(AvCmCheckCrlDP) then begin
    StrToArr(sPath, arr, #13#10, true);
    if lShow then begin
      m:=40;
      for i:=0 to Length(arr)-1 do begin
        if Length(arr[i])>m then begin
          s:=arr[i];
          m:=Length(arr[i]);
        end;
      end;
      OpenMessage(PadCStr(ref_coc+' ...',40,' ')+';'+s+'###');
    end;
    try
      for i:=0 to Length(arr)-1 do begin
        s:=arr[i];
//        sleep(2000);
        if lShow
          then ChangeMessage(ref_coc+';'+s);
        n:=AvCmCheckCrlDP(hSession, PANSIChar(s), 0);
        if n>0 then begin
          s:=ErrorInfo(n);
          Q_DelChars(s,chr(0));
        end;
        if IsRefreshError(n) then begin
          Result:=n;
          slError.Add(arr[i]+#13#10+'     '+s);
        end else begin
          if lAllSoob then begin
            if (n=0)
              then slError.Add(arr[i]+#13#10+'     Обновлен')
              else slError.Add(arr[i]+#13#10+'     Обновление не требуется ('+s+')');
          end;
        end;
      end;
    finally
      if lShow then CloseMessage();
    end;
    if slError.Count>0
      then sErr:=FullErrorInfo(0,true);
  end else begin
    Result:=AVCMR_NOT_IMPLEMENTED;
  end;
  DeactivateSession(hSession);
end;
//----------------------------------------------------------
function TAvest.RefreshCOC(sURL:String; lAllSoob:Boolean; var sErr:String; lShow:Boolean):Integer;
var
  s:String;
  sE:String;
  nRes:DWORD;
begin
  Result:=-1;  // !!!
  sErr:='';
  if IsActive then begin
    if (sURL='avest') then begin  // будем читать из конфигурационного файла Авест
      s:=CheckSleshN(PathDLL)+'CrlDPExt.txt';
      if FileExists(s) then begin
        sURL:=FileToStr(s);
      end else begin
        sErr:='Не найден файл "'+s+'"';
        exit;
      end;
    end;
    sE:='';
    s:=sUrl;
    DelChars(s,' '#13#10#9);
    if s<>'' then begin
      nRes:=0;
//      if lShow then OpenMessage(PadCStr('Контроль точек распределения СОС ...',80,'#')+';######');
//      try
        nRes:=SMDORefreshCOC2(sUrl,sE,lAllSoob,lShow);     // раздельно по каждому URL
//      finally
//        if lShow then CloseMessage;
//      end;
      if nRes>0 then begin
        Result:=1;  // Ошибка
        if sE<>'' then begin
          sErr:=sE;
        end else begin
          sErr:=ErrorInfo(nRes);
          DelChars(sErr, chr(0));
        end;
      end else begin
        Result:=0;
        if lAllSoob and (sE<>'')
          then sErr:=sE;
      end;
    end else begin
      sErr:='Не заполнен путь доступа к точкам распределения СОС';
    end;
  end else begin
    sErr:=not_load_etsp; //'Библиотека для работы с ЭЦП не загружена';
  end;
end;
//================
//-------------------------------------------------------
function TAvest.GetAllAttrSign(sNameFile:String; sSign:String; var slOut:TStringList):Boolean;
Var
     hSession: AvCmHc;
     hMsg: AvCmHmsg;
     hSign: AvCmHandle;
     hAcert, hCert: AvCmHcert;
     params: AvCmEnumGetParam;
     hcert_enum: AvCmHcertEnum;
//     hStatus: AvCmHcertstat;
     S, s1, s2 : AnsiString;
     f, w, k, res: DWORD;
     i: Integer;
     st2: TSystemTime;
     EnumType: boolean;
     isOkAAttr:Boolean;
     ValidACert:Integer;
     sFile, sMsg,KeyID:ANSIString;
begin
  // прочитаем файл который был подписан
  sFile:=FileToStr(sNameFile);

  Result:=false;
  res:=ActivateSession(hSession,false);
  {
  if hDefSession=nil then begin
    // инициализация
    res:=AvCmInit(AVCMF_STARTUP);
    CheckMsg(res,false);
    if res=AVCMR_SUCCESS then begin
      // открытие сессии без атентификации пользователя
      res:=AvCmLogin(0, Nil, hSession, AVCMF_NO_AUTH);
      CheckMsg(res,false);
    end;
  end else begin
    res:=0;
    hSession:=hDefSession;
  end;
  }
  if res=AVCMR_SUCCESS then begin
    S:=sSign;  // ЭЦП
    if FBase64     // декодировать ЭЦП из BASE64
      then S:=DecodeString(S);
    // открытие сообщения
    res:=AvCmOpenMsg(hSession, @S[1], Length(S), hMsg, AVCMF_IN_PKCS7);

    if res<>AVCMR_SUCCESS then begin
      slOut.Add('Открытие сообщения: ' + ErrorInfo(res));
    end else begin
      CheckMsg( AvCmSetMsgContent(hMsg, @sFile[1], Length(sFile), 0) );
      slOut.Add('Сообщение открыто.');
      CheckMsg( AvCmGetMsgSign(hMsg, 0, hSign, 0) );
      CheckMsg( AvCmFindCertBySign(hSign, hCert, 0) );

      //---- проверяем только первую ЭЦП ----   !!! для проверки ЭЦП нужет файл !!!
      res:=AvCmMsgVerifySign(hMsg, hCert, 0);
      if res=AVCMR_SUCCESS
        then slOut.Add('Проверка ЭЦП: OK!')
        else slOut.Add('Проверка ЭЦП: ' + Inttostr(res)+' '+ErrorInfo(res));
      //-----------
      CheckMsg(AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, Nil, Nil, W, 0));
      SetLength(keyID, W - 1);
      CheckMsg(AvCmGetCertAttr(hCert, AVCM_PUB_KEY_ID, Nil, @keyID[1], W, 0));
      slOut.Add('Сообщение подписано сертификатом с идентификатором ключа: ' + keyID);

      W:=SizeOf(st2);
      res:=AvCmGetCertAttr(hCert, AVCM_NOT_BEFORE , nil, @st2, W, 0);
      if res=AVCMR_SUCCESS
        then s1:=FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st2))
        else s1:='неизвестна ('+ErrorInfo(res)+')';
      slOut.Add('Дата/время начала действия сертификата:       ' + s1);
      W:=SizeOf(st2);
      res:=AvCmGetCertAttr(hCert, AVCM_NOT_AFTER , nil, @st2, W, 0);
      if res=AVCMR_SUCCESS
        then s1:=FormatDateTime('dd.mm.yyyy hh:nn:ss', SystemTimeToDateTime(st2))
        else s1:='неизвестна ('+ErrorInfo(res)+')';
      slOut.Add('Дата/время окончания действия сертификата: ' + s1);

      s1:='';
      res:=AvCmGetCertAttr(hCert, AVCM_SIGN_ALG_OID, nil, nil, W, 0);
      if res=AVCMR_SUCCESS then begin
        SetLength(S1, W-1);
        res:=AvCmGetCertAttr(hCert, AVCM_SIGN_ALG_OID, nil, @s1[1], W, 0);
      end else begin
        s1:=ErrorInfo(res);
      end;
      slOut.Add('Алгоритм подписи: ' + s1);
      s1:='';
      res:=AvCmGetCertAttr(hCert, AVCM_HASH_ALG_OID, nil, nil, W, 0);
      if res=AVCMR_SUCCESS then begin
        SetLength(S1, W-1);
        res:=AvCmGetCertAttr(hCert, AVCM_HASH_ALG_OID, nil, @s1[1], W, 0);
      end else begin
        s1:=ErrorInfo(res);
      end;
      slOut.Add('Алгоритм хеширования: ' + s1);


      {
      //----- получаем исходное сообщение    !!! для случая когда вдожение внутри !!!
      CheckMsg(AvCmGetMsgContent(hMsg, Nil, W, 0));
      SetLength(sMsg, W);
      CheckMsg(AvCmGetMsgContent(hMsg, @sMsg[1], W, 0));
      slOut.Add('Исходное сообщение: ' + sMsg);  }

      W := SizeOF(K);
      CheckMsg(AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR_COUNT, Nil, @K, W, 0));
      slOut.Add('-----------------------------------------------');
      slOut.Add('Количество атрибутов владельца сертификата ' + IntToStr(K));
      for i := 0 to K - 1 do begin
        res:=AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR  , @i, nil, W, AVCMF_ATTR_BY_NUM);
        if res=AVCMR_SUCCESS then begin
          SetLength(S1, W-1);
          res:=AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR , @i, @S1[1], W, AVCMF_ATTR_BY_NUM);
          if res<>AVCMR_SUCCESS then s1:='';
          AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR_OID, @i, nil, W, AVCMF_ATTR_BY_NUM);
          SetLength(S2, W-1);
          AvCmGetCertAttr(hCert, AVCM_SUBJECT_ATTR_OID, @i, @S2[1], W, AVCMF_ATTR_BY_NUM);
          slOut.Add(s2 + '='+s1);
        end;
      end;

      W := SizeOF(K);
      CheckMsg(AvCmGetCertAttr(hCert, AVCM_ISSUER_ATTR_COUNT, Nil, @K, W, 0));
      slOut.Add('-----------------------------------------------');
      slOut.Add('Количество атрибутов издателя сертификата ' + IntToStr(K));
      for i := 0 to K - 1 do begin
        res:=AvCmGetCertAttr(hCert, AVCM_ISSUER_ATTR, @i, nil, W, AVCMF_ATTR_BY_NUM);
        if res=AVCMR_SUCCESS then begin
          SetLength(S1, W-1);
          res:=AvCmGetCertAttr(hCert, AVCM_ISSUER_ATTR, @i, @S1[1], W, AVCMF_ATTR_BY_NUM);
          if res<>AVCMR_SUCCESS then s1:='';

          AvCmGetCertAttr(hCert, AVCM_ISSUER_ATTR_OID, @i, nil, W, AVCMF_ATTR_BY_NUM);
          SetLength(S2, W-1);
          AvCmGetCertAttr(hCert, AVCM_ISSUER_ATTR_OID, @i, @S2[1], W, AVCMF_ATTR_BY_NUM);
          slOut.Add(s2 + '='+s1);
        end;
      end;
      slOut.Add('-----------------------------------------------');
      //======================
      params.param_id := AVCM_ATTRIBUTE_CERTS;
      params.param := @hcert;

      ValidACert := 1;
      for EnumType := False to True do begin
        //Если уже нашли требуемый атрибутный сертификат - прерываем поиск
        if (ValidACert = 0) Then
            Break;

        if EnumType then begin
           params.param := @hcert;
           slOut.Add('Поиск атрибутных сертификатов в хринилище');
        end else begin
           params.param := @hmsg;
           slOut.Add('Поиск атрибутных сертификатов в сообщении');
        end;
        AvCmOpenCertEnum(hSession, 1,  @params, hcert_enum, 0);
        f := AVCMF_START;
        isOkAAttr := False;
        while AvCmEnumGet(hcert_enum, hACert, f) = 0 do begin
          // получаем найденные сертификаты
          f := 0;
          // получаем требуемый размер
          CheckMsg(AvCmGetCertAttr(hACert, AVCM_SERIAL_AS_STRING, Nil, Nil, W, 0));
          // выделяем память (дельфи авоматом содержит конец строки пожтому выделяем на 1 меньше)
          SetLength(s, W - 1);
          // получаем значение атрибута
          CheckMsg(AvCmGetCertAttr(hACert, AVCM_SERIAL_AS_STRING, Nil, @s[1], W, 0));
          slOut.Add('Найден атрибутный сертификат серийный номер ' + S);

          // Если ищем в сообщении - проверим на кого выпущен атрибутный сертификат
          if Not EnumType then begin
             CheckMsg(AvCmGetCertAttr(hACert, AVCM_PUB_KEY_ID, @i, Nil, W, 0));
             SetLength(s1, W - 1);
             CheckMsg(AvCmGetCertAttr(hACert, AVCM_PUB_KEY_ID, @i, @s1[1], W, 0));
             if s1 <> keyID then begin
                slOut.Add('Этот атрибутный сертификат выпущен на другой сертифика с KEY_ID ' + S1);
                Continue;
             end;

          end;

          // количество дополнительных атрибутов
          W := SizeOF(K);
          CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_COUNT, Nil, @K, W, 0));
          slOut.Add('Количество атрибутов  ' + IntToStr(K));
          for i := 0 to K - 1 do begin
              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_OID, @i, Nil, W, 0));
              SetLength(s1, W - 1);
              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_OID, @i, @s1[1], W, 0));

              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_OID_NAME, @i, Nil, W, 0));
              SetLength(s2, W - 1);
              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_OID_NAME, @i, @s2[1], W, 0));

              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_AS_STRING, @i, Nil, W, 0));
              SetLength(s, W - 1);
              CheckMsg(AvCmGetCertAttr(hACert, AVCM_ATTR_AS_STRING, @i, @s[1], W, 0));

              // Для примера в сообщении должен быть текст соответствующий значению с OID=2.5.4.4=Фамилия
              if s1 = '2.5.4.4' then begin
                 if Pos(s, sMsg) > 0 then
                    isOkAAttr := True;
              end;

              slOut.Add(s1 + '(' + s2 + ')=' + S);
          end;
          if isOkAAttr then begin
             slOut.Add('Этот атрибутный сертификат подходит для удостоверения данной ЭЦП');
             W := SizeOf(ValidACert);
             CheckMsg(AvCmGetCertAttr(hACert, AVCM_VALID, Nil, @ValidACert, W, 0));
             if ValidACert = 0 then begin
                slOut.Add('Атрибутный сертификат: ' + ErrorInfo(ValidACert));
                AvCmCloseHandle(hACert, 0);
                Break;
             end else begin
                slOut.Add('Ошибка при проверке атрибутного сертификата: ' + ErrorInfo(ValidACert));
             end;
          end else begin
            slOut.Add('Этот атрибутный сертификат не подходит для удостоверения данной ЭЦП');
          end;
          Result:=true;
          AvCmCloseHandle(hACert, 0);
        end;
        AvCmCloseHandle(hcert_enum, 0);
      end;
      AvCmCloseHandle(hmsg, 0);
      //==========
    end;
  end;
  DeactivateSession(hSession);
  {
  if hDefSession=nil then begin
    AvCmLogout(hSession, 0);
    AvCmInit(AVCMF_SHUTDOWN);
  end;
  }
end;

procedure TAvest.SetOnWriteLog(const Value: TWriteTextToLog);
begin
  FOnWriteLog:=Value;
end;

procedure TAvest.SetDebug(const Value: Boolean);
begin
  FDebug := Value;
end;


{
//-------------------------------------------------------
function TAvest.CalcHash(slFiles:TStringList; slSign:TStringList; sPath:String):DWORD;
var
  hSession: AvCmHc;
  hMsg: AvCmHmsg;
//  hSign: AvCmHandle;
//  hCert: AvCmHcert;
//     hStatus: AvCmHcertstat;
//     par: AvCmCertStatParam;
  w, res: DWORD;
//     statsert: DWORD;
//     i: Integer;
//  st1: TSystemTime;
  i:Integer;
  sSign,sFile:ANSIString;
begin
  if (sPath<>'') and (RightStr(sPath,1)<>'') then sPath:=sPath+'\';
  slError.Clear;
//  DateLastSign:=0;
  slSign.Clear;
  for i:=0 to slFiles.Count-1 do slSign.Add('');

  res:=ActivateSession(hSession,true);

  if res=AVCMR_SUCCESS then begin

    for i:=0 to slFiles.Count-1 do begin
      sSign:='';
      // прочитаем файл который будем подписывать
      sFile:=FileToStr(sPath+slFiles[i]);

      res:=AvCmOpenMsg(hSession, @sFile[1], Length(sFile), hMsg, AVCMF_OPEN_FOR_CALC_BELTHASH or AVCMF_IN_RAW_DATA);
      if res=AVCMR_SUCCESS then begin
        // Содержимое сообщения не включается в экспортируемое сообщение
        // В выходное сообщение будет включен только сертификат подписавшего.
        res:=AvCmMsgSign(hMsg, 0);
        if res=AVCMR_SUCCESS then begin
          AvCmGetMsg(hMsg, Nil, W, 0);
          SetLength(sSign, W);
          AvCmGetMsg(hmsg, @sSign[1], W, 0);
          sSign:=EncodeStringEx(sSign);  // в BASE64
        end;
        AvCmCloseHandle(hMsg, 0);
      end;
      slSign.Strings[i]:=sSign;
      if res<>AVCMR_SUCCESS then begin
        break;
      end;
    end;
    DeactivateSession(hSession);
  end;
  Result:=res;
end;
}

procedure TAvest.SetIgnoreCOC(const Value: Boolean);
begin
  FIgnoreCOC:=Value;
  if FIgnoreCOC then begin

//----------------------------------------------
// AvCmLogin: Если передан этот флаг, то в том случае, если соответствующий СОС
// истёк, не выдавать ошибки и продолжать работу
//const
//   AVCMF_IGNORE_CRL_EXPIRE = $8;
//----------------------------------------------
// AvCmLogin: Если передан этот флаг, то в том случае, если соответствующий СОС
// отсутствует, не выдавать ошибки и продолжать работу
//const
//   AVCMF_IGNORE_CRL_ABSENCE = $1;
//----------------------------------------------
    PAR_IgnoreCOC:=AVCMF_IGNORE_CRL_ABSENCE+AVCMF_IGNORE_CRL_EXPIRE;
  end else begin
    PAR_IgnoreCOC:=0;
  end;
end;

initialization
  Avest:=nil;
finalization
  if Avest<>nil then begin
    FreeAndNil(Avest);
  end;
end.
