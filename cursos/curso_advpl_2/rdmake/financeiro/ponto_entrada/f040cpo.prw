#include 'topconn.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F040CPO  �Autor  � E.Rodrigues - BGH  � Data �  05/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adicionar campos que podem ser       ���
���          � alterarados no Contas a Receber                            ���
�������������������������������������������������������������������������͹��
���Alteracoes�                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                      
user function F040CPO()

u_GerA0003(ProcName())
                       
    _aadccpo:={}
    
    Aadd(_aadccpo,"E1_CCD")    
    Aadd(_aadccpo,"E1_PREFIXO")  
    Aadd(_aadccpo,"E1_NATUREZ")
	Aadd(_aadccpo,"E1_VENCTO")
	Aadd(_aadccpo,"E1_VENCREA")
	Aadd(_aadccpo,"E1_HIST")
	Aadd(_aadccpo,"E1_INDICE")
	Aadd(_aadccpo,"E1_OP")
	Aadd(_aadccpo,"E1_VALJUR")
	Aadd(_aadccpo,"E1_PORCJUR")
	Aadd(_aadccpo,"E1_OCORREN")
	Aadd(_aadccpo,"E1_INSTR1")
	Aadd(_aadccpo,"E1_INSTR2")
	Aadd(_aadccpo,"E1_NUMBCO")
	Aadd(_aadccpo,"E1_IRRF")
	Aadd(_aadccpo,"E1_ISS")
	Aadd(_aadccpo,"E1_FLUXO")
	Aadd(_aadccpo,"E1_INSS")
	Aadd(_aadccpo,"E1_PIS")
	Aadd(_aadccpo,"E1_COFINS")
	Aadd(_aadccpo,"E1_CSLL")
	Aadd(_aadccpo,"E1_ACRESC")
	Aadd(_aadccpo,"E1_DECRESC")
	Aadd(_aadccpo,"E1_DIADESC")
	Aadd(_aadccpo,"E1_DESCFIN")   

return(_aadccpo)