#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHG001  ºAutor  ³Alexandre Nicoletti º Data ³  02/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho responsavel pelo preenchimento do numero de chamadoº±±
±±º          ³ e numero de OS a partir da digitacao do numero de IMEI     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AB9_SN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BGHG001()

Local _aSavArea := GetArea()
Local _aAB6Area := AB6->(GetArea())
Local _aZZ4Area := ZZ4->(GetArea())
Local _cSN      := M->AB9_SN
Local _cNrCham 	:= ""
Local _cNumOs	:= ""


u_GerA0003(ProcName())

DbSelectArea("AB2")
DbSetOrder(5)  // AB2_FILIAL + AB2_NUMSER
If DbSeek(xFilial("AB2")+_cSN)
	While AB2->(!Eof()) .and. xFilial("AB2") == AB2->AB2_FILIAL .and. AB2->AB2_NUMSER == _cSN
		DbSelectArea("AB7")
		DbSetOrder(1)
		If DbSeek(xFilial("AB7")+AB2->AB2_NUMOS) //Edson Rodrigues - 12/03/08
			If AB7->AB7_TIPO $ "13"
				_cNrCham := AB2->AB2_NRCHAM
				_cNumOs  := AB2->AB2_NUMOS
			Endif
		Endif
		DbSelectArea("AB2")
		AB2->(DbSkip())
	EndDo
EndIf

// Alerta usuario sobre a quantidade de vezes que o aparelho ja entrou para manutencao - M.Munhoz - ERPPLUS - 08/10/2007
AB6->(dbSetOrder(1))
if !empty(_cNumOS) .and. AB6->(dbSeek(xFilial("AB6") + _cNumOs)) .and. AB6->AB6_NUMVEZ > "1"
	if !apMsgYesNo("Esta é a "+alltrim(AB6->AB6_NUMVEZ)+"a. vez que o IMEI "+alltrim(_cSN)+" entrou para manutenção. Confirma atendimento deste aparelho?","")
		RestArea(_aAB6Area)
		RestArea(_aSavArea)
		M->AB9_SWAPAN   := space(1)
		M->AB9_NRCHAM   := space(8)
		M->AB9_NUMOS    := space(8)
		M->AB9_XTRECE   := space(6)
		M->AB9_SN       := space(TamSX3("ZZ4_IMEI")[1])//space(20)
		_cSN := space(TamSX3("ZZ4_IMEI")[1])//space(20)
		Return(_cSN)
	endif
endif

DbSelectArea("AB7")
DbSetOrder(1)
If DbSeek(xFilial("AB7")+_cNumOs)
	
	If AB7->AB7_TIPO == "4"
		MSGBOX("A Ordem de Serviço referente ao atendimento já está como atendida !!","Atenção !","INFO")
	elseif !empty(AB7->AB7_SWAPAN)
		if !ApMsgYesNo("Esse IMEI trata-se de SWAP ANTECIPADO e portanto não deveria sofrer atendimento. Confirma inclusão do atendimento deste IMEI?","Swap Antecipado")
			M->AB9_SWAPAN   := space(1)
			M->AB9_NRCHAM   := space(8)
			M->AB9_NUMOS    := space(8)
			M->AB9_XTRECE   := space(6)
			M->AB9_SN       := space(TamSX3("ZZ4_IMEI")[1])//space(20)
			_cSN            := space(TamSX3("ZZ4_IMEI")[1])//space(20)
			RestArea(_aSavArea)
			Return(_cSN)
		endif
	EndIf
	
	M->AB9_SWAPAN 	:=  iif(!empty(AB7->AB7_SWAPAN), "S", "N")
	
EndIf

M->AB9_NRCHAM	:=  _cNrCham
M->AB9_NUMOS 	:=  _cNumOs

// Alterado por M.Munhoz - ERP PLUS - 24/04/2007
dbSelectArea("ZZ4")
dbSetOrder(1)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
if dbSeek(xFilial("ZZ4") + _cSN + left(_cNumOs,6))
	
	// Vincular ao item da NF Entrada, apenas se local = 26
	// Alterado por M.Munhoz - ERP PLUS - 07/05/2007
	if !empty(ZZ4->ZZ4_NFENR)
		_aAreaSD1 := SD1->(GetArea())
		SD1->(dbSetOrder(1))
		if SD1->(dbSeek(xFilial("SD1") + ZZ4->ZZ4_NFENR + ZZ4->ZZ4_NFESER + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA)) .and. SD1->D1_LOCAL == '26'
			M->AB9_XPODAT := ZZ4->ZZ4_DATA
			M->AB9_XPOSUP := Posicione("SA1", 1, xFilial("SA1") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA, "A1_NREDUZ")
		endif
		restarea(_aAreaSD1)
	endif
	
	M->AB9_XTRECE := ZZ4->ZZ4_EMHR
	
endif

RestArea(_aAB6Area)
RestArea(_aSavArea)
RestArea(_aZZ4Area)
M->AB9_SN := _cSN

Return(_cSN)