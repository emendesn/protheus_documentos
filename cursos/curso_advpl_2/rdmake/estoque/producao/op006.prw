#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"              

/*
FUNCAO   : OP006
OBJETIVO : ROTINA AUTOMATICA PARA APONTAMENTO DE PRODU��O E TRANSFERENCIA ENTRE ARMAZ�NS
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 30.10.2009

-------------------------------------------------------------------------- 
PARAMETROS
01) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS PARA REALIZAR O APONTAMENTO DE PRODU��O
02) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS PARA TRANSFER�NCIA ENTRE ARMAZ�NS
03) OPCAO DA ROTINA

-------------------------------------------------------------------------- 
RETORNO
.T. PARA PROCESSAMENTO CONFIRMADO
.F. PARA FALHA NO PROCESSAMENTO

--------------------------------------------------------------------------
30.10.09 : IMPLEMENTADO CODIGO PADRAO

*/

User Function BGHOP006(aAp1,aTran,lInclui)                    

Local lRet := .T.

u_GerA0003(ProcName())
lRet := U_BGHOP003(aAp1,lInclui)

If lRet == .F.
	Return(lRet)
Else
	lRet := U_BGHOP004(aTran,lInclui)
Endif

Return(lRet)