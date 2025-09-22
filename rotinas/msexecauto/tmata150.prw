User Function Tmata150()
Local aCab  :={}
Local aItem := {}

lMsErroAuto := .F.

aCab := {	{"C8_NUM"	,"000001"			,NIL},;
            {"C8_COND"  ,"001"	     		,NIL}}

aadd(aItem,   {{"C8_ITEM","01" ,NIL},;
					{"C8_FORNECE","999999" ,NIL},;
					{"C8_LOJA","01" ,NIL},;
					{"C8_PRECO",10 ,NIL},;
	            {"C8_TOTAL"	,10 ,NIL}})
	            
MSExecAuto({|x,y,z| mata150(x,y,z)},aCab,aItem,3) //Atualiza 

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return