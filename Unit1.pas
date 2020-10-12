unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  nativexml, funcpr, superdate, superobject, StdCtrls, Mask, DBCtrlsEh, uDvigmen,
  HTTPSend, DB, Grids, DBGridEh, adsdata, adsfunc, adstable, adscnnct; // ssl_openssl;

type
  TForm1 = class(TForm)
    Button1: TButton;
    edMemo: TMemo;
    edFile: TDBEditEh;
    edURL: TDBEditEh;
    Button2: TButton;
    edMetod: TDBComboBoxEh;
    Grid: TDBGridEh;
    DataSource1: TDataSource;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    AdsConnection: TAdsConnection;
    GridTalon: TDBGridEh;
    DataSource2: TDataSource;
    tbTalonPrib: TAdsTable;
    tbTalonPribDeti: TAdsTable;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dm:TDvigMen;
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

implementation

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

procedure TForm1.Button2Click(Sender: TObject);
var
  sl:TStringList;
  SStrm:TStringStream;
  s:String;
  new_obj, obj: ISuperObject;
  sw:WideString;
  i:Integer;
begin
  sl:=TStringList.Create;
  SStrm:=TStringStream.Create('');
//  HttpGetText(edURL.text, sl);
  HttpGetBinary(edURL.text,SStrm);
  s:=SStrm.DataString;
  MemoWrite('!!!.json',s);
//  ed.Lines.Assign(sl);
  edMemo.lines.Add('---------------');
  edMemo.lines.Add(inttostr(length(s)));

  sw:=Utf8Decode(s);
//  sw:=Utf8ToAnsi(s);
  new_obj:=so(sw);

  for i:=0 to new_obj.AsArray.Length-1 do begin
    obj:=new_obj.AsArray.O[i];
    edmemo.Lines.add('identif="'+obj.S['identif']+'"');
    edmemo.Lines.add('dateRec"'+obj.S['dateRec']+'"');
    edmemo.Lines.add('sysOrganWhere.klUniPK.code="'+obj.O['sysOrganWhere'].O['klUniPK'].S['code']+'"');
    edmemo.Lines.add('sysOrganWhere.klUniPK.code="'+obj.S['sysOrganWhere.klUniPK.code']+'"');
    edmemo.Lines.add('sysOrganWhere.lex1="'+obj.O['sysOrganWhere'].S['lex1']+'"');
    edmemo.Lines.add('sysOrganWhere.dateBegin="'+obj.O['sysOrganWhere'].S['dateBegin']+'"');
    edmemo.Lines.add('sysOrganFrom.lex1="'+obj.O['sysOrganFrom'].S['lex1']+'"');
    edmemo.Lines.add('sysOrganFrom.dateBegin="'+obj.O['sysOrganFrom'].S['dateBegin']+'"');
  end;



//  edmemo.Lines.add(new_obj.AsJson(true, false));
  new_obj:=nil;

  sl.Free;
  SStrm.Free;
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
  slPar:TStringList;
begin
  slPar:=TStringList.Create;
  slPar.Add('sysOrgan=26');
  slPar.Add('since=01.01.2015');
//  slPar.Add('till=');
//  slPar.Add('first=');
//  slPar.Add('count=');
  dm.getMovements(slPar);
  DataSource1.DataSet:=dm.tbMovements;
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
begin
  dm:=TDvigMen.Create;
  dm.ReadParams;
  AdsConnection.IsConnected:=true;
  tbTalonPrib.Open;
  tbTalonPribDeti.Open;
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
 Edit2.Text:='';
 if ComboBox1.ItemIndex=0 then begin
   if ISO8601DateToDelphiDateTime(Edit1.Text, d)
     then Edit2.Text:=FormatDateTime('dd.mm.yyyy hh:nn:ss', d)
     else Edit2.Text:='error';
 end else begin
   d:=JavaToDelphiDateTime( StrToInt64(Edit1.Text));
   Edit2.Text:=FormatDateTime('dd.mm.yyyy hh:nn:ss', d)
 end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i:Integer;
  sp:TStringStream;
  function crlf:String;
  begin
    result:=chr(13)+chr(10);
  end;
begin
  sp:=TStringStream.Create('');
  sp.WriteString('{'+crlf);
  sp.WriteString('"1111111111",'#13#10);
  sp.WriteString('"2222222222222222", '#13#10);
  sp.WriteString('"44444444444444444", '#13#10);
  sp.WriteString('}');
  ShowMessage(sp.DataString);
  sp.Free;
{
  if dm.CreateTableDvigMens then begin
    DataSource1.DataSet:=dm.tbDvigMens;
    edMemo.Clear;
    for i:=0 to dm.tbDvigMens.Fields.Count-1 do begin
      edMemo.Lines.Add(dm.tbDvigMens.Fields[i].FieldName+'='+dm.getPathField(dm.tbDvigMens.Fields[i]));
    end;
  end else begin
    ShowMessage(dm.getLastError);
  end;
  }
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


end.


