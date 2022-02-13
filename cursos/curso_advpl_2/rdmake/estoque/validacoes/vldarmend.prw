#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDARMEND �Autor  �Hudson de Souza Santos� Data �08/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que valida transi��o de produtos entre armaz�ns e    ���
���          �endere�os.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VLDARMEND(cArmOri, cEndOri, cArmDest, cEndDest)
Local lRet	:= .T.
Local aArea	:= GetArea()
Local cQry	:= ""
Local lParam := GetMV("BH_DEPARA",.F.)
//��������������������������������������������������������������������ͻ
//�Regra 01�Parametro ligado e nenhum armaz�m n�o pode ser vazio       �
//��������������������������������������������������������������������ͼ
If !lParam
	Return(lRet)
ElseIf Empty(cArmOri) //.OR. Empty(cArmDest)
	lRet := .F.
	Return(lRet)
EndIf
//��������������������������������������������������������������������ͻ
//�Regra 02�Query que busca registro na SZW que antenda a regra de     �
//�        �negocio                                                    �
//��������������������������������������������������������������������ͼ
cQry := "SELECT count(*) as QTD FROM "+RetSQLName("SZW")+"(NOLOCK)"
cQry += " WHERE D_E_L_E_T_ = ''"
cQry += " AND ZW_FILIAL = '"+xFilial("SZW")+"'"
cQry += " AND ZW_ARMDE = '"+cArmOri+"'"
cQry += " AND ZW_ENDDE in ('"+cEndOri+"','*')"
If !Empty(cArmDest)
	cQry += " AND ZW_ARMPARA = '"+cArmDest+"'"
	cQry += " AND ZW_ENDPARA in ('"+cEndDest+"','*')"
EndIf
cQry += " AND ZW_MSBLQL <> '1'"
If Select("QRY") <> 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif
TCQUERY cQry NEW ALIAS "QRY"
If QRY->QTD == 0
	lRet := .F.
Endif
dbSelectArea("QRY")
dbCloseArea()
Return(lRet)