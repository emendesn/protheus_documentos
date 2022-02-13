#include "rwmake.ch"      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Depric    �Autor  � Edson Rodrigues    � Data �19/12/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno da conta  credito ou debito referente ���
���          �aos Lancamentos padronizados de depreciacao, no qual o mesmo���
���          �vai buscar a conta na tabela customizada ZZN, atraves do    ��� 
���          �centro de custo superior no nivel mais alto.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso   BGH �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function depric()   

u_GerA0003(ProcName())

SetPrvt("_CCONTA,")
_cConta  := Space(20) 
_nTcodpr := TAMSX3("CTT_CCSUP")[1]
_cCCusto := SN3->N3_CCUSTO
_clanpad := CT5->CT5_LANPAD
_cseqlpd := CT5->CT5_SEQUEN
_cCCSup  := SPACE(_nTcodpr) // Centro de custo Superior
_cCCSOP  := SPACE(_nTcodpr) // Centro de custo Superior Operacional
_areactt := CTT->(GetArea())



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

restarea(_areactt)

IF !EMPTY(_cCCSOP) 
   IF ZZN->(dbSeek(xFilial("ZZN")+_cCCSOP+_clanpad+_cseqlpd)) 
     _cConta :=ZZN->ZZN_CONTA
   ENDIF
ENDIF 

Return(_cConta)       