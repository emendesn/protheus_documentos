#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � XMLPEITE �Autor  �Eneo / Alexandro    � Data �  28/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Deve devolver uma matriz com os campos da SD1 a Incluir no ���
���          � aItens.                                                    ���
���          � Recebe: paramixb onde:                                     ���
���          � 1 - C�digo do produto interno, ja convertido pelo DePara   ���
���          � 2 - oDet - Objeto de Itens do XML                          ���
���          � 3 - i    - indice do Objeto oDet do produto atual          ���
���          � Para checar existencia de TAGs utilizar a vari�vel oXml    ���
���          � que � declarada private, vindo do importaxml.              ���
�������������������������������������������������������������������������͹��
��� Uso      �Exemplo de Ponto de Entrada Incluir campos no aItens do SD1.���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USer Function XMLPEITE()
Local _aArea 		:= GetArea()
Local _aRet  		:= {}                  	//devolver esta matriz
Local _cProduto 	:= paramixb[1]      	//produto
Local _i        	:= paramixb[3]      	//Item corrente
Private _oDet     	:= paramixb[2]      	//Objeto do XML

If Type("_oDet["+Alltrim(STR(_i))+"]:_PROD:_XPED:TEXT" ) <> "U"  
	_cPedCom := _oDet[_i]:_PROD:_XPED:TEXT
	dbSelectArea("Z14")
	dbSetOrder(2)
	If dbSeek(xFilial("Z14")+left(_cPedCom,8))
		aadd(_aRet,{"D1_XCSSNUM",_cPedCom,Nil})
	Endif
Endif

RestArea( _aArea )
Return( _aRet )
