#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TITICMST  �Autor  �Fabio Nascimento    � Data �  01/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA PARA ATUALIZAR DATA DE VENCIMENTO         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINANCEIRO                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                                                                                                                 

User Function TITICMST()

Local cRotina := PARAMIXB[1] 

u_GerA0003(ProcName())


	//If AllTrim(cRotina) == 'MATA460A'

		SE2->E2_VENCREA :=  dDataBase 
		SE2->E2_VENCTO  :=  dDataBase 
    	SE2->E2_HIST	:=  "GNRE NF: " +SF2->F2_DOC
		//SE2->E2_NUM     :=  SF2->F2_DOC	
           
	//Endif

Return (SE2->E2_HIST,SE2->E2_NUM,SE2->E2_VENCREA,SE2->E2_VENCTO)