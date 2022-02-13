/**
 * Rotina		:	PE MA020Alt - Verifica Inclusão e Alteração do Cadastro de Clientes
 * Autor		:	Paulo Francisco
 * Data			:	17/12/10	
 * Descricao	:   Evita a Inclusão de Cadastros com Erros
 * Uso			:	SIGACOM
 * ******************************ALTERAÇÕES********************************
 * Autor		:	Thomas Quintino Galvão  
 * Data			:	13/07/12        
 * Descricao	:	Validação de Cadastro de Fornecedores por Grupo de Usuários
 */ 
#Include "Totvs.ch" 

User Function MA020Alt()                         
	Local lRet  := .T. 

	u_GerA0003(ProcName())      
	
	&&Validação de Cadastro de Fornecedores por Grupo de Usuários
	&&Thomas Quintino Galvão - 13/07/12
	lRet := u_VldGrpUsr("CadFornecedores",.F.) 
	If !lRet
		Return .F.
	EndIf
	&&*******************************************************
	
	If ! ',' $ M->A2_END
		MsgAlert("Favor Revisar o Cadastro, Campos Endereço esta sem Virgula")
		lRet := .F.
	Endif
	
	If 'º' $ M->A2_END .Or. ':' $ M->A2_NUMCOMP .Or. '.' $ M->A2_END
		MsgAlert("Favor Revisar o Cadastro, Campos Endereço ou Complemento esta com Caracteres º ou : ou . ")
		lRet := .F.
	EndIf
	
	If ',' $ M->A2_NUMCOMP
		MsgAlert("Favor Remover a Segunda Virgula do Endereço ou Complemento")
		lRet := .F.
	EndIf 
Return lRet