User Function Tmata110()
Local aCab := {}
Local aItem:= {}

lMsErroAuto := .F.

aCab:= {		{"C1_NUM",GetSxeNum("SC1","C1_NUM"),NIL}}
				
Aadd(aItem, {	{"C1_ITEM","01",NIL},; 
					{"C1_PRODUTO","999999999999999",NIL},; 
					{"C1_QUANT",1,NIL}})
				
Aadd(aItem, {	{"C1_ITEM","02",NIL},; 
					{"C1_PRODUTO","000000000000001",NIL},; 
					{"C1_QUANT",1,NIL}})

MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,3) //Inclusao

/*
aCab:= {		{"C1_NUM","000001",NIL}}
				
Aadd(aItem, {	{"C1_ITEM","02",NIL},; 
					{"C1_PRODUTO","000000000000001",NIL},; 
					{"C1_QUANT",2,NIL}})

MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,4) //Alteracao
*/
/*
aCab:= {		{"C1_NUM","000001",NIL}}
				
Aadd(aItem, {	{"C1_ITEM","01",NIL}})

Aadd(aItem, {	{"C1_ITEM","02",NIL}})
					
MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return