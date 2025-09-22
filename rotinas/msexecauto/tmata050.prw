User Function TMata050()
Local aVetor := {}

lMsErroAuto := .F.
/*
aVetor:={ {"A4_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A4_NOME"      ,"TRANSPORTADORA TESTE"  ,Nil},; // Nome         C 40
				 {"A4_END"       ,"RUA DAS TRANSPORTADORAS"	 ,Nil},; // Endereco     C 40
				 {"A4_MUN"       ,"SAO PAULO"	 ,Nil},; // Cidade       C 15
				 {"A4_EST"       ,"SP"				    ,Nil}}  // Estado       C 02
MSExecAuto({|x,y| Mata050(x,y)},aVetor,3) //Inclusao
*/
/*
aVetor:={ {"A4_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A4_TEL"  ,"6485738"  ,Nil}}
MSExecAuto({|x,y| Mata050(x,y)},aVetor,4) //Alteracao
*/

aVetor:={ {"A4_COD"       ,"999999"           ,Nil}} // Codigo       C 06
MSExecAuto({|x,y| Mata050(x,y)},aVetor,5) //Exclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return