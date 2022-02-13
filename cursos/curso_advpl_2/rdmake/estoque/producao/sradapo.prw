#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SRAdApo  ºAutor  ³ Edson Rodrigues    º Data ³  12/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo Sony Refurbish - Adciona ao vetor as dados de aponº±±
±±º          | tamento da produção                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SRAdApo(cmovprod,cnewpro,cunimed,cnumos,carmprod,_laponta,_aAponOP,lInclui,lgerapon,cdoc,cnumseq,cchave,nrecno)


	NMODULO:=04
	CMODULO:="EST"

u_GerA0003(ProcName())
	
	AADD(_aAponOP,alltrim(cmovprod))
	AADD(_aAponOP,cnewpro)
	AADD(_aAponOP,SB1->B1_UM)
	AADD(_aAponOP,1)
	AADD(_aAponOP,cnumos+'01001  ')
	AADD(_aAponOP,left(carmprod,2))
	AADD(_aAponOP,cdoc)
	AADD(_aAponOP,cnumseq)
	AADD(_aAponOP,cchave)
	AADD(_aAponOP,nrecno)
		
	If len(_aAponOP) > 0 .and. lgerapon
		    _laponta :=U_BGHOP003(_aAponOP,lInclui)
	Endif
Return()        