#include "protheus.ch"
#include "report.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RNECENT   ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Necessidade SC x Entrega PC (TReport)                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RNECENT()        

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
	Local cPerg 	:= "RNECENT"
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
	
	oReport := TReport():New("Necessidade SC x Entrega PC","Relatório Necessidade SC x Entrega PC",clPerg,{|oReport| PrintReport(oReport)},"Relatório Necessidade SC x Entrega PC")   
	oReport:SetLandscape()  
  	oSection1 := TRSection():New(oReport ,"",{"QRY"}) 
  	oSection2 := TRSection():New(oReport ,"",{"QRYSC"})

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
	Local oSection2	:= oReport:Section(2)
	Local cQuery	:= ""
	Local cPedDe	:= MV_PAR01
	Local cPedAte	:= MV_PAR02
	Local cForDe	:= MV_PAR03
	Local cForAte	:= MV_PAR04
	Local cLojDe	:= MV_PAR05
	Local cLojAte	:= MV_PAR06 
	Local cProdDe	:= MV_PAR07
	Local cProdAte	:= MV_PAR08
	Local cArmDe	:= MV_PAR09
	Local cArmAte	:= MV_PAR10  
	Local nTipo     := MV_PAR11
	Local oBreack	:= Nil
	
	Local clPath   		:= ""
	Local clFile   		:= ""
	Local clExcel 		:= ""
	Local nlHandle 		:= 0

	If !KZVALIDPAR()
		Return
	EndIf	
	    
	cQuery :=  "  SELECT " + CRLF 
    cQuery +=  " 	   C7_PRODUTO, " + CRLF
    cQuery +=  "	   B1_DESC, " + CRLF
    cQuery +=  "       C1_NUM, " + CRLF
	cQuery +=  "       C1_ITEM, " + CRLF
	cQuery +=  "       C1_QUANT, " + CRLF
	cQuery +=  "       CONVERT(DATE,C1_DATPRF,112) AS DTENTC1, " + CRLF
	cQuery +=  "       C7_FORNECE, " + CRLF
	cQuery +=  "       C7_LOJA, " + CRLF
	cQuery +=  "       A2_NOME, " + CRLF
	cQuery +=  "       C7_NUM, " + CRLF
	cQuery +=  "       C7_ITEM,  " + CRLF
	cQuery +=  "       C7_QUANT, " + CRLF
	cQuery +=  "       C7_QUANT-C7_QUJE AS SALDO, " + CRLF 	
	cQuery +=  "       CONVERT(DATE,C1_EMISSAO,112) AS C1_EMISSAO, " + CRLF 	
	cQuery +=  "       CONVERT(DATE,C7_EMISSAO,112) AS C7_EMISSAO, " + CRLF 	
	cQuery +=  "       CONVERT(DATE,C7_DATPRF,112) AS DTENTC7, " + CRLF  
	cQuery +=  "       DATEDIFF(day, CONVERT(DATE,C1_DATPRF,112), CONVERT(DATE,C7_DATPRF,112)) AS DELTA " + CRLF
	cQuery +=  "	FROM " + RetSqlName("SC7") + " SC7 " + CRLF
	cQuery +=  "	INNER JOIN " + RetSqlName("SC1") + " SC1 ON  " + CRLF
	cQuery +=  "       C1_FILIAL=C7_FILIAL AND  " + CRLF
	cQuery +=  "       C1_NUM=C7_NUMSC AND  " + CRLF
	cQuery +=  "       C1_ITEM=C7_ITEMSC AND  " + CRLF
	cQuery +=  "       C1_PRODUTO=C7_PRODUTO AND  " + CRLF
	cQuery +=  "       SC1.D_E_L_E_T_=''   " + CRLF
	cQuery +=  "	INNER JOIN " + RetSqlName("SA2") + " SA2 ON  " + CRLF
	cQuery +=  "       A2_COD=C7_FORNECE AND  " + CRLF
	cQuery +=  "       A2_LOJA=C7_LOJA AND  " + CRLF
	cQuery +=  "       SA2.D_E_L_E_T_ = '' " + CRLF
	cQuery +=  "	INNER JOIN " + RetSqlName("SB1") + " SB1 ON  " + CRLF
	cQuery +=  "       B1_COD=C7_PRODUTO AND  " + CRLF
	cQuery +=  "       SB1.D_E_L_E_T_ = '' " + CRLF
	cQuery +=  "	WHERE " + CRLF
	cQuery +=  "       C7_FILIAL='" + xFilial("SC7") + "' AND  " + CRLF
 	If nTipo == 1 
		cQuery +=  "             C7_QUANT-C7_QUJE > 0 AND " + CRLF
	ElseIf nTipo == 2
		cQuery +=  "             C7_QUANT-C7_QUJE = 0 AND " + CRLF  
	Endif
	cQuery +=  "       C7_RESIDUO <> 'S' AND  " + CRLF
	cQuery +=  "       SC7.D_E_L_E_T_=''   " + CRLF 	
	cQuery +=  " AND C7_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' " + CRLF
	cQuery +=  " AND C7_FORNECE BETWEEN '" + cForDe + "' AND '" + cForAte + "' " + CRLF
	cQuery +=  " AND C7_LOJA BETWEEN '" + cLojDe + "' AND '" + cLojAte + "' " + CRLF
	cQuery +=  " AND C7_PRODUTO BETWEEN '" + cProdDe + "' AND '" + cProdAte + "' " + CRLF
	cQuery +=  " AND C7_LOCAL BETWEEN '" + cArmDe + "' AND '" + cArmAte + "' " + CRLF	
	cQuery +=  "	ORDER BY C7_NUM,C7_ITEM,C7_PRODUTO " + CRLF	
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'QRY', .T., .T. ) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Secao 1              							             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	
	cQuery :=  " SELECT " + CRLF 
 	cQuery +=  "    C1_PRODUTO,  " + CRLF
	cQuery +=  "    B1_DESC,  " + CRLF
    cQuery +=  "    C1_NUM,  " + CRLF
    cQuery +=  "    C1_ITEM,  " + CRLF
    cQuery +=  "    C1_QUANT, " + CRLF
	cQuery +=  "    C1_QUANT-C1_QUJE AS SALDOSC,  " + CRLF
	cQuery +=  "    CONVERT(DATE,C1_EMISSAO,112) AS C1_EMISSAO, " + CRLF  
    cQuery +=  "    CONVERT(DATE,C1_DATPRF,112) AS DTENTC1 " + CRLF
	cQuery +=  " FROM " + RetSqlName("SC1") + " SC1 (NOLOCK)	 " + CRLF
	cQuery +=  " INNER JOIN " + RetSqlName("SB1") + " SB1 ON   " + CRLF
    cQuery +=  "    B1_COD=C1_PRODUTO AND   " + CRLF
    cQuery +=  "    SB1.D_E_L_E_T_ = '' 	 " + CRLF
	cQuery +=  " WHERE  " + CRLF
    cQuery +=  "    C1_FILIAL='" + xFilial("SC1") + "' AND     " + CRLF
	cQuery +=  "    C1_RESIDUO <> 'S' AND " + CRLF
	cQuery +=  "    C1_QUANT-C1_QUJE > 0 AND " + CRLF
    cQuery +=  "    SC1.D_E_L_E_T_=''    " + CRLF
	cQuery +=  " 	 AND C1_PRODUTO BETWEEN '" + cProdDe + "' AND '" + cProdAte + "' " + CRLF
	cQuery +=  " 	 AND C1_LOCAL BETWEEN '" + cArmDe + "' AND '" + cArmAte + "' " + CRLF
	cQuery +=  " ORDER BY C1_NUM,C1_ITEM,C1_PRODUTO  " + CRLF
	
	If Select("QRYSC") > 0
		QRYSC->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRYSC", .T., .T. )		

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Secao                							             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
			
	TRCell():New(oSection1,"C7_PRODUTO" ,"QRY" 		,OEMTOANSI("Produto")			,"@!"					,15)
	TRCell():New(oSection1,"B1_DESC"  	,"QRY" 		,OEMTOANSI("Descrição")			,"@!"					,40) 
	TRCell():New(oSection1,"C1_NUM"  	,"QRY" 		,OEMTOANSI("SC")				,"@!"					,6) 
	TRCell():New(oSection1,"C1_ITEM"  	,"QRY" 		,OEMTOANSI("Item SC")			,"@!"					,2)
	TRCell():New(oSection1,"C1_QUANT"  	,"QRY" 		,OEMTOANSI("Qtde SC")			,X3PICTURE("C1_QUANT")	,	,,,"RIGHT",.F.,"RIGHT") 
	TRCell():New(oSection1,"DTENTC1"  	,"QRY" 		,OEMTOANSI("Data Necessidade")	,						,15	,,{||QRY->DTENTC1})  	
	TRCell():New(oSection1,"C7_NUM"  	,"QRY" 		,OEMTOANSI("PC")				,"@!"					,15)	
	TRCell():New(oSection1,"C7_ITEM"  	,"QRY" 		,OEMTOANSI("Item PC")			,"@!"					,2)	
	TRCell():New(oSection1,"C7_FORNECE"	,"QRY" 		,OEMTOANSI("Fornecedor")		,"@!"					,6)
	TRCell():New(oSection1,"C7_LOJA" 	,"QRY" 		,OEMTOANSI("Loja")				,"@!"					,2)   	
	TRCell():New(oSection1,"A2_NOME"	,"QRY"		,OEMTOANSI("Nome")				,"@!"					,40)	
	TRCell():New(oSection1,"C7_QUANT"	,"QRY"		,OEMTOANSI("Qtde PC")			,X3PICTURE("C7_QUANT")	,	,,,"RIGHT",.F.,"RIGHT")
	TRCell():New(oSection1,"SALDO"		,"QRY"		,OEMTOANSI("Saldo")				,X3PICTURE("C7_QUANT")	,	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"C1_EMISSAO"	,"QRY"		,OEMTOANSI("Dt Emissao SC")		,						,20	,,{||QRY->C1_EMISSAO}) 	
	TRCell():New(oSection1,"C7_EMISSAO"	,"QRY"		,OEMTOANSI("Dt Emissao Pedido")	,						,20	,,{||QRY->C7_EMISSAO})	
	TRCell():New(oSection1,"DTENTC7"	,"QRY"		,OEMTOANSI("Data Entrega")		,						,20	,,{||QRY->DTENTC7})
	TRCell():New(oSection1,"DELTA"		,"QRY"		,OEMTOANSI("Delta")				,X3PICTURE("C7_QUANT")	,	,,,"RIGHT",.F.,"RIGHT")  
	
	TRCell():New(oSection2,"C1_PRODUTO" ,"QRYSC" 	,OEMTOANSI("Produto")			,"@!"					,15)
	TRCell():New(oSection2,"B1_DESC"  	,"QRYSC" 	,OEMTOANSI("Descrição")			,"@!"					,40) 
	TRCell():New(oSection2,"C1_NUM"  	,"QRYSC" 	,OEMTOANSI("SC")				,"@!"					,6) 
	TRCell():New(oSection2,"C1_ITEM"  	,"QRYSC" 	,OEMTOANSI("Item SC")			,"@!"					,2)
	TRCell():New(oSection2,"C1_QUANT"  	,"QRYSC" 	,OEMTOANSI("Qtde SC")			,X3PICTURE("C1_QUANT")	,	,,,"RIGHT",.F.,"RIGHT") 
	TRCell():New(oSection2,"C1_EMISSAO"	,"QRYSC"	,OEMTOANSI("Dt Emissao SC")		,						,20	,,{||QRYSC->C1_EMISSAO}) 	
	TRCell():New(oSection2,"DTENTC1"  	,"QRYSC" 	,OEMTOANSI("Data Necessidade")	,						,20	,,{||QRYSC->DTENTC1})  	
	TRCell():New(oSection2,"SALDOSC"	,"QRYSC"	,OEMTOANSI("Saldo")				,X3PICTURE("C1_QUANT")	,	,,,"RIGHT",.F.,"RIGHT")
								
	oSection1:Init() 					
	oSection1:Print()					
	oSection1:Finish() 					 
				
	oSection2:Init()     					
	oSection2:Print()					
	oSection2:Finish() 								
		
	QRY->(DbCloseArea())
	QRYSC->(DbCloseArea())

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

		PutSx1(cPerg,"01",OEMTOANSI("Pedido De?"	)	,OEMTOANSI("Pedido De?"   	)  	,OEMTOANSI("Pedido De?"	)   			,"MV_CH1"	,"C",6	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"02",OEMTOANSI("Pedido Ate?"	) 	,OEMTOANSI("Pedido Ate?"  	)  	,OEMTOANSI("Pedido Ate?"	) 			,"MV_CH2"	,"C",6	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
		
		PutSx1(cPerg,"03",OEMTOANSI("Fornecedor De?"	)	,OEMTOANSI("Fornecedor De?"   	)  	,OEMTOANSI("Fornecedor De?"	)   ,"MV_CH3"	,"C",6	,0,0,"G","","SA2"	,"","S","MV_PAR03",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"04",OEMTOANSI("Fornecedor Ate?"	) 	,OEMTOANSI("Fornecedor Ate?"  	)  	,OEMTOANSI("Fornecedor Ate?") 	,"MV_CH4"	,"C",6	,0,0,"G","","SA2"	,"","S","MV_PAR04",""		,"","","",""		,"","","","","","","","","","","","","","","")
	
		PutSx1(cPerg,"05",OEMTOANSI("Loja De?"	)	,OEMTOANSI("Loja De?"   	)  	,OEMTOANSI("Loja De?"	)   				,"MV_CH5"	,"C",2	,0,0,"G","",""		,"","S","MV_PAR05",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"06",OEMTOANSI("Loja Ate?"	) 	,OEMTOANSI("Loja Ate?"  	)  	,OEMTOANSI("Loja Ate?"	) 					,"MV_CH6"	,"C",2	,0,0,"G","",""		,"","S","MV_PAR06",""		,"","","",""		,"","","","","","","","","","","","","","","")
	
		PutSx1(cPerg,"07",OEMTOANSI("Produto De?"	)	,OEMTOANSI("Produto De?"   	)  	,OEMTOANSI("Produto De?"	)   		,"MV_CH7"	,"C",15	,0,0,"G","","SB1"	,"","S","MV_PAR07",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"08",OEMTOANSI("Produto Ate?"	) 	,OEMTOANSI("Produto Ate?"  	)  	,OEMTOANSI("Produto Ate?"	) 			,"MV_CH8"	,"C",15	,0,0,"G","","SB1"	,"","S","MV_PAR08",""		,"","","",""		,"","","","","","","","","","","","","","","")
	
		PutSx1(cPerg,"09",OEMTOANSI("Armazem De?"	)	,OEMTOANSI("Armazem De?"   	)  	,OEMTOANSI("Armazem De?"	)   		,"MV_CH9"	,"C",2	,0,0,"G","",""		,"","S","MV_PAR09",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"10",OEMTOANSI("Armazem Ate?"	) 	,OEMTOANSI("Armazem Ate?"  	)  	,OEMTOANSI("Armazem Ate?"	) 			,"MV_CH10"	,"C",2	,0,0,"G","",""		,"","S","MV_PAR10",""		,"","","",""		,"","","","","","","","","","","","","","","")
		
		PutSx1(cPerg,"11",OEMTOANSI("Tipo?")	,OEMTOANSI("Tipo?")		,OEMTOANSI("Tipo?")										,"MV_CH11"	,"N",01,00,0,"C","",""		,"","","MV_PAR11","Aberto"		,"Aberto"	,"Aberto"	,"","Atendido","Atendido","Atendido","","","","","","","","","","","","","")

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
		Empty(MV_PAR02) .AND. ;
		Empty(MV_PAR03) .AND. ;
		Empty(MV_PAR04) .AND. ;
		Empty(MV_PAR05) .AND. ;
		Empty(MV_PAR06) .AND. ;
		Empty(MV_PAR07) .AND. ;
		Empty(MV_PAR08) .AND. ;
		Empty(MV_PAR09) .AND. ;
		Empty(MV_PAR10)
		  
	    MsgInfo(OEMTOANSI("Todos os campos estão em branco. Preencha pelo menos um parâmetro."))
		llRet := .F.
		
	EndIf
	
Return llRet 
