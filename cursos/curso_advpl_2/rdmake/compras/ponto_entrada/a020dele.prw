/**
 * Rotina		:	PE A020Dele - Valida��es do usu�rio para exclus�o do fornecedorReturn (lExecuta)..
 * Autor		:	Thomas Quintino Galv�o
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Valida��o de Cadastro de Produtos por Grupo de Usu�rios
 */  
 #Include "Totvs.ch"
 
 User Function A020Dele
	Local lRet := u_VldGrpUsr("CadFornecedores",.F.)
	u_GerA0003(ProcName())
 Return lRet