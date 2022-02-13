#DEFINE OPEN_FILE_ERROR -1      
#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPTABPEC º Autor ³ Luiz Ferreira      º Data ³  25/11/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTACAO TABELA DE PRECOS RENTABILIDADE POR PRODUTO      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FAT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION IMPTABPEC()
Private cPerg := "XIMPPE"

u_GerA0003(ProcName())

DBSELECTAREA("Z10")
ValidPerg(cPerg)        
Pergunte(cPerg,.F.)
//Montagem da tela de processamento.        
DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Importacao de tabela de precos") FROM  200,1 TO 380,380 PIXEL
@ 10,018 Say " Este programa tem como objetivo importar as tabelas de Rentabilidade" 
@ 18,018 Say " de acordo com os dados enviados nos arquivos CSV "    

DEFINE SBUTTON FROM 65,096 TYPE 1 ACTION Processa( { || u_imppec() } ) ENABLE OF oLeTxt
DEFINE SBUTTON FROM 65,126 TYPE 2 ACTION oLetxt:End() ENABLE OF oLeTxt    
//DEFINE SBUTTON FROM 65,156 TYPE 5 ACTION Pergunte(cPerg, .t.)   ENABLE OF oLeTxt    
Activate Dialog oLeTxt Centered
Return

User Function imppec(lEnd)

Local LPrim := .T.
Local cFabric    := ""
Local cProd      := ""
Local cMode      := ""
Local nPrecobr   := 0
Local nPerctip   := 0
Local nPercicm   := 0
Local nPercimp   := 0
Local nRebat     := 0
Local nValipi    := 0
Local nValicm    := 0
Local nValimp    := 0
Local nCaqui     := 0
Local ddata      := ""

//Pergunte(cPerg,.f.)
Private lMsHelpAuto := .F. // para mostrar os erro na tela             
Private lMsErroAuto := .f.             

// Abre o arquivo CSV gerado pelo Excel do cliente
_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
_cExcelCSV := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cExcelCSV)                         
	Aviso("Cancelada a Seleção!","Voce cancelou a seleção do arquivo.",{"Ok"})
	Return
Endif
if !file(_cExcelCSV)
	return
else
	CpyT2S(_cExcelCSV,"\RELRENT\")
endif       

_clocalArq := alltrim(_cExcelCSV)
_nPos     := rat("\",_clocalArq)
if _nPos > 0
	_cNomeArq := substr(_clocalArq,_nPos+1,len(_clocalArq)-_nPos)
endif

cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )  
__CopyFile(_clocalArq, cRootPath + "\RELRENT\"+alltrim(_cNomeArq))             
cFile :=  cRootPath +"\RELRENT\"+ alltrim(_cNomeArq)    


//Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
//Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )    
//Local cFile :=  cRootPath + cStartPath + alltrim(MV_PAR01)     



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
	/* fabricante da tabela */
	nDivi   := At(";",xBuffer)
	cFabric := Substr( xBuffer , 1, nDivi - 1)
    cFabric := Substr(xBuffer,1,  nDivi - 1)
	
	/* produto da tabela */	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cProd   := Substr(xBuffer,1,  nDivi - 1)
	
	/* modelo da tabela */	
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	cMode   := Substr(xBuffer,1,  nDivi - 1)
	
	/* preco bruto da tabela */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nPrecobr := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",",".")) 
	
	/* percentual  de ipi da tabela */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nPerctip := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))
	
	/* percetual de icm da tabela*/ 
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nPercicm := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))
	
	/* percetual de PIS\CONFINS */
	xBuffer  := Substr(xBuffer , nDivi+1)  
	nDivi    := At(";",xBuffer) 
	nPercimp := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))
	
	/* valor de rebate */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nRebat  := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* valor de IPI */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nValipi := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* valor de icms */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nValicm := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* valor pis\cofins */
	xBuffer   := Substr(xBuffer , nDivi+1)  
	nDivi     := At(";",xBuffer) 
	nValimp   := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
	
	/* custo de aquis  da tabela */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nCaqui  := Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))  
		
	/* data de lancto da tabela */
	xBuffer := Substr(xBuffer , nDivi+1)  
	nDivi   := At(";",xBuffer) 
	nDivi   := iif(nDivi == 0, len(alltrim(xBuffer))+1, nDivi)
	ddata   := CTOD(Substr(xBuffer,1,  nDivi - 1)) 

		
	   Z10->(DBSETORDER(2))	 // Z10_FILIAL+Z10_FABRIC+Z10_COD+DTOS(Z10_DATA)                                                                                                                    
		IF ! Z10->(DbSeek(xFilial("Z10") + cFabric + cProd + DTOS(dData)))  
			Reclock("Z10",.T.)	
			Z10->Z10_FILIAL  :=  xFilial("Z10")
			Z10->Z10_FABRIC  :=  cFabric    //FABRICANTE
			Z10->Z10_COD     :=  cProd      //PRODUTO
			Z10->Z10_MODELO  :=  cMode      //MODELO   
			Z10->Z10_TOTAL   :=  nPrecobr   //PRECO BRUTO
			Z10->Z10_IPI     :=  nPerctip   //PERCENT IPI
			Z10->Z10_ICM     :=  nPercicm   //PERCENT ICM
			Z10->Z10_ALQIMP  :=  nPercimp   //PERCENT PIS\COFINS
			Z10->Z10_REBAT   :=  nRebat     //REBATE
			Z10->Z10_VALIPI  := (nPrecobr * nPerctip)    //VALOR IPI			
			Z10->Z10_VALICM  := -(Z10_TOTAL - Z10_VALIPI) * (1 - Z10_ICM) + (Z10_TOTAL-Z10_VALIPI) //  =-(BRUTO-IPI)*(1-0,0925)+(BRUTO-IPI)
			Z10->Z10_VALIMP  := -(Z10_TOTAL - Z10_VALIPI) * (1-Z10_ALQIMP)+ (Z10_TOTAL-Z10_VALIPI) //  =-(BRUTO-IPI)*(1-0,07)  +(BRUTO-IPI)
    		Z10->Z10_VALCUS  :=  (Z10_TOTAL - Z10_VALICM - Z10_VALIMP - Z10_REBAT)   //CUSTO DE AQUISICAO
 			Z10->Z10_DTIMPU  := ddata      //DATA    			
 			Z10->Z10_EMISSA  := dDataBase
			MsUnlock()
	   
	    ELSE
          MSGALERT("Arquivo de Importação já utilizado Produto e data iguais")   
           return
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