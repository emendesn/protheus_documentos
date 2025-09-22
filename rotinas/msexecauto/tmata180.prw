User Function TMata180()
Local aVetor := {}

lMsErroAuto := .F.

aVetor  := {	{"B5_COD" ,"999999999999999"						,Nil},;
					{"B5_CEME"	   ,"NOME CIENTIFICO DO PRODUTO"	,Nil}}

MSExecAuto({|x,y| Mata180(x,y)},aVetor,3) //Inclusao

/*
aVetor  := {	{"B5_COD" ,"999999999999999"	,Nil},;
					{"B5_PRV2",32.20			      ,Nil}}

MSExecAuto({|x,y| Mata180(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor  := {	{"B5_COD" ,"999999999999999"	,Nil}}

MSExecAuto({|x,y| Mata180(x,y)},aVetor,5) //Exclusao
*/

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return