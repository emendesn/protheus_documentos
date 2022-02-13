#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NFBGH    บ Autor ณM.Munhoz - ERP PLUS บ Data ณ  06/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao de Notas fiscais de entrada e saida              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function NFBGHimp()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Variaveis para SetPrint e Set Default
Private cString 	 := "SF2"
Private aOrd 		 := {}
Private cDesc1       := "Este programa tem como objetivo imprimir as Notas Fiscais"
Private cDesc2       := "da BGH do Brasil"
Private cDesc3       := "Impressao de Notas Fiscais"
Private limite       := 220
Private tamanho      := "G"
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "NFBGH"
Private titulo       := "Impressao de Notas Fiscais"
Private nLin         := 0
Private wnrel        := "NFBGH"
Private _nLimMinProd := 20
Private _nLimMaxProd := 36
Private _nTamPag 	 := _nLimMaxProd - _nLimMinProd // Tamanho da area de impressao de produtos
Private _nPags		 := 0
Private _nPagAtu	 := 0 
Private _cfvenbo	:= GetMV("MV_CFVENBO")
Private _lbonif    :=.F.
Private _Duplicata  := "S"
Private COMPRESSAO := CHR(15)  // Caracter de Compressao
Private NORMAL     := CHR(18)  // Caracter de impressใo Normal
_aPIS       := {}
_aCOFINS    := {}
_aCSLL      := {}
	

u_GerA0003(ProcName())


/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณmv_par01 - Da Nota Fiscal         ณ
ณmv_par02 - Ate Nota Fiscal        ณ
ณmv_par03 - Da Serie               ณ
ณmv_par04 - Tipo (Entrada ou Saida)ณ
ณmv_par05 - Imprime Duplicatas     ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
ValidPerg()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se formulario estiver posicionado, monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if verimp()  // Verifica o formulario
	RptStatus({|| CriaNF() },"Imprimindo NF")
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ  CRIANF  บ Autor ณ AP5 IDE            บ Data ณ  01/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CriaNF()
Local nOrig := 0
Local ntotcfo := 0                                 
Local cDoc := "@#@#"
Local cSerie := "!@!"
Local aNatureza := {}
Local nNat  := 0
Local lBonus := .f.         

SetPrvt("_cNumNF,_cDuplic,_cCliente,_cLoja,_dEmissao,_nValFat,_nValMerc,_nBsICMS,_nVlICMS")
SetPrvt("_nBsIPI,_nVlIPI,_nBsISS,_nVlISS,_nBsICMSST,_nVlICMSST,_nVlFrete,_nVlSeguro,_nVlDespAc")
SetPrvt("_nVolumes,_nPesoLiq,_nPesoBrt,_cMarca,_cPedVen,_aCodProd,_aCodPNF,_aDescPro,_aPosIPI,_nServ, _nValServ")
SetPrvt("_aClasFis,_aSitTrib,_aProdUM,_aValUnit,_aValTot,_aAliqICMS,_aAliqIPI,_aLenDesc, _aImpresso")
SetPrvt("_aValIPI,_aValISS,_cNomCli,_cCGCCli,_cEndCli,_cBairro,_cCEPCli,_cIECLi,_cMunCli")
SetPrvt("_cFoneCli,_cEstCli,_cNatOp,_cNatureza,_cSuframa,_cEndCob1,_cEndCob2,_cEndEnt1,_cEndEnt2,_aDuplic,_cTESMenP")
SetPrvt("_cNomTrans,_aQtdVen,_cPedido,_cEndTrans,_cMunTrans,_cEstTrans,_cPedCli,_cCodCli")
SetPrvt("_cCGCTrans,_cIETrans,_cTpFrete,_aIMEINovo")
SetPrvt("_aPosIPI,_cClasFis,_npClasFis,_cCondPag,_aParcelas,_nCont,_aEspecTecn,_cQuery")
SetPrvt("_nValISS, _nValIRRF, _nAliqISS, _cMenPad, _cMenNota, _cBaseKit, _nQtdKit, ")
Private lImpItens := .t. // Claudia 29/12/2008 flag para imprimir todos os itens (NF complemetar de Importacao nao precisa)
private _nZFMerc := 0
private _nZFIcm  := 0
private _nZFPis  := 0
private _nZFCof  := 0      
Private aOrigem  := {}


_cBaseKit := ""
_nQtdKit  := 0
_nVlIPI   := 0
_cNatOp   := "" // Declarado fora do MV_PAR04 -- Edson Rodrigues 05/11/02
_cNatureza := ""


SetRegua(val(mv_par02)-val(mv_par01))

SA1->(dbsetorder(1)) // A1_FILIAL + A1_COD + A1_LOJA
SA2->(dbsetorder(1)) // A2_FILIAL + A2_COD + A2_LOJA
SA4->(dbsetorder(1)) // A4_FILIAL + A4_COD
SB1->(dbsetorder(1)) // B1_FILIAL + B1_COD
SC5->(dbsetorder(1)) // C5_FILIAL + C5_NUM
SC6->(dbsetorder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
SD1->(dbsetorder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
SD2->(dbsetorder(3)) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SE1->(dbsetorder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
SE4->(dbsetorder(1)) // E4_FILIAL + E4_CODIGO
SF1->(dbsetorder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
SF2->(dbsetorder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL
SF4->(dbsetorder(1)) // F4_FILIAL + F4_CODIGO

// Query com os dados das NF's (Entrada ou Saida) ou a serem impressas
if mv_par04 == 1 // Entrada
	
	_cQuery := " SELECT F1_DOC     'DOC'    , F1_SERIE   'SERIE'  , F1_FORNECE 'CLIFOR' , F1_LOJA    'LOJA'   , "
	_cQuery += "        F1_BASEICM 'BASEICM', F1_VALICM  'VALICM' , F1_BASEIPI 'BASEIPI', F1_VALIPI  'VALIPI' , "
	_cQuery += "        F1_VALMERC 'VALMERC', F1_VALBRUT 'VALBRUT', F1_DESPESA 'DESPESA', F1_FRETE   'FRETE'  , "
	_cQuery += "        F1_SEGURO  'SEGURO' , F1_ESPECIE 'ESPECIE', F1_TIPO    'TIPO'   , F1_EMISSAO 'EMISSAO', "
//// Alterada em 04/11/2008 - Luiz Ferreira -  Listar na impressใo da nf o valor total da nota (tirar o VALOR o Desconto)
//	_cQuery += "        F1_ICMSRET 'ICMSRET', F1_BRICMS  'BRICMS'                                              , "                                         "
	_cQuery += "        F1_ICMSRET 'ICMSRET', F1_BRICMS  'BRICMS' , F1_DESCONT 'DESCONTO' ,F1_VNAGREG 'VLRCOMPL',"                                         "
	_cQuery += "        F1_XNUMDI 'NUMDI' , F1_XDTDI 'DATADI', " // CLAUDIA 29/12/2008 - DADOS DA D.I. DECLARACAO DE IMPORTACAO
	_cQuery += "        D1_COD     'CODIGO' , D1_UM      'UNIDADE', D1_QUANT   'QUANT'  , D1_VUNIT   'VALOR'  , "
	_cQuery += "        D1_TOTAL   'TOTAL'  , D1_VALICM  'ICMITEM', D1_VALIPI  'IPIITEM', D1_IPI     'ALIQIPI', "
	_cQuery += "        D1_TES     'TES'    , D1_CF      'CFO'    , D1_NFORI   'NFORI'  , D1_SERIORI 'SERIORI', "
	_cQuery += "        D1_PICM    'ALIQICM', D1_VALIMP6 'PIS'    , D1_VALIMP5 'COFINS' , D1_VALIMP4 'CSLL'   , "
	_cQuery += "        D1_CLASFIS 'CLASFIS', D1_ITEM    'ITEM'   , D1_VALISS  'VALISS' , "
	_cQuery += "        B1_POSIPI  'POSIPI' , B1_DESC    'PRODUTO', B1_XCODNF  'CODNOTA', "
	_cQuery += "        F4_MENNOTA 'NATOPER', F4_ISS     'ISS'    , F4_RODAIPI 'RODAIPI', F4_FORMULA 'FORMULA', "
	_cQuery += "        F4_TEXTO   'TEXTO'  , F4_DUPLIC 'DUPLICATA', "
	_cQuery += "        0  'PLIQUI' , 0  'PBRUTO' , 0  'VALFAT' , 0  'BASEISS', 0  'VALISS' , 0  'VOLUME1', 0 'C5_BASEIPI', 0 'QTDKIT' , "
	_cQuery += "        '' 'PEDIDO' , '' 'ESPECI1', '' 'TRANSP' , '' 'BASEKIT', '' 'TPFRETE', '' 'CONDPAG', 1 'NF'        , 0 'VALIRRF', "
	_cQuery += "        0  'PRODISS', 0  'ALIQISS', 0  'ISSITEM', '' 'MENPAD' , '' 'MENNOTA', "
	_cQuery += "        '' 'CLIENTR', '' 'LOJAENT', 0  'ALIQCOF', 0  'ALIQPIS', 0  'DESCZFR', '' ITEMPV  " 
	_cQuery += " FROM   "+RetSqlName("SF1")+" AS F1 (nolock) "
	_cQuery += " JOIN   "+RetSqlName("SD1")+" AS D1 (nolock) "
	_cQuery += " ON     D1_FILIAL  = F1_FILIAL  AND D1_DOC  = F1_DOC  AND D1_SERIE = F1_SERIE AND "
	_cQuery += "        D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND F1_TIPO  = D1_TIPO  AND D1.D_E_L_E_T_ = ''"
	_cQuery += " JOIN   "+RetSqlName("SB1")+" AS B1 (nolock) "
	_cQuery += " ON      B1_COD  = D1_COD  AND B1.D_E_L_E_T_ = ''"
	_cQuery += " JOIN   "+RetSqlName("SF4")+" AS F4 (nolock) "
	_cQuery += " ON     F4_FILIAL = '' AND F4_CODIGO = D1_TES AND F4.D_E_L_E_T_ = ''"
	_cQuery += " WHERE  F1.D_E_L_E_T_ = ''"
	_cQuery += "        AND F1_FILIAL = '"+xFilial("SF1")+"'"
	_cQuery += "        AND F1_FORMUL = 'S'"
	_cQuery += "        AND F1_DOC    BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "        AND F1_SERIE  = '"+MV_PAR03+"' " 
	/* claudia 26/01/09 SOLICITAR FORNECEDOR E LOJA, POIS EXISTEM NFs COM MESMO NUMERO P/FORNECEDORES DIFERENTES */
	If !EMPTY(MV_PAR07)
		_cQuery += "        AND F1_FORNECE  >= '"+MV_PAR07+"' " 
	ENDIF                                                                                                          
	If !EMPTY(MV_PAR08)
		_cQuery += "        AND F1_LOJA  >= '"+MV_PAR08+"' " 
	ENDIF                                                    
	If !EMPTY(MV_PAR09)
		_cQuery += "        AND F1_FORNECE  <= '"+MV_PAR09+"' " 
	ENDIF                                                                                                          
	If !EMPTY(MV_PAR10)
		_cQuery += "        AND F1_LOJA  <= '"+MV_PAR10+"' " 
	ENDIF                                                       
	/* ------------------------------------------------------------------------------------------ */
	_cQuery += " ORDER BY D1_DOC, D1_SERIE, D1_COD, D1_ITEM"
	
	
/*B1_FILIAL  = D1_FILIAL  AND*/	
	
elseif mv_par04 == 2 // Notas Fiscais de Saida
	
	_cQuery := " SELECT F2_DOC     'DOC'    , F2_SERIE   'SERIE'  , F2_CLIENTE 'CLIFOR' , F2_LOJA    'LOJA'   , "
	_cQuery += "        F2_BASEICM 'BASEICM', F2_VALICM  'VALICM' , F2_BASEIPI 'BASEIPI', F2_VALIPI  'VALIPI' , "
	_cQuery += "        F2_VALMERC 'VALMERC', F2_VALBRUT 'VALBRUT', F2_DESPESA 'DESPESA', F2_FRETE   'FRETE'  , "
	_cQuery += "        F2_SEGURO  'SEGURO' , F2_ESPECIE 'ESPECIE', F2_TIPO    'TIPO'   , F2_EMISSAO 'EMISSAO', "
//// Alterada em 04/11/2008 - Luiz Ferreira -  Listar na impressใo da nf o valor total da nota (tirar o Valor de Desconto)
//	_cQuery += "        F2_TRANSP  'TRANSP' , F2_PLIQUI  'PLIQUI' , F2_PBRUTO  'PBRUTO'                        , "
	_cQuery += "        F2_TRANSP  'TRANSP' , F2_PLIQUI  'PLIQUI' , F2_PBRUTO  'PBRUTO' , 0  'DESCONTO'     , " 
	_cQuery += "        F2_VALFAT  'VALFAT' , F2_ICMSRET 'ICMSRET', F2_BASEISS 'BASEISS', F2_VALISS  'VALISS' , "
	_cQuery += "        F2_BRICMS  'BRICMS' , F2_VOLUME1 'VOLUME1', F2_ESPECI1 'ESPECI1', F2_VALIRRF 'VALIRRF', "
	_cQuery += "        D2_COD     'CODIGO' , D2_UM      'UNIDADE', D2_QUANT   'QUANT'  , D2_PRCVEN  'VALOR'  , "
	_cQuery += "        D2_TOTAL   'TOTAL'  , D2_DESC 'DESCONT'   , D2_VALICM  'ICMITEM', D2_VALIPI  'IPIITEM', D2_IPI     'ALIQIPI', "
	_cQuery += "        D2_TES     'TES'    , D2_CF      'CFO'    , D2_NFORI   'NFORI'  , D2_SERIORI 'SERIORI', "
	_cQuery += "        D2_PICM    'ALIQICM', D2_VALIMP6 'PIS'    , D2_VALIMP5 'COFINS' , D2_VALIMP4 'CSLL'   , "
	_cQuery += "        D2_CLASFIS 'CLASFIS', D2_ITEM    'ITEM'   , D2_VALISS  'ISSITEM', D2_ALIQISS 'ALIQISS', D2_LOTECTL,"
	_cQuery += "        PRODUTO = CASE WHEN B1_DESCFIS = '' THEN B1_DESC ELSE B1_DESCFIS END, "
	_cQuery += "        B1_POSIPI  'POSIPI' , B1_CODISS  'CODISS' , B1_ALIQISS 'PRODISS', B1_XCODNF  'CODNOTA', "
	_cQuery += "        F4_MENNOTA 'NATOPER', F4_ISS     'ISS'    , F4_RODAIPI 'RODAIPI', F4_TEXTO   'TEXTO'  , "
	_cQuery += "        F4_FORMULA 'FORMULA', F4_DUPLIC 'DUPLICATA',"
	_cQuery += "        C5_B_KIT   'BASEKIT', C5_QTDKIT  'QTDKIT' , C5_NUM     'PEDIDO' , C5_BASEIPI 'C5_BASEIPI', "
	_cQuery += "        C5_TPFRETE 'TPFRETE', C5_CONDPAG 'CONDPAG', C5_MENPAD  'MENPAD' , C5_MENNOTA 'MENNOTA   ', "
	_cQuery += "        C5_CLIENT  'CLIENTR', C5_LOJAENT 'LOJAENT', 2          'NF'     , "
	_cQuery += "        D2_ALQIMP5 'ALIQCOF', D2_ALQIMP6 'ALIQPIS', D2_DESCZFR 'DESCZFR', D2_ITEMPV  'ITEMPV'  "
	_cQuery += " FROM   "+RetSqlName("SF2")+" AS F2 (nolock) "
	_cQuery += " JOIN   "+RetSqlName("SD2")+" AS D2 (nolock) "
	_cQuery += " ON     D2_FILIAL  = F2_FILIAL  AND D2_DOC  = F2_DOC  AND D2_SERIE = F2_SERIE AND "
	_cQuery += "        D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND D2_TIPO  = F2_TIPO  AND D2.D_E_L_E_T_ = ''"
	_cQuery += " JOIN   "+RetSqlName("SB1")+" AS B1 (nolock) "
	_cQuery += " ON     B1_FILIAL  = '"+xFilial("SB1")+"' AND B1_COD  = D2_COD  AND B1.D_E_L_E_T_ = ''"
	_cQuery += " JOIN   "+RetSqlName("SF4")+" AS F4 (nolock) "
	_cQuery += " ON     F4_FILIAL = '"+xFilial("SF4")+"' AND F4_CODIGO = D2_TES AND F4.D_E_L_E_T_ = ''"
	_cQuery += " JOIN   "+RetSqlName("SC5")+" AS C5 (nolock) "
	_cQuery += " ON     C5_FILIAL = D2_FILIAL   AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = ''"
	_cQuery += " WHERE  F2.D_E_L_E_T_ = ''"
	_cQuery += "        AND F2_FILIAL = '"+xFilial("SF2")+"' "
	_cQuery += "        AND F2_SERIE  = '"+MV_PAR03+"' "
	_cQuery += "        AND F2_DOC    BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	/* claudia 26/01/09 SOLICITAR FORNECEDOR E LOJA, POIS EXISTEM NFs COM MESMO NUMERO P/FORNECEDORES DIFERENTES */
	If !EMPTY(MV_PAR07)
		_cQuery += "        AND F2_CLIENTE  >= '"+MV_PAR07+"' " 
	ENDIF                                                                                                          
	If !EMPTY(MV_PAR08)
		_cQuery += "        AND F2_LOJA  >= '"+MV_PAR08+"' " 
	ENDIF                                                    
	If !EMPTY(MV_PAR09)
		_cQuery += "        AND F2_CLIENTE  <= '"+MV_PAR09+"' " 
	ENDIF                                                                                                          
	If !EMPTY(MV_PAR10)
		_cQuery += "        AND F2_LOJA  <= '"+MV_PAR10+"' " 
	ENDIF                                                       
	/* ------------------------------------------------------------------------------------------ */

	_cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_COD, D2_ITEM"
	
endif

TCQUERY _cQuery NEW ALIAS "QRY"
//TcSetField("EMISSAO","D")

/*------------------------- claudia 14/11/2008 buscar CFOP correto e Natureza correta quando imprime mais de uma NF------- */
		dbSelectArea("QRY") 
    	//If mv_par04 == 2 // saida  alterado Edson Rodrigues 05/11/08
		QRY->(dbgotop())   
		//_cNatOp := ''  //alterado Edson Rodrigues 05/11/08
		
		If cNumEmp=='0201' //Incluso Edson Rodrigues 07/11/08
		   ntotcfo := 0 // claudia 12/11/08 para contar cfop e nao deixar colocar + 2
		   while QRY->(!eof())                              
		   		If  QRY->DOC <> cDoc .OR. QRY->SERIE <> cSerie // Claudia 14/11/2008 - qdo imprimia + de uma nota, saia o cFop errado.
					_cNatOp := ''	   			
					lBonus  := .F.
					ntotcfo := 0      
					_cNatureza	:= ''
					cDoc   := QRY->DOC
					cSerie := QRY->SERIE				
		        Endif
		    	If !Alltrim(QRY->CFO) $ _cNatOp                
			    	If !empty(_cNatOp) .and. _cNatOp $ _cfvenbo   //Incluso Edson Rodrigues 07/11/08 
			    	//FtIsBonus({QRY->CODIGO,QRY->QUANT,QRY->TES})
				    	if ntotcfo = 1  // claudia 12/11/08 para contar cfop e nao deixar colocar + 2
				    		If lBonus .AND. FtIsBonus({QRY->CODIGO,QRY->QUANT,QRY->TES}) // claudia 28/12/2008 eh TES de BONUS, mas ja gravou Bonus]
				    			QRY->(dbskip())		
				    			Loop
				    		Endif
				    		If !lBonus .AND. !FtIsBonus({QRY->CODIGO,QRY->QUANT,QRY->TES}) // claudia 28/12/2008 eh TES de BONUS, mas ja gravou Bonus]
				    			QRY->(dbskip())		
				    			Loop
				    		Endif
							_cNatOp		:= alltrim(_cNatOp)+"/"+alltrim(QRY->CFO)
							_cNatureza	:= substr(alltrim(_cNatureza),1,24)+"/"+substr(alltrim(QRY->NATOPER),1,24)  //TEXTO
							nNat := Ascan(aNatureza,{|x| x[1] = QRY->DOC + QRY->SERIE })
							If nNat > 0
								aNatureza[nNat,2] := alltrim(aNatureza[nNat,2])+"/"+alltrim(QRY->CFO)
								aNatureza[nNat,3] := alltrim(aNatureza[nNat,3])+"/"+substr(alltrim(QRY->NATOPER),1,24)  //TEXTO						
							Else        
								AADD(aNatureza,{QRY->DOC + QRY->SERIE, _cNatOp , _cNatureza , })
							Endif
							_lbonif := .T.
			 			endif 
						ntotcfo++
				    else                                             
				      _cNatOp		:= alltrim(QRY->CFO)   
				      _cNatureza	:= alltrim(QRY->NATOPER)  //TEXTO
				      ntotcfo++   
					  If FtIsBonus({QRY->CODIGO,QRY->QUANT,QRY->TES})				                       
						  lBonus := .T.
					  endif
				      AADD(aNatureza,{QRY->DOC + QRY->SERIE, _cNatOp , _cNatureza , })
				    endif	
			    Endif
			QRY->(dbskip())		
		   endDo
		
		Else 
		   //Incluso Edson Rodrigues 07/11/08 
		   //while QRY->(!eof()) // CLAUDIA 10/11/08 SO IMPRIME UM CFOP NAO PRECISA LER TODOS OS ITENS DA QUERY
		  	 If empty(_cNatOp)
		           _cNatOp := alltrim(QRY->CFO)	                     
		           _cNatureza := alltrim(QRY->NATOPER)  // CLAUDIA 10/11/08  NAO IMPRIMIA A NATUREZA
		     endif   
		    // QRY->(dbskip()) // CLAUDIA 10/11/08 SO IMPRIME UM CFOP NAO PRECISA LER TODOS OS ITENS DA QUERY
		   //endDo// CLAUDIA 10/11/08 SO IMPRIME UM CFOP NAO PRECISA LER TODOS OS ITENS DA QUERY
	    Endif   
	    //endif	
			
	/*------------------------------------------------------------------------------------------------	*/
	
_nPag := 0
QRY->(dbgotop())
while QRY->(!eof())
	_cNatOp		:= alltrim(QRY->CFO)   
    _cNatureza	:= alltrim(QRY->NATOPER) 
    /*---  claudia 26/02/09 testar se a tes gera duplicata-*/
    _Duplicata  := QRY->DUPLICATA 
	If mv_par04 == 2 // NF de Saida, buscar NF de Origem atraves do Lote
		_cQuery := " SELECT D1_DOC, D1_SERIE, D1_COD, D1_LOTECTL "   
		_cQuery += " FROM   "+RetSqlName("SD1")+" AS SD1 (nolock) "  
		_cQuery += " WHERE  SD1.D_E_L_E_T_ = ''"                     
		_cQuery += "        AND D1_NFORI = ''"   
		_cQuery += "        AND D1_SERIORI = ''"   
		_cQuery += "        AND D1_LOTECTL NOT IN ('')"
		_cQuery += "        AND D1_FILIAL = '"+xFilial("SD1")+"' "   
		_cQuery += "        AND D1_LOTECTL  = '"+QRY->D2_LOTECTL+"' "   
		_cQuery += "        AND D1_COD  	= '"+QRY->CODIGO+"' "   		
		TCQUERY _cQuery NEW ALIAS "NFORIG"
		NFORIG->(DBGOTOP())
		While ! NFORIG->(EOF())
			nOrig:= Ascan(aOrigem,{ |X| x[1] = ALLTRIM(NFORIG->D1_DOC)+'/'+ALLTRIM(NFORIG->D1_SERIE) })	
			If nOrig = 0
				AADD(aOrigem,{ALLTRIM(NFORIG->D1_DOC)+'/'+ALLTRIM(NFORIG->D1_SERIE) })
			Endif		
			NFORIG->(DbSkip())
		EndDO                           
		dbSelectArea("NFORIG")
		dbCloseArea("NFORIG")
		dbSelectArea("QRY")		
		/*--- claudia - imprimir CFOP E NATUREZA CORRETOS QDO IMPRIME MAIS DE 1 NF  14/11/2008 ---------*/
		nNat := Ascan(aNatureza,{|x| x[1] = QRY->DOC + QRY->SERIE })
		If nNat > 0
			_cNatOp    := aNatureza[nNat,2] 
			_cNatureza := aNatureza[nNat,3]
		Else
			_cNatOp		:= alltrim(QRY->CFO)   
   	        _cNatureza	:= alltrim(QRY->NATOPER) 
		Endif
		/*---------          fim          ---------------------------------------------*/
	EndIF                
	_aPIS       := {}
	_aCOFINS    := {}
	_aCSLL      := {}

	_cNumNF	    := QRY->DOC
	_cSerie		:= QRY->SERIE
	_cCliFor    := QRY->CLIFOR
	_cLoja		:= QRY->LOJA
	_dEmissao	:= dtoc(stod(QRY->EMISSAO))
	_nValFat	:= IIF(_lbonif,QRY->VALMERC,QRY->VALFAT) // Edson Rodrigues (para sair o valor da bonficacao somando todos os itens) 07/11/08
    _nDesconto	:= QRY->DESCONTO
	if _nValFat == 0 
	   _nValFat := QRY->VALMERC + QRY->VALIPI + QRY->SEGURO + QRY->FRETE + QRY->DESPESA + QRY->ICMSRET - QRY->DESCONTO 
	endif                      
	_nValFat := QRY->VALBRUT
	_nValMerc	:= QRY->VALMERC
	/*----- CLAUDIA  09/12/2008 NF COMPLEMENTAR DE IMPORTACAO ----- */   
	// NF DE COMPLEMENTO NAO EXISTE VALOR NOS CAMPOS
	If mv_par04 <> 2 .AND. QRY->TIPO = 'C' 
		IF _nValFat = 0
			_nValFat  := QRY->VLRCOMPL
		EndIf
		If _nValMerc = 0	
			_nValMerc := QRY->VLRCOMPL
		EndIF
	Else // Claudia 20/12/2008 NF DE IMPORTACAO TEM QUE SOMAR OS IMPOSTOS/DESPESAS NA NF 
		IF MV_PAR04 <> 2 // NF DE ENTRADA
			IF QRY->TES $  '310/318' // IMPORTACAO --INCLUSO TES 318 - Edson Rodrigues - 02/03/09
				_nValFat := QRY->VALBRUT
			ENDIF
		ENDIF		
	EndIf
	/*--------------------------------------------------------------*/
	_nBsICMS	:= QRY->BASEICM
	_nVlICMS	:= QRY->VALICM
	_nBsIPI		:= QRY->BASEIPI
//	_nVlIPI		:= QRY->VALIPI
	_nVlIPI		:= 0
	_nBsISS		:= QRY->BASEISS
	_nVlISS		:= QRY->VALISS
	_nBsICMSST	:= QRY->BRICMS
	_nVlICMSST	:= QRY->ICMSRET
	_nVlFrete	:= QRY->FRETE
	_nVlSeguro	:= QRY->SEGURO
	_nVlDespAc	:= QRY->DESPESA
	_nVolumes	:= QRY->VOLUME1
	_cEspecie   := QRY->ESPECI1
	_nValIRRF   := QRY->VALIRRF
	_cTes       := QRY->TES
	_cMarca 	:= ""
	_nServ      := 0
	_nValServ   := 0
	_nValISS    := 0
	_cMenPad    := QRY->MENPAD
	_cMenNota   := QRY->MENNOTA       
	/* ----------------- CLAUDIA 29/12/2008 MENSAGENS DA NF'S DE IMPORTACAO  */
	IF MV_PAR04 <> 2 // NF DE ENTRADA 
		IF QRY->TES $ '310/318' // IMPORTACAO
			_cMenNota := "Ref. D.I no. " + ALLTRIM(QRY->NUMDI)  + " de " + DTOC(stod(QRY->DATADI))
		ENDIF           
		IF QRY->TIPO = 'C' // COMPLEMENTAR
			DbSelectArea("SF1")
			DbSetOrder(1)
			DbSelectArea("SF8")
			DbSetOrder(1)
			MsSeek(xFilial("SF8") + QRY->DOC + QRY->SERIE + QRY->CLIFOR + QRY->LOJA )
			_cMenNota := "Ref. NF de Entrada no. " 
			Do while !SF8->(EOF()) .and. SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN) = QRY->DOC + QRY->SERIE + QRY->CLIFOR + QRY->LOJA
				SF1->( DbSeek( XFilial("SF1") + SF8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)) )
				_cMenNota += alltrim(SF8->F8_NFORIG) + '/' + ALLTRIM(SF8->F8_SERORIG)+ ', de '+ DTOC(SF1->F1_EMISSAO) + ', '
				If At(ALLTRIM(SF1->F1_XNUMDI),_cMenNota) <= 0 .and. !SF1->(Eof()) .and. !Empty(SF1->F1_XNUMDI)
					_cMenNota += " Ref. D.I no. " + ALLTRIM(SF1->F1_XNUMDI)  + " de " + DTOC(SF1->F1_XDTDI)
				EndIF	
				SF8->(DbSkip())
			EndDo
			DbSelectArea("QRY")
		ENDIF                                                     
	ENDIF	
	/*---------------------------------------- */	
	/*--  CLAUDIA - SUBSTITUICAO TRIBUTARIA 14/01/09 ---------------------*/
	IF MV_PAR04 == 2 // NF DE SAIDA 
		
			
		If QRY->TES $ '811/812/822'
			_nBsIcmsSt := 0
			_nVlIcmsSt := 0                         
			IF QRY->TIPO $ "DB" 
				_nValFat   := _nValFAt - QRY->ICMSRET
			Endif
			If QRY->TES $ '822'			             
				_nValFat   := _nValFAt - QRY->ICMSRET
			Endif
		endif
	Else
		If QRY->TES $ '312'
			_nValFat   := _nValFAt + QRY->ICMSRET
		endif			
	Endif  
	
	/* ------------------------------------------------------------------ */
	_cPedido	:= QRY->PEDIDO
	_cPedCli 	:= posicione("SC6",1,xFilial("SC6")+_cPedido,"C6_PEDCLI")
	//_cNatOp		:= QRY->CFO
	//_cNatureza	:= QRY->NATOPER  //TEXTO
	_cTESMenP	:= QRY->FORMULA
	
	_nPesoBrt   := QRY->PBRUTO
	_nPesoLiq   := QRY->PLIQUI
	_cTpFrete	:= QRY->TPFRETE
	_cCondPag	:= QRY->CONDPAG

	// Grava informacoes do Kit, caso este esteja informado no cabecalho do PV de um dos itens da NF
	_cBaseKit   := iif(empty(_cBaseKit).and.!empty(QRY->BASEKIT), QRY->BASEKIT, _cBaseKit)
	_nQtdKit    := iif(_nQtdKit == 0   .and. QRY->QTDKIT <> 0   , QRY->QTDKIT , _nQtdKit )
	
	_aCodProd   := {}
    _aCodPNF    := {}
	_aDescPro   := {}
	_aLenDesc   := {}
	_aClasFis	:= {}
	_aSitTrib	:= {}
	_aProdUM	:= {}
	_aQtdVen	:= {}
	_aValUnit	:= {}
	_aValTot	:= {}
	_aAliqICMS  := {}
	_aAliqIPI	:= {}
	_aValIPI	:= {}
	_aRodaIPI   := {}
	_aValISS	:= {}
	_aPosIPI	:= {}
	_aNFOri  	:= {}
	_aSeriOri	:= {}
	_aImpresso  := {}
	_aIMEINovo  := {}
	_nTotDIC    :=  QRY->DESCONTO
    _nTotDIM    :=  QRY->DESCONTO

	// Preenchimento dos dados do cliente / fornecedor
	if (QRY->TIPO $ "DB" .and. mv_par04 == 2) .or. (!QRY->TIPO $ "DB" .and. mv_par04 == 1 )
		SA2->(dbseek(xFilial("SA2") + QRY->CLIFOR + QRY->LOJA))
		_cCodCli	:= SA2->A2_COD + "-" + SA2->A2_LOJA
		_cNomCli 	:= SA2->A2_NOME
		_cCGCCli    := SA2->A2_CGC
		_cEndCli	:= SA2->A2_END
		_cBairro	:= SA2->A2_BAIRRO
		_cCEPCli	:= SA2->A2_CEP
		_cIECLi		:= SA2->A2_INSCR
		_cMunCli	:= SA2->A2_MUN
		_cFoneCli	:= SA2->A2_TEL
		_cEstCli	:= SA2->A2_EST
		_cEndCob1	:= ""
		_cEndCob2	:= ""
		_cEndEnt1	:= ""
		_cEndEnt2	:= ""
		_cSuframa	:= ""
		_cCodMun 	:= ""
	else
		SA1->(dbseek(xFilial("SA1") + QRY->CLIFOR + QRY->LOJA))
		_cCodCli	:= SA1->A1_COD + "-" + SA1->A1_LOJA
		_cNomCli 	:= SA1->A1_NOME
		_cCGCCli    := SA1->A1_CGC
		_cEndCli	:= SA1->A1_END
		_cBairro	:= SA1->A1_BAIRRO
		_cCEPCli	:= SA1->A1_CEP
		_cIECLi		:= SA1->A1_INSCR
		_cMunCli	:= SA1->A1_MUN
		_cFoneCli	:= SA1->A1_TEL
		_cEstCli	:= SA1->A1_EST
		_cEndCob1	:= alltrim(SA1->A1_ENDCOB)
		_cEndCob2	:= iif(!empty(SA1->A1_ENDCOB) .and. !empty(SA1->A1_CEPC),SA1->A1_CEPC,"")
		_cEndCob2	:= iif(!empty(SA1->A1_ENDCOB) .and. !empty(SA1->A1_MUNC), _cEndCob2 + iif(!empty(_cEndCob2), " - ", "") + alltrim(SA1->A1_MUNC), "")
		_cEndCob2	:= iif(!empty(SA1->A1_ENDCOB) .and. !empty(SA1->A1_ESTC), _cEndCob2 + iif(!empty(_cEndCob2), " - ", "") + alltrim(SA1->A1_ESTC), "")
		_cSuframa	:= SA1->A1_SUFRAMA
		_cCodMun 	:= SA1->A1_CODMUN
		_cInscrM    := SA1->A1_INSCRM
		if !empty(QRY->CLIENTR) .and. SA1->(dbSeek(xFilial("SA1") + QRY->CLIENTR + QRY->LOJAENT))
			_cEndEnt1	:= alltrim(SA1->A1_ENDENT)
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_CEPE),SA1->A1_CEPE,"")
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_MUNE), _cEndEnt2 + iif(!empty(_cEndEnt2), " - ", "") + alltrim(SA1->A1_MUNE), "")
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_ESTE), _cEndEnt2 + iif(!empty(_cEndEnt2), " - ", "") + alltrim(SA1->A1_ESTE), "")
		else
			_cEndEnt1	:= alltrim(SA1->A1_ENDENT)
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_CEPE),SA1->A1_CEPE,"")
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_MUNE), _cEndEnt2 + iif(!empty(_cEndEnt2), " - ", "") + alltrim(SA1->A1_MUNE), "")
			_cEndEnt2	:= iif(!empty(SA1->A1_ENDENT) .and. !empty(SA1->A1_ESTE), _cEndEnt2 + iif(!empty(_cEndEnt2), " - ", "") + alltrim(SA1->A1_ESTE), "")
		endif
	endif
	
	// Criacao de array om as duplicatas geradas apenas para notas de saida diferentes de B ou D
	// e que devam ter as duplicatas impressas (mv_par05 == 1)
	_aDuplic   := {}
	_aParcelas := {}
	if !(QRY->TIPO $ "DB") .and. mv_par04 == 2 .and. mv_par05 == 1
		if SE1->(dbseek(xFilial("SE1") + QRY->SERIE + QRY->DOC))
			while SE1->(!eof()) .and. QRY->SERIE + QRY->DOC == SE1->E1_PREFIXO + SE1->E1_NUM
				if !("NF" $ SE1->E1_TIPO)
					SE1->(dbSkip())
					Loop
				endif
				aadd(_aDuplic, {SE1->E1_NUM + iif(empty(SE1->E1_PARCELA),"","-" + SE1->E1_PARCELA),;
				iif(Dtoc(SE1->E1_VENCREA) == _dEmissao,"QUITADA",dtoc(SE1->E1_VENCREA)) , SE1->E1_VALOR})
				SE1->(dbSkip())
			enddo
		endif
	endif
	
	// Alimenta variaveis com os dados da Transportadora
	_cTransp := QRY->TRANSP
	if !empty(alltrim(_cTransp)) .and. SA4->(dbseek(xfilial("SA4") + _cTransp))
		_cNomTrans	:= SA4->A4_NOME
		_cEndTrans	:= SA4->A4_END
		_cMunTrans	:= SA4->A4_MUN
		_cEstTrans	:= SA4->A4_EST
		_cCGCTrans	:= SA4->A4_CGC
		_cIETrans	:= SA4->A4_INSEST
	else
		_cNomTrans	:= ""
		_cEndTrans	:= ""
		_cMunTrans	:= ""
		_cEstTrans	:= ""
		_cCGCTrans	:= ""
		_cIETrans	:= ""
	endif
	
	while QRY->DOC == _cNumNF .and. QRY->SERIE == _cSerie .and. QRY->(!eof())
		
		
		aadd(_aCodPNF,QRY->CODNOTA)            
		/* ------------- claudia 29/12/2008 NF COMPLEMENTAR NAO IMPRIME ITENS */
		If mv_par04 <> 2 .AND. QRY->TIPO = 'C' 
			aadd(_aCodProd,"")
			aadd(_aDescPro,QuebraLinha(SubStr(Alltrim(Formula("040")),001),30))		                                                	                        
			lImpItens := .f. // nao precisa imprimir os itens, so imprime mensagem da legislacao
		ELSE                                                                                                                                                        
			aadd(_aCodProd,QRY->CODIGO)
			aadd(_aDescPro,QuebraLinha(QRY->PRODUTO,30))
		ENDIF	
		/*---------------------------------------------------------------------------*/
		// Determina o numero de linhas de descricao do produto e guarda no Array _aLenDesc
		// Sera usado na impressao dos itens (veja funcao ImpProd)
		aadd(_aLenDesc,len(_aDescPro[len(_aDescPro)]))
		
		if lImpItens // Claudia 29/12/2008  quando imprime todos os itens, buscar o valor de cada item
			
			
			aadd(_aSitTrib , QRY->CLASFIS )
			aadd(_aProdUM  , QRY->UNIDADE )
			aadd(_aQtdVen  , QRY->QUANT   )
			aadd(_aValUnit , QRY->VALOR + QRY->DESCZFR / QRY->QUANT)
			aadd(_aValTot  , QRY->TOTAL + QRY->DESCZFR)
			aadd(_aAliqICMS, QRY->ALIQICM )
			aadd(_aAliqIPI , QRY->ALIQIPI )
			aadd(_aValIPI  , QRY->IPIITEM )
			aadd(_aRodaIPI , QRY->RODAIPI )
			aadd(_aValISS  , QRY->ISSITEM )
			aadd(_aNFOri   , QRY->NFORI   )
			aadd(_aSeriOri , QRY->SERIORI )
			aadd(_aPIS     , QRY->PIS     )
			aadd(_aCOFINS  , QRY->COFINS  )
			aadd(_aCSLL    , QRY->CSLL    )
			aadd(_aImpresso, "N"  ) 
			
			If mv_par04 == 2  //Edson Rodrigues 01/11/08
			  aadd(_aIMEINovo, {Posicione("SC6",1,xFilial("SC6") + QRY->PEDIDO + QRY->ITEMPV, "C6_IMEINOV"), Posicione("SC6",1,xFilial("SC6") + QRY->PEDIDO + QRY->ITEMPV, "C6_XIMEOLD")})
	        Endif
		else // NF COMPLEMENTAR DE IMPORTACAO nao precisa de valores
			
			aadd(_aSitTrib , "" )
			aadd(_aProdUM  , "" )
			aadd(_aQtdVen  , 0   )
			aadd(_aValUnit ,0    )
			aadd(_aValTot  , 0   )
			aadd(_aAliqICMS, 0  )
			aadd(_aAliqIPI , 0 )
			aadd(_aValIPI  , 0 )
			aadd(_aRodaIPI , "" )
			aadd(_aValISS  , 0 )
			aadd(_aNFOri   , ""    )
			aadd(_aSeriOri , ""  )
			aadd(_aPIS     , 0      )
			aadd(_aCOFINS  , 0 )
			aadd(_aCSLL    , 0    )
			aadd(_aImpresso, "N"  ) 
			
			If mv_par04 == 2  //Edson Rodrigues 01/11/08
			  aadd(_aIMEINovo, "")
	        Endif			
		endif
		if QRY->DESCZFR > 0
			// Calcula o desconto da Zona Franca pra cada item da NF, distribuindo entre ICMS x PIS x COFINS
			_nZFItDesc := QRY->DESCZFR 
			_nZFItBC   := QRY->TOTAL + _nZFItDesc
			_nZFItIcm  := iif(QRY->ICMITEM == 0, _nZFItBC * QRY->ALIQICM / 100, 0)
			_nZFItDesc := _nZFItDesc - _nZFItIcm

			_nZFMerc   += _nZFItBC
			_nZFIcm    += _nZFItIcm 
			_nZFPis    += _nZFItDesc * QRY->ALIQPIS / (QRY->ALIQPIS + QRY->ALIQCOF) 
			_nZFCof    += _nZFItDesc * QRY->ALIQCOF / (QRY->ALIQPIS + QRY->ALIQCOF) 

		endif

		if QRY->RODAIPI <> "N"
			_nVlIPI += QRY->IPIITEM
		endif
		
		if QRY->VOLUME1 == 0
			_nVolumes += QRY->QUANT
		endif
		
		// Tratamento da posicao de IPI
		if !empty(alltrim(QRY->POSIPI))   
			if ascan(_aPosIPI,QRY->POSIPI) == 0
				aadd(_aPosIPI,QRY->POSIPI)
			endif
			_npClasFis := ascan(_aPosIPI,QRY->POSIPI)
			do case
				case _npClasFis == 1
					_cClasFis := "A"
				case _npClasFis == 2
					_cClasFis := "B"
				case _npClasFis == 3
					_cClasFis := "C"
				case _npClasFis == 4
					_cClasFis := "D"
				otherwise
					_cClasFis := " "
			endcase
			if !lImpItens // Claudia 29/12/2008 NF COMPLEMENTAR  DE IMPORTACAO NAO IMPRIME ITENS
				_cClasFis := " "
			Endif
			aadd(_aClasFis,_cClasFis)
		else
			aadd(_aClasFis," ")
		endif
		
		if QRY->ISS == 'S' .and. QRY->ISSITEM > 0
			_cDescServ:= QRY->PRODUTO
			_nValServ += QRY->TOTAL
			_nValISS  += QRY->ISSITEM
			_nAliqISS := QRY->ALIQISS
		endif
		
		_cCompInd := ""
		if mv_par04 == 1
			_cCompInd := iif(QRY->TES == "010", "Compra de aparelhos usados p/ Industrializacao.", _cCompInd)

        endif    
		QRY->(dbskip())
		//If ! lImpItens // Claudia 29/12/2008 - NF complementar de Importacao nao imprime itens entao nao precisa ler todos os itens
		//	EXIT
		//Endif
	enddo
	IF MV_PAR04 <> 2 // NF DE ENTRADA     

			IF _cTES $ '310/318' // IMPORTACAO
				_nPis := _nCofins := _nCsll := 0
		        /* ----- Claudia 13/03/09 Imprimir PIS/COFINS/CSLL PARA NFS DE IMPORTACAO */
				For _nL := 1 to Len(_aPIS)
					_nPis += _aPIS[_nl]
				Next _nl
					
				For _nm := 1 to Len(_aCofins)
					_nCofins += _aCofins[_nm]
				Next _nm
					
				For _nn := 1 to Len(_aCsll)
					_nCsll += _aCsll[_nn]
				Next _nn
					
				if _nPis > 0
					_cMenNota +=  " Pis: " + Alltrim(Transform(_nPis ,"@E 999,999.99"))
				Endif
					
				If _nCofins > 0    
					_cMenNota +=  " Cofins: " + Alltrim(Transform(_nCofins ,"@E 999,999.99"))
				Endif
				
				If _nCsll > 0
					_cMenNota +=  " CSLL: " + Alltrim(Transform(_nCsll ,"@E 999,999.99"))
				Endif
			ENDIF            			
	endif
	// Calcula o numero de formularios necessarios para impressao da nota
	iF lImpItens = .t. // CLAUDIA  29/12/2008 - NF COMPLEMENTAR DE IMPORTACAO SO TERA UMA PAGINA
		_nPags   := CalcPags()
	Else 
		_nPags   := 1		
	Endif	
	_nPagAtu := 1
	
	// Envia os dados para impressao
	Imprime()
	
	If _cNumNF == QRY->DOC
		QRY->(dbskip())
	EndIf
	IncRegua()
	
enddo

dbSelectArea("QRY")
dbCloseArea("QRY")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

SetPgEject(.F.)

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCalcPags  บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  13/11/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Calcula o numero de formularios que serao utilizados       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CalcPags()
local _nk  		 := 0
local _nQtdLin	 := 0
local _nQtdProd := 0
local _nQtdServ := 0
local _nRet		:= 0
local _nProAg   := 0

// Aglutina็ใo de Produtos para Calculo de Pแgina
/*
  Caso o parโmetro esteja setado para aglutinar produtos, essa fun็ใo irแ calcular
  quantos produtos serใo impressos na nota fiscal para efeito de numera็ใo de pแginas
  
  Executa um looping de 1 para total de itens onde irแ contar produtos aglutinados
  quando o c๓digo for igual e valor unitแrio igual descontar na quantidade de produtos
  em rela็ใo a quantidade de pแginas, onde o segundo FOR inicia a partir do indice
  corrente em rela็ใo ao FOR anterior.
*/
If mv_par06 == 1
	for _nk := 1 to len(_aCodProd)
		If _aValISS[_nk] == 0
			for _nj := _nk to len(_aCodProd)
				If _aCodProd[_nj] == _aCodProd[_nk] .And. _aValUnit[_nj] == _aValUnit[_nk] .And. _nj <> _nk
					_nProAg++
				EndIf
			next _nj
		EndIf
	next _nk
EndIf

for _nk := 1 to len(_aCodProd)
	if _aValISS[_nk] == 0
		_nQtdLin += _aLenDesc[_nk]
	else
		If _nQtdServ = 0 // Claudia 27/03/2009 para nao somar pagina a mais
			_nQtdServ++
		Endif	
	endif
next _nk

_nQtdProd := int((_nQtdLin - _nProAg) / _nTamPag) + iif((_nQtdLin - _nProAg) % _nTamPag == 0,0,1)

// Verifica o q precisa de mais paginas para imprimir (servicos ou produtos)
_nRet := iif(_nQtdProd < _nQtdServ, _nQtdServ, _nQtdProd)

return(_nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  01/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Nota Fiscal     ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Nota Fiscal    ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Serie           ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Tipo               ?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Entrada","","","","","Saida","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Imprime Duplicatas ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Aglutina Produtos  ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณQUEBRALINHบ Autor ณM.Munhoz - ERPPLUS  บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Quebra uma string em um array com as linhas do tamanho     บฑฑ
ฑฑบ          ณ especificado                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
static function QuebraLinha(_cTexto,_nTamanho)
local _aRet := {}
local _nPos	:= 0
local _nLines := mlcount(_cTexto,_nTamanho)

for _nContaFor := 1 to _nLines
	if !empty(alltrim(memoline(_cTexto,_nTamanho,_nContaFor)))
		aadd(_aRet,memoline(_cTexto,_nTamanho,_nContaFor))
	endif
next _nContaFor

return(_aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ  VERIMP  บ Autor ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VerImp()
SetPrc(0,0)
dbCommitAll()
@ 000,000 PSAY " "
if aReturn[5] == 3
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		@ 000,000 PSAY " "
		IF MsgYesNo("Fomulario esta posicionado ? ")
			Exit
		ElseIF MsgYesNo("Tenta Novamente ? ")
			Loop
		Else
			Return(.f.)
		Endif
	Enddo
Endif
Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPCABEC บ Autor ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os dados do cabecalho da Nota Fiscal               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpCabec()

@ nLin, 000 PSAY COMPRESSAO
@ nLin, 001 PSAY " "

if mv_par04 == 2
	@ nLin, 090 PSAY "X" //+CHR(20)
else
	@ nLin, 105 PSAY "X" //+CHR(20)
endif

If _nPags > 1
	@ nLin, 117 PSAY alltrim(str(_nPagAtu,3,0))+"/"+alltrim(str(_nPags,3,0))
EndIf

@ nLin, 124 PSAY CHR(14)+_cNumNF+CHR(20)
_nPagAtu++

// Impressao de dados sobre a natureza da operacao
nLin +=5
@ nLin, 002 PSAY _cNatureza // Texto da Natureza de Operacao             
       
If  "/" $ _cNatOp 
	@ nLin, 049 PSAY _cNatOp // Codigo da Natureza de Operacao
Else
	@ nLin, 049 PSAY _cNatOp Picture iif(len(alltrim(_cNatOp))==4,"@R 9.999","@R 9.99")  // Codigo da Natureza de Operacao
Endif	
@ nLin, 064 PSAY ""   //TRANSF(SM0->M0_INSC,"@!") Retirado a IE do Campo Subst. Tributแria conforme solicitacao do Sr Andre - 09-07-08 Edson Rodrigues

//ณ Impressao dos Dados do Cliente      ณ
nLin +=2
@ nlin, 002 PSAY _cNomCLi        //Nome do Cliente
if !empty(_cCGCCli)              // Se o C.G.C. do Cli/Forn nao for Vazio
	if len(alltrim(_cCGCCli))==14   // Se for CGC
		@ nlin, 089 PSAY CHR(15)+TRANSF(_cCGCCli,"@R 99.999.999/9999-99") //+CHR(18)
	else  // Se for CPF
		@ nlin, 089 PSAY CHR(15)+TRANSF(_cCGCCli,"@R 999.999.999-99")+space(4) //+CHR(18)
	endif
else
	@ nlin, 089 PSAY CHR(15)+space(18) //+CHR(18)
endif
@ nlin, 126 PSAY _dEmissao                              // Data da Emissao do Documento

nLin +=2
@ nlin, 002  PSAY _cEndCli                              // Endereco
@ nlin, 065  PSAY _cBairro                               // Bairro
@ nlin, 103  PSAY _cCEPCli Picture "@R 99999-999"         // CEP
@ nlin, 126 PSAY "" //Date() Desabilitado, conf. solicitacao Denilza - Edson Rodrigues - 29/05/07   // Data da Saํda = Data da Impressใo da Nota

nLin +=1
@ nlin, 002  PSAY _cMunCli                               // Municipio
@ nlin, 058  PSAY _cFoneCli                              // Telefone/FAX
@ nlin, 081  PSAY _cEstCli                               // U.F.
@ nlin, 089  PSAY _cIECli                                // Insc. Estadual
@ nlin, 126  PSAY "" //Time() Desabilitado, conf. solicitacao Denilza - Edson Rodrigues - 29/05/07   // Horแrio da Saํda = Horแrio da Impressใo da Nota

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPDUP   บ Autor ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime as duplicatas da Nota Fiscal                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpDup()

SetPrvt("_ni,_aPosDup")

nLin +=2
@ nLin, 000 PSAY COMPRESSAO
// O array _aPosDup contem as posicoes das duplicatas no formulario da seguinte forma:
// {Deslocamento em relacao a linha inicial,
//  coluna do numero do titulo,
//  coluna do valor do titulo,
//  coluna do vencimento do titulo}
//_aPosDup := {{0,5,29,57},{0,50,69,92},{0,86,105,125},{1,5,29,57},{1,50,69,92},{1,86,105,125}}
_aPosDup := {{0,2,17,34},{0,52,67,83},{1,2,17,34},{1,52,67,83},{2,2,17,34},{2,52,67,83}}
for _ni := 1 to Len(_aDuplic)
	if _ni <= Len(_aDuplic)   .and. _ni <= len(_aPosDup)
		@nLin+_aPosDup[_ni,1], _aPosDup[_ni,2] psay chr(15)+_aDuplic[_ni,1]  // Numero e parcela do titulo
		@nLin+_aPosDup[_ni,1], _aPosDup[_ni,4] psay _aDuplic[_ni,2]   //+ chr(18)// Valor
		@nLin+_aPosDup[_ni,1], _aPosDup[_ni,3] psay _aDuplic[_ni,3]  picture "@E 9,999,999.99"  // Vencimento Real do titulo
		If _ni = 1
			@ nlin, 105 psay _cPedido
		EndIf
	endif
next _ni
// Impressao do endereco de cobranca e do Endere็o de Entrega
nLin +=3
//@ nlin, 002 psay _cEndCob1
//@ nlin, 077 psay _cEndEnt
//nLin++
//@ nlin, 077 psay _cMunEst
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPPROD  บ Autor ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os itens da Nota Fiscal                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpProd()

SetPrvt("_nk,_nj,_cPicVUnit,_cVUnit,_nDeslocVunit,_cPicQtd,_cQuant,_nDeslocQtd")

nLin := _nLimMinProd
//nLin := 20

@ nLin, 000 PSAY COMPRESSAO

// Nใo Aglutina Produtos
If mv_par06 == 2 

	for _nk := 1 to len(_aCodProd)

		if _aValISS[_nk] == 0
			// Alterado para permitir a quebra de pagina no meio da impressao de um item
			if nLin > _nLimMaxProd
				// Caso a descricao do produto nao caiba no formulario, pula para o proximo
				ImpRodZero()
				nLin := _nLimMinProd
			endif
			// Alterado para imprimir o codigo do especifico produto para Nota fiscal: Edson Rodrigues - 30/03/07
			If mv_par04 == 2 .and. !empty(SUBSTR(_aCodPNF[_nk],1,15))
  			   @ nLin, 002 PSAY SUBSTR(_aCodPNF[_nk],1,15)
			Else
			   @ nLin, 002 PSAY SUBSTR(_aCodProd[_nk],1,15)
			Endif
			for _nj := 1 to _aLenDesc[_nk]
				if nLin > _nLimMaxProd
					ImpRodZero()
					nLin := _nLimMinProd
				endif
				@ nLin++, 022 PSAY _aDescPro[_nk,_nj]
			next _nj
			nLin--
			@ nLin, 069 PSAY _aClasfis[_nk]
			@ nLin, 073 PSAY _aSitTrib[_nk]
			@ nLin, 079 PSAY _aProdUM[_nk]
			@ nLin, 085 PSAY _aQtdVen[_nk]		Picture "@E 99,999.99"
			@ nLin, 094 PSAY _aValUnit[_nk]		Picture "@E 999,999.9999"
			@ nLin, 107 PSAY _aValTot[_nk]		Picture "@E 9,999,999.99"
			@ nLin, 120 PSAY _aAliqICMS[_nk]	Picture "99"
			if _aRodaIPI[_nk] == "N"
				@ nLin, 124 PSAY 0 	Picture "99"
				@ nLin, 127 PSAY 0  Picture "@E 999,999.99"
			else
				@ nLin, 124 PSAY _aAliqIPI[_nk] 	Picture "99"
				@ nLin, 127 PSAY _aValIPI[_nk]		Picture "@E 999,999.99"
			endif
			nLin ++
		else
			_nServ ++
		endif
		IF !limpItens // Claudia 29/12/2008 NF cOMPLEMENTAR  NAO IMPRIME ITENS, SO MENSAGEN, POR ISSO DEVE SAIR DO FOR/NEXT
			Exit		
		EndIF
	next _nk
//EndIf

// Aglutina็ใo de Produtos
// Aglutina็ใo de Produtos para Calculo de Pแgina
/*
  Caso o parโmetro esteja setado para aglutinar produtos, essa fun็ใo somar a quantidade,
  valor total e total de IPI para considerar apenas uma unica impressใo no corpo da nota

  Caso o item jแ tenha sido impresso, o mesmo serแ marcado como "S" para nใo ser 
  impresso novamente, nem considerado uma outra vez na soma.
*/
elseIf mv_par06= 1

	if !empty(_cBaseKit) .and. _nQtdKit > 0 .and. SB1->(dbseek(xfilial("SB1") + _cBaseKit))

		@ nLin, 002 PSAY _cBaseKit
		@ nLin, 022 PSAY alltrim(SB1->B1_DESC)
		@ nLin, 069 PSAY SB1->B1_CLASFIS
		@ nLin, 079 PSAY SB1->B1_UM
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
//                                                                                     99,999.99999,999.99999,999,999.99 99  99 999,999.99
		@ nLin, 085 PSAY _nQtdKit				Picture "@E 99,999.99"
		// Auto Ajuste da impressao das casas decimais do preco unitario
		@ nLin, 094 PSAY _nValMerc/_nQtdKit 	Picture "@E 999,999.9999"
		@ nLin, 107 PSAY _nValMerc				Picture "@E 9,999,999.99"
		@ nLin, 120 PSAY 0						Picture "99"
		@ nLin, 124 PSAY 0 						Picture "99"
		@ nLin, 127 PSAY 0  					Picture "@E 999,999.99"
		nLin ++

		SG1->(dbsetorder(1))
		if SG1->(dbseek(xfilial("SG1") + _cBaseKit))
			nLin := nLin + 3
			@ nLin,030 Psay "ESTE KIT E COMPOSTO POR:  "
			while !SG1->(eof()) .and. SG1->G1_FILIAL == xFilial("SG1") .and. SG1->G1_COD == _cBaseKit
				nLin := nLin + 1
				@ nLin,030 Psay SG1->G1_QUANT 	Picture "99"
				@ nLin,033 Psay SG1->G1_COMP
				SG1->(dbSkip())
			enddo
		endif

	else

		for _nk := 1 to len(_aCodProd)
			If _aImpresso[_nk] == "N"
				if _aValISS[_nk] == 0
					for _nj := 1 to len(_aCodProd)
						If _aCodProd[_nj] == _aCodProd[_nk] .And. _aValUnit[_nj] == _aValUnit[_nk] .And. _nj <> _nk
							_aQtdVen[_nk]	+= _aQtdVen[_nj]
							_aValTot[_nk]	+= _aValTot[_nj]
							_aValIPI[_nk]	+= _aValIPI[_nj]
							_aImpresso[_nj] := "S"
						EndIf
					next _nj
					// Alterado para permitir a quebra de pagina no meio da impressao de um item
					if nLin > _nLimMaxProd
						// Caso a descricao do produto nao caiba no formulario, pula para o proximo
						ImpRodZero()
						nLin := _nLimMinProd
					endif
     				// Alterado para imprimir o codigo do especifico produto para Nota fiscal: Edson Rodrigues - 30/03/07
					If mv_par04 == 2 .and. !empty(SUBSTR(_aCodPNF[_nk],1,15))
  			          @ nLin, 002 PSAY SUBSTR(_aCodPNF[_nk],1,15)
          			Else
		              @ nLin, 002 PSAY SUBSTR(_aCodProd[_nk],1,15)
           			Endif
					for _nj := 1 to _aLenDesc[_nk]
						if nLin > _nLimMaxProd
							ImpRodZero()
							nLin := _nLimMinProd
						endif
						@ nLin++, 022 PSAY _aDescPro[_nk,_nj]
					next _nj
					nLin--
					@ nLin, 069 PSAY _aClasfis[_nk]
					@ nLin, 073 PSAY _aSitTrib[_nk]
					@ nLin, 079 PSAY _aProdUM[_nk]
					@ nLin, 085 PSAY _aQtdVen[_nk]		Picture "@E 99,999.99"
					@ nLin, 094 PSAY _aValUnit[_nk]		Picture "@E 999,999.9999"
					@ nLin, 107 PSAY _aValTot[_nk]		Picture "@E 9,999,999.99"
					@ nLin, 120 PSAY _aAliqICMS[_nk]	Picture "99"
					if _aRodaIPI[_nk] == "N"
						@ nLin, 124 PSAY 0 	Picture "99"
						@ nLin, 127 PSAY 0  Picture "@E 999,999.99"
					else
						@ nLin, 124 PSAY _aAliqIPI[_nk]	Picture "99"
						@ nLin, 127 PSAY _aValIPI[_nk]	Picture "@E 999,999.99"
					endif
					_aImpresso[_nk] := "S"
					nLin ++
				else
					_nServ ++
				endif
			EndIf    
			IF !limpItens // Claudia 29/12/2008 NF cOMPLEMENTAR  NAO IMPRIME ITENS, SO MENSAGEN, POR ISSO DEVE SAIR DO FOR/NEXT
				Exit		
			EndIF
		next _nk

	endif

EndIf

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPSERV  บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os servicos da Nota Fiscal                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpServ()

SetPrvt("_ni,_nk,_nj,_nServImp,_nTamLin")
SetPrvt("_nl, _nm, _nn")

nLin := 38
@ nLin, 000 PSAY COMPRESSAO

if _nValServ > 0
	@ nLin, 002 Psay ""           //Codigo do ISS
	@ nLin, 020 Psay _cDescServ   //Descricao do Servico
	@ nLin, 098 Psay 1    		Picture "@E 999"         //Quantidade
	@ nLin, 105 Psay _nValServ 	Picture "@E 999,999,999.99"  //Valor Unitario
	@ nLin, 122 Psay _nValServ 	Picture "@E 999,999,999.99"  //Valor Total
	nLin+=3
	@ nLin, 017 Psay _cInscrM                            //Inscricao Municipal do Destinatario
	@ nLin, 050 Psay _nAliqISS	Picture "@E 99.99"
	@ nLin, 070 Psay _nValISS	Picture "@E 999,999.99"  //Valor ISS
	@ nLin, 092 Psay _nValIRRF	Picture "@E 999,999.99"  //Valor do Imposto de Renda Retido na Fonte
	@ nLin, 124 Psay _nValServ	Picture "@E 999,999,999.99"  //Valor Total do Servico
//	_nValFat += _nValServ
endif

//-----------------------------------------------//
//Imprime valores de reten็ใo de pis/cofins/csll //
//-----------------------------------------------//
if mv_par05 == 2

	_nPis := _nCofins := _nCsll := 0

	For _nL := 1 to Len(_aPIS)
		_nPis += _aPIS[_nl]
	Next _nl
	
	For _nm := 1 to Len(_aCofins)
		_nCofins += _aCofins[_nm]
	Next _nm
	
	For _nn := 1 to Len(_aCsll)
		_nCsll += _aCsll[_nn]
	Next _nn
	
	if _nPis > 0
		nLin++
		@ nLin, 005 Psay "Valor Pis : "
		@ nLin, 020 Psay _nPis    PICTURE "@E 999,999.99"  //Valor PIS
	Endif
	
	If _nCofins > 0
		@ nLin, 040 Psay "Valor Cofins : "
		@ nLin, 055 Psay _nCofins    PICTURE "@E 999,999.99"  //Valor COFINS
	Endif
	
	If _nCsll > 0
		@ nLin,070 Psay "Valor CSLL : "
		@ nLin,085 Psay _nCsll    PICTURE "@E 999,999.99"  //Valor CSLL
	Endif
Endif

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณIMPRODZEROบ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณImprime o Rodape zerado da Nota Fiscal para quebra de paginaบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpRodZero()

nLin := 43
@ nLin, 000  PSAY COMPRESSAO
@ nLin, 015  PSAY "********"
@ nLin, 034  PSAY "********"
@ nLin, 062  PSAY "********"
@ nLin, 085  PSAY "********"
@ nLin, 110  PSAY "********"

nLin += 2
@ nLin, 015  PSAY "********"
@ nlin, 034  PSAY "********"
@ nLin, 062  PSAY "********"
@ nLin, 085  PSAY "********"
@ nLin, 110  PSAY "********"

nLin += 7

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos dados adicionais da NFณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ImpDadAdic()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Linha Inicial da impressao          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho da NF        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpCabec()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao das duplicatas do cliente ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPROD   บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime o Rodape da Nota Fiscal                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpRod()

nLin := 43

If _nServ <> 0
	_nBsICMS    := 0
	_nVlICMS    := 0
	_nBsICMSST  := 0
	_nVlICMSST  := 0
	_nValMerc   := 0
	_nVlFrete   := 0
	_nVlSeguro  := 0
	_nVlDespAc  := 0
	_nVlIPI     := 0
//	_nValFat    := 0
EndIf

@ nLin, 000  PSAY COMPRESSAO
@ nLin, 002  PSAY _nBsICMS    Picture "@E 999,999,999.99"  // Base do ICMS
@ nLin, 025  PSAY _nVlICMS    Picture "@E 999,999,999.99"  // Valor do ICMS
@ nLin, 060  PSAY _nBsICMSST  Picture "@E 999,999,999.99"  // Base ICMS Ret.
@ nLin, 090  PSAY _nVlICMSST  Picture "@E 999,999,999.99"  // Valor  ICMS Ret.
@ nLin, 120  PSAY _nValMerc   Picture "@E 999,999,999.99"  // Valor Mercadorias

nLin += 2
@ nLin, 002  PSAY _nVlFrete   Picture "@E 999,999,999.99"  // Valor do Frete
@ nLin, 025  PSAY _nVlSeguro  Picture "@E 999,999,999.99"  // Valor do seguro
@ nLin, 060  PSAY _nVlDespAc  Picture "@E 999,999,999.99"  // Valor desp. acessorias
@ nLin, 090  PSAY _nVlIPI     Picture "@E 999,999,999.99"  // Valor IPI
@ nLin, 120  PSAY _nValFat    Picture "@E 999,999,999.99"  // Valor Total NF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados da transportadora e volumes transportados            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin += 2
@ nLin, 002   PSAY _cNomTrans Picture "@!"
If _cTpFrete == 'C'           // Frete por conta do
	@ nlin, 080 PSAY "1"     // Emitente (1)
Else                         //  ou
	@ nlin, 080 PSAY "2"    // Destinatario (2)
Endif

if !empty(alltrim(_cTransp))
	if !empty(_cCGCTrans)              // Se o C.G.C. do Cli/Forn nao for Vazio
		if len(alltrim(_cCGCTrans))==14   // Se for CGC
			@ nlin, 110 PSAY CHR(15)+TRANSF(_cCGCTrans,"@R 99.999.999/9999-99") //+CHR(18)
		else  // Se for CPF
			@ nlin, 110 PSAY CHR(15)+TRANSF(_cCGCTrans,"@R 999.999.999-99") //+CHR(18)
		endif
	endif
	
	nLin+=2
	@ nLin, 002   PSAY _cEndTrans 	Picture "@!"
	@ nLin, 065   PSAY _cMunTrans	Picture "@!"
	@ nLin, 103   PSAY _cEstTrans 	Picture "@!"
	@ nLin, 110  PSAY TRANSFORM(_cIETrans,"@!")
else
	nLin+=2
endif
nLin += 1

//@ nlin, 002 PSAY _nVolumes      Picture "@E@Z 999,999"     // Quant. Volumes
If !Empty(AllTrim(_cEspecie))
	@ nlin, 035 PSAY _cEspecie 		Picture "@!"
EndIf

If !Empty(AllTrim(_cMarca))
	@ nlin, 068 PSAY _cMarca 		Picture "@!"
EndIf
@ nlin, 105 PSAY _nPesoBrt 			Picture "@E 999,999.99"       // Res para Peso Bruto
@ nlin, 120 PSAY _nPesoLiq 			Picture "@E 999,999.99"       // Res para Peso Liquido

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณIMPDADADICบ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os dados adicionais da Nota Fiscal                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpDadAdic()

Local y
Local _cTextoDev := ""
Local _cNfOri    := ""
Local nMax       := Len(aOrigem)
Local cNfOrig    := ""
nLin := 52
If nMax > 0   .AND. _Duplicata  = 'S' // CLAUDIA SO IMPRIME NF ORIGEM SE GERAR DUPLICATA.
	nlin++
	y:= 0
	For y = 1 to nMax
		cNfOrig = cNfOrig + IIf( y = 1, aOrigem[y,1],','+aorigem[y,1])
	Next       
	@ nLin ,002 Psay "N.F.Origem: " + cNfOrig
	nlin++	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Notas Fiscais Originais             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For y := 1 to Len(_aNFOri)
	if !empty(_aNFOri[y]) .and. !alltrim(_aNFOri[y]) $ _cNfOri   .and.  !alltrim(_aNFOri[y]) $ cNfOrig
		_cTextoDev += iif(!empty(_cTextoDev),"-", "")
		_cTextoDev += _aNFOri[y] + iif(!empty(_aSeriOri[y]), "/" + Alltrim(_aSeriOri[y]), "")
		_cNfOri    += alltrim(_aNFOri[y])
	endif
Next y

if !empty(_cTextoDev)
	//nLin++ // Edson Rodrigues em 22/09/08
	@ nLin ,002 Psay "N.F.Originais: " + _cTextoDev
endif

if	_cTes == "268"
	nLin++
   	@ nLin ,002 Psay "DESCONTO REF ICMS 7%:" + (Alltrim(str(_nTotDIC)))
endif 
if 	_cTes == "210" 
	nLin++
    @ nLin ,002 Psay "DESC ICMS 7%,PIS 1.65%,COFINS 7.6%:" + (Alltrim(str(_nTotDIM)))
endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao da Mensagem Padrao           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if !empty( _cMenPad )
	nLin++
	@ nLin,002 Psay SubStr(Alltrim(Formula(_cMenPad)),001,60)
	If !Empty(SubStr(Alltrim(Formula(_cMenPad)),061,60))
		nLin++
		@ nLin,002 Psay SubStr(Alltrim(Formula(_cMenPad)),061,60)
	EndIf
	If !Empty(SubStr(Alltrim(Formula(_cMenPad)),121,60))
		nLin++
		@ nLin,002 Psay SubStr(Alltrim(Formula(_cMenPad)),121,60)
	EndIf
EndIf                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao da Mensagem da Nota          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if !empty( _cMenNota)
	nLin++
	@ nLin,002 Psay SubStr(Alltrim(_cMenNota),001,60)
	If !Empty(SubStr(Alltrim(_cMenNota),061,60))
		nLin++
		@ nLin,002 Psay SubStr(Alltrim(_cMenNota),061,60)
	EndIf                                       
	IF ! lImpItens // claudia 29/12/2008 NF COMPLEMENTAR - PODE IMPRIMIR MAIS LINHAS DE MENSAGENS
		If !Empty(SubStr(Alltrim(_cMenNota),121,60))
			nLin++
			@ nLin,002 Psay SubStr(Alltrim(_cMenNota),121,60)
		EndIf
		If !Empty(SubStr(Alltrim(_cMenNota),181,60))
			nLin++
			@ nLin,002 Psay SubStr(Alltrim(_cMenNota),181,60)
		EndIf
	EndIf		
endif

if len(_aIMEINovo) > 0 .and. lImpItens // claudia 29/12/2008 nf complemenar de importacao nao imprime IMEI
	_cImeiNovo := ""                                   
	_cImeiold  := ""                                  
	for nW := 1 to len(_aIMEINovo)
		if !empty(_aIMEINovo[nW,1])
			_cImeiNovo += iif(!empty(_cImeiNovo), "/","") + alltrim(_aIMEINovo[nW,1])
		endif                      
		if !empty(_aIMEINovo[nW,2])
			_cImeiold += iif(!empty(_cImeiold), "/","") + alltrim(_aIMEINovo[nW,2])
		endif                    
		
	next nW
	if !empty(_cImeiNovo)
		nLin++
		@ nLin,002 Psay "IMEI(s) NOVO(s): "+_cImeiNovo
	endif                
	if !empty(_cImeiold)
		nLin++ 
		@ nLin,002 Psay "IMEI(s) VELHO(s): "+_cImeiold
	endif
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao da classificacao fiscal(NCM) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if Len(_aPosIPI) >= 1  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	nLin++
	@ nLin, 002 PSAY ALLTRIM(Transform(_aPosIPI[1],"99999999"))
endif

if Len(_aPosIPI) >= 2 .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 010 PSAY "/"+ALLTRIM(Transform(_aPosIPI[2],"99999999"))
endif

if Len(_aPosIPI) >= 3 .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 019 PSAY  "/"+Alltrim(Transform(_aPosIPI[3],"99999999"))
endif

if Len(_aPosIPI) >= 4  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 028 PSAY  "/"+alltrim(Transform(_aPosIPI[4],"99999999"))
endif        

if Len(_aPosIPI) >= 5  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 037 PSAY  "/"+alltrim(Transform(_aPosIPI[5],"99999999"))
endif                                                      

if Len(_aPosIPI) >= 6  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 046 PSAY  "/"+alltrim(Transform(_aPosIPI[6],"99999999"))
endif                

if Len(_aPosIPI) >= 7  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 055 PSAY  "/"+alltrim(Transform(_aPosIPI[7],"99999999"))
endif      

if Len(_aPosIPI) >= 8  .and. lImpItens // CLAUDIA 29/12/2008 NF COMPLEMENTAR NAO IMPRIMIR 
	@ nLin, 064 PSAY  "/"+alltrim(Transform(_aPosIPI[8],"99999999"))
endif        
  

if !empty(_cCompInd)
	nLin++
	@ nLin, 002 Psay _cCompInd
endif

nLin := 61

@ nLin, 114 psay CHR(14)+_cNumNF+CHR(20)
nLin++                                  

@ nLin, 000 PSAY CHR(18)

if aReturn[5] != 2
	//	setprc(0, 0)
endif

nLin := 4

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPLOCAISบ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os enderecos de cobranca e entrega na Nota Fiscal  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpLocais()

nLin++
if !empty(_cEndCob1)
	@ nlin, 002 psay alltrim(_cEndCob1)
endif

if !empty(_cEndEnt1)
	@ nlin, 078 psay alltrim(_cEndEnt1)
endif

nLin++
if !empty(_cEndCob2)
	@ nlin, 002 psay alltrim(_cEndCob2)
endif

if !empty(_cEndEnt2)
	@ nlin, 078 psay alltrim(_cEndEnt2)
endif

//nLin++

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPLOCAISบ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os enderecos de cobranca e entrega na Nota Fiscal  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpZF()

_nTotSufr := 0
nLin := 32
@ nlin, 022 psay "Codigo Suframa: " + _cSuframa
nLin++
if _nZFMerc > 0
	@ nlin, 022 psay "Valor da Mercadoria: R$ " + Transform(_nZFMerc,"@E 999,999.99")
	nLin++
endif
if _nZFIcm > 0
	@ nlin, 022 psay "Desconto de ICMS (aliq. "+Transform(_nZFIcm / _nZFMerc * 100,"@E 99.99")+"%): R$ " + alltrim(Transform(_nZFIcm ,"@E 999,999.99"))
	_nTotSufr += _nZFIcm
	nLin++
endif
if _nZFPis > 0
	@ nlin, 022 psay "Desconto de PIS (aliq. "+Transform(_nZFPis / _nZFMerc * 100,"@E 99.99")+"%): R$ " + alltrim(Transform(_nZFPis ,"@E 999,999.99"))
	_nTotSufr += _nZFPis
	nLin++
endif
if _nZFCof > 0
	@ nlin, 022 psay "Desconto de COFINS (aliq. "+Transform(_nZFCof / _nZFMerc * 100,"@E 99.99")+"%): R$ " + alltrim(Transform(_nZFCof ,"@E 999,999.99"))
	_nTotSufr += _nZFCof
	nLin++
endif
if _nTotSufr > 0
	@ nlin, 022 psay "Total: R$ " + alltrim(Transform(_nTotSufr ,"@E 999,999.99"))
	nLin++
endif

_nZFMerc := _nZFIcm := _nZFPis := _nZFCof := _nTotSufr := 0

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPRIME  บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  04/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime os dados da Nota Fiscal de acordo com as variaveis บฑฑ
ฑฑบ          ณ carregadas na Funcao CriaNF. Essa funcao preve a impressao บฑฑ
ฑฑบ          ณ de varios formularios para um mesmo numero de Nota Fiscal. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Imprime()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Linha Inicial da impressao          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho da NF        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpCabec()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao das duplicatas do cliente ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if Len(_aDuplic) > 0
	ImpDup()
else
	nLin +=5
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos locais de cobranca/entregaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpLocais()

nLin +=2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos produtos da NF        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nServ := 0
ImpProd()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos servicos da NF ou da  ณ
//ณ mensagem padrao contida no TES      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if _nServ >= 1
	ImpServ()
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dados da Zona Franca      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Alterado por M.Munhoz em 20/08/2007 para a impressao dos descontos de Zona Franca nao depender do codigo Suframa do cliente,
//ja que um caso relatado pela Denilza nao tera codigo Suframa mas tera desconto de PIS e COFINS.
//if !empty(_cSuframa) .and. _nZFIcm + _nZFPis + _nZFCof > 0
if _nZFIcm + _nZFPis + _nZFCof > 0

	if nLin >= 32
		ImpRodZero()
		nLin := _nLimMinProd
	endif

	ImpZF()

endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do Rodape da NF           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpRod()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao da Transportadora         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ImpTransp()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos dados adicionais da NFณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpDadAdic()
_nPag := 1

Return                      

Static Function FtIsBonus(aParam)
Local lBonusOk := .f.
If aParam [3] $ "758/780/793"
	lBonusOK := .T.
Endif
Return lBonusOK