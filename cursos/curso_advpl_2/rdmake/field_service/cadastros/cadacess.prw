#INCLUDE "rwmake.ch"
#INCLUDE 'TOPCONN.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADACESS  � Autor � Edson rodrigues    � Data �  07/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �  Cadastro de Acessorios                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CADACESS()

Private cCadastro := "Cadastro de Acessorios"
Private cAlias := "SZC"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","U_BGATUSZC",0,3} ,;
{"Alterar","U_BGATUSZC",0,4} ,;
{'Legenda', "u_legcaces" , 0,3}}      //"Legenda"


//{"Excluir"    ,"AxDeleta" ,0,5},;//EXCLUIR

// Revisar esta legenda de cores
Private aCores :=  { 	{'ZC_STATUS <> "0"' , 'BR_VERDE'   },; //Sucesso
{'ZC_STATUS == "0"' , 'BR_VERMELHO'}}  //N�o Sucesso

u_GerA0003(ProcName())

DbSelectArea("SZC") //Cadastro de Acess�rios
SZC->(DBSetOrder(1))
mBrowse( 6,1,22,75,cAlias, , , , , ,aCores)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGATUSZC  � Autor � Luciano Siqueira   � Data �  05/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para incluir ou alterar acessorios                  ���
���          �  Cadastro de Acessorios                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BGATUSZC(cAlias,nReg,nOpc)

Local nOpcA := 0

PRIVATE aTELA[0][0]
PRIVATE aGETS[0]

//�����������������������������������������������������������������������Ŀ
//� Inicializa os dados da Enchoice                                       �
//�������������������������������������������������������������������������
RegToMemory( "SZC",(nOpc == 3))


aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
EnChoice( "SZC", nReg, nOpc, , , , , aPosObj[1],,3)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(BGSZCTOk() .and. Obrigatorio(aGets,aTela),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	dbSelectArea("SZC")
	If nOpc == 4
		RecLock( "SZC", .F. )
	Else
		RecLock( "SZC", .T. )
	Endif
	SZC->ZC_FILIAL	:= xFilial("SZC")
	SZC->ZC_DOC		:= M->ZC_DOC
	SZC->ZC_SERIE	:= M->ZC_SERIE
	SZC->ZC_FORNECE	:= M->ZC_FORNECE
	SZC->ZC_LOJA	:= M->ZC_LOJA
	SZC->ZC_NOME	:= M->ZC_NOME
	SZC->ZC_ITEMNFE	:= M->ZC_ITEMNFE
	SZC->ZC_CODPRO	:= M->ZC_CODPRO
	SZC->ZC_DESPRO	:= M->ZC_DESPRO
	SZC->ZC_ITEM	:= M->ZC_ITEM
	SZC->ZC_ACESS	:= M->ZC_ACESS
	SZC->ZC_DESACES	:= M->ZC_DESACES
	SZC->ZC_IMEI	:= M->ZC_IMEI
	SZC->ZC_STATUS	:= M->ZC_STATUS
	SZC->ZC_TPACESS	:= M->ZC_TPACESS
	SZC->ZC_QUANT	:= 1
	MsUnlock()
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BGSZCTOk  � Autor � Luciano Siqueira   � Data �  05/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao Rotina para incluir ou alterar acessorios        ���
���          �  Cadastro de Acessorios                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function BGSZCTOk()

lRetorno := .T.

_cQry := " SELECT "
_cQry += " 	COUNT(*) AS QTDREG "
_cQry += " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQry += " WHERE "
_cQry += " 	ZZ4.D_E_L_E_T_ = '' "
_cQry += " 	AND ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
_cQry += " 	AND ZZ4_CODCLI='"+M->ZC_FORNECE+"' "
_cQry += " 	AND ZZ4_LOJA='"+M->ZC_LOJA+"' "
_cQry += " 	AND ZZ4_NFENR='"+M->ZC_DOC+"' "
_cQry += " 	AND ZZ4_CODPRO='"+M->ZC_CODPRO+"' "
_cQry += " 	AND ZZ4_IMEI='"+M->ZC_IMEI+"' "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY1",.T.,.T.)

If QRY1->QTDREG == 0
	MsgAlert("Dados n�o encontrado na Entrada Massiva!")
	lRetorno := .F.
Endif

QRY1->(dbCloseArea())


If lRetorno
	_cQry := " SELECT "
	_cQry += " 	COUNT(*) AS QTDREG "
	_cQry += " FROM   "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
	_cQry += " WHERE "
	_cQry += " 	ZZ4.D_E_L_E_T_ = '' "
	_cQry += " 	AND ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
	_cQry += " 	AND ZZ4_CODCLI='"+M->ZC_FORNECE+"' "
	_cQry += " 	AND ZZ4_LOJA='"+M->ZC_LOJA+"' "
	_cQry += " 	AND ZZ4_NFENR='"+M->ZC_DOC+"' "
	_cQry += " 	AND ZZ4_CODPRO='"+M->ZC_CODPRO+"' "
	_cQry += " 	AND ZZ4_IMEI='"+M->ZC_IMEI+"' "
	_cQry += " 	AND ZZ4_STATUS >'4' "//VERIFICA SE JA FOI ENCERRADO O PROCESSO
	
	_cQry := ChangeQuery(_cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"QRY1",.T.,.T.)
	
	If QRY1->QTDREG > 0
		MsgAlert("N�o � possivel Incluir/Alterar registro de um processo encerrado!")
		lRetorno := .F.
	Endif
	
	QRY1->(dbCloseArea())
Endif

If lRetorno
	If !Empty(M->ZC_ACESS) .AND. EMPTY(M->ZC_DESACES)
		MsgAlert("Favor informar a Descri��o do Acessorio!")
		lRetorno := .F.	
	Endif
Endif

Return(lRetorno)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �legcaces  �Autor  �Edson Rodrigues     � Data �  10/11/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria botao de Legenda                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function legcaces()

BRWLegenda('Legenda','Status',{{'BR_VERDE','Confirmada'},{'BR_VERMELHO','Nao confirmada'}})

Return(nil)
