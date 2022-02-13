#INCLUDE 'RWMAKE.CH'
#INCLUDE 'APVT100.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSER01  บAutor  ณ Luciano Siqueira   บ Data ณ  02/04/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incluir numero de serie na rotina base instalada com       บฑฑ
ฑฑบ          ณ base na pr้-nota digitida pelo usuario                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ															  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BNUSER01()

Private _cNF	  := Space(09)
Private _cSerie	  := Space(03)
Private _cFornece := Space(06)
Private _cLoja    := Space(02)
Private _cProduto := Space(25)
Private _cNumSer  := Space(20)
Private _cCodCli  := "191826"//BGH
Private _cLojCli  := "01"
Private _lRet     := .F.
Private _nQtdSD1  := 0
Private _nQtdAA3  := 0

u_GerA0003(ProcName())

ProcNF()

If _lRet
	ProcProd()
Endif

While _lRet
	
	@ 05, 00 VTSay PadR('Numero Serie ' , VTMaxCol())
	@ 06, 00 VTGet _cNumSer  Pict '@!' 	VALID !Empty(@_cNumSer)
	
	VTREAD
	If (VTLastKey()==27)
		BNUSE01C()
		If (_nQtdAA3+_nQtdSD1) == 0 .OR. _nQtdAA3 < _nQtdSD1
			If (lRet:=DLVTAviso('', 'EXISTEM NUMEROS DE SERIE A SEREM COLETADOS! DESEJA ENCERRAR ?', {'SIM', 'NAO'})==1)
				Exit
			EndIf
		Else
			Exit
		Endif
	EndIf
	
	IF !Empty(_cProduto) .AND. !Empty(_cNumSer)
		BNUSE01B()   //fc que grava numero de serie na base instalada
	Endif
	
	BNUSE01C()
EndDo
Return(.T.)

Static Function ProcNF()

DLVTCabec("Gera Base Instalada",.F.,.F.,.T.)
@ 01, 00 VTSay PadR('Documento' , VTMaxCol())
@ 02, 00 VTGet _cNF  	 Pict '@!' 	VALID !Empty(_cNF)

@ 03, 00 VTSay PadR('Serie' , VTMaxCol())
@ 04, 00 VTGet _cSerie  	 Pict '@!' 	VALID !Empty(_cSerie)

VTREAD

IF !Empty(_cNF) .and. !Empty(_cSerie)
	BNUSE01A()
Endif

Return

Static Function ProcProd()

@ 03, 00 VTSay PadR('Produto ' , VTMaxCol())
@ 04, 00 VTGet _cProduto Pict '@!' 	VALID !Empty(@_cProduto)

VTREAD

If (VTLastKey()==27)
	_lRet := .F. 
	BNUSE01C()
	If (_nQtdAA3+_nQtdSD1) == 0 .OR. _nQtdAA3 < _nQtdSD1
		If (lRet:=DLVTAviso('', 'EXISTEM NUMEROS DE SERIE A SEREM COLETADOS! DESEJA ENCERRAR ?', {'SIM', 'NAO'})==1)
			_cProduto := Space(25)
		Else
			_lRet := .T. 
		EndIf
	Else
		_cProduto := Space(25)
	Endif
EndIf

IF !Empty(_cProduto)
	BNUSE01D()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE01A   บAutor  ณLuciano Siqueira   บ Data ณ  02/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE01A()

_cQry := " SELECT "
_cQry += " TOP 1 F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA  "
_cQry += " FROM   "+RetSqlName("SF1")+" AS SF1 (nolock),"+RetSqlName("SDA")+" AS SDA (nolock) "
_cQry += " WHERE SF1.D_E_L_E_T_ = '' "
_cQry += " AND F1_FILIAL='"+xFilial("SF1")+"' "
_cQry += " AND F1_DOC='"+_cNF+"' "
_cQry += " AND F1_SERIE='"+_cSerie+"' "
_cQry += " AND DA_FILIAL='"+xFilial("SDA")+"' "
_cQry += " AND DA_DOC=F1_DOC "
_cQry += " AND DA_SERIE=F1_SERIE "
_cQry += " AND DA_CLIFOR=F1_FORNECE "
_cQry += " AND DA_LOJA=F1_LOJA "
_cQry += " AND DA_SALDO > 0 "
_cQry += " AND SDA.D_E_L_E_T_='' "


_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRYA",.T.,.T.)

QRYA->(dbGoTop())
If QRYA->(eof())
	DLVTAviso('', 'NOTA NAO ENCONTRADA OU JA ENDERECADA!')
Else
	_cSerie	  := QRYA->F1_SERIE
	_cFornece := QRYA->F1_FORNECE
	_cLoja    := QRYA->F1_LOJA
	_lRet 	  := .T.//inicia leitura dos produtos/numero serie
Endif

QRYA->(dbCloseArea())

VTKeyBoard(chr(20))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE01B   บAutor  ณLuciano Siqueira   บ Data ณ  02/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE01B()

Local aCabAA3	:= {}
Local aItensAA3	:= {}

_cQry := " SELECT "
_cQry += " D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD,SUM(D1_QUANT) AS QTDE, AA3_NUMSER"
_cQry += " FROM   "+RetSqlName("SF1")+" AS SF1 (nolock), "+RetSqlName("SD1")+" AS SD1 (nolock) "
_cQry += " LEFT JOIN "+RetSqlName("AA3")+" AS AA3 (nolock) "
_cQry += " ON (AA3_FILIAL='"+xFilial("AA3")+"' AND D1_FORNECE=AA3_FORNEC AND D1_LOJA=AA3_LOJAFO AND D1_DOC=AA3_XNFENT "
_cQry += " AND D1_SERIE=AA3_XSEREN AND D1_COD=AA3_CODPRO AND AA3_NUMSER='"+_cNumSer+"' AND AA3_CODCLI='"+_cCodCli+"' "
_cQry += " AND AA3_LOJA='"+_cLojCli+"' AND AA3.D_E_L_E_T_ = '') "
_cQry += " WHERE SF1.D_E_L_E_T_ = '' "
_cQry += " AND F1_FILIAL='"+xFilial("SF1")+"' "
_cQry += " AND F1_DOC='"+_cNF+"' "
_cQry += " AND F1_SERIE='"+_cSerie+"' "
_cQry += " AND F1_FORNECE='"+_cFornece+"' "
_cQry += " AND F1_LOJA='"+_cLoja+"' "
_cQry += " AND D1_FILIAL=F1_FILIAL "
_cQry += " AND D1_DOC=F1_DOC "
_cQry += " AND D1_FORNECE=F1_FORNECE "
_cQry += " AND D1_LOJA=F1_LOJA "
_cQry += " AND D1_DTDIGIT=F1_DTDIGIT "
_cQry += " AND D1_COD='"+_cProduto+"' "
_cQry += " AND SD1.D_E_L_E_T_ = '' "
_cQry += " GROUP BY D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD,AA3_NUMSER"

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRYB",.T.,.T.)

QRYB->(dbGoTop())

If alltrim(_cNumSer) == Alltrim(QRYB->AA3_NUMSER)
	DLVTAviso('', 'NUMERO DE SERIE '+Alltrim(_cNumSer)+ ' JA EXISTE NA BASE INSTALADA!')
Else
	_cQryAA3 := " SELECT "
	_cQryAA3 += " COUNT(*) AS QTDAA3 "
	_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock) "
	_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
	_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
	_cQryAA3 += " AND AA3_CODCLI='"+_cCodCli+"' "
	_cQryAA3 += " AND AA3_LOJA='"+_cLojCli+"' "
	_cQryAA3 += " AND AA3_XNFENT='"+QRYB->D1_DOC+"' "
	_cQryAA3 += " AND AA3_XSEREN='"+QRYB->D1_SERIE+"' "
	_cQryAA3 += " AND AA3_FORNEC='"+QRYB->D1_FORNECE+"' "
	_cQryAA3 += " AND AA3_LOJAFO='"+QRYB->D1_LOJA+"' "
	_cQryAA3 += " AND AA3_CODPRO='"+QRYB->D1_COD+"' "
	
	_cQryAA3 := ChangeQuery(_cQryAA3)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRYAA3",.T.,.T.)
	
	If QRYAA3->QTDAA3 < QRYB->QTDE
		
		Aadd(aCabAA3, { "AA3_FILIAL"	, xFilial("AA3")	, NIL } )
		Aadd(aCabAA3, { "AA3_CODCLI"	, _cCodCli      	, NIL } )
		Aadd(aCabAA3, { "AA3_LOJA"	 	, _cLojCli  		, NIL } )
		Aadd(aCabAA3, { "AA3_CODPRO"	, QRYB->D1_COD	  	, NIL } )
		Aadd(aCabAA3, { "AA3_NUMSER"	, _cNumSer			, NIL } )
		Aadd(aCabAA3, { "AA3_XNFENT"	, QRYB->D1_DOC		, NIL } )
		Aadd(aCabAA3, { "AA3_XSEREN"	, QRYB->D1_SERIE	, NIL } )
		Aadd(aCabAA3, { "AA3_XCLASS"	, "N"				, NIL } )
		
		lMSErroAuto := .F.
		MSExecAuto( {|w,x,y,z| TECA040(w,x,y,z)}, NIL, aCabAA3, aItensAA3, 3)
		
		If lMsErroAuto
			DLVTAviso('', 'ERRO NA INCLUSAO DO NUMERO DE SERIE')
		Else
			RecLock("AA3",.F.)
			AA3->AA3_FORNEC := QRYB->D1_FORNECE
			AA3->AA3_LOJAFO := QRYB->D1_LOJA
			MsUnLock()
		EndIf
		
	Else
		DLVTAviso('', 'QTDE LIDA DO PRODUTO '+Alltrim(_cProduto)+' EXCEDE A QTDE EXISTENTE NA NOTA!')
		_cProduto := Space(25)
		_lRet := .F.
	Endif
	QRYAA3->(dbCloseArea())
	If !_lRet
		_lRet := .T.
		ProcProd() 
	Endif
Endif

QRYB->(dbCloseArea())

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

Static Function BNUSE01C()

_cQry := " SELECT "
_cQry += " SUM(D1_QUANT) AS QTDSD1 "
_cQry += " FROM   "+RetSqlName("SF1")+" AS SF1 (nolock), "+RetSqlName("SD1")+" AS SD1 (nolock) "
_cQry += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 (nolock) ON (B1_FILIAL='"+xFilial("SB1")+"' "
_cQry += " AND D1_COD=B1_COD AND B1_XCONTSE = 'S' AND SB1.D_E_L_E_T_ = '') "
_cQry += " WHERE SF1.D_E_L_E_T_ = '' "
_cQry += " AND F1_FILIAL='"+xFilial("SF1")+"' "
_cQry += " AND F1_DOC='"+_cNF+"' "
_cQry += " AND F1_SERIE='"+_cSerie+"' "
_cQry += " AND F1_FORNECE='"+_cFornece+"' "
_cQry += " AND F1_LOJA='"+_cLoja+"' "
_cQry += " AND D1_FILIAL=F1_FILIAL "
_cQry += " AND D1_DOC=F1_DOC "
_cQry += " AND D1_FORNECE=F1_FORNECE "
_cQry += " AND D1_LOJA=F1_LOJA "
_cQry += " AND D1_DTDIGIT=F1_DTDIGIT "
If _lRet
	_cQry += " AND D1_COD='"+_cProduto+"' "
Endif
_cQry += " AND SD1.D_E_L_E_T_ = '' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRYC",.T.,.T.)

_nQtdSD1 := 0
QRYC->(dbGoTop())
If QRYC->(!eof())
	_nQtdSD1 := QRYC->QTDSD1
Endif
QRYC->(dbCloseArea())

_cQry := " SELECT "
_cQry += " COUNT(*) AS QTDAA3 "
_cQry += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock) "
_cQry += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 (nolock) ON (B1_FILIAL='"+xFilial("SB1")+"' "
_cQry += " AND AA3_CODPRO=B1_COD AND B1_XCONTSE = 'S' AND SB1.D_E_L_E_T_ = '') "
_cQry += " WHERE AA3.D_E_L_E_T_ = '' "
_cQry += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
_cQry += " AND AA3_CODCLI='"+_cCodCli+"' "
_cQry += " AND AA3_LOJA='"+_cLojCli+"' "
_cQry += " AND AA3_XNFENT='"+_cNF+"' "
If _lRet
	_cQry += " AND AA3_CODPRO='"+_cProduto+"' "
Endif
_cQry += " AND AA3_XSEREN='"+_cSerie+"' "
_cQry += " AND AA3_FORNEC='"+_cFornece+"' "
_cQry += " AND AA3_LOJAFO='"+_cLoja+"' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRYAA3",.T.,.T.)

_nQtdAA3 := 0
QRYAA3->(dbGoTop())
If QRYAA3->(!eof())
	_nQtdAA3 := QRYAA3->QTDAA3
Endif
QRYAA3->(dbCloseArea())

If (_nQtdAA3+_nQtdSD1) > 0 .AND. _nQtdAA3==_nQtdSD1
	_cProduto := Space(25)
	If _lRet
		ProcProd()
	Endif
Endif

VTKeyBoard(chr(20))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNUSE01B   บAutor  ณLuciano Siqueira   บ Data ณ  02/04/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BNUSE01D()

dbSelectArea("SB1")
dbSetOrder(1)
If !dbSeek(xFilial("SB1")+_cProduto)
	dbSelectArea("SB1")
	dbSetOrder(11)
	If dbSeek(xFilial("SB1")+_cProduto)//codigo WS
		_cProduto := SB1->B1_COD
		If SB1->B1_XCONTSE <> "S"
			DLVTAviso('', 'PRODUTO '+Alltrim(_cProduto)+' NAO CONTROLA NUMERO DE SERIE')
			_cProduto := Space(25)
			_lRet 	  := .F.
			VTKeyBoard(chr(20))
		Endif
	Else
		DLVTAviso('', 'PRODUTO '+Alltrim(_cProduto)+' NAO EXISTE NO CADASTRO')
		_cProduto := Space(25)
		_lRet 	  := .F.
		VTKeyBoard(chr(20))
	Endif
Else
	If SB1->B1_XCONTSE <> "S"
		DLVTAviso('', 'PRODUTO '+Alltrim(_cProduto)+' NAO CONTROLA NUMERO DE SERIE')
		_cProduto := Space(25)
		_lRet 	  := .F.
		VTKeyBoard(chr(20))
	Endif
Endif

_cQry := " SELECT "
_cQry += " D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD,SUM(D1_QUANT) AS QTDE"
_cQry += " FROM   "+RetSqlName("SF1")+" AS SF1 (nolock), "+RetSqlName("SD1")+" AS SD1 (nolock) "
_cQry += " WHERE SF1.D_E_L_E_T_ = '' "
_cQry += " AND F1_FILIAL='"+xFilial("SF1")+"' "
_cQry += " AND F1_DOC='"+_cNF+"' "
_cQry += " AND F1_SERIE='"+_cSerie+"' "
_cQry += " AND F1_FORNECE='"+_cFornece+"' "
_cQry += " AND F1_LOJA='"+_cLoja+"' "
_cQry += " AND D1_FILIAL=F1_FILIAL "
_cQry += " AND D1_DOC=F1_DOC "
_cQry += " AND D1_FORNECE=F1_FORNECE "
_cQry += " AND D1_LOJA=F1_LOJA "
_cQry += " AND D1_DTDIGIT=F1_DTDIGIT "
_cQry += " AND D1_COD='"+_cProduto+"' "
_cQry += " AND SD1.D_E_L_E_T_ = '' "
_cQry += " GROUP BY D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD"

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRYD",.T.,.T.)

QRYD->(dbGoTop())
If QRYD->(eof())
	DLVTAviso('', 'PRODUTO NAO ENCONTRADO NA NOTA - '+_cNF)
	_lRet 	  := .F.
	_cProduto := Space(25)
	VTKeyBoard(chr(20))
Endif

QRYD->(dbCloseArea())

If !_lRet
	_lRet 	  := .T.
	ProcProd()
Endif

Return
