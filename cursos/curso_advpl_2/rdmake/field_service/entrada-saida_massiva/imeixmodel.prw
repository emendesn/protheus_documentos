/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMEIXMODELบAutor  ณHudson de Souza Santos บ Data ณ 20/11/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte qiue valida o IMEI pelo modeo do aparelho de acordo   บฑฑ
ฑฑบ          ณcom a mแscara do cadastro de produtos B1_MASK 1 2 3         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IMEIxModel(cParam, cParam1,ctipo)
Local lRet		:= .F.
Local aArea		:= GetArea()
Local aAreaSB1	:= GetArea("SB1")
Local cMask1	:= ""
Local cMask2	:= ""
Local cMask3	:= ""
Local cTipo 	:= IIF(cTipo==NIL,"I",cTipo)

//cParam - IMEI ou Carca็a
//cParam1 - Modelo ou Opera็ใo
//cTipo - I = IMEI, C=CARCACA

If cTipo <> "C"
	If Empty(cParam) .OR. Empty(cParam1)
		lRet := .T.
	Else
		cParam := right(Space(20)+Alltrim(cParam),20)
	EndIf
	If !lRet
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+cParam1)
			cMask1	:= right(Space(20)+Alltrim(SB1->B1_MASK1),20)
			cMask2	:= right(Space(20)+Alltrim(SB1->B1_MASK2),20)
			cMask3	:= right(Space(20)+Alltrim(SB1->B1_MASK3),20)
		EndIf
	EndIf
	If !lRet .AND. Empty(cMask1) .AND. Empty(cMask2) .AND. Empty(cMask3)
		lRet := .T.
	EndIf
	If !lRet .AND. !Empty(cMask1) .AND. ValCarac(cMask1, cParam, cTipo)
		lRet := .T.
	EndIf
	If !lRet .AND. !Empty(cMask2) .AND. ValCarac(cMask2, cParam, cTipo)
		lRet := .T.
	EndIf
	If !lRet .AND. !Empty(cMask3) .AND. ValCarac(cMask3, cParam, cTipo)
		lRet := .T.
	EndIf
Else
	If Empty(cParam) .OR. Empty(cParam1)
		lRet := .T.
	Else
		cParam := left(cParam+Space(25),25)
	EndIf
	If !lRet
		dbSelectArea("ZZJ")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZJ")+cParam1)
			cMask1	:= left(ZZJ->ZZJ_MASCAR+Space(25),25)
		EndIf
	EndIf
	If !lRet .AND. Empty(cMask1)
		lRet := .T.
	EndIf
	If !lRet .AND. !Empty(cMask1) .AND. ValCarac(cMask1, cParam, cTipo)
		lRet := .T.
	EndIf

Endif
RestArea(aAreaSB1)
RestArea(aArea)
Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValCarac  บAutor  ณHudson de Souza Santos บ Data ณ 20/11/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte que valida o IMEI de acordo com a mแscara encontrada  บฑฑ
ฑฑบ          ณno cadstro de produto.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValCarac(cMask, cParam, cTipo)
Local lVal := .T.
Local nI := 0
If Len(cMask) <> Len(cParam)
	If cTipo <> "C"
		Alert("Tamanho da mแscara diferente do tamanho do Imei")
	Else
		Alert("Tamanho da mแscara diferente do tamanho da Carca็a")
	Endif
	lVal := .F.
EndIf

For nI := 1 to Len(cMask)
	If !lVal
		Exit
	EndIf
	If SubSTR(cMask, nI, 1) <> "*" .AND. SubSTR(cMask, nI, 1) <> SubSTR(cParam, nI, 1)
		If cTipo <> "C"
			Alert("Imei nใo compativel com a mascara do Produto")
		Else
			Alert("Carca็a nใo compativel com a mascara da Opera็ใo")
		Endif
		lVal := .F.
	EndIf
Next nI
Return(lVal)