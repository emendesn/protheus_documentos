#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor  ³ Edson Rodrigues-BGHº Data ³  01/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada durante a montagem do Acols da NFE atravésº±±
±±º          ³ da escolha do Pedido de compra                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function MT103IPC()

local _lRet      := .t.                                                    
local _nPosProd  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD"}) 
local _nPospcomp := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PEDIDO"})
local _nPositpco := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMPC"})
local _nPosdivne := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DIVNEG"})   
local _nPosItem  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEM"  })
local _aAreaSC7  := SC7->(GetArea()) 
local _cdivsc7   := ""

u_GerA0003(ProcName())

for x := 1 to len(aCols)  
   _cdivsc7 := Posicione("SC7",4,xFilial("SC7") + aCols[x,_nPosProd]+aCols[x,_nPospcomp]+aCols[x,_nPositpco], "C7_DIVNEG")
  
  if empty(aCols[x,_nPosdivne]) .and. empty(_cdivsc7) 
	  apMsgStop("Caro usuário, por favor informe a Divisão de negocio do item " + aCols[x,_nPosItem], "Div. Negocio nao Preenchida no Ped. Compra")
	  _lRet := .f.
  Else    
      //Incluso para pegar a  negócio do pedido de compra. Edson Rodrigues - 31/03/09
      aCols[x,_nPosdivne]:=_cdivsc7   
  Endif
Next  
  
restarea(_aAreaSC7)
return(_lRet)