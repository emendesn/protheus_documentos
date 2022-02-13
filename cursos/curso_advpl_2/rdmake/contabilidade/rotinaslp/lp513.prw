#include "rwmake.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³lp513     ºAutor  ³ Edson Rodrigues    º Data ³19/12/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno da conta banco, pois ha momentos que 0º±±
±±º          | sistema falha se perde                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso   BGH ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function lp513()   

SetPrvt("_CCONTA,")
_cConta  := Space(20) 
_cnumero := SE5->E5_NUMERO
_cprefix := SE5->E5_PREFIXO
_cparcel := SE5->E5_PARCELA
_ctipoe5 := SE5->E5_TIPO
_cclifor := SE5->E5_CLIFOR
_clojacf := SE5->E5_LOJA
_cseqse5 := SE5->E5_SEQ
_arease5 := SE5->(GetArea())
_areasa6 := SA6->(GetArea())
lachobco :=.f.

u_GerA0003(ProcName())

Dbselectarea("SA6")
Dbsetorder(1)

Dbselectarea("SE5")
Dbsetorder(7)



IF SE5->(dbSeek(xFilial("SE5") +_cprefix+_cnumero+_cparcel+_ctipoe5+_cclifor+_clojacf+_cseqse5)) 
     IF SA6->(dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
        _cConta  := SA6->A6_CONTA
        lachobco :=.T.
     ENDIF 
ENDIF

IF !lachobco
  _cnumero := SE2->E2_NUM
  _cprefix := SE2->E2_PREFIXO
  _cparcel := SE2->E2_PARCELA
  _ctipoe5 := SE2->E2_TIPO
  _cclifor := SE2->E2_FORNECE
  _clojacf := SE2->E2_LOJA
  IF SE5->(dbSeek(xFilial("SE5") +_cprefix+_cnumero+_cparcel+_ctipoe5+_cclifor+_clojacf))   
     IF SA6->(dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
        _cConta  := SA6->A6_CONTA
        lachobco :=.T.
     ENDIF 
  ENDIF
ENDIF

restarea(_arease5)
restarea(_areasa6)

Return(_cConta)       