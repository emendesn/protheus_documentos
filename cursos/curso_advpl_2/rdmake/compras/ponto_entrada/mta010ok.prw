/**
 * Rotina		:	PE MtA010Ok - mValida adicionais para a exclus�o do produto 
 * Autor		:	Thomas Quintino Galv�o
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Valida��o de Cadastro de Produtos por Grupo de Usu�rios
 */  
 #Include "Totvs.ch"
                                                      	
User Function MtA010Ok

	u_GerA0003(ProcName())                               	
	lRet := u_VldGrpUsr("CadProdutos",.F.) 
Return lRet