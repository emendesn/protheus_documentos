#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UnIssueºAutor  ³                       º Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Metodo UNISSUE                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UnIssue(aParam,cosacer)
	
	Local lSeekSN	:= .F.
	Local cTicket	:= ""
	Local cQuery	:= ""
	Local cLog := ""                                                        
	
	Local nQtdeAnt
	Local nHdlSemaf := 0
	Local cRotinExc := "UNISSUE"                              
    Local _cosacer := IIF(cosacer = nil,"",cosacer)                                      
    Local _clogz18 := ""

    default aParam := {'02','02'}    

	If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
		Return()
	Endif
 
	
	IF empty(_cosacer)
    	RpcClearEnv()
	    RPCSETTYPE(3)
    	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
    Endif	                    
    
   	//Faz Update de erro para tentar novamente o processamento de exclusao de reserva das peças - Edson Rodrigues - 08/06/2015
	cQuery := "UPDATE "+RetSqlName("Z18")+" SET Z18_STATUS='I' WHERE Z18_STATUS='E'  AND D_E_L_E_T_='' "
    IF !empty(_cosacer) 
    	cQuery += " AND Z18_CSSNUM='"+_cosacer+"' "
	Endif                              
	
	TcSqlExec(cQuery)
    TCRefresh(RETSQLNAME("Z18"))
    
	
	If SELECT("QRYZ18") > 0
		QRYZ18->(DbClosearea())
	EndIf
	
	//Verifica se o cliente foi integrado com sucesso
	cQuery := "SELECT  R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z18")+" WHERE D_E_L_E_T_='' AND Z18_STATUS = 'I'"
	
	IF !empty(_cosacer) 
    	cQuery += " AND Z18_CSSNUM='"+_cosacer+"' "
	Endif
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ18",.F.,.T.)
	QRYZ18->(DbGoTop())
	
	While QRYZ18->(!EOF())
		Z18->(DbGoTo(QRYZ18->NREC))
		
		cTicket		:= Z18->Z18_CSSNUM
		cProduto 	:= PADR(Alltrim(Z18->Z18_PRODUT),15," ")
		nQuant		:= Z18->Z18_QUANT
		_clogz18    := ""
		
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek( xFilial("SB1")+cProduto ))
			//ERRO -> PRODUTO NAO ENCONTRADO
			_clogz18 := Z18->Z18_LOG + "Produto não cadastrado "+Chr(13)+Chr(10) 
			
			RecLock("Z18",.F.)
			Z18->Z18_STATUS := "E"
			Z18->Z18_LOG	:= _clogz18
			Z18->(MsUnlock())
			//cLog += "Ticket: "+Z18->Z18_CSSNUM+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			
			QRYZ18->(DbSkip())
			Loop
		EndIf
		
		Z14->(DbSetOrder(2)) //Filial+Ticket+Numero de serie
		If !Z14->(DbSeek(xFilial("Z14")+Alltrim(cTicket)))
			//ERRO -> PRODUTO NAO ENCONTRADO
			_clogz18 := Z18->Z18_LOG + "Ticket não Localizado."+Chr(13)+Chr(10) 
			
			RecLock("Z18",.F.)
			Z18->Z18_STATUS	:= "E"
			Z18->Z18_LOG	:= _clogz18
			Z18->(MsUnlock())
			//cLog += "Ticket: "+Z18->Z18_CSSNUM+"-"+cProduto+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ18->(DbSkip())
			Loop
		EndIf
		
		If Z14->Z14_WARRAN == "O" .And. !U_IsDevPP()
			Conout("Ticket: "+Z18->Z18_CSSNUM+"-"+cProduto+" em garantia - Produto não retornado!")
			QRYZ18->(DbSkip())
			Loop
		Endif
		
		//Reirada essa validacao para permitir gravar des-reserva quando for pessoa juridica. Edson Rodrigue - 06-04-15
		//If Len(Alltrim(Z14->Z14_CNPJ)) >= 12
		//	RecLock("Z18",.F.)
		//	Z18->Z18_STATUS := "U"  // Transação ignorada -> não pode processar registros de CNPJ
		//	Z18->Z18_LOG	:= Z18->Z18_LOG + "Não processa clientes CNPJ  "+Chr(13)+Chr(10)
		//	Z18->(MsUnlock())
		//	QRYZ18->(DbSkip())
		//	Loop
		//EndIf
		
		If !(Z14->Z14_CREATE$"W|U")
			_clogz18 := Z18->Z18_LOG + "Não processa ticket antigos "+Chr(13)+Chr(10)
			
			RecLock("Z18",.F.)
			Z18->Z18_STATUS := "U" // Transação ignorada -> Não processar tickets antigos não criados/Atualizados pelo webservice
			Z18->Z18_LOG	:= _clogz18
			Z18->(MsUnlock())
			//cLog += "Ticket: "+Z18->Z18_CSSNUM+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ18->(DbSkip())
			Loop
		EndIf
		
		If DtoS(Z14->Z14_DATA) < "20130828"
			RecLock("Z18",.F.)
			Z18->Z18_STATUS := "U" // Data de corte para inicio de operações de issued/unissue/outbound
			Z18->(MsUnlock())
			QRYZ18->(DbSkip())
			Loop
		EndIf
		
		
		If Empty(Alltrim(Z14->Z14_NOTAE))
		    _clogz18 := "Nota de entrada não encontrada. "+Chr(13)+Chr(10)
			RecLock("Z18",.F.)			
			Z18->Z18_LOG	:= _clogz18
			Z18->(MsUnlock())
			//cLog += "Ticket: "+Z18->Z18_CSSNUM+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
			QRYZ18->(DbSkip())
			Loop
		EndIf
		
		cQuery := "SELECT R_E_C_N_O_ AS NRECNO FROM "+RetSqlName("SC0")+" SC0 WHERE C0_FILIAL = '"+xFilial("SC0")+"' AND C0_XCSSNUM = '"+Z14->Z14_CSSNUM+"' AND C0_PRODUTO = '"+cProduto+"' AND SC0.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
		While nQuant > 0 .And. !TRB->(Eof())
			SC0->(DbGoTo(TRB->NRECNO))
			cNumSC0 := SC0->C0_NUM
			nQtdeAnt := if(nQuant > SC0->C0_QUANT - SC0->C0_QTDPED ,SC0->C0_QUANT - SC0->C0_QTDPED ,nQuant)
			
			
			If SC0->C0_XSTAT == "P"    
			    _clogz18 :=Z18->Z18_LOG + "Tentativa de Unissue para uma reserva ja atrelada a um pedido. Reserva ("+SC0->C0_NUM+") "+Chr(13)+Chr(10)
				
				RecLock("Z18",.F.)
				Z18->Z18_STATUS := "E"
				Z18->Z18_LOG	:= _clogz18
				Z18->(MsUnlock())
				//cLog += "Ticket: "+Z18->Z18_CSSNUM+"-"+cProduto+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
				TRB->(DbSkip())
				Loop
			EndIf
			
			a430Reserv( {IIF(nQtdeAnt <> nQuant,2,3),"PD","","WS",xFilial("SC0"),"Uso Exclusivo do Webservice"},;
						cNumSC0,;
						cProduto,;
						SC0->C0_LOCAL,;
						nQtdeAnt,;
						{SC0->C0_NUMLOTE ,SC0->C0_LOTECTL ,"               " ,"                    "},;
						{},;
						{},;
						0)
			
			SC0->(DbSetOrder(1))
			If SC0->(DbSeek( xFilial("SC0")+cNumSC0+cProduto ))
				If SC0->C0_QUANT - SC0->C0_QTDPED <> nQtdeAnt
					// ERRO -> Quantidade não foi retirada corretamente pelo metodo
					_clogz18 := Z18->Z18_LOG + "Quantidade não foi retirada corretamente pelo metodo "+Chr(13)+Chr(10)
					
					RecLock("Z18",.F.)
					Z18->Z18_STATUS := "E"
					Z18->Z18_LOG	:= _clogz18
					Z18->(MsUnlock())
					//cLog += "Ticket: "+Z18->Z18_CSSNUM+"-"+cProduto+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
				Else
					RecLock("Z18",.F.)
					Z18->Z18_STATUS := "O" // Ok
					Z18->(MsUnlock())
					
					RecLock("SC0",.F.)
					SC0->C0_QTDORIG := SC0->C0_QUANT
					SC0->(MsUnlock())
					
				EndIf
				
			Else
				RecLock("Z18",.F.)
				Z18->Z18_STATUS := "O" // Ok
				Z18->(MsUnlock())
				
			EndIf
			nQuant -= nQtdeAnt
			TRB->(DbSkip())
		EndDo
		TRB->(DbCloseArea())
		
		If nQuant > 0                          
		    _clogz18 := Z18->Z18_LOG + "Tentativa de Unissue uma quantidade maior que a ja reservada "+Chr(13)+Chr(10)
			RecLock("Z18",.F.)
			Z18->Z18_STATUS := "E"
			Z18->Z18_LOG	:= _clogz18
			Z18->(MsUnlock())
			//cLog += "Ticket: "+Z18->Z18_CSSNUM+"-"+cProduto+"<br>"+Replace(Z18->Z18_LOG,Chr(13)+Chr(10),"<br>")+"<br>"
		EndIf
		
		
		QRYZ18->(DbSkip())
	Enddo
	
	QRYZ18->(DbCloseArea())
	
	if(!Empty(cLog))
		U_ACMAILJB("Erro Integração Des-Reservas",cLog,cRotinExc,.F.)
	Endif
	
	IF empty(_cosacer)
     	Reset Environment
	    RpcClearEnv()
	ENDIF    
	
	U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)
	
Return()