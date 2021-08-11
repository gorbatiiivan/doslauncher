unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Masks, ShellAPI, IniFiles, Vcl.ComCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

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
    PageControl: TPageControl;
    eXoDOSSheet: TTabSheet;
    eXoWin3xSheet: TTabSheet;
    DosMainList: TListBox;
    eXoScummVMSheet: TTabSheet;
    Win3xMainList: TListBox;
    ScummVMMainList: TListBox;
    Extras1: TMenuItem;
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
  private
    { Private declarations }
    FormActivated: Boolean;
    FConfig: TMemIniFile;
    function GetFConfig: TMemIniFile;
    procedure RegIni(Write: Boolean; FirstRun: Boolean);
    procedure ExtrasMenuClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  DosList: TStringList;
  DosPath: TStringList;
  Win3xList: TStringList;
  Win3xPath: TStringList;
  ScummVMList: TStringList;
  ScummVMPath: TStringList;
  ExtrassList: TStringList;

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

function FindMenuString(List: TMenuItem; s: string): Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < List.Count) and (List[i].Caption <> s) do
    inc(i);
  Result := i;
end;

procedure FindFileDosPattern(root: String; pattern: String);
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
          FindFileDosPattern(root + SR.Name, pattern);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
         begin
         if (SR.Name <> 'install.bat') then
          begin
            DosList.Add(ChangeFileExt(SR.Name,''));
            DosPath.Add(Root + SR.Name);
            MainForm.DosMainList.Items.Add(ChangeFileExt(SR.Name,''));
          end;
         end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

procedure FindFileWin3xPattern(root: String; pattern: String);
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
          FindFileWin3xPattern(root + SR.Name, pattern);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
         begin
         if (SR.Name <> 'install.bat') then
          begin
            Win3xList.Add(ChangeFileExt(SR.Name,''));
            Win3xPath.Add(Root + SR.Name);
            MainForm.Win3xMainList.Items.Add(ChangeFileExt(SR.Name,''));
          end;
         end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

procedure FindFileScummVMPattern(root: String; pattern: String);
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
          FindFileScummVMPattern(root + SR.Name, pattern);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
         begin
         if (SR.Name <> 'install.bat') then
          begin
            ScummVMList.Add(ChangeFileExt(SR.Name,''));
            ScummVMPath.Add(Root + SR.Name);
            MainForm.ScummVMMainList.Items.Add(ChangeFileExt(SR.Name,''));
          end;
         end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

procedure FindExtrasFile(root: String; pattern: String);
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
          FindExtrasFile(root + SR.Name, pattern);
      end else
      begin
        if MatchesMask(SR.Name, pattern) then
          begin
            ExtrassList.Add(Root + SR.Name);
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

function ExistsDosDir: Boolean;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))))+'eXoDOS');
end;

function ExistsWin3xDir: Boolean;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))))+'eXoWin3x');
end;

function ExistsScummVMDir: Boolean;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := DirectoryExists(IncludeTrailingPathDelimiter(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0)))))+'eXoScummVM');
end;

function GetDosDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'eXoDOS'+s+'!dos';
end;

function GetWin3xDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'eXoWin3x'+s+'!win3x';
end;

function GetScummVMDir: String;
var
  s: String;
begin
  s := IncludeTrailingPathDelimiter(s);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))+s+'eXoScummVM'+s+'!ScummVM';
end;

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
    PageControl.Enabled := False;
    PageControl.ActivePage := nil;

    if ExistsDosDir then
    begin
    DosList.Clear;
    DosPath.Clear;
    DosMainList.Items.Clear;
    FindFileDosPattern(GetDosDir, '*.bat');
    if DosMainList.Items.Count <> -1 then DosMainList.ItemIndex := 0;
    end;

    if ExistsWin3xDir then
    begin
    Win3xList.Clear;
    Win3xPath.Clear;
    Win3xMainList.Items.Clear;
    FindFileWin3xPattern(GetWin3xDir, '*.bat');
    if Win3xMainList.Items.Count <> -1 then Win3xMainList.ItemIndex := 0;
    end;

    if ExistsScummVMDir then
    begin
    ScummVMList.Clear;
    ScummVMPath.Clear;
    ScummVMMainList.Items.Clear;
    FindFileScummVMPattern(GetScummVMDir, '*.bat');
    if ScummVMMainList.Items.Count <> -1 then ScummVMMainList.ItemIndex := 0;
    end;

    if not (ExistsDosDir) and not(ExistsWin3xDir) and not (ExistsScummVMDir) then
    MainForm.Caption := 'Sorry, not found any eXo Collection folder' else
    MainForm.Caption := 'The scan is complete, please select your favorite tab.';

    Sleep (1000);
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

  FindExtrasFile(MainDir, '*.bat');
  if not (ExtrassList.Count = -1) then
  for i := 0 to ExtrassList.Count-1 do
   begin
    MenuItem := TMenuItem.Create(MenuItem);
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

//IniFile

function TMainForm.GetFConfig: TMemIniFile;
begin
  if FConfig = nil then
  FConfig := TMemIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini',TEncoding.UTF8);
  Result := FConfig;
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
 begin
  Position := poDesktopCenter;
  RegIni(False, True);
 end else Position := poDefaultPosOnly;

eXoDOSSheet.TabVisible := ExistsDosDir;
eXoWin3xSheet.TabVisible := ExistsWin3xDir;
eXoScummVMSheet.TabVisible := ExistsScummVMDir;

RegIni(False, False);

if LoadResourceFontByID(2, 'MYFONT1') then
 begin
   MainForm.ParentFont := False;
   MainForm.Font.Size := 8;
   MainForm.Font.Name := 'Modern DOS 8x8';
 end;
if LoadResourceFontByID(1, 'MYFONT') then
 begin
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
 end;

DosList := TStringList.Create;
DosPath := TStringList.Create;
Win3xList := TStringList.Create;
Win3xPath := TStringList.Create;
ScummVMList := TStringList.Create;
ScummVMPath := TStringList.Create;
ExtrassList := TStringList.Create;
SetTimer(Handle,TIMER1,1000,@TimerCallBack1);
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
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_F5 then AddGamesToList;
if Key = VK_RETURN then
 begin
   if eXoDOSSheet.Visible then DosMainListDblClick(Sender);
   if eXoWin3xSheet.Visible then Win3xMainListDblClick(Sender);
   if eXoScummVMSheet.Visible then ScummVMMainListDblClick(Sender);
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
Canvas.Rectangle (4, 4, ClientWidth -4, ClientHeight -4);
Canvas.Pen.Color := $00FFFF55;
Canvas.Pen.Style := psSolid;
Canvas.Pen.Width := 1;
Canvas.Rectangle (6, 6, ClientWidth -6, ClientHeight -6);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
Repaint;
PageControl.SetBounds(10,10,ClientWidth -20, ClientHeight -20);
end;

//TListMenu

procedure TMainForm.ListMenuPopup(Sender: TObject);
begin
if (eXoDOSSheet.Visible) and (DosMainList.ItemIndex <> -1) then
ExtrasFileAdd(Extras1);
if (eXoWin3xSheet.Visible) and (Win3xMainList.ItemIndex <> -1) then
ExtrasFileAdd(Extras1);
if (eXoScummVMSheet.Visible) and (ScummVMMainList.ItemIndex <> -1) then
ExtrasFileAdd(Extras1);
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

//TMainList

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

procedure TMainForm.DosMainListClick(Sender: TObject);
begin
MainForm.Caption := SetCaption;
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

MainForm.Caption := SetCaption;

if Button = mbRight then
if (Sender as TListBox).ItemIndex <> -1 then
 begin
  Open1.Enabled := True;
  Install1.Enabled := True;
  Extras1.Enabled := True;
  if ExistsDosDir then
  CheckforUpdate1.Enabled := eXoDOSSheet.Visible;
  ListMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
 end else
 begin
  Open1.Enabled := False;
  Install1.Enabled := False;
  Extras1.Enabled := False;
  if ExistsDosDir then
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
    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
MainForm.Caption := SetCaption;

if ExistsDosDir then
if eXoDOSSheet.Visible then
ActiveControl := DosMainList;

if ExistsWin3xDir then
if eXoWin3xSheet.Visible then
ActiveControl := Win3xMainList;

if ExistsScummVMDir then
if eXoScummVMSheet.Visible then
ActiveControl := ScummVMMainList;
end;

end.
