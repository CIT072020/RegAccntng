unit fmProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TFormProgress = class(TForm)
    ProgressBar: TProgressBar;
    lb: TLabel;
    lb2: TLabel;
    pb2: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProgress: TFormProgress;
  SplashPr1, SplashPr2 : TProgressBar;
  SplashLb1, SplashLb2 : TLabel;

  procedure CreateProgress(Caption, Text : String; nMax : Integer;  nLeft:Integer=0; nTop:Integer=0);
  procedure InitProgress(nMax : Integer; Text : String);
  procedure ChangeProgress(Position : Integer; Text : String);
  procedure ChangeProgress2(Position : Integer; Text : String);overload;
  procedure ChangeProgress2(Position : Integer);overload;
  procedure CloseProgress;

  procedure ChangeProgress2Text(Position : Integer; Text : String);
  procedure ChangeProgress2Pos(Position : Integer);

  procedure SetSpalshProgress(lb1,lb2 : TLabel; pr1, pr2 : TProgressBar);

implementation

{$R *.DFM}

procedure SetSpalshProgress(lb1,lb2 : TLabel; pr1,pr2 : TProgressBar);
begin
  if (lb1<>nil) and (pr1<>nil) then begin
    SplashLb1   := lb1;
    SplashLb2   := lb2;
    SplashPr1   := pr1;
    SplashPr2   := pr2;
  end else begin
    SplashLb1   := nil;
    SplashLb2   := nil;
    SplashPr1   := nil;
    SplashPr2   := nil;
  end;
end;

procedure CreateProgress(Caption, Text : String; nMax : Integer; nLeft:Integer; nTop:Integer);
begin
  if SplashLb1 = nil then begin
    FormProgress := TFormProgress.Create(nil);
    if (nLeft=0) and (nTop=0) then begin
      FormProgress.Position:=poScreenCenter;
    end else begin
      FormProgress.Position:=poDefaultSizeOnly;
      FormProgress.Left:=nLeft;
      FormProgress.Top:=nTop;
    end;
    FormProgress.Caption := Caption;
    FormProgress.lb.Caption := Text;
    FormProgress.ProgressBar.Max := nMax;
    FormProgress.ProgressBar.Position:=0;
    FormProgress.Show;
  end else begin
    SplashLb1.Caption := Text;
    SplashPr1.Max := nMax;
    SplashPr1.Position:=0;
    Application.ProcessMessages;
  end;
end;

procedure InitProgress(nMax : Integer; Text : String);
begin
  if SplashLb1 = nil then begin
    if Length(Text)>0 then begin
      FormProgress.lb.Caption := Text;
    end;
    FormProgress.ProgressBar.Position:=0;
    FormProgress.ProgressBar.Max:=nMax;
    Application.ProcessMessages;
  end else begin
    if Length(Text)>0 then begin
      SplashLb1.Caption := Text;
    end;
    SplashPr1.Position:=0;
    SplashPr1.Max:=nMax;
    Application.ProcessMessages;
  end;
end;

procedure ChangeProgress(Position : Integer; Text : String);
begin
  if SplashLb1 = nil then begin
    if Length(Text)>0 then begin
      FormProgress.lb.Caption := Text;
    end;
    if Position = -1 then begin
      Position := 0;
      FormProgress.ProgressBar.Visible := false;
    end else if Position <= 0 then begin
      Position := Abs(Position);
      FormProgress.ProgressBar.Visible := true;
    end;
    FormProgress.ProgressBar.Position := Position;
    Application.ProcessMessages;
  end else begin
    if Length(Text)>0 then begin
      SplashLb1.Caption := Text;
    end;
    SplashPr1.Position:=Position;
    Application.ProcessMessages;
  end;
end;

procedure ChangeProgress2(Position : Integer; Text : String);
begin
  if SplashLb1 = nil then begin
    FormProgress.lb2.Caption := Text;
    if Position = -1 then begin
      Position := 0;
      FormProgress.pb2.Visible := false;
    end else if Position <= 0 then begin
      Position := Abs(Position);
      FormProgress.pb2.Visible := true;
    end;
    FormProgress.pb2.Position := Position
  end else begin
    SplashLb2.Caption := Text;
    if Position = -1 then begin
      SplashPr2.Visible:=false;
      SplashPr2.Position:=0;
    end else if Position = 0 then begin
      SplashPr2.Visible:=true;
      SplashPr2.Position:=0;
    end else begin
      SplashPr2.Position:=Position;
    end;
  end;
  Application.ProcessMessages;
end;

procedure ChangeProgress2(Position : Integer);
begin
  FormProgress.pb2.Position:=Position;
  Application.ProcessMessages;
end;

procedure ChangeProgress2Text(Position : Integer; Text : String);
begin
  ChangeProgress2(Position, Text);
end;

procedure ChangeProgress2Pos(Position : Integer);
begin
  ChangeProgress2(Position);
end;

procedure CloseProgress;
begin
  if SplashLb1 = nil then begin
    FormProgress.Free;
  end else begin
    SplashLb1.Visible := false;
    SplashLb2.Visible := false;
  end;
end;

initialization
  FormProgress := nil;
  SplashPr1   := nil;
  SplashPr2   := nil;
  SplashLb1   := nil;
  SplashLb2   := nil;
end.



