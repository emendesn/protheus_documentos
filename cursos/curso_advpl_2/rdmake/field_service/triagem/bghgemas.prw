#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include "hbutton.ch"
#include "TcBrowse.ch"
#include "apwizard.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHGEMAS  บAutor  ณLuciano Siqueira    บ Data ณ  30/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar Master dos itens com Entrada Massiva efetuada        บฑฑ
ฑฑบ          ณ e ainda nใo possuem Documento de Entrada                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BGHGEMAS()

Local aButtons    	:= {}

Private _nQtdP1   	:= 0
Private _nQtdP2   	:= 0
Private _nQtdP3   	:= 0
Private _nQtdP4   	:= 0
Private _nQtdP5   	:= 0
Private _nQtdP6   	:= 0
Private _nQtdP7   	:= 0
Private _nQtdP8   	:= 0
Private _nQtdP9   	:= 0

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
Private aStru		:= {}
Private cPerg		:= "BGHGEMAS"

oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

For i := 1 to Len(_aGrupos)
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(_aGrupos[i])) $ "TRIABGH#Administradores"
		_lUsrAut  := .T.
	EndIf
Next i

If !_lUsrAut
	MsgInfo("Usuario sem acesso para gerar Master. Favor entrar em contato com o administrador do sistema.","Master")
	Return
Endif

AADD(aStru,{"CODPRO","C",TamSX3("ZZ4_CODPRO")[1],0})
AADD(aStru,{"CARCAC","C",TamSX3("ZZ4_CARCAC")[1],0})
AADD(aStru,{"IMEI","C",TamSX3("ZZ4_IMEI")[1],0})
AADD(aStru,{"NUMOS","C",TamSX3("ZZ4_OS")[1],0})
AADD(aStru,{"NFENR","C",TamSX3("ZZ4_NFENR")[1],0})
AADD(aStru,{"NFESER","C",TamSX3("ZZ4_NFESER")[1],0})
AADD(aStru,{"CODCLI","C",TamSX3("ZZ4_CODCLI")[1],0})
AADD(aStru,{"LOJA","C",TamSX3("ZZ4_LOJA")[1],0})
AADD(aStru,{"PALLET","C",TamSX3("ZZO_PALLET")[1],0})

_cArq     := CriaTrab(aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

_cChaveInd	:= "PALLET+CODCLI+LOJA+NFENR+NFESER"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Alimenta o aheader 	|
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MsAguarde({|| ADDAHEAD() })

MsAguarde({|| ATUTRB() })

MsAguarde({|| ADDACOLS() })

dbSelectArea("TRB")
TRB->(dbGotop())

If TRB->(!EOF())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem da Tela                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg TITLE "Gerar Master" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|Getdados para Forecast |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aObjects := {}
	
	aAdd( aObjects, {100,100, .T., .T.})
	aAdd( aObjects, {100,100, .T., .T.})
	
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj		:= MsObjSize( ainfo, aObjects )
	
	
	@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[2,3]-5,aPosObj[2,4]-5 LABEL "" OF oDlg PIXEL
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"P1" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+020,{|u| Iif( PCount() > 0, _nQtdP1 := u, _nQtdP1)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP1",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+090,{||"P2" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+100,{|u| Iif( PCount() > 0, _nQtdP2 := u, _nQtdP2)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP2",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+170,{||"P3" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+180,{|u| Iif( PCount() > 0, _nQtdP3 := u, _nQtdP3)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP3",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+250,{||"P4" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+260,{|u| Iif( PCount() > 0, _nQtdP4 := u, _nQtdP4)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP4",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+330,{||"P5" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+340,{|u| Iif( PCount() > 0, _nQtdP5 := u, _nQtdP5)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP5",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+410,{||"P6" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+420,{|u| Iif( PCount() > 0, _nQtdP6 := u, _nQtdP6)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP6",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+490,{||"P7" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+500,{|u| Iif( PCount() > 0, _nQtdP7 := u, _nQtdP7)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP7",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+570,{||"P8" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+580,{|u| Iif( PCount() > 0, _nQtdP8 := u, _nQtdP8)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP8",,)
	
	oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+650,{||"P9" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+660,{|u| Iif( PCount() > 0, _nQtdP9 := u, _nQtdP9)},oDlg,60,,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdP9",,)
	
	oGetDadM1 := MsNewGetDados():New(aPosObj[1,1]+30,aPosObj[1,2]+11,aPosObj[2,3]-10,aPosObj[2,4]-10,GD_UPDATE,"AllwaysTrue","AllwaysTrue","",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
	oGetDadM1:oBrowse:bChange := {||(oGetDadM1:nat)}
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| Processa({|| IIF(MSGYESNO("Deseja Gerar Etiqueta Master?"),GeraMast(),)},"Processando..."), oDlg:End()},{||oDlg:End()},,aButtons)
	
Else
	MsgInfo("Dados nใo encontrados para o parametro informado!","Opera็ใo")
Endif

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

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

AADD(aHeadM1,{"Produto"		,"CODPRO"	,"@!",TamSX3("ZZ4_CODPRO")[1]	,0,,,"C",,})
AADD(aHeadM1,{"Carca็a"		,"CARCAC"	,"@!",TamSX3("ZZ4_CARCAC")[1]	,0,,,"C",,})
AADD(aHeadM1,{"Imei"		,"IMEI"		,"@!",TamSX3("ZZ4_IMEI")[1]		,0,,,"C",,})
AADD(aHeadM1,{"OS"			,"NUMOS"	,"@!",TamSX3("ZZ4_OS")[1]		,0,,,"C",,})
AADD(aHeadM1,{"NF Entrada"	,"NFENR"	,"@!",TamSX3("ZZ4_NFENR")[1]	,0,,,"C",,})
AADD(aHeadM1,{"Serie"		,"NFESER"	,"@!",TamSX3("ZZ4_NFESER")[1]	,0,,,"C",,})
AADD(aHeadM1,{"Cliente"		,"CODCLI"	,"@!",TamSX3("ZZ4_CODCLI")[1]	,0,,,"C",,})
AADD(aHeadM1,{"Loja"		,"LOJA"		,"@!",TamSX3("ZZ4_LOJA")[1]		,0,,,"C",,})
AADD(aHeadM1,{"Pallet"		,"PALLET"	,"@!",TamSX3("ZZO_PALLET")[1]	,0,,,"C",,})


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
Static Function ADDACOLS()

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := TRB->(dbStruct())

dbSelectArea("TRB")
dbGotop()

While TRB->(!Eof())
	
	AAdd(aColsM1, Array(nQtdM1+1))
	
	nColuna := Len(aColsM1)
	
	For nM := 1 To Len(aCampos)
		
		cCpoTrb := "TRB->" + aCampos[nM][1]
		
		nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
		If nPos > 0
			aColsM1[nColuna][nPos] := &cCpoTrb
		EndIf
		
	Next nM
	
	
	aColsM1[nColuna][nQtdM1+1] := .F.
	
	TRB->(dbSkip())
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
Static Function ATUTRB()

cQuery := "	SELECT "
cQuery += "		R_E_C_N_O_ AS RECZZ4 "
cQuery += "	FROM " + RetSQlName("ZZ4") + " ZZ4(NOLOCK) "
cQuery += "	WHERE "
cQuery += "		ZZ4_FILIAL = '"+xFilial("ZZ4")+"' AND  "
cQuery += "		ZZ4_STATUS = '3' AND "
cQuery += " 	ZZ4_OPEBGH = '"+MV_PAR01+"' AND "
cQuery += " 	ZZ4_ETQMEM = '' AND "
cQuery += " 	ZZ4_PALLET <> '' AND "
cQuery += " 	ZZ4_ENDES  = '' AND "
cQuery += " 	ZZ4_EMUSER = '"+Alltrim(cUserName)+"' AND "
cQuery += " 	ZZ4.D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZZ4_PALLET,ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFENR,ZZ4_NFESER,ZZ4_CODPRO "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "QRYZZ4", .F., .T.)

dbSelectArea("QRYZZ4")
dbGoTop()

While QRYZZ4->(!Eof())
	
	dbSelectArea("ZZ4")
	dbGoto(QRYZZ4->RECZZ4)
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->CODPRO 	:= ZZ4->ZZ4_CODPRO
	TRB->CARCAC 	:= ZZ4->ZZ4_CARCAC
	TRB->IMEI	 	:= ZZ4->ZZ4_IMEI
	TRB->NUMOS		:= ZZ4->ZZ4_OS
	TRB->NFENR	 	:= ZZ4->ZZ4_NFENR
	TRB->NFESER		:= ZZ4->ZZ4_NFESER
	TRB->CODCLI	 	:= ZZ4->ZZ4_CODCLI
	TRB->LOJA		:= ZZ4->ZZ4_LOJA
	TRB->PALLET		:= ZZ4->ZZ4_PALLET
	MsUnlock()
	
	Do Case
		Case ZZ4->ZZ4_PALLET=="P1"
			_nQtdP1 ++
		Case ZZ4->ZZ4_PALLET=="P2"
			_nQtdP2 ++
		Case ZZ4->ZZ4_PALLET=="P3"
			_nQtdP3 ++
		Case ZZ4->ZZ4_PALLET=="P4"
			_nQtdP4 ++
		Case ZZ4->ZZ4_PALLET=="P5"
			_nQtdP5 ++
		Case ZZ4->ZZ4_PALLET=="P6"
			_nQtdP6 ++
		Case ZZ4->ZZ4_PALLET=="P7"
			_nQtdP7 ++
		Case ZZ4->ZZ4_PALLET=="P8"
			_nQtdP8 ++
		Case ZZ4->ZZ4_PALLET=="P9"
			_nQtdP9 ++
	EndCase
	
	QRYZZ4->(dbSkip())
EndDo

If Select("QRYZZ4") > 0
	QRYZZ4->(dbCloseArea())
EndIf

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
Static Function GeraMast()

Local cNumMas := ""
Local cPallet := ""


dbSelectArea("TRB")
TRB->(dbGotop())

Do While TRB->(!EOF())
	If cPallet <> TRB->PALLET
		If !Empty(cNumMas )
			Processa({|| U_BHETQMAS(cNumMas) },"Imprimindo Etiqueta...")
		Endif
		cNumMas := GetSXENum("ZZO","ZZO_NUMCX")
		_nContMax := 1
		While _nContMax == 1
			dbSelectArea("ZZO")
			dbSetOrder(4)
			If dbSeek(xFilial("ZZO")+cNumMas)
				cNumMas := GetSXENum("ZZO","ZZO_NUMCX")
			Else
				_nContMax := 0
			Endif
		EndDo
		ConfirmSX8()
	Endif
	Begin Transaction
	dbSelectArea("ZZ4")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZ4")+TRB->IMEI+TRB->NUMOS)
		
		RecLock("ZZO",.T.)
		ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
		ZZO->ZZO_IMEI		:= ZZ4->ZZ4_IMEI
		ZZO->ZZO_CARCAC		:= ZZ4->ZZ4_CARCAC
		ZZO->ZZO_STATUS		:= '2'
		ZZO->ZZO_MODELO		:= ZZ4->ZZ4_CODPRO
		ZZO->ZZO_GARANT  	:= ZZ4->ZZ4_GARANT
		ZZO->ZZO_DTSEPA		:= dDataBase
		ZZO->ZZO_HRSEPA		:= Time()
		ZZO->ZZO_USRSEP		:= cUserName
		ZZO->ZZO_NUMCX		:= cNumMas
		ZZO->ZZO_ORIGEM		:= "POS"
		ZZO->ZZO_CLIENT		:= ZZ4->ZZ4_CODCLI
		ZZO->ZZO_LOJA		:= ZZ4->ZZ4_LOJA
		ZZO->ZZO_NF			:= ZZ4->ZZ4_NFENR
		ZZO->ZZO_SERIE		:= ZZ4->ZZ4_NFESER
		ZZO->ZZO_PRECO		:= ZZ4->ZZ4_VLRUNI
		ZZO->ZZO_DESTIN		:= "B"
		ZZO->ZZO_ENVARQ		:= "S"
		ZZO->ZZO_BOUNCE		:= "N"
		ZZO->ZZO_DBOUNC		:= ""
		ZZO->ZZO_OPBOUN		:= ""
		ZZO->ZZO_OPERA		:= MV_PAR01
		ZZO->ZZO_REFGAR		:= ""
		ZZO->ZZO_DTDEST		:= dDataBase
		ZZO->ZZO_HRDEST		:= Time()
		ZZO->ZZO_USRDES		:= cUserName
		MsUnlock()
		
		RecLock("ZZ4",.F.)
		ZZ4->ZZ4_ETQMEM		:= cNumMas
		MsUnlock()
		
	Endif
	End Transaction
	
	cPallet := TRB->PALLET
	
	TRB->(dbSkip())
EndDo

If !Empty(cNumMas )
	Processa({|| U_BHETQMAS(cNumMas) },"Imprimindo Etiqueta...")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณLuciano Siqueira    บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPerguntas                                                   บฑฑ
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

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Operacao    ?','' ,'' , 'mv_ch1', 'C', 3, 0, 0, 'G', '', 'ZZJ', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')

Return
