#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �VLDPROD   � Autor � Edson Rodrigues - BGH � Data � 05/04/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida dados e parametros para executar rotinas             |��
���          |de inclus�o ou exclus�o de  Produ��o                        |��
�������������������������������������������������������������������������Ĵ��
���Retorno   �  .T. - True  ou .F. - False                                |��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VldProd(cOpe,cLAB)
Local lVld	:= .F.
Local aArea	:= GetArea()
u_GerA0003(ProcName())
dbselectarea("ZZJ")
dbsetorder(1)
If dbSeek(xFilial("ZZJ")+cOpe+cLab)
	//�������������������������������������������������������Ŀ
	//�Incluso Edson Rodrigues - 20/03/10                     �
	//�Para entrar na fun��o somente quando estiver preenchido�
	//�o armaz�m de processo e C�digo de Movimenta��o Interna �
	//�no cadastro de Opera��es.                              �
	//���������������������������������������������������������
	IF !Empty(ZZJ->ZZJ_CODPRO) .AND. !Empty(ZZJ->ZZJ_ALMPRO)
		lVld := .T.
	EndIf
EndIf
Restarea(aArea)
Return(lVld)