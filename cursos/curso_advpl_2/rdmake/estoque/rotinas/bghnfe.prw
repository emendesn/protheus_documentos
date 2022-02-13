#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHNFE บAutor  ณ Wilker Mar็al        บ Data ณ  18/06/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a  para Geracao de nota de entrada       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BGHNFE()

Private cPerg   := PADR("BGHNFE",10) //Ajustar para 6 caso seja Protheus 8
Private cEol    := CHR(13)+CHR(10)
Private cArqTxt
Private n_arq

nOpc := 0
@ 0,0 TO 170,500 DIALOG oDlgMan TITLE "Nota de Entrada"
@ 15,015 SAY "Esta rotina tem o objetivo Gerar Nota de Entrada de  "	 Size 300
@ 25,015 SAY "Devolu็ใo de Osasco para Alphaville"	                 	 Size 300
//@ 35,015 SAY "para inventแrio" Size 300
@ 65,015 BUTTON "Executar" SIZE 30,11 OF oDlgMan PIXEL ACTION (Processa({|| OkProc()}),Close(oDlgMan))
@ 65,050 BUTTON "Cancelar" SIZE 30,11 OF oDlgMan PIXEL ACTION Close(oDlgMan)

ACTIVATE MSDIALOG oDlgMan CENTERED

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpArquivoบAutor  ณWilker Mar็al    บ Data ณ  06/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Importa Arquivo TXT Mediante Layout Selecionado  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COVIDIEN                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OKProc()
//Pegando somente os registros de quantidade original sem estar totalmente liberada para fazer o enderecamento
Local nI
Local CMV_PAR01
Local CMV_PAR02
Local CMV_PAR03
Local cItens    := '0000'
Local aCab 		:= {}
Local aItens   	:= {}
Private _aB6Acum:= {}
//Local CMV_PAR04   

Private cCliBGHM := Alltrim(GetMv("MV_CLIBGHM",.F.,"Z018LW"))
Private cLojBGHM := Alltrim(GetMv("MV_LOJBGHM",.F.,"01"))   
Private cFilMDes := Alltrim(GetMv("MV_MUDFDES",.F.,"02")) 
Private cFilMOri := Alltrim(GetMv("MV_MUDFORI",.F.,"06")) 
Private cTESEnTM := Alltrim(GetMv("MV_TESENTM",.F.,"308")) 



ValidPerg()
if !Pergunte(cPerg,.T.)
	Return
Endif

CMV_PAR01:= MV_PAR01
CMV_PAR02:= MV_PAR02
CMV_PAR03:= MV_PAR03
//CMV_PAR04:= MV_PAR04

cArqTxt := alltrim(MV_PAR01)+"\"+"BaixaCQ_"+DTOS(dDataBase)+"_"+StrTran(Time(),":","")
cArqTxt	:= StrTran(Alltrim(cArqTxt)+".LOG","\\","\")
n_arq	:= fcreate(cArqTxt)


cQuery := " SELECT *  "
cQuery += " FROM " + retsqlname("SD2") +" D2 "
cQuery += " LEFT JOIN " + retsqlname("SF2") + " F2  ON  "
cQuery += " 	F2_FILIAL=D2_FILIAL AND "
cQuery += " 	F2_DOC=D2_DOC AND "
cQuery += " 	F2_SERIE=D2_SERIE AND "
cQuery += " 	F2_CLIENTE=D2_CLIENTE AND "
cQuery += " 	F2_LOJA=D2_LOJA  AND " 
cQuery += " 	F2.D_E_L_E_T_<>'*' "
cQuery += " WHERE D2_FILIAL='"+cFilMDes+"'"
cQuery += " 	AND D2_DOC = '"+MV_PAR03+"'"
cQuery += " 	AND D2_SERIE = '"+MV_PAR04+"'"
cQuery += " 	AND D2.D_E_L_E_T_=' '"
cQuery += " 	AND D2_CLIENTE= '"+cCliBGHM+"' "
cQuery += " 	AND D2_LOJA= '"+cLojBGHM+"' "
MEMOWRITE("C:\temp\Query\BGHNFE.SQL",cQuery)


If Select("TSQL") <> 0
	TSQL->(dbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "TSQL"
TCSETFIELD("TSQL","D2_EMISSAO","D")

DBSelectArea("TSQL")
DBGoTop()
nTotal := 0
nCont  := 0
dbEval( {|| nTotal++ } )
dbGoTop()
ProcRegua(nTotal)

//while .T.
nReg := 0

DBSelectArea("SA2")
DBSetOrder(1)
DBSeek(xFilial("SA2")+CMV_PAR01+CMV_PAR02)

//Cabecalho
aCab := {	{"F1_TIPO"   ,"N"      	,NIL},;
{"F1_FILIAL" ,xFilial("SF1")    	,NIL},;
{"F1_FORMUL" ,"N"        			,NIL},;
{"F1_EMISSAO",TSQL->D2_EMISSAO      ,NIL},;
{"F1_DTDIGIT",dDataBase       	    ,NIL},;
{"F1_FORNECE",MV_PAR01          	,NIL},;
{"F1_SERIE"  ,TSQL->D2_SERIE       	,NIL},;//
{"F1_DOC"    ,MV_PAR03	     		,NIL},;
{"F1_LOJA"   ,MV_PAR02          	,NIL},;
{"F1_CHVNFE" ,TSQL->F2_CHVNFE     	,NIL},;
{"F1_ESPECIE","SPED"        	    ,NIL}}

aItem:={}


WHILE !TSQL->(EOF())
	
	//	nCont++
	//	IncProc("Processando registros "+alltrim(str(nCont))+" de "+alltrim(str(nTotal)))
	//	nReg++
	
	cNfOri:=Alltrim(TSQL->D2_NFORI)
	cSerOri:=Alltrim(TSQL->D2_SERIORI)
	cProd:=Alltrim(TSQL->D2_COD)
	
	
	DBSelectArea("SB1")
	DBSetOrder(1)
	DBSeek(xFilial("SB1")+cProd)
	cItens := Soma1(cItens,4)
	
	//Pegar IdentB6
	cQuery1 := " SELECT *  "
	cQuery1 += " FROM " + retsqlname("SB6") +" B6 "
	cQuery1 += " WHERE B6_DOC = '"+cNfOri+"' AND B6_SERIE='"+cSerOri+"'   "
	cQuery1 += " AND B6_PRODUTO='"+cProd+"'   "
	cQuery1 += " AND B6_FILIAL='"+cFilMOri+"'"
	cQuery1 += " AND B6.D_E_L_E_T_=' '"
	cQuery1 += " AND B6_CLIFOR= '"+MV_PAR01+"' "
	cQuery1 += " AND B6_LOJA= '"+MV_PAR02+"'   "
	cQuery1 += " AND B6_SALDO > 0   "
   	cQuery1 += " ORDER BY B6_IDENT  "
	MEMOWRITE("C:\temp\Query\BGHNFE1.SQL",cQuery1)
	
	If Select("SQL1") <> 0
		SQL1->(dbCloseArea())
	EndIf
	TCQUERY cQuery1 NEW ALIAS "SQL1"
	
	dbSelectArea("SQL1")
	dbGotop()
	If  SQL1->(!EOF())
		_nQtde  := TSQL->D2_QUANT
		While SQL1->(!EOF()) .and. _nQtde > 0
			
			
			cIdent:=SQL1->B6_IDENT
			
			_lSaldo := .T.
			_nQtde  := TSQL->D2_QUANT
			_nPosTerc := aScan(_aB6Acum, { |X| X[1] == cIdent })
			if _nPosTerc > 0
				If _aB6Acum[_nPosTerc,2] < _nQtde
					_aB6Acum[_nPosTerc,2] := _aB6Acum[_nPosTerc,2] + _nQtde
					_nQtde  := 0
				Else
					_lSaldo := .F.
				Endif
			Else
				If _nQtde <= SQL1->B6_SALDO
					aAdd(_aB6Acum, {cIdent, _nQtde })
					_nQtde  := 0
				Else
					_lSaldo := .F.
				Endif
			Endif
			
			If _lSaldo
				
				aItem := {	{"D1_FILIAL" ,xFilial("SD1")    	,NIL},;
				{"D1_TIPO"   ,"N"								,NIL},;
				{"D1_COD"    ,TSQL->D2_COD			            ,NIL},;
				{"D1_ITEM"   ,cItens							,NIL},;
				{"D1_UM"     ,SB1->B1_UM						,NIL},;
				{"D1_CONTA"  ,SB1->B1_CONTA        				,NIL},;
				{"D1_CC"  	 ,TSQL->D2_CCUSTO					,NIL},;
				{"D1_LOCAL"  ,TSQL->D2_LOCAL	   				,NIL},;
				{"D1_TES"    ,cTESEnTM 		     				,NIL},;
				{"D1_NFORI"  ,TSQL->D2_NFORI  	   				,NIL},;
				{"D1_SERIORI",TSQL->D2_SERIORI	   				,NIL},;
				{"D1_ITEMORI",TSQL->D2_ITEMORI	   				,NIL},;
				{"D1_IDENTB6",cIdent        	   				,NIL},;
				{"D1_QUANT"  ,TSQL->D2_QUANT					,NIL},;
				{"D1_VUNIT"  ,TSQL->D2_PRCVEN					,NIL},;
				{"D1_TOTAL"  ,TSQL->D2_TOTAL					,NIL},;
				{"D1_DOC"    ,MV_PAR03	      					,NIL},;
				{"D1_SERIE"  ,TSQL->D2_SERIE					,NIL},;
				{"D1_FORNECE",MV_PAR01          				,NIL},;                                                    
				{"D1_LOJA"   ,MV_PAR02          				,NIL},;
				{"D1_EMISSAO",TSQL->D2_EMISSAO					,NIL},;
				{"D1_DTDIGIT",dDataBase     					,NIL},;
				{"D1_DTDOCA" ,dDataBase         				,NIL},;
				{"D1_HRDOCA" ,"000000"           				,NIL}}
				
				aadd(aitens,aItem) 	
			Endif
			
			SQL1->(dbSkip())
		EndDo
	Endif
	DbSelectArea("TSQL")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
lMsErroAuto := .F.
_nopc:=3
msExecAuto({|x,Y,Z|mata103(x,Y,Z)},aCab,aitens,_nopc)



If lMsErroAuto
	DisarmTransaction()
	Mostraerro()
EndIf

MsgINFO("Gera็ใo de Nota Fiscal de Entrada Finalizado com Sucesso!!!","OK!!!","OK")
//	IF TSQL->(EOF())
//		EXIT
//	ENDIF
//ENDDO



Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณVALIDPERG ณ Autor ณ Wilker Mar็al      ณ Data ณ 13/07/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluกndo-as caso no existam        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especกfico para clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aPerg:={}


Aadd(aPerg,{cPerg,"01","Fornecedor              ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","","","","","","",""})
Aadd(aPerg,{cPerg,"02","Loja                    ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPerg,{cPerg,"03","Nr.Nota          "        ,"","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPerg,{cPerg,"04","Serie Nota          "        ,"","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPerg,{cPerg,"04","Qtde. de Itens por Nota"  ,"","","mv_ch4","N",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aPerg)
	If !dbSeek(cPerg+aPerg[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aPerg[i])
				FieldPut(j,aPerg[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

