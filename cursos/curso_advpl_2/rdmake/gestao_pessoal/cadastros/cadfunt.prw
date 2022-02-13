#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �cadfunt  �Autor Carlos Gustavo         � Data �  27/06/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Mbrowse para altera��o de registros de funcion�rios        ���
���          � com matriculas iniciadas Por 9 acesso terceiros            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function cadfunt()

Local cFilter := "RA_MAT LIKE '9%'"  // filtrando apenas as matriculas iniciadas com 9

Private cCadastro := "Cadastro de Funcionarios"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Incluir","AxInclui",0,3} ,;
                     {"Alterar","AxAltera",0,4} ,;
                     {"Excluir","AxDeleta",0,5} }
Private cDelFunc := ".T." // Validacao para a exclusao. ExecBlock
Private cString := "SRA"

u_GerA0003(ProcName())

dbSelectArea("SRA")
dbSetOrder(1)       

dbSelectArea(cString) 

mBrowse(6,1,22,75,cString,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cFilter,NIL,NIL,NIL,NIL)

Return
