#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGHG003   �Autor  �Alexandre Nicoletti � Data �  07/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida codigo e loja do cliente nas perguntas da entrada e ���
���          � saida massiva ( x1_grupo = 'BARSZ1' e 'SAISZ1'             ���
�������������������������������������������������������������������������͹��
���Uso       � Validacao chamada do SX1                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGHG003()

Local _aSavArea := GetArea()
Local _lRet 	:= .F.

u_GerA0003(ProcName())

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+mv_par01+mv_par02)
	_lRet := .T.
Else
	MsgAlert("C�digo n�o existe no cadastro!!!! Favor informar o c�digo correto"," Valida��o de Codigo de Cliente e loja")
EndIf

RestArea(_aSavArea)

Return(_lRet)