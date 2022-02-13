#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP530    �Autor  �Edson Rodrigues     � Data �  23/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function lp530()

local _nvalor   := 0 
Local _calias   := alias() 
local _aAreaSE2 := SE2->(GetArea())
local _aAreaSE5 := SE5->(GetArea())
local _aAreaSE5 := SE5->(GetArea())
Local _ctitSE5  := SE5->E5_NUMERO+SE5->E5_TIPO+SE5->E5_PARCELA
Local _ctitSE2  := SE2->E2_NUM+SE2->E2_TIPO+SE2->E2_PARCELA
Local nvalSE5   := SE5->E5_VALOR
Local nvalSE2   := SE2->E2_VALLIQ

u_GerA0003(ProcName())

IF nvalSE5 > 0
   _nvalor:=nvalSE5
Elseif nvalSE2 > 0
   _nvalor:=nvalSE2
Endif


restarea(_aAreaSED)
restarea(_aAreaSE1)

return(_cConta)
