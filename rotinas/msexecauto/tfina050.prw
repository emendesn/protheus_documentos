User Function TFina050()
Local aVetor := {}

lMsErroAuto := .F.

aVetor :={	{"E2_PREFIXO"	,'999',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'1',Nil},;
				{"E2_TIPO"		,'NDF',Nil},;			
				{"E2_NATUREZ"	,'001',Nil},;
				{"E2_FORNECE"	,'999999',Nil},; 
				{"E2_LOJA"		,'01',Nil},;      
				{"E2_EMISSAO"	,dDataBase,NIL},;
				{"E2_VENCTO"	,dDataBase,NIL},;					 
				{"E2_VENCREA"	,dDataBase,NIL},;					 					
				{"E2_VALOR"		,1100,Nil}}

MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,3) //Inclusao

/*
aVetor :={	{"E2_PREFIXO"	,'999',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'1',Nil},;
				{"E2_TIPO"		,'NDF',Nil},;			
				{"E2_NATUREZ"	,'001',Nil},;
				{"E2_VENCTO"	,dDataBase,NIL},;					 
				{"E2_VENCREA"	,dDataBase+5,NIL},;					 					
				{"E2_VALOR"		,2200,Nil}}

MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,4) //Alteracao
*/
/*
aVetor :={	{"E2_PREFIXO"	,'999',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'1',Nil},;
				{"E2_TIPO"		,'NDF',Nil},;			
				{"E2_NATUREZ"	,'001',Nil}}

MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5) //Exclusao
*/

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return