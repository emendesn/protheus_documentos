#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQEXPLT บAutor  ณ D.FERNANDES        บ Data ณ  24/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para imprimir etiquetas de Armazenagem apos       บฑฑ
ฑฑบ          ณ ter confirmado a NFE.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ETQEXPLT()

Local cParam1 := Space(9)
Local cParam2 := Space(3)
Local cParam3 := Space(15)
Local cParam4 := Replicate("Z",15)
Local cParam5 := 1

Private aPergs := {}
Private aRet   := {}
			
aPergs := {}
aRet   := {}

aAdd( aPergs ,{1,"Nota Fiscal",cParam1,"@!",".T.","SF2",".T.",40,.T.})
aAdd( aPergs ,{1,"Serie",cParam2,"@!",".T.","",".T.",20,.T.})
aAdd( aPergs ,{1,"Produto de",cParam3,"@!",".T.","SB1",".T.",60,.F.})
aAdd( aPergs ,{1,"Produto ate",cParam4,"@!",".T.","SB1",".T.",60,.F.})
//aAdd( aPergs ,{1,"Qtd de Etiquetas",cParam5,"@!",".T.","",".T.",20,.F.})
	
If ParamBox(aPergs ,"Parametros ",aRet)
	Processa( {|lEnd| ETQREXP(@lEnd)}, "Aguarde...","Gerando os dados para impressใo das etiquetas ...", .T. )
EndIf
			
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQREXP  บAutor  ณ D.FERNANDES 		 บ Data ณ  16/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ETQREXP(lEnd)

Local _cdoc     := aRet[1]
Local _cserie   := aRet[2]
Local _cProdDe  := aRet[3]
Local _cProdAte := aRet[4]
Local nCont     := 0
Local aItens    := {}

Private nQtdEti := 1//IIF(aRet[5]<=0,1,aRet[5])

dbSelectArea("SF2")
SF2->(dbSetOrder(1))

If SF2->(DbSeek(xfilial("SF2") + _cdoc + _cserie ))
	
	_cQryD1 := " SELECT D2_COD, "  
	_cQryD1 += "		D2_CLIENTE, "
	_cQryD1 += "		D2_LOJA, "
	_cQryD1 += "		D2_DOC, "
	_cQryD1 += "		D2_SERIE, "
	_cQryD1 += "		D2_PEDIDO, "
	_cQryD1 += "		D2_LOCAL, "
	_cQryD1 += "		D2_EMISSAO, "
	_cQryD1 += "		D2_LOTECTL, "
	_cQryD1 += " 		D2_QUANT "
	_cQryD1 += " FROM   "+RetSqlName("SD2")+" AS D2 (nolock) "
	_cQryD1 += " WHERE  D2_FILIAL   = '"+xFilial("SD2")+"' AND "
	_cQryD1 += "        D2_DOC      = '"+_cdoc+"' AND "
	_cQryD1 += "        D2_SERIE    = '"+_cserie+"' AND "
	_cQryD1 += " 		D2_COD BETWEEN '"+_cProdDe+"' AND '"+_cProdAte+"' AND "	
	_cQryD1 += "        D2.D_E_L_E_T_  = '' "
	_cQryD1 += " ORDER BY D2_COD,D2_DOC,D2_SERIE,D2_LOCAL,D2_EMISSAO,D2_LOTECTL "
	
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
		
		dbSelectArea("SA1")		
		dbSetOrder(1)
		MsSeek( xFilial("SA1")+TSQL->(D2_CLIENTE+D2_LOJA) )
		
		AADD(aItens,{TSQL->D2_COD,;
		TSQL->D2_DOC,;
		TSQL->D2_SERIE,;
		TSQL->D2_QUANT,;
		STOD(TSQL->D2_EMISSAO),;
		TSQL->D2_LOTECTL,;
		TSQL->D2_PEDIDO,;
		SA1->A1_END,;
		SA1->A1_EST,;
		SA1->A1_MUN})
		
		TSQL->(dbskip())
	Enddo
	
	If Len(aItens) > 0
		IMPETQ(aItens)
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
Static Function IMPETQ(aItens)

Local nX
Local cfont := "0"
Local _afont 
Local _aLin := {41,35,32,28,24,20,16,05,01}//{42,32,28,24,20,16,5,01}
Local _aCol := {03,35,43,68}  //05,30
Local _nLargBar
Local _impress := ""                   

For nX := 1 to Len(aItens)
					
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek(xFilial("SB1")+aItens[nX][1])
	
		For nY := 1 To nQtdEti
	
			MSCBPRINTER("OS 214","LPT1",,110,.F.,,,,,,.T.)  //esta linha esta funcionando a impressora ARGOX
			MSCBChkStatus(.F.)
	    	MSCBBEGIN(1,4)
			
			//Trata variavel do endereco		      
			cEnder := Alltrim(aItens[nX][8])+"-"+Alltrim(aItens[nX][10]) +" - "+ aItens[nX][09]				
			
			MSCBSAY(3,34,"PEDIDO:  " + aItens[nX][7],"N","4","01,01")
			MSCBSAY(3,26,"NF.....: " + aItens[nX][2]+"/"+aItens[nX][3],"N","2","01,01")
			MSCBSAY(3,22,"PRODUTO: " + SB1->B1_COD + "-"+ Substr(SB1->B1_DESC,1,35),"N","2","01,01")
			MSCBSAY(3,18,"QTD....: " + Transform(aItens[nX][4],"@E 999,999.99"),"N","2","01,01")		
			MSCBSAY(3,14,"LOTE...: " + aItens[nX][6],"N","2","01,01")
			MSCBSAY(3,08,"DESTINO: " + cEnder,"N","2","01,01")
																		
			MSCBEND()                                                                          
			MSCBCLOSEPRINTER()
		Next nY			
		
	EndIf
      							
Next nX

Return