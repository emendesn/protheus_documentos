#INCLUDE "RWMAKE.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  25/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inicializador padrao de diversos campos do Pedido de Compraº±±
±±º          ³ para alimentar os campos a partir do 2o item com o valor doº±±
±±º          ³ 1o item.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT100LOK()
Local _lRet			:= .T.
Local _nPosTES		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_TES"   })
Local _nPosLoc		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_LOCAL" })
Local _nPosDtD		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DTDOCA"})
Local _nPosHrD		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_HRDOCA"})
Local _nPosProd		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD"   })
Local _nPosCC		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_CC"    })
Local _nPosRate		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_RATEIO"})
Local _nPosItem		:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEM"  })
Local _nPosAcess	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_XACESS"})
Local _nPosdivne	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DIVNEG"})
Local _nPospcomp	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PEDIDO"})
Local _nPositpco	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMPC"})
Local _nPosmodev	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_MOTDEVO"})
Local _nPosnfori	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_NFORI"})
Local _nPosseror	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_SERIORI"})
Local _nPositmor	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMORI"})
Local _nPositgrd	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMGRD"})
Local _nPosiqtde	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_QUANT"})
Local _nPosipicm	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PICM"})
Local _nPosiasol	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ALIQSOL"})
Local _nposadica	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ADICAO"})
Local _nposserad	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_SEQ_ADI"})
Local _nposnumse	:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_NUMSER"})
Local lUsrSemPC  	:= .F. 
Local _ctipo		:= ctipo
Local _cespecie		:= cespecie
Local _dEmissao		:= ddemissao
Local _cdivneg		:= ""
Local _ctescons		:= GetMV("MV_TESCONS")
Local _cARMRPG		:= GetMV("MV_XARMRPG")
Local _cctcontb		:= ""
Local _cuforig		:= ""
//Local _nposxoper:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_XOPEBGH"})
Private lUsrAut  	:= .F. 
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID)) 
u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Usuarios de Autorizado a entrar com NF-Compras.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#EXPLIDER#NFERETROAT"
		lUsrAut		:= .T.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Usuarios autorizados a entrar com NF sem PV.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#PCSEMAPROVA"
		lUsrSemPC	:= .T.
	EndIf
Next i
If Inclui .AND. !aCols[n,Len(aHeader)+1]
	If n <> 1
		If Empty(aCols[n,_nPosTES])
			aCols[n,_nPosTES] := aCols[1,_nPosTES]
			MaAvalTES("E",aCols[n,_nPosTES])
			MaFisRef("IT_TES","MT100",aCols[n,_nPosTES])
		EndIf
		If Empty(aCols[n,_nPosLoc])
			aCols[n,_nPosLoc] := aCols[1,_nPosLoc]
		EndIf
		If Empty(aCols[n,_nPosDtD])
			aCols[n,_nPosDtD] := aCols[1,_nPosDtD]
		EndIf
		If Empty(aCols[n,_nPosHrD])
			aCols[n,_nPosHrD] := aCols[1,_nPosHrD]
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se foi digitado acessorio pra cada item da NFE                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[n,Len(aHeader)+1]
		_lRet := u_valAcess()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida armazem digitado para operacoes que envolvem entrada massiva  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[n,Len(aHeader)+1]
		//_lRet := u_valarmem(cnfiscal,cserie,cA100For,cloja,aCols[n,_nPosProd],aCols[n,_nPosLoc],aCols[n,_nposnumse],aCols[n,_nposxoper])
		_lRet := u_valarmem(cnfiscal,cserie,cA100For,cloja,aCols[n,_nPosProd],aCols[n,_nPosLoc],aCols[n,_nposnumse],'')
	EndIf
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama tela de cadastro, tabela ZZL e grava a OS Nextel pra cada      |
	//|item da NFE.                                                         |
	//³Nesse momento, grava o campo status com valor 0=zero - Nao confirmado|
	//|Edson Rodrigues - 23/06/10                                           |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[n,Len(aHeader)+1] .AND. aCols[n,_nPosLoc] $ alltrim(_cARMRPG) .AND. cA100For <> "Z00403"
		_lRet :=U_CADOSPRG(cnfiscal,cserie,cA100For,cloja,cformul,aCols[n,_nPosItem],aCols[n,_nPositgrd],aCols[n,_nPosProd],ddemissao,ddatabase,aCols[n,_nPosiqtde],'0')
	EndIf
//	_lret  := IIF( FINDFunction('U_XVALCFOP'),U_XVALCFOP(aCols[n,_nPosTES],aCols[n,_nPosLoc]),.T.)//CLAUDIA, VALIDAR AMARRACAO DE CFOP X ARMAZEM        	                                                              
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida motivo de Devolucao quando for Devolucao                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(_ctipo) .AND. !Empty(aCols[n,_nPosmodev])
		If _ctipo=="D" .AND. aCols[n,_nPosmodev]=="00"
			apMsgStop("Caro usuário, por favor informe o Motivo de Devolução válido para o item " + aCols[n,_nPosItem], "Motivo de Devolução Invalido" )
			_lRet := .F.
		EndIf
		// busca centro de custo e divisão de negócio na nota de origem  -  Edson Rodrigues
		//Local _nPosnfori:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_NFORI"})
		//Local _nPosseror:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_SERIORI"})
		//Local _nPositmor:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMORI"})
		// u_GrvNatSE1(_nPosnfori,_nPosseror,"",SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD,SD1->D1_TES,SD1->D1_NFORI,SD1->D1_SERIORI,_nRecno)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida preenchimento da data de emissao menor que 180dias e maior que 01 dia³
	//³Alteração Paulo Francisco 14/06/10                                          ³
	//³Alterado - Edson Rodrigues - 13/10/10                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lUsrAut
		If  _dEmissao < DdataBase - 180
			MsgAlert("Caro usuário, data de emissao da NFE é maior que 180 dias. Digite uma data correta ou entre em contato com o administrado do Sistema !")
			//Return()
			_lRet := .F.
		ElseIf  _dEmissao > DdataBase + 1
			MsgAlert("Caro usuário, data de emissao da NFE é maior a data Atual. Digite uma data correta ou entre em contato com o administrado do Sistema !")
			//Return() Alterado - Edson Rodrigues - 13/10/10
			_lRet := .F.
		EndIf
	EndIf
	_cuforig  := Posicione("SA2",1,xFilial("SA2") + CA100FOR + CLOJA, "A2_TIPO")
	If Alltrim(_cespecie) == "SPED" .AND. AllTrim(_cuforig) == "X" .AND. Len(AllTrim(aCols[n,_nposadica])) <= 0
		aCols[n,_nposadica] := "100"
		_citem  := Transform(Substr(aCols[n,_nPosItem],2,3), "@E 999")
		_citem1 := Transform(Substr(aCols[n,_nPosItem],3,2), "@E 99" )
		If _citem < '100'
			_nitem := "1"
		Else
			_nitem := "2"
		EndIf
		aCols[n,_nposserad] := _nitem  + _citem1
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida preenchimento da data de emissao menor que 180dias e maior que 01 dia  ³
	//³Alteração Paulo Francisco 14/06/10                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (aCols[n,_nPosLoc] == "99") .AND. (aCols[n,_nPosipicm]) <> (aCols[n,_nPosiasol]) .AND. (aCols[n,_nPosTES] $ "318/310")
		MsgAlert("Favor atualizar o campo Aliq. ICMS So !")
		_lRet := .F.
	EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Valida preenchimento do Pedido de Compras sempre que o TES gerar duplicata    ³
    //³Alterado para acessórios entrarem sem PC      GLPI 20776                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _cTipo == "N" .AND. SF4->F4_DUPLIC == "S" .AND. !Alltrim(_cespecie) $ "CTR/NFCEE/NFST/NTSC/NTST/CTE" .AND. Empty(aCols[n,_nPospcomp])
		If !Excecao(aCols[n,_nPosProd], aCols[n,_nPosLoc], lUsrSemPC)
			apMsgStop("Caro usuário, este TES gera duplicata e portanto o Pedido de Compras é obrigatório (Exceção não atendida)! Favor selecioná-lo.")
			_lRet := .F.
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida e preenche a  Divisão de Negocio quando for PC                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aCols[n,_nPospcomp]) .AND. !Empty(aCols[n,_nPositpco])
		_lRet := valdiv()
		If _lRet
			Do Case
				Case (aCols[n,_nPosLoc] $ "80/81" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="Z-") .AND. aCols[n,_nPosdivne]<>"06"
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('A')", "Div. Negócio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] $ "83/84" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="B-") .AND. ( aCols[n,_nPosdivne]<>"05" .AND. aCols[n,_nPosdivne]<>"15" .AND. aCols[n,_nPosdivne]<>"13" )
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('B')", "Div. Negócio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] == "87" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="S-") .AND. aCols[n,_nPosdivne]<>"07"
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('C')", "Div. Negócio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] $ "01/1A/1B/" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"04"
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('D')", "Div. Negócio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] = "21" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"03"
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('E')", "Div. Negócio errada")
					_lRet := .F.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Nao validar divisao de negocio quando for pedido de      ³
					//³compra - pois ja foi validado ao fazer o pedido de compra³
					//³-  Edson Rodrigues - 01/04/09                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
				Case (aCols[n,_nPosLoc] == "51" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"09"
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem], "Div. Negócio errada")
					_lRet := .F.
*/
				Case (aCols[n,_nPosLoc] $ "70/71/72/73" .AND.  aCols[n,_nPosdivne]<>"14")
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('F')", "Div. Negócio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] == "92" .AND.  aCols[n,_nPosdivne]<>"15" )
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('G')", "Div. Negócio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] $ "30/31" .AND.  aCols[n,_nPosdivne]<>"16" )
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('H')", "Div. Negócio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] == "75" .AND.  aCols[n,_nPosdivne]<>"17" )
					apMsgStop("Caro usuário, por favor informe a Divisão de negócio correta para o item " + aCols[n,_nPosItem] + "('I')", "Div. Negócio errada")
					_lret := .F.
			EndCase
		EndIf
	EndIf
EndIf
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Para Aceitar o Centro de Custo digitado qdo for especie³
//³CTR / NTST - Edson Rodrigues - 26/02/09 / 03/04/09     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Alltrim(_cespecie) $ "CTR/NTST"
	aCols[n,_nPosCC] := Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_CC")
EndIf
*/
If Empty(aCols[n,_nPosCC]) .AND. aCols[n,_nPosRate] == "2"
	apMsgStop("Caro usuário, por favor informe o centro de custo do item " + aCols[n,_nPosItem], "Centro de Custo não preenchido")
	_lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se tem Item contabil cadastrado no cadastro de³
//³produtos quando o Tes for de Consumo. Edson Rodrigues  ³
//³- 23/12/08                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cctcontb:=Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_CONTA")
If aCols[n,_nPosTES] $ _ctescons .AND. Empty(_cctcontb)
	apMsgStop("Caro usuário,Essa Tes exige o preenchimento da Conta Contabil do item " + aCols[n,_nPosItem] + " no Cadastro de Produtos ", "Conta Contabil não preenchido")
	_lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Solicitação Luiz Reis GLPI 20531                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lRet
	cLocaliz :=Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_LOCALIZ")
	If cLocaliz == "S" .and. Alltrim(aCols[n,_nPosLoc]) $ "10/11"//ACESSORIOS
		If (CA100FOR == "000016" .and. CLOJA == "01") .and. Alltrim(aCols[n,_nPosLoc]) <> "10"
			apMsgStop("Armazem informado divergente para o fornecedor "+CA100FOR+"/"+CLOJA+". Favor verificar!", "Armazem Divergente")
			_lRet := .f.
		ElseIf (CA100FOR == "000680" .and. CLOJA == "01") .and. Alltrim(aCols[n,_nPosLoc]) <> "11"
			apMsgStop("Armazem informado divergente para o fornecedor "+CA100FOR+"/"+CLOJA+". Favor verificar!", "Armazem Divergente")
			_lRet := .f.
		Endif
	Endif
Endif

Return(_lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Microsiga           º Data ³  08/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function valdiv()
Local _lRet     := .T.
Local _nPosProd := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD"})
Local _nPospcomp:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PEDIDO"})
Local _nPositpco:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMPC"})
Local _nPosdivne:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DIVNEG"})
Local _nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEM"  })
Local _aAreaSC7 := SC7->(GetArea())
Local _cdivsc7 := ""
_cdivsc7 := Posicione("SC7",4,xFilial("SC7") + aCols[n,_nPosProd]+aCols[n,_nPospcomp]+aCols[n,_nPositpco], "C7_DIVNEG")
If Empty(aCols[n,_nPosdivne]) .AND. Empty(_cdivsc7)
	apMsgStop("Caro usuário, por favor informe a Divisão de negocio do item " + aCols[n,_nPosItem], "Div. Negocio nao Preenchida no Ped. Compra")
	_lRet := .F.
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incluso para pegar a  negócio do pedido de compra. Edson Rodrigues - 31/03/09³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,_nPosdivne]:=_cdivsc7
EndIf
RestArea(_aAreaSC7)
Return(_lRet)
/*                                                              
ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR +ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO
SF4->(dbSetOrder(1)) // F4_FILIAL + F4_CODIGO
SZA->(dbSetOrder(1)) // ZA_FILIAL + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_SERIE + ZA_IMEI
SA1->(dbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA

// Permite execucao da rotina apenas quando posicionado nos itens da NFE
If !Empty(__ReadVar)
	MsgAlert('Clique nos itens da Nota Fiscal antes de chamar a Entrada Massiva','itens'	)
	Return
EndIf

// Bloqueia chamada do botao se o tipo da NFE for diferente de Beneficiamento
If cTipo <> 'B'
	MsgAlert('A Entrada Massiva funciona apenas para Beneficiamento','Beneficiamento')
	Return
EndIf
*/
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³valarmem  ºAutor  ³Edson Rodrigues     º Data ³  29/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida Armazem digitado para operacoes de Entrada Massiva   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function valarmem(cnfiscal,cserie,Ccodcli,cloja,ccodprod,carmazem,cimei,copebgh)
Local _lRet     := .T.                                                    
Local _aAreaZZ4 := ZZ4->(GetArea()) 
Local carment   := SPACE(2)   
Local cOpe      := space(3)
dbSelectArea("ZZ4")
ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR +ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
If !Empty(cimei) .AND. ZZ4->(dbSeek(xFilial('ZZ4') + cnfiscal + cserie + Ccodcli + cLoja + ccodprod + cimei)) .AND. ZZ4->ZZ4_STATUS == "2" .AND. !Empty(ZZ4->ZZ4_OPEBGH)
	cOpe     := ZZ4->ZZ4_OPEBGH
	carment 	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_ARMENT")
	If !Empty(carmazem) .AND. !alltrim(carmazem) $  alltrim(carment)
		MsgAlert("Nao tem esse armazem "+carmazem+" cadastrado no cadastro de operacoes ZZJ para operacao: "+cOpe+". Favor cadastrar!","Armazem de Entrada Massiva Invalido")
		_lRet:=.F.
	ElseIf Empty(carmazem)
		MsgAlert("Armazem nao preenchido. Favor preencher o armazem!","Armazem de Entrada Massiva Invalido")
		_lRet:=.F.
	EndIf
ElseIf !Empty(copebgh)
	cOpe     := copebgh
	carment 	:= POSICIONE("ZZJ",1,xFilial("ZZJ") + cOpe,"ZZJ_ARMENT")
	If !Empty(carmazem) .AND. !alltrim(carmazem) $  alltrim(carment)
		MsgAlert("Nao tem esse armazem "+carmazem+" cadastrado no cadastro de operacoes ZZJ para operacao: "+cOpe+". Favor cadastrar!","Armazem de Entrada Massiva Invalido")
		_lRet:=.F.
	ElseIf Empty(carmazem)
		MsgAlert("Armazem nao preenchido. Favor preencher o armazem!","Armazem de Entrada Massiva Invalido")
		_lRet:=.F.
	EndIf
EndIf
RestArea(_aAreaZZ4)
Return(_lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Hudson de Souza Santos  ºData ³ 02/12/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica exceção para entrada de NF sem PC                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Excecao(cProduto, cArmazem, lGrpUser)
Local lRet := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica excecao da regra para permitidos incluir NF sem Pedido.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrpUser .AND. Left(cProduto,1) == "1" .AND. cArmazem == "20"
	lRet := .T.
EndIf
If cArmazem=="AO"
	lRet := .T.
Endif

Return(lRet)