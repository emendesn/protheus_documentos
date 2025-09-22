#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

// Funcoes - para Workflow
//
// WFAlcDoc(ExpA1,ExpD1,ExpN1)
// Ped01(_aParam) - _aParam -> cFilial , nOper

USER FUNCTION WF()
U_SC({'01',1})   

USER FUNCTION WF0()
U_sc({'01',2})    // resposta

USER FUNCTION WF1()
U_sc({'01',3})    // resposta

USER FUNCTION WF2()
U_sc({'01',5})    // PC REPROVADOS

USER FUNCTION WF3()     //1
U_PedCom( {'01',1} )		// Processo de Envio de PC para aprova็ใo

USER FUNCTION WF4()
U_PedCom( {'01',2} )		// Processo de Retorno do Workflow

USER FUNCTION WF5()    //1
U_PedCom( {'01',3} )		// Processo de Resposta de Pedido Bloqueado para Comprador

USER FUNCTION WF6()
U_PedCom( {'01',4} )		// Processo de Retorno de Pedido Reprovado

USER FUNCTION WF7()     //1
U_PedCom( {'01',5} )		// Processo de Resposta de Pedido Aprovado para Comprador

USER FUNCTION WF8()
U_PedCom( {'01',6} )		// Time-out

USER FUNCTION WF9()		// Processo de Envio de E-Mail
U_xSENDMAIL( {'01'} )

USER FUNCTION WF10()//1
U_PedCom( {'01',7} )		// Processo de Envio de PC para Aprovacao NIvel 2

USER FUNCTION WF11() //1
U_PedCom( { '01',8 } )		// Processo de Envio de PC Liberado Manualmente no Sistema

//------------------------------------------------------------------------
// ENVIO DE EMAIL
//------------------------------------------------------------------------

USER FUNCTION xSENDMAIL(aParam)
If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_XCONSOLE("Parametros nao recebidos => xSENDMAIL(cEmp)" )
	RETURN
EndIf

U_XCONSOLE('xSENDMAIL() /' + aParam[1], .F. )

WFSENDMAIL({aParam[1],"01"})
RETURN

//------------------------------------------------------------------------
// RETORNO DO WORKFLOW
//------------------------------------------------------------------------

USER FUNCTION xRECMAIL()
Local aArea	:= GetArea()
Local aParam := {}

Aadd( aParam, { '01' , '02' } )
//IF aParam == Nil .OR. VALTYPE(aParam) == "U"
//	U_XCONSOLE("Parametros nao recebidos => xRECMAIL()")
//	RETURN
//EndIf

//U_XCONSOLE('xRECMAIL() /' + aParam[1] )

WFReturn({ aParam[ 1,1 ], aParam[ 1,2 ] })
RestArea( aArea )
RETURN


//------------------------------------------------------------------------
// SEMAFORO
//------------------------------------------------------------------------

USER FUNCTION xSEMAFORO(cArq, nOpc)
Local nHdl, _nCtd := 0
Local cDataTime := Space(30)

IF cArq == Nil .OR. nOpc == Nil
	U_XCONSOLE("xSEMAFORO - Sem parametros")
	RETURN
ENDIF

IF nOpc == 1	// CRIA
	While .T.
		
		IF !FILE(cArq)
			nHdl:=MSFCREATE(cArq,0)
			cDataTime := DTOC(DATE()) + " " + TIME()
			fWRITE(nHdl,cDataTime,Len(cDataTime))
			FCLOSE(nHdl)
			EXIT
		ENDIF
		
		For _nCtd := 1 TO 1000000
		Next
	END
ENDIF
IF nOpc == 2	// REMOVE
	IF File(cArq)
		fErase(cArq)
	ENDIF
ENDIF
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PG       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Solicitacao de Compras                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PG( aParam )

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_XCONSOLE("Parametros nao recebidos => PG()" )
	RETURN 
EndIf

WfPrepEnv( aParam[1], "01" )

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_XCONSOLE('PG() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_XCONSOLE('PG() /' + aParam[1] + cFilAnt)
	
	U_Rfinw01(aParam[2])
	SM0->(DBSkip())
END

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SC       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Solicitacao de Compras                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SC( aParam )
If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_XCONSOLE("Parametros nao recebidos => SC()" )
	RETURN 
EndIf

WfPrepEnv( aParam[1], "01" )

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_XCONSOLE('SC() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_XCONSOLE('SC() /' + aParam[1] + cFilAnt)
	
	U_Rcomw04(aParam[2])
	SM0->(DBSkip())
END

RETURN     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PC       บAutor  ณMicrosiga           บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WORKFLOW Pedidos de Compras                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PedCom( aParam )

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_XCONSOLE("Parametros nao recebidos => PC()" )
	RETURN 
EndIf

If FindFunction( 'WfPrepEnv' )
	WfPrepEnv( aParam[ 1 ] , "02" )
Else
	RpcSetType( 3 )
	RpcSetEnv( aParam[ 1 ], "02" )
EndIf

CHKFILE("SM0")

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(aParam[1],.F.)

U_XCONSOLE('PC() /' + aParam[1] )

WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1]
	cFilAnt	:= SM0->M0_CODFIL
	
	U_XCONSOLE('PC() /' + aParam[1] + cFilAnt)
	
		U_Rcomw01(aParam[2])
	SM0->(DBSkip())
END

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AlcAprv    Autor ณ Aline Correa do Vale   ณ  Data ณ07.08.2001ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ WFAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1 = Array com informacoes do documento                 ณฑฑ
ฑฑณ          ณ       [1] Numero do documento                              ณฑฑ
ฑฑณ          ณ       [2] Tipo de Documento                                ณฑฑ
ฑฑณ          ณ       [3] Valor do Documento                               ณฑฑ
ฑฑณ          ณ       [4] Codigo do Aprovador                              ณฑฑ
ฑฑณ          ณ       [5] Codigo do Usuario                                ณฑฑ
ฑฑณ          ณ       [6] Grupo do Aprovador                               ณฑฑ
ฑฑณ          ณ       [7] Aprovador Superior                               ณฑฑ
ฑฑณ          ณ       [8] Moeda do Documento                               ณฑฑ
ฑฑณ          ณ       [9] Taxa da Moeda                                    ณฑฑ
ฑฑณ          ณ      [10] Data de Emissao do Documento                     ณฑฑ
ฑฑณ          ณ      [11] Grupo de Compras                                 ณฑฑ
ฑฑณ          ณ ExpD1 = Data de referencia para o saldo                    ณฑฑ
ฑฑณ          ณ ExpN1 = Operacao a ser executada                           ณฑฑ
ฑฑณ          ณ       1 = Inclusao do documento                            ณฑฑ
ฑฑณ          ณ       2 = Estorno do documento                             ณฑฑ
ฑฑณ          ณ       3 = Exclusao do documento                            ณฑฑ
ฑฑณ          ณ       4 = Aprovacao do documento                           ณฑฑ
ฑฑณ          ณ       5 = Estorno da Aprovacao                             ณฑฑ
ฑฑณ          ณ       6 = Bloqueio Manual da Aprovacao                     ณฑฑ
ฑฑณ          ณ ExpC1 = Respondido a 1 Vez ou a 2						  ณฑฑ
ฑฑณ          ณ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AlcAprv(aDocto,dDataRef,nOper, cWF, lMENU , cChaveSCR, lRejeita , cOpc )
Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local aArea		:= GetArea()
Local aAreaSCS  := SCS->(GetArea())
Local aAreaSCR  := SCR->(GetArea())
Local nSaldo	:= 0
Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv := ""
Local lAchou	:= .F.
Local nRec		:= 0
Local lRetorno	:= .T.
Local aSaldo	:= {}
dDataRef := dDataBase
cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cWF	   := IIF(cWF==Nil,  "", cWF)
lMENU  := IIF(lMENU==Nil, .F., lMENU)  // SE .T. UTILIZADA VIA MENU DO SISTEMA

ConOut( ' EVENTO: [ '+ IIF( nOper == 4 , 'APROVACAO', 'REPROVACAO' )+' ] ' )
IF !lMENU
	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
ENDIF

ConOut('AlcDoc aDocto[11]: '+aDocto[11])

If nOper == 6 // Reprovacao do Documento
	
	U_XCONSOLE(" 6 -Reprovacao - CR STATUS = 04")
	
	SCR->( dbSetOrder( 2 ) )
	SCR->( MsSeek( cChaveSCR ) )
	nRec := SCR->( Recno() )
	cAuxNivel := SCR->CR_NIVEL
	lLibera := SCR->CR_XTPLIB == 'A'
	
	dbSelectArea( "PAF" )
	PAF->( dbSetOrder( 1 ) )
	If PAF->( dbSeek(xFilial( "PAF" ) + cAprov ) )
		
		dbSelectArea( 'PAG' )
		PAG->( dbSetOrder( 1 ) ) //PAG_FILIAL, PAG_CODGRP, PAG_NIVEL, PAG_IDUSER
		PAG->( dbSeek( xFilial( 'PAG' ) + cGrupo + cAprov ) )
		
	Else
		ConOut( 'NAO FOI LOCALIZADO O APROVADOR [ '+ cAprov +' ]' )
		Return .T.
	EndIf
	
	Reclock("SCR",.F.)
	CR_STATUS   := "04"
	If SCR->(FieldPos("CR_X_OBS")) > 0
		CR_X_OBS    := Trim(CR_X_OBS)+If(Len(aDocto)>10,'. (Aprovador) - '+aDocto[11],"Reprova็ao manual")
	Else
		CR_OBS    := If(Len(aDocto)>10,aDocto[11],"Reprova็ao manual")
	EndIf
	
	SCR->CR_DATREJ 	:= dDataBase
	SCR->CR_USERLIB	:= PAG->PAG_IDUSER
	SCR->CR_LIBAPRO	:= PAG->PAG_CODGRP
	SCR->CR_VALLIB		:= nValDcto
	SCR->CR_APROV		:= cAprov
	SCR->CR_RESPOST 	:= cOpc
	
	SCR->( MsUnLock() )
	SCR->( FkCommit() )

	nRecSCR				:= SCR->( RecNo() )
	cChaveSCR			:= SCR->( CR_FILIAL + CR_TIPO + CR_NUM )
	dbSelectArea( "SCR" )
	dbSetOrder( 1 )
	MsSeek( cChaveSCR )
	While !Eof() .And. SCR->( CR_FILIAL + CR_TIPO + CR_NUM ) == cChaveSCR
		If SCR->CR_STATUS <> "04"
			RecLock( "SCR", .F. )
				SCR->CR_STATUS	:= "04"
			MsUnLock()
		EndIf
		dbSkip()
	EndDo
	dbSelectArea( "SCR" )
	dbGoTo( nRecSCR )
	
	lRetorno := lLibera
	lRejeita := IIF( cOpc == 'N', .T. , .F. )
	
EndIf

If nOper == 5 // Reprovacao Justificada. Preparar para uma nova Aprovacao do Documento
	
	U_XCONSOLE(" 5 - Reaprovacao - CR STATUS = 02")
	
	Reclock("SCR",.F.)
	CR_STATUS   := "02"
	If SCR->(FieldPos("CR_X_OBS")) > 0
		CR_X_OBS    := Trim(CR_X_OBS)+'. (Solicitante) - '+aDocto[11]
	Else
		CR_OBS    := aDocto[11]
	EndIf
	CR_DATALIB  := dDataBase
	CR_USERLIB	:= SCR->CR_USER
	CR_LIBAPRO	:= SCR->CR_USER
	MsUnlock()
	
EndIf

If nOper == 4 //Aprovacao do documento
	U_XCONSOLE(" 4 -Aprovacao ")
	
	SCR->( dbSetOrder( 2 ) )
	SCR->( MsSeek( cChaveSCR ) )
	nRec := SCR->( Recno() )
	cAuxNivel := SCR->CR_NIVEL
	lLibera := SCR->CR_XTPLIB == 'A'
	
	dbSelectArea( "PAF" )
	PAF->( dbSetOrder( 1 ) )
	If PAF->( dbSeek(xFilial( "PAF" ) + cAprov ) )
		
		dbSelectArea( 'PAG' )
		PAG->( dbSetOrder( 1 ) ) //PAG_FILIAL, PAG_CODGRP, PAG_NIVEL, PAG_IDUSER
		PAG->( dbSeek( xFilial( 'PAG' ) + cGrupo + cAprov ) )
		
	Else
		ConOut( 'NAO FOI LOCALIZADO O APROVADOR [ '+ cAprov +' ]' )
		Return .T.
	EndIf
	
	// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
	IF !EMPTY(SCR->CR_WFID) .AND. lMENU
		WFKillProcess(SCR->CR_WFID)
	ENDIF
	
	U_XCONSOLE(" 4 -Aprovacao - CR STATUS = 03")
	
	SCR->( MsSeek( cChaveSCR ) )
	While SCR->( !Eof() ) .And. SCR->( CR_FILIAL + CR_TIPO + CR_NUM + CR_USER ) == cChaveSCR
		
		If AllTrim( SCR->CR_STATUS ) == '03' // Loop para Validar Quando o PD Possuir o Aprovador mais de uma Vez na Alcada
			SCR->( dbSkip() ) ; Loop
		EndIf
		
		Reclock("SCR",.F.)
		CR_STATUS	:= "03"
		If SCR->(FieldPos("CR_X_OBS")) > 0
			CR_X_OBS:= Trim(CR_X_OBS)+ If(Len(aDocto)>10,'. (Aprovador) - '+aDocto[11],"")
		Else
			CR_OBS	:= If(Len(aDocto)>10,aDocto[11],"")
		EndIf
		
		SCR->CR_DATALIB	:= dDataBase
		SCR->CR_USERLIB	:= PAG->PAG_IDUSER
		SCR->CR_LIBAPRO	:= PAG->PAG_CODGRP
		SCR->CR_VALLIB	:= nValDcto
		SCR->CR_APROV	:= cAprov
		SCR->CR_RESPOST := cOpc
		SCR->( MsUnLock() )
		SCR->( FkCommit() )

		Exit
		SCR->( dbSkip() )
	EndDo
	
	SCR->( dbSetOrder( 1 ) )
	SCR->( MsSeek( xFilial("SCR")+cTipoDoc+cDocto ) )
	While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
		U_CONSOLE(" 4 -Aprovacao - LOOP SCR ["+SCR->CR_USER+"] " + CR_FILIAL+CR_TIPO+CR_NUM )
		
		If SCR->CR_STATUS == '03' .And. SCR->CR_XTPLIB == 'V' .And. !( SCR->CR_RESPOST == CriaVar( 'CR_RESPOST' , .F. ) )
			ConOut( 'PULA O VISTADOR [ '+ SCR->CR_USER +' ] ' )
			SCR->( dbSkip() ) ; Loop
		EndIf
		
		If SCR->CR_STATUS == '01' .And. SCR->CR_XTPLIB == 'V' .And. SCR->CR_RESPOST == CriaVar( 'CR_RESPOST' , .F. )
			ConOut( 'LIBERA O VISTADOR [ '+ SCR->CR_USER +' ] ' )
			RecLock( 'SCR' , .F. )
			SCR->CR_STATUS := '02'
			SCR->( MsUnLock() )
			Exit
		EndIf
		
		If AllTrim( SCR->CR_STATUS ) == '01' .And. AllTrim( SCR->CR_XTPLIB ) == 'A'
			ConOut( 'LIBERA O APROVADOR [ '+ SCR->CR_USER +' ] ' )
			RecLock( 'SCR' , .F. )
			SCR->CR_STATUS := '02'
			SCR->( MsUnLock() )
			Exit
		EndIf
		
		
		SCR->( dbSkip() )
	EndDo

	lRetorno := lLibera
	lRejeita := IIF( cOpc == 'N', .T. , .F. )
	
EndIf

SCR->( dbGoto( nRec ) )

U_XCONSOLE(" 4 -Aprovacao - Reposiciona e verifica se ja esta totalmente liberado. ")

RestArea(aAreaSCR)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTOD  บAutor  ณMicrosiga           บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ
ฑฑบ          ณ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xSTOD(_cData)
local _dData

_dData := ctod(substr(_cData,7,2) + "/" + substr(_cData,5,2) + "/" + substr(_cData,1,4))

return(_dData)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaLink บAutor ณ Sergio Oliveira       บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFc que envia um link com o processo de workflow a ser respondiบฑฑ
ฑฑบ          ณdo.                                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCSU.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnviaLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcFilial, pcTipo, pcNumDoc, pcDescProc, pcNomAprov )

Local oP

oP := TWFProcess():New( "000010", "Link de Processos de Workflow" )
oP:NewTask("Link de Processos Workflow", "\workflow\html\link_.htm")  // Html com link para envio

oP:ohtml:valbyname("cnomeprocesso", GetMV("MV_WFDHTTP")+"/WORKFLOW/"+ cHtmlFile )
oP:ohtml:valbyname("DESCPROC", pcDescProc )
oP:ohtml:valbyname("cNomAprov", pcNomaprov )

oP:cTo  := cOldTo
oP:cCC  := cOldCC
oP:cBCC := cOldBCC
oP:csubject := cSubject

oP:start()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaWiew บAutor  ณSergio Oliveira     บ Data ณ  Jan/2005   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta funcao cria a area de trabalho e faz a contagem de    บฑฑ
ฑฑบ          ณ registros.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ<ExpC1>    : Instrucao que sera montada a query.            บฑฑ
ฑฑบ          ณ<ExpC2>    : Alias para uso no programa da area de trabalho.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ<ExpN1> : Nro de Registros no arquivo de trabalho.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MontaView( cSql, cAliasTRB )

Local nCnt := 0
Local cSql := ChangeQuery( cSql )

If Select(cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasTRB)        // Se estiver, devera ser fechado.
	DbCloseArea(cAliasTRB)
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), cAliasTRB, .T., .F. )
DbSelectArea(cAliasTRB)
DbGoTop()

DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.

Return( nCnt )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณValidPerg ณ Autor ณ                       ณ Data ณ 11/08/97 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluกndo-as caso no existam        ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_ValidPerg(cPerg, aMatriz)                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpC1: Nome do Grupo de Perguntas.                          บฑฑ
ฑฑบ          ณExpA1: Matriz contendo as perguntas.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ValidPerg(cPerg, aMatriz)

Local _sAlias := Alias()
Local _j      := 0
Local _i      := 0
Local _cPerg  := PadR(cPerg,10," ")
Local _aRegs  := aMatriz

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 to Len(_aRegs)
	
	If !DbSeek( _cPerg + _aRegs[_i,2] )
		RecLock("SX1",.t.)
		For _j := 1 to FCount()
			FieldPut( _j, _aRegs[_i,_j] )
		Next
		MsUnlock()
	Endif
	
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณDadosadv  ณ Autor ณ Sergio Oliveira       ณ Data ณ 01/2003  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Operacoes.                                                  ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_Dadosadv()                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DadosAdv()

Processa( { || OkProc() }, 'Manutencao...' )

Return

Static Function OkProc()

aStructure2 := {}

AADD( aStructure2, {'ORIGEM'    ,'C',70,0} )
AADD( aStructure2, {'DESTINO'   ,'C',70,0} )
AADD( aStructure2, {'USUARIO'   ,'C',15,0} )
AADD( aStructure2, {'COMPUTADOR','C',35,0} )
AADD( aStructure2, {'HORA'      ,'C',08,0} )
AADD( aStructure2, {'QUANDO'    ,'D',08,0} )

xApaga := U_CriaTMP( aStructure2, "WORK" )
/*
If !File('\Dadosadv\Dadosadv.dbf')
	MSCreate('\Dadosadv\Dadosadv.dbf',aStructure2,"CTREECDX")
	//DbCreate('\Tabelas\Dadosadv.dbf', aStructure2)
	U_UsarDbf( '\Dadosadv\Dadosadv.dbf', 'WORK' )
Else
	U_UsarDbf( '\Dadosadv\Dadosadv.dbf', 'WORK' )
EndIf
*/

aStructure := {}

AADD( aStructure, {'TROK'   ,'C',02,0} )
AADD( aStructure, {'ARQUIVO','C',50,0} )
AADD( aStructure, {'TAMANHO','N',10,0} )
AADD( aStructure, {'_DATA'  ,'D',08,0} )
AADD( aStructure, {'HORA'   ,'C',08,0} )
AADD( aStructure, {'ATRIBUT','C',01,0} )

_aCampos  := {}
AADD(_aCampos,{"TROK"      ,"","  "         ,""})
AADD(_aCampos,{"ARQUIVO"   ,"","Arquivo"    ,""})
AADD(_aCampos,{"TAMANHO"   ,"","Tamanho"    ,"@E 999,999,999"})
AADD(_aCampos,{"_DATA"     ,"","Data"       ,""})
AADD(_aCampos,{"HORA"      ,"","Hora"       ,""})
AADD(_aCampos,{"ATRIBUT"   ,"","Atributo"   ,"@!"})

xApaga := U_CriaTMP( aStructure, "TRB" )

aRotina   := { { "Pesquisar "   ,'U_Pesquisar()' , 0 , 1},;
{ "Deletar   "   ,'U_Deletar()'   , 0 , 2},;
{ "Parametros"   ,'U_AjuPar()'    , 0 , 3},;
{ "Mark/Desmk"   ,'U_MarkDes()'  , 0 , 4},;
{ "Copiar"       ,'U_MultiCopia()', 0 , 5} }
lInvert   := .f.
cCadastro := "Conteudo da pasta: "+AllTrim(MV_PAR01)+AllTrim(MV_PAR02)
aStr      := {}
_cMarca   := GetMark()
MarkBrow("TRB","TROK",,_aCampos,.F.,_cMarca)

Return

User Function Deletar()

If !MsgBox('Confirme para prosseguir com o processo de Delecao.','Cuidado!!!','YesNo')
	Return
EndIf

aOp  	 := {"Marcados","Atual","Cancelar"}
cTit 	 := "Deletar Arquivos"
cMsg 	 := 'Para Deletar os Arquivos Marcados'+Chr(13)
cMsg     += 'Escolha uma das Opcoes abaixo:'
nOp      := Aviso(cTit,cMsg,aOp)
_nDelete := 0

DbSelectArea('TRB')
Procregua(1)
IncProc('Estabelecendo Selecao...')
If nOp == 1      // Todos
	DbGoTop()
	While !Eof()
		If !Empty(TRB->TROK)  // Esta Marcado. Deletar.
			RecLock('TRB',.f.)
			While .t.
				If Ferase(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)) == -1
					_xArquivo := AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)
					If MsgBox('Nao esta sendo possivel deletar o arquivo '+_xArquivo+Chr(13);
						+'Tenta Novamente?','Erro no Delete','YesNo')
						Loop
					Else
						Exit
					EndIf
				Else
					_nDelete ++
					DbDelete()
					Exit
				EndIf
			EndDo
			MsUnLock()
		EndIf
		DbSkip()
	EndDo
ElseIf nOp == 2  // Deletar somente o Atual
	If !Empty(TRB->TROK)  // Esta Marcado. Deletar.
		RecLock('TRB',.f.)
		While .t.
			If Ferase(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)) == -1
				_xArquivo := AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO)
				If MsgBox('Nao esta sendo possivel deletar o arquivo '+_xArquivo+Chr(13);
					+'Tenta Novamente?','Erro no Delete','YesNo')
					Loop
				Else
					Exit
				EndIf
			Else
				_nDelete ++
				DbDelete()
				Exit
			EndIf
		EndDo
		MsUnLock()
	EndIf
Else             // Cancelar
	Return
EndIf

MsgBox('Nro. de Arquivos Deletados: '+AllTrim(Str(_nDelete)),'Arquivos Deletados','Info')

If _nDelete > 0
	MarkBRefresh()
EndIf

Return

User Function Pesquisar()

_xCopia := Space(50)

@ 355,302 To 444,722 Dialog oDglCopia Title OemToAnsi("Copia de Arquivos")
@ 004,005 To 39,202  Title OemToAnsi("Digite o arquivo a pesquisar")
@ 019,010 Get _xCopia Size 131,010
@ 014,155 BmpButton Type 1 Action(xPesq())

Activate Dialog oDglCopia Centered

Return

Static Function xPesq()

DbSelectArea('TRB')
DbSeek(AllTrim(_xCopia))

Close(oDglCopia)

MarkBRefresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjuPar   ณ Autor ณ Sergio Oliveira       ณ Data ณ Abr/2003 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Reconfiguracao dos parametros de Visualizacao.             ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             AjuPar()                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ U_Dadosadv.prw                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AjuPar()
Local xi := 0
//cPerg := "_DADSD"
cPerg := PADR("_DADSD",10," ")
aRegs := {}

aAdd(aRegs,{cPerg,"01","Path p/ Visualizar.:","","","mv_ch1","C",40,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Visualizar Extensao:","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Copiar Para........:","","","mv_ch3","C",40,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Arquivos(Branco=All)","","","mv_ch4","C",40,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","A partir da Data...:","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate a Data.........:","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg,aRegs)    //--> Cria as perguntas. Funcao na Biblioteca YpfxFun.prw

If !Pergunte(cPerg,.t.)
	Return
EndIf

_xzArquivos := AllTrim(IIF( Empty(MV_PAR04),'*', MV_PAR04))

aDirectory := Directory(AllTrim(MV_PAR01)+_xzArquivos+'.'+AllTrim(MV_PAR02))

xApaga := U_CriaTMP( aStructure, "TRB" )

_xArqInd := Left(xApaga, 7) + 'A'

IndRegua("TRB",_xArqInd,"ARQUIVO",,,"Selecionando Registros...")

DbSelectArea("TRB")
Procregua(1)
IncProc("Selecionando registros")

For xi := 1 To Len(aDirectory)

    If Dtos(aDirectory[xi][3]) >= Dtos(MV_PAR05) .And. Dtos(aDirectory[xi][3]) <= Dtos(MV_PAR06)  // Faixa de dias

		RecLock("TRB",.t.)
		TRB->ARQUIVO := aDirectory[xi][1]
		TRB->TAMANHO := aDirectory[xi][2]
		TRB->_DATA   := aDirectory[xi][3]
		TRB->HORA    := aDirectory[xi][4]
		TRB->ATRIBUT := aDirectory[xi][5]
		MsUnLock()
	
    EndIf
	
Next

DbSelectArea('TRB')
DbGoTop()

MarkBRefresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMulticopiaณ Autor ณ Sergio Oliveira       ณ Data ณ Abr/2003 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Copia de forma multipla os arquivos selecionados.          ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             Multicopia()                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ U_Dadosadv.prw                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MultiCopia()

If !MsgBox('Deseja realmente efetuar a(s) copia(s)?','Cuidado!!!','YesNo')
	Return
EndIf

If !MsgBox('Confirme para prosseguir com o processo de Copia.','Cuidado!!!','YesNo')
	Return
EndIf

_nCopias := 0
_lMens   := .f.
//              1       2       3
aOp  := {"Sobrepor","Todos","Ignorar"}
cTit := "Sobreposicao de Arquivos"

DbSelectArea('TRB')
DbGoTop()
ProcRegua(1)
IncProc('Efetuando Copia...')
While !Eof()
	If !Empty(TRB->TROK)  // Registro Selecionado.
		If _lMens     // Sobrepor Todos
			If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
				MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
			Else
				_nCopias ++
			EndIf
		Else
			If File(AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO)) // Arquivo ja Existe
				cMsg := 'O arquivo de destino '+AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO)+' Ja existe.'+Chr(13);
				+'O que deseja Fazer?'
				nOp  := Aviso(cTit,cMsg,aOp)
				If nOp == 1      // Sobrepor Atual
					If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
						MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
					Else
						_nCopias ++
					EndIf
				ElseIf nOp == 2  // Sobrepor Todos
					_lMens := .t.
					If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
						MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
					Else
						_nCopias ++
					EndIf
				Else             // Nao Sobrepor
					DbSelectArea('TRB')
					DbSkip()
					Loop
				EndIf
			Else
				If (__CopyFile(AllTrim(MV_PAR01)+AllTrim(TRB->ARQUIVO),AllTrim(MV_PAR03)+AllTrim(TRB->ARQUIVO))) == .f.
					MsgBox("Nao Foi possivel efetuar a copia. Verifique o Destino.","Problema","Info")
				Else
					_nCopias ++
				EndIf
			EndIf
		EndIf
		
	EndIf
	DbSkip()
EndDo

MsgBox('Nro. de Arquivos Copiados: '+AllTrim(Str(_nCopias)),'Copia Multipla','Info')

Return

User Function MarkDes()

aOp  := {"Todos","Atual","Cancelar"}
cTit := "Marcacao x Remarcacao"
cMsg := 'Escolha uma das Opcoes abaixo:'
nOp  := Aviso(cTit,cMsg,aOp)

DbSelectArea('TRB')
Procregua(1)
IncProc('Estabelecendo Selecao...')
If nOp == 1      // Marcar/Desmarcar todos
	DbGoTop()
	While !Eof()
		RecLock('TRB',.f.)
		If !Empty(TRB->TROK)  // Esta Marcado. Desmarcar.
			Field->TROK := '  '
		Else                  // Nao esta Marcado. Marcar.
			Field->TROK := _cMarca
		EndIf
		MsUnLock()
		DbSkip()
	EndDo
ElseIf nOp == 2  // Marcar/Desmarcar somente o Atual
	RecLock('TRB',.f.)
	If !Empty(TRB->TROK)  // Esta Marcado. Desmarcar.
		Field->TROK := '  '
	Else                  // Nao esta Marcado. Marcar.
		Field->TROK := _cMarca
	EndIf
	MsUnLock()
Else             // Cancelar
	Return
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaTmp   ณ Autor ณ Sergio Oliveira.      ณ Data ณ 09/2002  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Criar arquivos de trabalho(Dbf).                           ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_CriaTmp( <ExpA1>, <ExpC1> )                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpA1: Matriz com a estrutura do Dbf a ser criado.          บฑฑ
ฑฑบ          ณExpC1: Alias a ser criado.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CriaTMP( Estrutura, NovoAlias )

Local _cArq := Criatrab(Estrutura,.t.)

If Select(NovoAlias) > 0
	DbSelectArea(NovoAlias)
	DbCloseArea(NovoAlias)
EndIf

DbUseArea(.t.,,_cArq,NovoAlias,.f.,.f.)

Return(_cArq + GetDbExtension() )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณUsarDbf   ณ Autor ณ Sergio Oliveira.      ณ Data ณ 10/2002  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Colocar em uso algum arquivo DBF.                          ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ             U_UsarDbf( <ExpC1>, <ExpC2> )                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpC1: Path + Nome do arquivo DBF.                          บฑฑ
ฑฑบ          ณExpC2: Alias a ser criado.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function UsarDbf( PatheArq, NovoAlias )

Local _lOk := .f.

If Select(NovoAlias) > 0
	DbSelectArea(NovoAlias)
	DbCloseArea(NovoAlias)
EndIf

If File(PatheArq)
	DbUseArea(.t.,,PatheArq,NovoAlias,.t.,.f.)
	_lOk := .t.
Else
	MsgBox('O arquivo '+PatheArq+' nao existe.','Atencao','Alert')
EndIf

Return(_lOk)

User Function CopiaHtm()

WaitRunSrv("D:\CSU_R3\Protheus_Data\sigaadvhom\wfbat.bat",.t.,"D:\CSU_R3\Protheus_Data\sigaadvhom\")

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณBaixaTab  ณ Autor ณ Sergio Oliveira       ณ Data ณ 12/2003  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico.                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BaixaTab()

aRegs := {}
//cPerg := 'Bxtab_'
cPerg := PADR('Bxtab_',10," ")

aAdd(aRegs,{cPerg,"01","Informe a Tabela...:","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Informe o Path.....:","","","mv_chb","C",40,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg, aRegs)

If !Pergunte(cPerg,.t.)
	Return
EndIf

If TcCanOpen(MV_PAR01)
	If Select(MV_PAR01) == 0
		Dbusearea(.T.,"TOPCONN",MV_PAR01,MV_PAR01,.T.)
		DbSelectArea(MV_PAR01)
	Else
		DbSelectArea(MV_PAR01)
	EndIf
	DbGoTop()
	_cPath :=GetSrvProfString('StartPath','')+MV_PAR01
	Copy To &_cPath
Else
	MsgBox('A Tabela nao Existe no Banco!','Erro-Arquivo','Info')
	Return
EndIf

If (__CopyFile( _cPath + '.Dbf', AllTrim(MV_PAR02)+MV_PAR01+'.Dbf' )) == .f.
	MsgBox('Nao foi possivel copiar para este Path!','Erro-Path','Info')
Else
	MsgBox('Copia efetuada com sucesso!','Copia','Info')
EndIf

If File(_cPath+'.Fpt')
	If (__CopyFile( _cPath + '.Fpt', AllTrim(MV_PAR02)+MV_PAR01+'.Fpt' )) == .f.
		MsgBox('Nao foi possivel copiar para este Path!','Erro-Path','Info')
	Else
		MsgBox('Copia efetuada com sucesso!','Copia','Info')
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UPSA1    บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Testes Genericos                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ YpfxFun.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UpSA1()

Private _xSqlExec := ""
Private cTitulo := "Testes de Rotinas Genericas"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 065,025 To 516,691 Dialog mkwdlg Title cTitulo
@ 007,008 To 207,272 Title "Entre com o comando"
@ 023,019 Get _xSqlExec MEMO Size 242,177
@ 072,280 Button OemToAnsi("_Executar") Size 44,16 Action(__Vai())
@ 100,280 Button OemToAnsi("_Sair")     Size 43,16 Action(Close(MkwDlg))

Activate Dialog mkwdlg

Return

Static Function __Vai()

If Empty(_xSqlExec)
	Return
EndIf

_nRet = TCSQLEXEC(_xSqlExec)
If _nRet#0
	_cRet = TCSQLERROR()
	APMsgAlert(AllTrim(_cRet),cTitulo) 
  	Return
EndIf

TcSqlExec( _xSqlExec )

Alert('Instrucao Processada')

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rftpa01  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o Upload de um arquivo conforme parametros.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shark                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UPLFtp(pcArqUpload)
Local xp	:= 0
Local cFtpSrv := GetNewPar( "MV_X_FTP"  ,"10.1.0.199" ) // IP ou endere็o do FTP
Local cFtpPrt := GetNewPar( "MV_X_FTPPO",21 )           // Porta
Local cFtpUsr := GetNewPar( "MV_X_FTPUS","serginho" )   // Usuario
Local cFtpPsw := GetNewPar( "MV_X_FTPSW","nenhumaa1" )  // Senha
Local aRetDir := {}
Local cArqUpload
	
If ! FTPCONNECT( cFtpSrv , cFtpPrt , cFtpUsr , cFtpPsw )
	Aviso("UPLOAD-FTP","Nao foi possivel se conectar no FTP. Contate o administrador do sistema.",;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PCOLOCK")
	Return( .f. )
EndIf 

aRetDir := FTPDIRECTORY( "*.*", )

For xp := Len( AllTrim( pcArqUpload ) ) To 1 Step -1

	If '\' == SubStr( pcArqUpload, xp, 1 )

		cArqUpload := SubStr( pcArqUpload, xp + 1, Len( AllTrim( pcArqUpload ) ) )
		
		Exit

	EndIf
	
Next

/*
   ==>> Modelo:
   
   If ! FTPUPLOAD('\workflow\entradas.txt', aRetDir[1][1]+'entradas.txt' )
*/   
   
If ! FTPUPLOAD( pcArqUpload, cArqUpload )
	Aviso("UPLOAD-FTP","Nao foi possivel realizar o UPLOAD ["+cArqUpload+"]. Contate o administrador do sistema.",;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PCOLOCK")
	Return( .f. )
Else
	Aviso("UPLOAD-FTP","Upload realizado ==> "+cArqUpload,;
		{"&Voltar"},3,"Grava็ใo do FTP",,"PMSAPONT")
EndIf

FTPDISCONNECT()

Return( .t. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Gpem410  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o Upload de um arquivo conforme parametros.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gpem410                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _Gpem410()

Local nOpc := 0

SetFunName( "GPEM410" )

GPEM410()

FormBatch(OemToAnsi("FTP - Envio de CNAB"),;
	{OemToAnsi("Esta rotina tem como ojbetivo processar o envio automatico do CNAB da Folha via "),;
	OemToAnsi("FTP")},;
	{ { 1,.T.,{|o| nOpc:=1,o:oWnd:End()}},;
	{ 2,.T.,{|o| o:oWnd:End()}}})

If nOpc == 1
	ConfSeg()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณConfSeg   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ _Gpem410()                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSeg()
Local xp	:= 0               
Local cArqDest := AllTrim( MV_PAR22 )
Local cArqUpload

For xp := Len( cArqDest ) To 1 Step -1

	If '\' == SubStr( cArqDest, xp, 1 )

		cArqUpload := SubStr( cArqDest, xp + 1, Len( cArqDest ) )
		
		Exit

	EndIf
	
Next
                
__CopyFile( AllTrim(MV_PAR22), MsDocPath()+"\"+cArqUpload )

U_UPLFtp(  MsDocPath()+"\"+cArqUpload ) // Envia por FTP o arquivo com os dados de pagamentos.
	
Ferase( MV_PAR22 )
Ferase(  MsDocPath()+"\"+cArqUpload )
	
Return	
Return