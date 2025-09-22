User Function Tmata265()
Local aCab := {}
Local aItem:= {}

lMsErroAuto := .F.

aCab:= {	{"DA_PRODUTO"	,"000000000000001",NIL},; 
			{"DA_LOCAL"		,"01"					,NIL}}
				
Aadd(aItem, {	{"DB_ITEM"		,"001"				,NIL},; 
					{"DB_LOCALIZ"	,"TESTE"				,NIL},; 
					{"DB_DATA"		,ddatabase			,NIL},; 
					{"DB_QUANT"		,25					,NIL}})

MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3) //Distribui

/*
aCab:= {	{"DA_PRODUTO"	,"000000000000001",NIL},; 
			{"DA_LOCAL"		,"01"					,NIL}}
				
Aadd(aItem, {	{"DB_ITEM"		,"001"				,NIL},; 
					{"DB_ESTORNO"	,"S"					,NIL},; 
					{"DB_DATA"		,ddatabase			,NIL},; 
					{"DB_QUANT"		,25					,NIL}})

MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,4) //Estorna
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return