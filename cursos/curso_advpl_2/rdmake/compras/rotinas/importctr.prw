#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CMD_OPENWORKBOOK	1
#DEFINE CMD_CLOSEWORKBOOK	2
#DEFINE CMD_ACTIVEWORKSHEET 3
#DEFINE CMD_READCELL		4
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ IMPORTCTRณ Autor ณ DeltaDecisao         ณ Data ณ 26/12/12  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gerar Conhecimento de Transporte de acordo com layout       ฑฑ
ฑฑณ          ณ disponibilizado em planilha de Excel						   ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMPORTCTR()
Local oDlg     		:= Nil
Local oGet     		:= Nil
Local nOpcao        := 0
Private cPerg		:= "BHCTR"
Private nOpca 		:= 0
u_GerA0003(ProcName())
ValidPerg() // Ajusta as Perguntas do SX1
Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Gerar Conhecimento de Transporte") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina irแ gerar Conhecimento de Transporte de acordo com layout ") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("utilizando os itens existentes na planilha.") SIZE 268, 8 OF oDlg PIXEL
@ 48, 15 SAY OemToAnsi("Para isto, o caminho de  localiza็ใo da Planilha deve ser informado nos Parametros") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
If nOpca == 1
	MsAguarde({|| PROCCTR()},OemtoAnsi("Processando itens da Planilha"))
Endif
Processa({|| VALIDACTR() },"Validando os Dados...")
Processa({|| NFECTRC() },"Processando CTRC...")
dbSelectArea("CTR2")
dbGoTop()
If CTR2->(!EOf())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
Endif
If Sele("CTR") <> 0
	CTR->(dbCloseArea())
Endif
If Sele("CTR2") <> 0
	CTR2->(dbCloseArea())
Endif
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ PROCCTR ณ Autor ณ DeltaDecisao          ณ Data ณ 26/12/12  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processando itens da planilha para gera็ใo do conhecimento  ฑฑ
ฑฑณ          ณ de transporte                       						   ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PROCCTR()
Local cCamDLL		:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
//Local cCamDLL		:= "C:\readexcel.dll"
Local nHdl			:= ExecInDLLOpen(cCamDLL)
Local cBuffer		:= ""
Local cDir			:= Alltrim(MV_PAR01)
Local cArq			:= Alltrim(MV_PAR02)
Private _cCGCORI	:= ""
Private _cCGCAND	:= ""
Private _cNFORI		:= ""
Private _cCTRC		:= ""
Private _cSERCTRC	:= ""
Private _cCHVCTE	:= ""
Private _dDTEMI		:= dDataBase
Private _dDTVenc	:= dDataBase
Private _cCLIORI	:= ""
Private _nVLRORI	:= 0
Private _nVLRCTR	:= 0
Private _aCelulas	:= {}
Private _aStru		:= {}
// Montagem das Celulas
/* GLPI 10592
AADD(_aCelulas,{"CGCORI","A" ,2,"C",014,0})
AADD(_aCelulas,{"CGCAND","B" ,2,"C",014,0})
AADD(_aCelulas,{"NFORI","E"  ,2,"C",400,0}) 
AADD(_aCelulas,{"CTRC" ,"F"  ,2,"C",009,0})
AADD(_aCelulas,{"DTEMI"	,"H" ,2,"D",010,0})
AADD(_aCelulas,{"CLIORI","I" ,2,"C",050,0})
AADD(_aCelulas,{"VLRORI","V" ,2,"N",014,2})
AADD(_aCelulas,{"VLRCTR","AA",2,"N",014,2})
AADD(_aCelulas,{"DTVENC","AD",2,"D",010,0})
*/
AADD(_aCelulas,{"CGCORI"	,"A" ,2,"C",014,0})
AADD(_aCelulas,{"CGCAND"	,"B" ,2,"C",014,0})
AADD(_aCelulas,{"NFORI"		,"D" ,2,"C",400,0})
AADD(_aCelulas,{"CTRC"		,"E" ,2,"C",009,0})
AADD(_aCelulas,{"SERCTRC"	,"G" ,2,"C",003,0})
AADD(_aCelulas,{"CHV_CTE"	,"F" ,2,"C",044,0})
AADD(_aCelulas,{"DTEMI"		,"H" ,2,"D",010,0})
AADD(_aCelulas,{"CLIORI"	,"I" ,2,"C",050,0})
AADD(_aCelulas,{"VLRORI"	,"V" ,2,"N",014,2})
AADD(_aCelulas,{"VLRCTR"	,"AA",2,"N",014,2})
AADD(_aCelulas,{"DTVENC"	,"AE",2,"D",010,0})
If Right(Alltrim(cDir),1) <> "\"
	cDir := Alltrim(cDir) + "\"
Endif
// Efetua Ajuste na Variavel de Nome do Arquivo
If Right(Alltrim(cArq),4) <> ".XLSX"
	cArq := Alltrim(cArq) + ".XLSX"
Endif
cFile   := cDir+cArq
AADD(_aStru,{"CGCORI"	,"C",014,0})
AADD(_aStru,{"CGCAND"	,"C",014,0})
AADD(_aStru,{"NFORI"	,"C",400,0})
AADD(_aStru,{"CTRC"		,"C",009,0})
AADD(_aStru,{"SERCTRC"	,"C",003,0})
AADD(_aStru,{"CHV_CTE"	,"C",044,0})
AADD(_aStru,{"DTEMI"	,"D",010,0})
AADD(_aStru,{"CLIORI"	,"C",050,0})
AADD(_aStru,{"VLRORI"	,"N",014,2})
AADD(_aStru,{"VLRCTR"	,"N",014,2})
AADD(_aStru,{"DTVENC"	,"D",010,0})
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
If Sele("CTR") <> 0
	CTR->(dbCloseArea())
Endif
_cChaveInd	:= "CGCAND+CTRC+SERCTRC"
dbUseArea(.T.,,_cArq,"CTR",.F.,.F.)
IndRegua("CTR",_cIndice,_cChaveInd,,,"Selecionando Registros...")
_aStru := {}
AADD(_aStru,{"CGCAND"	,"C",014,0})
AADD(_aStru,{"CTRC"		,"C",009,0})
AADD(_aStru,{"SERCTRC"	,"C",003,0})
AADD(_aStru,{"CHV_CTE"	,"C",044,0})
AADD(_aStru,{"VLRCTR"	,"N",014,2})
AADD(_aStru,{"CGCORI"	,"C",014,0})
AADD(_aStru,{"NFORI"	,"C",400,0})
AADD(_aStru,{"VLRORI"	,"N",014,2})
AADD(_aStru,{"LOG"		,"C",100,0})
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
If Sele("CTR2") <> 0
	CTR2->(dbCloseArea())
Endif
_cChaveInd	:= "CGCAND+CTRC+SERCTRC"
dbUseArea(.T.,,_cArq,"CTR2",.F.,.F.)
IndRegua("CTR2",_cIndice,_cChaveInd,,,"Selecionando Registros...")
// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )
	// Carrega o Excel e Abre o arquivo
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	If ( nBytes < 0 )
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop("Nใo foi possํvel abrir o arquivo : " + cFile)
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
	For _nElemx := 1 To 70000
		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))
		_cCGCORI	:= VERDADOS(nHdl,"_aCelulas",01,_nSomaLin,.T.)
		_cCGCAND	:= VERDADOS(nHdl,"_aCelulas",02,_nSomaLin,.T.)
		_cNFORI		:= VERDADOS(nHdl,"_aCelulas",03,_nSomaLin,.T.)
		_cCTRC		:= VERDADOS(nHdl,"_aCelulas",04,_nSomaLin,.T.)
		_cSERCTRC	:= VERDADOS(nHdl,"_aCelulas",05,_nSomaLin,.T.)
		_cCHVCTE	:= VERDADOS(nHdl,"_aCelulas",06,_nSomaLin,.T.)
		_dDTEMI		:= VERDADOS(nHdl,"_aCelulas",07,_nSomaLin)
		_cCLIORI	:= VERDADOS(nHdl,"_aCelulas",08,_nSomaLin,.T.)
		_nVLRORI	:= VERDADOS(nHdl,"_aCelulas",09,_nSomaLin)
		_nVLRCTR	:= VERDADOS(nHdl,"_aCelulas",10,_nSomaLin)
		_dDTVenc	:= VERDADOS(nHdl,"_aCelulas",11,_nSomaLin)
		If Empty(_cCTRC) .OR. Empty(_cSERCTRC)
			Exit
		Endif
		_cCGCORI	:= STRZERO(VAL(_cCGCORI),14)
		_cCGCAND	:= STRZERO(VAL(_cCGCAND),14)
		_cNFORI		:= IIF(Len(Alltrim(_cNFORI)) < 9, STRZERO(VAL(_cNFORI),9), Alltrim(_cNFORI))
		_cCTRC		:= IIF(Len(Alltrim(_cCTRC)) < 9, STRZERO(VAL(_cCTRC),9), Alltrim(_cCTRC))
		_cCHVCTE	:= IIF(Len(Alltrim(_cCHVCTE)) < 44, STRZERO(VAL(_cCHVCTE),44), Alltrim(_cCHVCTE))
		ATUTRB()//"Atualizando Tabela Temporaria..."
		_nSomaLin++
	Next _nElemx
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
Else
	MsgStop("Nao foi possivel carregar a DLL")
EndIf
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
Local _cRetorno	:= ""
Local _cBufferPl:= ""
Local _nBytesPl	:= 0
Local _cCelula	:= ""
Local _cDescCam	:= ""
Local _cColuna	:= ""
Local _cLinha	:= ""
Local _cTipo	:= ""
Local _cTamanho	:= ""
Local _cDecimal	:= ""
Local _cString	:= ""
If _lExtrai == Nil
	_lExtrai := .F.
Endif
_cDescCam	:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",1]"
_cColuna	:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",2]"
_cLinha		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",3]"
_cTipo   	:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",4]"
_cTamanho	:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",5]"
_cDecimal	:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",6]"
_cDescCam	:= &_cDescCam
_cColuna	:= &_cColuna
_cLinha		:= Alltrim(Str(&_cLinha+_nSoma))
_cTipo   	:= Upper(&_cTipo)
_cTamanho	:= &_cTamanho
_cDecimal	:= &_cDecimal
_cCelula	:= _cColuna+_cLinha
// Efetua Leitura da Planilha
_cBufferPl	:= _cCelula + Space(1024)
_nBytesPl	:= ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
_cRetorno	:= Subs(_cBufferPl, 1, _nBytesPl)
_cRetorno	:= Alltrim(_cRetorno)
// Realiza tratamento do campo  de acordo com o Tipo
If _cTipo == "N" // Numerico
	_cString	:= ""
	_cNewRet	:= ""
	For _nElem := 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString == ","
			_cString := "."
		Endif
		_cNewRet := Alltrim(_cNewRet)+_cString
	Next _nElem
	_cNewRet	:= Val(_cNewRet)
	_cRetorno	:= Round(_cNewRet,_cDecimal)
Endif
If _cTipo == "D" // Data 21/01/2006
	_cRetorno	:= Alltrim(_cRetorno)
	_cNewRet	:= Left(_cRetorno,6)+Right(_cRetorno,2)
	_cRetorno	:= CtoD(_cNewRet)
Endif
If _cTipo == "C" .AND. _lExtrai // Caracter e extra็เo de caracteres
	_cString	:= ""
	_cNewRet	:= ""
	For _nElem := 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString $ "#/#,#.#-"
			Loop
		Endif
		_cNewRet := Alltrim(_cNewRet)+_cString
	Next _nElem
	_cRetorno := _cNewRet
Endif
// Ajusta O Tamanho da variavel
If _cTipo == "C"
	_cRetorno := Alltrim(_cRetorno)
	_cRetorno := _cRetorno+Space(_cTamanho-Len(_cRetorno))
Endif
Return _cRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUTRB    บAutor  ณLuciano Siqueira    บ Data ณ  26/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualizando tabela temporaria com dados do CTR              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ATUTRB()
dbSelectArea("CTR")
If dbSeek(_cCGCAND+_cCTRC+_cSERCTRC)
	RecLock("CTR",.F.)
Else
	RecLock("CTR",.T.)
	CTR->CGCORI		:= _cCGCORI
	CTR->CGCAND		:= _cCGCAND
	CTR->CTRC		:= _cCTRC
	CTR->SERCTRC	:= _cSERCTRC
	CTR->CHV_CTE	:= _cCHVCTE
	CTR->DTEMI		:= _dDTEMI
	CTR->CLIORI		:= _cCliOri
	CTR->DTVENC		:= _dDTVenc
Endif
CTR->NFORI  := IIF(EMPTY(CTR->NFORI),_cNFORI,Alltrim(CTR->NFORI)+";"+_cNFORI)
CTR->VLRORI += _nVLRORI
CTR->VLRCTR += _nVLRCTR
MsUnlock()
Return
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
Static Function VALIDACTR()
dbSelectArea("CTR")
dbGoTop()
Do While CTR->(!EOf())
	dbSelectArea("SA2")
	dbsetorder(3)
	dbSeek(xFilial("SA2")+CTR->CGCAND)
	If Len(Alltrim(CTR->CTRC)) > 9
		GERLOG("Numero CT-E invalido")
	Endif
	If Len(Alltrim(CTR->SERCTRC)) > 3
		GERLOG("Serie  CT-E invalido")
	Endif
	If Len(Alltrim(CTR->CHV_CTE)) > 44
		GERLOG("Chave  CT-E invalido")
	Endif
	/*If Alltrim(CTR->SERCTRC) = "0"
		GERLOG("Serie  CT-E invalido")
	Endif*/
	If Upper(left(CTR->CLIORI,3))=="BGH"
		cQrySF2 := "SELECT SUM(F2_VALBRUT) VALBRUT "
		cQrySF2 += "FROM " + RetSqlName("SF2") + " SF2 "
		cQrySF2	+= "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND "
		cQrySF2	+= " F2_XAMFRE <> 'S' AND "
		cQrySF2 += " F2_DOC IN "+FormatIn(CTR->NFORI,";")+" AND "
		cQrySF2 += " F2_SERIE IN ('001','1') AND "
		cQrySF2 += " SF2.D_E_L_E_T_ = ' ' "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),"QRYSF2",.T.,.T.)
		If QRYSF2->VALBRUT <> CTR->VLRORI
			GERLOG("Nota(s) de origem nใo encontrada(s) ou valor da planilha diverge da(s) nota(s) no sistema")
		Endif
		QRYSF2->(dbCloseArea())
	Else
		cQrySF1 := "SELECT SUM(F1_VALBRUT) VALBRUT "
		cQrySF1 += "FROM " + RetSqlName("SF1") + " SF1 "
		cQrySF1 += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQrySF1 += "A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND A1_CGC='"+CTR->CGCORI+"' "
		cQrySF1	+= "WHERE F1_FILIAL='"+xFilial("SF1")+"' AND "
		cQrySF1	+= " F1_XAMFRE <> 'S' AND "
		cQrySF1 += " F1_DOC IN "+FormatIn(CTR->NFORI,";")+" AND "
		cQrySF1 += " F1_TIPO = 'B' AND "
		cQrySF1 += " SF1.D_E_L_E_T_ = ' ' "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF1),"QRYSF1",.T.,.T.)
		If QRYSF1->VALBRUT <> CTR->VLRORI
			GERLOG("Nota(s) de origem nใo encontrada(s) ou valor da planilha diverge da(s) nota(s) no sistema")
		Endif
		QRYSF1->(dbCloseArea())
	Endif
	CTR->(dbSkip())
EndDo
Return
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
Static Function GERLOG(_cLog)
dbSelectArea("CTR2")
RecLock("CTR2",.T.)
CTR2->CGCAND	:= CTR->CGCAND
CTR2->CTRC		:= CTR->CTRC
CTR2->SERCTRC	:= CTR->SERCTRC
CTR2->CHV_CTE	:= CTR->CHV_CTE
CTR2->VLRCTR	:= CTR->VLRCTR
CTR2->CGCORI	:= CTR->CGCORI
CTR2->NFORI		:= CTR->NFORI
CTR2->VLRORI	:= CTR->VLRORI
CTR2->LOG		:= _cLog
MsUnlock()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NFECTRC บAutor  ณ                     บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NFECTRC()
Local aArea			:= GetArea()
Local aCab			:= {}
Local aItens		:= {}
Local aLinha		:= {}
Private _cProduto	:=	""
Private _cTES		:=	""
Private lMsErroAuto := .F.
dbSelectArea("CTR")
dbGoTop()
Do While CTR->(!EOf())
	dbSelectArea("CTR2")
	If !dbSeek(CTR->CGCAND+CTR->CTRC+CTR->SERCTRC)
		If CTR->VLRCTR > 0
			dbSelectArea("SA2")
			dbsetorder(3)
			If dbSeek(xFilial("SA2")+CTR->CGCAND)
				dbSelectArea("SF1")
				dbsetorder(1)
				If dbSeek(xFilial("SF1")+CTR->CTRC+CTR->SERCTRC+SA2->A2_COD+SA2->A2_LOJA)
					GERLOG("CT-E gerado anteriormente. Favor verificar")
				Else
					dbSelectArea("SF3")
					dbsetorder(4)
					If dbSeek(xFilial("SF3")+SA2->A2_COD+SA2->A2_LOJA+CTR->CTRC+CTR->SERCTRC)
						GERLOG("CT-E ja existe no livro fiscal. Favor verificar")
					Else
						_cProduto	:= IIF(SA2->A2_EST=="SP","800017","800041")
						//_cTES		:= IIF(SA2->A2_EST=="SP","215","273") 
						_cTES		:= IIF(SA2->A2_EST=="SP","280","273")
						dbSelectArea("SB1")
						dbsetorder(1)
						dbSeek(xFilial("SB1")+_cProduto)
						aCab := {}
						aCab := { {"F1_TIPO"   ,"N"           ,NIL},;
						{"F1_FILIAL" ,xFilial("SF1")     ,NIL},;
						{"F1_FORMUL" ,"N"           ,NIL},;
						{"F1_EMISSAO",CTR->DTEMI  ,NIL},;
						{"F1_DTDIGIT",dDataBase          ,NIL},;
						{"F1_FORNECE",SA2->A2_COD   ,NIL},;
						{"F1_LOJA"   ,SA2->A2_LOJA   ,NIL},;
						{"F1_SERIE"  ,CTR->SERCTRC ,NIL},;
						{"F1_DOC"    ,CTR->CTRC    ,NIL},;
						{"F1_CHVNFE" ,CTR->CHV_CTE ,NIL},;
						{"F1_ESPECIE","CTE"       ,NIL}}
						aLinha := {}
						aLinha := { {"D1_COD"    ,_cProduto    ,NIL},;
						{"D1_FILIAL" ,xFilial("SD1")  ,NIL},;
						{"D1_ITEM"   ,"0001"     ,NIL},;
						{"D1_UM"     ,SB1->B1_UM   ,NIL},;
						{"D1_QUANT"  ,1              ,NIL},;
						{"D1_VUNIT"  ,CTR->VLRCTR ,NIL},;
						{"D1_TOTAL"  ,CTR->VLRCTR ,NIL},;
						{"D1_DOC"    ,CTR->CTRC     ,NIL},;
						{"D1_SERIE"  ,CTR->SERCTRC  ,NIL},;
						{"D1_TES"    ,_cTes         ,NIL},;
						{"D1_FORNECE",SA2->A2_COD   ,NIL},;
						{"D1_LOJA"   ,SA2->A2_LOJA   ,NIL},;
						{"D1_EMISSAO",CTR->DTEMI ,NIL},;
						{"D1_DTDIGIT",dDataBase    ,NIL},;
						{"D1_TIPO"   ,"N"      ,NIL},;
						{"D1_LOCAL"  ,SB1->B1_LOCPAD ,NIL},;
						{"D1_CONTA"  ,SB1->B1_CONTA  ,NIL},;
						{"D1_CC"    ,SB1->B1_CC  ,NIL}}
						aItens := {}
						AAdd( aItens, aLinha )
						If (Len(aCab) > 0) .And. (Len(aItens) > 0)
							MSExecAuto( {|x,y,z,w| MATA103( x, y, z, w ) }, aCab, aItens, 3, .F. )
							If lMsErroAuto
								//MostraErro()
								//DisarmTransaction()
								GERLOG("Erro na grava็ใo CT-E. Favor verificar")
							Else
								dbSelectArea("SE2")
								dbsetorder(6)
								dbGoTop()
								If dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
									Reclock("SE2",.F.)
									SE2->E2_VENCTO	:= CTR->DTVENC
									SE2->E2_VENCREA	:= CTR->DTVENC
									MsUnlock()
								EndIf
								GERLOG("CT-E gerado com sucesso")
								ATUCTR()
							Endif
						Endif
					Endif
				Endif
			Else
				GERLOG("Fornecedor nใo localizado. Favor verificar!")
			Endif
		Else
			GERLOG("Valor do CT-E nใo informado na planilha. Favor verificar!")
		Endif
	Endif
	dbSelectArea("CTR")
	CTR->(dbSkip())
EndDo
RestArea(aArea)
Return
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
Static Function ATUCTR()
Local aAreaAtu := GetArea()
If Upper(left(CTR->CliOri,3))=="BGH"
	cQrySF2 := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO, F2_CLIENTE,F2_LOJA,F2_VALBRUT, R_E_C_N_O_ AS RECSF2 "
	cQrySF2 += "FROM " + RetSqlName("SF2") + " SF2 "
	cQrySF2	+= "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND "
	cQrySF2	+= " F2_XAMFRE <> 'S' AND "
	cQrySF2 += " F2_DOC IN "+FormatIn(CTR->NFORI,";")+" AND "
	cQrySF2 += " F2_SERIE IN ('001','1') AND "
	cQrySF2 += " SF2.D_E_L_E_T_ = ' ' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),"QRYSF2",.T.,.T.)
	TcSetField("QRYSF2","F2_EMISSAO","D",10,0)
	TcSetField("QRYSF2","F2_VALBRUT","N",14,2)
	dbSelectArea("QRYSF2")
	dbGoTop()
	If QRYSF2->(!EOF())
		Do While QRYSF2->(!EOF())
			dbSelectArea("Z11")
			RecLock("Z11",.T.)
			Z11->Z11_FILIAL		:= xFilial("Z11")
			Z11->Z11_CTRNFE		:= SF1->F1_DOC
			Z11->Z11_SERIE 		:= SF1->F1_SERIE
			Z11->Z11_EMISSAO	:= CTR->DTEMI
			Z11->Z11_DIGIT		:= dDataBase
			Z11->Z11_FORNEC		:= SF1->F1_FORNECE
			Z11->Z11_LOJA		:= SF1->F1_LOJA
			Z11->Z11_DOC		:= QRYSF2->F2_DOC
			Z11->Z11_SERIES		:= QRYSF2->F2_SERIE
			Z11->Z11_EMISNFV	:= QRYSF2->F2_EMISSAO
			Z11->Z11_CLIENT		:= QRYSF2->F2_CLIENTE
			Z11->Z11_LOJACLI	:= QRYSF2->F2_LOJA
			Z11->Z11_VLRNFV		:= QRYSF2->F2_VALBRUT
			MsUnlock()
			dbSelectArea("SF2")
			SF2->(DBGOTO(QRYSF2->RECSF2))
			RecLock("SF2",.F.)
			SF2->F2_XAMFRE := "S"
			MsUnlock()
			QRYSF2->(dbSkip())
		EndDo
	Else
		dbSelectArea("Z11")
		RecLock("Z11",.T.)
		Z11->Z11_FILIAL  := xFilial("Z11")
		Z11->Z11_CTRNFE  := SF1->F1_DOC
		Z11->Z11_SERIE   := SF1->F1_SERIE
		Z11->Z11_EMISSAO := CTR->DTEMI
		Z11->Z11_DIGIT   := dDataBase
		Z11->Z11_FORNECE := SF1->F1_FORNECE
		Z11->Z11_LOJA    := SF1->F1_LOJA
		MsUnlock()
	Endif
	QRYSF2->(dbCloseArea())
Else
	cQrySF1 := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_EMISSAO, F1_FORNECE,F1_LOJA,F1_VALBRUT, SF1.R_E_C_N_O_ AS RECSF1 "
	cQrySF1 += "FROM " + RetSqlName("SF1") + " SF1 "
	cQrySF1 += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQrySF1 += "A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND A1_CGC='"+CTR->CGCORI+"' "
	cQrySF1	+= "WHERE F1_FILIAL='"+xFilial("SF1")+"' AND "
	cQrySF1	+= " F1_XAMFRE <> 'S' AND "
	cQrySF1 += " F1_DOC IN "+FormatIn(CTR->NFORI,";")+" AND "
	cQrySF1 += " F1_TIPO = 'B' AND "
	cQrySF1 += " SF1.D_E_L_E_T_ = ' ' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF1),"QRYSF1",.T.,.T.)
	TcSetField("QRYSF1","F1_EMISSAO","D",10,0)
	TcSetField("QRYSF1","F1_VALBRUT","N",14,2)
	dbSelectArea("QRYSF1")
	dbGoTop()
	If QRYSF1->(!EOF())
		Do While QRYSF1->(!EOF())
			dbSelectArea("Z11")
			RecLock("Z11",.T.)
			Z11->Z11_FILIAL  := xFilial("Z11")
			Z11->Z11_CTRNFE  := SF1->F1_DOC
			Z11->Z11_SERIE   := SF1->F1_SERIE
			Z11->Z11_EMISSAO := CTR->DTEMI
			Z11->Z11_DIGIT   := dDataBase
			Z11->Z11_FORNECE := SF1->F1_FORNECE
			Z11->Z11_LOJA    := SF1->F1_LOJA
			Z11->Z11_DOC     := QRYSF1->F1_DOC
			Z11->Z11_SERIES  := QRYSF1->F1_SERIE
			Z11->Z11_EMISNFV := QRYSF1->F1_EMISSAO
			Z11->Z11_CLIENT  := QRYSF1->F1_FORNECE
			Z11->Z11_LOJACLI := QRYSF1->F1_LOJA
			Z11->Z11_VLRNFV  := QRYSF1->F1_VALBRUT
			MsUnlock()
			dbSelectArea("SF1")
			SF1->(DBGOTO(QRYSF1->RECSF1))
			RecLock("SF1",.F.)
			SF1->F1_XAMFRE := "S"
			MsUnlock()
			QRYSF1->(dbSkip())
		EndDo
	Else
		dbSelectArea("Z11")
		RecLock("Z11",.T.)
		Z11->Z11_FILIAL  := xFilial("Z11")
		Z11->Z11_CTRNFE  := SF1->F1_DOC
		Z11->Z11_SERIE   := SF1->F1_SERIE
		Z11->Z11_EMISSAO := CTR->DTEMI
		Z11->Z11_DIGIT   := dDataBase
		Z11->Z11_FORNECE := SF1->F1_FORNECE
		Z11->Z11_LOJA    := SF1->F1_LOJA
		MsUnlock()
	Endif
	QRYSF1->(dbCloseArea())
Endif
RestArea(aAreaAtu)
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSection
oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")
oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"CTR2"})
TRCell():New(oSection1,"CGCAND","CTR2","CNPJ ANDREANI","@!",14)
TRCell():New(oSection1,"CTRC","CTR2","CTRC","@!",09)
TRCell():New(oSection1,"SERCTRC","CTR2","SERCTRC","@!",03)
TRCell():New(oSection1,"CHV_CTE","CTR2","CHV_CTE","@!",03)
TRCell():New(oSection1,"VLRCTR","CTR2","VLR CTRC","@E 99,999,999.99",20)
TRCell():New(oSection1,"CGCORI","CTR2","CNPJ ORIGEM","@!",14)
TRCell():New(oSection1,"NFORI","CTR2","NF ORIGEM","@!",400)
TRCell():New(oSection1,"VLRORI","CTR2","VLR ORIGEM","@E 99,999,999.99",20)
TRCell():New(oSection1,"LOG","CTR2","LOG","@!",100)
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ                   บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Relatorio                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)
// Impressao da Primeira secao
dbSelectArea("CTR2")
dbGoTop()
oReport:SetMeter(RecCount())
oSection1:Init()
While !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	dbSelectArea("CTR2")
	dbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()
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