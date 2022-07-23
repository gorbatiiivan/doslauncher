object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 676
  ClientWidth = 1110
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ShowHint = True
  SnapBuffer = 4
  StyleElements = [seFont, seClient]
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
    TabOrder = 1
    StyleElements = []
    OnChange = FindEditChange
    OnContextPopup = FindEditContextPopup
    OnKeyDown = FindEditKeyDown
  end
  object MainPanel: TPanel
    Left = 0
    Top = 5
    Width = 817
    Height = 548
    BevelOuter = bvNone
    TabOrder = 0
    object MainSplitter: TSplitter
      AlignWithMargins = True
      Left = 366
      Top = 27
      Height = 521
      Margins.Left = 0
      Margins.Top = 27
      Margins.Right = 0
      Margins.Bottom = 0
      AutoSnap = False
      ResizeStyle = rsUpdate
      OnMoved = MainSplitterMoved
      ExplicitLeft = 512
      ExplicitTop = 264
      ExplicitHeight = 100
    end
    object PageControl2: TPageControl
      AlignWithMargins = True
      Left = 369
      Top = 25
      Width = 448
      Height = 523
      Margins.Left = 0
      Margins.Top = 25
      Margins.Right = 0
      Margins.Bottom = 0
      ActivePage = TabSheet2
      Align = alClient
      DoubleBuffered = False
      ParentDoubleBuffered = False
      Style = tsFlatButtons
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        TabVisible = False
        object VideoSplitter: TSplitter
          Left = 0
          Top = 290
          Width = 440
          Height = 3
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          ResizeStyle = rsUpdate
          ExplicitTop = 265
          ExplicitWidth = 68
        end
        object NotesBox: TMemo
          AlignWithMargins = True
          Left = 2
          Top = 23
          Width = 436
          Height = 265
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alTop
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWhite
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          StyleElements = [seBorder]
          OnContextPopup = NotesBoxContextPopup
        end
        object Panel1: TPanel
          Left = 0
          Top = 293
          Width = 440
          Height = 220
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Image2: TImage
            AlignWithMargins = True
            Left = 191
            Top = 6
            Width = 243
            Height = 208
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            Align = alClient
            Center = True
            Stretch = True
            OnClick = Image1Click
            ExplicitLeft = 39
            ExplicitTop = 0
            ExplicitWidth = 27
            ExplicitHeight = 210
          end
          object PageControl3: TPageControl
            Left = 0
            Top = 0
            Width = 185
            Height = 220
            ActivePage = CoverSheet
            Align = alLeft
            Style = tsFlatButtons
            TabOrder = 0
            object VideoSheet: TTabSheet
              Caption = 'VideoSheet'
              TabVisible = False
              object VideoBox: TPanel
                Left = 0
                Top = 0
                Width = 177
                Height = 210
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                OnClick = VideoBoxClick
              end
            end
            object CoverSheet: TTabSheet
              Caption = 'CoverSheet'
              ImageIndex = 1
              TabVisible = False
              object Image1: TImage
                Left = 0
                Top = 0
                Width = 177
                Height = 210
                Align = alClient
                Center = True
                Stretch = True
                OnClick = Image1Click
                ExplicitTop = -6
                ExplicitWidth = 145
                ExplicitHeight = 151
              end
            end
          end
        end
        object ComboBox1: TComboBox
          Left = 0
          Top = 0
          Width = 440
          Height = 21
          Align = alTop
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          Style = csDropDownList
          DropDownCount = 16
          ExtendedUI = True
          TabOrder = 2
          StyleElements = []
          OnChange = ComboBox1Change
          OnDrawItem = ComboBox1DrawItem
        end
      end
    end
    object SysPanel: TPanel
      Left = 384
      Top = -1
      Width = 184
      Height = 25
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object MinButton: TSpeedButton
        Left = 267
        Top = 0
        Width = 23
        Height = 22
        Hint = 'Minimize'
        Caption = '_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = MinButtonClick
      end
      object CloseButton: TSpeedButton
        Left = 296
        Top = 0
        Width = 23
        Height = 22
        Hint = 'Close'
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = CloseButtonClick
      end
      object SysLabel: TLabel
        Left = 0
        Top = 0
        Width = 42
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        StyleElements = [seClient, seBorder]
      end
    end
    object TabControl: TTabControl
      Left = 0
      Top = 0
      Width = 366
      Height = 548
      Align = alLeft
      Enabled = False
      Style = tsButtons
      TabOrder = 2
      OnChange = TabControlChange
      object DosMainList: TListBox
        Left = 4
        Top = 6
        Width = 358
        Height = 538
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
        OnKeyDown = DosMainListKeyDown
        OnKeyUp = DosMainListKeyUp
        OnMouseDown = DosMainListMouseDown
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
      ShortCut = 13
      OnClick = ADblClickonListBoxExecute
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Extras1: TMenuItem
      Caption = 'Additional apps'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Addtofavorit1: TMenuItem
      Caption = 'Add to favorite'
      OnClick = Addtofavorit1Click
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object Manual1: TMenuItem
      Caption = 'View Manual'
      ShortCut = 114
      OnClick = AManualViewExecute
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Aditional1: TMenuItem
      Caption = 'Aditional'
      object Install1: TMenuItem
        Caption = 'Install/Uninstall'
        OnClick = Install1Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object Desktopshortcut1: TMenuItem
        Caption = 'Create desktop shortcut'
        object Selectedgame1: TMenuItem
          Caption = 'Selected game'
          OnClick = Selectedgame1Click
        end
        object Createdesktoptabshortcut1: TMenuItem
          Caption = 'All games in tab'
          OnClick = Createdesktoptabshortcut1Click
        end
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Scangamesinthistab1: TMenuItem
        Caption = 'Scan games in this tab'
        OnClick = Scangamesinthistab1Click
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object FullScreen1: TMenuItem
      AutoCheck = True
      Caption = 'Fullscreen'
      ShortCut = 122
      OnClick = AFullScreenExecute
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object AboutHelp1: TMenuItem
        Caption = 'About / Help'
        ShortCut = 112
        OnClick = AAboutExecute
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object Style1: TMenuItem
        Caption = 'Style'
        object Classic1: TMenuItem
          AutoCheck = True
          Caption = 'Classic'
          RadioItem = True
          OnClick = Classic1Click
        end
        object Blue1: TMenuItem
          AutoCheck = True
          Caption = 'Blue'
          RadioItem = True
          OnClick = Classic1Click
        end
        object Dark1: TMenuItem
          AutoCheck = True
          Caption = 'Dark'
          RadioItem = True
          OnClick = Classic1Click
        end
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object FullScreenonstartup1: TMenuItem
        AutoCheck = True
        Caption = 'Fullscreen on startup'
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object Showpriority1: TMenuItem
        Caption = 'Show priority'
        object Images1: TMenuItem
          AutoCheck = True
          Caption = 'Images'
          RadioItem = True
          OnClick = Images1Click
        end
        object Videos1: TMenuItem
          AutoCheck = True
          Caption = 'Videos'
          RadioItem = True
          OnClick = Images1Click
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
      object N3: TMenuItem
        Caption = '-'
      end
      object CheckforUpdate1: TMenuItem
        Caption = 'Check for Update'
        Enabled = False
        OnClick = CheckforUpdate1Click
      end
    end
    object N13: TMenuItem
      Caption = '-'
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
  object VideoEndTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = VideoEndTimerTimer
    Left = 20
    Top = 387
  end
  object TimerOnClick: TTimer
    Enabled = False
    OnTimer = TimerOnClickTimer
    Left = 20
    Top = 339
  end
  object ActionList: TActionList
    Left = 20
    Top = 291
    object ATabChange: TAction
      Caption = 'TTab'
      ShortCut = 16393
      OnExecute = ATabChangeExecute
    end
    object AAbout: TAction
      Caption = 'AAbout'
      ShortCut = 112
      OnExecute = AAboutExecute
    end
    object AFullScreen: TAction
      Caption = 'AFullScreen'
      ShortCut = 122
      OnExecute = AFullScreenExecute
    end
    object ADblClickonListBox: TAction
      Caption = 'ADblClickonListBox'
      ShortCut = 13
      OnExecute = ADblClickonListBoxExecute
    end
    object AVolDown: TAction
      Caption = 'AVolDown'
      ShortCut = 16424
      OnExecute = AVolDownExecute
    end
    object AVolUP: TAction
      Caption = 'AVolUP'
      ShortCut = 16422
      OnExecute = AVolUPExecute
    end
    object APlayPause: TAction
      Caption = 'APlayPause'
      ShortCut = 19
      OnExecute = APlayPauseExecute
    end
    object AManualView: TAction
      Caption = 'AManualView'
      ShortCut = 114
      OnExecute = AManualViewExecute
    end
  end
end
