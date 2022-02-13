#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX035 บAutor  ณM.Munhoz - ERPPLUS  บ Data ณ  16/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha de saldos de aparelhos   บฑฑ
ฑฑบ          ณ em estoque por status / fase                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECRX035()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Saldos em estoque de aparelhos por Status / Fase "
Local cDesc1  := "Exportacao dos saldos em estoque de aparelhos celulares por Status e Fases "
Local cDesc2  := ""
Local cDesc3  := ""
Local cDesc4  := "Especifico BGH"

Private cPerg := "TECX35"
private _csrvapl :=ALLTRIM(GetMV("MV_SERVAPL"))


u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Cria o grupo de perguntas no SX1 automaticamente             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| TECRX35A(@lEnd)}, "Aguarde...","Calculando saldos em estoque ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECRX035 บAutor  ณMicrosiga           บ Data ณ 16/02/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao de planilha de saldos de aparelhos   บฑฑ
ฑฑบ          ณ em estoque por status / fase                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TECRX35A(lEnd)

private _cDiret    := __RELDIR //"\relato\gerencial\"
private _lContinua := .t.

// Consulta saldos por STATUS
if _lContinua
	CriaQRY1()
endif

// Consulta saldos por FASE
if _lContinua
	CriaQRY2()
endif

// Abre Excel
if _lContinua
	AbreXls()
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIAQRY1 บAutor  ณMicrosiga           บ Data ณ 16/02/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ consulta de saldos de aparelhos por STATUS                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaQRY1()

local _cQuery := ""
local _Enter  := chr(13) + chr(10)
local _lOpen    := .f.
//local _cArquivo := "sld_est_status.xls"
local _cArquivo := "sld_est_status.cvs"

_cQuery += _Enter + " SELECT ZZ4_FILIAL, B1_GRUPO, ZZ4_CODPRO, ZZ4_STATUS, ZZ4_CODCLI, ZZ4_LOJA, A1_NREDUZ, ZZ4_LOCAL, STATUS, SALDO " 
_cQuery += _Enter + " FROM ("
_cQuery += _Enter + "        SELECT ZZ4_FILIAL, ZZ4_CODPRO, ZZ4_STATUS, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_LOCAL, " 
_cQuery += _Enter + "               STATUS = CASE WHEN ZZ4_STATUS = '1' THEN 'Entrada Massiva lida' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '2' THEN 'Entrada Massiva efetivada' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '3' THEN 'NFE gerada' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '4' THEN 'Em atendimento' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '5' THEN 'OS encerrada' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '6' THEN 'Saida Massiva lida' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '7' THEN 'Saida Massiva efetivada' " 
_cQuery += _Enter + "                             WHEN ZZ4_STATUS = '8' THEN 'PV gerado' END,  " 
_cQuery += _Enter + "               COUNT(*) SALDO " 
_cQuery += _Enter + "        FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) " 
_cQuery += _Enter + "        WHERE  ZZ4.D_E_L_E_T_ = ''  " 
_cQuery += _Enter + "               AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " 
_cQuery += _Enter + "               AND ZZ4_STATUS <> '9' " 
_cQuery += _Enter + "               AND ZZ4_CODPRO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' " 
if mv_par01 == 1  // Sony
	_cQuery += _Enter + "           AND '"+alltrim(getmv("MV_XSEDLOC"))+'/'+alltrim(getmv("MV_XSEMLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
else              // Nextel
	_cQuery += _Enter + "           AND '"+alltrim(getmv("MV_XNEXLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
endif
_cQuery += _Enter + "        GROUP BY ZZ4_FILIAL, ZZ4_CODPRO, ZZ4_STATUS, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_LOCAL " 
_cQuery += _Enter + " ) AS STATUS"
_cQuery += _Enter + " JOIN   "+RetSqlName("SB1")+" AS SB1 (NOLOCK) " 
_cQuery += _Enter + " ON     SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = ZZ4_CODPRO " 
_cQuery += _Enter + " JOIN   "+RetSqlName("SA1")+" AS SA1 (NOLOCK) "
_cQuery += _Enter + " ON     SA1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = ZZ4_CODCLI AND A1_LOJA = ZZ4_LOJA"
_cQuery += _Enter + " WHERE B1_GRUPO   BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
_cQuery += _Enter + " ORDER BY ZZ4_FILIAL, B1_GRUPO, ZZ4_CODPRO, ZZ4_STATUS " 

if select("TRB") > 0
	TRB->(dbCloseArea())
endif
//memowrite("TECRX035_STATUS.SQL",_cQuery )
_cQuery := strtran(_cQuery , _Enter, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
TRB->(dbGoTop())

_cArqSeq   :=CriaTrab(,.f.)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("TRB")
TRB->(dbgotop())
copy to &(cStartPath+_cArqSeq)
TRB->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_carquivo)
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



/*
While !_lOpen
	if file(_cDiret + _cArquivo) .and. ferase(_cDiret + _cArquivo) == -1 
		if !ApMsgYesNo("O arquivo " + _cArquivo + " nใo pode ser gerado porque deve estar sendo utilizado por outra rotina/software. Deseja tentar novamente? " )
			_lOpen     := .t.
			_lContinua := .f.
			ApMsgInfo("O arquivo Excel de Saldos em Estoque por Status nใo serแ gerado. ")
		endif
	else
		dbSelectArea("TRB")
		copy to (__RELDIR+"sld_est_status.xls") VIA "DBFCDXADS" //_cDiret + _cArquivo 
//		TRB->(dbCloseArea())
		_lOpen := .t.
	endif
enddo
*/


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIAQRY2 บAutor  ณMicrosiga           บ Data ณ 16/02/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ consulta de saldos de aparelhos por FASES DE ATENDIMENTO   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaQRY2()

local _cQuery   := ""
local _Enter    := chr(13) + chr(10)
local _lOpen    := .f.
//local _cArquivo := "sld_est_fases.xls"
local _cArquivo := "sld_est_fases.csv"

_cQuery += _Enter + " SELECT ZZ4.*, ZZ1_LAB, ZZ1_DESFA1, ZZ2_DESSET, A1_NREDUZ " 
_cQuery += _Enter + " FROM   ( " 
_cQuery += _Enter + "         SELECT ZZ4_FILIAL, B1_GRUPO, ZZ4_CODPRO, ZZ4_STATUS, COUNT(*) QUANT,  " 
_cQuery += _Enter + "                    ZZ4_SETATU, ZZ4_FASATU, ZZ4_LOCAL, ZZ4_CODCLI, ZZ4_LOJA " 
_cQuery += _Enter + "         FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (NOLOCK) " 
_cQuery += _Enter + "         JOIN   "+RetSqlName("SB1")+" AS SB1 (NOLOCK) " 
_cQuery += _Enter + "         ON     SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = ZZ4_CODPRO " 
_cQuery += _Enter + "         WHERE  ZZ4.D_E_L_E_T_ = ''  " 
_cQuery += _Enter + "                AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " 
_cQuery += _Enter + "                AND ZZ4_STATUS = '4' " 
_cQuery += _Enter + "                AND ZZ4_CODPRO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' " 
_cQuery += _Enter + "                AND B1_GRUPO   BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
if mv_par01 == 1  // Sony
	_cQuery += _Enter + "    AND '"+alltrim(getmv("MV_XSEDLOC"))+'/'+alltrim(getmv("MV_XSEMLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
else              // Nextel
	_cQuery += _Enter + "    AND '"+alltrim(getmv("MV_XNEXLOC"))+"' LIKE '%'+ZZ4.ZZ4_LOCAL+'%' "
endif
_cQuery += _Enter + "         GROUP BY ZZ4_FILIAL, B1_GRUPO, ZZ4_CODPRO, ZZ4_LOCAL, ZZ4_STATUS, ZZ4_SETATU, ZZ4_FASATU, ZZ4_CODCLI, ZZ4_LOJA " 
_cQuery += _Enter + "         ) AS ZZ4 " 
_cQuery += _Enter + " LEFT OUTER JOIN   "+RetSqlName("ZZ1")+" AS ZZ1 (NOLOCK) " 
_cQuery += _Enter + " ON     ZZ1.D_E_L_E_T_ = '' AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND  " 
_cQuery += _Enter + "        ZZ1_LAB    = '"+alltrim(str(mv_par01))+"' AND "
_cQuery += _Enter + "        ZZ1_CODSET = ZZ4_SETATU AND ZZ1_FASE1 = ZZ4_FASATU " 
_cQuery += _Enter + " LEFT OUTER JOIN   "+RetSqlName("ZZ2")+" AS ZZ2 (NOLOCK) " 
_cQuery += _Enter + " ON     ZZ2.D_E_L_E_T_ = '' AND ZZ2_FILIAL = '"+xFilial("ZZ2")+"' AND  " 
_cQuery += _Enter + "        ZZ2_LAB    = '"+alltrim(str(mv_par01))+"' AND "
_cQuery += _Enter + "        ZZ2_CODSET = ZZ4_SETATU  " 
_cQuery += _Enter + " JOIN   "+RetSqlName("SA1")+" AS SA1 (NOLOCK) "
_cQuery += _Enter + " ON     SA1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = ZZ4_CODCLI AND A1_LOJA = ZZ4_LOJA"
_cQuery += _Enter + " ORDER BY ZZ4_FILIAL, B1_GRUPO, ZZ4_CODPRO, ZZ4_STATUS, ZZ4_SETATU, ZZ4_FASATU " 

if select("QRY") > 0
	QRY->(dbCloseArea())
endif
//memowrite("TECRX035_FASES.SQL",_cQuery )
_cQuery := strtran(_cQuery , _Enter , "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)

_cArqSeq   :=CriaTrab(,.f.)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("QRY")
QRY->(dbgotop())
copy to &(cStartPath+_cArqSeq)
QRY->(dbCloseArea())

_cArqTmp := lower(AllTrim(__RELDIR)+_cArquivo)
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


/*
While !_lOpen
	if file(_cDiret + _cArquivo) .and. ferase(_cDiret + _cArquivo) == -1 
		if !ApMsgYesNo("O arquivo " + _cArquivo + " nใo pode ser gerado porque deve estar sendo utilizado por outra rotina/software. Deseja tentar novamente? " )
			_lOpen     := .t.
			_lContinua := .f.
			ApMsgInfo("O arquivo Excel de Saldos em Estoque por Fases nใo serแ gerado. ")
		endif
	else
		dbSelectArea("QRY")
		copy to (_cDiret + _cArquivo) VIA "DBFCDXADS"
//		copy to _cDiret + _cArquivo 
//		QRY->(dbCloseArea())
		_lOpen := .t.
	endif
enddo
*/


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ABREXLS  บAutor  ณMicrosiga           บ Data ณ 16/02/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AbreXls()

local _cArquivo  := "saldocel.xls"
local _cRootPath := getPvProfString(getEnvServer(), "RootPath", "ERROR", GetAdv97() )

ShellExecute( "Open" ,"\\"+_csrvapl+_cDiret+_cArquivo ,"", "" , 3 )

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณMicrosiga           บ Data ณ 16/02/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()

PutSX1(cPerg,'01','Laborat๓rio'                   ,'Laborat๓rio'                   ,'Laborat๓rio'                   ,'mv_ch1','N',1 ,0,0,'C',''                    ,''      ,'','S','mv_par01','Sony'           ,'Sony'           ,'Sony'           ,'','Nextel'         ,'Nextel'         ,'Nextel'         ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Modelo Inicial'                ,'Modelo Inicial'                ,'Modelo Inicial'                ,'mv_ch2','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par02',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'03','Modelo Final'                  ,'Modelo Final'                  ,'Modelo Final'                  ,'mv_ch3','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par03',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'04','Grupo Inicial'                 ,'Grupo Inicial'                 ,'Grupo Inicial'                 ,'mv_ch4','C',4 ,0,0,'G',''                    ,'SBM'   ,'','S','mv_par04',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'05','Grupo Final'                   ,'Grupo Final'                   ,'Grupo Final'                   ,'mv_ch5','C',4 ,0,0,'G',''                    ,'SBM'   ,'','S','mv_par05',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')

return