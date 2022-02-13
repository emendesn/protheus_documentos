#include 'rwmake.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATA002  บAutor  ณ M.Munhoz - ERPPLUS บ Data ณ  10/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para gerar Pedido de Venda de retorno do poder de บฑฑ
ฑฑบ          ณ terceiros do saldo em aberto                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function FATA002()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Geracao de Pedido de Vendas de Retorno de Terceiros"
Local cDesc1  := "Este programa executa a geracao de Pedidos de Venda de retorno para o "
Local cDesc2  := "saldo de terceiros em aberto. "
Local cDesc3  := "Estใo sendo considerados apenas Produtos filtrados pelo usuario "
Local cDesc4  := "e alimentados na tabela ARMAZ02."

Private cPerg := "FATA02"

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
else
	GeraPV()
Endif

//Processa({|lEnd| RunProc(@lEnd)}, "Aguarde...","Lendo Saldo de Terceiros", .T. )
//Processa({|lEnd| Execute(RunProc(@lEnd) )}, "Aguarde...","Lendo Saldo de Terceiros", .t.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERAPV   บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  10/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que le o saldo de Terceiros e gera Pedidos de Venda บฑฑ
ฑฑบ          ณ de Devolucao.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraPV()

Local bAcao   := {|lFim| RunProc(@lFim) }
Local cTitulo := ''
Local cMsg    := 'Gerando PV de Retorno para Terceiros...'
Local lAborta := .T.

Processa( bAcao, cTitulo, cMsg, lAborta )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  10/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que le o saldo de Terceiros e gera Pedidos de Venda บฑฑ
ฑฑบ          ณ de Devolucao.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lFim)

local _cQuery  := " "
local _nItemPV := 0
local _cItemPV := "01"
local _aCabPV  := {}
local _aItePV  := {}
local _lFirst  := .t.
local _aAreaSD1:= SD1->(GetArea())
local _aAreaSF1:= SF1->(GetArea())
local _aAreaSB1:= SB1->(GetArea())
local _aAreaSA1:= SA1->(GetArea())
local _aAreaSB6:= SB6->(GetArea())
local CR       := chr(13) + chr(10)
local _cimei   :=""
local _clocal  :=""
local _cprod    :=""
local _cnfe     :=""
local _ccli     :=""
local _cloj     :=""
local _cNumOsTk :=""

SB1->(DBSetOrder(1)) //B1_FILIAL+B1_COD

private lMsErroAuto := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Cliente                             ณ
//ณ mv_par02 - Loja                                ณ
//ณ mv_par03 - Almoxarifado                        ณ
//ณ mv_par04 - Dt Emissao Inicial                  ณ
//ณ mv_par05 - Dt Emissao Final                    ณ
//ณ mv_par06 - Produto Inicial                     ณ
//ณ mv_par07 - Produto Final                       ณ
//ณ mv_par08 - TES para o Pedido de Venda          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if select("TRA") > 0
	TRA->(dbCloseArea())
endif
if select("TRB") > 0
	TRB->(dbCloseArea())
endif                                      

if EMPTY(mv_par03)
   MsgBox("Favor digitar o almoxarifado.","Almoxarifado","ALERT")
   return
endif             

if EMPTY(mv_par08)
   MsgBox("Favor digitar a TES .","Tipo Entrada/Saida","ALERT")
   return
endif

_cSele2 :=      " SELECT COUNT(*) 'QTREG' "
_cSele1 := CR + " SELECT B6.* , D1_ITEM, D1_IDENTB6, D1_NUMSER, D1RECNO = D1.R_E_C_N_O_, F1RECNO = F1.R_E_C_N_O_, B6RECNO = B6.R_E_C_N_O_ "
_cQuery += CR + " FROM   "+RetSqlName("SB6")+" AS B6 (nolock)  "
_cQuery += CR + " JOIN   "+RetSqlName("SD1")+" AS D1 (nolock) "
_cQuery += CR + " ON     B6_FILIAL = D1_FILIAL AND B6_DOC = D1_DOC AND B6_SERIE = D1_SERIE AND B6_DTDIGIT = D1_DTDIGIT AND B6_IDENT = D1_IDENTB6 AND D1.D_E_L_E_T_ = '' "
_cQuery += CR + " JOIN   "+RetSqlName("SF1")+" AS F1 (nolock) "
_cQuery += CR + " ON     B6_FILIAL = F1_FILIAL AND B6_DOC = F1_DOC AND B6_SERIE = F1_SERIE AND B6_DTDIGIT = F1_DTDIGIT AND B6_CLIFOR = F1_FORNECE AND B6_LOJA = F1_LOJA AND F1.D_E_L_E_T_ = '' "
_cQuery += CR + " WHERE  B6.D_E_L_E_T_ = '' "
_cQuery += CR + "        AND B6_FILIAL = '"+xFilial("SB6")+"' "
_cQuery += CR + "        AND B6_TIPO   = 'D' "
_cQuery += CR + "        AND B6_PODER3 = 'R' "
_cQuery += CR + "        AND B6_SALDO  > 0 "     
                         if !EMPTY(mv_par01)
_cQuery += CR + "           AND B6_CLIFOR = '"+mv_par01+"' "
_cQuery += CR + "           AND B6_LOJA   = '"+mv_par02+"' "
                         Endif
_cQuery += CR + "        AND B6_LOCAL  = '"+mv_par03+"' "
_cQuery += CR + "        AND B6_PRODUTO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cQuery += CR + "        AND D1_DTDIGIT BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"' "
_cOrder := CR + " ORDER BY B6_PRODUTO, B6_PRUNIT "

//memowrite("fata002.sql",_cSele1 + _cQuery + _cOrder)
_cSele1 := strtran(_cSele1,CR,"")
_cQuery := strtran(_cQuery,CR,"")
_cOrder := strtran(_cOrder,CR,"")

TCQUERY _cSele2 + _cQuery NEW ALIAS "TRA"

TRA->(dbGoTop())
Procregua(TRA->QTREG)
TRA->(dbCloseArea())

TCQUERY _cSele1 + _cQuery + _cOrder NEW ALIAS "TRB"

TRB->(dbGoTop())
while !TRB->(eof())                    
  	SB1->(DBSeek(xFilial('SB1')+ alltrim(TRB->B6_PRODUTO)))
	SA1->(DBSeek(xFilial('SA1')+ ALLTRIM(TRB->B6_CLIFOR)+ALLTRIM(TRB->B6_LOJA)))
	
	_cimei  :=TRB->D1_NUMSER
    _clocal :=TRB->B6_LOCAL
    _cprod  :=TRB->B6_PRODUTO
    _cnfe   :=TRB->B6_DOC
    _ccli   :=TRB->B6_CLIFOR
    _cloj   :=TRB->B6_LOJA            
    
   if Select("QryPROD") > 0
     QryPROD->(dbCloseArea())
   endif
    
  _cQuery := " SELECT  * FROM   [DBMP8].dbo.ARMAZ02 (nolock) "
  _cQuery += " WHERE ARMAZEM='"+ _clocal+"'   AND PRODUTO='"+_cprod+"' "
  _cQuery += " AND NFE='"+_cnfe+"' AND CLIENTE='"+_ccli+"'  AND LOJA='"+_cloj+"' "
    
  TCQUERY _cQuery ALIAS "QryPROD" NEW
    
 if Select("QryPROD") <= 0
   QryPROD->(dbCloseArea())
   exit                           
 else
   _cNumOsTk:=QryPROD->OS+"01"
 endif
    
 dbselectarea("TRB")

	if lFim
		exit
	endif
	
	IncProc()

	If _lFirst

		_cNumPed	:= GetSXENum( "SC5", "C5_NUM" )
		_aCabPV	    := {{"C5_TIPO"		,"N"						,Nil},;
					{"C5_CLIENTE"	,TRB->B6_CLIFOR  	        ,Nil},;
					{"C5_LOJACLI"	,TRB->B6_LOJA    		    ,Nil},;
					{"C5_LOJAENT"	,TRB->B6_LOJA	        	,Nil},;
					{"C5_TIPOCLI"	,"F"						,Nil},;
					{"C5_CONDPAG"	,'001'	   					,Nil},;
					{"C5_TIPLIB"	,'1'	   					,Nil},;
					{"C5_TPCARGA"	,'2'	   					,Nil},;
					{"C5_B_KIT"		,''      					,Nil},;
					{"C5_XUSER"		,alltrim(cusername)			,Nil},;
					{"C5_TRANSP"	,iif(SB1->B1_LOCPAD $ "22/26/27",SA1->A1_TRANSP  ,"03"),Nil},;// Alterado por Edson Rodrigues - 13/12/2007 - 
					{"C5_MENPAD"	,iif(SB1->B1_LOCPAD $ "22/26/27",SA1->A1_MENSAGE ,"")	,Nil},;
					{"C5_DIVNEG"	,iif(SB1->B1_LOCPAD $ "22/26/27","03",iif(SB1->B1_LOCPAD $ "10","04","09")),Nil} }// Alterado por Edson Rodrigues - 26/12/2007


                    
	
		_aItePV		:= {}
		_lFirst		:= .F.
		_nItemPV	:= 0
		_cItemPV    := "01"
		_cProduto	:= alltrim(TRB->B6_PRODUTO)
		_nValor		:= TRB->B6_PRUNIT
		_nValtot	:= TRB->B6_PRUNIT*TRB->B6_SALDO

	EndIf

	_nItemPV += 01

			   
	aReg:={}
	aAdd(aReg, {"C6_ITEM"   ,_cItemPV				,Nil})
	aAdd(aReg, {"C6_PRODUTO",TRB->B6_PRODUTO		,Nil})              
	aAdd(aReg, {"C6_TES"    ,iif(!empty(mv_par08),mv_par08,"999"),Nil})
	aAdd(aReg, {"C6_LOCAL"  ,TRB->B6_LOCAL			,Nil})
	aAdd(aReg, {"C6_NFORI"  ,TRB->B6_DOC			,Nil})
	aAdd(aReg, {"C6_SERIORI",TRB->B6_SERIE			,Nil})
	aAdd(aReg, {"C6_ITEMORI",TRB->D1_ITEM			,Nil})
	aAdd(aReg, {"C6_QTDVEN" ,TRB->B6_SALDO			,Nil})
	aAdd(aReg, {"C6_PRCVEN" ,TRB->B6_PRUNIT			,Nil})
	aAdd(aReg, {"C6_PRUNIT" ,TRB->B6_PRUNIT			,Nil})
	aAdd(aReg, {"C6_IDENTB6",TRB->B6_IDENT			,Nil})
	aAdd(aReg, {"C6_DESCRI" ,SB1->B1_DESC          ,Nil})
	aAdd(aReg, {"C6_NUMSERI",TRB->D1_NUMSER			,Nil})
	aAdd(aReg, {"C6_NUMOS"	,_cNumOsTk				,Nil})    


	aAdd( _aItePV, aReg)
	_cItemPV := Soma1(_cItemPV)

	TRB->(dbSkip())

	if TRB->(eof()) .or. _nItemPV >= 700 .or. alltrim(TRB->B6_PRODUTO) <> alltrim(_cProduto) .or. TRB->B6_PRUNIT <> _nValor

		lMsErroAuto := .F.

		MSExecAuto( {|x, y, z| MATA410( x, y, z ) }, _aCabPV, _aItePV, 03 )
	
		If lMsErroAuto
			MostraErro()
			RollbackSX8()
		EndIf

		_aCabPV   := {}
		_aItePV   := {}
		_lFirst   := .t.
		if TRB->(!eof())
			_cProduto := alltrim(TRB->B6_PRODUTO)
			_nValor   := TRB->B6_PRUNIT
			_cItemPV  := "01"
			_nItemPV  := 0
		endif

	endif

enddo

TRB->(dbCloseArea())
RestArea(_aAreaSD1)
RestArea(_aAreaSF1)
RestArea(_aAreaSB6)
RestArea(_aAreaSB1)
RestArea(_aAreaSA1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERPPLUS  บ Data ณ  10/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para criacao automatica das perguntas (SX1)         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Cod. Cliente"			,"Cod. Cliente"				,"Cod. Cliente"				,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja"					,"Loja"						,"Loja"						,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Almoxarifado"			,"Almoxarifado"				,"Almoxarifado"				,"mv_ch3","C",02,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Emissao Inicial"			,"Emissao Inicial"			,"Emissao Inicial"			,"mv_ch4","D",08,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Emissao Final"			,"Emissao Final"			,"Emissao Final"			,"mv_ch5","D",08,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Produto Inicial"			,"Produto Inicial"			,"Produto Inicial"			,"mv_ch6","C",15,0,0,"G","","SB1"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Produto Final"			,"Produto Final"			,"Produto Final"			,"mv_ch7","C",15,0,0,"G","","SB1"	,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","TES para p PV"			,"TES para p PV"			,"TES para p PV"			,"mv_ch8","C",03,0,0,"G","","SF4"	,"",,"mv_par08","","","","","","","","","","","","","","","","")

Return Nil