unit Utils;

interface

uses Winapi.Windows, Winapi.Messages, Forms, System.SysUtils, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Graphics,
     System.Classes, ShellAPI, Vcl.ExtCtrls, Vcl.Menus, Masks, IniFiles, ShlObj,
     ComObj, ActiveX, Xml.VerySimple, IOUtils, Types, StrUtils;

function FindFromListView(List: TListView; s: string): Integer;
function GetExecDir: String;
procedure AddNotes(List: TListView; Xml:TXmlVerySimple; Books:TXmlNodeList);
function GetInfo(InfoNumber: Integer; List: TListView): String;
procedure GetInfoNotes(Notes:TMemo; List: TListView);
function OneLine(const s: String): String;
procedure GetMultimedia(List: TListView; BoxFrontImg: TImage; BoxBackImage: TImage);
procedure AddGameList(Dir: String; List: TListView; XML: TXmlVerySimple; Books:TXmlNodeList);
procedure GetFavorites(Config: TMemIniFile; List: TListView);
procedure AddToFav(Config: TMemIniFile; GameList: TListView; FavGameList: TListView; PageSelect: TPageControl);
function RunApplication(const AExecutableFile, AParameters: string; const AShowOption: Integer = SW_SHOWNORMAL): Boolean;
function GetDesktopFolder: string;
function CreateDesktopShellLink(const Folder, TargetName: string): Boolean;

implementation

uses Main;

function FindFromListView(List: TListView; s: string): Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < List.Items.Count) and (List.Items[i].Caption <> s) do
    inc(i);
  Result := i;
end;

function GetExecDir: String;
begin
  SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ParamStr(0)))));
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ParamStr(0))));
end;

procedure AddNotes(List: TListView; Xml:TXmlVerySimple; Books:TXmlNodeList);
var
  Item: TListItem;
  BookNode, EntityNode: TXmlNode;
  I: Integer;
begin
  Books := Xml.DocumentElement.FindNodes('Game');

  for BookNode in Books do
  begin
  Item := List.Items.Insert(0);

   EntityNode := BookNode.Find('Title');
    if Assigned(EntityNode) then
      Item.Caption := EntityNode.Text;

   EntityNode := BookNode.Find('ApplicationPath');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Developer');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Publisher');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Genre');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Series');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('PlayMode');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Platform');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('Notes');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('ConfigurationPath');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('ManualPath');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);

   EntityNode := BookNode.Find('ReleaseDate');
    if Assigned(EntityNode) then
      Item.SubItems.Add(EntityNode.Text);
  end;
  Item.Free;
end;

//Extract OnlyDate
function TGetDate(Date: String): String;
var
 fs: TFormatSettings;
 s: string;
 dt: TDateTime;
begin
if Date <> '' then
 begin
  fs := TFormatSettings.Create;
  fs.DateSeparator := '-';
  fs.ShortDateFormat := 'yyyy-MM-dd';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm';
  fs.LongTimeFormat := 'hh:mm:ss';
  s := Date;
  dt := StrToDateTime(s, fs);
  Result := DateToStr(dt);
 end;
end;

function GetInfo(InfoNumber: Integer; List: TListView): String;
begin
case InfoNumber of
  0: Result := 'Developer: '+StringReplace(List.Items[List.ItemIndex].SubItems[1],'&amp;', '&',[rfReplaceAll]);
  1: Result := 'Publisher: '+StringReplace(List.Items[List.ItemIndex].SubItems[2],'&amp;', '&',[rfReplaceAll]);
  2: Result := 'Genre: '+List.Items[List.ItemIndex].SubItems[3];
  3: Result := 'Series: '+List.Items[List.ItemIndex].SubItems[4];
  4: Result := 'PlayMode: '+List.Items[List.ItemIndex].SubItems[5];
  5: Result := 'Platform: '+List.Items[List.ItemIndex].SubItems[6];
  6: Result := 'Release date: '+TGetDate(List.Items[List.ItemIndex].SubItems[10]);
  7: Result := List.Items[List.ItemIndex].Caption;
end;
end;

procedure GetInfoNotes(Notes:TMemo; List: TListView);
begin
Notes.Lines.Insert(0,StringReplace(StringReplace(List.Items[List.ItemIndex].SubItems[7],'&amp;', '&',[rfReplaceAll]),'�', '''',[rfReplaceAll]));
Notes.SelStart := Notes.Perform(EM_LINEINDEX, 0, 0);
Notes.SelLength := Length(Notes.Lines[0]);
end;

function OneLine(const s: String): String;
//(R"([<>:"\/\\|?*'])")) from git Pegasus frontend
begin
  if Pos(':', s) > 0 then
    Result := OneLine(StringReplace(s, ':', '_', [rfReplaceAll])) else
  if Pos('"', s) > 0 then
    Result := OneLine(StringReplace(s, '"', '_', [rfReplaceAll])) else
  if Pos('(', s) > 0 then
    Result := OneLine(StringReplace(s, '(', '_', [rfReplaceAll])) else
  if Pos(')', s) > 0 then
    Result := OneLine(StringReplace(s, ')', '_', [rfReplaceAll])) else
  if Pos('''', s) > 0 then
    Result := OneLine(StringReplace(s, '''', '_', [rfReplaceAll])) else
  if Pos('/', s) > 0 then
    Result := OneLine(StringReplace(s, '/', '_', [rfReplaceAll])) else
  if Pos('<>', s) > 0 then
    Result := OneLine(StringReplace(s, '<>', '_', [rfReplaceAll])) else
  if Pos('<', s) > 0 then
    Result := OneLine(StringReplace(s, '<', '_', [rfReplaceAll])) else
  if Pos('>', s) > 0 then
    Result := OneLine(StringReplace(s, '>', '_', [rfReplaceAll])) else
  if Pos('\', s) > 0 then
    Result := OneLine(StringReplace(s, '\', '_', [rfReplaceAll])) else
  if Pos('\\', s) > 0 then
    Result := OneLine(StringReplace(s, '\\', '_', [rfReplaceAll])) else
  if Pos('|', s) > 0 then
    Result := OneLine(StringReplace(s, '|', '_', [rfReplaceAll])) else
  if Pos('?', s) > 0 then
    Result := OneLine(StringReplace(s, '?', '_', [rfReplaceAll])) else
  if Pos('*', s) > 0 then
    Result := OneLine(StringReplace(s, '*', '_', [rfReplaceAll])) else
  if Pos(']', s) > 0 then
    Result := OneLine(StringReplace(s, ']', '_', [rfReplaceAll])) else
  if Pos('[', s) > 0 then
    Result := OneLine(StringReplace(s, '[', '_', [rfReplaceAll]))
  else
    Result := s;
end;

procedure GetMultimedia(List: TListView; BoxFrontImg: TImage; BoxBackImage: TImage);
var
  PictName: String;
  ScreenShootDirs, GameTitles, BoxFronts, BoxBack: TStringDynArray;
  ScreenShootPath, GameTitlePath, BoxFronPath, BoxBackPath: String;
  TempPicture: TPicture;
begin
VirtualImgList.Clear;
TempPicture := TPicture.Create;
try
 ScreenShootDirs := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Screenshot - Gameplay\', OneLine(List.Selected.Caption)+'-'+'*', TSearchOption.soAllDirectories);
  for ScreenShootPath in ScreenShootDirs do
    begin
     VirtualImgList.Add(ScreenShootPath);
    end;

 GameTitles := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Screenshot - Game Title\', OneLine(List.Selected.Caption)+'-01'+'*', TSearchOption.soAllDirectories);
  for GameTitlePath in GameTitles do
    begin
     VirtualImgList.Add(GameTitlePath);
    end;

 BoxFronts := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Box - Front\', OneLine(List.Selected.Caption)+'-01'+'*', TSearchOption.soAllDirectories);
  for BoxFronPath in BoxFronts do
    begin
     TempPicture.WICImage.LoadFromFile(BoxFronPath);
     BoxFrontImg.Picture := TempPicture;
    end;

 BoxBack := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Box - Back\', OneLine(List.Selected.Caption)+'-01'+'*', TSearchOption.soAllDirectories);
  for BoxBackPath in BoxBack do
    begin
     TempPicture.WICImage.LoadFromFile(BoxBackPath);
     BoxBackImage.Picture := TempPicture;
    end;
 finally
   TempPicture.Free;
 end;
end;

procedure AddGameList(Dir: String; List: TListView; XML: TXmlVerySimple; Books:TXmlNodeList);
var
  Path: String;
  I: Integer;
  TempList: TStringList;
begin
TempList := TStringList.Create;
 try
  for Path in TDirectory.GetFiles(Dir,'*.xml') do
   begin
    TempList.Add(Path);
    for I := 0 to TempList.Count -1 do
     begin
      XML.LoadFromFile(TempList[I]);
     end;

    AddNotes(List,Xml,Books);
   end;
 finally
  TempList.Free;
 end;
List.SortType := stText;
end;

procedure GetFavorites(Config: TMemIniFile; List: TListView);
var
 I: Integer;
 Item: TListItem;
 TempList: TStringList;
begin
 List.Clear;
 TempList := TStringList.Create;
  try
   Config.ReadSections(TempList);
   for I := 0 to TempList.Count -1 do
   begin
    Item := List.Items.Insert(I);
    Item.Caption := TempList[I];
    Item.SubItems.Add(Config.ReadString(TempList[I],'ApplicationPath',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Developer',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Publisher',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Genre',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Series',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'PlayMode',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Platform',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'Notes',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'ConfigurationPath',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'ManualPath',''));
    Item.SubItems.Add(Config.ReadString(TempList[I],'ReleaseDate',''));
   end;
   List.Items.Delete(FindFromListView(List,'General'));
  finally
   TempList.Free;
  end;
 List.SortType := stText;
end;

procedure AddToFav(Config: TMemIniFile; GameList: TListView; FavGameList: TListView; PageSelect: TPageControl);
var
  Item: TListItem;
begin
if not Config.SectionExists(GameList.Selected.Caption) then
 begin
  Config.WriteString(GameList.Selected.Caption,'ApplicationPath',GameList.Items[GameList.ItemIndex].SubItems[0]);
  Config.WriteString(GameList.Selected.Caption,'Developer',GameList.Items[GameList.ItemIndex].SubItems[1]);
  Config.WriteString(GameList.Selected.Caption,'Publisher',GameList.Items[GameList.ItemIndex].SubItems[2]);
  Config.WriteString(GameList.Selected.Caption,'Genre',GameList.Items[GameList.ItemIndex].SubItems[3]);
  Config.WriteString(GameList.Selected.Caption,'Series',GameList.Items[GameList.ItemIndex].SubItems[4]);
  Config.WriteString(GameList.Selected.Caption,'PlayMode',GameList.Items[GameList.ItemIndex].SubItems[5]);
  Config.WriteString(GameList.Selected.Caption,'Platform',GameList.Items[GameList.ItemIndex].SubItems[6]);
  Config.WriteString(GameList.Selected.Caption,'Notes',GameList.Items[GameList.ItemIndex].SubItems[7]);
  Config.WriteString(GameList.Selected.Caption,'ConfigurationPath',GameList.Items[GameList.ItemIndex].SubItems[8]);
  Config.WriteString(GameList.Selected.Caption,'ManualPath',GameList.Items[GameList.ItemIndex].SubItems[9]);
  Config.WriteString(GameList.Selected.Caption,'ReleaseDate',GameList.Items[GameList.ItemIndex].SubItems[10]);
  Config.UpdateFile;
 end else
 begin
  if PageSelect.ActivePageIndex = 0 then
   begin
    Config.EraseSection(FavGameList.Selected.Caption);
    Config.UpdateFile;
    FavGameList.Items.Delete(FindFromListView(FavGameList,FavGameList.Selected.Caption));
    FavGameList.ItemIndex := -1;
    MainFrm.PageControl1Change(MainFrm);
   end else
  if PageSelect.ActivePageIndex = 1 then
   begin
    Config.EraseSection(GameList.Selected.Caption);
    Config.UpdateFile;
   end;
 end;
end;

function RunApplication(const AExecutableFile, AParameters: string;
  const AShowOption: Integer = SW_SHOWNORMAL): Boolean;
var
  _SEInfo: TShellExecuteInfo;
begin
  Result := False;
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
    Result := True;
  end;
end;

function GetDesktopFolder: string;
var
  PIDList: PItemIDList;
  Buffer: array [0..MAX_PATH-1] of Char;
begin
  Result := '';
  SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, PIDList);
  if Assigned(PIDList) then
    if SHGetPathFromIDList(PIDList, Buffer) then
      Result := Buffer;
end;

function CreateDesktopShellLink(const Folder, TargetName: string): Boolean;
var
  IObject: IUnknown;
  ISLink: IShellLink;
  IPFile: IPersistFile;
  PIDL: PItemIDList;
  LinkName: string;
  InFolder: array [0..MAX_PATH-1] of Char;
begin
  Result := False;

  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetDescription('');
    SetPath(PChar(TargetName));
    SetWorkingDirectory(PChar(ExtractFilePath(TargetName)));
  end;

  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
  SHGetPathFromIDList(PIDL, InFolder) ;

  LinkName := IncludeTrailingBackslash(Folder);
  LinkName := LinkName + ChangeFileExt(ExtractFileName(TargetName),'') + '.lnk';

  if not FileExists(LinkName) then
    if IPFile.Save(PWideChar(LinkName), False) = S_OK then
      Result := True;
end;

end.
