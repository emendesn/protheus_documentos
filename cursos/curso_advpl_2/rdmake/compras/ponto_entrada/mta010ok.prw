/**
 * Rotina		:	PE MtA010Ok - mValida adicionais para a exclusão do produto 
 * Autor		:	Thomas Quintino Galvão
 * Data			:	13/07/2012	
  * Uso			:	SIGACOM
 * Descricao	:	Validação de Cadastro de Produtos por Grupo de Usuários
 */  
 #Include "Totvs.ch"
                                                      	
User Function MtA010Ok

	u_GerA0003(ProcName())                               	
	lRet := u_VldGrpUsr("CadProdutos",.F.) 
Return lRet