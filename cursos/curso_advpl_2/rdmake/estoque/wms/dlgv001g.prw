
#INCLUDE "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'APVT100.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DLGV001G    ºAutor  ³  Luciano Siqueira  Data ³  24/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na gravação                                ±±
±±º          ³                                                             ±±
±±º          ³                                                             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DLGV001G()

Local aArea     := GetArea()
Local aItens 	:= {}
Private lMsErroAuto	:= 	.F.
Private lMsHelpAuto	:= 	.F.
Private aMata261 	:= 	{} 
Private cTrAutom	:= Getmv("BH_TRAUTO",.F.,"03")

u_GerA0003(ProcName())

If SDB->DB_STATUS == "1" .AND. SDB->DB_LOCAL $ cTrAutom
	
	_cQuery := " SELECT "
	_cQuery += " 	SZ9.R_E_C_N_O_ AS RECSZ9, "
	_cQuery += " 	ZZJ.ZZJ_ARMSEP AS ARMSEP, "
	_cQuery += " 	ZZJ.ZZJ_ENDBUF AS ENDBUF, "
	_cQuery += " 	ZZJ.ZZJ_ALMEP  AS ALMEP, "
	_cQuery += " 	ZZJ.ZZJ_ENDPRO AS ENDPRO "	
	_cQuery += " FROM " + RetSQlName("SZ9") + " SZ9 WITH(NOLOCK) "
	_cQuery += " INNER JOIN " + RetSQlName("ZZ4") + " ZZ4 WITH(NOLOCK) ON "
	_cQuery += " 	(ZZ4_FILIAL='" + xFilial('ZZ4') + "' AND ZZ4_IMEI=Z9_IMEI "
	_cQuery += " 	AND ZZ4_OS=Z9_NUMOS AND ZZ4.D_E_L_E_T_ = '') "
	_cQuery += " INNER JOIN " + RetSQlName("ZZJ") + " ZZJ WITH(NOLOCK) ON "
	_cQuery += " 	(ZZJ_FILIAL='" + xFilial('ZZJ') + "' AND ZZJ_OPERA=ZZ4_OPEBGH "
	_cQuery += " 	AND ZZJ.D_E_L_E_T_ = '') "
	_cQuery += " WHERE "
	_cQuery += " 	SZ9.D_E_L_E_T_ = '' "
	_cQuery += " 	AND Z9_FILIAL = '" + xFilial('SZ9') + "' "
	_cQuery += " 	AND Z9_PARTNR = '" + SDB->DB_PRODUTO + "' "
	_cQuery += " 	AND Z9_NUMSEQE = '" + SDB->DB_DOC + "' "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQuery), "QRYSZ9", .F., .T.)
	
	dbSelectArea("QRYSZ9")
	dbGoTop()
	
	If QRYSZ9->(!EOF())
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + Left(SDB->DB_PRODUTO,15)))
		
		aAdd(aItens,{Left(SDB->DB_PRODUTO,15),;	 	// Produto Origem
		Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
		AllTrim(SB1->B1_UM),;                     	// Unidade Medida
		QRYSZ9->ARMSEP,;                       		// Local Origem
		AllTrim(QRYSZ9->ENDBUF),;              		// Ender Origem
		Left(SDB->DB_PRODUTO,15),;		           	// Produto Destino
		Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
		AllTrim(SB1->B1_UM),;                     	// Unidade Medida
		QRYSZ9->ALMEP,;           					// Local Destino
		AllTrim(QRYSZ9->ENDPRO),;  					// Ender Destino
		Space(20),;                               	// Num Serie
		Space(10),;                               	// Lote
		Space(06),;                              	// Sub Lote
		CtoD("//"),;                              	// Validade
		0,;                                        	// Potencia
		SDB->DB_QUANT,;	                   			// Quantidade
		0,;                                       	// Qt 2aUM
		"N",;                                     	// Estornado
		Space(06),;                               	// Sequencia
		Space(10),;                               	// Lote Desti
		CtoD("//"),;                              	// Validade Lote
		Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
		Space(03)})									// Item Grade
		
		If Len(aItens) >0
			
			dbSelectArea("SD3")
			nSavReg     := RecNo()
			cDoc		:= space(6)
			cDoc    	:= IIf(Empty(cDoc),NextNumero("SD3",2,"D3_DOC",.T.),cDoc)
			cDoc    	:= A261RetINV(cDoc)
			dbSetOrder(2)
			dbSeek(xFilial()+cDoc)
			cMay := "SD3"+Alltrim(xFilial())+cDoc
			While D3_FILIAL+D3_DOC==xFilial()+cDoc .Or.!MayIUseCode(cMay)
				If D3_ESTORNO # "S"
					cDoc := Soma1(cDoc)
					cMay := "SD3"+Alltrim(xFilial())+cDoc
				EndIf
				dbSkip()
			EndDo
						
			lRet := u_BaixPeca(cDoc,aItens,3)
			
			If lRet
				dbSelectArea("SZ9")
				dbGoto(QRYSZ9->RECSZ9)
				RecLock("SZ9",.F.)
				SZ9->Z9_NUMSEQP := 	cDoc
				SZ9->Z9_DTAPONT := dDataBase
				MsUnLock()
			EndIf
			
		Endif
	Endif
	QRYSZ9->( DbCloseArea())
Endif

RestArea(aArea)

Return