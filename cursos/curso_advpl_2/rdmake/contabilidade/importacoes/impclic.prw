#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION IMPCLIC()

DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de conta contabil do cliente") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar as contas contabeis " 
@ 18,018 Say " dos clientes de acordo com os dados enviados no arquivo CSV"    
@ 26,018 Say " O arquivo deve estar abaixo do ROOTPATH (\protheus_data)."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || Letabela() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
//DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

Static Function Letabela(lEnd)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
Local cFile :=  cRootPath + cStartPath + "clientes.csv"         
Local nDivi := 0
Local lfindforn := .f.            
Local cConta := ''
Local cConta2 := ''    
Local cNome   := ''
Local cNreduz := ''
//Local cFile :=  cRootPath + alltrim(MV_PAR01)
Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .f.    

u_GerA0003(ProcName())         

ValidPerg()    
Pergunte(cPerg,.f.)

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
	SA1->(DBSETORDER(1))    
	IF !SA1->( MsSeek( XFilial("SA1") + cCod) )
		If len(alltrim(cCod)) < 6
			cCod := Replicate("0", 6-(len(alltrim(cCod)))) + alltrim(cCod)
		endif	         
		IF SA1->( MsSeek( XFilial("SA1") + cCod) )                       
			lFindForn := .t.	
		Endif
	Else	
		lFindForn := .t.	
	endif	 
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cNome    := Substr(xBuffer,1,  nDivi - 1)  
			
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cNreduz  := Substr(xBuffer,1,  nDivi - 1)  
			
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	cConta   := Substr(xBuffer,1) 	                
	If lFindForn        
		Do while ! SA1->(Eof()) .and. SA1->A1_COD = cCod
	   		Reclock("SA1",.F.)	
	   		SA1->A1_NOME   :=  cNome
	   		SA1->A1_NREDUZ :=  cNReduz
			SA1->A1_CONTA  :=  cConta
			MsUnlock()
			SA1->(DbSkip())
		EndDo	
		lFindForn := .F.
	EndIF
	FT_FSKIP()
EndDo	
// PESSOA FISICA 1120199999         
SA1->(DbGotop())
cConta := "1120199999"
Do while ! SA1->(Eof())
	If SA1->A1_PESSOA = 'F'	
		Reclock("SA1",.F.)	
		SA1->A1_CONTA  :=  cConta
		MsUnlock()
	EndIf	
	SA1->(DbSkip())	
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