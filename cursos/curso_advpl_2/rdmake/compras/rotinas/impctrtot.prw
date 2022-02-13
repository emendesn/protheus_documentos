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
ฑฑณFun…o    ณ IMPCTRTOTณ Autor ณ DeltaDecisao         ณ Data ณ 26/12/12  ณฑฑ
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
User Function IMPCTRTOT()
Local oDlg		:= Nil
Local oGet		:= Nil
Local nOpcao	:= 0
Private cPerg	:= "BHCTR"
Private nOpca	:= 0
u_GerA0003(ProcName())
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta as Perguntas do SX1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ValidPerg()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega as Perguntas do SX1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Pergunte(cPerg,.T.)
	Return
Endif
Define Msdialog oDlg From  96,9 TO 310,592 Title OemToAnsi("Gerar Conhecimento de Transporte") Pixel
@ 18, 6 TO 66, 287 LABEL "" Of oDlg Pixel
@ 29, 15 Say OemToAnsi("Esta rotina irแ gerar Conhecimento de Transporte de acordo com layout ") Size 268, 8 Of oDlg Pixel
@ 38, 15 Say OemToAnsi("utilizando os itens existentes na planilha.") Size 268, 8 Of oDlg Pixel
@ 48, 15 Say OemToAnsi("Para isto, o caminho de  localiza็ใo da Planilha deve ser informado nos Parametros") Size 268, 8 Of oDlg Pixel
Define Sbutton From 80, 196 TYPE 5 Action pergunte(cPerg,.T.) Enable Of oDlg
Define Sbutton From 80, 223 TYPE 1 Action (oDlg:End(),nOpca:=1) Enable Of oDlg
Define Sbutton From 80, 250 TYPE 2 Action oDlg:End() Enable Of oDlg
ACTIVATE Msdialog oDlg CENTER
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
Local cCamDLL		:= GetMV("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
//Local cCamDLL		:= "C:\readexcel.dll"
Local nHdl			:= ExecInDLLOpen(cCamDLL)
Local cBuffer		:= ""
Local cDir			:= AllTrim(MV_PAR01)
Local cArq			:= AllTrim(MV_PAR02)
Private _cFornece	:= "Z0062B"
Private _cLoja		:= "01"
Private _cNFORI		:= ""
Private _cSerORI	:= ""
Private _cCTRC		:= ""
Private _cSerCT		:= "UN "
Private _cChvNfe	:= ""
Private _nVLRORI	:= 0
Private _nVLRCTR	:= 0
Private _aCelulas	:= {}
Private _aStru		:= {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem das Celulasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
AADD(_aCelulas,{"CTRC"	,"B", 2,"C",09,0})
AADD(_aCelulas,{"SERCT"	,"C", 2,"C",03,0})
AADD(_aCelulas,{"CHVCTE","D", 2,"C",44,0})
AADD(_aCelulas,{"NFORI"	,"I", 2,"C",09,0})
AADD(_aCelulas,{"SERORI","J", 2,"C",03,0})
AADD(_aCelulas,{"DTEMI"	,"S", 2,"D",10,0})
AADD(_aCelulas,{"VLRORI","U", 2,"N",14,2})
AADD(_aCelulas,{"VLRCTR","AH",2,"N",14,2})
AADD(_aCelulas,{"DTVEN"	,"AJ",2,"D",10,0})
*/
AADD(_aCelulas,{"CTRC"	,"B", 2,"C",09,0})
AADD(_aCelulas,{"SERCT"	,"C", 2,"C",03,0})
AADD(_aCelulas,{"CHVCTE","D", 2,"C",44,0})
AADD(_aCelulas,{"NFORI"	,"K", 2,"C",09,0})
AADD(_aCelulas,{"SERORI","L", 2,"C",03,0})
AADD(_aCelulas,{"DTEMI"	,"U", 2,"D",10,0})
AADD(_aCelulas,{"VLRORI","W", 2,"N",14,2})
AADD(_aCelulas,{"VLRCTR","AJ",2,"N",14,2})
AADD(_aCelulas,{"DTVEN"	,"AL",2,"D",10,0})
If Right(AllTrim(cDir),1) <> "\"
	cDir := AllTrim(cDir)+"\"
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua Ajuste na Variavel de Nome do Arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Right(AllTrim(cArq),4) <> ".XLSX"
	cArq := AllTrim(cArq) + ".XLSX"
Endif
cFile   := cDir+cArq
AADD(_aStru,{"CTRC"		,"C",09,0})
AADD(_aStru,{"SERCT"	,"C",03,0})
AADD(_aStru,{"CHVCTE"	,"C",44,0})
AADD(_aStru,{"FORNECE"	,"C",06,0})
AADD(_aStru,{"LOJA"		,"C",02,0})
AADD(_aStru,{"NFORI"	,"C",09,0})
AADD(_aStru,{"SERORI"	,"C",03,0})
AADD(_aStru,{"VLRORI"	,"N",14,2})
AADD(_aStru,{"VLRCTR"	,"N",14,2})
AADD(_aStru,{"DTEMI"	,"D",10,0})
AADD(_aStru,{"DTVEN"	,"D",10,0})
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
If Sele("CTR") <> 0
	CTR->(dbCloseArea())
Endif
_cChaveInd	:= "CTRC"
dbUseArea(.T.,,_cArq,"CTR",.F.,.F.)
IndRegua("CTR",_cIndice,_cChaveInd,,,"Selecionando Registros...")
_aStru := {}
AADD(_aStru,{"CTRC"		,"C",009,0})
AADD(_aStru,{"SERCT"	,"C",003,0})
AADD(_aStru,{"CHVCTE"	,"C",044,0})
AADD(_aStru,{"NFORI"	,"C",009,0})
AADD(_aStru,{"SERORI"	,"C",003,0})
AADD(_aStru,{"VLRORI"	,"N",014,2})
AADD(_aStru,{"VLRCTR"	,"N",014,2})
AADD(_aStru,{"LOG"		,"C",100,0})
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
If Sele("CTR2") <> 0
	CTR2->(dbCloseArea())
Endif
_cChaveInd	:= "CTRC"
dbUseArea(.T.,,_cArq,"CTR2",.F.,.F.)
IndRegua("CTR2",_cIndice,_cChaveInd,,,"Selecionando Registros...")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se Conseguiu efetuar a Abertura do Arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ( nHdl >= 0 )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCarrega o Excel e Abre o arquivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	If ( nBytes < 0 )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณErro critico na abertura do arquivo sem msg de erroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MsgStop('Nใo foi possํvel abrir o arquivo : ' + cFile)
		Return
	ElseIf ( nBytes > 0 )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณErro critico na abertura do arquivo com msg de erroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MsgStop(Subs(cBuffer, 1, nBytes))
		Return
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSeleciona a worksheetณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cBuffer := "IMPORTAR" + Space(512)
	ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
	_nSomaLin	:= 0
	For _nElemx		:= 1 To 70000
		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))
		_cCTRC          := VERDADOS(nHdl,'_aCelulas',01,_nSomaLin,.T.)
		_cSerCT       	:= VERDADOS(nHdl,'_aCelulas',02,_nSomaLin,.T.)
		_cChvNfe        := VERDADOS(nHdl,'_aCelulas',03,_nSomaLin,.T.)		
		_cNFORI         := VERDADOS(nHdl,'_aCelulas',04,_nSomaLin,.T.)
		_cSerORI        := VERDADOS(nHdl,'_aCelulas',05,_nSomaLin,.T.) 
		_dDTEMI			:= VERDADOS(nHdl,'_aCelulas',06,_nSomaLin)
		_nVLRORI		:= VERDADOS(nHdl,'_aCelulas',07,_nSomaLin)
		_nVLRCTR		:= VERDADOS(nHdl,'_aCelulas',08,_nSomaLin)
		_dDTVen			:= VERDADOS(nHdl,'_aCelulas',09,_nSomaLin)
		If Empty(_cCTRC)
			Exit
		Endif
		_cNFORI  := IIF(Len(AllTrim(_cNFORI)) < 9, STRZERO(VAL(_cNFORI),9), AllTrim(_cNFORI)) 
		_cSerORI := IIF(Len(AllTrim(_cSerORI)) < 3, STRZERO(VAL(_cSerORI),3), AllTrim(_cSerORI))
		_cCTRC   := IIF(Len(AllTrim(_cCTRC)) < 9, STRZERO(VAL(_cCTRC),9), AllTrim(_cCTRC))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualizando Tabela Temporariaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ATUTRB()
		_nSomaLin++
	Next _nElemx
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFecha o arquivo e remove o excel da memoriaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
Local _nBytesPl	:= 0
Local _cRetorno	:= ""
Local _cBufferPl:= ""
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
_cDescCam	:= _cMatriz+"["+AllTrim(STR(_nElemento))+",1]"
_cColuna	:= _cMatriz+"["+AllTrim(STR(_nElemento))+",2]"
_cLinha		:= _cMatriz+"["+AllTrim(STR(_nElemento))+",3]"
_cTipo		:= _cMatriz+"["+AllTrim(STR(_nElemento))+",4]"
_cTamanho	:= _cMatriz+"["+AllTrim(STR(_nElemento))+",5]"
_cDecimal	:= _cMatriz+"["+AllTrim(STR(_nElemento))+",6]"
_cDescCam	:= &_cDescCam
_cColuna	:= &_cColuna
_cLinha		:= AllTrim(Str(&_cLinha+_nSoma))
_cTipo		:= Upper(&_cTipo)
_cTamanho	:= &_cTamanho
_cDecimal	:= &_cDecimal
_cCelula	:= _cColuna+_cLinha
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua Leitura da Planilhaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cBufferPl	:= _cCelula + Space(1024)
_nBytesPl	:= ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
_cRetorno	:= Subs(_cBufferPl, 1, _nBytesPl)
_cRetorno	:= AllTrim(_cRetorno)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza tratamento do campo  de acordo com o Tipoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If _cTipo == "N" // Numerico
	_cString := ""
	_cNewRet := ""
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString == ","
			_cString := "."
		Endif
		_cNewRet := AllTrim(_cNewRet)+_cString
	Next _nElem
	_cNewRet	:= Val(_cNewRet)
	_cRetorno	:= Round(_cNewRet,_cDecimal)
Endif
If _cTipo == "D" // Data 21/01/2006
	_cRetorno	:= AllTrim(_cRetorno)
	_cNewRet	:= Left(_cRetorno,6)+Right(_cRetorno,2)
	_cRetorno	:= CtoD(_cNewRet)
Endif
If _cTipo == "C" .AND. _lExtrai // Caracter e extra็เo de caracteres
	_cString	:= ""
	_cNewRet	:= ""
	For _nElem	:= 1 To Len(_cRetorno)
		_cString := SubStr(_cRetorno,_nElem,1)
		If _cString $ "#/#,#.#-"
			Loop
		Endif
		_cNewRet := AllTrim(_cNewRet)+_cString
	Next _nElem
	_cRetorno	:= _cNewRet
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta o Tamanho da variavelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If _cTipo == "C"
	_cRetorno := AllTrim(_cRetorno)
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
RecLock("CTR",.T.)
CTR->CTRC		:= _cCTRC
CTR->SERCT		:= _cSerCT
CTR->CHVCTE		:= _cChvNfe
CTR->FORNECE	:= _cFornece
CTR->LOJA		:= _cLoja
CTR->NFORI		:= _cNFORI
CTR->SERORI		:= _cSerORI
CTR->VLRORI		:= _nVLRORI
CTR->VLRCTR		:= _nVLRCTR
CTR->DTEMI		:= _dDtEmi
CTR->DTVEN		:= _dDtVen
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
do While CTR->(!EOf())
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+CTR->FORNECE+CTR->LOJA)
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+CTR->CTRC+CTR->SERCT+SA2->A2_COD+SA2->A2_LOJA)
		GERLOG("CT-E gerado anteriormente. Favor verificar!")
		CTR->(dbSkip())
		Loop
	EndIf
	If Len(AllTrim(CTR->CTRC)) > 9
		GERLOG("Numero CT-E invalido")
		CTR->(dbSkip())
		Loop
	Endif
	If AllTrim(CTR->SERCT) == "0"
		GERLOG("Serie CT-E invalido")
		CTR->(dbSkip())
		Loop
	Endif
	cQrySF2 := " SELECT F2_XAMFRE, F2_VALBRUT AS VALBRUT,Z11_CTRNFE, Z11_SERIE, SF2.R_E_C_N_O_ AS RECSF2 "
	cQrySF2 += " FROM " + RetSqlName("SF2") + " SF2 "  
	cQrySF2 += " LEFT JOIN " + RetSqlName("Z11") + " Z11 ON "
	cQrySF2 += " Z11_FILIAL='"+xFilial("SF2")+"' AND Z11_DOC=F2_DOC "
	cQrySF2 += " AND Z11_SERIES=F2_SERIE AND Z11_CLIENT=F2_CLIENTE AND "
	cQrySF2 += " Z11_LOJA=F2_LOJA AND Z11.D_E_L_E_T_='' "
	cQrySF2	+= " WHERE F2_FILIAL='"+xFilial("SF2")+"' AND "
	cQrySF2 += " F2_DOC = '"+CTR->NFORI+"' AND "
	cQrySF2 += " F2_SERIE ='"+CTR->SERORI+"' AND "
	cQrySF2 += " SF2.D_E_L_E_T_ = ' ' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),"QRYSF2",.T.,.T.)
	If AllTrim(QRYSF2->F2_XAMFRE) == "S"
		If ApMsgYesNo("Nota de Origem "+AllTrim(CTR->NFORI)+" utilizada anteriormente no CT-E "+AllTrim(QRYSF2->Z11_CTRNFE)+". Deseja gerar novamente?","CT-E")
			dbSelectArea("SF2")
			SF2->(dbGoTo(QRYSF2->RECSF2))
			RecLock("SF2",.F.)
			SF2->F2_XAMFRE := ""
			MsUnlock()
		Endif
	Endif
	If QRYSF2->VALBRUT <> CTR->VLRORI
		GERLOG("Nota de origem nใo encontrada ou valor da planilha diverge da nota no sistema")
		CTR->(dbSkip())
		Loop
	Endif
	QRYSF2->(dbCloseArea())
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
CTR2->CTRC   := CTR->CTRC
CTR2->SERCT  := CTR->SERCT
CTR2->CHVCTE := CTR->CHVCTE
CTR2->NFORI  := CTR->NFORI
CTR2->SERORI := CTR->SERORI
CTR2->VLRORI := CTR->VLRORI
CTR2->VLRCTR := CTR->VLRCTR
CTR2->LOG    := _cLog
MsUnlock()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NFECTRC  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
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
Local aArea:=GetArea()
Local aCab 		:= {}
Local aItens   	:= {}
Local aLinha	:= {}
Private _cProduto	:=	""
Private _cTES		:=	""
Private lMsErroAuto := .F.
dbSelectArea("CTR")
dbGoTop()
do While CTR->(!EOf())
	dbSelectArea("CTR2")
	If !dbSeek(CTR->CTRC)
		If CTR->VLRCTR > 0
			dbSelectArea("SA2")
			dbSetOrder(1)
			If dbSeek(xFilial("SA2")+CTR->FORNECE+CTR->LOJA)
				_cProduto	:= IIF(SA2->A2_EST=="SP","800017","800041")
//				_cTES		:= IIF(SA2->A2_EST=="SP","215","273")
				_cTES		:= IIF(SA2->A2_EST=="SP","280","273")
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+_cProduto)
				aCab := {}
				aCab := {;
					{"F1_TIPO"		,"N"			,Nil},;
					{"F1_FILIAL"	,xFilial("SF1")	,Nil},;
					{"F1_FORMUL"	,"N"			,Nil},;
					{"F1_EMISSAO"	,CTR->DTEMI		,Nil},;
					{"F1_DTDIGIT"	,dDataBase		,Nil},;
					{"F1_FORNECE"	,SA2->A2_COD	,Nil},;
					{"F1_LOJA"		,SA2->A2_LOJA	,Nil},;
					{"F1_CHVNFE"	,CTR->CHVCTE	,Nil},;
					{"F1_SERIE"		,CTR->SERCT		,Nil},;
					{"F1_DOC"		,CTR->CTRC		,Nil},;
					{"F1_ESPECIE"	,"CTE"			,Nil} ;
				}
				aLinha := {}
				aLinha := {;
					{"D1_COD"		,_cProduto		,Nil},;
					{"D1_FILIAL"	,xFilial("SD1")	,Nil},;
					{"D1_ITEM"		,"0001"			,Nil},;
					{"D1_UM"		,SB1->B1_UM		,Nil},;
					{"D1_QUANT"		,1				,Nil},;
					{"D1_VUNIT"		,CTR->VLRCTR	,Nil},;
					{"D1_TOTAL"		,CTR->VLRCTR	,Nil},;
					{"D1_DOC"		,CTR->CTRC		,Nil},;
					{"D1_SERIE"		,CTR->SERCT		,Nil},;
					{"D1_TES"		,_cTes			,Nil},;
					{"D1_FORNECE"	,SA2->A2_COD	,Nil},;
					{"D1_LOJA"		,SA2->A2_LOJA	,Nil},;
					{"D1_EMISSAO"	,dDataBase		,Nil},;
					{"D1_DTDIGIT"	,dDataBase		,Nil},;
					{"D1_TIPO"		,"N"			,Nil},;
					{"D1_LOCAL"		,SB1->B1_LOCPAD	,Nil},;
					{"D1_CONTA"		,SB1->B1_CONTA	,Nil},;
					{"D1_CC"		,"1093"			,Nil} ;
				}
				aItens := {}
				AAdd( aItens, aLinha )
				If (Len(aCab) > 0) .And. (Len(aItens) > 0)
					dbSelectArea("SE2")
					MSExecAuto( {|x,y,z,w| MATA103( x, y, z, w ) }, aCab, aItens, 3, .F. )
					If lMsErroAuto
						GERLOG("Erro na grava็ใo do CTRC. Favor verificar!")
					Else
						aAreaAtu := GetArea()
						GERLOG("CTRC gerado com sucesso!")
						ATUCTR()
						dbSelectArea("SE2")
            			dbsetorder(6)
            			dbGoTop()
            			If dbseek(xFilial("SE2")+SA2->A2_COD+SA2->A2_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
               				Reclock("SE2",.F.)
              				 SE2->E2_VENCTO		:= CTR->DTVEN
              				 SE2->E2_VENCREA	:= CTR->DTVEN
              				MsUnlock()
            			EndIf						
            			RestArea(aAreaAtu)
					Endif
				Endif
			Endif
		Else
			GERLOG("Valor do CTRC nใo informado na planilha. Favor verificar!")
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
cQrySF2 := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO, F2_CLIENTE,F2_LOJA,F2_VALBRUT, R_E_C_N_O_ AS RECSF2 "
cQrySF2 += "FROM " + RetSqlName("SF2") + " SF2 "
cQrySF2	+= "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND "
cQrySF2	+= " F2_XAMFRE <> 'S' AND "
cQrySF2 += " F2_DOC ='"+CTR->NFORI+"' AND "
cQrySF2 += " F2_SERIE ='"+CTR->SERORI+"' AND "
cQrySF2 += " SF2.D_E_L_E_T_ = ' ' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),"QRYSF2",.T.,.T.)
TcSetField("QRYSF2","F2_EMISSAO","D",10,0)
TcSetField("QRYSF2","F2_VALBRUT","N",14,2)
dbSelectArea("QRYSF2")
dbGoTop()
do While QRYSF2->(!EOF())
	dbSelectArea("Z11")
	RecLock("Z11",.T.)
	Z11->Z11_FILIAL  := xFilial("Z11")
	Z11->Z11_CTRNFE  := SF1->F1_DOC
	Z11->Z11_SERIE   := SF1->F1_SERIE
	Z11->Z11_EMISSAO := dDataBase
	Z11->Z11_DIGIT   := dDataBase
	Z11->Z11_FORNECE := SF1->F1_FORNECE
	Z11->Z11_LOJA    := SF1->F1_LOJA
	Z11->Z11_DOC     := QRYSF2->F2_DOC
	Z11->Z11_SERIES  := QRYSF2->F2_SERIE
	Z11->Z11_EMISNFV := QRYSF2->F2_EMISSAO
	Z11->Z11_CLIENT  := QRYSF2->F2_CLIENTE
	Z11->Z11_LOJACLI := QRYSF2->F2_LOJA
	Z11->Z11_VLRNFV  := QRYSF2->F2_VALBRUT
	MsUnlock()
	dbSelectArea("SF2")
	SF2->(dbGoTo(QRYSF2->RECSF2))
	RecLock("SF2",.F.)
	SF2->F2_XAMFRE := "S"
	MsUnlock()
	QRYSF2->(dbSkip())
EndDo
QRYSF2->(dbCloseArea())
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se relatorios personalizaveis esta disponivelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If TRepInUse()
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
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSection
oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")
oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"CTR2"})
TRCell():New(oSection1,"CTRC","CTR2","CTRC","@!",09)
TRCell():New(oSection1,"SERCT","CTR2","SERIE CTRC","@!",03)
TRCell():New(oSection1,"NFORI","CTR2","NF ORIGEM","@!",09)
TRCell():New(oSection1,"SERORI","CTR2","SERIE NF ORIGEM","@!",03)
TRCell():New(oSection1,"VLRORI","CTR2","VLR ORIGEM","@E 99,999,999.99",20)
TRCell():New(oSection1,"VLRCTR","CTR2","VLR ORIGEM","@E 99,999,999.99",20)
TRCell():New(oSection1,"LOG","CTR2","LOG","@!",100)
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor ณMicrosiga           บ Data ณ    /  /     บฑฑ
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime Titulo antes do Totalizador da Secao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSection1:SetTotalText("Total Geral  ")
oReport:OnPageBreak(,.T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressao da Primeira secaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("CTR2")
dbGoTop()
oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
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
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
cPerg			:= PADR(cPerg,Len(sx1->x1_grupo))
AAdd(aHelpPor,"Diretorio ( Pasta ) que se encontra ")
AAdd(aHelpPor,"a Planilha Excel")
PutSx1(cPerg,"01","Diretorio do arquivo ","Diretorio do arquivo","Diretorio do arquivo","mv_ch1","C",30,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
aHelpPor :={}
AAdd(aHelpPor,"Nome do Arquivo Excel a Ser Importado")
PutSx1(cPerg,"02","Nome do Arquivo ","Nome do Arquivo","Nome do Arquivo","mv_ch2","C",30,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
Return