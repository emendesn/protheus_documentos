#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BackOrder³Autor ³ Vinicius Leonardo     ³ Data ³ 02/05/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualiza Back Order		                                   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras/Importação - BGH                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BackOrder() 

	Local _cQuery	:= "" 
	Local cSay		:= ""
	Local nTotSI	:= 0
	Local nTotSCI   := 0
	Local nTotPO	:= 0  
	Local nTotGer   := 0
	Local nTotPC 	:= 0
	Local nTotTrans := 0 
	Local nTotC1	:= 0
	Local nTotC7	:= 0
	Local lConf		:= .T.
	Local lTransito	:= .T.
	Local lAtraso	:= .T.
	//Local lImport	:= .F.
		
	Static oGroup1
	Static oSay  
	
	/*_cQuery := " SELECT MAX(C1_IMPORT) AS IMPORT "
	_cQuery += " FROM "+RetSQLName("SC1")+" SC1 (NOLOCK) "
	_cQuery += " WHERE "
	_cQuery += " SC1.D_E_L_E_T_ <> '*' "
	_cQuery += " AND C1_FILIAL ='"+xFilial("SC1")+"' "
	_cQuery += " AND C1_PRODUTO = '"+SB2->B2_COD+"' "
	
	_cQuery := ChangeQuery(_cQuery) 
	If Select("TRBORI") > 0;TRBORI->( dbCloseArea() );EndIf
	dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBORI", .t., .t.)
	TRBORI->( dbGoTop() )
	
	If TRBORI->(!Eof())	
		If TRBORI->IMPORT == 'S'
			lImport := .T.
		EndIf
	EndIf
	TRBORI->(dbCloseArea())*/
	
	//If lImport 		    
	
		//SC IMPORTAÇÃO
		_cQuery := " SELECT "
		_cQuery += " C1_DATPRF, "
		_cQuery += " SUM(C1_QUANT-C1_QUJE) AS SALDO "
		_cQuery += " FROM "+RetSQLName("SC1")+" SC1 (NOLOCK) "
		_cQuery += " WHERE "
		_cQuery += " SC1.D_E_L_E_T_ = '' "
		_cQuery += " AND C1_FILIAL ='"+xFilial("SC1")+"' "
		_cQuery += " AND (C1_QUANT-C1_QUJE) > 0 "
		_cQuery += " AND C1_PRODUTO = '"+SB2->B2_COD+"' "
		_cQuery += " AND C1_IMPORT = 'S' "
		_cQuery	+= " AND C1_RESIDUO <> 'S' "
		_cQuery += " GROUP BY C1_DATPRF "
		_cQuery += " ORDER BY C1_DATPRF "
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBSCI") > 0;TRBSCI->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBSCI", .t., .t.)
		TRBSCI->( dbGoTop() )
		
		cSay += CRLF + CRLF 
		cSay += ".::SOLICITAÇÃO DE COMPRAS EM ABERTO (IMPORTAÇÃO)::." + CRLF
		If TRBSCI->(!Eof()) 
			While TRBSCI->(!Eof())	
				cSay += "- Prev.Entrega - " + DTOC(STOD(TRBSCI->C1_DATPRF)) + ".....: " + Alltrim(Transform(TRBSCI->SALDO,"@E 999,999,999.9999")) + CRLF 
				nTotSCI += TRBSCI->SALDO
				TRBSCI->(dbSkip())
			EndDo 
			cSay += CRLF 
			cSay += "- Total SC.........................."+Alltrim(Transform(nTotSCI,"@E 999,999,999.9999"))
		Else
			cSay += "- Não há" + CRLF
		EndIf 	
		TRBSCI->(dbCloseArea())
	
		//Solicitação de Importação
		
		_cQuery := " SELECT " + CRLF
		_cQuery += " W1_DTENTR_, " + CRLF
		_cQuery += " SUM(W1_SALDO_Q) AS SALDO " + CRLF
		_cQuery += " FROM "+RetSQLName("SW1")+" SW1 (NOLOCK) " + CRLF
		_cQuery += " WHERE " + CRLF
		_cQuery += " W1_FILIAL ='"+xFilial("SW1")+"' " + CRLF
		_cQuery += " AND W1_COD_I = '"+SB2->B2_COD+"' " + CRLF
		_cQuery += " AND W1_SALDO_Q > 0 " + CRLF
		_cQuery += " AND W1_SEQ = 0 " + CRLF
		_cQuery += " AND SW1.D_E_L_E_T_ <> '*' " + CRLF
		_cQuery += " GROUP BY W1_DTENTR_ " + CRLF
		_cQuery += " ORDER BY W1_DTENTR_ "  + CRLF
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBSI") > 0;TRBSI->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBSI", .t., .t.)
		TRBSI->( dbGoTop() )
		
		cSay += CRLF + CRLF 
		cSay += ".::SOLICITAÇÃO DE IMPORTAÇÃO EM ABERTO::." + CRLF
		If TRBSI->(!Eof()) 
			While TRBSI->(!Eof())	
				cSay += "- Prev.Entrega - " + DTOC(STOD(TRBSI->W1_DTENTR_)) + ".....: " + Alltrim(Transform(TRBSI->SALDO,"@E 999,999,999.9999")) + CRLF 
				nTotSI += TRBSI->SALDO
				TRBSI->(dbSkip())
			EndDo 
			cSay += CRLF 
			cSay += "- Total SI.........................."+Alltrim(Transform(nTotSI,"@E 999,999,999.9999"))
		Else
			cSay += "- Não há" + CRLF
		EndIf 	
		TRBSI->(dbCloseArea()) 
		
		//Purchase Order Colocado
		
		_cQuery := " SELECT "  + CRLF
		_cQuery += " W5_DT_ENTR, "  + CRLF
		_cQuery += " SUM(W5_SALDO_Q) AS SALDO "  + CRLF
		_cQuery += " FROM "+RetSQLName("SW5")+" SW5 (NOLOCK) "  + CRLF
		_cQuery += " WHERE "  + CRLF
		_cQuery += " W5_FILIAL ='"+xFilial("SW5")+"' "  + CRLF
		_cQuery += " AND W5_COD_I = '"+SB2->B2_COD+"' "  + CRLF
		_cQuery += " AND W5_SALDO_Q > 0 "  + CRLF
		_cQuery += " AND W5_SEQ = 0 "  + CRLF
		_cQuery += " AND SW5.D_E_L_E_T_ = '' "  + CRLF
		_cQuery += " GROUP BY W5_DT_ENTR "  + CRLF
		_cQuery += " ORDER BY W5_DT_ENTR "  + CRLF
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBPO") > 0;TRBPO->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBPO", .t., .t.)
		TRBPO->( dbGoTop() ) 
		
		cSay += CRLF + CRLF  
		cSay += ".::PURCHASE ORDER EM ABERTO (COLOCADO)::." + CRLF
		If TRBPO->(!Eof()) 
			While TRBPO->(!Eof())	
				cSay += "- Prev.Entrega - " + DTOC(STOD(TRBPO->W5_DT_ENTR)) + ".....: " + Alltrim(Transform(TRBPO->SALDO,"@E 999,999,999.9999")) + CRLF 
				nTotPO += TRBPO->SALDO
				TRBPO->(dbSkip())
			EndDo 
			cSay += CRLF 
			cSay += "- Total PO Aberto.........................."+Alltrim(Transform(nTotPO,"@E 999,999,999.9999"))
		Else
			cSay += "- Não há" + CRLF
		EndIf 
		TRBPO->(dbCloseArea()) 	
		
		//PO CONFIRMADO E PO EM TRANSITO
		_cQuery := " SELECT "
		_cQuery += " W6_HAWB, "
		_cQuery += " W6_PRVENTR, "
		_cQuery += " W6_DT_EMB, "
		_cQuery += " W7_QTDE AS SALDO "
		_cQuery += " FROM "+RetSQLName("SW6")+" SW6 (NOLOCK), "+RetSQLName("SW7")+" SW7 (NOLOCK) "
		_cQuery += " WHERE "
		_cQuery += " W6_FILIAL ='"+xFilial("SW6")+"' "
		_cQuery += " AND SW6.D_E_L_E_T_ = '' "
		_cQuery += " AND W7_HAWB = W6_HAWB "
		_cQuery += " AND W7_COD_I = '"+SB2->B2_COD+"' "
		_cQuery += " AND SW7.D_E_L_E_T_ = '' "
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBPC") > 0;TRBPC->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBPC", .t., .t.)
		TRBPC->( dbGoTop() )
		
		If TRBPC->(!Eof()) 
			While TRBPC->(!Eof())
			
				_cQryF1 := " SELECT F1_STATUS "
				_cQryF1 += " FROM "+RetSQLName("SF1")+" SF1 (NOLOCK), "+RetSQLName("SD1")+" SD1 (NOLOCK) "
				_cQryF1 += " WHERE SF1.D_E_L_E_T_ = '' "
				_cQryF1 += " AND F1_FILIAL ='"+xFilial("SF1")+"' "
				_cQryF1 += " AND F1_HAWB = '"+TRBPC->W6_HAWB+"' "
				_cQryF1 += " AND F1_TIPO = 'N' "
				_cQryF1 += " AND D1_FILIAL ='"+xFilial("SD1")+"' "
				_cQryF1 += " AND D1_DOC = F1_DOC "
				_cQryF1 += " AND D1_SERIE = F1_SERIE "
				_cQryF1 += " AND D1_FORNECE = F1_FORNECE "
				_cQryF1 += " AND D1_LOJA = F1_LOJA "
				_cQryF1 += " AND D1_COD = '"+SB2->B2_COD+"' "
				_cQryF1 += " AND SD1.D_E_L_E_T_ = '' "
				
				If Select("QRYF1") > 0
					dbSelectArea("QRYF1")
					DbCloseArea()
				EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryF1),"QRYF1",.T.,.T.)
				
				If QRYF1->(!Eof())
					If EMPTY(QRYF1->F1_STATUS)//SÓ CONSIDERA SE A NOTA AINDA NAO FOI CLASSIFICADA					
						If empty(TRBPC->W6_PRVENTR) //CONSIDERA COMO ATRASO
							If lAtraso
								cSay += CRLF + CRLF  
								cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF
								lAtraso := .F.
							EndIf 						
							cSay += "- Prev.Entrega - Não há .....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
							nTotPC += TRBPC->SALDO			
						Else					
							If empty(TRBPC->W6_DT_EMB)//DATA EFETIVA DO EMBARQUE 
								If lConf
									cSay += CRLF + CRLF  
									cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF 
									lConf := .F.
								EndIf							
								cSay += "- Prev.Entrega - " + DTOC(STOD(TRBPC->W6_PRVENTR)) + ".....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
								nTotPC += TRBPC->SALDO
							Else 
								If lTransito 
									cSay += CRLF + CRLF  
									cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF 
									lTransito := .F.
								EndIf   
								cSay += "- Prev.Entrega - " + DTOC(STOD(TRBPC->W6_PRVENTR)) + ".....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
								nTotPC += TRBPC->SALDO
								//nTotTrans += TRBPC->SALDO
							Endif
						Endif				
					Endif
					If Select("QRYF1") > 0
						dbSelectArea("QRYF1")
						DbCloseArea()
					EndIf
				Else			
					If empty(TRBPC->W6_PRVENTR) //CONSIDERA COMO ATRASO
						If lAtraso 
							cSay += CRLF + CRLF  
							cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF
							lAtraso := .F.
						EndIf 						
						cSay += "- Prev.Entrega - Não há .....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
						nTotPC += TRBPC->SALDO
					Else					
						If empty(TRBPC->W6_DT_EMB)//DATA EFETIVA DO EMBARQUE
							If lConf   
								cSay += CRLF + CRLF  
								cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF 
								lConf := .F.
							EndIf							
							cSay += "- Prev.Entrega - " + DTOC(STOD(TRBPC->W6_PRVENTR)) + ".....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
							nTotPC += TRBPC->SALDO
						Else
							If lTransito 
								cSay += CRLF + CRLF  
								cSay += ".::PURCHASE ORDER EM TRANSITO::." + CRLF 
								lTransito := .F.
							EndIf   
							cSay += "- Prev.Entrega - " + DTOC(STOD(TRBPC->W6_PRVENTR)) + ".....: " + Alltrim(Transform(TRBPC->SALDO,"@E 999,999,999.9999")) + CRLF 
							nTotPC += TRBPC->SALDO
							//nTotTrans += TRBPC->SALDO
						Endif
					Endif			
				Endif
				TRBPC->(dbSkip())
			Enddo
			//cSay += CRLF  
			//cSay += "- Total PO Confirmado.........................."+Alltrim(Transform(nTotPC,"@E 999,999,999.9999"))
			nTotTrans += nTotPC
			cSay += CRLF + CRLF  
			cSay += "- Total em Trânsito......."+Alltrim(Transform(nTotTrans,"@E 999,999,999.9999"))
		Else
			cSay += CRLF
			cSay += "- Não há" + CRLF
		EndIf 
		TRBPC->(dbCloseArea())
		
		//If !lTransito
			//cSay += CRLF + CRLF  
			//cSay += "- Total em Trânsito......."+Alltrim(Transform(nTotTrans,"@E 999,999,999.9999"))
		//EndIf	
	
   	//Else	
	
		//SC PREVISTA E SC FIRME
		_cQuery := " SELECT "
		_cQuery += " C1_DATPRF, "
		_cQuery += " SUM(C1_QUANT-C1_QUJE) AS SALDO "
		_cQuery += " FROM "+RetSQLName("SC1")+" SC1 (NOLOCK) "
		_cQuery += " WHERE "
		_cQuery += " SC1.D_E_L_E_T_ = '' "
		_cQuery += " AND C1_FILIAL ='"+xFilial("SC1")+"' "
		_cQuery += " AND (C1_QUANT-C1_QUJE) > 0 "
		_cQuery += " AND C1_PRODUTO = '"+SB2->B2_COD+"' "
		_cQuery += " AND C1_IMPORT <> 'S' "
		_cQuery	+= " AND C1_RESIDUO <> 'S' "
		_cQuery += " GROUP BY C1_DATPRF "
		_cQuery += " ORDER BY C1_DATPRF "
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBC1") > 0;TRBC1->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBC1", .t., .t.)
		TRBC1->( dbGoTop() )
		
		cSay += CRLF + CRLF
		cSay += ".::SOLICITAÇÃO DE COMPRAS EM ABERTO::." + CRLF
		If TRBC1->(!Eof()) 
			While TRBC1->(!Eof())	
				cSay += "- Prev.Entrega - " + DTOC(STOD(TRBC1->C1_DATPRF)) + ".....: " + Alltrim(Transform(TRBC1->SALDO,"@E 999,999,999.9999")) + CRLF 
				nTotC1 += TRBC1->SALDO
				TRBC1->(dbSkip())
			EndDo 
			cSay += CRLF  
			cSay += "- Total SC.........................."+Alltrim(Transform(nTotC1,"@E 999,999,999.9999"))
		Else
			cSay += "- Não há" + CRLF
		EndIf 	
		TRBC1->(dbCloseArea())
		
		//PC ITENS NACIONAIS
		_cQuery := " SELECT "
		_cQuery += " C7_DATPRF, "
		_cQuery += " SUM(C7_QUANT-C7_QUJE) AS SALDO "
		_cQuery += " FROM "+RetSQLName("SC7")+" SC7 (NOLOCK) "
		_cQuery += " WHERE "
		_cQuery += " SC7.D_E_L_E_T_ = '' "
		_cQuery += " AND C7_FILIAL ='"+xFilial("SC7")+"' "
		_cQuery += " AND (C7_QUANT-C7_QUJE) > 0 "
		_cQuery += " AND C7_PRODUTO = '"+SB2->B2_COD+"' " 
		_cQuery += " AND C7_IMPORT <> 'S' "
		_cQuery	+= " AND C7_RESIDUO <> 'S' "
		_cQuery += " GROUP BY C7_DATPRF "
		_cQuery += " ORDER BY C7_DATPRF " 
		
		_cQuery := ChangeQuery(_cQuery) 
		If Select("TRBC7") > 0;TRBC7->( dbCloseArea() );EndIf
		dbUseArea(.t., "TOPCONN", TCGenQry(,,_cQuery), "TRBC7", .t., .t.)
		TRBC7->( dbGoTop() )
		
		cSay += CRLF + CRLF  
		cSay += ".::PEDIDO DE COMPRAS EM ABERTO::." + CRLF
		If TRBC7->(!Eof())                     
		
			While TRBC7->(!Eof())	
				cSay += "- Prev.Entrega - " + DTOC(STOD(TRBC7->C7_DATPRF)) + ".....: " + Alltrim(Transform(TRBC7->SALDO,"@E 999,999,999.9999")) + CRLF 
				nTotC7 += TRBC7->SALDO
				TRBC7->(dbSkip())
			EndDo 
			cSay += CRLF  
			cSay += "- Total PC.........................."+Alltrim(Transform(nTotC7,"@E 999,999,999.9999"))
		Else
			cSay += "- Não há" + CRLF
		EndIf 	
		TRBC7->(dbCloseArea())
	//EndIf	
	
	DEFINE MSDIALOG oDlg TITLE "Detalhes dos Processos de Compras/Importação" FROM 000, 000  TO 700, 500 COLORS 0, 16777215 PIXEL
	                                    
		@ 017, 003 GROUP oGroup1 TO 350, 250 PROMPT "Produto: " + SB2->B2_COD OF oDlg COLOR 0, 16777215 PIXEL
				
		@ 030, 007 SAY oSay PROMPT cSay SIZE 250, 250 OF oDlg COLORS 0, 16777215 PIXEL 		
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg, {|| oDlg:END() },{|| oDlg:END() },.F.))  

Return 