#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010ALT  �Autor  �Hudson de Souza Santos� Data  � 02/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para altera��o do cadastro de produtos.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010ALT()
Local cPath := "\\BGH006\ImagensProtheus\"
If !Empty(SB1->B1_BITMAP)
	u_MT010IMG(cPath, SB1->B1_COD)
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010IMG  �Autor  �Hudson de Souza Santos� Data  � 02/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que gera imagem a partir do cadastro de produto.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �BGH                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010IMG(cCaminho, cProduto)
Local cFile := ""
cProduto := Alltrim(cProduto)
If right(Alltrim(cCaminho),1) <> "\"
	cCaminho := Alltrim(cCaminho)+"\"
EndIf
cFile := cCaminho + cProduto + ".jpg"
RepExtract(cProduto,cFile,,.T.)
Return()