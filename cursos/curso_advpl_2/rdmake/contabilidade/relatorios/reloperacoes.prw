#Include "PROTHEUS.CH"
#include 'topconn.ch'
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Programa : RELOPERACOES				| 	Maio de 2012									  					|
|-------------------------------------------------------------------------------------------------------------------------------------------	|
|	Desenvolvido por Luis Carlos - Maintech																				|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
|	Descrição : Relatório com resumo de Operações																  	|
|-------------------------------------------------------------------------------------------------------------------------------------------	|	
*/

User Function RELOPERACOES()    

	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" 

	PswOrder(1)
	PswSeek(getMV("MV_RELOPER"))
	_apswdet2 := PswRet(2)
	_usrrelat := _aPswDet2[1,3] // diretório da pasta relato


	Private cDirDocs	:= StrTran(alltrim(_usrrelat), "\", "/" )
	Private cArquivo	:=	"CP_DIARIA_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)
	Private cArquivo1	:=	"AAC_DIARIA_"+dtos(date())+LEFT(time(),2)+SUBSTR(time(),4,2)+SUBSTR(time(),7,2)
	Private cQuery  	:= ''
	Private _cArqTmp  	:= lower(AllTrim(__RELDIR)+cArquivo)
	Private _cAno 		:= alltrim(str(year(date())))
	Private _cMes 		:= padl(alltrim(str(month(date()))),2,"0")
	Private _operacao	:= {}

	u_GerA0003(ProcName())
	
	aadd(_operacao, "P01")
	aadd(_operacao, "P02")
	aadd(_operacao, "P03")
	aadd(_operacao, "P04")
		
	nHandle 			:= MsfCreate(cDirDocs+"\"+cArquivo+".xls",0)   
	
	for xyz:=1 to len(_operacao)
	
		_opera 	:= _operacao[xyz]
		               
		_cQuery :=	"select	MAX(diames.VALUE) AS dia, " // coluna A 
		_cQuery +=	"		MAX(ZAE.ZAE_META) AS ZAE_META, "  
		_cQuery +=	"		max(ZA2.ZA2_ENTPLA) AS ZA2_ENTPLA, "  
		_cQuery +=	"		max(ZA2.ZA2_BACKLO) AS ZA2_BACKLO, "  
		_cQuery +=	"		MAX(ZZJ.ZZJ_OPERA) AS ZZJ_OPERA, "  
		_cQuery +=	"		MAX(ZZJ.ZZJ_DESCRI) AS ZZJ_DESCRI, "  
		_cQuery +=	"		MAX(P.total) AS total_saida, "
		_cQuery +=	"		max(B.total_entrada) AS total_entrada, "     //  coluna C
		_cQuery +=	"		max(C.total_scrap) AS total_scrap, "  // coluna G     
		_cQuery +=	"		max(D.total_dsr) AS total_dsr, " // coluna F    
		_cQuery +=	"		max(E.produzido_dsr) AS prod_dsr, "   // coluna J
		_cQuery +=	"		max(F.produzido_scrap) AS prod_scrap, "  // coluna K
		_cQuery +=	"		max(G.produzido_total) AS prod_total, "  // coluna L
		_cQuery +=	"		max(H.coleta) AS coleta "  // coluna M		
		
		_cQuery +=	"From (SELECT '" + alltrim(str(year(date()))) + alltrim(strzero(month(date()),2,0)) + "01' AS VALUE "
	
		for x:=2 to Last_Day(date())	
			_cQuery +=	"		UNION SELECT '" + alltrim(str(year(date()))) + alltrim(strzero(month(date()),2,0)) + StrZero(x, 2, 0) + "' AS VALUE "	
		next	
		_cQuery +=	") AS diames "
			
		_cQuery +=	"left join ZZ4020 AS A ON ZZ4_NFSDT = diames.VALUE "
		_cQuery +=	"	and MONTH(ZZ4_NFSDT) = '" + _cMes + "' "
		_cQuery +=	"	and YEAR(ZZ4_NFSDT) = '" + _cAno + "' "                                                                            
		_cQuery +=	"	and A.D_E_L_E_T_ <> '*' "
		_cQuery +=	"	and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"	and ZZ4_GRPPRO <> '' "	      
		
		_cQuery +=	"left join ZZJ020 AS ZZJ ON ZZJ_OPERA =  '" + _opera + "' AND ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery +=  "left join ZAE020 AS ZAE ON ZAE_OPEBGH = '" + _opera + "' AND ZAE.D_E_L_E_T_ <> '*' AND ZAE.ZAE_DIAMET = diames.VALUE "
		_cQuery +=  "left join ZA2020 AS ZA2 ON ZA2_OPEBGH = '" + _opera + "' AND ZA2.D_E_L_E_T_ <> '*' AND ZA2.ZA2_MESANO = '" + _cMes + "/" + _cAno + "' "
		
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, MAX(ZZ4_DOCDTE) AS dia, count(*) AS total_entrada "
		_cQuery +=	"				from ZZ4020 "
		_cQuery +=	"				inner join ZZJ020 ON ZZJ_OPERA =  ZZ4_OPEBGH AND ZZJ020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				where MONTH(ZZ4_DOCDTE) = '" + _cMes + "' "
		_cQuery +=	"					and YEAR(ZZ4_DOCDTE) = '" + _cAno + "' "
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by ZZ4_LOCAL, ZZ4_DOCDTE) AS B ON ZZJ.ZZJ_OPERA = B.operacao and B.dia = diames.VALUE "      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, MAX(ZZ4_NFSDT) AS dia, count(*) AS total "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery	+=	"				inner join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.D_E_L_E_T_ <> '*' and ZZ3_ENCOS = 'S' "
		_cQuery +=	"				where MONTH(ZZ4_NFSDT) = '" + _cMes + "' "
		_cQuery +=	"				   	and YEAR(ZZ4_NFSDT) = '" + _cAno + "' "
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by ZZ4_LOCAL, ZZ4_NFSDT) AS P ON ZZJ.ZZJ_OPERA = P.operacao and P.dia = diames.VALUE "                      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, MAX(ZZ4_NFSDT) AS dia, count(*) AS total_scrap "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "
		_cQuery	+=	"				inner join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.D_E_L_E_T_ <> '*' and ZZ3.ZZ3_ASCRAP = 'S' and ZZ3_ENCOS = 'S' "
		_cQuery +=	"				where MONTH(ZZ4_NFSDT) = '" + _cMes + "' "
		_cQuery +=	"				   	and YEAR(ZZ4_NFSDT) = '" + _cAno + "' "
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by ZZ4_LOCAL, ZZ4_NFSDT) AS C ON ZZJ.ZZJ_OPERA = C.operacao and C.dia = diames.VALUE "                      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, MAX(ZZ4_NFSDT) AS dia, count(*) AS total_dsr "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "           
		_cQuery +=	"				inner join ZZ1020 AS ZZ1 ON ZZ1.ZZ1_FASE1 = ZZ4_FASATU "             
		_cQuery +=	"										and ZZ1_STFIMP = '3' "
		_cQuery +=	"										and ZZ1.ZZ1_LAB = ZZJ.ZZJ_LAB "
		_cQuery +=	"										and ZZ1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				where MONTH(ZZ4_NFSDT) = '" + _cMes + "' "
		_cQuery +=	"				   	and YEAR(ZZ4_NFSDT) = '" + _cAno + "' "
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by ZZ4_LOCAL, ZZ4_NFSDT) AS D ON ZZJ.ZZJ_OPERA = D.operacao and D.dia = diames.VALUE "                     
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, max((left(ZZ4_ATULT,8))) AS dia, count(*) AS produzido_dsr "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "           
		_cQuery +=	"				inner join ZZ1020 AS ZZ1 ON ZZ1.ZZ1_FASE1 = ZZ4_FASATU "             
		_cQuery +=	"										and ZZ1_STFIMP = '3' "
		_cQuery +=	"										and ZZ1.ZZ1_LAB = ZZJ.ZZJ_LAB "
		_cQuery +=	"										and ZZ1.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				where left(ZZ4_ATULT,6) = '" + _cAno + _cMes + "'"
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by left(ZZ4_ATULT,8)) AS E ON ZZJ.ZZJ_OPERA = E.operacao and E.dia = diames.VALUE "                      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, max((left(ZZ4_ATULT,8))) AS dia, count(*) AS produzido_scrap "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "           
		_cQuery	+=	"				inner join ZZ3020 AS ZZ3 ON ZZ3.ZZ3_NUMOS = ZZ4_OS and ZZ3.ZZ3_ESTORN <> 'S' and ZZ3.D_E_L_E_T_ <> '*' and ZZ3.ZZ3_ASCRAP = 'S' and ZZ3_ENCOS = 'S' "
	
		_cQuery +=	"				where left(ZZ4_ATULT,6) = '" + _cAno + _cMes + "'"
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by left(ZZ4_ATULT,8)) AS F ON ZZJ.ZZJ_OPERA = F.operacao and F.dia = diames.VALUE "                      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, max((left(ZZ4_ATULT,8))) AS dia, count(*) AS produzido_total "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "           
		_cQuery +=	"				where left(ZZ4_ATULT,6) = '" + _cAno + _cMes + "'"
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"				  	AND ZZ4_FASATU = (CASE 	WHEN ZZ4_OPEBGH = 'P01' THEN '07' "
		_cQuery +=	"				  							WHEN ZZ4_OPEBGH = 'P02' THEN '06' "
		_cQuery +=	"				  					 		WHEN ZZ4_OPEBGH = 'P03' THEN '06' END)"
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by left(ZZ4_ATULT,8)) AS G ON ZZJ.ZZJ_OPERA = G.operacao and G.dia = diames.VALUE "                      
	
		_cQuery +=	"left join (	select MAX(ZZJ_OPERA) AS operacao, count(*) AS coleta "
		_cQuery +=	"				from ZZ4020 "             
		_cQuery +=	"				inner join ZZJ020 AS ZZJ ON ZZJ.ZZJ_OPERA = ZZ4_OPEBGH "             
		_cQuery +=	"										and ZZJ.D_E_L_E_T_ <> '*' "           
		_cQuery +=	"				where ZZ4_DOCDTS = ''"
		_cQuery +=	"					and ZZ4_OPEBGH = '" + _opera + "' "
		_cQuery +=	"					and MONTH(ZZ4_NFSDT) = '" + _cMes + "' "
		_cQuery +=	"				   	and YEAR(ZZ4_NFSDT) = '" + _cAno + "' "
		_cQuery +=	"					and ZZ4020.D_E_L_E_T_ <> '*' "
		_cQuery +=	"				group by ZZJ_OPERA) AS H ON ZZJ.ZZJ_OPERA = H.operacao "                      
	    
		_cQuery +=	"group by diames.VALUE "
		_cQuery +=	"order by dia "
	    
	  	TCQUERY _cQuery NEW ALIAS "QRY0"  
		TcSetField("QRY0", "DIA", "D")
	
		nTotsRec := QRY0->(RECCOUNT())
		ProcRegua(nTotsRec)               
		                          
		clinha := '<html>' + CRLF 
		clinha += '<meta http-equiv=Content-Type content="text/html; charset=windows-1252">' + CRLF 
		clinha += '<body>' + CRLF 
		fWrite(nHandle, cLinha) 
		_resumo	:= {}
		_nBacklog	:=	0

		_cNomeOp	:= QRY0->ZZJ_DESCRI

		cLinha := '<table cellspacing=0 cellpadding=0  border="1">' + CRLF 
		cLinha += '<tr>'
		cLinha += '<td colspan="17" align="center"  bgcolor="lightblue"><font face="Arial" size="4"><b>' + _cNomeOp + '</td>'
		cLinha += '</tr>'
		cLinha += '<tr>'
		cLinha += '<td colspan="17" align="center"  bgcolor="#EEE9BF"></td>'
		cLinha += '</tr>'
	
		cLinha += '<tr>'
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Data </td>' 
		cLinha += '<td bgcolor="#6B8E23" colspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Entrada ACC</td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Meta ACC </td>' 
		cLinha += '<td bgcolor="#6B8E23" colspan="4" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Faturado ACC (NF Emitida) </td>' 
		cLinha += '<td bgcolor="#6B8E23" colspan="4" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Produzido ACC </td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>AG. Coleta </td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Saldo Inicial </td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Entrada do dia </td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Saída </td>' 
		cLinha += '<td bgcolor="#6B8E23" rowspan="2" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Saldo Final </td>' 
		cLinha += '</tr>' + CRLF
	
		cLinha += '<tr>'
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Prevista </td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Real </td>'
		 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>OK </td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>DSR</td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Scrap </td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Total </td>' 
		
		_nTotOKPRD	:= 0
		_nTotDSRPRD	:= 0
		_nTotSCRPRD	:= 0
		_nTotPRD	:= 0
	
		_nTotOK		:= 0
		_nTotDSR	:= 0
		_nTotSCR	:= 0
		_nTot		:= 0
		
		_nEntrACC	:= 0
		_nPrevACC	:= 0
		_nMetaACC	:= 0 
		
		_nSaldoIni	:= QRY0->ZA2_BACKLO
		_nSaida		:= 0
		_nSaldoFim 	:= 0
	
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>OK </td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>DSR</td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Scrap </td>' 
		cLinha += '<td bgcolor="#6B8E23" align="center" valign="center"><font face="Arial" size="2" color="white"><b>Total </td>' 
		cLinha += '</tr>' + CRLF
	
		fWrite(nHandle, cLinha)
	    
		Do  While ! QRY0->(EOF())                        
			    
			IncProc()           
			
			if QRY0->dia <= date()
				clinha := '<tr>'
				           
				_cColor := ""
				if DOW(QRY0->dia) == 7
					_cColor := 'color = "red"'
				endif
				
				cLinha += '<td><font face="Arial" size="2"' + _cColor + '>' + dtoc(QRY0->dia) + '</td>'
		
				_nEntrACC	+= QRY0->total_entrada
				_nPrevACC	+= QRY0->ZA2_ENTPLA
				_nMetaACC	+= QRY0->ZAE_META
					
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nPrevACC, "@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nEntrACC, "@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nMetaACC, "@E 9,999,999") + '</td>'
				
				_nTotOK		+= QRY0->total_saida - QRY0->total_dsr - QRY0->total_scrap
				_nTotDSR	+= QRY0->total_dsr
				_nTotSCR	+= QRY0->total_scrap
				_nTot		+= QRY0->total_saida
		
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotOK, 	"@E 9,999,999")	+ '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotDSR, 	"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotSCR, 	"@E 9,999,999")	+ '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTot, 	"@E 9,999,999")	+ '</td>'
		
				_nTotOKPRD	+= QRY0->prod_total
				_nTotDSRPRD	+= QRY0->prod_dsr
				_nTotSCRPRD	+= QRY0->prod_scrap
				_nTotPRD	+= QRY0->prod_total + QRY0->prod_dsr + QRY0->prod_scrap
					
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotOKPRD		,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotDSRPRD	,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotSCRPRD	,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nTotPRD		,"@E 9,999,999") + '</td>'
		        
		        if dtos(QRY0->dia) == dtos(date())   
		        	_nColeta := QRY0->coleta
		        else
		        	_nColeta := 0
		        endif        
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nColeta	,"@E 9,999,999") + '</td>'
		
				_nSaldoFim 	:= _nSaldoIni + QRY0->total_entrada - QRY0->prod_total
			          
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nSaldoIni			,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(QRY0->total_entrada,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(QRY0->total_saida	,"@E 9,999,999") + '</td>'
				cLinha += '<td><font face="Arial" size="2">' + Transform(_nSaldoFim			,"@E 9,999,999") + '</td>'
		
				cLinha += '</tr>' + CRLF
				fWrite(nHandle, cLinha)    
		
				_nSaldoIni 	:= _nSaldoFim
				
			endif	
			QRY0->(DBSKIP())      
			
		enddo	
        
		cLinha := '</table>' + CRLF
		cLinha += '<table>' + CRLF
		cLinha += '<tr><td></td></tr>' + CRLF
		cLinha += '<tr><td></td></tr>' + CRLF
		cLinha += '</table>' + CRLF
		fWrite(nHandle, cLinha)						
		
	    QRY0->(dbCloseArea())
	next xyz

	clinha := '</body>' + CRLF 
	clinha += '</html> ' + CRLF 
	fWrite(nHandle, cLinha)						
	fClose(nHandle)
                                   
		
	If !ApOleClient( 'MsExcel' )
		MsgAlert( "Ms Excel nao Instalado" )
	Else
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(_cArqTmp+".xls" )
		oExcelApp:SetVisible(.T.)
	EndIf

	IF Select("QRY0") <> 0 
		DbSelectArea("QRY0")
		DbCloseArea()
	Endif   

RESET ENVIRONMENT