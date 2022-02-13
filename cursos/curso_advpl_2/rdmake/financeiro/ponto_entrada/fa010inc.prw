/**
 * Rotina		:	PE FA010INC
 * Autor		:	Rodrigo Limas Salom�o
 * Data			:	25/03/2013	
  * Uso			:	SIGAFAT
 * Descricao	:	Valida��o de Cadastro de Naturezas por Grupo de Usu�rios
 */  
 #Include "Totvs.ch"
                                                      	
User Function FA010INC
                               	
	IIf (SA1->A1_PESSOA == "F", cGrupo := "Cadnaturezas", cGrupo := "Cadnaturezas" )
	lRet := u_VldGrpUsr(cGrupo,.F.) 
	If !lRet
		Return .F.
	EndIf
Return lRet