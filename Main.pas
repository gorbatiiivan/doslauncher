unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IOUtils, Types, StrUtils, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Xml.VerySimple, Vcl.Menus, IniFiles;

type
  TMainFrm = class(TForm)
    MainPanel: TPanel;
    NotesMemo: TMemo;
    MediaPanel: TPanel;
    DISCImage: TImage;
    BoxFrontImage: TImage;
    TitleImage: TImage;
    ScreenShootImage: TImage;
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
    GameListView: TListView;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GameListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormResize(Sender: TObject);
    procedure GameListViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DISCImageClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    procedure ViewManual1Click(Sender: TObject);
    procedure ListMenuPopup(Sender: TObject);
    procedure Createtodesktopshortcut1Click(Sender: TObject);
    procedure TimerOnClickTimer(Sender: TObject);
    procedure Addtofavorite1Click(Sender: TObject);
    procedure Alternativelaunch1Click(Sender: TObject);
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

implementation

{$R *.dfm}

uses Utils, FullScreenImage;

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
   //load favorites
   GetFavorites(FConfig, GameListView);
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
GameListView.Width := MainFrm.Width div 2;
GameListView.Column[0].Width := GameListView.Width -20;
NotesMemo.Height := MainFrm.Height div 2;
//Images resize
DISCImage.Top := 0;
DISCImage.Left := 0;
DISCImage.Width := MediaPanel.Width div 2;
DISCImage.Height := MediaPanel.Height div 2;
BoxFrontImage.Top := 0;
BoxFrontImage.Left := MediaPanel.Width div 2;
BoxFrontImage.Width := MediaPanel.Width div 2;
BoxFrontImage.Height := MediaPanel.Height div 2;
TitleImage.Top := MediaPanel.Height div 2;
TitleImage.Left := 0;
TitleImage.Width := MediaPanel.Width div 2;
TitleImage.Height := MediaPanel.Height div 2;
ScreenShootImage.Top := MediaPanel.Height div 2;
ScreenShootImage.Left := MediaPanel.Width div 2;
ScreenShootImage.Width := MediaPanel.Width div 2;
ScreenShootImage.Height := MediaPanel.Height div 2;
end;

procedure TMainFrm.GameListViewDblClick(Sender: TObject);
var
  PathGame: String;
begin
//stop timer
TimerOnClick.Enabled := False;
//run games
if GameListView.ItemIndex <> -1 then
 begin
  PathGame := GetExecDir+GameListView.Selected.SubItems[0];
  SetCurrentDir(ExtractFileDir(PathGame));
  RunApplication(PathGame,'');
 end;
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
end;
end;

procedure TMainFrm.TimerOnClickTimer(Sender: TObject);
begin
if GameListView.Selected.Selected = True then
 begin
  //stop timer
  TimerOnClick.Enabled := False;
  //clear images
  DISCImage.Picture := nil;
  BoxFrontImage.Picture := nil;
  TitleImage.Picture := nil;
  ScreenShootImage.Picture := nil;
  NotesMemo.Clear;
  //get caption
  if GameListView.Selected.GroupID = 0 then //Favorit Group ID
   Caption := ExtractFileName(ChangeFileExt(ParamStr(0),'')) + ' - Total favorites games : ['+
   IntToStr(GetNumItemsInGroup(GameListView,0)) + ']'
  else
  if GameListView.Selected.GroupID = 1 then //All Group ID
   Caption := ExtractFileName(ChangeFileExt(ParamStr(0),'')) + ' - Total games : ['+
   IntToStr(GetNumItemsInGroup(GameListView,1)) + ']';
  TrayIcon.Hint := Caption;
  //read info, notes, images
  if GameListView.Selected.GroupID = 0 then //if selected favorites
   begin
    GetNotes(NotesMemo, GameListView);
    GetMultimedia(GameListView, DISCImage, BoxFrontImage, TitleImage, ScreenShootImage);
   end else //else if selected all games
   begin
    GetNotes(NotesMemo, GameListView);
    GetMultimedia(GameListView, DISCImage, BoxFrontImage, TitleImage, ScreenShootImage);
   end;
 end;
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

procedure TMainFrm.DISCImageClick(Sender: TObject);
begin
//view image to fullscreen
with FullScreenForm do
 begin
  FullScreenImage.Picture.WICImage := (Sender as TImage).Picture.WICImage;
  if (Sender as TImage).Picture.WICImage.Empty <> True then
  Show;
 end;
end;

procedure TMainFrm.ListMenuPopup(Sender: TObject);
begin
if GameListView.ItemIndex <> -1 then
 begin
  //exists items if file exist
  Setup1.Enabled := FileExists(GetExecDir+GameListView.Selected.SubItems[8]);
  ViewManual1.Enabled := FileExists(GetExecDir+GameListView.Selected.SubItems[9]);
  //Change Favorite caption menu
  if GameListView.Selected.GroupID = 0 then
  Addtofavorite1.Caption := 'Remove to favorite' else
  if not FConfig.SectionExists(GameListView.Selected.Caption) then
  Addtofavorite1.Caption := 'Add to favorite' else
  Addtofavorite1.Caption := 'Remove to favorite';
 end;
end;

procedure TMainFrm.Alternativelaunch1Click(Sender: TObject);
var
  PathGame: String;
begin
//stop timer
TimerOnClick.Enabled := False;
//run alternative launcher
if GameListView.ItemIndex <> -1 then
 begin
  PathGame := GetExecDir+ExtractFileDir(GameListView.Selected.SubItems[0])+'\Extras\Alternate Launcher.bat';
  SetCurrentDir(ExtractFileDir(PathGame));
  RunApplication(PathGame,'');
 end;
end;

procedure TMainFrm.Setup1Click(Sender: TObject);
var
  PathSetup: String;
begin
//run setup
if GameListView.ItemIndex <> -1 then
 begin
  PathSetup := GetExecDir+GameListView.Selected.SubItems[8];
  SetCurrentDir(ExtractFileDir(PathSetup));
  RunApplication(PathSetup,'');
 end;
end;

procedure TMainFrm.ViewManual1Click(Sender: TObject);
var
  PathPDF: String;
begin
//run pdf
if GameListView.ItemIndex <> -1 then
 begin
  PathPDF := GetExecDir+GameListView.Selected.SubItems[9];
  SetCurrentDir(ExtractFileDir(PathPDF));
  RunApplication(PathPDF,'');
 end;
end;

procedure TMainFrm.Createtodesktopshortcut1Click(Sender: TObject);
var
  TargetName: String;
begin
//create desktop link for selected game
if GameListView.ItemIndex <> -1 then
 begin
   TargetName := GetExecDir+GameListView.Selected.SubItems[0];
  if CreateDesktopShellLink(GetDesktopFolder, TargetName) then ShowMessage('Link has been created ...');
 end;
end;

procedure TMainFrm.Addtofavorite1Click(Sender: TObject);
begin
//Create/Delete favorite
 AddToFav(FConfig, GameListView);
end;

end.
