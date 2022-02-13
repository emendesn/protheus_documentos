/**
 * Rotina		:	PE M030Del
 * Autor		:	Thomas Quintino Galv�o
 * Data			:	13/07/2012	
  * Uso			:	SIGAFAT
 * Descricao	:	Valida��o de Cadastro de Produtos por Grupo de Usu�rios
 */  
 #Include "Totvs.ch"
                                                      	
User Function M030Del
u_GerA0003(ProcName())	
                               	
	IIf (SA1->A1_PESSOA == "F", cGrupo := "CadClientePF", cGrupo := "CadClientePJ" )
	lRet := u_VldGrpUsr(cGrupo,.F.) 
	If !lRet
		Return .F.
	EndIf
Return lRet