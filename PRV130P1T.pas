unit PRV130P1T;

{Verificar Atividades do Usu�rio}

{Programa destinado � monitora��o dos perif�ricos de entrada de dados. A
monitora��o consiste em verificar a atividade do teclado e do mouse durante
um tempo pr�-estabelecido pelo usu�rio. Transcorrido este tempo ocorre o
bloqueio destes perif�ricos. Ap�s o t�rmino do pausa ocorre a libera��o dos
mesmos. Durante o pausa � apresentado um conjunto de mensagens.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Menus, ActnPopup,
  PlatformDefaultStyleActnCtrls;

type
  TFRMverificaratividadesusuario = class(TForm)
    PNLpreven: TPanel;
    TMRverificaratividadesusuario: TTimer;
    GBXcontroles: TGroupBox;
    LBLlimitediario: TLabel;
    LBLSAIDAhorafimatividade: TLabel;
    LBLSAIDAtempoatividade: TLabel;
    LBLtempoatividade: TLabel;
    TMRtecladomouse: TTimer;
    TYIprevenbackground: TTrayIcon;
    PopupActionBarpreven: TPopupActionBar;
    Sobre1: TMenuItem;
    N1: TMenuItem;
    Desativar1: TMenuItem;
    N2: TMenuItem;
    Sair1: TMenuItem;
    Minimizar1: TMenuItem;
    Pausa1: TMenuItem;
    Pular1: TMenuItem;
    Adiar1: TMenuItem;
    Pausar1: TMenuItem;
    ipo1: TMenuItem;
    Infantil1: TMenuItem;
    Adulto1: TMenuItem;
    TMRsentinela: TTimer;
    Modo1: TMenuItem;
    Claro: TMenuItem;
    Escuro: TMenuItem;
    Leitura1: TMenuItem;
    Ajuda1: TMenuItem;
    Doao1: TMenuItem;
    procedure TMRverificaratividadesusuarioTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMRtecladomouseTimer(Sender: TObject);
    procedure TKIprevenbackgroundClick(Sender: TObject);
    procedure Desativar1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure TYIprevenbackgroundClick(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Pausar1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure Adiar1Click(Sender: TObject);
    procedure Pular1Click(Sender: TObject);
    procedure Infantil1Click(Sender: TObject);
    procedure Adulto1Click(Sender: TObject);
    procedure Leitura1Click(Sender: TObject);
    procedure EscuroClick(Sender: TObject);
    procedure ClaroClick(Sender: TObject);
    procedure Doao1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FRMverificaratividadesusuario: TFRMverificaratividadesusuario;
  T_hfimatividade,{Vari�vel destinada ao armazenamento da hora do fim das
                     atividades}
  T_hiniatv,{Marca o instante do in�cio das atividades}
  T_hinipausa,{Marca o instante do in�cio das pausa}
  T_hcorrente,{Marca a hora corrente}
  T_tempoatividadediaria,
  T_tempopresalvamento,
  T_tempolimite,{Cont�m a dura��o m�xima das atividades}
  T_tempopausa,{Cont�m a dura��o do pausa}
  T_sinalpausa,{� um contador cujo valor m�ximo � igual ao tempo pausa.
                  Sofre decr�scimos de 1 segundo, ao atingir o valor de zero
                  segundo sinaliza que o pausa j� foi realizado.}
  T_sinalatividade,{� um contador que sofre acr�scimos quando os perif�ricos de
                    entrada est�o em atividades. Seu valor m�ximo � o

                    "T_tempopausa". Tamb�m sofre decr�scimos de 1 segundo, ao
                    atingir o valor de zero segundo sinaliza que n�o existe
                    atividades}
  T_cntpausa,{� um contador que sofre acr�scimos quando os perif�ricos de
            entrada foram interrompidos, at� atingir o valor do
            "T_tempopausa". Neste momento s�o restauradas as atividades}
  T_cntatv: ttime;{� um contador que sofre acr�scimos quando os perif�ricos de
            entrada est�o em atividade, at� atingir o valor do "T_tempolimite".
            Neste momento s�o interrompidas as atividades}
  B_ativataskicon,{Vari�vel booleana que coloca o sistema em background se for
                          verdadeira}
  B_publicoalvoinfantil, {Vari�vel booleana que habilita p�blico alvo Infantil se
                               for verdadeira}
  B_arquivossalvos : boolean; {Vari�vel booleana que habilita a interrup��o se
                               for verdadeira}

implementation

uses PRV130P1U, PRV130P2T, PRV130P3T, Vcl.Themes, Vcl.Styles, ShellAPI;

{$R *.DFM}

procedure TFRMverificaratividadesusuario.TMRverificaratividadesusuarioTimer(Sender: TObject);
var
   I_DesligarComputadorAgora, I_FazerPausaAgora: integer;
begin
  if B_ativataskicon = True then
    begin
     TYIprevenbackground.Visible := True;
     FRMverificaratividadesusuario.Visible := False;
     B_ativataskicon := False;
    end;

  {Algoritimo principal}
  T_hcorrente := time();
  if T_hfimatividade <= T_hcorrente then
  {Verifica o tempo m�ximo de atividade di�ria, informa-se o mesmo foi
  ultrapassado. Pergunta se o usu�rio deseja desligar o computador.
  Caso positivo, informa que deve-se salvar os trabalhos abertos.
  Caso negativo reinicia o sistema.}
    begin
      TMRverificaratividadesusuario.Enabled := False;
      T_hiniatv := T_hcorrente;

      I_DesligarComputadorAgora := Application.MessageBox('Atividade Di�ria Ultrapassada. Deseja Desligar Computador Agora?',
      'Preven - Sistema de Preven��o', mb_YesNo + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);

      Case I_DesligarComputadorAgora of
          IdNo:
            begin
              Application.MessageBox('Reiniciando o Preven Agora!', 'Preven - Sistema de Preven��o',
                         mb_Ok + mb_IconInformation + mb_DefButton1 + MB_SYSTEMMODAL);
              // Reinicializa��o de Vari�veis para um novo Expediente.
              T_hcorrente := time();
              T_hfimatividade := T_hcorrente + T_tempoatividadediaria;
              TMRverificaratividadesusuario.Enabled := True;
            end;
          IdYes:
              Application.MessageBox('Lembre-se de Salvar Seu Trabaho. Depois Desligue Seu Computador.',
                   'Preven - Sistema de Preven��o', mb_Ok + mb_IconExclamation + mb_DefButton1 + MB_SYSTEMMODAL);
      end;
    end;
  if B_arquivossalvos = False then
     if T_cntatv > (T_tempolimite - T_tempopresalvamento) then
        begin

//**************** P�ra para receber resposta *********************
//Deseja Fazer a Pausa Agora? - Salve seus arquivos! - Prepare-se para a pausa em: ' + S_tempopresalvamento + '  Minutos.'
             MessageBeep(64);
             TMRverificaratividadesusuario.Enabled := False;
             MessageBeep(64);
//Deseja Fazer a Pausa Agora? - Salve seus arquivos! - Prepare-se para a pausa em: ' + S_tempopresalvamento + '  Minutos.'
//**************** Para para receber resposta *********************

             I_FazerPausaAgora := Application.MessageBox('Deseja Fazer a Pausa Agora?',
                'Preven - Sistema de Preven��o', mb_YesNo + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);

             Case I_FazerPausaAgora of
                IdNo:
                  begin
                    T_sinalatividade := StrToTime('00:00:00');
                    T_sinalpausa := StrToTime('00:00:00');
                    T_cntpausa := StrToTime('00:00:00');
                    T_cntatv := StrToTime('00:00:00');
                    T_hiniatv := T_hcorrente;
                    T_hinipausa := StrToTime('00:00:00');
                    T_tempopresalvamento := StrToTime('00:01:00');
                    MessageBeep(64);
                    Application.MessageBox('Pausa Cancelada', 'Preven - Sistema de Preven��o',
                                           mb_Ok + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);
                    MessageBeep(64);
                    Pausar1.Enabled := True;
                  end;
                IdYes:
                  begin
                    MessageBeep(64);
                    Application.MessageBox('Salve seus arquivos!', 'Preven - Sistema de Preven��o',
                    mb_Ok + mb_IconWarning + MB_SYSTEMMODAL);
                    MessageBeep(64);
                    B_arquivossalvos := True;
                    T_sinalatividade := StrToTime('00:00:00');
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
                    T_hiniatv := ((T_hcorrente - T_tempolimite) + T_tempopresalvamento);
                    T_cntatv := T_tempolimite - T_tempopresalvamento;
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
                    Pausar1.Enabled := False;
                  end;
             end;
//************************* Volta ap�s receber resposta ************************
             TMRverificaratividadesusuario.Enabled := True;
//************************* Volta ap�s receber resposta ************************
        end;

  if T_cntatv >= T_tempolimite then
    begin
      T_sinalpausa := T_tempopausa;
      T_cntpausa := T_hcorrente - T_hinipausa;
      if B_arquivossalvos and FRMmostrarmensagens.Visible = False then
        begin
          FRMmostrarmensagens.Show;
          Pausar1.Enabled := False;
          Desativar1.Enabled := False;
          Adiar1.Enabled := True;
          Pular1.Enabled := True;
        end;
    end
  else if (T_sinalatividade > StrToTime('00:00:00')) or Leitura1.Checked then
      begin
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
        T_cntatv := T_hcorrente - T_hiniatv;
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
        T_hinipausa := T_hcorrente;
        LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
      end;
  if T_cntpausa >= T_tempopausa then
      begin
          T_sinalatividade := StrToTime('00:00:00');
          T_sinalpausa := StrToTime('00:00:00');
          T_cntpausa := StrToTime('00:00:00');
          T_cntatv := StrToTime('00:00:00');
          T_hiniatv := T_hcorrente;
          T_hinipausa := StrToTime('00:00:00');
          B_arquivossalvos := False;
          if FRMmostrarmensagens.Visible then
             begin
                FRMmostrarmensagens.Close;
                Pausar1.Enabled := True;
                Desativar1.Enabled := True;
                Adiar1.Enabled := False;
                Pular1.Enabled := False;
             end;
          LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
          MessageBeep(64);
          Application.MessageBox('Reativacao de Atividades', 'Preven - Sistema de Preven��o',
                      mb_Ok + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);
          Pausar1.Enabled := True;
      end;
  if T_sinalpausa > StrToTime('00:00:00') then
       T_sinalpausa := T_sinalpausa - StrToTime('00:00:01')
  else {if T_sinalpausa <= StrToTime('00:00:00') then}
      begin
          T_sinalatividade := StrToTime('00:00:00');
          T_sinalpausa := StrToTime('00:00:00');
          T_cntpausa := StrToTime('00:00:00');
          T_cntatv := StrToTime('00:00:00');
          T_hiniatv := T_hcorrente;
          T_hinipausa := StrToTime('00:00:00');
          B_arquivossalvos := False;
          LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
      end;
  if T_sinalatividade > StrToTime('00:00:00') then
     begin
       T_sinalatividade := T_sinalatividade - StrToTime('00:00:01');
     end
  else
       T_sinalatividade := StrToTime('00:00:00');
end;

procedure TFRMverificaratividadesusuario.TYIprevenbackgroundClick(
  Sender: TObject);
begin
  FRMverificaratividadesusuario.Visible := True;
  Minimizar1.Enabled := True;
end;

procedure TFRMverificaratividadesusuario.FormCreate(Sender: TObject);
begin
     FRMverificaratividadesusuario.Visible := False;
     B_ativataskicon := True;
     TMRtecladomouse.Enabled := True;

{Inicializa��o de Vari�veis de Configura��o}
     T_tempolimite := StrToTime('00:50:00');
     T_tempopausa:= StrToTime('00:10:00');
     T_tempoatividadediaria := StrToTime('08:00:00');
     T_tempopresalvamento := StrToTime('00:01:00');
     T_hcorrente := time();
     T_hiniatv := T_hcorrente;
     T_hfimatividade := T_hiniatv + T_tempoatividadediaria;
     T_sinalatividade := StrToTime('00:00:00');
     T_sinalpausa := StrToTime('00:00:00');
     T_cntpausa := StrToTime('00:00:00');
     T_cntatv := StrToTime('00:00:00');
     T_hinipausa := StrToTime('00:00:00');
     B_arquivossalvos := False;
     B_publicoalvoinfantil := False;
     Infantil1.Enabled := True;
     Adulto1.Enabled := False;
     LBLSAIDAhorafimatividade.caption := TimeToStr(T_hfimatividade);
     LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
     TMRverificaratividadesusuario.Enabled := True;
     TMRtecladomouse.Enabled := True;
     Leitura1.Checked := False;
end;

procedure TFRMverificaratividadesusuario.Infantil1Click(Sender: TObject);
begin
    B_publicoalvoinfantil := True;
    Infantil1.Enabled := False;
    Adulto1.Enabled := True;
end;

procedure TFRMverificaratividadesusuario.Leitura1Click(Sender: TObject);
begin
    if Leitura1.Checked then
      begin
        Leitura1.Checked := False;
      end
    else
      begin
        Leitura1.Checked := True;
      end;
end;

procedure TFRMverificaratividadesusuario.TMRtecladomouseTimer(Sender: TObject);
begin
        if tecladomouse then
        begin
             if T_sinalatividade < T_tempopausa then
                T_sinalatividade := T_sinalatividade + StrToTime('00:00:01');
             if T_sinalpausa < T_tempopausa then
                begin
                     T_sinalpausa := T_tempopausa;
                end;
        end;
end;

procedure TFRMverificaratividadesusuario.Pausar1Click(Sender: TObject);
begin
    T_cntatv := T_tempolimite;
    TYIprevenbackground.Visible := True;
    FRMverificaratividadesusuario.Visible := False;
end;

procedure TFRMverificaratividadesusuario.Adiar1Click(Sender: TObject);
begin
    T_sinalpausa := T_tempopausa;
    T_sinalatividade := T_tempopausa;
    T_cntpausa := StrToTime('00:00:00');
    T_hinipausa := T_hcorrente;
    MessageBeep(64);
    B_arquivossalvos := False;
    if FRMmostrarmensagens.Visible then
        FRMmostrarmensagens.Close;
    if FRMverificaratividadesusuario.Visible then
        FRMverificaratividadesusuario.Visible := False;
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
    T_tempolimite := T_tempolimite + StrToTime('00:01:00');
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ F�rmula 1
    LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
    Application.MessageBox('Pausa Adiada 1 minuto', 'Preven - Sistema de Preven��o',
      mb_Ok + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);
    Pausar1.Enabled := True;
    Desativar1.Enabled := True;
    Adiar1.Enabled := False;
    Pular1.Enabled := True;
end;

procedure TFRMverificaratividadesusuario.Adulto1Click(Sender: TObject);
begin
    B_publicoalvoinfantil := False;
    Infantil1.Enabled := True;
    Adulto1.Enabled := False;
end;

procedure TFRMverificaratividadesusuario.Ajuda1Click(Sender: TObject);
begin
   ShellExecute (FRMverificaratividadesusuario.Handle,'open','Help.HTM', nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TFRMverificaratividadesusuario.ClaroClick(Sender: TObject);
begin
    TStyleManager.TrySetStyle('Windows');
    Claro.Enabled := False;
    Escuro.Enabled := True;
end;

procedure TFRMverificaratividadesusuario.EscuroClick(Sender: TObject);
begin
    TStyleManager.TrySetStyle('Windows10 Dark');
    Claro.Enabled := True;
    Escuro.Enabled := False;
end;

procedure TFRMverificaratividadesusuario.Desativar1Click(Sender: TObject);
begin
  T_sinalatividade := StrToTime('00:00:00');
  T_sinalpausa := StrToTime('00:00:00');
  T_cntpausa := StrToTime('00:00:00');
  T_cntatv := StrToTime('00:00:00');
  T_hiniatv := T_hcorrente;
  T_hinipausa := StrToTime('00:00:00');
  B_arquivossalvos := False;
  if TMRtecladomouse.Enabled = True then
     begin
         TMRverificaratividadesusuario.Enabled := False;
         TMRtecladomouse.Enabled := False;
         MessageBeep(64);
         Application.MessageBox('Interrup��o Desabilitada', 'Preven - Sistema de Preven��o',
                     mb_Ok + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);
         Desativar1.Caption := 'A&tivar';
         MessageBeep(64);
         Pausar1.Enabled := False;
         Adiar1.Enabled := False;
         Pular1.Enabled := False;
     end
  else
      begin
        TMRverificaratividadesusuario.Enabled := True;
        TMRtecladomouse.Enabled := True;
        MessageBeep(64);
        Application.MessageBox('Interrup��o Habilitada', 'Preven - Sistema de Preven��o',
             mb_Ok + mb_IconWarning + mb_DefButton2 + MB_SYSTEMMODAL);
        Desativar1.Caption := '&Desativar';
        MessageBeep(64);
        Pausar1.Enabled := True;
        Adiar1.Enabled := False;
        Pular1.Enabled := False;
      end;
end;

procedure TFRMverificaratividadesusuario.Doao1Click(Sender: TObject);
begin
{Com o Comando ShellExecute, podemos executar a abertura do Brownser padr�o no seu
sistema operacional, e nele j� abrir o link clicado}

ShellExecute (FRMverificaratividadesusuario.Handle,'open','https://www.prevenus.net/doacoes', nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TFRMverificaratividadesusuario.Minimizar1Click(Sender: TObject);
begin
    TYIprevenbackground.Visible := True;
    FRMverificaratividadesusuario.Visible := False;
    Minimizar1.Enabled := False;
end;

procedure TFRMverificaratividadesusuario.Pular1Click(Sender: TObject);
begin
  T_sinalatividade := StrToTime('00:00:00');
  T_sinalpausa := StrToTime('00:00:00');
  T_cntpausa := StrToTime('00:00:00');
  T_cntatv := StrToTime('00:00:00');
  T_hiniatv := T_hcorrente;
  T_hinipausa := StrToTime('00:00:00');
  B_arquivossalvos := False;
  if FRMmostrarmensagens.Visible then
    FRMmostrarmensagens.Close;
  LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
  MessageBeep(64);
  Application.MessageBox('Pausa Pulada', 'Preven - Sistema de Preven��o',
                      mb_Ok + mb_IconWarning + mb_DefButton1 + MB_SYSTEMMODAL);
  Pausar1.Enabled := True;
  Desativar1.Enabled := True;
  Adiar1.Enabled := False;
  Pular1.Enabled := False;
end;

procedure TFRMverificaratividadesusuario.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure TFRMverificaratividadesusuario.Sobre1Click(Sender: TObject);
begin
    FRMtelaapresentacao := TFRMtelaapresentacao.Create(Self);
    try
      FRMtelaapresentacao.ShowModal;
    finally
      FRMtelaapresentacao.Release;
    end;
end;

procedure TFRMverificaratividadesusuario.TKIprevenbackgroundClick(
  Sender: TObject);
begin
    FRMverificaratividadesusuario.visible:=TRUE;
end;

{pergunta se faz a pausa agora ou n�o e se os trabalhos da se��o foram salvos

verifica se o tempo de atividade de uma sess�o ultrapassou o limite

entra em pausa

verifica se h� atividade no teclado e mouse  ou se a interrup��o ser� aplicada somente pelo tempo

volta a atividade depois de verificar se a pausa foi realizada

decrementa sinal de pausa caso n�o houver o uso do teclado ou mouse

decrementa sinal de atividade que tem valor inicial igual a T-tempopausa at� atingir o valor igual a zero

exibe mensagens casos o teclado e o mouse estiverem ociosos

torna tela principal do Preven invis�vel

tempo m�ximo de atividade di�ria

verifica atividade do teclado e mouse, incrementa o sinalatividade no caso do uso dos mesmos ou inicia sinalpausa do valor m�ximo que � T_tempopausa

adia pausa em que x minutos

desativa ou ativa a verifica��o das atividades do usu�rio. Tanto na primeira ou segunda possibilidade � necess�rio zerar a atividade do usu�rio

ocultar a tela principal do preven

exibir a tela de configura��o das propriedades do sistema Preven

pular a pausa ou n�o fazer a pausa}


end.
