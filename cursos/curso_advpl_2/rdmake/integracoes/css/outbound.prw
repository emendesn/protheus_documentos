#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OutBound ºAutor  ³                     º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Metodo OUTBOUND                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OutBound()
	
	Local aPosZ14	:= {}
	Local aPosZ13	:= {}
	Local cLog	 	:= ""
	Local cQuery	:= ""
	Local aAux		:= {}
	Local lCnpj		:= .F.
	Local nX
	Local nY
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02"
	
	If SELECT("QRYZ19") > 0
		QRYZ19->(DbClosearea())
	EndIf
	//Verifica se o cliente foi integrado com sucesso
	cQuery := "SELECT Z19.R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z19")+" Z19 "
	cQuery += " INNER JOIN "+RetSqlName("Z14")+" Z14 ON Z14_CSSNUM = Z19_CSSNUM AND Z14.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RetSqlName("SD1")+" SD1 ON D1_FILIAL = '"+xFilial("SD1")+"' AND D1_DOC = Z14_NOTAE AND D1_TES <> '' AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE Z19.D_E_L_E_T_='' AND Z19_STATUS = 'I'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ19",.F.,.T.)
	
	QRYZ19->(DbGoTop())
	
	While QRYZ19->(!EOF())
		
		Z19->(DbGoTo(QRYZ19->NREC))
		
		lProcessa	:= .T.
		cTicket		:= Alltrim(Z19->Z19_CSSNUM)
		cSerialN	:= Alltrim(Z19->Z19_SERIE)
		aCabec		:= {}
		aServicos	:= {}
		nPosServ	:= 0
		nCount		:= 0
		
		Z14->(DbSetOrder(2)) //Filial+Ticket+Numero de serie
		lSeekSN	:= Z14->(DbSeek(xFilial("Z14")+Alltrim(cTicket)))
		
		If !lSeekSN
			QRYZ19->(DbSkip())
			Loop
			// ERRO - TICKET NÃO ENCONTRADO
		Else
			lCnpj := IIF( Len(Alltrim(Z14->Z14_CNPJ)) >= 12,.T.,.F. )
			If lCnpj  // Não processa automáticamente CNPJ
				RecLock("Z19",.F.)
				Z19->Z19_STATUS := "U"  // Transação ignorada -> Não pode processar clientes CNPJ
				Z19->(MsUnlock())
				
				QRYZ19->(DbSkip())
				Loop
			EndIf
			
			If DtoS(Z14->Z14_DATA) < "20130828"
				
				RecLock("Z19",.F.)
				Z19->Z19_STATUS := "U" // Data de corte para inicio de operações de issued/unissue/outbound
				Z19->(MsUnlock())
				QRYZ19->(DbSkip())
				Loop
				
			EndIf
			
			If Z14->Z14_STATUS == "X" //ENVIO DE ACESSORIO
				RecLock("Z19",.F.)
				Z19->Z19_STATUS := "U"
				Z19->(MsUnlock())
				QRYZ19->(DbSkip())
				Loop
			EndIf
			
			If SELECT("QRYZ17") > 0
				QRYZ17->(DbClosearea())
			EndIf
			//Verifica se existe issued pendentes a serem processados
			cQuery := "SELECT * FROM "+RetSqlName("Z17")+" Z17 WHERE Z17_STATUS = 'I' AND Z17.D_E_L_E_T_ = '' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ17",.F.,.T.)
			If QRYZ17->(!EOF())
				u_Issued()
			EndIf
			
			If SELECT("QRYZ18") > 0
				QRYZ18->(DbClosearea())
			EndIf
			//Verifica se existe unissue pendentes a serem processados
			cQuery := "SELECT * FROM "+RetSqlName("Z18")+" Z18 WHERE Z18_STATUS = 'I' AND Z18.D_E_L_E_T_ = '' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ18",.F.,.T.)
			If QRYZ18->(!EOF())
				u_UnIssue()
			EndIf
			
			If Empty(Alltrim(Z14->Z14_PEDIDO))
				lAchouSC5	:= .F.
				cPedido 	:= GetSx8Num("SC5","C5_NUM")
			Else
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(xFilial("SC5")+Alltrim(Z14->Z14_PEDIDO)))
					If Empty(SC5->C5_NOTA)
						lAchouSC5	:= .T.
						cPedido 	:= Z14->Z14_PEDIDO
						
					Else
						RecLock("Z19",.F.)
						Z19->Z19_STATUS := "U"  // Transação ignorada -> Ja possui nota fiscal
						Z19->Z19_LOG 	:= "Pedido ja foi totalmente faturado"
						Z19->(MsUnlock())
						
						QRYZ19->(DbSkip())
						Loop
					EndIf
					
					RecLock("Z19",.F.)
					Z19->Z19_STATUS := "E"  // Ja Existe um pedido relacionado ao ticket
					Z19->Z19_LOG := "Foi tentando realizar um outbound para um ticket que ja continha um pedido efetuado"
					Z19->(MsUnlock())
					
					QRYZ19->(DbSkip())
					Loop
					
				Else
					RecLock("Z19",.F.)
					Z19->Z19_STATUS := "U"
					Z19->Z19_LOG 	:= "Existe pedido gravado no Z14_PEDIDO mas este não existe na SC5"
					Z19->(MsUnlock())
					
					QRYZ19->(DbSkip())
					Loop
				EndIf
			EndIf
			
		EndIf
		
		aReserv := {}
		
		If lAchouSC5
			RecLock("Z19",.F.)
			Z19->Z19_STATUS := "E"
			Z19->Z19_LOG := "Foi tentando realizar um outbound para um ticket que ja continha um pedido efetuado"
			Z19->(MsUnlock())
			QRYZ19->(DbSkip())
			Loop
		Else
			
			If SELECT("QRYSF1") > 0
				QRYSF1->(DbClosearea())
			EndIf
			//Verifica se o cliente foi integrado com sucesso
			cQuery := "SELECT D1_ITEM,D1_IDENTB6,D1_FORNECE,D1_LOJA,F1_XNUMTIC,F1_DOC,F1_SERIE FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SD1")+" SD1 WHERE D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC"+;
				" AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA"+;
				" AND F1_FILIAL = '"+xFilial("SF1")+"' AND F1_XNUMTIC = '"+Z19->Z19_CSSNUM+"' AND D1_TES <> '' AND SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSF1",.F.,.T.)
			
			aItens := {}
			lPrim	:= .T.
			
			If QRYSF1->(EOF())
				//ERRO -> TENTANDO GERAR UMA SAIDA PARA UM TICKET QUE NÃO TEM NOTA DE ENTRADA ou não esta classificada
				QRYZ19->(DbSkip())
				Loop
				
			Else
				
				While QRYSF1->(!EOF())
					
					SB6->(DbSetOrder(3))
					If SB6->(DbSeek(xFilial("SB6")+QRYSF1->D1_IDENTB6))
						cProduto 	:= SB6->B6_PRODUTO
						nQuant		:= SB6->B6_QUANT
						nPrcUnit	:= SB6->B6_PRUNIT
						cArmazem	:= SB6->B6_LOCAL
					Else
						RecLock("Z19",.F.)
						Z19->Z19_STATUS := "E"
						Z19->Z19_LOG 	:= "Não foi possivel posicionar nos registros da SB6 para este ticket, o mesmo ja tem nota de entrada classificada"
						Z19->(MsUnlock())
						QRYZ19->(DbSkip())
						Loop
					EndIf
					
					Do Case
					
					Case cArmazem == "EC"
						cTes := GetMv("ES_TESEC",,"510")
					EndCase
					
					If lPrim
						
						aCab := {}
						
						cMensagem := " " + Substr(QRYSF1->F1_XNUMTIC,1,6)+ " - RP RET REF NFE - " + QRYSF1->F1_DOC + "- SERIE - " + QRYSF1->F1_SERIE
						dbselectarea("SA1")
						dbsetorder(1)
						dbseek(xFilial("SA1")+QRYSF1->D1_FORNECE+QRYSF1->D1_LOJA)
									
						aAdd(aCab,{"C5_FILIAL"	,xFilial("SC5")																	,Nil,""})
						aAdd(aCab,{"C5_NUM"		,cPedido																		,Nil,""})
						aAdd(aCab,{"C5_TIPO"	,"N"																			,Nil,""})
						aAdd(aCab,{"C5_CLIENTE"	,QRYSF1->D1_FORNECE					   											,Nil,""})
						aAdd(aCab,{"C5_LOJACLI"	,QRYSF1->D1_LOJA																,Nil,""})
						aAdd(aCab,{"C5_CLIENT"	,QRYSF1->D1_FORNECE					   											,Nil,""})
						aAdd(aCab,{"C5_LOJAENT"	,QRYSF1->D1_LOJA																,Nil,""})
						aAdd(aCab,{"C5_TRANSP"	,"7     "																		,Nil,""})
						aAdd(aCab,{"C5_TIPOCLI"	,SA1->A1_TIPO																	,Nil,""})
						aAdd(aCab,{"C5_CONDPAG"	,"001"																			,Nil,""})
						aAdd(aCab,{"C5_VEND1"	,"00000 "																		,Nil,""})
						aAdd(aCab,{"C5_EMISSAO"	,dDataBase																		,Nil,""})
						aAdd(aCab,{"C5_TPFRETE"	,"C"																			,Nil,""})
						aAdd(aCab,{"C5_XNUMTIC"	,QRYSF1->F1_XNUMTIC																,Nil,""})
						aAdd(aCab,{"C5_XCODCSS"	,Posicione("Z14",2,xFilial("Z14")+QRYSF1->F1_XNUMTIC,"Z14_CODIGO")				,Nil,""})
						lPrim := .F.
				
					EndIf
				
					nCount++
				
					aAdd(aAux,{"C6_FILIAL"	,xFilial("SC6")											,Nil,""})
					aAdd(aAux,{"C6_ITEM"  	,StrZero(nCount,2)										,Nil,""})
					aAdd(aAux,{"C6_PRODUTO"	,cProduto												,Nil,""})
					aAdd(aAux,{"C6_DESCRI"	,Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")	,Nil,""})
					aAdd(aAux,{"C6_QTDVEN"	,nQuant													,Nil,""})
					aAdd(aAux,{"C6_PRCVEN"	,nPrcUnit												,Nil,""})
					aAdd(aAux,{"C6_VALOR"	,nPrcUnit*nQuant										,Nil,""})
					aAdd(aAux,{"C6_TES"		,cTes													,Nil,""})
					aAdd(aAux,{"C6_VALDESC"	,0														,Nil,""})
					aAdd(aAux,{"C6_DESCONT"	,0														,Nil,""})
					aAdd(aAux,{"C6_LOCAL"	,cArmazem												,Nil,""})
					aAdd(aAux,{"C6_PRUNIT"	,nPrcUnit												,Nil,""})
					aAdd(aAux,{"C6_NUM"		,cPedido												,Nil,""})
					aAdd(aAux,{"C6_NFORI"	,QRYSF1->F1_DOC											,Nil,""})
					aAdd(aAux,{"C6_IDENTB6"	,QRYSF1->D1_IDENTB6										,Nil,""})
					aAdd(aAux,{"C6_SERIORI"	,QRYSF1->F1_SERIE										,Nil,""})
					aAdd(aAux,{"C6_ITEMORI"	,QRYSF1->D1_ITEM										,Nil,""})
					aAdd(aItens,aAux)
				
					Z16->(DbSetOrder(1))
					If Z16->(Dbseek(xFilial("Z16")+Z19->Z19_CSSNUM))
						If Z16->Z16_WARRAN == "O"
							cGrupoServ := Posicione("SBM",1,xFilial("SBM")+Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRUPO"),"BM_XSVC")
							If !Empty(cGrupoServ)
								nPosServ := aScan(aServicos,{|x| Alltrim(x[1]) == Alltrim(cGrupoServ)})
								If nPosServ > 0
									aServicos[nPosServ][2] := aServicos[nPosServ][2]+1
								Else
									AADD(aServicos,{cGrupoServ,1})
								EndIf
				
							EndIf
				
						EndIf
					Else
						RecLock("Z19",.F.)
						Z19->Z19_STATUS := "U"  // Transação ignorada -> Não pode processar clientes CNPJ
						Z19->Z19_LOG 	:= "InBound não encontrado para o ticket"
						Z19->(MsUnlock())
				
						lProcessa := .F.
						Exit
				
					EndIf
				
					QRYSF1->(Dbskip())
					aAux := {}
				Enddo
				
			EndIf

			//	QUERY DOQUE JA ESTA PRONTO NA SC0

			If SELECT("QRYSC0") > 0
				QRYSC0->(DbClosearea())
			EndIf
			//Verifica se o cliente foi integrado com sucesso
			cQuery := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SC0")+" SC0 WHERE C0_FILIAL = '"+xFilial("SC0")+"' AND RTRIM(C0_XCSSNUM) = '"+Alltrim(Z19->Z19_CSSNUM)+"' AND C0_XSTAT = 'I' "+;
				" AND SC0.D_E_L_E_T_ = '' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSC0",.F.,.T.)

			While QRYSC0->(!EOF())

				nCount++
				aAux	:= {}
				SC0->(DbGoTo(QRYSC0->NREC))
				
				AADD(aReserv,{QRYSC0->NREC,SC0->C0_QUANT})
				
				nPreco	:= SeekPrc(SC0->C0_LOCAL,SC0->C0_PRODUTO)
				
				
				xTes := &(GetMv("ES_TES"+Alltrim(SC0->C0_LOCAL),,""))
	            cTes := if(ValType(xTes)<> "C",GetMv("ES_TES"+Alltrim(SC0->C0_LOCAL),,""),xTes)
				
				aAdd(aAux,{"C6_FILIAL"	,xFilial("SC6")			 									,Nil,""})
				aAdd(aAux,{"C6_ITEM"  	,StrZero(nCount,2)											,Nil,""})
				aAdd(aAux,{"C6_PRODUTO"	,SC0->C0_PRODUTO											,Nil,""})
				aAdd(aAux,{"C6_DESCRI"	,Posicione("SB1",1,xFilial("SB1")+SC0->C0_PRODUTO,"B1_DESC"),Nil,""})
				aAdd(aAux,{"C6_QTDVEN"	,SC0->C0_QUANT												,Nil,""})
				aAdd(aAux,{"C6_PRCVEN"	,nPreco	 													,Nil,""})
				aAdd(aAux,{"C6_VALOR"	,nPreco*SC0->C0_QUANT										,Nil,""})
				aAdd(aAux,{"C6_VALDESC"	,0															,Nil,""})
				aAdd(aAux,{"C6_DESCONT"	,0															,Nil,""})
				aAdd(aAux,{"C6_LOCAL"	,SC0->C0_LOCAL												,Nil,""})
				aAdd(aAux,{"C6_TES"		,cTes														,Nil,""})
				aAdd(aAux,{"C6_PRUNIT"	,nPreco														,Nil,""})
				aAdd(aAux,{"C6_NUM"		,cPedido													,Nil,""})
				aAdd(aAux,{"C6_RESERVA"	,SC0->C0_NUM												,Nil,""})
				aAdd(aItens,aAux)
				QRYSC0->(Dbskip())
				aAux := {}
			End
			
			For nX:=1 to Len(aServicos)
			
				aAux := {}
				nCount++
				nPreco := Posicione("DA1",1,xFilial("DA1")+GetMv("ES_TABSERV",,"006")+aServicos[nX][1],"DA1_PRCVEN")
			
				aAdd(aAux,{"C6_FILIAL"	,xFilial("SC6")			 									,Nil,""})
				aAdd(aAux,{"C6_ITEM"  	,StrZero(nCount,2)											,Nil,""})
				aAdd(aAux,{"C6_PRODUTO"	,aServicos[nX][1]											,Nil,""})
				aAdd(aAux,{"C6_DESCRI"	,Posicione("SB1",1,xFilial("SB1")+aServicos[nX][1],"B1_DESC"),Nil,""})
				aAdd(aAux,{"C6_QTDVEN"	,aServicos[nX][2]											,Nil,""})
				aAdd(aAux,{"C6_PRCVEN"	,nPreco	 													,Nil,""})
				aAdd(aAux,{"C6_VALOR"	,nPreco*aServicos[nX][2]									,Nil,""})
				aAdd(aAux,{"C6_VALDESC"	,0															,Nil,""})
				aAdd(aAux,{"C6_DESCONT"	,0															,Nil,""})
				aAdd(aAux,{"C6_LOCAL"	,"DR"														,Nil,""})
				aAdd(aAux,{"C6_TES"		,"552"														,Nil,""})
				aAdd(aAux,{"C6_PRUNIT"	,nPreco														,Nil,""})
				aAdd(aAux,{"C6_NUM"		,cPedido													,Nil,""})
				aAdd(aItens,aAux)
			
			Next
			
			If lProcessa
			
				Begin Transaction
					lMsErroAuto := .F.
					MATA410(aCab,aItens,3)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se ocorreram erros para gravar log.    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lMsErroAuto
						//      Erro ao gerar o pedido
						Z14->(DbSetOrder(2))
						If Z14->( DbSeek(xFilial("Z14")+cTicket))
							RecLock("Z14",.F.)
							Z14->Z14_STATUS	:= "N"
							Z14->(MsUnlock())
			
							RecLock("Z19",.F.)
							Z19->Z19_STATUS := "E"
							Z19->Z19_LOG 	:= ""
							Z19->(MsUnlock())
						EndIf
			
					Else
			
						lGravaOk := .T.
						For nY:=1 to Len(aReserv)
							SC0->(DbGoTo(aReserv[nY][1]))
							If SC0->C0_QUANT = 0 .And. SC0->C0_QTDPED = aReserv[nY][2]
								RecLock("SC0",.F.)
								SC0->C0_XSTAT := "P"
								SC0->(MsUnlock())
							Else
								lGravaOk := .F.
								//ERRO , RESERVA NÃO PROCESSADA CORRETAMENTE!
								//ALERTAR ERRO AO USUARIO
							EndIf
						Next
			
						If (Len(aReserv) = 0) .Or. (Len(aReserv) > 0 .And. lGravaOk)
							// ALTERA STATUS DO TICKET E RELACIONA O NUMERO DO PEDIDO NA Z14
							Z14->(DbSetOrder(2))
							If Z14->( DbSeek(xFilial("Z14")+cTicket))
								RecLock("Z14",.F.)
								Z14->Z14_PEDIDO	:= cPedido
								Z14->Z14_STATUS	:= "S" // Tudo ok (Saida)
								Z14->(MsUnlock())
			
								RecLock("Z19",.F.)
								Z19->Z19_STATUS := "O" // Tudo OK
								Z19->(MsUnlock())
							Else
								//ERRO - PEDIDO CRIADO SEM ERRO NO LMSERROAUTO E NÃO ENCONTRADO
							EndIf
			
						EndIf
			
					EndIf
			
				End Transaction
			EndIf
			
		EndIf
		
		QRYZ19->(DbSkip())
	End
	
Return()

Static Function SeekPrc(cArmazem,cProduto)
	Local aRet := U_GetArmPP(cProduto,1)
	Local aSeqArmz := aRet[3]
	
	if(aScan(aSeqArmz,{|x| Alltrim(x) == Alltrim(cArmazem) })>0)
	   cTabPreco := &(GetMv("ES_TAB"+cArmazem,,""))
	   cTabPreco := if(ValType(cTabPreco)<> "C",GetMv("ES_TAB"+cArmazem,,""),cTabPreco)
	Else
		cTabPreco	:= ""
	EndIf
	
	If SELECT("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	lC_Query := " SELECT *"
	lC_Query += " FROM "+RetSqlName("DA1")+" DA1"
	lC_Query += " WHERE	DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ = ' '"
	lC_Query += " AND DA1_CODPRO = '"+cProduto+"' AND DA1_CODTAB = '"+cTabPreco+"'"
	lC_Query += " ORDER BY DA1_DATVIG DESC"
	TcQuery lC_Query New Alias "QRY"
	lN_Preco := if(!Eof(),QRY->DA1_PRCVEN,0)
	QRY->(DbCloseArea())
Return(lN_Preco)
