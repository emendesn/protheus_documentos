/**
 * Rotina		:	PE MA030TOk - 	Verifica Inclus�o e Altera��o do Cadastro de Clientes
 * Autor		:	Paulo Francisco
 * Data			:	16/12/10	
 * Descricao	:   Evita a Inclus�o de Cadastros com Erros
 * Uso			:	SIGAFAT
 * ******************************ALTERA��ES********************************
 * Autor		:	Thomas Quintino Galv�o  
 * Data			:	13/07/12        
 * Descricao	:	Valida��o de Cadastro de Clientes por Grupo de Usu�rios
 * 
 * ATEN��O		: 	Qualquer altera��o nesta rotina, considerar entrada via WebService (__cInternet == 'AUTOMATICO')
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
				
	&&Valida��o de Cadastro de Clientes por Grupo de Usu�rios
	&&Thomas Quintino Galv�o - 13/07/12
	IF __cInternet != 'AUTOMATICO'
		IIf (M->A1_PESSOA == "F", cGrupo := "CadClientePF", cGrupo := "CadClientePJ" )
		lRet := u_VldGrpUsr(cGrupo,.F.) 
		If !lRet
			Return .F.
		EndIf
	EndIf
	&&*******************************************************
	
	If ! ',' $ M->A1_END
		cMsg += "Favor Revisar o Cadastro, Campos Endere�o esta sem Virgula !"+CRLF
		lRet := .F.
	Endif
	
	If '�' $ M->A1_END .Or. ':' $ M->A1_XNUMCOM .Or. '.' $ M->A1_END 
		cMsg += "Favor Revisar o Cadastro, Campos Endere�o ou Complemento esta com Caracter � ou Caracter :"+CRLF
		lRet := .F.
	EndIf
	
	cEnd	:= M->A1_END := Substr(M->A1_END , ndiv+1)
	If ',' $ cEnd
		cMsg += "Favor Remover a Segunda Virgula do Endere�o ou Complemento ! "+CRLF
		lRet := .F.
	EndIf  
	
	If Len(AllTrim(M->A1_INSCR))< 6                        
		cMsg += "Favor Verificar a Inscri��o Estadual !"+CRLF
		lRet := .F.
	EndIf  
	
	If ! ',' $ M->A1_ENDENT
		cMsg += "Favor Revisar o Cadastro, Campos Endere�o de Entrega esta sem Virgula !"+CRLF
		lRet := .F.
	Endif
	
	If '�' $ M->A1_ENDENT .Or. ':' $ M->A1_ENDENT .Or. '.' $ M->A1_ENDENT
		cMsg += "Favor Revisar o Cadastro, Campos Endere�o Entrega ou Complemento Entrega esta com Caracter � ou Caracter :"+CRLF
		lRet := .F.
	EndIf	
	
	cEnd	:= M->A1_ENDENT := Substr(M->A1_ENDENT , ndivi+1)
	If ',' $ cEnd
		cMsg += "Favor Remover a Segunda Virgula do Endere�o de Entrega !"
		lRet := .F.
	EndIf
	
	&&ATEN��O: Qualquer altera��o nesta rotina, considerar entrada via WebService (__cInternet == 'AUTOMATICO')
	IF __cInternet == 'AUTOMATICO'
		__cErMKTar := cMsg
	Else
		IIF(!lRet, Aviso("Valida��o de Campo", cMsg,{'OK'}),)	
	EndIf
Return lRet