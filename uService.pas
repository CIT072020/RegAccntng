unit uService;

interface

uses
 Classes, DB,
 StdCtrls,
 kbmMemTable,
 DBFunc,
 superdate, superobject, supertypes,
 {$IFDEF SYNA} httpsend,  {$ENDIF}
 SasaINiFile, FuncPr;

const
  INI_NAME = 'ExchgPars.ini';
  // функции запросов к серверу
  GET_LIST_ID  = 1;
  GET_LIST_DOC = 2;
  POST_DOC     = 3;

  // Тип списочных данных для GET
  TLIST_FIO = Integer(1);
  TLIST_INS = Integer(2);

  RES_HOST     = 'https://a.todes.by:13555';
  RES_GENPOINT = '/village-council-service/api';
  RES_NSI      = '/kluni-service';
  RES_VER      = '/v1';

  RESOURCE_LISTID_PATH = '/movements';
  RESOURCE_LISTDOC_PATH  = '/data';
  RESOURCE_POSTDOC_PATH = '/data/save';

  // Секции INI-файла для описания таблиц
  SCT_TBL_INS = 'TABLE_INDNUM';
  SCT_TBL_DOC = 'TABLE_DOCSET';
  SCT_TBL_CLD = 'TABLE_CHILD';

  // Имена таблиц
  MT_INS   = 'INS';
  MT_DOCS  = 'DOCS';
  MT_CHILD = 'CHILD';

  // Режим вывода очередной отладочной записи
  DEB_CLEAR    = 1;
  DEB_NEWLINE  = 2;
  DEB_SAMELINE = 3;

type
  THostReg = class(TObject)
  // путь к сервису
    URL      : string;
    GenPoint : string;
    Ver      : string;
  end;


function UnixStrToDateTime(sDate:String):TDateTime;
function Delphi2JavaDate(d:TDateTime):SuperInt;
function MemStream2Str(const MS: TMemoryStream; const FullStream: Boolean = True; const ADefault: string = ''): string;

function CreateMemTable(sTableName: string; Meta : TSasaIniFile; MetaSect: String; AutoCreate: Boolean = True; AutoOpen: Boolean = True): TDataSet;
procedure ShowDeb(const s: string; const Mode : Integer = DEB_NEWLINE);
function FullPath(H : THostReg; Func : Integer; Pars : string) : string;

function GetListDOC(Host : THostReg; Pars: TStringList): ISuperObject;
procedure LeaveOnly1(ds: TDataSet);

var
  ShowM : TMemo;

implementation

uses
  SysUtils,
  StrUtils;

function UnixStrToDateTime(sDate:String):TDateTime;
begin
   Result := 0;
   if (sDate <> 'null') then
     Result := JavaToDelphiDateTime(StrToInt64(sDate));
end;

function Delphi2JavaDate(d:TDateTime):SuperInt;
begin
  Result := DelphiToJavaDateTime(d);
end;

function MemStream2Str(const MS: TMemoryStream; const FullStream: Boolean = True; const ADefault: string = ''): string;
var
  NeedLen: Integer;
begin
  if Assigned(MS) then
  try
    if (FullStream = True) then
      MS.Position := 0;
    NeedLen := MS.Size - MS.Position;
    SetLength(Result, NeedLen);
    MS.Read(Result[1], NeedLen);
  except
    Result := ADefault;
  end
  else
    Result := ADefault;
end;

//---------------------------------------------
function CreateMemTable(sTableName: string; Meta : TSasaIniFile; MetaSect: String; AutoCreate: Boolean = True; AutoOpen: Boolean = True): TDataSet;

function GetFieldSize(sLen: string): Integer;
begin
  if IsAllDigit(sLen) then
    Result := StrToIntDef(sLen, 0)
  else
    Result := Meta.ReadInteger('CONST', sLen, 0);
end;

var
  I, n, m: Integer;
  FLastError, FieldName, s, sOpis, sKomm: string;
  FieldType: TFieldType;
  FieldSize: Integer;
  FieldDef: TFieldDef;
  fld: TField;
  tb: TkbmMemTable;
  arr, arrFields: TArrStrings;
  MetaDef,
  slAdd: TStringList;
begin
  FLastError := '';
  Result := nil;

  MetaDef := TStringList.Create;
  Meta.ReadSectionValues(MetaSect, MetaDef);

  if MetaDef.Count > 0 then begin
    slAdd := TStringList.Create;
    tb := TkbmMemTable.Create(nil);
    tb.Name := sTableName;
    tb.Tag := Integer(slAdd);
    tb.AutoIncMinValue := 1;

    for I := 0 to MetaDef.Count - 1 do begin
      FieldName := MetaDef.Names[I];
      s := MetaDef.ValueFromIndex[I];
      n := Pos('|', s);
      if n = 0 then begin
        sOpis := Trim(s);
        sKomm := '';
      end
      else begin
        sOpis := Trim(Copy(s, 1, n - 1));
        sKomm := Copy(s, n + 1, Length(s));
        n := Pos('[', sKomm);
        m := PosEx(']', sKomm, n + 1);
        if (n > 0) and (m > 0) then
          sKomm := Trim(Copy(sKomm, n + 1, m - n - 1))
        else
          sKomm := '';
      end;
      StrToArr(sOpis, arr, ',', false);
      SetLength(arr, 2);
      FieldSize := 0;
      if StringToFieldType(arr[0], FieldType) then begin
        FieldSize := GetFieldSize(arr[1]);
        FieldDef := tb.FieldDefs.AddFieldDef;
        FieldDef.Name := FieldName;
        FieldDef.DataType := FieldType;
        if FieldType <> ftBoolean then
          FieldDef.Size := FieldSize;
        if (FieldDef.DataType = ftString) and (FieldSize = 0) then begin
          FLastError := MetaDef.Strings[I];
          break;
        end;
        if sKomm <> '' then
          slAdd.Add(FieldDef.name + '=' + sKomm);
      end
      else begin
        FLastError := MetaDef.Strings[I];
        break;
      end;
    end;


  if (Length(FLastError) = 0) then begin
    if AutoCreate then
      tb.CreateTable;
    if AutoOpen then
      tb.Open;
    Result := tb;
    //FListObject.AddObject(sTableName, tb);
  end
  else begin
    slAdd.Free;
    tb.Free;
  end;

  end
  else
    FLastError := 'Meta-Описание не найдено!';

  MetaDef.Free;
end;


procedure ShowDeb(const s: string; const Mode : Integer = DEB_NEWLINE);
var
  AddS : string;
begin

  AddS := '';
  case Mode of
    DEB_CLEAR   : ShowM.Text := '';
    //DEB_NEWLINE : AddS := Char(13) + Char(10);
    DEB_NEWLINE : AddS := #13#10;
  end;

  ShowM.Text := ShowM.Text + AddS + s;

end;

function FullPath(H : THostReg; Func : Integer; Pars : string) : string;
var
  s : string;
begin
  s := '';
  case Func of
    GET_LIST_ID  : s := RESOURCE_LISTID_PATH;
    GET_LIST_DOC : s := RESOURCE_LISTDOC_PATH;
    POST_DOC     : s := RESOURCE_POSTDOC_PATH;
  end;
  if ( Length(s) > 0) then
    s := H.URL + H.GenPoint + H.Ver + s + Pars;
  Result := s;
end;




// установка параметров для GET : получения документов по ID
//
// identifier=3140462K000VF6
// name=
// surname=
// patronymic=
// first=
// count=
function SetPars4GetDocs(Pars : TStringList) : string;
var
  s : string;
begin
  s := Format('?identifier=%s&name=%s&surname=%s&patronymic=%s&first=%s&count=%s',
    [ Pars[0], Pars[1], Pars[2], Pars[3], Pars[4], Pars[5] ]);
  Result := s;
end;

function GetListDOC(Host : THostReg; Pars: TStringList): ISuperObject;
var
  Ret : Boolean;
  sDoc,
  sErr, sPars: string;
  ws : WideString;
  Docs : ISuperObject;
  HTTP: THTTPSend;
begin
  Result := nil;
  HTTP := THTTPSend.Create;
  sPars := FullPath(Host, GET_LIST_DOC, SetPars4GetDocs(Pars));
  ShowDeb(sPars);

  try
    try
      Ret := HTTP.HTTPMethod('GET', sPars);
      if (Ret = True) then begin
        if (HTTP.ResultCode < 200) or (HTTP.ResultCode >= 400) then begin
          sErr := HTTP.Headers.Text;
          raise Exception.Create(sErr);
        end;
        ShowDeb(IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString);
        sDoc := MemStream2Str(HTTP.Document);
        //Result := SO(Utf8Decode(sDoc));
        ws   := Utf8Decode(sDoc);
        Result := SO(ws);
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

end.
