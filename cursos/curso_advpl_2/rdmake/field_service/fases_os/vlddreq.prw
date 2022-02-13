#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �VLDDREQ   � Autor � Edson Rodrigues - BGH � Data � 24/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida dados e parametros para permitir a inser��o de       |��
���          |Movimenta��o Interna no sistema                             |��
���          |Para pe�as apontadas                                        |��
�������������������������������������������������������������������������Ĵ��
���Retorno   �  .t. - True  ou .f. - False                                |�� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION VLDDREQ(cOpe,cLAB)
  Local lvld:=.f.
  Local aArea    := GetArea()

u_GerA0003(ProcName())

  Dbselectarea("ZZJ")
  Dbsetorder(1)
  IF DBSEEK(XFILIAL("ZZJ")+cOPE+cLab)                             
	   IF !EMPTY(ZZJ->ZZJ_CODSF5) .AND. !EMPTY(ZZJ->ZZJ_ALMEP) // Incluso Edson Rodrigues - 20/03/10 - Para entrar na fun��o somente quando estiver preenchido o armaz�m de processo e C�digo de Movimenta��o Interna no cadastro de Opera��es
					   lvld:=.t.
		ENDIF			   
  ENDIF					   
  Restarea(aArea)
Return(lvld)