#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A240WMSO  �Autor  �Edson Estevam- Delta� Data �  01/11/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na movimenta��o interna p/ nao exibir     ���
���          � a tela de endere�o Destino e Estrutura Fisica              ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/           
User Function A240WMSO()
Local aArea    := GetArea()
Local cRadio   := GetMv("MV_RADIOF")
Local _cEndDest:= Getmv("MV_XENDDES")
Local _cEstFis := GetMv("MV_XESTFIS")
Local _aReturn := {}                

u_GerA0003(ProcName())


_cEndDest := Alltrim(_cEndDest)
_cEndDest := _cEndDest + Space(15-Len(_cEndDest))

AAdd(_aReturn,_cEndDest)
AAdd(_aReturn,_cEstFis)



RestArea(aArea)

Return (_aReturn)