#INCLUDE "PROTHEUS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "APVT100.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ APONTACT บ Autor ณPaulo Lopez         บ Data ณ  07/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Apontamento Pe็as - COLETOR (ACD)                 บฑฑ
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
User Function APONTACD()
Private cVarArm	:= Replicate(" ",02)
Private cVarEnd	:= Replicate(" ",20)
Private cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
Private cVarBos	:= Replicate(" ",08)
Private cVarBpe	:= Replicate(" ",25)
Private cVarArO	:= Replicate(" ",02)
Private	cVarEnO	:= Replicate(" ",25)
Private cVarArD	:= Replicate(" ",02)
Private	cVarEnD	:= Replicate(" ",25)                          
Private cVarltd := Replicate(" ",10)
Private cVarlto := Replicate(" ",10)
Private cVarsbl := Replicate(" ",6)
Private dVarlvl := CtoD("//")
Private _UserId	:= __cUserID
Private _CodTec	:= Posicione("AA1",4,xFilial("AA1") + _UserId,"AA1_CODTEC")
Private cImei	:= ""
Private cArmOri
Private cArmDes
Private cEndOri
Private cEndDes
Private cOs
Private cPeca
Private nTpApont := 0
u_GerA0003(ProcName())

If Empty(AllTrim(_CodTec))
	VTBEEP(3)
	VTAlert("------Tecnico nใo cadastrado, Entrar em contato com Supervisor.--------","Alerta",.T.,2500)
	cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
	cVarBos	:= Replicate(" ",08)
	cVarBpe	:= Replicate(" ",25)
	cVarltd := Replicate(" ",10)
    cVarlto := Replicate(" ",10)
    cVarsbl := Replicate(" ",6)
    dVarlvl := CtoD("//")
	VTClear()
	Return()
EndIf
nTpApont := DLVTAviso("", "Apontamento", {"Estoque", "Producao"})
CBChkTemplate()
While .T.
	VTClear
	nLin:= -1
	@ ++nLin,0 VTSAY "Coletor"
	If ! ApontAcda()
		Exit
	EndIf
	ApontAcdt()
	VTRead
	If (VTLastKey()==27)
		If ! VTYesNo("Confirma a Saida?","Aten็ใo")
			Loop
		EndIf
		Exit
	EndIf
End
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAPONTACDA บ Autor ณPaulo Lopez         บ Data ณ  07/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Apontamento Pe็as - COLETOR (ACD)                 บฑฑ
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
Static Function ApontAcda()
Local lRet	 := .T.
VTClear()
VTClearBuffer()
DLVTCabec("Aponta Pe็a Coletor",.F.,.F.,.T.)
@ 01, 00 VTSay "Arm. Orig."	VTGet cVarArO Pict "@!"	Valid ApontAcd1(@cVarArO,"4")
@ 02, 00 VTSay "End. Orig."	VTGet cVarEnO Pict "@!"	Valid ApontAcd1(@cVarEnO,"5")
@ 03, 00 VTSay "Arm. Dest."	VTGet cVarArD Pict "@!"	Valid ApontAcd1(@cVarArD,"6")
@ 04, 00 VTSay "End. Dest."	VTGet cVarEnD Pict "@!"	Valid ApontAcd1(@cVarEnD,"7")
VTRead
Return(lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ApontAcdtบ Autor ณPaulo Lopez         บ Data ณ  07/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Apontamento Pe็as - COLETOR (ACD)                 บฑฑ
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
Static Function ApontAcdt()
If Empty(cArmOri) .Or. Empty(cArmDes)
	VTClearBuffer()
Else
	VTClear()
	VTClearBuffer()
	DLVTCabec("Aponta Pe็a Coletor",.F.,.F.,.T.)
	//	@ 01, 00 VTSay "IMEI"	VTGet cVarBar Pict "@!"	Valid ApontAcd1(@cVarBar,"1")
	@ 01, 00 VTSay "O.S."	VTGet cVarBos Pict "@!"	Valid ApontAcd1(@cVarBos,"2")
	@ 02, 00 VTSay "Pe็a" 	VTGet cVarBpe Pict "@!"	Valid ApontAcd1(@cVarBpe,"3")
	VTREAD
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTecla ESC pressionada, lista op็๕es 	  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//If (VTLastKey()==27) .And. Empty(cVarBar) .And. Empty(cVarBos) .And. Empty(cVarBpe)
	If (VTLastKey()==27) .And. Empty(cVarBos) .And. Empty(cVarBpe)
		VTClearBuffer()
	Else
		nOpcao := DLVTAviso("", "Op็๕es", {"APONTAR", "EXCLUIR"})
		Do Case
			Case nOpcao == 1 // Apontar
				ApontAcd2(nOpcao)
				//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',15)
				cVarBos	:= Replicate(" ",08)
				cVarBpe	:= Replicate(" ",25)
				cVarltd := Replicate(" ",10)
                cVarlto := Replicate(" ",10)
                cVarsbl := Replicate(" ",6)
                dVarlvl := CtoD("//")
			Case nOpcao == 2 // Excluir
				If DLVTAviso("", "DESEJA REALMENTE EXCLUIR PECA DO APARELHO? ", {"SIM", "NAO"}) == 1
					ApontAcd2(nOpcao)
					//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
					cVarBos	:= Replicate(" ",08)
					cVarBpe	:= Replicate(" ",25)
					cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
				Else
					VTBEEP(3)
					VTAlert("------Cancelado conforme solicitado, Cancelado.--------","Alerta",.T.,2500)
					//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(' ',15)
					cVarBos	:= Replicate(" ",08)
					cVarBpe	:= Replicate(" ",25)
					cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
				EndIf
		EndCase
		VTClear()
	EndIf
EndIf
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApontAcd1 บAutor  ณ Paulo Francisco    บ Data ณ 07/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao Apontamento Pecas ACD                 			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ApontAcd1(cCodBar,nOpc)
Local _lRet		:= .T.
Local _lVadLoc  := GetMv("BH_VALLOC",.F.,.T.)
Local _lArmEnd	:= GetMV("BH_DEPARA",.F.)
Local _cArmVal	:= Tabela("ZU",cCodBar, .F. )
Local _cVSaldo
#IFDEF TOP
	Local xVaTemp		:= GetNextAlias()
	Local xlQuery		:= .F.
	Local xVaTemp1		:= GetNextAlias()
	Local xlQuery1		:= .F.
	Local xVaTemp2		:= GetNextAlias()
	Local xlQuery2		:= .F.
#ENDIF
If nOpc == "1" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
ElseIf nOpc == "1" .And. !Empty(AllTrim(cCodBar))
	cImei := cCodBar
ElseIf nOpc == "2" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
	cVarBos	:= Replicate(" ",08)
ElseIf nOpc == "2" .And. !Empty(AllTrim(cCodBar))
	cOs	:=	cCodBar
Endif
If nOpc == "2" .And. _lRet
	#IFDEF TOP
		xlQuery  := .T.
		BeginSql alias xVaTemp
			SELECT
			ZZ4_STATUS	as STATUSS
			FROM %table:ZZ4% ZZ4
			WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
			//ZZ4.ZZ4_IMEI = %exp: cImei%					AND
			ZZ4.ZZ4_OS = %exp: cVarBos%					AND
			ZZ4.ZZ4_STATUS < %exp: '5'%					AND
			ZZ4.%notDel%
		EndSql
		If Empty(AllTrim((xVaTemp)->STATUSS))
			VTBEEP(3)
			VTAlert("------Equipamento nใo localizado, favor analisar.--------","Alerta",.T.,2500)
			//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
			cVarBos	:= Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)
			cVarltd := Replicate(" ",10)
            cVarlto := Replicate(" ",10)
            cVarsbl := Replicate(" ",6)
            dVarlvl := CtoD("//")
			_lRet := .F.
		EndIf
		If xlQuery
			(xVaTemp)->( DbCloseArea())
		Endif
	#ENDIF
ElseIf nOpc == "3" .And. _lRet
	#IFDEF TOP
		xlQuery1  := .T.
		BeginSql alias xVaTemp1
			SELECT
			ZZ4_CODPRO as PRODUTO,
			ZZ4_OPEBGH as OPEBGH
			FROM %table:ZZ4% ZZ4
			WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
			//ZZ4.ZZ4_IMEI = %exp: cImei%					AND
			ZZ4.ZZ4_OS = %exp: (AllTrim(cOs))%			AND
			ZZ4.ZZ4_STATUS < %exp: '5'%					AND
			ZZ4.%notDel%
		EndSql
		If Empty(AllTrim((xVaTemp1)->PRODUTO))
			VTBEEP(3)
			VTAlert("------Pe็a nใo localizado, favor analisar.--------","Alerta",.T.,2500)
			//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
			cVarBos	:= 	Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)
			cVarltd := Replicate(" ",10)
            cVarlto := Replicate(" ",10)
            cVarsbl := Replicate(" ",6)
            dVarlvl := CtoD("//")
			_lRet := .F.
		Else 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณUtilizado os comandos rtrim e ltrim pois nใo estava retornando valor e sem l๓gica.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			xlQuery2  := .T.
			_cQuery := " SELECT rtrim(ltrim(GG_COMP)) AS COMP "
			_cQuery += " FROM "+RetSqlName("SGG")+" AS SGG "
			_cQuery += " WHERE "
			_cQuery += " SGG.GG_FILIAL = '" + xFilial("SGG") + "' "
			_cQuery += " AND (SGG.GG_COD = "
			_cQuery += " ( SELECT TOP 1 GG_COMP "
			_cQuery += " FROM "+RetSqlName("SGG")+" AS GG_1 "
			_cQuery += " WHERE "
			_cQuery += " GG_1.GG_FILIAL = SGG.GG_FILIAL "
			_cQuery += " AND GG_1.GG_COD = '" + (xVaTemp1)->PRODUTO + "' "
			_cQuery += " AND GG_1.D_E_L_E_T_ = '') "
			_cQuery += " OR SGG.GG_COD = '" + (xVaTemp1)->PRODUTO + "') "
			_cQuery += " AND SGG.GG_COMP = '" + cVarBpe + "' "
			_cQuery += " AND SGG.GG_TRT = '" + (xVaTemp1)->OPEBGH + "' "
			_cQuery += " AND SGG.D_E_L_E_T_ = '' "
			dbUseArea(.T., "TOPCONN", TCGenQry(,, _cQuery), "QTP", .F., .T.)
			dbSelectArea("QTP")
			dbGoTop()
			If Empty(AllTrim(QTP->COMP))
				VTBEEP(3)
				VTAlert("----Nใo localizado na Estrutura, favor analisar.--------","Alerta",.T.,2500)
				//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
				cVarBos	:= Replicate(" ",08)
				cVarBpe	:= Replicate(" ",25)
				cVarltd := Replicate(" ",10)
                cVarlto := Replicate(" ",10)
                cVarsbl := Replicate(" ",6)
                dVarlvl := CtoD("//")
				_lRet := .F.
			Else
				cPeca	  := cVarBpe          
				cultlote  := POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(cPeca),"B1_RASTRO")
            
                IF cultlote $ "SL"        

		 				VTClear()
		            	VTClearBuffer()
		             	DLVTCabec("Inf. o lote : ",.F.,.F.,.T.)
		              	 @ 01, 00 VTSay "Lote :"	VTGet cVarlto Pict "@!"	 Valid  vallote(@cVarlto,cPeca,cVarArO)
			            //@ 02, 00 VTSay "Lote Destino" 	VTGet cVarltd Pict cVarlto Valid .t. // Habilitar campo se for necessario digitat o lote destino
		             	VTREAD
	            
            	        cVarltd := cVarlto
	            
	            Endif
			EndIf
		EndIf
		If xlQuery1
			(xVaTemp1)->( DbCloseArea())
		Endif
		If xlQuery2
			QTP->( DbCloseArea())
		Endif
	#ENDIF
ElseIf nOpc == "4" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	cVarArO		:= Replicate(" ",02)
ElseIf  nOpc == "4" .And. !Empty(AllTrim(cCodBar))
	cArmOri		:= cCodBar
ElseIf nOpc == "5" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	cVarEnO		:= Replicate(" ",25)
ElseIf  nOpc == "5" .And. !Empty(AllTrim(cCodBar))
	cEndOri		:= cCodBar
	If  !Empty(cArmOri) .And. !Empty(cEndOri)
		SBE->(DbSetOrder(1))
		If ! SBE->(DbSeek(xFilial("SBE")+cArmOri+cEndOri))
			VtAlert("Endere็o nใo Localizado", "Aviso",.T.,4000,4) //"Endereco nao encontrado"###"Aviso"
			VTKeyboard(chr(20))
			VTClearGet("cArmOri")
			VTClearGet("cEndOri")
			VTGetSetFocus("cArmOri")
			VTGetSetFocus("cEndOri")
			_lRet := .F.
		EndIf
	EndIf
ElseIf nOpc == "6" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	cVarArD		:= Replicate(" ",02)
ElseIf  nOpc == "6" .And. !Empty(AllTrim(cCodBar))
	cArmDes	:= cCodBar
ElseIf nOpc == "7" .And. Empty(AllTrim(cCodBar))
	_lRet	:= .F.
	cVarEnD		:= Replicate(" ",25)
ElseIf  nOpc == "7" .And. !Empty(AllTrim(cCodBar))
	cEndDes	:= cCodBar
	If  !Empty(cArmDes) .And. !Empty(cEndDes)
		SBE->(DbSetOrder(1))
		If ! SBE->(DbSeek(xFilial("SBE")+cArmDes+cEndDes))
			VtAlert("Endere็o nใo Localizado", "Aviso",.T.,4000,4) //"Endereco nao encontrado"###"Aviso"
			VTKeyboard(chr(20))
			VTClearGet("cArmDes")
			VTClearGet("cEndDes")
			VTGetSetFocus("cArmDes")
			VTGetSetFocus("cEndDes")
			_lRet := .F.
		EndIf
	EndIf
ElseIf !_lArmEnd .AND. _lVadLoc .And. !Empty(_cArmVal) .And. cArmOri <> cArmDes
	If !(Alltrim(cArmDes) $ Alltrim(_cArmVal))
		_lRet := .F.
		VtAlert("Armazem Origem e Destino Incompativeis", "AVISO",.T.,4000,4) //"Endereco bloqueado"###"Aviso"
		VTKeyboard(chr(20))
	Endif
ElseIf _lArmEnd
	If !u_VLDARMEND(cArmOri, cEndOri, cArmDes, cEndDes)
		_lRet := .F.
		VtAlert("Transferencia nใo permitida. Cadastro 'De Para'. Entrar em contato com a Controladoria", "AVISO",.T.,4000,4)
		VTKeyboard(chr(20))
	EndIf
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotina de travamento do radio - GLPI 14467ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpc $ "1/2" .AND. _lRet
	#IFDEF TOP
		xlQuery  := .T.
		BeginSql alias xVaTemp
			SELECT
			ZZ4_FILIAL	as FILIALS,
			ZZ4_IMEI	as IMEIS,
			ZZ4_OS		as OSS
			FROM %table:ZZ4% ZZ4
			WHERE ZZ4.%notDel%
			AND ZZ4.ZZ4_FILIAL = %xfilial:ZZ4%
			AND ZZ4.ZZ4_OS = %exp: cVarBos%
			AND ZZ4.ZZ4_STATUS < %exp: '5'%
		EndSql
		If !U_VLDTRAV((xVaTemp)->FILIALS, (xVaTemp)->IMEIS, (xVaTemp)->OSS, {"C","APONTACD","ApontAcd1"})
			cVarBos	:= Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)
			_lRet := .F.
		EndIf
		If xlQuery
			(xVaTemp)->( dbCloseArea())
		Endif
	#ENDIF
EndIf
Return(_lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApontAcd2 บAutor  ณ Paulo Francisco    บ Data ณ 07/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao Apontamento Pecas ACD                 			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ApontAcd2(nOpc)
Local cArmazem	:="" 	//Recebe armazem (Garantia ou Fora)
Local lGarant 	:=.F.	/*Calcula Garantia do Rแdio*/
Local lPcEle	:=.F.	/*Verifica se a Peca e eletrica		*/
Local lPcRet	:=.F.   /*Verifica se a Peca e Retrabalhada	*/
Local aItens	:= {}
#IFDEF TOP
	Local xVaTemp3		:= GetNextAlias()
	Local xlQuery3		:= .F.
	Local xVaTemp4		:= GetNextAlias()
	Local xlQuery4		:= .F.
#ENDIF
dbselectarea("ZZJ")
ZZJ->(dbSetOrder(1))	//ZZJ_FILIAL+ZZJ_OPERA+ZZJ_LAB
dbselectarea("SZ9")
SZ9->(dbSetOrder(4))	//Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
dbselectarea("SB1")
SB1->(dbSetOrder(1))	//B1_FILIAL+B1_COD
dbSelectArea("ZZ4")
dbSetOrder(11)			//ZZ4_FILIAL+ZZ4_OS+ZZ4_IMEI
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o usuแrio digitou o PartNumberณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cPeca)
	ApontAcd1(cPeca,"3")
Endif
If Empty(cOs) .Or. Empty(cPeca)
	VTBEEP(3)
	VTAlert("------Radio ou peca nao localizado(a), favor analisar.--------","Alerta",.T.,2500)
	cVarBos	:= Replicate(" ",08)
	cVarBpe	:= Replicate(" ",25) 
	cVarltd := Replicate(" ",10)
    cVarlto := Replicate(" ",10)
    cVarsbl := Replicate(" ",6)
    dVarlvl := CtoD("//")
	Return()
EndIf
If ZZ4->(dbSeek(xFilial("ZZ4")+cOs))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRotina de travamento do radio - GLPI 14467ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !U_VLDTRAV(ZZ4->ZZ4_FILIAL, ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS, {"C","APONTACD","ApontAcd2"})
		VTBEEP(3)
		VTAlert("Radio bloqueado para apontamento. Contactar Relacionamento Cliente.","Alerta",.T.,2500)
		cVarBos	:= Replicate(" ",08)
		cVarBpe	:= Replicate(" ",25)
		cVarltd := Replicate(" ",10)
        cVarlto := Replicate(" ",10)
        cVarsbl := Replicate(" ",6)
        dVarlvl := CtoD("//")
		Return()
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRotina de travamento de transferencias    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ((nOpc == 1 .AND. !u_VLDARMEND(cVarArO, cVarEnO, cVarArD, cVarEnD)) .OR. ;
	(nOpc == 2 .AND. !u_VLDARMEND(cVarArD, cVarEnD, cVarArO, cVarEnO)))
		VTBEEP(3)
		VTAlert("-----Cadastro De/Para. Entrar em contato com Controladoria-----","Alerta",.T.,2500)
		cVarBos	:= Replicate(" ",08)
		cVarBpe	:= Replicate(" ",25) 
		cVarltd := Replicate(" ",10)
        cVarlto := Replicate(" ",10)
        cVarsbl := Replicate(" ",6)
        dVarlvl := CtoD("//")
		Return()
	Endif
	ZZJ->(dbSeek(xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH)) /*Pocionar no ZZJ de acordo com ZZ4*/
	If nTpApont == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se a pe็a e eletrica, se o radio esta na garantia, ณ
		//ณe qual o Armazem padrใo  de acordo com a ZZJ                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lPcEle   := Iif(Posicione("SB1",1,xFilial("SB1") + cPeca, "B1_XMECELE") == "E", .T. , .F. 		)	// Peca eletrica ou mecanica ?
		lGarant  := Iif(Iif(ZZJ->ZZJ_CALGAR == "S",ZZ4->ZZ4_GARMCL,ZZ4->ZZ4_GARANT) == "S" , .T. , .F.	)	//Recebe garantia de acordo com o parโmetro Calcula ou nใo garantia )
		cArmazem := Iif(lGarant ,ZZJ->ZZJ_ARMEST,ZZJ->ZZJ_ARMESF)											//recebe o Armazem a ser apontada a pe็a de acordo com a Garantia
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณA partir deste ponto valida o apontamento !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(ZZJ->ZZJ_COLEST)
			VTBEEP(3)
			VTAlert("------Nao ha cadastro de coletor para esta Operacao--------","Alerta",.T.,2500)
			cVarBos	:= Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)     
			cVarltd := Replicate(" ",10)
            cVarlto := Replicate(" ",10)
            cVarsbl := Replicate(" ",6)
            dVarlvl := CtoD("//")
			Return()
		Else
			If lGarant
				If !(ZZJ->ZZJ_COLEST == "A")
					If (ZZJ->ZZJ_COLEST == "F")
						VTBEEP(3)
						VTAlert("------Aparelho em garantia e operacao cadastrada para Fora de garantia--------","Alerta",.T.,2500)
						cVarBos	:= Replicate(" ",08)
						cVarBpe	:= Replicate(" ",25)
						cVarltd := Replicate(" ",10)
                        cVarlto := Replicate(" ",10)
                        cVarsbl := Replicate(" ",6)
                        dVarlvl := CtoD("//")
						Return()
					EndIf
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se a peca e eltrica e se o apontamento dela pode ser feito nessa operacao ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ( lPcEle .And. ZZJ->ZZJ_PNELE == "F" )
					VTBEEP(3)
					VTAlert("------Operacao cadastrada para apontamento de peca eletrica Fora de garantia--------","Alerta",.T.,2500)
					cVarBos	:= Replicate(" ",08)
					cVarBpe	:= Replicate(" ",25)
					cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
					Return()
				EndIf
			Else
				If !(ZZJ->ZZJ_COLEST == "A")
					If (ZZJ->ZZJ_COLEST == "G")
						VTBEEP(3)
						VTAlert("------Aparelho fora de garantia e operacao cadastrada para garantia--------","Alerta",.T.,2500)
						cVarBos	:= Replicate(" ",08)
						cVarBpe	:= Replicate(" ",25)
						cVarltd := Replicate(" ",10)
                        cVarlto := Replicate(" ",10)
                        cVarsbl := Replicate(" ",6)
                        dVarlvl := CtoD("//")
						Return()
					EndIf
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se a peca e eltrica e se o apontamento dela pode ser feito nessa operacao ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ( lPcEle .And. ZZJ->ZZJ_PNELE == "G" )
					VTBEEP(3)
					VTAlert("------Operacao cadastrada para apontamento de peca eletrica em garantia--------","Alerta",.T.,2500)
					cVarBos	:= Replicate(" ",08)
					cVarBpe	:= Replicate(" ",25)
					cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
					Return()
				EndIf
			EndIf
		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidacoes do COLETOR PRODUCAOณ
		//ณDelta Consultoria - 07.03.2014ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lPcRet   	:= IiF( Posicione("SB1",1,xFilial("SB1") + cPeca, "B1_RETRABA") == "S", .T. , .F. 		) 		// Peca retrabalhada ?
		lDivNeg	 	:= .F.
		cGar 		:= IIF(ZZJ->ZZJ_CALGAR=="S",ZZ4->ZZ4_GARMCL,ZZ4->ZZ4_GARANT)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se o produto ้ retrabalhado para que possa ser baixado ณ
		//ณdo armaz้m de retrabalho, caso contrario verifica armazem de    ณ
		//ณacordo com ZZJ...                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (lPcRet)
			cArmazem	:= AllTrim(ZZJ->ZZJ_ARMPR)
		Else
			cArmazem	:= IIF(cGar=="S",ZZJ->ZZJ_ALMEP,ZZJ->ZZJ_ALMPF)
		EndIf
		If Empty(ZZJ->ZZJ_COLPRO)
			lDivNeg	 := .T.
		Else
			If ZZJ->ZZJ_COLPRO <> "A"
				If cGar == "S"
					If ZZJ->ZZJ_COLPRO == "F"
						lDivNeg	 := .T.
					Endif
				Else
					If ZZJ->ZZJ_COLPRO == "G"
						lDivNeg	 := .T.
					Endif
				Endif
			Endif
		Endif
		If lDivNeg
			VTBEEP(3)
			VTAlert("------Diverge a regra de negocio--------","Alerta",.T.,2500)
			cVarBos	:= Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)
			cVarltd := Replicate(" ",10)
            cVarlto := Replicate(" ",10)
            cVarsbl := Replicate(" ",6)
            dVarlvl := CtoD("//")
			Return()
		Endif
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica o Armazem digitado x origem !			   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(Alltrim(cArmOri) $ cArmazem)
		VTBEEP(3)
		VTAlert("------Armazem "+cArmOri+" nao autorizado para essa transa็ใo, favor analisar.--------","Alerta",.T.,2500)
		cVarBos	:= Replicate(" ",08)
		cVarBpe	:= Replicate(" ",25)
		cVarltd := Replicate(" ",10)
        cVarlto := Replicate(" ",10)
        cVarsbl := Replicate(" ",6)
        dVarlvl := CtoD("//")
		Return()
	Endif
Else
	VTBEEP(3)
	VTAlert("------Registro nใo encontrado, favor analisar.--------","Alerta",.T.,2500)
	cVarBos	:= Replicate(" ",08)
	cVarBpe	:= Replicate(" ",25) 
	cVarltd := Replicate(" ",10)
    cVarlto := Replicate(" ",10)
    cVarsbl := Replicate(" ",6)
    dVarlvl := CtoD("//")
	Return()
Endif
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida็ใo anterior ao projeto de apontamento de pe็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Alltrim(cArmEst) <> Alltrim(cArmOri)
If LEFT(ZZ4->ZZ4_OPEBGH,1)=="N" .AND. ZZ4->ZZ4_GARMCL=="N"
If !Alltrim(cArmOri) $ cArmFog
VTBEEP(3)
VTAlert("------Opera็ใo nใo autorizada via coletor, favor analisar.--------","Alerta",.T.,2500)
cVarBos	:= Replicate(" ",08)
cVarBpe	:= Replicate(" ",25)
Return()
Endif
Else
VTBEEP(3)
VTAlert("------Armazem Origem divergente, favor analisar.--------","Alerta",.T.,2500)
cVarBos	:= Replicate(" ",08)
cVarBpe	:= Replicate(" ",25)
Return()
Endif
ElseIf Alltrim(cArmEst) == Alltrim(cArmOri) .AND. ZZ4->ZZ4_GARMCL=="N" .AND. LEFT(ZZ4->ZZ4_OPEBGH,1)=="N"
VTBEEP(3)
VTAlert("------Armazem Origem autorizado somente para Equipamento em Garantia, favor analisar.--------","Alerta",.T.,2500)
cVarBos	:= Replicate(" ",08)
cVarBpe	:= Replicate(" ",25)
Return()
Endif
Else
VTBEEP(3)
VTAlert("------Registro nใo encontrado, favor analisar.--------","Alerta",.T.,2500)
cVarBos	:= Replicate(" ",08)
cVarBpe	:= Replicate(" ",25)
Return()
Endif
*/
If nOpc == 1
	_cVSaldo := U_SaldPeca(cPeca,1,cImei,cOs,cArmOri,cEndOri)
	If !_cVSaldo
		VTBEEP(3)
		VTAlert("------Problema com Saldo Pe็a, Favor analisar.--------","Alerta",.T.,2500)
		//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
		cVarBos	:= Replicate(" ",08)
		cVarBpe	:= Replicate(" ",25)
		cVarltd := Replicate(" ",10)
        cVarlto := Replicate(" ",10)
        cVarsbl := Replicate(" ",6)
        dVarlvl := CtoD("//")
	Else
		Begin Transaction
		#IFDEF TOP
			xlQuery3  := .T.
			BeginSql alias xVaTemp3
				SELECT TOP 1 ZZ3.ZZ3_SEQ AS SEQ, ZZ3.ZZ3_CODTEC AS TEC, ZZ3.ZZ3_FASE1 AS FASE, ZZ3.ZZ3_IMEI AS IMEI
				FROM %table:ZZ3% ZZ3
				WHERE   ZZ3.ZZ3_FILIAL = %xfilial:ZZ3% 		AND
				//ZZ3.ZZ3_IMEI = %exp: (AllTrim(cImei))%		AND
				ZZ3.ZZ3_NUMOS = %exp: (AllTrim(cOs))%		AND
				ZZ3.%notDel%
				ORDER BY ZZ3.R_E_C_N_O_ DESC
			EndSql
			If !Empty(AllTrim((xVaTemp3)->SEQ))
				RecLock("SZ9",.T.)
				SZ9->Z9_FILIAL 	:= 	xFilial("SZ9")
				SZ9->Z9_NUMOS	:=	AllTrim(cOs)
				SZ9->Z9_SEQ		:=	AllTrim((xVaTemp3)->SEQ)
				SZ9->Z9_CODTEC	:= 	AllTrim((xVaTemp3)->TEC)
				SZ9->Z9_ITEM	:=	"01"
				SZ9->Z9_QTY		:=	1
				SZ9->Z9_PARTNR	:=	AllTrim(cPeca)
				SZ9->Z9_USED	:=	"0"
				//SZ9->Z9_IMEI	:= 	AllTrim(cImei)
				SZ9->Z9_IMEI	:= 	AllTrim((xVaTemp3)->IMEI)
				SZ9->Z9_STATUS	:=	"1"
				SZ9->Z9_FASE1	:=	AllTrim((xVaTemp3)->FASE)
				SZ9->Z9_PREVCOR	:=	"C"
				SZ9->Z9_LOCAL	:=	AllTrim(cArmOri)
				SZ9->Z9_COLETOR	:=	"S"
				SZ9->Z9_USRINCL	:= AllTrim(_CodTec)  + " - " + AllTrim(cUsername)
				SZ9->Z9_SYSORIG	:= IIF(nTpApont==2,"2","")
				MSUnlock()
			Else
				RecLock("SZ9",.T.)
				SZ9->Z9_FILIAL 	:= 	xFilial("SZ9")
				SZ9->Z9_NUMOS	:=	AllTrim(cOs)
				SZ9->Z9_SEQ		:=	"01"
				SZ9->Z9_CODTEC	:= 	_CodTec
				SZ9->Z9_ITEM	:=	"01"
				SZ9->Z9_QTY		:=	1
				SZ9->Z9_PARTNR	:=	AllTrim(cPeca)
				SZ9->Z9_USED	:=	"0"
				SZ9->Z9_IMEI	:= ZZ4->ZZ4_IMEI // Uiran Almeida - Alterado 09.12.2013 Por estar sendo preenchido em Branco  Chamado ID - 16.531
				//SZ9->Z9_IMEI	:= 	AllTrim(cImei)
				//SZ9->Z9_IMEI	:= 	AllTrim((xVaTemp3)->IMEI)
				SZ9->Z9_STATUS	:=	"1"
				SZ9->Z9_FASE1	:=	""
				SZ9->Z9_PREVCOR	:=	"C"
				SZ9->Z9_LOCAL	:=	AllTrim(cArmOri)
				SZ9->Z9_COLETOR	:=	"S"
				SZ9->Z9_USRINCL	:= AllTrim(_CodTec)  + " - " + AllTrim(cUsername)
				SZ9->Z9_SYSORIG	:= IIF(nTpApont==2,"2","")
				MSUnlock()
			Endif
			nRecZ9 := SZ9->(Recno())
			//Pocisiona Produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + Left(cPeca,15)))
			aAdd(aItens,{Left(cPeca,15),;			 	// Produto Origem
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			cArmOri,;                            		// Local Origem
			AllTrim(cEndOri),;                 			// Ender Origem
			Left(cPeca,15),;		                  	// Produto Destino
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			cArmDes,;                   				// Local Destino
			AllTrim(cEndDes),;         					// Ender Destino
			Space(25),;                               	// Num Serie
			cVarlto ,;                               	// Lote
			cVarsbl ,;                              	// Sub Lote
			dVarlvl ,;                              	// Validade
			0,;                                        	// Potencia
			1,;	                            			// Quantidade
			0,;                                       	// Qt 2aUM
			"N",;                                     	// Estornado
			Space(06),;                               	// Sequencia
			cVarltd ,;                               	// Lote Desti
			dVarlvl ,;                              	// Validade Lote
			Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
			Space(03)})									// Item Grade
			If Len(aItens) >0
				//u_BaixPeca("",aItens,3)
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
					EndIf
					dbSkip()
				EndDo
				u_BaixPeca(cDoc,aItens,3)
				dbSelectArea("SZ9")
				SZ9->(dbGoto(nRecZ9))
				RecLock("SZ9",.F.)
				SZ9->Z9_NUMSEQP :=  cDoc
				SZ9->Z9_DTAPONT := dDataBase
				SZ9->Z9_ATUSD3 :="S"
				MsUnLock()
			Endif
			If xlQuery3
				(xVaTemp3)->( DbCloseArea())
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณMensagem de Confirmacao, no apontamentoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				VTBEEP(3)
				VTAlert("------Transacao OK !--------","Alerta",.T.,2500)
				cVarBos	:= Replicate(" ",08)
				cVarBpe	:= Replicate(" ",25)   
				cVarltd := Replicate(" ",10)
                cVarlto := Replicate(" ",10)
                cVarsbl := Replicate(" ",6)
                dVarlvl := CtoD("//")
			Endif
		#ENDIF
		End Transaction
	EndIf
ElseIf nOpc == 2
	#IFDEF TOP
		xlQuery4  := .T.
		BeginSql alias xVaTemp4
			SELECT TOP 1 SZ9.Z9_SEQ AS SEQ
			FROM %table:SZ9% SZ9
			WHERE   SZ9.Z9_FILIAL = %xfilial:SZ9% 		AND
			//SZ9.Z9_IMEI = %exp: (AllTrim(cImei))%		AND
			SZ9.Z9_NUMOS = %exp: (AllTrim(cOs))%		AND
			SZ9.Z9_PARTNR = %exp: (AllTrim(cPeca))%	AND
			SZ9.Z9_COLETOR = %exp: 'S'%				AND
			SZ9.%notDel%
			ORDER BY SZ9.R_E_C_N_O_
		EndSql
		If !Empty(AllTrim((xVaTemp4)->SEQ))
			If SZ9->(dbSeek(xFilial("SZ9") + cOs + (xVaTemp4)->SEQ + cPeca)) //Z9_FILIAL+Z9_NUMOS+Z9_SEQ+Z9_PARTNR
				If SZ9->Z9_COLETOR == "S"
					Begin Transaction
					RecLock("SZ9",.F.)
					SZ9->Z9_USREXCL := AllTrim(_CodTec) + " - " + AllTrim(cUsername)
					dbDelete()
					msunlock()
					//Pocisiona Produto
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + Left(cPeca,15)))
					aAdd(aItens,{Left(cPeca,15),;			 	// Produto Origem
					Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
					AllTrim(SB1->B1_UM),;                     	// Unidade Medida
					cArmDes,;                            		// Local Origem
					AllTrim(cEndDes),;                 			// Ender Origem
					Left(cPeca,15),;		                  	// Produto Destino
					Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
					AllTrim(SB1->B1_UM),;                     	// Unidade Medida
					cArmOri,;                   				// Local Destino
					AllTrim(cEndOri),;         					// Ender Destino
					Space(20),;                               	// Num Serie
        			cVarlto ,;                               	// Lote
		        	cVarsbl ,;                              	// Sub Lote
	         		dVarlvl ,;                              	// Validade
					0,;                                        	// Potencia
					1,;	                            			// Quantidade
					0,;                                       	// Qt 2aUM
					"N",;                                     	// Estornado
					Space(06),;                               	// Sequencia
	     			cVarltd ,;                               	// Lote Desti
		        	dVarlvl ,;                              	// Validade Lote
		   		    Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
					Space(03)})									// Item Grade
					If Len(aItens) >0
						u_BaixPeca("",aItens,3)
					Endif
					End Transaction
				Else
					VTBEEP(3)
					VTAlert("------Pe็a nใo localizado, favor analisar.--------","Alerta",.T.,2500)
					//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
					cVarBos	:= Replicate(" ",08)
					cVarBpe	:= Replicate(" ",25)
					cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
				EndIf
			Else
				VTBEEP(3)
				VTAlert("------Pe็a nใo localizado, favor analisar.--------","Alerta",.T.,2500)
				//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
				cVarBos	:= Replicate(" ",08)
				cVarBpe	:= Replicate(" ",25)  
				cVarltd := Replicate(" ",10)
                cVarlto := Replicate(" ",10)
                cVarsbl := Replicate(" ",6)
                dVarlvl := CtoD("//")
			EndIf
		Else
			VTBEEP(3)
			VTAlert("------Pe็a nใo localizado, favor analisar.--------","Alerta",.T.,2500)
			//cVarBar	:= space(TamSX3("ZZ4_IMEI")[1])//Replicate(" ",15)
			cVarBos	:= Replicate(" ",08)
			cVarBpe	:= Replicate(" ",25)
			cVarltd := Replicate(" ",10)
            cVarlto := Replicate(" ",10)
            cVarsbl := Replicate(" ",6)
            dVarlvl := CtoD("//")
		EndIf
		If xlQuery4
			(xVaTemp4)->( DbCloseArea())
		Endif
	#ENDIF
EndIf
Return()  


Static function vallote(lote,cComp,cArm)
		   
Local _lvalid  := .f.		      
Local nSalb8   := 0.00                          
Local nSallote := 0.00

		   
		   dbselectarea("SB8")
			   SB8->(dbsetorder(3)) 
			  
				 //IF SB8->(DBSeek(xFilial('SB8')+cCod+cLocal+left(clotesub,10)+substr(clotesub,11,6)))  // Retirado essa op็ใo de procurar por lote e sublote definido
			   IF SB8->(DBSeek(xFilial('SB8')+Left(cPeca,15) + Left(cArm,2)))  
				   Do While !SB8->(EOF()) .AND. SB8->B8_FILIAL = XFILIAL("SB8") .AND. SB8->B8_PRODUTO = Left(cComp,15) .AND. SB8->B8_LOCAL = Left(cArm,2)
				         IF alltrim(lote) == ALLTRIM(SB8->B8_LOTECTL)
				            nSallote :=  QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,.F.,Nil,date()))//QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrevisto,Nil,dEmis260)) 
				            nSalb8   :=  nSalb8+nSallote    
				            cVarsbl  := SB8->B8_NUMLOTE
                            dVarlvl  := SB8->B8_DTVALID
                            _lvalid  :=.t.
				         ENDIF   
			         SB8->(DbSkip())
			      EndDo     
	   
		          If    nSalb8 < 1
               
               			VTBEEP(3)
               			VTAlert("------Saldo de lote ้ insuficiente !--------","Alerta",.T.,2500)
			            cVarltd := Replicate(" ",10)
                        cVarlto := Replicate(" ",10)
                        cVarsbl := Replicate(" ",6)
                        dVarlvl := CtoD("//")
    		            _lvalid	:= .F.
 		  
	  	          Endif
		       Else    

		            VTBEEP(3)
           			VTAlert("------Nใo hแ lote para o almoxarifado !--------","Alerta",.T.,2500)
		            cVarltd := Replicate(" ",10)
                    cVarlto := Replicate(" ",10)
                    cVarsbl := Replicate(" ",6)
                    dVarlvl := CtoD("//")
	                _lvalid	:= .F.
			   ENDIF
Return(_lvalid)

