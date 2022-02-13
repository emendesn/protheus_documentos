///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Pai_Filho()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Programa que demonstra a utilizacao do relacionamento de duas   |//
//|           | tabela com MsDialog, Enchoice e GetDados.                       |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+--------------------------------------------------------------------------------
| Parâmetros da Classe MsGetDados():New()
+--------------------------------------------------------------------------------
| MsGetDados():New( nSuperior, nEsquerda, nInferior, nDireita, nOpc, cLinhaOk, ;
|                   cTudoOk, cIniCpos, lApagar, aAlter, uPar1, lVazio, nMax, ;
|                   cCampoOk, cSuperApagar, uPar2, cApagaOk, oWnd )
+--------------------------------------------------------------------------------
| nSuperior....: 1  Distancia entre a MsGetDados e o extremidade superior do objeto que a contém
| nEsquerda....: 2  Distancia entre a MsGetDados e o extremidade esquerda do objeto que a contém
| nInferior....: 3  Distancia entre a MsGetDados e o extremidade inferior do objeto que a contém
| nDireita.....: 4  Distancia entre a MsGetDados e o extremidade direita do objeto que a contém
| nOpc.........: 5  Posição do elemento do vetor aRotina que a MsGetDados usará como referencia
| cLinhaOk.....: 6  Função executada para validar o contexto da linha atual do aCols
| cTudoOk......: 7  Função executada para validar o contexto geral da MsGetDados (todo aCols)
| cIniCpos.....: 8  Nome dos campos do tipo caracter que utilizarão incremento automático. 
|                   Este parâmetro deve ser no formato "+<nome do primeiro campo>+<nome do 
|                   segundo campo>+..."
| lApagar......: 9  Habilita deletar linhas do aCols. Valor padrão verdadeiro.
| aAlter.......: 10 Vetor com os campos que poderão ser alterados
| uPar1........: 11 Parâmetro reservado
| lVazio.......: 12 Habilita validação da primeira coluna do aCols para esta não poder estar vazia. 
|                   Valor padrão falso
| nMax.........: 13 Número máximo de linhas permitidas. Valor padrão 99
| cCampoOk.....: 14 Função executada na validação do campo
| cSuperApagar.: 15 Função executada quando pressionada as teclas <Ctrl>+<Delete>
| uPar2........: 16 Parâmetro reservado
| cApagaOk.....: 17 Função executada para validar a exclusão de uma linha do aCols
| oWnd.........: 18 Objeto no qual a MsGetDados será criada
+--------------------------------------------------------------------------------

+------------------------------------------------------------------------------------------------------------------
| Parâmetros da função EncoiceBar()
+------------------------------------------------------------------------------------------------------------------
| EnChoice(cAlias,nReg,nOpc,aAc,cOpc,cTextExclui,aAcho,aPos,aCpos,nNum,nColMens,cMensagem,cTudOk,oObj,lF3,lVirtual)
+------------------------------------------------------------------------------------------------------------------
| cAlias......: Alias da tabela selecionada
| nReg........: número do registro
| nOpc........: número da funcionalidade da funcao (2=visualiza,3=inclui,4=altera,5=exclui)
| aAc.........: Vetor com as opções do confirme da digitacao (obsoleto)
| cOpc........: Letras das teclas de atalho para as opções do confirme da digitação (obsoleto)
| cTextExclui.: Texto de solicitação de confirmação (obsoleto)
| aAcho.......: Vetor com campos visiveis
| aPos........: Vetor com as coordenadas para o enchoice no Dialog
| aCpos.......: Vetor com os campos alteráveis
| nNum........: é um número (obsoleto)
| nColMens....: Número da coluna para mensagem (obsoleto)
| cMensagem...: Mensagem (obsoleto)
| cTudOk......: Variável com o nome de uma função para validar se está tudo ok
| oObj........: Nome do Objeto
| lVirtual....: Quando falso carrega inicializador padrao nos campos virtuais
+------------------------------------------------------------------------------------------------------------------
*/

#Include "Protheus.Ch" 
#Define ENTER Chr(13)+Chr(10)

User Function Pai_Filho()
Private nUsado     := 0
Private cCadastro  := "Atualização de Orçamento"
Private cAlias1    := "ZA1"
Private cAlias2    := "ZA2"
Private cFilZA1    := ""
Private cFilZA2    := ""
Private aRotina    := {}
Private aPos       := {15, 1, 70, 315}
Private oCliente   := Nil
Private oTotal     := Nil
Private cCliente   := ""
Private nTotal     := 0

Private aSize    := {}
Private aObjects := {}
Private aInfo    := {}
Private aPosObj  := {}
Private aPosGet  := {}

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,080,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})
aAdd(aObjects,{100,015,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

aAdd( aRotina ,{"Pesquisar" ,"AxPesqui"    ,0,1})
aAdd( aRotina ,{"Visualizar",'u_Mod3Visual',0,2})
aAdd( aRotina ,{"Incluir"   ,'u_Mod3Inclui',0,3})
aAdd( aRotina ,{"Alterar"   ,'u_Mod3Altera',0,4})
aAdd( aRotina ,{"Excluir"   ,'u_Mod3Exclui',0,5})

U_xGeraBase()

If Empty(Posicione("SX3",1,cAlias1,"X3_ARQUIVO"))
   Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+ENTER+"X3, X2, IX E X7",1,0)
   RETURN
Endif

dbSelectArea(cAlias2)
dbSetOrder(1)
cFilZA2 := xFilial(cAlias2)

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilZA1 := xFilial(cAlias1)

mBrowse(,,,,cAlias1)

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3Visual()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Visualiza os dados                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3Visual( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oMainWnd  := Nil

Private oGet
Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }

cCliente := ""
nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(cFilZA2+ZA1->ZA1_NUM)

While !Eof() .And. cFilZA2 == ZA2->ZA2_FILIAL .And. ZA2->ZA2_NUM == ZA1->ZA1_NUM
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   nTotal += ZA2->ZA2_VALOR
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5]  OF oMainWnd PIXEL
EnChoice(cAlias, nRecNo, nOpc,,,,, aPosObj[1])

// Atualizacao do nome do cliente
@ aPosObj[3,1],aPosGet[1,1] SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,2] SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ aPosObj[3,1],aPosGet[1,3] SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

u_Mod3AtuCli()
oGet := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3Inclui()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Incluir os dados                                                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3Inclui( cAlias, nRecNo, nOpc )
Local nOpcA      := 0
Local nX         := 0
Local oDlg       := Nil

Private oGet
Private aTela    := {}
Private aGets    := {}
Private aHeader  := {}
Private aCols    := {}
Private bCampo   := {|nField| FieldName(nField) }

cCliente := ""
nTotal := 0

//+--------------------------------------
//| Cria Variaveis de Memoria da Enchoice
//+--------------------------------------
dbSelectArea(cAlias1)
For nX := 1 To FCount()
	M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
aAdd(aCols,Array(nUsado+1))
nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias2
	If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		nUsado++
		aCols[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
	Endif
	dbSkip()
End

aCols[1][nUsado+1] := .F.
aCols[1][aScan(aHeader,{|x| Trim(x[2])=="ZA2_ITEM"})] := "01"

//+----------------------------------
//| Envia para processamento dos Gets
//+----------------------------------
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
EnChoice( cAlias, nRecNo, nOpc, , , , , aPosObj[1])

// Atualizacao do nome do cliente
@ aPosObj[3,1],aPosGet[1,1] SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,2] SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ aPosObj[3,1],aPosGet[1,3] SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_Mod3LinOk()","u_Mod3TudOk()","+ZA2_ITEM",.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(u_Mod3Tudok().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1
	Begin Transaction
	If Mod3Grava(1)
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

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3Altera()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Altera os dados                                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3Altera( cAlias, nRecNo, nOpc )
Local nOpcA      := 0
Local nX         := 0
Local nCols      := 0
Local oDlg       := Nil

Private oGet
Private aTela    := {}
Private aGets    := {}
Private aHeader  := {}
Private aCols    := {}
Private aAltera  := {}
Private bCampo   := {|nField| FieldName(nField) }

cCliente := ""
nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX := 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(cFilZA2+ZA1->ZA1_NUM)

While !Eof() .And. cFilZA2 == ZA2->ZA2_FILIAL .And. ZA2->ZA2_NUM == ZA1->ZA1_NUM
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   nTotal += ZA2->ZA2_VALOR
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   aAdd(aAltera,RecNo())
   dbSkip()
End

//+----------------------------------
//| Envia para processamento dos Gets
//+----------------------------------
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
EnChoice( cAlias, nRecNo, nOpc, , , , , aPosObj[1])

// Atualizacao do nome do cliente
@ aPosObj[3,1],aPosGet[1,1] SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,2] SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ aPosObj[3,1],aPosGet[1,3] SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

u_Mod3AtuCli()
oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_Mod3LinOk()","u_Mod3TudOk()","+ZA2_ITEM",.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=1,If(u_Mod3Tudok().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1
	Begin Transaction
	If Mod3Grava(2,aAltera)
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

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3Exclui()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Exclui os dados                                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3Exclui( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oMainWnd  := Nil

Private oGet
Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }

cCliente := ""
nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(cFilZA2+ZA1->ZA1_NUM)

While !Eof() .And. cFilZA2 == ZA2->ZA2_FILIAL .And. ZA2->ZA2_NUM == ZA1->ZA1_NUM
   aAdd(aCols,Array(nUsado+1))
   nCols ++
   nTotal += ZA2->ZA2_VALOR
   
   For nX := 1 To nUsado
      If ( aHeader[nX][10] != "V")
         aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
      Else
         aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
      Endif
   Next nX
   
   aCols[nCols][nUsado+1] := .F.
   dbSelectArea(cAlias2)
   dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
EnChoice(cAlias, nRecNo, nOpc,,,,, aPosObj[1])

// Atualizacao do nome do cliente
@ aPosObj[3,1],aPosGet[1,1] SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,2] SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ aPosObj[3,1],aPosGet[1,3] SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ aPosObj[3,1],aPosGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

u_Mod3AtuCli()
oGet := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	If Mod3Grava(3)
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



/******************************************************************************
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
+-----------------------------------------------------------------------------+
| ******************* FUNCOES GENERICA DESTE PROGRAMA ************************|
+-----------------------------------------------------------------------------+
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
******************************************************************************/



///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaHeader()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria as variaveis vetor aHeader                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaHeader()
nUsado  := 0
aHeader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)
While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias2 )
   If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
      aAdd(aHeader,{ Trim(X3Titulo()), ;
                     SX3->X3_CAMPO   , ;
                     SX3->X3_PICTURE , ;
                     SX3->X3_TAMANHO , ;
                     SX3->X3_DECIMAL , ;
                     SX3->X3_VALID   , ;
                     SX3->X3_USADO   , ;
                     SX3->X3_TIPO    , ;
                     SX3->X3_ARQUIVO , ;
                     SX3->X3_CONTEXT } )
      nUsado++
   Endif
   dbSkip()
End
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3AtuCli()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Obetivo e atualizar a MsDialog com o nome do cliente            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3AtuCli()
cCliente := ""
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek( xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA )
   cCliente := Trim(SA1->A1_NREDUZ)
Endif
oCliente:Refresh()
Return(.T.)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3LinOK()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Validar a linha antes de mover para cima ou para baixo          |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3LinOk()
Local lRet      := .T.
Local i         := 0
Local nP_QtdVen := 0
Local nP_PrcVen := 0

// Atualiza o total do rodape 
nP_QtdVen := aScan(aHeader,{|x| Trim(x[2])=="ZA2_QTDVEN"})
nP_PrcVen := aScan(aHeader,{|x| Trim(x[2])=="ZA2_PRCVEN"})

nTotal := 0

For i := 1 To Len(aCols)
   If aCols[i][nUsado+1]
      Loop
   Endif
   nTotal += Round(aCols[i][nP_QtdVen]*aCols[i][nP_PrcVen],2)
Next i

oTotal:Refresh()

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ModTudOk()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Valiar se todas as linhas estao ok                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod3TudOk()
Local lRet       := .T.
Local nP_Produto := 0
Local nP_QtdVen  := 0
Local nP_PrcVen  := 0
Local cMsg       := ""
Local cProduto   := 0
Local nQtdVen    := 0
Local nPrcVen    := 0
Local i := 0

nP_Produto := aScan(aHeader,{|x| Trim(x[2])=="ZA2_PRODUT"})
nP_QtdVen  := aScan(aHeader,{|x| Trim(x[2])=="ZA2_QTDVEN"})
nP_PrcVen  := aScan(aHeader,{|x| Trim(x[2])=="ZA2_PRCVEN"})

For i := 1 To Len(aCols)

   If aCols[i][nUsado+1]
      Loop
   Endif
   
   cProduto := aCols[i][nP_Produto]
   nQtdVen  := aCols[i][nP_QtdVen]
   nPrcVen  := aCols[i][nP_PrcVen]
 
   If Empty(cProduto)
      cMsg := "Campo PRODUTO preenchimento obrigatorio"
      lRet := .F.
   Endif
      
   If nQtdVen == 0 .And. lRet
      cMsg := "Campo QUANTIDADE preenchimento obrigatorio"   
      lRet := .F.
   Endif
 
   If nPrcVen == 0 .And. lRet
      cMsg := "Campo PRECO UNITARIO preenchimento obrigatorio"   
      lRet := .F.
   Endif
   
   If !lRet
      Help("",1,"","Mod3TudOk",cMsg,1,0)
      Exit
   Endif
   
Next i

Return( lRet )       

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relaciona_Pai_Filho()| AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod3Grava()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Grava os dados nas variaveis M->??? e no vetor aGETS            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Mod3Grava(nOpc,aAltera)
Local lGravou  := .F.
Local nUsado   := 0
Local nSeq     := 1
Local nX       := 0
Local nI       := 0
Private bCampo := { |nField| FieldName(nField) }

nUsado := Len(aHeader) + 1

//+----------------
//| Se for inclusao
//+----------------
If nOpc == 1
   //+--------------------------
   //| Colocar os itens em ordem
   //+--------------------------
   aSort(aCols,,,{|x,y| x[1] < y[2] })
   
   //+---------------
   //| Grava os itens
   //+---------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)	
	For nX := 1 To Len(aCols)		
      If !aCols[nX][nUsado]
         RecLock(cAlias2,.T.)
         For nI := 1 To Len(aHeader)
            FieldPut(FieldPos(Trim(aHeader[nI,2])),aCols[nX,nI])
         Next nI
         ZA2->ZA2_FILIAL := cFilZA2
         ZA2->ZA2_NUM    := M->ZA1_NUM
         ZA2->ZA2_ITEM   := StrZero(nSeq,2)
         MsUnLock()
         nSeq ++
         lGravou := .T.
		Endif
	Next nX
	
   //+------------------
   //| Grava o Cabecalho
   //+------------------
   If lGravou
      dbSelectArea(cAlias1)
      RecLock(cAlias1,.T.)
      For nX := 1 To FCount()
         If "FILIAL" $ FieldName(nX)
            FieldPut(nX,cFilZA1)
         Else
            FieldPut(nX,M->&(Eval(bCampo,nX)))
         Endif
      Next nX
      MsUnLock()
   Endif
Endif

//+-----------------
//| Se for alteracao
//+-----------------
If nOpc == 2
   //+--------------------------------------
   //| Grava os itens conforme as alteracoes
   //+--------------------------------------
   dbSelectArea(cAlias2)
   dbSetOrder(1)
   For nX := 1 To Len(aCols)
      If nX <= Len(aAltera)
         dbGoto(aAltera[nX])
			RecLock(cAlias2,.F.)
         If aCols[nX][nUsado]
            dbDelete()
         EndIf
      Else
         If !aCols[nX][nUsado]
            RecLock(cAlias2,.T.)
         Endif
      Endif
      
      If !aCols[nX][nUsado]
         For nI := 1 To Len(aHeader)
            FieldPut(FieldPos(Trim(aHeader[nI,2])),aCols[nX,nI])
         Next nI
         ZA2->ZA2_FILIAL := cFilZA2
         ZA2->ZA2_NUM    := M->ZA1_NUM
         ZA2->ZA2_ITEM   := StrZero(nSeq,2)
         nSeq ++
         lGravou := .T.
      EndIf
      MsUnLock()
   Next nX

   //+----------------------------------------------------
   //| Aqui eu reordeno a sequencia gravada fora de ordem.
   //+----------------------------------------------------
   If lGravou
      nSeq := 1
      dbSelectArea(cAlias2)
      dbSetOrder(1)
      dbSeek(cFilZA2+M->ZA1_NUM,.F.)
      While !Eof() .And. cFilZA2 == ZA1->ZA1_FILIAL .And. ZA2->ZA2_NUM == M->ZA1_NUM
         RecLock(cAlias2,.F.)
         ZA2->ZA2_ITEM := StrZero(nSeq,2)
         MsUnLock()
         nSeq++
         lGravou := .T.
         dbSkip()
      End
	EndIf
	
   //+------------------
   //| Grava o Cabecalho
   //+------------------
   If lGravou
      dbSelectArea(cAlias1)
      RecLock(cAlias1,.F.)
      For nX := 1 To FCount()
         If "FILIAL" $ FieldName(nX)
            FieldPut(nX,cFilZA1)
         Else
            FieldPut(nX,M->&(Eval(bCampo,nX)))
         Endif
      Next
      MsUnLock()
   Else
      dbSelectArea(cAlias1)
      RecLock(cAlias1,.F.)
      dbDelete()
      MsUnLock()
   Endif
Endif

//+----------------
//| Se for exclucao
//+----------------
If nOpc == 3
   //+----------------
   //| Deleta os Itens
   //+----------------
   dbSelectArea(cAlias2)
   dbSetOrder(1)
   dbSeek(cFilZA2+M->ZA1_NUM,.T.)
   While !Eof() .And. cFilZA2 == ZA1->ZA1_FILIAL .And. ZA2->ZA2_NUM == M->ZA1_NUM
      RecLock(cAlias2)
      dbDelete()
      MsUnLock()
      dbSkip()
   End
   
   //+-------------------
   //| Deleta o Cabecalho
   //+-------------------
   dbSelectArea(cAlias1)
   RecLock(cAlias1)
   dbDelete()
   MsUnLock()
   lGravou := .T.
EndIf

Return( lGravou )

//+-------------------------------------------------------------------+
//| Rotina | xGeraBase | Autor | Robson Luiz (rleg) | Data | 26.11.06 |
//+-------------------------------------------------------------------+
//| Descr. | Rotina para criar a estrutura no dicionário.             |
//+-------------------------------------------------------------------+
//| Uso    | Oficina de Programação                                   |
//+-------------------------------------------------------------------+
User Function xGeraBase()
	Local cStartPath := GetSrvProfString("StartPath","")
	Local cComp := "_OFIC.DBF"
	Local aSX  := {"SIX","SX2","SX3","SX7"}
	Local nJ := 0
	Local nI := 0
	Local cTrbAlias := ""
	Local cArquivo := ""
	Local nQtdCpo := 0
	Local cNomCpoTrb := ""
	Local nPosCpoArq := 0
	For nJ := 1 To Len( aSX )
		dbSelectArea(aSX[nJ])
		dbSetOrder(1)
		If ! File( cStartPath + aSX[nJ] + cComp )
			cArquivo := aSX[nJ]+cComp
			If __CopyFile((cMainPath+cArquivo), (cStartPath+cArquivo))
				cTrbAlias := GetNextAlias()
				dbUseArea(.T.,"DBFCDX",cArquivo,cTrbAlias,.F.,.T.)
				dbSelectArea(cTrbAlias)
				dbGoTop()
				nQtdCpo := FCount()
				While ! (cTrbAlias)->(EOF())
					dbSelectArea(aSX[nJ])
					RecLock(aSX[nJ],.T.)
					For nI := 1 To nQtdCpo
						cNomCpoTrb := (cTrbAlias)->(FieldName(nI))
						nPosCpoArq := (aSX[nJ])->(FieldPos(cNomCpoTrb))
						(aSX[nJ])->(FieldPut(nPosCpoArq,(cTrbAlias)->(FieldGet(nI))))
					Next nI
					MsUnLock()
					(cTrbAlias)->(dbSkip())
				End
				dbSelectArea(cTrbAlias)
				dbCloseArea()
			Endif
		Endif
	Next nJ
Return

//+-------------------------------------------------------------------+
//| Rotina | xMudaLin  | Autor | Robson Luiz (rleg) | Data | 19.02.07 |
//+-------------------------------------------------------------------+
//| Descr. | Rotina para mudar de linha na getdados quando informar o |
//|        | dado no último campo.                                    |
//+-------------------------------------------------------------------+
//| Uso    | Oficina de Programação                                   |
//+-------------------------------------------------------------------+
User Function xMudaLin( xCpo, xHeader, xCOLS, xObjGet, xCOLUNA )
	
	Local cAlias := Alias()
	Local nReg   := RecNo()
	Local cVariavel := "M->"+xCpo
	Local cConteudo := &cVariavel
	Local nPosCpo := aScan( xHeader,{|x| Upper( AllTrim( x[2] ) ) == xCpo } )
	
	DEFAULT xCOLUNA := 1

	If !Empty(cConteudo)
		xObjGet:oBrowse:bEditCol := ;
		{ || Iif( !Empty( xCOLS[ n, aScan( xHeader, {|x| Upper( AllTrim( x[2] ) ) == xCpo } ) ] ) .And. ;
		xObjGet:LinhaOk(),( xObjGet:oBrowse:GoDown(), xObjGet:oBrowse:nColPos := xCOLUNA ) ,NIL ) }
		n := Len( xCOLS )
		xObjGet:oBrowse:Refresh()
	Endif	

	dbSelectarea(cAlias)
	dbGoTo(nReg)

Return(.T.)

//+---------------------------------------------------
//| MsAdvSize(ExpL1,ExpL2,ExpN1)
//+---------------------------------------------------
//| Parametros
//| ----------
//| ExpL1 -> Enchoicebar .T. ou .F.
//| ExpL2 -> Retorna janela padrao siga .T. ou .F.
//| ExpN1 -> Tamanho minimo ( altura )
//| 
//| Retorno
//| -------
//| ExpA1 -> Dimensoes da janela e area de trabalho
//|          1 -> Linha inicial area trabalho
//|          2 -> Coluna inicial area trabalho
//|          3 -> Linha final area trabalho
//|          4 -> Coluna final area trabalho
//|          5 -> Coluna final dialog
//|          6 -> Linha final dialog
//|          7 -> Linha inicial dialog
//+---------------------------------------------------

//+------------------------------------------------------------------------------------------
//| MsObjSize(ExpA1,ExpA2,lExp1,lExp2)
//+------------------------------------------------------------------------------------------
//| Parametros
//| ----------
//| ExpA2 -> Area de trabalho
//| ExpA3 -> Definicoes de objetos 1-Tamanho X
//|                                2-Tamanho Y
//|                                3-Dimensiona X
//|                                4-Dimensiona Y
//|                                5-Retorna dimensoes X e Y ao inves de linha / coluna final
//| ExpL2 -> Indica calculo de objetos horizontais
//| ExpL1 -> Mantem a proporcao dos objetos
//| 
//| Retorno   
//| -------
//| ExpA1 -> Array com as posicoes de cada objeto
//|          1 -> Linha inicial
//|          2 -> Coluna inicial
//|          3 -> Linha final
//|          4 -> Coluna final Ou caso seja passado o elemento 5 de cada 
//|               definicao de objetos como .T. o retorno sera: 3 -> Tamanho da dimensao X
//|                                                             4 -> Tamanho da dimensao Y
//+------------------------------------------------------------------------------------------

//+------------------------------------------------------------------------
//| MsObjGetPos(ExpN1,ExpN2,ExpA1)
//+------------------------------------------------------------------------
//| Parametros
//| ----------
//| nSizeAtu -> Linha final area trabalho menos Linha inicial area trabalho
//| nSizeDef -> Tamanho do espaço definido para distribuição
//| aPosDef --> Colunas que serão apresentadas em tela o SAY e GET
//|
//| Retorno
//| -------
//| Vetor com as colunas que serão apresentado o SAY e o GET
//+------------------------------------------------------------------------