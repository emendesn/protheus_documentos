#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CSS002   ³ Autor ³ ROGER ALEX		    ³ Data ³ 14/03/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Manutencao do integração CSS                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGAFAT                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function Css002()
	Local aCores := {}
	Local oBrowse	:= Nil
	Private cCadastro := "Integração CSS"
	Private cAlias := "Z14"
	PRIVATE aRotina	 := MenuDef()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o Browse ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectarea("SB1")
	dbsetorder(1)
	
	dbselectarea("Z14")
	dbsetorder(1)
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z14')
	oBrowse:SetDescription(cCadastro)  //"Meta de Venda"
	
	//Legendas referentes a entrada
	oBrowse:AddLegend( "Empty(Z14_CLIENT) .And. !Z14_STATUS =='C' .And. Z14_ABORT <>'S'"	, "BR_BRANCO", "Aguardando Cliente" )
	oBrowse:AddLegend( "Empty(Z14_CLIENT) .And.  Z14_STATUS =='C' .And. Z14_ABORT <>'S'"	, "BR_VERMELHO", "Erro ao criar o cliente" )
	
	oBrowse:AddLegend( "!Empty(Z14_CLIENT) .And. Empty(Z14_NOTAE)  .And. Empty(Z14_PEDIDO) .And. Z14_ABORT <>'S'"	, "BR_VIOLETA", "Aguardando Nota de Entrada" )
	
	oBrowse:AddLegend( "!Empty(Z14_NOTAE) .And. Empty(Z14_PEDIDO) .And. !Z14_STATUS $ 'M|E' .And. Z14_ABORT <>'S'", "BR_AZUL", "Nota de entrada gerada com sucesso" )
	oBrowse:AddLegend( "Empty(Z14_NOTAE)  .And. Empty(Z14_PEDIDO)  .And. Z14_STATUS $ 'M|E' .And. Z14_ABORT <>'S'", "BR_AMARELO", "Erro ao criar nota de entrada" )
	
	
	//Legendas referentes a saida
	oBrowse:AddLegend( "!Empty(Z14_PEDIDO) .And. Z14_ABORT <>'S'"							, "BR_VERDE", "Pedido de venda criado com sucesso" )
	oBrowse:AddLegend( " Empty(Z14_PEDIDO) .And. Z14_STATUS =='N' .And. Z14_ABORT <>'S'"	, "BR_PRETO", "Erro ao Criar Pedido de venda" ) 
	
	//Legenda para ticket abortado
	oBrowse:AddLegend( "Z14_ABORT =='S'"													, "BR_MARROM", "Ticket abortado" )
		
	oBrowse:Activate()
	
Return(.T.)





/*
=============================================================================================================================================================
Programa  : MODELDEF
=============================================================================================================================================================
*/
Static Function ModelDef()
	
	
	Local oModel
	Local oStruCab := FWFormStruct(1,'Z14')
	Local bPreValid     := {|oMdl|CSS02Pre(oMdl)}
	
	oModel := MPFormModel():New('CSSMODEL',/*bPreValid*/,/*bPosValidacao*/,/*bCommit*/	,/*bCancel*/)
	oModel:AddFields('Z14CAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:SetPrimaryKey({'Z14_FILIAL','Z14_CODIGO'})
	oModel:SetDescription("Integração CSS")
	
Return(oModel)


/*
=============================================================================================================================================================
Programa  : CSS02PRE
=============================================================================================================================================================
*/
Static Function CSS02Pre(oModel)
	
Return Z14->Z14_STATUS $ " |C"



/*
=============================================================================================================================================================
Programa  : VIEWDEF
=============================================================================================================================================================
*/
Static Function ViewDef()
	
	Local oView
	
	Local oModel     := FWLoadModel('CSS002')
	Local oStruCab   := FWFormStruct(2,'Z14')
	Local aUsrBut    := {}     					// recebe o ponto de entrada
	Local aButtons	 := {}                      // botoes da enchoicebar
	Local nAuxFor    := 0                       // auxiliar do For , contador da Array aUsrBut
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('VIEW_CAB',oStruCab,'Z14CAB')
	oView:CreateHorizontalBox('SUPERIOR',100)
	oView:SetOwnerView( 'VIEW_CAB','SUPERIOR' )
Return(oView)




/*
=============================================================================================================================================================
Programa  : MENUDEF
=============================================================================================================================================================
*/
Static Function MenuDef()
	Local aRotina :={}
	Local aUsrBut :={}
	Local nX := 0
	
	ADD OPTION aRotina TITLE "Pesquisar" 	   	 	ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"      	 	ACTION 'axvisual'	        OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"         	 	ACTION 'axaltera'	        OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"         	 	ACTION 'axexclui '	        OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE "Cliente"       		ACTION 'U_CSS002CLI'	    OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Proc. Entrada"   		ACTION 'U_CSS02ENT(.F.,"",)'OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Proc. Saida"	      	ACTION 'U_CSS02SAI'			OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Saida Orçamento Apr."	ACTION 'U_CSS02FOG'			OPERATION 3	ACCESS 0
	//ADD OPTION aRotina TITLE "Dev. PP Fora Garantia" ACTION 'U_CSS02DV'			OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Dev. Peca Acer"		ACTION 'U_DEVPEAC'			OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Libera Reproc."   	ACTION 'U_CSS002RE'			OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Visual. Entrada"  	ACTION 'U_CSS002VE'			OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Visual. Saida"    	ACTION 'U_CSS002VS'			OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Integrar Tickets"    	ACTION 'U_CSS002TK'			OPERATION 9	ACCESS 0 
	ADD OPTION aRotina TITLE "Abortar"    			ACTION 'U_CSSABO'			OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Devolução Varejo"		ACTION 'U_BGHSAIVJ'			OPERATION 3	ACCESS 0
	
Return(aRotina)
/*
=============================================================================================================================================================
Programa  : CSSABO
=============================================================================================================================================================
*/
User Function CSSABO()

Local aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Local lUsrAut   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a fazer troca de IMEI
	If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#CSSLIDER"
		lUsrAut  := .T.
	EndIf
	
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bloqueio de usuario sem acesso                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lUsrAut
	MsgStop("Usuário sem permissão para utilizar essa rotina favor entrar em contato com a área de TI")
	Return
EndIf

If Z14->Z14_WARRAN == "O" .OR. Z14->Z14_WARRAN == "B"
	If (MsgYesNo("Deseja abortar o processo do ticket?"))	
		If Reclock("Z14",.F.)
		    Z14->Z14_ABORT := "S"			
			Z14->Z14_LOG := "Abortado pelo usuário : "+ALLTRIM(CUSERNAME)+" em :"+Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")
			Z14->(MsUnlock())
		EndIf	
	EndIf
Else
	Alert("Ticket em garantia não pode ser abortado.")	
EndIf

Return

/*
=============================================================================================================================================================
Programa  : CSS002VE
=============================================================================================================================================================
*/
User Function CSS002VE()
	dbselectarea("SF1")
	set filter to F1_FILIAL=Z14->Z14_FILIAL .AND. F1_XCODCSS = Z14->Z14_CODIGO
	MATA103()
	dbselectarea("SF1")
	set filter to
Return



/*
=============================================================================================================================================================
Programa  : CSS002VS
=============================================================================================================================================================
*/
User Function CSS002VS()
	dbselectarea("SC5")
	set filter to C5_FILIAL=Z14->Z14_FILIAL .AND. C5_XCODCSS = Z14->Z14_CODIGO
	MATA410()
	dbselectarea("SC5")
	set filter to
Return



/*
=============================================================================================================================================================
Programa  : CSS002FE
=============================================================================================================================================================
*/
User Function CSS002FE()
	if (MsgYesNo("Mostrar Somente Registros Pendentes na Entrada??"))
		dbselectarea("Z14")
		set filter to Z14->Z14_STATUS $ " |C|A|E"
	endif
	
Return



/*
=============================================================================================================================================================
Programa  : CSS002SE
=============================================================================================================================================================
*/
User Function CSS002SE()
	if (MsgYesNo("Mostrar Somente Registros Pendentes de Saida??"))
		dbselectarea("Z14")
		set filter to Z14->Z14_STATUS $ "P|N"
	endif
Return



/*
=============================================================================================================================================================
Programa  : CSS02ENT
=============================================================================================================================================================
*/
User Function CSS02ENT(lWsCSS,cTicket)
	
	Local nForArea := 0 , aArea := {GetArea(),SD1->(GetArea())}
	
	If lWsCSS
		If !Empty(cTicket)
			
			Z14->(DbSetOrder(2))
			If !Z14->(DbSeek(xFilial("Z14")+cTicket))
				
				//Restaura as áreas e sai do programa
				For nForArea := 1 To Len(aArea)
					RestArea(aArea[nForArea])
				Next
				
				Return()
			EndIf
			
		EndIf
		
	EndIf
	
	
	/*
	SD1->(DbOrderNickName("TICKETD1"))
	
	If SD1->(DbSeek(xFilial("SD1")+Z14->Z14_CSSNUM))
		
		Aviso("Ticket duplicado","O ticket "+Alltrim(Z14->Z14_CSSNUM)+" já foi utilizado na NF "+SD1->D1_DOC+".",{"Sair"})
		
		//Restaura as áreas e sai da função
		For nForArea := 1 To Len(aArea)
			RestArea(aArea[nForArea])
		Next
		Return()
		
	EndIf
	*/
	
	
	If Len(Alltrim(Z14->Z14_CNPJ)) >= 12  .and. Z14->Z14_IE<>"ISENTO"
		If !lWsCss
			MsgAlert("Os casos de clientes CNPJ devem ser realizados manualmente ou pela rotina de integração de xml")
			
			//Restaura as áreas e sai do programa
			For nForArea := 1 To Len(aArea)
				RestArea(aArea[nForArea])
			Next
			
			Return()
		EndIf
	EndIf
	
	if lWsCSS
		PROCSF1(.T.,lWsCSS)
	ElseIf (Z14->Z14_STATUS $ " |C|A|E|M")
		MsgRun("Processando Nota de Entrada...","",{|| CursorWait(), PROCSF1(.F.,lWsCSS) ,CursorArrow()})
	Else
		MsgAlert("Registro Já Processado ou Com problema no cadastro de clientes !!!")
	endif
	
	//Restaura as áreas e sai do programa
	For nForArea := 1 To Len(aArea)
		RestArea(aArea[nForArea])
	Next
	
Return



/*
=============================================================================================================================================================
Programa  : PROCSF1
=============================================================================================================================================================
*/
Static Function PROCSF1(lBat,lIntWs)

	Local aCabec  := {}
	Local aItens  := {}
	Local aLinha  := {}
	Local cFormul := "N"

	Private cSernfe := "3"	   
	Private cMsgErr := ""
	
	Private lProces := .F.
	Private nStack  := 0
	Private lMsg    := .F.
	Private aRet	:= {}
	
	if(!Z14->Z14_PROCES $ "S| ") .And. !lIntWs
		Return .F.
	endif
	
	If Empty(Z14->Z14_CNPJ)
	    Alert("CPF/CNPJ Em Branco!!!")
	    RecLock("Z14",.F.)
		Z14->Z14_STATUS := "C"
		Z14->Z14_LOG    := "CPF/CNPJ Em Branco"
		MsUnlock()
		Return .F.
	
	endif
	
	If SELECT("QUERYSA1") > 0
		QUERYSA1->(DbCloseArea())
	EndIf
	
	cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_='' AND A1_CGC = '"+Z14->Z14_CNPJ+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSA1",.F.,.T.)
	
	IF(QUERYSA1->(Eof()))
	//IF !SELECT("QUERYSA1") > 0
		
		nPosSA1 := 0
		QUERYSA1->(DbCloseArea())
		u_CSS03ENT(.T.,Z14->Z14_CNPJ,lIntWs,@nPosSA1)
		
		cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_='' AND A1_CGC = '"+Z14->Z14_CNPJ+"'"
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSA1",.F.,.T.)
		
	EndIf
	
	IF(!QUERYSA1->(Eof()))
	//IF SELECT("QUERYSA1") > 0
		dbselectarea("SA1")
		dbgoto(QUERYSA1->NREC)
		RecLock("Z14",.F.)
		Z14->Z14_CLIENT := SA1->A1_COD
		Z14->Z14_LOJA := SA1->A1_LOJA
		Z14->Z14_ORIGEM := "SA1"
		
		MsUnlock()
	else
		Alert("CPF/CNPJ Não Localizado no cadastro de Clientes!!!")
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := "C"
		Z14->Z14_LOG    := "CPF/CNPJ Não Localizado no cadastro de Clientes"
		MsUnlock()
		QUERYSA1->(DbClosearea())
		
		If lBat
			U_ACMAILJB("Erro Integração NFE "+Z14->Z14_CSSNUM,"CPF/CNPJ Não Localizado no cadastro de Clientes!!!","CSS002",.F.)		
		EndIf
		
		Return .f.
	endif
	QUERYSA1->(DbClosearea())
	
	
	dbselectarea("SB1")
	dbsetorder(1)
	if !(dbseek(xfilial("SB1")+Alltrim(Z14->Z14_PRODUT)))
		Alert("PN: "+Z14->Z14_PRODUT+" Não Encontrado no Cadastro de Produtos")
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := "E"                                             
		Z14->Z14_LOG    := "PN: "+Z14->Z14_PRODUT+" Não Encontrado no Cadastro de Produtos"
		Z14->(MsUnlock())
		If lBat
			U_ACMAILJB("Erro Integração NFE "+Z14->Z14_CSSNUM,"PN: "+Z14->Z14_PRODUT+" Não Encontrado no Cadastro de Produtos","CSS002",.F.)		
		EndIf
		
		Return .F.
	Endif
	
	//nao processa no schedule quando for pessoa juridica
	//If(lBat .AND. SA1->A1_PESSOA=="J" ) 
	if(lBat .AND. SA1->A1_PESSOA=="J" .and. SA1->A1_INSCR<>"ISENTO" ) // Alterado regra conforme alinhamento com o Fiscal - Edson Rodrigues 18/04/15
		Return
	endif
		
	cPerg   := "XCSSF" 
	cNumero := ""
	cNfnant := ""
	cNumNF	:= ""
	aResult := {}
	lErrAut := .F.
	lExist	:= .F.
	
	// cNumNf := if(SA1->A1_PESSOA == "F" .and. lbat,GetNfeNum("1"),"         ")
	//cNfnant := if(lbat,U_GetNfeNum("3",lBat),"         ") 
	
	/*cNfnant := U_GetNfeNum("3",lBat)
	
	IF !NFENextDoc(@cNumero,SA1->A1_COD,cNfnant)                         
	    U_retnfant(cNfnant,"3") 
	    IF lBat	      
	      U_ACMAILJB("Erro Integração NFE "+Z14->Z14_CSSNUM,"CLiente: "+SA1->A1_COD+" Não foi possivel gerar o proximo numero de Nota entrada","CSS002",.F.)		
	    Else
	       Return()
	    Endif
	ELSE
	   cNumNf := cNumero    
	ENDIF*/    
	
	If !lBat .And. SA1->A1_PESSOA == "J" .And. !lIntWs
		GERPERG(cPerg)
		If !Pergunte(cPerg)
			MsgAlert("Para pessoas juridicas é obrigatório o preenchimento do numero e serie da nota")
			Return()
		Else
			cNumNF := MV_PAR01
		EndIf
	EndIf
	
	If (SA1->A1_PESSOA == "J" .and. Alltrim(SA1->A1_INSCR) == "ISENTO") .or. SA1->A1_PESSOA == "F"  
		cFormul := "S"
	EndIf
	
	aadd(aCabec,{"F1_FILIAL"   ,Z14->Z14_FILIAL,Nil,Nil})
	aadd(aCabec,{"F1_TIPO"   ,"B",Nil,Nil})
	aadd(aCabec,{"F1_DOC"   ,cNumNf,Nil,Nil})
	aadd(aCabec,{"F1_SERIE"   ,cSernfe,Nil,Nil})
	aadd(aCabec,{"F1_FORMUL" ,cFormul,Nil,Nil})
	aadd(aCabec,{"F1_EMISSAO",dDataBase,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE",SA1->A1_COD,Nil,Nil})
	aadd(aCabec,{"F1_LOJA"   ,SA1->A1_LOJA,Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE","SPED",Nil,Nil})
	aadd(aCabec,{"F1_COND","001",Nil,Nil})
	aadd(aCabec,{"F1_EST",SA1->A1_EST,Nil,Nil})
	aadd(aCabec,{"F1_XCODCSS",Z14->Z14_CODIGO,".T.",Nil})
	
	cOPAcer := GetMv("MV_XOPACER",.F.,"A01")
	cTES 	:= Posicione("ZZJ",1,xFilial("ZZJ") + cOPAcer,"ZZJ_TESECF")
    cARMEQ  := Posicione("ZZJ",1,xFilial("ZZJ") + cOPAcer,"ZZJ_ARMENT")
    cCCUSTO := Posicione("ZZJ",1,xFilial("ZZJ") + cOPAcer,"ZZJ_CC")
    cDIVNEG := Posicione("ZZJ",1,xFilial("ZZJ") + cOPAcer,"ZZJ_DIVNEG")
	
	aadd(aLinha,{"D1_FILIAL"   ,Z14->Z14_FILIAL,Nil,Nil})
	aadd(aLinha,{"D1_DOC"   ,Alltrim(cNumNf),Nil,Nil})
	aadd(aLinha,{"D1_SERIE"   ,cSernfe,Nil,Nil})
	aadd(aLinha,{"D1_FORNECE",SA1->A1_COD,Nil,Nil})
	aadd(aLinha,{"D1_LOJA"   ,SA1->A1_LOJA,Nil,Nil})
	aadd(aLinha,{"D1_ITEM","0001",Nil,Nil})
	aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil})	
	
	//verificar a regra de armazens.
	aadd(aLinha,{"D1_LOCAL",cARMEQ,Nil,Nil})
	
	_nValUnit := Z14->Z14_VUNIT
	
	aadd(aLinha,{"D1_QUANT",iif(Z14->Z14_QUANT=0,1,Z14->Z14_QUANT),Nil,Nil})
	aadd(aLinha,{"D1_VUNIT",_nValUnit,Nil,Nil})
	aadd(aLinha,{"D1_TOTAL",Z14->Z14_QUANT * _nValUnit,Nil,Nil})	
		
	aadd(aLinha,{"D1_TES",cTES,Nil,Nil})	
	
	aadd(aLinha,{"D1_XCSSNUM",Z14->Z14_CSSNUM,Nil,Nil})
	aadd(aLinha,{"D1_CC",cCCUSTO,Nil,Nil})
	aadd(aLinha,{"D1_DIVNEG",CDIVNEG,Nil,Nil})
	
	aadd(aItens,aLinha) 	
	
	//If !lBat .And. SA1->A1_PESSOA == "J" .And. !lIntWs
	   
		
		/*lMsErroAuto:=.f.
		
		MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec, aItens,3,!lBat)
		
		If lMsErroAuto
			lErrAut := .T.
			DisarmTransaction()
		EndIf*/		
	//Else	
		aResult := U_CSSNFE(aCabec,aItens,cSernfe,!lBat)
		If Len(aResult) > 0
			cMsgErr += aResult[1][1]
			lErrAut	:= aResult[1][2] 
			lExist	:= aResult[1][3]
		EndIf 
	//EndIf
	lProces := .F.
	nStack  := 0
	lMsg    := .F.
	aRet	:= {}	
	
	If lErrAut
		
		/*if(SA1->A1_PESSOA == "F" .and. lbat)
			RollbackNum()
		endif*/		
		//DisarmTransaction()
		//U_retnfant(cNfnant,"3") 
		
		If !lExist
		
			RecLock("Z14",.F.)
			Z14->Z14_STATUS := "E"
			Z14->Z14_STATUS := "Erro na rotina automatica Protheus Mata103-Cadastro de Clientes. Favor processar manualmente e visualizar o erro " 
			MsUnlock()
			if !lBat
				MostraErro()
			Endif
			
			
			If lBat
				U_ACMAILJB("Erro Integração NFE "+Z14->Z14_CSSNUM,"Erro Integração NFE "+Z14->Z14_CSSNUM,"CSS002",.F.)		
			EndIf
		
		EndIf
		//--------------------------------------------
		//NOTA FISCAL DE ENTRADA NÃO GERADA
		//ATUALIZA STATUS BGH
		//--------------------------------------------  
		
		Return .F.
	elseif(SF1->F1_FORNECE+SF1->F1_LOJA == Z14->Z14_CLIENT+Z14->Z14_LOJA .AND. SF1->F1_TIPO == "B" .AND. SD1->D1_COD == Z14->Z14_PRODUT)
		
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := "P"
		Z14->Z14_NOTAE := SF1->F1_DOC
		Z14->Z14_SERIEE := SF1->F1_SERIE
		Z14->Z14_USERE := cUserName
		MsUnlock()
		RecLock("SF1",.F.)
		SF1->F1_XCODCSS := Z14->Z14_CODIGO
		SF1->F1_XNUMTIC := Z14->Z14_CSSNUM
		MsUnlock()
		
		/*if(SF1->F1_FORMUL == "S" .and. lbat)
			CommitNum(cNumNF,SF1->F1_SERIE)
		EndIf*/
		Conout("CSS002 -> Gravei NF "+Alltrim(cNumNF)+"-"+time())
		//--------------------------------------------
		//NOTA FISCAL DE ENTRADA GERADA COM SUCESSO.
		//ATUALIZA STATUS BGH
		//--------------------------------------------
		U_BGHAC001()//Efetua entrada massiva e gera apontamento na produção
		
		MsUnLockAll()
		Conout("CSS002 -> Entrada massiva OK "+Alltrim(cNumNF)+"-"+time())
		
		Return .T.
	endif
	
	MsUnLockAll()
	
Return



/*
=============================================================================================================================================================
Programa  : GETNFENUM
=============================================================================================================================================================
*/
User Function GetNfeNum(cSerNf,lBat)
	Local cNumNf := ""
	Local cTab	 := "01"
	Local cFilSX5 := xFilial("SF1")
	Local lContinua := .T.
	Default lBat		:= .F.
	
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	If ( MsSeek(cFilSX5+cTab+cSerNF) )
		nVezes := 0
		cNumNf := SX5->X5_DESCRI
		While ( !SX5->(MsRLock()) )
			nVezes ++
			If ( nVezes > 10 )
				IF !lBat
				    Help(" ",1,"A460FLOCK")
				ENDIF    
				lContinua := .F.
				Exit
			EndIf
			Sleep(100)
		EndDo
		
	EndIf
	
Return cNumNf



/*
=============================================================================================================================================================
Programa  : COMMITNUM
=============================================================================================================================================================
*/
Static Function CommitNum(cNumNF,cSerNf)
	
	Local cTab	 := "01"
	Local cFilSX5 := xFilial("SF1")
	dbSelectArea("SX5")
	dbSetOrder(1)
	
	If ( MsSeek(cFilSX5+cTab+cSerNF) )
		RecLock("SX5",.F.)
		SX5->X5_DESCRI  := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
		SX5->X5_DESCSPA := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
		SX5->X5_DESCENG := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
		SX5->(MsRUnLock())
	EndIf
	
Return




/*
=============================================================================================================================================================
Programa  : ROLLBACKNUM
=============================================================================================================================================================
*/
Static Function RollbackNum()
	SX5->(MsRUnLock())
Return




/*
=============================================================================================================================================================
Programa  : CSS002RE
=============================================================================================================================================================
*/
User Function CSS002RE()
	
	cQ := "SELECT F1_SERIE,F1_DOC,R_E_C_N_O_ AS NREC FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_='' AND F1_XCODCSS LIKE '"+Z14->Z14_CODIGO+"' AND F1_FILIAL='"+Z14->Z14_FILIAL+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSF1",.F.,.T.)
	IF(!QUERYSF1->(Eof()))
	//IF SELECT("QUERYSF1") > 0 
		cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SC5")+" WHERE D_E_L_E_T_='' AND C5_XCODCSS LIKE '"+Z14->Z14_CODIGO+"' AND C5_FILIAL='"+Z14->Z14_FILIAL+"'"
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC5",.F.,.T.)
		IF(QUERYSC5->(Eof()))
		//IF !SELECT("QUERYSC5") > 0
			RecLock("Z14",.F.)
			Z14->Z14_STATUS := "P"
			Z14->Z14_PEDIDO := ""
			Z14->Z14_USERS := cUserName
			MsUnLock()
		Else
			Alert("Existe Pedido de Venda Vinculado a esse Ticket, para reprocessar não poderá existir pedidos vinculados ao Ticket!!!")
		endif
		QUERYSC5->(DbClosearea())
		
		Alert("Nota de Entrada "+QUERYSF1->F1_SERIE+"-"+QUERYSF1->F1_DOC+" Vinculada a esse Ticket, para reprocessar não poderá existir notas vinculadas ao Ticket!!!")
	else
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := ""
		Z14->Z14_NOTAE := ""
		Z14->Z14_SERIEE := ""
		Z14->Z14_CLIENT := ""
		Z14->Z14_LOJA := ""
		Z14->Z14_PEDIDO := ""
		Z14->Z14_USERS := cUserName
		Z14->Z14_USERE := cUserName
		Z14->Z14_REPROC := "S"
		MsUnLock()
		MsgInfo("Reprocessamento Liberado!")
	endif
	QUERYSF1->(DbClosearea())
	
Return



/*
=============================================================================================================================================================
Programa  : CSS02SAI
=============================================================================================================================================================
*/
User Function CSS02SAI()

		
	If Z14->Z14_WARRAN == "O"
		MsgAlert("Os casos FOG devem ser realizados através da rotina Saida Orçamento Apr.!") 
		Return
	Endif	
	
	
	If Len(Alltrim(Z14->Z14_CNPJ)) >= 12
		MsgAlert("Os casos de clientes PJ (com CNPJ) devem ser realizados através da rotina Devolução Varejo!") 
		Return
	Endif	
	
	
	If Z14->Z14_WARRAN <> "O"
		If Empty(Z14->Z14_PEDIDO)
			MsgRun("Processando Pedido de Venda...","",{|| CursorWait(), PROCSC5(.F.,.F.) ,CursorArrow()})
		Else
		       MsgInfo("Pedido de venda ja gerado!")		  
		endif
	Else
		
		If !TemReserv() .Or. (TemReserv() .And. U_IsDevPP()) 
		   If Empty(Z14->Z14_PEDIDO)
			   MsgRun("Processando Pedido de Venda...","",{|| CursorWait(), PROCSC5(.F.,.F.) ,CursorArrow()})
		   Else
		       MsgInfo("Pedido de venda ja gerado!")
		   Endif
		Endif
		
	Endif
Return


Static Function TemReserv()
	Local lRet := .T.
	Local cQuery
	
	//verificar se retorna como cliente ou fornecedor...
	cQuery := " SELECT COUNT(*) COUNTZ17 FROM "+RetSqlName("Z17")+" "
	cQuery += " WHERE D_E_L_E_T_=' ' AND Z17_CSSNUM = '"+Z14->Z14_CSSNUM+"' AND Z17_FILIAL = '"+xFilial("Z17")+"' "	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
	
	lRet := TRB->COUNTZ17 > 0 
	
	If !lRet 
		If Z14->Z14_ABORT <> "S"
			MsgInfo("Pedido ainda não pode ser gerado por falta do envio/retorno das peças!!!")
		Else
			lRet := .T.
		EndIf 
	// Comentado esse Else, pois conforme definido com o Fabio Attico, as pecas apontadas serao devolvidas  com equipamento
	// mesmo sendo abortado o processo de fora de garantia
	//Else             
	//	If Z14->Z14_ABORT == "S"
			//Alert("Processo Abortado!Exclua as peças apontadas para este ticket!")      
	//		lRet := .F.
	//	EndIf	
	EndIf
			
	TRB->(dbclosearea())
	
Return lRet




/*
=============================================================================================================================================================
Programa  : IsDevPP - Verifica se o PP fora de garantia foi devolvido para faturar para o cliente.
=============================================================================================================================================================
*/

User Function IsDevPP()
	Local lRet := .T.
	Local cQuery
	Local cTes := GetMv("ES_TERETPP",,"001")
	Local cclifor := GetMv("ES_CLIACER",,"Z006HT")
	Local ccliloj := GetMv("ES_LOJACER",,"01")
	Local _cAntclfo := GetMv("ES_ANCLACE",,"Z006HT")
    Local _cAntcllj := GetMv("ES_ANLJACE",,"01")
	
	//verificar se retorna como cliente ou fornecedor...
	/*
	cQuery := " SELECT D2_COD,D2_QUANT,
	cQuery += " 	(SELECT ISNULL(SUM(D1_QUANT),0) FROM "+RetSqlName("SD1")+" "
	cQuery += " 	WHERE D_E_L_E_T_=' ' AND D1_FILIAL = D2_FILIAL AND D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA "
	cQuery += " 	AND D1_XCSSNUM = D2_XCSSNUM AND D1_TES IN "+FormatIn(cTes,';')+ ") QTDEDEV "
	cQuery += " FROM "+RetSqlName("SD2")
	cQuery += " WHERE D_E_L_E_T_=' ' AND D2_CLIENTE = '"+cclifor+"' AND D2_LOJA = '"+ccliloj+"' "
	cQuery += " AND D2_XCSSNUM = '"+Z14->Z14_CSSNUM+"' AND D2_FILIAL = '"+xFilial("SD2")+"'"
	*/
	
	//Ajuste efetuado pois o codigo do cliente não será igual o codigo do fornecedor
	cQuery := " SELECT "  + CRLF
	cQuery += "	D2_COD, " + CRLF
	cQuery += "	D2_QUANT, " + CRLF
	cQuery += "	( " + CRLF
	cQuery += "		SELECT " + CRLF
	cQuery += "			COALESCE(SUM(D1_QUANT),0) " + CRLF
	cQuery += "		FROM "+RetSqlName("SD1")+" SD1 " + CRLF
	cQuery += "		INNER JOIN "+RetSqlName("SA2")+" SA2 ON " + CRLF
	cQuery += "			A2_FILIAL='"+xFilial("SA2")+"' AND "  + CRLF
	cQuery += "			A2_COD=D1_FORNECE AND " + CRLF
	cQuery += "			A2_LOJA=D1_LOJA AND " + CRLF
	cQuery += "			SA2.D_E_L_E_T_='' " + CRLF
	cQuery += "		WHERE "  + CRLF
	cQuery += "			SD1.D_E_L_E_T_=' ' AND " + CRLF
	cQuery += "			D1_FILIAL = D2_FILIAL AND " + CRLF
	cQuery += "			D1_COD=D2_COD AND " + CRLF
	cQuery += "			D1_XCSSNUM = D2_XCSSNUM AND " + CRLF
	cQuery += "			D1_TES IN "+FormatIn(cTes,';')+ " AND " + CRLF
	cQuery += "			LEFT(A2_CGC,9)=LEFT(A1_CGC,9) " + CRLF
	cQuery += "		)  QTDEDEV " + CRLF
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON " + CRLF
	cQuery += "		A1_FILIAL='"+xFilial("SA1")+"' AND " + CRLF
	cQuery += "		A1_COD=D2_CLIENTE AND " + CRLF
	cQuery += "		A1_LOJA=D2_LOJA AND " + CRLF
	cQuery += "		SA1.D_E_L_E_T_='' " + CRLF
	cQuery += " WHERE "   + CRLF
	cQuery += "		SD2.D_E_L_E_T_=' ' AND " + CRLF
	cQuery += "		(D2_CLIENTE = '"+cclifor+"' OR D2_CLIENTE='"+_cAntclfo+"')   AND " + CRLF
	cQuery += "		(D2_LOJA = '"+ccliloj+"' OR D2_LOJA = '"+_cAntcllj+"') AND " + CRLF
	cQuery += "		D2_XCSSNUM = '"+Z14->Z14_CSSNUM+"' AND " + CRLF
	cQuery += "		D2_FILIAL = '"+xFilial("SD2")+"' "	 + CRLF
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
	
	lRet := !TRB->(Eof())
	
	If !TRB->(Eof()) 
		While !TRB->(Eof())
			If TRB->(D2_QUANT > QTDEDEV)
			    if (!UPPER(procname(1)) $ "U_ISSUED/U_UNISSUE")
				     MsgAlert("Produto "+TRB->D2_COD+" não foi devolvido!")
				Endif
				lRet := .F.
			Endif
			TRB->(DbSkip())
		Enddo	
	Else
		If procname(1) == "U_CSS02SAI" 
			If Z14->Z14_ABORT <> "S"
				If !apmsgyesno('Este ticket ainda não foi retornado para faturar. Deseja prosseguir com a devolução do equipamento?',"Ticket sem Peças")
					lRet := .F.
				Else
					lRet := .T.	
				EndIf
			Else
     			lRet := .T.	
			EndIf	
		Elseif (UPPER(procname(1)) == "U_ISSUED" .OR. UPPER(procname(1)) == "U_UNISSUE")  .and. Z14->Z14_RECACE == "S"
		       lRet := .T.
		EndIf		
	EndIf
	TRB->(dbclosearea())
	
Return lRet

/*
=============================================================================================================================================================
Programa  : PROCSC5T
=============================================================================================================================================================
*/
USER Function PROCSC5T()
	PROCSC5(.T.,.F.)
Return




/*
=============================================================================================================================================================
Programa  : PROCSC5
=============================================================================================================================================================
*/
Static Function PROCSC5(lTodos,lDevPP)
	
	Local oDlgEsp
	Local oLbx
	Local nOpca     := 0
	Local aHSF1     := {}
	Local aSF1      := {}
	Local aCpoSF1   := {}
	Local dDataDe   := CToD('01/01/00')
	Local dDataAte  := CToD('31/12/20')
	Local nCnt      := 0
	Local nPosDoc   := 0
	Local nPosSerie := 0
	Local cDocSF1   := ''
	Local cIndex    := ''
	Local cQuery    := ''
	Local cAliasSF1 := ''
	Local lRetSC0	:= .T.
	
	Private aRotina	:= {{"RETORNO","A410ProcDv",0,3},{"RETORNO","A410ProcDv",0,3},{"RETORNO","A410ProcDv",0,3}}
	Private lFornece  := IF(Z14->Z14_ORIGEM == "SA1",IIF(Z14->Z14_WARRAN=="B",.T.,.F.),.T.)
	Private lForn     := IF(Z14->Z14_ORIGEM == "SA1",.F.,.T.)
	Private cAlias := "SC5"
	Private nReg := SC5->(Recno())
	Private nOpcx := 3
	
	Private cFornece := CriaVar("F1_FORNECE",.F.)
	Private cLoja    := CriaVar("F1_LOJA",.F.)
	
	Private aItPec  := {}
	Private aItServ := {}
	
	Private aNFPec := {}
	Private aNFServ:= {}
	
	Private aCabPec := {}
	Private aAcoPec := {}
	
	Default lTodos := .F.
	
	if(!Z14->Z14_PROCES $ "S| ")
		Return .F.
	endif                        
	
	/*If Z14->Z14_CLIENT $ "Z01FH7/Z01Z7W"
    	MsgAlert("Caro Usuário, esta bloqueado qualquer tipo de retorno para o cliente ACER Z01FH7. Duvidas contate o dpto de TI")
	    Return .F.
	ENDIF*/
	
	dbselectarea("SF1")
	dbsetorder(1)
	
	if(lTodos .OR. dbseek(xfilial("SF1")+Z14->Z14_NOTAE+Z14->Z14_SERIEE+Z14->Z14_CLIENT+Z14->Z14_LOJA+IF(Z14->Z14_ORIGEM == "SA1","B","N") ))
	
		If Z14->Z14_ABORT <> "S"
			lRetSC0 := u_ValidSE1SC0()			
		EndIf	
		If lRetSC0		
			cFornece := SF1->F1_FORNECE
			cLoja    := SF1->F1_LOJA
			
			If .T. // caso necessario coloca tratamento
				Aadd( aHSF1, ' ' )
				SX3->(DbSetOrder(1))
				SX3->(DbSeek("SF1"))
				While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SF1"
					If  SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V"
						Aadd( aHSF1, X3Titulo() )
						Aadd( aCpoSF1, SX3->X3_CAMPO )
						//-- Armazena a posicao do documento e serie
						If AllTrim(SX3->X3_CAMPO) == 'F1_DOC'
							nPosDoc := Len(aHSF1)
						ElseIf AllTrim(SX3->X3_CAMPO) == 'F1_SERIE'
							nPosSerie := Len(aHSF1)
						EndIf
					EndIf
					SX3->(DbSkip())
				EndDo
				//-- Retorna as notas que atendem o filtro.
				cFornece := SF1->F1_FORNECE
				cLoja    := SF1->F1_LOJA
				
				aSF1 := A410RetNF(aCpoSF1,ctod("01/01/00"),ctod("01/01/20"),lForn,lFornece,lTodos)
				If !Empty(aSF1)
					DEFINE MSDIALOG oDlgEsp TITLE "RETORNO DE DOC DE ENTRADA" FROM 00,00 TO 300,600 PIXEL //-- Retorno de Doctos. de Entrada
					oLbx:= TWBrowse():New( 012, 000, 300, 140, NIL, ;
						aHSF1, NIL, oDlgEsp, NIL, NIL, NIL,,,,,,,,,, "ARRAY", .T. )
					oLbx:SetArray( aSF1 )
					oLbx:bLDblClick  := { || { aSF1[oLbx:nAT,1] := !aSF1[oLbx:nAT,1] }}
					oLbx:bLine := &('{ || A410Line(oLbx:nAT,aSF1) }')
					ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{|| nOpca := 1, oDlgEsp:End()},{||oDlgEsp:End()}) CENTERED
					//-- Processa Devolucao
					If nOpca == 1
						ASort( aSF1,,,{|x,y| x[1] > y[1] })
						For nCnt := 1 To Len(aSF1)
							If !aSF1[nCnt,1]
								Exit
							EndIf
							#IFDEF TOP
								If Z14->Z14_WARRAN <> "B"
									cDocSF1 += "( SD1.D1_DOC = '" + aSF1[nCnt,nPosDoc] + "' AND SD1.D1_SERIE = '" + aSF1[nCnt,nPosSerie] + "' ) OR "
								Else
									cDocSF1 += "( SD1.D1_DOC = '" + aSF1[nCnt,nPosDoc] + "' AND SD1.D1_SERIE = '" + aSF1[nCnt,nPosSerie] + "' AND SD1.D1_COD = '" + Z14->Z14_PRODUT + "') OR "
								Endif
							#ELSE
								cDocSF1 += "( SD1->D1_DOC == '" + aSF1[nCnt,nPosDoc] + "' .And. SD1->D1_SERIE == '" + aSF1[nCnt,nPosSerie] + "' ) .Or. "
							#ENDIF
						Next nCnt
						
						If !Empty(cDocSF1)
							#IFDEF TOP
								cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-3) + " )"
							#ELSE
								cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-5) + " )"
							#ENDIF
						EndIf
						
						If Z14->Z14_WARRAN <> "B"  .AND. LEN(ALLTRIM(Z14->Z14_CNPJ))<= 11 
							cq := "SELECT * FROM "+RETSQLNAME("SC6")+ " WHERE D_E_L_E_T_='' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_NFORI = '"+Z14->Z14_NOTAE+"' AND C6_SERIORI = '"+Z14->Z14_SERIEE+"' "
							cQ := ChangeQuery(cQ)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC6",.F.,.T.)
							IF(!QUERYSC6->(eof()))
							// IF SELECT("QUERYSC6") > 0
								MsgAlert("Já existe pedido de venda vinculado a nota de entrada")
							ENDIF
							QUERYSC6->(dbclosearea())
						Endif
						
						RecLock("Z14",.F.)
						Z14->Z14_STATUS := "N"
						MSUnLock()
						
						dbselectarea("SC5")
						dbsetorder(1)
						dbgotop()
						dbselectarea("SC6")
						dbsetorder(1)
						dbgotop()
						
						A410ProcDv(cAlias,nReg,nOpcx,lFornece,cFornece,cLoja,cDocSF1)
						
						MsUnLockAll()
						
						cQ := "SELECT MAX(R_E_C_N_O_) AS SC6REC FROM "+RetSqlName("SC6")+" WHERE D_E_L_E_T_='' AND C6_FILIAL='"+Z14->Z14_FILIAL+"' "+;
							"AND C6_NFORI ='"+SF1->F1_DOC+"' AND C6_SERIORI='"+SF1->F1_SERIE+"' AND C6_CLI='"+SF1->F1_FORNECE+"' AND C6_LOJA='"+SF1->F1_LOJA+"'"
						cQ := ChangeQuery(cQ)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC6",.F.,.T.)
						IF(!QUERYSC6->(eof()))  
						//IF SELECT("QUERYSC6") > 0
							dbselectarea("SC6")
							dbgoto(QUERYSC6->SC6REC)
						ENDIF
						QUERYSC6->(dbclosearea())
						
						if(SC6->C6_NFORI == SF1->F1_DOC .AND. SC6->C6_SERIORI == SF1->F1_SERIE .AND. SC5->C5_CLIENTE == SF1->F1_FORNECE .AND. SC5->C5_LOJACLI == SF1->F1_LOJA)
							RecLock("Z14",.F.)
							Z14->Z14_STATUS := "S"
							Z14->Z14_PEDIDO := SC5->C5_NUM
							Z14->Z14_USRSAI := cUserName
							MSUnLock()
							RecLock("SC5",.F.)
							SC5->C5_XCODCSS := Z14->Z14_CODIGO
							SC5->C5_XNUMTIC := Z14->Z14_CSSNUM
							MSUnLock()
							
							//--------------------------------------------
							//NOTA FISCAL DE SAIDA GERADA COM SUCESSO
							//ATUALIZA STATUS BGH
							//--------------------------------------------
							u_BGHAC002(SC5->C5_NUM,.F.)//Atualiza dados da saida massiva
							MsUnLockAll()						
							If len(aCabPec) > 0 .and. len(aAcoPec) > 0
								lMsErroAuto := .F.
								MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPec,aAcoPec,3)
								If lMsErroAuto
									MostraErro()
								Else
									MsgAlert("Pedido "+SC5->C5_NUM+" da(s) peça(s) gerado com sucesso.")
									u_BGHAC002(SC5->C5_NUM,.T.)
								Endif
							Endif						
													
								//Vinicius Leonardo - Delta Decisão
								//If !Empty(aItPecServ) 
								/*If !Empty(aItPec) .or. !Empty(aItServ)
									//u_BGHProcPV(aItPecServ)//Gera Pedido de Venda de Peças e Serviços ao cliente final 
									u_BGHProcPV(aItPec,aItServ)//Gera Pedido de Venda de Peças e Serviços ao cliente final
								EndIf*/	
						ELSE
							RecLock("Z14",.F.)
							Z14->Z14_STATUS := "P"
							Z14->Z14_USERS := cUserName
							MSUnLock()
							
							MsUnLockAll()						
							
							//--------------------------------------------
							//NOTA FISCAL DE SAIDA NÃO GERADA
							//ATUALIZA STATUS BGH
							//--------------------------------------------
							
						endif
					endif
				endif
				
			Else
				DbSelectArea("SF1")
				cIndex := CriaTrab(NIL,.F.)
				cQuery := " SF1->F1_FILIAL == '" + xFilial("SF1") + "' "
				cQuery += " .And. SF1->F1_FORNECE == '" + cFornece + "' "
				cQuery += " .And. SF1->F1_LOJA    == '" + cLoja    + "' "
				cQuery += " .And. DtoS(SF1->F1_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
				cQuery += " .And. DtoS(SF1->F1_EMISSAO) <= '" + DtoS(dDataAte) + "' .And. !Empty(F1_XCODCSS) "
				If lForn
					cQuery += " .And. !(SF1->F1_TIPO $ 'DB') "
				Else
					cQuery += " .And. SF1->F1_TIPO $ 'DB'
				EndIf
				
				IndRegua("SF1",cIndex,SF1->(IndexKey()),,cQuery)
				
				cCadastro:="retorno de conserto"
				
				If SF1->(!Eof())
					MaWndBrowse(0,0,300,600,"retorno","SF1",,aRotina,,,,.T.,,,,,,.F.)
				Else
					Alert("Nenhum documento encontrado para ser retornado!") //-- //"Atencao!"###"Nenhum documento encontrado, favor verificar os dados informados  ..."###"Ok"
				EndIf
				
				RetIndex( "SF1" )
				FErase( cIndex+OrdBagExt() )
			EndIf
			
			MsUnLockAll()
		
		EndIf
	else
		MsgAlert("Nota Fiscal de Entrada Não Localizada !!!")
	endif
	
Return




/*
=============================================================================================================================================================
Programa  : A410RETNF
=============================================================================================================================================================
*/
Static Function A410RetNF(aCpoSF1,dDataDe,dDataAte,lForn, lFornece, lTodos)
	Local aSF1      := {}
	Local aAux      := {}
	Local aAreaSF1  := SF1->(GetArea())
	Local nCnt      := 0
	Local cAliasSF1 := 'SF1'
	Local cQuery    := ''
	Local cIndex    := ''
	Local nIndexSF1 := 0
	
	#IFDEF TOP
		cAliasSF1 := GetNextAlias()
		cQuery := " SELECT * "
		cQuery += "   FROM " + RetSqlName("SF1")
		cQuery += "   WHERE F1_FILIAL  = '" + xFilial("SF1") + "' "
		if(!lTodos)
			cQuery += "     AND F1_FORNECE = '" + cFornece + "' "
			cQuery += "     AND F1_LOJA    = '" + cLoja    + "' "
			cQuery += "     AND F1_DTDIGIT BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
			If (Z14->Z14_WARRAN <> "B") .AND. (Z14->Z14_CLIENT <>'Z01FH7') 
				cQuery += "		AND F1_XCODCSS = '"+Z14->Z14_CODIGO+"' "
			/*Else
				cQuery += "		AND F1_DOC = '"+Z14->Z14_NOTAE+"' "
				cQuery += "		AND F1_SERIE = '"+Z14->Z14_SERIEE+"' "			
			*/Endif
			
			cQuery += "		AND F1_DOC = '"+Z14->Z14_NOTAE+"' "
			cQuery += "		AND F1_SERIE = '"+Z14->Z14_SERIEE+"' "			
		else
			cQuery += "     AND F1_XCODCSS    <> '      ' "
		endif
		cQuery += "     AND F1_STATUS  <> '" + Space(Len(SF1->F1_STATUS)) + "' "
		If lForn
			cQuery += " AND F1_TIPO NOT IN ('D','B')
		Else
			cQuery += " AND F1_TIPO IN ('D','B')
		EndIf
		cQuery += "     AND D_E_L_E_T_ = ' ' "
		
		If Existblock("A410RNF")
			cQuery := ExecBlock("A410RNF",.F.,.F.,{dDataDe,dDataAte,lForn,lFornece})
		EndIf
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasSF1, .F., .T. )
	#ELSE
		DbSelectArea("SF1")
		cIndex := CriaTrab(NIL,.F.)
		cQuery := " SF1->F1_FILIAL == '" + xFilial("SF1") + "' "
		cQuery += " .And. SF1->F1_FORNECE == '" + cFornece + "' "
		cQuery += " .And. SF1->F1_LOJA    == '" + cLoja    + "' "
		cQuery += " .And. DtoS(SF1->F1_DTDIGIT) >= '" + DtoS(dDataDe)  + "'"
		cQuery += " .And. DtoS(SF1->F1_DTDIGIT) <= '" + DtoS(dDataAte) + "' "
		cQuery += " .And. SF1->F1_STATUS  <> '" + Space(Len(SF1->F1_STATUS)) + "' .And. F1_XCODCSS == '"+Z14->Z14_CODIGO+"' "
		If lForn
			cQuery += " .And. !(SF1->F1_TIPO $ 'DB') "
		Else
			cQuery += " .And. SF1->F1_TIPO $ 'DB'
		EndIf
		
		If Existblock("A410RNF")
			cQuery := ExecBlock("A410RNF",.F.,.F.,{dDataDe,dDataAte,lForn,lFornece})
		EndIf
		
		IndRegua("SF1",cIndex,"F1_DOC+F1_SERIE",,cQuery)
		SF1->(DbGotop())
	#ENDIF
	
	While (cAliasSF1)->(!Eof())
		aAux := {}
		Aadd( aAux, .F. )
		For nCnt := 1 To Len(aCpoSF1)
			Aadd( aAux, &(aCpoSF1[nCnt]) )
		Next nCnt
		aAdd( aSF1, aClone(aAux) )
		(cAliasSF1)->(DbSkip())
	EndDo
	
	#IFDEF TOP
		(cAliasSF1)->(DbCloseArea())
	#ELSE
		RetIndex( "SF1" )
		FErase( cIndex+OrdBagExt() )
	#ENDIF
	
	RestArea(aAreaSF1)
	
Return aSF1




/*
=============================================================================================================================================================
Programa  : NOACENTO
=============================================================================================================================================================
*/
static FUNCTION NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"
	Local cCecid := "çÇ"
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
Return cString



/*
=============================================================================================================================================================
Programa  : CSS002BAT
=============================================================================================================================================================
*/
User Function CSS002BAT(aParam)
	Local nHdlSemaf := 0
	Local cRotinExc := "CSS002BAT"
	Local Area      := GetArea()
    Private cSernfe := "3"	
	
	
	Default aParam := {"02","02"}
	If !U_SemafWKF(cRotinExc, @nHdlSemaf, .T.)
		Return()
	Endif
	
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO "COM" TABLES "SF1","SD1","SA1","SA1","SB1","SB2","SF4"
	dbselectarea("Z14")
	// Set Filter To !Empty(Z14->Z14_CNPJ) 
	Set Filter To !Empty(Z14->Z14_CNPJ) .AND. Z14->Z14_WARRAN<>'B' .AND. Z14->Z14_DATA >= ctod("27/05/15")  // Alterado o Filtro acima para desconsiderar as OSS que vieram da ACER.
	dbgotop()
	While !Z14->(Eof())
	
	cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SC5")+" WHERE D_E_L_E_T_='' AND C5_XCODCSS LIKE '"+Z14->Z14_CODIGO+"' AND C5_FILIAL='"+Z14->Z14_FILIAL+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC5",.F.,.T.)
	IF(QUERYSC5->(Eof()))
	//IF !SELECT("QUERYSC5") > 0
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := "P"
		Z14->Z14_PEDIDO := ""
		Z14->Z14_USERS := cUserName
		MsUnLock()
	endif
	QUERYSC5->(DbClosearea())
	
	cQ := "SELECT F1_SERIE,F1_DOC,R_E_C_N_O_ AS NREC FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_='' AND F1_XCODCSS LIKE '"+Z14->Z14_CODIGO+"' AND F1_FILIAL='"+Z14->Z14_FILIAL+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSF1",.F.,.T.)
	IF(QUERYSF1->(Eof()))
    //IF !SELECT("QUERYSF1") > 0	
		RecLock("Z14",.F.)
		Z14->Z14_STATUS := ""
		Z14->Z14_NOTAE := ""
		Z14->Z14_SERIEE := ""
		Z14->Z14_CLIENT := ""
		Z14->Z14_LOJA := ""
		Z14->Z14_PEDIDO := ""
		Z14->Z14_USERS := cUserName
		Z14->Z14_USERE := cUserName
		Z14->Z14_REPROC := "S"
		MsUnLock()
	endif
	QUERYSF1->(DbClosearea())
	
	
	if (!Z14->Z14_STATUS $ "J" .And. Empty(Z14->Z14_NOTAE))
		Area := GetArea()
		PROCSF1(.T.,.T.)
		RestArea(Area)
	Endif
	
	Z14->(DbSkip())
enddo
Reset Environment
U_SemafWKF(cRotinExc, @nHdlSemaf, .F.)

Return



/*
=============================================================================================================================================================
Programa  : TCSS003E
=============================================================================================================================================================
*/
User Function TCSS003E(cTpMov)
	
	if(cTpMov="E")
		dbselectarea("SF1")
		dbsetorder(1)
		if(dbseek(Z14->Z14_FILIAL + Z14->Z14_NOTAE + Z14->Z14_SERIEE + Z14->Z14_CLIENT + Z14->Z14_LOJA+IF(Z14->Z14_ORIGEM == "SA1","B","N")))
			
			if(SF1->F1_FORMUL == "S" .AND. !empty(SF1->F1_CHVNFE))
				Return "S"
			elseif(SF1->F1_FORMUL == "S" .AND. empty(SF1->F1_CHVNFE))
				Return "N"
			elseif(SF1->F1_FORMUL <> "S")
				Return "S"
			Endif
			
		else
			Return ""
		endif
	elseif(cTpMov="S")
		
		if(empty(Z14->Z14_PEDIDO))
			Return ""
		endif
		
		cQ := " SELECT DISTINCT F2_CHVNFE FROM "+Retsqlname("SF2")+" SF2, "+Retsqlname("SD2")+" SD2 WHERE SF2.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' "+;
			" AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "+;
			" AND D2_PEDIDO='"+Z14->Z14_PEDIDO+"' AND D2_FILIAL='"+Z14->Z14_FILIAL+"' AND D2_NFORI='"+Z14->Z14_NOTAE+"' AND D2_SERIORI='"+Z14->Z14_SERIEE+"'"
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSF2",.F.,.T.)
		_cRet := ""
		If(!QUERYSF2->(Eof()))             
		//If SELECT("QUERYSF2") > 0
			if(Empty(QUERYSF2->F2_CHVNFE))
				_cRet := "N"
			else
				_cRet := "S"
			endif
		else
			_cRet := "N"
		EndIF
		QUERYSF2->(dbclosearea())
		Return _cRet
	endif
Return ""


/*
=============================================================================================================================================================
Programa  : TCSS002A
=============================================================================================================================================================
*/
User Function TCss002A()
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+M->Z14_CLIENT+M->Z14_LOJA))
	
	M->Z14_LOJA := SUBSTR(SA1->A1_LOJA,1,TAMSX3("Z14_LOJA")[1])
	M->Z14_NOME := SUBSTR(SA1->A1_NOME,1,TAMSX3("Z14_NOME")[1])
	M->Z14_END := SUBSTR(SA1->A1_END,1,TAMSX3("Z14_END")[1])
	M->Z14_COMPLE := SUBSTR(SA1->A1_COMPLEM,1,TAMSX3("Z14_COMPLE")[1])
	M->Z14_BAIRRO := SUBSTR(SA1->A1_BAIRRO,1,TAMSX3("Z14_BAIRRO")[1])
	M->Z14_ESTADO := SUBSTR(SA1->A1_EST,1,TAMSX3("Z14_ESTADO")[1])
	M->Z14_CIDADE := SUBSTR(SA1->A1_MUN,1,TAMSX3("Z14_CIDADE")[1])
	M->Z14_CEP := SUBSTR(SA1->A1_CEP,1,TAMSX3("Z14_CEP")[1])
	M->Z14_CNPJ := SUBSTR(SA1->A1_CGC,1,TAMSX3("Z14_CNPJ")[1])
	M->Z14_IE := SUBSTR(SA1->A1_INSCR,1,TAMSX3("Z14_IE")[1])
	M->Z14_TEL := SUBSTR(SA1->A1_TEL,1,TAMSX3("Z14_TEL")[1])
	M->Z14_EMAIL := SUBSTR(SA1->A1_EMAIL,1,TAMSX3("Z14_EMAIL")[1])
	
Return .T.




/*
=============================================================================================================================================================
Programa  : CSS002CLI
=============================================================================================================================================================
*/
User function CSS002CLI
	dbselectarea("SA1")
	SA1->(dbsetorder(3))
	
	if((Empty(Z14->Z14_ORIGEM) .And. SA1->(DbSeek(xFilial("SA1")+Z14->Z14_CNPJ)) ) .Or. Z14->Z14_ORIGEM == "SA1" )
		
		If SA1->(DbSeek(xFilial("SA1")+Z14->Z14_CNPJ))
			set filter to A1_CGC = Z14->Z14_CNPJ
		EndIf
		MATA030()
		dbselectarea("SA1")
		set filter to
	Else
		Alert("Cadastro não localizado")
	endif
	
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Validperg2 º                          ³º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERPERG(cPerg)
	
	//    < cGrupo> , < cOrdem>, < cPergunt>       , < cPergSpa>    	, < cPergEng>     , < cVar> , < cTipo>, < nTamanho>                     , [ nDecimal]                      , [ nPreSel], < cGSC>, [ cValid]										, [ cF3], [ cGrpSXG], [ cPyme], < cVar01>, [ cDef01]						, [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02]													, [ cDefSpa2], [ cDefEng2], [ cDef03]									, [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
	PutSx1(cperg    , "01"     ,"Nota Fiscal"		,"Nota Fiscal" 	 	,"Invoice number" ,"mv_ch1","C"       ,TamSX3("F1_DOC")[1]          	,TamSX3("F1_DOC")[2]	           ,           ,"G"     ,""    										    ,""     ,""         ,""       ,"mv_par01",""      							,""          ,""          ,""        ,""															,""          ,""          ,""											,""          ,""          ,""		 ,""          ,""          ,""        ,""          ,""          ,""          ,""          ,""          ,""        )
	PutSx1(cperg    , "02"     ,"Serie"				,"Serie"		 	,"Serie"		  ,"mv_ch2","C"       ,TamSX3("F1_SERIE")[1]          	,TamSX3("F1_SERIE")[2]  	           ,           ,"G"     ,""    										    ,""     ,""         ,""       ,"mv_par02",""      							,""          ,""          ,""        ,""															,""          ,""          ,""											,""          ,""          ,""		 ,""          ,""          ,""        ,""          ,""          ,""          ,""          ,""          ,""        )
	
Return


/*
=============================================================================================================================================================
Programa  : CSS002TK
=============================================================================================================================================================
*/
User Function CSS002TK
	
	MsgRun("Processando Integração de tickets...","",{|| CursorWait(), u_Inbound() ,CursorArrow()})
	MsgInfo("Tickets Integrados com sucesso!")
	
Return()

/*
=============================================================================================================================================================
Programa  : BGHAC001
=============================================================================================================================================================
*/

User Function BGHAC001()
	
	Local aArea		:= GetArea()
	Local cOPAcer   := GetMv("MV_XOPACER",.F.,"A01")
	Local cFasIni   := GetMv("MV_XACAP01",.F.,"000000/00")
	Local cFasFim   := GetMv("MV_XACAP02",.F.,"000001/01")
	Local cNumCx 	:= ""
	
	Private cImei	:= Left(Z14->Z14_SERIE,TamSX3("ZZ4_IMEI")[1])
	Private cCarcac := Z14->Z14_SERIE 
	Private cNumCSS := Z14->Z14_CSSNUM
	
	cImei 	:= cImei+Space(TamSX3("ZZ4_IMEI")[1]-Len(cImei))
	cCarcac := cCarcac+Space(25-Len(cCarcac))
	
	dbSelectArea("ZZO")
	ZZO->(dbSetOrder(1))
	If !dbSeek(xFilial("ZZO")+cImei+cCarcac+"1",.F.)
		Conout("CSS002 -> Nova ZZO - "+time())
		cNumCx := GetSXENum("ZZO","ZZO_NUMCX")
		ZZO->(CONFIRMSX8())
		
		dbSelectArea("ZZO")
		dbSetOrder(4)
		While ZZO->(dbSeek(xFilial("ZZO")+cNumCx))
			cNumCx := GetSXENum("ZZO","ZZO_NUMCX")
			ZZO->(CONFIRMSX8())
			Conout("CSS002 -> ZZO_NUMCX "+cNumCx+" - "+time())
		EndDo
		
		Begin Transaction
			dbSelectArea("ZZO")
			RecLock("ZZO",.T.)
			ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
			ZZO->ZZO_IMEI		:= Z14->Z14_SERIE
			ZZO->ZZO_CARCAC		:= Z14->Z14_SERIE
			ZZO->ZZO_STATUS		:= '1'
			ZZO->ZZO_MODELO		:= Z14->Z14_PRODUT
			ZZO->ZZO_GARANT  	:= "S"
			ZZO->ZZO_DTSEPA		:= dDataBase
			ZZO->ZZO_HRSEPA		:= Time()
			ZZO->ZZO_USRSEP		:= cUserName
			ZZO->ZZO_NUMCX		:= cNumCx
			ZZO->ZZO_ORIGEM		:= "ACE"
			ZZO->ZZO_CLIENT		:= Z14->Z14_CLIENT
			ZZO->ZZO_LOJA		:= Z14->Z14_LOJA
			ZZO->ZZO_NF			:= Z14->Z14_NOTAE
			ZZO->ZZO_SERIE		:= Z14->Z14_SERIEE
			ZZO->ZZO_PRECO		:= Z14->Z14_VUNIT
			ZZO->ZZO_DESTIN		:= "B"
			ZZO->ZZO_ENVARQ		:= "S"
			ZZO->ZZO_BOUNCE		:= "N"
			ZZO->ZZO_OPERA		:= cOPAcer//Definir operação e tratar no parametro
			ZZO->ZZO_REFGAR		:= "1"
			MsUnlock()
			
		End Transaction
		Conout("CSS002 -> Gravando ZZO - "+time())
	Else
		RecLock("ZZO",.F.)
		ZZO->ZZO_CLIENT		:= Z14->Z14_CLIENT
		ZZO->ZZO_LOJA		:= Z14->Z14_LOJA
		ZZO->ZZO_NF			:= Z14->Z14_NOTAE
		ZZO->ZZO_SERIE		:= Z14->Z14_SERIEE
		MsUnlock()
		Conout("CSS002 -> Atualizando ZZO - "+time())
	Endif
	nRecnoZZO	:= ZZO->( recno() )
	
	Conout("CSS002 -> Chamado TECAX011 - "+time())
	If !IsBlind()
		Processa({|| U_TECAX011("BGHTRIAG"+ZZO->ZZO_OPERA,ZZO->ZZO_NUMCX,.T.) },"Processando Entrada Massiva ")
	Else
		U_TECAX011("BGHTRIAG"+ZZO->ZZO_OPERA,ZZO->ZZO_NUMCX,.T.)
	Endif
	Conout("CSS002 -> Fim TECAX011 - "+time())
	
	dbSelectArea("ZZO")
	ZZO->(dbGoto(nRecnoZZO))
	
	dbSelectArea("ZZ4")
	// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	If dbSeek(xFilial("ZZ4")+ZZO->ZZO_NF+ZZO->ZZO_SERIE+ZZO->ZZO_CLIENT+ZZO->ZZO_LOJA+ZZO->ZZO_MODELO+ZZO->ZZO_IMEI)
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If dbSeek(xFilial("SD1")+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD1->D1_COD)
			
			cCodTec := Posicione("AA1",4,xFilial("AA1") + __cUserID,"AA1_CODTEC")
			cLab 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_LAB")
			
			dbSelectArea("ZZ3")
			RecLock("ZZ3",.T.)
			ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
			ZZ3->ZZ3_CODTEC := cCodTec
			ZZ3->ZZ3_LAB    := cLab
			ZZ3->ZZ3_DATA   := date()
			ZZ3->ZZ3_HORA   := Time()
			ZZ3->ZZ3_CODSET := Substr(cFasIni,1,6)
			ZZ3->ZZ3_FASE1  := Substr(cFasIni,8,2)
			ZZ3->ZZ3_CODSE2 := Substr(cFasFim,1,6)
			ZZ3->ZZ3_FASE2  := Substr(cFasFim,8,2)
			ZZ3->ZZ3_ENCOS  := "N"
			ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
			ZZ3->ZZ3_SWAP   := ""
			ZZ3->ZZ3_IMEISW := ""
			ZZ3->ZZ3_MODSW  := ""
			ZZ3->ZZ3_UPGRAD := ""
			ZZ3->ZZ3_NUMOS  := ZZ4->ZZ4_OS
			ZZ3->ZZ3_STATUS := "1"
			ZZ3->ZZ3_SEQ    := "01"
			ZZ3->ZZ3_USER   := cUserName
			ZZ3->ZZ3_ACAO   := ""
			ZZ3->ZZ3_LAUDO  := ""
			ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
			ZZ3->ZZ3_ESTORN := "N"
			ZZ3->ZZ3_STATRA := "0"
			ZZ3->ZZ3_ASCRAP := "N"
			MsUnlock()
			Conout("CSS002 -> Gravando ZZ3 - "+time())
			dbSelectArea("ZZ4")
			Reclock("ZZ4",.f.)
			ZZ4->ZZ4_STATUS	:=	"4"
			ZZ4->ZZ4_SETATU := Substr(cFasFim,1,6)
			ZZ4->ZZ4_FASATU := Substr(cFasFim,8,2)
			ZZ4->ZZ4_NFEDT  := dDataBase
			ZZ4->ZZ4_NFEHR  := time()
			ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
			ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
			ZZ4->ZZ4_LOCAL  := SD1->D1_LOCAL
			ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
			ZZ4->ZZ4_ITEMD1 := SD1->D1_ITEM 
			ZZ4->ZZ4_GVSOS  := cNumCSS
			msunlock()
			Conout("CSS002 -> Gravando ZZ4 - "+time())
		Endif
	Endif
	
	RestArea(aArea)
	
Return()


/*
=============================================================================================================================================================
Programa  : BGHAC002
=============================================================================================================================================================
*/

User Function BGHAC002(cPedido,lPec)
	
	Local aArea		:= GetArea()
	Local cFasFim   := GetMv("MV_XACAP02",.F.,"000001/01")
	Local _cclifor := GetMv("ES_CLIACER",,"Z006HT")
	Local _cAntclfo := GetMv("ES_ANCLACE",,"Z006HT")
	Local _cAntcllj := GetMv("ES_ANLJACE",,"01")
	Local aPecas	:= {}
	
	Private aPedido	:= 	{}
	Private aNfOk	:= 	{}
	Private aAuxNF	:=  {}
	
	
	dbSelectArea("ZZ4")
	// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	If dbSeek(xFilial("ZZ4")+Z14->Z14_NOTAE+Z14->Z14_SERIEE+Z14->Z14_CLIENT+Z14->Z14_LOJA+Z14->Z14_PRODUT+Left(Z14->Z14_SERIE,TamSX3("ZZ4_IMEI")[1]))//+left(Z14->Z14_SERIE,20))
		
		cStatZZ4:= ZZ4->ZZ4_STATUS
		cCodTec := Posicione("AA1",4,xFilial("AA1") + __cUserID,"AA1_CODTEC")
		cLab 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_LAB")
		dbSelectArea("ZZ3")
		dbSetOrder(1)
		If !dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"01")
			U_GEZZ3AC(Z14->Z14_CSSNUM)		
		Endif		
		
		dbSelectArea("ZZ3")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"01")
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If dbSeek(xFilial("SC5")+cPedido)
				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SC5->C5_NUM)
					While SC6->(!Eof()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==SC5->C5_NUM
						If Alltrim(SC6->C6_PRODUTO)==Alltrim(ZZ4->ZZ4_CODPRO) .And.;
								SC6->C6_NFORI==ZZ4->ZZ4_NFENR .And. SC6->C6_SERIORI==ZZ4->ZZ4_NFESER
							
							reclock("SC6",.F.)
							SC6->C6_NUMSERI := ZZ4->ZZ4_IMEI
							SC6->C6_NUMOS   := ZZ4->ZZ4_OS
							msunlock()
							
							dbSelectArea("ZZ4")
							RecLock("ZZ4",.F.)
							ZZ4->ZZ4_PV     := SC5->C5_NUM + SC6->C6_ITEM
							ZZ4->ZZ4_STATUS := "8"  // PV Gerado
							msunlock()
							Conout("CSS002 -> Gravando ZZ4 - "+time())
						Else
							lAddPeca := .F.
						    If (Z14->Z14_WARRAN == "O" .and.  Z14->Z14_RECACE == "S" .and. Z14->Z14_CLIENT <> _cclifor .and. Z14->Z14_CLIENT <> _cAntclfo) 
		    					lAddPeca := .T.
				    		Endif			
							If Z14->Z14_WARRAN <> "O" .OR. lAddPeca
								aAdd(aPecas,{SC6->C6_PRODUTO})
								dbSelectArea("SZ9")
								dbSetORder(4)
								If !dbSeek(xFilial("SZ9")+ZZ3->ZZ3_NUMOS+ZZ3->ZZ3_SEQ+SC6->C6_PRODUTO,.F.)
									RecLock("SZ9",.T.)
									SZ9->Z9_FILIAL 	:= 	xFilial("SZ9")
									SZ9->Z9_NUMOS	:=	ZZ4->ZZ4_OS
									SZ9->Z9_SEQ		:=	ZZ3->ZZ3_SEQ
									SZ9->Z9_CODTEC	:= 	ZZ3->ZZ3_CODTEC
									SZ9->Z9_ITEM	:=	"01"
									SZ9->Z9_QTY		:=	SC6->C6_QTDVEN
									SZ9->Z9_PARTNR	:=	SC6->C6_PRODUTO
									SZ9->Z9_USED	:=	"0"
									SZ9->Z9_IMEI	:= 	ZZ4->ZZ4_IMEI
									SZ9->Z9_STATUS	:=	"1"
									SZ9->Z9_FASE1	:=	ZZ3->ZZ3_FASE1
									SZ9->Z9_PREVCOR	:=	"C"
									SZ9->Z9_LOCAL	:=	SC6->C6_LOCAL
									SZ9->Z9_COLETOR	:=	"S"
									SZ9->Z9_USRINCL	:= AllTrim(cCodTec)  + " - " + AllTrim(cUsername)
									SZ9->Z9_SYSORIG	:= "9"//Verificar qual a origem utilizaremos
									MSUnlock()
									Conout("CSS002 -> Gravando ZZ9 - "+time())
								Else
									RecLock("SZ9",.F.)
									SZ9->Z9_QTY		:=	SC6->C6_QTDVEN
									MSUnlock()
									Conout("CSS002 -> Gravando SZ9 - "+time())
								Endif
								dbSelectArea("ZZQ")
								dbSetOrder(3)
								//ZZQ_FILIAL+ZZQ_PECA+ZZQ_IMEI+ZZQ_NUMOS+ZZQ_PV+ZZQ_ITEMPV+ZZQ_MODELO
								If !dbSeek(xFilial("ZZQ")+SC6->C6_PRODUTO+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS,.F.)
									
									_cPNDefe := ""
									dbSelectArea("Z20")
									dbSetOrder(2)
									If dbSeek(xFilial("Z20")+Z14->Z14_CSSNUM+SC6->C6_PRODUTO)
										_cPNDefe := Z20->Z20_PNDEFE
									Endif
									dbSelectArea("SB1")
									dbSetOrder(1)
									dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
									
									dbSelectArea("SB6")
									dbSetOrder(3)
									dbSeek(xFilial("SB6")+SC6->C6_IDENTB6+SC6->C6_PRODUTO+"R")
									cArmPeca := ArmPeca(Z14->Z14_CSSNUM,SC6->C6_PRODUTO)
									dbSelectArea("ZZQ")
									Reclock("ZZQ",.T.)
									ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
									ZZQ->ZZQ_IMEI   := ZZ4->ZZ4_IMEI
									ZZQ->ZZQ_NUMOS  := ZZ4->ZZ4_OS
									ZZQ->ZZQ_MODELO := ZZ4->ZZ4_CODPRO
									ZZQ->ZZQ_CODEST := SB1->B1_GRUPO
									ZZQ->ZZQ_DTSAID := dDataBase
									ZZQ->ZZQ_PV     := SC6->C6_NUM
									ZZQ->ZZQ_ITEMPV := SC6->C6_ITEM
									ZZQ->ZZQ_CLISAI := SC6->C6_CLI
									ZZQ->ZZQ_LOJSAI := SC6->C6_LOJA
									ZZQ->ZZQ_PECA   := SC6->C6_PRODUTO
									ZZQ->ZZQ_QTDE   := SC6->C6_QTDVEN
									ZZQ->ZZQ_VLRUNI := SC6->C6_PRCVEN
									ZZQ->ZZQ_VLRTOT := SC6->C6_VALOR
									ZZQ->ZZQ_NFORI  := SC6->C6_NFORI
									ZZQ->ZZQ_SERORI := SC6->C6_SERIORI
									ZZQ->ZZQ_CLIORI := SB6->B6_CLIFOR
									ZZQ->ZZQ_LOJORI := SB6->B6_LOJA
									ZZQ->ZZQ_IDEORI := SC6->C6_IDENTB6
									ZZQ->ZZQ_OPEBGH := ZZ4->ZZ4_OPEBGH
									ZZQ->ZZQ_ARMAZ	:= cArmPeca
									ZZQ->ZZQ_PNDEFE := _cPNDefe
									msunlock()
									Conout("CSS002 -> Gravando ZZQ - "+time())
								Else
									RecLock("ZZQ",.F.)
									ZZQ->ZZQ_QTDE	:=	SC6->C6_QTDVEN
									MSUnlock()
								Endif
							Else
								If SC6->C6_LOCAL == 'AO' 
									dbSelectArea("SZ9")
									dbSetORder(4)
									If !dbSeek(xFilial("SZ9")+ZZ3->ZZ3_NUMOS+ZZ3->ZZ3_SEQ+SC6->C6_PRODUTO,.F.)
										RecLock("SZ9",.T.)
										SZ9->Z9_FILIAL 	:= 	xFilial("SZ9")
										SZ9->Z9_NUMOS	:=	ZZ4->ZZ4_OS
										SZ9->Z9_SEQ		:=	ZZ3->ZZ3_SEQ
										SZ9->Z9_CODTEC	:= 	ZZ3->ZZ3_CODTEC
										SZ9->Z9_ITEM	:=	"01"
										SZ9->Z9_QTY		:=	SC6->C6_QTDVEN
										SZ9->Z9_PARTNR	:=	SC6->C6_PRODUTO
										SZ9->Z9_USED	:=	"0"
										SZ9->Z9_IMEI	:= 	ZZ4->ZZ4_IMEI
										SZ9->Z9_STATUS	:=	"1"
										SZ9->Z9_FASE1	:=	ZZ3->ZZ3_FASE1
										SZ9->Z9_PREVCOR	:=	"C"
										SZ9->Z9_LOCAL	:=	SC6->C6_LOCAL
										SZ9->Z9_COLETOR	:=	"S"
										SZ9->Z9_USRINCL	:= AllTrim(cCodTec)  + " - " + AllTrim(cUsername)
										SZ9->Z9_SYSORIG	:= "9"//Verificar qual a origem utilizaremos
										MSUnlock()
										Conout("CSS002 -> Gravando ZZ9 - "+time())
									Else
										RecLock("SZ9",.F.)
										SZ9->Z9_QTY		:=	SC6->C6_QTDVEN
										MSUnlock()
										Conout("CSS002 -> Gravando SZ9 - "+time())
									Endif
								EndIf		
							Endif
						Endif
						SC6->(dbSkip())
					EndDo
				Endif
				If len(aPecas) > 0
					dbSelectArea("SZ9")
					dbSetORder(4)
					If dbSeek(xFilial("SZ9")+ZZ3->ZZ3_NUMOS+ZZ3->ZZ3_SEQ)
						While SZ9->(!EOF()) .AND. SZ9->Z9_FILIAL==xFilial("SZ9") .AND.;
								SZ9->Z9_NUMOS==ZZ3->ZZ3_NUMOS .AND. SZ9->Z9_SEQ==ZZ3->ZZ3_SEQ
							If !Empty(SZ9->Z9_PARTNR)
								nPos := Ascan(aPecas ,{ |x| Alltrim(x[1]) == Alltrim(SZ9->Z9_PARTNR) })
								If nPos == 0
									RecLock("SZ9",.F.)
									dbDelete()
									MSUnlock()
								EndIf
							Endif
							SZ9->(dbSkip())
						EndDo
					Endif
					dbSelectArea("ZZQ")
					dbSetOrder(1)
					//ZZQ_FILIAL+ZZQ_IMEI+ZZQ_NUMOS+ZZQ_PV+ZZQ_ITEMPV+ZZQ_MODELO
					If dbSeek(xFilial("ZZQ")+ZZ3->ZZ3_IMEI+ZZ3->ZZ3_NUMOS)
						While ZZQ->(!EOF()) .AND. ZZQ->ZZQ_FILIAL==xFilial("ZZQ") .AND.;
								ZZQ->ZZQ_IMEI==ZZ3->ZZ3_IMEI .AND. ZZQ->ZZQ_NUMOS==ZZ3->ZZ3_NUMOS
							If !Empty(ZZQ->ZZQ_PECA)
								nPos := Ascan(aPecas ,{ |x| Alltrim(x[1]) == Alltrim(ZZQ->ZZQ_PECA) })
								If nPos == 0
									RecLock("ZZQ",.F.)
									dbDelete()
									MSUnlock()
								EndIf
							Endif
							ZZQ->(dbSkip())
						EndDo
					Endif
				Endif
				If cStatZZ4 < '5'
					dbSelectArea("ZZ3")
					RecLock("ZZ3",.T.)
					ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
					ZZ3->ZZ3_CODTEC := cCodTec
					ZZ3->ZZ3_LAB    := cLab
					ZZ3->ZZ3_DATA   := date()
					ZZ3->ZZ3_HORA   := Time()
					ZZ3->ZZ3_CODSET := Substr(cFasFim,1,6)
					ZZ3->ZZ3_FASE1  := Substr(cFasFim,8,2)
					ZZ3->ZZ3_CODSE2 := Substr(cFasFim,1,6)
					ZZ3->ZZ3_FASE2  := Substr(cFasFim,8,2)
					ZZ3->ZZ3_ENCOS  := "S"
					ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
					ZZ3->ZZ3_SWAP   := ""
					ZZ3->ZZ3_IMEISW := ""
					ZZ3->ZZ3_MODSW  := ""
					ZZ3->ZZ3_UPGRAD := ""
					ZZ3->ZZ3_NUMOS  := ZZ4->ZZ4_OS
					ZZ3->ZZ3_STATUS := "1"
					ZZ3->ZZ3_SEQ    := u_CalcSeq(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
					ZZ3->ZZ3_USER   := cUserName
					ZZ3->ZZ3_ACAO   := ""
					ZZ3->ZZ3_LAUDO  := ""
					ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
					ZZ3->ZZ3_ESTORN := "N"
					ZZ3->ZZ3_STATRA := "0"
					ZZ3->ZZ3_ASCRAP := "N"
					MsUnlock()
					Conout("CSS002 -> Gravando ZZ3 - "+time())
				Endif
				aadd(aPedido,{SC5->C5_NUM})
				//GeraNFAC(aPedido,lPec)
				If Z14->Z14_WARRAN <> "O"
					GeraNFAC(aPedido,lPec)
				Else
					If (MsgYesNo("Deseja gerar NF?"))	
						GeraNFAC(aPedido,lPec)
					Endif
				Endif
				If len(aNFOK) > 0
					//U_BGHETQNF(aNfOk,"","1")				 
					cMsgNF:=""
					For nx:=1 To Len(aNfOk) 					
						If Len(aNfOk) == 2						
							If nx==1
								cMsgNF+="NF de Equipamento gerado com sucesso."+CRLF
					   		ElseIf nx==2
					   			If Z14->Z14_WARRAN == "B"			
					   				cMsgNF+="NF de peça gerado com sucesso."+CRLF
					   			Else
					   				cMsgNF+="NF de Serviço gerado com sucesso."+CRLF					   			
					   			Endif
					   		EndIf					
						ElseIf Len(aNfOk) == 3
							If nx==1
								cMsgNF+="NF de Equipamento gerado com sucesso."+CRLF					   		
					   		ElseIf nx==2
					   			cMsgNF+="NF de Peças gerado com sucesso."+CRLF					   			
					   		ElseIf nx==3
					   			cMsgNF+="NF de Serviço gerado com sucesso."+CRLF					   			
					   		EndIf
					   	EndIf					   	
					   	cMsgNF+="NF: "+Alltrim(aNfOk[nx][2])+" Serie: "+Alltrim(aNfOk[nx][1])+CRLF
					Next nx
					MsgInfo(cMsgNF)
				EndIf
			Endif
		Endif
	Endif
	
	RestArea(aArea)
	
Return()

Static Function ArmPeca(cCssNum,cPeca)
                  
Local cArmPeca 	:= ""
Local cTOWH 	:= GetMv("ES_XTOWH",,"502;701")

cq := " SELECT "
cq += "		Z18.Z18_TOWH "
cq += " FROM "
cq += "		( "
cq += "			SELECT "
cq += "				MAX(TRBZ18.R_E_C_N_O_) AS RECZ18 "
cq += "			FROM "+RETSQLNAME("Z18")+ "  TRBZ18 "
cq += "			WHERE "
cq += "				Z18_FILIAL='"+xFilial("Z18")+"' AND "
cq += "				Z18_CSSNUM = '"+cCssNum+"' AND "
cq += "				Z18_PRODUT = '"+cPeca+"' AND "
cq += "				Z18_TOWH IN "+FormatIn(cTOWH,';')+ " AND "
cq += "				TRBZ18.D_E_L_E_T_ = '' "
cq += "		) AS TRB "
cq += "	INNER JOIN "+RETSQLNAME("Z18")+ " Z18 ON "
cq += "		Z18_FILIAL='"+xFilial("Z18")+"' AND "
cq += "		Z18.R_E_C_N_O_= TRB.RECZ18 AND "
cq += "		Z18.D_E_L_E_T_ = '' "

cQ := ChangeQuery(cQ)  

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYZ18",.F.,.T.)

IF(!QUERYZ18->(eof()))
//If SELECT("QUERYZ18") > 0 
	cArmPeca := IIF(QUERYZ18->Z18_TOWH=="502","AD","SA")
ENDIF

QUERYZ18->(dbclosearea())

Return(cArmPeca)

Static Function GeraNFAC(aPedido,lPec)
	
	Local aAreaAtu  := GetArea()
	Local aPvlNfs   := {}
	Local aBloqueio := {{"","","","","","","",""}}
	Local aNotas    := {}
	Local cSerie	:=	"1"
	Local _cclifor := GetMv("ES_CLIACER",,"Z006HT")
	Local _cAntclfo := GetMv("ES_ANCLACE",,"Z006HT")
	Local _cAntcllj := GetMv("ES_ANLJACE",,"01")
	Private aAuxNF	:=  {}

	Private _cNumEtq:= GETSXENUM("SF2","F2_XNUMETQ")
	ConfirmSX8()
	
	For i:=1 to len(aPedido)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+aPedido[i,1])
			//Liberando Bloqueios do Pedido
			SC9->(dbSetOrder(1))
			If SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM))
				While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
					RecLock("SC9",.F.)
					If SC9->C9_BLEST <> "10"
						SC9->C9_BLEST  := ""
					EndIf
					If SC9->C9_BLCRED <> "10"
						SC9->C9_BLCRED := ""
					EndIf
					SC9->(MsUnlock())
					SC9->(dbSkip())
				EndDo
			EndIf
			
			// Checa itens liberados
			IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		EndIf
	Next i
	//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
	cNotaFeita :=""
	If Empty(aBloqueio) .And. !Empty(aPvlNfs)
		nItemNf  := a460NumIt(cSerie)
		Asort(aPvlNfs,,,{|x,y| x[2] < y[2]})
		If Procname(2) == "PROCSC5"
			Asort(aPvlNfs,,,{|x,y| x[2] < y[2]})
			lAddPeca := .T.
		    If (Z14->Z14_WARRAN == "O" .and.  Z14->Z14_RECACE == "S" .and. Z14->Z14_CLIENT <> _cclifor .and. Z14->Z14_CLIENT <> _cAntclfo ) 
		    	lAddPeca := .F.
			Endif			
			If (Z14->Z14_WARRAN == "O" .OR. Z14->Z14_WARRAN == "B") .AND. lAddPeca 
				If !lPec 
					For nX := 1 To Len(aPvlNfs) 					     
						If aPvlNfs[nX][15] == "AE"
							aadd(aNotas,{})
							// Efetua as quebras de acordo com o numero de itens
							If Len(aNotas[Len(aNotas)])>=nItemNf
								aadd(aNotas,{})
							EndIf 
							aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[1]))
						EndIf
					Next nX
				Else 
					aadd(aNotas,{})
					For nX := 1 To Len(aPvlNfs)						
						// Efetua as quebras de acordo com o numero de itens
						If Len(aNotas[Len(aNotas)])>=nItemNf
							aadd(aNotas,{})
						EndIf 
						aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))						
					Next nX
				EndIf			
				If Len(aNFPec) > 0 
					aadd(aNotas,{})
					For nX := 1 To Len(aPvlNfs) 					
						For i:=1 to Len(aNFPec)					
						    If aPvlNfs[nX][2] == aNFPec[i][1] 
						    	// Efetua as quebras de acordo com o numero de itens					    
								If Len(aNotas[Len(aNotas)])>=nItemNf
									aadd(aNotas,{})
								EndIf 
								aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX])) 						
							EndIf						
						Next i
					Next nX				
				EndIf 
			
				If Len(aNFServ) > 0
					aadd(aNotas,{})				
					For nX := 1 To Len(aPvlNfs)				
						If aPvlNfs[nX][2] == aNFServ[1][1] 
							// Efetua as quebras de acordo com o numero de itens
							If Len(aNotas[Len(aNotas)])>=nItemNf
								aadd(aNotas,{})
							EndIf 	 	
							aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
						EndIf
					Next nX	 			
				EndIf 
			
			Else
				aadd(aNotas,{})
				For nX := 1 To Len(aPvlNfs)   
					// Efetua as quebras de acordo com o numero de itens
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))						
				Next nX 
			EndIf
		Else
			aadd(aNotas,{})
			For nX := 1 To Len(aPvlNfs)   
				// Efetua as quebras de acordo com o numero de itens
				If Len(aNotas[Len(aNotas)])>=nItemNf
					aadd(aNotas,{})
				EndIf
				aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))						
			Next nX 			
		EndIf
		
		For nX := 1 To Len(aNotas)
			//Gera a Nota Fiscal
			IF aNotas[nX][1][6] = "800071.9"
			   IncProc( "Gerando Nota Fiscal Serviço " )    
			   cSerie := "RPS"
			ELSE
			   IncProc( "Gerando Nota Fiscal " )    
			   cSerie := "1"
			ENDIF        
			cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
			aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,_cNumEtq}) 
			aADD(aAuxNF,{SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA})
		Next nX 
		//AtuSF2()
		AtuaSE1()
	EndIf
	
	RestArea(aAreaAtu)
	
Return
/*Static Function AtuSF2()
    
	Local aArea := GetArea() 
	
	If Select("SF2") == 0
		DbSelectArea("SF2")
	EndIf
	SF2->(DbSetOrder(2))
	
	If Len(aNfOk) > 0
		For nx:=1 To Len(aNfOk)	 
			SE1->(DbGoTop())	
			
			If SE1->(DbSeek(xFilial("SE1")+aNfOk[nx][3]+aNfOk[nx][4]+aNfOk[nx][1]+aNfOk[nx][2]))
				
				If RecLock("SE1",.F.)
					SF2->F2_XNUMETQ := aNfOk[nx][3]
					SE1->(MsUnlock())
				EndIf
			EndIf 
		Next nx
	EndIf		
	
	RestArea(aArea)
	 
Return*/
Static Function AtuaSE1()
    
	Local aArea := GetArea() 
	
	If Select("SE1") == 0
		DbSelectArea("SE1")
	EndIf
	SE1->(DbSetOrder(2))
	
	If Len(aAuxNF) > 0
		For nx:=1 To Len(aAuxNF)	 
			SE1->(DbGoTop())	
			
			If SE1->(DbSeek(xFilial("SE1")+aAuxNF[nx][3]+aAuxNF[nx][4]+aAuxNF[nx][1]+aAuxNF[nx][2]))
				
				If RecLock("SE1",.F.)
					SE1->E1_XCSSNUM := Z14->Z14_CSSNUM
					SE1->(MsUnlock())
				EndIf
			EndIf 
		Next nx
	EndIf		
	
	RestArea(aArea)
	 
Return
User Function CSS02DV()

Local aAreaAtu := GetArea()
Local oDlgEsp
Local oLbx
Local nOpca     := 0
Local aHSF1     := {}
Local aSF1      := {}
Local aCpoSF1   := {}
Local dDataDe   := CToD('01/01/00')
Local dDataAte  := CToD('31/12/20')
Local nCnt      := 0
Local nPosDoc   := 0
Local nPosSerie := 0
Local cDocSF1   := ''
Local cIndex    := ''
Local cQuery    := ''
Local cAliasSF1 := ''
Local lRet		:= .T.

Private lFornece  := .T.
Private lForn	  := .T.
Private cCssNum	  := Z14->Z14_CSSNUM
Private aRotina	:= {{"RETORNO","A410ProcDv",0,3},{"RETORNO","A410ProcDv",0,3},{"RETORNO","A410ProcDv",0,3}}
Private cAlias := "SC5"
Private nReg := SC5->(Recno())
Private nOpcx := 3
Private aPedido	:= 	{}
Private aNfOk	:= 	{}

Private cFornece := GetMv("ES_CLIACER",,"Z006HT")//CriaVar("F1_FORNECE",.F.)
Private cLoja    := GetMv("ES_LOJACER",,"01")//CriaVar("F1_LOJA",.F.)

If Z14->Z14_WARRAN <> "O"
	MsgAlert("Ticket não é Fora de Garantia!")
	Return			
Endif

cq := "SELECT TOP 1 * FROM "+RETSQLNAME("SC6")+ " 
cq += "WHERE D_E_L_E_T_='' AND "
cq += "C6_FILIAL='"+xFilial("SC6")+"' AND "
cq += "C6_CLI = '"+cFornece+"' AND "
cq += "C6_LOJA = '"+cLoja+"' AND "
cq += "LEFT(C6_NUMPCOM,8) = '"+Z14->Z14_CSSNUM+"' "
cQ := ChangeQuery(cQ)  
		
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC6",.F.,.T.)

IF(!QUERYSC6->(eof()))
//IF SELECT("QUERYSC6") > 0
	lRet:= .F.
ENDIF
QUERYSC6->(dbclosearea())

If lRet
	dbSelectArea("Z17")
	dbSetOrder(1)
	If dbSeek(xFilial("Z17")+cCssNum)
	
		If Z14->Z14_ABORT <> "S"
			
			While Z17->(!EOF()) .and. Z17->Z17_FILIAL==xFilial("Z17") .and. Z17->Z17_CSSNUM==cCssNum
				
				cQuery := "SELECT TOP 1 * FROM "+RETSQLNAME("SB6")+ " SB6 "
				cQuery += "INNER JOIN "+RETSQLNAME("SD1")+ " SD1 ON D1_FILIAL=B6_FILIAL AND "
				cQuery += "D1_DOC=B6_DOC AND D1_SERIE=B6_SERIE AND D1_FORNECE=B6_CLIFOR AND D1_LOJA=B6_LOJA AND  "				
				cQuery += "D1_COD=B6_PRODUTO AND D1_IDENTB6=B6_IDENT "				
				cQuery += "WHERE SB6.D_E_L_E_T_='' AND "
				cQuery += "B6_FILIAL='"+xFilial("SB6")+"' AND "
				cQuery += "B6_CLIFOR = '"+cFornece+"' AND "
				cQuery += "B6_LOJA = '"+cLoja+"' AND "
				cQuery += "B6_PRODUTO = '"+Z17->Z17_PRODUT+"' AND "
				cQuery += "B6_SALDO > 0 "
				cQuery := ChangeQuery(cQuery)  
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSB6",.F.,.T.)
				
				dbselectarea("QRYSB6")
				dbGotop()
				
				IF(QRYSB6->(!Eof()))
					
					dbselectarea("SF1")
					dbsetorder(1)
					If dbseek(xfilial("SF1")+QRYSB6->B6_DOC+QRYSB6->B6_SERIE+QRYSB6->B6_CLIFOR+QRYSB6->B6_LOJA+"B")
					
						#IFDEF TOP
							cDocSF1 += "( SD1.D1_DOC = '" + QRYSB6->B6_DOC + "' AND SD1.D1_SERIE = '" + QRYSB6->B6_SERIE + "' AND SD1.D1_COD = '" + QRYSB6->B6_PRODUTO + "' AND SD1.D1_ITEM = '" + QRYSB6->D1_ITEM + "') OR"
						#ELSE
							cDocSF1 += "( SD1->D1_DOC == '" + QRYSB6->B6_DOC + "' .And. SD1->D1_SERIE == '" + QRYSB6->B6_SERIE + "' .And. SD1->D1_COD == '" + QRYSB6->B6_PRODUTO + "' .And. SD1->D1_ITEM == '" + QRYSB6->D1_ITEM + "') .OR."
						#ENDIF
					Endif			
					
				Endif
				
				If SELECT("QRYSB6") > 0
					QRYSB6->(DbCloseArea())
				EndIf
				
				Z17->(dbSkip())
			EndDo
			
			If !Empty(cDocSF1)
				#IFDEF TOP
					cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-3) + " )"
				#ELSE
					cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-5) + " )"
				#ENDIF
				
				A410ProcDv(cAlias,nReg,nOpcx,lFornece,cFornece,cLoja,cDocSF1)
				
				MsUnLockAll()
				
				cq := "SELECT TOP 1 * FROM "+RETSQLNAME("SC6")+ " 
				cq += "WHERE D_E_L_E_T_='' AND "
				cq += "C6_FILIAL='"+xFilial("SC6")+"' AND "
				cq += "C6_CLI = '"+cFornece+"' AND "
				cq += "C6_LOJA = '"+cLoja+"' AND "
				cq += "LEFT(C6_NUMPCOM,8) = '"+Z14->Z14_CSSNUM+"' "
				cQ := ChangeQuery(cQ)  
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSC6",.F.,.T.)
				
				IF(!QUERYSC6->(eof()))
					dbSelectArea("SC5")
					dbSetOrder(1)
					If dbSeek(xFilial("SC5")+QUERYSC6->C6_NUM)
						RecLock("SC5",.F.)
						SC5->C5_XNUMTIC := Z14->Z14_CSSNUM
						MSUnLock()				
						MsgAlert("Pedido "+SC5->C5_NUM+" gerado com sucesso!")
						aadd(aPedido,{SC5->C5_NUM})
						GeraNFAC(aPedido,.F.)
						MsgAlert("NF: "+Alltrim(aNfOk[1][2])+" Serie: "+Alltrim(aNfOk[1][1]))
					Endif
				ENDIF
				QUERYSC6->(dbclosearea())			
			Else
				Alert("Nenhum documento encontrado para ser retornado!")
			EndIf
		Else
			Alert("Processo Abortado!Exclua as peças apontadas para este ticket!")
		EndIf	
	Else
		Alert("Nenhuma peca encontrada para esse ticket!")
	Endif
Else
	Alert("Processo finalizado!")	
Endif

RestArea(aAreaAtu)

Return
       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NfeNextDocºAutor  ³Luciano Siqueira    º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controla numeracao da nota                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NFENextDoc(cNumero,cCliNFE,cnfant)

Local _lRet     := .T.
Local _nItensNf := 0
Local _cTipoNF  := SuperGetMv("MV_TPNRNFS")


//lRetorno:= Sx5NumNota(@cSerie,cTipoNf)
cNumero := NxtSX5Nota(cSernfe,NIL,_cTipoNF)

If Len(Alltrim(cNumero)) == 6
	cNumero := PadR(cNumero,9)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacao da NF informada pelo usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF1->(dbSetOrder(1))
If SF1->(MsSeek(xFilial("SF1") + cNumero + cSernfe + cCliNFE,.F.))
	IF !lBat
	     Help(" ",1,"EXISTNF")
	ENDIF      
	_lRet    := .F.
	cNumero := ""
EndIf

Return(_lRet)  



/*
=============================================================================================================================================================
Programa  : Retnfant
=============================================================================================================================================================
*/
User Function Retnfant(cNumNF,cSerNf)
	
	Local cTab	 := "01"
	Local cFilSX5 := xFilial("SF1")
	dbSelectArea("SX5")
	dbSetOrder(1)
	
	If ( MsSeek(cFilSX5+cTab+cSerNF) )
		RecLock("SX5",.F.)
		SX5->X5_DESCRI  := StrZero(Val(cNumNF),Len(Alltrim(cNumNF)))
		SX5->X5_DESCSPA := StrZero(Val(cNumNF),Len(Alltrim(cNumNF)))
		SX5->X5_DESCENG := StrZero(Val(cNumNF),Len(Alltrim(cNumNF)))
		SX5->(MsRUnLock())
	EndIf
	
Return
