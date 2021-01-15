program RegCtz;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uDvigMen in 'uDvigMen.pas',
  uService in 'uService.pas',
  ExchgRegBase in 'ExchgRegBase.pas',
  uPars in 'uPars.pas',
  uDTO in 'uDTO.pas',
  uNSI in 'uNSI.pas',
  uAvest in 'uAvest.pas',
  AuthF in 'AuthF.pas' {FormAuth};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormAuth, FormAuth);
  Application.Run;
end.
