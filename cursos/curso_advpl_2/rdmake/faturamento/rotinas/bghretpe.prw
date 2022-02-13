
#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHRETPE º Autor ³Luciano Siqueira    º Data ³  19/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Gera pedido de venda de retorno ao cliente 				  º±±
±±º          ³das peças apontadas nos equipamentos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BGHRETPE()

Private cPerg		:= "BGHRETPE"

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

Processa({|| BGHRET1A()}, "Processando...")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHRET1A  º Autor ³Luciano Siqueira    º Data ³  19/02/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Tela para marcação dos itens 								  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BGHRET1A()

Local aArea := GetArea()
Local aCampos     := {}
Local aMark  := {;
{"OK"		, "C", 02, 0},;
{"NF"   	, "C", TamSX3("D2_DOC")[1],0},;
{"SERIE"	, "C", TamSX3("D2_SERIE")[1],0},;
{"PECA"	    , "C", TamSX3("D2_COD")[1],0},;
{"ARMAZ"    , "C", TamSX3("D2_LOCAL")[1],0},;
{"DESCRI"   , "C", TamSX3("B1_DESC")[1],0},;
{"IDENT"    , "C", TamSX3("B6_IDENT")[1],0},;
{"ITEM"     , "C", TamSX3("D1_ITEM")[1],0},;
{"PV"  		, "C", TamSX3("C5_NUM")[1],0},;
{"QTDE"	    , "C", 10,0},;
{"VLRUNI"	, "C", 20,0},;
{"VLRTOT"	, "C", 20,0},;
{"NFORI"   	, "C", TamSX3("D2_DOC")[1],0},;
{"SERORI"	, "C", TamSX3("D2_SERIE")[1],0},;
{"CLIORI"  	, "C", TamSX3("D2_CLIENTE")[1],0},;
{"LOJORI"	, "C", TamSX3("D2_LOJA")[1],0}}

Private dDtSaiIni := MV_PAR01
Private	dDtSaiFim := MV_PAR02
Private dDtEntIni := MV_PAR03
Private dDtEntFim := MV_PAR04
Private cOpera	  := MV_PAR05
Private cArmaz	  := MV_PAR06
Private cCliNFE80 := Posicione("ZZJ",1,xFilial("ZZJ") + cOpera, "ZZJ_CLIEPE")					
Private cMarca    := GetMark()
Private cCadastro := 'Pedido de Venda'
Private aRotina   := {{"Pedido de Venda" , "u_BGHRET2A()", 0, 1 }} 
Private aIdent	  := {}

AtuPNDef()

AADD(aCampos,{"OK"		,,	""})
AADD(aCampos,{"NF"		,,	"NF "})
AADD(aCampos,{"SERIE"	,,	"Serie"})
AADD(aCampos,{"PECA"	,,	"Produto"})
AADD(aCampos,{"ARMAZ"	,,	"Armazem"})
AADD(aCampos,{"DESCRI"	,,	"Descricao"})
AADD(aCampos,{"QTDE"  	,,	"Quantidade"})
AADD(aCampos,{"VLRUNI"  ,,	"Vlr Unitario"})
AADD(aCampos,{"VLRTOT"  ,,	"Vlr Total"})
AADD(aCampos,{"IDENT"	,,	"Ident. B6"})
AADD(aCampos,{"ITEM"	,,	"Item"})
AADD(aCampos,{"PV"		,,	"Pedido Venda"})
AADD(aCampos,{"NFORI"	,,	"NF Origem"})
AADD(aCampos,{"SERORI"	,,	"Serie Origem"})
AADD(aCampos,{"CLIORI"	,,	"Cli Origem"})
AADD(aCampos,{"LOJORI"	,,	"Loja Origem"}) 

if Select("fMark")>0
	dbSelectArea("fMark")
	dbCloseArea()
endif

cFileMark := CriaTrab(aMark,.T.)
DBUSEAREA(.T.,,cFileMark,"fMark",.F.)
IndRegua("fMark",cFileMark,"NF+SERIE",,,"Criando Arquivo Trabalho...")

cQuery := "	SELECT DISTINCT "
cQuery += "		B6_CLIFOR, B6_LOJA, "
cQuery += "		B6_DOC,B6_SERIE,D1_ITEM,B6_IDENT, "
cQuery += "		B6_PRODUTO,B6_LOCAL,(B6_SALDO-B6_QULIB) AS SALDO, "
cQuery += "		B6_PRUNIT, ZZQ_CLIORI, ZZQ_LOJORI, ZZQ_NFORI, ZZQ_SERORI "
cQuery += "	FROM "+ RETSQLNAME("SB6")+" SB6 (nolock) "
cQuery += "	INNER JOIN "+ RETSQLNAME("ZZQ")+" ZZQ (nolock) ON "
cQuery += "		ZZQ_FILIAL='"+xFilial("ZZQ")+"' AND "
cQuery += "		ZZQ_NFENTR=B6_DOC AND "
cQuery += "		ZZQ_SERENT=B6_SERIE AND "
//cQuery += "		ZZQ_IDEENT=B6_IDENT AND "

If !(cOpera $ "P02/P04")
	cQuery += "		CASE WHEN ZZQ_PNDEFE <> ZZQ_PECA THEN ZZQ_PNDEFE ELSE ZZQ_PECA END = B6_PRODUTO AND "
EndIf

cQuery += "		ZZQ_ARMAZ=B6_LOCAL AND "
cQuery += "		ZZQ.D_E_L_E_T_='' "
cQuery += " INNER JOIN "+ RETSQLNAME("SD1")+" SD1 (nolock) ON "
cQuery += "		D1_FILIAL='"+xFilial("SD1")+"' AND "
cQuery += "		D1_DOC=B6_DOC AND "
cQuery += "		D1_SERIE=B6_SERIE AND "
cQuery += "		D1_FORNECE=B6_CLIFOR AND "
cQuery += "		D1_LOJA=B6_LOJA AND "
cQuery += "		D1_COD=B6_PRODUTO AND "
cQuery += "		D1_IDENTB6=B6_IDENT AND "

If cOpera $ "P02/P04"
	cQuery += "		ZZQ_NFORI = D1_NFORI AND "
	cQuery += "		ZZQ_SERORI = D1_SERIORI AND "
EndIf		
	
cQuery += "		SD1.D_E_L_E_T_='' "
cQuery += "	WHERE "
cQuery += "		B6_FILIAL='"+xFilial("SB6")+"' AND "

If cOpera $ "P02/P04"
	cQuery += "		(B6_CLIFOR='"+LEFT(cCliNFE80,6)+"' OR B6_CLIFOR='191826') AND "
	cQuery += "		B6_LOJA='"+RIGHT(cCliNFE80,2)+"' AND "
Else
	cQuery += "		B6_CLIFOR='"+LEFT(cCliNFE80,6)+"' AND "
	cQuery += "		B6_LOJA='"+RIGHT(cCliNFE80,2)+"' AND "
EndIf
cQuery += "		(B6_SALDO-B6_QULIB) > 0 AND "
//cQuery += "		B6_PRODUTO='LK.14005.010   ' AND "
cQuery += "		ZZQ_DTSAID BETWEEN '"+DTOS(dDtSaiIni)+"' AND '"+DTOS(dDtSaiFim)+"' AND "
cQuery += "		ZZQ_DTENTR BETWEEN '"+DTOS(dDtEntIni)+"' AND '"+DTOS(dDtEntFim)+"' AND "
cQuery += "		ZZQ_OPEBGH='"+cOpera+"' AND "
cQuery += "		ZZQ_ARMAZ='"+cArmaz+"' AND "
cQuery += "		ZZQ.D_E_L_E_T_='' "
cQuery += "	ORDER BY B6_LOCAL, D1_ITEM,B6_PRODUTO "

If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL1",.T.,.T.)

TSQL1->(DBGoTop())

While TSQL1->(!EOF())
	nPos := Ascan(aIdent ,{ |x| Alltrim(x[1]) == TSQL1->B6_IDENT })
	If nPos == 0
		RecLock("fMARK",.T.)
		fMark->OK		:= SPACE(2)
		fMark->NF	  	:= TSQL1->B6_DOC
		fMark->SERIE	:= TSQL1->B6_SERIE
		fMark->PECA	    := TSQL1->B6_PRODUTO
		fMark->ARMAZ    := TSQL1->B6_LOCAL
		fMark->DESCRI   := Posicione("SB1",1,xFilial("SB1") +TSQL1->B6_PRODUTO,"B1_DESC")
		fMark->QTDE	    := TransForm(TSQL1->SALDO,"@E 999,999.99")
		fMark->VLRUNI   := TransForm(TSQL1->B6_PRUNIT,"@E 999,999,999.9999")
		fMark->VLRTOT   := TransForm(TSQL1->B6_PRUNIT*TSQL1->SALDO,"@E 999,999,999.9999")
		fMark->IDENT  	:= TSQL1->B6_IDENT
		fMark->ITEM  	:= TSQL1->D1_ITEM
		fMark->NFORI  	:= TSQL1->ZZQ_NFORI
		fMark->SERORI  	:= TSQL1->ZZQ_SERORI
		fMark->CLIORI  	:= TSQL1->ZZQ_CLIORI
		fMark->LOJORI  	:= TSQL1->ZZQ_LOJORI
		fMARK->(MSUNLOCK()) 
		aAdd(aIdent,{TSQL1->B6_IDENT})
	Endif
	TSQL1->(DBSkip())
EndDo

dbSelectArea("fMark")
fMark->(DbGotop())

If fMark->(!EOF())
	MarkBrow("fMark","OK",,aCampos,.F.,cMarca,"u_MarcaIte(1)",,,,"u_MarcaIte(2)")
Else
	MsgAlert("Não existem informações para os parametros selecionados.")
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHNFE10 º Autor ³Luciano Siqueira    º Data ³  13/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Geração da NF Entrada - Motorola 10%                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BGHRET2A()

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
			
			dbSelectArea("SB6")
			dbSetOrder(3)
			dbSeek(xFilial("SB6")+fMark->IDENT+fMark->PECA+"R")
			
			_nQuant := SB6->(B6_SALDO-B6_QULIB)
			_nVlUni := A410Arred(SB6->B6_PRUNIT,"C6_PRCVEN")
			_nVlTot := A410Arred(_nVlUni*_nQuant,"C6_VALOR")
			
			If cOpera $ "P02/P04"
				_nVlTot := Round(A410Arred(_nVlUni*_nQuant,"C6_VALOR"),2)
			EndIf
			
			//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial("SD1")+fMark->NFORI+fMark->SERORI+fMark->CLIORI+fMark->LOJORI+fMark->PECA)
			
			cNumPCom := Right(Alltrim(fMark->NFORI),6)+SB6->B6_LOCAL
			cItemPC  := SD1->D1_ITEM
						
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
			{"C6_NFORI"		,SB6->B6_DOC					,Nil},;
			{"C6_SERIORI"	,SB6->B6_SERIE					,Nil},;
			{"C6_ITEMORI"	,fMark->ITEM					,Nil},;
			{"C6_IDENTB6"	,SB6->B6_IDENT					,Nil},;
			{"C6_LOCAL"		,SB6->B6_LOCAL					,Nil},;
			{"C6_NUMPCOM"	,cNumPCom						,Nil},;
			{"C6_ITEMPC"	,cItemPC						,Nil},;
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
				fMark->(DbSkip())
			EndDo
			MsgAlert("Pedido "+SC5->C5_NUM+" gerado com sucesso.")	
		Endif
	Else
		MsgAlert("Itens não selecionados ou PV gerado anteriormente!")	
	Endif
	
Endif

RestArea(aArea)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValPerg   º Autor ³Luciano Siqueira    º Data ³  11/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Perguntas                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'NF Saida De    ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'NF Saida Ate   ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'NF Entrada De  ?','' ,'' , 'mv_ch3', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'NF Entrada Ate ?','' ,'' , 'mv_ch4', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Operacao       ?','' ,'' , 'mv_ch5', 'C', 03, 0, 0, 'G', '', 'ZZJ', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Armazem        ?','' ,'' , 'mv_ch6', 'C', 02, 0, 0, 'G', '', '', '', '', 'mv_par06',,,'','','','','','','','','','','','','','')

Return

Static Function AtuPNDef()

cQuery := " SELECT "
cQuery += "		ZZQ.R_E_C_N_O_ AS RECZZQ, "
cQuery += "		Z20.R_E_C_N_O_ AS RECZ20 "
cQuery += "	FROM "+ RETSQLNAME("ZZQ")+" ZZQ (nolock) "
cQuery += "	INNER JOIN "+ RETSQLNAME("ZZ4")+" ZZ4 (nolock)  ON "
cQuery += "		ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND "
cQuery += "		ZZ4_IMEI=ZZQ_IMEI AND "
cQuery += "		ZZ4_OS=ZZQ_NUMOS AND "
cQuery += "		ZZ4.D_E_L_E_T_= '' "
cQuery += "	INNER JOIN "+ RETSQLNAME("Z20")+" Z20 (nolock)  ON "
cQuery += "		Z20_FILIAL='"+xFilial("Z20")+"' AND "
cQuery += "		Z20_CSSNUM=ZZ4_GVSOS AND "
cQuery += "		Z20_PNUSAG=ZZQ_PECA AND "
cQuery += "		Z20.D_E_L_E_T_='' "
cQuery += "	WHERE "
cQuery += "		ZZQ_FILIAL='"+xFilial("ZZQ")+"' AND "
cQuery += "		ZZQ_OPEBGH = 'A01' AND "
cQuery += "		ZZQ_DTSAID >= '20150101' AND "
cQuery += "		ZZQ_PNDEFE = '' AND "
cQuery += "		ZZQ.D_E_L_E_T_='' AND "
cQuery += "		ZZ4_GVSOS <> '' "

If Select("TSQPN") > 0
	dbSelectArea("TSQPN")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQPN",.T.,.T.)

TSQPN->(DBGoTop())

While TSQPN->(!EOF())
	dbSelectArea("Z20")
	dbGoto(TSQPN->RECZ20)
	
	dbSelectArea("ZZQ")
	dbGoto(TSQPN->RECZZQ)
	
	RecLock("ZZQ",.F.)
	ZZQ->ZZQ_PNDEFE	:= Z20->Z20_PNDEFE
	MSUNLOCK()

	TSQPN->(DBSkip())
EndDo



Return