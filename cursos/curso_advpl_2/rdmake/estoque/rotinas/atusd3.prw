#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUSD3    บAutor  ณEduardo Barbosa     บ Data ณ  05/12/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Para Geracao do SD3 Automatico			           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ATUSD3(_cTm,_cProdD3,_cLocal,_nQuant,_cLocaliz,_cDoc)

Local _aVetor		:= {}
Local _cTime    	:= TIME()
Local _aAreaAtu 	:= GetArea()
Local _cTm		 	:= _cTm
Local _cProdD3	 	:= _cProdD3
Local _cDoc			:= _cDoc
Local _lRet			:= .T.

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se durante a digitacao no foi incluido um documentoณ
//ณ com o mesmo numero por outro usu rio.                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea('SD3')
dbSetOrder(2)
dbSeek(xFilial()+_cDoc)
cMay := "SD3"+Alltrim(xFilial())+_cDoc
lFirstNum := .T.
While D3_FILIAL+D3_DOC==xFilial()+_cDoc .Or.!MayIUseCode(cMay)
	If D3_ESTORNO # "S"
		If lFirstNum
			_cDoc := NextNumero("SD3",2,"D3_DOC",.T.)
			_cDoc := A261RetINV(_cDoc)
			lFirstNum := .F.
		Else
			_cDoc := Soma1(_cDoc,6)
		EndIf
		lChangeDoc := .T.
		cMay := "SD3"+Alltrim(xFilial())+_cDoc
	EndIf
	dbSkip()
EndDo


aVetor:={{"D3_TM"	,_cTm,NIL},;
{"D3_COD"			,_cProdD3,NIL},;
{"D3_QUANT"			,_nQuant,NIL},;
{"D3_DOC"			,_cDoc,NIL},;
{"D3_EMISSAO"		,dDataBase,NIL},;
{"D3_LOCAL"			,_cLocal,NIL},;
{"D3_LOCALIZ"		,_cLocaliz,NIL}}

lMSHelpAuto := .F.
lMSErroAuto := .F.
MSExecAuto({|x,y| MATA240(x,y)},aVetor,3)
If lMSErroAuto
	_lRet := .F.
Endif
RestArea(_aAreaAtu)
Return _lRet
