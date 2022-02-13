#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHPVPEC³ Autor ³ Luciano Siqueira      ³ Data ³ 14/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerar pedido de Venda de pecas da Positivo que não sairam   ±±
±±           ³ com os equipamentos                                         ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BGHPVPEC()

MsAguarde({|| GERPVPEC()},OemtoAnsi("Processando..."))

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GERPVPEC  ³ Autor ³ Luciano Siqueira    ³ Data ³ 14/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geração dos Pedidos de Venda                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GERPVPEC()

Local nSaldo	:= 0
Local nSaldoBF	:= 0
Local nSaldoB6  := 0
Local _aCabSC5  := {}
Local _aIteSC6  := {}
Local _aStru	:= {;
{"CLIENTE"	, "C", TamSX3("A1_COD")[1],0},;
{"LOJA" 	, "C", TamSX3("A1_LOJA")[1],0},;
{"IMEI" 	, "C", TamSX3("ZZ4_IMEI")[1],0},;
{"NUMOS" 	, "C", TamSX3("ZZ4_OS")[1],0},;
{"PRODUTO"	, "C", TamSX3("B1_COD")[1],0},;
{"PECA"		, "C", TamSX3("B1_COD")[1],0},;
{"PEDIDO"	, "C", TamSX3("C5_NUM")[1],0},;
{"ITEMPV"	, "C", TamSX3("C6_ITEM")[1],0},;
{"NF"		, "C", TamSX3("D2_DOC")[1],0},;
{"SERIE"	, "C", TamSX3("D2_SERIE")[1],0},;
{"LOG"		, "C", 50,0}}

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

_cChaveInd	:= "CLIENTE+LOJA+IMEI+NUMOS"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

cQuery := " SELECT DISTINCT "
cQuery += " ZZ4_CODCLI, "
cQuery += " ZZ4_LOJA, "
cQuery += " A1_NOME, "
cQuery += " ZZ4_NFSNR, "
cQuery += " ZZ4_NFSSER, "
cQuery += " ZZ4_IMEI, "
cQuery += " ZZ4_OS, "
cQuery += " ZZ4_CODPRO, "
cQuery += " Z9_PARTNR, "
cQuery += " B1_LOCALIZ "
cQuery += " FROM SZ9020 SZ9 (NOLOCK) "
cQuery += " INNER JOIN ZZ4020 ZZ4 (NOLOCK) ON "
cQuery += " ZZ4_FILIAL='02' AND "
cQuery += " ZZ4_IMEI=Z9_IMEI AND "
cQuery += " ZZ4_OS=Z9_NUMOS AND "
cQuery += " ZZ4_STATUS='9' AND "
cQuery += " ZZ4_OPEBGH = 'P04' AND "
cQuery += " ZZ4_OS IN ('9B42RS','9B48BJ')    AND "
cQuery += " ZZ4.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN SA1020 SA1 (NOLOCK) ON "
cQuery += " A1_COD=ZZ4_CODCLI AND "
cQuery += " A1_LOJA=ZZ4_LOJA AND "
cQuery += " SA1.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN SB1020 SB1 (NOLOCK) ON "
cQuery += " B1_COD=Z9_PARTNR AND "
cQuery += " SB1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SD2020 SD2 (NOLOCK) ON "
cQuery += " D2_FILIAL='02' AND "
cQuery += " D2_DOC=ZZ4_NFSNR AND "
cQuery += " D2_SERIE=ZZ4_NFSSER AND "
cQuery += " D2_CLIENTE=ZZ4_CODCLI AND "
cQuery += " D2_LOJA=ZZ4_LOJA AND "
cQuery += " D2_COD=Z9_PARTNR AND "
cQuery += " SD2.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN ZZQ020 ZZQ (NOLOCK) ON "
cQuery += " ZZQ_FILIAL='02' AND "
cQuery += " ZZQ_IMEI=ZZ4_IMEI AND "
cQuery += " ZZQ_NUMOS=ZZ4_OS AND "
cQuery += " ZZQ_MODELO=ZZ4_CODPRO AND "
cQuery += " ZZQ_PECA=Z9_PARTNR AND "
cQuery += " ZZQ.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " Z9_FILIAL='02' AND "
cQuery += " Z9_PARTNR <> '' AND "
cQuery += " SZ9.D_E_L_E_T_ = '' AND "
cQuery += " Z9_NUMSEQP<>'' AND "
cQuery += " Z9_NUMSEQ<>'' AND "
cQuery += " D2_COD IS NULL AND "
cQuery += " ZZQ_PECA IS NULL "
cQuery += " ORDER BY ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFSNR,ZZ4_NFSSER "

TCQuery cQuery new Alias (cAlias:=GetNextAlias())

dbSelectArea(cAlias)
dbGotop()
If (cAlias)->(!Eof())
	While (cAlias)->(!Eof())
		
		cCodCli  := (cAlias)->(ZZ4_CODCLI+ZZ4_LOJA)
		cChavTRB := (cAlias)->(ZZ4_CODCLI+ZZ4_LOJA+ZZ4_IMEI+ZZ4_OS)
		_aCabSC5 := {}
		_aIteSC6 := {} 
		cItens   := '00'
		
		_aCabSC5  := {	{"C5_TIPO"		,"N"					,Nil},;
		{"C5_CLIENTE"	,(cAlias)->ZZ4_CODCLI					,Nil},;
		{"C5_LOJACLI"	,(cAlias)->ZZ4_LOJA						,Nil},;
		{"C5_LOJAENT"	,(cAlias)->ZZ4_LOJA						,Nil},;
		{"C5_TIPOCLI"	,"F"					    			,Nil},;
		{"C5_CONDPAG"	,'001'	   								,Nil},;
		{"C5_TIPLIB"	,'1'	   								,Nil},;
		{"C5_TPCARGA"	,'2'	   								,Nil},;
		{"C5_B_KIT"		,""		   								,Nil},;
		{"C5_XUSER"		,alltrim(cusername)						,Nil},;
		{"C5_TRANSP"    ,"01"				                    ,Nil},;
		{"C5_MENPAD"    ,""		             			        ,Nil},;
		{"C5_DIVNEG"    ,"22"	                  				,Nil},;
		{"C5_MENNOTA"	,""		      							,Nil}}
		
		While (cAlias)->(!Eof()) .and. (cAlias)->(ZZ4_CODCLI+ZZ4_LOJA)==cCodCli
			
			RecLock("TRB",.T.)
			TRB->CLIENTE		:= (cAlias)->ZZ4_CODCLI
			TRB->LOJA 		 	:= (cAlias)->ZZ4_LOJA
			TRB->IMEI	 		:= (cAlias)->ZZ4_IMEI
			TRB->NUMOS	 		:= (cAlias)->ZZ4_OS
			TRB->PRODUTO 		:= (cAlias)->ZZ4_CODPRO
			TRB->PECA	 		:= (cAlias)->Z9_PARTNR
			
			nSaldo	 := 1
			nSaldoBF := 0
			_nSalb2  := 0
			
			If (cAlias)->B1_LOCALIZ=="S"
				nSaldoBF := SaldoSBF("A5", "S", Left((cAlias)->Z9_PARTNR,15), NIL, NIL, NIL, .F.)
			Else
				dbselectarea("SB2")
				dbSetOrder(1)
				If SB2->(DBSeek(xFilial('SB2') +Left((cAlias)->Z9_PARTNR,15) + "A5"))
					_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
				Endif
			Endif
			
			DbSelectArea("SB6")
			SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
			
			_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT "
			_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
			_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
			_cQrySB6 += "        B6_PRODUTO = '"+(cAlias)->Z9_PARTNR+"' AND "
			_cQrySB6 += "        B6_CLIFOR  = '204018' AND "
			_cQrySB6 += "        B6_LOJA    = '02' AND "
			_cQrySB6 += "        B6_SALDO > 0 AND "
			_cQrySB6 += "B6_LOCAL ='A2' AND "
			_cQrySB6 += "B6.D_E_L_E_T_ = '' "
			_cQrySB6 += " ORDER BY B6_IDENT "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
			
			TSQLSB6->(DBGoTop())
			
			While TSQLSB6->(!EOF()) .and. nSaldo > 0
				_nSalP3  := SalDisP3(TSQLSB6->B6_IDENT, TSQLSB6->B6_SALDO)
				_nQtRet3 := iif(_nSalP3 >= nSaldo, nSaldo, _nSalP3)
				
				IF _nQtRet3 > 0
					cItens   := Soma1(cItens,2)
					nSaldo   := nSaldo - _nQtRet3
					_nPrcVen := A410Arred(TSQLSB6->B6_PRUNIT,"C6_VALOR")
					_nValor  := A410Arred(TSQLSB6->B6_PRUNIT * _nQtRet3,"C6_VALOR")
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+TSQLSB6->B6_PRODUTO)
					
					If SB1->B1_LOCALIZ=="S" .and. nSaldoBF >= _nQtRet3
						Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens	        ,Nil},;
						{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
						{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
						{"C6_TES"		,"738"							,Nil},;
						{"C6_QTDVEN"	,_nQtRet3				  		,Nil},;
						{"C6_QTDLIB"	,_nQtRet3						,Nil},;
						{"C6_NUMSERI"	,""                 			,Nil},;
						{"C6_NUMOS"		,""						        ,Nil},;
						{"C6_PRCVEN"	,_nPrcVen						,Nil},;
						{"C6_VALOR"		,_nValor			   			,Nil},;
						{"C6_PRUNIT"	,_nPrcVen						,Nil},;
						{"C6_NFORI"		,TSQLSB6->B6_DOC				,Nil},;
						{"C6_SERIORI"	,TSQLSB6->B6_SERIE				,Nil},;
						{"C6_ITEMORI"	,""								,Nil},;
						{"C6_IDENTB6"	,TSQLSB6->B6_IDENT				,Nil},;
						{"C6_PRCCOMP"	,0								,Nil},;
						{"C6_LOCAL"		,"A5"							,Nil},;
						{"C6_ENTREG"	,dDataBase						,Nil},;
						{"C6_OSGVS"		,""								,Nil},;
						{"C6_AIMPGVS"	,""								,Nil},;
						{"C6_LOCALIZ"	,"S"							,Nil}})
					ElseIf SB1->B1_LOCALIZ <>"S" .and. _nSalb2 >= _nQtRet3
						Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens	        ,Nil},;
						{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
						{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
						{"C6_TES"		,"738"							,Nil},;
						{"C6_QTDVEN"	,_nQtRet3				  		,Nil},;
						{"C6_QTDLIB"	,_nQtRet3						,Nil},;
						{"C6_NUMSERI"	,""                 			,Nil},;
						{"C6_NUMOS"		,""					            ,Nil},;
						{"C6_PRCVEN"	,_nPrcVen						,Nil},;
						{"C6_VALOR"		,_nValor			   			,Nil},;
						{"C6_PRUNIT"	,_nPrcVen						,Nil},;
						{"C6_NFORI"		,TSQLSB6->B6_DOC				,Nil},;
						{"C6_SERIORI"	,TSQLSB6->B6_SERIE				,Nil},;
						{"C6_ITEMORI"	,""								,Nil},;
						{"C6_IDENTB6"	,TSQLSB6->B6_IDENT				,Nil},;
						{"C6_PRCCOMP"	,0								,Nil},;
						{"C6_LOCAL"		,"A5"							,Nil},;
						{"C6_ENTREG"	,dDataBase						,Nil},;
						{"C6_OSGVS"		,""								,Nil},;
						{"C6_AIMPGVS"	,""								,Nil},;
						{	,											,Nil}})
					Endif
					
				Endif
				TSQLSB6->(dbSkip())
			Enddo
			If Select("TSQLSB6") > 0
				dbSelectArea("TSQLSB6")
				DbCloseArea()
			EndIf	
			If (cAlias)->B1_LOCALIZ=="S"
				If nSaldoBF < 1 .and. nsaldo > 0
					TRB->LOG := "NAO POSSUI SALDO NO ENDERECO E DE TERCEIRO."
				ElseIf nSaldoBF < 1
					TRB->LOG := "NAO POSSUI SALDO NO ENDERECO."
				ElseIf nsaldo > 0
					TRB->LOG := "NAO POSSUI SALDO DE TERCEIRO."
				Endif
			Else
				If _nSalb2 < 1 .and. nsaldo > 0
					TRB->LOG := "NAO POSSUI SALDO NO ARMAZEM E DE TERCEIRO."
				ElseIf nSaldoBF < 1
					TRB->LOG := "NAO POSSUI SALDO NO ARMAZEM."
				ElseIf nsaldo > 0
					TRB->LOG := "NAO POSSUI SALDO DE TERCEIRO."
				Endif
			Endif
			TRB->(MSUNLOCK())
			(cAlias)->(DbSkip())
		EndDo
		IF len(_aCabSC5) > 0 .and. len(_aIteSC6) > 0
			_lRet := u_geraPV(_aCabSC5, _aIteSC6, 3)
			If _lRet
				aPedido := {}              
				aadd(aPedido,SC5->C5_NUM)
				MsAguarde({|| GERAZZQ(SC5->C5_NUM)},OemtoAnsi("Atualizando Peças..."))
				GERANF(aPedido)
				dbSelectArea("TRB")
				If dbSeek(cChavTRB)
					While TRB->(!EOF()) .and. TRB->(CLIENTE+LOJA+IMEI+NUMOS)==cChavTRB
						dbSelectArea("SC6")
						dbSetOrder(2)
						If dbSeek(xFilial("SC6")+TRB->PECA+SC5->C5_NUM)
							dbSelectArea("TRB")
							RecLock("TRB",.F.)
							TRB->PEDIDO		:= SC6->C6_NUM
							TRB->ITEMPV		:= SC6->C6_ITEM
							TRB->NF			:= SC6->C6_NOTA
							TRB->SERIE		:= SC6->C6_SERIE
							TRB->(MSUNLOCK())
						Endif
						TRB->(dbSkip())
					EndDo
				Endif
			Else
				dbSelectArea("TRB")
				If dbSeek(cChavTRB)
					While TRB->(!EOF()) .and. TRB->(CLIENTE+LOJA+IMEI+NUMOS)==cChavTRB
						RecLock("TRB",.F.)
						TRB->LOG := "PEDIDO NAO GERADO. FAVOR ANALISAR!"
						TRB->(MSUNLOCK())
						TRB->(dbSkip())
					EndDo
				Endif
			Endif
		Endif
	Enddo
Else
	MsgAlert("Não existem dados para processamento.")
Endif
(cAlias)->(DbCloseArea())

dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
	If Sele("TRB")<>0
		TRB->(DbCloseArea())
	Endif
	Return
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SalDisP3  ºAutor  ³Microsiga           º Data ³  09/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular saldo disponivel de Terceiros.        º±±
±±º          ³ Desconta PV abertos do SB6->B6_SALDO                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


Static Function GERAZZQ(cPedido)

Local aAreaAtu := GetArea()

cQryPec := " SELECT "
cQryPec += " C6_PRODUTO AS PECA,C6_QTDVEN AS QTDE,C6_PRCVEN AS VLUNIT,C6_VALOR AS VLTOTAL, "
cQryPec += " C6_NUM AS PEDPECA,C6_ITEM AS ITPECA,C6_NFORI AS NFORI,C6_SERIORI AS SERIORI, "
cQryPec += " C6_IDENTB6 AS IDENT, C6_CLI AS CLISAI, C6_LOJA AS LOJSAI "
cQryPec += " FROM "+ RETSQLNAME("SC6")+" SC6 (nolock) "
cQryPec += " WHERE "
cQryPec += " C6_FILIAL ='"+xFilial("SC6")+"' "
cQryPec += " AND C6_NUM='"+cPedido+"' "
cQryPec += " AND C6_TES = '738' "
cQryPec += " AND SC6.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPec),"TSQLPEC",.T.,.T.)

TSQLPEC->(DBGoTop())

While TSQLPEC->(!EOF())
	
	dbSelectArea("TRB")
	dbSeek(cChavTRB)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+TRB->PRODUTO)
	
	dbSelectArea("SB6")
	dbSetOrder(3)
	dbSeek(xFilial("SB6")+TSQLPEC->IDENT+TSQLPEC->PECA+"R")
	
	
	Begin Transaction
	Reclock("ZZQ",.t.)
	ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
	ZZQ->ZZQ_IMEI   := TRB->IMEI
	ZZQ->ZZQ_NUMOS  := TRB->NUMOS
	ZZQ->ZZQ_MODELO := TRB->PRODUTO
	ZZQ->ZZQ_CODEST := SB1->B1_GRUPO
	ZZQ->ZZQ_DTSAID := dDataBase
	ZZQ->ZZQ_PV     := TSQLPEC->PEDPECA
	ZZQ->ZZQ_ITEMPV := TSQLPEC->ITPECA
	ZZQ->ZZQ_CLISAI := TSQLPEC->CLISAI
	ZZQ->ZZQ_LOJSAI := TSQLPEC->LOJSAI
	ZZQ->ZZQ_PECA   := TSQLPEC->PECA
	ZZQ->ZZQ_QTDE   := TSQLPEC->QTDE
	ZZQ->ZZQ_VLRUNI := TSQLPEC->VLUNIT
	ZZQ->ZZQ_VLRTOT := TSQLPEC->VLTOTAL
	ZZQ->ZZQ_NFORI  := TSQLPEC->NFORI
	ZZQ->ZZQ_SERORI := TSQLPEC->SERIORI
	ZZQ->ZZQ_CLIORI := SB6->B6_CLIFOR
	ZZQ->ZZQ_LOJORI := SB6->B6_LOJA
	ZZQ->ZZQ_OPEBGH := "P04"
	msunlock()
	End Transaction
	TSQLPEC->(DBSkip())
EndDo
If Select("TSQLPEC") > 0
	dbSelectArea("TSQLPEC")
	DbCloseArea()
EndIf
RestArea(aAreaAtu)

Return


Static Function GeraNF(aPedido)

Local aAreaAtu  := GetArea()
Local aPvlNfs   := {}
Local aBloqueio := {{"","","","","","","",""}}
Local aNotas    := {}
Local cSerie	:= "001"


For i:=1 to len(aPedido)
	aPvlNfs   := {}
	aBloqueio := {{"","","","","","","",""}}
	aNotas    := {}
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+aPedido[i])
		//Liberando Bloqueios do Pedido
		SC9->(DBSetOrder(1))
		If SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM))
			While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
				RecLock("SC9",.F.)
				If SC9->C9_BLEST <> "10"
					SC9->C9_BLEST  := ""
				EndIf
				If SC9->C9_BLCRED <> "10"
					SC9->C9_BLCRED := ""
				EndIf
				SC9->(MsUnlock())
				SC9->(DbSkip())
			EndDo
		EndIf
		
		// Checa itens liberados
		IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		
		//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
		cNotaFeita :=""
		If Empty(aBloqueio) .And. !Empty(aPvlNfs)
			nItemNf  := a460NumIt(cSerie)
			aadd(aNotas,{})
			// Efetua as quebras de acordo com o numero de itens
			For nX := 1 To Len(aPvlNfs)
				If Len(aNotas[Len(aNotas)])>=nItemNf
					aadd(aNotas,{})
				EndIf
				aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
			Next nX
			For nX := 1 To Len(aNotas)
				//Gera a Nota Fiscal
				IncProc( "Gerando Nota para Pedido " + SC5->C5_NUM)
				cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
			Next nX
		endIf
	Endif
Next i

RestArea(aAreaAtu)

Return       



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPEXC    ºAutor  ³Luciano Siqueira    º Data ³  12/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Log das Inconsistencias encontradas                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

TRCell():New(oSection1,"CLIENTE","TRB","CLIENTE","@!",06)
TRCell():New(oSection1,"LOJA","TRB","LOJA","@!",02)
TRCell():New(oSection1,"IMEI","TRB","IMEI","@!",20)
TRCell():New(oSection1,"NUMOS","TRB","OS","@!",06)
TRCell():New(oSection1,"PRODUTO","TRB","PRODUTO","@!",15)
TRCell():New(oSection1,"PECA","TRB","PECA","@!",15)
TRCell():New(oSection1,"PEDIDO","TRB","PEDIDO","@!",06)
TRCell():New(oSection1,"ITEMPV","TRB","ITEM PV","@!",04)
TRCell():New(oSection1,"NF","TRB","NF SAIDA","@!",09)
TRCell():New(oSection1,"SERIE","TRB","SERIE","@!",03)
TRCell():New(oSection1,"LOG","TRB","LOG","@!",50)   

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
