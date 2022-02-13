#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050CSL   �Autor  �Edson Rodrigues     � Data �  01/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava Nome do Fornecedor no Titulo de CSLL                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������͹��
���Alteracoes�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/
User Function F050CSL()

Local _aF050CSL := GetArea()
Local _nRecno := Recno()
Local _cNomFor,_cFilOrig,_ccustd

u_GerA0003(ProcName())

dbGoto(ParamIXB)                        //// REGISTRO DO TITULO ORIGINAL
_cFilOrig := SE2->E2_FILORIG
_cNomFor  := SE2->E2_NOMFOR
_ccustd   := SE2->E2_CCD
DbGoto(_nRecno)

// Grava Nome do Fornecedor do titulo original no Titulo de COFINS
RecLock("SE2",.F.)
SE2->E2_FILORIG   := _cFilOrig
SE2->E2_NOMFOR    := _cNomFor   
SE2->E2_CCD       :=iif(empty(_ccustd),"3061",_ccustd)
MsUnLock()

RESTAREA(_aF050CSL)
Return
//*************************************************************************