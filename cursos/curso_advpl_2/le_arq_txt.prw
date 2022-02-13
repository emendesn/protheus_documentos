#INCLUDE "PROTHEUS.CH"

USER FUNCTION LeArqTxt()
Private nOpc      := 0
Private cCadastro := "Ler arquivo texto"
Private aSay      := {}
Private aButton   := {}

aAdd( aSay, "O objetivo desta rotina e efetuar a leitura em um arquivo texto" )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| Import() }, "Processando..." )
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Le_Arq_Txt.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Import()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de importacao de dados                                   |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION Import()
Local cBuffer   := ""
Local cFileOpen := ""
Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Arquivo TXT | *.txt"

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diretório inicial se necessário
 * <ExpL1> - .F. botão salvar - .T. botão abrir
 * <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
 */
cFileOpen := cGetFile(cExtens,cTitulo1,,cMainPath,.T.)

If !File(cFileOpen)
   MsgAlert("Arquivo texto: "+cFileOpen+" não localizado",cCadastro)
   Return
Endif

FT_FUSE(cFileOpen)  //ABRIR
FT_FGOTOP() //PONTO NO TOPO
ProcRegua(FT_FLASTREC()) //QTOS REGISTROS LER

While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
   IncProc()

   // Capturar dados
   cBuffer := FT_FREADLN() //LENDO LINHA 
   
   cMsg := "Código do cliente: "+SubStr(cBuffer,01,06) + Chr(13)+Chr(10)
   cMsg += "Nome: "             +SubStr(cBuffer,07,30) + Chr(13)+Chr(10)
   cMsg += "Nome fantasia: "    +SubStr(cBuffer,39,15) + Chr(13)+Chr(10)
   cMsg += "Estado: "           +SubStr(cBuffer,54,02) + Chr(13)+Chr(10)
   cMsg += "CNPJ: "             +SubStr(cBuffer,81,14)
   
   MsgInfo(cMsg)
   
   FT_FSKIP()   //proximo registro no arquivo txt
EndDo

FT_FUSE() //fecha o arquivo txt

MsgInfo("Processo finalizada")

Return