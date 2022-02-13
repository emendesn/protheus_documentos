#INCLUDE "RWMAKE.CH"
#Include "Protheus.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � prodimg  �Autor  �Edson Rodrigurs     � Data �  03/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para salvar os arquivos de imagens de produtos e    ���
���          � sua URL                                                    ���
�������������������������������������������������������������������������͹��
���Projeto   � Integracao Protheus x Mobyshop (Judicon)                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION PRODIMG()

LOCAL cDirectory := ""
LOCAL aArquivos	 := {}    
LOCAL nArq	 := 1                                                   
LOCAL lSelecao         
PRIVATE _ccodpro :=M->B1_COD

u_GerA0003(ProcName())


If !empty(_ccodpro)
   PRIVATE aParamFile:= ARRAY(1)        
   aParamFile[1]:="*.jpg"


  // Exibe a estrutura de diret�rio e permite a sele��o dos arquivos que ser�o processados
  cDirectory 	:= ALLTRIM(cGetFile("Arquivos de Imagens|'"+aParamFile[1]+"'|", 'Importa��o de Imagens', ,'C:\', .T., GETF_OVERWRITEPROMPT +GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.T.))
  aArquivos 	:= Directory(cDirectory+"*.jpg")
  aArquivos 	:= MARKFILE(aArquivos,cDirectory,aParamFile[1],@lSelecao)      
Else
	Aviso('C�digo do Produto nao preenchido','Preencha o c�digo do produto!',{'OK'}) 
  
Endif  
RETURN






//+--------------------------------------------------------------------+
//| Rotina | MARKFILE | Autor | ARNALDO R. JUNIOR  | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Fun��o exemplo para marca��o de m�ltiplos arquivos.       |
//+--------------------------------------------------------------------+
//| Uso    | CURSO DE ADVPL                                            |
//+--------------------------------------------------------------------+

STATIC FUNCTION MARKFILE(aArquivos,cDiretorio,cDriver,lSelecao)

Local aChaveArq	:= {}
Local cTitulo	:= "Imagens para importa��o: "
Local bCondicao	:= {|| .T.}
// Vari�veis utilizadas na sele��o de categorias
Local oChkQual,lQual,oQual,cVarQ
// Carrega bitmaps
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")
// Vari�veis utilizadas para lista de filiais
Local nx        := 0
Local nAchou    := 0
Private nsoma   := 0

//+--------------------------------------------------------------------+
//| Carrega os arquivos do diret�rio no array da ListBox	       |
//+--------------------------------------------------------------------+


For nX := 1 to Len(aArquivos)
	//+--------------------------------------------------------------------+
	//| aChaveArq - Contem os arquivos que ser�o exibidos para sele��o     |
	//+--------------------------------------------------------------------+
	AADD(aChaveArq,{.F.,"00",aArquivos[nX][1],cDiretorio})
Next nX
        


IF len(aChaveArq) > 0
  //+--------------------------------------------------------------------+
  //| Monta tela para sele��o dos arquivos contidos no diret�rio         |
  //+--------------------------------------------------------------------+
  DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628;
  OF oMainWnd PIXEL
  oDlg:lEscClose := .F.
  @ 05,15 TO 125,300 LABEL UPPER(cDriver) OF oDlg  PIXEL
 // @ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Sele��o" SIZE 50, 10;
//  OF oDlg PIXEL;
//  ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),;
//  oQual:Refresh(.F.))
  @ 15,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Ordem","C�digo","Caminho" SIZE;
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
	Aviso('Nenhum Imagem Encontrada','Escolha outro diret�rio!',{'OK'}) 
	M->B1_XIMAGEM:='' 
Endif                       
If !lSelecao
  M->B1_XIMAGEM:='' 
Endif   

RETURN aChaveArq




//+--------------------------------------------------------------------+
//| Rotina | TROCA    | Autor | ARNALDO R. JUNIOR  | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Uso    | CURSO DE ADVPL                                            |
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
//| Rotina | MARCAOK  | Autor | ARNALDO R. JUNIOR  | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Uso    | CURSO DE ADVPL                                            |
//+--------------------------------------------------------------------+
                                  
STATIC FUNCTION MarcaOk(aArray)
Local lRet:=.F.
Local nx:=0  
Local aselimg:={}


// Checa marca��es efetuadas
For nx:=1 To Len(aArray)
	If aArray[nx,1]
		lRet:=.T.
	EndIf
Next nx                   
// Checa se existe algum item marcado na confirma��o
If !lRet
	HELP("SELFILE",1,"HELP","SEL. Imagens","N�o existem imegens marcados",1,0)

Else
   For nx:=1 To Len(aArray)
	If aArray[nx,1]
       AADD(aselimg,{_ccodpro,aArray[nx,1],aArray[nx,2],aArray[nx,3],aArray[nx,4]})              
	EndIf
   Next nx 
   ImgMover(aselimg)
EndIf
Return lRet



static function ImgMover(aselimg)
local _cDirimg  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
local _cDirDest := "\ProdImagens\"
local _lRet     := .f. 
local _csequimg :=""  
Local _cseq:="000" 
lOCAL _curl :="http://189.42.119.146:8083/"

ASORT(aselimg,3)

For nx:=1 To len(aselimg)
  _cDirOri  :=aselimg[nx,5]
  _cNomeArq :=aselimg[nx,4] 
   nDivi    := At(".",_cNomeArq)
  _cNomeArq := Substr( _cNomeArq , 1, nDivi - 1)
  _cseq     := STRZERO(val(_cseq)+1,3)                
  
  _cQuery := " SELECT MAX(ZZC_CODIMG) AS IMAGEM FROM "+ RetSQLName("ZZC")+" (nolock) "
  _cQuery += " WHERE ZZC_FILIAL='"+xFilial("ZZC")+"' AND D_E_L_E_T_='' AND ZZC_CODPRO='"+aselimg[nx,1]+"'"
                      
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"Qryimg",.T.,.T.)                         
  dbSelectArea("Qryimg")                               
  Qryimg->(dbgotop())        
                             
   If !empty(Qryimg->IMAGEM)                                                                                                                         
     _lret :=.f. 
     _csequimg:=ALLTRIM(Qryimg->IMAGEM)
      nDivi    := At(".",_csequimg)
     _cseq     := Substr(_csequimg , nDivi-3, 3)
     _cseq     := STRZERO(val(_cseq)+1,3)
   Endif
   Qryimg->(dbCloseArea())

  If File(  _cDirOri + Alltrim( _cNomeArq )+".jpg" )
	__CopyFile(_cDirOri + Alltrim( _cNomeArq )+".jpg", _cDirimg + _cDirDest +  alltrim(aselimg[nx,1])+'-'+_cseq+".jpg") 
	_lRet := .t.
  EndIf
  reclock("ZZC",.t.)
    ZZC->ZZC_FILIAL  := xFilial("ZZC")
    ZZC->ZZC_CODPRO  := alltrim(aselimg[nx,1])
    ZZC->ZZC_CODIMG  := alltrim(aselimg[nx,1])+'-'+_cseq+".jpg"
    ZZC->ZZC_URLIMG  := _curl+alltrim(aselimg[nx,1])+'-'+_cseq+".jpg"
  msunlock()
next 


return(_lRet)


	