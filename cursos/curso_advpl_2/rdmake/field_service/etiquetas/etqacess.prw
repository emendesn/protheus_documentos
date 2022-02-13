#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEtqAcess  บ Autor ณLuciano Siqueira    บ Data ณ  15/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA com acessorios informados na MASTER        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function EtqAcess()
Private oDlgAcess
Private _cNumEtq		:= Space(12)
DEFINE MSDIALOG oDlgAcess TITLE "Etiquetas Acessorios" FROM 0,0 TO 210,420 OF oDlgAcess PIXEL
@ 035,015 TO 070,180 LABEL "Master" PIXEL OF oDlgAcess
@ 045,025 GET _cNumEtq PICTURE "@!" 	SIZE 080,010 Valid EtqAces1(@_cNumEtq) Object ocodAcess
@ 080,140 BUTTON "Sai&r"       SIZE 036,012 ACTION oDlgAcess:End() OF oDlgAcess PIXEL
Activate MSDialog oDlgAcess CENTER
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEtqAces1  บ Autor ณLuciano Siqueira    บ Data ณ  15/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA DE ACESSORIOS DA MASTER                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function EtqAces1(_cNumEtq)
Local cPorta	:= "LPT1"
Local _aDados	:= {}
Local _cQry
Local _lRet		:= .F.
Local _aLin 	:= {04,09,18,20}
Local _aCol 	:= {05,25,45,65}
Private nqtdetq := 0
Private cUsado	:= ""
Private cOK		:= ""
Private cModelo	:= ""
Private cKit	:= ""
Private aEstru 	:= {}
Private nEstru 	:= 0
Private nX 		:= 1
_cNumEtq := TransForm(_cNumEtq,"@E 999999999999")
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
_cQry := " SELECT "
_cQry += "	max(ZZJ_QTDETM) as ZZJ_QTDETM, ZZ4_CODPRO, Z9_PARTNR, B1_DESC, Z9_SUCATA "
_cQry += " FROM " + RetSqlName("ZZ4") + " AS ZZ4  WITH(NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SZ9") + " AS SZ9  WITH(NOLOCK) ON "
_cQry += "	Z9_FILIAL='" + xFilial("SZ9") + "' AND "
_cQry += "	Z9_NUMOS=ZZ4_OS AND "
_cQry += "	Z9_IMEI=ZZ4_IMEI AND "
_cQry += "	Z9_SYSORIG='3' AND "
_cQry += "	SZ9.D_E_L_E_T_='' "
_cQry += " INNER JOIN " + RetSqlName("SB1") + " AS SB1  WITH(NOLOCK) ON "
_cQry += "	B1_FILIAL='" + xFilial("SB1") + "' AND "
_cQry += "	B1_COD=Z9_PARTNR AND "
_cQry += "	SB1.D_E_L_E_T_='' "
_cQry += " INNER JOIN " + RetSqlName("ZZJ") + " AS ZZJ WITH(NOLOCK) ON "
_cQry += "	ZZJ_FILIAL = '" + xFilial("ZZJ") + "' AND "
_cQry += "	ZZJ_OPERA = ZZ4_OPEBGH AND "
_cQry += "	ZZJ.D_E_L_E_T_='' "
_cQry += " WHERE "
_cQry += "	ZZ4_FILIAL='" + xFilial("ZZ4") + "' AND "
_cQry += "	ZZ4_ETQMAS = '" +_cNumEtq + "' AND "
_cQry += "	ZZ4.D_E_L_E_T_='' "
_cQry += " GROUP BY ZZ4_CODPRO, Z9_PARTNR, B1_DESC, Z9_SUCATA "
_cQry += " ORDER BY ZZ4_CODPRO, Z9_PARTNR, B1_DESC, Z9_SUCATA "
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("QRY")
dbGoTop()
If !EOF("QRY")
//	dbSelectArea("ZZJ")
//	ZZJ->(dbsetOrder(1))
//	ZZJ->(dbseek(xFilial("ZZJ")+ QRY->ZZ4_OPEBGH))

//	nqtdetq := ZZJ->ZZJ_QTDETM+1
	nqtdetq := QRY->ZZJ_QTDETM+1
	cUsado	:= IIF("-U"$ALLTRIM(QRY->ZZ4_CODPRO),"USADO","NOVO")
	cOK		:= "OK"
	cModelo	:= QRY->ZZ4_CODPRO

	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"WH")
	While SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == "WH"
		If ALLTRIM(SX5->X5_CHAVE)$ ALLTRIM(QRY->ZZ4_CODPRO)
			cKit := Left(SX5->X5_DESCRI,15)
			aEstru  := Estrut(ckIT)
			Exit
		EndIf
		SX5->(dbSkip())
	EndDo

	Do While nX <= Len(aEstru)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aEstru[nX,3])
		If SB1->B1_FANTASM == "S"
			aAdd(_aDados,{SB1->B1_COD, SB1->B1_DESC, "" })
		Endif
		nX++
	Enddo

	While !EOF("QRY")
		If QRY->Z9_SUCATA=="S"
			cOK		:= "NOK"
		Endif
		aAdd(_aDados,{QRY->Z9_PARTNR, QRY->B1_DESC, QRY->Z9_SUCATA })
		dbSelectArea("QRY")
		dbSkip()
	EndDo
Endif
QRY->(dbCloseArea())
If len(_aDados) > 0

	If !IsPrinter(cPorta)
		_cNumEtq:=SPACE(12)
		Return
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณProcessa impressao                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MSCBPRINTER("Z90XI",cPorta,,22,.F.,,,,,,.T.)
	MSCBCHKSTATUS(.F.)
	MSCBBEGIN(nqtdetq,6)
	MSCBSAY(_aCol[1],_aLin[1],"KIT - "+Alltrim(cModelo)+" - "+cUsado+space(2)+cOK ,"N","0","055,065")

	nLin := _aLin[2]
	For i:=1 to Len(_aDados)
		cSucata := IIF(_aDados[i,3]=="S","(SUCATA)","")
		MSCBSAY(_aCol[1],nLin,Alltrim(_aDados[i,1])+" - "+Substr(Alltrim(_aDados[i,2]),1,30)+space(2)+cSucata,"N","0","055,065")
		nLin += 5
	Next i
	MSCBEND()
	MSCBCLOSEPRINTER()
Endif
_cNumEtq:=SPACE(12)
Return()