#include "totvs.ch"
#include "protheus.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณTELATXT   บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ AP                                                         บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function IpTxtGcom()
Local oDlg
Local oSay01
Local oSay02
Local oSay03
Local oGetTXT
Local oBtnFile
Local oBtnOK
Local lOk := .F.
Local cType := "Arquivo TXT (*.TXT) |*.txt|"
Local cGetTXT	:= space(200)  

DEFINE MSDIALOG oDlg TITLE "Importa็ใo de TXT - GCOM" FROM 000, 000  TO 170,370 PIXEL 
	@010,010 SAY oSay01 PROMPT "Este programa farแ a inclusใo de ," SIZE 120,010 OF oDlg PIXEL
	@030,010 SAY oSay02 PROMPT "a partir de um arquivo TXT" SIZE 120,010 OF oDlg PIXEL
	@050,010 SAY oSay03 PROMPT "Arquivo TXT:" SIZE 040,010 OF oDlg PIXEL
	@048,045 MSGET oGetTXT VAR cGetTXT When .F. SIZE 120,010 OF oDlg PIXEL                                                                                                    
	@ 048, 165 BUTTON oBtnFile PROMPT "..." SIZE 010, 010 ACTION (cGetTXT:=cGetFile(cType,OemToAnsi("Selecione o arquivo a ser importado"),1,,.F.,nOR(GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T.,.T.)) OF oDlg PIXEL
	@ 070, 010 BUTTON oBtnOK PROMPT "Processa TXT" SIZE 050, 010 ACTION (Iif(!Empty(cGetTXT),LjMsgRun("Aguarde... Processando TXT",,{||lOk:=ImpTXT(cGetTXT)}),lOk:=.F.),Iif(lOk,oDlg:End(),Nil)) OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELATXT   บAutor  ณMicrosiga           บ Data ณ  05/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpTXT(cPath) 

Local cArq := "dados.txt"
Local cLinha := ""
Local lPrim := .T.
Local aCampos := {}
Local aDados := {}

Private aErro := {}


FT_FUSE(cDir+cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()

IncProc("Lendo arquivo texto...")

cLinha := FT_FREADLN()

If lPrim
aCampos := Separa(cLinha,"#",.T.)
lPrim := .F.
Else
AADD(aDados,Separa(cLinha,"#",.T.))
EndIf

FT_FSKIP()
EndDo

Begin Transaction
ProcRegua(Len(aDados))
For i:=1 to Len(aDados)

IncProc("Importando Dados...")

If aDados[i,1] $ 'C'
/// FAZ ISSO
ElseIf aDados[i,1] $ 'I'
/// Faz ISSO
Endif
Next i
End Transaction

FT_FUSE()

ApMsgInfo("Importa็ใo dos Dados concluํda com sucesso!","[AEST901] - SUCESSO")

Return

Return

