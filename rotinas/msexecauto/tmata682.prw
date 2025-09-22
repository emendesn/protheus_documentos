User Function Tmata682()
Local aVetor := {}

lMsErroAuto := .F.

aVetor := {{"H6_RECURSO"	,"0001"		,NIL},;
				{"H6_DTAPONT"	,dDataBase	,NIL},;
				{"H6_HORAINI"	,"11:25"		,NIL},;
				{"H6_HORAFIN"	,"11:30"		,NIL}}
		
MSExecAuto({|x| mata682(x)},aVetor)

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return