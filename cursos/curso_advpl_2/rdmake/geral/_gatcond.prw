#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_GatCond  �Autor  � Graziella Bianchin � Data �  09/11/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para virificacao da condicao de pagamento de acordo��� 
���          � com o que foi preenchido no parametro MV_ZQTDIA.           ���
�������������������������������������������������������������������������͹��
���Altercao  � Inclusao da condicao para nao aceitar pedidos com pagamen- ��� 
���          � to incial de 60 dias.                                      ��� 
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                     
User Function _GatCond()
	Local _cCond	:= Alltrim(M->C5_CONDPAG)
	Local _nQtdDias := Val(ALLTRIM(GetMV("MV_ZQTDIA")))
	Local _cDias	:= POSICIONE("SE4",1,XFILIAL("SE4")+_cCond,"E4_COND") 
	Local _cTipo	:= POSICIONE("SE4",1,XFILIAL("SE4")+_cCond,"E4_TIPO") 
	Local _nDias	:= 0  
	Local nValor 	:= ""
	Local _n60dias  := 0
	Local x			:= 3
	Local y			:= 2
	Local nCont		:= 0
	IncProc()       
u_GerA0003(ProcName())

	//_nDias:= Val(strtran(_cDias,","))   
	For i:= 1 to len(Alltrim(_cDias))  
		//ESSA PROGRAMACAO COMTEMPLA CONDICOES DE PAGAMENTO TIPO 1
		if Alltrim(_cTipo) == '1'
			if Substr(_cDias,i,1) <> ";" .And. Substr(_cDias,i+1,1) <> ";" .And. Substr(_cDias,i+2,1) <> ","
				nValor:= Val(Substr(_cDias,i,x))
				If nValor >= _nQtdDias
					Alert("N�o pode exsitir pedidos com mais de 180 dias!!!! Favor rever a condi��o de pagamento!!!")
					_cCond := "001"   
					i:= len(Alltrim(_cDias))
				Endif
				nCont := x
			Elseif Substr(_cDias,i,1) <> ";" .And. Substr(_cDias,i+1,1) <> ";" .And. Substr(_cDias,i+2,1) == ","
				nValor:= Val(Substr(_cDias,i,y))
				nCont := y
			Endif
		Endif
		i+= nCont
	Next 

	i:= 1

	_n60dias := Val(Substr(_cDias,i,2))

	/*
	if _n60dias >= 60
		Alert("O primeiro pagamento n�o poder� ser realizado em 60 dias!!!!Favor rever a condi��o de pagamento!!!")
		_cCond := "001"
	Endif	*/   
	
	Alert("Esta roina foi descoinuada em 30/10/2012 Favor informar esta ocorr�ncia ao setor de TI")

	
Return(_cCond)