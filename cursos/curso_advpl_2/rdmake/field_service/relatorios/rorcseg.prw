#include "protheus.ch"
#include "report.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RORCSEG	 � Autor � Vinicius Leonardo   � Data � 01/06/15  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Estrutura de Or�amento (TReport)               ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RORCSEG()        

	If FindFunction("TRepInUse") 
		IMPREL()
	EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � IMPREL	 � Autor � Vinicius Leonardo   � Data � 21/05/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Perguntas e valida��o                                       ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IMPREL()	
	Local oReport 	:= NIL
	Local cPerg 	:= "RORCSEG"
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ReportDef � Autor � Vinicius Leonardo   � Data � 21/05/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � M�todo TReport		                                       ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(clPerg)

	Local oReport	:= Nil
	Local oSection	:= Nil
	
	oReport := TReport():New("Or�amento Seguradoras","Relat�rio de Or�amento para Seguradoras",clPerg,{|oReport| PrintReport(oReport)},"Relat�rio de Or�amento para Seguradoras")   
	oReport:SetLandscape()  
  	oSection1 := TRSection():New(oReport ,"",{"QRY"}) 

Return oReport
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PrintReport Autor � Vinicius Leonardo   � Data � 09/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime relat�rio	                                       ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintReport(oReport)
 
	Local oSection1	:= oReport:Section(1)
	Local _cQuery	:= ""  
	Local cDescLi	:= ""  
	Local cChave	:= ""
	Local cOSDe		:= MV_PAR01 
	Local cOSAte	:= MV_PAR02
	Local cImeiDe	:= MV_PAR03
	Local cImeiAte	:= MV_PAR04
	Local cProdDe	:= MV_PAR05
	Local cProdAte	:= MV_PAR06	
	Local cDtDe		:= MV_PAR07
	Local cDtAte	:= MV_PAR08
	Local cCliDe	:= MV_PAR09
	Local cCliAte	:= MV_PAR10 
	Local cLojDe	:= MV_PAR11
	Local cLojAte	:= MV_PAR12 
	Local cOper		:= MV_PAR13
	Local oBreack	:= Nil
	
	Local clPath   	:= ""
	Local clFile   	:= ""
	Local clExcel 	:= ""
	Local nlHandle 	:= 0
		
	
	_cQuery := " 	 	SELECT	ZZ3_NUMOS,ZZ3_IMEI,ZZ4_CODPRO,ZZ4_NFEDT,A1_NREDUZ,ZZ4_CARCAC,ZZ1_DESFA1,Z9_DTAPONT, " + CRLF
	_cQuery += " 	 		STATUS =  " + CRLF
	_cQuery += " 	 			CASE	WHEN ZZ4_STATUS = '1' THEN 'Entrada Massiva lida'   " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '2' THEN 'Entrada Massiva efetivada'   " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '3' THEN 'NFE gerada'  " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '4' THEN 'Em atendimento'   " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '5' THEN 'OS encerrada'   " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '6' THEN 'Saida Massiva lida'  " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '7' THEN 'Saida Massiva efetivada'   " + CRLF
	_cQuery += " 	 					WHEN ZZ4_STATUS = '8' THEN 'PV gerado' " + CRLF 
	_cQuery += " 	 					WHEN ZZ4_STATUS = '9' THEN 'NFS Gerada' ELSE '' END,  " + CRLF 
	_cQuery += " 	 					CASE WHEN DA1_CODPRO IS NULL THEN 'Sem cadastro de preco' ELSE DA1_CODPRO END AS DA1_CODPRO, " + CRLF 
	_cQuery += " 	 					Z9_PRCCALC " + CRLF 	
	_cQuery += " 	 	FROM "+RetSqlName("ZZ3")+" ZZ3 (NOLOCK) " + CRLF
	_cQuery += " 	 		INNER JOIN "+RetSqlName("ZZ4")+" ZZ4 (NOLOCK) ON ZZ4_OS = ZZ3_NUMOS AND ZZ4_IMEI = ZZ3_IMEI AND ZZ4_FILIAL = ZZ3_FILIAL " + CRLF
	_cQuery += " 	 		AND ZZ4.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	 		INNER JOIN "+RetSqlName("ZZ1")+" ZZ1 (NOLOCK) ON ZZ1_LAB = ZZ3_LAB AND ZZ1_CODSET = ZZ3_CODSET AND ZZ1_FASE1 = ZZ3_FASE2 AND ZZ1.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	 		INNER JOIN "+RetSqlName("SZ9")+" SZ9 (NOLOCK) ON Z9_NUMOS = ZZ3_NUMOS AND Z9_FILIAL = ZZ3_FILIAL AND SZ9.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	 		AND Z9_IMEI = ZZ3_IMEI " + CRLF
	_cQuery += " 	 		INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_COD = ZZ4_CODCLI AND A1_LOJA = ZZ4_LOJA AND ZZ4.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	 		INNER JOIN "+RetSqlName("ZZJ")+" ZZJ (NOLOCK) ON ZZJ_OPERA = ZZ3_OPEBGH AND ZZJ.D_E_L_E_T_ <> '*'  " + CRLF
	_cQuery += " 	 		LEFT JOIN "+RetSqlName("DA1")+" DA1 (NOLOCK) ON DA1_CODTAB = ZZJ_CODTAB AND DA1_CODPRO = Z9_PARTNR AND DA1.D_E_L_E_T_ <> '*'  " + CRLF
	_cQuery += " 	 	WHERE	ZZ3.D_E_L_E_T_ <> '*' " + CRLF
	_cQuery += " 	 			AND ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' " + CRLF
	_cQuery += " 	 			AND ZZ1_CLCORC = 'S' " + CRLF 
	_cQuery += " 	 			AND ZZ3_NUMOS BETWEEN '"+cOSDe+"' AND '"+cOSAte+"'  " + CRLF
	_cQuery += " 	 			AND ZZ3_IMEI BETWEEN '"+cImeiDe+"' AND '"+cImeiAte+"'  " + CRLF
	_cQuery += " 	 			AND ZZ4_CODPRO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'  " + CRLF
	_cQuery += " 	 			AND ZZ4_NFEDT BETWEEN '"+DTOS(cDtDe)+"' AND '"+DTOS(cDtAte)+"'  " + CRLF
	_cQuery += " 	 			AND A1_COD BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' " + CRLF 
	_cQuery += " 	 			AND A1_LOJA BETWEEN '"+cLojDe+"' AND '"+cLojAte+"' " + CRLF 
	If !Empty(cOper)
		_cQuery += " 	 			AND ZZJ_OPERA = '"+cOper+"' " + CRLF 
	EndIf
	_cQuery += " 	 			ORDER BY ZZ3_NUMOS " + CRLF
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //��������������������������������������������������������������Ŀ
	//�Secao                							             �
	//���������������������������������������������������������������� 
	
	TRCell():New(oSection1,"ZZ3_NUMOS" 	,"QRY" 		,OEMTOANSI("OS")			,"@!"					,40 							)  
	TRCell():New(oSection1,"ZZ3_IMEI" 	,"QRY" 		,OEMTOANSI("Imei")			,"@!"					,40 							)
	TRCell():New(oSection1,"ZZ4_CODPRO"	,"QRY" 		,OEMTOANSI("Produto")		,"@!"					,40 							)	
	TRCell():New(oSection1,"ZZ4_NFEDT"	,"QRY"		,OEMTOANSI("Entrada")		,						,30	,,{||STOD(QRY->ZZ4_NFEDT)}	)	
	TRCell():New(oSection1,"A1_NREDUZ" 	,"QRY" 		,OEMTOANSI("Cliente")		,"@!"					,60					 			) 
	TRCell():New(oSection1,"ZZ4_CARCAC" ,"QRY" 		,OEMTOANSI("Sinistro")		,"@!"					,30 							)  
	TRCell():New(oSection1,"ZZ1_DESFA1" ,"QRY" 		,OEMTOANSI("Fase")			,"@!"					,70								)	
	TRCell():New(oSection1,"Z9_DTAPONT"	,"QRY"		,OEMTOANSI("Dt Apontamento"),						,30	,,{||STOD(QRY->Z9_DTAPONT)}	)
	TRCell():New(oSection1,"STATUS"		,"QRY" 		,OEMTOANSI("Status OS")		,"@!"					,60						 		)	
	TRCell():New(oSection1,"DA1_CODPRO"	,"QRY" 		,OEMTOANSI("Pe�a")			,"@!"					,40								)
	TRCell():New(oSection1,"Z9_PRCCALC"	,"QRY" 		,OEMTOANSI("Valor")			,X3PICTURE("Z9_PRCCALC"),						,,,"RIGHT",.F.,"RIGHT"	)
	
	oSection1:Init() 		
	oSection1:Print()					
	oSection1:Finish()	 			
		
	QRY->(DbCloseArea())

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1 � Autor � Vinicius Leonardo   � Data � 21/05/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria as perguntas	                                       ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSx1(cPerg)

	//SX1->(dbSetOrder(1))
	//If !SX1->(dbSeek(cPerg))

		PutSx1(cPerg,"01",OEMTOANSI("OS De ?"	)	,OEMTOANSI("OS De ?"	)  	,OEMTOANSI("OS De ?"	)  	,"MV_CH1"	,"C",TamSX3("ZZ3_NUMOS")[01]	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"02",OEMTOANSI("OS Ate ?"	) 	,OEMTOANSI("OS Ate ?"	)  	,OEMTOANSI("OS Ate ?"	)	,"MV_CH2"	,"C",TamSX3("ZZ3_NUMOS")[01]	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"03",OEMTOANSI("Imei De ?"	)	,OEMTOANSI("Imei De ?"	)  	,OEMTOANSI("Imei De ?"	) 	,"MV_CH3"	,"C",TamSX3("ZZ3_IMEI")[01]		,0,0,"G","",""		,"","S","MV_PAR03",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"04",OEMTOANSI("Imei Ate ?") 	,OEMTOANSI("Imei Ate ?"	)  	,OEMTOANSI("Imei Ate ?"	) 	,"MV_CH4"	,"C",TamSX3("ZZ3_IMEI")[01]		,0,0,"G","",""		,"","S","MV_PAR04",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"05",OEMTOANSI("Produto De ?")	,OEMTOANSI("Produto De ?") 	,OEMTOANSI("Produto De ?") 	,"MV_CH5"	,"C",TamSX3("ZZ4_CODPRO")[01]	,0,0,"G","","SB1"	,"","S","MV_PAR05",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"06",OEMTOANSI("Produto Ate ?"),OEMTOANSI("Produto Ate ?")	,OEMTOANSI("Produto Ate ?")	,"MV_CH6"	,"C",TamSX3("ZZ4_CODPRO")[01]	,0,0,"G","","SB1"	,"","S","MV_PAR06",""		,"","","",""		,"","","","","","","","","","","","","","","")
        PutSx1(cPerg,"07",OEMTOANSI("Data De ?")	,OEMTOANSI("Data De ?")  	,OEMTOANSI("Data De ?"	)  	,"MV_CH7"	,"D",							,0,0,"G","",""		,"","S","MV_PAR07",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"08",OEMTOANSI("Data Ate ?") 	,OEMTOANSI("Data Ate ?")  	,OEMTOANSI("Data Ate ?"	)	,"MV_CH8"	,"D",							,0,0,"G","",""		,"","S","MV_PAR08",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"09",OEMTOANSI("Cliente De ?")	,OEMTOANSI("Cliente De ?") 	,OEMTOANSI("Cliente De ?")  ,"MV_CH9"	,"C",TamSX3("A1_COD")[01]		,0,0,"G","","SA1"	,"","S","MV_PAR09",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"10",OEMTOANSI("Cliente Ate ?"),OEMTOANSI("Cliente Ate ?")	,OEMTOANSI("Cliente Ate ?")	,"MV_CHA"	,"C",TamSX3("A1_COD")[01]		,0,0,"G","","SA1"	,"","S","MV_PAR10",""		,"","","",""		,"","","","","","","","","","","","","","","")
    	PutSx1(cPerg,"11",OEMTOANSI("Loja De ?")	,OEMTOANSI("Loja De ?") 	,OEMTOANSI("Loja De ?")  	,"MV_CHB"	,"C",TamSX3("A1_LOJA")[01]		,0,0,"G","",""		,"","S","MV_PAR11",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"12",OEMTOANSI("Loja Ate ?")	,OEMTOANSI("Loja Ate ?")	,OEMTOANSI("Loja Ate ?")	,"MV_CHC"	,"C",TamSX3("A1_LOJA")[01]		,0,0,"G","",""		,"","S","MV_PAR12",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSX1(cPerg,"13",OEMTOANSI("Operacao")		,OEMTOANSI("Operacao")		,OEMTOANSI("Operacao")		,"MV_CHD"	,"C",3,0,0,"G","","ZZJ"	,"",,"mv_par13",""	,"","","",""		,"","",""	,"","","","","","","","")        

	//EndIf 
			   	
Return Nil                                                                 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � KZVALIDPAR� Autor � Vinicius Leonardo   � Data � 21/05/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida��o das perguntas                                     ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function KZVALIDPAR()

	Local llRet := .T.

	If 	Empty(MV_PAR01) .AND. ;
		Empty(MV_PAR02)	.AND. ;
		Empty(MV_PAR03)	.AND. ;
		Empty(MV_PAR04) .AND. ;
		Empty(MV_PAR05) .AND. ;
		Empty(MV_PAR06) .AND. ;
		Empty(MV_PAR07)	.AND. ;
		Empty(MV_PAR08)	.AND. ;
		Empty(MV_PAR09) .AND. ;
		Empty(MV_PAR10) .AND. ; 
		Empty(MV_PAR11) .AND. ;
		Empty(MV_PAR12) 
				  
	    MsgInfo(OEMTOANSI("Todos os campos est�o em branco. Preencha pelo menos um par�metro."))
		llRet := .F.
				
	EndIf
	
Return llRet 
