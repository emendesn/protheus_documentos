#INCLUDE "PROTHEUS.CH"
#define DS_MODALFRAME   128
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³tecax017  ³ Autor ³ M.Munhoz - ERP PLUS   ³ Data ³ 16/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Apontamento de sintomas e materiais no atendimento da OS    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function tecax017(OS, CODTEC, IMEI, cSEQ, _lobripart, FAS1Ori)
Local oGetD
Local oSay
Local nOpcA    		:= 0
Local aArea    		:= GetArea()
Local aSavAcols		:= {}
Local aSavAHead		:= {}
Local nSavN    		:= 0
Local cCadastro		:= OemToAnsi("Análise do Atendimento da OS")
Local nUsado   		:= 0
Local nTotDesp 		:= 0
Local nTotDCli		:= 0
Local nTotDFab 		:= 0
Local nPosSer  		:= 0
Local nPosVlr  		:= 0
Local lRet     		:= .T.
Local nOpcx    		:= iIf(inclui, 3, iIf(altera, 4, 2))
Local nOper    		:= aRotina[ nOpcx, 4 ]
Local nCntFor  		:= 0
Local lExibe   		:= .t.

Private aHeaderSZ9	:= {}
Private aColsSZ9   	:= {}
Private _cimeipn   	:= IMEI
Private _cospn     	:= OS
Private _ccodtec   	:= CODTEC
Private _cNfe  		:= POSICIONE("ZZ4",1,xFilial("ZZ4") + IMEI + left(_cospn,6),"ZZ4_NFENR")
Private _cNse  		:= POSICIONE("ZZ4",1,xFilial("ZZ4") + IMEI + left(_cospn,6),"ZZ4_NFESER")
Private _cSpc	   	:= Posicione("SZA",3,xFilial("SZA") + _cNfe + _cNse + IMEI,"ZA_SPC") //Numero do SPC atribuido
Private _cItem    	:= '00'
Private aSavAcols 	:= {}
Private	aSavAhead 	:= {}
Private _lTudoOk  	:= .F.
Private	nSavN       := 0         
Private cFaultId	:= ""         
Private cSEQUENCIA  := cSEQ
Private oDlg
Private oGetDesp   
Private FAS1Ori		:= FAS1Ori

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina de travamento do radio - GLPI 14467³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := U_VLDTRAV(xFilial("ZZ4"), IMEI, left(_cospn,6), {"P","TECAX017","TECAX017"})
If !lRet
	Return(lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Aheader SZ9                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Empty(aHeaderSZ9) )
	// Inclusao do campo Z9_SEQ no aHeader (este campo esta configurado como NAO usado)
	If funname() == "TECAX019"
		dbSelectArea("SX3")
		dbSetOrder(2)
		If SX3->(dbSeek("Z9_SEQ"))
			nUsado++
			aadd(aHeaderSZ9,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
	EndIf
	// Inclusao dos campos usados no aHeader
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SZ9")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SZ9") )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			aadd(aHeaderSZ9,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
			//			nUsado++
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols SZ9                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado := Len(aHeaderSZ9)
SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI, Z9_NUMOS, Z9_SEQ

If funname() == "TECAX019"
	_cChave := IMEI +  _cospn
Else
	_cChave := IMEI +  _cospn + cSEQUENCIA
EndIf
If SZ9->(dbSeek( xFilial("SZ9") + _cChave ))
	
	While SZ9->(!Eof()) .And. xFilial("SZ9") == SZ9->Z9_FILIAL .And. alltrim(_cospn) == alltrim(SZ9->Z9_NUMOS) .And. ;
		alltrim(SZ9->Z9_IMEI) == alltrim(IMEI) .and. iIf(funname() <> "TECAX019", alltrim(SZ9->Z9_SEQ) == alltrim(cSEQUENCIA), .t.)
		
		aadd(aColsSZ9,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			If ( aHeaderSZ9[nCntFor][10] == "V" )
				aColsSZ9[Len(aColsSZ9)][nCntFor] := CriaVar(aHeaderSZ9[nCntFor][2])
			Else
				aColsSZ9[Len(aColsSZ9)][nCntFor] := SZ9->(FieldGet(FieldPos(aHeaderSZ9[nCntFor][2])))
			EndIf
		Next nCntFor
		
		aColsSZ9[Len(aColsSZ9)][nUsado+1] := .F.
		_cItem := SZ9->Z9_ITEM
		
		SZ9->(dbSkip())
		
	EndDo
	
EndIf

If ( lExibe )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salva o aCols   de Entrada e Desabilita o Paint da Primeira GetDados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSavAcols:= aClone(aCols)
	aSavAhead:= aClone(aHeader)
	aHeader  := aClone(aHeaderSZ9)
	aCols    := aClone(aColsSZ9)
	nSavN    := N
	N        := 1
	
	If nOpcx <> 2
		_cPartNo := Posicione("ZZ1",1,xFilial("ZZ1") + LAB + substr(CODSET,1,At('-',CODSET)-2) + substr(FAS1,1,At('-',FAS1)-2),"ZZ1_PARTNR")
	Else
		_cPartNo := ""
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a GetDados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//DEFINE MSDIALOG oDlg TITLE cCadastro From 10,0 to 28,80 Pixel Style DS_MODALFRAME
	DEFINE MsDialog oDlg From 060,018 To 0310,0650 Title cCadastro Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.
	
	If !Empty(_cSpc)
		@ 015,005 SAY RetTitle("Z9_IMEI")  + ": " + alltrim(IMEI) + " - " + AllTrim(_cSpc) OF oDlg PIXEL
	Else
		@ 015,005 SAY RetTitle("Z9_IMEI")  + ": " + alltrim(IMEI) OF oDlg PIXEL
	EndIf
	
	@ 015,200 SAY RetTitle("Z9_NUMOS") + ": " + alltrim(_cospn) OF oDlg PIXEL
	@ 025,005 SAY RetTitle("Z9_CODTEC")+ ": " + _ccodtec+" - "+Posicione("AA1",1,xFilial("AA1")+CODTEC,"AA1_NOMTEC") OF oDlg PIXEL
	If funname() <> "TECAX019"
		@ 025,200 SAY RetTitle("Z9_SEQ")   + ": " + cSEQUENCIA OF oDlg PIXEL
	EndIf
	oGetDesp := MsGetDados():New(034,001,120,316,nOpcx,,"AllwaysTrue","+Z9_ITEM", ( nOper == 4 .Or. nOper == 3 ) )
	
	aButtons := {}
	AADD( aButtons, {"HISTORIC", {|| U_BrowSZ9(IMEI)}, "Histórico...","Histórico",{|| .T.}} )
	
	// Comentado e alterado dialogo Edson Rodrigues - 29/07/10
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| If(oGetDesp:TudoOk() .and. nOpcx<>2 , If(Grava(IMEI, _cospn, cSEQUENCIA,_lobripart),oDlg:End(),oDlg),oDlg:End())} , {|| iIf(_cPartNo == "2",U_DelApont(),iIf(_lobripart,.f.,oDlg:End()))})
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| If( nOpcx<>2 , If(Grava(IMEI, _cospn, cSEQUENCIA,_lobripart),oDlg:End(),oDlg),oDlg:End())} , {|| iIf(_cPartNo == "2",U_DelApont(),iIf(_lobripart,.f.,oDlg:End()))},,@aButtons)
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
±±ºPrograma  ³Grava     ºAutor  ³Edson B. - ERP Plus º Data ³  04/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava temporariamente os dados apontados no SZ9             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava(IMEI, _cospn, cSEQUENCIA,_lobripart)

Local _nPosIMEI   	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_IMEI"  })
Local _nPosOS     	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_NUMOS"  })
Local _nPosItem   	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_ITEM"  })
Local _nPosFaulID 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_FAULID"})
Local _nPosAction 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_ACTION"})
Local _nPosMotivo 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_MOTIVO"})
Local _nPosQty    	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_QTY"   })
Local _nPosPartNR 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PARTNR"})
Local _nPosUsed   	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_USED"  })
Local _nPosposloc 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_LOCAL"  })
Local _nPosSympto 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_SYMPTO"})
Local _nPosSintco 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_SINTCOD"})
Local _nPosmotdef 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_MOTDEFE"})
Local _nPosnivelr 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_NIVELRE"})
Local _nPosprevco 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PREVCOR"})
Local _nPosposesq 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_POSESQU"})
Local _nPosstatus 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_STATUS"})
Local _nPosnumseq 	:= aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_NUMSEQ"})
Local _lEmptypart 	:= .F.
Local _Bloq			:= .T.
Local _cQry

SZ9->(dbSetOrder(2))   // Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM

If (lUsrNext .Or. lUsrAdmi) .and. LAB <> 'E'
	//Valida todos apontamentos finais
	If Len(AllTrim(aCols[Len(aCols),_nPosPartNR]))>0
		If Select("QRY") > 0
			QRY->(dbCloseArea())
		EndIf
		
		_cQry	:=" SELECT Z9_NUMOS,COUNT(Z9_PARTNR)CONT  "
		_cQry	+=" FROM " + RetSqlName("SZ9") + " (NOLOCK) "
		_cQry	+=" WHERE D_E_L_E_T_ = '' "
		_cQry	+=" AND Z9_PARTNR = '" +aCols[Len(aCols),_nPosPartNR]+ "' "
		_cQry	+=" AND Z9_NUMOS = '" +_cospn+ "' "
		_cQry	+=" GROUP BY Z9_NUMOS,Z9_PARTNR "
		_cQry	+=" ORDER BY CONT DESC "
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
		
		If QRY->CONT > 0
			If	MSGYESNO("Fora Apontados : "+TransForm(QRY->CONT, "@E 999") +" o PartNumber " + AllTrim(aCols[Len(aCols),_nPosPartNR])+ " para a OS "+_cospn+"Deseja Continuar?",OemToAnsi('ATENCAO'))
				_lRet:=vlapofin(_nPosFaulID,_nPosAction,_nPosmotdef,_nPosnivelr,_nPosSympto,_nPosSintco,_nPosPartNR,_nPosposesq,_nPosposloc,_nPosQty,_nPosMotivo)
			Else
				_lRet := .F.
			EndIf
		Else
			_lRet:=vlapofin(_nPosFaulID,_nPosAction,_nPosmotdef,_nPosnivelr,_nPosSympto,_nPosSintco,_nPosPartNR,_nPosposesq,_nPosposloc,_nPosQty,_nPosMotivo)
		EndIf
	Else
		_lRet := .F.
	EndIf
Else
	
	//Valida todos apontamentos finais
	_lRet:=vlapofin(_nPosFaulID,_nPosAction,_nPosmotdef,_nPosnivelr,_nPosSympto,_nPosSintco,_nPosPartNR,_nPosposesq,_nPosposloc,_nPosQty,_nPosMotivo)
	
EndIf

If _lRet
	// Grava todos os Part Numbers apontados neste momento
	For _nI := 1 To len(aCols)
		lNovo := .t. // ve se eh novo apontamento, utilizado na requisicao
		aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
		_coldpartn:=""
		If SZ9->(dbSeek(xFilial("SZ9") + IMEI + _cospn + cSequencia + aCols[_nI,_nPosItem] ))
			//Acrescentado "If" Edson Rodrigues - 18/03/10
			If !EMPTY(SZ9->Z9_PARTNR) .AND. SZ9->Z9_STATUS='0' .AND. SZ9->Z9_QTY > 0 .AND. EMPTY(SZ9->Z9_NUMSEQ)
				lNovo := .T.
			Else
				lNovo := .F.
				_coldpartn:=IIf(!EMPTY(SZ9->Z9_NUMSEQ),SZ9->Z9_PARTNR,"")
			EndIf
			U_ADDSZ9(.F.,_lobripart, lNovo,@_lEmptypart)
		Else
			U_ADDSZ9(.T.,_lobripart, lNovo,@_lEmptypart)
		EndIf		
		//-----|| 4.3.2010 - EDUARDO NAKAMATU
		//-----|| INCLUI REQUISICAO
		//----Alterado a lógica acima e também esta abaixo, para chamar via função, pois estava sendo repetido várias esse bloco de códigos - Edson Rodrigues
		If lNovo
			//cOpe := ZZ4->ZZ4_OPEBGH // Alterado Edson Rodrigues 22/03/10
			//cLab := ZZ3->ZZ3_LAB         // Alterado Edson Rodrigues 22/03/10
			cseqsd3:=""
			cLab 		:= LAB
			cOpe  		:= POSICIONE("ZZ4",1,xFilial("ZZ4") + IMEI + left(_cospn,6),"ZZ4_OPEBGH")
			lFazReq 	:= IIf(!EMPTY(SZ9->Z9_PARTNR) .AND. SZ9->Z9_USED=="0",.T.,.F.)
			lret		:=.T.
			lvdadreq	:=U_VLDDREQ(cOpe,LAB) //Valida operações para chamar a função de inserção de requisição. Edson Rodrigues 24/03
			lvdaprod	:=U_VLDPROD(cOpe,LAB) //Valida se a opercao envolve processo de Ordem de producao. Edson Rodrigues  26/04/10
			
			If lFazReq .and. lvdadreq
				lret:=U_REQ_EST(1,SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,SZ9->Z9_QTY,ALLTRIM(SZ9->Z9_NUMOS)+"01001",DATE(),,ZZJ->ZZJ_CODSF5,nil,nil,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC))
				If lret 				   //Incluso Condição e função abaixo para gravar o número de sequênciao obtida no SD3 através do retorno verdadeiro dafunção acima - Edson Rodrigues - 23/03/10
					cseqsd3:=U_SEQMOV(SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,LEFT(SZ9->Z9_NUMOS,6)+"01001  ",DATE(),ZZJ->ZZJ_CODSF5,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM))
					If Empty(cseqsd3)
						MsgAlert("Não foi encontrado a sequencia de movimentação para a peça/OP : "+ALLTRIM(SZ9->Z9_PARTNR)+"/"+LEFT(SZ9->Z9_NUMOS,6)+"01001 "+" no armazém : "+ZZJ->ZZJ_ALMEP+" . Verifique ou entre contado com o Administrador do Sistema ! ")
					Else
						RecLock("SZ9",.F.)
						SZ9->Z9_NUMSEQ := cseqsd3
						SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
						MsUnlock()
						aCols[_nI,_nPosnumseq]:=cseqsd3
						aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
					EndIf
				Else
					MsgAlert("Não foi possível fazer a Mov. Interna, conforme mensagem(ns) anterior(es). A peça : "+ALLTRIM(SZ9->Z9_PARTNR)+" será excluida desse apontamento  ! ")
					acols[_ni,len(aCols[_nI])] := .T.
					_lEmptypart:=.F.  //Desobriga o apontamento da peça, pois a(s) mesma(s) podem não tem saldo - Edson Rodrigues 25/03/10
					_lobripart:=.F.      //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
					RecLock("SZ9",.F.)
					DBDELETE()
					MsUnlock()
				EndIf
			Else
				If acols[_ni,len(aCols[_nI])]
					lret:=.F.
					If lvdadreq
						_lEmptypart:=.F.  //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
						_lobripart:=.F.      //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
					EndIf
					RecLock("SZ9",.F.)
					DBDELETE()
					MsUnlock()
				Else
					RecLock("SZ9",.F.)
					SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
					MsUnlock()
					aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
				EndIf
			EndIf
		Else
			cseqsd3:=SZ9->Z9_NUMSEQ
			cLab := LAB
			cOpe  := POSICIONE("ZZ4",1,xFilial("ZZ4") + IMEI + left(_cospn,6),"ZZ4_OPEBGH")
			lFazReq  := IIf((!EMPTY(SZ9->Z9_PARTNR) .OR. !EMPTY(_coldpartn)) .AND. !EMPTY(SZ9->Z9_NUMSEQ) .AND. SZ9->Z9_USED="0",.T.,.F.)
			lret:=.T.
			lvdadreq:=.t.
			lvdadreq:=U_VLDDREQ(cOpe,LAB) //Valida operações para chamar a função de inserção de requisição. Edson Rodrigues 24/03
			lvdaprod:=U_VLDPROD(cOpe,LAB) //Valida se a opercao envolve processo de Ordem de producao. Edson Rodrigues  26/04/10
			
			If lFazReq .and. lvdadreq
				Dbselectarea("SD3")
				DBSETORDER(4)
				//If DBSEEK(XFILIAL("SD3")+ALLTRIM(cseqsd3)) // //Alterarado a busca para encontrar o registro correto nos caso onde já houve estorno. Edson Rodrigues 30/03/10
				If DBSEEK(XFILIAL("SD3")+ALLTRIM(cseqsd3)+'E0'+IIf(EMPTY(SZ9->Z9_PARTNR),_coldpartn,IIf(EMPTY(_coldpartn),SZ9->Z9_PARTNR,IIf(_coldpartn<>SZ9->Z9_PARTNR,_coldpartn, SZ9->Z9_PARTNR))))
					// SD3->(U_REQ_EST(2,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5))
					If acols[_ni,len(aCols[_nI])]
						SD3->(U_REQ_EST(3,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5,D3_CHAVE,RECNO(),lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC)))
						lret:=.f.
						_lEmptypart:=.F.  //Desobriga o apontamento da peça, a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
						_lobripart:=.F.      //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
						acols[_ni,len(aCols[_nI])] := .T.
						RecLock("SZ9",.F.)
						DBDELETE()
						MsUnlock()
					Else
						SD3->(U_REQ_EST(3,D3_COD,D3_LOCAL,D3_QUANT,D3_OP,D3_EMISSAO,D3_NUMSEQ,ZZJ->ZZJ_CODSF5,D3_CHAVE,RECNO(),lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC)))
						If !EMPTY(SZ9->Z9_PARTNR)
							lret:=U_REQ_EST(1,SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,SZ9->Z9_QTY,ALLTRIM(SZ9->Z9_NUMOS)+"01001",DATE(),,ZZJ->ZZJ_CODSF5,NIL,NIL,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC))
							
							If lret 					   //Incluso Condição e função abaixo para gravar o número de sequênciao obtida no SD3 através do retorno verdadeiro dafunção acima - Edson Rodrigues - 23/03/10
								cseqsd3:=U_SEQMOV(SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,LEFT(SZ9->Z9_NUMOS,6)+"01001  ",DATE(),ZZJ->ZZJ_CODSF5,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM))
								If Empty(cseqsd3)
									MsgAlert("Não foi encontrado a sequencia de movimentação para a peça/OP : "+ALLTRIM(SZ9->Z9_PARTNR)+"/"+LEFT(SZ9->Z9_NUMOS,6)+"01001 "+" no armazém : "+ZZJ->ZZJ_ALMEP+" . Verifique ou entre contado com o Administrador do Sistema ! ")
								Else
									RecLock("SZ9",.F.)
									SZ9->Z9_NUMSEQ := cseqsd3
									SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
									MsUnlock()
									aCols[_nI,_nPosnumseq]:=cseqsd3
									aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
								EndIf
							Else
								MsgAlert("Não foi possível fazer a Mov. Interna, conforme mensagem(ns) anterior(es). A peça : "+ALLTRIM(SZ9->Z9_PARTNR)+" será excluida desse apontamento  ! ")
								acols[_ni,len(aCols[_nI])] := .T.
								lret:=.f.
								_lEmptypart:=.F.  //Desobriga o apontamento da peça, pois a(s) mesma(s) podem não tem saldo - Edson Rodrigues 25/03/10
								_lobripart:=.F.      //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
								RecLock("SZ9",.F.)
								DBDELETE()
								MsUnlock()
							EndIf
						Else
							cseqsd3:=""
							RecLock("SZ9",.F.)
							SZ9->Z9_NUMSEQ := cseqsd3
							SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
							MsUnlock()
							aCols[_nI,_nPosnumseq]:=cseqsd3
							aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
						ENDIf
					ENDIf
				Else
					MsgAlert("Sequencia: "+ALLTRIM(cseqsd3)+" de movimentação interna nao localizado, não foi possível fazer a alteração!")
				ENDIf
			Else
				If acols[_ni,len(aCols[_nI])]
					lret:=.F.
					If lvdadreq
						_lEmptypart:=.F.  //Desobriga o apontamento da peça, pois as mesmas podem  não tem saldo - Edson Rodrigues 25/03/10
						_lobripart:=.F.      //Desobriga o apontamento da peça, pois as mesmas podem  não tem saldo - Edson Rodrigues 25/03/10
					EndIf
					RecLock("SZ9",.F.)
					DBDELETE()
					MsUnlock()
					
				Else
					//Inclui o Partnumber somente quando o campo partnumber do Acols estava vazio e o usuário resolveu alterar a linha colocando um partnumber
					lFazReq  := IIf(!EMPTY(SZ9->Z9_PARTNR) .AND. EMPTY(SZ9->Z9_NUMSEQ) .AND. SZ9->Z9_USED="0",.T.,.F.)
					
					If lFazReq .and. lvdadreq
						lret:=U_REQ_EST(1,SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,SZ9->Z9_QTY,ALLTRIM(SZ9->Z9_NUMOS)+"01001",DATE(),,ZZJ->ZZJ_CODSF5,NIL,NIL,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM),ALLTRIM(ZZJ->ZZJ_CC))
						If lret 					   //Incluso Condição e função abaixo para gravar o número de sequênciao obtida no SD3 através do retorno verdadeiro dafunção acima - Edson Rodrigues - 23/03/10
							cseqsd3:=U_SEQMOV(SZ9->Z9_PARTNR,ZZJ->ZZJ_ALMEP,LEFT(SZ9->Z9_NUMOS,6)+"01001  ",DATE(),ZZJ->ZZJ_CODSF5,lvdaprod,ALLTRIM(SZ9->Z9_NUMOS)+ALLTRIM(SZ9->Z9_ITEM))
							If Empty(cseqsd3)
								MsgAlert("Não foi encontrado a sequencia de movimentação para a peça/OP : "+ALLTRIM(SZ9->Z9_PARTNR)+"/"+LEFT(SZ9->Z9_NUMOS,6)+"01001 "+" no armazém : "+ZZJ->ZZJ_ALMEP+" . Verifique ou entre contado com o Administrador do Sistema ! ")
							Else
								RecLock("SZ9",.F.)
								SZ9->Z9_NUMSEQ := cseqsd3
								SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
								MsUnlock()
								aCols[_nI,_nPosnumseq]:=cseqsd3
								aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
							EndIf
						Else
							MsgAlert("Não foi possível fazer a Mov. Interna, conforme mensagem(ns) anterior(es). A peça : "+ALLTRIM(SZ9->Z9_PARTNR)+" será excluida desse apontamento  ! ")
							acols[_ni,len(aCols[_nI])] := .T.
							_lEmptypart:=.F.  //Desobriga o apontamento da peça, pois a(s) mesma(s) podem não tem saldo - Edson Rodrigues 25/03/10
							_lobripart:=.F.      //Desobriga o apontamento da peça, pois a(s) mesma(s) podem  não tem saldo - Edson Rodrigues 25/03/10
							RecLock("SZ9",.F.)
							DBDELETE()
							MsUnlock()
						EndIf
					Else
						cseqsd3:=""
						RecLock("SZ9",.F.)
						SZ9->Z9_NUMSEQ := cseqsd3
						SZ9->Z9_IMEI := IMEI    //colocado para gravar o IMEI quando se adiciona uma nova linha - Edson Rodrigues 31/03/10
						MsUnlock()
						aCols[_nI,_nPosnumseq]:=cseqsd3
						aCols[_nI,_nPosIMEI]:=IIf(EMPTY(aCols[_nI,_nPosIMEI]), IMEI,aCols[_nI,_nPosIMEI])
					EndIf
				EndIf
			ENDIf
		ENDIf
		If lret
			aadd(_aRecnoSZ9, SZ9->(RECNO()))
		EndIf
	Next
	
	//EndIf
	If !_lEmptypart// Incluso Edson Rodrigues - 19/07/09
		oDlg:End()
		_lTudoOk := .T.
		_lValidPartNO := .T.
		_lobripart:=.F.
	ENDIf
	
EndIf

If (lUsrNext .Or. lUsrAdmi) .And. _lRet == .F. .and. LAB <> 'E'
	MsgAlert("Houve problema na validacao final dos apontamentos na tela da partnumber! ")
EndIf

If _lRet 
	oDlg:End()   
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelApont  ºAutor  ³Edson B. - ERP Plus º Data ³  08/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DelApont()

Local _cRepar 	:= Posicione("SZL",2,XFILIAL("SZL")+ AllTrim(LAB) + Substr(DEFDET,1,5) + Substr(SOLUCAO,1,5), "ZL_PARTNUM")

If lUsrNext .Or. lUsrAdmi
	If _cRepar == "S"
		MsgAlert("Não sera possivel o fechamento de tela sem apontamentos do partnumber! ")
	Else
		oDlg:End()
	EndIf
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BLQCAMPO  ºAutor  ³Paulo Francisco     º Data ³  09/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Bloqueio do uso do campo SZ9_SYMPTO e Z9_ACTION para        º±±
±±º          ³operacoes Nextel.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BLQCAMPO()

Local lRet := .T.

If (lUsrNext .Or. lUsrAdmi) .and. LAB<>"E"
	lRet := .F.
	
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TECAX017  ºAutor  ³Microsiga           º Data ³  08/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function vldSZ9()
Local _lRet     := .t.
Local _csympt   :=""
Local _caction  :=""
Local _cfault   :=""
Local _csintco  :=""
Local _cmotdef  :=""
Local _cnivrep  :=""
Local _cparnum  :=""
Local _cprodpn  :=""
Local _cgruppn  :=""
Local _cproimei :=""
Local _cgrpimei :=""
Local _cposesq  :=""
Local _cposloc  :=""
Local _aAreaSZ8 := SZ8->(GetArea())
Local _aAreaZZ4 := ZZ4->(GetArea())
Local _aAreaSB1 := SB1->(GetArea())

#IFDEF TOP
	Local 	cGgTemp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	_lQuery    	:= .F.
#ENDIf

Private _coperbgh := ""

If readvar() == "M->Z9_SYMPTO"
	SZ8->(dbSetOrder(1))  // Z8_FILIAL + Z8_CLIENTE + Z8_CODSINT
	If !SZ8->(dbSeek(xFilial("SZ8") + LAB + M->Z9_SYMPTO))
		_lRet := .f.
		apMsgStop("Este código não existe no cadastro de sintomas. Favor selecionar outro sintoma para o apontamento.","Código de Sintoma inválido")
	Else
		_csympt:= POSICIONE("SZ8",1,XFILIAL("SZ8")+ LAB + M->Z9_SYMPTO,"Z8_CODSINT")
	EndIf
ElseIf readvar() == "M->Z9_ACTION"
	
	SZ8->(dbSetOrder(2))  // Z8_FILIAL + Z8_CLIENTE + Z8_CODSOLU
	If !SZ8->(dbSeek(xFilial("SZ8") + LAB + M->Z9_ACTION))
		_lRet := .f.
		apMsgStop("Este código não existe no cadastro de soluções. Favor selecionar outra solução para o apontamento.","Código de Solução inválido")
		
	Else
		_caction:=POSICIONE("SZ8",2,XFILIAL("SZ8")+ LAB + M->Z9_ACTION,"Z8_CODSOLU")
	EndIf
	
ElseIf readvar() == "M->Z9_FAULID"	.AND. LAB $ '1/E'    
	cFaultId := M->Z9_FAULID
	_cfault := TABELA("ZB", M->Z9_FAULID, .F.)
	If Empty(_cfault)
		apMsgStop("Este código não existe no cadastro de falhas. Favor selecionar outra falha para o apontamento.","Código de Falha inválido")
		_lRet := .f.
	EndIf
ElseIf readvar() == "M->Z9_MOTIVO"	.AND. LAB $ '1/E'    
	_cfault := TABELA("SA", M->Z9_MOTIVO, .F.)
	If Empty(_cfault)
		apMsgStop("Este código não existe no codigo de motivos. Favor insira o código de motivo correto para o apontamento.","Código de Motivo inválido")
		_lRet := .f.
	EndIf
	
ElseIf readvar() == "M->Z9_SINTCOD" .AND. LAB $ '1/E'
	_csintco := TABELA("ZS", M->Z9_SINTCOD, .F.)
	If Empty(_csintco)
		apMsgStop("Este código não existe no cadastro de Sintoma Codificado. Favor selecionar outro Sintoma Codificado para o apontamento.","Código de Sintoma Codificado inválido")
		_lRet := .f.
		
	Else
		_nPosSympto := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_SYMPTO"})
		_csympt    := aCols[n,_nPosSympto]
		If !Empty(_csympt) .and. !Empty(_csintco)
			If  val(_csympt) < 10
				_csympt:='0'+_csympt
				If ALLTRIM(substr(_csintco,1,2))<>ALLTRIM(_csympt)
					apMsgStop("código de Sintoma ou Sintoma codificado nao Coerentes. Favor selecionar outro codigo de Sintoma ou Sintoma codIficado para o apontamento.","Código de Sintoma ou Sintoma codIficados Incoerentes")
					_lRet := .f.
				EndIf
			Else
				If ALLTRIM(substr(_csintco,1,2))<>ALLTRIM(_csympt)
					apMsgStop("código de Sintoma ou Sintoma codificado nao Coerentes. Favor selecionar outro codigo de Sintoma ou Sintoma codIficado para o apontamento.","Código de Sintoma ou Sintoma codIficados Incoerentes")
					_lRet := .f.
				EndIf
			EndIf
		EndIf
	EndIf
	
ElseIf readvar() == "M->Z9_MOTDEFE" .AND. LAB $ '1/E'
	_cmotdef := TABELA("ZP", M->Z9_MOTDEFE, .F.)
	If Empty(_cmotdef)
		apMsgStop("Este código não existe no cadastro de Motivo do Defeito. Favor selecionar outro Motivo de Defeito para o apontamento.","Código de Motivo de Defeito inválido")
		_lRet := .f.
	EndIf
	
	
ElseIf readvar() == "M->Z9_NIVELRE" .AND. LAB $ '1/E'
	_cnivrep := TABELA("ZQ", M->Z9_NIVELRE, .F.)
	If Empty(_cnivrep)
		apMsgStop("Este código não existe no cadastro de Nivel de Reparo. Favor selecionar outro Nivel de Reparo para o apontamento.","Código de Nivel de Reparo inválido")
		_lRet := .f.
	EndIf
	
ElseIf readvar() == "M->Z9_PARTNR"
	_cparnum		:=	M->Z9_PARTNR
	_nPosloc 		:= 	aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_LOCAL"})
	_nPosqty 		:= 	aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_QTY"})
	If !Empty(_cimeipn) .and. !Empty(_cospn)
		_cproimei   :=	POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_CODPRO")
		_cgrpimei   :=	POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_GRPPRO")
		_coperbgh  	:=	POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_OPEBGH")
		_nqtmaxpc 	:=	Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_QTDAPP")    // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
		_clocalpc   :=	Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_ALMEP")    // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
	Else
		_cproimei   :=	_cgrpimei := ""
		_coperbgh  	:= 	""
		_clocalpc   := 	""
		_nqtmaxpc 	:= 	99
	EndIf

	If !Empty(_cparnum)
		_lverpn   := .f.
		_nPospec := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_POSESQU"})
		_cparnum :=ALLTRIM(_cparnum)+SPACE(20-LEN(ALLTRIM(_cparnum)))
		aCols[n,_nPospec] :=POSICIONE("ZZ9",1,xFilial("ZZ9") + _cparnum,"ZZ9_POSICA")
		
		If LAB $ '1/E'
			ZZ9->(dbsetorder(1))
			If ZZ9->(dbSeek(xFilial("ZZ9")+_cparnum))
				_cprodpn  :=SUBSTR(ZZ9->ZZ9_DESENH,1,5)
				_cgruppn  :=SUBSTR(ZZ9->ZZ9_DESENH,1,4)
				If (alltrim(_cproimei)=alltrim(_cprodpn)) .or. (left(_cgrpimei,4)=left(_cgruppn,4))
					_lverpn := .t.
				EndIf
			Else
				SB1->(DBOrderNickName('SB1XCODFAB'))//SB1->(dbsetorder(9))
				If SB1->(dbSeek(xFilial("SB1")+_cparnum))
					While  ( !Eof() .And. (SB1->B1_XCODFAB == _cparnum))
						_cprodpn  :=SB1->B1_COD
						_cgruppn  :=SB1->B1_GRUPO
						If (alltrim(_cproimei)=alltrim(_cprodpn)) .or. (left(_cgrpimei,4)=left(_cgruppn,4))
							_lverpn := .t.
						EndIf
						SB1->(dbSkip())
					Enddo
					
					If !_lverpn
						If ApMsgYesNo("Este Partnumber: "+_cparnum+" Nao pertence ao modelo: "+_cgruppn+". Deseja apontar esse Parnumber assim mesmo ?","Código de Partnumber Invalido")
							_lRet := .t.
						Else
							_lRet := .f.
						EndIf
					EndIf
				EndIf
			EndIf
		ENDIf
		
		If Empty(aCols[n,_nPosloc])
			If EMPTY(_clocalpc)
				If LAB='1' .AND. _coperbgh='S03'
					aCols[n,_nPosloc] :='34'
				ElseIf   LAB='1' .AND. _coperbgh $ 'S01/S02'
					aCols[n,_nPosloc] :='21'
				ElseIf  LAB='2'  .AND. _coperbgh $ "N02/N04/N06"
					aCols[n,_nPosloc] :='03'
					
				ElseIf LAB='2'  .AND. _coperbgh = "N05/N01"
					aCols[n,_nPosloc] :='01'
					
				ElseIf LAB='3'  .AND. _coperbgh $ "C01"
					aCols[n,_nPosloc] :='75'
					
				ElseIf LAB='4'  .AND. _coperbgh $ "I01"
					aCols[n,_nPosloc] :='37'
					
				ENDIf
				
			Else
				aCols[n,_nPosloc] :=_clocalpc
			ENDIf
		Else
			aCols[n,_nPosloc] :=_clocalpc
		EndIf
		
		If aCols[n,_nPosqty]<=0
			aCols[n,_nPosqty] :=1
		Else
			//Valida quantidade maxima de digitação para o Partnumber - Edson Rodrigues 20/03/10
			If aCols[n,_nPosqty] >_nqtmaxpc
				apMsgStop("Não é permitido digitar a quantidade de partnumber maior que "+strzero(_nqtmaxpc,2)+". Digite uma qtde menor ou igual ou verifique e cadastro de parâmetros de operações.","Qtde de Partnumber Invalida")
				_lRet := .f.
			EndIf
		EndIf
		
		//VerIfica se tem saldo para o produto de acordo com a operação -Edson Rodrigues - 01/04/10
		lvdadreq:=U_VLDDREQ(_coperbgh,LAB) //Valida operações para chamar a função de iconsultar saldo. Edson Rodrigues 01/04/10
		If  lvdadreq
			
			lconsaldo:=U_CONSALDO(_cparnum,aCols[n,_nPosloc],aCols[n,_nPosqty])
			If !lconsaldo
				_lRet := .f.
			EndIf
		ENDIf
		
		
	Else
		aCols[n,_nPosqty] :=0
		aCols[n,_nPosloc] :=""
	EndIf
	
	If lUsrNext .Or. lUsrAdmi
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consulta PartNumber X Modelo                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		#IfDEF TOP
			
			
			_lQuery  := .T.
			
			_cQuery := " SELECT GG_COMP AS PROD "
			_cQuery += " FROM "+RetSqlName("SGG")+" AS  SGG "
			_cQuery += " WHERE "
			_cQuery += " SGG.GG_FILIAL = '" + xFilial('SGG') + "' "
			_cQuery += " AND (SGG.GG_COD = "
			_cQuery += " ( SELECT TOP 1 GG_COMP "
			_cQuery += " FROM "+RetSqlName("SGG")+" AS GG_1 "
			_cQuery += " WHERE "
			_cQuery += " GG_1.GG_COD = '" +_cproimei+ "' "
			_cQuery += " AND GG_1.D_E_L_E_T_ = '') "
			_cQuery += " OR SGG.GG_COD ='" +_cproimei+ "')"
			_cQuery += " AND SGG.GG_COMP =	'" +_cparnum+ "' "
			_cQuery += " AND SGG.GG_TRT	=	'" +_coperbgh+ "' "
			_cQuery += " AND SGG.D_E_L_E_T_ = '' "
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQuery), "QTEMP2", .F., .T.)
			
			dbSelectArea("QTEMP2")
			dbGoTop()
			/*
			If Empty(AllTrim(("QTEMP2")->PROD))
			MsgStop("PartNumber não ClassIficado para esse Modelo, Favor Entrar em Contato com seu Supervisor","Divergencias PartNumber")
			_Bloq := .F.
			_lRet := .F.
			EndIf
			*/			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Uiran Almeida - 03.04.2014                         ³
			//³Bloqueio do apontamento para as peças nao eletricas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(AllTrim(("QTEMP2")->PROD))
				DbSelectarea("SB1")
				SB1->(dbSetOrder(1)) 	// B1_FILIAL+B1_COD
				
				If SB1->(dbSeek(xFilial("SB1")+ AllTrim(("QTEMP2")->PROD)))
					If Empty(Alltrim(SB1->B1_XMECELE))
						Aviso("Nao Permitido","PartNumber: "+AllTrim(("QTEMP2")->PROD)+", não é uma peça eletrica ! Favor verIficar junto a Engenharia",{"OK"})
						_Bloq := .F.
						_lRet := .F.
					ElseIf(Alltrim(SB1->B1_XMECELE) <> "E")
						Aviso("Nao Permitido","PartNumber: "+AllTrim(("QTEMP2")->PROD)+", não é uma peça eletrica ! Favor verIficar junto a Engenharia",{"OK"})
						_Bloq := .F.
						_lRet := .F.
					EndIf
				Else
					Aviso("Nao Permitido","PartNumber: "+AllTrim(("QTEMP2")->PROD)+", não encontrado no Cadastro de Produtos! Favor verIficar junto a Controladoria",{"OK"})
					_Bloq := .F.
					_lRet := .F.
				EndIf
			Else
				MsgStop("PartNumber não ClassIficado para esse Modelo, Favor Entrar em Contato com seu Supervisor","Divergencias PartNumber")
				_Bloq := .F.
				_lRet := .F.
			EndIf
						
			If _lQuery
				("QTEMP2")->( DbCloseArea())
			EndIf
			
		#ENDIf
		
	EndIf
	
	
ElseIf readvar() == "M->Z9_POSESQU" .AND. LAB='1/E'
	_cposesq:=M->Z9_POSESQU
	_nPospart := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "M->Z9_PARTNR"})
	_cpartnum := ALLTRIM(aCols[n,_nPospart])+space(20-len(ALLTRIM(aCols[n,_nPospart])))
	
	If Empty(_cposesq) .AND. !EMPTY(_cpartnum)
		apMsgStop("favor preencher o campo de posicao do esquema da Peca.","Código de Posicao de esquema da peca nao preenchido")
		_lRet := .f.
	Else
		M->Z9_POSESQU :=POSICIONE("ZZ9",1,xFilial("ZZ9") + _cpartnum,"ZZ9_POSICA")
	ENDIf
	
ElseIf readvar() == "M->Z9_LOCAL"
	_cposloc  :=M->Z9_LOCAL
	_nPosloc := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_LOCAL"})
	_nPospart := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PARTNR"})
	_cpartnum := ALLTRIM(aCols[n,_nPospart])+space(20-len(ALLTRIM(aCols[n,_nPospart])))
	If !Empty(_cimeipn) .and. !Empty(_cospn)
		_coperbgh  :=POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_OPEBGH")
		_clocalpc   :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_ALMEP")    // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
	Else
		_coperbgh :=""
		_clocalpc := ""
	EndIf
	
	If !EMPTY(_cpartnum)
		If Empty(aCols[n,_nPosloc])
			If EMPTY(_clocalpc)
				If LAB='1' .AND. _coperbgh='S03'
					aCols[n,_nPosloc] :='34'
				ElseIf   LAB='1' .AND. _coperbgh $ 'S01/S02'
					aCols[n,_nPosloc] :='21'
					
				ElseIf  LAB='2'  .AND. _coperbgh $ "N02/N04/N06"
					aCols[n,_nPosloc] :='03'
					
				ElseIf LAB='2'  .AND. _coperbgh $ "N05/N01"
					aCols[n,_nPosloc] :='01'
					
				ElseIf LAB='3'  .AND. _coperbgh $ "C01"
					aCols[n,_nPosloc] :='75'
					
				ElseIf LAB='4'  .AND. _coperbgh $ "I01"
					aCols[n,_nPosloc] :='37'
					
				ENDIf
			Else
				aCols[n,_nPosloc] :=_clocalpc
				M->Z9_LOCAL:=_clocalpc
			ENDIf
		Else
			aCols[n,_nPosloc] :=_clocalpc
			M->Z9_LOCAL:=_clocalpc
		EndIf
	Else
		aCols[n,_nPosloc] := ""
		M->Z9_LOCAL:=""
	EndIf
	
	
ElseIf readvar() == "M->Z9_QTY"
	_nPosqty := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_QTY"})
	_nPospart := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PARTNR"})
	_cpartnum := ALLTRIM(aCols[n,_nPospart])+space(20-len(ALLTRIM(aCols[n,_nPospart])))
	If !Empty(_cimeipn) .and. !Empty(_cospn)
		_coperbgh  :=POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_OPEBGH")
		_nqtmaxpc :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_QTDAPP")    // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
	Else
		_coperbgh :=""
		_clocalpc := ""
		_nqtmaxpc := 99
	EndIf
	
	If !Empty(_cpartnum)
		If aCols[n,_nPosqty]<=0
			aCols[n,_nPosqty] :=1
		Else
			//Valida quantidade maxima de digitação para o Partnumber - Edson Rodrigues 20/03/10
			If M->Z9_QTY >_nqtmaxpc
				apMsgStop("Não é permitido digitar uma quantidade de partnumber maior que "+strzero(_nqtmaxpc,2)+". Digite uma qtde menor ou igual ou verIfique  cadastro de parâmetros de operações.","Qtde de Partnumber Invalida")
				_lRet := .f.
			EndIf
		EndIf
	Else
		If M->Z9_QTY > 0  .or.   aCols[n,_nPosqty] > 0
			aCols[n,_nPosqty] :=0
			M->Z9_QTY:= 0
		EndIf
	EndIf
ENDIf
RestArea(_aAreaSZ8)
RestArea(_aAreaZZ4)
RestArea(_aAreaSB1)

Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLAPONFIN  ºAutor  ³Edson Rodrigues    º Data ³  24/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Apontamentos Finais  - Especifico Sony-BGH          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function vlapofin(_nPosFaulID, _nPosAction, _nPosmotdef, _nPosnivelr, _nPosSympto, _nPosSintco, _nPosPartNR, _nPosposesq, _nPosposloc, _nPosposqty, _nPosMotivo)

Local _lRet := .T.
Local _cMotivo := ""

If !Empty(_cimeipn) .and. !Empty(_cospn)
	_coperbgh  :=POSICIONE("ZZ4",1,xFilial("ZZ4") + _cimeipn + left(_cospn,6),"ZZ4_OPEBGH")
	_nqtmaxpc  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_QTDAPP")  // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
	_clocalpc  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_ALMEP")   // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
	cinftrans  :=Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh+LAB, "ZZJ_INFTCM")  // variavel que informa o Transcode - Processo Mclaims - Edson Rodrigues 11/08/10
Else
	_coperbgh  := ""
	_clocalpc  := ""
	_nqtmaxpc  := 99
	cinftrans  := "N"
EndIf

If LAB='1'
	For _nI := 1 To Len(aCols)
		If !acols[_ni,Len(aCols[_nI])]
			_cfault  := aCols[_nI,_nPosFaulID]
			_caction := aCols[_nI,_nPosAction]
			_cMotivo := aCols[_nI,_nPosMotivo]
			_cmotdef := aCols[_nI,_nPosmotdef]
			_cnivrep := aCols[_nI,_nPosnivelr]
			_csympt  := aCols[_nI,_nPosSympto]
			_csintco := aCols[_nI,_nPosSintco]
			_cpartnum:= aCols[_nI,_nPosPartNR]
			_cposesq := aCols[_nI,_nPosposesq]
			_cposloc := aCols[_nI,_nPosposloc]
			_nposqty := aCols[_nI,_nPosposqty]
			
			If !Empty(_cfault) .and. !Empty(_caction) .and. !Empty(_cMotivo) .and.  !Empty(_cnivrep) .and.  !Empty(_cmotdef) .and. !Empty(_csympt) .and. !Empty(_csintco)
				Do Case
					Case _cfault = '05' .and. _caction <> '04' .and. _cmotdef <> '1' .and. _cnivrep <> '2'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 5. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '11' .and. !_caction $ '16/22' .and. !_cmotdef $ '1/3' .and. !_cnivrep $ '1/2'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 11. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '12' .and. _caction <> '25' .and. _cmotdef <> '3' .and. _cnivrep <> '5'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 12. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '13' .and. _caction <> '03' .and. _cmotdef <> '2' .and. _cnivrep <> '3'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 13. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '14' .and. _caction <> '08' .and. _cmotdef <> '1' .and. _cnivrep <> '3'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 14. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '16' .and. !_caction $ '01/08/11' .and. _cmotdef <> '1' .and. !_cnivrep $ '2/3'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 16. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '17' .and. _caction <> '08' .and. _cmotdef <> '1' .and. _cnivrep <> '3'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 17. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '19' .and. _caction <> '14' .and. _cmotdef <> '3' .and. _cnivrep <> '6'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 19. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
						
					Case _cfault = '31' .and. _caction <> '05' .and. _cmotdef <> '3' .and. _cnivrep <> '1'
						apMsgStop("código de acao, motivo de defeito ou codigo do Nivel de reparo, nao pertencem a falha 31. Favor selecionar outro codigo de acao, Mot. Defeito ou Nivel de Reparo .","Código acao, Mot. Defeito ou Nivel de Reparo incoerentes")
						_lRet := .f.
				EndCase
				If Empty(_cposesq) .AND. !EMPTY(_cpartnum)
					apMsgStop("Favor preencher o campo de posição do esquema da Peça.","Código de Posição de esquema da peça não preenchido")
					_lRet := .f.
				EndIf
			Else
				apMsgStop("Campo(s) : Falha, Acao, Sintoma, Sint. CodIficado, Mot.Defeito, Niv.Reparo ou Motivo não estão preenchido(s). Favor Preencher !","Campo(s) não preenchido(s)")
				_lRet := .f.
			EndIf
		EndIf
	Next
EndIf
For _nI := 1 To len(aCols)
	If !acols[_ni,len(aCols[_nI])]
		
		_cpartnum := aCols[_nI,_nPosPartNR]
		_cposloc  := aCols[_nI,_nPosposloc]
		_nposqty  := aCols[_nI,_nPosposqty]
		_caction  := aCols[_nI,_nPosAction]
		_cMotivo  := aCols[_nI,_nPosMotivo]
		_csympt   := aCols[_nI,_nPosSympto]  
		
		If (U_VlFCxACf(_nPosFaulID,_nPosAction))
		  	If !(U_ValSwap(_nPosFaulID,_nPosAction))
		  		_lRet := .F.	
		  	EndIf
		EndIf
		
		If Empty(_cMotivo) .AND. FAS1Ori = '07'       
			apMsgStop("Favor preencher o campo Motivo na linha: " + strzero(_nI,2) + ".","Preencher campo Motivo")
			_lRet := .f. 
		EndIf
		
		//Valida digitacao de Action X Symptom - edson Rodrigues 11/08/10
		If Empty(_caction) .and. !Empty(_csympt) .and. cinftrans="S"
			apMsgStop("favor preencher o campo Action ID na linha: "+strzero(_nI,2)+". Se preenchido o campo Symptom ID é obrigatótio preencher o campo Action ID.","Action ID X Sympton ID")
			_lRet := .f.
		EndIf
		
		//Valida digitacao de Sympton X Action - edson Rodrigues 11/08/10
		If !Empty(_caction) .and. Empty(_csympt) .and. cinftrans="S"
			apMsgStop("favor preencher o campo Symptom ID na linha: "+strzero(_nI,2)+". Se preenchido o campo Action ID é obrigatótio preencher o campo Sympton ID.","Symptom ID X Action ID")
			_lRet := .f.
		EndIf

		//Valida Partnumber X Armazem - Edson Rodrigues 22/03/10
		If Empty(_cposloc) .and. !Empty(_cpartnum)
			apMsgStop("favor preencher o campo armazem da Peca, linha: "+strzero(_nI,2)+".","Código do armazem da peca nao preenchido. ")
			_lRet := .f.
			
		ElseIf !Empty(_cposloc) .and. !Empty(_cpartnum)
			If !Empty(_clocalpc)
				If  _cposloc<>_clocalpc
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido ." ,"favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
				EndIf
			Else
				If   LAB='1' .AND. _coperbgh ="S03" .and. _cposloc<>"34"
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				ElseIf  LAB='1' .AND. _coperbgh $ "S01/S02" .and. _cposloc<>'21'
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				ElseIf  LAB='2'  .AND. _coperbgh $ "N02/N04/N06"  .and. _cposloc<>'03'
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				ElseIf  LAB='2'  .AND. _coperbgh $ "N05/N01"  .and. _cposloc<>'01'
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				ElseIf  LAB='3'  .AND. _coperbgh $ "C01"  .and. _cposloc<>'75'
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				ElseIf  LAB='4'  .AND. _coperbgh $ "I01"  .and. _cposloc<>'37'
					apMsgStop("O armazem preenchido na linha :  "+strzero(_nI,2)+" é invalido." , "favor alterar ou verIficar o cadastro de operações. ")
					_lRet := .f.
					
				EndIf
			EndIf
			
		ElseIf !Empty(_cposloc) .and. Empty(_cpartnum)
			aCols[_nI,_nPosposloc]:=""
			
		EndIf
		
		//Valida Quantidade - Edson Rodrigues 22/03/10
		If  _nposqty <= 0 .and. !Empty(_cpartnum)
			apMsgStop("Favor preencher a quantidade do partnumber, linha :  "+strzero(_nI,2)+" ." , " Quantidade do Partnumber invalida.")
			_lRet := .f.
			
		ElseIf  _nposqty >_nqtmaxpc  .and.   !Empty(_cpartnum)
			apMsgStop("A quantidade digitada para o partnumber na linha :  "+strzero(_nI,2)+", não pode ser maior que a qtde de :"+strzero(_nqtmaxpc,2)+" parametrizada nessa operação" , " Quantidade do Partnumber invalida.")
			_lRet := .f.
			
		ElseIf  _nposqty > 0 .and. Empty(_cpartnum)
			apMsgStop(" Não há a partnumber preenchido na linha : "+strzero(_nI,2)+". Portanto a quantidade deverá ser igual Zero" , " Quantidade do Partnumber invalida.")
			_lRet := .f.
		EndIf
	EndIf
next

Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDSZ9    ºAutor  ³Edson Rodrigues - BGH º Data ³  24/03/10º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona dados na tabela SZ9                                º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function ADDSZ9(Inclui,_lobripart,lNovo,_lEmptypart)

Local _nPosItem   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_ITEM"  })
Local _nPosFaulID := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_FAULID"})
Local _nPosAction := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_ACTION"})
Local _nPosMotivo := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_MOTIVO"})
Local _nPosQty    := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_QTY"   })
Local _nPosPartNR := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PARTNR"})
Local _nPosUsed   := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_USED"  })
Local _nPosposloc := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_LOCAL"  })
Local _nPosSympto := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_SYMPTO"})
Local _nPosSintco := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_SINTCOD"})
Local _nPosmotdef := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_MOTDEFE"})
Local _nPosnivelr := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_NIVELRE"})
Local _nPosprevco := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_PREVCOR"})
Local _nPosposesq := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_POSESQU"})
Local _nPosstatus := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_STATUS"})
Local _nPosnumseq := aScan(aHeader,{|x|AllTrim(Upper(x[2])) == "Z9_NUMSEQ"})
Local _cOpe       := POSICIONE("ZZ4",1,xFilial("ZZ4") + IMEI + left(_cospn,6),"ZZ4_OPEBGH")
Local _Obappob    := Posicione("ZZJ",1,xFilial("ZZJ") +_cOpe+LAB, "ZZJ_OBAPOB")

If  _lobripart .and.  EMPTY(aCols[_nI,_nPosPartNR]) .and. _Obappob='S'
	_lEmptypart := .T.   // Incluso Edson Rodrigues - 19/07/09
	apMsgInfo("Caro usuário, e obrigatorio o apontamento do parnumber para essa fase ","Cadastrar Partnumber")
	Return()
Else
	If Inclui
		RecLock("SZ9", .T.)
		SZ9->Z9_FILIAL := xFilial("SZ9")
		SZ9->Z9_IMEI   := IMEI
		SZ9->Z9_NUMOS  := alltrim(left(_cospn,6))
		SZ9->Z9_SEQ    := cSEQUENCIA
		SZ9->Z9_ITEM   := aCols[_nI,_nPosItem  ]
		SZ9->Z9_CODTEC := _ccodtec
		
		If LAB = '2'
			SZ9->Z9_SYMPTO 	:= DEFDET
			SZ9->Z9_ACTION	:= SOLUCAO
		EndIf
		
	Else
		RecLock("SZ9", .F.)
	ENDIf
	SZ9->Z9_FAULID := aCols[_nI,_nPosFaulID]
	SZ9->Z9_QTY    := aCols[_nI,_nPosQty   ]
	SZ9->Z9_PARTNR := aCols[_nI,_nPosPartNR]
	SZ9->Z9_USED   := aCols[_nI,_nPosUsed  ]
	
	If LAB = '2'
		SZ9->Z9_SYMPTO 	:= DEFDET
		SZ9->Z9_ACTION	:= SOLUCAO
	Else
		SZ9->Z9_SYMPTO := aCols[_nI,_nPosSympto]
		SZ9->Z9_ACTION := aCols[_nI,_nPosAction]
		SZ9->Z9_MOTIVO := aCols[_nI,_nPosMotivo]		
	EndIf
	
	SZ9->Z9_STATUS  := "0"
	SZ9->Z9_FASE1   := FAS1
	SZ9->Z9_SINTCOD := aCols[_nI,_nPosSintco]
	SZ9->Z9_MOTDEFE := aCols[_nI,_nPosmotdef]
	SZ9->Z9_NIVELRE := aCols[_nI,_nPosnivelr]
	SZ9->Z9_PREVCOR := aCols[_nI,_nPosprevco]
	SZ9->Z9_POSESQU := aCols[_nI,_nPosposesq]
	SZ9->Z9_LOCAL   := aCols[_nI,_nPosposloc]
	SZ9->Z9_NUMSEQ  := aCols[_nI,_nPosnumseq]
	//Gravar data do apontamento da peca conforme solicitaçao do Edson - 27/07
	SZ9->Z9_DTAPONT	:= dDataBase
	
	MsUnlock()
	Commit
	
	// 21/05/2012 - M.Munhoz - Alertas para antecipar problemas do MCLAIM
	If !Empty(SZ9->Z9_PARTNR) .and. LAB == "2"
		_cDesign := Posicione("SB1",1,xFilial("SB1")+SZ9->Z9_PARTNR,"B1_CREFDES")
		If Empty(_cDesign)
			cPara    := getmv("MV_XMCLEMA")
			cCC      := ""
			cAssunto := "MCLAIM >>> Produto sem DESIGNATOR"
			cMsg     := "Caro responsável pelo MCLAIM, foi apontado o Part Number "+alltrim(SZ9->Z9_PARTNR)+" no IMEI: "+alltrim(SZ9->Z9_IMEI)+" - OS: "+alltrim(SZ9->Z9_NUMOS)+", o qual não possui código Designator (B1_CREFDES). Favor verIficar antes que o MCLAIM seja gerado."
			U_ENVIAEMAIL(cAssunto,cPara,cCC,cMsg,"")
		EndIf
	EndIf
EndIf
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDAPONT  ºAutor  ³Uiran Almeida       º Data ³  10/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o apontamento de pecas de acordo com o novo projeto º±±
±±º          ³ de apontamentos                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLPI - 16 832 doc BGHDP0028                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VldApont(cImei,cPartNumber)
Local lVal 		:= .T.
Local cGar 		:= ""
Local cCalgar 	:= ""
Local cStatus   := "4"
Local aAreaZZ4   := getArea("ZZ4")
Local aAreaZZJ   := getArea("ZZJ")
Local aAreaSB1   := getArea("SB1")

cImei := AvKey(cImei,"ZZ4_IMEI")

dbSelectArea("ZZJ")
ZZJ->(dbSetOrder(1))

DbSelectarea("SB1")
SB1->(dbSetOrder(1)) 	// B1_FILIAL+B1_COD

If (SB1->(dbSeek(xFilial("SB1")+ cPartNumber)))
	If (Empty(Alltrim(SB1->B1_XMECELE) ))
		Aviso("Nao Permitido","PartNumber: "+cPartNumber+", está cadastrado como Peça Mecânica! Favor verIficar junto a Engenharia",{"OK"})
		lVal := .F.
	EndIf
Else
	Aviso("Nao Permitido","PartNumber: "+cPartNumber+", não encontrado no Cadastro de Produtos! Favor verIficar junto a Controladoria",{"OK"})
	lVal := .F.
EndIf

dbSelectArea("ZZ4")
ZZ4->(dbSetOrder(4)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_STATUS

If ZZ4->(dBSeek(xFilial("ZZ4") + cImei + "4"))
	cCalgar  := Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH, "ZZJ_CALGAR")
	cGar 	 := IIf(cCalgar == "S",ZZ4->ZZ4_GARMCL,ZZ4->ZZ4_GARANT)
Else
	Aviso("Nao Encontrado","Imei: [ "+Alltrim(cImei)+" ] não encontrado ou na fase não permitida para apontamento de peças !",{"OK"})
	lVal := .F.
EndIf

// Neste ponto, faz as validacoes!
If lVal .And. ( Alltrim(ZZJ->ZZJ_COLEST)== "A" )
	Aviso("Nao Permitido","Apontamento via Protheus não permitido, operação "+ZZ4->ZZ4_OPEBGH+" parametrizada para apontamentos somente via Coletor !",{"OK"})
	lVal := .F.
EndIf

If( lVal .And. Alltrim(ZZJ->ZZJ_COLEST) == "G" .And. Alltrim(cGar) == "S" )
	Aviso("Nao Permitido","Imei: [ "+Alltrim(cImei)+" ] em garantia da operação "+ZZ4->ZZ4_OPEBGH+", apontamento não  permitido via Protheus !",{"OK"})
	lVal := .F.
ElseIf( lVal .And. Alltrim(ZZJ->ZZJ_COLEST) == "F" .And. Alltrim(cGar) == "N" )
	Aviso("Nao Permitido","Imei: [ "+Alltrim(cImei)+" ] fora de garantia da operação "+ZZ4->ZZ4_OPEBGH+", apontamento não permitido via Protheus !",{"OK"})
	lVal := .F.
EndIf

RestArea(aAreaZZ4)
RestArea(aAreaZZJ)
RestArea(aAreaSB1)

Return(lVal)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} ValFCxAC()
Função responsável pela validação do campo Action Code de acordo com a tabela de Sintomas x Soluções

@param 
@Return lRet
@author Sérgio Seiji Naka - MF consulting
@since 07/08/2015
@version P11
/*/       
//-----------------------------------------------------------------------------
User Function ValFCxAC()
Local lRet 		:= .T.
Local lFlag		:= .F.
Local cCodSolu	:= ""
Local cCodSint	:= ""           
Local cQuery	:= "SELECT * FROM SZ8020 WHERE Z8_CLIENTE = 'E'"          
Local cAlias	:= ""

cAlias := GetArea()                                                             

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),'Z21FxA', .F., .T.)
Z21FxA->(dbGoTop())
While Z21FxA->(!eof()) .AND. !lFlag
	cCodSolu := AllTrim(Z21FxA->Z8_CODSOLU)
	cCodSint := AllTrim(Z21FxA->Z8_CODSINT)
	If cCodSolu ==  AllTrim(M->Z9_ACTION) .AND. cCodSint == AllTrim(cFaultId)  
		lFlag := .T.
	EndIf
	Z21FxA->(dbSkip())                                                              
EndDo
Z21FxA->(dbCloseArea())                                                                                                         

If !lFlag    
	apMsgStop("Fault ID não vinculado a esse Action Code, favor selecionar um Action Code equivalente à esse Fault ID"	+ Chr(13) + Chr(10) + "Consultar tabela de Sintomas x Soluções", "Action Code não vinculado ao Fault ID")
	lRet := .F.
EndIf

RestArea(cAlias)

Return lRet  

//-----------------------------------------------------------------------------
/*/{Protheus.doc} VlFCxACf()
Função responsável pela validação do campo Action Code de acordo com a tabela de Sintomas x Soluções 

@param 
@Return lRet
@author Sérgio Seiji Naka - MF consulting
@since 07/08/2015
@version P11
/*/       
//-----------------------------------------------------------------------------
User Function VlFCxACf(_nPosFaulID,_nPosAction)
Local lRet 		:= .T.
Local lFlag		:= .F.
Local cCodSolu	:= ""
Local cCodSint	:= ""           
Local cQuery	:= "SELECT * FROM SZ8020 WHERE Z8_CLIENTE = 'E'"          
Local cAlias	:= ""

cAlias := GetArea()                                                             

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),'Z21FxA', .F., .T.)
Z21FxA->(dbGoTop())
While Z21FxA->(!eof()) .AND. !lFlag
	cCodSolu := AllTrim(Z21FxA->Z8_CODSOLU)
	cCodSint := AllTrim(Z21FxA->Z8_CODSINT)      	
	For nLoop := 1 To len(aCols)   
		If cCodSolu ==  AllTrim(aCols[nLoop,_nPosAction]) .AND. cCodSint == AllTrim(aCols[nLoop,_nPosFaulID]) 
			lFlag := .T.
		EndIf
	Next 
	Z21FxA->(dbSkip())                                                              
EndDo
Z21FxA->(dbCloseArea())                                                                                                         

If !lFlag    
	apMsgStop("Fault ID não vinculado a esse Action Code, favor selecionar um Action Code equivalente à esse Fault ID"	+ Chr(13) + Chr(10) + "Consultar tabela de Sintomas x Soluções", "Action Code não vinculado ao Fault ID")
	lRet := .F.
EndIf

RestArea(cAlias)

Return lRet  

//-----------------------------------------------------------------------------
/*/{Protheus.doc} ValSwap(_nPosFaulID,_nPosAction)
Função responsável pela validação do fluxo de swap de acordo com o fluxograma da especificação

@param 
@Return lRet
@author Sérgio Seiji Naka - MF consulting
@since 07/08/2015
@version P11
/*/       
//-----------------------------------------------------------------------------
User Function ValSwap(_nPosFaulID,_nPosAction)   
Local lRet 		:= .T.
Local nLoop		:= 0  


For nLoop := 1 To len(aCols)
	If AllTrim(aCols[nLoop,_nPosAction]) == 'AC08' .AND. AllTrim(aCols[nLoop,_nPosFaulID]) == '0109' 	//Validação do Scrap 
   		If nLoop == len(aCols) 		//Eliminando o preenchimento de somente um campo
			apMsgStop("Fault Code 0109 + Action Code AC08, somente e deve estar vinculado com o Fault Code 0112 e Action Code AC11 ou Fault Code 0109 e Action Code AC36"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.  		
   		ElseIf nLoop+2 == len(aCols) //Eliminando o preenchimento do terceiro campo
			apMsgStop("Fault Code 0109 + Action Code AC08, somente e deve estar vinculado com o Fault Code 0112 e Action Code AC11 ou Fault Code 0109 e Action Code AC36"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.  		
   		ElseIf AllTrim(aCols[nLoop+1][_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0112' .OR. AllTrim(aCols[nLoop+1][_nPosAction]) == 'AC36' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0109'
			lRet := .T.
			nLoop := len(aCols)
		Else
			apMsgStop("Fault Code 0109 + Action Code AC08, somente pode estar vinculado com o Fault Code 0112 e Action Code AC11 ou Fault Code 0109 e Action Code AC36"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf		
	ElseIf AllTrim(aCols[nLoop,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop,_nPosFaulID]) == '0110'	//Validação de Falta de peças
		//De acordo com o fluxograma o Action Code e Fault Code acima não pode ter nenhum outro código vinculado
		If nLoop != len(aCols)
			apMsgStop("Fault Code 0110 + Action Code AC11, não pode estar vinculado com nenhum outro código"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf
	ElseIf AllTrim(aCols[nLoop,_nPosAction]) == 'AC25' .AND. AllTrim(aCols[nLoop][_nPosFaulID]) == '0102'	//Validação aprovado oxidação
		//De acordo com o fluxograma o Action Code e Fault Code acima não pode ter nenhum outro código vinculado
		If nLoop != len(aCols)
			apMsgStop("Fault Code 0102 + Action Code AC25, não pode estar vinculado com nenhum outro código"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf
	ElseIf AllTrim(aCols[nLoop,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop][_nPosFaulID]) == '0102'
		If nLoop == len(aCols) .OR. nLoop+1 == len(aCols) .OR. nLoop+3 == len(aCols)		//Eliminando o preenchimento de um so campo campo
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F. 
			nLoop == len(aCols)
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC23' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0102'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC41' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0113'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := len(aCols)
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC41' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0113'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC23' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0102'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := nContSxF
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		Else
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf
	ElseIf AllTrim(aCols[nLoop,_nPosAction]) == 'AC23' .AND. AllTrim(aCols[nLoop][_nPosFaulID]) == '0102'
		If nLoop == len(aCols) .OR. nLoop+1 == len(aCols) .OR. nLoop+3 == len(aCols)		//Eliminando o preenchimento de um so campo campo
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop == len(aCols)
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0102'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC41' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0113'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := len(aCols)
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC41' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0113'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0102'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := len(aCols)
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		Else
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf
	ElseIf AllTrim(aCols[nLoop,_nPosAction]) == 'AC41' .AND. AllTrim(aCols[nLoop][_nPosFaulID]) == '0113'
		If nLoop == len(aCols) .OR. nLoop+1 == len(aCols) .OR. nLoop+3 == len(aCols)		//Eliminando o preenchimento de um so campo campo
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop == len(aCols)
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0102'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC23' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0102'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := len(aCols)
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		ElseIf AllTrim(aCols[nLoop+1,_nPosAction]) == 'AC23' .AND. AllTrim(aCols[nLoop+1][_nPosFaulID]) == '0102'
			If AllTrim(aCols[nLoop+2,_nPosAction]) == 'AC11' .AND. AllTrim(aCols[nLoop+2][_nPosFaulID]) == '0102'	//Validação reprovado oxidação
				lRet := .T.
				nLoop := len(aCols)
			Else
				apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
				lRet := .F.
				nLoop := len(aCols)
			EndIf
		Else
			apMsgStop("Fault Code 0102 + Action Code AC11 deve estar vinculado somente com o Fault Code 0102 + Action Code AC23 e Fault Code 0113 + Action Code AC41"	+ Chr(13) + Chr(10) + "Favor inserir os códigos corretamente", "Fault Code ou Action Code não vinculado")
			lRet := .F.
			nLoop := len(aCols)
		EndIf
	EndIf
Next 
     

Return lRet