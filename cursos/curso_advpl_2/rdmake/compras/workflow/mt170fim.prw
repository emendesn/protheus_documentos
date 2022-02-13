#Include "PROTHEUS.CH"
#include 'topconn.ch'
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------|
|	Programa : MT170FIM				| 		Outubro de 2012				|
|-----------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi								|
|-----------------------------------------------------------------------|	
|	Descrição : Programa acionado para mandar email para o Superior de  |
|				quem está abrindo a SC									|
|-----------------------------------------------------------------------|	
*/

User Function MT170FIM()  

local _cUser	:= __cUserId
local _cSuperior:= ""             
Local _cServer := getMV("MV_WFBRWSR")
Local _clink := "http://"+_cServer + "/H_LGAPRSC1.apl"
local _cNumSC	:= ""
	
_cQuery	:= "SELECT MAX(SC1.C1_NUM) AS C1_NUM, MAX(AJ_USER) AS AJ_USER "
_cQuery	+= "FROM " + retSqlName("SC1") + " AS SC1 "
_cQuery	+= "INNER JOIN " + retSqlName("SAI") + " AS SAI ON SAI.AI_USER = SC1.C1_USER "
_cQuery	+= "										   AND SAI.D_E_L_E_T_ <> '*' "
_cQuery	+= "INNER JOIN " + retSqlName("SAJ") + " AS SAJ ON AJ_GRCOM = AI_GRUPCOM "
_cQuery	+= "										   AND SAJ.D_E_L_E_T_ <> '*' "
_cQuery	+= "WHERE SC1.C1_EMISSAO = CONVERT(VARCHAR(8),GETDATE(),112)"
_cQuery	+= "  AND SC1.D_E_L_E_T_ <> '*' "
_cQuery	+= "GROUP BY SC1.C1_NUM "
	
TCQUERY _cQuery NEW ALIAS "TMPQRY"

Do While ! TMPQRY->(Eof())
	_cSuperior	:= TMPQRY->AJ_USER
	_cNumSC		:= TMPQRY->C1_NUM
	
	dbSelectArea("SC1")
	SC1->(dbGoTop())
	SC1->(dbSetOrder(1))
	SC1->(dbSeek(xFilial("SC1")+_cNumSC))
	Do While SC1->C1_NUM == _cNumSC
		If RecLock('SC1',.F.)
			C1_APRSUPE	:= _cSuperior
			C1_DTAPSUP	:= ctod('  /  /  ')
			msUnlock('SC1')
		EndIf    

		SC1->(dbSkip())
	EndDo

	PswOrder(1)
	PswSeek(_cSuperior)
	_apswdet	:= PswRet(1)
	_cEmail		:= _aPswDet[1,14]

	_cMensagem 	:= "Existe uma nova Solicitação de Compra para ser Aprovada."
	_cMensagem 	+= "Acesse o link " + _clink + " para aprovação"
	_cTitemail	:= "Aprovação da Solicitação de Compra Número " + _cNumSC
//	_cEmail		:= "luiscarlos@anadi.com.br"

	U_ENVIAEMAIL(_cTitemail,_cEmail,"",_cMensagem,"")

	TMPQRY->(dbSkip())
EndDo

TMPQRY->(dbCloseArea())

Return