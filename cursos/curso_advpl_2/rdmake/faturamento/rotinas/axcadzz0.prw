#INCLUDE 'RWMAKE.CH'

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : AXCADZZ0				| 	Março de 2012																|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : AxCadastro para a tabela ZZ0 de Manutencao da Tabela de Divisao de Negocios  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/


user function axCadZZ0()

	Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
	Private lUsrAut	:= .F.

u_GerA0003(ProcName())
	
	For i := 1 to Len(aGrupos)
		
		//Usuarios de Autorizado a entrar no módulo
		If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#ADMDIVISAONEGOCIOS"
			lUsrAut  := .T.
		EndIf
		
	Next i
	
	if lUsrAut
		AxCadastro("ZZ0","Manutencao da Tabela de Divisao de Negocios")
	else
	    alert ("Usuário sem permissão para acessar esse módulo !!")
	endif
	
Return 
