#include "rwmake.ch"
#include "topconn.ch"

/*
FUNCAO   : BGHOP004
OBJETIVO : ROTINA AUTOMATICA PARA TRANSFERENCIAS
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 26.10.2009

-------------------------------------------------------------------------- 
PARAMETROS
01) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS
02) OPCAO DA ROTINA

-------------------------------------------------------------------------- 
RETORNO
.T. PARA PROCESSAMENTO CONFIRMADO
.F. PARA FALHA NO PROCESSAMENTO

--------------------------------------------------------------------------
26.10.09 : IMPLEMENTADO CODIGO PADRAO

*/

USER FUNCTION BGHOP004(aParam,lInclui)

Local aDados      := {}
Local lOper       := IIF(lInclui,.F.,.T.)   // OPERACAO, INCLUSÃO/ESTORNO
Local _lRet       := .T.                // RETORNO  
Local cDocto    	:= aParam[4] //Documento                - Obrigatorio
Local dDtValid  	:= IIF(Empty(aParam[6]),"",aParam[6]) //Validade                 - Obrigatorio se usa Rastro
Local cNumSerie 	:= aParam[7]//Numero de Serie
Local lEstorno  	:= lOper //Indica se movimento e estorno
Local nRecOrig  	:= aParam[14]  //Numero do registro original (utilizado estorno)
Local nRecDest  	:= aParam[15] //Numero do registro destino (utilizado estorno)
Local cPrograma 	:= "BGHOP004" //Indicacao do programa que originou os lancamentos
Local cEstFis   	:= "" //Estrutura Fisica
Local cServico  	:= "" //Servico
Local cTarefa   	:= "" //Tarefa 
Local cAtividade	:= "" //Atividade 
Local cAnomalia 	:= "N" //Houve Anomalia? (S/N) 
Local cEstDest  	:= "" //Estrututa Fisica Destino 
Local cEndDest  	:= aParam[12] //Endereco Destino
Local cHrInicio 	:= "" //Hora Inicio
Local cAtuEst   	:= "S" //Atualiza Estoque? (S/N)
Local cCarga    	:= "" //Numero da Carga
Local cUnitiza  	:= "" //Numero do Unitizador
Local cOrdTar   	:= "" //Ordem da Tarefa
Local cOrdAti   	:= "" //Ordem da Atividade 
Local cRHumano  	:= "" //Recurso Humano 
Local cRFisico  	:= "" //Recurso Fisico
Local nPotencia 	:= "" //Potencia do Lote 
Local cLoteDest 	:= IIF(Empty(aParam[13]),"",aParam[13]) //Lote Destino da Transferencia 

//Incluso Edson Rodrigues 03/10/09, colocado essas variaveis como private, pois durante execauto,
//na chamda do ponto de entrada A260GRV, as mesmas nao estavam declaradas.
Private cCodOrig       := aParam[1] //Codigo do Produto Origem - Obrigatorio
Private cLocOrig       := aParam[2] //Almox Origem             - Obrigatorio
Private nQuant260      := aParam[3] //Quantidade 1a UM         - Obrigatorio
Private nQuant260D     := 0 //Quantidade 2a UM
Private cNumLote       := "" //Sub-Lote                 - Obrigatorio se Rastro "S"
Private cLoteDigi      := IIF(Empty(aParam[5]),"",aParam[5]) //Lote                     - Obrigatorio se usa Rastro
Private cLoclzOrig     := aParam[8]//localização Origem
Private cCodDest       := aParam[9]//Codigo do Produto Destino- Obrigatorio 
Private cLocDest       := aParam[10]//Almox Destino            - Obrigatorio
Private cLocLzDest     := aParam[11]//Localização Destino
Private lMsErroAuto    := .f.             // FLAG EXECAUTO  
Private dEmis260 := dDatabase //Data                     - Obrigatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a variavel que identifica se o calculo do custo e' :    ³
//³               O = On-Line                                    ³
//³               M = Mensal                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCusMed  := GetMv("MV_CUSMED")
PRIVATE cCadastro:= "Transferˆncias"	//"Transferˆncias"
PRIVATE aRegSD3  := {}

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo	// Nome do arquivo contra prova
EndIf

Begin Transaction

a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)

If lMsErroAuto
    DisarmTransaction()
    Mostraerro()
	_lRet := .F.
	Return(_lRet)
else
	_lRet := .T.
EndIf

End Transaction

Return(_lRet)