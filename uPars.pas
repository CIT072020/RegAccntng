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

    constructor Create(NType : Integer; Conn : TAdsConnection);
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

  // Результат для GET/POST
  TResultHTTP = class
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
    property ResMsg  : string read FMsg write FMsg;

    constructor Create; overload;
    constructor Create(Meta : TSasaIniFile; WhatMT: Integer = DATA_ONLY); overload;
  end;

implementation

uses
  SysUtils,
  NativeXml;

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


// Результат GET/POST
constructor TResultHTTP.Create;
begin
  inherited Create;
end;

constructor TResultHTTP.Create(Meta : TSasaIniFile; WhatMT: Integer = DATA_ONLY);
begin
  if (WhatMT <> NO_DATA) then begin
    if (WhatMT = DATA_ONLY) then begin
    //INs := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
    //Docs := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectDocs));
    //Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectChild));
      INs   := TkbmMemTable(CreateMemTable(MT_INS, Meta, SCT_TBL_INS));
      Docs  := TkbmMemTable(CreateMemTable(MT_DOCS, Meta, SCT_TBL_DOC));
      Child := TkbmMemTable(CreateMemTable(MT_CHILD, Meta, SCT_TBL_CLD));
    end
    else
    //Nsi := TkbmMemTable(CreateMemTable(MT_NSI, Pars.Meta, Pars.SectNsi));
      Nsi := TkbmMemTable(CreateMemTable(MT_NSI, Meta, SCT_TBL_NSI));
  end;
end;

constructor TParsPost.Create(DSign, Cert : string; URL : string = '');
begin
  USign := DSign;
  USert := Cert;
  FullURL := URL;
end;

end.
