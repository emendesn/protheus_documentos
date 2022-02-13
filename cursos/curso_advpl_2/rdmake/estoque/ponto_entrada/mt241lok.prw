#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MT241LOK  ∫Autor  ≥Luciano Oliveira       ∫ Data ≥ 25/07/14 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥LOCALIZA«√O: A241LinOk (Consistencias apos a digitacao da   ∫±±
±±∫          ≥             tela de Inclusao de MovimentaÁ„o Interna)      ∫±±
±±∫          ≥EM QUE PONTO:ApÛs a confirmaÁ„o da digitaÁ„o da linha,antes ∫±±
±±∫          ≥             da gravaÁ„o, deve ser utilizado como validaÁ„o ∫±±
±±∫          ≥             complementar desta. Este ponto de entrada      ∫±±
±±∫          ≥             somente ser· executado se a linha da getdados  ∫±±
±±∫          ≥             for validada pela funÁ„o A241LinOk.            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥BGH                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function MT241LOK()
Local aArea			:= GetArea()
Local lRet			:= .T.
Local nAt			:= ParamIxb[1]
Local _nPosxGrMovi	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D3_XGRMOVI"})
Local _nPosLOCOri	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})
Local cGrupo		:= aCols[naT,_nPosxGrMovi]
Local cLocal		:= aCols[naT,_nPosLocOri]
u_GerA0003(ProcName())
If Upper(Funname()) $ "MATA241"
	If !acols[nAt][len(aHeader)+1]
		If Alltrim(cTM) == "998" .and. Empty(cGrupo)
			lRet := .F.
			MsgAlert("Favor preencher o campo Grupo Mov. para prosseguir!")
		EndIf
	EndIf
EndIf
//Valida existencia do armazem
dbSelectArea("NNR")
dbSetOrder(1)
If !dbSeek(xFilial("NNR")+cLocal,.F.)
	ApMsgStop("Armazem "+Alltrim(cLocal)+" n√£o existente no Cadastro. Entrar em contato com a Controladoria!","Armaz√©m inv√°lido")
	Return(.F.)
Else
	If NNR->NNR_MSBLQL == "1"
		ApMsgStop("Armazem "+Alltrim(cLocal)+" bloqueado. Entrar em contato com a Controladoria!","Armaz√©m bloqueado")
		Return(.F.)
	EndIf
EndIf
RestArea(aArea)
Return lRet