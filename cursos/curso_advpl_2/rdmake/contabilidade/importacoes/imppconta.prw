#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION IMPPCONTA()

DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de conta contabil do cliente") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar o plano de contas  " 
@ 18,018 Say " contabeis de acordo com os dados enviados no arquivo CSV"    
@ 26,018 Say " O arquivo deve estar abaixo do ROOTPATH (\protheus_data)."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || Letabela() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
//DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

Static Function Letabela(lEnd)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
Local cFile :=  cRootPath + cStartPath + "contas.csv"         
Local nDivi := 0
Local cNome   := ''
Local cClasse := ''
Local CCond := ''
Local cBloq := ''
Local dDataIni := ctod('')
Local cCtaIni := ''
Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .f.   

u_GerA0003(ProcName())          

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!")   
	Return
Endif                                                         	

ProcRegua( FT_FLASTREC() )
While !FT_FEOF()
	lMsErroAuto := .F. 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := FT_FREADLN()
	
	IncProc()     
	/* CODIGO */
	nDivi   := At(";",xBuffer)
	cCod    := Substr( xBuffer , 1, nDivi - 1)
	CT1->(DBSETORDER(1))    
	IF !SA1->( MsSeek( XFilial("CT1") + cCod) )
	
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		cNome    := Substr(xBuffer,1,  nDivi - 1)  
		       
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		cClasse  := Substr(xBuffer,1,  nDivi - 1)  
		
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		cCond    := Substr(xBuffer,1,  nDivi - 1)  
		
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		cBloq    := Substr(xBuffer,1,  nDivi - 1)  
		
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		dDataIni := CtoD(Substr(xBuffer,1,  nDivi - 1))
		
		xBuffer  := Substr(xBuffer , nDivi+1)  
		nDivi    := At(";",xBuffer) 
		cCtaIni  := Substr(xBuffer,1)  
		
   		Reclock("CT1",.T.)
   		CT1->CT1_FILIAL  := XFILIAL("CT1")	
   		CT1->CT1_CONTA   := cCOD
   		CT1->CT1_DESC01  := cNome
   		CT1->CT1_CLASSE  := cClasse
		CT1->CT1_NORMAL  := cCond
		CT1->CT1_BLOQ    := cBloq
		CT1->CT1_DTEXIST := dDataIni
		CT1->CT1_CTASUP  := cCtaIni
		MsUnlock()

	EndIF
	FT_FSKIP()
EndDo  
Reclock("CT1",.T.)
CT1->CT1_FILIAL  := XFILIAL("CT1")	
CT1->CT1_CONTA   := "1120199999"
CT1->CT1_DESC01  := "CLIENTE PESSOA FISICA"
CT1->CT1_CLASSE  := cClasse
CT1->CT1_NORMAL  := cCond
CT1->CT1_BLOQ    := cBloq
CT1->CT1_DTEXIST := dDataIni
CT1->CT1_CTASUP  := cCtaIni	  
MsUnlock()
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
AAdd(aRegs,{cPerg,"01","Arq.LST p/importar:"        ,"Arq.CSV p/importar:"   ,"Arq.CSV p/importar:"  ,"mv_ch1","C",70,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
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