#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUCHV    �Autor  �Graziella Bianchin  � Data �  04/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para gravacao da chave, da nota fiscal de entrada.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo BGH                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtuChv()

//declara��o de variaveis
Local cNota  	:= ""
Local cSerie 	:= ""
Private cChave 	:= space(46)
Private cPerg	:="ATUCHV"   
Private oDlg
Private ocCliente

u_GerA0003(ProcName())

//chama o arquivo de perguntas
if !Pergunte(cPerg,.T.)
	Return()
Endif

//������������������������������������������������������������������������Ŀ
//� Definicao da janela e seus conteudos                                   �
//��������������������������������������������������������������������������
DEFINE MSDIALOG oDlg TITLE "Consulta Garantia" FROM 0,0 TO 210,420 OF oDlg PIXEL

@ 010,015 SAY "Informe a CHAVE da Nota Fiscal de Entrada." 	SIZE 150,008 PIXEL OF oDlg
@ 035,015 TO 070,200 LABEL "CHAVE" PIXEL OF oDlg
@ 042,023 GET cChave PICTURE "@!" 	SIZE 0175,010 Valid u_Valchave(@cChave) Object ocChave 
//������������������������������������������������������������������������Ŀ
//� Botoes da MSDialog                                                     �
//��������������������������������������������������������������������������
@ 080,100 BUTTON "&Sair" SIZE 36,16  PIXEL ACTION (oDlg:end())

Activate MSDialog oDlg CENTER On Init ocChave:SetFocus()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALCHAVE  �Autor  �Graziella Bianchin  � Data �  04/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que atualiza o campo chave                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso exclusivo BGH										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Valchave()

//Criacao de variaveis
Local cQuery 	:= ""
//Alimenta a variavel para execucao do Select no banco
cQuery:= " SELECT F1_DOC, F1_CHVNFE FROM " +Retsqlname ("SF1") + " "
cQuery+= " WHERE F1_DOC =    '" + MV_PAR01 + "' "
cQuery+= " AND F1_SERIE =    '" + MV_PAR02 + "' "
cQuery+= " AND F1_FORNECE=   '" + MV_PAR03 + "' "
cQuery+= " AND F1_LOJA =     '" + MV_PAR04 + "' "
cQuery+= " AND D_E_L_E_T_ <> '*'"

//Verifica se a tabela ja existe
if select("TRB1") > 0
	TRB1->(dbclosearea())
endif
//Cria a tabela temporaria
TCQUERY cQuery NEW ALIAS "TRB1"

//Contagem de registro
ProcRegua(TRB1->(reccount()))
TRB1->(dbGoTop())
//Verifica se tem dados na tabela temporaria
While !TRB1->(Eof())
	If !Empty(@cChave)
		Begin Transaction                                    
		//Alimenta a variavel para execucao do UPDATE no banco
		cQuery:= ""
		cQuery+= " UPDATE " +Retsqlname ("SF1") + ""
		cQuery+= " SET F1_CHVNFE =   '" + Alltrim(@cChave) + "' "	
		cQuery+= " FROM   " +Retsqlname ("SF1") + ""
		cQuery+= " WHERE F1_DOC =    '" + MV_PAR01 + "' "
		cQuery+= " AND F1_SERIE =    '" + MV_PAR02 + "' "
		cQuery+= " AND F1_FORNECE =  '" + MV_PAR03 + "' "
		cQuery+= " AND F1_LOJA =     '" + MV_PAR04 + "' "
		cQuery+= " AND D_E_L_E_T_ <> '*'"
		TcSqlExec(cQuery)   
		
		End Transaction 
		ApMsgInfo("Chave gravada com sucesso.") 
	else
		ApMsgInfo("Nota n�o encontrada. Por favor, verifique os par�metros digitados.")
	endif
	TRB1->(DBSKIP())
Enddo
//Fim do programa
Return