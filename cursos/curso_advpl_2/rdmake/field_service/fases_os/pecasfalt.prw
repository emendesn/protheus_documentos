#INCLUDE "PROTHEUS.CH"
#define DS_MODALFRAME   128

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : PECASFALT			| 	Abril de 2012														  			|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : Tela de Peças Faltantes para a Rastreabilidade												  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/

User Function PECASFALT(OS,CODTEC,IMEI,cSEQ,_lobripart)
Local oGetD
Local oSay
Local nOpcA    := 0
Local aArea    := GetArea()
Local aSavAcols:= {}
Local aSavAHead:= {}
Local nSavN    := 0
Local cCadastro:= OemToAnsi("Peças Faltantes")
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

Private aHeaderZZ7 	:= {}
Private aColsZZ7   	:= {}
Private _cimeipn   	:=IMEI
Private _cospn     	:=OS
Private _ccodtec   	:=CODTEC
Private oDlg
Private oGetDesp
Private aSavAcols 	:= {}
Private	aSavAhead 	:= {}
Private _lTudoOk  	:= .F.
Private	nSavN

Private cSEQUENCIA := cSEQ

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Aheader ZZ7                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Empty(aHeaderZZ7) )
	dbSelectArea("ZZ7")
	dbSetOrder(1)
	if SX3->(dbSeek("ZZ7"))
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
	endif
	// Inclusao dos campos usados no aHeader
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("ZZ7")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZZ7") )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			if trim(SX3->X3_CAMPO) == 'ZZ7_FASE1'
				_nRec := SX3->(RECNO())
									
				dbSetOrder(2)
				if MsSeek("ZZ3_FASE2")
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
				endif					
				
				dbSetOrder(1)
			 	Go _nRec
			else
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
			endif
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols ZZ7                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado := Len(aHeaderZZ7)

dbSelectarea("ZZ7")
dbSetOrder(2) //ZZ7_FILIAL+ZZ7_IMEI+ZZ7_NUMOS+ZZ7_SEQ+ZZ7_ITEM   
If ZZ7->(dbSeek(xFilial("ZZ7")+IMEI+_cospn))
	While ZZ7->(!Eof())  .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .and. alltrim(_cospn) == alltrim(ZZ7->ZZ7_NUMOS) .And. alltrim(ZZ7->ZZ7_IMEI) == alltrim(IMEI)
		if ZZ7->ZZ7_STATUS <> '0'
			aadd(aColsZZ7,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				if nCntFor == 11
					dbSelectArea("ZZ3")     
					dbSetOrder(1)
					if (ZZ3->(dbseek(xFilial("ZZ3") + ZZ7->ZZ7_IMEI + ZZ7->ZZ7_NUMOS + ZZ7->ZZ7_SEQ)))					
							aColsZZ7[Len(aColsZZ7)][nCntFor] := FieldGet(FieldPos(aHeaderZZ7[nCntFor][2]))
					else
							aColsZZ7[Len(aColsZZ7)][nCntFor] := ""
					endif
					dbSelectArea("ZZ7")					
				else
					If ( aHeaderZZ7[nCntFor][10] == "V" )
						aColsZZ7[Len(aColsZZ7)][nCntFor] := CriaVar(aHeaderZZ7[nCntFor][2])
					Else
						aColsZZ7[Len(aColsZZ7)][nCntFor] := ZZ7->(FieldGet(FieldPos(aHeaderZZ7[nCntFor][2])))
					EndIf
				endif
			Next nCntFor
			
			aColsZZ7[Len(aColsZZ7)][nUsado+1] := .F.
		endif			
		ZZ7->(dbSkip())
		
	EndDo
	
EndIf

If (len(aColsZZ7) > 0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salva o aCols   de Entrada e Desabilita o Paint da Primeira GetDados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSavAcols:= aClone(aCols)
	aSavAhead:= aClone(aHeader)
	aHeader  := aClone(aHeaderZZ7)
	aCols    := aClone(aColsZZ7)
	nSavN    := N
	N        := 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a GetDados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MsDialog oDlg From 060,018 To 0310,0650 Title cCadastro Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
	
	@ 015,005 SAY RetTitle("ZZ7_IMEI")  + ": " + alltrim(IMEI) OF oDlg PIXEL
	@ 015,200 SAY RetTitle("ZZ7_NUMOS") + ": " + alltrim(_cospn) OF oDlg PIXEL
	@ 025,005 SAY RetTitle("ZZ7_CODTEC")+ ": " + _ccodtec+" - "+Posicione("AA1",1,xFilial("AA1")+CODTEC,"AA1_NOMTEC") OF oDlg PIXEL            
	
	oGetDesp := MsGetDados():New(034,001,120,316,nOpcx,,"AllwaysTrue","+ZZ7_ITEM", ( nOper == 4 .Or. nOper == 3 ) )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||oDlg:End()},{||oDlg:End()})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna ao Estado de Entrada                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader  := aClone(aSavAHead)
	aCols    := aClone(aSavACols)
	N        := nSavN
	
else
	msgAlert("Não existem Peças Faltantes para esse IMEI + OS")
EndIf

RestArea(aArea)

Return(lRet)


