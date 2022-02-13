#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TBICONN.CH"



/*
// MT010INC - Corresponde ao ponto de entrada do sistema que somente
//		  será executado na inclusão de novos produtos.
*/
USER Function MT010INC(nOpcao,oProcess) 

u_GerA0003(ProcName())

// Inicialmente, os parâmetros nOpcao e oProcess estarão com valores iguais a NIL.
// se nOpcao for NIL, terá o seu valor inicial igual a 0 (zero).
/*default nOpcao := 0
                        
do case
case nOpcao == 0
	U_APVInicio()
case nOpcao == 1
	U_APVRetorno(oProcess)                       	
case nOpcao == 2
	U_APVTimeOut(oProcess)       	
endcase
	
Return
                     */

/*
// APVInicio - Esta função é responsável por iniciar a criação do processo e por
//		enviar a mensagem para o destinatário.
*/
/*User Function APVInicio() 
Local oProcess
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
Local aTesEnt := {}
Local aTesSai := {}
Local aNcm    := {}
Local cxxpath := getPvProfString(getenvserver(),"ROOTPATH","ERROR", GETADV97())
// \\172.16.0.10\MP8\Protheus_DataTST


IF  "TST" $ ALLTRIM(cXXPath)
	RETURN
eNDIF
If SB1->(FieldPos("B1_WFSTAT")) > 0
	If RecLock("SB1",.f.)
		SB1->B1_WFSTAT := "1"
		MsUnLock()
		return
	EndIf
EndIf 
                   */
//cCodProduto := SB1->B1_COD

// Código extraído do cadastro de processos.
//cCodProcesso := "ATUAPR"

// Arquivo html template utilizado para montagem da aprovação
//cHtmlModelo := "\workflow\ATUAPROD.htm"

// Assunto da mensagem
//cAssunto := "Atualização de dados do produto"

// Registre o nome do usuário corrente que esta criando o processo:
//cUsuarioProtheus:= SubStr(cUsuario,7,15) //Alterado para versão 10
//cUsuarioProtheus:= cUsername

// Inicialize a classe TWFProcess e assinale a variável objeto oProcess:
//oProcess := TWFProcess():New(cCodProcesso, cAssunto) 

// Crie uma tarefa.
//oProcess:NewTask(cAssunto, cHtmlModelo)  


//conout("(INICIO|ATUAPROD)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

// Crie um texto que identifique a etapas a etapa do processo que foi realizado
// para futuras consultas na janela de rastreabilidade.
//cTexto := "Iniciando a solicitação de " + cAssunto + " do produto: " + cCodProduto

// Informe o codigo de status correspondente a essa etapa.
//cCodStatus := "100100" // Código do cadastro de status de processo

// Repasse as informações para o método responsavel pela rastreabilidade.
//oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)  // Rastreabilidade

// Adicione informacao a serem incluidas na rastreabilidade
//cTexto := "Gerando solicitação para envio..."
//cCodStatus := "100200" 
//oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)
//Pego a Descricao da NCM
/*DbSelectArea('SYD')
DbSeek(xfilial('SYD'))                      
While !Eof() .and. xFilial('SYD')==YD_FILIAL        
	aadd(aNCM,"'"+YD_TEC + "-" + ALLTRIM(YD_DESC_P) +"'")	
	SYD->(DbSkip())
EndDo

//Pego as TES (entrada /saida)
dbSelectArea('SF4')
dbSeek(xFilial('SF4')+ '001')
While !Eof() .and. xFilial('SF4')==F4_FILIAL .AND. SF4->F4_CODIGO <= '499'
	if SF4->F4_MSBLQL <> '1'
		aadd(aTesEnt,"'"+F4_CODIGO + "-" + ALLTRIM(F4_FINALID) +"'")
	ENDIF
	dbSkip()
end
dbSeek(xFilial('SF4')+ '501')
While !Eof() .and. xFilial('SF4')==F4_FILIAL .AND. SF4->F4_CODIGO >= '501'
	if SF4->F4_MSBLQL <> '1'
		aadd(aTesSai,"'"+F4_CODIGO + "-" + ALLTRIM(F4_FINALID) +"'")
	ENDIF
	dbSkip()
end                     */



// Assinale novos valores às macros existentes no html:
/*oProcess:oHtml:ValByName("B1_COD"     	, SB1->B1_COD)
oProcess:oHtml:ValByName("B1_DESC"	  	, SB1->B1_DESC)
oProcess:oHtml:ValByName("B1_TE"  	  	, aTesEnt)
oProcess:oHtml:ValByName("B1_TS"      	, aTesSai)         
oProcess:oHtml:ValByName("B1_POSIPI"  	, aNcm)
oProcess:oHtml:ValByName("B1_TEPROD"  	, SB1->B1_TE)
oProcess:oHtml:ValByName("B1_TSPROD"   	, SB1->B1_TS)
oProcess:oHtml:ValByName("B1_NCM"  		, SB1->B1_POSIPI)
oProcess:oHtml:ValByName("B1_PICMRET" 	, SB1->B1_PICMRET)
oProcess:oHtml:ValByName("B1_PICM"    	, SB1->B1_PICM)
oProcess:oHtml:ValByName("B1_IPI"     	, SB1->B1_IPI)
oProcess:oHtml:ValByName("B1_ALIQISS" 	, SB1->B1_ALIQISS)
oProcess:oHtml:ValByName("B1_PIS"     	, SB1->B1_PIS)
oProcess:oHtml:ValByName("B1_COFINS"  	, SB1->B1_COFINS)
oProcess:oHtml:ValByName("B1_CSLL"    	, SB1->B1_CSLL)
oProcess:oHtml:ValByName("B1_PPIS"    	, SB1->B1_PPIS)
oProcess:oHtml:ValByName("B1_PCOFINS" 	, SB1->B1_PCOFINS)
oProcess:oHtml:ValByName("B1_PCSll"   	, SB1->B1_PCSLL)
//oProcess:oHtml:ValByName("B1_USUARIO"   , SUBSTR(cUsuario,7,15)) //Alterado para versao 10
oProcess:oHtml:ValByName("B1_USUARIO"   ,cusername)
// Repasse o texto do assunto criado para a propriedade especifica do processo.
oProcess:cSubject := cAssunto

// Informe o endereço eletrônico do destinatário.*/
//oProcess:cTo := "atuapr"


// Utilize a funcao WFCodUser para obter o codigo do usuario protheus.
//oProcess:UserSiga := WFCodUser(SubStr(cUsuario,7,15)) 

// Informe o nome da função de retorno a ser executada quando a mensagem de
// respostas retornarem ao Workflow:
//oProcess:bReturn := "U_MT010INC(1)"

// Antes de assinalar o ID do processo no campo, é verificado se realmente o
// campo existe na tabela SB1
/*If SB1->(FieldPos("B1_WFID")) > 0
	If RecLock("SB1",.f.)
		SB1->B1_WFID := oProcess:fProcessID + oProcess:fTaskID
		MsUnLock()
	EndIf
EndIf 

// Informe o nome da função do tipo timeout que será executada se houver um timeout
// ocorrido para esse processo. Neste exemplo, será executada 5 minutos após o envio
// do e-mail para o destinatário. Caso queira-se aumentar ou diminuir o tempo, altere
// os valores das variáveis: nDias, nHoras e nMinutos.
//oProcess:bTimeOut := {{"U_MT010INC(2)", nDias, nHoras, nMinutos}}

//cMailID := oProcess:Start()

cHtmlModelo := "\workflow\wflink.htm"

oProcess:NewTask(cAssunto, cHtmlModelo)  
conout("(INICIO|WFLINK)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

// Repasse o texto do assunto criado para a propriedade especifica do processo.
oProcess:cSubject := cAssunto

// Informe o endereço eletrônico do destinatário.
WF1->(DBSEEK(XFILIAL("WF1") + "ATUAPR" ))
If WF1->(FieldPos("WF1_XEMAIL")) > 0
	oProcess:cTo := Alltrim(WF1->WF1_XEMAIL)//"claudia.cabral@bgh.com.br"
ELSE	
	oProcess:cTo := "claudia.cabral@bgh.com.br;edson.rodrigues@bgh.com.br"
ENDIF	
oProcess:ohtml:ValByName("usuario","usuario")

oProcess:ohtml:ValByName("proc_link","http://172.16.0.10:8085/messenger/emp"+cempant+"/atuapr/"+ cMailID + ".htm")

oProcess:ohtml:ValByName("referente",cAssunto)

// Adicione informacao a serem incluidas na rastreabilidade
cTexto := "Enviando solicitação..."
cCodStatus := "100300"
oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus) 


// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
// ao destinatário.
oProcess:Start()

// Adicione informacao a serem incluidas na rastreabilidade
cTexto := "Aguardando retorno..."
cCodStatus := "100400"
oProcess:Track(cCodStatus, cTexto , cUsuarioProtheus)  // Rastreabilidade
Return        */

/*
// APVRetorno - Esta função é executada no retorno da mensagem enviada
//		    pelo destinatário. O Workflow recria o processo em que
//	 	    parou anteriormente na funcao APVInicio e repassa a
//		    variável objeto oProcess por parâmetro.
*/
/*User Function APVRetorno(oProcess) 
Local nPrecoVenda
Local cCodStatus, cTexto, cCodPro
Local cTE,cTS,cPosIpi,cPicmRet,cPicm,cIpi,cAliqIss,cPis,cCofins,cCsll,cPpis,cPcofins,cPcsll
Local nC, nDias := 0, nHoras := 0, nMinutos := 10

conout("(RETORNO)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )
// Obtenha o código do produto a partir do html
cCodPro := oProcess:oHtml:RetByName("B1_COD")
// Obtenha o novos valores do produto informado pelo destinatário:
cTE      := oProcess:oHtml:RetByName("B1_TE")
cTS      := oProcess:oHtml:RetByName("B1_TS")
cPOSIPI  := oProcess:oHtml:RetByName("B1_POSIPI")
cPICMRET := oProcess:oHtml:RetByName("B1_PICMRET")
cPICM    := oProcess:oHtml:RetByName("B1_PICM")
cIPI     := oProcess:oHtml:RetByName("B1_IPI")
cALIQISS := oProcess:oHtml:RetByName("B1_ALIQISS")
cPIS     := oProcess:oHtml:RetByName("B1_PIS")
cCOFINS  := oProcess:oHtml:RetByName("B1_COFINS")
cCSLL    := oProcess:oHtml:RetByName("B1_CSLL")
cPPIS    := oProcess:oHtml:RetByName("B1_PPIS")
cPCOFINS := oProcess:oHtml:RetByName("B1_PCOFINS")
cPCSLL   := oProcess:oHtml:RetByName("B1_PCSLL")


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
// Localize o produto cadastrado na tabela SB1
If SB1->(dbSeek(xFilial("SB1") + cCodPro))
	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Atualizando dados do produto..."
	nPicmRet := Val(cPicmRet)
	nPicm    := Val(cPicm)
	nIPI     := Val(cIpi)
	nAliqIss := Val(cAliqIss)
	nPpis    := Val(cPpis)
	nPcofins := Val(cPcofins)
	nPcsll   := Val(cPcsll)
	cCodStatus := "100500"
	// Atraves do atributo :cRetFrom da classe twfprocess, é possivel obter o endereço
	// eletrônico de quem respondeu a mensagem. Obtenha-a para adiciona-la à rastreabilidade.
		oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)
	
	// Atualize os dados do produto
	If RecLock( "SB1", .f. )
		SB1->B1_TE 		:= Substr(cTE,2,3)
		SB1->B1_TS      := Substr(cTS,2,3)
		SB1->B1_POSIPI  := Substr(cPOSIPI,2,8)
		SB1->B1_PICMRET := nPICMRET
		SB1->B1_PICM    := nPICM
		SB1->B1_IPI     := nIPI
		SB1->B1_ALIQISS := nALIQISS
		SB1->B1_PIS     := Iif(Upper(cPIS)='SIM','1','2')
		SB1->B1_COFINS  := Iif(Upper(cCOFINS)='SIM','1','2')
		SB1->B1_CSLL    := Iif(Upper(cCSLL)='SIM','1','2')
		SB1->B1_PPIS    := nPPIS
		SB1->B1_PCOFINS := nPCOFINS
		SB1->B1_PCSLL   := nPCSLL
		
		MsUnLock()
	EndIf
Else
	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Não foi possível encontrar o produto: " + cCodPro
	cCodStatus := "100900"
	 oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)
EndIf
// Adicione informacao a serem incluidas na rastreabilidade
cTexto := "Finalizando o processo..."
cCodStatus := "100800" // Código do cadastro de status de processo
oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)  // Rastreabilidade
Return  */


/*
// APTimeOut - Esta função será executada a partir do Scheduler no tempo
//		   estipulado pela propriedade :bTimeout da classe TWFProcess.
//		   Caso o processo tenha sido respondido em tempo hábil, essa
//	  	   execução será descartada automaticamente.
*/
/*User Function APVTimeOut(oProcess) 
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodStatus, cHtmlModelo
Local cCodProduto, cTexto, cTitulo

cHtmlModelo := "\workflow\ATUAPROD.htm"
cTitulo := "Atualização do preço de venda"

// Adicione informacao a serem incluidas na rastreabilidade
cTexto := "Executando TIMEOUT..."
cCodStatus := "100600"
// A funcao APTimeOut é executada automaticamente pelo sistema.
// Devido nao haver usuario associado à execução, será omitido o parâmetro
// correspondente.
oProcess:Track(cCodStatus, cTexto, "Administrador")  // Rastreabilidade
// Na execução da função de timeout não se caracteriza retorno de mensagem.
// Neste caso, deve usar o método :ValByName() no lugar do método :RetByName()
// para obter os valores contidos no html.
cCodProduto := oProcess:oHtml:ValByName("B1_COD")[1]

// Finalize a tarefa anterior para não ficar pendente.
oProcess:Finish()

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

// Localize o produto na tabela SB1:
If SB1->(dbSeek(xFilial("SB1") + cCodProduto))

	// Crie uma nova tarefa aproveitando o conteúdo do html preenchido anteriormente
	// com o uso do 3º. parâmetro com o valor lógico igual a .T. (verdadeiro)
	oProcess:NewTask(cTitulo, cHtmlModelo, .T.)
	
	oProcess:aAttFiles := {}

	cTexto := "Criando nova tarefa..."
	cCodStatus := "100600"
	oProcess:Track(cCodStatus, cTexto, "Administrador")  // Rastreabilidade

	// Antes de assinalar o ID do processo no campo, verifique se realmente o campo
	// existe na tabela SB1:
	If SB1->(FieldPos("B1_WFID")) > 0
		If RecLock("SB1",.f.)
			SB1->B1_WFID := oProcess:fProcessID + oProcess:fTaskID
			MsUnLock()
		EndIf
	EndIf 

	// Acrescente a palavra "(REENVIO)" no início do assunto da mensagem para
	// reforçar que houve um timeout executado.
	If (Left(oProcess:cSubject,9) != "(REENVIO)")
		oProcess:cSubject := "(REENVIO)" + oProcess:cSubject
	EndIf

	oProcess:cTo := Alltrim(WF1->WF1_XEMAIL) //"claudia.cabral@bgh.com.br" 

	// Utilize a funcao WFCodUser para obter o codigo do usuario protheus.
	oProcess:UserSiga := WFCodUser("Edson")

	// Redefina a função de retorno a ser executada.
	oProcess:bReturn := "U_MT010INC(1)"

	// Redefina a funcao de timeout a ser executada.
	oProcess:bTimeOut := {{"U_MT010INC(2)", nDias, nHoras, nMinutos}}

	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Reenviando a solicitação..."
	cCodStatus := "100700"
	oProcess:Track(cCodStatus, cTexto, "Administrador")

	// Inicie o processo
	oProcess:Start()
Else
	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Não foi possível encontrar o produto: " + cCodProduto
	cCodStatus := "100900"  // Código do cadastro de status de processo
	oProcess:Track(cCodStatus, cTexto, "Administrador")  // Rastreabilidade
EndIf  */
  
Return