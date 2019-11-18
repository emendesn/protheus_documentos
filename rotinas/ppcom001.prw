#Include "Protheus.ch"

/****************************************************************************
** Programa: PPCOM001    * Autor: Sergio Lacerda       * Data: 01/10/2010 ***
*****************************************************************************
** Desc.: Funcao que faz o retorno do WorkFlow de Aprovacao do Pedido de  ***
**        Compras.                                                        ***
*****************************************************************************
** DATA      * ANALISTA *  MOTIVO                                         ***
*****************************************************************************
**           *          *                                                 ***
****************************************************************************/
User Function PPCOM001(oProcess,cPedido,cUsrAprov,cAprova,cMotivo)

Local cFindKey, cAssunto, cNumPed, cShape, cCodigoStatus, cDescricao
LOcal lObjeto   := .T.
Default cPedido := ""
Default cUsrAprov := ""
Default cAprova   := ""
Default cMotivo   := ""


If Empty(cPedido) .And. Empty(cUsrAprov) .And. Empty(cAprova)
	// Obtenha o n�mero do pedido:
	cNumPed   := oProcess:oHtml:RetByName("Pedido")
	cUsrAprov := oProcess:oHtml:RetByName("UsrAprov")
	cAprova   := oProcess:oHtml:RetByName("RBAPROVA")
	cMotivo   := oProcess:oHtml:RetByName('lbmotivo')
Else
	// Obtenha o n�mero do pedido:
	cNumPed   := cPedido
	cUsrAprov := cUsrAprov
	cAprova   := cAprova
	lObjeto   := .F.
Endif

ConOut("******************************************************")
ConOut("Numero do Pedido: " + cNumPed )
ConOut("Usuario Aprovador: " + cUsrAprov)
ConOut("******************************************************")
ConOut("")

If lObjeto
	// Monte a lista de argumentos para ser passada para o m�todo track():
	// Pode ser informado mais do que um nome de shape para uma mesma
	// a��o do fluxo. Basta inform�-los utilizando o ";" para identificar cada um deles.
	cAssunto := "Pedido de compras no: " + cNumPed
	cShape := "RECEBE;REMETENTE;APROVADO?"
	cCodigoStatus := "100400"
	cDescricao := "Recebendo resultado aprova��o..."
	oProcess:Track( cCodigoStatus, cDescricao,,cShape  )
Endif

// Verifique se a resposta � diferente de "SIM", ou seja, reprovado.
if Upper(cAprova) <> "SIM"
	ConOut("******************************************************")
	ConOut("Processo Reprovado")
	ConOut("******************************************************")
	ConOut("")
	dbSelectarea("SCR")  // Posicione a libera��o
	dbSetorder(2)
	If dbSeek( xFilial("SCR") + "PC" + Padr(cNumPed,50) + cUsrAprov)
		RecLock("SCR",.f.)
		CR_DATALIB := dDataBase
		CR_OBS := ""
		CR_STATUS := "04"  // Bloqueado
		CR_OBS := cMotivo
		MsUnLock()
		DbCommit()
	End
	
	// Dessa vez, n�o informe nenhum shape associado � reprova��o por n�o
	// haver nenhum shape relacionado � reprova��o.
	If lObjeto
		// Gere novas informa��es a serem passadas para a rastreabilidade:
		cCodigoStatus := "100600"
		cDescricao := cAssunto + " - REPROVADO"
		oProcess:Track( cCodigoStatus, cDescricao )
		
	Endif
	U_Wfw120Ret(cNumPed, cMotivo,.F.,cUsrAprov)
	Return(.F.)
end
U_Wfw120Ret(cNumPed, cMotivo,.T.,cUsrAprov)
// Libere o pedido:
dbSelectArea("SCR")
dbSetOrder(2)
cFindKey := xFilial("SCR") + "PC" + Padr(cNumPed,50) + cUsrAprov
If dbSeek( cFindKey )
	ConOut("******************************************************")
	ConOut("Registro Localizado, atualizando")
	ConOut("******************************************************")
	ConOut("")
	RecLock("SCR",.f.)
	SCR->CR_DATALIB := dDataBase
	SCR->CR_OBS := ""
	SCR->CR_STATUS := "03"
	MsUnLock()
	DbCommit()
Else
	ConOut("******************************************************")
	ConOut("Registro Nao encontrador, problemas no seek")
	ConOut("******************************************************")
	ConOut("")
end

ConOut("******************************************************")
ConOut("Chamando funcao de Envio da Aprovacao")
ConOut("******************************************************")
ConOut("")
DbSelectArea("SC7")
DbSetOrder(1)
Dbseek(xFilial("SC7") + cNumPed)
U_Wfw120P()
Return(.T.)