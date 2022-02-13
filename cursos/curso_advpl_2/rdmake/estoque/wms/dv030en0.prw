#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV030EN1()    �Autor  �  Edson Estevam   Data �  24/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para mostrar o numero do documento que estᱱ
���          � Em execu��o no coletor antes de solicitar o endereco        ��
���          �                                                             ��
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DV030ENO()

Local aArea     := GetArea()
Local aAreaSDB  := GetArea("SDB")
_cDoc  := SDB->DB_DOC 
_cArm  := SDB->DB_LOCAL 

u_GerA0003(ProcName())

DLVTAviso ("EFETUAR SEPARACAO","ARMAZEM"+ Chr(13) + Chr(10) +Alltrim(_cArm)+Chr(13) + Chr(10) + "DOCUMENTO"+Chr(13) + Chr(10) +Alltrim(_cDoc))
RestArea(aAreaSDB)
RestArea(aArea)

Return 
	