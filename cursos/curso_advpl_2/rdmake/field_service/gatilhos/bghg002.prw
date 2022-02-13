#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGHG002   �Autor  �Alexandre Nicoletti � Data �  14/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho responsavel para trazer automaticamente a sequencia���
���          � de atendimento de acordo com a base de atendimento de OS   ���
�������������������������������������������������������������������������͹��
���Uso       � Gatilho no campo AB9_CODTEC                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BGHG002()

Local _cSeq := "01"
Local _aSavArea := GetArea()

u_GerA0003(ProcName())

DbSelectArea("AB9")
DbSetOrder(1) 
If DbSeek(xFilial("AB9")+M->AB9_NUMOS+M->AB9_CODTEC+_cSeq) 
	While AB9->(!Eof()) .and. AB9->AB9_NUMOS == M->AB9_NUMOS .and. AB9->AB9_CODTEC == M->AB9_CODTEC  
		_nSeq := Val(AB9->AB9_SEQ) + 1	
		AB9->(DbSkip())		
	EndDo
	_cSeq := Strzero(_nSeq,2)
Else
	_cSeq := "01"
EndIf

RestArea(_aSavArea) 

Return(_cSeq)