#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  BLOQSN     � Autor � AP6 IDE            � Data �  12/06/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BloqSn()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cPerg   := "1"
Private cString := "Z15"
Private cCadastro := "Bloqueio de Imeis"

Private aRotina := { {"Pesquisar"   ,"AxPesqui" ,0,1} ,;
{"Visualizar" ,"AxVisual" ,0,2} ,;
{"Incluir"    ,"AxInclui" ,0,3} ,;
{"Alterar"    ,"AxAltera" ,0,4} ,;
{"Importar"    ,"U_IMPZ15" ,0,4}}



dbSelectArea("Z15")
dbSetOrder(1)

cPerg   := "1"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//AxCadastro(cString,"Bloqueio de Imeis",cVldExc,cVldAlt)
mBrowse(,,,,cString,,,,,,)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return
