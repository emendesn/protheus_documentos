#Include "rwmake.ch" 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT460GRV  ºAutor  ³                    º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no atendimento da OS que executa a saida  º±±
±±º          ³ massiva automaticamente.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT460GRV()

Local aArea     := GetArea()
//Local nPosSint  := aScan(aHeaderSZ9,{|x| Alltrim(x[2])=="Z9_SYMPTO"})
//Local nPosItem  := aScan(aHeaderSZ9,{|x| Alltrim(x[2])=="Z9_ITEM"})
Local cLocAuto  := GetMv("MV_XSMAUTO")
Local _aAreaZZ4 := ZZ4->(GetArea())
Local _aAreaSD1 := SD1->(GetArea())
Local _aAreaAB7 := AB7->(GetArea())

u_GerA0003(ProcName())

/*
dbSelectArea("SM0")
If SM0->M0_CODIGO != '02' //Sao Paulo
	dbSelectArea("AB2")
	AB2->(dbSetOrder(1)) //AB2_FILIAL+AB2_NRCHAM_AB2_ITEM+AB2_CODPRO+AB2_NUMSER
	If AB2->(dbSeek(xFilial("AB2")+AB9->AB9_NRCHAM))
		Reclock("AB2",.F.)
		AB2->AB2_D4C := "N"
		if AB9->AB9_TIPO=='1' //Encerrado
			AB2->AB2_STD4C  := "3" //Aguardando cliente retirar
			AB2->AB2_MOTD4C := "3" //Cliente nao foi avisado
		else
			AB2->AB2_STD4C := "1" //Em aberto
			AB2->AB2_MOTD4C := AB9->AB9_MTATEN
		endif
		MsUnlock("AB2")
	Endif
EndIf
*/
// Munhoz - ERP PLUS - 16/04/2007
// Se diferente de EXCLUSAO
/*
if paramixb[1] <> 3 .and. aColsSZ9 <> nil .and. len(aColsSZ9) > 0

	nUsado   := Len(aHeaderSZ9)
	For nCntFor := 1 To Len(aColsSZ9)

		If ( !aColsSZ9[nCntFor][nUsado+1] .And. !Empty(aColsSZ9[nCntFor][nPosSint]) )
			dbSelectArea("SZ9")
			dbSetOrder(1)
			If ( MsSeek(xFilial("SZ9")+M->AB9_NUMOS+M->AB9_CODTEC+M->AB9_SEQ+aColsSZ9[nCntFor][nPosItem]) )
				RecLock("SZ9",.F.)
			Else
				RecLock("SZ9",.T.)
			EndIf

			For nCntFor2 := 1 To nUsado
				If ( aHeaderSZ9[nCntFor2][10] != "V" )
					SZ9->(FieldPut(FieldPos(aHeaderSZ9[nCntFor2][2]),aColsSZ9[nCntFor][nCntFor2]))
				EndIf
			Next nCntFor2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os campos fixos                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SZ9->Z9_FILIAL   := xFilial("SZ9")
			SZ9->Z9_NUMOS    := M->AB9_NUMOS
			SZ9->Z9_CODTEC   := M->AB9_CODTEC
			SZ9->Z9_SEQ      := M->AB9_SEQ

		Else

			dbSelectArea("SZ9")
			dbSetOrder(1)
			If ( MsSeek(xFilial("SZ9")+M->AB9_NUMOS+M->AB9_CODTEC+M->AB9_SEQ+aColsSZ9[nCntFor][nPosItem]) )
				RecLock("SZ9")
				SZ9->( dbDelete() )
			EndIf

		EndIf

	Next nCntFor
	
	SZ9->(msunlock())

// Se EXCLUSAO
elseif paramixb[1] == 3

	dbSelectArea("SZ9")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SZ9")+M->AB9_NUMOS + M->AB9_CODTEC + M->AB9_SEQ ) )
		while SZ9->(!eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_NUMOS == M->AB9_NUMOS .and. ;
		      SZ9->Z9_CODTEC == M->AB9_CODTEC .and. SZ9->Z9_SEQ == M->AB9_SEQ
			RecLock("SZ9")
			SZ9->(dbDelete())
			SZ9->(msunlock())

			SZ9->(dbSkip())
		enddo
	EndIf

endif
*/
// Se Inclusao ou Alteracao de Atendimento ENCERRADO de OS efetua SAIDA MASSIVA automaticamente - M.Munhoz - ERPPLUS
If (paramixb[1] == 1 .or. paramixb[1] == 2) .and. AB9->AB9_TIPO == "1"
	AB7->(DBOrderNickName('AB7NUMSER')) //AB7_FILIAL+AB7_NUMOS+AB7_NUMSER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por M.Munhoz em 16/08/2011 - Indice do SD1 alterado para identificacao do item da NFE sem IMEI. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	SD1->(dbSetOrder(12))  // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER
	SD1->(dbSetOrder(1))  // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
	ZZ4->(dbSetOrder(1))   // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
	if ZZ4->(dbSeek(xFilial("ZZ4") + AB9->AB9_SN + left(AB9->AB9_NUMOS,6) ))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por M.Munhoz em 16/08/2011 - Posicionamento no SD1 realizado a partir da identificacao do item da NFE sem IMEI. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		if SD1->(dbSeek(xFilial("SD1") + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_CODPRO + ZZ4->ZZ4_IMEI)) .and. ;
//		SD1->D1_LOCAL $ cLocAuto
		if SD1->(dbSeek(xFilial("SD1") + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA + ZZ4->ZZ4_CODPRO + ZZ4->ZZ4_ITEMD1)) .and. ;
		SD1->D1_LOCAL $ cLocAuto

			_SerSai := {} 
			// Efetua gravacao do ZZ4
			u_tecx012grv(AB9->AB9_SN, "", "", .T.)
			// Executa saida massiva, gerando PV
//			u_WndConfirma(.t.)
			u_tecx012c(.t.)
		endif
	endif
	restarea(_aAreaZZ4)
	restarea(_aAreaSD1)
	restarea(_aAreaAB7)
EndIf

// exclusao do atendimento da OS
If paramixb[1] == 3 .and. AB9->AB9_TIPO == "1"

	ZZ4->(dbSetOrder(1)) // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
	If ZZ4->(dbSeek(xFilial("ZZ4") + AB9->AB9_SN + left(AB9->AB9_NUMOS,6))) .and. ZZ4->ZZ4_STATUS == '5' // Status = OS Encerrada
		reclock("ZZ4",.f.)
		ZZ4->ZZ4_STATUS := "4"  // Status = OS em atendimento
		msunlock()                  
		
		
	    //Procura o ultimo registro no ZZ3 
	    nReg  :=U_Verultapo(ZZ4->ZZ4_IMEI,ZZ4->ZZ4_OS)
	    nOpc  :=4          
	    _lRet := .T.
	    dbSelectArea("ZZ3")
	    cAlias :=alias()
	    ZZ3->(dbgoto(nReg))
	
	    If ZZ3->ZZ3_ESTORN == "S"
	           apMsgStop("O ultimo apontamento é um estorno e portanto não poderá ser estornado novamente. ","Apontamento não estornado")
	           _lRet := .f.
        Endif

        If ZZ3->ZZ3_STATUS == "0"
	        apMsgStop("O ultimo apontamento é temporário e portanto não necessita de ser estornado. ","Apontamento não estornado")
 	        _lRet := .f.
        Endif
          
		If _lRet		
           _lRet:=Processa( {|| U_ESTZZ3(cAlias,nReg,nOpc)}, "Aguarde...","Fazendo estorno do Apontamento", .T. )
        Endif
	Endif
	
endif

RestArea(aArea)
RestArea(_aAreaZZ4)

Return()              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Verultapo ºAutor  ³Edson Rodrigues     º Data ³  26/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ver se o ultimo apontamento                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function Verultapo(_cIMEI, _cNumOS)
local _aAreaZZ3 := ZZ3->(GetArea())
local _nrecno   := 0
local cselQry   := ""


If Select("QryZZ3") > 0
	QryZZ3->(dbCloseArea())
Endif

cselQry:=" SELECT MAX(R_E_C_N_O_) AS RECNZZ3 FROM ZZ3020 (NOLOCK) WHERE ZZ3_FILIAL='"+xFilial("ZZ3")+"' AND  ZZ3_IMEI='"+_cIMEI+"' AND LEFT(ZZ3_NUMOS,6)='"+left(_cNumOS,6)+"' AND D_E_L_E_T_='' "

TCQUERY cselQry ALIAS "QryZZ3" NEW


If Select("QryZZ3") > 0
	_nrecno:=QryZZ3->RECNZZ3
 	QryZZ3->(dbCloseArea())
Endif

restarea(_aAreaZZ3)

Return(_nrecno)
