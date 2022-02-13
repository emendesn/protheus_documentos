#include 'protheus.ch'
#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LOGMCL   �Autor  � M.Munhoz           � Data �  13/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gravacao do LOG MCLAIM                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH - NEXTEL                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function LOGMCL(_cTipo, _cArqNome, _cArqData, _cArqTam)

local _cCodigo  := ""
local _aAreaSZQ := SZQ->(getarea())

u_GerA0003(ProcName())

if !empty(_cArqNome)

	SZQ->(dbSetOrder(2)) // ZQ_FILIAL + ZQ_ARQNOM
	if SZQ->(dbSeek(xFilial("SZQ")+alltrim(_cArqNome)))
		apMsgStop('Caro usu�rio. O arquivo '+alltrim(_cArqNome)+' j� foi processado anteriormente! Esta rotina ser� cancelada. Favor verificar.','Arquivo j� processado!')
	else
		SZQ->(dbGoBottom())
		_cCodigo := GetSXENum("SZQ","ZQ_CODIGO",,1) //iif(empty(SZQ->ZQ_CODIGO),"000001",Soma1(SZQ->ZQ_CODIGO))
		reclock("SZQ",.t.)
		SZQ->ZQ_FILIAL  := xFilial("SZQ")
		SZQ->ZQ_CODIGO  := _cCodigo
		SZQ->ZQ_LAB     := "2"
		SZQ->ZQ_TIPO    := _cTipo
		SZQ->ZQ_ARQNOM  := _cArqNome
		SZQ->ZQ_ARQDT   := _cArqData
		SZQ->ZQ_ARQTAM  := _cArqTam
		SZQ->ZQ_USER    := cUserName
		SZQ->ZQ_DATA    := dDataBase
		SZQ->ZQ_HORA    := time()
		SZQ->ZQ_ANOMCL  := mv_par01
		SZQ->ZQ_MESMCL  := mv_par02
		SZQ->ZQ_BATCH   := mv_par03
		msunlock()
		ConfirmSX8(.t.)
	endif
endif

restarea(_aAreaSZQ)

return(_cCodigo)
