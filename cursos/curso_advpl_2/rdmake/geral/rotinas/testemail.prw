#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/04/00
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��        
���Programa  �TESTEMAIL � Autor � Edson Rodrigues    � Data �  MARC/09    ���
�������������������������������������������������������������������������͹��
���Descricao � Prgrama para testar o envio de e-mail                      ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User function TESTEMAIL()      

SLEEP(180)
                                              
ConOut("*")
ConOut("*")
ConOut("*")
ConOut(Replicate("*",40)) 
ConOut("   [INTARG] - "+dtoc(date())+" "+time()) 
ConOut("   [INTARG] Montando ambiente Enviroment empresa/filial 02/02...")


PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "SD1","SD2","SC5","SC6","SF1","SD1","SB1","SBM","SA1","SX5","SA3","SC9","SC7","SZI","SZJ","ZZH"                    
ctitulo := "teste"
cDestina := "edson.rodrigues@bgh.com.br"
cCco := ""
cMensagem := " Teste de envio de e-mail "
Path := "172.16.0.7"

U_ENVIAEMAIL(cTitulo,cDestina,cCco,cMensagem,Path)



Return