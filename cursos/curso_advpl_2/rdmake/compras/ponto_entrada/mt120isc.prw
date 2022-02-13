/*
   Rotina:   Ponto de entrada após a seleção da solicitação de compra no pedido de compra.
   Objetivo: Preencher o campo Divisão de Negócio no PC com dados da SC
   Autor:    Marcelo Munhoz
   Data:     04/09/2013
 
 */
 
user function MT120ISC()

local _nPDivNeg := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_DIVNEG"})
local _nPNumSC  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_NUMSC"})
local _nPItemSC := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_ITEMSC"})
local _aAreaSC1 := SC1->(getarea())

SC1->(dbSetOrder(1)) // C1_FILIAL + C1_NUM + C1_ITEM

for x := 1 to len(aCols)

	if SC1->(dbSeek(xFilial('SC1') + aCols[x,_nPNumSC] + aCols[x,_nPItemSC]))
		aCols[x,_nPDivNeg] := SC1->C1_DIVNEG
	endif

next x

restarea(_aAreaSC1)

return()
