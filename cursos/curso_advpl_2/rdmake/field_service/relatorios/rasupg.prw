#Include 'Protheus.ch'
#define ENTER CHR(10)+CHR(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RASUPG   บAutor  ณUiran Almeida       บ Data ณ  00/00/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de aparelhos Upgrades                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
                            

User Function RasUpg()

Local oReport

Private cPerg := "RASUPG"
	
	CriaSX1()

	If TRepInUse()
		Pergunte(cPerg,.F.)
		oReport := ReportDef()
		oreport:PrintDialog()
	EndIf

Return

                                                                              
/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ MONTAGEM DO LAYOUT DO RELATORIO                                       บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

oReport := TReport():New("RasUpg","Rastreio Upgrade",cPerg,{|oReport|PrintReport(oReport)},"Relatorio de Rastreio do Upgrade")	

	oSection := TRSection():New(oReport,"Pedidos",{"SC6"})
	
	TRCell():New(oSection,"C6_IMEINOV"		,"SC6")
	TRCell():New(oSection,"C6_PRODUTO"		,"SC6")
	TRCell():New(oSection,"C6_DESCRI"		,"SC6")
	TRCell():New(oSection,"C6_CLI"			,"SC6")
	TRCell():New(oSection,"C6_XIMEOLD"		,"SC6")
	TRCell():New(oSection,"C6_NUM"			,"SC6")
	TRCell():New(oSection,"C6_NOTA"			,"SC6")
	TRCell():New(oSection,"C6_DATFAT"		,"SC6")
	
	
	oBreak := TRBreak():New(oSection,oSection:Cell("C6_NUM"),"SubTotal Pedidos")
	


Return oReport	
	

/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ MONTAGEM DOS DADOS DO RELATORIO                                       บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/	
	
Static Function PrintReport(oReport)

Local oSection 	:= oReport:Section(1)
Local cPedido   := ""
Local cImei   	:= ""
Local cFiltro 	:= ""
Local cPart		:= ""

	MakeSqlExpr(cPerg)
	oSection:BeginQuery()
		      
		   If !Empty(mv_par01)
		   		cPart := "%AND C6_IMEINOV='"+mv_par01+"' %"
	       EndIf
	       
	       If !Empty(mv_par02) 
	       		cPart := "%AND C6_NUM='"+mv_par02+"' %"
	       EndIf
	       
	       If !Empty(mv_par01) .And. !Empty(mv_par02) 
	       		cPart := "%AND C6_IMEINOV='"+mv_par01+"' AND C6_NUM='"+mv_par02+"' %"
	       EndIf         
	       
	       If Empty(cPart)		
	       		cPart := "%%"	
		   EndIf   
		   
		    
		   
		
	BeginSql alias "QRYSC6"
		SELECT  C6_IMEINOV,C6_PRODUTO,C6_DESCRI,C6_CLI,C6_XIMEOLD,C6_NUM,C6_NOTA,C6_DATFAT
			FROM %table:SC6% SC6 
			WHERE  	C6_FILIAL	=	%xfilial:SC6%
			AND 	C6_DATFAT BETWEEN %exp:mv_par03% AND %exp:mv_par04% 
	  		AND 	SC6.%notDel% %exp:cPart%
		    AND     C6_IMEINOV != ''
		ORDER BY C6_NUM
		
	EndSql
		oSection:EndQuery(mv_par05)
		
		oSection:Print()
		
Return

/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Cria as Perguntas Usadas no Relatorio                                 บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/

Static Function CriaSX1()

	PutSx1(cPerg,"01","Imei"			,"Imei"				,"Imei"				,"mv_ch01","C",TamSX3("ZZ4_IMEI")[1],0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","",)
	PutSx1(cPerg,"02","Pedido"			,"Pedido"			,"Pedido"			,"mv_ch02","C",6,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","",)
	PutSx1(cPerg,"03","Data de:"		,"Data de:"			,"Data de:"			,"mv_ch03","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","",)
	PutSx1(cPerg,"04","Data At้:"		,"Data At้:"		,"Data At้:"		,"mv_ch04","D",8,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","",)
Return Nil