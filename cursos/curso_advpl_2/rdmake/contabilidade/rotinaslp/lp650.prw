#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATA001  �Autor  �Microsiga           � Data � 01 /08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina Contabilidade             .                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User function lp650(_cTipo)
 
Local _aAreaSED := SED->(GetArea())
Local _cConta  := ""

u_GerA0003(ProcName())

//_cNatNFE:= MaFisRet(,"NF_NATUREZA")
 
SED->(dbSetOrder(1))

If SED->(dbSeek(xFilial("SED") + MaFisRet(,"NF_NATUREZA")))
//If SED->(dbSeek(xFilial("SED") + _cNatNFE) )

                _cConta := iif(_cTipo == "D", SED->ED_CONTA, Iif(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,"2110199999"))

EndIf
 
RestArea(_aAreaSED)
 
Return(_cConta) 
