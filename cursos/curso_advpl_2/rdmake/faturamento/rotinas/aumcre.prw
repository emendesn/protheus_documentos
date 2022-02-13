#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'      
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Aumcre    ³ Autor ³  Claudia Cabral       ³ Data ³15/09/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Aumcre()
Local cMyuser := GetNewPar("MV_XULIBCR","")

Local aStruTur := {}
Local aCpos    := {}   
Private lInverte := .F.	
Private cPerg := "XAUMEN"                   
Private cMarca	:= GetMark()	// Flag de marcacao para a markbrowse     
Private NperA      := 0
Private Nperaa     := 0
Private NPerB      := 0
Private NPerc      := 0
Private NPerD      := 0
Private lChkA      := .F.
Private lchkAA     := .F.
Private lChkB      := .F.
Private lChkC      := .F.
Private lChkD      := .F.
SetPrvt("oDlg1","oGrp1","oSay1","oCBox1","oGet1","oCBox2","oGet2","oCBox3","oGet3","oCBox4","oGet4","oCBox5")
SetPrvt("oBrw1","oSBtn1","oSBtn2","oSBtn3","oSBtn4","oSBtn5")

u_GerA0003(ProcName())

If !Substr(cUsuario,7,6) $ cMyUser            
	Aviso('AVISO','Usuario nao autorizado para utilizar essa rotina',{'OK'}) 
	Return
EndIF

//ValidPerg(cPerg)        
Pergunte(cPerg,.F.)

aAdd( aStruTur, { "TRB_OK"       , "C", 2                      , 0 } )
aAdd( aStruTur, { "TRBCLIENTE", "C",   TamSX3("E1_CLIENTE") [1], 0 } )
aAdd( aStruTur, { "TRBLOJA", "C",   TamSX3("E1_LOJA") [1], 0 } )
aAdd( aStruTur, { "TRBNATUREZ", "C",   TamSX3("E1_NATUREZ") [1], 0 } )
aAdd( aStruTur, { "TRBNOME", "C",   TamSX3("A1_NOME") [1], 0 } )
aAdd( aStruTur, { "TRBRISCO", "C",   1, 0 } )
aAdd( aStruTur, { "TRBCURVA"   , "C" , 2, 0 } )     
aAdd( aStruTur, { "TRBLC   "   , "N" , 14, 2 } )
aAdd( aStruTur, { "TRBSECATU"   , "N" , 14, 2 } )
aAdd( aStruTur, { "TRBLCFIN"   , "N" , 14, 2 } )
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
aAdd( aCpos, { "TRBRISCO"  ,,"Risco", ""} )
aAdd( aCpos, { "TRBCURVA" ,, "Curva ABC", "" } )    
aAdd( aCpos, { "TRBLC" ,, "Limite Credito ", "@E 999,999,999.99" } )
aAdd( aCpos, { "TRBSECATU" ,, "Lim.Cred. Adic.Atual", "@E 999,999,999.99" } )
aAdd( aCpos, { "TRBLCFIN" ,, "Lim.Cred.Adic.Novo", "@E 999,999,999.99" } )

oDlg1      := MSDialog():New( 095,232,597,927,"Bolha",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,000,244,344,"Aumento temporario de limite de credito dos clientes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,008,{||"Curva ABC  X  % Aumento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oCBox1     := TCheckBox():New( 032,012,"AA",{|u| If(PCount()>0,lchkAA:=u,lchkAA)},oGrp1,016,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGet1      := TGet():New( 032,044,{|u| If(PCount()>0,nPeraa:=u,nPeraa)},oGrp1,036,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPeraa",,)
oCBox2     := TCheckBox():New( 044,012,"A",{|u| If(PCount()>0,lChkA:=u,lChkA)},oGrp1,016,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGet2      := TGet():New( 044,044,{|u| If(PCount()>0,nPerA:=u,nPerA)},oGrp1,036,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPerA",,)
oCBox3     := TCheckBox():New( 056,012,"B",{|u| If(PCount()>0,lChkB:=u,lChkB)},oGrp1,016,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGet3      := TGet():New( 056,044,{|u| If(PCount()>0,nPerB:=u,nPerB)},oGrp1,036,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPerB",,)
oCBox4     := TCheckBox():New( 068,012,"C",{|u| If(PCount()>0,lChkC:=u,lChkC)},oGrp1,016,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGet4      := TGet():New( 068,044,{|u| If(PCount()>0,nPerc:=u,nPerc)},oGrp1,036,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPerc",,)
oCBox5     := TCheckBox():New( 080,012,"D",{|u| If(PCount()>0,lChkD:=u,lChkD)},oGrp1,016,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGet5      := TGet():New( 080,044,{|u| If(PCount()>0,nPerD:=u,nPerD)},oGrp1,036,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPerD",,)
DbSelectArea("TRBSA1")
oBrW1     :=  MsSelect():New( "TRBSA1", "TRB_OK", , aCpos, @lInverte, @cMarca,{096,004,216,340},,, oGrp1 ) 
oBrW1:oBrowse:lHasMark    := .t.
oBrW1:oBrowse:lCanAllMark := .t.                                         
oBrW1:oBrowse:bLDblClick:={||AtuBR(oBrW1)}
oBrW1:oBrowse:Refresh()    
oSBtn1     := SButton():New( 072,108,17,{|| FiltraCli(oBrw1)},oGrp1,,"", )
oSBtn2     := SButton():New( 060,196,18,{|| LibLim(oBrw1)},oGrp1,,"Libera limite", )
oSBtn3     := SButton():New( 060,276,2,{|| Fim()},oGrp1,,"Sair", )
oSBtn4     := SButton():New( 048,108,5,{|| Pergunte(cPerg, .t.)},oGrp1,,"Parametros", )
oSBtn5     := SButton():New( 060,240,3,{|| CanLim(oBrw1)},oGrp1,,"Cancela Limite", )

ACTIVATE DIALOG oDlg1 CENTERED        

Return

/* Busca faturamento dos clientes conforme parametros definidos pelo usuario */
Static Function FiltraCli(oBrw1)
Local cQuery	:= ""			// Texto da query
Local aStruSE1	:= {}			// Estrutura do arquivo de trabalho do SE1          
Local nCont := 0
Local cRisco := space(01)
Local cCurva := space(01)    
Local labriu := .f.
DbSelectArea("SA1")
DbSetOrder(1)
cQuery := "select SA1.A1_COD,SA1.A1_LOJA ,SA1.A1_RISCO,SA1.A1_NATUREZ,SA1.A1_NOME,SA1.A1_XCURVA,SA1.A1_XASSIG,SA1.A1_LC,SA1.A1_LCFIN" 
cQuery += "  from "
cQuery += RetSQLName("SA1")+" SA1 (nolock) "
cQuery += "   where A1_FILIAL = '"+xFilial("SA1")+"' "   
If !Empty(MV_PAR01)	   
	cQuery += " AND SA1.A1_EST = '" + MV_PAR05 + "' "
EndIF                          
If lChkAA
	cQuery += " AND ( SA1.A1_XCURVA IN ('AA') " 
	labriu := .t.
Endif 
If lChkA  
	If labriu
		cQuery += " OR  SA1.A1_XCURVA IN ('A') "
	Else 
		cQuery += " AND ( SA1.A1_XCURVA IN ('A') "	
		Labriu := .t.
	endif
Endif 
If lChkb 
	If labriu
		cQuery += " OR  SA1.A1_XCURVA IN ('B')  "
	Else 
		cQuery += " AND ( SA1.A1_XCURVA IN ('B') "	
		Labriu := .t.
	endif
Endif                                         
If lChkC  
	If labriu
		cQuery += " OR  SA1.A1_XCURVA IN ('C')  "
	Else 
		cQuery += " AND ( SA1.A1_XCURVA IN ('C') "	
		Labriu := .t.
	endif
Endif 
If lChkD  
	If labriu
		cQuery += " OR  SA1.A1_XCURVA IN ('D')  "
	Else 
		cQuery += " AND ( SA1.A1_XCURVA IN ('D') "	
		Labriu := .t.
	endif
Endif                                         
IF Labriu 
	cQuery += " ) "
	lAbriu := .f.
endif
cQuery += "   and SA1.D_E_L_E_T_ = ' '"                         

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
	RecLock( "TRBSA1", .T. )                   
	TRBSA1->TRB_OK      := ""
	TRBSA1->TRBCLIENTE  := QRY->A1_COD
	TRBSA1->TRBLOJA	    := QRY->A1_LOJA
	TRBSA1->TRBNOME     := QRY->A1_NOME
	TRBSA1->TRBCURVA    := QRY->A1_XCURVA
	TRBSA1->TRBNATUREZ  := QRY->A1_NATUREZ
	TRBSA1->TRBRISCO    := QRY->A1_RISCO
	TRBSA1->TRBLC       := QRY->A1_LC   
	TRBSA1->TRBSECATU   := QRY->A1_LCFIN
	IF lChkaa .and. QRY->A1_XCURVA = "AA"
		TRBSA1->TRBLCFIN    := QRY->A1_LC + (QRY->A1_LC * nPerAA /100)
	Endif
	IF lChka .and. alltrim(QRY->A1_XCURVA) = "A"
		TRBSA1->TRBLCFIN    := QRY->A1_LC + (QRY->A1_LC * nPerA /100)
	Endif	
	IF lChkb .and. alltrim(QRY->A1_XCURVA) = "B"
		TRBSA1->TRBLCFIN    := QRY->A1_LC + (QRY->A1_LC * nPerB /100)
	Endif	
	IF lChkC .and. alltrim(QRY->A1_XCURVA) = "C"
		TRBSA1->TRBLCFIN    := QRY->A1_LC + (QRY->A1_LC * nPerC /100)
	Endif	                                                    
	IF lChkD .and. alltrim(QRY->A1_XCURVA) = "D"
		TRBSA1->TRBLCFIN    := QRY->A1_LC + (QRY->A1_LC * nPerD /100)
	Endif	
	TRBSA1->( msUnlock() )
	QRY->( dbSkip() )
end
QRY->( dbCloseArea() )
dbSelectArea( "TRBSA1" )	// Apos um dbCloseArea, sempre ative algum outro alias
TRBSA1->(dbCloseArea())  
dbUseArea( .T.,, cArqTur, "TRBSA1", .F., .F. )
IndRegua("TRBSA1",cIndxTemp,cChave,,,"Buscando Titulos...") 
dbClearIndex()
DbSetIndex(cIndxTemp+OrdBagExt())     
DbSetOrder(1)
DbGotop()
oBrW1:oBrowse:Refresh(.T.)    
IF reccount() < 1
	Aviso('AVISO','Nao existem clientes para selecao',{'OK'})
Endif 
Return .t.

/* Atualiza limite de credito adicional conforme clientes selecionados pelo usuario*/ 
Static Function LibLim(cmarca)    

TRBSA1->( dbGoTop() )
while TRBSA1->( !eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica apenas o cliente marcado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if !Empty(TRBSA1->TRB_OK)      
		If SA1->( dbSeek(cFilial+TRBSA1->TRBCLIENTE+TRBSA1->TRBLOJA) ) 
			RecLock("SA1",.F.)
			SA1->A1_LCFIN := TRBSA1->TRBLCFIN	  
			SA1->(MSUNLOCK())		
		Endif
	Endif			
	TRBSA1->(DBSKIP())
EndDo  
Aviso('AVISO','Clientes com limite de credito adicional atualizado!',{'OK'})     
//TRBSA1->(DBCloseArea())     
//DbSelectArea("SA1")
Return .t.

/* Cancela limite de credito adicional conforme clientes selecionados pelo usuario*/ 
Static Function CanLim(cmarca)    

TRBSA1->( dbGoTop() )
while TRBSA1->( !eof() )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica apenas o cliente marcado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if !Empty(TRBSA1->TRB_OK)             
		If SA1->( dbSeek(cFilial+TRBSA1->TRBCLIENTE+TRBSA1->TRBLOJA) ) 
			RecLock("SA1",.F.)
			SA1->A1_LCFIN := 0
			SA1->(MSUNLOCK())		
		Endif
		
	Endif			
	TRBSA1->(DBSKIP())
EndDo  
Aviso('AVISO','Clientes com limite de credito adicional atualizado!',{'OK'})     
//TRBSA1->(DBCloseArea())     
DbSelectArea("SA1")
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
//	2			3			4				5		  	   	6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
AAdd(aRegs,{cPerg,"01","UF       :"     ,"UF       :"     ,"UF       :"  ,"mv_ch1"	,"C"	,2			,0			,0			,"G"	,""		,"mv_par01"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,"12"		,""})
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