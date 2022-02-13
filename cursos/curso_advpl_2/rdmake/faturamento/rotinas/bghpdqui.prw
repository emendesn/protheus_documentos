#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ BGHPDQUIณ Autor ณ Vinicius Leonardo     ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gerar pedido de Venda para os quiosques com base nos        ฑฑ
ฑฑณ          ณ parametros informados e dados da planilha de acordo         ฑฑ
ฑฑณ          ณ com layout definido pelo TI                                 ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BGHPDQUI()

Local lOk := .F.

Private cPerg		:= "BGHPDQUI"
Private aPlanilha := {} 

ValidPerg(cPerg) // Ajusta as Perguntas do SX1
If Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	lOk := LerCSV()
	If lOk
   		MsAguarde({|| IMPPDVEN()},OemtoAnsi("Processando..."))
   	EndIf	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ IMPPDVEN  ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera Pedidos de Venda                                       ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function IMPPDVEN()

Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca 	:= 0 //Opcao da confirmacao
Local _cArqEmp	:= "" //Arquivo temporario com as empresas a serem escolhidas
Local _aBrowse 	:= {} //array do browse para demonstracao das empresas
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 	:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local aButtons  := {}
Local aCores 	:= {}
Local _aStruTrb	:= {;
{"OK"			, "C", 02, 0},;
{"PRODUTO"		, "C", TamSX3("B1_COD")[1],0},;
{"DESCRI"   	, "C", 50,0},;
{"QTDEST"	    , "N", TamSX3("BF_QUANT") [1],2},;
{"QTDPLA"	    , "N", TamSX3("C6_QTDVEN") [1],2},;
{"QTDSUG"	    , "N", TamSX3("C6_QTDVEN") [1],2},;
{"PRCULT"	    , "C", TamSX3("C6_PRCVEN")[1],0},;
{"CLIENTE"		, "C", TamSX3("A1_COD")[1],0},;
{"LOJA" 		, "C", TamSX3("A1_LOJA")[1],0},;
{"TRANSP"		, "C", TamSX3("A4_COD")[1],0},;
{"CONDPAG"		, "C", TamSX3("C5_CONDPAG")[1],0},;           
{"DIVNEG"		, "C", 02,0},;
{"TES"			, "C", TamSX3("F4_CODIGO")[1],0},;
{"CLIORI"		, "C", TamSX3("A1_COD")[1],0},;
{"LOJORI"		, "C", TamSX3("A1_LOJA")[1],0},;
{"ARMORI"		, "C", TamSX3("B2_LOCAL")[1],0},;
{"ARMAZ"    	, "C", TamSX3("B2_LOCAL")[1],0}}

Private nUltPrc	:= 0
Private nPedVen := 0

Private lInverte	:= .F. //Variaveis para o MsSelect
Private cMarca 		:= GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect
Private oDlg

Private cArmaz	  	:= Alltrim(MV_PAR01)
Private cLclizOut	:= Alltrim(MV_PAR02)
Private nTipoPV  	:= MV_PAR03
Private cCliPv	  	:= Alltrim(MV_PAR04)
Private cLojPv	  	:= Alltrim(MV_PAR05)
Private cTransp		:= Alltrim(MV_PAR06)
Private cCondpgto	:= Alltrim(MV_PAR07)
Private cDivNeg		:= Alltrim(MV_PAR08)
Private cTES		:= Alltrim(MV_PAR09)
Private cPoder3   	:= Posicione("SF4",1,xFilial("SF4") + cTES, "F4_PODER3")
Private cCliOri		:= IIF(cPoder3 == "D",Alltrim(MV_PAR10),"")
Private cLojOri		:= IIF(cPoder3 == "D",Alltrim(MV_PAR11),"")
Private cArmOri		:= IIF(cPoder3 == "D",Alltrim(MV_PAR12),"")
Private _aStruLog 	:= {}
Private _cLog		:= ""

AADD(_aStruLog,{"LOG","C",90,0})

_cArq     := CriaTrab(_aStruLog,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	:= "LOG"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

If nTipoPV==2
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	If !dbSeek(xFilial("SA2")+cCliPv+cLojPv)
		_cLog := "Cod Fornecedor do PV: "+cCliPv+" - "+cLojPv+" - nใo localizado no cadastro."
		GERLOG(_cLog)
	Endif
Else
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If !dbSeek(xFilial("SA1")+cCliPv+cLojPv)
		_cLog := "Cod Cliente do PV: "+cCliPv+" - "+cLojPv+" - nใo localizado no cadastro."
		GERLOG(_cLog)
	Endif
Endif

dbSelectArea("SF4")
SF4->(dbSetOrder(1))
If !dbSeek(xFilial("SF4")+cTES)
	_cLog := "TES: "+cTES+" - nใo localizada no cadastro."
	GERLOG(_cLog)
Endif

dbSelectArea("SE4")
dbSetOrder(1)
If !dbSeek(xFilial("SE4")+cCondpgto)
	_cLog := "Cond. Pagto.: "+cCondpgto+" - nใo localizada no cadastro."
	GERLOG(_cLog)
Endif

dbSelectArea("SA4")
dbSetOrder(1)
If !dbSeek(xFilial("SA4")+cTransp)
	_cLog := "Transportadora: "+cTransp+" - nใo localizada no cadastro."
	GERLOG(_cLog)
Endif


If cPoder3=="D" .and. (EMPTY(cCliOri) .or. EMPTY(cLojOri) .or. EMPTY(cArmOri))
	_cLog := "Para TES que controla Poder3 ้ necessario informar Cliente, Loja e Armazem de Origem."
	GERLOG(_cLog)
Endif

If cPoder3=="D"
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If !dbSeek(xFilial("SA1")+cCliOri+cLojOri)
		_cLog := "Cod Cliente Origem: "+cCliOri+" - "+cLojOri+" - nใo localizado no cadastro."
		GERLOG(_cLog)
	Endif
Endif

dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
	If Sele("TRB")<>0
		TRB->(DbCloseArea())
	Endif
	Return
Endif

AADD(_aBrowse,{"OK"		,,	""})
AADD(_aBrowse,{"PRODUTO"	,,	"Produto"})
AADD(_aBrowse,{"DESCRI"	,,	"Descri็ใo"})
AADD(_aBrowse,{"QTDEST"	,,	"Saldo em Estoque","@E 999,999,999.99"})
AADD(_aBrowse,{"QTDPLA"	,,	"Quantidade na Planilha","@E 99999999.99"})
AADD(_aBrowse,{"QTDSUG"	,,	"Quantidade Sugerida","@E 99999999.99"})
AADD(_aBrowse,{"PRCULT"	,,	"Pre็o ฺltima Compra"})

If Select("fMark") > 0
	fMark->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)

dbUseArea(.T.,__LocalDriver,_cArqEmp,"fMark")

If Len(aPlanilha) == 0
	Return
EndIf	

For nx:=1 to Len(aPlanilha)

	cControlaEnd := Posicione("SB1",1,xFilial("SB1")+AVKEY(aPlanilha[nx][1],'B1_COD'),"B1_LOCALIZ")
	
	nSaldoEst := 0
	
	If cControlaEnd == "S"
		
		If Select("SBF") == 0
			dbSelectArea("SBF")
		EndIf
		SBF->(dbGoTop()) 
		SBF->(dbSetOrder(7))
		If SBF->(dbSeek(xFilial("SBF")+AVKEY(aPlanilha[nx][1],'BF_PRODUTO')+AVKEY(cArmaz,'BF_LOCAL')))
		  While SBF->(!EOF()) .and. SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL == xFilial("SBF")+AVKEY(aPlanilha[nx][1],'BF_PRODUTO')+AVKEY(cArmaz,'BF_LOCAL')
		    If !(Alltrim(SBF->BF_LOCALIZ) $ cLclizOut) 
		      nSaldoEst += SBF->BF_QUANT//SaldoSBF(SBF->BF_LOCAL, SBF->BF_LOCALIZ, SBF->BF_PRODUTO, NIL, NIL, NIL, .F.) 
		    Endif
		    SBF->(dbSkip())
		  EndDo
		Endif		
	Else	
		If Select("SB2") == 0
			dbSelectArea("SB2")
		EndIf     
		SB2->(dbGoTop()) 
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2")+AVKEY(aPlanilha[nx][1],'B2_COD')+AVKEY(cArmaz,'B2_LOCAL')))
			nSaldoEst += SB2->B2_QATU//SaldoSb2()
		EndIf	
		
	EndIf	
	
	cQuery := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDNE FROM " + RetSqlName("SC6") + " WHERE D_E_L_E_T_ <> '*' AND " + CRLF
	cQuery += " C6_PRODUTO = '" + AVKEY(aPlanilha[nx][1],'C6_PRODUTO') + "' AND C6_QTDVEN - C6_QTDENT > 0 " + CRLF
	cQuery += " AND C6_FILIAL = '" + xFilial("SC6") + "' AND C6_LOCAL = '" + AVKEY(cArmaz,'C6_LOCAL') + "' " + CRLF 
	
	cQuery := ChangeQuery(cQuery) 
	If Select("TRBSAL") > 0;TRBSAL->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "TRBSAL", .t., .t.)
	TRBSAL->( dbGoTop() )
	If TRBSAL->(!Eof()) 
		nPedVen := TRBSAL->QTDNE
	EndIf
	
    nSaldoEst := nSaldoEst - nPedVen
	
	cProd := AVKEY(aPlanilha[nx][1],'B1_COD')
	cDesc := Posicione("SB1",1,xFilial("SB1")+AVKEY(aPlanilha[nx][1],'B1_COD'), "B1_DESC")
	nQtdPlan := Val(aPlanilha[nx][2]) 
	nQtdSug := Iif(nSaldoEst>=nQtdPlan,nQtdPlan,nSaldoEst)
	
	cQuery := " SELECT D1_VUNIT FROM " + RetSqlName("SD1") + " SD1 " + CRLF
	cQuery += " WHERE SD1.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM " + RetSqlName("SD1") + " WHERE " + CRLF 
	cQuery += " D1_FILIAL = '" + xFilial("SD1") + "' AND " + CRLF
	cQuery += " D1_COD = '" + cProd + "' AND " + CRLF 
	cQuery += " D_E_L_E_T_ <> '*') " + CRLF
	
	cQuery := ChangeQuery(cQuery) 
	If Select("TRBULT") > 0;TRBULT->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "TRBULT", .t., .t.)
	TRBULT->( dbGoTop() )
	If TRBULT->(!Eof()) 
		nUltPrc := TRBULT->D1_VUNIT
	EndIf	
		
	RecLock("fMARK",.T.)
	fMark->OK			:= Iif(nSaldoEst<=0,"",cMarca)	
	fMark->PRODUTO 		:= cProd
	fMark->DESCRI   	:= cDesc
	fMark->QTDEST	    := nSaldoEst
	fMark->QTDPLA	    := nQtdPlan
	fMark->QTDSUG	    := nQtdSug
	fMark->PRCULT	    := Transform(nUltPrc,"@E 999,999,999.99999")	
	fMark->CLIENTE 		:= cCliPv
	fMark->LOJA 		:= cLojPv
	fMark->TRANSP 		:= cTransp
	fMark->CONDPAG 		:= cCondpgto
	fMark->DIVNEG 		:= cDivNeg
	fMark->TES	 		:= cTES
	
	If cPoder3 == "D"
		fMark->CLIORI 	:= cCliOri
		fMark->LOJORI 	:= cLojOri
		fMark->ARMORI 	:= cArmOri
	Endif	
	fMark->ARMAZ    := cArmaz
	
	fMARK->(MSUNLOCK())

Next nx  

aCores := {}
aAdd(aCores,{"fMark->QTDEST > 0","BR_VERDE"	})
aAdd(aCores,{"fMark->QTDEST == 0","BR_VERMELHO"})

aButtons := {} 
AAdd(aButtons,{"Legenda"   ,{|| Legenda() },"Legenda","Legenda"} )

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlg TITLE "Gera็ใo de Pedido de Venda" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

oBrwTrb := MsSelect():New("fMARK","OK","",_aBrowse,@lInverte,@cMarca,{005,005,420,900},,,,,aCores)

oBrwTrb:oBrowse:lHasMark    := .t.
oBrwTrb:oBrowse:lCanAllMark := .t.
Eval(oBrwTrb:oBrowse:bGoTop)
oBrwTrb:oBrowse:bAllMark := { || MarcaIte(1) }
oBrwTrb:oBrowse:bLDblClick:={||MarcaIte(2)}

Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered VALID _lRetorno

fMark->(DbGotop())

If _nOpca == 1
	If ApMsgYesNo('Deseja gerar Pedido de Venda?','Pedido de Venda')
		MsAguarde({|| GERAPV()},OemtoAnsi("Processando Pedido de Venda..."))
	Endif
Endif

//fecha area de trabalho e arquivo temporแrio criados

If Select("fMARK") > 0	
	DbSelectArea("fMARK")	
	DbCloseArea()	
	Ferase(_cArqEmp+OrdBagExt())	
Endif

dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
Endif

If Sele("TRB")<>0
	TRB->(DbCloseArea())
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MarcaIte  ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Marcar Itens                                                ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MarcaIte(nOpc)

If nOpc == 1 // Marcar todos
	fMark->(DbGotop())
	Do While fMark->(!EOF())
		RecLock("fMark",.F.)
		If fMark->QTDEST > 0 
			fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
		EndIf
		fMark->(MsUnlock())
		fMark->(DbSkip())
	Enddo
	dbGoTop()
Elseif nOpc == 2  // Marcar somente o registro posicionado
	RecLock("fMark",.F.)
	If fMark->QTDEST > 0
		fMark->OK := Iif(fMark->OK==cMarca,"",cMarca) 
	EndIf
	MsUnLock()
Endif

oBrwTrb:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAPV    บAutor  ณVinicius Leonardo   บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera Pedidos de Venda e NF de Saida                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERAPV()

Local aAreaAtu  	:= GetArea()
Local aCabPV      	:=	{}
Local aItemPV     	:=	{}
Local aItem       	:=	{}
Local nOpc		    :=	3
Local nItPv	 		:= 	'00' 
Local cWMS			:= "" 

If ApMsgYesNo('Deseja gerar Servi็o?','Servi็o WMS')
	cWMS := "014"
Endif

dbSelectArea("fMark")
dbGotop()

If fMark->(!EOF())
	While fMark->(!EOF())
		
			If Len(aCabPv) == 0 .and. Len(aItem) == 0
				aCabPV := {;
				{"C5_TIPO"   ,IIF(nTipoPV==1,"N","B")	,Nil},;
				{"C5_CLIENTE",fMark->CLIENTE   			,Nil},;
				{"C5_LOJACLI",fMark->LOJA	  			,Nil},;
				{"C5_CONDPAG",fMark->CONDPAG   			,Nil},;
				{"C5_TRANSP" ,fMark->TRANSP    			,Nil},;
				{"C5_DIVNEG" ,fMark->DIVNEG    			,Nil},;
				{"C5_CLIENT",fMark->CLIENTE   			,Nil},;
				{"C5_LOJAENT",fMark->LOJA	  			,Nil}}
			Endif
			If !EMPTY(fMark->OK)
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+fMark->PRODUTO)
					If cPoder3 <> "D"					
						nValor  := 0 
						nUltPrc := val(StrTran(fMark->PRCULT,',','.'))
						If nUltPrc > 0
							nValor  := A410Arred(nUltPrc*fMark->QTDSUG,"C6_VALOR")
							nItPv	:= Soma1(nItPv,2)
							
							aItemPV:={;
							{"C6_ITEM"   	,	nItPv					,Nil},;
							{"C6_PRODUTO"	,	fMark->PRODUTO	   		,Nil},;
							{"C6_QTDVEN" 	,	fMark->QTDSUG			,Nil},;
							{"C6_QTDLIB"	,	fMark->QTDSUG			,Nil},;
							{"C6_PRCVEN" 	,	nUltPrc 	  			,Nil},;
							{"C6_VALOR"		,	nValor				    ,Nil},;
							{"C6_TES"		,	fMark->TES				,Nil},;
							{"C6_NFORI"		,	""						,Nil},;
							{"C6_SERIORI"	,	""						,Nil},;
							{"C6_ITEMORI"	,	""						,Nil},;
							{"C6_IDENTB6"	,	""						,Nil},;
							{"C6_LOCAL" 	,	fMark->ARMAZ			,Nil},;
							{"C6_LOCALIZ" 	,	""						,Nil},;
							{"C6_PRUNIT"	,	0						,Nil},; 
							{"C6_SERVIC"	,	cWMS					,Nil}}
							aADD(aItem,aItempv)
							
							If len(aItem) == 999
								If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
									lMsErroAuto := .F.
									MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
									If lMsErroAuto
										MostraErro()
										//GERPVMAN(aCabPv,aItem) 
									Else 
										If RecLock('SC5',.F.)
											SC5->C5_MENNOTA := "Pedido - "+SC5->C5_NUM
											MsUnLock('SC5')
											MsgAlert("Pedido gerado - "+SC5->C5_NUM)
										EndIf
									Endif
									aCabPV      	:=	{}
									aItemPV     	:=	{}
									aItem       	:=	{}
									nItPv	 	    := 	'00'
								Endif
							Endif
						Else
							_cLog := "Custo do Produto: "+fMark->PRODUTO+" - nใo localizado no sistema."
							GERLOG(_cLog)
						Endif
					Else
						nSaldo := fMark->QTDEST
						DbSelectArea("SB6")
						SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
						
						_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
						_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
						_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
						_cQrySB6 += "        B6_PRODUTO = '"+fMark->PRODUTO+"' AND "
						_cQrySB6 += "        B6_CLIFOR  = '"+fMark->CLIORI+"' AND "
						_cQrySB6 += "        B6_LOJA    = '"+fMark->LOJORI+"' AND "
						_cQrySB6 += "		 B6_LOCAL ='"+fMark->ARMORI+"' AND "
						_cQrySB6 += "        B6_SALDO > 0 AND "
						_cQrySB6 += "		 B6.D_E_L_E_T_ = '' "
						_cQrySB6 += " ORDER BY B6_IDENT "
						
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
						
						TSQLSB6->(DBGoTop())
						
						While TSQLSB6->(!EOF()) .and. nSaldo > 0
							nSalP3  := SalDisP3(TSQLSB6->B6_IDENT, TSQLSB6->B6_SALDO)
							nQtRet3 := iif(nSalP3 >= nSaldo, nSaldo, nSalP3)
							
							IF nQtRet3 > 0
								nQtRet3 :=Iif(nQtRet3>=nQtdPlan,nQtdPlan,nQtRet3)							
								nItPv	:= Soma1(nItPv,2)
								nSaldo  := nSaldo - nQtRet3
								nPreco  := A410Arred(TSQLSB6->B6_PRUNIT,"C6_VALOR")
								nValor  := A410Arred(TSQLSB6->B6_PRUNIT * nQtRet3,"C6_VALOR")
								
								dbSelectArea("SB1")
								dbSetOrder(1)
								dbSeek(xFilial("SB1")+TSQLSB6->B6_PRODUTO)
								
								aItemPV:={;
								{"C6_ITEM"   	,	nItPv					,Nil},;
								{"C6_PRODUTO"	,	fMark->PRODUTO			,Nil},;
								{"C6_QTDVEN" 	,	nQtRet3					,Nil},;
								{"C6_QTDLIB"	,	nQtRet3 				,Nil},;
								{"C6_PRCVEN" 	,	nPreco					,Nil},;
								{"C6_VALOR"		,	nValor				    ,Nil},;
								{"C6_TES"		,	fMark->TES				,Nil},;
								{"C6_NFORI"		,	TSQLSB6->B6_DOC			,Nil},;
								{"C6_SERIORI"	,	TSQLSB6->B6_SERIE		,Nil},;
								{"C6_ITEMORI"	,	""						,Nil},;
								{"C6_IDENTB6"	,	TSQLSB6->B6_IDENT		,Nil},;
								{"C6_LOCAL" 	,	fMark->ARMAZ			,Nil},;
								{"C6_LOCALIZ" 	,	""						,Nil},;
								{"C6_PRUNIT"	,	0						,Nil}}
								aADD(aItem,aItempv)
								
								If len(aItem) == 999
									If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
										lMsErroAuto := .F.
										MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
										If lMsErroAuto
											MostraErro()
											//GERPVMAN(aCabPv,aItem)
										Else
											If RecLock('SC5',.F.)
												SC5->C5_MENNOTA := "Pedido - "+SC5->C5_NUM
												MsUnLock('SC5')
												MsgAlert("Pedido gerado - "+SC5->C5_NUM)
											EndIf
										Endif
										aCabPV      	:=	{}
										aItemPV     	:=	{}
										aItem       	:=	{}
										nItPv	 	    := 	'00'
									Endif
								Endif
								
							Endif
							TSQLSB6->(dbSkip())
						Enddo
						
						If nSaldo > 0
							_cLog := "Produto: "+fMark->PRODUTO+" - nใo possui a quantidade "+Alltrim(str(nSaldo))+" na tabela de terceiro."
							GERLOG(_cLog)
						Endif
						If Select("TSQLSB6") > 0
							dbSelectArea("TSQLSB6")
							DbCloseArea()
						EndIf
					Endif
				Else
					_cLog := "Produto: "+fMark->PRODUTO+" - nใo localizado no cadastro."
					GERLOG(_cLog)
				Endif
			Endif
			dbSelectArea("fMark")
			dbSkip()
		
	EndDo
	If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
		
		If lMsErroAuto
			MostraErro()
			//GERPVMAN(aCabPv,aItem)
		Else   
			If RecLock('SC5',.F.)
				SC5->C5_MENNOTA := "Pedido - "+SC5->C5_NUM
				MsUnLock('SC5')
				MsgAlert("Pedido gerado - "+SC5->C5_NUM)
			EndIf
		Endif
	Endif
	
Endif

RestArea(aAreaAtu)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERLOG    บAutor  ณLuciano Siqueira    บ Data ณ  03/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava log das inconsistencias encontradas                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SUNNY                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERLOG(_cLog)

dbSelectArea("TRB")
If !dbSeek(_cLog)
	RecLock("TRB",.T.)
	TRB->LOG := _cLog
	MsUnlock()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalDisP3  บAutor  ณMicrosiga           บ Data ณ  09/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para calcular saldo disponivel de Terceiros.        บฑฑ
ฑฑบ          ณ Desconta PV abertos do SB6->B6_SALDO                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function SalDisP3(_cIdent, _nSalSB6)

local _aAreaSC6  := SC6->(GetArea())
local _nSalDisP3 := _nQtPV3:= 0
Local _cqry      := ""

SC6->(dbSetOrder(12))

If Select("Qrysc6") > 0
	Qrysc6->(dbCloseArea())
Endif

_cqry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDSC6 "
_cqry += " FROM "+RETSQLNAME("SC6")+" (NOLOCK) WHERE C6_FILIAL='"+xFILIAL("SC6")+"' AND C6_IDENTB6='"+_cIdent+"' AND D_E_L_E_T_='' AND (C6_QTDVEN-C6_QTDENT) > 0 "

TCQUERY _cqry ALIAS "Qrysc6" NEW

dbSelectArea("Qrysc6")

If Select("Qrysc6") > 0
	_nQtPV3 :=Qrysc6->QTDSC6
Endif

_nSalDisP3 := _nSalSB6 - _nQtPV3

restarea(_aAreaSC6)

return(_nSalDisP3)


Static Function GERPVMAN(aCabPv,aItem)

Local aAreaAtu	:= GetArea()
Local cNrPV		:= GetSxeNum('SC5','C5_NUM')

If nTipoPv == 1
	dbSelectArea("SA1")
	dbSetOrder(1)
	SA1->(DBSeek(xFilial('SA1')+aCabPv[2,2]+aCabPv[3,2]))

	_cCFIni := "0"
	If Subs(SA1->A1_EST,1,2) == "EX"
		_cCFIni := "7"
	ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
		_cCFIni := "6"
	Else
		_cCFIni := "5"
	EndIf
Else 
	dbSelectArea("SA2")
	dbSetOrder(1)
	SA2->(DBSeek(xFilial('SA2')+aCabPv[2,2]+aCabPv[3,2]))
	
	_cCFIni := "0"
	If Subs(SA2->A2_EST,1,2) == "EX"
		_cCFIni := "7"
	ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA2->A2_EST)
		_cCFIni := "6"
	Else
		_cCFIni := "5"
	EndIf

Endif

dbSelectArea("SC5")
RecLock('SC5',.T.)
SC5->C5_FILIAL  := xFilial('SC5')
SC5->C5_NUM     := cNrPV
SC5->C5_TIPO    := aCabPv[1,2]
SC5->C5_CLIENTE := aCabPv[2,2]
SC5->C5_LOJACLI := aCabPv[3,2]
SC5->C5_CLIENT  := aCabPv[2,2]
SC5->C5_LOJAENT := aCabPv[3,2]
SC5->C5_TIPOCLI := 'F'   //Consumidor Final
SC5->C5_CONDPAG := aCabPv[4,2]
SC5->C5_TRANSP  := aCabPv[5,2]
SC5->C5_DIVNEG  := aCabPv[6,2]
SC5->C5_EMISSAO := dDatabase
SC5->C5_MOEDA   := 1
SC5->C5_TIPLIB  := '1'   //Liberacao por Pedido
SC5->C5_TPCARGA := '2'
SC5->C5_TXMOEDA := 1
SC5->C5_LIBEROK := "S"
MsUnLock('SC5')
ConfirmSX8()

for nX := 1 to len(aItem)
	SB1->(DBSeek(xFilial('SB1')+aItem[nX,2,2]))
	SF4->(DBSeek(xFilial('SF4')+aItem[nX,7,2])) 
	dbSelectArea("SC6")
	RecLock('SC6',.T.)
	SC6->C6_FILIAL := xFilial('SC6')
	SC6->C6_NUM    := cNrPV
	SC6->C6_ITEM   := aItem[nX,1,2]
	SC6->C6_PRODUTO:= aItem[nX,2,2]
	SC6->C6_UM     := SB1->B1_UM
	SC6->C6_QTDVEN := aItem[nX,3,2]
	SC6->C6_QTDLIB := aItem[nX,4,2]
	SC6->C6_PRCVEN := aItem[nX,5,2]
	SC6->C6_VALOR  := aItem[nX,6,2]
	SC6->C6_TES    := aItem[nX,7,2]
	SC6->C6_LOCAL  := aItem[nX,12,2]
	SC6->C6_LOCALIZ:= aItem[nX,13,2]
	SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
	SC6->C6_ENTREG := dDataBase
	SC6->C6_DESCRI := SB1->B1_DESC
	SC6->C6_PRUNIT := 0.00
	SC6->C6_NFORI  := aItem[nX,8,2]
	SC6->C6_SERIORI:= aItem[nX,9,2]
	SC6->C6_ITEMORI:= aItem[nX,10,2]
	SC6->C6_TPOP   := 'F' //FIRME
	SC6->C6_CLI    := aCabPv[2,2]
	SC6->C6_LOJA   := aCabPv[3,2]
	SC6->C6_IDENTB6:= aItem[nX,11,2]
	MsUnLock('SC6')
	
	MaLibDoFat(SC6->(RECNO()),aItem[nX,4,2],@.T.,@.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,aItem[nX,4,2])
next nX

MsgAlert("Pedido gerado - "+cNrPV)

RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPEXC    บAutor  ณLuciano Siqueira    บ Data ณ  12/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime Log das Inconsistencias encontradas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPEXC()

Local oReport

Private _cQuebra := " "

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return


Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")


oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"TRB"})

TRCell():New(oSection1,"LOG","TRB","LOG","@!",90)


Return oReport


// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)


// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG  บAutor  ณDelta Decisao      บ Data ณ  21/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG(cPerg)
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

	SX1->(dbSetOrder(1))
	If SX1->(!dbSeek(cPerg)) 
	
		AAdd(aHelpPor,"Armazem a ser considerado ")        	
		PutSx1(	cPerg		,"01"		,"Armazem ?"					,"Armazem ?"					,"Armazem ?"					,"mv_ch1"	,"C"   		,02	,0,0,"G",""			,"" 		,""			,""			,"MV_PAR01"		,""			,""					,""				,""	,""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
			 								
		aHelpPor :={}
		AAdd(aHelpPor,"Endere็o(s) a ser(em) desconsiderado(s).")
		PutSx1(cPerg		,"02"		,"Desconsidera Endere็o(s) ?"	,"Desconsidera Endere็o(s) ?"	,"Desconsidera Endere็o(s) ?"	,"mv_ch2"	,"C"		,40	,0,0,"G",""			,""			,""	   		,""			,"MV_PAR02"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Tipo Pedido Normal ou Utiliza Fornecedor")
		PutSx1(cPerg,"03","Tipo Pedido ?"				,"Tipo Pedido ?"				,"Tipo Pedido ?"								,"mv_ch3"	,"N"		,01	,0,0,"C",""			,""			,""			,""			,"MV_PAR03"		,"Normal"	,""					,""				,"","Utiliza Fornecedor","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Cliente/Fornecedor ")
		PutSx1(cPerg,"04","Cliente/Fornecedor ?"		,"Cliente/Fornecedor ?"			,"Cliente/Fornecedor ?"							,"mv_ch4"	,"C"		,06	,0,0,"G",""			,""			,""			,""			,"MV_PAR04"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Loja do Pedido de Venda")
		PutSx1(cPerg,"05","Loja PV ?"					,"Loja PV ?"					,"Loja PV ?"									,"mv_ch5"	,"C"		,02	,0,0,"G",""			,""			,""			,""			,"MV_PAR05"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Transportadora")
		PutSx1(cPerg,"06","Transp. ?"					,"Transp. ?"					,"Transp. ?"									,"mv_ch6"	,"C"		,06	,0,0,"G",""			,"SA4"		,""			,""			,"MV_PAR06"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Condi็ใo Pagto.")
		PutSx1(cPerg,"07","Cond. Pagto. ?"				,"Cond. Pagto. ?"				,"Cond. Pagto. ?"								,"mv_ch7"	,"C"		,03	,0,0,"G",""			,"SE4"		,""	   		,""			,"MV_PAR07"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Divisao Negocio")
		PutSx1(cPerg,"08","Div. Neg. ?"					,"Div. Neg. ?"					,"Div. Neg. ?"									,"mv_ch8"	,"C"		,02	,0,0,"G",""			,"ZM"		,""	   		,""			,"MV_PAR08"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"TES")
		PutSx1(cPerg,"09","TES ?"						,"TES ?"						,"TES ?"										,"mv_ch9"	,"C"		,03	,0,0,"G",""			,"SF4"		,""			,""			,"MV_PAR09"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Cliente Origem Poder Terceiro ")
		PutSx1(cPerg,"10","Cli Origem ?"				,"Cli Origem ?"					,"Cli Origem ?"									,"mv_cha"	,"C"		,06	,0,0,"G",""			,"SA1"		,""			,""			,"MV_PAR10"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Loja Cli Origem Poder Terceiro")
		PutSx1(cPerg,"11","Lj Origem ?"					,"Lj Origem ?"					,"Lj Origem ?"									,"mv_chb"	,"C"		,02	,0,0,"G",""			,""			,""			,""			,"MV_PAR11"		,""			,""					,""				,"",""					,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
		
		aHelpPor :={}
		AAdd(aHelpPor,"Armazem Origem Poder Terceiro")
		PutSx1(cPerg,"12","Armaz Origem?"				,"Armaz Origem?"				,"Armaz Origem?"								,"mv_chc"	,"C"		,02	,0,0,"G",""			,""			,""			,""			,"MV_PAR12"		,"Sim"		,""					,""				,"","Nใo"				,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"")
	EndIf		
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLerCSV	    บAutor  ณDelta Decisao      บ Data ณ  09/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a leitura da planilha excel com os itens a serem       บฑฑ
ฑฑบ          ณ inseridos no pedido de venda.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LerCSV()

Local cLinha	:= ""
Local lPrim	:= .T.
Local aCampos	:= {}
Local lRet := .T.
Local cType 	:= "Arquivo CSV (*.CSV) |*.csv|"
Local cArq		:= cGetFile(cType,OemToAnsi("Selecione o arquivo a ser importado"),0,,.F.,GETF_LOCALHARD,.F.,.F.)
 
Private aErro := {}
 
If !File(cArq)
	MsgStop("O arquivo " + cArq + " nใo foi encontrado. A rotina serแ abortada!","ATENCAO")
	lRet := .F.
EndIf

If lRet  
	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
	 
		IncProc("Lendo arquivo excel...")
	 
		cLinha := FT_FREADLN()
	 
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aPlanilha,Separa(cLinha,";",.T.))
		EndIf
	 
		FT_FSKIP()
	EndDo 
	
	FT_FUSE()
EndIf	

If Empty(aPlanilha)
	MsgStop("Arquivo " + cArq + " vazio. A rotina serแ abortada!","ATENCAO")
	lRet := .F.
EndIf

Return lRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda    บAutor  ณDelta Decisao      บ Data ณ  09/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra a legenda 									      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Legenda()
Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"	, "Apto a gerar Pedido"			})
AADD(aLegenda,{"BR_VERMELHO", "Inapto a gerar Pedido"		})

BrwLegenda("Situa็ใo de item","Situa็ใo de item",aLegenda)
	
Return
