#INCLUDE "PROTHEUS.CH"

/*
FUNCAO   : BGHOP002
OBJETIVO : ROTINA AUTOMATICA PARA CADASTRO DE EMPENHOS
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 21.10.2009

-------------------------------------------------------------------------- 
PARAMETROS
01) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS
02) OPCAO DA ROTINA

-------------------------------------------------------------------------- 
RETORNO
.T. PARA PROCESSAMENTO CONFIRMADO
.F. PARA FALHA NO PROCESSAMENTO

--------------------------------------------------------------------------
22.10.09 : IMPLEMENTADO CODIGO PADRAO

*/

USER FUNCTION BGHOP002(aParam,lInclui)

Local aDados      := {}
Local MD4_COD     := aParam[1]  // EMPENHO CODIGO PRODUTO
Local MD4_LOCAL   := aParam[2]  // EMPENHO LOCAL A RETIRAR
Local MD4_OP      := aParam[3]  // EMPENHO OP UTILIZAR
Local MD4_DATA    := aParam[4]  // EMPENHO DATA
Local MD4_QTDEORI := aParam[5]  // EMPENHO QUANTIDADE OPERACAO
Local MD4_QUANT   := aParam[6]  // EMPENHO QUANTIDADE OPERACAO
Local MD4_LOTECTL := aParam[7]  // EMPENHO LOTE
Local MD4_NUMLOTE := aParam[8]  // EMPENHO SUBLOTE
Local _lRet       := .T.                // RETORNO
Local nOper       := IIF(lInclui,3,5)   // OPERACAO, 3 INCLUIR, 5 EXCLUIR
Private lMsErroAuto  := .f.             // FLAG EXECAUTO      

u_GerA0003(ProcName())
                           

AADD(aDados,{"D4_FILIAL"  ,XFILIAL("SD4") ,NIL})  
AADD(aDados,{"D4_COD"     ,MD4_COD        ,NIL})  
AADD(aDados,{"D4_LOCAL"   ,MD4_LOCAL      ,NIL})  
AADD(aDados,{"D4_OP"      ,MD4_OP         ,NIL})  
AADD(aDados,{"D4_DATA"    ,MD4_DATA       ,NIL})  
AADD(aDados,{"D4_QTDEORI" ,MD4_QTDEORI    ,NIL}) 
AADD(aDados,{"D4_QUANT"   ,MD4_QUANT      ,NIL}) 
If (MD4_LOTECTL <> nil)
	AADD(aDados,{"D4_LOTECTL" ,MD4_LOTECTL    ,NIL}) 
	AADD(aDados,{"D4_NUMLOTE" ,MD4_NUMLOTE    ,NIL}) 
Endif

Begin Transaction

	MATA380(aDados,nOper)

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