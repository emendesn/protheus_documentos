#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT241SE  ºAutor  ³Edson Estevam       º Data ³  01/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Na Emissão do Movimento Interno para o WMS gravar no Acols  º±±
±±º          ³D3_SERVIC o conteudo do parametro MV_XSERWMS e alterar o    º±±
±±º          ³D3_LOCAL conforme conteudo informado no cadastro de produtosº±±
±±º			 ³para os Produtos Acabados					        		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH 														  º±±
±±ºSolicitante : Fernando Peratello                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT241SE()

Local _aArea 	  := GetArea()
Local _aAreaB1    := SB1->(GetArea())
Local _nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"} )
Local _nPosLocal  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_LOCAL"})
Local _nPosxGrMovi:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_XGRMOVI"} )
Local _nPosServi  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_SERVIC"})
Local _nPosQtd    := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_QUANT"})
Local _cSerparam  := Getmv("MV_XSERWMS")
Local _cTmovi     := Getmv("MV_XTPMOV")
Local _cProduto   := Alltrim(CPRODEST)
Local lRet        := .T.
Local _nQtdzero   := 0
Local oDlg
Local _lVldSal    := GetMv("BH_VALSAL",.F.,.T.)  // Abate do Saldo Disponivel a Qtde em Buffer e nas O.S`s WMS em Aberto
Local _cLocBuff   := GetMv("MV_LOCBUF",.F.,"BUFFER")
Local _lErro      := .F.

u_GerA0003(ProcName())

Private cGrupo      := Criavar("D3_XGRMOVI",.F.)


If ApMsgYesNo('Deseja informar o Grupo para esse movimento?','Grupo')
	DEFINE MSDIALOG oDlg FROM  140,000 TO 300,400 TITLE "Informe o Grupo" PIXEL
	@ 10,15 TO 63,185 LABEL Alltrim(RetTitle("D3_XGRMOVI")) OF oDlg PIXEL	
	@ 35,20 MSGET cGrupo F3 "SBM" Picture PesqPict("SD3","D3_XGRMOVI") Valid (NaoVazio() .And. ExistCpo("SBM",cGrupo)) SIZE 70,9 OF oDlg PIXEL
	DEFINE SBUTTON FROM 67,131 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED 
Endif

If Alltrim(CTM) == Alltrim(_cTmovi)
	
	If Alltrim(cEmpAnt) == "02" // Se for Matriz
			
		For _nElem := 1 to Len(acols)
			If  aCols[_nElem][_nPosQtd] > 0
				aCols[_nElem][_nPosServi] := Alltrim(_cSerparam)
				If !empty(cGrupo)
					aCols[_nElem][_nPosxGrMovi] := Alltrim(cGrupo)				
				Endif
			Else
				aCols[_nElem][len(aHeader)+1] := .T.
			Endif
			
		Next _nElem
	Endif
	
	
	DbSelectArea("SB1")
	Dbsetorder (1)
	DbSeek(xFilial("SB1")+_cProduto)
   	If !EMPTY(SB1->B1_XARMWMS) // Verifica se existe conteudo no campo criado no cadastro de Produtos (B1_XARMWMS)
		
		For _nElem := 1 to Len(acols)
		
			If  aCols[_nElem][_nPosQtd] > 0
				aCols[_nElem][_nPosLocal] := SB1->B1_XARMWMS
				aCols[_nElem][_nPosServi] := Alltrim(_cSerparam)
				If !empty(cGrupo)
					aCols[_nElem][_nPosxGrMovi] := Alltrim(cGrupo)				
				Endif
			Else
				aCols[_nElem][len(aHeader)+1] := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se o item tem saldo disponivel em estoque³
			//³ D.FERNANDES - 09/10/2013 - GLPI - 15737		   ³			
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _lVldSal
				If Upper(FunName()) == "MATA241"
					_nPosCod := ASCAN(aheader,{|x| Upper(Alltrim(x[2])) == "D3_COD" })
					_nPosLoc := ASCAN(aheader,{|x| Upper(Alltrim(x[2])) == "D3_LOCAL" })
					_cCodPro := Acols[_nElem,_nPosCod]
					_cLocPro := Acols[_nElem,_nPosLoc]
					_cTM 	 := CTM
				Endif

				If Alltrim(_cTM) > "500"

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Não considera saldo da qualidade - D.FERNANDES - 09/12/13³
					//³GLPI - 16539                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_cEndQua  := PADR("QUALIDADE",TamSx3("BF_LOCALIZ")[1])

					_cLocBuff := _cLocBuff+Space(15-Len(_cLocBuff))
					DbSelectArea("SB2")
					DbSetOrder(1)
				 	If DbSeek(xFilial("SB2")+_cCodPro+_cLocPro,.F.)

					 	_nSalQual := SaldoSBF(_cLocPro, _cEndQua, _cCodPro, NIL, NIL, NIL, .F.)

						_nSalSB2 := SB2->(B2_QATU-B2_QACLASS)
						_nSalBuff :=  SaldoSBF(_cLocPro, _cLOcBuff, _cCodPro, NIL, NIL, NIL, .F.)
						_nSalDCF  :=  U_SALDCF(_cCodPro,_cLocPro)
						_nSalDisp := _nSalSB2 - _nSalBuff - _nSalDCF - _nSalQual
						_nQtdDig  := aCols[_nElem][_nPosQtd]

						If _nQtdDig > _nSalDisp

							AutoGRLog("===================================================================================" )
							AutoGRLog("PRODUTO SEM SALDO EM ESTOQUE ->  " + _cCodPro +"-"+_cLocPro )
							AutoGRLog("SALDO BUFFER    -> "+Alltrim(STR(Round(_nSalBuff,2))))
							AutoGRLog("SALDO WMS (O.S.)-> "+Alltrim(STR(Round(_nSalDCF,2))))
							AutoGRLog("SALDO QUALIDADE -> "+Alltrim(STR(Round(_nSalQual,2))))
							AutoGRLog("SALDO DISPONIVEL-> "+Alltrim(STR(Round(_nSalDisp,2))))
							AutoGRLog("===================================================================================" )						

							_lErro  := .T.
							aCols[_nElem][_nPosQtd] := 0
							aCols[_nElem][len(aHeader)+1] := .T.
							
						Endif
					EndIf
				Endif
			Endif
			
		Next _nElem
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se o item tem saldo disponivel em estoque³
		//³ D.FERNANDES - 09/10/2013 - GLPI - 15737		   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If _lErro 
			MostraErro()
		EndIf			
		
   	Endif
	
Endif

RestArea(_aAreaB1)
RestArea(_aArea)

Return(lRet)