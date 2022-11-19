unit PRV130P2T;

{Mostrar Mensagens}

{Unidade respons�vel pela apresenta��o da mensagem de preven��o e pela
interrup��o das atividades}

interface

uses
  Windows, ExtCtrls, Gauges, StdCtrls, Controls,
  Classes, Messages, SysUtils, Graphics, Forms, Dialogs, ComCtrls,
  jpeg;

type
  TFRMmostrarmensagens = class(TForm)
    PNLmensagem: TPanel;
    PNLprogresso: TPanel;
    TMRpausaprogresso: TTimer;
    GAGpausa: TGauge;
    LBLgrupoteste: TLabel;
    LBLsubgrupoteste: TLabel;
    PNLprotecaoteste: TPanel;
    LBLgrupo: TLabel;
    LBLsubgrupo: TLabel;
    IMGrelaxar: TImage;
    MMOstartup1: TMemo;
    MMOstartup3: TMemo;
    MMOstartup2: TMemo;
    MMOstartup4: TMemo;
    MMOstartup5: TMemo;
    MMOstartup6: TMemo;
    MMOrelaxar: TMemo;
    GAGmensagem: TGauge;
    MMOprevenus: TMemo;
    IMGstartup1: TImage;
    IMGstartup2: TImage;
    IMGstartup4: TImage;
    IMGstartup3: TImage;
    IMGstartup5: TImage;
    IMGstartup6: TImage;
    IMGprevenus: TImage;
    PNLtitulo: TPanel;
    LBLtitulo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TMRpausaprogressoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRMmostrarmensagens: TFRMmostrarmensagens;
  T_hinicio,{Marca o instante do in�cio da exibi��o da mensagem}
  T_hcorrente,{Marca a hora corrente}
  T_cnt : ttime; {� um contador que sofre acr�scimos at� atingir o valor m�ximo
                  do tempo de exibi��o da mensagem}
  MensagemAtiva : Boolean; {Vari�vel destinada ao controle do progresso do Gauge}

implementation

uses PRV130P1T;

//Fun��o que Bloqueia e Desbloqueia Teclado e Mouse
Function BlockInput(ABlockInput: boolean): Boolean; stdcall;
  external 'USER32.DLL';
//Fun��o que Bloqueia e Desbloqueia Teclado e Mouse

// tela sempre na frente
function ForceForegroundWindow(hWnd: THandle): BOOL;
var
  hCurWnd: THandle;
begin
  hCurWnd := GetForegroundWindow;
  AttachThreadInput( GetWindowThreadProcessId(hCurWnd, nil), GetCurrentThreadId, True);
  Result := SetForegroundWindow(hWnd);

  AttachThreadInput( GetWindowThreadProcessId(hCurWnd, nil), GetCurrentThreadId, False);
end;
// tela sempre na frente

{$R *.DFM}

procedure TFRMmostrarmensagens.FormCreate(Sender: TObject);
begin
    TMRpausaprogresso.Enabled := False;
    T_hinicio := StrToTime('00:00:00');
    T_hcorrente := StrToTime('00:00:00');
    T_cnt := StrToTime('00:00:00');
    GAGpausa.MaxValue := 500;
    GAGmensagem.Progress := Gagmensagem.MaxValue;
    LBLgrupo.Caption := 'Exerc�cios';
    LBLsubgrupo.Caption := 'Startup';
end;

procedure TFRMmostrarmensagens.TMRpausaprogressoTimer(Sender: TObject);
begin
// tela sempre na frente
   ForceForegroundWindow(FRMmostrarmensagens.Handle);
// tela sempre na frente
   GAGpausa.Progress := GAGpausa.Progress + 1;
   GAGmensagem.Progress := GAGmensagem.Progress - 2;
   T_hcorrente := time();
   T_cnt := T_hcorrente - T_hinicio;
   if GAGmensagem.Progress = GAGmensagem.MinValue then
      begin
        if (GAGpausa.PercentDone >= 70) then
            begin
                IMGrelaxar.Visible := True;
                MMOrelaxar.Visible := True;
                IMGstartup6.Visible:= False;
                MMOstartup6.Visible := False;
                GAGmensagem.Visible := False;
            end
        else if (GAGpausa.PercentDone >= 60) and (GAGpausa.PercentDone < 70) then
              begin
                IMGstartup6.Visible:= True;
                MMOstartup6.Visible := True;
                IMGstartup5.Visible:= False;
                MMOstartup5.Visible := False;
              end
        else if (GAGpausa.PercentDone >= 50) and (GAGpausa.PercentDone < 60) then
              begin
                IMGstartup5.Visible:= True;
                MMOstartup5.Visible := True;
                IMGstartup4.Visible:= False;
                MMOstartup4.Visible := False;
              end
        else if (GAGpausa.PercentDone >= 40) and (GAGpausa.PercentDone < 50) then
              begin
                IMGstartup4.Visible:= True;
                MMOstartup4.Visible := True;
                IMGstartup3.Visible:= False;
                MMOstartup3.Visible := False;
              end
        else if (GAGpausa.PercentDone >= 30) and (GAGpausa.PercentDone < 40) then
              begin
                IMGstartup3.Visible:= True;
                MMOstartup3.Visible := True;
                IMGstartup2.Visible:= False;
                MMOstartup2.Visible := False;
              end
        else if (GAGpausa.PercentDone >= 20) and (GAGpausa.PercentDone < 30) then
              begin
                IMGstartup2.Visible:= True;
                MMOstartup2.Visible := True;
                IMGstartup1.Visible:= False;
                MMOstartup1.Visible := False;
              end
        else if (GAGpausa.PercentDone >= 10) and (GAGpausa.PercentDone < 20) then
              begin
                IMGstartup1.Visible:= True;
                MMOstartup1.Visible := True;
                IMGprevenus.Visible:= False;
                MMOprevenus.Visible := False;
              end
        else if (GAGpausa.PercentDone < 10) then
              begin
                IMGprevenus.Visible:= True;
                MMOprevenus.Visible := True;
                GAGmensagem.Visible := True;
              end;
        GAGmensagem.Progress := GAGmensagem.MaxValue;
      end;
end;

procedure TFRMmostrarmensagens.FormShow(Sender: TObject);
begin
    if B_publicoalvoinfantil = True then
        BlockInput (True);

    TMRpausaprogresso.Enabled := True;
    T_hcorrente := time();
    T_hinicio := T_hcorrente;
    T_cnt := T_hcorrente - T_hinicio;
    MensagemAtiva := False;
    GAGmensagem.Progress := GAGmensagem.MaxValue;

    IMGprevenus.Visible := True;
    MMOprevenus.Visible := True;

    IMGrelaxar.Visible := False;
    MMOrelaxar.Visible := False;

    IMGstartup1.Visible := False;
    IMGstartup2.Visible := False;
    IMGstartup3.Visible := False;
    IMGstartup4.Visible := False;
    IMGstartup5.Visible := False;
    IMGstartup6.Visible := False;

    MMOstartup1.Visible := False;
    MMOstartup2.Visible := False;
    MMOstartup3.Visible := False;
    MMOstartup4.Visible := False;
    MMOstartup5.Visible := False;
    MMOstartup6.Visible := False;
end;

procedure TFRMmostrarmensagens.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     if B_publicoalvoinfantil = True then
        BlockInput (False);
     TMRpausaprogresso.Enabled := False;
     T_hinicio := StrToTime('00:00:00');
     T_hcorrente := StrToTime('00:00:00');
     T_cnt := StrToTime('00:00:00');
     GAGpausa.Progress := 0;
     GAGmensagem.Progress := GAGmensagem.MaxValue;
end;

end.
