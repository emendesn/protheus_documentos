#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณVLDARMEND บAutor  ณHudson de Souza Santosบ Data ณ08/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que valida transi็ใo de produtos entre armaz้ns e    บฑฑ
ฑฑบ          ณendere็os.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VLDARMEND(cArmOri, cEndOri, cArmDest, cEndDest)
Local lRet	:= .T.
Local aArea	:= GetArea()
Local cQry	:= ""
Local lParam := GetMV("BH_DEPARA",.F.)
//ษออออออออหอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บRegra 01บParametro ligado e nenhum armaz้m nใo pode ser vazio       บ
//ศออออออออสอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
If !lParam
	Return(lRet)
ElseIf Empty(cArmOri) //.OR. Empty(cArmDest)
	lRet := .F.
	Return(lRet)
EndIf
//ษออออออออหอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บRegra 02บQuery que busca registro na SZW que antenda a regra de     บ
//บ        บnegocio                                                    บ
//ศออออออออสอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
cQry := "SELECT count(*) as QTD FROM "+RetSQLName("SZW")+"(NOLOCK)"
cQry += " WHERE D_E_L_E_T_ = ''"
cQry += " AND ZW_FILIAL = '"+xFilial("SZW")+"'"
cQry += " AND ZW_ARMDE = '"+cArmOri+"'"
cQry += " AND ZW_ENDDE in ('"+cEndOri+"','*')"
If !Empty(cArmDest)
	cQry += " AND ZW_ARMPARA = '"+cArmDest+"'"
	cQry += " AND ZW_ENDPARA in ('"+cEndDest+"','*')"
EndIf
cQry += " AND ZW_MSBLQL <> '1'"
If Select("QRY") <> 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
TCQUERY cQry NEW ALIAS "QRY"
If QRY->QTD == 0
	lRet := .F.
Endif
dbSelectArea("QRY")
dbCloseArea()
Return(lRet)