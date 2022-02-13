#include "Protheus.ch"

/******
 *
 * Função principal
 *
 */
 
User Function xMsExplorer()

Local cTitulo := "Exemplo da classe MsExplorer"
Local bValid

Private oExp
Private aFuncPanels := {} 
Private oPanels := {}
Private aRecNo := {}
Private nRecNo := 1

If oExp <> NIL
   xCadastro()
   xLista()
   xPainel()
Endif

oExp := MsExplorer():New(cTitulo)
oExp:DefaultBar()

oExp:oTree:bValid:= { |cPromAtu,cCargAtu,cPromFut,cCargFut| ;
                      &(aFuncPanels[Val(cCargFut)]),oPanels[Val(cCargFut)]:Show(),oPanels[Val(cCargAtu)]:FreeChildren(),.T.}

oExp:AddDefButton("FINAL","Saida",{|| oExp:DeActivate() })

Processa({|| xProcess(oExp,oPanels)},cTitulo,"Atualizando informações do sistema...")

&(aFuncPanels[1])

oExp:Activate(.T.,bValid)

Return

/******
 *
 * Função para montar a tree
 *
 */
Static Function xProcess(oExp)

ProcRegua(0)

oExp:AddTree("Cadastros"+Space(15),"PMSEDT3",,"0000001")
aAdd(oPanels,oExp:GetPanel(1))
aAdd(aFuncPanels,"xPainel(oExp,"+Str(Len(oPanels))+")")
IncProc()

   oExp:AddItem("Cliente"+Space(15),"PMSEDT2","0000002")
   aAdd(oPanels,oExp:GetPanel(2))
   aAdd(aFuncPanels,"xCadastro(oExp,"+Str(Len(oPanels))+")")
   IncProc()

   oExp:AddItem("Fornecedor"+Space(15),"PMSEDT2","0000003")
   aAdd(oPanels,oExp:GetPanel(3))
   aAdd(aFuncPanels,"xCadastro(oExp,"+Str(Len(oPanels))+")")
   IncProc()

   oExp:AddItem("Banco"+Space(15),"PMSEDT2","0000004")
   aAdd(oPanels,oExp:GetPanel(4))
   aAdd(aFuncPanels,"xCadastro(oExp,"+Str(Len(oPanels))+")")
   IncProc()
oExp:EndTree()

oExp:AddTree("Listas"+Space(15),"PMSEDT3",,"0000005")
aAdd(oPanels,oExp:GetPanel(5))
aAdd(aFuncPanels,"xPainel(oExp,"+Str(Len(oPanels))+")")
IncProc()

   oExp:AddItem("Cliente"+Space(15),"PMSEDT2","0000006")
   aAdd(oPanels,oExp:GetPanel(6))
   aAdd(aFuncPanels,"xLista(oExp,"+Str(Len(oPanels))+")")
   IncProc()

   oExp:AddItem("Fornecedor"+Space(15),"PMSEDT2","0000007")
   aAdd(oPanels,oExp:GetPanel(7))
   aAdd(aFuncPanels,"xLista(oExp,"+Str(Len(oPanels))+")")
   IncProc()

   oExp:AddItem("Banco"+Space(15),"PMSEDT2","0000008")
   aAdd(oPanels,oExp:GetPanel(8))
   aAdd(aFuncPanels,"xLista(oExp,"+Str(Len(oPanels))+")")
   IncProc()
oExp:EndTree()

Return

/******
 *
 * Função que conduz o usuário clicar na subcategoria da tree
 *
 */
Static Function xPainel(oExp,nPanel)
Local cTitulo := "Selecione uma subcategoria para "+IIF(nPanel==1,"cadastros","listas")
Local nTop := 0
Local nLeft := 0
Local nBottom := Int((oExp:aPanel[nPanel]:nHeight * 0.995)/2)
Local nRight := Int((oExp:aPanel[nPanel]:nWidth * 0.995)/2)
Local oBmp
Local oFnt := TFont():New("Arial",0,-12,,.T.,,,,,.T.)

@  0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oExp:GetPanel(nPanel) SIZE nRight/6, nBottom+10 NOBORDER WHEN .F. PIXEL ADJUST
TSay():New(nTop,(nRight*.1),{|| cTitulo },oExp:GetPanel(nPanel),,oFnt,,,,.T.,CLR_HBLUE,CLR_WHITE)

Return

/******
 *
 * Função que apresenta cadastro
 *
 */
Static Function xCadastro(oExp,nPanel)
Local nTop := 2
Local nLeft := 2
Local nBottom := Int((oExp:aPanel[nPanel]:nHeight * .995) / 2)
Local nRight := Int((oExp:aPanel[nPanel]:nWidth * .995) / 2)
Local aCoord := {{nTop,nLeft,nBottom,nRight}}
Local cAlias := IIF(nPanel==2,"SA1",IIF(nPanel==3,"SA2","SA6"))

INCLUI := .F.
ALTERA := .F.

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTo(nRecNo)
RegToMemory(cAlias,.F.)

MsMGet():New(cAlias,RecNo(),2,,,,,aCoord[1],,3,,,,oExp:GetPanel(nPanel))

Return

/******
 *
 * Função que apresenta lista do cadastro
 *
 */
Static Function xLista(oExp,nPanel)
Local nTop := 0
Local nLeft := 0
Local nBottom := Int((oExp:aPanel[nPanel]:nHeight * 0.995)/2)
Local nRight := Int((oExp:aPanel[nPanel]:nWidth * 0.995)/2)
Local cAlias := IIF(nPanel==6,"SA1",IIF(nPanel==7,"SA2","SA6"))
Local aHeader := {}
Local aCOLS := {}
Local nCOLS := 0
Local aCPO := {}
Local i := 0
Local oDlg
Local oLbx

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias
   If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
      aAdd(aHeader,RTrim(SX3->X3_TITULO))
      aAdd(aCPO,RTrim(SX3->X3_CAMPO))
   Endif
   dbSkip()
End

aRecNo := {}

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTop()
While !Eof()
   nCOLS++
   aAdd(aCOLS,Array(Len(aCPO)))
   aAdd(aRecNo,RecNo())
   For i:=1 To Len(aCPO)
      aCOLS[nCOLS,i] := FieldGet(FieldPos(aCPO[i]))
   Next i
   dbSkip()
End

If Empty(aCOLS)
   MsgInfo("Não existe dados a ser mostrado")
   Return
Endif

oLbx := TwBrowse():New(nTop,nLeft,nRight,nBottom,,aHeader,,oExp:GetPanel(nPanel),,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLbx:SetArray(aCOLS)
oLbx:bLine := {|| aEval( aCOLS[oLbx:nAt],{|z,w| aCOLS[oLbx:nAt,w]})}
oLbx:bChange := {|| nRecNo := aRecNo[oLbx:nAt] }
oLbx:Default()

Return