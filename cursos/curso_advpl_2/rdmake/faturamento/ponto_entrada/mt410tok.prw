/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410TOK  ºAutor  ³Carlos Vieira       º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada  na validacao do botao OK do Pedido de    º±±
±±º          ³ Venda                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT410TOK()
Local lRet		:= .T.
Local nPoscf	:= ASCAN(aHeader,{|x|x[2] = "C6_CF"})  
Local cUF		:= ""
Local cTipo		:= M->C5_TIPO
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Tipos de pedido:                   ³
³ N=Normal				Cliente     ³
³ C=Compl.Preços		Cliente     ³
³ I=Compl.ICMS			Cliente     ³
³ P=Compl.IPI			Cliente     ³
³ D=Dev.Compras			Fornecedor  ³
³ B=Utiliza Fornecedor	Fornecedor  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If cTipo $ "B/D"
	cUF:= Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_EST")  
Else
	cUF:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
EndIf
u_GerA0003(ProcName())
If ParamIxb[1] = 3 .or. ParamIxb[1] = 4 // Inclusao ou Alteracao do Pedido de Venda
	If !U_ValidTab(M->C5_DIVNEG,M->C5_TABELA)
		lRet := .F.
	EndIf
	If lRet //CASO A VALIDAÇÃO ACIMA NÃO SEJA ATENDIDA AJUSTE DO CFOP
		For nX:=1 to Len(aCols)
			If Left(aCols[nX,nPoscf],1) <> "5" .AND. cUF == "SP"
				aCols[nX,nPoscf]:= "5" + RIGHT(Alltrim(aCols[nX,nPoscf]),3) //5
			EndIf
			If Left(aCols[nX,nPoscf],1) <> "6" .AND. !(cUF $ "SP#EX")
				aCols[nX,nPoscf]:= "6" + RIGHT(Alltrim(aCols[nX,nPoscf]),3) //6
			EndIf
			If Left(aCols[nX,nPoscf],1) <> "7" .AND. cUF == "EX"
				aCols[nX,nPoscf]:= "7" + RIGHT(Alltrim(aCols[nX,nPoscf]),3) //"7"
			EndIf
		Next nX
	EndIf	
EndIf
If ParamIxb[1] == 1 // Exclussao do Pedido de Vendas
	dbselectarea("SZN")
	SZN->(dbSetOrder(3))
	If SZN->(dbSeek(xFilial("SZN" ) + M->C5_NUM))
		While SZN->(!eof()) .and. SZN->ZN_FILIAL == xFilial("SZN") .and. SZN->ZN_PEDVEND == M->C5_NUM
			dbselectarea("SZN")
			Begin Transaction
			RecLock("SZN",.F.)
			dbDelete()
			MSUnlock("SZN")
			End Transaction
			SZN->(dbSkip())
		EndDo
	EndIf
	lRet := .T.
EndIf
Return lRet 