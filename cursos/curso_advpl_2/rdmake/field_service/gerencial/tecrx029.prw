
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX029 บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  02/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Gerencial - TAT                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function tecrx029()

Local aSay     	:= {}
Local aButton   := {}
Local nOpc      := 0
Local cTitulo   := "Processamento dos dados para Relat๓rios Gerenciais"
Local cDesc1   	:= "Essa rotina serแ utilizada para processar os dados de atendimentos e gerar tabela"
Local cDesc2   	:= "com dados especํficos para a gera็ใo de grแficos atrav้s do Crystal."
Local cDesc3   	:= "Dados calculados: tempos de reparo, laboratorio, entrada doca e expedicao."
Local cDesc4   	:= "Especํfico BGH do Brasil"

Private _nSL1   := 0 //getmv("MV_XSEMSL1") // Dias ๚teis do SLA da Sony/Ericsson - MRC	4
Private _nSL2   := 0 //getmv("MV_XSEMSL2") // Dias ๚teis da segunda faixa do SLA da Sony/Ericsson - MRC	8
Private _nSL3   := 0 //getmv("MV_XSEMSL3") // Dias ๚teis da terceira faixa do SLA da Sony/Ericsson - MRC	30
Private _nTM1   := 0 //getmv("MV_XSEMTM1") // Meta 1 do TAT da Sony/Ericsson - MRC	90
Private _nTM2   := 0 //getmv("MV_XSEMTM2") // Meta 2 do TAT da Sony/Ericsson - MRC	100
Private _cDivis   := ""
Private _lGeraCrys:= .t.
private _Enter    := chr(13) + chr(10)
private _cFilLoc  := ""
private _cLabor   := "" //alltrim(str(mv_par01))
private _cDescLab := "" //iif(mv_par01==1,"Sony","Nextel")
private _csrvapl  :=ALLTRIM(GetMV("MV_SERVAPL"))

Private cPerg   := "TECX29"

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Cria dicionario de perguntas  - Alterado Paulo Francisco - 18/05/10  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)     
	Return
Endif

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

//Botoes
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)			}} ) //Botใo de parโmetros
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()		}} ) //Botใo Ok
aAdd( aButton, { 2, .T., {|| FechaBatch()					}} ) //Botใo Cancel

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
EndIf

_cLabor   := alltrim(str(mv_par01))
_cDescLab := iif(mv_par01==1,"Sony","Nextel")
if mv_par02 == 1     // Almoxarifados MRC 
	_cFilLoc := " AND '"+getmv("MV_XSEMLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' " 
	_cDivis  := "MRC"
	_nSL1    := getmv("MV_XSEMSL1")
	_nSL2    := getmv("MV_XSEMSL2")
	_nSL3    := getmv("MV_XSEMSL3")
	_nTM1    := getmv("MV_XSEMTM1")
	_nTM2    := getmv("MV_XSEMTM2")
elseif mv_par02 == 2 // Almoxarifados DOA
	_cFilLoc := " AND '"+getmv("MV_XSEDLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' "
	_cDivis  := "DOA"
	_nSL1    := getmv("MV_XSEDSL1")
	_nSL2    := getmv("MV_XSEDSL2")
	_nSL3    := getmv("MV_XSEDSL3")
	_nTM1    := getmv("MV_XSEDTM1")
	_nTM2    := getmv("MV_XSEDTM2")
elseif mv_par02 == 3 // Almoxarifados NEXTEL
	_cFilLoc := " AND '"+getmv("MV_XNEXLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' "
	_cDivis  := "NEX"
	_nSL1    := getmv("MV_XNEXSL1")
	_nSL2    := getmv("MV_XNEXSL2")
	_nSL3    := getmv("MV_XNEXSL3")
	_nTM1    := getmv("MV_XNEXTM1")
	_nTM2    := getmv("MV_XNEXTM2")
endif

// Efetua processamento dos atendimentos dentro do periodo das semanas informadas, mesmo que eles ja tenham sido processados anteriormente
if mv_par05 == 1 
	Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Calculando atendimentos da semana....", .T. )
endif

// Chama o relatorio de graficos do CRYSTAL
if _lGeraCrys

	// Cria arquivo com os atendimentos analiticos
	CriaXls()

	_cParams  := alltrim(str(_nSL1))+";"+;
	             alltrim(str(_nSL2))+";"+;
	             alltrim(str(_nSL3))+";"+;
	             alltrim(str(_nTM1))+";"+;
	             alltrim(str(_nTM2))+";"+;
	             MV_PAR03+";"+;
	             MV_PAR04+";"+;
	             _cDivis+";"+;
	             xFilial("ZZ4")
	_cOptions := "1;0;1;Relat๓rios Gerenciais SONY"
	CallCrys("mrc_tat",_cParams,_cOptions)
endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX029 บAutor  ณMicrosiga           บ Data ณ  05/19/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

// Chama funcao da regua - 1 item para cada processo do programa
ProcRegua(9)

if mv_par01 == 1 .and. mv_par02 == 3 .or. ;
   mv_par01 == 2 .and. mv_par02 <> 3
   apMsgStop("Caro usuแrio, o laborat๓rio Sony/Ericsson possui as divis๕es MRC ou DOA e o laborat๓rio Nextel possui apenas a divisใo Nextel. Por favor selecione outro laborat๓rio ou divisใo.","Laborat๓rio x Divisใo invแlido!")
   _lGeraCrys:=.f.
   return
endif

if mv_par02 == 1     // Almoxarifados MRC 
	_cFilLoc := " AND '"+getmv("MV_XSEMLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' " 
	_cDivis  := "MRC"
elseif mv_par02 == 2 // Almoxarifados DOA
	_cFilLoc := " AND '"+getmv("MV_XSEDLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' "
	_cDivis  := "DOA"
elseif mv_par02 == 3 // Almoxarifados NEXTEL
	_cFilLoc := " AND '"+getmv("MV_XNEXLOC")+"' LIKE '%'+ZZ4_LOCAL+'%' "
	_cDivis  := "NEX"
endif

// Cria tabela gerencial caso nao exista
CriaTab()

// Limpa registros da semana processada na tabela GERSETAT 
LimpaGer()

// Cria registros da semana processada na tabela GERSETAT 
ProcGer()

// Cria registros de SWAP da semana processada na tabela GERSETAT 
ProcSwap()

// Atualiza calculo do Tempo de Reparo (SAIDADOCA - ENTRDOCA)
CalcRep()

// Atualiza calculo do Tempo de Laboratorio (ENTRCHAM [ZZ4_ATPRI] - ENTRADA [D1_DTDIGIT])
CalcLab()

// Atualiza calculo do Tempo de Entrada na Doca (ENTRCHAM [ZZ4_ATPRI] - ENTRADA [D1_DTDIGIT])
CalcDoca()

// Atualiza calculo do Tempo de Expedicao (SAIDADOCA [ZZ4_DOCDTS] - DTENCCHA [ZZ4_ATULT])
CalcExped()

// Atualiza calculo do Tempo de Entrada na Doca (ENTRDOCA - ENTRADA)
CalcReceb()

apMsgInfo("Fim do processamento.")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaTab  บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  02/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria tabela gerencial caso nao exista                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaTab()

local _cCreate := ""

_cCreate += " if not exists (select * from sysobjects where type = 'U' and name = 'GERSETAT')"
_cCreate += " CREATE TABLE [dbo].[GERSETAT]("
_cCreate += " 	[FILIAL] [varchar](2) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[LAB] [varchar](1) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[DIV] [varchar](3) COLLATE Latin1_General_BIN NOT NULL,"
//_cCreate += " 	[IMEI] [varchar](20) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[IMEI] [varchar](25) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[PRODUTO] [varchar](15) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[NFE] [varchar](6) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[EMISENT] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[ENTRDOCA] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[SAIDADOCA] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[ENTRADA] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[CLIENTE] [varchar](6) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[NOMEENT] [varchar](30) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[ESTADO] [varchar](2) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[NFBGH] [varchar](6) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[EMISSAI] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[ENTRCHAM] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[DTENCCHA] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[FASE] [varchar](6) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[DESCFASE] [varchar](30) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[STATUSOS] [varchar](9) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[NOVOSN] [varchar](20) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[SEMANA] [varchar](5) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[SEMAINI] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[SEMAFIM] [varchar](8) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[ZZ4_LOCAL] [varchar](2) COLLATE Latin1_General_BIN NOT NULL,"
_cCreate += " 	[TREPARO] [float] NOT NULL,"
_cCreate += " 	[SLA1] [int] NOT NULL,"
_cCreate += " 	[SLA2] [int] NOT NULL,"
_cCreate += " 	[SLA3] [int] NOT NULL,"
_cCreate += " 	[SLA4] [int] NOT NULL,"
_cCreate += " 	[TLAB] [float] NOT NULL,"
_cCreate += " 	[TENTDOC] [float] NOT NULL,"
_cCreate += " 	[TEXPED] [float] NOT NULL,"
_cCreate += " 	[META1] [float] NOT NULL,"
_cCreate += " 	[META2] [float] NOT NULL,"
_cCreate += " 	[TRECEB] [float] NOT NULL"
_cCreate += " ) ON [PRIMARY]"
tcSqlExec(_cCreate)

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ExecSQL(_cExecSQL, _cIdQry)

//memowrite('tecrx029_'+_cIdQry+'.sql',_cExecSQL)
_cExecSQL := strtran(_cExecSQL,_Enter,"")
tcSqlExec(_cExecSQL)

// Incrementa regua do processo 
incproc()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa registros da semana processada na tabela GERSETAT    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function LimpaGer()

local _cDelete := ""

_cDelete += _Enter + " DELETE FROM GERSETAT WHERE LAB = '"+_cLabor+"' AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "+ _cFilLoc 
ExecSQL(_cDelete, "delete")       
TCRefresh("GERSETAT")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ProcGer()

local _cInsert := ""

_cInsert += _Enter + " INSERT  GERSETAT "
_cInsert += _Enter + " SELECT  ZZ4_FILIAL 'FILIAL',  "
_cInsert += _Enter + "         LAB = '"+_cLabor+"',  " 
_cInsert += _Enter + "         DIV = '"+_cDivis+"',  " 
_cInsert += _Enter + "         ZZ4_IMEI   'IMEI',  " 
_cInsert += _Enter + "         ZZ4_CODPRO 'PRODUTO',  " 
_cInsert += _Enter + "         ZZ4_NFENR  'NFE',  " 
_cInsert += _Enter + "         ZZ4_NFEDT  'EMISENT',  " 
_cInsert += _Enter + "         ZZ4_DOCDTE 'ENTRDOCA',  " 
_cInsert += _Enter + "         ZZ4_DOCDTS 'SAIDADOCA',  " 
_cInsert += _Enter + "         ZZ4_NFEDT  'ENTRADA',  " 
_cInsert += _Enter + "         ZZ4_CODCLI 'CLIENTE',  " 
_cInsert += _Enter + "         A1E.A1_NREDUZ 'NOMEENT',  " 
_cInsert += _Enter + "         A1E.A1_EST 'ESTADO',  " 
_cInsert += _Enter + "         ZZ4_NFSNR  'NFBGH',  " 
_cInsert += _Enter + "         ZZ4_NFSDT  'EMISSAI',  " 
_cInsert += _Enter + "         LEFT(ZZ4_ATPRI,8) 'ENTRCHAM',  " 
_cInsert += _Enter + "         LEFT(ZZ4_ATULT,8) 'DTENCCHA',  " 
_cInsert += _Enter + "         ZZ4_FASATU 'FASE',  " 
_cInsert += _Enter + "         SPACE(30)  'DESCFASE',  " 
_cInsert += _Enter + "         STATUSOS   = CASE WHEN ZZ4_STATUS > '4' THEN 'Encerrado' ELSE 'Aberto' END,   " 
_cInsert += _Enter + "         ZZ4_SWAP   'NOVOSN',  " 
_cInsert += _Enter + "         ZZ5_ANOSEM 'SEMANA',  " 
_cInsert += _Enter + "         ZZ5_DTINI  'SEMAINI', ZZ5_DTFIM 'SEMAFIM', "
_cInsert += _Enter + "         ZZ4_LOCAL, " 
_cInsert += _Enter + "         0, 0, 0, 0, 0, 0, 0, 0, "+str(_nTM1/100)+", "+str(_nTM2/100) + ", 0"
_cInsert += _Enter + "  FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) " 
_cInsert += _Enter + "  JOIN   "+RetSqlName("SA1")+" AS A1E (NOLOCK) " 
_cInsert += _Enter + "  ON     A1E.A1_FILIAL = '  ' AND A1E.A1_COD = ZZ4_CODCLI AND A1E.A1_LOJA = ZZ4_LOJA AND A1E.D_E_L_E_T_ = '' " 
_cInsert += _Enter + "  JOIN   "+RetSqlName("ZZ5")+" AS ZZ5 (NOLOCK) " 
_cInsert += _Enter + "  ON     ZZ5.D_E_L_E_T_ = '' AND ZZ5_FILIAL = '  ' AND ZZ5_LAB = '"+_cLabor+"' " 
_cInsert += _Enter + "         AND ZZ5_ANOSEM BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cInsert += _Enter + "         AND ZZ4_DOCDTS BETWEEN ZZ5_DTINI AND ZZ5_DTFIM " 
_cInsert += _Enter + "  WHERE  ZZ4.D_E_L_E_T_ = '' " 
_cInsert += _Enter + "         AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " 
_cInsert += _Enter + "         AND ZZ4_STATUS > '4' " 
_cInsert += _Enter + "         AND ZZ4_SWAP   = '' " 
_cInsert += _Enter + _cFilLoc
ExecSQL(_cInsert, "insert")
TCRefresh("GERSETAT")
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ProcSwap()

local _cSwap := ""

_cSwap +=  _Enter + " INSERT GERSETAT "
_cSwap +=  _Enter + " SELECT ZZ4_FILIAL 'FILIAL',  "
_cSwap +=  _Enter + "        LAB = '"+_cLabor+"',  " 
_cSwap +=  _Enter + "        DIV = '"+_cDivis+"',  " 
_cSwap +=  _Enter + "        ZZ4_IMEI   'IMEI',   " 
_cSwap +=  _Enter + "        ZZ4_CODPRO 'PRODUTO',   " 
_cSwap +=  _Enter + "        ZZ4_NFENR  'NFE',   " 
_cSwap +=  _Enter + "        ZZ4_NFEDT  'EMISENT',   " 
_cSwap +=  _Enter + "        ZZ4_DOCDTE 'ENTRDOCA',   " 
_cSwap +=  _Enter + "        SAIDADOCA = CASE WHEN ZZ4_SWSADC <> '' THEN ZZ4_SWSADC WHEN ZZ4_DOCDTS <> '' THEN ZZ4_DOCDTS ELSE '' END, " 
_cSwap +=  _Enter + "        ZZ4_NFEDT  'ENTRADA',   " 
_cSwap +=  _Enter + "        ZZ4_CODCLI 'CLIENTE',   " 
_cSwap +=  _Enter + "        A1E.A1_NREDUZ 'NOMEENT',   " 
_cSwap +=  _Enter + "        A1E.A1_EST 'ESTADO',   " 
_cSwap +=  _Enter + "        ZZ4_SWNFNR 'NFBGH',   " 
_cSwap +=  _Enter + "        ZZ4_SWNFDT 'EMISSAI',   " 
_cSwap +=  _Enter + "        LEFT(ZZ4_ATPRI,8) 'ENTRCHAM',   " 
_cSwap +=  _Enter + "        LEFT(ZZ4_ATULT,8) 'DTENCCHA',   " 
_cSwap +=  _Enter + "        ZZ4_FASATU 'FASE',   " 
_cSwap +=  _Enter + "        SPACE(30)  'DESCFASE',   " 
_cSwap +=  _Enter + "        STATUSOS   = CASE WHEN ZZ4_STATUS > '4' THEN 'Encerrado' ELSE 'Aberto' END,    " 
_cSwap +=  _Enter + "        ZZ4_SWAP   'NOVOSN',   " 
_cSwap +=  _Enter + "        ZZ5_ANOSEM 'SEMANA',   " 
_cSwap +=  _Enter + "        ZZ5_DTINI  'SEMAINI', ZZ5_DTFIM 'SEMAFIM',  " 
_cSwap +=  _Enter + "        ZZ4_LOCAL,  " 
_cSwap +=  _Enter + "        0, 0, 0, 0, 0, 0, 0, 0, "+str(_nTM1/100)+", "+str(_nTM2/100) + ", 0"
_cSwap +=  _Enter + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) " 
_cSwap +=  _Enter + " JOIN   "+RetSqlName("SA1")+" AS A1E (NOLOCK) " 
_cSwap +=  _Enter + " ON     A1E.A1_FILIAL = '"+xFilial("SA1")+"' AND A1E.A1_COD = ZZ4_CODCLI AND A1E.A1_LOJA = ZZ4_LOJA AND A1E.D_E_L_E_T_ = ''  " 
_cSwap +=  _Enter + " JOIN   "+RetSqlName("ZZ5")+" AS ZZ5 (NOLOCK) " 
_cSwap +=  _Enter + " ON     ZZ5.D_E_L_E_T_ = '' AND ZZ5_FILIAL = '"+xFilial("ZZ5")+"' AND ZZ5_LAB = '"+_cLabor+"' " 
_cSwap +=  _Enter + "        AND ZZ5_ANOSEM BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cSwap +=  _Enter + "        AND ZZ4_DOCDTS BETWEEN ZZ5_DTINI AND ZZ5_DTFIM " 
_cSwap +=  _Enter + " WHERE  ZZ4.D_E_L_E_T_ = ''  " 
_cSwap +=  _Enter + "        AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " 
_cSwap +=  _Enter + "        AND ZZ4_STATUS > '4' " 
_cSwap +=  _Enter + "        AND ZZ4_SWAP  <> '' " 
_cSwap +=  _Enter + _cFilLoc

ExecSQL(_cSwap, "insertswap")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CalcRep()

local _cReparo := " " 

_cReparo += _Enter + " UPDATE GERSETAT "
_cReparo += _Enter + " SET    TREPARO = CASE WHEN CALC.TREPARO < 0 THEN 0 ELSE CALC.TREPARO END , "
_cReparo += _Enter + "        SLA1 = CASE WHEN CALC.TREPARO <= "+str(_nSL1)+" THEN 1 ELSE 0 END, "
_cReparo += _Enter + "        SLA2 = CASE WHEN CALC.TREPARO BETWEEN "+str(_nSL1+1)+" AND "+str(_nSL2)+" THEN 1 ELSE 0 END, "
_cReparo += _Enter + "        SLA3 = CASE WHEN CALC.TREPARO BETWEEN "+str(_nSL2+1)+" AND "+str(_nSL3)+" THEN 1 ELSE 0 END, "
_cReparo += _Enter + "        SLA4 = CASE WHEN CALC.TREPARO > "+str(_nSL3)+" THEN 1 ELSE 0 END"
_cReparo += _Enter + " FROM   GERSETAT AS TAT1 "
_cReparo += _Enter + " JOIN   ("
_cReparo += _Enter + " 	SELECT LAB, DIV, IMEI, SEMANA, NFE, SUM(TREP.ZZ6_UTIL) - 1 TREPARO"
_cReparo += _Enter + " 	FROM   GERSETAT AS TAT (NOLOCK)"
_cReparo += _Enter + " 	JOIN   "+RetSqlName("ZZ6")+" AS TREP (NOLOCK)"
_cReparo += _Enter + " 	ON     TREP.ZZ6_FILIAL = '"+xFilial("ZZ6")+"' "
_cReparo += _Enter + " 	       AND TREP.D_E_L_E_T_ = '' "
_cReparo += _Enter + " 	       AND TREP.ZZ6_LAB = '"+_cLabor+"' "
_cReparo += _Enter + " 	       AND TREP.ZZ6_DATA BETWEEN ENTRDOCA AND SAIDADOCA"
_cReparo += _Enter + " 	WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cReparo += _Enter + " 	       AND LAB = '"+_cLabor+"' "
_cReparo += _Enter + " 	       AND DIV = '"+_cDivis+"' "
_cReparo += _Enter + " 	       AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cReparo += _Enter + " 	GROUP BY LAB, DIV, IMEI, SEMANA, NFE"
_cReparo += _Enter + " 	) AS CALC"
_cReparo += _Enter + " ON     TAT1.LAB = CALC.LAB AND TAT1.DIV = CALC.DIV AND TAT1.IMEI = CALC.IMEI AND TAT1.SEMANA = CALC.SEMANA AND TAT1.NFE = CALC.NFE"


ExecSQL(_cReparo, "reparo")
TCRefresh("GERSETAT")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CalcLab()

local _cLabora := " "

_cLabora += _Enter + " UPDATE GERSETAT "
_cLabora += _Enter + " SET    TLAB = CASE WHEN CALC.TLAB < 0 THEN 0 ELSE CALC.TLAB END "
_cLabora += _Enter + " FROM   GERSETAT AS TAT1 "
_cLabora += _Enter + " JOIN   ("
_cLabora += _Enter + " 	SELECT LAB, DIV, IMEI, SEMANA, NFE, SUM(TLAB.ZZ6_UTIL) - 1 TLAB"
_cLabora += _Enter + " 	FROM   GERSETAT AS TAT (NOLOCK)"
_cLabora += _Enter + " 	JOIN   "+RetSqlName("ZZ6")+" AS TLAB (NOLOCK)"
_cLabora += _Enter + " 	ON     TLAB.ZZ6_FILIAL = '"+xFilial("ZZ6")+"' "
_cLabora += _Enter + " 	       AND TLAB.D_E_L_E_T_ = '' "
_cLabora += _Enter + " 	       AND TLAB.ZZ6_LAB = '"+_cLabor+"' "
_cLabora += _Enter + " 	       AND TLAB.ZZ6_DATA BETWEEN ENTRADA AND DTENCCHA "
_cLabora += _Enter + " 	WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cLabora += _Enter + " 	       AND LAB = '"+_cLabor+"' "
_cLabora += _Enter + " 	       AND DIV = '"+_cDivis+"' "
_cLabora += _Enter + " 	       AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cLabora += _Enter + " 	GROUP BY LAB, DIV, IMEI, SEMANA, NFE"
_cLabora += _Enter + " 	) AS CALC"
_cLabora += _Enter + " ON     TAT1.LAB = CALC.LAB AND TAT1.DIV = CALC.DIV AND TAT1.IMEI = CALC.IMEI AND TAT1.SEMANA = CALC.SEMANA AND TAT1.NFE = CALC.NFE"


ExecSQL(_cLabora, "laboratorio")
TCRefresh("GERSETAT")
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CalcDoca()

local _cEntDoc := " " 

_cEntDoc += _Enter + " UPDATE GERSETAT "
_cEntDoc += _Enter + " SET    TENTDOC = CASE WHEN CALC.TENTDOC < 0 THEN 0 ELSE CALC.TENTDOC END "
_cEntDoc += _Enter + " FROM   GERSETAT AS TAT1 "
_cEntDoc += _Enter + " JOIN   ("
_cEntDoc += _Enter + " 	SELECT LAB, DIV, IMEI, SEMANA, NFE, SUM(TENTDOC.ZZ6_UTIL) - 1 TENTDOC"
_cEntDoc += _Enter + " 	FROM   GERSETAT AS TAT (NOLOCK)"
_cEntDoc += _Enter + " 	JOIN   "+RetSqlName("ZZ6")+" AS TENTDOC (NOLOCK)"
_cEntDoc += _Enter + " 	ON     TENTDOC.ZZ6_FILIAL = '"+xFilial("ZZ6")+"' AND TENTDOC.D_E_L_E_T_ = '' AND TENTDOC.ZZ6_LAB = '"+_cLabor+"' AND TENTDOC.ZZ6_DATA BETWEEN ENTRDOCA AND ENTRADA "
_cEntDoc += _Enter + " 	WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cEntDoc += _Enter + " 	       AND LAB = '"+_cLabor+"' "
_cEntDoc += _Enter + " 	       AND DIV = '"+_cDivis+"' "
_cEntDoc += _Enter + " 	       AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cEntDoc += _Enter + " 	GROUP BY LAB, DIV, IMEI, SEMANA, NFE"
_cEntDoc += _Enter + " 	) AS CALC"
_cEntDoc += _Enter + " ON     TAT1.LAB = CALC.LAB AND TAT1.DIV = CALC.DIV AND TAT1.IMEI = CALC.IMEI AND TAT1.SEMANA = CALC.SEMANA AND TAT1.NFE = CALC.NFE"

ExecSQL(_cEntDoc, "entradadoca")
TCRefresh("GERSETAT")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CalcExped()

local _cExped  := " " 

_cExped  += _Enter + " UPDATE GERSETAT "
_cExped  += _Enter + " SET    TEXPED = CASE WHEN CALC.TEXPED < 0 THEN 0 ELSE CALC.TEXPED END "
_cExped  += _Enter + " FROM   GERSETAT AS TAT1 "
_cExped  += _Enter + " JOIN   ("
_cExped  += _Enter + " 	SELECT LAB, DIV, IMEI, SEMANA, NFE, SUM(TEXPED.ZZ6_UTIL) - 1 TEXPED"
_cExped  += _Enter + " 	FROM   GERSETAT AS TAT (NOLOCK)"
_cExped  += _Enter + " 	JOIN   "+RetSqlName("ZZ6")+" AS TEXPED (NOLOCK)"
_cExped  += _Enter + " 	ON     TEXPED.ZZ6_FILIAL = '"+xFilial("ZZ6")+"' "
_cExped  += _Enter + " 	       AND TEXPED.D_E_L_E_T_ = '' "
_cExped  += _Enter + " 	       AND TEXPED.ZZ6_LAB = '"+_cLabor+"' "
_cExped  += _Enter + " 	       AND TEXPED.ZZ6_DATA BETWEEN DTENCCHA AND SAIDADOCA"
_cExped  += _Enter + " 	WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cExped  += _Enter + " 	       AND LAB = '"+_cLabor+"' "
_cExped  += _Enter + " 	       AND DIV = '"+_cDivis+"' "
_cExped  += _Enter + " 	       AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cExped  += _Enter + " 	GROUP BY LAB, DIV, IMEI, SEMANA, NFE"
_cExped  += _Enter + " 	) AS CALC"
_cExped  += _Enter + " ON     TAT1.LAB = CALC.LAB AND TAT1.DIV = CALC.DIV AND TAT1.IMEI = CALC.IMEI AND TAT1.SEMANA = CALC.SEMANA AND TAT1.NFE = CALC.NFE"


ExecSQL(_cExped, "expedicao")
TCRefresh("GERSETAT")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CalcReceb()

local _cTReceb  := " " 

_cTReceb  += _Enter + " UPDATE GERSETAT "
_cTReceb  += _Enter + " SET    TRECEB = CASE WHEN CALC.TRECEB < 0 THEN 0 ELSE CALC.TRECEB END "
_cTReceb  += _Enter + " FROM   GERSETAT AS TAT1 "
_cTReceb  += _Enter + " JOIN   ("
_cTReceb  += _Enter + " 	SELECT LAB, DIV, IMEI, SEMANA, NFE, SUM(TRECEB.ZZ6_UTIL) - 1 TRECEB"
_cTReceb  += _Enter + " 	FROM   GERSETAT AS TAT (NOLOCK)"
_cTReceb  += _Enter + " 	JOIN   "+RetSqlName("ZZ6")+" AS TRECEB (NOLOCK)"
_cTReceb  += _Enter + " 	ON     TRECEB.ZZ6_FILIAL = '"+xFilial("ZZ6")+"' AND TRECEB.D_E_L_E_T_ = '' AND TRECEB.ZZ6_LAB = '"+_cLabor+"' AND TRECEB.ZZ6_DATA BETWEEN ENTRDOCA AND ENTRADA"
_cTReceb  += _Enter + " 	WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cTReceb  += _Enter + " 	       AND LAB = '"+_cLabor+"' "
_cTReceb  += _Enter + " 	       AND DIV = '"+_cDivis+"' "
_cTReceb  += _Enter + " 	       AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cTReceb  += _Enter + " 	GROUP BY LAB, DIV, IMEI, SEMANA, NFE"
_cTReceb  += _Enter + " 	) AS CALC"
_cTReceb  += _Enter + " ON     TAT1.LAB = CALC.LAB AND TAT1.DIV = CALC.DIV AND TAT1.IMEI = CALC.IMEI AND TAT1.SEMANA = CALC.SEMANA AND TAT1.NFE = CALC.NFE"

ExecSQL(_cTReceb, "recebimento")
TCRefresh("GERSETAT")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX029  บAutor  ณMicrosiga           บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CriaXls()

local _cSelect   := ""
//local _cNomePlan := _cDescLab+"_"+_cDivis+"_"+dtos(dDataBase)+".xls"
local _cNomePlan := _cDescLab+"_"+_cDivis+"_"+dtos(dDataBase)+".csv"

_cSelect += " SELECT * FROM GERSETAT (nolock) " //WHERE SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cSelect += " WHERE  FILIAL = '"+xFilial("ZZ4")+"' "
_cSelect += "        AND LAB = '"+_cLabor+"' "
_cSelect += "        AND DIV = '"+_cDivis+"' "
_cSelect += "        AND SEMANA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSelect),"QRY",.T.,.T.)


//Copy to &(__RELDIR+_cNomePlan)  VIA "DBFCDXADS"
//QRY->(dbCloseArea())
_cArqSeq   :=CriaTrab(,.f.)
Private cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("QRY")
QRY->(dbgotop())
copy to &(cStartPath+_cArqSeq)
QRY->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_cNomePlan)
cArqorig := cStartPath+_cArqSeq+".dtc"

//Incluso Edson Rodrigues - 25/05/10
lgerou:=U_CONVARQ(cArqorig,_cArqTmp)

If lgerou                              
   If !ApOleClient( 'MsExcel' )
      MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
   Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
   EndIf

Else
  msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
Endif

// Incrementa regua do processo 
incproc()

return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  18/05/10   บฑฑ
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
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Laboratorio			?","","","mv_ch1","N",1 ,0,0,"C","",""   ,"","S","mv_par01","Sony/Ericsson","","","","Nextel"	,"","",""		,"","","","","","","","")
PutSX1(cPerg,"02","Divisao				?","","","mv_ch2","N",1 ,0,0,"C","",""   ,"","S","mv_par02","MRC"          ,"","","","DOA"   	,"","","Nextel"	,"","","","","","","","")
PutSX1(cPerg,"03","Semana Inicial		?","","","mv_ch3","C",5 ,0,0,"G","","ZZ5","","S","mv_par03",""				 ,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Semana Final			?","","","mv_ch4","C",5 ,0,0,"G","","ZZ5","","S","mv_par04",""				 ,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Processa Dados 		?","","","mv_ch5","N",1 ,0,0,"C","",""   ,"","S","mv_par05","Sim"			 ,"","","","Nao"   	,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Inicio Processamento	?","","","mv_ch6","C",5 ,0,0,"G","","ZZ5","","S","mv_par06",""				 ,"","","",""		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"07","Fim Processamento	?","","","mv_ch7","C",5 ,0,0,"G","","ZZ5","","S","mv_par07",""				 ,"","","",""		,"","",""		,"","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe Laborat๓rio.")
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
aAdd(aHelpPor,"Informe a Divisao.")
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
aAdd(aHelpPor,"Informe Semana Inicial.")
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
aAdd(aHelpPor,"Informe Semana Final.")
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
aAdd(aHelpPor,"Processa Dodos .")
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
aAdd(aHelpPor,"Informe o Inicio do Processamento.")
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
aAdd(aHelpPor,"Informe o Fim do Processamento.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return