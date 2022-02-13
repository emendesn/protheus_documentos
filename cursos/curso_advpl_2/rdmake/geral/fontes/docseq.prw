#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOCSEQ    �Autor  � Paulo Francisco    � Data � 28/01/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para verificar a integridade do numero sequencial de ���
���          �notas fiscais, armazenado no MV_DOCSEQ.                     ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DocSeq()

Local aArea		:= GetArea()				// Armazena o posicionamento atual
Local aAlias	:= {"SD1","SD2","SD3"}		// Tabelas que utilizam controle de sequencia de documentos
Local aAreaTmp	:= {}						// Armazenamento temporario das areas utilizadas
Local cBusca	:= ""						// String para busca pelo ultimo sequencial
Local cMax		:= ""						// Maior documento encontrado entre as tabelas
Local cDoc		:= ""						// Maior documento encontrado para cada tabela
Local nX		:= 0						// Auxiliar de loop
Local nTamSeq	:= 0						// Tamanho do campo de controle de sequencia

u_GerA0003(ProcName())
 
If !("DEVEL" $ Upper(AllTrim(getenvserver())) .or. "TESTE" $ Upper(AllTrim(getenvserver())))
	MsgAlert ("Rotina disponivel somente para o ambiente/base TESTE !")
	Return
Endif

//������������������������������������������������������������Ŀ
//�Le o tamanho dos campos de sequencial e monta a string      �
//�com este tamanho para busca pelo ultimo sequencial utilizado�
//��������������������������������������������������������������
nTamSeq	:= TamSx3("D3_NUMSEQ")[1]
cBusca := Replicate("z",nTamSeq)

//����������������������������������������������������������Ŀ
//�Le o maior numero sequencial existente entre os documentos�
//�de entrada (SD1), saida (SD2) e movimentacao de materiais �
//�(SD3)                                                     �
//������������������������������������������������������������
For nX := 1 to Len(aAlias)
	
	DbSelectArea(aAlias[nX])
	aAreaTmp := GetArea()
	//������������������������������������������Ŀ
	//�Ordem do DocSeq nas tabelas SD1, SD2 e SD3�
	//��������������������������������������������
	DbSetOrder(4) 
	DbSeek(xFilial(aAlias[nX])+cBusca,.T.)
	DbSkip(-1)
	
	If &(PrefixoCPO(aAlias[nX]) + "_FILIAL") == xFilial(aAlias[nX])
		cDoc := &(PrefixoCPO(aAlias[nX]) + "_NUMSEQ")
	EndIf
	
	//�������������������������������������������������Ŀ
	//�Armazena o maior sequencial entre as tres tabelas�
	//���������������������������������������������������
	If cDoc > cMax
		cMax := cDoc
	EndIf
	
	RestArea(aAreaTmp)   
	
Next nX

//��������������������������������������������Ŀ
//�Obtem o proximo numero a partir do MV_DOCSEQ�
//����������������������������������������������
cProx := Soma1(PadR(SuperGetMv("MV_DOCSEQ"),nTamSeq),,,.T.)

//�������������������������������������������������Ŀ
//�Verifica se o MV_DOCSEQ esta gravado corretamente�
//���������������������������������������������������
If cMax >= cProx
	PUTMV("MV_DOCSEQ",cMax)
EndIf

RestArea(aArea)

Return lRet