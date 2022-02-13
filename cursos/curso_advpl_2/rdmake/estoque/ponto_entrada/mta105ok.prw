#include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA105OK  �Autor  � CLAUDIA CABRAL     � Data �  17/11/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA NA SOLICITACAO AO ARMAZEM PARA VALIDAR    ���
���          � O CAMPO SOLICITANTE E CAMPO CENTRO DE CUSTO                ���
���          � NAO DEIXAR O MESM SER VAZIO                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function MTA105OK()

local _lRet      := .T.
Local lDeleted	 := .F.
Local nPCcusto   := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CC"})
Local nPCLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="CP_LOCAL"})
Local cCentroC   := aCols[n][nPCcusto]
Local cArmazem   := aCols[n][nPCLocal]

u_GerA0003(ProcName())

If Empty(csolic)
	apMsgStop("Caro usu�rio,o campo solicitante deve ser preenchido.")
	_lRet := .f.
Endif

If ( !lDeleted )
	For n:= 1 to len(aCols)
		if (n > 1) 
			aCols[n][nPCcusto] := cCentroC
			aCols[n][nPCLocal] := cArmazem
		Endif
	Next
	/*
		If (Empty(aCols[n][nPCcusto])) 
			apMsgStop("Favor,inserir Centro de Custo.") // Paulo Lopez
			_lRet := .F.
		EndIf
	*/	  
Endif	
return(_lRet)