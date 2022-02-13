#Include "PROTHEUS.CH"
#include 'topconn.ch'

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : CAT17				| 	Maio de 2012														  					|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : Relatório com Dados para Portaria CAT 17														  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/

User Function CAT17()    
	Local cPerg := "CAT17"

	u_GerA0003(ProcName())
	
	fCriaSX1(cPerg)
	if ! pergunte(cPerg)		
		return
	endif	
  
	Processa( { || MyRel() } ) 
Return .t.                     


Static Function MyRel()                 
	Local cDirDocs	
	Local cArquivo	:= "CAT17_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)
	Local cQuery  	:= ''
	Local _cArqTmp  
	
	PswOrder(1)
	PswSeek(__cUserID)
	_apswdet2 := PswRet(2)
	_usrrelat := _aPswDet2[1,3] // diretório da pasta relato
	
    cDirDocs := StrTran(alltrim(_usrrelat), "\", "/" )
	_cArqTmp := lower(AllTrim(cDirDocs)+cArquivo)
	
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".xls",0)
	                               
	IF Select("QRY0") <> 0 
		DbSelectArea("QRY0")
		DbCloseArea()
	Endif
	
	_cQuery	:=		"SELECT	D2_ITEM AS ITEM,"
	_cQuery	+=	"				D2_COD AS COD_PRODUTO,"
	_cQuery	+=	"				D2_UM AS UNIDADE,"
	_cQuery	+=	"				D2_SEGUM AS SEGUNDA_UM,"
	_cQuery	+=	"				D2_QUANT AS QUANTIDADE,"
	_cQuery	+=	"				D2_PRUNIT AS VLR_UNITARIO,"
	_cQuery	+=	"				D2_TOTAL AS TOTAL,"
	_cQuery	+=	"				D2_VALIPI AS IPI,"
	_cQuery	+=	"				(select TOP 1 D1_DOC  from SD1020 where D1_COD = D2_COD and D1_CF IN ('1401', '1403', '2401', '2403') and  D_E_L_E_T_ <> '*' AND D1_EMISSAO <= '" + dtos(mv_par03) +  "' order by R_E_C_N_O_ DESC)  AS D1_DOC,"
	_cQuery	+=	"				(select TOP 1 D1_EMISSAO from SD1020 where D1_COD = D2_COD and D1_CF IN ('1401', '1403', '2401', '2403') and  D_E_L_E_T_ <> '*'  AND D1_EMISSAO <= '" + dtos(mv_par03) +  "'  order by R_E_C_N_O_ DESC)  AS D1_EMISSAO,"
	_cQuery	+=	"				D2_QUANT * (select TOP 1 (D1_VALICM / D1_QUANT) as VAL_ICM from SD1020 where D1_COD = D2_COD and D1_CF IN ('1401', '1403', '2401', '2403') and  D_E_L_E_T_ <> '*' AND D1_EMISSAO <= '" + dtos(mv_par03) +  "'  order by R_E_C_N_O_ DESC)  AS VLR_ICMS,"
	_cQuery	+=	"				D2_TES AS TES,"
	_cQuery	+=	"				CASE WHEN D2_ICMSRET = 0 THEN "
	_cQuery	+=	"					D2_QUANT * (select TOP 1 (D1_ICMSRET / D1_QUANT) as VAL_ICM_SOL from SD1020 where D1_COD = D2_COD and D1_CF IN ('1401', '1403', '2401', '2403') and  D_E_L_E_T_ <> '*' AND D1_EMISSAO <= '" + dtos(mv_par03) +  "'  order by R_E_C_N_O_ DESC) "
	_cQuery	+=	"				ELSE"
	_cQuery	+=	"					0    "
	_cQuery	+=	"				END  AS ICMS_SOLID,"
	_cQuery	+=	"				D2_CF AS CFOP,"
	_cQuery	+=	"				D2_IPI AS ALIQ_IPI,"
	_cQuery	+=	"				D2_PICM AS ALIQ_ICMS,"
	_cQuery	+=	"				D2_OP AS ORDEM_PRODUCAO,"
	_cQuery	+=	"				D2_PEDIDO AS NUM_PEDIDO,"
	_cQuery	+=	"				D2_CLIENTE AS CLIENTE,"
	_cQuery	+=	"				D2_LOJA AS LOJA,"
	_cQuery	+=	"				D2_LOCAL AS ARMAZEM,"
	_cQuery	+=	"				D2_DOC AS NUM_DOCTO,"
	_cQuery	+=	"				D2_EMISSAO AS EMISSAO,"
	_cQuery	+=	"				D2_TP AS TIPO_PRODUTO,"
	_cQuery	+=	"				D2_SERIE AS SERIE,"
	_cQuery	+=	"				D2_CUSTO2 AS CUSTO_MOEDA_2,"
	_cQuery	+=	"				D2_CUSTO5 AS CUSTO_MOEDA_5,"
	_cQuery	+=	"				D2_PRCVEN AS PRC_TABELA,"
	_cQuery	+=	"				D2_EST AS ESTADO_DEST,"
	_cQuery	+=	"				CASE WHEN D2_ICMSRET = 0 THEN "
	_cQuery	+=	"					D2_ICMSRET "
	_cQuery	+=	"				ELSE "
	_cQuery	+=	"					D2_BASEICM "
	_cQuery	+=	"				END AS RET_ICMS,"
	_cQuery	+=	"				D2_BASEICM AS BASE_ICMS,"
	_cQuery	+=	"				D2_ICMSRET AS ICMS_SOLID,  "
	_cQuery	+=	"				D2_COMIS2 AS COMISSAO_2"
	_cQuery	+=	"		FROM SD2020"
	_cQuery	+=	"		WHERE D2_CF IN ('6102', '6403')"
	_cQuery	+=	"		 AND D_E_L_E_T_=''"
	_cQuery	+=	"		 AND D2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery	+=	"		ORDER BY D2_COD, D2_EMISSAO  "
	
	TCQUERY _cQuery NEW ALIAS "QRY0"  
	TcSetField("QRY0", "EMISSAO", "D")
	TcSetField("QRY0", "D1_EMISSAO", "D")
	
	nTotsRec := QRY0->(RECCOUNT())
	ProcRegua(nTotsRec)               
	                          
	clinha := '<html>' + CRLF 
	clinha += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">' + CRLF 
	clinha += '<body>' + CRLF 
	clinha += '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
	fWrite(nHandle, cLinha)						
	
	clinha := '<tr height=21  bgcolor="lightblue">'
	cLinha += '<td font face="Arial" size="10"><b>Ítem'
	cLinha += '</td><td font face="Arial" size="10"><b>Cod. Produto'
	cLinha += '</td><td font face="Arial" size="10"><b>Unidade'
	cLinha += '</td><td font face="Arial" size="10"><b>Seg. Unidade'
	cLinha += '</td><td font face="Arial" size="10"><b>Quantidade'
	cLinha +=  '</td><td font face="Arial" size="10"><b>Valor Unitário'
	cLinha +=  '</td><td font face="Arial" size="10"><b>Valor Total'
	cLinha +=  '</td><td font face="Arial" size="10"><b>Valor IPI'
	cLinha += '</td><td font face="Arial" size="10"><b>Valor ICMS'
	cLinha += '</td><td font face="Arial" size="10"><b>Tipo Saída'
	cLinha += '</td><td font face="Arial" size="10"><b>NF Entrada'
	cLinha += '</td><td font face="Arial" size="10"><b>Data de Emissão'
	cLinha += '</td><td font face="Arial" size="10"><b>ICMS Solid'
	cLinha += '</td><td font face="Arial" size="10"><b>CFOP'
	cLinha += '</td><td font face="Arial" size="10"><b>Aliq. IPI'
	cLinha += '</td><td font face="Arial" size="10"><b>Aliq. ICMS'
	cLinha += '</td><td font face="Arial" size="10"><b>Ordem de Produção'
	cLinha += '</td><td font face="Arial" size="10"><b>Num. Pedido'
	cLinha += '</td><td font face="Arial" size="10"><b>Cliente'
	cLinha += '</td><td font face="Arial" size="10"><b>Loja'
	cLinha += '</td><td font face="Arial" size="10"><b>Armazem'
	cLinha += '</td><td font face="Arial" size="10"><b>Num. Docto'
	cLinha += '</td><td font face="Arial" size="10"><b>Emissão'
	cLinha += '</td><td font face="Arial" size="10"><b>Tipo Produto'
	cLinha += '</td><td font face="Arial" size="10"><b>Série'
	cLinha += '</td><td font face="Arial" size="10"><b>Custo Moeda 2'
	cLinha += '</td><td font face="Arial" size="10"><b>Custo Moeda 5'
	cLinha += '</td><td font face="Arial" size="10"><b>Preço de Tabela'
	cLinha += '</td><td font face="Arial" size="10"><b>Estado Destino'
	cLinha += '</td><td font face="Arial" size="10"><b>Ret. ICMS'
	cLinha += '</td><td font face="Arial" size="10"><b>Base ICMS'
	cLinha += '</td><td font face="Arial" size="10"><b>ICMS Solid.'
	cLinha += '</td><td font face="Arial" size="10"><b>Comissão2'
	cLinha += '</td></tr>' + CRLF
	fWrite(nHandle, cLinha)
	    
	cor := ""
	Do  While ! QRY0->(EOF())
		IncProc()             
		clinha := '<tr height=21   bgcolor="'+ cor + '">'
		cLinha += '<td font face="Arial" size="10" bgcolor="'+ cor + '">' + QRY0->ITEM
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->COD_PRODUTO 
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->UNIDADE	
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->SEGUNDA_UM	
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->QUANTIDADE, "@E 9,999,999.99")
		cLinha +=  '</td><td font face="Arial" size="10">' + Transform(QRY0->VLR_UNITARIO, "@E 9,999,999.99")
		cLinha +=  '</td><td font face="Arial" size="10">' + Transform(QRY0->TOTAL, "@E 9,999,999.99")
		cLinha +=  '</td><td font face="Arial" size="10">' + Transform(QRY0->IPI, "@E 9,999,999.99")	
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->VLR_ICMS	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->TES
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->D1_DOC
		cLinha += '</td><td font face="Arial" size="10">' + DTOC(QRY0->D1_EMISSAO)
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->ICMS_SOLID	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->CFOP
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->ALIQ_IPI	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->ALIQ_ICMS	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->ORDEM_PRODUCAO
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->NUM_PEDIDO
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->CLIENTE
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->LOJA
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->ARMAZEM
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->NUM_DOCTO
		cLinha += '</td><td font face="Arial" size="10">' + DTOC(QRY0->EMISSAO)
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->TIPO_PRODUTO
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->SERIE
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->CUSTO_MOEDA_2	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->CUSTO_MOEDA_5	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->PRC_TABELA	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + QRY0->ESTADO_DEST
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->RET_ICMS	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->BASE_ICMS	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->ICMS_SOLID	, "@E 9,999,999.99")
		cLinha += '</td><td font face="Arial" size="10">' + Transform(QRY0->COMISSAO_2	, "@E 9,999,999.99")
		cLinha += '</td></tr>' + CRLF
		fWrite(nHandle, cLinha)
		QRY0->(DBSKIP())      
		iif(cor == "", cor := '#CDC9C9', cor := "")
	EndDo
	clinha := '</table>' + CRLF 
	clinha += '</body>' + CRLF 
	clinha += '</html> ' + CRLF 
	fWrite(nHandle, cLinha)						
	fClose(nHandle)
		
	If !ApOleClient( 'MsExcel' )
		MsgAlert( "Ms Excel nao Instalado" )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cArqTmp+".xls" )
		oExcelApp:SetVisible(.T.)
	EndIf
	
	IF Select("QRY0") <> 0 
		DbSelectArea("QRY0")
		DbCloseArea()
	Endif   
Return .t.


Static Function fCriaSX1(cPerg)
	PutSX1(cPerg,"01","Notas Fiscais emitidas de : ","","","mv_ch1","D",08,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"02","Notas Fiscais emitidas até: ","","","mv_ch2","D",08,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"03","Notas de Entrada até: ","","","mv_ch3","D",08,0,0,"G","",""    ,"","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","")
return 	
