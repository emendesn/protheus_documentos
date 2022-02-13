#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA260D3  �Autor  �Luciano Siqueira   � Data �  25/09/12   ��
�������������������������������������������������������������������������͹��
���Desc.     � Atualizar conteudo do campo D3_XGRMOVI                      ��
�������������������������������������������������������������������������͹��
���Uso       � BGH 														   ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA260D3()

Local _aArea  	:= GetArea()
Local _nRecno 	:= SD3->(Recno())
Local _cDoc	  	:= SD3->D3_DOC
Local _cProd  	:= SD3->D3_COD
Local _cXGrMovi := ""

u_GerA0003(ProcName())

If IsTelNet()
	dbSelectArea("SD3")
	dbGoTop()
	dbSetOrder(2)
	If dbSeek(xFilial("SD3")+_cDoc+_cProd)
		While !Eof() .and. SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD == xFilial("SD3")+_cDoc+_cProd
			If !Empty(SD3->D3_XGRMOVI)
				_cXGrMovi := SD3->D3_XGRMOVI
				Exit
			Endif
			dbSkip()
		EndDo
	Endif
	
	If !empty(_cXGrMovi)
		dbSelectArea("SD3")
		dbGoTop()
		dbSetOrder(2)
		If dbSeek(xFilial("SD3")+_cDoc+_cProd)
			While !Eof() .and. SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD == xFilial("SD3")+_cDoc+_cProd
				If Empty(SD3->D3_XGRMOVI)
					reclock("SD3",.F.)
					SD3->D3_XGRMOVI :=_cXGrMovi
					msunlock()
				Endif
				dbSkip()
			EndDo
		Endif
	Endif
Endif

SD3->(dbgoto(_nRecno))
RestArea(_aArea)
Return
