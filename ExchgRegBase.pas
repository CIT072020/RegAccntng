unit ExchgRegBase;

interface

uses
  Classes, DB,
  kbmMemTable,
  superobject,
  httpsend,
  SasaINiFile,
  uService;

type
  // параметры дл€ создани€ объекта
  TParsExchg = class
  private
    FMeta : TSasaIniFile;
  public
    MetaName : string;
    SectINs : string;
    SectDocs : string;
    SectChild : string;
    //  од органа регистрации (с/совета)
    Organ : string;

    property Meta : TSasaIniFile read FMeta write FMeta;

  end;

  // параметры дл€ GetDocs
  TParsGet = class
    DateBeg : TDateTime;
    DateEnd : TDateTime;
    Organ   : string;

    TypeDoc : string;
    FullURL : string;

    IndNum  : TStrings;

    constructor Create(DBeg, DEnd : TDateTime); overload;
    constructor Create(URL : string); overload;
    constructor Create(INs : TStrings); overload;
  end;

  // параметры дл€ SetDocs
  TParsSet = class
  end;

  TResultGet = class
  private
    FChild,
    FDocs,
    FINs : TkbmMemTable;
  protected
  public
    property INs   : TkbmMemTable read FINs write FINs;
    property Docs  : TkbmMemTable read FDocs write FDocs;
    property Child : TkbmMemTable read FChild write FChild;

    constructor Create(Pars : TParsExchg);
  end;

  TResultSet = class
  end;

  TRegSrv = class(TObject)
  // путь к сервису
    URL : string;
  end;

  // "черный €щик" обмена с REST-сервисом
  TExchgRegCitizens = class(TInterfacedObject)
  private
    FChild,
    FDocs,
    FIDs : TkbmMemTable;
    FPars : TParsExchg;
    FResGet : TResultGet;
    FResSet : TResultSet;

    function ReadIni : Boolean;
    function StoreINsInMT(Pars : TParsGet) : integer;

  protected
  public
    property ResGet : TResultGet read FResGet write FResGet;
    property ResSet : TResultGet read FResGet write FResGet;


    (* ѕолучить список документов [убыти€]


    *)
    function GetRegDocs(ParsGet : TParsGet) : TResultGet;

    (* «аписать сведени€ о регистрации


    *)
    function SetRegDocs(): TResultSet;


    constructor Create(Pars : TParsExchg);
    destructor Destroy; override;
  published
  end;





var
  BlackBox : TExchgRegCitizens = nil;

implementation

uses
  SysUtils,
  NativeXml;

function NewMemT(sTableName: string; MetaSect: String; AutoCreate: Boolean = True; AutoOpen: Boolean = True): TDataSet;
begin

end;

constructor TParsGet.Create(DBeg, DEnd : TDateTime);
begin
  DateBeg := DBeg;
  DateEnd := DEnd;
  FullURL := '';
end;

constructor TParsGet.Create(URL : string);
begin
  FullURL := URL;
end;

constructor TParsGet.Create(INs : TStrings);
begin
  IndNum := INs;
end;


constructor TResultGet.Create(Pars : TParsExchg);
begin
  INs   := TkbmMemTable(CreateMemTable(MT_INS, Pars.Meta, Pars.SectINs));
  Docs  := TkbmMemTable(CreateMemTable(MT_DOCS, Pars.Meta, Pars.SectINs));
  Child := TkbmMemTable(CreateMemTable(MT_CHILD, Pars.Meta, Pars.SectINs));
end;


function TExchgRegCitizens.ReadIni: Boolean;
begin
  try
    FPars.FMeta := TSasaIniFile.Create(FPars.MetaName);
    Result := True;
  except
    Result := False;
  end;
end;

constructor TExchgRegCitizens.Create(Pars : TParsExchg);
begin
  inherited Create;
  FPars := Pars;
  if (Length(FPars.MetaName) > 0) then
    ReadIni;
end;

destructor TExchgRegCitizens.Destroy;
begin

end;



// установка параметров дл€ GET : получени€ списка документов по территории
//
// Example:
// /v1/movements/sys_organ/:sys_organ/period/:since/:till?first=1&count=1
// :sys_organ - required
// :since - required
// :till - required
// first=[0]
// count=[500]
function SetPars4GetIDs(Pars : TStringList) : string;
var
  s : string;
begin
  s := Format( '/sys_organ/%s/period/%s/%s?first=%s&count=%s',
    [Pars[0], Pars[1], Pars[2], Pars[3], Pars[4]]);
  Result := s;
end;

// установка параметров дл€ GET : получени€ документов по ID
//
// identifier=3140462K000VF6
// name=
// surname=
// patronymic=
// first=
// count=
function SetPars4GetDocs(Pars : TStringList) : string;
var
  s : string;
begin
  s := Format('?identifier=%s&name=%s&surname=%s&patronymic=%s&first=%s&count=%s',
    [ Pars[0], Pars[1], Pars[2], Pars[3], Pars[4], Pars[5] ]);
  Result := s;
end;

function FullPath(Func : Integer; Pars : string) : string;
var
  s : string;
begin
  s := '';
  case Func of
    GET_LIST_ID  : s := RESOURCE_LISTID_PATH;
    GET_LIST_DOC : s := RESOURCE_LISTDOC_PATH;
    POST_DOC     : s := RESOURCE_POSTDOC_PATH;
  end;
  if ( Length(s) > 0) then
    s := RESOURCE_GEN_POINT + RESOURCE_VER + s + Pars;
  Result := s;
end;











function TExchgRegCitizens.StoreINsInMT(Pars : TParsGet) : integer;
var
  i : Integer;
  t : TkbmMemTable;
begin
  Result := Pars.IndNum.Count;
  i := 1;
  while i <= Result do begin



    i := i + 1;
  end;



end;


function MemStream2Str(const MS: TMemoryStream; const FullStream: Boolean = True; const ADefault: string = ''): string;
var
  NeedLen: Integer;
begin
  if Assigned(MS) then
  try
    if (FullStream = True) then
      MS.Position := 0;
    NeedLen := MS.Size - MS.Position;
    SetLength(Result, NeedLen);
    MS.Read(Result[1], NeedLen);
  except
    Result := ADefault;
  end
  else
    Result := ADefault;
end;

// ѕеремещение граждан за период
function GetListID(StrPars: string = ''): ISuperObject;
var
  INsCount : Integer;
  Ret: Boolean;
  sDoc, sErr, sPars: string;
  Docs: ISuperObject;
  HTTP: THTTPSend;
begin
  Result := nil;

  ShowDeb(sPars);

  HTTP := THTTPSend.Create;
  try
    try
      Ret := HTTP.HTTPMethod('GET', sPars);
      if (Ret = True) then begin
        if (HTTP.ResultCode < 200) or (HTTP.ResultCode >= 400) then begin
          sErr := HTTP.Headers.Text;
          raise Exception.Create(sErr);
        end;
        ShowDeb(IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString);
        sDoc := MemStream2Str(HTTP.Document);
        Result := SO(Utf8Decode(sDoc));
      end
      else begin
        sErr := IntToStr(HTTP.sock.LastError) + ' ' + HTTP.sock.LastErrorDesc;
        raise Exception.Create(sErr);
      end;
    except

    end;
  finally
    HTTP.Free;
  end;

end;



function FillIDList(SOArr: ISuperObject; IDs: TkbmMemTable): Integer;
  function CT(s: string): string;
  begin
    Result := s;
  end;

var
  i, SOMax: Integer;
  SO: ISuperObject;
begin
  try
    IDs.EmptyTable;
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      IDs.Append;
      //IDs.FieldByName('PID').AsString := SO.S[CT('pid')];
      IDs.FieldByName('IDENTIF').AsString        := SO.S[CT('IDENTIFIER')];
      IDs.FieldByName('DATEREC').AsDateTime      := sdDateTimeFromString(SO.S[CT('REG_DATE')], false);
      IDs.FieldByName('ORG_WHERE_CODE').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('CODE')];
      IDs.FieldByName('ORG_WHERE_NAME').AsString := SO.O[CT('SYS_ORGAN_WHERE')].S[CT('LEX')];
      IDs.FieldByName('ORG_FROM_CODE').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('CODE')];
      IDs.FieldByName('ORG_FROM_NAME').AsString  := SO.O[CT('SYS_ORGAN_FROM')].S[CT('LEX')];
      IDs.Post;
      i := i + 1;
    end;
  except
  end;
  Result := i;
end;

// ѕеремещение граждан за период
function GetINsFromSrv(ParsGet : TParsGet; MT : TkbmMemTable) : Integer;
var
  Pars : TStringList;
  SOList : ISuperObject;
begin
  Result := 0;
  if (Length(ParsGet.FullURL) = 0) then begin
    Pars := TStringList.Create;
    Pars.Add(ParsGet.Organ);
    Pars.Add(DateToStr(ParsGet.DateBeg));
    Pars.Add(DateToStr(ParsGet.DateEnd));
    Pars.Add('1');
    Pars.Add('800');
    ParsGet.FullURL := FullPath(GET_LIST_ID, SetPars4GetIDs(Pars));
  end;
  SOList := GetListID(ParsGet.FullURL);
  if Assigned(SOList) and (SOList.DataType = stArray) then begin
      Result := FillIDList(SOList, MT);
  end;
end;

function TExchgRegCitizens.GetRegDocs(ParsGet : TParsGet) : TResultGet;
var
  Ret: Boolean;
  nINs : Integer;
  sDoc, sErr, sPars: string;
  Docs: ISuperObject;
  HTTP: THTTPSend;
  Res : TResultGet;
begin
  Res := TResultGet.Create(FPars);

  // Fill MemTable with IDs
  if (Assigned(ParsGet.IndNum)) then
    nINs := StoreINsInMT(ParsGet)
  else
    nINs := GetINsFromSrv(ParsGet, Res.INs);


  Result := Res;
end;

function TExchgRegCitizens.SetRegDocs(): TResultSet;
begin
  Result := TResultSet.Create;
end;

end.
