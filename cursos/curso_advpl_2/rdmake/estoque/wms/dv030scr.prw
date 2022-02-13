
#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'APVT100.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV030SCR()    �Autor  �  Edson Estevam   Data �  24/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para mostrar o numero do documento que estᱱ
���          � Em execu��o no coletor                                      ��
���          �                                                             ��
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DV030SCR()

Local aArea     := GetArea()
Local lWmsLote := SuperGetMv('MV_WMSLOTE',.F.,.F.)
Local aAreaSDB  := GetArea("SDB")

u_GerA0003(ProcName())

_cDoc  := SDB->DB_DOC 
_cArm  := SDB->DB_LOCAL 
DLVTAviso ("VOCE ESTA SEPARANDO","ARMAZEM"+ Chr(13) + Chr(10) +Alltrim(_cArm)+Chr(13) + Chr(10) + "DOCUMENTO"+Chr(13) + Chr(10) +Alltrim(_cDoc))
RestArea(aAreaSDB)
RestArea(aArea)

Return .T.
	