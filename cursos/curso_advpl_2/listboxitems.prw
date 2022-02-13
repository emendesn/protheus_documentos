///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxItems.prw     | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxIte()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox com metodo items   |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#INCLUDE "PROTHEUS.CH"
User Function ListBoxIte()

Local oDlg
Local oLbx
Local aVetor   := {}
Local cTitulo  := "Consulta Tabela"
Local nChave   := 0
Local cChave   := ""

dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5"))

// Cursor no formato de ampulheta
CursorWait()

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While !Eof() .And. X5_FILIAL == xFilial("SX5") .And. X5_TABELA=="00"
   aAdd( aVetor, Trim(X5_CHAVE)+" - "+Capital(Trim(X5_DESCRI)) )
	dbSkip()
End

// Cursor no formato de seta
CursorArrow()

If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe dados a consultar", {"Ok"} )
   Return
Endif

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

@ 10,10 LISTBOX oLbx VAR nChave ITEMS aVetor SIZE 230,95 OF oDlg PIXEL
oLbx:bChange := {|| cChave := SubStr(aVetor[nChave],1,2) }

DEFINE SBUTTON FROM 107,183 TYPE 14 ACTION LoadTable(cChave) ENABLE OF oDlg
DEFINE SBUTTON FROM 107,213 TYPE  1 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxItems.prw     | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - LoadTable()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que carrega os dados da tabela selecionada em um listbox |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION LoadTable(cTabela)
LOCAL aTabela := {}
LOCAL oDlg
LOCAL oLbx

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+cTabela)

//+----------------------------------------------------------
//| O vetor pode receber carga de duas maneiras, acompanhe...
//+----------------------------------------------------------
//| Utilizando While/End
//+----------------------------------------------------------
//While !Eof() .And. X5_TABELA==cTabela
//   aAdd(aTabela,{X5_CHAVE,Capital(X5_DESCRI)})
//   dbSkip()
//End
//+-------------------
//| Utilizando dbEval()
//+--------------------
dbEval({|| aAdd(aTabela,{X5_CHAVE,Capital(X5_DESCRI)})},,{|| X5_TABELA==cTabela})

If Len(aTabela)==0
   Aviso( "FIM", "Necessário selecionar um item", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE "Dados da tabela selecionada" FROM 300,400 TO 540,900 PIXEL
@ 10,10 LISTBOX oLbx FIELDS HEADER "Tabela", "Descrição" SIZE 230,095 OF oDlg PIXEL	
oLbx:SetArray( aTabela )
oLbx:bLine := {|| {aTabela[oLbx:nAt,1],aTabela[oLbx:nAt,2]} }
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg
RETURN