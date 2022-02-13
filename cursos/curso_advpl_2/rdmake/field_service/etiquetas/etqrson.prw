#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ETQRSON  �Autor  � M.Munhoz - ERP PLUS� Data �  16/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para imprimir etiquetas de Entrada Massiva apos   ���
���          � ter confirmado a NFE.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ETQRSON()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Impress�o de etiquetas para a Entrada Massiva. "
Local cDesc1  := "Este programa tem o objetivo de imprimir as etiquetas de  "
Local cDesc2  := "Entrada Massiva ap�s a inclus�o da Nota Fiscal de Entrada."
Local cDesc3  := "Impressora T�rmica: Zebra "
Local cDesc4  := "Etiqueta: 22 x 88 mm "

Private cPerg := "ETQSON"
Private c2Perg:= "TPPRT"
Private nImp  := 0

C2SX1()
PERGUNTE(c2Perg,.T.) 
nImp := MV_PAR01

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )

//aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
   Return Nil
Endif

While Pergunte(cPerg,.T. )

	Processa( {|lEnd| ETQR001A(@lEnd)}, "Aguarde...","Gerando os dados para impress�o das etiquetas ...", .T. )

EndDo
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ETQR001A �Autor  � M.Munhoz - ERP PLUS� Data �  16/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ETQR001A(lEnd)

local _cQuery   := ""
local CR        := chr(13) + chr(10)
local _aImpEtq  := {}
local _nReg     := 0
local _aImpEtiq := {} 
private cPerg := "ETQSON"
Private lGrava	:= .F.
//��������������������������������������������������������������������������������������������������������Ŀ
//� Alterado por M.Munhoz em 16/08/2011 - query alterada para relacionar SD1 com o ZZ4 sem usar o D1_NUMSER�
//� e flagar o ZZ4_IMPETQ ao inves do D1_XIMPETQ.                                                          �
//����������������������������������������������������������������������������������������������������������
_cQuery += CR + " SELECT ZZ4_IMEI AS 'D1_NUMSER', LEFT(ZZ4_OS,6) ZZ4_OS, AB7_ITEM, D1_DOC, D1_SERIE, D1_COD, D1_DTDIGIT, D1_ITEM, D1.R_E_C_N_O_ REGSD1, D1_FORNECE, D1_LOJA, D1_XLOTE, "
_cQuery += CR + " ZZ4.REGZZ4, ZZ3_IMEISW, ZZ3_MODSW, ZZ4_IETRET  "
_cQuery += CR + " FROM   "+RetSqlName("SD1")+" AS D1 (nolock) "
_cQuery += CR + " JOIN   ( "
_cQuery += CR + " 	SELECT DISTINCT ZZ4_FILIAL, ZZ4_NFENR, ZZ4_NFESER, ZZ4_IMEI, ZZ4_CODCLI, ZZ4_LOJA, ZZ4_CODPRO, ZZ4_OS, ZZ4.R_E_C_N_O_ REGZZ4, ZZ4_ITEMD1,ZZ4_IETRET "
_cQuery += CR + " 	FROM "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery += CR + " 	WHERE ZZ4.D_E_L_E_T_ = '' "
_cQuery += CR + "         AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
_cQuery += CR + "         AND ZZ4_STATUS = '5' "
_cQuery += CR + "         AND ZZ4_IMEI   = '"+mv_par01+ "'  "
_cQuery += CR + " ) AS ZZ4 "
_cQuery += CR + " ON     ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4_CODCLI = D1_FORNECE AND ZZ4_LOJA = D1_LOJA AND ZZ4_CODPRO = D1_COD AND ZZ4_ITEMD1 = D1_ITEM  "
_cQuery += CR + " JOIN   "+RetSqlName("AB7")+" AS AB7 (nolock) "
_cQuery += CR + " ON     AB7_FILIAL = '"+xFilial("AB7")+"' AND AB7_NUMOS = LEFT(ZZ4_OS,6) AND AB7_NUMSER = ZZ4_IMEI AND AB7_CODPRO = D1_COD AND AB7_CODCLI = D1_FORNECE AND AB7_LOJA = D1_LOJA AND AB7.D_E_L_E_T_ = ''  "
_cQuery += CR + " LEFT JOIN   "+RetSqlName("ZZ3")+" AS ZZ3 (nolock) "
_cQuery += CR + " ON     ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND ZZ3_NUMOS = ZZ4_OS AND ZZ3_IMEI = ZZ4_IMEI AND ZZ3.D_E_L_E_T_ = ''  " 
_cQuery += CR + "        AND ZZ3_IMEISW <> ''  "
_cQuery += CR + " WHERE  D1.D_E_L_E_T_ = '' "
_cQuery += CR + "        AND D1_FILIAL = '"+xFilial("AB7")+"' "
_cQuery += CR + " ORDER BY D1_DOC, D1_SERIE, D1_ITEM "

//memowrite("ETQR001.SQL",_cQuery )

_cQuery := strtran(_cQuery, CR, "")

if Select("QRY") > 0
	QRY->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
TcSetField("QRY","D1_DTDIGIT"	,"D")

QRY->(dbGoTop())
if QRY->(eof()) .and. QRY->(bof())
	ApMsgInfo("Os par�metros informados retornaram um resultado vazio. Por favor, revise os par�metros ou contate o administrador do sistema.", "Etiquetas n�o geradas")
	return
endif

// Contagem de registros para a Regua
while !QRY->(eof())
	_nReg++
	QRY->(dbSkip())
enddo

// Inicializa a regua de evolucao
ProcRegua(_nReg)

QRY->(dbGoTop())
If !QRY->(eof()) 

	If Empty(QRY->ZZ4_IETRET)
		lGrava := .T.
	Else
		lRet := u_GerA0001( "Nextellider","Etiqueta j� gerada, contate seu supervisor para libera��o desta impress�o ! -> "+ZZ4->ZZ4_IETRET , .F.)
		If lRet
			lGrava := .T.
		EndIf
	EndIf
	
	If lGrava
		aAdd(_aImpEtiq, {QRY->D1_NUMSER, QRY->ZZ4_OS, QRY->AB7_ITEM, QRY->D1_DOC, QRY->D1_SERIE, QRY->D1_COD, QRY->D1_DTDIGIT, QRY->REGSD1, QRY->D1_FORNECE, QRY->D1_LOJA, QRY->D1_XLOTE, , , , , ,QRY->REGZZ4   , QRY->D1_ITEM   ,QRY->ZZ3_IMEISW, QRY->ZZ3_MODSW,U_GetDefSol(QRY->D1_NUMSER, QRY->ZZ4_OS),U_GetPec(QRY->D1_NUMSER, QRY->ZZ4_OS)})
	    If !Empty(QRY->ZZ3_IMEISW)
	    	aAdd(_aImpEtiq, {QRY->D1_NUMSER, QRY->ZZ4_OS, QRY->AB7_ITEM, QRY->D1_DOC, QRY->D1_SERIE, QRY->D1_COD, QRY->D1_DTDIGIT, QRY->REGSD1, QRY->D1_FORNECE, QRY->D1_LOJA, QRY->D1_XLOTE, , , , , ,QRY->REGZZ4   , QRY->D1_ITEM   ,QRY->ZZ3_IMEISW, QRY->ZZ3_MODSW,U_GetDefSol(QRY->D1_NUMSER, QRY->ZZ4_OS),U_GetPec(QRY->D1_NUMSER, QRY->ZZ4_OS)})
	    EndIf
    EndIf

EndIf

// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
if len(_aImpEtiq) > 0 
	U_EtqPRMass(_aImpEtiq,"",.F.,nImp)	
endif

If lGrava
	If Select("ZZ4") == 0
		DbSelectArea("ZZ4")
	EndIf
	ZZ4->(DbGoTo(QRY->REGZZ4))	
	If RecLock("ZZ4",.F.)
		ZZ4->ZZ4_IETRET := AllTrim(cUserName) +"("+ dToc(date())+" - "+Time()+")"	
		ZZ4->(MsUnlock())
	EndIf
EndIf

QRY->(dbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRIASX1  �Autor  �M.Munhoz - ERP PLUS � Data �  12/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para a criacao automatica das perguntas no SX1      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaSX1()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,'01','IMEI ?','IMEI ?','IMEI ?','mv_ch1','C',TamSX3("ZZ4_IMEI")[1],0,0,'G','','','','S','mv_par01','','','','','','','','','','','','','','','','')

Return Nil

Static Function C2SX1()
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Impressora","Impressora","Impressora","mv_ch1","N",01,0,0,"C","",""	,"",,"mv_par01","ZEBRA 200 DPI"	,"","","","ZEBRA 300 DPI"		,"","",""	,"","","","","","","","")

Return Nil
