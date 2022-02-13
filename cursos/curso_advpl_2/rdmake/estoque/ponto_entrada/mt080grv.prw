#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TBICONN.CH"
/* WORKFLOW PARA INFORMAR A CONTABILIDADE QUE FOI INCLUIDA UMA TES NOVA 
E A CONTABILIDADE CRIAR O LANCAMENTO PADRAO
CLAUDIA CABRAL 31/08/2009*/
USER FUNCTION  MT080GRV()         
Local oProcess
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cCodTES, cTexto, cAssunto
Local cxxpath := getPvProfString(getenvserver(),"ROOTPATH","ERROR", GETADV97())

u_GerA0003(ProcName())

// \\172.16.0.10\MP8\Protheus_DataTST


IF INCLUI  .and. ! "TST" $ ALLTRIM(cXXPath)
// so envia na inclusao da TES
	cCodTES := SF4->F4_CODIGO

	// Código extraído do cadastro de processos.
	cCodProcesso := "INCTES"

	// Arquivo html template utilizado para montagem da aprovação
	cHtmlModelo := "\workflow\INCTES.htm"

	// Assunto da mensagem
	cAssunto := "Inclusao de TES "

	// Registre o nome do usuário corrente que esta criando o processo:
	//cUsuarioProtheus:= SubStr(cUsuario,7,15)
    cUsuarioProtheus:= cUsername // alterado para versa0 10
	// Inicialize a classe TWFProcess e assinale a variável objeto oProcess:
	oProcess := TWFProcess():New(cCodProcesso, cAssunto) 

	// Crie uma tarefa.
	oProcess:NewTask(cAssunto, cHtmlModelo)  


	conout("(INICIO|INCTES)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

	// Crie um texto que identifique a etapas a etapa do processo que foi realizado
	// para futuras consultas na janela de rastreabilidade.
	cTexto := "Iniciando o aviso da " + cAssunto + cCodTES

	// Informe o codigo de status correspondente a essa etapa.
	cCodStatus := "100100" // Código do cadastro de status de processo

	// Repasse as informações para o método responsavel pela rastreabilidade.
	oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)  // Rastreabilidade

	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Gerando solicitação para envio..."
	cCodStatus := "100200" 
	oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)

	// Assinale novos valores às macros existentes no html:
	oProcess:oHtml:ValByName("F4_COD"     , cCodTES)
	oProcess:oHtml:ValByName("F4_DESC"	  , SF4->F4_FINALID)
	oProcess:oHtml:ValByName("F4_MENNOTA" , SF4->F4_MENNOTA)
	oProcess:oHtml:ValByName("F4_CF"      , SF4->F4_CF)         
	// Repasse o texto do assunto criado para a propriedade especifica do processo.
	oProcess:cSubject := cAssunto
	
	// Informe o endereço eletrônico do destinatário.
	oProcess:cTo := "inctes"
	
	// Utilize a funcao WFCodUser para obter o codigo do usuario protheus.
//	oProcess:UserSiga := WFCodUser(SubStr(cUsuario,7,15))  //Alterado para versao 10
   oProcess:UserSiga := WFCodUser(cUsername) 
   
   
	cMailID := oProcess:Start()
	
	cHtmlModelo := "\workflow\wflink.htm"
	
	oProcess:NewTask(cAssunto, cHtmlModelo)  
	conout("(INICIO|WFLINK)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )
	
	// Repasse o texto do assunto criado para a propriedade especifica do processo.
	oProcess:cSubject := cAssunto
	
	// Informe o endereço eletrônico do destinatário.
	WF1->(DBSEEK(XFILIAL("WF1") + "INCTES" ))
	If WF1->(FieldPos("WF1_XEMAIL")) > 0
		oProcess:cTo := Alltrim(WF1->WF1_XEMAIL)//"claudia.cabral@bgh.com.br"
	ELSE	
		oProcess:cTo := "paulo.francisco@bgh.com.br;edson.rodrigues@bgh.com.br"
	ENDIF	
	oProcess:ohtml:ValByName("usuario","usuario")
	
	oProcess:ohtml:ValByName("proc_link","http://172.16.0.10:8085/messenger/emp"+cempant+"/inctes/"+ cMailID + ".htm")
	
	oProcess:ohtml:ValByName("referente",cAssunto)
	
	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Enviando solicitação..."
	cCodStatus := "100300"
	oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus) 
	
	
	// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
	// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
	// ao destinatário.
	oProcess:Start()


ENDIF
return .t.
