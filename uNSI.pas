unit uNSI;

interface

uses
  SysUtils,
  superobject;

const
  KEY_NULL  = 1;
  KEY_EMPTY = 2;
  KEY_VAL   = 3;

  GET_VAL = 1;
  SET_VAL = 2;

type
  TNsiRoc = class
    private
      function RSupObj : ISuperObject;
      procedure WSupObj(const x : ISuperObject);
    public
    property SO : ISuperObject read RSupObj write WSupObj;

    class function SysDocType(ICode : Integer = 8; Func : Integer = SET_VAL) : String;
    class function Sex(SCode : string; Func : Integer = SET_VAL) : String;
    class function Country(ICode : Integer = 11200001; Func : Integer = SET_VAL) : String;
  end;


implementation

var
  SO : ISuperObject;

function TNsiRoc.RSupObj: ISuperObject;
begin
  Result := SO;
end;

procedure TNsiRoc.WSupObj(const x : ISuperObject);
begin
  SO := x;
end;

//-------------------------------------------------------
// Строка для значения ключевого реквизита
function UniKey(nType : Integer; nValue : Int64; ValType : integer = KEY_VAL) : String;
begin
  Result := 'null';
  if (ValType = KEY_VAL) then
    Result := Format('{"klUniPK":{"type":%d,"code":%d}}', [nType, nValue])
  else if (ValType = KEY_EMPTY) then
    Result := Format('{"klUniPK":{"type":%d,"code":0}}', [nType]);
end;

// SYS-Тип документа
class function TNsiRoc.SysDocType(ICode : Integer = 8; Func : Integer = SET_VAL) : String;
begin
  if (Func = SET_VAL) then begin
    if (ICode = 0) then
      ICode := 8;
    Result := UniKey(-2, ICode);
  end else begin

  end;
end;




// Мужской/женский
class function TNsiRoc.Sex(SCode : string; Func : Integer = SET_VAL) : String;
var
  n : Int64;
begin
  if (Func = SET_VAL) then begin
    if (SCode = 'М') then n := 21000001 else n := 21000002;
    Result := UniKey(32, n);
  end else begin

  end;


end;

// Код страны(гражданство, ...)
class function TNsiRoc.Country(ICode : Integer = 11200001; Func : Integer = SET_VAL) : String;
begin
  if (Func = SET_VAL) then begin
    Result := UniKey(8, ICode);
  end else begin

  end;
end;


end.
