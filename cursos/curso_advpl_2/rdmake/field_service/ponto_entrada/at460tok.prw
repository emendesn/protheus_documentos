/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AT460TOK �Autor  �M.Munhoz - ERP PLUS � Data �  08/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na validacao total do atendimento da OS   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function at460tok()

local _lRet   := .t.
local _aArea  := GetArea()
local _aAB6   := AB6->(GetArea())

u_GerA0003(ProcName())

AB6->(dbSetOrder(1))  // AB6_FILIAL + AB6_NUMOS
if AB6->(dbSeek(xFilial("AB6") + M->AB9_NUMOS )) .and. AB6->AB6_NUMVEZ > "2"

	if !apMsgYesNo("Esta � a "+alltrim(AB6->AB6_NUMVEZ)+"a. vez que o IMEI "+alltrim(M->AB9_SN)+" entrou para manuten��o. Confirma atendimento deste aparelho?","")
		_lRet := .f. 
	endif

endif

if M->AB9_TIPO == "1" .and. empty(M->AB9_XTCENC)
	_lRet := .f.
	apMsgStop("Ao encerrar a OS deve-se informar o tecnico de encerramento.")
endif

RestArea(_aAB6)
RestArea(_aArea)

return(_lRet)