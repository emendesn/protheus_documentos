#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP597    �Autor  �M.Munhoz - ERPPLUS  � Data �  31/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar conta contabil na contabilizacao de   ���
���          � NDF e PA na compensacao de Contas a pagar                  ���
�������������������������������������������������������������������������͹��
���Parametros� _cTipo -> "D" = conta debito                               ���
���          �           "C" = conta credito                              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function lp597(_cTipo)

local _cConta   := ""
local _aAreaSE2 := SE2->(GetArea())
local _aAreaSED := SED->(GetArea())

u_GerA0003(ProcName())

//��������������������������������������������������������������������������������������������������Ŀ
//� Regra contabil definida pelo Roberto da Net Worth em 14/04/2008, conforme informado pelo Edson.  �
//� Contabilizacao de Contas a Receber (NDF/PA)                                                      �
//� Debito  = conta credito da natureza do titulo de NDF ou PA                                       �
//� Credito = conta credito da natureza do titulo principal                                          �
//����������������������������������������������������������������������������������������������������

// Posiciona SE2 e SED pelo titulo gerador da compensacao (pode ser NDF/PA ou o titulo principal/NF)
SE2->(dbSetOrder(1))
SE2->(dbSeek(xFilial("SE2") + strlctpad))

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE2->E2_NATUREZ))

if alltrim(substr(strlctpad,11,3)) $ "NDF/PA"
	_cConta := iif(_cTipo == "D", Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999"), "")
else
	_cConta := iif(_cTipo == "D", "", Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999") )
endif

// Passo por todos os titulos, verificando qual esta marcado para compensacao
for _na := 1 to len(aTitulos)

	if aTitulos[_na,8]  // o Titulo estas marcado no markbrowse

		SE2->(dbSetOrder(1))
		SE2->(dbSeek(xFilial("SE2") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
	
		SED->(dbSetOrder(1))
		SED->(dbSeek(xFilial("SED") + SE2->E2_NATUREZ))

		if alltrim(aTitulos[_na,4]) $ "NDF/PA"
			_cConta := iif(_cTipo == "D", Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999"), _cConta)
		else
			_cConta := iif(_cTipo == "D", _cConta, Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999"))
		endif

		exit

	endif

next _na

restarea(_aAreaSED)
restarea(_aAreaSE2)

return(_cConta)
