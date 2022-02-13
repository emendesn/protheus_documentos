#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATR004()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Etiqueta T้rmica"
Local cDesc1   := "Este programa tem como objetivo imprimir a etiqueta BGH para os Correios"
Local cDesc2   := ""
Local cDesc3   := "Impressora utilizada: TษRMICA"
Local cDesc4   := "Etiqueta 14x10 cm "

Private cPerg  := "FATR04"

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)   	}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()           	}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

Processa( {|lEnd| U_ProcFatr04( @lEnd , 5 ) }, "Aguarde.....", "Executando rotina.....", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ProcFatr04()

Local _aEtiq     := {}
Local _cObjeto   := "" 
Local _cDtPostag := dtoc(dDataBase)
Local _cQuery    := ""
Local _cEnter    := chr(13) + chr(10)
Local cNomeCli   := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_NOME")
Local cCartPost  := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_CRTPOST")
Local cSedexCod  := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_TSECOD") 
Local cESedexCod := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_TESECOD")
Local cTxtSedex  := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_TXSED") 
Local cCodAdm  	 := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_CODADM")
Local cTpPost	 := Posicione("SA1",1,xFilial("SA1")+AvKey(mv_par12,"A1_COD")+AvKey(mv_par13,"A1_LOJA"),"A1_TPPOST")
Local lSedex	 := .T.
Local lObjVaz 	 := .F.
Local cObj		 := ""
Local lNoCep	 := .F.
Local lRet		 := .T.

Private lProces := .F.
Private nStack  := 0
Private lMsg    := .F.
Private cObj	:= ""

Private _lUsrAut 	:= .F.
Private _aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))

For i := 1 to Len(_aGrupos)
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(_aGrupos[i])) $ "Administradores#EtqSigep" 
		_lUsrAut  := .T.
	EndIf
Next i

If !_lUsrAut
	MsgInfo("Usuario sem acesso para efetuar reimpressใo. Favor entrar em contato com o seu gestor.","Reimpressใo")
	Return
Endif

If mv_par11 == 2 // Nใo. 

	_cQuery += _cEnter + " SELECT Z03.*, "
	_cQuery += _cEnter + "        A1_NOME, " 
	_cQuery += _cEnter + "        A1_COD, "
	_cQuery += _cEnter + "        A1_LOJA, "
	_cQuery += _cEnter + "        Z03_VOLUME, "	 
	_cQuery += _cEnter + "        ENDER  = CASE WHEN A1_ENDENT = '' THEN A1_END    ELSE A1_ENDENT  END, "
	_cQuery += _cEnter + "        BAIRRO = CASE WHEN A1_ENDENT = '' THEN A1_BAIRRO ELSE A1_BAIRROE END, "
	_cQuery += _cEnter + "        CEP    = CASE WHEN A1_ENDENT = '' THEN A1_CEP    ELSE A1_CEPE    END, "
	_cQuery += _cEnter + "        MUNIC  = CASE WHEN A1_ENDENT = '' THEN A1_MUN    ELSE A1_MUNE    END, "
	_cQuery += _cEnter + "        EST    = CASE WHEN A1_ENDENT = '' THEN A1_EST    ELSE A1_ESTE    END  "	
	_cQuery += _cEnter + "  FROM " + RetSqlName("Z03") + " Z03 " 	
	_cQuery += _cEnter + "  INNER JOIN " + RetSqlName("SA1")  + " SA1 "	
	_cQuery += _cEnter + "  	ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = Z03_DESTIN AND A1_LOJA = Z03_LOJDST AND SA1.D_E_L_E_T_ <> '*' " 	
	_cQuery += _cEnter + "        WHERE Z03.D_E_L_E_T_ <> '*' "
	_cQuery += _cEnter + "        AND Z03_FILIAL = '" + xFilial("Z03") + "' "	
	_cQuery += _cEnter + " 	      AND Z03_DOC     BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	_cQuery += _cEnter + " 	      AND Z03_SERIE   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	_cQuery += _cEnter + " 	      AND Z03_EMISSA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' " 
	_cQuery += _cEnter + " 	      AND Z03_DESTIN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' " 
	_cQuery += _cEnter + " 	      AND Z03_LOJDST  BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	_cQuery += _cEnter + " ORDER BY Z03_SERIE, Z03_DOC, Z03_EMISSA "

Else 
	
	_cQuery += _cEnter + " SELECT D2.*, "
	_cQuery += _cEnter + "        A1_NOME, "
	_cQuery += _cEnter + "        A1_COD, "
	_cQuery += _cEnter + "        A1_LOJA, " 
	_cQuery += _cEnter + "        A1_CGC, "
	_cQuery += _cEnter + "        F2_VOLUME1, "	 
	_cQuery += _cEnter + "        F2_PBRUTO, "
	_cQuery += _cEnter + "        F2_SERIE, "
	_cQuery += _cEnter + "        F2_EMISSAO, "
	_cQuery += _cEnter + "        ENDER  = CASE WHEN A1_ENDENT = '' THEN A1_END    ELSE A1_ENDENT  END, "
	_cQuery += _cEnter + "        BAIRRO = CASE WHEN A1_ENDENT = '' THEN A1_BAIRRO ELSE A1_BAIRROE END, "
	_cQuery += _cEnter + "        CEP    = CASE WHEN A1_ENDENT = '' THEN A1_CEP    ELSE A1_CEPE    END, "
	_cQuery += _cEnter + "        MUNIC  = CASE WHEN A1_ENDENT = '' THEN A1_MUN    ELSE A1_MUNE    END, "
	_cQuery += _cEnter + "        EST    = CASE WHEN A1_ENDENT = '' THEN A1_EST    ELSE A1_ESTE    END  "
	_cQuery += _cEnter + " FROM   ( "
	_cQuery += _cEnter + " 	SELECT D2_DOC, D2_EMISSAO, D2_SERIE, COUNT(*) QTDITENS, D2_CLIENTE, D2_LOJA "
	_cQuery += _cEnter + " 	FROM   "+RetSqlName("SD2")+" AS D2 "
	_cQuery += _cEnter + " 	WHERE  D2.D_E_L_E_T_ = '' "
	_cQuery += _cEnter + " 	       AND D2_FILIAL = '"+xFilial("SD2")+"' "                         	
	_cQuery += _cEnter + " 	       AND D2_DOC     BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	_cQuery += _cEnter + " 	       AND D2_SERIE   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	_cQuery += _cEnter + " 	       AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' " 
	_cQuery += _cEnter + " 	       AND D2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "  
	_cQuery += _cEnter + " 	       AND D2_LOJA    BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' " 	 	
	_cQuery += _cEnter + " 	       AND D2_TIPO = 'N' "
	_cQuery += _cEnter + " 	GROUP BY D2_DOC, D2_EMISSAO, D2_SERIE, D2_CLIENTE, D2_LOJA "
	_cQuery += _cEnter + " 	) AS D2 "	
	_cQuery += _cEnter + " JOIN   "+RetSqlName("SF2")+" AS F2 "
	_cQuery += _cEnter + " ON     F2.F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE " 
	_cQuery += _cEnter + " AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2.D_E_L_E_T_ = ''  "	
	_cQuery += _cEnter + " JOIN   "+RetSqlName("SA1")+" AS A1 "
	_cQuery += _cEnter + " ON     A1.A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ''  "
	_cQuery += _cEnter + " ORDER BY D2_SERIE, D2_DOC, D2_EMISSAO "

EndIf

memowrite('fatr004.sql',_cQuery)
_cQuery := strtran(_cQuery,_cEnter,"")

// Fecha arquivo temporario caso ele esteja aberto
if Select("TRB") > 0
	TRB->(dbCloseArea())
endif

// Cria ARQUIVO TEMPORARIO com o resultado da QUERY
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
dbselectarea("TRB")
TRB->(dbgotop())

while TRB->(!eof()) 

	If mv_par11 == 2		
	
		aadd(_aEtiq, {	alltrim(cValtoChar(TRB->Z03_VOLUME)),; //1.Volume
						alltrim(TRB->Z03_OBJETO)			,; //2.Objeto, usado tambem no c๓digo de barras
						alltrim(_cDtPostag)	   				,; //3.Data da Postagem
						alltrim(TRB->A1_NOME) 				,; //4.Destinatario
						alltrim(TRB->ENDER)	  				,; //5.Endere็o do Destinatario
						alltrim(TRB->BAIRRO)  				,; //6.Bairro do Destinatario
						alltrim(TRB->CEP)					,; //7.CEP do Destinatario, usado tambem no c๓digo de barras
						alltrim(TRB->MUNIC)					,; //8.Cidade do Destinatario
						alltrim(TRB->EST)					,; //9.Estado do Destinatario
						alltrim(SM0->M0_NOMECOM)			,; //10.Remetente
						alltrim(SM0->M0_ENDENT)				,; //11.Endere็o do Remetente
						alltrim(SM0->M0_BAIRENT)			,; //12.Bairro do Remetente
						alltrim(SM0->M0_CEPENT)				,; //13.CEP do Remetente, usado tambem no c๓digo de barras
						alltrim(SM0->M0_CIDENT)				,; //14.Cidade do Remetente
						alltrim(SM0->M0_ESTENT)				,; //15.Estado do Remetente 
						alltrim(TRB->Z03_DOC)				,; //16.Numero do Documento
						alltrim(cValtoChar(TRB->Z03_PESO))	,; //17.Peso Bruto
						alltrim(TRB->Z03_CRPOST)			,; //18. Nr. do Cartao de Postagem 						 
						alltrim(TRB->Z03_TSECD)				,; //19. Codigo Chancela Sedex						
						alltrim(TRB->Z03_TESECD)			,; //20. Codigo Chancela E-Sedex 
						alltrim(TRB->Z03_TXSED)				,; //21. Texto Chancela	
						alltrim(TRB->Z03_SERIE)				,; //22. Serie do Documento
						alltrim(TRB->Z03_EMISSA)			,; //23. Emissao do Documento											
						alltrim(TRB->Z03_DESTIN)			,; //24. Codigo do Cliente 						
						alltrim(TRB->Z03_LOJDST)			,; //25. Loja do Cliente 						
						alltrim(TRB->Z03_CODADM)			}) //26. Codigo Administrativo
	Else 
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOpera็ใo chumbada temporariamente no programa at้ que se definaณ
		//ณa regra a ser parametrizada pelas partes envolvidas.           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	    
	    If 'SONY' $ UPPER(alltrim(cNomeCli)) 
			If (TRB->A1_CGC == "J" .and. TRB->EST == "SP")
				apMsgInfo('Cliente CNPJ do estado de Sใo Paulo, nใo permitido para esta opera็ใo. Revise os parโmetros informados.','Nenhuma etiqueta foi gerada!')
				lRet := .F.
			EndIf
		EndIf
		If lRet
			If NExistZ03()			
			    			   	
			   	If cTpPost $ "2,4,6,7"																			
					lSedex := U_SchCEP(alltrim(TRB->CEP))
				   	_cObjeto:= U_GetObj(Iif(!lSedex,"DN","DM"),Alltrim(cCodAdm))											   											   	
			   	Else
			   		If cTpPost $ "1,5"										   	                                            
			   			_cObjeto := U_GetObj("DN",Alltrim(cCodAdm))
			   			lNoCep	:= .T.
			   		Else
			   			If cTpPost $ "3"                                            
			   				_cObjeto := U_GetObj("PI",Alltrim(cCodAdm))
			   				lNoCep	:= .T.
			   			EndIf
			   		EndIf			
			   	EndIf				
				
				lProces := .F.
				nStack  := 0
				lMsg    := .F.
				cObj	:= ""
				
				If !Empty(_cObjeto)
				
		        	_cObjeto := U_Calcdigv(_cObjeto)	        
		        		        		        
					aadd(_aEtiq, {	alltrim(cValtoChar(TRB->F2_VOLUME1)),; //1.Volume
									alltrim(_cObjeto)					,; //2.Objeto, usado tambem no c๓digo de barras
									alltrim(_cDtPostag)	   				,; //3.Data da Postagem
									alltrim(TRB->A1_NOME) 				,; //4.Destinatario
									alltrim(TRB->ENDER)	  				,; //5.Endere็o do Destinatario
									alltrim(TRB->BAIRRO)  				,; //6.Bairro do Destinatario
									alltrim(TRB->CEP)					,; //7.CEP do Destinatario, usado tambem no c๓digo de barras
									alltrim(TRB->MUNIC)					,; //8.Cidade do Destinatario
									alltrim(TRB->EST)					,; //9.Estado do Destinatario
									alltrim(SM0->M0_NOMECOM)			,; //10.Remetente
									alltrim(SM0->M0_ENDENT)				,; //11.Endere็o do Remetente
									alltrim(SM0->M0_BAIRENT)			,; //12.Bairro do Remetente
									alltrim(SM0->M0_CEPENT)				,; //13.CEP do Remetente, usado tambem no c๓digo de barras
									alltrim(SM0->M0_CIDENT)				,; //14.Cidade do Remetente
									alltrim(SM0->M0_ESTENT)				,; //15.Estado do Remetente
									alltrim(TRB->D2_DOC)				,; //16.Numero do Documento								
									alltrim(cValtoChar(TRB->F2_PBRUTO))	,; //17.Peso Bruto
									alltrim(cCartPost)					,; //18. Nr. do Cartao de Postagem 					
									alltrim(cSedexCod)					,; //19. Codigo Chancela Sedex 						
									alltrim(cESedexCod)					,; //20. Codigo Chancela E-Sedex  
									alltrim(cTxtSedex)					,; //21. Texto Chancela
									alltrim(TRB->F2_SERIE)				,; //22. Serie do Documento
									alltrim(TRB->F2_EMISSAO)			,; //23. Emissao do Documento
									alltrim(TRB->A1_COD)				,; //24. Codigo do Cliente
									alltrim(TRB->A1_LOJA)				,; //25. Loja do Cliente									
									alltrim(cCodAdm)					}) //26. Codigo Administrativo
				Else
					lObjVaz := .T.
				EndIf					
			EndIf
		EndIf																	
	EndIf
	
	TRB->(dbSkip())

enddo

// Processa impressao das etiquetas
if len(_aEtiq) > 0
	U_ImpEtiq01(_aEtiq,mv_par11 <> 2,.T.,lNoCep) 
else
	If !lObjVaz
		apMsgInfo('Nใo foram encontradas etiquetas a serem impressas. Revise os parโmetros informados.','Nenhuma etiqueta foi gerada!')
	EndIf	
endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NExistZ03()

Local aArea := GetArea()
Local lRet 	 := .F.
Local cQuery := ""    

cQuery := " SELECT * FROM " + RetSqlName("Z03") + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND Z03_FILIAL = '" + xFilial("Z03") + "' " + CRLF 
cQuery += " AND Z03_DOC = '" + TRB->D2_DOC + "' " + CRLF
cQuery += " AND Z03_SERIE = '" + TRB->F2_SERIE + "' " + CRLF 
cQuery += " AND Z03_EMISSA = '" + TRB->F2_EMISSAO + "' " + CRLF  
cQuery += " AND Z03_DESTIN = '" + TRB->A1_COD + "' " + CRLF 
cQuery += " AND Z03_LOJDST = '" + TRB->A1_LOJA + "' " + CRLF

If Select("QRYZ03") > 0
	QRYZ03->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ03",.T.,.T.)

QRYZ03->(dbGoTop())

If QRYZ03->(eof())
	lRet := .T.
Else 
	If MsgYesNo("Jแ foi impressa uma etiqueta com esta NF e serie. Voc๊ tem certeza que quer gerar um novo objeto ?")
		lRet := .T.
	EndIf	
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpEtiq01(_aEtiq,lAtuObj,lMenu,lNoCep)

Local _aCol := {7,11,24,33,43,40,45,60,31,40,75,65,68,30,78,77,67} //COL[5]=50
Local _aLin := {7,11,19,18,23,29,35,39,57,63,67,71,75,81,109,115,119,123,127,135}//LIN[1]=10
Local _aTam := {"038,043","040,045","045,045","045,045","025,025","075,075","035,035"}  

Local _cFon := "0"  
Local _nXIni, _nXFim
Local _nYIni, _nYFim
Local _cLogo := "" //Caminho do logo no servidor a partir da pasta system
Local _cDirecao := "N"
Local lSedex 

Default lAtuObj := .F.
Default lNoCep	:= .F.

_nXIni := 5
_nXIni := 145

_nYIni := 5
_nYIni := 100

MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)

For _nI := 1 to Len(_aEtiq) 
    
	If !lNoCep
		lSedex := U_SchCEP(_aEtiq[_nI,7])
	Else
		lSedex := .F.
	EndIf		  
	
	If !lSedex
		MSCBLOADGRF("SEDEX.GRF") //Carrega a imagem para memoria da impressora
	Else
	  	MSCBLOADGRF("E_SEDEX.GRF") //Carrega a imagem para memoria da impressora
	EndIf
	
	MSCBBEGIN(1,6)
	
	// Imprime a imagem da chancela da SONY/CORREIOS
	If !lSedex
		MSCBGRAFIC(_aCol[12],_aLin[02],"SEDEX")
	Else
    	MSCBGRAFIC(_aCol[12],_aLin[02],"E_SEDEX")
	EndIf
	
	//Texto dentro da chancela SONY/CORREIOS
	If !lSedex
		MSCBSAY(_aCol[13], 18.7 ,Alltrim(_aEtiq[_nI,19]) 	,_cDirecao ,_cFon ,_aTam[5]) // Linha 01 / Coluna 03 - 		
	Else
	  	MSCBSAY(_aCol[13], 18.7 ,Alltrim(_aEtiq[_nI,20]) 	,_cDirecao ,_cFon ,_aTam[5]) // Linha 01 / Coluna 03 - 	  	
	EndIf
	
	MSCBSAY(_aCol[13], 21.2 ,SubStr(Alltrim(_aEtiq[_nI,21]),1,17) 	,_cDirecao ,_cFon ,_aTam[5]) // Linha 01 / Coluna 03 - 
	MSCBSAY(_aCol[13], 23.5 ,SubStr(Alltrim(_aEtiq[_nI,21]),18)		,_cDirecao ,_cFon ,_aTam[5]) // Linha 01 / Coluna 03 - 

	//Titulos
	MSCBSAY(_aCol[3] ,_aLin[01] ,"Cartao de Postagem"	,_cDirecao ,_cFon ,_aTam[1]) // Linha 01 / Coluna 03 - Cartao de Postagem
	MSCBSAY(_aCol[3] ,_aLin[03] ,"NF: "              	,_cDirecao ,_cFon ,_aTam[1]) // Linha 05 / Coluna 03 - NF
	MSCBSAY(_aCol[3] ,_aLin[05] ,"GCCAP/CTE JAGUARE"   	,_cDirecao ,_cFon ,_aTam[1]) // Linha 03 / Coluna 03 - ACC...	
	MSCBSAY(_aCol[3] ,_aLin[06] ,"Volume:"            	,_cDirecao ,_cFon ,_aTam[1]) // Linha 06 / Coluna 03 - Volume
	MSCBSAY(_aCol[1] ,_aLin[09] ,"DESTINATARIO"       	,_cDirecao ,_cFon ,_aTam[1]) // Linha 09 / Coluna 01 - Destinatario
	MSCBSAY(_aCol[6] ,_aLin[09] ,"Data da Postagem:"   	,_cDirecao ,_cFon ,_aTam[1]) // Linha 09 / Coluna 04 - Data de Postagem
	MSCBSAY(_aCol[1] ,_aLin[15] ,"REMETENTE"          	,_cDirecao ,_cFon ,_aTam[1]) // Linha 15 / Coluna 01 - Remetente
	MSCBSAY(_aCol[1] ,_aLin[20] ,"Obs.:"              	,_cDirecao ,_cFon ,_aTam[1]) // Linha 20 / Coluna 01 - Obs
	
	//Valores
	MSCBSAY(_aCol[3]  ,_aLin[02] ,_aEtiq[_nI,18]	,_cDirecao ,_cFon ,_aTam[1]) // Nr. do Cartao de Postagem 
	MSCBSAY(_aCol[9]  ,_aLin[03] ,_aEtiq[_nI,16] 	,_cDirecao ,_cFon ,_aTam[1]) // Nr. NF
	MSCBSAY(_aCol[10] ,_aLin[06] ,_aEtiq[_nI,1] 	,_cDirecao ,_cFon ,_aTam[1]) //Volume
	MSCBSAY(_aCol[14] ,_aLin[07] ,_aEtiq[_nI,2] 	,_cDirecao ,_cFon ,_aTam[1]) //Objeto
	MSCBSAY(_aCol[11] ,_aLin[09] ,_aEtiq[_nI,3] 	,_cDirecao ,_cFon ,_aTam[1]) //Data de Postagem
	
	MSCBSAY(_aCol[1]  ,_aLin[10] ,_aEtiq[_nI,4] 	,_cDirecao ,_cFon ,_aTam[1]) //Destinatario
	MSCBSAY(_aCol[1]  ,_aLin[11] ,_aEtiq[_nI,5] 	,_cDirecao ,_cFon ,_aTam[1]) //Endere็o + Numero do Destinatario
	MSCBSAY(_aCol[1]  ,_aLin[12] ,_aEtiq[_nI,6] 	,_cDirecao ,_cFon ,_aTam[1]) //Bairro do Destinatario
	
	_cLinha13 := iif(len(_aEtiq[_nI,07]) == 8, left(_aEtiq[_nI,07],5)+"-"+substr(_aEtiq[_nI,07],6,3), _aEtiq[_nI,07]) + " - " 
	_cLinha13 += _aEtiq[_nI,08] + " - " + _aEtiq[_nI,09] 
	
	MSCBSAY(_aCol[1] ,_aLin[13]  ,_cLinha13			,_cDirecao ,_cFon ,_aTam[1]) //Cep + Cidade + Estado do Destinatario	
	MSCBSAY(_aCol[1] ,_aLin[16]  ,_aEtiq[_nI,10] 	,_cDirecao ,_cFon ,_aTam[1]) //Remetente
	MSCBSAY(_aCol[1] ,_aLin[17]  ,_aEtiq[_nI,11] 	,_cDirecao ,_cFon ,_aTam[1]) //Endere็o + Numero do Remetente
	MSCBSAY(_aCol[1] ,_aLin[18]  ,_aEtiq[_nI,12] 	,_cDirecao ,_cFon ,_aTam[1]) //Bairro do Remetente  
	
	_cLinha19 := iif(len(_aEtiq[_nI,13]) == 8, left(_aEtiq[_nI,13],5)+"-"+substr(_aEtiq[_nI,13],6,3), _aEtiq[_nI,13]) + " - " 
	_cLinha19 += _aEtiq[_nI,14] + " - " + _aEtiq[_nI,15] 
	
	MSCBSAY(_aCol[1] ,_aLin[19]  ,_cLinha19		 	,_cDirecao ,_cFon ,_aTam[1]) //Cep + Cidade + Estado do Remetente
    
    /*If !lSedex
		MSCBSAY(_aCol[17] ,95 ,"AR" 		,_cDirecao ,_cFon ,_aTam[6]) // AR - Opera็ใo Sedex
	EndIf*/
	  
	MSCBSAY(_aCol[17] ,103 ,"Peso(g):" 		,_cDirecao ,_cFon ,_aTam[7]) // Peso 
	MSCBSAY(_aCol[16] ,103 ,_aEtiq[_nI,17] 	,_cDirecao ,_cFon ,_aTam[7]) // Peso
	
	//Codigos de Barras
	MSCBSAYBAR(_aCol[2] ,_aLin[08] ,_aEtiq[_nI,2]	,_cDirecao,"MB07",16,.F.,.F.,.F.,,5,1,,,,) // Objeto
	MSCBSAYBAR(_aCol[3] ,_aLin[14] ,_aEtiq[_nI,7]	,_cDirecao,"MB07",25,.F.,.F.,.F.,,4,2,,,,) // CEP

	MSCBEND()
	
Next nX

MSCBCLOSEPRINTER()

If lAtuObj
	AtuTabObj(_aEtiq,lMenu) // Atualiza tabela com as etiquetas impressas e seus respectivos objetos
EndIf

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SchCEP(cCEP)

Local lRet := .T.
Local cQuery := ""

cQuery := " SELECT * FROM " + RetSqlName("ZB3") + CRLF 
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND ZB3_FILIAL = '" + xFilial("ZB3") + "' " + CRLF 
cQuery += " AND ZB3_CEPDE <= '" + cCEP + "' AND  ZB3_CEPATE >= '" + cCEP + "' " + CRLF

If Select("QRYCEP") > 0
	QRYCEP->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYCEP",.T.,.T.)

QRYCEP->(dbGoTop())

If QRYCEP->(eof())
	lRet := .F.
EndIf

Return lRet
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Calcdigv(_codobj)

Local _cdigver :=""
Local _cnewcobj:=""
Local _cparam  := "86423597"
Local _nsoma   :=0    
Local _lrest   := 0
Local cOriCod  := _codobj
Local _codobj  := Substr(_codobj,3,8) 

For lcont:=1 to 8
    _nsoma :=_nsoma + ABS(val(substr(_codobj,lcont,1))*val(substr(_cparam,lcont,1)))
Next               

_lrest  := mod(_nsoma,11)

Do case 
  case _lrest == 0
      _cdigver :="5"
  case _lrest == 1     
      _cdigver :="0"
  Otherwise 
    _cdigver :=str(11-_lrest)
Endcase   

//_cnewcobj:="SW"+alltrim(_codobj)+alltrim(_cdigver)+"BR"

_cnewcobj:= Substr(alltrim(cOriCod),1,10)+alltrim(_cdigver)+Substr(alltrim(cOriCod),11,2)

Return(_cnewcobj)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuTabObj(_aEtiq,lMenu)

For nx:=1 To Len(_aEtiq) 

	If Select("Z03") == 0
		DbSelectArea("Z03")
	EndIf	
	Z03->(DbSetOrder(1))
	Z03->(DbGoTop())  
	
	//Z03_FILIAL+Z03_DOC+Z03_SERIE+Z03_OBJETO+Z03_EMISSA
	If Z03->(!DbSeek(xFilial("Z03")+AvKey(_aEtiq[nx][16],"Z03_DOC")+AvKey(_aEtiq[nx][22],"Z03_SERIE")+AvKey(_aEtiq[nx][2],"Z03_OBJETO")+AvKey(Iif (lMenu,STOD(_aEtiq[nx][23]),_aEtiq[nx][23]),"Z03_EMISSA")))
		If Reclock("Z03",.T.)
		
			Z03->Z03_FILIAL := xFilial("Z03")
			Z03->Z03_DOC 	:= _aEtiq[nx][16]
			Z03->Z03_SERIE 	:= _aEtiq[nx][22]
			Z03->Z03_EMISSA := Iif (lMenu,STOD(_aEtiq[nx][23]),_aEtiq[nx][23])
			Z03->Z03_HORA 	:= Time()
			Z03->Z03_OBJETO := _aEtiq[nx][2]
			Z03->Z03_DESTIN := _aEtiq[nx][24]
			Z03->Z03_LOJDST := _aEtiq[nx][25]
			Z03->Z03_VOLUME := Val(_aEtiq[nx][1])
			Z03->Z03_PESO 	:= Val(_aEtiq[nx][17])
			Z03->Z03_CRPOST := _aEtiq[nx][18]
			Z03->Z03_TSECD 	:= _aEtiq[nx][19]
			Z03->Z03_TESECD := _aEtiq[nx][20]
			Z03->Z03_TXSED  := _aEtiq[nx][21] 
			Z03->Z03_IMPRE  := Iif (lMenu,'S','')
			Z03->Z03_CODADM := _aEtiq[nx][26]  
		
			Z03->(MsUnlock())
		EndIf	
	EndIf
	
	If lMenu
		If Select("SF2") == 0
			DbSelectArea("SF2")
		EndIf	
		SF2->(DbSetOrder(2))
		SF2->(DbGoTop())  
		
		If SF2->(DbSeek(xFilial("SF2")+AvKey(_aEtiq[nx][24],"F2_CLIENTE")+AvKey(_aEtiq[nx][25],"F2_LOJA")+AvKey(_aEtiq[nx][16],"F2_DOC")+AvKey(_aEtiq[nx][22],"F2_SERIE")))
			If Reclock("SF2",.F.)			
				SF2->F2_OBJETO  := _aEtiq[nx][2]			
				SF2->(MsUnlock())
			EndIf	
		EndIf
	EndIf	

Next nx	
	
Return   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

PutSX1(cPerg,"01","Da Nota"     		,"Da Nota"     		,"Da Nota"     			,"mv_ch1" ,"C",09,0,0,"G","",""   		,"",,"mv_par01",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"02","Ate Nota"    		,"Ate Nota"    		,"Ate Nota"    			,"mv_ch2" ,"C",09,0,0,"G","",""   		,"",,"mv_par02",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"03","Da S้rie"    		,"Da S้rie"    		,"Da S้rie"    			,"mv_ch3" ,"C",03,0,0,"G","",""   		,"",,"mv_par03",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"04","Ate S้rie"   		,"Ate S้rie"   		,"Ate S้rie"   			,"mv_ch4" ,"C",03,0,0,"G","",""   		,"",,"mv_par04",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"05","Da Emissao"  		,"Da Emissao"  		,"Da Emissao"  			,"mv_ch5" ,"D",08,0,0,"G","",""   		,"",,"mv_par05",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"06","Ate Emissao" 		,"Ate Emissao" 		,"Ate Emissao" 			,"mv_ch6" ,"D",08,0,0,"G","",""   		,"",,"mv_par06",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"07","Do Cliente"  		,"Do Cliente"  		,"Do Cliente"  			,"mv_ch7" ,"C",06,0,0,"G","","SA1"		,"",,"mv_par07",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"08","Ate Cliente" 		,"Ate Cliente" 		,"Ate Cliente" 			,"mv_ch8" ,"C",06,0,0,"G","","SA1"		,"",,"mv_par08",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"09","Da Loja"  			,"Da Loja"     		,"Da Loja"     			,"mv_ch9" ,"C",02,0,0,"G","",""   		,"",,"mv_par09",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"10","Ate Loja" 			,"Ate Loja"    		,"Ate Loja"    			,"mv_cha" ,"C",02,0,0,"G","",""   		,"",,"mv_par10",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"11","Novo Objeto?"		,"Novo Objeto?"		,"Novo Objeto?"			,"mv_chb" ,"N",01,0,0,"C","",""   		,"",,"mv_par11","Sim","","","","Nใo","","","","","","","","","","","")
PutSX1(cPerg,"12","Cliente Operacใo"  	,"Cliente Operacใo" ,"Cliente Operacใo"     ,"mv_chc" ,"C",06,0,0,"G","","A1CORR"	,"",,"mv_par12",""   ,"","","",""   ,"","","","","","","","","","","")
PutSX1(cPerg,"13","Loja Cli.Opera็ใo"	,"Loja Cli.Opera็ใo","Loja Cli.Opera็ใo"	,"mv_chd" ,"C",02,0,0,"G","",""   		,"",,"mv_par13",""   ,"","","",""   ,"","","","","","","","","","","")

Return