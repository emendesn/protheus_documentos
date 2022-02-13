#Include "Totvs.ch"

/*
 * Rotina		:	PE A010TOk
 * Autor		:	Thomas Quintino Galv�o
 * Data			:	12/07/2012	
 * Uso			:	SIGACOM
 * Descricao	:	Valida��o de Cadastro de Produtos por Grupo de Usu�rios

User Function A010TOk
	Local lRet := u_VldGrpUsr("CadProdutos",.F.)
	u_GerA0003(ProcName())
Return lRet
*/

User Function A010TOk

Local lRet := u_VldGrpUsr("CadProdutos",.F.)

u_GerA0003(ProcName())
	
	If lRet
		If inclui .or. altera
       	If Empty(M->B1_XCODFAB)
				M->B1_XCODFAB := AllTrim(M->B1_COD)
           Endif
       Endif
	Endif

Return lRet