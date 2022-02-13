#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT260TOK �Autor  �Eduardo Barbosa      � Data �  02/12/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E.localizado na confirma��o da Dialog na fun��o A260TudoOK���
���          �� executada ao pressionar o bot�o da EnchoiceBar.           ���
���          �Validar as informa��es inseridas pelo Usu�rio              ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT260TOK()
Local _lRet		:= .T.
Local _cArmVal	:= Tabela("ZU",cLocOrig, .F. )
Local _lVadLoc	:= GetMv("BH_VALLOC",.F.,.T.) 
Local _lDePar	:= GetMV("BH_DEPARA",.F.)
Local _LocOri	:= Alltrim(cLocOrig)
Local _LizOri	:= Alltrim(cLoclzOrig)
Local _LocDes	:= Alltrim(cLocDest)
Local _LizDes	:= Alltrim(cLoclzDest)

u_GerA0003(ProcName())

If !Upper(Funname()) $ "DLGV001"
	If _lDePar
		If !u_VLDARMEND(_LocOri, _LizOri, _LocDes, _LizDes)
			_lRet := .F.
			Alert("Transferencia n�o permitida. Cadastro 'De Para'. Entrar em contato com a Controladoria")
		Endif
	ElseIf _lVadLoc .AND. !Empty(_cArmVal) .AND. Alltrim(cLocDest) <> Alltrim(_LocOri) .AND. !(Alltrim(cLocDest) $ Alltrim(_cArmVal))
		_lRet := .F.
		Alert("Armazem Origem e Destino Incompativeis")
	Endif
Endif
Return _lRet