#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CVALRFTS  � Autor � AP6 IDE            � Data �  20/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de valores faturamento de Servi�o                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CVALRFTS()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrfts  	:= .F.
Private lUsrAdmi    := .F.
Private cCadastro := "Cadastro de Valores faturamento Servi�os"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4}} 
             
Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "ZZP"

u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	
	//Usuarios Nextel - Motorola
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,11) == "cadvalorfts"
		lUsrfts  := .T.
	EndIf
	
	//Administradores
	If Substr(AllTrim(GRPRetName(aGrupos[i])),1,4) $ "Admi"
		lUsrAdmi := .T.
	EndIf
Next i

If lUsrAdmi .or.  lUsrfts
   dbSelectArea("ZZP")
   dbSetOrder(1)
   mBrowse( 6,1,22,75,cString)

else
MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")

Endif


Return