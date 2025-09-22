User Function Tmata240()
Local aVetor := {}

lMsErroAuto := .F.

aVetor:={ {"D3_TM","401",NIL},; 
				 {"D3_COD",SB1->B1_COD,NIL},;
				 {"D3_EMISSAO",ddatabase,NIL},;
				 {"D3_QUANT",2,NIL}}
MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return