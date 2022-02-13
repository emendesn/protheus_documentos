#INCLUDE 'RWMAKE.CH'
#INCLUDE 'APVT100.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSER02  บAutor  ณ Luciano Siqueira   บ Data ณ  09/04/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incluir dados da nota de saida na rotina base instalada    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ															  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BNUSER02()

Private _cPedido  := Space(09)
Private _cSerie	  := Space(03)
Private _cCliente := Space(06)
Private _cLojaCli := Space(02)
Private _cNumSer  := Space(20)
Private _cProduto := Space(15)
Private _lRet     := .F.
Private _nQtdSC6  := 0
Private _nQtdAA3  := 0


u_GerA0003(ProcName())

DLVTCabec("Bx.Base Instalada",.F.,.F.,.T.)
@ 00, 00 VTSay PadR('Pedido Numero' , VTMaxCol())
@ 01, 00 VTGet _cPedido  	 Pict '@!' 	VALID !Empty(_cPedido)

VTREAD

IF !Empty(_cPedido)
	BNUSE02A()
Endif

While _lRet
	
	@ 00, 00 VTSay PadR('Numero Serie ' , VTMaxCol())
	@ 01, 00 VTGet _cNumSer  Pict '@!' 	VALID !Empty(@_cNumSer)
	
	VTREAD
	If (VTLastKey()==27)
		BNUSE02C()
		If (_nQtdAA3+_nQtdSC6) == 0 .OR. _nQtdAA3 < _nQtdSC6
			If (lRet:=DLVTAviso('', 'EXISTEM NUMEROS DE SERIE A SEREM COLETADOS! DESEJA ENCERRAR ?', {'SIM', 'NAO'})==1)
				Exit
			EndIf
		Else
			Exit
		Endif
	EndIf
	IF !Empty(_cNumSer)
		BNUSE02B()   //FUNCAO DE VENDA
	Endif
	BNUSE02C()
EndDo
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE02A   บAutor  ณLuciano Siqueira   บ Data ณ  09/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE02A()

_cQry := " SELECT "
_cQry += " * "
_cQry += " FROM   "+RetSqlName("SC5")+" AS SC5 (nolock)"
_cQry += " WHERE SC5.D_E_L_E_T_ = '' "
_cQry += " AND C5_FILIAL='"+xFilial("SC5")+"' "
_cQry += " AND C5_NUM='"+_cPedido+"' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY1",.T.,.T.)

QRY1->(dbGoTop())
If QRY1->(eof())
	DLVTAviso('', 'PEDIDO NAO ENCONTRADO!')
Else
	_cCliente := QRY1->C5_CLIENTE
	_cLojaCli := QRY1->C5_LOJACLI
	_lRet := .T.//inicia leitura dos produtos/numero serie
Endif

QRY1->(dbCloseArea())

VTKeyBoard(chr(20))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE02B   บAutor  ณLuciano Siqueira   บ Data ณ  09/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE02B()

Local aCabAA3	:= {}
Local aItensAA3	:= {}

dbSelectArea("AA3")
dbSetOrder(6)
If dbSeek(xFilial("AA3")+_cNumSer)
	_cProduto := AA3->AA3_CODPRO
Else
	DLVTAviso('', 'NUMERO DE SERIE '+Alltrim(_cNumSer)+' NAO ENCONTRADO NA BASE INSTALADA!')
	_cProduto := Space(15)
	_cNumSer  := Space(20)
	VTKeyBoard(chr(20))
	Return
Endif

_cQry := " SELECT "
_cQry += " C6_CLI,C6_LOJA,C6_NUM,C6_PRODUTO,SUM(C6_QTDVEN) AS QTDE,AA3_NUMSER "
_cQry += " FROM   "+RetSqlName("SC5")+" AS SC5 (nolock), "+RetSqlName("SC6")+" AS SC6 (nolock) "
_cQry += " LEFT JOIN "+RetSqlName("AA3")+" AS AA3 (nolock) "
_cQry += " ON (AA3_FILIAL='"+xFilial("AA3")+"' AND C6_CLI=AA3_CODCLI AND C6_LOJA=AA3_LOJA AND "
_cQry += " C6_NUM=AA3_NUMPED AND C6_PRODUTO=AA3_CODPRO AND AA3_NUMSER='"+_cNumSer+"' AND AA3.D_E_L_E_T_ = '') "
_cQry += " WHERE SC5.D_E_L_E_T_ = '' "
_cQry += " AND C5_FILIAL='"+xFilial("SC5")+"' "
_cQry += " AND C5_NUM='"+_cPedido+"' "
_cQry += " AND C5_CLIENTE='"+_cCliente+"' "
_cQry += " AND C5_LOJACLI='"+_cLojaCli+"' "
_cQry += " AND C6_FILIAL=C5_FILIAL "
_cQry += " AND C6_NUM=C5_NUM "
_cQry += " AND C6_CLI=C5_CLIENTE "
_cQry += " AND C6_LOJA=C5_LOJACLI "
_cQry += " AND C6_PRODUTO='"+_cProduto+"' "
_cQry += " AND SC6.D_E_L_E_T_ = '' "
_cQry += " GROUP BY C6_CLI,C6_LOJA,C6_NUM,C6_PRODUTO,AA3_NUMSER "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY1",.T.,.T.)

QRY1->(dbGoTop())
If QRY1->(eof())
	DLVTAviso('', 'PRODUTO NAO ENCONTRADO NO PEDIDO DE VENDA - '+_cPedido)
Else
	If alltrim(_cNumSer) == Alltrim(QRY1->AA3_NUMSER)
		DLVTAviso('', 'NUMERO DE SERIE '+Alltrim(_cNumSer)+ ' BAIXADO ANTERIORMENTE!')
	Else
		_cQryAA3 := " SELECT "
		_cQryAA3 += " COUNT(*) AS QTDAA3 "
		_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock) "
		_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
		_cQryAA3 += " AND AA3_CODCLI='"+QRY1->C6_CLI+"' "
		_cQryAA3 += " AND AA3_LOJA='"+QRY1->C6_LOJA+"' "
		_cQryAA3 += " AND AA3_NUMPED='"+QRY1->C6_NUM+"' "
		_cQryAA3 += " AND AA3_CODPRO='"+QRY1->C6_PRODUTO+"' "
		
		_cQryAA3 := ChangeQuery(_cQryAA3)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY2",.T.,.T.)
		
		If QRY2->QTDAA3 < QRY1->QTDE
			
			dbSelectArea("AA3")
			dbSetOrder(6)
			dbSeek(xFilial("AA3")+_cNumSer)
			
			If AA3->AA3_XCLASS <> "S"
				DLVTAviso('', 'NF DE ENTRADA '+Alltrim(AA3->AA3_XNFENT)+' NAO ENDEREวADA!')
				_cProduto := Space(15)
				_cNumSer  := Space(20)
				VTKeyBoard(chr(20))
				Return
			Endif
								
			RecLock("AA3",.F.)
			AA3->AA3_CODCLI := QRY1->C6_CLI
			AA3->AA3_LOJA   := QRY1->C6_LOJA
			AA3->AA3_NUMPED := QRY1->C6_NUM
			MsUnLock()
		Else
			DLVTAviso('', 'QTDE LIDA DO PRODUTO '+Alltrim(_cProduto)+' EXCEDE A QTDE EXISTENTE NO PEDIDO DE VENDA!')
		Endif
		QRY2->(dbCloseArea())
	Endif
Endif

QRY1->(dbCloseArea())

_cProduto := Space(15)
_cNumSer  := Space(20)

VTKeyBoard(chr(20))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE01C   บAutor  ณLuciano Siqueira   บ Data ณ  16/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE02C()


_cQry := " SELECT "
_cQry += " SUM(C6_QTDVEN) AS QTDSC6 "
_cQry += " FROM   "+RetSqlName("SC5")+" AS SC5 (nolock), "+RetSqlName("SC6")+" AS SC6 (nolock) "
_cQry += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 (nolock) ON (B1_FILIAL='"+xFilial("SB1")+"' "
_cQry += " AND C6_PRODUTO=B1_COD AND B1_XCONTSE = 'S' AND SB1.D_E_L_E_T_ = '') "
_cQry += " WHERE SC5.D_E_L_E_T_ = '' "
_cQry += " AND C5_FILIAL='"+xFilial("SC5")+"' "
_cQry += " AND C5_NUM='"+_cPedido+"' "
_cQry += " AND C5_CLIENTE='"+_cCliente+"' "
_cQry += " AND C5_LOJACLI='"+_cLojaCli+"' "
_cQry += " AND C6_FILIAL=C5_FILIAL "
_cQry += " AND C6_NUM=C5_NUM "
_cQry += " AND C6_CLI=C5_CLIENTE "
_cQry += " AND C6_LOJA=C5_LOJACLI "
_cQry += " AND SC6.D_E_L_E_T_ = '' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY3",.T.,.T.)

_nQtdSC6 := 0
QRY3->(dbGoTop())
If QRY3->(!eof())
	_nQtdSC6 := QRY3->QTDSC6
Endif
QRY3->(dbCloseArea())

_cQry := " SELECT "
_cQry += " COUNT(*) AS QTDAA3 "
_cQry += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock) "
_cQry += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 (nolock) ON (B1_FILIAL='"+xFilial("SB1")+"' "
_cQry += " AND AA3_CODPRO=B1_COD AND B1_XCONTSE = 'S' AND SB1.D_E_L_E_T_ = '') "
_cQry += " WHERE AA3.D_E_L_E_T_ = '' "
_cQry += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
_cQry += " AND AA3_CODCLI='"+_cCliente+"' "
_cQry += " AND AA3_LOJA='"+_cLojaCli+"' "
_cQry += " AND AA3_NUMPED='"+_cPedido+"' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY3",.T.,.T.)

_nQtdAA3 := 0
QRY3->(dbGoTop())
If QRY3->(!eof())
	_nQtdAA3 := QRY3->QTDAA3
Endif
QRY3->(dbCloseArea())

If (_nQtdAA3+_nQtdSC6) > 0 .AND. _nQtdAA3==_nQtdSC6
	If (lRet:=DLVTAviso('', 'TODOS OS NUMEROS DE SERIE JA FORAM COLETADOS! DESEJA ENCERRAR ?', {'SIM', 'NAO'})==1)
		_lRet := .F.
	EndIf
Endif

VTKeyBoard(chr(20))

Return

