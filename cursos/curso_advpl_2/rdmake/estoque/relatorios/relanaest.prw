#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Analise de Estoque³ Autor ³ Edson Estevam Data ³ 21/12/11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Posição de estoque de produtos desconsiderando o    ±±
±±³          ³ saldo do Buffer e requisições em aberto 			           ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque  - BGH                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELANAEST()

Local oReport

Private _cQuebra := " "

u_GerA0003(ProcName())

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Luciano Siqueira      ³ Data ³ 21/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque / Custos - AOC                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "XANAES"

ValPerg(cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New("RELANAEST","Resumo de estoque",cPerg,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Resumo dos saldos de produtos desconsiderando o BUFFER e Requisições 998 em Aberto")


oSection2 := TRSection():New(oReport,OemToAnsi("Resumo de Estoque"),{"TRB"})

TRCell():New(oSection2,"COD"         ,"TRB","CODIGO"  ,"@!",15)
TRCell():New(oSection2,"DESCRICAO"   ,"TRB","DESCRICAO"   ,"@!",50)
TRCell():New(oSection2,"Armazem"     ,"TRB","ARMAZEM" ,"@!",20)
TRCell():New(oSection2,"QTD"         ,"TRB","SALDO ATUAL","@E 99,999,999.99",0)
TRCell():New(oSection2,"QTD2"        ,"TRB","BUFFER" ,"@E 99,999,999.99",0)
TRCell():New(oSection2,"QTD3"        ,"TRB","SALDO WMS"   ,"@E 99,999,999.99",0)
TRCell():New(oSection2,"QTD4"        ,"TRB","TOTAL REAL"   ,"@E 99,999,999.99",0)
oSection2:Cell("QTD"	 ):SetHeaderAlign("LEFT") 
oSection2:Cell("QTD"	 ):SetAlign("LEFT") 
oSection2:Cell("QTD2" ):SetHeaderAlign("LEFT")
oSection2:Cell("QTD2" ):SetAlign("LEFT")

oBreak1 := TRBreak():New(oSection2,oSection2:Cell("COD"),{ || "Sub-Total COD --> "+_cQuebra},.F.)



Return oReport


// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection2 := oReport:Section(1)
oSection2:SetTotalInLine(.F.)
oSection2:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)


// Selecao dos dados a Serem Impressos
MsAguarde({|| fSeleDados()},"Selecionando Itens")

// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()
_cQuebra := TRB->COD

oReport:SetMeter(RecCount())
oSection2:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection2:PrintLine()
	
	If TRB->COD <> _cQuebra
		_cQuebra := TRB->COD
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection2:Finish()

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return


// Selecao dos dados a serem impressos


Static Function fSeleDados()




// Criacao arquivo de Trabalho
_aStru	:= {}


AADD(_aStru,{"COD"    ,"C",15,0})
AADD(_aStru,{"DESCRICAO"   ,"C",30,0})
AADD(_aStru,{"Armazem"  ,"C",02,0})
AADD(_aStru,{"QTD"    ,"N",10,0})
AADD(_aStru,{"QTD2"   ,"N",10,0})
AADD(_aStru,{"QTD3"   ,"N",10,0})
AADD(_aStru,{"QTD4"   ,"N",10,0})


_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	:= "COD+Armazem"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

_cCgcEmp := Left(SM0->M0_CGC,8)

_cQuery := "SELECT B2_COD,B2_LOCAL,B1_DESC,B2_QATU AS SALDO_SB2,SALDO_BUFFER,SALDO_WMS,( B2_QATU - SALDO_BUFFER - SALDO_WMS ) AS SALDO_REAL "
_cQuery += " FROM  (SELECT B2_COD,B2_LOCAL,B1_DESC,B2_QATU, "
_cQuery += " ISNULL( ( SELECT SUM(BF_QUANT-BF_EMPENHO) "
_cQuery += " FROM "  + RetSQLName ("SBF") +" SBF  "
_cQuery += " WHERE BF_FILIAL = '"+xFilial("SBF")+"' "              
_cQuery += " AND BF_PRODUTO = B2_COD "
_cQuery += " AND BF_LOCAL = B2_LOCAL "
_cQuery += " AND BF_LOCALIZ = 'BUFFER' "
_cQuery += " AND SBF.D_E_L_E_T_ <> '*' ),0) AS SALDO_BUFFER, "
_cQuery += " ISNULL(( SELECT SUM(D3_QUANT) "
_cQuery += " FROM " + RetSQLName ("SD3") +" SD3 "
_cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"' "              
_cQuery += " AND D3_COD = B2_COD "
_cQuery += " AND D3_LOCAL = B2_LOCAL "
_cQuery += " AND D3_TM = '998' "
_cQuery += " AND D3_ESTORNO <> 'S' "
_cQuery += " AND SD3.D_E_L_E_T_ <> '*'),0)  AS SALDO_WMS "
_cQuery += " FROM " + RetSQLName ("SB2") + " SB2  "
_cQuery +=     " LEFT JOIN " + RetSQLName ("SB1") + " SB1  ON (B1_COD = B2_COD AND SB1.D_E_L_E_T_ <> '*' ) "
_cQuery +=     " WHERE B2_FILIAL = '"+xFilial("SB2")+"' "              
_cQuery +=     " AND B2_QATU > 0 "
_cQuery +=     " AND SB2.D_E_L_E_T_ <> '*' "
_cQuery +=     " AND B2_COD BETWEEN  '"+MV_PAR01+"'  AND '"+MV_PAR02+"'"
_cQuery +=     " AND B2_LOCAL BETWEEN  '"+MV_PAR03+"'  AND '"+MV_PAR04+"'"
_cQuery +=     " ) AS TRB1 "
_cQuery +=     " ORDER BY B2_COD "


//* Verifica se a Query Existe, se existir fecha
If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)

dbSelectArea("TSQL1")
dbGotop()

Do While TSQL1->(!Eof())  

    
	_nSalDCF  := 0 
	_nSalDCF  :=  U_SALDCF(TSQL1->B2_COD,TSQL1->B2_LOCAL)
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->Armazem    := TSQL1->B2_LOCAL  //LOCAL
	TRB->COD    	:= TSQL1->B2_COD    //PRODUTO
	TRB->DESCRICAO  := TSQL1->B1_DESC  // DESCRICAO
	TRB->QTD  		:= TSQL1->SALDO_SB2  //SALDO ATUAL
	TRB->QTD2       := TSQL1->SALDO_BUFFER  // QUANTIDADE NO BUFFER
	TRB->QTD3       := _nSalDCF//TSQL1->SALDO_WMS -- QUANTIDADE QUE ESTÁ EM ABERTO NO SD3 COM MOVIMENTO 998
	TRB->QTD4       := (TSQL1->SALDO_SB2-TSQL1->SALDO_BUFFER-_nSalDCF)//TSQL1->SALDO_REAL  -- RESULTADO( SALDO ESTOQUE - BUFFER - REQUISIÇÕES EM ABERTO(TM 998))
	MsUnlock()
	
	dbSelectArea("TSQL1")
	DbSkip()
Enddo

If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf



Return

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'PRODUTO de            ?','' ,'' , 'mv_ch1', 'C', 10, 0,0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'PRODUTO Ate           ?','' ,'' , 'mv_ch2', 'C', 10, 0,0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Armazem de            ?','' ,'' , 'mv_ch3', 'C', 02, 0,0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Armazem Ate           ?','' ,'' , 'mv_ch4', 'C', 02, 0,0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')

Return 
    