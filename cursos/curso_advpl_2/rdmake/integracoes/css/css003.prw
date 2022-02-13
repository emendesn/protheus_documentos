#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CSS003   ³ Autor ³ ROGER ALEX		    ³ Data ³ 14/03/2012 ³±±
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
User Function Css003()
	
	Local oBrowse	:= Nil
	Private cCadastro := "Integração CSS - Clientes"
	Private cAlias := "Z13"
	Private nPosSA1 := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o Browse ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z13')
	oBrowse:SetDescription(cCadastro)
	oBrowse:AddLegend( "Z13_STATUS == ' '", "RED", "Não Processado" )
	oBrowse:AddLegend( "Z13_STATUS $  'SA'", "ENABLE", "Cliente Cadastrado" )
	oBrowse:AddLegend( "Z13_STATUS $  'EC'", "BLACK", "Erro Ao Gravar Cliente" )
	oBrowse:AddLegend( "Z13_STATUS == 'D'", "BLUE", "Cliente ja tem Cadastro (Schedule)" )
	
	
	oBrowse:Activate()
	
Return(.T.)
/*
==============================================================================================================================================================
Função ModelDef
==============================================================================================================================================================
*/
Static Function ModelDef()
	
	Local oModel
	Local oStruCab := FWFormStruct(1,'Z13')
	Local bPreValid     := {|oMdl|CSS03Pre(oMdl)}
	
	oModel := MPFormModel():New('CSSMODEL',/*bPreValid*/,/*bPosValidacao*/,/*bCommit*/	,/*bCancel*/)
	oModel:AddFields('Z13CAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:SetPrimaryKey({'Z13_FILIAL','Z13_CODIGO'})
	oModel:SetDescription("Integração CSS - Clientes")
	
Return(oModel)




/*
==============================================================================================================================================================
Função: CSS03Pre
==============================================================================================================================================================
*/
Static Function CSS03Pre(oModel)
	
Return Z13->Z13_STATUS $ " |E|C"
/*
==============================================================================================================================================================
Função: ViewDef
==============================================================================================================================================================
*/
Static Function ViewDef()
	
	Local oView
	
	Local oModel     := FWLoadModel('CSS003')
	Local oStruCab   := FWFormStruct(2,'Z13')
	Local aUsrBut    := {}     					// recebe o ponto de entrada
	Local aButtons	 := {}                      // botoes da enchoicebar
	Local nAuxFor    := 0                       // auxiliar do For , contador da Array aUsrBut
	
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('VIEW_CAB',oStruCab,'Z13CAB')
	oView:CreateHorizontalBox('SUPERIOR',100)
	oView:SetOwnerView( 'VIEW_CAB','SUPERIOR' )
	
Return(oView)




/*
==============================================================================================================================================================
Função: MenuDef
==============================================================================================================================================================
*/
Static Function MenuDef()
	Local aRotina :={}
	Local aUsrBut :={}
	Local nX := 0
	
	
	ADD OPTION aRotina TITLE "Pesquisar" ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.CSS003'	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"   ACTION 'axaltera'	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"   ACTION 'VIEWDEF.CSS003'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE "Proc. Cliente"   ACTION 'U_CSS03ENT(.F.,"              ",.F.)'	OPERATION 9	ACCESS 0
	ADD OPTION aRotina TITLE "Clientes Pedentes"   ACTION 'U_CSS003FE'	OPERATION 9	ACCESS 0
	
	
Return(aRotina)


/*
==============================================================================================================================================================
Função: Css003Pe
==============================================================================================================================================================
*/
User Function CSS003FE()
	if (MsgYesNo("Mostrar Somente Registros Pendentes??"))
		dbselectarea("Z13")
		set filter to Z13->Z13_STATUS $ " |E|C"
	endif
	
Return



/*
==============================================================================================================================================================
Função: Css03Ent
==============================================================================================================================================================
*/
User Function CSS03ENT(lCSS002,cZ13CNPJ,lWsTicket)
	
	If lCSS002 .Or. lWsTicket
		DbSelectArea("Z13")
		DbSetOrder(4)
		If !DbSeek(xFilial("Z13")+cZ13CNPJ)
			Alert("CNPJ/CPF não localizado no cadastro da rotina CSS - CLIENTES")
			Return .F.
		EndIf
	EndIf
	
	If lWsTicket
		PROCSA1(.T.,lWsTicket)
	Elseif (Z13->Z13_STATUS $ "M|E|C| ")
		MsgRun("Processando Cliente...","",{|| CursorWait(), PROCSA1(IIF(lWsTicket,.T.,.F.),lWsTicket) ,CursorArrow()})
	ElseIf lCSS002
		MsgRun("Processando Cliente...","",{|| CursorWait(), PROCSA1(IIF(lWsTicket,.T.,.F.),lWsTicket) ,CursorArrow()})
	endif
	
Return



/*
==============================================================================================================================================================
Função: ProcSa1
==============================================================================================================================================================
*/
Static Function PROCSA1(lBat,lWsTicket)
	Local cCodSA1   := "" , lSXE      := .F. , cEst  :=  ""
	Local cCodMun := "" , cCidade := ""
	Local _lSeek                           
	Local cCNPJ := Z13->Z13_CNPJ
    Local _lcep:=.f.

	DEFAULT lBat := .F.
	
	_lSeek := .F.
	If SELECT("QUERYSA1") > 0
		QUERYSA1->(DbClosearea())
	EndIf
	cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_='' AND RTRIM(A1_CGC) = '"+Alltrim(Z13->Z13_CNPJ)+"'"
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYSA1",.F.,.T.)
	

	// IF SELECT("QUERYSA1") > 0 .
	IF  (!QUERYSA1->(Eof()))
		_lSeek := .T.
		dbselectarea("SA1")
		dbgoto(QUERYSA1->NREC)
	Else
		_lSeek := .F.
	endif
	
	QUERYSA1->(DbClosearea())
	
	AreaSA1 := SA1->(GetArea())
	AreaCC2 := CC2->(GetArea())
	
	if(empty(Z13->Z13_CNPJ))
		If lBat
			U_ACMAILJB("Erro no Cadastro de Clientes "+Z13->Z13_CNPJ,"CNPJ/CPF Inválido.","CSS003",.F.)		
		Else		
		    Alert("CNPJ/CPF Inválido!")
		Endif
		
		RecLock("Z13",.F.)
		Z13->Z13_STATUS := "E"
		Z13->Z13_LOG    := "Erro no Cadastro de Clientes "+Z13->Z13_CNPJ+" CNPJ/CPF Inválido."
		Z13->( MsUnLock() )
		Return .F.
	endif
	
	if(_lSeek .and. lBat .And. !lWsTicket)
        If lBat
			U_ACMAILJB("Erro no cadastro Clientes "+Z13->Z13_CNPJ,"CNPJ/CPF Ja Existe No Cadastro!","CSS003",.F.)		
		Else		
		    Alert("CNPJ/CPF Ja Existe No Cadastro!")
		Endif
		RecLock("Z13",.F.)
		Z13->Z13_STATUS := "D"                                                               
		Z13->Z13_LOG    := "Erro no cadastro Clientes "+Z13->Z13_CNPJ+"CNPJ/CPF Ja Existe No Cadastro!"
		Z13->( MsUnLock() )
		Return .F.
	endif
	
   // Incluso validação de CEP - Edson Rodrigues - 18/04/15	
   dbSelectArea("Z07")
   dbSetOrder(1)
   If Z07->(dbSeek(xFilial("Z07") + alltrim(Padr(Z13->Z13_CEP,8,"0"))))
     	_lcep:=.t.
   
   Else
        If lBat
			U_ACMAILJB("Erro no Cadastro de Clientes "+Z13->Z13_CNPJ,"CEP :"+alltrim(Padr(Z13->Z13_CEP,8,"0"))+" Não cadastrado no Cad. Cep Protheus BGH!!","CSS003",.F.)		
		Else		
		    Alert("CEP Não cadastrado no Cad. Cep Protheus BGH!")
		Endif

    	
		RecLock("Z13",.F.)
		Z13->Z13_STATUS := "E"
		Z13->Z13_LOG    := "Erro no cadastro Clientes "+Z13->Z13_CNPJ+"CNPJ/CPF Ja Existe No Cadastro!"
		Z13->( MsUnLock() )
		Return .F.
   EndIf

	
	
	aCabec := {}
	lMsErroAuto := .F.
	
	if(!_lSeek)
		cCodSA1 := GetSx8Num("SA1","A1_COD")
		lSXE := .T.
		cLoja := "01"
	else		
		cCodSA1 := SA1->A1_COD
		cLoja	:= SA1->A1_LOJA
	endif
	
	
	aadd(aCabec,{"A1_COD"   ,cCodSA1,})
	aadd(aCabec,{"A1_LOJA",cLoja,})
	aadd(aCabec,{"A1_NOME",NoAcento(Z13->Z13_NOME),,".T."})
	aadd(aCabec,{"A1_PESSOA",iif(Len(Alltrim(Z13->Z13_CNPJ))>11,"J","F"),})
	aadd(aCabec,{"A1_NREDUZ",NoAcento(Z13->Z13_NOME),})
	aadd(aCabec,{"A1_END",NoAcento(Z13->Z13_END),})
	aadd(aCabec,{"A1_ENDCOB",NoAcento(Z13->Z13_END),})
	aadd(aCabec,{"A1_TIPO",iif(Len(Alltrim(Z13->Z13_CNPJ))>11,"S","F"),})
	aadd(aCabec,{"A1_EST",Upper(NoAcento(Z13->Z13_ESTADO)),})
	aadd(aCabec,{"A1_ESTE",Upper(NoAcento(Z13->Z13_ESTADO)),})
	
	If SELECT("QUERYCC1") > 0
		QUERYCC1->(DbCloseArea())
	EndIf
	
	cCC1 := ""
	cCC1 := "SELECT * FROM "+RetSqlName("CC2")+" WHERE D_E_L_E_T_='' AND CC2_EST = '"+Upper(NoAcento(Z13->Z13_ESTADO))+"' AND CC2_MUN = '"+Alltrim(Upper(StrTran(NoAcento(Z13->Z13_CIDADE),"'","")))+"'"
	cCC1 := ChangeQuery(cCC1)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCC1),"QUERYCC1",.F.,.T.)
	QUERYCC1->(DbgoTop())
	
	// IF(QUERYCC1->(Eof()))
	// IF !SELECT("QUERYCC1") > 0 .and.
	IF (QUERYCC1->(Eof()))
		
		If SELECT("QUERYCC2") > 0
			QUERYCC2->(DbCloseArea())
		EndIf
		
		cCC2 := ""
		cCC2 := "SELECT * FROM "+RetSqlName("CC2")+" WHERE D_E_L_E_T_='' AND CC2_EST = '"+Upper(NoAcento(Z13->Z13_ESTADO))+"' AND CC2_MUN LIKE '%"+Alltrim(Upper(StrTran(NoAcento(Z13->Z13_CIDADE),"'","")))+"%' ORDER BY CC2_MUN"
		cCC2 := ChangeQuery(cCC2)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCC2),"QUERYCC2",.F.,.T.)
		QUERYCC2->(DbgoTop())
		
		
		//If(!QUERYCC2->(Eof()))
		// IF SELECT("QUERYCC2") > 0 .and. 
		IF (!QUERYCC2->(Eof()))
		   
			aadd(aCabec,{"A1_COD_MUN",QUERYCC2->CC2_CODMUN,})
			aadd(aCabec,{"A1_MUN",QUERYCC2->CC2_MUN,})
			aadd(aCabec,{"A1_MUNE",QUERYCC2->CC2_MUN,})
			
			
			//------ Guarda o Estado e o código do município para posicionar a tabela CC2
			cEst    := Upper(NoAcento(Z13->Z13_ESTADO))
			cCodMun := QUERYCC2->CC2_CODMUN
			cCidade := QUERYCC2->CC2_MUN
			
			QUERYCC2->(DbClosearea())
		Else              
		    IF _lcep
		    
             	cCC3 := ""
		        cCC3 := "SELECT * FROM "+RetSqlName("CC2")+" WHERE D_E_L_E_T_='' AND CC2_EST = '"+Upper(NoAcento(Z07->Z07_UF))+"' AND CC2_MUN LIKE '%"+Alltrim(Upper(StrTran(NoAcento(Z07->Z07_MUNIC),"'","")))+"%' ORDER BY CC2_MUN"
		        cCC3 := ChangeQuery(cCC3)
		        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCC3),"QUERYCC3",.F.,.T.)
		        QUERYCC3->(DbgoTop())
	    
     		    IF SELECT("QUERYCC3") > 0
		   
                	aadd(aCabec,{"A1_COD_MUN",QUERYCC3->CC2_CODMUN,})
             		aadd(aCabec,{"A1_MUN",QUERYCC3->CC2_MUN,})
        			aadd(aCabec,{"A1_MUNE",QUERYCC3->CC2_MUN,})
			
			
            		//------ Guarda o Estado e o código do município para posicionar a tabela CC2
			        cEst    := Upper(NoAcento(Z07->Z07_UF))
             		cCodMun := QUERYCC3->CC2_CODMUN
           			cCidade := QUERYCC3->CC2_MUN
			
		         	QUERYCC3->(DbClosearea())
		        ELSE
        		     aadd(aCabec,{"A1_COD_MUN","",})
			         aadd(aCabec,{"A1_MUN","",})       
			         aadd(aCabec,{"A1_MUNE","",})
		        ENDIF
		     Else
		    
			      aadd(aCabec,{"A1_COD_MUN","",})
			      aadd(aCabec,{"A1_MUN","",})    
			      aadd(aCabec,{"A1_MUNE","",})
			 Endif     
		Endif
		
	Else
		aadd(aCabec,{"A1_COD_MUN",QUERYCC1->CC2_CODMUN,})
		aadd(aCabec,{"A1_MUN",QUERYCC1->CC2_MUN,})
		aadd(aCabec,{"A1_MUNE",QUERYCC1->CC2_MUN,})
		
		//------ Guarda o Estado e o código do município para posicionar a tabela CC2
		cEst    := Upper(NoAcento(Z13->Z13_ESTADO))
		cCodMun := QUERYCC1->CC2_CODMUN
		cCidade := QUERYCC1->CC2_MUN
		
	EndIf
	
	QUERYCC1->(DbClosearea())
	
	aadd(aCabec,{"A1_BAIRRO",NoAcento(Z13->Z13_BAIRRO),})
	aadd(aCabec,{"A1_BAIRROE",NoAcento(Z13->Z13_BAIRRO),})
	aadd(aCabec,{"A1_CEP",Padr(Z13->Z13_CEP,8,"0"),})
	aadd(aCabec,{"A1_CEPE",Padr(Z13->Z13_CEP,8,"0"),})
	aadd(aCabec,{"A1_DDD",substr(Z13->Z13_TEL,1,2),})
	aadd(aCabec,{"A1_TEL",substr(Z13->Z13_TEL,3,len(Z13->Z13_TEL)),})
	
	aadd(aCabec,{"A1_CGC",Z13->Z13_CNPJ,})
	aadd(aCabec,{"A1_INSCR",IIF(Empty(Z13->Z13_IE) .AND. LEN(ALLTRIM(Z13->Z13_CNPJ)) < 12,"ISENTO",Z13->Z13_IE),})
	aadd(aCabec,{"A1_TPFRET","C",})
	aadd(aCabec,{"A1_COND","001",})
	aadd(aCabec,{"A1_CODPAIS","01058",})
	aadd(aCabec,{"A1_TIPCLI","1",})
	aadd(aCabec,{"A1_EMAIL",IIF(Empty(Alltrim(Z13->Z13_EMAIL)),"SEMEMAIL@BGH.COM.BR",lower(Z13->Z13_EMAIL)),})
	aadd(aCabec,{"A1_COMPLEM",Z13->Z13_COMPLE,})
	aadd(aCabec,{"A1_RISCO","D",})
	aadd(aCabec,{"A1_XNUMCOM",Substr(NoAcento(Z13->Z13_END),Rat(" ",Alltrim(NoAcento(Z13->Z13_END))),Len(Alltrim(NoAcento(Z13->Z13_END))))+" "+Alltrim(Z13->Z13_COMPLE),})
	aadd(aCabec,{"A1_PAIS","105",})
	aadd(aCabec,{"A1_ENDENT",Alltrim(NoAcento(Z13->Z13_END))+" "+Alltrim(Z13->Z13_COMPLE),})
	aadd(aCabec,{"A1_TRANSP","01",})
	aadd(aCabec,{"A1_MENSAGE","002",})
	aadd(aCabec,{"A1_CONTRIB","2",})
	aadd(aCabec,{"A1_CONTA","1120100001",})
	          
	SA1->(RestArea(AreaSA1))
	CC2->(RestArea(AreaCC2))
	
	//----Posiciono
	CC2->(DbSetOrder(1))
	If !CC2->(DbSeek(xFilial("CC2")+cEst+cCodMun))
   
		If lBat
			U_ACMAILJB("Erro no cadastro de Clientes "+Z13->Z13_CNPJ,"Código Município","Não foi localizado o código do município. (Estado="+cEst+") (Código="+cCodMun+") (Cidade="+cCidade+")","CSS003",.F.)		
		Else		
			Aviso("Código Município","Não foi localizado o código do município. (Estado="+cEst+") (Código="+cCodMun+") (Cidade="+cCidade+")",{"OK"},3)

		Endif

		RecLock("Z13",.F.)
		Z13->Z13_STATUS := "E"
		Z13->Z13_LOG     := "Erro no cadastro de Clientes "+Z13->Z13_CNPJ+" Código Município não foi localizado o código do município. (Estado="+cEst+") (Código="+cCodMun+") (Cidade="+cCidade+")"
		Z13->( MsUnLock() )
		Return .F.

		
	EndIf
	BeginTran()
	
	dbselectarea("SA1")
	lMsErroAuto := .F.
	MsExecAuto({|x,y| MATA030(x,y)}, aCabec,iif(_lSeek,4,3))
	
	dbselectarea("Z13")
	RecLock("Z13",.F.)
	
	IF lMsErroAuto
		if(lSXE)
			RollbackSX8()
		endif
		
		DisarmTransaction()
		
		ALERT("Erro na Gravacao cadastro Cliente - Checar erro Registro "+Z13->Z13_CODIGO)
		IF(!lBat)
			MostraErro()
		Endif
		
		
		Z13->Z13_STATUS := "E"
		Z13->Z13_LOG    := "Erro na gravaçao cadastro Clientes "+Z13->Z13_CNPJ+"Erro ao cadastrar cliente via rotina de integração no Protheus - Tente Cadastrar manualmente."
		
		If lBat
			U_ACMAILJB("Erro na gravaçao cadastro Clientes "+Z13->Z13_CNPJ,"Erro ao cadastrar cliente via integração.","CSS003",.F.)		
		EndIf
		
		//--------------------------------------------
		//CLIENTE COM PROBLEMA NO CADASTRO.
		//ATUALIZA STATUS BGH
		//--------------------------------------------
	Else           
	   SA1->(dbSetorder(3)) // A1_FILIAL + A1_CGC
       IF SA1->(dbSeek(xFilial("SA1")+cCNPJ,.F.))

			Z13->Z13_STATUS := "S"
			Z13->Z13_CLIENT := cCodSA1
			Z13->Z13_LOJA   := cLoja
			Z13->Z13_ORIGEM := "SA1"  
	   		
			
	        ConfirmSX8()
	   ENDIF	
		//--------------------------------------------
		//CLIENTE GRAVADO COM SUCESSO
		//ATUALIZA STATUS BGH
		//--------------------------------------------
		
		
	endif
	Z13->(MsUnLock())
	EndTran()
	
Return !lMsErroAuto




/*
==============================================================================================================================================================
Função: NoAcento
==============================================================================================================================================================
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
==============================================================================================================================================================
Função: Css003Bat
==============================================================================================================================================================
*/
User Function CSS003BAT()
	Private nPosSA1 := 0
	
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" MODULO "COM" TABLES "SA1","Z13"
   
	cQ := "SELECT R_E_C_N_O_ AS NREC FROM "+RetSqlName("Z13")+" 
	cQ += " INNER JOIN ( SELECT Z14_CNPJ FROM "+RetSqlName("Z14")+" WHERE D_E_L_E_T_='' )  AS Z14"
	cQ += " ON Z14_CNPJ=Z13_CNPJ "	
	cQ += "	WHERE D_E_L_E_T_='' AND Z13_STATUS NOT IN ('E','S','D')"
	
	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYZ13",.F.,.T.)
	
	While(!QUERYZ13->(Eof()))
	
	dbselectarea("Z13")
	dbgoto(QUERYZ13->NREC)
	PROCSA1(.T.)
	QUERYZ13->(DbSkip())
enddo
QUERYZ13->(dbclosearea())

//Envio de relatório para efeito de verificação de schedule
U_ACMAILJB("CSS003","Rotina de integração de clientes do CSS Finalizado.","CSS003BAT")


Reset Environment

Return



/*
==============================================================================================================================================================
Função: TCss003a
==============================================================================================================================================================
*/
User Function TCss003A()
	
	M->Z13_LOJA := SUBSTR(SA1->A1_LOJA,1,TAMSX3("Z04_LOJA")[1])
	M->Z13_NOME := SUBSTR(SA1->A1_NOME,1,TAMSX3("Z04_NOME")[1])
	M->Z13_END := SUBSTR(SA1->A1_END,1,TAMSX3("Z04_END")[1])
	M->Z13_COMPLE := SUBSTR(SA1->A1_COMPLEM,1,TAMSX3("Z04_COMPLE")[1])
	M->Z13_BAIRRO := SUBSTR(SA1->A1_BAIRRO,1,TAMSX3("Z04_BAIRRO")[1])
	M->Z13_ESTADO := SUBSTR(SA1->A1_EST,1,TAMSX3("Z04_ESTADO")[1])
	M->Z13_CIDADE := SUBSTR(SA1->A1_MUN,1,TAMSX3("Z04_CIDADE")[1])
	M->Z13_CEP := SUBSTR(SA1->A1_CEP,1,TAMSX3("Z04_CEP")[1])
	M->Z13_CNPJ := SUBSTR(SA1->A1_CGC,1,TAMSX3("Z04_CNPJ")[1])
	M->Z13_IE := SUBSTR(SA1->A1_INSCR,1,TAMSX3("Z04_IE")[1])
	M->Z13_TEL := SUBSTR(SA1->A1_TEL,1,TAMSX3("Z04_TEL")[1])
	M->Z13_EMAIL := SUBSTR(SA1->A1_EMAIL,1,TAMSX3("Z04_EMAIL")[1])
	
Return .T.



/*
==============================================================================================================================================================
Função: GetProxNum
==============================================================================================================================================================
*/
Static Function GetProxNum()
	Local cAnt := ""
	dbselectarea("SA1")
	dbsetorder(1)
	if(nPosSA1 > 0)
		dbgoto(nPosSA1)
	else
		dbgotop()
	endif
	cAnt := SA1->A1_COD
	while(!eof())
	if(val(A1_COD)-val(cAnt) > 1)
		Return Strzero(val(cAnt)+1,6)
	else
		cAnt := SA1->A1_COD
		nPosSA1 := Recno()
	endif
	dbskip()
enddo

Return ""



/*
==============================================================================================================================================================
Função: GetMaxSa1
==============================================================================================================================================================
*/
Static Function GetMaxSA1()
	Local cProxSa1 := "000001"
	Local cQ2 := ""
	If Select("QUERYMAX") > 0
		QUERYMAX->(DbCloseArea())
	EndIf
	cQ2 := " SELECT A1_COD FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_=''  order by A1_COD DESC "
	cQ2 := ChangeQuery(cQ2)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ2),"QUERYMAX",.F.,.T.)
	if(!QUERYMAX->(eof()))
		cProxSa1 := Strzero(val(QUERYMAX->A1_COD)+1,6)
	endif
	QUERYMAX->(DbCloseArea())
	
Return cProxSa1
