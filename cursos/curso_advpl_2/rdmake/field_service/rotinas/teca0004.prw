#include 'Totvs.ch'
#Include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"
/*
*Programa: TecA0004 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 29/10/12   
*Desc.   : Impressão Etiqueta Magazines                     
*/
User Function TecA0004(cCODSET, cFasOri, cCODSE2,cFasDest, cIMEI,cLab)	
    Local aAreaZZ4 	:= ZZ4->(GetArea())                                         
    Local aAreaZZ1 	:= ZZ1->(GetArea()) 
    Local aAreaSA1 	:= SA1->(GetArea()) 
    Local cCarcaca 	:= ''
    Local cClassif	:= ''
    Local cTes		:= ''
    Local cModelo	:= ''
    Local cCodCli	:= ''
    Local cLojCli	:= ''
    Local cAlias 	:= ''
    Local cInform	:= ''
	Local cOper		:= ''    
    Local lImpMod	:= GetMv("MV_MODPOS")  
	
u_GerA0003(ProcName())
    
    If	SubStr(cFasOri,1,2) 		$ 	('02/10/12/16/08/09/14/17/18/19/20/21/22/30') .And. ;
		SubStr(cFasDest,1,2) 		== 	'07'

		cAlias 	:= GetNextAlias()
	                       
		BeginSql Alias cAlias			
			Select TOP 1 ZZ4.*  
			From %Table:ZZ4% ZZ4
			Where
				ZZ4_FILIAL 		= %xFilial:ZZ4% 
				And ZZ4_IMEI 	= %Exp:cIMEI% 
			   	And ZZ4_OPEBGH 	In ('P02','P03','P06')
				And ZZ4_NFSNR 	= ' ' 
				And ZZ4.%NotDel%
		EndSql
		
		If (cAlias)->(EoF())
			(cAlias)->(dbCloseArea())
			Return	
		EndIf
		
		cCodCli  := (cAlias)->ZZ4_CODCLI
		cLojCli  := (cAlias)->ZZ4_LOJA
		cCarcaca := (cAlias)->ZZ4_CARCAC
		cModelo  := Alltrim((cAlias)->ZZ4_CODPRO)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1") + (cAlias)->ZZ4_CODPRO,"B1_DESC"))
		cOper    := Alltrim((cAlias)->ZZ4_OPEBGH)
		(cAlias)->(dbCloseArea())  
				
		DbSelectArea("ZZ1")
		ZZ1->(dbSetOrder(1))//ZZ1_FILIAL+ZZ1_LAB+ZZ1_CODSET+ZZ1_FASE1
		ZZ1->(dbSeek(xFilial('ZZ1') + cLab + SubStr(cCODSET,1,6) + SubStr(cFasOri,1,2) ))		
        
  		cClassif := SubStr(ZZ1->ZZ1_DESFA1,At('/',ZZ1->ZZ1_DESFA1)+1,20)
		
		Do Case 
			Case SubStr(cFasOri,1,2) $ '02/17'
				cTes 	 := '727'
				If SubStr(cFasOri,1,2) = '02' 
					cClassif := ''
				EndIf
			Case SubStr(cFasOri,1,2) $ '10/18/19'
				cTes := '880'
				If SubStr(cFasOri,1,2) $ '10'  
					cInform := 'SALDO'
				EndIf
			Case SubStr(cFasOri,1,2) $ '12/16/20'
				cTes := '904'
			Case SubStr(cFasOri,1,2) $ '08/09/21'
				cTes := '729'
			Case SubStr(cFasOri,1,2) $ '14/22/30'
				cTes := '765'
				If SubStr(cFasOri,1,2) $ '14'
					cInform := 'DSR'
				EndIf
				If SubStr(cFasOri,1,2) $ '30'
					cInform := 'MUD'
				EndIf
		EndCase
		
		dbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCodCli+cLojCli))
		cMagazin := AllTrim(SA1->A1_NOME)
		&&Impressão Etiqueta
		TecA004A(cMagazin, SA1->A1_MUN, SA1->A1_EST, cIMEI, cTes, cCarcaca,cClassif, cInform, cModelo, cOper, lImpMod)
	EndIf
	
	RestArea(aAreaSA1)
	RestArea(aAreaZZ1)
	RestArea(aAreaZZ4)
Return 
 
/*
*Programa: TecA004A 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 29/10/12   
*Desc.   : Impressão Etiqueta                     
*/
Static Function TecA004A(cMagazin, cMun, cEst, cIMEI, cTes, cCarcaca, cClassif, cInform, cModelo, cOper, lImpMod)
	Local nX
	Local aLin := {03,015,27,39,51,60}
	Local aCol := {03,32,55,65,75,81,115}  
	Local aFont:={"070,070","080,080","090,090","100,100","110,110","130,130","150,150","200,200","280,280"}
	
	MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)  
	                
	MSCBChkStatus(.F.)
	
	MSCBBEGIN(1,6,144)            

	MSCBSAY(aCol[1],aLin[1], 'Cliente'		   						,"N","0",aFont[3])
	MSCBSAY(aCol[2],aLin[1], ': '+AllTrim(cMagazin)					,"N","0",aFont[3])
	MSCBSAY(aCol[1],aLin[2], 'Mun./UF.'				 				,"N","0",aFont[3]) 
	MSCBSAY(aCol[2],aLin[2], ': '+AllTrim(cMun)+'/'+cEst			,"N","0",aFont[3])
	
	//Alterado 
	If Alltrim(cOper) == 'P06'
		MSCBSAY(aCol[7],aLin[2], '- FOG -'			,"N","0",aFont[3])		
	EndIf
	
	If !Empty(cClassif)  
		MSCBSAY(aCol[1],aLin[3], 'Status'								,"N","0",aFont[3])
		MSCBSAY(aCol[2],aLin[3], ': '+cClassif							,"N","0",aFont[3])
		/*
		MSCBSAY(aCol[1],aLin[4], 'TES'									,"N","0",aFont[3]) 
		MSCBSAY(aCol[2],aLin[4], ': '+cTes								,"N","0",aFont[3])
		*/
		MSCBSAY(aCol[3]+80,aLin[3], 'TES: '+cTes						,"N","0",aFont[3]) 
	Else
		MSCBSAY(aCol[1],aLin[3], 'TES'									,"N","0",aFont[3]) 
		MSCBSAY(aCol[2],aLin[3], ': '+cTes								,"N","0",aFont[3])
	EndIf
	      
	If lImpMod
		MSCBSAY(aCol[1],aLin[4], 'Modelo'									,"N","0",aFont[3]) 
		MSCBSAY(aCol[2],aLin[4], ': '+cModelo								,"N","0",aFont[3])
	EndIf
	
	If AllTrim(cIMEI) == AllTrim(cCarcaca)
		MSCBSAY(aCol[1]+02,aLin[6], cInform							,"N","0",IIF(cInform =='DOA',aFont[9],aFont[8]))           
		MSCBSAY(aCol[3]+80,aLin[6], cInform							,"N","0",IIF(cInform =='DOA',aFont[9],aFont[8]))
		MSCBSAY(aCol[3]+15,aLin[5], 'Serial Number'					,"N","0",aFont[3])           
		MSCBSAYBAR(aCol[4]-6,aLin[6], AllTrim(cIMEI)				,"N","MB07",18,.F.,.T.,.F.,NIL,6)
	Else
		MSCBSAY(aCol[1]+16,aLin[5], 'Serial Number'					,"N","0",aFont[3]) 
		MSCBSAYBAR(aCol[1]+5,aLin[6], AllTrim(cIMEI)				,"N","MB07",18,.F.,.T.,.F.,NIL,6)
		If !Empty(cCarcaca)                                                                
			MSCBSAY(aCol[7]+8,aLin[5], 'Etiqueta Lacre'				,"N","0",aFont[3]) 
			MSCBSAYBAR(aCol[7]-5,aLin[6], AllTrim(cCarcaca)			,"N","MB07",18,.F.,.T.,.F.,NIL,6)
		EndIf
	EndIf

	MSCBEND()
	MSCBCLOSEPRINTER()                                                            
Return