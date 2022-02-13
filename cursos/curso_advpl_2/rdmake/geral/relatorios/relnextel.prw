#Include "PROTHEUS.CH"
#include 'topconn.ch'
#include "tbiconn.ch"

/*
|---------------------------------------------------------------|	
|	Programa : RELNEXTEL					| 	Maio de 2012	|
|---------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi						|
|---------------------------------------------------------------|	
|	Descrição : Relatório com Controle de Operações	 Nextel		|
|---------------------------------------------------------------|	
*/

User Function RELNEXTEL()    

//u_GerA0003(ProcName())
	
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" 

	PswOrder(1)
	PswSeek(getMV("BH_RELNEXT"))
	_apswdet2 := PswRet(2)
	_usrrelat := _aPswDet2[1,3] // diretório da pasta relato

    _aOps := {}
    aadd(_aOps, 'N02')
   	aadd(_aOps, 'N03')
    aadd(_aOps, 'N04')
    
	for xz:=1 to len(_aOps)                                         

		cDirDocs	:= StrTran(alltrim(_usrrelat), "\", "/" )
		cArquivo	:=	_aOps[xz] + "_BASE_DADOS_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)
		cArquivoFat	:=	_aOps[xz] + "_FATURADO_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)
		cArquivoRec	:=	_aOps[xz] + "_RECEBIDO_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)
		cArquivoOtd	:=	_aOps[xz] + "_OTD_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)
	
		cQuery  	:= ''
		_cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
		_cAno := alltrim(str(year(date())))
		_cMes := padl(alltrim(str(month(date()))),2,"0")
	
		_QRY := "SELECT MESORD, QUINZ FROM PROTHEUS_BI.dbo.CALENDARIO WHERE DATA = '" + dtos(date()) + "'"
		TCQUERY _QRY NEW ALIAS "QRY_PERIODO"  
		_mesord := QRY_PERIODO->MESORD
		_quinz :=	QRY_PERIODO->QUINZ
		QRY_PERIODO->(dbCloseArea())
	
		_QRY := "SELECT MIN(DATA) AS DATAINI, MAX(DATA) AS DATAFIM FROM PROTHEUS_BI.dbo.CALENDARIO WHERE MESORD = '" + _mesord + "'" // AND QUINZ = '" + _quinz + "'"
		TCQUERY _QRY NEW ALIAS "QRY_PERIODO"  
		_dataini := QRY_PERIODO->DATAINI
		_datafim:=	QRY_PERIODO->DATAFIM
		QRY_PERIODO->(dbCloseArea())
	
	//	 Query para aba Base de Dados
	  
		_cQuery :=	"select 	distinct	"
		_cQuery +=	"			ZZ4.ZZ4_OS, "
		_cQuery +=	"			ZZ4.ZZ4_IMEI, "
		_cQuery +=	"			ZZ4.ZZ4_CODPRO, "
		_cQuery +=	"			SB1.B1_XMODELO, "
		_cQuery +=	"			ZZ4.ZZ4_NFENR, "
		_cQuery +=	"			SD1.D1_EMISSAO, "
		_cQuery +=	"			DATEDIFF(DAY, D1_EMISSAO, GETDATE()) AS TAT_CLIENTE, "
		_cQuery +=	"			ZZ4.ZZ4_DOCDTE, "
		_cQuery +=	"			ZZ4.ZZ4_NFEDT, "
		_cQuery +=	"			SA1.A1_NOME, "
		_cQuery +=	"			SA1.A1_EST, "
		_cQuery +=	"			ZZ4.ZZ4_CARCAC, "
		_cQuery +=	"			ZZ1.ZZ1_DESFA1, "
		_cQuery +=	"			ZZ3.ZZ3_DATA, "
		_cQuery +=	"			CASE WHEN ZZ4.ZZ4_STATUS = '5' THEN 'Encerrado' ELSE 'Aberto' END AS STATUS, "
	//		RESP,
		_cQuery +=	"			DATEDIFF(DAY, ZZ4.ZZ4_NFEDT, GETDATE()) AS TAT_BGH	"
		_cQuery +=	"from ZZ4020 AS ZZ4 "
		_cQuery +=	"inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4.ZZ4_OPEBGH and ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SB1020 AS SB1 ON SB1.B1_COD = ZZ4.ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SA1020 AS SA1 ON SA1.A1_COD = ZZ4.ZZ4_CODCLI and SA1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join ZZ1020 AS ZZ1 ON ZZ1.ZZ1_FASE1 = ZZ4.ZZ4_FASATU and ZZ1.ZZ1_LAB = ZZJ.ZZJ_LAB and ZZ1.ZZ1_CODSET = ZZ4.ZZ4_SETATU and ZZ1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.ZZ3_ENCOS = 'S' and ZZ3.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join SD1020 AS SD1 ON SD1.D1_DOC = ZZ4.ZZ4_NFENR and SD1.D1_ITEM = ZZ4.ZZ4_ITEMD1 and SD1.D1_FORNECE = ZZ4.ZZ4_CODCLI and SD1.D1_LOJA = ZZ4.ZZ4_LOJA and SD1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"where ZZ4_NFSDT = '' "
		_cQuery +=	"  and ZZ4.D_E_L_E_T_ <> '*' "
		_cQuery +=	"  and ZZ4_LOCAL in ('16') "
		_cQuery +=	"  and ZZ4_OPEBGH = '"  + _aOps[xz] +  "' "
		_cQuery +=	"order by TAT_BGH desc "
		TCQUERY _cQuery NEW ALIAS "QRY0"  
	
		TcSetField("QRY0", "D1_EMISSAO", "D")
		TcSetField("QRY0", "ZZ4_DOCDTE", "D")
		TcSetField("QRY0", "ZZ4_NFEDT", "D")
		TcSetField("QRY0", "ZZ3_DATA", "D")

		nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".xls",0)
		clinha := '<html>' + CRLF 
		clinha += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">' + CRLF 
		clinha += '<body>' + CRLF 
		fWrite(nHandle, cLinha) 
		_resumo	:= {}

		QRY0->(dbGoTop())	
		Do  While ! QRY0->(EOF())                        
	
			cLinha := '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
			cLinha += '<tr>'
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>OS </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>IMEI </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>PRODUTO </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>MODELO </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NFE </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISENT</td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>TATC</td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRDOC </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRADA </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NOMEENT </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ESTADO </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>CARCACA </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DESFAATU </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DTENCHAN </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>STATUS </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>RESP. </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>TAT BGH </td>' 
			cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>PN Faltante </td>' 
			cLinha += '</tr>' + CRLF
	
			fWrite(nHandle, cLinha)
			    
			Do  While  !  QRY0->(EOF())  
				clinha := '<tr>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ4_OS + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ4_IMEI + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ4_CODPRO + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->B1_XMODELO + '</td>'
	 			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ4_NFENR + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRY0->D1_EMISSAO) + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + Transform(QRY0->TAT_CLIENTE	, "@E 9,999,999") + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRY0->ZZ4_DOCDTE) + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRY0->ZZ4_NFEDT) + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->A1_NOME + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->A1_EST + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ4_CARCAC + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->ZZ1_DESFA1 + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRY0->ZZ3_DATA) + ' </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + QRY0->STATUS + ' </td>'
				cLinha += '<td align="center" bgcolor="#C1CDC1"><font face="Calibri" size="1"> </td>'
				cLinha += '<td align="center"><font face="Calibri" size="1">' + Transform(QRY0->TAT_BGH, "@E 9,999,999") + ' </td>'     
				
				_cQuery :=	"SELECT ZZ7_PARTNR FROM ZZ7020 WHERE ZZ7_FILIAL = '"+xFilial("ZZ7")+"' AND ZZ7_NUMOS = '" + QRY0->ZZ4_OS + "' AND D_E_L_E_T_ <> '*' "
				TCQUERY _cQuery NEW ALIAS "QRY1"  
				_pecas := ""
				DbSelectArea("QRY1")
				Do  While  !  QRY1->(EOF())  
				  	_pecas +=  QRY1->ZZ7_PARTNR 
					QRY1->(DBSKIP())      
					if ! eof()
						_pecas +=  " / " 			
					endif
				enddo
				DbCloseArea()
				DbSelectArea("QRY0")			
				
				cLinha += '<td align="center"><font face="Calibri" size="1">' + _pecas + ' </td>'
				cLinha += '</tr>' + CRLF
				fWrite(nHandle, cLinha)    
				
				QRY0->(DBSKIP())      
			EndDo 
		
			cLinha := '</table>' + CRLF 
			fWrite(nHandle, cLinha)						
	
		enddo	
	
	
	// 	ABA FATURADO
	
		_cQuery :=	"select 	distinct	"
		_cQuery +=	"			ZZ4.ZZ4_OS, "
		_cQuery +=	"			ZZ4.ZZ4_IMEI, 	"		
		_cQuery +=	"			ZZ4.ZZ4_CODPRO, "
		_cQuery +=	"			SB1.B1_DESC,"
		_cQuery +=	"			SB1.B1_XMODELO, "
		_cQuery +=	"			ZZ4.ZZ4_NFENR,   "
		_cQuery +=	"			SD1.D1_EMISSAO,"
		_cQuery +=	"			ZZ4.ZZ4_DOCDTE,"
		_cQuery +=	"			ZZ4.ZZ4_DOCDTS,"
		_cQuery +=	"			ZZ4.ZZ4_NFEDT,"
		_cQuery +=	"			SB1.B1_GRUPO,"
		_cQuery +=	"			SA1.A1_NOME,"
		_cQuery +=	"			SA1.A1_EST,"
		_cQuery +=	"			ZZ4.ZZ4_CARCAC,"
		_cQuery +=	"			ZZ4.ZZ4_NFSNR,"
		_cQuery +=	"			ZZ4.ZZ4_NFSDT,"
		_cQuery +=	"			ZZ4.ZZ4_NFSTES,"
		_cQuery +=	"			LEFT(ZZ4.ZZ4_ATPRI,8) AS 'ENTRCHAM',"
		_cQuery +=	"			ZZ1.ZZ1_DESFA1,"
		_cQuery +=	"			ZZ3.ZZ3_DATA "
		_cQuery +=	"from ZZ4020 AS ZZ4 "
		_cQuery +=	"inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4.ZZ4_OPEBGH and ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SB1020 AS SB1 ON SB1.B1_COD = ZZ4.ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*'  "
		_cQuery +=	"inner join SA1020 AS SA1 ON SA1.A1_COD = ZZ4.ZZ4_CODCLI and SA1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join ZZ1020 AS ZZ1 ON ZZ1.ZZ1_FASE1 = ZZ4.ZZ4_FASATU and ZZ1.ZZ1_LAB = ZZJ.ZZJ_LAB and ZZ1.ZZ1_CODSET = ZZ4.ZZ4_SETATU and ZZ1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.ZZ3_ENCOS = 'S' and ZZ3.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join SD1020 AS SD1 ON SD1.D1_DOC = ZZ4.ZZ4_NFENR and SD1.D1_ITEM = ZZ4.ZZ4_ITEMD1 and SD1.D1_FORNECE = ZZ4.ZZ4_CODCLI and SD1.D1_LOJA = ZZ4.ZZ4_LOJA and SD1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"where  ZZ4.D_E_L_E_T_ <> '*'  "
		_cQuery +=	"  and ZZ4.ZZ4_NFSDT >= '" + _dataini + "' "
		_cQuery +=	"  and ZZ4.ZZ4_NFSDT <= '" + _datafim + "' "
		_cQuery +=	"  and ZZ4_LOCAL in ('16') "
		_cQuery +=	"  and ZZ4_OPEBGH = '"  + _aOps[xz] +  "' "
		_cQuery +=	"order by ZZ4.ZZ4_IMEI "
		TCQUERY _cQuery NEW ALIAS "QRYFAT"  
	
		TcSetField("QRYFAT", "D1_EMISSAO", "D")
		TcSetField("QRYFAT", "ZZ4_DOCDTE", "D")
		TcSetField("QRYFAT", "ZZ4_DOCDTS", "D")
		TcSetField("QRYFAT", "ZZ4_NFEDT", "D")
		TcSetField("QRYFAT", "ZZ3_DATA", "D")
		TcSetField("QRYFAT", "ZZ4_NFSDT", "D")
		TcSetField("QRYFAT", "ENTRCHAM", "D")
	
		nHandle := MsfCreate(cDirDocs+"\"+cArquivoFat+".xls",0)
	    
	 	cLinha := '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
		cLinha += '<tr>'
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>OS </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>IMEI </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>PRODUTO </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>MODELO </td>'     
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DESCR_PRODUTO </td>'     
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NFE </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISENT</td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRDOC </td>'   
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>SAIDDOCA </td>'   	
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>GRUPO </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NOMEENT </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ESTADO </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>CARCACA </td>'      
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NFBGH </td>'      
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISSAI </td>'      
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>TES </td>'      
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRCHAM </td>'      
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>	DESFAATU </td>' 
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DTENCHAN </td>' 
		cLinha += '</tr>' + CRLF
	
		fWrite(nHandle, cLinha)
	
		Do  While  !  QRYFAT->(EOF())   
			clinha := '<tr>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_OS + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_IMEI + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_CODPRO + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->B1_XMODELO + '</td>'
	 		cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->B1_DESC + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_NFENR + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->D1_EMISSAO) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->ZZ4_DOCDTE) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->ZZ4_DOCDTS) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->B1_GRUPO + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->A1_NOME + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->A1_EST + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_CARCAC + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_NFSNR + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->ZZ4_NFSDT) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ4_NFSTES + '</td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->ENTRCHAM) + ' </td>'     
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYFAT->ZZ1_DESFA1 + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYFAT->ZZ3_DATA) + ' </td>'
			cLinha += '</tr>' + CRLF
	
			fWrite(nHandle, cLinha)    
			
			QRYFAT->(DBSKIP())      
		EndDo 
		cLinha := '</table>' + CRLF 
		fWrite(nHandle, cLinha)						
	
	 
		//aba Recebidos       
		
		_cQuery :=	"select 	distinct	"
		_cQuery +=	"			ZZ4.ZZ4_OS, "
		_cQuery +=	"			ZZ4.ZZ4_IMEI, "
		_cQuery +=	"			ZZ4.ZZ4_CODPRO, "
		_cQuery +=	"			SB1.B1_XMODELO, "
		_cQuery +=	"			SB1.B1_DESC, "
		_cQuery +=	"			ZZ4.ZZ4_NFENR, "
		_cQuery +=	"			SD1.D1_EMISSAO,"
		_cQuery +=	"			ZZ4.ZZ4_NFEDT, "
		_cQuery +=	"			ZZ4.ZZ4_DOCDTE, "
		_cQuery +=	"			SB1.B1_GRUPO, "
		_cQuery +=	"			SA1.A1_NOME, "
		_cQuery +=	"			SA1.A1_EST, "
		_cQuery +=	"			ZZ4.ZZ4_CARCAC "
		_cQuery +=	"from ZZ4020 AS ZZ4 "
		_cQuery +=	"inner join SB1020 AS SB1 ON SB1.B1_COD = ZZ4.ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SA1020 AS SA1 ON SA1.A1_COD = ZZ4.ZZ4_CODCLI and SA1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join SD1020 AS SD1 ON SD1.D1_DOC = ZZ4.ZZ4_NFENR and SD1.D1_ITEM = ZZ4.ZZ4_ITEMD1 and SD1.D1_FORNECE = ZZ4.ZZ4_CODCLI and SD1.D1_LOJA = ZZ4.ZZ4_LOJA and SD1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"WHERE ZZ4.ZZ4_NFEDT >= '" + _dataini + "' "
		_cQuery +=	"  and ZZ4.ZZ4_NFEDT <= '" + _datafim + "' "
		_cQuery +=	"  and ZZ4.D_E_L_E_T_ <> '*' "
		_cQuery +=	"  and ZZ4_LOCAL in ('16') "
		_cQuery +=	"  and ZZ4_OPEBGH = '"  + _aOps[xz] +  "' "
		_cQuery +=	"order by ZZ4_IMEI "
	
		TCQUERY _cQuery NEW ALIAS "QRYREC"  
	
		TcSetField("QRYREC", "ZZ4_NFEDT", "D")
		TcSetField("QRYREC", "D1_EMISSAO", "D")
		TcSetField("QRYREC", "ZZ4_DOCDTE", "D")
	
		nHandle := MsfCreate(cDirDocs+"\"+cArquivoRec+".xls",0)
	
	 	cLinha := '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
		cLinha += '<tr>'
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>OS </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>IMEI </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>PRODUTO </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>MODELO </td>'     
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DESCR_PRODUTO </td>'     
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NFE </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISENT</td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRDOC </td>'   
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRADA </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>GRUPO </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NOMEENT </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ESTADO </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>CARCACA </td>'      
		cLinha += '</tr>' + CRLF
	
		fWrite(nHandle, cLinha)
	
		Do  While  !  QRYREC->(EOF())   
			clinha := '<tr>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->ZZ4_OS + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->ZZ4_IMEI + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->ZZ4_CODPRO + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->B1_XMODELO + '</td>'
	 		cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->B1_DESC + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->ZZ4_NFENR + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(D1_EMISSAO) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYREC->ZZ4_DOCDTE) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYREC->ZZ4_NFEDT) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->B1_GRUPO + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->A1_NOME + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->A1_EST + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYREC->ZZ4_CARCAC + ' </td>'
			cLinha += '</tr>' + CRLF
	
			fWrite(nHandle, cLinha)    
			
			QRYREC->(DBSKIP())      
		EndDo 
		cLinha := '</table>' + CRLF 
		fWrite(nHandle, cLinha)						
	
	// aba OTD
	     
		_cQuery :=	"select 	distinct	"
		_cQuery +=	"			ZZ4.ZZ4_OS, "
		_cQuery +=	"			ZZ4.ZZ4_IMEI, "
		_cQuery +=	"			ZZ4.ZZ4_CODPRO, "
		_cQuery +=	"			SB1.B1_DESC, "
		_cQuery +=	"			SB1.B1_XMODELO, "
		_cQuery +=	"			ZZ4.ZZ4_NFENR, "
		_cQuery +=	"			SD1.D1_EMISSAO, "
		_cQuery +=	"			ZZ4.ZZ4_DOCDTE, "
		_cQuery +=	"			ZZ4.ZZ4_NFEDT, "
		_cQuery +=	"			SA1.A1_NOME, "
		_cQuery +=	"			SA1.A1_EST, "
		_cQuery +=	"			ZZ4.ZZ4_CARCAC, "
		_cQuery +=	"			ZZ4.ZZ4_NFSDT, "
		_cQuery +=	"			LEFT(ZZ4.ZZ4_ATPRI,8) AS 'ENTRCHAM', "
		_cQuery +=	"			ZZ1.ZZ1_DESFA1, "
		_cQuery +=	"			ZZ3.ZZ3_DATA, "
		_cQuery +=	"			'Encerrado'  AS STATUS, "
		_cQuery +=	"			(ZZ3.ZZ3_DATA+1) - SD1.D1_EMISSAO AS OTD_BGH "
		_cQuery +=	"from ZZ4020 AS ZZ4 "
		_cQuery +=	"inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4.ZZ4_OPEBGH and ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SB1020 AS SB1 ON SB1.B1_COD = ZZ4.ZZ4_CODPRO and SB1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join SA1020 AS SA1 ON SA1.A1_COD = ZZ4.ZZ4_CODCLI and SA1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join ZZ1020 AS ZZ1 ON ZZ1.ZZ1_FASE1 = ZZ4.ZZ4_FASATU and ZZ1.ZZ1_LAB = ZZJ.ZZJ_LAB and ZZ1.ZZ1_CODSET = ZZ4.ZZ4_SETATU and ZZ1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"inner join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.ZZ3_ENCOS = 'S' and ZZ3.D_E_L_E_T_ <> '*' "
		_cQuery +=	"left join SD1020 AS SD1 ON SD1.D1_DOC = ZZ4.ZZ4_NFENR and SD1.D1_ITEM = ZZ4.ZZ4_ITEMD1 and SD1.D1_FORNECE = ZZ4.ZZ4_CODCLI and SD1.D1_LOJA = ZZ4.ZZ4_LOJA and SD1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"where ZZ4.D_E_L_E_T_ <> '*' "
		_cQuery +=	"  and ZZ3.ZZ3_DATA >= '" + _dataini + "' "
		_cQuery +=	"  and ZZ3.ZZ3_DATA <= '" + _datafim + "' "
		_cQuery +=	"  and ZZ4_LOCAL in ('16') "
		_cQuery +=	"  and ZZ4_OPEBGH = '"  + _aOps[xz] +  "' "
		_cQuery +=	"order by ZZ4.ZZ4_IMEI "
		TCQUERY _cQuery NEW ALIAS "QRYOTD"  
	
		TcSetField("QRYOTD", "D1_EMISSAO", "D")
		TcSetField("QRYOTD", "ZZ4_DOCDTE", "D")
		TcSetField("QRYOTD", "ZZ4_NFSDT", "D")
		TcSetField("QRYOTD", "ZZ4_NFEDT", "D")
		TcSetField("QRYOTD", "ENTRCHAM", "D")
		TcSetField("QRYOTD", "ZZ3_DATA", "D")
	
		nHandle := MsfCreate(cDirDocs+"\"+cArquivoOtd+".xls",0)
		
		cLinha := '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
		cLinha += '<tr>'
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>OS </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>IMEI </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>PRODUTO </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>MODELO </td>'     
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DESCR_PRODUTO </td>'     
		cLinha += '<td bgcolor="#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NFE </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISENT</td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRDOC </td>'   
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRADA </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>NOMEENT </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ESTADO </td>' 
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>CARCACA </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>EMISSAI </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>ENTRCHAM </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DESFAATU </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>DTENCHAN </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>STATUS </td>'      
		cLinha += '<td bgcolor="	#C1CDC1" align="center" valign="center"><font face="Calibri" size="1" color="#CD0000"><b>OTD BGH </td>'      
		cLinha += '</tr>' + CRLF
	
		fWrite(nHandle, cLinha)
	    
		Do  While  !  QRYOTD->(EOF())   
			clinha := '<tr>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ4_OS + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ4_IMEI + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ4_CODPRO + ' </td>'
	 		cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->B1_XMODELO + ' </td>'
	 		cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->B1_DESC + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ4_NFENR + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->D1_EMISSAO) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->ZZ4_DOCDTE) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->ZZ4_NFEDT) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->A1_NOME + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->A1_EST + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ4_CARCAC + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->ZZ4_NFSDT) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->ENTRCHAM) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->ZZ1_DESFA1 + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + dtoc(QRYOTD->ZZ3_DATA) + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + QRYOTD->STATUS + ' </td>'
			cLinha += '<td align="center"><font face="Calibri" size="1">' + Transform(QRYOTD->OTD_BGH	, "@E 9,999,999") + ' </td>'
			cLinha += '</tr>' + CRLF
	
			fWrite(nHandle, cLinha)    
			
			QRYOTD->(DBSKIP())      
		EndDo 
		cLinha := '</table>' + CRLF 
		fWrite(nHandle, cLinha)						

		IF Select("QRY0") <> 0 
			DbSelectArea("QRY0")
			DbCloseArea()
		Endif   
		IF Select("QRYFAT") <> 0 
			DbSelectArea("QRYFAT")
			DbCloseArea()
		Endif   
		IF Select("QRYREC") <> 0 
			DbSelectArea("QRYREC")
			DbCloseArea()
		Endif   
		IF Select("QRYOTD") <> 0 
			DbSelectArea("QRYOTD")
			DbCloseArea()
		Endif   
		
	next	
RESET ENVIRONMENT