#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RELENDES³ Autor ³ Luciano Siqueira      ³ Data ³ 19/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Master e endereço no estoque                   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELENDES()
Local oReport
Private cPerg    := "RENDES"

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	ValPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

u_GerA0003(ProcName())

oReport := TReport():New("RELENDES","Consulta Saldo por Endereço","RENDES",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao das Masters conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,OemToAnsi("Consulta Master por Endereço"),{"TRB"})

TRCell():New(oSection1,"ZZ4_CODCLI","TRB","Cliente","@!",06)
TRCell():New(oSection1,"ZZ4_LOJA","TRB","Loja","@!",02)
TRCell():New(oSection1,"DTENT","TRB","Dt Entrada","@!",10)
TRCell():New(oSection1,"ZZ4_NFENR","TRB","NF Entrada","@!",09)
TRCell():New(oSection1,"ZZ4_NFESER","TRB","Serie Entrada","@!",03)
TRCell():New(oSection1,"ZZ4_CODPRO","TRB","Modelo","@!",15)
TRCell():New(oSection1,"ZZ4_LOCAL","TRB","Armazem","@!",02)
TRCell():New(oSection1,"ZZ4_ETQMEM","TRB","Master","@!",20)
TRCell():New(oSection1,"QTDREG","TRB","Qtde Cx","@E 99,999,999.99",20)
TRCell():New(oSection1,"ZZ4_ENDES","TRB","Endereço","@!",20)
TRCell():New(oSection1,"ZZ4_FIFO","TRB","Lote","@!",06)
TRCell():New(oSection1,"DIAEST","TRB","Dias no Estoque","@E 9999999999",10)
TRCell():New(oSection1,"REFGAR","TRB","Status","@!",20)
TRCell():New(oSection1,"ZZ4_DOCSEP","TRB","Doc Sep","@!",20)  
TRCell():New(oSection1,"ZZ4_NFSDT","TRB","Dt Saida","@!",10)
TRCell():New(oSection1,"ZZ4_NFSNR","TRB","NF Saida","@!",09)
TRCell():New(oSection1,"ZZ4_NFSSER","TRB","Serie Saida","@!",03)
TRCell():New(oSection1,"MOTIVO","TRB","Motivo","@!",30)


oSection2 := TRSection():New(oReport,"Detalhes da Master",{"TRB1"})

TRCell():New(oSection2,"ZZ4_CODPRO","TRB1","Modelo","@!",15)
TRCell():New(oSection2,"ZZ4_ETQMEM","TRB1","Master","@!",20)
TRCell():New(oSection2,"ZZ4_IMEI","TRB1","Imei","@!",TamSX3("ZZ4_IMEI")[1])
TRCell():New(oSection2,"ZZ4_CARCAC","TRB1","Carcaça","@!",20)
TRCell():New(oSection2,"ZZ4_OS","TRB1","Num OS","@!",10)
TRCell():New(oSection2,"ZZ4_ENDES","TRB1","Endereço","@!",20)
TRCell():New(oSection2,"ZZ4_NFEDT","TRB1","Dt Entrada","@!",10)

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
//Local oSection2 := oReport:Section(1):Section(1)
Local oSection2 := oReport:Section(2)

// Selecao dos dados a Serem Impressos
MsAguarde({|| fSelMaster()},"Selecionando Master")


dbSelectArea("TRB")
dbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()

Do While TRB->(!Eof())
	If oReport:Cancel()
		Exit
	EndIf
	
	_cOperacao := ""
	_nDiaEst   := 0 
	
	If TRB->ZZO_REFGAR = '1'
		_cOperacao := "REFURBISH GARANTIA"
	ElseIf TRB->ZZO_REFGAR = '2'
		_cOperacao := "FORA DE GARANTIA"
	ElseIf TRB->ZZO_REFGAR = '3'
		_cOperacao := "REPARO GARANTIA"
	ElseIf TRB->ZZO_REFGAR = '4'
		_cOperacao := "BOUNCE"
	ElseIf TRB->ZZO_REFGAR = '5'
		_cOperacao := "PRATA"
	Endif
	
	If Empty(TRB->ZZ4_DOCSEP)
		_nDiaEst := dDataBase-TRB->DTENT
	Endif
	
	_cMotivo := AllTrim(Posicione("SX5", 1, xFilial("SX5")+'WG'+TRB->ZZO_MOTIVO, "X5_DESCRI"))    
	
	oSection1:Cell("REFGAR"):SetBlock( { ||_cOperacao})
	oSection1:Cell("DIAEST"):SetBlock( { ||_nDiaEst})
	oSection1:Cell("MOTIVO"):SetBlock( { ||_cMotivo})
	
	oSection1:PrintLine()
	
	dbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

//Inicia uma nova pagina
oReport:EndPage()
oReport:StartPage()

If MV_PAR09 == 2
	MsAguarde({|| fSelImei()},"Selecionando Imei's")
	oSection2:Init()
	oReport:SkipLine(03)
	oReport:PrintText(" D E T A L H E S  M A S T E R ")
	dbSelectArea("TRB1")
	dbGotop()
	Do While TRB1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		oSection2:PrintLine()
		dbSelectArea("TRB1")
		DbSkip()
		oReport:IncMeter()
	EndDo
	oSection2:Finish()  
	If Select("TRB1") > 0
		dbSelectArea("TRB1")
		DbCloseArea()
	EndIf
Endif


If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

Return

Static Function fSelMaster()

_cQuery := " SELECT "
_cQuery += " 	ZZ4_CODCLI,ZZ4_LOJA,MAX(ZZ4_NFEDT) AS DTENT,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO, "
_cQuery += " 	ZZ4_LOCAL,ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZO_REFGAR,COUNT(*) AS QTDREG, "
_cQuery += " 	ZZ4_DOCSEP,ZZ4_NFSDT,ZZ4_NFSNR,ZZ4_NFSSER,ZZO_MOTIVO "
_cQuery += " FROM "+RetSQLName("ZZ4")+" ZZ4 "
_cQuery += " INNER JOIN "+RetSQLName("ZZO")+" ZZO ON "
_cQuery += " 	ZZO_FILIAL='"+xFilial("ZZO")+"' "
_cQuery += "	AND ZZO_STATUS = '2' "
_cQuery += "	AND ZZ4_IMEI=ZZO_IMEI "
_cQuery += "	AND ZZ4_CARCAC=ZZO_CARCAC "
_cQuery += "	AND ZZ4_ETQMEM=ZZO_NUMCX "
If MV_PAR10 == 1
	//_cQuery += "	AND ZZ4_DOCSEP='' "
	_cQuery += "	AND ZZ4_STATUS='3' "
Endif
_cQuery += "	AND ZZO.D_E_L_E_T_ ='' "
_cQuery += " WHERE "
_cQuery += " ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
_cQuery += " AND ZZ4_CODPRO BETWEEN '"+MV_PAR01+"'    AND '"+MV_PAR02+"' "
_cQuery += " AND ZZ4_LOCAL BETWEEN '"+MV_PAR03+"'    AND '"+MV_PAR04+"' "
_cQuery += " AND ZZ4_ETQMEM BETWEEN '"+MV_PAR05+"'    AND '"+MV_PAR06+"' "
_cQuery += " AND ZZ4_ENDES BETWEEN '"+MV_PAR07+"'    AND '"+MV_PAR08+"' "
_cQuery += " AND ZZ4_ETQMEM <> '' "
_cQuery += " AND ZZ4_ENDES <> '' "
_cQuery += " AND ZZ4.D_E_L_E_T_=' ' "
_cQuery += " GROUP BY "
_cQuery += " 	ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO, "
_cQuery += " 	ZZ4_LOCAL,ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZO_REFGAR, "
_cQuery += "	ZZ4_DOCSEP,ZZ4_NFSDT,ZZ4_NFSNR,ZZ4_NFSSER,ZZO_MOTIVO "
_cQuery += " ORDER BY "
_cQuery += " 	ZZ4_CODPRO,MAX(ZZ4_NFEDT),ZZ4_ETQMEM,ZZ4_ENDES,ZZO_REFGAR "

//* Verifica se a Query Existe, se existir fecha
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)
TcSetField("TRB","DTENT","D",10,0)

Return

Static Function fSelImei()

_cQuery := " SELECT "
_cQuery += " 	ZZ4_CODPRO, ZZ4_ETQMEM,ZZ4_IMEI,ZZ4_CARCAC,ZZ4_OS,ZZ4_ENDES,ZZ4_NFEDT "
_cQuery += " FROM "+RetSQLName("ZZ4")+" ZZ4 "
_cQuery += " INNER JOIN "+RetSQLName("ZZO")+" ZZO ON "
_cQuery += " 	ZZO_FILIAL='"+xFilial("ZZO")+"' "
_cQuery += "	AND ZZO_STATUS = '2' "
_cQuery += "	AND ZZ4_IMEI=ZZO_IMEI "
_cQuery += "	AND ZZ4_CARCAC=ZZO_CARCAC "
_cQuery += "	AND ZZ4_ETQMEM=ZZO_NUMCX "
If MV_PAR10 == 1
	//_cQuery += "	AND ZZ4_DOCSEP='' "
	_cQuery += "	AND ZZ4_STATUS='3' "
Endif
_cQuery += "	AND ZZO.D_E_L_E_T_ ='' "
_cQuery += " WHERE "
_cQuery += " ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
_cQuery += " AND ZZ4_CODPRO BETWEEN '"+MV_PAR01+"'    AND '"+MV_PAR02+"' "
_cQuery += " AND ZZ4_LOCAL BETWEEN '"+MV_PAR03+"'    AND '"+MV_PAR04+"' "
_cQuery += " AND ZZ4_ETQMEM BETWEEN '"+MV_PAR05+"'    AND '"+MV_PAR06+"' "
_cQuery += " AND ZZ4_ENDES BETWEEN '"+MV_PAR07+"'    AND '"+MV_PAR08+"' "
_cQuery += " AND ZZ4_ENDES <> '' "
_cQuery += " AND ZZ4_ETQMEM <> '' "
_cQuery += " AND ZZ4.D_E_L_E_T_=' ' "
_cQuery += " ORDER BY "
_cQuery += " 	ZZ4_CODPRO, ZZ4_ETQMEM,ZZ4_IMEI,ZZ4_CARCAC,ZZ4_OS "

//* Verifica se a Query Existe, se existir fecha
If Select("TRB1") > 0
	dbSelectArea("TRB1")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB1",.F.,.T.)
TcSetField("TRB1","ZZ4_NFEDT","D",10,0)

Return


Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Modelo de              ?','' ,'' , 'mv_ch1', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Modelo Ate             ?','' ,'' , 'mv_ch2', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Armazem de             ?','' ,'' , 'mv_ch3', 'C', 02, 0,0, 'G', '', '', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Armazem Ate            ?','' ,'' , 'mv_ch4', 'C', 02, 0,0, 'G', '', '', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Master de              ?','' ,'' , 'mv_ch5', 'C', 20, 0, 0, 'G', '', '' , '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Master Ate             ?','' ,'' , 'mv_ch6', 'C', 20, 0, 0, 'G', '', '' , '', '', 'mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Endereco de            ?','' ,'' , 'mv_ch7', 'C', 20, 0,0, 'G', '', '', '', '', 'mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Endereco Ate           ?','' ,'' , 'mv_ch8', 'C', 20, 0,0, 'G', '', '', '', '', 'mv_par08',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '09', 'Lista Imei             ?','' ,'' , 'mv_ch9', 'N', 01, 0,01,'C', '',   '' , '', '', 'mv_par09',"Nao"," "," ","","Sim","","","","","","","","")
PutSx1(cPerg, '10', 'Master em Estoque      ?','' ,'' , 'mv_cha', 'N', 01, 0,01,'C', '',   '' , '', '', 'mv_par10',"Sim"," "," ","","Todos","","","","","","","","")

Return
