unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, FuncPr, ComObj, QStrings,
  Dialogs, DB, adsdata, adsfunc, adstable, adscnnct, StdCtrls, Buttons,
  Grids, DBGridEh, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    AdsConnection1: TAdsConnection;
    ATE: TAdsTable;
    Categ: TAdsTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    edDebug: TMemo;
    TabSheet2: TTabSheet;
    DBGridEh1: TDBGridEh;
    DataSource1: TDataSource;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    cbAll: TCheckBox;
    edGraf: TEdit;
    cbIndex: TComboBox;
    BitBtn2: TBitBtn;
    cbOnlyActive: TCheckBox;
    AdsConnection2: TAdsConnection;
    AteSys: TAdsTable;
    BitBtn3: TBitBtn;
    cbAllCat: TCheckBox;
    tsAdres: TTabSheet;
    Adresa: TAdsTable;
    DBGridEh2: TDBGridEh;
    DataSource2: TDataSource;
    BitBtn4: TBitBtn;
    edGrafA: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure cbIndexChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;  AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1Columns3GetCellParams(Sender: TObject;   EditMode: Boolean; Params: TColCellParamsEh);
    procedure cbOnlyActiveClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function LoadOneATE(sl:TStringList):Boolean;
    function LoadOneAdres(sl:TStringList; var npp:INteger):Boolean;
    procedure LoadOneCAT(sl:TStringList);
    function DateFromStr(s:String):TDateTime;
    function PathXLS:String;
    function getInt(s:String):String;
    function getInt64(s:String):Int64;

  end;

var
  Form1: TForm1;


implementation

uses StrUtils;

{$R *.dfm}

function TForm1.PathXLS:String;
begin
  Result:='E:\Projects\Selsovet7\_ATE\XLS\';
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  t,n,nn,m,j,mmm,nnn,i,i1,i2,tnCount:Integer;
  arr:Variant;
  XL:Variant;
  lErr,lLoad:Boolean;
  sl:TStringList;
  nCount:Integer;
  v:Variant;
begin
  if not Problem('Загрузить АТЕ ?') then exit;
  Ate.AdsZapTable;
  nCount:=0;
  n:=0;
  m:=0;
  try
    try XL := GetActiveOleObject('Excel.Application');
    except XL := CreateOleObject('Excel.Application');
  end;
    except
      raise Exception.Create('Hе могy запyстить Excel');
  end;

  try
//    xl.Workbooks.Add('E:\Projects\Selsovet7\_ATE\XLS\категории.xls');
    if FileExists(PathXLS+'СОАТО.xls') then begin
      xl.Workbooks.Add(PathXLS+'СОАТО.xls');
    end else if FileExists(PathXLS+'СОАТО.xlsx') then begin
      xl.Workbooks.Add(PathXLS+'СОАТО.xlsx');
    end;
  except
    on E: Exception do begin
      PutError('Ошибка открытия файла'+#13#10+E.Message,self);
      lErr:=true;
      edDebug.Lines.Add(E.Message);
      exit;
    end;
  end;
  lErr:=false;
  try
    arr:=XL.Range[Trim(edGraf.Text)].value;
  except
    on E: Exception do begin
      lErr:=true;
      edDebug.Lines.Add(E.Message);
    end;
  end;
  if lErr then exit;

  sl:=TStringList.Create;
  nn:=0;
  n := VarArrayDimCount(arr);
  if n <> 2 then begin
    lErr:=true;
  end;
  if lErr then exit;
  i1:=VarArrayLowBound(arr,1);
  i2:=VarArrayHighBound(arr,1);
  for i:=i1 to i2 do begin
    mmm:=VarArrayLowBound(arr,2);
    t := VarType(arr[i,mmm+1]);
    if (t=VarNull) or (t=VarEmpty) then begin
      v:=null;
    end else begin
      v:=arr[i,mmm+1];
    end;
    if (v=null) or (trim(vartostr(v))='') then begin
      v:='';
    end else begin
      v:=Trim(VarToStr(arr[i,mmm+1]));
    end;
    if v='' then begin
//      edDebug.Lines.add('строка '+inttostr(i));
      Application.ProcessMessages;
    end else begin
      sl.Clear;
      for j:=mmm to VarArrayHighBound(arr,2) do begin
        sl.Add(arr[i,j]);
      end;
      if LoadOneAte(sl)
        then Inc(nCount,1)
        else Inc(nn,1);
      Label2.Caption:='Пропущено: '+IntToStr(nn);
      Label1.Caption:=IntToStr(nCount);
      Application.ProcessMessages;
    end;
  end;
  sl.Free;

end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  t,n,nn,m,j,mmm,nnn,i,i1,i2,tnCount:Integer;
  arr:Variant;
  XL:Variant;
  lErr,lLoad:Boolean;
  sl:TStringList;
  nCount:Integer;
  npp:Integer;
  v:Variant;
begin
  if not Problem('Загрузить адреса ?') then exit;
  Adresa.AdsZapTable;
  nCount:=0;
  n:=0;
  m:=0;
  try
    try XL := GetActiveOleObject('Excel.Application');
    except XL := CreateOleObject('Excel.Application');
  end;
    except
      raise Exception.Create('Hе могy запyстить Excel');
  end;

  try
//    xl.Workbooks.Add('E:\Projects\Selsovet7\_ATE\XLS\категории.xls');
    if FileExists(PathXLS+'Адреса.xls') then begin
      xl.Workbooks.Add(PathXLS+'Адреса.xls');
    end else if FileExists(PathXLS+'Адреса.xlsx') then begin
      xl.Workbooks.Add(PathXLS+'Адреса.xlsx');
    end;
  except
    on E: Exception do begin
      PutError('Ошибка открытия файла'+#13#10+E.Message,self);
      lErr:=true;
      edDebug.Lines.Add(E.Message);
      exit;
    end;
  end;
  lErr:=false;
  try
    arr:=XL.Range[Trim(edGrafA.Text)].value;
  except
    on E: Exception do begin
      lErr:=true;
      edDebug.Lines.Add(E.Message);
    end;
  end;
  if lErr then exit;

  sl:=TStringList.Create;
  nn:=0;
  n := VarArrayDimCount(arr);
  if n <> 2 then begin
    lErr:=true;
  end;
  if lErr then exit;
  i1:=VarArrayLowBound(arr,1);
  i2:=VarArrayHighBound(arr,1);                    
  npp:=1;  
  for i:=i1 to i2 do begin
    mmm:=VarArrayLowBound(arr,2);
    t := VarType(arr[i,mmm+1]);
    if (t=VarNull) or (t=VarEmpty) then begin
      v:=null;
    end else begin
      v:=arr[i,mmm+1];
    end;
    if (v=null) or (trim(vartostr(v))='') then begin
      v:='';
    end else begin
      v:=Trim(VarToStr(arr[i,mmm+1]));
    end;
    if v='' then begin
//      edDebug.Lines.add('строка '+inttostr(i));
      Application.ProcessMessages;
    end else begin
      sl.Clear;
      for j:=mmm to VarArrayHighBound(arr,2) do begin
        sl.Add(arr[i,j]);
      end;
      if LoadOneAdres(sl,npp)
        then Inc(nCount,1)
        else Inc(nn,1);
      Label2.Caption:='Пропущено: '+IntToStr(nn);
      Label1.Caption:=IntToStr(nCount);
      Application.ProcessMessages;
    end;
  end;
  sl.Free;

end;

//-------------------------------------------------------
function TForm1.DateFromStr(s:String):TDateTime;
var
  nDay,nMonth,nYear:Word;
  i:Integer;
  ss:String;
begin
  Result:=0;
  if Q_CharCount(s,'.')=2 then begin   // типа дата
    i:=Pos(' ',s);
    if i>0 then ss:=Copy(s,1,i-1) else ss:=s;
    try
      nDay:=StrToInt(Q_GetWordN(1,ss,'.'));
      nMonth:=StrToInt(Q_GetWordN(2,ss,'.'));
      nYear:=StrToInt(Q_GetWordN(3,ss,'.'));
      Result:=EncodeDate(nYear,nMonth,nDay);
    except
      edDebug.Lines.Add('Error Date '+ss);
    end;
  end;
end;
//-------------------------------------------------------
function TForm1.LoadOneATE(sl:TStringList):Boolean;
var
  d1,d2:TDateTime;
begin
  Result:=false;
  if ((StrtoInt(sl[6])<241) or cbAllCat.Checked) and ((sl[8]='1') or cbAll.Checked) then begin
    Ate.Append;
    Ate.FieldByName('ID').AsString:=sl[0];
    Ate.FieldByName('KOD').AsString:=sl[1];
    Ate.FieldByName('OBL').AsString:=sl[2];
    Ate.FieldByName('RAION').AsString:=sl[3];
    Ate.FieldByName('NAME').AsString:=sl[4];
    Ate.FieldByName('NAME_B').AsString:=sl[5];
    Ate.FieldByName('CATEGORY').AsString:=sl[6];
    Ate.FieldByName('CENTR').AsString:=sl[7];
//    Ate.FieldByName('PARENTID').AsString:=sl[6];
    Ate.FieldByName('ACTIVE').AsString:=sl[8];
    d1:=DateFromStr(sl[9]);
    d2:=DateFromStr(sl[10]);
    if d1>0 then Ate.FieldByName('DATEIN').AsDateTime:=d1;
    if d2>0 then Ate.FieldByName('DATEOUT').AsDateTime:=d2;
    Ate.Post;
    Result:=true;
  end else begin
    edDebug.Lines.Add('cat='+sl[6]+'   Active='+sl[8]);
  end;
end;

function TForm1.getInt(s:String):String;
var
  n:Integer;
begin
  n:=Pos('.',s);
  if n>0 then begin
    s:=Copy(s,1,n-1);
  end else begin
    n:=Pos(',',s);
    if n>0 then begin
      s:=Copy(s,1,n-1);
    end;
  end;
  Result:=s;
end;

function TForm1.getInt64(s:String):Int64;
begin
  Result:=0;
end;
//-------------------------------------------------------
function TForm1.LoadOneAdres(sl:TStringList; var npp:Integer):Boolean;
var
  d1,d2:TDateTime;
  n:INteger;
begin
  Result:=false;
//  0             1          2          3         4           5            6          7         8           9         10        11
//  ADR_NUM	      UIDREGION	 REGION	    UIDDISTR	DISTR	      SELSOVET_ID	 NAMESS	    CATEGORY	NAME	      SHORTNAME	OBJ_ID	  NAMEOBJECT
//  4540824,0000 	1,0000	   Брестская	158,0000	Столинский	2427,0000	   Рубельский	235,0000	агрогородок	аг.	      2428,0000	Рубель
//  12          13            14            15              16          17        18        19        20        21        22      23      24      25
//  ID_EVA	    ELEMENTTYPЕ	  ELEMENTNAMЕ	  ELEMENTNAM	    PROP_TYPE	  NUM_HOUSE	NUM_CORP	IND_HOUSE	NUM_ROOM	IND_ROOM	REMARK	INDEXES	BCOORD	LCOORD
//  37641,0000	11,0000	      Улица	        50 лет Октября	2,0000	    6,0000						                                                        	51,9737	27,0731
  if sl[0]<>'' then begin
    with Adresa do begin
      Append;
      FieldByName('ADR_NUM').AsString:=sl[0];
      FieldByName('OBJ_ID').AsString:=sl[10];
      FieldByName('OBJ_NAME').AsString:=sl[11];
      FieldByName('ID_EVA').AsString:=sl[12];
      FieldByName('TYPE_EVA_K').AsString:=sl[13];
      FieldByName('TYPE_EVA_N').AsString:=sl[14];
      FieldByName('NAME_EVA').AsString:=sl[15];
      FieldByName('PROP_TYPE').AsString:=getInt(sl[16]);
      FieldByName('NUM_HOUSE').AsString:=getInt(sl[17]);
      FieldByName('NUM_CORP').AsString:=getInt(sl[18]);
      FieldByName('IND_HOUSE').AsString:=getInt(sl[19]);
      FieldByName('NUM_ROOM').AsString:=getInt(sl[20]);
      FieldByName('IND_ROOM').AsString:=getInt(sl[21]);
      FieldByName('REMARK').AsString:=sl[22];
      FieldByName('INDEXES').AsString:=sl[23];

      FieldByName('NPP').AsInteger:=npp;
      Inc(npp,1);
    {
    d1:=DateFromStr(sl[9]);
    d2:=DateFromStr(sl[10]);
    if d1>0 then Ate.FieldByName('DATEIN').AsDateTime:=d1;
    if d2>0 then Ate.FieldByName('DATEOUT').AsDateTime:=d2;
    }
      Post;
    end;
    Result:=true;
  end else begin
//    edDebug.Lines.Add('cat='+sl[6]+'   Active='+sl[8]);
  end;
end;

procedure TForm1.LoadOneCAT(sl:TStringList);
begin
  Categ.Append;
  Categ.FieldByName('KOD').AsString:=sl[0];
  Categ.FieldByName('NAME').AsString:=sl[1];
  Categ.FieldByName('ACTIVE').AsString:=sl[2];
  Categ.FieldByName('FRONT').AsString:=sl[3];
  Categ.FieldByName('NAMEC').AsString:=sl[4];
//  Categ.FieldByName('NAMEB').AsString:=sl[4];
  Categ.Post;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AdsConnection2.IsConnected:=true;
  ateSys.Open;
  AdsConnection1.IsConnected:=true;
  ate.Open;
  cbIndex.ItemIndex:=0;
  ate.IndexName:='KOD_KEY';
  Categ.Open;
  adresa.Open;
  adresa.IndexName:='NPP_KEY';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ate.Close;
  Categ.Close;
  AdsConnection1.IsConnected:=false;
  ateSys.Close;
  AdsConnection2.IsConnected:=false;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex=1
    then DataSource1.DataSet:=ATE
    else DataSource1.DataSet:=nil;
end;

procedure TForm1.cbIndexChange(Sender: TObject);
begin
  case cbIndex.ItemIndex of
   0: ate.IndexName:='KOD_KEY';
   1: ate.IndexName:='ID_KEY';
   2: ate.IndexName:='DATEIN_KEY';
   3: ate.IndexName:='PARENT_KEY';
 end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  sSeek,sBookMark,sSoato,sLastSoato:String;
  m,n,nLastID:Integer;
  sl:TStringList;
  procedure WriteParent;
  begin
    if nLastID>0 then begin
      Ate.Edit;
      Ate.FieldByName('PARENTID').AsInteger:=nLastID;
      Ate.Post;
    end;
  end;
  procedure SeekParent(nCount:Integer);
  begin
    sSeek:=Copy(sSoato,1,nCount)+StringOfChar('0', 10-nCount);
    if (sSeek<>sLastSoato) then begin
      sBookMark:=Ate.Bookmark;
      if Ate.Locate('KOD', sSeek, []) then begin
        nLastID:=Ate.FieldByName('ID').AsInteger;
        sLastSoato:=Ate.FieldByName('KOD').AsString;
      end else begin
        nLastID:=-1;
        sLastSoato:='###';
      end;
      Ate.Bookmark:=sBookMark;
    end;
  end;
begin
  sl:=TStringList.Create;
  sl.CommaText:='1550=1548,1551=1548,1552=1548,1553=1548,1554=1548,1555=1548,1556=1548,'+    //  1548-Микашевичи
                '6684=9393,'+  //  Междуречье-Новополоцк(9393)
                '7688=7686,7689=7686,7690=7686';  //   Дружба(7688),Труд(7689),Школа-Интернат(7690) - Сенно(7686)
  sLastSoato:='###';
  nLastID:=-1;
  Label1.Caption:='';
  Ate.DisableControls;
  Ate.First;
  n:=0;
  try
    while not Ate.Eof do begin
      sSoato:=Ate.FieldByName('KOD').AsString;
      if Copy(sSoato,2,9)='000000000' then begin // область
        sLastSoato:=sSoato;
        nLastID:=Ate.FieldByName('ID').AsInteger;
      end else if Copy(sSoato,5,6)='000000' then begin // район, крупный город
        if sLastSoato=Copy(sSoato,1,1)+'000000000' then begin
          WriteParent;
        end else begin
          SeekParent(1);
          WriteParent;
        end;
      end else if Copy(sSoato,8,3)='000' then begin // малы город, сельсовет
        SeekParent(4);
        WriteParent;
      end else if Copy(sSoato,5,3)='700' then begin // деревня подчиненная району   -> 2236700006-Барсуки
        SeekParent(4);
        WriteParent;
      end else begin   // деревня
        SeekParent(7);
        WriteParent;
      end;
      if Ate.FieldByName('PARENTID').AsInteger=0 then begin
        Ate.Edit;
        Ate.FieldByName('PARENTID').AsString:=sl.Values[Ate.FieldByName('ID').AsString];
        Ate.Post;
      end;
      Ate.Next;
      Inc(n,1);
      Label1.Caption:=IntToStr(n);
      Application.ProcessMessages;
    end;
  finally
    Ate.First;
    Ate.EnableControls;
    sl.Free;
  end;
end;

procedure TForm1.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
          AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if Copy(Ate.FieldByName('KOD').AsString,2,9)='000000000' then begin
    AFont.Style:=[fsBold];
    Background:=clSkyBlue;
  end else if Copy(Ate.FieldByName('KOD').AsString,5,6)='000000' then begin
    Background:=clSkyBlue;
  end else if Copy(Ate.FieldByName('KOD').AsString,8,6)='000' then begin
    Background:=clInfoBk;
  end;
  if Ate.FieldByName('ACTIVE').AsString<>'1' then begin
    AFont.Style:=[fsUnderline];
  end;
end;
//--------------------------------------------------------------
procedure TForm1.DBGridEh1Columns3GetCellParams(Sender: TObject;  EditMode: Boolean; Params: TColCellParamsEh);
begin
//
end;

procedure TForm1.cbOnlyActiveClick(Sender: TObject);
begin
  if cbOnlyActive.Checked then begin
    ate.Filter:=' active=''1'' ';
    ate.Filtered:=true;
  end else begin
    ate.Filtered:=false;
    ate.Filter:='';
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  n:Integer;
begin
//
  ate.DisableControls;
  ate.First;
  label1.Caption:='';
  n:=0;
  while not Ate.Eof do begin
{     KOD Char( 10 ),
      NAME CIChar( 80 ),
      NAME_B CIChar( 80 ),
      ATE_PARENTID Integer,
      ATE_ID Integer,
      DATEIN Date,
      DATEOUT Date,
      CATEGORY Integer,
      NAMEC CIChar( 10 ),
      NAMEC_B CIChar( 10 ),
      FRONT Integer) IN DATABASE;  }
    AteSys.Append;
    AteSys.FieldByName('ATE_ID').AsString:=Ate.FieldByName('ID').AsString;
    AteSys.FieldByName('ATE_PARENTID').AsString:=Ate.FieldByName('PARENTID').AsString;
    AteSys.FieldByName('KOD').AsString:=Ate.FieldByName('KOD').AsString;
    AteSys.FieldByName('NAME').AsString:=Ate.FieldByName('NAME').AsString;
    AteSys.FieldByName('NAME_B').AsString:=Ate.FieldByName('NAME_B').AsString;
    AteSys.FieldByName('CATEGORY').AsString:=Ate.FieldByName('CATEGORY').AsString;
    AteSys.FieldByName('DATEIN').Value:=Ate.FieldByName('DATEIN').Value;
    AteSys.FieldByName('DATEOUT').Value:=Ate.FieldByName('DATEOUT').Value;
    AteSys.FieldByName('CATEGORY').AsString:=Ate.FieldByName('CATEGORY').AsString;
    if Categ.Locate('KOD', Ate.FieldByName('CATEGORY').AsInteger, []) then begin
      AteSys.FieldByName('NAMEC').AsString:=Categ.FieldByName('NAMEC').AsString;
      AteSys.FieldByName('NAMEC_B').AsString:=Categ.FieldByName('NAMEC_B').AsString;
      AteSys.FieldByName('FRONT').AsString:=Categ.FieldByName('FRONT').AsString;
    end;
//    AteSys.FieldByName('CATEGORY').AsString:=Ate.FieldByName('CATEGORY').AsString;
    AteSys.Post;
    n:=n+1;
    ate.Next;
    label1.Caption:=inttostr(n);
    Application.ProcessMessages;
  end;
  ate.First;
  ate.EnableControls;

end;


end.


