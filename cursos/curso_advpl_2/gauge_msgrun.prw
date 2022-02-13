///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Gauge_MsgRun.prw     | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_GMsgRun()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstracao da funcao MsgRun e dbEval()                        |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

USER FUNCTION GMsgRun()
LOCAL nCnt := 0

dbSelectArea("SX1")
dbGoTop()

If Aviso("MsgRun","Janela com ou sem barra de título?",{"Com","Sem"},1,"Escolha")==1
   MsgRun("Lendo arquivo, aguarde...","Título opcional",{|| dbEval({|x| nCnt++}) })
Else
   MsgRun("Lendo arquivo, aguarde...",,{|| dbEval({|x| nCnt++}) })
Endif

MsgInfo("Ufa!!!, li "+LTrim(Str(nCnt))+" registros",FunName())

RETURN