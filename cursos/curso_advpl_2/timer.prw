///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Timer.prw            | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Timer()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Programa que demonstra a funcionalidade do Timer                |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.ch"

User Function Timer()

Local oDlg     := Nil
Local cTitulo  := "Consulta Saldos Bancários - Aguarde será atualizado"
Local oOk      := LoadBitmap( GetResources(), "BR_VERDE" )
Local oNo      := LoadBitmap( GetResources(), "BR_VERMELHO" )
Local i        := 0
Local cLine    := ""
Private oLbx   := Nil
Private aVetor := {}
Private oTimer := Nil

LoadBank(1)

cLine := "{IIf(aVetor[oLbx:nAt,1],oOk,oNo)"
For i:=2 To Len(aVetor[1])
   cLine += ",aVetor[oLbx:nAt]["+AllTrim(Str(i))+"]"
Next
cLine += "}"
bLine := &("{|| "+cLine+"}")

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

   @ 10,10 LISTBOX oLbx FIELDS HEADER " ", "Banco", "Agencia", "C/C", "Saldo Atual" SIZE 230,095 OF oDlg PIXEL
   DEFINE TIMER oTimer INTERVAL 5000 ACTION MsgRun("Aguarde, atualizando...",,{|| LoadBank(2)}) OF oDlg
   oTimer:Activate()
   LoadBank(2)
	                    
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
Return

/******
 *
 * Função para atualizar o vetor e o Listbox
 *
 */
Static Function LoadBank(nTp)
aVetor := {}

If nTp==2
   oTimer:Deactivate()
Endif

dbSelectArea("SA6") 
dbSetOrder(1)
dbSeek(xFilial("SA6"))

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
dbEval({|x| aAdd(aVetor,{(A6_SALATU>1000),SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,SA6->A6_SALATU})},;
       {|y| SA6->A6_FILIAL == xFilial("SA6")})
       
If nTp==2
   oLbx:SetArray(aVetor)
   oLbx:bLine := bLine
   oLbx:Refresh()
   oTimer:Activate()
Endif

Return