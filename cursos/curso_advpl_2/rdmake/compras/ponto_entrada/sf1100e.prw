#include 'rwmake.ch'
#define ENTER chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100E  ºAutor  ³Microsiga           º Data ³  02/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na exclusao da Nota Fiscal de Entrada paraº±±
±±º          ³ excluir os acessorios SONY                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH - SONY                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function sf1100e()
                                 
/* Rotina de verificacao de amarracao de conhecimento de frete para exclusao 01/12/2008 --------------------------*/ 
If  aLLtrIM(CESPECIE) == "CTR"        
	IF FINDFUNCTION("U_DELCONFRE")
		U_DelConFre()
	ENDIF		
Endif                                                                                                       	
Return .T.

/* ---- fim da rotina de conhecimento de frete -------------------------------------------------------------------*/                 
User Function DelConFre()
Local  cQry
Local _cQry 
Local  cQryExec 
Local _cQryExec 

u_GerA0003(ProcName())

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Select("QRY1") > 0
	QRY->(dbCloseArea())
EndIf

cQry 		:= "SELECT F1_XAMFRE XF1 " + ENTER
cQry 		+= "FROM " + RetSqlName("SF1") + " SF1 (nolock) " + ENTER
cQry 		+= "INNER JOIN " + RetSqlName("Z11") + " Z11 (nolock) " + ENTER
cQry 		+= "ON(F1_FORNECE + F1_DOC + F1_SERIE = Z11_CLIENT + Z11_DOC + Z11_SERIES) 
cQry 		+= "WHERE Z11_CTRNFE = '" + SF1->F1_DOC + "' AND Z11_SERIE = '" + SF1->F1_SERIE + "' AND Z11.D_E_L_E_T_ = ''  AND F1_XAMFRE = 'S' " 

cQry := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), "QRY", .F., .T.)

_cQry 		:= "SELECT F2_XAMFRE XF2 " + ENTER
_cQry 		+= "FROM " + RetSqlName("SF2") + " SF2 (nolock) " + ENTER
_cQry 		+= "INNER JOIN " + RetSqlName("Z11") + " Z11 (nolock) " + ENTER
_cQry 		+= "ON(F2_CLIENTE + F2_DOC + F2_SERIE = Z11_CLIENT + Z11_DOC + Z11_SERIES) " + ENTER
_cQry 		+= "WHERE Z11_CTRNFE = '" + SF1->F1_DOC + "' AND Z11_SERIE = '" + SF1->F1_SERIE + "' AND Z11.D_E_L_E_T_ = ''  AND F2_XAMFRE = 'S' "	 


_cQry := ChangeQuery(_cQry)
dbUseArea(.T., "TOPCONN", TcGenQry(,, _cQry), "QRY1", .F., .T.)


If !Empty(QRY->XF1)
	cQryExec 	:= "UPDATE " + RetSqlName("SF1") + ENTER                                                            
	cQryExec 	+= "SET F1_XAMFRE = '' " + ENTER
	cQryExec 	+= "WHERE EXISTS (SELECT  Z11_CLIENT + Z11_DOC +Z11_SERIES FROM " + RetSqlName("Z11") + ENTER
	cQryExec 	+= "WHERE Z11_CTRNFE = '" + SF1->F1_DOC + "' " + ENTER
	cQryExec 	+= "AND Z11_SERIE = '" + SF1->F1_SERIE + "' " + ENTER
	cQryExec 	+= "AND D_E_L_E_T_ = '' " + ENTER
	cQryExec 	+= "AND F1_FORNECE = Z11_CLIENT " + ENTER
	cQryExec 	+= "AND F1_DOC = Z11_DOC " + ENTER
	cQryExec 	+= "AND F1_SERIE = Z11_SERIES) " + ENTER 
	cQryExec 	+= "AND F1_XAMFRE = 'S' " + ENTER 

	TcSQlExec(cQryExec)           
	TCRefresh(RETSQLNAME("SF1"))

EndIf

If !Empty(QRY1->XF2)
 
	_cQryExec 	:= "UPDATE " + RetSqlName("SF2") + ENTER                                                            
	_cQryExec 	+= "SET F2_XAMFRE = '' " + ENTER
	_cQryExec 	+= "WHERE EXISTS (SELECT  Z11_CLIENT + Z11_DOC +Z11_SERIES FROM " + RetSqlName("Z11") + ENTER
	_cQryExec 	+= "WHERE Z11_CTRNFE = '" + SF1->F1_DOC + "' " + ENTER 
	_cQryExec 	+= "AND Z11_SERIE = '" + SF1->F1_SERIE + "' " + ENTER
	_cQryExec 	+= "AND D_E_L_E_T_ = '' " + ENTER
	_cQryExec 	+= "AND F2_CLIENTE = Z11_CLIENT " + ENTER
	_cQryExec 	+= "AND F2_DOC = Z11_DOC " + ENTER
	_cQryExec 	+= "AND F2_SERIE = Z11_SERIES)  AND F2_XAMFRE = 'S'  " + ENTER 

	TcSQlExec(_cQryExec)           
	TCRefresh(RETSQLNAME("SF2"))
	
EndIf

_cQryExec 	:= "UPDATE "+ RetSqlName("Z11") + ENTER 
_cQryExec 	+= "SET D_E_L_E_T_ = '*' " + ENTER
_cQryExec 	+= "WHERE Z11_CTRNFE = '" + SF1->F1_DOC   + "' " + ENTER
_cQryExec 	+= "AND   Z11_SERIE = '"  + SF1->F1_SERIE + "' " + ENTER
_cQryExec 	+= "AND D_E_L_E_T_ = ''" + ENTER
                                                                                             
TcSqlExec(_cQryExec)
TCRefresh(RETSQLNAME("Z11"))
 
QRY->(dbCloseArea())
QRY1->(dbCloseArea())  

Return .t.	
return()