unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  IniFiles, Vcl.ComCtrls, IOUtils, Types, Vcl.ExtCtrls, Vcl.Buttons,
  System.Actions, Vcl.ActnList;

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
    Launcherstate1: TMenuItem;
    Simple1: TMenuItem;
    Extended1: TMenuItem;
    N8: TMenuItem;
    VideoEndTimer: TTimer;
    FullScreen1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    FullScreenonstartup1: TMenuItem;
    SysPanel: TPanel;
    MinButton: TSpeedButton;
    CloseButton: TSpeedButton;
    SysLabel: TLabel;
    NotesBox: TMemo;
    VideoSplitter: TSplitter;
    PageControl3: TPageControl;
    VideoSheet: TTabSheet;
    VideoBox: TPanel;
    CoverSheet: TTabSheet;
    CoverImage: TImage;
    AboutHelp1: TMenuItem;
    N11: TMenuItem;
    TimerOnClick: TTimer;
    ActionList: TActionList;
    ATabChange: TAction;
    AAbout: TAction;
    AScan: TAction;
    AFullScreen: TAction;
    ADblClickonListBox: TAction;
    AVolDown: TAction;
    AVolUP: TAction;
    APlayPause: TAction;
    AManualView: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure VideoEndTimerTimer(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure VideoBoxClick(Sender: TObject);
    procedure MinButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure NotesBoxContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure AboutHelp1Click(Sender: TObject);
    procedure DosMainListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DosMainListDblClick(Sender: TObject);
    procedure TimerOnClickTimer(Sender: TObject);
    procedure DosMainListClick(Sender: TObject);
    procedure ATabChangeExecute(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure AScanExecute(Sender: TObject);
    procedure AFullScreenExecute(Sender: TObject);
    procedure ADblClickonListBoxExecute(Sender: TObject);
    procedure AVolDownExecute(Sender: TObject);
    procedure AVolUPExecute(Sender: TObject);
    procedure DosMainListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure APlayPauseExecute(Sender: TObject);
  private
    { Private declarations }
    IsArrowDown: Boolean;
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
  isFullScreen: Boolean = False;
  GetNotesMemo: String = '';


implementation

{$R *.dfm}

uses utils, mf;

//procedure/functions//////////////////////////////////////////////////////////

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
var
  ListBox: TListBox;
begin
with MainForm do
 begin
  case PageControl.ActivePageIndex of
  0: ListBox := DosMainList;
  1: ListBox := Win3xMainList;
  2: ListBox := ScummVMMainList;
  end;

  if PageControl.ActivePage.Visible then
  begin
   if ListBox.Items.Count <> -1 then
   begin
    Result :='Selected game : ['+IntToStr(ListBox.ItemIndex+1)+' from '+IntToStr(ListBox.Items.Count)+']';
   end else
    Result := 'Selected game : ['+IntToStr(0)+' from '+IntToStr(ListBox.Items.Count)+']';
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
    SysLabel.Caption := MainForm.Caption; 
    PageControl.Enabled := False;
    PageControl.ActivePage := nil;
    FindEdit.Text := '';
    FindEdit.Enabled := False;
    cmdlabel.Caption := 'c:\eXo>find ';
    if PageControl2.Visible = True then
     begin
      PageControl2.ActivePage := nil;
      if PageControl3.ActivePageIndex = 0 then
       begin
        MfStop;
        VideoEndTimer.Enabled := False;
       end else PageControl3.ActivePageIndex := 1;
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
     SysLabel.Caption := MainForm.Caption;
    end else
    begin
     MainForm.Caption := 'The scan is complete, please select your favorite tab.';
     TrayIcon.Hint := MainForm.Caption;
     SysLabel.Caption := MainForm.Caption;
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
  ListBox: TListBox;
  StringList1: TStringList;
  StringList2: TStringList;
begin
with MainForm do
 begin
  ExtrassList.Clear;
  AMenu.Clear;

  case PageControl.ActivePageIndex of
   0:
    begin
     ListBox := DosMainList;
     StringList1 := DosPath;
     StringList2 := DosList;
    end;
   1:
    begin
     ListBox := Win3xMainList;
     StringList1 := Win3xPath;
     StringList2 := Win3xList;
    end;
   2:
    begin
     ListBox := ScummVMMainList;
     StringList1 := ScummVMPath;
     StringList2 := ScummVMList;
    end;
  end;

  if PageControl.ActivePage.Visible then
  if not (ListBox.Items.Count = -1) then
  begin
   SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDir(StringList1[FindString(StringList2,ListBox.Items[ListBox.ItemIndex])]))+'Extras');
   MainDir := IncludeTrailingPathDelimiter(ExtractFileDir(StringList1[FindString(StringList2,ListBox.Items[ListBox.ItemIndex])]))+'Extras';
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

procedure StopVideoByTimer; //stop video after 1 sec
begin
  with MainForm do
   begin
    if PageControl2.Visible = True then
     TThread.CreateAnonymousThread(procedure begin
     Sleep(1500);
     MFPause;
    end).Start;
   end;
end;

procedure TMainForm.PlayVideoOnClick;
var
  Videos: TStringDynArray;
  VideoPath: String;
  ListBox: TListBox;
  VideoDir: String;
begin
  case PageControl.ActivePageIndex of
   0:
    begin
     ListBox := DosMainList;
     VideoDir := 'Videos\MS-DOS\Recordings';
    end;
   1:
    begin
     ListBox := Win3xMainList;
     VideoDir := 'Videos\Windows 3x\Recordings';
    end;
   2:
    begin
     ListBox := ScummVMMainList;
     VideoDir := 'Videos\ScummVM\Recordings';
    end;
  end;

if PageControl.ActivePage.Visible then
if ListBox.ItemIndex <> -1 then
 begin
  if DirectoryExists(GetMainDir+VideoDir) then
   begin
    Videos := TDirectory.GetFiles(GetMainDir+VideoDir, ListBox.Items[ListBox.ItemIndex]+'*', TSearchOption.soAllDirectories);
    for VideoPath in Videos do
     begin
      MFPlay(AppHandle, VideoPath);
      PageControl3.ActivePageIndex := 0;
      VideoEndTimer.Enabled := True;
     end;
    if not FileExists(VideoPath) then
     begin
      VideoEndTimer.Enabled := False;
      MFStop;
      PageControl3.ActivePageIndex := 1;
     end;
   end;
 end;
end;

procedure ActiveListOnClick;
begin
with MainForm do
 begin
   NotesBox.Lines.Text := '';

   if eXoDOSSheet.Visible then
   if DosMainList.ItemIndex <> -1 then
    begin
     DOSIndex := DosMainList.Items[DosMainList.ItemIndex];
     //if extended version
     if PageControl2.Visible = True then
      begin
       if PageControl2.ActivePageIndex = 0 then PageControl2.ActivePageIndex := 1;
       //get notes
       if FileExists(GetMainDir+'Data\Platforms\MS-DOS.xml') then
       NotesBox.Lines.Text := GetNotes(DosMainList.Items[DosMainList.ItemIndex], GetNotesMemo);
      end;
    end else if PageControl2.Visible = True then PageControl2.ActivePageIndex := 0;
   if eXoWin3xSheet.Visible then
   if Win3xMainList.ItemIndex <> -1 then
    begin
     Win3xIndex := Win3xMainList.Items[Win3xMainList.ItemIndex];
     //if extended version
     if PageControl2.Visible = True then
      begin
       if PageControl2.ActivePageIndex = 0 then PageControl2.ActivePageIndex := 1;
       //get notes
       if FileExists(GetMainDir+'Data\Platforms\Windows 3x.xml') then
       NotesBox.Lines.Text := GetNotes(Win3xMainList.Items[Win3xMainList.ItemIndex], GetNotesMemo);
      end;
    end else if PageControl2.Visible = True then PageControl2.ActivePageIndex := 0;
   if eXoScummVMSheet.Visible then
   if ScummVMMainList.ItemIndex <> -1 then
    begin
     ScummVMIndex := ScummVMMainList.Items[ScummVMMainList.ItemIndex];
     //if extended version
     if PageControl2.Visible = True then
      begin
       if PageControl2.ActivePageIndex = 0 then PageControl2.ActivePageIndex := 1;
       //get notes
       if FileExists(GetMainDir+'Data\Platforms\ScummVM.xml') or
        FileExists(GetMainDir+'Data\Platforms\ScummVM SVN.xml') then
       NotesBox.Lines.Text := GetNotes(ScummVMMainList.Items[ScummVMMainList.ItemIndex], GetNotesMemo);
      end;
    end else if PageControl2.Visible = True then PageControl2.ActivePageIndex := 0;

  MainForm.Caption := SetCaption;
  TrayIcon.Hint := MainForm.Caption;
  SysLabel.Caption := MainForm.Caption;
  PlayVideoOnClick;
 end;
end;

procedure MainListDblClick;
var
  ListBox: TListBox;
  PathDir: String;
begin
with MainForm do
begin

case PageControl.ActivePageIndex of
   0:
    begin
     ListBox := DosMainList;
     PathDir := GetDosCurrentDir;
    end;
   1:
    begin
     ListBox := Win3xMainList;
     PathDir := GetWin3xCurrentDir;
    end;
   2:
    begin
     ListBox := ScummVMMainList;
     PathDir := GetScummVMCurrentDir;
    end;
  end;

if PageControl.ActivePage.Visible then
if ListBox.ItemIndex <> -1 then
 begin
  SetCurrentDir(ExtractFilePath(PathDir));
  if RunApplication(PathDir, '') = True then StopVideoByTimer;
 end;
end;
end;

//IniFile//////////////////////////////////////////////////////////////////////

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
   FConfig.WriteInteger('General','OnTray',0);
   FConfig.WriteInteger('General','Launcher state',0);
   FConfig.WriteFloat('General','Volume',1);
   FConfig.WriteBool('General','FullScreen',False);
   FConfig.UpdateFile;
  end;
 end;
GetFConfig;
if Write = true then
 begin
  FConfig.WriteBool('General','FullScreen',FullScreenonstartup1.Checked);
  if FullScreenonstartup1.Checked = False then
  if isFullScreen = False then
   begin
    FConfig.WriteInteger('General','Top',Top);
    FConfig.WriteInteger('General','Left',Left);
    FConfig.WriteInteger('General','Width',Width);
    FConfig.WriteInteger('General','Height',Height);
   end;
  FConfig.WriteInteger('General','OnTray',OnTray);
  FConfig.WriteInteger('General','Launcher state',LauncherState);
  if PageControl2.Visible = True then
  begin
   if isFullScreen = True then
   begin
    FConfig.WriteInteger('General','SplitterPosFull',PageControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosFull',NotesBox.Height);
   end else
   begin
    FConfig.WriteInteger('General','SplitterPosNormal',PageControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosNormal',NotesBox.Height);
   end;
  end;
  FConfig.UpdateFile;
 end else
 begin
  FullScreenonstartup1.Checked := FConfig.ReadBool('General','FullScreen',False);
  if FullScreenonstartup1.Checked = False then
  begin
   Top := FConfig.ReadInteger('General','Top',Top);
   Left := FConfig.ReadInteger('General','Left',Left);
   Width := FConfig.ReadInteger('General','Width',Width);
   Height := FConfig.ReadInteger('General','Height',Height);
  end else
  begin
   isFullScreen := True;
   MainForm.BorderStyle := bsNone;
   MainForm.WindowState := wsMaximized;
   SysPanel.Visible := isFullScreen;
   SysLabel.Visible := isFullScreen;
  end;
  OnTray := FConfig.ReadInteger('General','OnTray',0);
  TrayAction(OnTray);
  LauncherState := FConfig.ReadInteger('General','Launcher state',0);
  case LauncherState of
   0:
    begin
     PageControl.Align := alClient;
     PageControl2.Visible := False;
     MainSplitter.Visible := False;
     VideoSplitter.Visible := False;
    end;
   1:
    begin
     PageControl.Align := alLeft;
     PageControl2.Visible := True;
     MainSplitter.Visible := True;
     VideoSplitter.Visible := True;
     PageControl2.ActivePage := nil;
     if isFullScreen = True then
      begin
       PageControl.Width := FConfig.ReadInteger('General','SplitterPosFull',PageControl.Width);
       NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosFull',NotesBox.Height);
     end else
      begin
       PageControl.Width := FConfig.ReadInteger('General','SplitterPosNormal',PageControl.Width);
       NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosNormal',NotesBox.Height);
      end;
    end;
  end;
 end;
end;

//TMainForm////////////////////////////////////////////////////////////////////

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
if isFullScreen = True then
 begin
  ShowWindow(Handle, SW_RESTORE);
  ShowWindow(Handle, SW_SHOWMAXIMIZED);
 end else
 begin
  ShowWindow(Handle, SW_RESTORE);
  ShowWindow(Handle, SW_SHOW);
 end;
SysPanel.Visible := isFullScreen;
SysLabel.Visible := isFullScreen;
SetForegroundWindow(Handle);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
if not FileExists(ExtractFilePath(ParamStr(0))+'config.ini') then
 begin
  Position := poDesktopCenter;
  RegIni(False, True);
 end else
 begin
  Position := poDefaultPosOnly;
  RegIni(False, False);
 end;

eXoDOSSheet.TabVisible := ExistsGameDir('eXoDOS');
eXoWin3xSheet.TabVisible := ExistsGameDir('eXoWin3x');
eXoScummVMSheet.TabVisible := ExistsGameDir('eXoScummVM');

if LoadResourceFontByID(1, 'MYFONT') then
 begin
   MainForm.ParentFont := False;
   MainForm.Font.Size := 8;
   MainForm.Font.Name := 'Modern DOS 8x16';

   SysLabel.ParentFont := False;
   SysLabel.Font.Size := 12;
   SysLabel.Font.Name := 'Modern DOS 8x16';
   SysLabel.Font.Color := clWhite;

   cmdlabel.ParentFont := False;
   cmdlabel.Font.Size := 12;
   cmdlabel.Font.Name := 'Modern DOS 8x16';
   cmdlabel.Font.Color := clBlack;
   cmdlabel.Color := clWhite;
   cmdlabel.Caption := 'c:\eXo>find ';

   NotesBox.ParentFont := False;
   NotesBox.Font.Size := 12;
   NotesBox.Font.Name := 'Modern DOS 8x16';
   NotesBox.Font.Color := clWhite;
   NotesBox.Color := $00AA0000;

   FindEdit.ParentFont := False;
   FindEdit.Font.Size := 12;
   FindEdit.Font.Name := 'Modern DOS 8x16';
   FindEdit.ParentColor := True;
   FindEdit.Color := clBlack;
   FindEdit.Font.Color := clWhite;
   FindEdit.BorderStyle := bsNone;
   FindEdit.Enabled := False;

   DosMainList.ParentFont := False;
   DosMainList.Font.Size := 12;
   DosMainList.Font.Name := 'Modern DOS 8x16';
   DosMainList.ParentColor := True;
   DosMainList.Color := $00AA0000;
   DosMainList.Font.Color := $00FFFF55;

   Win3xMainList.ParentFont := False;
   Win3xMainList.Font.Size := 12;
   Win3xMainList.Font.Name := 'Modern DOS 8x16';
   Win3xMainList.ParentColor := True;
   Win3xMainList.Color := $00AA0000;
   Win3xMainList.Font.Color := $00FFFF55;

   ScummVMMainList.ParentFont := False;
   ScummVMMainList.Font.Size := 12;
   ScummVMMainList.Font.Name := 'Modern DOS 8x16';
   ScummVMMainList.ParentColor := True;
   ScummVMMainList.Color := $00AA0000;
   ScummVMMainList.Font.Color := $00FFFF55;

   PageControl.ParentFont := False;
   PageControl.Font.Size := 12;
   PageControl.Font.Name := 'Modern DOS 8x16';
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
MainPanel.SetBounds(10,10,ClientWidth -20, ClientHeight -44);
cmdlabel.SetBounds(8,ClientHeight -20, cmdlabel.Width, cmdlabel.Height);
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18);
if isFullScreen = True then
 begin
  SysPanel.SetBounds(280,1,MainPanel.Width - 282, SysPanel.Height);
  CloseButton.Left := SysPanel.Width - 24;
  MinButton.Left := SysPanel.Width - 50;
  SysLabel.SetBounds(2,0, SysPanel.Width-100, SysLabel.Height);
 end;
Repaint;
end;

//TListMenu////////////////////////////////////////////////////////////////////

procedure TMainForm.ListMenuPopup(Sender: TObject);
var
  Manuals: TStringDynArray;
  ManualPath, ManualPathDir: String;
  ListBox: TListBox;
begin
  case PageControl.ActivePageIndex of
  0:
   begin
    ListBox := DosMainList;
    ManualPathDir := 'Manuals\MS-DOS';
   end;
  1:
   begin
    ListBox := Win3xMainList;
    ManualPathDir := 'Manuals\Windows 3x';
   end;
  2:
   begin
    ListBox := ScummVMMainList;
    ManualPathDir := 'Manuals';
   end;
  end;

//by default manual menu is not enabled
Manual1.Enabled := False;

Launcherstate1.Items[LauncherState].Checked := True;

if PageControl.ActivePage.Visible then
 if ListBox.ItemIndex <> -1 then
 begin
  //add Aditional to menu
  ExtrasFileAdd(Extras1);
  //if Exists manual in dir to menu manual is enabled
  Manuals := TDirectory.GetFiles(GetMainDir+ManualPathDir, ListBox.Items[ListBox.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do
  Manual1.Enabled := True;
 end;

//Tray options
SystemTray1.Items[OnTray].Checked := True;
end;

procedure TMainForm.Manual1Click(Sender: TObject);
var
  Manuals: TStringDynArray;
  ManualPath, ManualPathDir: String;
  ListBox: TListBox;
begin
  case PageControl.ActivePageIndex of
  0:
   begin
    ListBox := DosMainList;
    ManualPathDir := 'Manuals\MS-DOS';
   end;
  1:
   begin
    ListBox := Win3xMainList;
    ManualPathDir := 'Manuals\Windows 3x';
   end;
  2:
   begin
    ListBox := ScummVMMainList;
    ManualPathDir := 'Manuals';
   end;
  end;
if PageControl.ActivePage.Visible then
 begin
  SetCurrentDir(GetMainDir);
  Manuals := TDirectory.GetFiles(GetMainDir+ManualPathDir, ListBox.Items[ListBox.ItemIndex]+'*', TSearchOption.soAllDirectories);
  for ManualPath in Manuals do
  if RunApplication(ManualPath,'') = True then StopVideoByTimer;
 end;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
MainListDblClick;
end;

procedure TMainForm.Install1Click(Sender: TObject);
var
  ListBox: TListBox;
  InstallFileDir: String;
begin
case PageControl.ActivePageIndex of
   0:
    begin
     ListBox := DosMainList;
     InstallFileDir := GetDosCurrentDir;
    end;
   1:
    begin
     ListBox := Win3xMainList;
     InstallFileDir := GetWin3xCurrentDir;
    end;
   2:
    begin
     ListBox := ScummVMMainList;
     InstallFileDir := GetScummVMCurrentDir;
    end;
  end;

if PageControl.ActivePage.Visible then
 begin
  if ListBox.ItemIndex <> -1 then
   begin
    SetCurrentDir(ExtractFilePath(InstallFileDir));
    if RunApplication(ExtractFilePath(InstallFileDir) + 'install.bat', '') = True then StopVideoByTimer;
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
   if RunApplication(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'Update'+s+'update.bat', '') = True then StopVideoByTimer;
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
if PageControl.ActivePage.Visible then
begin
CaptionReplace := StringReplace(ExtrassList[FindMenuString(Extras1,TMenuItem(Sender).Caption)], '&', '', [rfReplaceAll]);
if FileExists(CaptionReplace) then
 begin
  SetCurrentDir(ExtractFilePath(CaptionReplace));
  if RunApplication(CaptionReplace,'') = True then StopVideoByTimer;
 end;
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

procedure TMainForm.FullScreen1Click(Sender: TObject);
begin
if isFullScreen = False then
 begin
  isFullScreen := True;
  FConfig.WriteInteger('General','Top',Top);
  FConfig.WriteInteger('General','Left',Left);
  FConfig.WriteInteger('General','Width',Width);
  FConfig.WriteInteger('General','Height',Height);
  MainForm.BorderStyle := bsNone;
  MainForm.WindowState := wsMaximized;
  SysPanel.Visible := True;
  SysLabel.Visible := True;
  if PageControl2.Visible = True then
   begin
    FConfig.WriteInteger('General','SplitterPosNormal',PageControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosNormal',NotesBox.Height);
    PageControl.Width := FConfig.ReadInteger('General','SplitterPosFull',PageControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosFull',NotesBox.Height);
   end;
  FConfig.UpdateFile;
 end else
 begin
  isFullScreen := False;
  MainForm.BorderStyle := bsSizeable;
  MainForm.WindowState := wsNormal;
  SysPanel.Visible := False;
  SysLabel.Visible := False;
  Top := FConfig.ReadInteger('General','Top',Top);
  Left := FConfig.ReadInteger('General','Left',Left);
  Width := FConfig.ReadInteger('General','Width',Width);
  Height := FConfig.ReadInteger('General','Height',Height);
  if PageControl2.Visible = True then
   begin
    FConfig.WriteInteger('General','SplitterPosFull',PageControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosFull',NotesBox.Height);
    PageControl.Width := FConfig.ReadInteger('General','SplitterPosNormal',PageControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosNormal',NotesBox.Height);
   end;
 end;
 FConfig.UpdateFile;
end;

procedure TMainForm.AboutHelp1Click(Sender: TObject);
begin
MessageBox(Handle,'doslauncher' +
                  #10 + #10 +
                  'Link : github.com/gorbatiiivan/doslauncher'+
                  #10 + #10 +
                  'Compatible with eXoDOS V5,eXoWin3x,eXoScummVM' +
                  #10 + #10 +
                  '-- Keyboard shortcuts --' +
                  #10 +
                  #10 + 'Main shortcuts:' +
                  #10 + '1. Ctrl+Down      | Volume Down' +
                  #10 + '2. Ctrl+Up        | Volume UP' +
                  #10 + '3. Space          | Play/Pause video' +
                  #10 + '4. F5             | Scanning games list'+
                  #10 + '5. Enter          | Run select game'+
                  #10 + '6. F11            | FullScreen'+
                  #10 + '7. Ctrl+TAB       | Tab change'+
                  #10 + '8. F3             | View manual'+
                  #10 +
                  #10 + 'Find box:'+
                  #10 + 'Escape            | Clear find items'+
                  #10 + ''+
                  #10 + 'Video:'+
                  #10 + 'Press on the item in the list for replay video'+
                  #10 + 'Press one click on the video for stoping video'
                  ,'About / Help',0);
end;

//Other controls///////////////////////////////////////////////////////////////

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
OnRestore(Sender);
end;

procedure TMainForm.DosMainListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Sender is TListBox then
(Sender as TListBox).ItemIndex:=TListBox(Sender).ItemIndex;

with (Sender as TListBox) do ItemIndex := ItemAtPos(Point(X, Y), True);

if Button = mbRight then
if (Sender as TListBox).ItemIndex <> -1 then
 begin
  Open1.Enabled := True;
  Install1.Enabled := True;
  Extras1.Enabled := True;
  if ExistsGameDir('eXoDOS') then
  CheckforUpdate1.Enabled := eXoDOSSheet.Visible;
  FullScreen1.Checked := isFullScreen;
  ActiveListOnClick;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end else
 begin
  Open1.Enabled := False;
  Install1.Enabled := False;
  Extras1.Enabled := False;
  if ExistsGameDir('eXoDOS') then
  CheckforUpdate1.Enabled := eXoDOSSheet.Visible;
  FullScreen1.Checked := isFullScreen;
  ActiveListOnClick;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end;

end;

procedure TMainForm.DosMainListClick(Sender: TObject);
begin
if IsArrowDown then
  begin
    TimerOnClick.Enabled := False;
    TimerOnClick.Interval := 500;
    TimerOnClick.Enabled := True;
  end else
  begin
    TimerOnClick.Enabled := False;
    TimerOnClick.Interval := GetDoubleClickTime() + 250;
    TimerOnClick.Enabled := True;
  end;
end;

procedure TMainForm.DosMainListDblClick(Sender: TObject);
begin
TimerOnClick.Enabled := False;
MainListDblClick;
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

procedure TMainForm.DosMainListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT) then IsArrowDown := True;
end;

procedure TMainForm.DosMainListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT) then IsArrowDown := False;
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
//is active tab with video is playing then is stopped
if PageControl2.Visible = True then
if PageControl3.ActivePageIndex = 0 then
 begin
  VideoEndTimer.Enabled := False;
  MfStop;
 end;

if ExistsGameDir('eXoDOS') then
if eXoDOSSheet.Visible then
 begin
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
  //if launcher state: extended then page visible
  if PageControl2.Visible = True then
   begin
    //load image
    LoadImageFromRes('exodos',ImageBox);
    LoadImageFromRes('exodos',CoverImage);
    PageControl3.ActivePageIndex := 1;
    //load notes
    if FileExists(GetMainDir+'Data\Platforms\MS-DOS.xml') then
    GetNotesMemo := Utf8ToString(GetNotesList(GetMainDir+'Data\Platforms\MS-DOS.xml'));
   end;
 end;

if ExistsGameDir('eXoWin3x') then
if eXoWin3xSheet.Visible then
 begin
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
  //if launcher state: extended then page visible
  if PageControl2.Visible = True then
   begin
    //load image
    LoadImageFromRes('exowin3x',ImageBox);
    LoadImageFromRes('exowin3x',CoverImage);
    PageControl3.ActivePageIndex := 1;
    //load notes
    if FileExists(GetMainDir+'Data\Platforms\Windows 3x.xml') then
    GetNotesMemo := Utf8ToString(GetNotesList(GetMainDir+'Data\Platforms\Windows 3x.xml'));
   end;
 end;

if ExistsGameDir('eXoScummVM') then
if eXoScummVMSheet.Visible then
 begin
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
  //if launcher state: extended then page visible
  if PageControl2.Visible = True then
   begin
    //load image
    LoadImageFromRes('scummvm',ImageBox);
    LoadImageFromRes('scummvm',CoverImage);
    PageControl3.ActivePageIndex := 1;
    //load notes
    if FileExists(GetMainDir+'Data\Platforms\ScummVM.xml') then
     GetNotesMemo := Utf8ToString(GetNotesList(GetMainDir+'Data\Platforms\ScummVM.xml'));
    if FileExists(GetMainDir+'Data\Platforms\ScummVM SVN.xml') then
     GetNotesMemo := GetNotesMemo + Utf8ToString(GetNotesList(GetMainDir+'Data\Platforms\ScummVM SVN.xml'));
   end;
 end;

MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;
SysLabel.Caption := MainForm.Caption;
cmdlabel.Caption := 'c:\eXo\'+PageControl.Pages[PageControl.TabIndex].Caption + '>find ';
FindEdit.Text := '';
FindEdit.Enabled := True;
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18);
PageControl2.ActivePageIndex := 0;
end;

procedure TMainForm.FindEditChange(Sender: TObject);
begin
if PageControl.ActivePageIndex <> -1 then
begin
if eXoDOSSheet.Visible then
 FindListIndex(FindEdit.Text, DosMainList, DosList);
if eXoWin3xSheet.Visible then
 FindListIndex(FindEdit.Text, Win3xMainList, Win3xList);
if eXoScummVMSheet.Visible then
 FindListIndex(FindEdit.Text, ScummVMMainList, ScummVMList);

MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;
SysLabel.Caption := MainForm.Caption;
end;
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
if Key = VK_RETURN then
 begin
  PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE);
 end;
if Key = VK_ESCAPE then
  begin
   PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE);
   FindEdit.Text := '';
  end;
end;

procedure TMainForm.VideoEndTimerTimer(Sender: TObject);
begin
if MFIfStoping = True then
 begin
  PageControl3.ActivePageIndex := 1;
  VideoEndTimer.Enabled := False;
 end;
end;

procedure TMainForm.VideoBoxClick(Sender: TObject);
begin
if PageControl2.Visible = True then
 begin
  MFStop;
  PageControl3.ActivePageIndex := 1;
 end;
end;

procedure TMainForm.TimerOnClickTimer(Sender: TObject);
begin
TimerOnClick.Enabled := False;
ActiveListOnClick;
end;

procedure TMainForm.MinButtonClick(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.NotesBoxContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
Handled := True;
end;

//ActionList///////////////////////////////////////////////////////////////////

procedure TMainForm.ATabChangeExecute(Sender: TObject);
begin
if (MainForm.Caption <> 'Please wait...') then
if (MainForm.Caption <> '')  then
PageControl.SelectNextPage(True,True);
end;

procedure TMainForm.AAboutExecute(Sender: TObject);
begin
AboutHelp1Click(Sender);
end;

procedure TMainForm.AScanExecute(Sender: TObject);
begin
AddGamesToList;
end;

procedure TMainForm.AFullScreenExecute(Sender: TObject);
begin
FullScreen1Click(Sender);
end;

procedure TMainForm.APlayPauseExecute(Sender: TObject);
begin
if PageControl2.ActivePageIndex = 1 then
if MFIfStoping = False then MFPause else PlayVideoOnClick;
end;

procedure TMainForm.ADblClickonListBoxExecute(Sender: TObject);
begin
if PageControl.ActivePageIndex <> -1 then MainListDblClick;
end;

procedure TMainForm.AVolDownExecute(Sender: TObject);
begin
MFVolumeDOWN;
end;

procedure TMainForm.AVolUPExecute(Sender: TObject);
begin
MFVolumeUP;
end;

///////////////////////////////////////////////////////////////////////////////
end.
