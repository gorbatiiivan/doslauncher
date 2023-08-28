unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IOUtils, Types, StrUtils, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Xml.VerySimple, Vcl.Menus, IniFiles, Vcl.Buttons;

type
  TMainFrm = class(TForm)
    MainPanel: TPanel;
    MediaPanel: TPanel;
    TrayIcon: TTrayIcon;
    TrayMenu: TPopupMenu;
    Close1: TMenuItem;
    N1: TMenuItem;
    ShowHide1: TMenuItem;
    ListMenu: TPopupMenu;
    Run1: TMenuItem;
    N2: TMenuItem;
    Alternativelaunch1: TMenuItem;
    N3: TMenuItem;
    Addtofavorite1: TMenuItem;
    N4: TMenuItem;
    ViewManual1: TMenuItem;
    N5: TMenuItem;
    Aditional1: TMenuItem;
    Setup1: TMenuItem;
    N6: TMenuItem;
    Createtodesktopshortcut1: TMenuItem;
    TimerOnClick: TTimer;
    Panel1: TPanel;
    NoteMemo: TMemo;
    ScreenShotImage: TImage;
    Panel2: TPanel;
    FrontImage: TImage;
    BackImage: TImage;
    InfoPanel: TPanel;
    TitleLabel: TLabel;
    DeveloperLabel: TLabel;
    PublisherLabel: TLabel;
    GenreLabel: TLabel;
    SeriesLabel: TLabel;
    PlayModeLabel: TLabel;
    PlatformLabel: TLabel;
    ReleaseLabel: TLabel;
    LaunchButton1: TButton;
    LaunchButton2: TButton;
    FavButton: TButton;
    ManualButton: TButton;
    ChangeImgButton: TButton;
    PageControl1: TPageControl;
    FavSheet: TTabSheet;
    AllGamesSheet: TTabSheet;
    FavListView: TListView;
    GameListView: TListView;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GameListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormResize(Sender: TObject);
    procedure GameListViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScreenShotImageClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    procedure ViewManual1Click(Sender: TObject);
    procedure ListMenuPopup(Sender: TObject);
    procedure Createtodesktopshortcut1Click(Sender: TObject);
    procedure TimerOnClickTimer(Sender: TObject);
    procedure Addtofavorite1Click(Sender: TObject);
    procedure Alternativelaunch1Click(Sender: TObject);
    procedure ChangeImgButtonClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    Xml: TXmlVerySimple;
    Books: TXmlNodeList;
    FConfig: TMemIniFile;
    IsArrowDown: Boolean;
    function GetFConfig: TMemIniFile;
    procedure RegIni(Write: Boolean; FirstRun: Boolean);
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;
  VirtualImgList: TStringList;

implementation

{$R *.dfm}

uses Utils, FullScreenImage, mf;

function TMainFrm.GetFConfig: TMemIniFile;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  if FConfig = nil then
  FConfig := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini',TEncoding.UTF8);
  Result := FConfig;
end;

procedure TMainFrm.RegIni(Write: Boolean; FirstRun: Boolean);
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
   FConfig.WriteInteger('General','WindowState', 0);
   FConfig.UpdateFile;
  end;
 end;
GetFConfig;
if Write = true then
 begin
  if WindowState = wsNormal then
    FConfig.WriteInteger('General','WindowState', 0) else
  if WindowState = wsMaximized then
    FConfig.WriteInteger('General','WindowState', 1);
  if WindowState = wsNormal then
   begin
    FConfig.WriteInteger('General','Top',Top);
    FConfig.WriteInteger('General','Left',Left);
    FConfig.WriteInteger('General','Width',Width);
    FConfig.WriteInteger('General','Height',Height);
   end;
  FConfig.UpdateFile;
 end else
 begin
  if FConfig.ReadInteger('General','WindowState', 0) = 1 then
  WindowState := wsMaximized else
  if FConfig.ReadInteger('General','WindowState', 0) = 0 then
   begin
    WindowState := wsNormal;
    Top := FConfig.ReadInteger('General','Top',Top);
    Left := FConfig.ReadInteger('General','Left',Left);
    Width := FConfig.ReadInteger('General','Width',Width);
    Height := FConfig.ReadInteger('General','Height',Height);
  end;
 end;
end;

procedure TMainFrm.Close1Click(Sender: TObject);
begin
//exit application
MainFrm.Close;
end;

procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //free
  MFDestroy;
  VirtualImgList.Free;
  Xml.Free;
  Books.Free;
  RegIni(True, False);
  FConfig.Free;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  //get caption
  Caption := ExtractFileName(ChangeFileExt(ParamStr(0),''));
  TrayIcon.Hint := Caption;
  //get visible trayicon
  TrayIcon.Visible := True;
  //write config file
  GetFConfig;
  //read config
  SetCurrentDir(ExtractFilePath(Application.ExeName));
   if not FileExists(ExtractFilePath(Application.ExeName)+'config.ini') then
    begin
     Position := poDesktopCenter;
     RegIni(False, True);
    end else
   begin
    Position := poDesigned;
    RegIni(False, False);
   end;
   //create and load xml
   Xml := TXmlVerySimple.Create;
   AddGameList(GetExecDir+'Data\Platforms\', GameListView, Xml, Books);
   //create virtual image list
   VirtualImgList := TStringList.Create;
   //get PageControl active page
   PageControl1.ActivePageIndex := 1;
end;

procedure TMainFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//run game with enter key
if Key = VK_RETURN then GameListViewDblClick(Sender);
end;

procedure TMainFrm.FormResize(Sender: TObject);
begin
//components resize
Panel1.Width := MainFrm.Width div 2;
Panel2.Height := MainFrm.Width div 3;
MediaPanel.Height := MainFrm.Height div 2;
NoteMemo.Height := MainFrm.Height div 4;
FavListView.Column[0].Width := FavListView.Width -20;
GameListView.Column[0].Width := GameListView.Width -20;
ChangeImgButton.Top := MediaPanel.Height - ChangeImgButton.Height - 4;
ChangeImgButton.Left := MediaPanel.Width - ChangeImgButton.Width - 4;  
ScreenShotImage.Width := MediaPanel.Width div 2;
FrontImage.Width := Panel2.Width div 2;
end;

procedure RunFromDblListView(List: TListView);
var
  PathGame: String;
begin
with MainFrm do
begin
//stop timer
TimerOnClick.Enabled := False;
//run games
if List.ItemIndex <> -1 then
 begin
  PathGame := GetExecDir+List.Selected.SubItems[0];
  SetCurrentDir(ExtractFileDir(PathGame));
  RunApplication(PathGame,'');
 end;
end;
end;

procedure TMainFrm.GameListViewDblClick(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then RunFromDblListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then RunFromDblListView(GameListView);
end;

procedure TMainFrm.GameListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
if Selected = True then
begin
 if IsArrowDown then
  begin
    TimerOnClick.Enabled := False;
    //if priority of image then interval is min
    //if FConfig.ReadInteger('General','Priority',0) = 0 then
    //TimerOnClick.Interval := 125 else TimerOnClick.Interval := 500;
    TimerOnClick.Interval := 125;
    TimerOnClick.Enabled := True;
  end else
  begin
    TimerOnClick.Enabled := False;
    TimerOnClick.Interval := GetDoubleClickTime() + 62;
    {if FConfig.ReadInteger('General','Priority',0) = 0 then
    TimerOnClick.Interval := GetDoubleClickTime() + 62 else
    TimerOnClick.Interval := GetDoubleClickTime() + 250;}
    TimerOnClick.Enabled := True;
  end;
  //make visible buttons on select item
  LaunchButton1.Visible := True;
  LaunchButton2.Visible := True;
  ManualButton.Visible := True;
  FavButton.Visible := True;
  ChangeImgButton.Visible := True;
  //get FavButton Hint
  if not FConfig.SectionExists(Item.Caption) then
  FavButton.Hint := 'Add to favorite' else FavButton.Hint := 'Remove to favorite'; 
end;
end;

procedure SelectListView(List: TListView);
begin
with MainFrm do
 begin
 if List.Selected.Selected = True then
 begin
  //stop timer
  TimerOnClick.Enabled := False;
  //clear images
  ScreenShotImage.Picture := nil;
  FrontImage.Picture := nil;
  BackImage.Picture := nil;
  NoteMemo.Clear;
  //get caption
  Caption := ExtractFileName(ChangeFileExt(ParamStr(0),'')) + ' - Total favorites games : ['+
  IntToStr(List.Items.Count-1) + ']';
  TrayIcon.Hint := Caption;
  //read info, notes, images
  DeveloperLabel.Caption := GetInfo(0, List);
  PublisherLabel.Caption := GetInfo(1, List);
  GenreLabel.Caption := GetInfo(2, List);
  SeriesLabel.Caption := GetInfo(3, List);
  PlayModeLabel.Caption := GetInfo(4, List);
  PlatformLabel.Caption := GetInfo(5, List);
  ReleaseLabel.Caption := GetInfo(6, List);
  TitleLabel.Caption := GetInfo(7, List);
  TitleLabel.Hint := GetInfo(7, List);
  GetInfoNotes(NoteMemo, List);
  GetMultimedia(List, FrontImage, BackImage);
  //GetScreenShotImages
  ChangeImgButtonClick(MainFrm);
 end;
 end;
end;

procedure TMainFrm.TimerOnClickTimer(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then SelectListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then SelectListView(GameListView);
end;

procedure TMainFrm.TrayIconDblClick(Sender: TObject);
begin
//show or hide main form
if not isWindowVisible (Handle) then
  begin
   ShowWindow(Handle, SW_RESTORE);
   ShowWindow(Handle, SW_SHOW);
   SetForegroundWindow(Handle);
  end else
  begin
   ShowWindow(Handle, SW_MINIMIZE);
   ShowWindow(Handle, SW_HIDE);
  end;
end;

procedure TMainFrm.ScreenShotImageClick(Sender: TObject);
begin
//view image to fullscreen
with FullScreenForm do
 begin
  FullScreenImage.Picture.WICImage := (Sender as TImage).Picture.WICImage;
  if (Sender as TImage).Picture.WICImage.Empty <> True then
  Show;
 end;
end;

procedure SelectMenuPopupListView(List: TListView);
begin
with MainFrm do
begin
if List.ItemIndex <> -1 then
 begin
  //exists items if file exist
  Setup1.Enabled := FileExists(GetExecDir+List.Selected.SubItems[8]);
  ViewManual1.Enabled := FileExists(GetExecDir+List.Selected.SubItems[9]);
  //Change Favorite caption menu
  if PageControl1.ActivePageIndex = 0 then
  Addtofavorite1.Caption := 'Remove to favorite' else
  if not FConfig.SectionExists(GameListView.Selected.Caption) then
  Addtofavorite1.Caption := 'Add to favorite' else
  Addtofavorite1.Caption := 'Remove to favorite';
 end;
end;
end;

procedure TMainFrm.ListMenuPopup(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then SelectMenuPopupListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then SelectMenuPopupListView(GameListView);
end;


procedure TMainFrm.PageControl1Change(Sender: TObject);
begin
TimerOnClick.Enabled := False;
//clear all info components
if PageControl1.ActivePageIndex = 0 then 
 begin
  //load favorites
  GetFavorites(FConfig, FavListView);
  FavListView.ItemIndex := -1 end else
if PageControl1.ActivePageIndex = 1 then GameListView.ItemIndex := -1;

Caption := ExtractFileName(ChangeFileExt(ParamStr(0),''));
NoteMemo.Lines.Clear;
DeveloperLabel.Caption := '';
PublisherLabel.Caption := '';
GenreLabel.Caption := '';
SeriesLabel.Caption := '';
PlayModeLabel.Caption := '';
PlatformLabel.Caption := '';
ReleaseLabel.Caption := '';
TitleLabel.Caption := '';
TitleLabel.Hint := '';
VirtualImgList.Clear;
FrontImage.Picture := nil;
BackImage.Picture := nil;
ScreenShotImage.Picture := nil;
LaunchButton1.Visible := False;
LaunchButton2.Visible := False;
ManualButton.Visible := False;
FavButton.Visible := False;
ChangeImgButton.Visible := False;
end;

procedure SelectAlternativListView(List: TListView);
var
  PathGame: String;
begin
with MainFrm do
begin
//stop timer
TimerOnClick.Enabled := False;
//run alternative launcher
if List.ItemIndex <> -1 then
 begin
  PathGame := GetExecDir+ExtractFileDir(List.Selected.SubItems[0])+'\Extras\Alternate Launcher.bat';
  SetCurrentDir(ExtractFileDir(PathGame));
  RunApplication(PathGame,'');
 end;
end;
end;

procedure TMainFrm.Alternativelaunch1Click(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then SelectAlternativListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then SelectAlternativListView(GameListView);
end;

procedure GetSetupListView(List: TListView);
var
  PathSetup: String;
begin
with MainFrm do
begin
//run setup
if List.ItemIndex <> -1 then
 begin
  PathSetup := GetExecDir+List.Selected.SubItems[8];
  SetCurrentDir(ExtractFileDir(PathSetup));
  RunApplication(PathSetup,'');
 end;
end;
end;

procedure TMainFrm.Setup1Click(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then GetSetupListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then GetSetupListView(GameListView);
end;

procedure GetManualListView(List: TListView);
var
  PathPDF: String;
begin
with MainFrm do
begin
//run pdf
if List.ItemIndex <> -1 then
 begin
  PathPDF := GetExecDir+List.Selected.SubItems[9];
  SetCurrentDir(ExtractFileDir(PathPDF));
  RunApplication(PathPDF,'');
 end;
end;
end;

procedure TMainFrm.ViewManual1Click(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then GetManualListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then GetManualListView(GameListView);
end;

procedure GetShortcutListView(List: TListView);
var
  TargetName: String;
begin
with MainFrm do
begin
//create desktop link for selected game
if List.ItemIndex <> -1 then
 begin
   TargetName := GetExecDir+List.Selected.SubItems[0];
  if CreateDesktopShellLink(GetDesktopFolder, TargetName) then ShowMessage('Link has been created ...');
 end
end;
end;

procedure TMainFrm.Createtodesktopshortcut1Click(Sender: TObject);
begin
if PageControl1.ActivePageIndex = 0 then GetShortcutListView(FavListView) else
if PageControl1.ActivePageIndex = 1 then GetShortcutListView(GameListView);
end;

procedure TMainFrm.Addtofavorite1Click(Sender: TObject);
begin
AddToFav(FConfig, GameListView, FavListView, PageControl1);
end;

procedure TMainFrm.ChangeImgButtonClick(Sender: TObject);
var
 i: Integer;
 TempPicture: TPicture;
begin
TempPicture := TPicture.Create;
 try
  for i := VirtualImgList.Count-1 downto 1 do
   begin
    VirtualImgList.Exchange(i, i-1);
    TempPicture.WICImage.LoadFromFile(VirtualImgList[i]);
    ScreenShotImage.Picture := TempPicture;
   end;
 finally
  TempPicture.Free;
 end;
end;

end.
