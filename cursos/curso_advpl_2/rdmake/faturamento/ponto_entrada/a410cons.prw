#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"
#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA410CONS  บ Autor ณPaulo Francisco     บ Data ณ  20/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAMARRAวรO NF-E X NF- RPSUE                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function A410CONS()

Local aButtons := {} // Botoes a adicionar

u_GerA0003(ProcName())


Aadd(aButtons,{"PENDENTE",{|| A41CONS()},"Amarracao RPS","RPS"})

Return aButtons

Static Function A41CONS()

Local _lMark   		:= .F.
Local y        		:= 1
Local aArea    		:= GetArea()
Local _oDlg

Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut  	:= .F.                             	 //Usuarios de Autorizado
Private cQry
Private cPerg   	:= "A41CONS"
Private _aHeader  	:= {}
Private _aItens   	:= {}
Private _aColumns 	:= {}
Private _lChk     	:= .F.
Private aCores    	:= {}
Private _oOk      	:= LoadBitmap(GetResources(), "LBOK")
Private _oNo      	:= LoadBitmap(GetResources(), "LBNO")

Private _oFont0   	:= TFont():New("Tahoma",, 16,,.F.,,,,,.F.)

nIten  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios Autorizado
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Faturamento"
		lUsrAut  := .T.
	EndIf
	
Next i

If !lUsrAut
	ApMsgStop("Usuario sem autoriza็ใo para execultar essa rotina !!","Amarracao RPS")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Dicionario de Perguntas                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fCriaSX1(cPerg)
If !Pergunte(cPerg, .T.)
	Return
EndIf

CursorWait()

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQry := " SELECT DISTINCT 	D2_DOC		AS DOC,   " + ENTER
cQry += " 					D2_SERIE	AS SERIE, " + ENTER
cQry += " 					D2_EMISSAO	AS EMISS, " + ENTER
cQry += " 					D2_CLIENTE	AS CLIEN, " + ENTER
cQry += " 					D2_LOJA		AS LOJA   " + ENTER
cQry += " FROM " + RetSqlName("SD2") + " SD2(NOLOCK) "+ ENTER
cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4(NOLOCK) " + ENTER
cQry += " ON(SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' AND SF4.F4_PODER3 = 'D') " + ENTER
cQry += " WHERE SD2.D_E_L_E_T_ = '' " + ENTER
cQry += " AND SD2.D2_EMISSAO BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' " + ENTER
cQry += " AND SD2.D2_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " + ENTER
cQry += " AND SD2.D2_SERIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " + ENTER

If mv_par07 == 1
	cQry += " AND SD2.D2_DOC + SD2.D2_SERIE NOT IN (SELECT ZN_NFESEFA + ZN_SERSEFA FROM SZN020 WHERE D_E_L_E_T_ = '' AND ZN_NFRPS = '' ) " + ENTER
Else
	cQry += " AND SD2.D2_DOC + SD2.D2_SERIE IN (SELECT ZN_NFESEFA + ZN_SERSEFA FROM SZN020 WHERE D_E_L_E_T_ = '' AND ZN_NFRPS = '' AND ZN_PEDVEND = '"+M->C5_NUM+"' ) " + ENTER
EndIf

cQry += " ORDER BY D2_EMISSAO " + ENTER

MemoWrite("D:\A410CONS.sql", cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)
TCSetField("QRY", "EMISS", "D")

QRY->(dbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")
	
	aAdd(_aItens, {_lMark,;
	0,;
	QRY->CLIEN,;
	QRY->LOJA,;
	QRY->DOC,;
	QRY->SERIE,;
	QRY->EMISS;
	})
	
	dbSelectArea("QRY")
	dbSkip()
	
EndDo

CursorArrow()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Fecha Query                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Empty(_aItens)
	MsgAlert("Nใo foram encontrados dados para a consulta!", "Aten็ใo")
	Return
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Estrutura do MarkBrowse                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(_aHeader , { "", "Seq", "Clie", "Loja", "Doc", "Serie", "Emissao"})
aAdd(_aColumns, { 4, 6, 6, 2, 9, 3, 8})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Apresenta o MarkBrowse para o usuario                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oDlg           := MSDialog():New(000, 000, 350, 500, "Sele็ใo de NFs",,,,,,,, oMainWnd, .T.)
_oDlg:lCentered := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Desenha os GroupBoxes                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oGrpo1 := TGroup():New(003, 003, 150, 250,, _oDlg,,, .T.)
_oGrpo2 := TGroup():New(151, 003, 170, 100,, _oDlg,,, .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Desenha os Botoes.                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oBtn2 := TButton():New(154, 150, 'Confirmar', _oDlg,{||  GravaItem(), _oDlg:End(),}  , 50, 15,,,,.T.)
_oBtn3 := TButton():New(154, 200, 'Sair'     , _oDlg,{|| _oDlg:End()}, 50, 15,,,,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Informacoes do Rodape                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oInf1 := TSay():New(157, 010, {|| "Itens Selecionados:" + Transform(nIten, "@E 999,999") }, _oDlg,, _oFont0,,,, .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Desenha o MarkBrowse.                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oBrw3 := TWBrowse():New(012, 010, 235, 135,, _aHeader[1], _aColumns[1], _oDlg,,,,,,,,,,,,,, .T.)
oBrw3:SetArray(_aItens)
oBrw3:bLine := {|| {;
Iif(_aItens[oBrw3:nAt][01], _oOk, _oNo),;
_aItens[oBrw3:nAt][02],;
_aItens[oBrw3:nAt][03],;
_aItens[oBrw3:nAt][04],;
_aItens[oBrw3:nAt][05],;
_aItens[oBrw3:nAt][06],;
_aItens[oBrw3:nAt][07]}}

oBrw3:lAdJustColSize := .T.
oBrw3:lColDrag       := .T.
oBrw3:lMChange       := .F.
oBrw3:lHScroll       := .F.
oBrw3:bLDblClick     := {|| _aItens[oBrw3:nAt,01] := !_aItens[oBrw3:nAt,01],;
Iif(_aItens[oBrw3:nAt,01], _aItens[oBrw3:nAt,02] := y, _aItens[oBrw3:nAt,02] := 0),;
Iif(_aItens[oBrw3:nAt,01], nIten := y , _aItens[oBrw3:nAt,02] := 0),;
_oInf1:Refresh(),;
Iif(_aItens[oBrw3:nAt,01], y++, y--)}


_oDlg:Activate(,,,.T.)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVAITEM บ Autor ณPaulo Francisco     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ GRAVAR SELEวรO EM TABELAS                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GravaItem()

Local x

For x := 1 to Len(_aItens)
	If _aItens[x,01]
		
		If mv_par07 == 1
			Begin Transaction
			RecLock("SZN",.T.)
			
			SZN->ZN_FILIAL 	:= xFilial("SZN")
			SZN->ZN_NFESEFA	:= _aItens[x][05]
			SZN->ZN_SERSEFA	:= _aItens[x][06]
			SZN->ZN_PEDVEND	:= M->C5_NUM
			
			MSUnlock("SZN")
			End Transaction
		Else
			
			Dbselectarea("SZN")
			SZN->(dbSetOrder(1))
			
			If SZN->(dbSeek(xFilial("SZN" ) + _aItens[x][05] + _aItens[x][06]))
				While SZN->(!eof()) .and. SZN->ZN_FILIAL == xFilial("SZN") .and. SZN->ZN_NFESEFA == _aItens[x][05] .And. SZN->ZN_SERSEFA == _aItens[x][06]
					
					Dbselectarea("SZN")
					Begin Transaction
					RecLock("SZN",.F.)
					
					dbDelete()
					
					MSUnlock("SZN")
					End Transaction
					
					SZN->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf
Next x

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Francisco     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaSX1()

Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","De Emissใo        ?","","","mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","At้ Emissใo       ?","","","mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","De Nota Fiscal    ?","","","mv_ch3","C",09,0,0,"G","","SF2","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate Nota Fiscal   ?","","","mv_ch4","C",09,0,0,"G","","SF2","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","De Serie          ?","","","mv_ch5","C",03,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Ate Serie         ?","","","mv_ch6","C",03,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Tipo de Gera็ใo   ?","","","mv_ch7","N",01,0,0,"C","",""   ,"","","mv_par06","Inclusใo","","","","Altera็ใo","","","","","","","","","","","","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Emissใo Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informa a Emissใo Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Nota Fiscal Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Nota Fiscal Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Serie Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "06."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Serie Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P." + cPerg + "07."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Inclusใo ou Altera็ใo.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return 