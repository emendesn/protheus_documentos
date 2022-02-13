#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACD150VE �Autor  �Eduardo Barbosa     � Data �  02/12/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. Para Validar Endereco na Rotina de Mestre de Inventario���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ACDA30VE()

Local _lRet  := .T.

u_GerA0003(ProcName())

// Se n�o possuir saldo por endere�o n�o gera mestre a ser inventariado.
DbSelectArea("SBF")
_aAreaSBF := GetArea()
DbSetOrder(1)
If !DbSeek(xFilial("SBF")+SBE->(BE_LOCAL+BE_LOCALIZ),.F.)
   _lRet := .F.
   // A rotina ACDA030 quando chama este ponto de entrada retorna EOF() da tabela CBA( Deveria estar posicinada na SBE)
   // Foi Aberto Chamado na TOTVS Porem nao chegaram a Efetuar Teste e fecharam o Chamado. 
   DbSelectArea("CBA")
   DbGoTop()
Endif

         
Return _lRet
