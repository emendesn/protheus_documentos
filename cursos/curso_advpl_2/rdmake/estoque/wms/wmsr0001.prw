#INCLUDE "DLGR220.ch"
#Include "FIVEWIN.CH"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WMSR0001 ³ Autor ³ Flavio Luiz Vicco     ³Data  ³17/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Operacoes executadas por um funcionario          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAWMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function WMSR0001()
Local oReport

u_GerA0003(ProcName())

AjustaSX1()

oReport:= ReportDef()
oReport:PrintDialog()

Return NIL
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Flavio Luiz Vicco      ³Data  ³17/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Operacoes executadas por um funcionario          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01: nReg = Registro posicionado do SC3 apartir Browse  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local cAliasNew := "SDB"
Local cTitle    := OemToAnsi(STR0001) //"Mapa de Separacao"
Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oBreak1
dbSelectArea(cAliasNew)
dbSetOrder(1)
#IFDEF TOP
	cAliasNew := GetNextAlias()
#ENDIF

oReport := TReport():New("WMSR0001",cTitle,"DLR220",{|oReport| ReportPrint(oReport,cAliasNew)},STR0001) //"Mapa de Separacao"

Pergunte(oReport:uParam,.F.)

oSection1:= TRSection():New(oReport,STR0019+' - '+STR0008,{"SDB"},/*aOrdem*/) //"Movimentos por endereco - Estrutura"
oSection1:SetCharSeparator("")
TRCell():New(oSection1,"DB_ESTFIS",	"SDB",STR0008+' : ') //"Estrutura : "
TRCell():New(oSection1,"CDESEST",	"",STR0022,,30,,{||If(lQuery,(cAliasNew)->DC8_DESEST,Posicione('DC8',1,xFilial('DC8')+(cAliasNew)->DB_ESTFIS,'DC8_DESEST'))}) //"Descrição"
TRCell():New(oSection1,"DB_DOC",	"SDB",STR0009) //"Pedido : "
oSection1:SetLineStyle()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:= TRSection():New(oSection1,STR0019+' - '+STR0020,{"SDB","SB1"},/*aOrdem*/) //"Movimentos por endereco - Endereco"
oSection2:SetHeaderPage()
oSection2:SetLineBreak()
TRCell():New(oSection2,"DB_LOCALIZ",	"SDB")
TRCell():New(oSection2,"DB_PRODUTO",	"SDB")
TRCell():New(oSection2,"B1_UM",			"SB1")
TRCell():New(oSection2,"B1_DESC",		"SB1",,,30)
TRCell():New(oSection2,"NQTDSEP",		"","Qtde Separada",PesqPict("SDB","DB_QUANT")) //"Quantidade"
TRCell():New(oSection2,"NSALDO",		"","Saldo",PesqPict("SDB","DB_QUANT")) //"Saldo"
TRCell():New(oSection2,"LACUNA3",		"",STR0025,,18,,{||"__________________"}) //"Anormalidades"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3:= TRSection():New(oSection2,STR0019+' - '+STR0021,{"SDB"},/*aOrdem*/) //"Movimentos por endereco - Recurso Humano"
TRCell():New(oSection3,"SEPARADOR", "",STR0013,,43,,{||" _______________________   ___:___   ___:___"}) //"Separador :"
TRCell():New(oSection3,"CONFERENTE","",STR0014,,43,,{||" _______________________   ___:___   ___:___"}) //"Conferente :"
oSection3:SetLineStyle()
oSection3:SetCharSeparator("")
Return(oReport)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Flavio Luiz Vicco     ³Data  ³17/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de monitoramento de servicos                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasNew)
Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(1):Section(1)
Local oSection3  := oReport:Section(1):Section(1):Section(1)
Local lWmsACar   := (SuperGetMV('MV_WMSACAR', .F., 'S')=='S')
Local cQuery     := ""
Local cChave     := ""
Local cCondWhile := ""
Local cValoWhile := ""
Local nQtdSep    := 0
Local nSaldo     := 0
Local nUMI       := 0
Local n1UM       := 0
Local n2UM       := 0
Local aQtdUni    := {}
Local cCodCFG    := ""
Local cPicCFG    := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "%"+cQuery+"%"

cChave := "SDB_1.DB_DOC,SDB_1.DB_LOCALIZ,SDB_1.DB_PRODUTO,SDB_1.DB_LOCAL"

cChave := "%"+cChave+"%"
oSection1:BeginQuery()
BeginSql Alias cAliasNew
	//-->
	/*
	SELECT	SDB.DB_FILIAL,SDB.DB_LOCAL,SDB.DB_LOCALIZ,SDB.DB_DOC,SUM(SDB.DB_QUANT) AS DB_QUANT,
		SDB.DB_SERVIC,SDB.DB_TAREFA,SDB.DB_ATIVID,SDB.DB_TM,SDB.DB_ATUEST,SDB.DB_PRODUTO, SDB.DB_ESTFIS, 
		(
			SELECT SUM(DB_QUANT) FROM %table:SDB% SDB_1 WHERE SDB_1.DB_FILIAL= %xFilial:SDB% 
			AND SDB_1.DB_DOC=SDB.DB_DOC AND SDB_1.DB_LOCALIZ=SDB.DB_LOCALIZ 
			AND SDB_1.DB_PRODUTO=SDB.DB_PRODUTO AND SDB_1.DB_TM > '500' AND SDB_1.DB_ESTORNO = ' '	
			AND SDB_1.DB_ATUEST = 'S' AND SDB_1.%NotDel%
		) AS QTDSEP
	FROM %table:SDB% SDB
	WHERE DB_FILIAL   = %xFilial:SDB%
		AND   DB_TM     >  '500'
		AND   DB_SERVIC >= %Exp:mv_par01%
		AND   DB_SERVIC <= %Exp:mv_par02%
		AND   DB_TAREFA >= %Exp:mv_par03%
		AND   DB_TAREFA <= %Exp:mv_par04%
		AND   DB_ATIVID >= %Exp:mv_par05%
		AND   DB_ATIVID <= %Exp:mv_par06%
		AND   DB_DOC    >= %Exp:mv_par07%
		AND   DB_DOC    <= %Exp:mv_par08%
		AND   DB_CARGA  >= %Exp:mv_par09%
		AND   DB_CARGA  <= %Exp:mv_par10%
		AND   DB_ATUEST  = 'N'
		AND   SDB.%NotDel%
	%Exp:cQuery%
	GROUP BY SDB.DB_FILIAL,SDB.DB_LOCAL,SDB.DB_LOCALIZ,SDB.DB_DOC,SDB.DB_SERVIC,SDB.DB_TAREFA,SDB.DB_ATIVID,SDB.DB_TM,SDB.DB_ATUEST,SDB.DB_PRODUTO, SDB.DB_ESTFIS
	ORDER BY %Exp:cChave%
	*/
	SELECT SDB_1.DB_FILIAL,SDB_1.DB_LOCAL,SDB_1.DB_LOCALIZ,SDB_1.DB_DOC,DCF.DCF_QUANT AS QTDCF, SDB_1.DB_QUANT AS QTDORI,
		SDB_1.DB_SERVIC,SDB_1.DB_TAREFA,SDB_1.DB_ATIVID,SDB_1.DB_TM,SDB_1.DB_ATUEST,SDB_1.DB_PRODUTO, 
		SDB_1.DB_ESTFIS,  SDB_1.DB_QUANT,SDB_2.DB_QUANT AS QTDSEP
	FROM %table:DCF% DCF
	LEFT JOIN %table:SDB% SDB_1 ON (SDB_1.DB_FILIAL=%xFilial:SDB%  AND SDB_1.DB_DOC=DCF_DOCTO 
		AND SDB_1.DB_PRODUTO=DCF_CODPRO AND SDB_1.DB_TM > '500' AND SDB_1.DB_ESTORNO = ' ' 
		AND SDB_1.DB_ATUEST = 'N' AND SDB_1.%NotDel%)
	
	LEFT JOIN %table:SDB% SDB_2 ON (SDB_2.DB_FILIAL= %xFilial:SDB%  AND SDB_2.DB_DOC=DCF_DOCTO 
		AND SDB_2.DB_PRODUTO=DCF_CODPRO AND SDB_2.DB_TM > '500' AND SDB_2.DB_ESTORNO = ' ' 
		AND SDB_2.DB_ATUEST = 'S' AND SDB_1.DB_LOCALIZ=SDB_2.DB_LOCALIZ AND SDB_2.%NotDel%)
	WHERE DCF_FILIAL = %xFilial:DCF% 
	AND DCF_SERVIC BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND DCF_DOCTO BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
	AND DCF.%NotDel%
	%Exp:cQuery%
	ORDER BY %Exp:cChave%
	
	//-->
EndSql
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo EndQuery ( Classe TRSection )                                    ³
//³                                                                        ³
//³Prepara o relatório para executar o Embedded SQL.                       ³
//³                                                                        ³
//³ExpA1 : Array com os parametros do tipo Range                           ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:EndQuery(/*Array com os parametros do tipo Range*/)

TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1")+(cAliasNew)->DB_PRODUTO } )
oBreak1 := TRBreak():New(oSection2,{||(cAliasNew)->(&cCondWhile) },,.F.,,.T.)

cCondWhile := If(mv_par14==1,"DB_ESTFIS+","")+"DB_DOC"


oSection1:Cell("CDESEST"):HideHeader()
oSection2:SetParentQuery()
oSection3:SetParentQuery()
oSection1:Init()
oSection2:Init()
oSection3:Init()
While !oReport:Cancel() .And. !(cAliasNew)->(Eof())
	oReport:IncMeter()
	If	oReport:Cancel()
		Exit
	EndIf
		
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->DB_PRODUTO))
	
	SB5->(dbSetOrder(1))
	SB5->(dbSeek(xFilial("SB5")+(cAliasNew)->DB_PRODUTO))
	
	nQtdSep := IIF((cALiasNew)->QTDORI > 0,(cALiasNew)->QTDORI,(cALiasNew)->QTDCF)
	
	nSaldo := IIF((cALiasNew)->QTDSEP > 0, nQtdSep-(cALiasNew)->QTDSEP,nQtdSep)
	
	oSection2:Cell("NQTDSEP"):SetValue(nQtdSep)
	oSection2:Cell("NSALDO"):SetValue(nSaldo)
	
	
	If	cCodCFG <> SBE->BE_CODCFG // Verifica se o codigo mudou
		If	SBE->(dbSeek(xFilial("SBE")+(cAliasNew)->(DB_LOCAL+DB_LOCALIZ)))
			cCodCFG := SBE->BE_CODCFG // Atualiza flag
			cPicCFG := DLXPicEnd(SBE->BE_CODCFG) // Atualiza Picture
			oSection2:Cell("DB_LOCALIZ"):SetPicture(cPicCFG)
		EndIf
	EndIf
	//-->
	If	cValoWhile <> &cCondWhile
		cValoWhile := &cCondWhile
		oSection1:PrintLine()
	EndIf
	oSection2:PrintLine()
	(cAliasNew)->(dbSkip())
	If	cValoWhile <> &cCondWhile
		oSection3:PrintLine()
		oSection2:Finish()
		oSection2:Init()
		oReport:EndPage()
	EndIf
EndDo
oSection1:Finish()
oSection2:Finish()
oSection3:Finish()
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Flavio Luiz Vicco     ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local cPerg      := "DLR220"
Local aHelpPor12 := {'Imprime ou nao as informacoes referentes', 'ao Controle de Rastreabilidade (LOTE e  ', 'SUBLOTE)'}
Local aHelpEsp12 := {'Imprime ou nao as informacoes referentes', 'ao Controle de Rastreabilidade (LOTE e  ', 'SUBLOTE)'}
Local aHelpEng12 := {'Imprime ou nao as informacoes referentes', 'ao Controle de Rastreabilidade (LOTE e  ', 'SUBLOTE)'}
Local aHelpPor13 := {'Especifica se as Quantidades deverao ser', 'impressas na 1aUM ou na Unidade de Medi-', 'da Industrial'}
Local aHelpEsp13 := {'Especifica se as Quantidades deverao ser', 'impressas na 1aUM ou na Unidade de Medi-', 'da Industrial'}
Local aHelpEng13 := {'Especifica se as Quantidades deverao ser', 'impressas na 1aUM ou na Unidade de Medi-', 'da Industrial'}
Local aHelpPor14 := {'Especifica se o Relatorio tera ou nao   ', 'Quebra de pagina por Estrutura Fisica   ', ''}
Local aHelpEsp14 := {'Especifica se o Relatorio tera ou nao   ', 'Quebra de pagina por Estrutura Fisica   ', ''}
Local aHelpEng14 := {'Especifica se o Relatorio tera ou nao   ', 'Quebra de pagina por Estrutura Fisica   ', ''}
Local aHelpPor15 := {'Permite ocultar as Quantidades para que ', 'seja feita uma Conferencia Cega com base', 'nas informacoes do Relatorio'}
Local aHelpEsp15 := {'Permite ocultar as Quantidades para que ', 'seja feita uma Conferencia Cega com base', 'nas informacoes do Relatorio'}
Local aHelpEng15 := {'Permite ocultar as Quantidades para que ', 'seja feita uma Conferencia Cega com base', 'nas informacoes do Relatorio'}
PutSx1(cPerg, '12', 'Imprimir Lote      ?', 'Imprimir Lote      ?', 'Imprimir Lote      ?', 'mv_chc', 'N', 1, 0, 2, 'C','','','','', 'mv_par12', 'Sim', 'Si', 'Yes','', 'Nao', 'No', 'No','','','','','','','','','', aHelpPor12, aHelpEsp12, aHelpEng12)
PutSx1(cPerg, '13', 'Imprimir U.M.I.    ?', 'Imprimir U.M.I.    ?', 'Imprimir U.M.I.    ?', 'mv_chd', 'N', 1, 0, 2, 'C','','','','', 'mv_par13', 'Sim', 'Si', 'Yes','', 'Nao', 'No', 'No','','','','','','','','','', aHelpPor13, aHelpEsp13, aHelpEng13)
PutSx1(cPerg, '14', 'Quebra por Estrut. ?', 'Quebra por Estrut. ?', 'Quebra por Estrut. ?', 'mv_che', 'N', 1, 0, 2, 'C','','','','', 'mv_par14', 'Sim', 'Si', 'Yes','', 'Nao', 'No', 'No','','','','','','','','','', aHelpPor14, aHelpEsp14, aHelpEng14)
PutSx1(cPerg, '15', 'Oculta Quantidades ?', 'Oculta Quantidades ?', 'Oculta Quantidades ?', 'mv_chf', 'N', 2, 0, 2, 'C','','','','', 'mv_par15', 'Sim', 'Si', 'Yes','', 'Nao', 'No', 'No','','','','','','','','','', aHelpPor15, aHelpEsp15, aHelpEng15)
Return Nil
