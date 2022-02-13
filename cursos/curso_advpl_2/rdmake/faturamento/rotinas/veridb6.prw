#include "rwmake.ch"

USER FUNCTION VERIDB6()

u_GerA0003(ProcName())

IF MsgBox("Esta rotina ira ajustar Pedidos de Vendas.Deseja Continuar?","Ajusta","YESNO")
        Processa({||NumO()},"Selecionando Registros",OemToAnsi("Aguarde..."),.F.)
	MSGBOX("Execucao da Rotina foi realizada com Sucesso","Execucao da Rotina")
EndIf

Return()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function NumO()

USE PROV NEW ALIAS PRV

DbSelectArea("SC6")
DbGotop()
ProcRegua(LastRec())

Do While SC6->(!eof())

   IncProc()

   If    SC6->C6_NUM < "006043";
   .or. SC6->C6_NUM > "900000"        
       DbSelectArea("SC6")
       DbSkip()
       Loop
   EndIf

   If Empty(SC6->C6_NFORI)
       DbSelectArea("SC6")
       DbSkip()
       Loop
   EndIf

   DbSelectArea("SD1")
   DbSetOrder(10)
   DbSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_NUMSERI)

   If Found() .and. SC6->C6_IDENTB6 <> SD1->D1_IDENTB6;
              .and. !Empty(SC6->C6_IDENTB6)

       DbSelectArea("SB6")
       DbSetOrder(3)
       DbSeek(xFilial("SB6")+SD1->D1_IDENTB6)

       If SB6->B6_SALDO >= SC6->C6_QTDVEN

           DbSelectArea("PRV")
           RECLOCK("PRV",.T.)
           PRV->TIPO      := "1"
           PRV->NFORI     := SC6->C6_NFORI
           PRV->SERIORI   := SC6->C6_SERIORI
           PRV->CLI       := SC6->C6_CLI
           PRV->LOJA      := SC6->C6_LOJA
           PRV->PRODUTO   := SC6->C6_PRODUTO
           PRV->ITEMORI   := SC6->C6_ITEMORI
           PRV->SERC6     := SC6->C6_NUMSERI
           PRV->SERD1     := SD1->D1_NUMSER
           PRV->PEDIDO    := SC6->C6_NUM
           MsunLock()

           DbSelectArea("SC6")
           RecLock("SC6",.F.)
           SC6->C6_IDENTB6 := SD1->D1_IDENTB6
           MsunLock()

       Else

           DbSelectArea("PRV")
           RECLOCK("PRV",.T.)
           PRV->TIPO      := "2"
           PRV->NFORI     := SC6->C6_NFORI
           PRV->SERIORI   := SC6->C6_SERIORI
           PRV->CLI       := SC6->C6_CLI
           PRV->LOJA      := SC6->C6_LOJA
           PRV->PRODUTO   := SC6->C6_PRODUTO
           PRV->ITEMORI   := SC6->C6_ITEMORI
           PRV->SERC6     := SC6->C6_NUMSERI
           PRV->SERD1     := SD1->D1_NUMSER
           PRV->PEDIDO    := SC6->C6_NUM
           MsunLock()

       EndIf

   EndIf

   DbSelectArea("SC6")
   DbSkip()

EndDo

DbSelectArea("SD2")
DbGotop()
ProcRegua(LastRec())

Do While SD2->(!eof())

   IncProc()

   If    SD2->D2_PEDIDO < "006043";
   .or. SD2->D2_PEDIDO > "900000"        
       DbSelectArea("SD2")
       DbSkip()
       Loop
   EndIf

   If Empty(SD2->D2_NFORI)
       DbSelectArea("SD2")
       DbSkip()
       Loop
   EndIf

   DbSelectArea("SD1")
   DbSetOrder(10)
   DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_NUMSERI)

   If Found() .and. SD2->D2_IDENTB6 <> SD1->D1_IDENTB6;
              .and. !Empty(SD2->D2_IDENTB6)

       DbSelectArea("SB6")
       DbSetOrder(3)
       DbSeek(xFilial("SB6")+SD1->D1_IDENTB6)

       If SB6->B6_SALDO >= SD2->D2_QUANT

           DbSelectArea("PRV")
           RECLOCK("PRV",.T.)
           PRV->TIPO      := "3"
           PRV->NFORI     := SD2->D2_NFORI
           PRV->SERIORI   := SD2->D2_SERIORI
           PRV->CLI       := SD2->D2_CLIENTE
           PRV->LOJA      := SD2->D2_LOJA
           PRV->PRODUTO   := SD2->D2_COD
           PRV->ITEMORI   := SD2->D2_ITEMORI
           PRV->SERC6     := SD2->D2_NUMSERI
           PRV->SERD1     := SD1->D1_NUMSER
           PRV->PEDIDO    := SD2->D2_PEDIDO
           MsunLock()

           DbSelectArea("SD2")
           RecLock("SD2",.F.)
           SD2->D2_IDENTB6 := SD1->D1_IDENTB6
           MsunLock()

       Else

           DbSelectArea("PRV")
           RECLOCK("PRV",.T.)
           PRV->TIPO      := "4"
           PRV->NFORI     := SD2->D2_NFORI
           PRV->SERIORI   := SD2->D2_SERIORI
           PRV->CLI       := SD2->D2_CLIENTE
           PRV->LOJA      := SD2->D2_LOJA
           PRV->PRODUTO   := SD2->D2_COD
           PRV->ITEMORI   := SD2->D2_ITEMORI
           PRV->SERC6     := SD2->D2_NUMSERI
           PRV->SERD1     := SD1->D1_NUMSER
           PRV->PEDIDO    := SD2->D2_PEDIDO
           MsunLock()

       EndIf

   EndIf

   DbSelectArea("SD2")
   DbSkip()

EndDo

Return()
