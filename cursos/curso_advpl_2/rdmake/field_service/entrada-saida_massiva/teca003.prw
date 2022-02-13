#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TECA003  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  15/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para comparar os dados da planilha Excel com a    บฑฑ
ฑฑบ          ณ entrada massiva realizada pelos usuarios.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function TECA003()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Comparativo Excel x Entrada Massiva"
Local cDesc1  := "Este programa compara os dados importados atrav้s da planilha Excel "
Local cDesc2  := "com os dados gerados pela Entrada Massiva. Caso existam diverg๊ncias, o "
Local cDesc3  := "programa irแ gerar um relat๓rio com as inconsist๊ncias identificadas."

Private cPerg := "TECA03"
u_GerA0003(ProcName())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Cliente                             ณ
//ณmv_par02 - Loja                                ณ
//ณmv_par03 - Nota Fiscal                         ณ
//ณmv_par04 - Serie                               |
//|mv_par05 - Cod Produto                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Comparando Excel x Entrada Massiva", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a importacao da planilha Excel do       บฑฑ
ฑฑบ          ณ cliente para a tabela SZA.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _cQuery1A := _cQuery1B := _cQuery2  := _cQuery3  := _cQuery4  := _cQuery5  := _cQuery6  := ""
local _aAreaSZA := SZA->(GetArea())
local CR        := chr(13) + chr(10)

private _aErros := {} 

// 0 - Verifica se existe Importacao do Excel da NF informada
//dbSelectArea("SZA")
//SZA->(dbSetOrder(1))
//if SZA->(dbSeek())
//endif

// 1 - Verificacao da quantidade de registros em cada tabela (ZZ4 x SZA)
_cQuery1A += CR + " SELECT COUNT(*) 'ZZ4REG' "
_cQuery1A += CR + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery1A += CR + " WHERE  ZZ4.D_E_L_E_T_  = '' "
_cQuery1A += CR + "        AND ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' "
_cQuery1A += CR + "        AND ZZ4_CODCLI  = '"+mv_par01+"' "
_cQuery1A += CR + "        AND ZZ4_LOJA    = '"+mv_par02+"' "
_cQuery1A += CR + "        AND ZZ4_NFENR   = '"+mv_par03+"' "
_cQuery1A += CR + "        AND ZZ4_NFESER   = '"+mv_par04+"' "

//memowrite("TECA0031A.SQL",_cQuery1A )

_cQuery1A := strtran(_cQuery1A, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1A),"TRB1A",.T.,.T.)

dbselectarea("TRB1A")
TRB1A->(dbgotop())

_nRegZZ4 := TRB1A->ZZ4REG
TRB1A->(dbCloseArea())

_cQuery1B += CR + " SELECT COUNT(*) 'ZAREG' "
_cQuery1B += CR + " FROM   "+RetSqlName("SZA")+" AS ZA (nolock) "
_cQuery1B += CR + " WHERE  ZA.D_E_L_E_T_  = '' "
_cQuery1B += CR + "        AND ZA_FILIAL  = '"+xFilial("SZA")+"' "
_cQuery1B += CR + "        AND ZA_CLIENTE = '"+mv_par01+"' "
_cQuery1B += CR + "        AND ZA_LOJA    = '"+mv_par02+"' "
_cQuery1B += CR + "        AND ZA_NFISCAL = '"+mv_par03+"' "
_cQuery1B += CR + "        AND ZA_SERIE   = '"+mv_par04+"' "

//memowrite("TECA0031B.SQL",_cQuery1B )

_cQuery1B := strtran(_cQuery1B, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1B),"TRB1B",.T.,.T.)

dbselectarea("TRB1B")
TRB1B->(dbgotop())

_nRegSZA := TRB1B->ZAREG
TRB1B->(dbCloseArea())

if _nRegZZ4 <> _nRegSZA
	aAdd(_aErros, {1,"Quant. de reg. divergente: ZZ4 (Entr.Mass.) - " + alltrim(str(_nRegZZ4)) + " / SZA (Excel) - " + alltrim(str(_nRegSZA)) })
endif

// 2 - Verificacao de duplicados na tabela ZZ4
_cQuery2 += CR + " SELECT ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFENR, ZZ4_NFESER, ZZ4_IMEI, COUNT(*) "
_cQuery2 += CR + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery2 += CR + " WHERE  ZZ4.D_E_L_E_T_  = '' "
_cQuery2 += CR + "        AND ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' "
_cQuery2 += CR + "        AND ZZ4_CODCLI  = '"+mv_par01+"' "
_cQuery2 += CR + "        AND ZZ4_LOJA    = '"+mv_par02+"' "
_cQuery2 += CR + "        AND ZZ4_NFENR   = '"+mv_par03+"' "
_cQuery2 += CR + "        AND ZZ4_NFESER  = '"+mv_par04+"' "
//_cQuery2 += CR + "        AND ZZ4_TIPO    = 'E' "
_cQuery2 += CR + " GROUP BY ZZ4_CODCLI, ZZ4_LOJA, ZZ4_NFENR, ZZ4_NFESER, ZZ4_IMEI "
_cQuery2 += CR + " HAVING COUNT(*) > 1 "

//memowrite("TECA0032.SQL",_cQuery2 )

_cQuery2 := strtran(_cQuery2, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"TRB2",.T.,.T.)

dbselectarea("TRB2")
TRB2->(dbgotop())
while TRB2->(!eof())
	aAdd(_aErros, {2,"ZZ4 (Entr.Mass.) - IMEI duplicado: " + alltrim(TRB2->ZZ4_IMEI) })
	TRB2->(dbSkip())
enddo
TRB2->(dbCloseArea())

// 3 - Verificacao de duplicados na tabela SZA
_cQuery3 += CR + " SELECT ZA_CLIENTE, ZA_LOJA, ZA_NFISCAL, ZA_SERIE, ZA_IMEI, COUNT(*) "
_cQuery3 += CR + " FROM   "+RetSqlName("SZA")+" AS ZA (nolock) "
_cQuery3 += CR + " WHERE  ZA.D_E_L_E_T_  = '' "
_cQuery3 += CR + "        AND ZA_FILIAL  = '"+xFilial("SZA")+"' "
_cQuery3 += CR + "        AND ZA_CLIENTE = '"+mv_par01+"' "
_cQuery3 += CR + "        AND ZA_LOJA    = '"+mv_par02+"' "
_cQuery3 += CR + "        AND ZA_NFISCAL = '"+mv_par03+"' "
_cQuery3 += CR + "        AND ZA_SERIE   = '"+mv_par04+"' "
_cQuery3 += CR + " GROUP BY ZA_CLIENTE, ZA_LOJA, ZA_NFISCAL, ZA_SERIE, ZA_IMEI "
_cQuery3 += CR + " HAVING COUNT(*) > 1 "

//memowrite("TECA0033.SQL",_cQuery3 )

_cQuery3 := strtran(_cQuery3, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),"TRB3",.T.,.T.)

dbselectarea("TRB3")
TRB3->(dbgotop())
while TRB3->(!eof())
	aAdd(_aErros, {3,"SZA (Excel) - IMEI duplicado: " + alltrim(TRB3->ZA_IMEI) })
	TRB3->(dbSkip())
enddo
TRB3->(dbCloseArea())

// 4 - Verificar IMEI's ausentes na tabela ZZ4 (Entrada Massiva)
_cQuery4 += CR + " SELECT * "
_cQuery4 += CR + " FROM   "+RetSqlName("SZA")+" AS ZA (nolock) "
_cQuery4 += CR + " LEFT OUTER JOIN   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery4 += CR + " ON     ZZ4_FILIAL = ZA_FILIAL AND ZZ4_NFENR = ZA_NFISCAL AND ZZ4_NFESER = ZA_SERIE AND ZZ4_CODCLI = ZA_CLIENTE "
//_cQuery4 += CR + "        AND ZZ4_LOJA = ZA_LOJA AND ZZ4_IMEI = ZA_IMEI AND ZZ4_TIPO = 'E' AND ZZ4.D_E_L_E_T_ = '' "
_cQuery4 += CR + "        AND ZZ4_LOJA = ZA_LOJA AND ZZ4_IMEI = ZA_IMEI AND ZZ4.D_E_L_E_T_ = '' "
_cQuery4 += CR + " WHERE  ZA.D_E_L_E_T_ = '' "
_cQuery4 += CR + "        AND ZA_FILIAL  = '"+xFilial("SZA")+"' "
_cQuery4 += CR + "        AND ZA_CLIENTE = '"+mv_par01+"' "
_cQuery4 += CR + "        AND ZA_LOJA    = '"+mv_par02+"' "
_cQuery4 += CR + "        AND ZA_NFISCAL = '"+mv_par03+"' "
_cQuery4 += CR + "        AND ZA_SERIE   = '"+mv_par04+"' "
_cQuery4 += CR + "        AND ZZ4_IMEI IS NULL "

//memowrite("TECA0034.SQL",_cQuery4 )

_cQuery4 := strtran(_cQuery4, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),"TRB4",.T.,.T.)

dbselectarea("TRB4")
TRB4->(dbgotop())
while TRB4->(!eof())
	aAdd(_aErros, {4,"Nใo existe entrada massiva para o IMEI " + alltrim(TRB4->ZA_IMEI) + " que estแ informado no Excel." })
	TRB4->(dbSkip())
enddo
TRB4->(dbCloseArea())

// 5 - Verificar IMEI's ausentes na tabela SZA (Planilha Excel)
_cQuery5 += CR + " SELECT *  "
_cQuery5 += CR + " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery5 += CR + " LEFT OUTER JOIN   "+RetSqlName("SZA")+" AS ZA (nolock) "
_cQuery5 += CR + " ON     ZZ4_FILIAL = ZA_FILIAL AND ZZ4_NFENR = ZA_NFISCAL AND ZZ4_NFESER = ZA_SERIE AND ZZ4_CODCLI = ZA_CLIENTE AND ZZ4_LOJA = ZA_LOJA AND ZZ4_IMEI = ZA_IMEI AND ZA.D_E_L_E_T_ = '' "
_cQuery5 += CR + " WHERE  ZZ4.D_E_L_E_T_ = '' "
_cQuery5 += CR + "        AND ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' "
_cQuery5 += CR + "        AND ZZ4_CODCLI  = '"+mv_par01+"' "
_cQuery5 += CR + "        AND ZZ4_LOJA    = '"+mv_par02+"' "
_cQuery5 += CR + "        AND ZZ4_NFENR   = '"+mv_par03+"' "
_cQuery5 += CR + "        AND ZZ4_NFESER  = '"+mv_par04+"' "
//_cQuery5 += CR + "        AND ZZ4_TIPO    = 'E' "
_cQuery5 += CR + "        AND ZA_IMEI IS NULL "

//memowrite("TECA0035.SQL",_cQuery5 )

_cQuery5 := strtran(_cQuery5, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery5),"TRB5",.T.,.T.)

dbselectarea("TRB5")
TRB5->(dbgotop())
while TRB5->(!eof())
	aAdd(_aErros, {5,"Nใo existe registro no Excel para o IMEI " + alltrim(TRB5->ZZ4_IMEI) + " que estแ informado na Entrada Massiva."})
	TRB5->(dbSkip())
enddo
TRB5->(dbCloseArea())

// 6 - Comparar Produto e 7 - Preco nos IMEI's relacionados (INNER JOIN)
//  e 8 - compara Operacao BGH - edson Rodrigues  
_cQuery6 += CR + " SELECT ZA.*, ZZ4.* "
_cQuery6 += CR + " FROM   "+RetSqlName("SZA")+" AS ZA (nolock) "
_cQuery6 += CR + " LEFT OUTER JOIN   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery6 += CR + " ON     ZZ4_FILIAL = ZA_FILIAL AND ZZ4_NFENR = ZA_NFISCAL AND ZZ4_NFESER = ZA_SERIE AND ZZ4_CODCLI = ZA_CLIENTE "
//_cQuery6 += CR + "        AND ZZ4_LOJA = ZA_LOJA AND ZZ4_IMEI = ZA_IMEI AND ZZ4_TIPO = 'E' AND ZZ4.D_E_L_E_T_ = '' "
_cQuery6 += CR + "        AND ZZ4_LOJA = ZA_LOJA AND ZZ4_IMEI = ZA_IMEI AND ZZ4.D_E_L_E_T_ = '' "
_cQuery6 += CR + " WHERE  ZA.D_E_L_E_T_ = '' "
_cQuery6 += CR + "        AND ZA_FILIAL  = '"+xFilial("SZA")+"' "
_cQuery6 += CR + "        AND ZA_CLIENTE = '"+mv_par01+"' "
_cQuery6 += CR + "        AND ZA_LOJA    = '"+mv_par02+"' "
_cQuery6 += CR + "        AND ZA_NFISCAL = '"+mv_par03+"' "
_cQuery6 += CR + "        AND ZA_SERIE   = '"+mv_par04+"' "
IF !empty(mv_par05)
	_cQuery6 += CR + "        AND ZA_CODPRO   = '"+mv_par05+"' " //Edson Rodrigues 22/11/07
	_cQuery6 += CR + "        AND ZZ4_CODPRO  = '"+mv_par05+"' " //Edson Rodrigues 22/11/07
Endif
_cQuery6 += CR + "        AND (ZA_CODPRO <> ZZ4_CODPRO OR ZA_PRECO <> ZZ4_VLRUNI) "

//memowrite("TECA0036.SQL",_cQuery6 )

_cQuery6 := strtran(_cQuery6, CR, "")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery6),"TRB6",.T.,.T.)

dbselectarea("TRB6")
TRB6->(dbgotop())
while TRB6->(!eof())
	if TRB6->ZZ4_CODPRO <> TRB6->ZA_CODPRO
		aAdd(_aErros, {6,"Codigo de Produto diferente: " + alltrim(TRB6->ZA_IMEI) })
	endif
	if TRB6->ZZ4_VLRUNI <> TRB6->ZA_PRECO
		aAdd(_aErros, {7,"Preco Unitario diferente: " + alltrim(TRB6->ZA_IMEI) })
	endif
	if TRB6->ZZ4_OPEBGH <> TRB6->ZA_OPERBGH
		aAdd(_aErros, {8,"Operacao BGH diferente: " + alltrim(TRB6->ZA_IMEI) })
	endif
	TRB6->(dbSkip())
enddo
TRB6->(dbCloseArea())

if len(_aErros) > 0
	_cStatus := "I"
	ApMsgInfo("Foram localizadas inconsist๊ncias na Entrada Massiva e ela nใo poderแ ser efetivada.","Entrada Massiva com Inconsist๊ncias")
else
	//ativa status 
	_cStatus := "V"
	ApMsgInfo("Nenhuma inconsist๊ncia foi localizada e a entrada massiva estแ disponํvel para efetiva็ใo. ","Entrada Massiva OK")
	
endif

_cUpdate := ""
_cUpdate += CR + " UPDATE "+RetSqlName("SZA")+" SET ZA_STATUS = '"+_cStatus+"' "
_cUpdate += CR + " WHERE D_E_L_E_T_ = '' "
_cUpdate += CR + "       AND ZA_FILIAL  = '"+xFilial("SZA")+"' "
_cUpdate += CR + "       AND ZA_CLIENTE = '"+mv_par01+"' "
_cUpdate += CR + "       AND ZA_LOJA    = '"+mv_par02+"' "
_cUpdate += CR + "       AND ZA_NFISCAL = '"+mv_par03+"' "
_cUpdate += CR + "       AND ZA_SERIE   = '"+mv_par04+"' "

//memowrite("TECA003upd.sql",_cUpdate )
_cUpdate := strtran(_cUpdate, CR, "")
TcSqlExec(_cUpdate)
TCRefresh(RetSqlName("SZA"))

//Edson Rodrigues - 15/10/08 - Atualiza lote do ZZ4
SZA->(dbSetOrder(1))
If SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par03 + mv_par04))
   IF   !EMPTY(SZA->ZA_LOTEIRL)
        _clote  :=SZA->ZA_LOTEIRL                      
        _cdpyim :=IIF(SUBSTR(SZA->ZA_CODDPY,1,3)="DPY",SZA->ZA_CODDPY,"")      
        _cgvsos :=SZA->ZA_OSGVS
        
        _cUpdate := ""
        _cUpdate += CR + " UPDATE "+RetSqlName("ZZ4")+" SET ZZ4_LOTIRL = '"+_clote+"',ZZ4_DPYIME = '"+_cdpyim+"',ZZ4_GVSOS='"+_cgvsos+"' "
        _cUpdate += CR + " WHERE D_E_L_E_T_ = '' "
        _cUpdate += CR + "       AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
        _cUpdate += CR + "       AND ZZ4_CODCLI = '"+mv_par01+"' "
        _cUpdate += CR + "       AND ZZ4_LOJA   = '"+mv_par02+"' "
        _cUpdate += CR + "       AND ZZ4_NFENR  = '"+mv_par03+"' "
        _cUpdate += CR + "       AND ZZ4_NFESER = '"+mv_par04+"' " 
        
//        memowrite("TECA003updZZ4.sql",_cUpdate )
        _cUpdate := strtran(_cUpdate, CR, "")
        TcSqlExec(_cUpdate) 
        TCRefresh(RetSqlName("ZZ4"))
        
        
   ENDIF                                
Endif




// Gera relatorio com as inconsistencias
if len(_aErros) > 0
	u_tecr003(_aErros)
endif

RestArea(_aAreaSZA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณM.Munhoz - ERP PLUS บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Cliente ?"       	,"Cliente ?"       		,"Cliente ?"       		,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja ?"				,"Loja ?"				,"Loja ?"				,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Nr. Nota Fiscal ? "	,"Nr. Nota Fiscal ? "	,"Nr. Nota Fiscal ? "	,"mv_ch3","C",09,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie NF ?"			,"Serie NF ?"			,"Serie NF ?"			,"mv_ch4","C",03,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Cod Produto?"		,"Cod Produto ?"		,"Cod Produto ?"		,"mv_ch5","C",15,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","")  //Edson Rodrigues - 22/11/07

Return Nil
