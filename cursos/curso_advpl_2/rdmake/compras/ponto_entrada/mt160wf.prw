#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TBICONN.CH"
/*

ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para envio de Workflow na analise da       บฑฑ
ฑฑบ          ณcotacao.        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT160WF()
Local aCond:={},cMailID,cSubject ,nfrete := 0, nipi := 0, NVALICMS := 0,NDESPESA:=0,NSEGURO:=0,NBASEICMS:= 0
Local oProcess
Local cUsuarioProtheus, cAssunto
Local aArea := GetArea()
Local _cServer := getMV("MV_WFBRWSR")
Local _clink := "http://"+_cServer + "/H_LGAPRSC1.apl"
	
u_GerA0003(ProcName())

cUsuarioProtheus:= cUsername 

If Select("TRBPED") <> 0 
	DbSelectArea("TRBPED")
	DbCloseArea()
Endif 

_Query := "SELECT C8_NUMPED "
_Query += "FROM SC8020  "
_Query += "WHERE C8_NUM = '" + ParamIXB[1] + "' AND D_E_L_E_T_ <> '*' AND C8_NUMPED <> 'XXXXXX' AND C8_NUMPED <> '' " //AND C8_CTRLMAI = '' "
TCQUERY _Query NEW ALIAS "TRBPED"  		

dbSelectArea("TRBPED")
TRBPED->(dbGotop())
while ! TRBPED->(EOF())
	
	numPed := TRBPED->C8_NUMPED

	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+numPed)
	
	if SC7->C7_CONAPRO == "L"
		ApMsgInfo("Pedido de compra gerado e liberado automแticamente com o n๚mero : " + numPed )
	else
		If Select("TRSUP") <> 0 
			DbSelectArea("TRSUP")
			DbCloseArea()
		Endif 
					
		_Query := "SELECT C1_APRSUPE "
		_Query += "FROM SC7020 AS SC7 "
		_Query += "INNER JOIN SC1020 AS SC1  ON C1_NUM = C7_NUMSC "
		_Query += "					 		AND C1_ITEM = C7_ITEMSC "
		_Query += "					 		AND SC1.D_E_L_E_T_ <> '*' "
		_Query += "WHERE C7_NUM = '" + numPed + "'"		
		_Query += "	 AND SC7.D_E_L_E_T_ <> '*' "
		TCQUERY _Query NEW ALIAS "TRSUP"  		
	    
		If Select(_Query) <> 0 
			DbSelectArea(_Query)
			DbCloseArea()
		Endif
		 
		_Query := "UPDATE SCR020 "
		_Query += "SET CR_USER = '" + TRSUP->C1_APRSUPE + "' "
		_Query += "WHERE CR_NUM = '" + numPed + "' AND CR_STATUS = '02' AND CR_NIVEL = '01' AND D_E_L_E_T_ <> '*' "
		TCSQLEXEC(_Query)    

		TRSUP->(dbCloseArea())

/*
		_Query := "SELECT R_E_C_N_O_ AS REG "
		_Query += "FROM SCR020 "
		_Query += "WHERE D_E_L_E_T_ <> '*' "
		_Query += "	 AND CR_NUM = '" + numPed + "' "
		_Query += "	 AND R_E_C_N_O_ NOT IN (SELECT SCR.R_E_C_N_O_ "
		_Query += "							FROM SCR020 AS SCR "
		_Query += "							INNER JOIN SAK020 AS SAK ON CR_APROV = AK_COD "
		_Query += "							AND SAK.D_E_L_E_T_ <> '*' "
		_Query += "							WHERE CR_NUM = '" + numPed + "' "
		_Query += "							   AND CR_TOTAL >= AK_LIMMIN ) "
*/      

		If Select("TRBSCREXC") <> 0 
			DbSelectArea("TRBSCREXC")
			DbCloseArea()
		Endif  

		_Query := "SELECT SCR.R_E_C_N_O_ "
		_Query += "FROM SCR020 AS SCR "
		_Query += "INNER JOIN SAK020 AS SAK ON CR_APROV = AK_COD "
		_Query += "						   AND SAK.D_E_L_E_T_ <> '*' "
		_Query += "WHERE CR_NUM = '" + numPed + "' "
		_Query += "  AND CR_TOTAL >= AK_LIMMIN "
		TCQUERY _Query NEW ALIAS "TRBSCREXC"  		

		_nCont := 0
		TRBSCREXC->(dbGoTop())
		while ! TRBSCREXC->(EOF())
			_nCont++
        	TRBSCREXC->(dbSkip())
		enddo

		
        if _nCont > 0
			ApMsgInfo("Pedido de compra gerado e aguardando aprova็ใo : " + numPed )
		else
			_Query := "UPDATE SC7020 SET C7_CONAPRO = 'L' WHERE C7_NUM = '" + numPed + "' AND D_E_L_E_T_ <> '*' "
			TcSqlExec(_Query)
					
			ApMsgInfo("Pedido de compra gerado e liberado automแticamente com o n๚mero : " + numPed )
		endif

/*		
		TRBSCREXC->(dbGoTop())
		while ! TRBSCREXC->(EOF())
			_Query := "DELETE FROM SCR020 "
			_Query += "WHERE R_E_C_N_O_ = '" + str(TRBSCREXC->REG) + "'"
			TCSQLEXEC(_Query) 
        	TRBSCREXC->(dbSkip())
		enddo
		TRBSCREXC->(dbCloseArea())
*/		 
		If Select("TRBLIMIT") <> 0 
			DbSelectArea("TRBLIMIT")
			DbCloseArea()
		Endif  
			
		_Query := "SELECT DISTINCT CR_USER, CR_NIVEL "
		_Query += "FROM SCR020 AS SCR "
		_Query += "WHERE CR_NUM = '" + numPed + "' AND CR_STATUS = '02' AND SCR.D_E_L_E_T_ <> '*' "
		TCQUERY _Query NEW ALIAS "TRBLIMIT"  		

		dbSelectArea("TRBLIMIT")
		TRBLIMIT->(dbGotop())
		nivel = TRBLIMIT->CR_NIVEL
		_email := {}
		while ! TRBLIMIT->(EOF())
			IF TRBLIMIT->CR_NIVEL == nivel
			  	 PswOrder(1)
				 If PswSeek(TRBLIMIT->CR_USER, .T.)
					aRet := PswRet()
		            aadd(_email, {aRet[1][1], aRet[1][14]})
				 endif	  
			endif
			TRBLIMIT->(dbSkip())
		enddo
	
		for xzx :=1 to len(_email)
//			_emailGer := "luiscarlos@anadi.com.br"
			_emailGer := _email[xzx,2]

			_cMensagem 	:= "Existe um novo Pedido de Compra para ser Aprovado."
			_cMensagem 	+= "Acesse o link " + _clink + " para aprova็ใo"
			_cTitemail	:= "Aprova็ใo de Pedido de Compra N๚mero " + numPed
			
			U_ENVIAEMAIL(_cTitemail,_emailGer,"",_cMensagem,"")
			
		next            
		
		dbSelectArea("TRBLIMIT")
		dbCloseArea()			
	endif
    
	If Select(_Query) <> 0 
		DbSelectArea(_Query)
		DbCloseArea()
	Endif
	_Query := "UPDATE SC8020 SET C8_CTRLMAI = 'S' WHERE C8_NUMPED = '" + numPed + "' AND D_E_L_E_T_ <> '*' "
	TcSqlExec(_Query)

	TRBPED->(dbSkip())
enddo                         


dbSelectArea("TRBPED")
dbCloseArea()

RestArea(aArea)

return .t.
         

