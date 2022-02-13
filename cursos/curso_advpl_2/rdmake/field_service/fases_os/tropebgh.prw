#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include "hbutton.ch"
#include "TcBrowse.ch"
#include "apwizard.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TROPEBGH  ºAutor  ³Luciano Siqueira    º Data ³  03/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar transferencia de operação qdo o aparelho for       º±±
±±º          ³ reprovado pela estetica na triagem                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TROPEBGH()

Local aButtons    	:= {}

Private _cImei    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
Private _nQtdSep   	:= 0

Private aColsM1	    := {}
Private aHeadM1 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados
Private aPosObj    	:= {}
Private aObjects   	:= {}


Private oGetDadM1   := Nil
Private oDlg		:= Nil

Private aSize      	:= MsAdvSize(.T.)
Private nFreeze 	:= 2

Private _lUsrAut 	:= .F.
Private _aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))

u_GerA0003(ProcName())

oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parâmetro negrito


For i := 1 to Len(_aGrupos)
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(_aGrupos[i])) $ "Administradores#Transf_OPEBGH"
		_lUsrAut  := .T.
	EndIf
Next i

If !_lUsrAut
	MsgInfo("Usuario sem acesso para efetuar transferencia de operação. Favor entrar em contato com o administrador do sistema.","Transferencia")
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Alimenta o aheader 	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsAguarde({|| ADDAHEAD() })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da Tela                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Transfere Operação" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Getdados para Forecast |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}

aAdd( aObjects, {100,100, .T., .T.})
aAdd( aObjects, {100,100, .T., .T.})

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )


@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[2,3]-5,aPosObj[2,4]-5 LABEL "" OF oDlg PIXEL

oSayIme := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"IMEI"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetIme := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
oGetIme:bValid 		:= {|| ValidZZ4("IME")}

oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+430,{||"Qtde. Transf" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+480,{|u| Iif( PCount() > 0, _nQtdSep := u, _nQtdSep)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdSep",,)

oGetDadM1 := MsNewGetDados():New(aPosObj[1,1]+30,aPosObj[1,2]+11,aPosObj[2,3]-10,aPosObj[2,4]-10,GD_UPDATE,"AllwaysTrue","AllwaysTrue","",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
oGetDadM1:oBrowse:bChange := {|| (oGetDadM1:nat) }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End(), Close(oDlg)},{||oDlg:End()},,aButtons)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDAHEAD  ºAutor  ³Luciano Siqueira    º Data ³  31/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ADDAHEAD()

Local cField := "ZZ4_CODPRO/ZZ4_CARCAC/ZZ4_IMEI/ZZ4_ETQMEM/ZZ4_STATUS/ZZ4_OPEBGH/ZZ4_OS"

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("ZZ4")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Header para o primeiro get da tela |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !SX3->(EOF()) .And. SX3->X3_Arquivo == "ZZ4"
	
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidZZ4  ºAutor  ³Luciano Siqueira    º Data ³  31/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidZZ4(_cTela)

Local _lRet 		:= .T.
Local _cRecCli    	:= ""
Local cTransc     	:= ""
Local cGarMCL     	:= ""  
Local _cOpebgh    	:= ""
Local _lRetEst 		:= .T.

If !empty(_cImei)
	dbSelectArea("ZZ4")
	dbSetOrder(4)
	If !dbSeek(xFilial("ZZ4")+_cImei+"3")
		dbSelectArea("ZZ4")
		dbSetOrder(4)
		If !dbSeek(xFilial("ZZ4")+_cImei+"4")
			MsgAlert("Equipamento não localizado com status 3(Estoque) e 4(Produção). Favor verificar!")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		Else
			_cSeFaDoc:= Alltrim(Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+"2", "ZZJ_SEFADO")) //SETOR E FASE AGUARDANDO DOCUMENTAÇAO
			_nDiasDoc:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH+"2", "ZZJ_DIADOC")//DIAS AGUARDANDO DOCUMENTAÇAO
			_cSeFaAtu:= Alltrim(ZZ4->ZZ4_SETATU)+ALLTRIM(ZZ4->ZZ4_FASATU)//SETOR E FASE ATUAL
			If !_cSeFaAtu $ _cSeFaDoc
				MsgAlert("Equipamento não localizado no Setor e Fase aguardando Documentação. Favor verificar!")
				_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
			Else
				_dDtZZ3 := dDataBase
				_nRecZZ3:= 0
				dbSelectArea("ZZ3")
				dbSetOrder(1)
				If dbSeek(xFilial("ZZ3")+ZZ4->(ZZ4_IMEI+ZZ4_OS))
					While ZZ3->(!Eof()) .and. ZZ3->(ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS)==xFilial("ZZ3")+ZZ4->(ZZ4_IMEI+ZZ4_OS)
						If Alltrim(ZZ3->ZZ3_CODSE2)+Alltrim(ZZ3->ZZ3_FASE2) == _cSeFaAtu .and. ZZ3->ZZ3_ESTORN <>"S"
							_dDtZZ3 := ZZ3->ZZ3_DATA
							_nRecZZ3:= ZZ3->(RECNO())
							Exit						
						Endif
						ZZ3->(dbSkip())
					EndDo				
				Endif			
				If dDataBase-_dDtZZ3 < _nDiasDoc
					MsgAlert("Equipamento encontra-se aguardando Documentação. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Endif
			Endif
		Endif
	Endif
	If _lRet
		If !Alltrim(ZZ4->ZZ4_OPEBGH) $ "N08/N09"
			MsgAlert("Operação Origem do Equipamento deve ser N08/N09. Favor verificar!")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		Endif
		If _lRet
			cTransc     := ZZ4->ZZ4_TRANSC
			cGarMCL     := ZZ4->ZZ4_GARMCL
			_cOpebgh    := IIF(Alltrim(ZZ4->ZZ4_OPEBGH)=="N08","N10","N11")
			dbselectarea("ZZJ")
			ZZJ->(dbsetOrder(1))
			ZZJ->(dbseek(xFilial("ZZJ")+ _cOpebgh + "2"))

			_cRecCli    := Posicione("ZZG",1,xFilial("ZZG")+ZZJ->ZZJ_LAB+ZZ4->ZZ4_DEFINF,"ZZG_RECCLI")

			if ZZ4->ZZ4_GARANT == "S" .and. !empty(_cRecCli) .and. _cRecCli <> "C0022"
				cTransc := ZZJ->ZZJ_CODTRF
			elseif u_CondIRF(ZZJ->ZZJ_LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), ZZ4->ZZ4_DEFINF)
				cTransc := "IRF"
			elseif u_CondIXT(ZZJ->ZZJ_LAB, ZZ4->ZZ4_GARANT, ZZ4->ZZ4_CODPRO, transform(u_TmpFabric(ZZ4->ZZ4_CARCAC, dtos(ZZ4->ZZ4_DOCDTE)),"@!"), ZZ4->ZZ4_DEFINF)
				cTransc := "IXT"
			elseif _cOpeBGH $ "N01/N10/N11"
				cTransc := "IOW"
			endif
			
			// Define Garantia MCLAIM de acordo com o Transaction
			if alltrim(cTransc) $ "IBS/IRE/IRR/IRS/IXT/IR2/IR4/ITS/IER/IFS/IFR"
				cGarMCL := "S"
			elseif alltrim(cTransc) $ "IOW/IRF"
				cGarMCL := "N"
			endif
			
			Begin Transaction
			
			IF ZZ4->ZZ4_STATUS<>"3"
				aAreaAtu := GetArea()
				dbSelectArea("ZZ3")
				ZZ3->(dbgoto(_nRecZZ3))
				u_EstZZ3("ZZ3",_nRecZZ3,4,"TROPEBGH")
				dbSelectArea("ZZ3")
				ZZ3->(dbgoto(_nRecZZ3))
				If ZZ3->ZZ3_ESTORN<>"S"
					_lRetEst := .F.
					MsgAlert("Setor e Fase aguardando documentação não estornado. Favor verificar!")
				Endif
				RestArea(aAreaAtu)
			Endif
			If _lRetEst
				RecLock("ZZ4",.F.)
				ZZ4->ZZ4_OPEANT := ZZ4->ZZ4_OPEBGH
				ZZ4->ZZ4_OPEBGH := IIF(Alltrim(ZZ4->ZZ4_OPEBGH)=="N08","N10","N11")
				ZZ4->ZZ4_TRANSC := cTransc
				ZZ4->ZZ4_GARMCL := cGarMCL
				MsUnlock()
				_nQtdSep += 1
				oGetQSep:Refresh()
			Endif
			End Transaction
			MsAguarde({|| ADDACOLS() })
		Endif
	Endif
	_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
	oGetIme:SetFocus()
Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDACOLS  ºAutor  ³Luciano Siqueira    º Data ³  31/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ADDACOLS(_cTela)

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := ZZ4->(dbStruct())

cChave     := xFilial("ZZ4")+_cImei+"3"

dbSelectArea("ZZ4")
dbSetOrder(4)

If MsSeek(cChave)
	
	If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][1])//IMEI
		AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
	Endif
	
	nColuna := Len(oGetDadM1:aCols)
	
	For nM := 1 To Len(aCampos)
		
		cCpoZO := "ZZ4->" + aCampos[nM][1]
		
		nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
		If nPos > 0
			oGetDadM1:aCols[nColuna][nPos] := &cCpoZO
		EndIf
		
	Next nM
	
	oGetDadM1:aCols[nColuna][nQtdM1+1] := .F.
	
EndIf

oGetDadM1:Refresh()

Return
