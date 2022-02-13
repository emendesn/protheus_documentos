user function LP610cred()

local _cConta   := "3110101999"
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())

u_GerA0003(ProcName())

SE1->(dbSetOrder(1))
SED->(dbSetOrder(1))

if !empty(SF2->F2_DUPL) .and. SE1->(dbSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL ))

	if SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ ))

		_cConta := iif(!empty(SED->ED_CONTA),SED->ED_CONTA,_cConta)

	endif

endif

restarea(_aAreaSE1)
restarea(_aAreaSED)

return(_cConta)
