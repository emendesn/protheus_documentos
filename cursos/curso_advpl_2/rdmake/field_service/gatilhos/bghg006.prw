#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGHG006   �Autor  �Edson Rodrigues     � Data �  21/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida codigo do produto nas perguntas da entrada e        ���
���          � saida massiva ( x1_grupo = 'BARSZ1'                        ���
�������������������������������������������������������������������������͹��
���Uso       � Validacao chamada do SX1                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGHG006()

Local _aSavArea := GetArea()
Local _lRet 	:= .F.

u_GerA0003(ProcName())

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+mv_par03)
	_lRet := .T.
Else
	MsgAlert("C�digo do produto n�o existe no cadastro!!!! Favor informar o c�digo correto"," Valida��o de Codigo do produto")
EndIf

RestArea(_aSavArea)

Return(_lRet)