User Function TstCase()

Local nOpc := 2

Do Case
   Case nOpc == 1
        MsgAlert("Op��o 1 selecionada")
   Case nOpc == 2
        MsgAlert("Op��o 2 selecionada")
   Case nOpc == 3
        MsgAlert("Op��o 3 selecionada")
   Otherwise
        MsgAlert("Nenhuma op��o selecionada")
EndCase

Return