#Include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQLAUDO ºAutor  ³M.Munhoz - ERPPLUS  º Data ³ 17/10/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressao da etiqueta de Laudo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function etqlau2() //Com as Definicoes para impressora Baxilon

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes das variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private oDlg   := Nil
private cIMEI  := Space(TamSX3("ZZ4_IMEI")[1])//Space(15)

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da janela e seus conteudos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Etiqueta de LAUDO" FROM 0,0 TO 210,420 OF oDlg PIXEL

@ 010,015 SAY   "Informe o IMEI para imprimir a Etiqueta de Laudo." 	SIZE 150,008 PIXEL OF oDlg 
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlg 
@ 045,025 MSGET cIMEI PICTURE "@!" 	SIZE 080,010 Valid u_implau2(cImei) PIXEL OF oDlg 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botoes da MSDialog                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 080,140 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPLAUDO ºAutor  ³Microsiga           º Data ³  17/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para imprimir a etiqueta de laudo                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function implau2(_cImei)

local _lRet := iif(empty(_cImei), .t., .f.)
Local _aCol := {05,25,50}
//Local _aLin := {090,85,80,76,72,60,48,36,35,22,05}
Local _aLin := {05,10,15,20,25,40,55,70,70,80,85}
//Local _aTam := {"1,0","020,025","010,015","015,015","015,015"}
Local _aTam := {"030,020","020,025","010,015","015,015","015,015"}
//Local _aTam := {"2,1","020,025","010,015","015,015","015,015"}
Local _cFon := "3"
Local _cLogo    := "" //Caminho do logo no servidor a partir da pasta system
Local _cDirecao := "N"
Local _aAreaZZ4 := ZZ4->(getarea())
Local _aAreaSA1 := SA1->(getarea())
Local _aAreaSZ9 := SZ9->(getarea())
Local _lAchou   := .f.
Local _cModelo  := _cCliente  := _cData := _cNovModel := _cImeiBar  := ""
Local _aSintom  := {}
Local _aDefeit  := {}
Local _aSoluca  := {}
Local _aPecas   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o IMEI informado no ZZ4 e posiciona na ultima ocorrencia dele³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ZZ4->(dbSetorder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
if ZZ4->(dbSeek(xFilial("ZZ4") + _cIMEI))
	while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. alltrim(ZZ4->ZZ4_IMEI) == alltrim(_cImei)
		ZZ4->(dbSkip())
	enddo
	ZZ4->(dbSkip(-1))
	_lAchou := alltrim(ZZ4->ZZ4_IMEI) == alltrim(_cImei)
elseif !empty(_cIMEI)
	apMsgStop("Caro usuário, o IMEI informado não existe na base de dados. Favor contatar o supervisor da área.","IMEI não encontrado")
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Continua o processamento caso tenha encontrado o IMEI                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _lAchou 
	
	SA1->(dbSeek(xFilial("SA1") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA ))
	_cIMEI     := "IMEI: "			+ ZZ4->ZZ4_IMEI
	_cModelo   := "Modelo: "		+ ZZ4->ZZ4_CODPRO
	_cCliente  := "Cliente: "		+ SA1->A1_NOME
	_cData     := "Data: "			+ dtoc(dDataBase)
	_cNovModel := "Novo Modelo: "	+ ZZ4->ZZ4_PRODUP
	_cImeiBar  := iif(!empty(ZZ4->ZZ4_SWAP), ZZ4->ZZ4_SWAP, ZZ4->ZZ4_IMEI)

	SZ9->(dbSetOrder(2))  // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
	if SZ9->(dbSeek(xFilial("SZ9") + ZZ4->ZZ4_IMEI + left(ZZ4->ZZ4_OS,6) ))

		_cAcumSint := _cAcumSolu := _cAcumPart := _cAcumDef := ""
		_cLab      := "1" //iif(ZZ4->ZZ4_LOCAL $ getnewpar("MV_XNEXLOC","10"), "2", "1")

		while SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_IMEI == ZZ4->ZZ4_IMEI .and. left(SZ9->Z9_NUMOS,6) == left(ZZ4->ZZ4_OS,6)

			if !empty(SZ9->Z9_SYMPTO) .and. !alltrim(SZ9->Z9_SYMPTO) $ _cAcumSint
				_cAcumSint += "/"+SZ9->Z9_SYMPTO
				_cDescSint := GetAdvFVal("SZ8","Z8_DESSINT",xFilial("SZ8") + _cLab + SZ9->Z9_SYMPTO, 1,"") // Z8_FILIAL + Z8_CLIENTE + Z8_CODSINT + Z8_CODSOLU
				aAdd(_aSintom, SZ9->Z9_SYMPTO+"-"+_cDescSint)
			endif
			if !empty(SZ9->Z9_ACTION) .and. !alltrim(SZ9->Z9_ACTION) $ _cAcumSolu
				_cAcumSolu += "/"+SZ9->Z9_ACTION
				_cDescSolu := GetAdvFVal("SZ8","Z8_DESSOLU",xFilial("SZ8") + _cLab + SZ9->Z9_ACTION, 2,"") // Z8_FILIAL + Z8_CLIENTE + Z8_CODSOLU + Z8_CODSINT
				aAdd(_aSoluca, SZ9->Z9_ACTION+"-"+_cDescSolu)
			endif
			if !empty(SZ9->Z9_PARTNR) .and. !alltrim(SZ9->Z9_PARTNR) $ _cAcumPart
				_cAcumPart += "/"+SZ9->Z9_PARTNR
				_cDescPart := GetAdvFVal("SB1","B1_DESC",xFilial("SB1") + SZ9->Z9_PARTNR, 1,"") // B1_FILIAL + B1_COD
				aAdd(_aPecas, _cDescPart)
			endif
			if !empty(SZ9->Z9_FAULID) .and. !alltrim(SZ9->Z9_FAULID) $ _cAcumDef
				_cAcumDef  += "/"+SZ9->Z9_FAULID
				_cDescDef  := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + "ZB" + SZ9->Z9_FAULID, 1,"") // X5_FILIAL + X5_TABELA + X5_CHAVE
				aAdd(_aDefeit, _cDescDef)
			endif

			SZ9->(dbSkip())

		enddo

	endif

	if apmsgyesno('Imprime a etiqueta de Laudo?')
//		MSCBPRINTER("ZEBRA","LPT1",,104,.F.,,,,,,.T.)  //esta linha esta funcionando a impressora ARGOX
        MSCBPRINTER("ZEBRA","LPT1",,104,.F.,,,,,,.T.)  //esta linha esta funcionando a impressora ARGOX
//		MSCBPRINTER("ALLEGRO","LPT1",,104,.F.,,,,,,.T.)  //esta linha esta funcionando a impressora ARGOX
//		MSCBPRINTER("ELTRON","LPT1",,104,.F.,,,,,,.T.) // testes com a impressora BARCODE
		MSCBChkStatus(.F.)
	
		MSCBLOADGRF("LOGOGVS.GRF") //Carrega a imagem para memoria da impressora
//		MSCBLOADGRF("LOGOBGH.GRF") //Carrega a imagem para memoria da impressora
	
	//	MSCBBEGIN(1,6)                        
		MSCBBEGIN()
		
		// Imprime os logos da Sony e BGH
		MSCBGRAFIC(_aCol[1],_aLin[1],"LOGOGVS")
//		MSCBGRAFIC(_aCol[3],_aLin[1],"LOGOBGH")
	
		//Titulos
		MSCBSAY(_aCol[2] ,_aLin[02] ,"Relatorio de Servico"	,_cDirecao ,_cFon ,_aTam[1]) // Linha 01 / Coluna 03 - Cartao de Postagem
		MSCBSAY(_aCol[1] ,_aLin[03] ,_cIMEI					,_cDirecao ,_cFon ,_aTam[1]) // Linha 03 / Coluna 03 - ACC...
		MSCBSAY(_aCol[3] ,_aLin[03] ,_cModelo 				,_cDirecao ,_cFon ,_aTam[1]) // Linha 05 / Coluna 03 - NF
		MSCBSAY(_aCol[1] ,_aLin[04] ,_cCliente				,_cDirecao ,_cFon ,_aTam[1]) // Linha 06 / Coluna 03 - Volume
		MSCBSAY(_aCol[3] ,_aLin[04] ,_cData					,_cDirecao ,_cFon ,_aTam[1]) // Linha 09 / Coluna 01 - Destinatario
		
		
		MSCBSAY(_aCol[1] ,_aLin[05] ,"Sintomas: "	 		,_cDirecao ,_cFon ,_aTam[1]) // Linha 09 / Coluna 04 - Data de Postagem
		if len(_aSintom) > 0  
	       _ntamc1:= 40                                       
		   _ntamc2:= 41                                                                                  

		    
			for x := 1 to len(_aSintom)
				//acrecentado regra para controle do tamanho da descrição  - Edson Rodrigues - 06/08/10
				If len(alltrim(_aSintom[x])) > _ntamc1
				  _ldescgrd:=.t.
 			      _nlin := 1
				Else
	    	 	  _ldescgrd:=.f. 
     	    	  _nlin :=0
				Endif
				
				If !_ldescgrd
					MSCBSAY(_aCol[2] ,_aLin[05] - 3*(x-1) ,"- "+alltrim(_aSintom[x])			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				
				Else
				     IF x=1
				        MSCBSAY(_aCol[2] ,_aLin[05] - 3*(x-1) ,"- "+left(alltrim(_aSintom[x]),_ntamc1)	,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente 
			            MSCBSAY(_aCol[2] ,_aLin[05] - 3*((x+_nlin)-1) ,substr(alltrim(_aSintom[x]),_ntamc2)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				     Else
				        MSCBSAY(_aCol[2] ,_aLin[05] - 3*((x+_nlin)-1) ,"- "+left(alltrim(_aSintom[x]),_ntamc1)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente 
                        MSCBSAY(_aCol[2] ,_aLin[05] - 3*((x+(2*_nlin))-1) ,substr(alltrim(_aSintom[x]),_ntamc2)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				     Endif
				ENDIF    		    
				if x >= 3
					exit
				endif                                                                                 
			next x
		endif
		
		
		MSCBSAY(_aCol[1] ,_aLin[06] ,"Defeitos: "			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
		if len(_aDefeit) > 0
   	        _ntamc1:= 40                                       
		    _ntamc2:= 41                                                
			for y := 1 to len(_aDefeit)
			   //acrecentado regra para controle do tamanho da descrição  - Edson Rodrigues - 06/08/10
			   If len(alltrim(_aDefeit[y])) > _ntamc1
				  _ldescgrd:=.t.
 			      _nlin := 1
				Else
	    	 	  _ldescgrd:=.f. 
     	    	  _nlin :=0
				Endif
				                
				If !_ldescgrd
					MSCBSAY(_aCol[2] ,_aLin[06] - 3*(y-1) ,"- "+alltrim(_aDefeit[y])			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				Else
				     IF y=1
                        MSCBSAY(_aCol[2] ,_aLin[06] - 3*(y-1) ,"- "+left(alltrim(_aDefeit[y]),_ntamc1)	,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente				        
			            MSCBSAY(_aCol[2] ,_aLin[06] - 3*((y+_nlin)-1) ,substr(alltrim(_aDefeit[y]),_ntamc2)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				     Else
                        MSCBSAY(_aCol[2] ,_aLin[06] - 3*((y+_nlin)-1) ,"- "+left(alltrim(_aDefeit[y]),_ntamc1)	 ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente				        
			            MSCBSAY(_aCol[2] ,_aLin[06] - 3*((y+(2*_nlin))-1) ,substr(alltrim(_aDefeit[y]),_ntamc2) ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				     Endif
				ENDIF    
				if y >= 3
					exit
				endif
			next y
		endif
	   
		MSCBSAY(_aCol[1] ,_aLin[07] ,"Solucoes: "	 		,_cDirecao ,_cFon ,_aTam[1]) // Linha 20 / Coluna 01 - Obs
		if len(_aSoluca) > 0
   	        _ntamc1:= 40                                       
		    _ntamc2:= 41                                                
			for w := 1 to len(_aSoluca)
               //acrecentado regra para controle do tamanho da descrição  - Edson Rodrigues - 06/08/10			   
			   If len(alltrim(_aSoluca[w])) > _ntamc1
				  _ldescgrd:=.t.
 			      _nlin := 1
			   Else
	    	 	  _ldescgrd:=.f. 
     	    	  _nlin :=0
			   Endif
				                
			   If !_ldescgrd
			   	   MSCBSAY(_aCol[2] ,_aLin[07] - 3*(w-1) ,"- "+alltrim(_aSoluca[w])  ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
		       Else
			       IF w=1                                                                                                                                       
			           MSCBSAY(_aCol[2] ,_aLin[07] - 3*(w-1) ,"- "+left(alltrim(_aSoluca[w]),_ntamc1)	,   _cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
                       MSCBSAY(_aCol[2] ,_aLin[07] - 3*((w+_nlin)-1) ,substr(alltrim(_aSoluca[w]),_ntamc2)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				   Else
                       MSCBSAY(_aCol[2] ,_aLin[07] - 3*((w+_nlin)-1) ,"- "+left(alltrim(_aSoluca[w]),_ntamc1)	 ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente				        
			           MSCBSAY(_aCol[2] ,_aLin[07] - 3*((w+(2*_nlin))-1) ,substr(alltrim(_aSoluca[w]),_ntamc2) ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				   Endif
			   ENDIF     
			   
			   if w >= 3
					exit
				endif
			next w
		endif
		
		
		MSCBSAY(_aCol[1] ,_aLin[08] ,"Pecas: "				,_cDirecao ,_cFon ,_aTam[1]) // Linha 20 / Coluna 01 - Obs
		if len(_aPecas) > 0
   	        _ntamc1:= 40                                       
		    _ntamc2:= 41                                                

		   for z := 1 to len(_aPecas)
			   //acrecentado regra para controle do tamanho da descrição  - Edson Rodrigues - 06/08/10			   
			   If len(alltrim(_aPecas[z])) > _ntamc1
				  _ldescgrd:=.t.
 			      _nlin := 1
			   Else
	    	 	  _ldescgrd:=.f. 
     	    	  _nlin :=0
			   Endif
               
               If !_ldescgrd
				   MSCBSAY(_aCol[2] ,_aLin[08] - 3*(z-1) ,"- "+alltrim(_aPecas[z])			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
		       Else
			       IF z=1 
			           MSCBSAY(_aCol[2] ,_aLin[08] - 3*(z-1) ,"- "+left(alltrim(_aPecas[z]),_ntamc1)  ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente                                                                                                                                      
                       MSCBSAY(_aCol[2] ,_aLin[08] - 3*((z+_nlin)-1) ,substr(alltrim(_aPecas[z]),_ntamc2)			,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				   Else
                       MSCBSAY(_aCol[2] ,_aLin[08] - 3*((z+_nlin)-1) ,"- "+left(alltrim(_aPecas[z]),_ntamc1)	 ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente				        
			           MSCBSAY(_aCol[2] ,_aLin[08] - 3*((z+(2*_nlin))-1) ,substr(alltrim(_aPecas[z]),_ntamc2) ,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
				   Endif
			   ENDIF     

			
				if z >= 3
					exit
				endif
		   next z
		endif
		MSCBSAY(_aCol[1] ,_aLin[10] ,_cNovModel	  			,_cDirecao ,_cFon ,_aTam[1]) // Linha 20 / Coluna 01 - Obs
	
		//MSCBSAYBAR(_aCol[1] ,_aLin[11] ,_cImeiBar 	,_cDirecao,"MB07",12,.F.,.T.,.F.,,,,,,,) // Objeto
      	//  MSCBSAYBAR(_aCol[1] ,_aLin[11] ,_cImeiBar 	,_cDirecao,"1",12,.F.,.T.,.F.,,,,.T.,,,) // Objeto
         MSCBSAYBAR(_aCol[1] ,_aLin[11] ,alltrim(_cImeiBar)	,_cDirecao,"MB07",12,.F.,.T.,.F.,,2,1) // Objeto      	  

		MSCBEND()
		
		MSCBCLOSEPRINTER()

	endif

endif	

cIMEI := Space(TamSX3("ZZ4_IMEI")[1])//space(15)
restarea(_aAreaSZ9)
restarea(_aAreaSA1)
restarea(_aAreaZZ4)

return(_lRet)