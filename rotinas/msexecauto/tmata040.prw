User Function TMata040()
Local aVetor := {}

lMsErroAuto := .F.
/*
aVetor:={ {"A3_COD"       ,"999998"           ,Nil},; // Codigo       C 06
				 {"A3_NOME"      ,"VENDEDOR TESTE"  ,Nil},; // Nome         C 40
				 {"A3_END"       ,"RUA DOS VENDEDORES"	 ,Nil},; // Endereco     C 40
				 {"A3_MUN"       ,"SAO PAULO"	 ,Nil},; // Cidade       C 15
				 {"A3_EST"       ,"SP"				    ,Nil}}  // Estado       C 02
MSExecAuto({|x,y| Mata040(x,y)},aVetor,3) //Inclusao

aVetor:={ {"A3_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A3_NOME"      ,"VENDEDOR TESTE"  ,Nil},; // Nome         C 40
				 {"A3_END"       ,"RUA DOS VENDEDORES"	 ,Nil},; // Endereco     C 40
				 {"A3_MUN"       ,"SAO PAULO"	 ,Nil},; // Cidade       C 15
				 {"A3_EST"       ,"SP"				    ,Nil}}  // Estado       C 02
MSExecAuto({|x,y| Mata040(x,y)},aVetor,3) //Inclusao
*/
/*
aVetor:={ {"A3_COD"       ,"999999"           ,Nil},; // Codigo       C 06
				 {"A3_NOME"      ,"VENDEDOR TESTE"  ,Nil},; // Nome         C 40
				 {"A3_TEL"     ,"1245674"  ,Nil},; 
				 {"A3_BAIRRO"  ,"VENDEDS"  ,Nil}}
MSExecAuto({|x,y| Mata040(x,y)},aVetor,4) //Alteracao
*/

aVetor:={ {"A3_COD"       ,"999999"           ,Nil}} // Codigo       C 06
MSExecAuto({|x,y| Mata040(x,y)},aVetor,5) //Exclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return