#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PRTOPDEF.CH
"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT240TOK  ºAutor  ³Graziella Bianchin  º Data ³  09/22/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para pegar o numero da requisicao e jogar º±±
±±º          ³ no numero da requisicao quando houver baixa de requisicoes.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso Exclusivo da empresa BGH                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT240TOK()

Local lRet := .T.
Local lValidaDoc :=GetNewPar("MV_VLDDOC","N") == "N"
Local _cArmzPr  := GETMV("BH_ARMZPR",.F.,"15")//Armazem de Processo

Local _cTMArm51 := GETMV("BH_TMARM51",.F.,"504")//TM Armazem qdo a

u_GerA0003(ProcName())

Private cSenhAce := GETMV("BH_PLIBPR",.F.,"processo")//Armazem de Processo


IF !Empty(Alltrim(SCP->CP_NUM))
	M->D3_DOC = Alltrim(SCP->CP_NUM)
Endif	
//-- Validações do usuário para inclusão do movimento   


If Alltrim(M->D3_LOCAL) $ _cArmzPr
	If !Upper(Funname()) $ "U_APONTACD" .and. !Upper(Funname()) $ "U_AXZZ3" .AND. !IsBlind() 
		lUsrAut  	:= .F.
		aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
		For i := 1 to Len(aGrupos)
			If AllTrim(GRPRetName(aGrupos[i])) $ "MOVPROC"
				lUsrAut  := .T.
			EndIf
		Next i
		If !lUsrAut 
			If ApMsgYesNo('Usuario não autorizado para efetuar movimentação em Armazem de Processo! Possui senha de liberação?','Movimentação')
				IF !u_VldSenha()
                   	lRet := .F.
                Endif					
			Else
				lRet := .F.
			Endif
			If !lRet
				Alert("Usuario não informado ou não autorizado! Favor verificar com o responsavel!")
			Endif
		Endif
	Endif
Endif

IF M->D3_LOCAL=="51" .and. M->D3_TM <> _cTMArm51
	Alert("TM informada esta incorreta! Utilizar a TM "+_cTMArm51+" para requisições do armazem 51.")
	lRet := .F.
Endif	

Return(lRet) 


