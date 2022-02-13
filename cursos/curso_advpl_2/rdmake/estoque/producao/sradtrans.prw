#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SRAdTrans  ºAutor  ³ Edson Rodrigues    º Data ³  12/03/2010º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo Sony Refurbish - Adciona ao vetor os daos de      º±±
±±º          | Transferencia de estoque                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SRAdTrans(cprodori,armori,cdoc,cprodest,carmdest,_atransp,ltransf,lInclui,_lgertrans,recori,recdest,nqtde)
		NMODULO:=04
		CMODULO:="EST"

u_GerA0003(ProcName())
	
        AADD(_atransp,cprodori)
	    AADD(_atransp,left(armori,2))
		AADD(_atransp,nqtde)
		AADD(_atransp,cdoc)
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,cprodest)
		AADD(_atransp,carmdest)
		AADD(_atransp,'')
		AADD(_atransp,'')
		AADD(_atransp,'' )
		AADD(_atransp,recori )
		AADD(_atransp,recdest )
		
		IF Len(_atransp) > 0 .and. _lgertrans
			ltransf:=U_BGHOP004(_atransp,lInclui)
	    ENDIF

Return()
                                                                     
