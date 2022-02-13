#include "protheus.ch"
USER FUNCTION CT105LOK()
/* VALIDACAO DA EXCLUSAO DO LANCAMENTO CONTABIL - NAO DEIXA EXCLUIR NO AMBIENTE FINANCEIRO
CLAUDIA CABRAL 22/04/09*/
LOCAL OPCAO := PARAMIXB[1]
Local _lret := .t.

u_GerA0003(ProcName())

IF nmodulo = 6 // nao 
	if TMP->CT2_FLAG // registro foi deletado
		Alert("Nao e permitido excluir o lancamento ! ")
		return .f.	
	endif
 Endif

//Incluso Edson Rodrigues para validar Centro de custo digitado
_lret:= u_valccust(1)   


return _lret