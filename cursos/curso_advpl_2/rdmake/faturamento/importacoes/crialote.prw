#include 'PROTHEUS.ch'
#include 'topconn.ch'      
User Function CriaLote()
Local cQuery := ""
Local cAliasSB1 := "QUERYSB1"

u_GerA0003(ProcName())

cQuery := "SELECT SB1.B1_FILIAL,SB1.B1_COD "
cQuery += " FROM "+RetSqlName("SB1")+" SB1 (nolock) "
cQuery += " WHERE SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND "
cQuery += " SB1.B1_LOCPAD IN('70','73') AND "
cQuery += " D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSB1, .F., .T.)
DbSelectArea("SB1")
DbSetOrder(1)
dbSelectArea(cAliasSB1)
DbGotop()
While !(cAliasSB1)->(Eof())  
	If SB1->( DbSeek( (cAliasSB1)->B1_FILIAL + (cAliasSB1)->B1_COD ) )  
		Reclock("SB1",.F.)
		SB1->B1_RASTRO := "S"
		MsUnlock()
	EndIF
	(cAliasSB1)->(DbSkip())
EndDo    
dbCloseArea()
DbSelectArea("SB1")
Return .t.