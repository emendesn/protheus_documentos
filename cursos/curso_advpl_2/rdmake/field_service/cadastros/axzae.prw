#INCLUDE 'RWMAKE.CH'

/*
|-------------------------------------------------------------------------------|	
|	Programa : AXZAE				| 	Outubro de 2012							|
|-------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Maintech										|
|-------------------------------------------------------------------------------|	
|	Descri��o : AxCadastro para a tabela ZAE de Cadastro de Metas por Produ��o	|
|-------------------------------------------------------------------------------|	
*/


user function AXZAE()

	Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
	Private lUsrAut	:= .F.
u_GerA0003(ProcName())
/*	
	For i := 1 to Len(aGrupos)
		
		//Usuarios de Autorizado a entrar no m�dulo
		If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES"
			lUsrAut  := .T.
		EndIf
		
	Next i
*/	
	lUsrAut  := .T.
	if lUsrAut
		AxCadastro("ZAE","Manutencao da Tabela de Metas por Produ��o")
	else
	    alert ("Usu�rio sem permiss�o para acessar esse m�dulo !!")
	endif
	
Return 
