#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD150VE ºAutor  ³Eduardo Barbosa     º Data ³  02/12/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E.utilizado para complementar a validação do ENDEREÇO    º±±
±±º          ³ (ORIGEM E DESTINO) na rotina de Transferência.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ACD150VE()
Local _lRet			:= .T.
Local _cArmVal		:= Tabela("ZU",cArmOri, .F. )
Local _lVadLoc		:= GetMv("BH_VALLOC",.F.,.T.)
Local _lDePara		:= GetMv("BH_DEPARA",.F.,.T.)
Local _cArmVlBlq	:= PARAMIXB[01]
Local _cEndVlBlq	:= PARAMIXB[02]
u_GerA0003(ProcName())
dbSelectArea("SBE")
dbSetOrder(1)
If dbSeek(xFilial("SBE")+_cArmVlBlq+_cEndVlBlq,.F.)
	If SBE->BE_STATUS == "3" // Bloqueado
		_lRet := .F.
		VtAlert("Endereco Bloqueado", "AVISO",.t.,4000,4) //'Endereco bloqueado'###'Aviso'
		VTKeyboard(chr(20))
	ElseIf !Upper(Funname()) $ "DLGV001" 
		If _lDePara 
			If !u_VLDARMEND(cArmOri, cEndOri, cArmDes, cEndDes)
				_lRet := .F.
				VtAlert("Transferencia não permitida. Cadastro 'De Para'. Entrar em contato com a Controladoria", "AVISO",.T.,4000,4)
				VTKeyboard(chr(20))
			EndIf
		Else
			If _lVadLoc .AND. !Empty(_cArmVal) .AND. !Empty(cArmDes) .AND. cArmOri <> cArmDes .AND. !(Alltrim(cArmDes) $ Alltrim(_cArmVal))
				_lRet := .F.
				VtAlert("Armazem Origem e Destino Incompativeis", "AVISO",.T.,4000,4) //'Endereco bloqueado'###'Aviso'
				VTKeyboard(chr(20))
			Endif
		Endif
	Endif
Endif
Return _lRet