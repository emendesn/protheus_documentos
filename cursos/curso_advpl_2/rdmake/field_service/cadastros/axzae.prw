#INCLUDE 'RWMAKE.CH'

/*
|-------------------------------------------------------------------------------|	
|	Programa : AXZAE				| 	Outubro de 2012							|
|-------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Maintech										|
|-------------------------------------------------------------------------------|	
|	Descrição : AxCadastro para a tabela ZAE de Cadastro de Metas por Produção	|
|-------------------------------------------------------------------------------|	
*/


user function AXZAE()

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
		AxCadastro("ZAE","Manutencao da Tabela de Metas por Produção")
	else
	    alert ("Usuário sem permissão para acessar esse módulo !!")
	endif
	
Return 
