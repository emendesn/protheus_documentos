#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "avprint.ch"

#define PAD_LEFT            0
#define PAD_RIGHT           1
#define PAD_CENTER          2
#define ENTER chr(13) + chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPTRIA   บ Autor ณPaulo Lopez         บ Data ณ  04/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณETIQUETA MASTER - TRIAGEM                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMPTRIA(cMaster,cDestin)
//User Function IMPTRIA()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cPict          	:= ""
Local imprime        	:= .T.
Local aOrd           	:= {}
Local aArea          	:= GetArea()

Private nPage  			:= 0
Private lAbortPrint  	:= .F.
Private nLimite      	:= 220
Private cTamanho     	:= "G"
Private cNomeProg    	:= "IMPTRIA"
Private nTipo        	:= 18
Private aReturn      	:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     	:= 0
Private wnrel        	:= "IMPTRIA"
Private cString      	:= "ZZO"
Private m_pag        	:= 01
Private nLin         	:= 0
Private oPrint
Private cDesc1         	:= "Este programa tem como objetivo imprimir equipamentos para "
Private cDesc2         	:= "Etiqueta Master"
Private cTitulo        	:= "Etiqueta Master"
Private Cabec1         	:= ""
Private Cabec2         	:= ""

u_GerA0003(ProcName())


//Private cMaster			:='00000000000000000032'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint   := PcoPrtIni("Etiqueta Master",.F.,2,)

If cDestin <> 'B'

oProcess := MsNewProcess():New({|lEnd| fMast001I(,oPrint,oProcess,cMaster)},"","",.F.)
oProcess :Activate()

PcoPrtEnd(oPrint)

Else


oProcess := MsNewProcess():New({|lEnd| fMast001B(,oPrint,oProcess,cMaster)},"","",.F.)
oProcess :Activate()

PcoPrtEnd(oPrint)

EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfMast001I บ Autor ณ AP6 IDE            บ Data ณ  04/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Efetua Impressใo para Etiqueta Master - NEXTEL             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fMast001I(lEnd,oPrint,oProcess,cMaster)

Local cQry

Private _aDados := {}
Private _aItens := {}
Private _aItens1 := {}
Private X
Private T
Private Y

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fontes utilizadas                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//                             Font              W  H  Bold  - Italic - Underline - Device
//oFont := oSend(TFont(),"New","Arial"          ,0,14,,.F.,,,,.F.,.F.,,,,,,oPrn)
Private oFont0  := TFont():New( "Tahoma"            ,,10     ,,.T.,,,,.F.,.F.)
Private oFont1	:= TFont():New( "Verdana"           ,,08     ,,.F.,,,,.F.,.F.)
Private oFont2	:= TFont():New( "Tahoma"            ,,08     ,,.T.,,,,.F.,.F.)
Private oFont3	:= TFont():New( "Tahoma"            ,,06     ,,.T.,,,,.F.,.F.)
Private oFont4  := TFont():New( "Tahoma"            ,,08     ,,.F.,,,,.F.,.F.)
Private cLogo


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQry := " SELECT ZZO_IMEI AS IMEI FROM " + RetSQlName("ZZO") + " ZZO(NOLOCK) " + ENTER
cQry += " WHERE ZZO_FILIAL  = '"+xFilial("ZZO")+"' " + ENTER
cQry += " AND ZZO_STATUS = 1 " + ENTER
cQry += " AND ZZO_SEGREG = '' " + ENTER
cQry += " AND ZZO_NUMCX = '"+cMaster+"' " + ENTER //+cMaster+"' " + ENTER
cQry += " AND D_E_L_E_T_ = ''  " + ENTER

MemoWrite("c:\IMPTRIA.sql", cQry)

TCQUERY cQry NEW ALIAS QRY

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")
	
	aAdd(_aDados,{	QRY->IMEI})
	
	
	dbSelectArea("QRY")
	dbSkip()
EndDo

QRY->(dbCloseArea())


For X := 1 to len(_aDados)
	
	Aadd(_aItens, {_aDados[X,1]})
	
	If X == 100
		Exit
	EndIf
	
Next X

If len (_aDados) > 100
	
	For T := 1 to len (_aItens)
		
		If  len (_aDados) >= X+T
			
			Aadd(_aItens1, {_aItens[T,1],_aDados[X+T,1] })
		Else
			
			Aadd(_aItens1, {_aItens[T,1],'' })
		EndIf
	Next T
EndIf

nLin := 1

cLogo := GetSrvProfString("Startpath","") + "bgh.BMP"
oPrint :SayBitmap(nLin, 0010, cLogo, 0180, 0110)
nLin ++
oPrint :Say( nLin , 1080, "  BGH DO BRASIL COMUNICACOES E SERVICOS LTDA.", oFont0,,,, PAD_CENTER)
oPrint :Say( nLin + 060 , 0580, "Etiqueta Master:  " + cMaster, oFont0,010,120,150, PAD_CENTER)
MSBAR3("CODE128",  0.4 + (0 * 0.20),08.3, cMaster, oPrint,	,	  ,.T. , 0.03, 0.35,	 ,.T. , "C", .F.)

If len (_aDados) < 100
	
	For Y := 1 to len(_aItens)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10
		//oPrint :Say( nLin + 60, 0040 ,  AllTrim(QRY->IMEI) , oFont2,,,, PAD_CENTER)
		// -- OK -- MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.3, _aDados[X,1], oPrint, .F., Nil, Nil, 0.03, 0.35, .T., "A", Nil, .F.)
		//MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.2, _aItens1[Y,1], oPrint, .F., Nil, Nil, 0.03, 0.35, .F., "A", Nil, .F.)
		//MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.2, AllTrim(_aItens1[Y,1]), oPrint, Nil, Nil, Nil, 0.03, 0.35, .F., Nil, Nil, .F.)
		MSBAR3("CODE128",  1.0 + (nPage * 0.55), 0.5, AllTrim(_aItens[Y,1]), oPrint,,,, 0.03, 0.35,,, "C", .F.)
		oPrint :Say( nLin + 120 , 0770, AllTrim(_aItens[Y,1]), oFont2,,,, PAD_CENTER)
	 /*	If Len(_aItens[Y,2]) > 0
			
			//MSBAR3("INT25",  1.0 + (nPage * 0.55), 13.3, AllTrim(_aItens1[Y,2]), oPrint, Nil, Nil, Nil, 0.03, 0.35, .F., Nil, Nil, .F.)
			MSBAR3("CODE128",  1.0 + (nPage * 0.55), 08.3, AllTrim(_aItens[Y,2]), oPrint,,,, 0.03, 0.35,,, "C", .F.)
			oPrint :Say( nLin + 120 , 1750, AllTrim(_aItens[Y,2]), oFont2,,,, PAD_CENTER)
		EndIf                    */
		//	MSBAR3("INT25",  1.6 + (nPage * 1.38), 0.5, QRY->IMEI, oPrint, .F., Nil, Nil, 0.03, 0.8, .T., Nil, Nil, .F.)
		
		If nPage > 48
			
			MSBAR3("CODE128",  1.0 + (20 * 0.55), 18.3, cMaster, oPrint,	,	  ,.F. , 0.03, 0.35,	 ,.T. , "C", .F.)
			//		oPrint :Say( nLin + 120 , 1750, '00000000000000000040', oFont2,010,120,150, PAD_CENTER)
			
			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y
	
Else
	
	For Y := 1 to len(_aItens1)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10
		//oPrint :Say( nLin + 60, 0040 ,  AllTrim(QRY->IMEI) , oFont2,,,, PAD_CENTER)
		// -- OK -- MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.3, _aDados[X,1], oPrint, .F., Nil, Nil, 0.03, 0.35, .T., "A", Nil, .F.)
		//MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.2, _aItens1[Y,1], oPrint, .F., Nil, Nil, 0.03, 0.35, .F., "A", Nil, .F.)
		//MSBAR3("INT25",  1.0 + (nPage * 0.55), 0.2, AllTrim(_aItens1[Y,1]), oPrint, Nil, Nil, Nil, 0.03, 0.35, .F., Nil, Nil, .F.)
		MSBAR3("CODE128",  1.0 + (nPage * 0.55), 0.5, AllTrim(_aItens1[Y,1]), oPrint,,,, 0.03, 0.35,,, "C", .F.)
		oPrint :Say( nLin + 120 , 0770, AllTrim(_aItens1[Y,1]), oFont2,,,, PAD_CENTER)
		If Len(_aItens1[Y,2]) > 0
			
			//MSBAR3("INT25",  1.0 + (nPage * 0.55), 13.3, AllTrim(_aItens1[Y,2]), oPrint, Nil, Nil, Nil, 0.03, 0.35, .F., Nil, Nil, .F.)
			MSBAR3("CODE128",  1.0 + (nPage * 0.55), 08.3, AllTrim(_aItens1[Y,2]), oPrint,,,, 0.03, 0.35,,, "C", .F.)
			oPrint :Say( nLin + 120 , 1750, AllTrim(_aItens1[Y,2]), oFont2,,,, PAD_CENTER)
		EndIf
		//	MSBAR3("INT25",  1.6 + (nPage * 1.38), 0.5, QRY->IMEI, oPrint, .F., Nil, Nil, 0.03, 0.8, .T., Nil, Nil, .F.)
		
		If nPage > 48
			
			MSBAR3("CODE128",  1.0 + (20 * 0.55), 18.3, cMaster, oPrint,	,	  ,.F. , 0.03, 0.35,	 ,.T. , "C", .F.)
			//		oPrint :Say( nLin + 120 , 1750, '00000000000000000040', oFont2,010,120,150, PAD_CENTER)
			
			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y
	
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfMast001B บ Autor ณ AP6 IDE            บ Data ณ  04/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Efetua Impressใo para Etiqueta Master - BGH                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fMast001B(lEnd,oPrint,oProcess,cMaster)

Local cQry

Private _aDados 	:= {}
Private _aItens 	:= {}
Private _aItens1 	:= {}
Private _aItens2 	:= {}
Private _aItens3 	:= {}
Private _cContro	:= 0
Private _cModelo
Private _cGarfog
Private X
Private T         
Private V
Private Z
Private Y

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fontes utilizadas                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//                             Font              W  H  Bold  - Italic - Underline - Device
//oFont := oSend(TFont(),"New","Arial"          ,0,14,,.F.,,,,.F.,.F.,,,,,,oPrn)
Private oFont0  := TFont():New( "Tahoma"            ,,10     ,,.T.,,,,.F.,.F.)
Private oFont1	:= TFont():New( "Verdana"           ,,08     ,,.F.,,,,.F.,.F.)
Private oFont2	:= TFont():New( "Tahoma"            ,,08     ,,.T.,,,,.F.,.F.)
Private oFont3	:= TFont():New( "Tahoma"            ,,06     ,,.T.,,,,.F.,.F.)
Private oFont4  := TFont():New( "Tahoma"            ,,08     ,,.F.,,,,.F.,.F.)
Private oFont5  := TFont():New( "Tahoma"            ,,12     ,,.T.,,,,.F.,.F.)
Private cLogo


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQry := " SELECT ZZO_IMEI AS IMEI, ZZO_MODELO AS MODELO, GAR_FOG = CASE	WHEN ZZO_REFGAR = '1' THEN 'REFURBISH-GAR' WHEN ZZO_REFGAR = '2' THEN 'REFURBISH-FOG' WHEN ZZO_REFGAR = '3' THEN 'REPARO-GAR' 	WHEN ZZO_REFGAR = '4' THEN 'BOUNCE' WHEN ZZO_REFGAR = '5' THEN 'PRATA' ELSE '' END  FROM " + RetSQlName("ZZO") + " ZZO(NOLOCK) " + ENTER
cQry += " WHERE ZZO_FILIAL  = '"+xFilial("ZZO")+"' " + ENTER 
cQry += " AND ZZO_SEGREG = '' " + ENTER
cQry += " AND ZZO_STATUS = 1 " + ENTER
cQry += " AND ZZO_NUMCX = '"+cMaster+"' " + ENTER            
cQry += " AND D_E_L_E_T_ = '' " + ENTER

MemoWrite("c:\IMPTRIA.sql", cQry)

TCQUERY cQry NEW ALIAS QRY

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("QRY")
dbGoTop()

_cGarfog	:=	QRY->GAR_FOG
_cModelo 	:= 	QRY->MODELO

While !EOF("QRY")
	
	aAdd(_aDados,{	QRY->IMEI})
	
	_cContro ++ 
	
	dbSelectArea("QRY")
	dbSkip()
EndDo


QRY->(dbCloseArea())


For X := 1 to len(_aDados)
	
	Aadd(_aItens, {_aDados[X,1]})
	
	If X == 51
		Exit
	EndIf
	
Next X

If len (_aDados) > 50
	
	For T := 1 to len (_aItens)
		
		If  len (_aDados) >= X+T
			
			Aadd(_aItens1, {_aItens[T,1],_aDados[X+T,1] })
		Else
			
			Aadd(_aItens1, {_aItens[T,1],'' })
		EndIf 
		
		If T == 51
			Exit
		EndIf
		
	Next T
EndIf

If len (_aDados) > 100
	
	For V := 1 to len (_aItens1)
		
		If  len (_aDados) >= X+T+V
			
			Aadd(_aItens2, {_aItens1[V,1],_aItens1[V,2],_aDados[X+T+V,1] })
		Else
			
			Aadd(_aItens2, {_aItens1[V,1],_aItens1[V,2],'' })
		EndIf 
		
		If V == 51
			Exit
		EndIf
		
	Next V
EndIf

If len (_aDados) > 150
	
	For Z := 1 to len (_aItens2)
		
		If  len (_aDados) >= X+T+V+Z
			
			Aadd(_aItens3, {_aItens2[Z,1],_aItens2[Z,2],_aItens2[Z,3],_aDados[X+T+V+Z,1] })
		Else
			
			Aadd(_aItens3, {_aItens2[Z,1],_aItens2[Z,2],_aItens2[Z,3],'' })
		EndIf
	Next Z
EndIf

nLin := 1

cLogo := GetSrvProfString("Startpath","") + "bgh.BMP"
oPrint :SayBitmap(nLin, 0010, cLogo, 0180, 0110)
nLin ++
oPrint	:Box(0150, 0100, 3223, 2300 )
oPrint 	:Say( nLin , 1080 , "  BGH DO BRASIL COMUNICACOES E SERVICOS LTDA.", oFont2,,,, PAD_CENTER)   
oPrint 	:Say( nLin + 60   , 0580, "  Data:  "+ Transform(dDatabase,"@E 99/99/99") +" - " + Time(), oFont2,,,, PAD_CENTER)
oPrint 	:Say( nLin + 60   , 1580, "  Modelo: "+ _cModelo, oFont2,,,, PAD_CENTER)
oPrint 	:Say( nLin + 100  , 0525, "  Local Origem:  SP", oFont2,,,, PAD_CENTER)
oPrint 	:Say( nLin + 100  , 1535, "  Quantidade: "+ Transform(StrZero(_cContro,3),"@E 999"), oFont2,,,, PAD_CENTER)
oPrint 	:Say( nLin + 100  , 1885, "  Opera็ใo:  "+_cGarfog, oFont2,,,, PAD_CENTER)
nLin ++

If len (_aDados) <= 50
	
	For Y := 1 to len(_aItens)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10

		oPrint :Say( nLin + 150 , 0363, AllTrim(_aItens[Y,1]), oFont2,,,, PAD_CENTER)
		
		nLin -= 30
			
		If nPage > 68
			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y
	                   
EndIf
	
If len (_aDados) > 50 .And. len (_aDados) <= 100
	
	For Y := 1 to len(_aItens1)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10

		oPrint :Say( nLin + 150 , 0363, AllTrim(_aItens1[Y,1]), oFont2,,,, PAD_CENTER)
		If Len(_aItens1[Y,2]) > 0
			
			oPrint :Say( nLin + 150 , 0800, AllTrim(_aItens1[Y,2]), oFont2,,,, PAD_CENTER)
		EndIf
		  
		nLin -= 30
		
		If nPage > 68
			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y     
Endif	

If len (_aDados) > 100	 .And. len (_aDados) <= 150

	
	For Y := 1 to len(_aItens2)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10

		oPrint :Say( nLin + 150 , 0363, AllTrim(_aItens2[Y,1]), oFont2,,,, PAD_CENTER)
		If Len(_aItens2[Y,2]) > 0
			
			oPrint :Say( nLin + 150 , 0800, AllTrim(_aItens2[Y,2]), oFont2,,,, PAD_CENTER)
			
		EndIf
			
		If Len(_aItens2[Y,3]) > 0	
			
			oPrint :Say( nLin + 150 , 1237, AllTrim(_aItens2[Y,3]), oFont2,,,, PAD_CENTER)
						
		EndIf  
		
		nLin -= 30 
		
		If nPage > 68
			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y       

EndIf
	
If len (_aDados) >= 150	 

	
	For Y := 1 to len(_aItens3)
		
		//	nLin += 10
		
		/*/ Parametros da funcao MSBAR3
		ณ 01 cTypeBar  String com o tipo do codigo de barras
		ณ              "EAN13","EAN8","UPCA","SUP5","CODE128"
		ณ              "INT25","MAT25,"IND25","CODABAR","CODE3_9"
		ณ              "EAN128"
		ณ 02 nRow      Numero da Linha em centimentros
		ณ 03 nCol      Numero da coluna em centimentros
		ณ 04 cCode     String com o conteudo do codigo
		ณ 05 oPr       Obejcto Printer
		ณ 06 lcheck    Se calcula o digito de controle
		ณ 07 Cor       Numero da Cor, utilize a "common.ch"
		ณ 08 lHort     Se imprime na Horizontal
		ณ 09 nWidth    Numero do Tamanho da barra em centimetros
		ณ 10 nHeigth   Numero da Altura da barra em milimetros
		ณ 11 lBanner   Se imprime o linha em baixo do codigo
		ณ 12 cFont     String com o tipo de fonte
		ณ 13 cMode     String com o modo do codigo de barras CODE128
		ณ 14 lPrint    Logico que indica se imprime ou nao
		ณ 15 nPFWidth  Numero do indice de ajuste da largura da fonte
		ณ 16 nPFHeigth Numero do indice de ajuste da altura da fonte
		/*/
		nLin += 10

		oPrint :Say( nLin + 150 , 0363, AllTrim(_aItens3[Y,1]), oFont2,,,, PAD_CENTER)
		
		If Len(_aItens3[Y,2]) > 0
			
			oPrint :Say( nLin + 150 , 0800, AllTrim(_aItens3[Y,2]), oFont2,,,, PAD_CENTER)
			
		EndIf
			
	   	If Len(_aItens3[Y,3]) > 0	
		
			oPrint :Say( nLin + 150 , 1237, AllTrim(_aItens3[Y,3]), oFont2,,,, PAD_CENTER)
			
        EndIf 
        
		If Len(_aItens3[Y,4]) > 0	
		
			oPrint :Say( nLin + 150 , 1737, AllTrim(_aItens3[Y,4]), oFont2,,,, PAD_CENTER)
						
		EndIf  
		
		nLin -= 30    
		
		If nPage > 68

			oPrint :EndPage()
			oPrint :StartPage()
			nPage := 0
			nLin  := 10
		Else
			nPage++
			nLin += 55
		EndIf
		
	Next Y     	
	
EndIf   
  
oPrint :Say( 03300 , 1280, "Etiqueta Master:  " + cMaster, oFont2,010,120,150, PAD_CENTER)
MSBAR3("CODE128",  1.0 + ((nPage) * 0.55),08.3, cMaster, oPrint,	,	  ,.T. , 0.03, 0.35,	 ,.T. , "C", .F.)

Return