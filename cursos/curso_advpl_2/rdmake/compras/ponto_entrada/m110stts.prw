#Include "PROTHEUS.CH"
#include 'topconn.ch'
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------|	
|	Programa : M110STTS					| 			Setembro de 2012	|
|-----------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Maintech								|
|-----------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada acionado após gravação da SC1			|
|				Será usado para mandar email para o Superior de quem	|
|				está abrindo a SC										|
|-----------------------------------------------------------------------|	
*/

User Function M110STTS()  

	local _cUser	:= __cUserId
	local _cSuperior:= ""             
	Local _cServer := getMV("MV_WFBRWSR")
	Local _clink := "http://"+_cServer + "/H_LGAPRSC1.apl"
	local _cNumSC	:= M->CA110NUM

	u_GerA0003(ProcName())

	if ALTERA .or. INCLUI
		_cQuery	:= "SELECT AJ_USER "
		_cQuery += "FROM " + retSqlName("SAI") + " AS SAI "
		_cQuery += "INNER JOIN " + retSqlName("SAJ") + " AS SAJ ON AJ_GRCOM = AI_GRUPCOM " 
		_cQuery += "										   AND SAJ.D_E_L_E_T_ <> '*' "
		_cQuery	+= "WHERE AI_USER = '" + _cUser + "' "
		_cQuery += "  AND SAI.D_E_L_E_T_ <> '*' "
		
		TCQUERY _cQuery NEW ALIAS "TMPQRY" 
	    _cSuperior	:= TMPQRY->AJ_USER    
	    TMPQRY->(dbCloseArea())
	    
	    dbSelectArea("SC1")  
	    dbSetOrder(1)
	    dbSeek(xFilial("SC1")+_cNumSC)
	    do while SC1->C1_NUM == _cNumSC
		 	if RecLock('SC1',.F.)
		 		C1_APRSUPE	:= _cSuperior
		 		C1_DTAPSUP	:= ctod('  /  /  ')
		 		msUnlock('SC1')	
		 	endif    
		 	SC1->(dbSkip())
		enddo
		    
		PswOrder(1)
		PswSeek(_cSuperior)
		_apswdet	:= PswRet()
		_cEmail		:= _aPswDet[1,14] 
		
		_cMensagem 	:= "Existe uma nova Solicitação de Compra para ser Aprovada."
		_cMensagem 	+= "Acesse o link " + _clink + " para aprovação"
		_cTitemail	:= "Aprovação da Solicitação de Compra Número " + _cNumSC
	//	_cEmail		:= "luiscarlos@anadi.com.br"
		
		U_ENVIAEMAIL(_cTitemail,_cEmail,"",_cMensagem,"")
	endif	
return 
