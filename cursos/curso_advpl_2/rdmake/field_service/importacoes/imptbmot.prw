#Include "Protheus.ch"
#Include "rwmake.ch"           
#DEFINE OPEN_FILE_ERROR -1  
//#Include "Font.Ch"
//#Include "Colors.ch"
//#Include "cheque.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ IMPTBMOT º Autor ³Edson Rodrigues     º Data ³  01/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Importacao das tabelas auxiliares Motorola.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IMPTBMOT()
MsAguarde({ || IMPORT() }, "Aguarde - Importando Tabelas Auxiliares . . . ")
//MsgRun("Importando Tabelas Auxiliares , Aguarde... ","",{|| CursorWait() , IMPORT() ,CursorArrow() })
Return (.T.)


//+--------------------------------------------------------------------+
//| Rotina | IMPORT    | Autor | Edson Rodrigues   | Data | 01.06.2009 |
//+--------------------------------------------------------------------+
//| Uso    |  BGH  - Seleciona Diretorio e arquivos para importacao    |
//+--------------------------------------------------------------------+
Static Function IMPORT()
LOCAL cDirectory := ""
LOCAL aArquivos	 := {}    
LOCAL nArq	 := 1                                                   
LOCAL lSelecao         
PRIVATE aParamFile:= ARRAY(1)        

u_GerA0003(ProcName())
 aParamFile[1]:="*.dat"
 
//cTipo := "Retorno D4C (*.DAT)        | *.DAT | "
//cTipo += "Todos os Arquivos  (*.*)   | *.*     "

// Exibe a estrutura de diretório e permite a seleção dos arquivos que serão processados
cDirectory 	:= ALLTRIM(cGetFile("Arquivos .dats|'"+aParamFile[1]+"'|", 'Importação arquivos .dats', ,'C:\', .T., GETF_OVERWRITEPROMPT +GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.T.))
aArquivos 	:= Directory(cDirectory+"*.dat")
aArquivos 	:= MARKFILE(aArquivos,cDirectory,aParamFile[1],@lSelecao)      

MSGINFO("Prcesso finalizado com sucesso !")

RETURN



//+--------------------------------------------------------------------+
//| Rotina | MARKFILE  | Autor | Edson Rodrigues   | Data | 01.06.2009 |
//+--------------------------------------------------------------------+
//| Uso    |  BGH - Marca aquivos para importacao                      |
//+--------------------------------------------------------------------+
STATIC FUNCTION MARKFILE(aArquivos,cDiretorio,cDriver,lSelecao)

Local aChaveArq	:= {}
Local cTitulo	:= "Arquivos .dat Motorola para importação: "
Local bCondicao	:= {|| .T.}
// Variáveis utilizadas na seleção de categorias
Local oChkQual,lQual,oQual,cVarQ
// Carrega bitmaps
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")
// Variáveis utilizadas para lista de filiais
Local nx        := 0
Local nAchou    := 0
Private nsoma   := 0
//+--------------------------------------------------------------------+
//| Carrega os arquivos do diretório no array da ListBox	       |
//+--------------------------------------------------------------------+
For nX := 1 to Len(aArquivos)
	//+--------------------------------------------------------------------+
	//| aChaveArq - Contem os arquivos que serão exibidos para seleção     |
	//+--------------------------------------------------------------------+
	AADD(aChaveArq,{.F.,"00",aArquivos[nX][1],cDiretorio})
Next nX
IF len(aChaveArq) > 0
  //+--------------------------------------------------------------------+
  //| Monta tela para seleção dos arquivos contidos no diretório         |
  //+--------------------------------------------------------------------+
  DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628;
  OF oMainWnd PIXEL
  oDlg:lEscClose := .F.
  @ 05,15 TO 125,300 LABEL UPPER(cDriver) OF oDlg  PIXEL
  @ 15,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Ordem","Arquivo","Caminho" SIZE;
  273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh());
  NoScroll OF oDlg PIXEL
  oQual:SetArray(aChaveArq)
  oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),;
  aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
   DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),;
 (lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
  DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End());
  ENABLE OF oDlg
  ACTIVATE MSDIALOG oDlg CENTERED      
  
Else
	Aviso('Nenhum arquivo Encontrado','Escolha outro diretório!',{'OK'}) 
Endif                       

RETURN aChaveArq



//+--------------------------------------------------------------------+
//| Rotina | TROCA    | Autor | Edson Rodrigues    | Data | 01.06.2009 |
//+--------------------------------------------------------------------+
//| Uso    | BGH - Troca marcacao de arquivos                          |
//+--------------------------------------------------------------------+
STATIC FUNCTION Troca(nIt,aArray)

IF !aArray[nIt,1]
	nSoma++      
	aArray[nIt,1] := !aArray[nIt,1]
    aArray[nIt,2] := strzero(nSoma,2)
ELSE
    aArray[nIt,1] := !aArray[nIt,1]
    aArray[nIt,2] := "00"
EndIf    

Return aArray



//+--------------------------------------------------------------------+
//| Rotina | MARCAOK  | Autor | Edson Rodrigues    | Data | 01.06.2009 |
//+--------------------------------------------------------------------+
//| Uso    | BGH - Seleciona os arquivos marcados                      |
//+--------------------------------------------------------------------+
                                  
STATIC FUNCTION MarcaOk(aArray)
Local lRet:=.F.
Local nx:=0  
Local aselarq:={}
// Checa marcações efetuadas
For nx:=1 To Len(aArray)
	If aArray[nx,1]
		lRet:=.T.
	EndIf
Next nx                   
// Checa se existe algum item marcado na confirmação
If !lRet
	HELP("SELFILE",1,"HELP","SEL. Imagens","Não existem arquivos marcados",1,0)

Else
   For nx:=1 To Len(aArray)
	If aArray[nx,1]
       AADD(aselarq,{".dat",aArray[nx,1],aArray[nx,2],aArray[nx,3],aArray[nx,4]})              
	EndIf
   Next nx 
   tratarq(aselarq)
EndIf
Return lRet


//+--------------------------------------------------------------------+
//| Rotina | tratarq  | Autor | Edson Rodrigues    | Data | 01.06.2009 |
//+--------------------------------------------------------------------+
//| Uso    | BGH - Trata os arquivos selecionados                      |
//+--------------------------------------------------------------------+
static function tratarq(aselarq)
local _cDirarq  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
local _cDirDest := "\relato\mclaims\arqdat\"
local _lRet     := .f. 
local _csequimg :=""  
Local _cseq:="000" 

For nx:=1 To len(aselarq)
  _cDirOri  :=aselarq[nx,5]
  _cNomeArq :=aselarq[nx,4] 
   cFile     := ""
  
  If File( _cDirOri + Alltrim(_cNomeArq))
	__CopyFile(_cDirOri + Alltrim(_cNomeArq),_cDirarq + _cDirDest +_cNomeArq) 
	cFile :=  _cDirarq + _cDirDest +  _cNomeArq  
    _lRet := .t.      
     //
     ValArq(cFile,_cNomeArq)
  EndIf
next 
return(_lRet)


//+--------------------------------------------------------------------+
//| Rotina | ValArq  | Autor | Edson Rodrigues    | Data | 01.06.2009  |
//+--------------------------------------------------------------------+
//| Uso    | BGH - Valida e Grava os dados dos arquivos em suas        |
//|        | Respectivas tabelas.                                      |
//+--------------------------------------------------------------------+
Static function ValArq(cFile,_cNomeArq) 
Local ntipo:=0
Local CTAB:=""       
dbselectarea("SX5")
dbsetorder(1)

If FT_FUSE( cfile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " nao encontrado!. Verifique se existe esse arquivo no caminho mencionado")   
	Return
Endif                                                         	

Do CASE 
   CASE _cNomeArq =='CUSTOMER_COMPLAINTS.DAT'//Cadastro Reclamacao do Cliente
       CTAB:="W4"  
   CASE _cNomeArq =='PROBLEMS.DAT'           //Codigo de Problemas Encontrado
	   CTAB:="W7"
   CASE _cNomeArq =='REPAIR_ACTIONS.DAT'     //Codigo de Acao do Reparo
       CTAB:="W8"
   CASE _cNomeArq =='REPAIR_STATUS.DAT'      //Codigo do Status do Reparo
	   CTAB:="W3"                                                 
   CASE _cNomeArq =='PROD_CODES.DAT'         //Codigo APC COD Produto
	   CTAB:="W2" 	   
   CASE _cNomeArq =='TRANSACTION_CODES.DAT'  //Codigo da Transacao
	   CTAB:="W5" 
   CASE _cNomeArq =='FAULT_CODES.DAT'        //Codigo de falha da peça
	   CTAB:="WA"                            
   CASE _cNomeArq =='REF_DESIGNATORS.DAT'    //Ref. Designator
	   CTAB:="W9" 	  
	   //Conforme solicitação do Edson, foi criado tabela ZZW para tratar Ref. Designator
	   Processa({|| ATUZZW() },"Atualizando tabela ZZW...")
   OtherWise
	  CTAB:=""  
ENDCASE

If !empty(CTAB) .AND. CTAB <> "W9"
	ProcRegua( FT_FLASTREC() )
	
	While !FT_FEOF() .AND. !EMPTY(CTAB)            
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lˆ linha do arquivo retorno ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer := FT_FREADLN()
		ccodigo := cdescri := ""
		_altincl:=.t.
		IncProc()                   
		
		/* Codigo */
		nDiv1   := At('"',xBuffer) 
		nDiv2   := AT(',',xBuffer) 
		ccodigo := Substr( xBuffer , nDiv1 + 1, nDiv2 - 3)
			       
	
	    /*Descricao*/
	    xBuffer  := Substr(xBuffer , nDiv2+1) 
	    nDiv1   := At('"',xBuffer) 
		nDiv2   := AT('"',substr(xBuffer,ndiv1+1)) 
	    cdescri := Substr( xBuffer , nDiv1 + 1, nDiv2 - 1)	
		
		if !SX5->(DBSeek(xFilial('SX5')+CTAB+ccodigo))
			RecLock('SX5',.T.)
			_altincl:=.f.
		ELSE
			RecLock('SX5',.F.)
		ENDIF
		SX5->X5_FILIAL  := xFilial('SX5')
		SX5->X5_TABELA  :=UPPER(CTAB)
		SX5->X5_CHAVE   :=Upper(ccodigo)
		IF !ALLTRIM(LEFT(_cNomeArq,8)) $ "TRANSACT/CUSTOMER"
		   SX5->X5_DESCRI  :=Upper(cdescri)
	       SX5->X5_DESCSPA :=Upper(cdescri)  
	       SX5->X5_DESCENG :=Upper(cdescri)
		  
		ELSE
		   SX5->X5_DESCSPA :=Upper(cdescri)  
	       SX5->X5_DESCENG :=Upper(cdescri)
		ENDIF  
	   MsUnlock('SX5') 
	FT_FSKIP()	
	ENDDO                               
Endif
Return(.T.)

Static Function ATUZZW()  

ProcRegua( FT_FLASTREC() )

While !FT_FEOF() 
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := FT_FREADLN()
	ccodigo := cdescri := cEstorno := ""
	
	IncProc()                   
	
	ccodigo  := substr(xBuffer,at('"',xBuffer)+1,At(',',xBuffer)-3)
	xBuffer  := substr(xBuffer,At(',',xBuffer)+1,len(xBuffer))
    cdescri  := substr(xBuffer,at('"',xBuffer)+1,At(',',xBuffer)-3)
    xBuffer  := substr(xBuffer,At(',',xBuffer)+1,len(xBuffer))
    cEstorno := substr(xBuffer,at('"',xBuffer)+1,len(xBuffer)-2)
	
	
	dbSelectArea("ZZW")
	dbSetOrder(1)
	If !ZZW->(DBSeek(xFilial('ZZW')+ccodigo))
		RecLock('ZZW',.T.)
		ZZW->ZZW_FILIAL  := xFilial('ZZW')
	ELSE
		RecLock('ZZW',.F.)
	ENDIF
	
	ZZW->ZZW_CODIGO   :=Upper(ccodigo)
	ZZW->ZZW_DESCRI   :=Upper(cdescri)
    ZZW->ZZW_SOLEST   :=Upper(cEstorno)  
    MsUnlock('ZZW') 
   	FT_FSKIP()	
ENDDO                               
Return(.T.)