#include "rwmake.ch"
User Function M415CANC()
/*Ponto de Entrada na Exclusao do Orcamento para validar se
o usuario informou o motivo do cancelamento do orcamento */
Local nret  	:= 1
Local aArea 	:= GetArea()
Private cPerg 	:= "XMOTCOR"
DbSelectArea("SCJ")
If FieldPos("CJ_XMOTCAN") > 0 .AND. Empty(M->CJ_XMOTCAN)
	fCriaSX1(cPerg)
	If Pergunte(cPerg, .T.)
		RecLock("SCJ",.F.)
		SCJ->CJ_XMOTCAN := MV_PAR01
		MSUNLOCK()
	EndIf
EndIF
RestArea(aArea)
return nRet
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCRIASX1  � Autor �Paulo Lopez         � Data �  14/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao �GERA DICIONARIO DE PERGUNTAS                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fCriaSX1(cPerg)

//���������������������������������������������������������������������Ŀ
//|Declaracao de variaveis                                              �
//�����������������������������������������������������������������������
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}


u_GerA0003(ProcName())

PutSX1(cPerg,"01","Motivo Cancelamento Orcamento : ","","","mv_ch1","C",06,0,0,"G","","ZW"  ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")


cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Motivo Cancelamento Orcamento .")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return