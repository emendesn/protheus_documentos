#Include "PROTHEUS.Ch"
#include "topconn.ch"   
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTR      �Autor  � Graziella Bianchin � Data �  16/02/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho criado para inclusao de documentos de entrada(CTRC)���
���          � Sempre que for um CTRC o campo QTDE ficar� como 1          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTR()
local _nPosDtD  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DTDOCA"})
local _nPosHrD  := aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_HRDOCA"})
local _nPosdivne:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_DIVNEG"})
local _nPosiqtde:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_QUANT"})                                                                             
local _nPoscProd:= aScan(aHeader,{|x| AllTrim(Upper(x[2])) == "D1_COD"})  

u_GerA0003(ProcName())

if Inclui .And. Alltrim(M->CESPECIE) == "CTR"
	aCols[n,_nPosDtD]  := dDataBase
	aCols[n,_nPosHrD]  := "00:00:00"
	aCols[n,_nPosdivne]:= "04"
	aCols[n,_nPosiqtde]:= 1		
	aCols[n,_nPoscProd]:= aCols[n,_nPoscProd]
Endif

Return(aCols[n,_nPoscProd])