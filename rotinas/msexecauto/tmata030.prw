User Function TMata030()
Local aVetor := {}

lMsErroAuto := .F.

aVetor:={ {"A1_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A1_LOJA"      ,"00"               ,Nil},; // Loja         C 02
				 {"A1_NOME"      ,"INC. AUTOMATICO"  ,Nil},; // Nome         C 40
				 {"A1_NREDUZ"    ,"AUTOMATICO"		 ,Nil},; // Nome reduz.  C 20
				 {"A1_TIPO"      ,"R"				    ,Nil},; // Tipo         C 01 //R Revendedor
				 {"A1_END"       ,"RUA AUTOMATICA"	 ,Nil},; // Endereco     C 40
				 {"A1_MUN"       ,"SAO AUTOMATICO"	 ,Nil},; // Cidade       C 15
				 {"A1_EST"       ,"SP"				    ,Nil}}  // Estado       C 02
MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //Inclusao

/*
aVetor:={ {"A1_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A1_LOJA"      ,"00"               ,Nil},; // Loja         C 02
				 {"A1_END"       ,"SEM NOME"	 ,Nil}} // Endereco     C 40
lMsErroAuto := .F.
MSExecAuto({|x,y| Mata030(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor:={ {"A1_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A1_LOJA"      ,"00"               ,Nil}} // Loja         C 02
MSExecAuto({|x,y| Mata030(x,y)},aVetor,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return