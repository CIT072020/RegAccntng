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

  // параметры для создания объекта
  TParsExchg = class(TObject)
  private
    FMeta : TSasaIniFile;
    procedure PEGenCreate;
  public
    MetaName : string;
    SectINs : string;
    SectDocs : string;
    SectChild : string;
    // Код органа регистрации (с/совета)
    Organ : string;

    property Meta : TSasaIniFile read FMeta write FMeta;

    constructor Create(MName : string); overload;
    constructor Create(MetaINI : TSasaIniFile); overload;
  end;

  // параметры для GetDocs
  TParsGet = class
    Organ   : string;
    DateBeg : TDateTime;
    DateEnd : TDateTime;
    First   : Integer;
    Count   : Integer;

    TypeDoc : string;
    FullURL : string;

    FIOrINs  : TStrings;
    // Тип данных во входном списке
    ListType : Integer;

    constructor Create(DBeg, DEnd : TDateTime; OrgCode : string = ''); overload;
    constructor Create(URL : string); overload;
    constructor Create(INs : TStrings; LType : Integer = TLIST_FIO); overload;
  end;

  // параметры для PostDocs
  TParsPost = class
  private
    FChild,
    FDocs   : TkbmMemTable;
  public
    USign   : string;
    USert   : string;
    TypeDoc : string;
    FullURL : string;

    property Docs  : TkbmMemTable read FDocs write FDocs;
    property Child : TkbmMemTable read FChild write FChild;

    constructor Create(DSign, Cert : string; URL : string = '');
  end;

(*
 Выходные результаты
*)

  // Результат для GET
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

  TResultPost = class
  private
    FCode : Integer;
    FMsg : string;
  protected
  public

    property ResCode : Integer read FCode write FCode;
    property ResMsg : string read FMsg write FMsg;
  end;


implementation

uses
  SysUtils,
  NativeXml;

procedure TParsExchg.PEGenCreate;
begin
  // Имена секций со структурами таблиц по умолчанию
  SectINs   := SCT_TBL_INS;
  SectDocs  := SCT_TBL_DOC;
  SectChild := SCT_TBL_CLD;
end;

constructor TParsExchg.Create(MName : string);
begin
  PEGenCreate;
  MetaName := MName;
end;

constructor TParsExchg.Create(MetaINI : TSasaIniFile);
begin
  PEGenCreate;
  Meta := MetaINI;
end;

// параметры для GetDocs
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

// Результат GET
constructor TResultGet.Create(Pars : TParsExchg);
begin
  INs   := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
  Docs  := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectDocs));
  Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectChild));
end;

constructor TParsPost.Create(DSign, Cert : string; URL : string = '');
begin
  USign := DSign;
  USert := Cert;
  FullURL := URL;
end;

end.
