#include 'rwmake.ch'
#include 'protheus.ch'
#include 'totvs.ch'

Static cVarTes 
Static cVarCC
Static cVarArm
Static cVarDiv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100CLAบAutor  ณVinicius Leonardo   บ Data ณ  19/09/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para antes da						      บฑฑ
ฑฑบ          ณ classifica็ใo da Nota de Entrada                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT100CLA()

Local oBmp
Local oFnt1 
Local cStartPath 
Local oV1
Local oV2  
Local oV3
Local oV4 
Local oDlg 
    
	cVarTes := Space(3)
	cVarCC	:= Space(9) 
	cVarArm := Space(2)
	cVarDiv	:= Space(2)
	oFnt1 := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)
	cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97()) 	
	  
	@ 0,0 TO 295,300 DIALOG oDlg TITLE "Informa็๕es para Entrada"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg)
	
	@ 25,010 SAY oV1 var "TES:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 35,010 GET cVarTes Size 100,080 PICTURE "@!" valid ExistCPO("SF4",cVarTES) .AND. cVarTES<"500"  F3 "SF4"
	
	@ 50,010 SAY oV2 var "Centro de Custo:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 60,010 GET cVarCC Size 100,080 PICTURE "@!" valid ExistCPO("CTT",cVarCC) F3 "CTT" 
	
	@ 75,010 SAY oV3 var "Armazem" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 85,010 GET cVarArm Size 100,080 PICTURE "@!" valid ExistCPO("NNR",cVarArm) F3 "NNR" 
	
	@ 100,010 SAY oV4 var "Div. Negocio:" of oDlg FONT oFnt1 PIXEL SIZE 150,010 COLOR CLR_BLUE
	@ 110,010 GET cVarDiv Size 100,080 PICTURE "@!" valid  EXISTCPO("SX5","ZM"+cVarDiv) F3 "ZM" 
	
	@ 130,085 BMPBUTTON TYPE 1 ACTION Processa({|lEnd| oDlg:End()})
	@ 130,120 BMPBUTTON TYPE 2 ACTION oDlg:End()                               

	Activate MSDialog oDlg Centered 

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103CLASบAutor  ณVinicius Leonardo   บ Data ณ  19/09/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada que manipula o aCols na					  บฑฑ
ฑฑบ          ณ classifica็ใo da Nota de Entrada			                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A103CLAS()  
	For nx:=1 To Len (aHeader)
		If Trim(aHeader[nx][2]) == "D1_TES"
			aCols[Len(aCols)][nx] := cVarTes
		EndIf 
		If Trim(aHeader[nx][2]) == "D1_CC"
			aCols[Len(aCols)][nx] := cVarCC
		EndIf 
		If Trim(aHeader[nx][2]) == "D1_LOCAL"
			aCols[Len(aCols)][nx] := cVarArm
		EndIf
		If Trim(aHeader[nx][2]) == "D1_DIVNEG"
			aCols[Len(aCols)][nx] := cVarDiv
		EndIf
	Next nx
Return                                             