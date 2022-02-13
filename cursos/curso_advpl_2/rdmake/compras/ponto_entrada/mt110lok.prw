/*
   Rotina:   Ponto de entrada de valida��o do item da solicita��o de compras
   Objetivo: Validar a divis�o de neg�cio com a mesma regra do pedido de compras (MT120LOK)
   Autor:    Marcelo Munhoz
   Data:     04/09/2013
 
 */
user function MT110LOK()

local _nPosLoc  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C1_LOCAL" })
local _nPosProd := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C1_PRODUTO" })
local _nPosDivNe:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C1_DIVNEG"})
local _nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C1_ITEM" })

local _lreturn  := .T.

Do Case
   Case (aCols[n,_nPosLoc] $ "80/81" .and. subSTR(aCols[n,_nPosProd],1,2)=="Z-") .and. aCols[n,_nPosdivne]<>"06"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "83/84" .and. subSTR(aCols[n,_nPosProd],1,2)=="B-") .and. (aCols[n,_nPosdivne]<>"05" .AND. aCols[n,_nPosdivne]<>"15" .AND. aCols[n,_nPosdivne]<>"13")
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] == "87" .and. subSTR(aCols[n,_nPosProd],1,2)=="S-") .and. aCols[n,_nPosdivne]<>"07"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   //Incluso essa condi��o para atender os aprelhos ainda movimentados no armaz�m 85 -- Edson Rodrigues 28/09/09   
   Case aCols[n,_nPosLoc] == "85"  .and. aCols[n,_nPosdivne]<>"01"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "01/1A/1B" .and. !subSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"04"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] == "21" .and. !subSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"03"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] == "51" .and. !subSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .and. aCols[n,_nPosdivne]<>"09"
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "70/71/72/73" .and.  aCols[n,_nPosdivne]<>"14")
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "92" .and.  aCols[n,_nPosdivne]<>"15")
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "30/31" .and.  aCols[n,_nPosdivne]<>"16")
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
   Case (aCols[n,_nPosLoc] $ "75" .and.  aCols[n,_nPosdivne]<>"17")
      apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
      _lreturn := .F.
EndCase


return(_lreturn)
