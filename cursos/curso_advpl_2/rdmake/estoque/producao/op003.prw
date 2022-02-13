#INCLUDE "PROTHEUS.CH"

/*
FUNCAO   : BGHOP003
OBJETIVO : ROTINA AUTOMATICA PARA APONTAMENTO DA PRODUCAO
AUTOR    : FABRICA DE SOFTWARE ADVPL  (advpl@advpl.com.br)
PROJETO  : BGH / EDSON RODRIGUES
DATA     : 23.10.2009

-------------------------------------------------------------------------- 
PARAMETROS
01) VETOR COM CONTEUDO DOS CAMPOS A SEREM UTILIZADOS
02) OPCAO DA ROTINA

-------------------------------------------------------------------------- 
RETORNO
.T. PARA PROCESSAMENTO CONFIRMADO
.F. PARA FALHA NO PROCESSAMENTO

--------------------------------------------------------------------------
23.10.09 : IMPLEMENTADO CODIGO PADRAO

*/

USER FUNCTION BGHOP003(aParam,lInclui)

Local aDados      := {}
Local _lRet       := .T.                // RETORNO
Local MD3_TM      := aParam[1]          // PRODUCAO TIPO DE MOVIMENTO  
Local MD3_COD     := aParam[2]          // PRODUCAO CODIGO DO PRODUTO
Local MD3_UM      := aParam[3]          // PRODUCAO UNIDADE DE MEDIDA
Local MD3_QUANT   := aParam[4]          // PRODUCAO QUANTIDADE PRODUZIDA
Local MD3_OP      := aParam[5]          // PRODUCAO NUMERO DA OP 
Local MD3_LOCAL   := aParam[6]          // PRODUCAO ARMAZEM
Local MD3_EMISSAO := dDatabase          // PRODUCAO DATA DA EMISSÃO
Local MD3_DOC     :=  aParam[7]          // DOCUMENTO
Local MD3_NUMSEQ  := IIF(lInclui,"",aParam[8])  // NUMERO DE SEQUENCIA
Local MD3_CHAVE   := IIF(lInclui,"",aParam[9])  //  CHAVE
Local NRECNO      := IIF(lInclui,"",aParam[10])  // RECNO
Local nOper       := IIF(lInclui,3,5)   // OPERACAO, 3 INCLUIR, 5 EXCLUIR  
local _aAreaSD3   := SD3->(GetArea())
Private lMsErroAuto  := .f.             // FLAG EXECAUTO      
Private lMSHelpAuto  := .f.

u_GerA0003(ProcName())
                 
IF nOper==5       // IF Incluso e alterado  a montagem dos vetores abaixo - Edson Rodrigues 20/03/10  -  30/03/10
	dbselectarea("SD3")
	dbsetorder(4)
	SD3->(dbGoto(NRECNO))
	
	aAdd(aDados,{"D3_FILIAL" ,XFILIAL("SD3") ,NIL})
	aAdd( aDados, {"D3_NUMSEQ" , MD3_NUMSEQ   , Nil})
	aAdd(aDados, {"D3_CHAVE" , MD3_CHAVE   , Nil})
	aAdd(aDados, {"D3_COD" , MD3_COD   , Nil})
	aAdd(aDados, {"INDEX"     , 4        , Nil})
Else
	aAdd(aDados,{"D3_OP"     ,MD3_OP         ,NIL})
	aAdd(aDados,{"D3_TM"     ,MD3_TM         ,NIL})
	aAdd(aDados,{"D3_QUANT"  ,MD3_QUANT      ,NIL})
Endif



//Begin Transaction

MSExecAuto({|x,y| mata250(x,y)},aDados,nOper) 

If lMsErroAuto
//    DisarmTransaction()
    Mostraerro()
	_lRet := .F.  
	Return(_lRet)
else
	
	_lRet := .T.
EndIf

//End Transaction    

restarea(_aAreaSD3)

Return(_lRet)