#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"

User Function GEZZ3AC(cTicket)

Local aArea		:= GetArea()
Local cOPAcer   := GetMv("MV_XOPACER",.F.,"A01")
Local cFasIni   := GetMv("MV_XACAP01",.F.,"000000/00")
Local cFasFim   := GetMv("MV_XACAP02",.F.,"000001/01")
Local cNumCx 	:= ""

Private cImei	:= ""
Private cCarcac := ""
Private cNumCSS := ""

Default cTicket := ""

cQuery := " SELECT "
cQuery += "		Z14.R_E_C_N_O_ AS RECZ14, ZZ4.R_E_C_N_O_ AS RECZZ4 "
cQuery += " FROM "+RETSQLNAME("Z14")+ " Z14 "
cQuery += "	INNER JOIN "+RETSQLNAME("ZZ4")+ " ZZ4 ON "
cQuery += "		ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND "
cQuery += "		ZZ4_CODCLI=Z14_CLIENT AND "
cQuery += "		ZZ4_LOJA=Z14_LOJA AND "
//cQuery += "		ZZ4_CODPRO=Z14_PRODUT AND "
cQuery += "		ZZ4_IMEI=Z14_SERIE AND "
cQuery += "		ZZ4_NFENR=Z14_NOTAE AND "
cQuery += "		ZZ4_NFESER=Z14_SERIEE AND "
cQuery += "		ZZ4.D_E_L_E_T_='' "
cQuery += "	LEFT JOIN "+RETSQLNAME("ZZ3")+ " ZZ3 ON "
cQuery += "		ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND "
cQuery += "		ZZ3_NUMOS=ZZ4_OS AND "
cQuery += "		ZZ3_IMEI=ZZ4_IMEI AND "
cQuery += "		ZZ3.D_E_L_E_T_='' "
cQuery += "	WHERE "
cQuery += "		Z14_FILIAL='"+xFilial("Z14")+"' AND "
If !Empty(cTicket)
	cQuery += "		Z14_CSSNUM = '"+cTicket+"' AND "
Endif
cQuery += "		Z14_PEDIDO = '' AND "
cQuery += "		Z14_NOTAE <> '' AND "
cQuery += "		Z14.D_E_L_E_T_ = '' AND "
cQuery += "		ZZ3_IMEI IS NULL "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ14",.F.,.T.)

While QRYZ14->(!EOF())

	dbselectarea("Z14")
	dbgoto(QRYZ14->RECZ14)
	
	dbselectarea("ZZ4")
	dbgoto(QRYZ14->RECZZ4)
	
	cImei	:= Left(Z14->Z14_SERIE,TamSX3("ZZ4_IMEI")[1])
	cCarcac := Z14->Z14_SERIE
	cNumCSS := Z14->Z14_CSSNUM
	
	
	cImei 	:= cImei+Space(TamSX3("ZZ4_IMEI")[1]-Len(cImei))
	cCarcac := cCarcac+Space(25-Len(cCarcac))
	
	dbSelectArea("ZZO")
	ZZO->(dbSetOrder(1))
	If !dbSeek(xFilial("ZZO")+cImei+cCarcac+"1",.F.)
		cNumCx := GetSXENum("ZZO","ZZO_NUMCX")
		ZZO->(CONFIRMSX8())
		
		dbSelectArea("ZZO")
		dbSetOrder(4)
		While ZZO->(dbSeek(xFilial("ZZO")+cNumCx))
			cNumCx := GetSXENum("ZZO","ZZO_NUMCX")
			ZZO->(CONFIRMSX8())
		EndDo
		
		Begin Transaction
		dbSelectArea("ZZO")
		RecLock("ZZO",.T.)
		ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
		ZZO->ZZO_IMEI		:= Z14->Z14_SERIE
		ZZO->ZZO_CARCAC		:= Z14->Z14_SERIE
		ZZO->ZZO_STATUS		:= '1'
		ZZO->ZZO_MODELO		:= ZZ4->ZZ4_CODPRO//Z14->Z14_PRODUT
		ZZO->ZZO_GARANT  	:= "S"
		ZZO->ZZO_DTSEPA		:= dDataBase
		ZZO->ZZO_HRSEPA		:= Time()
		ZZO->ZZO_USRSEP		:= cUserName
		ZZO->ZZO_NUMCX		:= cNumCx
		ZZO->ZZO_ORIGEM		:= "ACE"
		ZZO->ZZO_CLIENT		:= Z14->Z14_CLIENT
		ZZO->ZZO_LOJA		:= Z14->Z14_LOJA
		ZZO->ZZO_NF			:= Z14->Z14_NOTAE
		ZZO->ZZO_SERIE		:= Z14->Z14_SERIEE
		ZZO->ZZO_PRECO		:= Z14->Z14_VUNIT
		ZZO->ZZO_DESTIN		:= "B"
		ZZO->ZZO_ENVARQ		:= "S"
		ZZO->ZZO_BOUNCE		:= "N"
		ZZO->ZZO_OPERA		:= cOPAcer//Definir operação e tratar no parametro
		ZZO->ZZO_REFGAR		:= "1"
		MsUnlock()
		
		End Transaction
		
	Else
		RecLock("ZZO",.F.)
		ZZO->ZZO_CLIENT		:= Z14->Z14_CLIENT
		ZZO->ZZO_LOJA		:= Z14->Z14_LOJA
		ZZO->ZZO_NF			:= Z14->Z14_NOTAE
		ZZO->ZZO_SERIE		:= Z14->Z14_SERIEE
		MsUnlock()
		
	Endif
		
	dbSelectArea("ZZ4")
	// Ordena o ZZ4 pelo item de Nota Fiscal de Entrada
	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	If dbSeek(xFilial("ZZ4")+ZZO->ZZO_NF+ZZO->ZZO_SERIE+ZZO->ZZO_CLIENT+ZZO->ZZO_LOJA+ZZO->ZZO_MODELO+ZZO->ZZO_IMEI)
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If dbSeek(xFilial("SD1")+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD1->D1_COD)
			
			cCodTec := Posicione("AA1",4,xFilial("AA1") + __cUserID,"AA1_CODTEC")
			cLab 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_LAB")
			
			dbSelectArea("ZZ3")
			RecLock("ZZ3",.T.)
			ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
			ZZ3->ZZ3_CODTEC := cCodTec
			ZZ3->ZZ3_LAB    := cLab
			ZZ3->ZZ3_DATA   := date()
			ZZ3->ZZ3_HORA   := Time()
			ZZ3->ZZ3_CODSET := Substr(cFasIni,1,6)
			ZZ3->ZZ3_FASE1  := Substr(cFasIni,8,2)
			ZZ3->ZZ3_CODSE2 := Substr(cFasFim,1,6)
			ZZ3->ZZ3_FASE2  := Substr(cFasFim,8,2)
			ZZ3->ZZ3_ENCOS  := "N"
			ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
			ZZ3->ZZ3_SWAP   := ""
			ZZ3->ZZ3_IMEISW := ""
			ZZ3->ZZ3_MODSW  := ""
			ZZ3->ZZ3_UPGRAD := ""
			ZZ3->ZZ3_NUMOS  := ZZ4->ZZ4_OS
			ZZ3->ZZ3_STATUS := "1"
			ZZ3->ZZ3_SEQ    := "01"
			ZZ3->ZZ3_USER   := cUserName
			ZZ3->ZZ3_ACAO   := ""
			ZZ3->ZZ3_LAUDO  := ""
			ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
			ZZ3->ZZ3_ESTORN := "N"
			ZZ3->ZZ3_STATRA := "0"
			ZZ3->ZZ3_ASCRAP := "N"
			MsUnlock()
			
			dbSelectArea("ZZ4")
			Reclock("ZZ4",.f.)
			ZZ4->ZZ4_STATUS	:=	"4"
			ZZ4->ZZ4_SETATU := Substr(cFasFim,1,6)
			ZZ4->ZZ4_FASATU := Substr(cFasFim,8,2)
			ZZ4->ZZ4_NFEDT  := dDataBase
			ZZ4->ZZ4_NFEHR  := time()
			ZZ4->ZZ4_DOCDTE := SD1->D1_DTDOCA
			ZZ4->ZZ4_DOCHRE := left(SD1->D1_HRDOCA,2)+":"+substr(SD1->D1_HRDOCA,3,2)+":00"
			ZZ4->ZZ4_LOCAL  := SD1->D1_LOCAL
			ZZ4->ZZ4_GRPPRO := SB1->B1_GRUPO
			ZZ4->ZZ4_ITEMD1 := SD1->D1_ITEM
			ZZ4->ZZ4_GVSOS  := cNumCSS
			msunlock()
			
		Endif
	Endif
	
	QRYZ14->(Dbskip())
EndDo

QRYZ14->(DbClosearea())

RestArea(aArea)

Return()
