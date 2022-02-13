#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQAMZLT บAutor  ณ D.FERNANDES        บ Data ณ  24/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para imprimir etiquetas de Armazenagem apos       บฑฑ
ฑฑบ          ณ ter confirmado a NFE.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ETQAMZLT()

Local cParam1 := Space(9)
Local cParam2 := Space(3)
Local cParam3 := Space(6)
Local cParam4 := Space(2)
Local cParam5 := Space(15)
Local cParam6 := Space(15)
Local cParam7 := "0001"
Local cParam8 := "0000"
Local cParam9 := Space(10)
Local cParam10 := Space(10)

Private aPergs := {}
Private aRet   := {}
			
aPergs := {}
aRet   := {}

aAdd( aPergs ,{1,"Nota Fiscal",cParam1,"@!",".T.","",".T.",40,.T.})
aAdd( aPergs ,{1,"Serie",cParam2,"@!",".T.","",".T.",20,.F.})
aAdd( aPergs ,{1,"Fornecedor",cParam3,"@!",".T.","SA2",".T.",30,.T.})
aAdd( aPergs ,{1,"Loja",cParam4,"@!",".T.","",".T.",20,.T.})
aAdd( aPergs ,{1,"Produto de",cParam5,"@!",".T.","SB1",".T.",60,.F.})
aAdd( aPergs ,{1,"Produto ate",cParam6,"@!",".T.","SB1",".T.",60,.F.})
aAdd( aPergs ,{1,"Qtd Etiqueta",cParam7,"@99",".T.","",".T.",20,.F.})
aAdd( aPergs ,{1,"Qtd Pacote",cParam8,"@99",".T.","",".T.",20,.F.})   
aAdd( aPergs ,{1,"Lote de",cParam9,"@!",".T.","",".T.",60,.F.})
aAdd( aPergs ,{1,"Lote ate",cParam10,"@!",".T.","",".T.",60,.F.})
	
If ParamBox(aPergs ,"Parametros ",aRet)
	Processa( {|lEnd| ETQRARMZ(@lEnd)}, "Aguarde...","Gerando os dados para impressใo das etiquetas ...", .T. )
EndIf
			
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQRARMZ บAutor  ณ M.Munhoz - ERP PLUSบ Data ณ  16/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ETQRARMZ(lEnd)

Local _cdoc     := aRet[1]
Local _cserie   := aRet[2]
Local _cfornec  := aRet[3]
Local _cloja    := aRet[4]
Local _cProdDe  := aRet[5]
Local _cProdAte := aRet[6]
Local _nQtdEtq	:= Val(aRet[7])
Local _nQtdPac	:= Val(aRet[8])
Local _cLoteDe  := aRet[9]
Local _cLoteAte := aRet[10]
Local nCont     := 0
Local aItens    := {}

If _nQtdEtq <= 0
	_nQtdEtq := 1
EndIf 

dbSelectArea("SF1")
SF1->(dbSetOrder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO

If SF1->(DbSeek(xfilial("SF1") + _cdoc + _cserie + _cfornec + _cloja ))
	
	_cQryD1 := " SELECT D1_COD, "
	_cQryD1 += "		D1_DOC, "
	_cQryD1 += "		D1_SERIE, "
	_cQryD1 += "		D1_LOCAL, "
	_cQryD1 += "		D1_DTDIGIT, "
	_cQryD1 += "		D1_LOTECTL, "
	_cQryD1 += " 		D1_QUANT "
	_cQryD1 += " FROM   "+RetSqlName("SD1")+" AS D1 (nolock) "
	_cQryD1 += " WHERE  D1_FILIAL   = '"+xFilial("SD1")+"' AND "
	_cQryD1 += "        D1_DOC      = '"+_cdoc+"' AND "
	_cQryD1 += "        D1_SERIE    = '"+_cserie+"' AND "
	_cQryD1 += "        D1_FORNECE  = '"+_cfornec+"' AND "
	_cQryD1 += "        D1_LOJA     = '"+_cloja+"' AND "
	_cQryD1 += "        D1_COD BETWEEN '"+_cProdDe+"' AND '"+_cProdAte+"' AND  "	
	_cQryD1 += "        D1_LOTECTL BETWEEN '"+_cLoteDe+"' AND '"+_cLoteAte+"' AND  "	
	_cQryD1 += "        D1.D_E_L_E_T_  = '' "
	_cQryD1 += " ORDER BY D1_COD,D1_DOC,D1_SERIE,D1_LOCAL,D1_DTDIGIT,D1_LOTECTL "
	
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryD1),"TSQL",.T.,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณContagem de registros para a Reguaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("TSQL")
	TSQL->(dbGoTop())
	TSQL->( dbEval( {|| nCont++ } ) )
	
	TSQL->(dbGoTop())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicializa a regua de evolucao	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProcRegua(nCont)

	While TSQL->(!Eof())
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiona no cadastro de ณ
		//ณproduto x fornecedor   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cProdFor := ""
		dbSelectArea("SA5")
		dbSetOrder(1)
		If dbSeek(xFilial("SA5")+_cfornec+_cLoja+TSQL->D1_COD)
			cProdFor := SA5->A5_CODPRF
		Endif
		
		If _nQtdPac > 0
			_nQtdPac := _nQtdPac
		Else
			_nQtdPac := TSQL->D1_QUANT			
		EndIf
		
		AADD(aItens,{TSQL->D1_COD,;
		TSQL->D1_DOC,;
		TSQL->D1_SERIE,;
		TSQL->D1_LOCAL,;
		STOD(TSQL->D1_DTDIGIT),;
		TSQL->D1_LOTECTL,;
		cProdFor,;
		_nQtdPac})
		
		TSQL->(dbskip())
	Enddo
	
	If Len(aItens) > 0
		IMPETQ(aItens, _nQtdEtq)
	EndIf
	
Else
	ApMsgInfo("Nota Fiscal de Entrada nao Encontrada.","NFE nใo localizada!")
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPETQ    บAutor  ณD.FERNANDES         บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar a impressao das etiquetas             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPETQ(aItens, _nQtdEtq)

Local nX
Local cfont := "0"
Local _afont 
Local _aLin := {04,09,18,20}
Local _aCol := {03,30,45,65}  //05,30
Local _nLargBar
Local _impress := ""                   

_afont :={"050,050","040,040"}
_nLargBar := 3     
_impress := "Z90XI"   // impressora de 300 dpi

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 88 mm -----------------------ฟ ณ
//ณ |  PARTNUMBER - DESCR. PARTNUMBER             | ณ
//ณ |  |||||||||||||||||||||||||||||||||||||||||| | |
//ณ |  LOTE 00000   COD.FOR:      DT_ENTR00/00/00 ณ ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aItens)

	// Alimenta variaveis
	_codprod  := aItens[nX, 1]
	_cNFNum   := aItens[nX, 2]
	_cNFSer   := aItens[nX, 3]
	_carmaz   := aItens[nX, 4]
	_cDtEntr  := aItens[nX, 5]
	_clote    := aItens[nX, 6]
	_cProdFor := aItens[nX, 7]
	
	If _nQtdEtq == 1
		_nQuant := aItens[nX, 8]
	Else       
		_nQuant := 1
	EndIf		

	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek(xFilial("SB1")+_codprod)
	
		For nEtq := 1 To _nQtdEtq

			MSCBPRINTER(_impress,"LPT1",,033,.F.,,,,,,.T.)
			
			MSCBBEGIN(1,6)
			MSCBSAY(_aCol[1],_aLin[1],_codprod+left(SB1->B1_DESC,40-len(_codprod)) ,"N",cfont,_afont[1])  // Coluna 1 - Linha 1
		    MSCBSAYBAR(_aCol[2],_aLin[2],_codprod			 			,"N","MB07",7.5,.F.,.F.,.F.,,_nLargBar,1)
	
		    MSCBSAY(_aCol[1],_aLin[3]-09,"QTD: "+Transform(_nQuant,"@ 999,999.99") 		,"N",cfont,_afont[2])
		    	    	    
		    //Campo lote
		    MSCBSAY(_aCol[1],_aLin[3]-5,"Lote: "+Alltrim(_clote)		,"N",cfont,_afont[2])
		    MSCBSAYBAR(_aCol[1],_aLin[4]-2,Alltrim(_clote) 		,"N","MB07",5,.F.,.F.,.F.,,2)      	 
		    
		    MSCBSAY(_aCol[2],_aLin[3],"Cod.For: "+_cProdFor       		,"N",cfont,_afont[2])  
		    MSCBSAY(_aCol[4],_aLin[3],"Dt: "+Dtoc(_cDtEntr)   		,"N",cfont,_afont[2])  
		    
			MSCBEND()                                                                          
			
			MSCBCLOSEPRINTER()			
			
		Next nEtq		
	
	EndIf
      							
Next nX

Return