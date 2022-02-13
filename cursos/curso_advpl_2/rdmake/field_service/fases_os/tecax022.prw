#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³tecax022  ³ Autor ³ Edson Rodrigues       ³ Data ³ 28/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Apontamento de Pecas faltante                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function tecax022(OS,CODTEC,IMEI,cSEQ,_lobrigpf)
Local oGetD
Local oSay
Local nOpcA    := 0
Local aArea    := GetArea()
Local aSavAcols:= {}
Local aSavAHead:= {}
Local nSavN    := 0
Local cCadastro:= OemToAnsi("Apontamento de Peças Faltante")
Local nUsado   := 0
Local nTotDesp := 0
Local nTotDCli := 0
Local nTotDFab := 0
Local nPosSer  := 0
Local nPosVlr  := 0
Local lRet     := .T.
Local nOpcx    := iif(inclui, 3, iif(altera, 4, 2))
Local nOper    := aRotina[ nOpcx, 4 ]
Local nCntFor  := 0
Local lExibe   := .t.

Private aHeaderZZ7 := {}
Private aColsZZ7   := {}
private oDlg
Private oGetDesp
Private _cItem    := '00'
Private aSavAcols := {}
Private	aSavAhead := {}
Private _lTudoOk  := .F.
Private	nSavN             
Private cSEQUENCIA := cSEQ

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina de travamento do radio - GLPI 14467³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := U_VLDTRAV(xFilial("ZZ4"), IMEI, OS, {"P","TECAX022","TECAX022"})
If !lRet
	Return(lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Aheader ZZ7                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Empty(aHeaderZZ7) )
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("ZZ7")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZZ7") )
		If ( X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !(PcFalOpe(Posicione("ZZ4",1,xFilial("ZZ4")+IMEI+OS,"ZZ4_OPEBGH"),SX3->X3_CAMPO)))
			nUsado++
			aadd(aHeaderZZ7,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
			nUsado++
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols ZZ7                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado := Len(aHeaderZZ7)
ZZ7->(dbSetOrder(2))//ZZ7_FILIAL, ZZ7_IMEI, ZZ7_NUMOS, ZZ7_SEQ

If ZZ7->(dbSeek( xFilial("ZZ7") + IMEI + OS + cSEQUENCIA))

	While ZZ7->(!Eof()) .And. xFilial("ZZ7") == ZZ7->ZZ7_FILIAL .And. alltrim(OS) == alltrim(ZZ7->ZZ7_NUMOS) .And. ;
	alltrim(ZZ7->ZZ7_IMEI) == alltrim(IMEI) .And. Alltrim(ZZ7->ZZ7_SEQ) == alltrim(cSEQUENCIA)

		aadd(aColsZZ7,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			If ( aHeaderZZ7[nCntFor][10] == "V" )
				aColsZZ7[Len(aColsZZ7)][nCntFor] := CriaVar(aHeaderZZ7[nCntFor][2])
			Else
				aColsZZ7[Len(aColsZZ7)][nCntFor] := ZZ7->(FieldGet(FieldPos(aHeaderZZ7[nCntFor][2])))
			EndIf
		Next nCntFor

		aColsZZ7[Len(aColsZZ7)][nUsado+1] := .F.
		_cItem := ZZ7->ZZ7_ITEM
		
		ZZ7->(dbSkip())		

	EndDo
	
EndIf
	
If ( lExibe )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salva o aCols   de Entrada e Desabilita o Paint da Primeira GetDados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSavAcols:= aClone(aCols)
	aSavAhead:= aClone(aHeader)
	aHeader  := aClone(aHeaderZZ7)
	aCols    := aClone(aColsZZ7)
	nSavN    := N
	N        := 1            

	
	_cpecfal := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + substr(CODSET,1,At('-',CODSET)-2) + substr(FAS1,1,At('-',FAS1)-2),"ZZ1_PECFAL")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a GetDados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From 10,0 to 28,80       
	
	@ 015,005 SAY RetTitle("ZZ7_IMEI")  + ": " + alltrim(IMEI) OF oDlg PIXEL
	@ 015,200 SAY RetTitle("ZZ7_NUMOS") + ": " + alltrim(OS) OF oDlg PIXEL
	@ 025,005 SAY RetTitle("ZZ7_CODTEC")+ ": " + CODTEC+" - "+Posicione("AA1",1,xFilial("AA1")+CODTEC,"AA1_NOMTEC") OF oDlg PIXEL
	@ 025,200 SAY RetTitle("ZZ7_SEQ")   + ": " + cSEQUENCIA OF oDlg PIXEL
	oGetDesp := MsGetDados():New(034,001,120,316,nOpcx,,"AllwaysTrue","+ZZ7_ITEM", ( nOper == 4 .Or. nOper == 3 ) )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| if(oGetDesp:TudoOk(),Grava(IMEI, OS, cSEQUENCIA),) } , {|| if(_cpecfal == "S",U_DelApont(),iif(_lobrigpf,.f.,oDlg:End()))})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna ao Estado de Entrada                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader  := aClone(aSavAHead)
	aCols    := aClone(aSavACols)
	N        := nSavN

EndIf

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Grava     ºAutor  ³Edson Rodrigues     º Data ³  28/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava temporariamente os dados apontados no ZZ7             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava(IMEI, OS, cSEQUENCIA)

//local _nPosIMEI   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZ7_IMEI"  })
Local _nPosItem   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZ7_ITEM"  })
Local _nPosQty    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZ7_QTY"   })
Local _nPosPartNR := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZ7_PARTNR"})
Local _nPosPecnew := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "ZZ7_PECNEW"})
LOCAL _lemptypart := .F.

ZZ7->(dbSetOrder(2))   // ZZ7_FILIAL + ZZ7_IMEI + ZZ7_NUMOS + ZZ7_SEQ + ZZ7_ITEM
                           

 // Grava todos os Part Numbers apontados neste momento
	For _nI := 1 To len(aCols)                                                   
	
	 IF !EMPTY(aCols[_nI,_nPosPartNR]) .OR. ( _nPosPecnew > 0 .And. !EMPTY(aCols[_nI,_nPosPecnew])) //// Incluso Edson Rodrigues - 19/07/09
	
	 
		
		If ZZ7->(dbSeek(xFilial("ZZ7") + IMEI + OS + cSequencia + aCols[_nI,_nPosItem] ))
			RecLock("ZZ7",.f.)
		else
			RecLock("ZZ7",.T.)
			ZZ7->ZZ7_FILIAL := xFilial("ZZ7")
			ZZ7->ZZ7_IMEI   := IMEI
			ZZ7->ZZ7_NUMOS  := alltrim(left(OS,6))
		    ZZ7->ZZ7_SEQ    := cSEQUENCIA
		    ZZ7->ZZ7_ITEM   := aCols[_nI,_nPosItem  ]
		    ZZ7->ZZ7_CODTEC := CODTEC
		Endif
		ZZ7->ZZ7_QTY    := aCols[_nI,_nPosQty   ]
		ZZ7->ZZ7_PARTNR := aCols[_nI,_nPosPartNR]
		ZZ7->ZZ7_PECNEW := Iif(_nPosPecnew > 0 ,aCols[_nI,_nPosPecnew],"")
		ZZ7->ZZ7_STATUS := "0"
		ZZ7->ZZ7_FASE1  := FAS1
		ZZ7->ZZ7_LOCAL  := POSICIONE("SB1",1,xFilial("SB1") + ZZ7->ZZ7_PARTNR,"B1_LOCPAD") // Luiz Ferreira - 03/02/09 (Grava Local Padrao do Produto)
        ZZ7->ZZ7_DATA   := DdataBase // Luiz Ferreira - 03/02/09 (Grava DataBase)
		MsUnlock()

		aadd(_aRecnoZZ7, ZZ7->(RECNO()))
	  ELSE
	    _lemptypart:=.T.  // Incluso Edson Rodrigues - 19/07/09 
	    apMsgInfo("Caro usuário, e obrigatorio o apontamento do parnumber faltante ou a digitacao da peca nova","Cadastrar Partnumber ou Peca Nova")
	  ENDIF
		
				
	Next
	
//EndIf
IF !_lemptypart  //// Incluso Edson Rodrigues - 19/07/09
   oDlg:End()
   _lTudoOk := .T.
   _lValidPartNO := .T.
   _lobrigpf:=.F.
Endif   

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³PcFalOpe  ºAutor ³Marcelo Munhoz - Erp Plus   ºData ³28/09/08º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³Valida apresentação do campo PeçaNew de acordo com operação  º±±
±±º         ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PcFalOpe(cOpera, cCampo)
//Local lRet := Posicione("ZZJ",1,xFilial("ZZJ")+cOpera,"ZZJ_XXXXXXX")
Local lRet := .F.
Local nOpera := 0
Local cDescop := ""
If Alltrim(cCampo) == "ZZ7_PECNEW"
	cDescop := Upper(Posicione("ZZJ", 1, xFilial("ZZJ")+cOpera, "ZZJ_DESCRI"))
	nOpera := At("SONY", cDescop)
	lRet := Iif(nOpera>0,.T.,.F.)
//	lRet := Posicione("ZZJ",1,xFilial("ZZJ")+cOpera,"ZZJ_XXXXXXX")
EndIf
Return lRet