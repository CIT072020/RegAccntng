unit uDTO;

interface

uses
  Classes,
  DB,
  kbmMemTable,
  superobject,
  //httpsend,
  uService;

type
  // Чтение списка ИН
  TIndNomDTO = class
  public
    class function GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
  end;

  // Чтение/Запись установочных данных
  TDocSetDTO = class
  private
    function CheckUP(s:String):String;
  public
    NeedUpper : Boolean;

    function MemDoc2JSON(dsDoc:TDataSet; dsChild:TDataSet): string;

    constructor Create(ChkUp : Boolean);
    
    class function GetDocList(SOArr: ISuperObject; Docs, Chs: TkbmMemTable): Integer;
  end;

implementation

uses
  SysUtils,
  NativeXml,
  FuncPr;

class function TIndNomDTO.GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
  function CT(s: string): string;
  begin
    Result := s;
  end;

var
  i : Integer;
  SO: ISuperObject;
begin
  Result := 0;
  try
    if (EmpTbl = True) then
      IndNum.EmptyTable;
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      IndNum.Append;
      IndNum.FieldByName('IDENTIF').AsString        := SO.S[CT('IDENTIFIER')];
      IndNum.FieldByName('ORG_WHERE_CODE').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('CODE')];
      IndNum.FieldByName('ORG_WHERE_NAME').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('LEX')];
      IndNum.FieldByName('ORG_FROM_CODE').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('CODE')];
      IndNum.FieldByName('ORG_FROM_NAME').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('LEX')];
      IndNum.FieldByName('DATEREC').AsDateTime      := sdDateTimeFromString(SO.S[CT('REG_DATE')], false);
      IndNum.Post;
      i := i + 1;
    end;
    Result := i;
  except
    Result := -1;
  end;
end;


class function TDocSetDTO.GetDocList(SOArr: ISuperObject; Docs, Chs: TkbmMemTable): Integer;

  function CT(s: string): string;
  begin
    Result := s;
  end;

  procedure FillChild(SOA: ISuperObject; Chs: TkbmMemTable; MasterI: integer);
  var
    j: Integer;
    SO: ISuperObject;
  begin
    try
      for j := 0 to SOA.AsArray.Length - 1 do begin
        SO := SOA.AsArray.O[j];
        Chs.Append;
        Chs.FieldByName('ID').AsInteger := MasterI;
        Chs.FieldByName('PID').AsString := SO.S[CT('pid')];
        Chs.FieldByName('IDENTIF').AsString := SO.S[CT('identif')];
        Chs.FieldByName('FAMILIA').AsString := SO.S[CT('surname')];
        Chs.FieldByName('NAME').AsString := SO.S[CT('name')];
        Chs.FieldByName('BDATE').AsString := SO.S[CT('bdate')];
        Chs.FieldByName('DATER').AsDateTime := UnixStrToDateTime(SO.S[CT('dateRec')]);
        Chs.Post;
      end;
    except
    end;
  end;

var
  s : string;
  IsF20 : Boolean;
  i, NCh: Integer;
  v     : Variant;
  SOf20, SOChild, SO: ISuperObject;
begin
  Result := 0;
  try
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      SOf20 := SO.O[CT('form19_20')];
      // !!! True temporary !!!
      if ( Assigned(SOf20) and (Not SOf20.IsType(stNull) or True) ) then begin
        Docs.Append;
        Docs.FieldByName('PID').AsString := SO.S[CT('pid')];
        IsF20 := SOf20.B[CT('signAway')];
        if (IsF20 = True) then
          Docs.FieldByName('signAway').AsInteger := 1
        else
          Docs.FieldByName('signAway').AsInteger := 0;

        Docs.FieldByName('IDENTIF').AsString := SO.S[CT('identif')];
        Docs.FieldByName('sysDocType').AsString := SO.O[CT('sysDocType')].O[CT('klUniPK')].s[CT('type')];
        Docs.FieldByName('sysDocName').AsString := SO.O[CT('sysDocType')].S[CT('lex1')];
        Docs.FieldByName('FAMILIA').AsString := SO.S[CT('surname')];
        Docs.FieldByName('NAME').AsString := SO.S[CT('name')];

        try
          SOChild := SO.O[CT('form19_20')].O[CT('infants')];
          NCh := SOChild.AsArray.Length;
        except
          NCh := 0;
        end;

        if (Assigned(SOChild)) and (NCh > 0) then begin
          FillChild(SOChild, Chs, i);
        end;
        Docs.FieldByName('NCHILD').AsInteger := NCh;

        Docs.Post;
      end;
      i := i + 1;
    end;
    Result := i;
  except
    Result := -1;
  end;
end;

constructor TDocSetDTO.Create(ChkUp: Boolean);
begin
  inherited Create;
  NeedUpper := ChkUp;
end;




















//-------------------------------------------------------
function TDocSetDTO.CheckUP(s:String):String;
begin
  if NeedUpper
    then Result := ANSIUpperCase(s)
    else Result := s;
end;



function VarKey(nType : Integer; nValue : Int64) : String;
begin
  //Result := Format('{"klUniPK":{"type":%d,"code":%d},"lex1":null,"lex2":null,"lex3":null,"dateBegin":null,"active":true}', [nType, nValue]);
  Result := Format('{"klUniPK":{"type":%d,"code":%d}}', [nType, nValue]);
end;

// SYS-Тип документа
function VarKeySysDocType(sType : string = '8') : String;
begin
  Result := VarKey(-2, StrToInt64(sType));
end;

// Мужской/женский
function VarKeyPol(sType : string = 'М') : String;
var
  n : Int64;
begin
  if (sType = 'М') then n := 21000001 else n := 21000002;
  Result := VarKey(32, n);
end;

// Код гражданства
function VarKeyCountry(sType : string = '11200001') : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(8, n);
end;

// Код регистрирующего органа
function VarKeySysOrgan(sType : string = '') : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(-5, n);
end;

// Код типа населенного пункта
function VarKeyTypeCity(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(35, n);
end;

// Тип документа
function VarKeyDocType(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(37, n);
end;

// Территория/область
function VarKeyArea(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(1, n);
end;

// Регион
function VarKeyRegion(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(29, n);
end;

// Населенный пункт
function VarKeyCity(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(7, n);
end;

// Улица
function VarKeyStreet(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(34, n);
end;

// Орган выдачи документа
function VarKeyOrgan(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(24, n);
end;


// Сельсовет
function VarKeyVilage(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(98, n);
end;

// IntrRegion
function VarKeyIntrRegion(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(99, n);
end;


// Форма 19-20
function PrepForm1920(sType : string) : String;
begin
  Result := 'null';
end;

// Тело документа для POST
function TDocSetDTO.MemDoc2JSON(dsDoc:TDataSet; dsChild:TDataSet): string;
var
  spDoc : TStringStream;

  smesh,
  s,sURL,sPar,sss,sF,
  sFld,sPath,sPostDoc,sResponse,sError,sStatus,sId
  :String;

  sl, slHeader,
  slFld
  :TStringList;

  sStrm,sStrmG
  :TStringStream;

  new_obj, obj
  : ISuperObject;

  sw,
  ws
  :WideString;

  nSpr,n,i,j
  :Integer;

  lOk
  :Boolean;

  function getFld(sField:String):String;
  begin Result := CheckUP(dsDoc.FieldByName(sField).AsString); end;

  function getFldD(sField:String):TDateTime;
  begin Result := dsDoc.FieldByName(sField).AsDateTime; end;

  function getFldI(sField:String):Integer;
  begin Result := dsDoc.FieldByName(sField).AsInteger; end;

  // Вставить число
  procedure Addstd(ss1,ss2:String);
  begin
    spDoc.WriteString('"' + ss1 + '":' + ss2 +',');
  end;
  // Вставить строку
  procedure AddstdS(const ss1 : string; ss2 : String = '');
  begin
    if (ss2 = '') then ss2 := 'null' else ss2 := '"' + ss2 + '"';
    spDoc.WriteString('"' + ss1 + '": ' + ss2 + ',');
  end;
  procedure AddDJ(ss1:String; dValue:TDateTime);
  begin
    if (dValue=0) then sss := 'null' else sss := IntToStr(createJavaDate(dValue));
    spDoc.WriteString(smesh+'"'+ss1+'": '+sss+',');
  end;
begin

  spDoc := TStringStream.Create('');
  spDoc.WriteString('{');

  //Addstd(  'pid', getFld('pid') );
  AddstdS( 'identif', getFld('IDENTIF') );
  //addstd( 'view', createSpr(-3, 10));
  Addstd(  'view' );
  Addstd(  'sysDocType', VarKeySysDocType(-2, getFld('sysDocType')) );
  AddstdS( 'surname', getFld('FAMILIA') );
  AddstdS( 'name', getFld('NAME') );
  AddstdS( 'sname', getFld('OTCH') );
  Addstd(  'sex', VarKeyPol(32, getFld('POL')) );
  Addstd(  'citizenship', VarKeyCountry(getFldI('CITIZENSHIP')) );
  Addstd(  'sysOrgan', VarKeySysOrgan(getFldI('sysOrgan')) );    //###  код органа откуда отправляются данные !!!

  AddstdS( 'bdate', DTOSDef(getFldD('BDATE'), tdClipper, '') ); // 19650111
  AddstdS( 'dsdDateRec' );                                      // дата записи ???
  AddstdS( 'docSery', getFldD('docSer') );                       // серия основного документа
  AddstdS( 'docNum', getFldD('docNum') );                       // номер основного документа
  AddDJ(   'docDateIssue', getFldD('docDateIssue') );           // дата выдачи основного документа
  AddDJ(   'docAppleDate', getFldD('docAppleDate'));            // дата подачи документа  ???
  AddDJ(   'dateRec', getFldD('dateRec'));                      // системная дата записи  ???
  Addstd(  'ateAddress' );                                      // ???
  AddDJ(   'expireDate', getFldD('expireDate'));                // дата действия  ???
  Addstd(  'aisPasspDocStatus' );                               // ???
  Addstd(  'identifCheckResult' );                               // ???

  // место рождения
  Addstd(  'countryB', VarKeyCountry(getFldI('countryB')) );
  AddstdS( 'areaB', getFld('areaB') );
  Addstd(  'typeCityB', VarKeyCity(getFldI('typeCityB')) );
  Addstd(  'docType', VarKeyDocType(37, getFld('docType')) );  // тип основного документа
  AddstdS( 'docOrgan' );                                       // орган выдачи основного документа

  Addstd(  'contryL', VarKeyCountry(getFldI('countryL')) );
  Addstd(  'areaL', VarKeyArea(getFldI('areaL')) );
  Addstd(  'regionL', VarKeyRegion(getFldI('regionL')) );
  Addstd(  'typeCityL', VarKeyTypeCity(35, getFldI('typeCityL')) );
  Addstd(  'cityL', VarKeyCity(35, getFldI('cityL')) );
  Addstd(  'typeStreetL', VarKeyTypeStreet(35, getFldI('typeStreetL')) );
  Addstd(  'streetL', VarKeyStreet(35, getFldI('streetL')) );

  AddstdS( 'house', getFld('house') );
  AddstdS( 'korps', getFld('korps') );
  AddstdS( 'app', getFld('app') );

  AddstdS( 'organDoc', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа
  AddstdS( 'workplace', getFld('workplace') );
  AddstdS( 'workposition', getFld('workposition') );

  AddstdS( 'docIssueOrgan', VarKeyOrgan(getFldI('docIssueOrgan')) );    //###  код органа
  AddstdS( 'surnameBel', getFld('FAMILIA') );
  AddstdS( 'nameBel', getFld('NAME') );
  AddstdS( 'snameBel', getFld('OTCH') );

  AddstdS( 'surnameEn', getFld('FAMILIA') );
  AddstdS( 'nameEn', getFld('NAME') );

  AddstdS( 'areaBBel', getFld('areaB') );
  Addstd(  'regionBBelL', getFldI('regionL')) );
  Addstd(  'cityBBel', getFldI('cityL')) );

  AddstdS( 'villageCouncil', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа
  AddstdS( 'intracityRegion', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа

  AddstdS( 'dsdAddressLive', getFldI('organDoc')) );    //###  код органа
  AddstdS( 'images', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа
  AddstdS( 'status', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа
  AddstdS( 'intracityRegion', VarKeyOrgan(getFldI('organDoc')) );    //###  код органа
end.
