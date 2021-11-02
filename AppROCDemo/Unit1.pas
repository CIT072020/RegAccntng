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
    procedure btnCursNormClick(Sender: TObject);
    procedure btnCursWaitClick(Sender: TObject);
    procedure btnGetActualClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetDocsClick(Sender: TObject);
    procedure btnGetNSIClick(Sender: TObject);
    procedure btnPostDocClick(Sender: TObject);
    procedure btnGetTempINClick(Sender: TObject);
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
  // для отладки POST
  //GETRes : TResultHTTP;

implementation

uses
  kbmMemTable,
  SasaINiFile,
  uAvest,
  uRestService,
  uROCDTO,
  fPIN4Av;

{$R *.dfm}


// Вывод отладки в Memo
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
begin
  // ???
  ShowM := edMemo;
  edOrgan.Text  := '26';
  // Todes
  //dtBegin.Value := StrToDate('01.08.2021');
  //dtEnd.Value   := StrToDate('03.08.2021');
  // OAIS
  dtBegin.Value := StrToDate('12.05.2021');
  dtEnd.Value   := StrToDate('17.05.2021');
  edFirst.Text  := '0';
  edCount.Text  := '10';
  cbSrcPost.ItemIndex := 0;

  BlackBox := TROCExchg.Create(INI_NAME);
  Self.Caption := 'Обмен с адресом: ' + BlackBox.Host.URL;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
end;


// Уехавшие из Sys_Organ
procedure TForm1.btnGetDocsClick(Sender: TObject);
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
      lstINs.Items.Add(BlackBox.ResHTTP.INs.FieldValues['IDENTIF']);
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

// Актуальные установочные данные для ИН
procedure TForm1.btnGetActualClick(Sender: TObject);
var
  i: Integer;
  s : string;
  IndNums: TStringList;
  P: TParsGet;
begin
  IndNums := TStringList.Create;
  if (lstINs.SelCount > 0) then begin
    // Отмечено 1 или несколько, берем из списка ИН
    if (lstINs.SelCount = 1) then
      // Выбран единственный - передается строка
      BlackBox.ResHTTP := BlackBox.GetActualReg(lstINs.Items[lstINs.ItemIndex])
    else begin
      // Выбрано несколько - передается список
      for i := 1 to lstINs.SelCount do begin
        if (lstINs.Selected[i]) then
          IndNums.Add(lstINs.Items[i]);
      end;
      BlackBox.ResHTTP := BlackBox.GetActualReg(IndNums, TLIST_INS);
    end;
  end
  else begin
    // Ничего не отмечено, берем из TextBox ИН или ФИО
    IndNums := Split(' ', edtIN.Text);
    if (IndNums.Count = 1) then
      BlackBox.ResHTTP := BlackBox.GetActualReg(edtIN.Text)
    else
      BlackBox.ResHTTP := BlackBox.GetActualReg(IndNums, TLIST_FIO);
  end;
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);
  if (Assigned(BlackBox.ResHTTP)) then begin
    dsDocs.DataSet := BlackBox.ResHTTP.Docs;
    dsChild.DataSet := BlackBox.ResHTTP.Child;
    //SetAdditionalData(BlackBox.ResHTTP.Docs);
  end;

end;

// Сохранить PIN
function SetAvestPass(Avest: TAvest): Boolean;
var
  sPin: string;
begin
  Result := False;
  if (Length(Avest.Password) = 0)
    OR (Avest.hDefSession = nil) then begin
    // Подключаться еще не пытались, нужен PIN
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



// Записать Актуальные установочные данные для ИН
procedure TForm1.btnPostDocClick(Sender: TObject);
const
  exmSign = 'amlsnandwkn&@871099udlaukbdeslfug12p91883y1hpd91h';
  exmSert = '109uu21nu0t17togdy70-fuib';
var
  iSrc: Integer;
  PPost: TParsPost;
  Res: TResultHTTP;
begin
  //edMemo.Clear;
  PPost := TParsPost.Create(CHILD_FREE);
  iSrc := cbSrcPost.ItemIndex;
  if (cbSrcPost.ItemIndex in [0..1]) then begin
    // из MemTable
    PPost.JSONSrc := '';
    PPost.Docs := TkbmMemTable(dsDocs.DataSet);
    PPost.Child := TkbmMemTable(dsChild.DataSet);
    if (cbSrcPost.ItemIndex = 0) then
    // передача только текущей
      LeaveOnly1(dsDocs.DataSet);
  end
  else begin
    // из JSON-файла
    PPost.JSONSrc := cbSrcPost.Items[cbSrcPost.ItemIndex];
    //PPost.Docs := nil;
  end;

  BlackBox.Secure.SignPost := cbESTP.Checked;
  if (BlackBox.Secure.SignPost = True) then
    if (SetAvestPass(BlackBox.Secure.Avest) = False) then
      Exit;

  BlackBox.Secure.Avest.Debug := True;
  BlackBox.ResHTTP := BlackBox.PostRegDocs(PPost);
  ShowDeb(IntToStr(BlackBox.ResHTTP.ResCode) + ' ' + BlackBox.ResHTTP.ResMsg, cbClearLog.Checked);

end;


// Справочник ROC
procedure TForm1.btnGetNSIClick(Sender: TObject);
var
  ValidPars: Boolean;
  NsiCode, NsiType: integer;
  NsiTypeStr, Path2Nsi: string;
  ParsNsi: TParsNsi;
begin
  try
    NsiCode := 0;
    NsiTypeStr := AnsiUpperCase(edNsiType.Text);
    if (NsiTypeStr = 'ALL') OR (NsiTypeStr = 'ВСЕ') OR (NsiTypeStr = IntToStr(NSIALL)) then
      NsiType := NSIALL
    else begin
      NsiType := StrToInt(NsiTypeStr);
      if (Length(edNsiCode.Text) > 0) then
      // только один элемент справочника
        NsiCode := StrToInt(edNsiCode.Text)
    end;
    ValidPars := True;
  except
    ValidPars := False;
  end;
  if (ValidPars = True) then begin
    //cnctNsi.IsConnected := False;
    //cnctNsi.ConnectPath := IncludeTrailingBackslash(BlackBox.Meta.ReadString(SCT_ADMIN, 'ADSPATH', '.'));
    //ParsNsi := TParsNsi.Create(NsiType, BlackBox.Meta, nil, Owner);
    //ParsNsi.ADSCopy := cbAdsCvrt.Checked;
    //ParsNsi.NsiCode := NsiCode;
    //BlackBox.ResHTTP := BlackBox.GetNSI(ParsNsi);

    //BlackBox.ResHTTP := BlackBox.GetROCNSI(NsiType, nil, 'RegUch7');
    BlackBox.ResHTTP := BlackBox.GetROCNSI(NsiType);
    dsNsi.DataSet := BlackBox.ResHTTP.Nsi;
    BlackBox.ResHTTP.Nsi.First;
    lblNSI.Caption := Format('Справочник (%s) - Всего записей - %d', [NsiTypeStr, BlackBox.ResHTTP.Nsi.RecordCount]);
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
  ShowDeb('Готовность севера: ' + Iif(Ret = True, 'Да', 'Нет'));

end;

procedure TForm1.btnCursWaitClick(Sender: TObject);
begin
  OldCurs := SetCursor(OCR_WAIT);
  Application.ProcessMessages;
end;

procedure TForm1.btnCursNormClick(Sender: TObject);
var
  JD : LongInt;
begin
  TButton(Sender).Caption := DateTimeToStr(JavaToDelphiDateTime(StrToInt64(edJavaDate.Text)));;
end;

end.


