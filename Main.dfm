object MainForm: TMainForm
  Left = 0
  Top = 0
  ActiveControl = MainList
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
  object MainList: TListBox
    Left = 32
    Top = 24
    Width = 488
    Height = 561
    Style = lbOwnerDrawFixed
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
    OnClick = MainListClick
    OnDblClick = MainListDblClick
    OnDrawItem = MainListDrawItem
    OnKeyDown = FormKeyDown
    OnMouseDown = MainListMouseDown
  end
  object ListMenu: TPopupMenu
    OnPopup = ListMenuPopup
    Left = 16
    Top = 616
    object Run1: TMenuItem
      Caption = 'Run'
      Default = True
      OnClick = MainListDblClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Open1: TMenuItem
      Caption = 'Open'
      OnClick = Open1Click
    end
    object AlternateLauncher: TMenuItem
      Caption = 'Alternative Launcher'
      OnClick = AlternateLauncherClick
    end
    object Install1: TMenuItem
      Caption = 'Install'
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
    object N3: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object DefaultRun1: TMenuItem
        Caption = 'Default run'
        object Default1: TMenuItem
          Caption = 'Default'
          RadioItem = True
          OnClick = Default1Click
        end
        object AlternativeLauncher1: TMenuItem
          Caption = 'Alternative Launcher'
          RadioItem = True
          OnClick = AlternativeLauncher1Click
        end
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object CheckforUpdate1: TMenuItem
      Caption = 'Check for Update'
      OnClick = CheckforUpdate1Click
    end
  end
end
