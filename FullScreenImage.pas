unit FullScreenImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TFullScreenForm = class(TForm)
    FullScreenImage: TImage;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FullScreenForm: TFullScreenForm;

implementation

{$R *.dfm}

procedure TFullScreenForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Close;
end;

procedure TFullScreenForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 case Button of
   mbLeft :  Close;
   mbRight:  Close;
   mbMiddle: Close;
 end;
end;

end.
