#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͺ��                                                                                                      ���
���Programa  | CADRECLI � Autor |Edson Rodrigues     � Data �  02/03/10   ���
�������������������������������������������������������������������������ͺ��                                                                                                          ���
���Descricao � Codigo gerado pelo AP6 IDE.                                ��� 
���Cadastro de Reclama��o de Clientes         �                           ��� 
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADRECLI


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "ZZG"

u_GerA0003(ProcName())

dbSelectArea("ZZG")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Reclama��o de Clientes",cVldExc,cVldAlt)

Return