object ScreenImageForm: TScreenImageForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 480
  ClientWidth = 640
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  WindowState = wsMaximized
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 15
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
    Center = True
    Proportional = True
    Stretch = True
    OnClick = Image1Click
    ExplicitLeft = 184
    ExplicitTop = 160
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
end
