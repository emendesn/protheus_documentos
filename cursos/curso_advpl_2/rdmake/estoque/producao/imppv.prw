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
ฑฑบPrograma  ณIMPPV บAutor  ณLuciano Siqueira        บ Data ณ  12/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta Previsใo de Venda conforme layout                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPPV()

Private cPerg	:= "IMPPV"
Private nOpca 	:= 0
ValidPerg() // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return
Endif

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Importa็ใo Previsใo de Vendas") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina realiza a importa็ใo de Planilha Excel com dados de Previsใo de Vendas.") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("Caso exista informa็๕es nos periodos existentes na Planilha a rotina irแ excluir.") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	MsAguarde({|| fImpExcel()},OemtoAnsi("Aguarde Efetuando Importa็ใo da Planilha"))
Endif

If Sele("TRB")<>0
	TRB->(DbCloseArea())
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFImpExcel บAutor  ณLuciano Siqueira    บ Data ณ  12/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para abrir e ler informa็๕es do Excel                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FImpExcel()

Local cCamDLL     	:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
Local nHdl 		  	:= ExecInDLLOpen(cCamDLL)//caminho da dll
Local cBuffer	  	:= ''
Local cDir		  	:= Alltrim(MV_PAR01)
Local cArq		  	:= Alltrim(MV_PAR02)

Private _aStru	    := {}
Private _aCelulas	:= {}
Private _aPeriodo	:= {}

// Efetua ajuste no Parametro de Diretorio
If Right(Alltrim(cDir),1) <>'\'
	cDir := Alltrim(cDir)+"\"
Endif

// Efetua Ajuste na Variavel de Nome do Arquivo
If Right(Alltrim(cArq),4) <>'.XLSX'
	cArq := Alltrim(cArq)+".XLSX"
Endif
cFile   := cDir+cArq

AADD(_aStru,{"PERIODO"	,"D",08,0})
AADD(_aStru,{"PRODUTO"	,"C",15,0})
AADD(_aStru,{"ARMAZ"  	,"C",02,0})
AADD(_aStru,{"QTDE"		,"N",14,2})


_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	:= "PRODUTO+DTOS(PERIODO)+ARMAZ"

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
	
	AADD(_aCelulas,{'Produto               ',"A",1,'C',15,0})
	AADD(_aCelulas,{'Armaz                 ',"B",1,'C',02,0})
	
	_cCelula := "C"
	For _nLinha  := 3 to 25
		AADD(_aCelulas,{'',_cCelula,1,'N',14,2})
		_aCelulas[_nLinha,1] := U_CABECPV(nHdl,'_aCelulas',_nLinha,_nSomaLin)
		If Alltrim(_cCelula) == "Z"
			_cCelula := "AA"
		Else
			_cCelula := soma1(_cCelula)
		Endif
		While right(_cCelula,1) $ "0#1#2#3#4#5#6#7#8#9"
			_cCelula := soma1(_cCelula)
		End
		If Empty(_aCelulas[_nLinha,1])
			Exit
		Endif
		_cPeriodo  	:= Alltrim(_aCelulas[_nLinha,1])
		_nPos 		:= AScan( _aPeriodo, { |_x| _x[1] == _cPeriodo } )
		If _nPos == 0
			Aadd( _aPeriodo, {_cPeriodo} )
		Endif
	Next _nLinha
	
	_nSomaLin++
	For _nElemx		:= 1 To 70000
		_cProduto  := UPPER(U_VERPV(nHdl,'_aCelulas',01,_nSomaLin))
		_cProduto  := _cProduto+Space(15-Len(_cProduto))
		If Empty(_cProduto)
			Exit
		Endif
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+_cProduto)
			_cArmaz    := U_VERPV(nHdl,'_aCelulas',02,_nSomaLin)
			MsProcTxt("Proc.Produto: "+_cProduto)
			For _nLinha  := 3 to 25
				If Empty(_aCelulas[_nLinha,1])
					Exit
				Endif
				_nQtde := 0
				_nQtde := U_VERPV(nHdl,'_aCelulas',_nLinha,_nSomaLin)
				If _nQtde > 0
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->PRODUTO:= _cProduto
					TRB->ARMAZ	:= _cArmaz
					TRB->PERIODO:= CTOD(_aCelulas[_nLinha,1])
					TRB->QTDE	:= _nQtde
					MsUnlock()
				Endif
			Next _nLinha
		Else
			MsgAlert("Produto "+Alltrim(_cProduto)+" nใo encontrado no cadastro. Favor verificar!")
		Endif
		_nSomaLin++
	Next _nElemx
	

	dbSelectArea("TRB")
	dbGotop()
	If TRB->(!EOF())
		For i:=1 to Len(_aPeriodo)
			Processa({|| ExcPV(_aPeriodo[i,1]) },"Excluindo Previs๕es de Vendas do periodo "+_aPeriodo[i,1])
		Next i
		Processa({|| GERPV() },"Gerando Previs๕es de Venda...")
	Endif
	
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	
Else
	MsgStop('Nao foi possivel carregar a DLL')
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCABECPV    บAutor  ณLuciano Siqueira   บ Data ณ  10/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as lojas da RIHAPPY existentes na planilha         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CABECPV(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

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


Return _cRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERPV      บAutor  ณEduardo Barbosa     บ Data ณ  03/12/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Conteudo de Uma celula na planilha Excel         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VERPV(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

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
ฑฑบPrograma  ณExcPV บAutor  ณLuciano Siqueira        บ Data ณ  12/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExcluir Previs๕es de Venda                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExcPV(_cPeriodo)

Local dDtIni := FirstDay(CTOD(_cPeriodo))
Local dDtFim := LastDay(CTOD(_cPeriodo))

If select("QRYPV") > 0
	QRYPV->(dbCloseArea())
EndIf

_cQuery := " SELECT "
_cQuery += " 	R_E_C_N_O_ AS RECSC4 "
_cQuery += " FROM "+retsqlname("SC4")+" AS SC4 (NOLOCK) "
_cQuery += " WHERE "
_cQuery += "	C4_FILIAL = '"+xFilial("SC4")+"' AND "
_cQuery += "	C4_DATA BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' AND "
_cQuery += "	SC4.D_E_L_E_T_='' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRYPV",.T.,.T.)

QRYPV->(dbGoTop())
Do While QRYPV->(!EOF())
	dbSelectArea("SC4")
	SC4->(dbgoto(QRYPV->RECSC4))
	RecLock( "SC4", .F., .T. )
	SC4->( dbDelete() )
	SC4->( MsUnLock() )
	QRYPV->(dbSkip())
EndDo

If select("QRYPV") > 0
	QRYPV->(dbCloseArea())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERPV บAutor  ณLuciano Siqueira        บ Data ณ  12/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGerar Previs๕es de Venda                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERPV()

dbSelectArea("TRB")
dbGotop()

Do While TRB->(!EOF())
	DbSelectArea("SC4")
	RecLock("SC4",.T.)
	SC4->C4_FILIAL	:= xFilial("SC4")
	SC4->C4_PRODUTO	:= TRB->PRODUTO
	SC4->C4_LOCAL	:= TRB->ARMAZ
	SC4->C4_DATA	:= TRB->PERIODO
	SC4->C4_QUANT	:= TRB->QTDE
	SC4->C4_DOC		:= UPPER(LEFT(MESEXTENSO(MONTH(TRB->PERIODO)),3))+SPACE(1)+ALLTRIM(STR(YEAR(TRB->PERIODO)))
	MsUnlock()	
	TRB->(dbSkip())
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณLuciano Siqueira    บ Data ณ  03/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de perguntas no SX1                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SUNNY                                                      บฑฑ
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
