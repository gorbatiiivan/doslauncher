program µlauncher;



uses
  WinApi.Windows,
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  Utils in 'Utils.pas',
  Xml.VerySimple in 'Xml.VerySimple.pas',
  mf in 'mf.pas',
  FullScreenImage in 'FullScreenImage.pas' {FullScreenForm};

//mf in 'mf.pas';

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
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TFullScreenForm, FullScreenForm);
  Application.Run;
end.
