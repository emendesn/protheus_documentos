#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#DEFINE ENTER CHR(13)+CHR(10)
/*
==============================================================================================================================================================
Relatório da tabela de reservas que apresenta o ticket 
==============================================================================================================================================================
*/

User Function RelxSC0() //chamada

Local oReport
Private cPerg   := "RELXSC0"

VALIDPERG(cPerg)
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef() // Titulo
Local oReport
Local oSection
Local oBreak
Local aOrdem    := {}

oReport := TReport():New("RELXSC0","Relatório de reservas","RELXSC0",{|oReport| PrintReport(oReport,aOrdem)},"")

Return oReport
                                                                  	

Static Function PrintReport(oReport,aOrdem)  //print


Local nOrdem   	:= oReport:GetOrder()
Local cPart

oSection := TRSection():New(oReport,OemToAnsi("Relatório de reservas"),,, .F., .F. )
	TRCell():New(oSection,"Filial"    			,"" ,"Filial"   			,"@!"			,02,,) 
	TRCell():New(oSection,"Reserva" 			,"" ,"Reserva"     			,"@!"			,06	,,)
	TRCell():New(oSection,"Produto"  			,"" ,"Produto" 				,"@!"			,15	,,)		
	TRCell():New(oSection,"Quantidade"			,"" ,"Quantidade"			,"@E 999,999"	,12,,)
	TRCell():New(oSection,"Ticket"				,"" ,"Ticket"				,"@!"			,07,,)
	TRCell():New(oSection,"Obs"					,"" ,"Obs"					,"@!"			,80,,)
oBreak2  := TRBreak():New(oSection,{ || oSection:Cell('Filial'):uPrint })
TRFunction():New(oSection:Cell("Quantidade"),NIL,"SUM",oBreak2)

u_QryxSC0()

nCont:=0
QUERY->( dbEval( {|| nCont++ } ) )
QUERY->( dbGoTop() )
oReport:SetMeter(nCont)		// Total de Elementosadmin	 da regua

oSection:Init()
QUERY->(DbgoTop())

While(!QUERY->(Eof()))
	oReport:IncMeter()  
	oSection:Cell("Filial")				:SetBlock( { || QUERY->C0_FILIAL 			} )
	oSection:Cell("Reserva")				:SetBlock( { || QUERY->C0_NUM			} )
	oSection:Cell("Produto")			:SetBlock( { || QUERY->C0_PRODUTO			} )
	oSection:Cell("Quantidade")			:SetBlock( { || QUERY->C0_QUANT 			} )
	oSection:Cell("Ticket")				:SetBlock( { || QUERY->C0_XCSSNUM			} )
	oSection:Cell("Obs")				:SetBlock( { || QUERY->C0_OBS				} )
	oSection:PrintLine()
	QUERY->(DbSkip())
EndDo

QUERY->(DbCloseArea())

oSection:Finish()
oSection:Print()      

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Validperg ºAutor  ³º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VALIDPERG(cPerg)

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5                                                              

PutSX1(cPerg,"01","Data De??"			,"Data De?"				,"Date From?"		,"mv_ch1" ,"D" ,TamSx3("C0_EMISSAO")[1]	,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Data Ate?"			,"Data Ate?"			,"Date To?"			,"mv_ch2" ,"D" ,TamSx3("C0_EMISSAO")[1]	,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Ticket De"			,"Ticket De?"			,"Ticket From?"		,"mv_ch3" ,"C" ,TamSx3("C0_XCSSNUM")[1]	,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ticket Ate"			,"Ticket Ate?"			,"Ticket To?"		,"mv_ch4" ,"C" ,TamSx3("C0_XCSSNUM")[1]	,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Status Reserva"		,"Status Reserva"		,"Reserv Status"	,"mv_ch5" ,"C" ,10						,0,0,"C","",""		,"",,"mv_par05","Em aberto","","","" ,"Consumida","","","","","","","","","","","")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QryRel ºAutor André Jaar - ErpWorks ³º Data ³  14/04/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Query do relatório                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function QryxSC0()

Local cQuery	:= ""

If SELECT("QUERY") > 0     //Caso haja uma TRB em aberto, Fecha
	DbSelectArea("QUERY")
	DbCloseArea("QUERY")
EndIf

cQuery := " SELECT * "+CHR(13)+CHR(10)
cQuery += " FROM "+RetSqlName("SC0")+" SC0 "+CHR(13)+CHR(10)
cQuery += " WHERE C0_FILIAL = '"+xFilial("SC0")+"' "+CHR(13)+CHR(10) 
cQuery += " AND C0_EMISSAO BETWEEN "+DtoS(MV_PAR01)+" AND "+DtoS(MV_PAR02)+" "
cQuery += " AND C0_XCSSNUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CHR(13)+CHR(10)
cQuery += " AND C0_QUANT "+IIF(MV_PAR05 = 1,"> 0","< 0")+" "+CHR(13)+CHR(10)
cQuery += " AND SC0.D_E_L_E_T_ = '' "+CHR(13)+CHR(10)
cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

Return()                   
