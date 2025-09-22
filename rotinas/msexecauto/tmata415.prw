User Function Tmata415()
Local aCab := {}
Local aItem:= {}

lMsErroAuto := .F.

aCab:= {		{"CJ_NUM",GetSxeNum("SCJ","CJ_NUM"),NIL},;
				{"CJ_CLIENTE","000001",NIL},;
				{"CJ_CONDPAG","001",NIL}}
				
Aadd(aItem, {	{"CK_PRODUTO","999999999999999",NIL},; 
				{"CK_PRCVEN",10,NIL},;
				{"CK_VALOR",10,NIL},;
				{"CK_TES","501",NIL},;
				{"CK_QTDVEN",1,NIL}})
				
MSExecAuto({|x,y,z| mata415(x,y,z)},aCab,aItem,3) //Inclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return