#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA330TRB  �Autor  �D.FERNANDES         � Data �  11/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E para desconsiderar as requisi��es em aberta             ���
���          �referente TM 998                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH DO BRASIL                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA330TRB()

Local _aArea 	:= GetArea()       
Local _aAreaSd3	:= SD3->(Getarea())

dbSelectArea("TRB")
TRB->(dbGoTop())

While TRB->(!Eof())
	If Alltrim(TRB->TRB_ALIAS)=="SD3" .AND. Alltrim(TRB->TRB_CF) $ "RE0"
		
		dbSelectArea("SD3")
		dbGoto(TRB->TRB_RECNO)                 
				                                
		//N�o considera movimento 998 (Processo customizado), porque s�o utilizados para requisi��o no WMS.				
		If Alltrim(SD3->D3_TM) == "998"			
			dbSelectArea("TRB")
			TRB->(RecLock("TRB",.F.))
			TRB->(dbDelete())
			TRB->(MsUnLock())
		EndIf
	EndIf 	 		
 	TRB->(dbskiP())
Enddo

RestArea(_aArea)
RestArea(_aAreaSd3)

Return