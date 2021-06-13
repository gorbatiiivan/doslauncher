unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Masks, ShellAPI, IniFiles;

type
  TMainForm = class(TForm)
    MainList: TListBox;
    ListMenu: TPopupMenu;
    Run1: TMenuItem;
    N1: TMenuItem;
    Install1: TMenuItem;
    AlternateLauncher: TMenuItem;
    N2: TMenuItem;
    Refresh1: TMenuItem;
    N3: TMenuItem;
    CheckforUpdate1: TMenuItem;
    N4: TMenuItem;
    Options1: TMenuItem;
    DefaultRun1: TMenuItem;
    Default1: TMenuItem;
    AlternativeLauncher1: TMenuItem;
    Open1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainListDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MainListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Install1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure AlternateLauncherClick(Sender: TObject);
    procedure CheckforUpdate1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormPaint(Sender: TObject);
    procedure ListMenuPopup(Sender: TObject);
    procedure Default1Click(Sender: TObject);
    procedure AlternativeLauncher1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
    FConfig: TMemIniFile;
    function GetFConfig: TMemIniFile;
    procedure RegIni(Write: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  FileList: TStringList;
  FilePath: TStringList;

implementation

{$R *.dfm}

//functions@procedure

function LoadResourceFontByID( ResourceID : Integer; ResType: PChar ) : Boolean;
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
begin
  ResStream := TResourceStream.CreateFromID(hInstance, ResourceID, ResType);
  try
    Result := (AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount) <> 0);
  finally
    ResStream.Free;
  end;
end;

function FindString(List: TStringList; s: string): Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < List.Count) and (List[i] <> s) do
    inc(i);
  Result := i;
end;

procedure FindFilePattern(root: String; pattern: String);
var
  SR: TSearchRec;
begin
  root := IncludeTrailingPathDelimiter(root);
  if FindFirst(root + '*.*', faAnyFile, SR) = 0 then
  try
    repeat
      Application.ProcessMessages;
      if (SR.Attr and faDirectory) <> 0 then
      begin
        if (SR.Name <> '.') and (Sr.Name <> '..') then
          FindFilePattern(root + SR.Name, pattern);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
         begin
         if (SR.Name <> 'install.bat') and (SR.Name <> 'Alternate Launcher.bat') then
          begin
            FileList.Add(ChangeFileExt(SR.Name,''));
            FilePath.Add(Root + SR.Name);
            MainForm.MainList.Items.Add(ChangeFileExt(SR.Name,''));
          end;
         end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

function RunApplication(const AExecutableFile, AParameters: string;
  const AShowOption: Integer = SW_SHOWNORMAL): Integer;
var
  _SEInfo: TShellExecuteInfo;
begin
  Result := 0;
  if not FileExists(AExecutableFile) then
    Exit;

  FillChar(_SEInfo, SizeOf(_SEInfo), 0);
  _SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  _SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  // _SEInfo.Wnd := Application.Handle;
  _SEInfo.lpFile := PChar(AExecutableFile);
  _SEInfo.lpParameters := PChar(AParameters);
  _SEInfo.nShow := AShowOption;
  if ShellExecuteEx(@_SEInfo) then
  begin
    WaitForInputIdle(_SEInfo.hProcess, 3000);
    Result := GetProcessID(_SEInfo.hProcess);
  end;
end;

function GetDosDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'eXoDOS'+s+'!dos';
end;

procedure AddGamesToList;
begin
with MainForm do
 begin
  if MainForm.Caption <> 'Please wait...' then
   begin
    MainForm.Caption := 'Please wait...';
    FileList.Clear;
    FilePath.Clear;
    MainList.Items.Clear;
    FindFilePattern(GetDosDir, '*.bat');
    MainForm.Caption := 'MS-DOS Games: ' + IntToStr(MainList.Items.Count);
    if MainList.Items.Count <> -1 then MainList.ItemIndex := 0;
   end;
 end;
end;

//IniFile

function TMainForm.GetFConfig: TMemIniFile;
begin
  if FConfig = nil then
  FConfig := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'config.ini',TEncoding.UTF8);
  Result := FConfig;
end;

procedure TMainForm.RegIni(Write: Boolean);
begin
if Write = true then
 begin
  FConfig.WriteInteger('General','Top',Top);
  FConfig.WriteInteger('General','Left',Left);
  FConfig.WriteInteger('General','Width',Width);
  FConfig.WriteInteger('General','Height',Height);
  FConfig.UpdateFile;
 end else
 begin
  Top := FConfig.ReadInteger('General','Top',Top);
  Left := FConfig.ReadInteger('General','Left',Left);
  Width := FConfig.ReadInteger('General','Width',Width);
  Height := FConfig.ReadInteger('General','Height',Height);
 end;
end;

//TMainForm

procedure TMainForm.FormCreate(Sender: TObject);
begin
if not FileExists(ExtractFilePath(ParamStr(0))+'config.ini') then
Position := poDesktopCenter else Position := poDefaultPosOnly;

GetFConfig;
RegIni(False);

if LoadResourceFontByID(2, 'MYFONT1') then
 begin
   MainForm.ParentFont := False;
   MainForm.Font.Size := 8;
   MainForm.Font.Name := 'Modern DOS 8x8';
 end;
if LoadResourceFontByID(1, 'MYFONT') then
 begin
   MainList.ParentFont := False;
   MainList.Font.Size := 12;
   MainList.Font.Name := 'Modern DOS 8x14';
   MainList.ParentColor := True;
   MainList.Color := $00AA0000;
   MainList.Font.Color := $00FFFF55;
 end;

FileList := TStringList.Create;
FilePath := TStringList.Create;
AddGamesToList;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
RegIni(True);
FConfig.Free;
FileList.Free;
FilePath.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_F5 then AddGamesToList;
if Key = VK_RETURN then MainListDblClick(Sender);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
Color := $00AA0000;
Canvas.Pen.Color := $00AA0000;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 1;
Canvas.Rectangle (0, 0, ClientWidth, ClientHeight);
Canvas.Pen.Color := $00FFFF55;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 1;
Canvas.Rectangle (4, 4, ClientWidth -4, ClientHeight -4);
Canvas.Pen.Color := $00FFFF55;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 1;
Canvas.Rectangle (6, 6, ClientWidth -6, ClientHeight -6);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
Repaint;
MainList.SetBounds(10,10,ClientWidth -20, ClientHeight -20);
end;

//TListMenu

procedure TMainForm.ListMenuPopup(Sender: TObject);
begin
if FConfig.ReadInteger('General','Run',0) = 0 then
Default1.Checked := True
else
if FConfig.ReadInteger('General','Run',0) = 1 then
AlternativeLauncher1.Checked := True;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
if MainList.ItemIndex <> -1 then
 begin
  SetCurrentDir(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])]));
  RunApplication(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])], '');
 end;
end;

procedure TMainForm.Install1Click(Sender: TObject);
begin
if MainList.ItemIndex <> -1 then
 begin
   SetCurrentDir(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])]));
   RunApplication(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])]) + 'install.bat', '');
 end;
end;

procedure TMainForm.AlternateLauncherClick(Sender: TObject);
var
  s: String;
begin
if MainList.ItemIndex <> -1 then
 begin
  s := IncludeTrailingPathDelimiter(s);
  if FileExists(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])])+s+'Extras'+s+'Alternate Launcher.bat') then
   begin
    SetCurrentDir(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])])+s+'Extras');
    RunApplication(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])])+s+'Extras'+s+'Alternate Launcher.bat', '');
   end else
  begin
    SetCurrentDir(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])]));
    RunApplication(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])], '');
  end;
 end;
end;

procedure TMainForm.Refresh1Click(Sender: TObject);
begin
AddGamesToList;
end;

procedure TMainForm.CheckforUpdate1Click(Sender: TObject);
var
  s: String;
begin
if MainList.ItemIndex <> -1 then
 begin
   s := IncludeTrailingPathDelimiter(s);
   SetCurrentDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'Update');
   RunApplication(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'Update'+s+'update.bat', '');
 end;
end;

procedure TMainForm.Default1Click(Sender: TObject);
begin
FConfig.WriteInteger('General','Run',0);
FConfig.UpdateFile;
end;

procedure TMainForm.AlternativeLauncher1Click(Sender: TObject);
begin
FConfig.WriteInteger('General','Run',1);
FConfig.UpdateFile;
end;

//TMainList

procedure TMainForm.MainListDblClick(Sender: TObject);
begin
if MainList.ItemIndex <> -1 then
 begin
  if FConfig.ReadInteger('General','Run',0) = 0 then
   begin
    SetCurrentDir(ExtractFilePath(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])]));
    RunApplication(FilePath[FindString(FileList,MainList.Items[MainList.ItemIndex])], '');
   end else
  if FConfig.ReadInteger('General','Run',0) = 1 then
    AlternateLauncherClick(Sender);
 end;
end;

procedure TMainForm.MainListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
with MainList do ItemIndex := ItemAtPos(Point(X, Y), True);

if Button = mbRight then
if MainList.ItemIndex <> -1 then
 begin
  Run1.Enabled := True;
  Open1.Enabled := True;
  Install1.Enabled := True;
  Alternatelauncher.Enabled := True;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end else
 begin
  Run1.Enabled := False;
  Open1.Enabled := False;
  Install1.Enabled := False;
  Alternatelauncher.Enabled := False;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end;
end;

procedure TMainForm.MainListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with (Control as TListBox).Canvas do
  begin
    if odSelected in State then
    begin
      Brush.Color := $00AAAA00;
      Font.Color := clBlack;
    end;

    FillRect(Rect);
    TextOut(Rect.Left+4, Rect.Top+4, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := MainList.Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

end.
