User Function Tcfgx016()
Local aCab := {}
Local aItem:= {}

//Fazer a alteracao na tabela 00

lMsErroAuto := .F.

aCab :={	{"X5_TABELA"	,"XX",Nil}}

aadd(aItem,  {	{"X5_CHAVE"		,"TESTE1"		, NIL},;
					{"X5_DESCRI"	,"PORTUGUES"	,NIL},;
					{"X5_DESCSPA"	,"ESPANHOL"		,NIL},;
					{"X5_DESCENG"	,"INGLES"		,NIL}})

MSExecAuto({|x,y| cfgx016(x,y)},aCab,aItem)

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif

Return