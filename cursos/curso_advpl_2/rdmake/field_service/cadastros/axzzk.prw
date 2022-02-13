#INCLUDE 'RWMAKE.CH'

/*
|---------------------------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : AXCADZZK				| 	Março de 2012																					|
|---------------------------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																									|
|--------------------------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : AxCadastro para a tabela ZZK de Manutencao da Tabela de Clientes x Cod. Servico x Actions  	|
|--------------------------------------------------------------------------------------------------------------------------------------------------------------	|	
*/


user function axZZK()

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
		AxCadastro("ZZK","Manutencao da Tabela de Relacionamento entre Clientes x Cod. Servico x Actions")
	else
	    alert ("Usuário sem permissão para acessar esse módulo !!")
	endif
	
Return 
