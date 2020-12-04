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
    function GetNSI(NsiType : integer; NsiCode : integer = 0): TResultGet;


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
        i := TDocSetDTO.GetDocList(SOList, ResGet.Docs, FResGet.Child);
      end;
    end;
  except
    on E:Exception do begin
      ShowDeb(E.Message);
    end;
  end;
end;

// �������� ��������� ��� ���������� �� ������
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

// �������� ��������� ��� ���������� �� ������
function TExchgRegCitizens.GetDeparted(ParsGet: TParsGet): TResultGet;
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
      Docs4CurIN(FResGet.INs.FieldValues['IDENTIF'], FResGet.INs.FieldValues['PID'], IndNs);
      FResGet.INs.Next;
    end;
    IndNs.Free;
    FResGet.ResCode := 0;
    Result := FResGet;
  end;
end;

// �������� ���������� �������� ����������� ��� ������������� ��
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
function TExchgRegCitizens.Post1Doc(ParsPost: TParsPost; StreamDoc : TStringStream) : TResultPost;
var
  Ret, NeedUp: Boolean;
  sErr: string;
  Header: TStringList;
begin
  NeedUp := False;
  Result := TResultPost.Create;

    try
      FHTTP.Headers.Clear;

        StreamDoc.Seek(0, soBeginning);

        if (TDocSetDTO.MemDoc2JSON(ParsPost.Docs, ParsPost.Child, StreamDoc, NeedUp) = True) then begin
          FHTTP.Headers.Clear;

          FHTTP.Headers.Add('sign:' + ParsPost.USign);
          FHTTP.Headers.Add('certificate:' + ParsPost.USert);
          FHTTP.MimeType := 'application/json;charset=UTF-8';
          FHTTP.Document.CopyFrom(StreamDoc, 0);

          Ret := FHTTP.HTTPMethod('POST', ParsPost.FullURL);
          if (Ret = True) then begin
            if (FHTTP.ResultCode < 200) or (FHTTP.ResultCode >= 400) then begin
              sErr := FHTTP.Headers.Text;
              raise Exception.Create(sErr);
            end;
            ShowDeb(IntToStr(FHTTP.ResultCode) + ' ' + FHTTP.ResultString);
          end
          else begin
            sErr := IntToStr(FHTTP.sock.LastError) + ' ' + FHTTP.sock.LastErrorDesc;
            raise Exception.Create(sErr);
          end;

        end;


    except

    end;
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

      ParsPost.Docs.First;
      while not ParsPost.Docs.Eof do begin
        Result := Post1Doc(ParsPost, StreamDoc);
        ParsPost.Docs.Next;
      end;

    except

    end;
  finally
    FHTTP.Free;
  end;

end;










// �������� ���������� �����������
function TExchgRegCitizens.GetNSI(NsiType : integer; NsiCode : integer = 0): TResultGet;
var
  P: TParsGet;
begin
  Result := nil;
  {
  if (NsiCode = 0) then
    OrgCode := FPars.Organ;
  P := TParsGet.Create(DBeg, DEnd, OrgCode);
  try
    Result := GetDeparted(P);
  finally
    P.Free;
  end;
  }
end;


end.
