#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFW120P   ºAutor  ³Luis Carlos - Anadi º Data ³  05/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada usado para o envio de emails aos          º±±
±±º          ³ aprovadores                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFW120P()
Local aArea		:= GetArea()
Local _clink	:= ""
Local cGrupo	:= ""
Local lConsSC1	:= .T. //Verifica se considera cadastro de solicitantes para select
_cServer	:= GetMV("MV_WFBRWSR")
_clink := "http://"+Alltrim(_cServer)+"/H_LGAPRSC1.apl"
cNumero		:= SC7->C7_NUM
If ALTERA .or. INCLUI
	If AllTrim(SC7->C7_CC) == '2021'
		cGrupo	:= '000004'
		dbSelectArea("SC7")
		RecLock("SC7",.F.)
		SC7->C7_GRUPCOM	:= cGrupo
		SC7->C7_APROV		:= cGrupo
		MsUnlock()
		lConsSC1 := .F.
	EndIf
	_cQuery	:= "SELECT MAX(AJ_USER) AS AJ_USER "
	_cQuery	+= "FROM " + retSqlName("SC7") + " AS SC7 "
	If lConsSC1
		_cQuery	+= "INNER JOIN " + retSqlName("SAI") + " AS SAI ON SAI.AI_USER = SC7.C7_USER "
		_cQuery	+= "										   AND SAI.D_E_L_E_T_ <> '*' "
		_cQuery	+= "INNER JOIN " + retSqlName("SAJ") + " AS SAJ ON AJ_GRCOM = AI_GRUPCOM "
		_cQuery	+= "										   AND SAJ.D_E_L_E_T_ <> '*' "
	Else
		_cQuery	+= "INNER JOIN " + retSqlName("SAJ") + " AS SAJ ON AJ_GRCOM = C7_GRUPCOM "
		_cQuery	+= "										   AND SAJ.D_E_L_E_T_ <> '*' "
	EndIf
	_cQuery	+= "WHERE SC7.C7_NUM = '" + cNumero + "'"
	_cQuery	+= "  AND SC7.D_E_L_E_T_ <> '*' "
	_cQuery	+= "GROUP BY SC7.C7_NUM "
	TCQUERY _cQuery NEW ALIAS "TMPQRY"
	_cSuperior	:= TMPQRY->AJ_USER
	TMPQRY->(dbCloseArea())
	_Query := "UPDATE SCR020 "
	_Query += "SET CR_USER = '" + _cSuperior + "' "
	_Query += "WHERE CR_NUM = '" + cNumero + "' AND CR_STATUS = '02' AND CR_NIVEL = '01' AND D_E_L_E_T_ = '' "
	TCSQLEXEC(_Query)
	_Query := " SELECT DISTINCT CR_USER, CR_NIVEL "
	_Query += " FROM SCR020 AS SCR "
	_Query += " WHERE CR_NUM = '" + cNumero + "' AND CR_STATUS = '02' AND SCR.D_E_L_E_T_ = '' "
	_Query += " ORDER BY CR_NIVEL "
	TCQUERY _Query NEW ALIAS "TRBLIMIT"
	dbSelectArea("TRBLIMIT")
	TRBLIMIT->(dbGotop())
	nivel = TRBLIMIT->CR_NIVEL
	_email := {}
	While ! TRBLIMIT->(EOF())
		IF TRBLIMIT->CR_NIVEL == nivel
			PswOrder(1)
			If PswSeek(TRBLIMIT->CR_USER, .T.)
				aRet := PswRet()
				AADD(_email, {aRet[1][1], aRet[1][14]})
			EndIf
		EndIf
		TRBLIMIT->(dbSkip())
	EndDo
	For nI := 1 to Len(_email)
//		_emailGer := _email[nI,2]
		_cMensagem 	:= "Existe uma nova Solicitação de Compra para ser Aprovada."
		_cMensagem 	+= "Acesse o link " + _clink + " para aprovação"
		_cTitemail	:= "Aprovação do Pedido No " + cNumero //_cNumSC
		_emailGer := _email[nI,2]
//		_emailGer	:= "hudson.santos@bgh.com.br"
		U_ENVIAEMAIL(_cTitemail,_emailGer,"",_cMensagem,"")
	Next
	dbSelectArea("TRBLIMIT")
	dbCloseArea()
EndIf
RestArea(aArea)
Return .T.