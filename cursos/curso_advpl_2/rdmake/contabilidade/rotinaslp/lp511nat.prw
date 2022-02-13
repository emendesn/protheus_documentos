#include "rwmake.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lp511nat  ºAutor  ³ Edson Rodrigues    º Data ³03/01/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno da conta  credito ou debito referente º±±
±±º          ³a Lp 511/001 / 512/001 Inclusao contas a pagar, no qual     º±±
±±º          ³o mesmo vai buscar a conta na tabela customizada ZZN,       º±± 
±±º          ³atraves do centro de custo superior do nivel mais           º±±
±±º          |alto e natureza especificas                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso   BGH ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function lp511nat(clp,cseq)   

SetPrvt("_CCONTA,")
_cConta  := Space(20) 
_nTcodpr := TAMSX3("CTT_CCSUP")[1]
_cCCusto := CUSTO
_cCCusto := IIF(EMPTY(_cCCusto),CV4->CV4_CCC,_cCCusto)
_cnaturz := M->E2_NATUREZ       
_cnaturz := IIF(empty(_cnaturz),SE2->E2_NATUREZ,_cnaturz)

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

_cCCSup  := SPACE(_nTcodpr) // Centro de custo Superior
_cCCSOP  := SPACE(_nTcodpr) // Centro de custo Superior Operacional
_areactt := CTT->(GetArea())

Dbselectarea("ZZN")
Dbsetorder(2)

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

restarea(_areactt)

IF !EMPTY(_cCCSOP) 
   IF ZZN->(dbSeek(xFilial("ZZN")+_cCCSOP+_clanpad+_cseqlpd+_cnaturz)) 
     _cConta :=ZZN->ZZN_CONTA
   ENDIF
ENDIF 

Return(_cConta)       