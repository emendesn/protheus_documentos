#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP596    ºAutor  ³M.Munhoz - ERPPLUS  º Data ³  31/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar conta contabil na contabilizacao de   º±±
±±º          ³ NCC e RA na compensacao de Contas a Receber                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cTipo -> "D" = conta debito                               º±±
±±º          ³           "C" = conta credito                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function lp596(_cTipo)

local _cConta   := ""
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())


u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regra contabil definida pelo Roberto da Net Worth em 14/04/2008, conforme informado pelo Edson.  ³
//³ Contabilizacao de Contas a Receber (NCC/RA)                                                      ³
//³ Debito  = conta credito da natureza do titulo de NCC ou RA                                       ³
//³ Credito = conta credito da natureza do titulo principal                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Posiciona SE1 e SED pelo titulo gerador da compensacao (pode ser NCC/RA ou o titulo principal/NF)
SE1->(dbSetOrder(1))
SE1->(dbSeek(xFilial("SE1") + strlctpad))

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))

if alltrim(substr(strlctpad,11,3)) $ "NCC/RA"
	_cConta := iif(_cTipo == "D", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,"1120199998") , "")
else
	_cConta := iif(_cTipo == "D", "", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,"1120199998") )
endif

// Passo por todos os titulos, verificando qual esta marcado para compensacao
for _na := 1 to len(aTitulos)

	if aTitulos[_na,8]  // o Titulo estas marcado no markbrowse

		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
	
		SED->(dbSetOrder(1))
		SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))

		if alltrim(aTitulos[_na,4]) $ "NCC/RA"
			_cConta := iif(_cTipo == "D", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,"1120199998") , _cConta)
		else
			_cConta := iif(_cTipo == "D", _cConta, Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,"1120199998") )
		endif

		exit

	endif

next _na

restarea(_aAreaSED)
restarea(_aAreaSE1)

return(_cConta)
