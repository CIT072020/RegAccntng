unit uDTO;

interface

uses
  Classes,
  //DB,
  kbmMemTable,
  superobject,
  //httpsend,
  uService;

type
  TIndNomDTO = class
  public
    class function GetIndNumList(SOArr: ISuperObject; IndNum : TkbmMemTable; EmpTbl : Boolean = True): Integer;
  end;

  TDocSetDTO = class
  public
    class function GetDocList(SOArr: ISuperObject; Docs, Chs: TkbmMemTable): Integer;
  end;

implementation

uses
  SysUtils,
  NativeXml;

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
      IndNum.FieldByName('DATEREC').AsDateTime      := sdDateTimeFromString(SO.S[CT('REG_DATE')], false);
      IndNum.FieldByName('ORG_WHERE_CODE').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('CODE')];
      IndNum.FieldByName('ORG_WHERE_NAME').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('LEX')];
      IndNum.FieldByName('ORG_FROM_CODE').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('CODE')];
      IndNum.FieldByName('ORG_FROM_NAME').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('LEX')];
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





















procedure TStringStream.WriteString(const AString: string);
begin
  Write(PChar(AString)^, Length(AString));
end;

//-------------------------------------------------------
function CheckUP(s:String):String;
begin
  if FCharUpper
    then Result:=ANSIUpperCase(s)
    else Result:=s;
end;

function createSpr(nType:Integer; nValue:Int64):String;
begin
  Result:=Format('{ "klUniPK": { "type": %d, "code": %d } }', [nType, nValue]);
end;


//
function TDocSetDTO.MemDoc2JSON(slPar:TStringList; dsDoc:TDataSet; dsChild:TDataSet): Boolean;
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

  nType
  :SuperInt;

  function getFld(sField:String):String;
  begin Result := CheckUP(dsDoc.FieldByName(sField).AsString); end;

  function getFldD(sField:String):TDateTime;
  begin Result := dsDoc.FieldByName(sField).AsDateTime; end;

  function getFldI(sField:String):Integer;
  begin Result := dsDoc.FieldByName(sField).AsInteger; end;

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

  spDoc:=TStringStream.Create('');
  spDoc.WriteString('{'#13#10);

  smesh:='  ';
  addstd( 'view', createSpr(-3, 10));
  addstd( 'sysDocType', createSpr(-2, 8));
  addstdS('identif', getFld('LICH_NOMER'));
  addstdS('surname', getFld('FAMILIA'));
  addstdS('name', getFld('NAME'));
  addstdS('sname', getFld('OTCH'));

  addstd( 'sex', createPol(getFld('POL') ));
  addstd( 'citizenship', createGrag(getFldI('CITIZEN')) );
  addstd( 'bdate', DTOSDef(getFldD('DATER'), tdClipper, '')); // 19650111
  addstd( 'sysOrgan', createSpr(-5, 26));    //###  ��� ������ ������ ������������ ������ !!!
  addstd( 'dsdDateRec', 'null');  // ���� ������

  addstd( 'docType', createTypeDoc(getFldI('PASP_UDOST')));   // ��� ��������� ���������
  addstd( 'docOrgan', 'null'); // ###      PASP_ORGAN              ����� ������ ��������� ���������
  addDJ(  'docDateIssue', getFldD('PASP_DATE'));  // ���� ������ ��������� ���������
  addDJ(  'docAppleDate', getFldD('DATEZ'));      // ���� ������ ���������  ???
  addDJ(  'dateRec', getFldD('DATEZ'));           // ��������� ���� ������  ???

  addstd( 'countryB', createCountry(getFldI('GOSUD_R')));
  addstdS('areaB', createObl(getFld('OBL_R'), dsDoc.FieldByName('B_OBL_R')));
  addstd( 'typeCityB', createTypeCity(getFldI('GOROD_R_B')));

  //----- ����� 19-20 ------------------------------------------------
  spDoc.WriteString(smesh+'"form19_20": {'#13#10);
    smesh:='    ';
    addstdS('form19_20Base', 'form19_20');   //
    addstd( 'pid', '0');           //
    addstd( 'signAway', 'true');   //  ������-����(0- ������, 1 - ����)  � ������� false true ???
    // ���� ������ - ���� ����
    addstd( 'countryPu', createCountry(getFldI('GOSUD_O')));
    addstdS('areaPu', createObl(getFld('OBL_O'), dsDoc.FieldByName('B_OBL_O')));
    addstdS('regionPu', getFld('RAION_O'));
    addstd( 'typeCityPu', createTypeCity(getFldI('GOROD_O_B')));
    addstdS('cityPu', getFld('GOROD_O'));
    //--- ������ ������ �������� UL_O ---   ###
    addstd( 'typeStreetPu', createSpr(38, 0));
    addstd( 'streetPu', 'null');
    addstd( 'housePu', 'null');
    addstd( 'korpsPu', 'null');
    addstd( 'appPu', 'null');
    //-------------------------------------------------
    addstd( 'datePu', 'null');    // ###   ���� ������-��������
    addstd( 'marks', createSpr(2, 0));   // ###  ������ �������
    addstd( 'notes', 'null');   // ###
    addstd( 'term', 'null');    // ###  ����
    addstd( 'reason', createSpr(3, 2));    // ###  ���� ��������-������
    addDJ(  'dateRec', Now);    // ###  ��������� ���� ������
    addDJ(  'dateReg', Date);   // ###  ���� ��������
    addstd( 'termReg', createSpr( 27, 4));  // ###  ���� ��������  1-��������� 2-�� ��������� ���������� 3-�� 3-� ������� 4-�� 6-�� ������� 5-�� ���������� ����
    addDJ(  'dateRegTill', getFldD('DATE_SROK'));  // ���� ����� �� nil   ���� ��
    addstd( 'causeIssue', createSpr( 39, 59200021));  // ###  ������� ������ ���������
    addstd( 'deathDate', 'null');     // ���� ������ (� ������ �������� ��� ������ ���������)
    addstd( 'signNoTake', 'false');  // ������� � ����������� �������� (� ������ �������� ��� ������ ���������)
    addstd( 'signNoReg', 'false');   // ������� � ��������� �������� ��� �������� (� ������ �������� ��� ������ ���������)
    addstd( 'signDestroy', 'false'); // ������� ������� ��������� ��� ���������������� (� ������ �������� ��� ������ ���������)
    addstd( 'noAddrPu', createSpr( 70,  0));  // ###  ��������-������ ��� ������
    addstd( 'regType', createSpr(500, 2));  // ### TYPEREG 1-���������� ���. 2-��������� ���.
    addstd( 'maritalStatus', createSem(getFldI('SEM')));  // �������� ���������
    addstd( 'education', createObraz(getFldI('OBRAZ')));  // �����������
    addstd( 'student', 'false');  // ### �������  ��� ������ ���������
    //------ ���� ----------------------------
//    addstd( 'infants', '[]'); // ����
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
  addstd('getPassportDate', 'null');  // ���� ��������� ��������
  addstd('images', '[]');
  addstd('addressLast', 'null');      // ��������� ����� ???
  addstd('dossieStatus', 'null');     // ������ ���������
  spDoc.WriteString(smesh+'"status": null'#13#10);  // ������
  spDoc.WriteString('}');

  sPostDoc:=AnsiToUtf8(spDoc.DataString);

  MemoWrite('1', sPostDoc);
  spDoc.Free;
//  new_obj.SaveTo('2',false,false);
  //============================================
//  ws:=new_obj.AsJSon(true,false);
//  sPostDoc:=UTF8Encode(ws);
//  MemoWrite('1', sPostDoc); // ���� � ��������� UTF-8
//  new_obj:=nil;

//  exit;
  MemoRead('SaveDocTest.json', sPostDoc); // ���� � ��������� UTF-8

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
    WriteTextLog('�������� ������:'#13#10+FLastError, TEXT_ERROR);
  end else begin
    sw:=Utf8Decode(sResponse);
//  {  "status": 1, "id": 90021850,  "error": null  }
//  {  "status": 0, "id": null,      "error": "�� ������� ��������� ������ � ��" }
    lOk:=true;
    try
      new_obj:=so(sw);
    except
      on E:Exception do begin
        lOK:=false;
        WriteTextLog('���������� ��������� ����� �������:'#13#10+Utf8ToAnsi(sResponse), TEXT_ERROR);
      end;
    end;
    if lOk and (new_obj<>nil) then begin
      WriteDebugFile('_saveDoc.json',Utf8ToAnsi(sResponse));
      sStatus:=new_obj.S['status'];
      if sStatus='1' then begin
        sId:=new_obj.S['id'];
        sError:='';
        WriteTextLog('������ '+getIDSave(dsDoc)+' ������� ����������', TEXT_OK);
//        ShowMessageCont(,nil);
      end else begin
        sId:='';
        sError:=new_obj.S['error'];
        FLastError:=sError+', ������ '+getIDSave(dsDoc);
        WriteTextLog(FLastError, TEXT_ERROR);
        Result:=false;
      end;
    end;
    new_obj:=nil;
  end;
  sl.Free;
end;














end.
