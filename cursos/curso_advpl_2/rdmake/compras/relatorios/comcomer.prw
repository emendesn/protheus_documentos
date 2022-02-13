#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMCOMER  บAutor  ณGRAZIELLA BIANCHIN  บ Data ณ  15/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ COMPRAS MOSTRA OS ITENS COMPRADOS DE ACORDO COM A TES      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACOM - EXCLUSIVO BGH                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                  
User Function COMCOMER()

	Private nCusult  :=0
	Private nCusreps :=0
	Private cPerg	 :="COMCOR"   
	Private _csrvapl := ALLTRIM(GetMV("MV_SERVAPL"))  

	u_GerA0003(ProcName())
	
	//ValidPerg(cPerg) 
	
	if !Pergunte(cPerg,.T.)
		Return()
	Endif
	
	Processa( { ||relgerpri() } ) 
	Return .t.

return .T.

Static Function relgerpri()
//VARIAVEIS PARA MANIPULACAO DO ARQUIVO
Local cQry1 		:=""
Local cQuery 		:=""
Local cQry2 		:=""
Local cDirDocs		:= __RelDir
Local cCrLf			:=Chr(13)+Chr(10)
Local cArquivo		:=CriaTrab(,.F.)
Local cPath			:=AllTrim(GetTempPath())

Local cDescriProd := ""
Local cFabric	  := ""    
Local cConContabil:= ""
Local cCCusto	  := "" 

Local cNomeCliFor := ""
Local cMunCliFor  := ""
Local cEstCliFor  := ""	
Local cNatCliFor  := ""	

Local cCondPagto  := ""
Local cDescPagto  := ""

//VARIAVEIS PARA UTILIZACAO NA TABELA
Local nTotFAT	 :=0 
Local nTotFATLIQ :=0
Local nTotMC     :=0
Local nTotIPI    :=0
Local nTotISS    :=0
Local nTotCUSTO  :=0
Local nTotICMS   :=0
Local nTotPIS    :=0
Local nTotCOFINS :=0
Local nTotMCPER  :=0                    
Local nTotCusult :=0
Local nTotCust2  :=0
Local nTotCust2  :=0
Local nTotCusre  :=0
Local nTotCustq  :=0 
Local nTotRetIcms:=0 
Local nTotFrete  :=0 
Local nTotDescon :=0 
Local nTotBruto  :=0 
Local nTaxa      :=0  

//VARIAVEIS PARA MANIPULACAO DO ARQUIVO
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
nHandle 		:= MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

//CABECALHO DO ARQUIVO
cLinha 	:= "FILIAL;NOTA;SERIE;NUM_PEDIDO;DT_IMPUT;EMISSAO;ARMAZEM;FORNEC;"
cLinha 	+= "LOJA;NOME_FOR;CIDADE;UF;CCUSTO;CCONTABIL;NATUREZ;NUM_PEDIDO;"
cLinha 	+= "CFOP;TES;CONDICAO_PGTO;ITEM;PRODUTO;DESCRICAO;FABRIC;"
cLinha 	+= "QTDE;VL_UNIT;DESC;VAL_DESC;TOT_SEM_IMP;"
cLinha 	+= "VL_IPI;ALIQ_IPI;TOTAL_COM_IPI;
cLinha 	+= "VL_ICMS;ALIQ_ICMS;TOTAL_COM_ICMS;"
cLinha 	+= "ICMS_RET;ISS;COFINS;PIS;FRETE;TOT_LIQ;MC;MC_%;"
cLinha 	+= "CUSTO;CUSTO1_UNIT;CUSTO1_TOTAL;CUSTO2_C_IMP;"
cLinha 	+= "CUSTO3;VL_BRUTO_NOTA;TOTAL;TAXA;NFEORI;"


//INICIO DA GRAVACAO DO ARQUIVO 
fWrite(nHandle, cLinha  + cCrLf)  

dbSelectArea("SM2")
DbSetOrder(1)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

cQuery += " SELECT 						"  
cQuery += " D1_FILIAL  AS FILIAL,  		"
cQuery += " D1_DOC     AS NOTA,			"
cQuery += " D1_SERIE   AS SERIE,		"
cQuery += " D1_PEDIDO  AS NUM_PEDIDO, 	"  
cQuery += " D1_DTDIGIT AS DT_IMPUT, 	"
cQuery += " D1_EMISSAO AS EMISSAO, 		"
cQuery += " D1_LOCAL   AS ARMAZEM,		"
cQuery += " D1_FORNECE AS FORN,			"
cQuery += " D1_LOJA	   AS LOJA,			"
cQuery += " D1_ITEM    AS ITEM,			"
cQuery += " D1_CF      AS CFOP, 		"   
cQuery += " D1_TES 	   AS TES, 			"
cQuery += " D1_COD     AS PRODUTO, 		"
cQuery += " D1_QUANT   AS QUANTIDADE,	"
cQuery += " D1_VUNIT   AS VL_UNITARIO,	"
cQuery += " (D1_QUANT * D1_VUNIT)+D1_VALFRE AS TOTAL_SEM_IMPOSTOS,"
cQuery += " SUM(D1_VALIPI)  AS VL_IPI,  		"
cQuery += " SUM(D1_TOTAL - D1_VALDESC + D1_VALIPI)   AS 'TOTAL_COM_IPI',"
cQuery += " D1_IPI     AS ALIQUOTA_IPI,	"
cQuery += " SUM(D1_VALICM)  AS VL_ICMS, 		" 
cQuery += " SUM(D1_TOTAL - D1_VALDESC + D1_VALICM)   AS 'TOTAL_COM_ICMS',"
cQuery += " D1_PICM    AS ALIQUOTA_ICMS,"
cQuery += " SUM(D1_VALISS)  AS ISS    ,"
cQuery += " SUM(D1_CUSTO)   AS CUSTO  ,"
cQuery += " SUM(D1_VALIMP6) AS PIS    ,"
cQuery += " SUM(D1_VALIMP5) AS COFINS ,"
cQuery += " SUM(D1_ICMSRET) AS ICMSRET,"
cQuery += " SUM(D1_VALFRE)  AS FRETE  ,"
cQuery += " SUM(D1_DESC) 	AS DESC1  ,"	     
cQuery += " SUM(D1_VALDESC) AS VAL_DESC,"
cQuery += " SUM(D1_TOTAL)   AS TOTAL,		"
cQuery += " SUM(D1_TOTAL   + D1_VALIPI + D1_VALFRE  - D1_VALICM  - D1_VALIPI - D1_VALISS - D1_VALIMP6 - D1_VALIMP5  ) AS 'TOT_LIQ' ,"
cQuery += " (((SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) + SUM(D1_VALIMP5)) + SUM(D1_CUSTO))) AS MC ,"
cQuery += " (((SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5)) + SUM(D1_CUSTO))/( SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5))) 'MC_PERCENT'  ,"
cQuery += " D1_NFORI        AS 'NFEORI'"    
cQuery += " FROM   " +Retsqlname ("SD1") + " SD1  " 
cQuery += " WHERE  SD1.D1_FILIAL='"+(MV_PAR07)+"' "
cQuery += "   AND SD1.D1_CF IN ('1101','1124','1102','1202','1252','1302','1352','1401','1403','1406','1407', "
cQuery += "                     '1411','1551','1556','1910','1932','1949','2101','2102','2352','2401','2403', "
cQuery += "                     '2406','2407','2411','2551','2556','2910','2932','2949','3101','3102','3556') "
cQuery += "   AND  SD1.D1_COD     BETWEEN '"+(MV_PAR03)    +"' AND '"+(MV_PAR04)    +"'                      "
cQuery += "   AND  SD1.D1_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'                      "
cQuery += "   AND  SD1.D1_DOC     BETWEEN '"+(MV_PAR05)    +"' AND '"+(MV_PAR06)    +"'                      "
cQuery += "   AND  SD1.D_E_L_E_T_ = ''                                                                        "
cQuery += " GROUP BY  D1_FILIAL	,D1_DOC     ,D1_SERIE, D1_PEDIDO  ,D1_DTDIGIT, D1_EMISSAO, "
cQuery += "			  D1_LOCAL  ,D1_FORNECE ,D1_LOJA    ,D1_ITEM    ,"
cQuery += " D1_CF      ,D1_TES	   ,D1_COD     ,D1_QUANT   ,D1_VUNIT   ,D1_VALIPI  , "
cQuery += " D1_IPI     ,D1_VALICM  ,D1_PICM    ,D1_ICMSRET ,D1_VALISS  , "
cQuery += " D1_VALIMP5 ,D1_VALIMP6 ,D1_VALFRE  ,D1_DESC    ,D1_VALDESC ,D1_TOTAL   , "
cQuery += " D1_CUSTO   ,D1_VALIMP6 ,D1_VALIMP5 ,D1_ICMSRET ,D1_NFORI    "
cQuery += " ORDER BY D1_FILIAL, D1_DTDIGIT, D1_DOC, D1_ITEM "

TCQUERY cQuery NEW ALIAS "QRY1"                                                                                                                       
TcSetField("QRY1","DT_IMPUT","D")//TRANFORMACAO DAS DATAS
TcSetField("QRY1","EMISSAO","D") //TRANFORMACAO DAS DATAS

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


procregua(reccount())
Do While !QRY1->(EOF())  
	cDescriProd := POSICIONE("SB1",1,XFILIAL("SB1")+QRY1->PRODUTO,"B1_DESC") 
	cFabric		:= POSICIONE("SB1",1,XFILIAL("SB1")+QRY1->PRODUTO,"B1_FABRIC")
	cConContabil:= POSICIONE("SB1",1,XFILIAL("SB1")+QRY1->PRODUTO,"B1_CONTA")
	cCCusto		:= POSICIONE("SB1",1,XFILIAL("SB1")+QRY1->PRODUTO,"B1_CC")
	
	IF (QRY1->CFOP = '1411' .OR. QRY1->CFOP = '2411') // PESQUISAR NA SA1
		cNomeCliFor	:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+QRY1->FORN+QRY1->LOJA,"A1_NOME"))
		cMunCliFor	:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+QRY1->FORN+QRY1->LOJA,"A1_MUN"))
		cEstCliFor	:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+QRY1->FORN+QRY1->LOJA,"A1_EST"))
		cNatCliFor	:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+QRY1->FORN+QRY1->LOJA,"A1_NATUREZ"))
	ELSE // PESQUISAR NA SA2
		cNomeCliFor	:= Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QRY1->FORN+QRY1->LOJA,"A2_NOME"))
		cMunCliFor	:= Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QRY1->FORN+QRY1->LOJA,"A2_MUN"))
		cEstCliFor	:= Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QRY1->FORN+QRY1->LOJA,"A2_EST"))
		cNatCliFor	:= Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QRY1->FORN+QRY1->LOJA,"A2_NATUREZ"))		
	ENDIF
	
	
	cCondPagto  := Alltrim(POSICIONE("SF1",1,XFILIAL("SF1")+QRY1->(NOTA+SERIE+FORN+LOJA),"F1_COND"))
	cDescPagto  := Alltrim(POSICIONE("SE4",1,XFILIAL("SE4")+cCondPagto,"E4_DESCRI"))
	nTotBruto	:= QRY1->(TOTAL+VL_IPI-VAL_DESC)
	
	DbSelectArea("QRY1")
	
	//gravar apenas o ISS , siga grava o campo icms com o mesmo conteudo do ISS
    nICMS	 := QRY1->VL_ICMS
	nCusult  :=0
	nCusreps :=0 
	nCustq   :=0  

    ultcusto  (QRY1->PRODUTO)     //BUSCA VALOR NA QUERY2      (Custo de Reposi็ใo e Custo M้dio)
	u_custoq2 (QRY1->PRODUTO)     //BUSCA VALOR NA QUERY3      (CustoQ - Faturamento)
	//Alltrim(QRY1->CFOP) = '1202' .or. 
  	If Alltrim(QRY1->CFOP) = '2202' .or. Alltrim(QRY1->CFOP) = '2203'  //Custo negativo no caso de Devolucao
       	nCusult  = (nCusult)   //Caso de Devolu็ใo transforma os valores negativos
       	nCusreps = (nCusreps)  //Caso de Devolu็ใo transforma os valores negativos
       	nCustq   = (nCustq)	   //Caso de Devolu็ใo transforma os valores negativos
    endIf            
  			
  	SC7->(dbseek(xFilial("SC7") + QRY1->NUM_PEDIDO))
  	SM2->(dbseek(DTOS(SC7->C7_EMISSAO)))
  	nTaxa :=SC7->C7_TXMOEDA
  	
  	If SC7->C7_MOEDA <> 1 .AND. (NTAXA = 1 .OR. NTAXA = 0 )
		If SC7->C7_MOEDA = 1    
			nTaxa := 1
		ElseIf SC7->C7_MOEDA = 2
			nTaxa := SM2->M2_MOEDA2
		ElseIf SC7->C7_MOEDA = 3
			nTaxa := SM2->M2_MOEDA3
		ElseIf SC7->C7_MOEDA = 4  
			nTaxa := SM2->M2_MOEDA4
	  	ElseIf SC7->C7_MOEDA = 5
	  		nTaxa := SM2->M2_MOEDA5
	  	ElseIf SC7->C7_MOEDA = 6  
	  		nTaxa := SM2->M2_MOEDA6
	  	Elseif  SC7->C7_MOEDA = 7                 
	  		nTaxa := SM2->M2_MOEDA7
	  	Else
	  		nTaxa := 0	
	  	EndIF
	Endif 
    /*
    cLinha 	:= "FILIAL;NOTA;SERIE;NUM_PEDIDO;DT_IMPUT;EMISSAO;ARMAZEM;FORNEC;"
	cLinha 	+= "LOJA;NOME_FOR;CIDADE;UF;CCUSTO;CCONTABIL;NATUREZ;NUM_PEDIDO;"
	cLinha 	+= "CFOP;TES;CONDICAO_PGTO;ITEM;PRODUTO;DESCRICAO;FABRIC;"
	cLinha 	+= "QTDE;VL_UNIT;DESC;VAL_DESC;TOT_SEM_IMP;"
	cLinha 	+= "VL_IPI;ALIQ_IPI;TOTAL_COM_IPI;
	cLinha 	+= "VL_ICMS;ALIQ_ICMS;TOTAL_COM_ICMS"
	cLinha 	+= "ICMS_RET;ISS;COFINS;PIS;FRETE;TOT_LIQ;MC;MC_%;"
	cLinha 	+= "CUSTO;CUSTO1_UNIT;CUSTO1_TOTAL;CUSTO2_C_IMP;"
	cLinha 	+= "CUSTO3;TOTAL;TAXA;NFEORI;"    */
    //INFORMACOES SOBRE AS NOTAS
    cLinha     := QRY1->FILIAL 			+";"+ QRY1->NOTA 			+";"+ QRY1->SERIE 	+";"+ QRY1->NUM_PEDIDO	+";"
    cLinha     += DTOC(QRY1->DT_IMPUT) +";"+ DTOC(QRY1->EMISSAO)	+";"+ QRY1->ARMAZEM	+";"+ QRY1->FORN 		+";"  
    cLinha     += QRY1->LOJA			+";"+ cNomeCliFor			+";"+ cMunCliFor	+";"+ cEstCliFor		+";"
    cLinha     += cCCusto				+";"+ cConContabil			+";"+ cNatCliFor	+";"+ QRY1->NUM_PEDIDO	+";"	
    cLinha     += QRY1->CFOP			+";"+ QRY1->TES				+";"+ cCondPagto +" - "	+ cDescPagto 		+";"
    cLinha     += QRY1->ITEM			+";"+ QRY1->PRODUTO			+";"+ cDescriProd	+";"+ cFabric			+";"
    //INFORMACOES SOBRE OS VALORERS
    cLinha     += Transform(QRY1->QUANTIDADE			,"@E 9,999,999,999.99")		+";"	
    cLinha     += transform(QRY1->VL_UNITARIO 			,"@E 9,999,999,999.9999")	+";"
    cLinha     += Transform(QRY1->DESC1					,"@E 9,999,999,999.99 %")	+";"
    cLinha     += Transform(QRY1->VAL_DESC				,"@E 9,999,999,999.99")		+';'    
    cLinha     += Transform(QRY1->TOTAL_SEM_IMPOSTOS 	,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->VL_IPI				,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->ALIQUOTA_IPI			,"@E 9,999,999,999.99 %")	+";"    
	cLinha     += Transform(QRY1->TOTAL_COM_IPI			,"@E 9,999,999,999.99")		+";"    
    cLinha     += Transform(QRY1->VL_ICMS				,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->ALIQUOTA_ICMS 		,"@E 9,999,999,999.99 %")	+";"
	cLinha     += Transform(QRY1->TOTAL_COM_ICMS		,"@E 9,999,999,999.99")		+";"        
    cLinha     += Transform(QRY1->ICMSRET				,"@E 9,999,999,999.99")		+";"    
    cLinha     += Transform(QRY1->ISS					,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->COFINS				,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->PIS					,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->FRETE					,"@E 9,999,999,999.99")		+';'
    cLinha     += Transform(QRY1->TOT_LIQ				,"@E 9,999,999,999.99")		+';'        
    cLinha     += Transform(QRY1->MC					,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->MC_PERCENT * 100 		,"@E 99,999.999999%")		+";"
    cLinha     += Transform(QRY1->CUSTO					,"@E 9,999,999,999.99")		+";"
    //VALORES A ENCONTRAR
    cLinha     += Transform(nCusult  					,"@E 9,999,999,999.99")		+";" //ULTIMO CUSTO UNITARIO
    cLinha     += Transform(nCusult * QRY1->QUANTIDADE	,"@E 9,999,999,999.99")		+";" //ULTIMO CUSTO TOTAL
    cLinha     += Transform(nCusreps 					,"@E 9,999,999,999.99")		+";" //ULTIMO CUSTO C/ IMPOSTOS
    cLinha     += Transform(nCustq 						,"@E 9,999,999,999.99")		+";" //ULTIMO CUSTO TABELA Z10
    cLinha     += Transform(nTotBruto					,"@E 9,999,999,999.99")		+";"
    cLinha     += Transform(QRY1->TOTAL					,"@E 9,999,999,999.99")		+";"

    cLinha     += transform(nTaxa 						,"@E 9,999.99999")			+';'
    cLinha     += QRY1->NFEORI	+";"
    
    fWrite(nHandle, cLinha  + cCrLf)
    
    QRY1->(DBSKIP())
    IncProc()
Enddo

//FECHA ARQUIVO
fClose(nHandle)

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
Return


Static Function ultcusto(_cprod)

IF Select("QRY2") <> 0 
	DbSelectArea("QRY2")
	DbCloseArea()
Endif

cQuery2 := " SELECT TOP 1 D1_COD, "
cQuery2 += "       D1_CUSTO / D1_QUANT 'ULCUST',  "
cQuery2 += "       D1_DTDIGIT, 
cQuery2 += "       D1_VUNIT - (D1_VUNIT * 0.0925) - SD1.D1_VALICM/SD1.D1_QUANT 'CUSTOREPOS' "
cQuery2 += " FROM " +Retsqlname ("SD1") + " SD1 (NOLOCK) "                        
cQuery2 += " WHERE SD1.D1_COD  =  '"+(_cprod)+"' "
cQuery2 += "  AND  SD1.D1_CF IN ('1102','1101','1403','1202','2202','3101','1411','2411') "  
cQuery2 += "  AND  SD1.D1_QUANT > 0 "  
cQuery2 += "  AND  SD1.D_E_L_E_T_=''     "
cQuery2 += " ORDER BY D1_DTDIGIT DESC, R_E_C_N_O_ DESC "

TCQUERY cQuery2 NEW ALIAS "QRY2"
           
IF Select("QRY2") <> 0 
	nCusult  := QRY2->ULCUST
	nCusreps := QRY2->CUSTOREPOS
Endif                                    	

QRY2->(DbCloseArea())

return(nCusult,nCusreps)
                               

Static Function u_custoq2 (_cprod)

IF Select("QRY3") <> 0 
	DbSelectArea("QRY3")
	DbCloseArea()
Endif

_cquery := " SELECT TOP 1 Z10.Z10_COD,Z10.Z10_VALCUS 'CUSTOQ' "
_cquery += " FROM " +Retsqlname ("Z10") + " Z10 (NOLOCK) "
_cquery += " WHERE  Z10.D_E_L_E_T_=''   "               
_cquery += "    AND Z10.Z10_COD   = '"+(_cprod)+"' "
_cquery += " ORDER BY Z10_DTIMPU  DESC, R_E_C_N_O_ DESC  "
                                                               
TCQUERY _cquery NEW ALIAS "QRY3"
           
IF Select("QRY3") <> 0 
	nCustq  := QRY3->CUSTOQ
Endif                                    	

QRY3->(DbCloseArea()) 

return(nCustq)