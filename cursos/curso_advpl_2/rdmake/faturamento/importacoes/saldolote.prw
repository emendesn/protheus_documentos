#include 'PROTHEUS.ch'
#include 'topconn.ch'      
User Function SaldoLote()
Local cQuery := ""
Local cAliasSB1 := "QUERYSB1"        
Local cLote := "INI0000001"   

u_GerA0003(ProcName())

IF Select("QUERYSB1") <> 0 
	DbSelectArea("QUERYSB1")
	DbCloseArea()
Endif   
DBSELECTAREA("SB1")

cQuery := " SELECT SB1.B1_LOCPAD,SB2.B2_QATU,SB1.B1_COD "  
cQuery += " FROM "+RetSqlName("SB1")+" SB1 (nolock) "
cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 (nolock)  ON "
cQuery += "	SB1.B1_COD = SB2.B2_COD AND  "    
cQuery += "	SB1.B1_LOCPAD = SB2.B2_LOCAL AND  "
cQuery += " SB1.B1_LOCPAD IN ('70','73') "
cQuery += " WHERE	SB1.D_E_L_E_T_ = '' AND "
cQuery += "	SB2.D_E_L_E_T_ = '' AND "     
cQuery += " SB2.B2_LOCAL IN ('70','73') AND "
cQuery += " SB1.B1_RASTRO IN ('L','S') "
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSB1, .F., .T.)       
DbSelectArea("SB8")
DbSetOrder(3)
DbSelectArea("SBF")
DbSetOrder(2)
DbSelectArea("SD5")
DbSetOrder(2)
dbSelectArea(cAliasSB1)
DbGotop()
While !(cAliasSB1)->(Eof())  
	If !SD5->( DbSeek( XFILIAL("SD5") + (cAliasSB1)->B1_COD  + (cAliasSB1)->B1_LOCPAD  + cLote ) )  
		Reclock("SD5",.T.)    
		SD5->D5_FILIAL  := XFILIAL("SD5")                                   
		SD5->D5_PRODUTO := (cAliasSB1)->B1_COD
		SD5->D5_LOCAL   := (cAliasSB1)->B1_LOCPAD
		SD5->D5_QUANT   := (cAliasSB1)->B2_QATU           
		SD5->D5_ORIGLAN := "MAN"
		SD5->D5_NUMSEQ  := PROXNUM()
		SD5->D5_LOTECTL := cLote                       
		SD5->D5_DATA    := CTOD("01/04/09") 
		SD5->D5_DTVALID := CTOD("01/04/09") + 365
		MsUnlock()
	EndIF    
	IF !SB8->( DbSeek( XFILIAL("SB8") + (cAliasSB1)->B1_COD  + (cAliasSB1)->B1_LOCPAD  + cLote ) )                            
		RECLOCK("SB8",.T.)  
		SB8->B8_FILIAL  := XFILIAL("SB8")                                   
		SB8->B8_PRODUTO := (cAliasSB1)->B1_COD
		SB8->B8_LOCAL   := (cAliasSB1)->B1_LOCPAD
		SB8->B8_QTDORI   := (cAliasSB1)->B2_QATU
		SB8->B8_SALDO   := (cAliasSB1)->B2_QATU
		SB8->B8_ORIGLAN := "MAN"
		SB8->B8_LOTECTL := cLote
		SB8->B8_DATA    := CTOD("01/04/09") 
		SB8->B8_DTVALID := CTOD("01/04/09") + 365
		MsUnlock()
	endif    
	/* NAO PRECISA SER CRIADO , POIS SE NAO DUPLICA O SALDO
	IF !SBJ->( DbSeek( XFILIAL("SBJ") + (cAliasSB1)->B1_COD  + (cAliasSB1)->B1_LOCPAD  + cLote ) )                            
		RECLOCK("SBJ",.T.)  
		SBJ->BJ_FILIAL  := XFILIAL("SBJ")                                   
		SBJ->BJ_COD     := (cAliasSB1)->B1_COD
		SBJ->BJ_LOCAL   := (cAliasSB1)->B1_LOCPAD
		SBJ->BJ_QINI    := (cAliasSB1)->B2_QATU
		SBJ->BJ_LOTECTL := cLote
		SBJ->BJ_DATA    := CTOD("31/03/09")
		SBJ->BJ_DTVALID := CTOD("01/04/09") + 365
		MsUnlock()
	endif                     
	*/
	IF SBF->( DbSeek( XFILIAL("SBF") + (cAliasSB1)->B1_COD  + (cAliasSB1)->B1_LOCPAD ) )                            
		DO While ! SBF->(EOF()) .and. 	SBF->BF_FILIAL = XFILIAL("SBF") .AND. ;
						   				SBF->BF_LOCAL = (cAliasSB1)->B1_LOCPAD  .AND. ;
										SBF->BF_PRODUTO = (cAliasSB1)->B1_COD
			RECLOCK("SBF",.F.)  
			SBF->BF_LOTECTL := cLote
			MsUnlock()
			SBF->(DbSkip())
		EndDo
	endif       
	IF SBK->( DbSeek( XFILIAL("SBK") + (cAliasSB1)->B1_COD  + (cAliasSB1)->B1_LOCPAD  + DTOS(CTOD("28/02/09")) ))                            
			RECLOCK("SBK",.F.)  
			SBK->BK_LOTECTL := cLote
			MsUnlock()
	endif
	cLote := Soma1(cLote,10)
	(cAliasSB1)->(DbSkip())
EndDo   
DbcloseArea()
DbSelectArea("SB8")
DbSetOrder(1)
Return .t.