unit ExchgRegBase;

interface

type
  // параметры для создания объекта
  TParsExchg = class
  // путь к сервису
    URL : string;
  end;

  // параметры для GetDocs
  TParsGet = class
    DBeg : TDateTime;
    DEnd : TDateTime;
  end;

  // параметры для SetDocs
  TParsSet = class
  end;

  TResultGet = class
  end;

  TResultSet = class
  end;

  { Обмен данными с базой регистрации}
  TExchRegCitizens = class(TObject)
  private
  protected
  public
  
    (* Получить список документов [убытия]


    *)
    function GetRegDocs(): TResultGet;

    (* Записать сведения о регистрации


    *)
    function SetRegDocs(): TResultSet;
    constructor Create;
    destructor Destroy;
  published
  end;



implementation

constructor TExchRegCitizens.Create;
begin

end;

destructor TExchRegCitizens.Destroy;
begin

end;


function TExchRegCitizens.GetRegDocs(): TResultGet;
begin
  Result := TResultGet.Create;
end;

function TExchRegCitizens.SetRegDocs(): TResultSet;
begin
  Result := TResultSet.Create;
end;

end.
