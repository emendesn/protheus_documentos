#INCLUDE 'RWMAKE.CH'

/*
|---------------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : AXZZX.PRW				| 	Abril de 2012												 							|
|---------------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																						|
|---------------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : AxCadastro para a tabela ZZX de Cadastro de Motivos e Responsabilidades de Scrap  	|
|---------------------------------------------------------------------------------------------------------------------------------------------------	|	
*/


user function AXZZX()

	Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
	Private lUsrAut	:= .F.


u_GerA0003(ProcName())

/*	
	For i := 1 to Len(aGrupos)
		
		//Usuarios de Autorizado a entrar no módulo
		If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES"
			lUsrAut  := .T.
		EndIf
		
	Next i
*/	

	lUsrAut  := .T.

	if lUsrAut
		AxCadastro("ZZX","Cadastro de Motivos e Responsabilidades de Scrap")
	else
	    alert ("Usuário sem permissão para acessar esse módulo !!")
	endif
	
Return 
