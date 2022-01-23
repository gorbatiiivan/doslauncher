program µlauncher;

{$R *.dres}

uses
  WinApi.Windows,
  Vcl.Forms,
  Vcl.Styles,
  Main in 'Main.pas' {MainForm},
  ScreenImageUnit in 'ScreenImageUnit.pas' {ScreenImageForm},
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
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TScreenImageForm, ScreenImageForm);
  Application.Run;
end.
