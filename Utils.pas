unit Utils;

interface

uses Winapi.Windows, Winapi.Messages, Forms, System.SysUtils, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Graphics,
     System.Classes, ShellAPI, Vcl.ExtCtrls, Vcl.Menus, Masks, IniFiles, ShlObj,
     ComObj, ActiveX, Xml.VerySimple, IOUtils, Types, StrUtils;

function FindFromListView(List: TListView; s: string): Integer;
function GetExecDir: String;
procedure AddNotes(List: TListView; Xml:TXmlVerySimple; Books:TXmlNodeList);
procedure GetNotes(Memo: TMemo; List: TListView);
procedure GetMultimedia(List: TListView; ScreenShotImg: TImage; TitleImg: TImage; BoxFrontImg: TImage; DISCImg: TImage);
procedure AddGameList(Dir: String; List: TListView; XML: TXmlVerySimple; Books:TXmlNodeList);
procedure GetFavorites(Config: TMemIniFile; List: TListView);
procedure AddToFav(Config: TMemIniFile; GameList: TListView);
function RunApplication(const AExecutableFile, AParameters: string; const AShowOption: Integer = SW_SHOWNORMAL): Boolean;
function GetDesktopFolder: string;
function CreateDesktopShellLink(const Folder, TargetName: string): Boolean;
function GetNumItemsInGroup(List: TListView; const GroupID: integer): integer;

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
  Item.GroupID := 1;

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
  end;
  Item.Free;
end;

procedure GetNotes(Memo: TMemo; List: TListView);
begin
Memo.Lines.Insert(0,'Developer: '+StringReplace(List.Items[List.ItemIndex].SubItems[1],'&amp;', '&',[rfReplaceAll]));
Memo.Lines.Insert(1,'Publisher: '+StringReplace(List.Items[List.ItemIndex].SubItems[2],'&amp;', '&',[rfReplaceAll]));
Memo.Lines.Insert(2,'Genre: '+List.Items[List.ItemIndex].SubItems[3]);
Memo.Lines.Insert(3,'Series: '+List.Items[List.ItemIndex].SubItems[4]);
Memo.Lines.Insert(4,'PlayMode: '+List.Items[List.ItemIndex].SubItems[5]);
Memo.Lines.Insert(5,'Platform: '+List.Items[List.ItemIndex].SubItems[6]);
Memo.Lines.Insert(6,'');
Memo.Lines.Insert(7,StringReplace(StringReplace(List.Items[List.ItemIndex].SubItems[7],'&amp;', '&',[rfReplaceAll]),'�', '''',[rfReplaceAll]));
//Select first line
Memo.SelStart := Memo.Perform(EM_LINEINDEX, 0, 0);
Memo.SelLength := Length(Memo.Lines[0]);
end;

function OneLine(const s: String): String;
//(R"([<>:"\/\\|?*'])")) from git Pegasus frontend
begin
  if Pos(':', s) > 0 then
    Result := OneLine(StringReplace(s, ':', '_', [rfReplaceAll])) else
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

procedure GetMultimedia(List: TListView; ScreenShotImg: TImage; TitleImg: TImage; BoxFrontImg: TImage; DISCImg: TImage);
var
  PictName: String;
  ScreenShootDirs, GameTitles, BoxFronts, DISCS: TStringDynArray;
  ScreenShootPath, GameTitlePath, BoxFronPath, DISCPath: String;
  TempPicture: TPicture;
begin
TempPicture := TPicture.Create;
try
 ScreenShootDirs := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Screenshot - Gameplay\', OneLine(List.Selected.Caption)+'*', TSearchOption.soAllDirectories);
  for ScreenShootPath in ScreenShootDirs do
    begin
     TempPicture.WICImage.LoadFromFile(ScreenShootPath);
     ScreenShotImg.Picture := TempPicture;
    end;

 GameTitles := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Screenshot - Game Title\', OneLine(List.Selected.Caption)+'*', TSearchOption.soAllDirectories);
  for GameTitlePath in GameTitles do
    begin
     TempPicture.WICImage.LoadFromFile(GameTitlePath);
     TitleImg.Picture := TempPicture;
    end;

 BoxFronts := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Box - Front\', OneLine(List.Selected.Caption)+'*', TSearchOption.soAllDirectories);
  for BoxFronPath in BoxFronts do
    begin
     TempPicture.WICImage.LoadFromFile(BoxFronPath);
     BoxFrontImg.Picture := TempPicture;
    end;

 DISCS := TDirectory.GetFiles(GetExecDir+'Images\'+List.Selected.SubItems[6]+'\Box - Back\', OneLine(List.Selected.Caption)+'*', TSearchOption.soAllDirectories);
  for DISCPath in DISCS do
    begin
     TempPicture.WICImage.LoadFromFile(DISCPath);
     DISCImg.Picture := TempPicture;
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
 TempList := TStringList.Create;
  try
   Config.ReadSections(TempList);
   for I := 0 to TempList.Count -1 do
   begin
    Item := List.Items.Insert(I);
    Item.GroupID := 0;
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
   end;
   List.Items.Delete(FindFromListView(List,'General'));
  finally
   TempList.Free;
  end;
end;

procedure AddToFav(Config: TMemIniFile; GameList: TListView);
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
  Config.UpdateFile;
  //Add item to main list
  GameList.Items.BeginUpdate;
  Item := GameList.Items.Insert(0);
  Item.GroupID := 0;
  Item.Caption := GameList.Selected.Caption;
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'ApplicationPath',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Developer',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Publisher',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Genre',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Series',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'PlayMode',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Platform',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'Notes',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'ConfigurationPath',''));
  Item.SubItems.Add(Config.ReadString(GameList.Selected.Caption,'ManualPath',''));
  GameList.Items.EndUpdate;
 end else
 begin
  if GameList.Items[GameList.ItemIndex].GroupID = 0 then
   begin
    Config.EraseSection(GameList.Selected.Caption);
    Config.UpdateFile;
    GameList.Items.Delete(FindFromListView(GameList,GameList.Selected.Caption));
    GameList.ItemIndex := -1;
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

function GetNumItemsInGroup(List: TListView; const GroupID: integer): integer;
var
  i: Integer;
begin
  result := 0;
  assert((GroupID >= 0) and (GroupID <= List.Groups.Count - 1));
  for i := 0 to List.Items.Count - 1 do
    if List.Items.Item[i].GroupID = GroupID then
      inc(result);
end;

end.
