/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     �Autor  �Microsiga           � Data �  08/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function at460dok()

local _lRet     := .t.
local _aAreaZZ4 := ZZ4->(GetArea())

u_GerA0003(ProcName())

ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
if ZZ4->(dbSeek(xFilial("ZZ4") + AB9->AB9_SN + left(AB9->AB9_NUMOS,6))) .and. ZZ4->ZZ4_STATUS > '5' // Status = a partir de Saida Massiva lida

	_lRet := .f.
	apMsgStop('Este atendimento de OS n�o poder� ser exclu�do porque o aparelho encontra-se em status posterior a OS encerrada.','Exclus�o de atendimento de OS n�o permitida!')

endif

restarea(_aAreaZZ4)

return(_lRet)