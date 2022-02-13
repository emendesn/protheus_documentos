#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ POSCOMP  ∫ Autor ≥ Edson Rodrigues    ∫ Data ≥  25/03/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Posicao de  Estoque  / valor estoque                       ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico BGH DO BRASIL                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function POSESTQ()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local cDesc1        := "Este programa tem como objetivo gerar um relatÛrio da PosiÁ„o e valor Contabil do Estoque "
Local cDesc2        := "DisribuiÁ„o."
Local cDesc3        := "EspecÌfico BGH"
Local cPict         := ""
Local titulo        := "PosiÁ„o e valor Contabil do Estoque  DistribuiÁ„o"
Local nLin          := 80
Local Cabec1        := "Produto          Descricao                  Armazem  Tipo        Fabricante       Modelo         Estq.Atual   Unit Valor-CTA      Total Valor-CTA "
Local Cabec2        := "                 "
Local imprime       := .T.
Local aOrd          := {}
Local _ddata        := ddatabase
Local _ndia         := 0
Local _nmes         := 0                                      
Local _nano         := 0
Local _campos       := space(2)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ESTOQD"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "ESTOQD"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "ESTOQD"
Private cString     := ""
Private _aprodnf    := {} 
Private _aquinz     := {}                                       
Private _aCampos    := {}                                    
private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

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
Local _cArqTrab := CriaTrab(,.f.) 


_aCampos := {	{"CODIGO"		,"C", 15, 0},;
				{"DESCRICAO"	,"C", 30, 0},;
				{"TIPO"			,"C", 15, 0},;				
				{"FABRICANTE"	,"C", 20, 0},;
				{"MODELO"	    ,"C", 20, 0},;
				{"ARMAZ"	    ,"C", 02, 0},;
				{"GRUPO"	    ,"C", 04, 0},;
				{"FAMILIA"		,"C", 08, 0},;
                {"CATEGORIA"	,"C", 25, 0},;     
                {"COR"			,"C", 02, 0},;                  
                {"OPERADORA"	,"C", 02, 0},;           
                {"GSMCDMA"		,"C", 04, 0},;              
                {"COMPRAS"		,"N", 14, 2},;                      
                {"VENDAS"		,"N", 14, 2},;              
                {"TRANSF"		,"N", 14, 2},;              
                {"DEVCOM"		,"N", 11, 2},;              
                {"DEVVEN"		,"N", 11, 2},;              
                {"SALFISICO"	,"N", 11, 2},;              
                {"PVABERTO"		,"N", 11, 2},;              
                {"SALDISPON	"	,"N", 11, 2},;              
                {"ULTNFCOMP"	,"C", 06, 0},;                   
                {"QTDCOMP"		,"N", 11, 2},;        	      
                {"VLRCOMP"		,"N", 14, 2},;        	      
                {"ICMSCOMP"		,"N", 11, 2},;        	      
                {"IPICOMP"		,"N", 11, 2},;          	      
                {"PICMCOMP"		,"N", 07, 2},;        	      
                {"PIPICOMP"		,"N", 07, 2},;        	      
                {"CMVCTAUN"		,"N", 14, 2},;        	      
                {"CMVCTATT"		,"N", 14, 2}}        	      
		
_cArqSeq := CriaTrab(_aCampos)
dbUseArea(.T.,,_cArqSeq,"TPCOM",.T.,.F.)				




//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Fecha os arquivos temporarios, caso estejam abertos          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
if select("TRB") > 0
	TRB->(dbCloseArea())
endif
                            

if select("TPC") > 0
	TPC->(dbCloseArea())
endif              

_cQuery += CR + " SELECT RTRIM(PRODUTO)  AS CODIGO, B1_DESC AS DESCRICAO, "
_cQuery += CR + "                  TIPO_PRODUTO=CASE WHEN B1_TIPOP='A'  THEN 'ACESSORIO'  WHEN B1_TIPOP='C' THEN 'APARELHO'  WHEN B1_TIPOP='K'  THEN 'KIT' ELSE ''  END,"
_cQuery += CR + "                   B1_GRUPO AS GRUPO,ARMAZEN AS ARMAZ,B1_FABRIC AS FABRICANTE, "
_cQuery += CR + "                  FAMILIA=CASE WHEN B1_XFAMILI='O' THEN 'ORIGINAL' ELSE 'GENERICO' END, B1_XCATEG AS CATEGORIA, B1_XMODELO AS MODELO, B1_XCOR AS COR, B1_XSTW AS OPERADORA, "
_cQuery += CR + "                  GSMCDMA= CASE WHEN  B1_XGSMCDM='G' THEN 'GSM' ELSE 'CDMA' END,COMPRAS, VENDAS, TRANSF,DEVCOM, DEVVEN, SALFISICO, PVABERTO, SALDISPON,' ' AS ULTNFCOMP, 0  AS QTDCOMP, 0 AS VLRCOMP, 0 AS ICMSCOMP, 0 IPICOMP, 0 PICMCOMP, 0 PIPICOMP, 0 CMVCTAUN,0 CMVCTATT "
_cQuery += CR + " FROM   (SELECT TRB.PRODUTO,ARMAZEN, "
_cQuery += CR + "                              SUM(COMPRAS) COMPRAS, "
_cQuery += CR + "                              SUM(DEVVEN) DEVVEN, "
_cQuery += CR + "                              SUM(VENDAS) VENDAS, "
_cQuery += CR + "                              SUM(DEVCOM) DEVCOM, "
_cQuery += CR + "                              SUM(TRANSF) TRANSF, "
_cQuery += CR + "                              AJUSTES =SUM(SALDOB2) - (SUM(COMPRAS) - ((SUM(VENDAS) + SUM(DEVVEN) + SUM(TRANSF) - SUM(DEVCOM)))) ,"
_cQuery += CR + "                              SALFISICO = SUM(SALDOB2) ,  "
_cQuery += CR + "                              SUM(PVABERTO)  AS PVABERTO, "
_cQuery += CR + "                              SALDISPON = SUM(COMPRAS) - SUM(VENDAS) + SUM(DEVVEN) + SUM(TRANSF)  - SUM(DEVCOM) - SUM(PVABERTO) " 
_cQuery += CR + "                               FROM   (SELECT D1_COD PRODUTO, D1_TIPO TIPONF,D1_LOCAL  ARMAZEN,"
_cQuery += CR + "                                              COMPRAS = CASE WHEN D1_TIPO = 'N' THEN SUM(D1_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                              DEVVEN  = CASE WHEN D1_TIPO = 'D' THEN SUM(D1_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                              VENDAS  = 0, DEVCOM = 0, PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD1") + "  D1 (nolock)  JOIN " + RetSqlName("SF4") + " AS F4 (nolock)  ON F4_CODIGO = D1_TES AND F4_PODER3 IN ('N') AND F4.D_E_L_E_T_ = '' "
if !empty(mv_par05) 
  _cQuery += CR + "                                            WHERE  D1.D1_FILIAL='"+xFilial("SD1")+"' AND D1.D_E_L_E_T_ = ''  AND D1_TIPO IN ('N', 'D')  AND  SUBSTRING(D1_COD,1,2) IN "+_cinprbgh+"  AND D1_COD     BETWEEN '' AND 'ZZZZZZ'  AND '"+mv_par05+"' LIKE'%'+D1_LOCAL+'%' "
Else
_cQuery += CR + "                                              WHERE  D1.D1_FILIAL='"+xFilial("SD1")+"' AND D1.D_E_L_E_T_ = ''  AND D1_TIPO IN ('N', 'D')  AND  SUBSTRING(D1_COD,1,2) IN "+_cinprbgh+"  AND D1_COD     BETWEEN '' AND 'ZZZZZZ' " 
Endif
_cQuery += CR + "                                              GROUP BY D1_COD, D1_TIPO,D1_LOCAL " 
_cQuery += CR + "                                              UNION ALL "
if !empty(mv_par05)  .and. "80" $ mv_par05 
  _cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
  _cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock)  WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='80' AND D_E_L_E_T_='' AND D3_TM='999' AND D3_EMISSAO='20070621'  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+"  "
  _cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL"
  _cQuery += CR + "                                              UNION ALL "
endif                                                         
if !empty(mv_par05)  .and. "82" $ mv_par05 

_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock)  WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL='82' AND D_E_L_E_T_='' AND D3_TM='499' AND D3_EMISSAO='20070621' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+"  "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "  
endif               
if !empty(mv_par05)  .and. "80/81" $ mv_par05 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81') AND D_E_L_E_T_='' AND D3_TM='999' AND D3_EMISSAO='20071227'  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
Endif                                                              
if !empty(mv_par05)  .and. "83/84" $ mv_par05 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('83','84') AND D_E_L_E_T_='' AND D3_TM='499' AND D3_EMISSAO='20071227' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
Endif
if !empty(mv_par05)  .and. "80/81/82/83/84" $ mv_par05 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502') AND D3_EMISSAO='20071228' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002') AND D3_EMISSAO='20071228' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080104' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080104' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080213' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080213' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('600','502','999') AND D3_EMISSAO='20080402' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+""
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "  
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN ('80','81','82','83','84') AND D_E_L_E_T_='' AND D3_TM IN ('499','002','100') AND D3_EMISSAO='20080402' AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "   
Endif      
if !empty(mv_par05)
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN "+_carmdist+" AND D_E_L_E_T_='' AND D3_TM IN ('700','999')  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_LOCAL IN "+_carmdist+" AND D_E_L_E_T_='' AND D3_TM IN ('200','499')  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "                               
Else                                                                                                                                                                                                                                  
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'D' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,-1*SUM(D3_QUANT) TRANSF,SALDOB2=0 " 
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND  '"+mv_par05+"' LIKE'%'+D3_LOCAL+'%'  AND D_E_L_E_T_='' AND D3_TM IN ('700','999')  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL " 
_cQuery += CR + "                                              SELECT D3_COD PRODUTO,'T' TIPONF,D3_LOCAL ARMAZEN,COMPRAS =  0,DEVVEN=0,VENDAS=0,DEVCOM=0,PVABERTO=0,SUM(D3_QUANT) TRANSF,SALDOB2=0  "
_cQuery += CR + "                                              FROM " + RetSQLName("SD3") + " (nolock) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND  '"+mv_par05+"' LIKE'%'+D3_LOCAL+'%'  AND D_E_L_E_T_='' AND D3_TM IN ('200','499')  AND SUBSTRING(D3_COD,1,2) IN "+_cinprbgh+" "
_cQuery += CR + "                                              GROUP BY D3_COD, D3_LOCAL "
_cQuery += CR + "                                              UNION ALL "      
Endif
_cQuery += CR + "                                              SELECT D2_COD PRODUTO, D2_TIPO TIPONF, D2_LOCAL  ARMAZEN, "
_cQuery += CR + "                                                              COMPRAS = 0, DEVVEN = 0, " 
_cQuery += CR + "                                                             VENDAS  = CASE WHEN D2_TIPO = 'N' THEN SUM(D2_QUANT) ELSE 0 END,  "
_cQuery += CR + "                                                             DEVCOM  = CASE WHEN D2_TIPO = 'D' THEN SUM(D2_QUANT) ELSE 0 END,  " 
_cQuery += CR + "                                                             PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD2") + " AS  D2 (nolock)  JOIN   " + RetSqlName("SF4") + "  AS F4 (nolock)  ON F4_CODIGO = D2_TES AND F4_PODER3 IN ( 'N') AND F4.D_E_L_E_T_ = ''  AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE  D2.D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = ''    AND  D2_TIPO IN ('N', 'D')  AND  SUBSTRING(D2_COD,1,2) IN "+_cinprbgh+"   AND D2_COD     BETWEEN '' AND 'ZZZZZZ'  AND  D2_TES <> '786'  "
_cQuery += CR + "                                              GROUP BY D2_COD, D2_TIPO,D2_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT D2_COD PRODUTO, D2_TIPO TIPONF, D2_LOCAL  ARMAZEN, "
_cQuery += CR + "                                                              COMPRAS = 0, DEVVEN = 0, " 
_cQuery += CR + "                                                             VENDAS  = CASE WHEN D2_TIPO = 'N' THEN SUM(D2_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                                             DEVCOM  = CASE WHEN D2_TIPO = 'D' THEN SUM(D2_QUANT) ELSE 0 END, " 
_cQuery += CR + "                                                             PVABERTO = 0,TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SD2") + " AS  D2 (nolock)  JOIN   " + RetSQLName("SF4") + "   AS F4  (nolock) ON F4_CODIGO = D2_TES AND F4_PODER3 IN ( 'R') AND F4.D_E_L_E_T_ = ''  AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE  D2.D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = ''    AND  D2_TIPO IN ('N', 'D')  AND SUBSTRING(D2_COD,1,2) IN "+_cinprbgh+"   AND D2_COD     BETWEEN '' AND 'ZZZZZZ' AND D2_TES='758' " 
_cQuery += CR + "                                              GROUP BY D2_COD, D2_TIPO,D2_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT C6_PRODUTO PRODUTO, TIPONF = '',C6_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = SUM(C6_QTDVEN - C6_QTDENT),TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SC6") + "  AS C6 (nolock)   JOIN   " + RetSQLName("SF4") + "  AS F4  (nolock)  ON  F4_CODIGO = C6_TES AND F4_PODER3 = 'R' AND F4.D_E_L_E_T_ = '' AND C6_TES='758' "
_cQuery += CR + "                                              WHERE  C6.C6_FILIAL='"+xFilial("SC6")+"' AND SUBSTRING(C6_PRODUTO,1,2) IN "+_cinprbgh+"  AND C6_PRODUTO BETWEEN '' AND 'ZZZZZZ'   AND C6_QTDVEN - C6_QTDENT > 0  AND C6.D_E_L_E_T_ = '' "  
_cQuery += CR + "                                              GROUP BY C6_PRODUTO,C6_LOCAL "
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT C6_PRODUTO PRODUTO, TIPONF = '',C6_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = SUM(C6_QTDVEN - C6_QTDENT),TRANSF=0,SALDOB2=0 "
_cQuery += CR + "                                              FROM   " + RetSQLName("SC6") + "  AS C6 (nolock)   JOIN   " + RetSQLName("SF4") + " AS F4 (nolock)   ON  F4_CODIGO = C6_TES AND F4_PODER3 = 'N' AND F4.D_E_L_E_T_ = '' AND F4_ESTOQUE='S' "
_cQuery += CR + "                                              WHERE C6.C6_FILIAL='"+xFilial("SC6")+"' AND  SUBSTRING(C6_PRODUTO,1,2) IN "+_cinprbgh+"  AND C6_PRODUTO BETWEEN '' AND 'ZZZZZZ'   AND C6_QTDVEN - C6_QTDENT > 0  AND C6.D_E_L_E_T_ = ''  AND C6_TES <> '786'  " 
_cQuery += CR + "                                              GROUP BY C6_PRODUTO,C6_LOCAL
_cQuery += CR + "                                              UNION ALL "
_cQuery += CR + "                                              SELECT B2_COD  PRODUTO, TIPONF = '',B2_LOCAL  ARMAZEN, COMPRAS = 0, DEVVEN = 0, VENDAS = 0, DEVCOM = 0, PVABERTO = 0,TRANSF=0  ,SALDOB2=SUM(B2_QATU) " 
_cQuery += CR + "                                              FROM   " + RetSQLName("SB2") + "  AS B2 (nolock)   WHERE  B2.B2_FILIAL='"+xFilial("SB2")+"' AND SUBSTRING(B2_COD,1,2) IN "+_cinprbgh+"  AND B2.D_E_L_E_T_=''  AND '"+mv_par05+"'  LIKE  '%'+B2_LOCAL+'%'   GROUP BY B2_COD,B2_LOCAL ) AS TRB    GROUP BY PRODUTO,ARMAZEN) AS EST  JOIN  "+ RetSQLName("SB1") +" AS B1  ON  B1_COD = EST.PRODUTO AND B1.D_E_L_E_T_ = '' "
_cQuery += CR + " WHERE B1.B1_COD >= '"+MV_PAR01+"' AND B1.B1_COD<='"+MV_PAR02+"' "  
IF MV_PAR03==1
_cQuery += CR + " AND B1.B1_TIPOP='C' " 
ENDIF
IF MV_PAR03==2
_cQuery += CR + " AND B1.B1_TIPOP='A' " 
ENDIF   
IF !EMPTY(MV_PAR04)
  _cQuery += CR + " AND B1.B1_FABRIC LIKE '%"+MV_PAR04+"%' "
ENDIF                                                       
if !empty(mv_par05) // Armazem
    _cQuery += CR +  "     AND '"+mv_par05+"' LIKE'%'+ARMAZEN+'%' "
endif
 _cQuery += CR + " ORDER BY B1.B1_COD,B1.B1_LOCPAD "

_cQuery := strtran(_cQuery, CR, "")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.F.)


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
  _ncompra	= 0.00
  _cprod	:= SPACE(15)
  _cLocal	:= SPACE(2)
  _cdescr	:= SPACE(25)
            
 
 
 
  IF TRB->SALFISICO > 0 
    _cprod   	:= TRB->CODIGO
    _cLocal  	:= TRB->ARMAZ
    _nsalfis 	:= TRB->SALFISICO
    _cdescr  	:= SUBSTR(TRB->DESCRICAO,1,25)
    _ctipo   	:= TRB->TIPO_PRODUTO
    _cfabric 	:= TRB->FABRICANTE
    _cmodelo 	:= TRB->MODELO

    _nfcomp  	:= getcompra(_cprod,_nsalfis,_cLocal,_cdescr,_ctipo,_cfabric,_cmodelo) 
    _nqtcomp 	:= 0.00
    _ncomp   	:= 0.00
    _ncms    	:= 0.00
    _npicm   	:= 0.00
    _nipi    	:= 0.00
    _npipi   	:= 0.00
    _ntotucmv	:= 0.00
    _ntottcmv	:= 0.00
    
    dbSelectArea("SD1")
    dbSetOrder(2)
    if SD1->(dbSeek(xFilial("SD1")+_cprod+_nfcomp))
        _nqtcomp := SD1->D1_QUANT
        _ncomp   := SD1->D1_TOTAL
        _ncms    := SD1->D1_VALICM
        _npicm   := SD1->D1_PICM       
        _nipi    := SD1->D1_VALIPI 
        _npipi   := SD1->D1_IPI 
    Else
         _cprodnew:="Z"+SUBSTR(_cprod,2,14)
         if SD1->(dbSeek(xFilial("SD1")+_cprodnew+_nfcomp))
            _nqtcomp := SD1->D1_QUANT
            _ncomp   := SD1->D1_TOTAL
            _ncms    := SD1->D1_VALICM
            _npicm   := SD1->D1_PICM
            _nipi    := SD1->D1_VALIPI
            _npipi   := SD1->D1_IPI 
         Endif    
    Endif
    //                           1         2        3         4            5        6              7        8                9       10          11    12      13      14          
    aAdd(_aProdnf,{_cprod,_cLocal,_cdescr,_ctipo,_cfabric,_cmodelo,_nsalfis,_nqtcomp,_ncomp,_ncms,_npicm,_nipi,_npipi,_nfcomp})
    
    _ntotucmv  += (((_ncomp/_nqtcomp)*(_npipi/100))+((_ncomp/_nqtcomp)*(1-0.0925-(_npicm/100))))
    _ntottcmv  += (((_ncomp/_nqtcomp)*(_npipi/100))+((_ncomp/_nqtcomp)*(1-0.0925-(_npicm/100))))*_nsalfis

   	reclock("TPCOM",.T.)
		TPCOM->CODIGO	       	:= TRB->CODIGO
		TPCOM->DESCRICAO	   	:= TRB->DESCRICAO
		TPCOM->TIPO           	:= TRB->TIPO_PRODUTO
		TPCOM->FABRICANTE      	:= TRB->FABRICANTE
		TPCOM->MODELO	       	:= TRB->MODELO	
		TPCOM->ARMAZ	       	:= TRB->ARMAZ
        TPCOM->GRUPO	       	:= TRB->GRUPO		
		TPCOM->FAMILIA	       	:= TRB->FAMILIA
		TPCOM->CATEGORIA       	:= TRB->CATEGORIA
		TPCOM->COR            	:= TRB->COR
		TPCOM->OPERADORA      	:= TRB->OPERADORA
		TPCOM->GSMCDMA         	:= TRB->GSMCDMA        
		TPCOM->COMPRAS         	:= TRB->COMPRAS
		TPCOM->VENDAS          	:= TRB->VENDAS
		TPCOM->TRANSF          	:= TRB->TRANSF
		TPCOM->DEVCOM          	:= TRB->DEVCOM
		TPCOM->DEVVEN        	:= TRB->DEVVEN
	    TPCOM->SALFISICO      	:= TRB->SALFISICO
	    TPCOM->PVABERTO        	:= TRB->PVABERTO
	    TPCOM->SALDISPON	  	:= TRB->SALDISPON
		TPCOM->ULTNFCOMP     	:= _nfcomp
		TPCOM->QTDCOMP	      	:= _nqtcomp
		TPCOM->VLRCOMP	      	:= _ncomp
		TPCOM->ICMSCOMP	      	:= _ncms
		TPCOM->IPICOMP  	  	:= _nipi
		TPCOM->PICMCOMP	      	:= _npicm
		TPCOM->PIPICOMP	      	:= _npipi
		TPCOM->CMVCTAUN	      	:= _ntotucmv
		TPCOM->CMVCTATT	      	:= _ntottcmv
	msunlock()

  ENDIF  
  TRB->(dbSkip())
  IncRegua() 
Enddo                                 

If Len(_aProdnf) > 0                 
   _ntotucmv 	:= 0.00
   _ntottcmv 	:= 0.00
   _ntotest 	:= 0.00

   For _nit := 1 to Len(_aProdnf)
     	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
     	//≥ Verifica o cancelamento pelo usuario...                             ≥
	   //¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	   If lAbortPrint
	    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	    	Exit
	    Endif     
	    
    	IncRegua()
	
	    //⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	    //≥ Impressao do cabecalho do relatorio. . .                            ≥
	    //¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	    If nLin > 55                  	           
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                     
	        nLin := 9
 	    Endif
	
        //"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        //"0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
        //"Produto          Descricao                  Armazem Tipo             Fabricante      Modelo     Estq.Atual   CMV-CTA Unit     Total CMV-CTA "
        //""  
        _nucmv   := 0.00
        _ntcmv   := 0.00        
        _ntotest   +=_aProdnf[_nit,7]
        _ntotucmv  += (((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,13]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,11]/100))))
        _ntottcmv  += ((((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,13]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,11]/100))))*_aProdnf[_nit,7])     

  	    @nLin,000 PSAY _aProdnf[_nit,1]
	    @nLin,017 PSAY _aProdnf[_nit,3]
   	 	@nLin,046 PSAY _aProdnf[_nit,2]
	    @nLin,052 PSAY _aProdnf[_nit,4]
	    @nLin,065 PSAY _aProdnf[_nit,5]
	    @nLin,081 PSAY _aProdnf[_nit,6]
	    @nLin,098 PSAY TRANSFORM(_aProdnf[_nit,7],"@E 999,999.99")
	    _nucmv  += (((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,13]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,11]/100))))
        _ntcmv  += ((((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(_aProdnf[_nit,13]/100))+((_aProdnf[_nit,9]/_aProdnf[_nit,8])*(1-0.0925-(_aProdnf[_nit,11]/100))))*_aProdnf[_nit,7])     
 	    @nLin,112 PSAY TRANSFORM(_nucmv,"@E 999,999.99")
	    @nLin,128 PSAY TRANSFORM(_ntcmv, "@E 999,999,999.99")	    
	    nLin := nLin + 1                        
   		next _nit                                             
        nLin := nLin + 1
   	    @nLin,000 PSAY "T O T A L    G E  R  A  L ........  "
   	    @nLin,093 PSAY TRANSFORM(_ntotest,"@E 999,999,999.99")
   	    @nLin,107 PSAY TRANSFORM(_ntotucmv,"@E 999,999,999.99")
 	    @nLin,128 PSAY TRANSFORM(_ntottcmv,"@E 999,999,999.99")  

Endif


dbSelectArea("TPCOM")

_cArq  := "Pos-Estoque_"+Alltrim(cUserName)+".csv"
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )


_lOPen := .f.
                            

dbSelectArea("TPCOM")
TPCOM->(dbgotop())

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

TRB->(dbCloseArea()) 
TPCOM->(dbCloseArea()) 


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





Static Function Getcompra(_cprod,_nsalfis,_clocal,_cdescr)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aArea  := GetArea()
Local _cprodnew := Space(15)                                   
Local lqry := .f.   
LOCAL _cquinz := ""
LOCAL _cmesano := SPACE(6)

if select("QrySD1") > 0
	QrySD1->(dbCloseArea())
endif

cQuery := " SELECT SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MAX(SD1.D1_DTDIGIT) DTDIGIT " 	
cQuery += " FROM "+RETSQLNAME('SD1')+" SD1 (nolock) "
cQuery += " INNER JOIN "+RETSQLNAME('SF4')+" AS SF4 (nolock) ON D1_TES=SF4.F4_CODIGO "
cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += " AND SD1.D1_LOCAL = '"+_cLocal+"' "
cQuery += " AND SD1.D_E_L_E_T_ <> '*' AND SD1.D1_COD = '"+_cProd+"' "
cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(ddatabase)+"'"
cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ <> '*' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
cQuery += " GROUP BY SD1.D1_DTDIGIT,SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "   

TCQUERY cQuery ALIAS "QrySD1" NEW

                                                                      
if !QrySD1->(EOF())
   lqry=.T.       
else                  
   QrySD1->(dbCloseArea())  
 
   _cprodnew:="Z"+SUBSTR(_cprod,2,14)
   cQuery := " SELECT SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MAX(SD1.D1_DTDIGIT) DTDIGIT " 	
   cQuery += " FROM "+RETSQLNAME('SD1')+" SD1 (nolock) "
   cQuery += " INNER JOIN "+RETSQLNAME('SF4')+" AS SF4 (nolock) ON D1_TES=SF4.F4_CODIGO "
   cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' " 
   cQuery += " AND SD1.D1_LOCAL IN ('80','81') "
   cQuery += " AND SD1.D_E_L_E_T_ <> '*' AND SD1.D1_COD = '"+_cprodnew+"' "
   cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(ddatabase)+"' "
   cQuery += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
   cQuery += " AND SF4.F4_PODER3 = 'N' AND SF4.D_E_L_E_T_ <> '*' AND SD1.D1_TIPO IN ('N') AND SF4.F4_TEXTO LIKE '%COMPR%' "
   cQuery += " GROUP BY SD1.D1_DTDIGIT,SD1.D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA " 

   TCQUERY cQuery ALIAS "QrySD1" NEW
endif   

if !QrySD1->(EOF())
   lqry=.T.      
Endif

TCSETFIELD( "QrySD1","DTDGIT","D")

dbSelectArea("QrySD1")
IF lqry 
   _cNFSD1:=QrySD1->D1_DOC+SUBSTR(QrySD1->D1_SERIE,1,3)+QrySD1->D1_FORNECE+D1_LOJA
ELSE      
  _cNFSD1:=""      
          
ENDIF                     
DBSelectArea('QrySD1')
//DBCloseArea('QrySD1') 
QrySD1->(DBCloseArea()) 

RestArea(aArea)
Return(_cNFSD1)                                 

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
PutSX1(cPerg,"03","Tipo "				    ,"Tipo "					,"Tipo"					    ,"mv_ch3","N",01,0,0,"C","",""		,"",,"mv_par03","Aparelho"	,"Aparelho"	,"Aparelho"	,"","AcessÛrio"	,"AcessÛrio"	,"AcessÛrio"	,"Ambos"	,"Ambos"	,"Ambos"	,"","","","","","")
PutSX1(cPerg,"04","Fabricante"			,"Fabricante"			,"Fabricante"		             	,"mv_ch4","C",6,0,0,"G","","Z6"	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"O5","Armazens"				,"Armazens"				,"Armazens"				,"mv_ch5","C",20,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","")
Return Nil