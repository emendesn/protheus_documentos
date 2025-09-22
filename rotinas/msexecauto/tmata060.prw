User Function Tmata060()
Local aVetor := {}

lMsErroAuto := .F.


aVetor:={	{"A5_FORNECE"	,"999999"         	,Nil},;
			{"A5_PRODUTO"	,"999999999999999"	,Nil}} 
MSExecAuto({|x,y| mata060(x,y)},aVetor,3) //Inclusao

/*
aVetor:={	{"A5_FORNECE"	,"999999"	,Nil},;
				{"A5_LOJA"		,"01"			,Nil},;
				{"A5_NOTA"		,5				,Nil}} 
lMsErroAuto := .F.
MSExecAuto({|x,y| mata060(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor:={	{"A5_FORNECE"	,"999999"	,Nil},;
				{"A5_LOJA"		,"01"			,Nil},;
				{"A5_PRODUTO" ,"999999999999999"	,Nil}} 
MSExecAuto({|x,y| mata060(x,y)},aVetor,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return