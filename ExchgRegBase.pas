unit ExchgRegBase;

interface

type
  // ��������� ��� �������� �������
  TParsExchg = class
  // ���� � �������
    URL : string;
  end;

  // ��������� ��� GetDocs
  TParsGet = class
    DBeg : TDateTime;
    DEnd : TDateTime;
  end;

  // ��������� ��� SetDocs
  TParsSet = class
  end;

  TResultGet = class
  end;

  TResultSet = class
  end;

  { ����� ������� � ����� �����������}
  TExchRegCitizens = class(TObject)
  private
  protected
  public
  
    (* �������� ������ ���������� [������]


    *)
    function GetRegDocs(): TResultGet;

    (* �������� �������� � �����������


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
