#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CALCLELM� Autor � Luciano Siqueira      � Data � 05/10/12  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para corrigir necessidade de acordo com    ��
���          � Lote Economico e Qtde Embalagem                             ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH - Fernando Peratello                                   ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function CALCLELM()

Local aArea		:= GetArea()
Local cModo		:= ""
Local cProduto	:= PARAMIXB[1]
Local nNeces	:= PARAMIXB[2]
Local aQtdAjus	:= aClone(PARAMIXB[3])
Local nx 		:= 0
Local nQuant	:= 0

Local aRet := {}//Customiza��es do cliente
Local nRet := 0

u_GerA0003(ProcName())

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+cProduto)
	cModo		:= "F"
Else
	cModo		:= "C"
EndIf

For nX := 1 to Len(aQtdAjus)
	nQuant += aQtdAjus[nX]
Next

While nQuant >0
	If !Empty(nB1_LE) .And. nQuant >= nB1_LE
		//aAdd(aRet,nB1_LE)
		nRet += nB1_LE
		nQuant -= nB1_LE
	ElseIf !Empty(If(cModo == "F",nB1_LM,nB1_QE)) .And. nQuant >= IIf(cModo == "F",nB1_LM,nB1_QE)
		//aAdd(aRet,IIf(cModo == "F",nB1_LM,nB1_QE))
		nRet += IIf(cModo == "F",nB1_LM,nB1_QE)
		nQuant -= IIf(cModo == "F",nB1_LM,nB1_QE)
	Else
		nQtdRet := IIf(cModo == "F",nB1_LM,nB1_QE)
		If nQtdRet > 0 
			//aAdd(aRet,nQtdRet)
			nRet +=nQtdRet
		Else	
			//aAdd(aRet,nQuant)
			nRet+=nQuant
		Endif
		nQuant := 0
	EndIf
End

If nRet > 0 
	aAdd(aRet,nRet)
Endif

RestArea(aArea)
Return (aRet)