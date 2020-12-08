unit uDTO;

interface

uses
  Classes,
  DB,
  kbmMemTable,
  superobject,
  superdate,
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
    // MemTable with Docs
    FDoc : TDataSet;
    FChild : TDataSet;
    FSO : ISuperObject;

    function GetFS(sField: String): String;
    function GetFD(sField: String): TDateTime;
    // Код из справочного реквизита
    function GetCode(sField: String): Integer;
  public
    NeedUpper : Boolean;

    // Список документов из SuperObject сохранить в MemTable
    function GetDocList(SOArr: ISuperObject): Integer;
    function MemDoc2JSON(dsDoc: TDataSet; dsChild: TDataSet; StreamDoc: TStringStream; NeedUp : Boolean): Boolean;

    constructor Create(MTDoc, MTChild : TDataSet);

    class function GetNsi(SOArr: ISuperObject; Nsi: TkbmMemTable; EmpTbl: Boolean = True): Integer;
  end;

implementation

uses
  SysUtils,
  NativeXml,
  FuncPr;


constructor TDocSetDTO.Create(MTDoc, MTChild : TDataSet);
begin
  inherited Create;
  FDoc := MTDoc;
  FChild := MTChild;
end;

// Строковое из MemTable
function TDocSetDTO.GetFS(sField: String): String;
begin
  Result := FDoc.FieldByName(sField).AsString;
end;

// Дата из MemTable
function TDocSetDTO.GetFD(sField: String): TDateTime;
begin
  Result := FDoc.FieldByName(sField).AsDateTime;
end;

// Код из справочного реквизита
function TDocSetDTO.GetCode(sField: String): Integer;
begin
  Result := FSO.O[sField].O['klUniPK'].I['code'];
end;

class function TIndNomDTO.GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
  function CT(s: string): string;
  begin
    Result := s;
  end;

var
  s : string;
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
      IndNum.FieldByName('PID').AsString            := SO.S[CT('pid')];
      IndNum.Post;
      i := i + 1;
    end;
    Result := i;
  except
    Result := -1;
  end;
end;


function TDocSetDTO.GetDocList(SOArr: ISuperObject): Integer;

  function CT(s: string): string;
  begin
    Result := s;
  end;

  procedure FillChild(SOA: ISuperObject; Chs: TDataSet; MasterI: integer);
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
  iV,
  i, NCh: Integer;
  d : TDateTime;
  v     : Variant;
  SOf20, SODsdAddr,
  SOChild, SO: ISuperObject;
begin
  Result := 0;
  try
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      FSO := SO;
      SOf20 := SO.O[CT('form19_20')];
      SODsdAddr := SO.O[CT('dsdAddressLive')];
      // !!! True temporary !!!
      if ( Assigned(SOf20) and (Not SOf20.IsType(stNull) or True) ) then begin
        FDoc.Append;
        FDoc.FieldByName('PID').AsString := SO.S[CT('pid')];
        IsF20 := SOf20.B[CT('signAway')];
        if (IsF20 = True) then
          FDoc.FieldByName('signAway').AsInteger := 1
        else
          FDoc.FieldByName('signAway').AsInteger := 0;

        FDoc.FieldByName('view').AsInteger := GetCode('view');
        FDoc.FieldByName('LICH_NOMER').AsString := SO.S[CT('identif')];
        FDoc.FieldByName('sysDocType').AsInteger := GetCode('sysDocType');
        FDoc.FieldByName('sysDocName').AsString := SO.O[CT('sysDocType')].S[CT('lex1')];
        FDoc.FieldByName('Familia').AsString := SO.S[CT('surname')];
        FDoc.FieldByName('Name').AsString := SO.S[CT('name')];
        FDoc.FieldByName('Otch').AsString := SO.S[CT('sname')];

        iV := SO.O[CT('sex')].O[CT('klUniPK')].I[CT('code')];
        if (iV = 21000002) then s := 'Ж' else s := 'М';
        FDoc.FieldByName('POL').AsString := s;

        iV := SO.O[CT('citizenship')].O[CT('klUniPK')].I[CT('code')];
        FDoc.FieldByName('CITIZEN').AsInteger := iV;

        FDoc.FieldByName('sysOrgan').AsInteger := SO.O[CT('sysOrgan')].O[CT('klUniPK')].I[CT('code')];
        FDoc.FieldByName('ORGAN').AsString := SO.O[CT('sysOrgan')].S[CT('lex1')];

        d := STOD(SO.S[CT('bdate')]);
        FDoc.FieldByName('DateR').AsDateTime := d;

        FDoc.FieldByName('PASP_SERIA').AsString := SO.S[CT('docSery')];
        FDoc.FieldByName('PASP_NOMER').AsString := SO.S[CT('docNum')];
        FDoc.FieldByName('PASP_DATE').AsDateTime := JavaToDelphiDateTime(SO.I[CT('docDateIssue')]);

        FDoc.FieldByName('GOSUD_R').AsInteger := SO.O[CT('countryB')].O[CT('klUniPK')].I[CT('code')];
        FDoc.FieldByName('GOSUD_R_NAME').AsString := SO.O[CT('countryB')].S[CT('lex1')];

        try
          SOChild := SO.O[CT('form19_20')].O[CT('infants')];
          NCh := SOChild.AsArray.Length;
        except
          NCh := 0;
        end;

        if (Assigned(SOChild)) and (NCh > 0) then begin
          FillChild(SOChild, FChild, i);
        end;
        FDoc.FieldByName('DETI').AsInteger := NCh;

        if ( Assigned(SODsdAddr) and (Not SODsdAddr.IsType(stNull)) ) then begin
          FDoc.FieldByName('vilCouncilObjNum').AsInteger := SODsdAddr.I[CT('vilCouncilObjNum')];
          FDoc.FieldByName('villageCouncil').AsString := SODsdAddr.S[CT('villageCouncil')];

          FDoc.FieldByName('ateObjectNum').AsInteger := SODsdAddr.I[CT('ateObjectNum')];
          FDoc.FieldByName('ateElementUid').AsInteger := SODsdAddr.I[CT('ateElementUid')];
          FDoc.FieldByName('ateAddrNum').AsInteger := SODsdAddr.I[CT('ateAddrNum')];
          FDoc.FieldByName('house').AsString := SODsdAddr.S[CT('house')];
          FDoc.FieldByName('korps').AsString := SODsdAddr.S[CT('korps')];
          FDoc.FieldByName('app').AsString := SODsdAddr.S[CT('app')];

        end;


        FDoc.Post;
      end;
      i := i + 1;
    end;
    Result := i;
  except
    Result := -1;
  end;
end;





















//-------------------------------------------------------
function VarKey(nType : Integer; nValue : Int64; Emp : Boolean = False) : String;
begin
  //Result := Format('{"klUniPK":{"type":%d,"code":%d},"lex1":null,"lex2":null,"lex3":null,"dateBegin":null,"active":true}', [nType, nValue]);
  if (NOT Emp) then
    Result := Format('{"klUniPK":{"type":%d,"code":%d}}', [nType, nValue])
  else
    Result := Format('{"klUniPK":{"type":%d,"code":0}}', [nType]);
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
  try
  n := StrToInt64(sType);
  except
    n := 0;
  end;
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

// Тип Улицы
function VarKeyTypeStreet(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(38, n);
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



// Тело документа для POST
function TDocSetDTO.MemDoc2JSON(dsDoc: TDataSet; dsChild: TDataSet; StreamDoc: TStringStream; NeedUp : Boolean): Boolean;
var
  s, sURL, sPar, sss, sF, sFld, sPath, sPostDoc, sResponse, sError, sStatus, sId: String;
  sUTF : UTF8String;
  ws : WideString;
  new_obj, obj: ISuperObject;
  nSpr, n, i, j: Integer;
  lOk: Boolean;

{
}

  function getFldI(sField: String): String;
  begin
    try
    Result := IntToStr(dsDoc.FieldByName(sField).AsInteger);
    except
      Result := 'null';
    end;
  end;

  // Вставить число
  // Вставить логическое
  procedure AddNum(const ss1: string; ss2: String = '');
  begin
    if (ss2 = '') then
      ss2 := 'null';
    StreamDoc.WriteString('"' + ss1 + '":' + ss2 + ',');
  end;
  // Вставить строку

  procedure AddStr(const ss1: string; ss2: String = '');
  begin
    if (ss2 = '') then
      ss2 := 'null'
    else
      ss2 := '"' + ss2 + '"';
    StreamDoc.WriteString('"' + ss1 + '": ' + ss2 + ',');
  end;
  // Вставить дату

  procedure AddDJ(ss1: String; dValue: TDateTime);
  begin
    if (dValue = 0) then
      sss := 'null'
    else
      sss := IntToStr(Delphi2JavaDate(dValue));
    StreamDoc.WriteString('"' + ss1 + '": ' + sss + ',');
  end;



  // Место рождения
procedure SchPlaceOfBorn;
begin
  try
    AddNum('countryB', VarKeyCountry(getFldI('GOSUD_R')));
    AddStr('areaB', GetFS('areaB'));
    AddNum('typeCityB', VarKeyCity(getFldI('typeCityB')));
  except
  end;
end;

  // Место проживания
procedure SchPlaceOfLiv;
begin
  try
    AddNum('contryL', VarKeyCountry(getFldI('countryL')));
    AddNum('areaL', VarKeyArea(getFldI('areaL')));
    AddNum('regionL', VarKeyRegion(getFldI('regionL')));
    AddNum('typeCityL', VarKeyTypeCity(getFldI('typeCityL')));
    AddNum('cityL', VarKeyCity(getFldI('cityL')));
    AddNum('typeStreetL', VarKeyTypeStreet(getFldI('typeStreetL')));
    AddNum('streetL', VarKeyStreet(getFldI('streetL')));

    AddStr('house', GetFS('house'));
    AddStr('korps', GetFS('korps'));
    AddStr('app', GetFS('app'));

    AddStr('areaBBel', GetFS('areaB'));
    AddNum('regionBBelL', getFldI('regionL'));
    AddNum('cityBBel', getFldI('cityL'));

  except
  end;
end;

  // Схема Паспорт
procedure SchPasport;
begin
  try
    AddStr('docSery', GetFS('PASP_SERIA'));                       // серия основного документа
    AddStr('docNum', GetFS('PASP_NOMER'));                       // номер основного документа
    AddDJ('docDateIssue', GetFD('PASP_DATE'));           // дата выдачи основного документа
    //AddDJ('docAppleDate', getFldD('docAppleDate'));            // дата подачи документа  ???
    AddDJ('expireDate', GetFD('expireDate'));                // дата действия  ???
    //AddNum('aisPasspDocStatus');                               // ???
    AddNum('docType', VarKeyDocType(GetFS('docType')));  // тип основного документа
    AddStr('docOrgan');                                       // орган выдачи основного документа
    //AddStr('docIssueOrgan', VarKeyOrgan(getFldI('docIssueOrgan')));    //###  код органа

    //AddStr('surnameBel', getFld('FAMILIA'));
    //AddStr('nameBel', getFld('NAME'));
    //AddStr('snameBel', getFld('OTCH'));

    //AddStr('surnameEn', getFld('FAMILIA'));
    //AddStr('nameEn', getFld('NAME'));
  except
  end;
end;

// Структура dsdAddressLive
procedure DsdAddress;
begin
  try
    StreamDoc.WriteString('"dsdAddressLive":{');
    AddStr('dsdAddressLiveBase', 'dsdAddressLive');
    AddNum('ateObjectNum', getFldI('ateObjectNum'));
    AddNum('ateElementUid', getFldI('ateElementUid'));
    AddNum('ateAddrNum', getFldI('ateAddrNum'));
    AddStr('house', GetFS('house'));
    AddStr('korps', GetFS('korps'));
    AddStr('app', GetFS('app'));

  // Последней была запятая, вернемся для записи конца объекта
    StreamDoc.Seek(-1, soCurrent);
    StreamDoc.WriteString('},');

  except
  end;
end;


// Форма 19-20
procedure Form19_20Write;
begin
  try
    StreamDoc.WriteString('"form19_20":{');
    AddStr('form19_20Base', 'form19_20');
    AddNum('signAway', 'false');
    AddDJ('dateReg', GetFD('DATEZ'));
    AddNum('countryPu', VarKeyCountry(getFldI('GOSUD_O')));
    AddNum('areaPu', VarKeyArea(GetFS('OBL_O')));
    //AddNum('regionPu', VarKeyRegion(getFldI('RAION_O')));

  // Последней была запятая, вернемся для записи конца объекта
    StreamDoc.Seek(-1, soCurrent);
    StreamDoc.WriteString('},');

  except
  end;
end;

begin
  Result := False;
  try
    StreamDoc.WriteString('{');

    AddNum(  'pid' );
    AddStr('identif', GetFS('LICH_NOMER'));
  //AddNum( 'view', createSpr(-3, 10));
    AddNum('view');
    AddNum('sysDocType', VarKeySysDocType(GetFS('sysDocType')));
    AddStr('surname', GetFS('Familia'));
    AddStr('name', GetFS('Name'));
    AddStr('sname', GetFS('Otch'));
    AddNum('sex', VarKeyPol(GetFS('POL')));
    AddNum('citizenship', VarKeyCountry(GetFS('CITIZEN')));
    AddNum('sysOrgan', VarKeySysOrgan(GetFS('sysOrgan')));    //###  код органа откуда отправляются данные !!!
    AddStr('bdate', DTOSDef(GetFD('DateR'), tdClipper, '')); // 19650111
    AddStr('dsdDateRec');                                      // дата записи ???

    // Схема Паспорт
    SchPasport;

    //AddStr('regNum');                                      // дата записи ???
    //AddDJ('dateRec', getFldD('dateRec'));                      // системная дата записи  ???
    //AddNum('ateAddress');                                      // ???
    //AddNum('identifCheckResult');                               // ???

    // Место рождения
    SchPlaceOfBorn;

    // Место проживания
    SchPlaceOfLiv;


    if (False) then begin
    AddStr('organDoc', VarKeyOrgan(getFldI('organDoc')));    //###  код органа
    AddStr('workplace', GetFS('workplace'));
    AddStr('workposition', GetFS('workposition'));
    AddStr('villageCouncil', VarKeyOrgan(getFldI('organDoc')));    //###  код органа
    AddStr('intracityRegion', VarKeyOrgan(getFldI('organDoc')));    //###  код органа

    // Форма 19-20
    Form19_20Write;
    // Адрес регистрации
    DsdAddress;

    AddStr('images', VarKeyOrgan(getFldI('organDoc')));    //###  код органа
    AddStr('status', VarKeyOrgan(getFldI('organDoc')));    //###  код органа
    AddStr('intracityRegion', VarKeyOrgan(getFldI('organDoc')));    //###  код органа
    end;


  // Последней была запятая, вернемся для записи конца объекта
    StreamDoc.Seek(-1, soCurrent);
    StreamDoc.WriteString('}');
    sUTF := AnsiToUtf8(StreamDoc.DataString);
    //ws := UTF8Encode();
    StreamDoc.Seek(0, soBeginning);
    StreamDoc.WriteString(sUTF);
    Result := True;
  except
    Result := False;
  end;
end;










class function TDocSetDTO.GetNsi(SOArr: ISuperObject; Nsi: TkbmMemTable; EmpTbl: Boolean = True): Integer;
  function CT(s: string): string;
  begin
    Result := s;
  end;

var
  b : Boolean;
  s : string;
  i : Integer;
  SOPK,
  SO: ISuperObject;
begin
  Result := 0;
  try
    if (EmpTbl = True) then
      Nsi.EmptyTable;
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      Nsi.Append;
      SO := SOArr.AsArray.O[i];
      Nsi.FieldByName('Type').AsInteger := SO.O[CT('klUniPK')].I[CT('type')];
      Nsi.FieldByName('Code').AsInteger := SO.O[CT('klUniPK')].I[CT('code')];
      Nsi.FieldByName('Lex1').AsString  := SO.S[CT('lex1')];
      Nsi.FieldByName('Lex2').AsString  := SO.S[CT('lex2')];
      Nsi.FieldByName('Lex3').AsString  := SO.S[CT('lex3')];
      Nsi.FieldByName('DateBegin').AsDateTime := JavaToDelphiDateTime(SO.I[CT('dateBegin')]);;
      b := SO.B[CT('active')];
      if (b = True) then
      Nsi.FieldByName('Active').AsInteger := 1
      else
      Nsi.FieldByName('Active').AsInteger := 1;
      Nsi.Post;
      i := i + 1;
    end;
    Result := i;
  except
    Result := -1;
  end;
end;







end.
