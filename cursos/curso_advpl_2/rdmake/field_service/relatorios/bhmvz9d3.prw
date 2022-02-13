#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BHMVZ9D3³ Autor ³ Luciano Siqueira      ³ Data ³ 31/07/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Movimentação de Peças Z9 x D3                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BHMVZ9D3()

Local oReport

Private  _nTamB1 := TamSX3("B1_COD")[1]
Private _cQuebra := " "

u_GerA0003(ProcName())

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Luciano Siqueira      ³ Data ³ 31/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "MVZ9D3"

ValPerg(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New("BHMVZ9D3","Movimentação de Peças Z9 x D3",cPerg,{|oReport| PrintReport(oReport)},"Movimentação de Peças Z9 x D3 Referente ao Periodo Selcionado")

oSection1 := TRSection():New(oReport,OemToAnsi("Movimentação de Peças Z9 x D3"),{"TRB"})

Return oReport

// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)

TRCell():New(oSection1,"DTAPONT","TRB","Data Apontamento","@!",10)
TRCell():New(oSection1,"HRAPONT","TRB","Hora Apontamento","@!",10)
TRCell():New(oSection1,"USAPONT","TRB","Usuario","@!",30)
TRCell():New(oSection1,"NUMOS","TRB","Numero OS","@!",06)
TRCell():New(oSection1,"SEQ","TRB","Sequencia","@!",02)
TRCell():New(oSection1,"IMEI","TRB","IMEI","@!",TamSX3("ZZ4_IMEI")[1])
TRCell():New(oSection1,"CODANA","TRB","Codigo Analista","@!",05)
TRCell():New(oSection1,"OPEBGH","TRB","Operação BGH","@!",05)
TRCell():New(oSection1,"MODELO","TRB","MODELO","@!",25)
TRCell():New(oSection1,"DESMOD","TRB","Descrição","@!",40)
TRCell():New(oSection1,"PARTNR","TRB","Peça ","@!",25)    
TRCell():New(oSection1,"DESPART","TRB","Descrição","@!",40)
TRCell():New(oSection1,"QUANT","TRB","Qtde","@E 99,999,999.99",20)
TRCell():New(oSection1,"NUMSEQ","TRB","Documento","@!",30)
TRCell():New(oSection1,"ALMOX","TRB","Local","@!",05)
TRCell():New(oSection1,"ATUD3","TRB","Gerou D3","@!",05)

// Selecao dos dados a Serem Impressos
MsAguarde({|| fSelDados()},"Selecionando Itens")

// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Cell("DTAPONT"):SetBlock( { || STOD(TRB->DTAPONT) })
	oSection1:Cell("DESMOD"):SetBlock( { || Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->MODELO,"B1_DESC")) })
	oSection1:Cell("DESPART"):SetBlock( { || Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->PARTNR,"B1_DESC")) })
	oSection1:PrintLine()

	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return

// Selecao dos dados a serem impressos

Static Function fSelDados()

_cQuery := " SELECT "
_cQuery += " 	ZZ3.ZZ3_DATA DTAPONT,ZZ3.ZZ3_HORA HRAPONT,ZZ3.ZZ3_USER USAPONT,ZZ3.ZZ3_NUMOS NUMOS, "
_cQuery += " 	ZZ3.ZZ3_SEQ SEQ,ZZ3.ZZ3_IMEI IMEI,ZZ3.ZZ3_CODANA CODANA,ZZ4_OPEBGH OPEBGH, "
_cQuery += " 	ZZ4_CODPRO MODELO,Z9_QTY QUANT,Z9_PARTNR PARTNR,Z9_NUMSEQ NUMSEQ, "
_cQuery += " 	Z9_LOCAL ALMOX, "
_cQuery += " 	(CASE WHEN LEFT(D3_DOC,6)=LEFT(Z9_NUMSEQ,6) AND Z9_ATUSD3 = 'S' THEN 'SIM' ELSE 'NAO' END) AS ATUD3 "
_cQuery += " FROM "+RetSQLName("ZZ3")+" ZZ3 "
_cQuery += " INNER JOIN "+RetSQLName("SZ9")+" SZ9 ON "
_cQuery += " 	( "
_cQuery += " 		Z9_FILIAL='"+xFilial("SZ9")+"'  AND "
_cQuery += " 		Z9_NUMOS=ZZ3_NUMOS AND "
_cQuery += " 		Z9_SEQ=ZZ3_SEQ AND "
_cQuery += " 		Z9_IMEI=ZZ3_IMEI AND "
_cQuery += " 		Z9_PARTNR <> '' AND "
_cQuery += " 		SZ9.D_E_L_E_T_ = '' "
_cQuery += " 	) "
_cQuery += " INNER JOIN "+RetSQLName("ZZ4")+" ZZ4 ON "
_cQuery += " 	( "
_cQuery += " 		ZZ4_FILIAL='"+xFilial("ZZ4")+"'  AND "
_cQuery += " 		ZZ4_OS=ZZ3_NUMOS AND "
_cQuery += " 		ZZ4_IMEI=ZZ3_IMEI AND "
_cQuery += " 		ZZ4_OPEBGH IN ('N03','N02','N04','N08','N09') AND "
_cQuery += " 		ZZ4_STATUS >= '5' AND "
_cQuery += " 		ZZ4.D_E_L_E_T_ = '' "
_cQuery += " 	) "
_cQuery += " LEFT OUTER JOIN "
_cQuery += " 	( "
_cQuery += " 		SELECT "
_cQuery += " 			ZZ3_FILIAL,ZZ3_NUMOS,ZZ3_IMEI "
_cQuery += " 		FROM "+RetSQLName("ZZ3")+" ZZ32 "
_cQuery += " 		WHERE "
_cQuery += " 			ZZ3_FILIAL='"+xFilial("ZZ3")+"'  AND "
_cQuery += " 			ZZ3_DATA ='"+DTOS(MV_PAR01)+"' AND "
_cQuery += " 			ZZ3_ENCOS='S' AND "
_cQuery += " 			ZZ3_STATUS='1' AND "
_cQuery += " 			ZZ3_ESTORN<>'S' AND "
_cQuery += " 			ZZ32.D_E_L_E_T_='') AS ZZ32 "
_cQuery += " 		ON "
_cQuery += "  			ZZ3.ZZ3_FILIAL=ZZ32.ZZ3_FILIAL AND "
_cQuery += " 			ZZ3.ZZ3_IMEI=ZZ32.ZZ3_IMEI AND "
_cQuery += " 			ZZ3.ZZ3_NUMOS=ZZ32.ZZ3_NUMOS "
_cQuery += " LEFT JOIN "+RetSQLName("SD3")+" SD3 ON "
_cQuery += " 		( "
_cQuery += " 			SD3.D_E_L_E_T_='' AND "
_cQuery += " 			D3_FILIAL='"+xFilial("SD3")+"' AND "
//_cQuery += " 			D3_EMISSAO='"+DTOS(MV_PAR01)+"' AND "
_cQuery += " 			D3_TM='499' AND "
_cQuery += " 			D3_LOCAL='15' AND "
_cQuery += " 			D3_LOCALIZ='AUDITORIA' AND "
_cQuery += " 			D3_ESTORNO<>'S' AND "
_cQuery += " 			D3_COD=Z9_PARTNR AND "
_cQuery += " 			LEFT(D3_DOC,6)=LEFT(Z9_NUMSEQ,6) "
_cQuery += " 		) "
_cQuery += " WHERE  "
_cQuery += " 	ZZ3.ZZ3_FILIAL='"+xFilial("ZZ3")+"' "
_cQuery += " 	AND ZZ3_ESTORN <> 'S' "
_cQuery += " 	AND ZZ3_STATUS = '1' " 
_cQuery += " 	AND ZZ3.D_E_L_E_T_ = '' " 
_cQuery += " 	AND ZZ32.ZZ3_NUMOS IS NOT NULL "


//* Verifica se a Query Existe, se existir fecha
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)
TcSetField("TRB","QUANT","N",14,2)

Return

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'DT Encerramento     ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')

Return