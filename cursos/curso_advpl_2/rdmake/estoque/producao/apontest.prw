#INCLUDE "PROTHEUS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "APVT100.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ APONTEST ∫ Autor ≥Paulo Lopez         ∫ Data ≥  07/02/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥Tela para Apontamento Fases - COLETOR (ACD)                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GENERICO                                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫                     A L T E R A C O E S                               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Data      ∫Programador       ∫Alteracoes                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function ApontEst()

Private cVarMas  	:= Replicate(' ',20)
Private _UserId     := __cUserID
Private _CodTec 	:= Posicione("AA1",4,xFilial("AA1") + _UserId,"AA1_CODTEC")
Private _aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private _lUsrAut 	:= .F.
Private	_cApt01	  	:= GetMv("MV_APONT01")
Private	_cApt02	  	:= GetMv("MV_APONT02")
Private	_cFifo		:= GetMv("MV_FIFOEST")
Private _cOpera
Private	_cEtqMa
Private	_cLab
Private _nQtdSep    := 0
Private _nRecZZY    := 0
Private _cDocSep 	:= ""

u_GerA0003(ProcName())

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Valida acesso de usuario                                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
For i := 1 to Len(_aGrupos)
	
	//Usuarios de Autorizado
	
	//If AllTrim(GRPRetName(_aGrupos[i])) $ "Administradores#Estoque_ACD"
	If AllTrim(GRPRetName(_aGrupos[i])) $ "Administradores#Producao_ACD#delta.consultoria"
		
		_lUsrAut  := .T.
		
	EndIf
	
Next i

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//| Usuario Nao Autorizado                                              |
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !_lUsrAut
	
	
	VTBEEP(3)
	VTAlert("------Tecnico n„o Autorizado, Entrar em contato com Supervisor.--------","Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	
	VTClear()
	
	Return()
	
EndIf

If Empty(AllTrim(_CodTec))
	
	VTBEEP(3)
	VTAlert("------Tecnico n„o cadastrado, Entrar em contato com Supervisor.--------","Alerta",.t.,2500)
	cVarMas	:= Replicate(' ',20)
	
	VTClear()
	
	Return()
	
EndIf


CBChkTemplate()


While .t.
	VTClear
	nLin:= -1
	@ ++nLin,0 VTSAY "Coletor"
	If ! ApontEsta()
		Exit
	EndIf
	VTRead
	If (VTLastKey()==27)
		If !VTYesNo('Confirma a Saida?','AtenÁ„o')
			loop
		EndIf
		Exit
	EndIf
End

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥APONTESTA ∫ Autor ≥Paulo Lopez         ∫ Data ≥  07/02/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥Tela para Apontamento Fases - COLETOR (ACD)                 ∫±±
±±∫          ≥              ETQ MASTER                                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GENERICO                                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫                     A L T E R A C O E S                               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Data      ∫Programador       ∫Alteracoes                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function ApontEsta()

Local lRet	:=	.T.

VTClear()
VTClearBuffer()

DLVTCabec("Aponta Master Estoque",.F.,.F.,.T.)
@ 01, 00 VTGet cVarMas Pict '@!'	Valid ApontEstb(@cVarMas,'1')
VTRead

Return(lRet)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ApontEstb ∫Autor  ≥ Paulo Francisco    ∫ Data ≥ 07/02/2012  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Validacao Apontamento Fase  ACD                 			  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function ApontEstb(cCodBar,nOpc)

Local _lRet		:= .T.
Local _cEndBuf  := GetMv("MV_XENDBUF",.F.,"BUFFER")

#IFDEF TOP
	Local xVaTemp		:= GetNextAlias()
	Local xlQuery		:= .F.
	Local xVaTemp1		:= GetNextAlias()
	Local xlQuery1		:= .F.
	Local xVaTemp2		:= GetNextAlias()
	Local xlQuery2		:= .F.
#ENDIF

If nOpc == '1'
	
	#IFDEF TOP
		xlQuery  := .T.
		BeginSql alias xVaTemp
			SELECT TOP 1 ZZJ.ZZJ_LAB AS LAB, ZZ4.ZZ4_IMEI AS IMEI, ZZ4.ZZ4_OS AS OS, ZZ4.ZZ4_OPEBGH AS OPERA, ZZ4.ZZ4_CODPRO AS PRODU, ZZ4.ZZ4_ETQMEM AS MASTER
			FROM %table:ZZ4% ZZ4
			JOIN %table:ZZJ% ZZJ ON
			ZZJ.ZZJ_FILIAL = %xfilial:ZZJ% 				AND
			ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA   			AND
			ZZJ.%notDel%
			WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
			ZZ4.ZZ4_STATUS = %exp: '3'%					AND
			ZZ4.ZZ4_ETQMEM = %exp: cVarMas%				AND
			ZZ4.ZZ4_ENDES  = %exp: _cEndBuf%			AND
			ZZ4.%notDel%
		EndSql
		
		If Empty(AllTrim((xVaTemp)->MASTER))
			
			VTBEEP(3)
			VTAlert("------ Master n„o localizada no endereÁo BUFFER. Favor verificar! --------","Alerta",.t.,2500)
			cVarMas	:= Replicate(' ',20)
			
			_lRet := .F.
			
		EndIf
		
		If _lRet .And. _cFifo
			
			xlQuery1  := .T.
			BeginSql alias xVaTemp1
				SELECT TOP 1 ZZ4_ETQMEM AS ETQMA
				FROM %table:ZZ4% ZZ4
				WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 				AND
				ZZ4.ZZ4_STATUS 	= %exp: '3'%						AND
				ZZ4.ZZ4_OPEBGH	= %exp: AllTrim((xVaTemp)->OPERA)%	AND
				ZZ4.ZZ4_CODPRO	= %exp: AllTrim((xVaTemp)->PRODU)%	AND
				ZZ4.ZZ4_ETQMEM <> %exp:	''%							AND
				ZZ4.ZZ4_ETQMEM <  %exp:	cVarMas%					AND
				ZZ4.%notDel%
				ORDER BY ZZ4_ETQMEM
			EndSql
			
			If !Empty(AllTrim((xVaTemp1)->ETQMA))
				
				VTBEEP(3)
				VTAlert("------ Existe Master com Fifo " + AllTrim((xVaTemp1)->ETQMA) + ",favor analisar. --------","Alerta",.t.,2500)
				cVarMas	:= Replicate(' ',20)
				
				_lRet := .F.
				
			Else
				
				_cOpera	:=	AllTrim((xVaTemp)->OPERA)
				_cLab	:=	AllTrim((xVaTemp)->LAB)
				_cEtqMa	:=	cVarMas
				
			EndIf
			
		Else
			_cOpera	:=	AllTrim((xVaTemp)->OPERA)
			_cLab	:=	AllTrim((xVaTemp)->LAB)
			_cEtqMa	:=	cVarMas
			
		EndIf
		
		If xlQuery
			
			(xVaTemp)->( DbCloseArea())
			
		Endif
		
		If xlQuery1
			
			(xVaTemp1)->( DbCloseArea())
			
		Endif
		
	#ENDIF
	
EndIf

// Valida Se Etiqueta Master Possui Documento de Planejamento
If _lRet .AND. GETMV("BH_VALMAT",.F.,.T.)  // Parametro Para Validar Existencia da Etiqueta Master com o Documento planejado para ProduÁ„o)
	DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
	DbSetOrder(2)  // ZZY_FILIAL, ZZY_NUMMAS, ZZY_CODMAS, ZZY_CODPLA, R_E_C_N_O_, D_E_L_E_T_
	If ! DbSeek(xFilial("ZZY")+cVarMas ,.F.)
		VTBEEP(3)
		VTAlert("Etiqueta Master Nao Possui Documento de Separacao.","Alerta",.t.,2500)
		_lRet := .F.
	Else
		While ZZY->(!Eof()) .and. ZZY->(ZZY_FILIAL+ZZY_NUMMAS)==xFilial("ZZY")+cVarMas
			_lRet := .F.
			_nQtdSep := ZZY->ZZY_QTDMAS-ZZY->ZZY_QTDSEP
			If _nQtdSep > 0 .AND. ZZY->ZZY_TPRESE == "T"
				_cDocSep := ZZY->ZZY_NUMDOC
				_nRecZZY := ZZY->(RECNO())
				_lRet := .T.
			ElseIf _nQtdSep > 0 .and. ZZY->ZZY_TPRESE == "P"
				VTBEEP(3)
				VTAlert("Etiqueta Master Parcial, Deve ser separada por IMEI","Alerta",.t.,2500)
				_lRet := .F.
			Endif
			If _lRet
				ApontEstc()
			EndIf
			ZZY->(dbSkip())
		EndDo
	Endif
Endif

cVarMas	:= Replicate(' ',20)

Return(_lRet)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥APONTESTC ∫ Autor ≥Paulo Lopez         ∫ Data ≥  07/02/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥Tela para Apontamento Fases - COLETOR (ACD)                 ∫±±
±±∫          ≥            ETQ MASTER                                      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GENERICO                                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫                     A L T E R A C O E S                               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Data      ∫Programador       ∫Alteracoes                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ApontEstc()

Local _cCount  := 00.00
Local aSave    := {}
Local nPosicao := 1
Local aCabec   := {"Lab","Setor Destino","Fase Destino"}
Local aSize    := {2,6,5}
Local nAtiva   := GetNewPar("MV_XATVFS",0)

_cApt01 := ""
_cApt02 := ""

ZZ4->(DBOrderNickName('ZZ4ETQMEM'))
If ZZ4->(DbSeek(xFilial("ZZ4") + _cOpera + _cEtqMa))
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Busca as operacoes destinos de apontamento.≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If nAtiva == 1 .and. Left(_cOpera,1)=="N"
	
		aDestinos := RetFase(_cOpera, _cLab)
		If Len(aDestinos) == 0
			cVarMas := Space(TamSx3("ZZ4_ETQMEM")[1])
			Return
		EndIf
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Seleciona operacao destino		≥
		//≥ D.FERNANDES - 14/10/13   		≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		While .T.
			
			aSave := VTSAVE()
			VTClear()
			nPosicao := VTaBrowse(0,0,7,19,aCabec,aDestinos,aSize,,nPosicao)
			VtRestore(,,,,aSave)
			VTClearBuffer()
			
			If nPosicao > 0
				_cApt01 := GetMv("MV_APONT01",.F.,"000000/00")
				_cApt02 := Alltrim(aDestinos[nPosicao, 2])+"/"+Alltrim(aDestinos[nPosicao, 3])
			Else
				VTAlert("Nenhum item selecionado!!!")
				Loop
			EndIf
			
			If VTYesNo('Confirma apont. para Setor: '+_cApt01+' Fase: '+_cApt02, 'AtenÁ„o')
				Exit
			EndIf
			
		EndDo
		
	Else
		If Alltrim(_cOpera) == "P01"//POSITIVO PLACAS
			_cApt01 := GetMv("MV_FORIP01",.F.,"000001/01")
			_cApt02 := GetMv("MV_FDESP01",.F.,"000001/02")
		ElseIf Alltrim(_cOpera) == "P02" .OR. Alltrim(_cOpera) == "P03"//POSITIVO MAGAZINE
			_cApt01 := GetMv("MV_FORIP02",.F.,"000002/01")
			_cApt02 := GetMv("MV_FDESP02",.F.,"000002/02")
		ElseIf Alltrim(_cOpera) == "Y01"//SONY
			_cApt01 := GetMv("MV_FORIY01",.F.,"000001/01")
			_cApt02 := GetMv("MV_FDESY01",.F.,"000001/02")
		ElseIf Alltrim(_cOpera) == "N01"
			_cApt01 := GetMv("MV_APONT01",.F.,"000000/00")
			_cApt02 := GetMv("MV_APONT02",.F.,"000001/01")
		ElseIf Alltrim(_cOpera) == "N10"
			_cApt01 := GetMv("MV_APONT01",.F.,"000000/00")
			_cApt02 := GetMv("MV_APONT10",.F.,"000015/01")
		ElseIf Alltrim(_cOpera) == "N11"
			_cApt01 := GetMv("MV_APONT01",.F.,"000000/00")
			_cApt02 := GetMv("MV_APONT11",.F.,"000014/01")
		Endif
	EndIf
	
	Begin Transaction
	
	Do While !ZZ4->(EOF()) .And. ZZ4->ZZ4_FILIAL = xFilial("ZZ4") .And. ZZ4->ZZ4_OPEBGH == _cOpera .And. ZZ4->ZZ4_ETQMEM == _cEtqMa// .And. ZZ4->ZZ4_STATUS < '4'
		
		If _cCount >= _nQtdSep
			Exit
		Endif
		
		If ZZ4->ZZ4_STATUS < '4'  .and. Alltrim(ZZ4->ZZ4_DOCSEP)== Alltrim(_cDocSep)
			RecLock("ZZ3",.T.)
			
			ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
			ZZ3->ZZ3_CODTEC := _CodTec
			ZZ3->ZZ3_LAB    := _cLab
			ZZ3->ZZ3_DATA   := date()
			ZZ3->ZZ3_HORA   := Time()
			ZZ3->ZZ3_CODSET := Substr(_cApt01,1,6)
			ZZ3->ZZ3_FASE1  := Substr(_cApt01,8,2)
			ZZ3->ZZ3_CODSE2 := Substr(_cApt02,1,6)
			ZZ3->ZZ3_FASE2  := Substr(_cApt02,8,2)
			ZZ3->ZZ3_ENCOS  := "N"
			ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
			ZZ3->ZZ3_SWAP   := ""
			ZZ3->ZZ3_IMEISW := ""
			ZZ3->ZZ3_MODSW  := ""
			ZZ3->ZZ3_UPGRAD := ""
			ZZ3->ZZ3_NUMOS  := ZZ4->ZZ4_OS
			ZZ3->ZZ3_STATUS := "1"
			ZZ3->ZZ3_SEQ    := u_CalcSeq(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)//"01"
			ZZ3->ZZ3_USER   := cUserName
			ZZ3->ZZ3_ACAO   := ""
			ZZ3->ZZ3_LAUDO  := ""
			ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
			ZZ3->ZZ3_ESTORN := "N"
			ZZ3->ZZ3_STATRA := "0"
			ZZ3->ZZ3_ASCRAP := "N"
			
			MsUnlock()
			
			/// Localiza o Numero do Documento de SeparaÁ„o
			//_cDocSep  := ''
			_aAreaAtu := GetArea()
			/*
			DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
			DbSetOrder(2)  // ZZY_FILIAL, ZZY_NUMMAS, ZZY_CODMAS, ZZY_CODPLA, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial("ZZY")+ZZ4->ZZ4_ETQMEM ,.F.)
			_cDocSep := ZZY->ZZY_NUMDOC
			RecLock("ZZY",.F.)
			ZZY->ZZY_QTDSEP := ZZY->ZZY_QTDSEP+1
			msUnlock()
			Endif
			*/
			If _nRecZZY > 0
				DbSelectArea("ZZY")  // Tabela de Planejamento da Producao
				DbGoTo(_nRecZZY)
				//_cDocSep := ZZY->ZZY_NUMDOC
				RecLock("ZZY",.F.)
				ZZY->ZZY_QTDSEP := ZZY->ZZY_QTDSEP+1
				msUnlock()
			Endif
			
			RestArea(_aAreaAtu)
			
			RecLock("ZZ4",.F.)
			
			ZZ4->ZZ4_STATUS	:=	"4"
			ZZ4->ZZ4_SETATU := Substr(_cApt02,1,6)
			ZZ4->ZZ4_FASATU := Substr(_cApt02,8,2)
			/*
			If ! Empty(_cDocSep)
			ZZ4->ZZ4_DOCSEP := _cDocSep
			Endif
			*/
			MsUnlock()
			
			dbSelectArea("SZ9")
			SZ9->(dbsetorder(1))
			If SZ9->(dbSeek(xFilial("SZ9") + ZZ4->ZZ4_OS))
				While SZ9->(!eof()) .AND. SZ9->Z9_FILIAL == xFilial("SZ9") .AND. ;
					SZ9->Z9_NUMOS == ZZ4->ZZ4_OS 
					If !Empty(SZ9->Z9_PARTNR)
						lEstZZ3 := .T.
						dbSelectarea("ZZ3")
						ZZ3->(dbsetorder(1))
						If ZZ3->(dbSeek(xFilial("ZZ3") + SZ9->(Z9_IMEI+Z9_NUMOS+Z9_SEQ)))
							While ZZ3->(!eof()) .AND. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .AND. ;
								ZZ3->ZZ3_NUMOS == SZ9->Z9_NUMOS .AND. ZZ3->ZZ3_SEQ == SZ9->Z9_SEQ 
								If ZZ3->ZZ3_CODTEC == SZ9->Z9_CODTEC .AND. ZZ3->ZZ3_ESTORN <> "S"
									lEstZZ3 := .F.								
								Endif								
								ZZ3->(dbSkip())
							EndDo
						Endif						
						
						If lEstZZ3
							lAchZZ3 := .F.
							dbSelectarea("ZZ3")
							ZZ3->(dbsetorder(1))
							If ZZ3->(dbSeek(xFilial("ZZ3") + SZ9->(Z9_IMEI+Z9_NUMOS+Z9_SEQ)))
								While ZZ3->(!eof()) .AND. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .AND. ;
									ZZ3->ZZ3_NUMOS == SZ9->Z9_NUMOS .AND. ZZ3->ZZ3_SEQ == SZ9->Z9_SEQ 
									If ZZ3->ZZ3_CODTEC == SZ9->Z9_CODTEC .AND. ZZ3->ZZ3_ESTORN == "S" 
										
										lAchZZ3 	  := .T.
										_cTecZZ3      := ZZ3->ZZ3_CODTEC
										_cLabZZ3      := ZZ3->ZZ3_LAB
										_cSet1ZZ3     := ZZ3->ZZ3_CODSET
										_cSet2ZZ3     := ZZ3->ZZ3_CODSE2
										_cFas1ZZ3     := ZZ3->ZZ3_FASE1
										_cFas2ZZ3     := ZZ3->ZZ3_FASE2
										_cSeqZZ3      := ZZ3->ZZ3_SEQ
																			
										RecLock("ZZ3",.F.)
										ZZ3->ZZ3_ESTORN := "N"
										ZZ3->ZZ3_STATRA := "0"
//										ZZ3->ZZ3_DEVPRO := DTOC(date())+" - "+Alltrim(time())+" - "+Alltrim(cUserName)
										MsUnlock()
										                  
										RecLock("ZZ4",.F.)
										ZZ4->ZZ4_SETATU := _cSet2ZZ3 
										ZZ4->ZZ4_FASATU := _cFas2ZZ3  
										MsUnlock()
																				
										Exit																								
									Endif								
									ZZ3->(dbSkip())
								EndDo
							Endif		
							
							If lAchZZ3
								dbSelectarea("ZZ3")
								ZZ3->(dbsetorder(1))
								If ZZ3->(dbSeek(xFilial("ZZ3") + SZ9->(Z9_IMEI+Z9_NUMOS)))
									While ZZ3->(!eof()) .AND. ZZ3->ZZ3_FILIAL == xFilial("ZZ3") .AND. ZZ3->(ZZ3_IMEI+ZZ3_NUMOS) == SZ9->(Z9_IMEI+Z9_NUMOS) 
										If ZZ3->ZZ3_CODTEC == SZ9->Z9_CODTEC .AND. ZZ3->ZZ3_ESTORN == "S" .AND. ;
												 ZZ3->ZZ3_CODSET == _cSet2ZZ3 .AND. ZZ3->ZZ3_FASE1  == _cFas2ZZ3
											RecLock("ZZ3",.F.)
											dbDelete()
											MsUnlock()
											Exit																								
										Endif								
										ZZ3->(dbSkip())
									EndDo
								Endif		
							Endif
						Endif
					Endif
					SZ9->(dbSkip())
				EndDo
			Endif
			
			_cCount ++
		Endif
		ZZ4->(dbskip())
	Enddo
	
	If _cCount > 0
		VTBEEP(3)
		VTAlert("------ Transferido " + StrZero(_cCount,3) + " com Sucesso. --------","Alerta",.t.,2500)
		//cVarMas	:= Replicate(' ',20)
	Else
		VTBEEP(3)
		VTAlert("------ Transferencia n„o efetuada. Favor verificar ","Alerta",.t.,2500)
		//cVarMas	:= Replicate(' ',20)
	Endif
	
	End Transaction
	
EndIf

Return()
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RetFase   ∫Autor  ≥D.FERNANDES         ∫ Data ≥  10/14/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao para buscar operacoes destinos                      ∫±±
±±∫          ≥ do operador                                                ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ BGH DO BRASIL                                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function RetFase(cOperacao, cLab)

Local lContinua := .T.
Local aDestinos := {}
Local cQuery    := ""
Local cSetOri   := GetNewPar("MV_XSETORI","000000")
Local cfaseOri  := GetNewPar("MV_XFASORI","00")

//Posiciona no cadastro de tecnico
dbSelectArea("AA1")
dbSetOrder(4)

If MsSeek(xFilial("AA1")+__cUserID)
	
	cQuery := " SELECT DISTINCT ZZA_LAB, "
	cQuery += "		   ZZA_SETOR2, "
	cQuery += "		   ZZA_FASE2 "
	cQuery += "	FROM "+RetSqlName("ZZB")+" ZZB "
	cQuery += "	INNER JOIN "+RetSqlName("ZZA")+" ZZA ON ( ZZA_SETOR1 = ZZB_CODSET AND  "
	cQuery += "							  ZZA_FASE1 = ZZB_CODFAS AND  "
	cQuery += "							  ZZA_LAB = ZZB_LAB ) "
	cQuery += "	INNER JOIN "+RetSqlName("ZZ1")+" ZZ1 ON ( ZZ1_CODSET = ZZB_CODSET AND  "
	cQuery += "							  ZZ1_FASE1 = ZZB_CODFAS AND "
	cQuery += "							  ZZ1_LAB = ZZB_LAB )	"
	cQuery += "	INNER JOIN "+RetSqlName("ZZ2")+" ZZ2 ON ( ZZ2_CODSET = ZZA_SETOR2 )	"
	cQuery += "	WHERE ZZB_CODTEC = '"+AA1->AA1_CODTEC+"' "
	cQuery += "	AND ZZB.D_E_L_E_T_ = ''  "
	cQuery += "	AND ZZA.D_E_L_E_T_ = '' "
	cQuery += "	AND ZZ1_MSBLQL <> 1 "
	cQuery += "	AND ZZ2_OPERAC LIKE '%"+cOperacao+"%' "
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Filtra setor padrao se estiver preenchido≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cQuery += "	AND ZZB_CODSET = '"+cSetOri+"' "
	cQuery += "	AND ZZB_CODFAS = "+cfaseOri+" "
	cQuery += "	AND ZZB_LAB = '"+cLab+"' "
	cQuery += "	AND ZZ2_FILIAL = '"+xFilial("ZZ2")+"' "
	cQuery += "	AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' "
	cQuery += "	AND ZZA_FILIAL = '"+xFilial("ZZA")+"' "
	cQuery += "	AND ZZB_FILIAL = '"+xFilial("ZZB")+"' "
	
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)
	
	dbSelectArea("TSQL")
	TSQL->(dbGotop())
	
	While TSQL->(!Eof())
		
		AADD( aDestinos,{ ZZA_LAB,;
		ZZA_SETOR2,;
		ZZA_FASE2} )
		
		TSQL->(dbSkip())
	EndDo
	
Else
	lContinua := .F.
EndIf

If !lContinua .Or. Len(aDestinos) == 0
	VTBEEP(3)
	VTAlert("------Amarra«√O n„o encontrado para o tecnico, Entrar em contato com Supervisor.--------","Alerta",.T.,2500)
	VTClear()
EndIf

Return aDestinos
