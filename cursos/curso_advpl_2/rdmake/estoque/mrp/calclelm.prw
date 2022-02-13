#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CALCLELM³ Autor ³ Luciano Siqueira      ³ Data ³ 05/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para corrigir necessidade de acordo com    ±±
±±³          ³ Lote Economico e Qtde Embalagem                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH - Fernando Peratello                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function CALCLELM()

Local aArea		:= GetArea()
Local cModo		:= ""
Local cProduto	:= PARAMIXB[1]
Local nNeces	:= PARAMIXB[2]
Local aQtdAjus	:= aClone(PARAMIXB[3])
Local nx 		:= 0
Local nQuant	:= 0

Local aRet := {}//Customizações do cliente
Local nRet := 0

u_GerA0003(ProcName())

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+cProduto)
	cModo		:= "F"
Else
	cModo		:= "C"
EndIf

For nX := 1 to Len(aQtdAjus)
	nQuant += aQtdAjus[nX]
Next

While nQuant >0
	If !Empty(nB1_LE) .And. nQuant >= nB1_LE
		//aAdd(aRet,nB1_LE)
		nRet += nB1_LE
		nQuant -= nB1_LE
	ElseIf !Empty(If(cModo == "F",nB1_LM,nB1_QE)) .And. nQuant >= IIf(cModo == "F",nB1_LM,nB1_QE)
		//aAdd(aRet,IIf(cModo == "F",nB1_LM,nB1_QE))
		nRet += IIf(cModo == "F",nB1_LM,nB1_QE)
		nQuant -= IIf(cModo == "F",nB1_LM,nB1_QE)
	Else
		nQtdRet := IIf(cModo == "F",nB1_LM,nB1_QE)
		If nQtdRet > 0 
			//aAdd(aRet,nQtdRet)
			nRet +=nQtdRet
		Else	
			//aAdd(aRet,nQuant)
			nRet+=nQuant
		Endif
		nQuant := 0
	EndIf
End

If nRet > 0 
	aAdd(aRet,nRet)
Endif

RestArea(aArea)
Return (aRet)