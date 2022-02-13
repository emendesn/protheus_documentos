#include "protheus.ch"
#include "report.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RBKORD	 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Back Order (TReport) 		                   ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RBKORD()        

	If FindFunction("TRepInUse") 
		IMPREL()
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPREL	 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Perguntas e validação                                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPREL()	
	Local oReport 	:= NIL
	Local cPerg 	:= "RBKORD"
	Local llEmpty	:= .T.	
	    
	AjustaSx1(cPerg)
	While llEmpty
		If Pergunte(cPerg,.T.)
			If !(llEmpty := !(KZVALIDPAR()))
		   		oReport := ReportDef(cPerg)
		   		oReport :PrintDialog()	
			EndIf
		Else
			llEmpty	:= .F.			
		EndIf
	EndDo
		
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Método TReport		                                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(clPerg)

	Local oReport	:= Nil
	Local oSection	:= Nil
	
	oReport := TReport():New("Back Order","Relatório de Back Order",clPerg,{|oReport| PrintReport(oReport)},"Relatório de Back Order")   
	oReport:SetLandscape()  
  	oSection1 := TRSection():New(oReport ,"",{"QRY"}) 

Return oReport
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintReport Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatório	                                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintReport(oReport)
 
	Local oSection1	:= oReport:Section(1)
	Local cQuery	:= ""  
	Local cDescLi	:= ""  
	Local cChave	:= ""
	Local cPODe		:= MV_PAR01
	Local cPOAte	:= MV_PAR02
	Local oBreack	:= Nil
	
	Local clPath   	:= ""
	Local clFile   	:= ""
	Local clExcel 	:= ""
	Local nlHandle 	:= 0

	If !KZVALIDPAR()
		Return
	EndIf	
	
	_cQuery := " 	SELECT W3_COD_I AS COD_I, " + CRLF 
	_cQuery += " 	 	W3_SALDO_Q AS SALDO_Q,  " + CRLF
	_cQuery += " 	 	W3_PO_NUM AS PO_NUM,  " + CRLF
	_cQuery += " 	 	W3_PRECO AS PRECO,  " + CRLF 
	_cQuery += " 	 	W3_QTDE AS QTDE,  " + CRLF
	_cQuery += " 	 	(W3_PRECO * W3_QTDE) AS TOTAL,  " + CRLF
	_cQuery += " 	 	W3_PESOL AS PESOL,  " + CRLF
	_cQuery += " 	 	W3_PESO_BR AS PESO_BR,  " + CRLF
	_cQuery += " 	 	A5_CODPRF AS CODPRF,  " + CRLF
	_cQuery += " 	 	W3_FORN AS FORN,  " + CRLF
	_cQuery += " 	 	W3_FABR AS FABR,  " + CRLF
	_cQuery += " 	 	W2_TIPO_EM AS TIPO_EM,  " + CRLF
	_cQuery += " 	 	W2_INCOTER AS INCOTER,  " + CRLF
	_cQuery += " 	 	W2_ORIGEM AS ORIGEM,  " + CRLF
	_cQuery += " 	    CONVERT(DATE,W3_DT_ENTR,112) AS DT_ENTR,  " + CRLF
	_cQuery += " 	    CONVERT(DATE,W3_DT_EMB,112) AS DT_EMB,  " + CRLF 
	_cQuery += " 	    CONVERT(DATE,C1_DATPRF,112) AS C1_DATPRF,  " + CRLF	
	_cQuery += " 	 	W3_TEC AS TEC  " + CRLF
	_cQuery += " 	 	FROM  " +RetSqlName("SW3") + "  SW3 (NOLOCK)  " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SB1") + "  SB1 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SB1.B1_COD = SW3.W3_COD_I AND SB1.D_E_L_E_T_ <> '*'   " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SA5") + "  SA5 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SA5.A5_PRODUTO = SW3.W3_COD_I AND SA5.A5_FORNECE = SW3.W3_FORN AND SA5.A5_LOJA = SW3.W3_FORLOJ AND SA5.D_E_L_E_T_ <> '*'   " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SW2") + "  SW2 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SW2.W2_PO_NUM = SW3.W3_PO_NUM AND SW3.W3_FILIAL = SW2.W2_FILIAL AND SW2.D_E_L_E_T_ <> '*' 	  " + CRLF	
	_cQuery += " 	 	LEFT JOIN  " +RetSqlName("SC1") + "  SC1 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SC1.C1_NUM_SI = SW3.W3_SI_NUM AND SW3.W3_FILIAL = SC1.C1_FILIAL AND SC1.D_E_L_E_T_ <> '*' 	  " + CRLF	
	_cQuery += " 	 	WHERE  " + CRLF
	_cQuery += " 	 	SW3.W3_FILIAL = '" + xFilial("SW3") + "'  " + CRLF
	_cQuery += " 	 	AND SW3.W3_PO_NUM BETWEEN '" + cPODe + "' AND '" + cPOAte + "' 	  " + CRLF
	_cQuery += " 	 	AND SW3.W3_SALDO_Q > 0  " + CRLF
	_cQuery += " 	 	AND SW3.W3_SEQ = 0  " + CRLF
	_cQuery += " 	 	AND SW3.D_E_L_E_T_ <> '*'  " + CRLF
	
	_cQuery += " 	UNION " + CRLF    
		
	_cQuery += " 	SELECT W5_COD_I AS COD_I, " + CRLF 
	_cQuery += " 	 	W5_SALDO_Q AS SALDO_Q,  " + CRLF
	_cQuery += " 	 	W5_PO_NUM AS PO_NUM,  " + CRLF
	_cQuery += " 	 	W5_PRECO AS PRECO,  " + CRLF
	_cQuery += " 	 	W5_QTDE AS QTDE,  " + CRLF
	_cQuery += " 	 	(W5_PRECO * W5_QTDE) AS TOTAL,  " + CRLF
	_cQuery += " 	 	W5_PESO AS PESOL,  " + CRLF
	_cQuery += " 	 	W5_PESO_BR AS PESO_BR,  " + CRLF
	_cQuery += " 	 	A5_CODPRF AS CODPRF,  " + CRLF
	_cQuery += " 	 	W5_FORN AS FORN,  " + CRLF
	_cQuery += " 	 	W5_FABR AS FABR,  " + CRLF
	_cQuery += " 	 	W2_TIPO_EM AS TIPO_EM,  " + CRLF
	_cQuery += " 	 	W2_INCOTER AS INCOTER,  " + CRLF
	_cQuery += " 	 	W2_ORIGEM AS ORIGEM,  " + CRLF
	_cQuery += " 	    CONVERT(DATE,W5_DT_ENTR,112) AS DT_ENTR,  " + CRLF
	_cQuery += " 	    CONVERT(DATE,W5_DT_EMB,112) AS DT_EMB,  " + CRLF 	
	_cQuery += " 	    CONVERT(DATE,C1_DATPRF,112) AS C1_DATPRF,  " + CRLF	
	_cQuery += " 	 	W5_TEC AS TEC  " + CRLF
	_cQuery += " 	 	FROM  " +RetSqlName("SW5") + "  SW5 (NOLOCK)  " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SB1") + "  SB1 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SB1.B1_COD = SW5.W5_COD_I AND SB1.D_E_L_E_T_ <> '*'   " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SA5") + "  SA5 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SA5.A5_PRODUTO = SW5.W5_COD_I AND SA5.A5_FORNECE = SW5.W5_FORN AND SA5.A5_LOJA = SW5.W5_FORLOJ AND SA5.D_E_L_E_T_ <> '*'   " + CRLF
	_cQuery += " 	 	INNER JOIN  " +RetSqlName("SW4") + "  SW4 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SW4.W4_PGI_NUM = SW5.W5_PGI_NUM AND SW5.W5_FILIAL = SW4.W4_FILIAL AND SW4.D_E_L_E_T_ <> '*' 	  " + CRLF 	
	_cQuery += " 	 	INNER JOIN " +RetSqlName("SW3") + " SW3 (NOLOCK) 	  " + CRLF 
 	_cQuery += " 	 	ON SW5.W5_PGI_NUM = SW3.W3_PGI_NUM AND SW5.W5_FILIAL = SW3.W3_FILIAL AND SW3.D_E_L_E_T_ <> '*' 	  " + CRLF  
 	_cQuery += " 	 	INNER JOIN " +RetSqlName("SW2") + " SW2 (NOLOCK) 	  " + CRLF 
 	_cQuery += " 	 	ON SW2.W2_PO_NUM = SW3.W3_PO_NUM AND SW2.W2_FILIAL = SW3.W3_FILIAL AND SW2.D_E_L_E_T_ <> '*' 	  " + CRLF 
 	_cQuery += " 	 	LEFT JOIN  " +RetSqlName("SC1") + "  SC1 (NOLOCK)  " + CRLF
	_cQuery += " 	 	ON SC1.C1_NUM_SI = SW5.W5_SI_NUM AND SW5.W5_FILIAL = SC1.C1_FILIAL AND SC1.D_E_L_E_T_ <> '*' 	  " + CRLF	
	_cQuery += " 	 	WHERE  " + CRLF
	_cQuery += " 	 	SW5.W5_FILIAL = '" + xFilial("SW5") + "' " + CRLF
	_cQuery += " 	 	AND SW5.W5_PO_NUM BETWEEN '" + cPODe + "' AND '" + cPOAte + "' 	  " + CRLF
	_cQuery += " 	 	AND SW5.W5_SALDO_Q > 0  " + CRLF
	_cQuery += " 	 	AND SW5.W5_SEQ = 0  " + CRLF
	_cQuery += " 	 	AND SW5.D_E_L_E_T_ <> '*'  " + CRLF
	 	
	_cQuery += " 		ORDER BY DT_ENTR, COD_I   " + CRLF
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Secao                							             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
	
	TRCell():New(oSection1,"PO_NUM" 	,"QRY" 		,OEMTOANSI("No.P.O.")			,"@!"					,15)  
	TRCell():New(oSection1,"COD_I" 		,"QRY" 		,OEMTOANSI("Código Item")		,"@!"					,15)
	TRCell():New(oSection1,"VM_GI"		,"" 		,OEMTOANSI("Descrição LI")		,"@!"					,80) 	
	TRCell():New(oSection1,"QTDE"		,"QRY" 		,OEMTOANSI("Qtde P.O.")			,X3PICTURE("W3_QTDE")	,	,,,"RIGHT",.F.,"RIGHT")
	TRCell():New(oSection1,"SALDO_Q"	,"QRY" 		,OEMTOANSI("Saldo Qtde")		,X3PICTURE("W3_SALDO_Q"),	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"PRECO"  	,"QRY" 		,OEMTOANSI("Preço Unit.")		,X3PICTURE("W3_PRECO")	,	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"TOTAL"  	,"QRY" 		,OEMTOANSI("Valor Total")		,X3PICTURE("W3_PRECO")	,	,,,"RIGHT",.F.,"RIGHT") 
	TRCell():New(oSection1,"PESOL"  	,"QRY" 		,OEMTOANSI("Peso Líquido")		,X3PICTURE("W3_PESO")	,	,,,"RIGHT",.F.,"RIGHT")	 
	TRCell():New(oSection1,"PESO_BR"	,"QRY" 		,OEMTOANSI("Peso Total")		,X3PICTURE("W3_PESO_BR"),	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"CODPRF" 	,"QRY" 		,OEMTOANSI("Part Number")		,"@!"					,15) 
	TRCell():New(oSection1,"FORN" 		,"QRY" 		,OEMTOANSI("Fornecedor")		,"@!"					,15)  
	TRCell():New(oSection1,"FABR" 		,"QRY" 		,OEMTOANSI("Fabricante")		,"@!"					,15)
	TRCell():New(oSection1,"TIPO_EM"	,"QRY" 		,OEMTOANSI("Via Transp")		,"@!"					,15)
	TRCell():New(oSection1,"INCOTER"	,"QRY" 		,OEMTOANSI("Incoterm")			,"@!"					,15)
	TRCell():New(oSection1,"ORIGEM" 	,"QRY" 		,OEMTOANSI("Origem")			,"@!"					,15)	
	TRCell():New(oSection1,"DT_ENTR"	,"QRY" 		,OEMTOANSI("Dt Entrega")		,						,15	,,{||QRY->DT_ENTR})  	
	TRCell():New(oSection1,"DT_EMB" 	,"QRY" 		,OEMTOANSI("Dt Embarque")		,						,15	,,{||QRY->DT_EMB})  	 
	TRCell():New(oSection1,"C1_DATPRF" 	,"QRY" 		,OEMTOANSI("Dt Necessidade")	,						,15	,,{||QRY->C1_DATPRF})  	
	TRCell():New(oSection1,"TEC"	 	,"QRY" 		,OEMTOANSI("Pos.IPI/NCM")		,X3PICTURE("W3_TEC")	,15)	
	
	oSection1:Init() 
		
	While QRY->(!EOF())	
	    cDescLi := ""
	    
		If Select("SYP") == 0
			dbSelectArea( "SYP" )
		EndIf	
		SYP->( dbSetOrder(1) )
		SYP->( dbGoTop() )
		If SYP->( dbSeek( xFilial( "SYP" ) + Posicione("SB1", 1, xFilial("SB1") + QRY->COD_I,"B1_DESC_GI") ) ) 
			cChave:=SYP->YP_CHAVE
			While SYP->(!EOF()) .and. cChave==SYP->YP_CHAVE
				cDescLi += SYP->YP_TEXTO + " " 
				SYP->(DbSkip())
			EndDo	 
		EndIf		
		oSection1:Cell("VM_GI"):SetValue(cDescLi)
		
		oSection1:PrintLine()
	
		QRY->(DbSkip())
		
	EndDo
					
	oSection1:Finish()	 			
		
	QRY->(DbCloseArea())

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas	                                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)

	SX1->(dbSetOrder(1))
	If !SX1->(dbSeek(cPerg))

		PutSx1(cPerg,"01",OEMTOANSI("Da Purchase Order ?"	)	,OEMTOANSI("Da Purchase Order ?"   	)  	,OEMTOANSI("Da Purchase Order ?"	)   			,"MV_CH1"	,"C",15	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"02",OEMTOANSI("Até Purchase Order ?"	) 	,OEMTOANSI("Até Purchase Order ?"  	)  	,OEMTOANSI("Até Purchase Order ?"	) 				,"MV_CH2"	,"C",15	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
		
	EndIf 
			   	
Return Nil                                                                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ KZVALIDPAR³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validação das perguntas                                     ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function KZVALIDPAR()

	Local llRet := .T.

	If 	Empty(MV_PAR01) .AND. ;
		Empty(MV_PAR02) 
				  
	    MsgInfo(OEMTOANSI("Todos os campos estão em branco. Preencha pelo menos um parâmetro."))
		llRet := .F.
				
	EndIf
	
Return llRet 
