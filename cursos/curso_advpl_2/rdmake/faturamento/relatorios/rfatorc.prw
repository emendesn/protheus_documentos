#include "protheus.ch"
#include "report.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATORC	 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 21/07/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Entrada X Faturamento de Orçamento (TReport)   ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATORC()        

	If FindFunction("TRepInUse") 
		IMPREL()
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPREL	 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 21/05/14  ³±±
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
	Local cPerg 	:= "RFATORC"
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
±±³Fun‡…o    ³ ReportDef ³ Autor ³ Vinicius Leonardo   ³ Data ³ 21/05/14  ³±±
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
	
	oReport := TReport():New("Entrada X Faturamento de Orçamento","Relatorio de Entrada X Faturamento de Orçamento",clPerg,{|oReport| PrintReport(oReport)},"Relatório de Entrada X Faturamento de Orçamento")   
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
	Local _cQuery	:= ""  
	Local cDescLi	:= ""  
	Local cChave	:= ""
	Local cDtDe		:= DTOS(MV_PAR01)
	Local cDtAte	:= DTOS(MV_PAR02)
	Local cOpeBgh	:= MV_PAR03
	Local oBreack	:= Nil
	
	Local clPath   	:= ""
	Local clFile   	:= ""
	Local clExcel 	:= ""
	Local nlHandle 	:= 0	
	Local cCliNFE10 := Getmv("BH_CLINFE10",.F.,"Z0040301")
	
	_cQuery := " SELECT ZZQ_NUMOS, ZZQ_IMEI, ZZQ_MODELO, ZZ4_CARCAC, ZZQ_CLISAI, ZZQ_LOJSAI, ZZQ_NFS, " + CRLF
	_cQuery += " 	ZZQ_NFSSER,D2_EMISSAO, LTRIM(RTRIM(ZZJ_DESCRI)) AS OPER,0 AS VLR_SERVICOS, D2_PRCVEN,D2_TOTAL,ZZQ_NFENTR,D1_EMISSAO,D1_VUNIT,D1_TOTAL,ZZQ_PECA " + CRLF
	_cQuery += " FROM " + RetSqlName("ZZQ") + " ZZQ (NOLOCK) " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK)  " + CRLF
	_cQuery += " 	ON ZZQ_NFS = D2_DOC AND ZZQ_NFSSER = D2_SERIE AND ZZQ_CLISAI = D2_CLIENTE " + CRLF
	_cQuery += " 	AND ZZQ_LOJSAI = D2_LOJA AND ZZQ_PECA = D2_COD AND ZZQ.D_E_L_E_T_ = SD2.D_E_L_E_T_  " + CRLF
	_cQuery += " 	AND ZZQ_FILIAL = D2_FILIAL " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("ZZJ") + " ZZJ (NOLOCK) " + CRLF
	_cQuery += " 	ON ZZJ_OPERA = ZZQ_OPEBGH AND ZZJ.D_E_L_E_T_ = ZZQ.D_E_L_E_T_ " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 (NOLOCK) " + CRLF
	_cQuery += " 	ON ZZQ_NFENTR = D1_DOC AND ZZQ_SERENT = D1_SERIE AND D1_COD = D2_COD " + CRLF
	_cQuery += " 	AND ZZQ.D_E_L_E_T_ = SD1.D_E_L_E_T_ AND ZZQ_FILIAL = D1_FILIAL " + CRLF 	
	_cQuery += " INNER JOIN " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + CRLF 
 	_cQuery += " 	ON ZZQ_IMEI = ZZ4_IMEI AND ZZQ_NUMOS = ZZ4_OS " + CRLF  
 	_cQuery += " 	AND ZZQ.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ AND ZZQ_FILIAL = ZZ4_FILIAL " + CRLF 	
	_cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6 (NOLOCK) " + CRLF
	_cQuery += " 	ON ZZQ_PVRESA = C6_NUM AND ZZQ.D_E_L_E_T_ = SC6.D_E_L_E_T_ AND ZZQ_FILIAL = C6_FILIAL AND C6_NOTA = '' " + CRLF
	_cQuery += " WHERE ZZQ.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	AND ZZQ_FILIAL = '" + xFilial("ZZQ") + "'  " + CRLF
	_cQuery += " 	AND D2_EMISSAO BETWEEN '" + cDtDe + "' AND '" + cDtAte + "' " + CRLF
	_cQuery += " 	AND ZZQ_OPEBGH = '"+cOpeBgh+"' " + CRLF
	_cQuery += " 	AND D1_FORNECE = '" + substr(cCliNFE10,1,6) + "' " + CRLF 
	_cQuery += " 	AND D1_LOJA = '" + substr(cCliNFE10,7,2) + "' " + CRLF  	
	
	_cQuery += " 	UNION ALL  " + CRLF
 
	_cQuery += "  SELECT DISTINCT ZZ4_OS AS ZZQ_NUMOS , ZZ4_IMEI AS ZZQ_IMEI, ZZ4_CODPRO AS ZZQ_MODELO,ZZ4_CARCAC, ZZ4_CODCLI AS ZZQ_CLISAI,  " + CRLF
	_cQuery += " 	ZZ4_LOJA AS ZZQ_LOJSAI, ZZ4_NFSNR AS ZZQ_NFS,ZZ4_NFSSER AS ZZQ_NFSSER,D2_EMISSAO, LTRIM(RTRIM(ZZJ_DESCRI)) AS OPER,  " + CRLF
	_cQuery += " 	0 AS VLR_SERVICOS, 0 AS D2_PRCVEN,0 AS D2_TOTAL,'' AS ZZQ_NFENTR,'' AS D1_EMISSAO,  " + CRLF
	_cQuery += "  	0 AS D1_VUNIT,0 AS D1_TOTAL,'' AS ZZQ_PECA   " + CRLF
	_cQuery += "  FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK)   " + CRLF
	_cQuery += "  INNER JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK)    " + CRLF
	_cQuery += "  	ON ZZ4_NFSNR = D2_DOC AND ZZ4_NFSSER = D2_SERIE AND ZZ4_CODCLI = D2_CLIENTE   " + CRLF
	_cQuery += "  	AND ZZ4_LOJA = D2_LOJA AND ZZ4_CODPRO = D2_COD AND ZZ4.D_E_L_E_T_ = SD2.D_E_L_E_T_    " + CRLF
	_cQuery += "  	AND ZZ4_FILIAL = D2_FILIAL   " + CRLF
	_cQuery += "  INNER JOIN " + RetSqlName("ZZJ") + " ZZJ (NOLOCK)   " + CRLF
	_cQuery += "  	ON ZZJ_OPERA = ZZ4_OPEBGH AND ZZJ.D_E_L_E_T_ = ZZ4.D_E_L_E_T_  " + CRLF
	_cQuery += "  WHERE ZZ4_IMEI NOT IN   " + CRLF
	_cQuery += " 	(SELECT Z9_IMEI FROM " + RetSqlName("SZ9") + " (NOLOCK) WHERE D_E_L_E_T_ <> '*' AND Z9_FILIAL = '" + xFilial("SZ9") + "' AND Z9_PARTNR <> '' )    " + CRLF
	_cQuery += " 	AND ZZ4.D_E_L_E_T_ <> '*'   " + CRLF
	_cQuery += "  	AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "'    " + CRLF
	_cQuery += "  	AND D2_EMISSAO BETWEEN '" + cDtDe + "' AND '" + cDtAte + "' " + CRLF
	_cQuery += "  	AND ZZ4_OPEBGH = '"+cOpeBgh+"' " + CRLF	
	_cQuery += " ORDER BY D1_EMISSAO  " + CRLF	

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Secao                							             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
	TRCell():New(oSection1,"ZZQ_NUMOS" 		,"QRY" 		,OEMTOANSI("OS")				,"@!"					,40 							)  
	TRCell():New(oSection1,"ZZQ_IMEI" 		,"QRY" 		,OEMTOANSI("Imei")				,"@!"					,40 							)
	TRCell():New(oSection1,"ZZQ_MODELO"		,"QRY" 		,OEMTOANSI("Produto")			,"@!"					,40 							)	
	TRCell():New(oSection1,"ZZ4_CARCAC"		,"QRY" 		,OEMTOANSI("Senha")				,"@!"					,40 							)		
	TRCell():New(oSection1,"ZZQ_CLISAI"		,"QRY" 		,OEMTOANSI("Cliente")			,"@!"					,40 							)	
	TRCell():New(oSection1,"ZZQ_NFS"		,"QRY" 		,OEMTOANSI("Nota de Peças")		,"@!"					,40 							)	
	TRCell():New(oSection1,"D2_EMISSAO"		,"QRY"		,OEMTOANSI("Emissão")			,						,30	,,{||STOD(QRY->D2_EMISSAO)}	)		
	TRCell():New(oSection1,"OPER" 			,"QRY" 		,OEMTOANSI("Operação")			,"@!"					,60					 			) 	
	TRCell():New(oSection1,"VLR_SERVICOS"	,"QRY" 		,OEMTOANSI("Vlr.Serviços")		,X3PICTURE("D2_PRCVEN"),		,,,"RIGHT",.F.,"RIGHT"	) 	
	TRCell():New(oSection1,"D2_PRCVEN"		,"QRY" 		,OEMTOANSI("Vlr.Peças")			,X3PICTURE("D2_PRCVEN"),		,,,"RIGHT",.F.,"RIGHT"	)	
	TRCell():New(oSection1,"D2_TOTAL"		,"QRY" 		,OEMTOANSI("Total")				,X3PICTURE("D2_TOTAL"),			,,,"RIGHT",.F.,"RIGHT"	)	
	TRCell():New(oSection1,"ZZQ_NFENTR"		,"QRY" 		,OEMTOANSI("Nota de Reentrada")	,"@!"					,40 							)	
	TRCell():New(oSection1,"D1_EMISSAO"		,"QRY"		,OEMTOANSI("Emissão")			,						,30	,,{||STOD(QRY->D1_EMISSAO)}	)		
	TRCell():New(oSection1,"D1_VUNIT"		,"QRY" 		,OEMTOANSI("Valor")				,X3PICTURE("D1_VUNIT")	,		,,,"RIGHT",.F.,"RIGHT"	)	
	TRCell():New(oSection1,"ZZQ_PECA"		,"QRY" 		,OEMTOANSI("Peças")				,"@!"					,40 							)	
	 	
	oSection1:Init() 		
	oSection1:Print()					
	oSection1:Finish()	 			
		
	QRY->(DbCloseArea())

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 21/05/14  ³±±
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

	PutSx1(cPerg,"01",OEMTOANSI("Data De ?")	,OEMTOANSI("Data De ?")  	,OEMTOANSI("Data De ?"	)  	,"MV_CH1"	,"D",							,00,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02",OEMTOANSI("Data Ate ?") 	,OEMTOANSI("Data Ate ?")  	,OEMTOANSI("Data Ate ?"	)	,"MV_CH2"	,"D",							,00,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03",OEMTOANSI("Operacao ?")	,OEMTOANSI("Operacao ?") 	,OEMTOANSI("Operacao ?") 	,"MV_CH3"	,"C",03							,00,0,"G","","ZZJ"	,"","" ,"MV_PAR03",""		,"","","",""		,"","","","","","","","","","","","","","","")
			   	
Return Nil                                                                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ KZVALIDPAR³ Autor ³ Vinicius Leonardo   ³ Data ³ 21/05/14  ³±±
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
