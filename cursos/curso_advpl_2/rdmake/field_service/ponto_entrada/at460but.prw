/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AT460BUT �Autor  �Antonio Leandro Favero � Data � 08/07/03 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adionar botoes de pesquisa no        ���
���          � ATENDIMENTO DA OS                                          ���
�������������������������������������������������������������������������͹��
���Uso       � BGH - Modulo Field Service                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AT460BUT()

Public aColsSZ9 := {}
Public aHeaderSZ9 := {}

u_GerA0003(ProcName())

SetPrvt("xAlias, xOrd, xRecno,xBut")
xAlias := Alias()
xOrd   := IndexOrd()
xRecno := Recno()

xBut := {}

//AADD(xBut,{"NOTE",{ || U_VERCHA()},"Atendimento"})
AADD(xBut,{"NOTE" ,{ || U_VERCHA()},"Chamado Tecnico"})
AADD(xBut,{"DBG06",{ || U_teca005()},"An�lise OS"}) // Munhoz - ERP PLUS - 16/04/2007

// retorna o ambiente
DbSelectArea(xAlias)
DbSetOrder(xOrd)
DbGoTo(xRecno)

Return(xBut)