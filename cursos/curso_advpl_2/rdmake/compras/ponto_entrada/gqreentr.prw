/* Ponto de Entrada apos a gravacao da NF de Entrada
12/03/2009 - Claudia Cabral 
Validar se a UF do SF1 e SF3 nao estao em branco */
User Function GQREENTR()
Local aArea := GetArea()

	u_GerA0003(ProcName())

If EMPTY(SF1->F1_EST)     
	dbSelectArea(IIf(cTipo$"DB","SA1","SA2"))
	dbSetOrder(1)
	MsgAlert("O Campo UF nao foi gravado - Regravando ...","Atencao") 
	dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA)	    
	Reclock("SF1",.F.)
	REPLACE F1_EST With IIF(SF1->F1_TIPO$"DB",SA1->A1_EST,SA2->A2_EST)
	MsUnlock()
	dbSelectArea("SF3")      
	DbSetOrder(4)
	dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE )
	Replace F3_ESTADO  With SF1->F1_EST
	MsUnlock()
	MsgAlert("Gravada UF: " + SF1->F1_EST + " na NF " + SF1->F1_DOC,"Atencao")	
ENDIF  
RestArea(aArea)
Return .T.
