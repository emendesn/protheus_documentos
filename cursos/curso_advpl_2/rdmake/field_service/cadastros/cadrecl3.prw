#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADRECL3  � Autor � Paulo Francisco    � Data �  08/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADRECL3()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Local cfiltro := "X5_TABELA='W7'"
Private cString := "SX5"

u_GerA0003(ProcName())

dbSelectArea("SX5")
dbSetOrder(1) 
Set Filter to &cfiltro

//ProcRegua(RecCount())

DbGoTop()                          



AxCadastro(cString,"Cadastro de Problem Fault - Motorola",cVldExc,cVldAlt)

Return