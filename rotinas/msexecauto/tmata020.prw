User Function TMata020()
Local aVetor := {}

lMsErroAuto := .F.

aVetor := {{"A2_COD"    ,"999999"		,nil},;
				{"A2_LOJA"   ,"01" 			,nil},;
				{"A2_NOME"   ,"Fornecedor Teste" ,nil},;
				{"A2_NREDUZ" ,"Teste F" 	,nil},;
				{"A2_END"    ,"Rua teste" 	,nil},;
				{"A2_MUN"    ,"teste" 		,nil},;
				{"A2_EST"    ,"SP" 			,nil}}
MSExecAuto({|x,y| Mata020(x,y)},aVetor,3) //Inclusao

/*
aVetor := {{"A2_COD"    ,"999999"		,nil},;
				{"A2_LOJA"   ,"01" 			,nil},;
				{"A2_MUN"    ,"RIO" 		,nil}}
MSExecAuto({|x,y| Mata020(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor := {{"A2_COD"    ,"999999"		,nil},;
				{"A2_LOJA"   ,"01" 			,nil}}
MSExecAuto({|x,y| Mata020(x,y)},aVetor,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return