/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX031 บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  14/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Gerencial - Acompanhamento Semanal               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function tecrx031()

Local aSay     	:= {}
Local aButton   := {}
Local nOpc      := 0
Local cTitulo   := "Processamento dos dados para Relat๓rios Gerenciais"
Local cDesc1   	:= "Essa rotina serแ utilizada para gerar os relat๓rios gerenciais de "
Local cDesc2   	:= "Acompanhamento Semanal com grแficos atrav้s do Crystal Reports."
Local cDesc3   	:= ""
Local cDesc4   	:= "Especํfico BGH do Brasil"

Private cPerg     := padr("TECX31",10)

u_GerA0003(ProcName())

ValidPerg()  //Cria Perguntas SX1

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

//Botoes
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T.)			}} ) //Botใo de parโmetros
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()		}} ) //Botใo Ok
aAdd( aButton, { 2, .T., {|| FechaBatch()					}} ) //Botใo Cancel

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	ExecCrys()
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX031 บAutor  ณMicrosiga           บ Data ณ  14/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ExecCrys()

private _cLabor    := ""
private _cDescLab  := "" 
Private _cDivis    := ""
private _cLocal    := ""
private _nReRepair := 0
private _nSwap     := 0
private _nReparab  := 0
private _nBacklog  := 0
private _nAnaliDia := 0
private _nDiasBoun := 0
private _nSLAIncome:= 0
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

_cLabor   := alltrim(str(mv_par01))
_cDescLab := iif(mv_par01==1,"Sony","Nextel")
if mv_par02 == 1     // SONY MRC 
	_cDivis    := "MRC"
	_cLocal    := getmv("MV_XSEMLOC") 
	_nReRepair := getmv("MV_XSEMRRE")
	_nSwap     := getmv("MV_XSEMSWA")
	_nReparab  := getmv("MV_XSEMREP")
	_nBacklog  := getmv("MV_XSEMBKL")
	_nAnaliDia := getmv("MV_XSEMAND")
	_nDiasBoun := getmv("MV_XSEMDBO")
	_nSLAIncome:= getmv("MV_XSEMSLA")
elseif mv_par02 == 2 // SONY DOA
	_cDivis    := "DOA"
	_cLocal    := getmv("MV_XSEDLOC") 
	_nReRepair := getmv("MV_XSEDRRE")
	_nSwap     := getmv("MV_XSEDSWA")
	_nReparab  := getmv("MV_XSEDREP")
	_nBacklog  := getmv("MV_XSEDBKL")
	_nAnaliDia := getmv("MV_XSEDAND")
	_nDiasBoun := getmv("MV_XSEDDBO")
	_nSLAIncome:= getmv("MV_XSEDSLA")
Elseif mv_par02 == 3 // NEXTEL
	_cDivis    := "NEXTEL"
	_cLocal    := getmv("MV_XNEXLOC") 
	_nReRepair := getmv("MV_XNEXRRE")
	_nSwap     := getmv("MV_XNEXSWA")
	_nReparab  := getmv("MV_XNEXREP")
	_nBacklog  := getmv("MV_XNEXBKL")
	_nAnaliDia := getmv("MV_XNEXAND")
	_nDiasBoun := getmv("MV_XNEXDBO")
	_nSLAIncome:= getmv("MV_XNEXSLA")
Endif

// Chama o relatorio de graficos do CRYSTAL
_cParams  := xFilial("ZZ4")				+";"+;
             _cLabor					+";"+;
             _cDescLab 					+";"+;
             _cDivis 					+";"+;
             _cLocal					+";"+;
             mv_par03					+";"+;
             mv_par04					+";"+;
             alltrim(str(_nReRepair))	+";"+;
             alltrim(str(_nSwap))		+";"+;
             alltrim(str(_nReparab))	+";"+;
             alltrim(str(_nBacklog))	+";"+;
             alltrim(str(_nAnaliDia))	+";"+;
             alltrim(str(_nDiasBoun))	+";"+;
             alltrim(str(_nSLAIncome))
_cOptions := "1;0;1;Relat๓rios Gerenciais SONY - Qualidade"
CallCrys("grf_quali",_cParams,_cOptions)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa funcao para alimentar as tabelas SQL com os dados processadosณ
//ณ pelos graficos de Acompanhamento Semanal                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
UpdTabSQL()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa funcao para copiar o arquivo Excel para a estacao do usuario ณ
//ณ e abrir este Excel automaticamente.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AbreExcel()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX031  บAutor  ณMicrosiga           บ Data ณ  11/24/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function UpdTabSQL()

local _cUpdate := ""

_cUpdate += " EXEC STP_TABQUALI '"+xFilial("ZZ4")+"', '"+_cLabor+"', '"+_cDescLab+"', '"+_cDivis+"', '"+_cLocal+"', '"
_cUpdate += mv_par03+"', '"+mv_par04+"', "+alltrim(str(_nReRepair))+", "+alltrim(str(_nSwap))+", "
_cUpdate += alltrim(str(_nReparab))+", "+alltrim(str(_nBacklog))+", "+alltrim(str(_nAnaliDia))+", "
_cUpdate += alltrim(str(_nDiasBoun))

tcSqlExec(_cUpdate)
alert('update concluido')

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECRX031  บAutor  ณMicrosiga           บ Data ณ  11/24/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AbreExcel()

//local cDirDocs  := "\\172.16.0.10\MP8\Protheus8\myprojects-oficial\rdmake\gerencial\excel\" //MsDocPath()
//local cDirDocs  := MsDocPath() -- Removido a pedido do Carlos Rocha 14/07/10 --
local cDirDocs  := __RelDir
Local cArquivo 	:= "Tab_Gerencial_Acompanhamento_Semanal.xlsx"
Local cPath		:= AllTrim(GetTempPath())
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
Local oExcelApp

//CpyS2T( cDirDocs + cArquivo , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath + cArquivo ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
oExcelApp:SetVisible(.T.)

return
                                                                                                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  02/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria perguntas automaticamente no SX1                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

PutSX1(cPerg,'01','Laboratorio'                   ,'Laboratorio'                   ,'Laboratorio'                   ,'mv_ch1','N',1 ,0,0,'C',''             ,''      ,'','S','mv_par01','Sony/Ericsson'  ,'Sony/Ericsson'  ,'Sony/Ericsson'  ,'','Nextel'         ,'Nextel'         ,'Nextel'         ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Divisao'                       ,'Divisao'                       ,'Divisao'                       ,'mv_ch2','N',1 ,0,0,'C',''             ,''      ,'','S','mv_par02','MRC'            ,'MRC'            ,'MRC'            ,'','DOA'            ,'DOA'            ,'DOA'            ,'Nextel'         ,'Nextel'         ,'Nextel'         ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'03','Semana Inicial'                ,'Semana Inicial'                ,'Semana Inicial'                ,'mv_ch3','C',5 ,0,0,'G',''             ,'ZZ5'   ,'','S','mv_par03','','','','','','','','','','','','','','','','')
PutSX1(cPerg,'04','Semana Final'                  ,'Semana Final'                  ,'Semana Final'                  ,'mv_ch4','C',5 ,0,0,'G',''             ,'ZZ5'   ,'','S','mv_par04','','','','','','','','','','','','','','','','')

Return()