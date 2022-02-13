#INCLUDE "Acdv035.ch" 
#INCLUDE "protheus.ch"
#INCLUDE "apvt100.ch"

STATIC __aRetCount	:= {} //Array que armazenara o retorno da analise do inventario ==>{lOk, aProdOk,aEtiQtdOk,aEtiLidas}
STATIC __cMestre	:= ""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHINVRO  ³ Autor ³ ACD                   ³ Data ³ 25/07/13³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa principal do VT100 para o inventario Rotativo     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BGHINVRO()
Local aTela
Local nOpc

aTela := VtSave()
VTCLear()

ACDV035X(1)

Return

Static Function ACDV035X(nOpc,lRetorno)
Local lValidQtdInv
Local cLocal:=Space(2)
Local cLocaAux
Local cEtiqueta :=Space(48)
Local lCBINV03  :=ExistBlock('CBINV03')
Local uRetEti	
Local bkey09
Private cArmazem
Private cEndereco
Private cEtiqend
Private cProduto
Private cEtiqProd
Private nQtdEtiq
Private cClasses := ""
Private cCodOpe  :=CBRetOpe()
Private aProdEnd :={}
Private lMsErroAuto	:= .F.
Private lUsaCB001 :=UsaCB0("01")
Private lUsaCB002 :=UsaCB0("02")
Private lModelo1  :=GetMv("MV_CBINVMD")=="1"
Private lForcaQtd :=GetMV("MV_CBFCQTD",,"2") =="1"
lValidQtdInv := If(lUsaCB001,(GetMv("MV_VQTDINV")=="1"),.t.)

CBChkTemplate()
If Empty(cCodOpe)
	VTAlert(STR0001,STR0002,.T.,4000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf
If ! SuperGetMV("MV_CBPE012",.F.,.F.)
	VTAlert(STR0042,STR0002,.T.,6000,3) //"Necessario ativar o parametro MV_CBPE012"###"Aviso"
	Return .F.
EndIf

If ! lModelo1
	bkey09 := VTSetKey(09,{|| Informa()},STR0043) //"Informacao"
EndIf


While .t.
	
	cArmazem := Space(02)
	cEndereco:= Space(15)
	cEtiqend := Space(48)
	cProduto := Space(15)
	cEtiqProd:= Space(48)
	nQtdEtiq := 0
	
	VTClear
	cCodInv := Space(TamSX3("CBA_CODINV")[1])
	@ 0,0 VTSay STR0003 //'Inventario'
	@ 2,0 VTSay STR0004 //'Codigo Mestre'
	@ 3,0 VTGet cCodInv Pict '@!'Valid VldCodInv(cCodInv,@lRetorno)  F3 "CBB"
	VTRead
	
	If !EMPTY(CBA->CBA_PROD) .AND. !EMPTY(CBA->CBA_LOCAL)
		dbSelectArea("SBF")
		dbSetOrder(2)
		If dbSeek(xFilial("SBF")+CBA->CBA_PROD+CBA->CBA_LOCAL)
	    	While SBF->(!EOF()) .AND. SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL)==xFilial("SBF")+CBA->CBA_PROD+CBA->CBA_LOCAL
				If VtLastkey() == 27
					Exit
				EndIf
				cEtiqProd := CBA->CBA_PROD
				cArmazem := CBA->CBA_LOCAL
				cEndereco := SBF->BF_LOCALIZ
				
				VTClear
				@ 0,0 VTSay STR0003 //'Inventario'
				@ 1,0 VTSay STR0005+CBA->CBA_LOCAL //'Armazem '
			
				@ 3,0 VTGet cArmazem
				
				@ 3,4 VtSay "-" VTGet cEndereco pict '@!'  Valid VldEnd()
										
				@ 4,0 VTSay STR0007 //"Quantidade"
				
				@ 5,0 VTGet nQtdEtiq pict CBPictQtde() valid nQtdEtiq > 0 when (lForcaQtd .or. VTLastkey() == 5) .and. lValidQtdInv
				
				@ 6,0 VTSay STR0009 //"Produto"
				
				@ 7,0 VTGet cEtiqProd pict "@!" Valid VTLastkey() == 5  .or. VldEtiPro(nOpc)
							
				VTRead
						
				cArmazem := Space(02)
				cEndereco:= Space(15)
				cEtiqend := Space(48)
				cProduto := Space(15)
				cEtiqProd:= Space(48)
				nQtdEtiq := 0
							
				SBF->(dbSkip())
			EndDo
			aiv035Fim()
		Else
			VTAlert("Endereço(s) não localizado(s) para o produto informado no mestre. Favor verificar!")
		Endif
	Else
		VTAlert("Para Inventario Rotativo é necessario gerar o mestre por produto. Favor verificar!")
	Endif
	Exit
End

If ! lModelo1
	vtsetkey(09,bkey09)
EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿
³Funcao³VoltaStatus         ³Autor³Erike Yuri da Silva³05/01/05³
ÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´
³Descricao ³Analisa a contagem apos sua finalizacao, e verifica³
³          ³se a mesma esta vazia (gerou CBC), estornando a    ³
³          ³contagem e os status se necessario                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno:  ³Nenhum                                             ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function VoltaStatus()
Local cNum    := CBB->CBB_NUM
Local nRecPos := CBB->(RecNo())
Local lPausa  := .f.
Local lCAtiva := .f.  // Contagem ativada

CBC->(DbSetOrder(1))
If !CBC->(DbSeek(xFilial("CBC")+CBB->CBB_NUM))
	DbSelectArea("CBB")
	RecLock("CBB",.f.)
	CBB->(DbDelete())
	CBB->(MsUnLock())


	DbSelectArea("CBA")
	RecLock("CBA",.f.)
	If ! lModelo1 // se for modelo 2 desbloquea mestre
		CBA->CBA_AUTREC := "1" // DESBLOQUEADO
	EndIf

	CBB->(DbSetOrder(3))
	// Se for encontrado verifica o modelo e altera o status
	If CBB->(DbSeek(xFilial('CBB')+CBA->CBA_CODINV))
		If !lModelo1
			CBA->CBA_STATUS := "3" 		// "3" - Contado
		Else
			While CBB->(!Eof() .AND. CBB_FILIAL+CBB_CODINV==xFilial("CBB")+CBA->CBA_CODINV)
				If (cNum#CBB->CBB_NUM) .and. CBB->CBB_STATUS $ "0|1"
					lCAtiva := .t.
					Exit
				EndIf
				CBB->(DbSkip())
			EndDo
			If !lCAtiva
				CBA->CBA_STATUS := "3" 		// "3" - Contado
			EndIf
		EndIf
	Else
		//Se nao encontrar nenhuma contagem para o mestre de inventario, altera status para noa iniciado
		CBA->CBA_STATUS := "0" 		// "0" - Nao Iniciado
		ACDA30Exc()
	EndIf
	CBA->(MsUnLock())
Else
	If lModelo1
		CBB->(dbSetOrder(3))
		CBB->(DbSeek(xFilial('CBB')+CBA->CBA_CODINV))
		While CBB->(!EOF() .AND. CBB_FILIAL+CBB_CODINV==xFilial('CBB')+CBA->CBA_CODINV)
			If (cNum==CBB->CBB_NUM) .and. (CBB->CBB_STATUS $ "01")
				lPausa := .T.
			ElseIf (cNum#CBB->CBB_NUM) .and. CBB->CBB_STATUS $ "0|1"
				lCAtiva := .t.
				RecLock("CBA",.f.)
				CBA->CBA_STATUS := "3" // EM PAUSA
				CBA->(MsUnLock())
				Exit
			EndIf
			CBB->(DbSkip())
		EndDo
	EndIf

	If !lModelo1 .or. (lPausa .and. !lCAtiva)
		//para o Modelo 2 somente a ultima contagem que importa, mas como so um
		//operador estara contando, nao preciso fazer analise, ja o modelo 1 deve
		//respeitar pausa somente se nenhum outro operador estiver com contagem em andamento.
		RecLock("CBA",.f.)
		CBA->CBA_STATUS := "2" // EM PAUSA
		CBA->(MsUnLock())
	EndIf
	CBB->(DbGoto(nRecPos))
EndIf
Return


Static Function aiv035Fim()
Local lPerExcInv  := SuperGetMv("MV_CBEXMIN", .F., .F.) //Habilitar exclusao do mestre inventario de enderecos s/saldo
Local nRecCBB
Local nX

If ! VTYesNo(STR0010,STR0002,.T.)  //"Deseja finalizar a contagem?"###"Aviso"
	// sandro
	// vereficar se nao leu nada para voltar o status
	CBB->(MsUnlock())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna contagem possicionada e altera status se necessario. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	VoltaStatus()
	Return
EndIf


// BY ERIKE Verificar se existe produtos a serem contados para este mestre
CBLoadEst(aProdEnd,.f.)
CBC->(dbSetOrder(1))
If Empty(aProdEnd) .and. ! CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM))
	If CBA->CBA_TIPINV == "1" // Por Produto
		VTAlert(STR0049,STR0002,.T.,4000) //"Nao existem Produtos para este endereco. A contagem nao sera finalizada!"###"Aviso"
		CBB->(MsUnlock())
		Return
	Else	//Por Endereco
		CBB->(MsUnlock())
		nRecCBB := CBB->(RecNo())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso este endereco estaja vazio, e nao exista ocorrencia de  ³
		//³ contagem, sera perguntado para o operador se o mesmo deseja  ³
		//³ continuar com a contagem em aberto, ou finalizar o mestre de ³
		//³ inventario.                                                  ³
		//³ Bops: 00000084197                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CBC->(dbSetOrder(3))
		If !CBC->(DbSeek(xFilial('CBC')+CBA->CBA_CODINV))
			VTAlert(STR0100+; //"Nao existem produtos para este endereco nos saldos do sistema, "
			STR0101+; //"nem foi detectada a ocorrencia de inventario para este mestre!"
			STR0102+; //"Este mestre deve ser excluido, caso contrario a contagem nao sera "
			STR0103,STR0104,.T.)   //"finalizada."###"Atencao"
			//Permite operador excluir Mestre inventario (tipo=endereco) por RF para inventario de endereco sem saldo.
			If lPerExcInv .And. CB1->(FieldPos("CB1_EXMIRF"))>0 .And. CB1->CB1_EXMIRF=="1"
				If VTYesNo(STR0105,STR0104,.t.) //"Deseja excluir este mestre de inventario?"###"Atencao"
					//Apaga Contagem atual
					RecLock('CBB',.F.)
					CBB->(DbDelete())
					CBB->(MsUnLock())
					//Apaga Mestre de inventario
					RecLock('CBA',.F.)
					CBA->(dbDelete())
					CBA->(MsUnLock())
				EndIf
				If CBA->CBA_STATUS == '0'
					ACDA30Exc()
				EndIf	
			Else
				//Apaga Contagem atual
				RecLock('CBB',.F.)
				CBB->(DbDelete())
				CBB->(MsUnLock())

				//Atualiza o status do mestre como nao inicial
				RecLock('CBA',.F.)
				CBA->CBA_STATUS := "0"
				CBA->(MsUnLock())
				ACDA30Exc()
			EndIf
		Else
			CBB->(DbGoto(nRecCBB))
			VTAlert(STR0100+; //"Nao existem produtos para este endereco nos saldos do sistema, "
			STR0106+; //"porem foi detectada a ocorrencia de inventario para este mestre!"
			STR0107+; //"sera necessario excluir esta contagem, caso contrario a contagem nao sera "
			STR0103,STR0104,.T.)   //"finalizada."###"Atencao"
			If VTYesNo(STR0108,STR0104,.t.) //"Deseja excluir a contagem atual?"###"Atencao"
				RecLock('CBB',.F.)
				CBB->(DbDelete())
				CBB->(MsUnLock())
			EndIf
			If CBA->CBA_STATUS == "0" 
				ACDA30Exc()
			EndIf	
		EndIf
		Return
	EndIf
EndIf
///------------------------
dbSelectArea("CBC")
CBC->(dbSetOrder(1))
If ! CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM))
	If ! VTYesNo(STR0033,STR0002,.t.) //'Nenhum produto foi inventariado, confirma estoque Zero'###"Aviso"
		CBB->(MsUnlock())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna contagem possicionada e altera status se necessario. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		VoltaStatus()
		Return
	Else
		For nX:= 1 To Len(aProdEnd)
			RecLock("CBC",.T.)
			CBC->CBC_FILIAL := xFilial("CBC")
			CBC->CBC_CODINV := CBB->CBB_CODINV
			CBC->CBC_NUM    := CBB->CBB_NUM
			CBC->CBC_LOCAL  := aProdEnd[nX,4]
			CBC->CBC_LOCALI := aProdEnd[nX,5]
			CBC->CBC_COD    := aProdEnd[nX,1]
			CBC->CBC_LOTECT := aProdEnd[nX,2]
			CBC->CBC_NUMLOT := aProdEnd[nX,3]
			CBC->CBC_NUMSER := aProdEnd[nX,6]
			CBC->CBC_QUANT  := 0
			CBC->(MSUNLOCK())
		Next
	EndIf
Else
	CBC->(dbSetOrder(2))
	For nX:= 1 To Len(aProdEnd)
		If CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM+aProdEnd[nX,1]+aProdEnd[nX,4]+aProdEnd[nX,5]+aProdEnd[nX,2]+aProdEnd[nX,3]+aProdEnd[nX,6]))
			// se encontrar nao eh necessario completar a contagem para compatibilizar o estoque
			Loop
		EndIf
		RecLock("CBC",.T.)
		CBC->CBC_FILIAL := xFilial("CBC")
		CBC->CBC_CODINV := CBB->CBB_CODINV
		CBC->CBC_NUM    := CBB->CBB_NUM
		CBC->CBC_LOCAL  := aProdEnd[nX,4]
		CBC->CBC_LOCALI := aProdEnd[nX,5]
		CBC->CBC_COD    := aProdEnd[nX,1]
		CBC->CBC_LOTECT := aProdEnd[nX,2]
		CBC->CBC_NUMLOT := aProdEnd[nX,3]
		CBC->CBC_NUMSER := aProdEnd[nX,6]
		CBC->CBC_QUANT  := 0
		CBC->(MSUNLOCK())
	Next
Endif

dbSelectArea("CBB")
RecLock("CBB",.F.)
CBB->CBB_STATUS := "2"
CBB->(MsUnlock())
If ! Ultimo()
	Return
EndIF

dbSelectArea("CBA")
RecLock("CBA",.F.)
CBA->CBA_STATUS := "3" //Contado
CBA->(MsUnLock())

If GetMV("MV_ANAINV") # "1"
	//Esta funcao eh executada para atualizar o CBA_ANALIS (que indica se existe divergencia ou nao no mestre de inventario)
	AnalisaInv(.F.)
	Return
EndIf
CBAnaInv()
Return

Static Function VldCodInv(cCodInv,lAlert)
Local lRetorno
Local lV035VLDM :=ExistBlock("V035VLDM")
Local cUltCont
Local aCBC:={}
Local nX,nY
Default lAlert:= .t.
If Empty(cCodInv)
	VtKeyBoard(chr(23))
	Return .f.
EndIf
CBA->(DbSetOrder(1))
If ! CBA->(DbSeek(xFilial('CBA')+cCodInv))
	VTBeep(3)
	VTAlert(STR0016,STR0017,.t.,4000) //'Codigo mestre de inventario nao cadastrado'###'Atencao'
	VTKeyBoard(chr(20))
	Return .f.
EndIf
If CBA->CBA_STATUS$"4-5" // 4=Finalizado / 5=Processado
	VTBeep(3)
	VTAlert(STR0018,STR0017,.t.,4000) //'Inventario finalizado'###'Atencao'
	VTKeyBoard(chr(20))
	Return .f.
EndIf
If (CB1->CB1_INVPVC<>"1")// mesmo operador executar o mesmo inventario
	CBB->(dbSetOrder(2))
	If CBB->(dbSeek(xFilial('CBB')+"2"+cCodOpe+CBA->CBA_CODINV ))
		VTBeep(3)
		VTAlert(STR0059,STR0060,.t.,4000)  //"Operador ja realizou contagem para o inventario"###"Sem permissao"
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
EndIf
If DTOS(CBA->CBA_DATA)#DTOS(dDataBase)
	VTAlert('Data do "Mestre de Inventario" deve ser igual a "Data Base" do sistema!',STR0017,.t.,4000,3)
	VTAlert("So sera possivel executar este Mestre de Inventario na data -> "+DTOC(CBA->CBA_DATA)+" <-",STR0017,.t.)  //"Somente o Operador "###" pode dar continuidade a este inventario"###"Contagens == 1"
	VTKeyBoard(chr(20))
	Return .f.
EndIf
If CBA->CBA_CONTS == 1
	CBB->(DbSetOrder(1))
	If CBB->(DbSeek(xFilial('CBB')+CBA->CBA_CODINV )) .and. CBB->CBB_USU # cCodOpe
		VTBeep(3)
		VTAlert(STR0061+CBB->CBB_USU+STR0062,STR0063,.t.,4000)  //"Somente o Operador "###" pode dar continuidade a este inventario"###"Contagens == 1"
		VTKeyBoard(chr(20))
		Return .f.
	Endif
Endif
CBB->(DbSetOrder(2))
If CBB->(DbSeek(xFilial('CBB')+"1"+cCodOpe+CBA->CBA_CODINV ))
	If ! CBB->(RLock())
		VTBeep(3)
		VTAlert(STR0019,STR0017,.t.,4000) //'Operador executando inventario em outro terminal'###'Atencao'
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	CBB->(DBUnLock())
	Reclock("CBB",.f.)
Else
	cUltCont:=Space(6)
	If ! lModelo1 // se for modelo 2 tem que verificar se tem autorizacao
		If CBA->CBA_AUTREC=="2" // BLOQUEADO
			VTBeep(3)
			VTAlert(STR0058,STR0017,.t.,4000) //'Atencao' //"Inventario bloqueado para auditoria"
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cUltCont := CBUltCont(CBA->CBA_CODINV)
	EndIf
	Reclock("CBB",.T.)
	CBB->CBB_FILIAL := xFilial("CBB")
	CBB->CBB_NUM    := CBProxCod('MV_USUINV')
	CBB->CBB_CODINV := CBA->CBA_CODINV
	CBB->CBB_USU    := cCodOpe
	// CBB_NCONT  := nCont   // verificar necessidade
	CBB->CBB_STATUS := "1"
	CBB->(MsUnlock())
	Reclock("CBB",.F.)

	//-- transpor as contagens batidas para este usuario
	If ! lModelo1 .and. ! Empty(cUltCont)
		CBC->(DbSetOrder(1))
		CBC->(DbSeek(xFilial('CBC')+cUltCont))
		While CBC->(!Eof() .and. xFilial('CBC')+cUltCont == CBC_FILIAL+CBC_NUM)
			If CBC->CBC_CONTOK=="1"
				aadd(aCBC,array(CBC->(FCount())))
				For nX:= 1 to CBC->(FCount())
					aCBC[len(aCBC),nX] := CBC->(FieldGet(nX))
				Next
			EndIf
			CBC->(DbSkip())
		End
		For nX:= 1 to len(aCBC)
			Reclock("CBC",.t.)
			For nY := 1 to CBC->(FCount())
				If CBC->(FieldName(nY)) == "CBC_CODINV"
					CBC->CBC_CODINV    := CBB->CBB_CODINV
				ElseIf CBC->(FieldName(nY)) == "CBC_NUM"
					CBC->CBC_NUM    := CBB->CBB_NUM
				Else
					CBC->(FieldPut(nY,aCBC[nX,nY]))
				EndIf
			Next
			CBC->(MsUnLock())
		Next
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analisando Classificacao por curva ABC                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cClasses := ""
If CBA->CBA_CLASSA=="1"
	cClasses+="A"
EndIf
If CBA->CBA_CLASSB=="1"
	cClasses+="B"
EndIf
If CBA->CBA_CLASSC=="1"
	cClasses+="C"
EndIf

CBLoadEst(aProdEnd)
If CBA->CBA_STATUS=='0'
	IniciaCBM(aProdEnd)
EndIf
RecLock("CBA",.f.)
If ! lModelo1 // se for modelo 2 tem que verificar se tem autorizacao
	CBA->CBA_AUTREC:="2" // BLOQUEADO
EndIf
CBA->CBA_STATUS := "1"  // 1=Em andamento
CBA->(MsUnlock())

If lV035VLDM
	   lRetorno := ExecBlock("V035VLDM",.F.,.F.)
	   lRetorno := If(ValType(lRetorno)=="L",lRetorno,.T.)
	   VTKeyBoard(chr(20))
	   If !lRetorno
	      Return .F.
	   Endif
Endif

If CBA->CBA_TIPINV =="2" .and. lAlert
	VTAlert(STR0035+CBA->CBA_LOCAL+STR0036+CBA->CBA_LOCALI,STR0002,.t.,4000) //"Va para o Armazem "###" Endereco "###"Aviso"
EndIf
Return .t.

Static Function EtiqEnd()
Local aEtiqueta
If Empty(cEtiqEnd)
	Return .f.
EndIF
aEtiqueta := CBRetEti(cEtiqEnd,"02")
If Len(aEtiqueta) ==0
	VTBeep(3)
	VTAlert(STR0020,STR0002,.t.,4000) //'Etiqueta invalida'###'Aviso'
	VTKeyBoard(chr(20))
	Return .f.
EndIf
cEndereco := aEtiqueta[1]
cArmazem  := aEtiqueta[2]
@ 3,0 VTSay Padr(cEndereco,20)
Return VldEnd()

Static Function VldEnd()
Local lRet := .T.

If ExistBlock('CBINV02')
	lRet := ExecBlock("CBINV02",,,{cArmazem,cEndereco})
	If ValType(lRet)#"L"
		lRet := .T.	
	EndIf
	If !lRet
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
EndIf

If CBA->CBA_TIPINV == "2"  // 2=Por Endereco
	If ! CBA->CBA_LOCAL == cArmazem .or. ! CBA->CBA_LOCALI == cEndereco
		VTBeep(3)
		VTAlert(STR0022+chr(13)+CHR(10)+STR0023+CBA->CBA_LOCAL+"-"+CBA->CBA_LOCALI,STR0017,.t.,4000) //'Armazem e endereco incorreto.'###'O correto seria:'###'Atencao'
		VtClearGet("cArmazem")
		VtClearGet("cEndereco")
		VtGetSetFocus("cArmazem")
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
Else
	SBE->(DbSetOrder(1))
	If !SBE->(DbSeek(xFilial('SBE')+cArmazem+cEndereco))
		VTBeep(3)
		VTAlert(STR0024,STR0017,.t.,4000) //'Endereco nao cadastrado.'###'Atencao'
		VtClearGet("cArmazem")
		VtClearGet("cEndereco")
		VtGetSetFocus("cArmazem")
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
EndIf
Return .t.

Static Function VldEtiPro(nOpc)
Local aEtiqueta
Local nQE
Local nQuant
Local nQtdEtiq2
Local cArm2
Local cEnd2
Local cNumSeri
Local aSave
Local aItensPallet := CBItPallet(cEtiqProd)
Local lIsPallet := .t.
Local nP, nX
Local aLidos   :={}
Local lCBINV01 :=ExistBlock('CBINV01')
Local lCBINV04 :=ExistBlock('CBINV04')
Private cLote  :=Space(10)
Private cSLote :=Space(06)

If Empty(cEtiqProd)
	Return .f.
EndIf

If len(aItensPallet) == 0
	aItensPallet:={cEtiqProd}
	lIsPallet := .f.
EndIf
Begin Sequence
For nP := 1 to len(aItensPallet)
	cEtiqProd:=Padr(aItensPallet[nP],48)
	If lCBINV01
		cEtiqProd := ExecBlock("CBINV01",,,{cArmazem,cEndereco,cEtiqProd})
		If ValType(cEtiqProd)#"C"
			cEtiqProd:=Padr(aItensPallet[nP],48)
		EndIf
	EndIf
	If lUsaCB001
		aEtiqueta := CBRetEti(cEtiqProd,"01",.T.,.T.)
		If Len(aEtiqueta) == 0 .Or. CB0->CB0_STATUS $"12"
			VTBeep(3)
			VTAlert(STR0020,STR0002,.t.,4000) //'Etiqueta invalida'###'Aviso'
			break
		EndIf
		If A166VldCB9(aEtiqueta[1], CB0->CB0_CODETI)
			VTBeep(3)
			VTAlert(STR0088,STR0002,.t.,3000) //"Etiqueta Invalida"###"Aviso"
			break
		EndIf
		If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
			VTBeep(3)
			VTAlert(STR0020+STR0064,STR0002,.t.,4000) //'Etiqueta invalida'", produto pertence a um pallet "###'Aviso'
			break
		EndIf
		cProduto := aEtiqueta[01]
		nQtdEtiq2:= aEtiqueta[02]
		cLote    := aEtiqueta[16]
		cSLote   := aEtiqueta[17]
		cArm2    := aEtiqueta[10]
		cEnd2    := aEtiqueta[09]
		cNumSeri := CB0->CB0_NUMSER
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1")+cProduto))
			VTBeep(3)
			VTAlert(STR0030,STR0017,.t.,4000) //'Produto nao cadastrado.'###'Atencao'
			break
		EndIf

		//Para evitar problemas na execucao da rotina automatica que gera SB7
		//Sera incluida aqui a validacao do valido do B7_LOCAL (by Erike)
		SB2->(DbSetOrder(1))
		If !SB2->(DbSeek(xFilial("SB2")+cProduto+cArm2))
			VTBeep(3)
			VTAlert(STR0065,STR0017,.t.,4000) //'Produto nao localizado na tabela de saldos fisicos(SB2).'###'Atencao'
			break
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando Classificacao por curva ABC, somente inv. por prod.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CBA->CBA_TIPINV == "1" .and. !Empty(cClasses) .and. !CBClABC(cProduto,cClasses)
			VTBeep(3)
			VTAlert(STR0066+cClasses+STR0067,STR0017,.t.,4000) //'Produto nao pertence a(s) classe(s) "'###'" da curva ABC!'
			break
		EndIf

		If GetMv('MV_LOCALIZ') =="S"
			If nOpc == 1 // --> Inventario por Mestre
				If CBA->CBA_TIPINV == "1" .and. SB1->B1_LOCALIZ == "S" .and. Empty(cEnd2)
					VTBeep(3)
					VTAlert(STR0068,STR0002,.t.,4000) //"Etiqueta de produto sem endereco"###'Aviso'
					break
				Elseif CBA->CBA_TIPINV == "2" .and. SB1->B1_LOCALIZ == "S" .and. Empty(cEnd2)
					VTBeep(3)
					VTAlert(STR0068,STR0002,.t.,4000) //"Etiqueta de produto sem endereco"###'Aviso'
					break
				Elseif CBA->CBA_TIPINV == "2" .and. SB1->B1_LOCALIZ # "S"
					VTBeep(3)
					VTAlert(STR0069,STR0002,.t.,4000) //"Produto sem controle de endereco"###"Aviso"
					break
				Endif
			Elseif nOpc == 2 // --> Inventario por Produto
				If SB1->B1_LOCALIZ == "S" .and. Empty(cEnd2)
					VTBeep(3)
					VTAlert(STR0068,STR0002,.t.,4000) //"Etiqueta de produto sem endereco"###'Aviso'
					break
				Endif
			Else // --> Inventario por Endereco
				If SB1->B1_LOCALIZ # "S"
					VTBeep(3)
					VTAlert(STR0069,STR0002,.t.,4000) //"Produto sem controle de endereco"###"Aviso"
					break
				Elseif SB1->B1_LOCALIZ == "S" .and. Empty(cEnd2)
					VTBeep(3)
					VTAlert(STR0068,STR0002,.t.,4000) //"Etiqueta de produto sem endereco"###'Aviso'
					break
				Endif
			Endif
		Endif
		If Empty(aEtiqueta[2])
			nQtdEtiq2:= 1
		EndIf
		nQE:= 1		
		If ! CBProdUnit(aEtiqueta[1])
			nQE := CBQtdEmb(aEtiqueta[1])
			If empty(nQE)
				break
			EndIf
			CBC->(DBSetOrder(1))
			If CBC->(DBSeek(xFilial('CBC')+CBB->CBB_NUM+CB0->CB0_CODETI))
				VTBeep(3)
				VTAlert(STR0026,STR0002,.t.,4000) //'Codigo ja lido'###'Aviso'
				break
			EndIf
			If Localiza(aEtiqueta[1])
				If GetMV("MV_ALTENDI") == "0"
					IF ! Empty(cEnd2) .and. ! cArm2+cEnd2 == cArmazem+cEndereco
						VTBeep(3)
						VTAlert(STR0025+cArm2+'-'+cEnd2,STR0002,.t.,4000) //'Produto pertence ao endereco:'###'Aviso'
						break
					EndIf
				EndIf
			EndIf
		Else
			If CBQtdVar(aEtiqueta[1]) .and. ! lIsPallet
				aSave   := VTSAVE()
				VTClear
				@ 2,0 VTSay STR0070 //"Produto com "
				@ 3,0 VtSay STR0071  //"Qtde variavel"
				@ 4,0 VtGet nQE pict CBPictQtde()
				VTREAD
				VtRestore(,,,,aSave)
				If VTLastKey() == 27
					VTAlert(STR0072,STR0002,.t.,3000) //"Quantidade Invalida"###"Aviso"
					VTKeyboard(chr(20))
					Return .f.
				EndIf
				nQtdEtiq2:= nQE
				nQE:= 1	
			EndIf
			CBC->(DBSetOrder(1))
			If CBC->(DBSeek(xFilial('CBC')+CBB->CBB_NUM+CB0->CB0_CODETI))
				VTBeep(3)
				VTAlert(STR0026,STR0002,.t.,4000) //'Codigo ja lido'###'Aviso'
				break
			EndIf
			If Localiza(aEtiqueta[1])
				IF ! cArm2+cEnd2 == cArmazem+cEndereco
					If GetMV("MV_ALTENDI") == "0"
						VTBeep(3)
						VTAlert(STR0025+cArm2+'-'+cEnd2,STR0002,.t.,4000) //'Produto pertence ao endereco:'###'Aviso'
						break
					EndIf
				EndIF
			EndIf
		EndIF
		nQuant := nQE*nQtdEtiq*nQtdEtiq2
	Else
		If ! CBLoad128(@cEtiqProd)
			VTAlert(STR0027,STR0002,.t.,4000,3) //'Leitura invalida'###'Aviso'
			VTKeyBoard(chr(20))
			Return .f.
		Endif
		cTipId:=CBRetTipo(cEtiqProd)
		If ! cTipId $ "EAN8OU13-EAN14-EAN128"
			VTALERT(STR0028,STR0002,.T.,4000,3)   //"Etiqueta invalida."###"Aviso"
			VTKeyboard(chr(20))
			Return .f.
		EndIf
		aEtiqueta := CBRetEtiEan(cEtiqProd)
		If Len(aEtiqueta) == 0
			VTAlert(STR0029,STR0002,.t.,4000,3) //'Etiqueta invalida!!'###'Aviso'
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cProduto  := aEtiqueta[01]
		nQtdEtiq2 := aEtiqueta[02]
		cLote     := aEtiqueta[03]
		cNumSeri  := aEtiqueta[05]
		nQE       := 1
		//-- SubLote: retornado no PE CBRETEAN (CBRetEtiEAN/ACDXFUN)
		If Len(aEtiqueta)>5
			cSLote := aEtiqueta[06]
		EndIf

		If CBA->CBA_TIPINV=="2" .And. !Localiza(cProduto)
			VTAlert(STR0069,STR0002,.t.,4000,3) //"Produto sem controle de endereco"###"Aviso"
			break
		EndIf
		If ! CBProdUnit(aEtiqueta[1])
			nQE := CBQtdEmb(aEtiqueta[1])
			If	Empty(nQE)
				VTKeyboard(chr(20))
				Return .f.
			EndIf
			nQtdEtiq2 := 1
		EndIf
		nQuant := nQE*nQtdEtiq*nQtdEtiq2
		If CBChkSer(aEtiqueta[1]) .And. ! CBNumSer(@cNumseri,Nil,aEtiqueta)
			Return .f.
		EndIf
		If !Empty(cNumseri)
		SBF->(DbSetorder(4))
			If !SBF->(DbSeek(xFilial("SBF")+cProduto+cNumseri)).And. SuperGetMV("MV_ALTENDI") == "0"
	            VTAlert(STR0084+cNumseri+" inválido",STR0021,.T.,3000) // N.serie: inválido #Aviso#
				VTKeyBoard(chr(20))
				Return .F.	  
			EndIf
		EndIf
	EndIf
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial('SB1')+cProduto))
		VTBeep(3)
		VTAlert(STR0030,STR0017,.t.,4000) //'Produto nao cadastrado.'###'Atencao'
		VTKeyBoard(chr(20))
		Return .F.
	EndIf
    If SuperGetMv("MV_LOCALIZ")== "S"  .And. SB1->B1_LOCALIZ == "S" .And. Empty(cEndereco) .And. Empty(cNumseri) 
	    VTAlert("Endereco e numero de serie em branco, informe a localização do produto",STR0021,.T.,3000)  //"Endereco e numero de serie em branco, informe a localização do produto"   #Aviso#                                                                                                                                                                                                                                                                                                                                                                                                                                                    
		VtClearGet("cEtiqProd")
		VtClearGet("cEndereco")
		VtGetSetFocus("cEndereco")
        Return .F.
    EndIf    
	//Para evitar problemas na execucao da rotina automatica que gera SB7
	//Sera incluida aqui a validacao do valido do B7_LOCAL (by Erike)
	SB2->(DbSetOrder(1))
	If !SB2->(DbSeek(xFilial("SB2")+cProduto+cArmazem))
		VTBeep(3)
		VTAlert(STR0030,STR0017,.t.,4000) //'Produto nao localizado na tabela de saldos fisicos(SB2).'###'Atencao'
		VTKeyBoard(chr(20))
		Return .F.
	EndIf

	If CBA->CBA_TIPINV == "1"  // 1=Por Produto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando Classificacao por curva ABC, somente inv. por prod.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cClasses) .and. !CBClABC(cProduto,cClasses)
			VTBeep(3)
			VTAlert(STR0066+cClasses+STR0067,STR0017,.t.,4000) //'Produto nao pertence a(s) classe(s) "'###'" da curva ABC!'
			VTKeyBoard(chr(20))
			Return .F.
		EndIf

		If ! CBA->CBA_PROD == cProduto .and. ! Empty(CBA->CBA_PROD)
			VTBeep(3)
			VTAlert(STR0031,STR0017,.t.,4000) //'Produto diferente do que deve ser inventariado.'###'Atencao'
			VTKeyBoard(chr(20))
			Return .F.
		EndIf
	EndIf
	If lCBINV04
		ExecBlock("CBINV04",.F.,.F.)
	Endif
	If Rastro(cProduto)
		If ! CBRastro(cProduto,@cLote,@cSLote)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		If !V35VldLot(cProduto,cArmazem,cLote,cSLote)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	EndIf


	If lUsaCB001
		CBC->(DBSetOrder(1))
		If CBC->(DBSeek(xFilial('CBC')+CBB->CBB_NUM+CB0->CB0_CODETI))
			RecLock("CBC",.f.)
		Else
			RecLock("CBC",.T.)
			CBC->CBC_FILIAL := xFilial("CBC")
			CBC->CBC_CODINV := CBB->CBB_CODINV
			CBC->CBC_NUM    := CBB->CBB_NUM
			CBC->CBC_LOCAL  := cArmazem
			CBC->CBC_LOCALI := cEndereco
			CBC->CBC_COD    := cProduto
			CBC->CBC_CODETI := CB0->CB0_CODETI
			CBC->CBC_LOTECT := cLote
			CBC->CBC_NUMLOT := cSLote
			CBC->CBC_NUMSER := cNumSeri
			aadd(aLidos,CB0->CB0_CODETI)
		EndIf
		CBC->CBC_QUANT  += nQuant
		CBC->CBC_QTDORI += nQuant
		CBC->(MsUnlock())
	Else
		CBC->(DBSetorder(2))
		If ! CBC->(DbSeek(xFilial('CBC')+CBB->CBB_NUM+cProduto+cArmazem+cEndereco+cLote+cSLote+cNumSeri))
			RecLock("CBC",.T.)
			CBC->CBC_FILIAL := xFilial("CBC")
			CBC->CBC_CODINV := CBB->CBB_CODINV
			CBC->CBC_NUM    := CBB->CBB_NUM
			CBC->CBC_LOCAL  := cArmazem
			CBC->CBC_LOCALI := cEndereco
			CBC->CBC_COD    := cProduto
			CBC->CBC_LOTECT := cLote
			CBC->CBC_NUMLOT := cSLote
			CBC->CBC_NUMSER := cNumSeri
		Else
			If ! lModelo1
				If CBC->CBC_CONTOK =="1"
					VTBeep(3)
					VTAlert(STR0073,STR0074,.t.,4000)  //"Nao eh necessario a recontagem!!!"###"Produto ja auditado"
					VTKeyBoard(chr(20))
					Return .F.
				EndIf
			EndIf
			RecLock("CBC",.f.)
		EndIf
		CBC->CBC_QUANT  += nQuant
		CBC->CBC_QTDORI += nQuant
		CBC->(MsUnlock())
	EndIf
	ACD35CBM(3,CBA->CBA_CODINV,cProduto,cArmazem,cEndereco,cLote,cSLote,cNumSeri)
Next
/*
If lForcaQtd
	VtSay(7,0,Space(19))
	cEtiqProd:= Space(48)
	cEndereco:= Space(15)
	nQtdEtiq := 1
	VtGetSetFocus('cEtiqProd')
	VtGetSetFocus('nQtdEtiq')
Else
	VTKeyBoard(chr(20))
	nQtdEtiq :=1
	VTGetRefresh('nQtdEtiq')
EndIf
*/
Return //.f.
End Sequence
// se passar aqui e' porque ocorreum alguma consistencia
For nX:= 1 to len(aLidos)
	CBC->(DBSetOrder(1))
	If CBC->(DBSeek(xFilial('CBC')+CBB->CBB_NUM+aLidos[nX]))
		RecLock("CBC",.f.)
		CBC->(DbDelete())
		CBC->(MsUnlock())
	EndIf
Next
VTKeyBoard(chr(20))
nQtdEtiq :=1
VTGetRefresh('nQtdEtiq')
Return .f.

Static Function Ultimo()
Local lIsLast:= .t.
Local nReg := CBB->(Recno())
RecLock('CBA',.f.)
CBB->(DbUnLock())
CBB->(DBSetOrder(1))
CBB->(DBSeek(xFilial('CBB')+CBA->CBA_CODINV))
While CBB->(!eof()) .and. CBB->CBB_CODINV == CBA->CBA_CODINV
	If ! CBB->(Rlock())
		lIsLast := .f.
		Exit
	EndIf
	CBB->(DBSkip())
EndDo
CBB->(DbGoto(nReg))
RecLock('CBB',.f.)
CBA->(DbUnLock())
Return lIsLast


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿
³Funcao³AnalisaInv          ³Autor³ACD                ³??/??/??³
ÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´
³Descricao ³Tem o objetivo de invalidar etiquetas nao lidas e  ³
³          ³atualizar valores(quantidade) no CB0.              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³lMonitor: Indica se o programa que fara a analise  ³
³          ³          sera o Monitor de inv(protheus) ou RF.   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observacao³O nome anterior desta funcao era AnalisaInv.       ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno:  ³Array, onde:                                       ³
³          ³array[1]: Logico indicando se existe divergencia   ³
³          ³          nas contagens;                           ³
³          ³array[2]: Array listando produtos sem diergencia   ³
³          ³array[3]: Array listando etiquetas sem divergencia ³
³          ³array[4]: Array listando todas etiquetas lidas.    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AnalisaInv(lMonitor)
Local aProds  := {}
Local aProdAux:= {}
Local aProdOK := {}
Local aProdOK2:= {}
Local aProdNoOk:={}
Local aEtiQtdOK:={}
Local aEtiLidas:={}
Local nPos
Local i, j
Local cCodCBB := CBB->CBB_NUM
Local cAux:=''
Local nSaldo
Local cProduto,cArm,cEnd,cLote,cSLote,cNumSeri
Local lOK:= .f.
Local lModelo1 := SuperGetMv("MV_CBINVMD")=="1"
Local lUsaCB001:=UsaCB0("01")
Private aCods  := {}

If lModelo1
	CBB->(dbSetOrder(1))
	CBB->(dbSeek(xFilial('CBB')+CBA->CBA_CODINV))
	While ! CBB->(Eof()) .and. xFilial("CBB") == CBB->CBB_FILIAL .and. CBB->CBB_CODINV == CBA->CBA_CODINV
		If CBB->CBB_STATUS == "2"
			Aadd(aCods,CBB->CBB_NUM)
		EndIf
		CBB->(dbSkip())
	EndDo

	For i := 1 To Len(aCods)
		CBC->(dbSetOrder(1))
		CBC->(dbSeek(xFilial('CBC')+aCods[i]))
		While !CBC->(Eof()) .and. xFilial("CBC") == CBC->CBC_FILIAL .and. CBC->CBC_NUM == aCods[i]

			cAux:=Space(10)
			If lUsaCB001 .and.  CBProdUnit(CBC->CBC_COD) //.and. !CBQtdVar(CBC->CBC_COD)
				cAux:= CBC->CBC_CODETI
			EndIf
			If lUsaCB001
				If Ascan(aEtiLidas,CBC->CBC_CODETI) == 0
					aadd(aEtiLidas,CBC->CBC_CODETI)
				EndIf
			EndIf
			nPos := Ascan(aProds,{|x| x[1] == CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux) .and. x[3]==CBC->CBC_NUM })
			If nPos > 0
				aProds[nPos,2] +=  CBC->CBC_QUANT
			Else
				Aadd(aProds,{CBC->( CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux),CBC->CBC_QUANT,CBC->CBC_NUM,CBC->CBC_LOCAL,CBC->CBC_LOCALI})
			Endif
			If cCodCBB == CBC->CBC_NUM
				CBC->(CBLog("04",{CBC_COD,CBC_QUANT,CBC_LOTECT,CBC_NUMLOT,CBC_LOCAL,CBC_LOCALI,CBA->CBA_CODINV,CBC_NUM,CBC_CODETI}))
			EndIf
			CBC->(dbSkip())
		EndDo
	Next i
	For i := 1 to len(aProds)
		For j:= 1 to len(aCods)
			CBC->(dbSetOrder(2))
			If ! CBC->(DBSeek(xFilial('CBC')+aCods[j]+aProds[i,1]))
				If Ascan(aProds,{|x| x[1] == aProds[i,1] .and. x[2] ==0 .and. x[3] == aCods[j]  }) == 0
					Aadd(aProds,{aProds[i,1],0,aCods[j],aProds[i,4],aProds[i,5]})
				EndIF
			EndIf
		Next
	Next
	For i := 1 to len(aProds)
		nPos := Ascan(aProdAux,{|x| Padr(x[1],78)==Padr(aProds[i,1],78) .and. StrZero(x[2],12,4) == StrZero(aProds[i,2],12,4) })
		If nPos==0
			Aadd(aProdAux,{aProds[i,1],aProds[i,2],1,aProds[i,4],aProds[i,5]})
		Else
			aProdAux[nPos,3]++
		EndIF
	Next
	For i := 1 to len(aProdAux)
		If aProdAux[i,3] >= CBA->CBA_CONTS
			nPos := Ascan(aProdOK,{|x| x[1] == aProdAux[i,1]})
			If nPos== 0
				aadd(aProdOk,{aProdAux[i,1],aProdAux[i,2],aProdAux[i,4],aProdAux[i,5]})
				If Subs(aProdAux[i,1],69,10) <> Space(10)
					aadd(aEtiQtdOK,{Subs(aProdAux[i,1],69,10),aProdAux[i,2],aProdAux[i,4],aProdAux[i,5]})
				EndIf
			EndIf
		Else
			nPos := Ascan(aProdNoOK,{|x| x[1] == aProdAux[i,1]})
			If nPos == 0
				aadd(aProdNoOK,{aProdAux[i,1]})
			EndIf
		EndIf
	Next
	For i := 1 to len(aProdOk)
		nPos := Ascan(aProdNoOK,{|x| x[1] == aProdOK[i,1]})
		If nPos > 0
			aDel(aProdNoOk,nPos)
			aSize(aPRodNoOk,Len(aProdNoOK)-1)
		EndIf
	Next
	aProdOk2:={}
	For i:= 1 to len(aProdOK)
		nPos := Ascan(aProdOK2,{|x| Left(x[1],68) == Left(aProdOK[i,1],68)})
		If nPos == 0
			aadd(aProdOk2,{Left(aProdOK[i,1],68),aProdOK[i,2],aProdOK[i,3],aProdOK[i,4]})
		Else
			aProdOk2[npos,2] +=aProdOk[i,2]
		EndIF
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o status de analise indicando se esta divergente ou nao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("CBA")
	RecLock("CBA",.F.)
	If Empty(aProdNoOK)
		CBA->CBA_ANALIS := "1"
	Else
		CBA->CBA_ANALIS := "2"
	EndIf
	CBA->(MsUnLock())

Else
	// posicionar na ultima contagem
	CBB->(dbSetOrder(3))
	If ! CBB->(dbSeek(xFilial('CBB')+CBA->CBA_CODINV))
		MsgInTrans(1,STR0046+CBA->CBA_CODINV+STR0075) //"Mestre de Inventario"###" Nao encontrado"
	EndIf
	While ! CBB->(Eof()) .and. xFilial("CBB") == CBB->CBB_FILIAL .and. CBB->CBB_CODINV == CBA->CBA_CODINV
		CBB->(dbSkip())
	EndDo
	CBB->(dbSkip(-1))
	// Aglutinar as quantidade pela chave
	CBC->(dbSetOrder(1))
	CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM))
	While CBC->( !Eof() .and. xFilial("CBC")+CBB->CBB_NUM == CBC_FILIAL+CBC_NUM)
		cAux:=Space(10)
		If lUsaCB001 .and.  CBProdUnit(CBC->CBC_COD) //.and. CBQtdVar(CBC->CBC_COD)
			cAux:= CBC->CBC_CODETI
		EndIf
		If lUsaCB001
			If Ascan(aEtiLidas,CBC->CBC_CODETI) == 0
				aadd(aEtiLidas,CBC->CBC_CODETI)
			EndIf
		EndIf
		nPos := Ascan(aProds,{|x| x[1] == CBC->(CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux) })
		If nPos > 0
			aProds[nPos,2] += CBC->CBC_QUANT
		Else
			Aadd(aProds,{CBC->( CBC_COD+CBC_LOCAL+CBC_LOCALI+CBC_LOTECT+CBC_NUMLOT+CBC_NUMSER+cAux),CBC->CBC_QUANT,CBC->CBC_LOCAL,CBC->CBC_LOCALI})
		EndIf
		CBC->(CBLog("04",{CBC_COD,CBC_QUANT,CBC_LOTECT,CBC_NUMLOT,CBC_LOCAL,CBC_LOCALI,CBA->CBA_CODINV,CBC_NUM,CBC_CODETI}))
		CBC->(dbSkip())
	EndDo
	// aglutinar o mesmo produto
	For i:= 1 to len(aProds)
		nPos := Ascan(aProdAux,{|x| Left(x[1],68) == Left(aProds[i,1],68)})
		If nPos== 0
			aadd(aProdAux,{Left(aProds[i,1],68),aProds[i,2]})
		Else
			aProdAux[nPos,2]+=aProds[i,2]
		EndIf
		If lUsaCB001
			aadd(aEtiQtdOK,{Subs(aProds[i,1],69,10),aProds[i,2],aProds[i,3],aProds[i,4]})
		EndIf
	Next

	For i:= 1 to len(aProdAux)
		//CBC_COD
		//               CBC_LOCAL
		//                 CBC_LOCALI
		//                                CBC_LOTECT
		//                                          CBC_NUMLOT
		//                                                CBC_NUMSER
		//12345678901234512123456789012345123456789012345612345678901234567890
		//1234567890123456789012345678901234567890123456789012345678901234567980  regua
		//         1         2         3         4         5         6
		cProduto := Subs(aProdAux[i,1],01,15)
		cArm     := Subs(aProdAux[i,1],16,02)
		cEnd     := Subs(aProdAux[i,1],18,15)
		cLote    := Subs(aProdAux[i,1],33,10)
		cSLote   := Subs(aProdAux[i,1],43,06)
		cNumSeri := Subs(aProdAux[i,1],49,20)


		If Localiza(cProduto)
			nSaldo := SaldoSBF(cArm,cEnd,cProduto,cNumSeri,cLote,cSlote)
		ElseIf Rastro(cProduto)
			nSaldo := SaldoLote(cProduto,cArm,cLote,cSLote,.F.)
		Else
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial('SB2')+cProduto+cArm))
			nSaldo := SaldoSB2(,.F.)
		EndIf
		If Str(aProdAux[i,2],12,4) == Str(nSaldo,12,4)
			nPos := Ascan(aProdOK,{|x| x[1] == aProdAux[i,1]})
			If nPos== 0
				aadd(aProdOk,{aProdAux[i,1],aProdAux[i,2]})
			EndIf
			nPos := ascan(aProdEnd,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==cProduto+cLote+cSLote+cArm+cEnd+cNumSeri })
			If npos > 0
				aDel(aProdEnd,nPos)
				aSize(aProdEnd,len(aProdEnd)-1)
			EndIf
		Else
			nPos := Ascan(aProdNoOK,{|x| x[1] == aProdAux[i,1]})
			If nPos == 0
				aadd(aProdNoOK,{aProdAux[i,1],aProdAux[i,2]})
			EndIf
		EndIf
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o status de analise indicando se esta divergente ou nao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("CBA")
	RecLock("CBA",.F.)
	If Empty(aProdNoOK)
		CBA->CBA_ANALIS := "1"
	Else
		CBA->CBA_ANALIS := "2"
	EndIf
	CBA->(MsUnLock())

	If lMonitor .and. ! Empty(aProdNoOK)
		aProdOk2 := aClone(aProdNoOk)
		aProdNoOk := {}
	Else
		If Empty(aProdNoOK) .and. ! Empty(aProdEnd)
			aProdNoOK := {STR0076} //"atribuicao simbolica somente para nao validar a contagem"
		Elseif Empty(aProdNoOK) .and. Empty(aProdEnd)
			lOK:= .t.
		EndIf
	EndIf
EndIf
Return {(len(aProdNoOK) == 0),aProdOk2,aEtiQtdOK,aEtiLidas,lOK}


Static Function AcertoInv(aProdOk,aEtiQtdOk,aEtiLidas,lMonitorInv,lAutomatico)
Local aVetor
Local nX
Local cProduto
Local cLote
Local cSLote
Local cNumSeri
Local nPos
Local cArm,cEnd
Local aEtiqueta:={}
Local lDigitaQtde := (GetMv("MV_VQTDINV") == "1")
Local dDataInv := dDataBase
Local dDtValid := ctod("")
Local aAreaSB7:=GetArea("SB7")
Private lMsHelpAuto := .T.
Private nModulo     := 4
DEFAULT lMonitorInv := .F.
DEFAULT lAutomatico := .F.

RecLock("CBA",.f.)
CBA->CBA_STATUS := "4"  // 4-finalizado
CBA->(MsUnlock())
If Empty(aProdOK) .and. Empty(aProdEnd)
	// desbloquer o inventario
	CBLoadEst(aProdEnd,.f.)
	For nX := 1 to len(aProdEnd)
		cProduto := Subs(aProdEnd[nX,1],01,15)
		CBUnBlqInv(CBA->CBA_CODINV,cProduto)
	Next
	RecLock("CBA",.f.)
	CBA->CBA_STATUS := "5"  // 5-Processado sem registro no SB7
	CBA->(MsUnlock())
	Return .t.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso a geracao do SB7 seja feita pelo windows  data a            ³
//³ ser considerada a data do mestre de inventario                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !IsTelnet()
	// Pega a data do mestre de inventario quando executador fora do coletor
	dDataInv := CBA->CBA_DATA
EndIf

For nX := 1 to len(aProdOK)
	cProduto := Subs(aProdOk[nX,1],01,15)
	cArm     := Subs(aProdOk[nX,1],16,02)
	cEnd     := Subs(aProdOk[nX,1],18,15)
	cLote    := Subs(aProdOk[nX,1],33,10)
	cSLote   := Subs(aProdOk[nX,1],43,06)
	cNumSeri := Subs(aProdOk[nX,1],49,20)
	nPos := ascan(aProdEnd,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==cProduto+cLote+cSLote+cArm+cEnd+cNumSeri})
	If npos > 0
		dDtValid := aProdEnd[npos,8]
	EndIf

	If IsTelNet()
		VTMSG(STR0077) //"Incluindo Inventario"
	EndIf

	If !AcdvGSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataInv,aProdOk[nX,2],cLote,cSLote,cNumSeri,dDtValid)
		If lAutomatico
			Aadd(aLogMestre,{CBA->CBA_CODINV,2,STR0078,.F.})//"Erro na rotina automatica:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,2,"==== == ====== ==========",.F.})
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0079+cProduto,.F.}) //"Produto: "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0080+cArm,.F.}) //"Armazem: "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0081+cEnd,.F.}) //"Endereco:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0082+cLote,.F.}) //"Lote:    "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0083+cSLote,.F.}) //"Sub-Lote:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0084+cNumSeri,.F.}) //"N.Serie: "
		Else
			MsgInTrans(2)
			MsgInTrans(1,STR0085,STR0017,.T.,5000,2) //'Erro na rotina automatica, necessario excluir esta finalizacao pelo Mestre de Inventario'###'Atencao'
		EndIf
		Return .F.
	Endif

	If npos > 0
		aDel(aProdEnd,nPos)
		aSize(aProdEnd,len(aProdEnd)-1)
	EndIf
Next

For nX := 1 to len(aProdEnd)
	conout(STR0087) //"não deve entrar"
	cProduto := aProdEnd[nX,1]
	cArm     := aProdEnd[nX,4]
	cEnd     := aProdEnd[nX,5]
	cLote    := aProdEnd[nX,2]
	cSLote   := aProdEnd[nX,3]
	cNumSeri := aProdEnd[nX,6]
	dDtValid := aProdEnd[nX,8]
	If IsTelNet()
		VTMSG(STR0077) //"Incluindo Inventario"
	EndIf
	If !AcdvGSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataInv,0,cLote,cSLote,cNumSeri,dDtValid) //GeraSB7(cProduto,cArm,cEnd,CBA->CBA_CODINV,dDataBase,0,cLote,cSLote,cNumSeri)
		If lAutomatico
			Aadd(aLogMestre,{CBA->CBA_CODINV,2,STR0078,.F.}) //"Erro na rotina automatica:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,2,"==== == ====== ==========",.F.})
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0079+cProduto,.F.}) //"Produto: "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0080+cArm,.F.}) //"Armazem: "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0081+cEnd,.F.}) //"Endereco:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0082+cLote,.F.}) //"Lote:    "
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0083+cSLote,.F.}) //"Sub-Lote:"
			Aadd(aLogMestre,{CBA->CBA_CODINV,3,STR0084+cNumSeri,.F.}) //"N.Serie: "
		Else
			MsgInTrans(2)
			MsgInTrans(1,STR0085,STR0017,.T.,5000,2) //'Erro na rotina automatica, necessario excluir esta finalizacao pelo Mestre de Inventario'###'Atencao'
		EndIf
		Return .F.
	Endif
Next

If IsGeraAcerto(lMonitorInv)
	If IsTelNet()
		VTMSG(STR0086)  //"Acerto Estoque..."
	EndIf

	SB7->(DbOrderNickName("ACDSB701"))
	If SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
		MATA340(.T.,CBA->CBA_CODINV,.F.)
	EndIf

	RestArea(aAreaSB7)
EndIf

If !IsTelnet()
	IncProc()
EndIf
Return .T.

Static Function VldMEti(nOpc,cLocal,cEtiqueta)
Local aEtiqueta := {}
Local cEtiqAux
Local cCodigo := cEtiqueta
Local aMestre:={}
Local aTela,npos
Local lRet	:= .t.
If Empty(cEtiqueta)
	Return .f.
EndIf
If nOpc==1
	If ExistBlock('CBINV01')
		cEtiqAux := ExecBlock("CBINV01",,,{cLocal,nil,cEtiqueta})
		If ValType(cEtiqAux)=="C"
			cCodigo := cEtiqAux
		EndIf
	EndIf
	If lUsaCB001
		aEtiqueta:= CbRetEti(cCodigo,"01",.T.,.T.)
		If Empty(aEtiqueta)
			VTBeep(3)
			VTAlert(STR0088,STR0002,.t.,3000) //"Etiqueta Invalida"###"Aviso"
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cLocal := CB0->CB0_LOCAL
		cCodigo:= CB0->CB0_CODPRO
	Else
		If !CBLoad128(@cEtiqueta)
			VTAlert(STR0027,STR0002,.t.,4000,3) //'Leitura invalida'###'Aviso'
			VTKeyBoard(chr(20))
			Return .f.
		Endif
		If !(CBRetTipo(cEtiqueta)$"EAN8OU13-EAN14-EAN128")
			VTALERT(STR0028,STR0002,.T.,4000,3)   //"Etiqueta invalida."###"Aviso"
			VTKeyboard(chr(20))
			Return .f.
		EndIf
		aEtiqueta := CBRetEtiEan(cEtiqueta)
		If Len(aEtiqueta) == 0
			VTAlert(STR0029,STR0002,.t.,4000,3) //'Etiqueta invalida!!'###'Aviso'
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cCodigo := aEtiqueta[01]
	EndIf
	CBA->(DbSetOrder(3)) // local+produto
Else
	If lUsaCB002
		aEtiqueta:= CbRetEti(cCodigo,"02")
		If Empty(aEtiqueta)
			VTBeep(3)
			VTAlert(STR0088,STR0002,.t.,3000) //"Etiqueta Invalida"###"Aviso"
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
		cLocal := CB0->CB0_LOCAL
		cCodigo:= CB0->CB0_LOCALI
	EndIf
	CBA->(DbSetOrder(2)) // local+endereco
	If ExistBlock('CBINV02')
		lRet := ExecBlock("CBINV02",,,{cLocal,cCodigo})
		If ValType(lRet)#"L"
			lRet := .t.
		EndIf
		If !lRet
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	EndIf
EndIf
aMestre:={}
CBA->(DbSeek(xFilial("CBA")+Str(nOpc,1)+"0"+cLocal+Padr(cCodigo,15)))
While CBA->(! EOF() .AND. xFilial("CBA")+Str(nOpc,1)+"0"+cLocal==CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL)
	If Padr(cCodigo,15) == If(nOpc ==1,CBA->CBA_PROD,CBA->CBA_LOCALI) .AND. CBA->CBA_DATA <= dDataBase
		aadd(aMestre,{CBA->CBA_CODINV,DTOC(CBA->CBA_DATA),Padr(STR0089,19),CBA->(RecNo())}) //"Nao Iniciado"
	EndIf
	CBA->(DbSkip())
	If CBA->(EOF()) .or. Padr(cCodigo,15) <> If(nOpc ==1,CBA->CBA_PROD,CBA->CBA_LOCALI)
		Exit
	EndIf
End

If ! CBA->(DbSeek(xFilial("CBA")+Str(nOpc,1)+"1"+cLocal+Padr(cCodigo,15)))
	If ! CBA->(DbSeek(xFilial("CBA")+Str(nOpc,1)+"2"+cLocal+Padr(cCodigo,15)))
		CBA->(DbSeek(xFilial("CBA")+Str(nOpc,1)+"3"+cLocal+Padr(cCodigo,15)))
	EndIf
EndIf
While CBA->(! EOF() .AND. xFilial("CBA")+Str(nOpc,1)+cLocal==CBA_FILIAL+CBA_TIPINV+CBA_LOCAL)
	If CBA->CBA_STATUS > "3"
		Exit
	EndIf
	If Padr(cCodigo,15) == If(nOpc ==1,CBA->CBA_PROD,CBA->CBA_LOCALI) .AND. CBA->CBA_DATA <= dDataBase
		aadd(aMestre,{CBA->CBA_CODINV,DTOC(CBA->CBA_DATA),Padr(STR0090,19),CBA->(RecNo())}) //"Em Andamento"
	EndIf
	CBA->(DbSkip())
	If CBA->(EOF()) .or. Padr(cCodigo,15) <> If(nOpc ==1,CBA->CBA_PROD,CBA->CBA_LOCALI)
		exit
	EndIf
End
If Empty(aMestre)
	VTBeep(3)
	VTAlert(STR0091,STR0002,.t.,3000) //"Mestre de Inventario nao encontrado"###"Aviso"
	VTKeyBoard(chr(20))
	If (nOpc==1 .and. ! lUsaCB001) .or. (nOpc==2 .and. ! lUsaCB002)
		VTClearGet("cEtiqueta")
		VTClearGet("cLocal")
		VTGetSetFocus("cLocal")
	EndIf
	Return .f.
EndIf
If Len(aMestre) > 1
	aMestre := aSort(aMestre,,,{|x,y| x[2]<y[2]})
	aTela := VtSave()
	VTClear()
	nPos :=VTaBrowse(0,0,7,19,{STR0040,STR0092,STR0093},aMestre,{06,08,19}) //"Mestre"###"Data"###"Status"
	VtRestore(,,,,aTela)
	If nPos == 0
		VTBeep(3)
		VTAlert(STR0094,STR0002,.t.,3000) //"Mestre de Inventario nao selecionado"###"Aviso"
		VTKeyBoard(chr(20))
		If (nOpc==1 .and. ! lUsaCB001) .or. (nOpc==2 .and. ! lUsaCB002)
			VTClearGet("cEtiqueta")
			VTClearGet("cLocal")
			VTGetSetFocus("cLocal")
		EndIf
		Return .f.
	EndIf
	CBA->(DbGoto(aMestre[nPos,4]))
Else
	CBA->(DbGoto(aMestre[1,4]))
EndIf

Return VldCodInv(CBA->CBA_CODINV,.f.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Informa    ³ Autor ³ Desenv. ACD         ³ Data ³ 30/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDV060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Informa()
Local aCab,aSize,aSave := VTSAVE()
Local nX
Local aTemp:={}
Local aCBC:= GetArea("CBC")

CBC->(DbSetOrder(2))
VTClear()
aCab  := {STR0009,STR0047,STR0041,STR0095,STR0096,STR0097} //"Produto"###"Armazem"###"Endereco"###"Lote"###"SubLote"###"Serie"
aSize := {15,7,15,10,7,20}
For nX:= 1 to len(aProdEnd)
	If CBC->(DbSeek(xFilial('CBC')+CBB->CBB_NUM+aProdEnd[nx,1]+aProdEnd[nx,4]+aProdEnd[nx,5]+aProdEnd[nx,2]+aProdEnd[nx,3]+aProdEnd[nx,6])) .and. CBC->CBC_CONTOK=="1"
		Loop
	EndIf
	aadd(aTemp,{aProdEnd[nx,1],aProdEnd[nx,4],aProdEnd[nx,5],aProdEnd[nx,2],aProdEnd[nx,3],aProdEnd[nx,6]})
Next
VTaBrowse(0,0,7,19,aCab,aTemp,aSize)
VtRestore(,,,,aSave)
RestArea(aCBC)
Return

//---------------------------------------
// cInvAut:= MV_INVAUT
// MV_INVAUT == '0' NAO FAZ ACERTO AUTOMATICO
// MV_INVAUT == '1' FAZ ACERTO AUTOMATICO SOMENTE PELO RADIO
// MV_INVAUT == '2' FAZ ACERTO AUTOMATICO SOMENTE PELO MONITOR
// MV_INVAUT == '3' FAZ ACERTO AUTOMATICO PELO RADIO E MONITOR
Static Function IsGeraAcerto(lMonitorInv)
Local lRet    := .F.
Local cInvAut := SuperGetMv("MV_INVAUT")
If cInvAut== '3'
	lRet := .T.
EndIf
If cInvAut=='1' .and. ! lMonitorInv
	lRet := .T.
EndIf
If cInvAut=='2' .and. lMonitorInv
	lRet := .T.
EndIf
Return lRet


Static Function IniciaCBM(aProdEnd)
Local nX
Local cProduto,cArm,cEnd,cLote,cSLote,cNumSeri,nQtdOri
Local lChkClasse := ( "1" $ CBA->( CBA_CLASSA + CBA_CLASSB + CBA_CLASSC ) )

DbSelectArea("SB3")
SB3->(DbSetOrder(1))
For nX := 1 to len(aProdEnd)
	cProduto := aProdEnd[nX,1]
	cArm     := aProdEnd[nX,4]
	cEnd     := aProdEnd[nX,5]
	cLote    := aProdEnd[nX,2]
	cSLote   := aProdEnd[nX,3]
	cNumSeri := aProdEnd[nX,6]
	nQtdOri  := aProdEnd[nX,7]

	RecLock("CBM",.T.)
	CBM->CBM_FILIAL := xFilial("CBM")
	CBM->CBM_CODINV := CBA->CBA_CODINV
	CBM->CBM_LOCAL  := cArm
	CBM->CBM_LOCALI := cEnd
	CBM->CBM_COD    := cProduto
	CBM->CBM_LOTECT := cLote
	CBM->CBM_NUMLOT := cSLote
	CBM->CBM_NUMSER := cNumSeri
	CBM->CBM_QTDORI := nQtdOri
	If lChkClasse .And. SB3->( MsSeek(xFilial("SB3")+cProduto) )
		CBM->CBM_CLASSE := SB3->B3_CLASSE
	EndIf
	CBM->(MsUnLock())
Next
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³V35VldLot ³ Autor ³ Erike Yuri da Silva   ³ Data ³ 03/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o numero do lote com o produto.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDV035                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function V35VldLot(cProduto,cLocal,cLote,cSLote)
Local cOldAlias	:= Alias()
Local aAreaSB8	:= GetArea("SB8")
Local lRet 		:= .T.
Local lVldLotErr:= If(Pergunte("MTA270",.F.),MV_PAR01 == 1,.F.) // Indica se valida a existencia do produto.

If Rastro( cProduto, "S" )
	dbSelectArea( "SB8" )
	dbSetOrder( 3 )
	If !dbSeek( xFilial( "SB8" ) + cProduto + cLocal+ cLote + cSLote, .F.) .And. lVldLotErr
		Help (" ",1,"A270LOTERR")
		lRet := .F.
	EndIf
Else
	dbSelectArea( "SB8" )
	dbSetOrder( 3 )
	If !dbSeek( xFilial( "SB8" ) + cProduto + cLocal + cLote ) .And.lVldLotErr
		Help (" ",1,"A270LOTERR")
		lRet := .F.
	EndIf
EndIf
SB8->(RestArea(aAreaSB8))
dbSelectArea(cOldAlias)
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MsgInTrans³ Autor ³ Erike Yuri da Silva   ³ Data ³ 21/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Guarda Mensagens que serao apresentadas apos a transacao.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Tipo da funcao :1=CBALERT,2-MOSTRAERRO             ³±±
±±³          ³ ExpC1 = Texto da Mensagem     - VT100 / WINDOWS            ³±±
±±³          ³ ExpC2 = Titulo da Mensagem    - VT100 / WINDOWS            ³±±
±±³          ³ ExpL1 = Mensagem centralizada - VT100                      ³±±
±±³          ³ ExpN2 = Tempo que a mensagem ficara ativada - VT100        ³±±
±±³          ³ ExpN3 = Numero de beeps - VT100                            ³±±
±±³          ³ ExpL2 = Limpa get atual - VT100                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDV035                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MsgInTrans(nTipo,cTexto,cTitulo,lCenter,nTime,nBeep,lLimpa)
STATIC __aMsg := {}
Aadd(__aMsg,{nTipo,cTexto,cTitulo,lCenter,nTime,nBeep,lLimpa})
Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ViewMsgInT³ Autor ³ Erike Yuri da Silva   ³ Data ³ 21/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualiza as mensagens que foram guardadas pela funcao     ³±±
±±³          ³ MsgInTrans.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDV035                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewMsgInT()
Local nI
For nI:=1 To Len(__aMsg)
	DO CASE
		Case __aMsg[nI,1]== 1 
			CBAlert(__aMsg[nI,2],__aMsg[nI,3],__aMsg[nI,4],__aMsg[nI,5],__aMsg[nI,6],__aMsg[nI,7])
		Case __aMsg[nI,1]== 2
			If IsTelNet()
				VTDispFile(NomeAutoLog(),.t.)
			Else
				MostraErro()
			EndIf
	END CASE
Next
__aMsg := {}
Return
