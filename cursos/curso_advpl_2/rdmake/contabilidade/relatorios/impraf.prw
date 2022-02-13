#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPRAF    บAutor  ณMicrosiga           บ Data ณ  06/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PROGRAMA DE GERACAO IMPOSTO EM EXCELL  SEGUINDO MODELO     บฑฑ
ฑฑบ          ณ PLANILHA DA CONTABILIDADE                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                  
User Function IMPRAF()   



PRIVATE cPerg	 :="RAF001"     

u_GerA0003(ProcName())

ValidPerg(cPerg) 

if ! Pergunte(cPerg,.T.)
 Return()
Endif


Processa( { ||relgerpri() } ) 
Return .t.

return .T.

Static Function relgerpri()


Local cQry1 :=""
Local cQuery :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local nTotFAT:=0
Local nTotFATLIQ :=0
Local nTotMC     :=0
Local nTotIPI    :=0
Local nTotISS    :=0
Local nTotCUSTO  :=0
Local nTotICMS   :=0
Local nTotPIS    :=0
Local nTotCOFINS :=0
Local nTotMCPER  :=0                    
Local nTotRetIcms :=0
Local nTotFrete   :=0
Local nTotDescon   :=0                                                                
Local nTotBruto    := 0 
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
//dbSelectArea(_sAlias)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)


                              //atualizado fonte Luiz Ferreira 08/09/2008
//cLinha := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
//fWrite(nHandle, cLinha  + cCrLf)

If MV_PAR03 = 2 // sintetico
   cLinha := "C.CUSTO;ARMAZEM;CFOP;FATURAMENTO;ICMS;ICMS RETIDO;FRETE;IPI;ISS;PIS;COFINS;CUSTO;FRETE;DESCONTO;TES"
Else
   cLinha := "FILIAL;COD_PROD;DESCRI;FABRIC;QTDE;PEDIDO_NUM;NF_DOC;CLIENTE;NOME;C.CUSTO;ARMAZEM;CFOP;FAT;FAT_LIQ;MC;MC_%;IPI;ISS;CUSTO;PIS;COFINS;ICMS;ICMS RETIDO;FRETE;DESCONTO;VALOR BRUTO;REPRESENTANTE;TES"
Endif      
   
   
fWrite(nHandle, cLinha  + cCrLf)


IF Select("QRY2") <> 0 
DbSelectArea("QRY2")
DbCloseArea()
Endif


IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif

IF MV_PAR03 == 2 //SINTETICO

	cQuery := " SELECT D2_CCUSTO AS CCUSTO,D2_LOCAL AS ARMAZEM, D2_CF AS CFOP,D2_TES AS TES,SUM(D2_TOTAL+D2_VALIPI) AS FAT,SUM(D2_VALICM) AS ICMS,SUM(D2_ICMSRET) AS ICMSRET,SUM(D2_VALFRE) AS FRETE,SUM(D2_VALIPI) AS IPI,"+CRLF
	//cQuery += " SUM(D2_VALISS) AS ISS,SUM(D2_VALIMP6) AS PIS,SUM(D2_VALIMP5) AS COFINS,SUM(D2_CUSTO1) AS CUSTO, SUM(D2_DESCON) AS DESCON, SUM(D2_VALBRUT + D2_VALIPI) AS VALBRUTO "+CRLF CLAUDIA 03/02/2010 - DENILZA RECLAMOU QUE O IPI ESTAVA SOMANDO 2 X NO VALOR BRUTO DO SD2
	cQuery += " SUM(D2_VALISS) AS ISS,SUM(D2_VALIMP6) AS PIS,SUM(D2_VALIMP5) AS COFINS,SUM(D2_CUSTO1) AS CUSTO, SUM(D2_DESCON) AS DESCON, SUM(D2_VALBRUT ) AS VALBRUTO "+CRLF
	cQuery += " FROM "+ RetsqlName("SD2")+" (nolock) "+CRLF
	cQuery += " WHERE D2_CF IN ('5933', '6933', '5124', '5102', '5106', '6102', '6106', '6108', '6110','5910','6910','5104','5405','6108','6401','7949','6405','5401','6401','5403','5403','6403') "+CRLF
	cQuery += " AND D_E_L_E_T_=''"+CRLF
	cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	cquery += " GROUP BY D2_CCUSTO,D2_LOCAL,D2_CF,D2_TES" + CRLF
	Cquery += " ORDER BY D2_CCUSTO,D2_LOCAL,D2_CF" 
	//memowrite('D:\abc\QSLK.sql',cQuery) 
	TCQUERY cQuery NEW ALIAS "QRY1"
	                                  
	
	
	cQuery1 := " SELECT D1_CC AS CCUSTO,D1_LOCAL AS ARMAZEM,  D1_CF AS CFOP,D1_TES AS TESDEV,-1*SUM(D1_TOTAL+D1_VALIPI + D1_VALFRE  - D1_VALICM  -  D1_VALIPI - D1_VALISS - D1_VALIMP6 - D1_VALIMP5 ) AS DEV,-1*SUM(D1_VALICM) AS DEVICMS,-1 *SUM(D1_ICMSRET) AS DEVICMSRET,-1* SUM(D1_VALFRE) AS DEVFRETE,-1* SUM(D1_VALIPI) AS DEVIPI,"+CRLF
	cQuery1 += " -1*SUM(D1_VALISS) AS DEVISS,-1*SUM(D1_VALIMP6) AS DEVPIS,-1*SUM(D1_VALIMP5) AS DEVCOFINS,-1*SUM(D1_CUSTO) AS CUSTO, -1 * SUM(D1_VALDESC) AS VALDESC , SUM(D1_TOTAL + D1_VALIPI) AS DEVBRUTO " +CRLF
	cQuery1 += "FROM "+ RetsqlName("SD1")+ " (nolock) "+CRLF
	cQuery1 += "WHERE D1_CF IN ('1202','2202','2203','1411','2411') "+CRLF
	cQuery1 += "AND D_E_L_E_T_=''"+CRLF
	cQuery1 += "AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	cquery1 += "GROUP BY D1_CC,D1_LOCAL,D1_CF,D1_TES" + CRLF
	Cquery1 += "ORDER BY D1_CC,D1_LOCAL,D1_CF,D1_TES"                
	//memowrite('D:\abc\QSLK1.sql',cQuery) 
	TCQUERY cQuery1 NEW ALIAS "QRY2"
	                
ELSE //ANALITICO
cQuery1 :=  " SELECT DISTINCT "
cQuery1 +=  " D2_FILIAL AS 'FILIAL',D2_COD AS 'COD_PROD',C6_DESCRI AS 'DESCRI', B1_FABRIC AS 'FABRIC',SUM(D2_QUANT) AS 'QTDE', (C6_NUM) AS 'PEDIDO_NUM',D2_DOC AS 'NF_DOC',D2_CLIENTE AS 'CLIENTE',  "
cQuery1 +=  " A1_NOME AS 'NOME', D2_CCUSTO AS 'CCUSTO', D2_LOCAL AS 'ARMAZEM', D2_TES AS 'TES' , D2_CF AS 'CFOP', "
//cQuery1 +=  " SUM(D2_TOTAL + D2_VALIPI) AS 'FAT', (SUM(D2_TOTAL + D2_VALIPI + D2_VALFRE) - SUM(D2_VALICM) - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - "
//cQuery1 +=  " SUM(D2_VALISS) - SUM(D2_VALIPI) ) AS FAT_LIQ,  "
cQuery1 +=  " SUM(D2_TOTAL + D2_VALIPI) AS 'FAT', (SUM(D2_VALBRU + D2_VALFRE) - SUM(D2_VALICM) - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - "
cQuery1 +=  " SUM(D2_VALISS) - SUM(D2_VALIPI) ) AS FAT_LIQ,  "
cQuery1 +=  " (((SUM(D2_TOTAL + D2_VALIPI) - SUM(D2_VALICM) - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - SUM(D2_VALISS) - SUM(D2_VALIPI)) - SUM(D2_CUSTO1))) AS MC, (((SUM(D2_TOTAL + D2_VALIPI) -  "
cQuery1 +=  " SUM(D2_VALICM) - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - SUM(D2_VALISS) - SUM(D2_VALIPI)) -  "
cQuery1 +=  " SUM(D2_CUSTO1)) / (SUM(D2_TOTAL - D2_VALIPI) - SUM(D2_VALICM) - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - "
cQuery1 +=  " SUM(D2_VALISS) - SUM(D2_VALIPI))) AS 'MC_PERCENT', SUM(D2_VALIPI) AS 'IPI', SUM(D2_VALISS) AS 'ISS', SUM(D2_CUSTO1) AS 'CUSTO',  "
//cQuery1 +=  " SUM(D2_VALIMP6) AS PIS, SUM(D2_VALIMP5) AS COFINS, SUM(D2_VALICM) AS ICMS, SUM(D2_ICMSRET) AS  ICMSRET , SUM(D2_VALFRE) AS FRETE, SUM(D2_DESCON) AS DESCON, SUM(D2_VALBRUT + D2_VALIPI) AS VALBRUTO, A3_NOME AS 'REPRESENTANTE' " CLAUDIA 03/02/2010 - DENILZA RECLAMOU QUE O IPI ESTAVA SOMANDO 2 X NO VALOR BRUTO DO SD2
cQuery1 +=  " SUM(D2_VALIMP6) AS PIS, SUM(D2_VALIMP5) AS COFINS, SUM(D2_VALICM) AS ICMS, SUM(D2_ICMSRET) AS  ICMSRET , SUM(D2_VALFRE) AS FRETE, SUM(D2_DESCON) AS DESCON, SUM(D2_VALBRUT ) AS VALBRUTO, A3_NOME AS 'REPRESENTANTE' "
cQuery1 +=  " FROM " +Retsqlname("SD2") +" SD2 (nolock)  "
cQuery1 +=  " INNER JOIN (SELECT * FROM " +Retsqlname ("SA1") + " SA1 (nolock) WHERE D_E_L_E_T_ = '') AS SA1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA "
cQuery1 +=  " LEFT  JOIN (SELECT * FROM  " +RetsqlName ("SC6") + " SC6 (nolock) WHERE D_E_L_E_T_ = '') AS SC6 ON C6_NUM = D2_PEDIDO AND D2_FILIAL = C6_FILIAL AND C6_CLI = D2_CLIENTE AND C6_PRODUTO = D2_COD AND C6_LOJA = D2_LOJA AND C6_ITEM = D2_ITEMPV  "
cQuery1 +=  " LEFT  JOIN (SELECT * FROM  " +RetsqlName ("SA3") + " SA3 (nolock) WHERE D_E_L_E_T_ = '') AS SA3 ON A1_VEND = A3_COD "
cQuery1 +=  " INNER JOIN (SELECT * FROM " +RetsqlName ("SB1")  +" SB1 (nolock) WHERE SB1.D_E_L_E_T_ = '') AS SB1 ON B1_COD = D2_COD "
cQuery1 +=	" WHERE  D2_CF IN ('5933', '6933', '5124', '5102', '5106', '6102', '6106', '6108', '6110','5910','6910','5104','5405','6108','6401','7949','6405','5401','6401','5403','6403') AND D2_EMISSAO BETWEEN '" +DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND SD2.D_E_L_E_T_ = '' "
cQuery1 +=  " GROUP BY D2_CCUSTO, D2_LOCAL, D2_TES, D2_CF, D2_COD, D2_CLIENTE, SA1.A1_NOME, SA3.A3_NOME, D2_FILIAL, C6_DESCRI, SC6.C6_NUM ,D2_DOC,SB1.B1_FABRIC,D2_COD "
cQuery1 +=  " UNION ALL "
cQuery1 +=  " SELECT DISTINCT "
cQuery1 +=  " D1_FILIAL AS 'FILIAL', D1_COD AS 'COD_PROD',B1_DESC AS 'DESCRI',B1_FABRIC AS 'FABRIC', D1_QUANT AS 'QTDE', '0.00' AS 'PEDIDO_NUM',D1_DOC AS 'NF_DOC',D1_FORNECE AS 'FORN', "
cQuery1 +=  " A1_NOME AS 'NOME', D1_CC AS 'CCUSTO', D1_LOCAL AS 'ARMAZEM' , D1_TES AS 'TESDEV', D1_CF AS 'CFOP', "
cQuery1 +=  "  -1* SUM(D1_TOTAL + D1_VALIPI) AS 'DEV',  "
cQuery1 +=  " (-1* SUM(D1_TOTAL + D1_VALIPI+ D1_VALFRE  - D1_VALICM  -  D1_VALIPI - D1_VALISS - D1_VALIMP6 - D1_VALIMP5 )) AS DEV_LIQ, "
cQuery1 +=  " (((-1* SUM(D1_TOTAL - D1_VALIPI) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5)) + SUM(D1_CUSTO))) AS MC_DEV,  "
cQuery1 +=  " (((-1* SUM(D1_TOTAL - D1_VALIPI) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5)) + SUM(D1_CUSTO))/( SUM(D1_TOTAL - D1_VALIPI) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5))) AS 'MC_DEV_PERCET', "
cQuery1 +=  " -1* SUM(D1_VALIPI)  AS DEVIPI,  -1*  SUM(D1_VALISS) AS DEVISS, "
cQuery1 +=  " -1* SUM(D1_CUSTO) AS CUSTO,  -1* SUM(D1_VALIMP6) AS DEVPIS, -1* SUM(D1_VALIMP5) AS DEVCOFINS, -1* SUM(D1_VALICM) AS DEVICMS, -1* SUM(D1_ICMSRET)  AS DEVICMSRET ,-1* SUM(D1_VALFRE) AS DEVFRETE,-1*SUM(D1_VALDESC) AS VALDESC, -1*SUM(D1_TOTAL + D1_VALIPI) AS VALORTOTAL, '' AS 'REPRESENTANTE'  "
cQuery1 +=  " FROM " +RetsqlName("SD1") +" SD1 (nolock) "
cQuery1 +=  " INNER JOIN (SELECT * FROM " +RetsqlName ("SA1")  +" SA1 (nolock) WHERE SA1.D_E_L_E_T_ = '') AS SA1 ON A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA "
cQuery1 +=  " INNER JOIN (SELECT * FROM " +RetsqlName ("SB1")  +" SB1 (nolock) WHERE SB1.D_E_L_E_T_ = '') AS SB1 ON B1_COD = D1_COD "
cQuery1 +=  " WHERE D1_CF IN ('1202', '2202','2203','1411','2411') AND SD1.D_E_L_E_T_ = ''  AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "  "
cQuery1 +=  " GROUP BY D1_CC, D1_LOCAL, D1_COD,D1_TES,D1_CF, D1_FILIAL, D1_QUANT, D1_FORNECE, SB1.B1_DESC, SA1.A1_NOME,D1_DOC,SB1.B1_FABRIC "
//    memowrite('QSLK.sql',cQuery1) 
	TCQUERY cQuery1 NEW ALIAS "QRY1"
ENDIF

DBSELECTAREA("QRY1")
QRY1->(DBGOTOP())


 procregua(reccount())
	DO WHILE !QRY1->(EOF())
	    IF MV_PAR03 ==2 //SINTETICO
			// gravar apenas o ISS , siga grava o campo icms com o mesmo conteudo do ISS
			If Alltrim(QRY1->CFOP) = '5933' .or. Alltrim(QRY1->CFOP) = '6933'
	        nICMS:=0
	        else
	        nICMS:=QRY1->ICMS
	        Endif
			
			//cLinha := Transform(QRY1->FAT,"@E 9,999,999,999.99")+";"+QRY1->D2_CCUSTO+";"+QRY1->D2_CF+";"+Transform(nICMS,"@E 9,999,999,999.99")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")                                                                                                                                                                                                                                                                                                                                         
	          cLinha := QRY1->CCUSTO+";"+QRY1->ARMAZEM+";"+QRY1->CFOP+";"+Transform(QRY1->FAT,"@E 9,999,999,999.99")+";"+Transform(nICMS,"@E 9,999,999,999.99")+Transform(QRY1->ICMSRET,"@E 9,999,999,999.99")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")+";"+Transform(QRY1->CUSTO,"@E 9,999,999,999.99")+';'+Transform(QRY1->FRETE,"@E 9,999,999,999.99")+';'+Transform(QRY1->DESCON,"@E 9,999,999,999.99")+';'+Transform(QRY1->VALBRUTO,"@E 9,999,999,999.99")
        ELSE 
             cLinha := QRY1->FILIAL+";"+QRY1->COD_PROD+";"+QRY1->DESCRI+";"+QRY1->FABRIC+";"+Transform(QRY1->QTDE ,"@E 9,999,999,999.99")+";"+QRY1->PEDIDO_NUM+";"+QRY1->NF_DOC+";"+QRY1->CLIENTE+";"+QRY1->NOME+";"+QRY1->CCUSTO+";"+QRY1->ARMAZEM+";"+QRY1->CFOP+";"+Transform (QRY1->FAT ,"@E 9,999,999,999.99")+";"+Transform(QRY1->FAT_LIQ ,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC_PERCENT * 100 ,"@E 999.999999%")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->CUSTO,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")+";"+Transform(QRY1->ICMS,"@E 9,999,999,999.99")+";"+Transform(QRY1->ICMSRET,"@E 9,999,999,999.99")+";"+Transform(QRY1->FRETE,"@E 9,999,999,999.99")+';'+Transform(QRY1->DESCON,"@E 9,999,999,999.99")+';'+Transform(QRY1->VALBRUTO,"@E 9,999,999,999.99")+";"+QRY1->REPRESENTANTE+';'+QRY1->TES
            nTotFAT    += QRY1->FAT
			nTotFATLIQ += QRY1->FAT_LIQ
			nTotMC     += QRY1->MC
			nTotIPI    += QRY1->IPI
			nTotISS    += QRY1->ISS
			nTotCUSTO  += QRY1->CUSTO
			nTotICMS   += QRY1->ICMS
			nTotPIS    += QRY1->PIS
			nTotCOFINS += QRY1->COFINS 
		 	nTotRetIcms += QRY1->ICMSRET
		 	nTotFrete   += QRY1->Frete
		 	nTotDescon  += QRY1->Descon
		 	ntotBruto   += QRY1->VALBRUTO
        ENDIF
          fWrite(nHandle, cLinha  + cCrLf)
      QRY1->(DBSKIP())
 IncProc()
ENDDO

// DEVOLUวOES

IF MV_PAR03 == 2 //SINTETICO
DBSELECTAREA("QRY2")
QRY2->(DBGOTOP())

	DO WHILE !QRY2->(EOF())
 
		//cLinha1 := Transform(QRY2->DEV,"@E 9,999,999,999.99")+";"+QRY2->D1_CC+";"+QRY2->D1_CF+";"+Transform(QRY2->DEVICMS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVIPI,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVISS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVPIS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVCOFINS,"@E 9,999,999,999.99")
        //cLinha1 := QRY2->CCUSTO+";"+QRY2->ARMAZEM+";"+QRY2->CFOP+";"+Transform(QRY2->DEV,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVICMS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVIPI,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVISS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVCOFINS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVPIS,"@E 9,999,999,999.99")+";"+Transform(QRY2->CUSTO,"@E 9,999,999,999.99")	
          cLinha1 := QRY2->CCUSTO+";"+QRY2->ARMAZEM+";"+QRY2->CFOP+";"+Transform(QRY2->DEV,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVICMS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVICMSRET,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVFRETE,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVIPI,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVISS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVPIS,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVCOFINS,"@E 9,999,999,999.99")+";"+Transform(QRY2->CUSTO,"@E 9,999,999,999.99")+";"+Transform(QRY2->DEVFRETE,"@E 9,999,999,999.99")+';'+Transform(QRY2->VALDESC,"@E 9,999,999,999.99")+';'+QRY2->TESDEV
          fWrite(nHandle, cLinha1  + cCrLf)
	QRY2->(DBSKIP())
ENDDO
ELSE
            nTotMCPER := (nTotfatliq-nTotCusto)/(nTotfatliq)*100
            cLinha1 := ''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+Transform (nTotFat ,"@E 9,999,999,999.99")+";"+Transform(nTotFatliq,"@E 9,999,999,999.99")+";"+Transform(nTotMC,"@E 9,999,999,999.99")+";"+Transform(nTotMCPER,"@E 999.999999%")+";"+Transform(nTotIPI,"@E 9,999,999,999.99")+";"+Transform(nTotISS,"@E 9,999,999,999.99")+";"+Transform(nTotCUSTO,"@E 9,999,999,999.99")+";"+Transform(nTotPIS,"@E 9,999,999,999.99")+";"+Transform(nTotCOFINS,"@E 9,999,999,999.99")+";"+Transform(nTotICMS,"@E 9,999,999,999.99")+';'+Transform(nTOTRETICMS,"@E 9,999,999,999.99")+';'+Transform(nTOTFRETE,"@E 9,999,999,999.99")+';'+Transform(nTOTDESCON,"@E 9,999,999,999.99")+';'+Transform(nTOTBRUTO,"@E 9,999,999,999.99")
            fWrite(nHandle, cLinha1  + cCrLf)
ENDIF

fClose(nHandle)
//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
RETURN


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2			3			4						5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
//AAdd(aRegs,{cPerg,"03","Data Fechamento:    ",""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
//AAdd(aRegs,{cPerg,"02","Mostrar Lancamento: ",""				,""  			,"mv_ch2",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	"1-Sim"	,"1-Si"		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
     AAdd(aRegs,{cPerg,"03","Tipo do Relatorio: ",""				,""  			,"mv_ch3",	"N",   01       ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	"1-Analitico"	,"1-Analitico"		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
//AAdd(aRegs,{cPerg,"04","Lancamento On-line: ",""   				,""  			,"mv_ch4",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	"1-Sim"	,"1-Si"		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return


