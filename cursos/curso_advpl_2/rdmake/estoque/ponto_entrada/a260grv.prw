#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A260GRV   �Autor  �Claudia Cabral      � Data �  28/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. Na Transferencia Comum, para validar a quantidade do   ���
���          �estoque X quantidade do endere�o. Criado para n�o deixar    ���
���          �fazer o processo de transferencia caso o saldo do SBF seja  ���
���          �diferente que o Saldo do SB2. Evita-se dessa maneira saldos ���
���          �negativos tanbo no SB2 como SBF.                            ���
���          �Apos confirmada a transferencia, antes de atualizar qualquer���
���          �arquivo. Pode ser utilizado para validar o movimento ou     ���
���          �atualizar o valor de alguma das variaveis disponiveis no    ���
���          �momento.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A260Grv()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
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
	ApMsgStop("Armazem "+Alltrim(cLocal)+" n�o existente no Cadastro. Entrar em contato com a Controladoria!","Armaz�m inv�lido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocal)+" bloqueado. Entrar em contato com a Controladoria!","Armaz�m bloqueado")
		Return(.F.)
	Endif
Endif

//Valida existencia do armazem destino na transferencia
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocalDes,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocalDes)+" n�o existente no Cadastro. Entrar em contato com a Controladoria!","Armaz�m inv�lido")
	Return(.F.)
Else 
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocalDes)+" bloqueado. Entrar em contato com a Controladoria!","Armaz�m bloqueado")
		Return(.F.)
	Endif
Endif

//�����������������������������������������������������Ŀ
//�Valida��o retirada de pe�as do armaz�m RE apenas para�
//�pe�as recuperadas - Hudson de Souza Santos.          �
//�������������������������������������������������������
If (Alltrim(cLocOrig) == "RE" .AND. POSICIONE("SB1",1,xFilial("SB1")+cCodOrig,"B1_RETRABA") <> "S") .OR.;
   (Alltrim(cLocDest) == "RE" .AND. POSICIONE("SB1",1,xFilial("SB1")+cCodDest,"B1_RETRABA") <> "S")
	ApMsgStop("Movimenta��o no Armaz�m 'RE' exclusivo pe�as recuperadas","Armaz�m inv�lido")
	lRet := .F.
EndIf

//������������������������������������������������������������Ŀ
//| Verifica se Produto de Origem � igual ao Produto de Destino� *** Paulo Francisco ***
//��������������������������������������������������������������  
If cCodOrig <> cCodDest .AND. Alltrim(__cUserID) <> '000916' // Solicitado pelo Sr. Fernando Peratello somente o mesmo pode fazer essa transferecia.
	ApMsgStop("Rotina de transfer�ncia entre produtos diferentes desabilitada pelo administrador. Entre em contato com TI!","Produto inv�lido")
	lRet := .F.
EndIf
//����������������������������������Ŀ
//�Valida��o da data na transferencia�
//������������������������������������
If DEMIS260 <> dDataBase
	ApMsgStop("Rotina de transfer�ncia entre datas diferentes desabilitada pelo administrador. Entre em contato com TI!","Data inv�lido")
	lRet := .F.
EndIf    
//����������������������������������������������������������Ŀ
//�Valida��o pelo endere�o pela tabela SX5.                  �
//�O sistema deve percorrer todos os registros e validar o   �
//�destino de acordo com a origem. Separado pelo caracter "|"�
//������������������������������������������������������������
If cLocOrig == cLocDest .AND. !u_KITVldEnd(cLocOrig, cLoclzOrig, cLoclzDest)
	ApMsgStop("Amarra��o de endere�o de origemxdestino n�o esta cadastrada. Entre em contato com o TI","Ender�o Inv�lido")
	lRet := .F.
EndIf
//����Ŀ
//�    �
//������
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
			If ApMsgYesNo('Usuario n�o autorizado para efetuar movimenta��o em Armazem de Processo! Possui senha de libera��o?','Movimenta��o')
				IF !u_VldSenha()
                   	lRet := .F.
                EndIf					
			Else
				lRet := .F.
			EndIf
			If !lRet
				ApMsgStop("Usuario n�o informado ou n�o autorizado! Favor verificar com o responsavel!")
			EndIf
		EndIf
	EndIf
EndIf

//���������������������Ŀ
//�Restaura os ambientes�
//�����������������������
RestArea(aAreaSB2)
RestArea(aAreaSB8)
RestArea(aAreaSBF) 
RestArea(aAreaSDA)
RestArea(aArea)
Return lRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KITVldEnd �Autor  �Hudson de Souza Santos � Data � 03/14/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KITVldEnd(cArm, cEndOri, cEndDes)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local lRet		:= .T.
Local aArea		:= GetArea()
Local aEndDes	:= {}
Local nX		:= 0
Local cAuxDesc	:= ""
//����������������������������������������������Ŀ
//�Posiciona na tabela SX5 onde esta cadastrada a�
//�amarra��o Endere�o Origem x Endere�o Destino  �
//�Tabela: HE                                    �
//������������������������������������������������
dbSelectArea("SX5")
dbSetOrder(1)
//���������������������������������������Ŀ
//�Valida se existe cadastro de amarra��o.�
//�S� valida se existir o cadastro        �
//�����������������������������������������
If dbSeek(xFilial("SX5")+"HE"+cArm+"001")
	//���������������������������������������������������������Ŀ
	//�Caso exista cadastro de amarra��o, o retorno inicia Falso�
	//�����������������������������������������������������������
	lRet := .F.
	//�����������������������������������������Ŀ
	//�Percorre todo o SX5 com armaz�m referente�
	//�������������������������������������������
	While !SX5->(Eof()) .AND. SubSTR(SX5->X5_CHAVE,1,2) == cArm
		//������������������������������������������������Ŀ
		//�Primeiramente ajusta o final do registro na SX5.�
		//�Obrigando terminar com o caracter   /           �
		//��������������������������������������������������
		If SubSTR(SX5-X5_DESCRI,Len(Alltrim(SX5-X5_DESCRI)),1) <> "/"
			cAuxDesc := Alltrim(SX5->X5_DESCRI) + "/"
			RecLock("SX5",.F.)
			 SX5->X5_DESCRI		:= cAuxDesc
			 SX5->X5_DESCSPA	:= cAuxDesc
			 SX5->X5_DESCENG	:= cAuxDesc
			MsUnLock()
		EndIf
		//��������������������������������������������������������Ŀ
		//�Caso encontre o registro de acordo com o Endere�o Origem�
		//����������������������������������������������������������
		If Alltrim(cEndOri) == SubSTR(SX5-X5_DESCRI,1,AT("|",SX5-X5_DESCRI)-1)
			//�����������������������������������������������Ŀ
			//�Alimenta o Array com todos destinos do cadastro�
			//�������������������������������������������������
			aEndDes := StrTokArr(Alltrim(SubSTR(SX5-X5_DESCRI,AT("|",SX5-X5_DESCRI)+1)),"/")
			//���������������������������������������������������������Ŀ
			//�Para aceitar ender�o em branco, basta no cadastro colocar�
			//�o caracter / por duas vezes seguidas   //                �
			//�����������������������������������������������������������
			If AT(SubSTR(SX5-X5_DESCRI,AT("|",SX5-X5_DESCRI)+1),"//")
				aAdd(aEndDes,{""})
			EndIf
			//��������������������������������
			//�Percorre o array para validar.�
			//��������������������������������
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