#include "rwmake.ch"
#include "topconn.ch"                              '
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT01    บAutor  ณMarcos Zanetti      บ Data ณ  25/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Carteira em Aberto                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Howden                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                   
user function RFAT50()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis padrao de relatorio                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
private cDesc1      := 	"Este programa tem como objetivo imprimir relatorio "
private cDesc2      := 	"de acordo com os parametros informados pelo usuario."
private cDesc3      := 	"Relat๓rio de Carteiras em Aberto"
Private lAbortPrint	:= 	.F.
Private limite      := 	220
Private tamanho     := 	"G"
Private nomeprog    := 	"RFAT01"
Private wnrel      	:= 	"RFAT01"
Private nTipo       := 	18
Private aReturn     := 	{ "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 	0
Private cPerg      	:= 	"RFAT01"
private titulo      := 	"Relat๓rio de Carteira em Aberto"
private _nLin       := 	80
private Cabec1      := 	"cabec1"
private Cabec2      := 	"cabec2"
Private CONTFL     	:= 	01
Private m_pag      	:= 	01
Private cString 	:= 	"SD2"
Private aOrd		:= 	{}
private _nOrdem		:= 	0
private CR	 		:= chr(13) + chr(10)
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

Private _cQuebra	:= 	"" 	// Expressao de condicao de quebra - Carregada em RFAT22ORD()
Private _cQuerySel 	:= 	"" 	// Retorno   da Query - Carregada em RFAT22ORD()
Private _cQueryGrp 	:= 	"" 	// Agrupamento da Query - Carregada em RFAT22ORD()
Private _cQueryOrd 	:= 	"" 	// Ordenacao da Query - Carregada em RFAT22ORD()

Private _aCampos	:= 	{} 	// Matriz dos campos que serao impresso

Private _aCondQueb	:=	{}	// Array utilzado na quebra (contem os valores correntes para quebra)

Private	_nDesloc	:= 0 	// Usada no deslocamento da impressao

Private	_nTamDesloc	:= 0	// Tamanho do deslocamento entre grupos

Private _cTexto		:= ""  // Texto a ser impresso no inicio de cada pagina ou grupo

u_GerA0003(ProcName())

ValidPerg()

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

Private _dDtIni   := mv_par01
Private _dDtFim   := mv_par02
Private _lExcel   := mv_par11 == 1

If nLastKey == 27
	Return
Endif

if !_lExcel
	SetDefault(aReturn,cString)
endif

If nLastKey == 27
	Return
Endif

nTipo 	:= If(aReturn[4]==1,15,18)

_nOrdem := aReturn[8]  // Ordem escolhida para impressao do relatorio

_nQuebras := RFAT01ORD() // Chama funcao responsavel pela carga do array de ordens

Cabec1 := space(_nDesloc)+Cabec1
Cabec2 := space(_nDesloc)+Cabec2

MsAguarde({||RFAT01SQL()},"Aguarde","Selecionando Dados",.F.)

if _nRegQry > 0
	if _lExcel // Gera arquivo Excel
		GeraExcel("QUERY",,_aCampos)
	else // Gera Relatorio
		RptStatus({|| RFAT01IMP() },Titulo)
	endif
	
else
	msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Sem Dados","STOP")
endif

QUERY->(dbclosearea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFAT01SQL บ Autor ณ Marcos Zanetti     บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela montagem e execucao da Query       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RFAT01SQL()
local _cQuery 	:= ""
local _nTotal 	:= 0

_cQuery += CR + "SELECT "
_cQuery += CR + "C5_EMISSAO EMISSAO, "
_cQuery += CR + "C6_ENTREG  ENTREGA, "
_cQuery += CR + "CLIENTE, "
_cQuery += CR + "PEDIDO, "
_cQuery += CR + "ITEM, "
_cQuery += CR + "B1_DESC DESCRICAO, "
_cQuery += CR + "A1_EST EST, "
_cQuery += CR + "SALDO MERCADORIA, "
_cQuery += CR + "SALDO * (1- "
_cQuery += CR + "CASE WHEN F4_ICM = 'S' THEN "
_cQuery += CR + "   CASE WHEN A1_EST = 'SP' THEN CASE WHEN B1_PICM > 0 THEN B1_PICM/100 ELSE 0.18 END "
_cQuery += CR + "        WHEN A1_EST IN ('RS','SC','PR','MG','RJ') THEN CASE WHEN B1_PICM > 0 AND B1_PICM < 0.12 THEN B1_PICM/100 ELSE 0.12 END "
_cQuery += CR + "        ELSE CASE WHEN B1_PICM > 0 AND B1_PICM < 7 THEN B1_PICM/100 ELSE 0.07 END END "
_cQuery += CR + "* CASE WHEN F4_BASEICM > 0 THEN F4_BASEICM / 100 ELSE 1 END "
_cQuery += CR + "* CASE WHEN F4_INCIDE = 'S' AND F4_IPI = 'S' AND B1_IPI > 0 THEN 1+((CASE WHEN F4_BASEIPI > 0 THEN F4_BASEIPI / 100 ELSE 1 END) * B1_IPI/100) ELSE 1 END "
_cQuery += CR + "ELSE 0 END "
_cQuery += CR + "- CASE WHEN F4_ISS = 'S' AND B1_ALIQISS > 0 THEN B1_ALIQISS/100 ELSE 0 END "
_cQuery += CR + "- CASE WHEN F4_PISCOF IN ('1','3') AND F4_PISCRED = '2' THEN 0.0165 ELSE 0 END "
_cQuery += CR + "- CASE WHEN F4_PISCOF IN ('2','3') AND F4_PISCRED = '2' THEN 0.0760 ELSE 0 END) "
_cQuery += CR + "LIQUIDO "
_cQuery += CR + "FROM "
_cQuery += CR + "(SELECT CLIENTE, PEDIDO, ITEM,  SUM(SALDO) SALDO "
_cQuery += CR + "        FROM ( "
_cQuery += CR + "        SELECT A1_NOME CLIENTE, C6_NUM PEDIDO, C6_ITEM ITEM, "
_cQuery += CR + "        CASE WHEN C6_BLQ = 'R' THEN 0 ELSE C6_QTDVEN * C6_PRCVEN END SALDO "
_cQuery += CR + "        FROM "+RetSqlName("SA1")+" SA1 (nolock) , "+RetSqlName("SC5")+" SC5 (nolock) , "+RetSqlName("SC6")+" SC6 (nolock) "
_cQuery += CR + "        WHERE SA1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND C6_NUM = C5_NUM AND C5_TIPO = 'N' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
_cQuery += CR + "        AND (C5_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' )"
_cQuery += CR + "        UNION ALL "
_cQuery += CR + "        SELECT A1_NOME, D2_PEDIDO PEDIDO, D2_ITEMPV ITEM, CASE WHEN C6_BLQ = 'R' THEN 0 ELSE -D2_TOTAL END SALDO "
_cQuery += CR + "        FROM "+RetSqlName("SA1")+" SA1 (nolock) , "+RetSqlName("SC5")+" SC5 (nolock) , "+RetSqlName("SC6")+" SC6 (nolock) , "+RetSqlName("SD2")+" SD2 (nolock) "
_cQuery += CR + "        WHERE SA1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND D2_TIPO = 'N' AND C6_NUM = C5_NUM "
_cQuery += CR + "        AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
_cQuery += CR + "        AND (C5_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND  )"
_cQuery += CR + "        AND D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
_cQuery += CR + "        ) T "
_cQuery += CR + "        GROUP BY PEDIDO, ITEM, CLIENTE "
_cQuery += CR + ") T2 "
_cQuery += CR + "INNER JOIN "+RetSqlName("SC5")+" SC5 (nolock) ON PEDIDO     = C5_NUM     AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += CR + "INNER JOIN "+RetSqlName("SC6")+" SC6 (nolock) ON PEDIDO     = C6_NUM     AND ITEM = C6_ITEM AND SC6.D_E_L_E_T_ = ' ' "
_cQuery += CR + "INNER JOIN "+RetSqlName("SF4")+" SF4 (nolock) ON C6_TES     = F4_CODIGO  AND SF4.D_E_L_E_T_ = ' ' "
_cQuery += CR + "INNER JOIN "+RetSqlName("SB1")+" SB1 (nolock) ON C6_PRODUTO = B1_COD     AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += CR + "INNER JOIN "+RetSqlName("SA1")+" SA1 (nolock) ON C6_CLI     = A1_COD     AND C6_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += CR + "WHERE ROUND(SALDO,2) > 0 "
_cQuery += CR + "      AND C6_ENTREG  BETWEEN '" + Dtos(mv_par03) + "' AND '"+Dtos(mv_par04)+"' "
_cQuery += CR + "      AND PEDIDO     BETWEEN '" + mv_par05 + "' AND '"+mv_par06+"' "
_cQuery += CR + "      AND C5_CLIENTE BETWEEN '" + mv_par07 + "' AND '"+mv_par08+"' "
_cQuery += CR + "      AND A1_LOJA    BETWEEN '" + mv_par09 + "' AND '"+mv_par10+"' "
_cQuery += CR + "ORDER BY EMISSAO DESC, PEDIDO, ITEM "

//memowrite("RFAT01.SQL",_cQuery)

_cQuery := strtran(_cQuery, CR, "")

TcQuery _cQuery NEW ALIAS "QUERY"

TcSetField("QUERY","EMISSAO"	,"D",08,00)
TcSetField("QUERY","ENTREGA"	,"D",08,00)
TcSetField("QUERY","MERCADORIA"	,"N",13,02)
TcSetField("QUERY","LIQUIDO"	,"N",13,02)
TcSetField("QUERY","GROSS"		,"N",10,02)
TcSetField("QUERY","PRVENT" 	,"D",08,00)                                           


_cNomeArq := CriaTrab(NIL,.F.)
dbselectarea("QUERY")
copy to &(_cNomeArq)
QUERY->(dbclosearea())
dbUseArea(.T.,,_cNomeArq,"QUERY",.F.,.F.)

_nRegQry := QUERY->(reccount())

QUERY->(dbgotop())
while QUERY->(!eof())
	RecLock("QUERY",.F.)
	QUERY->DESCPED  := strtran(strtran(strtran(QUERY->DESCPED  ,chr(10),''),chr(13),''),';',',')
	QUERY->DESCNOTA := strtran(strtran(strtran(QUERY->DESCNOTA ,chr(10),''),chr(13),''),';',',')
	QUERY->LINHA    := LEFT(TABELA('Z6',QUERY->CLINHA,.F.),15)
	QUERY->SEGMENTO := LEFT(TABELA('Z7',QUERY->CSEGMENTO,.F.),15)
	MsUnlock()
	QUERY->(dbskip())
enddo

return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFAT01IMP บ Autor ณ Marcos Zanetti     บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela impressao dos dados                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RFAT01IMP()
local _aTexto
local _nContaFor
Local _cQuebSoma 	:= ""
Local _cQuebTit 	:= ""
Local _cQuebTit2 	:= ""            
local _cRelato		:= ""

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

//for _nCont2 := 1 to _nQuebras
//	VerifPag()
//next _nCont2

While QUERY->(!eof())
	
	RFAT01QUEB() // Funcao responsavel pelas quebras
	
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

// roda(_nRegQry,"registros impressos",tamanho)

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFAT01QUEB บ Autor ณ Marcos Zanetti     บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela totalizacao de acordo c/ as quebras บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RFAT01QUEB()
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
					if !empty(&(_aQuebras[_nCont2,1]))
						@ _nLin , 000 Psay &(_aQuebras[_nCont2,1])
						_nLin+=2
					endif 
					_aCondQueb[_nCont2] := &(_aQuebras[_nCont2,3])
					
				next _nCont2
			endif
			
		endif
	endif
next _nCont1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRFAT01ORD  บ Autor ณ Marcos Zanetti     บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao responsavel pela carga do array _aQuebras            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RFAT01ORD()
local _nRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEstrutura da Matriz _aCampos    ณ
//ณ[1] Campo a ser impresso - C    ณ
//ณ[2] Picture a ser utilizada - C ณ
//ณ[3] Coluna de impressao - N     ณ
//ณ[4] Acumula total - L           ณ
//ณ[5] Tipo do campo - C/N/D       ณ
//ณ[6] Titulo do campo - Excel     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if _nOrdem == 1 // Produto
	
//	aadd( _aQuebras, {"'Gerente: ' + QUERY->NOMEGER","Total Gerente ->","QUERY->GERPRD","",.F.})
//	_nDesloc := len(_aQuebras)*_nTamDesloc
	
//	Cabec1 := 	"EMISSAO   ENTREGA   CLIENTE                                   PEDIDO  ITEM  DESCRIวรO                       DESCRIวรO DO PEDIDO             DESCRIวรO DA NOTA               ESTADO     MERCADORIA        LIQUIDO"
//	Cabec2 := 	""
//	             xxxxxxxx  xxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxx  xxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx      xxxxxxxxxxxxx  xxxxxxxxxxxxx
//               0         1         2         3         4         5         6         7         8         9        10        11       12        13        14        15         16        17       18        19        20        21
//               012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456790123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	Cabec1 := 	"EMISSAO   ENTREGA   PRV ENT  PROPOSTA        GROSS   LINHA             SEGMENTO           CLIENTE                                   PEDIDO  IT  DESCRIวรO                             UF     MERCADORIA        LIQUIDO"
	Cabec2 := 	""
	//           xxxxxxxx  xxxxxxxx  xxxxxxxxxxxxxxx  xxxxxxxx  x      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxx  xx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx        xxxxxxxxxxxxx  xxxxxxxxxxxxx
	//           0         1         2         3         4         5         6         7         8         9        10        11       12        13        14        15         16        17       18
	//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456790123456789012345678901234567890123456789012345678901234567890
	
	aadd(_aCampos , {"QUERY->EMISSAO" 						, ""				, 000, .F. ,"D", "EMISSAO"		})
	aadd(_aCampos , {"QUERY->ENTREGA"						, ""				, 010, .F. ,"D", "ENTREGA"		})
	aadd(_aCampos , {"QUERY->PRVENT"						, ""				, 020, .F. ,"D", "PRV ENT"		})
	aadd(_aCampos , {"QUERY->PROPOSTA"						, ""				, 029, .F. ,"C", "PROPOSTA"		})
	aadd(_aCampos , {"QUERY->GROSS"							, "@E 99,999.99%"	, 041, .F. ,"N", "GROSS"		})
	aadd(_aCampos , {"QUERY->LINHA"							, ""				, 055, .F. ,"C", "LINHA"		})
	aadd(_aCampos , {"QUERY->SEGMENTO"						, ""				, 073, .F. ,"C", "SEGMENTO"		})
	aadd(_aCampos , {"QUERY->CLIENTE"						, ""				, 091, .F. ,"C", "CLIENTE"		})
	aadd(_aCampos , {"QUERY->PEDIDO"						, ""				, 133, .F. ,"C", "PEDIDO"		})
	aadd(_aCampos , {"QUERY->ITEM"							, ""				, 141, .F. ,"C", "ITEM"			})
	If _lExcel
		aadd(_aCampos , {"SUBSTR(QUERY->PEDIDO,2,5)"		, ""				, 128, .F. ,"C", "NฺMERO DE OS"	})
		aadd(_aCampos , {"SUBSTR(QUERY->DESCRICAO,1,40)" , "", 000, .F. ,"C", "DESCRIวรO"	})
		aadd(_aCampos , {"QUERY->DESCPED"	 , "", 000, .F. ,"C", "DESCRIวรO DO PEDIDO"})
		//aadd(_aCampos , {"SUBSTR(QUERY->DESCRICAO,1,40)" , "", 000, .F. ,"C", "DESCRIวรO"	})
		//aadd(_aCampos , {"STRTRAN(STRTRAN(STRTRAN(QUERY->DESCPED,CHR(10),''),CHR(13),''),';',',')"	 , "", 000, .F. ,"C", "DESCRIวรO DO PEDIDO"})
		//aadd(_aCampos , {"strtran(strtran(strtran(QUERY->DESCNOTA,CHR(10),''),CHR(13),''),';',',')" , "", 000, .F. ,"C", "DESCRIวรO DA NOTA"})
	else
		aadd(_aCampos , {"SUBSTR(QUERY->DESCPED,1,40)"	, "", 1450, .F. ,"C", "DESCRIวรO DO PEDIDO"	})
		//aadd(_aCampos , {"SUBSTR(STRTRAN(STRTRAN(STRTRAN(QUERY->DESCPED,CHR(10),''),CHR(13),''),';',','),1,40)"	, "", 140, .F. ,"C", "DESCRIวรO"	})
	EndIf
	aadd(_aCampos , {"QUERY->EST"						, ""				, 187, .F. ,"C", "EST"		})//Tirar
	aadd(_aCampos , {"QUERY->MERCADORIA"					, "@E 99,999,999.99", 192, .T. ,"N", "MERCADORIA"	})//Tirar
	aadd(_aCampos , {"QUERY->LIQUIDO"						, "@E 99,999,999.99", 207, .T. ,"N", "LIQUIDO"		})//Tirar
	

endif

_nRet := len(_aQuebras)

_cQuebra 	:=""
For _nContaFor := 1 to _nRet
	_cQuebra 	+= 	_aQuebras[_nContaFor,3]
//	_cQueryOrd 	+=	_aQuebras[_nContaFor,4]
	if _nContaFor < len(_aQuebras)
		_cQuebra 	+= "+"
//		_cQueryOrd 	+= ","
	endif
Next _nContaFor

return(_nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VERIFPAG บAutor  ณMarcos Zanetti      บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a necessidade de quebra de pagina                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
static function VerifPag()
Local _nContCab
If _nLin > _nTamPag

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	_nLin := PROW()+1
	
	for _nContCab := 1 to _nQuebras
		if !empty(&(_aQuebras[_nContCab,1]))
			@ _nLin , 000 Psay &(_aQuebras[_nContCab,1])
			_nLin += 2
		endif
	next _nContCab
	
Endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraExcel บAutor  ณM Zanetti ERP Plus  บ Data ณ  01/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function GeraExcel(_cAlias,_cFiltro,aHeader)

MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraCSV   บAutor  ณM Zanetti ERP Plus  บ Data ณ  01/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX

_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[6] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	(_cAlias)->(dbgotop())
	while (_cAlias)->(!eof())
		
		for _ni := 1 to len(aHeader)
			
			_uValor := ""
			
			if aHeader[_ni,5] == "D" // Trata campos data
				_uValor := dtoc(&(aHeader[_ni,1]))
			elseif aHeader[_ni,5] == "N" // Trata campos numericos
				_uValor := transform(&(aHeader[_ni,1]),aHeader[_ni,2])
			elseif aHeader[_ni,5] == "C" // Trata campos caracter
				_uValor := &(aHeader[_ni,1])
			endIf
			
			fWrite(nHandle, _uValor + IIF(_ni <> len(aHeader),";",""))
			
		next _ni
		
		fWrite(nHandle, cCrLf )
		
		(_cAlias)->(dbskip())
		
	enddo
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert("Falha na cria็ใo do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMarcos Zanetti      บ Data ณ  22/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VALIDPERG()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Da Emissใo "			,"Da Emissใo "			,"Da Emissใo "			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate a Emissใo"		,"Ate a Emissใo"		,"Ate a Emissใo"		,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Da Entrega"			,"Da Entrega"			,"Da Entrega"			,"mv_ch3","D",08,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate Entrega"			,"Ate Entrega"			,"Ate Entrega"			,"mv_ch4","D",08,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Do Pedido"			,"Do Pedido"			,"Do Pedido"			,"mv_ch5","C",06,0,0,"G","","SC5"	,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Ate Pedido"			,"Ate Pedido"			,"Ate Pedido"			,"mv_ch6","C",06,0,0,"G","","SC5"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Do Cliente"			,"Do Cliente"			,"Do Cliente"			,"mv_ch7","C",06,0,0,"G","","CLI"	,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Ate Cliente"			,"Ate Cliente"			,"Ate Cliente"			,"mv_ch8","C",06,0,0,"G","","CLI"	,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Da Loja"				,"Da Loja"				,"Da Loja"				,"mv_ch9","C",02,0,0,"G","",""		,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Ate Loja"			,"Ate Loja"				,"Ate Loja"				,"mv_cha","C",02,0,0,"G","",""		,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Impressใo"			,"Impressใo"			,"Impressใo"			,"mv_chb","N",01,0,0,"C","",""		,"",,"mv_par11","Excel","","","","Relatorio","","","","","","","","","","","")

return