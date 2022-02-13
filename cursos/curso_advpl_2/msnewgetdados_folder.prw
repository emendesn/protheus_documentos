#Include "Protheus.ch"

User Function MsNwGtDs()
	
	Private cCadastro := "MsNewGetDados dividido em pastas"
	Private aRotina := {}
	
	aAdd( aRotina, {"Pesquisar"  ,"AxPesqui" ,0,1})
	aAdd( aRotina, {"Visualizar" ,'U_MsNwInc',0,2})
	aAdd( aRotina, {"Incluir"    ,'U_MsNwInc',0,3})
	aAdd( aRotina, {"Alterar"    ,'U_MsNwInc',0,4})
	aAdd( aRotina, {"Excluir"    ,'U_MsNwInc',0,5})
	
	dbSelectArea("ZA4")
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse(,,,,"ZA4")	
Return

User Function MsNwInc( cAlias, nRec, nOpcX )
   Local aFolder := {}
   Local oDlg
   Local oFld
   Local oTPanel
	Local nFldCtb := 0
	Local cCodUsu := Space(6)
	Local cNomUsu := Space(25)
	Local nOpc := 0
	
   // Campos no MsDialog..............: ZA3_CODUSE, ZA3_NOMUSE
   
   // Campos no primeiro MsNewGetDados: ZA4_CUSTO, ZA4_CTTDES
   // Campos no segundo MsNewGetDados.: ZA4_ITEM, ZA4_CTDDES
   // Campos no terceiro MsNewGetDados: ZA4_CLVL, ZA4_CTHDES
   Local aNoCpo1 := {"ZA4_CODUSE","ZA4_NOMUSE","ZA4_ITEM","ZA4_CTDDES","ZA4_CLVL","ZA4_CTHDES"}
   Local aNoCpo2 := {"ZA4_CODUSE","ZA4_NOMUSE","ZA4_CUSTO","ZA4_CTTDES","ZA4_CLVL","ZA4_CTHDES"}
   Local aNoCpo3 := {"ZA4_CODUSE","ZA4_NOMUSE","ZA4_CUSTO","ZA4_CTTDES","ZA4_ITEM","ZA4_CTDDES"}
      
	Private aHeader1 := {}
	Private aCOLS1 := {}
	Private oGetDad1
	
	Private aHeader2 := {}
	Private aCOLS2 := {}
	Private oGetDad2
	
	Private aHeader3 := {}
	Private aCOLS3 := {}
   Private oGetDad3
      
   AAdd( aFolder, "Centro de custo" )
   AAdd( aFolder, "Item contábil" )
   AAdd( aFolder, "Classe de valor" )
	
	LoadArrays( nOpcX, "ZA4", aCOLS1, aHeader1, /*cWhere*/, /*aOrder*/, oGetDad1, aNoCpo1, /*cQuery*/)
	LoadArrays( nOpcX, "ZA4", aCOLS2, aHeader2, /*cWhere*/, /*aOrder*/, oGetDad2, aNoCpo2, /*cQuery*/)
	LoadArrays( nOpcX, "ZA4", aCOLS3, aHeader3, /*cWhere*/, /*aOrder*/, oGetDad3, aNoCpo3, /*cQuery*/)
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 400,800 OF oMainWnd PIXEL 
		oDlg:lEscClose := .F.
		
		oTPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel:Align := CONTROL_ALIGN_TOP

		@ 5,02 SAY "Usuário:" SIZE 20,7 PIXEL OF oTPanel
		@ 4,30 MSGET cCodUsu F3 "USR" Valid VldUser( cCodUsu, @cNomUsu ) Picture "@!"  SIZE 20,7 PIXEL OF oTPanel
		@ 4,70 MSGET cNomUsu Picture "@!" When .F. SIZE 80,7 PIXEL OF oTPanel
		
		oFld := TFolder():New( 5, 5, aFolder, , oDlg,,,,.T.,.F.,215,130, )
		oFld:Align := CONTROL_ALIGN_ALLCLIENT
		
		oGetDad1 := MsNewGetDados():New(1,1,1,1,GD_INSERT+GD_UPDATE+GD_DELETE,"AllWaysTrue","AllWaysTrue","",,,999,,,,oFld:aDialogs[1],aHeader1,aCOLS1,)
		oGetDad1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		oGetDad2 := MsNewGetDados():New(1,1,1,1,GD_INSERT+GD_UPDATE+GD_DELETE,"AllWaysTrue","AllWaysTrue","",,,999,,,,oFld:aDialogs[2],aHeader2,aCOLS2,)
		oGetDad2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

		oGetDad3 := MsNewGetDados():New(1,1,1,1,GD_INSERT+GD_UPDATE+GD_DELETE,"AllWaysTrue","AllWaysTrue","",,,999,,,,oFld:aDialogs[3],aHeader3,aCOLS3,)
		oGetDad3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT		
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, ;
	{|| Iif( MsgYesNo("Confirma a gravação dos dados?",cCadastro),( nOpc:=1, oDlg:End() ), NIL) }, ;
	{|| oDlg:End() } )
	
	If nOpc == 1
		Processa({|| NwGdGrava( cCodUsu )},cCadastro,"Gravando os dados, aguarde...",.F.)
	Endif
Return

Static Function NwGdGrava( cCodUsu )
	Local nI := 0
	Local nX := 0
	Local nY := 0
	Local aDADOS := {}
	Local aCPOS := {}
	
	For nI := 1 To 3
		aDADOS := &("oGetDad" + LTrim( Str(nI,1,0) )+ ":aCOLS")
		aCPOS  := &("oGetDad" + LTrim( Str(nI,1,0) )+ ":aHeader")
		
		For nX := 1 To Len( aDADOS )
			If aDADOS[ nX, Len( aCPOS ) + 1 ]
				Loop
			Endif
			If Empty( aDADOS[ nX, 1 ] )
				Loop
			Endif
			
			ZA4->(RecLock("ZA4",.T.))
			ZA4->ZA4_FILIAL := xFilial("ZA4")
			ZA4->ZA4_CODUSE := cCodUsu
			
			For nY := 1 To Len( aCPOS )
				// É campo virtual
				If aCPOS[ nY, 8 ] == "V"
					Loop
				Endif
				// É campo de controle
				If RTrim( aCPOS[ nY, 2 ] ) $ "ZA4_ALI_WT|ZA4_REC_WT"
					Loop
				Endif
				// Efetuar a gravação dos demais campos
				ZA4->( FieldPut( FieldPos( RTrim( aCPOS[ nY,2 ] ) ), aDADOS[ nX, nY ] ) )
			Next nY
			ZA4->(MsUnLock())
		Next nX
	Next nI
Return

User Function NwGdValid()
	Local cCpo := ReadVar()
	Local aArray := {}
	Local nLinAtu := 0
	Local nCol := 0
	Local lRet := .T.
	Local nI := 0
	
	If cCpo == "M->ZA4_CUSTO"
		aArray  := oGetDad1:aCOLS
		nCol    := AScan(oGetDad1:aHeader,{|x| RTrim(x[2]) == "ZA4_CUSTO"})
		nLinAtu := oGetDad1:oBrowse:nAt		
	Elseif cCpo == "M->ZA4_ITEM"
		aArray  := oGetDad2:aCOLS
		nCol    := AScan(oGetDad2:aHeader,{|x| RTrim(x[2]) == "ZA4_ITEM"})
		nLinAtu := oGetDad2:oBrowse:nAt
	Elseif cCpo == "M->ZA4_CLVL"
		aArray  := oGetDad3:aCOLS
		nCol    := AScan(oGetDad3:aHeader,{|x| RTrim(x[2]) == "ZA4_CLVL"})
		nLinAtu := oGetDad3:oBrowse:nAt
	Endif
	
	For nI := 1 To Len( aArray )
		If nI == nLinAtu
			Loop
		Endif
		If aArray[ nI, nCol ] == &(cCpo) //aArray[ nLinAtu, nCol ]
			MsgAlert("Já existe este dado em outra linha, verifique.",cCadastro)
			lRet := .F.
			Exit
		Endif
	Next nI
Return( lRet )

Static Function LoadArrays( nOpc, cAlias, aCOLS, aHeader, cWhere, aOrder, oGetDad, aNoFields, cQuery )
	Local nX        := 0
	Local lExec     := (cQuery == NIL)
	Local cOrder    := ""

	DEFAULT aOrder := {}
	DEFAULT cWhere := ""

	aCOLS := {}

	dbSelectArea(cAlias)

	If nOpc != 3
		If lExec
			// Monta Query
			cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " WHERE "
			
			// Filtra filial
			cQuery += cAlias+"."+cAlias+"_FILIAL = '"+xFilial(cAlias)+"' AND "
			
			// Verifica condicao Where
			If !Empty(cWhere)
				cQuery += cWhere + " AND "
			EndIf
			
			// Filtra refistros deletados
			cQuery += cAlias+".D_E_L_E_T_ = ' ' "
			
			// Monta ordem dos registros
			If Len(aOrder) > 0
				For nX:=1 to len(aOrder)
					cOrder += aOrder[nX]+","
				Next nX
				cQuery += "ORDER BY " + SubStr(cOrder,1,len(cOrder)-1)
			Endif
		Endif
		
		// Executa
		FillGetDados(nOpc,cAlias,1,,,{|| .T. },aNoFields,,,cQuery,,,If(len(aHeader)>0,NIL,aHeader),aCols)
	Else
		FillGetDados(nOpc,cAlias,1,,,,aNoFields,,,,,.T.,aHeader,aCols)
	Endif
	
	// Atualiza a getdados
	If oGetDad != Nil
		oGetDad:aCols := aCOLS
		oGetDad:oBrowse:Refresh()
		oGetDad:Refresh()
	Endif
	
Return

Static Function VldUser( cCodUsu, cNomUsu )
	PswOrder( 1 )
	If	PswSeek( cCodUsu )
		cNomUsu := PswRet( 1 )[ 1 ][ 2 ]
	Else
		HELP("   ",1,"USR_EXIST")
		Return(.F.)
	Endif
Return(.T.)

/*
CodUse - C - 6 - Usuário
Nome - C - 25 - Nome do usuário

CTT_CUSTO - CENTRO DE CUSTO - C - 9 - C.Custo
CTT_DESC01 - DESCRIÇÃO MOEDA 1 - C - 40 - Desc Moeda 1 - Virtual

CTD_ITEM - ITEM CONTABIL - C - 9 - Item Contab
CTD_CTD_DESC01 - DESCRIÇÃO MOEDA 1 - C - 40 - Desc Moeda 1

CTH_CLVL - CODIGO CLASSE DE VALOR - C - 9 - Cod Cl Valor
CTH_DESC01 - DESCRIÇÃO MOEDA 1 - C - 40 - Desc Moeda 1
*/