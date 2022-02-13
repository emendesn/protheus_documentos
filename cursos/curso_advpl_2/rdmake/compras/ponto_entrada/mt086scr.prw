#include "protheus.ch"                         	
#include "rwmake.ch"                         	
#include "TOPCONN.ch"


User Function MT086SCR() 
	/*� passado um array com duas dimens�es onde:
	PARAMIXB[1] -> Op��o que foi chamada :
	2 - Visualiza��o
	3 - Inclus�o
	4 - Altera��o
	5 - Exclus�o
	PARAMIXB[2] -> Objeto oDlg que cont�m a dialog da atualiza��o do grupo de compras.
	*/
	
	Local aArea   := GetArea()
	Local nOpcao  := PARAMIXB[1]
	Local cDescri := ' '
	Local lVisual := IIF(nOpcao<>3,.F.,.T.) 

	u_GerA0003(ProcName())
	
	dbSelectArea('SAJ') 
	
	If nOpcao == 3  
		cDescri  := CRIAVAR('AJ_DESCGRP')
	Else
		cDescri  := SAJ->AJ_DESCGRP
	Endif 

	@ 20,90 SAY "Descri��o:" PIXEL OF PARAMIXB[2]  
	@ 18,130 MSGET cDescri Picture '@!' Valid U_TSTVLD(cDescri) When lVisual OF PARAMIXB[2] PIXEL SIZE 90,10 
	
	RestArea(aArea)
Return
	        
	
User Function TSTVLD(cDescri)
	Local nPosDesc := ASCAN(aHeader,{|x|x[2] = 'AJ_DESCGRP'})
	Local nX := 0
	
	For nX:= 1 To Len(aCols) 
		aCols[nX][nPosDesc] := cDescri
	Next 
Return(.T.)           


User Function MT086VLD()
	Local ExpA1 := PARAMIXB[1]
	Local ExpA2 := PARAMIXB[2]
	Local ExpL1 := PARAMIXB[3]   
	Local ExpC1	:= PARAMIXB[4]   
	Local ExpL2 := .T.//Valida��es do usu�rio.Return ExpL2
	Local nPosDesc := ASCAN(aHeader,{|x|x[2] = 'AJ_DESCGRP'})
	Local nX := 0	                       

	if Inclui .or. Altera
		cDescric := aCols[1][nPosDesc] 
		For nX:= 2 To Len(aCols) 
			aCols[nX][nPosDesc] := cDescric
		Next 
	endif       
	
return .T.
		
	