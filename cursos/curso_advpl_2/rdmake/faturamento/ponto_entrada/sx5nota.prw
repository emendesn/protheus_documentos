
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SX5NOTA  �Autor  �Microsiga           � Data �  17/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para filtrar as series de NF de acordo    ���
���          � com a filial logada.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function SX5NOTA()

Local lRet	:= .f.

Do Case
	// Permitido apenas as series 001, 002, 003 e 004 na filial 02 (Alphaville)
  	Case cFilAnt == '02' .And. (AllTrim(SX5->X5_CHAVE) == '1' .or. AllTrim(SX5->X5_CHAVE) == '2' .or. AllTrim(SX5->X5_CHAVE) == '3' .or. AllTrim(SX5->X5_CHAVE) == '4' .or. AllTrim(SX5->X5_CHAVE) == 'RPS')
		lRet	:= .t.
	// Permitido apenas as series 1, 2, 3 e 4 na filial 06 (Osasco)
	Case cFilAnt == '06' .And. (AllTrim(SX5->X5_CHAVE) == '1' .or. AllTrim(SX5->X5_CHAVE) == '2' .or. AllTrim(SX5->X5_CHAVE) == '3' .or. AllTrim(SX5->X5_CHAVE) == '4' .or. AllTrim(SX5->X5_CHAVE) == 'RPS')
		lRet	:= .t.
EndCase  

Return(lRet)
