#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'      
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PotenCli  ³ Autor ³  Claudia Cabral       ³ Data ³12/09/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Potencli()
Local cMyuser := GetNewPar("MV_XULIBCR","")
Local aStruTur := {}
Local aCpos    := {}   
Private lInverte := .F.	
Private cPerg := "XPOTEN"                   
Private cMarca	:= GetMark()	// Flag de marcacao para a markbrowse     
Private cGetcont := ''
Private nMinB    := GetNeWPar("MV_CURMINB",50000)
Private nMaxB    := GetNeWPar("MV_CURMAXB",149999.99)                                             
Private nMinc    := GetNeWPar("MV_CURMINC",15000)
Private nMaxC    := GetNeWPar("MV_CURMAXC",49999.99) 
Private nMaxD    := GetNeWPar("MV_CURMAXD",14999.99)                                                                                         
Private cRiscoA  := GetNeWPar("MV_CURVAAR","A")
Private cRiscoB  := GetNeWPar("MV_CURVABR","B")                                             
Private cRiscoC  := GetNeWPar("MV_CURVACR","C")
Private cRiscoD     := GetNeWPar("MV_CURVADR","D")
Private cUserRisco  := GetNeWPar("MV_XUSURIS","") 

u_GerA0003(ProcName())

SetPrvt("oDlg1","oGrp1","oBrw1","oSBtn1","oSBtn2","oSBtn3","oSBtn4","oMGet1","oGetcont")

//If !Substr(cUsuario,7,6) $ cMyUser            
If !Substr(cUsername,7,6) $ cMyUser // Alterado para nova versao P10           
	Aviso('AVISO','Usuario nao autorizado para utilizar essa rotina',{'OK'}) 
	Return
EndIF

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)

aAdd( aStruTur, { "TRB_OK"       , "C", 2                      , 0 } )
aAdd( aStruTur, { "TRBCLIENTE", "C",   TamSX3("E1_CLIENTE") [1], 0 } )
aAdd( aStruTur, { "TRBLOJA", "C",   TamSX3("E1_LOJA") [1], 0 } )
aAdd( aStruTur, { "TRBNATUREZ", "C",   TamSX3("E1_NATUREZ") [1], 0 } )
aAdd( aStruTur, { "TRBNOME", "C",   TamSX3("A1_NOME") [1], 0 } )
aAdd( aStruTur, { "TRBRISANT", "C",   1, 0 } )
aAdd( aStruTur, { "TRBRISATU", "C", 1, 0 } )
aAdd( aStruTur, { "TRBCURVA"   , "C" , 2, 0 } )
aAdd( aStruTur, { "TRBFATURA"    , "N", 20, 2 } )
cArqTur := CriaTrab( aStruTur, .T. )
dbUseArea( .T.,, cArqTur, "TRBSA1", .F., .F. )
cChave:="TRBCLIENTE+TRBLOJA"  
cIndxtemp := "TINDSA1"
IndRegua("TRBSA1",cIndxTemp,cChave,,,"Buscando Titulos...") 
dbClearIndex()
dbSelectArea("TRBSA1")
dbSetIndex(cIndxTemp+OrdBagExt())
TRBSA1->(dbSetOrder(1))


aAdd(aCpos, { "TRB_OK"    ,," ","" } )
aAdd( aCpos, { "TRBCLIENTE",, "Cliente", "" } )
aAdd( aCpos, { "TRBLOJA" ,, "Loja", "" } )
aAdd( aCpos, { "TRBNOME",, "Nome", ""} )
aAdd( aCpos, { "TRBNATUREZ",, "Natureza", ""} )
aAdd( aCpos, { "TRBRISANT"  ,,"Risco Anterior", ""} )
aAdd( aCpos, { "TRBRISATU"  ,,"Risco Atual","" } )
aAdd( aCpos, { "TRBCURVA" ,, "Curva ABC", "" } )
aAdd( aCpos, { "TRBFATURA" ,, "Total Faturado", "@E 999,999,999,999.99"} )
 
oDlg1      := MSDialog():New( 095,232,490,809,"Classificacao de Clientes",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 000,000,192,284,"Classificacao do Potencial do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
DbSelectArea("TRBSA1")
oBrW1     :=  MsSelect():New( "TRBSA1", "TRB_OK", , aCpos, @lInverte, @cMarca,{012,004,172,276},,, oGrp1 ) 
oBrW1:oBrowse:lHasMark    := .t.
oBrW1:oBrowse:lCanAllMark := .t.                                         
oBrW1:oBrowse:bLDblClick:={||AtuBR(oBrW1)}
oBrW1:oBrowse:Refresh()    

oSBtn1     := SButton():New( 176,048,5 ,{|| Pergunte(cPerg, .t.)},oGrp1,,"", )
oSBtn2     := SButton():New( 176,088,17,{|| BuscaFat(oBrw1)},oGrp1,,"", )
oSBtn3     := SButton():New( 176,124,1 ,{|| SaveCli(cmarca)},oGrp1,,"", )
oSBtn4     := SButton():New( 176,160,2 ,{|| Fim()},oGrp1,,"", )

ACTIVATE DIALOG oDlg1 CENTERED        

Return

/* Busca faturamento dos clientes conforme parametros definidos pelo usuario */
Static Function BuscaFat(oBrw1)
Local cQuery	:= ""			// Texto da query
Local aStruSE1	:= {}			// Estrutura do arquivo de trabalho do SE1          
Local nCont := 0
Local cRisco := space(01)
Local cCurva := space(01)      
DbSelectArea("SE1")
DbSetOrder(1)

cQuery := "select SE1.E1_FILIAL,SE1.E1_SALDO,SE1.E1_CLIENTE,SE1.E1_LOJA ,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SA1.A1_RISCO,SA1.A1_NATUREZ,SA1.A1_NOME,SA1.A1_XCURVA,SA1.A1_XASSIG" 
cQuery += "  from "
cQuery += RetSQLName("SE1")+" SE1 (nolock) , "
cQuery += RetSQLName("SA1")+" SA1 (nolock) , "
cQuery += "   where E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += "   and  E1_SALDO = 0 "     
//cQuery += "   and  E1_TIPO NOT IN ('"+ MVABATIM  +" ') "    
cQuery += "   and  E1_TIPO NOT IN ('"+ MVPROVIS  +" ') "     
cQuery += "   and  SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA     
cQuery += "   and  SA1.A1_XASSIG = ''"
If !Empty(MV_PAR01)
	cQuery += "   and  SE1.E1_VENCREA  >= '" + DTOS(MV_PAR01) + "' "
ENDIF
If !Empty(MV_PAR02)
	cQuery += "   and  SE1.E1_VENCREA  <= '" + DTOS(MV_PAR02) + "' "
ENDIF
If !Empty(MV_PAR03)
	cQuery += "   and  SE1.E1_CLIENTE  = '" + MV_PAR03 + "' "
ENDIF
If !Empty(MV_PAR04)	
	cQuery += "   and  SE1.E1_LOJA = '" + MV_PAR04 + "' "
EndIF
If !Empty(MV_PAR05)	   
	cQuery += " AND SA1.A1_EST = '" + MV_PAR05 + "' "
EndIF                  
cQuery += "   and SE1.D_E_L_E_T_ = ' '"                         

cQuery := ChangeQuery( cQuery )         

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

QRY->( dbEval( {|| nCont++ } ) )
QRY->( dbGoTop() )
ProcRegua( nCont )
TRBSA1->(DBGOTOP())
While TRBSA1->( !eof() )
	RecLock( "TRBSA1", .F. )
	TRBSA1->(DbDelete())
	TRBSA1->(MsUnlock())
	TRBSA1->(DBSKIP())
EndDo             
QRY->( dbGoTop() )
while QRY->( !eof() )
	IncProc( "Filtrando dados dos clientes para classificacao" )
	If ! TRBSA1->(dbSeek(QRY->E1_CLIENTE+QRY->E1_LOJA))
		RecLock( "TRBSA1", .T. )                   
		TRBSA1->TRB_OK      := ""
		TRBSA1->TRBCLIENTE  := QRY->E1_CLIENTE
		TRBSA1->TRBLOJA	    := QRY->E1_LOJA
		TRBSA1->TRBNATUREZ  := QRY->A1_NATUREZ
		TRBSA1->TRBNOME     := QRY->A1_NOME
	Else	
		RecLock( "TRBSA1", .F. )                   
	EndIf	
	TRBSA1->TRBRISANT   := QRY->A1_RISCO
	TRBSA1->TRBFATURA += QRY->E1_VALOR
	IF 	   TRBSA1->TRBFATURA <= nMaxD
		cCurva := "D"
		cRisco := cRiscoD
	ElseIf TRBSA1->TRBFATURA  >= nMinC .and. TRBSA1->TRBFATURA <= nMaxC   
		cCurva := "C"
		cRisco := cRiscoC
	ElseIf TRBSA1->TRBFATURA  >= nMinB .and. TRBSA1->TRBFATURA <= nMaxB
		cCurva := "B"
		cRisco := cRiscoB
	Else    // TRBSA1->E1_FATURA  >= 150000.00
		cCurva := "A"
		cRisco := cRiscoA
	Endif
	TRBSA1->TRBRISATU   := cRisco
	TRBSA1->TRBCURVA    := cCurva
	TRBSA1->( msUnlock() )
	QRY->( dbSkip() )
end
QRY->( dbCloseArea() )
dbSelectArea( "TRBSA1" )	// Apos um dbCloseArea, sempre ative algum outro alias
TRBSA1->( dbCloseArea() )  
dbUseArea( .T.,, cArqTur, "TRBSA1", .F., .F. )
IndRegua("TRBSA1",cIndxTemp,cChave,,,"Buscando Titulos...") 
dbClearIndex()
DbSetIndex(cIndxTemp+OrdBagExt())     
DbSetOrder(1)
DbGotop()
oBrW1:oBrowse:Refresh(.T.)     
Return .t.

/* Atualiza Curva ABC do cliente e Risco conforme clientes selecionados pelo usuario*/ 
Static Function SaveCli(cmarca)    

TRBSA1->( dbGoTop() )
while TRBSA1->( !eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica apenas o cliente marcado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
	If SA1->( dbSeek(cFilial+TRBSA1->TRBCLIENTE+TRBSA1->TRBLOJA) ) 
	    RECLOCK("SA1",.F.)
		if TRBSA1->TRB_OK == cMarca       
			//If Substr(cUsuario,7,6) $ cUserRisco
			If Substr(cUsername,7,6) $ cUserRisco // Alterado para nova versao P10
				SA1->A1_RISCO  := TRBSA1->TRBRISATU
			EndIF	
		Endif    
		SA1->A1_XCURVA := TRBSA1->TRBCURVA	 		
		SA1->(MSUNLOCK())
	Endif	
					
	TRBSA1->(DBSKIP())
EndDo  
Aviso('AVISO','Clientes Atualizados!',{'OK'})     
//TRBSA1->(DBCloseArea())     
DbSelectArea("SE1")
Return .t.

/* atualiza os itens marcados no browse */ 
Static Function AtuBr(oBrW1)  
Local cMarca 	:= ThisMark()         
LOCAL nReg := TRBSA1->(Recno())
IF ! TRBSA1->(EOF())
	RecLock("TRBSA1",.F.)

	If TRBSA1->TRB_OK  == cMarca
		TRBSA1->TRB_OK  := Space(2)           
		lMarcou := .f.
	Else
		TRBSA1->TRB_OK := cMarca
		lMarcou := .t.
	EndIf           
	TRBSA1->(MsUnlock())
ENDIF	
TRBSA1->(dbGoto(nReg))           
oBrW1:oBrowse:Refresh()    
Return .t.

Static Function Fim()
TRBSA1->(DBCLOSEAREA())
odlg1:end()
Return .t.


/*Funcao para criacao da pergunta, caso a mesma nao exista*/
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//X1_GRUPO	X1_ORDEM	X1_PERGUNT		X1_PERSPA  			X1_PERENG 	X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2			3			4				5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
AAdd(aRegs,{cPerg,"01","Data de :"        ,"Data de :"   ,"Data de:"  ,"mv_ch1"	,"D"	,8			,0			,0			,"G"	,""		,"mv_par01"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		,""})
AAdd(aRegs,{cPerg,"02","Data ate:"        ,"Data Ate:"   ,"Data de:"  ,"mv_ch2"	,"D"	,8			,0			,0			,"G"	,""		,"mv_par02"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		,""})               
AAdd(aRegs,{cPerg,"03","Cliente :"        ,"Cliente :"   ,"Cliente:"  ,"mv_ch3"	,"C"	,6			,0			,0			,"G"	,""		,"mv_par03"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,"SA1"		,""})  
AAdd(aRegs,{cPerg,"04","Loja    :"        ,"Loja    :"   ,"Loja   :"  ,"mv_ch4"	,"C"	,2			,0			,0			,"G"	,""		,"mv_par04"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		,""})
AAdd(aRegs,{cPerg,"05","UF      :"        ,"UF      :"   ,"UF     :"  ,"mv_ch5"	,"C"	,2			,0			,0			,"G"	,""		,"mv_par05"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,"12"		,""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return .t.