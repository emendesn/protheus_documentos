#include "protheus.ch"
#include "report.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RINVDI	 � Autor � Vinicius Leonardo   � Data � 21/05/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Invoices x DI's (TReport)	                   ��
���          �                                  						   ��                                                                                                                     ��
�������������������������������������������������������������������������Ĵ��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RINVDI()        

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
	Local cPerg 	:= "RINVDI"
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
	
	oReport := TReport():New("Invoices x DI's","Relat�rio de Invoices x DI's",clPerg,{|oReport| PrintReport(oReport)},"Relat�rio de Invoices x DI's")   
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
	Local cQuery	:= ""  
	Local cDescLi	:= ""  
	Local cChave	:= ""
	Local cDiDe		:= MV_PAR01 
	Local cDiAte	:= MV_PAR02
	Local cInvDe	:= MV_PAR03
	Local cInvAte	:= MV_PAR04
	Local cProcDe	:= MV_PAR05
	Local cProcAte	:= MV_PAR06
	Local oBreack	:= Nil
	
	Local clPath   	:= ""
	Local clFile   	:= ""
	Local clExcel 	:= ""
	Local nlHandle 	:= 0

	If !KZVALIDPAR()
		Return
	EndIf 			
	
	_cQuery := " 		SELECT  " + CRLF
	_cQuery += " 	 	       W9_HAWB, " + CRLF
	_cQuery += " 	 	       W6_DI_NUM, " + CRLF
	_cQuery += " 	 	       W9_INVOICE, " + CRLF
	_cQuery += " 	 	       W9_FORN, " + CRLF
	_cQuery += " 	 	       W9_NOM_FOR, " + CRLF
	_cQuery += " 	 	       W9_NUM, " + CRLF
	_cQuery += " 	 	       E2_PARCELA, " + CRLF
	_cQuery += " 	 	       E2_VALOR " + CRLF
	_cQuery += " 	 	FROM " + RetSqlName("SW9") + " SW9 (NOLOCK) " + CRLF
	_cQuery += " 	 	INNER JOIN " + RetSqlName("SW6") + " SW6 (NOLOCK) ON  " + CRLF
	_cQuery += " 	 	       W6_FILIAL='" + xFilial("SW6") + "' AND  " + CRLF
	_cQuery += " 	 	       W6_HAWB=W9_HAWB AND  " + CRLF
	_cQuery += "			   W6_DI_NUM BETWEEN '" + cDiDe + "' AND '" + cDiAte + "' AND " + CRLF
	_cQuery += " 	 	       SW6.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 	 	INNER JOIN " + RetSqlName("SE2") + " SE2 (NOLOCK) ON  " + CRLF
	_cQuery += " 	 	       E2_FILIAL='" + xFilial("SE2") + "' AND  " + CRLF
	_cQuery += " 	 	       E2_TIPO='INV' AND  " + CRLF
	_cQuery += " 	 	       E2_PREFIXO='EIC' AND  " + CRLF
	_cQuery += " 	 	       E2_FORNECE=W9_FORN AND  " + CRLF
	_cQuery += " 	 	       E2_NUM=W9_NUM AND  " + CRLF
	_cQuery += " 	 	       SE2.D_E_L_E_T_='' " + CRLF
	_cQuery += " 	 	WHERE " + CRLF
	_cQuery += " 	 	W9_FILIAL='" + xFilial("SW9") + "' AND  " + CRLF	
	_cQuery += " 	 	W9_INVOICE BETWEEN '" + cInvDe + "' AND '" + cInvAte + "' AND " + CRLF 	
	_cQuery += " 	 	W9_HAWB BETWEEN '" + cProcDe + "' AND '" + cProcAte + "' AND " + CRLF
	_cQuery += " 	 	SW9.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 	 	ORDER BY W9_HAWB,W9_INVOICE,W9_NUM " + CRLF
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
				
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), 'QRY', .T., .T. ) 

    //��������������������������������������������������������������Ŀ
	//�Secao                							             �
	//����������������������������������������������������������������     
	
	TRCell():New(oSection1,"W9_HAWB" 	,"QRY" 		,OEMTOANSI("Processo")			,"@!"					,TamSX3("W9_HAWB")[01] 							)  
	TRCell():New(oSection1,"W6_DI_NUM" 	,"QRY" 		,OEMTOANSI("Num.DI")			,"@!"					,TamSX3("W6_DI_NUM")[01] 						)
	TRCell():New(oSection1,"W9_INVOICE"	,"QRY" 		,OEMTOANSI("Invoice")			,"@!"					,TamSX3("W9_INVOICE")[01] 						) 
	TRCell():New(oSection1,"W9_FORN" 	,"QRY" 		,OEMTOANSI("Fornecedor")		,"@!"					,10					 							) 
	TRCell():New(oSection1,"W9_NOM_FOR" ,"QRY" 		,OEMTOANSI("Nome Fornec.")		,"@!"					,TamSX3("W9_NOM_FOR")[01] 						)  
	TRCell():New(oSection1,"W9_NUM" 	,"QRY" 		,OEMTOANSI("Nro. T�tulo")		,"@!"					,15					 							)
	TRCell():New(oSection1,"E2_PARCELA"	,"QRY" 		,OEMTOANSI("Parcela")			,"@!"					,10						 						)
	TRCell():New(oSection1,"E2_VALOR"	,"QRY" 		,OEMTOANSI("Valor")				,X3PICTURE("E2_VALOR")	,						,,,"RIGHT",.F.,"RIGHT"	)
	
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

	SX1->(dbSetOrder(1))
	If !SX1->(dbSeek(cPerg))

		PutSx1(cPerg,"01",OEMTOANSI("Invoice De ?"	)	,OEMTOANSI("Invoice De ?"	)  	,OEMTOANSI("Invoice De ?"	)  			,"MV_CH1"	,"C",TamSX3("W9_INVOICE")[01]	,0,0,"G","",""		,"","S","MV_PAR01",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"02",OEMTOANSI("Invoice Ate ?"	) 	,OEMTOANSI("Invoice Ate ?"	)  	,OEMTOANSI("Invoice Ate ?"	)			,"MV_CH2"	,"C",TamSX3("W9_INVOICE")[01]	,0,0,"G","",""		,"","S","MV_PAR02",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"03",OEMTOANSI("DI De ?"	)		,OEMTOANSI("DI De ?"	)  		,OEMTOANSI("DI De ?"	)   			,"MV_CH3"	,"C",TamSX3("W6_DI_NUM")[01]	,0,0,"G","",""		,"","S","MV_PAR03",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"04",OEMTOANSI("DI Ate ?"	) 		,OEMTOANSI("DI Ate ?"	)  		,OEMTOANSI("DI Ate ?"	) 				,"MV_CH4"	,"C",TamSX3("W6_DI_NUM")[01]	,0,0,"G","",""		,"","S","MV_PAR04",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"05",OEMTOANSI("Processo De ?"	)	,OEMTOANSI("Processo De ?"	)  	,OEMTOANSI("Processo De ?"	)  			,"MV_CH5"	,"C",TamSX3("W9_HAWB")[01]		,0,0,"G","",""		,"","S","MV_PAR05",""		,"","","",""		,"","","","","","","","","","","","","","","")
		PutSx1(cPerg,"06",OEMTOANSI("Processo Ate ?") 	,OEMTOANSI("Processo Ate ?"	)  	,OEMTOANSI("Processo Ate ?"	)			,"MV_CH6"	,"C",TamSX3("W9_HAWB")[01]		,0,0,"G","",""		,"","S","MV_PAR06",""		,"","","",""		,"","","","","","","","","","","","","","","")

	EndIf 
			   	
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
		Empty(MV_PAR06) 
				  
	    MsgInfo(OEMTOANSI("Todos os campos est�o em branco. Preencha pelo menos um par�metro."))
		llRet := .F.
				
	EndIf
	
Return llRet 
