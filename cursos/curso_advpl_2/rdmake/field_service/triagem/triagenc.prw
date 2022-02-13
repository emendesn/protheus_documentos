#include 'protheus.ch'
#include 'topconn.ch'
#include "hbutton.ch"
#include "TcBrowse.ch"
#include "apwizard.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHTRIAG  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para Triagem, gera็ใo da Etq. Master e encerramento   บฑฑ
ฑฑบ          ณ dos radios na planta alphaville                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TRIAGENC()

Local aButtons    	:= {}

Private _cImei	    := space(TamSX3("ZZ4_IMEI")[1])//space(20)
Private _cCarca	    := space(20)
Private _cMaster    := space(20)
Private _nQtdMas    := 0
Private aColsM1	    := {}
Private aHeadM1 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados
Private aPosObj    	:= {}
Private aObjects   	:= {}
Private oGetDadM1   := Nil
Private oDlg		:= Nil
Private oSayMaster  := Nil
Private aSize      	:= MsAdvSize(.T.)
Private nFreeze 	:= 2
Private cPerg   	:= PADR("TRIAGENC",10)
Private cSA1Chave	:= ""
Private cSB1Chave   := ""        
Private _cmudfdes  := GETMV("MV_MUDFDES")
Private _cmudfori  := GETMV("MV_MUDFORI")


oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito
oFont1  := tFont():New('Tahoma',,-28,.t.,.t.) // 5o. Parโmetro negrito
oFont2  := tFont():New('Tahoma',,-18,.t.,.t.) // 5o. Parโmetro negrito

VALIDPERG()
If !Pergunte(cPerg,.T.)
	Return
EndIf
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Alimenta o aheader 	|
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MsAguarde({|| ADDAHEAD() })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem da Tela                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg TITLE "Triagem Nextel" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Getdados para Forecast |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}

aAdd( aObjects, {100,100, .T., .T.})
aAdd( aObjects, {100,100, .T., .T.})

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLabel de Informa็๕es adicionais ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[1,3],aPosObj[1,4]-5 LABEL "" OF oDlg PIXEL


oSayIme := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"IMEI"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetIme := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
oGetIme:bValid 		:= {|| ValidZZ4()}

@aPosObj[1,1],aPosObj[1,2]+355 To aPosObj[1,3],aPosObj[1,4]-5 LABEL "" OF oDlg PIXEL

DEFINE FONT oFont NAME "FW Microsiga" SIZE 0, -9

oSayMaster := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+360,{||"QTD MASTER - "+Strzero(_nQtdMas,3)},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oSayMaster := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+360,{||_cMaster},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)

oGetDadM1 := MsNewGetDados():New(aPosObj[2,1]+15,aPosObj[2,2]+11,aPosObj[2,3]-10,aPosObj[2,4]-10,GD_UPDATE,"AllwaysTrue","AllwaysTrue","",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
oGetDadM1:oBrowse:bChange := {||  IIF(Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2]),ADDACOLS(1),(oGetDadM1:nat))}


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| Processa({|| IIF( QtdOk(_nQtdMas) .And. MSGYESNO("Finalizar Etiqueta Master?"),GravaZZO(),)},"Processando..."), oDlg:End()},{||oDlg:End()},,aButtons)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADDAHEAD  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDAHEAD()

Local cField := "ZZO_IMEI/ZZO_CARCAC/ZZO_STATUS/ZZO_MODELO/ZZO_GARANT/ZZO_BOUNCE/ZZO_NVEZ/"
cField += "ZZO_OPBOUN/ZZO_RECLIC/ZZO_DTSEPA/ZZO_HRSEPA/ZZO_REFGAR/ZZO_DESTIN/ZZO_DTDEST/"
cField += "ZZO_HRDEST/ZZO_USRDES/ZZO_NUMCX/ZZO_DTCOFE/ZZO_HRCOFE/ZZO_USRCOF/ZZO_DBOUNC/"
cField += "ZZO_ENVARQ/ZZO_SEGREG/ZZO_SYMPTO/ZZO_ACTION/ZZO_OPERA/ZZO_OSFILI/ZZO_CLIENF/"
cField += "ZZO_LOJCLF/ZZO_NFENRF/ZZO_NFESEF/ZZO_ITEMDF/ZZO_MASENF/ZZO_ARMZEF/ZZO_RCZZ3F"

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("ZZO")

aAdd(aHeadM1,{" ","LEGENDA","@BMP",2,0,,,"C",,"V"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Header para o primeiro get da tela |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !SX3->(EOF()) .And. SX3->X3_Arquivo == "ZZO"
	
	If Trim(SX3->X3_Campo) $ cField
		AAdd(aHeadM1, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
		
	EndIf
	
	SX3->(dbSkip())
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADDACOLS  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDACOLS(nOpcao)

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := ZZO->(dbStruct())
Local cUsrDes	 := Alltrim(cUserName)+Space(30-Len(Alltrim(cUserName)))

If nOpcao == 1

	If MV_PAR01 == 1//Tratamento para SCRAP - 17/05/13
		cChave     := xFilial("ZZO")+"X"+cUsrDes
	Else	
		cChave     := xFilial("ZZO")+"P"+cUsrDes
	EndIf		
		
	dbSelectArea("ZZO")
	dbSetOrder(7)
	If MsSeek(cChave)
		_cMaster := ZZO->ZZO_NUMCX       
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlterado - Uiran Almeida - 17.02.2014 - GLPI - (17 445) ณ
		//ณAjuste da Chave para carrega-la no momento em que entra ณ
		//ณnovamente na rotina, e carrega o aCols.                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cSA1Chave := ZZO->ZZO_CLIENF+ZZO->ZZO_LOJCLF
		cSB1Chave := ZZO->ZZO_MODELO //Valida o Modelo do Aparelho		
		
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_STATUS+ZZO_USRDES)
			If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
				AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
			Endif
			nColuna := Len(oGetDadM1:aCols)
			oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
			_nQtdMas++
			For nM := 1 To Len(aCampos)
				cCpoZO := "ZZO->" + aCampos[nM][1]
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPreenche o acols ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
				If nPos > 0
					oGetDadM1:aCols[nColuna][nPos] := &cCpoZO
				EndIf
			Next nM
			oGetDadM1:aCols[nColuna][nQtdM1+1] := .F.
			ZZO->(dbSkip())
		EndDo
	EndIf
Else
	
	If MV_PAR01 == 1//SCRAP
		cChave     := xFilial("ZZO")+_cImei+_cCarca+"X" 
	Else	
		cChave     := xFilial("ZZO")+_cImei+_cCarca+"P"
	EndIf		
	
	dbSelectArea("ZZO")
	dbSetOrder(1)
	If MsSeek(cChave)
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_IMEI+ZZO_CARCAC+ZZO_STATUS)
			If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
				AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
			Endif
			nColuna := Len(oGetDadM1:aCols)
			oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
			_nQtdMas++
			For nM := 1 To Len(aCampos)
				cCpoZO := "ZZO->" + aCampos[nM][1]
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPreenche o acols ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
				If nPos > 0
					oGetDadM1:aCols[nColuna][nPos] := &cCpoZO
				EndIf
			Next nM
			oGetDadM1:aCols[nColuna][nQtdM1+1] := .F.
			ZZO->(dbSkip())
		EndDo
	EndIf
Endif

oGetDadM1:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidZZ4  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidZZ4()

Local _lRet := .T.

If Empty(_cImei)
	_lRet := .F.
ElseIf _nQtdMas == 200
	MsgAlert("Atingiu a quantidade de IMEIS na Master. Favor finalizar!")
	_lRet := .F.
ElseIf Len(AllTrim(_cImei)) <> 15
	MsgAlert("Equipamento com Erro no Imei, Favor Inserir Novamente!")
	_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)                 
	_lRet := .F.
ElseIf !empty(_cImei) .and. _lRet
 
	If MV_PAR01 == 1 //Tratamento para scrap 
			
		cQuery := " SELECT ZZ4_IMEI,  "
		cQuery += " 	   ZZ4_OS, "
		cQuery += " 	   ZZ4_SETATU, "
		cQuery += " 	   ZZ4_FASATU "
		cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4 "
		cQuery += " INNER JOIN "+RetSqlName("ZZ3")+" ZZ3 ON (ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND   "
		cQuery += " 						ZZ3_IMEI = ZZ4_IMEI AND "
		cQuery += " 						ZZ3_NUMOS = ZZ4_OS AND 	"
		cQuery += " 						ZZ3.D_E_L_E_T_<> '*' AND   "
		cQuery += " 						ZZ3_ENCOS = 'S' AND "
		cQuery += " 						ZZ3_ESTORN = '')	"					
		cQuery += " INNER JOIN "+RetSqlName("ZZ1")+" ZZ1 ON (ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND " 
		cQuery += " 						ZZ1_CODSET = ZZ4_SETATU AND  "
		cQuery += " 						ZZ1_FASE1 = ZZ4_FASATU AND	"					
		cQuery += " 						ZZ1_SCRAP = 'S' AND  "
		cQuery += " 						ZZ1.D_E_L_E_T_<> '*' AND "
		cQuery += " 						ZZ1_LAB = ZZ3_LAB)	"		
		cQuery += " WHERE ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
		cQuery += " AND ZZ4_STATUS IN ('5','4') "
		cQuery += " AND ZZ4_OPEBGH IN ('N01','N10','N08') "
		cQuery += " AND ZZ4.D_E_L_E_T_ <> '*' "
		cQuery += " AND ZZ4_IMEI = '"+_cImei+"' "               
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TFIL",.F.,.T.)
		
		dbSelectArea("TFIL")
		TFIL->(dbGotop())
		
		If Eof()
			MsgAlert("Equipamento nใo encontrado na fase de SCRAP.")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.					 
		Else
			dbSelectArea("ZZ4")
			dbSetOrder(4)
			If !dbSeek(xFilial("ZZ4")+_cImei)                          
				MsgAlert("Equipamento nใo localizado. Favor verificar!")
				_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
			EndIf								
		EndIf
		
		TFIL->(dbCloseArea())

	
	Else
		
		dbSelectArea("ZZ4")
		dbSetOrder(4)
		If !dbSeek(xFilial("ZZ4")+_cImei+"3")
			dbSelectArea("ZZ4")
			dbSetOrder(4)
			If !dbSeek(xFilial("ZZ4")+_cImei+"4")
				MsgAlert("Equipamento nใo localizado. Favor verificar!")
				_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
			Endif
		Endif

	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida se o IMEI sใo de clientes diferentesณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _lRet
		If Empty(cSA1Chave)
			cSA1Chave := ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
		EndIf
		
		If Empty(cSB1Chave)
			cSB1Chave := ZZ4->ZZ4_CODPRO //Valida o Modelo do Aparelho		
		EndIf
		
		If cSA1Chave <> ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
			MsgAlert("Cliente diferente do primeiro apontamento, por favor verificar!")		
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		EndIf
		If _lRet .And. cSB1Chave <> ZZ4->ZZ4_CODPRO
			MsgAlert("C๓digo de Produto diferente do primeiro apontamento, por favor verificar!")		
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		EndIf
	EndIf
			
	If _lRet
	
	
		_cCarca		    := ZZ4->ZZ4_CARCAC
		_nDBounce		:= Alltrim(Str(ZZ4->ZZ4_BOUNCE))
		_lGrvZZO 		:= .T.
		
		_cQuery := " SELECT ZZO_IMEI "
		_cQuery += " FROM "+RETSQLNAME("ZZO")+" ZZO "
		_cQuery += " WHERE "
		_cQuery += " 	ZZO_IMEI  = '"+ZZ4->ZZ4_IMEI+"' AND "
		_cQuery += " 	ZZO_CARCAC  = '"+ZZ4->ZZ4_CARCAC+"' AND "
		
		If MV_PAR01 == 1//Tratamento para SCRAP.
			_cQuery += "    ZZO_STATUS IN ('X','S') AND "
		Else
			_cQuery += "    ZZO_STATUS = 'P' AND "
		EndIf			
		
		_cQuery += "    ZZO.D_E_L_E_T_ = '' "
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)
		
		dbSelectArea("TSQL1")
		dbGotop()
		If TSQL1->(!Eof())
			_lGrvZZO := .F.
		Endif
		
		If Select("TSQL1") > 0
			dbSelectArea("TSQL1")
			DbCloseArea()
		EndIf
		
		If _lGrvZZO
			If Empty(_cMaster)
				_cMaster := GetSXENum("ZZO","ZZO_NUMCX")
				_nContMax := 1
				While _nContMax == 1
					dbSelectArea("ZZO")
					dbSetOrder(4)
					If dbSeek(xFilial("ZZO")+_cMaster)
						_cMaster := GetSXENum("ZZO","ZZO_NUMCX")
					Else
						_nContMax := 0
					Endif
				EndDo
				ConfirmSX8()
			Endif
			    
			nRecZZ3 := 0
			
			If MV_PAR01 == 2 		
				_cQuery := " SELECT MAX(ZZ3.R_E_C_N_O_) AS RECZZ3 "
				_cQuery += " FROM "+RETSQLNAME("ZZ3")+" ZZ3 "
				_cQuery += " WHERE "
				_cQuery += " 	ZZ3_FILIAL  = '"+xFilial("ZZ3")+"' AND "
				_cQuery += " 	ZZ3_IMEI  = '"+ZZ4->ZZ4_IMEI+"' AND "
				_cQuery += " 	ZZ3_NUMOS  = '"+ZZ4->ZZ4_OS+"' AND "
				_cQuery += "    ZZ3.D_E_L_E_T_ = '' "
				
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)
				
				dbSelectArea("TSQL1")
				dbGotop()
				If TSQL1->RECZZ3 > 0
					nRecZZ3 := TSQL1->RECZZ3
				Endif
				
				If Select("TSQL1") > 0
					dbSelectArea("TSQL1")
					DbCloseArea()
				EndIf
				
			EndIf				
						
			_cRefGar := ""
			If ALLTRIM(ZZ4->ZZ4_OPEBGH)$"N01" .AND. (ZZ4->ZZ4_BOUNCE <= 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
				_cRefGar := "2"
			ElseIf ALLTRIM(ZZ4->ZZ4_OPEBGH)$"N10/N11" .AND. (ZZ4->ZZ4_BOUNCE <= 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
				_cRefGar := "1"
			ElseIf ZZ4->ZZ4_BOUNCE > 0 .AND. ZZ4->ZZ4_BOUNCE < 90
				_cRefGar := "4"
			Else
				_cRefGar := "3"
			Endif
			
			Begin Transaction
			
			RecLock("ZZO",.T.)
			ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
			ZZO->ZZO_IMEI		:= _cImei
			ZZO->ZZO_CARCAC		:= _cCarca
			ZZO->ZZO_MODELO		:= ZZ4->ZZ4_CODPRO
			ZZO->ZZO_GARANT  	:= ZZ4->ZZ4_GARANT
			ZZO->ZZO_BOUNCE		:= IIF(ZZ4->ZZ4_BOUNCE > 0 .AND. ZZ4->ZZ4_BOUNCE <= 90,"S","N")
			ZZO->ZZO_NVEZ		:= ZZ4->ZZ4_NUMVEZ
			ZZO->ZZO_OPBOUN		:= IIF(ZZ4->ZZ4_BOUNCE > 0 ,"S","")
			ZZO->ZZO_RECLIC		:= ZZ4->ZZ4_DEFINF
			ZZO->ZZO_DTSEPA		:= dDataBase
			ZZO->ZZO_HRSEPA		:= Time()
			ZZO->ZZO_STATUS		:= IIF(MV_PAR01==1,'X','P') //Tratamento SCRAP
			ZZO->ZZO_REFGAR		:= _cRefGar
			ZZO->ZZO_DESTIN		:= "B"
			ZZO->ZZO_DTDEST		:= dDataBase
			ZZO->ZZO_HRDEST		:= Time()
			ZZO->ZZO_USRDES		:= cUserName
			ZZO->ZZO_NUMCX		:= _cMaster
			ZZO->ZZO_DTCOFE		:= dDataBase
			ZZO->ZZO_HRCOFE		:= Time()
			ZZO->ZZO_USRCOF		:= cUserName
			ZZO->ZZO_DBOUNC		:= Iif(Len(_nDBounce) >0, Transform(_nDBounce, "@E 999"),000)
			ZZO->ZZO_ENVARQ		:= "N"
			ZZO->ZZO_SEGREG		:= "N"
			ZZO->ZZO_SYMPTO		:= IIF(!EMPTY(ZZ4->ZZ4_DEFDET),ZZ4->ZZ4_DEFDET,ZZ4->ZZ4_PROBLE)
			ZZO->ZZO_ACTION 	:= ZZ4->ZZ4_REPAIR
			ZZO->ZZO_ORIGEM		:= Posicione("SA1",1,xFilial("SA1")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA,"A1_EST")
			ZZO->ZZO_PRECO		:= ZZ4->ZZ4_VLRUNI
			ZZO->ZZO_OPERA		:= ZZ4->ZZ4_OPEBGH
			ZZO->ZZO_OSFILI		:= ZZ4->ZZ4_OS
			ZZO->ZZO_CLIENF		:= ZZ4->ZZ4_CODCLI
			ZZO->ZZO_LOJCLF		:= ZZ4->ZZ4_LOJA
			ZZO->ZZO_NFENRF		:= ZZ4->ZZ4_NFENR
			ZZO->ZZO_NFESEF		:= ZZ4->ZZ4_NFESER
			ZZO->ZZO_ITEMDF		:= ZZ4->ZZ4_ITEMD1
			ZZO->ZZO_MASENF		:= ZZ4->ZZ4_ETQMEM
			ZZO->ZZO_ARMZEF		:= ZZ4->ZZ4_LOCAL
			ZZO->ZZO_RCZZ3F		:= nRecZZ3
			MsUnlock()
			
			End Transaction
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//|Alimenta o acols e cria TM    |
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			MsAguarde({|| ADDACOLS(2) })
		Else
			MsgAlert("Triagem do IMEI "+Alltrim(_cImei)+" efetuada anteriormente.")
		Endif
	Endif
	
Endif

_cImei	    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
_cCarca		    := space(25)
_lRet			:= .T.
oGetIme:SetFocus()

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVAZZO  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Confirma็ใo para gravacao dos IMEI's na tabela ZZO         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GRAVAZZO()

Local aArea     := GetArea()
Local oDlgx
Local nOpc  	:= 0
Local lRetMas 	:= .F.

Private cTecnico	:= space(6)
Private LAB			:= "2"//space(1)
Private FASE1		:= "01"//space(2)
Private XCODSET		:= "000098"//space(6)

If MV_PAR01 == 2

	DEFINE MSDIALOG oDlgx TITLE "Dados para encerrar Etq. Master" FROM 0,0 TO 200,500 PIXEL
	
	
	@ 06, 006 SAY "Tecnico.:" SIZE 70,7 PIXEL OF oDlgx
	@ 05, 050 MSGET cTecnico When .T. F3 "AA1" valid ExistCPO("AA1") SIZE 30,7 PIXEL OF oDlgx
	
	@ 26, 006 SAY "Lab.:"   SIZE 70,7 PIXEL OF oDlgx
	@ 25, 050 MSGET LAB  When .F. F3 "LB" Valid !EMPTY(LAB) SIZE 30,7 PIXEL OF oDlgx
	
	@ 46, 006 SAY "Setor.:" SIZE 70,7 PIXEL OF oDlgx
	@ 45, 050 MSGET XCODSET When .F. F3 "ZZ2_4" Valid !EMPTY(XCODSET) SIZE 30,7 PIXEL OF oDlgx
	
	@ 66, 006 SAY "Fase.:" SIZE 70,7 PIXEL OF oDlgx
	@ 65, 050 MSGET FASE1 When .F. F3 "ZZ1_4" Valid !EMPTY(FASE1) SIZE 30,7 PIXEL OF oDlgx
	
	ACTIVATE MSDIALOG oDlgx ON INIT EnchoiceBar(oDlgx,{||nOpc:=1,oDlgx:End()},{||oDlgx:End()})
	
	If nOpc == 1
		lRetMas := u_TECAX033(cTecnico,FASE1,XCODSET,LAB,_cMaster,"03","N")//TECNICO, FASE, SETOR, LABORATORIO, CODIGO ORIGEM, EXECUTA SAIDA MASSIVA
		If lRetMas
			dbSelectArea("ZZO")
			ZZO->(dbSetOrder(4))
			
			//Altera filial ap๓s encerrar Master na filial 06
			_cUpdate := " UPDATE " + RetSqlName("ZZO")
			_cUpdate += " SET    ZZO_FILIAL = '"+alltrim(_cmudfdes)+"' "
			_cUpdate += " WHERE  ZZO_FILIAL = '"+xFilial('ZZO')+"' AND "
			_cUpdate += "        ZZO_NUMCX  = '"+_cMaster+"' AND "
			_cUpdate += "        ZZO_STATUS = 'P' AND "
			_cUpdate += "        ZZO_USRDES = '"+cUserName+"' AND "
			_cUpdate += "        D_E_L_E_T_ = '' "
			
			tcSqlExec(_cUpdate)
			TCRefresh(RetSqlName("ZZO"))
			
			U_BHETMA01(_cMaster)
			
			MsgAlert("Master "+_cMaster+" encerrada com sucesso!")
			
		Else
			MsgAlert("Master nใo encerrada. Favor verificar!")
			
		Endif
		
	Else
		MsgAlert("Master nใo encerrada. Favor verificar!")
	Endif

Else //Scrap
	
	//Grava ZZ4
	dbSelectArea("ZZO")
	dbSetOrder(4)
	
	If MsSeek(xFilial("ZZO")+_cMaster)
	
		While ZZO->(!Eof()) .And. ZZO->(ZZO_FILIAL+ZZO_NUMCX) == xFilial("ZZO")+_cMaster
		                                 	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza status scrap na tabela ZZO ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ZZO->(RecLock("ZZO",.F.))
			ZZO->ZZO_STATUS := "S"
			ZZO->(MsUnlock())

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGrava etiqueta Master 			   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			dbSelectArea("ZZ4")
			dbSetOrder(4)               
			If dbSeek(xFilial("ZZ4")+ZZO->ZZO_IMEI+"5")
				ZZ4->(RecLock("ZZ4",.F.))
				ZZ4->ZZ4_ETQMAS	:= Val(ZZO->ZZO_NUMCX)
				ZZ4->(MsUnlock())
			EndIf
		
			ZZO->(dbSkip())
		EndDo                   
		
		//Imprime etiqueta		
		U_BHETMA01(_cMaster)
		
	EndIf

EndIf

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBHETQMAS  บ Autor ณLuciano Siqueira    บ Data ณ  12/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณIMPRIME ETIQUETA MASTER DA TRIAGEM EFETUADA NA BGH          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function BHETMA01(cMaster)

Local cPorta	:= "LPT1"
Local _cMaster	:= IIF(cMaster <> Nil,cMaster,"")
Local cEst 		:= ""
Private cPerg	:= "BGHETQMA"   

If empty(_cMaster)
	If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		Return()
	Endif
	_cMaster	:= MV_PAR01
Endif

If !IsPrinter(cPorta)
	MsgAlert("Impressora nใo localizada")
	Return
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

//Busca estado do cliente para impressใo da etiqueta
//Solicita็ใo do Alessandro - 20/05/13
cQry := " SELECT DISTINCT A1_EST "
cQry += " FROM "+RetSqlName("ZZ4")+" ZZ4 "
cQry += " LEFT JOIN "+RetSqlName("SA1")+" SA1  "
cQry += " 				ON (ZZ4_CODCLI+ZZ4_LOJA = A1_COD+A1_LOJA "
cQry += " 				AND SA1.D_E_L_E_T_ <> '*' ) "
cQry += " WHERE ZZ4_ETQMAS = '"+_cMaster+"' "  
cQry += " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
cQry += " AND ZZ4.D_E_L_E_T_ <> '*'  "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

dbSelectArea("QRY")
QRY->(dbGotop())

If QRY->(!Eof())
	cEst := QRY->A1_EST
EndIf

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

//Busca quantidade de etiquetas na ZZO 
cQry := " SELECT COUNT(*) AS QTDREG, MAX(ZZO_STATUS) AS Z4STATUS  "
cQry += " FROM "+RETSQLNAME("ZZO")+" ZZO "
cQry += " WHERE ZZO_NUMCX  = '"+_cMaster+"' AND "
cQry += " ZZO_STATUS IN('P','S') AND "
cQry += " ZZO.D_E_L_E_T_ = '' "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Grava dados no Array                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("QRY")
dbGoTop()

If QRY->QTDREG == 0
	apMsgStop("Etiqueta Master nใo Encontrada!")
	Return
Else

	If Alltrim(QRY->Z4STATUS) == "S" //Modelo especifico para scrap
	      
		/*MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Primeira Linha                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MSCBBOX(004,0.5,038,06,4)
		MSCBSAY(006,002,"BGH","N","0","035,045",.T.)
		MSCBBOX(038,0.5,087,06,4)
		MSCBSAY(040,002,"Data: " + DTOC(dDataBase) ,"N","0","035,045",.T.)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Segunda Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MSCBBOX(004,06,038,12,4)
		MSCBSAY(006,008,"Dest: "+"SCRAP "+cEst,"N","0","035,045",.T.)
		MSCBBOX(038,06,062,12,4)
		MSCBSAY(040,008,"Qtd: " + STRZERO(QRY->QTDREG,3),"N","0","035,045",.T.)
		MSCBBOX(062,06,087,12,4)
		MSCBSAY(063,008,"Oper: " + "N01/N10","N","0","035,045",.T.)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Terceira Linha Etiqueta Master                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Len(Alltrim(_cMaster)) == 20
			_cMaster := Substr(_cMaster,9,12)
		EndIf
					
		//MSCBSAYBAR(008,13,Alltrim(_cMaster),"N","MB07",2,.F.,.T.,.T.,,,)
		MSCBSAYBAR(011,15,Alltrim(_cMaster),"N","MB07",4,.F.,.T.,.T.,,3,2)

		MSCBEND()

		MSCBCLOSEPRINTER()*/
		
		MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Primeira Linha                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MSCBBOX(002,007,075,017,4)
		MSCBSAY(019,009,"BGH","N","0","065,075",.T.)
		MSCBBOX(075,007,170,017,4)
		MSCBSAY(076,009,"Data: " + DTOC(dDataBase) ,"N","0","065,075",.T.)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Segunda Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MSCBBOX(002,017,075,027,4)
		MSCBSAY(008,018,"Local Dest: "+"SCRAP "+cEst,"N","0","065,075",.T.)
		MSCBBOX(075,017,100,027,4)
		MSCBSAY(076,018,"Qtd: " + STRZERO(QRY->QTDREG,3),"N","0","065,075",.T.)
		MSCBBOX(100,017,170,027,4)
		MSCBSAY(101,018,"Oper.: " + "N01/N10/N08","N","0","065,075",.T.)
        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Terceira Linha Etiqueta Master                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Len(Alltrim(_cMaster)) == 20
			_cMaster := Substr(_cMaster,9,12)
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Terceira Linha Etiqueta Master                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MSCBSAYBAR	(025,35,Alltrim(_cMaster),"N","MB07",6,.F.,.T.,.T.,,8,2)

		MSCBEND()

		MSCBCLOSEPRINTER()

	Else
		
		MSCBPRINTER("Z90XI","LPT1",,144,.F.,,,,,,.T.)
		
		MSCBCHKSTATUS(.F.)
		
		MSCBBEGIN(1,6)
		
		//       c   l   c   l
		MSCBBOX(004,007,096,120,4)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Primeira Linha                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,007,030,030,4)
		MSCBSAY(010,020,"BGH","N","0","065,075",.T.)
		//       c   l   c   l
		MSCBBOX(030,007,096,030,4)
		MSCBSAYBAR(035,012,Alltrim(_cMaster),"N","MB07",08,.F.,.F.,.F.,,2,1)
		MSCBSAY(038,022,Alltrim(_cMaster),"N","0","035,045",.T.)
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Segunda Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,030,055,048,4)
		MSCBSAY(006,032,"DATA ENTRADA: ","N","0","035,045",.T.)
		MSCBSAY(008,040,DTOC(dDataBase),"N","0","085,095",.T.)
		//       c   l   c   l
		MSCBBOX(055,030,096,048,4)
		MSCBSAY(057,032,"QUANTIDADE: ","N","0","035,045",.T.)
		MSCBSAY(061,040,STRZERO(QRY->QTDREG,3),"N","0","085,095",.T.)
		
		//       c   l   c   l
		MSCBBOX(004,066,055,084,4)
		MSCBSAY(006,068,"MODELO: ","N","0","035,045",.T.)
		MSCBSAY(008,075,"","N","0","065,075",.T.)
		//       c   l   c   l
		MSCBBOX(055,066,096,084,4)
		MSCBSAY(057,068,"ARMAZEM: ","N","0","035,045",.T.)
		MSCBSAY(061,075,"","N","0","065,075",.T.)
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Quinta Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,084,096,102,4)
		MSCBSAY(006,086,"OPERACAO: ","N","0","035,045",.T.)
		MSCBSAY(008,093,"","N","0","085,095",.T.)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Sexta Linha                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//       c   l   c   l
		MSCBBOX(004,102,096,120,4)
		MSCBSAY(006,104,"NRO MASTER: ","N","0","035,045",.T.)
		MSCBSAY(008,110,Alltrim(_cMaster),"N","0","085,095",.T.)
		
		MSCBEND()
		
		MSCBCLOSEPRINTER()			
						
	EndIf	
	
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG  บAutor  ณDelta Decisao      บ Data ณ  21/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG()

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
cPerg        := PADR(cPerg,len(sx1->x1_grupo))

aHelpPor :={}
AAdd(aHelpPor,"Scarp Nextel /  Mudancao Osasco ")
PutSx1(cPerg,"01","Tipo Pedido ?","Tipo Pedido ?","Tipo Pedido ?","mv_ch1","N",01,0,0,"C","","","","","MV_PAR01","Scrap Nextel","","","","Mudan็a Osasco","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQtdOk     บAutor  ณUiran Almeida       บ Data ณ  30/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica de a quantidade da master e valida para o encerra-บฑฑ
ฑฑบ          ณmento de acordo com definido                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERACAO DE MASTER SCRAP                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
Static Function QtdOk(nQtd)   

Local lRet := .F.
Local nQtdMin := GETMV("BH_QTDMSC")
Local cCrLf    := Chr(13)+Chr(10)
Local cMensagem := "A Quantidade Minima para imprssao ้ de: [ "+Alltrim(Transform(nQtdMin,"@E 999"))+"]  , " + cCrLf 
	  cMensagem += "Para fazer a impressao com: [ "+Alltrim(Transform(nQtd,"@E 999"))+" ], ้ necessแrio libera็ใo do supervisor !" 	               

	If(nQtd < nQtdMin)
	   	lRet := u_GerA0001("Nextellider",cMensagem, .F.) 
	Else 
		lRet := .T.
	EndIf
	
Return lRet

