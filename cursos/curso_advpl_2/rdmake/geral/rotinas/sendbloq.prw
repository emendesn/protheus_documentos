#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  12/06/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro do Motivo de Bloqueio de Numero de S�rie          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SendBloq()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cPerg := "1"
Private cCadastro := "Cadastro de Motivos de Bloqueio"

Private aRotina := { {"Pesquisar"   ,"AxPesqui" ,0,1} ,;
{"Visualizar" ,"AxVisual" ,0,2} ,;
{"Incluir"    ,"AxInclui" ,0,3} ,;
{"Alterar"    ,"AxAltera" ,0,4}}



//aAdd( aRotina, {"Cad.Repair" , "U_AXSZM"	  	, 0, 6})
	

Private cString := "Z12"

dbSelectArea("Z12")
dbSetOrder(1)

cPerg   := "1"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//AxCadastro(cString,"Cadastro de Motivos de Bloqueio",cVldExc,cVldAlt)
//mBrowse( ,,,,cString)  
mBrowse(,,,,cString,,,,,,)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return
