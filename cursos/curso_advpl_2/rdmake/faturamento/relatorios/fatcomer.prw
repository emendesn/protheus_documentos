#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

/*
 *Programa  : FATCOM    
 *Autor     : Luiz Ferreira       
 *Data 		: 26/09/2008 
 *Desc.     : Faturamento Comercia Mostra a Rentabilidade do Produto
 *Uso       : FAT                                                        
*/

User Function FATCOM()
	Private nCusult  :=0
	Private nCusreps :=0
	Private cPerg	 :="FATCOR"
	Private _csrvapl := ALLTRIM(GetMV("MV_SERVAPL"))
	ValidPerg(cPerg)


u_GerA0003(ProcName())
	
	If ! Pergunte(cPerg,.T.)
		Return()
	EndIf
	
	Processa( { ||relgerpri() } )
Return .T.

/*
 *Programa  : relgerpri    
 *Autor     : Luiz Ferreira       
 *Data 		: 26/09/2008 
 */
Static Function relgerpri()
	Local cQry1 	 :=""
	Local cQuery 	 :=""
	Local cQry2 	 :=""
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
	Local nTotCusult :=0
	Local nTotCust2  :=0
	Local nTotCust2  :=0
	Local nTotCusre  :=0
	Local nTotCustq  :=0
	Local nTotRetIcms:=0
	Local nTotFrete  :=0
	Local nTotDescon :=0
	Local nTotBruto  :=0
	Local nTaxa      := 0
	Local _cArqTmp   := lower(AllTrim(__RELDIR)+cArquivo)
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
	
	&&Inclusão dos campos COD_TRANSP e NOME_TRANSP - Thomas Quintino Galvão - 06/08/12 - GLPI ID 7905
	cLinha := "FILIALxxxx;COD_PROD;DESCRI;FABRIC;QTDE;ITEM;PEDIDO_NUM;COD_TRANSP;NOME_TRANSP;ICMS;DT_IMPUT;NF_DOC;EMISSAO_NF;CLIENTE;NOME;CIDADE;UF;C.CUSTO;ARMAZEM;CFOP;PRVUNIT;FAT;FAT_LIQ;MC;MC_%;IPI;ISS;CUSTO;ULTCUSTO;ULTCSTOT;CUSTOREP;CUSTOQ;PIS;COFINS;R$_ICMS;ICMS RETIDO;FRETE;DESCONTO;VALOR BRUTO;REPRESENTANTE;PRAZO_PGTO;PRAZO_FAT;MOTIVO_DEV;NFEORI;MOEDA;TAXA;TES"
	
	fWrite(nHandle, cLinha  + cCrLf)
	DbSelectArea("SM2")
	DbSetOrder(1)
	
	If Select("QRY1") <> 0
		DbSelectArea("QRY1")
		DbCloseArea()
	EndIf

	&&Inclusão dos campos COD_TRANSP e NOME_TRANSP - Thomas Quintino Galvão - 06/08/12 - GLPI ID 7905
	cQuery1 := " SELECT DISTINCT  D2_FILIAL 'FILIAL',D2_COD 'COD_PROD',SB1.B1_DESC 'DESCRI',B1_FABRIC 'FABRIC' "
	//cQuery1 += "              ,SUM(D2_QUANT) 'QTDE'
	cQuery1 += "                ,D2_QUANT 'QTDE' , D2_ITEM 'ITEM'"
	cQuery1 += "                ,C6_NUM   'PEDIDO_NUM' "
	cQuery1 += "                ,ISNULL(C5_TRANSP,' ')  'COD_TRANSP', ISNULL(A4_NOME,' ') 'NOME_TRANSP' "
	cQuery1 += "                ,D2_PICM  'PICMS',C6_ENTREG 'DT_IMPUT' "
	cQuery1 += "                ,D2_DOC   'NF_DOC',D2_EMISSAO 'EMISSAO' "
	cQuery1 += "                ,D2_CLIENTE 'CLIENTE',A1_NOME 'NOME',SA1.A1_MUN 'CIDADE',SA1.A1_EST 'UF' "
	cQuery1 += "                ,D2_CCUSTO  'CCUSTO',D2_LOCAL 'ARMAZEM',D2_TES 'TES', D2_CF 'CFOP' "
	cQuery1 += "                ,MAX(D2_PRCVEN)'PRCVEN' "
	cQuery1 += "                ,(D2_TOTAL + D2_VALIPI)'FAT' "
	//cQuery1 += "              ,SUM(D2_TOTAL + D2_VALIPI)'FAT' "
	cQuery1 += "                ,(SUM((D2_TOTAL - D2_DESCON + D2_VALIPI))   - CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 Else SUM(D2_VALICM) END  - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - SUM(D2_VALISS) - SUM(D2_VALIPI)  + SUM(D2_VALFRE))  AS FAT_LIQ
	cQuery1 += "                ,(((SUM((D2_TOTAL - D2_DESCON + D2_VALIPI)) - CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 Else SUM(D2_VALICM) END  - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - SUM(D2_VALISS) - SUM(D2_VALIPI)) - SUM(D2_CUSTO1))) 'MC'
	cQuery1 += "                ,(((SUM((D2_TOTAL - D2_DESCON + D2_VALIPI)) - CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 Else SUM(D2_VALICM) END  - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) - SUM(D2_VALISS) - SUM(D2_VALIPI)) - SUM(D2_CUSTO1)) /  CASE WHEN (SUM(D2_TOTAL - D2_VALIPI) - CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 Else SUM(D2_VALICM) END - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) -  SUM(D2_VALISS) - SUM(D2_VALIPI)) <= 0 THEN 1 ELSE  (SUM(D2_TOTAL - D2_VALIPI) - CASE WHEN D2_CF IN ('5933','6933','7409') THEN 0.00 Else SUM(D2_VALICM) END - SUM(D2_VALIMP6) - SUM(D2_VALIMP5) -  SUM(D2_VALISS) - SUM(D2_VALIPI)) END ) 'MC_PERCENT'  "
	cQuery1 += "                ,SUM(D2_VALIPI) AS 'IPI', SUM(D2_VALISS) AS 'ISS', SUM(D2_CUSTO1) AS 'CUSTO', SUM(D2_VALIMP6) AS PIS, SUM(D2_VALIMP5) AS COFINS, SUM(D2_VALICM) AS ICMS , ISNULL(A3_NOME,'/') 'REPRESENTANTE',SE4.E4_DESCRI AS 'PGTO'
	cQuery1 += "                ,DATEDIfF([DAY] ,C6_ENTREG,D2_EMISSAO)'PRAZO_FAT' , '' 'MOTIVO_DEV','' 'NFEORI'"
	//cQuery1 += "				, SUM(D2_ICMSRET) ICMSRET ,SUM(D2_VALFRE) FRETE, SUM(D2_DESCON) DESCON ,  SUM(D2_VALBRUT + D2_VALIPI) AS VALBRUTO " CLAUDIA 03/02/2010 - DENILZA RECLAMOU QUE O IPI ESTAVA SOMANDO 2 X NO VALOR BRUTO DO SD2
	cQuery1 += "				, SUM(D2_ICMSRET) ICMSRET ,SUM(D2_VALFRE) FRETE, SUM(D2_DESCON) DESCON ,  SUM(D2_VALBRUT) AS VALBRUTO "
	cQuery1 += " FROM " +Retsqlname ("SD2") + " SD2 (NOLOCK) "
	cQuery1 += "   		LEFT  JOIN " +Retsqlname ("SA1") + " SA1 (NOLOCK) ON SA1.D_E_L_E_T_='' AND SA1.A1_FILIAL='"+xfilial("SA1")+"' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA  "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SC6") + " SC6 (NOLOCK) ON SC6.D_E_L_E_T_='' AND SC6.C6_FILIAL='"+xfilial("SC6")+"' AND SC6.C6_NUM = SD2.D2_PEDIDO AND SD2.D2_FILIAL = SC6.C6_FILIAL  AND SC6.C6_CLI = SD2.D2_CLIENTE AND SC6.C6_PRODUTO = SD2.D2_COD AND SC6.C6_LOJA = SD2.D2_LOJA AND SC6.C6_ITEM = SD2.D2_ITEMPV "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SM2") + " SM2 (NOLOCK) ON SM2.D_E_L_E_T_='' AND SM2.M2_DATA = SD2.D2_EMISSAO "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SB1") + " SB1 (NOLOCK) ON SB1.D_E_L_E_T_='' AND SB1.B1_FILIAL='"+xfilial("SB1")+"' AND SB1.B1_COD = SD2.D2_COD "
	cQuery1 += " 		INNER JOIN " +Retsqlname ("SF2") + " SF2 (NOLOCK) ON SF2.D_E_L_E_T_='' AND SF2.F2_FILIAL='"+xfilial("SF2")+"' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE=SD2.D2_SERIE AND SF2.F2_CLIENTE=SD2.D2_CLIENTE AND SF2.F2_LOJA=SD2.D2_LOJA AND   SF2.F2_EMISSAO=SD2.D2_EMISSAO "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SA3") + " SA3 (NOLOCK) ON SF2.D_E_L_E_T_='' AND SA3.A3_FILIAL='"+xfilial("SA3")+"' AND SF2.F2_VEND1 = SA3.A3_COD "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SE4") + " SE4 (NOLOCK) ON SE4.D_E_L_E_T_='' AND SE4.E4_FILIAL='"+xfilial("SE4")+"' AND SE4.E4_CODIGO =SF2.F2_COND "
	cQuery1 += "        LEFT  JOIN " +Retsqlname ("SC5") + " SC5 (NOLOCK) ON SC5.D_E_L_E_T_='' AND SC5.C5_FILIAL='"+xfilial("SC5")+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND  SC5.C5_TIPO NOT IN ('C','I','P') "
	cQuery1 += "        LEFT  JOIN " +Retsqlname ("SA4") + " SA4 (NOLOCK) ON SA4.D_E_L_E_T_='' AND SA4.A4_FILIAL='"+xfilial("SA4")+"' AND SA4.A4_COD = SC5.C5_TRANSP "
//	cQuery1 += " WHERE  SD2.D2_FILIAL='"+xfilial("SD2")+"' AND SD2.D2_CF IN ('5922','5933', '6933', '5124','5102','5106', '6102', '6106', '6108', '6110','6910','5202','5405','5411','7949','6405','5401','6401','5403','6403','7102', '6119','5910')  " // 1. Inclusao da Cfop 6119 em 01/10/10  - 2. |Thomas Galvão|-> 5910 em 08/09/2012 - GLPI ID 8189
  	cQuery1 += " WHERE  SD2.D2_FILIAL='"+xfilial("SD2")+"' AND SD2.D2_CF IN ('5922','5933', '6933', '5124','5102','5106', '6102', '6106', '6108', '6110','6910','5405','7949','6405','5401','6401','5403','6403','7102', '6119')  " // Alterado Uiran Almeida - retirado CFOP 5202 e 5910 Chamado - ID 15627 e ID 15813  - Uiran Almeida - retirado CFOP '5411' Chamado ID - ????
	cQuery1 += "   AND  SD2.D2_COD BETWEEN     '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
	cQuery1 += "   AND  SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
	cQuery1 += "   AND  SD2.D2_DOC  BETWEEN    '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
	//cQuery1 += " AND  SB1.B1_TIPO BETWEEN    '"+(MV_PAR07)+"' "
	//cQuery1 += " AND  SB1.B1_FABRIC BETWEEN  '"+(MV_PAR08)+"' "
	//cQuery1 += "   AND  SC5.C5_TIPO NOT IN ('C','I','P') "
	cQuery1 += "   AND  SD2.D_E_L_E_T_ = '' "
	//cQuery1 += " GROUP BY SD2.D2_CCUSTO, SD2.D2_LOCAL, SD2.D2_CF, SD2.D2_COD, SD2.D2_CLIENTE, SA1.A1_NOME,SA3.A3_NOME, SD2.D2_FILIAL, SC6.C6_DESCRI, SC6.C6_NUM ,SD2.D2_DOC,SB1.B1_FABRIC,SD2.D2_COD,SA1.A1_MUN,SA1.A1_EST,SD2.D2_EMISSAO,SE4.E4_DESCRI,SC6.C6_ENTREG,SD2.D2_PICM  "
	cQuery1 += " GROUP BY SD2.D2_CCUSTO, SD2.D2_LOCAL,SD2.D2_TES,SD2.D2_CF, SD2.D2_COD, SD2.D2_CLIENTE, SA1.A1_NOME,SA3.A3_NOME, SD2.D2_FILIAL, SB1.B1_DESC , SC6.C6_NUM ,SC5.C5_TRANSP, SA4.A4_NOME, SD2.D2_DOC,SB1.B1_FABRIC,SD2.D2_COD,SA1.A1_MUN,SA1.A1_EST,SD2.D2_EMISSAO,SE4.E4_DESCRI,SC6.C6_ENTREG,SD2.D2_PICM,SD2.D2_QUANT,(D2_TOTAL + D2_VALIPI),D2_ITEM "
	cQuery1 += " UNION ALL "
	cQuery1 += " SELECT DISTINCT  D1_FILIAL 'FILIAL', D1_COD AS 'COD_PROD',B1_DESC AS 'DESCRI',B1_FABRIC AS 'FABRIC' "
	cQuery1 += "                ,D1_QUANT  'QTDE', '' ,'' 'PEDIDO_NUM', '' 'COD_TRANSP', '' 'NOME_TRANSP' "
	cQuery1 += "                ,D1_PICM 'PICMS','' AS 'DT_IMPUT' "
	cQuery1 += "                ,D1_DOC AS 'NF_DOC',D1_EMISSAO AS 'EMISSAO' "
	cQuery1 += "                ,D1_FORNECE AS 'FORN',  A1_NOME AS 'NOME',SA1.A1_MUN AS 'CIDADE',SA1.A1_EST AS 'UF' "
	cQuery1 += "                ,D1_CC AS 'CCUSTO', D1_LOCAL AS 'ARMAZEM',D1_TES AS 'TESDEV', D1_CF AS 'CFOP'"
	cQuery1 += "                ,(-1* D1_VUNIT),  -1* SUM(D1_TOTAL - D1_VALDESC + D1_VALIPI) AS 'DEV', (-1 * SUM(D1_TOTAL + D1_VALIPI + D1_VALFRE  - D1_VALICM  -  D1_VALIPI - D1_VALISS - D1_VALIMP6 - D1_VALIMP5  )) 'DEV_LIQ' "
	cQuery1 += "                ,(((-1* SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5)) + SUM(D1_CUSTO))) AS MC_DEV,   (((-1* SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5)) + SUM(D1_CUSTO))/( SUM((D1_TOTAL - D1_VALDESC + D1_VALIPI)) +  SUM(D1_VALICM) +  SUM(D1_VALIPI) +  SUM(D1_VALISS) +  SUM(D1_VALIMP6) +  SUM(D1_VALIMP5))) 'MC_DEV_PERCET' "
	cQuery1 += "                ,-1* SUM(D1_VALIPI)  AS DEVIPI,  -1*  SUM(D1_VALISS) AS DEVISS,  -1* SUM(D1_CUSTO) AS CUSTO,  -1* SUM(D1_VALIMP6)  AS DEVPIS, -1* SUM(D1_VALIMP5) AS DEVCOFINS, -1* SUM(D1_VALICM) 'DEVICMS' "
	cQuery1 += "                ,ISNULL(A3_NOME,'/') 'REPRESENTANTE','' 'PGTO','' 'PRAZO_FAT',MAX(X5_DESCRI) AS 'MOTIVO_DEV',D1_NFORI 'NFEORI', -1* SUM(D1_ICMSRET) 'DEVICMSRET' , -1* SUM(D1_VALFRE) DEVFFETE, -1* SUM(D1_VALDESC) DEVDESC,(-1 * SUM(D1_TOTAL + D1_VALIPI+D1_ICMSRET+D1_VALFRE)) DEVTOTAL  "
	cQuery1 += " FROM " +Retsqlname ("SD1") + " SD1  (NOLOCK) "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SA1") + " SA1 (NOLOCK) ON SA1.A1_FILIAL='"+xfilial("SA1")+"' AND SA1.D_E_L_E_T_='' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SB1") + " SB1 (NOLOCK) ON SB1.B1_FILIAL='"+xfilial("SB1")+"' AND SB1.D_E_L_E_T_='' AND SB1.B1_COD = SD1.D1_COD "
	cQuery1 += " 		INNER JOIN " +Retsqlname ("SF1") + " SF1 (NOLOCK) ON SF1.F1_FILIAL='"+xfilial("SF1")+"' AND SF1.D_E_L_E_T_='' AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE=SD1.D1_SERIE AND SF1.F1_FORNECE=SD1.D1_FORNECE AND SF1.F1_LOJA=SD1.D1_LOJA AND  SF1.F1_EMISSAO=SD1.D1_EMISSAO  "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SE4") + " SE4 (NOLOCK) ON SE4.E4_FILIAL='"+xfilial("SE4")+"' AND SE4.D_E_L_E_T_='' AND SE4.E4_CODIGO = SF1.F1_COND "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SA3") + " SA3 (NOLOCK) ON SA3.A3_FILIAL='"+xfilial("SA3")+"' AND SA3.D_E_L_E_T_='' AND SA1.A1_VEND = SA3.A3_COD "
	cQuery1 += " 		LEFT  JOIN " +Retsqlname ("SX5") + " SX5 (NOLOCK) ON SX5.X5_FILIAL='"+xfilial("SX5")+"' AND SX5.D_E_L_E_T_= ''AND SX5.X5_TABELA='ZL' AND SX5.X5_CHAVE=SD1.D1_MOTDEVO  "
	cQuery1 += " WHERE  SD1.D1_FILIAL='"+xfilial("SD1")+"' AND SD1.D1_CF IN ('1202', '2202','2203','1411','2411') "
	cQuery1 += "   AND  SD1.D1_COD BETWEEN     '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
	cQuery1 += "   AND  SD1.D1_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
	cQuery1 += "   AND  SD1.D1_DOC  BETWEEN    '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
	//cQuery1 += " AND  SB1.B1_TIPO BETWEEN    '"+(MV_PAR07)+"' "
	//cQuery1 += " AND  SB1.B1_FABRIC BETWEEN  '"+(MV_PAR08)+"' "
	cQuery1 += "   AND  SD1.D_E_L_E_T_ = ''  "
	cQuery1 += " GROUP BY SD1.D1_CC, SD1.D1_LOCAL, SD1.D1_COD,SD1.D1_TES,SD1.D1_CF, SD1.D1_FILIAL, SD1.D1_QUANT, SD1.D1_FORNECE, SB1.B1_DESC, SA1.A1_NOME,SD1.D1_DOC,SB1.B1_FABRIC,SA1.A1_EST,SA1.A1_MUN,SD1.D1_EMISSAO,SD1.D1_VUNIT,SD1.D1_NFORI,SD1.D1_PICM,SA3.A3_NOME  "
	//cQuery1 += " OPTION(MAXDOP 2) "
	
	memowrite('fatcomer.txt',cQuery1)
	TCQUERY cQuery1 NEW ALIAS "QRY1"
	TcSetField("QRY1","DT_IMPUT","D")    //TRANFORMACAO DAS DATAS
	TcSetField("QRY1","EMISSAO","D")     //TRANFORMACAO DAS DATAS
			
	Procregua(RecCount())
	
	Do While !QRY1->(EoF())
		
		// gravar apenas o ISS , siga grava o campo icms com o mesmo conteudo do ISS
		If Alltrim(QRY1->CFOP) = '5933' .or. Alltrim(QRY1->CFOP) = '6933'
			nICMS:= 0
		Else
			nICMS:= QRY1->ICMS
		EndIf
		
		nCusult  :=0
		nCusreps :=0
		nCustq   :=0
		
		ultcusto  (QRY1->COD_PROD)     //BUSCA VALOR NA QUERY2      (Custo de Reposição e Custo Médio)
		u_custoq2 (QRY1->COD_PROD)     //BUSCA VALOR NA QUERY3      (CustoQ - Faturamento)
		
		If Alltrim(QRY1->CFOP) = '1202' .or. Alltrim(QRY1->CFOP) = '2202' .or. Alltrim(QRY1->CFOP) = '2203'  //Custo negativo no caso de Devolucao
			nCusult  = (-1 * nCusult)   //Caso de Devolução transforma os valores negativos
			nCusreps = (-1 * nCusreps)  //Caso de Devolução transforma os valores negativos
			nCustq   = (-1 * nCustq)	//Caso de Devolução transforma os valores negativos
		EndIf
		
		SC5->(DBSEEK(XFILIAL("SC5") + QRY1->PEDIDO_NUM))
		SM2->(DBSEEK(DTOS(SC5->C5_EMISSAO)))
		nTaxa :=SC5->C5_TXMOEDA
		If SC5->C5_MOEDA <> 1 .AND. (NTAXA = 1 .OR. NTAXA = 0 )
			If SC5->C5_MOEDA = 1
				nTaxa := 1
			ElseIf SC5->C5_MOEDA = 2
				nTaxa := SM2->M2_MOEDA2
			ElseIf SC5->C5_MOEDA = 3
				nTaxa := SM2->M2_MOEDA3
			ElseIf SC5->C5_MOEDA = 4
				nTaxa := SM2->M2_MOEDA4
			ElseIf SC5->C5_MOEDA = 5
				nTaxa := SM2->M2_MOEDA5
			ElseIf SC5->C5_MOEDA = 6
				nTaxa := SM2->M2_MOEDA6
			ElseIf  SC5->C5_MOEDA = 7
				nTaxa := SM2->M2_MOEDA7
			Else
				nTaxa := 0
			EndIf
		EndIf
		//            cLinha  := QRY1->FILIAL+";"+QRY1->COD_PROD+";"+QRY1->DESCRI+";"+QRY1->FABRIC+";"+Transform(QRY1->QTDE ,"@E 9,999,999,999.99")+";"+QRY1->ITEM+";"+QRY1->PEDIDO_NUM+";"+Transform(QRY1->PICMS ,"@E 9,999,999,999.99 %")+";"+DTOC(QRY1->DT_IMPUT)+";"+QRY1->NF_DOC+";"+DTOC(QRY1->EMISSAO)+";"+QRY1->CLIENTE+";"+QRY1->NOME+";"+QRY1->CIDADE+";"+QRY1->UF+";"+QRY1->CCUSTO+";"+QRY1->ARMAZEM+";"+QRY1->CFOP+";"+transform(QRY1->PRCVEN , "@E 9,999,999,999.9999")+";"+Transform (QRY1->FAT ,"@E 9,999,999,999.9999")+";"+Transform(QRY1->FAT_LIQ ,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC_PERCENT * 100 ,"@E 99,999.999999%")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->CUSTO,"@E 9,999,999,999.99")+";"+Transform(nCusult  ,"@E 9,999,999,999.99")+";"+Transform(nCusult * QRY1->QTDE,"@E 9,999,999,999.99")+";"+Transform(nCusreps ,"@E 9,999,999,999.99")+";"+Transform(nCustq ,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")+";"+IIf(QRY1->ISS=0,Transform(QRY1->ICMS,"@E 9,999,999,999.99","0"))+";"+Transform(QRY1->ICMSRET,"@E 9,999,999,999.99")+";"+Transform(QRY1->FRETE,"@E 9,999,999,999.99")+';'+Transform(QRY1->DESCON,"@E 9,999,999,999.99")+';'+Transform(QRY1->VALBRUTO,"@E 9,999,999,999.99")+';'+QRY1->REPRESENTANTE+";"+QRY1->PGTO+";"+transform(QRY1->PRAZO_FAT , "@ 9,999,999.999")+";"+QRY1->MOTIVO_DEV+";"+QRY1->NFEORI+';'+ALLTRIM(STR(SC5->C5_MOEDA))+';'+transform(nTaxa , "@E 9,999.99999")+';'+QRY1->TES
		cLinha  := QRY1->FILIAL+";"+QRY1->COD_PROD+";"+QRY1->DESCRI+";"+QRY1->FABRIC+";"+Transform(QRY1->QTDE ,"@E 9,999,999,999.99")+";"+QRY1->ITEM+";"+QRY1->PEDIDO_NUM+";"+QRY1->COD_TRANSP+";"+QRY1->NOME_TRANSP+";"+Transform(QRY1->PICMS ,"@E 9,999,999,999.99 %")+";"+DTOC(QRY1->DT_IMPUT)+";"+QRY1->NF_DOC+";"+DTOC(QRY1->EMISSAO)+";"+QRY1->CLIENTE+";"+QRY1->NOME+";"+QRY1->CIDADE+";"+QRY1->UF+";"+QRY1->CCUSTO+";"+QRY1->ARMAZEM+";"+QRY1->CFOP+";"+transform(QRY1->PRCVEN , "@E 9,999,999,999.9999")+";"+Transform (QRY1->FAT ,"@E 9,999,999,999.9999")+";"+Transform(QRY1->FAT_LIQ ,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC,"@E 9,999,999,999.99")+";"+Transform(QRY1->MC_PERCENT * 100 ,"@E 99,999.999999%")+";"+Transform(QRY1->IPI,"@E 9,999,999,999.99")+";"+Transform(QRY1->ISS,"@E 9,999,999,999.99")+";"+Transform(QRY1->CUSTO,"@E 9,999,999,999.99")+";"+Transform(nCusult  ,"@E 9,999,999,999.99")+";"+Transform(nCusult * QRY1->QTDE,"@E 9,999,999,999.99")+";"+Transform(nCusreps ,"@E 9,999,999,999.99")+";"+Transform(nCustq ,"@E 9,999,999,999.99")+";"+Transform(QRY1->PIS,"@E 9,999,999,999.99")+";"+Transform(QRY1->COFINS,"@E 9,999,999,999.99")+";"+IIf(QRY1->ISS=0,Transform(QRY1->ICMS,"@E 9,999,999,999.99"),"0")+";"+Transform(QRY1->ICMSRET,"@E 9,999,999,999.99")+";"+Transform(QRY1->FRETE,"@E 9,999,999,999.99")+';'+Transform(QRY1->DESCON,"@E 9,999,999,999.99")+';'+Transform(QRY1->VALBRUTO,"@E 9,999,999,999.99")+';'+QRY1->REPRESENTANTE+";"+QRY1->PGTO+";"+transform(QRY1->PRAZO_FAT , "@ 9,999,999.999")+";"+QRY1->MOTIVO_DEV+";"+QRY1->NFEORI+';'+ALLTRIM(STR(SC5->C5_MOEDA))+';'+transform(nTaxa , "@E 9,999.99999")+';'+QRY1->TES
		nTotFAT    += QRY1->FAT
		nTotFATLIQ += QRY1->FAT_LIQ
		nTotMC     += QRY1->MC
		nTotIPI    += QRY1->IPI
		nTotISS    += QRY1->ISS
		nTotCUSTO  += QRY1->CUSTO
		nTotICMS   += IIf(QRY1->ISS=0,QRY1->ICMS,0)
		nTotPIS    += QRY1->PIS
		nTotCOFINS += QRY1->COFINS
		nTotCusult += nCusult
		nTotCust2  +=(nCusult * QRY1->QTDE)
		nTotCusre  += nCusreps
		nTotCustq  += nCustq
		nTotRetIcms+= QRY1->ICMSRET
		nTotFrete  += QRY1->Frete
		nTotDescon += QRY1->Descon
		nTotBruto  += QRY1->VALBRUTO
		fWrite(nHandle, cLinha  + cCrLf)
		QRY1->(DbSkip())
		IncProc()
	EndDo
	nTotMCPER := (nTotfatliq-nTotCusto)/(nTotfatliq)*100
	cLinha1 := ''+";"+"''"+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+''+";"+'T O T A L'+";"+";"+Transform (nTotFat ,"@E 9,999,999,999.99")+";"+Transform(nTotFatliq,"@E 9,999,999,999.99")+";"+Transform(nTotMC,"@E 9,999,999,999.99")+";"+Transform(nTotMCPER,"@E 999.999999%")+";"+Transform(nTotIPI,"@E 9,999,999,999.99")+";"+Transform(nTotISS,"@E 9,999,999,999.99")+";"+Transform(nTotCUSTO,"@E 9,999,999,999.99")+";"+Transform(nTotCusult ,"@E 9,999,999,999.99")+";"+Transform(nTotCust2 ,"@E 9,999,999,999.99")+";"+Transform(nTotCusre ,"@E 9,999,999,999.99")+";"+Transform(nTotCustq,"@E 9,999,999,999.99")+";"+Transform(nTotPIS,"@E 9,999,999,999.99")+";"+Transform(nTotCOFINS,"@E 9,999,999,999.99")+";"+Transform(nTotICMS,"@E 9,999,999,999.99")+";"+Transform(nTotRETICMS,"@E 9,999,999,999.99")+";"+Transform(nTotFrete,"@E 9,999,999,999.99")+';'+Transform(nTotDescon,"@E 9,999,999,999.99")+';'+Transform(nTotBruto,"@E 9,999,999,999.99")+';'+''+";"+''+";"+''+";"+''+";"+''+';'+''+';'+''+';'+''
	fWrite(nHandle, cLinha1  + cCrLf)
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
Return
/*
 *Programa  : ValidPerg    
 *Autor     : Luiz Ferreira       
 *Data 		: 26/09/2008 
 */
Static Function ValidPerg()
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j	
	DbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
	//	2			3			4						5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
	AAdd(aRegs,{cPerg,"01","Considere Data De?  ",""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
	AAdd(aRegs,{cPerg,"02","Até a Data: ",""				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	""	,""		,	""		,"",		""		,  "",	""		,	""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
	//AAdd(aRegs,{cPerg,"03","Tipo do Relatorio: ",""				,""  			,"mv_ch3",	"N",   01       ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	"1-Analitico"	,"1-Analitico"		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
	//AAdd(aRegs,{cPerg,"04","Lancamento On-line: ",""   				,""  			,"mv_ch4",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	"1-Sim"	,"1-Si"		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
Return
/*
 *Programa  : ultcusto    
 *Autor     : Luiz Ferreira       
 *Data 		: 26/09/2008 
 */
Static Function ultcusto(_cprod)	
	If Select("QRY2") <> 0
		DbSelectArea("QRY2")
		DbCloseArea()
	EndIf
	
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
	
	//    memowrite('QSLK3.sql',cQuery2)
	TCQUERY cQuery2 NEW ALIAS "QRY2"
	
	If Select("QRY2") <> 0
		nCusult := QRY2->ULCUST
		nCusreps := QRY2->CUSTOREPOS
	EndIf	
	QRY2->(DbCloseArea())
Return(nCusult,nCusreps)
/*
 *Programa  : u_custoq2    
 *Autor     : Luiz Ferreira       
 *Data 		: 26/09/2008 
 */
Static Function u_custoq2 (_cprod)
	If Select("QRY3") <> 0
		DbSelectArea("QRY3")
		DbCloseArea()
	EndIf	
	_cquery := " SELECT TOP 1 Z10.Z10_COD,Z10.Z10_VALCUS 'CUSTOQ' "
	_cquery += " FROM " +Retsqlname ("Z10") + " Z10 (NOLOCK) "
	_cquery += " WHERE  Z10.D_E_L_E_T_=''   "
	_cquery += "    AND Z10.Z10_COD   = '"+(_cprod)+"' "
	_cquery += " ORDER BY Z10_DTIMPU  DESC, R_E_C_N_O_ DESC  "
	
	// memowrite('custoq.sql',_cquery)
	TCQUERY _cquery NEW ALIAS "QRY3"
	
	If Select("QRY3") <> 0
		nCustq  := QRY3->CUSTOQ
	EndIf
	
	QRY3->(DbCloseArea())
Return(nCustq)