#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050IRF   �Autor  �Edson Rodrigues     � Data �  01/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � GERA TITULO DE IRRF                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico BGH                                              ���
�������������������������������������������������������������������������͹��
���Alteracoes� Gravacao do Nome do Fornecedor do titulo                   ���
���          � Original no titulo de IRRF                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F050IRF()     

Local _aF050IRF := GETAREA()
Local _nRecno := Recno()
Local _cNomFor
Local _ccustd

u_GerA0003(ProcName())

dbGoto(ParamIXB)						//// REGISTRO DO TITULO ORIGINAL
_cFilOrig := SE2->E2_FILORIG
_cNomFor  := SE2->E2_NOMFOR
_ccustd   := SE2->E2_CCD
DbGoto(_nRecno)

// Grava Nome do Fornecedor do titulo original no Titulo de IRRF
RecLock("SE2",.F.)
SE2->E2_FILORIG   := _cFilOrig
SE2->E2_NOMFOR    := _cNomFor  
SE2->E2_CCD       :=iif(empty(_ccustd),"3061",_ccustd)
MsUnLock()

RESTAREA(_aF050IRF)
Return
//*************************************************************************