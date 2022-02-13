///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - mBrowsAx()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao da utilizacao das funcoes Ax e mBrowse             |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+------------------------------------------------------------------------------
| Par�metros dos Ax...()
+------------------------------------------------------------------------------
| AxVisual(cAlias,nReg,nOpc,aAcho,nColMens,cMensagem,cFunc,aButtons)
| AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons)
| AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons)
| AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons)
+------------------------------------------------------------------------------
| Func      - Fun��o chamado antes de montar a tela - nenhum retorno esperado
| cTudoOk   - Ao clicar no Ok, esperado .T. ou .F.
| cTransact - Fun��o chamado depois da grava��o dos dados - nenhum retorno esperado
| aAcho     - Campos visiveis
| aCpos     - Campos alteraveis
| aButtons  - {{"BMP",{||UserFunc()},"LegendaMouse"}}
| nColMens  - Parametro invalido
| cMensagem - Parametro invalido
| lF3       - Parametro invalido
+------------------------------------------------------------------------------

+------------------------------------------------------------------------------
| Par�metros do mBrowse()
+------------------------------------------------------------------------------
| mBrowse( uPar1, uPar2, uPar3, uPar4, cAlias, aFixos, cCpo, uPar5, cFunc, ;
|          nPadrao, aCores, cExpIni, cExpFim, nCongela )
+------------------------------------------------------------------------------
| uPar1....: N�o obrigat�rio, par�metros reservado
| uPar2....: N�o obrigat�rio, par�metros reservado
| uPar3....: N�o obrigat�rio, par�metros reservado
| uPar4....: N�o obrigat�rio, par�metros reservado
| cAlias...: Alias do arquivo a ser visualizado no browse
| aFixos...: Contendo os nomes dos campos fixos pr�-definidos pelo programador,
|            obrigando a exibi��o de uma ou mais colunas
|            Ex.: aFixos := {{ "??_COD",  Space(6) },;
|                            { "??_LOJA", Space(2) },;
|                            { "??_NOME", Space(30) }}
| cCpo.....: Campo a ser validado se est� vazio ou n�o para exibi��o do bitmap de status
| uPar5....: N�o obrigat�rio, par�metros reservado
| cFunc....: Fun��o que retornar� um valor l�gico para exibi��o do bitmap de status
| nPadrao..: N�mero da rotina a ser executada quando for efetuado um duplo clique 
|            em um registros do browse. Caso n�o seja informado o padr�o ser� executada 
|            visualiza��o ou pesquisa
| aCores...: Este vetor possui duas dimens�es, a primeira � a fun��o de valida��o 
|            para exibi��o do bitmap de status, e a segunda o bitmap a ser exibido
|            Ex.: aCores := {{ "??_STATUS == ' ', "BR_VERMELHO" },;
|                            { "??_STATUS == 'S', "BR_VERDE"    },;
|                            { "??_STATUS == 'N', "BR_AMARELO"  }}
| cExpIni..: Fun��o que retorna o conte�do inicial do filtro baseada na chave de �ndice selecionada
| cExpFim..: Fun��o que retorna o conte�do final do filtro baseada na chave de �ndice selecionada
| nCongela.: Coluna a ser congelado no browse
+------------------------------------------------------------------------------
*/

#include "protheus.ch"

User Function mBrowsAx()

Private cAlias := "SA6"
Private aRotina   := {}
Private aSubRotina := {}
Private lRefresh  := .T.
Private cCadastro := "Exemplo de Ax's"
Private aButtons := {}
Private oMenu

aAdd(aButtons,{"PESQUISA"  ,{||MsgInfo("Voc� clicou no 1� bot�o","Oi")},"1� Bot�o"})
aAdd(aButtons,{"PARAMETROS",{||MsgInfo("Voc� clicou no 2� bot�o","Oi")},"2� Bot�o"})
aAdd(aButtons,{"BUDGET"    ,{||MsgInfo("Voc� clicou no 3� bot�o","Oi")},"3� Bot�o"})
aAdd(aButtons,{"BUDGETY"   ,{|oObj,nX,nY|AtivaMenu(@nX,@nY,@oObj)},"4� Bot�o..."})

MENU oMenu POPUP
   MENUITEM "Primeira op��o" ACTION MsgInfo("Voc� escolheu a primeira op��o do menu")
   MENUITEM "Segunda op��o"  ACTION MsgInfo("Voc� escolheu a segunda op��o do menu")
   MENUITEM "Terceira op��o" ACTION MsgInfo("Voc� escolheu a terceira op��o do menu")
   MENUITEM "Quarta op��o"   ACTION MsgInfo("Voc� escolheu a quarta op��o do menu")
   MENUITEM "Quinta op��o"   ACTION MsgInfo("Voc� escolheu a quinta op��o do menu")
   MENUITEM "Sexta op��o"    ACTION MsgInfo("Voc� escolheu a sexta op��o do menu")
   MENUITEM "S�tima op��o"   ACTION MsgInfo("Voc� escolheu a s�tima op��o do menu")
   MENUITEM "Oitava op��o"   ACTION MsgInfo("Voc� escolheu a oitava op��o do menu")
   MENUITEM "Nona op��o"     ACTION MsgInfo("Voc� escolheu a nona op��o do menu")
   MENUITEM "D�cima op��o"   ACTION MsgInfo("Voc� escolheu a d�cima op��o do menu")
ENDMENU

aAdd( aSubRotina, {"Op��o 1",'Alert("Op��o 1")',0,4})
aAdd( aSubRotina, {"Op��o 2",'Alert("Op��o 2")',0,4})
aAdd( aSubRotina, {"Op��o 3",'Alert("Op��o 3")',0,4})

aAdd( aRotina, {"Pesquisar" ,"AxPesqui",0,1} )
aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
aAdd( aRotina, {"Incluir"   ,'AxInclui(cAlias,RecNo(),3,,,,,,,aButtons)',0,3} )
aAdd( aRotina, {"Alterar"   ,'AxAltera(cAlias,RecNo(),4)',0,4} )
aAdd( aRotina, {"Submenu"   ,aSubRotina,0,4} )
aAdd( aRotina, {"Excluir"   ,"u_mBrowDel",0,5} )
//aAdd( aRotina, {"Excluir"   ,"AxDeleta",0,5} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - mBrowDel()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Exclui o registro em questao                                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function mBrowDel(cAlias,nReg,nOpc)
Local nOpcA := 0
Local lDelSE5 := .F.
Local lDelSEF := .F.

nOpcA := AxVisual(cAlias,nReg,2)

If nOpcA == 1
   dbSelectArea("SE5")
   dbSetOrder(3)
   lDelSE5 := dbSeek(xFilial("SE5")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON)

   dbSelectArea("SEF")
   dbSetOrder(1)
   lDelSEF := dbSeek(xFilial("SEF")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON)
   
   If ! lDelSE5 .And. ! lDelSEF
      Begin Transaction
      	DbSelectArea(cAlias)
      	RecLock(cAlias,.F.)
      		dbDelete()
      	MsUnLock()
      End Transaction
   Else
      Help("",1,"","mBrowDel","N�o � poss�vel a exclus�o, este banco j� foi movimentado",1,0)
   Endif
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - AtivaMenu()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Ativa o menu no bot�o                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AtivaMenu(nX,nY,oObj)
Local oWnd
oWnd := GetWndDefault()
oMenu:Activate(246,15,oWnd)
Return