/*
 *Programa   : ETQGLLD   
 *Autores 	 : Carlos Vieira
 *Data		 : 28/07/2012
 *Descricao  : Programa para impressao de Etiquetas - DOA Lojas - ZEBRA
*/
#Include "Protheus.ch"
User Function ETQGLLD() //EtqCarRE()
	MsgAlert("Etiqueta descontinuada,solicite ao TI-Sistemas a Alteração no Menu para TecA0002!")   
Return	
	
Static Function Desativada()	
	Local aAreaZZ4   := ZZ4->(GetArea())
	Private ocImei               
	Private ocserial
	Private ccImei   := Space(20)  
	Private ccSerial := Space(15)
	Private _oDlgETI      
	Private _cModelo := Space(20)
	Private _cbaiest := Space(45)
	Private _ccliloj := Space(15)
	Private _cNfants := Space(30)              
	Private _dEntmas 
	Private _nqtdeti := 0                        
	Private cPerg    := "TIPIMP1" 
	Private _operdescri
	Private _operdes
	Private _ean	
	Private _operbgh := ""	

u_GerA0003(ProcName())	       
	CriaSX1()
	Pergunte(cPerg,.T.)  
	       
	Define MsDialog _oDlgETI Title "ETIQ. GTIA. LOJAS" From C(276),C(346) To C(467),C(623) Pixel
		@ C(000),C(001) To C(097),C(140) LABEL "Dados" Pixel Of _oDlgETI
		@ C(020),C(020) Say "IMEI:" 	Size C(014),C(008) COLOR CLR_BLACK  							 Pixel OF _oDlgETI
		@ C(020),C(040) MsGet ocImei 	Var ccImei   Size C(060),C(009) COLOR CLR_BLACK  Valid CHKIMEI() Pixel Of _oDlgETI
		@ C(044),C(020) Say "SERIAL:" 	Size C(014),C(008) COLOR CLR_BLACK  							 Pixel Of _oDlgETI
		@ C(040),C(040) MsGet ocserial 	Var ccSerial Size C(060),C(009) COLOR CLR_BLACK  Valid CHKSER()  Pixel Of _oDlgETI		
		Define SButton From C(068),C(045) Type 1 Enable OF _oDlgETI Action ()
		Define SButton From C(068),C(065) Type 2 Enable OF _oDlgETI Action (_oDlgEti:End())		
	Activate MsDialog _oDlgETI Centered
	ZZ4->(RestArea(aAreaZZ4))
Return
/*
 *Programa   : ckhimei   
 *Autores 	 : Claudia Cabral/Edson Rodrigues
 *Data		 : 16/09/10
 *Descricao  : Funcao responsavel validar o codigo do cliente e IMEI       
*/
Static Function ChkImei()      
	Local _lAchou := .F.
	
	&&Funcao responsavel validar IMEI e SWAP	
	_lAchou := VldIMEIouSWAP(cCImei)	

	If _lAchou 
		If  !ZZ4->ZZ4_STATUS $ '5'     
			apMsgStop("Caro usuário, o IMEI informado não encontra-se na fase de encerramento. ","IMEI com fase incorreta")
			Return .F.
		EndIf
		SA1->(dbSeek(xFilial("SA1") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA ))
		
		_cModelo   := ALLTRIM(ZZ4->ZZ4_CODPRO)
		//_cCliloj := alltrim(ZZ4->ZZ4_CODCLI) + ' - ' + alltrim(ZZ4->ZZ4_LOJA) + ' - ' + alltrim(SA1->A1_NREDUZ )
		_cCliloj   := alltrim(ZZ4->ZZ4_CODCLI) + ' - ' + alltrim(ZZ4->ZZ4_LOJA)
		_cNfants   := alltrim(SA1->A1_NREDUZ) + '-' + alltrim(SA1->A1_LOJA) //homologar a inclusão da loja
		_dEntmas   := ZZ4->ZZ4_EMDT
		_cbaiest   := alltrim(LEFT(SA1->A1_BAIRRO,40))  + ' - ' + SA1->A1_EST
	
	Else
		apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")		
		Return .F.
	EndIf
Return .T.
/*
 *Programa   : ChkSer   
 *Autores 	 : Edson Rodrigues 
 *Data		 : 16/09/10
 *Descricao  : Funcao responsavel validar o Serial 
*/
Static Function ChkSer()      
	Local _lAchou   :=.F.
	
	&&Funcao responsavel validar IMEI e SWAP
	_lAchou := VldIMEIouSWAP(cCImei)

    If Empty(ccSerial)
		apMsgStop("Caro usuário, o Serial nao foi informado.","IMEI não informado")
		Return .F.
	EndIf                              
	   
	_nqtdeti    := 1 
	_operbgh   	:= ZZ4->ZZ4_OPEBGH

	_cvalseri  	:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_VALSER")
    //_nqtdeti   	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_QTDRET")
    _cvalcardu 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_ETQCDU")
    //_cvalcardu 	:= 'S'
    _operdes	:= Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_DESCRI") 
    _ean        := Posicione("SB1",1,xFilial("SB1") + ALLTRIM(_cModelo), "B1_EAN")

	If _lAchou
		If Empty(ZZ4->ZZ4_SWAP) 		    

			If Left(_operdes,6) $ "NEXTEL"
				_operdescri	:=Substr(_operdes,9,20)
			Else
				_operdescri	:= _operdes
			EndIf	    
	    	    
		    If _cvalseri <> "S"
				apMsgStop("Caro usuário, A operacao desse IMEI informado não valida o serial. ","Operacao Invalida para validar Serial")
				Return .F.
		    Else                              
		       _clab :=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_operbgh), "ZZJ_LAB")           
		    EndIf                                                            
		   	    
			If !ALLTRIM(ZZ4->ZZ4_CARCAC)==ALLTRIM(ccSerial)
		        apMsgStop("Caro usuário, O serial :"+alltrim(ccSerial)+" é dIferente do serial da entrada. O serial da entrada é : "+ALLTRIM(ZZ4->ZZ4_CARCAC),"Serial Invalido")
				Return .F.
		    EndIf
		    
		    If _nqtdeti <= 0
		        apMsgStop("Caro usuário, Essa Operacao :"+ALLTRIM(_operbgh)+" nao esta parametrizada para imprimir essa Etiqueta. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
				Return .F.
		    EndIf
		    
		    If AllTrim(_cvalcardu) == "S"
		    	apMsgStop("Caro usuário, Essa Operacao :"+ALLTRIM(_operbgh)+" nao esta parametrizada para imprimir essa Etiqueta. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
				Return .F.
		    EndIf
		    
		    If Empty (_ean)
		        apMsgStop("Caro Usuário, O código EAN para esse modelo não está devidamente preenchido no cadastro do produto. Entre em contato com Administrado do Sistema " ,"Operacao Invalida para Impr. Etiqueta")
		        Return .F.
		    EndIf
		EndIf       
	Else     
		apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")		
		Return .F.
	EndIf
	
	If _lAchou 
		ImpEti()                        
	EndIf	
Return .T. 
/*
 *Programa   : VldIMEIouSWAP   
 *Autores 	 : Thomas Quintino Galvão
 *Data		 : 06/08/12
 *Descricao  : Funcao responsavel validar IMEI e SWAP
*/
Static Function VldIMEIouSWAP(cCImei)
	Local cAliasMax := GetNextAlias() 
	Local lValid	:= .F.
	
	If Empty(ccImei)
		apMsgStop("Caro usuário, o IMEI nao foi informado.","IMEI não informado")
		Return lValid
	EndIf    
	
	BeginSQL Alias cAliasMax                                               
		Select 
			ISNULL(RECIMEI,0) RECIMEI,  
			ISNULL(RECSWAP,0) RECSWAP
		From 
			(Select Max(ZZ4A.R_E_C_N_O_) RECIMEI From %Table:ZZ4% ZZ4A Where ZZ4A.ZZ4_FILIAL = %xFilial:ZZ4% And ZZ4A.ZZ4_IMEI = %Exp:cCImei% And ZZ4A.%notDel%) AS MXIMEI,
			(Select Max(ZZ4B.R_E_C_N_O_) RECSWAP From %Table:ZZ4% ZZ4B Where ZZ4B.ZZ4_FILIAL = %xFilial:ZZ4% And ZZ4B.ZZ4_SWAP = %Exp:cCImei% And ZZ4B.%notDel%) AS MXSWAP
	EndSql	
	
	If Select(cAliasMax) > 0 
		If (cAliasMax)->RECIMEI == 0 
			If !Empty((cAliasMax)->RECSWAP)
				ZZ4->(dbGoTo((cAliasMax)->RECSWAP))
				lValid := .T.
			Else
				lValid := .F.	 
		    EndIf
		Else
			ZZ4->(dbGoTo((cAliasMax)->RECIMEI))
			lValid := .T.	
		EndIf
	Else
		lValid := .F.
	EndIf	
	
	If !lValid
		apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
	EndIf	
	(cAliasMax)->(dbCloseArea(cAliasMax))	
Return lValid 
/*
 *Programa   : C 
 *Autores 	 : Norbert/Ernani/Mansano
 *Data		 : 10/05/2005
 *Descricao  : Funcao responsavel por manter o Layout indepEndente da
 *Descricao  : resolucao horizontal do Monitor do Usuario
*/                                                               
Static Function C(nTam)                                                         
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//Tratamento para tema "Flat" 
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)
/*
 *Programa   : ImpEti
 *Autores 	 : Claudia Cabral/Edson Rodrigues
 *Data		 : 16/09/10
 *Descricao  : Funcao responsavel pela impressão da etiqueta Retail 
*/       
Static Function ImpEti()
	Local nX
	//Local _aLin := {03,06,09,12,15}
	//Local _aLin := {03,07,10,14,17}
	//Local _aCol := {05,27,30,54}  //05,30
	Local _aLin := {}
	Local _aCol := {}  //05,30
	Local cfont := "0"                                               
	Local datab	:= dDataBase
	Local hora	:= Time()
	Local _afont :={"020,030","037,047","055,075","065,085","090,090","100,100","110,110"}      
	
	If MV_PAR01 == 1
	  _aLin := {03,07,11,15,19}
	  _aCol := {05,17,20,60}  //05,30
	Else 
	  _aLin := {06,16,22,32,39}
	  _aCol := {10,20,23,98}  //05,30
	EndIf   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura da Matriz                                                         ³
	//³ 01 - IMEI                                                                   ³
	//³ 02 - Numero da OS                                                           ³
	//³ 03 - Item da OS                                                             ³
	//³ 04 - Numero da NF de Entrada                                                ³
	//³ 05 - Serie da NF de Entrada                                                 ³
	//³ 06 - Modelo do aparelho                                                     ³
	//³ 07 - Data de Entrada                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Layout da Etiqueta                              ³
	//³ Ú--------------- 88 mm -----------------------¿ ³
	//³ |  CARD-U: 000000000000000  XXXXXXXXXXXXXX    | ³
	//³ |  IMEI: 000000000000000           UF      22 | ³
	//³ |  CLIENTE                                 mm ³ ³
	//³ À---------------------------------------------Ù ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	For nx =1 to _nqtdeti
	
		If MV_PAR01 == 1
	     	MSCBPRINTER("S300","LPT1",,022,.F.,,,,,,.T.)  	     	       
		    MSCBBEGIN(1,6)	        //direcao fonte   tamanho 
		       
		    MSCBSAYBAR(_aCol[1],_aLin[1],alltrim(ccImei),"N","MB07",3,.F.,.F.,.F.,,2,1)
		    
	        //Alterado Layout da Etiqueta conforme solictacao do Francis - Edson Rodrigues 08/05/10
		    //MSCBSAY(   _aCol[4],_aLin[1],"Modelo: " + _cModelo,"N","0","020,030") 
		    MSCBSAY(_aCol[4],_aLin[1],_cCliloj ,"N",cfont,_afont[1])  	
		    MSCBSAY(_aCol[1],_aLin[2],"IMEI: " 		+ alltrim(ccImei) ,"N",cfont,_afont[1])   	
			MSCBSAY(_aCol[4],_aLin[2],"Entrada : " + TransForm(_dEntmas, "@E 99/99/99") ,"N",cfont,_afont[1])
			  
			//MSCBSAY(_aCol[4],_aLin[3],_cbaiest ,"N","0","020,030")		
		    MSCBSAYBAR(_aCol[1],_aLin[3],_cModelo,"N","MB07",3,.F.,.F.,.F.,,2,1) 
		     
	        MSCBSAY(_aCol[1],_aLin[4],"Modelo: " + _cModelo +' - '+ AllTrim(_operbgh)+ '-'+ Alltrim(_operdescri),"N",cfont,_afont[1]) 
		    MSCBSAY(_aCol[4],_aLin[3],alltrim(__cUserID)+ ' '+ Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[1])  // Coluna 2 - Linha 2		
		    MSCBSAY(_aCol[1],_aLin[5],_cNfants+' - '+_cbaiest ,"N",cfont,_afont[1])
	        //MSCBSAY(_aCol[1],_aLin[4],_cCliloj ,"N","0","020,030")  // Coluna 2 - Linha1 
		    //MSCBSAY(_aCol[1],_aLin[5],_cbaiest ,"N","0","020,030")  // Coluna 2 - Linha1		
		    MSCBEnd()	
		    MSCBCLOSEPRINTER()      
		     
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Layout da Etiqueta                              ³
			//³ Ú--------------- 88 mm -----------------------¿ ³
			//³ |  000000000000000          00000000000000    | ³
			//³ |  IMEI: 000000000          serial:0000000    | ³
			//³ |  000000000000000          00000000000000    | ³             
			//³ |  MODELO:00000000          EAN:0000000000    | ³
			//³ |  CLIENT/loja - CIDADE - EST   SAIDA:DD/MM/AA|³
			//³ À---------------------------------------------Ù ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    		    
		Else		
	   	    MSCBPRINTER("Z90XI","LPT1",,22,.F.,,,,,,.T.) 
		    MSCBBEGIN(1,6)
	        //                                  direcao fonte   tamanho    
	        //	_aLin := {06,16,22,32,39}
	        //  _aCol := {10,20,23,100}
		    MSCBSAYBAR(_aCol[1],_aLin[1],alltrim(ccImei)	,"N","MB07",8,.F.,.F.,.F.,,4,2)	        
	        MSCBSAYBAR(_aCol[4],_aLin[1],alltrim(ccSerial)	,"N","MB07",8,.F.,.F.,.F.,,4,2)	        
	        MSCBSAYBAR(_aCol[4],_aLin[3],alltrim(_ean)		,"N","MB04",8,.F.,.F.,.F.,,4,2)  //VERIfICAR SE É EAN8 OU EAN13	        
	        MSCBSAYBAR(_aCol[1],_aLin[3],alltrim(_cModelo)	,"N","MB07",8,.F.,.F.,.F.,,4,2) 
	        	
	      //MSCBSAY(_aCol[4],_aLin[2],_cCliloj ,"N",cfont,_afont[3]) 		    
		    MSCBSAY(_aCol[4],_aLin[2],"Serial: "+ alltrim(ccSerial) ,"N",cfont,_afont[3]) 		
		    MSCBSAY(_aCol[1],_aLin[2],"IMEI: "  + alltrim(ccImei)   ,"N",cfont,_afont[3])	
	      //MSCBSAY(_aCol[4],_aLin[4],"Entrada: "+ TransForm(_dEntmas, "@E 99/99/99") ,"N",cfont,_afont[3])	    
		    MSCBSAY(_aCol[4],_aLin[5],"Saida: " + Transform(datab, "@E 99/99/99") + ' - ' + (hora),"N",cfont,_afont[3])		    
		    MSCBSAY(_aCol[1],_aLin[4],"Modelo/OP: " + _cModelo +' / '+ AllTrim(_operbgh),"N",cfont,_afont[3]) 		    
		    MSCBSAY(_aCol[4],_aLin[4],"EAN: "   + _ean,"N",cfont,_afont[3])		    
		    MSCBSAY(_aCol[1],_aLin[5],_cNfants  +' - '+_cbaiest ,"N",cfont,_afont[2])	        
		    MSCBEnd()	
		    MSCBCLOSEPRINTER()
		EndIf  		    
	Next	
	ccImei   := Space(20)
	ccserial := Space(11)
	ocImei:Setfocus()
Return  .T.                      
/*
 *Programa   : CriaSX1
 *Autores 	 : Claudia Cabral/Edson Rodrigues
 *Data		 : 16/09/10
 *Descricao  : Cria Grupo de Perguntas
*/  	
Static Function CriaSX1()
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 600 DPI"		,"","",""	,"","","","","","","","")
Return Nil

