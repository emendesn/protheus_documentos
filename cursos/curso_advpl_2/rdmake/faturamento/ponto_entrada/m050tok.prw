#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M050TOK   � Autor � Paulo Francisco    � Data � 17/12/10    ���
�������������������������������������������������������������������������͹��
���Descri�ao � EVITA INCLUSAO DE CADASTRO ERRONIO                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M050TOK()

//Local nOpcx := ParamIxb[1]
Local lRet := .T.

u_GerA0003(ProcName())

//If nOpcx == 3 .or. nOpcx == 4
	
	If ! ',' $ M->A4_END
		MsgAlert("Favor Revisar o Cadastro, Incluir Virgula e Numero no Endere�o")
		lRet := .F.
	Endif
	
	If '�' $ M->A4_COMPLEM .Or. ':' $ M->A4_COMPLEM .Or. '.' $ M->A4_COMPLEM
		MsgAlert("Favor Revisar o Cadastro, Campo Complemento esta com Caracteres � ou : ou . ")
		lRet := .F.
	EndIf
	
	
	If ',' $ M->A4_COMPLEM
		MsgAlert("Favor Remover a Segunda Virgula do Complemento")
		lRet := .F.
	EndIf
	
//EndIf

Return lRet