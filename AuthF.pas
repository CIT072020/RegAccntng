unit AuthF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, DBCtrlsEh, IniFiles;

type
  TFormAuth = class(TForm)
    Parol: TDBEditEh;
    Label2: TLabel;
    Vxod: TBitBtn;
    Vixod: TBitBtn;
    ChB: TCheckBox;
    procedure VxodClick(Sender: TObject);
    procedure VixodClick(Sender: TObject);
    procedure ParolChange(Sender: TObject);
    procedure ChBClick(Sender: TObject);

    procedure InitPars(Pin : string);
    procedure SetResult(var UP : string);
    procedure ParolKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  FormAuth: TFormAuth;

implementation

{$R *.dfm}

procedure TFormAuth.InitPars(Pin : string);
begin
  Parol.Text := Pin;
end;

procedure TFormAuth.SetResult(var UP : string);
begin
  UP := Parol.Text;
end;

procedure TFormAuth.VxodClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormAuth.VixodClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormAuth.ParolChange(Sender: TObject);
begin
if ChB.Checked then Parol.PasswordChar:=#0 else Parol.PasswordChar:='*';
end;

procedure TFormAuth.ChBClick(Sender: TObject);
begin
if ChB.Checked then Parol.PasswordChar:=#0 else Parol.PasswordChar:='*';
Parol.SetFocus;
end;

procedure TFormAuth.ParolKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = VK_RETURN) then
   Vxod.Click;
end;


end.
