#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"              

/*
FUNCAO   : OP005
OBJETIVO : ROTINA AUTOMATICA PARA INSERIR OP E TRANSFERENCIA ENTRE ARMAZÉNS
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 30.10.2009

-------------------------------------------------------------------------- 
PARAMETROS
01) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS PARA INSERIR OP
02) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS PARA TRANSFERÊNCIA ENTRE ARMAZÉNS
03) OPCAO DA ROTINA

-------------------------------------------------------------------------- 
RETORNO
.T. PARA PROCESSAMENTO CONFIRMADO
.F. PARA FALHA NO PROCESSAMENTO

--------------------------------------------------------------------------
30.10.09 : IMPLEMENTADO CODIGO PADRAO
*/

User Function BGHOP005(aOp1,aTran,lInclui)

                    
Local lRet := .T.

u_GerA0003(ProcName())

lRet := U_BGHOP001(aOp1,lInclui)

If lRet == .F.
	Return(lRet)
Else
   lRet := U_BGHOP004(aTran,lInclui)
Endif

Return(lRet)