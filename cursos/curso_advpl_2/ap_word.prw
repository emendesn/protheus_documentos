///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ap_word()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este programa demonstra com fazer integracao do protheus com    |//
//|           | o ms-word. Para este exemplo eh necessario os arquivos:         |//
//|           | PedidoVenda.dot e ExemploMacro.bas                              |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#include "Protheus.Ch"
#include "MSOle.Ch"

User Function ap_word()
	Local nOpc := 0
	
	Private cCadastro := "Integração Protheus Vs Ms-Word"
	Private aSay := {}
	Private aButton := {}

	aAdd( aSay, "Esta rotina irá imprimir o pedido de vendas conforme parâmetros informados." )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		Processa( {|| ImpWord() }, cCadastro, "Processando..." )
	Endif
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ImpWord()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que descarrega as variaveis nas variaveis do word        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ImpWord()
	Local oWord := Nil
	Local cFileOpen := ""
	Local cFileSave := ""
	Local cPedido := ""
	Local cCond := ""
	Local cPICTURE := "@E 99,999,999.99"
	Local aPARAM := {}
	Local aRET := {}
	Local aSC6 := {}
	Local nTOTAL := 0
	Local nI := 0
	Local nSaida := 0
	Local aSaida := {"1-Na Impressora","2-Em Arquivo","3-Deixar Word Aberto"}

	aAdd( aPARAM, { 1, "Nº Pedido de venda" , Space(6) , ""    , "", "SC5", "" , 0  , .T. })
	aAdd( aPARAM, { 6, "Arquivo Modelo Word", Space(50), ""    , "", ""   , 50 , .T., "Modelo MS-Word |*.dot", cMainPath })
	aAdd( aPARAM, { 2, "Qual saída"         , 1        , aSaida, 80, ""   , .F.})

	If !ParamBox(aPARAM,"Parâmetros",@aRET)
   	Return
	Endif

	cFileOpen := aRET[2]

	If !File(cFileOpen)
   	MsgInfo("Arquivo não localizado",cCadastro)
   	Return
	Endif

	cPedido := aRET[1]
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If !dbSeek( xFilial("SC5") + cPedido )
		MsgInfo("Pedido de venda não encontrado",cCadastro)
		Return
	Endif

	nSaida := Val(Left(aRET[3],1))
	cCond := Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1") + SC5->( C5_CLIENTE + C5_LOJACLI ) )

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek( xFilial("SC6") + SC5->C5_NUM )

	While !EOF() .And. SC6->( C6_FILIAL + C6_NUM ) == xFilial("SC5") + SC5->C5_NUM
		nTOTAL += SC6->C6_VALOR
		aAdd( aSC6, { 	C6_ITEM, ;
							Posicione("SB1",1,xFilial("SB1")+C6_PRODUTO,"B1_DESC"), ;
							LTrim(TransForm(C6_QTDVEN,cPICTURE)), ;
							LTrim(TransForm(C6_PRCVEN,cPICTURE)), ;
							LTrim(TransForm(C6_VALOR,cPICTURE)) } )
		dbSkip()
	End

	If Len( aSC6 ) == 0
		MsgInfo("Não foi possível ler os itens do pedido de venda",cCadastro)
		Return
	Endif

	//+--------------------------------------------------------------------------------------------------
	//| Ao final deste fonte está a explicação de cada função para a integração do Protheus com o Ms-Word
	//+--------------------------------------------------------------------------------------------------
	oWord := OLE_CreateLink()
	OLE_NewFile( oWord, cFileOpen )

	OLE_SetDocumentVar( oWord, 'w_C5_NUM'    , SC5->C5_NUM  )
	OLE_SetDocumentVar( oWord, 'w_C5_EMISSAO', Dtoc(SC5->C5_EMISSAO) )
	OLE_SetDocumentVar( oWord, 'w_C5_CONDPAG', cCond )
	OLE_SetDocumentVar( oWord, 'w_C5_CLIENTE', SA1->A1_COD+"-"+SA1->A1_LOJA+"/"+SA1->A1_NOME )
	OLE_SetDocumentVar( oWord, 'w_VlrTotal'  , LTrim(TransForm(nTOTAL,cPICTURE)) )
	OLE_SetDocumentVar( oWord, 'w_NumItens'  , LTrim( Str( Len( aSC6 ) ) ) )
	
	For nI := 1 To Len( aSC6 )
		OLE_SetDocumentVar( oWord, 'w_C6_ITEM'   + LTrim(Str(nI)), aSC6[nI,1] )
		OLE_SetDocumentVar( oWord, 'w_C6_PRODUTO'+ LTrim(Str(nI)), aSC6[nI,2] )
		OLE_SetDocumentVar( oWord, 'w_C6_QTDE'   + LTrim(Str(nI)), aSC6[nI,3] )
		OLE_SetDocumentVar( oWord, 'w_C6_UNIT'   + LTrim(Str(nI)), aSC6[nI,4] )
		OLE_SetDocumentVar( oWord, 'w_C6_TOTAL'  + LTrim(Str(nI)), aSC6[nI,5] )
	Next nI
	
	OLE_ExecuteMacro( oWord , "PedidoVenda" )
	OLE_UpDateFields( oWord )

	If nSaida <> 3
   	If nSaida == 1
	   	OLE_PrintFile( oWord )
   	Elseif nSaida == 2
      	cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
	   	OLE_SaveAsFile( oWord, cFileSave+SC5->C5_NUM+"_protheus.doc" )
   	Endif
	Endif

	OLE_CloseLink( oWord, .F. )

Return

//+-----------------------------------------------------------------
//+-----------------------------------------------------------------
//| Descritivo de cada função para integrar o Protheus com o Ms-Word
//+-----------------------------------------------------------------
//+-----------------------------------------------------------------
/*

- Funcao que abre o Link com o Word tendo como parametro a versao
  oWord := OLE_CreateLink( "TMSOLEWORD97" )

- Funcao que faz o Word aparecer na Area de Transferencia do Windows, sendo que para habilitar/desabilitar e so colocar .T. ou .F.
  OLE_SetProperty( oWord, OLEWDVISIBLE, .T. )
  OLE_SetProperty( oWord, OLEWDPRINTBACK,.T. )

- Funcoes que configuram o tamanho da janela do Word
  OLE_SetProperty( oWord, OLEWDLEFT  , 000 )
  OLE_SetProperty( oWord, OLEWDTOP   , 090 )
  OLE_SetProperty( oWord, OLEWDWIDTH , 480 )
  OLE_SetProperty( oWord, OLEWDHEIGHT, 250 )

- Funcao de abertura do Documento com os parametros lReadOnly (Somente Leitura), com SENHAXXX (senha de abertura do Documento) 
  e com SENHAWWW (senha de gravacao)
  OLE_OPENFILE( oWord, "C:\WINDOWS\TEMP\EXEMPLO.DOC", lReadOnly, "SENHAXXX","SENHAWWW")

- Funcao para criar um Documento com Modelo(DOT) especificado no parametro
  OLE_NewFile( oWord, "C:\WINDOWS\TEMP\EXEMPLO.DOT" )

- Funcao que salva o Documento com o nome especificado, com senha e no formato Word
  OLE_SaveAsFile( oWord, "C:\WINDOWS\TEMP\EXEMPLO1.DOC", "SENHAXXX", "SENHAWWW", .F., OLEWDFORMATDOCUMENT )

- Funcao salva o Documento corrente
  OLE_SaveFile( oWord )

- Funcao que atualiza as variaveis do Word, conforme exemplo ira atualizar a variavel "AdvNomeFilial" com o conteudo 
  "Microsiga Software S/A". O RdMake GPEWORD podera servir de exemplo para atualizacao de variaveis
  OLE_SetDocumentVar( oWord, "Adv_NomeFilial", "Microsiga Software S/A" )

- Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a funcao OLE_SetDocumentVar()
  OLE_Updatefields( oWord )

- Funcao que imprime o Documento corrente podendo ser especificado o numero de copias, podedo tambem imprimir 
  com um intervalo especificado nos parametros "nPagInicial" ate "nPagFinal" retirando o parametro"ALL"
  OLE_PrintFile( oWord, "ALL", nPagInicial, nPagFinal, nCopias )

- Funcao que fecha o Documento sem fechar o Link com o Word, utilizado para manipulacao de dois ou mais arquivos 
  (recomendado fechar todos os arquivos antes de fechar o Link com Word)
  OLE_CloseFile( oWord )

- Funcao que fecha o Link com o Word
  OLE_CloseLink( oWord )
*/