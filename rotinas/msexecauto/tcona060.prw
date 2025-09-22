User Function TCona060()
Local aVetor := {}

Aadd(aVetor,{"I3_CUSTO","001",NIL})
Aadd(aVetor,{"I3_DESC","CC TESTE",NIL})
lMsErroAuto := .F.
MSExecAuto({|x,y| Cona060(x,y)},aVetor,3) 

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return