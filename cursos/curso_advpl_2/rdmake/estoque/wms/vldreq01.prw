#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDREQ01 ºAutor  ³Eduardo Barbosa     º Data ³  07/02/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validações na Rotina de Movimentação Interna Mod1 e Mod 2  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldReq01()

Local _lRet		  := .T.
Local _lVldPRO  := GetMv("BH_VALPRO",.F.,.T.)  // Validação do Produto ( Nao pode digitar o Mesmo Produto na Mesma Requisição
Local _lVldSal  := GetMv("BH_VALSAL",.F.,.T.)  // Abate do Saldo Disponivel a Qtde em Buffer e nas O.S`s WMS em Aberto
Local _cLocBuff := GetMv("MV_LOCBUF",.F.,"BUFFER")
Local _cCampo	:= ReadVar()
Local _cConteudo:= &_cCampo
Local _cCodPro	:= ""
Local _cLocPro  := ""
Local _nQtdDig	:= 0
Local _aArea	:= GetArea()

u_GerA0003(ProcName())

If _lVldPro .AND. Upper(FunName()) == "MATA241" .AND. Upper(_cCampo)  == "M->D3_COD" // Internos Modelo 2
	_nPosCod := ASCAN(aheader,{|x| Upper(Alltrim(x[2])) == Upper("D3_COD") })
	For _nElem  := 1 To Len(aCols)
		If 	_nElem == n // Desconsidera o Item Atual
			Loop
		Endif
		If Alltrim(aCols[_nElem,_nPosCod]) == Alltrim(_cConteudo)
			Alert("Item -> "+Alltrim(_cConteudo) +"Ja Digitado Nesta Requisicao")
			_lRet := .F.
			Exit
		Endif
	Next _nElem
Endif

If _lVldSal .AND. Upper(_cCampo) == "M->D3_QUANT"
	If Upper(FunName()) == "MATA241"
		_nPosCod := ASCAN(aheader,{|x| Upper(Alltrim(x[2])) == "D3_COD" })
		_nPosLoc := ASCAN(aheader,{|x| Upper(Alltrim(x[2])) == "D3_LOCAL" })
		_cCodPro := Acols[n,_nPosCod]
		_cLocPro := Acols[n,_nPosLoc]
		_cTM 	:= CTM
	ElseIf Upper(FunName()) == "MATA240"
		_cCodPro := M->D3_COD
		_cLocPro := M->D3_LOCAL
		_cTM 	:= M->D3_TM
	Endif

	If Alltrim(_cTM) > "500"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Não considera saldo da qualidade - D.FERNANDES - 09/12/13³
		//³GLPI - 16539                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cEndQua  := PADR("QUALIDADE",TamSx3("BF_LOCALIZ")[1])
	
		_cLocBuff := _cLocBuff+Space(15-Len(_cLocBuff))
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+_cCodPro+_cLocPro,.F.)
		_nSalSB2 := SB2->(B2_QATU-B2_QACLASS)
		_nSalBuff := SaldoSBF(_cLocPro, _cLOcBuff, _cCodPro, NIL, NIL, NIL, .F.)
		_nSalQual := SaldoSBF(_cLocPro, _cEndQua, _cCodPro, NIL, NIL, NIL, .F.)
		_nSalDCF  := U_SALDCF(_cCodPro,_cLocPro)
		_nSalDisp := _nSalSB2 - _nSalBuff - _nSalDCF - _nSalQual
		_nQtdDig  := _cConteudo
		If _nQtdDig > _nSalDisp
			Alert("Nao Existe Saldo Suficiente Para Este Item")
			AutoGRLog("SALDOS CONSIDERADOS " )
			AutoGRLog("SALDO ESTOQUE   -> "+Alltrim(STR(Round(_nSalSB2 ,2))))
			AutoGRLog("SALDO BUFFER    -> "+Alltrim(STR(Round(_nSalBuff,2))))
			AutoGRLog("SALDO WMS (O.S.)-> "+Alltrim(STR(Round(_nSalDCF,2))))
			AutoGRLog("SALDO QUALIDADE -> "+Alltrim(STR(Round(_nSalQual,2))))
			AutoGRLog("SALDO DISPONIVEL-> "+Alltrim(STR(Round(_nSalDisp,2))))
			MostraErro()
			_lRet := .F.
		Endif
	Endif
Endif

RestArea(_aArea)

Return _lRet


User Function SALDCF(_cProduto,_cArmazem)

Local _aAreaTRB := GetArea()

cQuery := " SELECT SUM(DCF_QUANT) AS QUANT FROM "+RetSqlName('DCF')
cQuery += " WHERE "
cQuery += " DCF_FILIAL = '"+xFilial("DCF")+"'"
cQuery += " AND DCF_ORIGEM = 'SD3'"
cQuery += " AND DCF_CODPRO = '"+_cProduto+"'"
cQuery += " AND DCF_LOCAL =  '"+_cArmazem+"'"
cQuery += " AND DCF_STSERV IN ('1','2')    "
cQuery += " AND D_E_L_E_T_ = ' '"

If SELE("TRBWMS") <> 0
	DbSelectArea("TRBWMS")
	DbCloseArea()
Endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),"TRBWMS",.F.,.T.)

TcSetField("TRBWMS","DCF_QUANT","N",14,2)

_nRet := TRBWMS->QUANT

If SELE("TRBWMS") <> 0
	DbSelectArea("TRBWMS")
	DbCloseArea()
Endif

RestArea(_aAreaTRB)
Return _nRet


