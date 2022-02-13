/* 
   Fonte:  AVALCOT.PRW
   Fun��o: Ponto de entrada ap�s gravar cada item do Pedido de Compra criado atrav�s da an�lise da cota��o
           Utilizado para gravar o campo de divis�o de neg�cio da Solicita��o de Compra no Pedido de Compra 
   Autor:  Marcelo Munhoz
   Data:   17/09/2013

*/

user function avalcot()

local _aAreaSC1 := SC1->(getarea())

SC1->(dbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM

if SC1->(dbSeek(xFilial('SC1') + SC7->C7_NUMSC + SC7->C7_ITEMSC))
	reclock('SC7',.f.)
	SC7->C7_DIVNEG	:= SC1->C1_DIVNEG
	SC7->C7_CC			:= SC1->C1_CC 
	msunlock()
endif

restarea(_aAreaSC1)

return()