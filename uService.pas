unit uService;

interface

uses
 Classes, DB,
 kbmMemTable,
 DBFunc,
 SasaINiFile, FuncPr;

function CreateMemTable(sTableName: string; Meta : TSasaIniFile; MetaSect: String; AutoCreate: Boolean = True; AutoOpen: Boolean = True): TDataSet;

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


end.
