#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA261D3   ºAutor  ³Eduardo Barbosa     º Data ³  02/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. Executado apos a transferencia para Geracao de 		  º±±
±±º			 ³ Requisicao Automatica                			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA261D3()
Local _aAreaD3 := GetArea()
u_GerA0003(ProcName())
dbSelectArea("SD3")
_aAreaD3	:= GetArea()
_cBxTran	:= GetMv("BH_BXTRAN",.F.,"N")
_cCodTM		:= ""
_cTMCusto	:= GetMv("BH_TMPROD",.F.,"502")
_cTMConsu	:= GetMv("BH_TMCONS",.F.,"505")
_cLocBai	:= GetMv("BH_LOCBAI",.F.,"1P")
_cCodPro	:= SD3->D3_COD
_cCodLoc	:= SD3->D3_LOCAL
_nQtde		:= SD3->D3_QUANT
_cCodEnd	:= SD3->D3_LOCALIZ
_cCodDoc	:= SD3->D3_DOC
_cCodDoc	:= Soma1(_cCodDoc,6)
_lBxTran	:= .F.
If Alltrim(_cCodLoc) == Alltrim(_cLocBai) .AND. _cBxTran <> "X"
	_cCodTM := _cTMCusto
	If Consumo(_cCodPro)
		_cCodTM	 	:= _cTMConsu
		_lBxTran 	:= .T.
	ElseIf _cBxTran == "S"
		_lBxTran 	:= .T.
	ElseIf _cBxTran == "C" .AND. !_lBxTran
		If IsTelNet()
			_lBxTran	:= .T.
		ElseIf MsgYesNo("Esta transferência de peça deve ser baixada pra custo?","Baixa de peças pra Custo.")
			_lBxTran	:= .T.
		Endif
	EndIf
Endif
If _lBxTran
	U_ATUSD3(_cCodTM,_cCodPro,_cCodLoc,_nQtde,_cCodEnd,_cCodDoc)
EndIf
RestArea(_aAreaD3)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA261D3   ºAutor  ³Hudson de Souza Santos º Data ³ 31/03/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que define se produto é de consumo ou não. Sendo:    º±±
±±º          ³B1_LOCPAD = "55" ou (B1_LOCPAD = "01" e B1_TIPO = "MC")     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Consumo(cProduto)
Local aArea		:= GetArea()
Local lRet		:= .F.
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	If SB1->B1_LOCPAD == "55" .OR. (SB1->B1_LOCPAD == "01" .AND. SB1->B1_TIPO == "MC")
		lRet := .T.
	EndIf
EndIf
RestArea(aArea)
Return(lRet)