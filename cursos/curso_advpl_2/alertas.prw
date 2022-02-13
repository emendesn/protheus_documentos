///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Alertas.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Alertas()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#Include "Protheus.Ch"

User Function Alertas()
	Local oDlg
	Local aOPC := {}
	Local nRadio := 0
	Local oRadio
	Local bBlock := { |x| Iif( ValType( x ) == 'U', nRadio, nRadio:=x ) }

	aAdd( aOPC, "Alert"          )
	aAdd( aOPC, "MsgAlert"       )
	aAdd( aOPC, "MsgInfo"        )
	aAdd( aOPC, "MsgStop"        )
	aAdd( aOPC, "Help"           )
	aAdd( aOPC, "MsgYesNoTimer"  )
	aAdd( aOPC, "MsgRetryCancel" )
	aAdd( aOPC, "MsgYesNo"       )
	aAdd( aOPC, "MsgNoYes"       )
	aAdd( aOPC, "Aviso"          )

	DEFINE MSDIALOG oDlg TITLE "Alertas Protheus" FROM 0,0 TO 245,205 OF oDlg PIXEL
		@ 4, 5 TO 108,100 LABEL " Selecione " OF oDlg PIXEL
		oRadio := TRadMenu():New( 12, 10, aOPC, bBlock, oDlg, , NIL, , , , , ,80 ,10 )
		@ 110,33 BUTTON "&Executar" SIZE 32,10 PIXEL ACTION ExecFuncao(nRadio)
		@ 110,68 BUTTON "&Sair"     SIZE 32,10 PIXEL ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTER
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | ExecFuncao           | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao auxiliar                                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ExecFuncao( nRadio )
	Local nRet
	
	If nRadio == 0     ; MsgInfo("Selecione uma op��o","Oficina de Programa��o")
	Elseif nRadio == 1 ; Alert("Mensagem")
	Elseif nRadio == 2 ; MsgAlert("Mensagem","T�tulo")
	Elseif nRadio == 3 ; MsgInfo("Mensagem","T�tulo")
	Elseif nRadio == 4 ; MsgStop("Mensagem","T�tulo")
	Elseif nRadio == 5 ; Help("",1,"RECNO")
	Elseif nRadio == 6 ; nRet := MsgYesNoTimer("Mensagem","T�tulo",10000,2)
	Elseif nRadio == 7 ; nRet := MsgRetryCancel("Mensagem","T�tulo")
	Elseif nRadio == 8 ; nRet := MsgYesNo("Mensagem","T�tulo")
	Elseif nRadio == 9 ; nRet := MsgNoYes("Mensagem","T�tulo")
	Elseif nRadio == 10; nRet := Aviso("T�tulo",",Mensagem",{"Confirmar","Cancelar"},1,"Sub-t�tulo")
	Endif
	
Return