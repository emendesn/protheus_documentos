#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "APVT100.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Tecax016 บ Autor ณPaulo Lopez         บ Data ณ  08/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSaida massiva pelo Cod. Master / Tela de Insercao           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ11/10/2011บDiego Fernandes   บImplanta็ใo da Radio Frequencia          บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Tecax016()
Local nOpcao := 0
Local aButtons    	:= {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracoes das variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oDlgCgar
Private cMASS  		:= Space(12)
Private nCount		:= 0
Private _aHeader  	:= {}
Private _aColumns 	:= {}
Private _aDados	 	:= {}
Private _aMass		:= {}
Private _cSts		:= .T.
Private _lrotaut	:= .F.
Private _nCount		:= 0
Private _nCountx	:= 0
Private _lRet		:= .F.
Private _cQtd		:= GetMv("MV_QTDETQM") 				 // Quantidade de Equipamentos para Impressใo Etiquetas Master          
Private lRf         := IsTelnet() .And. VtModelo() == "RF"// Implanta็ใo Radio Frequencia - 11/10/11
Private aLidos 		:= {}
Private lMudOs		:= .F.

u_GerA0003(ProcName())
If ApMsgYesNo("Saida para Mudan็a BGH?","Mudan็a BGH")  
	cMASS  		:= Space(20)		
	lMudOs		:= .T.
Else
	If UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_CONSKIT",.F.,"LEANDRO.CASTANHARO"))
		If ApMsgYesNo("Deseja consultar Saldo do KIT?","Consulta Saldo do KIT")
			U_BCONSKIT()
			If !ApMsgYesNo("Deseja continuar na Saida Master?","Saida Master")
				Return()	
			Endif
		Endif
	Endif
Endif


If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf
If Select("QRY2") > 0
	QRY2->(dbCloseArea())
EndIf                                                                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtiva consulta das etiquetas lidas		 ณ
//ณImplanta็ใo Radio Frequencia - 13/10/2011 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If IsTelNet()
	bkey02 := VTSetKey(2,{|| MostraLids() }) //CTRL - B
EndIf	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Montagem da Query Com Status 6                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry	:= " SELECT ZZ4.ZZ4_IMEI	AS IMEI,	" + ENTER
cQry	+= "		ZZ4.ZZ4_CARCAC	AS CARC,  	" + ENTER
cQry	+= "		ZZ3.ZZ3_CARDU	AS CARDU,  	" + ENTER

cQry	+= "		ZZ4.ZZ4_CODCLI	AS CODCLI, 	" + ENTER
cQry	+= "		ZZ4.ZZ4_LOJA	AS LOJA,  	" + ENTER

cQry	+= "		ZZ4.ZZ4_CODPRO	AS CODPRO, 	" + ENTER
cQry	+= "		ZZ4.ZZ4_OS		AS OS, 		" + ENTER
cQry	+= "		ZZ4.ZZ4_ETQMAS	AS ETQ,  	" + ENTER
cQry	+= "		ZZ4.ZZ4_OPEBGH	AS OPERA,	" + ENTER
cQry	+= "		ZZ4.ZZ4_STATUS	AS STATUS, 	" + ENTER
cQry	+= "		SA1.A1_EST		AS EST   	" + ENTER
cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
cQry	+= "INNER JOIN " + RetSqlName("ZZ3") + " ZZ3 (NOLOCK) " + ENTER
cQry	+= "ON( ZZ4.ZZ4_FILIAL=ZZ3.ZZ3_FILIAL AND ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS AND ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ3.ZZ3_ENCOS = 'S' AND ZZ3.ZZ3_ESTORN = '' AND ZZ4.D_E_L_E_T_ = ZZ3.D_E_L_E_T_)  " + ENTER
cQry	+= "INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock)  " + ENTER
cQry	+= "ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '"+xfilial("SA1")+"' ) " + ENTER
cQry	+= "WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' "+ ENTER 
cQry	+= "AND ZZ4.D_E_L_E_T_ = ''  " + ENTER
cQry	+= "AND ZZ4.ZZ4_STATUS   = '6' " + ENTER
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry	+= "AND ZZ4.ZZ4_TRAVA   = '' " + ENTER
cQry	+= "AND ZZ4.ZZ4_ETQMAS <> ''  " + ENTER
cQry 	+= "AND SUBSTRING(ZZ4.ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER
cQry	+= "ORDER BY ZZ4.ZZ4_IMEI " + ENTER

MemoWrite("c:\SAIDMASS1.sql", cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)


cQryy	:= "SELECT COUNT(*)/' " + Transform(strzero(_cQtd,5),"@E 99999") +"' AS QTDTOT " + ENTER
cQryy	+= "FROM " + RetSqlName("ZZ4") + " ZZ4020 (NOLOCK) " + ENTER
cQryy	+= "WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' "
cQryy	+= "AND D_E_L_E_T_ = '' " + ENTER
cQryy	+= "AND ZZ4_ETQMAS <> '' " + ENTER
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQryy	+= "AND ZZ4_TRAVA   = '' " + ENTER
cQryy	+= "AND ZZ4_STATUS = '6' " + ENTER
cQryy	+= "AND SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER
cQryy	+= "GROUP BY ZZ4_STATUS " + ENTER

MemoWrite("c:\SAIDMASS2.sql", cQryy)

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryy), "QRY1", .F., .T.)
cQryx	:= "SELECT ZZ4_ETQMAS ETQ FROM " + RetSqlName("ZZ4") + " ZZ4(NOLOCK) " + ENTER
cQryx	+= "WHERE ZZ4_FILIAL='"+xfilial("ZZ4")+"' "
cQryx	+= "AND ZZ4.D_E_L_E_T_ = ''  " + ENTER
cQryx	+= "AND ZZ4.ZZ4_STATUS   = '6' " + ENTER
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQryx	+= "AND ZZ4_TRAVA   = '' " + ENTER
cQryx	+= "AND ZZ4.ZZ4_ETQMAS <> ''  " + ENTER
cQryx	+= "AND SUBSTRING(ZZ4.ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER  
cQryx	+= "GROUP BY ZZ4_ETQMAS " + ENTER

MemoWrite("c:\SAIDMASS3.sql", cQryx)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryx), "QRY2", .F., .T.)
QRY->(dbGoTop())
QRY1->(dbGoTop())
QRY2->(dbGoTop())

If  Len (AllTrim(QRY->IMEI)) > 0    //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Grava dados no Array                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("QRY")
	dbGoTop()
	While !EOF("QRY")
		aAdd(_aDados,{	QRY->IMEI, QRY->CARC, QRY->CARDU, QRY->CODPRO, QRY->OS, QRY->ETQ, QRY->OPERA, QRY->STATUS, QRY->EST, QRY->CODCLI, QRY->LOJA })
		If _cSts
			_cSts := Iif(QRY->STATUS $ "6" , .T., .F.)
		EndIf
		_nCount ++
		dbSelectArea("QRY")
		dbSkip()
	EndDo
	QRY->(dbCloseArea())
	nCount := QRY1->QTDTOT
	QRY1->(dbCloseArea())
	dbSelectArea("QRY2")
	dbGoTop()
	While !EOF("QRY2")
		aAdd(_aMass,{	QRY2->ETQ	})
		dbSelectArea("QRY2")
		dbSkip()
	EndDo
	QRY2->(dbCloseArea())
Endif


aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )	
	
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
nGetLin := aPosObj[3,1]

Aadd(aButtons,{"GRAVAR",{|| oDlgCgar:end() },"GRAVAR","GRAVAR"}) //"GRAVAR"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adapta็ใo para o coletor de dados                                      ณ
//ณ Delta Decisao - DF - 11/10/2011                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRf 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao da janela e seus conteudos                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//DEFINE MSDIALOG oDlgCgar TITLE "Saida Massiva Master" FROM 0,0 TO 210,420 OF oDlgCgar PIXEL
	DEFINE MSDIALOG oDlgCgar TITLE "Saida Massiva Master" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	@ 010+10,015 SAY   "Informe Cod. Master para Saida Massiva." 	SIZE 150,008 PIXEL OF oDlgCgar
	@ 022+10,015 SAY   "Qtd. Caixa" 	SIZE 150,008 PIXEL OF oDlgCgar
	@ 022+10,045 SAY   Transform(strzero(nCount,5),"@E 99999")	SIZE 150,008 PIXEL OF oDlgCgar
	@ 022+10,065 SAY   "Qtd. Equip." 	SIZE 150,008 PIXEL OF oDlgCgar
	@ 022+10,095 SAY   Transform(strzero(_nCount,5),"@E 99999")	SIZE 150,008 PIXEL OF oDlgCgar
	@ 035+10,015 TO 070,180 LABEL "Cod. Master" PIXEL OF oDlgCgar
	@ 045+10,025 GET cMASS PICTURE "@!" 	SIZE 080,010 Valid SaiMass01(@cMASS) Object ocodimei
	@ 045+10,130 GET "" Size 001,001 PICTURE "@!" //Tratado para atualizar o valid da variavel cvarbar
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Botoes da MSDialog                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	//@ 080,060 BUTTON "&CONFIRMA" SIZE 36,16  ACTION Processa({ || Tecax01B(), oDlgCgar:End(), Close(oDlgCgar)})
	//@ 080,100 BUTTON "&GRAVAR" SIZE 36,16  PIXEL ACTION (oDlgCgar:end())
	//@ 080,140 BUTTON "&CANCELAR" SIZE 36,16  ACTION Processa({|| Tecax01C(), oDlgCgar:End(), Close(oDlgCgar) })
	//Activate MSDialog oDlgCgar CENTER On Init ocodimei:SetFocus()
	/*
	ACTIVATE MSDIALOG oDlgCgar ON INIT EnchoiceBar(oDlgCgar,{||Tecax01B(), oDlgCgar:End(), Close(oDlgCgar)},;
	{||Tecax01C(), oDlgCgar:End(), Close(oDlgCgar)},,aButtons)
	*/
	
	ACTIVATE MSDIALOG oDlgCgar ON INIT EnchoiceBar(oDlgCgar,{|| Processa({|| IIF(ValAcess(),Tecax01B(),)},"Processando..."), oDlgCgar:End(), Close(oDlgCgar)},;
	{||Tecax01C(), oDlgCgar:End(), Close(oDlgCgar)},,aButtons)
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta tela 				   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	While .T.
		VTClear()
		VTClearBuffer()
	
		DLVTCabec("Informe Cod. Master",.F.,.F.,.T.)
		@ 01, 00 VTSay "Cod. Master"	VTGet cMASS Pict '@!' 	Valid SaiMass01(@cMASS)
		@ 02, 00 VTSay "Qtd. Caixa:"
		@ 02, 15 VTSay Alltrim(Str(nCount))
		@ 03, 00 VTSay "Qtd. Equip."
		@ 03, 15 VTSay Alltrim(Str(_nCount))
	
		VTREAD	  
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTecla ESC pressionada, lista op็๕es 	  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (VTLastKey()==27)
			nOpcao := DLVTAviso('', 'Deseja encerrar a Saida Master?', {'CONFIRMA', 'GRAVAR', 'CANCELAR'})
			Do Case
				Case nOpcao == 1  //Confirma
					Tecax01B()
				Case nOpcao == 2  //Gravar  
					Exit
				Case nOpcao == 3  //Cancelar
					Tecax01C()
			End Case 
			VTClearBuffer()
		EndIf
	
	EndDo	
EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Tecax016 บ Autor ณPaulo Lopez         บ Data ณ  08/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSaida massiva pelo Cod. Master                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function SaiMass01()

Local lRet := .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Verifica parametro IMEI esta vazio                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If !Empty(cMASS)
	
	CursorWait()
	
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Montagem da Query                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cQry	:= " SELECT ZZ4.ZZ4_IMEI	AS IMEI,	" + ENTER
	_cQry	+= "		ZZ4.ZZ4_CARCAC	AS CARC,  	" + ENTER
	_cQry	+= "		ZZ3.ZZ3_CARDU	AS CARDU,  	" + ENTER
	
	_cQry	+= "		ZZ4.ZZ4_CODCLI	AS CODCLI, 	" + ENTER
	_cQry	+= "		ZZ4.ZZ4_LOJA	AS LOJA,  	" + ENTER
	
	_cQry	+= "		ZZ4.ZZ4_CODPRO	AS CODPRO, 	" + ENTER
	_cQry	+= "		ZZ4.ZZ4_OS		AS OS, 		" + ENTER
	_cQry	+= "		ZZ4.ZZ4_ETQMAS	AS ETQ,  	" + ENTER
	_cQry	+= "		ZZ4.ZZ4_OPEBGH	AS OPERA,	" + ENTER
	_cQry	+= "		ZZ4.ZZ4_STATUS	AS STATUS, 	" + ENTER
	_cQry	+= "		SA1.A1_EST		AS EST,   	" + ENTER
	_cQry	+= "		ZZO.ZZO_NUMCX	AS MASZZO  	" + ENTER
	_cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
	_cQry	+= "INNER JOIN " + RetSqlName("ZZ3") + " ZZ3 (NOLOCK) " + ENTER
	_cQry	+= "ON(ZZ3.ZZ3_FILIAL = ZZ4.ZZ4_FILIAL AND ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS AND ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ3.ZZ3_ENCOS = 'S' AND ZZ3.ZZ3_ESTORN = '' AND ZZ4.D_E_L_E_T_ = ZZ3.D_E_L_E_T_)  " + ENTER
	_cQry	+= "INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock)  " + ENTER
	_cQry	+= "ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '"+XFILIAL("SA1")+"' ) " + ENTER
	_cQry	+= "LEFT JOIN " + RetSqlName("ZZO") + " ZZO (NOLOCK) "+ ENTER
	_cQry	+= "ON (ZZO_IMEI=ZZ4_IMEI AND ZZO_CARCAC=ZZ4_CARCAC AND ZZO_NUMCX=ZZ4_ETQMAS AND ZZO_OSFILI=ZZ4_OS AND ZZO_STATUS IN ('P','E') AND ZZO.D_E_L_E_T_ ='') "+ ENTER
	_cQry	+= "WHERE ZZ4.ZZ4_FILIAL = '"+XFILIAL("ZZ4")+"' " + ENTER
	_cQry	+= "AND ZZ4.D_E_L_E_T_ = ''  " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_STATUS   = '5' " + ENTER
	_cQry	+= "AND ZZ4.ZZ4_ETQMAS = '"+ cMASS + "'  " + ENTER
	_cQry	+= "ORDER BY ZZ4.ZZ4_IMEI " + ENTER
	
	MemoWrite("c:\SAIDMASS.sql", _cQry)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), "QRY", .F., .T.)
	
	QRY->(dbGoTop())
	
	
	If  Len (AllTrim(QRY->IMEI)) <= 0
		                              
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Adapta็ใo para o coletor de dados                                      ณ
		//ณ Delta Decisao - DF - 11/10/2011                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lRf
			CursorArrow()
			MsgStop("Caro Usuario Cod. Master Nใo Localizado ou Em Encerramento", "Alerta")
			cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
			ocodimei:SetFocus()
			Return()
		Else 
			VTBEEP(3)     
		    VTAlert("Caro Usuario Cod. Master Nใo Localizado ou Em Encerramento","Alerta",.t.,2500)
			cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
			Return()		
		EndIf	
	Endif
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Grava dados no Array                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea("QRY")
	dbGoTop()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|Verifica Estado que Esta Em Saida Massiva                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If !Empty(cMASS) .And. Len(_aDados)>0 .and. !lMudOs
		If AllTrim(_aDados[1,09]) <> QRY->EST
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Adapta็ใo para o coletor de dados                                      ณ
			//ณ Delta Decisao - DF - 11/10/2011                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !lRf
				CursorArrow()
				MsgStop("Estado Em Encerramento "+ AllTrim(_aDados[1,09]) + "  Estado Apontado " + QRY->EST , "Estado Divergente")
				cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
				ocodimei:SetFocus()
				Return()
			Else 
	 			VTBEEP(3)     
			    VTAlert("Estado Em Encerramento "+ AllTrim(_aDados[1,09]) + "  Estado Apontado","Estado Divergente",.t.,2500)
				cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
				Return()				
			EndIf	
		Endif
		
		If AllTrim(_aDados[1,10]+_aDados[1,11]) <> Alltrim(QRY->CODCLI+QRY->LOJA)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Adapta็ใo para o coletor de dados                                      ณ
			//ณ Delta Decisao - DF - 11/10/2011                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !lRf
				CursorArrow()
				MsgStop("Cliente Em Encerramento "+ AllTrim(_aDados[1,10]+" - "+_aDados[1,11]) + "  Cliente Apontado " + QRY->CODCLI+" - "+QRY->LOJA , "Cliente Divergente")
				cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
				ocodimei:SetFocus()
				Return()
			Else 
	 			VTBEEP(3)     
			    VTAlert("Cliente Em Encerramento "+ AllTrim(_aDados[1,10]+" - "+_aDados[1,11]) + "  Cliente Apontado " + QRY->CODCLI+" - "+QRY->LOJA, "Cliente Divergente",.t.,2500)
				cMASS:=IIF(lMudOs,SPACE(20),SPACE(12))
				Return()				
			EndIf	
		Endif
	EndIf
	
	While !EOF("QRY")
		
		aAdd(_aDados,{	QRY->IMEI, QRY->CARC, QRY->CARDU, QRY->CODPRO, QRY->OS, QRY->ETQ, QRY->OPERA, QRY->STATUS, QRY->EST, QRY->CODCLI, QRY->LOJA })
		
		If _cSts
			_cSts := Iif(QRY->STATUS $ "5#6" , .T., .F.)
		EndIf
		
		_nCount ++
		_nCountx ++
		
		IF LEFT(QRY->OPERA,1) <> "N" .OR. !EMPTY(QRY->MASZZO)
		   _cQtd:=_nCountx
		ENDIF
		
		dbSelectArea("QRY")
		dbSkip()
	EndDo
	
	aAdd(_aMass,{ cMASS})
	
	QRY->(dbCloseArea())
	
	CursorArrow()
	
	If Len(_aDados) < 0
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Adapta็ใo para o coletor de dados                                      ณ
		//ณ Delta Decisao - DF - 11/10/2011                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lRf
			MsgAlert("Nใo foram encontrados dados para a consulta!", "Aten็ใo")
			Return
		Else
 			VTBEEP(3)
		    VTAlert("Nใo foram encontrados dados para a consulta!","Aten็ao",.t.,2500)
			Return
		EndIf	
	EndIf
	
	nCount ++
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Grava Status 6 Conforme Regras                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Tecax01A()
	
Endif

If _lRet
                  	
	cMASS		:= IIF(lMudOs,Replicate(' ',20),Replicate(' ',12))
	_nCountx	:= 0
	If !lRf
		ocodimei:SetFocus()
	EndIf	
EndIf


Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Tecax01A บ Autor ณPaulo Lopez         บ Data ณ  08/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSaida massiva pelo Cod. Master                              บฑฑ
ฑฑบ          ณGrava Statu 6 para Saida Massiva                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Tecax01A()

If _cSts //.And. _nCountx <= _cQtd 

MsgAlert('A caixa Possui:   '+space(04) + cValtoChar(_nCountx) + space(04)+ '   Unidades')
	
	
	
	cQryExec 	:= " UPDATE " + RetSqlName("ZZ4") + ENTER
	cQryExec 	+= " SET ZZ4_STATUS = '6', ZZ4_SMUSER = '" + AllTrim(cUserName) + "',ZZ4_SMDT   = '" + DtoS(dDataBase) + "',ZZ4_SMHR = '" + Time() + "' " + 	ENTER
	cQryExec 	+= " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER 
	cQryExec 	+= " AND D_E_L_E_T_ = '' " + ENTER
	cQryExec 	+= " AND ZZ4_ETQMAS = '"+ cMASS + "'  " + ENTER
	cQryExec 	+= " AND ZZ4_STATUS = '5' " + ENTER
	
	MemoWrite("c:\exec.sql", cQryExec)
	
	TcSQlExec(cQryExec)
	//TCRefresh(RETSQLNAME("ZZ4"))
	
	
	
Endif
      

_lRet := .t.

Return(_lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Tecax01B บ Autor ณPaulo Lopez         บ Data ณ  08/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSaida massiva pelo Cod. Master                              บฑฑ
ฑฑบ          ณGrava Statu 7 para Saida Massiva                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Tecax01B()

Local nModulOld := 0

If _cSts
	
	For x := 1 to Len(_aMass)
		
		cQryExec 	:= " UPDATE " + RetSqlName("ZZ4") + ENTER
		cQryExec 	+= " SET ZZ4_STATUS = '7' " + 	ENTER
    	cQryExec 	+= " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER 
    	cQryExec 	+= " AND D_E_L_E_T_ = '' " + ENTER
		cQryExec 	+= " AND ZZ4_ETQMAS = '"+ TransForm(_aMass[x,01], IIF(lMudOs,"@E 99999999999999999999","@E 999999999999")) +  "'  " + ENTER
		cQryExec 	+= " AND ZZ4_STATUS = '6' " + ENTER    
		cQryExec	+= " AND SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER  		
		
		MemoWrite("c:\exec1.sql", cQryExec)
		
		TcSQlExec(cQryExec)
		//		TCRefresh(RETSQLNAME("ZZ4"))
		
	Next x
	
	If !lRf
		// Gera o Pedido de Vendas a partir da saida massiva
		u_tecax015(_lrotaut, lRf)
	Else		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera o Pedido de Vendas a partir da saida massiva ณ
		//ณE Necessario alterar a variacel nModulo, porque	 ณ
		//ณno ACD erros sใo gerados se utilizar o ExecAuto doณ
		//ณpedido de venda									 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nModulOld := nModulo
		nModulo   := 5 //Faturamento
		u_tecax015(_lrotaut, lRf)
		nModulo	 := nModulOld
	EndIf	
	
Endif

cMASS		:=IIF(lMudOs,Replicate(' ',20),Replicate(' ',12))
nCount 		:= 0
_nCount 	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adapta็ใo para o coletor de dados                                      ณ
//ณ Delta Decisao - DF - 11/10/2011                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRf 
	ocodimei:SetFocus()
EndIf 	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Tecax01c บ Autor ณPaulo Lopez         บ Data ณ  08/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSaida massiva pelo Cod. Master                              บฑฑ
ฑฑบ          ณExclui Saida Massiva Retorna Status 5                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Tecax01C()

If _cSts
	
	For y := 1 to Len(_aMass)
		
		cQryExec 	:= " UPDATE " + RetSqlName("ZZ4") + ENTER
		cQryExec 	+= " SET ZZ4_STATUS = '5', ZZ4_SMUSER = '',ZZ4_SMDT   = '',ZZ4_SMHR = '' " + 	ENTER
		cQryExec 	+= " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER 
    	cQryExec 	+= " AND D_E_L_E_T_ = '' " + ENTER
		cQryExec 	+= " AND ZZ4_ETQMAS = '"+ TransForm(_aMass[y,01], "@E 999999999999") + "'  " + ENTER
		cQryExec 	+= " AND ZZ4_STATUS = '6' " + ENTER
		cQryExec	+= " AND SUBSTRING(ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER  

		MemoWrite("c:\exec2.sql", cQryExec)
		
		TcSQlExec(cQryExec)
		//		TCRefresh(RETSQLNAME("ZZ4"))
		
	Next y
	
Endif 


cMASS		:=IIF(lMudOs,Replicate(' ',20),Replicate(' ',12))
nCount 		:= 0
_nCount 	:= 0  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adapta็ใo para o coletor de dados                                      ณ
//ณ Delta Decisao - DF - 11/10/2011                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRf 
	ocodimei:SetFocus()
EndIf 	

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraLidsบAutor  ณDiego Fernandes     บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que mostra as ultimas etiquetas lidas               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MostraLids()

Local aSave    := {}
Local nPosicao := 1
Local aCabec   := {"Master","IMEI","Cliente","Opera็ใo"}
Local aKits    := {}
Local aSize    := {15,15,20,3} 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz filtro para verificar as etiquetas jแ lidasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry	:= " SELECT ZZ4.ZZ4_IMEI	AS IMEI,	" + ENTER
cQry	+= "		ZZ4.ZZ4_CARCAC	AS CARC,  	" + ENTER
cQry	+= "		ZZ3.ZZ3_CARDU	AS CARDU,  	" + ENTER
cQry	+= "		ZZ4.ZZ4_CODPRO	AS CODPRO, 	" + ENTER
cQry	+= "		ZZ4.ZZ4_OS		AS OS, 		" + ENTER
cQry	+= "		ZZ4.ZZ4_ETQMAS	AS ETQ,  	" + ENTER
cQry	+= "		ZZ4.ZZ4_OPEBGH	AS OPERA,	" + ENTER
cQry	+= "		ZZ4.ZZ4_STATUS	AS STATUS, 	" + ENTER
cQry	+= "		SA1.A1_EST		AS EST,   	" + ENTER
cQry	+= "		SA1.A1_NREDUZ   AS NREDUZ  	" + ENTER
cQry	+= "FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) " + ENTER
cQry	+= "INNER JOIN " + RetSqlName("ZZ3") + " ZZ3 (NOLOCK) " + ENTER
cQry	+= "ON(ZZ3.ZZ3_FILIAL = ZZ4.ZZ4_FILIAL AND ZZ3.ZZ3_NUMOS = ZZ4.ZZ4_OS AND ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ3.ZZ3_ENCOS = 'S' AND ZZ3.ZZ3_ESTORN = '' AND ZZ4.D_E_L_E_T_ = ZZ3.D_E_L_E_T_)  " + ENTER
cQry	+= "INNER JOIN " + RetSqlName("SA1") + " SA1 (nolock)  " + ENTER
cQry	+= "ON(ZZ4.ZZ4_CODCLI = SA1.A1_COD AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA AND A1_FILIAL = '"+XFILIAL("SA1")+"' ) " + ENTER
cQry 	+= "WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' " + ENTER 
cQry 	+= "AND D_E_L_E_T_ = '' " + ENTER
cQry	+= "AND ZZ4.ZZ4_STATUS   = '6' " + ENTER
cQry	+= "AND ZZ4.ZZ4_ETQMAS <> ''  " + ENTER
cQry 	+= "AND SUBSTRING(ZZ4.ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' " + ENTER
cQry	+= "ORDER BY ZZ4.ZZ4_ETQMAS " + ENTER

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe exitir o alias, finaliza! 				  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                               
If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf
	
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

dbSelectArea("QRY")
QRY->(dbGotop())

While QRY->(!Eof())
	AADD(aLidos, {QRY->ETQ,; 
	              QRY->IMEI,;     
	              QRY->NREDUZ,;
	              QRY->OPERA} )
	              
	QRY->(dbSkip())
EndDo

aSave := VTSAVE()
VTClear()
nPosicao := VTaBrowse(0,0,7,19,aCabec,aLidos,aSize,,nPosicao)
VtRestore(,,,,aSave)
VTClearBuffer()

Return


Static Function ValAcess()

Local lRetAces := .T.

cQuery := " SELECT "
cQuery += "		ZZ4_CODCLI,ZZ4_LOJA,ZZ4_LOCAL,Z9_PARTNR,COUNT(1) AS QTD "
cQuery += " FROM " + RetSqlName("ZZ4") + " ZZ4 (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SZ9") + " SZ9 (NOLOCK) ON "
cQuery += " 	Z9_FILIAL='"+XFILIAL("SZ9")+"' AND "
cQuery += "		Z9_NUMOS=ZZ4_OS AND "
cQuery += "		Z9_PARTNR <> '' AND "
cQuery += "		Z9_SYSORIG='3' AND "
cQuery += "		SZ9.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += "		ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND "
cQuery += "		ZZ4.ZZ4_STATUS   = '6' AND " 
cQuery += " 	ZZ4.ZZ4_ETQMAS <> ''  AND " 
cQuery += " 	ZZ4.ZZ4_OPEBGH IN ('N01', 'N10','N11') AND " 
cQuery += "		SUBSTRING(ZZ4.ZZ4_SMUSER,1,13) = '"+Substr(cUserName,1,13)+"' AND "
cQuery += "		ZZ4.D_E_L_E_T_='' "
cQuery += "	GROUP BY ZZ4_CODCLI,ZZ4_LOJA,ZZ4_LOCAL,Z9_PARTNR "

If Select("QRYAC") > 0
	QRYAC->(dbCloseArea())
EndIf
	
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "QRYAC", .F., .T.)

dbSelectArea("QRYAC")
QRYAC->(dbGotop())

While QRYAC->(!Eof())
	
	_cArmPSP := GetMv("MV_XARMPSP",.F.,"1S")
	_cArmPRJ := GetMv("MV_XARMPRJ",.F.,"1R")
	_cEndKit := GetMv("MV_XENDFAT",.F.,"FATURAR")
	
	_cArmKIT := IIF(QRYAC->ZZ4_CODCLI $ "000016/Z01FY6",_cArmPSP,_cArmPRJ)
	
	_nSaldoBF :=  SaldoSBF(_cArmKIT, _cEndKit, QRYAC->Z9_PARTNR, NIL, NIL, NIL, .F.)
		
	If _nSaldoBF < QRYAC->QTD
		lRetAces := .F.
		MsgStop("Saldo do Acessorio "+ALLTRIM(QRYAC->Z9_PARTNR)+" no endere็o faturar nใo ้ suficiente para efetuar essa saida massiva. Favor verificar! ", "Alerta")
	Endif	
	
	_nSaldoB6 :=  SALDOSB6()
		
	If _nSaldoB6 < QRYAC->QTD
		lRetAces := .F.
		MsgStop("Saldo do Acessorio "+ALLTRIM(QRYAC->Z9_PARTNR)+" na tabela de terceiros nใo ้ suficiente para efetuar essa saida massiva. Favor verificar! ", "Alerta")
	Endif	
	              
	QRYAC->(dbSkip())
EndDo

dbSelectArea("QRYAC")
QRYAC->(dbGotop())


Return (lRetAces)

Static Function SALDOSB6()

Local nSaldoB6 := 0

cQuery := " SELECT "
cQuery += "		B6_PRODUTO, SUM(B6_SALDO) AS SALDOB6, "
cQuery += "		(	SELECT "
cQuery += "				ISNULL(SUM(C6_QTDVEN-C6_QTDENT) ,0)
cQuery += "			FROM " + RetSqlName("SC6") + " SC6 (NOLOCK) "
cQuery += "			WHERE "
cQuery += "				C6_FILIAL='"+XFILIAL("SC6")+"' AND "
cQuery += "				C6_PRODUTO=B6_PRODUTO AND "
cQuery += "				C6_CLI='"+QRYAC->ZZ4_CODCLI+"' AND "
cQuery += "				C6_LOJA='"+QRYAC->ZZ4_LOJA+"' AND "
cQuery += "				C6_QTDVEN-C6_QTDENT > 0 AND "
cQuery += "				SC6.D_E_L_E_T_='' "
cQuery += "		) AS SALDOC6 "
cQuery += "	FROM " + RetSqlName("SB6") + " SB6 (NOLOCK) "
cQuery += "	WHERE "
cQuery += "		B6_FILIAL='"+XFILIAL("SB6")+"' AND "
cQuery += "		B6_CLIFOR='"+QRYAC->ZZ4_CODCLI+"' AND "
cQuery += "		B6_LOJA='"+QRYAC->ZZ4_LOJA+"' AND "
cQuery += "		B6_PRODUTO='"+QRYAC->Z9_PARTNR+"' AND "
cQuery += "		B6_SALDO > 0 AND "
cQuery += "		SB6.D_E_L_E_T_ ='' "
cQuery += "	GROUP BY B6_PRODUTO "

If Select("QRYB6") > 0
	QRYB6->(dbCloseArea())
EndIf
	
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "QRYB6", .F., .T.)

dbSelectArea("QRYB6")
QRYB6->(dbGotop())

If QRYB6->(!Eof())
	nSaldoB6 := QRYB6->SALDOB6-QRYB6->SALDOC6
Endif

If Select("QRYB6") > 0
	QRYB6->(dbCloseArea())
EndIf       

Return(nSaldoB6)