#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION IMPTABPRE()
Private cPerg := "XCCMNT"                   
Private cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
Private cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Private _ccaminho  :=cRootPath+cStartPath


u_GerA0003(ProcName())

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)
//³Montagem da tela de processamento.        
DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de tabela de precos") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar as tabelas de precos" 
@ 18,018 Say " de acordo com os dados enviados nos arquivos CSV. O arquivo "    
@ 26,018 Say " deve estar no :" +_ccaminho+"."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || u_Letabpre() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

User Function Letabpre(lEnd)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
Local cFile :=  cRootPath + cStartPath + alltrim(MV_PAR01)    
Local LPrim := .T.
Local cCodTab    :=Space(03)
Local cDescri    :=Space(30)
Local dDataIni   := Date()
Local dDataFim   := Date()
Local cHoraDe    := space(05)
Local cHoraAte   := space(05) 
Local cCondPag   := space(03)
Local cAtivo     := space(01)
Local cTpHora    := space(01)
Local cProd      := space(15)
Local nPrecoVen  := 0
Local nValorDes  := 0
Local nPerDes    := 0
Local cAtivoItem := space(01)
Local cUF        := space(02)
Local cTpOper    := space(01)
Local nQtLote    := 0
Local nMoeda     := 1
Local dDataVig   := Date()
Local nDivi := 0
Local cstring := ""    
Local cItem := StrZero( 0, TamSX3("DA1_ITEM")[1] ) 
Pergunte(cPerg,.f.)
Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .f.             

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")   
	Return
Endif                                                         	

ProcRegua( FT_FLASTREC() )
lPrim := .t.    
While !FT_FEOF()
	lMsErroAuto := .F. 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := FT_FREADLN()
	
	IncProc()     
	/* codigo da tabela */
	nDivi   := At(";",xBuffer)
	cCodTab := Substr( xBuffer , 1, nDivi - 1)
	If len(alltrim(cCodTab)) < 3
		cCodTab := Replicate("0", 3-(len(alltrim(cCodTab)))) + alltrim(cCodTab)
	endif	
	
	/* descricao da tabela */	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cDescri := Substr(xBuffer,1,  nDivi - 1)
	
	/* Data de inicio de vigencia da tabela */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	dDataIni := Ctod(Substr(xBuffer,1,  nDivi - 1))  
	
	/* Hora de Inicio de Vigencia da tabela */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cHoraDe := Substr(xBuffer,1,  nDivi - 1)
	
	/* Hora de termino de vigencia da tabela*/ 
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cHoraAte := Substr(xBuffer,1,  nDivi - 1)
	
	/* Condicao de pagamento*/
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cCondPag := Substr(xBuffer,1,  nDivi - 1)
	
	/* Tabela Ativa */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cAtivo  := Substr(xBuffer,1,  nDivi - 1)
	
	/* Tipo de Hora */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	CTpHora := Substr(xBuffer,1,  nDivi - 1)
	
	/* Produto*/ 	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cProd   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Preco de venda */
	xBuffer   := Substr(xBuffer , nDivi+1)  
	nDivi     := At(";",xBuffer) 
	nprecoVen := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* Valor do Desconto */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nValorDes := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* Percentual do Desconto */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nPerDes := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* Item Ativo  */
	xBuffer    := Substr(xBuffer , nDivi+1)  
	nDivi      := At(";",xBuffer) 
	cAtivoItem := Substr(xBuffer,1,  nDivi - 1)
	
	/* UF */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nUF     := Substr(xBuffer,1,  nDivi - 1)
	
	/* Tipo de Operacao */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cTpOper := Substr(xBuffer,1,  nDivi - 1)
	
	/* Lote maximo*/
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nQtLote := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* Moeda */	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nMoeda  := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),".",""))  
	
	/* Data de vigencia */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	dDataVig := CTOD(Substr(xBuffer,1,  nDivi - 1))  
		
	If LPrim // grava a Capa da tabela de Precos       
		DA0->(DBSETORDER(1))	
		IF ! DA0->(DbSeek(Xfilial("DA0")+cCodTab))
			Reclock("DA0",.T.)	
			DA0->DA0_FILIAL := XFILIAL("DA0")
			DA0->DA0_CODTAB := cCodTab
			DA0->DA0_DESCRI := cDescri    
			DA0->DA0_DATDE  := dDataIni
			DA0->DA0_HORADE := cHoraDe
			DA0->DA0_HORATE := cHoraAte
			DA0->DA0_CONDPG := cCondPag
			DA0->DA0_ATIVO  := cAtivo
			DA0->DA0_TPHORA := cTpHora			
			MsUnlock()
		EndIF
		lPrim := .f.
	EndIF 
   	DA1->(DBSETORDER(3))    
    cItem := Soma1(cItem, TamSX3("DA1_ITEM")[1])	                   
    IF ! DA1->(DbSeek(Xfilial("DA1")+cCodTab+cItem))
		Reclock("DA1",.T.)	
		DA1->DA1_FILIAL  := XFILIAL("DA0")
		DA1->DA1_CODTAB  := cCodTab         
		DA1->DA1_ITEM    := cItem
		DA1->DA1_CODPROD := cProd
		DA1->DA1_PRCVEN  := NPrecoVen		
		DA1->DA1_VLRDES  := nValorDes
		DA1->DA1_PERDES  := nPerDes
		DA1->DA1_ATIVO   := cAtivoItem
		DA1->DA1_ESTADO  := cUF
		DA1->DA1_TPOPER  := cTpOper
		DA1->DA1_QTDLOT  := 999999.99
		DA1->DA1_MOEDA   := nMoeda
		DA1->DA1_DATVIG  := dDataVig
		MsUnlock()
	EndIF
	FT_FSKIP()
EndDo	
MSGSTOP("Processo de importacao finalizado")   
Return       


/*
Funcao para criacao da pergunta, caso a mesma nao exista
*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta                      /Pergunta Espanhol/Pergunta Ingles/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AAdd(aRegs,{cPerg,"01","Arq.CSV p/importar:"        ,"Arq.CSV p/importar:"   ,"Arq.CSV p/importar:"  ,"mv_ch1","C",40,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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

Return