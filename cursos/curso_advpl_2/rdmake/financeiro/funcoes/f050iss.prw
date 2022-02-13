#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050Iss	�Autor	�Edson Rodrigues     � Data �  01/03/08  ���
�������������������������������������������������������������������������͹��
���Desc.	 � GERA TITULO DO ISS										              ���
��� 		 �															                    ���
�������������������������������������������������������������������������͹��
���Uso		 �Especifico BGH    										              ���
�������������������������������������������������������������������������͹��
���Alteracoes�Gravacao do Nome do Fornecedor do titulo	                 ���
��� 		 �				  Original no titulo de ISS                          ���                                      
��� 		 �  				                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/
User Function F050ISS()

Local _aF050ISS := GETAREA()
Local _nRecno := Recno()
Local _cNomFor,_cFilOrig,_ccustd
Local _dVencto,_dVencReal


u_GerA0003(ProcName())
dbGoto(ParamIXB)						//// REGISTRO DO TITULO ORIGINAL
_cFilOrig := SE2->E2_FILORIG
_cNomFor  := SE2->E2_NOMFOR   
_ccustd   := SE2->E2_CCD  

DbGoto(_nRecno)

// Grava Nome do Fornecedor do titulo original no Titulo de ISS
RecLock("SE2",.F.)

SE2->E2_FILORIG   := _cFilOrig
SE2->E2_NOMFOR    := _cNomFor
SE2->E2_CCD       := iif(empty(_ccustd),"3061",_ccustd)  

MsUnLock()

RESTAREA(_aF050ISS)
                                 
Return
//*************************************************************************