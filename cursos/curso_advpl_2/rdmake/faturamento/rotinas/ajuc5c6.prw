#include "rwmake.ch"

USER FUNCTION AJUC5C6()

Private _aSavArea := GetArea()
Private _lGrava := .F.

u_GerA0003(ProcName())

IF MsgBox("Esta rotina ira ajustar Pedidos de Vendas.Deseja Continuar?","Ajusta","YESNO")
	Processa({||SGera()},"Selecionando Registros",OemToAnsi("Aguarde..."),.F.)
	MSGBOX("Execucao da Rotina foi realizada com Sucesso","Execucao da Rotina")
EndIf

RestArea(_aSavArea)

Return()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function SGera()

DbSelectArea("SC5")
DbGotop()
ProcRegua(LastRec())

While SC5->(!eof())

   IncProc()

   _lTudoOK  := .T.
   _lLiber   := .F.
   _nQuant   := 0
   _cNota    := Space(06)
   _cSerie   := Space(02)
   _dDataF   := CtoD("  /  /  ")
   _nQuantC9 := 0

   DbSelectArea("SC6")
   DbSetOrder(1)
   DbSeek(xFilial("SC6")+SC5->C5_NUM)

   Do While !Eof() .and. SC6->C6_NUM == SC5->C5_NUM

       _nQuant   := 0
       _cNota    := Space(06)
       _cSerie   := Space(02)
       _dDataF   := CtoD("  /  /  ")
       _nQuantC9 := 0

       DbSelectArea("SD2")
       DbSetOrder(8)
       DbSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_ITEM)
       Do While !Eof() .and. SC6->C6_NUM  == SD2->D2_PEDIDO;
                       .and. SC6->C6_ITEM == SD2->D2_ITEMPV
           _nQuant := _nQuant + SD2->D2_QUANT
           _cNota  := SD2->D2_DOC
           _cSerie := SD2->D2_SERIE
           _dDataF := SD2->D2_EMISSAO
           DbSelectArea("SD2")
           DbSkip()
       EndDo
       DbSelectArea("SC6")
       RecLock("SC6",.F.)
       SC6->C6_QTDENT := _nQuant
       If SC6->C6_QTDVEN == _nQuant
           SC6->C6_NOTA   := _cNota
           SC6->C6_SERIE  := _cSerie
           SC6->C6_DATFAT := _dDataF
       EndIf
       MsunLock()
       If SC6->C6_QTDVEN <> _nQuant 
           _lTudoOK := .F.
       EndIf

       DbSelectArea("SC9")
       DbSetOrder(1)
       DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
       Do While !Eof() .and. SC6->C6_NUM  == SC9->C9_PEDIDO;
                       .and. SC6->C6_ITEM == SC9->C9_ITEM
           If SC9->C9_BLEST <> "10" .and. SC9->C9_BLCRED <> "10"
               _nQuantC9 := _nQuantC9 + SC9->C9_QTDLIB
           EndIf
           _lLiber := .T.
           DbSelectArea("SC9")
           DbSkip()
       EndDo
       DbSelectArea("SC6")
       RecLock("SC6",.F.)
       SC6->C6_QTDEMP := _nQuantC9
       MsunLock()
       
       DbSelectArea("SC6")
       DbSkip()
   EndDo
   DbSelectArea("SC5")
   RecLock("SC5",.F.)
   If _lLiber  == .T.
       SC5->C5_LIBEROK := "S"
   EndIf
   If _lTudoOK == .T.
       SC5->C5_NOTA  := _cNota
       SC5->C5_SERIE := _cSerie
   EndIf
   MsunLock()
   
   DbSelectArea("SC5")
   DbSkip()

EndDo

Return()
