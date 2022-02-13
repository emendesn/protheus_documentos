#INCLUDE "APWEBSRVl.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "APVT100.CH"
#DEFINE ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLDTRAV  บAutor ณ Hudson de Souza Santos บ Data ณ 09/10/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que verifica se o Imei esta travado de acordo com a บฑฑ
ฑฑบ          ณ tabela de motivos SX5(HL) e envia e-mail para avisar o     บฑฑ
ฑฑบ          ณ ocorrido.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cFil   : Filial.                                          บฑฑ
ฑฑบ          ณ _cImei  : Imei.                                            บฑฑ
ฑฑบ          ณ _cOS    : OS.                                              บฑฑ
ฑฑบ          ณ _aOri   : Define array com informa็๕es de origem:          บฑฑ
ฑฑบ          ณ          • Primeiro parametro define:                      บฑฑ
ฑฑบ          ณ            C = Coletor (Utilizar VAlert).                  บฑฑ
ฑฑบ          ณ            W = WebService (Utilizar Connout)               บฑฑ
ฑฑบ          ณ            P = Protheus (Utilizar Alert)                   บฑฑ
ฑฑบ          ณ          • Segundo parametro define qual arquivo.          บฑฑ
ฑฑบ          ณ          • Terceiro parametro define qual fun็ใo.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VLDTRAV(_cFil, _cImei, _cOs, _aOri)
Local lRet		:= .T.
Local aArea		:= GetArea()
//Local aAreaZZ4	:= GetArea("ZZ4")
Local aAreaZ15	:= GetArea("Z15")
Local aAreaSX5	:= GetArea("SX5")
Local cMotivo	:= ""
Local cMens		:= ""
Local cMens2	:= ""
Local cAssu		:= ""
Local cDest		:= ""
Local cCopy		:= ""

/*
_cFil	:= AvKey(_cFil,		"ZZ4_FILIAL")
_cImei	:= AvKey(_cImei,	"ZZ4_IMEI"	)
_cOs	:= AvKey(_cOs,		"ZZ4_OS"	)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Lista todos motivso cadastrados na tabela SX5  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"HL")
While SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == "HL"
If !Empty(cMotivo)
cMotivo += ","
EndIf
cMotivo += SX5->X5_CHAVE
dbSkip()
EndDo
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Verifica se o conte๚do do campo ZZ4_TRAVA esta contido nos motivos cadastrados na SX5  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("ZZ4")
dbSetOrder(1)
If dbSeek(_cFil + _cImei + _cOs)
If !Empty(cMotivo) .AND. ZZ4->ZZ4_TRAVA $ Alltrim(cMotivo) .AND. !Empty(ZZ4->ZZ4_TRAVA)
lRet	:= .F.
cAssu	:= "Imei '" + Alltrim(_cImei) + "' travado em [" + Alltrim(_aOri[3]) + "," + Alltrim(_aOri[2]) + "]"
cMens	:= "O Imei '"
cMens	+= Alltrim(_cImei)
cMens	+= "' com O.S. '"
cMens	+= Alltrim(_cOs)
cMens	+= "' esta travado por '"
cMens	+= Alltrim(POSICIONE("SX5",1,xFilial("SX5")+"HL"+ZZ4->ZZ4_TRAVA,"X5_DESCRI"))
cMens	+= "'." + ENTER
cMens2	:= ENTER + ENTER
cMens2	+= Replicate("-",20) + "Informa็๕es T้cnicas" + Replicate("-",20)
cMens2	+= ENTER
cMens2	+= "Arquivo" + Replicate(".",20-Len("Arquivo")) + ":" + _aOri[2]
cMens2	+= ENTER
cMens2	+= "Fun็ใo"  + Replicate(".",20-Len("Fun็ใo"))  + ":" + _aOri[2]
cMens2	+= ENTER
U_ENVIAEMAIL(cAssu,"sistemas@bgh.com.br","",cMens+cMens2,"")
If _aOri[1] == "P"
MsgStop(cMens + " Favor entrar em contato com 'RELACIONAMENTO COORPORATIVO'!","Pe็a Travada")
ElseIf _aOri[1] == "W"
ConOut(cMens + " Favor entrar em contato com 'RELACIONAMENTO COORPORATIVO'!")
ElseIf _aOri[1] == "C"
VTBEEP(3)
VTAlert(cMens + " Favor entrar em contato com 'RELACIONAMENTO COORPORATIVO'!",.T.,2500)
EndIf
EndIf
EndIf
RestArea(aAreaSX5)
RestArea(aAreaZZ4)
RestArea(aArea)
*/
_cFil	:= AvKey(_cFil,		"Z15_FILIAL")
_cImei	:= AvKey(_cImei,	"Z15_IMEI"	)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Verifica se o conte๚do do campo ZZ4_TRAVA esta contido nos motivos cadastrados na SX5  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("Z15")
dbSetOrder(1)
If Z15->(dbSeek(_cFil + Alltrim(_cImei)))
	If(Z15->Z15_MSBLQL != "1") //[DEVE ESTAR DESBLOQUEADO PARA FUNCIONAR]
		lRet	:= .F.
		cAssu	:= "Imei '" + Alltrim(_cImei) + "' travado em [" + Alltrim(_aOri[3]) + "," + Alltrim(_aOri[2]) + "]"
		cMens	:= "O Imei '"
		cMens	+= Alltrim(_cImei)
		cMens	+= "' com O.S. '"
		cMens	+= Alltrim(_cOs)
		cMens	+= "' esta travado por '"
		cMens	+= Alltrim(POSICIONE("Z12",1,xFilial("Z12")+Z15->Z15_MOTIVO,"Z12_DESC"))
		cMens	+= "'." + ENTER
		cMens2	:= ENTER + ENTER
		cMens2	+= Replicate("-",20) + "Informa็๕es T้cnicas" + Replicate("-",20)
		cMens2	+= ENTER
		cMens2	+= "Arquivo" + Replicate(".",20-Len("Arquivo")) + ":" + _aOri[2]
		cMens2	+= ENTER
		cMens2	+= "Fun็ใo"  + Replicate(".",20-Len("Fun็ใo"))  + ":" + _aOri[2]
		cMens2	+= ENTER
		
		
		cDest := GetInfo(Alltrim(POSICIONE("Z12",1,xFilial("Z12")+Z15->Z15_MOTIVO,"Z12_USER")),"email")
		cCopy := Lower(Alltrim(POSICIONE("Z12",1,xFilial("Z12")+Z15->Z15_MOTIVO,"Z12_REPO")))
		//[Caso usuario nao tiver e-mail cadastrado, manda somente pro report]
		If Empty(cDest)
			cDest := cCopy
			cCopy := ""
		EndIf
		
		
		U_ENVIAEMAIL(cAssu,cDest,cCopy,cMens+cMens2,"")
		
		
		
		
		If _aOri[1] == "P"
			MsgStop(cMens,"Pe็a Travada")
		ElseIf _aOri[1] == "W"
			ConOut(cMens)
		ElseIf _aOri[1] == "C"
			VTBEEP(3)
			VTAlert(cMens,.T.,2500)
		EndIf
	EndIf
EndIf

RestArea(aAreaZ15)
RestArea(aArea)

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetInfo   บAutor  ณMicrosiga           บ Data ณ  06/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetona informacoes Pertinentes ao usuario                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetInfo(cUser,cInfo)
Local aUser    := {}
Local cRetorno := ""

PswOrder(2)
If PswSeek( cUser, .T. )
	aUser := PSWRET() // Retorna vetor com informa็๕es do usuแrio
EndIf

If(cInfo=="email")
	cRetorno := Alltrim(aUser[1][14])
EndIf



Return cRetorno


