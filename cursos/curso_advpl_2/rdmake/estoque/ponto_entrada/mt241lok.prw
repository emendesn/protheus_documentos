#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT241LOK  �Autor  �Luciano Oliveira       � Data � 25/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �LOCALIZA��O: A241LinOk (Consistencias apos a digitacao da   ���
���          �             tela de Inclusao de Movimenta��o Interna)      ���
���          �EM QUE PONTO:Ap�s a confirma��o da digita��o da linha,antes ���
���          �             da grava��o, deve ser utilizado como valida��o ���
���          �             complementar desta. Este ponto de entrada      ���
���          �             somente ser� executado se a linha da getdados  ���
���          �             for validada pela fun��o A241LinOk.            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT241LOK()
Local aArea			:= GetArea()
Local lRet			:= .T.
Local nAt			:= ParamIxb[1]
Local _nPosxGrMovi	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D3_XGRMOVI"})
Local _nPosLOCOri	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})
Local cGrupo		:= aCols[naT,_nPosxGrMovi]
Local cLocal		:= aCols[naT,_nPosLocOri]
u_GerA0003(ProcName())
If Upper(Funname()) $ "MATA241"
	If !acols[nAt][len(aHeader)+1]
		If Alltrim(cTM) == "998" .and. Empty(cGrupo)
			lRet := .F.
			MsgAlert("Favor preencher o campo Grupo Mov. para prosseguir!")
		EndIf
	EndIf
EndIf
//Valida existencia do armazem
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocal,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocal)+" não existente no Cadastro. Entrar em contato com a Controladoria!","Armazém inválido")
	Return(.F.)
Else
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocal)+" bloqueado. Entrar em contato com a Controladoria!","Armazém bloqueado")
		Return(.F.)
	EndIf
EndIf
RestArea(aArea)
Return lRet