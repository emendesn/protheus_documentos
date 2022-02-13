#include "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MA265TDOK³ Autor ³ Luciano Siqueira      ³ Data ³ 16/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ P.E para validar a existencia dos numeros de serie          ±±
±± da operação WS na Base Instalada                                        ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Zatix                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

User Function MA265TDOK()

Local aArea		:= GetArea()
Local _lRet		:= .T.
Local _cCodCli  := "191826"
Local _cLojCli  := "01"
Local _cCodFor  := SDA->DA_CLIFOR
Local _cLojFor  := SDA->DA_LOJA
Local _cDoc     := SDA->DA_DOC
Local _cSerie   := SDA->DA_SERIE
Local _cProduto := SDA->DA_PRODUTO
Local _nQtdOri  := SDA->DA_QTDORI

Local _cContSe	:= ""
Local _nQtD1   	:= 0


u_GerA0003(ProcName())

_cContSe := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_XCONTSE")
If _cContSe == "S"
	_nQtD1 += _nQtdOri
	If _nQtD1 > 0
		_cQryAA3 := " SELECT "
		_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
		_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
		_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
		_cQryAA3 += " AND AA3_XNFENT='"+_cDoc+"' "
		_cQryAA3 += " AND AA3_XSEREN='"+_cSerie+"' "
		_cQryAA3 += " AND AA3_CODCLI='"+_cCodCli+"' "
		_cQryAA3 += " AND AA3_LOJA='"+_cLojCli+"' "
		_cQryAA3 += " AND AA3_FORNEC='"+_cCodFor+"' "
		_cQryAA3 += " AND AA3_LOJA='"+_cLojFor+"' "
		_cQryAA3 += " AND AA3_CODPRO='"+_cProduto+"' "
		_cQryAA3 += " AND AA3_XCLASS<>'S' "
		_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
		_cQryAA3 += " AND B1_COD=AA3_CODPRO "
		_cQryAA3 += " AND B1_XCONTSE='S' "
		
		_cQryAA3 := ChangeQuery(_cQryAA3)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
		
		_nQtAA3 := 0
		
		QRY1->(dbGoTop())
		Do While QRY1->(!Eof())
			_nQtAA3++
			dbSelectArea("QRY1")
			DbSkip()
		Enddo
		
		If _nQtAA3 < _nQtD1
			MsgStop("Favor gerar Base Instalada antes de endereçar!!!", "Base Instalada.")
			_lRet := .f.
		Else
			QRY1->(dbGoTop())
			Do While QRY1->(!Eof())
				dbSelectArea("AA3")
				dbSetOrder(1)
				If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
					Reclock("AA3",.F.)
					AA3->AA3_XCLASS := "S"
					MsUnLock()
				Endif
				dbSelectArea("QRY1")
				DbSkip()
			Enddo
		Endif
		QRY1->(dbCloseArea())
	Endif
Endif

RestArea(aArea)

Return _lRet