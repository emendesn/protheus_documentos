#include "rwmake.ch"
#include "topconn.ch"


/*
FUNCAO   : BGHOP001
OBJETIVO : ROTINA AUTOMATICA PARA CADASTRO DE ORDEM DE PRODUCAO
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 22.10.2009

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

USER FUNCTION BGHOP001(aParam,lInclui)

Local aDados      := {}
Local MC2_NUM     := aParam[1]          // OP NUMERO
Local MC2_ITEM    := aParam[2]          // OP ITEM
Local MC2_SEQUEN  := aParam[3]          // OP SEQUENCIA
Local MC2_PRODUTO := aParam[4]          // OP PRODUTO
Local MC2_LOCAL   := aParam[5]          // OP LOCAL DE ENTREGA PRODUCAO
Local MC2_CC      := aParam[6]          // OP CENTRO DE CUSTO
Local MC2_QUANT   := aParam[7]          // OP QUANTIDADE
Local MC2_UM      := aParam[8]          // OP UNIDADE DE MEDICA
Local MC2_DATPRI  := dDatabase + 5      // OP DATA PREVISAO
Local MC2_DATPRF  := dDatabase + 5      // OP DATA ENTREGA
Local MC2_EMISSAO := dDatabase          // OP EMISSAO
Local MC2_STATUS  := "N"                // OP SITUACAO
Local MC2_TPOP    := "F"                // OP TIPO
Local nOper       := IIF(lInclui,3,5)   // OPERACAO, 3 INCLUIR, 5 EXCLUIR
Local _lRet        := .T.               // RETORNO
Private lMsErroAuto  := .f.             // FLAG EXECAUTO


u_GerA0003(ProcName())

AADD(aDados,{"C2_FILIAL"  ,XFILIAL("SC2") ,Nil}) 
AADD(aDados,{"C2_NUM"     ,MC2_NUM     ,Nil}) 
AADD(aDados,{"C2_ITEM"    ,MC2_ITEM    ,Nil}) 
AADD(aDados,{"C2_SEQUEN"  ,MC2_SEQUEN  ,Nil}) 
AADD(aDados,{"C2_PRODUTO" ,MC2_PRODUTO ,Nil}) 
AADD(aDados,{"C2_LOCAL"   ,MC2_LOCAL   ,Nil}) 
AADD(aDados,{"C2_CC"      ,MC2_CC      ,Nil}) 
AADD(aDados,{"C2_QUANT"   ,MC2_QUANT   ,Nil}) 
AADD(aDados,{"C2_UM"      ,MC2_UM      ,Nil}) 
AADD(aDados,{"C2_DATPRI"  ,MC2_DATPRI  ,Nil}) 
AADD(aDados,{"C2_DATPRF"  ,MC2_DATPRF  ,Nil}) 
AADD(aDados,{"C2_EMISSAO" ,MC2_EMISSAO ,Nil}) 
AADD(aDados,{"C2_STATUS"  ,MC2_STATUS  ,Nil}) 
AADD(aDados,{"C2_TPOP"    ,MC2_TPOP    ,Nil}) 
                                                                     

IF nOper == 5
     dbselectarea("SC2")
     dbsetorder(1)
     dbgotop()
     IF !DBSEEK(XFILIAL("SC2")+aDados[2,2]+aDados[3,2])
     	MsgAlert("OP: "+aDados[2,2]+aDados[3,2]+" nao localizado!")
     	return(nil)
     ENDIF
ENDIF 
                                        
Begin Transaction

MSExecAuto({|x,y| mata650(x,y)},aDados,nOper)   // MATA650(aCab,Acos,3)

If lMsErroAuto
    DisarmTransaction()
    Mostraerro()
	_lRet := .F. 
	RETURN(_lRet)
else
	_lRet := .T.
EndIf

End Transaction

Return(_lRet)