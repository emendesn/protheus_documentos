#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTR28C   บAutor  ณMarcos Zanetti GZ   บ Data ณ  21/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Checagem de fechamento de estoque por Enderecamento        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Se os parametros abaixo nao forem passados, sera disponibi-บฑฑ
ฑฑบ          ณ lizado o botao de parametros na SetPrint                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ _dDtIni   - Data do fechamento inicial                     บฑฑ
ฑฑบ          ณ _dDtFim   - Data do fechamento final                       บฑฑ
ฑฑบ          ณ _cFilial  - Filial a ser considerada                       บฑฑ
ฑฑบ          ณ _nDestino - 1- Relatorio / 2- Planilha Excel               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Galderma                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function ESTR28C(_dDtIni, _dDtFim, _cFilial, _nDestino)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis padrao de relatorio                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
private cDesc2      := "de acordo com os parametros informados pelo usuario."
private cDesc3      := "Checagem de Fechamento - por Endere็amento "
Private lAbortPrint	:= .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ESTR28C"
Private wnrel      	:= "ESTR28C"
Private nTipo       := 	18
Private aReturn     := 	{ "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 	0
Private cPerg      	:= 	"ESTR18"
private titulo      := 	"Checagem de Fechamento - por Endere็amento"
private _nLin       := 	80
private Cabec1      := 	"cabec1"
private Cabec2      := 	"cabec2"
Private CONTFL     	:= 	01
Private m_pag      	:= 	01
Private cString 	:= 	"SB9"
Private aOrd		:= 	{}
private _nOrdem		:= 	0
private CR	 		:= chr(13) + chr(10)
//private _cArq		:= "ESTR28C.XLS"                                
private _cArq		:= "ESTR28C.CSV"                                
private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))


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

Private _nQuebras	:= 	0 	// indica o numero de quebras que serao feitas no relatorio

Private _cQuebra	:= 	"" 	// Expressao de condicao de quebra - Carregada em ESTR28CORD()
Private _cQueryOrd 	:= 	"" 	// Ordenacao da Query - Carregada em ESTR28CORD()

Private _aCampos	:= 	{} 	// Matriz dos campos que serao impresso

Private _aCondQueb	:=	{}	// Array utilzado na quebra (contem os valores correntes para quebra)

Private	_nDesloc	:= 0 	// Usada no deslocamento da impressao

Private	_nTamDesloc	:= 0	// Tamanho do deslocamento entre grupos

Private _cTexto		:= ""  // Texto a ser impresso no inicio de cada pagina ou grupo


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

titulo	:= alltrim(titulo) + ' - ' + dtoc(_dDtIni) + ' x ' + dtoc(_dDtFim)

_nQuebras := ESTR28CORD() // Chama funcao responsavel pela carga do array de ordens

Cabec1 := space(_nDesloc)+Cabec1
Cabec2 := space(_nDesloc)+Cabec2
//memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +cUsername)

MsAguarde({||ESTR28CSQL(_dDtIni, _dDtFim, _cFilial, _nDestino)},"Aguarde","Selecionando Dados",.F.)

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
		RptStatus({|| ESTR28CIMP(_dDtIni, _dDtFim) },Titulo)
	else // Gera arquivo Excel
		if file(__RELDIR+_cArq) .and. ferase(__RELDIR+_cArq) == -1
			msgstop("Nใo foi possํvel abrir o arquivo " + _cArq + " pois ele pode estar aberto por outro usuแrio.")
		else
			dbselectarea("QUERY")
			copy to &(__RELDIR+_cArq)  VIA "DBFCDXADS"
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
ฑฑบFuno    ณESTR28CSQLบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela montagem e execucao da Query       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28CSQL(_dDtIni, _dDtFim, _cFilial, _nDestino)
local _cQuery	:= ""

_cQuery += CR + " SELECT "
_cQuery += CR + " SBK.BK_FILIAL FILIAL, SBK.BK_COD PRODUTO, SB1.B1_DESC DESCPRO, SBK.BK_LOTECTL LOTE, SBK.BK_LOCALIZ LOCALIZ, SBK.BK_LOCAL ALMOX,"
_cQuery += CR + " Q1.QUANT QTD_MOV, SBK.BK_QINI QTD_FECH, Q1.QUANT-SBK.BK_QINI QTD_DIF"

_cQuery += CR + " FROM " + RetSQLName("SB1")+ " SB1 (nolock) , " + RetSQLName("SBK")+ " SBK (nolock) , "

_cQuery += CR + " (SELECT PRODUTO, LOTE, LOCALIZ, ALMOX, SUM(QUANT) QUANT FROM "
_cQuery += CR + " ("
_cQuery += CR + " SELECT SDB.DB_PRODUTO PRODUTO, SDB.DB_LOTECTL LOTE, SDB.DB_LOCALIZ LOCALIZ, SDB.DB_LOCAL ALMOX, "
_cQuery += CR + " CASE WHEN DB_TM < '500' THEN SDB.DB_QUANT ELSE -SDB.DB_QUANT END QUANT"
_cQuery += CR + " FROM " + RetSQLName("SDB")+ " SDB (nolock) "
_cQuery += CR + " WHERE SDB.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SDB.DB_ESTORNO = ' '"
_cQuery += CR + " AND SDB.DB_DATA <= '" + dtos(_dDtFim) + "'"
_cQuery += CR + " AND SDB.DB_DATA >  '" + dtos(_dDtIni) + "'"
_cQuery += CR + " AND SDB.DB_FILIAL = '" + _cFilial + "'"
_cQuery += CR + " AND SDB.DB_ATUEST = 'S'"

_cQuery += CR + " UNION ALL"

_cQuery += CR + " SELECT BK_COD PRODUTO, BK_LOTECTL LOTE, BK_LOCALIZ LOCALIZ, BK_LOCAL ALMOX, BK_QINI QUANT"
_cQuery += CR + " FROM " + RetSQLName("SBK")+ " SBK (nolock) "
_cQuery += CR + " WHERE D_E_L_E_T_ = ' '"
_cQuery += CR + " AND BK_DATA = '" + dtos(_dDtIni) + "'"
_cQuery += CR + " AND BK_FILIAL = '" + _cFilial + "'"

_cQuery += CR + " ) T"
_cQuery += CR + " GROUP BY PRODUTO, LOTE, LOCALIZ, ALMOX"

_cQuery += CR + " ) Q1"

_cQuery += CR + " WHERE SBK.D_E_L_E_T_ = ' '"
_cQuery += CR + " AND SBK.BK_DATA    = '" + dtos(_dDtFim) + "'"
_cQuery += CR + " AND SBK.BK_COD     = Q1.PRODUTO"
_cQuery += CR + " AND SBK.BK_COD     = SB1.B1_COD"
_cQuery += CR + " AND SBK.BK_LOTECTL = Q1.LOTE"
_cQuery += CR + " AND SBK.BK_LOCALIZ = Q1.LOCALIZ"
_cQuery += CR + " AND SBK.BK_LOCAL   = Q1.ALMOX"
_cQuery += CR + " AND SBK.BK_FILIAL  = '" + _cFilial + "'"
_cQuery += CR + " AND ROUND(SBK.BK_QINI-Q1.QUANT,2)<>0"
_cQuery += CR + " AND '" + dtos(_dDtFim) + "' > '" + dtos(_dDtIni) + "'"

_cQueryOrd	:= " ORDER BY " + _cQueryOrd

//memowrite("ESTR28C.SQL",_cQuery + CR + _cQueryOrd)

_cQuery := strtran(_cQuery, CR, "")

// Executa a query principal
TcQuery _cQuery + _cQueryOrd NEW ALIAS "QUERY"

_aTamQtd := TamSx3("B9_QINI")
TcSetField("QUERY","QTD_FECH"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","QTD_MOV"	,"N",_aTamQtd[1],_aTamQtd[2])
TcSetField("QUERY","QTD_DIF"	,"N",_aTamQtd[1],_aTamQtd[2])

// Conta os registros da Query
TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + _cQuery + ") AS T" NEW ALIAS "QRYCONT"
QRYCONT->(dbgotop())
_nRegQry := QRYCONT->TOTALREG
QRYCONT->(dbclosearea())

return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณESTR28CIMPบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela impressao dos dados                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28CIMP(_dDtIni, _dDtFim)
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
	
	ESTR28CQUEB() // Funcao responsavel pelas quebras
	
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

@ ++_nLin , 000 Psay "LEGENDA:"
@ ++_nLin , 000 Psay "MOVIMENTO  - Valor obtido com base no fechamento de " + dtoc(_dDtIni) + " mais os movimentos de " + dtoc(_dDtIni+1) + " a " + dtoc(_dDtFim)
@ ++_nLin , 000 Psay "FECHAMENTO - Valor obtido com base no fechamento de " + dtoc(_dDtFim)
@ ++_nLin , 000 Psay "DIFERENวA  - Diferen็a entre o valor de MOVIMENTO e de FECHAMENTO"


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
ฑฑบFuno    ณESTR28CQUEBบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela totalizacao de acordo c/ as quebrasบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28CQUEB()
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
ฑฑบFuno    ณESTR28CORDบ Autor ณ Marcos Zanetti GZ  บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela carga do array _aQuebras           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ESTR28CORD()
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
	"'"+space(_nDesloc)+"Checagem da Filial - ' + QUERY->FILIAL",;
	space(_nDesloc)+"Total da Filial -->",;
	"QUERY->FILIAL",;
	"PRODUTO, LOTE, LOCALIZ, ALMOX",.F.})
	_nDesloc := len(_aQuebras)*_nTamDesloc
	
	Cabec1 := 	"______________________________________PRODUTO________________________________________         ______________________ QUANTIDADE ______________________"
	Cabec2 := 	"CำDIGO            DESCRIวรO                            LOTE        ENDERECO            ALM           MOVIMENTO          FECHAMENTO           DIFERENวA"
	
	aadd(_aCampos , {"QUERY->PRODUTO"	, "", 000, .F. })
	aadd(_aCampos , {"QUERY->DESCPRO"	, "", 018, .F. })
	aadd(_aCampos , {"QUERY->LOTE"		, "", 055, .F. })
	aadd(_aCampos , {"QUERY->LOCALIZ"	, "", 067, .F. })
	aadd(_aCampos , {"QUERY->ALMOX"		, "", 087, .F. })
	
	aadd(_aCampos , {"QUERY->QTD_MOV"	, PesqPict("SB9","B9_QINI")		, 095, .T. })
	aadd(_aCampos , {"QUERY->QTD_FECH"	, PesqPict("SB9","B9_QINI")		, 115, .T. })
	aadd(_aCampos , {"QUERY->QTD_DIF"	, PesqPict("SB9","B9_QINI")		, 135, .T. })
	
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