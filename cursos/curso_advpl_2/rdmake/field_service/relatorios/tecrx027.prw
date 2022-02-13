#include 'rwmake.ch'
#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX027 บAutor  ณMicrosiga           บ Data ณ  15/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exporta atendimentos NEXTEL para EXCEL                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL (NEXTEL)                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function TECRX027()

Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local cTitulo  := "Exportacao dos atendimentos Nextel para planilha Excel."
Local cDesc1   := "Este programa exporta os dados de atendimentos da Nextel para uma   "
Local cDesc2   := "planilha Excel, ja efetuando alguns tratamentos especificos. "
Local cDesc3   := ""

Private cPerg  := "TECR04"
Private nmaxpn :=0
Private _nReg1 :=0
Private _nReg2 :=0                                                                     
private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Data de Atend Inicial                      ณ
//ณmv_par02 - Data de Atend Final                        ณ
//ณMV_PAR03 - Tipo Relatorio: 1 - Pecas / 2 - Tecnico    ณ
//ณMV_PAR04 - Status: 1 - Tudo / 2 = Com NF / 3 = Sem NF ณ
//ณMV_PAR05 - Data de Saida Inicial                      ณ
//ณMV_PAR06 - Data de Saida Final                        ณ
//ณMV_PAR07 - Laboratorio  / Sony / Nextel               ณ
//ณMV_PAR08 - Fases                                      ณ
//ณmv_par09 - setores                                    ณ
//ณmv_par10 - Tipo de Fases Repor/Nao Report/Todas       ณ
//ณmv_par11 - Considera Partnumber / Individual/Multiplo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Gerando dados de atendimentos Nextel", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  19/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exporta dados de atendimentos para planilha Excel          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _cQuery   := ""
local _cQryReg  := ""
local _cSelect  := _cFrom := _cWhere := _cJoin := _cOrder := _cCount   := ""
local CR        := chr(13) + chr(10)
local _aCampos  := {}
local _cFil08   := "AND ZZ3_FASE1 IN ("
local _cFil09   := "AND ZZ3_CODSET IN ("
local _cOS      := _cASM     := _cIMEI    := _cSerial  := _cCodFase := _cDesFase := _cProduto := _cdefinf  := ""
local _cNexSint := _cNexSolu := _cCodTec  := _cNomeTec := _cCodAna := _cNomeAna := _cNexAct  := ""
//local _cPartN1  := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6  := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""
local _cSrvloc  :=  _cAction := _cclient  := _clojacl  := _cnomecl  := _cestado := ""
local _dDtEntr  := _dDtAtend := _dDtSai   := ctod("  /  /  ")
local _cLaudo1  := _cDesLau1 := _cLaudo2  := _cDesLau2 := _cLaudo3  := _cDesLau3 := _cLaudo4  := _cDesLau4 := ""
Local _nvaluni  := 0
Local _cArqTmp
Local _cResets :=  0

if select("TRB") > 0
	TRB->(dbCloseArea())
endif

if select("REG") > 0
	REG->(dbCloseArea())
endif

if select("QRY") > 0
	QRY->(dbCloseArea())
endif

if select("QR2") > 0
	QR2->(dbCloseArea())
endif

If  !empty(MV_PAR08) .and. empty(MV_PAR09)
   msgstop("Ao informar fase(s), ้ necessแrio que se informe o(s) setor(es) tamb้m. Informe o(s) setor(es) nos parametros do relatorio.","Setor(es) nใo Informado(s)","STOP")
   return
Endif



_cmvpar08 := alltrim(MV_PAR08)
if len(_cmvpar08) > 0
	while len(_cmvpar08) > 0
		_nPosBar := at("/",_cmvpar08)
		_cFil08  += iif(right(_cFil08,1)=="'", ", ","")
		_cFil08  += "'"+left(_cmvpar08,iif(_nPosBar>0,_nPosBar-1,len(_cmvpar08)))+"'"
		_cmvpar08:= iif(_nPosBar == 0, "", right(_cmvpar08,len(_cmvpar08)-_nPosBar))
	enddo
	_cFil08 += ")"
else
	_cFil08 := ""
endif

_cmvpar09 := alltrim(MV_PAR09)
If len(_cmvpar09) > 0
	While len(_cmvpar09) > 0
		_nPosBar := at("/",_cmvpar09)
		_cFil09  += iif(right(_cFil09,1)=="'", ", ","")
		_cFil09  += "'"+left(_cmvpar09,iif(_nPosBar>0,_nPosBar-1,len(_cmvpar09)))+"'"
		_cmvpar09:= iif(_nPosBar == 0, "", right(_cmvpar09,len(_cmvpar09)-_nPosBar))
    Enddo
	_cFil09 += ")"
Else
	_cFil09 := ""
Endif



//_cCodLab := iif(MV_PAR07 == 1, '1', '2')
_cCodLab := ALLTRIM(MV_PAR07)
_cFilFas := iif(MV_PAR10 == 1, " AND ZZ1_TIPO = '1' ", iif(MV_PAR10 == 2, " AND ZZ1_TIPO = '2' ", ""))
_nwhile:=iif(MV_PAR10 == 3,2,1)


for x:=1 to _nwhile
	If x==1
		_cFilFas:=IIF(_nwhile==1,_cFilFas," AND ZZ1_TIPO = '1' ")
		_cCount  := CR + " SELECT COUNT(*) NRREG "
		_cSelect := CR + " SELECT LEFT(ZZ4_OS,6) AS OS, ZZ4_CODPRO, ASM = SPACE(15), ZZ4_CARCAC, ZZ4_IMEI, SYMCODE = '', DESC_SYM = '', "
		_cSelect += CR + "        DESFASE = ZZ1_DESFA1, ZZ1_TIPO,ZZ1_GRAU, DTENTR = ZZ4_EMDT, ZZ3_DATA,ZZ3_HORA, "
     //_cSelect += CR + "        AB9_PARTN1 = SPACE(20), AB9_PARTN2 = SPACE(20), AB9_PARTN3 = SPACE(20), AB9_PARTN4 = SPACE(20), AB9_PARTN5 = SPACE(20), "
     //_cSelect += CR + "        AB9_PARTN6 = SPACE(20), AB9_PARTN7 = SPACE(20), AB9_PARTN8 = SPACE(20), AB9_PARTN9 = SPACE(20), AB9_PARTNA = SPACE(20), "
		_cSelect += CR + "        ZZ3_CODTEC, NOMTEC = CASE WHEN AA1.AA1_NOMTEC IS NOT NULL THEN AA1.AA1_NOMTEC ELSE SPACE(30) END, "
		_cSelect += CR + "        ZZ3_CODANA, NOMANA = CASE WHEN AA1_1.AA1_NOMTEC IS NOT NULL THEN AA1_1.AA1_NOMTEC ELSE SPACE(30) END, ZZ3_LAUDO, DESLAUDO = Z8.X5_DESCENG, NEXSIN = SPACE(10), NEXSOL = SPACE(10), SERVLOC = 'BGH-BRZ', "
		_cSelect += CR + "        ACAO = SPACE(10), ZZ3_FASE1, ZZ3_FASE2, ZZ3_SEQ, ZZ3_LAB,ZZ3_CODSET , ZZ3_CODSE2 , "
		_cSelect += CR + "        ZZ4_PV, ZZ4_NFSNR, ZZ4_NFSSER, ZZ4_NFSDT,"
		_cSelect += CR + "        ZZ4_BOUNCE, ZZ4_DEFINF, ZZ4_DEFDET,ZZ3_DEFINF,ZZ3_DEFDET, "
		_cSelect += CR + "        IMEISWAP=CASE WHEN ZZ4_SWAP='' THEN ZZ3_IMEISW ELSE ZZ4_SWAP END,"
		_cSelect += CR + "        ZZ4_FASMAX,ZZ4_SETMAX,ZZ4_GRMAX,ZZ4_GARANT,ZZ4_GARMCL,ZZ4_OPEBGH, ZZ3_QTDRES, "
		_cSelect += CR + "         STATUS     = CASE WHEN ZZ4_STATUS = '1' THEN '1-Entrada Apontada'"
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '2' THEN '2-Entrada Confirmada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '3' THEN '3-NFE Gerada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '4' THEN '4-Em atendimento' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '5' THEN '5-OS Encerrada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '6' THEN '6-Saida Lida' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '7' THEN '7-Saida Apontada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '8' THEN '8-PV Gerado' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '9' THEN '9-NFS Gerada' else '' END,ZZ4_CODCLI CLIENTE,ZZ4_LOJA LOJA,ZZ4_VLRUNI AS VALUNIT"
		_cFrom   := CR + " FROM   "+RetSqlName("ZZ3")+" AS ZZ3 (nolock) "
		_cJoin   := CR + " JOIN   ( SELECT Z4.ZZ4_FILIAL,Z4.ZZ4_IMEI,Z4.ZZ4_OS,Z4.ZZ4_EMDT,Z4.ZZ4_PV,Z4.ZZ4_NFSNR, Z4.ZZ4_NFSSER, Z4.ZZ4_NFSDT,Z4.ZZ4_BOUNCE,Z4.ZZ4_OPEBGH, "
		_cJoin   += CR + "          Z4.ZZ4_FASMAX,Z4.ZZ4_SETMAX,Z4.ZZ4_GRMAX,Z4.ZZ4_GARANT,Z4.ZZ4_GARMCL,Z4.ZZ4_DEFINF, Z4.ZZ4_DEFDET,Z4.ZZ4_STATUS,Z4.ZZ4_CODCLI,Z4.ZZ4_LOJA,Z4.ZZ4_CODPRO,Z4.ZZ4_CARCAC,Z4.ZZ4_VLRUNI,Z4.ZZ4_SWAP FROM "+RetSqlName("ZZ4")+" AS Z4 (nolock) "
		_cJoin   += CR + "          WHERE  Z4.D_E_L_E_T_ = '' AND Z4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"'
		IF MV_PAR04==3
			_cJoin   += CR + " AND Z4.ZZ4_NFSNR='' ) AS ZZ4 "
		Elseif MV_PAR04==2
			_cJoin   += CR +  " AND Z4.ZZ4_NFSDT >='"+dtos(MV_PAR05)+"' AND  Z4.ZZ4_NFSDT <='"+dtos(MV_PAR06)+"' AND Z4.ZZ4_NFSNR<>'' ) AS ZZ4 "
		ELSE
			_cJoin   += CR + " ) AS ZZ4 "
		ENDIF
		_cJoin   += CR + " ON  ZZ3_IMEI=ZZ4.ZZ4_IMEI AND LEFT(ZZ3_NUMOS,6) = LEFT(ZZ4.ZZ4_OS,6)   "
		_cJoin   += CR + " JOIN   "+RetSqlName("ZZ1")+" AS ZZ1 (nolock) "
		_cJoin   += CR + " ON     ZZ1.D_E_L_E_T_ = '' AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_LAB = ZZ3_LAB AND ZZ1_CODSET = ZZ3_CODSET AND ZZ1_FASE1 = ZZ3_FASE1 "
		_cJoin   += CR + " JOIN   "+RetSqlName("AA1")+" AS AA1 (nolock) "
		_cJoin   += CR + " ON     AA1.D_E_L_E_T_ = '' AND AA1.AA1_FILIAL = '"+xFilial("AA1")+"' AND AA1.AA1_LAB = ZZ3_LAB AND AA1.AA1_CODTEC = ZZ3_CODTEC" 
		_cJoin   += CR + " LEFT JOIN   "+RetSqlName("AA1")+" AS AA1_1 (nolock) "
		_cJoin   += CR + " ON     AA1_1.D_E_L_E_T_ = '' AND AA1_1.AA1_FILIAL = '"+xFilial("AA1")+"' AND AA1_1.AA1_LAB = ZZ3_LAB AND AA1_1.AA1_CODTEC = ZZ3_CODANA"		
		_cJoin   += CR + " LEFT OUTER JOIN "+RetSqlName("SX5")+" AS Z8 (nolock) "
		_cJoin   += CR + " ON     Z8.D_E_L_E_T_  = '' AND Z8.X5_FILIAL = '"+xFilial("SX5")+"' AND Z8.X5_TABELA = 'Z8' AND Z8.X5_CHAVE = ZZ3_LAUDO"
		_cWhere  := CR + "        WHERE ZZ3_FILIAL = '"+xFilial("ZZ3")+"' "
		_cWhere  += CR + "        AND ZZ3_LAB    = '"+_cCodLab+"' "
		_cWhere  += CR + "        AND ZZ3_DATA   >='"+dtos(mv_par01)+"' AND  ZZ3_DATA <='"+dtos(mv_par02)+"' "
		_cWhere  += CR + "        AND ZZ3_STATUS ='1' AND  ZZ3_ESTORN <>'S' "
		_cWhere  += CR + "        "+_cFil08
		_cWhere  += CR + "        "+_cFil09
		_cWhere  += CR + "        "+_cFilFas
		_cWhere  += CR + "        AND  ZZ3.D_E_L_E_T_ = '' "
		_cOrder  := CR + " ORDER BY ZZ3_IMEI,ZZ3_NUMOS,ZZ3_DATA, ZZ3_HORA,ZZ1_TIPO"
		
		// Verifica quantidade de registros para definir regua
		
		_cQryReg := _cCount + _cFrom + _cJoin + _cWhere
		_cQryReg := strtran(_cQryReg, CR, "")
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryReg),"REG",.T.,.T.)
		dbselectarea("REG")
		REG->(dbgotop())
		_nReg1 := REG->NRREG
		REG->(dbCloseArea())
		
		// Grava query em arquivo texto pra ser utilizado pelo Query Analiser
		_cQuery := _cSelect + _cFrom + _cJoin + _cWhere + _cOrder
//     memowrite("TECRX0271.SQL",_cQuery )
		_cQuery := strtran(_cQuery, CR, "")
		
		// Gera arquivos temporario com resultado da Query
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
    //TcSetField("QRY", "AB9_DTSAID", "D")
		
	Else
		_cFilFas:=" AND ZZ1_TIPO = '2' "
		_cCount  := CR + " SELECT COUNT(*) NRREG "
		_cSelect := CR + " SELECT LEFT(ZZ4_OS,6) AS OS, ZZ4_CODPRO, ASM = SPACE(15), ZZ4_CARCAC, ZZ4_IMEI, SYMCODE = '', DESC_SYM = '', "
		_cSelect += CR + "        DESFASE = ZZ1_DESFA1, ZZ1_TIPO,ZZ1_GRAU, DTENTR = ZZ4_EMDT, ZZ3_DATA,ZZ3_HORA, "
     //_cSelect += CR + "        AB9_PARTN1 = SPACE(20), AB9_PARTN2 = SPACE(20), AB9_PARTN3 = SPACE(20), AB9_PARTN4 = SPACE(20), AB9_PARTN5 = SPACE(20), "
     //_cSelect += CR + "        AB9_PARTN6 = SPACE(20), AB9_PARTN7 = SPACE(20), AB9_PARTN8 = SPACE(20), AB9_PARTN9 = SPACE(20), AB9_PARTNA = SPACE(20), "
		_cSelect += CR + "        ZZ3_CODTEC, NOMTEC = CASE WHEN AA1.AA1_NOMTEC IS NOT NULL THEN AA1.AA1_NOMTEC ELSE SPACE(30) END, "
		_cSelect += CR + "        ZZ3_CODANA, NOMANA = CASE WHEN AA1_1.AA1_NOMTEC IS NOT NULL THEN AA1_1.AA1_NOMTEC ELSE SPACE(30) END,ZZ3_LAUDO, DESLAUDO = Z8.X5_DESCENG, NEXSIN = SPACE(10), NEXSOL = SPACE(10), SERVLOC = 'BGH-BRZ', "
		_cSelect += CR + "        ACAO = SPACE(10), ZZ3_FASE1, ZZ3_FASE2, ZZ3_SEQ, ZZ3_LAB,ZZ3_CODSET , ZZ3_CODSE2 , "
		_cSelect += CR + "        ZZ4_PV, ZZ4_NFSNR, ZZ4_NFSSER, ZZ4_NFSDT,"
		_cSelect += CR + "        ZZ4_BOUNCE, ZZ4_DEFINF, ZZ4_DEFDET,ZZ3_DEFINF,ZZ3_DEFDET,"
		_cSelect += CR + "        IMEISWAP=CASE WHEN ZZ4_SWAP='' THEN ZZ3_IMEISW ELSE ZZ4_SWAP END,"
		_cSelect += CR + "        ZZ4_FASMAX,ZZ4_SETMAX,ZZ4_GRMAX,ZZ4_GARANT,ZZ4_GARMCL,ZZ4_OPEBGH, ZZ3_QTDRES, "
		_cSelect += CR + "         STATUS     = CASE WHEN ZZ4_STATUS = '1' THEN '1-Entrada Apontada'"
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '2' THEN '2-Entrada Confirmada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '3' THEN '3-NFE Gerada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '4' THEN '4-Em atendimento' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '5' THEN '5-OS Encerrada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '6' THEN '6-Saida Lida' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '7' THEN '7-Saida Apontada' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '8' THEN '8-PV Gerado' "
		_cSelect += CR + "                           WHEN ZZ4_STATUS = '9' THEN '9-NFS Gerada' else '' END,ZZ4_CODCLI CLIENTE,ZZ4_LOJA LOJA,ZZ4_VLRUNI AS VALUNIT"
		_cFrom   := CR + " FROM   "+RetSqlName("ZZ3")+" AS ZZ3 (nolock) "
		_cJoin   := CR + " JOIN   ( SELECT Z4.ZZ4_FILIAL,Z4.ZZ4_IMEI,Z4.ZZ4_OS,Z4.ZZ4_EMDT,Z4.ZZ4_PV,Z4.ZZ4_NFSNR, Z4.ZZ4_NFSSER, Z4.ZZ4_NFSDT,Z4.ZZ4_BOUNCE,Z4.ZZ4_OPEBGH, "
		_cJoin   += CR + "          Z4.ZZ4_FASMAX,Z4.ZZ4_SETMAX,Z4.ZZ4_GRMAX,Z4.ZZ4_GARANT,Z4.ZZ4_GARMCL,Z4.ZZ4_DEFINF, Z4.ZZ4_DEFDET,Z4.ZZ4_STATUS,Z4.ZZ4_CODCLI,Z4.ZZ4_LOJA,Z4.ZZ4_CODPRO,Z4.ZZ4_CARCAC,Z4.ZZ4_VLRUNI,Z4.ZZ4_SWAP FROM "+RetSqlName("ZZ4")+" AS Z4 (nolock) "
		_cJoin   += CR + "          WHERE  Z4.D_E_L_E_T_ = '' AND Z4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"'
		IF MV_PAR04==3
			_cJoin   += CR + " AND Z4.ZZ4_NFSNR='' ) AS ZZ4 "
		Elseif MV_PAR04==2
			_cJoin   += CR +  " AND Z4.ZZ4_NFSDT >='"+dtos(MV_PAR05)+"' AND  Z4.ZZ4_NFSDT <='"+dtos(MV_PAR06)+"' AND Z4.ZZ4_NFSNR<>'' ) AS ZZ4 "
		ELSE
			_cJoin   += CR + " ) AS ZZ4 "
		ENDIF
		_cJoin   += CR + " ON  ZZ3_IMEI=ZZ4.ZZ4_IMEI AND LEFT(ZZ3_NUMOS,6) = LEFT(ZZ4.ZZ4_OS,6)
		_cJoin   += CR + " JOIN   "+RetSqlName("ZZ1")+" AS ZZ1 (nolock) "
		_cJoin   += CR + " ON     ZZ1.D_E_L_E_T_ = '' AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_LAB = ZZ3_LAB AND ZZ1_CODSET = ZZ3_CODSET AND ZZ1_FASE1 = ZZ3_FASE1 "
		_cJoin   += CR + " JOIN   "+RetSqlName("AA1")+" AS AA1 (nolock) "
		_cJoin   += CR + " ON     AA1.D_E_L_E_T_ = '' AND AA1.AA1_FILIAL = '"+xFilial("AA1")+"' AND AA1.AA1_LAB = ZZ3_LAB AND AA1.AA1_CODTEC = ZZ3_CODTEC"
		_cJoin   += CR + " LEFT JOIN   "+RetSqlName("AA1")+" AS AA1_1 (nolock) "
		_cJoin   += CR + " ON     AA1_1.D_E_L_E_T_ = '' AND AA1_1.AA1_FILIAL = '"+xFilial("AA1")+"' AND AA1_1.AA1_LAB = ZZ3_LAB AND AA1_1.AA1_CODTEC = ZZ3_CODANA"			
		_cJoin   += CR + " LEFT OUTER JOIN "+RetSqlName("SX5")+" AS Z8 (nolock) "
		_cJoin   += CR + " ON     Z8.D_E_L_E_T_  = '' AND Z8.X5_FILIAL = '"+xFilial("SX5")+"' AND Z8.X5_TABELA = 'Z8' AND Z8.X5_CHAVE = ZZ3_LAUDO"
		_cWhere  := CR + "        WHERE ZZ3_FILIAL = '"+xFilial("ZZ3")+"' "
		_cWhere  += CR + "        AND ZZ3_LAB    = '"+_cCodLab+"' "
		_cWhere  += CR + "        AND ZZ3_DATA   >='"+dtos(mv_par01)+"' AND  ZZ3_DATA <='"+dtos(mv_par02)+"' "
		_cWhere  += CR + "        AND ZZ3_STATUS ='1' AND  ZZ3_ESTORN <>'S' "
		_cWhere  += CR + "        "+_cFil08
		_cWhere  += CR + "        "+_cFil09
		_cWhere  += CR + "        "+_cFilFas
		_cWhere  += CR + "       AND  ZZ3.D_E_L_E_T_ = '' "
		_cOrder  := CR + " ORDER BY ZZ3_IMEI,ZZ3_NUMOS,ZZ3_DATA, ZZ3_HORA,ZZ1_TIPO"
		
		// Verifica quantidade de registros para definir regua
		
		_cQryReg := _cCount + _cFrom + _cJoin + _cWhere
		_cQryReg := strtran(_cQryReg, CR, "")
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryReg),"REG",.T.,.T.)
		dbselectarea("REG")
		REG->(dbgotop())
		_nReg2 := REG->NRREG
		REG->(dbCloseArea())
		
		// Grava query em arquivo texto pra ser utilizado pelo Query Analiser
		_cQuery := _cSelect + _cFrom + _cJoin + _cWhere + _cOrder
		memowrite("TECRX0272.SQL",_cQuery )
		_cQuery := strtran(_cQuery, CR, "")
		
		// Gera arquivos temporario com resultado da Query
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QR2",.T.,.T.)
    //TcSetField("QR2", "AB9_DTSAID", "D")
	Endif
Next

//Fun็ใo para achar o n๚mero // Edson Rodrigues 04/03/10
nmaxpn:=u_maxprn( _nReg1,_nReg2,_cFilFas,_cFil08,_cFil09,_cCodLab)


// Chama funcao da regua
ProcRegua(_nReg1)

if mv_par12 == 1
	_aCampos := {	{"OS"		,"C",6,0} ,;
	{"PRODUTO"	,"C",15,0},;
	{"GRUPO"	,"C",10,0},;
	{"ASM"      ,"C",15,0},;
	{"SERIAL"	,"C",15,0},;
	{"IMEI"		,"C",TamSX3("ZZ4_IMEI")[1],0},;
	{"DTENTR"	,"D",08,0},;
	{"DTATEN"	,"D",08,0},;
	{"HRATEN"   ,"C",05,0},;
	{"VALUNIT"	,"N",13,2},;
	{"LABOR"	,"C",06,0},;
	{"OPEBGH"	,"C",25,0},;
	{"CODTEC"	,"C",06,0},;
	{"NOMETEC"	,"C",20,0},;
	{"ANALISTA"	,"C",06,0},;
	{"NOMEANA"	,"C",20,0},;
	{"SETORIG"	,"C",06,0},;
	{"CODFASE"	,"C",06,0},;
	{"FASE"		,"C",20,0},;
	{"TIPOFASE" ,"C",20,0},;
	{"GRAU"     ,"C",2,0},;
	{"SETDEST"	,"C",06,0},;
	{"CODFAS2"	,"C",06,0},;
	{"FASE2"	,"C",20,0},;
	{"FASEMAXS" ,"C",06,0},;
	{"SETFMAXS" ,"C",06,0},;
	{"GRAUMAXS" ,"C",02,0},;
	{"GARANTIA" ,"C",01,0},;
	{"GARMCLAI" ,"C",01,0},;
	{"SYMCODE"	,"C",20,0},;
	{"DESC_SYM" ,"C",55,0},;
	{"RESCODE"	,"C",06,0},;
	{"NEXSOLU"	,"C",06,0},;
	{"DESC_SOL" ,"C",55,0},;
	{"DEFINF"	,"C",05,0},;
	{"DESDINF"	,"C",30,0},;
	{"DEFDET"	,"C",05,0},;
	{"DESDDET"	,"C",30,0},;
	{"LAUDO1"	,"C",20,0},;
	{"DESLAU1"	,"C",50,0},;
	{"LAUDO2"	,"C",20,0},;
	{"DESLAU2"	,"C",50,0},;
	{"LAUDO3"	,"C",20,0},;
	{"DESLAU3"	,"C",50,0},;
	{"LAUDO4"	,"C",20,0},;
	{"DESLAU4"	,"C",50,0},;
	{"SERVLOC"  ,"C",06,0},;
	{"ACAO"  	,"C",10,0},;
	{"RESETS"  	,"N",2,0},;
	{"BOUNCE"   ,"N",10,2},;
	{"IMEISWAP" ,"C",TamSX3("ZZ4_IMEI")[1],0},;
	{"NUMPV"	,"C",06,0},;
	{"NUMNF"	,"C",09,0},;
	{"EMISNF"	,"D",08,0},;
	{"DTSAID"	,"D",08,0},;
	{"CLIENTE"	,"C",06,0},;
	{"LOJA"   	,"C",02,0},;
	{"NOMENT"	,"C",30,0},;
	{"ESTADO"	,"C",30,0},;
	{"STATUOS"	,"C",20,0}}
else
	_aCampos := {{"IMEI"		,"C",TamSX3("ZZ4_IMEI")[1],0},;
	{"OS"		,"C",6,0} ,;
	{"DESCRICAO","C",50,0},;
	{"PRODUTO"	,"C",15,0}}
endif

//Cria as variaveis da tabela temporarํa e variaveis de uso nos processos do programa -  Edson Rodrigues 04/03/10
For x:=1 to nmaxpn
	cCampo:='_cPARTN'+STRZERO(X,3)
	&cCampo:=space(20)
	AAdd(_aCampos,{substr(cCampo,3),'C',20,0})
Next

_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TRB",.T.,.F.)
cInd1TRB := CriaTrab(Nil, .F.)
IndRegua("TRB",cInd1TRB,"IMEI+OS",,,"Indexando Arquivo de Trabalho")
dbClearIndex()
cindarqt :=cInd1TRB + OrdBagExt()
dbSetIndex(cInd1TRB + OrdBagExt())


// Processa arquivo temporario da Query
dbSelectArea("QRY")
QRY->(dbGoTop())
_cIMEI := ""
//_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6 := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""
//_cPartN11 := _cPartN12  := _cPartN13  := _cPartN14  := _cPartN15  := _cPartN16 := _cPartN17  := _cPartN18  := _cPartN19  := _cPartN20 := ""

//Cria as variaveis de uso no  while  abaixo-  Edson Rodrigues 04/03/10
For x:=1 to nmaxpn
	cCampo:='_cPARTN'+STRZERO(X,3)
	&cCampo:=space(20)
Next

_cdefinf := _cDesdinf := _cdefdet  := _cDesddet :=""
_apartnr := {}

while QRY->(!eof())
	IncProc( "Processando dados  Qry de OS reportadas ... " )
       //_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6 := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""
	_cLab    := QRY->ZZ3_LAB
	_csetori := QRY->ZZ3_CODSET
	_csetdes := QRY->ZZ3_CODSE2
	_cstat   := QRY->STATUS
	_ctpfase := IIF(QRY->ZZ1_TIPO=='1','REPORTADA','NAO REPORTADA')
	_lok := .F.
	
	
	_cPartN := " SELECT Z9.* "
	_cPartN += " FROM   "+RetSqlName("SZ9")+" AS Z9 (nolock) "
	_cPartN += " WHERE  Z9_FILIAL  = '"+xFilial("SZ9")+"' AND "
	_cPartN += "        Z9_IMEI    = '"+QRY->ZZ4_IMEI+"' AND "
	_cPartN += "        LEFT(Z9_NUMOS,6) = '"+QRY->OS+"' AND "
	_cPartN += "        Z9_SEQ     = '"+QRY->ZZ3_SEQ+"' AND "
	_cPartN += "        Z9.D_E_L_E_T_ = '' AND Z9_STATUS='1'"
	_cPartN += " ORDER BY Z9_ITEM "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cPartN),"PARTNR",.T.,.T.)
	PARTNR->(dbGoTop())
	
	_cSintom := _cSoluca := _cAction := ""
	_nwhile    :=0
	
	while PARTNR->(!eof())
		
		_cSintom := iif(empty(_cSintom) , PARTNR->Z9_SYMPTO , _cSintom )
		_cSoluca := iif(empty(_cSoluca) , PARTNR->Z9_ACTION , _cSoluca )
		_cAction := ""//iif(empty(_cSoluca), PARTNR->Z9_ACTION, _cAction)
		
		
		IF !EMPTY(PARTNR->Z9_PARTNR)
			_nwhile:=IIF(_nwhile=0,1,_nwhile)
			//alimenta as variaveis em  uso  com os conte๚dos de parnumbers encontrados -  Edson Rodrigues 04/03/10
			For x:=_nwhile to nmaxpn
				_lok:=.F.
				cCampo:='_cPARTN'+STRZERO(x,3)
                  //&cCampo:=space(20)
				IF MV_PAR11==1
					IF empty(alltrim(&cCampo))
						&cCampo  := alltrim(PARTNR->Z9_PARTNR)
						AADD(_apartnr,{alltrim(&cCampo)})
						_lok:=.T.
						_nwhile++
					Endif
				ELSEIF MV_PAR11==2 .AND. PARTNR->Z9_QTY=1
					IF empty(alltrim(&cCampo))
						&cCampo  := alltrim(PARTNR->Z9_PARTNR)
						AADD(_apartnr,{alltrim(&cCampo)})
						_lok:=.T.
						_nwhile++
					Endif
				ELSEIF MV_PAR11==2 .AND. PARTNR->Z9_QTY > 1
					For n:=1 to  PARTNR->Z9_QTY
						_lok:=.F.
						cCampo:='_cPARTN'+STRZERO(x,3)
						IF empty(alltrim(&cCampo))
							&cCampo  := alltrim(PARTNR->Z9_PARTNR)
							AADD(_apartnr,{alltrim(&cCampo)})
							x++
							_nwhile++
							_lok:=.T.
						ENDIF
					next
				ENDIF
				
				IF _lok
					EXIT
				ENDIF
				
			Next
			
		ENDIF
		
			/*
			//Desabilitado, estแ sendo feito via valida็ใo acima -  Edson Rodrigues 04/03/10 
		Do Case 
			Case empty(_cPartN1)
				_cPartN1  := PARTNR->Z9_PARTNR
			Case empty(_cPartN2)
				_cPartN2  := PARTNR->Z9_PARTNR
			Case empty(_cPartN3)
				_cPartN3  := PARTNR->Z9_PARTNR
			Case empty(_cPartN4)
				_cPartN4  := PARTNR->Z9_PARTNR
            Case empty(_cPartN5)
				_cPartN5  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN6)
				_cPartN6  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN7)
				_cPartN7  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN8)
				_cPartN8  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN9)
				_cPartN9  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN10)
				_cPartN10 := PARTNR->Z9_PARTNR			
			Case empty(_cPartN11)
				_cPartN11  := PARTNR->Z9_PARTNR
			Case empty(_cPartN12)
				_cPartN12  := PARTNR->Z9_PARTNR
			Case empty(_cPartN13)
				_cPartN13  := PARTNR->Z9_PARTNR
			Case empty(_cPartN14)
				_cPartN14  := PARTNR->Z9_PARTNR
            Case empty(_cPartN15)
				_cPartN15  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN16)
				_cPartN16  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN17)
				_cPartN17  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN18)
				_cPartN18  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN19)
				_cPartN19  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN20)
				_cPartN20 := PARTNR->Z9_PARTNR	
		EndCase
	    */
		
		PARTNR->(dbSkip())
	enddo
	PARTNR->(dbCloseArea())
	
	if empty(_cIMEI) .or. QRY->ZZ1_GRAU > _cGrau
		_cIMEI    := QRY->ZZ4_IMEI
		_cOS      := QRY->OS
		_cASM     := QRY->ASM
		_cSerial  := QRY->ZZ4_CARCAC
		_cCodFase := QRY->ZZ3_FASE1
		_cDesFase := QRY->DESFASE
		_cCodFas2 := QRY->ZZ3_FASE2
		_cCodSet2 := IIF(EMPTY(QRY->ZZ3_CODSE2),QRY->ZZ3_CODSET,QRY->ZZ3_CODSE2)
		_cDesFas2 := Posicione("ZZ1",2,xFilial("ZZ1") + QRY->ZZ3_LAB + QRY->ZZ3_FASE2 + _cCodSet2 ,"ZZ1_DESFA1")
		_dDtEntr  := stod(QRY->DTENTR) //VerDtEntr(QRY->ZZ3_IMEI, QRY->OS)
		_dDtAtend := stod(QRY->ZZ3_DATA)
		_cfasmxs  := QRY->ZZ4_FASMAX
		_csetmxs  := QRY->ZZ4_SETMAX
//		_cdesmxs  := QRY->ZZ4_DFAMAX
		_graumxs  := QRY->ZZ4_GRMAX
		_cgarant  := QRY->ZZ4_GARANT
		_cgarmcl  := QRY->ZZ4_GARMCL
		_chrAtend := QRY->ZZ3_HORA
		_cProduto := QRY->ZZ4_CODPRO
		_cGrupo   := Posicione("SB1",1,xFilial("SB1") + QRY->ZZ4_CODPRO , "B1_GRUPO")
		_cNexSint := iif(!empty(_cSintom), _cSintom, _cNexSint)
		_cNexSolu := iif(!empty(_cSoluca), _cSoluca, _cNexSolu)
		_cNexAct  := iif(!empty(_cAction), _cAction, _cNexAct )
		_cdefinf  := iif(!empty(_cdefinf),_cdefinf,IIF(!EMPTY(QRY->ZZ4_DEFINF),QRY->ZZ4_DEFINF,QRY->ZZ3_DEFINF))
		_cDesdinf := Posicione("ZZG",1,xFilial("ZZG") + QRY->ZZ3_LAB + _cdefinf, "ZZG_DESCRI" )
		_cdefdet  := iif(!empty(_cdefdet),_cdefdet,IIF(!EMPTY(QRY->ZZ4_DEFDET),QRY->ZZ4_DEFDET,QRY->ZZ3_DEFDET))
		_cDesddet := Posicione("ZZG",1,xFilial("ZZG") + QRY->ZZ3_LAB + _cdefdet, "ZZG_DESCRI" )
		_nbounce  := QRY->ZZ4_BOUNCE
		_cimeswap := QRY->IMEISWAP
		_cCodTec  := QRY->ZZ3_CODTEC
		_cNomeTec := QRY->NOMTEC
		_cCodAna  := QRY->ZZ3_CODANA
		_cNomeAna := QRY->NOMANA
		_dDtSai   := stod(QRY->ZZ4_NFSDT) //VerDtSai(QRY->AB9_SN, QRY->AB9_NUMOS)
		_cSrvloc  := QRY->SERVLOC
		_cGrau    := QRY->ZZ1_GRAU
		_cclient  := QRY->CLIENTE
		_clojacl  := QRY->LOJA
		_cnomecl  := Posicione("SA1",1,xFilial("SA1") + QRY->CLIENTE + QRY->LOJA, "A1_NREDUZ")
		_cestado  := Posicione("SA1",1,xFilial("SA1") + QRY->CLIENTE + QRY->LOJA, "A1_EST")
		_nvaluni  := QRY->VALUNIT
        _copebgh  := QRY->ZZ4_OPEBGH+"-"+ALLTRIM(Posicione("ZZJ",1,xFilial("ZZJ") + QRY->ZZ4_OPEBGH + QRY->ZZ3_LAB, "ZZJ_DESCRI" ))
		_cResets := QRY->ZZ3_QTDRES
	endif
	
	_cNumPV   := QRY->ZZ4_PV
	_cNumNF   := ALLTRIM(QRY->ZZ4_NFSNR)
	_dEmisNF  := stod(QRY->ZZ4_NFSDT)
	if !empty(QRY->ZZ3_LAUDO)
		do case
			case empty(_cLaudo1)
				_cLaudo1  := QRY->ZZ3_LAUDO
				_cDesLau1 := QRY->DESLAUDO
			case empty(_cLaudo2)
				_cLaudo2  := QRY->ZZ3_LAUDO
				_cDesLau2 := QRY->DESLAUDO
			case empty(_cLaudo3)
				_cLaudo3  := QRY->ZZ3_LAUDO
				_cDesLau3 := QRY->DESLAUDO
			case empty(_cLaudo4)
				_cLaudo4  := QRY->ZZ3_LAUDO
				_cDesLau4 := QRY->DESLAUDO
		endcase
	endif
	
	QRY->(dbSkip())
	
	  // MV_PAR03 => 1 = Pecas / 2 = Tecnicos 
      //Quando for Tecnico pega todas as fases/IMEIS
	  //Quando for Pecas e se parametro tipo de Fases reportada ou nao reportada pega somente um IMEI.
	  //Quando for Pecas e se parametro tipo de Fases todas 
	  //if MV_PAR03 == 2 .or. (MV_PAR03 == 1 .and. (QRY->(eof()) .or. IIF(MV_PAR10==3,.T.,_cIMEI <> QRY->ZZ4_IMEI))) //.and. ; 
	if MV_PAR03 == 2 .or. (MV_PAR03 == 1 .and. (QRY->(eof()) .or. (_cIMEI+_cOS <> QRY->ZZ4_IMEI+QRY->OS ))) //.and. ;
		// MV_PAR04 => 1 = Tudo  / 2 = Com NF   / 3 = Sem NF
		if MV_PAR04 == 1 .or. (MV_PAR04 == 2 .and. !empty(_cNumNF) .and. _dEmisNF >= MV_PAR05 .and. _dEmisNF <= MV_PAR06) .or. ;
			(MV_PAR04 == 3 .and. empty(_cNumNF))

			RecLock("TRB",.t.)
			if mv_par12 == 1
				TRB->IMEI     := _cIMEI
				TRB->SERIAL   := _cSerial
				TRB->OS       := _cOS
				TRB->LABOR    := _cLab
				TRB->CODFASE  := _cCodFase
				TRB->FASE	  := _cDesFase
				TRB->SETORIG  := _csetori
				TRB->CODFAS2  := _cCodFas2
				TRB->FASE2	  := _cDesFas2
				TRB->SETDEST  := _csetdes
				TRB->TIPOFASE := _ctpfase
				TRB->GRAU     := _cGrau
				TRB->DTENTR   := _dDtEntr
				TRB->DTATEN   := _dDtAtend
				TRB->HRATEN   := _chrAtend
				TRB->PRODUTO  := _cProduto
				TRB->GRUPO    := _cGrupo
				TRB->VALUNIT  := _nvaluni
				TRB->OPEBGH   := _copebgh
				TRB->RESETS := _cResets
				//Grava o conte๚do obtido nas variแveis de partnumbers nos campos de partnumbers correspondente na tabela temporแria -  Edson Rodrigues 04/03/10
				If len(_apartnr) > 0
					For x:=1 to len(_apartnr)
						IF X <= nmaxpn
							cCMPTab:='TRB->PARTN'+STRZERO(X,3)
							&cCMPTab:=_apartnr[x,1]
						ENDIF
					Next
				Endif
				TRB->SYMCODE  := _cNexSint
				TRB->DESC_SYM := Posicione("SZ8",1,xFilial("SZ8") + _cLab + _cNexSint, "Z8_DESSINT")
				TRB->NEXSOLU  := _cNexSolu
				TRB->DESC_SOL := Posicione("SZ8",2,xFilial("SZ8") + _cLab + _cNexSolu, "Z8_DESSOLU")
				TRB->LAUDO1   := _cLaudo1
				TRB->DESLAU1  := _cDesLau1
				TRB->LAUDO2   := _cLaudo2
				TRB->DESLAU2  := _cDesLau2
				TRB->LAUDO3   := _cLaudo3
				TRB->DESLAU3  := _cDesLau3
				TRB->LAUDO4   := _cLaudo4
				TRB->DESLAU4  := _cDesLau4
				TRB->ASM      := _cASM
				TRB->ACAO     := _cNexAct
				TRB->SERVLOC  := _cSrvloc
				TRB->DEFINF   := _cdefinf
				TRB->DESDINF  := _cDesdinf
				TRB->DEFDET   := _cdefdet
				TRB->DESDDET  := _cDesddet
				TRB->BOUNCE   := _nbounce
				TRB->IMEISWAP := _cimeswap
				TRB->CODTEC  := _cCodTec
				TRB->NOMETEC := _cNomeTec
				TRB->ANALISTA:= _cCodAna
				TRB->NOMEANA := _cNomeAna
				TRB->STATUOS := _cstat
				TRB->DTSAID  := _dDtSai
				TRB->NUMPV   := _cNumPV
				TRB->NUMNF   := _cNumNF
				TRB->EMISNF  := _dEmisNF
				TRB->CLIENTE :=_cclient
				TRB->LOJA    :=_clojacl
				TRB->NOMENT  :=_cnomecl
				TRB->ESTADO  :=_cestado
				TRB->FASEMAXS :=_cfasmxs
				TRB->SETFMAXS :=_csetmxs
				TRB->GRAUMAXS :=_graumxs
				TRB->GARANTIA :=_cgarant
				TRB->GARMCLAI :=_cgarmcl
			else
				_cQuery := "select B1_DESC "
				_cQuery += "from ZZ4020 AS ZZ4 "
				_cQuery += "inner join SB1020 AS SB1 ON B1_COD = ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
				_cQuery += "where ZZ4.ZZ4_OS = '" + _cOS + "' and ZZ4.D_E_L_E_T_ <> '*' "
				TCQUERY _cQuery NEW ALIAS "QRY0"  
				_cdesc	:= QRY0->B1_DESC
				QRY0->(dbCloseArea())

				TRB->IMEI     := _cIMEI
				TRB->OS       := _cOS
				TRB->PRODUTO  := _cProduto
				TRB->DESCRICAO:= _cdesc
				//Grava o conte๚do obtido nas variแveis de partnumbers nos campos de partnumbers correspondente na tabela temporแria -  Edson Rodrigues 04/03/10
				If len(_apartnr) > 0
					For x:=1 to len(_apartnr)
						IF X <= nmaxpn
							cCMPTab:='TRB->PARTN'+STRZERO(X,3)
							&cCMPTab:=_apartnr[x,1]
						ENDIF
					Next
				Endif
			endif	

			msunlock()
			//_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6  := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := "" 
			//_cPartN11 := _cPartN12  := _cPartN13  := _cPartN14  := _cPartN15  := _cPartN16 := _cPartN17  := _cPartN18  := _cPartN19  := _cPartN20 := ""
			
			//apaga cont้udo das variแveis em uso dentro desse while   Edson Rodrigues 04/03/10
			For x:=1 to nmaxpn
				cCampo:='_cPARTN'+STRZERO(X,3)
				&cCampo:=space(20)
			Next
			_apartnr := {}
			_cLaudo1 := _cDesLau1 := _cLaudo2  := _cDesLau2 := _cLaudo3  := _cDesLau3 := _cLaudo4  := _cDesLau4 := ""
			
		endif
		
		_cOS :=   _cASM := _cIMEI    := _cSerial  := _cCodFase := _cDesFase := _cProduto := _cGrupo := ""
		_cNexSint := _cNexSolu := _cLaudo   := _cCodTec  := _cNomeTec := _cCodAna := _cNomeAna := _cDesLaudo := ""
      //	_cPartN1  := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5 :=  _cPartN6 :=  ""
		_cSrvloc  :=  _cAction  := _cNexAct :=  _cclient  := _clojacl  := _cnomecl  := _cestado := ""
		_cNumPV   := _cNumNF   := _cDesSint := _cDesSolu := ""
		_dDtEntr  := _dDtAtend := _dDtSai   := _dEmisNF  := ctod("  /  /  ")
	   //	_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6  := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""  
	   //	_cPartN11 := _cPartN12  := _cPartN13  := _cPartN14  := _cPartN15  := _cPartN16 := _cPartN17  := _cPartN18  := _cPartN19  := _cPartN20 := ""
		_cLaudo1 := _cDesLau1 := _cLaudo2  := _cDesLau2 := _cLaudo3  := _cDesLau3 := _cLaudo4  := _cDesLau4 := ""
		_nvaluni := _nbounce  := 0.00
		_cdefinf := _cDesdinf := _cdefdet  := _cDesddet := _cimeswap := ""
		_cfasmxs   := _csetmxs   :=_cdesmxs   :=_graumxs :=_cgarant  :=_cgarmcl :=_chrAtend := ""
		_cResets :=  0
		
		//Renova cont้udo das variแveis em uso dentro desse while   Edson Rodrigues 04/03/10 
       // For x:=1 to nmaxpn
       //     cCampo:='_cPARTN'+STRZERO(X,2)
       //     &cCampo:=space(20)
       // Next  	
		
	endif
enddo
QRY->(dbCloseArea())


if select("QR2") > 0
	ProcRegua(_nReg2)
	// Processa arquivo temporario da Query
	dbSelectArea("QR2")
	QR2->(dbGoTop())
	_cIMEI := ""
   // _cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6 := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""      
   //_cPartN11 := _cPartN12  := _cPartN13  := _cPartN14  := _cPartN15  := _cPartN16 := _cPartN17  := _cPartN18  := _cPartN19  := _cPartN20 := ""
	
	//Cria as variaveis de uso no  while  abaixo-  Edson Rodrigues 04/03/10
	For x:=1 to nmaxpn
		cCampo:='_cPARTN'+STRZERO(X,3)
		&cCampo:=space(20)
	Next
	_apartnr := {}
	
	
	TRB->(dbSetOrder(1))  // IMEI+0S
	
	while QR2->(!eof())
		
		If MV_PAR03 == 1
			TRB->(dbGoTop())
			If TRB->(dbSeek((QR2->ZZ4_IMEI)+left(QR2->OS,6)))
				VERPRTN(QR2->ZZ4_IMEI,left(QR2->OS,6),QR2->ZZ3_SEQ)
				QR2->(dbSkip())
				LOOP
			ENDIF
		Endif
		
		IncProc( "Processando dados Qry de OSs nao report ... " )
     //_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6 := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""
		_cLab    := QR2->ZZ3_LAB
		_csetori := QR2->ZZ3_CODSET
		_csetdes := QR2->ZZ3_CODSE2
		_cstat   := QR2->STATUS
		_ctpfase := IIF(QR2->ZZ1_TIPO=='1','REPORTADA','NAO REPORTADA')
		_lok := .F.
		
		
		_cPartN := " SELECT Z9.* "
		_cPartN += " FROM   "+RetSqlName("SZ9")+" AS Z9 (nolock) "
		_cPartN += " WHERE  Z9_FILIAL  = '"+xFilial("SZ9")+"' AND "
		_cPartN += "        Z9_IMEI    = '"+QR2->ZZ4_IMEI+"' AND "
		_cPartN += "        LEFT(Z9_NUMOS,6) = '"+QR2->OS+"' AND "
		_cPartN += "        Z9_SEQ     = '"+QR2->ZZ3_SEQ+"' AND "
		_cPartN += "        Z9.D_E_L_E_T_ = '' AND Z9_STATUS='1'"
		_cPartN += " ORDER BY Z9_ITEM "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cPartN),"PARTNR",.T.,.T.)
		PARTNR->(dbGoTop())
		
		
		_cSintom := _cSoluca := _cAction := ""
		_nwhile := 0
		while PARTNR->(!eof())
			
			_cSintom := iif(empty(_cSintom) , PARTNR->Z9_SYMPTO , _cSintom )
			_cSoluca := iif(empty(_cSoluca) , PARTNR->Z9_ACTION , _cSoluca )
		_cAction := ""//iif(empty(_cSoluca), PARTNR->Z9_ACTION, _cAction)
			
			IF !EMPTY(PARTNR->Z9_PARTNR)
				_nwhile:=IIF(_nwhile=0,1,_nwhile)
				//alimenta as variaveis em  uso  com os conte๚dos de parnumbers encontrados -  Edson Rodrigues 04/03/10
				For x:=_nwhile to nmaxpn
					_lok:=.F.
					cCampo:='_cPARTN'+STRZERO(X,3)
                  //&cCampo:=space(20)
					IF MV_PAR11==1
						IF empty(alltrim(&cCampo))
							&cCampo  := alltrim(PARTNR->Z9_PARTNR)
							AADD(_apartnr,{alltrim(&cCampo)})
							_lok:=.T.
							_nwhile++
						Endif
					ELSEIF MV_PAR11==2 .AND. PARTNR->Z9_QTY=1
						IF empty(alltrim(&cCampo))
							&cCampo  := alltrim(PARTNR->Z9_PARTNR)
							AADD(_apartnr,{alltrim(&cCampo)})
							_lok:=.T.
							_nwhile++
						Endif
					ELSEIF MV_PAR11==2 .AND. PARTNR->Z9_QTY > 1
						For n:=1 to  PARTNR->Z9_QTY
							_lok:=.F.
							cCampo:='_cPARTN'+STRZERO(X,3)
							// &cCampo:=space(20)
							IF empty(alltrim(&cCampo))
								&cCampo  := alltrim(PARTNR->Z9_PARTNR)
								AADD(_apartnr,{alltrim(&cCampo)})
								x++
								_nwhile++
								_lok:=.T.
							ENDIF
						next
					ENDIF
					
					IF _lok
						EXIT
					ENDIF
					
				Next
				
			ENDIF
        /*      
        //Desabilitado para ser feito o tratamento pela valida็ใo acima - Edson Rodriguse  - 08/03/10
		Do Case 
			Case empty(_cPartN1)
				_cPartN1  := PARTNR->Z9_PARTNR
			Case empty(_cPartN2)
				_cPartN2  := PARTNR->Z9_PARTNR
			Case empty(_cPartN3)
				_cPartN3  := PARTNR->Z9_PARTNR
			Case empty(_cPartN4)
				_cPartN4  := PARTNR->Z9_PARTNR
            Case empty(_cPartN5)
				_cPartN5  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN6)
				_cPartN6  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN7)
				_cPartN7  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN8)
				_cPartN8  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN9)
				_cPartN9  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN10)
				_cPartN10 := PARTNR->Z9_PARTNR
			Case empty(_cPartN11)
				_cPartN11  := PARTNR->Z9_PARTNR
			Case empty(_cPartN12)
				_cPartN12  := PARTNR->Z9_PARTNR
			Case empty(_cPartN13)
				_cPartN13  := PARTNR->Z9_PARTNR
			Case empty(_cPartN14)
				_cPartN14  := PARTNR->Z9_PARTNR
            Case empty(_cPartN15)
				_cPartN15  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN16)
				_cPartN16  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN17)
				_cPartN17  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN18)
				_cPartN18  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN19)
				_cPartN19  := PARTNR->Z9_PARTNR
        	Case empty(_cPartN20)
				_cPartN20 := PARTNR->Z9_PARTNR	
	      EndCase 
		 */
			PARTNR->(dbSkip())
		enddo
		PARTNR->(dbCloseArea())
		
		if empty(_cIMEI) .or. QR2->ZZ1_GRAU > _cGrau
			_cIMEI    := QR2->ZZ4_IMEI
			_cOS      := QR2->OS
			_cASM     := QR2->ASM
			_cSerial  := QR2->ZZ4_CARCAC
			_cCodFase := QR2->ZZ3_FASE1
			_cDesFase := QR2->DESFASE
			_cCodFas2 := QR2->ZZ3_FASE2
			_cCodSet2 := IIF(EMPTY(QR2->ZZ3_CODSE2),QR2->ZZ3_CODSET,QR2->ZZ3_CODSE2)
			_cDesFas2 := Posicione("ZZ1",2,xFilial("ZZ1") + QR2->ZZ3_LAB + QR2->ZZ3_FASE2 + _cCodSet2 ,"ZZ1_DESFA1")
			_dDtEntr  := stod(QR2->DTENTR) //VerDtEntr(QRY->ZZ3_IMEI, QRY->OS)
			_dDtAtend := stod(QR2->ZZ3_DATA)
			_cfasmxs  := QR2->ZZ4_FASMAX
			_csetmxs  := QR2->ZZ4_SETMAX
//			_cdesmxs  := QR2->ZZ4_DFAMAX
			_graumxs  := QR2->ZZ4_GRMAX
			_cgarant  := QR2->ZZ4_GARANT
			_cgarmcl  := QR2->ZZ4_GARMCL
			_chrAtend := QR2->ZZ3_HORA
			_cProduto := QR2->ZZ4_CODPRO
			_cGrupo   := Posicione("SB1",1,xFilial("SB1") + QR2->ZZ4_CODPRO , "B1_GRUPO")
			_cNexSint := iif(!empty(_cSintom), _cSintom, _cNexSint)
			_cNexSolu := iif(!empty(_cSoluca), _cSoluca, _cNexSolu)
			_cNexAct  := iif(!empty(_cAction), _cAction, _cNexAct )
			_cdefinf  := iif(!empty(_cdefinf),_cdefinf,IIF(!EMPTY(QR2->ZZ4_DEFINF),QR2->ZZ4_DEFINF,QR2->ZZ3_DEFINF))
			_cDesdinf := Posicione("ZZG",1,xFilial("ZZG") + QR2->ZZ3_LAB + _cdefinf, "ZZG_DESCRI" )
			_cdefdet  := iif(!empty(_cdefdet),_cdefdet,IIF(!EMPTY(QR2->ZZ4_DEFDET),QR2->ZZ4_DEFDET,QR2->ZZ3_DEFDET))
			_cDesddet := Posicione("ZZG",1,xFilial("ZZG") + QR2->ZZ3_LAB + _cdefdet, "ZZG_DESCRI" )
			_nbounce  := QR2->ZZ4_BOUNCE
			_cimeswap := QR2->IMEISWAP
			_cCodTec  := QR2->ZZ3_CODTEC
			_cNomeTec := QR2->NOMTEC    
			_cCodAna  := QR2->ZZ3_CODANA
			_cNomeAna := QR2->NOMANA
			_dDtSai   := stod(QR2->ZZ4_NFSDT) //VerDtSai(QRY->AB9_SN, QRY->AB9_NUMOS)
			_cSrvloc  := QR2->SERVLOC
			_cGrau    := QR2->ZZ1_GRAU
			_cclient  := QR2->CLIENTE
			_clojacl  := QR2->LOJA
			_cnomecl  := Posicione("SA1",1,xFilial("SA1") + QR2->CLIENTE + QR2->LOJA, "A1_NREDUZ")
			_cestado  := Posicione("SA1",1,xFilial("SA1") + QR2->CLIENTE + QR2->LOJA, "A1_EST")
			_nvaluni  := QR2->VALUNIT
            _copebgh  := QR2->ZZ4_OPEBGH+"-"+ALLTRIM(Posicione("ZZJ",1,xFilial("ZZJ") + QR2->ZZ4_OPEBGH + QR2->ZZ3_LAB, "ZZJ_DESCRI" ))
			_cResets :=  QR2->ZZ3_QTDRES
		endif
		
		_cNumPV   := QR2->ZZ4_PV
		_cNumNF   := ALLTRIM(QR2->ZZ4_NFSNR)
		_dEmisNF  := stod(QR2->ZZ4_NFSDT)
		if !empty(QR2->ZZ3_LAUDO)
			do case
				case empty(_cLaudo1)
					_cLaudo1  := QR2->ZZ3_LAUDO
					_cDesLau1 := QR2->DESLAUDO
				case empty(_cLaudo2)
					_cLaudo2  := QR2->ZZ3_LAUDO
					_cDesLau2 := QR2->DESLAUDO
				case empty(_cLaudo3)
					_cLaudo3  := QR2->ZZ3_LAUDO
					_cDesLau3 := QR2->DESLAUDO
				case empty(_cLaudo4)
					_cLaudo4  := QR2->ZZ3_LAUDO
					_cDesLau4 := QR2->DESLAUDO
			endcase
		endif
		
		QR2->(dbSkip())
		
	  // MV_PAR03 => 1 = Pecas / 2 = Tecnicos 
      //Quando for Tecnico pega todas as fases/IMEIS
	  //Quando for Pecas e se parametro tipo de Fases reportada ou nao reportada pega somente um e-mail.
	  //Quando for Pecas e se parametro tipo de Fases todas 
	  //if MV_PAR03 == 2 .or. (MV_PAR03 == 1 .and. (QRY->(eof()) .or. IIF(MV_PAR10==3,.T.,_cIMEI <> QRY->ZZ4_IMEI))) //.and. ; 
      if MV_PAR03 == 2 .or. (MV_PAR03 == 1 .and. (QR2->(eof()) .or. (_cIMEI+_cOS <> QR2->ZZ4_IMEI+QR2->OS))) //.and. ;     
		// MV_PAR04 => 1 = Tudo  / 2 = Com NF   / 3 = Sem NF
			
			if MV_PAR04 == 1 .or. (MV_PAR04 == 2 .and. !empty(_cNumNF) .and. _dEmisNF >= MV_PAR05 .and. _dEmisNF <= MV_PAR06) .or. ;
				(MV_PAR04 == 3 .and. empty(_cNumNF))
				
				reclock("TRB",.t.)
				if mv_par12 == 1
					TRB->IMEI     := _cIMEI
					TRB->SERIAL   := _cSerial
					TRB->OS       := _cOS
					TRB->LABOR    := _cLab
					TRB->CODFASE  := _cCodFase
					TRB->FASE	  := _cDesFase
					TRB->SETORIG  := _csetori
					TRB->CODFAS2  := _cCodFas2
					TRB->FASE2	  := _cDesFas2
					TRB->SETDEST  := _csetdes
					TRB->TIPOFASE := _ctpfase
					TRB->GRAU     := _cGrau
					TRB->DTENTR   := _dDtEntr
					TRB->DTATEN   := _dDtAtend
					TRB->HRATEN   := _chrAtend
					TRB->PRODUTO  := _cProduto
					TRB->GRUPO    := _cGrupo
					TRB->VALUNIT  := _nvaluni
					TRB->OPEBGH   := _copebgh
					TRB->RESETS := _cResets
					//Grava o conte๚do obtido nas variแveis de partnumbers nos campos de partnumbers correspondente na tabela temporแria -  Edson Rodrigues 04/03/10
					If len(_apartnr) > 0
						For x:=1 to len(_apartnr)
							IF X <= nmaxpn
								cCMPTab:='TRB->PARTN'+STRZERO(X,3)
								&cCMPTab:=_apartnr[x,1]
							ENDIF
						Next
					Endif
					
					TRB->SYMCODE  := _cNexSint
					TRB->DESC_SYM := Posicione("SZ8",1,xFilial("SZ8") + _cLab + _cNexSint, "Z8_DESSINT")
					TRB->NEXSOLU  := _cNexSolu
					TRB->DESC_SOL := Posicione("SZ8",2,xFilial("SZ8") + _cLab + _cNexSolu, "Z8_DESSOLU")
					TRB->LAUDO1   := _cLaudo1
					TRB->DESLAU1  := _cDesLau1
					TRB->LAUDO2   := _cLaudo2
					TRB->DESLAU2  := _cDesLau2
					TRB->LAUDO3   := _cLaudo3
					TRB->DESLAU3  := _cDesLau3
					TRB->LAUDO4   := _cLaudo4
					TRB->DESLAU4  := _cDesLau4
					TRB->ASM      := _cASM
					TRB->DEFINF   := _cdefinf
					TRB->DESDINF  := _cDesdinf
					TRB->DEFDET   := _cdefdet
					TRB->DESDDET  := _cDesddet
					TRB->BOUNCE   := _nbounce
					TRB->IMEISWAP := _cimeswap
					TRB->ACAO     := _cNexAct
					TRB->SERVLOC  := _cSrvloc
					TRB->CODTEC   := _cCodTec
					TRB->NOMETEC  := _cNomeTec
					TRB->ANALISTA := _cCodAna
					TRB->NOMEANA  := _cNomeAna
					TRB->STATUOS  := _cstat
					TRB->DTSAID   := _dDtSai
					TRB->NUMPV    := _cNumPV
					TRB->NUMNF    := _cNumNF
					TRB->EMISNF   := _dEmisNF
					TRB->CLIENTE  :=_cclient
					TRB->LOJA     :=_clojacl
					TRB->NOMENT   :=_cnomecl
					TRB->ESTADO   :=_cestado
					TRB->NOMENT   :=_cnomecl
					TRB->ESTADO   :=_cestado
					TRB->FASEMAXS :=_cfasmxs
					TRB->SETFMAXS :=_csetmxs
					TRB->GRAUMAXS :=_graumxs
					TRB->GARANTIA :=_cgarant
					TRB->GARMCLAI :=_cgarmcl
				else                          
				
					_cQuery := "select B1_DESC "
					_cQuery += "from ZZ4020 AS ZZ4 "
					_cQuery += "inner join SB1020 AS SB1 ON B1_COD = ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
					_cQuery += "where ZZ4.ZZ4_OS = '" + _cOS + "' and ZZ4.D_E_L_E_T_ <> '*' "
					TCQUERY _cQuery NEW ALIAS "QRY0"  
					_cdesc	:= QRY0->B1_DESC
					QRY0->(dbCloseArea())

					TRB->IMEI     := _cIMEI
					TRB->OS       := _cOS
					TRB->PRODUTO  := _cProduto
					TRB->DESCRICAO:= _cdesc
					//Grava o conte๚do obtido nas variแveis de partnumbers nos campos de partnumbers correspondente na tabela temporแria -  Edson Rodrigues 04/03/10
					If len(_apartnr) > 0
						For x:=1 to len(_apartnr)
							IF X <= nmaxpn
								cCMPTab:='TRB->PARTN'+STRZERO(X,3)
								&cCMPTab:=_apartnr[x,1]
							ENDIF
						Next
					Endif
				endif	
				
				msunlock()
			//_cPartN1 := _cPartN2  := _cPartN3  := _cPartN4  := _cPartN5  := _cPartN6  := _cPartN7  := _cPartN8  := _cPartN9  := _cPartN10 := ""    
			//_cPartN11 := _cPartN12  := _cPartN13  := _cPartN14  := _cPartN15  := _cPartN16 := _cPartN17  := _cPartN18  := _cPartN19  := _cPartN20 := ""
				_cLaudo1 := _cDesLau1 := _cLaudo2  := _cDesLau2 := _cLaudo3  := _cDesLau3 := _cLaudo4  := _cDesLau4 := ""
				
				//Renova cont้udo das variแveis em uso dentro desse while   Edson Rodrigues 04/03/10
				For x:=1 to nmaxpn
					cCampo  :='_cPARTN'+STRZERO(X,3)
					&cCampo :=space(20)
				Next
			endif
			
			_apartnr := {}
			
			_cOS       := _cASM      := _cIMEI    := _cSerial  := _cCodFase := _cDesFase  := _cProduto := _cGrupo := ""
			_cNexSint  := _cNexSolu  := _cLaudo   := _cCodTec  := _cNomeTec := _cCodAna := _cNomeAna := _cDesLaudo := ""
      //	_cPartN1:= _cPartN2   := _cPartN3   := _cPartN4  := _cPartN5  :=  _cPartN6   :=  ""
			_cSrvloc   := _cAction   := _cNexAct  :=  _cclient := _clojacl  := _cnomecl    := _cestado := ""
			_cNumPV    := _cNumNF    := _cDesSint := _cDesSolu := ""
			_dDtEntr   := _dDtAtend  := _dDtSai   := _dEmisNF  := ctod("  /  /  ")
	   //	_cPartN1   :=_cPartN2 := _cPartN3   := _cPartN4  := _cPartN5  := _cPartN6  := _cPartN7  := _cPartN8   := _cPartN9  := _cPartN10 := ""  
	   //	_cPartN11  :=_cPartN12:= _cPartN13  := _cPartN14 := _cPartN15 := _cPartN16 := _cPartN17 := _cPartN18  := _cPartN19  := _cPartN20 := ""
			_cLaudo1   := _cDesLau1  := _cLaudo2  := _cDesLau2 := _cLaudo3  := _cDesLau3 := _cLaudo4  := _cDesLau4 := ""
			_nvaluni   := _nbounce   := 0.00
			_cdefinf   := _cDesdinf  := _cdefdet  := _cDesddet := _cimeswap := ""
			_cfasmxs   := _csetmxs   :=_graumxs :=_cgarant  :=	_cgarmcl  := _chrAtend := "" // _cdesmxs :=
			_cResets :=  0
			
	   //Renova cont้udo das variแveis em uso dentro desse while   Edson Rodrigues 04/03/10 
     //  For x:=1 to nmaxpn
     //       cCampo:='_cPARTN'+STRZERO(X,2)
     //       &cCampo:=space(20)
      //  Next  	
			
		endif
	enddo
	QR2->(dbCloseArea())
Endif


//_cNomePlan := iif(MV_PAR03 == 1, "pecas_novo.xls", "tecnicos_novo.xls")
_cNomePlan := iif(MV_PAR03 == 1, "pecas_novo.csv", "tecnicos_novo.csv")

dbSelectArea("TRB")
TRB->(dbgotop())

_cArqTmp := lower(AllTrim(__RELDIR)+_cNomePlan)    
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
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

TRB->(dbCloseArea())               


//Deleta o arquivo temporario - Edson Rodrigues - 30/08/10
_carqtemp:=_cArqSeq+".dtc"
If MsErase(_carqtemp,cindarqt)
  //  MsgAlert( "Arquivo Temporario excluido com Sucesso" ) 
Else
   MsgAlert( "Problemas ao deletar o arquivo Temporario, Print a tela e informe ao Administrador do sistema " ) 
Endif

//Copy to &_cArqTmp VIA "DBFCDXADS"
//ApMsgInfo("Fim do Processamento. A planilha "+_cNomePlan+" foi gerada em " + __reldir)

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERDTENTR บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  19/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica data da entrada massiva.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VerDtEntr(_cCodBar, _cNumOs)

local _aAreaSZ1 := SZ1->(GetArea())
local _dDtEntr  := ctod("  /  /  ")

SZ1->(dbSetOrder(10))  // Z1_FILIAL + Z1_OS + Z1_CODBAR + Z1_TIPO + Z1_STNFE
if SZ1->(dbSeek(xFilial("SZ1") + left(_cNumOs,6) + _cCodBar))
	
	while SZ1->(!eof()) .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_CODBAR == _cCodBar .and. SZ1->Z1_OS == left(_cNumOs,6)
		
		_dDtEntr := iif(!empty(_dDtEntr) .and. _dDtEntr < SZ1->Z1_DATA, _dDtEntr, SZ1->Z1_DATA)
		SZ1->(dbSkip())
		
	enddo
	
endif

restarea(_aAreaSZ1)

return(_dDtEntr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VERDTSAI บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  26/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica data da saida do aparelho atraves de Notas Fiscaisบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VerDtSai(_cCodBar, _cNumOs)

local _aAreaSC6 := SC6->(GetArea())
local _aAreaSD2 := SD2->(GetArea())
local _dDtSai   := ctod("  /  /  ")
local _cNumPV   := _cNumNF := ""

//SC6->(dbSetOrder(9))  // C6_FILIAL + C6_NUMSERI
SC6->(DBOrderNickName('SC6IMEI'))// C6_FILIAL + C6_NUMSERI
if SC6->(dbSeek(xFilial("SC6") + _cCodBar))
	
	while SC6->(!eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUMSERI == _cCodBar
		
		if left(SC6->C6_NUMOS,8) == _cNumOS .and. !empty(SC6->C6_NOTA)
			_cNumPV := SC6->C6_NUM + SC6->C6_ITEM
			_cNumNF := ALLTRIM(SC6->C6_NOTA)
		endif
		SC6->(dbSkip())
		
	enddo
	
endif

if !empty(_cNumPV)
	
	SD2->(dbSetOrder(8))  // D2_FILIAL + D2_PEDIDO + D2_ITEMPV
	if SD2->(dbSeek(xFilial("SD2") + _cNumPV)) .and. ALLTRIM(SD2->D2_DOC) == ALLTRIM(_cNumNF)
//		SF2->(dbSetOrder(1))
//		SF2->(dbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA))
//		_dDtSai := iif(!empty(SF2->F2_DTDOCA), SF2->F2_DTDOCA, SD2->D2_EMISSAO)
		_dDtSai := SD2->D2_EMISSAO
	endif
	
endif

restarea(_aAreaSC6)
restarea(_aAreaSD2)

return(_dDtSai)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data Atend Inicial?"	,"Data Atend Inicial?"	,"Data Atend Inicial?"	,"mv_ch1","D",08,0,0,"G","",""	,"",,"mv_par01",""	   		,"","","",""				,"","",""		,"","","","","","","","")
PutSX1(cPerg,"02","Data Atend Final?"	,"Data Atend Final?"	,"Data Atend Final?"	,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02",""	   		,"","","",""	   			,"","",""		,"","","","","","","","")
PutSX1(cPerg,"03","Tipo Planilha?"		,"Tipo Planilha?"		,"Tipo Planilha?"		,"mv_ch3","N",01,0,0,"C","",""	,"",,"mv_par03","Pecas"		,"","","","Tecnicos"		,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Status"				,"Status"				,"Status"				,"mv_ch4","N",01,0,0,"C","",""	,"",,"mv_par04","Tudo"		,"","","","Com NF"			,"","","Sem NF"	,"","","","","","","","")
PutSX1(cPerg,"05","Data Saida Inicial?"	,"Data Saida Inicial?"	,"Data Saida Inicial?"	,"mv_ch5","D",08,0,0,"G","",""	,"",,"mv_par05",""			,"","","",""				,"","",""		,"","","","","","","","")
PutSX1(cPerg,"06","Data Saida Final?"	,"Data Saida Final?"	,"Data Saida Final?"	,"mv_ch6","D",08,0,0,"G","",""	,"",,"mv_par06",""	   		,"","","",""				,"","",""		,"","","","","","","","")
PutSX1(cPerg,"07","Laboratorio?"		,"Laboratorio?"			,"Laboratorio?"			,"mv_ch7","C",06,0,0,"C","","LB","",,"mv_par07",""      	,"","","",""			    ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"08","Fase(s)?"			,"Fase(s)?"				,"Fase(s)?"				,"mv_ch8","C",40,0,0,"G","",""	,"",,"mv_par08",""			,"","","",""				,"","",""		,"","","","","","","","")
PutSX1(cPerg,"09","Setor(es)?"			,"Setor(es)?"			,"Setor(es)?"			,"mv_ch9","C",99,0,0,"G","",""	,"",,"mv_par09",""			,"","","",""				,"","",""		,"","","","","","","","")
PutSX1(cPerg,"10","Tipo de Fases?"		,"Tipo de Fases?"		,"Tipo de Fases?"		,"mv_ch10","N",01,0,0,"C","",""	,"",,"mv_par10","Reportada"	,"","","","Nao Reportada"	,"","","Todas"	,"","","","","","","","")
PutSX1(cPerg,"11","Considera Partnumber?","Considera Partnumber?","Considera Partnumber?","mv_ch11","N",01,0,0,"C","","","",,"mv_par11","Individual"	,"","","","Multiplo"	,"","",""	,"","","","","","","","")
PutSX1(cPerg,"12","Tipo de Relatorio ?"	,"Tipo de Relatorio ?","Tipo de Relatorio ?"	,"mv_ch12","N",01,0,0,"C","",""	,"",,"mv_par12","Normal","","","","Resumido"	,"","",""	,"","","","","","","","")
Return Nil





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ MAXPRN  บAutor  ณEdson Rodrigues      บ Data ณ  03/03/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao verificar o maximo de partnumber para cria็ao da   บฑฑ
ฑฑบ          | colunas                                                   บฑฑ
ฑฑบ          ณ                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function maxprn(_nReg1,_nReg2,_cFilFas,_cFil08,_cFil09,_cCodLab)

Local cSelec  :=""
local  CR        := chr(13) + chr(10)
local  nmaxptn := 0

//ProcRegua(_nReg1)
   
//dbSelectArea("QRY")
//QRY->(dbGoTop())
                          
//while QRY->(!eof())             
if select("QRYMAX") > 0
	QRYMAX->(dbCloseArea())
Endif
  //  	IncProc( "Procurando maximo pe็as apont. QRY1... " )  
     
      //cSelec  := CR + " SELECT SUM(Z9_QTY) QTDE , COUNT(*) CONTA, Z9_NUMOS, Z9_IMEI "
      //cSelec += CR + " FROM "+RetSqlName("SZ9")+"   "
      //cSelec += CR + " WHERE D_E_L_E_T_ = ' ' "
      //cSelec += CR + " AND Z9_PARTNR <> ' '   "                                        
      //cSelec += CR + " AND Z9_FILIAL ='"+xFilial("SZ9")+"'  "
      //cSelec += CR + " AND Z9_IMEI    = '"+QRY->ZZ4_IMEI+"'  "
	   //cSelec += CR + " AND LEFT(Z9_NUMOS,6) = '"+QRY->OS+"'
      //cSelec += CR + " AND Z9_SEQ     = '"+QRY->ZZ3_SEQ+"' "
 	   //cSelec += CR + " AND Z9_STATUS = '1' "
      //cSelec += CR + " GROUP BY Z9_NUMOS,Z9_IMEI "

cSelec  := CR + "  SELECT TOP 1 SUM(Z9_QTY) QTDE , COUNT(Z9_PARTNR) CONTA, Z9_NUMOS, Z9_IMEI "
cSelec += CR + "  FROM "+RetSqlName("SZ9")+"  (NOLOCK) "
cSelec += CR + "  INNER JOIN (SELECT ZZ3_FILIAL,ZZ3_IMEI,ZZ3_NUMOS,ZZ3_SEQ,ZZ3_LAB,ZZ3_FASE1,ZZ3_CODSET "
cSelec += CR + "                       FROM "+RetSqlName("ZZ3")+" (NOLOCK) "
cSelec += CR + "                       INNER JOIN  (SELECT ZZ4_FILIAL,ZZ4_IMEI,ZZ4_OS "
cSelec += CR + "                                             FROM "+RetSqlName("ZZ4")+" Z4 (NOLOCK) "
cSelec += CR + "                                             WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND D_E_L_E_T_=''
IF MV_PAR04==3
	cSelec += CR + "                                           AND Z4.ZZ4_NFSNR='' ) AS ZZ4 "
Elseif MV_PAR04==2
	cSelec += CR + "                                           AND Z4.ZZ4_NFSDT >='"+dtos(MV_PAR05)+"' AND  Z4.ZZ4_NFSDT <='"+dtos(MV_PAR06)+"' AND Z4.ZZ4_NFSNR<>'' )  AS ZZ4 "
ELSE
	cSelec += CR + "                                             ) AS ZZ4 "
ENDIF
cSelec += CR + "                         ON  ZZ3_IMEI=ZZ4.ZZ4_IMEI AND LEFT(ZZ3_NUMOS,6) = LEFT(ZZ4.ZZ4_OS,6) "
cSelec += CR + "                         INNER JOIN  (SELECT ZZ1_FILIAL,ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1 FROM "+RetSqlName("ZZ1")+" (NOLOCK) "
cSelec += CR + "                                               WHERE D_E_L_E_T_ = '' AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' "
IF MV_PAR10 = 1
	cSelec += CR + "                                                 AND ZZ1_TIPO= '1' )  AS ZZ1 "
ELSEIF MV_PAR10 = 2
	cSelec += CR + "                                                 AND ZZ1_TIPO = '2' )  AS ZZ1 "
ELSE
	cSelec += CR + "                                                )  AS ZZ1 "
ENDIF
cSelec += CR + "                        ON ZZ1_LAB = ZZ3_LAB AND ZZ1_CODSET = ZZ3_CODSET AND ZZ1_FASE1 = ZZ3_FASE1  "
cSelec += CR + "                    WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' "
cSelec += CR + "                    AND ZZ3_LAB    = '"+_cCodLab+"' "
cSelec += CR + "                    AND ZZ3_DATA   >='"+dtos(mv_par01)+"' AND  ZZ3_DATA <='"+dtos(mv_par02)+"' "
cSelec += CR + "                    AND ZZ3_STATUS='1' "
cSelec += CR + "                    AND ZZ3_ESTORN<>'S' "
cSelec += CR + "                     "+_cFil08
cSelec += CR + "                     "+_cFil09+ " ) AS ZZ3 "
cSelec += CR + "  ON    ZZ3_FILIAL=Z9_FILIAL AND ZZ3_IMEI=Z9_IMEI AND ZZ3_NUMOS=Z9_NUMOS AND  ZZ3_SEQ=Z9_SEQ "
cSelec += CR + "  WHERE D_E_L_E_T_ = ' ' "
cSelec += CR + "  AND Z9_PARTNR <> '  '   "
cSelec += CR + "  AND Z9_FILIAL ='"+xFilial("SZ9")+"'  "
cSelec += CR + "  AND Z9_STATUS = '1'  "
cSelec += CR + "  GROUP BY Z9_NUMOS,Z9_IMEI  "
cSelec += CR + "  ORDER BY 1 DESC  "


// Gera arquivos temporario com resultado da Query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSelec),"QRYMAX",.T.,.T.)

DBSELECTAREA("QRYMAX")
QRYMAX->(dbGoTop())

if select("QRYMAX") > 0
	If    MV_PAR11==1
		IF nmaxptn < QRYMAX->CONTA
			nmaxptn:=QRYMAX->CONTA
		Endif
	Else
		IF nmaxptn < QRYMAX->QTDE
			nmaxptn:=QRYMAX->QTDE
		Endif
	Endif
Else
	QRYMAX->(dbCloseArea())
Endif

DBSELECTAREA("QRYMAX")
QRY->(DBSKIP())

//Enddo

//If  select("QR2") > 0 
//    ProcRegua(_nReg2)
//    dbSelectArea("QR2")
//    QR2->(dbGoTop())
                          
//    while QR2->(!eof())             
//      if select("QRYMAX") > 0
//         QRYMAX->(dbCloseArea())
//     Endif 
//     	    	IncProc( "Procurando maximo pe็as apont. QRY2 ... " )  
     
//      cSelec  := CR + " SELECT SUM(Z9_QTY) QTDE , COUNT(*) CONTA, Z9_NUMOS, Z9_IMEI "
//      cSelec += CR + " FROM "+RetSqlName("SZ9")+"   "
//      cSelec += CR + " WHERE D_E_L_E_T_ = ' ' "
//      cSelec += CR + " AND Z9_PARTNR <> '  ' "
//      cSelec += CR + " AND Z9_FILIAL ='"+xFilial("SZ9")+"'  "
//      cSelec += CR + " AND Z9_IMEI    = '"+QR2->ZZ4_IMEI+"'  "
//	  cSelec += CR + " AND LEFT(Z9_NUMOS,6) = '"+QR2->OS+"'
	  //cSelec += CR + " AND  Z9_SEQ     = '"+QR2->ZZ3_SEQ+"' "
// 	  cSelec += CR + " AND Z9_STATUS = '1' "
//      cSelec += CR + " GROUP BY Z9_NUMOS,Z9_IMEI "
                                                                           
     // Gera arquivos temporario com resultado da Query
 //    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSelec),"QRYMAX",.T.,.T.)
     
 //    DBSELECTAREA("QRYMAX")
 //    QRYMAX->(dbGoTop())

//     if select("QRYMAX") > 0
//	    If    MV_PAR11==1                    
//	        IF nmaxptn < QRYMAX->CONTA
//	            nmaxptn:=QRYMAX->CONTA
//	        Endif    
//	    Else    
//	       IF nmaxptn < QRYMAX->QTDE
//	            nmaxptn:=QRYMAX->QTDE
//	        Endif    
 //	    Endif 	     
//	 Else    
//	     QRYMAX->(dbCloseArea())
//     Endif
         
//     DBSELECTAREA("QRYMAX")
//     QR2->(DBSKIP())

//    Enddo
//Endif
///IIF(nmaxptn>0,nmaxptn++,nmaxptn)
 
return(nmaxptn)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออ ปฑฑ
ฑฑบPrograma  ณ VERPRTN  บAutor  ณEdson Rodrigues     บ Data ณ  30/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao verificar se existe partnumber gravado para OS      บฑฑ
ฑฑบ          | nใo reportadas, mas que jแ foram gravadas no               บฑฑ
ฑฑบ          ณ na tabela temporแria TRB como reportadas, acrescenta esses บฑฑ
ฑฑบ          | partnumbers encontrados                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION VERPRTN(_CIMEI,_COS,_CSEQ)

_cPartN := " SELECT Z9.* "
_cPartN += " FROM   "+RetSqlName("SZ9")+" AS Z9 (nolock) "
_cPartN += " WHERE  Z9_FILIAL  = '"+xFilial("SZ9")+"' AND "
_cPartN += "        Z9_IMEI    = '"+_CIMEI+"' AND "
_cPartN += "        LEFT(Z9_NUMOS,6) = '"+_COS+"' AND "
_cPartN += "        Z9_SEQ     = '"+_CSEQ+"' AND "
_cPartN += "        Z9_PARTNR <>  '' AND "
_cPartN += "        Z9.D_E_L_E_T_ = '' AND Z9_STATUS='1'"
_cPartN += " ORDER BY Z9_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cPartN),"PARTNR",.T.,.T.)
PARTNR->(dbGoTop())
_nwhile    :=0

While PARTNR->(!eof())
	_nwhile:=iif(_nwhile=0,1,_nwhile)
	
	IF !EMPTY(PARTNR->Z9_PARTNR)
		//alimenta as variaveis em  uso  com os conte๚dos de parnumbers encontrados para OS nใo reportadas e que acaso tenha partnumbers-  Edson Rodrigues 04/03/10
		For x:=_nwhile to nmaxpn
			_lok:=.F.
			cCMPTab:='TRB->PARTN'+STRZERO(X,3)
			IF EMPTY(&cCMPTab) .AND. MV_PAR11==1
				reclock("TRB",.f.)
				&cCMPTab:=PARTNR->Z9_PARTNR
				msunlock()
				_nwhile++
				_lok:=.t.
				
			ELSEIF EMPTY(&cCMPTab) .AND. MV_PAR11==2 .AND. PARTNR->Z9_QTY=1
				reclock("TRB",.f.)
				&cCMPTab:=PARTNR->Z9_PARTNR
				msunlock()
				_nwhile++
				_lok:=.t.
				
			ELSEIF EMPTY(&cCMPTab) .AND. MV_PAR11==2 .AND. PARTNR->Z9_QTY > 1
				For n:=1 to  PARTNR->Z9_QTY
					_lok:=.F.
					cCMPTab:='TRB->PARTN'+STRZERO(X,3)
					IF empty(alltrim(&cCMPTab))
						reclock("TRB",.f.)
						&cCMPTab:=PARTNR->Z9_PARTNR
						msunlock()
						X++
						_nwhile++
						_lok:=.t.
					ENDIF
				next
			ENDIF
			
			iF _lok
				EXIT
			ENDIF
		Next
	Endif
	PARTNR->(DBSKIP())
Enddo

PARTNR->(dbCloseArea())

Return()