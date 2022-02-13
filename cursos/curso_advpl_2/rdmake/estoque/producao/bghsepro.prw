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
±±ºPrograma  ³BGHSEPRO  ºAutor  ³Luciano Siqueira    º Data ³  09/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar Documento de Separação para Produção                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BGHSEPRO()

Local aButtons    	:= {}

Private _cImei    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
Private _cDoc   	:= space(09)
Private _cDocOri   	:= space(09)
Private _cModelo   	:= space(15)
Private _nQtdSZY   	:= 0
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

u_GerA0003(ProcName())


oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parâmetro negrito

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Alimenta o aheader 	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsAguarde({|| ADDAHEAD() })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da Tela                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Separação Produção" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Getdados para Forecast |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}

aAdd( aObjects, {100,100, .T., .T.})
aAdd( aObjects, {100,100, .T., .T.})

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )


@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[2,3]-5,aPosObj[2,4]-5 LABEL "" OF oDlg PIXEL

oSayDoc := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"Documento"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetDoc := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cDoc := u, _cDoc)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cDoc")
oGetDoc:bValid 		:= {|| !Empty(_cDoc) .and. ValidZZ4("DOC")}

oSayIme := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+160,{||"IMEI"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetIme := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+200,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
oGetIme:bValid 		:= {|| ValidZZ4("IME")}

oSayQSzy := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+300,{||"Qtde Doc" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetQSzy := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+350,{|u| Iif( PCount() > 0, _nQtdSzy := u, _nQtdSzy)},oDlg,60,,'@E 99,999,999.99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdSzy",,)

oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+430,{||"Qtde Sep" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+480,{|u| Iif( PCount() > 0, _nQtdSep := u, _nQtdSep)},oDlg,60,,'@E 99,999,999.99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdSep",,)

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

Local cField := "ZZ4_CODPRO/ZZ4_CARCAC/ZZ4_IMEI/ZZ4_ETQMEM/ZZ4_STATUS/ZZ4_DOCSEP"

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

Local _lRet := .T.
Local _cNumMaster := "SEM_MASTER"+SPACE(10)

If _cTela == "DOC"
	If Empty(_cDocOri)
		DbSelectArea("ZZY")
		DbSetOrder(3)
		If !DbSeek(xFilial("ZZY")+_cDoc+_cNumMaster,.F.)
			MsgAlert("Documento de Separação não localizado. Favor verificar!")
			_lRet := .F.
		Else
			_nQtdSzy += ZZY->ZZY_QTDMAS
			_cModelo := Left(ZZY->ZZY_CODPLA,4)
			oGetQSzy:Refresh()
			_cDocOri := _cDoc
			MsAguarde({|| ADDACOLS("DOC") })
		Endif
	ElseIf !Empty(_cDocOri) .and. _cDocOri <> _cDoc
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][6])
			MsgAlert("Não é possivel alterar o Documento de Separação!")
			_cDoc := _cDocOri
		Else
			_cDocOri := _cDoc
		Endif
	Endif
Endif

If _cTela == "IME" .and. !empty(_cImei)
	dbSelectArea("ZZ4")
	dbSetOrder(4)
	If !dbSeek(xFilial("ZZ4")+_cImei+"4")
		MsgAlert("Equipamento não localizado com status 4. Favor verificar!")
		_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
		_lRet := .F.
	Else
		If _nQtdSep == _nQtdSzy
			MsgAlert("Não é possivel separar quantidade maior que a quantidade informada no Documento.")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		Endif
		If _lRet .and. !Alltrim(ZZ4->ZZ4_OPEBGH) $ "N10/N11"
			MsgAlert("Operação do Equipamento não é origem Garantia. Favor verificar!")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.		
		Endif
		
		If _lRet .and. !EMPTY(ZZ4->ZZ4_DOCSEP)
			MsgAlert("Equipamento ja possui documento de separação. Favor verificar!")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		Endif
		If _lRet .and. !Alltrim(_cModelo) $ Alltrim(ZZ4->ZZ4_CODPRO)
			MsgAlert("Modelo do Equipamento divergente do Modelo informado no primeiro registro. Favor verificar!")
			_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
			_lRet := .F.
		Endif
		If _lRet
			Begin Transaction
			RecLock("ZZ4",.F.)
			ZZ4->ZZ4_DOCSEP := _cDoc
			MsUnlock()
			DbSelectArea("ZZY")
			DbSetOrder(3)
			If DbSeek(xFilial("ZZY")+_cDoc+_cNumMaster,.F.)
				RecLock("ZZY",.F.)
				ZZY->ZZY_QTDSEP := ZZY->ZZY_QTDSEP+1
				msUnlock()
			Endif
			_nQtdSep += 1
			oGetQSep:Refresh()
			End Transaction
			MsAguarde({|| ADDACOLS("IMEI") })
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

If _cTela == "IMEI"
	
	cChave     := xFilial("ZZ4")+_cImei+"4"
	
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
	
ElseIf _cTela == "DOC"
	
	cQuery:= " SELECT ZZ4_CODPRO,ZZ4_IMEI"
	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4 "
	cQuery+= " WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"'"
	cQuery+= " AND ZZ4.D_E_L_E_T_='' "
	cQuery+= " AND ZZ4_STATUS = '4' "
	cQuery+= " AND ZZ4_OPEBGH IN ('N10','N11') "	
	cQuery+= " AND ZZ4_DOCSEP = ('"+_cDoc+"')"
	
	If Select("TSQZZ4") > 0
		DbSelectArea("TSQZZ4")
		DbCloseArea()
	Endif
	
	TCQUERY cQuery NEW ALIAS "TSQZZ4"
	
	DbSelectArea("TSQZZ4")
	While ! Eof()
		
		cChave     := xFilial("ZZ4")+TSQZZ4->ZZ4_IMEI+"4"
		
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
			
			_nQtdSep += 1
			oGetQSep:Refresh()
			
		EndIf
				
		DbSelectArea("TSQZZ4")
		DbSkip()
	Enddo
	
	If Select("TSQZZ4") > 0
		DbSelectArea("TSQZZ4")
		DbCloseArea()
	Endif
Endif

oGetDadM1:Refresh()

Return
