program Differential_Equations;

uses
  Vcl.Forms,
  Diff_Equations in 'Diff_Equations.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
