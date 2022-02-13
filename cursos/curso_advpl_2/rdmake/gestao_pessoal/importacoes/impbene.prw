#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"
USER FUNCTION IMPSRN()
Private cPerg := "XIMPFOL"

ValidPerg(cPerg)        
Pergunte(cPerg,.F.)
//³Montagem da tela de processamento.        
DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de tabelas do Gestao de Pessoal") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar as tabelas do Gestao " 
@ 18,018 Say " de Pessoal de acordo com os dados enviados nos arquivos LST. O "    
@ 26,018 Say " arquivo deve estar abaixo do ROOTPATH (\protheus_data)."    
DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || Letabela() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

Static Function Letabela(lEnd)
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
//Local cFile :=  cRootPath + cStartPath + alltrim(MV_PAR01)    
Local cFile :=  cRootPath + alltrim(MV_PAR01)                   
Local nDivi := 0
Local cCodigo := space(15)
Local cDescri := space(60)
Local nValor  := 0
Pergunte(cPerg,.f.)
Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .f.             

u_GerA0003(ProcName())

DbSelectArea("SRN")
DbSetOrder(1)

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
	/* Codigo Vale Transporte */      
	nDivi   := At(";",xBuffer)
	cCodigo := Substr( xBuffer , 1, nDivi - 1 )
	             
	/* Descricao do Vale Beneficio */ 	             
	xBuffer := Substr( xBuffer , nDivi + 1 )
	nDivi   := At(";",xBuffer)    
	cDescri := Substr( xBuffer , 1, nDivi - 1 )
	
	/* Valor do Vale Beneficio */ 	             
	xBuffer := Substr( xBuffer , nDivi + 1 )
	nValor  := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  

       	
   // IF ! SRN->(DbSeek(Xfilial("SRN")+cCodigo))
		Reclock("SRN",.T.)	
		SRN->RN_FILIAL  := XFILIAL("SRN")
		SRN->RN_COD     := cCodigo
		SRN->RN_DESC    := cDescri    
		SRN->RN_VUNIATU := nValor
		SRN->RN_DATVIGE := CTOD('01/01/09')
		MSUnlock()        
//	Endif	
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