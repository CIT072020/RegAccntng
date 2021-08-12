
program AppROC;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  fPIN4Av in 'fPIN4Av.pas' {fPINGet},
  uROCExchg in '..\..\Lais7\OAIS\uROCExchg.pas',
  uROCDTO in '..\..\Lais7\OAIS\uROCDTO.pas',
  uRestService in '..\..\Lais7\OAIS\uRestService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfPINGet, fPINGet);
  Application.Run;
end.
