#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัออออออออออหออออออัออออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma ณGVSFILE   บAutor ณHudson de Souza Santos      บData ณ03/08/15บฑฑ
ฑฑฬอออออออออุออออออออออสออออออฯออออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.    ณLista Laudos e NF de Entrada para envio ao GVS.              บฑฑ
ฑฑบ         ณPrametros: Emrpesa, Filial, Rotina Auto                      บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Especifico BGH                                              บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function GVSFile(aParam)
Local cQry			:= ""
Local cIDGVS		:= ""
Local nQtdOS		:= 0
Local nIdImg		:= 0
Local lAuto			:= .F.
Local _cASCCode		:= ""
Local _cWCNumber	:= ""
Local _cType		:= ""
Private oSoa
Default aParam := {"02", "02", .T.}
lAuto	:= aParam[3]
If lAuto
	PREPARE ENVIRONMENT EMPRESA  aParam[1] FILIAL aParam[2] TABLES "ZZ4","ZZ8","AC9","SB1"
EndIf
dbSelectArea("ZZ8")
dbSetOrder(2)


cQry := "SELECT " + CRLF
cQry += "	ZZ4.ZZ4_FILIAL		as FILIAL, " + CRLF
cQry += "	ZZ4.ZZ4_IMEI		as IMEI, " + CRLF
cQry += "	ZZ4.ZZ4_OS			as OSBGH, " + CRLF
cQry += "	IMG_VERSAO			as VERSAO, " + CRLF
cQry += "	IMG_IDIMAGEM		as IDIMAGEM, " + CRLF
cQry += "	'OSLAUDO'			as TIPO, " + CRLF
cQry += "	ZZ4_GVSOS			as OSGVS " + CRLF
cQry += "FROM "+RetSQLName("AC9")+" as AC9(NOLOCK) " + CRLF
cQry += "Inner join "+RetSQLName("ZZ4")+" as ZZ4(NOLOCK) " + CRLF
cQry += "	ON ZZ4.D_E_L_E_T_ = '' " + CRLF
cQry += "		AND ZZ4_OPEBGH in ('S05','S06','S08','S09') " + CRLF
cQry += "		AND ZZ4_FILIAL = AC9_FILENT " + CRLF
//cQry += "		AND ZZ4_OS = '9BGT44' " + CRLF
cQry += "		AND ZZ4_OS = substring(AC9_CODENT,1,6) " + CRLF
cQry += "Left join ImageScan..IMG020 as IMG " + CRLF
cQry += "	ON IMG.D_E_L_E_T_ = AC9.D_E_L_E_T_ COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF
cQry += "		AND IMG_OS = ZZ4_OS COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF
cQry += "		AND IMG_VERSAO = substring(AC9_CODENT,7,3) COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF
cQry += "Inner join "+RetSQLName("SB1")+" as SB1(NOLOCK) " + CRLF
cQry += "	ON SB1.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ " + CRLF
cQry += "		AND B1_COD = ZZ4_CODPRO " + CRLF
cQry += "Inner join "+RetSQLName("ZZ8")+" as ZZ8(NOLOCK) " + CRLF
cQry += "	ON ZZ8.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ " + CRLF
cQry += "		AND ZZ8_FILIAL = ZZ4_FILIAL " + CRLF
cQry += "		AND ZZ8_IMEI = ZZ4_IMEI " + CRLF
cQry += "		AND ZZ8_NUMOS= ZZ4_GVSOS " + CRLF
cQry += "		AND ZZ8_CODPRO = B1_MODELO " + CRLF
cQry += "WHERE AC9.D_E_L_E_T_ = '' " + CRLF
cQry += "	AND ZZ4_FILIAL = '02' " + CRLF
cQry += "	AND AC9_ENTIDA = 'ZZ3' " + CRLF
cQry += "	AND NOT(ZZ4_GVSOS in ('','000000')) " + CRLF
cQry += "	AND IMG_VERSAO > ZZ8_VERLAU COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF

cQry += "UNION ALL " + CRLF

cQry += "SELECT " + CRLF
cQry += "	ZZ4.ZZ4_FILIAL		as FILIAL, " + CRLF
cQry += "	ZZ4.ZZ4_IMEI		as IMEI, " + CRLF
cQry += "	ZZ4.ZZ4_OS			as OSBGH, " + CRLF
cQry += "	IMG.IMG_VERSAO		as VERSAO, " + CRLF
cQry += "	IMG.IMG_IDIMAGEM	as IDIMAGEM, " + CRLF
cQry += "	IMG_TIPO			as TIPO, " + CRLF
cQry += "	ZZ4_GVSOS			as OSGVS " + CRLF
cQry += "FROM [ImageScan]..[IMG020] as IMG(NOLOCK) " + CRLF
cQry += "Inner join "+RetSQLName("ZZ4")+" as ZZ4(NOLOCK) " + CRLF
cQry += "	ON ZZ4.D_E_L_E_T_ = '' " + CRLF
cQry += "		AND ZZ4.ZZ4_OS = IMG.IMG_OS COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF
//cQry += "		AND ZZ4.ZZ4_OS = '9BIP5R' " + CRLF
cQry += "		AND ZZ4.ZZ4_OPEBGH in ('S05','S06','S08','S09') " + CRLF
cQry += "Inner join "+RetSQLName("SB1")+" as SB1(NOLOCK) " + CRLF
cQry += "	ON SB1.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ " + CRLF
cQry += "		AND B1_COD = ZZ4_CODPRO " + CRLF
cQry += "Inner join "+RetSQLName("ZZ8")+" as ZZ8(NOLOCK) " + CRLF
cQry += "	ON ZZ8.D_E_L_E_T_ = ZZ4.D_E_L_E_T_ " + CRLF
cQry += "		AND ZZ8_FILIAL = ZZ4_FILIAL " + CRLF
cQry += "		AND ZZ8_IMEI = ZZ4_IMEI " + CRLF
cQry += "		AND ZZ8_NUMOS= ZZ4_GVSOS " + CRLF
cQry += "		AND ZZ8_CODPRO = B1_MODELO  " + CRLF
cQry += "WHERE NOT(ZZ4_GVSOS in ('',replicate('0',10))) " + CRLF
cQry += "	AND IMG.IMG_VERSAO > ZZ8_VERNFC COLLATE SQL_Latin1_General_CP1_CI_AS " + CRLF
cQry += "	AND IMG.IMG_TIPO = 'OSNF' " + CRLF
//cQry += "	AND 1=2 " + CRLF
cQry += "ORDER BY 1, 7, 6, 4 " + CRLF

If Select("IMAGE") <> 0
	dbSelectArea("IMAGE")
	dbCloseArea()
Endif
TCQUERY cQry NEW ALIAS "IMAGE"

dbSelectArea("IMAGE")
IMAGE->(dbGoTop())
While IMAGE->(!Eof())
	If nQtdOS = 0
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDefinindo objeto principal, que ficara com a conexao ativa.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cIDGVS := GVSLogin()
		If cIDGVS = Nil
			If nContEmail >= 100
				cMsgEmail := '<p><font face="Courier New" size="4" color="#4F81BD">Caros,<br /><br />'
				cMsgEmail += 'O Acesso ao m&eacute;todo Login do WebService WSServiceOrder n&atilde;o esta retornando se&ccedil;&atilde;o.<br />'
				cMsgEmail += 'Solicita&ccedil;&atilde;o efetuada em <strong>'
				cMsgEmail += DTOC(dDataBase)
				cMsgEmail += '</strong> &agrave;s <strong>'
				cMsgEmail += Time()
				cMsgEmail += '</strong>.<br />'
				cMsgEmail += 'Pe&ccedil;o que verifiquem.<br /><br />'
				cMsgEmail += 'No aguardo.</p>'
				U_ENVIAEMAIL("WSServiceOrder.asmx: Problemas comunica็ใo","erro.gvs@bgh.com.br","",cMsgEmail,"")
				nContEmail := 0
				Sleep(60000)
			Else
				nContEmail += 1
			EndIf
			Loop
		EndIf
	EndIf
	nQtdOS++

	_cASCCode	:= "7474"
	_cWCNumber	:= IMAGE->OSGVS
	_cType      := IMAGE->TIPO
	nIdImg		:= IMAGE->IDIMAGEM
	GVSIntegra(_cASCCode, _cWCNumber, _cType, nIdImg )

	CarregaRet(IMAGE->VERSAO, IMAGE->TIPO)
	IMAGE->(dbSkip())
EndDo

If lAuto
	RESET ENVIRONMENT
EndIf
Return(.T.)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัออออออออออหออออออัออออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma ณGVSLogin  บAutor ณHudson de Souza Santos      บData ณ06/08/15บฑฑ
ฑฑฬอออออออออุออออออออออสออออออฯออออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.    ณEfetua Login atraves do m้todo GVS "Login"                   บฑฑ
ฑฑบ         ณ                                                             บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Especifico BGH                                              บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GVSLogin()
oSoa:= WSWSServiceOrder():New()
oSoa:cASCCode  := "0000057685"
oSoa:cPassword := "X7F6H8"
oSoa:Login()
Return(oSoa:oWSgvsSession:cID)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัออออออออออหออออออัออออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma ณGVSIntegraบAutor ณHudson de Souza Santos      บData ณ06/08/15บฑฑ
ฑฑฬอออออออออุออออออออออสออออออฯออออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.    ณEnvia informa็๕es ao GVS baseado no ID do banco ImageScan.   บฑฑ
ฑฑฬอออออออออุอออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVariaveisณ_cASCCode  ณC๓digo do posto a que pretence a OS.             บฑฑ
ฑฑบ         ณ_cWCNumber ณDeve conter o n๚mero da Ordem de Servi็o rferenteบฑฑ
ฑฑบ         ณ           ณ a imagem enviada.                               บฑฑ
ฑฑบ         ณ_cType     ณ[OSNF]    Para notas fiscais                     บฑฑ
ฑฑบ         ณ           ณ[OSLAUDO] Para laudo t้cnico                     บฑฑ
ฑฑบ         ณnIdImg     ณId para gerar fragmenta็ใo                       บฑฑ
ฑฑฬอออออออออุอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบInfo     ณHandle     ณQuando for preenchido por "0" (zero) refere-se a บฑฑ
ฑฑบ         ณ           ณuma nova imagem, quando for preenchido com o Id  บฑฑ
ฑฑบ         ณ           ณgerado da nova imagem se trata de uma atualiza็ใoบฑฑ
ฑฑบ         ณ           ณda imagem.                                       บฑฑ
ฑฑบ         ณSeq        ณDeve ser informada a sequencia da imagem, cada OSบฑฑ
ฑฑบ         ณ           ณpode possuir mais de uma imagem.                 บฑฑ
ฑฑบ         ณFile       ณO HVC deve informar os parโmetros e a imagem em  บฑฑ
ฑฑบ         ณ           ณbinary a cada 64k                                บฑฑ
ฑฑฬอออออออออุอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Especifico BGH                                              บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GVSIntegra(_cASCCode, _cWCNumber, _cType, nIdImg)
Local nHandle	:= 0
Local nX		:= 0
Local cQryImg	:= ""
Local aFile		:= {}
Local cFile		:= ""
Local nSeqArq	:= 1

cQryImg := "EXEC ImageScan..spu__GENERATES_IMG @ID = " + Alltrim(STR(nIdImg)) + ", @TIPO = '" + Alltrim(_cType) + "'"
TcSqlExec(cQryImg)

Sleep(3000)

cQryImg := "SELECT ID, STEP, SQL_BASE64 FROM ImageScan..IMG_BASE64 ORDER BY ID, STEP ASC"
If Select("ARQUIVO") <> 0
	dbSelectArea("ARQUIVO")
	dbCloseArea()
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryImg),"ARQUIVO",.T.,.T.)
dbSelectArea("ARQUIVO")
ARQUIVO->(dbGoTop())
While ARQUIVO->(!Eof())
	If nSeqArq <> ARQUIVO->ID
		nSeqArq := ARQUIVO->ID
		aAdd(aFile,cFile)
		cFile := ""
	EndIf
	cFile += Alltrim(ARQUIVO->SQL_BASE64)
	ARQUIVO->(dbSkip())
EndDo

If !Empty(cFile)
	aAdd(aFile,cFile)
EndIf
ARQUIVO->(dbCloseArea())

For nX:= 1 to Len(aFile)
	oSoa:nHandle	:= nHandle
	oSoa:nSeq		:= nX
	oSoa:cASCCode	:= _cASCCode
	oSoa:cWCNumber	:= _cWCNumber
	oSoa:cType		:= Alltrim(_cType)
	oSoa:cFile		:= Alltrim(aFile[nX])
	oSoa:DataUploadFile()
	If oSoa:OWSDATAUPLOADFILERESULT:NRESULTCODE <> 0
		Exit
	EndIf

	nHandle := oSoa:OWSDATAUPLOADFILERESULT:NHANDLE
Next nX

Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัออออออออออหออออออัออออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma ณCarregaRetบAutor ณHudson de Souza Santos      บData ณ04/08/15บฑฑ
ฑฑฬอออออออออุออออออออออสออออออฯออออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.    ณCom retorno, alimenta ZZ8 para nใo enviar novamente.         บฑฑ
ฑฑบ         ณ                                                             บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Especifico BGH                                              บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaRet(_cVersao, _cTipo)
Local cResultMSG	:= oSoa:OWSDATAUPLOADFILERESULT:CRESULTMSG
Local nHandle		:= oSoa:OWSDATAUPLOADFILERESULT:NHANDLE
Local cResultCode	:= oSoa:OWSDATAUPLOADFILERESULT:NRESULTCODE
Local lOk			:= Iif(oSoa:OWSDATAUPLOADFILERESULT:NRESULTCODE<>0,.F.,.T.)
Local cOSGVS		:= AvKey(oSoa:cWCNumber,"ZZ8_NUMOS")
If lOk
	ZZ8->(dbGoTop())
	If ZZ8->(dbSeek(xFilial("ZZ8")+cOSGVS))
		RecLock("ZZ8", .F.)
		If Alltrim(_cTipo) == "OSLAUDO"
			ZZ8->ZZ8_VERLAU := _cVersao
		ElseIf Alltrim(_cTipo) == "OSNF"
			ZZ8->ZZ8_VERNFC := _cVersao
		EndIf
		MsUnlock()
	EndIf
EndIf
Return() 