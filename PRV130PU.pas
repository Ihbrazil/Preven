unit PRV130PU;
{Programa destinado � monitora��o dos perif�ricos de entrada de dados. A
monitora��o consiste em verificar a atividade do teclado e do mouse durante
um tempo pr�-estabelecido pelo usu�rio. Transcorrido este tempo ocorre o
bloqueio destes perif�ricos. Ap�s o t�rmino do repouso ocorre a libera��o dos
mesmos. Durante o repouso � apresentado um conjunto de mensagens.}
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TaskIcon, StdCtrls, Buttons, ComCtrls;

type
  TFRMverificaratividadesusuario = class(TForm)
    PNLpreven: TPanel;
    BTNFechar: TBitBtn;
    TMRverificaratividadesusuario: TTimer;
    Bevel1: TBevel;
    GBXcontroles: TGroupBox;
    LBLhorainicio: TLabel;
    LBLSAIDAhorainicio: TLabel;
    LBLhoracorrente: TLabel;
    Label5: TLabel;
    LBLSAIDAhoracorrente: TLabel;
    Label6: TLabel;
    LBLSAIDAtempoatividade: TLabel;
    LBLtempoatividade: TLabel;
    TMRtecladomouse: TTimer;
    BTNPropriedades: TBitBtn;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    LBLsinalrepouso: TLabel;
    LBLSAIDAsinalrepouso: TLabel;
    TKIprevenbackground: TTaskIcon;
    BTNInterrupcao: TBitBtn;
    procedure TMRverificaratividadesusuarioTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TKIprevenbackgroundDblClick(Sender: TObject);
    procedure BTNFecharClick(Sender: TObject);
    procedure TMRtecladomouseTimer(Sender: TObject);
    procedure BTNPropriedadesClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTNInterrupcaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRMverificaratividadesusuario: TFRMverificaratividadesusuario;
{  S_horainicioatividade,Vari�vel destinada ao armazenamento da hora do in�cio
                       das atividades}
  S_tempolimite,{Vari�vel destinada a configura��o do tempo m�ximo de atividade}
  S_tempoatividadediaria,{Vari�vel destinada a configura��o do tempo m�ximo de
                       atividade di�ria}
  S_tempoprotetortela,{Vari�vel destinada a configura��o do tempo m�ximo de
                      aus�ncia de atividade para mostrar o protetor de tela}
  S_tempopresalvamento,{Vari�vel destinada a configura��o do tempo m�ximo
                       necess�rio para o salvamento dos arquivos antes que a
                       interrup��o das atividades ocorra}
  S_temporepouso : string[8];{Vari�vel destinada a configura��o da dura��o do
                             tempo de repouso}
  S_interrupcaointermediaria,{Vari�vel destinada a configura��o da exist�ncia ou
                             n�o da interrup��o intermedi�ria}
  S_exerciciosiniciais,{Vari�vel destinada a configura��o da exist�ncia ou
                             n�o de exerc�cios iniciais}                             
  S_interrupcaotoquetempo,{Vari�vel destinada a configura��o da exist�ncia da
                          interrup��o por toque e tempo ou somente por tempo}
{  S_fiel : string[3];Vari�vel destinada a configura��o da fidelidade ou n�o �
                    interrup��o das atividades de entrada}
{  S_datacorrente,Vari�vel destinada ao armazenamento da data atual}
{  S_dataatividade : string[10];Vari�vel destinada ao armazenamento da data da atividade do
                  usu�rio}
{  S_senha : string[6];Vari�vel destinada a configura��o da senha de
                        acesso a desativa��o do sistema pelo usu�rio}
  S_numerogrupoexercicios : string[3];{Vari�vel destinada ao armazenamento do grupo
                             de exerc�cios que ser� exibido ao usu�rio}
  S_numerogrupomensagens :  string[3];{Vari�vel destinada ao armazenamento do grupo
                             de mensagens que ser� exibido ao usu�rio}
  configuracao : Text; {Vari�vel interna de arquivo texto}
  T_hfimatividade,{Vari�vel destinada ao armazenamento da hora do fim das
                     atividades}
  T_hiniatv,{Marca o instante do in�cio das atividades}
  T_hinirepouso,{Marca o instante do in�cio das repouso}
  T_hcorrente,{Marca a hora corrente}
  T_tempolimite,{Cont�m a dura��o m�xima das atividades}
  T_temporepouso,{Cont�m a dura��o do repouso}
  T_sinalrepouso,{� um contador cujo valor m�ximo � igual ao tempo repouso.
                  Sofre decr�scimos de 1 segundo, ao atingir o valor de zero
                  segundo sinaliza que o repouso j� foi realizado.}
  T_sinalatividade,{� um contador que sofre acr�scimos quando os perif�ricos de
                    entrada est�o em atividades. Seu valor m�ximo � o

                    "T_temporepouso". Tamb�m sofre decr�scimos de 1 segundo, ao
                    atingir o valor de zero segundo sinaliza que n�o existe
                    atividades}
  T_cntrep,{� um contador que sofre acr�scimos quando os perif�ricos de
            entrada foram interrompidos, at� atingir o valor do
            "T_temporepouso". Neste momento s�o restauradas as atividades}
  T_cntatv: ttime;{� um contador que sofre acr�scimos quando os perif�ricos de
            entrada est�o em atividade, at� atingir o valor do "T_tempolimite".
            Neste momento s�o interrompidas as atividades}
  B_ativataskicon,{Vari�vel booleana que coloca o sistema em background se for
                          verdadeira}
  B_arquivossalvos : boolean; {Vari�vel booleana que habilita a interrup��o se
                               for verdadeira}
  T_cntprotetortela :  ttime;{� um contador que sofre acr�scimos quando os
                               perif�ricos de entrada n�o est�o em atividade,
                               at� atingir o valor do "S_tempoprotetortela"
                               Neste momento � mostrado o protetor de tela}

implementation

uses PRV120PU, PRV142PU, PRV190PU;


{$R *.DFM}

{procedure Salvar;
begin
     AssignFile(configuracao,'PVC001A.txt');
     rewrite(configuracao);
     write(configuracao,S_horainicioatividade,S_tempolimite,S_temporepouso,
                  S_fiel,S_tempoatividadediaria,S_tempoprotetortela,
                  S_tempopresalvamento,S_interrupcaointermediaria,
                  S_interrupcaotoquetempo,S_dataatividade,S_senha,
                  S_numerogrupoexercicios,S_numerogrupomensagens,
                  S_exerciciosiniciais);
     CloseFile(configuracao);
end;}

procedure TFRMverificaratividadesusuario.TMRverificaratividadesusuarioTimer(Sender: TObject);
begin
  if B_ativataskicon = True then
    begin
     BTNFecharClick(Sender);
     B_ativataskicon := False;
    end;
  {Algoritimo principal}
  T_hcorrente := time();
  if T_hfimatividade <= T_hcorrente then
     ShowMessage('Atividade Diaria Ultrapassada');
  LBLSAIDAhoracorrente.caption := TimeToStr(T_hcorrente);
  if B_arquivossalvos = False then
     if T_cntatv > (T_tempolimite - StrToTime(S_tempopresalvamento)) then
        begin
             B_arquivossalvos := True;
             T_cntatv := T_tempolimite - StrToTime(S_tempopresalvamento);
             T_sinalatividade := StrToTime('00:00:00');
             MessageBeep(64);
             ShowMessage('salve Seus Arquivos!');
      end;
  if T_cntatv >= T_tempolimite then
   begin
    T_sinalrepouso := T_temporepouso;
    T_cntrep := T_hcorrente-T_hinirepouso;
    label6.caption := TimeToStr(T_cntrep);
    if B_arquivossalvos and FRMmostrarmensagens.Visible = False then
       FRMmostrarmensagens.Show;
   end
  else if (T_sinalatividade > StrToTime('00:00:00'))
          or (S_interrupcaotoquetempo = 'NAO') then
    begin
      T_cntatv := T_hcorrente - T_hiniatv;
      T_hinirepouso := T_hcorrente;
      LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
    end;
  if T_cntrep >= T_temporepouso then
    begin
          T_sinalatividade := StrToTime('00:00:00');
          T_sinalrepouso := StrToTime('00:00:00');
          T_cntrep := StrToTime('00:00:00');
          T_cntatv := StrToTime('00:00:00');
          T_hiniatv := T_hcorrente;
          T_hinirepouso := StrToTime('00:00:00');
          B_arquivossalvos := False;
          FRMmostrarmensagens.Close;
          ShowMessage('Reativacao de Atividades');
          label6.caption := TimeToStr(T_cntrep);
          LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
    end;
  if T_sinalrepouso > StrToTime('00:00:00') then
       T_sinalrepouso := T_sinalrepouso - StrToTime('00:00:01')
  else {if T_sinalrepouso <= StrToTime('00:00:00') then}
         begin
          T_sinalatividade := StrToTime('00:00:00');
          T_sinalrepouso := StrToTime('00:00:00');
          T_cntrep := StrToTime('00:00:00');
          T_cntatv := StrToTime('00:00:00');
          T_hiniatv := T_hcorrente;
          T_hinirepouso := StrToTime('00:00:00');
          B_arquivossalvos := False;
          label6.caption := TimeToStr(T_cntrep);
          LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
         end;
  if T_sinalatividade > StrToTime('00:00:00') then
     begin
       T_sinalatividade := T_sinalatividade - StrToTime('00:00:01');
       T_cntprotetortela := StrToTime('00:00:00');
     end
  else
     begin
       T_sinalatividade := StrToTime('00:00:00');
       T_cntprotetortela := T_cntprotetortela + StrToTime('00:00:01');
     end;
  if T_cntprotetortela > StrToTime(S_tempoprotetortela) then
{     ssvShow};
end;

procedure TFRMverificaratividadesusuario.FormCreate(Sender: TObject);
begin
     AssignFile(configuracao,'PVC001A.txt');
     {$I-}
     reset(configuracao);
     if ioresult = 0 then
        begin
          read(configuracao,S_tempolimite,S_temporepouso,
               S_tempoatividadediaria,S_tempoprotetortela,
               S_tempopresalvamento,S_interrupcaointermediaria,
               S_interrupcaotoquetempo,S_numerogrupoexercicios,
               S_numerogrupomensagens,S_exerciciosiniciais);
        end
     else
        ShowMessage('Erro, arquivo n�o encontrado');
     {$I+}
     CloseFile(configuracao);
     T_cntprotetortela := StrToTime('00:00:00');
     T_tempolimite := StrToTime(S_tempolimite);
     T_temporepouso := StrToTime(S_temporepouso);
     T_hcorrente := time();
     T_hiniatv := T_hcorrente;
     T_hfimatividade := T_hiniatv + StrToTime(S_tempoatividadediaria);
     T_sinalatividade := StrToTime('00:00:00');
     T_sinalrepouso := StrToTime('00:00:00');
     T_cntrep := StrToTime('00:00:00');
     T_cntatv := StrToTime('00:00:00');
     T_hinirepouso := StrToTime('00:00:00');
     B_arquivossalvos := False;
     LBLSAIDAhorainicio.caption := TimeToStr(T_hiniatv);
     LBLSAIDAhoracorrente.caption := TimeToStr(T_hcorrente);
     label6.caption := TimeToStr(T_cntrep);
     LBLSAIDAtempoatividade.caption := TimeToStr(T_cntatv);
     TMRverificaratividadesusuario.Enabled := True;
     TMRtecladomouse.Enabled := True;
     T_tempolimite := StrToTime('00:05:00');
     T_temporepouso := StrToTime('00:05:00');
end;

procedure TFRMverificaratividadesusuario.TKIprevenbackgroundDblClick(Sender: TObject);
begin
       FRMverificaratividadesusuario.visible:=TRUE;
end;

procedure TFRMverificaratividadesusuario.BTNFecharClick(Sender: TObject);
begin
     TKIprevenbackground.Active := True;
     FRMverificaratividadesusuario.Visible := False;
end;

procedure TFRMverificaratividadesusuario.TMRtecladomouseTimer(Sender: TObject);
begin
        if tecladomouse then
        begin
             if T_sinalatividade < T_temporepouso then
                T_sinalatividade := T_sinalatividade + StrToTime('00:00:01');
             if T_sinalrepouso < T_temporepouso then
                begin
                     T_sinalrepouso := T_temporepouso;
                end;
        end;
        label10.caption := TimeToStr(T_sinalatividade);
        LBLSAIDAsinalrepouso.caption := TimeToStr(T_sinalrepouso);
end;

procedure TFRMverificaratividadesusuario.BTNPropriedadesClick(Sender: TObject);
var
   CMD: string;
begin
  CMD := 'PRV110PP' + #0;
  WinExec(@CMD[1],sw_showmaximized);
end;

procedure TFRMverificaratividadesusuario.FormActivate(Sender: TObject);
begin
     B_ativataskicon := True
end;

procedure TFRMverificaratividadesusuario.FormShow(Sender: TObject);
begin
     if FRMtelaapresentacao.Visible then
        begin
           FRMtelaapresentacao.Close;
           FRMtelaapresentacao.Free;
        end;
end;

procedure TFRMverificaratividadesusuario.BTNInterrupcaoClick(
  Sender: TObject);
begin
  if BTNInterrupcao.Caption = 'Desativar' then
     begin
         TMRverificaratividadesusuario.Enabled := False;
         TMRtecladomouse.Enabled := False;
         ShowMessage('Interrup��o Desabilitada');
         BTNInterrupcao.Caption := 'Ativar';
     end
  else
      begin
         TMRverificaratividadesusuario.Enabled := True;
         TMRtecladomouse.Enabled := True;
         ShowMessage('Interrup��o Abilitada');
         BTNInterrupcao.Caption := 'Desativar';
      end;
end;

end.
