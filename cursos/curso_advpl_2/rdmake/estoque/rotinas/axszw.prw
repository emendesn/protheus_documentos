#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZW     �Autor  �D.FERNANDES         � Data �  11/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadasro de armazens do estoque                             ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AxSZW()
AxCadastro('SZW','Cadastro Armazens', "U_VLDSZW(5)", "U_VLDSZW()")
Return                                                     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDSZW    �Autor  �D.FERNANDES         � Data �  11/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao usada para criar e validar amarra��es com a tabela  ���
���          � SX5 - AL 												  ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VLDSZW(_nOpc)
             
Local lRet := .T.         
Local cTabela := PADR("AL",2)
         
If _nOpc == 5 //Exclui
	dbSelectArea("SX5")
	dbSetOrder(1)
		
	If MsSeek(xFilial("SX5")+cTabela+SZW->ZW_ALM)	
		SX5->(RecLock("SX5",.F.))
		SX5->(dbDelete())
		SX5->(MsUnLock())
	EndIf
Else
	//Trata inclucao da armazens no cadastro
	If INCLUI 
	                          
		dbSelectArea("SX5")
		dbSetOrder(1)
		
		If !MsSeek(xFilial("SX5")+cTabela+M->ZW_ALM)
			SX5->(RecLock("SX5",.T.))
			SX5->X5_FILIAL  := xFilial("SX5")
			SX5->X5_TABELA  := cTabela
			SX5->X5_CHAVE   := M->ZW_ALM
			SX5->X5_DESCRI  := M->ZW_DESCRI
			SX5->X5_DESCSPA := M->ZW_DESCRI		
			SX5->X5_DESCENG := M->ZW_DESCRI				
			SX5->(MsUnLock())
		EndIf
		
	EndIf
	
	//Trata exclusao da armazens no cadastro	
	If !INCLUI .And. ALTERA
		dbSelectArea("SX5")
		dbSetOrder(1)
		
		If MsSeek(xFilial("SX5")+cTabela+M->ZW_ALM)
		
			If M->ZW_MSBLQL == "1"		
				SX5->(RecLock("SX5",.F.))
				SX5->(dbDelete())
				SX5->(MsUnLock())
			Else
				SX5->(RecLock("SX5",.F.))
				SX5->X5_DESCRI  := M->ZW_DESCRI
				SX5->X5_DESCSPA := M->ZW_DESCRI		
				SX5->X5_DESCENG := M->ZW_DESCRI				
				SX5->(MsUnLock())			
			EndIf
		Else
			SX5->(RecLock("SX5",.T.))
			SX5->X5_FILIAL  := xFilial("SX5")
			SX5->X5_TABELA  := cTabela
			SX5->X5_CHAVE   := M->ZW_ALM
			SX5->X5_DESCRI  := M->ZW_DESCRI
			SX5->X5_DESCSPA := M->ZW_DESCRI		
			SX5->X5_DESCENG := M->ZW_DESCRI				
			SX5->(MsUnLock())					
		EndIf	
	EndIf
EndIf
	
Return lRet