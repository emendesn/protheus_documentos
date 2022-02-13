#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IssueDataºAutor  ³                       Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Metodo ISSUE                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Issued(aParam,cosacer)
	
	Local lSeekSN	:= .F.
	Local cTicket	:= ""
	Local cQuery	:= ""
	
	Local cLog := ""
	Local nHdlSemaf := 0
	Local cRotinExc := "ISSUED"
	Local cAmrzWO
	Local cLoteCtl
	Local cNumLote
	Local aRet
	Local lErroSaldo := .F.
	Local nQuant             
    Local _cosacer := IIF(cosacer == nil,"",cosacer)
	
	DEFAULT aParam:={'02','02'}
	
   	If  !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
   		Return()
   	Endif
	
	IF empty(_cosacer)
     	RpcClearEnv()
	    RPCSETTYPE(3)
        PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
    ENDIF    
	
	cAmrzWO := GetMv("ES_ARMZWO",,"03")

	
	If SELECT("QRYZ17") > 0
		QRYZ17->(DbClosearea())
	EndIf
	
	//Faz Update de erro para tentar novamente o processamento de reserva das peças - Edson Rodrigues - 08/06/2015
	cQuery := "UPDATE "+RetSqlName("Z17")+" SET Z17_STATUS='I' WHERE Z17_STATUS='E'  AND D_E_L_E_T_='' "   //AND Z17_CSSNUM='1274764X' "
    IF !empty(_cosacer) 
    	cQuery += " AND Z17_CSSNUM='"+_cosacer+"' "
	Endif                              
	
	TcSqlExec(cQuery)
    TCRefresh(RETSQLNAME("Z17"))
	
		
	//Verifica se o cliente foi integrado com sucesso
	cQuery := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z17")+" WHERE D_E_L_E_T_='' AND Z17_STATUS = 'I' " // AND Z17_CSSNUM='1274764X' "
	IF !empty(_cosacer) 
    	cQuery += " AND Z17_CSSNUM='"+_cosacer+"' "
	Endif
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ17",.F.,.T.)
	
	QRYZ17->(DbGoTop())
	
	While QRYZ17->(!EOF())
		
		Z17->(DbGoTo(QRYZ17->NREC))
		
		cTicket		:= Z17->Z17_CSSNUM
		cProduto 	:= PADR(Alltrim(Z17->Z17_PRODUT),15," ")
		nQuant		:= Z17->Z17_QUANT
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek( xFilial("SB1")+cProduto ))
			//ERRO -> PRODUTO NAO ENCONTRADO
			RecLock("Z17",.F.)
			Z17->Z17_STATUS	:= "E"
			Z17->Z17_LOG	:= Z17->Z17_LOG + "Produto não cadastrado"+Chr(13)+Chr(10)
			Z17->(MsUnlock())
			cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ17->(DbSkip())
			
			Loop
		EndIf
		
		Z14->(DbSetOrder(2)) //Filial+Ticket+Numero de serie
		if !Z14->(DbSeek(xFilial("Z14")+Alltrim(cTicket)))
			//ERRO -> PRODUTO NAO ENCONTRADO
			RecLock("Z17",.F.)
			Z17->Z17_STATUS	:= "E"
			Z17->Z17_LOG	:= Z17->Z17_LOG + "Ticket não Localizado."+Chr(13)+Chr(10)
			Z17->(MsUnlock())
			cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ17->(DbSkip())
			Loop
		EndIf
		
		
		If Z14->Z14_WARRAN == "O" .And. !U_IsDevPP()
			Conout("Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+" fora de garantia - Produto não retornado!")
			QRYZ17->(DbSkip())
			Loop
		Endif
		
		//Reirada essa validacao para permitir gravar reserva quando for pessoa juridica. Edson Rodrigue - 06-04-15
		//If Len(Alltrim(Z14->Z14_CNPJ)) >= 12
		//	RecLock("Z17",.F.)
		//	Z17->Z17_STATUS := "U"  // não pode processar registros de CNPJ
		//	Z17->(MsUnlock())
		//	
		//	QRYZ17->(DbSkip())
		//	Loop
		//EndIf
		
		If !(Z14->Z14_CREATE $ "W|U")
			RecLock("Z17",.F.)
			Z17->Z17_STATUS := "U" // Transação ignorada -> Não processar tickets antigos não criados/Atualizados pelo webservice
			Z17->(MsUnlock())
			//CHAMA ROTINA DE RETORNO DE ERRO NO WEBSERVICE
			QRYZ17->(DbSkip())
			Loop
		EndIf
		
		If DtoS(Z14->Z14_DATA) < "20130828"
			
			RecLock("Z17",.F.)
			Z17->Z17_STATUS := "U" // Data de corte para inicio de operações de issued/unissue/outbound
			Z17->(MsUnlock())
			QRYZ17->(DbSkip())
			Loop
			
		EndIf
		
		If Z14->Z14_STATUS == "X" //ENVIO DE ACESSORIO
			RecLock("Z17",.F.)
			Z17->Z17_STATUS := "U"
			Z17->(MsUnlock())
			QRYZ17->(DbSkip())
			Loop
		EndIf
		
		If !Empty(Alltrim(Z14->Z14_PEDIDO))  //PEDIDO DE VENDA JA CRIADO
			RecLock("Z17",.F.)
			Z17->Z17_STATUS := "E"
			Z17->Z17_LOG 	:= "Pedido de venda ja criado antes de ter o processo do issued"
			Z17->(MsUnlock())
			cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ17->(DbSkip())
			Loop
		EndIf
		
		If Empty(Alltrim(Z14->Z14_NOTAE))
			//ERRO -> NÃO FOI REALIZADA NOTA FISCAL DE ENTRADA AINDA
			RecLock("Z17",.F.)			
			Z17->Z17_LOG 	:= "Nota Fiscal de Entrada não encontrada."
			Z17->(MsUnlock())
			cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ17->(DbSkip())
			Loop
		EndIf
		
		lErroSaldo := .F.
		While nQuant > 0 .And. !lErroSaldo
						
			If Z14->Z14_WARRAN == "O" .and. Z14->Z14_RECACE <> "S"
				dbSelectArea("ZA9")
				dbSetOrder(1)
				If dbSeek(xFilial("ZA9")+Z14->Z14_CSSNUM+cProduto)
					If ZA9->ZA9_PRECO > 0 
						aRet := {cAmrzWO,"","",nQuant}
					Else
						aRet := BuscaLocal(cProduto,nQuant)//"PP"					
					Endif
				Endif
			Else
				aRet := BuscaLocal(cProduto,nQuant)//"PP"
			Endif
			
			If !Empty(aRet[1])
				cLocalOri := aRet[1]
				cLoteCtl  := aRet[2]
				cNumLote := aRet[3]
				cNumSC0	:= GetSx8Num("SC0","C0_NUM")
				
				//RESERVA A PEÇA 
				a430Reserv( {1,"PD","","WS",xFilial("SC0"),"Uso Exclusivo do Webservice"},;
							cNumSC0,;
							cProduto,;
							cLocalOri,;
							IIF(nQuant > aRet[4],aRet[4],nQuant),;
							{cNumLote, cLoteCtl, "               ","                    "},;
							{},;
							{},;
							0)
				
				DbCommitAll()
				
				SC0->(DbSetOrder(1))
				If SC0->(DbSeek( xFilial("SC0")+cNumSC0+cProduto ))
					
					If SC0->C0_QUANT <> IIF(nQuant > aRet[4],aRet[4],nQuant)
						RecLock("Z17",.F.)
						Z17->Z17_STATUS := "E"
						Z17->Z17_LOG	:= Z17->Z17_LOG + " Foi tentado reservar : "+StrZero(IIF(nQuant > aRet[4],aRet[4],nQuant),2)+" mas após procedimento somente havia "+StrZero(SC0->C0_QUANT,2)+" na reserva"+Chr(13)+Chr(10)
						Z17->(MsUnlock())
						cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
						lErroSaldo := .T.
						
					EndIf
					
					
					RecLock("SC0",.F.)
					SC0->C0_XNOTAE 	:= Z14->Z14_NOTAE
					SC0->C0_XSTAT	:= "I"
					SC0->C0_XCSSNUM	:= Z14->Z14_CSSNUM
					SC0->C0_VALIDA	:= dDatabase + 60
					SC0->(MsUnlock())
					
					ConfirmSx8()
					
					RecLock("Z17",.F.)
					Z17->Z17_STATUS := "O"
					Z17->(MsUnlock())
					//-------------------------------------------
					//RESERVA GRAVADA COM SUCESSO
					//ATUALIZA STATUS BGH
					//-------------------------------------------
					
				Else
					//NÃO FOI POSSIVEL REALIZAR A RESERVA
					//CHAMAR METODO DE WEBSERVICE PARA NEGAR A RESERVA DESTE PN`
					RecLock("Z17",.F.)
					Z17->Z17_STATUS := "E"
					Z17->(MsUnlock())
					cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+"NAO FOI POSSIVEL REALIZAR A RESERVA"+"<br>"
					lErroSaldo := .T.
				EndIf
			Else
				RecLock("Z17",.F.)
				Z17->Z17_STATUS	:= "E"
				Z17->Z17_LOG	:= Z17->Z17_LOG + "Nenhum armazem com saldo suficiente para CONCLUIR reserva ("+Str(nQuant)+")"+Chr(13)+Chr(10)
				Z17->(MsUnlock())
				cLog += "Ticket: "+Z17->Z17_CSSNUM+"-"+cProduto+"<br>"+Replace(Z17->Z17_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
				lErroSaldo := .T.
			Endif
			
			nQuant -= IIF(nQuant > aRet[4],aRet[4],nQuant)
		Enddo
		
		QRYZ17->(DbSkip())
	Enddo
	
	
	if(!Empty(cLog))
		U_ACMAILJB("Erro Integração Reservas",cLog,"ISSUED",.F.)
	Endif
	
	
	IF empty(_cosacer)
    	Reset Environment
	    RpcClearEnv()
	 ENDIF   
	
	U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)
	
Return()

Static Function BuscaLocal(cProduto,nQuant)
	Local cLocal := ""
	Local aRet := U_GetArmPP(cProduto,nQuant)
	Local cLoteCtl := aRet[4]
	Local cNumLote := aRet[5]
	
	
	if(!aRet[1])
		RecLock("Z17",.F.)
		Z17->Z17_LOG := Z17->Z17_LOG+"O Produto: "+cProduto+" nao possui saldo suficiente em nenhum armazem favor verificar a disponibilidade com o departamento de compras/estoque"+Chr(13)+Chr(10)
		Z17->(MsUnlock())
	Else
		cLocal := aRet[2]
	Endif
	
Return {cLocal,cLoteCtl,cNumLote,aRet[6]}