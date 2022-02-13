#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A260GRV   ºAutor  ³Claudia Cabral      º Data ³  28/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. Na Transferencia Comum, para validar a quantidade do   º±±
±±º          ³estoque X quantidade do endereço. Criado para não deixar    º±±
±±º          ³fazer o processo de transferencia caso o saldo do SBF seja  º±±
±±º          ³diferente que o Saldo do SB2. Evita-se dessa maneira saldos º±±
±±º          ³negativos tanbo no SB2 como SBF.                            º±±
±±º          ³Apos confirmada a transferencia, antes de atualizar qualquerº±±
±±º          ³arquivo. Pode ser utilizado para validar o movimento ou     º±±
±±º          ³atualizar o valor de alguma das variaveis disponiveis no    º±±
±±º          ³momento.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A260Grv()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			:= GetArea()
Local aAreaSDA		:= SDA->(GetArea())
Local aAreaSB2		:= SB2->(GetArea())
Local aAreaSB8		:= SB8->(GetArea())
Local aAreaSBF		:= SBF->(GetArea())
Local lRet			:= .T.
Local lRastro		:= .F.
Local lRastro2		:= .F.
Local cCodDes		:= Iif(IsTelNet(),nil,cCodDest)
Local cLocalDes		:= Iif(IsTelNet(),nil,cLocDest)
Local cLocalizDes	:= Iif(IsTelNet(),nil,cLoclzDest)
Local cCod			:= Iif(IsTelNet(),nil,cCodOrig)
Local cLocal		:= Iif(IsTelNet(),nil,cLocOrig)
Local cLoteCtl		:= Iif(IsTelNet(),nil,cLotedigi)
Local cnumLote		:= Iif(IsTelNet(),nil,cNumLote)
Local cLocaliz		:= Iif(IsTelNet(),nil,cLoclzOrig)
Local nQuant		:= Iif(IsTelNet(),nil,nQuant260)
Local nQuantSEG		:= Iif(IsTelNet(),nil,nQuant260D)
Local nSaldoB2		:= 0
Local nSaldo		:= 0
Local nDSaldoB2		:= 0
Local nDSaldo		:= 0
Local aTravas		:= {}    
Local _cArmzPr		:= GETMV("BH_ARMZPR",.F.,"15") //Armazem de Processo
Local lPcNvRet		:= .F.
u_GerA0003(ProcName())
If IsTelNet()
	Return(.t.)
EndIf
SBF->(DbSetOrder(2))
SB8->(DbSetOrder(1))

//Valida existencia do armazem origem na transferencia
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocal,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocal)+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocal)+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
		Return(.F.)
	Endif
Endif

//Valida existencia do armazem destino na transferencia
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocalDes,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocalDes)+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocalDes)+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
		Return(.F.)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação retirada de peças do armazém RE apenas para³
//³peças recuperadas - Hudson de Souza Santos.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Alltrim(cLocOrig) == "RE" .AND. POSICIONE("SB1",1,xFilial("SB1")+cCodOrig,"B1_RETRABA") <> "S") .OR.;
   (Alltrim(cLocDest) == "RE" .AND. POSICIONE("SB1",1,xFilial("SB1")+cCodDest,"B1_RETRABA") <> "S")
	ApMsgStop("Movimentação no Armazém 'RE' exclusivo peças recuperadas","Armazém inválido")
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se Produto de Origem é igual ao Produto de Destino³ *** Paulo Francisco ***
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If cCodOrig <> cCodDest .AND. Alltrim(__cUserID) <> '000916' // Solicitado pelo Sr. Fernando Peratello somente o mesmo pode fazer essa transferecia.
	ApMsgStop("Rotina de transferência entre produtos diferentes desabilitada pelo administrador. Entre em contato com TI!","Produto inválido")
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação da data na transferencia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If DEMIS260 <> dDataBase
	ApMsgStop("Rotina de transferência entre datas diferentes desabilitada pelo administrador. Entre em contato com TI!","Data inválido")
	lRet := .F.
EndIf    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação pelo endereço pela tabela SX5.                  ³
//³O sistema deve percorrer todos os registros e validar o   ³
//³destino de acordo com a origem. Separado pelo caracter "|"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cLocOrig == cLocDest .AND. !u_KITVldEnd(cLocOrig, cLoclzOrig, cLoclzDest)
	ApMsgStop("Amarração de endereço de origemxdestino não esta cadastrada. Entre em contato com o TI","Enderço Inválido")
	lRet := .F.
EndIf
//ÚÄÄÄÄ¿
//³    ³
//ÀÄÄÄÄÙ
If Alltrim(cLocal) $ _cArmzPr .Or. Alltrim(cLocalDes) $ _cArmzPr
	If !Upper(Funname()) $ "U_APONTACD" .and. !Upper(Funname()) $ "U_AXZZ3" .AND. !IsBlind() 
		lUsrAut  	:= .F.
		aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
		For i := 1 to Len(aGrupos)
			If AllTrim(GRPRetName(aGrupos[i])) $ "MOVPROC"
				lUsrAut  := .T.
			EndIf
		Next i
		If !lUsrAut 
			If ApMsgYesNo('Usuario não autorizado para efetuar movimentação em Armazem de Processo! Possui senha de liberação?','Movimentação')
				IF !u_VldSenha()
                   	lRet := .F.
                EndIf					
			Else
				lRet := .F.
			EndIf
			If !lRet
				ApMsgStop("Usuario não informado ou não autorizado! Favor verificar com o responsavel!")
			EndIf
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os ambientes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSB2)
RestArea(aAreaSB8)
RestArea(aAreaSBF) 
RestArea(aAreaSDA)
RestArea(aArea)
Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KITVldEnd ºAutor  ³Hudson de Souza Santos º Data ³ 03/14/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KITVldEnd(cArm, cEndOri, cEndDes)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet		:= .T.
Local aArea		:= GetArea()
Local aEndDes	:= {}
Local nX		:= 0
Local cAuxDesc	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona na tabela SX5 onde esta cadastrada a³
//³amarração Endereço Origem x Endereço Destino  ³
//³Tabela: HE                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se existe cadastro de amarração.³
//³Só valida se existir o cadastro        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dbSeek(xFilial("SX5")+"HE"+cArm+"001")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso exista cadastro de amarração, o retorno inicia Falso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Percorre todo o SX5 com armazém referente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !SX5->(Eof()) .AND. SubSTR(SX5->X5_CHAVE,1,2) == cArm
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Primeiramente ajusta o final do registro na SX5.³
		//³Obrigando terminar com o caracter   /           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SubSTR(SX5-X5_DESCRI,Len(Alltrim(SX5-X5_DESCRI)),1) <> "/"
			cAuxDesc := Alltrim(SX5->X5_DESCRI) + "/"
			RecLock("SX5",.F.)
			 SX5->X5_DESCRI		:= cAuxDesc
			 SX5->X5_DESCSPA	:= cAuxDesc
			 SX5->X5_DESCENG	:= cAuxDesc
			MsUnLock()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso encontre o registro de acordo com o Endereço Origem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim(cEndOri) == SubSTR(SX5-X5_DESCRI,1,AT("|",SX5-X5_DESCRI)-1)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimenta o Array com todos destinos do cadastro³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEndDes := StrTokArr(Alltrim(SubSTR(SX5-X5_DESCRI,AT("|",SX5-X5_DESCRI)+1)),"/")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Para aceitar enderço em branco, basta no cadastro colocar³
			//³o caracter / por duas vezes seguidas   //                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AT(SubSTR(SX5-X5_DESCRI,AT("|",SX5-X5_DESCRI)+1),"//")
				aAdd(aEndDes,{""})
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Percorre o array para validar.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nX := 1 to Len(aEndDes)
				If Alltrim(cEndDes) == Alltrim(aEndDes[nX])
					lRet := .T.
					Exit
				EndIf
			Next nX
			Exit
		EndIf
		SX5->(dbSkip())
	EndDo
EndIf
RestArea(aArea)
Return(lRet)