#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �Vinicius Leonardo  � Data �  19/02/15    ���
�������������������������������������������������������������������������͹��
���Desc.     � 		  													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GetObj(cSigla,cCodAdm)

Local aArea   := Nil
Local cQuery  := "" 

Local nHdlSemaf := 0
Local cRotinExc := "OBJCOR"  

//MAXIMO DE 200 PILHAS DE CHAMADAS.
While !U_SemaNFE(cRotinExc, @nHdlSemaf, .T., lProces)
	If lProces .or. nStack >= 190 
		If nStack >= 190
			If !lMsg
				apMsgInfo('N�o foi poss�vel imprimir etiqueta devido a controle de processamento. Para imprimir a etiqueta, utilize a rotina de IMPRESS�O.','Controle de Processamento')	
				lMsg := .T.
			EndIf
		EndIf
		Return cObj
	EndIf
	nStack:=nStack+1
	Sleep(200)
	U_GetObj(cSigla,cCodAdm)
EndDo 

lProces := .T. 

aArea := GetArea()

If Select("ZB2") == 0
	DbSelectArea("ZB2")
EndIf	
ZB2->(DbSetOrder(3))

//Busca primeiro objeto v�lido que encontrar

cQuery := " SELECT TOP 1 ZB2_OBJETO FROM " + RetSqlName("ZB2") + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' " + CRLF 
cQuery += " AND ZB2_FILIAL = '" + xFilial("ZB2") + "' " + CRLF 
cQuery += " AND SUBSTRING(ZB2_OBJETO,1,2) = '" + cSigla + "' " + CRLF
cQuery += " AND ZB2_CODADM = '" + cCodAdm + "' " + CRLF 
cQuery += " AND ZB2_USADO <> 'S' " + CRLF

If Select("QRYOBJ") > 0
	QRYOBJ->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYOBJ",.T.,.T.)

QRYOBJ->(dbGoTop())

If QRYOBJ->(!eof())
	cObj := QRYOBJ->ZB2_OBJETO	
	ZB2->(DbGoTop())  	
	//ZB2_FILIAL+ZB2_OBJETO
	If ZB2->(DbSeek(xFilial("ZB2")+AvKey(cCodAdm,"ZB2_CODADM")+AvKey(cObj,"ZB2_OBJETO")))
		If Reclock("ZB2",.F.)
			ZB2->ZB2_USADO := "S"				
			ZB2->(MsUnlock())
		EndIf
	EndIf
Else
	apMsgInfo('N�o existem objetos a serem utilizados na impress�o de postagem. Interrompa as pr�ximas sa�das e entre em contato com seu gestor.','Range esgotado!')	
EndIf

RestArea(aArea)

U_SemaNFE(cRotinExc, @nHdlSemaf, .F.)

Return cObj 