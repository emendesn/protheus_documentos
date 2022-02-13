#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT120OK  บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  25/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na confirmacao do PC para validar TES e   บฑฑ
ฑฑบ          ณ Almoxarifado.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT120OK()

Local _nPosLoc	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_LOCAL" })
Local _nPosTES	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_TES"   })
Local _nPoscam	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_CAMPANH"})
Local _nPosprod	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_PRODUTO" })
Local _nPosItem	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "C7_ITEM" })
Local _lRet		:= .T.
Local _aLocal	:= {}
Local _aTES		:= {}
Local _cfabric	:= ""
Local _carmdist	:= GetMV("MV_ARMCAMP")

u_GerA0003(ProcName())

For x := 1 To Len(aCols)
	If !Empty(aCols[x,_nPosLoc])
		If aCols[x,_nPosLoc] $ _carmdist .and. (Empty(aCols[x,_nPoscam]) .or. aCols[x,_nPoscam] =="00")
			MsgAlert('Favor digitar uma campanha valida para o produto no armazem : ' +aCols[x,_nPosLoc]+  ' , Aten็ใo' )
			_lRet  := .F.
		EndIf
	EndIf
Next x

For x := 1 to len(aCols)
	If !Empty(aCols[x,_nPosLoc]) .and. aScan(_aLocal, aCols[x,_nPosLoc]) <= 0
		aAdd(_aLocal, aCols[x,_nPosLoc])
	EndIf
	If !Empty(aCols[x,_nPosTES]) .and. aScan(_aTES  , aCols[x,_nPosTES]) <= 0
		aAdd(_aTES  , aCols[x,_nPosTES])
	EndIf
Next x

If Len(_aLocal) > 1
	If !apMsgYesNo('Existe mais de 1 almoxarifado informado neste Pedido de Compra. Confirma inclusใo?', 'Almoxarifados diferentes no mesmo PC')
		_lRet := .F.
	EndIf
EndIf

If Len(_aTES) > 1
	If !apMsgYesNo('Existe mais de 1 TES informado neste Pedido de Compra. Confirma inclusใo?', 'TES diferentes no mesmo PC')
		_lRet := .F.
	EndIf
EndIf

For x := 1 To Len(aCols)
	_cfabric := Posicione("SB1",1,xFilial("SB1") + aCols[x,_nPosProd], "B1_FABRIC")
	If !Empty(_cfabric)
		Do Case
			Case  aCols[x,_nPosLoc] $ "80/81" .and. !substr(alltrim(_cfabric),1,8)="MOTOROLA"
				apMsgStop("Caro usuแrio, por favor corrigir o Fabricante ou Arm. Padrao do item " +;
								aCols[x,_nPosItem] +" no Cadastro de Produtos ", "Fabricante ou Arm. Padrao Invalido")
				_lRet := .F.
			Case  aCols[x,_nPosLoc] $ "87/88" .and. !substr(alltrim(_cfabric),1,4)="SONY"
				apMsgStop("Caro usuแrio, por favor corrigir o Fabricante ou Arm. Padrao do item " +;
								aCols[x,_nPosItem] +" no Cadastro de Produtos ", "Fabricante ou Arm. Padrao Invalido")
				_lRet := .F.
		EndCase
	Else
		If  aCols[x,_nPosLoc] $ "80/81"
			apMsgStop("Caro usuแrio, por favor Preencher o Fabricante do item " + aCols[x,_nPosItem]+" no Cadastro de Produtos ", "Fabricante nใo preenchido")
			_lRet := .F.
		EndIf
	EndIf
Next x

Return(_lRet)