#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
                                   

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHIMPSA5  ºAutor  ³ Robson Sanchez     º Data ³ 	 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para tratamento Importação dados SA5                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     
User Function IMPSA5()
	Local cFunction    := FunName()
	Local cTitle       := "Importação da Planilha em Excel"
	Local cDescription := "Este programa tem por objetivo, ler as planilhas dos Produtos IDEN,MD,OUTROS  e grava-los no Microsiga Protheus"

	Local bProcess     := { |ExpO1| U_ImpXLS( ExpO1,cTitle,MV_PAR01,Alltrim(MV_PAR02) ) }
	Local aInfoCustom  := {}
	Local cPerg        := "IMPSA5"
	Local aHelp        := {}
	Local cDirTXT      := ""

	Private __cFileCSV
	Private nPrecUnit := 0
	Private cCodiProd := ""
	Private cCodiOper := "01"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicao de perguntas ao SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
aHelp := {}
AAdd( aHelp, 'Informe o diretório de onde se encontra   ' )
AAdd( aHelp, 'os arquivos de pedidos de vendas enviados ' )
AAdd( aHelp, 'para faturamento para serem importados    ' )
AAdd( aHelp, 'para o Microsiga Protheus                 ' )
AAdd( aHelp, '( Ex: C:\PEDIDOS\ )                       ' )
PutSX1( cPerg,"01","Origem dos Arquivos?","Origem dos Arquivos?","Origem dos Arquivos?","mv_ch1","C",99,0,1,"C","","Z01","","","mv_par01","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)
*/
	aHelp := {}
	AAdd( aHelp, 'Informe o Tipo de Produto a importar.  ' )
	AAdd( aHelp, ' As opçoes são "IDEN , MD, OUTROS" ( Ex: IDEN )   ' )

	PutSX1( cPerg,"01", "Tipo Produto?","Tipo Produto?","Tipo Produto?","mv_ch1","C",99,0,1,"C","","","","","mv_par01","IDEN","IDEN","IDEN","","MD","MD","MD","OUTROS","OUTROS","OUTROS","","","","","","",aHelp,aHelp,aHelp)
	PutSX6( "ES_IMPSA5","C:\BGH\SA5\" )

	cDirXLS := GetNewPar("ES_IMPSA5","C:\BGH\SA5\")


	aHelp := {}
	AAdd( aHelp, 'Informe o Arquivo a ser importado           ' )
	AAdd( aHelp, 'para o Microsiga Protheus                   ' )
	PutSX1( cPerg,"02","Nome do Arquivo?","Nome do Arquivo?","Nome do Arquivo?","mv_ch2","C",99,0,1,"C","","Z01","","","mv_par02","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)


	aHelp := {}
	AAdd( aHelp, 'Informe fornecedor  ' )
	PutSx1(cPerg,'03','Fornecedor ?' ,'Fornecedor ?','Fornecedor ?','mv_ch3','C',TamSX3("A2_COD")[1],,0,'G','','FOR','','',"mv_par03","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	aHelp := {}
	AAdd( aHelp, 'Informe loja do fornecedor ' )
	PutSx1(cPerg,'04','Loja ' ,'Loja ?','Loja ?','mv_ch4','C',TamSX3("A2_LOJA")[1],,0,'G','','','','',"mv_par04","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicao de Consulta Padrao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_PutSXB("Z01","1","01","RE","Selecione o Arquivo","Selecione o Arquivo","Selecione o Arquivo","SX5","")
	U_PutSXB("Z01","2","01","01","                   ","                   ","                   ","U_AbreExp(184,Nil)","")
	U_PutSXB("Z01","5","01","  ","                   ","                   ","                   ","U_RetExp()","")

	tNewProcess():New(cFunction,cTitle,bProcess,cDescription,cPerg,aInfoCustom )

	Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDIImpPed ºAutor  ³ Robson Sanchez     º Data ³ 25/01/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao dos arquivos no Pedido de Venda                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EDIXFUN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpXLS( oRegua,cTitle,nTipoProd,cFileXLS )
Local cTipoProd :=""
Local cCamDLL      		:= Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
//Local nHdl	 	   		:= ExecInDLLOpen(cCamDLL)
Local nHdl              := ExecInDLLOpen("C:\bgh\readexcel.dll")
Local cBuffer			:= ''                      

Local cArqLog

Local cPRODVIEW
Local cGROUPID
Local cSOURCE
Local cORDERABLE
Local cSUBSTITUTE
Local cDESCRIPTION
Local cCURRENCY
Local nLISTPRICE
Local nYOURPRICE
Local nBESTPRICE
Local nQUANTITY
Local cITEMTYPE
Local cUNIT
Local nPROP

Local cForn
Local cFabr
Local cLojFo
Local cLojFab

Private aCelulas		:= {}

If nTipoProd == nil
	cTipoProd:="1"
Else
	cTipoProd:=Str(nTipoProd,1)
Endif

If Empty( cFileXLS )
	U_MsgHBox("Nome do Arquivo nao Informado")
	Return Nil
EndIf

If ! File( cFileXLS )
	U_MsgHBox("Arquivo nao encontrado com este nome")
	Return Nil
EndIf
               
If Empty( mv_par03 ) .or. Empty( mv_par04 ) 
	U_MsgHBox("Fornecedor/Loja devem ser informados")
	Return Nil
Endif

SA2->(dbsetorder(1))   
If ! SA2->(dbseek(xFilial("SA2")+mv_par03+mv_par04))
	U_MsgHBox("Fornecedor/Loja não encontrados com este codigo")
	Return Nil
Endif
               
cArqLog := CriaTrab(Nil,.F.)+"_"+If(cTipoProd=="1","IDEN",If(cTipoProd=="2","MD","OUTROS"))+".log"

If File(cArqLog)
	FErase(cArqLog)
EndIf
  
AcaLog( cArqLog, "Fornecedor: "+Alltrim(mv_par03)+"/"+Alltrim(mv_par04) )


// Montagem das Celulas
AADD(aCelulas,{'PRODVIEW'   ,"A",2,'C',15,0})
AADD(aCelulas,{'GROUPID'    ,"B",2,'C',05,0})
AADD(aCelulas,{'SOURCE'     ,"C",2,'C',10,0})
AADD(aCelulas,{'ORDERABLE'  ,"D",2,'C',02,0})
AADD(aCelulas,{'SUBSTITUTE' ,"E",2,'C',15,0})
AADD(aCelulas,{'DESCRIPTION',"F",2,'C',60,0})
AADD(aCelulas,{'CURRENCY'   ,"G",2,'C',03,0})
AADD(aCelulas,{'LISTPRICE'	,"H",2,'N',15,5}) 	 
AADD(aCelulas,{'YOURPRICE'	,"I",2,'N',15,5})	 
AADD(aCelulas,{'BESTPRICE'	,"J",2,'N',15,5})
AADD(aCelulas,{'QUANTITY'	,"K",2,'N',13,3})	
AADD(aCelulas,{'ITEMTYPE'	,"L",2,'C',03,0})	
AADD(aCelulas,{'UNIT'		,"M",2,'C',03,0})
AADD(aCelulas,{'PROP'		,"N",2,'N',03,0})                

SA5->(dbsetorder(2))
SB1->(dbsetorder(1))

// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )
	
	// Carrega o Excel e Abre o arquivo
	cBuffer := cFileXLS + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
	If ( nBytes < 0 )
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Não foi possível abrir o arquivo : ' + cFileXLS)
		Return
	ElseIf ( nBytes > 0 )
		// Erro critico na abertura do arquivo com msg de erro
		MsgStop(Subs(cBuffer, 1, nBytes))
		Return
	EndIf
	
	// Seleciona a worksheet
	cBuffer := "IMPORTAR" + Space(512)
	xBytes:=ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
	_nSomaLin	:= 0
	
    oRegua:SetRegua2( 4000 )

	For _nElemx		:= 1 To 70000

//		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6))

		cPRODVIEW    :=Alltrim(VERDADOS(nHdl,'aCelulas',01,_nSomaLin))
		cGROUPID	 :=VERDADOS(nHdl,'aCelulas',02,_nSomaLin)
		cSOURCE      :=VERDADOS(nHdl,'aCelulas',03,_nSomaLin)
		cORDERABLE   :=VERDADOS(nHdl,'aCelulas',04,_nSomaLin)
		cSUBSTITUTE  :=Alltrim(VERDADOS(nHdl,'aCelulas',05,_nSomaLin))
		cDESCRIPTION :=VERDADOS(nHdl,'aCelulas',06,_nSomaLin)
		cCURRENCY    :=VERDADOS(nHdl,'aCelulas',07,_nSomaLin)
		nLISTPRICE   :=VERDADOS(nHdl,'aCelulas',08,_nSomaLin)
		nYOURPRICE   :=VERDADOS(nHdl,'aCelulas',09,_nSomaLin)
		nBESTPRICE   :=VERDADOS(nHdl,'aCelulas',10,_nSomaLin)
		nQUANTITY    :=VERDADOS(nHdl,'aCelulas',11,_nSomaLin)
		cITEMTYPE    :=VERDADOS(nHdl,'aCelulas',12,_nSomaLin)
		cUNIT        :=Alltrim(VERDADOS(nHdl,'aCelulas',13,_nSomaLin))
		nPROP        :=VERDADOS(nHdl,'aCelulas',14,_nSomaLin)

        If Empty( cProdView )
           Exit
        Endif

        If ! Empty (cSubstitute)
           cProdView := cSubstitute
        Endif

        If ! sb1->(dbseek(xFilial("SB1")+AVKEY(cProdview,"B1_COD")))
           cProdView:="0"+cProdView
           If ! sb1->(dbseek(xFilial("SB1")+AVKEY(cProdview,"B1_COD")))
              //MsgStop("["+Alltrim(cProdView)+"] Produto nao Encontrado","Atenção")
  		      _nSomaLin++
              AcaLog( cArqLog, "Produto nao Encontrado "+cProdView )
              Loop
           Endif
        Endif                        
        
        oRegua:IncRegua2( "Processando Registro nr: " +StrZero(_nElemx,6) )
        

        If Left(cUnit,2) == "PK"
           nBESTPRICE := (nBESTPRICE / nProp) 
		Endif
		
		cForn   := mv_par03
		cFabr   := mv_par03
		cLojFo  := mv_par04
		cLojFab := mv_par04
		
		If ! SA5->(dbseek(xFilial("SA5")+AvKey(cProdView,"A5_PRODUTO")+cForn+cLojFo))		
            SA5->(RecLock("SA5",.t.))
			SA5->A5_FILIAL    := xFilial("SA5")
			SA5->A5_FORNECE	  := cForn
			SA5->A5_LOJA      := cLojFo
			SA5->A5_NOMEFOR   := SA2->A2_NREDUZ
			SA5->A5_PRODUTO   := Avkey(cProdView,"A5_PRODUTO")
 		    SA5->A5_NOMPROD   := SB1->B1_DESC
		    SA5->A5_FABR      := cFabr 
  		    SA5->A5_FALOJA    := cLojFab
        Else
            SA5->(RecLock("SA5",.f.))
	    Endif
		SA5->A5_UNID      := cUnit
		SA5->A5_MOE_US    := cCurrency
		SA5->A5_VLCOTUS   := nBESTPRICE 
		SA5->A5_QT_COT    := nQUANTITY
		SA5->A5_TPPROD    := cTipoProd
		SA5->A5_QUANT01   := nProp
	    SA5->(MsUnlock())
			                   
		_nSomaLin++
        AcaLog( cArqLog, "Produto importado para o EIC "+Avkey(cProdView,"A5_PRODUTO") )
	Next _nElemx

	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)

Endif
MsgInfo("Importação, Finalizada")
MsgInfo("Arquivo de Log Gerado "+cArqLog,"Aviso")

Return Nil



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
±±ºPrograma  ³ AbreExp  ºAutor  ³ TOTVS ABM          º Data ³ 11/11/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre uma tela para escolha do arquivo ou diretorio desejadoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - Utilizado em consultas padroes (SXB)            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AbreExp( cDrivers, cType )
//    Local cFileCSV      :=""

//	Default cType		:= "*.CSV"
	//Default cDrivers	:= GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY
    //-- Exibe interface para selecao do arquivo XML
   __cFileCSV := cGetFile('Arquivo .XLSX|*.XLSX','Open File',,,.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)

	Return !Empty(__cFileCSV)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetExp   ºAutor  ³ TOTVS-ABM          º Data ³ 11/11/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o conteudo do arquivo Statico de Diretorios        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - Utilizado em consultas padroes (SXB)            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetExp()
	Return(__cFileCSV)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MsgHBox   ºAutor  ³ TOTVS-ABM          º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe uma mensagem no padrao Help.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MsgHBox( cMensagem, cTipoHelp )
	Local aMsg  := {}
	Local cText := ""
	Local nMemo := 0

	Default cTipoHelp := ProcName(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebro o texto em 40 posicoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Q_MemoArray( cMensagem, @aMsg, 40 )

	For nMemo := 1 to Len( aMsg )
		cText += aMsg[nMemo]+Chr(13)+Chr(10)
	Next nMemo

	Help(" ",1,"NVAZIO",cTipoHelp,cText,1,0)

	Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PutSXB   ºAutor  ³ Robson Sanchez     º Data ³ 24/01/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza a gravacao dos dados na tabela SXB                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PutSXB(cAlias,cTipo,cSeq,cColuna,cDescri,cDesSpa,cDesEng,cContem,cWContem)
	Local lRet  := .T.
	Local aStru := SXB->( dbStruct() )
	Local nTamAlias := 0
	Local nTamTipo  := 0
	Local nTamSeq   := 0
	Local nTamCol   := 0
	Local nPos      := 0

	nPos := aScan( aStru,{|x| x[1] == "XB_ALIAS" } )
	nTamAlias := aStru[nPos,3]

	nPos := aScan( aStru,{|x| x[1] == "XB_TIPO" } )
	nTamTipo := aStru[nPos,3]

	nPos := aScan( aStru,{|x| x[1] == "XB_SEQ" } )
	nTamSeq := aStru[nPos,3]

	nPos := aScan( aStru,{|x| x[1] == "XB_COLUNA" } )
	nTamColuna := aStru[nPos,3]

	cAlias  := PadR( cAlias , nTamAlias  )
	cTipo   := PadR( cTipo  , nTamTipo   )
	cSeq    := PadR( cSeq   , nTamSeq    )
	cColuna := PadR( cColuna, nTamColuna )

	SXB->( dbSetOrder(1) )
	lRet := SXB->( ! dbSeek( cAlias + cTipo + cSeq + cColuna ) )
	If lRet
		SXB->(RecLock("SXB",.T.))
		SXB->XB_ALIAS   := cAlias
		SXB->XB_TIPO    := cTipo
		SXB->XB_SEQ     := cSeq
		SXB->XB_COLUNA  := cColuna
		SXB->XB_DESCRI  := cDescri
		SXB->XB_DESCSPA := cDesSpa
		SXB->XB_DESCENG := cDesEng
		SXB->XB_CONTEM  := cContem
		SXB->XB_WCONTEM := cWContem
		SXB->(MsUnlock())
	EndIf

	Return lRet

	*----------------------------------*
Static Function PutSX6( cParam, cValor )
	*----------------------------------*
	SX6->(dbsetorder(1))
	If ! SX6->(dbseek(xFilial("SX6")+cParam))
		SX6->(RecLock("SX6",.T.))
		SX6->X6_FIL    :=xFilial("SX6")
		SX6->X6_VAR    :=cParam
		SX6->X6_TIPO   :="C"
		SX6->X6_DESCRIC:="Diretorio dos Arquivos TXT's para o EDI"
		SX6->X6_CONTEUD:=cValor
		SX6->(MsUnlock())
	Endif

	Return
