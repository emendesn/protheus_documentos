#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH" 
#include 'TOPCONN.ch' 
#INCLUDE "Fileio.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BGHIMPBLC()
               
Local oDlg     		:= Nil
Local oGet     		:= Nil
Local nOpcao        := 0 
Local _aRetGroup	:= {}
Local _lUser		:= .F.

Private nOpca 		:= 0
Private _cMsg	  	:= "Usuario sem acesso. Entre em contato com o Administrador!" 
Private cLogError	:= ""
Private cType 		:= "Planilha XLSX (*.XLSX) | *.XLSX | "
Private cArq		:= "" 
Private cFile		:= ""
 
// Defino a ordem
PswOrder(2) // Ordem de nome
     
// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
If PswSeek(cUsername,.F.) 
   // Obtenho o resultado conforme vetor
   _aRetGroup := PswRet(1)   
	If !Empty(_aRetGroup[1][10][1])
		For nx:=1 To Len(_aRetGroup[1][10])
        	If _aRetGroup[1][10][nx] == '000068' //IMBQNEXTEL - Importação Bloco Peças Nextel
        		_lUser := .T.
        		Exit
        	EndIf	 
		Next nx 
	EndIf           
EndIf

If !_lUser
	MsgAlert(_cMsg)
	Return
Endif

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Importação Bloco de Peças Nextel") PIXEL
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina efetua a importação do bloco de Peças Nextel") SIZE 268, 8 OF oDlg PIXEL
@ 38, 15 SAY OemToAnsi("utilizando os itens existentes na planilha.") SIZE 268, 8 OF oDlg PIXEL
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	MsAguarde({|| ImpBLC()},OemtoAnsi("Processando itens da Planilha"))
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpBLC  ³ Autor ³ DeltaDecisao          ³ Data ³ 29/03/11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 												               ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpBLC()

Local cCamDLL      		:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.5\Microsiga\protheus_data\dll\readexcel.dll") 
Local nHdl	 	   		:= ExecInDLLOpen(cCamDLL)
Local cBuffer			:= ""
Local _cProduto  		:= ""
Local _cPedido   		:= ""  
Local _cItemPed			:= ""
Local _cPO		   		:= ""
Local _cItPO   			:= ""

Private _aCelulas		:= {}
Private _aPO   			:= {}

cFile := cGetFile(cType,OemToAnsi("Selecione o arquivo a ser importado"),0,,.F.,GETF_LOCALHARD,.F.,.F.) 

// Montagem das Celulas
AADD(_aCelulas,{'PRODUTO            ',"A",2,'C',15,0})
AADD(_aCelulas,{'NUM. PEDIDO        ',"J",2,'C',06,0}) 
AADD(_aCelulas,{'ITEM PEDIDO        ',"K",2,'C',02,0})
AADD(_aCelulas,{'PO                 ',"P",2,'C',15,0})
AADD(_aCelulas,{'NUMERO DA LINHA    ',"Q",2,'C',06,0})

// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )
	
	// Carrega o Excel e Abre o arquivo
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
	If ( nBytes < 0 )
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Não foi possível abrir o arquivo : ' + cFile)
		Return
	ElseIf ( nBytes > 0 )
		// Erro critico na abertura do arquivo com msg de erro
		MsgStop(Subs(cBuffer, 1, nBytes))
		Return
	EndIf
	
	// Seleciona a worksheet
	cBuffer := "Bloco Peças PV-SERVICO" + Space(512)
	ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
	_nSomaLin	:= 0
	
	For _nElemx		:= 1 To 70000
		
		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))
		
		_cProduto  := VERDADOS(nHdl,'_aCelulas',01,_nSomaLin)		
		_cPedido   := VERDADOS(nHdl,'_aCelulas',02,_nSomaLin)
		_cItemPed  := VERDADOS(nHdl,'_aCelulas',03,_nSomaLin)
		_cPO	   := VERDADOS(nHdl,'_aCelulas',04,_nSomaLin)
		_cItPO     := VERDADOS(nHdl,'_aCelulas',05,_nSomaLin)
		
		If Empty(_cPedido)
			Exit
		Endif
		
		_cProduto	:= _cProduto+Space(15-Len(_cProduto))
		_cPedido	:= _cPedido+Space(06-Len(_cPedido)) 
		_cItemPed	:= _cItemPed+Space(02-Len(_cItemPed))
		_cPO		:= _cPO+Space(15-Len(_cPO))
		_cItPO		:= _cItPO+Space(06-Len(_cItPO))
		
		_aPO := {}
		AADD(_aPO,_cProduto)
		AADD(_aPO,_cPedido)
		AADD(_aPO,_cItemPed)
		AADD(_aPO,_cPO)
		AADD(_aPO,_cItPO)
		
		If 	len(_aPO) > 0
			Processa({|| ImpSC6() },"Efetuando importação...")
		Endif
		
		_nSomaLin++
	Next _nElemx
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	
	If !Empty(cLogError)
		ConsoleLog(cLogError)
		//MsgInfo(cLogError)
	EndIf	
	
Else
	MsgStop('Nao foi possivel carregar a DLL')
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERDADOS   ºAutor  ³Delta Decisao      º Data ³  21/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o Conteudo de Uma celula na planilha Excel         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

If _cTipo =='C' .AND. _lExtrai // Caracter e extraçào de caracteres
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpSC6 ºAutor  ³Vinicius Leonardo		 º Data ³  29/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua alteracao do campo do P.O. e item                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpSC6()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.
Local aArea	 := GetArea()      

Private lMsErroAuto := .F.
Private lMsHelpAuto := .F. 

If Select("SC6") == 0
	DbSelectArea("SC6")
EndIf
SC6->(DbSetOrder(1))
SC6->(DbGoTop())   

If SC6->(DbSeek(xFilial("SC6")+_aPO[2]+_aPO[3]+_aPO[1])) 

	If Empty(SC6->C6_NOTA)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
		//| Teste de alteracao                                           | 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		/*aCabec := {} 
		aItens := {} 
		aadd(aCabec,{"C5_NUM",SC6->C6_NUM,Nil}) 		
		
		aLinha := {}
		aadd(aLinha,{"LINPOS"		,"C6_ITEM"		,SC6->C6_ITEM})
		aadd(aLinha,{"AUTDELETA"	,"N"			,Nil}) 
		aadd(aLinha,{"C6_QTDLIB"	,SC6->C6_QTDVEN	,Nil})
		aadd(aLinha,{"C6_NUMPCOM"	,_aPO[4]		,Nil})  
		aadd(aLinha,{"C6_ITEMPC" 	,_aPO[5]		,Nil})   
		aadd(aItens,aLinha)		
	 
		//Altera Pedido de Venda
		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec, aItens, 4)
		
		If lMsErroAuto	
			DisarmTransaction()
			//Mostraerro()
			cLogError += "Ocorreu um erro na atualização do PV:" + Alltrim(_aPO[2]) + " Item: " + Alltrim(_aPO[3]) + " Produto: " + Alltrim(_aPO[1]) + CRLF
		Else
			cLogError += "Atualização do PV:" + Alltrim(_aPO[2]) + " Item: " + Alltrim(_aPO[3]) + " Produto: " + Alltrim(_aPO[1]) + CRLF
		EndIf*/
		If RecLock("SC6",.F.)		    
			SC6->C6_NUMPCOM := _aPO[4]
			SC6->C6_ITEMPC  := _aPO[5]
		
			SC6->(msunlock())
		Else
			cLogError += "Ocorreu um erro na atualização do PV:" + Alltrim(_aPO[2]) + " Item: " + Alltrim(_aPO[3]) + " Produto: " + Alltrim(_aPO[1]) + CRLF			
		EndIf
		
	Else
		cLogError += "PV: " + Alltrim(_aPO[2]) + " já foi faturado." + CRLF		
	EndIf	
Else
	cLogError += "PV: " + Alltrim(_aPO[2]) + " Item: " + Alltrim(_aPO[3]) + " Produto: " + Alltrim(_aPO[1]) + CRLF
EndIf	

RestArea(aArea)

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpSC6 ºAutor  ³Vinicius Leonardo		 º Data ³  29/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua alteracao do campo do P.O. e item                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function ConsoleLog(cMsg)
 
Private cArqTxt := "\LogBlq.TXT"
 
Private nHdl := 0
 
//Verifica se o arquivo existe
 
if !file(cArqTxt)
 
	nHdl := fCreate(cArqTxt)
 
	if nHdl == -1 
		MsgAlert("O arquivo de nome "+cArqtxt+" nao pode ser executado ! Verifique os parametros.","Atenção !")	 
		Return	 
	Endif
	 
	if nHdl <> -1	 
		//Grava no arquivo texto	 
		if fWrite(nHdl,cMsg,Len(cMsg)) != Len(cMsg)	 
			if !MsgAlert("Ocorreu um erro na gravacao do arquivo." + "Continua !","Atencao !")	 
				Return(.F.)	 
			endif	 
		endif	 
	endif 
else 
	// Abre o arquivo de Origem
	 
	nHdl := fOpen(cArqTxt,1)
	// Testa a abertura do Arquivo
	 
	If nHdl == -1	 
		MsgStop('Erro ao abrir origem. Ferror = '+str(ferror(),4),'Erro')	 
		Return .F.	 
	Endif
	 
	fSeek(nHdl,0,2)
	 
	//Grava no arquivo texto
	 
	if fWrite(nHdl,cMsg,Len(cMsg)) != Len(cMsg)	 
		if !MsgAlert("Ocorreu um erro na gravacao do arquivo." + "Continua !","Atencao !")	 
			Return(.F.)	 
   		endif	 
	endif	 
endif
 
//Fecha o arquivo texto
 
If !fClose(nHdl) 
	Conout( "Erro ao fechar arquivo, erro numero: ", FERROR() ) 
EndIf
 
Return(.T.)
 