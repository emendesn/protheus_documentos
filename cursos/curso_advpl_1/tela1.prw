#Include "PROTHEUS.CH"

User Function Tela1()

Local oDlg
Local aButtons
Local cNome  := Space(20)
Local cEnder := Space(30)
Local cCivil := Space(1)

aButtons := {{"BMPPERG", {||MsgInfo("Pergunte")}, "Pergunte..."},;
             {"BMPCALEN", {||MsgInfo("Calendario")}, "Calendario..."}}
             
Define MSDialog oDlg Title "" From 0,0 To 400,600 Pixel

@20,10 Say "Nome:" Pixel Of oDlg
@20,50 Get cNome Pixel Of oDlg

@40,10 Say "Estado Civil:" Pixel Of oDlg
@40,50 Get cCivil Picture "@!" Valid cCivil$"S|C|D" Pixel Of oDlg

@60,10 Say "Endereço:" Pixel Of oDlg
@60,50 Get cEnder Pixel Of oDlg

Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg, {|| oDlg:End()}, {||oDlg:End()},,aButtons)

Return Nil
             