// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : M460FIM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 27/01/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

User Function M460FIM()
	
	SC5->(dbSetOrder(1)) // C5_FILIAL+C5_NUM
	SD2->(dbSetOrder(3))
	
	
	If SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		While !SD2->(Eof()) .and. xFilial("SD2")+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
			
			//--------------------- Grava o número do ticket
			If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				
				If !Empty(SC5->C5_XNUMTIC)
					SD2->(RecLock("SD2",.F.))
					SD2->D2_XCSSNUM := SC5->C5_XNUMTIC
					SD2->(MsUnlock())
				Endif
			Endif
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV+D2_COD))
				If !Empty(SC6->C6_NUMPCOM)
					dbSelectArea("Z14")
					dbSetOrder(2)
					If dbSeek(xFilial("Z14")+LEFT(SC6->C6_NUMPCOM,8))
						SD2->(RecLock("SD2",.F.))
						SD2->D2_XCSSNUM := LEFT(SC6->C6_NUMPCOM,8)
						SD2->(MsUnlock())						
					Endif				
				Endif			
			Endif			
			SD2->(dbSkip())
		Enddo
	Endif
	
	//Chama rotina para impressão de etiqueta para Sedex/e-Sedex - Vinicius Leonardo/Delta Decisão
	//U_OperSedex()  
	
Return
