object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 665
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object cmdlabel: TLabel
    Left = 56
    Top = 640
    Width = 25
    Height = 13
    Caption = 'find \'
    Transparent = True
  end
  object PageControl: TPageControl
    Left = 48
    Top = 16
    Width = 497
    Height = 625
    ActivePage = eXoDOSSheet
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
        Height = 591
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
        Height = 591
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
        Height = 591
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
  object FindEdit: TEdit
    Left = 140
    Top = 636
    Width = 121
    Height = 21
    AutoSize = False
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 1
    StyleElements = []
    OnChange = FindEditChange
    OnContextPopup = FindEditContextPopup
    OnKeyDown = FindEditKeyDown
  end
  object ListMenu: TPopupMenu
    OnPopup = ListMenuPopup
    Left = 16
    Top = 616
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
      Caption = 'Install and Uninstall'
      OnClick = Install1Click
    end
    object N2: TMenuItem
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
    Top = 534
  end
  object TrayMenu: TPopupMenu
    Left = 16
    Top = 576
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
end
