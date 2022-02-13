#Include "Totvs.ch"
/**
 * Classe		:	VldGrpUsr
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012    
 * Uso			:	
 * Descricao	:	Classe para Retorno de Grupos onde usuário tem acesso  
 * Sintaxe		:   New(cGrupo, cUser, lMsg)	
 * 				:   	cGrupo --> Nome do Grupo a Pesquisar
 * 				:   	cUser  --> Usuário a Consultar (Desativado)
 * 				:   	lMsg   --> .T. Indica se Mostra mensagem com os Grupos que o Usuário Pertence
 */ 
User Function VldGrpUsr(cGrupo,lMostra) 
	Local oVld
	Local lRet 	:= .T.

	u_GerA0003(ProcName())
	
	oVld := VldGrpUsr():New(cGrupo,,.T.)
	lRet := oVld:VldAcessUsr() 	//Verifica se Usuário Locado tem acesso ao Grupo Informado  -->lOk
	oVld:GetRelUsrGrp(lMostra) 	//.T. = Mostra Mensagem com os Grupos que Pertence    	    -->cTexto
	
Return lRet
/**
 * Classe		:	VldGrpUsr
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012	
 * Descricao	:   Classe para Retorno de Grupos onde usuário tem acesso 
 */
Class VldGrpUsr
	Data cGrupo
	Data cUser
	Data aGrupos				
	Data lUsrAut
	Data lMsg
	Data aUsers
		
	Method New()				&& Construtor
	Method VldAcessUsr()		&& Validação de Acesso a Grupo de Usuário	
	Method GetGrpUsr()			&& Retorna Array com Usuário, Grupos e descrição dos Grupos que tem acesso	
	Method GetRelUsrGrp()		&& Mostra Relação de Usuários para o Grupo Informado
End Class
/**
 * Método		:	VldGrpUsr
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012	
 * Descricao	:	Construtor
 */
Method New(cGrupo, cUser, lMsg) Class VldGrpUsr
	::lUsrAut   :=.F.
	::cGrupo	:= cGrupo
	::cUser		:= cUser 
	::lMsg		:= lMsg
	
	Default	::aGrupos 	:= {}
	Default ::aUsers	:= {}
	Default ::cUser		:= __cUserID
	Default	::cGrupo	:= ""
    Default ::lMsg		:= .F.
    
	::aGrupos 	:= aClone(UsrRetGRP()) &&Retorna um array contendo os códigos dos grupos em que o usuário pertence..

	If Empty(::cGrupo) 
		MsgAlert("É Nessário informar o(s) Grupo(s) a ser(em) Encontrado(s)!")
		Return	
	EndIf
	
Return    
/**
 * Método		:	VldAcessUsr
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012	
 * Descricao	:	VldAcessUsr
 */
Method VldAcessUsr() Class VldGrpUsr
	Local nI 	:= 0 
	Local aRet	:={}
	Local cMsg	:= ""
	For nI := 1 to Len(::aGrupos)	
		If Upper(AllTrim(GRPRetName(::aGrupos[nI]))) $ Upper(AllTrim(::cGrupo))
			::lUsrAut  := .T.  
			aAdd(aRet,{ __cUserID		,; 								&&1 = Usuário
						::aGrupos[nI]	,;								&&2 = Código do Grupo
						AllTrim(GRPRetName(::aGrupos[nI]))})   			&&3 = Nome do Grupo 
			
			::aUsers := aClone(aRet)
		EndIf		
	Next nI

	If !::lUsrAut
		cMsg := "Usuário não Está Autorizado a Realizar Esta Operação, " 
	 	cMsg += "Entre em contato com o Departamento de TI Para Solicitar Acesso! "
		Aviso("SEM ACESSO",cMsg, {"OK"})	
	EndIf
	     
Return ::lUsrAut  
/**
 * Método		:	GetGrpUsr
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012	
 * Descricao	:	VldAcessUsr
 */
Method GetGrpUsr() Class VldGrpUsr
 
Return ::aUsers 

/**
 * Método		:	GetRelUsrGrp
 * Autor		:	Thomas Quintino Galvão
 * Data			:	12/07/2012	
 * Descricao	:	VldAcessUsr
 */ 
Method GetRelUsrGrp(lMsg) Class VldGrpUsr
	Local lTexto	:= .T. 
	Local cTexto 	:= ""
	Local cMostra	:= ""
	Local nCont		:= 0
	Local nI		:= 0
	
	::lMsg := lMsg
	
	If ::lMsg
		If Len(::aUsers) > 0 
			cMostra := ""
			For nI:= 1 To Len(::aUsers)
				nCont++
				If cMostra <> ::aUsers[nI,2] 
					cMostra := ::aUsers[nI,2] 
					cTexto += "Grupo     Descrição"+CRLF 				
				EndIf
				cTexto += ::aUsers[nI,2]+" - "+::aUsers[nI,3]+CRLF
			Next nI
			cTexto += CRLF
			If nCont > 1
				cTexto += "Foram encontrados "+StrZero(nCont,3)+" Grupos para Este Usuário		
			Else
				cTexto += "Foi encontrado "+StrZero(nCont,3)+" Grupo para Este Usuário
				cTexto += CRLF	 	
			EndIf
			Aviso("Grupos do Usuário "+::aUsers[1,1],cTexto,{"OK"})	
		EndIf
	EndIf
Return cTexto