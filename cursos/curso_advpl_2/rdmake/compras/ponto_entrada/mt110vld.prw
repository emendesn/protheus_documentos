/**
 * Rotina		:	PE Mt110Vld
 * Autor		:	Thomas Quintino Galvão
 * Data			:	07/12/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Validação de Inclusão de Solicitação de Compras
 */  
#Include 'Totvs.ch' 
#Include 'TopConn.ch'
User Function Mt110Vld
	Local lRet := .T.  
	Local cQuery := ''
	Local cAlias := GetNextAlias()

	u_GerA0003(ProcName())
    
	If INCLUI
		cQuery := " SELECT AJ_USER "
		cQuery += " FROM " + retSqlName("SAI") + " AS SAI "
		cQuery += " 	INNER JOIN " + retSqlName("SAJ") + " AS SAJ "
		cQuery += " 		ON AJ_GRCOM = AI_GRUPCOM " 
		cQuery += "			AND SAJ.D_E_L_E_T_ <> '*' "
		cQuery += " WHERE AI_USER = '" + __cUserId + "' "
		cQuery += "  	AND SAI.D_E_L_E_T_ <> '*' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		(cAlias)->(dbGoTop())
		If (cAlias)->(EoF())
			MsgAlert("Usuário não autorizado a efetuar esta Operação!") 
			lRet := .F.
		EndIf	   	      
	    (cAlias)->(dbCloseArea())
	 EndIf
Return lRet