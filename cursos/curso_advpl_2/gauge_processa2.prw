///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Gauge_Processa2.prw  | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_GProces2()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao de como utilizar o processa2()                     |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function GProces2()
Private oProcess

oProcess := MsNewProcess():New({|lEnd| RunProc(lEnd)},"Processando","Lendo...",.T.)
oProcess:Activate()

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Gauge_Processa2.prw  | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RunProc()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de processamento                                         |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RunProc(lEnd)
Local aTabela := {}
Local nCnt := 0
Local i := 0
                   
aTabela := {{"00",0},{"12",0},{"13",0},{"35",0},{"T3",0}}

dbSelectArea("SX5")
dbSetOrder(1)
For i:=1 To Len(aTabela)
   dbSeek(xFilial("SX5")+aTabela[i,1])
   While !Eof() .And. X5_FILIAL+X5_TABELA == xFilial("SX5")+aTabela[i,1]
      If lEnd
         Exit
      Endif
      nCnt++
      dbSkip()
   End
   aTabela[i,2] := nCnt
   nCnt := 0
Next i 

oProcess:SetRegua1(Len(aTabela))
For i:=1 To Len(aTabela)
   If lEnd
      Exit
   Endif
   oProcess:IncRegua1("Lendo Tabela: "+aTabela[i,1])
   dbSelectArea("SX5")
   dbSeek(xFilial("SX5")+aTabela[i,1])
   oProcess:SetRegua2(aTabela[i,2])
   While !Eof() .And. X5_FILIAL+X5_TABELA == xFilial("SX5")+aTabela[i,1]
      oProcess:IncRegua2("Lendo chave: "+X5_CHAVE)
      If lEnd
         Exit
      Endif
      dbSkip()
   End
Next i
Return