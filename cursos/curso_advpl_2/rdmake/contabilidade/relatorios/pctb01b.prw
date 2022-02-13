#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCTB01    ºAutor  ³                    º Data ³  02/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao do Razao em Excel                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function PCTB01B()

private _cPerg := "PCTB01_B"

private aHeader := {} // Usado para gravar a planilha

u_GerA0003(ProcName())

// Cria as perguntas, se necessario
PutSX1(_cPerg,"01","Da Data"				,"Da Data"					,"Da Data"					,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"02","Ate a Data"				,"Ate a Data"				,"Ate a Data"				,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"03","Da Conta	          "	,"Da Conta           	"	,"Da Conta           	"	,"mv_ch3","C",20,0,0,"G","","CT1"	,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"04","Ate a Conta 		 "	,"Ate a Conta 		    "	,"Ate a Conta 		 "		,"mv_ch4","C",20,0,0,"G","","CT1"	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"05","Filiais            "	,"Filiais            	"	,"Filiais            	"	,"mv_ch5","C",20,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"06","Do Centro de Custo "	,"Do Centro de Custo   	"	,"Do Centro de Custo	"	,"mv_ch6","C",20,0,0,"G","","CTT"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"07","Ate o Centro de Custo "	,"Ate o Centro de Custo   "	,"Ate o Centro de Custo"	,"mv_ch7","C",20,0,0,"G","","CTT"	,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"08","Do Grupo	          "	,"Do Grupo           	"	,"Do Grupo           	"	,"mv_ch8","C",20,0,0,"G","","CTR"	,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"09","Ate o Grupo 		 "	,"Ate o Grupo 		    "	,"Ate o Grupo 		 "		,"mv_ch9","C",20,0,0,"G","","CTR"	,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"10","Moeda "					,"Moeda			         "	,"Moeda"					,"mv_cha","C",02,0,0,"G","","CTO"	,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(_cPerg,"11","Tipo de Saldo       "	,"Tipo de Saldo       "		,"Tipo de Saldo       "		,"mv_chb","C",01,0,0,"G","","SL"	,"",,"mv_par11","","","","","","","","","","","","","","","","")

if pergunte(_cPerg,.T.)
	msaguarde({||PCTB01BSQL()},"Gerando arquivo")
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCTB01SQL ºAutor  ³ º Data ³  02/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Extracao dos dados via SQL                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function PCTB01BSQL()
local _cQuery := ""
local CR := chr(13)+chr(10)

_cQuery += CR + " SELECT FILIAL, CONTA, CT1_GRUPO, CTR_DESC, DESCRIC, DATA DATALC, CHAR(39) + LOTE + SUBLOTE + DOCUMENTO + LINHA LOTE, "
_cQuery += CR + " HISTORICO, CONTRAP, CC, DEBITO, CREDITO, SALDO"

_cQuery += CR + " FROM ("

_cQuery += CR + " SELECT CT2_FILIAL FILIAL, CT2_DEBITO CONTA, "
_cQuery += CR + " CT1_DESC01 DESCRIC, "
_cQuery += CR + " CT2_DATA DATA, "
_cQuery += CR + " CT2_LOTE LOTE, "
_cQuery += CR + " CT2_DOC  DOCUMENTO, "
_cQuery += CR + " CT2_SBLOTE SUBLOTE, "
_cQuery += CR + " CT2_LINHA LINHA, "
_cQuery += CR + " CT2_HIST HISTORICO, "
_cQuery += CR + " CT2_CCD CC, "
_cQuery += CR + " CT2_CREDIT CONTRAP,"
_cQuery += CR + " CT2_VALOR DEBITO, "
_cQuery += CR + " 0 CREDITO,"
_cQuery += CR + " 0 SALDO, "
_cQuery += CR + " CT1_GRUPO  "
_cQuery += CR + " FROM " + RetSQLName("CT1") + " CT1 (nolock) , " + RetSQLName("CT2") + " CT2 (nolock) "

_cQuery += CR + " WHERE "
_cQuery += CR + "     CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' ' "
_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' "
//_cQuery += CR + " AND CT2.CT2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_parxx+"' "
_cQuery += CR + " AND '"+alltrim(mv_par05)+"' LIKE '%'+CT2.CT2_FILIAL+'%' "
_cQuery += CR + " AND CT1.CT1_CONTA = CT2.CT2_DEBITO"
_cQuery += CR + " AND CT2_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += CR + " AND CT2_DEBITO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += CR + " AND CT2_DC IN ('1','3')"
_cQuery += CR + " AND CT2_MOEDLC = '" + mv_par10 + "'"
_cQuery += CR + " AND CT2_TPSALD = '" + mv_par11 + "'"
_cQuery += CR + " AND CT2_VALOR > 0"
_cQuery += CR + " AND CT1_GRUPO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
_cQuery += CR + " AND CT2_CCD   BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "

_cQuery += CR + " UNION ALL "

_cQuery += CR + " SELECT CT2_FILIAL FILIAL, CT2_CREDIT, "
_cQuery += CR + " CT1_DESC01 DESCRIC, "
_cQuery += CR + " CT2_DATA DATA, "
_cQuery += CR + " CT2_LOTE, "
_cQuery += CR + " CT2_DOC, "
_cQuery += CR + " CT2_SBLOTE, "
_cQuery += CR + " CT2_LINHA, "
_cQuery += CR + " CT2_HIST, "
_cQuery += CR + " CT2_CCC, "
_cQuery += CR + " CT2_DEBITO,"
_cQuery += CR + " 0, "
_cQuery += CR + " CT2_VALOR,"
_cQuery += CR + " 0, "
_cQuery += CR + " CT1_GRUPO "
_cQuery += CR + " FROM " + RetSQLName("CT1") + " CT1 (nolock) , " + RetSQLName("CT2") + " CT2 (nolock) " 
_cQuery += CR + " WHERE "
_cQuery += CR + "     CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' ' "
//_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' AND CT2.CT2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_parxx+"' "
_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' "
_cQuery += CR + " AND '"+alltrim(mv_par05)+"' LIKE '%'+CT2.CT2_FILIAL+'%' "
_cQuery += CR + " AND CT1.CT1_CONTA = CT2.CT2_CREDIT"
_cQuery += CR + " AND CT2_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += CR + " AND CT2_CREDIT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += CR + " AND CT2_DC IN ('2','3')"
_cQuery += CR + " AND CT2_MOEDLC = '" + mv_par10 + "'"
_cQuery += CR + " AND CT2_TPSALD = '" + mv_par11 + "'"
_cQuery += CR + " AND CT2_VALOR > 0"
_cQuery += CR + " AND CT1_GRUPO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
_cQuery += CR + " AND CT2_CCC   BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT FILIAL, CONTA, "
_cQuery += CR + " DESCRIC, "
_cQuery += CR + " '" + dtos(mv_par01-1) + "', "
_cQuery += CR + " '000000', "
_cQuery += CR + " '000000', "
_cQuery += CR + " '000', "
_cQuery += CR + " '000', "
_cQuery += CR + " 'Saldo Inicial', "
_cQuery += CR + " space(9), "
_cQuery += CR + " space(20),"
_cQuery += CR + " 0, "
_cQuery += CR + " 0,"
_cQuery += CR + " SUM(SALDO), "
_cQuery += CR + " CT1_GRUPO  "
_cQuery += CR + " FROM "
_cQuery += CR + " ("
_cQuery += CR + " SELECT CT2_FILIAL FILIAL, "
_cQuery += CR + " CT2_DEBITO CONTA, "
_cQuery += CR + " CT1_DESC01 DESCRIC, "
_cQuery += CR + " -CT2_VALOR  SALDO , "
_cQuery += CR + " CT1_GRUPO  "
_cQuery += CR + " FROM " + RetSQLName("CT1") + " CT1 (nolock) , " + RetSQLName("CT2") + " CT2 (nolock) " 
_cQuery += CR + " WHERE "
_cQuery += CR + "     CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' ' "
//_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' AND CT2.CT2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_parxx+"' "
_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' "
_cQuery += CR + " AND '"+alltrim(mv_par05)+"' LIKE '%'+CT2.CT2_FILIAL+'%' "
_cQuery += CR + " AND CT1.CT1_CONTA = CT2.CT2_DEBITO"
_cQuery += CR + " AND CT2_DATA < '" + dtos(mv_par01) + "' "
_cQuery += CR + " AND CT2_DEBITO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += CR + " AND CT2_DC IN ('1','3')"
_cQuery += CR + " AND CT2_MOEDLC = '" + mv_par10 + "'"
_cQuery += CR + " AND CT2_TPSALD = '" + mv_par11 + "'"
_cQuery += CR + " AND CT2_VALOR > 0"
_cQuery += CR + " AND CT1_GRUPO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
_cQuery += CR + " AND CT2_CCD   BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "

_cQuery += CR + " UNION ALL "

_cQuery += CR + " SELECT CT2_FILIAL FILIAL, CT2_CREDIT CONTA,"
_cQuery += CR + " CT1_DESC01 DESCRIC, "
_cQuery += CR + " CT2_VALOR SALDO, "
_cQuery += CR + " CT1_GRUPO  "
_cQuery += CR + " FROM " + RetSQLName("CT1") + " CT1 (nolock) , " + RetSQLName("CT2") + " CT2 (nolock) " 
_cQuery += CR + " WHERE "
_cQuery += CR + "     CT1.D_E_L_E_T_ = ' ' AND CT2.D_E_L_E_T_ = ' ' "
//_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' AND CT2.CT2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_parxx+"' "
_cQuery += CR + " AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' "
_cQuery += CR + " AND '"+alltrim(mv_par05)+"' LIKE '%'+CT2.CT2_FILIAL+'%' "
_cQuery += CR + " AND CT1.CT1_CONTA = CT2.CT2_CREDIT"
_cQuery += CR + " AND CT2_DATA < '" + dtos(mv_par01) + "' "
_cQuery += CR + " AND CT2_CREDIT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += CR + " AND CT2_DC IN ('2','3')"
_cQuery += CR + " AND CT2_MOEDLC = '" + mv_par10 + "'"
_cQuery += CR + " AND CT2_TPSALD = '" + mv_par11 + "'"
_cQuery += CR + " AND CT2_VALOR > 0"
_cQuery += CR + " AND CT1_GRUPO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
_cQuery += CR + " AND CT2_CCC   BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "

_cQuery += CR + " ) SLDINI"
_cQuery += CR + " GROUP BY FILIAL, CONTA, DESCRIC, CT1_GRUPO"

_cQuery += CR + " ) T"
_cQuery += CR + " LEFT OUTER JOIN "+RetSqlName("CTR")+" AS CTR (NOLOCK) "
_cQuery += CR + " ON CTR_FILIAL = '"+xFilial("CTR")+"' AND CTR_GRUPO = CT1_GRUPO AND CTR.D_E_L_E_T_ = '' "
_cQuery += CR + " ORDER BY FILIAL, CONTA, DATA, LOTE, DOCUMENTO, SUBLOTE, LINHA"

memowrite("PCTB01B.SQL",_cQuery)

TcQuery strtran(_cQuery,CR,"") New Alias "SQL"

TcSetField("SQL","DATALC"	, "D", 08, 00)
TcSetField("SQL","DEBITO"	, "N", 17, 02)
TcSetField("SQL","CREDITO"	, "N", 17, 02)
TcSetField("SQL","SALDO"	, "N", 17, 02)

// Carrega o aHeader para permitir a geracao da planilha
Aadd(aHeader,{"Filial" 	, 	"FILIAL", 		"", 20, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Grupo" 	, 	"CTR_DESC",		"", 40, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Conta" 	, 	"CONTA"	, 		"", 20, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Descricao",	"DESCRIC", 		"", 40, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Data" 	, 	"DATALC", 		"", 08, 0, "", "", "D", "SQL", "R" } )
Aadd(aHeader,{"Lote" 	, 	"LOTE"	, 		"", 18, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Histórico" ,	"HISTORICO", 	"", 40, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Contra Partida" , "CONTRAP",	"", 20, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Centro de Custo" , "CC", 	"", 10, 0, "", "", "C", "SQL", "R" } )
Aadd(aHeader,{"Débito" 	, 	"DEBITO", 		"@E 999,999,999.99", 17, 2, "", "", "N", "SQL", "R" } )
Aadd(aHeader,{"Crédito"	, 	"CREDITO", 		"@E 999,999,999.99", 17, 2, "", "", "N", "SQL", "R" } )
Aadd(aHeader,{"Saldo" 	, 	"SALDO", 		"@E 999,999,999.99", 17, 2, "", "", "N", "SQL", "R" } )

GeraExcel("SQL","",aHeader)

SQL->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExcel ºAutor  ³Zanetti - ERPPLUS   º Data ³  01/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function GeraExcel(_cAlias,_cFiltro,aHeader)

MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraCSV   ºAutor  ³ - ERPPLUS   º Data ³  01/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader)

//local cDirDocs  := __RELDIR // "/IMPIMEI/"
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+alltrim(cArquivo)+".csv")
local _cArq		:= ""

_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
_aAreaSM0 := SM0->(getarea())
SM0->(dbSetOrder(1))

if !empty(_cFiltro)
	(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif

//nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
nHandle := MsfCreate(_cArqTmp,0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	//aEval(aHeader, {|e, nX| fWrite(nHandle, iif(!("ZS_SEP" $ e[nX,2]), e[1] + If(nX < Len(aHeader), ";", ""),"") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	(_cAlias)->(dbgotop())
	while (_cAlias)->(!eof())
		
		for _ni := 1 to len(aHeader)
			
			//if !("ZS_SEP" $ aHeader[_ni,2])
			
			_uValor := ""
			
			if aHeader[_ni,8] == "D" // Trata campos data
				_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
			elseif aHeader[_ni,8] == "N" // Trata campos numericos
				_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
			elseif aHeader[_ni,8] == "C" // Trata campos caracter
				if alltrim(aHeader[_ni,2]) == "FILIAL"
					SM0->(dbSeek(cEmpAnt + &(_cAlias + "->" + aHeader[_ni,2])))
					_uValor := UPPER(SM0->M0_FILIAL)
				else
					_uValor := &(_cAlias + "->" + aHeader[_ni,2])
				endif
			endif
			
			if _ni <> len(aHeader)
				fWrite(nHandle, _uValor + ";" )
			else
				fWrite(nHandle, _uValor )
			endif
			
			//endif
			
		next _ni
		
		fWrite(nHandle, cCrLf )
		
		(_cAlias)->(dbskip())
		
	enddo
	
	fClose(nHandle)
	//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	Else
      ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
	EndIf
	
	/*
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
	*/
	
Else
	MsgAlert("Falha na criação do arquivo")
Endif

(_cAlias)->(dbclearfil())
restarea(_aAreaSM0)

Return