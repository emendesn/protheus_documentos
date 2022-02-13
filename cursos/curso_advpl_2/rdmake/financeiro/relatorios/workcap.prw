#Include "PROTHEUS.CH"
//#INCLUDE "topconn.ch"

/*
RELATORIO DE WORKING CAPITAL
*/

User Function WorkCap()    
PRIVATE cPerg	 :="XWORKC"     
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif          
Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local xx := 0
Local nMax := 0            
Local cDiv := "01"
Local nLin := 0
Local nMaxant := 0
Local aTotal := {}
Local cDivNeg := ''
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0
LOCAL cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra      
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

Private aDadosCR  := {}
Private aDadosCP  := {}
Private aDadosES  := {}
Private aDivCP    := {}
Private aDivCR    := {}
Private cDivisao  := {} 
Private cValdiv   := ''            
Private cpar05    := mv_par05
Private nQuant := 0
Private nCusto := 0
Private aSaldo := {}
Private cArmazem := "('80','81','87','83','84','01','1A','1B','21','24','90','91','92','70','71','72','74')"    
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))


u_GerA0003(ProcName())

cDivisao := STRTRAN(alltrim(mv_par02),"*","")
If Len(cDivisao) < 16 // nao quer todas as Divisoes  
	For xx = 1 to LEN(cDivisao)
		cValida := Substr(cDivisao,xx,1)    
		cValida := u_VerDivisao(cValida)
		if xx == Len(cDivisao)
			cVALDIV += cValida+ "|"                      
		ELSE
			cvaldiv += cValida+"|"			
		endIF
	Next          
EndIF           


nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

dbSelectArea("SB1")
dbsetorder(1)		
/*--------------------------*/
u_TITREC() // CONTAS A RECEBER


/*-------------------------------------------*/		
U_VtitPag() // grava contas a pagar
	
	
/* ------------------------ estoque ----------------------------------- */
U_SaldoFornec()   // grava saldo dos estoques
	
/* Impressao */
ASORT(aDadosCR,,, { |x, y| x[2] < y[2] })
SX5->(dbSeek(cFilial+"ZX"))
cLinha := '    R$    ' + ";"
nmax := 0
While ! SX5->(Eof()) .And. SX5->X5_Tabela == "ZX"
	nMax++
	cLinha += Alltrim(X5Descri()) + ";"
	SX5->(dbSkip())
Enddo
fWrite(nHandle, cLinha  + cCrLf)

/* ---- Contas A Receber ----- */
cDiv := "01"      
nMaxAnt := nMax   
cLinha := 'CONTAS A RECEBER'    + ";"
ProcRegua(nmax)
For xx = 1 to nMax   
	IncProc()
	If xx=nMax 
		cDiv = "  "
	EndIf 
	nLin := Ascan(aDadosCR, { |x| x[2] = cDiv })
	If nLin > 0
		cLinha += Transform(aDadosCR[nLin,3], "@E 99,999,999,999.99")+";"
		aadd(aTotal,{cDiv,aDadosCR[nLin,3]})
	Else 
		cLinha += " " +";"                  
		aadd(aTotal,{cDiv,0})
	EndIf	      
	cDiv := Soma1(cDiv,2)
Next
fWrite(nHandle, cLinha  + cCrLf)

/* -------  Estoque ------   */
nMax := nMaxAnt    
cDiv := "01"                   
cLinha := 'ESTOQUES' + ";"
ProcRegua(nMax)
For xx = 1 to nMax  
	IncProc()
	If xx=nMax 
		cDiv = "  "
	EndIf 
	nLin := Ascan(aDadosES, { |x| x[2] = cDiv })
	If nLin > 0
		cLinha += Transform(aDadosES[nLin,3], "@E 99,999,999,999.99")+";"
		nAt := Ascan(aTotal, { |x| x[1] = cDiv })
		If nAt > 0
			aTotal[nAt,2] += aDadosES[nLin,3]
		Else
			aadd(aTotal,{cDiv,0})		
		Endif
	Else 
		cLinha += " " +";"
	EndIf	
	cDiv := Soma1(cDiv,2)
Next          
fWrite(nHandle, cLinha  + cCrLf)


/* ---- Contas A Pagar  -------- */

nMax := nMaxAnt    
cDiv := "01"    
cLinha := 'FORNECEDORES'  + ";"
ProcRegua(nMax)
For xx = 1 to nMax  
	IncProc()
	If xx=nMax 
		cDiv = "  "
	EndIf 
	nLin := Ascan(aDadosCP, { |x| x[2] = cDiv })
	If nLin > 0
		cLinha += Transform(aDadosCP[nLin,3], "@E 99,999,999,999.99")+";"
		nAt := Ascan(aTotal, { |x| x[1] = cDiv })
		If nAt > 0
			aTotal[nAt,2] -= aDadosCP[nLin,3]
		Else
			aadd(aTotal,{cDiv,0})		
		Endif
	Else 
		cLinha += " " +";"
	EndIf	
	cDiv := Soma1(cDiv,2)
Next                            
fWrite(nHandle, cLinha  + cCrLf)

/*------ TOTAIS --------- */    
nMax := nMaxAnt    
cDiv := "01"    
cLinha := 'WORKING CAPITAL'  + ";"
ProcRegua(nMax)
For xx = 1 to nMax  
	IncProc()
	If xx=nMax 
		cDiv = "  "
	EndIf 
	nLin := Ascan(aTotal, { |x| x[1] = cDiv })
	If nLin > 0
		cLinha += Transform(aTotal[nLin,2], "@E 99,999,999,999.99")+";"
	Else 
		cLinha += " " +";"
	EndIf	
	cDiv := Soma1(cDiv,2)
Next                            
fWrite(nHandle, cLinha  + cCrLf)
if cpar05 = 1

	/*---------------DETALHE DAS NFS A RECEBER  ------------------------------*/
	ASORT(aDIVCR,,, { |x, y| x[1] < y[1] })
	nMax := Len(aDivCR)    
	cDiv := "$##$" 
	cLinha := ' '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := ' '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := 'DETALHES DOS TITULOS A RECEBER   '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := 'DIVISAO' + ';' +'PREFIXO '  + ";" + 'NUMERO '  + ";"  + 'PARCELA '  + ";" + 'TIPO '  + ";" + 'CLIENTE '  + ";" + 'LOJA '  + ";" + 'NOME '  + ";" + 'VENCTO '  + ";" + 'VALOR  '  + ";" + 'MOEDA '  + ";" + 'FILIAL'
	fWrite(nHandle, cLinha  + cCrLf)
	ProcRegua(nMax)
	For xx = 1 to nMax  
		IF CDIV <> ADIVCR[XX,1] 
			IF SX5->(dbSeek(cFilial+"ZM"+ADIVCR[XX,1] ))
				cDESCDIV := Alltrim(X5Descri())
			//fWrite(nHandle, cLinha  + cCrLf)
				CDIV:= ADIVCR[XX,1] 
			ELSE 
				CDIV :=  ADIVCR[XX,1] +" NAO ACHOU NO SX5"
			ENDIF	
			If Empty(aDivcr[xx,1])
				cDescDiv := "SEM DIVISAO"
			EndIF
		ENDIF	
		IncProc()
		cLinha := cDescDiv + ';'+ aDivCR[xx,2]+';'+aDivCR[xx,3]+';'+aDivCR[xx,4]+';'+aDivCR[xx,5]+';' +aDivCR[xx,6]+';'
		cLinha := clinha + aDivCR[xx,7]+';'+ aDivCR[xx,8]+ ';' + DtoC(aDivCR[xx,9]) +';' +  Transform(aDivCR[xx,10], "@E 99,999,999,999.99")+";" + alltrim(str(aDivCR[xx,11],1))+';'+ aDivCr[xx,12]
		fWrite(nHandle, cLinha  + cCrLf)
	Next       

	/*---------------DETALHE DAS NFS A PAGAR  ------------------------------*/
	ASORT(aDIVCP,,, { |x, y| x[1] < y[1] })
	cDiv := "$##$" 
	nMax := Len(aDivCP)    
	cLinha := ' '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := ' '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := 'DETALHES DOS TITULOS A PAGAR  '  + ";"            
	fWrite(nHandle, cLinha  + cCrLf)
	cLinha := 'DIVISAO' + ';' + 'PREFIXO '  + ";" + 'NUMERO '  + ";"  + 'PARCELA '  + ";" + 'TIPO '  + ";" + 'FORNECEDOR '  + ";" + 'LOJA '  + ";" + 'NOME '  + ";" + 'VENCTO '  + ";" + 'VALOR  '  + ";" + 'MOEDA '  + ";"
	fWrite(nHandle, cLinha  + cCrLf)
	ProcRegua(nMax)
	For xx = 1 to nMax  
		IncProc()       
		IF CDIV <> ADIVCP[XX,1] 
			SX5->(dbSeek(cFilial+"ZM"+ADIVCP[XX,1] ))
			cDescDiv := Alltrim(X5Descri())
			//fWrite(nHandle, cLinha  + cCrLf)
			CDIV:= ADIVCP[XX,1] 
			If Empty(aDivcP[xx,1])
				cDescDiv := "SEM DIVISAO"
			EndIF
		ENDIF	
		cLinha := cDescDiv + ';' + aDivCp[xx,2]+';'+aDivCp[xx,3]+';'+aDivCp[xx,4]+';'+aDivCp[xx,5]+';' +aDivCp[xx,6]+';'
		cLinha := clinha + aDivCp[xx,7]+';'+ aDivCp[xx,8]+ ';' + DtoC(aDivCp[xx,9]) +';' +  Transform(aDivCp[xx,10], "@E 99,999,999,999.99")+";" + alltrim(str(aDivCp[xx,11],1))+';'
		fWrite(nHandle, cLinha  + cCrLf)
	Next       
Endif                     
cLinha:= ''
/*----------------------------------------------------------------------*/
fWrite(nHandle, cLinha  + cCrLf)
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
dbSelectArea("SE1")
dbCloseArea()
ChKFile("SE1")
dbSelectArea("SE1")
dbSetOrder(1)
dbSelectArea("SE2")
dbCloseArea()
ChKFile("SE2")
dbSelectArea("SE2")
dbSetOrder(1)
Return .t.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fDIVISA0  ³ Autor ³ Claudia Cabral  	     ³ Data ³ 15/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar a Divisao de Negocio 			         			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fDIVISAO()											            	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 											            	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function fDIVISAO(l1Elem,lTipoRet)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""

Private aCat:={}

lTipoRet := .T.

l1Elem := If (l1Elem = Nil , .F. , .T.)

cAlias := Alias() 					 // Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

dbSelectArea("SX5")
If dbSeek(cFilial+"00ZX")
   cTitulo := Alltrim(Left(X5Descri(),20))
Endif
If dbSeek(cFilial+"ZX")
	CursorWait()
		While !Eof() .And. SX5->X5_Tabela == "ZX"
			Aadd(aCat,Left(SX5->X5_Chave,1) + " - " + Alltrim(X5Descri()))
			MvParDef+=Left(SX5->X5_Chave,1)                           
			
			dbSkip()
		Enddo
	CursorArrow()
Else
	MsgAlert("Tabela ZX nao encontrada no SX5") // Estou usando situacao Default, nao achei tabela
	aCat :={	"A - DIST.SUDESTE",;	
				"B - DIST.SUL",;	
				"C - SERVICE SONY ERICSSON",;	
				"D - SERVICE NEXTEL",;	
				"E - DIST.DIVERSAS REGIOES",;
				"F - DIST.MOTOROLA",; 
				"G - DIST.SONY ERICSSON",;
				"H - DIST.NORDESTE",;
				"I - DIVERSOS SERVICE",;
				"J - TELEVENDAS",;
				"K - DIST.NORTE",;
				"L - HOLDING",;
				"M - MOBYSHOP/JUDCON",;
				"N - 2WR" ,;   
				"O - AUDIO E VIDEO" ,; 
				"Z - SEM DIVISAO";
				}  	
	MvParDef:="RLIDATBX
	"
	cTitulo :="Divisao de Negocio"
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := mvpar										 // Devolve Resultado
	EndIF
EndIF

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )


User Function VerDivisao(cValida)
Local aValida  := {}   
Local nDiv     := 0
Local cDivisao := " "
aadd(aValida, { 	"A","01" })
aadd(aValida, {	"B","02" })
aadd(aValida, {	"C","03" })
aadd(aValida, {	"D","04" })
aadd(aValida, {	"E","05" })
aadd(aValida, {	"F","06" })
aadd(aValida, { 	"G","07" })
aadd(aValida, {	"H","08" })
aadd(aValida, {	"I","09" })
aadd(aValida, {	"J","10" })
aadd(aValida, {	"K","11" })
aadd(aValida, {	"L","12" })
aadd(aValida, {	"M","13" })
aadd(aValida, {	"N","14" })
aadd(aValida, {	"O","15" })
aadd(aValida, {	"Z"," "  })
				
nDiv := Ascan(aValida, { |X| X[1] = cValida})				
If nDiv > 0    
	cDivisao := aValida[ndiv,2]
EndIF
Return(cDivisao)


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
  AAdd(aRegs,{cPerg,"01","Dt.Referencia   : "        ,""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","Divisao de Negocio : "  ,""   				,""  			,"mv_ch2",	"C",		13      ,0       ,		0 ,		"G"  ,		"u_fdivisao",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"03","Filial de       : "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"04","Filial ate      : "        ,""   				,""  			,"mv_ch4",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"05","Mostra Titulos  : "        ,""   				,""  			,"mv_ch5",	"N",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par05",		"1-Sim"	   ,	""		,		""		,"",		""		,		"2-Nao",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  //AAdd(aRegs,{cPerg,"04","Divisao Neg. de : "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})  
  //AAdd(aRegs,{cPerg,"05","Divisao Neg. ate: "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})  
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