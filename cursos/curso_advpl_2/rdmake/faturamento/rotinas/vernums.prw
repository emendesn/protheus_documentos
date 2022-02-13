#include "rwmake.ch"

USER FUNCTION VERNUMS()

u_GerA0003(ProcName())

IF MsgBox("Esta rotina ira ajustar Pedidos de Vendas.Deseja Continuar?","Ajusta","YESNO")
        Processa({||NumS()},"Selecionando Registros",OemToAnsi("Aguarde..."),.F.)
	MSGBOX("Execucao da Rotina foi realizada com Sucesso","Execucao da Rotina")
EndIf

Return()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function NumS()

USE PROV NEW ALIAS PRV

DbSelectArea("SC6")
DbGotop()
ProcRegua(LastRec())

Do While SC6->(!eof())

   IncProc()

   If Empty(SC6->C6_NFORI)
       DbSelectArea("SC6")
       DbSkip()
       Loop
   EndIf

   DbSelectArea("SD1")
   DbSetOrder(1)
   DbSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_ITEMORI)

   If Found()
       If SD1->D1_NUMSER <> SC6->C6_NUMSERI
           DbSelectArea("PRV")
           RECLOCK("PRV",.T.)
           PRV->TIPO    := "1"
           PRV->NFORI   := SC6->C6_NFORI
           PRV->SERIORI := SC6->C6_SERIORI
           PRV->CLI     := SC6->C6_CLI
           PRV->LOJA    := SC6->C6_LOJA
           PRV->PRODUTO := SC6->C6_PRODUTO
           PRV->ITEMORI := SC6->C6_ITEMORI
           PRV->SERC6   := SC6->C6_NUMSERI
           PRV->SERD1   := SD1->D1_NUMSER
           PRV->PEDIDO  := SC6->C6_NUM
           MsunLock()
       EndIf
   EndIf

   DbSelectArea("SC6")
   DbSkip()

EndDo

Return()
