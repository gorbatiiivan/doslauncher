unit ScreenImageUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TScreenImageForm = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ScreenImageForm: TScreenImageForm;

implementation

{$R *.dfm}

uses Main;

procedure TScreenImageForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=VK_LEFT) then
Image1.Picture.WICImage := MainForm.Image1.Picture.WICImage else
if (Key=VK_RIGHT) then
Image1.Picture.WICImage := MainForm.Image2.Picture.WICImage else
Close;
end;

procedure TScreenImageForm.Image1Click(Sender: TObject);
begin
Close;
end;

end.
