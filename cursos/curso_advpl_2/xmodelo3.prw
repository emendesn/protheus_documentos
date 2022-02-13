#INCLUDE "PROTHEUS.CH"

User Function xModelo3()

Private cTitulo := "Atualização de orçamento"
Private cAlias1 := "ZA1"
Private cAlias2 := "ZA2"
Private aRotina := {}

aAdd( aRotina ,{"Pesquisar" ,"AxPesqui"    ,0,1})
aAdd( aRotina ,{"Visualizar","u_xMod3Atual",0,2})
aAdd( aRotina ,{"Incluir"   ,"u_xMod3Atual",0,3})
aAdd( aRotina ,{"Alterar"   ,"u_xMod3Atual",0,4})
aAdd( aRotina ,{"Excluir"   ,"u_xMod3Atual",0,5})

dbSelectArea(cAlias2)
dbSetOrder(1)
cFilZA2 := xFilial(cAlias2)

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilZA1 := xFilial(cAlias1)

mBrowse(,,,,cAlias1)

Return

User Function xModAtual( cAlias, nRec, nOpc )
Local i := 0
Local cCliente 
Local oCliente
Local nValor := 0
Local oValor
Local nOpcA := 0
Local oGet
Local oDlg 

Private aHeader := {}
Private aCOLS := {}
Private nUsado := 0
Private bCpo := { |nField| Field(nField) }
Private aRecNo := {}
Private aTELA := {}
Private aGETS := {}

Private aPosEnch := {15, 1, 70, 315}
Private aSize := {}
Private aObjects := {}
Private aInfo := {}
Private aPosObj := {}
Private aPosGet := {}

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,100,.T.,.T.})
aAdd(aObjects,{100,100,.T.,.T.})
aAdd(aObjects,{100,015,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRec)

For i := 1 To FCount()
	If nOpc == 3
      M->&( Eval( bCpo, i ) ) := CriaVar( FieldName( i ), .T. )
   Else
      M->&( Eval( bCpo, i ) ) := FieldGet( i )
   Endif
Next i

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)

While !Eof() .And. X3_ARQUIVO == cAlias2
   If X3USO( X3_USADO ) .And. cNivel >= X3_NIVEL
      aAdd( aHeader, { Trim( X3Titulo() ), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
      nUsado++
   Endif
   dbSkip()
End

If nOpc == 3
   aAdd( aCOLS, Array( nUsado + 1 ) )
   nUsado := 0
   
   dbSelectArea("SX3")
   dbSetOrder(1)
   dbSeek(cAlias2)
   
   While !Eof() .And. X3_ARQUIVO == cAlias2
	   If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		   nUsado++
		   aCOLS[ 1, nUsado ] := CriaVar( Trim( X3_CAMPO ), .T. )
      Endif
      dbSkip()
   End

   aCOLS[ 1, nUsado+1 ] := .F.
   aCOLS[ 1, aScan( aHeader, {|x| Trim( x[ 2 ] ) == "ZA2_ITEM" } ) ] := StrZero(1,TamSX3("ZA2_ITEM")[1],0)
Else
   dbSelectArea( cAlias2 )
   dbSetOrder( 1 )
   dbSeek( cFilZA2 + ZA1->ZA1_NUM )

   While !Eof() .And. cFilZA2 == ZA2_FILIAL .And. ZA2_NUM == ZA1_NUM
      aAdd( aCOLS, Array( nUsado+1 ) )
      nCOLS ++
      nTotal += ZA2_VALOR
   
      For i := 1 To nUsado
         If aHeader[ i, 10 ] <> "V"
            aCOLS[ nCOLS, i ] := FieldGet( FieldPos( aHeader[ i, 2 ] ) )
         Else
            aCOLS[ nCOLS, i ] := CriaVar( aHeader[ i, 2 ], .T. )
         Endif
      Next i
   
      aAdd( aRecNo, RecNo() )
      aCOLS[ nCOLS, nUsado+1 ] := .F.
      dbSelectArea( cAlias2 )
      dbSkip()
   End

Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
EnChoice( cAlias1, nRec, nOpc, , , , , aPosObj[1], , 3)

@ aPosObj[3,1],aPosGet[1,1] SAY "Cliente: " SIZE 70,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,2] SAY oCliente VAR cCliente SIZE 98,7 OF oDlg PIXEL

@ aPosObj[3,1],aPosGet[1,3] SAY "Valor Total: " SIZE 70,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,4] SAY oTotal VAR nTotal PICTURE aHeader[ aScan( aHeader, {|x| Trim (x[2] ) == "ZA2_VALOR" } ), 3 ] SIZE 70,7 OF oDlg PIXEL

u_Mod3AtuCli()

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_Mod3LinOk()","u_Mod3TudOk()","+ZA2_ITEM",.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(u_Mod3Tudok().And.Obrigatorio(aGETS,aTELA),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})


If nOpcA == 1 .And. nOpc >= 3
	Begin Transaction
	If Mod3Grv( nOpc )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		Endif
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8()
	Endif
Endif

Return

Static Function Mod3Grv( nOpc )
Local nP_Item
Local nP_Prod
Local i := 0
Local y := 0

dbSelectArea(cAlias2)

For i := 1 To Len( aCOLS )
   nP_Item := GdFieldPos("ZA2_ITEM")
   nP_Prod := GdFieldPos("ZA2_PRODUT")
   
   dbSeek( cFilZA2 + M->ZA1_NUM + aCOLS[ i, nP_Item ] + aCOLS[ i, nP_Prod ] )
   If !aCOLS[ i, nUsado+1 ]
      If Found()
         RecLock(cAlias2,.F.)
      Else
         RecLock(cAlias2,.T.)
      Endif
      
      ZA2->ZA2_FILIAL := cFilZA2
      ZA2->ZA2_NUM    := M->ZA1_NUM
      
      For y := 1 To Len( aHeader )
         If aHeader[ y, 10 ] <> "V"
            FieldPut( FieldPos( aHeader[ y, 2 ] ), aCOLS[ i, y ] )
         Endif
      Next y
      MsUnLock()
   Else
      If !Found()
         Loop
	   Endif
      RecLock( cAlias1, .F. )
         dbDelete()
      MsUnLock( cAlias1 )
   Endif
Next i

dbSelectArea( cAlias1 )

If nOpc >= 4

Endif

Return( lRet )