#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSRAdEmp  บAutor  ณ Edson Rodrigues    บ Data ณ  11/03/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processo Sony Refurbish - Adciona ao vetor as pe็as        บฑฑ
ฑฑบ          | a empenhar                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SRAdEmp(_cCod,carmaz,_cnumop,_nqtde,_nqtemp,clote,csublote,_aEmpenh,lInclui,_lempenh,lgeraemp)
      Local _crastro   := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(_cCod),"B1_RASTRO") // Rastro       
      NMODULO:=04
      CMODULO:="EST"

u_GerA0003(ProcName())	  
	   AADD(_aEmpenh,_cCod)
	   AADD(_aEmpenh,left(carmaz,2))
	   AADD(_aEmpenh,left(_cnumop,6)+'01001  ')
	   AADD(_aEmpenh,dDatabase)
	   AADD(_aEmpenh,iif(_nqtde<=0,1,_nqtde))
	   AADD(_aEmpenh,iif(_nqtde<=0,1,_nqtde))
	   AADD(_aEmpenh,iif(_crastro $ "SL",clote,nil))
	   AADD(_aEmpenh,iif(_crastro="S",csublote,nil))        
	  
	   IF  len(_aEmpenh)> 0 .and.  lgeraemp
		 _lempenh :=U_BGHOP002(_aEmpenh,lInclui)
	   Endif		
Return()
