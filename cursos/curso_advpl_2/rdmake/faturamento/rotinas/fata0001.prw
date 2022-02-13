#Include "Totvs.ch"
/*
*Programa: VldSA1CGC 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 07/10/12   
*Desc.   :                       
*/
User Function FatA0001()
	Local lRet	:= .F.

u_GerA0003(ProcName())
    
  	If /*Empty(M->A1_COD_MUN).and.*/ cNivel > 6 .Or. __cInternet == 'AUTOMATICO'
		lRet := .T.	
	EndIf

Return lRet