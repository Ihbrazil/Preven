unit STL100P2T;

{Mostrar Mensagens Visuais}

{Unidade responsável pela apresentação da Mensagem Visual correspondente a
Velocidade da Digitação}

interface

uses
  Windows, ExtCtrls, Gauges, StdCtrls, Controls,
  Classes, Messages, SysUtils, Graphics, Forms, Dialogs, ComCtrls,
  jpeg, Buttons;

type
  TFRMsentinela = class(TForm)
    IMGsinalamarelo: TImage;
    IMGsinalverde: TImage;
    IMGsinalvermelho: TImage;
    PNLmensagem: TPanel;
    procedure IMGsinalvermelhoClick(Sender: TObject);
    procedure IMGsinalverdeClick(Sender: TObject);
    procedure IMGsinalamareloClick(Sender: TObject);
    procedure PNLvelocidadedigitacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRMsentinela: TFRMsentinela;

implementation

uses PRV130P1T;

{$R *.DFM}

procedure TFRMsentinela.IMGsinalvermelhoClick(Sender: TObject);
begin
    FRMsentinela.Visible := False;
end;

procedure TFRMsentinela.IMGsinalverdeClick(Sender: TObject);
begin
    FRMsentinela.Visible := False;
end;

procedure TFRMsentinela.IMGsinalamareloClick(Sender: TObject);
begin
    FRMsentinela.Visible := False;
end;

procedure TFRMsentinela.PNLvelocidadedigitacaoClick(
  Sender: TObject);
begin
    FRMsentinela.Visible := False;
end;

procedure TFRMsentinela.FormShow(Sender: TObject);
begin
    Left := Screen.WorkAreaWidth - Width;
    Top := Screen.WorkAreaHeight - Height;
    Sleep (10000);
    Close;
end;

end.
