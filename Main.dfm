object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = #181'launcher'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 21
  object MainPanel: TPanel
    Left = 289
    Top = 0
    Width = 335
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object NotesMemo: TMemo
      Left = 0
      Top = 0
      Width = 335
      Height = 201
      Margins.Top = 30
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MediaPanel: TPanel
      Left = 0
      Top = 201
      Width = 335
      Height = 240
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object DISCImage: TImage
        Left = 17
        Top = 17
        Width = 105
        Height = 105
        Center = True
        Proportional = True
        Stretch = True
        OnClick = DISCImageClick
      end
      object BoxFrontImage: TImage
        Left = 128
        Top = 16
        Width = 105
        Height = 105
        Center = True
        Proportional = True
        Stretch = True
        OnClick = DISCImageClick
      end
      object TitleImage: TImage
        Left = 16
        Top = 128
        Width = 105
        Height = 105
        Center = True
        Proportional = True
        Stretch = True
        OnClick = DISCImageClick
      end
      object ScreenShootImage: TImage
        Left = 128
        Top = 128
        Width = 105
        Height = 105
        Center = True
        Proportional = True
        Stretch = True
        OnClick = DISCImageClick
      end
    end
  end
  object GameListView: TListView
    Left = 0
    Top = 0
    Width = 289
    Height = 441
    Align = alLeft
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
      end>
    ColumnClick = False
    FlatScrollBars = True
    Groups = <
      item
        Header = 'Favorites'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'All games'
        GroupID = 1
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    GroupView = True
    ReadOnly = True
    PopupMenu = ListMenu
    ShowColumnHeaders = False
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = GameListViewDblClick
    OnSelectItem = GameListViewSelectItem
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
