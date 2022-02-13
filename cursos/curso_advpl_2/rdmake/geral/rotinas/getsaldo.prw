#Include 'Protheus.ch'
#Include "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AXSZ8    ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  26/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetSaldo()

Private oProduct
Private ccProduct := Space(20)

Private oImei
Private ccImei := Space(20)


Private _oDlgETI



Define MsDialog _oDlgETI Title "Verifica Saldo / Defeito Reclamado" From C(275),C(345) To C(465),C(602) Pixel
@ C(000),C(001) To C(95),C(130) Label "PartNumber/IMEI" Pixel Of _oDlgETI

@ C(015),C(015) Say "PN: " Size C(035),C(010) Color CLR_BLACK Pixel Of _oDlgETI
@ C(015),C(035) MsGet oProduct Var ccProduct Size C(065),C(010) Color CLR_BLACK 	Valid GetSbf() 	Pixel Of _oDlgETI

@ C(035),C(015) Say "IMEI: " Size C(035),C(010) Color CLR_BLACK Pixel Of _oDlgETI
@ C(035),C(035) MsGet oImei Var ccImei Size C(065),C(010) Color CLR_BLACK 	Valid GetDef() 	Pixel Of _oDlgETI


Define Sbutton From C(075),C(040) Type 1 Enable Of _oDlgETI Action()
Define Sbutton From C(075),C(065) Type 2 Enable Of _oDlgETI Action(_oDlgETI:end())

Activate MsDialog _oDlgETI Centered




Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.³ GetDef                                                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetDef()
Local cMensagem := ""
Local cQryWa := ""

If !Empty(Alltrim(ccImei))
	
	If Select("WASZA") > 0
		WASZA->(dbCloseArea())
	endif
	
	cQryWa :="	SELECT TOP 1	"
	cQryWa +="		 [IMEI]		= [ZZ4].[ZZ4_IMEI] "
	cQryWa +="		,[OS]	    = [ZZ4].[ZZ4_OS] "
	cQryWa +="		,[MODELO]   = [SB1].[B1_DESC] "
	cQryWa +="		,[DEFEITO]  = [SZA].[ZA_DEFCONS] "
	cQryWa +="	FROM [PROTHEUS].[dbo].[ZZ4020](NOLOCK) AS [ZZ4] "
	cQryWa +="	JOIN [PROTHEUS].[dbo].[SZA020](NOLOCK) AS [SZA] "
	cQryWa +="	ON ( [SZA].[ZA_IMEI] = [ZZ4].[ZZ4_IMEI] "
	cQryWa +="  	And [SZA].[ZA_IMEI]		= [ZZ4].[ZZ4_IMEI] "
	cQryWa +="  	And [SZA].[ZA_CLIENTE]	= [ZZ4].[ZZ4_CODCLI] "
	cQryWa +="  	And [SZA].[ZA_NFISCAL]	= [ZZ4].[ZZ4_NFENR] "
	cQryWa +="  	And [SZA].[D_E_L_E_T_]	= [ZZ4].[D_E_L_E_T_] "
	cQryWa +="  	) "
	cQryWa +="  JOIN [PROTHEUS].[dbo].[SB1020](NOLOCK) AS [SB1] "
	cQryWa +="  ON ([SB1].[B1_COD] = [ZZ4].[ZZ4_CODPRO]) "
	cQryWa +="  WHERE	[ZZ4].[D_E_L_E_T_] = '' "
	cQryWa +="  AND		[ZZ4].[ZZ4_FILIAL] = '02' "
	cQryWa +="  AND     [ZZ4].[ZZ4_STATUS] <= '5' "
	cQryWa +="  AND		[ZZ4].[ZZ4_IMEI]   = '"+ccImei+"'	"
	
	TCQUERY cQryWa NEW ALIAS "WASZA"
	
	
	
	dbSelectArea("WASZA")
	WASZA->(dbGoTop())
	cMensagem := "<table border = '1'>"
	while WASZA->(!eof())
		cMensagem += "<tr><td>IMEI		</td><td>"+WASZA->IMEI		+"</td></tr>"
		cMensagem += "<tr><td>OS		</td><td>"+WASZA->OS		+"</td></tr>"
		cMensagem += "<tr><td>MODELO	</td><td>"+WASZA->MODELO	+"</td></tr>"
		cMensagem += "<tr><td>DEFEITO	</td><td>"+WASZA->DEFEITO	+"</td></tr>"
		
		WASZA->(dbSkip())
	EndDo
	cMensagem += "</table>"
	
	WASZA->(dbCloseArea())
	
	MsgInfo(cMensagem)
	
EndIf

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.³ GetSbf                                                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSbf()
Local cMsgSbf := ""
Local cQryWb := ""

If !Empty(Alltrim(ccProduct))
	
	If Select("WASBF") > 0
		WASBF->(dbCloseArea())
	endif
	
	cQryWb :="SELECT "
	cQryWb +="	[PRODUTO]		=	[SBF].[BF_PRODUTO] "
	cQryWb +=",	[ARMAZEM]		=	[SBF].[BF_LOCAL] "
	cQryWb +=",	[ENDERECO]		=	[SBF].[BF_LOCALIZ] "
	cQryWb +=",	[QUANTIDADE]	=	SUM([SBF].[BF_QUANT]-[SBF].[BF_EMPENHO]) "
	cQryWb +="FROM [PROTHEUS].[dbo].[SBF020](NOLOCK) as [SBF] "
	cQryWb +="  JOIN [PROTHEUS].[dbo].[SB1020](NOLOCK) AS [SB1] "
	cQryWb +="  ON ([SB1].[B1_COD] = [SBF].[BF_PRODUTO]) "
	cQryWb +="WHERE	[SBF].[D_E_L_E_T_]	 =	'  ' "
	cQryWb +="AND	[SBF].[BF_FILIAL]	 =	'02' "
	cQryWb +="AND	[SBF].[BF_PRODUTO]	 =	'"+Alltrim(ccProduct)+"' "
	cQryWb +="AND   [SBF].[BF_LOCAL]	 =	'S3' "
	cQryWb +="GROUP BY  [SBF].[BF_PRODUTO],[SBF].[BF_LOCAL],[SBF].[BF_LOCALIZ] "
	
	TCQUERY cQryWb NEW ALIAS "WASBF"
	
	
	dbSelectArea("WASBF")
	WASBF->(dbGoTop())
	cMsgSbf := "<table border = '1'>"
	cMsgSbf += "<tr>"
	cMsgSbf += "<th>PARTNUMBER</th>"
	cMsgSbf += "<th>ARMAZEM</th>"
	cMsgSbf += "<th>ENDERECO</th>"
	cMsgSbf += "<th>QUANTIDADE</th>"
	cMsgSbf += "</tr>"
	while WASBF->(!eof())
		cMsgSbf += "<tr>"
		cMsgSbf += "<td>"+WASBF->PRODUTO+"</td>"
		cMsgSbf += "<td>"+WASBF->ARMAZEM+"</td>"
		cMsgSbf += "<td>"+WASBF->ENDERECO+"</td>"
		cMsgSbf += "<td>"+Str(WASBF->QUANTIDADE)+"</td>"
		cMsgSbf += "</tr>"
		WASBF->(dbSkip())
	EndDo
	cMsgSbf += "</table>"
	
	WASBF->(dbCloseArea())
	
	MsgInfo(cMsgSbf)
EndIf

Return

