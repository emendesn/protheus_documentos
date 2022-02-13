#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261D3   �Autor  �Eduardo Barbosa     � Data �  02/12/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. Executado apos a transferencia para Geracao de 		  ���
���			 � Requisicao Automatica                			          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
		ElseIf MsgYesNo("Esta transfer�ncia de pe�a deve ser baixada pra custo?","Baixa de pe�as pra Custo.")
			_lBxTran	:= .T.
		Endif
	EndIf
Endif
If _lBxTran
	U_ATUSD3(_cCodTM,_cCodPro,_cCodLoc,_nQtde,_cCodEnd,_cCodDoc)
EndIf
RestArea(_aAreaD3)
Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261D3   �Autor  �Hudson de Souza Santos � Data � 31/03/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que define se produto � de consumo ou n�o. Sendo:    ���
���          �B1_LOCPAD = "55" ou (B1_LOCPAD = "01" e B1_TIPO = "MC")     ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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