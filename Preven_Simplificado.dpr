program Preven_Simplificado;

{PREVEN - Sistema de Preven��o ao Dort/Ler}

uses
  Forms,
  Windows,
  PRV130P1T in 'PRV130P1T.pas' {FRMverificaratividadesusuario},
  PRV130P2T in 'PRV130P2T.pas' {FRMmostrarmensagens},
  PRV130P3T in 'PRV130P3T.pas' {FRMtelaapresentacao},
  PRV130P1U in 'PRV130P1U.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.Title := 'Preven';
  Application.HelpFile := 'D:\Embarcadero Delphi\Preven - Simplificado\Help\HELP.HLP';
  Application.CreateForm(TFRMverificaratividadesusuario, FRMverificaratividadesusuario);
  Application.CreateForm(TFRMmostrarmensagens, FRMmostrarmensagens);
  Application.CreateForm(TFRMtelaapresentacao, FRMtelaapresentacao);
  Application.Run;
end.
