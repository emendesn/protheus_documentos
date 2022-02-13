/*****
 *
 * Modelo usando a dbTree com a base de dados do SX5 - Tabelas Genéricas.
 *
 */
#INCLUDE "PROTHEUS.CH"

User Function xTrees()                                 
	Local cDADOS := ""
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local cCadastro := "Modelo dbTree com SX5"
	Local nRecPai := 0
	Local oDlg
	Local oTree
   Local aButton := {}
   
	AAdd( aButton,{"PESQUISA"  ,{|| PesqTree( oTree ) },"Pesquisar..."})

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 122,0 TO 432,600 OF oDlg PIXEL
	   oTree := dbTree():New(0,0,0,0,oDlg,{|| xProcTrees(oTree:GetCargo())},,.T.)
	   oTree:Align := CONTROL_ALIGN_ALLCLIENT
	
		MsgRun("Carregando dados do SX5 - Tabelas genéricas, aguarde...",,{|| LoadSX5( cDADOS, nRecPai, oTree, cBmp1, cBmp2 )})
		
		oTree:EndTree()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButton)
Return

Static Function LoadSX5( cDADOS, nRecPai, oTree, cBmp1, cBmp2 )
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5")))
	While SX5->(!EOF()) .And. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"00"

		cDADOS  := RTrim( SX5->X5_CHAVE )
		nRecPai := SX5->( RecNo() )

		oTree:AddTree( cDADOS + " - " + X5Descri(), .T., cBmp1, cBmp1,,,"#"+SX5->X5_CHAVE )
		
		SX5->( dbSeek( xFilial("SX5") + cDADOS ) )
		
		While SX5->(!EOF()) .And. SX5->( X5_FILIAL + X5_TABELA ) == xFilial("SX5") + cDADOS
			oTree:AddTreeItem( RTrim(SX5->X5_CHAVE) + " - " + X5Descri(), cBmp2,, LTrim( Str( SX5->( RecNo() ) ) ) )
	   	SX5->( dbSkip() )
	   	
		End
		oTree:EndTree()
		SX5->( dbGoTo( nRecPai ) )
		SX5->( dbSkip() )		
	End
Return

Static Function xProcTrees(cCargo)
	If ! ( "#" $ cCargo )
		MsgAlert("Número do RECNO(): "+cCargo)
	Endif
Return

Static Function PesqTree( oTree )
	Local aPar := {}
	Local aRet := {}
 
	AAdd( aPar,{1,"Tabela",Space(6),"","","","",0,.T.})
	If ParamBox( aPar,"Pesquisar",@aRet,,,,,,,,.F.)
		oTree:TreeSeek( "#"+RTrim( aRet[1] ) )
 	Else
 		MsgAlert("Não localizado")
   Endif
Return