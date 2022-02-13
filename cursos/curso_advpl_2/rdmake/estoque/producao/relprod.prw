#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACOMPRDI ³ Autor ³ Eduardo Barbosa( Delta)³Data ³ 08/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio  Produçao Diaria                                  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP - BGH                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RELPROD()

Local oReport

u_GerA0003(ProcName())
cPerg := "RLPROD"
ValPerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= ReportDef()     
// Seleciona Dados e Atualiza TRB Para Impressao
oReport:SetTotalInLine(.F.)  
oReport:PrintDialog()
	
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Eduardo Barbosa( Delta)³Data ³ 08/03/12         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()
Local oReport
Local oSection1, oSection2
Local cTitle	:= "Producao Diaria" 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New("ACOMPRDI",cTitle,cPerg, {|oReport| ReportPrint(oReport)},OemToAnsi("Este Programa Ira Imprimir O Relatorio de Producao Diaria")) 

oReport:SetPortrait()     // Define a orientacao de pagina do relatorio como retrato.
oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
oReport:nFontBody	:= 10 // Define o tamanho da fonte.
oReport:nLineHeight	:= 50 // Define a altura da linha.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da secao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a secao.                   ³
//³ExpA4 : Array com as Ordens do relatorio                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1 (oSection1)                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Acompanhamento de Producao",{"TRB1"}) 
//oSection1:SetLineStyle() //Define a impressao da secao em linha
//oSection1:SetReadOnly()

TRCell():New(oSection1,'DATALANC'   ,'TRB1',"Data "  ,"@!",15,/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROD'		,'TRB1',"Produto","@!"                        ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'OS'	    	,'TRB1',"OS","@!"                        ,06,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'IMEI'	    ,'TRB1',"IMEI","@!"                        ,TamSX3("ZZ4_IMEI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DOCSEP'    	,'TRB1',"Doc Separacao","@!"                        ,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MODELO'		,'TRB1',"Modelo","@!"                        ,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CELULA'		,'TRB1',"Celula","@!"                        ,06,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TURNO'		,'TRB1',"Nome Celula","@!"                        ,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QTDPROD' 	,'TRB1',"Qtd Produzida"  ,PesqPict("ZZY","ZZY_QTDPLA"),TamSX3("ZZY_QTDPLA")[1],/*lPixel*/ ,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'OPERACAO'	,'TRB1',"Operação","@!"                        ,03,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DESCOP'		,'TRB1',"Descrição Operação","@!"                        ,30,/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Eduardo Barbosa      ³ Data ³08/03/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATR820                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Local oSection1	:= oReport:Section(1)
Local oBreak

// Seleciona Dados
FGRVTRB1()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetMeter(TRB1->(LastRec()))
oSection1:Init()

dbSelectArea("TRB1")
DbGoTop()
While !oReport:Cancel() .And. !TRB1->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definindo o titulo do Relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetTitle("RELATORIO DE PRODUCAO ") 

	//Impressao da Section 1
	oSection1:PrintLine()
	dbSelectArea("TRB1")
	dbSkip()

EndDo
oSection1:Finish()
dbSelectArea("TRB1")
DbGoTop()

Return Nil

        
        
Static Function FGRVTRB1()

Local aCampos := {}

AADD(aCampos,{"PROD"		,"C",15,0})
AADD(aCampos,{"OS"   		,"C",06,0})
AADD(aCampos,{"IMEI"   		,"C",TamSX3("ZZ4_IMEI")[1],0})
AADD(aCampos,{"DOCSEP" 		,"C",10,0})
AADD(aCampos,{"DATALANC" 	,"D",08,0})
AADD(aCampos,{"MODELO"		,"C",04,0})
AADD(aCampos,{"CELULA"		,"C",06,0})
AADD(aCampos,{"TURNO"		,"C",40,0})
AADD(aCampos,{"QTDPROD"		,"N",14,2})
AADD(aCampos,{"OPERACAO"	,"C",03,0})
AADD(aCampos,{"DESCOP"		,"C",40,0})


cTrabDi:=CriaTrab(aCampos)
_cIndex := Criatrab(,.F.)
If SELECT("TRB1") <> 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif

dbUseArea(.T.,,cTrabDi,"TRB1",.T.,.F.)
//IndRegua("TRB1",_cIndex,"CHAVE",,,"Criando Indice")
IndRegua("TRB1",_cIndex,"DTOS(DATALANC)+MODELO+CELULA+OPERACAO",,,"Criando Indice")

// Montagem da Query Para selecao dos dados
cQuery := " SELECT 
If MV_PAR05 == 2
	cQuery += " ZZ4_CODPRO AS PROD,ZZ4_OS AS OS,ZZ4_IMEI AS IMEI,ZZ4_DOCSEP AS DOCSEP, "
Endif
cQuery += " ZZ3_DATA,B1_GRUPO AS MODELO,ZZ3_CODANA,ZZ4_OPEBGH,LEFT(ZZ3_HORA,2) AS HORA,COUNT(*) AS QTDE "
cQuery += " FROM "+RETSQLNAME("ZZ3")+" ZZ3, "+RETSQLNAME("ZZ2")+" ZZ2, "+RETSQLNAME("ZZ4")+" ZZ4, "+RETSQLNAME("ZZ1")+" ZZ1, "+RETSQLNAME("SB1")+" SB1 "
cQuery += " WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"'"
cQuery += " AND ZZ1_FILIAL='"+xFilial("ZZ1")+"'"
cQuery += " AND ZZ2_FILIAL='"+xFilial("ZZ2")+"'"
cQuery += " AND ZZ4_FILIAL='"+xFilial("ZZ4")+"'"
cQuery += " AND B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND ZZ4_IMEI=ZZ3_IMEI "
cQuery += " AND ZZ4_OS=ZZ3_NUMOS "
cQuery += " AND ZZ4_STATUS>='4' "
cQuery += " AND ZZ2_LAB='2'  "
cQuery += " AND ZZ2_CODSET=ZZ3_CODSET "
cQuery += " AND ZZ3_DATA BETWEEN '"+DTOS(MV_PAR01) +"' AND '"+DTOS(MV_PAR02+1)+"'"
cQuery += " AND NOT(ZZ4_OPEBGH IN ('N01','N10','N11') AND ZZ3_FASE1 IN ('41')) "//SOLICITACAO DA USUARIA HELIDA - GLPI 19704
cQuery += " AND ZZ1_CODSET=ZZ3_CODSET "
cQuery += " AND ZZ1_FASE1=ZZ3_FASE1 "
cQuery += " AND ZZ1_LAB='2' "
cQuery += " AND ZZ1_SCRAP<>'S' "     
cQuery += " AND ZZ1_DESFA1  NOT LIKE '%EOL%' "
cQuery += " AND ZZ1.D_E_L_E_T_='' "
cQuery += " AND ZZ2.D_E_L_E_T_='' "
cQuery += " AND ZZ3.D_E_L_E_T_='' "
cQuery += " AND ZZ4.D_E_L_E_T_='' "
cQuery += " AND ZZ3_ENCOS='S' "
cQuery += " AND ZZ3_ESTORN <>'S' "
cQuery += " AND ZZ4_OPEBGH IN "+FormatIn(mv_par04,";") //('N01','N10','N11') "
cQuery += " AND B1_COD = ZZ4_CODPRO "
If !Empty(MV_PAR03)
	cQuery += " AND B1_GRUPO LIKE '%"+Alltrim(MV_PAR03)+"%'"
Endif

cQuery += " GROUP BY "
If MV_PAR05 == 2
	cQuery += " ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI,ZZ4_DOCSEP, "
Endif
cQuery += " ZZ3_DATA,ZZ4_OPEBGH,B1_GRUPO,ZZ3_CODANA,LEFT(ZZ3_HORA,2) "
cQuery += " ORDER BY "
If MV_PAR05 == 2
	cQuery += " ZZ4_CODPRO,ZZ4_OS,ZZ4_IMEI,ZZ4_DOCSEP,"
Endif
cQuery += " ZZ3_DATA,ZZ4_OPEBGH,B1_GRUPO,ZZ3_CODANA,LEFT(ZZ3_HORA,2) "

If SELECT("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TcSetField("TRB","ZZ3_DATA","D",8,0)
TcSetField("TRB","QTDE","N",14,0)
While ! Eof()  
      _nHora := Val(TRB->HORA)
      
      If (TRB->ZZ3_DATA  == MV_PAR01 .AND. _nHora < 06) .OR.;
         (TRB->ZZ3_DATA > MV_PAR02 .AND. _nHora >=06)  // Descarta o Primeiro e segundo Turno do Dia  Anterior e descarta tereiro Turno do ultimo dia.
         DbSkip()
         Loop
      Endif
      
      _dData := TRB->ZZ3_DATA
      If _nHora <=05 
         _dData := TRB->ZZ3_DATA-1
      Endif   
      If MV_PAR05 == 1
	      DbSelectArea("TRB1")
	      DbSetOrder(1)
	      If DbSeek(DTOS(_dData)+TRB->MODELO+TRB->ZZ3_CODANA+TRB->ZZ4_OPEBGH,.F.)
	         RecLock("TRB1",.F.)
	      Else
	         RecLock("TRB1",.T.)
	          TRB1->DATALANC := _dData
	          TRB1->MODELO	:= TRB->MODELO
	          TRB1->CELULA	:= TRB->ZZ3_CODANA
	          TRB1->TURNO   := Posicione("AA1",1,xFilial("AA1")+TRB->ZZ3_CODANA,"AA1_NOMTEC")
	          TRB1->OPERACAO:= TRB->ZZ4_OPEBGH
	          TRB1->DESCOP  := Posicione("ZZJ",1,xFilial("ZZJ")+TRB->ZZ4_OPEBGH,"ZZJ_DESCRI")
	      Endif
	      TRB1->QTDPROD := TRB1->QTDPROD + TRB->QTDE
	      MsUnlock()
	   Else
          RecLock("TRB1",.T.)
       	  TRB1->PROD	:= TRB->PROD
       	  TRB1->OS      := TRB->OS
       	  TRB1->IMEI    := TRB->IMEI
       	  TRB1->DOCSEP  := TRB->DOCSEP
          TRB1->DATALANC := _dData
          TRB1->MODELO	:= TRB->MODELO
          TRB1->CELULA	:= TRB->ZZ3_CODANA
          TRB1->TURNO   := Posicione("AA1",1,xFilial("AA1")+TRB->ZZ3_CODANA,"AA1_NOMTEC")
          TRB1->OPERACAO:= TRB->ZZ4_OPEBGH
          TRB1->DESCOP  := Posicione("ZZJ",1,xFilial("ZZJ")+TRB->ZZ4_OPEBGH,"ZZJ_DESCRI")
          TRB1->QTDPROD := TRB->QTDE
          MsUnlock()
        Endif
      
      DbSelectArea("TRB")
      DbSkip()
Enddo
If SELECT("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

Return      


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALPERG ³ Autor ³ Ricardo Berti         ³ Data ³21/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria pergunta para o grupo			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValPerg(cPerg)

Local aHelp	:= {}

PutSx1(cPerg, '01', 'Producao de         ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Producao Ate        ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Produto             ?','' ,'' , 'mv_ch3', 'C', 4, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Operações           ?','' ,'' , 'mv_ch4', 'C', 60, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Tipo Relatorio      ?','' ,'' , 'mv_ch5', 'N', 01, 0,01 ,'C', '', '' , '', '' , 'mv_par05',"Sintetico"," "," ","","Analitico","","","","","","","","")

Return          


        