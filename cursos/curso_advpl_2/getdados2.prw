/*
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ GetDados2  ¦ Autor ¦ Robson Luiz          ¦ Data ¦ 16/04/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Programa exemplo da utilização da classe MsGetDados           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Uso       ¦ Oficina de Programação                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

User Function GetDados2()

Private cCadastro := "MsGetDados"
Private aRotina := {}

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui" ,0,1})
aAdd( aRotina, {"Visualizar" ,'u_GDManut',0,2})
aAdd( aRotina, {"Incluir"    ,'u_GDManut',0,3})
aAdd( aRotina, {"Alterar"    ,'u_GDManut',0,4})
aAdd( aRotina, {"Excluir"    ,'u_GDManut',0,5})

U_xGeraBase()

If Empty(Posicione("SX3",1,"ZA3","X3_ARQUIVO"))
   Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+ENTER+"X3, X2, IX E X7",1,0)
   RETURN
Endif

dbSelectArea("ZA3")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"ZA3")

Return

/*
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ GDManut    ¦ Autor ¦ Robson Luiz          ¦ Data ¦ 16/04/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Programa exemplo da utilização da classe MsGetDados           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Uso       ¦ Oficina de Programação                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function GDManut(cAlias,nRecNo,nOpc)
	
	Local nI := 0
	Local nCOLS := 0
	Local nOpcA := 0
	
	Local oDlg
	Local oGet
	Local oPane1
	Local oPane2
	Local aRGB := {72,145,145}
	Local	aArea := GetArea()
	
	Private cCodigo := CriaVar("ZA3_CODIGO",.T.)
	Private cNome := CriaVar("ZA3_NOME",.T.)
	Private dData := CriaVar("ZA3_DATA",.T.)
	Private aHeader := {}
	Private aCOLS := {}

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)

	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			aAdd( aHeader, { Trim(X3Titulo()),;
			X3_CAMPO,;
			X3_PICTURE,;
			X3_TAMANHO,;
			X3_DECIMAL,;
			X3_VALID,;
			X3_USADO,;
			X3_TIPO,;
			X3_ARQUIVO,;
			X3_CONTEXT})
		Endif
		dbSkip()
	End
	
	If nOpc == 3
		nCOLS := 0
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		dbSeek(cAlias)
		While !EOF() .And. X3_ARQUIVO == cAlias
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				nCOLS++
				aCOLS[1,nCOLS] := CriaVar(X3_CAMPO,.T.)
			Endif
			dbSkip()
		End
		aCOLS[1,nCOLS+1] := .F.
		aCOLS[1,GdFieldPos("ZA3_ITEM")] := "01"
	Else
		cCodigo := ZA3->ZA3_CODIGO
		cNome   := ZA3->ZA3_NOME
		dData   := ZA3->ZA3_DATA 
		
		dbSelectArea(cAlias)
		dbSetOrder(1)
		dbSeek(xFilial(cAlias)+ZA3->ZA3_CODIGO)
		
		While !EOF() .And. ZA3->(ZA3_FILIAL+ZA3_CODIGO) == xFilial(cAlias) + cCodigo
			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			nCOLS++
			For nI := 1 To Len( aHeader )
				If aHeader[nI,10] == "V"
					aCOLS[nCOLS,nI] := CriaVar( aHeader[nI,2], .T. )
				Else
					aCOLS[nCOLS,nI] := FieldGet( FieldPos( aHeader[nI,2] ) )
				Endif
			Next nI
			aCOLS[ nCOLS, Len( aCOLS[ nCOLS ] ) ] := .F.
			dbSkip()
		End
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 300,600 OF oMainWnd PIXEL 
		oDlg:lMaximized := .T.
		
		oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane1:Align := CONTROL_ALIGN_TOP
		oTPane1:NCLRPANE := RGB(aRGB[1],aRGB[2],aRGB[3])
		
		@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
		@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
		@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

		@ 3, 026 MSGET cCodigo When nOpc==3 F3 "SA3" PICTURE "@!" VALID U_PesqSA3(cCodigo) SIZE 30,7 PIXEL OF oTPane1
		@ 3, 080 MSGET cNome   When .F.                                                    SIZE 78,7 PIXEL OF oTPane1
		@ 3, 192 MSGET dData   When nOpc==3 PICTURE "99/99/99"                             SIZE 40,7 PIXEL OF oTPane1

		oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPane2:Align := CONTROL_ALIGN_BOTTOM
		oTPane2:NCLRPANE := RGB(aRGB[1],aRGB[2],aRGB[3])

		oGet := MSGetDados():New(0,0,0,0,nOpc,"u_Mod2LinOk()","u_Mod2TudOk()","+ZA3_ITEM",.T.)
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
	EnchoiceBar(oDlg,;
	{|| iif((nOpc==2.Or.nOpc==5),(nOpcA:=1,oDlg:End()),;
		 iif((nOpc==3.Or.nOpc==4),iif(MsgYesNo("Confirma a gravação",cCadastro),(nOpcA:=1,oDlg:End()),NIL),NIL))	 }, ;
	{|| oDlg:End() },;
	(nOpc==5))

   // Se clicado em Ok
   If nOpcA == 1 .And. (nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5)
   	// Se a funcionalidade for incluir ou alterar
   	If nOpc == 3 .Or. nOpc == 4
			Begin Transaction
	   	U_Mod2Grava(cAlias)
			End Transaction
      // Se a funcionalidade for excluir
      Elseif nOpc == 5
      	dbSelectArea(cAlias)
      	dbSetOrder(1)
      	dbSeek(xFilial(cAlias)+cCodigo)
      	Begin Transaction
      	While !EOF() .And. ZA3->(ZA3_FILIAL+ZA3_CODIGO) == xFilial(cAlias)+cCodigo
      		RecLock(cAlias,.F.)
      		dbDelete()
      		MsUnLock()
      		dbSkip()
      	End
      	End Transaction
      Endif
   Endif
   
	RestArea(aArea)
Return