#include 'protheus.ch'
/*
*Programa: TecA0001 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 24/09/12   
*Desc.   : Impressão Etiqueta para Mc Addres                      
*/
User Function TecA0001()	
	Local cPerg		:= "ZZ_TETQMA"
	Local nSeq		:= GetMv("MV_ZZSEQET")
	Local nI		:= 0
	Local nCont		:= 0
	Local nContTot	:= 0
	Local nLin		:= 04
	Local nCol		:= 08
	Local nColBar	:= 5
	Local nCont		:= 0

u_GerA0003(ProcName())
	   
	CriaSX1(cPerg)	
	
	If Pergunte(cPerg, .T.)
		If MsgYesNo("Confirma a geração de "+ StrZero(MV_PAR01,4)+" Etiquetas?")
			nQuant 	:= MV_PAR01
			
			MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.)
			MSCBBEGIN(1,6)
			
			For nI:=1 To nQuant 
				nCont++
				nContTot++
			
				If nCont > 3 
					nLin 	+= 10
					nCol 	:= 08
					nCont 	:= 0
				EndIf
				 
				MSCBSAYBAR(nCol,nLin,"P"+StrZero(nSeq,6),"N","MB07",4,.F.,.F.,.F.,,2,1)
				MSCBSAY(nCol+6 ,nLin+5,"*P"+StrZero(nSeq,6)+"*","N","A","019,012")
				nCol += 26
				nSeq++
				
				If 	nContTot == 6     
					nContTot:= 0
					nCont 	:= 0
					nCol 	:= 08
					nLin 	:= 04
			    	MSCBEnd()
				   	MSCBCLOSEPRINTER()
				   		   	
					MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.)
					MSCBBEGIN(1,6)
				EndIf
			Next
			MSCBEnd()
			MSCBCLOSEPRINTER()

			PutMv('MV_ZZSEQET',nSeq)		    	
		EndIf	
	EndIf	
Return
/*
*Programa: CriaSX1 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 24/09/12   
*Desc.   : Grupo de Perguntas
*/
Static Function CriaSX1(cPerg)
	PutSX1(cPerg,  "01", "Qtde. Etiquetas ?", "Qtde. Etiquetas ?", "Qtde. Etiquetas ?","mv_ch1","N",04, 0, 0, "G","","","","","mv_par01")
Return Nil