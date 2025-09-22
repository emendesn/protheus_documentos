User Function Tfina070()
Local aVetor := {}

lMsErroAuto := .F.

aVetor := {{"E1_PREFIXO"	 ,"   "             ,Nil},;
				{"E1_NUM"		 ,"000001"           ,Nil},;
				{"E1_PARCELA"	 ," "               ,Nil},;
				{"E1_TIPO"	    ,"DP "             ,Nil},;
				{"AUTMOTBX"	    ,"NOR"             ,Nil},;
				{"AUTDTBAIXA"	 ,dDataBase         ,Nil},;
				{"AUTDTCREDITO" ,dDataBase         ,Nil},;
				{"AUTHIST"	    ,'Baixa Automatica',Nil},;
				{"AUTVALREC"	 ,125               ,Nil }}
MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Inclusao

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return