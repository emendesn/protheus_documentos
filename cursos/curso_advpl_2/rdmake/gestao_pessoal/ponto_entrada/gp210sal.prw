#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³GP210SAL  ºAutor  ³Microsiga                º Data ³ 08/07/14 º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Na rotina de Geração do Relatório de Mapa de Vale Transporte, º±±
±±º        ³foi criado um ponto de entrada que permite a alteração do     º±±
±±º        ³percentual de desconto do VT.                                 º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³BGH                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GP210SAL()
Local cAliasSr0 := "SR0"
Local cAliasQry := "SRA"
u_GerA0003(ProcName())
dbSelectArea( cAliasSr0 )
If dbSeek( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT )
	While !Eof() .AND. ( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT = (cAliasSr0)->R0_FILIAL + (cAliasSr0)->R0_MAT )
		If Alltrim((cAliasSr0)->R0_MEIO) $ "518"
			Reclock("SR0",.F.)
			(cAliasSr0)->R0_VALCAL := (cAliasSr0)->R0_QDIACAL * (cAliasSr0)->R0_XVALORU
			MsUnlock()
			dbSelectArea( cAliasSrn )
			If dbSeek( If(cFilial == "  ","  " + (cAliasSr0)->R0_MEIO , (CAliasSr0)->R0_FILIAL + (cAliasSr0)->R0_MEIO ) )
				Reclock("SRN",.F.)
				 (cAliasSrn)->RN_VUNIATU := (cAliasSr0)->R0_XVALORU
				MsUnlock()
			Endif
		Endif
		(cAliasSr0)->( dbSkip() )
	EndDo
Endif
Return .T.