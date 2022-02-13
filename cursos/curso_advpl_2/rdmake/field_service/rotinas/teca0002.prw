#Include "Totvs.ch"
#Include "TopConn.ch"
/*
*Programa: TecA0002 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Impressão Etiqueta Imei ou Swap                      
*/
User Function TecA0002()
	Local oGetSerial
	Local oGrid
	Local oImei
	Local oSerial
	Local cPerg    		:= "TIPIMP1" 
	Local nTipo    		:= 0 
	Local lRet			:= .F.
	Private oGetImei
	Private oTipImei
	Private cGetImei   	:= Space(TamSX3("ZZ4_IMEI")[1])//Space(20) 
	Private cGetSerial 	:= Space(15) 
	Private cTipImei	:= ''
	Private cBkpSerial 	:= '' 
	Private lValSerial 	:= .T.
	Private cValSerial	:= ''
	Private cValEtqCdu  := ''
	Private cValEan		:= ''
	Private cOperBgh	:= ''
	Private cCliloja	:= ''
	Private cModelo		:= ''
	Private cOperdes	:= ''
	Private cNfants		:= ''
	Private cBaiEst		:= ''
	Private dEntMas		:= sTod(Space(8))
	Private lStatus		:= .F.
	Private oDlg	
	Private cLote 		:=''

u_GerA0003(ProcName())


	CriaSx1(cPerg)
	Pergunte(cPerg,.T.) 
	       
	Define MsDialog oDlg Title "Etiqueta Garantia Lojas"  From 276, 346  To 467, 623 			  			Pixel
	  	@ 000, 001 Group oGrid To 094, 140 Label "Dados" 													Pixel Of oDlg                    
    	@ 020, 040 MsGet oGetImei 	VAR cGetImei   Size 060, 009 COLOR CLR_BLACK  Valid lRet := TecA002A()  Pixel OF oDlg
    	@ 040, 040 MsGet oGetSerial VAR cGetSerial Size 060, 009 COLOR CLR_BLACK  Valid lRet := TecA002B()  Pixel OF oDlg
    	@ 020, 020 Say oImei 	PROMPT "IMEI:"     Size 014, 008 COLOR CLR_BLACK  							Pixel OF oDlg
    	@ 044, 020 Say oSerial 	PROMPT "SERIAL:"   Size 014, 008 COLOR CLR_BLACK  							Pixel OF oDlg
    	@ 084, 020 Say oTipImei PROMPT cTipImei	   Size 250, 008 COLOR CLR_BLACK  							Pixel OF oDlg
	    Define SButton From 071, 062 Type 01 Enable Of oDlg Action (nTipo := 1, oDlg:End())
    	Define SButton From 071, 095 Type 02 Enable Of oDlg Action (nTipo := 2, oDlg:End())
	Activate MsDialog oDlg Centered  
Return
/*
*Programa: TecA002A 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Validação de Imei/Swap                      
*/
Static Function TecA002A()
	Local lAchou := .F.	
	If Empty(cGetImei)
		apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
		Return .F.
	EndIf
	
	lValSerial := .T.
	
	lAchou := QryValid(1) 		&&Imei
	If !lAchou
		lAchou 		:= QryValid(2)	&&Swap
		lValSerial 	:= .F.
		If lAchou
			cTipImei := "ATENÇÃO: IMEI de SWAP, não valida Serial"
			oTipImei:NCLRTEXT := 255
			oDlg:Refresh()
		Else
			apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")		
			cTipImei := ""
			oDlg:Refresh()	
		EndIF
	EndIf
	
	If lStatus  
		apMsgStop("Caro usuário, o IMEI informado não encontra-se na fase de encerramento. ","IMEI com fase incorreta")
		lStatus:= .F.
		lAchou := .F.
	EndIf           
	
	cTipImei := ""
	oDlg:Refresh()	
Return lAchou
/*
*Programa: TecA002B 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Validação de Serial
*/
Static Function TecA002B()	
	If Empty(cGetSerial)
		apMsgStop("Caro usuário, o Serial nao foi informado.","Serial não informado")
		Return .F.
	EndIf
	
	&&Se Swap não valida Serial Libera impressão qualquer valor [ Nao mais ]
	If !lValSerial
		If Empty(cValEan) //Alterado Uiran Almeida 09.12.2013 - Incluso para validar o EAN mesmo que o imei seja SWAP. Chamado - ID 16026
        	apMsgStop("Caro Usuário, O código EAN para esse modelo não está devidamente preenchido no cadastro do produto. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
        	Return .F.
    	Endif
		TecA002C()        
		Return .T.	
	EndIF 
	
	&&Verifica se Serial Digitado é igual ao Serial deste Imei
	If AllTrim(cGetSerial) != AllTrim(cBkpSerial)
		apMsgStop("Serial :"+AllTrim(cGetSerial)+" é diferente do serial da entrada. O serial da entrada é : "+AllTrim(cBkpSerial),"Serial Invalido")
		Return .F.
	EndIf
	
	&&Valida Serial?
	If cValSerial <> "S"
		apMsgStop("Caro usuário, A operacao desse IMEI informado não valida o serial. ","Operacao Invalida para validar Serial")
		Return .F.
	EndIf
	
	&&Imprime Etiqueta?
	If AllTrim(cValEtqCdu) == "S"
    	apMsgStop("Essa Operacao :"+AllTrim(cOperBgh)+" nao esta parametrizada para imprimir essa Etiqueta. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
		Return .F.
    EndIf
    
    &&Valida cadastro SB1, B1_EAN tem que estar preenchido
    If Empty(cValEan)
        apMsgStop("Caro Usuário, O código EAN para esse modelo não está devidamente preenchido no cadastro do produto. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
        Return .F.
    Endif
                           
   	TecA002C()    
Return .T.
/*
*Programa: QryValid 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Query de Validação Imei/Swap
*/
Static Function QryValid(nNum)
	Local cWhere := ""    
	Local lRet 	 := .T.
	Local cAlias := GetNextAlias()
	
	Do Case
		Case nNum == 1 
			cWhere := "%ZZ4_IMEI = '"+cGetImei+"'%"
		Case nNum == 2
			cWhere := "%ZZ4_SWAP = '"+cGetImei+"'%"
	EndCase	
	
	BeginSql Alias cAlias		
		Select Top 1
			ZZ4.R_E_C_N_O_ NREGZZ4, ZZJ.R_E_C_N_O_ NREGZZJ, SB1.R_E_C_N_O_ NREGSB1, SA1.R_E_C_N_O_ NREGSA1,
			ZZ4_IMEI,   ZZ4_SWAP,   ZZ4_STATUS, ZZ4_OPEBGH, ZZ4_CODPRO, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_CARCAC,
			ZZ4_CARCAC, A1_NREDUZ,  A1_LOJA,    ZZ4_EMDT,   A1_BAIRRO,  A1_EST,     ZZJ_VALSER, 
			ZZJ_ETQCDU, ZZJ_DESCRI, B1_EAN,     ZZJ_LAB, ZZ4_NFENR, ZZ4_NFESER, ZZ4_ITEMD1,ZZ4_CHVFIL 
			
		From %Table:ZZ4% ZZ4 (NoLock)
		
			Left Join %Table:SA1% SA1 (NoLock)
				On A1_FILIAL  = %xFilial:SA1%	
				And A1_COD 	  = ZZ4_CODCLI 
				And A1_LOJA   = ZZ4_LOJA
				And SA1.%NotDel%
				
			Left Join %Table:ZZJ% ZZJ (NoLock)			
				On ZZJ_FILIAL = %xFilial:ZZJ%	
				And ZZJ_OPERA = ZZ4_OPEBGH
				And ZZJ.%NotDel%
						
			Left Join %Table:SB1% SB1 (NoLock)
				On B1_FILIAL  = %xFilial:SB1%	
				And B1_COD 	  = ZZ4_CODPRO
				And SB1.%NotDel%
		Where
			ZZ4_FILIAL = %xFilial:ZZ4%
			And %Exp:cWhere%
			And ZZ4.%NotDel%
		Order By ZZ4_EMDT Desc		
	EndSql
	
	If (cAlias)->(eof()) .and. (cAlias)->(bof())
		Return .F.		
	EndIf
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If (cAlias)->ZZ4_CODCLI=="Z00403" .AND. !EMPTY((cAlias)->ZZ4_CHVFIL)
		SA1->(dbSeek(xFilial("SA1") + SUBSTR((cAlias)->ZZ4_CHVFIL,7,8)))
	Else
		SA1->(dbSeek(xFilial("SA1") + (cAlias)->ZZ4_CODCLI + (cAlias)->ZZ4_LOJA ))
	Endif
	
	&&Carga de Variáveis para impressão da etiqueta ou Validações
	cBkpSerial 	:= (cAlias)->ZZ4_CARCAC
	cValSerial 	:= (cAlias)->ZZJ_VALSER
	cValEtqCdu 	:= (cAlias)->ZZJ_ETQCDU
	cValEan		:= (cAlias)->B1_EAN
	cOperBgh	:= (cAlias)->ZZ4_OPEBGH
	//cCliloja	:= AllTrim((cAlias)->ZZ4_CODCLI) + ' - ' + AllTrim((cAlias)->ZZ4_LOJA)
	cCliloja	:= AllTrim(SA1->A1_COD) + ' - ' + AllTrim(SA1->A1_LOJA)
	dEntMas     := (cAlias)->ZZ4_EMDT
	cModelo   	:= AllTrim((cAlias)->ZZ4_CODPRO) 
	cOperDes	:= (cAlias)->ZZJ_DESCRI
	//cNfants   	:= AllTrim((cAlias)->A1_NREDUZ) + '-' + AllTrim((cAlias)->A1_LOJA)
	cNfants   	:= AllTrim(SA1->A1_NREDUZ) + '-' + AllTrim(SA1->A1_LOJA)
	//cBaiEst   	:= alltrim(LEFT((cAlias)->A1_BAIRRO,40))  + ' - ' +(cAlias)->A1_EST
	cBaiEst   	:= alltrim(LEFT(SA1->A1_BAIRRO,40))  + ' - ' +SA1->A1_EST
	lStatus		:= (cAlias)->ZZ4_STATUS != '5'     
	cLote 		:= "" 
 	
	If Alltrim((cAlias)->ZZ4_OPEBGH)=='N04'
		cLote := Posicione("SD1",1,xFilial("SD1")+ (cAlias)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_ITEMD1), "D1_XLOTE") //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If !empty(cLote)
			cLote := "(" + Alltrim(cLote) + ")"
		Endif
	Endif

	(cAlias)->(dbCloseArea())
Return lRet
/*
*Programa: TecA002C 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Impressão de Etiquetas
*/
Static Function TecA002C()
	Local aLin 	:= {}
	Local aCol	:= {}  
	Local cFont := "0"                                               
	Local dDtBas:= dDataBase
	Local cHora	:= Time()
	Local aFont :={"020,030","037,047","055,075","065,085","090,090","100,100","110,110"}      
	
	If Left(cOperDes,6) $ "NEXTEL"
		cOperDescr	:=Substr(cOperDes,10,20)          
	Else
		cOperDescr	:= cOperDes
	EndIf    
	
	If MV_PAR01 == 1
		aLin := {03,07,11,15,19}
	  	aCol := {05,17,20,60}  
	  
     	MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.) 
     	MSCBBEGIN(1,6)
	    
	    MSCBSAYBAR(aCol[1],aLin[1],AllTrim(cGetImei),"N","MB07",3,.F.,.F.,.F.,,2,1)
	    
	    MSCBSAY(aCol[4],aLin[1],cCliloja ,"N",cFont,aFont[1]) 
	    MSCBSAY(aCol[1],aLin[2],"IMEI: " 	 + AllTrim(cGetImei) ,"N",cFont,aFont[1])     
		MSCBSAY(aCol[4],aLin[2],"Entrada : " + TransForm(dEntMas, "@E 99/99/99") ,"N",cFont,aFont[1])  
	    
	    MSCBSAYBAR(aCol[1],aLin[3],cModelo,"N","MB07",3,.F.,.F.,.F.,,2,1)  
        
        MSCBSAY(aCol[1],aLin[4],"Modelo: " + cModelo +' - '+ AllTrim(cOperBgh)+ '-'+ AllTrim(cOperDescr)+cLote,"N",cFont,aFont[1]) 
	    MSCBSAY(aCol[4],aLin[3],AllTrim(__cUserID)+ ' '+ dToc(sTod(dEntMas)) + ' - ' + (cHora),"N",cFont,aFont[1])  // Coluna 2 - Linha 2	
	    MSCBSAY(aCol[1],aLin[5],cNfants+' - '+cBaiEst ,"N",cFont,aFont[1])
 	Else
 		aLin := {06,16,22,32,39}
		aCol := {10,20,23,98}  	
		
   	    MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.) 
	    MSCBBEGIN(1,6)
	    
	    MSCBSAYBAR(aCol[1],aLin[1],AllTrim(cGetImei)	,"N","MB07",8,.F.,.F.,.F.,,4,2)
        MSCBSAYBAR(aCol[4],aLin[1],AllTrim(cGetSerial)	,"N","MB07",8,.F.,.F.,.F.,,4,2)
        MSCBSAYBAR(aCol[4]+6,aLin[3],AllTrim(cValEan)		,"N","MB04",8,.F.,.F.,.F.,,4,2)  
        MSCBSAYBAR(aCol[1],aLin[3],AllTrim(cModelo)		,"N","MB07",8,.F.,.F.,.F.,,4,2)
	    
	    MSCBSAY(aCol[4],aLin[2],"Serial: "		+ AllTrim(cGetSerial) ,"N",cFont,aFont[3]) 
	    MSCBSAY(aCol[1],aLin[2],"IMEI: "		+ AllTrim(cGetImei) ,"N",cFont,aFont[3]) 
	    //MSCBSAY(aCol[4],aLin[5],"Saida: "		+ dToc(sTod(dEntMas)) + ' - ' + (cHora),"N",cFont,aFont[3])  alterado por Rodrigo Salomão 09/01/13 
	    MSCBSAY(aCol[4],aLin[5],"Saida: "		+Transform(dDtBas, "@E 99/99/99") + ' - ' + (cHora),"N",cFont,aFont[3])
	    MSCBSAY(aCol[1],aLin[4],"Modelo/OP: " 	+ cModelo +'/' + AllTrim(cOperBgh)+IIF(!Empty(cLote),"-"+cLote+" EAN: "+cValEan," EAN: "+cValEan),"N",cFont,aFont[3]) 
	    //MSCBSAY(aCol[4],aLin[4],"EAN: " 		+ cValEan,"N",cFont,aFont[3]) 
	    MSCBSAY(aCol[1],aLin[5],cNfants+' - '	+cBaiEst ,"N",cFont,aFont[2])
	EndIf   
 	MSCBEnd()
 	MSCBCLOSEPRINTER()
 	    
	cGetImei   := Space(TamSX3("ZZ4_IMEI")[1])//space(20)
	cGetSerial := space(15)
   	cTipImei := ""
	oDlg:Refresh()
	oGetImei:Setfocus()
Return  .T.                      
/*
*Programa: CriaSX1 
*Autor	 : Thomas Quintino Galvão 
*Data 	 : 26/09/12   
*Desc.   : Cria Grupo de Perguntas
*/
Static Function CriaSX1(cPerg)
	PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 600 DPI"		,"","",""	,"","","","","","","","")
Return Nil