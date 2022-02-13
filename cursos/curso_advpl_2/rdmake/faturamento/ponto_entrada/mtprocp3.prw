#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTPROCP3  �Autor  �Graziella Bianchin  � Data �  03/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Criacao do Ponto de Entrada que verifica se o item em       ���
���          �questao deve ou n�o compor a tela de NF de Origens.         ���
�������������������������������������������������������������������������͹��
���Uso       � Uso exclusivo BGH                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTPROCP3()

Local aArea		:= GetArea()  
Local cCliNFE10 := Getmv("BH_CLINFE10",.F.,"19182601")
Local cCliSB6	:= B6_CLIFOR+B6_LOJA   
Local cDocSB6	:= B6_DOC+B6_SERIE
Local nSaldo	:= B6_SALDO
Local lProcessa := .T.
Local cCGCSC5   :=""
Local cCGCZZQ   :=""

u_GerA0003(ProcName())

IF nSaldo > 0
	lProcessa := .T.
	If Upper(Funname()) $ "MATA410"
		If cCliSB6==cCliNFE10
			cCGCSC5   :=Posicione("SA1",1,xFilial("SA1") + C5_CLIENTE+C5_LOJACLI, "A1_CGC")
			dbSelectArea("ZZQ")
			dbSetOrder(5)
			If dbSeek(xFilial("ZZQ")+cDocSB6)
				cCGCZZQ   :=Posicione("SA1",1,xFilial("SA1") + ZZQ->ZZQ_CLIORI+ZZQ->ZZQ_LOJORI, "A1_CGC")
				If  Left(cCGCZZQ,8) <> Left(cCGCSC5,8)
					lProcessa := .F.
				Endif
			Endif
		Endif
	Endif
ELSE
	lProcessa := .F.
ENDIF

RestArea(aArea)

Return(lProcessa)