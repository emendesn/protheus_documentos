#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*                                                                              
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ETQARMAZ �Autor  � Edson Rodrigues    � Data � 02/08/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para impressao da etiqueta de Armazenagem         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Etqarmaz(_aEtiquet)
//User Function Etqarmaz()

Local nX
Local _aLin := {15,30,45,60,75,90,105,120,135}
Local _aCol := {03,40}  //05,30

u_GerA0003(ProcName())

//�����������������������������������������������������������������������������Ŀ
//� Estrutura da Matriz                                                         �
//� 01 - ARMAZEM                                                                �
//� 02 - LOTE                                                                   �
//� 03 - ORIGEM                                                                 �
//� 04 - MODELO                                                                 �
//� 05 - NFE ENTRADA                                                            �                                                                 �
//� 06 - SERIE NFE                                                              �
//� 07 - DATA ENTRADA                                                           �
//� 08 - QUANTIDADE PROD POR CAIXA                                              |
//�������������������������������������������������������������������������������

//�������������������������������������������������Ŀ
//� Layout da Etiqueta                              �
//� �--------------- 100 mm -----------------------��
//� |  NOTA ENTRADA : XXXXXXXXX  SERIE : XXX      | �
//� |  MODELO : XXXXXXXXXXXXXXX                 144�
//� |  ARMAZEM : XX                               mm�
//� |  ORIGEM  : XX                               � �
//� |  LOTE    : XXXXXXX                          � �
//� |  QTDE CAIXA : 999                           � �
//� �---------------------------------------------� �
//���������������������������������������������������
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)

//_aEtiquet:={}
//AADD(_aEtiquet,{'XXXXXXXXXXXXXXX','999999999','999','10',DATE(),'YYYYYYY','SP',300})       

If Len(_aEtiquet) > 0
   For nX := 1 to Len(_aEtiquet)

	MSCBBEGIN(1,6,144)


	// Alimenta variaveis
	_cModelo  := _aEtiquet[nX, 1]
	_cNFNum   := _aEtiquet[nX, 2] 
	_cNFSer   := _aEtiquet[nX, 3] 
	_carmaz   := _aEtiquet[nX, 4]
	_cDtEntr  := _aEtiquet[nX, 5]
	_clote    := _aEtiquet[nX, 6]
	_corigem  := _aEtiquet[nX,7]
	_cqtdecx  := STRZERO(_aEtiquet[nX,8],3)
		
	// Campos da etiqueta
//	MSCBSAYBAR(nXmm, nYmm, cConteudo, cRotacao, cTypePrt, nAltura, lDigVer, lLinha, lLinBaixo, cSubSetIni, nLargura, nRelacao, lCompacta, lSerial, cIncr, lZerosL)
	

	MSCBSAY(_aCol[1],_aLin[1],"ARMAZEM : " ,"N","0","090,090")  // Coluna 1 - Linha 1
	MSCBSAY(_aCol[2],_aLin[1],_carmaz      ,"N","0","125,125")  // Coluna 2 - Linha 1
	MSCBSAY(_aCol[1],_aLin[2],"LOTE    : " ,"N","0","080,080")  // Coluna 1 - Linha 2
	MSCBSAY(_aCol[2],_aLin[2],_clote       ,"N","0","115,115")  // Coluna 2 - Linha 2
	MSCBSAY(_aCol[1],_aLin[3],"ORIGEM  : " ,"N","0","080,080")  // Coluna 1 - Linha 3
	MSCBSAY(_aCol[2],_aLin[3],_corigem 	    ,"N","0","125,125")  // Coluna 2 - Linha 3
	MSCBSAY(_aCol[1],_aLin[4],"MODELO : "  ,"N","0","080,080")  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[2],_aLin[4],_cModelo 	    ,"N","0","090,090")  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[1],_aLin[5],"ENTRADA :  "	 +_cDtEntr	,"N","0","080,080")  // Coluna 1 - Linha 5
	MSCBSAY(_aCol[1],_aLin[6],"NFE :  "	+ _cNFNum       ,"N","0","080,080")  // Coluna 1 - Linha 6
	MSCBSAY(_aCol[1],_aLin[7],"SERIE :  " 	+ _cNFSer	,"N","0","080,080")  // Coluna 1 - Linha 7
	MSCBSAY(_aCol[1],_aLin[8],"QTDE CAIXA : ","N","0","080,080")  // Coluna 1 - Linha 8
	MSCBSAY(_aCol[2],_aLin[8],_cqtdecx 	 ,"N","0","105,105")  // Coluna 1 - Linha 8
	MSCBEND()

   Next nX
Endif


MSCBCLOSEPRINTER()

Return