#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"

#DEFINE DIRTEMP  "C:\TEMP\"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRVRCB     บAutor  ณGraziella Bainchin  บ Data ณ  20/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRELATORIO DE VARIACAO CAMBIAL - DESENVOLVIDO DE ACRODO COM  บฑฑ
ฑฑบ          ณAS ESPECIFICACOES DA USUARIA JESSICA E LUZIA DO FINANCEIRO  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณUSO ESPECIFICO DA EMPRESA BGH                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RVRCB()

Private cPerg	 := "RVRCB"
Private _csrvapl := ALLTRIM(GetMV("MV_SERVAPL"))

if ! Pergunte(cPerg,.T.)
	Return()
Endif

Processa( { ||RELRVRCB() } )

Return .T.

Static Function RELRVRCB()
Local cQuery1 	:= ""
Local cDirDocs	:= Alltrim(__RelDir)
Local cCrLf		:= Chr(13)+Chr(10)
Local cArquivo	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

nHandle 		:= MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

u_GerA0003(ProcName())

IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltra titulos baixados  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery1 += " SELECT E2_MOEDA, E2_FILIAL, E2_PREFIXO, E2_NUM, "
cQuery1 += " E2_TIPO, E2_NATUREZ, E2_FORNECE, "
cQuery1 += " E2_LOJA, E2_NOMFOR, E2_EMISSAO,  "
cQuery1 += " E2_VENCREA, E2_VALOR, E2_DIVNEG, E5_DOCUMEN, E5_TIPODOC, "
cQuery1 += " E2_CCD, E2_EMIS1, E2_SALDO, E5_VALOR, 
cQuery1 += " E2_TXMOEDA, E2_BAIXA, E5_DATA, SE5.E5_TXMOEDA AS TAXA, 
cQuery1 += " SE5.E5_VLMOED2 AS VLR_BAIXA, "
cQuery1 += " SE5.R_E_C_N_O_ AS RECSE5, "
cQuery1 += " SE5.E5_MOTBX "

cQuery1 += " FROM " +Retsqlname ("SE2") + " SE2 "

cQuery1 += " INNER JOIN "+RetSqlName("SE5")+" SE5 ON SE5.E5_FILIAL = SE2.E2_FILIAL AND SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
cQuery1 += " SE5.E5_FORNECE = SE2.E2_FORNECE AND "
cQuery1 += " SE5.E5_PARCELA = SE2.E2_PARCELA AND  "
cQuery1 += " SE5.E5_NUMERO = SE2.E2_NUM  AND SE5.E5_TIPODOC IN ('VL','CP','BA') AND SE5.D_E_L_E_T_ = '' "

cQuery1 += " WHERE E2_FILIAL >= '"+(MV_PAR01)+"' AND E2_FILIAL <= '"+(MV_PAR02)+"' "
cQuery1 += "   AND E2_FORNECE>= '"+(MV_PAR03)+"' AND E2_FORNECE<= '"+(MV_PAR04)+"' "
cQuery1 += "   AND E2_LOJA   >= '"+(MV_PAR05)+"' AND E2_LOJA   <= '"+(MV_PAR06)+"' "
cQuery1 += "   AND E5_DATA>= '"+DTOS(MV_PAR08)+"' AND E5_DATA<= '"+DTOS(MV_PAR09)+"' "
cQuery1 += "   AND SE2.D_E_L_E_T_ = ' ' "
cQuery1 += "   AND E2_MOEDA IN ('2','5')   "
cQuery1 += "   AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
cQuery1 += "   AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")
cQuery1 += "   AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")

IF MV_PAR07 = 1
	cQuery1 += "ORDER BY E2_FORNECE, E2_LOJA "
ELSEIF MV_PAR07 = 2
	cQuery1 += "ORDER BY E2_NATUREZ "
ELSE
	cQuery1 += "ORDER BY E2_DIVNEG  "
ENDIF

//MemoWrite("C:\temp\BGH\RVRCB.sql", cQuery1)
TCQUERY cQuery1 NEW ALIAS "QRY1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbselectArea("QRY1")
DbGotop()

//verifica o mes Atual
If Empty(MV_PAR08)
	_dDataRel := dDataBase
Else
	_dDataRel := MV_PAR08
EndIf
	
_cDtAtu      :=Transform(Year(_dDataRel),'9999')+SUBSTRING(DTOS(_dDataRel),5,2)+"01"+"'"+" AND " +"'"+Transform(Year(_dDataRel),'9999')+SUBSTRING(DTOS(_dDataRel),5,2)+"31"
_nMesComp    := Transform(Year(_dDataRel),'9999')+SUBSTRING(DTOS(_dDataRel),5,2)+"01"
_cMesExtAtu  := MesExtenso(SUBSTRING(DTOS(_dDataRel),5,2))
_nMoedaAnt  := 0
_nMoedaAtual := 0

// Mes Anterior
_nMesAnt:= val(substring(transform(_nMesComp,'99999999'),5,2))-1

If _nMesAnt == 0
	_nMesAnt := 12       
	_cAno    := Year(_dDataRel)-1
Else
	_cAno    := Year(_dDataRel)
EndIf    

if _nMesAnt<=9
	_nMesAnt:="0"+alltrim(transform(_nMesAnt,'99'))
Else
	_nMesAnt:=alltrim(transform(_nMesAnt,'99'))
EndIf
_cMesExtAnt := MesExtenso(_nMesAnt)
_cDtAnt:=Transform(_cAno,'9999')+_nMesAnt+"01"+"'"+" AND " +"'"+Transform(_cAno,'9999')+_nMesAnt+"31"


IF Select("QRY2") <> 0
	DbSelectArea("QRY2")
	DbCloseArea()
Endif
//Encontrar a Moeda do anterior do Titulo
/*
cQuery1 := ""
cQuery1 := " SELECT M2_DATA, M2_MOEDA2 as MOEDA, M2_MOEDA5 as MOEDA5"
cQuery1 += " FROM " +Retsqlname ("SM2") + " WHERE "
cQuery1 += " M2_DATA BETWEEN '"+_cDtAnt+"'"
cQuery1 += " AND M2_MOEDA2 <> 0 "
cQuery1 += " AND D_E_L_E_T_ <> '*'"
TCQUERY cQuery1 NEW ALIAS "QRY2"
*/
cQuery1 := ""
cQuery1 := " SELECT M2_DATA, M2_MOEDA2 as MOEDA, M2_MOEDA5 as MOEDA5 "
cQuery1 += " FROM "
cQuery1 += " (SELECT MAX(M2_DATA) AS DT "
cQuery1 += " FROM " +Retsqlname ("SM2") + " WHERE "
cQuery1 += " M2_DATA BETWEEN '"+_cDtAnt+"'"
cQuery1 += " AND M2_MOEDA2 <> 0 "
cQuery1 += " AND D_E_L_E_T_ <> '*') AS TRB "
cQuery1 += " INNER JOIN " +Retsqlname ("SM2") + " SM2 ON "
cQuery1 += " M2_DATA=TRB.DT AND "
cQuery1 += " SM2.D_E_L_E_T_='' "
TCQUERY cQuery1 NEW ALIAS "QRY2"

//MemoWrite("C:\temp\BGH\RVRCB1.sql", cQuery1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula a media das taxas - Diego Fernandes - 09/09/2013ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("QRY2")
QRY2->(dbGotop())

nQtdMed := 0
_nTotal := 0

_nTotal5 := 0 //Tratamento para moeda 5 Euro

//While QRY2->(!Eof())
If QRY2->(!Eof())
	
	_dData := STOD(QRY2->M2_DATA)
	/*	
	If DataValida(_dData,.T.) == _dData
		nQtdMed++
		_nTotal += QRY2->MOEDA
		           
		//Tratamento para moeda 5 - GLPI - 16536
		_nTotal5+= QRY2->MOEDA5
	EndIf
	*/
	
	_nMoedaAnt := QRY2->MOEDA

	_nMoed5Ant := QRY2->MOEDA5
Endif
	//QRY2->(dbSkip())
//EndDo
/*
_nMoedaAnt := _nTotal / nQtdMed

//Tratamento para moeda 5 - GLPI - 16536
_nMoed5Ant := _nTotal5 / nQtdMed
*/

IF Select("QRY3") <> 0
	DbSelectArea("QRY3")
	DbCloseArea()
Endif

//Encontrar a Moeda do periodo do Atual
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula a media das taxas - Diego Fernandes - 09/09/2013ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
cQuery1 := ""
cQuery1 := " SELECT M2_DATA, M2_MOEDA2 AS MOEDA, M2_MOEDA5 as MOEDA5"
cQuery1 += " FROM " +Retsqlname ("SM2") + " WHERE "
cQuery1 += " M2_DATA BETWEEN '"+_cDtAtu+"'"
cQuery1 += " AND M2_MOEDA2 <> 0 "
cQuery1 += " AND D_E_L_E_T_ <> '*'"
*/

cQuery1 := ""
cQuery1 := " SELECT M2_DATA, M2_MOEDA2 as MOEDA, M2_MOEDA5 as MOEDA5 "
cQuery1 += " FROM "
cQuery1 += " (SELECT MAX(M2_DATA) AS DT "
cQuery1 += " FROM " +Retsqlname ("SM2") + " WHERE "
cQuery1 += " M2_DATA BETWEEN '"+_cDtAtu+"'"
cQuery1 += " AND M2_MOEDA2 <> 0 "
cQuery1 += " AND D_E_L_E_T_ <> '*') AS TRB "
cQuery1 += " INNER JOIN " +Retsqlname ("SM2") + " SM2 ON "
cQuery1 += " M2_DATA=TRB.DT AND "
cQuery1 += " SM2.D_E_L_E_T_='' "

TCQUERY cQuery1 NEW ALIAS "QRY3"

dbSelectArea("QRY3")
QRY3->(dbGotop())

nQtdMed := 0
_nTotal := 0

_nTotal5 := 0 //Tratamento para moeda 5 Euro

//While QRY3->(!Eof())
If QRY3->(!Eof())
	
	_dData := STOD(QRY3->M2_DATA)
	/*
	If DataValida(_dData,.T.) == _dData
		nQtdMed++
		_nTotal += QRY3->MOEDA             
		
		//Tratamento para moeda 5 - GLPI - 16536
		_nTotal5+= QRY3->MOEDA5
		
	EndIf
	*/
	_nMoedaAtual := QRY3->MOEDA             

	_nMoed5Atual := QRY3->MOEDA5
Endif
	//QRY3->(dbSkip())
//EndDo
/*
_nMoedaAtual := _nTotal / nQtdMed

//Tratamento para moeda 5 - GLPI - 16536
_nMoed5Atual := _nTotal5 / nQtdMed
*/                  

//CABECALHO RELATORIO
cLinha  := "DOLAR "+";"+ _cMesExtAtu + "/" + Transform(Year(_dDataRel),'9999')+";"
cLinha  += Transform(_nMoedaAtual,"@E 999.9999")+";"
cLinha  += _cMesExtAnt + "/" + Transform(_cAno,'9999')+";"
cLinha  += Transform(_nMoedaAnt,"@E 999.9999")+";"

fWrite(nHandle, cLinha  + cCrLf)

//Tratamento para moeda 5 - GLPI - 16536
cLinha  := "EURO "+";"+ _cMesExtAtu + "/" + Transform(Year(_dDataRel),'9999')+";"
cLinha  += Transform(_nMoed5Atual,"@E 999.9999")+";"
cLinha  += _cMesExtAnt + "/" + Transform(_cAno,'9999')+";"
cLinha  += Transform(_nMoed5Ant,"@E 999.9999")+";"

fWrite(nHandle, cLinha  + cCrLf)

cLinha := "Filial;Moeda;Prefixo;No.Titulo;Tipo;Natureza;Fornecedor;Loja;"
cLinha += "Nome Fornece;DT Emissao;Vencto Real;Vlr.Tituldo;Valor Liquido Baixado;Div. Negocio;"
cLinha += "Centro Custo;DT Baixa;DT Contab.;Saldo;Taxa DI;Taxa Cambio;Tx. Ant.;Tx. Atu.;Vlr. Ant. R$;"
cLinha += "Vlr. Atual R$;Varia็ใo;Mot. Baixa"

fWrite(nHandle, cLinha  + cCrLf)

nTxAnt  := _nMoedaAnt
nTxAtu  := _nMoedaAtual

nTxAnt5 := _nMoed5Ant
nTxAtu5 := _nMoed5Atual

procregua(reccount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta relatorio de titulos baixados 					   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !QRY1->(EOF())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncao para checar se o item foi estornado na SE5 	   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If CheckE5(QRY1->RECSE5)
		QRY1->(dbSkip())
		Loop
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se e baixa por compensacao e busca a taxa do PA - Diego Fernandes - 19/09/2013  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nTaxa := 0
	If QRY1->E5_TIPODOC == "CP"
		dbSelectArea("SE2")
		dbSetOrder(1)
		If MsSeek(xFilial("SE2")+Alltrim(QRY1->E5_DOCUMEN))
			nTaxa := SE2->E2_TXMOEDA
		EndIf
	Else
		nTaxa := QRY1->TAXA
	EndIf

	IF Select("QRY4") <> 0
		DbSelectArea("QRY4")
		DbCloseArea()
	Endif
	
	/*//Encontrar a Moeda do DOLAR
	cQuery1 := ""
	cQuery1 := " SELECT M2_DATA, M2_MOEDA2 "
	cQuery1 += " FROM " +Retsqlname ("SM2") + " WHERE "
	cQuery1 += " M2_DATA = '"+QRY1->E2_EMISSAO+"' "
	cQuery1 += " AND D_E_L_E_T_ <> '*'"
	TCQUERY cQuery1 NEW ALIAS "QRY4"
	
	_nDolar := QRY4->M2_MOEDA2*/
	
	//_nTxDi:=QRY1->E2_TXMOEDA
	
	cLinha  := QRY1->E2_FILIAL +";"
	cLinha  += Alltrim(Str(QRY1->E2_MOEDA)) +";"
	cLinha  += QRY1->E2_PREFIXO+";"
	cLinha  += QRY1->E2_NUM    +";"
	cLinha  += QRY1->E2_TIPO   +";"
	cLinha  += QRY1->E2_NATUREZ+";"
	cLinha  += QRY1->E2_FORNECE+";"
	cLinha  += QRY1->E2_LOJA   +";"
	cLinha  += QRY1->E2_NOMFOR +";"
	cLinha  += Transform(STOD(QRY1->E2_EMISSAO),"@E 99/99/99") +";"
	cLinha  += Transform(STOD(QRY1->E2_VENCREA),"@E 99/99/99") +";"
	cLinha  += Transform(QRY1->E2_VALOR,"@E 9,999,999,999.99")+";"
	cLinha  += Transform(QRY1->VLR_BAIXA,"@E 9,999,999,999.99")+";"
	cLinha  += QRY1->E2_DIVNEG+";"
	cLinha  += QRY1->E2_CCD+";"
	cLinha  += Transform(STOD(QRY1->E2_BAIXA),"@E 99/99/99") +";"
	cLinha  += Transform(STOD(QRY1->E2_EMIS1),"@E 99/99/99") +";"
	//    If  ! Empty( QRY1->E2_BAIXA )
	//  	    cLinha  += Transform(QRY1->VLR_BAIXA,"@E 9,999,999,999.99")+";"
	//    Else
	cLinha  += Transform(QRY1->E2_SALDO,"@E 9,999,999,999.99")+";"
	//	Endif
	cLinha  += Transform(QRY1->E2_TXMOEDA,"@E 999.9999")+";"
	
	cLinha  += Transform(nTaxa,"@E 999.9999")+";" //Taxa cambio para titulos baixados
		
	If QRY1->E2_MOEDA == 2 //Dolar
		_nMoedaAnt   := nTxAnt
		_nMoedaAtual := nTxAtu          
	Else//Euro
		_nMoedaAnt   := nTxAnt5
		_nMoedaAtual := nTxAtu5         
	EndIf

	If  ! Empty( QRY1->E2_BAIXA )
		_nMoedaAtual := nTaxa
	Endif
	                                             
	If Alltrim(QRY1->E2_TIPO) == "PA"	
		cLinha  += Transform(0,"@E 999.9999")+";" //Zerado para titulos baixados 
		cLinha  += Transform(0,"@E 999.9999")+";" //Usada para titulos em aberto do m๊s que estแ sendo analisado	
		cLinha  += Transform(0,"@E 9,999,999,999.9999")+";"
		cLinha  += Transform(0,"@E 9,999,999,999.9999")+";"
		cLinha  += Transform(0,"@E 9,999,999,999.9999")+";"
	Else
		cLinha  += Transform(0,"@E 999.9999")+";" //Zerado para titulos baixados 
		cLinha  += Transform(0,"@E 999.9999")+";" //Usada para titulos em aberto do m๊s que estแ sendo analisado	
		cLinha  += Transform((QRY1->VLR_BAIXA*QRY1->E2_TXMOEDA),"@E 9,999,999,999.9999")+";"		
		cLinha  += Transform((QRY1->VLR_BAIXA*_nMoedaAtual),"@E 9,999,999,999.9999")+";"
		cLinha  += Transform(((QRY1->VLR_BAIXA*QRY1->E2_TXMOEDA)-(QRY1->VLR_BAIXA*_nMoedaAtual)),"@E 9,999,999,999.9999")+";"
	EndIf		
	cLinha  += QRY1->E5_MOTBX
		
	fWrite(nHandle, cLinha  + cCrLf)
	
	QRY1->(DBSKIP())
	
	IncProc()
ENDDO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta previsao de titulos em aberto - Diego Fernandes   ณ
//ณ Chamado:  											   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
cQuery1 :=  " SELECT "
cQuery1 +=  "		DISTINCT SE2.R_E_C_N_O_  AS RECSE2 "
cQuery1 +=  " FROM "+RetSqlName("SE2")+" SE2 "
cQuery1 +=  " LEFT JOIN "+RetSqlName("SE5")+" SE5 ON SE5.E5_FILIAL = SE2.E2_FILIAL AND SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
cQuery1 +=  " SE5.E5_FORNECE = SE2.E2_FORNECE AND "
cQuery1 +=  " SE5.E5_TIPO = SE2.E2_TIPO AND  "
cQuery1 +=  " SE5.E5_NUMERO = SE2.E2_NUM  AND SE5.D_E_L_E_T_ = '' "
cQuery1 +=  " WHERE E2_EMISSAO <= '"+DTOS(MV_PAR09)+"' "
cQuery1 +=  " AND E5_DATA > '"+DTOS(MV_PAR09)+"' "
cQuery1 +=  " AND E2_FILIAL >= '"+(MV_PAR01)+"' AND E2_FILIAL <= '"+(MV_PAR02)+"'" "
cQuery1 +=  " AND SE2.D_E_L_E_T_ = '' "
cQuery1 +=  " AND E2_MOEDA IN ('2','5') "
cQuery1 +=  " AND E2_TIPO <> 'PA' "
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")
cQuery1 +=  " AND E2_FILIAL+E2_NUM+E2_PREFIXO+E2_PARCELA+E2_TIPO  "
cQuery1 +=  " 	 NOT IN ( SELECT E5_FILIAL+E5_NUMERO+E5_PREFIXO+E5_PARCELA+E5_TIPO "
cQuery1 +=  " 			  FROM "+RetSqlName("SE5")+" SE5  "
cQuery1 +=  " 			  WHERE E5_FILIAL+E5_NUMERO+E5_PREFIXO+E5_PARCELA+E5_TIPO  = E2_FILIAL+E2_NUM+E2_PREFIXO+E2_PARCELA+E2_TIPO  "
cQuery1 +=  " 			  AND E5_DATA <= '"+DTOS(MV_PAR09)+"' ) "
cQuery1 +=  "UNION ALL "
cQuery1 +=  " SELECT "
cQuery1 +=  "		DISTINCT SE2A.R_E_C_N_O_  AS RECSE2 "
cQuery1 +=  " FROM "+RetSqlName("SE2")+" SE2A "
cQuery1 +=  " WHERE E2_EMISSAO <= '"+DTOS(MV_PAR09)+"' "
cQuery1 +=  " AND E2_FILIAL >= '"+(MV_PAR01)+"' AND E2_FILIAL <= '"+(MV_PAR02)+"'" "
cQuery1 +=  " AND SE2A.D_E_L_E_T_ = '' "
cQuery1 +=  " AND E2_MOEDA IN ('2','5') "
cQuery1 +=  " AND E2_TIPO <> 'PA' "
cQuery1 +=  " AND E2_SALDO > 0 "
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")
cQuery1 +=  " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")

If Select("QRY1") > 0 
	QRY1->(dbCloseArea())		
EndIf

TCQUERY cQuery1 NEW ALIAS "QRY1"

dbSelectArea("QRY1")
QRY1->(dbGotop())

cLinha  := "TITULOS EM ABERTO" +";"
fWrite(nHandle, cLinha  + cCrLf)

While QRY1->(!Eof())

	dbSelectArea("SE2")
	dbGoto(QRY1->RECSE2)
	
	If SE2->E2_MOEDA == 2 //Dolar
		_nMoedaAnt   := nTxAnt
		_nMoedaAtual := nTxAtu          
	Else//Euro
		_nMoedaAnt   := nTxAnt5
		_nMoedaAtual := nTxAtu5         
	EndIf	
	//nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,MV_PAR09-50,,SE2->E2_LOJA,,SE2->E2_TXMOEDA,3)

	//If nSaldo > 0					
		cLinha  := SE2->E2_FILIAL +";"
		cLinha  += Alltrim(Str(SE2->E2_MOEDA)) +";"
		cLinha  += SE2->E2_PREFIXO+";"
		cLinha  += SE2->E2_NUM    +";"
		cLinha  += SE2->E2_TIPO   +";"
		cLinha  += SE2->E2_NATUREZ+";"
		cLinha  += SE2->E2_FORNECE+";"
		cLinha  += SE2->E2_LOJA   +";"
		cLinha  += SE2->E2_NOMFOR +";"
		cLinha  += Transform(SE2->E2_EMISSAO,"@E 99/99/99") +";"
		cLinha  += Transform(SE2->E2_VENCREA,"@E 99/99/99") +";"
		cLinha  += Transform(SE2->E2_VALOR,"@E 9,999,999,999.99")+";"
		cLinha  += Transform(0,"@E 9,999,999,999.99")+";"
		cLinha  += SE2->E2_DIVNEG+";"
		cLinha  += SE2->E2_CCD+";"
		cLinha  += Transform(STOD(""),"@E 99/99/99") +";"
		cLinha  += Transform(SE2->E2_EMIS1,"@E 99/99/99") +";"
		
		//cLinha  += Transform(SE2->E2_VALOR,"@E 9,999,999,999.99")+";"
		cLinha  += Transform(SE2->E2_SALDO,"@E 9,999,999,999.99")+";"//Conforme solicita็ใo do usuario Luciano do financeiro alterado para mostrar o saldo do titulo
		cLinha  += Transform(SE2->E2_TXMOEDA,"@E 999.9999")+";"		
		cLinha  += Transform(0,"@E 999.9999")+";" //Taxa cambio para titulos baixados
							                
		If Month(SE2->E2_EMIS1) == Month(_dDataRel)		
			cLinha  += Transform(SE2->E2_TXMOEDA,"@E 999.9999")+";"
			cLinha  += Transform(nTxAtu,"@E 999.9999")+";" //Usada para titulos em aberto do m๊s que estแ sendo analisado		
			/*
			cLinha  += Transform((SE2->E2_VALOR*SE2->E2_TXMOEDA),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform((SE2->E2_VALOR*_nMoedaAtual),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform(((SE2->E2_VALOR*SE2->E2_TXMOEDA)-(SE2->E2_VALOR*_nMoedaAtual)),"@E 9,999,999,999.9999")+";"
			*/
			
			cLinha  += Transform((SE2->E2_SALDO*SE2->E2_TXMOEDA),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform((SE2->E2_SALDO*_nMoedaAtual),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform(((SE2->E2_SALDO*SE2->E2_TXMOEDA)-(SE2->E2_SALDO*_nMoedaAtual)),"@E 9,999,999,999.9999")+";"
		Else
			cLinha  += Transform(nTxAnt,"@E 999.9999")+";"
			cLinha  += Transform(nTxAtu,"@E 999.9999")+";" //Usada para titulos em aberto do m๊s que estแ sendo analisado
			/*
			cLinha  += Transform((SE2->E2_VALOR*_nMoedaAnt),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform((SE2->E2_VALOR*_nMoedaAtual),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform(((SE2->E2_VALOR*_nMoedaAnt)-(SE2->E2_VALOR*_nMoedaAtual)),"@E 9,999,999,999.9999")+";"
			*/
			
			cLinha  += Transform((SE2->E2_SALDO*_nMoedaAnt),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform((SE2->E2_SALDO*_nMoedaAtual),"@E 9,999,999,999.9999")+";"
			cLinha  += Transform(((SE2->E2_SALDO*_nMoedaAnt)-(SE2->E2_SALDO*_nMoedaAtual)),"@E 9,999,999,999.9999")+";"
		EndIf

		fWrite(nHandle, cLinha  + cCrLf)

	//EndIf

	QRY1->(dbSkip())
EndDo

fClose(nHandle)

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	//CpyS2T( cDirDocs+cArquivo+".CSV", DIRTEMP, .T. )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	//oExcelApp:WorkBooks:Open( "c:\temp\"+cArquivo+".xls" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheckE5   บAutor  ณDiego Fernandes     บ Data ณ  09/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para verificar se o registro foi estornado          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CheckE5(nRecSE5)

Local lRet := .F.

dbSelectArea("SE5")
dbSetOrder(2)
dbGoto(nRecSE5)

If MsSeek(SE5->E5_FILIAL+"ES"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ))
	lRet := .T.
EndIf

Return( lRet )