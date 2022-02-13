//+----------------------------------------------------------------------------
//| Rotina....: xMsDialog
//+----------------------------------------------------------------------------
//| Autor.....: Robson Luiz                                 Data...: 01/01/2005
//+----------------------------------------------------------------------------
//| Descri��o.: Exemplo da utiliza��o do comando MsDialog (janela/formul�rio)
//+----------------------------------------------------------------------------
//| Utiliza��o: OFICINA DE PROGRAMA��O
//+----------------------------------------------------------------------------
//| Veja mais sobre o comando ou a classe no arquivo SIGAWIN.CH
//+----------------------------------------------------------------------------
#Include "Protheus.ch"

User Function xMsDialog()
Local oDlg 

DEFINE MSDIALOG oDlg TITLE "Janela do Protheus" FROM 0,0 TO 400,600 OF oMainWnd PIXEL
	oDlg:lMaximized := .T.
	oDlg:lEscClose := .F. 

// DEFINE MSDIALOG oDlg TITLE "Janela do Protheus" FROM 0,0 TO 400,600 OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

// ACTIVATE MSDIALOG oDlg CENTER WHEN <lCondi��oL�gica>
// ACTIVATE MSDIALOG oDlg CENTER VALID <lCondi��oL�gica>
// ACTIVATE MSDIALOG oDlg CENTER ON INIT <uFuncao>

ACTIVATE MSDIALOG oDlg CENTER 

Return
