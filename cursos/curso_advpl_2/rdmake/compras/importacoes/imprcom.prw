#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPTABPRE  บAutor  ณDeltaDecisao        บ Data ณ  13/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ao Tabela de Preco de Compras em Planilha Excel    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPRCOM()

Private cPerg	:= "IMPTABPR"
Private nOpca 	:= 0

u_GerA0003(ProcName())

ValidPerg() // Ajusta as Perguntas do SX1

If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return
EndIf


DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Importa็ใo Tabela de Pre็o") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina realiza a importa็ใo de Planilha Excel Com  os dados do Tabela de Pre็o") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("De Compras") SIZE 268, 8 OF oDlg PIXEL
@ 48, 15 SAY OemToAnsi("Para isto, o caminho de  localiza็ใo da Planilha deve ser informado nos Parametros") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	MsAguarde({|| fImpExcel()},OemtoAnsi("Aguarde Efetuando Importa็ใo da Planilha"))
EndIf

If Select("TRB")<>0
	TRB->(DbCloseArea())
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPEXCEL บAutor  ณDeltaDecisao        บ Data ณ  14/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta planilha Tabela de Pre็o                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH      	                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FImpExcel()
 

//////////////////////////////////////// continuar a partir daqui ///////////////////////////////////////////////////////////
Local _cNumPVPro   := ""
Local _cNumPVSer   := ""
//Local nHdl 	   	   := ExecInDLLOpen('C:\dll\readexcel.dll')
Local cCamDLL      := Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
Local nHdl	 	   := ExecInDLLOpen(cCamDLL)
Local cBuffer	   := ""
Local cDir		   := Alltrim(MV_PAR01)
Local cArq		   := Alltrim(MV_PAR02)
Local _cDescTab	   := Alltrim(MV_PAR03)
Local _dVigIni	   := MV_PAR04
Local _dVigFim	   := MV_PAR05      
Local _cCodFor	   := MV_PAR06
Local _cLojFor	   := MV_PAR07    
Local _cCondPg     := MV_PAR08
Local _nMoeda      := IIF(MV_PAR09>0,MV_PAR09,1)
Local _nQtdLin 	   := 70000
Local _nDecimal    := TamSX3("AIB_PRCCOM")[2]  

Private _aCelulas  := {}
Private cAlias     := "TMP"
Private _cLinPlan  := 2
Private _cArqLog   := CriaTrab(,.F.)+".TXT"
Private _nHdlLog   := 0
Private _cQuebra   := Chr(13)+Chr(10)
Private _lErro	   := .F.
Private _lPriErr   := .T.
Private _aCabTab   := {}
Private _aIteTab   := {}


// Valida Existencia do Fornecedor
DbSelectArea("SA2")
DbSetOrder(1)
If !DbSeek(xFilial("SA2")+_cCodFor+_cLojFor,.F.)
   MsgAlert("Fornecedor Inexistente")
   Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua ajuste no Parametro de Diretorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Right(Alltrim(cDir),1) <>'\'
	cDir := Alltrim(cDir)+"\"
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua Ajuste na Variavel de Nome do Arquivo  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Right(Alltrim(cArq),5) <>'.XLSX' .AND. Right(Alltrim(cArq),4) <>'.XLS'
	cArq := Alltrim(cArq)+".XLSX"
Endif
cFile   := cDir+cArq

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Elementos da Matriz _aCelula										|
//|																	|
//|1o.-> Variavel do Programa										|
//|2o.-> Coluna da Planilha											|
//|3o.-> Linha da Planilha											|
//|4o.-> Tipo do dado a ser Gravado( Caracter,Numerico,Data)		|
//|5o.-> Tamanho do Dado a Ser Gravado								|
//|6o.-> Casas decimais do dado a ser Gravado						|
//|																	|
//| TamSX3("B2_QATU")[1] Tamanho										|
//| TamSX3("B2_QATU")[2] Decimal                                     |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem das Celulas   		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(_aCelulas,{'CODIGO ',"A",2,'C',TamSX3("B1_COD")[1],0}) 
AADD(_aCelulas,{'PRECO  ',"B",2,'N',14,_nDecimal}) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se Conseguiu efetuar a Abertura do Arquivo    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If ( nHdl >= 0 )    
    
	// Carrega o Excel e Abre o arquivo
	
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
	If ( nBytes < 0 )                    
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Nใo foi possํvel abrir o arquivo : ' + cFile)
		Return
	ElseIf ( nBytes > 0 )                     
		// Erro critico na abertura do arquivo com msg de erro
		MsgStop(Subs(cBuffer, 1, nBytes))		
		Return
	EndIf                           
	
	// Seleciona a worksheet
	cBuffer := "IMPORTAR" + Space(512)
	ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)   
	_nSomaLin	:= 0 
	For _nElem		:= 1 To _nQtdLin
		MsProcTxt("Proc.Linha: "+StrZero(_nElem,6))
		// Variaveis da Planilha
		_cProduto	:= LERPLAN(nHdl,'_aCelulas',01,_nSomaLin)
		_nPreco		:= LERPLAN(nHdl,'_aCelulas',02,_nSomaLin)
		_nSomaLin++	
		// Abandona importacao pois esta na ultima Linha
		If Empty(_cProduto)
		   Exit
		Endif
		// Localiza o Codigo do Produto
        _cMsgErro  := " "
        _lGrava	   := .T.
        DbSelectarea("SB1")
        DbSetOrder(1)
        If ! DbSeek(xFilial("SB1")+_cProduto,.F.)
           _cMsgErro := "Produto Nao Localizado -> "+_cProduto
           _lGrava   := .F.
        Endif
        // Verifica se Valor Esta Zerado
        If _lGrava
           If _nPreco <= 0
              If _nPreco == 0
                 _cMsgErro := "Produto Com Valor Zerado   " + _cProduto
              Else
                 _cMsgErro := "Produto Com Valor Negativo " + _cProduto
              Endif
              _lGrava := .F.
           Endif
        Endif      
        If _lGrava
           If Len(_aCabTab) == 0  // Pega Nova Tabela Apenas se for o Primeiro Registro
              _cTabela   := ProxTab(_cCodFor,_cLojFor)
           Endif
           AtuTabPre(_cTabela,_cCodFor,_cLojFor,_cProduto,_nPreco,_cCondPg,_cDescTab,_dVigIni,_dVigFim,_nMoeda)
        Else
           If ! _lErro // Primeiro Erro, deve criar o Arquivo
              _nHdlLog := Fcreate(_cArqLog,0)                
              fWrite(_nHdlLog," ** INCONSISTENCIAS IMPORTACAO TABELA DE PRECO ******* "+_cQuebra)
              fWrite(_nHdlLog,_cQuebra)
              _lErro := .T.
           Endif
           Fwrite(_nHdlLog,_cMsgErro+_cQuebra)
        Endif
	Next _nElem
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)	
	ExecInDLLClose(nHdl)	
Else
    MsgStop('Nao foi possivel carregar a DLL')
EndIf 

// Grava Tabela De Preco dos registros que nใo Possuem Erros
If Len(_aCabTab) > 0
   MsProcTxt(OemToAnsi("Aguarde...Gravando Tabela de Pre็o"))
	// Gravacao do Pedido de Venda 
	lMSErroAuto	:= .F.
	lMSHelpAuto	:= .F.
	MSExecAuto({|x,y,z|Coma010(x,y,z)},3,_aCabTab,_aIteTab)
	If lMsErroAuto
		Mostraerro()
	Else
	  // Atualiza็ใo Cadastro Amarra็ใo do Produto x Fornecedor
	  For _nElemIt := 1 To Len(_aIteTab)
	      _cCodPro := _aIteTab[_nElemIt][01][02]
	      DbSelectArea("SA5")
	      DbSetOrder(1)
	      If DbSeek(xFilial("SA5")+_cCodFor+_cLojFor+_cCodPro,.F.) 
	         RecLock("SA5",.F.)
	           SA5->A5_CODTAB	:= _cTabela
	         msUnlock()  
	      Else
	       	 _cNomeFor := Posicione("SA2",1,xFilial("SA2")+_cCodFor+_cLojFor,"A2_NOME")
	       	 _cNomePro := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_DESC")
	       	 RecLock("SA5",.T.)
	       	   SA5->A5_FILIAL	:= xFilial("SA5")
	           SA5->A5_FORNECE	:= _cCodFor
	           SA5->A5_NOMEFOR	:= _cNomeFor
	           SA5->A5_NOMPROD	:= _cNomePro
	           SA5->A5_LOJA		:= _cLojFor
	           SA5->A5_PRODUTO	:= _cCodPro
	           SA5->A5_CODTAB	:= _cTabela
	         msUnlock()  
	      Endif
	  Next _nElemIt
	  MsgInfo(OemToAnsi("Gerada a Tabela Numero ")+_cTabela)
	Endif
Endif

If _lErro 
  fWrite(_nHdlLog,_cQuebra)
  fWrite(_nHdlLog,_cQuebra)
  fClose(_nHdlLog)
  showmemo(_cArqLog)
Else
  fClose(_nHdlLog) 
Endif
// Apaga Arquivo de Log
Ferase(_cArqLog)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLERPLAN   บAutor  ณEduardo Barbosa     บ Data ณ  22/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Conteudo de Uma celula na planilha Excel         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณBGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LERPLAN(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

Local _cRetorno	:= ''
Local _cBufferPl:= ''
Local _nBytesPl	:= 0
Local _cCelula	:= ''
Local _cDescCam	:= ''
Local _cColuna	:= ''
Local _cLinha	:= ''
Local _cTipo	:= ''
Local _cTamanho	:= ''
Local _cDecimal	:= ''
Local _cString	:= ''

If _lExtrai == Nil
	_lExtrai := .F.
Endif

_cDescCam		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",1]"
_cColuna		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",2]"
_cLinha			:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",3]"
_cTipo   		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",4]"
_cTamanho		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",5]"
_cDecimal		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",6]"

_cDescCam		:= &_cDescCam
_cColuna		:= &_cColuna
_cLinha			:= Alltrim(Str(&_cLinha+_nSoma))
_cTipo   		:= Upper(&_cTipo)
_cTamanho		:= &_cTamanho
_cDecimal		:= &_cDecimal
_cCelula		:= _cColuna+_cLinha

// Efetua Leitura da Planilha
_cBufferPl := _cCelula + Space(1024)
_nBytesPl  := ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
_cRetorno  := Subs(_cBufferPl, 1, _nBytesPl)
_cRetorno  := Alltrim(_cRetorno)

// Realiza tratamento do campo  de acordo com o Tipo

If _cTipo =='N' // Numerico
	_cString	:=''
	_cNewRet :=''
	For _nElemTp	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElemTp,1)
		If _cString ==','
			_cString :='.'
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElemTp
	_cNewRet		:= Val(_cNewRet)
	_cRetorno    := Round(_cNewRet,_cDecimal)
Endif

If _cTipo =='D' // Data 21/01/2006
	_cRetorno 	:= Alltrim(_cRetorno)
	_cNewRet 	:= Left(_cRetorno,6)+Right(_cRetorno,2)
	_cRetorno    := CtoD(_cNewRet)
Endif

If _cTipo =='C' .AND. _lExtrai // Caracter e extra็เo de caracteres
	_cString	:=''
	_cNewRet :=''
	For _nElemTp	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElemTp,1)
		If _cString $ '#/#,#.#-'
			Loop
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElemTp
	_cRetorno    := _cNewRet
Endif

// Ajusta O Tamanho da variavel
If _cTipo =='C'
	_cRetorno := Alltrim(_cRetorno)
	_cRetorno := _cRetorno+Space(_cTamanho-Len(_cRetorno))
Endif

Return _cRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROXTAB บAutor  ณDelta Decisao	     บ Data ณ  14/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Proxima Tabela de preco                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProxTab(_cFornece,_cLoja)

Local _cTabRet 	:= "000"
Local _aAreaAtu := GetArea()   

DbSelectArea("AIA")
DbSeek(xFilial("AIA")+_cFornece+_cLoja,.F.)
While ! Eof() .AND. AIA->(AIA_FILIAL+AIA_CODFOR+AIA_LOJFOR) == xFilial("AIA")+_cFornece+_cLoja  
      _cTabRet := AIA->(AIA_CODTAB)
      DbSkip()
Enddo
_cTabRet := Soma1(_cTabRet,03)
RestArea(_aAreaAtu)
Return _cTabRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUTABPRE บAutor  ณDelta Decisao	     บ Data ณ  14/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao Cabe็alho e Itens Tabela de Pre็o                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuTabPre(_cCodTab,_cFornece,_cLoja,_cCodPro,_nPrcCom,_cCondicao,_cDesc,_dDatDe,_dDatAte,_nMoeda)

// Se for o Primeiro Registro, inclui o Cabe็alho
If Len(_aCabTab) == 0 
	_aCabTab:={	{"AIA_CODFOR"  , _cFornece ,Nil},; 
				{"AIA_LOJFOR"  , _cLoja    ,Nil},; 
				{"AIA_CODTAB"  , _cCodTab  ,Nil},; 
				{"AIA_DESCRI"  , _cDesc    ,Nil},; 
				{"AIA_DATDE"   , _dDatDe   ,Nil},; 
				{"AIA_DATATE"  , _dDatAte  ,Nil},; 
				{"AIA_CONDPG"  , _cCondicao,Nil}}
Endif

// Adiciona Item No Array
_aItem:={	{"AIB_CODPRO"   ,_cCodPro,Nil},; 
			{"AIB_PRCCOM"	,_nPrcCom ,Nil},;
			{"AIB_MOEDA"	,_nMoeda ,Nil},;
			{"AIB_DATVIG"	,_dDatDe ,Nil}}
			
			
			
			
aadd(_aIteTab,_aItem)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณDelta Decisao	     บ Data ณ  01/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de perguntas no SX1                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDPERG()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

cPerg     	   := PADR(cPerg,len(sx1->x1_grupo))

// Pasta do Arquivo
AAdd(aHelpPor,"Diretorio ( Pasta ) que se encontra ")
AAdd(aHelpPor,"a Planilha Excel")
PutSx1(cPerg,"01","Diretorio do arquivo ","Diretorio do arquivo","Diretorio do arquivo","mv_ch1","C",30,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Nome do Arquivo
aHelpPor :={}
AAdd(aHelpPor,"Nome do Arquivo Excel a Ser Importado")
PutSx1(cPerg,"02","Nome do Arquivo ","Nome do Arquivo","Nome do Arquivo","mv_ch2","C",30,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Descricao da Tabela
AAdd(aHelpPor,"Descricao da Tabela ")
AAdd(aHelpPor,"de Preco")
PutSx1(cPerg,"03","Descricao da Tabela ","Descricao da Tabela","Descricao da Tabela","mv_ch3","C",30,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Data Vigencia Inicial
AAdd(aHelpPor,"Data Inicial Vigencia")
AAdd(aHelpPor,"Da Tabela de Preco")
PutSx1(cPerg,"04","Data Inicial Vigencia","Data Inicial Vigencia","Data Inicial Vigencia","mv_ch4","D",08,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Data Vigencia Final
AAdd(aHelpPor,"Data Final Vigencia")
AAdd(aHelpPor,"Da Tabela de Preco")
PutSx1(cPerg,"05","Data Final Vigencia","Data Final Vigencia","Data Final Vigencia","mv_ch5","D",08,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Fornecedor
AAdd(aHelpPor,"Codigo Fornecedor")
AAdd(aHelpPor,"Da Tabela de Preco")
PutSx1(cPerg,"06","Fornecedor","Fornecedor","Fornecedor","mv_ch6","C",06,0,0,"G","","SA2","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Loja
AAdd(aHelpPor,"Loja Fornecedor")
AAdd(aHelpPor,"Da Tabela de Preco")
PutSx1(cPerg,"07","Loja","Loja","Loja","mv_ch7","C",02,0,0,"G","","","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

// Fornecedor
AAdd(aHelpPor,"Condicao de Pagamento")
AAdd(aHelpPor,"Da Tabela de Preco")
PutSx1(cPerg,"08","Cond.Pagto","Cond.Pagto","Cond.Pagto","mv_ch8","C",03,0,0,"G","","SE4","","","MV_PAR08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

AAdd(aHelpPor,"Moeda do Preco")
AAdd(aHelpPor,"Da Tabela")
PutSx1(cPerg,"09","Moeda","Moeda","Moeda","mv_ch9","N",02,0,0,"C","","","","","MV_PAR09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return