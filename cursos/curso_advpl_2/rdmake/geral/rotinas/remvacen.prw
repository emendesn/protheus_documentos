#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��        
���Programa  �REMVACEN  � Autor � Edson Rodrigues    � Data �  MAIO /08   ���
�������������������������������������������������������������������������͹��
���Descricao � Prgrama para remover acento do Cadastro de                 ���
���          �    da Descricao das Contas Contabeis                       ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User function REMVACEN()


PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" TABLES "CT1"
cnewdesc  :=""  
Private aAlias  := {"CT1"}  
                   

dbSelectArea("CT1")
DbSetOrder(1) //CT1_FILIAL+CT1_CONTA

CT1->(dbgotop())
While !CT1->(eof())
  cnewdesc:=u_tiraacento(ALLTRIM(CT1->CT1_DESC01))
  IF !EMPTY(cnewdesc)
  	RecLock('CT1',.F.)
	CT1->CT1_FILIAL   :=  xFilial('CT1') 
	CT1->CT1_DESC01   :=  cnewdesc
	MsUnLock('CT1') 
  ENDIF          
  
CT1->(dbSkip())  
ENDDO

RETURN                                                

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��        
���Programa  �REMVACE2  � Autor � Edson Rodrigues    � Data �  MAIO /08   ���
�������������������������������������������������������������������������͹��
���Descricao � Prgrama para remover acento do Cadastro de                 ���
���          �    da Reclamacoes de defeito do Cliente                    ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User function REMVACE2()                                        


PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" TABLES "ZZG"
cnewdesc  :=""  
Private aAlias  := {"ZZG"}  
                   

dbSelectArea("ZZG")
DbSetOrder(1) //ZZG_FILIAL+ZZG_LAB+ZZG_CODIGO

ZZG->(dbgotop())
While !ZZG->(eof())
  cnewdesc:=u_tiraacento(ALLTRIM(ZZG->ZZG_DESCRI))
  IF !EMPTY(cnewdesc)
  	RecLock('ZZG',.F.)
	ZZG->ZZG_FILIAL   :=  xFilial('ZZG') 
	ZZG->ZZG_DESCRI   :=  cnewdesc
	MsUnLock('ZZG') 
  ENDIF          
  
ZZG->(dbSkip())  
ENDDO

RETURN