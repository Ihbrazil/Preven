unit PRV130PU;
{Programa destinado à monitoração dos periféricos de entrada de dados. A
monitoração consiste em verificar a atividade do teclado e do mouse durante
um tempo pré-estabelecido pelo usuário. Transcorrido este tempo ocorre o
bloqueio destes periféricos. Após o término do repouso ocorre a liberação dos
mesmos. Durante o repouso é apresentado um conjunto de mensagens.}
 
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
{  S_horainicioatividade,Variável destinada ao armazenamento da hora do início
                       das atividades}
  S_tempolimite,{Variável destinada a configuração do tempo máximo de atividade}
  S_tempoatividadediaria,{Variável destinada a configuração do tempo máximo de
                       atividade diária}
  S_tempoprotetortela,{Variável destinada a configuração do tempo máximo de
                      ausência de atividade para mostrar o protetor de tela}
  S_tempopresalvamento,{Variável destinada a configuração do tempo máximo
                       necessário para o salvamento dos arquivos antes que a
                       interrupção das atividades ocorra}
  S_temporepouso : string[8];{Variável destinada a configuração da duração do
                             tempo de repouso}
  S_interrupcaointermediaria,{Variável destinada a configuração da existência ou
                             não da interrupção intermediária}
  S_exerciciosiniciais,{Variável destinada a configuração da existência ou
                             não de exercícios iniciais}                             
  S_interrupcaotoquetempo,{Variável destinada a configuração da existência da
                          interrupção por toque e tempo ou somente por tempo}
{  S_fiel : string[3];Variável destinada a configuração da fidelidade ou não à
                    interrupção das atividades de entrada}
{  S_datacorrente,Variável destinada ao armazenamento da data atual}
{  S_dataatividade : string[10];Variável destinada ao armazenamento da data da atividade do
                  usuário}
{  S_senha : string[6];Variável destinada a configuração da senha de
                        acesso a desativação do sistema pelo usuário}
  S_numerogrupoexercicios : string[3];{Variável destinada ao armazenamento do grupo
                             de exercícios que será exibido ao usuário}
  S_numerogrupomensagens :  string[3];{Variável destinada ao armazenamento do grupo
                             de mensagens que será exibido ao usuário}
  configuracao : Text; {Variável interna de arquivo texto}
  T_hfimatividade,{Variável destinada ao armazenamento da hora do fim das
                     atividades}
  T_hiniatv,{Marca o instante do início das atividades}
  T_hinirepouso,{Marca o instante do início das repouso}
  T_hcorrente,{Marca a hora corrente}
  T_tempolimite,{Contém a duração máxima das atividades}
  T_temporepouso,{Contém a duração do repouso}
  T_sinalrepouso,{É um contador cujo valor máximo é igual ao tempo repouso.
                  Sofre decréscimos de 1 segundo, ao atingir o valor de zero
                  segundo sinaliza que o repouso já foi realizado.}
  T_sinalatividade,{É um contador que sofre acréscimos quando os periféricos de
                    entrada estão em atividades. Seu valor máximo é o

                    "T_temporepouso". Também sofre decréscimos de 1 segundo, ao
                    atingir o valor de zero segundo sinaliza que não existe
                    atividades}
  T_cntrep,{É um contador que sofre acréscimos quando os periféricos de
            entrada foram interrompidos, até atingir o valor do
            "T_temporepouso". Neste momento são restauradas as atividades}
  T_cntatv: ttime;{É um contador que sofre acréscimos quando os periféricos de
            entrada estão em atividade, até atingir o valor do "T_tempolimite".
            Neste momento são interrompidas as atividades}
  B_ativataskicon,{Variável booleana que coloca o sistema em background se for
                          verdadeira}
  B_arquivossalvos : boolean; {Variável booleana que habilita a interrupção se
                               for verdadeira}
  T_cntprotetortela :  ttime;{É um contador que sofre acréscimos quando os
                               periféricos de entrada não estão em atividade,
                               até atingir o valor do "S_tempoprotetortela"
                               Neste momento é mostrado o protetor de tela}

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
        ShowMessage('Erro, arquivo não encontrado');
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
         ShowMessage('Interrupção Desabilitada');
         BTNInterrupcao.Caption := 'Ativar';
     end
  else
      begin
         TMRverificaratividadesusuario.Enabled := True;
         TMRtecladomouse.Enabled := True;
         ShowMessage('Interrupção Abilitada');
         BTNInterrupcao.Caption := 'Desativar';
      end;
end;

end.
