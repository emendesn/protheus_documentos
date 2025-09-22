User Function Tmata270()
Local aVetor := {}

lMsErroAuto := .F.

aVetor:={	{"B7_COD","999999999999999",NIL},; 
				{"B7_QUANT",3,NIL},; 				 
				{"B7_DOC","01",NIL}}
MSExecAuto({|x,y| mata270(x,y)},aVetor,3) //Inclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return