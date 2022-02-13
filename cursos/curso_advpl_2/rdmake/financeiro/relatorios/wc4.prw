#Include "PROTHEUS.CH"

/* Posi‡„o dos Estoques */

User Function SaldoFornec()
Local cString		:="SE1"
Local nRegEmp		:=SM0->(RecNo())
Local dOldDtBase 	:= dDataBase
Local dOldData		:= dDatabase

u_GerA0003(ProcName())              

Pergunte("XWORKC",.F.)

SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL

FAESTImp(cString) 
Return

/**/
Static Function FAESTimp(cString)
Local cAliasTOP	:= "TMPEST"               
Local lContinua 	:= .T.
Local cCond1,cCond2,cCarAnt
Local nSaldo		:=0
Local dDataAnt 	:= dDataBase
Local cIndexSe1
Local cChaveSe1
Local aFiliais 	:= {}
Private nRegSM0 	:= SM0->(Recno())
Private nAtuSM0 	:= SM0->(Recno())
PRIVATE cFilDe,cFilAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ³
//³                                                                  ³
//³ A fun‡„o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ³
//³ efeito de performance. Se o alias auxiliar para a SumAbat() n„o  ³
//³ estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ³
//³ pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SomaAbat("","","","R")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	

//Acerta a database de acordo com o parametro
                     
If Empty(mv_par03)
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par03	// Todas as filiais
	cFilAte:= mv_par04
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	cFilAnt := SM0->M0_CODFIL

	iF Select(cAliasTop) > 0
		DbSelectArea(cAliasTop)
		dbCloseArea()
		DbSelectArea("SA1")
	Endif	
	cData2 :=dDataBase
	If !Empty(MV_PAR01)
		cData2 := MV_PAR01
	EndIf
	cQuery := "SELECT SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_FILIAL  "
	cQuery += " FROM "+RetSqlName('SB2')+" SB2 (NOLOCK) "
	cQuery += " WHERE B2_FILIAL = '" + SM0->M0_CODFIL + "'"
	cQuery += " AND SB2.B2_LOCAL IN " + cArmazem    
	cQuery += " AND SB2.D_E_L_E_T_ = ' '"   
	cQuery += " GROUP BY "
	cQuery += " SB2.B2_COD, SB2.B2_LOCAL,SB2.B2_FILIAL "
	MsAguarde({|| dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), cAliasTOP,.F.,.T.)}, "Selecionando Registros do Estoque ...") 
	
	dbSelectArea(cAliasTop)
	ProcRegua(Reccount())
	Do While !(cAliasTop)->(Eof())
		IncProc()
		If SB1->(DBSEEK(xfilial("SB1") + (cAliasTop)->B2_COD))
			dbSelectArea(cAliasTop)
			nQuant := 0.00
			nCusto := 0.00
			aSaldo := CalcEst((cAliasTOP)->B2_COD,(cAliasTop)->B2_LOCAL,cData2 , (cAliasTOP)->B2_FILIAL)
			nQuant := aSaldo[1]
			nCusto := SB1->B1_CUSTD * nQuant //aSaldo[2]
			If (cAliasTop)->B2_LOCAL $ "80|81" 
				cDivNeg := "06"
			ElseIf (cAliasTop)->B2_LOCAL $ "87" 			
				cDivNeg := "07"
			ElseIf (cAliasTop)->B2_LOCAL $ "83|84|90|91|92" 			
				cDivNeg := "01"			
			ElseIf (cAliasTop)->B2_LOCAL $ "01|1A|1B" 			
				cDivNeg := "04"	
			ElseIF (cAliasTop)->B2_LOCAL $ "21|24" 			
				cDivNeg := "03"       
			ElseIF (cAliasTop)->B2_LOCAL $ "70|71|72|74|73" 	
				cDivNeg := "14" 	           
			Else
				cDivNeg := "  " 	
			EndIF		
			xx := Ascan(aDadosES, { |x| x[1] = "ES" .AND. x[2] = cDivNeg})
			IF xx = 0
				//AADD (aDadosES,{"ES", cDivNeg,(nQuant * nCusto)})
				AADD (aDadosES,{"ES", cDivNeg,( nCusto)})
			Else
			   //	aDadosES[xx,3] += (nQuant * nCusto)				
				aDadosES[xx,3] += ( nCusto)						   
			ENDIF	
		endif		
		(cAliasTop)->(dbSkip())
	EndDo                                                          
	
	dbSelectArea("SM0")
	dbSkip()
Enddo

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL
Return