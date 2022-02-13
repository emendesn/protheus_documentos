#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define ENTER CHR(10)+CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA080VLD º Autor ³Paulo Lopez         º Data ³  26/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PONTO DE ENTRADA PARA VALIDAÇÃO DE TES                      º±±
±±º          ³BLOQUEIO DE ALTERAÇÃO QUANTO TIVER TES ULTILIZADO EM PV     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA080VLD(nOpc)

Local lRet := .T.
Local _cCod
Local _cPos
Local _cEst
Local _cQry


u_GerA0003(ProcName())

_cCod := M->F4_CODIGO
_cPos := M->F4_PODER3 
_cEst := M->F4_ESTOQUE
/*
If !Inclui .And. (SF4->F4_PODER3 <> _cPos .Or. SF4->F4_ESTOQUE <> _cEst)
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	
	_cQry := " SELECT TOP 1 C6_TES TES " + ENTER
	_cQry += " FROM " + RetSqlName("SC6") + " C6 (NOLOCK) " + ENTER
	_cQry += " WHERE C6.D_E_L_E_T_ = '' " + ENTER
	_cQry += " AND C6_TES = '"+_cCod+"' " + ENTER
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	
	If Len(AllTRim(QRY->TES)) > 0 
		MsgAlert("Impossivel Alteração, Devido à Saída de Produtos Controlando Poder de Terceiros !!")
		lRet := .F.
	EndIf
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	
EndIf   */

Return(lRet)