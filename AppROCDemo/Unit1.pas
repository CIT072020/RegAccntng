unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DateUtils,
  nativexml,
  funcpr,
  superdate, superobject,
  StdCtrls, Mask,
  DBCtrlsEh,
  DB, Grids, DBGridEh,
  adsdata, adsfunc, adstable, adscnnct,
  HTTPSend,
  ssl_openssl, ssl_openssl_lib,
  uROCExchg;

const  
  INI_NAME = '..\..\Lais7\Service\RegUch.ini';

 

type
  TForm1 = class(TForm)
    edMemo: TMemo;
    gdIDs: TDBGridEh;
    DataSource1: TDataSource;
    gdDocs: TDBGridEh;
    dsDocs: TDataSource;
    gdChild: TDBGridEh;
    dsChild: TDataSource;
    btnGetDocs: TButton;
    dtBegin: TDBDateTimeEditEh;
    dtEnd: TDBDateTimeEditEh;
    edOrgan: TDBEditEh;
    edFirst: TDBEditEh;
    edCount: TDBEditEh;
    btnPostDoc: TButton;
    btnGetActual: TButton;
    lstINs: TListBox;
    edtIN: TDBEditEh;
    btnGetNSI: TButton;
    lblSSovCode: TLabel;
    lblIndNum: TLabel;
    edNsiType: TDBEditEh;
    lblNsiType: TLabel;
    gdNsi: TDBGridEh;
    dsNsi: TDataSource;
    edNsiCode: TDBEditEh;
    cbSrcPost: TDBComboBoxEh;
    cnctNsi: TAdsConnection;
    cbAdsCvrt: TDBCheckBoxEh;
    cbESTP: TDBCheckBoxEh;
    cbClearLog: TDBCheckBoxEh;
    lblFirst: TLabel;
    lblCount: TLabel;
    lblDepartFromDate: TLabel;
    lblINs: TLabel;
    lblDSD: TLabel;
    lblChilds: TLabel;
    lblNSI: TLabel;
    btnGetTempIN: TButton;
    btnServReady: TButton;
    btnCursWait: TButton;
    btnCursNorm: TButton;
    edJavaDate: TDBEditEh;
    btnGetINsOnly: TButton;
    cbINsOnly: TDBCheckBoxEh;
    btnGetDprtII: TButton;
    btnKADGetReq: TButton;
    btnFileKAD: TButton;
    procedure btnCursNormClick(Sender: TObject);
    procedure btnCursWaitClick(Sender: TObject);
    procedure btnFileKADClick(Sender: TObject);
    procedure btnGetActualClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetDocsClick(Sender: TObject);
    procedure btnGetDprtIIClick(Sender: TObject);
    procedure btnGetINsOnlyClick(Sender: TObject);
    procedure btnGetNSIClick(Sender: TObject);
    procedure btnPostDocClick(Sender: TObject);
    procedure btnGetTempINClick(Sender: TObject);
    procedure btnKADGetReqClick(Sender: TObject);
    procedure btnServReadyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  BlackBox : TROCExchg;
  ShowM : TMemo;
  OldCurs : HICON;
  // ��� ������� POST
  //GETRes : TResultHTTP;

implementation

uses
  kbmMemTable,
  SasaINiFile,
  DBFunc,
  SynCommons,

  uAvest,
  uUseful,
  uRestService,
  uLoggerThr,
  uROCDTO,
  fPIN4Av;

{$R *.dfm}

var
  ROCLogger  : TLoggerThread;

// ����� ������� � Memo
procedure ShowDeb(const s: string; const ClearAll: Boolean = True);
var
  AddS: string;
begin
  AddS := '';
  if (ClearAll = True) then
    ShowM.Text := ''
  else
    AddS := CRLF;
  ShowM.Text := ShowM.Text + AddS + s;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  LOG_GISRU = 'RegUch.log';
var
  FFileLog : string;
  FEnableTextLog : Boolean;
begin
  // ???
  ShowM := edMemo;
  edOrgan.Text  := '26';
  // Todes
  //dtBegin.Value := StrToDate('01.08.2021');
  //dtEnd.Value   := StrToDate('03.08.2021');
  // OAIS
  dtBegin.Value := StrToDate('01.01.2022');
  dtEnd.Value   := StrToDate('01.01.2023');
  edFirst.Text  := '0';
  edCount.Text  := '100';
  cbSrcPost.ItemIndex := 0;

  FFileLog   := '1';
  FEnableTextLog := True;
  ROCLogger    := TLoggerThread.Create(FFileLog, LOG_GISRU, False, FEnableTextLog);

  BlackBox := TROCExchg.Create(INI_NAME);
  BlackBox.Logger := ROCLogger;

  Self.Caption := '����� � �������: ' + BlackBox.Host.URL;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ROCLogger);
  FreeAndNil(BlackBox);
end;


// �������� �� Sys_Organ
procedure TForm1.btnGetDocsClick(Sender: TObject);
var
  First, Count : Integer;
  s : string;
  D1, D2: TDateTime;
  P: TParsGet;
begin
  D1 := dtBegin.Value;
  D2 := dtEnd.Value;
  try
    First := Integer(edFirst.Value);
    except
    First := 0;
      end;

  try
    Count := Integer(edCount.Value);
    except
    Count := 0;
      end;

  BlackBox.SetProgressVisible;
  if (First = 0) AND (Count = 0) then
    BlackBox.ResHTTP := BlackBox.GetDeparted(D1, D2, cbINsOnly.Checked, edOrgan.Text)
  else begin
    P := TParsGet.Create(D1, D2, edOrgan.Text);
    P.First := First;
    P.Count := Count;
    P.NeedINsOnly := cbINsOnly.Checked;
    BlackBox.ResHTTP := BlackBox.GetDeparted(P);
  end;
  //GETRes := BlackBox.ResHTTP;
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);

  //if (BlackBox.ResHTTP.INs.RecordCount > 0) then begin
    DataSource1.DataSet := BlackBox.ResHTTP.INs;
    dsDocs.DataSet := BlackBox.ResHTTP.Docs;
    dsChild.DataSet := BlackBox.ResHTTP.Child;
    BlackBox.ResHTTP.INs.First;
    while (NOT BlackBox.ResHTTP.INs.Eof) do begin
      if (BlackBox.ResHTTP.INs.Bof) then
        lstINs.Clear;
      s := BlackBox.ResHTTP.INs.FieldValues['IDENTIF'] + '=' + BlackBox.ResHTTP.INs.FieldValues['PID'];
      lstINs.Items.Add(BlackBox.ResHTTP.INs.FieldValues['IDENTIF']);
      //lstINs.Items.Add(s);
      BlackBox.ResHTTP.INs.Next;
    end;

  //end;

end;

procedure SetAdditionalData(ds : TDataSet);
begin
  ds.Edit;
  ds['organDocCode']    := 17608178;
  ds['sysDocType']      := 8;
  ds['inputOldAddress'] := true;
  ds['areaL']           := 11300001;
  ds['typeCityL']       := 11100001;
  ds['cityL']           := 11904366;
  ds['streetL']         := 11904366;
  ds['DATEZ']           := StrToDate('12.08.2021');
  ds.Post;
end;

// ���������� ������������ ������ ��� ��
procedure TForm1.btnGetActualClick(Sender: TObject);
var
  i: Integer;
  //s : string;
  IndNums: TStringList;
  //P: TParsGet;
begin
  BlackBox.SetProgressVisible;
  IndNums := TStringList.Create;
  //IndNums.Delimiter 
  if (lstINs.SelCount > 0) then begin
    // �������� 1 ��� ���������, ����� �� ������ ��
    if (lstINs.SelCount = 1) then
      // ������ ������������ - ���������� ������
      BlackBox.ResHTTP := BlackBox.GetActualReg(lstINs.Items[lstINs.ItemIndex])
    else begin
      // ������� ��������� - ���������� ������
      for i := 0 to lstINs.Count - 1 do begin
        if (lstINs.Selected[i]) then
          IndNums.Add(lstINs.Items[i]);
      end;
      BlackBox.ResHTTP := BlackBox.GetActualReg(IndNums, REG_TYPE_CONST, TLIST_INDNUMS);
    end;
  end
  else begin
    // ������ �� ��������, ����� �� TextBox �� ��� ���
    IndNums := Split(' ', edtIN.Text);
    if (IndNums.Count = 1) then
      BlackBox.ResHTTP := BlackBox.GetActualReg(edtIN.Text)
    else
      BlackBox.ResHTTP := BlackBox.GetActualReg(IndNums, REG_TYPE_CONST, TLIST_FIO);
  end;
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);
  if (Assigned(BlackBox.ResHTTP)) then begin
    dsDocs.DataSet := BlackBox.ResHTTP.Docs;
    dsChild.DataSet := BlackBox.ResHTTP.Child;
    //SetAdditionalData(BlackBox.ResHTTP.Docs);
  end;

end;

// ��������� PIN
function SetAvestPass(Avest: TAvest): Boolean;
var
  sPin: string;
begin
  Result := False;
  if (Length(Avest.Password) = 0)
    OR (Avest.hDefSession = nil) then begin
    // ������������ ��� �� ��������, ����� PIN
    fPINGet := TfPINGet.Create(nil);
    try
      if (fPINGet.ShowModal = mrOk) then begin
        fPINGet.SetResult(sPin);
        if (Length(sPin) > 0) then begin
          Avest.SetLoginParams(sPin, '');
          Result := True;
        end;
      end;
    finally
      fPINGet.Free;
      fPINGet := nil;
    end;
  end
  else
    Result := True;
end;

procedure LeaveOnly1(ds: TDataSet);
var
  x : Variant;
begin

  x := DS.FieldValues['MID'];
  ds.First;
  while (ds.RecordCount > 1)AND(not ds.Eof) do begin
    if (ds.FieldValues['MID'] = x) then
      ds.Next
    else
      ds.Delete;
  end;
end;

//----------------------------------------------
function DSet4Post(MemTableCode : string = MT_DOCS; CurDS : Boolean = False) : TkbmMemTable;
var
  Sect : string;
begin
  if (MemTableCode = MT_DOCS) then
    if (CurDS = True) then
      Result := BlackBox.ResHTTP.Docs
    else
      Result := TkbmMemTable(CreateMemTable(MemTableCode, BlackBox.Meta, SCT_TBL_DOC))
  else
    if (CurDS = True) then
      Result := BlackBox.ResHTTP.Child
    else
      Result := TkbmMemTable(CreateMemTable(MemTableCode, BlackBox.Meta, SCT_TBL_CLD));
end;

// �������� ���������� ������������ ������ ��� ��
procedure TForm1.btnPostDocClick(Sender: TObject);
const
  exmSign = 'amlsnandwkn&@871099udlaukbdeslfug12p91883y1hpd91h';
  exmSert = '109uu21nu0t17togdy70-fuib';
var
  iSrc  : Integer;
  PPost : TParsPost;
  aRec  : TCurrentRecord;
  //Res: TResultHTTP;
begin
  //edMemo.Clear;
  PPost := TParsPost.Create(CHILD_FREE);
  iSrc  := cbSrcPost.ItemIndex;
  if (iSrc in [0..1]) then begin
    // �� MemTable
    PPost.JSONSrc := '';
    PPost.Docs := DSet4Post(MT_DOCS);
    //PPost.Child := DSet4Post(MT_CHILD);
    if (cbSrcPost.ItemIndex = 0) then begin
    // �������� ������ �������
      GetCurrentRecord(dsDocs.DataSet, '', aRec);
      AddCurrentRecord(PPost.Docs, aRec);
      //LeaveOnly1(dsDocs.DataSet);
    end;
  end
  else begin
    // �� JSON-�����
    PPost.JSONSrc := cbSrcPost.Items[iSrc];
    //PPost.Docs := nil;
  end;

  BlackBox.Secure.SignPost := cbESTP.Checked;
  if (BlackBox.Secure.SignPost = True) then
    if (SetAvestPass(BlackBox.Secure.xAvest) = False) then
      Exit;

  BlackBox.Secure.xAvest.Debug := True;
  BlackBox.ResHTTP := BlackBox.PostRegDocs(PPost);
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' MSG: =' + BlackBox.ResHTTP.ResMsg + '=' + CRLF +
          'Inf: =' + BlackBox.ResHTTP.StrInf + '=', cbClearLog.Checked);

end;


// ���������� ROC
procedure TForm1.btnGetNSIClick(Sender: TObject);
var
  ValidPars: Boolean;
  NsiCode, NsiType: integer;
  TName,
  NsiTypeStr, Path2Nsi: string;
  ParsNsi: TParsNsi;
  cAds : TAdsConnection;
begin
  try
    NsiCode := 0;
    NsiTypeStr := AnsiUpperCase(edNsiType.Text);
    if (NsiTypeStr = 'ALL') OR (NsiTypeStr = '���') OR (NsiTypeStr = IntToStr(NSIALL)) then
      NsiType := NSIALL
    else begin
      NsiType := StrToInt(NsiTypeStr);
      if (Length(edNsiCode.Text) > 0) then
      // ������ ���� ������� �����������
        NsiCode := StrToInt(edNsiCode.Text)
    end;
    ValidPars := True;
  except
    ValidPars := False;
  end;
  if (ValidPars = True) then begin
    cAds := nil;

    cnctNsi.IsConnected := False;
    //cnctNsi.ConnectPath := IncludeTrailingBackslash(BlackBox.Meta.ReadString(SCT_NSI, 'ADSPATH', '.'));
    cnctNsi.ConnectPath := BlackBox.Meta.ReadString(SCT_NSI, 'ADSPATH', '.');

    cAds := cnctNsi;

    //ParsNsi := TParsNsi.Create(NsiType, BlackBox.Meta, nil, Owner);
    //ParsNsi.ADSCopy := cbAdsCvrt.Checked;
    //ParsNsi.NsiCode := NsiCode;
    //BlackBox.ResHTTP := BlackBox.GetNSI(ParsNsi);

    //BlackBox.ResHTTP := BlackBox.GetROCNSI(NsiType, nil, 'RegUch7');
    TName := Trim(edtIN.Text);
    if Right(TName, 1) = '*' then
      TName := DelRight(TName, 1)
    else
      TName := '';
    BlackBox.SetProgressVisible;
    //BlackBox.SetProgressVisible(False);
    BlackBox.ResHTTP := BlackBox.GetROCNSI(NsiType, cAds, TName);
    dsNsi.DataSet := BlackBox.ResHTTP.Nsi;
    BlackBox.ResHTTP.Nsi.First;
    lblNSI.Caption := Format('���������� (%s) - ����� ������� - %d', [NsiTypeStr, BlackBox.ResHTTP.Nsi.RecordCount]);
    ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);
  end;
end;




//
procedure TForm1.btnGetTempINClick(Sender: TObject);
var
  s : string;
begin
  s := 'IDENTIF';
  //s := 'PASSPORT';
  BlackBox.ResHTTP := BlackBox.GetTempIN(s);
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg + ' ' + BlackBox.ResHTTP.StrInf, cbClearLog.Checked);

end;

procedure TForm1.btnServReadyClick(Sender: TObject);
var
  Ret : Boolean;
  s : string;
begin
  s := 'IDENTIF';
  //s := 'PASSPORT';
  Ret := BlackBox.ServiceReady;
  ShowDeb('���������� ������: ' + Iif(Ret = True, '��', '���'));

end;

procedure TForm1.btnCursWaitClick(Sender: TObject);
const
  FileJson = 'J4Post-OAIS.json';
var
  s : string;
  sU : UTF8String;
  jsNotFmt,new: RawUTF8;
begin
(*
  OldCurs := SetCursor(OCR_WAIT);
  Application.ProcessMessages;
*)

  jsNotFmt := StringFromFile(FileJson);
  MemoRead(FileJson, s);
  new := JSONReformat(jsNotFmt, jsonHumanReadable);
  ShowDeb(UTF8ToString(new));
end;



procedure TForm1.btnCursNormClick(Sender: TObject);
var
  JD : LongInt;
begin
  TButton(Sender).Caption := DateTimeToStr(JavaToDelphiDateTime(StrToInt64(edJavaDate.Text)));;
end;

procedure TForm1.btnGetDprtIIClick(Sender: TObject);
var
  First, Count : Integer;
  s : string;
  Res: TResultHTTP;
begin
  if (BlackBox.ResHTTP.INs.RecordCount > 0) then begin
    Res := BlackBox.GetActualReg(BlackBox.ResHTTP.INs);
    s := Format( '��� ����������: %d, %s', [Res.ResCode, Res.ResMsg]);
  end else
    s := '�� ������� �� ������!';
  ShowDeb(s);
end;

procedure TForm1.btnGetINsOnlyClick(Sender: TObject);
var
  First, Count : Integer;
  D1, D2: TDateTime;
  P: TParsGet;
begin
  D1 := dtBegin.Value;
  D2 := dtEnd.Value;
  try
    First := Integer(edFirst.Value);
    except
    First := 0;
      end;

  try
    Count := Integer(edCount.Value);
    except
    Count := 0;
      end;

  BlackBox.SetProgressVisible;
  if (First = 0) AND (Count = 0) then
    BlackBox.ResHTTP := BlackBox.GetDeparted(D1, D2, True, edOrgan.Text)
  else begin
    P := TParsGet.Create(D1, D2, edOrgan.Text);
    P.First := First;
    P.Count := Count;
    P.NeedINsOnly := True;
    BlackBox.ResHTTP := BlackBox.GetDeparted(P);
  end;
  //GETRes := BlackBox.ResHTTP;
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);

  //if (BlackBox.ResHTTP.INs.RecordCount > 0) then begin
    DataSource1.DataSet := BlackBox.ResHTTP.INs;
    dsDocs.DataSet := BlackBox.ResHTTP.Docs;
    dsChild.DataSet := BlackBox.ResHTTP.Child;
    BlackBox.ResHTTP.INs.First;
    while (NOT BlackBox.ResHTTP.INs.Eof) do begin
      if (BlackBox.ResHTTP.INs.Bof) then
        lstINs.Clear;
      lstINs.Items.Add(BlackBox.ResHTTP.INs.FieldValues['IDENTIF']);
      BlackBox.ResHTTP.INs.Next;
    end;

  //end;

end;


//-----------------------------------
function GetKADFile(RegionId, ZipFullName : string; UserId: string = ''; UrlKad: string = ''; AuthToken: string = '' ): Boolean;
const
  URL_KAD_REQ  = 'https://apimgw.core.oais.by:40003/nca-34609/v1/api/address/v1/addressesExtendedFlatsByRegion';
  URL_KAD_FILE = 'https://apimgw.core.oais.by:40003/nca-34609/v1/api/address/v1/loadFile';
  ATOKEN       = 'Bearer c6eff146-8fbc-356b-ba41-0a10d94630f5';
  USERID_KAD   = 'DL_290050294_00000_BS';
var
  RequestId: int64;
  s: string;
  Ret : TResultHTTP;
begin
  Result := False;
  if (UserId = '') then
    UserId := USERID_KAD;
  if (UrlKad = '') then
    UrlKad := URL_KAD_REQ;
  if (AuthToken = '') then
    AuthToken := ATOKEN;

  Ret := BlackBox.GetKADReq(RegionId, UserId, UrlKad, AuthToken);
  if (Ret.ResCode = 0) then begin
    try
      RequestId := Ret.SOAnswer.I['requestId'];
      UrlKad    := URL_KAD_FILE;
      Sleep(1000 * 60);
      Ret := BlackBox.GetKADFileATE(IntToStr(RequestId), ZipFullName, UserId, UrlKad, AuthToken);
      if (Ret.ResCode = 0) then begin
        Result := True;
      end;
    except
    end;
    //WriteTextLog(GetError(True,True))
  end else begin
    //Result := Ret.StrInf;
  end;
end;


procedure TForm1.btnKADGetReqClick(Sender: TObject);
const
  ATEZIP    = 'C:\Users\Alex\Documents\����-�����\ATE';
  // 1370-������, 2073-�������
  // 608-��������, 2-����������
  // 20834-������
  REGION_ID = '20834';
var
  bRet: Boolean;
  RegionId,
  sF,
  s : string;
begin
  RegionId := edJavaDate.Text;
  if (RegionId = '') then
    RegionId := REGION_ID;
  //sF   := Format('%s-%s-%s.zip', [ATEZIP, RegionId, IntToStr(DelphiToJavaDateTime(Now))]);
  sF   := Format('%s-%s.zip', [ATEZIP, RegionId]);
  bRet := GetKADFile(RegionId, sF);
  if (bRet = True) then begin
    s := Format('������ ��� ������� %s ���������: %s , ������-%d', [RegionId, sF, FileSize(sF)]);
  end else
    s := Format('��� ��������: %d %s', [BlackBox.ResHTTP.ResCode, BlackBox.ResHTTP.ResMsg + ' *** ' + BlackBox.ResHTTP.StrInf]);
  ShowDeb(s);
end;


procedure TForm1.btnFileKADClick(Sender: TObject);
const
  ATEZIP    = 'C:\Users\Alex\Documents\����-�����\ATE';
  URL_KAD_FILE = 'https://apimgw.core.oais.by:40003/nca-34609/v1/api/address/v1/loadFile';
  USERID_KAD   = 'DL_290050294_00000_BS';
  ATOKEN       = 'Bearer c6eff146-8fbc-356b-ba41-0a10d94630f5';
  REQ_ID = '189281';
var
  ZipFullName,
  RequestId,
  s: string;
  Ret : TResultHTTP;
begin
  //ZipFullName := Format('%s-%s-%s.zip', [ATEZIP, 'XXX', IntToStr(DelphiToJavaDateTime(Now))]);

  RequestId := edJavaDate.Text;
  if (RequestId = '') then
    RequestId := REQ_ID;
  ZipFullName := Format('%s-%s.zip', [ATEZIP, RequestId]);

  Ret := BlackBox.GetKADFileATE(RequestId, ZipFullName, USERID_KAD, URL_KAD_FILE, ATOKEN);
  if (Ret.ResCode = 0) then begin
    s := Format('������ ��� ������� %s ���������: %s , ������-%d', ['XXX', ZipFullName, FileSize(ZipFullName)]);
  end else
    s := Format('��� ��������: %d %s', [BlackBox.ResHTTP.ResCode, BlackBox.ResHTTP.ResMsg + ' *** ' + BlackBox.ResHTTP.StrInf]);
  ShowDeb(s);
end;

end.


