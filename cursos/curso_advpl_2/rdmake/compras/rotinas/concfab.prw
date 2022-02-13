#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function ConCFab
/*Controle de conta corrente dos fabricantes
Claudia Cabral 03/02/2009 */   
Private ldelpol := .f.
Private cFabric    := Space(6)           
pRIVATE cLoja      := space(2)
PRIVATE cMarca   := GetMark( )
Private aStruD1 := {}   
PRIVATE lInverte := .F.

u_GerA0003(ProcName())

IF Select("QRY") <> 0 
	DbSelectArea("QRY")
	DbCloseArea()
Endif   
DbSelectarea("ZZE")
DbSetOrder(1)
IF Select("TMPSD1") <> 0 
	DbSelectArea("TMPSD1")
	DbCloseArea()
Endif
SetPrvt("oDlg1","oGrp1","oSay1","oFabric","oBrw1","oSBtn1","oSBtn2","oSBtn3")

aAdd( aStruD1, { "D1_OK"     , "C", 2                     , 0 } )
aAdd( aStruD1, { "D1_DOC"    , "C", TamSX3("D1_DOC")   [1], 0 } )
aAdd( aStruD1, { "D1_SERIE"  , "C", TamSX3("D1_SERIE") [1], 0 } )
aAdd( aStruD1, { "D1_FORNECE", "C", TamSX3("D1_FORNECE")   [1], 0 } )
aAdd( aStruD1, { "D1_LOJA"   , "C", TamSX3("D1_LOJA")  [1], 0 } )
aAdd( aStruD1, { "D1_EMISSAO" , "D", 8					  , 0 } )
aAdd( aStruD1, { "D1_ITEM"   , "C", TamSX3("D1_ITEM")  [1], 0 } )
aAdd( aStruD1, { "D1_COD"    , "C", TamSX3("D1_COD")   [1], 0 } )
aAdd( aStruD1, { "D1_QUANT"  , "N", TamSX3("D1_QUANT") [1], 2 } )
aAdd( aStruD1, { "D1_VUNIT"  , "N", TamSX3("D1_VUNIT") [1], 5 } )      
aAdd( aStruD1, { "D1_TOTAL"  , "N", TamSX3("D1_TOTAL") [1], 5 } )
aAdd( aStruD1, { "D1_TABPOL" , "N", TamSX3("D1_TOTAL") [1], 5 } )
aAdd( aStruD1, { "D1_DIFUN"  , "N", TamSX3("D1_VUNIT") [1], 5 } )
aAdd( aStruD1, { "D1_DIFTOT" , "N", TamSX3("D1_VUNIT") [1], 5 } )

cArqSD1 := CriaTrab( aStruD1, .T. )
dbUseArea( .T.,, cArqSD1, "TMPSD1", .F., .F. )
cChave:="D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM"  
cIndxtemp := "TINDSD1"
IndRegua("TMPSD1",cIndxTemp,cChave,,,"Buscando Notas Fiscais...") 
dbClearIndex()
DbSetIndex(cIndxTemp+OrdBagExt())
TMPSD1->(dbSetOrder(1))

oDlg1      := MSDialog():New( 089,104,614,1012,"Conta Corrente de Fabricantes",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,252,444,"Manutencao de Saldos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 024,012,{||"Fabricante :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oFabric    := TGet():New( 024,040,{|u| If(PCount()>0,cFabric:=u,cFabric)},oGrp1,060,008,'',{|X| ExistCpo("SA2",cFabric)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cFabric",,)
oLoja      := TGet():New( 024,104,{|u| If(PCount()>0,cLoja:=u,cLoja)},oGrp1,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLoja",,)
DbSelectArea("TMPSD1")
DbSetOrder(1)
oBrw1      := MsSelect():New( "TMPSD1","","",{{"D1_OK","","D1_OK","@!"},{"D1_DOC","","Documento",""},{"D1_SERIE","","Serie",""},{"D1_ITEM","","Item",""},{"D1_COD","","Produto",""},{"D1_QUANT","","Quantidade","@E 99,999,999.99"},{"D1_VUNIT","","Valor Unitario","@E 99,999,999 .99999"},{"D1_TOTAL","","Valor Total","@E 99,999,999 .99999"},{"D1_TABPOL","","Tabela Politica Unitario","@E 99,999,999 .99999"},{"D1_DIFUN","","Diferenca Unitario","@E 99,999,999 .99999"},{"D1_DIFTOT","","Diferenca Total","@E 99,999,999 .99999"},{"D1_FORNECE","","Fornecedor",""},{"D1_LOJA","","Loja",""}},.t.,,{044,008,220,440},,, oGrp1 ) 

//oBrW1     :=  MsSelect():New( "TRBSE1", "TRB_OK", , aCpos, @lInverte, @cMarca,{036,004,140,340},,, oGrp1 ) 
oBrW1:oBrowse:lHasMark    := .t.
oBrW1:oBrowse:lCanAllMark := .t.                                         
oBrW1:oBrowse:bLDblClick:={||Atu_NF(oBrW1)}    
oBrW1:oBrowse:Refresh()    


oSBtn1     := SButton():New( 228,180,1,{|X| SaveNF()},oGrp1,,"", )
oSBtn2     := SButton():New( 228,224,2,{|| oDlg1:end()},oGrp1,,"", )
oSBtn3     := SButton():New( 028,128,18,{|X| BuscaNF()},oGrp1,,"", )    
oSBtn4     := SButton():New( 028,166,2,{|X| DeleNF()},oGrp1,,"", )

oDlg1:Activate(,,,.T.)

Return   

Static Function BuscaNF()
Local nCont := 0
Private cvlrpol    := 0     
SetPrvt("oDlg2","oGrp1","","ovlrpol")           
lDelpol := .f.
DbSelectArea("ZZE")
DbSetOrder(1)
cQuery := "SELECT SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_LOJA,SD1.D1_EMISSAO,"
cQuery += "SD1.D1_ITEM,SD1.D1_COD,SD1.D1_QUANT,SD1.D1_VUNIT,SD1.D1_TOTAL"
cQuery += "  from "
cQuery += RetSQLName("SD1")+" SD1 (nolock) LEFT JOIN " + RetSQLName("ZZE") + " ZZE (NOLOCK) ON "  
cQuery += "   ZZE_FILIAL = '" + xFilial("ZZE")+"' "
cQuery += "   and  ZZE_FORNEC = '"  + cFabric + "' "
cQuery += "   and  ZZE_LOJA = '" + cLoja  + "' "    
cQuery += "   and  ZZE_DOC  = SD1.D1_DOC  "    
cQuery += "   and  ZZE_SERIE =  SD1.D1_SERIE  "    
cQuery += "   and  ZZE_ITEM = SD1.D1_ITEM   "  
cQuery += "   and ZZE.D_E_L_E_T_ = ' '  "                  
cQuery += "   where D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += "   and  D1_FORNECE = '"  + cFabric + "'"
cQuery += "   and  D1_LOJA = '" + cLoja  + "'"    
cQuery += "   and SD1.D_E_L_E_T_ = ' ' "                         
cQuery += "   and  ZZE_DOC IS NULL "
cQuery := ChangeQuery( cQuery )         
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
QRY->( dbEval( {|| nCont++ } ) )
QRY->( dbGoTop() )
ProcRegua( nCont )
TMPSD1->(DBGOTOP())
While TMPSD1->( !eof() )
	RecLock( "TMPSD1", .F. )
	TMPSD1->(DbDelete())
	TMPSD1->(MsUnlock())
	TMPSD1->(DBSKIP())
EndDo             
QRY->( dbGoTop() )
while QRY->( !eof() )
	IncProc( "Filtrando Notas Fiscais ..." )
	RecLock( "TMPSD1", .T. )                   
	TMPSD1->D1_OK     := ""
	TMPSD1->D1_DOC    := QRY->D1_DOC
	TMPSD1->D1_SERIE  := QRY->D1_SERIE
	TMPSD1->D1_FORNECE := QRY->D1_FORNECE
	TMPSD1->D1_LOJA   := QRY->D1_LOJA
	TMPSD1->D1_ITEM   := QRY->D1_ITEM
	TMPSD1->D1_COD    := QRY->D1_COD
	TMPSD1->D1_QUANT  := QRY->D1_QUANT
	TMPSD1->D1_VUNIT  := QRY->D1_VUNIT
	TMPSD1->D1_TOTAL  := QRY->D1_TOTAL    
	TMPSD1->D1_EMISSAO := STOD(QRY->D1_EMISSAO)
	TMPSD1->( msUnlock() )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )
dbSelectArea( "TMPSD1" )	// Apos um dbCloseArea, sempre ative algum outro alias
DbCloseArea()
dbUseArea( .T.,, cArqSd1, "TMPSD1", .F., .F. )
cChave:="D1_DOC+D1_SERIE+D1_ITEM+D1_COD"  
cIndxtemp := "TINDSD1"
IndRegua("TMPSD1",cIndxTemp,cChave,,,"Buscando Notas Fiscais do Fabricante...") 
dbClearIndex()
DbSetIndex(cIndxTemp+OrdBagExt())
TMPSD1->(dbSetOrder(1))
TMPSD1->(DbGoTop())  
oFABRIC:Refresh()
olOJA:Refresh()
oBrW1:oBrowse:Refresh()
Return .t.
               
Static Function SaveNF()       
TMPSD1->(DbGoTop())
Do While !TMPSD1->(EOF())
	If !empty(TMPSD1->D1_OK)       
		If TMPSD1->D1_TABPOL =  0 // quer excluir a Tabela Politica
			ZZE->(DbSeek(Xfilial("ZZE") + TMPSD1->D1_DOC + TMPSD1->D1_SERIE + TMPSD1->D1_FORNECE + TMPSD1->D1_LOJA + TMPSD1->D1_COD  )) 
			While ! ZZE->(Eof()) .and. ZZE->ZZE_DOC   = TMPSD1->D1_DOC   .AND. ;
				ZZE->ZZE_SERIE  = TMPSD1->D1_SERIE .AND. ;
				ZZE->ZZE_FORNEC = TMPSD1->D1_FORNECE .AND. ;
				ZZE->ZZE_LOJA   = TMPSD1->D1_LOJA .AND. ;
				ZZE->ZZE_COD    = TMPSD1->D1_COD
				If 	ZZE->ZZE_ITEM   = TMPSD1->D1_ITEM		
					RECLOCK("ZZE",.F.)
					ZZE->(DbDelete())	
					ZZE->(MsUnlock())
					Exit
				EndIf	
				ZZE->(DbSkip())
			EndDo
		Else // Item Novo
			RECLOCK("ZZE",.T.)               
			ZZE->ZZE_FILIAL := XFILIAL("ZZE")
			ZZE->ZZE_DOC    := TMPSD1->D1_DOC   
			ZZE->ZZE_SERIE  := TMPSD1->D1_SERIE
			ZZE->ZZE_FORNEC := TMPSD1->D1_FORNECE 
			ZZE->ZZE_LOJA   := TMPSD1->D1_LOJA
			ZZE->ZZE_ITEM   := TMPSD1->D1_ITEM
			ZZE->ZZE_COD    := TMPSD1->D1_COD			 
			ZZE->ZZE_QUANT  := TMPSD1->D1_QUANT 
			ZZE->ZZE_VUNIT  := TMPSD1->D1_VUNIT 
			ZZE->ZZE_TABPOL := TMPSD1->D1_TABPOL
			ZZE->ZZE_DIFUN  := TMPSD1->D1_DIFUN
			ZZE->ZZE_DIFTOT := TMPSD1->D1_DIFTOT 
			ZZE->ZZE_EMISSA := TMPSD1->D1_EMISSAO
			ZZE->(MsUnlock())
		EndIF
	EndIf
	TMPSD1->(DBSKIP())
EndDo                          
//oDlg1:end() 
if lDelPol // Veio da Rotina de Exclusao, monta os dados com as Notas a serem excluidas
	DeleNf()
else // monta os dados para incluir a tabela politica
	BuscaNf()	
endIF
ldelpol := .f.
Return .t.
          
Static Function DeleNF()
Local nCont := 0
Private cvlrpol    := 0     
SetPrvt("oDlg2","oGrp1","","ovlrpol")
DbSelectArea("ZZE")
DbSetOrder(1)                           
lDelpol := .t.
cQuery := "SELECT SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_LOJA,"
cQuery += "SD1.D1_ITEM,SD1.D1_COD,SD1.D1_QUANT,SD1.D1_VUNIT,SD1.D1_TOTAL,ZZE.ZZE_TABPOL,ZZE.ZZE_DIFUN,ZZE.ZZE_DIFTOT"
cQuery += "  from "
cQuery += RetSQLName("SD1")+" SD1 (nolock) INNER JOIN " + RetSQLName("ZZE") + " ZZE (NOLOCK) ON "  
cQuery += "   ZZE_FILIAL = '" + xFilial("ZZE")+"' "
cQuery += "   and  ZZE_FORNEC = '"  + cFabric + "' "
cQuery += "   and  ZZE_LOJA = '" + cLoja  + "' "    
cQuery += "   and  ZZE_DOC  = SD1.D1_DOC  "    
cQuery += "   and  ZZE_SERIE =  SD1.D1_SERIE  "    
cQuery += "   and  ZZE_ITEM = SD1.D1_ITEM   "  
cQuery += "   and ZZE.D_E_L_E_T_ = ' '  "                  
cQuery += "   where D1_FILIAL = '"+xFilial("SD1")+"' "
cQuery += "   and  D1_FORNECE = '"  + cFabric + "'"
cQuery += "   and  D1_LOJA = '" + cLoja  + "'"    
cQuery += "   and SD1.D_E_L_E_T_ = ' ' "                         
//cQuery += "   and  ZZE_DOC IS NULL "
cQuery := ChangeQuery( cQuery )         
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
QRY->( dbEval( {|| nCont++ } ) )
QRY->( dbGoTop() )
ProcRegua( nCont )
TMPSD1->(DBGOTOP())
While TMPSD1->( !eof() )
	RecLock( "TMPSD1", .F. )
	TMPSD1->(DbDelete())
	TMPSD1->(MsUnlock())
	TMPSD1->(DBSKIP())
EndDo             
QRY->( dbGoTop() )
while QRY->( !eof() )
	IncProc( "Filtrando Notas Fiscais ..." )
	RecLock( "TMPSD1", .T. )                   
	TMPSD1->D1_OK     := ""
	TMPSD1->D1_DOC    := QRY->D1_DOC
	TMPSD1->D1_SERIE  := QRY->D1_SERIE
	TMPSD1->D1_FORNECE := QRY->D1_FORNECE
	TMPSD1->D1_LOJA   := QRY->D1_LOJA
	TMPSD1->D1_ITEM   := QRY->D1_ITEM
	TMPSD1->D1_COD    := QRY->D1_COD
	TMPSD1->D1_QUANT  := QRY->D1_QUANT
	TMPSD1->D1_VUNIT  := QRY->D1_VUNIT
	TMPSD1->D1_TOTAL  := QRY->D1_TOTAL
	TMPSD1->D1_TABPOL := QRY->ZZE_TABPOL
	TMPSD1->D1_DIFUN  := QRY->ZZE_DIFUN
	TMPSD1->D1_DIFTOT := QRY->ZZE_DIFTOT
	TMPSD1->( msUnlock() )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )
dbSelectArea( "TMPSD1" )	// Apos um dbCloseArea, sempre ative algum outro alias
DbCloseArea()
dbUseArea( .T.,, cArqSd1, "TMPSD1", .F., .F. )
cChave:="D1_DOC+D1_SERIE+D1_ITEM+D1_COD"  
cIndxtemp := "TINDSD1"
IndRegua("TMPSD1",cIndxTemp,cChave,,,"Buscando Notas Fiscais do Fabricante...") 
dbClearIndex()
DbSetIndex(cIndxTemp+OrdBagExt())
TMPSD1->(dbSetOrder(1))
TMPSD1->(DbGoTop())  
oFABRIC:Refresh()
olOJA:Refresh()
oBrW1:oBrowse:Refresh()
Return .t.


STATIC Function Atu_nf(oBrW1)  
Local cMarca 	:= "XX"         
LOCAL nReg := TMPSD1->(Recno())
IF ! TMPSD1->(EOF())
	

	If TMPSD1->D1_OK  == cMarca       
		RecLock("TMPSD1",.F.)	
		TMPSD1->D1_OK  := Space(2)           
		TMPSD1->(MsUnlock())
		lMarcou := .f.
	Else     
		RecLock("TMPSD1",.F.)
		TMPSD1->D1_OK := cMarca   
		TMPSD1->(MsUnlock())
		cVlrPol := TMPSD1->D1_TABPOL
		oDlg2      := MSDialog():New( 238,357,363,656,"Tabela Politica",,,.F.,,,,,,.T.,,,.T. )
		oGrp1      := TGroup():New( 000,000,052,144,"Valor Tabela Politica",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		OTSAY1      := TSay():New( 020,008,{||"Valor Unitario :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
		ovlrpol    := TGet():New( 020,044,{|u| If(PCount()>0,cvlrpol:=u,cvlrpol)},oGrp1,060,008,'@E 99,999,999.99999',{||Positivo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cvlrpol",,)
		oSxBtn1     := SButton():New( 036,044,1,{|X| SVTABPOL()},oGrp1,,"", )
		oSxBtn2     := SButton():New( 036,080,2,{||odlg2:end()},oGrp1,,"", )
		oDlg2:Activate(,,,.T.)		
		lMarcou := .t.
	EndIf           

ENDIF	
                               
TMPSD1->(dbGoto(nReg))           
oBrW1:oBrowse:Refresh()   
Return .t.

Static Function SVTABPOL
RecLock("TMPSD1",.F.)
TMPSD1->D1_TABPOL := cVlrPol
TMPSD1->D1_DIFUN  := cVlrPol - TMPSD1->D1_VUNIT
TMPSD1->D1_DIFTOT := (cVlrPol - TMPSD1->D1_VUNIT) * TMPSD1->D1_QUANT
TMPSD1->(MsUnlock())
oDlg2:end()
Return .t.