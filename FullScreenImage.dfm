object FullScreenForm: TFullScreenForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FullScreenForm'
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
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 15
  object FullScreenImage: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
    Center = True
    Proportional = True
    Stretch = True
    OnMouseUp = FormMouseUp
    ExplicitLeft = 72
    ExplicitTop = 128
    ExplicitWidth = 504
    ExplicitHeight = 208
  end
end
