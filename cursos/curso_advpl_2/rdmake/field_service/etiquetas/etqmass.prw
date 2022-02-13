#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Execblock � ETQMASS  � Autor � Marcelo Munhoz     � Data �  16/07/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para impressao de Etiquetas.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EtqMass(_aEtiquet,cCarcaca)

Local nX
Local _aLin := {03,06,09,12,15,18}
Local _aCol := {05,27,30,48}  //05,30


u_GerA0003(ProcName())

//�����������������������������������������������������������������������������Ŀ
//� Estrutura da Matriz                                                         �
//� 01 - IMEI                                                                   �
//� 02 - Numero da OS                                                           �
//� 03 - Item da OS                                                             �
//� 04 - Numero da NF de Entrada                                                �
//� 05 - Serie da NF de Entrada                                                 �
//� 06 - Modelo do aparelho                                                     �
//� 07 - Data de Entrada                                                        �
//�������������������������������������������������������������������������������

//�������������������������������������������������Ŀ
//� Layout da Etiqueta                              �
//� �--------------- 88 mm -----------------------� �
//� |  IMEI: 000000000000000                      | �
//� |  OS: 000000-0000	Modelo: XXXXXXXXXXXXXX 22 | �
//� |  NF/Serie: 000000/000	Dt.Entr: 99/99/99  mm � �
//� �---------------------------------------------� �
//���������������������������������������������������
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI","LPT1",,033,.F.,,,,,,.T.)

For nX := 1 to Len(_aEtiquet)

	MSCBBEGIN(1,6)
/*
	// Alimenta flag de impressao da etiqueta no SD1
	if _aEtiquet[nX,8] <> 0
		SD1->(dbGoTo(_aEtiquet[nX,8]))
		reclock("SD1",.f.)
		SD1->D1_XIMPETQ := "S"
		msunlock()
	endif
*/
	// Alimenta flag de impressao da etiqueta no ZZ4 - Alterado por M.Munhoz em 16/08/2011
	if _aEtiquet[nX,17] <> 0
		ZZ4->(dbGoTo(_aEtiquet[nX,17]))
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_IMPETQ := "S"
		msunlock()
	endif

	// Alimenta variaveis
	_cIMEI    := _aEtiquet[nX, 1]
	_cOS      := _aEtiquet[nX, 2] + "/" + _aEtiquet[nX, 3]
	_cNFSer   := _aEtiquet[nX, 4] + "/" + _aEtiquet[nX, 5]
	_cModelo  := _aEtiquet[nX, 6]
	_cDtEntr  := dtoc(_aEtiquet[nX, 7])
	_cCliente := _aEtiquet[nX, 9] + "/" + _aEtiquet[nX,10]
	
	// Campos da etiqueta
	MSCBSAY(_aCol[1],_aLin[1],"IMEI: " 		+ _cIMEI	,"N","0","030,030")  // Coluna 1 - Linha 1
	MSCBSAY(_aCol[2]+10,_aLin[1],"Modelo: " 	+ _cModelo	,"N","0","030,030")  // Coluna 2 - Linha 2
//	MSCBSAYBAR(nXmm, nYmm, cConteudo, cRotacao, cTypePrt, nAltura, lDigVer, lLinha, lLinBaixo, cSubSetIni, nLargura, nRelacao, lCompacta, lSerial, cIncr, lZerosL)
	MSCBSAYBAR(_aCol[1],_aLin[2],_aEtiquet[nX, 1],"N","MB07",2.5,.F.,.F.,.F.,,2,1)
//	MSCBSAYBAR(_aCol[1],_aLin[2],_aEtiquet[nX, 1],"N","MB07",2.5,.F.,.F.,.F.,,2,1)
	MSCBSAY(_aCol[1],_aLin[3],"OS: " 		+ _cOS		,"N","0","030,030")  // Coluna 1 - Linha 3
	MSCBSAY(_aCol[2]-4,_aLin[3],"Cliente: "	+ _cCliente	,"N","0","030,030")  // Coluna 2 - Linha 3
	if !empty(_aEtiquet[nX, 11])
		MSCBSAY(_aCol[4]-4,_aLin[3],"Lote: "	+ _aEtiquet[nX, 11]	,"N","0","030,030")  // Coluna 4 - Linha 3
	endif
	MSCBSAY(_aCol[1],_aLin[4],oemtoansi("NF/Serie: ") 	+ _cNFSer	,"N","0","030,030")  // Coluna 1 - Linha 4
	MSCBSAY(_aCol[2]+10,_aLin[4],"Dt.Entr.: " 	+ _cDtEntr	,"N","0","030,030")  // Coluna 2 - Linha 4
	if alltrim(_aEtiquet[nX, 5]) == "3"
		MSCBSAY(_aCol[4]+6,_aLin[4],"CORREIO"	,"N","0","030,030")  // Coluna 4 - Linha 4
	endif
	
	If !Empty(cCarcaca)
		MSCBSAY(_aCol[1],_aLin[5],"MAC ADRESS: " 		+ cCarcaca	,"N","0","030,030")  // Coluna 1 - Linha 1	
		MSCBSAYBAR(_aCol[1],_aLin[6],cCarcaca,"N","MB07",2.5,.F.,.F.,.F.,,2,1)
	EndIF

	MSCBEND()

Next nX

MSCBCLOSEPRINTER()

Return
