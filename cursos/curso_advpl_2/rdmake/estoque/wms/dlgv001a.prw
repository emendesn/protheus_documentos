#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDLGV001A  บAutor  ณLuciano Siqueira    บ Data ณ  07/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. Regra de Convoca็ใo                                   บฑฑ
ฑฑ			                                         			          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION DLGV001A()

Local aArea := GetArea()
Local lRet := .T.
Local aRetRegra := {}
Local cRecHum := PARAMIXB [01]  
Local cNumDoc := PARAMIXB [07]
Local lAtRegra:= Getmv("BH_ATREGRA",.F.,.F.)

u_GerA0003(ProcName())

If lAtRegra
	_cQuery := " SELECT TOP 1 DB_RECHUM AS RECHUM FROM " + RetSqlName("SDB") + " SDB "
	_cQuery += " WHERE DB_FILIAL='"+xFilial("SDB")+"' AND DB_DOC='"+cNumDoc+"' AND "
	_cQuery += " DB_ESTORNO <> 'S' AND DB_RECHUM <> '' AND DB_TM='998' AND SDB.D_E_L_E_T_ ='' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRYSDB",.T.,.T.)

	dbSelectArea("QRYSDB")
	dbGoTop()
	If QRYSDB->(!EOF())
		If Alltrim(cRecHum) <> Alltrim(QRYSDB->RECHUM)
			lRet := .F.
		Endif
	Endif
	
	If lRet
		If	!WmsRegra('1',SDB->DB_LOCAL,cRecHum,SDB->DB_SERVIC,SDB->DB_TAREFA,SDB->DB_ATIVID,SDB->DB_LOCALIZ,SDB->DB_ESTFIS,SDB->DB_ENDDES,SDB->DB_ESTDES,aRetRegra)
			lRet := .F.
		Endif
	Endif
		
	QRYSDB->(dbCloseArea())
Endif

RestArea(aArea)
                     
Return(lRet)