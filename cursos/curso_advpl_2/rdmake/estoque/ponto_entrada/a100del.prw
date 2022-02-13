#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100DEL   �Autor  �Uiran Almeida       � Data �  09/14/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para a rotina de exclusao de nota fiscal  ���
���          �de entrada, somente permitido aos usuarios no grupo         ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A100DEL()
Local lRet := .F.
Private aGrupos	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
//������������������������������������������������������������������Ŀ
//�Valida acesso a exclusao, atendendo demanda do chamado GLPI 23.940�
//��������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,5) $ "EXCNF"
		lRet  := .T.
	EndIf
Next i
If !lRet
	MsgAlert("Usu�rio sem autoriza��o para exclus�o !","A100DEL")
EndIf

Return(lRet)
