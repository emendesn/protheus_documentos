/**
 * Rotina		:	PE MA020Alt - Verifica Inclus�o e Altera��o do Cadastro de Clientes
 * Autor		:	Paulo Francisco
 * Data			:	17/12/10	
 * Descricao	:   Evita a Inclus�o de Cadastros com Erros
 * Uso			:	SIGACOM
 * ******************************ALTERA��ES********************************
 * Autor		:	Thomas Quintino Galv�o  
 * Data			:	13/07/12        
 * Descricao	:	Valida��o de Cadastro de Fornecedores por Grupo de Usu�rios
 */ 
#Include "Totvs.ch" 

User Function MA020Alt()                         
	Local lRet  := .T. 

	u_GerA0003(ProcName())      
	
	&&Valida��o de Cadastro de Fornecedores por Grupo de Usu�rios
	&&Thomas Quintino Galv�o - 13/07/12
	lRet := u_VldGrpUsr("CadFornecedores",.F.) 
	If !lRet
		Return .F.
	EndIf
	&&*******************************************************
	
	If ! ',' $ M->A2_END
		MsgAlert("Favor Revisar o Cadastro, Campos Endere�o esta sem Virgula")
		lRet := .F.
	Endif
	
	If '�' $ M->A2_END .Or. ':' $ M->A2_NUMCOMP .Or. '.' $ M->A2_END
		MsgAlert("Favor Revisar o Cadastro, Campos Endere�o ou Complemento esta com Caracteres � ou : ou . ")
		lRet := .F.
	EndIf
	
	If ',' $ M->A2_NUMCOMP
		MsgAlert("Favor Remover a Segunda Virgula do Endere�o ou Complemento")
		lRet := .F.
	EndIf 
Return lRet