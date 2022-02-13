User Function BloqBoni()
 
Local aArea     := GetArea()
Local aRegistros:= {}
Local lQuery    := .F.
Local cQuery    := ""
Local cAliasSC6 := "SC6"
Local cPedido   := SC5->C5_NUM    
Local cCliente  := SC5->C5_CLIENTE
Local cIndSC6   := CriaTrab(,.F.)
Local cFiltro   := ""
Local cMensagem := RetTitle("C6_NUM")
Local nFolga    := GetMV("MV_FOLGAPV")
Local nIndex    := 0
Local nQtdLib   := 0
Local lFiltro   := .F.
Local lValido   := .T.
Local lLiber    := .t.
Local ltransf   := .f.
Local NRegSC5   := SC5->(Recno())


u_GerA0003(ProcName())

MaAvalSC5("SC5",9)
SC5->(DbGoto(nRegSC5))
If lValido                                                 
	dbSelectArea("SC6")
	dbSetOrder(1)
	lQuery := .T.
	cAliasSC6 := "QUERYSC6"
	cQuery := "SELECT SC6.R_E_C_N_O_ C6RECNO,"
	cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_TES,SC6.C6_PRODUTO,SC6.C6_ITEM,SC6.C6_QTDVEN,SC6.C6_QTDEMP,SC6.C6_QTDENT,"
	cQuery += "SC6.C6_ENTREG,SC6.C6_BLQ,SC6.C6_BLOQUEI "
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 (nolock) "
	cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND "
	cQuery += " SC6.C6_NUM  ='"+cPedido+"' AND "
	cQuery += " SC6.C6_CLI  ='"+cCliente+"'"
	cQuery += " ORDER BY "+SqlOrder(SC6->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSC6, .F., .T.)
	TcSetField(cAliasSC6,"C6_ENTREG","D",8,0)
	dbSelectArea(cAliasSC6)
	DbGotop()
	
	aRegistros := {}
	While !(cAliasSC6)->(Eof()) .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And. (cAliasSC6)->C6_NUM == cPedido
		nQtdLib := ( (cAliasSC6)->C6_QTDVEN - ( (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDENT ) )
		If FtIsBonus({(cAliasSC6)->C6_PRODUTO,(cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_TES})
			nQtdLib := 0
		EndIf
		If RecLock("SC5")
			SC6->(MsGoto((cAliasSC6)->C6RECNO))
			RecLock("SC6") //Forca a atualizacao do Buffer no Top
			nQtdLib := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
			If FtIsBonus({(cAliasSC6)->C6_PRODUTO,(cAliasSC6)->C6_QTDVEN,(cAliasSC6)->C6_TES})
				nQtdLib := 0
			EndIf
			If nQtdLib >= 0
			    /*
				If ( SC5->C5_TIPLIB == "1" )
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//쿗ibera por Item de Pedido                                               �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					Begin Transaction
						MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,lLiber,lTransf)
					End Transaction
				Else
				*/
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//쿗ibera por Pedido                                                       �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸			
					Begin Transaction
						RecLock("SC6")
						SC6->C6_QTDLIB := nQtdLib
						MsUnLock()
						aadd(aRegistros,SC6->(RecNo()))
					End Transaction
				//EndIf
			EndIf
			SC6->(MsUnLock())
			SC5->(MsUnLock())
		EndIf
		
	   	dbSelectArea(cAliasSC6)
		(cAliasSC6)->(dbSkip())
	EndDo
	If ( Len(aRegistros) > 0 )
		Begin Transaction
			SC6->(MaAvLibPed(cPedido,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,.t.))
		End Transaction
	EndIf
	Begin Transaction
		SC6->(MaLiberOk({cPedido},.F.))
	End Transaction
	If nModulo == 72
		KEXF920()
	EndIf
	dbSelectArea(cAliasSC6)
EndIf
dbSelectArea(cAliasSC6)
dbCloseArea()
Ferase(cIndSC6+OrdBagExt())
dbSelectArea("SC6")

If Type("bFiltraBrw") == "B" .And. lFiltro
	Eval(bFiltraBrw)	
Endif	

RestArea(aArea)
Return(.T.)