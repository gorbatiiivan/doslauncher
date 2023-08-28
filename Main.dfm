object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = #181'launcher'
  ClientHeight = 538
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 21
  object MainPanel: TPanel
    Left = 273
    Top = 0
    Width = 452
    Height = 538
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object MediaPanel: TPanel
      Left = 0
      Top = 354
      Width = 452
      Height = 184
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object ScreenShotImage: TImage
        Left = 0
        Top = 0
        Width = 452
        Height = 184
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        OnClick = ScreenShotImageClick
        ExplicitLeft = 2
        ExplicitTop = -5
        ExplicitWidth = 177
        ExplicitHeight = 150
      end
      object ChangeImgButton: TButton
        Left = 415
        Top = 144
        Width = 33
        Height = 33
        Hint = 'Next image'
        Caption = '>'
        TabOrder = 0
        Visible = False
        OnClick = ChangeImgButtonClick
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 233
      Width = 452
      Height = 121
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object FrontImage: TImage
        Left = 0
        Top = 0
        Width = 176
        Height = 121
        Align = alLeft
        Center = True
        Proportional = True
        Stretch = True
        OnClick = ScreenShotImageClick
        ExplicitLeft = 2
        ExplicitTop = -6
      end
      object BackImage: TImage
        Left = 176
        Top = 0
        Width = 276
        Height = 121
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        OnClick = ScreenShotImageClick
        ExplicitLeft = 128
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object InfoPanel: TPanel
      Left = 0
      Top = 0
      Width = 452
      Height = 233
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object TitleLabel: TLabel
        Left = 0
        Top = 0
        Width = 452
        Height = 32
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 7
      end
      object DeveloperLabel: TLabel
        Left = 0
        Top = 32
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object PublisherLabel: TLabel
        Left = 0
        Top = 53
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object GenreLabel: TLabel
        Left = 0
        Top = 74
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object SeriesLabel: TLabel
        Left = 0
        Top = 95
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object PlayModeLabel: TLabel
        Left = 0
        Top = 116
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object PlatformLabel: TLabel
        Left = 0
        Top = 137
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object ReleaseLabel: TLabel
        Left = 0
        Top = 158
        Width = 452
        Height = 21
        Align = alTop
        ExplicitWidth = 4
      end
      object LaunchButton1: TButton
        Left = 14
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Launch'
        TabOrder = 0
        Visible = False
        OnClick = GameListViewDblClick
      end
      object LaunchButton2: TButton
        Left = 95
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Launch 2'
        TabOrder = 1
        Visible = False
        OnClick = Alternativelaunch1Click
      end
      object FavButton: TButton
        Left = 257
        Top = 192
        Width = 33
        Height = 25
        Caption = #9829
        TabOrder = 2
        Visible = False
        OnClick = Addtofavorite1Click
      end
      object ManualButton: TButton
        Left = 176
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Manual'
        TabOrder = 3
        Visible = False
        OnClick = ViewManual1Click
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 538
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 1
    object NoteMemo: TMemo
      AlignWithMargins = True
      Left = 9
      Top = 385
      Width = 255
      Height = 144
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alBottom
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 271
      Height = 376
      ActivePage = FavSheet
      Align = alClient
      PopupMenu = ListMenu
      TabOrder = 1
      OnChange = PageControl1Change
      object FavSheet: TTabSheet
        Caption = #9829
        object FavListView: TListView
          Left = 0
          Top = 0
          Width = 263
          Height = 340
          Align = alClient
          BorderStyle = bsNone
          Columns = <
            item
              AutoSize = True
            end>
          ColumnClick = False
          DoubleBuffered = False
          FlatScrollBars = True
          ReadOnly = True
          ParentDoubleBuffered = False
          PopupMenu = ListMenu
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = GameListViewDblClick
          OnSelectItem = GameListViewSelectItem
        end
      end
      object AllGamesSheet: TTabSheet
        Caption = 'All games'
        ImageIndex = 1
        object GameListView: TListView
          Left = 0
          Top = 0
          Width = 263
          Height = 340
          Align = alClient
          BorderStyle = bsNone
          Columns = <
            item
              AutoSize = True
            end>
          ColumnClick = False
          DoubleBuffered = False
          FlatScrollBars = True
          ReadOnly = True
          ParentDoubleBuffered = False
          PopupMenu = ListMenu
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = GameListViewDblClick
          OnSelectItem = GameListViewSelectItem
        end
      end
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = TrayMenu
    OnDblClick = TrayIconDblClick
    Left = 8
    Top = 392
  end
  object TrayMenu: TPopupMenu
    Left = 72
    Top = 392
    object ShowHide1: TMenuItem
      Caption = 'Show/Hide'
      Default = True
      OnClick = TrayIconDblClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
  object ListMenu: TPopupMenu
    OnPopup = ListMenuPopup
    Left = 136
    Top = 392
    object Run1: TMenuItem
      Caption = 'Run'
      Default = True
      OnClick = GameListViewDblClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Alternativelaunch1: TMenuItem
      Caption = 'Alternative launch'
      OnClick = Alternativelaunch1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Addtofavorite1: TMenuItem
      Caption = 'Add to favorite'
      OnClick = Addtofavorite1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object ViewManual1: TMenuItem
      Caption = 'View Manual'
      OnClick = ViewManual1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Aditional1: TMenuItem
      Caption = 'Aditional'
      object Setup1: TMenuItem
        Caption = 'Setup'
        OnClick = Setup1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Createtodesktopshortcut1: TMenuItem
        Caption = 'Create to desktop shortcut'
        OnClick = Createtodesktopshortcut1Click
      end
    end
  end
  object TimerOnClick: TTimer
    Enabled = False
    Interval = 125
    OnTimer = TimerOnClickTimer
    Left = 192
    Top = 392
  end
end
