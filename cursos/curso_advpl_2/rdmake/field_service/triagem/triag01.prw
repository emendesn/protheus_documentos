#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRIAG01   �Autor  �Paulo Francisco     � Data �07/12/2011   ���
�������������������������������������������������������������������������͹��
���Descricao �CADASTRO TRIAGEM CLA                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRIAG01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Cadastro Triagem CLA"
Private aCores    := {}
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut  	:= .F.
Private lUsrAdm  	:= .F.
Private lUsrExp		:= .F.


u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(aGrupos[i])) $ "Nextelanha"
		lUsrAut  := .T.
	EndIf
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Nexteladm"
		lUsrAdm  := .T.
		lUsrAut  := .T.
	EndIf
	
	If AllTrim(GRPRetName(aGrupos[i])) $ "Explider"
		lUsrExp  := .T.
	EndIf
	
Next i

//���������������������������������������������������������������������Ŀ
//| Usuario Expedi��o                                                   |
//�����������������������������������������������������������������������
If lUsrExp == .T.
   
	MsgStop("Usuario sem acesso a essa rotina!")
	Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar" 	,"AxPesqui"   	, 0, 1},;
{"Visualizar"	,"AxVisual"   	, 0, 2},;
{"Incluir"   	,"AxInclui"   	, 0, 3},;
{"Alterar"   	,"U_TRIAG02(3)"	, 0, 4},;
{"Excluir"   	,"U_TRIAG02(4)"	, 0, 5},;
{"Fitr Status"	,"U_TRIAG03"	, 0, 2},;
{"Imp. Nextel"  ,"U_IMPARQNEX"	, 0, 3},;
{"Imp. CLA"		,"U_IMPARQCLA"	, 0, 3},;
{"Limpeza" 		,"U_TRIAG02(1)"	, 0, 2},;
{"Legenda"   	,"U_TRIAG02(2)"	, 0, 2}}


Private cString := "ZZT"

//���������������������������������������������������������������������Ŀ
//� Cores da Legenda                                                    �
//�����������������������������������������������������������������������
aAdd(aCores, {"ZZT_STATUS == '1'", "DISABLE"  })    //Equipamento com Problema Fiscal
aAdd(aCores, {"ZZT_STATUS == '2'", "ENABLE"   })    //Equipamento Valido
aAdd(aCores, {"ZZT_STATUS == '3'", "BR_PRETO" })    //Equipamento Triado

//���������������������������������������������������������������������Ŀ
//� Montagem do Browse                                                  �
//�����������������������������������������������������������������������
dbSelectArea(cString)
dbSetOrder(1)
dbSelectArea(cString)
mBrowse(6, 1, 22, 75, cString,,,,,, aCores)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRIAG02   �Autor  �Paulo Francisco     � Data �07/12/2011   ���
�������������������������������������������������������������������������͹��
���Descricao �FUNCAO AUXILIAR                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRIAG02(nOpc)

Local cQryExe

If nOpc == 1
	
	//���������������������������������������������������������������������Ŀ
	//| Limpeza de Tabela                                                   |
	//�����������������������������������������������������������������������
	
	cQryExe := " TRUNCATE TABLE " + RetSqlName("ZZT")
	TcSqlExec(cQryExe)
	TCRefresh(RETSQLNAME("ZZT"))
	
EndIf

If nOpc == 2
	
	//���������������������������������������������������������������������Ŀ
	//| Legenda                                                             |
	//�����������������������������������������������������������������������
	
	aCorDesc := {	{"ENABLE"     	, "Equipamento Valido"      },;
	{"BR_PRETO"		, "Equipamento Triado"     },;
	{"DISABLE"   	, "Equipamento com Problema Fiscal"   }}
	
	BrwLegenda(cCadastro, "Status", aCorDesc )
	Return ( .T. )
	
EndIf

If nOpc == 3
	
	//���������������������������������������������������������������������Ŀ
	//| Alteracao                                                           |
	//�����������������������������������������������������������������������
	
	If ZZT->ZZT_STATUS == "1"
		AxAltera("ZZT", Recno(), 4)
	EndIf
	
EndIf

If nOpc == 4
	
	//���������������������������������������������������������������������Ŀ
	//| Exclusao                                                            |
	//�����������������������������������������������������������������������
	
	If ZZT->ZZT_STATUS == "1"
		AxDeleta("ZZT", Recno(), 5)
	EndIf
	
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRIAG03   �Autor  �Paulo Francisco     � Data �07/12/2011   ���
�������������������������������������������������������������������������͹��
���Descricao �FUNCAO FILTRO                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Triag03()

Private cFiltro
Private oSelec
Private nOpcao   := 0
Private bOk      := {|| nOpcao := 1, oSelec:End()}
Private bCancel  := {|| nOpcao := 0, oSelec:End()}


aEscolha := {"Todos", "Problemas Fiscais", "Equipamentos Validos", "Equipamentos Triados"}
nEscolha := 1

DEFINE MSDIALOG oSelec TITLE "Filtros" FROM 001,001 TO 125,185 PIXEL
@ 020,010 RADIO aEscolha VAR nEscolha
ACTIVATE MSDIALOG oSelec ON INIT EnchoiceBar(oSelec, bOk, bCancel,,) CENTERED

If nOpcao == 1
	If nEscolha == 1
		Set Filter to
	ElseIf nEscolha == 2
		Set Filter to &(" @ ZZT_STATUS = '1' ")
	ElseIf nEscolha == 3
		Set Filter to &(" @ ZZT_STATUS = '2' ")
	ElseIf nEscolha == 4
		Set Filter to &(" @ ZZT_STATUS = '3' ")
	Endif
EndIf

dbSelectArea("ZZT")
dbGoTop()

Return()