FUNCTION Teste140()
Cad140()
Exc140()
msgstop("Fim...")
Return .t.
     

Function Cad140()
lMSHelpAuto := .t. // para mostrar os erro na tela
lMsErroAuto := .f.
aCab := {	{"F1_TIPO"		,'N'			,NIL},;
			{"F1_DOC"		,"000003"		,NIL},;
			{"F1_SERIE"		,"A  "			,NIL},;
			{"F1_EMISSAO"	,dDataBase		,NIL},;									
			{"F1_FORNECE"	,'000006'    	,NIL},;		
			{"F1_LOJA"	   ,'00'        	,NIL},;		
			{"F1_FRETE" 	,'1000'     	,NIL},;		
			{"F1_ESPECIE"	,'NF'    		,NIL},;  
			{"F1_COND"		,'1'			,NIL},;
            {"F1_ICMSRET"	,180			,Nil}}                                                   
            
aItens :={}
aItem1:={	{"D1_COD"		,"000000000000001", NIL},;
			{"D1_UM"		,'UN'				,NIL},;
			{"D1_QUANT"		,1					,NIL},;
			{"D1_VUNIT"		,10000				,NIL},;
			{"D1_TOTAL"		,10000				,NIL},;
			{"D1_VALIPI"	,100				,NIL},;
			{"D1_VALICM"	,180				,NIL},;
			{"D1_TES"		,'1'				,NIL},;												
			{"D1_CF"		,'112'				,NIL},;                                                    
			{"D1_RATEIO" 	,'2'				,NIL},;                                                    												
			{"D1_LOCAL"		,'01'				,NIL}}

aadd(aitens,aItem1)

aItem2:={	{"D1_COD"		,"000000000000001", NIL},;
			{"D1_UM"		,'UN'				,NIL},;
			{"D1_QUANT"		,1					,NIL},;
			{"D1_VUNIT"		,10000				,NIL},;
			{"D1_TOTAL"		,10000				,NIL},;
			{"D1_VALIPI"	,100				,NIL},;
			{"D1_VALICM"	,180				,NIL},;
			{"D1_TES"		,'1'				,NIL},;												
			{"D1_CF"		,'112'				,NIL},;                                                    
			{"D1_RATEIO" 	,'2'				,NIL},;                                                    												
			{"D1_LOCAL"		,'01'				,NIL}}

aadd(aitens,aItem2)

MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,3)
If lMsErroAuto
   cpath := '\auto'
   cFile := 'meuerro.log'
   MostraErro(cpath,cfile`)

EndIF
Return


Function Exc140()
PRIVATE lMSHelpAuto := .F. // para mostrar os erro na tela
aDel140Cab   :={{'F1_DOC'      ,"000002"	,NIL},;
                 {'F1_SERIE'    ,"A  "		,NIL},;
                 {"F1_FORNECE"  ,'000006'  ,NIL},;		
                 {"F1_LOJA"	    ,'00'   	,NIL}}		

aDel140Item   :={{'D1_DOC'      ,"000002"	,NIL},;
                  {'D1_SERIE'     ,"A  "  	,NIL},;
                  {"D1_FORNECE"	  ,'000006' ,NIL},;		
                  {"D1_LOJA"	  ,'00'   	,NIL}}		
							                         
MSExecAuto({|x,y,z| MATA140(x,y,z)},aDel140Cab,{aDel140Item},5)
Return
