
#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHSP3 	บ Autor ณVinicius Leonardo   บ Data ณ  19/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera pedido de venda de retorno ao cliente 				  บฑฑ
ฑฑบ          ณdas pe็as apontadas nos equipamentos                        บฑฑ
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
User Function BGHSP3()

Private cPerg		:= "BGHSP3"

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

Processa({|| BGHRET1A()}, "Processando...")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHRET1A  บ Autor ณVinicius Leonardo   บ Data ณ  19/02/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para marca็ใo dos itens 								  บฑฑ
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
Static Function BGHRET1A()

Local aArea := GetArea()
Local aCampos     := {}
Local aMark  := {;
{"OK"		, "C", 02, 0},;
{"NF"   	, "C", TamSX3("D2_DOC")[1],0},;
{"SERIE"	, "C", TamSX3("D2_SERIE")[1],0},;
{"PECA"	    , "C", TamSX3("D2_COD")[1],0},;
{"DESCRI"   , "C", TamSX3("B1_DESC")[1],0},;
{"ITEM"     , "C", TamSX3("D1_ITEM")[1],0},;
{"PV"  		, "C", TamSX3("C5_NUM")[1],0},;
{"QTDE"	    , "C", 10,0},;
{"VLRUNI"	, "C", 20,0},;
{"VLRTOT"	, "C", 20,0},;
{"RECZZQ"	, "N", 20,0}}

Private dDtSaiIni := MV_PAR01
Private	dDtSaiFim := MV_PAR02
Private dDtEntIni := MV_PAR03
Private dDtEntFim := MV_PAR04
Private cOpera	  := MV_PAR05
Private cArmaz	  := MV_PAR06
Private cForNFE10 := Getmv("BH_FORNFE10",.F.,"Z0040301") 
Private carmproc  := Posicione("ZZJ",1,xFilial("ZZJ") + cOpera, "ZZJ_ALMSCR")					
Private cMarca    := GetMark()
Private cCadastro := 'Pedido de Venda'
Private aRotina   := {{"Pedido de Venda" , "u_BGHSP3A()", 0, 1 }} 
Private aIdent	  := {}

AADD(aCampos,{"OK"		,,	""})
AADD(aCampos,{"NF"		,,	"NF "})
AADD(aCampos,{"SERIE"	,,	"Serie"})
AADD(aCampos,{"PECA"	,,	"Produto"})
AADD(aCampos,{"DESCRI"	,,	"Descricao"})
AADD(aCampos,{"QTDE"  	,,	"Quantidade"})
AADD(aCampos,{"VLRUNI"  ,,	"Vlr Unitario"})
AADD(aCampos,{"VLRTOT"  ,,	"Vlr Total"})
AADD(aCampos,{"ITEM"	,,	"Item"})
AADD(aCampos,{"PV"		,,	"Pedido Venda"})

if Select("fMark")>0
	dbSelectArea("fMark")
	dbCloseArea()
endif

cFileMark := CriaTrab(aMark,.T.)
DBUSEAREA(.T.,,cFileMark,"fMark",.F.)
IndRegua("fMark",cFileMark,"NF+SERIE",,,"Criando Arquivo Trabalho...")

cQuery := "	SELECT ZZQ.R_E_C_N_O_ AS RECZZQ,* FROM "+ RETSQLNAME("ZZQ")+" ZZQ (nolock) " + CRLF
cQuery += " INNER JOIN "+ RETSQLNAME("SD1")+" SD1 (nolock) ON " + CRLF
cQuery += "		D1_FILIAL='"+xFilial("SD1")+"' AND " + CRLF
cQuery += "		D1_DOC=ZZQ_NFENTR AND " + CRLF
cQuery += "		D1_SERIE=ZZQ_SERENT AND " + CRLF
cQuery += "		D1_COD=ZZQ_PECA AND "  + CRLF
cQuery += "		SD1.D_E_L_E_T_='' " + CRLF
cQuery += "	WHERE "  + CRLF
cQuery += "		ZZQ_FILIAL='"+xFilial("ZZQ")+"' AND " + CRLF
cQuery += "		ZZQ_DTSAID BETWEEN '"+DTOS(dDtSaiIni)+"' AND '"+DTOS(dDtSaiFim)+"' AND " + CRLF
cQuery += "		ZZQ_DTENTR BETWEEN '"+DTOS(dDtEntIni)+"' AND '"+DTOS(dDtEntFim)+"' AND " + CRLF
cQuery += "		ZZQ_OPEBGH='"+cOpera+"' AND " + CRLF
cQuery += "		ZZQ.D_E_L_E_T_='' AND "  + CRLF
cQuery += "		ZZQ_PVRESA = '' AND "  + CRLF
cQuery += "		D1_FORNECE='"+substr(cForNFE10,1,6)+"' AND " + CRLF
cQuery += "		D1_LOJA='"+substr(cForNFE10,7,2)+"' " + CRLF
cQuery += "	ORDER BY D1_ITEM,ZZQ_PECA " + CRLF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL1",.T.,.T.)

TSQL1->(DBGoTop())

While TSQL1->(!EOF())
	RecLock("fMARK",.T.)
	fMark->OK		:= SPACE(2)
	fMark->NF	  	:= TSQL1->D1_DOC
	fMark->SERIE	:= TSQL1->D1_SERIE
	fMark->PECA	    := TSQL1->D1_PRODUTO
	fMark->DESCRI   := Posicione("SB1",1,xFilial("SB1") +TSQL1->D1_COD,"B1_DESC")
	fMark->QTDE	    := TransForm(TSQL1->D1_QUANT,"@E 999,999.99")
	fMark->VLRUNI   := TransForm(TSQL1->ZZQ_VLRUNI,"@E 999,999,999.9999")
	fMark->VLRTOT   := TransForm(TSQL1->ZZQ_VLRUNI*TSQL1->D1_QUANT,"@E 999,999,999.9999")
	fMark->ITEM  	:= TSQL1->D1_ITEM
	fMark->RECZZQ   := TSQL1->RECZZQ
	fMARK->(MSUNLOCK()) 
	
	TSQL1->(DBSkip())
EndDo

dbSelectArea("fMark")
fMark->(DbGotop())

If fMark->(!EOF())
	MarkBrow("fMark","OK",,aCampos,.F.,cMarca,"u_MarcaIte(1)",,,,"u_MarcaIte(2)")
Else
	MsgAlert("Nใo existem informa็๕es para os parametros selecionados.")
Endif

If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

if Select("fMark")>0
	dbSelectArea("fMark")
	dbCloseArea()
endif

RestArea(aArea)

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHNFE10 บ Autor ณVinicius Leonardo    บ Data ณ  13/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera็ใo da NF Entrada - Motorola 10%                        บฑฑ
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
User Function BGHSP3A()

Local aArea:=GetArea()

Processa({|| BGHPV1A()},"Processando Pedido de Venda.")

RestArea(aArea)

Return

Static Function BGHPV1A()

Local aArea:=GetArea()
Local aCab 		:= {}
Local aItens   	:= {}
Local cItens    := '00'

dbSelectArea("fMark")
fMark->(DbGotop())

If fMark->(!EOF())
	
	While fMark->(!EOF())
		
		If !EMPTY(fMark->OK) .and. EMPTY(fMark->PV)
			
			dbSelectArea("ZZJ")
			dbSetOrder(1)
			dbSeek(xFilial("ZZJ")+cOpera)
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+ZZJ->ZZJ_CLIDEV+ZZJ->ZZJ_LOJDEV)
			
			If len(aCab) == 0
				
				aCab  := {	{"C5_TIPO"		,"N"					,Nil},;
				{"C5_CLIENTE"	,SA1->A1_COD						,Nil},;
				{"C5_LOJACLI"	,SA1->A1_LOJA						,Nil},;
				{"C5_LOJAENT"	,SA1->A1_LOJA						,Nil},;
				{"C5_CONDPAG"	,'001'	   							,Nil},;
				{"C5_XUSER"		,alltrim(cusername)					,Nil},;
				{"C5_TRANSP"    ,ZZJ->ZZJ_TRANSP	                ,Nil},;
				{"C5_DIVNEG"    ,ZZJ->ZZJ_DIVNEG           			,Nil}}
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+fMark->PECA)  
						
			_nQuant := fMark->QTDE
			_nVlUni := A410Arred(fMark->VLRUNI,"C6_PRCVEN")
			_nVlTot := A410Arred(_nVlUni*_nQuant,"C6_VALOR")
						
			cItens := Soma1(cItens,2)
			Aadd(aItens,{	{"C6_ITEM"		,cItens	        ,Nil},;
			{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
			{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
			{"C6_TES"		,ZZJ->ZZJ_TSPECA				,Nil},;
			{"C6_QTDVEN"	,_nQuant				  		,Nil},;
			{"C6_QTDLIB"	,_nQuant						,Nil},;
			{"C6_PRCVEN"	,_nVlUni						,Nil},;
			{"C6_VALOR"		,_nVlTot			   			,Nil},;
			{"C6_PRUNIT"	,_nVlUni						,Nil},;
			{"C6_LOCAL"		,carmproc						,Nil},;
			{"C6_ENTREG"	,dDataBase						,Nil}})			
			
		Endif
		
		fMark->(DbSkip())
		
	EndDo
	
	If Len(aItens) > 0
		lRet := u_geraPV(aCab,aItens,3)
		If lRet
			dbSelectArea("fMark")
			fMark->(DbGotop())
			While fMark->(!EOF())
				If !EMPTY(fMark->OK) .and. EMPTY(fMark->PV)
					RecLock("fMARK",.F.)
					fMark->PV  := SC5->C5_NUM
					fMark->(MsUnlock())
				Endif
				dbSelectArea("ZZQ")
				ZZQ->(dbGoto(fMark->RECZZQ))
				
				If RecLock("ZZQ",.F.)
					ZZQ->ZZQ_PVRESA := SC5->C5_NUM
					ZZQ->(MsUnlock())
				EndIf
				fMark->(DbSkip())
			EndDo
			MsgAlert("Pedido "+SC5->C5_NUM+" gerado com sucesso.")	
		Endif
	Else
		MsgAlert("Itens nใo selecionados ou PV gerado anteriormente!")	
	Endif
	
Endif

RestArea(aArea)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณVinicius Leonardo   บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPerguntas                                                   บฑฑ
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

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'NF Saida De    ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'NF Saida Ate   ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'NF Entrada De  ?','' ,'' , 'mv_ch3', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'NF Entrada Ate ?','' ,'' , 'mv_ch4', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Operacao       ?','' ,'' , 'mv_ch5', 'C', 03, 0, 0, 'G', '','ZZJ', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')

Return
