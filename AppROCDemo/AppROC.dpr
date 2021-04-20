
program AppROC;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  fPIN4Av in 'fPIN4Av.pas' {fPINGet},
  uROCService in '..\..\Lais7\RegUch\uROCService.pas',
  uROCNSI in '..\..\Lais7\RegUch\uROCNSI.pas',
  uROCExchg in '..\..\Lais7\RegUch\uROCExchg.pas',
  uROCDTO in '..\..\Lais7\RegUch\uROCDTO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfPINGet, fPINGet);
  Application.Run;
end.
