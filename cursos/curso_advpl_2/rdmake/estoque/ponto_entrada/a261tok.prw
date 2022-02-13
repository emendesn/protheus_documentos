#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261TOK �Autor  �Eduardo Barbosa     � Data �  02/12/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. Executado para confirmar a consistencia da            ���
���          � transferencia Mod2 . Ex ( 01 s� pode ir para 1P...)        ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function A261TOK()
Local _aArea	:= GetArea()
Local _lRet		:= .T.
Local _lVadLoc	:= GetMv("BH_VALLOC",.F.,.T.) 
Local _cArmzPr	:= GETMV("BH_ARMZPR",.F.,"15")//Armazem de Processo

u_GerA0003(ProcName())

For _nElem  := 1 To Len(aCols)
	If aCols[_nElem,Len(aCols[_nElem])]  // Linhas Deletadas
		Loop
	Endif
	_cLocOri := aCols[_nElem,04]	//Armazem Origem
	_cEndOri := aCols[_nElem,05]	//Endere�o Origem
	_cLocDes := aCols[_nElem,09]	//Armazem Destino
	_cEndDes := aCols[_nElem,10]	//Endere�o Destino
	//���������������������������������������������������������������Ŀ
	//�Adicionada regra para considerar tabela SZW no lugar da SX5-ZU.�
	//�����������������������������������������������������������������
	If GetMV("BH_DEPARA",.F.)
		If _lRet .AND. !u_VLDARMEND(_cLocOri, _cEndOri, _cLocDes, _cEndDes)
			_lRet := .F.
			If !IsTelnet()
				Alert("Transferencia n�o permitida. Cadastro 'De Para'. Entrar em contato com a Controladoria")
			EndIf
		EndIf
	Else
		_cArmVal := Tabela("ZU",_cLocOri, .F. )
		If !Upper(Funname()) $ "DLGV001" .AND. _lVadLoc .AND. !Empty(_cArmVal) .AND. _cLocOri <> _cLOCDes
			If !(Alltrim(_cLocDes) $ Alltrim(_cArmVal))
				_lRet := .F.
				If !IsTelnet()
					Alert("Armazem Origem e Destino Incompativeis")
				Endif
			Endif
		Endif
	Endif
	If Alltrim(_cLocOri) $ _cArmzPr .Or. Alltrim(_cLocDes) $ _cArmzPr
		If !Upper(Funname()) $ "U_APONTACD#U_AXZZ3#U_TRANSAUTO#DLGV001" .AND. !IsBlind()
			lUsrAut  	:= .F.
			aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
			For i := 1 to Len(aGrupos)
				If AllTrim(GRPRetName(aGrupos[i])) $ "MOVPROC"
					lUsrAut  := .T.
				EndIf
			Next i
			If !lUsrAut
				If ApMsgYesNo("Usuario n�o autorizado para efetuar movimenta��o em Armazem de Processo! Possui senha de libera��o?","Movimenta��o")
					IF !u_VldSenha()
						_lRet := .F.
					Endif
				Else
					_lRet := .F.
				Endif
				If !_lRet
					Alert("Usuario n�o informado ou n�o autorizado! Favor verificar com o responsavel!")
				Endif
			Endif
		Endif
	Endif
Next _nElem
RestArea(_aArea)   
Return _lRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldSenha  �Autor  �                    � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VldSenha()
Local oSenha
Local oTelAdmin
Local oUser
Local oGetSenha
Local oGetUser
Local cGetSenha	:= Space(30)
Local cGetUser	:= Space(30)
Local lRet		:= .F.
Local nRet		:= 0
Local nOpca		:= 0
Static oDlg
DEFINE MSDIALOG oDlg TITLE "Acesso" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL
 @ 001, 003 GROUP oTelAdmin TO 071, 148 PROMPT "Login" OF oDlg COLOR 0, 16777215 PIXEL
 @ 020, 045 MSGET oGetUser VAR cGetUser SIZE 087, 010 OF oDlg COLORS 0, 16777215 PIXEL
 @ 040, 045 MSGET oGetSenha VAR cGetSenha SIZE 087, 010 OF oDlg COLORS 0, 16777215 PASSWORD PIXEL 
 @ 020, 010 SAY oUser PROMPT "Usu�rio:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
 @ 040, 010 SAY oSenha PROMPT "Senha" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
 DEFINE SBUTTON oSButton1 FROM 055, 075 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
 DEFINE SBUTTON oSButton2 FROM 055, 105 TYPE 2 ACTION (oDlg:End(),nOpca:=2) ENABLE OF oDlg	    
ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	nRet := PswAdmin(cGetUser, cGetSenha)
	Do Case
		Case nRet == 0 .or. nRet == 1
			lRet := .F.
			aGrupos  	:= aClone(UsrRetGRP(,cGetUser))
			For i := 1 to Len(aGrupos)
				If AllTrim(GRPRetName(aGrupos[i])) $ "MOVPROC"
					lRet := .T.
				EndIf
			Next i
		Case nRet == 2 
			MsgAlert("Usu�rio n�o encontrado")
			lRet := .F.
		Case nRet == 3
			MsgAlert("Arquivo de senha sendo utilizado por outra esta��o")
			lRet := .F.
	EndCase
	Else
	lRet := .F.
EndIf
Return lRet  