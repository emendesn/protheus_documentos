/**
 * Rotina		:	PE FIN010ALT
 * Autor		:	Rodrigo Limas Salomão
 * Data			:	25/03/2013	
  * Uso			:	SIGAFAT
 * Descricao	:	Validação de Cadastro de Naturezas por Grupo de Usuários
 */  
 #Include "Totvs.ch"
                                                      	
User Function FIN010ALT
                               	
	IIf (SA1->A1_PESSOA == "F", cGrupo := "Cadnaturezas", cGrupo := "Cadnaturezas" )
	lRet := u_VldGrpUsr(cGrupo,.F.) 
	If !lRet
		Return .F.
	EndIf
Return lRet