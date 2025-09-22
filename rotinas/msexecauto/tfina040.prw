User Function TFina040()
Local aVetor := {}

lMsErroAuto := .F.

aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
				{"E1_NUM"	   ,"000001"         ,Nil},;
				{"E1_PARCELA" ," "             ,Nil},;
				{"E1_TIPO"	   ,"DP "            ,Nil},;
				{"E1_NATUREZ" ,"001"      ,Nil},;
	          	{"E1_CLIENTE" ,"999999"        ,Nil},;
             	{"E1_LOJA"	   ,"00"            ,Nil},;
	          	{"E1_EMISSAO" ,dDataBase       ,Nil},;
		       	{"E1_VENCTO"	,dDataBase       ,Nil},;
		       	{"E1_VENCREA" ,dDataBase       ,Nil},;
		       	{"E1_VALOR"	,125             ,Nil }}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao

/*
aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
             	{"E1_NUM"	   ,"000001"         ,Nil},;
             	{"E1_PARCELA" ," "             ,Nil},;
             	{"E1_TIPO"	   ,"DP "            ,Nil},;
	          	{"E1_NATUREZ" ,"001"      ,Nil},;
		       	{"E1_VALOR"	,250             ,Nil }}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
             	{"E1_NUM"	   ,"000001"         ,Nil},;
             	{"E1_PARCELA" ," "             ,Nil},;
             	{"E1_TIPO"	   ,"DP "            ,Nil},;
	          	{"E1_NATUREZ" ,"001"      ,Nil}}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,5) //Exclusao
*/

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return