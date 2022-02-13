
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RETTERC  บ Autor ณ M.Munhoz           บ Data ณ  16/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina especifica para gerar pedidos de venda de retorno   บฑฑ
ฑฑบ          ณ para Terceiros                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function RETTERC()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Gera็ใo de pedidos de venda de Retorno para Terceiros."
Local cDesc1  := "Este programa gera pedidos de venda de retorno para terceiros"
Local cDesc2  := "a partir de uma tabela no SQL contendo cliente, produto, TES,"
Local cDesc3  := "local e quantidade a ser retornada."
Local _cArq	  := ""

Private cPerg := "RETTERC"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 ->                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RETTERC1(@lEnd)}, "Aguarde...","Gerando pedidos de venda de Retorno para Terceiros ......", .T. )

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETTERC   บAutor  ณMicrosiga           บ Data ณ  16/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function RETTERC1()

Local _aCabSC5  := {}
Local _aIteSC6	:= {}
local _cQuery   := ""
local _cEnter   := chr(13) + chr(10)
local _nNewPV   := .t.
local _nMaxItPV := 100
local _cCliLoja	:= ""

local _aAreaSC5 := SC5->(getarea())
local _aAreaSC6 := SC6->(getarea())
local _aAreaSA1 := SA1->(getarea())
local _aAreaSA2 := SA2->(getarea())
local _aAreaSB1 := SB1->(getarea())

if select("QRY") > 0
	QRY->(dbCloseArea())
endif


_cQuery += _cEnter + " SELECT DISTINCT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_TPCF, NOME = CASE WHEN B6_TPCF = 'C' THEN A1_NOME ELSE A2_NOME END,"
_cQuery += _cEnter + "        B6_PRODUTO, B1_DESC, B1_LOCALIZ, B6_LOCAL, B6_IDENT, B6_DOC, B6_SERIE, B6_EMISSAO, B6_UENT, B6_DTDIGIT, B6_TES, F4_TESDV, B6_ESTOQUE, B6_TIPO, B6_PODER3, "
_cQuery += _cEnter + "        B6_QUANT, B6_SALDO, B2_QATU, B6_CUSTO1, B6_UM"
_cQuery += _cEnter + " FROM    "+retsqlname("SB6")+" AS SB6 (NOLOCK) "

_cQuery += _cEnter + " LEFT OUTER JOIN  "+retsqlname("SF4")+" AS F4"
_cQuery += _cEnter + " ON	F4_CODIGO = B6_TES"
_cQuery += _cEnter + " 		AND F4.D_E_L_E_T_=''"

_cQuery += _cEnter + " INNER JOIN  "+retsqlname("SB1")+" AS B1 (NOLOCK)"
_cQuery += _cEnter + " ON   B1_FILIAL = ''"
_cQuery += _cEnter + "		AND B1_COD = B6_PRODUTO"
_cQuery += _cEnter + "		AND SB1.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT OUTER JOIN  "+retsqlname("SA1")+" AS A1 (NOLOCK)"
_cQuery += _cEnter + " ON	A1_FILIAL = ''"
_cQuery += _cEnter + "		AND A1_COD = B6_CLIFOR"
_cQuery += _cEnter + "		AND A1_LOJA = B6_LOJA"
_cQuery += _cEnter + "		AND SA1.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT OUTER JOIN  "+retsqlname("SA2")+" AS A2 (NOLOCK)"
_cQuery += _cEnter + " ON	A2_FILIAL = ''"
_cQuery += _cEnter + "		AND A2_COD = B6_CLIFOR"
_cQuery += _cEnter + "		AND A2_LOJA = B6_LOJA"
_cQuery += _cEnter + "		AND SA2.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " INNER JOIN  "+retsqlname("SB2")+" AS B2"
_cQuery += _cEnter + " ON	B2.B2_FILIAL=SB6.B6_FILIAL"
_cQuery += _cEnter + "		AND B2.B2_COD=SB6.B6_PRODUTO"
_cQuery += _cEnter + "		AND B2.B2_LOCAL=SB6.B6_LOCAL"

_cQuery += _cEnter + " WHERE B6_FILIAL = '06'"
_cQuery += _cEnter + " AND B6_SALDO > 0"
_cQuery += _cEnter + " AND B6_LOCAL IN ('03','04','08','15','16')"
_cQuery += _cEnter + " AND SB6.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " ORDER BY B6_CLIFOR"


memowrite("RETTERC.SQL",_cQuery )
_cQuery := strtran(_cQuery , _cEnter , "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

QRY->(dbGoTop())

TcSetField("QRY","B6_DTDIGIT"	,"D")
TcSetField("QRY","B6_EMISSAO"	,"D")
TcSetField("QRY","B6_UENT"		,"D")

SA1->(dbSetOrder(1))

_lGerouPV := .T.

_cCliLoja := QRY->B6_CLIFOR+QRY->B6_LOJA

while QRY->(!eof()) 

_cCliLoja := QRY->B6_CLIFOR+QRY->B6_LOJA
	
	if _lGerouPV

		// Cria o cabecalho do pedido de venda
		if SA1->(dbSeek(xFilial('SA1') + _cCliLoja ))
			_cTipoCli := SA1->A1_TIPO
		endif
		_aCabSC5  := {}
		_aIteSC6  := {}
		_aCabSC5  := {	{"C5_FILIAL"	,'06'				,Nil},;
						{"C5_TIPO"		,'N'				,Nil},;
						{"C5_CLIENTE"	,_cCliente			,Nil},;
						{"C5_LOJACLI"	,_cLoja				,Nil},;
						{"C5_LOJAENT"	,_cLoja				,Nil},;
						{"C5_TIPOCLI"	,_cTipoCli			,Nil},;
						{"C5_TRANSP"   	,'01'				,Nil},;
						{"C5_CONDPAG"	,'001'				,Nil},;
						{"C5_DIVNEG"   	,'04'				,Nil},;
						{"C5_TIPLIB"	,'1'				,Nil},;
						{"C5_XUSER"		,AllTrim(cUserName)	,Nil},;
						{"C5_MENNOTA"	,''					,Nil}}
		_cTipoCli := ""
		_lGerouPV := .F.
		_cItem    := "01"
		_lCabec	  :=.F.
	endif
	
	//INCLUI ITENS DOS PEDIDOS DE VENDAS
	while QRY->(!eof()) .AND. QRY->B6_CLIFOR+QRY->B6_LOJA == _cCliLoja 

		// Cria o item do pedido de venda
		_cCodPro  := QRY->B6_PRODUTO
		_cDescPro := QRY->B1_DESC
		_nSaldo   := QRY->B6_SALDO
		_cNFOri   := QRY->B6_DOC
		_cSerOri  := QRY->B6_SERIE
		IF QRY->B6_TPCF == 'C'
			_cChaveSD2 := QRY->B6_FILIAL+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA
			_cItemOri := GetAdvFVal("SD2","D2_ITEM",_cChaveSD2,3,"") //3 =D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			_nPrcVen  := GetAdvFVal("SD2","D2_PRCVEN",_cChaveSD2,3,"")
		ELSE
			_cChaveSD1 := QRY->B6_FILIAL+QRY->B6_EMISSAO+QRY->B6_DOC+QRY->B6_SERIE+QRY->B6_CLIFOR+QRY->B6_LOJA
		 	_cItemOri := GetAdvFVal("SD1","D1_VUNIT",_cChaveSD1,3,"") // 3 = D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		 	_nPrcVen  := QRY->D1_VUNIT
		ENDIF 	
		_cIdentB6 := QRY->B6_IDENT
		_cLocal   := QRY->B6_LOCAL
		_cEndereco:= 'P999999'
		_nTotal   := ROUND(_nSaldo*_nPrcVen,2) //iif(_nQuant == QRY2->D1_QUANT, QRY2->D1_TOTAL, _nQuant * QRY2->D1_VUNIT ) // isso foi feito para resolver problemas de arredondamento
		_cTES	  := QRY->F4_TESDV
		

		if _nPrcVen >= 0.01 .and. alltrim(_cCodPro) <> '11009431001'
		Aadd(_aIteSC6,{	{"C6_ITEM"		,_cItem						,Nil},;
						{"C6_PRODUTO"	,_cCodPro					,Nil},;
						{"C6_DESCRI"	,_cDescPro					,Nil},;
						{"C6_TES"		,_cTes						,Nil},;
						{"C6_QTDVEN"	,_nQuant					,Nil},;
						{"C6_QTDLIB"	,_nQuant					,Nil},;
						{"C6_PRCVEN"	,_nPrcVen					,Nil},;
						{"C6_VALOR"		,_nTotal					,Nil},;
						{"C6_PRUNIT"	,_nPrcVen					,Nil},;
						{"C6_NFORI"		,_cNFOri					,Nil},;
						{"C6_SERIORI"	,_cSerOri					,Nil},;
						{"C6_ITEMORI"	,_cItemOri					,Nil},;
						{"C6_IDENTB6"	,_cIdentB6					,Nil},;
						{"C6_LOCAL"		,_cLocal					,Nil},;
						{"C6_ENTREG"	,dDataBase					,Nil},;
						{"C6_LOCALIZ"	,_cEndereco					,Nil} })

	
		endif
		QRY->(dbSkip())
		_cItem := Soma1(_cItem)

	enddo
	

enddo
QRY->(dbCloseArea())

//aSort(_aIteSC6,,,{|x,y| x[4,2]+x[2,2] < y[4,2]+y[2,2]})

ALERT('IRA GERAR Os PEDIDOs DE VENDA')

_aItem := {}
_cItem := '01'

FOR X := 1 TO LEN(_aIteSC6)

		_lRet := u_GeraPV(_aCabSC5, _aItem, 3) // 3 = inclusao
		_lGerouPV := .T.
		_cItem := '01'
		_aItem := {}
/*
		if _lRet 
			ALERT('TERMINOU DE GERAR O PV COM SUCESSO !!!')
		else
			ALERT('TERMINOU DE GERAR O PV COM ERRO !!!')
		endif
*/
    endif

next x
//endif
 
alert('fim do processamento')

restarea(_aAreaSC5)
restarea(_aAreaSC6)
restarea(_aAreaSA1)
restarea(_aAreaSA2)
restarea(_aAreaSB1)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 ->                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','Motorola x BGH Alpha'          ,'Motorola x BGH Alpha'          ,'Motorola x BGH Alpha'          ,'mv_ch1','N',1 ,0,0,'C',''                    ,''      ,'','S','mv_par01','Motorola'       ,'Motorola'       ,'Motorola'       ,'','BGH'            ,'BGH'            ,'BGH'            ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Endereco'                      ,'Endereco'                      ,'Endereco'                      ,'mv_ch2','C',10,0,0,'G',''                    ,''      ,'','S','mv_par01',''       ,''       ,''       ,'',''       ,''       ,''       ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')

Return Nil
