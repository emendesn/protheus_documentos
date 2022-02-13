#include "protheus.ch"
#include "report.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCSTSBF	 ³ Autor ³ Vinicius Leonardo   ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório Valor Unitário SBF (TReport)	                   ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCSTSBF()        

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
	Local cPerg 	:= "RCSTSBF"
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
	
	oReport := TReport():New("Valor Unitário SBF","Relatório Valor Unitário SBF",clPerg,{|oReport| PrintReport(oReport)},"Relatório Valor Unitário SBF")   
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
	Local cEndDe	:= MV_PAR01
	Local cEndAte	:= MV_PAR02
	Local cArmDe	:= MV_PAR03
	Local cArmAte	:= MV_PAR04
	Local oBreack	:= Nil
	
	Local clPath   	:= ""
	Local clFile   	:= ""
	Local clExcel 	:= ""
	Local nlHandle 	:= 0

	If !KZVALIDPAR()
		Return
	EndIf	
	
	_cQuery := " 	SELECT BF_FILIAL,BF_PRODUTO,BF_LOCAL,BF_PRIOR,BF_LOCALIZ,BF_NUMSERI,BF_LOTECTL,  " + CRLF
	_cQuery += " 	 	BF_NUMLOTE,BF_QUANT,BF_EMPENHO,BF_QTSEGUM,BF_EMPEN2,BF_ESTFIS,B2_CM1  " + CRLF
	_cQuery += " 	 	FROM " + RetSqlName("SBF") + " BF (NOLOCK)  " + CRLF 
	_cQuery += " 	 	LEFT JOIN " + RetSqlName("SB2") + " B2 (NOLOCK) ON B2_LOCAL = BF_LOCAL AND B2_FILIAL = BF_FILIAL AND B2_COD = BF_PRODUTO AND B2.D_E_L_E_T_ <> '*'  " + CRLF 
	_cQuery += " 	 	WHERE BF.D_E_L_E_T_ <> '*'  " + CRLF	
	_cQuery += "        AND BF_LOCALIZ BETWEEN '" + cEndDe + "' AND '" + cEndAte + "' " + CRLF
	_cQuery += "        AND B2_LOCAL BETWEEN '" + cArmDe + "' AND '" + cArmAte + "' " + CRLF	 
	_cQuery += " 	 	AND BF_FILIAL = '" + xFilial("SBF") + "'  " + CRLF 
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Secao                							             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
	
	TRCell():New(oSection1,"BF_FILIAL" 	,"QRY" 		,OEMTOANSI("Filial")		,"@!"					,10)  
	TRCell():New(oSection1,"BF_PRODUTO" ,"QRY" 		,OEMTOANSI("Produto")		,"@!"					,15)
	TRCell():New(oSection1,"BF_LOCAL"	,"QRY" 		,OEMTOANSI("Armazem")		,"@!"					,05) 	
	TRCell():New(oSection1,"BF_PRIOR"	,"QRY" 		,OEMTOANSI("Prioridade")	,"@!"					,15)
	TRCell():New(oSection1,"BF_LOCALIZ"	,"QRY" 		,OEMTOANSI("Endereço")		,"@!"					,15)
	TRCell():New(oSection1,"BF_NUMSERI" ,"QRY" 		,OEMTOANSI("Num de Serie")	,"@!"					,20)
	TRCell():New(oSection1,"BF_LOTECTL" ,"QRY" 		,OEMTOANSI("Lote")			,"@!"					,20)
	TRCell():New(oSection1,"BF_NUMLOTE" ,"QRY" 		,OEMTOANSI("Sub-Lote")		,"@!"					,20)
	TRCell():New(oSection1,"BF_QUANT"	,"QRY" 		,OEMTOANSI("Quantidade")	,X3PICTURE("BF_QUANT")	,	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"BF_EMPENHO" ,"QRY" 		,OEMTOANSI("Empenho")		,X3PICTURE("BF_EMPENHO"),	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"BF_QTSEGUM" ,"QRY" 		,OEMTOANSI("Qtd 2a UM")		,X3PICTURE("BF_QTSEGUM"),	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"BF_EMPEN2"	,"QRY" 		,OEMTOANSI("Empenho 2UM")	,X3PICTURE("BF_EMPEN2")	,	,,,"RIGHT",.F.,"RIGHT")	
	TRCell():New(oSection1,"BF_ESTFIS" 	,"QRY" 		,OEMTOANSI("Estrutura")		,"@!"					,20)	
	TRCell():New(oSection1,"B2_CM1"		,"QRY" 		,OEMTOANSI("Valor Unitário"),X3PICTURE("B2_CM1")	,	,,,"RIGHT",.F.,"RIGHT")	
	
	oSection1:Init() 
	oSection1:Print()
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

		PutSx1(cPerg,"01",OEMTOANSI("Endereço De ?"	)		,OEMTOANSI("Endereço De ?"   	)  	,OEMTOANSI("Endereço De ?"	)   			,"MV_CH1"	,"C",Tamsx3('BE_LOCALIZ')[1]	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"02",OEMTOANSI("Endereço Até ?"	) 	,OEMTOANSI("Endereço Até ?"  	)  	,OEMTOANSI("Endereço Até ?"	) 				,"MV_CH2"	,"C",Tamsx3('BE_LOCALIZ')[1]	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
		
		PutSx1(cPerg,"03",OEMTOANSI("Armazem De ?"	)		,OEMTOANSI("Armazem De ?"   	)  	,OEMTOANSI("Armazem De ?"	)   			,"MV_CH3"	,"C",Tamsx3('BF_LOCAL')[1]		,0,0,"G","",""		,"","S","MV_PAR03",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"04",OEMTOANSI("Armazem Até ?"	) 		,OEMTOANSI("Armazem Até ?"  	)  	,OEMTOANSI("Armazem Até ?"	) 				,"MV_CH4"	,"C",Tamsx3('BF_LOCAL')[1]		,0,0,"G","",""		,"","S","MV_PAR04",""		,"","","",""		,"","","","","","","","","","","","","","","")
		
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
		Empty(MV_PAR04) 
				  
	    MsgInfo(OEMTOANSI("Todos os campos estão em branco. Preencha pelo menos um parâmetro."))
		llRet := .F.
				
	EndIf
	
Return llRet 
