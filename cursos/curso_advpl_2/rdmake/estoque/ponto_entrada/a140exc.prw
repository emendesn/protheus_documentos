#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A140Exc   ºAutor  ³Luciano Siqueira    º Data ³  09/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada responsavel por excluir a Base Instalada  º±±
±±º          ³ no momento da exclusao da Pre-Nota                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A140Exc()

Local _aArea	:= GetArea()
Local _lRet		:= .T.

u_GerA0003(ProcName())

If ALLTRIM(UPPER(FUNNAME())) == "MATA140"
	_cQryAA3 := " SELECT "
	_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
	_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
	_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
	_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
	_cQryAA3 += " AND AA3_XNFENT='"+SF1->F1_DOC+"' "
	_cQryAA3 += " AND AA3_XSEREN='"+SF1->F1_SERIE+"' "
	_cQryAA3 += " AND AA3_FORNEC='"+SF1->F1_FORNECE+"' "
	_cQryAA3 += " AND AA3_LOJAFO='"+SF1->F1_LOJA+"' "
	_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
	_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
	_cQryAA3 += " AND B1_COD=AA3_CODPRO "
	_cQryAA3 += " AND B1_XCONTSE='S' "
	
	_cQryAA3 := ChangeQuery(_cQryAA3)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
	
	QRY1->(dbGoTop())
	Do While QRY1->(!Eof())
		dbSelectArea("AA3")
		dbSetOrder(1)
		If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
			
			If !Empty(AA3->AA3_NFVEND)
				MSGSTOP("Atenção, Não foi possivel excluir o Numero de Serie "+Alltrim(AA3->AA3_NUMSER)+" da Base Instalada." + CHR(13)+CHR(10)+;
				"O mesmo teve sua saida na NF "+Alltrim(AA3->AA3_NFVEND)+". Favor verificar com o Administrador.")
			Else
				Reclock("AA3",.F.)
				DbDelete()
				MsUnLock()
	
				dbSelectarea("AAF")
				dbSetOrder(1)
				If dbSeek(xFilial("AAF")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
					Reclock("AAF",.F.)
					AAF->AAF_DTFIM  := dDataBase
					AAF->AAF_LOGFIM := "EXCLUIDO PELA AMARRACAO"
					MsUnLock()
				EndIf
			Endif
			
		Endif
		dbSelectArea("QRY1")
		DbSkip()
	Enddo
	QRY1->(dbCloseArea())
Endif

RestArea(_aArea)

Return(_lRet)
