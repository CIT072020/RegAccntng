unit uPars;

interface

uses
  Classes,
  //DB,
  adscnnct, adstable,
  kbmMemTable,
  //superobject,
  //httpsend,
  SasaINiFile,
  uService;


type
  // параметры для создания объекта обмена с ROC
  TParsExchg = class(TObject)
  private
    FMeta : TSasaIniFile;
    procedure PEGenCreate;
  public
    MetaName : string;
    SectADM : string;
    SectINs : string;
    SectDocs : string;
    SectChild : string;
    SectNsi : string;
    // Код органа регистрации (ГиМ)
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
    // Нужны актуальные сведения по ИН или убывшие
    NeedActual : Boolean;

    constructor Create(DBeg, DEnd : TDateTime; OrgCode : string = ''); overload;
    constructor Create(URL : string); overload;
    constructor Create(INs : TStringList; LType : Integer = TLIST_FIO); overload;
  end;

  // параметры для GetNsi
  TParsNsi = class
    NsiType : Integer;
    NsiCode : Integer;
    FullURL : string;
    ConnADS : TAdsConnection;
    ADSCopy : Boolean;

    constructor Create(NType : Integer; Conn : TAdsConnection); overload;
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
    JSONSrc : string;

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

    constructor Create(Pars: TParsExchg; WhatMT : Integer = DATA_ONLY);
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
  SectADM   := SCT_ADMIN;
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
  MetaName := MetaINI.FileName;
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

//
constructor TParsNsi.Create(NType : Integer; Conn : TAdsConnection);
begin
  NsiType := NType;
  NsiCode := 0;
  ConnADS := Conn;
  ADSCopy := True;
  FullURL := '';
end;



// Результат GET
constructor TResultGet.Create(Pars: TParsExchg; WhatMT : Integer = DATA_ONLY);
begin
  if (WhatMT <> NO_DATA) then begin
  if (WhatMT = DATA_ONLY) then begin
    INs := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
    Docs := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectDocs));
    Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectChild));
  end else
    Nsi := TkbmMemTable(CreateMemTable(MT_NSI, Pars.Meta, Pars.SectNsi));
    end;
end;

constructor TParsPost.Create(DSign, Cert : string; URL : string = '');
begin
  USign := DSign;
  USert := Cert;
  FullURL := URL;
end;

end.
