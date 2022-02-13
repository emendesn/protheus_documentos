#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "Protheus.ch"
/* Cancelamento da Nota Fiscal de Saida - GRAVAR MOTIVO */
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2520E   บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SF2520E()
Local aArea := GetArea()
Private cPerg := padr("XMOTCNF",10)

u_GerA0003(ProcName())

//DEFINE MSDIALOG oLeTxt TITLE OemtoAnsi("Motivo de Exclusao de Nota Fiscal") FROM  200,1 TO 380,380 PIXEL
//ValidPerg(cPerg)

fCriaSX1(cPerg)

If Pergunte(cPerg, .T.)
	LeTabela()
EndIf

// Executa funcao para verificar existencia de IMEI com MCLAIM gerado
VerMCLAIM()

//Exclui Base Instalada em caso de Nota Fiscal da opera็ใo WS
_cQryAA3 := " SELECT "
_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
_cQryAA3 += " AND AA3_NFVEND='"+SF2->F2_DOC+"' "
_cQryAA3 += " AND AA3_SERINF='"+SF2->F2_SERIE+"' "
_cQryAA3 += " AND AA3_CODCLI='"+SF2->F2_CLIENTE+"' "
_cQryAA3 += " AND AA3_LOJA='"+SF2->F2_LOJA+"' "
_cQryAA3 += " AND AA3_XCLASS='S' "
_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
_cQryAA3 += " AND B1_COD=AA3_CODPRO "
_cQryAA3 += " AND B1_XCONTSE='S' "

_cQryAA3 := ChangeQuery(_cQryAA3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)

QRY1->(dbGoTop())
Do While QRY1->(!Eof())
	dbSelectArea("AA3")
	dbSetOrder(1)
	If dbSeek(xFilial("AA3")+QRY1->AA3_CODCLI+QRY1->AA3_LOJA+QRY1->AA3_CODPRO+QRY1->AA3_NUMSER)
		dbSelectArea("AAF")
		Reclock("AAF",.T.)
		AAF->AAF_FILIAL := xFilial("AAF")
		AAF->AAF_CODCLI := SF2->F2_CLIENTE
		AAF->AAF_LOJA   := SF2->F2_LOJA
		AAF->AAF_CODPRO := AA3->AA3_CODPRO
		AAF->AAF_NUMSER := AA3->AA3_NUMSER
		AAF->AAF_PRODAC := AA3->AA3_CODPRO
		AAF->AAF_NSERAC := AA3->AA3_NUMSER
		AAF->AAF_DTINI  := dDataBase
		AAF->AAF_CODFAB := AA3->AA3_CODFAB
		AAF->AAF_LOJAFA := AA3->AA3_LOJAFA
		AAF->AAF_LOGINI := Left( "EXC. NF SAIDA " + ALLTRIM(SF2->F2_SERIE) + "/" + ;
		ALLTRIM(SF2->F2_DOC) , Len( AAF->AAF_LOGINI ) )
		MsUnLock()
		
		RecLock("AA3",.F.)
		AA3->AA3_NFVEND := ""
		AA3->AA3_SERINF := ""
		MsUnLock()
	Endif
	dbSelectArea("QRY1")
	DbSkip()
Enddo
QRY1->(dbCloseArea())

EstorObj()

RestArea(aArea)
Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEstorObj  บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se gerou objeto dos Correios e o habilita novamenteบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EstorObj() 

Local aArea  := GetArea()
Local cQuery := "" 
Local _cAlias:= GetNextAlias()
Local cObj	 := ""

If Select("Z03") == 0
	DbSelectArea("Z03")
EndIf
Z03->(DbGoTop())

If Select("ZB2") == 0
	DbSelectArea("ZB2")
EndIf  
ZB2->(DbSetOrder(3))
ZB2->(DbGoTop())		
	
cQuery := " SELECT Z03.R_E_C_N_O_ AS RECNOZ03  FROM " + RetSqlName("Z03") + " Z03 (NOLOCK) " + CRLF 
cQuery += " WHERE " + CRLF
cQuery += " Z03_FILIAL = '"+xFilial("Z03")+"' " + CRLF 
cQuery += " AND Z03_DOC = '"+SF2->F2_DOC+"' " + CRLF 
cQuery += " AND Z03_SERIE = '"+SF2->F2_SERIE+"' " + CRLF 
cQuery += " AND Z03_DESTIN = '"+SF2->F2_CLIENTE+"' " + CRLF 
cQuery += " AND Z03_LOJDST = '"+SF2->F2_LOJA+"' " + CRLF 

cQuery := ChangeQuery(cQuery)  

If Select(_cAlias) > 0;( _cAlias )->( dbCloseArea() );EndIf
dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .t., .t.)
( _cAlias )->( dbGoTop() )

If ( _cAlias )->( !Eof() )
	Z03->(dbgoto(( _cAlias )->RECNOZ03))	
    If RecLock("Z03",.F.)    
    	Z03->Z03_CANCEL := 'S'    
    	Z03->(MsUnlock())
    
    	cObj := SubStr(Z03->Z03_OBJETO,1,10)+SubStr(Z03->Z03_OBJETO,12,2)
    	
    	If ZB2->(DbSeek(xFilial("ZB2")+AvKey(Z03->Z03_CODADM,"ZB2_CODADM")+AvKey(cObj,"ZB2_OBJETO")))	    
	    	If RecLock("ZB2",.F.)    
	    		ZB2->ZB2_USADO := ''    
	    		ZB2->(MsUnlock())
	    	EndIf
	    EndIf    	    
    EndIf    
EndIf   

RestArea(aArea)
	 
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2520E   บAutor  ณMicrosiga           บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeTabela()
Local aArea := GetArea()
Local nLogNf := 0
DbSelectArea("ZZD")
DbSetOrder(1)
SD2->(DbSetOrder(3))
ZZD->(dbSeek(xFilial("ZZD") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
Do While ! ZZD->(Eof()) .and.   ZZD->ZZD_FILIAL = XFILIAL("ZZD")    .and. ;
	ZZD->ZZD_DOC    = SF2->F2_DOC       .and. ;
	ZZD->ZZD_SERIE  = SF2->F2_SERIE     .and. ;
	ZZD->ZZD_CLIENT = SF2->F2_CLIENTE	.and. ;
	ZZD->ZZD_LOJA   = SF2->F2_LOJA
	nLogNf := ZZD->ZZD_SEQ
	ZZD->(DbSkip())
EndDo
If nLogNf = 0 // e o Primeiro Log de exclusao para a NF entao comeca em 1
	nLogNF := 1
Else
	nLogNF++
EndIf

//	SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
RecLock("ZZD",.T.)
ZZD->ZZD_FILIAL := XFILIAL("ZZD")
ZZD->ZZD_DOC    := SF2->F2_DOC
ZZD->ZZD_SERIE  := SF2->F2_SERIE
ZZD->ZZD_CLIENT := SF2->F2_CLIENTE
ZZD->ZZD_LOJA   := SF2->F2_LOJA
ZZD->ZZD_EMIS   := SF2->F2_EMISSAO
ZZD->ZZD_DATA   := dDataBase
//ZZD->ZZD_USUARI := Substr(cUsuario,7,15)
ZZD->ZZD_USUARI := cUsername  // Alterado para nova versao P10
ZZD->ZZD_PEDIDO := SD2->D2_PEDIDO
ZZD->ZZD_MOTIVO := mv_par01
ZZD->ZZD_SEQ    := Iif(nLogNf=0,1,nLogNf)
ZZD->(MSUnlock())

SD2->(DbSetOrder(1))
RestArea(aArea)

Dbselectarea("SZN")
SZN->(dbSetOrder(2))

If SZN->(dbSeek(xFilial("SZN" ) + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE)))
	While SZN->(!eof()) .and. SZN->ZN_FILIAL == xFilial("SZN") .and. SZN->ZN_NFRPS == AllTrim(SF2->F2_DOC) .And. SZN->ZN_SERRPS == AllTrim(SF2->F2_SERIE)
		
		Dbselectarea("SZN")
		Begin Transaction
		RecLock("SZN",.F.)
		
		SZN->ZN_NFRPS 	:= ""
		SZN->ZN_SERRPS	:= ""
		
		MSUnlock("SZN")
		End Transaction
		
		SZN->(dbSkip())
	EndDo
EndIf

ZZQ->(dbSetOrder(4))  // ZZQ_FILIAL + ZZQ_NFS + ZZQ_NFSSER + ZZQ_PV + ZZQ_ITEMPV
ZZQ->(dbgotop())

If ZZQ->(dbSeek(xFilial("ZZQ" ) + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE)))
	While ZZQ->(!eof()) .and. ZZQ->ZZQ_FILIAL == xFilial("ZZQ") .and. ZZQ->ZZQ_NFS == AllTrim(SF2->F2_DOC) .And. ZZQ->ZZQ_NFSSER == AllTrim(SF2->F2_SERIE)
		Dbselectarea("ZZQ")
		Begin Transaction
		RecLock("ZZQ",.F.)
		
		ZZQ->ZZQ_NFS 	:= ""
		ZZQ->ZZQ_NFSSER	:= ""
		
		MSUnlock("ZZQ")
		End Transaction
		
		ZZQ->(dbSkip())
	Enddo
Endif

Return .t.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  14/085/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
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
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Motivo Cancelamento NF : ","","","mv_ch1","C",04,0,0,"G","","ZL" ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o motivo do cancelamento.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerMCLAIM บAutor  ณ Marcelo Munhoz     บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para verificar existencia de IMEI com MCLAIM gerado.บฑฑ
ฑฑบ          ณ O responsavel MCLAIM deve tratar a situacao de reenvio do  บฑฑ
ฑฑบ          ณ MCLAIM de um IMEI por causa da exclusao da Nota Fiscal     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VerMCLAIM()

local _aAreaZZ4 := ZZ4->(getarea())
local _aAreaSD2 := SD2->(getarea())
local _aMCLAIM  := {}
local _Enter    := chr(13) + chr(10)

ZZ4->(dbSetOrder(5)) // ZZ4_FILIAL + ZZ4_NFSNR + ZZ4_NFSSER + ZZ4_IMEI
SD2->(dbSetOrder(3)) //  D2_FILIAL +  D2_DOC   +  D2_SERIE  +  D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM

if SD2->(dbseek(xFilial("SD2") + SF2->F2_DOC   + SF2->F2_SERIE  + SF2->F2_CLIENTE + SF2->F2_LOJA)) .and.;
	!empty(SD2->D2_NUMSERI)
	
	while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE .and.;
		SD2->D2_CLIENTE == SF2->F2_CLIENTE .and. SD2->D2_LOJA == SF2->F2_LOJA
		
		if ZZ4->(dbSeek(xFilial("ZZ4") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_NUMSERI)) .and. !empty(ZZ4->ZZ4_MCLGER)
			aAdd(_aMCLAIM, {alltrim(ZZ4->ZZ4_IMEI), alltrim(ZZ4->ZZ4_OS), left(ZZ4->ZZ4_MCLGER,8), alltrim(substr(ZZ4->ZZ4_MCLGER,9,42))})
		endif
		
		SD2->(dbSkip())
		
	enddo
	
endif

if len(_aMCLAIM) > 0
	apMsgStop("A Nota Fiscal excluํda cont้m IMEIs que jแ foram enviados para o MCLAIM, podendo gerar Cobran็a em duplicidade caso ocorra um novo faturamento. Favor contatar o responsแvel pelo MCLAIM para apurar esta situa็ใo." , "Exclusใo de IMEI com MCLAIM")
	cTitulo   := "NF excluํda com MCLAIM - nr " + SF2->F2_DOC + " / s้rie " + SF2->F2_SERIE
	cDestina  := GetMV("MV_XMCLEMA")
	cCco      := ""
	cMensagem := "Caro usuแrio, foi excluํda a NF " + SF2->F2_DOC + " / s้rie " + SF2->F2_SERIE + " que continha IMEIs jแ enviados para o MCLAIM, conforme listagem abaixo. Favor verificar com urg๊ncia." + _Enter + _Enter
	cMensagem := CriaMsg(_aMCLAIM, cMensagem)
	Path      := ""
	u_EnviaEmail(cTitulo,cDestina,cCco,cMensagem,Path)
endif

restarea(_aAreaZZ4)
restarea(_aAreaSD2)

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2520E   บAutor  ณMicrosiga           บ Data ณ  06/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CriaMsg(_aMCLAIM, _cMensagem)

local _cTexto := ""
local _Enter  := chr(13)+chr(10)

_cTexto += _Enter + "<html> "
_cTexto += _Enter + "<meta http-equiv=Content-Type content='text/html; charset=windows-1252'> "
_cTexto += _Enter + "<body> "
_cTexto += _Enter + "<table cellspacing=0 cellpadding=0  border='1'> "

_cTexto += _Enter + "<tr height=21  bgcolor='lightblue'>"
_cTexto += _Enter + "<td font face='Arial' size='20'><b> IMEI</td>"
_cTexto += _Enter + "<td font face='Arial' size='10'><b> OS</td>"
_cTexto += _Enter + "<td font face='Arial' size='10'><b> Data MCLAIM</td>"
_cTexto += _Enter + "<td font face='Arial' size='40'><b> Arquivo MCLAIM</td>"
_cTexto += _Enter + "</tr>"

for x := 1 to len(_aMCLAIM)
	
	_cIMEI := _aMCLAIM[x,1]
	_cOS   := _aMCLAIM[x,2]
	_cData := _aMCLAIM[x,3]
	_cArq  := _aMCLAIM[x,4]
	
	_cTexto += _Enter + "<tr height=21   bgcolor='white'>"
	/*
	_cTexto += _Enter + "<td font face='Arial' size='20'>"+_cIMEI+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_cOS+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_cData+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='40'>"+_cArq+"</td>"
	*/
	
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_aMCLAIM[x,1]+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_aMCLAIM[x,2]+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_aMCLAIM[x,3]+"</td>"
	_cTexto += _Enter + "<td font face='Arial' size='10'>"+_aMCLAIM[x,4]+"</td>"
	
	_cTexto += _Enter + "</tr>"
	
next x

_cTexto += _Enter + "</table>"
_cTexto += _Enter + "</body>"
_cTexto += _Enter + "</html>"

_cTexto := strtran(_cTexto,_Enter,"")
_cMensagem += _cTexto

return(_cMensagem)
