#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHENT10 บ Autor ณLuciano Siqueira    บ Data ณ  13/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera็ใo de NF Entrada - ACER 80%                            บฑฑ
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
User Function BGHENT80()

Private cPerg		:= "BGHENT80"

u_GerA0003(ProcName())

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

Processa({|| BGHENT8A()}, "Processando...")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHENT8A บ Autor ณLuciano Siqueira    บ Data ณ  13/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para marca็ใo dos itens - NF Entrada - ACER 80%        บฑฑ
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
Static Function BGHENT8A()

Local aArea := GetArea()
Local aCampos     := {}
Local aMark  := {;
{"OK"		, "C", 02, 0},;
{"NFS"   	, "C", TamSX3("D2_DOC")[1],0},;
{"NFSSER"	, "C", TamSX3("D2_SERIE")[1],0},;
{"PECA"	    , "C", TamSX3("D2_COD")[1],0},;
{"ARMAZ"    , "C", TamSX3("D2_LOCAL")[1],0},;
{"DESCRI"   , "C", TamSX3("B1_DESC")[1],0},;
{"QTDE"	    , "N", 09,2},;
{"VLRUNI"	, "N", 13,2},;
{"VLRTOT"	, "N", 13,2},;
{"NFENT"   	, "C", TamSX3("D1_DOC")[1],0},;
{"SERENT"	, "C", TamSX3("D1_SERIE")[1],0},;
{"OPEBGH"	, "C", TamSX3("ZZJ_OPERA")[1],0},;
{"CC"	    , "C", TamSX3("ZZJ_CC")[1],0},;
{"CSSNUM"   , "C", TamSX3("Z20_CSSNUM")[1],0},;
{"OBS"   	, "C", 150,0},;
{"RECZZQ"	, "N", 20,0}}


Private cDocIni := MV_PAR01
Private cDocFim := MV_PAR02
Private cSerIni := MV_PAR03
Private cSerFim := MV_PAR04
Private cProIni := MV_PAR05
Private cProFim := MV_PAR06
Private cCliente:= MV_PAR07
Private cLoja	:= MV_PAR08       
Private dDtDe	:= MV_PAR09       
Private dDtAte	:= MV_PAR10       
Private cArmDe	:= MV_PAR11       
Private cArmAte	:= MV_PAR12       

Private cCGC    	:=Posicione("SA1",1,xFilial("SA1") + cCliente + cLoja, "A1_CGC")
Private cCliNFE80 	:= ""//Getmv("BH_CLINFE10",.F.,"19182601")
Private cOpAcer 	:= Getmv("BH_XOPACER",.F.,"A01")


Private cMarca    := GetMark()
Private cCadastro := 'NF Entrada'
Private aRotina   := {{"NF Entrada" , "u_BGHNFE80()", 0, 1 },;
					  {"Relatorio" , "u_IMPEXC80()", 0, 2 }}
					  

AADD(aCampos,{"OK"		,,	""})
AADD(aCampos,{"NFS"		,,	"NF Saida"})
AADD(aCampos,{"NFSSER"	,,	"Serie Saida"})
AADD(aCampos,{"PECA"	,,	"Produto"})
AADD(aCampos,{"ARMAZ"	,,	"Armazem"})
AADD(aCampos,{"DESCRI"	,,	"Descricao"})
AADD(aCampos,{"QTDE"  	,,	"Quantidade"})
AADD(aCampos,{"VLRUNI"  ,,	"Vlr Unitario"})
AADD(aCampos,{"VLRTOT"  ,,	"Vlr Total"})
AADD(aCampos,{"NFENT"	,,	"NF Entrada"})
AADD(aCampos,{"SERENT"	,,	"Serie Entrada"})  
AADD(aCampos,{"CSSNUM"	,,	"Ticket"})  
AADD(aCampos,{"OBS"		,,	"Observa็ใo"})  

if Select("fMark")>0
	dbSelectArea("fMark")
	dbCloseArea()
endif

cFileMark := CriaTrab(aMark,.T.)
DBUSEAREA(.T.,,cFileMark,"fMark",.F.)
IndRegua("fMark",cFileMark,"NFS+NFSSER",,,"Criando Arquivo Trabalho...")

cQuery := " SELECT "
cQuery += " 	ZZQ_NFORI, "
cQuery += " 	ZZQ_SERORI, "
cQuery += " 	ZZQ_PV, "
cQuery += " 	ZZQ_ITEMPV, "
cQuery += " 	ZZQ_NFS, "
cQuery += " 	ZZQ_NFSSER, "
cQuery += " 	PECA = CASE WHEN Z20_PNDEFE IS NOT NULL THEN Z20_PNDEFE ELSE ZZQ_PECA END, "
cQuery += " 	ZZQ_PECA, "
cQuery += " 	ZZQ_ARMAZ, "
cQuery += " 	ZZQ_QTDE, "
cQuery += " 	ZZQ_VLRUNI, "
cQuery += " 	ZZQ_VLRTOT, "
cQuery += " 	ZZJ_OPERA, "
cQuery += " 	ZZJ_CC, "
cQuery += " 	ZZQ.R_E_C_N_O_ AS RECZZQ, "
cQuery += " 	ZZ4.ZZ4_GVSOS AS GVSOS, "
cQuery += " 	CSSNUM = CASE WHEN Z20_CSSNUM IS NOT NULL THEN Z20_CSSNUM ELSE SPACE(30) END "
cQuery += " FROM "+ RETSQLNAME("ZZQ")+" ZZQ (nolock) "
cQuery += " INNER JOIN "+ RETSQLNAME("ZZJ")+" ZZJ (nolock) ON  "
cQuery += " 	ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND  "
cQuery += " 	ZZJ_OPERA = ZZQ_OPEBGH AND "
cQuery += " 	ZZJ_GEPECA='S' AND "
cQuery += " 	ZZJ.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 (nolock) ON " 
cQuery += " 	A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += " 	A1_COD = ZZQ_CLIORI AND "
cQuery += " 	A1_LOJA = ZZQ_LOJORI AND "
cQuery += " 	LEFT(A1_CGC,8) = '"+LEFT(cCGC,8)+"' AND "
cQuery += " 	SA1.D_E_L_E_T_= '' "
cQuery += " INNER JOIN "+ RETSQLNAME("ZZ4")+" ZZ4 (NOLOCK) ON "
cQuery += " 	ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND "
cQuery += " 	ZZ4_IMEI = ZZQ_IMEI AND "
cQuery += " 	ZZ4_OS = ZZQ_NUMOS AND "
cQuery += " 	ZZ4.D_E_L_E_T_= '' "
cQuery += " LEFT JOIN "+ RETSQLNAME("Z20")+" Z20 (NOLOCK) ON "
cQuery += " 	Z20_FILIAL='"+xFilial("Z20")+"' AND "
cQuery += " 	Z20_CSSNUM=ZZ4_GVSOS AND "
cQuery += " 	Z20_PNUSAG=ZZQ_PECA AND "
cQuery += " 	Z20.D_E_L_E_T_='' "
cQuery += " WHERE "
cQuery += " 	ZZQ_FILIAL = '"+xFilial("ZZQ")+"' "
cQuery += " 	AND ZZQ_NFS BETWEEN '"+cDocIni+"' AND '"+cDocFim+"' "
cQuery += " 	AND ZZQ_NFSSER BETWEEN '"+cSerIni+"' AND '"+cSerFim+"' "
cQuery += " 	AND ZZQ_PECA BETWEEN '"+cProIni+"' AND '"+cProFim+"' "
cQuery += " 	AND ZZQ_OPEBGH = '"+cOpAcer+"' "
cQuery += " 	AND ZZQ_ARMAZ BETWEEN '"+cArmDe+"' AND '"+cArmAte+"' "
cQuery += " 	AND ZZQ_DTSAID BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "
cQuery += " 	AND ZZQ_NFS <> '' "
cQuery += " 	AND ZZQ_NFENTR = '' "
cQuery += " 	AND ZZQ.D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZZQ_ARMAZ, PECA "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL1",.T.,.T.)

TSQL1->(DBGoTop())

While TSQL1->(!EOF())
    
	cObs  := ""
	cpeca := ""
	cTabPreco := Getmv("BH_XTABPEC",.F.,"AC3")
	lpconAcer := .F.
	
	_nVlUni := 0
	_nVlTot := 0
	
	dbSelectArea("SB1")
    dbSetOrder(1)


	If !dbSeek(xFilial("SB1")+TSQL1->PECA,.F.) .and. TSQL1->ZZQ_ARMAZ = "AD"
	   cObs := cObs+"PN com Defeito nใo localizado no cadastro de produto!"
    
    Elseif (dbSeek(xFilial("SB1")+TSQL1->PECA,.F.) .and. TSQL1->ZZQ_ARMAZ = "AD") .or. (dbSeek(xFilial("SB1")+TSQL1->PECA,.F.) .and. TSQL1->ZZQ_ARMAZ = "SA")
       cpeca := TSQL1->PECA

    Elseif !dbSeek(xFilial("SB1")+TSQL1->PECA,.F.) .and. TSQL1->ZZQ_ARMAZ = "SA"
       cpeca := TSQL1->ZZQ_PECA  
       
    Elseif dbSeek(xFilial("SB1")+TSQL1->PECA,.F.) .and. TSQL1->ZZQ_ARMAZ = "XX"       
       lpconAcer := .T.
    Endif
	
			
	dbSelectArea("DA1")
	dbSetOrder(1)
	If dbSeek(xFilial("DA1")+cTabPreco+cpeca) .and. !lpconAcer
		_nVlUni := DA1->DA1_PRCVEN
		_nVlTot := A410Arred(_nVlUni*TSQL1->ZZQ_QTDE,"D1_TOTAL")
	Endif			                
	
	IF  _nVlUni == 0 .and. TSQL1->ZZQ_ARMAZ = "SA" .and. !Left(cpeca ,2) $ "KL/LK/NB/MB/DB/HB/HD/KN" 
     	_nVlUni :=  TSQL1->ZZQ_VLRUNI
	    _nVlTot :=  A410Arred(_nVlUni*TSQL1->ZZQ_QTDE,"D1_TOTAL")
	ENDIF            
	

	If Empty(TSQL1->CSSNUM) .and. !lpconAcer
		cObs := cObs+"Pe็a Def x Cons nใo importada! "
	Endif                                   
	
	If _nVlUni == 0  .and. !lpconAcer
		cObs := cObs+"Pe็a nใo encontrada na tabela de pre็o! "  
	Endif                            
	
	If Empty(TSQL1->ZZQ_ARMAZ) .and. !lpconAcer
		cObs := cObs+"Armazem da pe็a nใo encontrado!"  				
	Endif                  
	                           
	
    IF  !lpconAcer
	
			RecLock("fMARK",.T.)
			fMark->OK		:= SPACE(2)
			fMark->NFS  	:= TSQL1->ZZQ_NFS
			fMark->NFSSER   := TSQL1->ZZQ_NFSSER
			fMark->PECA	    := cpeca
			fMark->ARMAZ    := TSQL1->ZZQ_ARMAZ
			fMark->DESCRI   := Posicione("SB1",1,xFilial("SB1") +TSQL1->PECA,"B1_DESC")
			//fMark->QTDE	:= TransForm(TSQL1->ZZQ_QTDE,"@E 999,999.99")
			//fMark->VLRUNI := TransForm(_nVlUni,"@E 999,999,999.9999")//TSQL1->ZZQ_VLRUNI
			//fMark->VLRTOT := TransForm(_nVlTot,"@E 999,999,999.9999")//TSQL1->ZZQ_VLRTOT
			fMark->QTDE	    := TSQL1->ZZQ_QTDE
			fMark->VLRUNI   := _nVlUni
			fMark->VLRTOT   := _nVlTot
			fMark->OPEBGH   := TSQL1->ZZJ_OPERA
			fMark->CC       := TSQL1->ZZJ_CC
			fMark->RECZZQ   := TSQL1->RECZZQ
			fMark->CSSNUM   := TSQL1->GVSOS//TSQL1->CSSNUM
			fMark->OBS		:= cObs
			fMARK->(MSUNLOCK())
	
	ENDIF		
	TSQL1->(DBSkip())
EndDo

dbSelectArea("fMark")
fMark->(DbGotop()) 

If fMark->(!EOF())
	MarkBrow("fMark","OK",,aCampos,.F.,cMarca,"u_MarcIt80(1)",,,,"u_MarcIt80(2)")
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
ฑฑบPrograma  ณ BGHNFE80 บ Autor ณLuciano Siqueira    บ Data ณ  13/09/12   บฑฑ
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
User Function BGHNFE80()

Local aArea:=GetArea()

Processa({|| BGHNFE1A()},"Processando NF Entrada.")

RestArea(aArea)

Return

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

Private cNumero		:=	""
Private cSerie		:=	"3"
Private _cDoc		:=	""
Private _cSer		:=	""
Private lMsErroAuto := .F.
Private _lContinua  := .T.

dbSelectArea("fMark")
fMark->(DbGotop())

If fMark->(!EOF())
	
	While fMark->(!EOF())
		
		If !EMPTY(fMark->OK) .and. EMPTY(fMark->NFENT)
			cCliNFE80 := Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_CLIEPE")					
			If len(aCab) == 0
				If _lContinua				
					cNfnant := U_GetNfeNum(cSerie,.F.)
					If !NFENextDoc(@cNumero)				
						MsgAlert("Erro ao buscar pr๓xima Nota Fiscal de Entrada.")
						U_retnfant(cNfnant,cSerie)
						Return(.F.)
					EndIf
				EndIf
	
				_cDoc := cNumero
				_cSer := cSerie
													
				aCab := {	{"F1_TIPO"   ,"B"        			,NIL},;
				{"F1_FILIAL" ,xFilial("SF1")    	,NIL},;
				{"F1_FORMUL" ,"S"        			,NIL},;
				{"F1_EMISSAO",dDataBase			 	,NIL},;
				{"F1_DTDIGIT",dDataBase         	,NIL},;
				{"F1_FORNECE",substr(cCliNFE80,1,6)	,NIL},;
				{"F1_SERIE"  ,_cSer   		    	,NIL},;
				{"F1_DOC"    ,_cDoc 	     		,NIL},;
				{"F1_LOJA"   ,substr(cCliNFE80,7,2)	,NIL},;
				{"F1_ESPECIE","SPED"        		,NIL}}
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+fMark->PECA)
			
			dbSelectArea("ZZQ")
			ZZQ->(dbGoto(fMark->RECZZQ))
			
			cTEPeca := Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_TEPECA")
			cAlmScr := ZZQ->ZZQ_ARMAZ//Posicione("ZZJ",1,xFilial("ZZJ") + fMark->OPEBGH, "ZZJ_ALMSCR")
			nPerc	:= 80
			_nQuant := ZZQ->ZZQ_QTDE
			
			cTabPreco := Getmv("BH_XTABPEC",.F.,"AC3")
	
			_nVlUni := fMark->VLRUNI
			_nVlTot := fMark->VLRTOT
			
			// Desabilitado, pois nao precisa buscar novamente na tabela, poi o pre็o jแ estแ composto no temporแrio.
			// Edson Rodrigues - 06/05/15
			
			//dbSelectArea("DA1")
			//dbSetOrder(1)
			//If dbSeek(xFilial("DA1")+cTabPreco+fMark->PECA)
			//	_nVlUni := DA1->DA1_PRCVEN
			//	_nVlTot := A410Arred(_nVlUni*_nQuant,"D1_TOTAL")
			//Endif		 
			
			
			DbSelectarea("SB2")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SB2")+fMark->PECA+cAlmScr,.F.)
				CriaSb2(fMark->PECA,cAlmScr)
			Endif	
			
			cItens := Soma1(cItens,4)
			aLinha := {	{"D1_FILIAL" ,xFilial("SD1")					,NIL},;
			{"D1_TIPO"   ,"B"								,NIL},;
			{"D1_COD"    ,fMark->PECA			,NIL},;
			{"D1_ITEM"   ,cItens							,NIL},;
			{"D1_UM"     ,SB1->B1_UM						,NIL},;
			{"D1_CONTA"  ,SB1->B1_CONTA        				,NIL},;
			{"D1_CC"  	 ,fMark->CC  						,NIL},;
			{"D1_LOCAL"  ,cAlmScr			   				,NIL},;
			{"D1_TES"    ,cTEPeca		     				,NIL},;
			{"D1_NFORI"  ,ZZQ->ZZQ_NFORI	   				,NIL},;
			{"D1_SERIORI",ZZQ->ZZQ_SERORI	   				,NIL},;	
			{"D1_QUANT"  ,_nQuant      						,NIL},;
			{"D1_VUNIT"  ,_nVlUni							,NIL},;
			{"D1_TOTAL"  ,_nVlTot							,NIL},;
			{"D1_DOC"    ,_cDoc 	      					,NIL},;
			{"D1_SERIE"  ,_cSer       						,NIL},;
			{"D1_FORNECE",substr(cCliNFE80,1,6)				,NIL},;
			{"D1_LOJA"   ,substr(cCliNFE80,7,2)				,NIL},;
			{"D1_EMISSAO",dDataBase 						,NIL},;
			{"D1_DTDIGIT",dDataBase							,NIL},;
			{"D1_DTDOCA" ,dDataBase         				,NIL},;
			{"D1_HRDOCA" ,"000000"           				,NIL}}
			
			AAdd( aItens, aLinha )
			
		Endif
		
		fMark->(DbSkip())
	
	EndDo
	
	If Len(aItens) > 0 
		aIteAglu := {}
		For nI := 1 To Len(aItens)
			_aLinha := aClone(aItens[nI])
			nPosProd := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_COD'})
			nPosSeri := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_SERIORI'})
			nPosNota := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_NFORI'})
			nPosUnit := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_VUNIT'})
			nPosQtde := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_QUANT'})
			nPosTot  := Ascan(_aLinha,{|x| Alltrim(x[1]) == 'D1_TOTAL'})
			nPos := Ascan(aIteAglu,{|x| x[nPosProd][2] == aItens[nI][nPosProd][2] .AND.;
			x[nPosUnit][2] == aItens[nI][nPosUnit][2] .AND.; 
			x[nPosSeri][2] == aItens[nI][nPosSeri][2] .AND.;
			x[nPosNota][2] == aItens[nI][nPosNota][2]})
			If nPos == 0
				aAdd(aIteAglu,aItens[nI])
			Else
				aIteAglu[nPos][nPosQtde][2] += aItens[nI][nPosQtde][2]
				aIteAglu[nPos][nPosTot][2] := A410Arred(aIteAglu[nPos][nPosUnit][2] * aIteAglu[nPos][nPosQtde][2],"D1_TOTAL")
			EndIf
		Next
				
		If (Len(aCab) > 0) .And. (Len(aIteAglu) > 0)
			lMsErroAuto := .F.
			MsExecAuto({|x,y| MATA103(x,y)},aCab,aIteAglu)
			If lMsErroAuto
				RollBackSX8()
				MostraErro()
				DisarmTransaction()
				//U_retnfant(cNfnant,_cSer)
			Else
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
						
						RecLock("ZZQ",.F.)
						ZZQ->ZZQ_NFENTR  := _cDoc
						ZZQ->ZZQ_SERENT  := _cSer
						ZZQ->ZZQ_DTENTR  := dDataBase
						ZZQ->(MsUnlock())
					Endif
					fMark->(DbSkip())
				EndDo
				
				MsgAlert("Nota Fiscal "+_cDoc+"/"+_cSer+" gerada com sucesso.")	
			Endif
		Endif
	Else
		MsgAlert("Itens nใo selecionados ou NF gerada anteriormente!")	
	Endif
	
Endif

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNfeNextDocบAutor  ณLuciano Siqueira    บ Data ณ  19/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Controla numeracao da nota                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Validacao da NF informada pelo usuario                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SF1->(dbSetOrder(1))
If SF1->(MsSeek(xFilial("SF1") + cNumero + cSerie + cCliNFE80,.F.))
	Help(" ",1,"EXISTNF")
	_lRet    := .F.
	cNumero := ""
EndIf

Return(_lRet)  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณLuciano Siqueira    บ Data ณ  11/06/12   บฑฑ
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

PutSx1(cPerg, '01', 'NF Saida De    ?','' ,'' , 'mv_ch1', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'NF Saida Ate   ?','' ,'' , 'mv_ch2', 'C', 9, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Serie De       ?','' ,'' , 'mv_ch3', 'C', 3, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Serie Ate      ?','' ,'' , 'mv_ch4', 'C', 3, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Produto De     ?','' ,'' , 'mv_ch5', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto Ate    ?','' ,'' , 'mv_ch6', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Cliente        ?','' ,'' , 'mv_ch7', 'C', 06, 0, 0, 'G', '', 'SA1', '', '', 'mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Loja           ?','' ,'' , 'mv_ch8', 'C', 02, 0, 0, 'G', '', '', '', '', 'mv_par08',,,'','','','','','','','','','','','','','')
PutSX1(cPerg, '09', "DT Saida De   	?","","","mv_ch9","D",08,0,0,"G","","" ,"","","mv_par09",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg, '10', "DT Saida Ate   ?","","","mv_cha","D",08,0,0,"G","","" ,"","","mv_par10",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg, '11', "Armazem De     ?","","","mv_chb","C",02,0,0,"G","","" ,"","","mv_par11",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg, '12', "Armazem Ate    ?","","","mv_chc","C",02,0,0,"G","","" ,"","","mv_par12",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")

Return


User Function MarcIt80(nOpc)

Local lMarcIt := .T.

If nOpc == 1 // Marcar todos
	fMark->(DbGotop())
	Do While fMark->(!EOF())
		If Empty(fMark->OBS) 
			RecLock("fMark",.F.)
			fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
			fMark->(MsUnlock())
		Else
			lMarcIt := .F.
		Endif
		fMark->(DbSkip())
	Enddo
	If !lMarcIt
		MsgAlert("Itens que possuem Observa็ใo nใo serใo processados. Favor verificar!")	
	Endif
	dbGoTop()
Elseif nOpc == 2  // Marcar somente o registro posicionado

	If Empty(fMark->OBS)
		RecLock("fMark",.F.)
		fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
		MsUnLock()
	Else
		MsgAlert("Item possui Observa็ใo e nใo serแ processado. Favor verificar!")	
	Endif
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPEXC    บAutor  ณLuciano Siqueira    บ Data ณ  30/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime Log das Inconsistencias encontradas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IMPEXC80()
Local oReport
Private _cQuebra := " "
If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSection

oReport := TReport():New("IMPEXC","Entrada 80%",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir itens referente a entrada 80%")

oSection1 := TRSection():New(oReport,OemToAnsi("Entrada 80%"),{"FMARK"})
TRCell():New(oSection1,"NFS","FMARK","NF Saida","@!",09)
TRCell():New(oSection1,"NFSSER","FMARK","Serie NFS","@!",03)
TRCell():New(oSection1,"PECA","FMARK","Pe็a","@!",15)
TRCell():New(oSection1,"ARMAZ","FMARK","Armazem","@!",02)
TRCell():New(oSection1,"DESCRI","FMARK","Descricao","@!",40)
TRCell():New(oSection1,"QTDE","FMARK","Qtde","@!",10)
TRCell():New(oSection1,"VLRUNI","FMARK","Vlr Unitario","@!",20)
TRCell():New(oSection1,"VLRTOT","FMARK","Vlr Total","@!",20)
TRCell():New(oSection1,"CSSNUM","FMARK","Ticket","@!",30)
TRCell():New(oSection1,"OBS","FMARK","Obs","@!",150)


Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ                   บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Relatorio                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)

// Impressao da Primeira secao
dbSelectArea("FMARK")
dbGoTop()
oReport:SetMeter(RecCount())
oSection1:Init()
While !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	dbSelectArea("FMARK")
	dbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()
Return