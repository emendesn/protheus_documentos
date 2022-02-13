///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxChange.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ListBoxCha()                                         |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que demonstra a utilizacao de listbox com metodo change  |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#include "Protheus.Ch"

User Function ListBoxCha()

Local oDlg
Local oLbx1
Local cCond     := ""

Private oAberto   := LoadBitmap(GetResources(),"BR_VERDE")
Private oEncerr   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oLibera   := LoadBitmap(GetResources(),"BR_AMARELO")
Private cTitulo   := "Pedido de Vendas"
Private aVetSC5   := {}
Private aVetSC6   := {}

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5"))
While !Eof() .And. C5_FILIAL == xFilial("SC5")	   
   If Empty(C5_LIBEROK) .And. Empty(C5_NOTA)
      cCond := "A"
   Elseif !Empty(C5_NOTA) .Or. C5_LIBEROK == "E"
      cCond := "E"
   Elseif !Empty(C5_LIBEROK) .And. Empty(C5_NOTA)
      cCond := "L"
   Endif
   aAdd(aVetSC5,{cCond,C5_NUM,C5_CLIENTE,C5_LOJACLI})
	dbSkip()
End

//+------------------------------------+
//| Se o estiver vazio, nao mostra-los |
//+------------------------------------+
If Len(aVetSC5)==0
   Aviso(cTitulo,"Nao existe dados a consultar", {"Ok"} )
   Return
Endif

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+aVetSC5[1,2])
While !Eof() .And. C6_FILIAL+C6_NUM == xFilial("SC6")+aVetSC5[1,2]
   If C6_QTDENT==0
      cCond := "A"
   Elseif (C6_QTDVEN-C6_QTDENT)<>0
      cCond := "P"
   Elseif C6_QTDVEN == C6_QTDENT
      cCond := "T"
   Endif
   aAdd(aVetSC6,{cCond,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_VALOR})
   dbSkip()
End

//+------------------------------------+
//| Se o estiver vazio, nao mostra-los |
//+------------------------------------+
If Len(aVetSC6)==0
   Aviso(cTitulo,"Nao existe dados no SC6 a consultar", {"Ok"} )
   Return
Endif

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 300,600 PIXEL

@ 14,3 TO  76,298 LABEL " Cabecalho do Pedido de Venda " OF oDlg PIXEL
@ 79,3 TO 149,298 LABEL " Item(ns) do Pedido de Venda "  OF oDlg PIXEL

@ 19,5 LISTBOX oLbx1 FIELDS HEADER "","Numero","Cliente","Loja" ;
       SIZE 290,55 OF oDlg PIXEL ON CHANGE MudaLin(oLbx1:nAt)
       
oLbx1:SetArray(aVetSC5)
oLbx1:bLine:={|| {Iif(aVetSC5[oLbx1:nAt,1]=="A",oAberto,Iif(aVetSC5[oLbx1:nAt,1]=="E",oEncerr,oLibera)),;
                      aVetSC5[oLbx1:nAt,2],aVetSC5[oLbx1:nAt,3],aVetSC5[oLbx1:nAt,4]}}

@ 84,5 LISTBOX oLbx2 FIELDS HEADER "","Produto","Quantidade","Unitario","Total" SIZE 290,62 OF oDlg PIXEL
oLbx2:SetArray(aVetSC6)
oLbx2:bLine:={|| {Iif(aVetSC6[oLbx2:nAt,1]=="A",oAberto,Iif(aVetSC6[oLbx2:nAt,1]=="P",oEncerr,oLibera)),;
                  aVetSC6[oLbx2:nAt,2],aVetSC6[oLbx2:nAt,3],aVetSC6[oLbx2:nAt,4],aVetSC6[oLbx2:nAt,5]}}

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ListBoxItems.prw     | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - MudaLin()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que atualiza o segundo listbox relacionado ao primeiro   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function MudaLin(nPos)

aVetSC6 := {}

dbSelectArea("SC6")
dbSetOrder(1)
//     FILIAL         NUM.PEDIDO
dbSeek(xFilial("SC6")+aVetSC5[nPos,2])

While !Eof() .And. C6_FILIAL+C6_NUM == xFilial("SC6")+aVetSC5[nPos,2]
   If C6_QTDENT==0
      cCond := "A"
   Elseif (C6_QTDVEN-C6_QTDENT)<>0
      cCond := "P"
   Elseif C6_QTDVEN == C6_QTDENT
      cCond := "T"
   Endif
   aAdd(aVetSC6,{cCond,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_VALOR})
   dbSkip()
End
oLbx2:SetArray(aVetSC6)
oLbx2:bLine:={|| {Iif(aVetSC6[oLbx2:nAt,1]=="A",oAberto,Iif(aVetSC6[oLbx2:nAt,1]=="P",oEncerr,oLibera)),;
                  aVetSC6[oLbx2:nAt,2],aVetSC6[oLbx2:nAt,3],aVetSC6[oLbx2:nAt,4],aVetSC6[oLbx2:nAt,5]}}
oLbx2:Refresh()
Return