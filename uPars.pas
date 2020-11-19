unit uPars;

interface

uses
  Classes,
  //DB,
  kbmMemTable,
  //superobject,
  //httpsend,
  SasaINiFile,
  uService;


type
  TAuth = class
  end;

  // ��������� ��� �������� �������
  TParsExchg = class
  private
    FMeta : TSasaIniFile;
  public
    MetaName : string;
    SectINs : string;
    SectDocs : string;
    SectChild : string;
    // ��� ������ ����������� (�/������)
    Organ : string;

    property Meta : TSasaIniFile read FMeta write FMeta;
    constructor Create(MName : string);
  end;

  // ��������� ��� GetDocs
  TParsGet = class
    Organ   : string;
    DateBeg : TDateTime;
    DateEnd : TDateTime;
    First   : Integer;
    Count   : Integer;

    TypeDoc : string;
    FullURL : string;

    FIOrINs  : TStrings;
    // ��� ������ �� ������� ������
    ListType : Integer;

    constructor Create(DBeg, DEnd : TDateTime; OrgCode : string = ''); overload;
    constructor Create(URL : string); overload;
    constructor Create(INs : TStrings; LType : Integer = TLIST_FIO); overload;
  end;

  // ��������� ��� SetDocs
  TParsSet = class
  end;

(*
 �������� ����������
*)

  // ��������� ��� GET
  TResultGet = class
  private
    FChild,
    FDocs,
    FINs : TkbmMemTable;
    FCode : Integer;
    FMsg : string;
  protected
  public
    property INs   : TkbmMemTable read FINs write FINs;
    property Docs  : TkbmMemTable read FDocs write FDocs;
    property Child : TkbmMemTable read FChild write FChild;

    property ResCode : Integer read FCode write FCode;
    property ResMsg : string read FMsg write FMsg;

    constructor Create(Pars : TParsExchg);
  end;

  TResultSet = class
  end;


implementation

uses
  SysUtils,
  NativeXml;

constructor TParsExchg.Create(MName : string);
begin
  MetaName  := MName;
  SectINs   := SCT_TBL_INS;
  SectDocs  := SCT_TBL_DOC;
  SectChild := SCT_TBL_CLD;
end;

constructor TParsGet.Create(DBeg, DEnd : TDateTime; OrgCode : string = '');
begin
  DateBeg := DBeg;
  DateEnd := DEnd;
  Organ   := OrgCode;
  FullURL := '';
end;

constructor TParsGet.Create(URL : string);
begin
  FullURL := URL;
end;

constructor TParsGet.Create(INs : TStrings; LType : Integer = TLIST_FIO);
begin
  FIOrINs := INs;
  ListType := LType;
end;

// ��������� GET
constructor TResultGet.Create(Pars : TParsExchg);
begin
  INs   := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
  Docs  := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectDocs));
  Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectChild));
end;


end.
