#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TECXMASK  �Autor  �Hudson de Souza Santos� Data �22/11/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TECXMASK()
Local cAlias		:= "SB1"
Local aFixe			:= {}
Private cCadastro	:= "Manuten��o M�scara Produto"
Private aRotina		:= {}
//���������������������������Ŀ
//�Adiciona Rotinas ao mBrowse�
//�����������������������������
AADD(aRotina,{"Visualizar" ,"u_TECXMSKM",0,2})
AADD(aRotina,{"Manuten��o" ,"u_TECXMSKM",0,4})
//������������������������������������������Ŀ
//�Configura Campos que ir�o preencher o grid�
//��������������������������������������������
AADD(aFixe,{"Modelo"	,"B1_COD"	})
AADD(aFixe,{"Descri��o"	,"B1_DESC"	})
AADD(aFixe,{"M�scara 1"	,"B1_MASK1"	})
AADD(aFixe,{"M�scara 2"	,"B1_MASK2"	})
AADD(aFixe,{"M�scara 3"	,"B1_MASK3"	})
dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,aFixe)
//����������������������������������������������Ŀ
//�Deleta o filtro utilizado na fun��o FilBrowse.�
//������������������������������������������������
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TECXMASKM �Autor  �Microsiga           � Data �  11/22/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TECXMSKM(cAlias,nReg,nOpc)
/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cGetProd	:= Space(30)
Private cGetDesc	:= Space(15)
Private cGetMask1	:= Space(20)
Private cGetMask2	:= Space(20)
Private cGetMask3	:= Space(20)
Private cSayCod		:= Space(25)
Private cSayDesc	:= Space(25)
Private cSayMask1	:= Space(25)
Private cSayMask2	:= Space(25)
Private cSayMask3	:= Space(25)
dbSelectArea(cAlias)
dbGoTo(nReg)
cGetProd := SB1->B1_COD
cGetDesc := SB1->B1_DESC
cGetMask1 := SB1->B1_MASK1
cGetMask2 := SB1->B1_MASK2
cGetMask3 := SB1->B1_MASK3
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgMask","oSayCod","oSayMask1","oSayMask2","oSayMask3","oSayDesc","oBtnCancel","oBtnOK","oGetProd")
SetPrvt("oGetMask1","oGetMask2","oGetMask3")
/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgMask   := MSDialog():New( 115,315,390,660,"M�scara Produto",,,.F.,,,,,,.T.,,,.T. )
// Label
oSayCod    := TSay():New( 010,010,{||"Cod. Produto:"}		,oDlgMask,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSayMask1  := TSay():New( 040,010,{||"M�scara 1:"}			,oDlgMask,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSayMask2  := TSay():New( 055,010,{||"M�scara 2:"}			,oDlgMask,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSayMask3  := TSay():New( 070,010,{||"M�scara 3:"}			,oDlgMask,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSayDesc   := TSay():New( 025,010,{||"Desc Produto:"}		,oDlgMask,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
// Edite
oGetProd   := TGet():New( 010,060,{|u| If(PCount()>0,cGetProd:=u ,cGetProd)} ,oDlgMask,097,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetProd",,)
oGetDesc   := TGet():New( 025,060,{|u| If(PCount()>0,cGetDesc:=u ,cGetDesc)} ,oDlgMask,097,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDesc",,)
oGetMask1  := TGet():New( 040,060,{|u| If(PCount()>0,cGetMask1:=u,cGetMask1)},oDlgMask,097,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetMask1",,)
oGetMask2  := TGet():New( 055,060,{|u| If(PCount()>0,cGetMask2:=u,cGetMask2)},oDlgMask,097,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetMask2",,)
oGetMask3  := TGet():New( 070,060,{|u| If(PCount()>0,cGetMask3:=u,cGetMask3)},oDlgMask,097,008,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetMask3",,)
// Desabilita os Get do c�digo e da descri��o do produto.
oGetProd:Disable()
oGetDesc:Disable()
If nOpc = 1
	oGetMask1:Disable()
	oGetMask2:Disable()
	oGetMask3:Disable()
EndIf
// Bot�es
oBtnCancel := SButton():New( 108,028,2,{||oDlgMask:End()} ,oDlgMask,,"", )
oBtnOK     := SButton():New( 108,116,1,{|| (Iif(nOpc<>1,TECXGRV(cAlias,nReg),oDlgMask:End()),oDlgMask:End())} ,oDlgMask,,"", )
oDlgMask:Activate(,,,.T.)
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TECXGRV   �Autor  �Hudson de Souza Santos� Data �  22/11/13 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TECXGRV(cAlias,nReg)
Local aArea := GetArea()
dbSelectArea(cAlias)
dbGoTo(nReg)
RecLock(cAlias,.F.)
 SB1->B1_MASK1 := cGetMask1
 SB1->B1_MASK2 := cGetMask2
 SB1->B1_MASK3 := cGetMask3
MsUnLock()
RestArea(aArea)
Return