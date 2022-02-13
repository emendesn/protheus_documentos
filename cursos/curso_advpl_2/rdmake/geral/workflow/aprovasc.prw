#INCLUDE "Protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APROVASC  ºAutor  ³Graziella Bianchin  º Data ³  01/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function WFW120S()
Local xSolCom := SC1->C1_NUM

u_GerA0003(ProcName())

//PREPARE ENVIRONMENT EMPRESA("01") FILIAL("01")

//cria processo do workflow
ConOut("Envio de Solicitações de Compras")
oProcess:=TWFProcess():New("000001","Envio de Solicitações de Compras")
oProcess:NewTask('Inicio',"c:\workflow\OPTORA.htm")
oHtml   := oProcess:oHtml
			
oHtml:valbyname("cNum"		 , SC1->C1_NUM		) 	//NUMERO
oHtml:valbyname("Emiss"  	 , SC1->C1_EMISSAO	)	//DATA EMISSAO
oHtml:valbyname("cSolicit"   , SC1->C1_SOLICIT	)	//SOLICITANTE

aAdd( (oHtml:valbyname("it.cItem"    		)), SC1->C1_ITEM	)							//ITEM DA SAOLICITACAO
aAdd( (oHtml:valbyname("it.cCod"    		)), SC1->C1_PRODUTO	)							//CODIGO DO PRODUTO
aAdd( (oHtml:valbyname("it.cDescri"    		)), SC1->C1_DESCRI	)							//DESCRICAO DO PRODUTO
aAdd( (oHtml:valbyname("it.cLocal"    		)), SC1->C1_LOCAL	)							//LOCAL DO PRODUTO
aAdd( (oHtml:valbyname("it.cUM"	    		)), SC1->C1_UM		)							//UNIDADE DE MEDIDA
aAdd( (oHtml:valbyname("it.cQuant"  		)),TRANSFORM( SC1->C1_QUANT,'@E 9999999' ))	//QUANTIDADE REQUISITADA
aAdd( (oHtml:valbyname("it.Obs"	    		)), SC1->C1_OBS)								//OBSERVACAO DA SOLICITACAO
		
//SC1->C1_WFID := oProcess:fProcessID
	
dbSelectArea("SAJ")
dbGotop()
dbSetorder(1)
dbSeek(xFilial()+"000010")	
While !SAJ->(EOF())
	oHtml:valbyname("c7aprova", SAJ->AJ_USER )			//APROVADORES DE SOLICITACAO
	SAJ->(dbSkip())
Enddo
_user := Subs(cUsuario,7,15) 
oProcess:ClientName(_user)
oProcess:cTo      := "edson.rodrigues@bgh.com.br"
oProcess:cBCC     := ''
oProcess:cSubject := "Solicitação de Compras " + xSolCom
oProcess:cBody    := ""
//oProcess:bReturn  := "U_WFK1A()"
		
oProcess:Start()
//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"ANASOC",'100100',"Envio de solicitações de Compras",cUsername)
oProcess:Free()
oProcess:= Nil
		
WFSendMail()

//RESET ENVIRONMENT
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFK0001   ºAutor  ³Microsiga           º Data ³  02/15/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFK1A()
Local cEmaRej		:=""
Local nVezes 		:= 1
Local cFiltraSCP 	:= ""
Local xSolCom		:= oProcess:oHtml:RetByName("cNum")


ConOut("Iniciando Atualizacao da Solicitação de Compras")

dbSelectArea("SC1")
dbGoTop()
dbSetOrder(1)
dbSeek(xFilial()+xSolCom)
While SC1->(!EOF()) .And. (SC1->C1_NUM = xSolCom) 

	RecLock("SC1",.F.)
	SC1->C1_APROV:= oProcess:oHtml:RetByName("RBAPROVA")
	SC1->C1_OBS  := oProcess:oHtml:RetByName("c7aprova")
	SC1->C1_WFID := oProcess:fProcessID
	MsUnlock()

	SC1->(DBSKIP())
Enddo
Return
