User Function TCona050()
Local aCab	:= {}
Local aItem	:= {}
Local aTotItem := {}

lMsErroAuto := .F.

aCab := {	{"I2_DATA"		,ctod("04/06/00")	,NIL},;
			{"I2_LOTE"		,"0000"				,NIL},;
			{"I2_DOC"	   ,"000007"			,NIL}}
			
aItem := {	{"I2_LINHA"			,"01"	, NIL},;
		 	{"I2_DC"			,"D"			, NIL},;
			{"I2_DEBITO"	,"11101"		,NIL},;
			{"I2_VALOR"		,10			,NIL},;
			{"I2_HIST"		,"TESTE"		,NIL}}

Aadd(aTotItem,aItem)

aItem := {	{"I2_LINHA"			,"02"	, NIL},;
		 	{"I2_DC"			,"C"			, NIL},;
			{"I2_CREDITO"	,"1110201"	,NIL},;
			{"I2_VALOR"		,10			,NIL},;
			{"I2_HIST"		,"TESTE"		,NIL}}

Aadd(aTotItem,aItem)


MSExecAuto({|x,y,Z| Cona050(x,y,Z)},NIL,aCab,aTotItem) 

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return