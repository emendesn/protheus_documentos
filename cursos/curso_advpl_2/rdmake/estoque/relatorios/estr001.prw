#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ ESTR001  ∫ Autor ≥ M.Munhoz - ERPPLUS ∫ Data ≥  09/04/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Posicao de estoque para a area Comercial                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico BGH DO BRASIL                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function ESTR001()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local cDesc1        := "Este programa tem como objetivo gerar um relatÛrio da PosiÁ„o de Estoque para at. "
Local cDesc2        := "·rea Comercial."
Local cDesc3        := "EspecÌfico BGH"
Local cPict         := ""
Local titulo        := "PosiÁ„o de Estoque - ¡rea Comercial"
Local nLin          := 80
Local Cabec1        := "Produto          Descricao                        Tipo     Grupo  Familia  Categoria    Modelo       Cor      Operadora       Compras     Vendas   Dev.Comp.  Dev.Vend.    Transf.  Aj.Sist   Sal.Fis.  PV.Aberto  Sal.Disp."
Local Cabec2        := "                                                                                                                                 (+)        (-)        (-)        (+)       (+ou-)       (+ou-)   (=)       (-)        (=)  "
Local imprime       := .T.
Local aOrd          := {}
Local cAlias    	:= ALIAS()
Local _cArqTmp

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ESTR001"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "ESTR01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "ESTR001"
Private cString     := ""                           
private _csrvapl    :=ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

CriaSX1()

pergunte(cPerg,.F.)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta a interface padrao com o usuario...                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  09/04/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _cquery   := ""
Local CR        := chr(13) + chr(10) 
Local _cinprbgh	:= GetMV("MV_INPROBG")
Local _carmdist	:= GetMV("MV_ARMDIST") 
Local _carmprop	:= GetMV("MV_ARMPBGH")
Local _carmpven	:= GetMV("MV_ARMPVEN")
Local _cfventot	:= GetMV("MV_CFTVEND")        
Local _cfdevtot	:= GetMV("MV_CFTDEV") 
Local _Ddataini	:= GetMV("MV_DINIRAR") 
Local _ncompras := 0.00
Local _nvendas  := 0.00
Local _ndevcom  := 0.00
Local _ndevven  := 0.00
Local _ntransf  := 0.00
Local _najuste  := 0.00
Local _nsalfis  := 0.00 
Local _npvaber  := 0.00  
Local _nsaldisp := 0.00


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Fecha os arquivos temporarios, caso estejam abertos          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
if select("TRB") > 0
	TRB->(dbCloseArea())
endif

_cQuery += CR + " SELECT RTRIM(PRODUTO)  AS PRODUTO, B1_DESC , "
_cQuery += CR + "                  B1_TIPO=CASE WHEN B1_TIPOP='A'  THEN 'ACESSORIO'  WHEN B1_TIPOP='C' THEN 'APARELHO'  WHEN B1_TIPOP='K'  THEN 'KIT' ELSE ''  END,"
_cQuery += CR + "                   B1_GRUPO,ARMAZEN AS ARMAZ,B1_FABRIC FABRICANTE, "
_cQuery += CR + "                  FAMILIA=CASE WHEN B1_XFAMILI='O' THEN 'ORIGINAL' ELSE 'GENERICO' END, B1_XCATEG AS CATEGORIA, B1_XMODELO AS MODELO, B1_XCOR, B1_XSTW, "
_cQuery += CR + "                  GSMCDMA= CASE WHEN  B1_XGSMCDM='G' THEN 'GSM' ELSE 'CDMA' END,COMPRAS, VENDAS, TRANSF,DEVCOM, DEVVEN,AJUSTES, SALFISICO, PVABERTO, SALDISPON "
_cQuery += CR + " FROM   (SELECT TRB.PRODUTO,ARMAZEN, "
_cQuery += CR + "                              SUM(COMPRAS) COMPRAS, "
_cQuery += CR + "                              SUM(DEVVEN) DEVVEN, "
_cQuery += CR + "                              SUM(VENDAS) VENDAS, "
_cQuery += CR + "                              SUM(DEVCOM) DEVCOM, "
_cQuery += CR + "                              SUM(TRANSF) TRANSF, "     
_cQuery += CR + "                              AJUSTES =SUM(SALDOB2) - (SUM(COMPRAS) - ((SUM(VENDAS) + SUM(DEVVEN) + SUM(TRANSF) - SUM(DEVCOM)))) ,"
_cQuery += CR + "                              SALFISICO =SUM(SALDOB2) ,  "
_cQuery += CR + "                              SUM(PVABERTO) AS  PVABERTO, "
_cQuery += CR + "                              SALDISPON = SUM(SALDOB2)  - SUM(PVABERTO) " 
_cQuery += CR + "                               FROM   (SELECT D1_COD PRODUTO, D1_TIPO TIPONF,D1_LOCAL  ARMAZEN,"
_cQuery += CR + "                                              COMPRAS = CASE WHEN D1_TIPO = 'N' THEN SUM(D1_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                              DEVVEN  = CASE WHEN D1_TIPO = 'D' THEN SUM(D1_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                              VENDAS  = 0, DEVCOM = 0, PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD1") + "  D1 (nolock) JOIN " + RetSqlName("SF4") + "  AS F4 (nolock)  ON F4_CODIGO = D1_TES AND F4_PODER3 IN ('N') AND F4.D_E_L_E_T_ = '' AND F4_ESTOQUE='S' "
if !empty(mv_par15) 
  _cQuery += CR + "                                            WHERE  D1.D1_FILIAL='"+xFilial("SD1")+"' AND D1.D_E_L_E_T_ = ''  AND D1_TIPO IN ('N', 'D')  AND  SUBSTRING(D1_COD,1,2) IN "+_cinprbgh+"  AND D1_COD     BETWEEN '' AND 'ZZZZZZ'  AND '"+mv_par15+"' LIKE'%'+D1_LOCAL+'%' "
Else
_cQuery += CR + "                                              WHERE  D1.D1_FILIAL='"+xFilial("SD1")+"' AND D1.D_E_L_E_T_ = ''  AND D1_TIPO IN ('N', 'D')  AND  SUBSTRING(D1_COD,1,2) IN "+_cinprbgh+"  AND D1_COD     BETWEEN '' AND 'ZZZZZZ' " 
Endif
_cQuery += CR + "                                              GROUP BY D1_COD, D1_TIPO,D1_LOCAL " 
_cQuery += CR + "                                              UNION ALL "
if !empty(mv_par15)  .and. "80" $ mv_par15 
  _cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
  _cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock)  WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='80' AND D_E_L_E_T_='' AND D3_TM='999' AND D3_EMISSAO='20070621'"
  _cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL"
  _cQuery += CR + "                                              UNION ALL "
endif                                                         
if !empty(mv_par15)  .and. "82" $ mv_par15 

_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock)  WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='82' AND D_E_L_E_T_='' AND D3_TM='499' AND D3_EMISSAO='20070621' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "  
endif               
if !empty(mv_par15)  .and. "80/81" $ mv_par15 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81') AND D_E_L_E_T_='' AND D3_TM='999' AND D3_EMISSAO='20071227' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
Endif                                                              
if !empty(mv_par15)  .and. "83/84" $ mv_par15 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('83','84') AND D_E_L_E_T_='' AND D3_TM='499' AND D3_EMISSAO='20071227' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
Endif
if !empty(mv_par15)  .and. "80/81/82/83/84" $ mv_par15 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502') AND D3_EMISSAO='20071228' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002') AND D3_EMISSAO='20071228' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080104' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080104' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080213' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080213' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080402' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "  
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080402' "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "   
Endif      
if !empty(mv_par15)
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN "+_carmdist+" AND D_E_L_E_T_='' AND D3_TM IN ('700','999')  "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN "+_carmdist+" AND D_E_L_E_T_='' AND D3_TM IN ('200','499')  "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "                               
Else                                                                                                                                                                                                                                  
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND  '"+mv_par15+"' LIKE'%'+D3_LOCAL+'%'  AND D_E_L_E_T_='' AND D3_TM IN ('700','999')  "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND  '"+mv_par15+"' LIKE'%'+D3_LOCAL+'%'  AND D_E_L_E_T_='' AND D3_TM IN ('200','499')  "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "                               
Endif
_cQuery += CR + "                                              SELECT D2_COD PRODUTO, D2_TIPO TIPONF, D2_LOCAL  ARMAZEN, "
_cQuery += CR + "                                                              COMPRAS = 0, DEVVEN = 0, " 
_cQuery += CR + "                                                             VENDAS  = CASE WHEN D2_TIPO = 'N' THEN SUM(D2_QUANT) ELSE 0 END,  "
_cQuery += CR + "                                                             DEVCOM  = CASE WHEN D2_TIPO = 'D' THEN SUM(D2_QUANT) ELSE 0 END,  " 
_cQuery += CR + "                                                             PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD2") + " AS  D2 (nolock)  JOIN  " + RetSqlName("SF4") + "  AS F4 (nolock)  ON F4_CODIGO = D2_TES AND F4_PODER3 IN ( 'N') AND F4.D_E_L_E_T_ = ''  AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE  D2.D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = ''    AND  D2_TIPO IN ('N', 'D')  AND  SUBSTRING(D2_COD,1,2) IN "+_cinprbgh+"   AND D2_COD     BETWEEN '' AND 'ZZZZZZ'  AND  D2_TES <> '786'  "
_cQuery += CR + "                                              GROUP BY D2_COD, D2_TIPO,D2_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D2_COD PRODUTO, D2_TIPO TIPONF, D2_LOCAL  ARMAZEN, "
_cQuery += CR + "                                                              COMPRAS = 0, DEVVEN = 0, " 
_cQuery += CR + "                                                             VENDAS  = CASE WHEN D2_TIPO = 'N' THEN SUM(D2_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                                             DEVCOM  = CASE WHEN D2_TIPO = 'D' THEN SUM(D2_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                                             PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD2") + " AS  D2 (nolock)  JOIN   " + RetSQLName("SF4") + "   AS F4 (nolock)  ON F4_CODIGO = D2_TES AND F4_PODER3 IN ( 'R') AND F4.D_E_L_E_T_ = ''  AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE  D2.D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = ''    AND  D2_TIPO IN ('N', 'D')  AND SUBSTRING(D2_COD,1,2) IN "+_cinprbgh+"   AND D2_COD     BETWEEN '' AND 'ZZZZZZ' AND D2_TES='758' " 
_cQuery += CR + "                                              GROUP BY D2_COD, D2_TIPO,D2_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT C6_PRODUTO PRODUTO, TIPONF = '',C6_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = SUM(C6_QTDVEN - C6_QTDENT),TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SC6") + "  AS C6  (nolock)  JOIN   " + RetSQLName("SF4") + "  AS F4  (nolock)  ON  F4_CODIGO = C6_TES AND F4_PODER3 = 'R' AND F4.D_E_L_E_T_ = '' AND C6_TES='758' "
_cQuery += CR + "                                              WHERE  C6.C6_FILIAL='"+xFilial("SC6")+"' AND SUBSTRING(C6_PRODUTO,1,2) IN "+_cinprbgh+"  AND C6_PRODUTO BETWEEN '' AND 'ZZZZZZ'   AND C6_QTDVEN - C6_QTDENT > 0  AND C6.D_E_L_E_T_ = '' "  
_cQuery += CR + "                                              GROUP BY C6_PRODUTO,C6_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT C6_PRODUTO PRODUTO, TIPONF = '',C6_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = SUM(C6_QTDVEN - C6_QTDENT),TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SC6") + "  AS C6 (nolock)   JOIN   " + RetSQLName("SF4") + " AS F4 (nolock)   ON  F4_CODIGO = C6_TES AND F4_PODER3 = 'N' AND F4.D_E_L_E_T_ = '' AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE C6.C6_FILIAL='"+xFilial("SC6")+"' AND  SUBSTRING(C6_PRODUTO,1,2) IN "+_cinprbgh+"  AND C6_PRODUTO BETWEEN '' AND 'ZZZZZZ'   AND C6_QTDVEN - C6_QTDENT > 0  AND C6.D_E_L_E_T_ = ''  AND C6_TES <> '786'  " 
_cQuery += CR + "                                              GROUP BY C6_PRODUTO,C6_LOCAL
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT B2_COD  PRODUTO, TIPONF = '',B2_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = 0,TRANSF=0  ,SALDOB2=SUM(B2_QATU) " 
_cQuery += CR + "                                              FROM   " + RetSQLName("SB2") + "  AS B2 (nolock)   WHERE B2.D_E_L_E_T_=''  AND '"+mv_par15+"'  LIKE  '%'+B2_LOCAL+'%'   GROUP BY B2_COD,B2_LOCAL ) AS TRB    GROUP BY PRODUTO,ARMAZEN) AS EST  JOIN  "+ RetSQLName("SB1") +" AS B1  ON  B1_COD = EST.PRODUTO AND B1.D_E_L_E_T_ = '' "
_cQuery += CR + " WHERE  SUBSTRING(B1_COD,1,2) IN "+_cinprbgh+"  AND  B1.B1_COD >= '"+MV_PAR01+"' AND B1.B1_COD<='"+MV_PAR02+"' "  
_cQuery += CR + " AND B1_GRUPO   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
if mv_par05 == 1  		// Original
	_cQuery += CR + " AND B1_XFAMILI = 'O' "
elseif mv_par05 == 2  	// Generico
	_cQuery += CR + " AND B1_XFAMILI = 'G' "
endif
_cQuery += CR + " AND B1_XCATEG  BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cQuery += CR + " AND B1_XMODELO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
_cQuery += CR + " AND B1_XCOR    BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "
_cQuery += CR + " AND B1_XSTW    BETWEEN '"+mv_par12+"' AND '"+mv_par13+"' "
if mv_par14 == 1  		// GSM
	_cQuery += CR + " AND B1_XGSMCDM = 'G' "
elseif mv_par14 == 2  	// CDMA
	_cQuery += CR + " AND B1_XGSMCDM = 'C' "
endif                                  
if !empty(mv_par15) // Armazem
    _cQuery += CR + "     AND '"+mv_par15+"' LIKE'%'+ARMAZEN+'%' "
endif
    _cQuery += CR + " ORDER BY PRODUTO"

//memowrite("ESTR001.SQL",_cQuery )
_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
dbselectarea("TRB")
TRB->(dbgotop())

nConta := 0

While !TRB->(eof())
	nConta++
	TRB->(dbSkip())
EndDo

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
SetRegua(nConta)

TRB->(dbGoTop())
While TRB->(!eof())
	                                                                                     
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Verifica o cancelamento pelo usuario...                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Impressao do cabecalho do relatorio. . .                            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
//"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//"0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//"Produto          Descricao                        Tipo Grupo  Fam Categoria                    Modelo              Cor       Operadora GSM     Compras     Vendas  Dev.Comp.  Dev.Vend. Aj.Sist  Sal.Fis.  PV.Aberto  Sal.Disp.
//"                                                                                                                                       CDMA      (+)        (-)        (-)        (+)        (=)        (-)        (=)
//"                                                                                                                                            99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 99,999,999 
	@nLin,000 PSAY TRB->PRODUTO
	@nLin,017 PSAY TRB->B1_DESC
	@nLin,050 PSAY TRB->B1_TIPO
	@nLin,060 PSAY TRB->B1_GRUPO
	@nLin,066 PSAY SUBSTR(TRB->FAMILIA,1,8)
	@nLin,076 PSAY SUBSTR(TRB->CATEGORIA,1,10)
	@nLin,088 PSAY SUBSTR(TRB->MODELO,1,10)
	@nLin,100 PSAY iif(!empty(TRB->B1_XCOR), left(tabela('Z3',TRB->B1_XCOR),8), "-")
	@nLin,110 PSAY iif(!empty(TRB->B1_XSTW), left(tabela('Z4',TRB->B1_XSTW),8), "-")
//	@nLin,122 PSAY SUBSTR(TRB->GSMCDMA,1,4)

	@nLin,122 PSAY TRB->COMPRAS      Picture "@E 99,999,999"
	@nLin,133 PSAY TRB->VENDAS       Picture "@E 99,999,999"
	@nLin,144 PSAY TRB->DEVCOM       Picture "@E 99,999,999"
	@nLin,155 PSAY TRB->DEVVEN       Picture "@E 99,999,999"
	@nLin,166 PSAY TRB->TRANSF       Picture "@E 99,999,999"
	@nLin,177 PSAY TRB->AJUSTES      Picture "@E 99,999,999"
	@nLin,188 PSAY TRB->SALFISICO    Picture "@E 99,999,999"
	@nLin,199 PSAY TRB->PVABERTO     Picture "@E 99,999,999"
	@nLin,210 PSAY TRB->SALDISPON    Picture "@E 99,999,999"
	
	
	
   _ncompras+= TRB->COMPRAS 
   _nvendas += TRB->VENDAS
	_ndevcom += TRB->DEVCOM
	_ndevven += TRB->DEVVEN
	_ntransf += TRB->TRANSF
	_najuste += TRB->AJUSTES
	_nsalfis += TRB->SALFISICO 
	_npvaber += TRB->PVABERTO  
	_nsaldisp+= TRB->SALDISPON 
	
	nLin := nLin + 1
	
	TRB->(dbSkip())

EndDo    
    
    nLin := nLin + 3
    If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
   @nLin,000 PSAY "Total Geral................"
   @nLin,114 PSAY _ncompras   Picture "@E 99,999,999.99"
	@nLin,126 PSAY _nvendas    Picture "@E 99,999,999.99"
	@nLin,140 PSAY _ndevcom    Picture "@E 99,999,999"
	@nLin,151 PSAY _ndevven    Picture "@E 99,999,999"
	@nLin,162 PSAY _ntransf    Picture "@E 99,999,999"
	@nLin,173 PSAY _najuste    Picture "@E 99,999,999"
	@nLin,184 PSAY _nsalfis    Picture "@E 99,999,999"
	@nLin,195 PSAY _npvaber    Picture "@E 99,999,999"
	@nLin,206 PSAY _nsaldisp   Picture "@E 99,999,999"

dbSelectArea("TRB")
_cArq  := "Estoque_Coml_"+Alltrim(cUserName)+".XLS"
_cArqTmp := lower(AllTrim(__RELDIR)+_cArq)
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
_lOPen := .f.

//Incluso Paulo Francisco - 27/05/10
cArqorig := cStartPath+_cArq+".dtc"
cArqdest := lower(AllTrim(__RELDIR))+"Estoque_Coml_"+Alltrim(cUserName)+".CSV"

if nConta > 0
if file(_cArqTmp) .and. ferase(_cArqTmp) == -1
			if !ApMsgYesNo("O arquivo: " + _cArq + " n„o pode ser gerado porque deve estar sendo utilizado. Deseja tentar novamente? " )
				_lOpen := .t.
				ApMsgInfo("O arquivo Excel n„o foi gerado. ")
			endif
		else

			dbselectarea("TRB")
			dbGoTop()
			
			lgerou:=U_CONVARQ(cArqorig,cArqdest)
			
            if lgerou                              
		       If !ApOleClient( 'MsExcel' )
		           MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
               Else
		            ShellExecute( "Open" , "\\"+_csrvapl+cArqdest ,"", "" , 3 )           
    	        EndIf
	
            else
	              msgstop("Nao existem dados gerados para esse relatorio. Verifique os parametros do relatorio.","Arquivo Vazio","STOP")
            endif
		endif
else
	msgstop("N„o existem dados gerados para esse relatÛrio. Verifique os par‚metros do relatÛrio.","Arquivo Vazio","STOP")
endif
//dbselectarea( cAlias )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Finaliza a execucao do relatorio...                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
SET DEVICE TO SCREEN

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ CRIASX1  ∫Autor  ≥Microsiga           ∫ Data ≥  09/04/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Cria grupo de perguntas                                    ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function CriaSx1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Produto Inicial"			,"Produto Inicial"			,"Produto Inicial"			,"mv_ch1","C",15,0,0,"G","","SB1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Produto Final"			,"Produto Final"			,"Produto Final"			,"mv_ch2","C",15,0,0,"G","","SB1"	,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Grupo Inicial"			,"Grupo Inicial"			,"Grupo Inicial"			,"mv_ch3","C",04,0,0,"G","","SBM"	,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Grupo Final"				,"Grupo Final"				,"Grupo Final"				,"mv_ch4","C",04,0,0,"G","","SBM"	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Familia "				,"Familia "					,"Familia"					,"mv_ch5","N",01,0,0,"C","",""		,"",,"mv_par05","Original"	,"Original"	,"Original"	,"","Generico"	,"Generico"	,"Generico"	,"Ambos"	,"Ambos"	,"Ambos"	,"","","","","","")
PutSX1(cPerg,"06","Categoria Inicial"		,"Categoria Inicial"		,"Categoria Inicial"		,"mv_ch6","C",25,0,0,"G","",""		,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Categoria Final"			,"Categoria Final"			,"Categoria Final"			,"mv_ch7","C",25,0,0,"G","",""		,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Modelo Inicial"			,"Modelo Inicial"			,"Modelo Inicial"			,"mv_ch8","C",15,0,0,"G","",""		,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Modelo Final"			,"Modelo Final"				,"Modelo Final"				,"mv_ch9","C",15,0,0,"G","",""		,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Cor Inicial"				,"Cor Inicial"				,"Cor Inicial"				,"mv_cha","C",02,0,0,"G","","Z3"	,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Cor Final"				,"Cor Final"				,"Cor Final"				,"mv_chb","C",02,0,0,"G","","Z3"	,"",,"mv_par11","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"12","STW Inicial"				,"STW Inicial"		 		,"STW Inicial"				,"mv_chc","C",02,0,0,"G","","Z4"	,"",,"mv_par12","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"13","STW Final"				,"STW Final"	   			,"STW Final"				,"mv_chd","C",02,0,0,"G","","Z4"	,"",,"mv_par13","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"14","GSM x CDMA"				,"GSM x CDMA"				,"GSM x CDMA"	,"mv_che","N",01,0,0,"C","",""		,"",,"mv_par14","GSM","GSM","GSM","","CDMA","CDMA","CDMA","Ambos","Ambos","Ambos","","","","","","")
PutSX1(cPerg,"15","Digite os Armazens"				,"Digite os Armazens"				,"Digite os Armazens"				,"mv_chf","C",20,0,0,"G","",""	,"",,"mv_par15","","","","","","","","","","","","","","","","")

Return Nil