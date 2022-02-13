#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"

#define ENTER chr(13) + chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BLQGAR01 � Autor �Paulo Lopez         � Data �  01/07/10   ���
�������������������������������������������������������������������������͹��
���Descricao �LIBERACAO DO BLOQUEIO DEVIDO AO SPECIAL PROJECT             ���
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

User Function BLQGAR01()

//������������������������������������������������������������������������Ŀ
//� Declaracoes das variaveis                                              �
//��������������������������������������������������������������������������
Private oDlgCgar
Private cIMEI  		:= space(TamSX3("ZZ4_IMEI")[1])//Space(15)
Private nTamNfe  	:= TAMSX3("D1_DOC")[1]
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut  	:= .F.                               //Usuarios Autorizado a entrar com Special Project
Private aArea    	:= GetArea()

u_GerA0003(ProcName())

//���������������������������������������������������������������������Ŀ
//� Valida acesso de usuario                                            �
//�����������������������������������������������������������������������
For i := 1 to Len(aGrupos)
	
	//Usuarios de Autorizado a entrar com NF-Compras
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Nexteladm"
		lUsrAut  := .T.
	EndIf
	
Next i

If !lUsrAut
	MsgAlert("Usuario nao autorizado a realizar essa opera��o !!")
	RestArea(aArea)
	Return
EndIf

//������������������������������������������������������������������������Ŀ
//� Definicao da janela e seus conteudos                                   �
//��������������������������������������������������������������������������
DEFINE MSDIALOG oDlgCgar TITLE "Consulta Garantia" FROM 0,0 TO 210,420 OF oDlgCgar PIXEL

@ 010,015 SAY   "Informe o IMEI para Consultar a Garantia." 	SIZE 150,008 PIXEL OF oDlgCgar
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlgCgar
@ 045,025 GET cIMEI PICTURE "@!" 	SIZE 080,010 Valid U_BLQGAR02(@cIMEI) Object ocodimei


//������������������������������������������������������������������������Ŀ
//� Botoes da MSDialog                                                     �
//��������������������������������������������������������������������������
@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgCgar:end())

Activate MSDialog oDlgCgar CENTER On Init ocodimei:SetFocus()

return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BLQGAR01 � Autor �Paulo Francisco     � Data �  26/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � LIBERACAO DO BLOQUEIO DEVIDO AO SPECIAL PROJECT            ���
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
User Function BLQGAR02(cIMEI)

//������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                    �
//��������������������������������������������������������������

Local oOk       := LoadBitmap(GetResources(), "LBOK")
Local oNo       := LoadBitmap(GetResources(), "LBNO")

//���������������������������������������������������������������������Ŀ
//| Matrizes de Dados                                                   �
//�����������������������������������������������������������������������

Private aHeader   	:= {}
Private aColumns  	:= {}
Private aItens    	:= {}
Private aHeader2  	:= {}
Private aColumns2 	:= {}
Private aItens2   	:= {}

//���������������������������������������������������������������������Ŀ
//� Conferencia Nf Cliente                                              �
//�����������������������������������������������������������������������

_oDlg     := Nil
_oOk      := LoadBitmap(GetResources(), "ENABLE")
_oNo      := LoadBitmap(GetResources(), "DISABLE")
_oCq      := LoadBitmap(GetResources(), "BR_LARANJA")
_lChk     := .F.

//���������������������������������������������������������������������Ŀ
//|Verifica parametro IMEI esta vazio                                   �
//�����������������������������������������������������������������������

CursorWait()

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

//��������������������������������������������������������������Ŀ
//| Montagem da Query                                            �
//����������������������������������������������������������������

cQry	:= "SELECT 	ZZ4_CODCLI  CODCLI, 	" + ENTER
cQry	+= "		ZZ4_LOJA  	LOJA,     	" + ENTER
cQry	+= "		ZZ4_IMEI  	IMEI,     	" + ENTER
cQry	+= "		ZZ4_CARCAC  CARCAC, 	" + ENTER
cQry	+= "		RTRIM(ZZ4_CODPRO) COD,	" + ENTER
cQry	+= "		RTRIM(B1_DESC)  PRODUT, " + ENTER
cQry	+= "		ZZ4_OS  	ORDSERV,    " + ENTER
cQry	+= "		ZZ4_NFENR  	NFE,     	" + ENTER
cQry	+= "		ZZ4_NFESER  SERIE,  	" + ENTER
cQry	+= "		ZZ4_STATUS  STATU, 		" + ENTER
cQry	+= "		ZZ4_NFEDT  	DTENTRA,	" + ENTER
cQry	+= "		ZZ4_OPEBGH 	OPERA, 		" + ENTER
cQry	+= "		ZZ4_GARANT  GARANT,     " + ENTER
cQry	+= "		ZA_NFCOMPR  NFCOMP, 	" + ENTER
cQry	+= "		ZA_SERNFC  	SERNFC, 	" + ENTER
cQry	+= "		ZA_DTNFCOM  DTCOMP, 	" + ENTER
cQry	+= "		ZA_CNPJNFC  CNPJNF, 	" + ENTER
cQry	+= "		ZA_CPFCLI  	CPFCLI  	" + ENTER
cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) " + ENTER
cQry	+= "LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
cQry	+= "ON (ZZ4_CODCLI = ZA_CLIENTE AND ZZ4_LOJA = ZA_LOJA AND ZZ4_CODPRO = ZA_CODPRO AND ZZ4_IMEI = ZA_IMEI  " + ENTER
cQry	+= "AND ZZ4_NFENR = ZA_NFISCAL AND ZZ4_NFESER = ZA_SERIE AND ZZ4_FILIAL = ZA_FILIAL AND SZA.D_E_L_E_T_ = '') " + ENTER
cQry	+= "INNER JOIN " + RetSqlName("SB1")  + " SB1 (nolock) " + ENTER
cQry	+= "ON(B1_FILIAL = '"+xFilial("SB1")+"' AND ZZ4_CODPRO = B1_COD AND SB1.D_E_L_E_T_ = '') " + ENTER
cQry	+= "WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " + ENTER
cQry	+= "AND ZZ4_IMEI  = '" + cIMEI + "' " + ENTER
cQry	+= "AND ZZ4.ZZ4_STATUS IN ('3','4') " + ENTER
cQry	+= "AND ZZ4.ZZ4_OPEBGH IN ('S03','N01','N02','N03','N04','N05','N09') " + ENTER
cQry	+= "AND ZZ4.ZZ4_GARANT = 'N' " + ENTER
cQry	+= "AND ZZ4.D_E_L_E_T_ = '' "  + ENTER

//MemoWrite("c:\garantia.sql", _cQry)
MemoWrite("c:\blqgar01.sql", cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)
TCSetField("QRY", "DTENTRA", "D")
TCSetField("QRY", "DTCOMP", "D")

QRY->(dbGoTop())

If  Empty(AllTrim(QRY->OPERA))
	CursorArrow()
	MsgStop("Caro Usuario IMEI nao Localizado")
	Return()
Endif

//��������������������������������������������������������������Ŀ
//| Grava dados no Array                                         �
//����������������������������������������������������������������
dbSelectArea("QRY")
dbGoTop()

While !EOF("QRY")
	
	aAdd(aItens,{QRY->CODCLI, QRY->LOJA, QRY->IMEI, QRY->CARCAC, QRY->PRODUT, QRY->ORDSERV, QRY->NFE, QRY->SERIE, QRY->STATU, QRY->DTENTRA, QRY->NFCOMP, QRY->SERNFC, QRY->DTCOMP, QRY->CNPJNF, QRY->CPFCLI, QRY->OPERA, QRY->COD, QRY->GARANT})
	
	dbSelectArea("QRY")
	dbSkip()
EndDo

QRY->(dbCloseArea())

//��������������������������������������������������������������Ŀ
//| Montagem da Query1                                           �
//����������������������������������������������������������������

/*_cQry	:= "SELECT 	ZZ4.ZZ4_CODCLI			CODCLI,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_LOJA  			LOJA,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_IMEI  			IMEI,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_CARCAC			CARCAC,	" + ENTER
_cQry	+= "		RTRIM(ZZ4.ZZ4_CODPRO)	COD,	" + ENTER
_cQry	+= "		RTRIM(SB1.B1_DESC)		PRODUT,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_DEFINF			COD_DEF, 	" + ENTER
_cQry	+= "		ZZG.ZZG_DESCRI			DESC_DEF,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_OS  			ORDSERV,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_NFENR  			NFE,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_NFESER			SERIE,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_STATUS			STATU,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_OPEBGH 			OPERA,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_GARANT			GARANT,	" + ENTER
_cQry	+= "		ZZ4.ZZ4_NFEDT  			DTENTRA, " + ENTER
_cQry	+= "		(SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	" + ENTER
_cQry	+= "		(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' GARACARC, " + ENTER
_cQry	+= "		DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	" + ENTER
_cQry	+= "						(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) MES_GARA	" + ENTER
_cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) " + ENTER
_cQry	+= "LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+= "ON (ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI  " + ENTER
_cQry	+= "AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_) " + ENTER
_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " SB1 (nolock) " + ENTER
_cQry	+= "ON(ZZ4.ZZ4_CODPRO = SB1.B1_COD) " + ENTER
_cQry	+= "INNER JOIN " + RetSqlName("ZZG") + " ZZG (nolock) " + ENTER
_cQry	+= "ON (ZZ4.ZZ4_DEFINF = ZZG.ZZG_CODIGO) " + ENTER
_cQry	+= "WHERE ZZ4.ZZ4_STATUS IN ('3','4') " + ENTER
_cQry	+= "AND ZZ4.ZZ4_GARANT = 'N' " + ENTER
_cQry	+= "AND ZZ4.ZZ4_OPEBGH IN ('S03','N02','N03','N04') " + ENTER
_cQry	+= "AND ZZ4.D_E_L_E_T_ = '' " + ENTER
_cQry	+= "AND ZZG.D_E_L_E_T_ = '' " + ENTER
_cQry	+= "AND ZZ4_CODPRO IN ('I776F','I776W','I776W-U','MPI776','MPI776-U','MPI776W','MPI776W-U') " + ENTER
_cQry	+= "AND ZZG.ZZG_CODIGO IN ('02084','02085','02087','02092','02134','02135') " + ENTER
_cQry	+= "AND DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	" + ENTER
_cQry	+= "					(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) BETWEEN '15' AND '20' " + ENTER
_cQry	+= "ORDER BY DTENTRA " + ENTER

MemoWrite("blqcar02.sql", _cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY1", .F., .T.)
TCSetField("QRY1", "DTENTRA", "D")
TCSetField("QRY1", "DTCOMP", "D")

QRY1->(dbGoTop())

//��������������������������������������������������������������Ŀ
//| Grava dados no Array1                                        �
//����������������������������������������������������������������
dbSelectArea("QRY1")
dbGoTop()

While !EOF("QRY1")

aAdd( aItens2,{QRY1->CODCLI, QRY1->LOJA, QRY1->IMEI, QRY1->CARCAC, QRY1->COD, QRY1->PRODUT, QRY1->COD_DEF, QRY1->DESC_DEF, QRY1->ORDSERV, QRY1->NFE, QRY1->SERIE, QRY1->DTENTRA, QRY1->GARACARC, QRY1->MES_GARA, QRY1->GARANT})

dbSelectArea("QRY1")
dbSkip()
EndDo

QRY1->(dbCloseArea())

*/
If len(aItens) == 0
	aAdd( aItens,{"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"})
EndIf

/*If len(aItens2) == 0
aAdd( aItens2,{"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"})
EndIf
*/

CursorArrow()

//���������������������������������������������������������������������Ŀ
//| Definicao do Dialog e seus conteudos                                �
//�����������������������������������������������������������������������
//���������������������������������������������������������������������Ŀ
//| Dialog                                                              |
//�����������������������������������������������������������������������
oDlg      := MSDialog():New( 088,232,725,927, cCadastro + " - " + "Libera��o Special Project ",,,.F.,,,,,,.T.,,,.T. )

//���������������������������������������������������������������������Ŀ
//|EnchoiceBar                                                          |
//�����������������������������������������������������������������������
oDlg:bInit := {||EnchoiceBar(oDlg,{||nOpc:=Iif(TudoOk(),1,0), Iif(nOpc==1,oDlg:End(),Nil), Iif(nOpc==1, FATX02GRV(nOpcao),Nil)},{|| oDlg:End()},.F.,{})}

//���������������������������������������������������������������������Ŀ
//|Cabecalho                                                            |
//�����������������������������������������������������������������������

oGrp1      := TGroup():New( 015,005,055,344,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 018,010,{||"Aten��o "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
oSay2      := TSay():New( 030,010,{||"Todos Aparelhos Descritos Abaixo Poder� ser Liberados para Entrada no Laborat�rio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,260,008)
oSay3      := TSay():New( 042,010,{||"Pelo Special Project Indicado. "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,088,008)

//���������������������������������������������������������������������Ŀ
//|Folders (Notas Fiscais # Creditos/Debitos)                           |
//�����������������������������������������������������������������������
//oFld1      := TFolder():New( 055,002,{"SPC0000433", "SPC0000434"},{},oDlg,,,,.T.,.F.,344,262,)
oFld1      := TFolder():New( 055,002,{" SPC0000457 / SPC0000476 / SPC0000515 / SPC0000520"},{},oDlg,,,,.T.,.F.,344,262,)
//���������������������������������������������������������������������Ŀ
//|Folder Notas Fiscais                                                 |
//�����������������������������������������������������������������������
oGrp2      := TGroup():New( 001,003,018,340,"",oFld1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

//oBtn1      := TButton():New( 004,005,"&SPC457"   	,oFld1:aDialogs[1],{||SPC457()},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 004,005,"&SPC457"   	,oFld1:aDialogs[1],{||SPC000("SPC0000457")},037,012,,,,.T.,,"",,,,.F. )
//oBtn2      := TButton():New( 004,040,"&SPC476"   	,oFld1:aDialogs[1],{||SPC476()},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 004,040,"&SPC476"   	,oFld1:aDialogs[1],{||SPC000("SPC0000476")},037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 004,075,"&SPC515"   	,oFld1:aDialogs[1],{||SPC000("SPC0000515")},037,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 004,110,"&SPC520"   	,oFld1:aDialogs[1],{||SPC000("SPC0000520")},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 004,150,"&Sair"		,oFld1:aDialogs[1],{|| oDlg:End()},037,012,,,,.T.,,"",,,,.F. )

//��������������������������������������������������������������Ŀ
//| Estrutura do Browse 1                                        �
//����������������������������������������������������������������
aAdd(aHeader , { "", "Cliente/Loja", "IMEI", "CARCA�A", "Produto", "O.S.", "Nota Fiscal", "Serie Nf-e", "Dt Entrada", "Nf. Compra", "Serie NfeComp.", "Data Compra", "CNPJ Nf Comp.","CPF Cliente"})
aAdd(aColumns, { 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40})

//�������������������������������������������������������������������������Ŀ
//� Desenha o MarkBrowse 1                                                  �
//���������������������������������������������������������������������������
oBrw:= TWBrowse():New(020,003,337,225,, aHeader[1], aColumns[1], oFld1:aDialogs[1],,,,,,,,,,,,,, .T.)
oBrw:SetArray(aItens)
oBrw:bLine := {|| {;
Iif(aItens[oBrw:nAt][18] == "N" , _oNo, _oCq),;
aItens[oBrw:nAt][01]+ " - " + aItens[oBrw:nAt][02],;
aItens[oBrw:nAt][03],;
aItens[oBrw:nAt][04],;
AllTrim(aItens[oBrw:nAt][17]) + " - " + AllTRim(aItens[oBrw:nAt][05]),;
aItens[oBrw:nAt][06],;
aItens[oBrw:nAt][07],;
aItens[oBrw:nAt][08],;
Transform(aItens[oBrw:nAt][10], "@E 99/99/99"),;
aItens[oBrw:nAt][11],;
aItens[oBrw:nAt][12],;
Transform(aItens[oBrw:nAt][13], "@E 99/99/99"),;
aItens[oBrw:nAt][14],;
aItens[oBrw:nAt][15],;
aItens[oBrw:nAt][16]}}

oBrw:lAdJustColSize := .T.
oBrw:lColDrag       := .T.
oBrw:lMChange       := .T.
oBrw:lHScroll       := .T.

//���������������������������������������������������������������������Ŀ
//|Folder Creditos/Debitos                                              |
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//|Cabecalho 2                                                          |
//�����������������������������������������������������������������������
//oGrp3      := TGroup():New( 001,003,018,340,"",oFld1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )

//oBtn1      := TButton():New( 004,005,"&Liberar"   	,oFld1:aDialogs[2],{||Liberar2()},037,012,,,,.T.,,"",,,,.F. )
//oBtn2      := TButton():New( 004,040,"&Sair"		,oFld1:aDialogs[2],{|| oDlg:End()},037,012,,,,.T.,,"",,,,.F. )

//��������������������������������������������������������������Ŀ
//| Estrutura do MarkBrowse 2                                    �
//����������������������������������������������������������������
//aAdd(aHeader2 , { "", "Cliente/Loja", "IMEI", "CARCA�A", "Cod/Produto", "Cod/Def.","O.S.", "NF/Serie", "Dt. Entrada","Gar. Carca�a","Periodo"})
//aAdd(aColumns2, { 2, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40})

//�������������������������������������������������������������������������Ŀ
//� Desenha o MarkBrowse 2.                                                 �
//���������������������������������������������������������������������������
/*oBrw2:= TWBrowse():New(020,003,337,225,, aHeader[1], aColumns[1], oFld1:aDialogs[2],,,,,,,,,,,,,, .T.)
oBrw2:SetArray(aItens2)
oBrw2:bLine := {|| {;
Iif(aItens2[oBrw2:nAt][09] == "0" , _oNo, _oCq),;
aItens2[oBrw2:nAt][01]+ " - " + aItens2[oBrw2:nAt][02],;
aItens2[oBrw2:nAt][03],;
aItens2[oBrw2:nAt][04],;
AllTrim(aItens2[oBrw2:nAt][05]) + " - " + AllTrim(aItens2[oBrw2:nAt][06]),;
aItens2[oBrw2:nAt][07] + " - " + aItens2[oBrw2:nAt][08],;
aItens2[oBrw2:nAt][09],;
aItens2[oBrw2:nAt][10] + " - " + aItens2[oBrw2:nAt][11],;
aItens2[oBrw2:nAt][12],;
aItens2[oBrw2:nAt][13],;
aItens2[oBrw2:nAt][14],;
aItens2[oBrw2:nAt][15]}}

oBrw2:lAdJustColSize := .T.
oBrw2:lColDrag       := .T.
oBrw2:lMChange       := .T.
oBrw2:lHScroll       := .T. */

oDlg:Activate(,,,.T.)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SPC457   � Autor �Paulo Francisco     � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � GRAVACAO DA LIBERACAO ACIMA DETERMINADA                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���07/08/2012�Marcelo Munhoz    �Adaptacao da funcao para utilizar o      ���
���          �                  �codigo do SPC como parametro.            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//Static Function SPC457()
Static Function SPC000(_cSPC)

Local _cQry
Local cQryExec
Local _cQryGaran

// Ticket 6361 - Marcelo Munhoz - 04/06/2012 - Bloqueia o apontamento de SPC de acordo com a operacao do IMEI
//if !u_PermitSPC(aItens[1,16], "2", "SPC0000457")
if !u_PermitSPC(aItens[1,16], "2", _cSPC)
	return()
endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+=" WHERE ZA_CLIENTE = '" + aItens[01][01] + "' " + ENTER
_cQry	+=" AND ZA_LOJA = '" + aItens[01][02] + "' " + ENTER
_cQry	+=" AND ZA_NFISCAL = '" + aItens[01][07] + "' " + ENTER
//_cQry	+=" AND ZA_SERIE = '" + aItens[01][08] + "' " + ENTER
_cQry	+=" AND ZA_IMEI = '" + aItens[01][03] + "' " + ENTER
//_cQry	+=" AND ZA_CODPRO = '" + aItens[01][17] + "' " + ENTER
_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER

MemoWrite("blqgar03.sql", _cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

If Empty(QRY->CLIENTE)
	
    // Corrigido por Marcelo Munhoz em 07/08/2012 - O fonte estava alterando o registro posicionado de forma errada. 
    // O correto seria incluir um registro novo quando nao for encontrado o IMEI + NFISCAL + CLIENTE no SZA, como esta feito agora.
//	RecLock("SZA",.F.)
	RecLock("SZA",.T.) 
	
	SZA->ZA_FILIAL 	:= "02"
	SZA->ZA_CLIENTE	:= aItens[01][01]
	SZA->ZA_LOJA 	:= aItens[01][02]
	SZA->ZA_NFISCAL	:= aItens[01][07]
	SZA->ZA_SERIE 	:= aItens[01][08]
	SZA->ZA_EMISSAO	:= aItens[01][10]
	SZA->ZA_DATA 	:= aItens[01][10]
	SZA->ZA_IMEI 	:= aItens[01][03]
	SZA->ZA_CODPRO 	:= aItens[01][17]
	SZA->ZA_STATUS 	:= "V"
//	SZA->ZA_SPC 	:= "SPC0000457"
	SZA->ZA_SPC 	:= _cSPC
	SZA->ZA_NOMUSER	:= "Y"+AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
	
	msunlock()
Else
	cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
//	cQryExec += "SET ZA_SPC = 'SPC0000457', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
	cQryExec += "SET ZA_SPC = '"+_cSPC+"', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
	cQryExec += "WHERE ZA_CLIENTE = '" + aItens[01][01] + "' " + ENTER
	cQryExec += "AND ZA_LOJA = '" + aItens[01][02] + "' " + ENTER
	cQryExec += "AND ZA_NFISCAL = '" + aItens[01][07] + "' " + ENTER
	//cQryExec += "AND ZA_SERIE = '" + aItens[01][08] + "' " + ENTER
	cQryExec += "AND ZA_IMEI = '" + aItens[01][03] + "' " + ENTER
	
	TcSQlExec(cQryExec)
	TCRefresh(RETSQLNAME("SZA"))
Endif

_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
_cQryGaran += " SET ZZ4_GARANT = 'S' " + ENTER
_cQryGaran += " WHERE ZZ4_CODCLI = '" + aItens[01][01] + "' " + ENTER
_cQryGaran += " AND ZZ4_LOJA = '" + aItens[01][02] + "' " + ENTER
_cQryGaran += " AND ZZ4_IMEI = '" + aItens[01][03] + "' " + ENTER
_cQryGaran += " AND ZZ4_CARCAC = '" + aItens[01][04] + "' " + ENTER
_cQryGaran += " AND ZZ4_OS  = '" + aItens[01][06] + "' " + ENTER
_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
_cQryGaran += " AND ZZ4_GARANT = 'N' " + ENTER

MemoWrite("blqgar04.sql", _cQryGaran)
TcSQlExec(_cQryGaran)
TCRefresh(RETSQLNAME("ZZ4"))

//MsgAlert("Gravado Com sucesso SPC0000457 !!!")
MsgAlert("Gravado Com sucesso "+_cSPC+" !!!")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SPC476   � Autor �Paulo Francisco     � Data �  30/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � GRAVACAO DA LIBERACAO ACIMA DETERMINADA                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���07/08/2012�Marcelo Munhoz    �Funcao eliminada com a adaptacao da      ���
���          �                  �funcao SPC000 para o SPC como parametro. ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function SPC476()

Local _cQry
Local cQryExec
Local _cQryGaran

// Ticket 6361 - Marcelo Munhoz - 04/06/2012 - Bloqueia o apontamento de SPC de acordo com a operacao do IMEI
if !u_PermitSPC(aItens[1,16], "2", "SPC0000476")
	return()
endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+=" WHERE ZA_CLIENTE = '" + aItens[01][01] + "' " + ENTER
_cQry	+=" AND ZA_LOJA = '" + aItens[01][02] + "' " + ENTER
_cQry	+=" AND ZA_NFISCAL = '" + aItens[01][07] + "' " + ENTER
_cQry	+=" AND ZA_SERIE = '" + aItens[01][08] + "' " + ENTER
_cQry	+=" AND ZA_IMEI = '" + aItens[01][03] + "' " + ENTER
_cQry	+=" AND ZA_CODPRO = '" + aItens[01][17] + "' " + ENTER
_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER

MemoWrite("blqgar03.sql", _cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

If Empty(QRY->CLIENTE)
	
	RecLock("SZA",.F.)
	
	SZA->ZA_FILIAL 	:= "02"
	SZA->ZA_CLIENTE	:= aItens[01][01]
	SZA->ZA_LOJA 	:= aItens[01][02]
	SZA->ZA_NFISCAL	:= aItens[01][07]
	SZA->ZA_SERIE 	:= aItens[01][08]
	SZA->ZA_EMISSAO	:= aItens[01][10]
	SZA->ZA_DATA 	:= aItens[01][10]
	SZA->ZA_IMEI 	:= aItens[01][03]
	SZA->ZA_CODPRO 	:= aItens[01][17]
	SZA->ZA_STATUS 	:= "V"
	SZA->ZA_SPC 	:= "SPC0000476"
	SZA->ZA_NOMUSER	:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
	
	msunlock()
Else
	cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
	cQryExec += "SET ZA_SPC = 'SPC0000476', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
	cQryExec += "WHERE ZA_CLIENTE = '" + aItens[01][01] + "' " + ENTER
	cQryExec += "AND ZA_LOJA = '" + aItens[01][02] + "' " + ENTER
	cQryExec += "AND ZA_NFISCAL = '" + aItens[01][07] + "' " + ENTER
	cQryExec += "AND ZA_SERIE = '" + aItens[01][08] + "' " + ENTER
	cQryExec += "AND ZA_IMEI = '" + aItens[01][03] + "' " + ENTER
	
	TcSQlExec(cQryExec)
	TCRefresh(RETSQLNAME("SZA"))
Endif

_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
_cQryGaran += " SET ZZ4_GARANT = 'S' " + ENTER
_cQryGaran += " WHERE ZZ4_CODCLI = '" + aItens[01][01] + "' " + ENTER
_cQryGaran += " AND ZZ4_LOJA = '" + aItens[01][02] + "' " + ENTER
_cQryGaran += " AND ZZ4_IMEI = '" + aItens[01][03] + "' " + ENTER
_cQryGaran += " AND ZZ4_CARCAC = '" + aItens[01][04] + "' " + ENTER
_cQryGaran += " AND ZZ4_OS  = '" + aItens[01][06] + "' " + ENTER
_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
_cQryGaran += " AND ZZ4_GARANT = 'N' " + ENTER

MemoWrite("blqgar04.sql", _cQryGaran)
TcSQlExec(_cQryGaran)
TCRefresh(RETSQLNAME("ZZ4"))

MsgAlert("Gravado Com sucesso SPC0000476 !!!")

Return
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PERMITSPC �Autor  � M.Munhoz           � Data �  22/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio de apontamento de SPC de acordo com a operacao.   ���
���          � Exclusivo para Nextel                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function PermitSPC(_cOper, _cLab, _cSPC)

local _lRet     := .f.
local _aAreaZZJ := ZZJ->(getarea())

if !empty(_cOper)

	ZZJ->(dbSetOrder(1)) // ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB

	If  ZZJ->(dbseek(xFilial("ZZJ")+_cOper+_cLab)) .and. alltrim(_cSPC) $ ZZJ->ZZJ_SPC
		_lRet := .t.
	else
		if empty(ZZJ->ZZJ_SPC)
			apMsgStop("Caro Usu�rio, a opera��o deste IMEI ("+_cOper+") n�o permite apontamento de SPC.","SPC n�o permitido")
		else
			apMsgStop("Caro Usu�rio, a opera��o deste IMEI ("+_cOper+") n�o permite o SPC "+_cSPC+". Favor verificar.","SPC inv�lido")
		endif
	Endif

endif

restarea(_aAreaZZJ)
	
return(_lRet)
