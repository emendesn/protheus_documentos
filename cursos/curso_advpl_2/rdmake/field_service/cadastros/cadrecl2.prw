#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADRECL2  � Autor � Edson rodrigues    � Data �  16/09/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADRECL2()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Local cfiltro := "X5_TABELA='W4'"
Private cString := "SX5"

u_GerA0003(ProcName())

dbSelectArea("SX5")
dbSetOrder(1) 
Set Filter to &cfiltro

//ProcRegua(RecCount())

DbGoTop()                          



AxCadastro(cString,"Cadastro de Reclamacoes de Cliente - Motorola",cVldExc,cVldAlt)

Return
