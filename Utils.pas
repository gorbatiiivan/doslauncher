unit Utils;

interface

uses Winapi.Windows, Forms, System.SysUtils, Vcl.StdCtrls, System.Classes, ShellAPI,
     Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Menus, Masks;


function LoadResourceFontByID( ResourceID : Integer; ResType: PChar ) : Boolean;
procedure LoadImageFromRes(ResName: String; Image: TImage);
function FindString(List: TStringList; s: string): Integer;
function FindListBoxString(List: TListBox; s: string): Integer;
function FindMenuString(List: TMenuItem; s: string): Integer;
procedure FindFilePattern(root: String; pattern: String; NameList: TStringList; ListPath: TStringList);
procedure FindExtrasFile(root: String; pattern: String; FList: TStringList);
function RunApplication(const AExecutableFile, AParameters: string;
  const AShowOption: Integer = SW_SHOWNORMAL): Integer;
procedure FindListIndex(GameName: String; List: TListBox; BackupList: TStringList);
function ExistsGameDir(Name: String): Boolean;
function ExistsDOSManualDir: Boolean;
function GetExecDir: String;
function GetMainDir: String;

implementation

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

procedure LoadImageFromRes(ResName: String; Image: TImage);
var
  RS: TResourceStream;
  JPGImage: TJPEGImage;
begin
  JPGImage := TJPEGImage.Create;
  try
    RS := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
    try
      JPGImage.LoadFromStream(RS);
      Image.Picture.Graphic := JPGImage;
    finally
      RS.Free;
    end;
  finally
    JPGImage.Free;
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

function FindListBoxString(List: TListBox; s: string): Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < List.Items.Count) and (List.Items[i] <> s) do
    inc(i);
  Result := i;
end;

function FindMenuString(List: TMenuItem; s: string): Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < List.Count) and (List[i].Caption <> s) do
    inc(i);
  Result := i;
end;

procedure FindFilePattern(root: String; pattern: String; NameList: TStringList; ListPath: TStringList);
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
       if (Sr.Name <> 'Extras') then
        if (SR.Name <> '.') and (Sr.Name <> '..') then
          FindFilePattern(root + SR.Name, pattern, NameList, ListPath);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
         begin
         if (SR.Name <> 'install.bat') then
          begin
            NameList.Add(ChangeFileExt(SR.Name,''));
            ListPath.Add(Root + SR.Name);
          end;
         end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

procedure FindExtrasFile(root: String; pattern: String; FList: TStringList);
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
          FindExtrasFile(root + SR.Name, pattern, FList);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
          begin
            FList.Add(Root + SR.Name);
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

procedure FindListIndex(GameName: String; List: TListBox; BackupList: TStringList);
var
  i: Integer;
begin
 List.Items.BeginUpdate;
 List.Items.Assign(BackupList);
 if GameName <> '' then
 for i := List.Count - 1 downto 0
  do if Pos(AnsiUpperCase(GameName), AnsiUpperCase(List.Items.Strings[i])) = 0
        then List.Items.Delete(i);
 List.Items.EndUpdate;
end;

function ExistsGameDir(Name: String): Boolean;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))))+Name);
end;

function ExistsDOSManualDir: Boolean;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))))+'Manuals\MS-DOS');
end;

function GetExecDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s;
end;

function GetMainDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))))+s;
end;

end.
