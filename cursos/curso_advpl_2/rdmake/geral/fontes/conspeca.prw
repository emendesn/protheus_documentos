#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

#define ENTER CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CONSPECA บ Autor ณPaulo Lopez         บ Data ณ  18/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME PECAS APONTADAS PELO USUARIO                        บฑฑ
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

User Function CONSPECA()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracoes das variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oDlgCgar
Private cIMEI  		:= space(TamSX3("ZZ4_IMEI")[1])//Space(15)
Private lCheck 		:= .T.

u_GerA0003(ProcName())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao da janela e seus conteudos                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlgCgar TITLE "Consulta Pe็as" FROM 0,0 TO 210,420 OF oDlgCgar PIXEL

@ 010,015 SAY   "Informe o IMEI para Consultar Pe็as." 	SIZE 150,008 PIXEL OF oDlgCgar
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlgCgar
@ 045,025 GET cIMEI PICTURE "@!" 	SIZE 080,010 Valid U_CONSPE02(@cIMEI) Object ocodimei

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Botoes da MSDialog                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgCgar:end())

Activate MSDialog oDlgCgar CENTER On Init ocodimei:SetFocus()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CONSPE02 บ Autor ณPaulo Lopez         บ Data ณ  18/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME PECAS APONTADAS CONFORME PARAMETRO INFORMADO        บฑฑ
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
User Function CONSPE02(cIMEI)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oPrint

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint   := PcoPrtIni("Impressใo de Pe็as",.F.,2,)

oProcess := MsNewProcess():New({|lEnd| fCONSPEI(,oPrint,oProcess,cIMEI)},"","",.F.)
oProcess :Activate()

PcoPrtEnd(oPrint)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCONSPEI  บ Autor ณPaulo Francisco     บ Data ณ  18/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEFETUA IMPRESSAO DA REQUISICAO                              บฑฑ
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
Static Function fCONSPEI(lEnd,oPrint,oProcess,cIMEI)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilziadas                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private  nLin
Private  cQry
Private  _cQry
Private  cServ
Private nItens
Private nVia

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fontes utilizadas                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oFont0  := TFont():New( "Arial"             ,,07     ,,.F.,,,,,.F.)
Private oFont2	:= TFont():New( "Arial"             ,,10     ,,.T.,,,,,.F.)
Private oFont3	:= TFont():New( "Arial"             ,,14     ,,.T.,,,,,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Verifica parametro IMEI esta vazio                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

CursorWait()

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf          

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Montagem da Query                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQry	:=	" SELECT 	ZZ4.ZZ4_CODCLI			CODCLI,	" + ENTER
cQry	+=	" 			SA1.A1_EST				EST,    " + ENTER
cQry	+=	" 			ZZ4.ZZ4_LOJA  			LOJA, 	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_IMEI  			IMEI, 	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_CARCAC			CARCAC, " + ENTER
cQry	+=	" 			RTRIM(ZZ4.ZZ4_CODPRO)	COD, 	" + ENTER
cQry	+=	" 			RTRIM(SB1.B1_DESC)		PRODUT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_OS  			ORDSERV," + ENTER
cQry	+=	" 			ZZ4.ZZ4_OPEBGH 			OPERAC,	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_OPEANT			OPERAT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_GARANT			GARANT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_BOUNCE			BOUNCE,	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_TRANSC			TRANSC,	" + ENTER
cQry	+=	" 			SZA.ZA_GARNFC			GARNFC, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_DEFINF			Z4_DEFI," + ENTER
cQry	+=	" 			ISNULL(ZZG1.ZZG_RECCLI, 'C0022')AS	RECLAM, 			" + ENTER
cQry	+=	" 			SZA.ZA_DEFRECL			DEFEITO," + ENTER
cQry	+=	" 			ISNULL(SZA.ZA_SPC,0)	SPC,	" + ENTER
cQry	+=	" 			ISNULL(SZA.ZA_NOMUSER,0) NOMUSER,	" + ENTER
cQry	+=	" 			ZZG.ZZG_DESCRI			DESCRIC, 	" + ENTER
cQry	+=	" 			ZZG1.ZZG_DESCRI			DESCRIC1	" + ENTER
cQry	+= " FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock)   	" + ENTER
cQry	+= " LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock)   	" + ENTER
cQry	+= " ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI    " 			+ ENTER
cQry	+= " AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)   " 	+ ENTER
cQry	+= " INNER JOIN " + RetSqlName("SB1") + " SB1 (nolock)  	" 																							+ ENTER
cQry	+= " ON(ZZ4.ZZ4_CODPRO = SB1.B1_COD AND SB1.B1_FILIAL = '" + xFilial("SB1") + "')" 																		+ ENTER
cQry	+= " INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock) " 																								+ ENTER
cQry	+= " ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '" + xFilial("SB1") + "')"											+ ENTER
cQry	+= " LEFT JOIN " +  RetSqlName("ZZG") + " ZZG1 (nolock)  	" 																							+ ENTER
cQry	+= " ON(ZZ4.ZZ4_DEFINF = ZZG1.ZZG_CODIGO AND ZZG1.D_E_L_E_T_ = '') " 																					+ ENTER
cQry	+= " LEFT JOIN " +  RetSqlName("ZZG") + " ZZG (nolock)  	" 																							+ ENTER
cQry	+= " ON(SZA.ZA_DEFRECL = ZZG.ZZG_CODIGO AND ZZG.D_E_L_E_T_ = '') " 																						+ ENTER
cQry	+= " WHERE ZZ4.ZZ4_STATUS IN ('3','4')   " 																												+ ENTER
cQry	+= " AND ZZ4.D_E_L_E_T_ = ''   " 														  																+ ENTER
cQry	+= " AND ZZ4.ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " 																									+ ENTER
cQry	+= " AND ZZ4.ZZ4_IMEI = '" + cIMEI + "'  " 	 																											+ ENTER

MemoWrite("c:\pecas.sql", cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)
TCSetField("QRY", "DTENTRA", "D")
TCSetField("QRY", "DTCOMP",  "D")
TCSetField("QRY", "DTTROC",  "D")
TCSetField("QRY", "GARACARC",  "D")

QRY->(dbGoTop())

_cQry	:=	" SELECT Z9_IMEI, Z9_NUMOS, Z9_PARTNR, Z9_SEQ, Z9_QTY, Z9_CODTEC, Z9_LOCAL FROM " + RetSqlName("SZ9") + " WHERE Z9_FILIAL='"+xfilial("SZ9")+"' AND Z9_NUMOS = '" + QRY->ORDSERV+ "' AND D_E_L_E_T_ = ''  "

MemoWrite("c:\pecasx.sql", _cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY1", .F., .T.)

QRY1->(dbGoTop())

If  Len (AllTrim(QRY->OPERAC)) < 1
	CursorArrow()
	MsgStop("Caro Usuario IMEI 	Nใo Localizado")
	Return()
Endif

CursorArrow()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint :StartPage()

fCabec() //Cabecalho
                /*
dbSelectArea("SZ9")
dbSetOrder(2)
dbSeek( xFilial("SZ9") + QRY->IMEI + QRY->ORDSERV )
                  */
nItens 	:= 0
nVia 	:= 0
nTot	:= 0

While !QRY1->(EOF()) //.And. ( QRY1->Z9_IMEI + QRY1->Z9_NUMOS ) == ( QRY->IMEI + QRY->ORDSERV )
	
	//	If !Empty(SZ9->Z9_PARTNR)
	
	oPrint :Say( nLin , 0018 , QRY1->Z9_PARTNR , oFont0 , 100 )
	oPrint :Say( nLin , 0420 , Posicione("SB1",1,xFilial("SB1") + QRY1->Z9_PARTNR,"B1_DESC") , oFont0 , 100 )
	oPrint :Say( nLin , 1075 , Posicione("SB1",1,xFilial("SB1") + QRY1->Z9_PARTNR,"B1_UM") , oFont0 , 100 )
	oPrint :Say( nLin , 1315 , Transform(StrZero(QRY1->Z9_QTY,2),"@E 99") ,oFont0 , 100 )
	oPrint :Say( nLin , 1560 , Transform(QRY1->Z9_SEQ,"@E 99") , oFont0 , 100 )
	oPrint :Say( nLin , 1850 , Transform(QRY1->Z9_LOCAL,"@E 99") , oFont0 , 100 )
	oPrint :Say( nLin , 2160 , QRY1->Z9_CODTEC , oFont0 , 100 )
	/*oPrint :Say( nLin , 1325 , SZ9->Z9_SEQ ,oFont0 , 100 )
	oPrint :Say( nLin , 1760 , SZ9->Z9_LOCAL , oFont0 , 100 )
	oPrint :Say( nLin , 2060 , SZ9->Z9_CODTEC , oFont0 , 100 )*/
	
	nLin += 48
	oPrint :Box( nLin , 0008 , nLin + 1 , 2350 )
	nLin += 7
	
	nItens++
	
	If  !Empty(QRY1->Z9_PARTNR) .And. nTot == 0
		nTot :=   QRY1->Z9_QTY
	Else
		nTot +=   QRY1->Z9_QTY
	EndIf
	
	If nItens > 43
		oPrint :EndPage()
		oPrint :StartPage()
		fCabec()
	EndIf
	
	dbSelectArea("QRY1")
	dbSkip()
	
	//	Endif
	
EndDo

nVia ++

fRodape()
oPrint :EndPage()


QRY->(dbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRodape   บ Autor ณPaulo Francisco     บ Data ณ  18/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRODAPE DE IMPRESSAO                                         บฑฑ
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
Static Function fRodape()

oPrint:Box( 2900 , 0008 , 2903 , 2350 )

oPrint:Box( 2903 , 0008 , 2980 , 0600 ) //Peso Bruto
oPrint:Box( 2903 , 0600 , 2980 , 1600 ) //Embalagens
oPrint:Box( 2903 , 1600 , 2980 , 2350 ) //Valor Total

oPrint:Box( 3170 , 0008 , 3310 , 1198 ) //Data da Conferencia
oPrint:Box( 3170 , 1198 , 3310 , 2350 ) //Visto do Conferente


oPrint:Say( 2920 , 0020 , "Quantidade Pe็as: " + Transform(StrZero(nTot,2),"@E 999")                    				,oFont0, 100 )
oPrint:Say( 2920 , 0610 , "Qtde. Equipamento: 01 "                                                          				,oFont0, 100 )
oPrint:Say( 2920 , 1610 , "Descri็ใo Produto: " + QRY->PRODUT	 														,oFont0, 100 )

oPrint:Say( 3180 , 0020 , "Data da Conferencia: "                                                                   	,oFont0, 100 )
oPrint:Say( 3220 , 0600 , "          /                     /"                                                       	,oFont0, 100 )
oPrint:Say( 3180 , 1210 , "Visto do Conferente: "                                                                  		,oFont0, 100 )
oPrint:Box( 3285 , 1218 , 3286 , 2358 )

oPrint:Say( 3320 , 0005 , "Data : " + DtoC(dDataBase) + "    Hora : " + Time() 				 						, oFont0  , 100 )
oPrint:Say( 3320 , 2175 , "Via Nบ. : " + StrZero(nVia,2)                                                               , oFont0  , 100 )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCabec    บ Autor ณPaulo Francisco     บ Data ณ  18/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCABECALHO DE IMPRESSAO                                      บฑฑ
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
Static Function fCabec()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Cabecalho                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint :Box( 0200 , 0008 , 3310 , 2350 ) //Itens

oPrint :Box( 0012 , 0008 , 0200 , 2100 ) //Produto
oPrint :Box( 0012 , 2100 , 0200 , 2350 ) //Ordem

oPrint :Box( 0200 , 0008 , 0260 , 0600 ) //IMEI

oPrint :Box( 0260 , 0008 , 0320 , 0600 ) //Carcaca

oPrint :Box( 0320 , 0008 , 0380 , 0600 ) //Transaction

oPrint :Box( 0380 , 0008 , 0440 , 1150 ) //Operacao
oPrint :Box( 0380 , 1150 , 0440 , 2350 ) //Observacoes

oPrint :Say( 0075 , 0033 , " Produto: " , oFont3 , 100 )
oPrint :Say( 0075 , 2125 , AllTrim(QRY->COD) , oFont2 , 100 )
oPrint :Say( 0210 , 0033 , "Ordem: " + AllTrim(QRY->ORDSERV) , oFont0 , 100 )
oPrint :Say( 0270 , 0033 , "IMEI: " + Alltrim(QRY->IMEI), oFont0 , 100 )
oPrint :Say( 0330 , 0033 , "Carca็a: " + AllTrim(QRY->CARCAC) , oFont0 , 100 )
oPrint:Say( 0390 , 0033 , "Transaction: " + AllTrim(QRY->TRANSC) , oFont0  , 100 )
oPrint:Say( 0390 , 1180 , "Opera็ใo: " + Alltrim(QRY->OPERAC) , oFont0  , 100 )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial() + QRY->CODCLI + QRY->LOJA)

cNomCli := SA1->A1_COD + "-" + SA1->A1_LOJA + " / "  + Rtrim(SA1->A1_NOME)+ "   " + "Telefone : " + SA1->A1_TEL + " Fax : " + SA1->A1_FAX
cEndCli := Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - CEP:"+Transform(SA1->A1_CEP,"99999-999")+" - "+Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_EST)
cEntCli := Alltrim(SA1->A1_ENDENT)

oPrint :Say( 0210 , 0610 , "Cliente: " + cNomCli , oFont0 , 100 )
oPrint :Say( 0270 , 0610 , "End.: " + cEndCli , oFont0 , 100 )
oPrint :Say( 0330 , 0610 , "End. Entrega: " + cEntCli , oFont0 , 100 )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Montagem do Layout de Impressao (Detalhe)                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint :Box( 0440 , 0008 , 0443 , 2350 )

oPrint :Box( 0443 , 0008 , 0503 , 0410 ) //Cod. Prod.
oPrint :Box( 0506 , 0008 , 2900 , 0410 )
oPrint :Box( 0443 , 0410 , 0503 , 1065 ) //Desc. Prod.
oPrint :Box( 0506 , 0410 , 2900 , 1065 )
oPrint :Box( 0443 , 1065 , 0503 , 1180 ) //U.M.
oPrint :Box( 0506 , 1065 , 2900 , 1180 )
oPrint :Box( 0443 , 1180 , 0503 , 1440 ) //Qtde.
oPrint :Box( 0506 , 1180 , 2900 , 1440 )
oPrint :Box( 0443 , 1440 , 0503 , 1740 ) //Qtde. Entregue
oPrint :Box( 0506 , 1440 , 2900 , 1740 )
oPrint :Box( 0446 , 1740 , 0503 , 2040 ) //Val. Unit.
oPrint :Box( 0506 , 1740 , 2900 , 2040 )
oPrint :Box( 0443 , 2040 , 0503 , 2350 ) //Total do Item
oPrint :Box( 0506 , 2040 , 2900 , 2350 )

oPrint :Say( 0453 , 0018 , "CำDIGO DO PRODUTO"    , oFont0 , 100 )
oPrint :Say( 0453 , 0420 , "DESCRIวรO DO PRODUTO" , oFont0 , 100 )
oPrint :Say( 0453 , 1075 , "U.M"                  , oFont0 , 100 )
oPrint :Say( 0453 , 1190 , "QUANTIDADE"                , oFont0 , 100 )
oPrint :Say( 0453 , 1450 , "SEQUสNCIA"       , oFont0 , 100 )
oPrint :Say( 0453 , 1750 , "ARMAZษM"       , oFont0 , 100 )
oPrint :Say( 0453 , 2050 , "TษCNICO"          , oFont0 , 100 )

nLin := 512
Return()