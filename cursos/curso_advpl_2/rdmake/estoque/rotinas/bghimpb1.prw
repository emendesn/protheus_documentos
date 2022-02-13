#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BGHIMPB1   บAutor  ณLuciano Siqueira	 บ Data ณ  09/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que importa um arquivo txt ou excel para o cadastro บฑฑ
ฑฑบ          ณ de Centro de Produto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH               				                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function BGHIMPB1()

Local aSays			:= {}
Local aButtons		:= {}
Local nOpca			:= 0
Local cCadastro		:= "Importa Cadastro de Produto"

//Texto da tela principal.
AADD(aSays, " Este programa irแ ler o conte๚do de um arquivo .TXT ou excel 				" )
AADD(aSays, " de acordo com layout definido. O arquivo .TXT deverแ ser delimitador 		" )
AADD(aSays, " por | (Pipeline). Depois de lido o arquivo, a rotina farแ as   			" )
AADD(aSays, " grava็๕es na tabela de Produto.    							    	    " )
AADD(aSays, " Ao final da importa็ใo o sistema apresentarแ o status.  			        " )

//Insere os bot๕es na tela e adiciona fun็๕es a eles.
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch()	 		}} )
AADD(aButtons, { 2,.T.,{|| nOpca:= 0, FechaBatch() 		}} )

//Cria a tela com os bot๕es.
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| OkLeTxt() })
EndIf

Return

Static Function OkLeTxt

Local 	 cTitulo  	   := "Selecione a planilha de Condicao de Pagto
Local 	 cExtens       := "Excel 							  | *.xlsx | "
Local 	 cExtens       += "Arquivos Texto					  | *.txt  | "
Local    cExtens       += "Todos os Arquivos 				  | *.*    | "
Local    _cBuffer      := ""
Private  _aDados       := {}     && Vetor com os dados dos campos.
Private  _cNomeArq     := ""
Private  _nCount	   := 0
Private  _nContGrav    := 0
Private  _cDelimitador := "|"
Private  _aDadosLinha  := {}
Private  _Status       := ""
Private  cExtArq	   := ""

//Abre janela para escolha do arquivo a ser processado
_cNomeArq 	:= cGetFile(cExtens,cTitulo,0,,.F.,GETF_ONLYSERVER+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_OVERWRITEPROMPT)

If Empty(_cNomeArq) //Verifica se o arquivo foi selecionado
	Return
EndIf

If UPPER(Right(Alltrim(_cNomeArq),3))=="TXT"
	cExtArq := "TXT"
	cCnpjCli := LEFT(UPPER(Right(Alltrim(_cNomeArq),26)),8)
ElseIf UPPER(Right(Alltrim(_cNomeArq),3))=="XLS"
	cExtArq := "XLS"
	cCnpjCli := LEFT(UPPER(Right(Alltrim(_cNomeArq),26)),8)
ElseIf UPPER(Right(Alltrim(_cNomeArq),4))=="XLSX"
	cExtArq := "XLSX"
	cCnpjCli := LEFT(UPPER(Right(Alltrim(_cNomeArq),27)),8)
Endif

dbSelectArea("SZY")
dbSetOrder(1)
If !dbSeek(xFilial("SZY")+cCnpjCli,.F.)
	MsgAlert("CNPJ nใo cadastrado na tabela SZY ou nomenclatura do arquivo nใo confere com layout. Favor verificar!")
	Return
Endif


If cExtArq =="TXT"
	
	FT_FUSE(_cNomeArq) //Abre o arquivo
	FT_FGOTOP() //Posiciona na primeira linha
	
	While !FT_FEOF()  //Faz enquanto arquivo nใo acabar
		_nCount++
		IncProc( "Lendo Arquivo ")  //Progresso
		
		_cBuffer	 :=  FT_FREADLN() //Leitura da Linha
		_aDadosLinha := Split(_cBuffer,_cDelimitador)  //Faz o tratamento da linha e tem um retorno no array _aDadosLinha
		
		Aadd(_aDados,_aDadosLinha) //Grava a linha de dados no array principal para grava็ใo posterior da tabela
		
		FT_FSKIP() //Pula para o pr๓ximo registro
	EndDo
ElseIf cExtArq=="XLS" .OR. cExtArq=="XLSX"
	 MsAguarde({|| fImpExcel()},OemtoAnsi("Aguarde Efetuando Importa็ใo da Planilha"))
Else
	MsgAlert("Exten็ใo do arquivo selecionado nใo existente no layout. Favor verificar!")
	Return
Endif

GrvDados()  //Rotina que farแ a atualiza็ใo do contrato.

_Status += +CRLF+ "Total de Registros Lidos no Arquivo: " + StrZero(_nCount,6) + CRLF
_Status += 		   "Total de Registros gravados........: " + StrZero(_nContGrav,6) + CRLF
AVISO("Status da Atualiza็ใo",_Status,{"OK"},3)


RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPEXCEL บAutor  ณLuciano Siqueira    บ Data ณ  13/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta planilha Cadastro de Produto                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FImpExcel()

Local cCamDLL	:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.5\Microsiga\Protheus_Data\dll\readexcel.dll")
Local nHdl 		  := ExecInDLLOpen(cCamDLL)
Local cBuffer	  := ''
Private _aCelulas := {}

If !File(_cNomeArq)
	MsgStop("O arquivo " + _cNomeArq + " nใo foi encontrado. A rotina serแ abortada!","ATENCAO")
	Return
EndIf

/*
1-Codigo do Produto
2-Descricao do Produto
3-Tipo de Produto
4-Unidade de Medida
5-Pos.IPI/NCM
6-Origem do produto
7-Segunda Unidade de Medida
8-Fator de Conversao de UM
9-Tipo de Conversao da UM
10-Peso Liquido
11-Peso Bruto
12-Codigo de Barras
13-Categoria de Produto
*/

AADD(_aCelulas,{'PRODUTO              ',"A",2,'C',15,0}) 
AADD(_aCelulas,{'DESCRICAO            ',"B",2,'C',30,0}) 
AADD(_aCelulas,{'TIPO                 ',"C",2,'C',02,0}) 
AADD(_aCelulas,{'UM		              ',"D",2,'C',02,0}) 
AADD(_aCelulas,{'NCM 	              ',"E",2,'C',10,0}) 
AADD(_aCelulas,{'ORIGEM               ',"F",2,'C',01,0}) 
AADD(_aCelulas,{'SEGUM                ',"G",2,'C',02,0}) 
AADD(_aCelulas,{'FATOR                ',"H",2,'N',05,2}) 
AADD(_aCelulas,{'TIPOCONV             ',"I",2,'C',01,0}) 
AADD(_aCelulas,{'PESOL                ',"J",2,'N',18,8}) 
AADD(_aCelulas,{'PESOB                ',"K",2,'N',18,8}) 
AADD(_aCelulas,{'CODBAR               ',"L",2,'C',15,0}) 
AADD(_aCelulas,{'CATEGORIA            ',"M",2,'C',01,0}) 


// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )    
    
	// Carrega o Excel e Abre o arquivo
	
	cBuffer := _cNomeArq + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
	If ( nBytes < 0 )                    
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Nใo foi possํvel abrir o arquivo : ' + _cNomeArq)
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
		_cProduto	:= VERDADOS(nHdl,'_aCelulas',01,_nSomaLin)
		_cDescri   	:= VERDADOS(nHdl,'_aCelulas',02,_nSomaLin)
		_cTipo	   	:= VERDADOS(nHdl,'_aCelulas',03,_nSomaLin)
		_cUM		:= VERDADOS(nHdl,'_aCelulas',04,_nSomaLin)
		_cNCM		:= VERDADOS(nHdl,'_aCelulas',05,_nSomaLin)
		_cOrigem	:= VERDADOS(nHdl,'_aCelulas',06,_nSomaLin)
		_cSegum		:= VERDADOS(nHdl,'_aCelulas',07,_nSomaLin)
		_nFator		:= VERDADOS(nHdl,'_aCelulas',08,_nSomaLin)
		_cTipoConv  := VERDADOS(nHdl,'_aCelulas',09,_nSomaLin)
		_nPesol		:= VERDADOS(nHdl,'_aCelulas',10,_nSomaLin)
		_nPesoB		:= VERDADOS(nHdl,'_aCelulas',11,_nSomaLin)
		_cCodBar    := VERDADOS(nHdl,'_aCelulas',12,_nSomaLin)
		_cCategoria := VERDADOS(nHdl,'_aCelulas',13,_nSomaLin)
	
		_nSomaLin++
		If Empty(_cProduto)
			Exit		
		Endif
		_nCount++
		aAdd(_aDados,{	_cProduto, _cDescri, _cTipo, _cUM, _cNCM, _cOrigem,;
		 _cSegum, _nFator, _cTipoConv, _nPesol, _nPesoB,_cCodBar,_cCategoria })
		
			
	Next _nElemx
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)	
	ExecInDLLClose(nHdl)	
Else
    MsgStop('Nao foi possivel carregar a DLL')
EndIf

Return


Static Function GrvDados()

IncProc( "Processando")  //Progresso

For nx := 1 to Len(_aDados)
	lMsErroAuto := .F.
	aVetor := {}
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB1")+_aDados[nx][01],.F.)
		dbSelectArea("SZY")
		dbSetOrder(1)
		If dbSeek(xFilial("SZY")+cCnpjCli+_aDados[nx][13])
			aVetor:= {{"B1_COD"    ,_aDados[nx][01],Nil},;
			{"B1_DESC"    ,_aDados[nx][02],Nil},;
			{"B1_TIPO" 	  ,_aDados[nx][03],Nil},;
			{"B1_LOCPAD"  ,SZY->ZY_LOCPAD ,Nil},;
			{"B1_GRUPO"   ,SZY->ZY_GRUPO  ,Nil},;
			{"B1_UM"      ,_aDados[nx][04],Nil},;
			{"B1_SEGUM"   ,_aDados[nx][07],Nil},;
			{"B1_CONV"    ,IIF(cExtArq=="TXT",Val(_aDados[nx][08]),_aDados[nx][08]),Nil},;
			{"B1_TIPCONV" ,_aDados[nx][09],Nil},;
			{"B1_PESO"	  ,IIF(cExtArq=="TXT",Val(_aDados[nx][10]),_aDados[nx][10]),Nil},;
			{"B1_PESBRU"  ,IIF(cExtArq=="TXT",Val(_aDados[nx][11]),_aDados[nx][11]),Nil},;
			{"B1_POSIPI"  ,_aDados[nx][05],Nil},;
			{"B1_ORIGEM"  ,_aDados[nx][06],Nil},;
			{"B1_CODBAR"  ,_aDados[nx][12],Nil},;
			{"B1_LOCALIZ" ,SZY->ZY_LOCALIZ,Nil},;
			{"B1_RASTRO"  ,SZY->ZY_RASTRO ,Nil},;
			{"B1_GARANT"  ,SZY->ZY_GARANT ,Nil},;
			{"B1_CONTA"   ,SZY->ZY_CONTA  ,Nil},;
			{"B1_CODLINH" ,SZY->ZY_CODLINH,Nil},;
			{"B1_CODMARC" ,SZY->ZY_CODMARC,Nil},;
			{"B1_CODFAMI" ,SZY->ZY_CODMARC,Nil},;
			{"B1_CODSUBF" ,SZY->ZY_CODSUBF,Nil},;
			{"B1_SHCN" 	  ,SZY->ZY_SHCN   ,Nil},;
			{"B1_ESTOCAV" ,SZY->ZY_ESTOCAV,Nil}}
			
			Processa({|| ImpSB1(aVetor)},"Gerando Produto...")
		Else
		  	MsgAlert("CNPJ+Categoria "+cCnpjCli+"-"+_aDados[nx][13]+" nใo cadastrado na tabela SZY. Favor verificar!")		
		Endif
	//Else
	  //	MsgAlert("Produto "+Alltrim(_aDados[nx][01])+" Cadastrado anteriormente. Favor verificar!")		
	Endif
	
Next


Return(.T.)

Static Function ImpSB1(_aGeraSb1)

Private lMsErroAuto := .f.

MSExecAuto({|x,y| Mata010(x,y)},_aGeraSb1,3) 

If lMsErroAuto
	MostraErro()
//	MsgAlert("Erro na grava็ใo do produto "+_aGeraSb1[1][2]+". Favor verificar!")		
Else
	_nContGrav++
Endif

Return(!lMsErroAuto)

Static Function Split(cStr,cChar)

Local cCampo
Local cLinha
Local nLen
Local nI
Local aRet := {}

cLinha := cStr

nI := AT(cChar, cLinha)
While nI > 0
	If nI <> 1
		cCampo := Substr(cLinha,1,nI-1)
		aadd(aRet,cCampo)
	Else	
		aadd(aRet,"")	
	Endif
	nLen := Len(cLinha)
	cLinha := Substr(cLinha,nI+1,nLen-nI)
	nI := AT(cChar, cLinha)
EndDo
if len(cLinha)>0
	aadd(aRet,cLinha)
endif

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERDADOS   บAutor  ณEduardo Barbosa     บ Data ณ  22/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Conteudo de Uma celula na planilha Excel         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ZATIX                                                      บฑฑ
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