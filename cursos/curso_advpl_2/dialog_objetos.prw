///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Objetos.prw   | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - DialogObj()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao da MsDialog com varios objetos                     |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#Include "Protheus.Ch"

User Function DialogObj()

//+-------------------------
//| Declarações das varáveis
//+-------------------------
Local oDlg
Local oCombo

Local nNumero := 0
Local dData   := Ctod(Space(8))

Local cNome   := Space(20)
Local cArq    := Space(250)
Local cDir    := Space(250)
Local cExt    := "Arquivo DBF | *.DBF"
Local cPath   := "Selecione diretório"
Local cCombo  := Space(10)
Local cViaF3  := Space(10)
Local cAtencao:= "Atenção"

Local aCombo  := {}
Local lChk    := .F.

Private aRadio  := {} 
Private nRadio  := 0
Private oFld    := Nil
Private oRadio  := Nil

//+-----------------------
//| Atribuição as matrizes
//+-----------------------
aAdd( aCombo, "Opcao 1" )
aAdd( aCombo, "Opcao 2" )
aAdd( aCombo, "Opcao 3" )
aAdd( aCombo, "Opcao 4" )
aAdd( aCombo, "Opcao 5" )

aAdd( aRadio, "Disco" )
aAdd( aRadio, "Impressora" )
aAdd( aRadio, "Scanner" )

//+-------------------------------------
//| Definição da janela e seus conteúdos
//+-------------------------------------
DEFINE MSDIALOG oDlg TITLE "MsDialog com Objetos" FROM 0,0 TO 280,552 OF oDlg PIXEL

@ 06,06 TO 46,271 LABEL "Exemplo de Campos" OF oDlg PIXEL

@ 15, 15 SAY   "Campo Caracter" SIZE 45,8 PIXEL OF oDlg
@ 25, 15 MSGET cNome PICTURE "@!" SIZE 80,10 PIXEL OF oDlg

@ 15,100 SAY "Campo Numerico"  SIZE 45,8 PIXEL OF oDlg
@ 25,100 MSGET nNumero PICTURE "@E 99,999,999.99" VALID nNumero >= 0 SIZE 80,10 PIXEL OF oDlg

@ 15,185 SAY "Campo Data"   SIZE 35,8 PIXEL OF oDlg
@ 25,185 MSGET dData PICTURE "99/99/99" SIZE 76,10 PIXEL OF oDlg

@ 50,06 FOLDER oFld OF oDlg PROMPT "&Buscas", "&Consultas", "Check-&Up / Botões" PIXEL SIZE 222,078

//+-----------------------
//| Campos da pasta Buscas
//+-----------------------
@ 06, 10 SAY "Diretorio a partir do Root"  SIZE  65, 8 PIXEL OF oFld:aDialogs[1]
@ 16, 10 MSGET cDir PICTURE "@!"           SIZE 180,10 PIXEL OF oFld:aDialogs[1]
@ 15,200 BUTTON "..."                      SIZE  13,13 PIXEL OF oFld:aDialogs[1] ACTION cDir:=cGetFile(,cPath,,,.T.,128)

@ 30, 10 SAY "Arquivo a partir do Root"   SIZE  65, 8 PIXEL OF oFld:aDialogs[1]
@ 40, 10 MSGET cArq PICTURE "@!"          SIZE 180,10 PIXEL OF oFld:aDialogs[1]
@ 39,200 BUTTON "..."                     SIZE  13,13 PIXEL OF oFld:aDialogs[1] ACTION cArq:=cGetFile(cExt,cExt,,,.T.,1)
                
//+--------------------------
//| Campos da pasta Consultas
//+--------------------------
@ 06, 10 SAY "Consulta via [F3]"            SIZE  65, 8 PIXEL OF oFld:aDialogs[2]
@ 16, 10 MSGET cViaF3 F3 "SA6" PICTURE "@!" SIZE 180,10 PIXEL OF oFld:aDialogs[2]

@ 30, 10 SAY "Consulta via ComboBox"             SIZE  65, 8 PIXEL OF oFld:aDialogs[2]
@ 40, 10 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 180,10 PIXEL OF oFld:aDialogs[2]

//+-------------------------
//| Campos da pasta Check-Up
//+-------------------------
@ 06, 2 CHECKBOX oChk VAR lChk PROMPT "Check Box" SIZE 35,8 PIXEL OF oFld:aDialogs[3] ;
         ON CLICK(Iif(lChk,MsgInfo("Habilitado",cAtencao),MsgAlert("Desabilidato",cAtencao)))

@ 30, 2 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2],aRadio[3] SIZE 35,8 PIXEL OF ;
         oFld:aDialogs[3] ;
         ON CHANGE ;
         (Iif(nRadio==1,MsgInfo("Opcão 1",cAtencao),;
          Iif(nRadio==2,MsgInfo("Opção 2",cAtencao),MsgInfo("Opção 3",cAtencao))),oRadio:Refresh())

//+---------------------
//| Botões da aDialog[3]
//+---------------------
DEFINE SBUTTON FROM  4, 40 TYPE  1 ACTION (MsgInfo("Tipo  1",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18, 40 TYPE  2 ACTION (MsgInfo("Tipo  2",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32, 40 TYPE  3 ACTION (MsgInfo("Tipo  3",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 46, 40 TYPE  4 ACTION (MsgInfo("Tipo  4",cAtencao)) ENABLE OF oFld:aDialogs[3]

DEFINE SBUTTON FROM  4, 70 TYPE  5 ACTION (MsgInfo("Tipo  5",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18, 70 TYPE  6 ACTION (MsgInfo("Tipo  6",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32, 70 TYPE  7 ACTION (MsgInfo("Tipo  7",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 46, 70 TYPE  8 ACTION (MsgInfo("Tipo  8",cAtencao)) ENABLE OF oFld:aDialogs[3]

DEFINE SBUTTON FROM  4,100 TYPE  9 ACTION (MsgInfo("Tipo  9",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18,100 TYPE 10 ACTION (MsgInfo("Tipo 10",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32,100 TYPE 11 ACTION (MsgInfo("Tipo 11",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 46,100 TYPE 12 ACTION (MsgInfo("Tipo 12",cAtencao)) ENABLE OF oFld:aDialogs[3]

DEFINE SBUTTON FROM  4,130 TYPE 13 ACTION (MsgInfo("Tipo 13",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18,130 TYPE 14 ACTION (MsgInfo("Tipo 14",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32,130 TYPE 15 ACTION (MsgInfo("Tipo 15",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 46,130 TYPE 16 ACTION (MsgInfo("Tipo 16",cAtencao)) ENABLE OF oFld:aDialogs[3]

DEFINE SBUTTON FROM  4,160 TYPE 17 ACTION (MsgInfo("Tipo 17",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18,160 TYPE 18 ACTION (MsgInfo("Tipo 18",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32,160 TYPE 19 ACTION (MsgInfo("Tipo 19",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 46,160 TYPE 20 ACTION (MsgInfo("Tipo 20",cAtencao)) ENABLE OF oFld:aDialogs[3]

DEFINE SBUTTON FROM  4,190 TYPE 21 ACTION (MsgInfo("Tipo 21",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 18,190 TYPE 22 ACTION (MsgInfo("Tipo 22",cAtencao)) ENABLE OF oFld:aDialogs[3]
DEFINE SBUTTON FROM 32,190 TYPE 23 ACTION (MsgInfo("Tipo 23",cAtencao)) ENABLE OF oFld:aDialogs[3]

//+-------------------
//| Botoes da MSDialog
//+-------------------
@ 093,235 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION oDlg:End()
@ 113,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER
Return