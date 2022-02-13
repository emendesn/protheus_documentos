#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELSPEND บAutor  ณ Marcelo Munhoz     บ Data ณ  16/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Spend Analysis em TReport                     บฑฑ
ฑฑบ          ณ (Dados simples a partir de uma query pronta)               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH - Solicitante: Victor Leao                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELSPEND()

Local oReport
Private cPerg := "RELSPEND"

AjustaSX1()

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELSPEND บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

Local oReport
Local oSection
Local oItemNF

oReport := TReport():New("RELSPEND","Relat๓rio de Spend Analysis","RELSPEND",{|oReport|PrintReport(oReport,"SC7",oSection,oItemNF)},"Este relatorio irแ imprimir o relat๓rio de Spend Analysis.")
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)


oSection := TRSection():New(oReport,OemToAnsi("Spend Analysis"),)
oSection:SetTotalInLine(.F.)

TRCell():New(oSection ,"C7_FILIAL","SB1","Grupo ",,,,{|| CESTABEL})
oReport:Section(1):SetLineStyle(.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSecao de Itens - Section(1):Section(1)                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oItemNF := TRSection():New(oSection,"Pedidos de Compra",{"SC7"},,,)
oItemNF:SetTotalInLine(.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz a quebra de linha para impressao da descricao do produto            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:Section(1):Section(1):SetLineBreak()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do Cabecalho no top da pagina                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:Section(1):Section(1):SetHeaderPage()

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELSPEND บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport,cAliasSC7,oSection,oItemNF)

Local cPart
Local cFilUsuSC7 := oReport:Section(1):GetAdvplExp("SC7")

// Analitico
TRCell():New(oItemNF,"_CSTATUS"		,,"Status"			,								,20							,,{|| cStatus}	,,,"LEFT")
TRCell():New(oItemNF,"_CESTAB"		,,"Estabelecimento"	,								,15							,,{|| cEstabel}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_NUM"  	,,"Numero PC"		,PesqPict("SC7","C7_NUM")		, TamSx3("C7_NUM")[1]		,,{|| cNumPC}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_EMISSAO"	,,"Dt Emissao"		,PesqPict("SC7","C7_EMISSAO")	, TamSX3("C7_EMISSAO")[1]	,,{|| cEmisPC}	,,,"LEFT")
TRCell():New(oItemNF,"CY1_NOME"		,,"Comprador"		,PesqPict("SY1","Y1_NOME")		, TamSX3("Y1_NOME")[1]		,,{|| cCompra}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_NUMSC"	,,"Numero SC"		,PesqPict("SC7","C7_NUMSC")		, TamSX3("C7_NUMSC")[1]		,,{|| cNumSC}	,,,"LEFT")
TRCell():New(oItemNF,"CC1_EMISSAO"	,,"Dt Emissao"		,PesqPict("SC1","C1_EMISSAO")	, TamSX3("C1_EMISSAO")[1]	,,{|| cEmisSC}	,,,"LEFT")
TRCell():New(oItemNF,"_CSOLICIT"	,,"Solicitante"		,PesqPict("SY1","Y1_NOME")		, TamSX3("Y1_NOME")[1]		,,{|| cSolicit}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_FORNECE"	,,"Cod Fornecedor"	,PesqPict("SC7","C7_FORNECE")	, TamSX3("C7_FORNECE")[1]+3	,,{|| cFornec}	,,,"LEFT")
TRCell():New(oItemNF,"CA2_NREDUZ"	,,"Nome Fantasia"	,PesqPict("SA2","A2_NREDUZ")	, TamSX3("A2_NREDUZ")[1]	,,{|| cNReduz}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_PRODUTO"	,,"Cod Produto"		,PesqPict("SC7","C7_PRODUTO")	, TamSX3("C7_PRODUTO")[1]	,,{|| cProduto}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_DESCRI"	,,"Descricao"		,PesqPict("SC7","C7_DESCRI")	, TamSX3("C7_DESCRI")[1]	,,{|| cDescri}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_LOCAL"	,,"Armazem"			,PesqPict("SC7","C7_LOCAL")		, TamSX3("C7_LOCAL")[1]		,,{|| cLocal}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_QUANT"	,,"Quantidade"		,PesqPict("SC7","C7_QUANT")		, TamSX3("C7_QUANT")[1]		,,{|| nQuant}	,,,"RIGHT")
TRCell():New(oItemNF,"CC7_UM"		,,"U.M."			,PesqPict("SC7","C7_UM")		, TamSX3("C7_UM")[1]		,,{|| cUM}		,,,"LEFT")
TRCell():New(oItemNF,"CC7_PRECO"	,,"Preco Unitario"	,PesqPict("SC7","C7_PRECO")		, TamSX3("C7_PRECO")[1]		,,{|| nPreco}	,,,"RIGHT")
TRCell():New(oItemNF,"CC7_TOTAL"	,,"Total"			,PesqPict("SC7","C7_TOTAL")		, TamSX3("C7_TOTAL")[1]		,,{|| nTotal}	,,,"RIGHT")
TRCell():New(oItemNF,"_NSLDQTD"		,,"Saldo Quantidade",PesqPict("SC7","C7_QUANT")		, TamSX3("C7_QUANT")[1]		,,{|| nSldQtd}	,,,"RIGHT")
TRCell():New(oItemNF,"CC7_PICM" 	,,"Aliq.ICM"		,PesqPict("SC7","C7_PICM")		, TamSX3("C7_PICM")[1]		,,{|| nPICM}	,,,"RIGHT")
TRCell():New(oItemNF,"CC7_IPI"		,,"Aliq.IPI"		,PesqPict("SC7","C7_IPI")		, TamSX3("C7_IPI")[1]		,,{|| nIPI}		,,,"RIGHT")
TRCell():New(oItemNF,"CA5_CODPRF"	,,"Cod Prod Fornec"	,PesqPict("SA5","A5_CODPRF")	, TamSX3("A5_CODPRF")[1]	,,{|| cCodPFor}	,,,"LEFT")
TRCell():New(oItemNF,"CE4_DESCRI"	,,"Condicao Pagto"	,PesqPict("SE4","E4_DESCRI")	, TamSX3("E4_DESCRI")[1]	,,{|| cCondPag}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_CONTA"	,,"Conta Contabil"	,PesqPict("SC7","C7_CONTA")		, TamSX3("C7_CONTA")[1]		,,{|| cConta}	,,,"LEFT")
TRCell():New(oItemNF,"CC7_CC"   	,,"Centro de Custo"	,PesqPict("SC7","C7_CC")		, TamSX3("C7_CC")[1]		,,{|| cCC}		,,,"LEFT")
TRCell():New(oItemNF,"CC7_DATPRF"	,,"Dt Entrega"		,PesqPict("SC7","C7_DATPRF")	, TamSX3("C7_DATPRF")[1]	,,{|| cEntrega}	,,,"LEFT")
TRCell():New(oItemNF,"CMOEDA"		,,"Moeda"			,"@!"							, 10						,,{|| cMoeda}	,,,"LEFT")
TRCell():New(oItemNF,"CF4_TEXTO"	,,"Categoria"		,PesqPict("SF4","F4_TEXTO")		, TamSX3("F4_TEXTO")[1]		,,{|| cTES}		,,,"LEFT")
TRCell():New(oItemNF,"CC7_OBS"		,,"Observacao"		,PesqPict("SC7","C7_OBS")		, TamSX3("C7_OBS")[1]		,,{|| cObs}		,,,"LEFT")

TRFunction():New(oItemNF:Cell("CC7_QUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oItemNF:Cell("CC7_TOTAL"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

oReport:Section(1):Section(1):Cell("_CSTATUS"		):SetBlock({|| cStatus})
oReport:Section(1):Section(1):Cell("_CESTAB"		):SetBlock({|| cEstabel})
oReport:Section(1):Section(1):Cell("CC7_NUM"		):SetBlock({|| cNumPC})
oReport:Section(1):Section(1):Cell("CC7_EMISSAO"	):SetBlock({|| cEmisPC})
oReport:Section(1):Section(1):Cell("CY1_NOME"		):SetBlock({|| cCompra})
oReport:Section(1):Section(1):Cell("CC7_NUMSC"	):SetBlock({|| cNumSC})
oReport:Section(1):Section(1):Cell("CC1_EMISSAO"	):SetBlock({|| cEmisSC})
oReport:Section(1):Section(1):Cell("_CSOLICIT"	):SetBlock({|| cSolicit})
oReport:Section(1):Section(1):Cell("CC7_FORNECE"	):SetBlock({|| cFornec})
oReport:Section(1):Section(1):Cell("CA2_NREDUZ"	):SetBlock({|| cNReduz})
oReport:Section(1):Section(1):Cell("CC7_PRODUTO"	):SetBlock({|| cProduto})
oReport:Section(1):Section(1):Cell("CC7_DESCRI"	):SetBlock({|| cDescri})
oReport:Section(1):Section(1):Cell("CC7_LOCAL"	):SetBlock({|| cLocal})
oReport:Section(1):Section(1):Cell("CC7_QUANT"	):SetBlock({|| nQuant})
oReport:Section(1):Section(1):Cell("CC7_UM"		):SetBlock({|| cUM})
oReport:Section(1):Section(1):Cell("CC7_PRECO"	):SetBlock({|| nPreco})
oReport:Section(1):Section(1):Cell("CC7_TOTAL"	):SetBlock({|| nTotal})
oReport:Section(1):Section(1):Cell("_NSLDQTD"		):SetBlock({|| nSldQtd})
oReport:Section(1):Section(1):Cell("CC7_PICM"		):SetBlock({|| nPICM})
oReport:Section(1):Section(1):Cell("CC7_IPI"		):SetBlock({|| nIPI})
oReport:Section(1):Section(1):Cell("CA5_CODPRF"	):SetBlock({|| cCodPFor})
oReport:Section(1):Section(1):Cell("CE4_DESCRI"	):SetBlock({|| cCondPag})
oReport:Section(1):Section(1):Cell("CC7_CONTA"	):SetBlock({|| cConta})
oReport:Section(1):Section(1):Cell("CC7_CC"		):SetBlock({|| cCC})
oReport:Section(1):Section(1):Cell("CC7_DATPRF"	):SetBlock({|| cEntrega})
oReport:Section(1):Section(1):Cell("CMOEDA"		):SetBlock({|| cMoeda})
oReport:Section(1):Section(1):Cell("CF4_TEXTO"	):SetBlock({|| cTes})
oReport:Section(1):Section(1):Cell("CC7_OBS"		):SetBlock({|| cObs})

oSection:BeginQuery()

// Monta filtro antes de executar o BEGINSQL
cPart := "%AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'" 
cPart += " AND C7_FORNECE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'" 
cPart += " AND C7_PRODUTO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'" 
cPart += " AND C7_NUM     BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "'"
if mv_par01 == 1 // Alphaville
	cPart += " AND C7_FILIAL = '02' "
elseif mv_par01 == 2 // Osasco
	cPart += " AND C7_FILIAL = '06' "
endif
if mv_par02 == 1 // Aberto
	cPart += " AND C7_RESIDUO <> 'S' AND C7_QUANT > C7_QUJE "
elseif mv_par02 == 2 // Encerrado
	cPart += " AND C7_RESIDUO = 'S' OR C7_QUANT <= C7_QUJE "
endif
cPart += "%"

BeginSql alias "QRYSC7"

	SELECT C7_FILIAL, C7_NUM, C7_EMISSAO, 
	       Y1_NOME, 
	       C7_NUMSC, C1_EMISSAO, C1_USER, 
	       C7_FORNECE, C7_LOJA, A2_NREDUZ, 
	       C7_PRODUTO, C7_DESCRI, C7_LOCAL, C7_QUANT, C7_QUJE, C7_RESIDUO, C7_UM,
	       C7_PRECO, C7_TOTAL, C7_PICM, C7_IPI, 
	       A5_CODPRF, 
	       E4_DESCRI, 
	       C7_CONTA, C7_CC, C7_DATPRF, C7_MOEDA, C7_TES, C7_OBS
	FROM  %table:SC7% SC7
	JOIN  %table:SA2% SA2
	ON    A2_FILIAL = %xfilial:SA2% AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.%notDel%
	LEFT OUTER JOIN  %table:SY1% SY1
	ON    Y1_FILIAL = %xfilial:SY1% AND Y1_USER = C7_USER AND SY1.%notDel%
	LEFT OUTER JOIN  %table:SE4% SE4
	ON    E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = C7_COND AND SE4.%notDel%
	LEFT OUTER JOIN  %table:SA5% SA5
	ON    A5_FILIAL = %xfilial:SA5% AND A5_FORNECE = C7_FORNECE AND A5_LOJA = C7_LOJA AND A5_PRODUTO = C7_PRODUTO AND SA5.%notDel%
	LEFT OUTER JOIN  %table:SC1% SC1
	ON    C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1.%notDel%
	WHERE SC7.%notDel%
	      %exp:cPart%
	ORDER BY C7_FILIAL, C7_NUM, C7_ITEM 

EndSql

oSection:EndQuery()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                                                                        ณ
//ณ                        I M P R E S S A O                               ณ
//ณ                                                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:SetMeter(QRYSC7->(reccount()))
oReport:Section(1):Section(1):Init()

cNumPC := ""
cEstabel := ""

PswOrder(1) // pesquisa por c๓digo

QRYSC7->(dbgotop())
While QRYSC7->(!Eof())

	if oReport:Cancel()
		exit
	endif

	// Define nome da filial (Alphaville ou Osasco)
	_cFilial := iif(QRYSC7->C7_FILIAL == "02", "Alphaville", iif(QRYSC7->C7_FILIAL == "06", "Osasco", "-"))

	oReport:Section(1):Init()
	oReport:Section(1):Section(1):Init()
	cEstabel := _cFilial 
	oReport:Section(1):PrintLine()

	// Encontra nome do solicitante a partir do seu codigo de usuario
	_cSolicit := "" 
	if !empty(QRYSC7->C1_USER) .and. PswSeek(alltrim(QRYSC7->C1_USER)) // Ex: c๓digo do usuแrio
		_aPswDet1 := PswRet(1) // Retorna um array multidimensional contendo os dados do usuแrio
		_cSolicit := alltrim(_aPswDet1[1,2])
	endif
	
	// Define descricao da operacao (TES)
	_cTES    := posicione("SF4",1,xFilial("SF4") + QRYSC7->C7_TES, "F4_TEXTO")
	
	// Define status do item do pedido de compra
	_cStatus := iif(QRYSC7->C7_RESIDUO == "S", "Residuo Eliminado", iif(QRYSC7->C7_QUJE == 0, "Aberto", iif(QRYSC7->C7_QUJE < QRYSC7->C7_QUANT, "Parcial", "Encerrado")))

	cStatus  := _cStatus
	cEstabel := _cFilial
	cNumPC   := QRYSC7->C7_NUM
	cEmisPC  := QRYSC7->C7_EMISSAO
	cCompra  := QRYSC7->Y1_NOME
	cNumSC   := QRYSC7->C7_NUMSC
	cEmisSC  := QRYSC7->C1_EMISSAO
	cSolicit := _cSolicit
	cFornec  := QRYSC7->C7_FORNECE+'-'+QRYSC7->C7_LOJA
	cNReduz  := QRYSC7->A2_NREDUZ
	cProduto := QRYSC7->C7_PRODUTO
	cDescri  := QRYSC7->C7_DESCRI
	cLocal   := QRYSC7->C7_LOCAL
	nQuant   := QRYSC7->C7_QUANT
	cUM      := QRYSC7->C7_UM
	nPreco   := QRYSC7->C7_PRECO
	nTotal   := QRYSC7->C7_TOTAL
	nSldQtd  := QRYSC7->C7_QUANT - QRYSC7->C7_QUJE
	nPICM    := QRYSC7->C7_PICM
	nIPI     := QRYSC7->C7_IPI
	cCodPFor := QRYSC7->A5_CODPRF
	cCondPag := QRYSC7->E4_DESCRI
	cConta   := QRYSC7->C7_CONTA
	cCC      := QRYSC7->C7_CC
	cEntrega := QRYSC7->C7_DATPRF
	cMoeda   := GETMV("MV_MOEDA"+alltrim(str(QRYSC7->C7_MOEDA)))
	cTES     := _cTES
	cObs     := QRYSC7->C7_OBS
	
	oReport:IncMeter()

	// Imprime a linha de valores (layout analitico)
	oReport:Section(1):Section(1):PrintLine()	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Altera texto do Total para cada PEDIDO DE COMPRA               		   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport:Section(1):Section(1):Finish()
	oReport:Section(1):Finish()	

	QRYSC7->(dbSkip())

enddo    

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELSPEND บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AjustaSX1()

PutSX1(cPerg,'01','Filial'                        ,'Filial'                        ,'Filial'                        ,'mv_ch1','N',1 ,0,0,'C',''                    ,''      ,'','S','mv_par01','Alphaville'     ,'Alphaville'     ,'Alphaville'     ,'','Osasco'         ,'Osasco'         ,'Osasco'         ,'Ambas'          ,'Ambas'          ,'Ambas'          ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Status'                        ,'Status'                        ,'Status'                        ,'mv_ch2','N',1 ,0,0,'C',''                    ,''      ,'','S','mv_par02','Em aberto'      ,'Em aberto'      ,'Em aberto'      ,'','Encerrado'      ,'Encerrado'      ,'Encerrado'      ,'Todos'          ,'Todos'          ,'Todos'          ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'03','Emissao Inicial'               ,'EmissaoInicial'               ,'Emissao Inicial'               ,'mv_ch3','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par03',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'04','Emissao Final'                 ,'Emissao Final'                 ,'Emissao Final'                 ,'mv_ch4','D',8 ,0,0,'G',''                    ,''      ,'','S','mv_par04',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'05','Fornecedor Inicial'            ,'Fornecedor Inicial'            ,'Fornecedor Inicial'            ,'mv_ch5','C',6 ,0,0,'G',''                    ,'SA2'   ,'','S','mv_par05',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'06','Fornecedor Final'              ,'Fornecedor Final'              ,'Fornecedor Final'              ,'mv_ch6','C',6 ,0,0,'G',''                    ,'SA2'   ,'','S','mv_par06',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'07','Produto Inicial'               ,'Produto Inicial'               ,'Produto Inicial'               ,'mv_ch7','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par07',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'08','Produto Final'                 ,'Produto Final'                 ,'Produto Final'                 ,'mv_ch8','C',15,0,0,'G',''                    ,'SB1'   ,'','S','mv_par08',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'09','Pedido Inicial'                ,'Pedido Inicial'                ,'Pedido Inicial'                ,'mv_ch9','C',6 ,0,0,'G',''                    ,'SC7'   ,'','S','mv_par09',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'10','Pedido Final'                  ,'Pedido Final'                  ,'Pedido Final'                  ,'mv_cha','C',6 ,0,0,'G',''                    ,'SC7'   ,'','S','mv_par10',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')

return()
