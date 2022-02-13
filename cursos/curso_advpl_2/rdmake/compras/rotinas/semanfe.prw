#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �Vinicius Leonardo  � Data �  19/02/15    ���
�������������������������������������������������������������������������͹��
���Desc.     � 		  													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//-- Cria semaforo para execucao de rotinas via Scheduller
User Function SemaNFE(cRotina, nHdlSemaf, lCria, lProc)

Local lRET := .T.
                     
Default nHdlSemaf := 0                                                  
Default lCria     := .T.
Default lProc	  := .F.

If lProc
	Return .F.
EndIf	 

If lCria
	nHdlSemaf := MSFCreate(cRotina+".LCK")
	IF nHdlSemaf < 0                           
		lRet := .F.
	Endif       
Else
	If File(cRotina+".LCK")
		FClose(nHdlSemaf)
		lRET := .T.
	EndIf
EndIf

Return lRET