program doslauncher;

{$R *.dres}

uses
  WinApi.Windows,
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  ExtendedStyle: Longint;
begin
  SetLastError(NO_ERROR);
  CreateSemaphore(nil,0,1,PWideChar('MS-DOS_game_launcher_for_Exo_Collections'));
  if GetLastError = ERROR_ALREADY_EXISTS then Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
