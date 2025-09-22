User Function Tmata920()
Local aCab := {}
Local aItem:= {}

lMsErroAuto := .F.

aCab := {{"F2_TIPO"		,'N'			,NIL},;
			{"F2_DOC"	   ,"00009"		,NIL},;
			{"F2_EMISSAO"	,dDataBase	,NIL},;									
			{"F2_CLIENTE"	,"000001"   ,NIL},;		
			{"F2_LOJA"	   ,'01'       ,NIL},;		
			{"F2_COND" 	   ,"001"	 	,NIL},;		
			{"F2_ESPECIE"	,'NF'    	,NIL},;
			{"F2_VALBRUT"	,1000    	,NIL}}
			
aadd(aItem,  {	{"D2_ITEM"	,"01"					, NIL},;
					{"D2_COD"	,"999999999999999", NIL},;
					{"D2_QUANT"	,1						,NIL},;
					{"D2_PRCVEN",10000				,NIL},;
					{"D2_TOTAL"	,10000				,NIL},;
					{"D2_TES"	,"501"				,NIL},;																	
					{"D2_LOCAL"	,'01'					,NIL}})			
		
MSExecAuto({|x,y,z| mata920(x,y,z)},aCab,aItem,3) //Inclusao

/*
aCab := {{"F2_TIPO"		,'N'			,NIL},;
			{"F2_DOC"	   ,"00009"		,NIL},;
			{"F2_EMISSAO"	,dDataBase	,NIL},;									
			{"F2_CLIENTE"	,"000001"   ,NIL},;		
			{"F2_LOJA"	   ,'01'       ,NIL},;		
			{"F2_COND" 	   ,"001"	 	,NIL},;		
			{"F2_ESPECIE"	,'NF'    	,NIL},;
			{"F2_VALBRUT"	,1000    	,NIL}}
			
aadd(aItem,  {	{"D2_ITEM"	,"01"					, NIL},;
					{"D2_COD"	,"999999999999999", NIL},;
					{"D2_QUANT"	,1						,NIL},;
					{"D2_PRCVEN",10000				,NIL},;
					{"D2_TOTAL"	,10000				,NIL},;
					{"D2_TES"	,"501"				,NIL},;																	
					{"D2_LOCAL"	,'01'					,NIL}})			
		
MSExecAuto({|x,y,z| mata920(x,y,z)},aCab,aItem,5) //Exclusao
*/
If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return