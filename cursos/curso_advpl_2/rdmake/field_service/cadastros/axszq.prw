#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZQ    �Autor  � M.Munhoz           � Data �  13/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de visualizacao do LOG MCLAIM                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH - NEXTEL                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AXSZQ()

Local cAlias 		:= "SZQ"
Private cCadastro	:= "LOG MCLAIM"
Private aRotina	:= {}                

u_GerA0003(ProcName())

AADD(aRotina,{"Pesquisar"	,"AxPesqui",0,1})
AADD(aRotina,{"Visualizar"	,"AxVisual",0,2})
AADD(aRotina,{"Debitos"	,"u_LANDEBI1()",0,2})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZQ     �Autor  �Microsiga           � Data �  02/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LANDEBI1()
        
Local cPerg    := PADR("LANDEBI1",10)
Local bOk      := {|| .T.}
Local bCancel  := {|| oDlg:End() }

Private oDebito  	:= Nil 
Private _nDebito 	:= 0
Private aObjects    := {},aPosObj  :={}
Private aSize       := MsAdvSize()
Private aHeader     := {}
Private aCols       := {}
Private aIteMod     := {}

CriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return	
EndIf
     
//Calcula do total a faturar do MCLAIN
cQuery := " SELECT ISNULL(SUM(ZR_TPRICE),0) as TPRICE "
cQuery += " FROM "+RetSqlName("SZR")+"  "
cQuery += " WHERE D_E_L_E_T_ = ''  "
cQuery += " AND ZR_PEDIDO = ''  "
cQuery += " AND ZR_ANOMCL = '"+MV_PAR01+"'  "
cQuery += " AND ZR_MESMCL = '"+MV_PAR02+"'  "
cQuery += " AND ZR_FILIAL = '"+xFilial("SZR")+"'  "
cQuery += " AND ZR_STATUS = 'A' "

//���������������������������Ŀ
//�Verifica se o alias existe �
//�����������������������������
If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)

dbSelectArea("TSQL") 
TSQL->(dbGotop())

nTotal := TSQL->TPRICE

//Busca o valor do debita se j� digitado
dbSelectArea("SZR")
dbSetOrder(5)

If MsSeek(xFilial("SZR")+MV_PAR01+MV_PAR02+"D")
	_nDebito := SZR->ZR_DEBITO
EndIf

//Monta tela para lan�ar o valor de debito
aObjects	:= {}
aAdd( aObjects, {100,090, .t., .F.})
aAdd( aObjects, {100,100, .t., .T.})
aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )

//Ajustando tela as dimen��es do Munitor configurado
oDlg:= MSDialog():New( 000,000,aSize[4]-50,aSize[3]-120,"Debitos MCLAIN",,,.F.,,,,,,.T.,,,.T. )
oGrp1 := TGroup():New( aPosObj[1,1],aPosObj[1,2],aPosObj[2,3]-165,aPosObj[2,4]-400,"D�bitos",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ aPosObj[1,1]+40 ,015  SAY "Valor D�bito: " OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
@ aPosObj[1,1]+40 ,050  MSGET oDebito  VAR _nDebito  PICTURE "@E 999,999,999.99" SIZE 040,07 OF oGrp1 PIXEL WHEN .T.
                                                      
oFont 	:= TFont():New("Courier new",,-20,.T.,.T.)
oSayQtd := TSay():New(aPosObj[1,1]+10,aPosObj[1,1]+20,{|| "A Faturar:" + Transform(nTotal,"@E 999,999,999.99") },oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,400,60)

oTButton1 := TButton():New( 085, 065, "Confirmar",oDlg,{|| GrvSzr() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
oTButton2 := TButton():New( 085, 015, "Cancelar",oDlg,{|| oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

oDlg:Activate()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaSX1   �Autor  �D.FERNANDES         � Data �  01/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para criar as perguntas                             ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaSX1(cPerg)

//���������������������������������������������������������������������Ŀ
//|Declaracao de variaveis                                              �
//�����������������������������������������������������������������������
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Ano			    	?","","","mv_ch1","C",04,0,0,"G","","" ,"","","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Mes			    	?","","","mv_ch2","C",02,0,0,"G","","" ,"","","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Batch    	    	?","","","mv_ch3","C",01,0,0,"G","","" ,"","","mv_par03",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvSzr    �Autor  �D.FERNANDES         � Data �  01/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para gravar dados na SZR                            ���
�������������������������������������������������������������������������͹��
���Uso       � BGH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvSzr()

dbSelectArea("SZR")
dbSetOrder(5)

If MsSeek(xFilial("SZR")+MV_PAR01+MV_PAR02+"D")
	SZR->(RecLock("SZR",.F.))
	SZR->ZR_FILIAL := xFilial("SZR")
	SZR->ZR_STATUS := "D"
	SZR->ZR_DEBITO := _nDebito	
	SZR->ZR_OS 	   := "DEBITO"
	SZR->ZR_ANOMCL := MV_PAR01
	SZR->ZR_MESMCL := Val(MV_PAR02)
	SZR->(MsUnLock())	
Else                    

	cCodigo := GetSxeNum("SZR","ZR_CODIGO")
	
	SZR->(RecLock("SZR",.T.))
	SZR->ZR_CODIGO := cCodigo
	SZR->ZR_FILIAL := xFilial("SZR")
	SZR->ZR_STATUS := "D"
	SZR->ZR_DEBITO := _nDebito
	SZR->ZR_OS 	   := "DEBITO"
	SZR->ZR_ANOMCL := MV_PAR01
	SZR->ZR_MESMCL := Val(MV_PAR02)
	SZR->(MsUnLock())		 
	
	ConfirmSx8()
	
EndIf 

// Incluir mensagem do valor do credito - debito informado.

oDlg:End()

Return