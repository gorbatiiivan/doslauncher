program doslauncher;

{$R *.dres}

uses
  WinApi.Windows,
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  utils in 'utils.pas',
  mf in 'mf.pas';

{$R *.res}
{$SETPEFLAGS IMAGE_FILE_RELOCS_STRIPPED}

var
  ExtendedStyle: Longint;
begin
  SetLastError(NO_ERROR);
  CreateSemaphore(nil,0,1,PWideChar('game_launcher_for_eXo_collections'));
  if GetLastError = ERROR_ALREADY_EXISTS then Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Blue');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
