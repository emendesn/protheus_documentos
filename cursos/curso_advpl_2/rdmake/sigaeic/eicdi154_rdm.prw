#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/**************************************************************************************
Rotina: EICDI154			Elizabete de Oliveira Brito				Data: 09/01/2014
Descricao: Ponto de entrada para gravar os dados da NF do EIC para o Compras 
***************************************************************************************/
User Function EICDI154

IF PARAMIXB == "GRV_SF1" 
	EIH->(dbSeek(xFilial("EIH") + SW6->W6_HAWB))
	nCpo := 1
	DO WHILE !EIH->(eof()) .AND. EIH->(EIH_FILIAL + EIH->EIH_HAWB) == xFilial("EIH")+SW6->W6_HAWB
		IF nCpo <= 5 .AND. SJF->(dbSeek(xFilial("SJF") + EIH->EIH_CODIGO)) 
			SF1->(FieldPut(FieldPos("F1_ESPECI"+STR(nCpo,1)),SJF->JF_DESC))		
			SF1->(FieldPut(FieldPos("F1_VOLUME"+STR(nCpo,1)),EIH->EIH_QTDADE))		
			nCpo++
		ENDIF
		EIH->(dbSkip())
	ENDDO

	IF SF1->F1_TIPO <> 'C'	
	
		SF1->F1_PLIQUI := nPesol   
		SF1->F1_PBRUTO := IF(SW6->W6_PESO_BR > 0,SW6->W6_PESO_BR,nPesoB)
		SF1->F1_TRANSP := SW6->W6_TRANS 	
	
	ENDIF
	
	
ELSEIF PARAMIXB == "GRAVACAO_SD1"
	Aadd( aItem, { "D1_HRDOCA", TIME() , ".T." } )
	
	IF SD1->D1_TIPO=='C'
	
		Aadd( aItem, { "D1_QUANT", 0, ".T." } )
	
	ENDIF
	
ENDIF   
RETURN .T.