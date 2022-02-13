#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa�GP210SAL  �Autor  �Microsiga                � Data � 08/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.   �Na rotina de Gera��o do Relat�rio de Mapa de Vale Transporte, ���
���        �foi criado um ponto de entrada que permite a altera��o do     ���
���        �percentual de desconto do VT.                                 ���
�������������������������������������������������������������������������͹��
���Uso     �BGH                                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function GP210SAL()
Local cAliasSr0 := "SR0"
Local cAliasQry := "SRA"
u_GerA0003(ProcName())
dbSelectArea( cAliasSr0 )
If dbSeek( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT )
	While !Eof() .AND. ( (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT = (cAliasSr0)->R0_FILIAL + (cAliasSr0)->R0_MAT )
		If Alltrim((cAliasSr0)->R0_MEIO) $ "518"
			Reclock("SR0",.F.)
			(cAliasSr0)->R0_VALCAL := (cAliasSr0)->R0_QDIACAL * (cAliasSr0)->R0_XVALORU
			MsUnlock()
			dbSelectArea( cAliasSrn )
			If dbSeek( If(cFilial == "  ","  " + (cAliasSr0)->R0_MEIO , (CAliasSr0)->R0_FILIAL + (cAliasSr0)->R0_MEIO ) )
				Reclock("SRN",.F.)
				 (cAliasSrn)->RN_VUNIATU := (cAliasSr0)->R0_XVALORU
				MsUnlock()
			Endif
		Endif
		(cAliasSr0)->( dbSkip() )
	EndDo
Endif
Return .T.