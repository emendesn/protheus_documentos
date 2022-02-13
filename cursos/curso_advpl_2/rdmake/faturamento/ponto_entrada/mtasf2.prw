#include "RWMAKE.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTASF2   ºAutor  ³ Luciano siqueira   º Data ³  15/04/14      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desenvolver ponto de entrada para digitação de Volume,Espécie  º±±
±±º          ³Peso Liq,Peso Bruto no momento da Geração do Documento de Saidaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTASF2()
//Declara as variaveis
Local aButtons := {}
Local aItems   := {'F=FOB','C=CIF','T=Por conta terceiros','S=Sem frete'}
Private _cNumero,_cSerie,cTitulo,_ccMens1,_ccMens2,cPesoLiq,cPesoBru,cQuanti,cEspecie,cPedido,_ccMens1,_ccMens2, cTransp, dDataFat, cPlaca

//Salva area
_cAlias  := GetArea()   
_cNumero := SF2->F2_DOC
_cSerie  := SF2->F2_SERIE
_cEst    := SF2->F2_EST
cTitulo  := "Digitacao de dados para N.Fiscal"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atibui Valores as variaveis de acordo com o Pedido de Vendas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPesoLiq := SF2->F2_PLIQUI
cPesoBru := cPesoLiq
cQuanti  := SC5->C5_VOLUME1
cEspecie := SC5->C5_ESPECI1
cPedido  := SC5->C5_NUM
cTransp  := SC5->C5_TRANSP
cMsgNota := SC5->C5_MENNOTA
cTpFrete := SC5->C5_TPFRETE 

lValOpeBGH :=  IIF(ALLTRIM(UPPER(FUNNAME())) == "BGHSAIVJ",.T.,ValOpeBGH())

cEspecie := If( Empty(cEspecie), "CAIXA                ", cEspecie )
cQuanti  := If( Empty(cQuanti), 0  , cQuanti  )

_lTela := alltrim(SF2->F2_ESPECIE)=="SPED"

if _lTela .and. lValOpeBGH
	While _lTela
		lAltPesol := cPesoLiq==0
		@ 0,0 TO 300,460 DIALOG oBase TITLE cTitulo
		
		_ccMens1 := OemToAnsi("Nota Fiscal / serie  : " + _cNumero +" / "+_cSerie)
		@ 005,016 SAY _ccMens1 size 100,200
		_ccMens2 := OemToAnsi("Pedido de Venda Numero: "+cPedido)
		@ 015,016 SAY _ccMens2 size 100,200
		
		@ 030,018 SAY "Volume(s)" size 200,100
		@ 030,067 GET cQuanti PICTURE "99999"
		@ 040,018 SAY "Especie" size 200,100
		@ 040,067 GET cEspecie PICTURE "@!"    size 80,100 valid NaoVazio()
		@ 050,018 Say "Transportadora"
		@ 050,067 Get cTransp F3 "SA4" PICTURE "999999"  VALID ExistCpo("SA4",cTransp) SIZE 50,10
		@ 080,018 SAY "Peso Liquido" size 200,100
		@ 080,067 GET cPesoLiq PICTURE "@E 9,999,999,999.99" size 80,100 When lAltPesol Valid (cPesoBru := cPesoLiq,.T.)
		@ 090,018 SAY "Peso Bruto" size 200,100
		@ 090,067 GET cPesoBru PICTURE "@E 9,999,999,999.99" size 80,100
		@ 100,018 SAY "Tipo Frete" size 200,100
		oCombo1 := TComboBox():New(100,067,{|u|if(PCount()>0,cTpFrete:=u,cTpFrete)},aItems,100,20,oBase,,{||},,,,.T.,,,,,,,,,'cCombo1')
		@ 112,018 SAY "Msg.Nota" SIZE 200,100
		@ 112,067 GET cMsgNota  PICTURE "@S50!"  SIZE 150,10 
				
		@ 138,067 BMPBUTTON TYPE 1 ACTION If(VldValor(),GravaSC5(),NIL)  		
		
		ACTIVATE DIALOG oBase CENTERED
	Enddo
endif

RestArea(_cAlias)
Return()

Static Function VldValor()
Local lRet := .T.  
Local dDTval := CTOD("  /  /  ")

If(cQuanti <= 0)
	MsgStop("Por favor, preencha o valor do campo 'Qtde Volume'","Atenção")
	lRet := .F.
EndIf

If(cPesoLiq <= 0)
	MsgStop("Por favor, preencha o valor do campo 'Peso Liquido'","Atenção")
	lRet := .F.
EndIf

If(cPesoBru <= 0)
	MsgStop("Por favor, preencha o valor do campo 'Peso Bruto'","Atenção")
	lRet := .F.
EndIf      


Return lRet


Static Function GravaSC5()
If _cEst='EX' .and. cPesoBru == 0
	MsgBox ("Peso Nao Informado","Informação","INFO")
	_lTela := .T.
Else
	if _lTela
		Close(oBase)
	endif
	
	_lTela := .F.
	
	dbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_TRANSP  := cTransp
	SC5->C5_MENNOTA := cMsgNota
	SC5->C5_TPFRETE := cTpFrete 
	MsUnlock()
	
	dbSelectArea("SF2")
	
	RecLock("SF2",.F.)
	SF2->F2_VOLUME1 := cQuanti
	SF2->F2_ESPECI1 := cEspecie
	SF2->F2_PLIQUI  := cPesoLiq
	SF2->F2_PBRUTO  := cPesoBru
	SF2->F2_TRANSP  := cTransp
	SF2->F2_TPFRETE := cTpFrete 
	MsUnlock()
	
Endif

Return


Static Function ValOpeBGH()

Local aArea := GetArea()
Local lRet	:= .F.

cQuery := " SELECT "
cQuery += " 	DISTINCT ZZ4_OPEBGH "
cQuery += " FROM "+ RETSQLNAME("SC6")+" SC6 (NOLOCK) "
cQuery += " INNER JOIN "+ RETSQLNAME("ZZ4")+" ZZ4 (NOLOCK) ON "
cQuery += " 	ZZ4_FILIAL=C6_FILIAL AND "
cQuery += "		(ZZ4_IMEI=C6_XIMEOLD OR "
cQuery += "		ZZ4_IMEI=C6_NUMSERI) AND "
cQuery += "		ZZ4_STATUS < '9' AND "
cQuery += "		ZZ4.D_E_L_E_T_='' "
cQuery += " INNER JOIN "+ RETSQLNAME("ZZJ")+" ZZJ (NOLOCK) ON "
cQuery += " 	ZZJ_OPERA=ZZ4_OPEBGH AND "
cQuery += " 	ZZJ_INFVOL='S' AND "
cQuery += " 	ZZJ.D_E_L_E_T_ = '' "
cQuery += "	WHERE "
cQuery += "		C6_FILIAL='"+xFilial("SC6")+"' AND "
cQuery += "		C6_NUM = '"+SC5->C5_NUM+"' AND "
cQuery += "		SC6.D_E_L_E_T_= '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

QRY->(dbGoTop())
While QRY->(!Eof())
	lRet := .T. 
	Exit
	QRY->(dbSkip())	
EndDo 

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
EndIf		

RestArea(aArea)

Return(lRet)  