#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"                  
// PONTO DE ENTRADA NAS MOVIMENTACOES INTERNAS PARA BUSCAR O CUSTO DO ITEM 
User Function MT185SD3
//COMENTADO PARA ADIÇÃO DE TRATAMENTO CONFORME GLPI 19047 - VINICIUS LEONARDO - DELTA DECISÃO - 16/07/2014

/*Local QRY 	 := ""
Local cProd  := M->D3_COD      
Local cQuant := M->D3_QUANT                    
Local cTm    := M->D3_TM

u_GerA0003(ProcName())

//SF5->(DBSETORDER(1))
//IF SF5->(DBSEEK( XFILIAL("SF5") + cTm )) .and. SF5->F5_VAL $'S/1' // SOMENTE PARA MOVIMENTO VALORIZADO TRAZ O CUSTO DO ITEM
	IF Select("QRY") <> 0 
		DbSelectArea("QRY")
		DbCloseArea()
	Endif   
	cQuery := " SELECT TOP 1 D1_CUSTO,D1_QUANT "
	cQuery += " FROM " + RetSqlName("SD1") + " SD1 (nolock) "
	cQuery += " WHERE SD1.D1_FILIAL='" + xFilial("SD1")+"' AND "  
	cQuery += " SD1.D1_COD = '" + cProd + "' AND "  
	cQuery += " SD1.D1_CF IN ('1556','2556','3101','3102','1101','1102','1403') AND "
	cQuery += " SD1.D1_TIPO <> 'C' AND "
	cQuery += "	SD1.D_E_L_E_T_ = ' ' "                          
	cQuery += " ORDER BY D1_DTDIGIT DESC, R_E_C_N_O_ DESC "
	TCQUERY cQuery NEW ALIAS "QRY"       
	QRY->(DBGOTOP())   
	DO WHILE !QRY->(EOF())
		M->D3_CUSTO1 := (QRY->D1_CUSTO / QRY->D1_QUANT) * cQuant
		Exit
	EndDo*/
//ENDIF 

//ADIÇÃO DE TRATAMENTO CONFORME GLPI 19047 - VINICIUS LEONARDO - DELTA DECISÃO - 16/07/2014
If M->D3_CUSTO1 == 0
    
	If Select("SB2") == 0
		dbSelectArea("SB2")
	EndIf	
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(xFilial("SB2")+M->D3_COD+M->D3_LOCAL))
		M->D3_CUSTO1 := SB2->B2_CM1 * M->D3_QUANT
	EndIf
	
	If M->D3_CUSTO1 == 0
		M->D3_CUSTO1 := u_verultcom(M->D3_COD,ddatabase,M->D3_LOCAL) * M->D3_QUANT 
	EndIf	

EndIf  

Return .t.