#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTR28E   บAutor  ณMarcos Zanetti GZ   บ Data ณ  21/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Checagem de fechamento de estoque por Enderecamento        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Se os parametros abaixo nao forem passados, sera disponibi-บฑฑ
ฑฑบ          ณ lizado o botao de parametros na SetPrint                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ _dDtRef   - Data do fechamento final                       บฑฑ
ฑฑบ          ณ _cFilial  - Filial a ser considerada                       บฑฑ
ฑฑบ          ณ _nDestino - 1- Relatorio / 2- Planilha Excel               บฑฑ
ฑฑบ          ณ _lDifer   - Imprime so diferencas                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Galderma                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function ESTR28E(_dDtRef, _cFilial, _nDestino, _lDifer)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis padrao de relatorio                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
private cDesc1       := 	"Este programa tem como objetivo imprimir relatorio "
private cDesc2       := 	"de acordo com os parametros informados pelo usuario."
private cDesc3       := 	"Previsใo de Fechamento - Produto x Lotes x Endere็amento"
Private lAbortPrint	 := 	.F.
Private limite       := 	220
Private tamanho      := 	"G"
Private nomeprog     := 	"ESTR28E"
Private wnrel      	 := 	"ESTR28E"
Private nTipo        := 	18
Private aReturn      := 	{ "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 	0
Private cPerg      	 := 	"ESTR18"
private titulo       := 	"Previsใo de Fechamento - Produto x Lotes x Endere็amento"
private _nLin        := 	80
private Cabec1       := 	"cabec1"
private Cabec2       := 	"cabec2"
Private CONTFL     	 := 	01
Private m_pag      	 := 	01
Private cString   	 := 	"SB9"
Private aOrd	   	 := 	{}
private _nOrdem		 := 	0
private CR	 	     := chr(13) + chr(10)
//private _cArq	   	 := "ESTR28E.XLS"                                      
private _cArq	   	 := "ESTR28E.CSV"                                      
private _csrvapl      :=ALLTRIM(GetMV("MV_SERVAPL"))


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis especificas por programa  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _nRegQry	:= 	0 // Numero de Registros da Query
Private _nTamPag	:= 	55 // Tamanho de linhas por pagina

Private _aQuebras	:= 	{} // Matriz utilizada na quebra
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณEstrutura da matriz a Quebra (por linha)          ณ
ณ[1] - Expressao do titulo da quebra               ณ
ณ[2] - Expressao do rodape da quebra               ณ
ณ[3] - Expressao com a condicao da quebra          ณ
ณ[4] - Expressao com a o campo na Query (ordenacao)ณ
ณ[5] - Flag para quebra de pagina apos total       ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

Private _nQuebras 	:= 0 	// indica o numero de quebras que serao feitas no relatorio

Private _cQuebra  	:= "" 	// Expressao de condicao de quebra - Carregada em ESTR28EORD()
Private _cQueryOrd 	:= "" 	// Ordenacao da Query - Carregada em ESTR28EORD()

Private _aCampos	   := {} 	// Matriz dos campos que serao impresso

Private _aCondQueb	:=	{}	// Array utilzado na quebra (contem os valores correntes para quebra)

Private	_nDesloc	   := 0 	// Usada no deslocamento da impressao

Private	_nTamDesloc	:= 0	// Tamanho do deslocamento entre grupos

Private _cTexto		:= ""  // Texto a ser impresso no inicio de cada pagina ou grupo

Private _cMVULMES	   := dtos(GetMV("MV_ULMES"))

u_GerA0003(ProcName())

if _nDestino == 1
	
	wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo 	:= If(aReturn[4]==1,15,18)
	
endif

_nOrdem := 1

titulo	:= alltrim(titulo) + ' - ' + dtoc(_dDtRef)

_nQuebras := ESTR28EORD() // Chama funcao responsavel pela carga do array de ordens

Cabec1 := space(_nDesloc)+Cabec1
Cabec2 := space(_nDesloc)+Cabec2
//memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +cUsername)

MsAguarde({||ESTR28ESQL(_dDtRef, _cFilial, _nDestino, _lDifer)},"Aguarde","Selecionando Dados",.F.)

_cArqSeq   :=CriaTrab(,.f.)  
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

dbselectarea("QUERY")
QUERY->(dbgotop())
copy to &(cStartPath+_cArqSeq)


_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
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
if _nRegQry > 0
	if _nDestino == 1 // Nao gera arquivo Excel
		RptStatus({|| ESTR28EIMP(_dDtRef) },Titulo)
	else // Gera arquivo Excel
		if file(__RELDIR+_cArq) .and. ferase(__RELDIR+_cArq) == -1
			msgstop("Nใo foi possํvel abrir o arquivo " + _cArq + " pois ele pode estar aberto por outro usuแrio.")
		else
			dbselectarea("QUERY")
			copy to &(__RELDIR+_cArq) VIA "DBFCDXADS"
			ShellExecute( "Open" , "\\"+_csrvapl+_cArq ,"", "" , 3 )
		endif
	endif
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Sem Dados","STOP")
endif
*/


QUERY->(dbclosearea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณESTR28ESQLบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela montagem e execucao da Query       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28ESQL(_dDtRef, _cFilial, _nDestino,_lDifer)
local _cQuery	:= ""

_cQuery += CR + " SELECT "
_cQuery += CR + " PRODUTO, "
_cQuery += CR + " ALMOX, "
_cQuery += CR + " SB1.B1_DESC    DESCPRO,"
_cQuery += CR + " SB1.B1_RASTRO  RASTRO,"
_cQuery += CR + " SB1.B1_LOCALIZ LOCALIZ,"
_cQuery += CR + " SUM(QTD_PROD)  QTD_PROD, "
_cQuery += CR + " SUM(QTD_LOTE)  QTD_LOTE, "
_cQuery += CR + " SUM(QTD_ENDE)  QTD_END,"
_cQuery += CR + " SUM(QTD_FECH)  QTD_FECH, "
_cQuery += CR + " SUM(QTD_PROD-QTD_FECH)    DIF_PR_FEC, "
_cQuery += CR + " SUM(CUSTO_MOV) CUSTO_MOV, "
_cQuery += CR + " SUM(CUSTO_FECH)CUSTO_FECH,"
_cQuery += CR + " SUM(CUSTO_MOV-CUSTO_FECH) DIF_CUSTO"

_cQuery += CR + " FROM " + RetSQLName("SB1") + " SB1 (nolock) ,"

_cQuery += CR + " ("

_cQuery += CR + " SELECT PRODUTO, ALMOX, SUM(QUANT) QTD_PROD, 0 QTD_LOTE, 0 QTD_ENDE, 0 QTD_FECH, SUM(CUSTO) CUSTO_MOV, 0 CUSTO_FECH FROM "
_cQuery += CR + " (SELECT SD1.D1_COD PRODUTO, SD1.D1_LOCAL ALMOX, SD1.D1_QUANT QUANT, SD1.D1_CUSTO CUSTO"
_cQuery += CR + " FROM " + RetSQLName("SD1") + " SD1 (nolock) , " + RetSQLName("SF4") + " SF4 (nolock) "
_cQuery += CR + " WHERE SD1.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SD1.D1_TES = SF4.F4_CODIGO"
_cQuery += CR + " AND SD1.D1_DTDIGIT <= '" + dtos(_dDtRef) + "'"
_cQuery += CR + " AND SD1.D1_DTDIGIT > '" + _cMVULMES + "'"
_cQuery += CR + " AND SF4.F4_ESTOQUE = 'S'"
_cQuery += CR + " AND SD1.D1_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT SD2.D2_COD PRODUTO, SD2.D2_LOCAL ALMOX, -SD2.D2_QUANT QUANT, -SD2.D2_CUSTO1 CUSTO"
_cQuery += CR + " FROM " + RetSQLName("SD2") + " SD2 (nolock) , " + RetSQLName("SF4") + " SF4 (nolock) "
_cQuery += CR + " WHERE SD2.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += CR + " AND SD2.D2_TES = SF4.F4_CODIGO"
_cQuery += CR + " AND SD2.D2_EMISSAO <= '" + dtos(_dDtRef) + "'"
_cQuery += CR + " AND SD2.D2_EMISSAO >  '" + _cMVULMES + "'"
_cQuery += CR + " AND SF4.F4_ESTOQUE = 'S'"
_cQuery += CR + " AND SD2.D2_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT SD3.D3_COD PRODUTO, SD3.D3_LOCAL ALMOX, "
_cQuery += CR + " CASE WHEN D3_TM < '500' THEN SD3.D3_QUANT ELSE -SD3.D3_QUANT END QUANT, "
_cQuery += CR + " CASE WHEN D3_TM < '500' THEN SD3.D3_CUSTO1  ELSE -SD3.D3_CUSTO1 END CUSTO"
_cQuery += CR + " FROM " + RetSQLName("SD3") + " SD3 (nolock) "
_cQuery += CR + " WHERE SD3.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SD3.D3_ESTORNO <> 'S'"
_cQuery += CR + " AND SD3.D3_EMISSAO <= '" + dtos(_dDtRef) + "'"
_cQuery += CR + " AND SD3.D3_EMISSAO >  '" + _cMVULMES + "'"
_cQuery += CR + " AND SD3.D3_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT B9_COD PRODUTO, B9_LOCAL ALMOX, B9_QINI QUANT, B9_VINI1 CUSTO"
_cQuery += CR + " FROM " + RetSQLName("SB9") + " SB9 (nolock) "
_cQuery += CR + " WHERE D_E_L_E_T_ = ' '"
_cQuery += CR + " AND B9_DATA = '" + _cMVULMES + "'"
_cQuery += CR + " AND B9_FILIAL = '" + _cFilial + "'"
_cQuery += CR + " ) T1 GROUP BY PRODUTO, ALMOX"

_cQuery += CR + " UNION ALL"


_cQuery += CR + " SELECT PRODUTO, ALMOX, 0 QTD_PROD, SUM(QUANT)  QTD_LOTE, 0 QTD_ENDE, 0 QTD_FECH, 0 CUSTO_MOV, 0 CUSTO_FECH FROM "
_cQuery += CR + " ("
_cQuery += CR + " SELECT SD5.D5_PRODUTO PRODUTO, SD5.D5_LOTECTL LOTE, SD5.D5_NUMLOTE SUBLOTE, SD5.D5_LOCAL ALMOX, "
_cQuery += CR + " CASE WHEN D5_ORIGLAN < '500' OR D5_ORIGLAN = 'MAN' THEN SD5.D5_QUANT ELSE -SD5.D5_QUANT END QUANT"
_cQuery += CR + " FROM " + RetSQLName("SD5") + " SD5 (nolock) "
_cQuery += CR + " WHERE SD5.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SD5.D5_ESTORNO = ' '"
_cQuery += CR + " AND SD5.D5_DATA <= '" + dtos(_dDtRef) + "'"
_cQuery += CR + " AND SD5.D5_DATA >  '" + _cMVULMES + "'"
_cQuery += CR + " AND SD5.D5_FILIAL = '" + _cFilial + "'"


_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT BJ_COD PRODUTO, BJ_LOTECTL LOTE, BJ_NUMLOTE SUBLOTE, BJ_LOCAL ALMOX, BJ_QINI QUANT"
_cQuery += CR + " FROM " + RetSQLName("SBJ") + " SBJ (nolock) "
_cQuery += CR + " WHERE D_E_L_E_T_ = ' '"
_cQuery += CR + " AND BJ_DATA = '" + _cMVULMES + "'"
_cQuery += CR + " AND BJ_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " ) T2 GROUP BY PRODUTO, LOTE, SUBLOTE, ALMOX"

_cQuery += CR + " UNION ALL"


_cQuery += CR + " SELECT PRODUTO, ALMOX, 0 QTD_PROD, 0 QTD_LOTE, SUM(QUANT) QTD_ENDE, 0 QTD_FECH, 0 CUSTO_MOV, 0 CUSTO_FECH FROM "
_cQuery += CR + " ("
_cQuery += CR + " SELECT SDB.DB_PRODUTO PRODUTO, SDB.DB_LOTECTL LOTE, SDB.DB_LOCALIZ LOCALIZ, SDB.DB_LOCAL ALMOX, "
_cQuery += CR + " CASE WHEN DB_TM < '500' THEN SDB.DB_QUANT ELSE -SDB.DB_QUANT END QUANT"
_cQuery += CR + " FROM " + RetSQLName("SDB") + " SDB (nolock) "
_cQuery += CR + " WHERE SDB.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SDB.DB_ESTORNO = ' '"
_cQuery += CR + " AND SDB.DB_DATA <= '" + dtos(_dDtRef) + "'"
_cQuery += CR + " AND SDB.DB_DATA >  '" + _cMVULMES + "'"
_cQuery += CR + " AND SDB.DB_FILIAL = '" + _cFilial + "'"
_cQuery += CR + " AND SDB.DB_ATUEST = 'S'"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT BK_COD PRODUTO, BK_LOTECTL LOTE, BK_LOCALIZ LOCALIZ, BK_LOCAL ALMOX, BK_QINI QUANT"
_cQuery += CR + " FROM " + RetSQLName("SBK") + " SBK (nolock) " 
_cQuery += CR + " WHERE D_E_L_E_T_ = ' '"
_cQuery += CR + " AND BK_DATA = '" + _cMVULMES + "'"
_cQuery += CR + " AND BK_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " ) T3"
_cQuery += CR + " GROUP BY PRODUTO, LOTE, LOCALIZ, ALMOX"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT B2_COD, B2_LOCAL, 0, 0, 0, B2_QFIM, 0, B2_VFIM1 CUSTO_FECH "
_cQuery += CR + " FROM " + RetSQLName("SB2") + " (nolock) "                  
_cQuery += CR + " WHERE D_E_L_E_T_ = ' '"
_cQuery += CR + " AND B2_FILIAL = '" + _cFilial + "'"
_cQuery += CR + " ) T"

_cQuery += CR + " WHERE "
_cQuery += CR + " T.PRODUTO = SB1.B1_COD"
_cQuery += CR + " AND SB1.D_E_L_E_T_ = ' '"

_cQuery += CR + " GROUP BY PRODUTO, ALMOX, SB1.B1_DESC, SB1.B1_RASTRO, SB1.B1_LOCALIZ"

//_cQuery += CR + " ORDER BY ALMOX, PRODUTO"

_cQueryOrd	:= " ORDER BY " + _cQueryOrd

//memowrite("ESTR28E.SQL",_cQuery + CR + _cQueryOrd)

_cQuery := strtran(_cQuery, CR, "")

// Executa a query principal
TcQuery _cQuery + _cQueryOrd NEW ALIAS "QUERY"

_aTamQtd := TamSx3("B9_QINI")
TcSetField("QUERY","QTD_PROD"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","QTD_LOTE"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","QTD_END"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","QTD_FECH"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","DIF_PR_FEC"	,"N",_aTamQtd[1],_aTamQtd[2])
_aTamQtd := TamSx3("B9_VINI1")
TcSetField("QUERY","CUSTO_MOV"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","CUSTO_FECH"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","DIF_CUSTO"	,"N",_aTamQtd[1],_aTamQtd[2])

if _lDifer // Se imprime apenas as diferencas, trata o resultado da query
	
	_cNomeArq := CriaTrab(NIL,.F.)
	dbselectarea("QUERY")
	copy to &(_cNomeArq) //VIA "DBFCDXADS"
	QUERY->(dbclosearea())
	dbUseArea(.T.,,_cNomeArq,"QUERY",.F.,.F.)
	
	dbselectarea("QUERY")
	QUERY->(dbgotop())
	while QUERY->(!eof())
		
		if !(QUERY->RASTRO $ "SL" .and. QUERY->QTD_PROD <> QUERY->QTD_LOTE .or. ;
			QUERY->LOCALIZ == "S" .and. QUERY->QTD_PROD <> QUERY->QTD_END  .or. ;
			QUERY->DIF_CUSTO <> 0 .or. QUERY->DIF_PR_FEC <> 0)
			RecLock("QUERY",.F.)
			dbdelete()
			MsUnlock()
		endif
		QUERY->(dbskip())
	enddo
	pack
	
	// Conta os registros do arquivo de trabalho
	_nRegQry := QUERY->(RecCount())
else
	
	// Conta os registros da Query
	TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + _cQuery + ") AS T" NEW ALIAS "QRYCONT"
	QRYCONT->(dbgotop())
	_nRegQry := QRYCONT->TOTALREG
	QRYCONT->(dbclosearea())
	
endif


return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณESTR28EIMPบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela impressao dos dados                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28EIMP(_dDtRef)
local _aTexto
local _nContaFor
Local _cQuebSoma 	:= ""
Local _cQuebTit 	:= ""
Local _cQuebTit2 	:= ""

Private _aTotal	:= {}

// Monta o array de total
For _ni := 1 to len(_aQuebras)
	aadd(_aTotal , array(len(_aCampos))) // Cria um vetor com um total por quebra
	afill(_aTotal[_ni],0)
Next _ni
aadd(_aTotal , array(len(_aCampos)))
afill(_aTotal[len(_aTotal)],0) // Total Geral

SetRegua(_nRegQry)
QUERY->(dbGoTop())

_nLin := _nTamPag+1

VerifPag()
for _nContaFor := 1 to _nQuebras
	aadd(_aCondQueb, &(_aQuebras[_nContaFor,3]))
next _nContaFor

While QUERY->(!eof())
	/*
	if !(QUERY->RASTRO $ "SL" .and. QUERY->DIF_PR_LOT <> 0 .or. ;
	QUERY->LOCALIZ == "S" .and. QUERY->DIF_PR_END <> 0)
	QUERY->(dbSkip())
	IncRegua()
	loop
	endif
	*/
	
	ESTR28EQUEB() // Funcao responsavel pelas quebras
	
	If lAbortPrint // Verifica o cancelamento pelo usuario...
		@_nLin,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	for _ni := 1 to len(_aCampos)
		
		_uValor := &(_aCampos[_ni,1])
		
		@ _nLin , _aCampos[_ni,3]+_nDesloc Psay iif(!empty(_aCampos[_ni,2]) , Transform(_uValor,_aCampos[_ni,2]), _uValor)
		
		if _aCampos[_ni,4] // Se gera total
			for _nj := 1 to len(_aTotal)
				_aTotal[_nj,_ni] += &(_aCampos[_ni,1])
			next _nj
		endif
		
	next _ni
	
	_nLin++
	
	VerifPag()
	
	QUERY->(dbSkip())
	IncRegua()
	
EndDo

for _nCont2 := _nQuebras to 1 step -1
	
	_nLin++
	
	VerifPag()
	
	@ _nLin , 000 Psay _aQuebras[_nCont2,2]
	for _ni := 1 to len(_aCampos)
		if _aCampos[_ni,4]
			@ _nLin , _aCampos[_ni,3]+_nDesloc Psay _aTotal[_nCont2,_ni] picture _aCampos[_ni,2]
		endif
	next _ni
	afill(_aTotal[_nCont2],0)
	
	_nLin+=2
	
next _nCont2

@ ++_nLin , 000 Psay "Total Geral -->"
for _ni := 1 to len(_aCampos)
	if _aCampos[_ni,4]
		@ _nLin , _aCampos[_ni,3]+_nDesloc Psay _aTotal[len(_aTotal),_ni] picture _aCampos[_ni,2]
	endif
next _ni

_nLin += 2

/*
@ ++_nLin , 000 Psay "LEGENDA:"
@ ++_nLin , 000 Psay "MOVIMENTO  - Valor obtido com base no fechamento de " + dtoc(_dDtRef) + " mais os movimentos de " + dtoc(_dDtRef+1) + " a " + dtoc(_dDtRef)
@ ++_nLin , 000 Psay "FECHAMENTO - Valor obtido com base no fechamento de " + dtoc(_dDtRef)
@ ++_nLin , 000 Psay "DIFERENวA  - Diferen็a entre o valor de MOVIMENTO e de FECHAMENTO"
*/

roda(_nRegQry,"registros impressos",tamanho)

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuno    ณESTR28EQUEBบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela totalizacao de acordo c/ as quebrasบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28EQUEB()
local _nCont1	 	:= 0
local _nCont2		:= 0
local _lFezQuebra	:= .F.
local _lQuebraPag	:= .F.

for _nCont1 := 1 to _nQuebras
	
	if !_lFezQuebra
		
		if _aCondQueb[_nCont1] <> &(_aQuebras[_nCont1,3]) .or. QUERY->(eof())
			
			_lFezQuebra := .T.
			
			for _nCont2 := _nQuebras to _nCont1 step -1
				
				VerifPag()
				
				@ _nLin , 000 Psay _aQuebras[_nCont2,2]
				for _ni := 1 to len(_aCampos)
					if _aCampos[_ni,4]
						@ _nLin , _aCampos[_ni,3]+_nDesloc Psay _aTotal[_nCont2,_ni] picture _aCampos[_ni,2]
					endif
				next _ni
				afill(_aTotal[_nCont2],0)
				
				_nLin+=2
				
				_lQuebraPag	:= _lQuebraPag .OR. _aQuebras[_nCont2,5]
				
			next _nCont2
			
			if QUERY->(!eof())
				
				if _lQuebraPag
					_nLin := _nTamPag+1
				else
					_nLin++
				endif
				
				VerifPag()
				
				for _nCont2 := _nCont1 to _nQuebras
					
					VerifPag()
					@ _nLin , 000 Psay &(_aQuebras[_nCont2,1])
					_aCondQueb[_nCont2] := &(_aQuebras[_nCont2,3])
					_nLin+=2
					
				next _nCont2
			endif
			
		endif
	endif
next _nCont1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณESTR28EORDบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela carga do array _aQuebras           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28EORD()
local _nRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEstrutura da Matriz _aCampos    ณ
//ณ[1] Campo a ser impresso - C    ณ
//ณ[2] Picture a ser utilizada - C ณ
//ณ[3] Coluna de impressao - N     ณ
//ณ[4] Acumula total - L           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if _nOrdem == 1
	
	aadd( _aQuebras, {;
	"'"+space(_nDesloc)+" Almoxarifado - ' + QUERY->ALMOX",;
	space(_nDesloc)+"Total do Almoxarifado -->",;
	"QUERY->ALMOX",;
	"ALMOX, PRODUTO",.F.})
	_nDesloc := len(_aQuebras)*_nTamDesloc
	
	Cabec1 := 	"___________________________PRODUTO__________________________          QUANTIDADE          QUANTIDADE          QUANTIDADE          QUANTIDADE           DIFERENวA            CUSTO DO            CUSTO DO           DIFERENวA"
	Cabec2 := 	"CำDIGO            DESCRIวรO                           LT END ALM     POR PRODUTO            POR LOTE        POR ENDEREวO       P/ FECHAMENTO         PROD x FECH           MOVIMENTO          FECHAMENTO            DE CUSTO"
	
	aadd(_aCampos , {"QUERY->PRODUTO"	, "", 000, .F. })
	aadd(_aCampos , {"QUERY->DESCPRO"	, "", 018, .F. })
	aadd(_aCampos , {"QUERY->RASTRO"		, "", 055, .F. })
	aadd(_aCampos , {"QUERY->LOCALIZ"	, "", 058, .F. })
	aadd(_aCampos , {"QUERY->ALMOX"		, "", 061, .F. })
	
	aadd(_aCampos , {"QUERY->QTD_PROD"	, PesqPict("SB9","B9_QINI")		, 065, .T. })
	aadd(_aCampos , {"QUERY->QTD_LOTE"	, PesqPict("SB9","B9_QINI")		, 085, .T. })
	aadd(_aCampos , {"QUERY->QTD_END"	, PesqPict("SB9","B9_QINI")		, 105, .T. })
	aadd(_aCampos , {"QUERY->QTD_FECH"	, PesqPict("SB9","B9_QINI")		, 125, .T. })
	aadd(_aCampos , {"QUERY->DIF_PR_FEC", PesqPict("SB9","B9_QINI")		, 145, .T. })
	aadd(_aCampos , {"QUERY->CUSTO_MOV"	, PesqPict("SB9","B9_VINI1")		, 165, .T. })
	aadd(_aCampos , {"QUERY->CUSTO_FECH", PesqPict("SB9","B9_VINI1")		, 185, .T. })
	aadd(_aCampos , {"QUERY->DIF_CUSTO"	, PesqPict("SB9","B9_VINI1")		, 205, .T. })
	
endif

_nRet := len(_aQuebras)

_cQuebra 	:=""
_cQueryOrd	:=""
For _nContaFor := 1 to _nRet
	_cQuebra 	+= 	_aQuebras[_nContaFor,3]
	_cQueryOrd 	+=	_aQuebras[_nContaFor,4]
	if _nContaFor < len(_aQuebras)
		_cQuebra 	+= "+"
		_cQueryOrd 	+= ","
	endif
Next _nContaFor

return(_nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VERIFPAG บAutor  ณMarcos Zanetti GZ   บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a necessidade de quebra de pagina                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
static function VerifPag()
Local _nContCab
If _nLin > _nTamPag
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
	_nLin := PROW()+1
	
	for _nContCab := 1 to _nQuebras
		@ _nLin , 000 Psay &(_aQuebras[_nContCab,1])
		_nLin += 2
	next _nContCab
	
Endif

return
