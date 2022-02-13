/**
 * Rotina		:	PE A020Dele - Validações do usuário para exclusão do fornecedorReturn (lExecuta)..
 * Autor		:	Thomas Quintino Galvão
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Validação de Cadastro de Produtos por Grupo de Usuários
 */  
 #Include "Totvs.ch"
 
 User Function A020Dele
	Local lRet := u_VldGrpUsr("CadFornecedores",.F.)
	u_GerA0003(ProcName())
 Return lRet