#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA261DOC   � Autor � Luciano Siqueira� Data �  21/05/12    ���
�������������������������������������������������������������������������͹��
���Descricao � P.E para bloquear altera��o documento na rotina transf.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA261DOC()

Local _aArea   := GetArea()
Local lRet     := GETMV("BH_CONTDOC")

u_GerA0003(ProcName())

RestArea(_aArea)

Return lRet
