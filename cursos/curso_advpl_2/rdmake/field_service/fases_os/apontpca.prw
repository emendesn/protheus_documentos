#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � APONTPCA � Autor �Paulo Lopez         � Data �  19/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �Tela para Apontamento Pe�as                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function APONTPCA()
//������������������������������������������������������������������������Ŀ
//� Declaracoes das variaveis                                              �
//��������������������������������������������������������������������������
Private oDlgCgar
Private cIMEI  		:= space(TamSX3("ZZ4_IMEI")[1])//Space(15)
Private _UserId     := __cUserID
Private _CodTec 	:=  Posicione("AA1",4,xFilial("AA1") + _UserId,"AA1_CODTEC")
Private _center     := CHR(10)+CHR(13)
Private Path 		:= "172.16.0.7"
u_GerA0003(ProcName())
If Empty(AllTrim(_CodTec))
	MsgStop("Tecnico   "+_UserId + " - " + AllTrim(cUsername) +" n�o Cadastrado !!!","Cadastro Tecnico")
	Return
Endif
//������������������������������������������������������������������������Ŀ
//� Definicao da janela e seus conteudos                                   �
//��������������������������������������������������������������������������
DEFINE MSDIALOG oDlgCgar TITLE "Consulta Pe�as" FROM 0,0 TO 210,420 OF oDlgCgar PIXEL
@ 010,015 SAY   "Informe o IMEI para Consultar Pe�as." 	SIZE 150,008 PIXEL OF oDlgCgar
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlgCgar
@ 045,025 GET cIMEI PICTURE "@!" 	SIZE 080,010 Valid Iif(!Vazio(),APONTPC2(@cIMEI),cIMEI := SPACE(TamSX3("ZZ4_IMEI")[1])) Object ocodimei
//������������������������������������������������������������������������Ŀ
//� Botoes da MSDialog                                                     �
//��������������������������������������������������������������������������
@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgCgar:end())
Activate MSDialog oDlgCgar CENTER On Init ocodimei:SetFocus()
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � APONTPC2 � Autor �Paulo Lopez         � Data �  19/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �IMPRIME PECAS APONTADAS CONFORME PARAMETRO INFORMADO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function APONTPC2()
Local _cQry
Private lCheck 		:= .T.
Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Apontamento de Pe�as")
Private nTotal      := 0
Private cQtd		:= 01
Private cArquivo    := ""
Private cArmPeca
Private cEndProd
Private cEndAudi
Private cCodSe2
Private cFaSe2
Private cNumOs
Private cSeq
Private cLab
Private cOpe
Private cDoc
Private cArmSep
Private cEndBuf
Private cSerWms
If !Empty(AllTrim(cIMEI))
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	Endif
	_cQry	:=	"	SELECT TOP 1 	ZZ3_CODSE2		AS	CODSE2, " + ENTER
	_cQry	+=	"					ZZ3.ZZ3_FASE2	AS	FASE2, 	" + ENTER
	_cQry	+=	"					ZZ3.ZZ3_LAB		AS 	LAB,	" + ENTER
	_cQry	+=	"					ZZ3.ZZ3_SEQ		AS 	SEQ,	" + ENTER
	_cQry	+=	"					ZZ3.ZZ3_NUMOS	AS 	NUMOS,	" + ENTER
	_cQry	+=	"					ZZ3.ZZ3_SOFOUT	AS	SOFOUT, " + ENTER
	_cQry	+=	"					ZZ3.ZZ3_CARDU	AS	CARDU, 	" + ENTER
	_cQry	+=	"					ZZ4.ZZ4_OPEBGH	AS	OPERAC 	" + ENTER
	_cQry	+=	"	FROM " + RetSQlName("ZZ3") + " ZZ3 WITH(NOLOCK) " + ENTER
	_cQry	+=	"	INNER JOIN " + RetSQlName("ZZ4")+ " ZZ4 WITH(NOLOCK) " + ENTER
	_cQry	+=	"	ON(ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ4.ZZ4_OS = ZZ3.ZZ3_NUMOS AND ZZ4.D_E_L_E_T_ = ZZ3.D_E_L_E_T_) " + ENTER
	_cQry	+=	"	WHERE ZZ3_FILIAL='"+xfilial("ZZ3")+"' "+ ENTER 
	_cQry	+=	"	  AND ZZ3.ZZ3_IMEI = '" + cIMEI + "' " + ENTER
	_cQry	+=	"     AND ZZ3.D_E_L_E_T_ = ''  " + ENTER
    _cQry	+=	"     AND ZZ4_FILIAL='"+xfilial("ZZ4")+"'
	_cQry	+=	"	  AND ZZ4.ZZ4_STATUS < 5 " + ENTER
	_cQry	+=	"	ORDER BY ZZ3_SEQ DESC " + ENTER
	MemoWrite("c:\pecasI.sql", _cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	If Empty(AllTrim(QRY->CODSE2))
		MsgStop("Equipamento n�o Encontrado, Verificar se o mesmo esteja encerrado","Apontamento Pe�a" )
	//������������������������������������������Ŀ
	//�Rotina de travamento do radio - GLPI 14467�
	//��������������������������������������������
	ElseIf U_VLDTRAV(xFilial("ZZ4"),cIMEI,QRY->NUMOS,{"P","APONTPCA","APONTPC2"})


//	Else
		If Select("QRY1") > 0
			QRY1->(dbCloseArea())
		Endif
		If Select("QRY2") > 0
			QRY2->(dbCloseArea())
		Endif
		If Select("TRB") > 0
			TRB->(dbCloseArea())
		Endif
		cCodSe2		:=	QRY->CODSE2
		cFaSe2		:=	QRY->FASE2
		cNumOs		:=	QRY->NUMOS
		cSeq		:= 	QRY->SEQ
		cLab		:=	QRY->LAB
		cOpe		:=	QRY->OPERAC
		cArmPeca	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_ALMEP")
		cEndProd	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_ENDPRO") // End
		cEndAudi	:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_ENDAUD") // End
		cArmSep		:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_ARMSEP")
		cEndBuf		:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_ENDBUF")
		cSerWms		:= 	Posicione("ZZJ",1,xFilial("ZZJ") + AllTrim(cOpe),"ZZJ_SERWMS")
		Processa({|| ProcAPONTPC3()() },"Processando...")
	Endif                                                                        
Endif
If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
Endif
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
Endif
If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
cIMEI := space(TamSX3("ZZ4_IMEI")[1])//space(15)
ocodimei:SetFocus()
Return()
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �APONTPC3  �Autor  �Paulo Lopez           � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Processa para MarkBrowser                                    ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ProcAPONTPC3()
//�����������������������Ŀ
//�Atribuicao de variaveis�
//�������������������������
Local aArea   := {}
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local aCpos   := {}
Local aCampos := {}
Local cMsg    := ""
Local cQry
Private cArqDBF  := CriaTrab(NIL,.f.)
Private aFields  := {}
Private QRY1
//���������������������������������������������8�
//�Execucao so possivel na empresa BGH - MATRIZ�
//���������������������������������������������8�
If cEmpAnt # "02"
	Return Nil
Endif
//���������������������������������������Ŀ
//�Atribui as variaveis de funcionalidades�
//�����������������������������������������
aAdd( aRotina ,{"Pesquisar"  ,"u_PesqTRB()"  ,0,1})
//aAdd( aRotina ,{"Marcar"     ,"u_MarcaAll()" ,0,2})
aAdd( aRotina ,{"Compor"     ,"u_MontPeca()" ,0,3})
aAdd( aRotina ,{"Imprimir"   ,"u_ImprPeca()" ,0,3})
aAdd( aRotina ,{"MarcarPeca" ,"u_MarcPeca()" ,0,3})
aAdd( aRotina ,{"Legenda"    ,"u_Peca5L()"   ,0,4})
//����������������������������������������������������������Ŀ
//�Atribui as variaveis os campos que aparecerao no mBrowse()�
//������������������������������������������������������������
aAdd(aCampos,{"TR_OK"   	,"",""           	,"@!"             })
aAdd(aCampos,{"TR_COD"  	,"","Modelo"    	,"@!"             })
aAdd(aCampos,{"TR_DESC"		,"","Desc.Mod"   	,"@!"             })
aAdd(aCampos,{"TR_COMP"		,"","Componente"    ,"@!"             })
aAdd(aCampos,{"TR_DESC1" 	,"","Desc.Comp."    ,"@!"             })
aAdd(aCampos,{"TR_QUANT"   	,"","Quantidade"	,"@!"             })
aAdd(aCampos,{"TR_NUMOS"   	,"","IMEI-OS"		,"@!"             })
//�������������������������������������������
//�Monta o filtro especifico para MarkBrow()�
//�������������������������������������������
aAdd(aFields,{"TR_OK"	,"C",02,0})
aAdd(aFields,{"TR_COD"	,"C",15,0})
aAdd(aFields,{"TR_DESC"	,"C",30,0})
aAdd(aFields,{"TR_COMP"	,"C",15,0})
aAdd(aFields,{"TR_DESC1","C",30,0})
aAdd(aFields,{"TR_QUANT","N",02,0})
aAdd(aFields,{"TR_NUMOS","C",25,0})
dbCreate(cArqDbf,aFields)
dbUseArea(.T.,,cArqDbf,"TRB",.F.)
Private cArqNtx  := CriaTrab(NIL,.f.)
Private cIndCond  :=  "TR_COD+TR_COMP"
IndRegua("TRB",cArqNtx,cIndCond,,,"Selecionando Registros....")
//������������������������������������������������������������������������������������������Ŀ
//�Incluido para atender a nova regra de Pre Estrutura - Luciano (Delta Decisao) - 22/03/2012�
//��������������������������������������������������������������������������������������������
cQryZZ4 := " SELECT ZZ4_CODPRO AS MODELO, B1_DESC AS DESCRI, ZZ4_OPEBGH AS OPEBGH " + ENTER
cQryZZ4	+= " FROM " + RetSqlname("ZZ4")+ " ZZ4 WITH(NOLOCK) " + ENTER
cQryZZ4	+= " INNER JOIN " + RetSqlname("SB1")+ " SB1 WITH(NOLOCK)	" + ENTER
cQryZZ4	+= " ON(ZZ4_CODPRO=SB1.B1_COD AND SB1.D_E_L_E_T_= '')	" + ENTER
cQryZZ4	+= " WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' "+ ENTER 
cQryZZ4	+= " AND ZZ4.ZZ4_IMEI = '" + cIMEI + "'	" + ENTER
cQryZZ4	+= " AND ZZ4.ZZ4_STATUS < 5  " + ENTER
cQryZZ4	+= " AND ZZ4.D_E_L_E_T_ = '' " + ENTER
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryZZ4), "QRYZZ4", .F., .T.)
dbSelectArea("QRYZZ4")
dbGoTop()
If !Eof()
	cQrySGG := " SELECT GG_COMP AS PECA, B1_DESC AS DESCRI1 " + ENTER
	cQrySGG += " FROM "+RetSqlName("SGG")+" AS SGG " + ENTER
	cQrySGG += " INNER JOIN " + RetSqlname("SB1")+ " SB1 WITH(NOLOCK)	" + ENTER 
	cQrySGG += " ON(GG_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_= '')	" + ENTER 
	cQrySGG += " WHERE " + ENTER 
	cQrySGG += " SGG.GG_FILIAL = '" + xFilial('SGG') + "' " + ENTER
	cQrySGG += " AND (SGG.GG_COD = " + ENTER
	cQrySGG += " ( SELECT TOP 1 GG_COMP " + ENTER
	cQrySGG += " FROM "+RetSqlName("SGG")+" AS GG_1 " + ENTER
	cQrySGG += " WHERE GG_1.GG_COD = '" +QRYZZ4->MODELO+ "' AND GG_1.D_E_L_E_T_ = '') " + ENTER
	cQrySGG += " OR SGG.GG_COD ='" +QRYZZ4->MODELO+ "') " + ENTER
	cQrySGG += " AND SGG.GG_TRT = '" +QRYZZ4->OPEBGH+ "' " + ENTER
	cQrySGG += " AND SGG.D_E_L_E_T_ = '' " + ENTER
	cQrySGG += " ORDER BY GG_COMP " + ENTER
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQrySGG), "QRYSGG", .F., .T.)
	dbSelectArea("QRYSGG")
	dbGoTop()
	While !Eof("QRYSGG")
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->TR_OK    	:= Space(2)
		TRB->TR_COD   	:= AllTrim(QRYZZ4->MODELO)
		TRB->TR_DESC 	:= AllTrim(QRYZZ4->DESCRI)
		TRB->TR_COMP   	:= AllTrim(QRYSGG->PECA)
		TRB->TR_DESC1  	:= AllTrim(QRYSGG->DESCRI1)
		TRB->TR_QUANT  	:= cQtd
		TRB->TR_NUMOS  	:= ""
		MsUnLock()
		dbSelectArea("QRYSGG")
		dbSkip()
	EndDo
	("QRYSGG")->( dbCloseArea())
Endif
("QRYZZ4")->( dbCloseArea())
//�����������������������������������������������������Ŀ
//�Final Inclus�o - Luciano (Delta Decisao) - 22/03/2012�
//�Apresenta o MarkBrowse para o usuario                �
//�������������������������������������������������������
dbSelectArea("TRB")
dbGoTop()
cMarca := GetMark()
MarkBrow("TRB","TR_OK","TR_NUMOS",aCampos,,cMarca,,,,,)
//�������������������������������������
//�Desfaz o indice e filtro temporario�
//�������������������������������������
TRB->(dbCloseArea())
Ferase(cArqDBF+OrdBagExt())
Ferase(cIndCond+OrdBagExt())
Return Nil
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �MacaBox   �Autor  �Paulo Lopez           � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Marca ou desmarca registro para processamento                ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MarcaBox()
dbSelectArea("TRB")
cRegAtu := TRB->TR_COD+TRB->TR_NUMOS
If IsMark("TR_OK",cMarca )
	RecLock("TRB",.F.)
	TRB->TR_OK := Space(2)
	MsUnLock()
Else
	RecLock("TRB",.F.)
	TRB->TR_OK := Space(2)
	MsUnLock()
Endif
Return Nil
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �MacaAll   �Autor  �Paulo Lopez           � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Marca ou desmarca todos registros                            ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MarcaAll()
dbSelectArea("TRB")
cRegAtu := TRB->TR_COD+TRB->TR_NUMOS
dbGoTop()
While !Eof("TRB")
	If TRB->TR_COD+TRB->TR_NUMOS # cRegAtu
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	If IsMark("TR_OK",cMarca )
		RecLock("TRB",.F.)
		TRB->TR_OK := Space(2)
		MsUnLock()
	Else
		RecLock("TRB",.F.)
		TRB->TR_OK := cMarca
		MsUnLock()
	Endif
	dbSelectArea("TRB")
	dbSkip()
EndDo
Return .T.
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �PesqTRB   �Autor  �Paulo Francisco       � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Pesquisa TRB                                                 ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function PesqTRB()
//������������������������Ŀ
//�Declara��es das var�veis�
//��������������������������
Local oCombo  := Nil
Local aCombo  := {}
Private oDlg    := Nil
Private cViaF3  := Space(30)
Private cCombo  := Space(30)
//����������������������Ŀ
//�Atribui��o as matrizes�
//������������������������
aAdd( aCombo, "Componente" )
//�������������������������������������0�
//�Defini��o da janela e seus conte�dos�
//�������������������������������������0�
DEFINE MSDIALOG oDlg TITLE "Apontamento de Pe�as" FROM 0,0 TO 100,500 OF oDlg PIXEL
@ 06,06 TO 46,242 LABEL "Pesquisa" OF oDlg PIXEL
@ 15, 15 MSGET cViaF3 PICTURE "@!" SIZE 180,10 PIXEL OF oDlg
@ 30, 15 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 180,10 PIXEL OF oDlg
//������������������Ŀ
//�Botoes da MSDialog�
//��������������������
@ 11,200 BUTTON "&Pesquisar" SIZE 36,17 PIXEL ACTION ExecPesq()
@ 26,200 BUTTON "Cancelar" SIZE 36,17 PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTER
Return
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ExecPesq  �Autor  �Paulo Francisco       � Data �  20/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Executa Pesquisa em TRB                                      ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ExecPesq()
dbSelectArea("TRB")
dbSetOrder(1)
dbSeek(TRB->TR_COD + Alltrim(cViaF3),.T.)
oDlg:End()
Return
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �MarcPeca  �Autor  �Paulo Francisco       � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Consulta para apontamento de varias Pe�as                    ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MarcPeca()
//������������������������Ŀ
//�Declara��es das var�veis�
//��������������������������
Local oCombo  := Nil
Local aCombo  := {}
Private oDlg    := Nil
Private cViaF3  := Space(15)
Private cCombo  := Space(15)
//����������������������Ŀ
//�Atribui��o as matrizes�
//������������������������
aAdd( aCombo, "Componente" )
//������������������������������������Ŀ
//�Defini��o da janela e seus conte�dos�
//��������������������������������������
DEFINE MSDIALOG oDlg TITLE "Apontamento de Pe�as" FROM 0,0 TO 100,500 OF oDlg PIXEL
@ 06,06 TO 46,242 LABEL "Apontar" OF oDlg PIXEL
@ 015, 015 MSGET cViaF3 VALID !Vazio() PICTURE "@!" SIZE 150,10 PIXEL OF oDlg
//@ 30, 15 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 180,10 PIXEL OF oDlg
//������������������Ŀ
//�Botoes da MSDialog�
//��������������������
@ 11,200 BUTTON "Apontar" SIZE 36,17 PIXEL ACTION ExecApon()
//@ 26,200 BUTTON "Cancelar" SIZE 36,17 PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTER
Return
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ExecApon  �Autor  �Paulo Francisco       � Data �  20/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Executa Apontamento Consultando                              ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ExecApon()
Local cCod
Local cDesc
Local cComp
Local cDesc1
Local cQry1
Local oFotoProd
Private lRet	:= .T.
Private _lRet	:= .T.
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
Endif
cQry1	:=	" SELECT COUNT(*) QTD " + ENTER
cQry1	+=	" FROM " + RetSqlName('SZ9')+ " SZ9 WITH(NOLOCK)	" + ENTER
cQry1	+=	" WHERE D_E_L_E_T_ = '' " + ENTER
cQry1	+=	" AND Z9_FILIAL = '" + xFilial('SZ9') + "' " + ENTER
cQry1	+=	" AND Z9_NUMOS = '" + AllTrim(cNumOs) + "' " + ENTER
cQry1	+=	" AND Z9_PARTNR = '" + Alltrim(cViaF3) + "' " + ENTER
MemoWrite("c:\pecasIII.sql", cQry1)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry1), "QRY2", .F., .T.)
If QRY2->QTD > 0
	//Pergunta grava��o de pecas duplicadas
	If MsgYesNo("Existe " + StrZero(QRY2-> QTD,3) + "pe�as apontadas para esse equipamento deseja prosseguir ? ", "Apontamento Pe�as")
		//u_SaldPeca(lRet,AllTrim(cViaF3))// Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
		u_Imagem(AllTrim(cViaF3))
		//�������������������������������������������������������������Ŀ
		//�Incluso rotina para verificar o saldo dispon�vel da pe�a para�
		//�somente informar o operador, mas nao impedir o               �
		//�apontamento                                                  �
		//�Conf. Falado com Marcos Santos em 08/05/12/.                 �
		//�Edson Rodrigues - 08/05//12                                  �
		//���������������������������������������������������������������
		If Empty(cSerWms)
			_lRet := Conspeca(cViaF3,AllTrim(cArmPeca),cEndProd,cNumOs,cIMEI)
		Else
			_nSalSB2  := 0
			_nSalBlq  := 0
			_nSalBuff := 0   
			_nSalDCF  := 0
			_nSalDisp := 0
			_cLocBuff := Alltrim(cEndBuf)+Space(15-Len(cEndBuf))
			_lRet    := .T.
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+Left(cViaF3,15)+Left(cArmSep,2))
				_nSalSB2  := SB2->(B2_QATU-B2_QACLASS)
				_nSalBuff :=  SaldoSBF(cArmSep, _cLOcBuff, cViaF3, NIL, NIL, NIL, .F.)
	   			_nSalDCF  :=  U_SALDCF(cViaF3,cArmSep)
	   			_nSalBlq  :=  EndBloq(cViaF3,cArmSep)
	   			_nSalDisp := _nSalSB2 - _nSalBuff - _nSalDCF - _nSalBlq
			Endif
			If _nSalDisp < 1
				AutoGRLog("Componente "+Alltrim(cViaF3)+" n�o possui saldo. Favor verificar!" ) 
			    AutoGRLog("SALDO ESTOQUE   -> "+Alltrim(STR(Round(_nSalSB2 ,2))))
	            AutoGRLog("SALDO BUFFER    -> "+Alltrim(STR(Round(_nSalBuff,2))))
	            AutoGRLog("SALDO WMS (O.S.)-> "+Alltrim(STR(Round(_nSalDCF,2))))
	            AutoGRLog("SALDO BLOQUEADO -> "+Alltrim(STR(Round(_nSalBlq,2))))
	            AutoGRLog("SALDO DISPONIVEL-> "+Alltrim(STR(Round(_nSalDisp,2))))
		        MostraErro()
				_lRet    := .F.
			Endif
		Endif
		If _lRet
			dbSelectArea("TRB")
			dbSetOrder(1)
			dbSeek(TRB->TR_COD + Alltrim(cViaF3),.T.)
			If TRB->TR_COD + AllTrim(cViaF3) == TRB->TR_COD + AllTrim(TRB->TR_COMP)
				cCod 	:= TRB->TR_COD
				cDesc	:= TRB->TR_DESC
				cComp	:= TRB->TR_COMP
				cDesc1	:= TRB->TR_DESC1
				If IsMark("TR_OK",cMarca )
					RecLock("TRB",.F.)
					TRB->TR_OK      := cMarca
					TRB->TR_COD     := cCod
					TRB->TR_DESC    := cDesc
					TRB->TR_COMP    := cComp
					TRB->TR_DESC1   := cDesc1
					TRB->TR_QUANT   := 01
					TRB->TR_NUMOS   := ""
					//TRB->TR_QUANT  	:= cQtd := TRB->TR_QUANT + 01// Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
					MsUnLock()
				Else
					RecLock("TRB",.F.)
					TRB->TR_OK := cMarca
					MsUnLock()
				Endif
			Else
				MsgAlert("Componente n�o Encontrado !!!","Alerta")
			Endif
		Endif
	Endif
Else
	u_Imagem(AllTrim(cViaF3))
	//u_SaldPeca(lRet,AllTrim(cViaF3))// Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
	//�������������������������������������������������������������Ŀ
	//�Incluso rotina para verificar o saldo dispon�vel da pe�a para�
	//�somente informar o operador, mas nao impedir o               �
	//�apontamento.                                                 �
	//�Conf. Falado com Marcos Santos em 08/05/12/.                 �
	//�Edson Rodrigues - 08/05//12                                  �
	//���������������������������������������������������������������
	If Empty(cSerWms)
		_lRet:=Conspeca(cViaF3,AllTrim(cArmPeca),cEndProd,cNumOs,cIMEI)
	Else
		_nSalSB2  := 0
		_nSalBlq  := 0
		_nSalBuff := 0
		_nSalDCF  := 0
		_nSalDisp := 0
		_cLocBuff := Alltrim(cEndBuf)+Space(15-Len(cEndBuf))
		_lRet    := .T.
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+Left(cViaF3,15)+Left(cArmSep,2))
			_nSalSB2  := SB2->(B2_QATU-B2_QACLASS)
			_nSalBuff :=  SaldoSBF(cArmSep, _cLOcBuff, cViaF3, NIL, NIL, NIL, .F.)
			_nSalDCF  :=  U_SALDCF(cViaF3,cArmSep)
			_nSalBlq  :=  EndBloq(cViaF3,cArmSep)
			_nSalDisp := _nSalSB2 - _nSalBuff - _nSalDCF - _nSalBlq
		Endif
		If _nSalDisp < 1
			AutoGRLog("Componente "+Alltrim(cViaF3)+" n�o possui saldo. Favor verificar!" ) 
		    AutoGRLog("SALDO ESTOQUE   -> "+Alltrim(STR(Round(_nSalSB2 ,2))))
	        AutoGRLog("SALDO BUFFER    -> "+Alltrim(STR(Round(_nSalBuff,2))))
	        AutoGRLog("SALDO WMS (O.S.)-> "+Alltrim(STR(Round(_nSalDCF,2))))
	        AutoGRLog("SALDO BLOQUEADO -> "+Alltrim(STR(Round(_nSalBlq,2))))
	        AutoGRLog("SALDO DISPONIVEL-> "+Alltrim(STR(Round(_nSalDisp,2))))
		    MostraErro()
			_lRet    := .F.
		Endif
	Endif
	If _lRet
		dbSelectArea("TRB")
		dbSetOrder(1)
		dbSeek(TRB->TR_COD + Alltrim(cViaF3),.T.)
		If TRB->TR_COD + AllTrim(cViaF3) == TRB->TR_COD + AllTrim(TRB->TR_COMP)
			cCod 	:= TRB->TR_COD
			cDesc	:= TRB->TR_DESC
			cComp	:= TRB->TR_COMP
			cDesc1	:= TRB->TR_DESC1
			If IsMark("TR_OK",cMarca )
				RecLock("TRB",.F.)
				TRB->TR_OK      := cMarca
				TRB->TR_COD     := cCod
				TRB->TR_DESC    := cDesc
				TRB->TR_COMP    := cComp
				TRB->TR_DESC1   := cDesc1
				TRB->TR_QUANT   := 01
				TRB->TR_NUMOS   := ""
				//TRB->TR_QUANT  	:= cQtd := TRB->TR_QUANT + 01// Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
				MsUnLock()
			Else
				RecLock("TRB",.F.)
				TRB->TR_OK := cMarca
				MsUnLock()
			Endif
		Else
			MsgAlert("Componente n�o Encontrado !!!","Alerta")
		Endif
	Endif
Endif
cQtd := 01
oDlg:End()
GetdRefresh()
u_MarcPeca()
Return ()
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �MontPeca  �Autor  �Paulo Francisco       � Data �  19/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Executa Incluss�o de Pe�as                                   ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MontPeca()
Local nItens	:= 0
Local cItem		:= 0
Local _xQry
Local __cImei	:= ""
Local __cOs		:= ""
Local lRadioF	:= (SuperGetMV("MV_RADIOF", .F., "N") == "S")
Private aItens	:= {}
Private lEnd	:= .T.
Private lSaldo	:= .T.
Private nRecZZ3
Private nRecSZ9  

//����������������������������������������������������Ŀ
//�  Valida se aparelho pode ser apontado via Protheus,�
//�de acordo com as regras de negocio implicitas no doc�
//�BGHDP0028                                           �
//������������������������������������������������������

If !U_VldApont(cIMEI) && Alterado Uiran Almeida - 12.02.2014 GLPI - 16 832 
	Return
EndIf             

//�����������������������������Ŀ
//�Verifica se ha itens marcados�
//�������������������������������
dbSelectArea("TRB")
dbGoTop()
While TRB->(!Eof())
	If TRB->TR_OK == cMarca .And. Empty(TRB->TR_NUMOS)
		nItens++
		If !Empty(cSerWms)
			_nSalSB2  := 0
			_nSalBlq  := 0
			_nSalBuff := 0
			_nSalDCF  := 0
			_nSalDisp := 0
			_cLocBuff := Alltrim(cEndBuf)+Space(15-Len(cEndBuf))
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+TRB->TR_COMP+cArmSep)
				_nSalSB2	:= SB2->(B2_QATU-B2_QACLASS)
				_nSalBuff	:= SaldoSBF(cArmSep, _cLOcBuff, TRB->TR_COMP, NIL, NIL, NIL, .F.)
	   			_nSalDCF	:= U_SALDCF(TRB->TR_COMP,cArmSep)
	   			_nSalBlq	:= EndBloq(TRB->TR_COMP,cArmSep)
	   			_nSalDisp	:= _nSalSB2 - _nSalBuff - _nSalDCF - _nSalBlq
			Endif
			If _nSalDisp < TRB->TR_QUANT
				AutoGRLog("Componente "+Alltrim(TRB->TR_COMP)+" n�o possui saldo. Favor verificar!" ) 
			    AutoGRLog("SALDO ESTOQUE   -> "+Alltrim(STR(Round(_nSalSB2 ,2))))
	            AutoGRLog("SALDO BUFFER    -> "+Alltrim(STR(Round(_nSalBuff,2))))
	            AutoGRLog("SALDO WMS (O.S.)-> "+Alltrim(STR(Round(_nSalDCF,2))))
	            AutoGRLog("SALDO BLOQUEADO -> "+Alltrim(STR(Round(_nSalBlq,2))))
	            AutoGRLog("SALDO DISPONIVEL-> "+Alltrim(STR(Round(_nSalDisp,2))))
		        MostraErro()
				lSaldo    := .F.
			Endif
		Endif
	Endif
	TRB->(dbSkip())
EndDo
If nItens == 0
	MsgStop("N�o h� pe�as selecionados!","Apontamento de Pe�as")
	Return
Endif
If !lSaldo
	MsgStop("Favor analisar saldo das pe�as para prosseguir!","Apontamento de Pe�as")
	Return
Endif
//������������������������������������������Ŀ
//�Rotina de travamento do radio - GLPI 14467�
//��������������������������������������������
__cImei	:= SubSTR(TRB->TR_NUMOS,1,(AT(" - ",TRB->TR_NUMOS)-1))
__cOs	:= SubSTR(TRB->TR_NUMOS,(AT(" - ",TRB->TR_NUMOS)+3))
If !U_VLDTRAV(xFilial("ZZ4"),__cImei,__cOs,{"P","APONTPCA","MontPeca"})
	Return
EndIf


//��������������������Ŀ
//�Gera Inclussao Pecas�
//����������������������
If MsgYesNo("Deseja prosseguir com Inclus�o das pe�as ? ", "Apontamento Pe�as")
	SB1->(dbSetOrder(1))
	//�����������������Ŀ
	//�Pocisiona Produto�
	//�������������������
	SB1->(dbSeek(xFilial("SB1") + AllTrim(TRB->TR_COMP)))
	If Select("QRYX") > 0
		QRYX->(dbCloseArea())
	Endif
	_xQry	:= "SELECT TOP 1 Z9_NUMSEQ SEQ FROM "+RetSqlName("SZ9") + " WHERE Z9_STATUS = '1' AND Z9_PARTNR <> '' AND Z9_NUMOS = '"+cNumOs+"' ORDER BY R_E_C_N_O_ DESC "
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _xQry), "QRYX", .F., .T.)
	/*
	If Len(AllTRim(QRYX->SEQ)) >0
		cDoc := Soma1(QRYX->SEQ)
	Else
		cDoc := AllTrim(cNumOs)
		cDoc += "11A"
	Endif
	*/
	dbSelectArea("TRB")
	//�����������������������������Ŀ
	//�Verifica se ha itens marcados�
	//�������������������������������
	dbSetOrder(1)
	dbGoTop()
	cSeq	:=	Soma1(cSeq)
	Begin Transaction
	dbSelectArea("ZZ3")
	RecLock("ZZ3",.T.)
	ZZ3->ZZ3_FILIAL    	:= 	xFilial("ZZ3")
	ZZ3->ZZ3_CODTEC   	:= 	AllTrim(_CodTec)
	ZZ3->ZZ3_LAB 		:= 	cLab
	ZZ3->ZZ3_CODSET  	:= 	cCodSe2
	ZZ3->ZZ3_DATA   	:= 	date()
	ZZ3->ZZ3_HORA   	:= 	Time()
	ZZ3->ZZ3_FASE1		:= 	cFaSe2
	ZZ3->ZZ3_FASE2		:= 	cFaSe2
	ZZ3->ZZ3_ENCOS		:=	"N"
	ZZ3->ZZ3_IMEI		:=	cIMEI
	ZZ3->ZZ3_SWAP		:=	"N"
	ZZ3->ZZ3_NUMOS		:=	cNumOs
	ZZ3->ZZ3_STATUS		:=	"1"
	ZZ3->ZZ3_SEQ		:=	cSeq
	ZZ3->ZZ3_USER		:=	cUserName
	ZZ3->ZZ3_CODSE2		:=	cCodSe2
	MsUnLock()
	nRecZZ3 := ZZ3->(RECNO())
	End Transaction
	While !Eof("TRB")
		If TRB->TR_OK # cMarca .Or. !Empty(TRB->TR_NUMOS)
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		cEmpR := TRB->TR_COD + TRB->TR_COMP
		While TRB->TR_COD + TRB->TR_COMP == cEmpR
			Begin Transaction
			dbSelectArea("SZ9")
			RecLock("SZ9",.T.)
			SZ9->Z9_FILIAL    	:= 	xFilial("SZ9")
			SZ9->Z9_NUMOS   	:= 	cNumOs
			SZ9->Z9_SEQ 		:= 	cSeq
			SZ9->Z9_CODTEC   	:= 	AllTrim(_CodTec)
			SZ9->Z9_ITEM   		:= 	"01"
			SZ9->Z9_QTY			:= 	TRB->TR_QUANT
			SZ9->Z9_USED		:= 	"0"
			SZ9->Z9_IMEI		:=	cIMEI
			SZ9->Z9_STATUS		:=	"1"
			SZ9->Z9_FASE1		:=	cFaSe2
			SZ9->Z9_PREVCOR		:=	"C"
			SZ9->Z9_PARTNR		:= TRB->TR_COMP
			//SZ9->Z9_NUMSEQ		:= cDoc  // Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
			SZ9->Z9_LOCAL		:= AllTrim(cArmPeca)
			SZ9->Z9_DTAPONT		:= dDataBase//Gravar data do apontamento da peca conforme solicita�ao do Edson - 27/07			
			SZ9->Z9_USRINCL		:= AllTrim(_CodTec)  + ' - ' + AllTrim(cUsername)
			If !Empty(cSerWms)
				SZ9->Z9_COLETOR	:=	'S'
			Endif			
			MsUnLock()
			nRecSZ9 := SZ9->(RECNO())
			If Empty(cSerWms)
				aAdd(aItens,{TRB->TR_COMP,;
				Left(SB1->B1_DESC,30),;
				AllTrim(SB1->B1_UM),;
				cArmPeca,;
				cEndProd,;
				TRB->TR_COMP,;
				Left(SB1->B1_DESC,30),;
				AllTrim(SB1->B1_UM),;
				cArmPeca,;
				cEndAudi,;
				Space(20),;
				Space(10),;
				Space(06),;
				CtoD("//"),;
				0,;
				TRB->TR_QUANT,;
				0,;
				"N",;
				Space(06),;
				Space(10),;
				CtoD("//"),;
				Space(03),;
				Space(03)})
			Else
				aAdd(aItens,{TRB->TR_COMP,cArmSep,TRB->TR_QUANT,nRecSZ9})
			Endif
			End Transaction
			RecLock("TRB",.F.)
			TRB->TR_OK    	:= Space(2)
			TRB->TR_NUMOS 	:= cIMEI + " - " + cNumOs
			MsUnLock()
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	EndDo
	GetdRefresh()
	//u_BaixPeca(cDoc,aItens,3)// Desabilitado conforme solicita��o Sr. Rodrigo Bazzo
	If !Empty(cSerWms)
		If Len(aItens) > 0
			Processa({|lEnd| GeraMov(@lEnd, lRadioF)},'Execucao de Servicos','Executando Servicos...',.T.)	//'Executando Servicos...'
			aItens:= {}
			ETQSEP()
		Endif
	Endif
	u_ImprPeca(cIMEI)
Else
	GetdRefresh()
Endif
Return
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Legenda   �Autor  �Paulo Francisco       � Data �  20/10/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Gera Legenda                                                 ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Generico                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function Peca5L()
Local aCor := {}
aAdd(aCor,{"BR_VERDE"   ,"Equipamento sem Selec�o"})
aAdd(aCor,{"BR_VERMELHO","Equipamento Selecionado"})
BrwLegenda(cCadastro,OemToAnsi("Registros"),aCor)
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Imagem    �Autor  �Paulo Francisco	 � Data �  24/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao utilizada para exibir/alterar a imagem do Produto.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Imagem()
Local	oBitPro
Local 	oDlgFoto		// Objeto do form
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + Alltrim(cViaF3))
DEFINE MSDIALOG oDlgFoto FROM 0,0 TO 265,260 TITLE ("Imagem") PIXEL // "Imagem"
If Empty(SB1->B1_BITMAP)
	@ 80,30 SAY ("Foto n�o disponivel" ) SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlgFoto //"Foto n�o disponivel"
Else
	@ 10,13 REPOSITORY oBitPro OF oDlgFoto NOBORDER SIZE 350,200 PIXEL
	Showbitmap(oBitPro,SB1->B1_BITMAP,"")
	oBitPro:lStretch:=.F.
	oBitPro:Refresh()
Endif
@110,010 BUTTON "OK" SIZE 50,15 OF oDlgFoto PIXEL ACTION (lRet := .T.,oDlgFoto:End())
@110,075 BUTTON "Cancel" SIZE 50,15 OF oDlgFoto PIXEL ACTION (lRet := .F.,oDlgFoto:End())
ACTIVATE MSDIALOG oDlgFoto
Return(lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �   BMPOK  �Autor  �Paulo Francisco     � Data �  24/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Passagem de parametros para botao "confirma". Isso para     ���
���          �atualizar a imagem.                                         ���
�������������������������������������������������������������������������͹��
���Uso       �SM2A010                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BMPOK(cArq,oFotoProd,oSayBMP,oLogoFirst)
oFotoProd:CBMPFILE:=cArq
oSayBMP:CCAPTION:=ArqSemDir(cArq)
If oLogoFirst != NIL
	oLogoFirst:LVISIBLE:=.F.
Endif
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ArqSemDir �Autor  �Paulo Francisco     � Data �  24/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina generica para tirar o path do caminho do arquivo e   ���
���          �retornar apenas o nome e extensao.                          ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ArqSemDir(cArquivo)
Local	cStr
Local 	i
cStr := AllTrim(cArquivo)
For i := Len(cStr) to 1 Step -1
	If Substr(cStr,i,1) == "\"
		cArquivo := Substr(cStr,i+1,Len(cStr)-i)
		Exit
	Endif
	Loop
Next
Return(cArquivo)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RetNomArq	�Autor  �Paulo Francisco        � Data �24/10/11  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o nome do arquivo                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpC1: Nome Arquivo                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Caminho onde se encontra o caminho                   ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RetNomArq(cPatch)
Local nPosBar := 0
Local cNomArq := ""
Default cPatch  := ""
nPosBar := At("\",cPatch)
cNomArq := SubStr(cPatch,nPosBar+1,Len(cPatch))
While (nPosBar <> 0)
	nPosBar := At("\",cNomArq)
	cNomArq := SubStr(cNomArq,nPosBar+1,Len(cNomArq))
EndDo
Return cNomArq
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ImprPeca � Autor �Paulo Francisco     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �IMPRIME PECAS APONTADAS CONFORME PARAMETRO INFORMADO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ImprPeca()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private oPrint
//���������������������������������������������������������������������Ŀ
//� Impressao                                                           �
//�����������������������������������������������������������������������
oPrint   := PcoPrtIni("Impress�o de Pe�as",.F.,2,)
oProcess := MsNewProcess():New({|lEnd| fCONSPEI(,oPrint,oProcess,cIMEI)},"","",.F.)
oProcess :Activate()
PcoPrtEnd(oPrint)
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCONSPEI  � Autor �Paulo Francisco     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �EFETUA IMPRESSAO DA REQUISICAO                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fCONSPEI(lEnd,oPrint,oProcess,cIMEI)
//���������������������������������������������������������������������Ŀ
//� Variaveis utilziadas                                                �
//�����������������������������������������������������������������������
Private  nLin
Private  cQry
Private  cServ
Private nItens
Private nVia
//���������������������������������������������������������������������Ŀ
//� Fontes utilizadas                                                   �
//�����������������������������������������������������������������������
Private oFont0  := TFont():New( "Arial"             ,,07     ,,.F.,,,,,.F.)
Private oFont2	:= TFont():New( "Arial"             ,,10     ,,.T.,,,,,.F.)
Private oFont3	:= TFont():New( "Arial"             ,,14     ,,.T.,,,,,.F.)
//���������������������������������������������������������������������Ŀ
//|Verifica parametro IMEI esta vazio                                   �
//�����������������������������������������������������������������������
CursorWait()
If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif
//���������������������������������������������������������������������Ŀ
//| Montagem da Query                                                   �
//�����������������������������������������������������������������������
cQry	:=	" SELECT 	ZZ4.ZZ4_CODCLI			CODCLI,	" + ENTER
cQry	+=	" 			SA1.A1_EST				EST,    " + ENTER
cQry	+=	" 			ZZ4.ZZ4_LOJA  			LOJA, 	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_IMEI  			IMEI, 	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_CARCAC			CARCAC, " + ENTER
cQry	+=	" 			RTRIM(ZZ4.ZZ4_CODPRO)	COD, 	" + ENTER
cQry	+=	" 			RTRIM(SB1.B1_DESC)		PRODUT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_FILIAL 			FILIAL," + ENTER
cQry	+=	" 			ZZ4.ZZ4_OS  			ORDSERV," + ENTER
cQry	+=	" 			ZZ4.ZZ4_OPEBGH 			OPERAC,	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_OPEANT			OPERAT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_GARANT			GARANT, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_BOUNCE			BOUNCE,	" + ENTER
cQry	+=	" 			ZZ4.ZZ4_TRANSC			TRANSC,	" + ENTER
cQry	+=	" 			SZA.ZA_GARNFC			GARNFC, " + ENTER
cQry	+=	" 			ZZ4.ZZ4_DEFINF			Z4_DEFI," + ENTER
cQry	+=	" 			ISNULL(ZZG1.ZZG_RECCLI, 'C0022')AS	RECLAM, 			" + ENTER
cQry	+=	" 			SZA.ZA_DEFRECL			DEFEITO," + ENTER
cQry	+=	" 			ISNULL(SZA.ZA_SPC,0)	SPC,	" + ENTER
cQry	+=	" 			ISNULL(SZA.ZA_NOMUSER,0) NOMUSER,	" + ENTER
cQry	+=	" 			ZZG.ZZG_DESCRI			DESCRIC, 	" + ENTER
cQry	+=	" 			ZZG1.ZZG_DESCRI			DESCRIC1	" + ENTER
cQry	+= " FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock)   	" + ENTER
cQry	+= " LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock)   	" + ENTER
cQry	+= " ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI    " 			+ ENTER
cQry	+= " AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)   " 	+ ENTER
cQry	+= " INNER JOIN " + RetSqlName("SB1") + " SB1 (nolock)  	" 																							+ ENTER
cQry	+= " ON(ZZ4.ZZ4_CODPRO = SB1.B1_COD AND SB1.B1_FILIAL = '" + xFilial("SB1") + "')" 																		+ ENTER
cQry	+= " INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock) " 																								+ ENTER
cQry	+= " ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '" + xFilial("SB1") + "')"											+ ENTER
cQry	+= " LEFT JOIN " +  RetSqlName("ZZG") + " ZZG1 (nolock)  	" 																							+ ENTER
cQry	+= " ON(ZZ4.ZZ4_DEFINF = ZZG1.ZZG_CODIGO AND ZZG1.D_E_L_E_T_ = '') " 																					+ ENTER
cQry	+= " LEFT JOIN " +  RetSqlName("ZZG") + " ZZG (nolock)  	" 																							+ ENTER
cQry	+= " ON(SZA.ZA_DEFRECL = ZZG.ZZG_CODIGO AND ZZG.D_E_L_E_T_ = '') " 																						+ ENTER
cQry	+= " WHERE ZZ4.ZZ4_STATUS IN ('3','4')   " 																												+ ENTER
cQry	+= " AND ZZ4.D_E_L_E_T_ = ''   " 														  																+ ENTER
cQry	+= " AND ZZ4.ZZ4_FILIAL = '" + xFilial("ZZ4") + "' " 																									+ ENTER
cQry	+= " AND ZZ4.ZZ4_IMEI = '" + AllTRim(cIMEI) + "'  " 	 																											+ ENTER
MemoWrite("c:\pecas.sql", cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)
TCSetField("QRY", "DTENTRA", "D")
TCSetField("QRY", "DTCOMP",  "D")
TCSetField("QRY", "DTTROC",  "D")
TCSetField("QRY", "GARACARC",  "D")
QRY->(dbGoTop())
If Len (AllTrim(QRY->OPERAC)) < 1
	CursorArrow()
	MsgStop("Caro Usuario IMEI 	N�o Localizado")
	Return()
Endif
CursorArrow()
//���������������������������������������������������������������������Ŀ
//� Impressao                                                           �
//�����������������������������������������������������������������������
oPrint :StartPage()
fCabec() //Cabecalho
dbSelectArea("SZ9")
dbSetOrder(2)
dbSeek( xFilial("SZ9") + QRY->IMEI + QRY->ORDSERV )
nItens 	:= 0
nVia 	:= 0
nTot	:= 0
While !SZ9->(Eof()) .And. ( SZ9->Z9_FILIAL+SZ9->Z9_IMEI + SZ9->Z9_NUMOS ) == ( QRY->FILIAL + QRY->IMEI + QRY->ORDSERV )
	oPrint :Say( nLin , 0018 , SZ9->Z9_PARTNR , oFont0 , 100 )
	oPrint :Say( nLin , 0420 , Posicione("SB1",1,xFilial("SB1") + SZ9->Z9_PARTNR,"B1_DESC") , oFont0 , 100 )
	oPrint :Say( nLin , 1075 , Posicione("SB1",1,xFilial("SB1") + SZ9->Z9_PARTNR,"B1_UM") , oFont0 , 100 )
	oPrint :Say( nLin , 1315 , Transform(StrZero(SZ9->Z9_QTY,2),"@E 99") ,oFont0 , 100 )
	oPrint :Say( nLin , 1560 , Transform(SZ9->Z9_SEQ,"@E 99") , oFont0 , 100 )
	oPrint :Say( nLin , 1850 , Transform(SZ9->Z9_LOCAL,"@E 99") , oFont0 , 100 )
	oPrint :Say( nLin , 2160 , SZ9->Z9_CODTEC , oFont0 , 100 )
	nLin += 48
	oPrint :Box( nLin , 0008 , nLin + 1 , 2350 )
	nLin += 7
	nItens++
	If  !Empty(SZ9->Z9_PARTNR) .And. nTot == 0
		nTot :=   SZ9->Z9_QTY
	Else
		nTot +=   SZ9->Z9_QTY
	Endif
	If nItens > 43
		oPrint :EndPage()
		oPrint :StartPage()
		fCabec()
	Endif
	dbSelectArea("SZ9")
	dbSkip()
EndDo
nVia ++
fRodape()
oPrint :EndPage()
QRY->(dbCloseArea())
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRodape   � Autor �Paulo Francisco     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �RODAPE DE IMPRESSAO                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fRodape()
oPrint:Box( 2900 , 0008 , 2903 , 2350 )
oPrint:Box( 2903 , 0008 , 2980 , 0600 ) //Peso Bruto
oPrint:Box( 2903 , 0600 , 2980 , 1600 ) //Embalagens
oPrint:Box( 2903 , 1600 , 2980 , 2350 ) //Valor Total
oPrint:Box( 3170 , 0008 , 3310 , 1198 ) //Data da Conferencia
oPrint:Box( 3170 , 1198 , 3310 , 2350 ) //Visto do Conferente
oPrint:Say( 2920 , 0020 , "Quantidade Pe�as: " + Transform(StrZero(nTot,2),"@E 999")                    				,oFont0, 100 )
oPrint:Say( 2920 , 0610 , "Qtde. Equipamento: 01 "                                                          				,oFont0, 100 )
oPrint:Say( 2920 , 1610 , "Descri��o Produto: " + QRY->PRODUT	 														,oFont0, 100 )
oPrint:Say( 3180 , 0020 , "Data da Conferencia: "                                                                   	,oFont0, 100 )
oPrint:Say( 3220 , 0600 , "          /                     /"                                                       	,oFont0, 100 )
oPrint:Say( 3180 , 1210 , "Visto do Conferente: "                                                                  		,oFont0, 100 )
oPrint:Box( 3285 , 1218 , 3286 , 2358 )
oPrint:Say( 3320 , 0005 , "Data : " + DtoC(dDataBase) + "    Hora : " + Time() 				 						, oFont0  , 100 )
oPrint:Say( 3320 , 2175 , "Via N�. : " + StrZero(nVia,2)                                                               , oFont0  , 100 )
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabec    � Autor �Paulo Francisco     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao �CABECALHO DE IMPRESSAO                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fCabec()
//���������������������������������������������������������������������Ŀ
//| Cabecalho                                                           �
//�����������������������������������������������������������������������
oPrint :Box( 0200 , 0008 , 3310 , 2350 ) //Itens
oPrint :Box( 0012 , 0008 , 0200 , 2100 ) //Produto
oPrint :Box( 0012 , 2100 , 0200 , 2350 ) //Ordem
oPrint :Box( 0200 , 0008 , 0260 , 0600 ) //IMEI
oPrint :Box( 0260 , 0008 , 0320 , 0600 ) //Carcaca
oPrint :Box( 0320 , 0008 , 0380 , 0600 ) //Transaction
oPrint :Box( 0380 , 0008 , 0440 , 1150 ) //Operacao
oPrint :Box( 0380 , 1150 , 0440 , 2350 ) //Observacoes
oPrint :Say( 0075 , 0033 , " Produto: " , oFont3 , 100 )
oPrint :Say( 0075 , 2125 , AllTrim(QRY->COD) , oFont2 , 100 )
oPrint :Say( 0210 , 0033 , "Ordem: " + AllTrim(QRY->ORDSERV)+space(20)+"Documento: " + AllTrim(cDoc) , oFont0 , 100 )
oPrint :Say( 0270 , 0033 , "IMEI: " + Alltrim(QRY->IMEI), oFont0 , 100 )
oPrint :Say( 0330 , 0033 , "Carca�a: " + AllTrim(QRY->CARCAC) , oFont0 , 100 )
oPrint:Say( 0390 , 0033 , "Transaction: " + AllTrim(QRY->TRANSC) , oFont0  , 100 )
oPrint:Say( 0390 , 1180 , "Opera��o: " + Alltrim(QRY->OPERAC) , oFont0  , 100 )
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial() + QRY->CODCLI + QRY->LOJA)
cNomCli := SA1->A1_COD + "-" + SA1->A1_LOJA + " / "  + Rtrim(SA1->A1_NOME)+ "   " + "Telefone : " + SA1->A1_TEL + " Fax : " + SA1->A1_FAX
cEndCli := Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - CEP:"+Transform(SA1->A1_CEP,"99999-999")+" - "+Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_EST)
cEntCli := Alltrim(SA1->A1_ENDENT)
oPrint :Say( 0210 , 0610 , "Cliente: " + cNomCli , oFont0 , 100 )
oPrint :Say( 0270 , 0610 , "End.: " + cEndCli , oFont0 , 100 )
oPrint :Say( 0330 , 0610 , "End. Entrega: " + cEntCli , oFont0 , 100 )
//���������������������������������������������������������������������Ŀ
//| Montagem do Layout de Impressao (Detalhe)                           �
//�����������������������������������������������������������������������
oPrint :Box( 0440 , 0008 , 0443 , 2350 )
oPrint :Box( 0443 , 0008 , 0503 , 0410 ) //Cod. Prod.
oPrint :Box( 0506 , 0008 , 2900 , 0410 )
oPrint :Box( 0443 , 0410 , 0503 , 1065 ) //Desc. Prod.
oPrint :Box( 0506 , 0410 , 2900 , 1065 )
oPrint :Box( 0443 , 1065 , 0503 , 1180 ) //U.M.
oPrint :Box( 0506 , 1065 , 2900 , 1180 )
oPrint :Box( 0443 , 1180 , 0503 , 1440 ) //Qtde.
oPrint :Box( 0506 , 1180 , 2900 , 1440 )
oPrint :Box( 0443 , 1440 , 0503 , 1740 ) //Qtde. Entregue
oPrint :Box( 0506 , 1440 , 2900 , 1740 )
oPrint :Box( 0446 , 1740 , 0503 , 2040 ) //Val. Unit.
oPrint :Box( 0506 , 1740 , 2900 , 2040 )
oPrint :Box( 0443 , 2040 , 0503 , 2350 ) //Total do Item
oPrint :Box( 0506 , 2040 , 2900 , 2350 )
oPrint :Say( 0453 , 0018 , "C�DIGO DO PRODUTO"    , oFont0 , 100 )
oPrint :Say( 0453 , 0420 , "DESCRI��O DO PRODUTO" , oFont0 , 100 )
oPrint :Say( 0453 , 1075 , "U.M"                  , oFont0 , 100 )
oPrint :Say( 0453 , 1190 , "QUANTIDADE"                , oFont0 , 100 )
oPrint :Say( 0453 , 1450 , "SEQU�NCIA"       , oFont0 , 100 )
oPrint :Say( 0453 , 1750 , "ARMAZ�M"       , oFont0 , 100 )
oPrint :Say( 0453 , 2050 , "T�CNICO"          , oFont0 , 100 )
nLin := 512
Return()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Conspeca  � Autor �Edson Rodrigues     � Data �  09/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao �Consulta saldo de pe�a dispon�vel no estoque                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Conspeca(cComp,cArm,cEnd,cos,cimei)
nSalb2  := 0
lsalend :=.t.
lsalest :=.t.
nQtd    := 0
lReturn :=.t.
_center := CHR(10)+CHR(13)
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + Left(cComp,15)))
cQtdLtmi	:=	SB1->B1_LOTEMPR
dbSelectArea("SB2")
SB2->(dbSetOrder(1))
SB2->(dbSeek(xFilial('SB2') + Left(cComp,15) + Left(cArm,2)))
//��������������������������������������������������������������Ŀ
//| Chama Funcao Padra para Consultar Saldo do Produto           |
//����������������������������������������������������������������
nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
If nSalb2 > 0
	If Select("QRY3") > 0
		QRY3->(dbCloseArea())
	Endif
	cqry :=" SELECT ISNULL(SUM(Z9_QTY),0) QTD " + ENTER
	cqry +=" FROM "+ RetSqlName("SZ9")+" SZ9 WITH(NOLOCK)     " + ENTER
	cqry +=" INNER JOIN (SELECT ZZ3_FILIAL,ZZ3_NUMOS,ZZ3_SEQ FROM "+ RetSqlName("ZZ3")+" ZZ3 WITH(NOLOCK) " + ENTER
	cqry +="             INNER JOIN (SELECT ZZ4_FILIAL,ZZ4_OS FROM "+ RetSqlName("ZZ4")+" WITH(NOLOCK) WHERE D_E_L_E_T_='' AND ZZ4_STATUS<'5') AS ZZ4 " + ENTER
	cqry +="             ON ZZ3_FILIAL=ZZ4_FILIAL AND ZZ3_NUMOS=ZZ4_OS " + ENTER
	cqry +="             WHERE ZZ3.D_E_L_E_T_='' AND ZZ3.ZZ3_ESTORN<>'S' AND ZZ3.ZZ3_STATUS='1') AS ZZ31 " + ENTER
	cqry +=" ON Z9_FILIAL=ZZ3_FILIAL AND Z9_NUMOS=ZZ3_NUMOS AND Z9_SEQ=ZZ3_SEQ AND Z9_COLETOR<>'S' " + ENTER
	cqry +=" WHERE D_E_L_E_T_ = '' AND Z9_NUMSEQ='' " + ENTER
	cqry +=" AND Z9_FILIAL = '" + xFilial('SZ9') + "' " + ENTER
	cqry +=" AND Z9_PARTNR = '" + Alltrim(cComp) + "' " + ENTER
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cqry), "QRY3", .F., .T.)
	nQtd := QRY3->QTD
	If nSalb2 >= nQtd
		dbSelectArea("SBF")
		SBF->(dbSetOrder(7))
		If SBF->(dbSeek(xFilial('SBF') + Left(cComp,15) + Left(cArm,2) + AllTrim(cEnd)))
			If SBF->BF_QUANT > 0
				If !Empty(AllTrim(cQtdLtmi))
					If SBF->BF_QUANT <= cQtdLtmi
						lsalend:=.f.
					ElseIf SBF->BF_QUANT < (nQtd+1)
						lsalend:=.f.
					Endif
				Else
					If SBF->BF_QUANT < (nQtd+1)
						lsalend:=.f.
					Endif
				Endif
			Else
				lsalend:=.f.
			Endif
		Else
			lsalend:=.f.
		Endif
	Else
		lsalest :=.f.
	Endif
Else
   lsalest :=.f.
Endif	
If !lsalend
    lReturn :=.f.
	Alert("O Partnumber : "+alltrim(cComp)+" selecionado nao tem saldo dispon�vel no armazem/Endere�o : "+alltrim(cArm)+"/"+AllTrim(cEnd)+". O apontamento n�o ser� realizado. Fale com seu superior")
	cMensagem := "Partnumber : "+alltrim(cComp)+"  N�o apontado (Pe�as auditoria) por falta de saldo no armazem/Endere�o : "+alltrim(cArm)+"/"+AllTrim(cEnd)+" em : "+DTOC(date())+" - "+time()+" hrs."+ _center
	cMensagem += "Equipamento Sendo Apontado : "+AllTrim(cimei)+ _center
	cMensagem += "OS : " + AllTrim(cos)+ _center
	cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +_center
	cTitemail:="Apontamento de Pe�as auditoria - Pe�as n�o apontadas por falta de saldo em estoque"
//	U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;fernando.luciano@bgh.com.br;nivea.goncalves@bgh.com.br;denise.marcelino@bgh.com.br;marcos.santos@bgh.com.br;PCP@bgh.com.br;fernando.medeiros@bgh.com.br;natalia.santos@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
	U_ENVIAEMAIL(cTitemail,"conspeca@bgh.com.br","",cMensagem,Path)
ElseIf !lsalest
    lReturn :=.f.
	Alert("O Partnumber : "+alltrim(cComp)+" selecionado nao tem saldo dispon�vel no armazem : "+alltrim(cArm)+ ". O apontamento n�o ser� realizado. Fale com seu superior")
	cMensagem := "Partnumber : "+alltrim(cComp)+"  N�o apontado (Pe�as auditoria) por falta de saldo no armazem : "+alltrim(cArm)+" em : "+DTOC(date())+" - "+time()+" hrs."+ _center
	cMensagem += "Equipamento Sendo Apontado : "+AllTrim(cimei)+ _center
    cMensagem += "OS : " + AllTrim(cos)+ _center
	cMensagem += "Usuario Apontando " + AllTrim(cUsername)  +_center
	cTitemail:="Apontamento de Pe�as auditoria - Pe�as n�o apontadas por falta de saldo em estoque"
//	U_ENVIAEMAIL(cTitemail,"LiderancaNextel@bgh.com.br;fernando.luciano@bgh.com.br;nivea.goncalves@bgh.com.br;denise.marcelino@bgh.com.br;marcos.santos@bgh.com.br;PCP@bgh.com.br;rodrigo.bazzo@bgh.com.br;edson.rodrigues@bgh.com.br","",cMensagem,Path)
	U_ENVIAEMAIL(cTitemail,"conspeca@bgh.com.br","",cMensagem,Path)
Endif
Return(lReturn)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EndBloq �Autor  �                     � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EndBloq(_cProduto,_cArmazem)
Local _aAreaAtu := GetArea()
cQuery := " SELECT "
cQuery += "		SUM(BF_QUANT) AS QTDBLQ "
cQuery += " FROM "+RetSqlName("SBF")+" AS SBF (nolock) "
cQuery += " INNER JOIN "+RetSqlName("SBE")+" AS SBE (nolock) ON "
cQuery += " 	BE_FILIAL='"+xFilial("SBE")+"' AND "
cQuery += "		BE_LOCAL=BF_LOCAL AND "
cQuery += "		BE_LOCALIZ=BF_LOCALIZ AND "
cQuery += "		BE_STATUS='3' AND "
cQuery += "		SBE.D_E_L_E_T_='' "
cQuery += " WHERE "
cQuery += "		BF_FILIAL='"+xFilial("SBF")+"' AND "
cQuery += "		BF_PRODUTO='"+_cProduto+"' AND "
cQuery += "		BF_LOCAL='"+_cArmazem+"' AND "
cQuery += "		BF_QUANT > 0  AND "
cQuery += "		SBF.D_E_L_E_T_='' "
If SELE("TRBSBF") <> 0
   dbSelectArea("TRBSBF")
   dbCloseArea()
EndIf   
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),"TRBSBF",.F.,.T.)
TcSetField("TRBSBF","QTDBLQ","N",14,2)
_nRet := TRBSBF->QTDBLQ
If SELE("TRBSBF") <> 0
   dbSelectArea("TRBSBF")
   dbCloseArea()
EndIf   
RestArea(_aAreaAtu)
Return _nRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GeraMov  �Autor  �                    � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraMov(lEnd,lRadioF)
Local aAreaAnt	:= GetArea()
Private aMovSD3		:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
//������������������������������������������Ŀ
//�Variaveis utilizadas pela funcao wmsexedcf�
//��������������������������������������������
Private aLibSDB	:= {}
Private aWmsAviso:= {}
dbSelectArea("SD3")
nSavReg     := RecNo()
cDoc		:= space(6)
cDoc    	:= IIf(Empty(cDoc),NextNumero("SD3",2,"D3_DOC",.T.),cDoc)
cDoc    	:= A261RetINV(cDoc)
dbSetOrder(2)
dbSeek(xFilial()+cDoc)
cMay := "SD3"+Alltrim(xFilial())+cDoc
While D3_FILIAL+D3_DOC==xFilial()+cDoc .Or.!MayIUseCode(cMay)
	If D3_ESTORNO # "S"
		cDoc := Soma1(cDoc)
		cMay := "SD3"+Alltrim(xFilial())+cDoc
	Endif
	dbSkip()
EndDo
aCab := {;
{"D3_DOC"		,cDoc			,NIL},;
{"D3_TM"		,"998"     		,NIL},;
{"D3_EMISSAO"	,dDataBase		,Nil}}
For i:=1 To Len(aItens)
	aadd(aMovSD3,{{"D3_COD"		,aItens[i,01],NIL},;
	{"D3_LOCAL"		,aItens[i,02],NIL},;
	{"D3_QUANT"		,aItens[i,03],NIL},;
	{"D3_SERVIC"	,cSerWms,NIL}})
Next i
If Len(aMovSD3) > 0 	
	MSExecAuto({|x,y| MATA241(x,y)},aCab,aMovSD3)
	If lMsErroAuto
		MostraErro()
		dbSelectArea("ZZ3")
		dbGoto(nRecZZ3)
		RecLock("ZZ3",.F.)
		dbDelete()
		MsUnLock()
		For x:=1 To Len(aItens)  
			dbSelectArea("SZ9")
			dbGoto(aItens[x,04])
			RecLock("SZ9",.F.)
			dbDelete()
			MsUnLock()
		Next x
	Else
		For x:=1 To Len(aItens)  
			dbSelectArea("SZ9")
			dbGoto(aItens[x,04])
			RecLock("SZ9",.F.)
			SZ9->Z9_NUMSEQE := 	cDoc
			MsUnLock()
		Next x
		aAreaDCF	:= DCF->(GetArea())
		aAreaDC5	:= DC5->(GetArea())
		cAliasNew	:= 'DCF'
		Default lRadioF := (GetMV('MV_RADIOF', .F., 'N')=='S') //-- Como Default o parametro MV_RADIOF e verificado
		dbSelectArea('SD3')
		dbSetOrder(2)
		dbSelectArea('DBN')
		dbSetOrder(1)
		dbSelectArea('DC5')
		dbSetOrder(1)
		dbSelectArea('DC6')
		dbSetOrder(1)
		dbSelectArea('DCF')
		//�������������������������������������������Ŀ
		//�Verificar data do ultimo fechamento em SX6.�
		//���������������������������������������������
		If If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES")) >= dDataBase
			Help (' ', 1, 'FECHTO')
			Return Nil
		Endif
		#IFDEF TOP
			cAliasNew := GetNextAlias()
			cQuery := " SELECT R_E_C_N_O_ RECNODCF FROM "+RetSqlName('DCF')
			cQuery += " WHERE "
			cQuery += " DCF_FILIAL = '"+xFilial("DCF")+"'"
			cQuery += " AND DCF_SERVIC = '"+cSerWms+"'"
			cQuery += " AND DCF_STSERV IN (' ','1')"
			cQuery += " AND DCF_DOCTO = '"+cDoc+"'"
			cQuery += " AND D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasNew,.F.,.T.)
		#Endif
		While (cAliasNew)->(!Eof()) .And. !lEnd
			DCF->(MsGoTo((cAliasNew)->RECNODCF))
			aAreaDCF := DCF->(GetArea())
			WmsExeDCF('1',.F.)
			(cAliasNew)->(dbSkip())
		EndDo
		WmsExeDCF('2')
		RestArea(aAreaDCF)
		RestArea(aAreaDC5)
		dbSelectArea(cAliasNew)
		dbCloseArea()
	Endif
Endif
RestArea(aAreaAnt)
Return lEnd
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EtqSep �Autor  �                      � Data �    /  /     ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EtqSep()
Local _aArea    := GetArea()
Local _cQuery   := ""
Local CR        := chr(13) + chr(10)
Local _aImpEtiq  := {}
_cQuery += CR + " SELECT DCF_DOCTO,DCF_NUMSEQ,DCF_CODPRO,B1_DESC,DCF_LOCAL,DCF_QUANT,DCF_QUANT,DCF_NUMSEQ,DCF_DATA,'2' TIPOFILT,Z9_NUMOS,Z9_USRINCL " 
_cQuery += CR + " FROM "+RetSqlName("DCF")+" AS DCF (nolock) "
_cQuery += CR + "    INNER JOIN "+RetSqlName("SB1")+" AS SB1 (nolock) "
_cQuery += CR + "    ON B1_FILIAL='"+XFILIAL("SB1")+"' AND DCF_CODPRO=B1_COD AND SB1.D_E_L_E_T_='' "
_cQuery += CR + "    INNER JOIN "+RetSqlName("SZ9")+" AS SZ9 (nolock) "
_cQuery += CR + "    ON Z9_FILIAL='"+XFILIAL("SZ9")+"' AND DCF_CODPRO=Z9_PARTNR AND DCF_DOCTO=Z9_NUMSEQE AND SZ9.D_E_L_E_T_='' "
_cQuery += CR + " WHERE DCF_FILIAL='"+XFILIAL("DCF")+"' AND DCF_DOCTO='"+cDoc+"' "
_cQuery += CR + " AND DCF.D_E_L_E_T_='' "
_cQuery += CR + " ORDER BY DCF_DOCTO,DCF_CODPRO,DCF_LOCAL "    
_cQuery := strtran(_cQuery, CR, "")
If Select("QRYETQ") > 0
	QRYETQ->(dbCloseArea())
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRYETQ",.T.,.T.)
TcSetField("QRYETQ","DCF_DATA" ,"D")
QRYETQ->(dbGoTop())
While !QRYETQ->(Eof())
    aAdd(_aImpEtiq, {QRYETQ->DCF_DOCTO,QRYETQ->DCF_NUMSEQ,QRYETQ->DCF_CODPRO,QRYETQ->B1_DESC,;
    QRYETQ->DCF_LOCAL,QRYETQ->DCF_QUANT,QRYETQ->DCF_QUANT,QRYETQ->DCF_NUMSEQ,QRYETQ->DCF_DATA,;
    QRYETQ->TIPOFILT,QRYETQ->Z9_NUMOS,QRYETQ->Z9_USRINCL})
    QRYETQ->(dbSkip())
EndDo
If Len(_aImpEtiq) > 0 
	U_impEtqswh(_aImpEtiq)
Endif
If Select("QRYETQ") > 0
	QRYETQ->(dbCloseArea())
Endif
RestArea(_aArea)
Return