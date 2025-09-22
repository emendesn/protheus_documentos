User Function Tmata416()
Local aCab := {}
Local aItem:= {}

lMsErroAuto := .F.

aCab:= {		{"CJ_NUM","000001",NIL},;
				{"CJ_CLIENTE","000001",NIL},;
				{"CJ_CONDPAG","001",NIL}}
				
Aadd(aItem, {{"CK_ITEM","01",NIL},; 
				{"CK_PRODUTO","999999999999999",NIL},; 
				{"CK_PRCVEN",10,NIL},;
				{"CK_VALOR",10,NIL},;
				{"CK_TES","501",NIL},;
				{"CK_QTDVEN",1,NIL}})
				
MSExecAuto({|x,y| mata416(x,y)},aCab,aItem)

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return