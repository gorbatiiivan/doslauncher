unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Themes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  IniFiles, Vcl.ComCtrls, IOUtils, Types, Vcl.ExtCtrls, Vcl.Buttons,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, StrUtils,
  Jpeg, PngImage, GIFImg;

type
  TMainForm = class(TForm)
    ListMenu: TPopupMenu;
    N1: TMenuItem;
    Install1: TMenuItem;
    N2: TMenuItem;
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
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
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
    AboutHelp1: TMenuItem;
    N11: TMenuItem;
    TimerOnClick: TTimer;
    ActionList: TActionList;
    ATabChange: TAction;
    AAbout: TAction;
    AFullScreen: TAction;
    ADblClickonListBox: TAction;
    AVolDown: TAction;
    AVolUP: TAction;
    APlayPause: TAction;
    AManualView: TAction;
    N12: TMenuItem;
    Addtofavorit1: TMenuItem;
    N13: TMenuItem;
    Aditional1: TMenuItem;
    Selectedgame1: TMenuItem;
    Createdesktoptabshortcut1: TMenuItem;
    Desktopshortcut1: TMenuItem;
    N14: TMenuItem;
    Enabledstyle1: TMenuItem;
    N15: TMenuItem;
    Showpriority1: TMenuItem;
    Images1: TMenuItem;
    Videos1: TMenuItem;
    Panel1: TPanel;
    Image2: TImage;
    PageControl3: TPageControl;
    VideoSheet: TTabSheet;
    VideoBox: TPanel;
    CoverSheet: TTabSheet;
    Image1: TImage;
    TabControl: TTabControl;
    DosMainList: TListBox;
    N6: TMenuItem;
    Scangamesinthistab1: TMenuItem;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DosMainListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Install1Click(Sender: TObject);
    procedure CheckforUpdate1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DosMainListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormPaint(Sender: TObject);
    procedure ListMenuPopup(Sender: TObject);
    procedure FindEditChange(Sender: TObject);
    procedure FindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FindEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TrayIconClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure none1Click(Sender: TObject);
    procedure Minimize1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VideoEndTimerTimer(Sender: TObject);
    procedure VideoBoxClick(Sender: TObject);
    procedure MinButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure NotesBoxContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure DosMainListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DosMainListDblClick(Sender: TObject);
    procedure TimerOnClickTimer(Sender: TObject);
    procedure DosMainListClick(Sender: TObject);
    procedure ATabChangeExecute(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure AFullScreenExecute(Sender: TObject);
    procedure ADblClickonListBoxExecute(Sender: TObject);
    procedure AVolDownExecute(Sender: TObject);
    procedure AVolUPExecute(Sender: TObject);
    procedure DosMainListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure APlayPauseExecute(Sender: TObject);
    procedure Addtofavorit1Click(Sender: TObject);
    procedure Selectedgame1Click(Sender: TObject);
    procedure Createdesktoptabshortcut1Click(Sender: TObject);
    procedure Enabledstyle1Click(Sender: TObject);
    procedure AManualViewExecute(Sender: TObject);
    procedure MainSplitterMoved(Sender: TObject);
    procedure Images1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure Scangamesinthistab1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    IsArrowDown: Boolean;
    function GetFConfig: TMemIniFile;
    function GetFavConfig: TMemIniFile;
    function GetListConfig: TMemIniFile;
    procedure RegIni(Write: Boolean; FirstRun: Boolean);
    procedure OnMinimize(Sender: TObject);
    procedure OnRestore(Sender: TObject);
    procedure ExtrasMenuClick(Sender: TObject);
    procedure PlayVideoOnClick;
    procedure WMSize(var Msg: TMessage); message WM_SIZE; //for mfplayer
    procedure MyExcept(Sender:TObject; E:Exception);
  public
    { Public declarations }
    FConfig: TMemIniFile;
    FavConfig: TMemIniFile;
    ListConfig: TMemIniFile;
    PictureGamePlay,PictureTitleScrn, ManualXml: String;
  end;

var
  MainForm: TMainForm;
  OnTray: Integer;
  AClose: Boolean = false;
  DosList: TStringList;
  DosPath: TStringList;
  FindList: TStringList;
  TabsList: TStringList;
  ExtrassList: TStringList;
  AppHandle: HWND;
  isFullScreen: Boolean = False;
  GetNotesMemo: String = '';
  isStyled: Boolean = True;
  TempPicture: TPicture;
  ImageForIni1, ImageForIni2: String;
  Priority: Integer = 1;


implementation

{$R *.dfm}

uses utils, mf, ScreenImageUnit;

procedure TMainForm.MyExcept(Sender:TObject; E:Exception);
begin
  If E is Exception then
    Exit
  else
    Exit
end;

//procedure/functions//////////////////////////////////////////////////////////

function SetCaption: String;
begin
with MainForm do
 begin
  if TabControl.TabIndex <> -1 then
  begin
   if DosMainList.Items.Count <> -1 then
   begin
    Result :='Selected game : ['+IntToStr(DosMainList.ItemIndex+1)+' from '+IntToStr(DosMainList.Items.Count)+']';
   end else
    Result := 'Selected game : ['+IntToStr(0)+' from '+IntToStr(DosMainList.Items.Count)+']';
  end;
  end;
end;

procedure ExtrasFileAdd(AMenu: TMenuItem);
var
  i: Integer;
  MenuItem: TMenuItem;
  MainDir, PathDir: String;
begin
with MainForm do
if DosMainList.Items.Count <> -1 then
 begin
  ExtrassList.Clear;
  AMenu.Clear;
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   begin
    PathDir := GetExecDir + ExtractFileDir(FavConfig.ReadString('Favorit',DosMainList.Items[DosMainList.ItemIndex],''));
   end else
   begin
    PathDir := GetExecDir + ExtractFileDir(ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex],''));
   end;

  SetCurrentDir(IncludeTrailingPathDelimiter(PathDir)+'Extras');
  MainDir := IncludeTrailingPathDelimiter(PathDir)+'Extras';

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

procedure PauseVideoByTimer; //stop video after 1,5 sec
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
  VideoPath, VideoDir: String;
begin
//daca nu este se opreste video precedent
VideoEndTimer.Enabled := False;
MFStop;
PageControl3.ActivePageIndex := 1;

if DosMainList.ItemIndex <> -1 then
begin
 if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   VideoDir := FavConfig.ReadString('Video',DosMainList.Items[DosMainList.ItemIndex],'')
 else
   VideoDir := FConfig.ReadString('Video',TabControl.Tabs[TabControl.TabIndex],'');

 SetCurrentDir(GetExecDir);
 if DirectoryExists(GetExecDir+VideoDir) then
   begin
    Videos := TDirectory.GetFiles(GetExecDir+VideoDir, DosMainList.Items[DosMainList.ItemIndex]+'*', TSearchOption.soAllDirectories);
    for VideoPath in Videos do //se porneste video
     if MFPlay(AppHandle, VideoPath) then
     begin
      MFPaint(AppHandle);
      PageControl3.ActivePageIndex := 0;
      VideoEndTimer.Enabled := True;
     end;
   end;
 //daca se apasa nu pe item se opreste video curent
 end else
 begin
  VideoEndTimer.Enabled := False;
  MFStop;
  PageControl3.ActivePageIndex := 1;
 end;
end;

procedure ActiveListOnClick;
var
  Imageos: TStringDynArray;
  ImageDir: String;
  I: Integer;
begin
with MainForm do
 begin
 //get favorite tab
 if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
  begin
   if DosMainList.ItemIndex <> -1 then
    begin
     FavConfig.WriteString('ItemPos',TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex]);
     FavConfig.UpdateFile;
     //if extended version
     if PageControl2.Visible = True then
      begin
       if PageControl2.ActivePageIndex = -1 then PageControl2.ActivePageIndex := 0;
       //get notes
       if FavConfig.ValueExists('Notes',DosMainList.Items[DosMainList.ItemIndex]) then
        begin
         FavNotesToStream(DosMainList.Items[DosMainList.ItemIndex],NotesBox,FavConfig,True);
         if FileExists(GetExecDir+FavConfig.ReadString('ImageScrn',DosMainList.Items[DosMainList.ItemIndex],'')) then
          begin
           TempPicture.WICImage.LoadFromFile(GetExecDir+FavConfig.ReadString('ImageScrn',DosMainList.Items[DosMainList.ItemIndex],''));
           Image1.Picture := TempPicture;
          end;
         if FileExists(GetExecDir+FavConfig.ReadString('ImageTitle',DosMainList.Items[DosMainList.ItemIndex],'')) then
          begin
           TempPicture.WICImage.LoadFromFile(GetExecDir+FavConfig.ReadString('ImageTitle',DosMainList.Items[DosMainList.ItemIndex],''));
           Image2.Picture := TempPicture;
          end;
        end;
      end;
    end else PageControl2.ActivePageIndex := -1;
  end else //all tabs
  if TabControl.TabIndex <> -1 then
  if DosMainList.ItemIndex <> -1 then
   begin
    FConfig.WriteString('ItemPos',TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex]);
    FConfig.UpdateFile;
    //if extended version
    if PageControl2.Visible = True then
     begin
      if PageControl2.ActivePageIndex = -1 then PageControl2.ActivePageIndex := 0;
      //get notes
      NotesBox.Lines.Text := GetNotes(DosMainList.Items[DosMainList.ItemIndex], GetNotesMemo);
      //get PictureGamePlay
      if DirectoryExists(GetExecDir+ExtractFileDir(StringReplace(StringReplace(PictureGamePlay,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll]))) then
       begin
        Imageos := TDirectory.GetFiles(GetExecDir+ExtractFileDir(StringReplace(StringReplace(PictureGamePlay,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll])), ExtractFileName(StringReplace(GetExecDir+StringReplace(PictureGamePlay,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll])), TSearchOption.soAllDirectories);
        for ImageDir in Imageos do
        if FileExists(ImageDir) then
         begin
          TempPicture.WICImage.LoadFromFile(ImageDir);
          Image1.Picture := TempPicture;
          ImageForIni1 := ImageDir;
         end;
        end;
        // get PictureTitleScrn
        if DirectoryExists(GetExecDir+ExtractFileDir(StringReplace(StringReplace(PictureTitleScrn,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll]))) then
         begin
          Imageos := TDirectory.GetFiles(GetExecDir+ExtractFileDir(StringReplace(StringReplace(PictureTitleScrn,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll])), ExtractFileName(StringReplace(GetExecDir+StringReplace(PictureTitleScrn,'/','\',[rfReplaceAll]), '&amp;', '&', [rfReplaceAll])), TSearchOption.soAllDirectories);
          for ImageDir in Imageos do
          if FileExists(ImageDir) then
          begin
           TempPicture.WICImage.LoadFromFile(ImageDir);
           Image2.Picture := TempPicture;
           ImageForIni2 := ImageDir;
          end;
         end;
      end;
    end else PageControl2.ActivePageIndex := -1;

  if ManualXml = '' then Manual1.Enabled := False else Manual1.Enabled := True;
  MainForm.Caption := SetCaption;
  TrayIcon.Hint := MainForm.Caption;
  SysLabel.Caption := MainForm.Caption;
  if FConfig.ReadInteger('General','Priority',0) = 1 then PlayVideoOnClick;
 end;
end;

procedure MainListDblClick;
var
  ListBox: TListBox;
  PathDir: String;
begin
with MainForm do
begin
if DosMainList.ItemIndex <> -1 then
 begin
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
  PathDir := GetExecDir + FavConfig.ReadString('Favorit',DosMainList.Items[DosMainList.ItemIndex],'') else
  PathDir := GetExecDir + ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex],'');
  SetCurrentDir(ExtractFilePath(PathDir));
  if RunApplication(PathDir, '') = True then PauseVideoByTimer;
 end;
end;
end;

procedure LoadPlaylists(List: TComboBox);
begin
with MainForm do
 begin
  List.Items.Clear;
  FConfig.ReadSection(TabControl.Tabs[TabControl.TabIndex], List.Items);
  List.Items.Insert(0,'All games');
  List.ItemIndex := 0;
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

function TMainForm.GetFavConfig: TMemIniFile;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  if FavConfig = nil then
  FavConfig := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+'favorite.ini',TEncoding.UTF8);
  Result := FavConfig;
end;

function TMainForm.GetListConfig: TMemIniFile;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  if ListConfig = nil then
  ListConfig := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+'list.ini',TEncoding.UTF8);
  Result := ListConfig;
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
   FConfig.WriteString('Tabs','DOS','eXo\eXoDOS\!dos');
   FConfig.WriteString('Tabs','Win3x','eXo\eXoWin3x\!win3x');
   FConfig.WriteString('xml','DOS','µlauncher\MS-DOS.xml');
   FConfig.WriteString('xml','Win3x','µlauncher\Windows 3x.xml');
   FConfig.WriteString('Video','DOS','Videos\MS-DOS\Recordings');
   FConfig.WriteString('Video','Win3x','Videos\Windows 3x\Recordings');
   FConfig.WriteString('DOS','eXoDOS 3dfx Games','Data\Playlists\eXoDOS 3dfx Games.xml');
   FConfig.WriteString('DOS','eXoDOS Games with CGA Composite','Data\Playlists\eXoDOS Games with CGA Composite.xml');
   FConfig.WriteString('DOS','eXoDOS Games with Gravis Ultrasound','Data\Playlists\eXoDOS Games with Gravis Ultrasound.xml');
   FConfig.WriteString('DOS','eXoDOS Games with MT-32','Data\Playlists\eXoDOS Games with MT-32.xml');
   FConfig.WriteString('DOS','eXoDOS Games with Sound Canvas','Data\Playlists\eXoDOS Games with Sound Canvas.xml');
   FConfig.WriteString('DOS','eXoDOS Remote Multiplayer','Data\Playlists\eXoDOS Remote Multiplayer.xml');
   FConfig.WriteInteger('General','Top',Top);
   FConfig.WriteInteger('General','Left',Left);
   FConfig.WriteInteger('General','Width',Width);
   FConfig.WriteInteger('General','Height',Height);
   FConfig.WriteInteger('General','WindowState', 0);
   FConfig.WriteInteger('General','OnTray',0);
   FConfig.WriteInteger('General','Priority',0);
   FConfig.WriteInteger('General','SplitterPosFull',698);
   FConfig.WriteInteger('General','VideoSplitterPosFull',485);
   FConfig.WriteInteger('General','SplitterPosNormal',506);
   FConfig.WriteInteger('General','VideoSplitterPosNormal',369);
   FConfig.WriteFloat('General','Volume',1);
   FConfig.WriteBool('General','FullScreen',False);
   FConfig.WriteBool('General','isStyled',True);
   FConfig.UpdateFile;
  end;
 end;
GetFConfig;
if Write = true then
 begin
  FConfig.WriteBool('General','FullScreen',FullScreenonstartup1.Checked);
  if FullScreenonstartup1.Checked = False then
  if isFullScreen = False then
  if WindowState = wsNormal then
   begin
    FConfig.WriteInteger('General','Top',Top);
    FConfig.WriteInteger('General','Left',Left);
    FConfig.WriteInteger('General','Width',Width);
    FConfig.WriteInteger('General','Height',Height);
   end;
  if WindowState = wsNormal then
  FConfig.WriteInteger('General','WindowState', 0) else
  if WindowState = wsMaximized then
  FConfig.WriteInteger('General','WindowState', 1);
  FConfig.WriteInteger('General','OnTray',OnTray);
  FConfig.WriteBool('General','isStyled',isStyled);
  FConfig.WriteInteger('General','Priority',Priority);
  if PageControl2.Visible = True then
  begin
   if isFullScreen = True then
   begin
    FConfig.WriteInteger('General','SplitterPosFull',TabControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosFull',NotesBox.Height);
   end else
   begin
    FConfig.WriteInteger('General','SplitterPosNormal',TabControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosNormal',NotesBox.Height);
   end;
  end;
  FConfig.UpdateFile;
 end else
 begin
  if FConfig.ReadBool('General','isStyled',True) = True then
  TStyleManager.TrySetStyle('Windows10 Blue', False)
  else
  TStyleManager.TrySetStyle('Windows', False);

  FullScreenonstartup1.Checked := FConfig.ReadBool('General','FullScreen',False);
  if FullScreenonstartup1.Checked = False then
  begin
   if FConfig.ReadInteger('General','WindowState', 0) = 0 then WindowState := wsNormal else
   if FConfig.ReadInteger('General','WindowState', 0) = 1 then WindowState := wsMaximized;
   if WindowState = wsNormal then
   begin
    Top := FConfig.ReadInteger('General','Top',Top);
    Left := FConfig.ReadInteger('General','Left',Left);
    Width := FConfig.ReadInteger('General','Width',Width);
    Height := FConfig.ReadInteger('General','Height',Height);
   end;
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
  isStyled := FConfig.ReadBool('General','isStyled',True);
  Priority := FConfig.ReadInteger('General','Priority',0);
  if isFullScreen = True then
   begin
    TabControl.Width := FConfig.ReadInteger('General','SplitterPosFull',TabControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosFull',NotesBox.Height);
   end else
   begin
    TabControl.Width := FConfig.ReadInteger('General','SplitterPosNormal',TabControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosNormal',NotesBox.Height);
   end;
 //load tabs
 FConfig.ReadSection('Tabs', TabControl.Tabs);
 TabControl.Tabs.Add('Favorite');
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
if PageControl2.Visible = True then
if MFIfStoping = False then PauseVideoByTimer;
end;

procedure TMainForm.OnRestore(Sender: TObject);
begin
if isFullScreen = True then
 begin
  ShowWindow(Handle, SW_RESTORE);
  ShowWindow(Handle, SW_SHOWMAXIMIZED);
 end else
 begin
  if not ShowWindow(Handle, SW_SHOW) then
  begin
   ShowWindow(Handle, SW_RESTORE);
   ShowWindow(Handle, SW_SHOW);
  end else SetForegroundWindow(Handle);
 end;
SysPanel.Visible := isFullScreen;
SysLabel.Visible := isFullScreen;
SetForegroundWindow(Handle);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
SetCurrentDir(ExtractFilePath(Application.ExeName));
if not FileExists(ExtractFilePath(Application.ExeName)+'config.ini') then
 begin
  Position := poDesktopCenter;
  RegIni(False, True);
 end else
 begin
  Position := poDefaultPosOnly;
 end;

RegIni(False, False);
GetFavConfig;
GetListConfig;

if FConfig.ReadBool('General','isStyled',True) = True then
begin
if LoadResourceFontByID(1, 'MYFONT') then
 begin
   MainForm.ParentFont := False;
   MainForm.Font.Size := 8;
   MainForm.Font.Name := 'Modern DOS 8x16';
   MainForm.Caption := 'Welcome to µlauncher, please select your favorite tab';

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
   NotesBox.BorderStyle := bsNone;

   FindEdit.ParentFont := False;
   FindEdit.Font.Size := 12;
   FindEdit.Font.Name := 'Modern DOS 8x16';
   FindEdit.ParentColor := True;
   FindEdit.Color := clBlack;
   FindEdit.Font.Color := clWhite;
   FindEdit.BorderStyle := bsNone;
   FindEdit.Enabled := False;

   DosMainList.BorderStyle := bsNone;
   DosMainList.ParentFont := False;
   DosMainList.Font.Size := 12;
   DosMainList.Font.Name := 'Modern DOS 8x16';
   DosMainList.ParentColor := True;
   DosMainList.Color := $00AA0000;
   DosMainList.Font.Color := $00FFFF55;
   DosMainList.Style := lbOwnerDrawFixed;

   ComboBox1.ParentFont := False;
   ComboBox1.Font.Size := 12;
   ComboBox1.Font.Name := 'Modern DOS 8x16';
   ComboBox1.ParentColor := True;
   ComboBox1.Color := $00AA0000;
   ComboBox1.Font.Color := $00FFFF55;
   ComboBox1.Style := csOwnerDrawFixed;

   TabControl.ParentFont := False;
   TabControl.Font.Size := 12;
   TabControl.Font.Name := 'Modern DOS 8x16';
   TabControl.TabIndex := -1;
   TabControl.Enabled := True;
 end;
end else
begin
 MainForm.Caption := 'Welcome to µlauncher, please select your favorite tab';
 TabControl.TabIndex := -1;
 TabControl.Enabled := True;
 cmdlabel.Caption := 'c:\eXo>find ';
 FindEdit.BorderStyle := bsSingle;
 FindEdit.Enabled := False;
 DosMainList.BorderStyle := bsSingle;
 DosMainList.Style := lbStandard;
 DosMainList.Font.Size := 10;
 ComboBox1.Style := csDropDownList;
 ComboBox1.Font.Size := 10;
 NotesBox.BorderStyle := bsSingle;
 NotesBox.Font.Size := 10;
 FindEdit.Font.Size := 10;
 SysLabel.Font.Size := 10;
end;
ActiveControl := nil;
PageControl2.ActivePage := nil;

DosList := TStringList.Create;
DosPath := TStringList.Create;
FindList := TStringList.Create;
TabsList := TStringList.Create;
ExtrassList := TStringList.Create;
TempPicture := TPicture.Create;
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
FavConfig.Free;
ListConfig.Free;
DosList.Free;
DosPath.Free;
FindList.Free;
TabsList.Free;
ExtrassList.Free;
TempPicture.Free;
if PageControl2.Visible = True then MfDestroy;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
if FConfig.ReadBool('General','isStyled',True) = True then
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
 end;

//MFVideo
if PageControl2.Visible = True then MFPaint(AppHandle);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
MainPanel.SetBounds(10,10,ClientWidth -20, ClientHeight -44);
cmdlabel.SetBounds(8,ClientHeight -20, cmdlabel.Width, cmdlabel.Height);
//change findedit.top
if FConfig.ReadBool('General','isStyled',True) = True then
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18) else
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -22, ClientWidth -cmdlabel.Width-12, 18);
if isFullScreen = True then
 begin
  SysPanel.SetBounds(PageControl2.Left,1,PageControl2.Width, SysPanel.Height);
  CloseButton.Left := SysPanel.Width - 24;
  MinButton.Left := SysPanel.Width - 50;
  SysLabel.SetBounds(2,0, SysPanel.Width-100, SysLabel.Height);
 end;
PageControl3.Width := NotesBox.Width div 2;
Repaint;
end;

//TListMenu////////////////////////////////////////////////////////////////////

procedure TMainForm.ListMenuPopup(Sender: TObject);
var
  ManualPath: String;
begin
Showpriority1.Items[Priority].Checked := True;

Enabledstyle1.Checked := FConfig.ReadBool('General','isStyled',True);

if TabControl.TabIndex <> -1 then
if DosMainList.ItemIndex <> -1 then
 begin
  //add Aditional to menu
  ExtrasFileAdd(Extras1);
  //if exists game in favorit then caption change
  if FavConfig.ValueExists('Favorit',DosMainList.Items[DosMainList.ItemIndex]) then
  Addtofavorit1.Caption := 'Remove form favorite' else Addtofavorit1.Caption := 'Add to favorite';
 end;

//not scanning if the favorit tab
if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
  Scangamesinthistab1.Enabled := False else Scangamesinthistab1.Enabled := True;
  
//Tray options
SystemTray1.Items[OnTray].Checked := True;
end;

procedure TMainForm.Image1Click(Sender: TObject);
begin
with ScreenImageForm do
 begin
  Image1.Picture.WICImage := (Sender as TImage).Picture.WICImage;
  Show;
 end;
end;

procedure TMainForm.Images1Click(Sender: TObject);
begin
Priority := (Sender as TMenuItem).MenuIndex;
FConfig.WriteInteger('General','Priority',Priority);
FConfig.UpdateFile;
end;

procedure TMainForm.Install1Click(Sender: TObject);
var
  InstallFileDir: String;
begin
if TabControl.TabIndex <> -1 then
 if DosMainList.ItemIndex <> -1 then
  begin
   if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   InstallFileDir := GetExecDir + FavConfig.ReadString('Favorit',DosMainList.Items[DosMainList.ItemIndex],'') else
   InstallFileDir := GetExecDir + ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex],'');
   SetCurrentDir(ExtractFilePath(InstallFileDir));
   if RunApplication(ExtractFilePath(InstallFileDir) + 'install.bat', '') = True then PauseVideoByTimer;
  end;
end;

procedure TMainForm.CheckforUpdate1Click(Sender: TObject);
begin
if DosMainList.ItemIndex <> -1 then
 begin
   SetCurrentDir(GetExecDir+'eXo\Update');
   if RunApplication(GetExecDir+'eXo\Update\update.bat','') = True then PauseVideoByTimer;
 end;
end;

procedure TMainForm.Enabledstyle1Click(Sender: TObject);
begin
isStyled := not isStyled;
ShowMessage('Need to restart application!');
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
  if RunApplication(CaptionReplace,'') = True then PauseVideoByTimer;
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

procedure TMainForm.Addtofavorit1Click(Sender: TObject);
begin
if not FavConfig.ValueExists('Favorit',DosMainList.Items[DosMainList.ItemIndex]) then
 begin
  FavConfig.WriteString('Favorit',DosMainList.Items[DosMainList.ItemIndex],ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex],''));
  FavNotesToStream(DosMainList.Items[DosMainList.ItemIndex],NotesBox,FavConfig,False);
  FavConfig.WriteString('ImageScrn',DosMainList.Items[DosMainList.ItemIndex],StringReplace(ImageForIni1,GetExecDir,'',[rfReplaceAll]));
  FavConfig.WriteString('ImageTitle',DosMainList.Items[DosMainList.ItemIndex],StringReplace(ImageForIni2,GetExecDir,'',[rfReplaceAll]));
  FavConfig.WriteString('Video',DosMainList.Items[DosMainList.ItemIndex],FConfig.ReadString('Video',TabControl.Tabs[TabControl.TabIndex],''));
  FavConfig.WriteString('Manual',DosMainList.Items[DosMainList.ItemIndex],ManualXml);
 end else
 begin
  FavConfig.DeleteKey('Favorit',DosMainList.Items[DosMainList.ItemIndex]);
  FavConfig.DeleteKey('Notes',DosMainList.Items[DosMainList.ItemIndex]);
  FavConfig.DeleteKey('ImageScrn',DosMainList.Items[DosMainList.ItemIndex]);
  FavConfig.DeleteKey('ImageTitle',DosMainList.Items[DosMainList.ItemIndex]);
  FavConfig.DeleteKey('Video',DosMainList.Items[DosMainList.ItemIndex]);
  FavConfig.DeleteKey('Manual',DosMainList.Items[DosMainList.ItemIndex]);
   //daca este selectat joaca in list in alt tab
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   begin
    DosMainList.Items.Delete(FindListBoxString(DosMainList,DosMainList.Items[DosMainList.ItemIndex]));
    if DosMainList.Items.Count = -1 then
     begin
      DosMainList.ItemIndex := 0;
      DosMainListClick(Sender);
     end else
     begin
      DosMainList.ItemIndex := -1;
      DosMainListClick(Sender);
     end;
   end;
 end;
FavConfig.UpdateFile;
end;

procedure TMainForm.Selectedgame1Click(Sender: TObject);
var
  TargetName: String;
begin
if DosMainList.ItemIndex <> -1 then
 begin
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   TargetName := GetExecDir + FavConfig.ReadString('Favorit',DosMainList.Items[DosMainList.ItemIndex],'')
   else
   TargetName := GetExecDir + ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[DosMainList.ItemIndex],'');
  if CreateDesktopShellLink(GetDesktopFolder, TargetName) then ShowMessage('Link has been created ...');
 end;
end;

procedure TMainForm.Createdesktoptabshortcut1Click(Sender: TObject);
var
  NewDir: String;
  i: Integer;
begin
if DosMainList.Items.Count <> -1 then
for i := 0 to DosMainList.Items.Count-1 do
 begin
  NewDir := GetDesktopFolder +'\'+TabControl.Tabs[TabControl.TabIndex];
  CreateDir(NewDir);
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
  CreateDesktopShellLink(NewDir + '\', GetExecDir + FavConfig.ReadString('Favorit',DosMainList.Items[I],''))
  else
  CreateDesktopShellLink(NewDir + '\', GetExecDir + ListConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items[I],''));
 end;
end;

procedure TMainForm.Scangamesinthistab1Click(Sender: TObject);
var
  I: Integer;
begin
if MessageDlg('Do you really want to scan games?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
   //clear
   DosList.Clear;
   DosPath.Clear;
   DosMainList.Items.Clear;
   if ListConfig.SectionExists(TabControl.Tabs[TabControl.TabIndex]) then
      ListConfig.EraseSection(TabControl.Tabs[TabControl.TabIndex]);
   //preparation for scan
   if MainForm.Caption <> 'Please wait...' then
   begin
    MainForm.Caption := 'Please wait...';
    TrayIcon.Hint := MainForm.Caption;
    SysLabel.Caption := MainForm.Caption;
    TabControl.Enabled := False;
    FindEdit.Text := '';
    FindEdit.Enabled := False;
    cmdlabel.Caption := 'c:\eXo>find ';
    if PageControl2.Visible = True then
     begin
      if PageControl3.ActivePageIndex = 0 then
       begin
        VideoEndTimer.Enabled := False;
        MfStop;
        PageControl3.ActivePageIndex := 1;
       end else PageControl3.ActivePageIndex := 1;
       PageControl2.ActivePage := nil;
     end;
   end;
   //if not exists or exists
   FConfig.ReadSection('Tabs',TabsList);
   if not (ExistsGameDir(FConfig.ReadString('Tabs',TabControl.Tabs[TabControl.TabIndex],''))) then
   begin
    ShowMessage('Sorry, not found ' +TabControl.Tabs[TabControl.TabIndex]+ ' Collection folder');
    TabControl.Enabled := True;
   end else
   begin
   //find
   FindFilePattern(GetExecDir+FConfig.ReadString('Tabs',TabControl.Tabs[TabControl.TabIndex],''), '*.bat', DosList, DosPath);
    for I := 0 to DosList.Count-1 do
     begin
      ListConfig.WriteString(TabControl.Tabs[TabControl.TabIndex],DosList[I],StringReplace(DosPath[I],GetExecDir,'',[rfReplaceAll]));
     end;
   ListConfig.UpdateFile;
   ListConfig.ReadSection(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items);
   GetNotesMemo := Utf8ToString(GetNotesList(GetExecDir+FConfig.ReadString('xml',TabControl.Tabs[TabControl.TabIndex],'')));
   end;

   //find item position
   if DosMainList.Items.Count <> -1 then
   if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
   DosMainList.ItemIndex := FindListBoxString(DosMainList,FavConfig.ReadString('ItemPos',TabControl.Tabs[TabControl.TabIndex],''))
   else
   DosMainList.ItemIndex := FindListBoxString(DosMainList,FConfig.ReadString('ItemPos',TabControl.Tabs[TabControl.TabIndex],''));
   //final
   MainForm.Caption := SetCaption;
   TrayIcon.Hint := MainForm.Caption;
   SysLabel.Caption := MainForm.Caption;
   cmdlabel.Caption := 'c:\eXo\'+TabControl.Tabs[TabControl.TabIndex] + '>find ';
   FindEdit.Text := '';
   FindEdit.Enabled := True;
   //change findedit.top
   if FConfig.ReadBool('General','isStyled',True) = True then
   FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18) else
   FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -22, ClientWidth -cmdlabel.Width-12, 18);
   TabControl.Enabled := True;
   DosMainListClick(Sender);
 end;
end;

//Other controls///////////////////////////////////////////////////////////////

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
OnRestore(Sender);
end;

procedure TMainForm.DosMainListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if TabControl.TabIndex <> -1 then
begin
if Sender is TListBox then
(Sender as TListBox).ItemIndex:=TListBox(Sender).ItemIndex;

with (Sender as TListBox) do ItemIndex := ItemAtPos(Point(X, Y), True);

if Button = mbRight then
if (Sender as TListBox).ItemIndex <> -1 then
 begin
  Open1.Enabled := True;
  Aditional1.Enabled := True;
  Install1.Enabled := True;
  SelectedGame1.Enabled := True;
  Extras1.Enabled := True;
  Addtofavorit1.Enabled := True;
  CheckforUpdate1.Enabled := ExistsGameDir(FConfig.ReadString('Tabs','DOS',''));
  FullScreen1.Checked := isFullScreen;
  DosMainListClick(Sender);
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end else
 begin
  Open1.Enabled := False;
  Aditional1.Enabled := True;
  SelectedGame1.Enabled := False;
  Install1.Enabled := False;
  Extras1.Enabled := False;
  Addtofavorit1.Enabled := False;
  CheckforUpdate1.Enabled := ExistsGameDir(FConfig.ReadString('Tabs','DOS',''));
  FullScreen1.Checked := isFullScreen;
  DosMainListClick(Sender);
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end;
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
if FConfig.ReadBool('General','isStyled',True) = True then
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
if (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT)
or (Key=VK_HOME) or (Key=VK_END)or (Key=VK_PRIOR)or (Key=VK_NEXT) then IsArrowDown := True;
end;

procedure TMainForm.DosMainListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_LEFT) or (Key=VK_RIGHT)
or (Key=VK_HOME) or (Key=VK_END)or (Key=VK_PRIOR)or (Key=VK_NEXT) then IsArrowDown := False;
end;

procedure TMainForm.FindEditChange(Sender: TObject);
begin
if TabControl.TabIndex <> -1 then
begin
if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
 begin
  DosMainList.Items.Clear;
  FavConfig.ReadSection('Favorit',FindList);
  FindListIndex(FindEdit.Text, DosMainList, FindList);
 end else
begin
 DosMainList.Items.Clear;
 if ComboBox1.Items[ComboBox1.ItemIndex] = 'All games' then
  begin
   ListConfig.ReadSection(TabControl.Tabs[TabControl.TabIndex],FindList);
   FindListIndex(FindEdit.Text, DosMainList, FindList);
  end else FindListIndex(FindEdit.Text, DosMainList, DosList);
end;

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
APlayPauseExecute(Sender);
end;

procedure TMainForm.TimerOnClickTimer(Sender: TObject);
begin
TimerOnClick.Enabled := False;
ActiveListOnClick;
end;

procedure TMainForm.MainSplitterMoved(Sender: TObject);
begin
PageControl3.Width := NotesBox.Width div 2;
if isFullScreen = True then
 begin
  SysPanel.SetBounds(PageControl2.Left,1,PageControl2.Width, SysPanel.Height);
  CloseButton.Left := SysPanel.Width - 24;
  MinButton.Left := SysPanel.Width - 50;
  SysLabel.SetBounds(2,0, SysPanel.Width-100, SysLabel.Height);
 end;
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
if TabControl.tabIndex > 0 then
  TabControl.TabIndex := TabControl.tabIndex - 1
 else
  TabControl.TabIndex := TabControl.tabs.Count - 1
 //end if
 else
  if TabControl.tabIndex < TabControl.Tabs.Count - 1 then
     TabControl.TabIndex := TabControl.tabIndex + 1
  else
     TabControl.TabIndex := 0;
  //end if
  //end if
  FocusControl(TabControl);
  TabControl.OnChange(self);
end;

procedure TMainForm.AAboutExecute(Sender: TObject);
begin
MessageBox(Handle,'µlauncher' +
                  #10 + #10 +
                  'Link : github.com/gorbatiiivan/µlauncher'+
                  #10 + #10 +
                  'Compatible with only eXo collections' +
                  #10 + #10 +
                  '-- Keyboard shortcuts --' +
                  #10 +
                  #10 + 'Main shortcuts:' +
                  #10 + '1. Ctrl+Down      | Volume Down' +
                  #10 + '2. Ctrl+Up        | Volume UP' +
                  #10 + '3. Pause          | Play/Pause video' +
                  #10 + '4. Enter          | Run select game'+
                  #10 + '5. F11            | FullScreen'+
                  #10 + '6. Ctrl+TAB       | Tab change'+
                  #10 + '7. F3             | View manual'+
                  #10 +
                  #10 + 'Focus on find:'+
                  #10 + 'Escape            | Clear find items'+
                  #10 + ''+
                  #10 + 'Video:'+
                  #10 + 'Press on the item in the list for replay video'+
                  #10 + 'Press one click on the video to pause video'
                  ,'About / Help',0);
end;

procedure TMainForm.AFullScreenExecute(Sender: TObject);
begin
if isFullScreen = False then
 begin
  isFullScreen := True;
  if WindowState = wsNormal then FConfig.WriteInteger('General','WindowState', 0) else
  if WindowState = wsMaximized then FConfig.WriteInteger('General','WindowState', 1);
  if WindowState = wsNormal then
  begin
   FConfig.WriteInteger('General','Top',Top);
   FConfig.WriteInteger('General','Left',Left);
   FConfig.WriteInteger('General','Width',Width);
   FConfig.WriteInteger('General','Height',Height);
  end;
  MainForm.BorderStyle := bsNone;
  ShowWindow(Handle, SW_RESTORE);
  ShowWindow(Handle, SW_SHOWMAXIMIZED);
  SysPanel.Visible := True;
  SysLabel.Visible := True;
  if PageControl2.Visible = True then
   begin
    FConfig.WriteInteger('General','SplitterPosNormal',TabControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosNormal',NotesBox.Height);
    TabControl.Width := FConfig.ReadInteger('General','SplitterPosFull',TabControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosFull',NotesBox.Height);
   end;
  FConfig.UpdateFile;
 end else
 begin
  isFullScreen := False;
  MainForm.BorderStyle := bsSizeable;
  if FConfig.ReadInteger('General','WindowState', 0) = 0 then
   begin
    ShowWindow(Handle, SW_RESTORE);
    ShowWindow(Handle, SW_NORMAL);
   end else
  if FConfig.ReadInteger('General','WindowState', 0) = 1 then
   begin
    ShowWindow(Handle, SW_RESTORE);
    ShowWindow(Handle, SW_SHOWMAXIMIZED);
   end;
  SysPanel.Visible := False;
  SysLabel.Visible := False;
  if WindowState = wsNormal then
  begin
   Top := FConfig.ReadInteger('General','Top',Top);
   Left := FConfig.ReadInteger('General','Left',Left);
   Width := FConfig.ReadInteger('General','Width',Width);
   Height := FConfig.ReadInteger('General','Height',Height);
  end;
  if PageControl2.Visible = True then
   begin
    FConfig.WriteInteger('General','SplitterPosFull',TabControl.Width);
    FConfig.WriteInteger('General','VideoSplitterPosFull',NotesBox.Height);
    TabControl.Width := FConfig.ReadInteger('General','SplitterPosNormal',TabControl.Width);
    NotesBox.Height := FConfig.ReadInteger('General','VideoSplitterPosNormal',NotesBox.Height);
   end;
 end;
 FConfig.UpdateFile;
 MainSplitterMoved(Sender);
end;

procedure TMainForm.AManualViewExecute(Sender: TObject);
var
  ManualPath: String;
begin
if DosMainList.ItemIndex <> -1 then
 begin
  if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
  ManualPath := FavConfig.ReadString('Manual',DosMainList.Items[DosMainList.ItemIndex],'')
  else
  ManualPath := StringReplace(ManualXml,'&amp;', '&',[rfReplaceAll]);

  SetCurrentDir(GetExecDir);
  if RunApplication(GetExecDir + ManualPath,'') = True then PauseVideoByTimer;
 end;
end;

procedure TMainForm.APlayPauseExecute(Sender: TObject);
begin
if PageControl2.ActivePageIndex = 0 then
if MFIfStoping = False then MFPause else PlayVideoOnClick;
end;

procedure TMainForm.ADblClickonListBoxExecute(Sender: TObject);
begin
if ScreenImageForm.Showing = True then ScreenImageForm.Close
else
if TabControl.TabIndex <> -1 then MainListDblClick;
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

procedure TMainForm.ComboBox1Change(Sender: TObject);
var
  i: Integer;
  List1, List2: TStringList;
begin
if TabControl.Tabs[TabControl.TabIndex] <> 'Favorite' then
if ComboBox1.Items[ComboBox1.ItemIndex] = 'All games' then
   ListConfig.ReadSection(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items) else
 begin
  List1 := TStringList.Create;
  List2 := TStringList.Create;
   try
    List1.LoadFromFile(GetExecDir + FConfig.ReadString(TabControl.Tabs[TabControl.TabIndex],ComboBox1.Items[ComboBox1.ItemIndex],''));
    FindListIndex2('<GameFileName>', List2, List1);
    for i := 0 to List2.Count-1 do
     List2[I] := ChangeFileExt(StrCut(List2[i],List2[i],'<GameFileName>','</GameFileName>'),'');
     FindList.Assign(List2);
     DosMainList.Items.Assign(List2);
     DosList.Assign(List2);
    finally
     List1.Free;
     List2.Free;
   end;
 end;
ActiveControl := DosMainList;
FindEdit.Text := '';
DosMainListClick(Sender);
if DosMainList.Items.Count = -1 then
   DosMainList.Selected[-1] := False else DosMainList.Selected[0] := True;
end;

procedure TMainForm.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
if FConfig.ReadBool('General','isStyled',True) = True then
with (Control as TComboBox).Canvas do
  begin
    if odSelected in State then
    begin
      Brush.Color := $00AAAA00;
      Font.Color := clBlack;
    end;

    FillRect(Rect);
    TextOut(Rect.Left+4, Rect.Top, (Control as TComboBox).Items[Index]);
    if odFocused In State then
     begin
      Brush.Color := (Control as TComboBox).Color;
      DrawFocusRect(Rect);
     end;
  end;
end;

procedure TMainForm.TabControlChange(Sender: TObject);
var
  I: Integer;
begin
//daca este selectat favorit
if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
 begin
  DosMainList.Items.Clear;
  FavConfig.ReadSection('Favorit',DosMainList.Items);
 end else
begin
 //daca nu este denumire la tab in ini atunci da la scan
 if not ListConfig.SectionExists(TabControl.Tabs[TabControl.TabIndex]) then
  begin
   Scangamesinthistab1Click(Sender);
  end else
  //daca este atunci doar citeste
  begin
   DosMainList.Items.Clear;
   ListConfig.ReadSection(TabControl.Tabs[TabControl.TabIndex],DosMainList.Items);
   GetNotesMemo := Utf8ToString(GetNotesList(GetExecDir+FConfig.ReadString('xml',TabControl.Tabs[TabControl.TabIndex],'')));
  end;
end;
//load playlists
LoadPlaylists(ComboBox1);
//info
ActiveControl := DosMainList;
if DosMainList.Items.Count <> -1 then
if TabControl.Tabs[TabControl.TabIndex] = 'Favorite' then
DosMainList.ItemIndex := FindListBoxString(DosMainList,FavConfig.ReadString('ItemPos',TabControl.Tabs[TabControl.TabIndex],''))
else
DosMainList.ItemIndex := FindListBoxString(DosMainList,FConfig.ReadString('ItemPos',TabControl.Tabs[TabControl.TabIndex],''));
MainForm.Caption := SetCaption;
TrayIcon.Hint := MainForm.Caption;
SysLabel.Caption := MainForm.Caption;
cmdlabel.Caption := 'c:\eXo\'+TabControl.Tabs[TabControl.TabIndex] + '>find ';
FindEdit.Text := '';
FindEdit.Enabled := True;
//change findedit.top
if FConfig.ReadBool('General','isStyled',True) = True then
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -20, ClientWidth -cmdlabel.Width-12, 18) else
FindEdit.SetBounds(cmdlabel.Left + cmdlabel.Width, ClientHeight -22, ClientWidth -cmdlabel.Width-12, 18);
DosMainListClick(Sender);
end;

end.
