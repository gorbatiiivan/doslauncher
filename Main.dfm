object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 613
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  SnapBuffer = 4
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object cmdlabel: TLabel
    Left = 16
    Top = 568
    Width = 25
    Height = 13
    Caption = 'find \'
    Transparent = True
  end
  object FindEdit: TEdit
    Left = 100
    Top = 564
    Width = 121
    Height = 21
    AutoSize = False
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    StyleElements = []
    OnChange = FindEditChange
    OnContextPopup = FindEditContextPopup
    OnKeyDown = FindEditKeyDown
  end
  object MainPanel: TPanel
    Left = 0
    Top = 5
    Width = 576
    Height = 548
    BevelOuter = bvNone
    TabOrder = 1
    object MainSplitter: TSplitter
      AlignWithMargins = True
      Left = 497
      Top = 27
      Height = 521
      Margins.Left = 0
      Margins.Top = 27
      Margins.Right = 0
      Margins.Bottom = 0
      ResizeStyle = rsUpdate
      ExplicitLeft = 512
      ExplicitTop = 264
      ExplicitHeight = 100
    end
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 497
      Height = 548
      ActivePage = eXoDOSSheet
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Style = tsFlatButtons
      TabOrder = 0
      TabWidth = 80
      OnChange = PageControlChange
      object eXoDOSSheet: TTabSheet
        Caption = 'DOS'
        object DosMainList: TListBox
          Left = 0
          Top = 0
          Width = 489
          Height = 514
          Style = lbOwnerDrawFixed
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 22
          ParentFont = False
          Sorted = True
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          OnClick = DosMainListClick
          OnDblClick = DosMainListDblClick
          OnDrawItem = DosMainListDrawItem
          OnKeyDown = FormKeyDown
          OnMouseDown = DosMainListMouseDown
        end
      end
      object eXoWin3xSheet: TTabSheet
        Caption = 'Win3x'
        ImageIndex = 1
        object Win3xMainList: TListBox
          Left = 0
          Top = 0
          Width = 489
          Height = 514
          Style = lbOwnerDrawFixed
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 22
          ParentFont = False
          Sorted = True
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          OnClick = DosMainListClick
          OnDblClick = Win3xMainListDblClick
          OnDrawItem = DosMainListDrawItem
          OnKeyDown = FormKeyDown
          OnMouseDown = DosMainListMouseDown
        end
      end
      object eXoScummVMSheet: TTabSheet
        Caption = 'ScummVM'
        ImageIndex = 2
        object ScummVMMainList: TListBox
          Left = 0
          Top = 0
          Width = 489
          Height = 514
          Style = lbOwnerDrawFixed
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 22
          ParentFont = False
          Sorted = True
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          OnClick = DosMainListClick
          OnDblClick = ScummVMMainListDblClick
          OnDrawItem = DosMainListDrawItem
          OnKeyDown = FormKeyDown
          OnMouseDown = DosMainListMouseDown
        end
      end
    end
    object PageControl2: TPageControl
      AlignWithMargins = True
      Left = 500
      Top = 25
      Width = 76
      Height = 523
      Margins.Left = 0
      Margins.Top = 25
      Margins.Right = 0
      Margins.Bottom = 0
      ActivePage = TabSheet2
      Align = alClient
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 1
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        TabVisible = False
        object ImageBox: TImage
          Left = 0
          Top = 0
          Width = 68
          Height = 513
          Align = alClient
          Stretch = True
          ExplicitLeft = 32
          ExplicitTop = 296
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        TabVisible = False
        object VideoBox: TPanel
          Left = 0
          Top = 0
          Width = 68
          Height = 513
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
  end
  object ListMenu: TPopupMenu
    OnPopup = ListMenuPopup
    Left = 16
    Top = 504
    object Open1: TMenuItem
      Caption = 'Play'
      Default = True
      OnClick = Open1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Extras1: TMenuItem
      Caption = 'Aditional launch'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Manual1: TMenuItem
      Caption = 'View Manual'
      OnClick = Manual1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Install1: TMenuItem
      Caption = 'Install/Uninstall'
      OnClick = Install1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object FullScreen1: TMenuItem
      AutoCheck = True
      Caption = 'FullScreen'
      OnClick = FullScreen1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ShortCut = 116
      OnClick = Refresh1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object FullScreenonstartup1: TMenuItem
        AutoCheck = True
        Caption = 'FullScreen on startup'
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object Launcherstate1: TMenuItem
        Caption = 'Launcher state'
        object Simple1: TMenuItem
          AutoCheck = True
          Caption = 'Simple'
          RadioItem = True
          OnClick = Simple1Click
        end
        object Extended1: TMenuItem
          AutoCheck = True
          Caption = 'Extended'
          RadioItem = True
          OnClick = Simple1Click
        end
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object SystemTray1: TMenuItem
        Caption = 'System Tray'
        object none1: TMenuItem
          AutoCheck = True
          Caption = 'none'
          Checked = True
          RadioItem = True
          OnClick = none1Click
        end
        object Minimize1: TMenuItem
          AutoCheck = True
          Caption = 'Minimize'
          RadioItem = True
          OnClick = Minimize1Click
        end
        object Close1: TMenuItem
          AutoCheck = True
          Caption = 'Close'
          RadioItem = True
          OnClick = Close1Click
        end
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object CheckforUpdate1: TMenuItem
      Caption = 'Check for Update'
      Enabled = False
      OnClick = CheckforUpdate1Click
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = TrayMenu
    OnClick = TrayIconClick
    Left = 20
    Top = 422
  end
  object TrayMenu: TPopupMenu
    Left = 16
    Top = 464
    object Show1: TMenuItem
      Caption = 'Show'
      Default = True
      OnClick = TrayIconClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
  object PlaybackTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = PlaybackTimerTimer
    Left = 20
    Top = 387
  end
end
