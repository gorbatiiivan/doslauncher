unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  IniFiles, Vcl.ComCtrls, IOUtils, Types, Vcl.ExtCtrls;

const
  TIMER1 = 1;

type
  TMainForm = class(TForm)
    ListMenu: TPopupMenu;
    N1: TMenuItem;
    Install1: TMenuItem;
    N2: TMenuItem;
    Refresh1: TMenuItem;
    N3: TMenuItem;
    CheckforUpdate1: TMenuItem;
    Open1: TMenuItem;
    Extras1: TMenuItem;
    FindEdit: TEdit;
    cmdlabel: TLabel;
    Manual1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Options1: TMenuItem;
    N6: TMenuItem;
    SystemTray1: TMenuItem;
    none1: TMenuItem;
    Minimize1: TMenuItem;
    Close1: TMenuItem;
    TrayIcon: TTrayIcon;
    TrayMenu: TPopupMenu;
    Show1: TMenuItem;
    N7: TMenuItem;
    Exit1: TMenuItem;
    MainPanel: TPanel;
    MainSplitter: TSplitter;
    PageControl: TPageControl;
    eXoDOSSheet: TTabSheet;
    DosMainList: TListBox;
    eXoWin3xSheet: TTabSheet;
    Win3xMainList: TListBox;
    eXoScummVMSheet: TTabSheet;
    ScummVMMainList: TListBox;
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    ImageBox: TImage;
    TabSheet2: TTabSheet;
    VideoBox: TPanel;
    Launcherstate1: TMenuItem;
    Simple1: TMenuItem;
    Extended1: TMenuItem;
    N8: TMenuItem;
    PlaybackTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DosMainListDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DosMainListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Install1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure CheckforUpdate1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DosMainListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormPaint(Sender: TObject);
    procedure ListMenuPopup(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure DosMainListClick(Sender: TObject);
    procedure Win3xMainListDblClick(Sender: TObject);
    procedure ScummVMMainListDblClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FindEditChange(Sender: TObject);
    procedure FindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FindEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Manual1Click(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure none1Click(Sender: TObject);
    procedure Minimize1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Simple1Click(Sender: TObject);
    procedure PlaybackTimerTimer(Sender: TObject);
  private
    { Private declarations }

    function GetFConfig: TMemIniFile;
    procedure RegIni(Write: Boolean; FirstRun: Boolean);
    procedure OnMinimize(Sender: TObject);
    procedure OnRestore(Sender: TObject);
    procedure ExtrasMenuClick(Sender: TObject);
    procedure PlayVideoOnClick;
    procedure WMSize(var Msg: TMessage); message WM_SIZE; //for mfplayer
  public
    { Public declarations }
    FConfig: TMemIniFile;
  end;

var
  MainForm: TMainForm;
  OnTray: Integer;
  AClose: Boolean = false;
  DosList: TStringList;
  DosPath: TStringList;
  Win3xList: TStringList;
  Win3xPath: TStringList;
  ScummVMList: TStringList;
  ScummVMPath: TStringList;
  ExtrassList: TStringList;
  DOSIndex, Win3xIndex, ScummVMIndex: String;
  AppHandle: HWND;
  LauncherState: Integer = 0;

implementation

{$R *.dfm}

uses utils, mf;

//procedure/functions

function GetDosCurrentDir: String;
begin
with MainForm do
 begin
  if DosMainList.ItemIndex <> -1 then
  Result := DosPath[FindString(DosList,DosMainList.Items[DosMainList.ItemIndex])];
 end;
end;

function GetWin3xCurrentDir: String;
begin
with MainForm do
 begin
  if Win3xMainList.ItemIndex <> -1 then
  Result := Win3xPath[FindString(Win3xList,Win3xMainList.Items[Win3xMainList.ItemIndex])];
 end;
end;

function GetScummVMCurrentDir: String;
begin
with MainForm do
 begin
  if ScummVMMainList.ItemIndex <> -1 then
  Result := ScummVMPath[FindString(ScummVMList,ScummVMMainList.Items[ScummVMMainList.ItemIndex])];
 end;
end;

function SetCaption: String;
begin
with MainForm do
 begin
  if eXoDOSSheet.Visible then
  begin
   if DosMainList.Items.Count <> -1 then
   begin
    Result :='Selected Dos Game : ['+IntToStr(DosMainList.ItemIndex+1)+' from '+IntToStr(DosMainList.Items.Count)+']';
   end else
    Result := 'Selected Dos Game : ['+IntToStr(0)+' from '+IntToStr(DosMainList.Items.Count)+']';
  end;
  if eXoWin3xSheet.Visible then
  begin
   if Win3xMainList.Items.Count <> -1 then
   begin
    Result :='Selected Win3x Game : ['+IntToStr(Win3xMainList.ItemIndex+1)+' from '+IntToStr(Win3xMainList.Items.Count)+']';
   end else
    Result := 'Selected Win3x Game : ['+IntToStr(0)+' from '+IntToStr(Win3xMainList.Items.Count)+']';
  end;
  if eXoScummVMSheet.Visible then
  begin
   if ScummVMMainList.Items.Count <> -1 then
   begin
    Result :='Selected ScummVM Game : ['+IntToStr(ScummVMMainList.ItemIndex+1)+' from '+IntToStr(ScummVMMainList.Items.Count)+']';
   end else
    Result := 'Selected ScummVM Game : ['+IntToStr(0)+' from '+IntToStr(ScummVMMainList.Items.Count)+']';
  end;
  end;
end;

procedure AddGamesToList;
begin
with MainForm do
 begin
  if MainForm.Caption <> 'Please wait...' then
   begin
    MainForm.Caption := 'Please wait...';
    TrayIcon.Hint := MainForm.Caption;
    PageControl.Enabled := False;
    PageControl.ActivePage := nil;
    FindEdit.Text := '';
    FindEdit.Enabled := False;
    cmdlabel.Caption := 'c:\eXo>find ';
    if PageControl2.Visible = True then
     begin
      if PageControl2.ActivePageIndex = 1 then
       begin
        MfDestroy;
        PlaybackTimer.Enabled := False;
       end;
         PageControl2.ActivePage:= nil;
     end;

    if ExistsGameDir('eXoDOS') then
    begin
    DosList.Clear;
    DosPath.Clear;
    DosMainList.Items.Clear;
    FindFilePattern(GetExecDir+'eXoDOS\!dos', '*.bat', DosList, DosPath);
    end;

    if ExistsGameDir('eXoWin3x') then
    begin
    Win3xList.Clear;
    Win3xPath.Clear;
    Win3xMainList.Items.Clear;
    FindFilePattern(GetExecDir+'eXoWin3x\!win3x', '*.bat', Win3xList, Win3xPath);
    end;

    if ExistsGameDir('eXoScummVM') then
    begin
    ScummVMList.Clear;
    ScummVMPath.Clear;
    ScummVMMainList.Items.Clear;
    FindFilePattern(GetExecDir+'eXoScummVM\!ScummVM', '*.bat', ScummVMList, ScummVMPath);
    end;

    if not (ExistsGameDir('eXoDOS')) and not(ExistsGameDir('eXoWin3x')) and not (ExistsGameDir('eXoScummVM')) then
    begin
     MainForm.Caption := 'Sorry, not found any eXo Collection folder';
     TrayIcon.Hint := MainForm.Caption;
    end else
    begin
     MainForm.Caption := 'The scan is complete, please select your favorite tab.';
     TrayIcon.Hint := MainForm.Caption;
    end;

     PageControl.Enabled := True;
   end;
 end;
end;

procedure ExtrasFileAdd(AMenu: TMenuItem);
var
  i: Integer;
  MenuItem: TMenuItem;
  MainDir: String;
begin
with MainForm do
 begin
  ExtrassList.Clear;
  AMenu.Clear;

  if eXoDOSSheet.Visible then
  if not (DosMainList.Items.Count = -1) then
  begin
   SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDir(DosPath[FindString(DosList,DosMainList.Items[DosMainList.ItemIndex])]))+'Extras');
   MainDir := IncludeTrailingPathDelimiter(ExtractFileDir(DosPath[FindString(DosList,DosMainList.Items[DosMainList.ItemIndex])]))+'Extras';
  end;

  if eXoWin3xSheet.Visible then
  if not (Win3xMainList.Items.Count = -1) then
  begin
   SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDir(Win3xPath[FindString(Win3xList,Win3xMainList.Items[Win3xMainList.ItemIndex])]))+'Extras');
   MainDir := IncludeTrailingPathDelimiter(ExtractFileDir(Win3xPath[FindString(Win3xList,Win3xMainList.Items[Win3xMainList.ItemIndex])]))+'Extras';
  end;

  if eXoScummVMSheet.Visible then
  if not (ScummVMMainList.Items.Count = -1) then
  begin
   SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDir(ScummVMPath[FindString(ScummVMList,ScummVMMainList.Items[ScummVMMainList.ItemIndex])]))+'Extras');
   MainDir := IncludeTrailingPathDelimiter(ExtractFileDir(ScummVMPath[FindString(ScummVMList,ScummVMMainList.Items[ScummVMMainList.ItemIndex])]))+'Extras';
  end;

  FindExtrasFile(MainDir, '*.bat', ExtrassList);
  if ExtrassList.Count <> -1 then
  for i := 0 to ExtrassList.Count-1 do
   begin
    MenuItem := TMenuItem.Create(AMenu);
    MenuItem.Caption := ExtractFileName(ChangeFileExt(ExtrassList[i],''));
    MenuItem.OnClick := ExtrasMenuClick;
    AMenu.Add(MenuItem);
   end;
 end;
end;

procedure TimerCallBack1(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;
begin
  AddGamesToList;
  KillTimer(MainForm.Handle,TIMER1);
end;

procedure TMainForm.PlayVideoOnClick;
var
  Videos: TStringDynArray;
  VideoPath: String;
begin
with MainForm do
begin
if eXoDOSSheet.Visible then
 if DosMainList.ItemIndex <> -1 then
 begin
  if DirectoryExists(GetMainDir+'Videos\MS-DOS\Recordings') then
   begin
    Videos := TDirectory.GetFiles(GetMainDir+'Videos\MS-DOS\Recordings', DosMainList.Items[DosMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
    for VideoPath in Videos do MFPlay(AppHandle, VideoPath);
    if FileExists(VideoPath) then
     begin
      PageControl2.ActivePageIndex := 1;
      PlaybackTimer.Enabled := True;
     end else
    if not FileExists(VideoPath) then
     begin
      PlaybackTimer.Enabled := False;
      MfDestroy;
      PageControl2.ActivePageIndex := 0;
     end;
   end;
 end;
if eXoWin3xSheet.Visible then
if Win3xMainList.ItemIndex <> -1 then
 begin
  if DirectoryExists(GetMainDir+'Videos\Windows 3x\Recordings') then
   begin
    Videos := TDirectory.GetFiles(GetMainDir+'Videos\Windows 3x\Recordings', Win3xMainList.Items[Win3xMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
    for VideoPath in Videos do MFPlay(AppHandle, VideoPath);
    if FileExists(VideoPath) then
     begin
      PageControl2.ActivePageIndex := 1;
      PlaybackTimer.Enabled := True;
     end else
    if not FileExists(VideoPath) then
     begin
      PlaybackTimer.Enabled := False;
      MfDestroy;
      PageControl2.ActivePageIndex := 0;
     end;
   end;
 end;
if eXoScummVMSheet.Visible then
if ScummVMMainList.ItemIndex <> -1 then
 begin
  if DirectoryExists(GetMainDir+'Videos\ScummVM\Recordings') and (DirectoryExists(GetMainDir+'Videos\ScummVM SVN\Recordings')) then
   begin
    Videos := TDirectory.GetFiles(GetMainDir+'Videos\ScummVM\Recordings', ScummVMMainList.Items[ScummVMMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
    if VideoPath = '' then
    Videos := TDirectory.GetFiles(GetMainDir+'Videos\ScummVM SVN\Recordings', ScummVMMainList.Items[ScummVMMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
    for VideoPath in Videos do MFPlay(AppHandle, VideoPath);
    if FileExists(VideoPath) then
     begin
      PageControl2.ActivePageIndex := 1;
      PlaybackTimer.Enabled := True;
     end else
    if not FileExists(VideoPath) then
     begin
      PlaybackTimer.Enabled := False;
      MfDestroy;
      PageControl2.ActivePageIndex := 0;
     end;
   end;
 end;
end;
end;

//IniFile

function TMainForm.GetFConfig: TMemIniFile;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  if FConfig = nil then
  FConfig := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini',TEncoding.UTF8);
  Result := FConfig;
end;

procedure TrayAction(Index: Integer);
begin
with MainForm do
case Index of
  0:
   begin
    OnTray := 0;
    Application.OnMinimize := nil;
    Application.OnRestore := nil;
    AClose := False;
    TrayIcon.Visible := False;
   end;
  1:
   begin
    OnTray := 1;
    Application.OnMinimize := OnMinimize;
    Application.OnRestore := OnRestore;
    AClose := False;
    TrayIcon.Visible := True;
   end;
  2:
   begin
    OnTray := 2;
    AClose := True;
    Application.OnMinimize := nil;
    Application.OnRestore := nil;
    TrayIcon.Visible := True;
   end;
end;
end;

procedure TMainForm.RegIni(Write: Boolean; FirstRun: Boolean);
begin
if FirstRun = True then
 begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  if not FileExists(ExtractFilePath(Application.ExeName)+'config.ini') then
  begin
   GetFConfig;
   FConfig.WriteInteger('General','Top',Top);
   FConfig.WriteInteger('General','Left',Left);
   FConfig.WriteInteger('General','Width',Width);
   FConfig.WriteInteger('General','Height',Height);
   FConfig.WriteInteger('General','SplitterPos',PageControl.Width);
   FConfig.WriteInteger('General','OnTray',0);
   FConfig.WriteInteger('General','Launcher state',0);
   FConfig.WriteFloat('General','Volume',1);
   FConfig.UpdateFile;
  end;
 end;
GetFConfig;
if Write = true then
 begin
  FConfig.WriteInteger('General','Top',Top);
  FConfig.WriteInteger('General','Left',Left);
  FConfig.WriteInteger('General','Width',Width);
  FConfig.WriteInteger('General','Height',Height);
  FConfig.WriteInteger('General','OnTray',OnTray);
  FConfig.WriteInteger('General','Launcher state',LauncherState);
  if PageControl2.Visible = True then
  begin
   FConfig.WriteInteger('General','SplitterPos',PageControl.Width);
  end;
  FConfig.UpdateFile;
 end else
 begin
  Top := FConfig.ReadInteger('General','Top',Top);
  Left := FConfig.ReadInteger('General','Left',Left);
  Width := FConfig.ReadInteger('General','Width',Width);
  Height := FConfig.ReadInteger('General','Height',Height);
  OnTray := FConfig.ReadInteger('General','OnTray',0);
  TrayAction(OnTray);
  LauncherState := FConfig.ReadInteger('General','Launcher state',0);
  case LauncherState of
   0:
    begin
     PageControl.Align := alClient;
     PageControl2.Visible := False;
     MainSplitter.Visible := False;
    end;
   1:
    begin
     PageControl.Align := alLeft;
     PageControl2.Visible := True;
     MainSplitter.Visible := True;
     PageControl2.ActivePage := nil;
     PageControl.Width := FConfig.ReadInteger('General','SplitterPos',PageControl.Width);
    end;
  end;
 end;
end;

//TMainForm

procedure TMainForm.WMSize(var Msg: TMessage);
begin
  inherited;
  if (Msg.wParam = SIZE_RESTORED) then MFWMSize(AppHandle);
end;

procedure TMainForm.OnMinimize(Sender: TObject);
begin
ShowWindow(Handle, SW_MINIMIZE);
ShowWindow(Handle, SW_HIDE);
end;

procedure TMainForm.OnRestore(Sender: TObject);
begin
ShowWindow(Handle, SW_RESTORE);
ShowWindow(Handle, SW_SHOW);
SetForegroundWindow(Handle);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
if not FileExists(ExtractFilePath(ParamStr(0))+'config.ini') then
 begin
  Position := poDesktopCenter;
  RegIni(False, True);
 end else Position := poDefaultPosOnly;

RegIni(False, False);

eXoDOSSheet.TabVisible := ExistsGameDir('eXoDOS');
eXoWin3xSheet.TabVisible := ExistsGameDir('eXoWin3x');
eXoScummVMSheet.TabVisible := ExistsGameDir('eXoScummVM');


if LoadResourceFontByID(1, 'MYFONT') then
 begin
   MainForm.ParentFont := False;
   MainForm.Font.Size := 8;
   MainForm.Font.Name := 'Modern DOS 8x14';

   cmdlabel.ParentFont := False;
   cmdlabel.Font.Size := 12;
   cmdlabel.Font.Name := 'Modern DOS 8x14';
   cmdlabel.Font.Color := clBlack;
   cmdlabel.Color := clWhite;
   cmdlabel.Caption := 'c:\eXo>find ';

   FindEdit.ParentFont := False;
   FindEdit.Font.Size := 12;
   FindEdit.Font.Name := 'Modern DOS 8x14';
   FindEdit.ParentColor := True;
   FindEdit.Color := clBlack;
   FindEdit.Font.Color := clWhite;
   FindEdit.BorderStyle := bsNone;

   DosMainList.ParentFont := False;
   DosMainList.Font.Size := 12;
   DosMainList.Font.Name := 'Modern DOS 8x14';
   DosMainList.ParentColor := True;
   DosMainList.Color := $00AA0000;
   DosMainList.Font.Color := $00FFFF55;

   Win3xMainList.ParentFont := False;
   Win3xMainList.Font.Size := 12;
   Win3xMainList.Font.Name := 'Modern DOS 8x14';
   Win3xMainList.ParentColor := True;
   Win3xMainList.Color := $00AA0000;
   Win3xMainList.Font.Color := $00FFFF55;

   ScummVMMainList.ParentFont := False;
   ScummVMMainList.Font.Size := 12;
   ScummVMMainList.Font.Name := 'Modern DOS 8x14';
   ScummVMMainList.ParentColor := True;
   ScummVMMainList.Color := $00AA0000;
   ScummVMMainList.Font.Color := $00FFFF55;

   PageControl.ParentFont := False;
   PageControl.Font.Size := 12;
   PageControl.Font.Name := 'Modern DOS 8x14';
   PageControl.ActivePage := nil;
   PageControl.Enabled := False;
 end;

DosList := TStringList.Create;
DosPath := TStringList.Create;
Win3xList := TStringList.Create;
Win3xPath := TStringList.Create;
ScummVMList := TStringList.Create;
ScummVMPath := TStringList.Create;
ExtrassList := TStringList.Create;
SetTimer(Handle,TIMER1,1000,@TimerCallBack1);

//mfplayer
if PageControl2.Visible = True then
 begin
  AppHandle := VideoBox.Handle;
  g_bHasVideo := False;
 end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if AClose = True then
 begin
  Action := caNone;
  onMinimize(Sender);
 end else Action := caFree;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
RegIni(True, False);
FConfig.Free;
DosList.Free;
DosPath.Free;
Win3xList.Free;
Win3xPath.Free;
ScummVMList.Free;
ScummVMPath.Free;
ExtrassList.Free;
if PageControl2.Visible = True then MfDestroy;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_F1 then MessageBox(Handle,'Keyboard shortcuts:' +
                                #10 + '1. Ctrl - | Volume Down' +
                                #10 + '2. Ctrl + | Volume UP',
                                'Help',0);
if Key = VK_F5 then AddGamesToList;
if Key = VK_RETURN then
 begin
   if eXoDOSSheet.Visible then DosMainListDblClick(Sender);
   if eXoWin3xSheet.Visible then Win3xMainListDblClick(Sender);
   if eXoScummVMSheet.Visible then ScummVMMainListDblClick(Sender);
 end;
if PageControl2.Visible = True then
 begin
  if (ssCtrl in Shift) and (Key = $BD) then MFVolumeDOWN;
  if (ssCtrl in Shift) and (Key = $BB) then MFVolumeUP;
 end;
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
Canvas.Rectangle (4, 4, ClientWidth -4, ClientHeight -28);
Canvas.Pen.Color := $00FFFF55;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 1;
Canvas.Rectangle (6, 6, ClientWidth -6, ClientHeight -30);
Canvas.Pen.Color := clBlack;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 24;
Canvas.Rectangle (0, ClientHeight -16, ClientWidth, ClientHeight);

//MFVideo
if PageControl2.Visible = True then MFPaint(AppHandle);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
Repaint;
MainPanel.SetBounds(10,10,ClientWidth -20, ClientHeight -44);
cmdlabel.SetBounds(8,ClientHeight -20, cmdlabel.Width, cmdlabel.Height);
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18);
end;

//TListMenu

procedure TMainForm.ListMenuPopup(Sender: TObject);
var
  Manuals: TStringDynArray;
  ManualPath: String;
begin
//by default manual menu is not enabled
Manual1.Enabled := False;

Launcherstate1.Items[LauncherState].Checked := True;

if eXoDOSSheet.Visible then
 if DosMainList.ItemIndex <> -1 then
 begin
  //add Aditional to menu
  ExtrasFileAdd(Extras1);
  //if Exists manual in dir to menu manual is enabled
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals\MS-DOS', DosMainList.Items[DosMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do
  Manual1.Enabled := True;
 end;

if eXoWin3xSheet.Visible then
 if Win3xMainList.ItemIndex <> -1 then
 begin
  //add Aditional to menu
  ExtrasFileAdd(Extras1);
  //if Exists manual in dir to menu manual is enabled
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals\Windows 3x', Win3xMainList.Items[Win3xMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do
  Manual1.Enabled := True;
 end;

if eXoScummVMSheet.Visible then
 if ScummVMMainList.ItemIndex <> -1 then
 begin
  //add Aditional to menu
  ExtrasFileAdd(Extras1);
  //if Exists manual in dir to menu manual is enabled
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals', ScummVMMainList.Items[ScummVMMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do
  Manual1.Enabled := True;
 end;

//Tray options
SystemTray1.Items[OnTray].Checked := True;
end;

procedure TMainForm.Manual1Click(Sender: TObject);
var
  Manuals: TStringDynArray;
  ManualPath: String;
begin
if eXoDOSSheet.Visible then
 begin
  SetCurrentDir(GetMainDir);
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals\MS-DOS', DosMainList.Items[DosMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do RunApplication(ManualPath,'');
 end;
if eXoWin3xSheet.Visible then
 begin
  SetCurrentDir(GetMainDir);
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals\Windows 3x', Win3xMainList.Items[Win3xMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do RunApplication(ManualPath,'');
 end;
if eXoScummVMSheet.Visible then
 begin
  SetCurrentDir(GetMainDir);
  Manuals := TDirectory.GetFiles(GetMainDir+'Manuals', ScummVMMainList.Items[ScummVMMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do RunApplication(ManualPath,'');
 end;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
if eXoDOSSheet.Visible then
 begin
  if DosMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetDosCurrentDir));
    RunApplication(GetDosCurrentDir, '');
   end;
 end;
if eXoWin3xSheet.Visible then
 begin
  if Win3xMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetWin3xCurrentDir));
    RunApplication(GetWin3xCurrentDir, '');
   end;
 end;
if eXoScummVMSheet.Visible then
 begin
  if ScummVMMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetScummVMCurrentDir));
    RunApplication(GetScummVMCurrentDir, '');
   end;
 end;
end;

procedure TMainForm.Install1Click(Sender: TObject);
begin
if eXoDOSSheet.Visible then
 begin
  if DosMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetDosCurrentDir));
    RunApplication(ExtractFilePath(GetDosCurrentDir) + 'install.bat', '');
   end;
 end;
if eXoWin3xSheet.Visible then
 begin
  if Win3xMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetWin3xCurrentDir));
    RunApplication(ExtractFilePath(GetWin3xCurrentDir) + 'install.bat', '');
   end;
 end;
if eXoScummVMSheet.Visible then
 begin
  if ScummVMMainList.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(GetScummVMCurrentDir));
    RunApplication(ExtractFilePath(GetScummVMCurrentDir) + 'install.bat', '');
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
if DosMainList.ItemIndex <> -1 then
 begin
   s := IncludeTrailingPathDelimiter(s);
   SetCurrentDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'Update');
   RunApplication(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'Update'+s+'update.bat', '');
 end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
AClose := False;
Close;
end;

procedure TMainForm.ExtrasMenuClick(Sender: TObject);
var
  CaptionReplace: String;
begin
CaptionReplace := StringReplace(ExtrassList[FindMenuString(Extras1,TMenuItem(Sender).Caption)], '&', '', [rfReplaceAll]);
if FileExists(CaptionReplace) then
 begin
  SetCurrentDir(ExtractFilePath(CaptionReplace));
  RunApplication(CaptionReplace,'');
 end;
end;

procedure TMainForm.none1Click(Sender: TObject);
begin
TrayAction(0);
end;

procedure TMainForm.Minimize1Click(Sender: TObject);
begin
TrayAction(1);
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
TrayAction(2);
end;

procedure TMainForm.Simple1Click(Sender: TObject);
begin
LauncherState := (Sender as TMenuItem).MenuIndex;
ShowMessage('Need to restart application!');
end;

//TMainList

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
OnRestore(Sender);
end;

procedure TMainForm.DosMainListClick(Sender: TObject);
begin
MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;

if eXoDOSSheet.Visible then
if DosMainList.ItemIndex <> -1 then DOSIndex := DosMainList.Items[DosMainList.ItemIndex];
if eXoWin3xSheet.Visible then
if Win3xMainList.ItemIndex <> -1 then Win3xIndex := Win3xMainList.Items[Win3xMainList.ItemIndex];
if eXoScummVMSheet.Visible then
if ScummVMMainList.ItemIndex <> -1 then ScummVMIndex := ScummVMMainList.Items[ScummVMMainList.ItemIndex];

//PlayVideo on click
if PageControl2.Visible = True then PlayVideoOnClick;
end;

procedure TMainForm.DosMainListDblClick(Sender: TObject);
begin
if DosMainList.ItemIndex <> -1 then
 begin
  SetCurrentDir(ExtractFilePath(GetDosCurrentDir));
  RunApplication(GetDosCurrentDir, '');
 end;
end;

procedure TMainForm.Win3xMainListDblClick(Sender: TObject);
begin
if Win3xMainList.ItemIndex <> -1 then
 begin
  SetCurrentDir(ExtractFilePath(GetWin3xCurrentDir));
  RunApplication(GetWin3xCurrentDir, '');
 end;
end;

procedure TMainForm.ScummVMMainListDblClick(Sender: TObject);
begin
if ScummVMMainList.ItemIndex <> -1 then
 begin
  SetCurrentDir(ExtractFilePath(GetScummVMCurrentDir));
  RunApplication(GetScummVMCurrentDir, '');
 end;
end;

procedure TMainForm.DosMainListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
with (Sender as TListBox) do ItemIndex := ItemAtPos(Point(X, Y), True);

if Button = mbRight then
if (Sender as TListBox).ItemIndex <> -1 then
 begin
  DosMainListClick(Sender);
  Open1.Enabled := True;
  Install1.Enabled := True;
  Extras1.Enabled := True;
  if ExistsGameDir('eXoDOS') then
  CheckforUpdate1.Enabled := eXoDOSSheet.Visible;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end else
 begin
  DosMainListClick(Sender);
  Open1.Enabled := False;
  Install1.Enabled := False;
  Extras1.Enabled := False;
  if ExistsGameDir('eXoDOS') then
  CheckforUpdate1.Enabled := eXoDOSSheet.Visible;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end;
end;

procedure TMainForm.DosMainListDrawItem(Control: TWinControl; Index: Integer;
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
    if odFocused In State then
     begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
     end;
  end;
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
cmdlabel.Caption := 'c:\eXo\'+PageControl.Pages[PageControl.TabIndex].Caption + '>find ';
FindEdit.Text := '';
FindEdit.Enabled := True;
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18);

//is active tab with video is playing then is stopped
if PageControl2.Visible = True then
if PageControl2.ActivePageIndex = 1 then
 begin
  PlaybackTimer.Enabled := False;
  MfDestroy;
 end;

if ExistsGameDir('eXoDOS') then
if eXoDOSSheet.Visible then
 begin
  if PageControl2.Visible = True then
   begin
    LoadImageFromRes('exodos',ImageBox);
    PageControl2.ActivePageIndex := 0;
   end;
  ActiveControl := DosMainList;
  MainForm.DosMainList.Items.Assign(DosList);
  if DosList.Count <> -1 then
  begin
  if DosIndex = '' then DosMainList.ItemIndex := 0 else
   begin
    DosMainList.ItemIndex := FindListBoxString(DosMainList,DOSIndex);
    SendMessage(DosMainList.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
   end;
  end;
 end;

if ExistsGameDir('eXoWin3x') then
if eXoWin3xSheet.Visible then
 begin
  if PageControl2.Visible = True then
   begin
    LoadImageFromRes('exowin3x',ImageBox);
    PageControl2.ActivePageIndex := 0;
   end;
  ActiveControl := Win3xMainList;
  MainForm.Win3xMainList.Items.Assign(Win3xList);
  if Win3xList.Count <> -1 then
  begin
  if Win3xIndex = '' then Win3xMainList.ItemIndex := 0 else
   begin
    Win3xMainList.ItemIndex := FindListBoxString(Win3xMainList,Win3xIndex);
    SendMessage(Win3xMainList.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
   end;
  end;
 end;

if ExistsGameDir('eXoScummVM') then
if eXoScummVMSheet.Visible then
 begin
  if PageControl2.Visible = True then
   begin
    LoadImageFromRes('scummvm',ImageBox);
    PageControl2.ActivePageIndex := 0;
   end;
  ActiveControl := ScummVMMainList;
  MainForm.ScummVMMainList.Items.Assign(ScummVMList);
  if ScummVMList.Count <> -1 then
  begin
  if ScummVMIndex = '' then ScummVMMainList.ItemIndex := 0 else
   begin
    ScummVMMainList.ItemIndex := FindListBoxString(ScummVMMainList,ScummVMIndex);
    SendMessage(ScummVMMainList.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
   end;
  end;
 end;

MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;
end;

procedure TMainForm.FindEditChange(Sender: TObject);
begin
if eXoDOSSheet.Visible then
 FindListIndex(FindEdit.Text, DosMainList, DosList);
if eXoWin3xSheet.Visible then
 FindListIndex(FindEdit.Text, Win3xMainList, Win3xList);
if eXoScummVMSheet.Visible then
 FindListIndex(FindEdit.Text, ScummVMMainList, ScummVMList);

MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;
end;

procedure TMainForm.FindEditContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
Handled := True;
end;

procedure TMainForm.FindEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Mgs: TMsg;
begin
if Key = VK_F5 then AddGamesToList;
if Key = VK_RETURN then
 begin
  PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE);
  if eXoDOSSheet.Visible then DosMainListDblClick(Sender);
  if eXoWin3xSheet.Visible then Win3xMainListDblClick(Sender);
  if eXoScummVMSheet.Visible then ScummVMMainListDblClick(Sender);
 end;
if Key = VK_ESCAPE then
  begin
   PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE);
   FindEdit.Text := '';
  end;
end;

procedure TMainForm.PlaybackTimerTimer(Sender: TObject);
begin
if MFIfStoping = True then
 begin
  PageControl2.ActivePageIndex := 0;
  PlaybackTimer.Enabled := False;
 end;
end;

end.
