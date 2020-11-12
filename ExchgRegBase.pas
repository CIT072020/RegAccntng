unit ExchgRegBase;

interface

type
  // параметры для GetDocs
  TParsGet = class
    DBeg: TDateTime;
    DEnd: TDateTime;
  end;

  TParsSet = class
  end;

  TResultGet = class
  end;

  TResultSet = class
  end;

  { Обмен данными с базой регистрации}
  TExchRegBase = class(TObject)
  private
  protected
  public
    (* Получить список документов [убытия]


    *)
    function GetRegDocs(): TResultGet;
    function SetRegDocs(): TResultSet;
    constructor Create;
    destructor Destroy;
  published
  end;



implementation

constructor TExchRegBase.Create;
begin

end;

destructor TExchRegBase.Destroy;
begin

end;


function TExchRegBase.GetRegDocs(): TResultGet;
begin
  Result := TResultGet.Create;
end;

function TExchRegBase.SetRegDocs(): TResultSet;
begin
  Result := TResultSet.Create;
end;

end.
