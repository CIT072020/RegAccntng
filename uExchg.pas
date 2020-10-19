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
  protected
  public
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


function GetListDoc(Pars: TStringList): Boolean;
var
  sErr, sPars: string;
  HTTP: THTTPSend;
begin
  HTTP := THTTPSend.Create;
  sPars := FullPath(GET_LIST_DOC, SetPars4GetList(Pars));
  try
    try
      Result := HTTP.HTTPMethod('GET', sPars);
      if Result then begin
        if (HTTP.ResultCode < 200) or (HTTP.ResultCode >= 400) then begin
          Result := False;
          sErr := HTTP.Headers.Text;
        end;

      end
      else begin
        sPars := IntToStr(HTTP.sock.LastError) + ' ' + HTTP.sock.LastErrorDesc;
      end;
    except
    end;
  finally
    HTTP.Free;
  end;

end;


end.

