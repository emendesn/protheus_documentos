User Function Tmata080()
Local aVetor := {}

lMsErroAuto := .F.
/*
aVetor:={ {"F4_CODIGO" ,"001"           ,Nil},; 
				 {"F4_TIPO" ,"E"	 ,Nil},;
				 {"F4_ICM" ,"N"	 ,Nil},;
				 {"F4_IPI" ,"N"	 ,Nil},;
				 {"F4_CREDICM" ,"N"	 ,Nil},;
				 {"F4_CREDIPI" ,"N"	 ,Nil},;
				 {"F4_DUPLIC" ,"N"	 ,Nil},;
				 {"F4_ESTOQUE" ,"N"	 ,Nil},;
				 {"F4_CF" ,"111"	 ,Nil},;
				 {"F4_TEXTO" ,"TESTE"	 ,Nil},;
				 {"F4_PODER3" ,"N"	 ,Nil},;
				 {"F4_LFICM"  ,"N"				    ,Nil},;
				 {"F4_LFIPI"  ,"N"				    ,Nil},;
				 {"F4_LFICM"  ,"N"				    ,Nil},;
				 {"F4_DESTACA"  ,"N"				    ,Nil},;
				 {"F4_INCIDE"  ,"N"				    ,Nil},;
				 {"F4_COMPL"  ,"N"				    ,Nil},;
				 {"F4_ATUTEC"  ,"N"				    ,Nil},;
				 {"F4_ATUATF"  ,"N"				    ,Nil},;
				 {"F4_TPIPI"  ,"B"				    ,Nil},;
				 {"F4_CREDST"  ,"2"				    ,Nil}}
MSExecAuto({|x,y| mata080(x,y)},aVetor,3) //Inclusao
*/
/*
aVetor:={ {"F4_CODIGO" ,"001"           ,Nil},; 
				 {"F4_ESTOQUE" ,"S"	 ,Nil}}
MSExecAuto({|x,y| mata080(x,y)},aVetor,4) //Alteracao
*/

aVetor:={ {"F4_CODIGO"       ,"001"           ,Nil}} // Codigo       C 06
MSExecAuto({|x,y| mata080(x,y)},aVetor,5) //Exclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return