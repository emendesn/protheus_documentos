#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XMLPEITE บAutor  ณEneo / Alexandro    บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Deve devolver uma matriz com os campos da SD1 a Incluir no บฑฑ
ฑฑบ          ณ aItens.                                                    บฑฑ
ฑฑบ          ณ Recebe: paramixb onde:                                     บฑฑ
ฑฑบ          ณ 1 - C๓digo do produto interno, ja convertido pelo DePara   บฑฑ
ฑฑบ          ณ 2 - oDet - Objeto de Itens do XML                          บฑฑ
ฑฑบ          ณ 3 - i    - indice do Objeto oDet do produto atual          บฑฑ
ฑฑบ          ณ Para checar existencia de TAGs utilizar a variแvel oXml    บฑฑ
ฑฑบ          ณ que ้ declarada private, vindo do importaxml.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso      ณExemplo de Ponto de Entrada Incluir campos no aItens do SD1.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
