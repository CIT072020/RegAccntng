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

  // "������ ����" ������ � REST-��������
  TExchgRegCitizens = class(TInterfacedObject)
  private
    FPars   : TParsExchg;
    FHost   : THostReg;
    FResGet : TResultGet;
    FResSet : TResultPost;
    FHTTP   : THTTPSend;

    function ReadIni : Boolean;
    function StoreINsInRes(Pars : TParsGet) : integer;
    function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
    procedure Docs4CurIN(IndNum, PID : string; IndNs: TStringList);
    function Post1Doc(ParsPost: TParsPost; StreamDoc : TStringStream) : TResultPost;
  protected
  public
    // ��������� ������� ������ (GET)
    property ResGet : TResultGet read FResGet write FResGet;
    // ��������� �������� ������ (POST)
    property ResPost : TResultPost read FResSet write FResSet;

    (* �������� ������ ���������� [������]
    *)
    function GetDeparted(DBeg, DEnd : TDateTime; OrgCode : string = '') : TResultGet; overload;
    function GetDeparted(ParsGet : TParsGet) : TResultGet; overload;

    (* �������� �������� ���������� �����������
    *)
    function GetActualReg(INum : string) : TResultGet; overload;
    function GetActualReg(IndNs: TStringList) : TResultGet;  overload;
    function GetActualReg(ParsGet : TParsGet) : TResultGet;  overload;

    (* �������� �������� � �����������
    *)
    function PostRegDocs(ParsPost: TParsPost) : TResultPost;

    (* �������� ���������� �����������
    *)
    function GetNSI(NsiType : integer; NsiCode : integer = 0; URL : string = ''): TResultGet;


    constructor Create(Pars : TParsExchg);
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

// ���������� ���������� �� INI-�����
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
  FHost.NsiPoint := RES_NSI;
  FHost.Ver := RES_VER;

  if (NOT Assigned(FPars.Meta)) then
    if (Length(FPars.MetaName) > 0) then
      ReadIni;
end;

destructor TExchgRegCitizens.Destroy;
begin

end;



// ��������� ���������� ��� GET : ��������� ������ ���������� �� ����������
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





// ����������� ������ �� � �������� �������
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


// ������� Num->Str
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
  // ����� ���������� �������������
  i := PosEx(Srch + '"', Src);
  if (i <= 0) then begin
    // ���������� ���, �������� �������������, ��� � ����
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


// ����������� ������� �� ������
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


// �������������� ������ ������� �� ������
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


// �������� ��������� ��� �������� � ������ ID
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
      // ������ ��������� ������ ������������ ����������
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

// ������ ������� ��� ���������� (������-���������)
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

// ������ ������� ��� ���������� (���������)
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

// ���������� �������� ����������� ��� ������������� ��
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

// �������� ���������� �������� ����������� ��� ������ ��
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

// �������� ���������� �������� ����������� ��� ��
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

// �������� ������ ���������
function TExchgRegCitizens.Post1Doc(ParsPost: TParsPost; StreamDoc: TStringStream): TResultPost;
var
  RetCode: Integer;
  Ret, NeedUp: Boolean;
  sErr: string;
  Header: TStringList;
  DocDTO: TDocSetDTO;
begin
  sErr := '';
  NeedUp := False;
  Result := TResultPost.Create;

  try
    FHTTP.Headers.Clear;
    FHTTP.Headers.Add('sign:' + ParsPost.USign);
    FHTTP.Headers.Add('certificate:' + ParsPost.USert);
    FHTTP.MimeType := 'application/json;charset=UTF-8';
    if (ParsPost.JSONSrc = '') then begin
      DocDTO := TDocSetDTO.Create(ParsPost.Docs, ParsPost.Child);
      StreamDoc.Seek(0, soBeginning);
      if (DocDTO.MemDoc2JSON(ParsPost.Docs, ParsPost.Child, StreamDoc, NeedUp) = True) then
        FHTTP.Document.CopyFrom(StreamDoc, 0)
      else begin
        RetCode := 1;
        sErr := 'Error creating POST card';
        raise Exception.Create(sErr);
      end;
    end
    else begin
      FHTTP.Document.LoadFromFile(ParsPost.JSONSrc);
    end;

    Ret := FHTTP.HTTPMethod('POST', ParsPost.FullURL);
    if (Ret = True) then begin
      RetCode := FHTTP.ResultCode;
      if (FHTTP.ResultCode < 200) or (FHTTP.ResultCode >= 400) then begin
        StreamDoc.Seek(0, soBeginning);
        StreamDoc.CopyFrom(FHTTP.Document, 0);
        sErr := Utf8ToAnsi(StreamDoc.DataString) + CRLF + FHTTP.Headers[0];
        raise Exception.Create(sErr);
      end;
      sErr := FHTTP.ResultString;
    end
    else begin
      RetCode := FHTTP.sock.LastError;
      sErr := FHTTP.sock.LastErrorDesc;
      raise Exception.Create(sErr);
    end;
  except
    if (sErr <> '') then begin
    end;
  end;
  Result.ResCode := RetCode;
  Result.ResMsg := sErr;
end;

// �������� ��������� �����������
function TExchgRegCitizens.PostRegDocs(ParsPost: TParsPost): TResultPost;
var
  Ret, NeedUp: Boolean;
  sErr: string;
  Header: TStringList;
  StreamDoc: TStringStream;
begin
  NeedUp := False;
  Result := TResultPost.Create;

  FHTTP := THTTPSend.Create;
  try
    try
      ParsPost.FullURL := FullPath(FHost, POST_DOC, '');
      StreamDoc := TStringStream.Create('');
      if (ParsPost.JSONSrc = '') then begin
        ParsPost.Docs.First;
        while not ParsPost.Docs.Eof do begin
          Result := Post1Doc(ParsPost, StreamDoc);
          ParsPost.Docs.Next;
        end;
      end
      else
        Result := Post1Doc(ParsPost, StreamDoc);
    except

    end;
  finally
    FHTTP.Free;
  end;

end;




















// �������� ���������� �����������
function TExchgRegCitizens.GetNSI(NsiType: integer; NsiCode: integer = 0; URL: string = ''): TResultGet;
var
  nRec: Integer;
  SOList: ISuperObject;
  Ret: Boolean;
  StrPars, sDoc, sType, sCode, sErr: string;
begin
  Result := nil;

  if (URL = '') then begin
    if (NsiCode = 0) then
      sCode := ''
    else
      sCode := IntToStr(NsiCode);
    sType := IntToStr(NsiType);
    StrPars := Format('/type/%s?code=%s&active=true&first&count', [sType, sCode]);
    StrPars := FullPath(FHost, GET_NSI, StrPars);
  end
  else
    StrPars := URL;

  ShowDeb(StrPars);

  FHTTP := THTTPSend.Create;
  try
    try
      Ret := FHTTP.HTTPMethod('GET', StrPars);
      if (Ret = True) then begin
        if (FHTTP.ResultCode < 200) or (FHTTP.ResultCode >= 400) then begin
          sErr := FHTTP.Headers.Text;
          raise Exception.Create(sErr);
        end;
        ShowDeb(IntToStr(FHTTP.ResultCode) + ' ' + FHTTP.ResultString);
        sDoc := MemStream2Str(FHTTP.Document);
        SOList := SO(Utf8Decode(sDoc));
      end
      else begin
        sErr := IntToStr(FHTTP.sock.LastError) + ' ' + FHTTP.sock.LastErrorDesc;
        raise Exception.Create(sErr);
      end;
    except

    end;
  finally
    FHTTP.Free;
  end;

  if Assigned(SOList) and (SOList.DataType = stArray) then begin
    Result := TResultGet.Create(FPars, True);
    nRec := TDocSetDTO.GetNSI(SOList, Result.Nsi);
    if (nRec < 0) then
      Result := nil;
  end;

end;


end.
