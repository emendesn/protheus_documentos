#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INIPADS   �Autor  � M.Munhoz - ERPPLUS � Data �  25/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializador padrao de diversos campos para alimentar os  ���
���          � campos a partir do 2o item com o valor do 1o item.         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function inipadSD1(_cCampo)

local _nPos   := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == _cCampo })
local _nPosPC := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_PEDIDO" })
local _IniPad := criavar(_cCampo,.F.)

u_GerA0003(ProcName())

if Inclui .and. n <> 1 .and. empty(aCols[1,_nPosPC]) 

	_IniPad := aCols[1,_nPos]

endif

return(_IniPad)