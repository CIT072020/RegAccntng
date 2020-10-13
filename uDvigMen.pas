unit uDvigMen;
{
   доделать отмечено знаком ###
}
interface

{$I Task.inc}

{$DEFINE SYNA}

uses
  Windows, SysUtils, Math, Classes, Forms, SasaINiFile, Db, NativeXML,
  superobject, supertypes, superdate,
  {$IFDEF SYNA} httpsend,  {$ENDIF}
  kbmMemTable, DbFunc, FuncPr;

const
  RESOURCE_MOVEMENTS=1;
  RESOURCE_GETDOC=2;
  RESOURCE_SAVEDOC=3;

  DEF_HOST = 'https://a.todes.by';
  DEF_PORT = '13555';
  DEF_Movements = '/cxf/vcouncil/movements';
  DEF_getDoc    = '/cxf/vcouncil';
  DEF_saveDoc   = '/cxf/vcouncil';

  TEXT_NOT=0;
  TEXT_ERROR=1;
  TEXT_OK=2;

type

  ateAdres=record
   dsdAddressLiveBase: String; //"dsdAddressLive",
   pid  : SuperInt;
   house: String;
   korps: String;
   app  : String;
   ateObjectNum: SuperInt;
   ateElementUid: SuperInt;
   ateAddrNum: SuperInt;
  end;

  TDvigMen = class(TObject)
  private
    FLastError:String;
    FShowError:Boolean;
    FShowMessage:Boolean;
    FListObject:TStringList;
    FEnableTextLog:Boolean;
    FEnableLocalLog:Boolean;
    FDebug:Boolean;
    FTimeOut:Integer;
    FHost: String;
    FPort: String;
    FPathIni: String;
    FFileIni:String;
    FFileLog:String;
    FResource_Movements: String;
    FResource_getDoc: String;
    FResource_saveDoc: String;
    FIsEnabled: Boolean;
    FIsActive: Boolean;
    FMessageSource: String;
    FActiveETSP: Boolean;
    FPostUserName: Boolean;
    FIsDebug: Boolean;
    FCharUpper:Boolean;
    procedure SetPathIni(const Value: String);
    procedure SetIsActive(const Value: Boolean);
    procedure SetIsEnabled(const Value: Boolean);
    procedure SetMessageSource(const Value: String);
    procedure SetActiveETSP(const Value: Boolean);
    procedure SetPostUserName(const Value: Boolean);
    procedure SetIsDebug(const Value: Boolean);
  public
    LocalLog:TStringList;
    Meta:TSasaIniFile;
    tbMovements:TDataSet;
    tbDvigMens:TDataSet;
    tbChild:TDataSet;
    property IsActive:Boolean read FIsActive write SetIsActive;
    property IsEnabled:Boolean read FIsEnabled write SetIsEnabled;
    property IsDebug:Boolean read FIsDebug write SetIsDebug;
    property PostUserName:Boolean read FPostUserName write SetPostUserName;
    property ActiveETSP:Boolean read FActiveETSP write SetActiveETSP;
    property MessageSource:String read FMessageSource write SetMessageSource;
    property PathIni:String read FPathIni write SetPathIni;
    property TimeOut:Integer read FTimeOut write FTimeOut;
    property EnableTextLog:Boolean  read FEnableTextLog write FEnableTextLog;

    procedure WriteDebugFile(sFileName:String; sText:String);
    procedure WriteTextLog(sOper:String; nType:Integer);
    procedure ShowError(sErr:String);
    procedure CheckSizeFileLog(nSizeMB:Integer);
    function CT(s:String):String;
    function getResource(nType:Integer): String;
    function getURL(nType:Integer): String;

    function getMovements(slPar:TStringList): Boolean;
    function getDoc(slPar:TStringList): Boolean;
    function saveDoc(slPar:TStringList; dsDoc:TDataSet; dsChild:TDataSet): Boolean;
    function getIDSave(dsDoc:TDataSet): String;

    function createSpr(nType:Integer; nValue:Int64):String;
    function createGrag(nGrag:Integer):String;

    function createPol(sPol:String):String;
    function decodePol(nPol:SuperInt):String;

    function createJavaDate(d:TDateTime):SuperInt;
    function createISODate(d:TDateTime):String;
    function decodeDate(sDate:String; var sErr:String):TDateTime;
    function decodeDateS(sDate:String; var nType:Integer; var sErr:String):TDateTime;

    function createCountry(nGosud:Integer):String;
    function createObl(sObl:String; fldType:TField):String;
    function createTypeCity(nType:Integer):String;
    function createTypeDoc(nType:Integer):String;
    function createObraz(nValue:Integer):String;
    function createSem(nValue:Integer):String;
    function CheckUP(s:String):String;

    function CreatePar(slPar:TstringList; slHeader:TStringList):String;
    function ReadParams:Boolean;
    function CreateMemTable(sTableName:String;  sMetaTable:String; AutoCreate, AutoOpen: Boolean): TDataSet;
    function getPathField(fld:TField):String;
    function GetFieldSize(sLen:String):Integer;
    procedure ClearMemTable(tb:TDataSet);
    function CreateTableMovements:Boolean;
    function CreateTableDvigMens:Boolean;
    function GetLastError:String;

    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses StrUtils;

{ TDvigMen }
const
  FILE_NAME = 'dvigmen.ini';
  LOG_FILE  = 'dvigmen';

//-------------------------------------------------------------------------------------
constructor TDvigMen.Create;
var
  strFile:String;
  Ini:TSasaIniFile;
begin
  FListObject:=TStringList.Create;
  FLastError:='';
  tbMovements:=nil;
  tbDvigMens:=nil;
  tbChild:=nil;
  FEnableTextLog:=true;
  FEnableLocalLog:=false;
  LocalLog:=TStringList.Create;
  FCharUpper:=true;
  FShowError:=true;
  FShowMessage:=true;
  FDebug:=true;
  FTimeOut:=0;
  FHost:='http://www.todes.by';
  FPort:='8086';
  FResource_Movements:='/cxf/vcouncil/movements';
  FResource_getDoc:='/cxf/vcouncil';
  FResource_saveDoc:='/cxf/vcouncil';

  {$IFDEF TEST_SO}
    FPathINI:=CheckSleshN(ExtractFilePath(Application.ExeName));
  {$ELSE}
    FPathINI:=CheckSleshN(GlobalTask.PathServiceMain);
  {$ENDIF}
  strFile:=FPathINI+FILE_NAME;
  if FileExists(strFile) then begin
    Ini:=TSasaIniFile.Create( strFile );
    // взять файл с настройками на локальном компьютере
    if ini.ReadString('ADMIN', 'LOCAL', '0')='1' then begin
      {$IFDEF TEST_SO}
        FPathINI:=CheckSleshN(ExtractFilePath(Application.ExeName));
      {$ELSE}
        FPathINI:=CheckSleshN(GlobalTask.PathService);
      {$ENDIF}
      if not FileExists(FPathINI+FILE_NAME) then begin
        CopyFile(PChar(strFile), PChar(FPathINI+FILE_NAME),false);
      end;
    end;
    ini.Free;
  end;
  FFileIni:=FPathINI+FILE_NAME;
  FFileLog:=CheckSleshN(ExtractFilePath(Application.ExeName))+'dvigmen.log';
  Meta:=TSasaIniFile.Create(FPathINI+'dvigmen_meta.ini');
  ReadParams;
end;
//-------------------------------------------------------------------------------------
destructor TDvigMen.Destroy;
var
  i,n:Integer;
begin
  for i:=0 to FListObject.Count-1 do begin
    try
      if FListObject.Objects[i] is TDataSet then begin
        TDataSet(FListObject.Objects[i]).Close;
        n:=TDataSet(FListObject.Objects[i]).Tag;
        if TObject(n) is TStringList then begin
          TStringList(n).Free;
        end;
      end;
      FListObject.Objects[i].Free;
    except
    end;
  end;
  FListObject.Free;
  LocalLog.Free;
  Meta.Free;
  inherited;
end;
//---------------------------------------------
function TDvigMen.CreateTableMovements:Boolean;
begin
  Result:=true;
  if tbMovements=nil then begin
    tbMovements:=CreateMemTable('tbMovements', 'TABLE_MOVEMENTS', true, true);
    if (tbMovements=nil) then Result:=false;
  end;
end;
//---------------------------------------------
function TDvigMen.CreateTableDvigMens:Boolean;
begin
  Result:=true;
  if tbDvigMens=nil then begin
    tbDvigMens:=CreateMemTable('tbDvigMens', 'TABLE_DVIGMEN', true, true);
    if (tbDvigMens=nil) then Result:=false;
  end;
  if tbChild=nil then begin
    tbChild:=CreateMemTable('tbChild', 'TABLE_CHILD', true, true);
    if (tbChild=nil) then Result:=false;
  end;
end;
//---------------------------------------------
procedure TDvigMen.ClearMemTable(tb:TDataSet);
begin
  TkbmMemTable(tb).EmptyTable;
end;
//---------------------------------------------
function TDvigMen.GetFieldSize(sLen:String):Integer;
begin
  if sLen='' then begin
    Result:=0
  end else begin
    if IsAllDigit(sLen) then begin
      Result:=StrToIntDef(sLen,0);
    end else begin
      Result:=Meta.ReadInteger('CONST', sLen,0);
    end;
  end;
end;
//---------------------------------------------
function TDvigMen.getPathField(fld:TField):String;
var
  n:Integer;
begin
  Result:='';
  if (fld.DataSet.Tag>0) and (TObject(fld.DataSet.Tag) is TStringList) then begin
    n:=TStringList(fld.DataSet.Tag).IndexOfName(fld.FieldName);
    if n>-1 then begin
      Result:=TStringList(fld.DataSet.Tag).ValueFromIndex[n];
    end;
  end;
end;
//---------------------------------------------
function TDvigMen.CreateMemTable(sTableName:String; sMetaTable:String; AutoCreate, AutoOpen: Boolean): TDataSet;
var
   I,n,m: Integer;
   FieldName,s,sOpis,sKomm: string;
   FieldType: TFieldType;
   FieldSize: Integer;
   FieldDef: TFieldDef;
   tb:TkbmMemTable;
   arr, arrFields:TArrStrings;
   sl,slAdd:TStringList;
   lErr:Boolean;
   fld:TField;
begin
   FLastError:='';
   Result:=nil;
   lErr:=true;
   sl:=TStringList.Create;
   slAdd:=TStringList.Create;
   Meta.ReadSectionValues(sMetaTable, sl);
   if sl.Count>0 then begin
     tb:=TkbmMemTable.Create(nil);
     tb.Name:=sTableName;
     tb.Tag:=Integer(slAdd);
     for I:=0 to sl.Count-1  do begin
       FieldName:=sl.Names[i];
       s:=sl.ValueFromIndex[i];
       n:=Pos('|',s);
       if n=0 then begin
         sOpis:=Trim(s);
         sKomm:='';
       end else begin
         sOpis:=Trim(Copy(s,1,n-1));
         sKomm:=Copy(s,n+1,Length(s));
         n:=Pos('[',sKomm);
         m:=PosEx(']',sKomm,n+1);
         if (n>0) and (m>0)
           then sKomm:=Trim(Copy(sKomm,n+1,m-n-1))
           else sKomm:='';
       end;
       StrToArr(sOpis, arr,',',false);
       SetLength(arr,2);
       FieldSize:=0;
       if StringToFieldType(arr[0], FieldType) then begin
         lErr:=false;
         FieldSize:=GetFieldSize(arr[1]);
         FieldDef:=tb.FieldDefs.AddFieldDef;
         FieldDef.Name:=FieldName;
         FieldDef.DataType:=FieldType;
         if FieldType<>ftBoolean then
           FieldDef.Size:=FieldSize;
         if (FieldDef.DataType=ftString) and (FieldSize=0) then begin
           FLastError:=sl.Strings[i];
           lErr:=true;
           tb.Free;
           break;
         end;
         if sKomm<>'' then begin
           slAdd.Add(FieldDef.name+'='+sKomm);
         end;
       end else begin
         FLastError:=sl.Strings[i];
         lErr:=true;
         tb.Free;
         break;
       end;
     end;
   end else begin
     FLastError:='Описание не найдено '+sMetaTable;
   end;
   if not lErr then begin
     if AutoCreate then tb.CreateTable;
     if AutoOpen   then tb.Open;
     Result:=tb;
     FListObject.AddObject(sTableName, tb);
   end;
   sl.Free;
end;
//----------------------------------------------------------------
{
procedure CreateAndCopyMemTable(Src: TDataSet; Dst: TkbmMemTable);
var
   I: Integer;
   Field: TField;
   FieldDef: TFieldDef;
begin
   Dst.FieldDefs.Clear;
   for I:=0 to Pred(Src.Fields.Count) do begin
      Field:=Src.Fields[I];
      FieldDef:=Dst.FieldDefs.AddFieldDef;
      FieldDef.Name:=Field.FieldName;
      FieldDef.DataType:=Field.DataType;
      FieldDef.Size:=Field.Size;
      if Field is TFloatField then begin
         FieldDef.Precision:=TFloatField(Field).Precision;
      end;
   end;
   Dst.CreateTable;
   Dst.Open;
   Src.First;
   while not Src.Eof do begin
      Dst.Append;
      for I:=0 to Pred(Src.Fields.Count) do begin
         Dst.Fields[I].AsString:=Src.Fields[I].AsString;
      end;
      Dst.Post;
      Src.Next;
   end;
end;
}
//-------------------------------------------------------------------------------------
// Контроль и преобразование названия ТЕГА
function TDvigMen.CT(s:String):String;
begin
  Result:=s;
end;
//-------------------------------------------------------------------------------------
procedure TDvigMen.WriteTextLog(sOper:String; nType:Integer);
var
  s:String;
begin
  if nType=TEXT_ERROR
    then s:='ОШИБКА: '+sOper
    else s:=sOper;
  if FEnableTextLog then begin
    try
      WriteStringLog(StringReplace(s, #13#10, ', ', [rfReplaceAll]), FFileLog);
    except
    end;
  end;
  if FEnableLocalLog then begin
    LocalLog.Add(s);
  end;
  if FShowError and (nType=TEXT_ERROR) then begin
    PutError(s);
  end;
  if FShowMessage and (nType=TEXT_OK) then begin
    ShowMessageCont(s,nil);
  end;
end;
procedure TDvigMen.ShowError(sErr:String);
begin
  if FShowError then begin
    PutError(sErr);
  end;
end;
//-------------------------------------------------------------------------------------
procedure TDvigMen.CheckSizeFileLog(nSizeMB:Integer);
begin
  if FEnableTextLog then begin
    CheckSizeLog(FFileLog,nSizeMB);
  end;
end;

procedure TDvigMen.SetPathIni(const Value: String);
begin
  FPathIni := Value;
end;

//-------------------------------------------------------
function TDvigMen.getResource(nType:Integer): String;
begin
  Result:='';
  case nType of
    RESOURCE_MOVEMENTS: Result:=FResource_Movements;
    RESOURCE_GETDOC   : Result:=FResource_getDoc;
    RESOURCE_SAVEDOC  : Result:=FResource_saveDoc;
  end;
end;
//-------------------------------------------------------
function TDvigMen.getURL(nType:Integer): String;
begin
  Result:=FHost+':'+FPort;
  case nType of
    RESOURCE_MOVEMENTS: Result:=Result+FResource_Movements;
    RESOURCE_GETDOC   : Result:=Result+FResource_getDoc;
    RESOURCE_SAVEDOC  : Result:=Result+FResource_saveDoc;
  end;
end;
//-------------------------------------------------------
function TDvigMen.CreatePar(slPar:TStringList; slHeader:TStringList):String;
var
  i:Integer;
begin
  Result:='';
  if (slPar<>nil) and (slPar.Count>0) then begin
    Result:='?';
    for i:=0 to slPar.Count-1 do begin
      Result:=Result+slPar.Strings[i]+'&';
    end;
    Result:=Copy(Result,1,Length(Result)-1);
  end;
end;
//-------------------------------------------------------
procedure TDvigMen.WriteDebugFile(sFileName:String; sText:String);
begin
  if FDebug
    then MemoWrite(sFileName,sText);
end;
//-------------------------------------------------------
function TDvigMen.getMovements(slPar:TStringList): Boolean;
var
  sURL,sPar:String;
  HTTP:THTTPSend;
  sl:TStringList;
  SStrm:TStringStream;
  sResponse:String;
  new_obj, obj: ISuperObject;
  sw:WideString;
  i:Integer;
  lOk:Boolean;
begin
  FLastError:='';
  sURL:=getURL(RESOURCE_MOVEMENTS);
  sl:=TStringList.Create;
  SStrm:=TStringStream.Create('');
//  HttpGetBinary(edURL.text,SStrm);
  HTTP:=THTTPSend.Create;
  sPar:=CreatePar(slPar,HTTP.Headers);
  sResponse:='';
  try
    Result:=HTTP.HTTPMethod('GET', sURL+sPar);
//    HeadersToList(Headers);
    if Result then begin
      SStrm.Seek(0, soFromBeginning);
      SStrm.CopyFrom(HTTP.Document, 0);
      sResponse:=SStrm.DataString;
      if (HTTP.ResultCode<200) or (HTTP.ResultCode>=400) then begin
        Result:=false;
        FLastError:=HTTP.Headers.Text;
      end;
    end else begin
      FLastError:=inttostr(HTTP.sock.LastError)+' '+HTTP.sock.LastErrorDesc;
    end;
  finally
    HTTP.Free;
  end;
  if not Result then begin
    WriteTextLog(FLastError, TEXT_ERROR);
  end else begin
    sw:=Utf8Decode(sResponse);
  //  sw:=Utf8ToAnsi(s);
    lOk:=true;
    try
      new_obj:=so(sw);
    except
      on E:Exception do begin
        lOK:=false;
        WriteTextLog('невозможно разобрать ответ сервера getMovements:'#13#10+Utf8ToAnsi(sResponse), TEXT_ERROR);
      end;
    end;
    if lOk and (new_obj<>nil) and (new_obj.DataType=stArray) then begin  // должен вернуться массив ИН
      WriteDebugFile('_getMovements.json',Utf8ToAnsi(sResponse));
      if CreateTableMovements then begin
        ClearMemTable(tbMovements);
        for i:=0 to new_obj.AsArray.Length-1 do begin
          obj:=new_obj.AsArray.O[i];
          tbMovements.Append;
          tbMovements.FieldByName('PID').AsString:=obj.S[CT('pid')];
          tbMovements.FieldByName('IDENTIF').AsString:=obj.S[CT('identif')];
          tbMovements.FieldByName('DATEREC').AsDateTime:=sdDateTimeFromString(obj.S[CT('dateRec')], false);
          tbMovements.FieldByName('ORG_WHERE_TYPE').AsString:=obj.O[CT('sysOrganWhere')].O[CT('klUniPK')].S[CT('type')];
          tbMovements.FieldByName('ORG_WHERE_CODE').AsString:=obj.O[CT('sysOrganWhere')].O[CT('klUniPK')].S[CT('code')];
          tbMovements.FieldByName('ORG_WHERE_NAME').AsString:=obj.O[CT('sysOrganWhere')].S[CT('lex1')];
          tbMovements.FieldByName('ORG_FROM_TYPE').AsString:=obj.O[CT('sysOrganFrom')].O[CT('klUniPK')].S[CT('type')];
          tbMovements.FieldByName('ORG_FROM_CODE').AsString:=obj.O[CT('sysOrganFrom')].O[CT('klUniPK')].S[CT('code')];
          tbMovements.FieldByName('ORG_FROM_NAME').AsString:=obj.O[CT('sysOrganFrom')].S[CT('lex1')];
          tbMovements.Post;
        end;
      end else begin
        Result:=false;
      end;
    end else begin
      Result:=false;
    end;
    new_obj:=nil;
  end;
  sl.Free;
  SStrm.Free;
end;
//-------------------------------------------------------
function TDvigMen.getDoc(slPar:TStringList): Boolean;
var
  sErr,sURL,sPar:String;
  HTTP:THTTPSend;
  sl, slHeader:TStringList;
  SStrm:TStringStream;
  sFld,sPath,sResponse:String;
  new_obj, obj: ISuperObject;
  sw:WideString;
  nSpr,n,i,j:Integer;
  slFld:TStringList;
  lOk:Boolean;
  d:TDateTime;
begin
  FLastError:='';
  sURL:=getURL(RESOURCE_GETDOC);
  slHeader:=TStringList.Create;
  sl:=TStringList.Create;
  SStrm:=TStringStream.Create('');
//  HttpGetBinary(edURL.text,SStrm);
  HTTP:=THTTPSend.Create;
  sPar:=CreatePar(slPar,HTTP.Headers);
  try
    Result:=HTTP.HTTPMethod('GET', sURL+sPar);
//    HeadersToList(Headers);
    if Result then begin
      SStrm.Seek(0, soFromBeginning);
      SStrm.CopyFrom(HTTP.Document, 0);
      sResponse:=SStrm.DataString;
      if (HTTP.ResultCode<200) or (HTTP.ResultCode>=400) then begin
        Result:=false;
        FLastError:=HTTP.Headers.Text;
      end;
    end else begin
      FLastError:=inttostr(HTTP.sock.LastError)+' '+HTTP.sock.LastErrorDesc;
    end;
  finally
    HTTP.Free;
  end;
  if not Result then begin
    WriteTextLog(FLastError, TEXT_ERROR);
  end else begin
    sw:=Utf8Decode(sResponse);
  //  sw:=Utf8ToAnsi(s);
    lOk:=true;
    try
      new_obj:=so(sw);
    except
      on E:Exception do begin
        lOK:=false;
        WriteTextLog('невозможно разобрать ответ сервера getDoc:'#13#10+Utf8ToAnsi(sResponse), TEXT_ERROR);
      end;
    end;
    if lOk and (new_obj<>nil) and (new_obj.DataType=stArray) then begin  // должен вернуться массив ИН
      WriteDebugFile('_getDoc.json',Utf8ToAnsi(sResponse));
      if CreateTableDvigMens then begin
        ClearMemTable(tbDvigMens);
        ClearMemTable(tbChild);
        for i:=0 to new_obj.AsArray.Length-1 do begin
          obj:=new_obj.AsArray.O[i];
          slFld:=TStringList(tbDvigMens.Tag);
          tbDvigMens.Append;
          with tbDvigMens do begin
            for j:=0 to slFld.Count-1 do begin
              sFld:=slFld.Names[j];
              sPath:=slFld.ValueFromIndex[j];
              if sPath<>'' then begin
                n:=Pos(':',sPath);
                nSpr:=0;
                if n>0 then begin
                  nSpr:=StrToIntDef(Copy(sPath,n+1,Length(sPath)),0);
                  sPath:=Copy(sPath,1,n-1);
                end;
                try
                  case FieldByName(sFld).DataType of
                    ftBoolean : FieldByName(sFld).AsBoolean:=obj.B[sPath];
                    ftInteger,ftSmallint,ftWord
                              : FieldByName(sFld).AsInteger:=obj.I[sPath];
                    ftDate,ftDateTime : begin
                                          d:=decodeDate(obj.S[sPath], sErr);
                                          if sErr<>'' then  WriteTextLog('ОШИБКА - getDoc "'+sPath+'" '+sErr, 0);
                                          if (d>0) then FieldByName(sFld).AsDateTime:=d;   // дата не пустая
                                        end;
                  else
                    FieldByName(sFld).AsString:=obj.S[sPath];
                  end;
                except
                  on E:Exception do begin
                    WriteTextLog('ОШИБКА - getDoc "'+sPath+'" '+E.Message, 0);
                  end;
                end;
              end;
            end;
            //---- дополнительная обработка --------------
            d:=decodeDateS(FieldByName('BDATE').AsString, n, sErr);
            if sErr<>'' then WriteTextLog('ОШИБКА - getDoc "bdate" '+sErr, 0);
            if (d>0) and (n=8)  then FieldByName('DATER').AsDateTime:=d;   // дата не пустая и она полная
            d:=decodeDateS(FieldByName('deathDate').AsString, n, sErr);
            if sErr<>'' then WriteTextLog('ОШИБКА - getDoc "deathDate" '+sErr, 0);
            if (d>0) and (n=8)  then FieldByName('DATES').AsDateTime:=d;
            //-------------------------------------------
          end;
          tbDvigMens.Post;
        end;
      end else begin
        Result:=false;
      end;
    end else begin
      Result:=false;
    end;
    new_obj:=nil;
  end;
  slHeader.Free;
  sl.Free;
  SStrm.Free;
end;
//-------------------------------------------------------
function TDvigMen.getIDSave(dsDoc:TDataSet): String;
begin
  Result:=dsDoc.FieldByName('FAMILIA').AsString+' '+dsDoc.FieldByName('NAME').AsString+' '+dsDoc.FieldByName('OTCH').AsString;
//  Result:='test_id';   // доделать ###
end;
//-------------------------------------------------------
function TDvigMen.createSpr(nType:Integer; nValue:Int64):String;
begin
  Result:=Format('{ "klUniPK": { "type": %d, "code": %d } }', [nType, nValue]);
end;
//-------------------------------------------------------
function TDvigMen.createGrag(nGrag:Integer):String;
begin
// ### поиск sGrag в справочнике стран (СпрСтран) по полю ID и возврат поля AC_MIGR
  nGrag:=11200001;
  Result:=createSpr(8,nGrag);
end;
//-------------------------------------------------------
function TDvigMen.createPol(sPol:String):String;
var
  n:Int64;
begin
  if sPol='Ж'  then n:=21000002  else n:=21000001;
  Result:=createSpr(32, n);
end;
//-------------------------------------------------------
function TDvigMen.decodePol(nPol:SuperInt):String;
begin
  if nPol=21000002 then Result:='Ж' else Result:='М';
end;
//-------------------------------------------------------
function TDvigMen.createJavaDate(d:TDateTime):SuperInt;
begin
  Result:=DelphiToJavaDateTime(d);
end;
//-------------------------------------------------------
function TDvigMen.createISODate(d:TDateTime):String;
begin
  Result:=DelphiDateTimeToISO8601DateWithTimeZone(d, nil);
end;
//-------------------------------------------------------
function TDvigMen.decodeDate(sDate:String; var sErr:String):TDateTime;
begin
  sErr:='';
  if (sDate='') or (sDate='null') then begin
    Result:=0;
  end else begin
    try
      if IsAllDigit(sDate) then begin
        Result:=JavaToDelphiDateTime(StrToInt64(sDate))
      end else begin
        if not ISO8601DateToDelphiDateTime(sDate, Result)
          then Result:=0;
      end;
    except
      on E:Exception do begin
        sErr:='преобразование даты из'+sDate;
      end;
    end;
  end;
end;
//-------------------------------------------------------
function TDvigMen.decodeDateS(sDate:String; var nType:Integer; var sErr:String):TDateTime;
begin
  Result:=0;
  sErr:='';
  nType:=Length(sDate);
  try
    case nType of
      8 : begin       // YYYYMMDD
            Result:=STOD(sDate,tdClipper);
          end;
      6 : begin       // YYYYMM
            Result:=STOD(Copy(sDate,1,6)+'15',tdClipper);
          end;
      4 : begin       // YYYY
            Result:=STOD(Copy(sDate,1,4)+'0701',tdClipper);
          end;
    end;
  except
    on E:Exception do begin
      sErr:='преобразование даты из'+sDate;
    end;
  end;
end;
//-------------------------------------------------------
function TDvigMen.createCountry(nGosud:Integer):String;
var
  n:Int64;
begin
  // nGosud код из SysSpr.СпрСтран
  nGosud:=11200001;      // ###
  n:=nGosud;
  Result:=createSpr(8, nGosud);
end;
//-------------------------------------------------------
function TDvigMen.createObl(sObl:String; fldType:TField):String;
begin
  if sObl='' then begin
    Result:='';
  end else begin
    if fldType.IsNull then begin
      Result:=sObl;
    end else if fldType.AsBoolean=true then begin
      Result:=sObl+' область';
    end else begin
      Result:=sObl+' край';
    end;
  end;
  Result:=CheckUP(Result);
end;
//-------------------------------------------------------
function TDvigMen.createTypeCity(nType:Integer):String;
begin
  // nType код из SysSpr.TypePunkt
  nType:=11100009;
  Result:=createSpr(35, nType);  // ###
end;
//-------------------------------------------------------
function TDvigMen.createTypeDoc(nType:Integer):String;
var
  n:Int64;
begin
// ### поиск sType в справочнике SprTypeDok (типов документов) KOD_GISUN
  n:=54100015;      // 54100001-паспорт гр РБ
  Result:=createSpr(37, n);
end;
//-------------------------------------------------------
function TDvigMen.createObraz(nValue:Integer):String;
begin
  if (nValue>6) then nValue:=0;
  Result:=createSpr(502, nValue);
end;
//-------------------------------------------------------
function TDvigMen.createSem(nValue:Integer):String;
begin
  Result:=createSpr(501, nValue);
end;
//-------------------------------------------------------
function TDvigMen.CheckUP(s:String):String;
begin
  if FCharUpper
    then Result:=ANSIUpperCase(s)
    else Result:=s;
end;
//-------------------------------------------------------
function TDvigMen.saveDoc(slPar:TStringList; dsDoc:TDataSet; dsChild:TDataSet): Boolean;
var
  spDoc:TStringStream;
  smesh,s,sURL,sPar,sss,sF:String;
  HTTP:THTTPSend;
  sl, slHeader:TStringList;
  sStrm,sStrmG:TStringStream;
  sFld,sPath,sPostDoc,sResponse,sError,sStatus,sId:String;
  new_obj, obj: ISuperObject;
  sw:WideString;
  nSpr,n,i,j:Integer;
  slFld:TStringList;
  lOk:Boolean;
  ws:WideString;
  nType:SuperInt;
  function getFld(sField:String):String;
  begin Result:=CheckUP(dsDoc.FieldByName(sField).AsString); end;
  function getFldD(sField:String):TDateTime;
  begin Result:=dsDoc.FieldByName(sField).AsDateTime; end;
  function getFldI(sField:String):Integer;
  begin Result:=dsDoc.FieldByName(sField).AsInteger; end;
  procedure addstd(ss1,ss2:String);
  begin
    spDoc.WriteString(smesh+'"'+ss1+'": '+ss2+','#13#10);
  end;
  procedure addstdS(ss1,ss2:String);
  begin
    if ss2='' then ss2:='null' else ss2:='"'+ss2+'"';
    spDoc.WriteString(smesh+'"'+ss1+'": '+ss2+','#13#10);
  end;
  procedure addDJ(ss1:String; dValue:TDateTime);
  begin
    if dValue=0 then sss:='null' else sss:=IntToStr(createJavaDate(dValue));
    spDoc.WriteString(smesh+'"'+ss1+'": '+sss+','#13#10);
  end;
begin
  smesh:='';
  FLastError:='';
  sURL:=getURL(RESOURCE_SAVEDOC);
  slHeader:=TStringList.Create;
  sl:=TStringList.Create;
  HTTP:=THTTPSend.Create;
  HTTP.Headers.Clear;
  sPar:=CreatePar(slPar,slHeader);
  HTTP.Headers.Add('sign:amlsnandwkn&@871099udlaukbdeslfug12p91883y1hpd91h');
  HTTP.Headers.Add('certificate:109uu21nu0t17togdy70-fuib');
  HTTP.MimeType:='application/json;charset=UTF-8';

//  ws:=UTF8Decode(sPostDoc);
// Max значение int64 = 9223372036854775807

  spDoc:=TStringStream.Create('');
  spDoc.WriteString('{'#13#10);
  smesh:='  ';
  addstd( 'view', createSpr(-3, 10));
  addstd( 'sysDocType', createSpr(-2, 8));
  addstdS('identif', getFld('LICH_NOMER'));
  addstdS('surname', getFld('FAMILIA'));
  addstdS('name', getFld('NAME'));
  addstdS('sname', getFld('OTCH'));
  addstd('surnameBel', 'null');         //###
  addstd('nameBel', 'null');         //###
  addstd('snameBel', 'null');   //###
  addstd('surnameEn', 'null');         //###
  addstd('nameEn', 'null');         //###
  {
  addstdS('surnameBel', 'КРЫ');         //###
  addstdS('nameBel', 'РАДЖЭШ');         //###
  addstdS('snameBel', 'КУТРАПАНСАН');   //###
  addstdS('surnameEn', 'CREE');         //###
  addstdS('nameEn', 'RAJESH');         //###
  }
  addstd( 'sex', createPol(getFld('POL') ));
  addstd( 'citizenship', createGrag(getFldI('CITIZEN')) );
  addstd( 'bdate', DTOSDef(getFldD('DATER'), tdClipper, '')); // 19650111
  addstd( 'sysOrgan', createSpr(-5, 26));    //###  код органа откуда отправляются данные !!!
  addstd( 'dsdDateRec', 'null');  // дата записи
  addstdS('docSery', getFld('PASP_SERIA'));
  addstdS('docNum', getFld('PASP_NOMER'));
  addstd( 'docType', createTypeDoc(getFldI('PASP_UDOST')));   // тип основного документа
  addstd( 'docOrgan', 'null'); // ###      PASP_ORGAN              орган выдачи основного документа
  addDJ(  'docDateIssue', getFldD('PASP_DATE'));  // дата выдачи основного документа
  addDJ(  'docAppleDate', getFldD('DATEZ'));      // дата подачи документа  ???
  addDJ(  'dateRec', getFldD('DATEZ'));           // системная дата записи  ???
//  new_obj.S['dateRec2']:=createISODate(Now);
  addstd( 'organDoc', createSpr(24, 17608347));        // ###
  addstd( 'docIssueOrgan', createSpr(24, 17608931));  // ###
  addstd( 'countryB', createCountry(getFldI('GOSUD_R')));
  addstdS('areaB', createObl(getFld('OBL_R'), dsDoc.FieldByName('B_OBL_R')));
  addstdS('regionB', getFld('RAION_R'));
  addstd( 'typeCityB', createTypeCity(getFldI('GOROD_R_B')));
  addstdS('cityB', getFld('GOROD_R'));
  addstd( 'areaBBel', 'null');   // ###
  addstd( 'regionBBel', 'null'); // ###
  addstd( 'cityBBel', 'null');   // ###
  addstdS('workPlace', getFld('WORK_NAME'));
  addstdS('workPosition', getFld('DOLG_NAME'));
  addstd( 'villageCouncil', createSpr(98, 0));     // сельский совет  ###
  addstd( 'intracityRegion', createSpr(99, 0));    // внутригородской район  ###
  addstd( 'ateAddress', 'null');   // ### адреса кадастрового агенства ???
  addstd( 'expireDate', 'null');   // ???
  addstd( 'aisPasspDocStatus', 'null');   // ???
  //----- Форма 19-20 ------------------------------------------------
  spDoc.WriteString(smesh+'"form19_20": {'#13#10);
    smesh:='    ';
    addstdS('form19_20Base', 'form19_20');   //
    addstd( 'pid', '0');           //
    addstd( 'signAway', 'true');   //  прибыл-убыл(0- прибыл, 1 - убыл)  в примере false true ???
    // отку прибыл - куда убыл
    addstd( 'countryPu', createCountry(getFldI('GOSUD_O')));
    addstdS('areaPu', createObl(getFld('OBL_O'), dsDoc.FieldByName('B_OBL_O')));
    addstdS('regionPu', getFld('RAION_O'));
    addstd( 'typeCityPu', createTypeCity(getFldI('GOROD_O_B')));
    addstdS('cityPu', getFld('GOROD_O'));
    //--- сейчас только реквизит UL_O ---   ###
    addstd( 'typeStreetPu', createSpr(38, 0));
    addstd( 'streetPu', 'null');
    addstd( 'housePu', 'null');
    addstd( 'korpsPu', 'null');
    addstd( 'appPu', 'null');
    //-------------------------------------------------
    addstd( 'datePu', 'null');    // ###   дата убытия-прибытия
    addstd( 'marks', createSpr(2, 0));   // ###  особые отметки
    addstd( 'notes', 'null');   // ###
    addstd( 'term', 'null');    // ###  срок
    addstd( 'reason', createSpr(3, 2));    // ###  цель прибытия-убытия
    addDJ(  'dateRec', Now);    // ###  системная дата записи
    addDJ(  'dateReg', Date);   // ###  дата прописки
    addstd( 'termReg', createSpr( 27, 4));  // ###  срок прописки  1-ПОСТОЯННО 2-ДО ПОЛУЧЕНИЯ ЖИЛПЛОЩАДИ 3-ДО 3-Х МЕСЯЦЕВ 4-ДО 6-ТИ МЕСЯЦЕВ 5-ДО КОНКРЕТНОЙ ДАТЫ
    addDJ(  'dateRegTill', getFldD('DATE_SROK'));  // если пусто то nil   дата до
    addstd( 'causeIssue', createSpr( 39, 59200021));  // ###  причина выдачи документа
    addstd( 'deathDate', 'null');     // дата смерти (в талоне прибытия нет такого реквизита)
    addstd( 'signNoTake', 'false');  // отметка о неполучении паспорта (в талоне прибытия нет такого реквизита)
    addstd( 'signNoReg', 'false');   // отметка о получении паспорта без прописки (в талоне прибытия нет такого реквизита)
    addstd( 'signDestroy', 'false'); // отметка паспорт уничтожен как невостребованный (в талоне прибытия нет такого реквизита)
    addstd( 'noAddrPu', createSpr( 70,  0));  // ###  прибытие-убытие без адреса
    addstd( 'regType', createSpr(500, 2));  // ### TYPEREG 1-постоянная рег. 2-временная рег.
    addstd( 'maritalStatus', createSem(getFldI('SEM')));  // семейное положение
    addstd( 'education', createObraz(getFldI('OBRAZ')));  // образование
    addstd( 'student', 'false');  // ### студент  нет такого реквизита
    //------ дети ----------------------------
//    addstd( 'infants', '[]'); // дети
    spDoc.WriteString(smesh+'"infants": []'#13#10);
    //----------------------------------------
  smesh:='  ';
    spDoc.WriteString(smesh+'},'#13#10);
  spDoc.WriteString(smesh+'"dsdAddressLive": {'#13#10);
    smesh:='    ';
    addstdS('dsdAddressLiveBase', 'dsdAddressLive');
    addstd( 'pid', '0');
    addstdS('house', '32');
    addstdS('korps', '');
    addstdS('app', '');
    addstd( 'ateObjectNum', '21293');
    addstd( 'ateElementUid', 'null');
//    addstdS('ateAddrNum', ''); 4998243
    spDoc.WriteString(smesh+'"ateAddrNum": null'#13#10);
  smesh:='  ';
    spDoc.WriteString(smesh+'},'#13#10);
  addstd('getPassportDate', 'null');  // дата получения паспорта
  addstd('images', '[]');
  addstd('addressLast', 'null');      // последний адрес ???
  addstd('dossieStatus', 'null');     // статус документа
  spDoc.WriteString(smesh+'"status": null'#13#10);  // статус
  spDoc.WriteString('}');

  sPostDoc:=AnsiToUtf8(spDoc.DataString);

  MemoWrite('1', sPostDoc);
  spDoc.Free;
//  new_obj.SaveTo('2',false,false);
  //============================================
//  ws:=new_obj.AsJSon(true,false);
//  sPostDoc:=UTF8Encode(ws);
//  MemoWrite('1', sPostDoc); // файл в кодировке UTF-8
//  new_obj:=nil;

//  exit;
  MemoRead('SaveDocTest.json', sPostDoc); // файл в кодировке UTF-8

  sStrm:=TStringStream.Create(sPostDoc);
  sStrm.Seek(0, soFromBeginning);
  HTTP.Document.CopyFrom(sStrm, 0);
  new_obj:=nil;
  try
    Result:=HTTP.HTTPMethod('POST', sURL+sPar);
    if Result then begin
      sStrmG:=TStringStream.Create(sPostDoc);
      sStrmG.Seek(0, soFromBeginning);
      sStrmG.CopyFrom(HTTP.Document, 0);
      sResponse:=sStrmG.DataString;
      sStrmG.Free;
      if (HTTP.ResultCode<200) or (HTTP.ResultCode>=400) then begin
        Result:=false;
        FLastError:=HTTP.Headers.Text;
      end;
    end else begin
      FLastError:=inttostr(HTTP.sock.LastError)+' '+HTTP.sock.LastErrorDesc;
    end;
  finally
    HTTP.Free;
    slHeader.Free;
    sStrm.Free;
  end;
  if not Result then begin
    WriteTextLog('отправка данных:'#13#10+FLastError, TEXT_ERROR);
  end else begin
    sw:=Utf8Decode(sResponse);
//  {  "status": 1, "id": 90021850,  "error": null  }
//  {  "status": 0, "id": null,      "error": "Не удалось сохранить запись в БД" }
    lOk:=true;
    try
      new_obj:=so(sw);
    except
      on E:Exception do begin
        lOK:=false;
        WriteTextLog('Невозможно разобрать ответ сервера:'#13#10+Utf8ToAnsi(sResponse), TEXT_ERROR);
      end;
    end;
    if lOk and (new_obj<>nil) then begin
      WriteDebugFile('_saveDoc.json',Utf8ToAnsi(sResponse));
      sStatus:=new_obj.S['status'];
      if sStatus='1' then begin
        sId:=new_obj.S['id'];
        sError:='';
        WriteTextLog('Запись '+getIDSave(dsDoc)+' успешно отправлена', TEXT_OK);
//        ShowMessageCont(,nil);
      end else begin
        sId:='';
        sError:=new_obj.S['error'];
        FLastError:=sError+', запись '+getIDSave(dsDoc);
        WriteTextLog(FLastError, TEXT_ERROR);
        Result:=false;
      end;
    end;
    new_obj:=nil;
  end;
  sl.Free;
end;

//-------------------------------------------------------
function TDvigMen.ReadParams: Boolean;
var
  ini:TSasaIniFile;
begin
  Result:=false;
  Ini:=nil;
  // файл с настройками для подключения должен храниться на главном компьютере или на локальном
  if FileExists(FFileIni) then begin
    Ini:=TSasaIniFile.Create( FFileIni );
    IsActive:=Ini.ReadBool('ADMIN','ACTIVE', true);
    IsEnabled:=IsActive;
    FEnableTextLog:=Ini.ReadBool('ADMIN','LOG', true);
    FDebug:=Ini.ReadBool('ADMIN','DEBUG', true);
    FCharUpper:=Ini.ReadBool('ADMIN','UPPER', true);
    FHost:=Ini.ReadString('HTTP','HOST', DEF_HOST);
    FPort:=Ini.ReadString('HTTP','PORT', DEF_PORT);
    FResource_Movements:=Ini.ReadString('HTTP','MOVEMENTS', DEF_Movements);
    FResource_getDoc:=Ini.ReadString('HTTP','GETDOC', DEF_getDoc);
    FResource_saveDoc:=Ini.ReadString('HTTP','SAVEDOC', DEF_saveDoc);
  end else begin
    PutError('Не найден файл параметров');
    IsEnabled:=false;
    IsActive:=false;
    exit;
  end;
  {$IFDEF TEST_SO}
    IsEnabled:=true;
    IsActive:=true;
  {$ELSE}
    if GlobalTask.GetLastValueAsBoolean('NOT_DVIGMEN') then begin
      IsEnabled:=false;
      IsActive:=false;
    end;
  {$ENDIF}
  CheckSizeFileLog(4);

  FActiveETSP:=false;
  FMessageSource:='';
  FPostUserName:=false;
  FIsDebug:=false;
  if IsEnabled then begin
    Result:=true;
    WriteTextLog(StringOfChar('-',50),0);
    WriteTextLog('чтение метоинформации '+FFileIni,0);
    FMessageSource:=Trim(Ini.ReadString('ADMIN', 'MESSAGESOURCE', ''));
    WriteTextLog('код организации='+FMessageSource,0);
    FPostUserName:=Ini.ReadBool('ADMIN', 'POST_USERNAME', true);
    FActiveETSP:=Ini.ReadBool('ADMIN', 'ETSP_ACTIVE', false);
    FIsDebug:=Ini.ReadBool('ADMIN', 'DEBUG', false);
  end;
end;

procedure TDvigMen.SetIsActive(const Value: Boolean);
begin
  FIsActive := Value;
end;

procedure TDvigMen.SetIsEnabled(const Value: Boolean);
begin
  FIsEnabled := Value;
end;

procedure TDvigMen.SetMessageSource(const Value: String);
begin
  FMessageSource := Value;
end;

procedure TDvigMen.SetActiveETSP(const Value: Boolean);
begin
  FActiveETSP := Value;
end;

procedure TDvigMen.SetPostUserName(const Value: Boolean);
begin
  FPostUserName := Value;
end;

procedure TDvigMen.SetIsDebug(const Value: Boolean);
begin
  FIsDebug := Value;
end;
function TDvigMen.GetLastError: String;
begin
  Result:=FLastError;
end;
{
POST http://www.todes.by:8086/cxf/vcouncil HTTP/1.1
Accept-Encoding: gzip,deflate
sign: amlsnandwkn&@871099udlaukbdeslfug12p91883y1hpd91h
certificate: 109uu21nu0t17togdy70-fuib
Content-Type: application/json;charset=UTF-8
Content-Length: 9772
Host: www.todes.by:8086
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)}

{
procedure TForm1.Login;
var
  HTTP:THTTPSend;
  Data:TStringStream;
  NewUrl:String;
begin
 HTTP := THTTPSend.Create;
 Data := TStringStream.Create('');
 try
   HTTP.UserAgent := 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4)'+
                      'Gecko/20100611 Firefox/3.6.4';
   HTTP.KeepAlive := True;
   HTTP.TargetPort := '80';
   HTTP.TargetHost := 'swa.mail.ru';
   HTTP.Protocol :='1.1';
   HTTP.MimeType :='application/x-www-form-urlencoded';

   // Данные необходимые для логина
   Data.WriteString('Page=http://otvet.mail.ru/login/?url=http://otvet.mail.ru/');
   Data.WriteString('&Login=name');
   Data.WriteString('&Domain=mail.ru');
   Data.WriteString('&Password=mypassword');

   HTTP.Document.LoadFromStream(Data);

    // далее парсим редирект
     if HTTP.HTTPMethod('POST','http://swa.mail.ru/cgi-bin/auth') then
       begin
         NewUrl :=StringReplace(HTTP.Headers.Strings[6],'Location:','',[]);
         HTTP.Document.Clear;
         HTTP.Headers.Clear;
         HTTP.TargetHost:='win.mail.ru';

           if HTTP.HTTPMethod('GET',NewUrl) then
             begin
               NewUrl :=StringReplace(HTTP.Headers.Strings[6],'Location:','',[]);
               HTTP.Document.Clear;
               HTTP.Headers.Clear;
               HTTP.TargetHost:='otvet.mail.ru';

                 if HTTP.HTTPMethod('GET','http://otvet.mail.ru') then
                   HTTP.Document.SaveToFile('D:\LoginToParse.html');
           end;
     end;
  finally
    Data.Free;
    HTTP.Free;
  end;
end;
}

end.
