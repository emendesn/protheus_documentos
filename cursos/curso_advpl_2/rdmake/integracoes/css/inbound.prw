#INCLUDE "PROTHEUS.CH"
#Include "TbiConn.Ch"
#INCLUDE "TRYEXCEPTION.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Inbound  ºAutor  ³                        Data ³ 24/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a tabela Z16 a procura de itens a serem processadosº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    


User Function Inbound(_aParam)

Local aPosZ14	:= {}
Local aPosZ13	:= {}
Local aAreaZ14	:= {}
Local aAreaZ13	:= {}
Local cLog	 	:= ""
Local cQuery	:= ""
Local lDados := .F.
Local nHdlSemaf := 0
Local cRotinExc := "INBOUND"           

DEFAULT _aParam:={'02','02'}

If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
	MsgStop("Já Existe Um Processo de Integração em Execução Por Outro Usuário!")
	Return()
Endif

//------------------------------ Seta a empresa e filial-----------------
If ValType(_aParam) != "U"
	If !Empty(_aParam[1]) .and. !Empty(_aParam[2])
		RPCSETTYPE(3)
		If FindFunction('WFPREPENV')
			WfPrepEnv(_aParam[1],_aParam[2])
		Else
		   Prepare Environment Empresa _aParam[1] Filial _aParam[2]
		Endif	
    EndIf
Endif	

//----------------------------------------------------------------------- 

If SELECT("QRYZ16") > 0
	QRYZ16->(DbClosearea())
EndIf                          

//Verifica se o cliente foi integrado com sucesso
cQuery := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z16")+" WHERE D_E_L_E_T_=' ' AND Z16_STATUS = 'I'"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ16",.F.,.T.)

QRYZ16->(DbGoTop())

While QRYZ16->(!EOF())

	Z16->(DbGoTo(QRYZ16->NREC))
	lDados := .T.
	cTicket		:= Alltrim(Z16->Z16_CSSNUM)
	cSerialN	:= Alltrim(Z16->Z16_SERIE)

	If SELECT("QRYZ14") > 0
		QRYZ14->(DbClosearea())
	EndIf
	//Verifica se o cliente foi integrado com sucesso
	cQryZ14 := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z14")+" WHERE D_E_L_E_T_=' ' AND RTRIM(Z14_CSSNUM) = '"+cTicket+"' "
	cQryZ14 := ChangeQuery(cQryZ14)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ14),"QRYZ14",.F.,.T.)
	lSeekSN	:= QRYZ14->(!EOF())  // .T. -> Achou  e .F. -> Não achou

	If lSeekSN

		Z14->(DbGoTo(QRYZ14->(NREC))) // Posiciona no RECNO

		If !Empty(Alltrim(Z14->Z14_NOTAE))
			RecLock("Z16",.F.)
			Z16->Z16_STATUS := "E"  // A = Ticket ja existia e ja possuia NF de entrada
			Z16->Z16_LOG := Z16->Z16_LOG + "Nota de entrada ja existia para o ticket"+Chr(13)+Chr(10)
			Z16->(MsUnlock())
			// TABELA DE LOGS -> MAS NÃO É UM ERRO DO WEBSERVICE.
			//ERRO -> INBOUND PRA UM TICKET JA CRIADO E COM UMA NOTA DE ENTRADA JA REALIZADA.
			QRYZ16->(DbSkip())
			Loop
		EndIf
	EndIf
	//*****GRAVAÇÃO Z14 ******     - INICIO                
	RecLock("Z14",!lSeekSN)

	If !lSeekSN
		Z14->Z14_FILIAL := xFilial("Z14")
		Z14->Z14_CODIGO := GetSx8Num("Z14","Z14_CODIGO")
		ConfirmSX8()
	EndIf

	aAreaZ14 := Z14->(GetArea()) 	

	Z14->Z14_NOME		:= Z16->Z16_NOME
	Z14->Z14_END		:= Z16->Z16_END
	Z14->Z14_COMPLE		:= Z16->Z16_COMPLE
	Z14->Z14_BAIRRO		:= Z16->Z16_BAIRRO
	Z14->Z14_ESTADO		:= Z16->Z16_ESTADO
	Z14->Z14_CIDADE		:= Z16->Z16_CIDADE
	Z14->Z14_CEP		:= Z16->Z16_CEP
	Z14->Z14_TIPEND		:= Z16->Z16_TIPEND
	Z14->Z14_CNPJ 		:= Z16->Z16_CNPJ
	Z14->Z14_IE	  		:= Z16->Z16_IE
	Z14->Z14_TEL		:= Z16->Z16_TEL
	Z14->Z14_EMAIL		:= IIF( Empty(Alltrim(Z16->Z16_EMAIL)),"SEMEMAIL@ACER.COM",Lower(Z16->Z16_EMAIL) )
	Z14->Z14_CSSNUM		:= Z16->Z16_CSSNUM
	Z14->Z14_SEQ		:= Z16->Z16_SEQ
	Z14->Z14_PRODUT		:= Z16->Z16_PRODUT
	Z14->Z14_QUANT		:= Z16->Z16_QUANT
	Z14->Z14_SERIE		:= Z16->Z16_SERIE
	Z14->Z14_VUNIT		:= Z16->Z16_VUNIT
	Z14->Z14_PROCES		:= " "   
	Z14->Z14_WARRAN 	:= Z16->Z16_WARRAN
	cStatus := ""
	If Len(Alltrim(Z16->Z16_CNPJ)) >= 12
		If Empty(Alltrim(Z16->Z16_IE))
			cStatus := "R"
		ElseIf Alltrim(Z16->Z16_IE) == "ISENTO"
			cStatus := "R"
		Else 
			cStatus := "J"
		EndIf
	Else 
		cStatus := " "
	EndIf

	Z14->Z14_STATUS		:= cStatus //IIF( Len(Alltrim(Z16->Z16_CNPJ)) >= 12,IIF( (Empty(Alltrim(Z16->Z16_IE)) .Or. Alltrim(Z16->Z16_IE) == "ISENTO"),"R","J" )," " )
	Z14->Z14_ARQUIV		:= Z16->Z16_ARQUIV
	Z14->Z14_DATA		:= dDataBase
	If !lSeekSN
		Z14->Z14_CREATE := "W"
	Else
		Z14->Z14_CREATE := IIF(Z14->Z14_CREATE == "F","U","W")
	EndIf
	Z14->(MsUnlock())

	//Verificação da tabela de CUSTOMER(Cliente)

	Z13->(DbSetOrder(4))
	lSeekZ13 :=  Z13->( dbseek(xFilial("Z13") + Z14->Z14_CNPJ )) // Caso encontre

	If !lSeekZ13
		Z13->(DbSetOrder(3))                  	
		lSeekZ13 :=  Z13->( DbSeek(xFilial("Z13") + Alltrim(Upper(Z14->Z14_NOME))) )
		IIF(Alltrim(Z14->Z14_NOME)==Alltrim(Z13->Z13_NOME),_lSeek := .T.,_lSeek := .F.) // Alteração - Andre Jaar - _lSeek ficava .T. Quando os 25 primeiros caracteres coincidiam
	EndIf

	RecLock("Z13",!lSeekZ13)
	If !lSeekZ13
		Z13->Z13_FILIAL := xFilial("Z13")
		Z13->Z13_CODIGO := GetSx8Num("Z13","Z13_CODIGO")
		ConfirmSX8()
	EndIf

	Z13->Z13_NOME  	:= Z16->Z16_NOME
	Z13->Z13_END   	:= Z16->Z16_END
	Z13->Z13_COMPLE	:= Z16->Z16_COMPLE
	Z13->Z13_BAIRRO	:= Z16->Z16_BAIRRO
	Z13->Z13_ESTADO	:= Z16->Z16_ESTADO
	Z13->Z13_CIDADE	:= Z16->Z16_CIDADE
	Z13->Z13_CEP   	:= Z16->Z16_CEP
	Z13->Z13_CNPJ  	:= Z16->Z16_CNPJ
	Z13->Z13_IE    	:= Z16->Z16_IE
	Z13->Z13_TEL   	:= Z16->Z16_TEL
	Z13->Z13_EMAIL 	:= IIF( Empty(Alltrim(Z16->Z16_EMAIL)),"SEMEMAIL@ACER.COM",Lower(Z16->Z16_EMAIL) )
	Z13->(MsUnlock())
	//*****GRAVAÇÃO Z13 ******     - FIM
	If Len(Alltrim(Z16->Z16_CNPJ)) >= 12
		RecLock("Z16",.F.)
		Z16->Z16_STATUS := "U"  //ignora a transação
		Z16->Z16_LOG 	:= Z16->Z16_LOG + "Transação será ignorada por ser de cliente CNPJ"+Chr(13)+Chr(10)	 
		Z16->(MsUnlock()) 	 

		QRYZ16->(DbSkip())		
		Loop                 		
	EndIf	
	//Chamada função para criação de cliente
	u_CSS03ENT(.F.,Z13->Z13_CNPJ,.T.)
	
	If SELECT("INBOUNDSA1") > 0
		INBOUNDSA1->(DbClosearea())
	EndIf
	//Verifica se o cliente foi integrado com sucesso
	cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_='' AND A1_CGC = '"+Alltrim(Z13->Z13_CNPJ)+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"INBOUNDSA1",.F.,.T.)
	//**********GRAVAR STATUS NA Z14 E NA Z13 e Z16
	RecLock("Z16",.F.)            
	Z16->Z16_STATUS := IIf(INBOUNDSA1->(!Eof()),"P","C")  //6 = Integrado(WS) e cliente OK  / E = Erro
	If INBOUNDSA1->(Eof())
		Z16->Z16_LOG 	:= Z16->Z16_LOG + "Erro ao cadastrar o cliente"+Chr(13)+Chr(10)	 
	EndIf
	Z16->(MsUnlock())                                                             

	RestArea(aAreaZ14)
	RecLock("Z14",.F.)
	Z14->Z14_STATUS := IIf(INBOUNDSA1->(!Eof()),IIF(Len(Alltrim(Z16->Z16_CNPJ)) >= 12,"J"," "),"C")  //J = Integrado(WS) // C = Integrado com sucesso - Erro ao criar cliente 
	Z14->(MsUnlock())                                                                       

	RecLock("Z13",.F.)
	Z13->Z13_STATUS := IIf(INBOUNDSA1->(!Eof()),IIF(Len(Alltrim(Z16->Z16_CNPJ)) >= 12,"M","A"),"C")  //M = Necessita processamento manual | A= Aguardar Webservice  / C = Integrado com sucesso - Erro ao criar cliente
	Z13->(MsUnlock()) 		                                                         
	
	INBOUNDSA1->(DbCloseArea())
	
	
	
				
	QRYZ16->(DbSkip())
End

If SELECT("QRYZ14") > 0
	QRYZ14->(DbClosearea())
EndIf

IF ValType(_aParam) != "U" .And. lDados
   U_ACMAILJB("Integração de Tickets","Integração de Tickets finalizada com sucesso.",cRotinExc,.F.)
Endif

If ValType(_aParam) != "U"
	If !Empty(_aParam[1]) .and. !Empty(_aParam[2])
    	  Reset Environment
	endif
endif

U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)

Return()