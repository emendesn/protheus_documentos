#include "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M265ESTOK� Autor � Luciano Siqueira      � Data � 16/01/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � P.E para validar a existencia dos numeros de serie          ��
�� da opera��o WS na Base Instalada                                        ��
�������������������������������������������������������������������������Ĵ��
���Uso       � Zatix                                                      ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
/*/

User Function M265ESTOK()

Local aArea		:= GetArea()
Local _lRet		:= .T.
local _nPosEst  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "DB_ESTORNO" })
Local _cCodCli  := "191826"
Local _cLojCli  := "01"
Local _cCodFor  := SDA->DA_CLIFOR
Local _cLojFor  := SDA->DA_LOJA
Local _cDoc     := SDA->DA_DOC
Local _cSerie   := SDA->DA_SERIE
Local _cProduto := SDA->DA_PRODUTO
Local _nQtdOri  := SDA->DA_QTDORI
Local _cContSe	:= ""
Local _lEstorno := .T.

u_GerA0003(ProcName())

For i:=1 to Len(aCols)
	If Empty(Alltrim(aCols[i,_nPosEst]))
		_lEstorno := .F.
		Exit
	Endif
Next i 

_cContSe := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_XCONTSE")
If _cContSe == "S" .and. _lEstorno
	
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
	_cQryAA3 += " AND AA3_XCLASS='S' "
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
	
	If _nQtAA3 <> _nQtdOri 
		MSGSTOP("Aten��o, N�o � possivel estornar o endere�amento pois a quantidade de numero de serie n�o confere com a quantidade endere�ada.")
		_lRet := .F.		
	Else
		QRY1->(dbGoTop())
		Do While QRY1->(!Eof())
			dbSelectArea("AA3")
			dbSetOrder(1)
			If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
				Reclock("AA3",.F.)
				AA3->AA3_XCLASS := "N"
				MsUnLock()
			Endif
			dbSelectArea("QRY1")
			DbSkip()
		Enddo
	Endif
	QRY1->(dbCloseArea())
	
Endif

RestArea(aArea)

Return _lRet
