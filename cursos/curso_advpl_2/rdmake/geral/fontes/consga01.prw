#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "HBUTTON.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "APWIZARD.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA01 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA GARANTIA CONFORME NOTA FISCAL CLIENTE              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONSGA01()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes das variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oDlgCgar
Private cIMEI  		:= Space(TamSX3("ZZ4_IMEI")[1])
Private nTamNfe  	:= TAMSX3("D1_DOC")[1]
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut  	:= .F.                             	 //Usuarios de Autorizado a entrar com NF-Compras
Private lUsrAdm		:= .F.								 //Usuarios de Autorizado a entrar com NF-Compras
Private _cSpc		:= GetMv("MV_SPC0434") 				 // Aparelhos Parametrizados para Especifico SPC0000434 - Motorola
Private _cPsp		:= GetMv("MV_PERSPC0") 				 // Periodo Parametrizados para Especifico SPC0000434 - Motorola
Private _cSpt		:= GetMv("MV_DTFSPC2") 				 // Data Final Parametrizados para Especifico SPC0000434 - Motorola
Private _cSpr		:= GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _cPsq		:= GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSps		:= GetMv("MV_DEFESPC") 				 // Defeitos Parametrizados para Especifico SPC0000433 - Motorola
Private _cNft		:= GetMv("MV_PERNFTR") 				 // Periodo Parmetrizado para Nf de Troca
Private cPerg       := "CONSG01"
Private lCheck 		:= .T.
Private _cnotdefc   := GetMv("MV_NOTDEFC")           
Private _lspc433    := .F.
u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado a entrar com NF-Compras
	If AllTrim(GRPRetName(aGrupos[i])) $ "Administradores#Nextellider"
		lUsrAut  := .T.
	EndIf
Next i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da janela e seus conteudos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgCgar TITLE "Consulta Garantia" FROM 0,0 TO 210,420 OF oDlgCgar PIXEL
@ 010,015 SAY   "Informe o IMEI para Consultar a Garantia." 	SIZE 150,008 PIXEL OF oDlgCgar
@ 035,015 TO 070,180 LABEL "IMEI" PIXEL OF oDlgCgar
@ 045,025 GET cIMEI PICTURE "@!" 	SIZE 080,010 Valid U_CONSGA02(@cIMEI) Object ocodimei
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botoes da MSDialog                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  PIXEL ACTION (oDlgCgar:end())
Activate MSDialog oDlgCgar CENTER On Init ocodimei:SetFocus()
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA02 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³GERA CAMPOS COM ATRIBUTOS PARA ATUALIZAÇÃO                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONSGA02(cIMEI)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Variaveis do sistema                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg
Local _cQry
Local cQryExec
Private _aHeader  	:= {}
Private _aColumns 	:= {}
Private _aDados	 	:= {}
Private _cBrow
Private _cMesGa
Private _cMesCo
Private _cBounc
Private _nNftro
Private _nDefcl
Private _nDescr
Private _cGarS		:= .F.
Private _cGarT		:= .F.
Private _cGarA		:= .F.
Private _cGarU		:= .F.
Private _lRet 		:= .F.
Private _cImpGa		:= .T.
Private _cUser
Private _cMesAt
oFont   := tFont():New("Tahoma",,-20,.T.,.T.) // 5o. Parâmetro negrito
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conferencia Nf Cliente                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oDlg     	:= Nil
_oOk      	:= LoadBitmap(GetResources(), "ENABLE")
_oNo      	:= LoadBitmap(GetResources(), "DISABLE")
_oCq      	:= LoadBitmap(GetResources(), "BR_AMARELO")
_oCp      	:= LoadBitmap(GetResources(), "BR_PINK")
_oCr      	:= LoadBitmap(GetResources(), "BR_AZUL")
_oCc      	:= LoadBitmap(GetResources(), "BR_CANCEL")
_lChk     	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Verifica parametro IMEI esta vazio                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cIMEI)
	AjusTran(cIMEI)
	GravDef(cIMEI)
	CursorWait()
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Montagem da Query Calcula Garantia para Special Project             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQry	:= "SELECT "
	_cQry	+= "ZZ4.ZZ4_CODCLI				as CODCLI, "
	_cQry	+= "ZZ4.R_E_C_N_O_				as REGZZ4, "
	_cQry	+= "SA1.A1_EST					as EST, "
	_cQry	+= "ZZ4.ZZ4_LOJA  				as LOJA, "	 
	_cQry	+= "ZZ4.ZZ4_IMEI  				as IMEI, "
	_cQry	+= "ZZ4.ZZ4_CARCAC				as CARCAC, "
	_cQry	+= "RTRIM(ZZ4.ZZ4_CODPRO)		as COD, "
	_cQry	+= "RTRIM(SB1.B1_DESC)			as PRODUT,
	_cQry	+= "ZZ4.ZZ4_OS  				as ORDSERV, "
	_cQry	+= "ZZ4.ZZ4_NFENR  				as NFE, "
	_cQry	+= "ZZ4.ZZ4_NFESER				as SERIE, "
	_cQry	+= "ZZ4.ZZ4_STATUS				as STATU, "
	_cQry	+= "ZZ4.ZZ4_NFEDT  				as DTENTRA, "
	_cQry	+= "ZZ4.ZZ4_OPEBGH 				as OPERAC, "
	_cQry	+= "ZZ4.ZZ4_GARANT				as GARANT, "
	_cQry	+= "ZZ4.ZZ4_BOUNCE				as BOUNCE, "
	_cQry	+= "SZA.ZA_GARNFC				as GARNFC, "
	_cQry	+= "SZA.ZA_GARNFT				as GARNFT, "
	_cQry	+= "SZA.ZA_NFCOMPR				as NFCOMP, "
	_cQry	+= "SZA.ZA_SERNFC  				as SERNFC, "
	_cQry	+= "SZA.ZA_DTNFCOM				as DTCOMP, "
	_cQry	+= "SZA.ZA_CNPJNFC				as CNPJNFC, "
	_cQry	+= "SZA.ZA_NFTROCA				as NFTROC, "
	_cQry	+= "SZA.ZA_SERNFTR				as SERNFT, "
	_cQry	+= "SZA.ZA_DTNFTRO				as DTTROC, "
	_cQry	+= "SZA.ZA_CNPJNFT				as CNPJNFT, "
	_cQry	+= "SZA.ZA_CPFCLI  				as CPFCLI, "
	_cQry	+= "ZZ4.ZZ4_DEFINF				as Z4_DEFI, "
	_cQry	+= "SZA.ZA_DEFRECL				as DEFEITO, "
	_cQry	+= "ISNULL(SZA.ZA_SPC,0)		as SPC, "
	_cQry	+= "ISNULL(SZA.ZA_NOMUSER,0)	as NOMUSER, "
	_cQry	+= "ZZG.ZZG_DESCRI				as DESCRIC, "
	_cQry	+= "ZZG1.ZZG_DESCRI				as DESCRIC1, "
	_cQry	+= "convert(varchar(10),convert(date,ZZ4.ZZ4_EMDT),103) as ENTMAS, "
	_cQry	+= "RTRIM(WC.X5_DESCRI)+LEFT(WD.X5_DESCRI,2)+'01' as GARACARC, "
	_cQry	+= "DATEDIFF(MONTH, RTRIM(WC.X5_DESCRI)+LEFT(WD.X5_DESCRI,2)+'01',ZZ4.ZZ4_NFEDT) as MES_GARA, "
	_cQry	+= "DATEDIFF(MONTH, SZA.ZA_DTNFCOM ,ZZ4.ZZ4_NFEDT) as MES_GCOM, "
	_cQry	+= "CONVERT (VARCHAR (10),DATEADD(MONTH, 12,SZA.ZA_DTNFCOM),112) as DTFIMGAR "
	_cQry	+= "FROM " + RetSqlName("ZZ4") + " as ZZ4(NOLOCK) "
	_cQry	+= "LEFT JOIN " + RetSqlName("SZA") + " as SZA(NOLOCK) "
	_cQry	+= "ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA"
	_cQry	+= " AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL "
	_cQry	+= "AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND SZA.D_E_L_E_T_ = '') "
	_cQry	+= "INNER JOIN " + RetSqlName("SB1") + " as SB1(NOLOCK) "
	_cQry	+= "ON(ZZ4.ZZ4_CODPRO = SB1.B1_COD AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = '') "
	_cQry	+= "INNER JOIN " + RetSqlName("SA1") + " as SA1(NOLOCK) "
	_cQry	+= "ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_ = '') "
	_cQry	+= "LEFT JOIN " + RetSqlName("ZZG") + " as ZZG1(NOLOCK) "
	_cQry	+= "ON(ZZG1.ZZG_FILIAL = '"+xFilial("ZZG")+"' AND ZZ4.ZZ4_DEFINF = ZZG1.ZZG_CODIGO AND ZZG1.D_E_L_E_T_ = '') "
	_cQry	+= "LEFT JOIN " + RetSqlName("ZZG") + " as ZZG(NOLOCK) "
	_cQry	+= "ON (ZZG.ZZG_FILIAL = '"+xFilial("ZZG")+"' AND SZA.ZA_DEFRECL = ZZG.ZZG_CODIGO AND ZZG.D_E_L_E_T_ = '') "
	_cQry	+= "LEFT JOIN " + RetSqlName("SX5") + " as WC "
	_cQry	+= "ON (WC.D_E_L_E_T_ = '' AND WC.X5_FILIAL = '' AND WC.X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = WC.X5_CHAVE) "
	_cQry	+= "LEFT JOIN " + RetSqlName("SX5") + " as WD "
	_cQry	+= "ON (WD.D_E_L_E_T_ = '' AND WD.X5_FILIAL = '' AND WD.X5_TABELA = 'WD' AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = WD.X5_CHAVE) "
	_cQry	+= "WHERE ZZ4.ZZ4_FILIAL = '" + xFilial("ZZ4") + "' "
	_cQry	+= "AND ZZ4.ZZ4_IMEI = '" + cIMEI + "' "
	_cQry	+= "AND	ZZ4.ZZ4_STATUS IN ('3','4') "
	_cQry	+= "AND ZZ4.D_E_L_E_T_ = '' "
	MemoWrite("c:\garantia.sql", _cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	TCSetField("QRY", "DTENTRA", "D")
	TCSetField("QRY", "DTCOMP",  "D")
	TCSetField("QRY", "DTTROC",  "D")
	TCSetField("QRY", "GARACARC",  "D")
	QRY->(dbGoTop())
	If  Len (AllTrim(QRY->OPERAC)) <= 0
		CursorArrow()
		MsgStop("Caro Usuario IMEI 	Não Localizado")
		Return()
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Grava SPC0000433 Conforme Parametros Determinados.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(AllTrim(QRY->SPC)) <= 1
		//U_PROREPA(QRY->IMEI,QRY->ORDSERV,'2')
		U_CONSGA09(QRY->IMEI,QRY->ORDSERV)
	EndIf
	_cMesGa := QRY->MES_GARA
	_cMesCo := QRY->MES_GCOM
	_nNftro := QRY->NFTROC
	If !Empty(AllTrim(QRY->Z4_DEFI))
		_nDefcl	:= AllTrim(QRY->Z4_DEFI)
		_nDescr	:= AllTrim(QRY->DESCRIC1)
	Else
		_nDefcl	:= AllTrim(QRY->DEFEITO)
		_nDescr	:= AllTrim(QRY->DESCRIC)
	EndIf
	_nDefre	:= Posicione("ZZG", 1, xFilial("ZZG") + "2" + AllTrim(_nDefcl), "ZZG_RECCLI")
	_nDefcr	:= (AllTrim(_nDefre) $ "C0022")
	// Filtro para Special Project SPC0000434
	_cGarS  := AllTrim(QRY->COD) $ _cSpc .And. Transform (QRY->MES_GCOM, "@E 99") $ ( _cPsp)  .And. _nDefcr == .F. .And.;
										!Empty(_nDefcl) .And. AllTrim(QRY->GARACARC) <= _cSpt .And. QRY->GARANT == "N"
	// Filtro para Special Project SPC0000433 Operação N02
	_cGarU  := AllTrim(QRY->COD) $ _cSpr .And. Transform (QRY->MES_GCOM, "@E 99") $ ( _cPsq)  .And. QRY->GARANT == "N" .And.;
										AllTrim(QRY->OPERAC) $ "N02"
	_cGarA  := QRY->GARANT == "S" 
	_cGarR	:= _lRet .OR. AllTrim(QRY->SPC) == "SPC0000433"  // Filtro para Special Project SPC0000433
	_cBounc := StrZero(QRY->BOUNCE, 3)
	_cUser	:= Len(AllTrim(QRY->NOMUSER)) > 1
	_cMesAt	:= QRY->GARACARC

	// Filtro para ativar Nf de Troca / Reparo / OS .
	_dENTMAS := CTOD(Iif(Empty(QRY->ENTMAS),Date(),QRY->ENTMAS))
	_cGarT  := QRY->GARANT == "N" .AND. !Empty(_nDefcl) .AND. !_nDefcr .AND. AllTrim(QRY->OPERAC) == "N09" .AND.;
		(;
			(!Empty(QRY->NFCOMP) .AND. U_Tecx011K(QRY->OPERAC, _dENTMAS, QRY->DTCOMP,1)=="S" ) .OR.;
			(!Empty(QRY->NFTROC) .AND. U_Tecx011K(QRY->OPERAC, _dENTMAS, QRY->DTTROC,2)=="S" );
		)
	If _cGarS
		_cBrow := _oCq
	ElseIf _cGarT
		_cBrow := _oCp
	ElseIf _cGarR
		_cBrow := _oCr
	ElseIf _nDefcr .And. _cGarA .AND. Len(AllTrim(QRY->SPC)) <= 1 .And. AllTrim(QRY->OPERAC) $ "N01#N08#N09#N10#N11"
		_cBrow := _oCc
		_cImpGa := .F.
	ElseIf Empty(_nDefcl) .AND. _cGarA .And. Len(AllTrim(QRY->SPC)) <= 1 .And. AllTrim(QRY->OPERAC) $ "N01#N08#N09#N10#N11"
		_cBrow := _oCc
		_cImpGa := .F.
	EndIf
	If Empty(_cBrow)
		If _cGarA
			_cBrow := _oOk
		Else
			_cBrow := _oNo
			_cImpGa := .F.
		EndIf
	EndIf
	If _nDefcr .AND. _cGarA .AND. Len(AllTrim(QRY->SPC)) <= 1 .AND. AllTrim(QRY->OPERAC) $ "N01#N08"
		ETIQCHEC(QRY->ORDSERV, QRY->IMEI, QRY->COD, QRY->STATU, QRY->OPERAC, "N", QRY->BOUNCE, _nDefcl, _nDescr, QRY->CARCAC,"",QRY->REGZZ4)
	ELSE
		ETIQCHEC(QRY->ORDSERV, QRY->IMEI, QRY->COD, QRY->STATU, QRY->OPERAC, QRY->GARANT, QRY->BOUNCE, _nDefcl, _nDescr, QRY->CARCAC, QRY->ENTMAS,QRY->REGZZ4)
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Grava dados no Array                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QRY")
	dbGoTop()
	While !EOF("QRY")
		aAdd(_aDados,{	QRY->CODCLI, 	QRY->LOJA, 		QRY->IMEI, 		QRY->CARCAC, 	QRY->PRODUT, 	QRY->ORDSERV, 	QRY->NFE, 		QRY->SERIE,		QRY->STATU,		QRY->DTENTRA,;
		QRY->NFCOMP,	QRY->SERNFC, 	QRY->DTCOMP, 	QRY->CNPJNFC, 	QRY->CPFCLI, 	QRY->OPERAC, 	QRY->COD, 		QRY->GARANT,	QRY->MES_GARA,	QRY->DEFEITO,;
		QRY->DESCRIC, 	QRY->EST, 		QRY->Z4_DEFI, 	QRY->DESCRIC1, 	QRY->NOMUSER,	QRY->DTFIMGAR,	QRY->GARACARC})
		dbSelectArea("QRY")
		dbSkip()
	EndDo
	QRY->(dbCloseArea())
	CursorArrow()
	If Len(_aDados) < 0
		MsgAlert("Não foram encontrados dados para a consulta!", "Atenção")
		Return
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Apresenta o MarkBrowse para o usuario                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(AllTrim(_aDados[1][23])) > 1
		_cDestDe	:= IIF(!EMPTY(AllTrim(_aDados[1][23])),Posicione("ZZG", 1, xFilial("ZZG") + "2" + AllTrim(_aDados[1][23]), "ZZG_DESTDE"),"")
		_oDlg           := MSDialog():New(000, 000, 273, 800, "Conferência Garantia - Defeito Reclamado (" + _aDados[1][23] + " - " + AllTrim(_aDados[1][24]) + ")  Bounce " + AllTrim(_cBounc) + " - Estado " + " - " + AllTrim(_aDados[1][22]) ,,,,,,,, oMainWnd, .T.)
		//_oDlg           := MSDialog():New(000, 000, 273, 800, "Conferência Garantia - Defeito Reclamado (" + _aDados[1][20] + " - " + AllTrim(_aDados[1][21]) + ")  Bounce " + AllTrim(_cBounc) + " - Estado " + " - " + AllTrim(_aDados[1][22]) ,,,,,,,, oMainWnd, .T.)
		If _cDestDe == "S"
			oSayMen := TSay():New( 005, 010,{|| _aDados[1][23] + " - " + AllTrim(_aDados[1][24]) },_oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
		Endif
	Else
		_cDestDe	:= IIF(!EMPTY(AllTrim(_aDados[1][20])),Posicione("ZZG", 1, xFilial("ZZG") + "2" + AllTrim(_aDados[1][20]), "ZZG_DESTDE"),"")
		_oDlg           := MSDialog():New(000, 000, 273, 800, "Conferência Garantia - Defeito Reclamado (" + _aDados[1][20] + " - " + AllTrim(_aDados[1][21]) + ")  Bounce " + AllTrim(_cBounc) + " - Estado " + " - " + AllTrim(_aDados[1][22]) ,,,,,,,, oMainWnd, .T.)
		//_oDlg           := MSDialog():New(000, 000, 273, 800, "Conferência Garantia - Defeito Reclamado (" + _aDados[1][20] + " - " + AllTrim(_aDados[1][21]) + ")  Bounce " + AllTrim(_cBounc) + " - Estado " + " - " + AllTrim(_aDados[1][22]) ,,,,,,,, oMainWnd, .T.)
		If _cDestDe == "S"
			oSayMen := TSay():New( 005, 010,{|| _aDados[1][20] + " - " + AllTrim(_aDados[1][21]) },_oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
		Endif		
	EndIf
	
	If Alltrim(_aDados[1][4])==Alltrim(GETMV("MV_SNPADR"))
		oSayGar := TSay():New( 020, 010,{|| "NÃO LIGA - SN PADRÃO" },_oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,252,016)
	Else
		If _aDados[1][18] =="S"
			oSayGar := TSay():New( 020, 010,{|| "GARANTIA" },_oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,252,016)
		Endif
	Endif
	
	If Transform(_cBounc,"@E 999") >= "001" .and. Transform(_cBounc,"@E 999") <= "089" 
		oSayBou := TSay():New( 035, 010,{|| "Bounce " + AllTrim(_cBounc) + " - Estado " + " - " + AllTrim(_aDados[1][22]) },_oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,252,016)
	Endif    

	_oDlg:lCentered := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha os GroupBoxes                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_oGrpo1 := TGroup():New(003, 003, 115, 398,, _oDlg,,, .T.)
	_oGrpo2 := TGroup():New(116, 003, 135, 398,, _oDlg,,, .T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha os Botoes.                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// Ticket 6076 - M.Munhoz - 15/05/2012
	// Alteracao da ordem dos botoes para evitar gravacao indevida, quando o IMEI eh lido 2 vezes pelo tecnico. Quando isto ocorrer sera acionado o botao de Legenda, nao causando gravacao indevida.
	_oBtn4 := TButton():New(118, 025, "Legenda"            			, _oDlg,{|| Legenda()}    				  , 50, 15,,,,.T.)

	If lUsrAut
		If _cGarS
//			_oBtn1 := TButton():New(118, 125, "Audio/Display"          , _oDlg,{|| Consga05()}    				  , 50, 15,,,,.T.)
			_oBtn1 := TButton():New(118, 075, "Audio/Display"          , _oDlg,{|| Consga05()}    				  , 50, 15,,,,.T.)
		EndIf
		
		//Ticket 5537 - M.Munhoz - 20/04/2012 - Criacao de novo SPC (536) para garantia "Outro Motorola"
		_oBtn4 := TButton():New(118, 125, "Outro Moto"                	, _oDlg,{|| Consga06("SPC0000536")}    				  , 50, 15,,,,.T.)
		_oBtn2 := TButton():New(118, 175, "DOA/Bounce"                	, _oDlg,{|| Consga06("SPC0000475")}    				  , 50, 15,,,,.T.)
		_oBtn3 := TButton():New(118, 225, "Contigencia"        		, _oDlg,{|| Consga07()}    				  , 50, 15,,,,.T.)
	EndIf
			
//	_oBtn4 := TButton():New(118, 275, "Legenda"            			, _oDlg,{|| Legenda()}    				  , 50, 15,,,,.T.)
	_oBtn5 := TButton():New(118, 325, "Sair"               			, _oDlg,{|| _oDlg:End()}                 , 50, 15,,,,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Estrutura do MarkBrowse                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aAdd(_aHeader , { "", "Cliente/Loja", "IMEI", "CARCAÇA", "Produto", "O.S.", "Nota Fiscal", "Serie Nf-e", "Dt Entrada", "Nf. Compra", "Serie NfeComp.", "Data Compra", "CNPJ Nf Comp.","CPF Cliente"})
	aAdd(_aColumns, { 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha o MarkBrowse.                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oBrw3 := TWBrowse():New(008+40, 008, 389, 103-40,, _aHeader[1], _aColumns[1], _oDlg,,,,,,,,,,,,,, .T.)
	oBrw3:SetArray(_aDados)
	oBrw3:bLine := {|| {;
	_cBrow,;
	_aDados[oBrw3:nAt][01] + " - " + _aDados[oBrw3:nAt][02],;
	_aDados[oBrw3:nAt][03],;
	_aDados[oBrw3:nAt][04],;
	_aDados[oBrw3:nAt][17] + " - " + _aDados[oBrw3:nAt][05],;
	_aDados[oBrw3:nAt][06],;
	_aDados[oBrw3:nAt][07],;
	_aDados[oBrw3:nAt][08],;
	Transform(_aDados[oBrw3:nAt][10], "@E 99/99/99"),;
	_aDados[oBrw3:nAt][11],;
	_aDados[oBrw3:nAt][12],;
	Transform(_aDados[oBrw3:nAt][13], "@E 99/99/99"),;
	_aDados[oBrw3:nAt][14],;
	_aDados[oBrw3:nAt][15],;
	_aDados[oBrw3:nAt][16]}}
	
	oBrw3:lAdJustColSize := .F.
	oBrw3:lColDrag       := .F.
	oBrw3:lMChange       := .F.
	oBrw3:lHScroll       := .T.
	
	If _aDados[oBrw3:nAt][09] < "5" .And.  lUsrAut
		oBrw3:bLDblClick     := {|| MENU(), oBrw3:Refresh()}
	EndIf
	
	_oDlg:Activate(,,,.T.)
	
	cIMEI:= space(TamSX3("ZZ4_IMEI")[1])//SPACE(15)
	ocodimei:SetFocus()
	
EndIf

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA03 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³TELA PARA INSERIR DADOS DA NOTA FISCAL CLIENTE              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONSGA03()

Local _lOk := .f.

MV_PAR18 := Space(nTamNfe) // NF de Compra
MV_PAR19 := ctod("  /  / ")  // Data da NF de Compra
MV_PAR21 := SPACE(3)
MV_PAR22 := SPACE(18)
MV_PAR23 := SPACE(14)

If mv_par01 == 1
	@ 116,095 To 380,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 115,210 Title OemToAnsi("Dados NF Compra Aparelho")
Else
	@ 116,095 To 380,536 Dialog TelaOutras Title OemToAnsi("Outras informações ")
	@ 002,009 To 115,210 Title OemToAnsi("Dados NF Compra  Troca/Reparo/OS")
EndIf

@ 012,015 Say OemToAnsi("NF       :")         Size 29,8
@ 026,015 Say OemToAnsi("Serie NF       :")         Size 29,8
@ 040,015 Say OemToAnsi("Data       :")         Size 29,8
@ 056,015 Say OemToAnsi("CNPJ Forn. NF       :")         Size 29,8
@ 068,015 Say OemToAnsi("CPF/CNPJ Consumidor:")         Size 29,8


@ 011,057 Get mv_par18 Size 025,010 Picture "@!"		  valid !vazio()	 Object onfcom
@ 024,059 Get mv_par21 Size 010,010 Picture "!!!"
@ 038,057 Get mv_par19 Size 025,010 Picture " / / "       valid u_valtx11n(mv_par19,"3") Object odtnfco
@ 052,075 Get mv_par22 Size 059,010 Picture "@R 99.999.999/9999-99"
@ 064,075 Get mv_par23 Size 059,010 Picture "@R 99999999999999" //valid u_valtx11n(mv_par23,"4") Object ocpfcli


@ 100, 140 BMPBUTTON TYPE 1 ACTION (_lOk := .T., Close(TelaOutras),CONSGA04())
@ 100, 170 BMPBUTTON TYPE 2 ACTION (_lOk := .f., Close(TelaOutras))

Activate Dialog TelaOutras

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA04 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS INFORMADO ANTERIORMENTE º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CONSGA04()

Local  cQry
Local _cQry
Local  cQryExec
Local _cQryExec
Local _cQryExec1
Local _cQryDelet
Local _cQryGaran
Local _cQryGnfco
Local _cQryGnftr
Local _cMensagem
Local _dData 	:= Dtos(_aDados[1][10])
Local _pergar  	:= Posicione("ZZJ", 1, xFilial("ZZJ") + _aDados[1][16], "ZZJ_PERGRC")
Local _cTitemail:= "Regra 77"
Local _Path 	:= "172.16.0.7"
Local _center  	:= Chr(13)+Chr(10)
Local _cSpc1	:= .F.
Local _garan
Local _cSpc
Local _dCom


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
If Select("TRB1") > 0
	TRB1->(dbCloseArea())
Endif
If Select("TRB2") > 0
	TRB2->(dbCloseArea())
Endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
Endif
If Select("TRB4") > 0
	TRB4->(dbCloseArea())
Endif

_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+=" WHERE ZA_FILIAL = '" + xFilial("SZA") + "' " + ENTER
_cQry	+=" AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
_cQry	+=" AND ZA_LOJA = '" +_aDados[1][2] + "' " + ENTER
_cQry	+=" AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
//_cQry	+=" AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
_cQry	+=" AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
//_cQry	+=" AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
_cQry	+=" AND ZA_STATUS = 'V' " + ENTER
_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

If MV_PAR19 < _cMesAt .And. lUsrAut
	If ApMsgYesNo("Data de Compra Menor à Fabricação, Esse Equipamento Esta Liberado como SPC0000520 ???", "Divergencias Entre Datas")
		_cSpc1 := .T.
		
		_cMensagem := "Equipamento Regra 77 : "+DTOC(date())+" - "+time()+" hrs." + _center
		_cMensagem += "Equipamento modelo: " +  _aDados[1][17] + _center
		_cMensagem += "Cliente: " + _aDados[1][1] + " Loja: " +  _aDados[1][2] + _center
		_cMensagem += "IMEI: " + _aDados[1][3] + "Os: " + _aDados[1][6]+_center
		_cMensagem += "NF-e Compra : "+MV_PAR18+ "Serie: " + MV_PAR21 + _center
		_cMensagem += "Usuario Apontando " + AllTrim(cUsername)
//		U_ENVIAEMAIL(_cTitemail,"marcos.santos@bgh.com.br;alessandro.mendonca@bgh.com.br;thiago.costa@bgh.com.br;luiz.reis@bgh.com.br;denise.marcelino@bgh.com.br","",_cMensagem,_Path)		
		U_ENVIAEMAIL(_cTitemail,"consga04@bgh.com.br","",_cMensagem,_Path)
	Else
		Return()
	EndIf
EndIf

If mv_par01 == 1
	
	If Empty(QRY->CLIENTE)
		
		RecLock("SZA",.T.)
		
		SZA->ZA_FILIAL 		:= xfilial("SZA")
		SZA->ZA_CLIENTE		:= _aDados[1][1]
		SZA->ZA_LOJA 		:= _aDados[1][2]
		SZA->ZA_NFISCAL		:= _aDados[1][7]
		SZA->ZA_SERIE 		:= _aDados[1][8]
		SZA->ZA_EMISSAO		:= _aDados[1][10]
		SZA->ZA_DATA 		:= _aDados[1][10]
		SZA->ZA_IMEI 		:= _aDados[1][3]
		SZA->ZA_CODPRO 		:= _aDados[1][17]
		SZA->ZA_STATUS 		:= "V"
		SZA->ZA_NFCOMPR		:= MV_PAR18
		SZA->ZA_SERNFC 		:= MV_PAR21
		SZA->ZA_DTNFCOM		:= MV_PAR19
		SZA->ZA_CNPJNFC		:= MV_PAR22
		SZA->ZA_CPFCLI 		:= MV_PAR23
		SZA->ZA_GARCARC 	:= _aDados[1][18]
		SZA->ZA_NOMUSER		:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
		msunlock()
	Else
		cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
		cQryExec += "SET ZA_NFCOMPR  = '" + MV_PAR18 + "' , ZA_SERNFC = '" + MV_PAR21 + "' , ZA_DTNFCOM = '" + Dtos(MV_PAR19) + "' , ZA_CNPJNFC = '" + MV_PAR22 + "' , ZA_CPFCLI = '" + MV_PAR23 + "' , ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "', ZA_GARCARC = '" + _aDados[1][18] + "' " + ENTER
		cQryExec += "WHERE ZA_FILIAL='"+xfilial("SZA")+"' "+ENTER 
		cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
		cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
		cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
		cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
		cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
		
		TcSQlExec(cQryExec)
		TCRefresh(RETSQLNAME("SZA"))
	Endif
	
	If _cSpc1
		MsgAlert("Concluido entrada conforme Liberação !!!","Garantia")
	EndIf
	
Else
	If Empty(QRY->CLIENTE)
		
		RecLock("SZA",.T.)
		
		SZA->ZA_FILIAL 		:= xfilial("SZA")
		SZA->ZA_CLIENTE		:= _aDados[1][1]
		SZA->ZA_LOJA 		:= _aDados[1][2]
		SZA->ZA_NFISCAL		:= _aDados[1][7]
		SZA->ZA_SERIE 		:= _aDados[1][8]
		SZA->ZA_EMISSAO		:= _aDados[1][10]
		SZA->ZA_DATA 		:= _aDados[1][10]
		SZA->ZA_IMEI 		:= _aDados[1][3]
		SZA->ZA_CODPRO 		:= _aDados[1][17]
		SZA->ZA_STATUS 		:= "V"
		SZA->ZA_NFTROCA		:= MV_PAR18
		SZA->ZA_SERNFTR		:= MV_PAR21
		SZA->ZA_DTNFTRO		:= MV_PAR19
		SZA->ZA_CNPJNFT		:= MV_PAR22
		SZA->ZA_CPFCLI 		:= MV_PAR23
		SZA->ZA_GARCARC 	:= _aDados[1][18]
		SZA->ZA_NOMUSER		:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
		
		msunlock()
	Else
		cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
		cQryExec += "SET ZA_NFTROCA  = '" + MV_PAR18 + "' , ZA_SERNFTR = '" + MV_PAR21 + "' , ZA_DTNFTRO = '" + Dtos(MV_PAR19) + "' , ZA_CNPJNFT = '" + MV_PAR22 + "' , ZA_CPFCLI = '" + MV_PAR23 + "' , ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "', ZA_GARCARC = '" + _aDados[1][18] + "' " + ENTER
    	cQryExec += "WHERE ZA_FILIAL='"+xfilial("SZA")+"' "+ENTER
		cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
		cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
		cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
		cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
		cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
		
		TcSQlExec(cQryExec)
		TCRefresh(RETSQLNAME("SZA"))
	Endif
Endif

//If !_cGarA

//_cQryExec := " SELECT DATEDIFF(MONTH, '" + Dtos(MV_PAR19) + "' , '" +_dData + "' ) AS DATES "

If mv_par01 == 1 .And. _cSpc1 == .F.
	_cQryExec := " SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, " + Transform(_pergar,"@E 99") + ",'" + Dtos(MV_PAR19) + "' ),112) AS DATES "
	TCQUERY _cQryExec NEW ALIAS "TRB"
	
	_cQryExec1  := "	SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB->DATES + "' ),112) AS DIAS "
	TCQUERY _cQryExec1 NEW ALIAS "TRB3"
	
	If  _dData <= TRB->DATES
		_garan 	:= "S"
		_cSpc	:= ""
		MsgAlert("Esta em Garantia")
	EndIf
	If TRB->DATES < _dData .And. _dData <= TRB3->DIAS
		_garan 	:= "S"
		_cSpc	:= "SPC0000456"
		MsgAlert("Esta em Garantia")
	EndIf
	If TRB->DATES < _dData .And. _dData > TRB3->DIAS
		_garan 	:= "N"
		_cSpc	:=	""
		MsgAlert("Não Esta em Garantia")
	EndIf

	_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
	_cQryGaran += " SET ZZ4_GARANT = '" + _garan + "' " + ENTER
	_cQryGaran += " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER
	_cQryGaran += " AND	ZZ4_CODCLI = '" + _aDados[1][1] + "' " + ENTER
	_cQryGaran += " AND ZZ4_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryGaran += " AND ZZ4_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryGaran += " AND ZZ4_CARCAC = '" + _aDados[1][4] + "' " + ENTER
	_cQryGaran += " AND ZZ4_OS  = '" + _aDados[1][6] + "' " + ENTER
	_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
	_cQryGaran += " AND D_E_L_E_T_='' " + ENTER
	TcSQlExec(_cQryGaran)
	TCRefresh(RETSQLNAME("ZZ4"))

	_cQryGnfco := " UPDATE  " + RetSqlName("SZA") + ENTER
	_cQryGnfco += " SET ZA_GARNFC = '" + _garan + "', ZA_SPC = '" + _cSpc + "' " + ENTER
	_cQryGnfco += " WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
	_cQryGnfco += " AND	ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
	_cQryGnfco += " AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryGnfco += " AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryGnfco += " AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
	_cQryGnfco += " AND D_E_L_E_T_='' " + ENTER
	TcSQlExec(_cQryGnfco)
	TCRefresh(RETSQLNAME("SZA"))
	
	MsgAlert("Gravação Nf - Compra concluida com exito")
EndIf

If mv_par01 == 2 .And. _cSpc1 == .F.
	_cQryExec  := " SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, 3,'" + Dtos(MV_PAR19) + "' ),112) AS DATES "
	TCQUERY _cQryExec NEW ALIAS "TRB1"
	
	//_cQryExec1  := "	SELECT CONVERT(VARCHAR(10),DATEADD(DAY, 30,'" + TRB1->DATES + "' ),112) AS DIAS "
	
	//	TCQUERY _cQryExec1 NEW ALIAS "TRB2"
	
	//Alterado IF de validacao, pois nao estava validando data da NF de troca - Edson Rodrigues - 24/06/12.
	//If  _aDados[1][26] >= Dtos(MV_PAR19) .And. _dData <= TRB1->DATES
	If STOD(_dData)-STOD(TRB1->DATES) <=((_pergar*30)+5)
	
		_garan := "S"
		_cSpc	:=	""
		MsgAlert("Esta em Garantia")
	Else
		_garan := "N"
		_cSpc	:=	""
		MsgAlert("Não Esta em Garantia")
	EndIf
	
	_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
	_cQryGaran += " SET ZZ4_GARANT = '" + _garan + "' " + ENTER
	_cQryGaran += " WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' " + ENTER
	_cQryGaran += "	AND ZZ4_CODCLI = '" + _aDados[1][1] + "' " + ENTER
	_cQryGaran += " AND ZZ4_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryGaran += " AND ZZ4_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryGaran += " AND ZZ4_CARCAC = '" + _aDados[1][4] + "' " + ENTER
	_cQryGaran += " AND ZZ4_OS  = '" + _aDados[1][6] + "' " + ENTER
	_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
	
	TcSQlExec(_cQryGaran)
	TCRefresh(RETSQLNAME("ZZ4"))
	
	_cQryGnfco := " UPDATE  " + RetSqlName("SZA") + ENTER
	_cQryGnfco += " SET ZA_GARNFT = '" + _garan + "', ZA_SPC = '" + _cSpc + "' " + ENTER
	_cQryGnfco += " WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
	_cQryGnfco += " AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
	_cQryGnfco += " AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryGnfco += " AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryGnfco += " AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
	
	TcSQlExec(_cQryGnfco)
	TCRefresh(RETSQLNAME("SZA"))
	
	MsgAlert("Gravação Nf- Troca concluida com exito")
EndIf

If Alltrim(_aDados[1][16])=="N09"
	aAreaAtu := GetArea()
	dbSelectArea("ZZ4")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZ4")+_aDados[1][3]+_aDados[1][6])
		
		cTransc     := ZZ4->ZZ4_TRANSC
		cGarMCL     := ZZ4->ZZ4_GARMCL
		_cOpebgh    := ZZ4->ZZ4_OPEBGH
		dbselectarea("ZZJ")
		ZZJ->(dbsetOrder(1))
		ZZJ->(dbseek(xFilial("ZZJ")+ _cOpebgh + "2"))
		
		_cRecCli    := Posicione("ZZG",1,xFilial("ZZG")+ZZJ->ZZJ_LAB+ZZ4->ZZ4_DEFINF,"ZZG_RECCLI")
		
		if ZZ4->ZZ4_GARANT == "S" .and. !empty(_cRecCli) .and. _cRecCli <> "C0022"
			cTransc := ZZJ->ZZJ_CODTRF
		elseif u_CondIRF(ZZJ->ZZJ_LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), ZZ4->ZZ4_DEFINF)
			cTransc := "IRF"
		elseif u_CondIXT(ZZJ->ZZJ_LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), ZZ4->ZZ4_DEFINF)
			cTransc := "IXT"
		elseif _cOpeBGH $ "N01/N10/N11"
			cTransc := "IOW"
		endif
		
		// Define Garantia MCLAIM de acordo com o Transaction
		if alltrim(cTransc) $ "IBS/IRE/IRR/IRS/IXT/IR2/IR4/ITS/IER/IFS/IFR"
			cGarMCL := "S"
		elseif alltrim(cTransc) $ "IOW/IRF"
			cGarMCL := "N"
		endif
		
		Begin Transaction
		RecLock("ZZ4",.F.)
		ZZ4->ZZ4_TRANSC := cTransc
		ZZ4->ZZ4_GARMCL := cGarMCL
		MsUnlock()
		End Transaction
		
	Endif
	RestArea(aAreaAtu)
Endif

If _aDados[1][18] == 'S'
	
	_cQryExec  := "SELECT DATEDIFF(MONTH, '" + DtoS(_aDados[1][27]) + "' , '" + DtoS(MV_PAR19) + "' ) AS  REG77 "
	
	TCQUERY _cQryExec NEW ALIAS "TRB4"
	
	If TRB4->REG77 >= 20
		MsgAlert("Data de fabricação Maior que 24 Meses , Esse Equipamento Esta Liberado como SPC0000520 ???", "Divergencias Entre Datas")
		
		_cMensagem := "Equipamento Regra 77 : "+DTOC(date())+" - "+time()+" hrs." + _center
		_cMensagem += "Equipamento modelo: " +  _aDados[1][17] + _center
		_cMensagem += "Cliente: " + _aDados[1][1] + " Loja: " +  _aDados[1][2] + _center
		_cMensagem += "IMEI: " + _aDados[1][3] + "Os: " + _aDados[1][6]+_center
		_cMensagem += "NF-e Compra : "+MV_PAR18+ "Serie: " + MV_PAR21 + _center
		_cMensagem += "Usuario Apontando " + AllTrim(cUsername)
		
	//  U_ENVIAEMAIL(_cTitemail,"marcos.santos@bgh.com.br;alessandro.mendonca@bgh.com.br;thiago.costa@bgh.com.br;luiz.reis@bgh.com.br;denise.marcelino@bgh.com.br","",_cMensagem,_Path)
		U_ENVIAEMAIL(_cTitemail,"consga04@bgh.com.br","",_cMensagem,_Path)
	Endif
	
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif
If Select("TRB1") > 0
	TRB1->(dbCloseArea())
Endif
If Select("TRB2") > 0
	TRB2->(dbCloseArea())
Endif
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
Endif
If Select("TRB4") > 0
	TRB4->(dbCloseArea())
Endif

oBrw3:Refresh()

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA05 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS INFORMADO ANTERIORMENTE º±±
±±º          ³SPC0000434 - PERIODO DE 15 A 20 MESES                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CONSGA05()

Local _cQry
Local _cQryExec
Local _cQryGaran
Local _dData 	:= Dtos(_aDados[1][10])


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+=" WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
_cQry	+=" AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
_cQry	+=" AND ZA_LOJA = '" +_aDados[1][2] + "' " + ENTER
_cQry	+=" AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
//_cQry	+=" AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
_cQry	+=" AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
//_cQry	+=" AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
_cQry	+=" AND ZA_STATUS = 'V' " + ENTER
_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

If _cGarA == .F.
	
	If _cGarS
		
		If Empty(QRY->CLIENTE)
			
			RecLock("SZA",.T.)
			
			SZA->ZA_FILIAL 	:= xfilial("SZA")
			SZA->ZA_CLIENTE	:= _aDados[1][1]
			SZA->ZA_LOJA 	:= _aDados[1][2]
			SZA->ZA_NFISCAL	:= _aDados[1][7]
			SZA->ZA_SERIE 	:= _aDados[1][8]
			SZA->ZA_EMISSAO	:= _aDados[1][10]
			SZA->ZA_DATA 	:= _aDados[1][10]
			SZA->ZA_IMEI 	:= _aDados[1][3]
			SZA->ZA_CODPRO 	:= _aDados[1][17]
			SZA->ZA_STATUS 	:= "V"
			SZA->ZA_SPC 	:= "SPC0000434"
			SZA->ZA_EXECAO	:= "S"
			SZA->ZA_NOMUSER	:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
			
			msunlock()
			
		Else
			_cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
			_cQryExec += "SET ZA_SPC = 'SPC0000434', ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
			_cQryExec += "WHERE  ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
			_cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
			_cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
			_cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
			//_cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
			_cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
			_cQryExec += "AND ZA_STATUS = 'V' " + ENTER
			
			TcSQlExec(_cQryExec)
			TCRefresh(RETSQLNAME("SZA"))
		EndIf
		
	ElseIf _cGarU
		
		If Empty(QRY->CLIENTE)
			
			RecLock("SZA",.T.)
			
			SZA->ZA_FILIAL 	:= xfilial("SZA")
			SZA->ZA_CLIENTE	:= _aDados[1][1]
			SZA->ZA_LOJA 	:= _aDados[1][2]
			SZA->ZA_NFISCAL	:= _aDados[1][7]
			SZA->ZA_SERIE 	:= _aDados[1][8]
			SZA->ZA_EMISSAO	:= _aDados[1][10]
			SZA->ZA_DATA 	:= _aDados[1][10]
			SZA->ZA_IMEI 	:= _aDados[1][3]
			SZA->ZA_CODPRO 	:= _aDados[1][17]
			SZA->ZA_STATUS 	:= "V"
			SZA->ZA_SPC 	:= IIF(_lspc433,"SPC0000433","")
			SZA->ZA_EXECAO	:= "S"
			SZA->ZA_NOMUSER	:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
			
			msunlock()
			
		Else
			_cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
			IF _lspc433
				_cQryExec += "SET ZA_SPC = 'SPC0000433', ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
			ELSE
				_cQryExec += "SET ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
			ENDIF
			_cQryExec += "WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER 
			_cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
			_cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
			_cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
			//_cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
			_cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
			_cQryExec += "AND ZA_STATUS = 'V' " + ENTER
			
			TcSQlExec(_cQryExec)
			TCRefresh(RETSQLNAME("SZA"))
		EndIf
	Endif
	
	If _cGarS .Or. _cGarU
		
		_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
		IF _lspc433
			_cQryGaran += " SET ZZ4_GARANT = 'S' " + ENTER
		ELSE
			_cQryGaran += " SET ZZ4_GARMCL = 'S' " + ENTER
			
		ENDIF
		_cQryGaran += " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER
		_cQryGaran += " AND ZZ4_CODCLI = '" + _aDados[1][1] + "' " + ENTER
		_cQryGaran += " AND ZZ4_LOJA = '" + _aDados[1][2] + "' " + ENTER
		_cQryGaran += " AND ZZ4_IMEI = '" + _aDados[1][3] + "' " + ENTER
		_cQryGaran += " AND ZZ4_CARCAC = '" + _aDados[1][4] + "' " + ENTER
		_cQryGaran += " AND ZZ4_OS  = '" + _aDados[1][6] + "' " + ENTER
		_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
		
		TcSQlExec(_cQryGaran)
		TCRefresh(RETSQLNAME("ZZ4"))
		
		MsgAlert("Gravação concluida com exito SPC0000434", "Alerta SPC")
		
	Else
		
		MsgAlert("Equipamento fora da especificação de SPC !!", "Alerta SPC")
		
	EndIf
Else
	
	MsgAlert("Equipamento com Garantia Validada não será Possível Validar pelo SPC !!", "Alerta SPC")
EndIf

QRY->(dbCloseArea())

oBrw3:Refresh()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA06 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS INFORMADO ANTERIORMENTE º±±
±±º          ³SPC0000475 - DOA                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 20/04/12 ºMarcelo Munhoz    ºAlteracao para tratar o novo SPC00000536 º±±
±±º          º                  ºOUTROMOTO                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CONSGA06(_cSPC)

Local _cQry
Local _cQryExec
Local _cQryGaran
Local _dData 	:= Dtos(_aDados[1][10])

// Ticket 6361 - Marcelo Munhoz - 04/06/2012 - Bloqueia o apontamento de SPC de acordo com a operacao do IMEI
if !u_PermitSPC(_aDados[1,16], "2", _cSPC)
	oBrw3:Refresh()
	return()
endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
_cQry	+=" WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER  
_cQry	+=" AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
_cQry	+=" AND ZA_LOJA = '" +_aDados[1][2] + "' " + ENTER
_cQry	+=" AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
//_cQry	+=" AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
_cQry	+=" AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
//_cQry	+=" AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
_cQry	+=" AND ZA_STATUS = 'V' " + ENTER
_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)

If Empty(QRY->CLIENTE)
	
	RecLock("SZA",.T.)
	
	SZA->ZA_FILIAL 	:= xfilial("SZA")
	SZA->ZA_CLIENTE	:= _aDados[1][1]
	SZA->ZA_LOJA 	:= _aDados[1][2]
	SZA->ZA_NFISCAL	:= _aDados[1][7]
	SZA->ZA_SERIE 	:= _aDados[1][8]
	SZA->ZA_EMISSAO	:= _aDados[1][10]
	SZA->ZA_DATA 	:= _aDados[1][10]
	SZA->ZA_IMEI 	:= _aDados[1][3]
	SZA->ZA_CODPRO 	:= _aDados[1][17]
	SZA->ZA_STATUS 	:= "V"
// Ticket 5537 - M.Munhoz - 20/04/2012 - Criacao de novo SPC para garantia 'Outro Motorola'
//	SZA->ZA_EXECAO	:= "D"
	SZA->ZA_EXECAO	:= iif(_cSPC == "SPC0000536","O","D")
	SZA->ZA_SPC 	:= _cSPC //DOA/BOUNCE = "SPC0000475" / OUTRO MOTO = "SPC0000536"
	SZA->ZA_NOMUSER	:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
	
	msunlock()
Else
	_cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
// Ticket 5537 - M.Munhoz - 20/04/2012 - Criacao de novo SPC para garantia 'Outro Motorola'
//	_cQryExec += "SET ZA_SPC = 'SPC0000475', ZA_EXECAO = 'D', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
	_cQryExec += "SET ZA_SPC = '"+_cSPC+"', ZA_EXECAO = '"+iif(_cSPC == "SPC0000536","O","D")+"', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
	_cQryExec += "WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
    _cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
	_cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
	//_cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
	_cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryExec += "AND ZA_STATUS = 'V' " + ENTER
	
	TcSQlExec(_cQryExec)
	TCRefresh(RETSQLNAME("SZA"))
Endif

_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
_cQryGaran += " SET ZZ4_GARANT = 'S' " + ENTER
_cQryGaran += " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER
_cQryGaran += " AND ZZ4_CODCLI = '" + _aDados[1][1] + "' " + ENTER
_cQryGaran += " AND ZZ4_LOJA = '" + _aDados[1][2] + "' " + ENTER
_cQryGaran += " AND ZZ4_IMEI = '" + _aDados[1][3] + "' " + ENTER
_cQryGaran += " AND ZZ4_CARCAC = '" + _aDados[1][4] + "' " + ENTER
_cQryGaran += " AND ZZ4_OS  = '" + _aDados[1][6] + "' " + ENTER
_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER

TcSQlExec(_cQryGaran)
TCRefresh(RETSQLNAME("ZZ4"))

//Ticket 5537 - M.Munhoz - 20/04/2012 - Criacao de novo SPC para garantia 'Outro Motorola'
//MsgAlert("Gravação concluida com exito SPC0000475")
MsgAlert("Gravação concluida com exito "+_cSPC)

QRY->(dbCloseArea())

oBrw3:Refresh()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA07 º Autor ³Paulo Lopez         º Data ³  18/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS INFORMADO ANTERIORMENTE º±±
±±º          ³SPC0000477 - CONTIGENCIA                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CONSGA07()

Local _cQry
Local _cQryExec
Local _cQryGaran
Local _dData 	:= Dtos(_aDados[1][10])

// Ticket 6361 - Marcelo Munhoz - 04/06/2012 - Bloqueia o apontamento de SPC de acordo com a operacao do IMEI
if !u_PermitSPC(_aDados[1,16], "2", "SPC0000477")
	oBrw3:Refresh()
	return()
endif

If !Empty(_nNftro)
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	
	_cQry	:=" SELECT ZA_CLIENTE CLIENTE " + ENTER
	_cQry	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
	_cQry	+=" WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
	_cQry	+=" AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
	_cQry	+=" AND ZA_LOJA = '" +_aDados[1][2] + "' " + ENTER
	_cQry	+=" AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
	//_cQry	+=" AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
	_cQry	+=" AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
	//_cQry	+=" AND ZA_CODPRO = '" + _aDados[1][17] + "' " + ENTER
	_cQry	+=" AND ZA_STATUS = 'V' " + ENTER
	_cQry	+=" AND D_E_L_E_T_ = '' " + ENTER
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	
	If Empty(QRY->CLIENTE)
		
		RecLock("SZA",.T.)
		
		SZA->ZA_FILIAL 	:= xfilial("SZA")
		SZA->ZA_CLIENTE	:= _aDados[1][1]
		SZA->ZA_LOJA 	:= _aDados[1][2]
		SZA->ZA_NFISCAL	:= _aDados[1][7]
		SZA->ZA_SERIE 	:= _aDados[1][8]
		SZA->ZA_EMISSAO	:= _aDados[1][10]
		SZA->ZA_DATA 	:= _aDados[1][10]
		SZA->ZA_IMEI 	:= _aDados[1][3]
		SZA->ZA_CODPRO 	:= _aDados[1][17]
		SZA->ZA_STATUS 	:= "V"
		SZA->ZA_NOMUSER	:= AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time()
		
		If Transform(_cBounc,"@E 999") > "090"
			SZA->ZA_SPC 	:= "SPC0000477"
			SZA->ZA_EXECAO	:= "C"
		Else
			SZA->ZA_SPC 	:= "SPC0000477"
			SZA->ZA_EXECAO	:= "B"
		Endif
		
		msunlock()
		
	Else
		_cQryExec := "UPDATE " + RetSqlName("SZA") + ENTER
		
		If Transform(_cBounc,"@E 999") > "090"
			_cQryExec += "SET ZA_SPC = 'SPC0000477', ZA_EXECAO = 'C', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
		Else
			_cQryExec += "SET ZA_SPC = 'SPC0000477', ZA_EXECAO = 'B', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER
		EndIf
		
		_cQryExec += "WHERE ZA_FILIAL='"+XFILIAL("SZA")+"' " + ENTER
		_cQryExec += "AND ZA_CLIENTE = '" + _aDados[1][1] + "' " + ENTER
		_cQryExec += "AND ZA_LOJA = '" + _aDados[1][2] + "' " + ENTER
		_cQryExec += "AND ZA_NFISCAL = '" + _aDados[1][7] + "' " + ENTER
		//_cQryExec += "AND ZA_SERIE = '" + _aDados[1][8] + "' " + ENTER
		_cQryExec += "AND ZA_IMEI = '" + _aDados[1][3] + "' " + ENTER
		_cQryExec += "AND ZA_STATUS = 'V' " + ENTER
		
		TcSQlExec(_cQryExec)
		TCRefresh(RETSQLNAME("SZA"))
	Endif
	
	_cQryGaran := " UPDATE  " + RetSqlName("ZZ4") + ENTER
	_cQryGaran += " SET ZZ4_GARANT = 'S' " + ENTER
	_cQryGaran += " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER
	_cQryGaran += " AND ZZ4_CODCLI = '" + _aDados[1][1] + "' " + ENTER
	_cQryGaran += " AND ZZ4_LOJA = '" + _aDados[1][2] + "' " + ENTER
	_cQryGaran += " AND ZZ4_IMEI = '" + _aDados[1][3] + "' " + ENTER
	_cQryGaran += " AND ZZ4_CARCAC = '" + _aDados[1][4] + "' " + ENTER
	_cQryGaran += " AND ZZ4_OS  = '" + _aDados[1][6] + "' " + ENTER
	_cQryGaran += " AND ZZ4_STATUS IN ('3','4') " + ENTER
	
	TcSQlExec(_cQryGaran)
	TCRefresh(RETSQLNAME("ZZ4"))
	
	QRY->(dbCloseArea())
	
	If Transform(_cBounc,"@E 999") > "090"
		MsgAlert("Gravação concluida com exito SPC0000477 !!!")
	ELse
		msgAlert("Equipamento Bounce, Gravação concluida com exito SPC0000477 !!!")
	EndIf
	
Else
	MsgAlert("Favor Inserir dados da Nf - Troca")
EndIf

oBrw3:Refresh()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSGA    º Autor ³Paulo Lopez         º Data ³  07/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CADASTROS PARA MENU DINAMICO                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MENU()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Cria dicionario de perguntas                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif

Do Case
	
	Case mv_par01 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Monta Nf de Compras                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_CONSGA03()
		
	Case mv_par01 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Monta Nf de Troca/Reparo/OS                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_CONSGA03()
		
EndCase

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSGA08  º Autor ³Paulo Lopez         º Data ³  07/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³VERIFICACAO DE NF COMPRAS CLIENTE                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONSGA08()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg      	:= Nil
Local cQry

Private aHeader1  	:= {}
Private aColumns1 	:= {}
Private _Dados 		:= {}

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Query                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CursorWait()

cQry	:=	"SELECT ZZ4.ZZ4_IMEI	IMEI, " + ENTER
cQry	+=	"		ZZ4.ZZ4_OS		ORDSERV, " + ENTER
cQry	+=	"		ZZ4.ZZ4_NFENR  	NFE, " + ENTER
cQry	+=	"		ZZ4.ZZ4_NFESER	SERIE, " + ENTER
cQry	+=	"		ZZ4.ZZ4_STATUS	STATU, " + ENTER
cQry	+=	"		ZZ4.ZZ4_NFEDT	DTENTRA, " + ENTER
cQry	+=	"		ZZ4.ZZ4_GARANT	GARANT, " + ENTER
cQry	+=	"		ZZ4.ZZ4_BOUNCE	BOUNCE, " + ENTER
cQry	+=	"		SZA.ZA_NFCOMPR	NFCOMP, " + ENTER
cQry	+=	"		SZA.ZA_SERNFC   SERNFC, " + ENTER
cQry	+=	"		SZA.ZA_DTNFCOM	DTCOMP, " + ENTER
cQry	+=	"		SZA.ZA_NFTROCA	NFTROC, " + ENTER
cQry	+=	"		SZA.ZA_SERNFTR	SERNFT, " + ENTER
cQry	+=	"		SZA.ZA_DTNFTRO	DTTROC, " + ENTER
cQry	+=	"		ISNULL(SZA.ZA_SPC,'')	SPC " + ENTER
cQry	+=	"FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) " + ENTER
cQry	+=	"LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) " + ENTER
cQry	+=	"ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI     " + ENTER
cQry	+=	"AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_)    " + ENTER
cQry	+=	"INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock)  " + ENTER
cQry	+=	"ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL =  '"+XFILIAL("SA1")+"' ) " + ENTER
cQry	+=	"WHERE ZZ4.ZZ4_FILIAL = '"+XFILIAL("ZZ4")+"'  " + ENTER
cQry	+=	"AND ZZ4.ZZ4_IMEI = '"+ZZ3->ZZ3_IMEI+"' " + ENTER
cQry	+=	"AND ZZ4.D_E_L_E_T_ = ''    " + ENTER
cQry	+=	"ORDER BY DTENTRA DESC " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY1", .F., .T.)
TCSetField("QRY1", "DTENTRA", "D")
TCSetField("QRY1", "DTCOMP",  "D")
TCSetField("QRY1", "DTTROC",  "D")

QRY1->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava dados no Array                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QRY1")
dbGoTop()

While !EOF("QRY1")
	
	aAdd( _Dados,{QRY1->IMEI, QRY1->ORDSERV, QRY1->NFE, QRY1->SERIE, QRY1->DTENTRA, QRY1->STATU, QRY1->GARANT, QRY1->BOUNCE, QRY1->NFCOMP, QRY1->SERNFC, QRY1->DTCOMP, QRY1->NFTROC, QRY1->SERNFT, QRY1->DTTROC, QRY1->SPC})
	
	dbSelectArea("QRY1")
	dbSkip()
EndDo

QRY1->(dbCloseArea())

CursorArrow()

If Len( _Dados) < 1
	MsgAlert("Não foram encontrados dados para a consulta!", "Atenção")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Estrutura do MarkBrowse                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aHeader1 , {"IMEI", "O.S.", "Nf.Entrada", "Serie", "Data-Entrada", "Status","Garantia", "Bounce", "Nf.Compra","Serie","Data-Compra","Nf.Troca","Serie","Data-Troca","SPC"})
aAdd(aColumns1, {24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Apresenta o MarkBrowse para o usuario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg           := MSDialog():New(000, 000, 240, 880, "Nf de Compra",,,,,,,, oMainWnd, .T.)
oDlg:lCentered := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha os GroupBoxes                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGrpo1 := TGroup():New(002, 003, 106, 438,, oDlg,,, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha o MarkBrowse.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBrw1 := TWBrowse():New(003, 004, 430, 100,, aHeader1[1], aColumns1[1], oDlg,,,,,,,,,,,,,, .T.)
oBrw1 :SetArray(_Dados)
oBrw1 :bLine := {|| {;
_Dados[oBrw1:nAt][01],;
_Dados[oBrw1:nAt][02],;
_Dados[oBrw1:nAt][03],;
_Dados[oBrw1:nAt][04],;
Transform(_Dados[oBrw1:nAt][05], "@E 99/99/99"),;
_Dados[oBrw1:nAt][06],;
_Dados[oBrw1:nAt][07],;
_Dados[oBrw1:nAt][08],;
_Dados[oBrw1:nAt][09],;
_Dados[oBrw1:nAt][10],;
Transform(_Dados[oBrw1:nAt][11], "@E 99/99/99"),;
_Dados[oBrw1:nAt][12],;
_Dados[oBrw1:nAt][13],;
Transform(_Dados[oBrw1:nAt][14], "@E 99/99/99"),;
_Dados[oBrw1:nAt][15]}}

oBrw1:lAdJustColSize := .F.
oBrw1:lColDrag       := .F.
oBrw1:lMChange       := .F.
oBrw1:lHScroll       := .T.

oDlg:Activate(,,,.T.)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONSGA09 º Autor ³Paulo Lopez         º Data ³  29/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS CONFORME PARAMETROS DETERMINADOS            º±±
±±º          ³SPC0000433 - PERIODO DE 15 A 20 MESES                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          |           A L T E R A C O E S                              º±±
±±º          |A partir de 01/01/12 essa validacao mudou, onde nao grava   º±±
±±º          |mais o SPC0000433 e sim o Trannsaction code IXT, o qual e   º±±
±±º          |atualizaa parelhos fora da garantia de 15 a 24 meses        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONSGA09(_NumImei,_NumOS)

Local _cQry
Local _cDef
Local _cQry1
Local _cQryExec
Local _cQryGaran
Local _ExecQry
Local _lRet := .F.

Private _cSpr		:= GetMv("MV_SPC0433") 				 // Aparelhos Parametrizados para Especifico SPC0000433 - Motorola
Private _cPsq		:= GetMv("MV_PERSPC3") 				 // Periodo Parametrizados para Especifico SPC0000433 - Motorola
Private _cSpf		:= GetMv("MV_PRFOUND")				 // Problem Found para SPC0000433 - Motorola

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf

_cQry	:= " SELECT ZZ4.ZZ4_CODCLI CODCLI, ZZ4.ZZ4_LOJA LOJA, ZZ4.ZZ4_NFENR NFE, ZZ4.ZZ4_NFESER SERIE, ZZ4.ZZ4_IMEI IMEI, ZZ4.ZZ4_NFEDT DTENTRA,"
_cQry	+= " ZZ4.ZZ4_CODPRO COD, ZZ4.ZZ4_CARCAC CARCAC, ZZ4.ZZ4_OS ORDSERV, ZZ4.ZZ4_GARANT GARANT, SZA.ZA_DEFRECL DEFEITO, ZZ4.ZZ4_PROBLE PFOUND, "
_cQry	+= "	(SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = ''"
_cQry	+= " AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + "
_cQry	+= "	(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD'"
_cQry	+= "	AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' GARACARC, "
_cQry	+= "		DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = ''"
_cQry	+= "	AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM(ZZ4_CARCAC),5,1) = X5_CHAVE) + 	  "
_cQry	+= "				(SELECT LEFT(X5_DESCRI,2) FROM " + RetSqlName("SX5") + " WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD'"
_cQry	+= "	AND SUBSTRING(RTRIM(ZZ4_CARCAC),6,1) = X5_CHAVE)+ '01' ,ZZ4.ZZ4_NFEDT) MES_GARA  "
_cQry	+= " FROM " + RetSqlName("ZZ4") + " ZZ4 (nolock) "
_cQry	+= " LEFT JOIN " + RetSqlName("SZA") + " SZA (nolock) "
_cQry	+= " ON(ZZ4.ZZ4_CODCLI = SZA.ZA_CLIENTE AND ZZ4.ZZ4_LOJA = SZA.ZA_LOJA AND ZZ4.ZZ4_CODPRO = SZA.ZA_CODPRO AND ZZ4.ZZ4_IMEI = SZA.ZA_IMEI "
_cQry	+= " AND ZZ4.ZZ4_NFENR = SZA.ZA_NFISCAL AND ZZ4.ZZ4_NFESER = SZA.ZA_SERIE AND ZZ4.ZZ4_FILIAL = SZA.ZA_FILIAL"
_cQry	+= "	AND ZZ4.D_E_L_E_T_ = SZA.D_E_L_E_T_) "
_cQry	+= " WHERE ZZ4.ZZ4_FILIAL = '"+XFILIAL("ZZ4")+"'  " + ENTER 
_cQry	+= " AND ZZ4.ZZ4_IMEI = '"+_NumImei+"' "
_cQry	+= " AND ZZ4.ZZ4_OS = '"+_NumOs+"' "
_cQry	+= " AND ZZ4.D_E_L_E_T_ = '' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY1", .F., .T.)

_cDef	:= "SELECT ZZG_RECCLI RECCLI FROM "
_cDef	+= RetSqlName("ZZG")
_cDef	+= " WHERE D_E_L_E_T_ = '' AND ZZG_LAB = 2 AND ZZG_CODIGO = '"+Left(AllTrim(QRY1->DEFEITO),5)+"' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, _cDef), "QRY3", .F., .T.)

IF Alltrim(QRY1->GARANT) == 'N' .And. AllTrim(QRY1->COD) $ _cSpr .And. Transform(QRY1->MES_GARA, "@E 99") $ _cPsq .And. IIF(_lspc433,AllTrim(QRY1->PFOUND) $ _cSpf, Iif (!Empty(QRY3->RECCLI), AllTrim(QRY3->RECCLI) <> 'C0022', .F.))
	_cQry1	:=" SELECT ZA_CLIENTE CLIENTE "
	_cQry1	+=" FROM " + RetSqlName("SZA") + " SZA (nolock) "
	_cQry1	+=" WHERE ZA_FILIAL = '"+xFilial("SZA")+"' " + ENTER
	_cQry1	+=" AND ZA_CLIENTE = '"+QRY1->CODCLI+"' "
	_cQry1	+=" AND ZA_LOJA = '"+QRY1->LOJA+"' "
	_cQry1	+=" AND ZA_NFISCAL = '"+QRY1->NFE+"' "
	//_cQry1	+=" AND ZA_SERIE = '"+QRY1->SERIE+"' "
	_cQry1	+=" AND ZA_IMEI = '"+QRY1->IMEI+"' "
	_cQry1	+=" AND ZA_STATUS = 'V' "
	_cQry1	+=" AND D_E_L_E_T_ = '' "
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry1), "QRY2", .F., .T.)
	If Empty(QRY2->CLIENTE)
		RecLock("SZA",.T.)
		SZA->ZA_FILIAL 	:= xfilial("SZA")
		SZA->ZA_CLIENTE	:= QRY1->CODCLI
		SZA->ZA_LOJA 	:= QRY1->LOJA
		SZA->ZA_NFISCAL	:= QRY1->NFE
		SZA->ZA_SERIE 	:= QRY1->SERIE
		SZA->ZA_DATA 	:= QRY1->DTENTRA
		SZA->ZA_IMEI 	:= QRY1->IMEI
		SZA->ZA_CODPRO 	:= QRY1->COD
		SZA->ZA_STATUS 	:= "V"
		SZA->ZA_SPC 	:= IIF(_lspc433,"SPC0000433","")
		SZA->ZA_EXECAO	:= "S"
		MsUnLock()
	Else
		cQryExec := " UPDATE " + RetSqlName("SZA") + " SET"
		If _lspc433
			cQryExec += " ZA_SPC = 'SPC0000433', "
		Endif
		cQryExec += " ZA_EXECAO = 'S', ZA_NOMUSER = '" + AllTrim(cUserName) + "-" + DtoC(dDataBase) + "-" + Time() + "' " + ENTER 
		cQryExec += " WHERE ZA_FILIAL = '"+xFilial("SZA")+"' " + ENTER
		cQryExec += " AND ZA_CLIENTE = '"+QRY1->CODCLI+"' " + ENTER 
		cQryExec += " AND ZA_LOJA = '"+QRY1->LOJA+"' " + ENTER 
		cQryExec += " AND ZA_NFISCAL = '"+QRY1->NFE+"' " + ENTER 
		//cQryExec += " AND ZA_SERIE = '"+QRY1->SERIE+ "' " + ENTER 
		cQryExec += " AND ZA_IMEI = '"+QRY1->IMEI+"' " + ENTER 
		cQryExec += " AND ZA_STATUS = 'V' " + ENTER 
		cQryExec += " AND D_E_L_E_T_='' "
		TcSQlExec(cQryExec)
		TCRefresh(RETSQLNAME("SZA"))
	EndIf
	_cQryGaran := " UPDATE  " + RetSqlName("ZZ4")
	_cQryGaran += " SET ZZ4_GARANT = 'S', ZZ4_TRANSC = '"+Iif(_lspc433,"IRF","IXT")+"' "
	_cQryGaran += " WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " + ENTER
	_cQryGaran += " AND ZZ4_CODCLI = '"+QRY1->CODCLI+ "' "
	_cQryGaran += " AND ZZ4_LOJA = '"+QRY1->LOJA+"' "
	_cQryGaran += " AND ZZ4_IMEI = '"+QRY1->IMEI+"' "
	_cQryGaran += " AND ZZ4_CARCAC = '"+QRY1->CARCAC+"' "
	_cQryGaran += " AND ZZ4_OS  = '"+QRY1->ORDSERV+"' "
	_cQryGaran += " AND ZZ4_STATUS < '8' "
	_cQryGaran += " AND D_E_L_E_T_='' "
	TcSQlExec(_cQryGaran)
	TCRefresh(RETSQLNAME("ZZ4"))
	_lRet := .T.
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf

Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROREPA  º Autor ³Paulo Lopez         º Data ³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS DEFEITO INFORMADO PELO CLIENTE              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROREPA(cImei,cOs,cLab)
Local   cQryExec
Local  _cQryExec
Local   cQryExec1
Local  _cQryExec1
Local 	cProble
Local 	cReparo
Local _aAreaZZ4  := ZZ4->(GetArea())
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf
If Select("QRY5") > 0
	QRY5->(dbCloseArea())
EndIf
If Select("QRY6") > 0
	QRY6->(dbCloseArea())
EndIf
If Select("QRY7") > 0
	QRY7->(dbCloseArea())
EndIf
If Select("QRY8") > 0
	QRY8->(dbCloseArea())
EndIf
cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + ENTER
cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
cQryExec	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
cQryExec	+= "AND ZL.ZL_CODPROB <> 'P0021' " + ENTER
cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
cQryExec	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec), "QRY1", .F., .T.)

cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + ENTER
cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
cQryExec1	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER 
cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY1->REPA+"' " + ENTER
cQryExec1	+= "AND ZL.ZL_CODPROB <> 'P0021' " + ENTER
cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
cQryExec1	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + ENTER

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec1), "QRY2", .F., .T.)

If Len(AllTrim(QRY1->REPA))>0
	cproblem 	:= QRY2->PROB
	creparo		:= QRY1->REPA
Else
	
	_cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + ENTER
	_cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
	_cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
	_cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
	_cQryExec	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
	_cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
	_cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
	_cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
	_cQryExec	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
	_cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + ENTER

	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryExec), "QRY3", .F., .T.)
	
	_cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + ENTER
	_cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
	_cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
	_cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODSINT AND Z3.ZZ3_ACAO = ZL.ZL_CODREPA AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
	_cQryExec1	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
	_cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
	_cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY3->REPA+"' " + ENTER
	_cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
	_cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
	_cQryExec1	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
	_cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + ENTER
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryExec1), "QRY4", .F., .T.)
	
	cproblem 	:= 	QRY4->PROB
	creparo		:=	QRY3->REPA
	
EndIf

If Empty(AllTrim(cproblem)) .And. Empty(AllTrim(creparo))
	
	cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + ENTER
	cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
	cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
	cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
	cQryExec	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
	cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
	cQryExec	+= "AND ZL.ZL_CODPROB <> 'P0021' " + ENTER
	cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
	cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
	cQryExec	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
	cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + ENTER
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec), "QRY5", .F., .T.)
	
	cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + ENTER
	cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
	cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
	cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
	cQryExec1	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
	cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
	cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY5->REPA+"' " + ENTER
	cQryExec1	+= "AND ZL.ZL_CODPROB <> 'P0021' " + ENTER
	cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
	cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
	cQryExec1	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
	cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + ENTER
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryExec1), "QRY6", .F., .T.)
	
	If Len(AllTrim(QRY5->REPA))>0
		cproblem 	:= QRY6->PROB
		creparo		:= QRY5->REPA
	Else
		
		_cQryExec	:= "SELECT TOP 1 ZL_CODIGO REPA " + ENTER
		_cQryExec	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
		_cQryExec	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
		_cQryExec	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
		_cQryExec	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
		_cQryExec	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
		_cQryExec	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
		_cQryExec	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
		_cQryExec	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
		_cQryExec	+= "ORDER BY ZL.ZL_GRAU DESC " + ENTER
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryExec), "QRY7", .F., .T.)
		
		_cQryExec1	:= "SELECT TOP 1 ZL.ZL_CODPROB PROB " + ENTER
		_cQryExec1	+= "FROM " + RetSqlName("ZZ3") + " Z3(NOLOCK) " + ENTER
		_cQryExec1	+= "INNER JOIN " + RetSqlName("SZL") + " ZL(NOLOCK) " + ENTER
		_cQryExec1	+= "ON (Z3.ZZ3_DEFDET = ZL.ZL_CODPROB AND Z3.ZZ3_ACAO = ZL.ZL_CODIGO AND ZL.D_E_L_E_T_ = Z3.D_E_L_E_T_  ) " + ENTER
		_cQryExec1	+= "WHERE Z3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_IMEI = '" + cimei + "' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_NUMOS = '" + Left(cos,6) + "' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_DEFDET <> '' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_ESTORN <> 'S' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_ACAO <> '' " + ENTER
		_cQryExec1	+= "AND Z3.ZZ3_ACAO <> 'R0000' " + ENTER
		_cQryExec1	+= "AND ZL.ZL_CODIGO = '"+QRY7->REPA+"' " + ENTER
		_cQryExec1	+= "AND ZL.ZL_CLIENTE = '" + cLab + "' " + ENTER
		_cQryExec1	+= "AND ZL.ZL_MSBLQL != '1' " + ENTER
		_cQryExec1	+= "AND Z3.D_E_L_E_T_ = '' " + ENTER
		_cQryExec1	+= "ORDER BY Z3.R_E_C_N_O_ " + ENTER
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryExec1), "QRY8", .F., .T.)
		
		cproblem 	:= 	QRY8->PROB
		creparo		:=	QRY7->REPA
		
	EndIf
	
EndIf

ZZ4->(dbsetorder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
If ZZ4->(DbSeek(xFilial("ZZ4") + cImei + cOs))
	
	Begin Transaction
	RecLock('ZZ4',.F.)
	
	ZZ4->ZZ4_PROBLE := AllTrim(cproblem)
	ZZ4->ZZ4_REPAIR	:= AllTrim(creparo)
	
	MsUnlock()
	End Transaction
	
EndIf

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf
If Select("QRY3") > 0
	QRY3->(dbCloseArea())
EndIf
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf

RestArea(_aAreaZZ4)

Return(cproblem,creparo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AJUSTRANº Autor ³Hudson de Souza Santos ºData³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ajusta o defeito informado da ZZ4 caso aparelho esteja em   º±±
±±º          ³Garantia.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjusTran(cIMEI)
Local _cQryTran	:= ""
Local _cUPDZZ4	:= ""
Local _cUPDZZM	:= ""
If Select("QRY9") > 0
	QRY9->(dbCloseArea())
EndIf
_cQryTran	:= " SELECT"
_cQryTran	+= "  ZZ4.R_E_C_N_O_ as ZZ4_RECNO,"
_cQryTran	+= "  ZZM_1.R_E_C_N_O_ as ZZM_RECNO,"
_cQryTran	+= "  ZZ4.ZZ4_STATUS,"
_cQryTran	+= "  ZZ4_FILIAL, rtrim(ltrim(ZZ4_IMEI)) as ZZ4_IMEI, ZZ4_OS,"
_cQryTran	+= "  ZZ4_TRANSC, ZZ4_GARMCL,"
_cQryTran	+= "  ZZ4_GARANT,"
_cQryTran	+= "  ZZ4_DEFINF,"
_cQryTran	+= "  isnull(isnull(ZZM_2.ZZM_DEFINF,ZZM_1.ZZM_DEFINF),'') as ZZM_DEFINF,"
_cQryTran	+= "  isnull(isnull(ZZM_2.ZZM_MSBLQL,ZZM_1.ZZM_MSBLQL),'') as ZZM_MSBLQL,"
_cQryTran	+= "  ZZG.ZZG_RECCLI,"
_cQryTran	+= "  SZA.ZA_GARNFC,"
_cQryTran	+= "  SZA.ZA_GARNFT,"
_cQryTran	+= "  ZZ4_OPEBGH"
_cQryTran	+= " FROM " + RetSqlName("ZZ4") + " as ZZ4(NOLOCK)"
_cQryTran	+= " left join " + RetSqlName("ZZM") + " as ZZM_2 ON ZZM_2.D_E_L_E_T_ = ''"
_cQryTran	+= "  AND ZZM_2.ZZM_LAB = '2'"
_cQryTran	+= "  AND ZZM_2.ZZM_MSBLQL = '2'"
_cQryTran	+= "  AND ZZM_2.ZZM_FILIAL = ZZ4.ZZ4_FILIAL"
_cQryTran	+= "  AND ZZM_2.ZZM_IMEI = ZZ4.ZZ4_IMEI"
_cQryTran	+= " left join " + RetSqlName("ZZM") + " as ZZM_1 ON ZZM_1.D_E_L_E_T_ = ''"
_cQryTran	+= "  AND ZZM_1.ZZM_LAB = '2'"
_cQryTran	+= "  AND ZZM_1.ZZM_FILIAL = ZZ4.ZZ4_FILIAL"
_cQryTran	+= "  AND ZZM_1.ZZM_IMEI = ZZ4.ZZ4_IMEI"
_cQryTran	+= "  AND ZZM_1.R_E_C_N_O_ = ("
_cQryTran	+= "    SELECT max(AUX.R_E_C_N_O_) FROM " + RetSqlName("ZZM") + " as AUX"
_cQryTran	+= "    WHERE AUX.D_E_L_E_T_ = ''"
_cQryTran	+= "     AND AUX.ZZM_FILIAL = ZZM_1.ZZM_FILIAL"
_cQryTran	+= "     AND AUX.ZZM_LAB = ZZM_1.ZZM_LAB"
_cQryTran	+= "     AND AUX.ZZM_IMEI = ZZM_1.ZZM_IMEI)"
_cQryTran	+= " left join " + RetSqlName("ZZG") + " as ZZG(NOLOCK) ON ZZG.D_E_L_E_T_ = ''"
_cQryTran	+= "  AND ZZ4.ZZ4_DEFINF = ZZG.ZZG_CODIGO"
_cQryTran	+= "  AND ZZG.ZZG_LAB = '2'"
_cQryTran	+= " inner join " + RetSqlName("SZA") + " as SZA(NOLOCK) ON SZA.D_E_L_E_T_ = ''"
_cQryTran	+= "  AND SZA.ZA_FILIAL = ZZ4.ZZ4_FILIAL"
_cQryTran	+= "  AND SZA.ZA_CLIENTE = ZZ4.ZZ4_CODCLI"
_cQryTran	+= "  AND SZA.ZA_LOJA = ZZ4.ZZ4_LOJA"
_cQryTran	+= "  AND SZA.ZA_NFISCAL = ZZ4.ZZ4_NFENR"
_cQryTran	+= "  AND SZA.ZA_SERIE = ZZ4.ZZ4_NFESER"
_cQryTran	+= "  AND SZA.ZA_IMEI = ZZ4.ZZ4_IMEI"
_cQryTran	+= " WHERE ZZ4.D_E_L_E_T_ = ''"
_cQryTran	+= "  AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "'"
_cQryTran	+= "  AND ZZ4_IMEI = '" + cIMEI + "'"
_cQryTran	+= "  AND ZZ4.ZZ4_STATUS <= '5'"
_cQryTran	+= "  AND ZZ4.ZZ4_OPEBGH = 'N09'"
_cQryTran	+= "  AND ZZ4.ZZ4_GARANT = 'N'"
_cQryTran	+= "  AND ZZ4_DEFINF <> ''"
_cQryTran	+= "  AND ZZ4_TRANSC <> 'IOW'"
_cQryTran	+= "  AND (ZZ4_DEFINF = substring(ZZM_2.ZZM_DEFINF,1,5) OR (ZZM_2.ZZM_DEFINF IS NULL AND ZZ4_DEFINF = substring(ZZM_1.ZZM_DEFINF,1,5)))"
_cQryTran	+= "  AND ZZG_RECCLI <> 'C0022'"
_cQryTran	+= "  AND (SZA.ZA_GARNFC = 'S' OR SZA.ZA_GARNFT = 'S')"
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryTran), "QRY9", .F., .T.)
If !Empty(QRY9->ZZ4_RECNO)
	_cUPDZZ4 := "UPDATE " + RetSqlName("ZZ4") + " SET ZZ4_DEFINF = '', ZZ4_TRANSC = 'IRS', ZZ4_GARMCL = 'S' WHERE R_E_C_N_O_ = " + Transform(QRY9->ZZ4_RECNO,"@e 9999999999")
	TcSQlExec(_cUPDZZ4)
	TCRefresh(RETSQLNAME("ZZ4"))
	If QRY9->ZZM_MSBLQL == "1"
		_cUPDZZM := "UPDATE " + RetSqlName("ZZM") + " SET ZZM_MSBLQL = '2' WHERE R_E_C_N_O_ = " + Transform(QRY9->ZZM_RECNO,"@e 9999999999")
		TcSQlExec(_cUPDZZM)
		TCRefresh(RETSQLNAME("ZZM"))
	EndIf
EndIf
If Select("QRY9") > 0
	QRY9->(dbCloseArea())
EndIf
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRAVDEF  º Autor ³Paulo Lopez         º Data ³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ATUALIZA CAMPOS DEFEITO INFORMADO PELO CLIENTE              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravDef(cIMEI)

Local _cQryDef
Local _ExecDef
Local _ExecDef1
Local _ExecDef2
Local _ExecDef3
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf
_cQryDef := "SELECT  ZM.ZZM_IMEI	AS ZM_IMPIMEI, " + ENTER
_cQryDef += "		ZM.ZZM_DEFINF	AS ZM_DEFINF, " + ENTER
_cQryDef += "		ZM.R_E_C_N_O_	AS ZM_RECNO, " + ENTER
_cQryDef += "		ZZ4.ZZ4_IMEI	AS Z4_IMEI, " + ENTER
_cQryDef += "		ZZ4.ZZ4_DEFINF	AS Z4_DEFINF, " + ENTER
_cQryDef += "		ZZ4.ZZ4_OS		AS Z4_OS, " + ENTER
_cQryDef += "		ZZ4.ZZ4_CODCLI	AS Z4_CODCLI, " + ENTER
_cQryDef += "		ZZ4.ZZ4_LOJA	AS Z4_LOJA, " + ENTER
_cQryDef += "		ZZ4.ZZ4_CODPRO	AS Z4_CODPRO, " + ENTER
_cQryDef += "		ZZ4.ZZ4_NFENR	AS Z4_NFENR, " + ENTER
_cQryDef += "		ZZ4.ZZ4_NFESER	AS Z4_NFESER, " + ENTER
_cQryDef += "		ZZ4.ZZ4_FILIAL	AS Z4_FILIAL, " + ENTER
_cQryDef += "		ZZ4.R_E_C_N_O_	AS Z4_RECNO, " + ENTER
_cQryDef += "		ZZ4.ZZ4_CARCAC	AS Z4_CARCAC, " + ENTER
_cQryDef += "		ZZ4.ZZ4_OPEBGH	AS Z4_OPEBGH, " + ENTER
_cQryDef += "		ZZ4.ZZ4_GARANT	AS Z4_GARANT " + ENTER
_cQryDef += "FROM " + RetSqlName("ZZM") + " ZM (NOLOCK) " + ENTER
_cQryDef += "INNER JOIN " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
_cQryDef += "ON(ZM.ZZM_IMEI = ZZ4.ZZ4_IMEI  AND ZZ4.D_E_L_E_T_ = ZM.D_E_L_E_T_ AND ZZ4.ZZ4_FILIAL = ZM.ZZM_FILIAL) " + ENTER
_cQryDef += "WHERE ZZ4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"' " + ENTER
_cQryDef += "AND ZZ4.ZZ4_IMEI = '"+cIMEI+"' " + ENTER
_cQryDef += "AND ZZ4.ZZ4_DEFINF = '' " + ENTER
_cQryDef += "AND ZZ4.ZZ4_STATUS < '5' " + ENTER
_cQryDef += "AND ZM.ZZM_MSBLQL = '2' " + ENTER
_cQryDef += "AND ZM.D_E_L_E_T_ = '' " + ENTER
_cQryDef += "ORDER BY 1 " + ENTER
dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQryDef), "QRY4", .F., .T.)
If !Empty(AllTrim(QRY4->ZM_DEFINF))
	_ExecDef := " UPDATE " + RetSqlName("ZZ4") + " SET ZZ4_DEFINF = '" + Substr(QRY4->ZM_DEFINF,1,5) + "' , ZZ4_SEQZZ3 = '01'"
	_ExecDef += " WHERE D_E_L_E_T_ = ''"
	_ExecDef += " AND ZZ4_FILIAL = '" + xFilial("ZZ4") + "'"
	_ExecDef += " AND ZZ4_IMEI = '" + cIMEI + "'"
	_ExecDef += " AND ZZ4_OS = '" + QRY4->Z4_OS + "'"
	TcSQlExec(_ExecDef)
	TCRefresh(RETSQLNAME("ZZ4"))
	_ExecDef1 := " UPDATE  " + RetSqlName("SZA")
	_ExecDef1 += " SET ZA_DEFRECL = '" + Substr(QRY4->ZM_DEFINF,1,5) + "' "
	_ExecDef1 += " WHERE ZA_FILIAL = '"+xFilial("SZA")+"' "
	_ExecDef1 += " AND ZA_IMEI = '"+cIMEI+"' "
	_ExecDef1 += " AND ZA_NFISCAL = '"+QRY4->Z4_NFENR+"' "
//	_ExecDef1 += " AND ZA_SERIE = '"+QRY4->Z4_NFESER+"' "
	_ExecDef1 += " AND ZA_STATUS = 'V' "
    _ExecDef1 += " AND D_E_L_E_T_ = '' "	
	TcSQlExec(_ExecDef1)
	TCRefresh(RETSQLNAME("SZA"))

	_ExecDef2 := "UPDATE " + RetSqlName("ZZM")  + ENTER
	_ExecDef2 += "SET ZZM_MSBLQL = '1' " + ENTER
	_ExecDef2 += "WHERE ZZM_FILIAL='"+xFilial("ZZM")+"' " + ENTER
	_ExecDef2 += "AND ZZM_IMEI = '"+cIMEI+"' " + ENTER
	_ExecDef2 += "AND ZZM_MSBLQL = '2' " + ENTER	
	_ExecDef2 += "AND D_E_L_E_T_ = '' " + ENTER
	TcSqlExec(_ExecDef2)
	TCRefresh(RETSQLNAME("ZZM"))

	_ExecDef3 := "UPDATE " + RetSqlName("SZA") + ENTER
	_ExecDef3 += "SET ZA_CODRECL = ZZG.ZZG_RECCLI " + ENTER
	_ExecDef3 += "FROM " + RetSqlName("SZA") + " SZA (NOLOCK) " + ENTER
	_ExecDef3 += "INNER JOIN " + RetSQlName("ZZG") + " ZZG (NOLOCK) " + ENTER
	_ExecDef3 += "ON (SZA.ZA_DEFRECL = ZZG.ZZG_CODIGO AND SZA.D_E_L_E_T_ = ZZG.D_E_L_E_T_ AND ZZG.ZZG_LAB = '2' AND ZZG.ZZG_FILIAL = '') " + ENTER
	_ExecDef3 += "WHERE SZA.ZA_FILIAL='"+xFilial("SZA")+"' " + ENTER
	_ExecDef3 += "AND SZA.ZA_IMEI = '"+cIMEI+"' " + ENTER
	_ExecDef3 += "AND SZA.ZA_DEFRECL != '' " + ENTER
	_ExecDef3 += "AND ZZG.ZZG_RECCLI ! ='' " + ENTER
	_ExecDef3 += "AND SZA.D_E_L_E_T_ = '' " + ENTER
	TcSqlExec(_ExecDef3)
	TCRefresh(RETSQLNAME("SZA"))
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerto do campo garantia de acordo com NF Troca / Compra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QRY4->Z4_GARANT == "N"
	_ExecGar := " UPDATE " + RetSqlName("ZZ4") + " SET ZZ4_GARANT ="
	_ExecGar += " CASE WHEN ZZ4.ZZ4_GARANT = 'S' THEN 'S'"
	_ExecGar += " WHEN ZZ4.ZZ4_GARANT <> 'S'"
	_ExecGar += " AND (isnull(SZA.ZA_GARNFC,'') = 'S' OR isnull(SZA.ZA_GARNFT,'') = 'S')"
	_ExecGar += " AND ZZ4.ZZ4_OPEBGH = 'N09'"
	_ExecGar += " AND NOT('" + Alltrim(Substr(QRY4->ZM_DEFINF,1,5)) + "' = '' OR isnull(ZZG.ZZG_RECCLI,'') = 'C0022')"
	_ExecGar += " THEN 'S' ELSE 'N' END"
	_ExecGar += " FROM " + RetSqlName("ZZ4") + " as ZZ4(NOLOCK)"
	_ExecGar += " left join " + RetSqlName("SZA") + " as SZA(NOLOCK) ON SZA.D_E_L_E_T_ = ''"
	_ExecGar += " AND SZA.ZA_FILIAL = ZZ4.ZZ4_FILIAL"
	_ExecGar += " AND SZA.ZA_CLIENTE = ZZ4.ZZ4_CODCLI"
	_ExecGar += " AND SZA.ZA_LOJA = ZZ4.ZZ4_LOJA"
	_ExecGar += " AND SZA.ZA_NFISCAL = ZZ4.ZZ4_NFENR"
	_ExecGar += " AND SZA.ZA_SERIE = ZZ4.ZZ4_NFESER"
	_ExecGar += " AND SZA.ZA_IMEI = ZZ4.ZZ4_IMEI"
	_ExecGar += " left join " + RetSqlName("ZZG") + " as ZZG(NOLOCK) ON ZZG.D_E_L_E_T_ = ''"
	_ExecGar += " AND ZZG.ZZG_LAB = '2'"
	_ExecGar += " AND ZZG.ZZG_CODIGO = '" + Alltrim(Substr(QRY4->ZM_DEFINF,1,5)) + "'"
	_ExecGar += " WHERE ZZ4.D_E_L_E_T_ = ''"
	_ExecGar += " AND ZZ4.ZZ4_STATUS <> '9'  "
	_ExecGar += " AND ZZ4.ZZ4_IMEI = '"+cIMEI+"'  "
	_ExecGar += " AND ZZ4.ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	TcSQlExec(_ExecGar)
	TCRefresh(RETSQLNAME("ZZ4"))
EndIf
If Select("QRY4") > 0
	QRY4->(dbCloseArea())
EndIf
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LEGENDA  º Autor ³Paulo Lopez         º Data ³  08/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³LEGENDA                                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Legenda()

IF date() >= ctod('01/01/12')
	BrwLegenda("Conferência de Entrada","Legenda",{{"ENABLE"    	,"IMEI em Garantia !!!"},;
	{"BR_AMARELO"  	,"IMEI atende especificação SPC0000456!!! "},;
	{"BR_AZUL"  	,"IMEI dentro da extensão de garantia motorola, transaction code IXT!!! "},;
	{"BR_PINK"  	,"IMEI atende Nf de Troca/Reparo/OS !!! "},;
	{"DISABLE"   	,"IMEI fora de Garantia !!! "},;
	{"BR_CANCEL"	,"Equipamento sem Def. Inf. Cliente !!!"}})
Else
	BrwLegenda("Conferência de Entrada","Legenda",{{"ENABLE"    	,"IMEI em Garantia !!!"},;
	{"BR_AMARELO"  	,"IMEI atende especificação SPC0000456!!! "},;
	{"BR_AZUL"  	,"IMEI atende especificação SPC0000433!!! "},;
	{"BR_PINK"  	,"IMEI atende Nf de Troca/Reparo/OS !!! "},;
	{"DISABLE"   	,"IMEI fora de Garantia !!! "},;
	{"BR_CANCEL"	,"Equipamento sem Def. Inf. Cliente !!!"}})
EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCRIASX1  º Autor ³Paulo Lopez         º Data ³  08/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³GERA DICIONARIO DE PERGUNTAS                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCriaSX1()

dbSelectArea("SX1")
dbSetOrder(1)
aSX1 := {}

aAdd(aSx1,{cPerg,"01","Tipo de Nf ? ","","","mv_ch1","N",01,0,0,"C","","mv_par01","Nf de Compras","","","","","Nf de Troca","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega as Perguntas no SX1                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
ValidPerg(aSX1,cPerg)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETIQCHEC º Autor ³Paulo Lopez         º Data ³  16/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ETIQUETA CHECK LIST NEXTEL - MOTOROLA                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FILD - SERVICES                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ETIQCHEC(_nOs, _nImei, _cMod, _cStat, _cOper, _cGar, _cBoun, _nDef, _cDesc, _cCarc, _dEntMas,_cRegZZ4)
Local _aLin 	:= {03,07,11,15,19,23,27}
Local _aCol 	:= {05,17,20,60,80}  //05,30
Local _cfont 	:= "0"
Local _afont	:={"020,030","025,035","055,075","065,085","090,090","100,100","110,110"}
Local _operdescri
Local _operdes
Local _cStatus
Local _cGara
Local _cPorta   := "LPT1:"
Local _cdata 	:= substr(dtos(ddatabase),7,2)+'/'+substr(dtos(ddatabase),5,2)+'/'+left(dtos(ddatabase),4)
Local aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Local aAreaZZ4  := ZZ4->(GetArea())
Local lGrava	:= .F.
Local lRet		:= .T.
ZZ4->(DbSelectArea("ZZ4"))
ZZ4->(DbGoTo(_cRegZZ4))
If ZZ4->ZZ4_OPEBGH $ AllTrim(GetMv('ZZ_OPERETQ'))

	If Alltrim(ZZ4->ZZ4_CARCAC)==Alltrim(GETMV("MV_SNPADR"))
		MsgAlert("Etiqueta não será gerada! Contate seu supervisor - Serial Number Padrão!")
		Return .F.	
	Else
		If Empty(ZZ4->ZZ4_IETQMA)
			lGrava := .T.
		Else
			lRet := u_GerA0001("Nextellider","Etiqueta já gerada, contate seu supervisor para liberação desta impressão ! -> "+ZZ4->ZZ4_IETQMA , .F.)
			If !lRet
				Return .F.
			Else
				lGrava := .T.
			EndIf
		EndIf
	Endif
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica porta de impressao                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !IsPrinter(_cPorta)
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara Variaveis                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_operdes	:=Posicione("ZZJ",1,xFilial("ZZJ") + ALLTRIM(_cOper), "ZZJ_DESCRI")
If Left(_operdes,6) $ "NEXTEL"
	_operdescri	:=Substr(_operdes,9,20)
Else
	_operdescri	:= _operdes
EndIf
If allTrim(_cStat) == "1"
	_cStauts := "Entrada Apontada"
ElseIf allTrim(_cStat) == "2"
	_cStauts := "Entrada Confirmada"
ElseIf allTrim(_cStat) == "3"
	_cStauts := "NFE Gerada"
ElseIf allTrim(_cStat) == "4"
	_cStauts := "Em atendimento"
ElseIf allTrim(_cStat) == "5"
	_cStauts := "OS Encerrada"
ElseIf allTrim(_cStat) == "6"
	_cStauts := "Saida Lida"
ElseIf allTrim(_cStat) == "7"
	_cStauts := "Saida Apontada"
ElseIf allTrim(_cStat) == "8"
	_cStauts := "PV Gerado"
ElseIf allTrim(_cStat) == "9"
	_cStauts := "NFS Gerada"
EndIf
If AllTrim(_cGar) == 'S' .And. _cImpGa
	_cGara := "GAR"
Else
	_cGara := "FOG"
EndIf
_nQtdeEtiq := 1
For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado a entrar com NF-Compras
	If AllTrim(GRPRetName(aGrupos[i])) == "Imp_Etiq_Duplicada"
		_nQtdeEtiq := 2
	EndIf
Next i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura da Matriz                                                         ³
//³ 01 - IMEI                                                                   ³
//³ 02 - Numero da OS                                                           ³
//³ 03 - Modelo do Equipamento                                                  ³
//³ 04 - Status do Equipamento                                                  ³
//³ 05 - Operação do Equipamento                                                ³
//³ 06 - Garantia do Equipamento S/N                                            ³
//³ 07 - Data de Entrada                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For x:=1 to _nQtdeEtiq
	MSCBPRINTER("S300",_cPorta,,022,.F.,,,,,,.T.)
	MSCBBEGIN(1,6)
	//                                  direcao fonte   tamanho
	If !ZZ4->ZZ4_OPEBGH $ AllTrim(GetMv('ZZ_OPERETQ')) &&Caso não esteja na relação de operaçoes a bloquear, rotina imprime os codigos de barras
		MSCBSAYBAR	( _aCol[1],_aLin[1],AllTrim(_nImei),"N","MB07",3,.F.,.F.,.F.,,2,1)
		MSCBSAYBAR	( _aCol[5],_aLin[1],AllTrim(_cCarc),"N","MB07",3,.F.,.F.,.F.,,2,1)
	EndIf
	MSCBSAY		( _aCol[1],_aLin[2],"IMEI: " + alltrim(_nImei) ,"N",_cfont,_afont[2])
	MSCBSAY		( _aCol[5],_aLin[2],"S/N: " + alltrim(_cCarc) ,"N",_cfont,_afont[2])
	MSCBSAYBAR	( _aCol[1],_aLin[3],_cMod,"N","MB07",3,.F.,.F.,.F.,,2,1)
	MSCBSAYBAR	( _aCol[5],_aLin[3],_nOs,"N","MB07",3,.F.,.F.,.F.,,2,1)
	If !Empty(AllTrim(_dEntMas))
		MSCBSAY		( _aCol[1],_aLin[4]," Modelo: "   + AllTrim(_cMod) + " Data Ent.: " + TransForm(_dEntMas, "@E 99/99/9999"),"N",_cfont,_afont[2])
	Else
		MSCBSAY		( _aCol[1],_aLin[4]," Modelo: "   + AllTrim(_cMod),"N",_cfont,_afont[2])
	EndIf
	MSCBSAY		( _aCol[5],_aLin[4],"Numero da OS: " + AllTrim(_nOs) ,"N",_cfont,_afont[2])
	MSCBSAY		( _aCol[1],_aLin[5]," Operacao: " + AllTrim(_cOper)   	+ '-'+ Alltrim(_operdescri),"N",_cfont,_afont[2])
	MSCBSAY		( _aCol[5],_aLin[5]," Data Atend.: " + _cdata,"N",_cfont,_afont[2])  // Coluna 2 - Linha 2
	MSCBSAY		( _aCol[1],_aLin[6]," Status: "  + AllTrim(_cStauts) 	+ '   ' + " Bounce: "  + Transform(_cBoun, "@E 999") + '   ' + "Garantia: " + AllTrim(_cGara),"N",_cfont,_afont[2])
	MSCBSAY		( _aCol[1],_aLin[7]," Def. Inf. : "  + Transform(_nDef, "@E 99999") + ' - ' + AllTrim(_cDesc) ,"N",_cfont,_afont[2])
	MSCBEnd()
	MSCBCLOSEPRINTER()
Next
If ZZ4->ZZ4_OPEBGH $ AllTrim(GetMv('ZZ_OPERETQ'))
	If lGrava
		RecLock("ZZ4",.F.)
			ZZ4->ZZ4_IETQMA := AllTrim(cUserName) +"("+ dToc(date())+" - "+Time()+")"
		MsUnlock()
	EndIf
EndIf
RestArea(aAreaZZ4)
Return()