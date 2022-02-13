#include "rwmake.ch"



User funtion lp650(_cTipo)

 

Local _aAreaSED := SED->(GetArea())
                             

Local _cConta  := ""

u_GerA0003(ProcName())

 

SED->(dbSetOrder(1))

If SED->(dbSeek(xFilial("SED") + CNATUREZA))

                _cConta := iif(_cTipo == "D", SED->ED_CONTA, Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999"))

EndIf

 

RestArea(_aAreaSED)

 

Return(_cConta)