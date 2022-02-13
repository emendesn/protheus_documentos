#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110COR  �Autor  �Hudson de Souza Santos � Data � 28/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto-de-Entrada: MT110COR - Manipula o Array com as regras ���
���          �e cores da Mbrowse                                          ���
�������������������������������������������������������������������������͹��
���Par�metros�PARAMIXB: Array contendo as regras para a apresenta��o das  ���
���          �cores do status do pedido de compras na mbrowse             ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT110COR()
Local aCores2	:= aClone(PARAMIXB[1])
Local aNewCores := {}
Local cEnable	:= ""
Local nX		:= 0
For nX := 1 to Len(aCores2)
	If Alltrim(aCores2[nX,2]) == "ENABLE"
	   	aAdd(aNewCores, { aCores2[nX,1] + " .And.  Empty(C1_DTAPSUP)" ,"CADEADO"})
	   	aAdd(aNewCores, { aCores2[nX,1] + " .And. !Empty(C1_DTAPSUP)" ,aCores2[nX,2]})
	Else
	   	aAdd(aNewCores, aCores2[nX])
	EndIf
Next nX
Return(aNewCores)