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
  public
    NeedUpper : Boolean;


    constructor Create(ChkUp : Boolean);

    class function GetDocList(SOArr: ISuperObject; Docs, Chs: TkbmMemTable): Integer;
    class function MemDoc2JSON(dsDoc: TDataSet; dsChild: TDataSet; StreamDoc: TStringStream; NeedUp : Boolean): Boolean;
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
  iV,
  i, NCh: Integer;
  d : TDateTime;
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

        Docs.FieldByName('LICH_NOMER').AsString := SO.S[CT('identif')];
        Docs.FieldByName('sysDocType').AsString := SO.O[CT('sysDocType')].O[CT('klUniPK')].s[CT('code')];
        Docs.FieldByName('sysDocName').AsString := SO.O[CT('sysDocType')].S[CT('lex1')];
        Docs.FieldByName('FAMILIA').AsString := SO.S[CT('surname')];
        Docs.FieldByName('NAME').AsString := SO.S[CT('name')];
        Docs.FieldByName('OTCH').AsString := SO.S[CT('sname')];
        iV := SO.O[CT('sex')].O[CT('klUniPK')].I[CT('code')];
        if (iV = 21000002) then s := '�' else s := '�';
        Docs.FieldByName('POL').AsString := s;

        iV := SO.O[CT('citizenship')].O[CT('klUniPK')].I[CT('code')];
        Docs.FieldByName('CITIZEN').AsInteger := iV;

        Docs.FieldByName('sysOrgan').AsInteger := SO.O[CT('sysOrgan')].O[CT('klUniPK')].I[CT('code')];
        Docs.FieldByName('ORGAN').AsString := SO.O[CT('sysOrgan')].S[CT('lex1')];

        s := SO.S[CT('bdate')];
        d := STOD(s);
        Docs.FieldByName('DateR').AsDateTime := d;

        Docs.FieldByName('PASP_SERIA').AsString := SO.S[CT('docSery')];
        Docs.FieldByName('PASP_NOMER').AsString := SO.S[CT('docNum')];
        Docs.FieldByName('PASP_DATE').AsDateTime := JavaToDelphiDateTime(SO.I[CT('docDateIssue')]);

        Docs.FieldByName('GOSUD_R').AsInteger := SO.O[CT('countryB')].O[CT('klUniPK')].I[CT('code')];
        Docs.FieldByName('GOSUD_R_NAME').AsString := SO.O[CT('countryB')].S[CT('lex1')];

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
function VarKey(nType : Integer; nValue : Int64; Emp : Boolean = False) : String;
begin
  //Result := Format('{"klUniPK":{"type":%d,"code":%d},"lex1":null,"lex2":null,"lex3":null,"dateBegin":null,"active":true}', [nType, nValue]);
  if (NOT Emp) then
    Result := Format('{"klUniPK":{"type":%d,"code":%d}}', [nType, nValue])
  else
    Result := Format('{"klUniPK":{"type":%d,"code":0}}', [nType]);
end;

// SYS-��� ���������
function VarKeySysDocType(sType : string = '8') : String;
begin
  Result := VarKey(-2, StrToInt64(sType));
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
function VarKeyCountry(sType : string = '11200001') : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(8, n);
end;

// ��� ��������������� ������
function VarKeySysOrgan(sType : string = '') : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(-5, n);
end;

// ��� ���� ����������� ������
function VarKeyTypeCity(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(35, n);
end;

// ��� ���������
function VarKeyDocType(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(37, n);
end;

// ����������/�������
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

// ������
function VarKeyRegion(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(29, n);
end;

// ���������� �����
function VarKeyCity(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(7, n);
end;

// ��� �����
function VarKeyTypeStreet(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(38, n);
end;

// �����
function VarKeyStreet(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(34, n);
end;

// ����� ������ ���������
function VarKeyOrgan(sType : string) : String;
var
  n : Int64;
begin
  n := StrToInt64(sType);
  Result := VarKey(24, n);
end;


// ���������
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



// ���� ��������� ��� POST
class function TDocSetDTO.MemDoc2JSON(dsDoc: TDataSet; dsChild: TDataSet; StreamDoc: TStringStream; NeedUp : Boolean): Boolean;
var
  s, sURL, sPar, sss, sF, sFld, sPath, sPostDoc, sResponse, sError, sStatus, sId: String;
  sUTF : UTF8String;
  ws : WideString;
  new_obj, obj: ISuperObject;
  nSpr, n, i, j: Integer;
  lOk: Boolean;

  function getFld(sField: String): String;
  begin
    Result := dsDoc.FieldByName(sField).AsString;
    if NeedUp then Result := ANSIUpperCase(Result);
  end;

  function getFldD(sField: String): TDateTime;
  begin
    Result := dsDoc.FieldByName(sField).AsDateTime;
  end;

  function getFldI(sField: String): String;
  begin
    try
    Result := IntToStr(dsDoc.FieldByName(sField).AsInteger);
    except
      Result := 'null';
    end;
  end;

  // �������� �����
  // �������� ����������
  procedure AddNum(const ss1: string; ss2: String = '');
  begin
    if (ss2 = '') then
      ss2 := 'null';
    StreamDoc.WriteString('"' + ss1 + '":' + ss2 + ',');
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
// ����� 19-20
procedure Form19_20Write;
begin
  try
    StreamDoc.WriteString('"form19_20":{');
    AddStr('form19_20Base', 'form19_20');
    AddNum('signAway', 'false');
    AddDJ('dateReg', getFldD('DATEZ'));
    AddNum('countryPu', VarKeyCountry(getFldI('GOSUD_O')));
    AddNum('areaPu', VarKeyArea(getFld('OBL_O')));
    //AddNum('regionPu', VarKeyRegion(getFldI('RAION_O')));

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
    AddStr('identif', getFld('LICH_NOMER'));
  //AddNum( 'view', createSpr(-3, 10));
    AddNum('view');
    AddNum('sysDocType', VarKeySysDocType(getFld('sysDocType')));
    AddStr('surname', getFld('Familia'));
    AddStr('name', getFld('Name'));
    AddStr('sname', getFld('Otch'));
    AddNum('sex', VarKeyPol(getFld('POL')));
    AddNum('citizenship', VarKeyCountry(getFld('CITIZEN')));
    AddNum('sysOrgan', VarKeySysOrgan(getFld('sysOrgan')));    //###  ��� ������ ������ ������������ ������ !!!

    AddStr('bdate', DTOSDef(getFldD('DateR'), tdClipper, '')); // 19650111
    AddStr('dsdDateRec');                                      // ���� ������ ???
    AddStr('docSery', getFld('PASP_SERIA'));                       // ����� ��������� ���������
    AddStr('docNum', getFld('PASP_NOMER'));                       // ����� ��������� ���������
    AddDJ('docDateIssue', getFldD('PASP_DATE'));           // ���� ������ ��������� ���������
    //AddDJ('docAppleDate', getFldD('docAppleDate'));            // ���� ������ ���������  ???
    //AddDJ('dateRec', getFldD('dateRec'));                      // ��������� ���� ������  ???
    AddNum('ateAddress');                                      // ???
    AddDJ('expireDate', getFldD('expireDate'));                // ���� ��������  ???
    AddNum('aisPasspDocStatus');                               // ???
    AddNum('identifCheckResult');                               // ???

    Form19_20Write;

    if (False) then begin
  // ����� ��������
    AddNum('countryB', VarKeyCountry(getFldI('GOSUD_R')));
    AddStr('areaB', getFld('areaB'));
    AddNum('typeCityB', VarKeyCity(getFldI('typeCityB')));
    AddNum('docType', VarKeyDocType(getFld('docType')));  // ��� ��������� ���������
    AddStr('docOrgan');                                       // ����� ������ ��������� ���������

    AddNum('contryL', VarKeyCountry(getFldI('countryL')));
    AddNum('areaL', VarKeyArea(getFldI('areaL')));
    AddNum('regionL', VarKeyRegion(getFldI('regionL')));
    AddNum('typeCityL', VarKeyTypeCity(getFldI('typeCityL')));
    AddNum('cityL', VarKeyCity(getFldI('cityL')));
    AddNum('typeStreetL', VarKeyTypeStreet(getFldI('typeStreetL')));
    AddNum('streetL', VarKeyStreet(getFldI('streetL')));

    AddStr('house', getFld('house'));
    AddStr('korps', getFld('korps'));
    AddStr('app', getFld('app'));

    AddStr('organDoc', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������
    AddStr('workplace', getFld('workplace'));
    AddStr('workposition', getFld('workposition'));

    AddStr('docIssueOrgan', VarKeyOrgan(getFldI('docIssueOrgan')));    //###  ��� ������
    AddStr('surnameBel', getFld('FAMILIA'));
    AddStr('nameBel', getFld('NAME'));
    AddStr('snameBel', getFld('OTCH'));

    AddStr('surnameEn', getFld('FAMILIA'));
    AddStr('nameEn', getFld('NAME'));

    AddStr('areaBBel', getFld('areaB'));
    AddNum('regionBBelL', getFldI('regionL'));
    AddNum('cityBBel', getFldI('cityL'));

    AddStr('villageCouncil', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������
    AddStr('intracityRegion', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������


    AddStr('dsdAddressLive', getFldI('organDoc'));    //###  ��� ������
    AddStr('images', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������
    AddStr('status', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������
    AddStr('intracityRegion', VarKeyOrgan(getFldI('organDoc')));    //###  ��� ������
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

end.
