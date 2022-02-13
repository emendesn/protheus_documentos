
#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHENASS º Autor ³Vinicius Leonardo    º Data ³  13/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Geração de NF Entrada 				                      º±±
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
User Function BGHENASS()

Private cPerg		:= "BGHENASS"

u_GerA0003(ProcName())

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

Processa({|| BGHENT1A()}, "Processando...")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHENT1A º Autor ³Vinicius Leonardo   º Data ³  13/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Tela para marcação dos itens - NF Entrada 				  º±±
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
Static Function BGHENT1A()

Local aArea := GetArea()
Local aCampos     := {}
Local aMark  := {;
{"OK"		, "C", 02, 0},;
{"NFS"   	, "C", TamSX3("D2_DOC")[1],0},;
{"NFSSER"	, "C", TamSX3("D2_SERIE")[1],0},;
{"PECA"	    , "C", TamSX3("D2_COD")[1],0},;
{"DESCRI"   , "C", TamSX3("B1_DESC")[1],0},;
{"QTDE"	    , "C", 10,0},;
{"VLRUNI"	, "C", 20,0},;
{"VLRTOT"	, "C", 20,0},;
{"NFENT"   	, "C", TamSX3("D1_DOC")[1],0},;
{"SERENT"	, "C", TamSX3("D1_SERIE")[1],0},;
{"OPEBGH"	, "C", TamSX3("ZZJ_OPERA")[1],0},;
{"CC"	    , "C", TamSX3("ZZJ_CC")[1],0},;
{"RECZZQ"	, "N", 20,0}} 

Private cCnpjOpe	:= ""
Private nPerRent	:= 0 
Private cTpReent  := ""

Private cDocIni := MV_PAR01
Private cDocFim := MV_PAR02
Private cSerIni := MV_PAR03
Private cSerFim := MV_PAR04
Private cProIni := MV_PAR05
Private cProFim := MV_PAR06  
Private cOpeBgh	:= MV_PAR07

Private cCliNFE10 	:= Getmv("BH_CLINFE10",.F.,"Z0040301")

Private cMarca    := GetMark()
Private cCadastro := 'NF Entrada'
Private aRotina   := {{"NF Entrada" , "u_BGHNFEAS()", 0, 1 }}

cTpReent := Posicione("ZZJ",1,xFilial("ZZJ") + cOpeBgh, "ZZJ_TPRENT")
cCnpjOpe := Posicione("ZZJ",1,xFilial("ZZJ") + cOpeBgh, "ZZJ_CNPJRE")

AADD(aCampos,{"OK"		,,	""})
AADD(aCampos,{"NFS"		,,	"NF Saida"})
AADD(aCampos,{"NFSSER"	,,	"Serie Saida"})
AADD(aCampos,{"PECA"	,,	"Produto"})
AADD(aCampos,{"DESCRI"	,,	"Descricao"})
AADD(aCampos,{"QTDE"  	,,	"Quantidade"})
AADD(aCampos,{"VLRUNI"  ,,	"Vlr Unitario"})
AADD(aCampos,{"VLRTOT"  ,,	"Vlr Total"})
AADD(aCampos,{"NFENT"	,,	"NF Entrada"})
AADD(aCampos,{"SERENT"	,,	"Serie Entrada"})

if Select("fMark")>0
	dbSelectArea("fMark")
	dbCloseArea()
endif

cFileMark := CriaTrab(aMark,.T.)
DBUSEAREA(.T.,,cFileMark,"fMark",.F.)
IndRegua("fMark",cFileMark,"NFS+NFSSER",,,"Criando Arquivo Trabalho...")

cQuery := " SELECT " + CRLF
cQuery += " ZZQ_PV, " + CRLF
cQuery += " ZZQ_ITEMPV, " + CRLF
cQuery += " ZZQ_NFS, " + CRLF
cQuery += " ZZQ_NFSSER, " + CRLF
cQuery += " ZZQ_PECA, " + CRLF
cQuery += " ZZQ_QTDE, " + CRLF
cQuery += " B2_CM1 AS ZZQ_VLRUNI, " + CRLF 
cQuery += " ZZQ_QTDE*B2_CM1 AS ZZQ_VLRTOT, " + CRLF
cQuery += " ZZJ_OPERA, " + CRLF
cQuery += " ZZJ_CC, " + CRLF
cQuery += " ZZQ.R_E_C_N_O_ AS RECZZQ " + CRLF
cQuery += " FROM "+ RETSQLNAME("ZZQ")+" ZZQ (nolock) " + CRLF
cQuery += " INNER JOIN "+ RETSQLNAME("ZZJ")+" ZZJ (nolock) " + CRLF
cQuery += " ON (ZZJ_FILIAL = '"+xFilial("ZZJ")+"' " + CRLF
cQuery += " AND ZZJ_OPERA=ZZQ_OPEBGH AND ZZJ_PVPECA='S' AND ZZJ.D_E_L_E_T_ = '') " + CRLF 
cQuery += " INNER JOIN "+ RETSQLNAME("ZZ4")+" ZZ4 (NOLOCK) ON " + CRLF
cQuery += " ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND " + CRLF
cQuery += " ZZ4_IMEI=ZZQ_IMEI AND " + CRLF
cQuery += " ZZ4_OS=ZZQ_NUMOS AND " + CRLF
cQuery += " ZZ4.D_E_L_E_T_='' " + CRLF
cQuery += " INNER JOIN ( " + CRLF
cQuery += " 	SELECT DISTINCT Z9_IMEI, Z9_NUMOS, Z9_LOCAL FROM "+ RETSQLNAME("SZ9")+" SZ9 (NOLOCK) " + CRLF
cQuery += " 	WHERE Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_=''  ) Z9 ON	  " + CRLF
cQuery += " 	Z9_IMEI=ZZQ_IMEI AND  " + CRLF
cQuery += " 	Z9_NUMOS=ZZQ_NUMOS 	  " + CRLF
cQuery += " INNER JOIN "+ RETSQLNAME("SB2")+" SB2 (NOLOCK) ON  " + CRLF
cQuery += " B2_FILIAL='"+xFilial("SB2")+"' AND  " + CRLF
cQuery += " B2_COD=ZZQ_PECA AND  " + CRLF
cQuery += " B2_LOCAL=Z9.Z9_LOCAL AND " + CRLF
cQuery += " SB2.D_E_L_E_T_='' " + CRLF
cQuery += " WHERE " + CRLF
cQuery += " ZZQ_FILIAL = '"+xFilial("ZZQ")+"' " + CRLF
cQuery += " AND ZZQ_NFS BETWEEN '"+cDocIni+"' AND '"+cDocFim+"' " + CRLF
cQuery += " AND ZZQ_NFSSER BETWEEN '"+cSerIni+"' AND '"+cSerFim+"' " + CRLF
cQuery += " AND ZZQ_PECA BETWEEN '"+cProIni+"' AND '"+cProFim+"' " + CRLF
cQuery += " AND ZZQ_DTSAID <> '' " + CRLF
cQuery += " AND ZZJ_OPERA = '"+cOpeBgh+"' " + CRLF
cQuery += " AND ZZQ_NFS <> '' " + CRLF
cQuery += " AND ZZQ_NFENTR = '' " + CRLF 
cQuery += " AND ZZQ.D_E_L_E_T_ = '' " + CRLF
cQuery += " ORDER BY ZZQ_PECA " + CRLF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL1",.T.,.T.)

TSQL1->(DBGoTop())

While TSQL1->(!EOF())
	RecLock("fMARK",.T.)
	fMark->OK		:= SPACE(2)
	fMark->NFS  	:= TSQL1->ZZQ_NFS
	fMark->NFSSER   := TSQL1->ZZQ_NFSSER
	fMark->PECA	    := TSQL1->ZZQ_PECA
	fMark->DESCRI   := Posicione("SB1",1,xFilial("SB1") +TSQL1->ZZQ_PECA,"B1_DESC")
	fMark->QTDE	    := TransForm(TSQL1->ZZQ_QTDE,"@E 999,999.99")
	fMark->VLRUNI   := TransForm(TSQL1->ZZQ_VLRUNI,"@E 999,999,999.9999")
	fMark->VLRTOT   := TransForm(TSQL1->ZZQ_VLRTOT,"@E 999,999,999.9999")
	fMark->OPEBGH   := TSQL1->ZZJ_OPERA
	fMark->CC       := TSQL1->ZZJ_CC
	fMark->RECZZQ   := TSQL1->RECZZQ
	fMARK->(MSUNLOCK())
	TSQL1->(DBSkip())
EndDo

dbSelectArea("fMark")
fMark->(DbGotop()) 

If fMark->(!EOF())
	MarkBrow("fMark","OK",,aCampos,.F.,cMarca,"u_MarItem(1)",,,,"u_MarItem(2)")
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
±±ºPrograma  ³ BGHNFEAS º Autor ³Vinicius Leonardo   º Data ³  13/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Geração da NF Entrada 				                      º±±
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
User Function BGHNFEAS()

Local aArea:=GetArea()

Processa({|| BGHNFE1A()},"Processando NF Entrada.")

RestArea(aArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHNFE1A º Autor ³Vinicius Leonardo   º Data ³  13/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Geração da NF Entrada 				                      º±±
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
Static Function BGHNFE1A()

Local aArea:=GetArea()
Local aCab 		:= {}
Local aItens   	:= {}
Local aIteAglu  := {}
Local aLinha	:= {}
Local cItens    := '0000'
Local aSeries  	:=	{}
Local cTEPeca   := ""
Local cAlmScr   := ""
Local aResult	:= {}
Local lRet		:= .F.
Local cMsgErr	:= "" 
Local _cDoc		:= ""
Local _cSer		:= "3"

Private lProces := .F.
Private nStack  := 0
Private lMsg    := .F.
Private aRet	:= {}

dbSelectArea("fMark")
fMark->(DbGotop())

If fMark->(!EOF())
	
	While fMark->(!EOF())
		
		If !EMPTY(fMark->OK) .and. EMPTY(fMark->NFENT)
		
			If len(aCab) == 0
					
				aCab := {	{"F1_TIPO"   ,"N"        			,NIL},;
							{"F1_FILIAL" ,xFilial("SF1")    	,NIL},;
							{"F1_FORMUL" ,"S"        			,NIL},;
							{"F1_EMISSAO",dDataBase			 	,NIL},;
							{"F1_DTDIGIT",dDataBase         	,NIL},;
							{"F1_FORNECE",substr(cCliNFE10,1,6)	,NIL},;
							{"F1_SERIE"  ,_cSer   		    	,NIL},;
							{"F1_DOC"    ,_cDoc 	     		,NIL},;
							{"F1_LOJA"   ,substr(cCliNFE10,7,2)	,NIL},;
							{"F1_ESPECIE","SPED"        		,NIL}}
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+fMark->PECA)
			
			dbSelectArea("ZZQ")
			ZZQ->(dbGoto(fMark->RECZZQ))
			
			cTEPeca := Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_TEPECA")
			cAlmScr := Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_ALMSCR")
			nPerc   := Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_PERCRE")
			
			_nQuant := ZZQ->ZZQ_QTDE
			_nVlUni := A410Arred((ZZQ->ZZQ_VLRUNI*nPerc)/100,"D1_TOTAL")
			_nVlTot := A410Arred(_nVlUni*_nQuant,"D1_TOTAL")
			
			DbSelectarea("SB2")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SB2")+fMark->PECA+cAlmScr,.F.)
				CriaSb2(fMark->PECA,cAlmScr)
			Endif	
			
			cItens := Soma1(cItens,4)
			aLinha := {	{"D1_FILIAL" ,xFilial("SD1")			,NIL},;
			{"D1_TIPO"   ,"N"									,NIL},;
			{"D1_COD"    ,fMark->PECA							,NIL},;
			{"D1_ITEM"   ,cItens								,NIL},;
			{"D1_UM"     ,SB1->B1_UM							,NIL},;
			{"D1_CONTA"  ,SB1->B1_CONTA        					,NIL},;
			{"D1_CC"  	 ,fMark->CC  							,NIL},;
			{"D1_LOCAL"  ,cAlmScr			   					,NIL},;
			{"D1_TES"    ,cTEPeca		     					,NIL},;
			{"D1_QUANT"  ,_nQuant      							,NIL},;
			{"D1_VUNIT"  ,_nVlUni								,NIL},;
			{"D1_TOTAL"  ,_nVlTot								,NIL},;
			{"D1_DOC"    ,_cDoc 	      						,NIL},;
			{"D1_SERIE"  ,_cSer       							,NIL},;
			{"D1_FORNECE",substr(cCliNFE10,1,6)					,NIL},;
			{"D1_LOJA"   ,substr(cCliNFE10,7,2)					,NIL},;
			{"D1_EMISSAO",dDataBase 							,NIL},;
			{"D1_DTDIGIT",dDataBase								,NIL},;
			{"D1_DTDOCA" ,dDataBase         					,NIL},;
			{"D1_HRDOCA" ,"000000"           					,NIL}}
			
			AAdd( aItens, aLinha )
			
		Endif
		
		fMark->(DbSkip())
	
	EndDo
	
	If Len(aItens) > 0 
		aIteAglu := {}
		For nI := 1 To Len(aItens)
			_aLinha := aClone(aItens[nI])
			nPosProd := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_COD'})
			nPosUnit := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_VUNIT'})
			nPosQtde := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_QUANT'})
			nPosTot  := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_TOTAL'})
			nPos := Ascan(aIteAglu,{|x| x[nPosProd][2] == aItens[nI][nPosProd][2] .AND.;
			x[nPosUnit][2] == aItens[nI][nPosUnit][2]})
			If nPos == 0
				aAdd(aIteAglu,aItens[nI])
			Else
				aIteAglu[nPos][nPosQtde][2] += aItens[nI][nPosQtde][2]
				aIteAglu[nPos][nPosTot][2] := A410Arred(aIteAglu[nPos][nPosUnit][2]*aIteAglu[nPos][nPosQtde][2],"D1_TOTAL")
			EndIf
		Next
			
		If (Len(aCab) > 0) .And. (Len(aIteAglu) > 0) 
		
			aResult := GERANFE(aCab,aIteAglu,_cSer)
			If Len(aResult) > 0
				cMsgErr += aResult[1][1]
				lRet	:= aResult[1][2]
				_cDoc	:= aResult[1][3]
			EndIf
			lProces := .F.
			nStack  := 0
			lMsg    := .F.
			aRet	:= {} 
			
			If !lRet
				dbSelectArea("fMark")
				fMark->(DbGotop())
				While fMark->(!EOF())
					If !EMPTY(fMark->OK) .and. EMPTY(fMark->NFENT)
						RecLock("fMARK",.F.)
						fMark->NFENT  := _cDoc
						fMark->SERENT := _cSer
						fMark->(MsUnlock())
						
						dbSelectArea("ZZQ")
						ZZQ->(dbGoto(fMark->RECZZQ))
						
						If RecLock("ZZQ",.F.)
							ZZQ->ZZQ_NFENTR  := _cDoc
							ZZQ->ZZQ_SERENT  := _cSer
							ZZQ->ZZQ_DTENTR  := dDataBase
							ZZQ->(MsUnlock())
						EndIf
					Endif
					fMark->(DbSkip())
				EndDo
				
				MsgAlert("Nota Fiscal "+Alltrim(_cDoc)+"/"+_cSer+" gerada com sucesso.")
			Else
				//mostraerro()
				MsgAlert(cMsgErr)		
			Endif
		Endif
	Else
		MsgAlert("Itens não selecionados ou NF gerada anteriormente!")	
	Endif
	
Endif

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NfeNextDocºAutor  ³Vinicius Leonardo   º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controla numeracao da nota                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NFENextDoc(cNumero)

Local _lRet     := .T.
Local _nItensNf := 0
Local _cTipoNF  := SuperGetMv("MV_TPNRNFS")

//lRetorno:= Sx5NumNota(@cSerie,cTipoNf)
cNumero := NxtSX5Nota(cSerie,NIL,_cTipoNF)

If Len(Alltrim(cNumero)) == 6
	cNumero := PadR(cNumero,9)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacao da NF informada pelo usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF1->(dbSetOrder(1))
If SF1->(MsSeek(xFilial("SF1") + cNumero + cSerie + cCliNFE10,.F.))
	Help(" ",1,"EXISTNF")
	_lRet    := .F.
	cNumero := ""
EndIf

Return(_lRet)  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarItem	ºAutor  ³Vinicius Leonardo   º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controla numeracao da nota                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MarItem(nOpc)

If nOpc == 1 // Marcar todos
	fMark->(DbGotop())
	Do While fMark->(!EOF())
		RecLock("fMark",.F.)
		fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
		fMark->(MsUnlock())
		fMark->(DbSkip())
	Enddo
	dbGoTop()
Elseif nOpc == 2  // Marcar somente o registro posicionado
	RecLock("fMark",.F.)
	fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
	MsUnLock()
Endif

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValPerg   º Autor ³Vinicius Leonardo	 º Data ³  11/06/12   º±±
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

PutSx1(cPerg, '01', 'NF Saida De    ?','' ,'' , 'mv_ch1', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'NF Saida Ate   ?','' ,'' , 'mv_ch2', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Serie De       ?','' ,'' , 'mv_ch3', 'C', 3, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Serie Ate      ?','' ,'' , 'mv_ch4', 'C', 3, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Produto De     ?','' ,'' , 'mv_ch5', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto Ate    ?','' ,'' , 'mv_ch6', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Operacao       ?','' ,'' , 'mv_ch7', 'C', 03, 0, 0, 'G', '', 'ZZJ', '', '', 'mv_par07',,,'','','','','','','','','','','','','','')

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Vinicius Leonardo  º Data ³  19/02/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 		  													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERANFE(aCabec,aItens,cSerNf)

Local nHdlSemaf := 0
Local cRotinExc := "NFEBAT" 
Local lRet 	  	:= .T.

//MAXIMO DE 200 PILHAS DE CHAMADAS
While !U_SemaNFE(cRotinExc, @nHdlSemaf, .T., lProces)
	If lProces .or. nStack >= 100 
		If nStack >= 100
			If !lMsg
				Aadd(aRet,{'Não foi possível realizar a entrada da NF por controle de processamento, tente novamente mais tarde.',.T.,""})
				lMsg := .T.
			EndIf
		EndIf
		Return aRet
	EndIf
	nStack:=nStack+1
	Sleep(200)
	GERANFE(aCabec,aItens,cSerNf)
EndDo 

lProces := .T.

cNumNf := AvKey(Alltrim(GetSetNF(cSerNf)),"F1_DOC")
If Empty(cNumNf)
	Aadd(aRet,{'Problemas para buscar NF de entrada',.T.,""})
	lRet := .F.
	U_retnfant(cNumNf,cSerNf)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Buscando o número da NF corretamente, ajusta os arrays para MsExecauto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aItens)
		nPosNum	:= Ascan(aItens[nX],{|x|x[1] = "D1_DOC"})
		aItens[nX][nPosNum][2] := cNumNf
	Next nX
	nPosNum	:= Ascan(aCabec,{|x|x[1] = "F1_DOC"})
	aCabec[nPosNum][2] := cNumNf
	lRet := .T.
EndIf
If lRet
	lMsErroAuto := .F.
	MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec, aItens,3)
	If lMsErroAuto
		DisarmTransaction()
		Aadd(aRet,{'Erro no ExecAuto',.T.,""})
		U_retnfant(cNumNf,cSerNf)
	Else
		Aadd(aRet,{'Ok',.F.,cNumNf})	
	EndIf
EndIf	

U_SemaNFE(cRotinExc, @nHdlSemaf, .F.)

Return aRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetSetNF  ºAutor  ³Hudson de Souza Santos  ºData ³ 16/04/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Método diferente para buscar a NF já comitando              º±±
±±º          ³*Melhor deixar NF's inutilizadas a duplicar NF.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetSetNF(cSerNf)
Local cTab		:= "01"
Local cFilSX5	:= xFilial("SF1")
Local cNumNF	:= ""
dbSelectArea("SX5")
dbSetOrder(1)
If ( dbSeek(cFilSX5+cTab+cSerNF) )
	RecLock("SX5",.F.)
	cNumNF			:= SX5->X5_DESCRI
	SX5->X5_DESCRI  := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->X5_DESCSPA := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->X5_DESCENG := StrZero(Val(cNumNF)+1,Len(Alltrim(cNumNF)))
	SX5->(MsUnLock())
EndIf
Return(cNumNF)

