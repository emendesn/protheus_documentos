#include "rwmake.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lanc_000  ºAutor  ³ Edson Rodrigues    º Data ³19/12/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno da conta  credito ou debito referente º±±
±±º          ³aos Lancamentos padronizados da folha, no qual o mesmo      º±±
±±º          ³vai buscar a conta na tabela customizada ZZN, atraves do    º±± 
±±º          ³centro de custo superior no nivel mais alto.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso   BGH ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Lanc_000(clp,cseq)   

SetPrvt("_CCONTA,")
_cConta   := Space(20) 
_nTcodpr  := TAMSX3("CTT_CCSUP")[1]
_areactt  := CTT->(GetArea())
_areact5  := CT5->(GetArea())
_cCCSup   := SPACE(_nTcodpr) // Centro de custo Superior
_cCCSOP   := SPACE(_nTcodpr) // Centro de custo Superior Operacional

u_GerA0003(ProcName())

If clp = nil 
   _clanpad  := CT5->CT5_LANPAD
Else
   _clanpad  := clp
Endif

If cseq = nil 
   _cseqlpd  := CT5->CT5_SEQUEN
Else
   _cseqlpd  := cseq
Endif


Dbselectarea("CT5")
Dbsetorder(1)
IF CT5->(Dbseek(xfilial("CT5") +  _clanpad + _cseqlpd ))
    _ccusclp  := alltrim(CT5->CT5_CCC)
    _ccusdlp  := alltrim(CT5->CT5_CCD)
    _ndivcclp :=AT("-",_ccusclp) 
    _ndivcdlp :=AT("-",_ccusdlp) 
    _ltabela  := .f. 
    dbSelectArea("SX3")
    dbSetOrder(2)
		

    If _ndivcclp > 0 .or.  _ndivcdlp > 0
       _ctabcclp := substr(_ccusclp,1,_ndivcclp-1)
       _ctabcdlp := substr(_ccusdlp,1,_ndivcdlp-1)
       _ltabela  := .t.
    Endif                              

    // Verifica a tabela 
    If _ltabela .and. !empty(_ccusclp) .and. SX3->(dbSeek(substr(_ccusclp,_ndivcclp+2)))
       _cCCusto := &_ccusclp 
    Elseif _ltabela .and. !empty(_ccusdlp) .and. SX3->(dbSeek(substr(_ccusdlp,_ndivcdlp+2)))
       _cCCusto := &_ccusdlp 
    ELSE 
       msgstop("Favor cadastrar na LP : "+alltrim(_clanpad)+"/"+alltrim(_cseqlpd)+" a ORIGEM (Tabela -> Nome do Campo)  do centro de Custo debito ou crédito. Exemplo : SRZ->RZ_CC. "," Cadastro do Centro de Custo Invalido na LP","STOP") 
   	   _cCCusto:=""
    Endif


    Dbselectarea("ZZN")
    Dbsetorder(1)

    Dbselectarea("CTT")
    Dbsetorder(1)


    IF CTT->(dbSeek(xFilial("CTT") +_cCCusto)) 
       IF !EMPTY(CTT->CTT_CCSUP) .AND. CTT->CTT_BLOQ<>'1' 
          _cCCSup:=CTT->CTT_CCSUP 
      ENDIF         
    ENDIF


    IF !EMPTY(_cCCSup)
        WHILE !EMPTY(_cCCSup)
          _cCCSOP:=_cCCSup
         IF CTT->(dbSeek(xFilial("CTT")+_cCCSup))
            IF CTT->CTT_BLOQ<>'1' 
               _cCCSup:=CTT->CTT_CCSUP
            ELSE
               _cCCSup:=""
            ENDIF 
         ELSE
            _cCCSup:=""
         ENDIF
        ENDDO
    ENDIF                  

ENDIF

restarea(_areactt)
restarea(_areact5)


IF !EMPTY(_cCCSOP) 
   IF ZZN->(dbSeek(xFilial("ZZN")+_cCCSOP+_clanpad+_cseqlpd)) 
     _cConta :=ALLTRIM(ZZN->ZZN_CONTA)
   ENDIF
ENDIF 

Return(_cConta)       