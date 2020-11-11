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
  // "черный ящик" обмена с REST-сервисом
  TExchReg = class(THTTPSend)
  private
    FIDs : TkbmMemTable;
  protected
  public
    Meta : TSasaIniFile;
    property IDs : TkbmMemTable read FIDs write FIDs;

    constructor Create(Pars : TConnPars);
    destructor Destroy; override;
  published
  end;

const
  GET_LIST_ID  = 1;
  GET_LIST_DOC = 2;
  POST_DOC     = 3;

  DEF_HOST = 'https://a.todes.by';
  DEF_PORT = '13555';

  RESOURCE_GEN_POINT = '/village-council-service/api';
  RESOURCE_VER       = '/v1';

  RESOURCE_LISTID_PATH = '/movements';
  RESOURCE_LISTDOC_PATH  = '/data';
  RESOURCE_POSTDOC_PATH = '/data/save';


function SetPars4GetIDs(Pars : TStringList) : string;
function GetListID(Pars: TStringList; StrPars : string = ''): ISuperObject;

function GetListDOC(Pars: TStringList): ISuperObject;
function FillIDList(SOArr: ISuperObject; IDs: TkbmMemTable): Integer;
function FillDocList(SOArr: ISuperObject; IDs, Chs: TkbmMemTable): Integer;

implementation

uses
  uService;

function UnixStrToDateTime(sDate:String):TDateTime;
begin
   Result := 0;
   if (sDate <> 'null') then
     Result := JavaToDelphiDateTime(StrToInt64(sDate));
end;

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


// установка параметров для GET : получения документов по ID
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
    GET_LIST_ID  : s := RESOURCE_LISTID_PATH;
    GET_LIST_DOC : s := RESOURCE_LISTDOC_PATH;
    POST_DOC     : s := RESOURCE_POSTDOC_PATH;
  end;
  if ( Length(s) > 0) then
    s := DEF_HOST + ':' + DEF_PORT +
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

// Перемещение граждан за период
function GetListID(Pars: TStringList; StrPars: string = ''): ISuperObject;
var
  Ret: Boolean;
  sDoc, sErr, sPars: string;
  Docs: ISuperObject;
  HTTP: THTTPSend;
begin
  Result := nil;
  HTTP := THTTPSend.Create;

  if (Length(StrPars) = 0) then begin
  //sPars := 'http://jsonplaceholder.typicode.com/users';
  //sPars := 'https://my-json-server.typicode.com/CIT072020/TestData4RegAcc/posts';
  //sPars := 'https://my-json-server.typicode.com/CIT072020/TestData4RegAcc/Departs';
    sPars := FullPath(GET_LIST_ID, SetPars4GetIDs(Pars));
  end
  else begin
    sPars := StrPars;
  end;

  ShowDeb(sPars);

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

function ParseSOFromListDoc(SO : ISuperObject; MTableIDs : TkbmMemTable) : Integer;
begin

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

// Плучить документы для текущего в списке ID
function GetListDOC(Pars: TStringList): ISuperObject;
var
  Ret : Boolean;
  sDoc,
  sErr, sPars: string;
  ws : WideString;
  Docs : ISuperObject;
  HTTP: THTTPSend;
begin
  Result := nil;
  HTTP := THTTPSend.Create;
  sPars := FullPath(GET_LIST_DOC, SetPars4GetDocs(Pars));
  ShowDeb(sPars);

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
        //Result := SO(Utf8Decode(sDoc));
        ws   := Utf8Decode(sDoc);
        Result := SO(ws);
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

function FillDocList(SOArr: ISuperObject; IDs, Chs: TkbmMemTable): Integer;

  function CT(s: string): string;
  begin
    Result := s;
  end;

  procedure FillChild(SOA: ISuperObject; Chs: TkbmMemTable; MasterI: integer);
  var
    j: Integer;
    SO: ISuperObject;
  begin
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
  end;

var
  i, NCh: Integer;
  SOChild, SO: ISuperObject;
begin
  try
    IDs.EmptyTable;
    i := 0;
    while (i <= SOArr.AsArray.Length - 1) do begin
      SO := SOArr.AsArray.O[i];
      IDs.Append;
      IDs.FieldByName('PID').AsString := SO.S[CT('pid')];
      IDs.FieldByName('IDENTIF').AsString := SO.S[CT('identif')];
      IDs.FieldByName('sysDocType').AsString := SO.O[CT('sysDocType')].O[CT('klUniPK')].s[CT('type')];
      IDs.FieldByName('sysDocName').AsString := SO.O[CT('sysDocType')].s[CT('lex1')];
      IDs.FieldByName('FAMILIA').AsString := SO.S[CT('surname')];
      IDs.FieldByName('NAME').AsString := SO.S[CT('name')];

      try
        SOChild := SO.O[CT('form19_20')].O[CT('infants')];
        NCh := SOChild.AsArray.Length;
      except
        NCh := 0;
      end;

      if (Assigned(SOChild)) and (NCh > 0) then begin
        FillChild(SOChild, Chs, i);
      end;
      IDs.FieldByName('NCHILD').AsInteger := NCh;

      IDs.Post;
      SOChild := SO.O[CT('infants')];
      if (Assigned(SOChild)) then begin
        FillChild(SOChild, Chs, i);
      end;
      i := i + 1;
    end;
  except
  end;
  Result := i;
end;


end.

