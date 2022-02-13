#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function nfcanc()    
PRIVATE cPerg	 :="XNFCANC"  
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
  
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local aStru := SE1->(dbStruct())
Local cDataC1    := dtos(dDatabase)
Local cDataC2    := dtos(dDatabase)
Local cDataE1    := dtos(dDatabase)
Local cDataE2    := dtos(dDatabase)
Local nLin := 0
Local nMaxant := 0
Local cMOTIVO := ''            
Local cAliasTOP	:= "TMPZZD"               
Local cValMot := ''
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)


u_GerA0003(ProcName())

If !Empty(MV_PAR01)
	cDataC1 = Dtos(MV_PAR01)
EndIf
If !Empty(MV_PAR02)
	cDatac2 = Dtos(MV_PAR02)
EndIf
If !Empty(MV_PAR01)
	cDataE1 = Dtos(MV_PAR03)
EndIf
If !Empty(MV_PAR02)
	cDataE2 = Dtos(MV_PAR04)
EndIf
cMotivo := STRTRAN(alltrim(mv_par07),"*","")
Private dBaixa := dDataBase                  

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
/*--------         Seleciona NFS Canceladas --------*/
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   
dbSelectArea("ZZD")
DbSetOrder(1)
dbSelectArea("SA1")
DbSetOrder(1)
DbSelectArea("SF2")
DbSetOrder(1)
//If Len(cMotivo) < 17 // nao quer todos os motivos
	For xx = 1 to LEN(cMotivo)
		cValida := Substr(cMotivo,xx,1)    
		cValida := u_VerMotivo(cValida)
		cVALMot += cValida+ "|"                      
	Next          
//EndIF           
cQuery := "SELECT * "
cQuery += "  FROM " +	RetSqlName("ZZD") + " ZZD (NOLOCK) WHERE " 
cQuery += "   ZZD.D_E_L_E_T_ =  ' ' "                
If !Empty(mv_par01)
	cQuery += " AND ZZD_DATA >= '" + cDataC1 + "'"
ENDIF	                                    
IF !Empty(mv_par02)
	cQuery += " AND ZZD_DATA <= '" + cDataC2 + "'"
EndIF	
If !Empty(mv_par03)
	cQuery += " AND ZZD_EMIS >= '" + cDataE1 + "'"
ENDIF	                                    
IF !Empty(mv_par04)
	cQuery += " AND ZZD_EMIS <= '" + cDataE2 + "'"
EndIF	                                   
If !Empty(mv_par05)
	cQuery += " AND ZZD_PEDIDO >= '" + mv_par05 + "'"
ENDIF	                                    
IF !Empty(mv_par06)
	cQuery += " AND ZZD_PEDIDO <= '" + mv_par06 + "'"
EndIF	                                   
If !Empty(mv_par08)
	cQuery += "AND ZZD_FILIAL	 >= '" + MV_PAR08 + "'"
ENDIF	                                    
IF !Empty(mv_par09)
	cQuery += " AND ZZD_FILIAL <= '" + MV_PAR09 + "'"
EndIF	
cQuery += " ORDER BY ZZD_DOC, ZZD_SERIE, ZZD_CLIENT,ZZD_LOJA,ZZD_SEQ"
	
TCQUERY cQuery NEW ALIAS "QRY1"

ProcRegua(Reccount())                                    
cLinha := 'N.Fiscal' + ";" + 'Serie' + ";" +  'Valor' + ";" +  'Emissao' + ";" + 'Cancelamento' + ";"  + "Cod.Cliente" + ";" +  'Cliente' + ";" + 'Loja ' + ";" + ' Pedido ' + ";" + 'Motivo '  + ";" + "Sequencia Exclusao"  + ";" + 'Usuario' 
fWrite(nHandle, cLinha  + cCrLf)
While  !Eof() 
	IncProc()
	SC5->(DBSEEK(XFILIAL("SC5") + QRY1->ZZD_PEDIDO ))     
	//If Len(cMotivo) < 17 // nao quer todas os Motivos
	If !Empty(cValMot)
		If ! QRY1->ZZD_MOTIVO $ cValMot  .and. QRY1->ZZD_MOTIVO <> "**"
			Dbskip()
			Loop
		EndIf         
	EndIF	
	//EndIF                
	
	SA1->(DBSEEK(XFILIAL("SA1") + QRY1->ZZD_CLIENTE  + QRY1->ZZD_LOJA))     		           
	SX5->(dbSeek(cFilial+"ZL"+QRY1->ZZD_MOTIVO))
	SF2->(dbSeek(xFilial("SF2") + QRY1->ZZD_DOC + QRY1->ZZD_SERIE + QRY1->ZZD_CLIENT + QRY1->ZZD_LOJA))
	cLinha := ''
	cLinha += QRY1->ZZD_DOC   + ";"
	cLinha += QRY1->ZZD_SERIE + ";"
	cLinha += Transform(SF2->F2_VALMERC, "@E 99,999,999,999.99")+";" 
	cLinha += DTOC(STOD(QRY1->ZZD_EMIS)) + ";"
	cLinha += DTOC(STOD(QRY1->ZZD_DATA)) + ";"
	cLinha += QRY1->ZZD_CLIENT + ";"
	cLinha += SA1->A1_NOME + ";"
	cLinha += QRY1->ZZD_LOJA + ";"
	cLinha += QRY1->ZZD_PEDIDO + ";"	
	cLinha += Iif(QRY1->ZZD_MOTIVO <> '**', Alltrim(X5Descri()), "!!! *** NF INCLUIDA NOVAMENTE *** !!!" )	+ ";"            
	cLinha += Transform(QRY1->ZZD_SEQ, "999")+ ";"
	cLinha += QRY1->ZZD_USUARI
	fWrite(nHandle, cLinha  + cCrLf)
	DbSelectArea("QRY1")
	dbSkip()
Enddo                                 
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

//CRIACAO DA PERGUNTA
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
        //X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
         //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Dt.Cancel. de  : "        ,"Dt.Cancel. de "   				,"Dt.Cancel. de "  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","Dt.Cancel. ate : "        ,"Dt.Cancel. ate"   				,"Dt.Cancel. ate"  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"03","Dt.Emissao de  : "        ,"Dt.Emissao de "   				,"Dt.Emissao de "  			,"mv_ch3",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"04","Dt.Emissao ate : "        ,"Dt.Emissao ate"   				,"Dt.Emissao ate"  			,"mv_ch4",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"05","Pedido de      : "        ,"Pedido de"   				        ,"Pedido de"  		   		,"mv_ch5",	"C",		06      ,0       ,		0 ,		"G"  ,		"",		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"06","Pedido ate     : "        ,"Pedido ate"   			     	,"Pedido ate"  				,"mv_ch6",	"C",		06      ,0       ,		0 ,		"G"  ,		"",		"mv_par06",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"07","Motivo         : "        ,"Motivo"   			   			,"Motivo"  					,"mv_ch7",	"C",		18      ,0       ,		0 ,		"G"  ,		"",		"mv_par07",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"08","Filial de      : "        ,"Filial de"   						,"Filial de"  				,"mv_ch8",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par08",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"09","Filial ate     : "        ,"Filial ate"   			     	,"Filial ate"  				,"mv_ch9",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par09",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
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
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fmotivo   ³ Autor ³ Claudia Cabral  	    ³ Data ³ 29/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar o motivo de cancelamento   	    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fmotivo()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function fmotivo(l1Elem,lTipoRet)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""
Local x := 1               
Local aValida:={}
Private aCat:={}
                 

aadd(aValida, { "A","01" })
aadd(aValida, {	"B","02" })
aadd(aValida, {	"C","03" })
aadd(aValida, {	"D","04" })
aadd(aValida, {	"E","05" })
aadd(aValida, {	"F","06" })
aadd(aValida, { "G","07" })
aadd(aValida, {	"H","08" })
aadd(aValida, {	"I","09" })
aadd(aValida, {	"J","10" })
aadd(aValida, {	"K","11" })
aadd(aValida, {	"L","12" })
aadd(aValida, {	"M","13" })
aadd(aValida, {	"N","14" })
aadd(aValida, {	"O","15" })
aadd(aValida, {	"P","16" })
aadd(aValida, {	"Q","00" })
aadd(aValida, {	"R","99" }) 
lTipoRet := .T.

l1Elem := If (l1Elem = Nil , .F. , .T.)

cAlias := Alias() 					 // Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

dbSelectArea("SX5")
If dbSeek(cFilial+"00ZL")
   cTitulo := Alltrim(Left(X5Descri(),20))
Endif
If dbSeek(cFilial+"ZL")
	CursorWait()
		While !Eof() .And. SX5->X5_Tabela == "ZL"
			Aadd(aCat,aValida[x,1] + " - " + Alltrim(X5Descri()))
			//MvParDef+=Left(SX5->X5_Chave,1)                           
			dbSkip()         
			X++
		Enddo      
		MvParDef:="ABCDEFGHIJKLMNOPQR     
		                 "
	CursorArrow()
Else
	MsgAlert("Tabela ZL nao encontrada no SX5") // Estou usando situacao Default, nao achei tabela
	aCat :={	"99 - MOTIVO NAO CADASTRADO"}	
	MvParDef:="ABCDEFGHIJKLMNOPQR
	"
	cTitulo :="Motivos de Cancelamento"
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,38,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := mvpar										 // Devolve Resultado
	EndIF
EndIF

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )        


User Function VerMotivo(cValida)
Local aValida  := {}   
Local nDiv     := 0
Local cMotivo  := " "
aadd(aValida, { "A","01" })
aadd(aValida, {	"B","02" })
aadd(aValida, {	"C","03" })
aadd(aValida, {	"D","04" })
aadd(aValida, {	"E","05" })
aadd(aValida, {	"F","06" })
aadd(aValida, { "G","07" })
aadd(aValida, {	"H","08" })
aadd(aValida, {	"I","09" })
aadd(aValida, {	"J","10" })
aadd(aValida, {	"K","11" })
aadd(aValida, {	"L","12" })
aadd(aValida, {	"M","13" })
aadd(aValida, {	"N","14" })
aadd(aValida, {	"O","15" })
aadd(aValida, {	"P","16" })
aadd(aValida, {	"Q","00" })                           
aadd(aValida, {	"R","99" })                          
nDiv := Ascan(aValida, { |X| X[1] = cValida})				
If nDiv > 0    
	cMotivo := aValida[ndiv,2]
EndIF
Return(cMotivo)