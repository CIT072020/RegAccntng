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
  // ������ ������ ��
  TIndNomDTO = class
  public
    class function GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
  end;

  // ������/������ ������������ ������
  TDocSetDTO = class
  private
    // MemTable with Docs
    FDoc : TDataSet;
    FChild : TDataSet;
    FSO : ISuperObject;

    function GetFS(sField: String): String;
    function GetFI(sField: String): Integer;
    function GetFD(sField: String): TDateTime;
    // ��� �� ����������� ���������
    function GetCode(sField: String): Integer;

    // ���������� ������
    procedure GetPasp;
    // ����� ��������
    procedure GetPlaceOfBirth;
    // ����� ����������
    procedure GetPlaceOfLiving;
    // ����������� ������
    procedure GetByVer;
    // ����� �����������
    procedure GetROC(SODsdAddr: ISuperObject);
    // ����� 19-20
    procedure GetForm19_20(SOf20 : ISuperObject; MasterI: integer);
    // ������ �� ����� �� ����������� �������
    procedure GetChild(SOA: ISuperObject; MasterI: integer);

  public
    NeedUpper : Boolean;

    // ������ ���������� �� SuperObject ��������� � MemTable
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

// ��������� �� MemTable
function TDocSetDTO.GetFS(sField: String): String;
begin
  Result := FDoc.FieldByName(sField).AsString;
end;

// �������� ����� �� MemTable
function TDocSetDTO.GetFI(sField: String): Integer;
begin
  Result := FDoc.FieldByName(sField).AsInteger;
end;


// ���� �� MemTable
function TDocSetDTO.GetFD(sField: String): TDateTime;
begin
  Result := FDoc.FieldByName(sField).AsDateTime;
end;

// ��� �� ����������� ���������
function TDocSetDTO.GetCode(sField: String): Integer;
begin
  Result := FSO.O[sField].O['klUniPK'].I['code'];
end;

// ������ �������
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







  // ���������� ������
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


// ����� ��������
procedure TDocSetDTO.GetPlaceOfBirth;
var
  d: TDateTime;
begin
  try

  except
  end;
end;

// ����� ����������
procedure TDocSetDTO.GetPlaceOfLiving;
begin
end;

// ����������� ������
procedure TDocSetDTO.GetByVer;
begin
end;


// ����� �����������
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

// ����� 19-20
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

        // �������� � �����
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


// ������ �� ����� �� ����������� �������
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


// ������ DSD
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
        s := '�'
      else
        s := '�';
      FDoc.FieldByName('POL').AsString := s;

      FDoc.FieldByName('sysOrgan').AsInteger := GetCode('sysOrgan');
      FDoc.FieldByName('ORGAN').AsString := FSO.O[CT('sysOrgan')].s[CT('lex1')];

      // ���������� ������
      GetPasp;

      // ����� ��������
      GetPlaceOfBirth;
      // ����� ����������
      GetPlaceOfLiving;
      // ����������� ������
      GetByVer;
      // ����� �����������
      GetROC(FSO.O[CT('dsdAddressLive')]);
      // ����� 19-20
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

// SYS-��� ���������
function VarKeySysDocType(ICode : Integer = 8) : String;
begin
  Result := VarKey(-2, ICode);
end;

// �������/�������
function VarKeyPol(sType : string = '�') : String;
var
  n : Int64;
begin
  if (sType = '�') then n := 21000001 else n := 21000002;
  Result := VarKey(32, n);
end;

// ��� �����������
function VarKeyCountry(ICode : Integer = 11200001) : String;
begin
  Result := VarKey(8, ICode);
end;

// ��� ��������������� ������
function VarKeySysOrgan(ICode : Integer = 0) : String;
begin
  Result := VarKey(-5, ICode);
end;

// ��� ���� ����������� ������
function VarKeyTypeCity(ICode : Integer = 0) : String;
begin
  Result := VarKey(35, ICode);
end;

// ��� ���������
function VarKeyDocType(ICode : Integer = 0) : String;
begin
  Result := VarKey(37, ICode);
end;

// ����������/�������
function VarKeyArea(ICode : Integer = 0) : String;
begin
  Result := VarKey(1, ICode);
end;

// ������
function VarKeyRegion(ICode : Integer = 0) : String;
begin
  Result := VarKey(29, ICode);
end;

// ���������� �����
function VarKeyCity(ICode : Integer = 0) : String;
begin
  Result := VarKey(7, ICode);
end;

// ��� �����
function VarKeyTypeStreet(ICode : Integer = 0) : String;
begin
  Result := VarKey(38, ICode);
end;

// �����
function VarKeyStreet(ICode : Integer = 0) : String;
begin
  Result := VarKey(34, ICode);
end;

// ����� ������ ���������
function VarKeyOrgan(ICode : Integer = 0) : String;
begin
  Result := VarKey(24, ICode);
end;

// ���������
function VarKeyVilage(ICode : Integer = 0) : String;
begin
  Result := VarKey(98, ICode);
end;

// IntrRegion
function VarKeyIntrRegion(ICode : Integer = 0) : String;
begin
  Result := VarKey(99, ICode);
end;


// ���� ��������� ��� POST
function TDocSetDTO.MemDoc2JSON(dsDoc: TDataSet; dsChild: TDataSet; StreamDoc: TStringStream; NeedUp : Boolean): Boolean;
var
  s, sURL, sPar, sss, sF, sFld, sPath, sPostDoc, sResponse, sError, sStatus, sId: String;
  sUTF : UTF8String;
  ws : WideString;
  new_obj, obj: ISuperObject;
  nSpr, n, i, j: Integer;
  lOk: Boolean;

  // �������� �����
  // �������� ����������
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



  // �������� ������

  procedure AddStr(const ss1: string; ss2: String = '');
  begin
    if (ss2 = '') then
      ss2 := 'null'
    else
      ss2 := '"' + ss2 + '"';
    StreamDoc.WriteString('"' + ss1 + '": ' + ss2 + ',');
  end;
  // �������� ����

  procedure AddDJ(ss1: String; dValue: TDateTime);
  begin
    if (dValue = 0) then
      sss := 'null'
    else
      sss := IntToStr(Delphi2JavaDate(dValue));
    StreamDoc.WriteString('"' + ss1 + '": ' + sss + ',');
  end;



  // ����� ��������
procedure SchPlaceOfBorn;
begin
  try
    AddNum('countryB', VarKeyCountry(GetFI('GOSUD_R')));
    AddStr('areaB', GetFS('areaB'));
    AddNum('typeCityB', VarKeyCity(GetFI('typeCityB')));
  except
  end;
end;

  // ����� ����������
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

  // ����� �������
procedure SchPasport;
begin
  try
    AddStr('docSery', GetFS('PASP_SERIA'));                       // ����� ��������� ���������
    AddStr('docNum', GetFS('PASP_NOMER'));                       // ����� ��������� ���������
    AddDJ('docDateIssue', GetFD('PASP_DATE'));           // ���� ������ ��������� ���������
    //AddDJ('docAppleDate', getFldD('docAppleDate'));            // ���� ������ ���������  ???
    AddDJ('expireDate', GetFD('expireDate'));                // ���� ��������  ???
    //AddNum('aisPasspDocStatus');                               // ???
    AddNum('docType', VarKeyDocType(GetFI('docType')));  // ��� ��������� ���������
    AddStr('docOrgan');                                       // ����� ������ ��������� ���������
    //AddStr('docIssueOrgan', VarKeyOrgan(GetFI('docIssueOrgan')));    //###  ��� ������

    //AddStr('surnameBel', getFld('FAMILIA'));
    //AddStr('nameBel', getFld('NAME'));
    //AddStr('snameBel', getFld('OTCH'));

    //AddStr('surnameEn', getFld('FAMILIA'));
    //AddStr('nameEn', getFld('NAME'));
  except
  end;
end;

// ��������� dsdAddressLive
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

  // ��������� ���� �������, �������� ��� ������ ����� �������
    StreamDoc.Seek(-1, soCurrent);
    StreamDoc.WriteString('},');

  except
  end;
end;


// ����� 19-20
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

  // ��������� ���� �������, �������� ��� ������ ����� �������
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
    AddNum('sysOrgan', VarKeySysOrgan(GetFI('sysOrgan')));    //###  ��� ������ ������ ������������ ������ !!!
    AddStr('bdate', DTOSDef(GetFD('DateR'), tdClipper, '')); // 19650111
    AddStr('dsdDateRec');                                      // ���� ������ ???

    // ����� �������
    SchPasport;

    //AddStr('regNum');                                      // ���� ������ ???
    //AddDJ('dateRec', getFldD('dateRec'));                      // ��������� ���� ������  ???
    //AddNum('ateAddress');                                      // ???
    //AddNum('identifCheckResult');                               // ???

    // ����� ��������
    SchPlaceOfBorn;

    // ����� ����������
    SchPlaceOfLiv;


    if (False) then begin
    AddStr('organDoc', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������
    AddStr('workplace', GetFS('workplace'));
    AddStr('workposition', GetFS('workposition'));
    AddStr('villageCouncil', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������
    AddStr('intracityRegion', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������

    // ����� 19-20
    Form19_20Write;
    // ����� �����������
    DsdAddress;

    AddStr('images', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������
    AddStr('status', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������
    AddStr('intracityRegion', VarKeyOrgan(GetFI('organDoc')));    //###  ��� ������
    end;


  // ��������� ���� �������, �������� ��� ������ ����� �������
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
