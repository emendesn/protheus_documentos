///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Get_Dados()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao da utilizacao da funcao Getdados                   |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

User Function Get_Dados()

Private cCadastro := "GetDados - Modelo 2"
Private aRotina := {}

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"    ,0,1})
aAdd( aRotina, {"Visualizar" ,'u_Mod2Visual',0,2})
aAdd( aRotina, {"Incluir"    ,'u_Mod2Inclui',0,3})
aAdd( aRotina, {"Alterar"    ,'u_Mod2Altera',0,4})
aAdd( aRotina, {"Excluir"    ,'u_Mod2Exclui',0,5})

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

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Visual()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de visualizacao                                          |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Visual( cAlias, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local oTPane1
Local oTPane2

Private cCodigo := ZA3->ZA3_CODIGO
Private cNome   := ZA3->ZA3_NOME
Private dData   := ZA3->ZA3_DATA
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( xFilial("ZA3") + cCodigo )

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		                X3_CAMPO        ,;
		                X3_PICTURE      ,;
		                X3_TAMANHO      ,; 
		                X3_DECIMAL      ,; 
		                X3_VALID        ,;
		                X3_USADO        ,;
		                X3_TIPO         ,;
		                X3_ARQUIVO      ,;
		                X3_CONTEXT      })
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSeek( xFilial("ZA3") + cCodigo )

While !Eof() .And. ZA3->ZA3_FILIAL + ZA3->ZA3_CODIGO == xFilial("ZA3") + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406
	
	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Inclui()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de inclusao                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Inclui(cAlias,nReg,nOpcX)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oTPane1
Local oTPane2

Private cCodigo := Space(Len(ZA3->ZA3_CODIGO))
Private cNome   := Space(Len(ZA3->ZA3_NOME))
Private dData   := dDataBase
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea("SX3")
dbSeek(cAlias)
While !EOF() .And. X3_ARQUIVO == cAlias
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_ARQUIVO  ,;
		               X3_CONTEXT  })
	Endif
	dbSkip()
End

aAdd( aCOLS,Array(Len(aHeader)+1))

dbSelectArea("SX3")
dbSeek(cAlias)
nUsado:=0
While !EOF() .And. X3_ARQUIVO == cAlias
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		IF X3_TIPO == "C"
			If Trim(aHeader[nUsado][2]) == "ZA3_ITEM"
				aCOLS[1][nUsado] := "01"
			Else
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Endif
		ELSEIF X3_TIPO == "N"
			aCOLS[1][nUsado] := 0
		ELSEIF X3_TIPO == "D"
			aCOLS[1][nUsado] := dDataBase
		ELSEIF X3_TIPO == "M"
			aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		ELSE
			aCOLS[1][nUsado] := .F.
		Endif
		If X3_CONTEXT == "V"
			aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		Endif
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSetOrder(1)

aCOLS[1][nUsado+1] := .F.

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo F3 "SA3" PICTURE "@!" VALID U_PesqSA3(cCodigo) SIZE 030,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome When .F.              SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData PICTURE "99/99/99"    SIZE 40,7 PIXEL OF oTPane1

	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","+ZA3_ITEM",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	   U_Mod2Grava(cAlias)
	End Transaction
Endif
dbSelectArea(cAlias)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Altera()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de alteracao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Altera( cAlias, nRecNo, nOpcX )
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local oTPane1
Local oTPane2

Private cCodigo := ZA3->ZA3_CODIGO
Private cNome   := ZA3->ZA3_NOME
Private dData   := ZA3->ZA3_DATA
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( xFilial("ZA3") + cCodigo )

dbSelectArea("SX3")
dbSeek(cAlias)
While !EOF() .And. X3_ARQUIVO == cAlias
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSeek( xFilial("ZA3") + cCodigo )

While !EOF() .And. ZA3->ZA3_FILIAL + ZA3->ZA3_CODIGO == xFilial("ZA3") + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek(cAlias)
	While !EOF() .And. X3_ARQUIVO == cAlias
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","+ZA3_ITEM",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
   Begin Transaction
      U_Mod2Grava(cAlias)
   End Transaction
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Exclui()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de exclusao                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Exclui( cAlias, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local nX       := 0
Local oTPane1
Local oTPane2

Private cCodigo := ZA3->ZA3_CODIGO
Private cNome   := ZA3->ZA3_NOME
Private dData   := ZA3->ZA3_DATA
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := {}

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

//Fazer pesquisar para saber se o(s) registro(s) pode(m) ser excluídos

dbSetOrder(1)
dbSeek( xFilial("ZA3") + cCodigo )

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSeek( xFilial("ZA3") + cCodigo )

While !Eof() .And. ZA3->ZA3_FILIAL + ZA3->ZA3_CODIGO == xFilial("ZA3") + cCodigo
   aAdd( aCOLS, Array(Len(aHeader)+1))
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := cAlias+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 080 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	dbSelectArea(cAlias)
	dbSetOrder(1)
	For nX = 1 to Len(aCols)
		dbSeek( xFilial("ZA3") + cCodigo+aCols[nX,GdFieldPos("ZA3_ITEM")] )
		RecLock(cAlias,.F.)
		dbDelete()
	Next nx
	MsUnLock(cAlias)
	End Transaction
Endif

Return

//+------------------------------------------------------------------------------+
//|******************************************************************************|
//|******************+---------------------------------------+*******************|
//|******************| FUNCOES GENEREICAS PARA ESTE PROGRAMA |*******************|
//|******************+---------------------------------------+*******************|
//|******************************************************************************|
//+------------------------------------------------------------------------------+

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ModLinOk()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Verifica se a linha esta ok                                     |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2LinOk()
Local lRet := .T.
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
If !aCOLS[n,Len(aHeader)+1]
   If Empty(aCOLS[n,GdFieldPos("ZA3_CCUSTO")])
      cMsg := "Nao sera permitido linhas sem o centro de custo."
      Help("",1,"","Mod2LinOk",cMsg,1,0)
      lRet := .F.
   Endif
Endif

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2TudOk()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar se todas as linhas estao OK                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2TudOk()
Local lRet := .T.

lRet := u_Mod2LinOk()

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2Grava()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de para gravar os dados                                  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Grava(cAlias)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lOk := .T.
Local cMsg := ""

dbSelectArea(cAlias)
dbSetOrder(1)

For nI := 1 To Len(aCols)
   dbSeek( xFilial(cAlias) + cCodigo + aCOLS[nI,GdFieldPos("ZA3_ITEM")] )

   If !aCOLS[nI,Len(aHeader)+1]            
      If Found()
         RecLock(cAlias,.F.)
      Else
         RecLock(cAlias,.T.)
      Endif
      
      ZA3->ZA3_FILIAL := xFilial(cAlias)
      ZA3->ZA3_CODIGO := cCodigo
      ZA3->ZA3_NOME   := cNome
      ZA3->ZA3_DATA   := dData
            
      For nY = 1 to Len(aHeader)
         If aHeader[nY][10] # "V"
            cVar := Trim(aHeader[nY][2])
            Replace &cVar. With aCOLS[nI][nY]
         Endif
      Next nY
      MsUnLock(cAlias)      
   Else
      If !Found()
         Loop
      Endif
      //Fazer pesquisa para saber se o item poderar ser deletado e
      If lOk
         RecLock(cAlias,.F.)
            dbDelete()
         MsUnLock(cAlias)
      Else
         cMsg := "Nao foi possivel deletar o item "+aCols[nI,GdFieldPos("ZA3_ITEM")]+", o mesmo possui amarracao"
         Help("",1,"","NAOPODE",cMsg,1,0)
      Endif
   Endif
Next nI

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Get_Dados.prw        | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - PesqSA3()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar se o codigo existe                                      |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function PesqSA3(cCodigo)
Local lRet := .T.

dbSelectArea("ZA3")
dbSetOrder(1)
If dbSeek( xFilial("ZA3") + cCodigo )
   Help("",1,"","Cod_Existe","Este Vendedor já têm cadastro",1,0)
   lRet := .F.
Endif

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+cCodigo)

If Eof()
   lRet := .F.
Else
   cNome := SA3->A3_NOME
Endif

Return( lRet )