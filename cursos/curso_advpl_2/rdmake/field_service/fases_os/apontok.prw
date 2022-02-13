#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ APONTOK  ºAutor  ³Uiran Almeida       º Data ³  24/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para validacao dos apontamentos realizados          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function APONTOK(cNumos,cPartNumber)
Local lApont 	:= .T.
Local lGarant	:= .F.
Local lPcEle		:= .F.
Local cArmApont	:= " "
Local cArmEst	:= " "
Local aAreaZZ4   := getArea("ZZ4")
Local aAreaZZJ   := getArea("ZZJ")
Local aAreaSZ9   := getArea("SZ9")
Local aAreaSB1   := getArea("SB1")

DbSelectArea("ZZ4")
DbSetOrder(11) 			// ZZ4_FILIAL+ZZ4_OS+ZZ4_IMEI
ZZ4->(dbSeek(xFilial("ZZ4")+ cNumos))

DbSelectarea("ZZJ")
ZZJ->(dbSetOrder(1))	// ZZJ_FILIAL+ZZJ_OPERA+ZZJ_LAB
ZZJ->(dbseek(xFilial("ZZJ")+Alltrim(ZZ4->ZZ4_OPEBGH)))

DbSelectarea("SZ9")
SZ9->(dbSetOrder(4))  	// Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
If(SZ9->(dbSeek(xFilial("SZ9") + cNumos)))
	If !Empty(Alltrim(SZ9->Z9_PARTNR))
		cArmApont := ( Alltrim(SZ9->Z9_LOCAL) )
	EndIf
EndIf

DbSelectarea("SB1")
SB1->(dbSetOrder(1)) 	// B1_FILIAL+B1_COD
SB1->(dbSeek(xFilial("SB1")+ cPartNumber))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recebe os dados para a validacao ! ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Peca Eletrica ?
If ( SB1->B1_XMECELE == "E" )
	lPcEle = .T.
EndIf

//Radio em Garantia ?
lGarant  := IiF( Iif( ZZJ->ZZJ_CALGAR == "S",ZZ4->ZZ4_GARMCL,ZZ4->ZZ4_GARANT) == "S" , .T. , .F. )

// Armazem apontado x Armazem de estoque !
cArmApont := Alltrim(SZ9->Z9_LOCAL)
cArmEst   := IiF( lGarant ,ZZJ->ZZJ_ARMEST,ZZJ->ZZJ_ARMESF)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio das Validacoes              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If(Empty(SZ9->Z9_NUMSEQP) .And. !Empty(ZZJ->ZZJ_COLEST))
	lApont := .F.
Else
	//Armazens
	If ( lApont .And. (Alltrim(cArmApont) <> Alltrim(cArmEst)) )
		lApont := .F.
	EndIf
	//Garantia?
	If(lApont .And. lGarant)
		//Peca eletrica?
		If(lApont .And.	lPcEle .And. (Alltrim(ZZJ->ZZJ_PNELE)=="F")	)
			lApont := .F.
		EndIf
		//Coletor
		If( lApont .And. !Empty(SZ9->Z9_NUMSEQP) .And. ( Alltrim(ZZJ->ZZJ_COLEST) == "F") )
			lApont := .F.
		EndIf
	Else
		//Peca Eletrica
		If( lApont .And. lPcEle .And. (Alltrim(ZZJ->ZZJ_PNELE)=="G") )
			lApont := .F.
		EndIf
		//Apontamento coletor
		If( lApont .And. !Empty(SZ9->Z9_NUMSEQP) .And. ( Alltrim(ZZJ->ZZJ_COLEST) == "G"))
			lApont := .F.
		EndIf
	EndIf
EndIf



RestArea(aAreaZZ4)
RestArea(aAreaZZJ)
RestArea(aAreaSZ9)
RestArea(aAreaSB1)

Return lApont

