unit mf;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Graphics,
  System.Classes,
  WinApi.WinApiTypes,
  WinApi.ActiveX.ObjBase,
  WinApi.ComBaseApi,
  WinApi.MediaFoundationApi.MfApi,
  WinApi.MediaFoundationApi.MfPlay;

type
  TMediaPlayerCallback = class(TInterfacedPersistent, IMFPMediaPlayerCallback)
  private
    procedure OnMediaPlayerEvent(var pEventHeader: MFP_EVENT_HEADER); stdcall;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  end;

  procedure OnMediaItemCreated(pEvent: PMFP_MEDIAITEM_CREATED_EVENT);
  procedure OnMediaItemSet(pEvent: PMFP_MEDIAITEM_SET_EVENT);
  function PlayMediaFile(const hApp: HWND; const sURL: LPCWSTR): HResult;
  procedure MFPlay(MFHandle: THandle; FilePath: String);
  procedure MFStop;
  function MFIfStoping: Boolean;
  procedure MFSetVolume(GetVolume: Float);
  procedure MFMute;
  procedure MFVolumeUP;
  procedure MFVolumeDOWN;
  procedure MFPaint(MFHandle: THandle);
  procedure MFWMSize(MFHandle: THandle);
  procedure MFDestroy;

var
  g_pPlayer: IMFPMediaPlayer;
  g_pPlayerCB: TMediaPlayerCallback;
  g_bHasVideo: BOOL;

implementation

uses Main;

constructor TMediaPlayerCallback.Create();
begin
  inherited Create();
end;

destructor TMediaPlayerCallback.Destroy();
begin
  inherited Destroy();
end;

procedure TMediaPlayerCallback.OnMediaPlayerEvent(var pEventHeader: MFP_EVENT_HEADER);
begin
  if Failed(pEventHeader.hrEvent) then Exit;

  case (pEventHeader.eEventType) of
    MFP_EVENT_TYPE_MEDIAITEM_CREATED:
      begin
        OnMediaItemCreated(MFP_GET_MEDIAITEM_CREATED_EVENT(@pEventHeader));
      end;

    MFP_EVENT_TYPE_MEDIAITEM_SET:
      begin
        OnMediaItemSet(MFP_GET_MEDIAITEM_SET_EVENT(@pEventHeader));
      end;
  end;
end;

procedure OnMediaItemCreated(pEvent: PMFP_MEDIAITEM_CREATED_EVENT);
var
  hr: HResult;
  bHasVideo,
  bIsSelected: BOOL;
label
  done;
begin
  hr := S_OK;
  if Assigned(g_pPlayer) then
    begin
      bHasVideo := False;
      bIsSelected := False;
      hr := pEvent.pMediaItem.HasVideo(bHasVideo, bIsSelected);
      if Failed(hr) then goto done;
      g_bHasVideo := bHasVideo and bIsSelected;
      hr := g_pPlayer.SetMediaItem(pEvent.pMediaItem);
    end;
done:
  if Failed(hr) then Exit;
end;

procedure OnMediaItemSet(pEvent: PMFP_MEDIAITEM_SET_EVENT);
var
  hr: HResult;
begin
  hr := g_pPlayer.Play();
  if Failed(hr) then Exit
end;

function PlayMediaFile(const hApp: HWND; const sURL: LPCWSTR): HResult;
var
  hr: HResult;
label
  done;
begin
  if not Assigned(g_pPlayer) then
    begin
      g_pPlayerCB := TMediaPlayerCallback.Create();
      if not Assigned(g_pPlayerCB) then
        begin
          hr := E_OUTOFMEMORY;
          goto done;
        end;
      hr := MFPCreateMediaPlayer(Nil,False,0,g_pPlayerCB,hApp,g_pPlayer);
      if Failed(hr) then
        goto done;
    end;
 hr := g_pPlayer.CreateMediaItemFromURL(sURL,False,0,Nil);
done:
  Result := hr;
end;

procedure MFPlay(MFHandle: THandle; FilePath: String);
var
  hr: HResult;
  pwszFilePath: PWideChar;
begin
  hr := S_OK;
  pwszFilePath := PWideChar(FilePath);
  hr := PlayMediaFile(MFHandle, pwszFilePath);
  hr := g_pPlayer.SetVolume(MainForm.FConfig.ReadFloat('General','Volume',1));
  if Failed(hr) then Exit;
end;

procedure MFStop;
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
begin
if Assigned(g_pPlayer) then
 begin
  hr := g_pPlayer.GetState(state);
  if (state = MFP_MEDIAPLAYER_STATE_PLAYING) then
  g_pPlayer.Stop();
 end;
end;

function MFIfStoping: Boolean;
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
begin
if Assigned(g_pPlayer) then
 begin
  hr := g_pPlayer.GetState(state);
  if (state = MFP_MEDIAPLAYER_STATE_PLAYING) then
  Result := False else
  if (state = MFP_MEDIAPLAYER_STATE_STOPPED) then
  Result := True;
 end;
end;

procedure MFSetVolume(GetVolume: Float);
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
begin
if Assigned(g_pPlayer) then
 begin
   hr := g_pPlayer.GetState(state);
   if Succeeded(hr) then
    begin
     if (state <> MFP_MEDIAPLAYER_STATE_EMPTY) or (state <> MFP_MEDIAPLAYER_STATE_SHUTDOWN) then
     hr := g_pPlayer.SetVolume(GetVolume);
    end;
 end;
if Failed(hr) then Exit;
end;

procedure MFMute;
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
  MuteState: Bool;
begin
if Assigned(g_pPlayer) then
 begin
  hr := g_pPlayer.GetState(state);
  if Succeeded(hr) then
   begin
    if (state <> MFP_MEDIAPLAYER_STATE_EMPTY) or (state <> MFP_MEDIAPLAYER_STATE_SHUTDOWN) then
    if Succeeded(g_pPlayer.GetMute(MuteState)) then
    begin
     if MuteState = True then hr := g_pPlayer.SetMute(False)
     else
     if MuteState = False then hr := g_pPlayer.SetMute(True);
    end;
   end;
  end;
end;

procedure MFVolumeUP;
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
  CurVolume: FLOAT;
begin
if Assigned(g_pPlayer) then
 begin
   hr := g_pPlayer.GetState(state);
   if Succeeded(hr) then
    begin
     if (state <> MFP_MEDIAPLAYER_STATE_EMPTY) or (state <> MFP_MEDIAPLAYER_STATE_SHUTDOWN) then
      if Succeeded(g_pPlayer.GetVolume(CurVolume)) then
       begin
        CurVolume := CurVolume + 0.1;
        if CurVolume > 1 then CurVolume := 1;
        hr := g_pPlayer.SetVolume(CurVolume);
        MainForm.FConfig.WriteFloat('General','Volume',CurVolume);
       end;
    end;
 end;
if Failed(hr) then Exit;
end;

procedure MFVolumeDOWN;
var
  hr: HResult;
  state: MFP_MEDIAPLAYER_STATE;
  CurVolume: FLOAT;
begin
if Assigned(g_pPlayer) then
 begin
   hr := g_pPlayer.GetState(state);
   if Succeeded(hr) then
    begin
     if (state <> MFP_MEDIAPLAYER_STATE_EMPTY) or (state <> MFP_MEDIAPLAYER_STATE_SHUTDOWN) then
      if Succeeded(g_pPlayer.GetVolume(CurVolume)) then
       begin
        CurVolume := CurVolume - 0.1;
        if CurVolume < 0 then CurVolume := 0;
        hr := g_pPlayer.SetVolume(CurVolume);
        MainForm.FConfig.WriteFloat('General','Volume',CurVolume);
       end;
    end;
 end;
if Failed(hr) then Exit;
end;

procedure MFPaint(MFHandle: THandle);
var
  ps: PAINTSTRUCT;
  whdc: HDC;
begin
  whdc := BeginPaint(MFHandle, ps);
  if (Assigned(g_pPlayer) and g_bHasVideo) then
    begin
      g_pPlayer.UpdateVideo();
    end else
    begin
      FillRect(whdc,ps.rcPaint,HBRUSH(COLOR_WINDOW + 1));
    end;
    EndPaint(whdc, ps);
end;

procedure MFWMSize(MFHandle: THandle);
var
  whdc: HDC;
  ps: PAINTSTRUCT;
begin
  if Assigned(g_pPlayer) then
   begin
    whdc := BeginPaint(MFHandle, ps);
    g_pPlayer.UpdateVideo();
    EndPaint(whdc, ps);
   end;
end;

procedure MFDestroy;
begin
  if Assigned(g_pPlayer) then
    begin
      g_pPlayer.Stop();
      g_pPlayer.Shutdown();
      g_pPlayer := Nil;
    end;

   if Assigned(g_pPlayerCB) then
    begin
      FreeAndNil(g_pPlayerCB);
    end;
end;

initialization
begin
  if Succeeded(MFStartup(MF_VERSION)) then
    CoInitializeEx(Nil,
                   COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE)
  else
    Abort();
end;

finalization
begin
  MFShutdown();
  CoUninitialize();
end;

end.
