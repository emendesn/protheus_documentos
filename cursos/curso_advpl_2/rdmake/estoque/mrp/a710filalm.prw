#include 'rwmake.ch'
#include 'topconn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A710FILALM � Autor � Luciano Siqueira     �Data � 12/03/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para considerar armazens no MRP            ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP - BGH                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function A710FILALM()

Local aArea			:= GetArea()
Local cArmazens		:= Alltrim(aPergs711[32])
Local cProduto		:= paramixb[1]
Local aRet     		:= {}
Local cNewRet 		:= ""
Local cString		:= ""

If !Empty(cArmazens)
	For _nElem	:= 1 To Len(cArmazens)
		cString := SubStr(cArmazens,_nElem,1)
		If cString ==','
			Aadd(aRet,cNewRet)
			cNewRet := ""
		Else
			cNewRet	:=Alltrim(cNewRet)+cString
		Endif
	Next _nElem
	If !Empty(cNewRet)
		Aadd(aRet,cNewRet)	
	Endif
Endif

RestArea(aArea)

Return IIf(Empty(aRet),Nil,aRet)
