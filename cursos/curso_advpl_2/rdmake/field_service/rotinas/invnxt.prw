#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'  
#include "tbiconn.ch" 
#define ENTER CHR(10)+CHR(13)

Static cDataAux
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVPNXT	บAutor  ณVinicius Leonardo   บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inventแrio Nextel					                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function INVPNXT()  
	U_INVNXT(.T.)
Return

User Function INVENXT()
	U_INVNXT(.F.)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function INVNXT(lProd)   

Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690")   
Local cInv		:= SuperGetMv("BH_FMSTINV",,"")

Private cCadastro	:= "Inventario Nextel"
Private aCores		:= {}
Private aRotina		:= {} 

If cInv == "F" .and. !(__cUserId $ cUserExc)
	MsgStop("Permitido o acesso somente com a autoriza็ใo do gestor.","Acesso negado","STOP")
	Return
EndIf

aAdd(aRotina, {"Pesquisar"	,"AxPesqui",0,1})
aAdd(aRotina, {"Visualizar"	,"AxVisual",0,2})  
If lProd
	aAdd(aRotina, {"Novo Inventario","U_INVNXT1(.T.)",0,3,, .f.}) 
Else
	aAdd(aRotina, {"Novo Inventario","U_INVNXT1(.F.)",0,3,, .f.}) 
EndIf  
If lProd
	aAdd(aRotina, {"Excluir"	,"U_ExcZB0(.T.)",0,5,,})
Else	
	aAdd(aRotina, {"Excluir"	,"U_ExcZB0(.F.)",0,5,,})
EndIf
aAdd(aRotina, {"Legenda"    ,'U_LegenZB0()',0,6,,}) 
If lProd
	aAdd(aRotina, {"Relatorio"  ,'U_RELINVNXT(.T.)',0,7,,}) 
Else
	aAdd(aRotina, {"Relatorio"  ,'U_RELINVNXT(.F.)',0,7,,})
EndIf  
If lProd                                                     
	aAdd(aRotina, {"Retomar Contagem"  ,'U_CarNaoConf(.T.,.F.)',0,8,,}) 
Else
	aAdd(aRotina, {"Retomar Contagem"  ,'U_CarNaoConf(.F.,.F.)',0,8,,})
EndIf  
If lProd                                                     
	aAdd(aRotina, {"Valida็ใo/Rejei็ใo"  ,'U_ValRej(.T.)',0,9,,}) 
Else
	aAdd(aRotina, {"Valida็ใo/Rejei็ใo"  ,'U_ValRej(.F.)',0,9,,})
EndIf 
If lProd                                                     
	aAdd(aRotina, {"Recontagem"  ,'U_CarNaoConf(.T.,.T.)',0,10,,}) 
Else
	aAdd(aRotina, {"Recontagem"  ,'U_CarNaoConf(.F.,.T.)',0,10,,})
EndIf
If lProd                                                     
	aAdd(aRotina, {"Gerar Etiqueta"  ,'U_GeraEtiq(.T.,.T.)',0,11,,}) 
Else
	aAdd(aRotina, {"Gerar Etiqueta"  ,'U_GeraEtiq(.F.,.T.)',0,11,,})
EndIf   

aAdd(aCores, {"ZB0_STATUS == '1'"    , "BR_AMARELO"   	})    
aAdd(aCores, {"ZB0_STATUS == '2'"    , "BR_AZUL"		})    
aAdd(aCores, {"ZB0_STATUS == '3'"    , "BR_CINZA"   	})    
aAdd(aCores, {"ZB0_STATUS == '4'"    , "BR_LARANJA"   	})    
aAdd(aCores, {"ZB0_STATUS == '5'"    , "BR_MARROM"		})    
aAdd(aCores, {"ZB0_STATUS == '6'"    , "BR_PINK"  	 	})    
aAdd(aCores, {"ZB0_STATUS == '7'"    , "BR_PRETO"   	})    
aAdd(aCores, {"ZB0_STATUS == '8'"    , "BR_VERDE"  		})    
aAdd(aCores, {"ZB0_STATUS == '9'"    , "BR_VERMELHO"   	})  
aAdd(aCores, {"ZB0_STATUS == '0'"    , "BR_BRANCO"   	})   

dbSelectArea("ZB0")
dbSetOrder(1)

MBrowse( 6,1,22,75, "ZB0",,,,,,aCores,,,,,,,,Iif (lProd,"ZB0_MASTER = '0'","ZB0_MASTER <> '0'"))

Return

User Function IniMestre()
 
	Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690")
	Local cInv		:= SuperGetMv("BH_FMSTINV",,"")
	Local cDocMestre:= SuperGetMv("BH_INDOCMS",,"")
	
	If !(__cUserId $ cUserExc)
		MsgStop("Usuแrio sem permissใo para acesso.","Acesso negado","STOP")
	 	Return
	EndIf
	
	If cInv == "F"
		If MsgYesNo("Deseja iniciar um novo Documento Mestre de Inventแrio ?")			
			
			If Select("SX6") == 0
				DbSelectArea("SX6")
			EndIf
			SX6->(dbGoTop())	
			SX6->(dbsetorder(1))
			If SX6->(dbseek(xFilial("SX6")+"BH_FMSTINV"))
				If SX6->(RecLock("SX6",.F.))
					SX6->X6_CONTEUD:="I"
					SX6->(MsUnlock())
				EndIf	
			Endif				
			
			MsgInfo("Documento Mestre " +cDocMestre+ " iniciado.") 			
		EndIf
	Else
		MsgStop("Jแ existe um Documento Mestre de Inventแrio em aberto. Para iniciar um novo, serแ necessแrio finalizแ-lo.")
	EndIf		 

Return
User Function FinMestre()
 
	Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690")
	Local cInv		:= SuperGetMv("BH_FMSTINV",,"")
	Local cDocMestre:= SuperGetMv("BH_INDOCMS",,"")
	
	If !(__cUserId $ cUserExc)
		MsgStop("Usuแrio sem permissใo para acesso.","Acesso negado","STOP")
	 	Return
	EndIf	
	
	If cInv == "I"
		If MsgYesNo("Deseja finalizar o Documento Mestre de Inventแrio " +cDocMestre+ " ?")  
		
			If Select("SX6") == 0
				DbSelectArea("SX6")
			EndIf
			SX6->(dbGoTop())
			SX6->(dbsetorder(1))
			If SX6->(dbseek(xFilial("SX6")+"BH_FMSTINV"))
				If SX6->(RecLock("SX6",.F.))
					SX6->X6_CONTEUD:="F"
					SX6->(MsUnlock())
				EndIf	
			Endif
		
			MsgInfo("Documento Mestre finalizado.")
			
			If Select("SX6") == 0
				DbSelectArea("SX6")
			EndIf	
			SX6->(dbGoTop())
			SX6->(dbsetorder(1))
			If SX6->(dbseek(xFilial("SX6")+"BH_INDOCMS"))
				If SX6->(RecLock("SX6",.F.))
					SX6->X6_CONTEUD:=strzero(Val(SX6->X6_CONTEUD)+1,3)
					SX6->(MsUnlock())
				EndIf	
			Endif
		EndIf
	Else
		MsgStop("Nใo existe Documento Mestre de Inventแrio em aberto.")
	EndIf		 

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function INVNXT1(lProd,lRetCont,lRecontagem)

Local aPosObj    	:= {}
Local aObjects   	:= {}
Local aSize      	:= MsAdvSize()
Local cLinOK     	:= "AllwaysTrue"
Local cTudoOK       := "AllwaysTrue"
Local aButtons    	:= {} 

Private llFecha		:= .F.  
Private lDelRecont  := .F.

Private aColsM1    	:= {}
Private aHeadM1 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados

Private nFreeze 	:= 0
Private cAliaM1     := "TRB"
Private oGetDadM1 	:= Nil
Private oDlgConf 	:= Nil
Private nQtdOri 	:= 0
Private nQtdDes 	:= 0   

Private cData		:= CTOD("  /  /  ") 
Private cLocal		:= space(2) 
Private cRua		:= space(1) 
Private cPalete		:= space(2) 
Private cCaixa		:= space(2) 
Private cModel		:= space(20)
Private cDescLoc	:= "" 
Private cLocEst		:= ""

Private cPerg		:= "INVENXT" 
Private cNumSta		:= ""

Private _cImei	    := space(20)
Private _cMaster	:= space(20) 

Private cDocMestre	:= SuperGetMv("BH_INDOCMS",,"") 
Private cNumDoc		:= ""   
Private nVarCont	:= 0 
Private oSayDCont	:= Nil
Private llApont		:= .F. 

Private	cNextNum 	:= ""
Private	lFirst 	 	:= .T.

Default lRetCont	:= .F.
Default lRecontagem := .F.

oFont   		:= tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito 
oVarContFont	:= tFont():New('Tahoma',,-45,.t.,.t.) // 5o. Parโmetro negrito

If !lRetCont
	If lProd 	
		TelaPar()
		If llFecha
			Return
		EndIf
		cDescLoc:= AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IN'+cLocal, "X5_DESCRI"))			
	Else
		If Empty(cDataAux) 
			ValPerg(cPerg)
			If !Pergunte(cPerg, .T.)
				Return
			EndIf
		EndIf	
	EndIf
	If !lProd
		If Empty(cDataAux)
			cData 	:= mv_par01
			cDataAux := cData
		Else
			cData := cDataAux
		EndIf
	EndIf
EndIf		 

// Cracao dos arquivos de Trabalho
FCRIATRB(lRetCont,lRecontagem,lProd) 

//Alimenta o aheader
ADDAHEAD(lProd)  

//Alimenta o acols e cria TMP
If !lRetCont    
	ADDACOLS(1,lProd,Nil,lRetCont,lRecontagem,0) 
Else
	If lRecontagem 
		lRetCont := .F.
		ADDACOLS(1,lProd,Nil,lRetCont,lRecontagem,0) 
	EndIf	
EndIf
	
	DEFINE MSDIALOG oDlgConf TITLE "Inventario Radio Nextel" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL
	
	aObjects := {}
	
	aAdd( aObjects, {100,100, .T., .T.})
	aAdd( aObjects, {100,100, .T., .T.})
	
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj		:= MsObjSize( ainfo, aObjects )
	
	@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[1,3]-125,aPosObj[1,4]-5 LABEL "" OF oDlgConf PIXEL    
	
	If lProd
		oSayIme := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+010,{||"IMEI"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oGetIme := tGet():New( aPosObj[1,1]+25,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlgConf,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei") 	
	Else
		oSayIme := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+010,{||"MASTER"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oGetIme := tGet():New( aPosObj[1,1]+25,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cMaster := u, _cMaster)},oDlgConf,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cMaster") 	
	EndIf
	
	oGetIme:bValid 		:= {|| ExeConf(lProd,.F.,.F.,lRecontagem) }  
	
	If lProd
		oSayRua  := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+150,{||"RUA"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)  
		oSayDRua := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+150,{||cRua} ,oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,016) 
		
		oSayPal  := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+200,{||"PALETE"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)  
		oSayDPal := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+200,{||cPalete} ,oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,016) 
		
		oSayCai  := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+250,{||"CAIXA"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)   
		oSayDCai := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+250,{||cCaixa} ,oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,016)	
		
		oSayMod  := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+300,{||"MODELO"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)   
		oSayDMod := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+300,{||cModel} ,oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,016)
		
	EndIf 
	
	oSayLoc  := TSay():New( aPosObj[1,1]+85,aPosObj[1,2]+010,{||"LOCAL"} ,oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)  
	oSayDLoc := TSay():New( aPosObj[1,1]+85,aPosObj[1,2]+060,{|| Iif (lProd,cDescLoc,cLocEst)},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,016) 
	
	oSayDCont:= TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+500,{||STRZERO(nVarCont,5)},oDlgConf,,oVarContFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,252,030) 
	
	oGetDadM1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],GD_UPDATE,"AllwaysTrue",cTudoOK,"",aEdiCpo,nFreeze,9999,,,.T.,oDlgConf,aHeadM1,aColsM1) 
	
	oGetDadM1:oBrowse:bChange := {|| (oGetDadM1:nat) }
	
	If lRetCont
		If !lRecontagem 
			ADDACOLS(1,lProd,Nil,lRetCont,lRecontagem,0)
		EndIf
	Else
		If lRecontagem 
			ADDACOLS(1,lProd,Nil,lRetCont,lRecontagem,1) 
		EndIf			 
	EndIf
	
	ACTIVATE MSDIALOG oDlgConf ON INIT EnchoiceBar(oDlgConf,{|| AtuFlagRec("N",cDocMestre,cNumDoc),IncConfir(lProd),oDlgConf:End()},{|| AtuFlagRec("N",cDocMestre,cNumDoc),oDlgConf:End()},,aButtons)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CarNaoConf(lProd,lRecontagem)

Local llRet  := .F.
Local cQuery := ""
Local _cAlias := GetNextAlias() 

Local aNaoConf := {} 

	If !lProd
		Return
	EndIf	

	cQuery := " SELECT ZB0_DOCMAS, ZB0_DOC, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_LOCAL, MAX(ZB0_CONTAG) ZB0_CONTAG, ZB0_DTINV, ZB0_MODELO FROM " + RetSqlName("ZB0") + CRLF
	
	If lRecontagem
		cQuery += " (NOLOCK) WHERE ZB0_FINALI <> 'S' AND ZB0_SITUAC NOT IN ('0','1') " + CRLF 
	Else
		cQuery += " (NOLOCK) WHERE ZB0_CONFIR = '0' " + CRLF 
	EndIf	
	cQuery += " AND D_E_L_E_T_ <> '*' AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF 
	cQuery += " AND ZB0_MASTER = '0' AND (ZB0_FLREC = 'N' OR ZB0_FLREC = '')  " + CRLF
	cQuery += " GROUP BY ZB0_DOCMAS, ZB0_DOC, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_LOCAL, ZB0_DTINV, ZB0_MODELO " + CRLF 	
	
	cQuery := ChangeQuery(cQuery) 
	If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
	( _cAlias )->( dbGoTop() )
	
	If ( _cAlias )->( !EOF() )
		While ( _cAlias )->( !EOF() ) 
			aAdd(aNaoConf,;
			{( _cAlias )->(ZB0_DOCMAS),;
			( _cAlias )->( ZB0_DOC),;
			( _cAlias )->( ZB0_RUA),;
			( _cAlias )->( ZB0_PALETE),;
			( _cAlias )->( ZB0_CAIXA),;
			AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IN'+( _cAlias )->( ZB0_LOCAL), "X5_DESCRI")),;
			( _cAlias )->( ZB0_CONTAG),;
			STOD(( _cAlias )->( ZB0_DTINV)),;
			( _cAlias )->( ZB0_LOCAL),;
			( _cAlias )->( ZB0_MODELO),;
			.F.})		
		
			( _cAlias )->( DbSkip() ) 
		EndDo 
		TelNaoConf(aNaoConf,lProd,lRecontagem)
	Else
		If lRecontagem
			MsgAlert("Nใo hแ documentos a serem feitas recontagens.Documentos aguardando anแlise ou jแ finalizados.")
		Else
			MsgAlert("Nใo hแ documentos a serem retomadas sua contagem.")
		EndIf	 
	EndIf		

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelNaoConf(aNaoConf,lProd,lRecontagem)

	Local oDlg
	Local aSize 	:= MsAdvSize()
	Local aHeadConf := {}
	
	Private oGetNaoConf	:= Nil	
	
	aAdd(aHeadConf,{"Doc.Mestre" 		,"Doc.Mestre"		,"@!" ,TamSX3("ZB0_DOCMAS")[1]	,0 ,"" ,"","C","","" }) 
	aAdd(aHeadConf,{"Doc. Caixa" 		,"Doc. Caixa"		,"@!" ,TamSX3("ZB0_DOC")[1]+10	,0 ,"" ,"","C","","" }) 
	aAdd(aHeadConf,{"Rua" 				,"Rua" 				,"@!" ,TamSX3("ZB0_RUA")[1]+10	,0 ,"" ,"","C","","" })
	aAdd(aHeadConf,{"Palete" 			,"Palete" 			,"@!" ,TamSX3("ZB0_PALETE")[1]	,0 ,"" ,"","C","","" })
	aAdd(aHeadConf,{"Caixa" 			,"Caixa" 			,"@!" ,TamSX3("ZB0_CAIXA")[1]	,0 ,"" ,"","C","","" })
	aAdd(aHeadConf,{"Local" 			,"Local" 			,"@!" ,TamSX3("B1_DESC")[1] 	,0 ,"" ,"","C","","" })
	aAdd(aHeadConf,{"Contagem" 			,"Contagem" 		,"@!" ,TamSX3("ZB0_CONTAG")[1]	,0 ,"" ,"","N","","" })
	aAdd(aHeadConf,{"Data Inventแrio"	,"Data Inventแrio"	,"@!" ,TamSX3("ZB0_DTINV")[1]	,0 ,"" ,"","D","","" })	
	aAdd(aHeadConf,{"Cod.Local" 		,"Cod.Local" 		,"@!" ,TamSX3("ZB0_LOCAL")[1] 	,0 ,"" ,"","C","","" })
	aAdd(aHeadConf,{"Modelo" 			,"Modelo" 			,"@!" ,TamSX3("ZB0_MODELO")[1] 	,0 ,"" ,"","C","","" })
				
	//Cria uma Dialog
	
	DEFINE MSDIALOG oDlg TITLE "Inventario Nextel - " + Iif(lRecontagem,"Recontagem","Retomar Contagens") From aSize[7],0 to aSize[6],aSize[5] PIXEL
		
		oGetNaoConf := MsNewGetDados():New(aSize[7],0,aSize[6],aSize[5],GD_UPDATE,"AllwaysTrue","AllwaysTrue","",{},0,9999,,,.T.,oDlg,aHeadConf,aNaoConf)
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| AtuFlagRec("S",oGetnaoconf:acols[oGetnaoconf:nat][1],oGetnaoconf:acols[oGetnaoconf:nat][2]),U_INVNXT1(lProd,.T.,lRecontagem), oDlg:End()},{|| oDlg:End()})
	 
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuFlagRec Autor  ณVinicius Leonardo    บ Data ณ  06/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuFlagRec(cFlag,cDocMestre,cNumDoc)

	cQuery := " UPDATE " + RetSqlName("ZB0") + " SET ZB0_FLREC = '"+cFlag+"' " + CRLF
	cQuery += " WHERE ZB0_DOC = '" + cNumDoc + "' " + CRLF  
	cQuery += " AND ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF 
	cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
	cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF 
	
	TcSqlExec(cQuery)
	
Return	 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIATRB  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria็ใo das Tabelas Temporarias           		          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AOC                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FCRIATRB(lRetCont,lRecontagem,lProd)

Local _aStru := {}

AADD(_aStru,{"BGH_MODELO"	,"C",TamSX3("ZB0_MODELO")[1],0})
AADD(_aStru,{"BGH_IMEI"		,"C",TamSX3("ZB0_IMEI")[1],0})
AADD(_aStru,{"BGH_OS"	    ,"C",TamSX3("ZB0_NUMOS")[1],0})
AADD(_aStru,{"BGH_DATA"		,"D",TamSX3("ZB0_DATA")[1],0})
AADD(_aStru,{"BGH_HORA"		,"C",TamSX3("ZB0_HORA")[1],0})
AADD(_aStru,{"BGH_USER"		,"C",TamSX3("ZB0_USER")[1],0})
AADD(_aStru,{"BGH_STATUS"	,"C",TamSX3("B1_DESC")[1],0})
AADD(_aStru,{"BGH_MASTER"	,"C",TamSX3("ZB0_MASTER")[1],0}) 
AADD(_aStru,{"BGH_DTINV"	,"D",TamSX3("ZB0_DTINV")[1],0}) 
If lRetCont .and. !lRecontagem 
	AADD(_aStru,{"BGH_NUMSTA"	,"C",TamSX3("ZB0_STATUS")[1],0})
EndIf
If !lProd
	AADD(_aStru,{"BGH_RUA"	 ,"C",TamSX3("ZB0_RUA")[1],0}) 
	AADD(_aStru,{"BGH_PALETE","C",TamSX3("ZB0_PALETE")[1],0}) 
EndIf

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif  

_cChaveInd	 := "BGH_MASTER+BGH_IMEI" 

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaHead  บAutor  ณVinicius Leonardo   บ Data ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria os a headers para a tela 							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDAHEAD(lProd)

If lProd
	aCmp 	:= {"ZB0_MODELO","ZB0_IMEI","ZB0_NUMOS","ZB0_DATA","ZB0_HORA","ZB0_USER","B1_DESC"}
	
	aCmpTRB := {"BGH_MODELO","BGH_IMEI","BGH_OS","BGH_DATA","BGH_HORA","BGH_USER","BGH_STATUS"}
	
	aTitTRB := {"Modelo","IMEI","OS","Dt Apontamento","Hora","Analista","Status"}

Else
	aCmp 	:= {"ZB0_MODELO","ZB0_IMEI","ZB0_NUMOS","ZB0_DATA","ZB0_HORA","ZB0_USER","B1_DESC","ZB0_RUA","ZB0_PALETE"}
	
	aCmpTRB := {"BGH_MODELO","BGH_IMEI","BGH_OS","BGH_DATA","BGH_HORA","BGH_USER","BGH_STATUS","BGH_RUA","BGH_PALETE"}
	
	aTitTRB := {"Modelo","IMEI","OS","Dt Apontamento","Hora","Analista","Status","Endere็o","Palete"}
EndIf

aAdd(aHeadM1,{" ","LEGENDA","@BMP",2,0,,,"C",,"V"})

dbSelectArea("SX3")
dbSetOrder(2)
For i := 1 To Len(aCmp)
	If SX3->(dbSeek(aCmp[i]))
		AAdd(aHeadM1, {aTitTRB[i],;
		aCmpTRB[i],;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	Endif
Next i

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExeConf   บAutor  ณVinicius Leonardo     บ Data ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa Separa็ใo da Pe็a                                    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExeConf(lProd,lRetCont,lRecontagem,lRecon2)

Local _cAlias 		:= GetNextAlias()
Local cStatus		:= ""
Local lInclui 		:= .F.
Local lverif 		:= .F.
Local lExist		:= .F. 

Default lRetCont	:= .F. 
Default lRecon2		:= .F.

If lRecon2 
	If !lDelRecont
		cQuery := " UPDATE " + RetSqlName("ZB0") + " SET D_E_L_E_T_ = '*' " + CRLF
		cQuery += " WHERE ZB0_DOC = '" + oGetnaoconf:acols[oGetnaoconf:nat][2] + "' " + CRLF  
		cQuery += " AND ZB0_DOCMAS = '" + oGetnaoconf:acols[oGetnaoconf:nat][1] + "' " + CRLF 
		cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF 
		
		TcSqlExec(cQuery)
		lDelRecont := .T.
	EndIf
EndIf

If lProd
	cVar := _cImei
Else
	cVar := _cMaster
EndIf

If lRetCont
	If lProd
		If !lRecontagem  		
			cQuery := " SELECT * FROM " + RetSqlName("ZB0") + CRLF
			cQuery += " (NOLOCK) WHERE ZB0_DOC = '" + oGetnaoconf:acols[oGetnaoconf:nat][2] + "' " + CRLF  
			cQuery += " AND ZB0_DOCMAS = '" + oGetnaoconf:acols[oGetnaoconf:nat][1] + "' " + CRLF 
			cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
			cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF 
			cQuery += " ORDER BY ZB0_CONTAG " + CRLF
			
			cQuery := ChangeQuery(cQuery) 
			If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
			dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
			( _cAlias )->( dbGoTop() )
			
			If ( _cAlias )->( !EOF() ) 
				cDocMestre := ( _cAlias )->(ZB0_DOCMAS)
				cNumDoc	:= ( _cAlias )->(ZB0_DOC)
				cData	:= STOD(( _cAlias )->(ZB0_DTINV)) 
				cLocal	:= ( _cAlias )->(ZB0_LOCAL)
				While ( _cAlias )->( !EOF() )  
				
					DbSelectArea("TRB")
					If RecLock("TRB",.T.)
						TRB->BGH_MODELO   	:= ( _cAlias )->(ZB0_MODELO)
						TRB->BGH_IMEI   	:= ( _cAlias )->(ZB0_IMEI) 
						TRB->BGH_OS   		:= ( _cAlias )->(ZB0_NUMOS)						
						TRB->BGH_DATA   	:= STOD(( _cAlias )->(ZB0_DATA))
						TRB->BGH_HORA       := ( _cAlias )->(ZB0_HORA)
						TRB->BGH_USER		:= ( _cAlias )->(ZB0_USER)	
						TRB->BGH_STATUS		:= ( _cAlias )->(ZB0_DSCSTA) 
						TRB->BGH_MASTER		:= ( _cAlias )->(ZB0_MASTER)
						TRB->BGH_DTINV   	:= STOD(( _cAlias )->(ZB0_DTINV))
						TRB->BGH_NUMSTA		:= ( _cAlias )->(ZB0_STATUS)												
					   	TRB->(MsUnlock())
				   	EndIf
					ADDACOLS(2,lProd,Nil,lRetCont,lRecontagem,0)
					
					( _cAlias )->( dbSkip() )
				EndDo
			EndIf
		EndIf
		If lRecontagem  
			cDocMestre:= oGetnaoconf:acols[oGetnaoconf:nat][1]
			cNumDoc	:= oGetnaoconf:acols[oGetnaoconf:nat][2]
			cData	:= STOD(oGetnaoconf:acols[oGetnaoconf:nat][8]) 
			cLocal	:= oGetnaoconf:acols[oGetnaoconf:nat][9]
		EndIf		
		cRua	:= oGetnaoconf:acols[oGetnaoconf:nat][3]
		cPalete	:= oGetnaoconf:acols[oGetnaoconf:nat][4]
		cCaixa	:= oGetnaoconf:acols[oGetnaoconf:nat][5]
		cDescLoc:= oGetnaoconf:acols[oGetnaoconf:nat][6]
		cModel  := oGetnaoconf:acols[oGetnaoconf:nat][10]
		nVarCont:= Iif(lRecontagem,0,oGetnaoconf:acols[oGetnaoconf:nat][7])
		oSayDRua:Refresh()
		oSayDPal:Refresh()
		oSayDCai:Refresh()
		oSayDLoc:Refresh()
		oSayDMod:Refresh()
		oSayDCont:Refresh()
	EndIf	
Else                	
	If !empty(cVar)
		If lProd
			If Len(AllTrim(_cImei)) <> 15
				MsgAlert("Equipamento com Erro no Imei, Favor Inserir Novamente!") 
				_cImei  := Space(20)
				oGetDadM1:Refresh()
				oGetIme:SetFocus()
				Return
			EndIf
		EndIf 
		If lProd		
			cQuery := " SELECT MAX(R_E_C_N_O_) AS ZZ4_RECNO FROM " + RetSqlName("ZZ4") + CRLF
			cQuery += " (NOLOCK) WHERE ZZ4_IMEI = '" + _cImei + "' " + CRLF 
			cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
			cQuery += " AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " 	
		Else
			cQuery := " SELECT MAX(ZZ4_STATUS) AS ZZ4_STATUS, ZZ4_CODPRO, ZZ4_IMEI, ZZ4_OS, ZZ4_ETQMEM, ZZ4_LOCAL, ZZ4_ENDES, ZZ4_PALLET FROM " + RetSqlName("ZZ4") + CRLF
			cQuery += " (NOLOCK) WHERE ZZ4_ETQMEM = '" + _cMaster + "' " + CRLF 
			cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
			cQuery += " AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " + CRLF 
			cQuery += " GROUP BY ZZ4_CODPRO, ZZ4_IMEI, ZZ4_OS, ZZ4_ETQMEM, ZZ4_LOCAL, ZZ4_ENDES, ZZ4_PALLET " + CRLF
			cQuery += " ORDER BY ZZ4_IMEI " + CRLF 
		EndIf 
		
		cQuery := ChangeQuery(cQuery) 
		If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
		( _cAlias )->( dbGoTop() )
		If lProd
			If ( _cAlias )->(ZZ4_RECNO)#0
				If Select("ZZ4") == 0		
					dbSelectArea("ZZ4")
				EndIf 
				ZZ4->(dbGoTop())
				ZZ4->(dbGoTo(( _cAlias )->(ZZ4_RECNO)))				
				
				cQuery := " SELECT * FROM " + RetSqlName("ZB0") + CRLF
				cQuery += " (NOLOCK) WHERE ZB0_IMEI = '" + ZZ4->ZZ4_IMEI + "' " + CRLF 				
				cQuery += " AND ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF							
				cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
				cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' "  
				
				cQuery := ChangeQuery(cQuery) 
				If Select("TRB1") > 0;TRB1->(dbCloseArea());EndIf
				dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "TRB1", .t., .t.)
				TRB1->(dbGoTop())  
				
				If TRB1->(EOF())
					
					If !lRecontagem	 		 			
						If Empty(cNumDoc)	
							If lRecon2
								cNumDoc := oGetnaoconf:acols[oGetnaoconf:nat][2]
							Else							
								cNumDoc := DocCaixa()
							EndIf						
						EndIf 
						nVarCont := nVarCont+1
						Do Case  
						Case Alltrim(ZZ4->ZZ4_STATUS)=="1"
							cNumSta :="1"
							cStatus:="ENTRADA APONTADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="2"
							cNumSta :="2"
							cStatus:="ENTRADA CONFIRMADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="3"
							cNumSta :="3"
							cStatus:="EM PODER DO ESTOQUE" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="4"
							cNumSta :="4"
							cStatus:="EM PODER DA PRODUCAO" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="5"
							cNumSta :="5"
							cStatus:="OS ENCERRADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="6"
							cNumSta :="6"
							cStatus:="SAIDA LIDA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="7"
							cNumSta :="7"
							cStatus:="SAIDA APONTADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="8"
							cNumSta :="8"
							cStatus:="PV GERADO" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="9"
							cNumSta :="9"
							cStatus:="NFS GERADA" 
						EndCase
						If RecLock("ZB0",.T.)
							ZB0->ZB0_FILIAL	:= xFilial("ZB0")
							ZB0->ZB0_DOCMAS	:= cDocMestre						
							ZB0->ZB0_DOC	:= cNumDoc 
							ZB0->ZB0_STATUS := ZZ4->ZZ4_STATUS
							ZB0->ZB0_DSCSTA := cStatus
							ZB0->ZB0_MODELO	:= cModel 
							ZB0->ZB0_IMEI   := ZZ4->ZZ4_IMEI								
							ZB0->ZB0_NUMOS	:= ZZ4->ZZ4_OS
							If lRecon2
								ZB0->ZB0_LOCAL  := oGetnaoconf:acols[oGetnaoconf:nat][9]
							Else					
								ZB0->ZB0_LOCAL  := cLocal
							EndIf
							ZB0->ZB0_RUA	:= cRua
							ZB0->ZB0_PALETE	:= cPalete
							ZB0->ZB0_CAIXA	:= cCaixa												
							ZB0->ZB0_DATA	:= dDataBase 
							ZB0->ZB0_HORA   := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							ZB0->ZB0_USER	:= cUserName
							If lRecon2
								ZB0->ZB0_DTINV	:= oGetnaoconf:acols[oGetnaoconf:nat][8]
							Else 
								ZB0->ZB0_DTINV	:= cData
							EndIf 
							ZB0->ZB0_MASTER	:= "0" 
							ZB0->ZB0_CONFIR	:= "0"						
							ZB0->ZB0_FINALI := "N"
							ZB0->ZB0_CONTAG := nVarCont
							ZB0->ZB0_SITUAC := "0"
							ZB0->ZB0_NUMCON := '1' 						
							ZB0->(MsUnlock())
						EndIf  
											
						DbSelectArea("TRB")
						If RecLock("TRB",.T.)
							TRB->BGH_MODELO   	:= ZZ4->ZZ4_CODPRO
							TRB->BGH_IMEI   	:= ZZ4->ZZ4_IMEI 
							TRB->BGH_OS   		:= ZZ4->ZZ4_OS						
							TRB->BGH_DATA   	:= dDataBase
							TRB->BGH_HORA       := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							TRB->BGH_USER		:= cUserName	
							TRB->BGH_STATUS		:= cStatus
							TRB->BGH_MASTER		:= "0"
							TRB->BGH_DTINV   	:= cData							
						   	TRB->(MsUnlock())
					   	EndIf
						ADDACOLS(2,lProd,ZZ4->ZZ4_IMEI,Nil,lRecontagem,0)
										
					Else				
						
						If Empty(cNumDoc)							
							cNumDoc := DocCaixa()							
						EndIf 						
						If lFirst
							cNextNum := ProxNum()
							lFirst 	 := .F.
						EndIf						
						nVarCont := nVarCont+1
						Do Case  
						Case Alltrim(ZZ4->ZZ4_STATUS)=="1"
							cNumSta :="1"
							cStatus:="ENTRADA APONTADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="2"
							cNumSta :="2"
							cStatus:="ENTRADA CONFIRMADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="3"
							cNumSta :="3"
							cStatus:="EM PODER DO ESTOQUE" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="4"
							cNumSta :="4"
							cStatus:="EM PODER DA PRODUCAO" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="5"
							cNumSta :="5"
							cStatus:="OS ENCERRADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="6"
							cNumSta :="6"
							cStatus:="SAIDA LIDA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="7"
							cNumSta :="7"
							cStatus:="SAIDA APONTADA" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="8"
							cNumSta :="8"
							cStatus:="PV GERADO" 
						Case Alltrim(ZZ4->ZZ4_STATUS)=="9"
							cNumSta :="9"
							cStatus:="NFS GERADA" 
						EndCase
						If RecLock("ZB0",.T.)
							ZB0->ZB0_FILIAL	:= xFilial("ZB0")
							ZB0->ZB0_DOCMAS	:= cDocMestre
							ZB0->ZB0_DOC	:= cNumDoc 
							ZB0->ZB0_STATUS := ZZ4->ZZ4_STATUS
							ZB0->ZB0_DSCSTA := cStatus
							ZB0->ZB0_MODELO	:= cModel 
							ZB0->ZB0_IMEI   := ZZ4->ZZ4_IMEI								
							ZB0->ZB0_NUMOS	:= ZZ4->ZZ4_OS					
							ZB0->ZB0_LOCAL  := cLocal
							ZB0->ZB0_RUA	:= cRua
							ZB0->ZB0_PALETE	:= cPalete
							ZB0->ZB0_CAIXA	:= cCaixa												
							ZB0->ZB0_DATA	:= dDataBase 
							ZB0->ZB0_HORA   := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							ZB0->ZB0_USER	:= cUserName 
							ZB0->ZB0_DTINV	:= cData 
							ZB0->ZB0_MASTER	:= "0" 
							ZB0->ZB0_CONFIR	:= "0"  
							ZB0->ZB0_FINALI := "N"
							ZB0->ZB0_CONTAG := nVarCont
							ZB0->ZB0_SITUAC := "0"
							ZB0->ZB0_NUMCON := cNextNum 
							ZB0->(MsUnlock())
						EndIf  
											
						DbSelectArea("TRB")
						If RecLock("TRB",.T.)
							TRB->BGH_MODELO   	:= ZZ4->ZZ4_CODPRO
							TRB->BGH_IMEI   	:= ZZ4->ZZ4_IMEI 
							TRB->BGH_OS   		:= ZZ4->ZZ4_OS						
							TRB->BGH_DATA   	:= dDataBase
							TRB->BGH_HORA       := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							TRB->BGH_USER		:= cUserName	
							TRB->BGH_STATUS		:= cStatus
							TRB->BGH_MASTER		:= "0"
							TRB->BGH_DTINV   	:= cData							
						   	TRB->(MsUnlock())
					   	EndIf 
						ADDACOLS(2,lProd,ZZ4->ZZ4_IMEI,Nil,lRecontagem,0)
					EndIf	
				Else						
					MsgAlert("Imei jแ apontado para este Mestre de Inventแrio.")
					llApont := .T.
																			
				Endif						
			Else 
				MsgAlert("Imei nใo encontrado no sistema.")
				_cImei  := Space(20)
				oGetDadM1:Refresh()
				oGetIme:SetFocus()
				Return					
			EndIf
		Else
		    If ( ( _cAlias )->( !Eof() ) ) 
		    
			    cQryQtd := " SELECT COUNT(*) AS QTD FROM " + RetSqlName("ZZ4") + CRLF
			    cQryQtd += " (NOLOCK) WHERE ZZ4_ETQMEM = '" + _cMaster + "' " + CRLF
			    cQryQtd += " AND D_E_L_E_T_ <> '*' " + CRLF
				cQryQtd += " AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " + CRLF
                
				cQryQtd := ChangeQuery(cQryQtd) 
				If Select("SQLQTD") > 0;SQLQTD->( dbCloseArea() );EndIf
				dbUseArea(.t., "TOPCONN", TCGenQry(,,cQryQtd), "SQLQTD", .t., .t.)
				SQLQTD->( dbGoTop() )
		        If SQLQTD->( !Eof() )  
		    		nVarCont := SQLQTD->QTD
		    	EndIf
		    			    	
		    	cLocEst:= AllTrim(Posicione("NNR", 1, xFilial("NNR")+( _cAlias )->(ZZ4_LOCAL), "NNR_DESCRI"))		
		      
				While ( ( _cAlias )->( !Eof() ) )			    
					If !lverif					
						cQuery := " SELECT * FROM " + RetSqlName("ZB0") + CRLF
						cQuery += " (NOLOCK) WHERE ZB0_MASTER = '" + ( _cAlias )->(ZZ4_ETQMEM) + "' " + CRLF 				
						cQuery += " AND ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF				
						cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
						cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' "  
						
						cQuery := ChangeQuery(cQuery) 
						If Select("TRB2") > 0;TRB2->(dbCloseArea());EndIf
						dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "TRB2", .t., .t.)
						TRB2->(dbGoTop())  
						
						If TRB2->(EOF())						
						    lInclui := .T.
							lverif := .T.
						Else
							MsgAlert("Master jแ apontada no inventario da data informada no parโmetro.") 
							lExist := .T. 
							nVarCont := 0
							cLocEst := ""
							Exit		
						EndIf
					EndIf	
					If lInclui
						If Empty(cNumDoc)
							cNumDoc := DocCaixa() 							
						EndIf   
						Do Case  
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="1"
							cNumSta :="1"
							cStatus:="ENTRADA APONTADA" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="2"
							cNumSta :="2"
							cStatus:="ENTRADA CONFIRMADA" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="3"
							cNumSta :="3"
							cStatus:="EM PODER DO ESTOQUE" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="4"
							cNumSta :="4"
							cStatus:="EM PODER DA PRODUCAO" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="5"
							cNumSta :="5"
							cStatus:="OS ENCERRADA" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="6"
							cNumSta :="6"
							cStatus:="SAIDA LIDA" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="7"
							cNumSta :="7"
							cStatus:="SAIDA APONTADA" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="8"
							cNumSta :="8"
							cStatus:="PV GERADO" 
						Case Alltrim(( _cAlias )->(ZZ4_STATUS))=="9"
							cNumSta :="9"
							cStatus:="NFS GERADA" 
						EndCase
						If RecLock("ZB0",.T.)
							ZB0->ZB0_FILIAL	:= xFilial("ZB0")
							ZB0->ZB0_DOCMAS	:= cDocMestre 
							ZB0->ZB0_DOC	:= cNumDoc 
							ZB0->ZB0_STATUS := Alltrim(( _cAlias )->(ZZ4_STATUS))
							ZB0->ZB0_DSCSTA := cStatus
							ZB0->ZB0_MODELO	:= ( _cAlias )->(ZZ4_CODPRO) 
							ZB0->ZB0_IMEI   := ( _cAlias )->(ZZ4_IMEI)								
							ZB0->ZB0_NUMOS	:= ( _cAlias )->(ZZ4_OS)
							ZB0->ZB0_LOCAL  := ( _cAlias )->(ZZ4_LOCAL)							
							ZB0->ZB0_RUA  	:= ( _cAlias )->(ZZ4_ENDES)
							ZB0->ZB0_PALETE := ( _cAlias )->(ZZ4_PALLET)	
							ZB0->ZB0_CAIXA  := "01"																				
							ZB0->ZB0_DATA	:= dDataBase 
							ZB0->ZB0_HORA   := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							ZB0->ZB0_USER	:= cUserName 
							ZB0->ZB0_DTINV	:= cData
							ZB0->ZB0_MASTER	:= cValtoChar(( _cAlias )->(ZZ4_ETQMEM))
							ZB0->ZB0_CONFIR	:= "1" 
							ZB0->ZB0_FINALI	:= "S"
							ZB0->ZB0_CONTAG := nVarCont
							ZB0->ZB0_SITUAC := "0" 
							ZB0->ZB0_NUMCON := "1"
							ZB0->(MsUnlock())
						EndIf  
											
						DbSelectArea("TRB")
						If RecLock("TRB",.T.)
							TRB->BGH_MODELO   	:= ( _cAlias )->(ZZ4_CODPRO)
							TRB->BGH_IMEI   	:= ( _cAlias )->(ZZ4_IMEI) 
							TRB->BGH_OS   		:= ( _cAlias )->(ZZ4_OS)						
							TRB->BGH_DATA   	:= dDataBase
							TRB->BGH_HORA       := SUBSTR(Time(), 1, 2)+ ":" +SUBSTR(Time(), 4, 2)
							TRB->BGH_USER		:= cUserName	
							TRB->BGH_STATUS		:= cStatus 
							TRB->BGH_MASTER		:= cValtoChar(( _cAlias )->(ZZ4_ETQMEM))
							TRB->BGH_DTINV   	:= cData							
							TRB->BGH_RUA   		:= ( _cAlias )->(ZZ4_ENDES)
							TRB->BGH_PALETE   	:= ( _cAlias )->(ZZ4_PALLET)														
						   	TRB->(MsUnlock())
					   	EndIf
						ADDACOLS(2,lProd,( _cAlias )->(ZZ4_IMEI),Nil,lRecontagem,0) 
					EndIf	
							
			
				( _cAlias )->( DbSkip() )
				
				EndDo
			Else
				MsgAlert("Nenhum Imei encontrado para esta Master.") 
				_cMaster  := Space(20)
				oGetDadM1:Refresh()
				oGetIme:SetFocus()
				Return
			EndIf	
		
		EndIf				
		
	Endif
	
	If lProd
		_cImei  := Space(20) 
	Else
		_cMaster := Space(20)
	EndIf
	
	oGetDadM1:Refresh()
	If lProd
		oGetIme:SetFocus()
		If !llApont 
			oSayDCont:Refresh()
		Else
			llApont := .F.	
		EndIf	
	Else 
		If !lExist
			oGetIme:Disable()
			oSayDLoc:Refresh()
			oSayDCont:Refresh()
		EndIf	
	EndIf 
EndIf    

Return 

Static Function DocCaixa() 

Local cQuery	:= "" 
Local _cAlDocCx	:= GetNextAlias()
Local cNextDoc	:= ""  

cQuery := "	SELECT MAX(ZB0_DOC) AS ZB0_DOC FROM " + RetSqlName("ZB0") + CRLF 
cQuery += " 	WHERE (ZB0_DOCMAS = '' OR ZB0_DOCMAS = '" + cDocMestre + "' )" + CRLF
cQuery += " 	AND ZB0_FILIAL = '" +xFilial("ZB0")+ "' " + CRLF
cQuery += " 	AND D_E_L_E_T_ <> '*' " + CRLF 

cQuery := ChangeQuery(cQuery) 
If Select(_cAlDocCx) > 0;( _cAlDocCx )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlDocCx, .t., .t.)
( _cAlDocCx )->( dbGoTop() )
If( ( _cAlDocCx )->( !Eof() ) )	     
	cNextDoc := SOMA1(( _cAlDocCx )->(ZB0_DOC))
EndIf 
Return cNextDoc 
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProxNum()

Local cQuery	:= "" 
Local _cAlNum	:= GetNextAlias()
Local cNextNum	:= ""

cQuery := " SELECT MAX(ZB0_NUMCON) FROM " + RetSqlName("ZB0") + CRLF 
cQuery += " WHERE ZB0_FILIAL = '" +xFilial("ZB0")+ "' AND ZB0_IMEI = '"+ZZ4->ZZ4_IMEI+"' " + CRLF
cQuery += " AND ZB0_MASTER = '" + AvKey("0","ZB0_MASTER") + "' " + CRLF
cQuery += " AND ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF 
cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF 

cQuery := ChangeQuery(cQuery) 
If Select(_cAlNum) > 0;( _cAlNum )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlNum, .t., .t.)
( _cAlNum )->( dbGoTop() )
If( ( _cAlNum )->( !Eof() ) )	     
	cNextNum := SOMA1(( _cAlNum )->(ZB0_NUMCON))
EndIf 
Return cNextNum 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncConfir(lProd)	
    
	Local aTrb	:= {}
	
	DbSelectArea("TRB")
	TRB->(DbGotop())
	
	While TRB->(!EOF())	
		aAdd(aTrb,{TRB->BGH_IMEI,TRB->BGH_MASTER})		
		TRB->(DbSkip())
	EndDo
	
	cQuery := " SELECT R_E_C_N_O_ AS ZB0_RECNO FROM " + RetSqlName("ZB0") + CRLF
	cQuery += " (NOLOCK) WHERE ZB0_IMEI IN ( "  + CRLF 	
	For nx:=1 To Len(aTrb)	
		If nx == Len(aTrb) 
			cQuery += "'" + aTrb[nx][1] + "')" + CRLF 
		Else
			cQuery += "'" + aTrb[nx][1] + "'," + CRLF 
		EndIf	
	Next nx 
	cQuery += " AND ZB0_MASTER IN ( "  + CRLF
	For nx:=1 To Len(aTrb)	
		If nx == Len(aTrb) 
			cQuery += "'" + aTrb[nx][2] + "')" + CRLF 
		Else
			cQuery += "'" + aTrb[nx][2] + "'," + CRLF 
		EndIf	
	Next nx
	cQuery += " AND ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF 
	cQuery += " AND ZB0_DOC = '" + cNumDoc + "' " + CRLF
	cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
	cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " 
	
	cQuery := ChangeQuery(cQuery) 
	If Select("TRB3") > 0;TRB3->(dbCloseArea());EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "TRB3", .t., .t.)
	TRB3->(dbGoTop())  
	
	While TRB3->(!EOF())	
	
		If Select("ZB0") == 0
			DbSelectArea("ZB0")
		EndIf
		ZB0->(DbGotop())
		ZB0->(dbGoTo(TRB3->ZB0_RECNO)) 		
	
		If RecLock("ZB0",.F.)
			ZB0->ZB0_CONFIR := "1" 
			ZB0->ZB0_CONTAG := nVarCont					 
			ZB0->(MsUnlock())
		EndIf			
	
		TRB3->(DbSkip())
	EndDo
	
	If MsgYesNo("Gerar Etiqueta ?")
		U_GeraEtiq(lProd,.F.)
	EndIf			 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenZZO  บ Autor ณLuciano Siqueira    บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLegenda                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LegenZB0()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Legenda                                                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCorDesc := {	{"BR_AMARELO"   , "Entrada Apontada" 	   			},;
				{"BR_AZUL"		, "Entrada Confirmada"				},; 
				{"BR_CINZA"		, "Em Poder do Estoque"				},;
				{"BR_LARANJA"	, "Em Poder da Producao"			},;
				{"BR_MARROM"	, "OS Encerrada"					},;
				{"BR_PINK"		, "Saida Lida"						},;
				{"BR_PRETO"		, "Saida Apontada"					},;
				{"BR_VERDE"		, "PV Gerado"						},;
				{"BR_VERMELHO"	, "NFS Gerada"						},;
				{"BR_BRANCO"	, "Imei nao encontrado no sistema"	}}
				 					

BrwLegenda(cCadastro, "Status", aCorDesc )

Return ( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADDACOLS  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDACOLS(nParam,lProd,cImei,lRetCont,lRecontagem,nOpRec)

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local aCampos	 := TRB->(dbStruct())  
Local lAchou 	 := .F.

Default lRetCont := .F.

If !lRetCont
	If nParam == 1
	
		AAdd(aColsM1, Array(nQtdM1+1))
		nColuna := Len(aColsM1)	
		aColsM1[nColuna][1]:="BR_BRANCO"	
		For nM := 2 To Len(aCampos)		
			aColsM1[nColuna][nM] := ""		
		Next nM
		aColsM1[nColuna][nQtdM1+1]  := .F. 		
		
		If lRecontagem			
			cRua	:= oGetnaoconf:acols[oGetnaoconf:nat][3]
			cPalete	:= oGetnaoconf:acols[oGetnaoconf:nat][4]
			cCaixa	:= oGetnaoconf:acols[oGetnaoconf:nat][5]
			cDescLoc:= oGetnaoconf:acols[oGetnaoconf:nat][6]			
			cModel  := oGetnaoconf:acols[oGetnaoconf:nat][10]
			nVarCont:= 0 
			If nOpRec == 1
				oSayDRua:Refresh()
				oSayDPal:Refresh()
				oSayDCai:Refresh()
				oSayDLoc:Refresh()
				oSayDCont:Refresh()
				oSayDMod:Refresh()
			EndIf	
		EndIf	
		
	ElseIf nParam == 2	  
	
		dbSelectArea("TRB")
		DbGoTop()
		If dbSeek(TRB->BGH_MASTER+cImei)
			lAchou := .T.
		EndIf	
		If lAchou
			If !(Len(oGetDadM1:aCols) == 1 .and. Empty(oGetDadM1:aCols[1][3]))
				AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
			EndIf
			nColuna := Len(oGetDadM1:aCols)
			Do Case  
			Case Alltrim(cNumSta)=="1"
				oGetDadM1:aCols[nColuna][1]:="BR_AMARELO" 
			Case Alltrim(cNumSta)=="2"
				oGetDadM1:aCols[nColuna][1]:="BR_AZUL"
			Case Alltrim(cNumSta)=="3"
				oGetDadM1:aCols[nColuna][1]:="BR_CINZA"
			Case Alltrim(cNumSta)=="4"
				oGetDadM1:aCols[nColuna][1]:="BR_LARANJA"
			Case Alltrim(cNumSta)=="5"
				oGetDadM1:aCols[nColuna][1]:="BR_MARROM"
			Case Alltrim(cNumSta)=="6"
				oGetDadM1:aCols[nColuna][1]:="BR_PINK"
			Case Alltrim(cNumSta)=="7"
				oGetDadM1:aCols[nColuna][1]:="BR_PRETO"
			Case Alltrim(cNumSta)=="8"
				oGetDadM1:aCols[nColuna][1]:="BR_VERDE"
			Case Alltrim(cNumSta)=="9"
				oGetDadM1:aCols[nColuna][1]:="BR_VERMELHO"	
			Case Alltrim(cNumSta)=="0"
				oGetDadM1:aCols[nColuna][1]:="BR_BRANCO"	
			EndCase	  
			
			For nM := 1 To Len(aCampos)
				cCpoTRB := "TRB->" + aCampos[nM][1]
				_cConteudo := &cCpoTRB
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPreenche o acols ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
				If nPos > 0
					oGetDadM1:aCols[nColuna][nPos] := _cConteudo
				EndIf
			Next nM
			oGetDadM1:aCols[nColuna][nQtdM1+1]  := .F.
		Endif
	EndIf		
Else
	If nParam == 1
		ExeConf(lProd,lRetCont,lRecontagem) 
		
	ElseIf nParam == 2 
		If !(Len(oGetDadM1:aCols) == 1 .and. Empty(oGetDadM1:aCols[1][3]))
			AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
		EndIf	
		nColuna := Len(oGetDadM1:aCols)
		Do Case  
			Case TRB->BGH_NUMSTA=="1"
				oGetDadM1:aCols[nColuna][1]:="BR_AMARELO" 
			Case TRB->BGH_NUMSTA=="2"
				oGetDadM1:aCols[nColuna][1]:="BR_AZUL"
			Case TRB->BGH_NUMSTA=="3"
				oGetDadM1:aCols[nColuna][1]:="BR_CINZA"
			Case TRB->BGH_NUMSTA=="4"
				oGetDadM1:aCols[nColuna][1]:="BR_LARANJA"
			Case TRB->BGH_NUMSTA=="5"
				oGetDadM1:aCols[nColuna][1]:="BR_MARROM"
			Case TRB->BGH_NUMSTA=="6"
				oGetDadM1:aCols[nColuna][1]:="BR_PINK"
			Case TRB->BGH_NUMSTA=="7"
				oGetDadM1:aCols[nColuna][1]:="BR_PRETO"
			Case TRB->BGH_NUMSTA=="8"
				oGetDadM1:aCols[nColuna][1]:="BR_VERDE"
			Case TRB->BGH_NUMSTA=="9"
				oGetDadM1:aCols[nColuna][1]:="BR_VERMELHO"	
			Case TRB->BGH_NUMSTA=="0"
				oGetDadM1:aCols[nColuna][1]:="BR_BRANCO"	
		EndCase	
		
		For nM := 1 To Len(aCampos)
			cCpoTRB := "TRB->" + aCampos[nM][1]
			_cConteudo := &cCpoTRB
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPreenche o acols ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
			If nPos > 0
				oGetDadM1:aCols[nColuna][nPos] := _cConteudo
			EndIf
		Next nM
		oGetDadM1:aCols[nColuna][nQtdM1+1]  := .F.	
	EndIf
		
EndIf	

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
Static Function ValPerg(cPerg) 

    If SX1->(!dbSeek(cPerg))                                                                                                                                                                                      
		PutSx1(cPerg,"01","Data Invent. ?"	, "Data Invent. ?"	, "Data Invent. ?"	, "mv_ch1","D",08,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","")
	EndIf	
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarPalet  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function CarPalet() 

	Local cQuery  := "" 
	Local cPalete := "01"
	Local _cAlias := GetNextAlias()

	cQuery := " SELECT TOP 1 ZB0.ZB0_PALETE FROM " + RetSqlName("ZB0") + " ZB0 (NOLOCK) WHERE ZB0.ZB0_PALETE = " + CRLF	
	cQuery += " ( SELECT MAX(ZB0_PALETE) FROM " + RetSqlName("ZB0") + " ZB0REC (NOLOCK) " + CRLF
	cQuery += " 	WHERE ZB0REC.ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " 	AND ZB0REC.D_E_L_E_T_ <> '*'  " + CRLF
	cQuery += " 	AND ZB0REC.ZB0_LOCAL = '" + cLocal + "' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_RUA = '" + cRua + "' )" + CRLF
	cQuery += " 	AND ZB0.ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " 	AND ZB0.D_E_L_E_T_ <> '*'  

	cQuery := ChangeQuery(cQuery) 
	If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
	( _cAlias )->( dbGoTop() )
	If( ( _cAlias )->( !Eof() ) )	     
		cPalete := SOMA1(( _cAlias )->(ZB0_PALETE))
	EndIf	
	
Return cPalete
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarCaixa  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function CarCaixa()
	
	Local cQuery  := "" 
	Local cCaixa  := "01"  
	Local _cAlias := GetNextAlias()

	cQuery := " SELECT TOP 1 ZB0.ZB0_CAIXA FROM " + RetSqlName("ZB0") + " ZB0 (NOLOCK) WHERE ZB0.ZB0_CAIXA = " + CRLF	
	cQuery += " ( SELECT MAX(ZB0_CAIXA) FROM " + RetSqlName("ZB0") + " ZB0REC (NOLOCK) " + CRLF
	cQuery += " 	WHERE ZB0REC.ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " 	AND ZB0REC.D_E_L_E_T_ <> '*' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_LOCAL = '" + cLocal + "' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_RUA = '" + cRua + "' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_DOCMAS = '" + cDocMestre + "' " + CRLF 
	cQuery += " 	AND ZB0REC.ZB0_PALETE = '" + cPalete + "' )" + CRLF
	cQuery += " 	AND ZB0.ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " 	AND ZB0.D_E_L_E_T_ <> '*'  

	cQuery := ChangeQuery(cQuery) 
	If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
	( _cAlias )->( dbGoTop() )
	If( ( _cAlias )->( !Eof() ) )	     
		cCaixa := SOMA1(( _cAlias )->(ZB0_CAIXA))
	EndIf
	
Return cCaixa 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ RELCONF	 ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Relat๓rio Valor Unitแrio SBF (TReport)	                   ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RELINVNXT(lProd)

Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690") 

If !(__cUserId $ cUserExc)
	MsgStop("Usuario sem permissใo para acessar relat๓rio.","Aten็ใo")
Else 
	If FindFunction("TRepInUse") 
		IMPREL(lProd)
	EndIf
EndIf	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ IMPREL	 ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Perguntas e valida็ใo                                       ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function IMPREL(lProd)	
	Local oReport 	:= NIL
	Local cPerg 	:= "INVRNXT"
	Local llEmpty	:= .T.	
	    
	AjustaSx1(cPerg)
	While llEmpty
		If Pergunte(cPerg,.T.)
			If !(llEmpty := !(KZVALIDPAR()))
		   		oReport := ReportDef(cPerg,lProd)
		   		oReport :PrintDialog()	
			EndIf
		Else
			llEmpty	:= .F.			
		EndIf
	EndDo
		
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ReportDef ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ M้todo TReport		                                       ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef(clPerg,lProd)

	Local oReport	:= Nil
	Local oSection	:= Nil 
	
	If lProd
		oReport := TReport():New("INVPNXT","Inventario Nextel Produ็ใo",clPerg,{|oReport| PrintReport(oReport,lProd)},"Este relatorio ira imprimir Inventario Nextel para Produ็ใo") 
	Else
		oReport := TReport():New("INVENXT","Inventario Nextel Estoque",clPerg,{|oReport| PrintReport(oReport,lProd)},"Este relatorio ira imprimir Inventario Nextel para Estoque") 
	EndIf  
	oReport:SetLandscape()  
  	oSection1 := TRSection():New(oReport ,"",{"QRY"}) 

Return oReport
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ PrintReport Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Imprime relat๓rio	                                       ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PrintReport(oReport,lProd)
 
	Local oSection1	:= oReport:Section(1)
	Local _cQuery	:= ""  
	Local cDataDe	:= DTOS(MV_PAR01) 
	Local cDataAte	:= DTOS(MV_PAR02) 
	Local oBreak	:= Nil

	If !KZVALIDPAR()
		Return
	EndIf	
	
	_cQuery := " 	SELECT * FROM " + RetSqlName("ZB0") + " (NOLOCK) " + CRLF
	_cQuery += " 	  WHERE ZB0_DTINV BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'   " + CRLF
	If lProd 
		_cQuery += "  	AND ZB0_MASTER = '0' " + CRLF
	Else
		_cQuery += "  	AND ZB0_MASTER <> '0' " + CRLF	
	EndIf	
	_cQuery += " 	 	AND D_E_L_E_T_ <> '*'  " + CRLF	
	_cQuery += " 	 	AND ZB0_FILIAL = '" + xFilial("ZB0") + "'  " + CRLF  
	_cQuery += " 	 	ORDER BY ZB0_DTINV " + CRLF 
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSecao                							             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู     
	
	TRCell():New(oSection1,"ZB0_DOCMAS" 	,"QRY" 		,OEMTOANSI("Mestre Invent.")	,"@!"					,20)
	TRCell():New(oSection1,"ZB0_DOC" 		,"QRY" 		,OEMTOANSI("Docum.Caixa")		,"@!"					,20)
	If !lProd
		TRCell():New(oSection1,"ZB0_MASTER" ,"QRY" 		,OEMTOANSI("Master")			,"@!"					,20)
	EndIf	 
	TRCell():New(oSection1,"ZB0_MODELO" 	,"QRY" 		,OEMTOANSI("Modelo")			,"@!"					,20)
	TRCell():New(oSection1,"ZB0_IMEI"		,"QRY" 		,OEMTOANSI("IMEI")				,"@!"					,25) 	
	TRCell():New(oSection1,"ZB0_NUMOS"		,"QRY" 		,OEMTOANSI("Numero OS")			,"@!"					,20) 	
	TRCell():New(oSection1,"ZB0_LOCAL"		,"" 		,OEMTOANSI("Local")				,"@!"					,40)
	TRCell():New(oSection1,"ZB0_RUA"		,"QRY" 		,OEMTOANSI("Rua")				,"@!"					,10)
	TRCell():New(oSection1,"ZB0_PALETE"		,"QRY" 		,OEMTOANSI("Palete")			,"@!"					,10)
	TRCell():New(oSection1,"ZB0_CAIXA"		,"QRY" 		,OEMTOANSI("Caixa")				,"@!"					,20)	
	TRCell():New(oSection1,"ZB0_DSCSTA"		,"QRY" 		,OEMTOANSI("Status")			,"@!"					,40)		
	TRCell():New(oSection1,"DATA"			,"QRY" 		,OEMTOANSI("Data Inclusao")		,						,20	,,{||STOD(QRY->ZB0_DATA)})
	TRCell():New(oSection1,"ZB0_HORA" 		,"QRY" 		,OEMTOANSI("Hora Inclusao")		,"@!"					,20)
	TRCell():New(oSection1,"ZB0_USER" 		,"QRY" 		,OEMTOANSI("Usuario")			,"@!"					,30)
	TRCell():New(oSection1,"DATAINV"		,"QRY" 		,OEMTOANSI("Data Inventario")	,						,20	,,{||STOD(QRY->ZB0_DTINV)})
	
	oSection1:Init()
	While  QRY->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
	
		oSection1:Cell("ZB0_LOCAL"):SetValue(AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IN'+QRY->ZB0_LOCAL, "X5_DESCRI")))	 
		oSection1:Cell("DATAINV"):SetLineBreak()
		oSection1:PrintLine()		
		QRY->(DbSkip())
	
	EndDo
	oSection1:Finish()	 			
		
	QRY->(DbCloseArea())

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSx1 ณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria as perguntas	                                       ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSx1(cPerg)

	SX1->(dbSetOrder(1))
	If !SX1->(dbSeek(cPerg))
		PutSx1(cPerg,"01",OEMTOANSI("Dt. Invent. De ?"	)	,OEMTOANSI("Dt. Invent. De ?"	)  	,OEMTOANSI("Dt. Invent. De ?"	)  			,"MV_CH1"	,"D",8	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","") 
		PutSx1(cPerg,"02",OEMTOANSI("Dt. Invent. At้ ?"	)	,OEMTOANSI("Dt. Invent. At้ ?"	)  	,OEMTOANSI("Dt. Invent. At้ ?"	)  			,"MV_CH2"	,"D",8	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
	EndIf 
			   	
Return Nil                                                                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ KZVALIDPARณ Autor ณ Vinicius Leonardo   ณ Data ณ 09/04/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Valida็ใo das perguntas                                     ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function KZVALIDPAR()

	Local llRet := .T.

	If 	Empty(MV_PAR01) .AND. ;
		Empty(MV_PAR02) 
				  
	    MsgInfo(OEMTOANSI("Todos os campos estใo em branco. Preencha pelo menos um parโmetro."))
		llRet := .F.
				
	EndIf
	
Return llRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaPar()

	Local aPosObj    	:= {}
	Local aObjects   	:= {}
	Local aSize      	:= MsAdvSize()
	Local cLinOK     	:= "AllwaysTrue"
	Local cTudoOK       := "AllwaysTrue"
	Local aButtons    	:= {}
	Local oDlgPar  	

	DEFINE MSDIALOG oDlgPar TITLE "Parametros" FROM aSize[7], 0 TO  300,  500 OF oMainWnd PIXEL 
	
	//DEFINE MSDIALOG oDlgPar TITLE "Parametros" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL
	
	aObjects := {}
	
	aAdd( aObjects, {100,100, .T., .T.})
	aAdd( aObjects, {100,100, .T., .T.})
	
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj		:= MsObjSize( ainfo, aObjects )
	
	@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[1,3]-125,aPosObj[1,4]-5 LABEL "" OF oDlgPar PIXEL     	
	
	oSayData := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+010,{||"Data Inventario ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetData := tGet():New( aPosObj[1,1]+20,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cData := u, cData)},oDlgPar,60,,"@D",,,,,,,.T.,,,,,,,,,"","cData")
	oGetData:bChange := {|| cPalete := U_CarPalet(),cCaixa := U_CarCaixa() }
	
	oSayLocal := TSay():New( aPosObj[1,1]+40,aPosObj[1,2]+010,{||"Local ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetLocal := tGet():New( aPosObj[1,1]+40,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cLocal := u, cLocal)},oDlgPar,60,,"@!",,,,,,,.T.,,,,,,,,,"IN","cLocal")
    oGetLocal:bChange := {|| cPalete := U_CarPalet(),cCaixa := U_CarCaixa() }
    oGetLocal:bValid  := {|| Iif (!Empty(AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IN'+cLocal, "X5_DESCRI"))),.T.,.F.)}
    
	oSayRua := TSay():New( aPosObj[1,1]+60,aPosObj[1,2]+010,{||"Rua ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetRua := tGet():New( aPosObj[1,1]+60,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cRua := u, cRua)},oDlgPar,60,,"@!",,,,,,,.T.,,,,,,,,,"","cRua")
	oGetRua:bChange := {|| cPalete := U_CarPalet(),cCaixa := U_CarCaixa() }    

	oSayPalete := TSay():New( aPosObj[1,1]+80,aPosObj[1,2]+010,{||"Palete ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetPalete := tGet():New( aPosObj[1,1]+80,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cPalete := u, cPalete)},oDlgPar,60,,"@!",,,,,,,.T.,,,,,,,,,"","cPalete")
	oGetPalete:bChange := {|| cCaixa := U_CarCaixa() }

	oSayCaixa := TSay():New( aPosObj[1,1]+100,aPosObj[1,2]+010,{||"Caixa ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetCaixa := tGet():New( aPosObj[1,1]+100,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cCaixa := u, cCaixa)},oDlgPar,60,,"@!",,,,,,,.T.,,,,,,,.T.,,"","cCaixa") 	
	
	oSayModel := TSay():New( aPosObj[1,1]+120,aPosObj[1,2]+010,{||"Modelo ?"},oDlgPar,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016) 	
	oGetModel := tGet():New( aPosObj[1,1]+120,aPosObj[1,2]+080,{|u| Iif( PCount() > 0, cModel := u, cModel)},oDlgPar,60,,"@!",,,,,,,.T.,,,,,,,,,"IM","cModel")
	oGetModel:bValid  := {|| Iif (!Empty(AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IM'+cModel, "X5_DESCRI"))),.T.,.F.)}
	
	ACTIVATE MSDIALOG oDlgPar ON INIT EnchoiceBar(oDlgPar,{|| oDlgPar:End()},{|| llFecha:= .T.,oDlgPar:End()},,) 

Return  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExcZB0(lProd)

	Local _stru		:= {}
	Local aCpoBro	:= {}
	Local oDlg
	Local aCores 	:= {}  	
	Local cPerg 	:= "" 
	Local aSize 	:= MsAdvSize()
	Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690") 
	Local lMestre
	
	Private lInverte:= .F.
	Private cMark   := GetMark()   
	Private oMark

	If !(__cUserId $ cUserExc)
		MsgStop("Usuario sem permissใo para efetuar exclusใo.","Aten็ใo")
	Else 
	 
	If MsgYesNo("Excluir por Mestre ou por Documentos Caixa?"+CRLF+"Sim para exclusใo por Mestre e Nใo para Documentos Caixa.") 
		cPerg 	:= "INVPEXC"
		lMestre := .T. 
	Else
		cPerg 	:= "INVEEXC"  
		lMestre := .F.
	EndIf	 
	
	PergExc(cPerg,lMestre)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf 
	
	FTRBEXC() 
	
	cQuery := " SELECT * FROM " + RetSqlName("ZB0") + CRLF
	cQuery += " WHERE " + CRLF
	If lMestre 
		cQuery += " ZB0_DOCMAS BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF 
	Else
		cQuery += " ZB0_DOCMAS BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF 
		cQuery += " AND ZB0_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF 
	EndIf
	cQuery += " AND ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " AND D_E_L_E_T_ <> '*' " + CRLF
	
	If Select("QRYEXC") > 0
		QRYEXC->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRYEXC", .T., .T. ) 	
	
	QRYEXC->(dbGoTop())
	While QRYEXC->(!Eof()) 	     
		DbSelectArea("TRB")	
		RecLock("TRB",.T.)		
		TRB->BGH_MODELO	:=  QRYEXC->ZB0_MODELO		
		TRB->BGH_IMEI	:=  QRYEXC->ZB0_IMEI		
		TRB->BGH_OS    	:=  QRYEXC->ZB0_NUMOS		
		TRB->BGH_DATA 	:=  STOD(QRYEXC->ZB0_DATA)		
		TRB->BGH_HORA	:=  QRYEXC->ZB0_HORA		
		TRB->BGH_USER  	:= 	QRYEXC->ZB0_USER	 
		TRB->BGH_STATUS := 	QRYEXC->ZB0_DSCSTA
		TRB->BGH_MASTER := 	QRYEXC->ZB0_MASTER 
		TRB->BGH_DTINV  := 	STOD(QRYEXC->ZB0_DTINV)				 
		TRB->BGH_DOCMAS := 	QRYEXC->ZB0_DOCMAS				
		TRB->BGH_DOC	:= 	QRYEXC->ZB0_DOC				
		TRB->(MsunLock())
		QRYEXC->(dbSkip())
	EndDo			
	
	//Define quais colunas (campos da TRB) serao exibidas na MsSelect
	
	aCpoBro	:= {{ "OK"			,, ""           		,"@!"},;
				{ "BGH_MODELO"	,, "Modelo"         	,"@!"},;
				{ "BGH_IMEI"	,, "Imei"           	,"@!!"},;
				{ "BGH_OS"		,, "OS"           		,"@!"},;
				{ "BGH_DATA"	,, "Data Inclusใo"		,"@D"},; 
				{ "BGH_HORA"	,, "Hora Inclusใo"		,"@!"},;
				{ "BGH_USER"	,, "Usuแrio"			,""},;
				{ "BGH_STATUS"	,, "Status"				,""},; 
				{ "BGH_MASTER"	,, "Master"   			,"@!"},;
				{ "BGH_DTINV"	,, "Data Inventแrio"	,"@D"},;
				{ "BGH_DOCMAS"	,, "Mestre"				,"@!"},;
				{ "BGH_DOC"		,, "Docum.Caixa"		,"@!"}}
				
	//Cria uma Dialog
	
	DEFINE MSDIALOG oDlg TITLE "Inventario Nextel - Exclusใo" From aSize[7],0 to aSize[6],aSize[5] PIXEL
	
		DbSelectArea("TRB")
		DbGotop()
		
		//Cria a MsSelect
		oMark := MsSelect():New("TRB","OK","",aCpoBro,@lInverte,@cMark,{005,005,230,650},,,,,)
		
		oMark:oBrowse:lHasMark    := .t.
		oMark:oBrowse:lCanAllMark := .t.
		Eval(oMark:oBrowse:bGoTop)
		oMark:oBrowse:bAllMark := { || Disp(1,.T.) }
		oMark:oBrowse:bLDblClick:={||Disp(2,.T.)}
		oMark:oBrowse:Refresh() 
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| ExcInv(),oDlg:End()},{|| oDlg:End()})
	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	
	TRB->(DbCloseArea()) 

EndIf	

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Funcao executada ao Marcar/Desmarcar um registro.   
Static Function Disp(nOpc,llExc)
Local cDoc := ""

If llExc
	If nOpc == 1 // Marcar todos 
		TRB->(DbGotop())
		Do While TRB->(!EOF())
			RecLock("TRB",.F.)
			TRB->OK := Iif(TRB->OK==cMark,"",cMark)
			TRB->(MsUnlock())
			TRB->(DbSkip())
		Enddo
		dbGoTop()
	Elseif nOpc == 2  // Marcar somente o registro posicionado
		RecLock("TRB",.F.)
		TRB->OK := Iif(TRB->OK==cMark,"",cMark)
		TRB->(MSUNLOCK())
	Endif
Else
	If nOpc == 1 // Marcar todos 	
		TRB->(DbGotop())
		Do While TRB->(!EOF())		
			//If TRB->BGH_SITUAC == AvKey("Analisar","B1_DESC")
				RecLock("TRB",.F.)
				TRB->OK := Iif(TRB->OK==cMark,"",cMark)
				TRB->(MsUnlock())				
			//EndIf	
			//cDoc:=TRB->BGH_DOC
			TRB->(DbSkip())
		Enddo
		dbGoTop()
	Elseif nOpc == 2  // Marcar somente o registro posicionado
		RecLock("TRB",.F.)
		TRB->OK := Iif(TRB->OK==cMark,"",cMark)
		TRB->(MSUNLOCK())
	Endif
EndIf	
		
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FTRBEXC()

Local _aStru := {}

AADD(_aStru,{"OK"     		,"C",2						,0})
AADD(_aStru,{"BGH_MODELO"	,"C",TamSX3("ZB0_MODELO")[1],0})
AADD(_aStru,{"BGH_IMEI"		,"C",TamSX3("ZB0_IMEI")[1],0})
AADD(_aStru,{"BGH_OS"	    ,"C",TamSX3("ZB0_NUMOS")[1],0})
AADD(_aStru,{"BGH_DATA"		,"D",TamSX3("ZB0_DATA")[1],0})
AADD(_aStru,{"BGH_HORA"		,"C",TamSX3("ZB0_HORA")[1],0})
AADD(_aStru,{"BGH_USER"		,"C",TamSX3("ZB0_USER")[1],0})
AADD(_aStru,{"BGH_STATUS"	,"C",TamSX3("B1_DESC")[1],0})
AADD(_aStru,{"BGH_MASTER"	,"C",TamSX3("ZB0_MASTER")[1],0}) 
AADD(_aStru,{"BGH_DTINV"	,"D",TamSX3("ZB0_DTINV")[1],0})
AADD(_aStru,{"BGH_DOCMAS"	,"C",TamSX3("ZB0_DOCMAS")[1],0}) 
AADD(_aStru,{"BGH_DOC"		,"C",TamSX3("ZB0_DOC")[1],0}) 

_cArq     := CriaTrab(_aStru,.T.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif  

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcInv()

	DbSelectArea("TRB")
	TRB->(DbGotop())
	
	While TRB->(!EOF())

		If TRB->OK == cMark  
		
			DbSelectArea("ZB0")
			ZB0->(DbSetOrder(1))
			ZB0->(DbGotop())  
			                
			If ZB0->(DbSeek(xFilial("ZB0")+TRB->BGH_DOCMAS+TRB->BGH_DOC+TRB->BGH_MASTER+TRB->BGH_IMEI))			
				If RecLock("ZB0",.F.)
					ZB0->(dbdelete()) 
					ZB0->(MsUnlock())
				EndIf			
			EndIf	
		
		EndIf
		TRB->(DbSkip())
	EndDo

Return
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergExc   บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
Static Function PergExc(cPerg,lMestre) 
    
	If !lMestre
		If SX1->(!dbSeek(cPerg)) 
		
			PutSx1(cPerg,"01","Mestre De ?"			, "Mestre De ?"			, "Mestre De ?"			, "mv_ch1","C",03,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"02","Mestre At้ ?"		, "Mestre At้ ?"		, "Mestre At้ ?"		, "mv_ch2","C",03,0,0,"G",""		,""		,"","","mv_par02","","","",""			,"","","","","","","","","","","","","","","","")
		                                                                                                                                                                                     
			PutSx1(cPerg,"03","Documento De ?"		, "Documento De ?"		, "Documento De ?"		, "mv_ch3","C",09,0,0,"G",""		,""		,"","","mv_par03","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"04","Documento At้ ?"		, "Documento At้ ?"		, "Documento At้ ?"		, "mv_ch4","C",09,0,0,"G",""		,""		,"","","mv_par04","","","",""			,"","","","","","","","","","","","","","","","")
		EndIf		 
	Else	
		If SX1->(!dbSeek(cPerg)) 
			PutSx1(cPerg,"01","Mestre De ?"			, "Mestre De ?"			, "Mestre De ?"			, "mv_ch1","C",03,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"02","Mestre At้ ?"		, "Mestre At้ ?"		, "Mestre At้ ?"		, "mv_ch2","C",03,0,0,"G",""		,""		,"","","mv_par02","","","",""			,"","","","","","","","","","","","","","","","")
		EndIf		
	EndIf		
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ValRej(lProd) 

Local aCpoBro	:= {}
Local oDlg
Local aCores 	:= {}  	
Local cPerg 	:= "" 
Local aSize 	:= MsAdvSize()
Local _aStru	:= {}
Local cQuery 	:= "" 
Local _cAlias	:= GetNextAlias()
Local aButtons  := {}
Local cUserExc	:= SuperGetMv("BH_USINEXC",,"001015;001588;000690") 

Private lInverte:= .F.
Private cMark   := GetMark()   
Private oMark 

If !(__cUserId $ cUserExc)
	MsgStop("Usuario sem permissใo para acesso.","Aten็ใo")
Else 

	If lProd
		cPerg 	:= "INVPVR" 
	Else
		Return		
	EndIf
	PergVR(cPerg,lProd)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf 
	
	AADD(_aStru,{"OK"     		,"C",2					,0}) 
	AADD(_aStru,{"BGH_DOCMAS"	,"C",TamSX3("ZB0_DOCMAS")[1],0})
	AADD(_aStru,{"BGH_DOC"		,"C",TamSX3("ZB0_DOC")[1],0})
	AADD(_aStru,{"BGH_LOCAL"	,"C",TamSX3("B1_DESC")[1],0})
	AADD(_aStru,{"BGH_RUA"	    ,"C",TamSX3("ZB0_RUA")[1],0})
	AADD(_aStru,{"BGH_PALETE"	,"C",TamSX3("ZB0_PALETE")[1],0})
	AADD(_aStru,{"BGH_CAIXA"	,"C",TamSX3("ZB0_CAIXA")[1],0})
	AADD(_aStru,{"BGH_NUMCON"	,"C",TamSX3("ZB0_NUMCON")[1],0})
	AADD(_aStru,{"BGH_CONTAG"	,"N",TamSX3("ZB0_CONTAG")[1],0})
	AADD(_aStru,{"BGH_SITUAC"	,"C",TamSX3("B1_DESC")[1],0}) 
	
	_cArq     := CriaTrab(_aStru,.T.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif  
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	
	cQuery := " SELECT ZB0_DOCMAS, ZB0_DOC, ZB0_LOCAL, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_NUMCON, ZB0_CONTAG, ZB0_SITUAC FROM " + RetSqlName("ZB0") + " (NOLOCK) " + CRLF
	cQuery += " 	WHERE ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
	cQuery += " 	AND D_E_L_E_T_ <> '*' " + CRLF 
	cQuery += " 	AND ZB0_DOCMAS BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF 
	cQuery += " 	AND ZB0_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF  
	cQuery += " 	AND ZB0_FINALI <> 'S' " + CRLF  
	cQuery += " 	AND ZB0_CONFIR = '1' " + CRLF 
	cQuery += " GROUP BY ZB0_DOCMAS, ZB0_DOC, ZB0_LOCAL, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_NUMCON, ZB0_CONTAG, ZB0_SITUAC " + CRLF  
	cQuery += " 	ORDER BY ZB0_DOCMAS, ZB0_DOC " + CRLF 
	
	cQuery := ChangeQuery(cQuery) 
	If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
	( _cAlias )->( dbGoTop() )
	If( ( _cAlias )->( !Eof() ) ) 
		While ( ( _cAlias )->( !Eof() ) )
		
			If ( _cAlias )->( ZB0_SITUAC) == '0';cSituac:="Analisar";ElseIf ( _cAlias )->( ZB0_SITUAC) == '1';cSituac:="Conferencia";ElseIf ( _cAlias )->( ZB0_SITUAC) == '2';cSituac:="Rejeitado";EndIf 
			     
			DbSelectArea("TRB")	
			RecLock("TRB",.T.)
			TRB->BGH_DOCMAS	:=  ( _cAlias )->( ZB0_DOCMAS) 				
			TRB->BGH_DOC	:=  ( _cAlias )->( ZB0_DOC) 		
			TRB->BGH_LOCAL	:=  AllTrim(Posicione("SX5", 1, xFilial("SX5")+'IN'+( _cAlias )->( ZB0_LOCAL), "X5_DESCRI"))		
			TRB->BGH_RUA   	:=  ( _cAlias )->( ZB0_RUA)		
			TRB->BGH_PALETE	:=  ( _cAlias )->( ZB0_PALETE)		
			TRB->BGH_CAIXA	:=  ( _cAlias )->( ZB0_CAIXA)		
			TRB->BGH_NUMCON	:= 	( _cAlias )->( ZB0_NUMCON)
			TRB->BGH_CONTAG :=  ( _cAlias )->( ZB0_CONTAG)	 
			TRB->BGH_SITUAC := 	cSituac
							
			TRB->(MsunLock())			
			
			( ( _cAlias )->( DbSkip() ) )
		EndDo		
	EndIf	
	
	//Define quais colunas (campos da TRB) serao exibidas na MsSelect
	
	aCpoBro	:= {{ "OK"			,, ""           		,"@!"},; 
				{ "BGH_DOCMAS"	,, "Doc.Mestre"        	,"@!"},;
				{ "BGH_DOC"		,, "Doc.Caixa"         	,"@!"},;
				{ "BGH_LOCAL"	,, "Local"           	,"@!!"},;
				{ "BGH_RUA"		,, "Rua"           		,"@!"},;
				{ "BGH_PALETE"	,, "Palete"				,"@!"},; 
				{ "BGH_CAIXA"	,, "Caixa"				,"@!"},;
				{ "BGH_NUMCON"	,, "Contagem"			,""},;			
				{ "BGH_CONTAG"	,, "Qtd.Contada"		,""},;
				{ "BGH_SITUAC"	,, "Status"				,""}} 
				
	//Cria uma Dialog
	
	DEFINE MSDIALOG oDlg TITLE "Inventario Nextel - Valida็ใo/Rejei็ใo" From aSize[7],0 to aSize[6],aSize[5] PIXEL
	
		DbSelectArea("TRB")
		DbGotop()
		
		//Cria a MsSelect
		oMark := MsSelect():New("TRB","OK","",aCpoBro,@lInverte,@cMark,{005,005,230,650},,,,,)
		
		oMark:oBrowse:lHasMark    	:= .t.
		oMark:oBrowse:lCanAllMark 	:= .t.
		Eval(oMark:oBrowse:bGoTop)
		oMark:oBrowse:bAllMark		:= {|| Disp(1,.F.)}
		oMark:oBrowse:bLDblClick	:= {|| Disp(2,.F.)}
		oMark:oBrowse:Refresh() 
		
		@ 240,005 BUTTON "&Conferencia" SIZE 36,16 PIXEL ACTION AtuSta(1,lProd)
		@ 240,045 BUTTON "&Rejeita" 	SIZE 36,16 PIXEL ACTION AtuSta(2,lProd)
		@ 240,085 BUTTON "&Finaliza" 	SIZE 36,16 PIXEL ACTION AtuSta(3,lProd)
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()})
	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	
	TRB->(DbCloseArea())
	 
EndIf	

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSta(nOpc,lProd)

	Local cQuery := ""
	Local cAlAtu := GetNextAlias()

	If Select("ZB0") == 0					
		DbSelectArea("ZB0")
	EndIf
	ZB0->(dbSetOrder(1)) 

	TRB->(DbGotop())
	Do While TRB->(!EOF())
    	If TRB->OK==cMark  
    	
	    	cQuery := " SELECT ZB0_IMEI, ZB0_DTINV, ZB0_MASTER, ZB0_NUMCON, ZB0_MODELO, ZB0_DOCMAS, ZB0_DOC FROM " + RetSqlName("ZB0") + CRLF
	    	cQuery += " WHERE ZB0_DOC = '" + TRB->BGH_DOC + "' AND ZB0_NUMCON = '" + TRB->BGH_NUMCON + "' " + CRLF
	    	cQuery += " AND ZB0_DOCMAS = '" + TRB->BGH_DOCMAS + "' AND ZB0_FILIAL = '" + xFilial("ZB0") + "' AND D_E_L_E_T_ <> '*' "
	    	
	    	cQuery := ChangeQuery(cQuery) 
			If Select(cAlAtu) > 0;( cAlAtu )->( dbCloseArea() );EndIf
			dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), cAlAtu, .t., .t.)
			( cAlAtu )->( dbGoTop() )		    	  		
			
			If nOpc == 1        
				If( ( cAlAtu )->( !Eof() ) ) 
					While ( ( cAlAtu )->( !Eof() ) )
						ZB0->(dbGoTop())
						If ZB0->(dbSeek(xFilial("ZB0")+( cAlAtu )->( ZB0_DOCMAS)+( cAlAtu )->( ZB0_DOC)+( cAlAtu )->( ZB0_MASTER)+( cAlAtu )->( ZB0_IMEI)))
							If RecLock("ZB0",.F.)		
								ZB0->ZB0_SITUAC := '1'
								ZB0->(MSUNLOCK())
							EndIf
						EndIf 
						( ( cAlAtu )->( DbSkip() ) )
					EndDo	
					RecLock("TRB",.F.)			
					TRB->BGH_SITUAC := "Conferencia"
					TRB->(MSUNLOCK())							
				EndIf			
					
			ElseIf nOpc == 2
				If( ( cAlAtu )->( !Eof() ) ) 
					While ( ( cAlAtu )->( !Eof() ) )
						ZB0->(dbGoTop())
						If ZB0->(dbSeek(xFilial("ZB0")+( cAlAtu )->( ZB0_DOCMAS)+( cAlAtu )->( ZB0_DOC)+( cAlAtu )->( ZB0_MASTER)+( cAlAtu )->( ZB0_IMEI)))
							If RecLock("ZB0",.F.)		
								ZB0->ZB0_SITUAC := '2'
								ZB0->(MSUNLOCK())
							EndIf
						EndIf 
						( ( cAlAtu )->( DbSkip() ) )
					EndDo	
					RecLock("TRB",.F.)			
					TRB->BGH_SITUAC := "Rejeitado"
					TRB->(MSUNLOCK())							
				EndIf
				
			ElseIf nOpc == 3 
			
				If( ( cAlAtu )->( !Eof() ) ) 
					While ( ( cAlAtu )->( !Eof() ) )
						ZB0->(dbGoTop())
						If ZB0->(dbSeek(xFilial("ZB0")+( cAlAtu )->( ZB0_DOCMAS)+( cAlAtu )->( ZB0_DOC)+( cAlAtu )->( ZB0_MASTER)+( cAlAtu )->( ZB0_IMEI)))
							If RecLock("ZB0",.F.)		
								ZB0->ZB0_FINALI := 'S'
								ZB0->(MSUNLOCK())
							EndIf
						EndIf 
						( ( cAlAtu )->( DbSkip() ) )
					EndDo	
					RecLock("TRB",.F.)		
					TRB->(DbDelete())
					TRB->(MSUNLOCK())							
				EndIf					
			EndIf				
		EndIf
		TRB->(DbSkip())
	Enddo
	dbGoTop()	
	oMark:oBrowse:Refresh() 
		
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergVR(cPerg,lProd) 
	If lProd
		If SX1->(!dbSeek(cPerg))  
		
			PutSx1(cPerg,"01","Mestre De ?"			, "Mestre De ?"			, "Mestre De ?"			, "mv_ch1","C",03,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"02","Mestre At้ ?"		, "Mestre At้ ?"		, "Mestre At้ ?"		, "mv_ch2","C",03,0,0,"G",""		,""		,"","","mv_par02","","","",""			,"","","","","","","","","","","","","","","","")
		                                                                                                                                                                                 
			PutSx1(cPerg,"03","Documento De ?"		, "Documento De ?"		, "Documento De ?"		, "mv_ch3","C",09,0,0,"G",""		,""		,"","","mv_par03","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"04","Documento Ate ?"		, "Documento Ate ?"		, "Documento Ate ?"		, "mv_ch4","C",09,0,0,"G",""		,""		,"","","mv_par04","","","",""			,"","","","","","","","","","","","","","","","")
		EndIf
	Else 
	    If SX1->(!dbSeek(cPerg))                                                                                                                                                                                      
			PutSx1(cPerg,"01","Data Invent. ?"	, "Data Invent. ?"	, "Data Invent. ?"	, "mv_ch1","D",08,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","") 
			PutSx1(cPerg,"02","Master ?"		, "Master ?"		, "Master ?"		, "mv_ch2","C",12,0,0,"G",""		,""		,"","","mv_par02","","","",""			,"","","","","","","","","","","","","","","","")
		EndIf
	EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergExc   บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
Static Function PergEtq(cPerg)	
	If SX1->(!dbSeek(cPerg)) 
	
		PutSx1(cPerg,"01","Mestre De ?"			, "Mestre De ?"			, "Mestre De ?"			, "mv_ch1","C",03,0,0,"G",""		,""		,"","","mv_par01","","","",""			,"","","","","","","","","","","","","","","","") 
		PutSx1(cPerg,"02","Mestre At้ ?"		, "Mestre At้ ?"		, "Mestre At้ ?"		, "mv_ch2","C",03,0,0,"G",""		,""		,"","","mv_par02","","","",""			,"","","","","","","","","","","","","","","","")
	                                                                                                                                                                                     
		PutSx1(cPerg,"03","Documento De ?"		, "Documento De ?"		, "Documento De ?"		, "mv_ch3","C",09,0,0,"G",""		,""		,"","","mv_par03","","","",""			,"","","","","","","","","","","","","","","","") 
		PutSx1(cPerg,"04","Documento At้ ?"		, "Documento At้ ?"		, "Documento At้ ?"		, "mv_ch4","C",09,0,0,"G",""		,""		,"","","mv_par04","","","",""			,"","","","","","","","","","","","","","","","")
	EndIf		 

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/      
User Function GeraEtiq(lProd,lMenu)   

	Local cPorta := "LPT1"
	Local cQuery := ""
	Local _cAlias := GetNextAlias()

	If !IsPrinter(cPorta)
		Return
	Endif		
	
	MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
	
	MSCBCHKSTATUS(.F.)	
	
	If !lMenu
		GrvEtq(lProd,cData,nVarCont,cModel,cCaixa,cPalete,cRua,cDescLoc,cUserName)
	Else

		cPerg 	:= "INVPET" 
	
		PergEtq(cPerg)
		If !Pergunte(cPerg,.T.)
			Return
		EndIf 
	
		cQuery := " SELECT ZB0_DOCMAS, ZB0_DOC, ZB0_LOCAL, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_NUMCON, ZB0_CONTAG, ZB0_SITUAC, ZB0_MODELO, ZB0_USER, ZB0_DTINV FROM " + RetSqlName("ZB0") + " (NOLOCK) " + CRLF
		cQuery += " 	WHERE ZB0_FILIAL = '" + xFilial("ZB0") + "' " + CRLF
		cQuery += " 	AND D_E_L_E_T_ <> '*' " + CRLF 
		cQuery += " 	AND ZB0_DOCMAS BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF 
		cQuery += " 	AND ZB0_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF  
		cQuery += " 	AND ZB0_FINALI = 'S' " + CRLF  
		cQuery += " 	AND ZB0_CONFIR = '1' " + CRLF 
		cQuery += " GROUP BY ZB0_DOCMAS, ZB0_DOC, ZB0_LOCAL, ZB0_RUA, ZB0_PALETE, ZB0_CAIXA, ZB0_NUMCON, ZB0_CONTAG, ZB0_SITUAC, ZB0_MODELO, ZB0_USER, ZB0_DTINV " + CRLF  
		cQuery += " 	ORDER BY ZB0_DOCMAS, ZB0_DOC " + CRLF 
		
		cQuery := ChangeQuery(cQuery) 
		If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
		( _cAlias )->( dbGoTop() )
		If( ( _cAlias )->( !Eof() ) ) 
			While ( ( _cAlias )->( !Eof() ) ) 			
			
				GrvEtq(lProd,STOD(( _cAlias )->( ZB0_DTINV)),( _cAlias )->( ZB0_NUMCON),( _cAlias )->( ZB0_MODELO),( _cAlias )->( ZB0_CAIXA),( _cAlias )->( ZB0_PALETE),;
				( _cAlias )->( ZB0_RUA),( _cAlias )->( ZB0_LOCAL),( _cAlias )->( ZB0_USER))
				
				( ( _cAlias )->( DbSkip() ) )
			EndDo		
		EndIf	
	EndIf	
	
	MSCBCLOSEPRINTER()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVNXT1  บAutor  ณVinicius Leonardo    บ Data ณ  06/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/      
Static Function GrvEtq(lProd,dDataApont,nTotal,cModEtq,cCxEtq,cPallEtq,cRuEtq,cLocEtq,cUsEtq)

	MSCBBEGIN(1,6)
	
	//       c   l   c   l
	MSCBBOX(004,007,096,120,4)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Primeira Linha                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l
	MSCBBOX(004,007,096,030,4)
	MSCBSAY(010,020,"BGH        Inventario Nextel","N","0","065,075",.T.)
			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Segunda Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l
	MSCBBOX(004,030,055,048,4)
	MSCBSAY(006,032,"DATA APONTADA: ","N","0","035,045",.T.)
	MSCBSAY(008,040,DTOC(dDataApont),"N","0","085,095",.T.)
	//       c   l   c   l
	MSCBBOX(055,030,096,048,4)
	MSCBSAY(057,032,"TOTAL: ","N","0","035,045",.T.)
	MSCBSAY(061,040,STRZERO(nTotal,5),"N","0","085,095",.T.)		
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Terceira Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l            
	
	If lProd
		MSCBBOX(004,048,055,066,4)
		MSCBSAY(006,050,"MODELO: ","N","0","035,045",.T.)
		MSCBSAY(008,058,Alltrim(cModEtq),"N","0","085,095",.T.)
		//       c   l   c   l
		MSCBBOX(055,048,096,066,4)
		MSCBSAY(057,050,"NRO.CAIXA: ","N","0","035,045",.T.)
		MSCBSAY(061,058,ALLTRIM(cCxEtq),"N","0","085,095",.T.)
	Else
		//       c   l   c   l
		MSCBBOX(004,048,096,066,4)
		MSCBSAY(006,050,"NRO.CAIXA: ","N","0","035,045",.T.)
		MSCBSAY(008,058,ALLTRIM(cCxEtq),"N","0","085,095",.T.)
	EndIf		
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Quarta Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู								
	//       c   l   c   l
	MSCBBOX(004,066,096,084,4)
	MSCBSAY(006,068,"PALLET: ","N","0","035,045",.T.)
	MSCBSAY(008,075,Alltrim(cPallEtq),"N","0","085,095",.T.)	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Quinta Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l
	MSCBBOX(004,084,096,102,4)
	MSCBSAY(006,086,"RUA: ","N","0","035,045",.T.)
	MSCBSAY(008,093,cRuEtq,"N","0","085,095",.T.)		
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Sexta Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l
	MSCBBOX(004,102,096,120,4)
	MSCBSAY(006,104,"LOCAL: ","N","0","035,045",.T.)
	MSCBSAY(008,110,Alltrim(cLocEtq),"N","0","085,095",.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Setima Linha                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//       c   l   c   l
	MSCBBOX(004,120,096,138,4)
	MSCBSAY(006,122,"USUARIO: ","N","0","035,045",.T.)
	MSCBSAY(008,130,Alltrim(cUsEtq),"N","0","085,095",.T.)	
	
	MSCBEND()

Return	
