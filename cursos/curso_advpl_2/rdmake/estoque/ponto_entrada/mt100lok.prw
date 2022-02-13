#INCLUDE "RWMAKE.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  � M.Munhoz - ERPPLUS � Data �  25/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializador padrao de diversos campos do Pedido de Compra���
���          � para alimentar os campos a partir do 2o item com o valor do���
���          � 1o item.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	//�����������������������������������������������Ŀ
	//�Usuarios de Autorizado a entrar com NF-Compras.�
	//�������������������������������������������������
	If Upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#EXPLIDER#NFERETROAT"
		lUsrAut		:= .T.
	EndIf
	//��������������������������������������������Ŀ
	//�Usuarios autorizados a entrar com NF sem PV.�
	//����������������������������������������������
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
	//���������������������������������������������������������������������Ŀ
	//�Valida se foi digitado acessorio pra cada item da NFE                �
	//�����������������������������������������������������������������������
	If !aCols[n,Len(aHeader)+1]
		_lRet := u_valAcess()
	EndIf
	//���������������������������������������������������������������������Ŀ
	//�Valida armazem digitado para operacoes que envolvem entrada massiva  �
	//�����������������������������������������������������������������������
	If !aCols[n,Len(aHeader)+1]
		//_lRet := u_valarmem(cnfiscal,cserie,cA100For,cloja,aCols[n,_nPosProd],aCols[n,_nPosLoc],aCols[n,_nposnumse],aCols[n,_nposxoper])
		_lRet := u_valarmem(cnfiscal,cserie,cA100For,cloja,aCols[n,_nPosProd],aCols[n,_nPosLoc],aCols[n,_nposnumse],'')
	EndIf
 	//���������������������������������������������������������������������Ŀ
	//�Chama tela de cadastro, tabela ZZL e grava a OS Nextel pra cada      |
	//|item da NFE.                                                         |
	//�Nesse momento, grava o campo status com valor 0=zero - Nao confirmado|
	//|Edson Rodrigues - 23/06/10                                           |
	//�����������������������������������������������������������������������
	If !aCols[n,Len(aHeader)+1] .AND. aCols[n,_nPosLoc] $ alltrim(_cARMRPG) .AND. cA100For <> "Z00403"
		_lRet :=U_CADOSPRG(cnfiscal,cserie,cA100For,cloja,cformul,aCols[n,_nPosItem],aCols[n,_nPositgrd],aCols[n,_nPosProd],ddemissao,ddatabase,aCols[n,_nPosiqtde],'0')
	EndIf
//	_lret  := IIF( FINDFunction('U_XVALCFOP'),U_XVALCFOP(aCols[n,_nPosTES],aCols[n,_nPosLoc]),.T.)//CLAUDIA, VALIDAR AMARRACAO DE CFOP X ARMAZEM        	                                                              
	//���������������������������������������������������������������������Ŀ
	//�Valida motivo de Devolucao quando for Devolucao                      �
	//�����������������������������������������������������������������������
	If !Empty(_ctipo) .AND. !Empty(aCols[n,_nPosmodev])
		If _ctipo=="D" .AND. aCols[n,_nPosmodev]=="00"
			apMsgStop("Caro usu�rio, por favor informe o Motivo de Devolu��o v�lido para o item " + aCols[n,_nPosItem], "Motivo de Devolu��o Invalido" )
			_lRet := .F.
		EndIf
		// busca centro de custo e divis�o de neg�cio na nota de origem  -  Edson Rodrigues
		//Local _nPosnfori:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_NFORI"})
		//Local _nPosseror:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_SERIORI"})
		//Local _nPositmor:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_ITEMORI"})
		// u_GrvNatSE1(_nPosnfori,_nPosseror,"",SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD,SD1->D1_TES,SD1->D1_NFORI,SD1->D1_SERIORI,_nRecno)
	EndIf
	//����������������������������������������������������������������������������Ŀ
	//�Valida preenchimento da data de emissao menor que 180dias e maior que 01 dia�
	//�Altera��o Paulo Francisco 14/06/10                                          �
	//�Alterado - Edson Rodrigues - 13/10/10                                       �
	//������������������������������������������������������������������������������
	If !lUsrAut
		If  _dEmissao < DdataBase - 180
			MsgAlert("Caro usu�rio, data de emissao da NFE � maior que 180 dias. Digite uma data correta ou entre em contato com o administrado do Sistema !")
			//Return()
			_lRet := .F.
		ElseIf  _dEmissao > DdataBase + 1
			MsgAlert("Caro usu�rio, data de emissao da NFE � maior a data Atual. Digite uma data correta ou entre em contato com o administrado do Sistema !")
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
	//������������������������������������������������������������������������������Ŀ
	//�Valida preenchimento da data de emissao menor que 180dias e maior que 01 dia  �
	//�Altera��o Paulo Francisco 14/06/10                                            �
	//��������������������������������������������������������������������������������
	If (aCols[n,_nPosLoc] == "99") .AND. (aCols[n,_nPosipicm]) <> (aCols[n,_nPosiasol]) .AND. (aCols[n,_nPosTES] $ "318/310")
		MsgAlert("Favor atualizar o campo Aliq. ICMS So !")
		_lRet := .F.
	EndIf
    //������������������������������������������������������������������������������Ŀ
    //�Valida preenchimento do Pedido de Compras sempre que o TES gerar duplicata    �
    //�Alterado para acess�rios entrarem sem PC      GLPI 20776                      �
    //��������������������������������������������������������������������������������
	If _cTipo == "N" .AND. SF4->F4_DUPLIC == "S" .AND. !Alltrim(_cespecie) $ "CTR/NFCEE/NFST/NTSC/NTST/CTE" .AND. Empty(aCols[n,_nPospcomp])
		If !Excecao(aCols[n,_nPosProd], aCols[n,_nPosLoc], lUsrSemPC)
			apMsgStop("Caro usu�rio, este TES gera duplicata e portanto o Pedido de Compras � obrigat�rio (Exce��o n�o atendida)! Favor selecion�-lo.")
			_lRet := .F.
		EndIf
	EndIf
	//���������������������������������������������������������������������Ŀ
	//�Valida e preenche a  Divis�o de Negocio quando for PC                �
	//�����������������������������������������������������������������������
	If !Empty(aCols[n,_nPospcomp]) .AND. !Empty(aCols[n,_nPositpco])
		_lRet := valdiv()
		If _lRet
			Do Case
				Case (aCols[n,_nPosLoc] $ "80/81" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="Z-") .AND. aCols[n,_nPosdivne]<>"06"
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('A')", "Div. Neg�cio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] $ "83/84" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="B-") .AND. ( aCols[n,_nPosdivne]<>"05" .AND. aCols[n,_nPosdivne]<>"15" .AND. aCols[n,_nPosdivne]<>"13" )
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('B')", "Div. Neg�cio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] == "87" .AND. SubSTR(aCols[n,_nPosProd],1,2)=="S-") .AND. aCols[n,_nPosdivne]<>"07"
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('C')", "Div. Neg�cio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] $ "01/1A/1B/" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"04"
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('D')", "Div. Neg�cio errada")
					_lRet := .F.
				Case (aCols[n,_nPosLoc] = "21" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"03"
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('E')", "Div. Neg�cio errada")
					_lRet := .F.
					//���������������������������������������������������������Ŀ
					//�Nao validar divisao de negocio quando for pedido de      �
					//�compra - pois ja foi validado ao fazer o pedido de compra�
					//�-  Edson Rodrigues - 01/04/09                            �
					//�����������������������������������������������������������
/*
				Case (aCols[n,_nPosLoc] == "51" .AND. !SubSTR(aCols[n,_nPosProd],1,2) $ "S-/Z-/B-") .AND. aCols[n,_nPosdivne]<>"09"
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem], "Div. Neg�cio errada")
					_lRet := .F.
*/
				Case (aCols[n,_nPosLoc] $ "70/71/72/73" .AND.  aCols[n,_nPosdivne]<>"14")
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('F')", "Div. Neg�cio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] == "92" .AND.  aCols[n,_nPosdivne]<>"15" )
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('G')", "Div. Neg�cio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] $ "30/31" .AND.  aCols[n,_nPosdivne]<>"16" )
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('H')", "Div. Neg�cio errada")
					_lret := .F.
				Case (aCols[n,_nPosLoc] == "75" .AND.  aCols[n,_nPosdivne]<>"17" )
					apMsgStop("Caro usu�rio, por favor informe a Divis�o de neg�cio correta para o item " + aCols[n,_nPosItem] + "('I')", "Div. Neg�cio errada")
					_lret := .F.
			EndCase
		EndIf
	EndIf
EndIf
/*
//�������������������������������������������������������Ŀ
//�Para Aceitar o Centro de Custo digitado qdo for especie�
//�CTR / NTST - Edson Rodrigues - 26/02/09 / 03/04/09     �
//���������������������������������������������������������
If !Alltrim(_cespecie) $ "CTR/NTST"
	aCols[n,_nPosCC] := Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_CC")
EndIf
*/
If Empty(aCols[n,_nPosCC]) .AND. aCols[n,_nPosRate] == "2"
	apMsgStop("Caro usu�rio, por favor informe o centro de custo do item " + aCols[n,_nPosItem], "Centro de Custo n�o preenchido")
	_lRet := .F.
EndIf
//�������������������������������������������������������Ŀ
//�Verifica se tem Item contabil cadastrado no cadastro de�
//�produtos quando o Tes for de Consumo. Edson Rodrigues  �
//�- 23/12/08                                             �
//���������������������������������������������������������
_cctcontb:=Posicione("SB1",1,xFilial("SB1") + aCols[n,_nPosProd], "B1_CONTA")
If aCols[n,_nPosTES] $ _ctescons .AND. Empty(_cctcontb)
	apMsgStop("Caro usu�rio,Essa Tes exige o preenchimento da Conta Contabil do item " + aCols[n,_nPosItem] + " no Cadastro de Produtos ", "Conta Contabil n�o preenchido")
	_lRet := .F.
EndIf
//�������������������������������������������������������Ŀ
//�Solicita��o Luiz Reis GLPI 20531                       �
//���������������������������������������������������������
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
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  �Microsiga           � Data �  08/25/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
	apMsgStop("Caro usu�rio, por favor informe a Divis�o de negocio do item " + aCols[n,_nPosItem], "Div. Negocio nao Preenchida no Ped. Compra")
	_lRet := .F.
Else
	//�����������������������������������������������������������������������������Ŀ
	//�Incluso para pegar a  neg�cio do pedido de compra. Edson Rodrigues - 31/03/09�
	//�������������������������������������������������������������������������������
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
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �valarmem  �Autor  �Edson Rodrigues     � Data �  29/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida Armazem digitado para operacoes de Entrada Massiva   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  �Hudson de Souza Santos  �Data � 02/12/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica exce��o para entrada de NF sem PC                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Excecao(cProduto, cArmazem, lGrpUser)
Local lRet := .F.
//��������������������������������������������������������������������Ŀ
//�Verifica excecao da regra para permitidos incluir NF sem Pedido.    �
//����������������������������������������������������������������������
If lGrpUser .AND. Left(cProduto,1) == "1" .AND. cArmazem == "20"
	lRet := .T.
EndIf
If cArmazem=="AO"
	lRet := .T.
Endif

Return(lRet)