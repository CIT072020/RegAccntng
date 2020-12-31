unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DateUtils,
//  IdHTTP, //, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  nativexml, funcpr, superdate, superobject, StdCtrls, Mask, DBCtrlsEh, uDvigmen,
  DB, Grids, DBGridEh, adsdata, adsfunc, adstable, adscnnct,
//  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  HTTPSend, ssl_openssl, ssl_openssl_lib,
  uExchg,
  uPars,
  ExchgRegBase;

type
  TForm1 = class(TForm)
    Button1: TButton;
    edMemo: TMemo;
    edFile: TDBEditEh;
    edURL: TDBEditEh;
    Button2: TButton;
    edMetod: TDBComboBoxEh;
    gdIDs: TDBGridEh;
    DataSource1: TDataSource;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    btnSort: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    AdsConnection: TAdsConnection;
    GridTalon: TDBGridEh;
    DataSource2: TDataSource;
    tbTalonPrib: TAdsTable;
    tbTalonPribDeti: TAdsTable;
    cbCreateSO: TCheckBox;
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
    procedure btnGetActualClick(Sender: TObject);
    procedure btnGetListClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btnGetCurIDClick(Sender: TObject);
    procedure btnGetDocsClick(Sender: TObject);
    procedure btnGetNSIClick(Sender: TObject);
    procedure btnGetWithParsClick(Sender: TObject);
    procedure btnPostDocClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dm:TDvigMen;
    function getHTTP(lIndy:Boolean):String;
  end;

const
  data =
'/* more difficult test case */ { "glossary": { "title": "example glossary", "GlossDiv":'+
' { "title": "S", "GlossList": [ { "ID": "SGML", "SortAs": "SGML", "GlossTerm": "Standar'+
'd Generalized Markup Language", "Acronym": "SGML", "Abbrev": "ISO 8879:1986", "GlossDef'+
'": "A meta-markup language, used to create markup languages such as DocBook.", "GlossSe'+
'eAlso": ["GML", "XML", "markup"] } ] } } }';

var
  Form1: TForm1;
  // ��� ������� POST
  GETRes : TResultGet;


implementation
uses
  kbmMemTable,
  SasaINiFile,
  uService;

{$R *.dfm}

// getMovements:  http://www.todes.by:8086 /cxf/vcouncil/movements ?sysOrgan=26&since=01.01.2015
procedure TForm1.Button1Click(Sender: TObject);
var
  new_obj: ISuperObject;
  s:String;
  sw:WideString;
begin
  MemoRead(NameFromExe(edFile.Text),s);
  edmemo.Lines.add(Utf8ToAnsi(s));
  sw:=Utf8ToAnsi(s);

  edmemo.Lines.add('-------------------------------');
  new_obj:=so(sw);
 // new_obj:=TSuperObject.ParseString(PWideCharsw,false);
  edmemo.Lines.add('new_obj.AsJson='+new_obj.AsJson(true, false));
  new_obj:=nil;
end;

//---------------------------------------------------
function TForm1.getHTTP(lIndy:Boolean):String;
var
//  IdHttp:TIdHTTP;
//  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
  SStrm: TStringStream;
  sURL:String;
  HTTP: THTTPSend;
begin
  SStrm:=TStringStream.Create('');
  sURL:=edURL.text;
  if lIndy then begin
//    IdHTTP:=TIdHTTP.Create(nil);
//    IdHTTP.Request.BasicAuthentication:=false;
//    IdSSLIOHandlerSocket:=TIdSSLIOHandlerSocket.Create(IdHTTP);
//    IdSSLIOHandlerSocket.SSLOptions.Mode:=sslmClient;
//    IdSSLIOHandlerSocket.SSLOptions.Method:=sslvTLSv1;
//    IdHTTP.IOHandler:=IdSSLIOHandlerSocket;
  //  IdHTTP.OnWork:=fmmain.IdHTTP1Work;
  //  IdHTTP.OnWorkBegin:=fmmain.IdHTTP1WorkBegin;
  //  IdHTTP.OnWorkEnd:=fmmain.IdHTTP1WorkEnd;
//    IdHTTP1.Get(sURL, SStrm);
//    FreeAndNil(IdSSLIOHandlerSocket);
//    FreeAndNil(IdHTTP);
//    WhichFailedToLoad;
  end else begin
    HTTP:=THTTPSend.Create;
//    HTTP.Protocol:='1.1';
//    HTTP.Sock.SSL.SSLType:=LT_TLSv1;
    try
      HTTP.HTTPMethod('GET', sURL);
      edMemo.Lines.Add(IntToStr(HTTP.ResultCode)+'  '+HTTP.ResultString);
      edMemo.Lines.Add(HTTP.Sock.LastErrorDesc);
      SStrm.Seek(0, soFromBeginning);
      SStrm.CopyFrom(HTTP.Document, 0);
      Result:=SStrm.DataString;
    finally
      HTTP.Free;
    end;
  end;
  FreeAndNil(SStrm);
end;
//---------------------------------------------------
function UnixStrToDateTime(sDate:String):TDateTime;
begin
 try
   if sDate='null'
     then result:=0
//     else result:=UnixToDateTime(StrToInt64(Copy(sDate,1,Length(sDate)-3)));
     else result:=JavaToDelphiDateTime(StrToInt64(sDate));
 except
   result:=0;
 end;
end;
//---------------------------------------------------
procedure TForm1.Button2Click(Sender: TObject);
var
  sl:TStringList;
//  SStrm:TStringStream;
  s:String;
  new_obj, obj: ISuperObject;
  sw:WideString;
  i:Integer;
  HTTP: THTTPSend;
begin
  sl:=TStringList.Create;
  s:=getHTTP(false);
//  SStrm:=TStringStream.Create('');
//  HttpGetText(edURL.text, sl);
//  HttpGetBinary(edURL.text,SStrm);
//  s:=SStrm.DataString;
  MemoWrite('!!!.json',s);
//  ed.Lines.Assign(sl);
  edMemo.lines.Add('---------------');
  edMemo.lines.Add(inttostr(length(s)));
  if (Length(s)>0) and cbCreateSO.Checked then begin
    sw:=Utf8Decode(s);
  //  sw:=Utf8ToAnsi(s);
    new_obj:=so(sw);
    for i:=0 to new_obj.AsArray.Length-1 do begin
      obj:=new_obj.AsArray.O[i];
      edmemo.Lines.add('active="'+obj.S['active']+'"');
      edmemo.Lines.add('pid="'+obj.S['pid']+'"');
      edmemo.Lines.add('identif="'+obj.S['identif']+'"');
      edmemo.Lines.add('surname="'+obj.S['surname']+'"');
      edmemo.Lines.add('name="'+obj.S['name']+'"');
      edmemo.Lines.add('docAppleDate='+obj.S['docAppleDate']+'  '+FormatDateTime('dd.mm.yyyy hh:nn',UnixStrToDateTime(obj.S['docAppleDate'])));
      edmemo.Lines.add('dateBegin='+obj.S['dateBegin']+'  '+FormatDateTime('dd.mm.yyyy hh:nn',UnixStrToDateTime(obj.S['dateBegin'])));
      edmemo.Lines.add('dateRec='+obj.S['dateRec']+'  '+FormatDateTime('dd.mm.yyyy hh:nn',UnixStrToDateTime(obj.S['dateRec'])));
      edMemo.lines.Add('---------------------------------------------');
      {
      edmemo.Lines.add('sysOrganWhere.klUniPK.code="'+obj.O['sysOrganWhere'].O['klUniPK'].S['code']+'"');
      edmemo.Lines.add('sysOrganWhere.klUniPK.code="'+obj.S['sysOrganWhere.klUniPK.code']+'"');
      edmemo.Lines.add('sysOrganWhere.lex1="'+obj.O['sysOrganWhere'].S['lex1']+'"');
      edmemo.Lines.add('sysOrganWhere.dateBegin="'+obj.O['sysOrganWhere'].S['dateBegin']+'"');
      edmemo.Lines.add('sysOrganFrom.lex1="'+obj.O['sysOrganFrom'].S['lex1']+'"');
      edmemo.Lines.add('sysOrganFrom.dateBegin="'+obj.O['sysOrganFrom'].S['dateBegin']+'"');
      }
    end;

  end;
//  edmemo.Lines.add(new_obj.AsJson(true, false));
  new_obj:=nil;
  sl.Free;
end;

{
var
  HTTP: THTTPSend;
begin
  HTTP := THTTPSend.Create;
    try
      if edMetod.Text='GET' then begin
        if HTTP.HTTPMethod('GET', edURL.Text) then begin
          edMemo.Lines.Assign(HTTP.Headers);
          edMemo.Lines.ADD('----------------');
          edMemo.Lines.Add('DownloadSize '+InttoStr(HTTP.DownloadSize));
          edMemo.Lines.Add('ResultCode '+InttoStr(HTTP.ResultCode)+'  '+HTTP.ResultString);
//          SStrm:=TStringStream.Create('');
//          Response.Seek(0, soFromBeginning);
//          Response.CopyFrom(HTTP.Document, 0);
        end else begin
          edMemo.Lines.ADD('----------------');
          edMemo.Lines.ADD('ERROR');
          edMemo.Lines.Add('ResultCode '+InttoStr(HTTP.ResultCode)+'  '+HTTP.ResultString);
        end;
      end else begin
        if HTTP.HTTPMethod('HEAD', edURL.Text) then begin
          edMemo.Lines.Assign(HTTP.Headers);
          edMemo.Lines.ADD('----------------');
          edMemo.Lines.Add('ResultCode '+InttoStr(HTTP.ResultCode)+'  '+HTTP.ResultString);
        end;
      end;
    finally
      HTTP.Free;
    end;
end;
}
procedure TForm1.Button3Click(Sender: TObject);
var
  sP : string;
  slPar : TStringList;
begin
  slPar := TStringList.Create;
  //sys_organ
  slPar.Add('26');
  //since
  slPar.Add('01.01.2015');
  //till
  slPar.Add('01.01.2015');

  //first
  slPar.Add('1');
  //count
  slPar.Add('');
  //sP := SetPars4GetList(slPar);
  dm.getMovements(slPar);

  DataSource1.DataSet := dm.tbMovements;
  slPar.Free;
end;

procedure TForm1.Button8Click(Sender: TObject);
//var
//  slPar:TStringList;
begin
//  slPar:=TStringList.Create;
  dm.saveDoc(nil, tbTalonPrib, tbTalonPribDeti);
//  DataSource1.DataSet:=dm.tbDvigMens;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  slPar:TStringList;
  i:Integer;
begin
  slPar:=TStringList.Create;
 //   FSourceURL:='/cxf/vcouncil/movements';
  slPar.Add('identif=4090940B026PB5');
//  slPar.Add('identif=2222940B011PB5');
  dm.getDoc(slPar);
  slPar.Free;
  DataSource1.DataSet:=dm.tbDvigMens;
  with dm.tbDvigMens do begin
    for i:=0 to FieldCount-1 do begin
      edMemo.Lines.Add(Fields[i].FieldName+'='+Fields[i].AsString);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Pars : TParsExchg;
begin
  dm:=TDvigMen.Create;
  //dm.ReadParams;
  AdsConnection.IsConnected:=true;
  tbTalonPrib.Open;
  tbTalonPribDeti.Open;

  ShowM := edMemo;
  edOrgan.Text  := '12';
  dtBegin.Value := StrToDate('20.12.2020');
  dtEnd.Value   := StrToDate('26.12.2020');
  edFirst.Text  := '0';
  edCount.Text  := '10';
  cbSrcPost.ItemIndex := 0;

  //Pars := TParsExchg.Create();
  BlackBox := TExchgRegCitizens.Create(INI_NAME);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  tbTalonPrib.Close;
  tbTalonPribDeti.Close;
  AdsConnection.IsConnected:=false;
  dm.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  jdt : Int64;
  d:TDateTime;
begin
{
function JavaToDelphiDateTime(const dt: Int64): TDateTime;
function DelphiToJavaDateTime(const dt: TDateTime): Int64;

function DelphiDateTimeToISO8601Date(dt: TDateTime): SOString;
function DelphiDateTimeToISO8601DateWithTimeZone(dt: TDateTime; tzi: PTimeZoneInformation): SOString;

function ISO8601DateToJavaDateTime(const str: SOString; var ms: Int64): Boolean;
function ISO8601DateToDelphiDateTime(const str: SOString; var dt: TDateTime): Boolean;
}
//1240672053000
 //Edit2.Text:='';

 if ComboBox1.ItemIndex=0 then begin
   // ISO converting
   if ISO8601DateToDelphiDateTime(Edit1.Text, d)
     then Edit2.Text:=FormatDateTime('dd.mm.yyyy hh:nn:ss', d)
     else Edit2.Text:='error';
 end else begin
   // Java converting
   if (Edit1.Text <> '') then begin
     d:=JavaToDelphiDateTime( StrToInt64(Edit1.Text));
     Edit2.Text:=FormatDateTime('dd.mm.yyyy hh:nn:ss', d);
   end else begin
     d   := StrToDate(Edit2.Text);
     jdt := DelphiToJavaDateTime(d);
     Edit1.Text := IntToStr(DelphiToJavaDateTime(StrToDate(Edit2.Text)));

   end;
 end;
end;


// ��������� ���������� ������ ������ �� �������
procedure SetIDSort;
const
  IDX_ID = 'IDTF';
var
  mt : TkbmMemTable;
  ds : TDataSet;
begin
  mt := TkbmMemTable(Form1.gdIDs.DataSource.DataSet);
  //mt.AddIndex(IDX_ID, 'IDENTIF', [ixDescending]);
  mt.AddIndex(IDX_ID, 'IDENTIF', []);
  mt.IndexName := IDX_ID;
end;

procedure TForm1.btnSortClick(Sender: TObject);
var
  i:Integer;
  sp:TStringStream;
  function crlf:String;
  begin
    result:=chr(13)+chr(10);
  end;
begin
//  sp:=TStringStream.Create('');
//  sp.WriteString('{'+crlf);
//  sp.WriteString('"1111111111",'#13#10);
//  sp.WriteString('"2222222222222222", '#13#10);
//  sp.WriteString('"44444444444444444", '#13#10);
//  sp.WriteString('}');
//  ShowMessage(sp.DataString);
//  sp.Free;
//  if dm.CreateTableDvigMens then begin
//    DataSource1.DataSet:=dm.tbDvigMens;
//    edMemo.Clear;
//    for i:=0 to dm.tbDvigMens.Fields.Count-1 do begin
//      edMemo.Lines.Add(dm.tbDvigMens.Fields[i].FieldName+'='+dm.getPathField(dm.tbDvigMens.Fields[i]));
//    end;
//  end else begin
//    ShowMessage(dm.getLastError);
//  end;

  SetIDSort;
end;

function UnEscape(s: AnsiString): WideString;
var
  i: Integer;
  j: Integer;
  c: Integer;
begin
  // Make result at least large enough. This prevents too many reallocs
  SetLength(Result, Length(s));
  i := 1; j := 1;
  while i <= Length(s) do
  begin
     // If a '\' is found, typecast the following 4 digit integer to widechar
     if s[i] = '\' then  begin
       if (s[i+1]='u') and TryStrToInt(Copy(s, i+2, 4), c) then begin
//         raise Exception.CreateFmt('Invalid code at position %d', [i]);
         Inc(i, 6);
         Result[j] :=WideChar(c);
       end else begin
         Result[j]:=WideChar(s[i]);
         Inc(i);
       end;
     end else begin
       Result[j]:=WideChar(s[i]);
       Inc(i);
     end;
     Inc(j);
  end;
  // Trim result in case we reserved too much space
  SetLength(Result, j-1);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  obj,new_obj: ISuperObject;
  st1,st2:TStringStream;
  n:Integer;
  lCRLF,lEscape:Boolean;
  sss:String;
  ws:WideString;
begin
  new_obj:=sa([]);
  obj:=so;
  obj.S['surname']:='������';
  obj.I['pid']:=744477;
//  obj.D['pid2']:=111110815014021226;
  obj.O['qqq']:=nil;
  obj.I['sysOrganWhere.klUniPK.code']:=777;
  obj.I['sysOrganWhere.klUniPK.type']:=-2;
  sss:='����������� ���� ������� �������';
  obj.S['sysOrganWhere.lex1']:=sss;
  new_obj.AsArray.Add(obj);
  lCRLF:=true;
  lEscape:=false;
  ws:=new_obj.AsJSon(lCRLF,lEscape);
//  sss:=WideString(st1.DataString);
  memowrite('test.json', UTF8Encode(ws));
  edMemo.Lines.Text:=inttostr(n)+#13#10+Utf8ToAnsi(UTF8Encode(ws));

  {
  obj:=so;
  obj.I['sysOrganWhere.klUniPK.code']:=777;
  obj.I['sysOrganWhere.klUniPK.type']:=-2;
  obj.S['sysOrganWhere.lex1']:='wwwwwwwwwwwwww vvvvvvvvvvvvv';
  st1:=TStringStream.Create('');
  st2:=TStringStream.Create('');
  obj.SaveTo(st1);
//  edMemo.Lines.Text:=st1.DataString;
  new_obj:=so('[ '+st1.DataString+' ]');
  new_obj.SaveTo(st2);
  edMemo.Lines.Text:=st2.DataString;
  st1.Free;
  st2.Free;
  }
end;
























// ����� GET with UI or HARD Pars
procedure GetWithVarPars(SOList : ISuperObject; Meta4kbm : TSasaIniFile; DS : TDataSource);
var
  i : Integer;
  sP : string;
  Pars : TStringList;
  IDs : TkbmMemTable;
begin
  // ������ ���� ������ ��
  if Assigned(SOList) and (SOList.DataType = stArray) then begin
    IDs := TkbmMemTable(CreateMemTable('IDs', Meta4kbm, 'TABLE_MOVEMENTS'));
    if ( Assigned(IDs) ) then
      i := FillIDList(SOList, IDs);
      if (i > 0) then begin
        DS.DataSet := IDs;
      end;
  end;
end;


//---***---
// :sys_organ
// :since
// :till
// first=
// count=
// ����������� ������� �� ������
procedure TForm1.btnGetWithParsClick(Sender: TObject);
begin
  GetWithVarPars(GetListID(nil, edURL.Text), dm.Meta, DataSource1);
end;

// ����������� ������� �� ������
procedure TForm1.btnGetListClick(Sender: TObject);
var
  Pars : TStringList;
begin
  Pars := TStringList.Create;
  Pars.Add('26');
  Pars.Add('05.10.2020');
  Pars.Add('31.10.2020');
  Pars.Add('1');
  Pars.Add('800');

  GetWithVarPars( GetListID(Pars), dm.Meta, DataSource1 );
end;

// ������� ��������� ��� �������� � ������ ID
procedure TForm1.btnGetCurIDClick(Sender: TObject);
var
  RecN, i: Integer;
  s : string;
  Pars: TStringList;
  SOA, SOList: ISuperObject;
  Child,
  Docs: TkbmMemTable;
  DS : TDataSet;
  FH : THostReg;
begin
  try
    RecN := gdIDs.DataSource.DataSet.RecNo;
    if (RecN >= 0) then begin
      FH := THostReg.Create;
      FH.URL := RES_HOST;
      FH.GenPoint := RES_GENPOINT;
      FH.Ver := RES_VER;

      DS := gdIDs.DataSource.DataSet;
      s  := DS.FieldValues['IDENTIF'];

      Pars := TStringList.Create;
      Pars.Add(s);
      Pars.Add('');
      Pars.Add('');
      Pars.Add('');
      Pars.Add('');
      Pars.Add('');

      //SOList := GetListDoc(FH, Pars);
      // ������ ��������� ������ ������������ ����������
      if Assigned(SOList) and (SOList.DataType = stArray) then begin
        Docs   := TkbmMemTable(CreateMemTable('Docs', dm.Meta, 'TABLE_DVIGMEN'));
        Child  := TkbmMemTable(CreateMemTable('Child', dm.Meta, 'TABLE_CHILD'));
        if (Assigned(Docs)) then
          i := FillDocList(SOList, Docs, Child);
        if (i > 0) then begin
          dsDocs.DataSet := Docs;
          dsChild.DataSet := Child;
        end;
      end;
    end;
  except
    on E:Exception do begin
      ShowDeb(E.Message);
    end;
  end;
end;

// �������� �� Sys_Organ
procedure TForm1.btnGetDocsClick(Sender: TObject);
var
  D1, D2: TDateTime;
  P: TParsGet;
begin
  edMemo.Clear;
  D1 := dtBegin.Value;
  D2 := dtEnd.Value;
  if (Integer(edFirst.Value) = 0) AND (Integer(edCount.Value) = 0) then
    BlackBox.ResGet := BlackBox.GetDeparted(D1, D2, edOrgan.Text)
  else begin

    P := TParsGet.Create(D1, D2, edOrgan.Text);
    P.First := edFirst.Value;
    P.Count := edCount.Value;
    BlackBox.ResGet := BlackBox.GetDeparted(P);
  end;
  GETRes := BlackBox.ResGet;
  ShowDeb(IntToStr(GETRes.ResCode) + ' ' + GETRes.ResMsg);

  if (GETRes.INs.RecordCount > 0) then begin
    DataSource1.DataSet := BlackBox.ResGet.INs;
    dsDocs.DataSet := BlackBox.ResGet.Docs;
    dsChild.DataSet := BlackBox.ResGet.Child;
    BlackBox.ResGet.INs.First;
    while (NOT BlackBox.ResGet.INs.Eof) do begin
      if (BlackBox.ResGet.INs.Bof) then
        lstINs.Clear;
      lstINs.Items.Add(BlackBox.ResGet.INs.FieldValues['IDENTIF']);
      BlackBox.ResGet.INs.Next;
    end;

  end;

end;


// �������� ���������� ������������ ������ ��� ��
procedure TForm1.btnPostDocClick(Sender: TObject);
const
  exmSign = 'amlsnandwkn&@871099udlaukbdeslfug12p91883y1hpd91h';
  exmSert = '109uu21nu0t17togdy70-fuib';
var
  iSrc : Integer;
  PPost : TParsPost;
  Res : TResultPost;
begin
  //edMemo.Clear;
  PPost := TParsPost.Create(exmSign, exmSert);
  iSrc := cbSrcPost.ItemIndex;
  if (cbSrcPost.ItemIndex in [0..1]) then begin
    // �� MemTable
    PPost.JSONSrc := '';
    PPost.Docs := BlackBox.ResGet.Docs;
    PPost.Child := BlackBox.ResGet.Child;
    if (cbSrcPost.ItemIndex = 0) then
    // �������� ������ �������
      LeaveOnly1(dsDocs.DataSet);
  end
  else begin
    // �� JSON-�����
    PPost.JSONSrc := cbSrcPost.Items[cbSrcPost.ItemIndex];
    //PPost.Docs := nil;
  end;

  BlackBox.ResPost := BlackBox.PostRegDocs(PPost);
  if (Assigned(BlackBox.ResPost)) then begin
  end;
  ShowDeb(IntToStr(BlackBox.ResPost.ResCode) + ' ' + BlackBox.ResPost.ResMsg);

end;

// ���������� ������������ ������ ��� ��
procedure TForm1.btnGetActualClick(Sender: TObject);
var
  i: Integer;
  IndNums: TStringList;
  P: TParsGet;
begin
  if (lstINs.SelCount > 0) then begin
    if (lstINs.SelCount = 1) then
      // ������ ������������ - ���������� ������
      BlackBox.ResGet := BlackBox.GetActualReg(lstINs.Items[lstINs.ItemIndex])
    else begin
      // ������� ��������� - ���������� ������
      IndNums := TStringList.Create;
      for i := 1 to lstINs.SelCount do begin
        if (lstINs.Selected[i]) then
          IndNums.Add(lstINs.Items[i]);
      end;
      BlackBox.ResGet := BlackBox.GetActualReg(IndNums);
    end;
  end
  else
      // ������ �� �������, ����� �� TextBox
    BlackBox.ResGet := BlackBox.GetActualReg(edtIN.Text);
  ShowDeb(IntToStr(BlackBox.ResGet.ResCode) + ' ' + BlackBox.ResGet.ResMsg);
  if (Assigned(BlackBox.ResGet)) then begin
    dsDocs.DataSet := BlackBox.ResGet.Docs;
    dsChild.DataSet := BlackBox.ResGet.Child;
  end;

end;

// ���������� ROC
procedure TForm1.btnGetNSIClick(Sender: TObject);
var
  ValidPars: Boolean;
  NsiCode, NsiType: integer;
  Path2Nsi : string;
  ParsNsi : TParsNsi;
begin
  try
    NsiType := StrToInt(edNsiType.Text);
    if (Length(edNsiCode.Text) > 0) then
      // ������ ���� ������� �����������
      NsiCode := StrToInt(edNsiCode.Text)
    else
      NsiCode := 0;
    ValidPars := True;
  except
    ValidPars := False;
  end;
  if (ValidPars = True) then begin
      cnctNsi.IsConnected := False;
      cnctNsi.ConnectPath := IncludeTrailingBackslash(BlackBox.BBPars.Meta.ReadString(SCT_ADMIN, 'ADSPATH', '.'));
    ParsNsi := TParsNsi.Create(NsiType, cnctNsi);
    ParsNsi.ADSCopy := cbAdsCvrt.Checked;
    ParsNsi.NsiCode := NsiCode;
    BlackBox.ResGet := BlackBox.GetNSI(ParsNsi);
    if (BlackBox.ResGet.ResCode = 0) then begin
      dsNsi.DataSet := BlackBox.ResGet.Nsi;
      BlackBox.ResGet.Nsi.First;
    end;
    ShowDeb(IntToStr(BlackBox.ResGet.ResCode) + ' ' + BlackBox.ResGet.ResMsg);
  end;
end;








//
end.


