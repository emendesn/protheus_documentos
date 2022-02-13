#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH' 
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OBJCORREIO()

Local aArea   := GetArea()
Local cObj	  := ""
Local cQuery  := ""
Local nParAux := 0
Local nParCont:= 0
Local Path    := "172.16.0.7"
Local cGrpMail:= ""
Local _cAlias := ""

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "02" TABLES "ZB2"

_cAlias := GetNextAlias()
nParCont:= SuperGetMV("BH_CNTPOST",  ,500)
cGrpMail:= SuperGetMV("BH_MAILGPP",  ,"")

nParAux := SuperGetMV("BH_AUXDMPL",  ,8300)

cQuery := " SELECT COUNT(ZB2_OBJETO) AS QTD FROM " + RetSqlName("ZB2") + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND ZB2_FILIAL = '" + xFilial("ZB2") + "' " + CRLF 
cQuery += " AND SUBSTRING(ZB2_OBJETO,1,2) = 'DM' " + CRLF
cQuery += " AND ZB2_USADO <> 'S' " + CRLF

cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If ( ( _cAlias )->( !Eof() ) )	
	If (nParAux - ( _cAlias )->(QTD)) == nParCont
		cTitemail := "N๚mero de etiquetas restantes para e-Sedex."
		cMensagem := "TIPO POSTAL : DM - ETIQUETA E-SEDEX." + CRLF
		cMensagem += "QUANTIDADE DE ETIQUETAS : " + cValToChar(( _cAlias )->(QTD)) +  CRLF
		U_ENVIAEMAIL(cTitemail,cGrpMail,"",cMensagem,Path)
		AtuParam(( _cAlias )->(QTD),"DM")		
	EndIf           
EndIf 
                        
nParAux := SuperGetMV("BH_AUXDNPL",  ,8300)

cQuery := " SELECT COUNT(ZB2_OBJETO) AS QTD FROM " + RetSqlName("ZB2") + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND ZB2_FILIAL = '" + xFilial("ZB2") + "' " + CRLF 
cQuery += " AND SUBSTRING(ZB2_OBJETO,1,2) = 'DN' " + CRLF
cQuery += " AND ZB2_USADO <> 'S' " + CRLF

cQuery := ChangeQuery(cQuery) 
If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )
If ( ( _cAlias )->( !Eof() ) )	
	If (nParAux - ( _cAlias )->(QTD)) == nParCont
		cTitemail := "N๚mero de etiquetas restantes para Sedex."
		cMensagem := "TIPO POSTAL : DN - ETIQUETA SEDEX." + CRLF
		cMensagem += "QUANTIDADE DE ETIQUETAS : " + cValToChar(( _cAlias )->(QTD)) +  CRLF
		U_ENVIAEMAIL(cTitemail,cGrpMail,"",cMensagem,Path)
		AtuParam(( _cAlias )->(QTD),"DN")		
	EndIf           
EndIf

RestArea(aArea)

RESET ENVIRONMENT

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณVinicius Leonardo  บ Data ณ  19/02/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  													  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuParam(nQtd,cSigla)

Local aArea := GetArea()  

If cSigla == "DM"
	cPar := "BH_AUXDMPL" 
ElseIf cSigla == "DN"
	cPar := "BH_AUXDNPL"
EndIf   

//Atualiza Parametro auxiliar de contagem de objetos vแlidos
If Select("SX6") == 0
	DbSelectArea("SX6")
EndIf
SX6->(DbSetOrder(1))
If SX6->(DbSeek(xFilial("SX6")+cPar)) 
	If RecLock("SX6",.F.)
		SX6->X6_CONTEUD:= cValToChar(nQtd)
		SX6->(MsUnlock())
	EndIf
EndIf 
RestArea(aArea)
Return