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
    SectNsi : string;
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
    PID     : string;

    TypeDoc : string;
    FullURL : string;

    FIOrINs  : TStringList;
    // Тип данных во входном списке
    ListType : Integer;

    constructor Create(DBeg, DEnd : TDateTime; OrgCode : string = ''); overload;
    constructor Create(URL : string); overload;
    constructor Create(INs : TStringList; LType : Integer = TLIST_FIO); overload;
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
    FNsi,
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
    property Nsi   : TkbmMemTable read FNsi write FNsi;

    property ResCode : Integer read FCode write FCode;
    property ResMsg : string read FMsg write FMsg;

    constructor Create(Pars : TParsExchg; NSIOnly : Boolean = False);
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
  SectNsi   := SCT_TBL_NSI;
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

constructor TParsGet.Create(INs : TStringList; LType : Integer = TLIST_FIO);
begin
  FIOrINs := INs;
  ListType := LType;
end;

// Результат GET
constructor TResultGet.Create(Pars: TParsExchg; NSIOnly: Boolean = False);
begin
  if (NSIOnly = False) then begin
    INs := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
    Docs := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectDocs));
    Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectChild));
  end;
  Nsi := TkbmMemTable(CreateMemTable(MT_NSI, Pars.Meta, Pars.SectNsi));
end;

constructor TParsPost.Create(DSign, Cert : string; URL : string = '');
begin
  USign := DSign;
  USert := Cert;
  FullURL := URL;
end;

end.
