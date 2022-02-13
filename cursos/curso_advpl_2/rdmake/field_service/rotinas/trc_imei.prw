#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#define ENTER CHR(10)+CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TRC_IMEI บ Autor ณPaulo Lopez         บ Data ณ  25/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณALTERACAO DE IMEI E CARCACA.                                บฑฑ
ฑฑบ          ณFAZENDO RECALCULO DA GARANTIA PELA CARCACA                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATURAMENTO                                                บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ16/08/11  บM.Munhoz          บEliminacao do SD1 deste programa pq o    บฑฑ
ฑฑบ          บ                  บmesmo nao ira mais gravar o D1_NUMSER.   บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TRC_IMEI1()


Local _cQry
Local _cQryc
Local _cQryExec
Local _periodo
Local _cgaran
Local lUsrAut  := .F.  
Local _aAreaZZ4  := ZZ4->(GetArea())
Local _aAreaSZA  := SZA->(GetArea())
Local _aAreaZZ3  := ZZ3->(GetArea())                                    
Local _aAreaSZ9  := SZ9->(GetArea())
Local _aAreaSD1  := SD1->(GetArea())
Local _aAreaAB2  := AB2->(GetArea())
Local _aAreaAB7  := AB7->(GetArea())
Local _aAreaAB9  := AB9->(GetArea())
Local _aAreaSD9  := SD9->(GetArea())


Private cPerg 	:= "TRCIMEI"
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a fazer troca de IMEI
	If upper(AllTrim(GRPRetName(aGrupos[i]))) $ "ADMINISTRADORES#NEXTELLIDER#EXPLIDER"
		lUsrAut  := .T.
	EndIf
	
Next i

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Bloqueio de usuario sem acesso                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lUsrAut
	MsgStop("Usuแrio sem permissใo para utilizar essa rotina favor entrar em contato com a แrea de TI")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha a tabela temporaria QRY e QRY1 se estiver aberta.             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Verifica dicionario de perguntas                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fCriaSX1(cPerg)

If Pergunte(cPerg, .T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|Verifica parametros em brancos                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(mv_par01) .Or. Empty(mv_par02) .Or. Empty(mv_par03) .Or. Empty(mv_par05) .Or. Empty(mv_par06)
		MsgStop("Todos Campos sใo obrigatorios. Favor preencher os mesmos.")
		Return
	EndIf
	
	CursorWait()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao Query                                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cQry	:= " SELECT	ZZ4.ZZ4_OS					AS       OS,  " + ENTER
	_cQry	+= "		ZZ4.ZZ4_NFENR				AS    NFENR,  " + ENTER
	_cQry	+= "	   	ZZ4.ZZ4_NFESER				AS	 NFESER,  " + ENTER
	_cQry	+= "		ZZ4.ZZ4_CARCAC				AS  CARCACA,  " + ENTER
	_cQry	+= " 		ZZ4.ZZ4_IMEI				AS  Z4_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(SZA.ZA_IMEI,   0)	AS  ZA_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(ZZ3.ZZ3_IMEI,  0)	AS  Z3_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(SZ9.Z9_IMEI,   0)	AS  Z9_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(SD1.D1_NUMSER, 0)	AS  D1_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(SD2.D2_NUMSERI,0)	AS  D2_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(AB2.AB2_NUMSER,0)	AS AB2_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(AB7.AB7_NUMSER,0)	AS AB7_IMEI,  " + ENTER
	_cQry	+= "		ISNULL(AB9.AB9_SN    ,0)	AS AB9_IMEI   " + ENTER
	_cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock)      " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = SZA.ZA_IMEI AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("ZZ3") + " ZZ3 (nolock)  " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ4.ZZ4_OS = ZZ3.ZZ3_NUMOS AND ZZ4.D_E_L_E_T_ = ZZ3.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = ZZ3.ZZ3_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("SZ9") + " SZ9 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = SZ9.Z9_IMEI AND ZZ4.ZZ4_OS = SZ9.Z9_NUMOS AND ZZ4.D_E_L_E_T_ = SZ9.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = SZ9.Z9_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlname("SD1") + " SD1 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = SD1.D1_NUMSER AND ZZ4.ZZ4_NFENR = SD1.D1_DOC AND ZZ4.ZZ4_NFESER = SD1.D1_SERIE AND ZZ4.D_E_L_E_T_ = SD1.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = SD1.D1_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlname("AB2") + " AB2 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = AB2.AB2_NUMSER AND ZZ4.ZZ4_OS = AB2.AB2_NUMOS AND ZZ4.D_E_L_E_T_ = AB2.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = AB2.AB2_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("AB7") + " AB7 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = AB7.AB7_NUMSER AND ZZ4.ZZ4_OS = AB7.AB7_NUMOS AND ZZ4.D_E_L_E_T_ = AB7.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = AB7.AB7_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("AB9") + " AB9 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = AB9.AB9_SN AND ZZ4.ZZ4_OS = AB9.AB9_NUMOS AND ZZ4.D_E_L_E_T_ = AB9.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = AB9.AB9_FILIAL) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("SD2") + " SD2 (nolock) " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_IMEI = SD2.D2_NUMSERI AND ZZ4.ZZ4_NFENR = SD2.D2_NFORI AND ZZ4.ZZ4_NFESER = SD2.D2_SERIORI AND ZZ4.D_E_L_E_T_ = SD2.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = SD2.D2_FILIAL) " + ENTER
	_cQry	+= "WHERE ZZ4.D_E_L_E_T_ = '' " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_IMEI   = '" + mv_par01 + "' " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_CARCAC = '" + mv_par02 + "' " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_NFENR  = '" + mv_par03 + "' " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_NFESER = '" + mv_par04 + "' " + ENTER
	
	MemoWrite("trc_imei.sql", _cQry)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	
	_nD2imei	:= Len(AllTrim(QRY->D2_IMEI))  > 1
	_nZaimei	:= Len(AllTrim(QRY->ZA_IMEI))  > 1
	_nZ4imei	:= Len(AllTrim(QRY->Z4_IMEI))  > 0
	_nZ3imei	:= Len(AllTrim(QRY->Z3_IMEI))  > 1
	_nZ9imei	:= Len(AllTrim(QRY->Z9_IMEI))  > 1
	_nD1imei	:= Len(AllTrim(QRY->D1_IMEI))  > 1
	_nB2imei	:= Len(AllTrim(QRY->AB2_IMEI)) > 1
	_nB7imei	:= Len(AllTrim(QRY->AB7_IMEI)) > 1
	_nB9imei	:= Len(AllTrim(QRY->AB9_IMEI)) > 1
	
	If _nD2imei
		MsgAlert("IMEI em encerramento ou encerrado impossํvel fazer altera็ใo do mesmo!")
		Return
	EndIf
	
	If _nZaimei 
		
		SZA->(dbsetorder(3)) //ZA_FILIAL+ZA_NFISCAL+ZA_SERIE+ZA_IMEI
		If SZA->(DbSeek(xFilial("SZA") + QRY->NFENR + QRY->NFESER + QRY->ZA_IMEI))
			
			Begin Transaction
			RecLock('SZA',.F.)
			
			SZA->ZA_IMEI := mv_par05
			
			MsUnlock()
			End Transaction
		
		EndIf	
		
	EndIf
	
	If _nZ4imei
		  
		ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
		If ZZ4->(DbSeek(xFilial("ZZ4") + QRY->Z4_IMEI + QRY->OS))
			
			Begin Transaction
			RecLock('ZZ4',.F.)
			
			ZZ4->ZZ4_IMEI 		:= mv_par05
			ZZ4->ZZ4_CARCAC 	:= MV_PAR06
			
			MsUnlock()
			End Transaction              

		EndIf	
		
	EndIf
	
	If _nZ3imei
	
		ZZ3->(dbsetorder(1)) //ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS+ZZ3_SEQ
		If ZZ3->(DbSeek(xFilial("ZZ3") + QRY->Z3_IMEI + QRY->OS))
			
			Begin Transaction                                    
			
	
			cQryEx := " UPDATE " + RetSqlName("ZZ3") + ENTER
			cQryEx += " SET ZZ3_IMEI = '"+mv_par05+"' "
			cQryEx += " WHERE D_E_L_E_T_ = '' "
			cQryEx += " AND ZZ3_NUMOS = '"+QRY->OS+"' "
			cQryEx += " AND ZZ3_IMEI = '"+QRY->Z3_IMEI+"' "
			
			TcSQlExec(cQryEx)
			TCRefresh(RETSQLNAME("ZZ3"))
			
			End Transaction              
			
		EndIf		
		
	EndIf
	
	If _nZ9imei
		
		SZ9->(dbsetorder(2)) //Z9_FILIAL+Z9_IMEI+Z9_NUMOS+Z9_SEQ+Z9_ITEM
		If SZ9->(DbSeek(xFilial("SZ9") + QRY->Z3_IMEI + QRY->OS))
			
			Begin Transaction                                    
			
			cQryExe := " UPDATE " + RetSqlName("SZ9") + ENTER
			cQryExe += " SET Z9_IMEI = '"+mv_par05+"'
			cQryExe += " WHERE D_E_L_E_T_ = '' "
			cQryExe += " AND Z9_NUMOS = '"+QRY->OS+"' "
			cQryExe += " AND Z9_IMEI = '"+QRY->Z3_IMEI+"' " 
			
			TcSQlExec(cQryExe)
			TCRefresh(RETSQLNAME("SZ9"))
			
			End Transaction 
				
		EndIf	             
		
	EndIf
	
	// M.Munhoz - 16/08/2011
	If _nD1imei 
			
		SD1->(DBOrderNickName('D1NUMSER')) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
		If SD1->(DbSeek(xFilial("SD1") + QRY->NFENR + QRY->NFESER))
			
			Begin Transaction                                    
			
			Do While !SD1->(EOF()) .And. SD1->D1_FILIAL = xFilial("SD1") .And. SD1->D1_DOC == QRY->NFENR .And. SD1->D1_SERIE == QRY->NFESER 
			
				if SD1->D1_NUMSER == mv_par01  // M.Munhoz - 25/08/2011 - alimenta SD1 apenas quando o D1_NUMSER estiver preenchido e for igual ao mv_par01 (IMEI atual)
			RecLock('SD1',.F.)
			
			SD1->D1_NUMSER := mv_par05
			
			MsUnlock()
				endif			
			SD1->(dbskip())
            Enddo
			
			End Transaction 
				
		EndIf	             
		
	EndIf
	
	If _nB2imei
		
		AB2->(dbsetorder(6)) //AB2_FILIAL+AB2_NUMOS
		If AB2->(DbSeek(xFilial("AB2") + AllTrim(QRY->OS)))
			
			Begin Transaction
			RecLock('AB2',.F.)
			
			AB2->AB2_NUMSER := mv_par05
			
			MsUnlock()
			End Transaction              
			
		EndIf	
		
	EndIf
	
	If _nB7imei
		
		AB7->(dbsetorder(1)) //AB7_FILIAL+AB7_NUMOS+AB7_ITEM
		If AB7->(DbSeek(xFilial("AB7") + AllTrim(QRY->OS)))
			
			Begin Transaction
			RecLock('AB7',.F.)
			
			AB7->AB7_NUMSER := mv_par05
			
			MsUnlock()
			End Transaction              
			
		EndIf	
		
	EndIf
	
	If _nB9imei
		
		AB9->(DBOrderNickName('AB9SNOSCLI'))//AB9->(dbsetorder(7)) //AB9_FILIAL+AB9_SN+AB9_NUMOS+AB9_CODCLI+AB9_LOJA
		If AB9->(DbSeek(xFilial("AB9") + AllTrim(QRY->OS)))
			
			Begin Transaction
			RecLock('AB9',.F.)
			
			AB9->AB9_SN := mv_par05
			
			MsUnlock()
			End Transaction              
			
		EndIf	
		
	EndIf
	
	If !Empty(AllTrim(mv_par06))
		
		_cQryc	:= "SELECT 	ZZ4.ZZ4_IMEI  			  IMEI,	 " + ENTER
		_cQryc	+= "		ZZ4.ZZ4_OS				    OS,  " + ENTER
		_cQryc	+= "		ZZ4.ZZ4_CARCAC			CARCAC,  " + ENTER
		_cQryc	+= "		ZZ4.ZZ4_OPEBGH 			OPERAC,  " + ENTER
		_cQryc	+= "		DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  " + ENTER
		_cQryc	+= "				(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) MES " + ENTER
		_cQryc	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock)   " + ENTER
		_cQryc	+= "LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock)   " + ENTER
		_cQryc	+= "ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI    " + ENTER
		_cQryc	+= "AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)   " + ENTER
		_cQryc	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 (nolock)   " + ENTER
		_cQryc	+= "ON(ZZ4.ZZ4_CODPRO = SB1.B1_COD)   " + ENTER
		_cQryc	+= "WHERE  ZZ4.ZZ4_STATUS < = '5' " + ENTER
		_cQryc	+= "AND ZZ4.D_E_L_E_T_ = ''   " + ENTER
		_cQryc	+= "AND ZZ4.ZZ4_CARCAC = '"+mv_par06+"' " + ENTER
		
	   //	MemoWrite("trc_imei9.sql", _cQry)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryc), "QRY1", .F., .T.)
		
		_periodo := Posicione("ZZJ", 1, xFilial("ZZJ") + QRY1->OPERAC, "ZZJ_PERGAR")
		
		If QRY1->MES + 1 <= _periodo
			_cgaran	:= "S"
		ElseIf QRY1->MES + 1 > _periodo
			_cgaran	:= "N"
		EndIf
		 
		ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
		If ZZ4->(DbSeek(xFilial("ZZ4") + QRY->Z4_IMEI + QRY->OS))
			
			Begin Transaction
			RecLock('ZZ4',.F.)
			
			ZZ4->ZZ4_GARANT := _cgaran
			
			MsUnlock()
			End Transaction              
			
		EndIf	
		
	EndIf
	
	CursorArrow()
	 
	MsgAlert("Altera็ใo efetuada com sucesso !!")
	
Else                                             
	MsgAlert("Altera็ใo efetuada com Erro !!")
EndIf	   

// Acrescentado em 16/12/2011 por  Gilberto.Suzart 
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
               
// Termina aqui
//  QRY->(dbCloseArea())
//  QRY1->(dbCloseArea())

RestArea(_aAreaZZ4)
RestArea(_aAreaSZA)
RestArea(_aAreaZZ3)
RestArea(_aAreaSZ9)
RestArea(_aAreaSD1)
RestArea(_aAreaAB2)
RestArea(_aAreaAB7)
RestArea(_aAreaAB9)
RestArea(_aAreaSD9)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  26/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
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
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey 		:= ""
Local aHelpEng 	:= {}
Local aHelpPor 	:= {}
Local aHelpSpa 	:= {}

PutSX1(cPerg,"01","IMEI Atual        ?","","","mv_ch1","C",TamSX3("ZZ4_IMEI")[1],0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Carca็a Atual     ?","","","mv_ch2","C",16,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Nบ da NF-e        ?","","","mv_ch3","C",09,0,0,"G","",""    ,"","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie NF-e        ?","","","mv_ch4","C",03,0,0,"G","",""    ,"","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","IMEI Novo         ?","","","mv_ch5","C",TamSX3("ZZ4_IMEI")[1],0,0,"G","",""    ,"","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Carca็a Novo      ?","","","mv_ch6","C",16,0,0,"G","",""    ,"","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o IMEI Atual.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Carca็a Atual.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Num. NF-e Atual.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Serie NF-e Atual.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o IMEI Novo.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P." + cPerg + "06."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Carca็a Nova.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return Nil
