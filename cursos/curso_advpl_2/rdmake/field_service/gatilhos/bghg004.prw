#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 12/11/01

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BGHG004  �Autor  � Antonio Gendra     � Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BGHG004()

Local _lFlag    := .T.
Local _aSavArea := GetArea()
Local _cSN      := M->AB9_SN
Local _cNumOs	:= ""

u_GerA0003(ProcName())

DbSelectArea("AB2")
DbSetOrder(5)  // AB2_FILIAL + AB2_NUMSER 
If DbSeek(xFilial("AB2")+_cSN)	
	While AB2->(!Eof()) .and. xFilial("AB2") == AB2->AB2_FILIAL .and. AB2->AB2_NUMSER == _cSN 
		_cNumOs  := Substring(AB2->AB2_NUMOS,1,6)
		AB2->(DbSkip())
    EndDo
EndIf                              

_aSavZZ4 := GetArea()
DbSelectArea("ZZ4")
DbSetOrder(1)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
//If DbSeek(xFilial("ZZ4")+_cSN+_cNumOs) 
If DbSeek(xFilial("ZZ4")+_cSN+left(M->AB9_NUMOS,6)) 
	if ZZ4->ZZ4_STATUS < "3"
		_lFlag := .F.
		MsgStop("Antes de efetuar o atendimento � necess�ria a digita��o do Documento de Entrada")
	elseif ZZ4->ZZ4_STATUS > "5"
		_lFlag := .F.
		MsgStop("A OS '"+_cNumOs+"' j� est� em processo de encerramento e n�o poder� sofrer atendimentos.")
	endif
EndIf

DbSelectArea("ZZ4")
RestArea(_aSavZZ4) 
               
Return(_lFlag)