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
      Caption = 'Open'
      Default = True
      OnClick = Open1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Install1: TMenuItem
      Caption = 'Install'
      OnClick = Install1Click
    end
    object Extras1: TMenuItem
      Caption = 'Aditional launch'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ShortCut = 116
      OnClick = Refresh1Click
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
end
