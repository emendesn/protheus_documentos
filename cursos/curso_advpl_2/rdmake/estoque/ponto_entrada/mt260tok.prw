#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT260TOK บAutor  ณEduardo Barbosa      บ Data ณ  02/12/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณP.E.localizado na confirma็ใo da Dialog na fun็ใo A260TudoOKบฑฑ
ฑฑบ          ณษ executada ao pressionar o botใo da EnchoiceBar.           บฑฑ
ฑฑบ          ณValidar as informa็๕es inseridas pelo Usuแrio              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
			Alert("Transferencia nใo permitida. Cadastro 'De Para'. Entrar em contato com a Controladoria")
		Endif
	ElseIf _lVadLoc .AND. !Empty(_cArmVal) .AND. Alltrim(cLocDest) <> Alltrim(_LocOri) .AND. !(Alltrim(cLocDest) $ Alltrim(_cArmVal))
		_lRet := .F.
		Alert("Armazem Origem e Destino Incompativeis")
	Endif
Endif
Return _lRet