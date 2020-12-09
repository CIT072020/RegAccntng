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
    function GetFI(sField: String): Integer;
    function GetFD(sField: String): TDateTime;
    // Код из справочного реквизита
    function GetCode(sField: String): Integer;

    // Паспортные данные
    procedure GetPasp;
    // Место рождения
    procedure GetPlaceOfBirth;
    // Место проживания
    procedure GetPlaceOfLiving;
    // Белорусская версия
    procedure GetByVer;
    // Адрес регистрации
    procedure GetROC(SODsdAddr: ISuperObject);
    // Форма 19-20
    procedure GetForm19_20(SOf20 : ISuperObject; MasterI: integer);
    // Данные по детям из внутреннего массива
    procedure GetChild(SOA: ISuperObject; MasterI: integer);

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
  Variants,
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

// Числовое целое из MemTable
function TDocSetDTO.GetFI(sField: String): Integer;
begin
  Result := FDoc.FieldByName(sField).AsInteger;
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

// Список убывших
class function TIndNomDTO.GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
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







  // Паспортные данные
procedure TDocSetDTO.GetPasp;
var
  d: TDateTime;
begin
  FDoc.FieldByName('PASP_SERIA').AsString := FSO.S[CT('docSery')];
  FDoc.FieldByName('PASP_NOMER').AsString := FSO.S[CT('docNum')];
  FDoc.FieldByName('PASP_DATE').AsDateTime := JavaToDelphiDateTime(FSO.I[CT('docDateIssue')]);
  d := STOD(FSO.S[CT('bdate')]);
  FDoc.FieldByName('DateR').AsDateTime := d;
  FDoc.FieldByName('CITIZEN').AsInteger := GetCode('citizenship');

  FDoc.FieldByName('GOSUD_R').AsInteger := FSO.O[CT('countryB')].O[CT('klUniPK')].i[CT('code')];
  FDoc.FieldByName('GOSUD_R_NAME').AsString := FSO.O[CT('countryB')].s[CT('lex1')];
end;


// Место рождения
procedure TDocSetDTO.GetPlaceOfBirth;
var
  d: TDateTime;
begin
  try

  except
  end;
end;

// Место проживания
procedure TDocSetDTO.GetPlaceOfLiving;
begin
end;

// Белорусская версия
procedure TDocSetDTO.GetByVer;
begin
end;


// Адрес регистрации
procedure TDocSetDTO.GetROC(SODsdAddr: ISuperObject);
begin
  if (Assigned(SODsdAddr) and (Not SODsdAddr.IsType(stNull))) then begin
    FDoc.FieldByName('villageCouncil').AsString := SODsdAddr.S[CT('villageCouncil')];
    FDoc.FieldByName('vilCouncilObjNum').AsInteger := SODsdAddr.I[CT('vilCouncilObjNum')];

    FDoc.FieldByName('ateObjectNum').AsInteger := SODsdAddr.I[CT('ateObjectNum')];
    FDoc.FieldByName('ateElementUid').AsInteger := SODsdAddr.I[CT('ateElementUid')];
    FDoc.FieldByName('ADRES_ID').AsInteger := SODsdAddr.I[CT('ateAddrNum')];
    FDoc.FieldByName('house').AsString := SODsdAddr.S[CT('house')];
    FDoc.FieldByName('korps').AsString := SODsdAddr.S[CT('korps')];
    FDoc.FieldByName('app').AsString := SODsdAddr.S[CT('app')];
  end;
end;

// Форма 19-20
procedure TDocSetDTO.GetForm19_20(SOf20: ISuperObject; MasterI: integer);
var
  IsF20: Boolean;
  NCh: Integer;
  SOChild: ISuperObject;
begin
  if (Assigned(SOf20) and (Not SOf20.IsType(stNull))) then begin
    IsF20 := SOf20.B[CT('signAway')];
    if (IsF20 = True) then
      FDoc.FieldByName('signAway').AsInteger := 1
    else
      FDoc.FieldByName('signAway').AsInteger := 0;

        // Сведения о детях
    try
      SOChild := FSO.O[CT('form19_20')].O[CT('infants')];
      NCh := SOChild.AsArray.Length;
    except
      NCh := 0;
    end;

    if (Assigned(SOChild)) and (NCh > 0) then begin
      GetChild(SOChild, MasterI);
    end;
    FDoc.FieldByName('DETI').AsInteger := NCh;
  end;
end;


// Данные по детям из внутреннего массива
procedure TDocSetDTO.GetChild(SOA: ISuperObject; MasterI: integer);
var
  j: Integer;
  SO: ISuperObject;
begin
  try
    for j := 0 to SOA.AsArray.Length - 1 do begin
      SO := SOA.AsArray.O[j];
      FChild.Append;
      FChild.FieldByName('ID').AsInteger := MasterI;
      FChild.FieldByName('PID').AsString := SO.S[CT('pid')];
      FChild.FieldByName('IDENTIF').AsString := SO.S[CT('identif')];
      FChild.FieldByName('FAMILIA').AsString := SO.S[CT('surname')];
      FChild.FieldByName('NAME').AsString := SO.S[CT('name')];
      FChild.FieldByName('BDATE').AsString := SO.S[CT('bdate')];
      FChild.FieldByName('DATER').AsDateTime := UnixStrToDateTime(SO.S[CT('dateRec')]);
      FChild.Post;
    end;
  except
  end;
end;


// Список DSD
function TDocSetDTO.GetDocList(SOArr: ISuperObject): Integer;
var
  s: string;
  iV, i: Integer;
  d: TDateTime;
  v: Variant;
begin
  Result := 0;
  try
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      FSO := SOArr.AsArray.O[i];
      FDoc.Append;
      FDoc.FieldByName('PID').AsString := FSO.S[CT('pid')];

      FDoc.FieldByName('view').AsInteger := GetCode('view');
      FDoc.FieldByName('LICH_NOMER').AsString := FSO.S[CT('identif')];
      FDoc.FieldByName('sysDocType').AsInteger := GetCode('sysDocType');
      FDoc.FieldByName('sysDocName').AsString := FSO.O[CT('sysDocType')].s[CT('lex1')];
      FDoc.FieldByName('Familia').AsString := FSO.S[CT('surname')];
      FDoc.FieldByName('Name').AsString := FSO.S[CT('name')];
      FDoc.FieldByName('Otch').AsString := FSO.S[CT('sname')];

      iV := GetCode('sex');
      if (iV = 21000002) then
        s := 'Ж'
      else
        s := 'М';
      FDoc.FieldByName('POL').AsString := s;

      FDoc.FieldByName('sysOrgan').AsInteger := GetCode('sysOrgan');
      FDoc.FieldByName('ORGAN').AsString := FSO.O[CT('sysOrgan')].s[CT('lex1')];

      // Паспортные данные
      GetPasp;

      // Место рождения
      GetPlaceOfBirth;
      // Место проживания
      GetPlaceOfLiving;
      // Белорусская версия
      GetByVer;
      // Адрес регистрации
      GetROC(FSO.O[CT('dsdAddressLive')]);
      // Форма 19-20
      GetForm19_20(FSO.O[CT('form19_20')], FDoc.FieldByName('MID').AsInteger);
      FDoc.Post;
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
function VarKeySysDocType(ICode : Integer = 8) : String;
begin
  Result := VarKey(-2, ICode);
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
function VarKeyCountry(ICode : Integer = 11200001) : String;
begin
  Result := VarKey(8, ICode);
end;

// Код регистрирующего органа
function VarKeySysOrgan(ICode : Integer = 0) : String;
begin
  Result := VarKey(-5, ICode);
end;

// Код типа населенного пункта
function VarKeyTypeCity(ICode : Integer = 0) : String;
begin
  Result := VarKey(35, ICode);
end;

// Тип документа
function VarKeyDocType(ICode : Integer = 0) : String;
begin
  Result := VarKey(37, ICode);
end;

// Территория/область
function VarKeyArea(ICode : Integer = 0) : String;
begin
  Result := VarKey(1, ICode);
end;

// Регион
function VarKeyRegion(ICode : Integer = 0) : String;
begin
  Result := VarKey(29, ICode);
end;

// Населенный пункт
function VarKeyCity(ICode : Integer = 0) : String;
begin
  Result := VarKey(7, ICode);
end;

// Тип Улицы
function VarKeyTypeStreet(ICode : Integer = 0) : String;
begin
  Result := VarKey(38, ICode);
end;

// Улица
function VarKeyStreet(ICode : Integer = 0) : String;
begin
  Result := VarKey(34, ICode);
end;

// Орган выдачи документа
function VarKeyOrgan(ICode : Integer = 0) : String;
begin
  Result := VarKey(24, ICode);
end;

// Сельсовет
function VarKeyVilage(ICode : Integer = 0) : String;
begin
  Result := VarKey(98, ICode);
end;

// IntrRegion
function VarKeyIntrRegion(ICode : Integer = 0) : String;
begin
  Result := VarKey(99, ICode);
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

  // Вставить число
  // Вставить логическое
  procedure AddNum(const ss1: string; ss2: Variant); overload;
  begin
    //if (VarType(ss2) = varNull) then ss2 := 'null'
    //else ss2 := IntToStr(ss2);
    ss2 := VarToStrDef(ss2, 'null');
    StreamDoc.WriteString('"' + ss1 + '":' + ss2 + ',');
  end;

  procedure AddNum(const ss1: string); overload;
  begin
       AddNum(ss1, null);
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
    AddNum('countryB', VarKeyCountry(GetFI('GOSUD_R')));
    AddStr('areaB', GetFS('areaB'));
    AddNum('typeCityB', VarKeyCity(GetFI('typeCityB')));
  except
  end;
end;

  // Место проживания
procedure SchPlaceOfLiv;
begin
  try
    AddNum('contryL', VarKeyCountry(GetFI('countryL')));
    AddNum('areaL', VarKeyArea(GetFI('areaL')));
    AddNum('regionL', VarKeyRegion(GetFI('regionL')));
    AddNum('typeCityL', VarKeyTypeCity(GetFI('typeCityL')));
    AddNum('cityL', VarKeyCity(GetFI('cityL')));
    AddNum('typeStreetL', VarKeyTypeStreet(GetFI('typeStreetL')));
    AddNum('streetL', VarKeyStreet(GetFI('streetL')));

    AddStr('house', GetFS('house'));
    AddStr('korps', GetFS('korps'));
    AddStr('app', GetFS('app'));

    AddStr('areaBBel', GetFS('areaB'));
    AddNum('regionBBelL', GetFI('regionL'));
    AddNum('cityBBel', GetFI('cityL'));

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
    AddNum('docType', VarKeyDocType(GetFI('docType')));  // тип основного документа
    AddStr('docOrgan');                                       // орган выдачи основного документа
    //AddStr('docIssueOrgan', VarKeyOrgan(GetFI('docIssueOrgan')));    //###  код органа

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
    AddNum('ateObjectNum', GetFI('ateObjectNum'));
    AddNum('ateElementUid', GetFI('ateElementUid'));
    AddNum('ateAddrNum', GetFI('ADRES_ID'));
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
    AddNum('countryPu', VarKeyCountry(GetFI('GOSUD_O')));
    AddNum('areaPu', VarKeyArea(GetFI('OBL_O')));
    //AddNum('regionPu', VarKeyRegion(GetFI('RAION_O')));

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
    AddNum('sysDocType', VarKeySysDocType(GetFI('sysDocType')));
    AddStr('surname', GetFS('Familia'));
    AddStr('name', GetFS('Name'));
    AddStr('sname', GetFS('Otch'));
    AddNum('sex', VarKeyPol(GetFS('POL')));
    AddNum('citizenship', VarKeyCountry(GetFI('CITIZEN')));
    AddNum('sysOrgan', VarKeySysOrgan(GetFI('sysOrgan')));    //###  код органа откуда отправляются данные !!!
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
    AddStr('organDoc', VarKeyOrgan(GetFI('organDoc')));    //###  код органа
    AddStr('workplace', GetFS('workplace'));
    AddStr('workposition', GetFS('workposition'));
    AddStr('villageCouncil', VarKeyOrgan(GetFI('organDoc')));    //###  код органа
    AddStr('intracityRegion', VarKeyOrgan(GetFI('organDoc')));    //###  код органа

    // Форма 19-20
    Form19_20Write;
    // Адрес регистрации
    DsdAddress;

    AddStr('images', VarKeyOrgan(GetFI('organDoc')));    //###  код органа
    AddStr('status', VarKeyOrgan(GetFI('organDoc')));    //###  код органа
    AddStr('intracityRegion', VarKeyOrgan(GetFI('organDoc')));    //###  код органа
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
