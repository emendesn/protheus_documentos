///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBox_ClickDir.prw | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxD()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox e o clique com     |//
//|           | 0 botão direito.                                                |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.ch"

User Function LBoxDir()

Local aListBox := {}
Local cResultado := ""
Local oDlg
Local oListBox
Local cCadastro := "Simulação de menu em ListBox"

// Cursor no formato de ampulheta
CursorWait()

dbSelectArea("SX5")
dbSetOrder(1)
dbGoTop()
dbEval({|x| aAdd(aListBox,X5_TABELA+" - "+X5_CHAVE+" - "+X5_DESCRI)},,{|y| X5_TABELA == "00"})

// Cursor no formato de seta
CursorArrow() 

MENU oMenu POPUP 
   MENUITEM "Visualizar" ACTION MsgInfo("Foi clicado no item: "+AllTrim(Str(oListbox:nAt)),cCadastro)
   MENUITEM "Alterar"    ACTION MsgInfo("Foi clicado no item: "+AllTrim(Str(oListbox:nAt)),cCadastro)
ENDMENU

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 240,500 PIXEL
   @ 10,10 LISTBOX oListBox VAR cResultado ITEMS aListBox PIXEL SIZE 230,95 OF oDlg MULTI
   oListBox:bRClicked := { |o,nX,nY| oMenu:Activate(nX-410,nY-318,oListBox ) } // Posição x,y em relação a Dialog 
   oListBox:SetArray( aListBox ) 
   oListBox:Refresh() 

   @ 110,10 SAY "Click o botão direito" SIZE 60,007 PIXEL OF oDlg

   DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
Return