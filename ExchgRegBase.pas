unit ExchgRegBase;

interface

type
  // ��������� ��� GetDocs
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

  { ����� ������� � ����� �����������}
  TExchRegBase = class(TObject)
  private
  protected
  public
    (* �������� ������ ���������� [������]


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
