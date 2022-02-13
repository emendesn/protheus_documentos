
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NFSVLNUM �Autor  � M.Munhoz           � Data �  12/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validacao da digitacao do numero da  ���
���          � nota fiscal                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function NFSVLNUM()

local _lRet := alltrim(upper(cUserName)) $ 'MARILICE.BASSINI/ANDRE.LUIZ/KAIRO.GOES'

if !_lRet
	apMsgStop('Caro usu�rio, voc� n�o possui acesso a alterar o n�mero da NF. Favor solicitar esta altera��o para Marilice Bassini, Andr� Luiz ou Kairo Goes. (fonte: NFSVLNUM)','Proibido alterar n�mero da NF')
endif

return(_lRet)
