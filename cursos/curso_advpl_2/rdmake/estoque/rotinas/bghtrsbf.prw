#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ BGHTRSBFณ Autor ณ DeltaDecisao          ณ Data ณ 29/03/11  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Efetuar Transferencia Produto+Armazem+Endere็o Origem para  ฑฑ
ฑฑณ          ณ Produto+Armazem+Endere็o Destino    						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BGHTRSBF()

Local oDlg     		:= Nil
Local oGet     		:= Nil
Local nOpcao        := 0
Private cPerg		:= "BHTRSBF"
Private nOpca 		:= 0
Private _lUserSBF  	:= IIF(UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_USERZU",.F.,"FERNANDO.PERATELLO")),.T.,.F.)
Private _cMsgSBF  	:= "Usuario sem acesso. Entre em contato com o Administrador!"


u_GerA0003(ProcName())

If !_lUserSBF
	MsgAlert(_cMsgSBF)
	Return
Endif

ValidPerg() // Ajusta as Perguntas do SX1
Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Transferencia de Produto") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina efetua transferencia Produto+Armazem+Endere็o ") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("utilizando os itens existentes na planilha.") SIZE 268, 8 OF oDlg PIXEL
@ 48, 15 SAY OemToAnsi("Para isto, o caminho de  localiza็ใo da Planilha deve ser informado nos Parametros") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	MsAguarde({|| ImpSBF()},OemtoAnsi("Processando itens da Planilha"))
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ImpSBF  ณ Autor ณ DeltaDecisao          ณ Data ณ 29/03/11  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Efetua transferencia Produto+Armazem+Endere็o               ฑฑ
ฑฑณ          ณ                                  						   ฑฑ                                                                                                                     ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImpSBF()

Local cCamDLL      		:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
Local nHdl	 	   		:= ExecInDLLOpen(cCamDLL)
Local cBuffer			:= ''
Local cDir		  		:= Alltrim(MV_PAR01)
Local cArq		  		:= Alltrim(MV_PAR02)
Local _cProduto  		:= ""
Local _cArmOri   		:= ""
Local _cEndOri   		:= ""
Local _nQuant    		:= 0
Local _cArmDes   		:= ""
Local _cEndDes   		:= ""

Private _aCelulas		:= {}
Private _atransp   		:= {}
Private _aStru	        := {}

// Montagem das Celulas
AADD(_aCelulas,{'CODIGO             ',"A",2,'C',15,0})
AADD(_aCelulas,{'ARMORI             ',"B",2,'C',02,0})
AADD(_aCelulas,{'ENDORI             ',"C",2,'C',15,0})
AADD(_aCelulas,{'QUANT              ',"D",2,'N',14,2})
AADD(_aCelulas,{'ARMDES             ',"E",2,'C',02,0})
AADD(_aCelulas,{'ENDDES             ',"F",2,'C',15,0})

If Right(Alltrim(cDir),1) <>'\'
	cDir := Alltrim(cDir)+"\"
Endif

// Efetua Ajuste na Variavel de Nome do Arquivo
If Right(Alltrim(cArq),4) <>'.XLSX'
	cArq := Alltrim(cArq)+".XLSX"
Endif

cFile   := cDir+cArq


AADD(_aStru,{"PRODUTO","C",15,0})
AADD(_aStru,{"QUANT","N",14,2})
AADD(_aStru,{"ARMORI","C",02,0})
AADD(_aStru,{"ENDORI","C",15,0})
AADD(_aStru,{"ARMDES","C",02,0})
AADD(_aStru,{"ENDDES","C",15,0})
AADD(_aStru,{"LOG","C",50,0})


_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	:= "PRODUTO+ARMORI"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")


// Verifica se Conseguiu efetuar a Abertura do Arquivo
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
	
	For _nElemx		:= 1 To 70000
		
		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))
		
		_cProduto  := VERDADOS(nHdl,'_aCelulas',01,_nSomaLin)
		_cArmOri   := VERDADOS(nHdl,'_aCelulas',02,_nSomaLin)
		_cEndOri   := VERDADOS(nHdl,'_aCelulas',03,_nSomaLin)
		_nQuant    := VERDADOS(nHdl,'_aCelulas',04,_nSomaLin)
		_cArmDes   := VERDADOS(nHdl,'_aCelulas',05,_nSomaLin)
		_cEndDes   := VERDADOS(nHdl,'_aCelulas',06,_nSomaLin)
		
		If Empty(_cProduto)
			Exit
		Endif
		
		_cProduto	:= _cProduto+Space(15-Len(_cProduto))
		_cArmOri	:= _cArmOri+Space(02-Len(_cArmOri))
		_cArmDes	:= _cArmDes+Space(02-Len(_cArmDes))
		_cEndOri	:= _cEndOri+Space(15-Len(_cEndOri))
		_cEndDes	:= _cEndDes+Space(15-Len(_cEndDes))
		
		// Cria armazem de destino caso nao exista.
		DbSelectarea("SB2")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SB2")+_cProduto+_cArmDes,.F.)
			CriaSb2(_cProduto,_cArmDes)
		Endif
		
		_aTransp := {}
		AADD(_atransp,_cProduto)
		AADD(_atransp,_nQuant)
		AADD(_atransp,_cArmOri)
		AADD(_atransp,_cEndOri)
		AADD(_atransp,_cArmDes)
		AADD(_atransp,_cEndDes)
		
		If 	len(_atransp) > 0
			Processa({|| u_GeraTrans() },"Efetuando transferencia...")
		Endif
		
		_nSomaLin++
	Next _nElemx
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	
	dbSelectArea("TRB")
	dbGotop()
	If TRB->(!EOf())
		Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
	Endif
	
Else
	MsgStop('Nao foi possivel carregar a DLL')
EndIf

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERDADOS   บAutor  ณDelta Decisao      บ Data ณ  21/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Conteudo de Uma celula na planilha Excel         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VERDADOS(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

Local _cRetorno	:= ''
Local _cBufferPl:= ''
Local _nBytesPl	:= 0
Local _cCelula	:=''
Local _cDescCam	:=''
Local _cColuna	:=''
Local _cLinha	:=''
Local _cTipo	:=''
Local _cTamanho	:=''
Local _cDecimal	:=''
Local _cString	:=''

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
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString ==','
			_cString :='.'
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElem
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
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString $ '#/#,#.#-'
			Loop
		Endif
		_cNewRet	:=Alltrim(_cNewRet)+_cString
	Next _nElem
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
ฑฑบPrograma  ณGERLOG    บAutor  ณLuciano Siqueira    บ Data ณ  30/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava log das inconsistencias encontradas                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERLOG(_cProduto,_nQuant,_cArmOri,_cEndOri,_cArmDes,_cEndDes)

dbSelectArea("TRB")

RecLock("TRB",.T.)
TRB->PRODUTO := _cProduto
TRB->QUANT   := _nQuant
TRB->ARMORI  := _cArmOri
TRB->ENDORI  := _cEndOri
TRB->ARMDES  := _cArmDes
TRB->ENDDES  := _cEndDes
TRB->LOG     := "Transferencia nใo Efetuada. Favor verificar!"
MsUnlock()


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPEXC    บAutor  ณLuciano Siqueira    บ Data ณ  30/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime Log das Inconsistencias encontradas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function IMPEXC()

Local oReport

Private _cQuebra := " "

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return


Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")


oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"TRB"})

TRCell():New(oSection1,"PRODUTO","TRB","Produto","@!",15)
TRCell():New(oSection1,"QUANT","TRB","Qtde","@E 99,999,999.99",20)
TRCell():New(oSection1,"ARMORI","TRB","Armz Origem","@!",02)
TRCell():New(oSection1,"ENDORI","TRB","End Origem","@!",15)
TRCell():New(oSection1,"ARMDES","TRB","Armz Destino","@!",02)
TRCell():New(oSection1,"ENDDES","TRB","End Destino","@!",15)
TRCell():New(oSection1,"LOG","TRB","LOG","@!",50)


Return oReport


// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)


// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTrans บAutor  ณLuciano Siqueira    บ Data ณ  29/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua transferencia dos produtos                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GeraTrans()

Local cCodOri	:= 	Space(1)
Local cDescrOri	:= 	Space(1)
Local cUmOri	:=	Space(1)
Local cAlmOri	:= 	Space(1)
Local cEndOri	:= 	Space(1)
Local cCodDest	:=	Space(1)
Local cDescrDest:=	Space(1)
Local cUmDest	:=	Space(1)
Local cAlmDest	:=	Space(1)
Local cEndDest	:= 	Space(1)
Local cNumSerie	:= 	Space(1)
Local cLote		:= 	Space(1)
Local cSLote	:= 	Space(1)
Local cValLote	:= 	ctod('')
Local nPotenc	:= 	0
Local nQtde		:= 	0
Local _nQtde	:= 	0
Local nQtde2	:=	0
Local cEstorn	:= 	Space(01)
Local cSeq      := 	Space(1)
Local cLoteDest	:=	Space(10)
Local cValLtDest:=	ctod('')
Local _aSepa	:= {}
Local cDocumento:= Space(6)
Local _nOpcAuto := 3

//-- Inicializa o numero do Documento com o ultimo + 1
dbSelectArea("SD3")
nSavReg     := RecNo()
cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
cDocumento	:= A261RetINV(cDocumento)
dbSetOrder(2)
dbSeek(xFilial()+cDocumento)
cMay := "SD3"+Alltrim(xFilial())+cDocumento
While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
	If D3_ESTORNO # "S"
		cDocumento := Soma1(cDocumento)
		cMay := "SD3"+Alltrim(xFilial())+cDocumento
	EndIf
	dbSkip()
EndDo

aSepa  := {{cDocumento,dDataBase}}	//Criacao da 1a. linha do array com o documento e data


_cProduto 	:= _atransp[01]
_nQtde		:= _atransp[02]
cCodOri	 	:= 	_cProduto												//	Produto Origem	(Codigo)
cDescrOri	:= 	Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC") //	Produto Origem	(Descricao)
cUmOri	 	:=	Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_UM")	//	Produto Origem	(Unid Medida)
cAlmOri		:= _atransp[03] //_cLocal												//	Produto Origem	(Almoxarifado)
cEndOri		:= _atransp[04] //_cEndOri												//	Produto Origem	(Endereco)

cCodDest	:=	_cProduto												//	Produto Destino	(Codigo)
cDescrDest	:=	Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")	//	Produto Destino	(Descricao)
cUmDest		:=	Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_UM")	//	Produto Destino	(Unid Medida)
cAlmDest	:=	_atransp[05] //_cLocal												//	Produto Destino	(Almoxarifado)
cEndDest	:= 	_atransp[06] //_cEndDest														//	Produto Destino	(Endereco)

cNumSerie	:= 	' '							//	Produto	(Numero de Serie)
cLote		:= 	Space(10)							//	Produto	(Lote)
cSLote		:= 	Space(06)								//	Produto	(Sub Lote)
cValLote	:= 	ctod('')								//	Produto	(Validade do Lote)
nPotenc		:= 	0										//  Potencia
nQtde		:= 	_atransp[02]					//	Produto	(Quantidade do movimento)
nQtde2		:=	ConvUM(cCodOri,nqtde,0,2)				//	Produto	(Quantidade do movimento na Segunda Unidade Medida)
cEstorn		:= 	Space(01)								//	Produto	(Se igual a S = Indica estorno)
cSeq      	:= 	IIF(_nOpcAuto==3,ProxNum()," ")		//	Produto	(Sequencia utilizada pelo sistema)
cLoteDest	:=	Space(10)							//	Produto	(Lote Destino)
cValLtDest  :=	ctod('')								//  Produto (Validade Destino)
cServWms	:= Space(3)
cCodSer		:= Space(3)
cItemGrd	:= Space(3)

aAdd(aSepa,{	cCodOri		,;	//	Produto Origem	(Codigo)
cDescrOri	,;	//	Produto Origem	(Descricao)
cUmOri		,;	//	Produto Origem	(Unid Medida)
cAlmOri		,;	//	Produto Origem	(Almoxarifado)
cEndOri		,;	//	Produto Origem	(Endereco)
cCodDest	,;	//	Produto Destino	(Codigo)
cDescrDest	,;	//	Produto Destino	(Descricao)
cUmDest		,;	//	Produto Destino	(Unid Medida)
cAlmDest	,;	//	Produto Destino	(Almoxarifado)
cEndDest	,;	//	Produto Destino	(Endereco)
cNumSerie	,;	//	Produto	(Numero de Serie)
cLote		,;	//	Produto	(Lote)
cSLote		,;	//	Produto	(Sub Lote)
cValLote	,;	//	Produto	(Validade do Lote)
nPotenc		,;  //	Produto (Potencia)
nQtde		,;	//	Produto	(Quantidade do movimento)
nQtde2		,;	//	Produto	(Quantidade do movimento na Segunda Unidade Medida)
cEstorn		,;	//	Produto	(Se igual a S = Indica estorno)
cSeq		,;	//	Produto	(Sequencia)
cLoteDest	,;	//	Produto	(Lote Destino)
cValLtDest	,;  //  Produto (Validade Lote Destino)
cCodSer		,;
cItemGrd	})  //  Produto (Validade Lote Destino)

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
Chamada da Rotina automatica para gravacao de dados	ณ
|de transferencia modelo II - [tabela SD3] 				|
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
lmsErroAuto	:= .F.
MsExecAuto({|x,y| mata261(x,y)},aSepa,_nOpcAuto)
If  lmsErroAuto
	MostraErro()
	GerLog(_atransp[01],_atransp[02],_atransp[03],_atransp[04],_atransp[05],_atransp[06])
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG  บAutor  ณDelta Decisao      บ Data ณ  21/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function VALIDPERG()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
cPerg        := PADR(cPerg,len(sx1->x1_grupo))

AAdd(aHelpPor,"Diretorio ( Pasta ) que se encontra ")
AAdd(aHelpPor,"a Planilha Excel")
PutSx1(cPerg,"01","Diretorio do arquivo ","Diretorio do arquivo","Diretorio do arquivo","mv_ch1","C",30,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Nome do Arquivo Excel a Ser Importado")
PutSx1(cPerg,"02","Nome do Arquivo ","Nome do Arquivo","Nome do Arquivo","mv_ch2","C",30,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return
