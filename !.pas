  procedure write_str_new_obj(sPath:SOString; sValue:String);
  begin
    if sValue='' then new_obj.O[sPath]:=nil else new_obj.S[sPath]:=sValue;
  end;
  procedure write_datej_new_obj(sPath:SOString; dValue:TDateTime);
  begin
    if dValue=0 then new_obj.O[sPath]:=nil else new_obj.I[sPath]:=createJavaDate(dValue);
  end;



  new_obj:=so;
//  new_obj.I['view.klUniPK.type']:=-3;
//  new_obj.I['view.klUniPK.code']:=10;
  new_obj.O['view']:=so('{ "klUniPK": { "type": -3, "code": 10  }  }');
  new_obj.O['sysDocType']:=so('{ "klUniPK": { "type": -2, "code": 8 } }');
  new_obj.S['identif']:=getFld('LICH_NOMER');
  new_obj.S['surname']:=getFld('FAMILIA');
  new_obj.S['name']:=getFld('NAME');
  new_obj.S['sname']:=getFld('OTCH');
  new_obj.S['surnameBel']:='���';  //###
  new_obj.S['nameBel']:='������';    //###
  new_obj.S['snameBel']:='�����������';   //###
  new_obj.S['surnameEnl']:='CREE';   //###
  new_obj.S['nameEn']:='RAJESH';     //###

//   "surnameBel": "���",    "nameBel": "������",  "snameBel": "�����������",  "surnameEn": "CREE",  "nameEn": "RAJESH",
  new_obj.O['sex']:=createPol(getFld('POL'));
//  new_obj.I['sex.klUniPK.code']:=codePol(getFld('POL'),nType);
//  new_obj.I['sex.klUniPK.type']:=nType;
  new_obj.O['citizenship']:=createGrag(getFld('CITIZEN'));
  new_obj.S['bdate']:=DTOSDef(getFldD('DATER'), tdClipper, ''); // 19650111
  new_obj.O['dsdDateRec']:=nil;  // ���� ������

  write_str_new_obj('docSery', getFld('PASP_SERIA'));
  write_str_new_obj('docNum', getFld('PASP_NOMER'));
  new_obj.O['docType']:=createTypeDoc(getFld('PASP_UDOST'));   // ��� ��������� ���������
  new_obj.O['docOrgan']:=nil; // ###      PASP_ORGAN              ����� ������ ��������� ���������

  write_datej_new_obj('docDateIssue', getFldD('PASP_DATE'));  // ���� ������ ��������� ���������
  write_datej_new_obj('docAppleDate', getFldD('DATEZ'));      // ���� ������ ���������  ???
  write_datej_new_obj('dateRec', getFldD('DATEZ'));           // ��������� ���� ������  ???

//  new_obj.S['dateRec2']:=createISODate(Now);

  new_obj.O['organDoc']:=so('{"klUniPK": { "type": 24, "code": 17608347 } }');        // ###
  new_obj.O['docIssueOrgan']:=so('{"klUniPK": { "type": 24, "code": 17608931 } }');   // ###

  new_obj.O['countryB']:=createCountry(getFld('GOSUD_R'));
  write_str_new_obj('areaB', createObl(getFld('OBL_R'), dsDoc.FieldByName('B_OBL_R')));
  write_str_new_obj('regionB', getFld('RAION_R'));
  new_obj.O['typeCityB']:=createTypeCity(getFld('GOROD_R_B'));
  write_str_new_obj('cityB', getFld('GOROD_R'));
  new_obj.O['areaBBel']:=nil;
  new_obj.O['regionBBel']:=nil;
  new_obj.O['cityBBel']:=nil;

  write_str_new_obj('workPlace', getFld('WORK_NAME'));
  write_str_new_obj('workPosition', getFld('DOLG_NAME'));
  new_obj.O['villageCouncil']:=so('{"klUniPK":{"type": 98, "code": 0} }');     // �������� �����  ###
  new_obj.O['intracityRegion']:=so('{"klUniPK":{"type": 99, "code": 0} }');    // ��������������� �����  ###
  new_obj.O['ateAddress']:=nil;          // ### ������ ������������ �������� ???
  new_obj.O['expireDate']:=nil;          //  ???
  new_obj.O['aisPasspDocStatus']:=nil;   //  ???

  new_obj.S['form19_20.form19_20Base']:='form19_20';   //
  new_obj.I['form19_20.pid']:=0;   //
  new_obj.B['form19_20.signAway']:=true;   //    ������-����(0- ������, 1 - ����)  � ������� false true ???
  // ���� ������ - ���� ����
  new_obj.O['form19_20.countryPu']:=createCountry(getFld('GOSUD_O'));
  write_str_new_obj('form19_20.areaPu', createObl(getFld('OBL_O'), dsDoc.FieldByName('B_OBL_O')));
  write_str_new_obj('form19_20.regionPu', getFld('RAION_O'));
  new_obj.O['form19_20.typeCityPu']:=createTypeCity(getFld('GOROD_O_B'));
  write_str_new_obj('form19_20.cityPu', getFld('GOROD_O'));

  //--------- ������ ������ �������� UL_O -----------
  new_obj.O['form19_20.typeStreetPu']:=so('{"klUniPK":{"type": 38, "code": 0 } }');
  new_obj.O['form19_20.streetPu']:=nil;
  new_obj.O['form19_20.housePu']:=nil;
  new_obj.O['form19_20.korpsPu']:=nil;
  new_obj.O['form19_20.appPu']:=nil;
  //-------------------------------------------------
  new_obj.O['form19_20.datePu']:=nil;    // ###   ���� ������-��������
  new_obj.O['form19_20.marks']:=so('{ "klUniPK": { "type": 2, "code": 0 } }');   // ###  ������ �������
  new_obj.O['form19_20.term']:=nil;    // ###  ����
  new_obj.O['form19_20.reason']:=so('{ "klUniPK": { "type": 3, "code": 2 } }');    // ###  ���� ��������-������
  new_obj.I['form19_20.dateRec']:=createJavaDate(Now);    // ###  ��������� ���� ������
  new_obj.I['form19_20.dateReg']:=createJavaDate(Date);   // ###  ���� ��������
  new_obj.O['form19_20.termReg']:=so('{"klUniPK": { "type": 27, "code": 4} }');  // ###  ���� ��������  1-��������� 2-�� ��������� ���������� 3-�� 3-� ������� 4-�� 6-�� ������� 5-�� ���������� ����
  write_datej_new_obj('form19_20.dateRegTill', getFldD('DATE_SROK'));  // ���� ����� �� nil   ���� ��
  new_obj.O['form19_20.causeIssue']:=so('{"klUniPK": { "type": 39, "code": 59200021 } }');  // ###  ������� ������ ���������
  new_obj.O['form19_20.deathDate']:=nil;     // ���� ������ (� ������ �������� ��� ������ ���������)
  new_obj.B['form19_20.signNoTake']:=false;  // ������� � ����������� �������� (� ������ �������� ��� ������ ���������)
  new_obj.B['form19_20.signNoReg']:=false;   // ������� � ��������� �������� ��� �������� (� ������ �������� ��� ������ ���������)
  new_obj.B['form19_20.signDestroy']:=false; // ������� ������� ��������� ��� ���������������� (� ������ �������� ��� ������ ���������)
  new_obj.O['form19_20.noAddrPu']:=so('{"klUniPK": {"type": 70, "code": 0} }');  // ###  ��������-������ ��� ������
  new_obj.O['form19_20.regType']:=so('{ "klUniPK":  {"type": 500,"code": 2 }');  // ### TYPEREG 1-���������� ���. 2-��������� ���.
  new_obj.O['form19_20.maritalStatus']:=createSem(getFld('SEM'));  // �������� ���������
  new_obj.O['form19_20.education']:=createObraz(getFld('OBRAZ'));  // �����������
  new_obj.B['form19_20.student']:=false;  // ### �������  ��� ������ ���������
  new_obj.O['form19_20.infants']:=so([]); // ### ����

  new_obj.S['dsdAddressLive.dsdAddressLiveBase']:='dsdAddressLive';
  new_obj.I['dsdAddressLive.pid']:=0;
  new_obj.I['dsdAddressLive.house']:=32;
  new_obj.O['dsdAddressLive.korps']:=nil;
  new_obj.O['dsdAddressLive.app']:=nil;
  new_obj.I['dsdAddressLive.ateObjectNum']:=21293;
  new_obj.O['dsdAddressLive.ateElementUid']:=nil;
  new_obj.O['dsdAddressLive.ateAddrNum']:=nil;

  new_obj.O['getPassportDate']:=nil;  // ���� ��������� ��������
  new_obj.O['images']:=sa([]);
  new_obj.O['addressLast']:=nil;     // ��������� ����� ???
  new_obj.O['dossieStatus']:=nil;    // ������ ���������
  new_obj.O['status']:=nil;          // ������
