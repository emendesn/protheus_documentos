/**
 * Rotina		:	PE MA030TOk - 	Verifica Inclusão e Alteração do Cadastro de Clientes
 * Autor		:	Paulo Francisco
 * Data			:	16/12/10	
 * Descricao	:   Evita a Inclusão de Cadastros com Erros
 * Uso			:	SIGAFAT
 * ******************************ALTERAÇÕES********************************
 * Autor		:	Thomas Quintino Galvão  
 * Data			:	13/07/12        
 * Descricao	:	Validação de Cadastro de Clientes por Grupo de Usuários
 * 
 * ATENÇÃO		: 	Qualquer alteração nesta rotina, considerar entrada via WebService (__cInternet == 'AUTOMATICO')
 */ 
#Include "Totvs.ch"

User Function Ma030TOk()                      
	Local lRet  := .T.       
	Local ndiv	:= AT(",",M->A1_END)
	Local ndivi	:= AT(",",M->A1_ENDENT)
	Local cEnd 
	Local cGrupo := ""
	Local cMsg	:= ""
	Public __cErMKTar := ""
	
u_GerA0003(ProcName())
	
	If l030Auto
		Return .T.	
	Endif
				
	&&Validação de Cadastro de Clientes por Grupo de Usuários
	&&Thomas Quintino Galvão - 13/07/12
	IF __cInternet != 'AUTOMATICO'
		IIf (M->A1_PESSOA == "F", cGrupo := "CadClientePF", cGrupo := "CadClientePJ" )
		lRet := u_VldGrpUsr(cGrupo,.F.) 
		If !lRet
			Return .F.
		EndIf
	EndIf
	&&*******************************************************
	
	If ! ',' $ M->A1_END
		cMsg += "Favor Revisar o Cadastro, Campos Endereço esta sem Virgula !"+CRLF
		lRet := .F.
	Endif
	
	If 'º' $ M->A1_END .Or. ':' $ M->A1_XNUMCOM .Or. '.' $ M->A1_END 
		cMsg += "Favor Revisar o Cadastro, Campos Endereço ou Complemento esta com Caracter º ou Caracter :"+CRLF
		lRet := .F.
	EndIf
	
	cEnd	:= M->A1_END := Substr(M->A1_END , ndiv+1)
	If ',' $ cEnd
		cMsg += "Favor Remover a Segunda Virgula do Endereço ou Complemento ! "+CRLF
		lRet := .F.
	EndIf  
	
	If Len(AllTrim(M->A1_INSCR))< 6                        
		cMsg += "Favor Verificar a Inscrição Estadual !"+CRLF
		lRet := .F.
	EndIf  
	
	If ! ',' $ M->A1_ENDENT
		cMsg += "Favor Revisar o Cadastro, Campos Endereço de Entrega esta sem Virgula !"+CRLF
		lRet := .F.
	Endif
	
	If 'º' $ M->A1_ENDENT .Or. ':' $ M->A1_ENDENT .Or. '.' $ M->A1_ENDENT
		cMsg += "Favor Revisar o Cadastro, Campos Endereço Entrega ou Complemento Entrega esta com Caracter º ou Caracter :"+CRLF
		lRet := .F.
	EndIf	
	
	cEnd	:= M->A1_ENDENT := Substr(M->A1_ENDENT , ndivi+1)
	If ',' $ cEnd
		cMsg += "Favor Remover a Segunda Virgula do Endereço de Entrega !"
		lRet := .F.
	EndIf
	
	&&ATENÇÃO: Qualquer alteração nesta rotina, considerar entrada via WebService (__cInternet == 'AUTOMATICO')
	IF __cInternet == 'AUTOMATICO'
		__cErMKTar := cMsg
	Else
		IIF(!lRet, Aviso("Validação de Campo", cMsg,{'OK'}),)	
	EndIf
Return lRet