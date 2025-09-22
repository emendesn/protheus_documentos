User Function TMata010()
Local aVetor := {}

lMsErroAuto := .F.

aVetor:= {{"B1_COD"     ,"999999999999999",Nil},;
 				 {"B1_CODITE"  ,"999999999999999999999999999",Nil},;
 				 {"B1_DESC"    ,"Teste"        ,Nil},;
				 {"B1_TIPO"    ,"PA"           ,Nil},; 
				 {"B1_UM"      ,"UN"           ,Nil},; 
				 {"B1_LOCPAD"  ,"01"           ,Nil},; 
				 {"B1_PICM"    ,0              ,Nil},; 
				 {"B1_IPI"     ,0              ,Nil},; 
				 {"B1_PRV1"    ,100            ,Nil},; 
				 {"B1_TIPOCQ"  ,"M"            ,Nil},; 
				 {"B1_CONTRAT" ,"N"            ,Nil},; 
				 {"B1_LOCALIZ" ,"N"            ,Nil},; 
				 {"B1_CODBAR"  ,'123456'       ,Nil},; 
				 {"B1_IRRF"    ,"N"            ,Nil},; 
				 {"B1_CONTSOC" ,"N"            ,Nil},; 
				 {"B1_MRP"     ,"N"            ,Nil}} 
MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Inclusao

/*
aVetor:= {{"B1_COD"     ,"999999999999999",Nil},;
				 {"B1_CODBAR"  ,'898989'       ,Nil}} 
MSExecAuto({|x,y| Mata010(x,y)},aVetor,4) //Alteracao
*/
/*
aVetor:= {{"B1_COD"     ,"999999999999999",Nil}}
MSExecAuto({|x,y| Mata010(x,y)},aVetor,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return