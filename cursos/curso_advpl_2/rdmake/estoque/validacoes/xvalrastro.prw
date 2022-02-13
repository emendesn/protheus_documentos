#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*
Funcao para validar a alteracao do campo rastro do cadastro de produtos.
Caso o saldo de todos os armazens do produto seja maior que zero, nao sera
possivel a alteracao do campo rastro
Claudia Cabral - 02/12/2009.
*/
USER Function XvalRastro(cProd)
Local cQuery := ''
Local lRet := .T.

u_GerA0003(ProcName())

If !INCLUI  .AND. M->B1_RASTRO <> SB1->B1_RASTRO // so valida para alteracao de produto e quando altera o rastro
	IF Select("QRY1") <> 0 
		DbSelectArea("QRY1")
		DbCloseArea()
	Endif       
	cQuery := " SELECT B2_COD,SUM(B2_QATU) 'TOTAL' "
	cQuery += " FROM " + RetSqlName('SB2') + " SB2 "
	cQuery += " WHERE B2_COD = '"  + cPROD    + "' "
	cQuery += " AND B2_FILIAL = '" + xFiliaL("SB2") + "' "
	cQuery += "	AND D_E_L_E_T_ = '' "
	cQuery += " GROUP BY B2_COD "
	TCQUERY cQuery NEW ALIAS "QRY1"
	IF Select("QRY1") <> 0 
		DbSelectArea("QRY1")
	    DbGoTop()
	    If QRY1->TOTAL > 0
	    	MsgAlert( "Ha um saldo de " + Alltrim(Transform(QRY1->TOTAL ,"@E 999,999,999.9999"))+ " unidade(s) para esse item. Nao pode alterar o rastro" )
	    	lRet := .F.
	    Endif
		DbCloseArea()
	Endif       
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a existência de saldo na alteração do campo B1_LOCALIZ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "B1_LOCALIZ" $ Alltrim(__ReadVar)  .And. !INCLUI .AND. &(__ReadVar) <> SB1->B1_LOCALIZ

	cQuery := " SELECT B2_COD,SUM(B2_QATU) 'TOTAL' "
	cQuery += " FROM " + RetSqlName('SB2') + " SB2 "
	cQuery += " WHERE B2_COD = '"  + cPROD    + "' "
	//cQuery += " AND B2_FILIAL = '" + xFiliaL("SB2") + "' "
	cQuery += "	AND D_E_L_E_T_ = '' "
	cQuery += " GROUP BY B2_COD "
	
	If Select("TSQL") <> 0 
		dbSelectArea("TSQL")
		TSQL->(dbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TSQL"
	
	If Select("TSQL") <> 0
	
		dbSelectArea("TSQL")
	    TSQL->(dbGoTop())
	    
	    If TSQL->TOTAL > 0
			MsgAlert("Ha um saldo de " + Alltrim(Transform(TSQL->TOTAL ,"@E 999,999,999.9999"))+ " unidade(s) para esse item, solicite ao estoque o ENDERECAMENTO do produto!")
	    Endif
		
		TSQL->(dbCloseArea())
		
	Endif       
EndIf

Return lRet