#include 'protheus.ch'
#include 'rwmake.ch'
#INCLUDE "APVT100.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERAPV   �Autor  � M.Munhoz - ERPPLUS � Data �  06/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao generica para a criacao automatica de Pedido de     ���
���          � Venda                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH DO BRASIL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function GeraPV(_aCabSC5, _aItSC6, _nOpc)

Local _lRet     := .t.
Local aAreaBKP  := GetArea()
//Acrescentado savearea1 e restarea1 - Edson Rodrigues - 13/07/10
//Local _aAreas   := SaveArea1({"SC5","SC6","SB6","SB1","SD1","SD2","SF4","SC2","SG1","AB9","AB7","ZZJ","ZZ4","ZZ3"})


Private lMsErroAuto	:= .F.
Private lMsHelpAuto := .F.

u_GerA0003(ProcName())

//Gera Pedido de Venda
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabSC5, _aItSC6, _nOpc)

If lMsErroAuto
	//**********************************************
	//          Flag da Saida Massiva - Edson Rodrigues - 27/09/07   *
	//**********************************************
	If !IsTelnet() //Implanta��o Radio Frequencia - 11/10/2011
		DisarmTransaction()
		Mostraerro()
		RollBackSX8()
		apMsgInfo("Ocorreu um erro na gera��o do PV. O sistema far� uma segunda tentativa.")
		_lRet := .F.
	Else
		DisarmTransaction()		
		RollBackSX8()      
		VTDispFile(NomeAutoLog(),.t.)
		VTBEEP(3)     
	    VTAlert("Ocorreu um erro na gera��o do PV. O sistema far� uma segunda tentativa.","Erro!",.t.,2500)
		_lRet := .F.
	EndIf		
Else
  If IsTelnet()
  	ConfirmSX8()
  Endif
EndIf

//RestArea1(_aAreas)
RestArea(aAreaBKP)         

return(_lRet)
