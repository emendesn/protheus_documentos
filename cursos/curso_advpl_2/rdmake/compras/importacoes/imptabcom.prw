#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION IMPTABCOM()
Private cPerg := "XTABCO"

	u_GerA0003(ProcName())

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)
//³Montagem da tela de processamento.        
DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de tabela de precos MOL") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar as tabelas de precos" 
@ 18,018 Say " de acordo com os dados enviados nos arquivos CSV. "    
//@ 26,018 Say " deve estar na sua o ROOTPATH (\system)."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || Letabpre() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

Static Function Letabpre(lEnd)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
//Local cFile :=  cRootPath + cStartPath + alltrim(MV_PAR01)    
Local cFile :=  alltrim(MV_PAR01)    
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
Local cfornec    := space(6)
Local cLoja      := space(2)
Local dDataVig   := Date()
Local nDivi := 0
Local cstring := ""    
Local cItem := StrZero( 0, TamSX3("AIB_ITEM")[1] ) 
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
	/* codigo da Fornecedor */
	nDivi   := At(";",xBuffer)
	cFornec := Substr( xBuffer , 1, nDivi - 1)
	If len(alltrim(cCodTab)) < 6
		cFornec := alltrim(cFornec) + Replicate(" ", 6-(len(alltrim(cFornec))))
	ENDIF
	
	/* Loja do fornecedor */	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cLoja := Substr(xBuffer,1,  nDivi - 1)
	
	
	
	/* codigo da tabela */                
	xBuffer := Substr(xBuffer , nDivi+1)  
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
	
	/* Produto*/ 	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cProd   := Substr(xBuffer,1,  nDivi - 1)
	
	/* Preco de compra */
	xBuffer   := Substr(xBuffer , nDivi+1)  
	nDivi     := At(";",xBuffer) 
	nprecoVen := Val(STRTRAN(Substr(xBuffer,1),",","."))  
	
	If LPrim // grava a Capa da tabela de Precos       
		AIA->(DBSETORDER(1))	
		IF ! AIA->(DbSeek(Xfilial("AIA")+ cFornec + cLoja + cCodTab))
			Reclock("AIA",.T.)	
			AIA->AIA_FILIAL := XFILIAL("AIA")
			AIA->AIA_CODFOR := cFornec
			AIA->AIA_LOJFOR := cLoja
			AIA->AIA_CODTAB := cCodTab
			AIA->AIA_DESCRI := cDescri    
			AIA->AIA_DATDE  := dDataIni
			MsUnlock()
		EndIF
		lPrim := .f.
	EndIF 
   	AIB->(DBSETORDER(2))    
    cItem := Soma1(cItem, TamSX3("AIB_ITEM")[1])	                   
    IF ! AIB->(DbSeek(Xfilial("AIB")+cFornec+cLoja+cCodTab+cProd))
		Reclock("AIB",.T.)	
		AIB->AIB_FILIAL  := XFILIAL("AIB")
		AIB->AIB_CODFOR  := cfornec
		AIB->AIB_LOJFOR  := cLoja         
		AIB->AIB_CODTAB  := cCodTab
		AIB->AIB_ITEM    := cItem
		AIB->AIB_CODPRO  := cProd
		AIB->AIB_PRCCOM  := NPrecoVen		
		AIB->AIB_QTDLOT  := 999999.99
		//AIB->AIB_MOEDA   := nMoeda
		AIB->AIB_DATVIG  := dDataVig
		MsUnlock()   
	else                    
		Reclock("AIB",.f.)	
		AIB->AIB_PRCCOM  := NPrecoVen	
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