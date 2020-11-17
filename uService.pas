unit uService;

interface

uses
 Classes, DB,
 StdCtrls,
 kbmMemTable,
 DBFunc,
 SasaINiFile, FuncPr;

const
  // функции запросов к серверу
  GET_LIST_ID  = 1;
  GET_LIST_DOC = 2;
  POST_DOC     = 3;

  RESOURCE_GEN_POINT = '/village-council-service/api';
  RESOURCE_VER       = '/v1';

  RESOURCE_LISTID_PATH = '/movements';
  RESOURCE_LISTDOC_PATH  = '/data';
  RESOURCE_POSTDOC_PATH = '/data/save';


  MT_INS   = 'INS';
  MT_DOCS  = 'DOCS';
  MT_CHILD = 'CHILD';

  DEB_CLEAR    = 1;
  DEB_NEWLINE  = 2;
  DEB_SAMELINE = 3;

function CreateMemTable(sTableName: string; Meta : TSasaIniFile; MetaSect: String; AutoCreate: Boolean = True; AutoOpen: Boolean = True): TDataSet;
procedure ShowDeb(const s: string; const Mode : Integer = DEB_NEWLINE);

var
  ShowM : TMemo;

implementation

uses
  SysUtils,
  StrUtils;


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

end.
