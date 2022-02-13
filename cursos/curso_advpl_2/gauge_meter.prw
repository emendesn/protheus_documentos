//+------------------------------------------------------------+
//| Rotina | GMeter    | Autor | Robson Luiz | Data | 15.07.09 |
//+------------------------------------------------------------+
//| Descr. | Rotina para apresentar o funcionamento da         |
//|        | função Meter.                                     |
//+------------------------------------------------------------+
//| Uso    | Especifico para Oficina de Programação            |
//+------------------------------------------------------------+
User Function GMeter()
	MsgMeter( {|oMeter,oText,oDlg,lEnd| GMProcess(oMeter,oText,oDlg,@lEnd) },"Mensagem","Título",.T.)
Return

//+------------------------------------------------------------+
//| Rotina | GMProcess | Autor | Robson Luiz | Data | 15.07.09 |
//+------------------------------------------------------------+
//| Descr. | Rotina de processamento para a apresentação       |
//|        | da funcionalidade da Meter.                       |
//+------------------------------------------------------------+
//| Uso    | Especifico para Oficina de Programação            |
//+------------------------------------------------------------+
Static Function GMProcess(oMeter,oText,oDlg,lEnd)
	Local nLastRec := 0
	Local nCOUNT := 0
	
	SX5->(dbSetOrder(1))
	SX5->(dbGoTop())
	
	nLastRec := SX5->(RecCount())
	oMeter:nTotal := nLastRec
	
	While !SX5->(EOF())
		If lEnd
			MsgAlert(cCancel)
			Exit
		Endif
		nCOUNT++
		IncMeter(oMeter,oText,nCOUNT,"Processando registro: "+LTrim(Str(nCOUNT))+" de "+LTrim(Str(nLastRec)))
		SX5->(dbSkip())
	End
Return

//+------------------------------------------------------------+
//| Rotina | IncMeter  | Autor | Robson Luiz | Data | 15.07.09 |
//+------------------------------------------------------------+
//| Descr. | Rotina para incrementar o gauge do Metera         |
//+------------------------------------------------------------+
//| Uso    | Especifico para Oficina de Programação            |
//+------------------------------------------------------------+
Static Function IncMeter(oMeter,oText,nCount,cText)
	oText:SetText( cText )
	bBlock:={|| oMeter:Set(nCount), SysRefresh() }
	EVAL(bBlock)
Return