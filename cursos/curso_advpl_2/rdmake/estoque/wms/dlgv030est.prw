#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'APVT100.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV030SEP    �Autor  �  Edson Estevam   Data �  25/11/11     ���
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

User Function DLGV030EST()

Local aArea     := GetArea()
Local lWmsLote := SuperGetMv('MV_WMSLOTE',.F.,.F.)
Local aAreaSDB  := GetArea("SDB")


u_GerA0003(ProcName())

_cDoc  := SDB->DB_DOC 

DLVTAviso ("FINALIZADO O ITEM ","DOCUMENTO"+ Chr(13) + Chr(10) +Alltrim(_cDoc))


RestArea(aAreaSDB)
RestArea(aArea)


Return .T.
