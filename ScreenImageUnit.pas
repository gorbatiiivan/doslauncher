unit ScreenImageUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TScreenImageForm = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TScreenImageForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
Close;
end;

procedure TScreenImageForm.Image1Click(Sender: TObject);
begin
Close;
end;

end.
