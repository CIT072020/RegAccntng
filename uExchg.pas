unit uExchg;

interface

uses
  Windows, SysUtils, Math, Classes, Forms, Db, NativeXML,
  {$IFDEF SYNA} httpsend,  {$ENDIF}
  superobject, supertypes, superdate, kbmMemTable, DbFunc, FuncPr, SasaINiFile;


type
  TConnPars = class(TObject)
  end;

type
  TExchReg = class(THTTPSend)
  private
    FIDs : TkbmMemTable;
  protected
  public
    property IDs : TkbmMemTable read FIDs write FIDs;
    //constructor Create; override;
    constructor Create(Pars : TConnPars);
    destructor Destroy; override;


  published
  end;

const
  GET_LIST_DOC = 1;
  GET_DOC      = 2;
  POST_DOC     = 3;

  DEF_HOST = 'https://a.todes.by';
  DEF_PORT = '13555';

  RESOURCE_GEN_POINT = '/village-council-service';
  RESOURCE_VER       = '/v1';

  RESOURCE_LISTDOC_PATH = '/movements';
  RESOURCE_GETDOC_PATH  = '/data';
  RESOURCE_POSTDOC_PATH = '/data/save';


function SetPars4GetList(Pars : TStringList) : string;
function GetListDoc(Pars: TStringList): ISuperObject;

implementation

constructor TExchReg.Create(Pars : TConnPars);
begin
  inherited Create;

end;

destructor TExchReg.Destroy;
begin
  inherited Destroy;

end;

// установка параметров для GET : получения списка документов по территории
//
// Example:
// /v1/movements/sys_organ/:sys_organ/period/:since/:till?first=1&count=1
// :sys_organ
// :since
// :till
// first=
// count=
function SetPars4GetList(Pars : TStringList) : string;
var
  s : string;
begin
  s :=
    '/sys_organ/' + Pars[0] +
    '/period/'    + Pars[1] +
    '/'           + Pars[2] +
    '?first='     + Pars[3] +
    '&count='     + Pars[4];
  Result := s;
end;


// установка параметров для GET : получения документа по ID
//
// identifier=3140462K000VF6
// name=
// surname=
// patronymic=
// first=
// count=
procedure SetPars4GetDoc;

begin

end;

// установка параметров для POST : сохранение документа (форма)
//
// Example:
// https://a.todes.by:13555/village-council-service/v1/data/save
procedure SetPars4SaveDoc;

begin

end;


function FullPath(Func : Integer; Pars : string) : string;
var
  s : string;
begin
  s := '';
  case Func of
    GET_LIST_DOC  : s := RESOURCE_LISTDOC_PATH;
    GET_DOC       : s := RESOURCE_GETDOC_PATH;
    POST_DOC      : s := RESOURCE_POSTDOC_PATH;
  end;

  if ( Length(s) > 0) then
    s := DEF_HOST + '' + DEF_PORT +
    RESOURCE_GEN_POINT +
    RESOURCE_VER + s + Pars;

  Result := s;
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

function GetListDoc(Pars: TStringList): ISuperObject;
var
  Ret : Boolean;
  sDoc,
  sErr, sPars: string;
  Docs : ISuperObject;

  HTTP: THTTPSend;
begin
  Result := nil;
  HTTP := THTTPSend.Create;
  //sPars := FullPath(GET_LIST_DOC, SetPars4GetList(Pars));
  sPars := 'http://jsonplaceholder.typicode.com/users';
  try
    try
      Ret := HTTP.HTTPMethod('GET', sPars);
      if (Ret = True) then begin
        if (HTTP.ResultCode < 200) or (HTTP.ResultCode >= 400) then begin
          sErr := HTTP.Headers.Text;
          raise Exception.Create(sErr);
        end;
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

function ParseSOFromListDoc(SO : ISuperObject) : Integer;
begin

end;

{
function MTList(SOArr : ISuperObject) : Integer;
var
  SOMax : Integer;
  SO    : ISuperObject;
begin
  try

        //ClearMemTable(tbMovements);
        for i:=0 to SOArr.AsArray.Length-1 do begin
          SO := SOArr.AsArray.O[i];
          IDs.Append;
          tbMovements.FieldByName('PID').AsString:=obj.S[CT('pid')];
          tbMovements.FieldByName('IDENTIF').AsString:=obj.S[CT('identif')];
          tbMovements.FieldByName('DATEREC').AsDateTime:=sdDateTimeFromString(obj.S[CT('dateRec')], false);
          tbMovements.FieldByName('ORG_WHERE_TYPE').AsString:=obj.O[CT('sysOrganWhere')].O[CT('klUniPK')].S[CT('type')];
          tbMovements.FieldByName('ORG_WHERE_CODE').AsString:=obj.O[CT('sysOrganWhere')].O[CT('klUniPK')].S[CT('code')];
          tbMovements.FieldByName('ORG_WHERE_NAME').AsString:=obj.O[CT('sysOrganWhere')].S[CT('lex1')];
          tbMovements.FieldByName('ORG_FROM_TYPE').AsString:=obj.O[CT('sysOrganFrom')].O[CT('klUniPK')].S[CT('type')];
          tbMovements.FieldByName('ORG_FROM_CODE').AsString:=obj.O[CT('sysOrganFrom')].O[CT('klUniPK')].S[CT('code')];
          tbMovements.FieldByName('ORG_FROM_NAME').AsString:=obj.O[CT('sysOrganFrom')].S[CT('lex1')];
          tbMovements.Post;
        end;


    except
      end;

end;
}

end.

