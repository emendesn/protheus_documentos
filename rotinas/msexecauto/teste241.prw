FUNCTION Teste241
Cad241()
msgstop("Fim...")
Return .t.

Function Cad241()
Local aCab  :={}
Local aItem := {}
lMSHelpAuto := .F. // para mostrar os erro na tela
aCab := {	{"D3_DOC"	,"000009"			,NIL},;
            {"D3_TM"    	,"501"	     		,NIL},;
            {"D3_CC"    	,"000000001"   		,NIL},;
            {"D3_EMISSAO"	,dDataBase			,Nil}} 

aadd(aItem, {    {"D3_COD"		,"000000000000001" ,NIL},;
            {"D3_QUANT"		,10			   ,NIL}   })

aadd(aItem, {    {"D3_COD"		,"000000000000002" ,NIL},;
            {"D3_QUANT"		,20			   ,NIL}   })


MSExecAuto({|x,y| MATA241(x,y)},aCab,aItem)
Return   