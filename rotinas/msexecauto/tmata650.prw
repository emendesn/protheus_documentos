User Function Tmata650()
Local aVetor := {}

lMsErroAuto := .F.
/*
aVetor:={ {"C2_NUM","000001",NIL},; 
				 {"C2_ITEM","01",NIL},;
				 {"C2_SEQUEN","001",NIL},;
				 {"C2_PRODUTO",SB1->B1_COD,NIL},;
				 {"C2_QUANT",20,NIL},;
				 {"C2_DATPRI",ddatabase,NIL},;
				 {"C2_DATPRF",ddatabase,NIL}}
MSExecAuto({|x,y| mata650(x,y)},aVetor,3) //Inclusao
*/
/*
aVetor:={	{"C2_NUM","000001",NIL},; 
				{"C2_QUANT",31,NIL},;
				{"C2_DATPRF",ddatabase+2,NIL}}
MSExecAuto({|x,y| mata650(x,y)},aVetor,4) //Alteracao
*/

aVetor:={ {"C2_NUM","000001",NIL}}
MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return