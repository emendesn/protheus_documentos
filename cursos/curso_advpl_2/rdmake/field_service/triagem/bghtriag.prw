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
ฑฑบDesc.     ณ Tela para Triagem e gera็ใo da Etq. Master Nextel / BGH    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BGHTRIAG()

Private cCadastro := "Triagem e Gera็ใo Etq. Master"
Private aCores    := {}
Private nOpcao

Private aRotina := {}

Private lUsrAut  	:= .F.
Private aGrupos  	:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
Private cNexSpRj    := GetMv("MV_NEXTSP") +"/"+GetMv("MV_NEXTRJ")

u_GerA0003(ProcName())

aAdd(aRotina, {"Pesquisar","AxPesqui",0,1})
aAdd(aRotina, {"Visualizar","AxVisual",0,2})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida acesso de usuario                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(aGrupos[i])) $ "TRIABGH#Administradores"
		lUsrAut  := .T.
	EndIf
Next i

If lUsrAut
	aAdd(aRotina, {"Triagem","U_BGHTRI02(1)",0,3,, .f.})
	aAdd(aRotina, {"Ent Massiva","U_BGHENTMA()",0,3,, .f.})
	aAdd(aRotina, {"Excluir IMEI","U_BGHEXZZO(1)",0,3,, .f.})
Endif

/*
If UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_TRIAREC"))
aAdd(aRotina, {"Triagem","U_BGHTRI02(1)",0,7, .f.})
aAdd(aRotina, {"Ent Massiva","U_BGHENTMA()",0,7, .f.})
aAdd(aRotina, {"Excluir IMEI","U_BGHEXZZO(1)",0,7, .f.})
Endif
*/

If UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_EXCMAST"))
	aAdd(aRotina, {"Excluir Master","U_BGHEXZZO(2)",0,3,, .f.})
Endif

If UPPER(Alltrim(cUsername)) $ UPPER(GETMV("BH_TRIAEST"))
	aAdd(aRotina, {"Gera Master Estoque","U_BGHTRI02(2)",0,3,, .f.})
Endif


lUsrAut  	:= .F.

For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado
	If AllTrim(GRPRetName(aGrupos[i])) $ "TRIAEST#Administradores"
		lUsrAut  := .T.
	EndIf
Next i

If lUsrAut
	aAdd(aRotina, {"Master Devolucao Estoque","U_BGHTRI02(3)",0,3,, .f.})
Endif

aAdd(aRotina, {"Imp Etq Master","U_BHETQMAS()",0,7,, .f.})
aAdd(aRotina, {"Legenda"         ,'U_LegenZZO()',0,6,,})



aAdd(aCores, {"ZZO_STATUS == '0'  .And. ZZO_SEGREG <>  'S'"                      , "ENABLE"    	})    // Triando
aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG <>  'S'"                      , "BR_AZUL"   	})    // Separacao Efetuada
aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG ==  'S'"                      , "DISABLE"   	})    // Equipamento Segregado
aAdd(aCores, {"ZZO_STATUS == '2'"                                                , "BR_PINK"   	})    // Entrada Massiva BGH
aAdd(aCores, {"ZZO_STATUS == '9'"                                                , "BR_CANCEL" 	})    // Rotina Master Estoque BGH

dbSelectArea("ZZO")
dbSetOrder(1)

MBrowse( 6,1,22,75, "ZZO",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHTRI02  บAutor  ณLuciano Siqueira    บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua Triagem e gera Etq. Master                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BGHTRI02(nOpcao)

Local nOpcG      	:= 3
Local cLinOK     	:= "AllwaysTrue"
Local cTudoOK       := "AllwaysTrue"
Local c_item  		:= ""
Local nLinhas		:= 30
Local cFieldOK   	:= "AllwaysTrue"
Local bExecBrow
Local bBlock
Local nWndTop
Local nWndLeft
Local nAdjust
Local lTopFilter
Local lAxPesqui 	:= .T.
Local lSeeAll 		:= .T.
Local oPesqPanel	:= Nil
Local oPesqGet		:= Nil
Local oPesqCbx		:= Nil
Local cPesqCampo 	:= Space(40)
Local cPesqOrd		:= ""
Local aPesqIdx 		:= {}
Local aPesqOrd	 	:= {}
Local nPesqPos		:= 1
Local lAxPesqui 	:= .F.
Local oOrigem		:= Nil
Local aOrigem		:= {"RJ","BH"}
Local aButtons    	:= {}

Private _cGara			:= ""
Private _cRefGar		:= ""
Private _cBounce	    := ""
Private _nDBounce		:= 0
Private _cOperBou		:= ""
Private _cModelo		:= space(15)
Private _cTES			:= space(06)
Private _cModOri		:= space(15)
Private _cDesMod		:= space(50)
Private _cOrigem		:= space(10)
Private _cOrigemOri		:= space(10)
Private _cNF			:= space(09)
Private _cNFOri			:= space(09)
Private _cSerie	    	:= space(03)
Private _cSerOri    	:= space(03)
Private _cCarca		    := space(25)
Private _cImei	    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
Private _cCliente		:= space(06)
Private _cCliOri		:= space(06)
Private _cLoja  		:= space(02)
Private _cLojOri  		:= space(02)
Private _cMensag		:= space(20)
Private _cMGar	 		:= space(20)
Private _cMPrata 		:= space(20)
Private _cMFog			:= space(20)
Private _cMBou			:= space(20)
Private _cNumCx			:= space(20)
Private _nPreco 		:= 0
Private _nPrOri 		:= 0
Private _nQtMGar	 	:= 0
Private _nQtMPra	 	:= 0
Private _nQtMFog		:= 0
Private _nQtMBou		:= 0
Private _nQMaxGar       := 999
Private _nQMaxFog       := 999
Private _nQMaxBou       := 999
Private _cValGar		:= ""
Private _cValBou		:= ""
Private _cValMod		:= ""

Private aColsM1	    := {}
Private aColsM2	    := {}
Private aRotina		:= {}
Private aHeadM1 	:= {}
Private aHeadM2 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados
Private aEdiCpo2  	:= {"B2_COD","QTDNF"} //Campos a serem editados
Private aPosObj    	:= {}
Private aObjects   	:= {}


Private oGetDadM1   := Nil
Private oGetDadM2   := Nil
Private oDlg		:= Nil
Private oSayGar		:= Nil
Private oSayFog		:= Nil
Private oSayBou		:= Nil

Private aSize      	:= MsAdvSize(.T.)
Private nOpc        := 3 //Inclusao
Private nFreeze 	:= 2
Private nQtdPlan   	:= 2 //Quantidade de plantas
Private bCalc    	:= {|K,Y| Z := Round( ( K * (Y / 100) ),0 ) }
Private bCaPor   	:= {|K,Y| Z := Round( ( ( K / Y )* 100 ),0 ) }

Private cPerg		:= "BGHTRIAG"
Private _cOpeBGH	:= ""
Private _cMotivo	:= ""
Private _cdadoSZA   := ""
Private _nTriagem	:= 1

Private _cTesGar	:= GETMV("BH_TESGAR")
Private _cTesFog	:= GETMV("BH_TESFOG")


If nOpcao == 1
	
	ValPerg(cPerg) // Ajusta as Perguntas do SX1
	If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		Return()
	Endif
	
	_cOpeBGH	:= MV_PAR01
	_nTriagem	:= MV_PAR02
	
	dbSelectArea("ZZJ")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZJ")+_cOpeBGH)
		If ZZJ_TRIAEN <> 'S'
			MsgAlert("Opera็ใo nใo configurada para efetuar entrada na BGH.")
			Return()
		Else
			_nQMaxGar       := ZZJ_MAXGAR
			_nQMaxFog       := ZZJ_MAXFOG
			_nQMaxBou       := ZZJ_MAXBOU
			_cdadoSZA       := ZZJ_DADSZA
			
			_cValGar		:= ZZJ_VALGAR
			_cValBou		:= ZZJ_VALBOU
			_cValMod		:= ZZJ_VALMOD
			
			If Empty(_cValGar)
				MsgAlert("Informe se valida Garantia por Carca็a ou TES no cadastro de Opera็๕es.")
				Return()
			Endif
			
			If Empty(_cValBou)
				MsgAlert("Informe se valida Bounce no cadastro de Opera็๕es.")
				Return()
			Endif
			
			If Empty(_cValMod)
				MsgAlert("Informe se valida Modelo no cadastro de Opera็๕es.")
				Return()
			Endif
			
			
			If ZZJ_MAXGAR+ZZJ_MAXFOG+ZZJ_MAXBOU == 0
				MsgAlert("Informe a quantidade maxima nas Master no cadastro de Opera็๕es.")
				Return()
			Endif
			If  ZZJ_MAXGAR == 0
				MsgAlert("Informe a quantidade maxima na Master para GAR no cadastro de Opera็๕es.")
				Return()
			Endif
			If  ZZJ_MAXFOG == 0
				MsgAlert("Informe a quantidade maxima na Master para FOG no cadastro de Opera็๕es.")
				Return()
			Endif
			If  ZZJ_MAXBOU == 0
				MsgAlert("Informe a quantidade maxima na Master para BOU no cadastro de Opera็๕es.")
				Return()
			Endif
		Endif
	Else
		MsgAlert("Operacใo nใo encontrada.")
		Return()
	Endif
ElseIf nOpcao == 3
	cPerg		:= "TRDEVEST"
	ValPerg2(cPerg) // Ajusta as Perguntas do SX1
	If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		Return()
	Endif
	_cMotivo	:= MV_PAR01
Endif
oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito
oFont1  := tFont():New('Tahoma',,-28,.t.,.t.) // 5o. Parโmetro negrito
oFont2  := tFont():New('Tahoma',,-18,.t.,.t.) // 5o. Parโmetro negrito

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

Aadd(aButtons,{"RELATORIO",{|| LEGEND()  },"LEGENDA","LEGENDA"}) //LEGENDA
Aadd(aButtons,{"SOLICITA",{|| Processa({|| GRAVAZZO(nOpcao) },"Processando Master...")  },"Gerar Master","Gerar Master"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLabel de Informa็๕es adicionais ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[1,3],aPosObj[1,4]-5 LABEL "" OF oDlg PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDescricao do ForeCast ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpcao == 1
	oSayOri := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"Origem" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetOri := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cOrigem := u, _cOrigem)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"BH","_cOrigem")
	oGetOri:bValid:= {|| Valida("ORI",nOpcao)}
	
	If _cValGar == "2"
		oSayTes := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+160,{||"TES"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oGetTes := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _cTES := u, _cTES)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"SF4","_cTES")
		oGetTes:bValid:= {|| !Empty(Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_CODIGO")) .and. Valida("TES",nOpcao)}
	Endif
	
	
	oSayCli := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+010,{||"Cliente" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetCli := tGet():New( aPosObj[1,1]+25,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cCliente := u, _cCliente)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"SA1","_cCliente")
	oGetCli:bValid:= {|| !Empty(_cCliente) .and. Valida("CLI",nOpcao)}
	
	oSayLoj := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+160,{||"Loja" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetLoj	:= TGet():New( aPosObj[1,1]+25,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _cLoja := u, _cLoja)},oDlg,60,,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_cLoja",,)
	
	oSayNF := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+010,{||"Nota Fiscal"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetNF := tGet():New( aPosObj[1,1]+45,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cNF := u, _cNF)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cNF")
	oGetNF:bValid:= {|| !Empty(_cNF) .and. Valida("NF",nOpcao)}
	
	oSaySer := TSay():New( aPosObj[1,1]+45,aPosObj[1,2]+160,{||"Serie"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetSer := tGet():New( aPosObj[1,1]+45,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _cSerie := u, _cSerie)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cSerie")
	oGetSer:bValid:= {|| !Empty(_cSerie) .and. Valida("SER",nOpcao)}
	
	oSayPre := TSay():New( aPosObj[1,1]+65,aPosObj[1,2]+010,{||"Pre็o"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetPre := tGet():New( aPosObj[1,1]+65,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _nPreco := u, _nPreco)},oDlg,60,,"@E 99,999,999.99999",,,,,,,.T.,,,,,,,,,"","_nPreco")
	oGetPre:bValid:= {|| _nPreco > 0 .and. Valida("PRE",nOpcao)}
	
	oSayMod := TSay():New( aPosObj[1,1]+85,aPosObj[1,2]+010,{||"Modelo"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetMod	:= TGet():New( aPosObj[1,1]+85,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cModelo := u, _cModelo)},oDlg,60,,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","_cModelo",,)
	oGetMod:bValid:= {|| !Empty(Posicione("SB1",1,xFilial("SB1")+_cModelo,"B1_COD")) .and. Valida("MOD",nOpcao)}
	
	oSayDes := TSay():New( aPosObj[1,1]+85,aPosObj[1,2]+160,{||"Descri็ใo"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetDes	:= TGet():New( aPosObj[1,1]+85,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _cDesMod := u, _cDesMod)},oDlg,141,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_cDesMod",,)
	oGetMod:bLostFocus := {|| _cDesMod := Posicione("SB1",1,xFilial("SB1")+_cModelo,"B1_DESC")}
	
	oSayCar := TSay():New( aPosObj[1,1]+105,aPosObj[1,2]+010,{||"Carca็a"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetCar := tGet():New( aPosObj[1,1]+105,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cCarca := u, _cCarca)},oDlg,80,,"@!",,,,,,,.T.,,,,,,,,,"","_cCarca")
	
	oSayIme := TSay():New( aPosObj[1,1]+105,aPosObj[1,2]+160,{||"IMEI"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetIme := tGet():New( aPosObj[1,1]+105,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
	oGetIme:bValid 		:= {|| Valida("IME",nOpcao)}
Else
	
	oSayMod := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"Modelo"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetMod	:= TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cModelo := u, _cModelo)},oDlg,60,,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","_cModelo",,)
	oGetMod:bValid:= {|| !Empty(Posicione("SB1",1,xFilial("SB1")+_cModelo,"B1_COD")) .and. ValidZZ4("MOD",nOpcao)}
	
	oSayIme := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+010,{||"IMEI"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetIme := tGet():New( aPosObj[1,1]+25,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
	oGetIme:bValid 		:= {|| ValidZZ4("IME",nOpcao)}
Endif

@aPosObj[1,1],aPosObj[1,2]+355 To aPosObj[1,3],aPosObj[1,4]-5 LABEL "" OF oDlg PIXEL

DEFINE FONT oFont NAME "FW Microsiga" SIZE 0, -9

If _cValGar == "1" .or. Empty(_cValGar)
	
	If _nTriagem == 2
		oSayGar := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+360,{||"QTD MASTER PRATA - "+Strzero(_nQtMPra,3)},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayGar := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+360,{||_cMPrata},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
	ElseIf _nTriagem == 3
		oSayGar := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+360,{||"QTD MASTER GAR - "+Strzero(_nQtMGar,3)},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayGar := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+360,{||_cMGar},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
	ElseIf _nTriagem == 4
		oSayFog := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+360,{||"QTD MASTER FOG - "+Strzero(_nQtMFog,3) },oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayFog := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+360,{||_cMFog},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,252,016)
	Else
		
		oSayGar := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+360,{||"QTD MASTER GAR - "+Strzero(_nQtMGar,3)},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayGar := TSay():New( aPosObj[1,1]+20,aPosObj[1,2]+360,{||_cMGar},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
		
		oSayFog := TSay():New( aPosObj[1,1]+35,aPosObj[1,2]+360,{||"QTD MASTER FOG - "+Strzero(_nQtMFog,3) },oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayFog := TSay():New( aPosObj[1,1]+50,aPosObj[1,2]+360,{||_cMFog},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,252,016)
		
		oSayBou := TSay():New( aPosObj[1,1]+65,aPosObj[1,2]+360,{||"QTD MASTER BOU - "+Strzero(_nQtMBou,3) },oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
		oSayBou := TSay():New( aPosObj[1,1]+80,aPosObj[1,2]+360,{||_cMBou},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,252,016)
	Endif
Else
	
	MsAguarde({|| AHEAD2() })
	
	oGetDadM2 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2]+355,aPosObj[1,3]-35,aPosObj[1,4]-5,3,"AllwaysTrue","AllwaysTrue","",aEdiCpo2,0,9999,,,.T.,oDlg,aHeadM2,aColsM2)
	oGetDadM2:oBrowse:bChange := {|| (oGetDadM2:nat) }
Endif

@aPosObj[1,1],aPosObj[1,2]+355 To aPosObj[1,3]-35,aPosObj[1,4]-5 LABEL "" OF oDlg PIXEL

If _nTriagem == 2 .and. _cValGar == "1"
	oSayMen := TSay():New( aPosObj[1,1]+110,aPosObj[1,2]+360,{|| _cMensag },oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
Else
	oSayMen := TSay():New( aPosObj[1,1]+110,aPosObj[1,2]+360,{|| Iif(Alltrim(_cGara) == 'S' .and. Alltrim(_cBounce) <> 'S', _cMensag,"")},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,252,016)
	
	oSayMen := TSay():New( aPosObj[1,1]+110,aPosObj[1,2]+360,{|| Iif(Alltrim(_cGara) == 'N' .and. Alltrim(_cBounce) <> 'S', _cMensag,"")},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,252,016)
	
	oSayMen := TSay():New( aPosObj[1,1]+110,aPosObj[1,2]+360,{|| Iif(Alltrim(_cBounce) == 'S', _cMensag,"")},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,252,016)
Endif


@aPosObj[2,1],aPosObj[2,2]+5 To aPosObj[2,3]-5,aPosObj[2,4]-5 LABEL "" OF oDlg PIXEL

oGetDadM1 := MsNewGetDados():New(aPosObj[2,1]+15,aPosObj[2,2]+11,aPosObj[2,3]-10,aPosObj[2,4]-10,GD_UPDATE,"AllwaysTrue",cTudoOK,"",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
oGetDadM1:oBrowse:bChange := {|| (oGetDadM1:nat) }


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| Processa({|| IIF(MSGYESNO("Deseja Finalizar Etiqueta Master?"),GravaZZO(nOpcao),)},"Processando..."), oDlg:End()},{||oDlg:End()},,aButtons)



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

Local cField := "ZZO_IMEI/ZZO_CARCAC/ZZO_STATUS/ZZO_MODELO/ZZO_GARANT/ZZO_DTSEPA/ZZO_HRSEPA/ZZO_USRSEP/ZZO_NUMCX/ZZO_ORIGEM/ZZO_CLIENT/ZZO_LOJA/ZZO_NF/ZZO_SERIE/ZZO_PRECO/ZZO_BOUNCE/ZZO_DBOUNC/ZZO_OPERA"

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
Static Function ADDACOLS(_cTela,nOpcao)

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := ZZO->(dbStruct())

If _cTela == "IMEI"
	
	cChave     := xFilial("ZZO")+_cImei+_cCarca+"0"
	
	dbSelectArea("ZZO")
	dbSetOrder(1)
	
	If MsSeek(cChave)
		
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_IMEI+ZZO_CARCAC+ZZO_STATUS)
			
			If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
				AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
			Endif
			
			nColuna := Len(oGetDadM1:aCols)
			
			If _nTriagem == 2 .and. _cValGar == "1"
				oGetDadM1:aCols[nColuna][1] := "BR_BRANCO"
				_nQtMPra++
			Else
				If Alltrim(ZZO->ZZO_GARANT) == 'S' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_MARRON"
					_nQtMGar++
				ElseIf Alltrim(ZZO->ZZO_GARANT) == 'N' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
					_nQtMFog++
				ElseIf Alltrim(ZZO->ZZO_BOUNCE) == 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_VERMELHO"
					_nQtMBou++
				Endif
			Endif
			
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
			
			If _cValGar == "2"
				For i:=1 to len(oGetDadM2:aCols)
					If Alltrim(oGetDadM2:aCols[i,1]) == Alltrim(ZZO->ZZO_MODELO)
						oGetDadM2:aCols[i,3] +=1
						oGetDadM2:Refresh()
						Exit
					Endif
				Next i
			Endif
			ZZO->(dbSkip())
		EndDo
		
	EndIf
ElseIf _cTela == "MOD" .and. nOpcao == 1 .and. _cValMod == "S"
	
	cChave     := xFilial("ZZO")+_cCliente+_cLoja+_cNF+_cSerie+_cModelo+"0"
	
	dbSelectArea("ZZO")
	dbSetOrder(5)
	
	If MsSeek(cChave)
		
		If _nPreco <> ZZO->ZZO_PRECO
			_nPreco := ZZO->ZZO_PRECO
			_nPrOri := _nPreco
		Endif
		
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_CLIENT+ZZO_LOJA+ZZO_NF+ZZO_SERIE+ZZO_MODELO+ZZO_STATUS)
			
			If alltrim(ZZO->ZZO_USRSEP) == Alltrim(cUserName)
			
				If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
					AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
				Endif
				
				nColuna := Len(oGetDadM1:aCols)
				
				If _nTriagem == 2 .and. _cValGar == "1"
					oGetDadM1:aCols[nColuna][1] := "BR_BRANCO"
					_nQtMPra++
					If Empty(_cMPrata)
						_cMPrata := ZZO->ZZO_NUMCX
					Endif
				Else
					If Alltrim(ZZO->ZZO_GARANT) == 'S' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_MARRON"
						_nQtMGar++
						If Empty(_cMGar)
							_cMGar := ZZO->ZZO_NUMCX
						Endif
					ElseIf Alltrim(ZZO->ZZO_GARANT) == 'N' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
						_nQtMFog++
						If Empty(_cMFog)
							_cMFog := ZZO->ZZO_NUMCX
						Endif
					ElseIf Alltrim(ZZO->ZZO_BOUNCE) == 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_VERMELHO"
						_nQtMBou++
						If Empty(_cMBou)
							_cMBou := ZZO->ZZO_NUMCX
						Endif
					Endif
				Endif
				
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
			Endif
			ZZO->(dbSkip())
		EndDo
		
	EndIf
	
ElseIf _cTela == "MOD" .and. nOpcao == 1 .and. _cValMod <> "S"
	
	cChave     := xFilial("ZZO")+_cCliente+_cLoja+_cNF+_cSerie
	
	dbSelectArea("ZZO")
	dbSetOrder(5)
	
	If MsSeek(cChave)
		
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_CLIENT+ZZO_LOJA+ZZO_NF+ZZO_SERIE)
			If ZZO->ZZO_STATUS == "0" .and. alltrim(ZZO->ZZO_USRSEP) == Alltrim(cUserName)
				
				If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
					AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
				Endif
				
				nColuna := Len(oGetDadM1:aCols)
				
				If _nTriagem == 2 .and. _cValGar == "1"
					oGetDadM1:aCols[nColuna][1] := "BR_BRANCO"
					_nQtMPra++
					If Empty(_cMPrata)
						_cMPrata := ZZO->ZZO_NUMCX
					Endif
				Else
					If Alltrim(ZZO->ZZO_GARANT) == 'S' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_MARRON"
						_nQtMGar++
						If Empty(_cMGar)
							_cMGar := ZZO->ZZO_NUMCX
						Endif
					ElseIf Alltrim(ZZO->ZZO_GARANT) == 'N' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
						_nQtMFog++
						If Empty(_cMFog)
							_cMFog := ZZO->ZZO_NUMCX
						Endif
					ElseIf Alltrim(ZZO->ZZO_BOUNCE) == 'S'
						oGetDadM1:aCols[nColuna][1] := "BR_VERMELHO"
						_nQtMBou++
						If Empty(_cMBou)
							_cMBou := ZZO->ZZO_NUMCX
						Endif
					Endif
				Endif
				
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
				
				If _cValGar == "2"
					For i:=1 to len(oGetDadM2:aCols)
						If Alltrim(oGetDadM2:aCols[i,1]) == Alltrim(ZZO->ZZO_MODELO)
							oGetDadM2:aCols[i,3] +=1
							oGetDadM2:Refresh()
							Exit
						Endif
					Next i
				Endif
			Endif
			ZZO->(dbSkip())
		EndDo
		
	EndIf
	
ElseIf _cTela == "MOD" .and. (nOpcao == 2 .or. nOpcao == 3)
	
	cChave     := xFilial("ZZO")+_cModelo+"0"+IIF(nOpcao==2,"ZZ4   ","DEV   ")//MODELO+STATUS/ORIGEM
	
	dbSelectArea("ZZO")
	dbSetOrder(6)
	
	If MsSeek(cChave) 
	
		While ZZO->(!Eof()) .And. cChave == ZZO->(ZZO_FILIAL+ZZO_MODELO+ZZO_STATUS+ZZO_ORIGEM)
			If ZZO->ZZO_STATUS == "0" .and. alltrim(ZZO->ZZO_USRSEP) == Alltrim(cUserName)
			
			If Empty(_cCliOri+_cLojOri) 
				_cModelo := ZZO->ZZO_MODELO
				_cOpeBgh := ZZO->ZZO_OPERA
				_cCliOri := ZZO->ZZO_CLIENT
				_cLojOri := ZZO->ZZO_LOJA
				_cMotivo := ZZO->ZZO_MOTIVO
			Endif
			
				If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
					AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
				Endif
				
				nColuna := Len(oGetDadM1:aCols)
				
				If Alltrim(ZZO->ZZO_GARANT) == 'S' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_MARRON"
					_nQtMGar++
					If Empty(_cMGar)
						_cMGar := ZZO->ZZO_NUMCX
					Endif
				ElseIf Alltrim(ZZO->ZZO_GARANT) == 'N' .AND. Alltrim(ZZO->ZZO_BOUNCE) <> 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_VERDE"
					_nQtMFog++
					If Empty(_cMFog)
						_cMFog := ZZO->ZZO_NUMCX
					Endif
				ElseIf Alltrim(ZZO->ZZO_BOUNCE) == 'S'
					oGetDadM1:aCols[nColuna][1] := "BR_VERMELHO"
					_nQtMBou++
					If Empty(_cMBou)
						_cMBou := ZZO->ZZO_NUMCX
					Endif
				Endif
				
				If Empty(_cOpeBgh)
					_cOpeBgh := ZZO->ZZO_OPERA
				Endif
				
				
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
			Endif
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
ฑฑบPrograma  ณADDAHEAD  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AHEAD2()

aAdd(aHeadM2,{"Modelo","B2_COD","@!",15,0,,,"C",,})
aAdd(aHeadM2,{"Qtd NF","QTDNF","@E 999,999,999.99",12,2,,,"N",,})
aAdd(aHeadM2,{"Qtd Lida","QTDLIDA","@E 999,999,999.99",12,2,,,"N",,})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValida   บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Valida(_cTela,nOpcao)

Local _lRet := .T.

//Nใo autoriza o usuario alterar a Origem
If !empty(_cOrigem) .and. _cTela == "ORI"
	If Empty(_cOrigemOri)
		_cOrigemOri := _cOrigem
	ElseIf !Empty(_cOrigemOri) .and. _cOrigemOri <> _cOrigem
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar a Origem.")
			_cOrigem := _cOrigemOri
		Else
			_cOrigemOri := _cOrigem
		Endif
	Endif
Endif

If !empty(_cTES) .and. _cTela == "TES"
	If !Alltrim(_cTes) $ _cTesGar .and. !Alltrim(_cTes) $ _cTesFog
		MsgAlert("TES informada nใo existe nos parametros que controlam Garantia e Fora de Garantia.")
		_cTES    := space(6)
		oGetTes:SetFocus()
	Endif
Endif


//Nใo autoriza o usuario alterar o Cliente
If !empty(_cCliente) .and. _cTela == "CLI"
	If Empty(_cCliOri)
		_cCliOri := _cCliente
		_cLojOri := _cLoja
	ElseIf !Empty(_cCliOri) .and. _cCliOri <> _cCliente
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar o Cliente.")
			_cCliente := _cCliOri
			_cLoja	  := _cLojOri
		Else
			_cCliOri := _cCliente
			_cLojOri := _cLoja
		Endif
	Endif
Endif

//Nใo autoriza o usuario alterar a NF
If !empty(_cNF) .and. _cTela == "NF"
	If Empty(_cNFOri)
		_cNFOri  := _cNF
	ElseIf !Empty(_cNFOri) .and. _cNFOri <> _cNF
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar a NF.")
			_cNF    := _cNFOri
		Else
			_cNFOri  := _cNF
		Endif
	Endif
Endif

//Nใo autoriza o usuario alterar a Serie NF
If !empty(_cSerie) .and. _cTela == "SER"
	If Empty(_cSerOri)
		_cSerOri := _cSerie
	ElseIf !Empty(_cSerOri) .and. _cSerOri <> _cSerie
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar a Serie.")
			_cSerie := _cSerOri
		Else
			_cSerOri := _cSerie
		Endif
	Endif
Endif

//Nใo autoriza o usuario alterar a Pre็o
If _cTela == "PRE"
	If _nPrOri == 0
		_nPrOri  := _nPreco
	ElseIf _nPrOri <> _nPreco .and. _cValMod == "S"
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar o Pre็o.")
			_nPreco    := _nPrOri
		Else
			_nPrOri  := _nPreco
		Endif
	Endif
Endif

//Nใo autoriza o usuario alterar o Modelo
If !Empty(_cModelo).and. _cTela == "MOD"
	If _cValGar == "2"
		_lValMod := .F.
		For i:=1 to Len(oGetDadM2:aCols)
			If Alltrim(oGetDadM2:aCols[i,1]) == Alltrim(_cModelo)
				_lValMod := .T.
				Exit
			Endif
		Next i
		If !_lValMod
			MsgAlert("Modelo informado nใo confere com os produtos da NF.")
			Return(.F.)
		Endif
	Endif
	
	If Empty(_cModOri)
		_cModOri := _cModelo
		MsAguarde({|| ADDACOLS("MOD",nOpcao) })
	ElseIf !Empty(_cModOri) .and. _cModOri <> _cModelo .and. _cValMod == "S"
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])
			MsgAlert("Nใo ้ possivel alterar o Modelo.")
			_cModelo := _cModOri
			_cDesMod := Posicione("SB1",1,xFilial("SB1")+_cModelo,"B1_DESC")
		Else
			_cModOri := _cModelo
		Endif
	Endif
Endif

//Valida Carca็a e IMEI
If _cTela == "IME" .and. !empty(_cImei)
	If _cValGar == "1"
		If Len(AllTrim(_cCarca)) <> 10
			MsgAlert("Equipamento com Erro na Carca็a, Favor Inserir Novamente!")
			_cCarca	:= Space(25)
			_lRet := .F.
		ElseIf _lRet .And. !U_VALDCARC(AllTrim(_cCarca)) .and. AllTrim(_cCarca) <> Alltrim(GETMV("MV_SNPADR"))
			MsgAlert("Equipamento com Erro na Carca็a, Favor Inserir Novamente!")
			_cCarca	:= Space(25)
			_lRet := .F.
		Endif
	Else
		If Empty(_cCarca)
			MsgAlert("Equipamento com Erro na Carca็a, Favor Inserir Novamente!")
			_cCarca	:= Space(25)
			_lRet := .F.
		Endif
		For i:=1 to len(oGetDadM2:aCols)
			If Alltrim(oGetDadM2:aCols[i,1]) == Alltrim(_cModelo)
				If oGetDadM2:aCols[i,3] >= oGetDadM2:aCols[i,2]
					MsgAlert("Qtde Lida maior que Qtde existente na NF!")
					_cCarca	:= Space(25)
					_cImei	:= Space(space(TamSX3("ZZ4_IMEI")[1]))
					_lRet := .F.
					Exit
				Endif
			Endif
		Next i
	Endif
	
	If _lRet .and. !u_IMEIxModel(_cCarca, _cOpeBgh,"C") .and. AllTrim(_cCarca) <> Alltrim(GETMV("MV_SNPADR"))
		_cCarca	:= Space(25)
		_lRet := .F.
	Endif


	If Empty(_cImei) .and. _lRet
		_lRet := .F.
	ElseIf Len(AllTrim(_cImei)) <> 15 .and. _cValGar == "1"
		MsgAlert("Equipamento com Erro no Imei, Favor Inserir Novamente!")
		//_cImei	:= Space(space(TamSX3("ZZ4_IMEI")[1])) // Alterado GLPI 21536
		_cImei := AvKey(_cImei,"ZZ4_IMEI")
		_lRet := .F.
	ElseIf !empty(_cImei) .and. _lRet
      //Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
      //If Alltrim(_cdadoSZA) = "S" .OR. (Alltrim(_cdadoSZA) = "C" .and. alltrim(_cCliente) $ "000016/000680")$ Alltrim(cNexSpRj)
		If Alltrim(_cdadoSZA) = "S" .OR. (Alltrim(_cdadoSZA) = "C" .and. alltrim(_cCliente) $ Alltrim(cNexSpRj))
			dbSelectArea("SZA")
			dbSetOrder(1)
			If !dbSeek(xFilial("SZA")+_cCliente+_cLoja+_cNF+_cSerie+_cImei)
				MsgAlert("Equipamento nใo localizado na tabela SZA. Favor verificar!")
				_lRet := .F.
			Else
				If !Alltrim(_cModelo) == Alltrim(SZA->ZA_CODPRO)
					MsgAlert("Modelo do IMEI divergente do modelo existente na tabela SZA. Favor verificar!")
					_lRet := .F.
				Else
					Begin Transaction
					RecLock("SZA",.F.)
					SZA->ZA_STATUS 	:= "V"
					MsUnlock()
					End Transaction
				Endif
			Endif
		Endif
		If _lRet
			If _cValBou == "S"
				CalBounce()
			Else
				_cBounce := "N"
			Endif
			If _cValGar == "1"
				Garantia()
				If _nTriagem == 2
					_cMensag := "PRATA"
				Else
					If _nTriagem == 3 .and. _cValGar == "1"
						_cGara	:= "S"
						_cBounce:= "N"
					ElseIf _nTriagem == 4 .and. _cValGar == "1"
						_cGara	:= "N"
						_cBounce:= "N"
					Endif
					If Alltrim(_cGara) == 'S' .and. Alltrim(_cBounce) <> 'S'
						_cMensag := "GARANTIA"
					ElseIf Alltrim(_cGara) == 'N' .and. Alltrim(_cBounce) <> 'S'
						_cMensag := "FORA GARANTIA"
					ElseIf Alltrim(_cBounce) == 'S'
						_cMensag := "BOUNCE"
					Endif
				Endif
			ElseIf _cValGar == "2"
				If Alltrim(_cTES) $ _cTesGar .and. Alltrim(_cBounce) <> 'S'
					_cGara	 := "S"
					_cMensag := "GARANTIA"
				ElseIf Alltrim(_cTES) $ _cTesFog .and. Alltrim(_cBounce) <> 'S'
					_cGara	 := "N"
					_cMensag := "FORA GARANTIA"
				ElseIf Alltrim(_cBounce) == 'S'
					_cMensag := "BOUNCE"
				Endif
			Endif
			_lGrvZZO := .T.
			dbSelectArea("ZZO")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZO")+_cImei)
				While !ZZO->(EOF()) .And. xFilial("ZZO") == ZZO->ZZO_FILIAL .And. ZZO->ZZO_IMEI == _cImei
					If Alltrim(ZZO->ZZO_STATUS) $ "0/1"//Verificar com o Edson
						_lGrvZZO := .F.
					Endif
					dbSkip()
				EndDo
			Endif
			If _lGrvZZO
				dbSelectArea("ZZ4")
				dbSetOrder(1)
				If dbSeek(xFilial("ZZ4")+_cImei)
					While !ZZ4->(EOF()) .And. xFilial("ZZ4") == ZZ4->ZZ4_FILIAL .And. ZZ4->ZZ4_IMEI == _cImei
						If Alltrim(ZZ4->ZZ4_STATUS) < '9'
							_lGrvZZO := .F.
						Endif
						dbSkip()
					EndDo
				Endif
			Endif
			If _lGrvZZO
				If _nTriagem == 2 .and. _cValGar == "1"
					If Empty(_cMPrata)
						_cMPrata := GetSXENum("ZZO","ZZO_NUMCX")
						_nContMax := 1
						While _nContMax == 1
							dbSelectArea("ZZO")
							dbSetOrder(4)
							If dbSeek(xFilial("ZZO")+_cMPrata)
								_cMPrata := GetSXENum("ZZO","ZZO_NUMCX")
							Else
								_nContMax := 0
							Endif
						EndDo
						ConfirmSX8()
					Endif
					_cNumCx := _cMPrata
					_cRefGar:= "5"
				Else
					If Alltrim(_cGara) == 'S' .and. Alltrim(_cBounce) <> 'S'
						If Empty(_cMGar)
							_cMGar := GetSXENum("ZZO","ZZO_NUMCX")
							_nContMax := 1
							While _nContMax == 1
								dbSelectArea("ZZO")
								dbSetOrder(4)
								If dbSeek(xFilial("ZZO")+_cMGar)
									_cMGar := GetSXENum("ZZO","ZZO_NUMCX")
								Else
									_nContMax := 0
								Endif
							EndDo
							ConfirmSX8()
						Endif
						_cNumCx := _cMGar
						_cRefGar:= "1"
					ElseIf Alltrim(_cGara) == 'N' .and. Alltrim(_cBounce) <> 'S'
						If Empty(_cMFog)
							_cMFog := GetSXENum("ZZO","ZZO_NUMCX")
							_nContMax := 1
							While _nContMax == 1
								dbSelectArea("ZZO")
								dbSetOrder(4)
								If dbSeek(xFilial("ZZO")+_cMFog)
									_cMFog := GetSXENum("ZZO","ZZO_NUMCX")
								Else
									_nContMax := 0
								Endif
							EndDo
							ConfirmSX8()
						Endif
						_cNumCx := _cMFog
						_cRefGar:= "2"
					ElseIf Alltrim(_cBounce) == 'S'
						If Empty(_cMBou)
							_cMBou := GetSXENum("ZZO","ZZO_NUMCX")
							_nContMax := 1
							While _nContMax == 1
								dbSelectArea("ZZO")
								dbSetOrder(4)
								If dbSeek(xFilial("ZZO")+_cMBou)
									_cMBou := GetSXENum("ZZO","ZZO_NUMCX")
								Else
									_nContMax := 0
								Endif
							EndDo
							ConfirmSX8()
						Endif
						_cNumCx := _cMBou
						_cRefGar:= "4"
					Endif
				Endif
				Begin Transaction
				RecLock("ZZO",.T.)
				ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
				ZZO->ZZO_IMEI		:= _cImei
				ZZO->ZZO_CARCAC		:= _cCarca
				ZZO->ZZO_STATUS		:= '0'
				ZZO->ZZO_MODELO		:= _cModelo
				ZZO->ZZO_GARANT  	:= _cGara
				ZZO->ZZO_DTSEPA		:= dDataBase
				ZZO->ZZO_HRSEPA		:= Time()
				ZZO->ZZO_USRSEP		:= cUserName
				ZZO->ZZO_NUMCX		:= _cNumCx
				ZZO->ZZO_ORIGEM		:= _cOrigem
				ZZO->ZZO_CLIENT		:= _cCliente
				ZZO->ZZO_LOJA		:= _cLoja
				ZZO->ZZO_NF			:= _cNF
				ZZO->ZZO_SERIE		:= _cSerie
				ZZO->ZZO_PRECO		:= _nPreco
				ZZO->ZZO_DESTIN		:= "B"
				ZZO->ZZO_ENVARQ		:= "S"
				ZZO->ZZO_BOUNCE		:= _cBounce
				If _cValBou == "S"
					ZZO->ZZO_DBOUNC		:= Iif(Len(_nDBounce) >0, Transform(_nDBounce, "@E 999"),000)
					ZZO->ZZO_OPBOUN		:= Substr(_cOperBou,1,3)
				Endif
				ZZO->ZZO_OPERA		:= IIF(SUBSTR(_cOpeBGH,1,1)=="N",IIF(Alltrim(_cGara)=='S' .and. Alltrim(_cBounce) <> 'S',"N08","N01"),_cOpeBGH)//IIF(Alltrim(_cGara)=='S' .and. Alltrim(_cBounce) <> 'S' .and. Alltrim(_cOpeBGH) == "N01","N08",_cOpeBGH)
				ZZO->ZZO_REFGAR		:= _cRefGar
				MsUnlock()
				End Transaction
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//|Alimenta o acols e cria TM    |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				MsAguarde({|| ADDACOLS("IMEI",nOpcao) })
			Else
				MsgAlert("Triagem do IMEI "+Alltrim(_cImei)+" efetuada anteriormente.")
			Endif
		Endif
	Endif
	_cImei	    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
	_cCarca		    := space(25)
	_lRet			:= .T.
	oGetCar:SetFocus()
	
Endif

If _nQtMPra == _nQMaxGar
	Processa({|| GeMaster("PRA",nOpcao) },"Processando Master PRATA...")
Endif

If _nQtMGar == _nQMaxGar
	Processa({|| GeMaster("GAR",nOpcao) },"Processando Master GAR...")
Endif

If _nQtMFog == _nQMaxFog
	Processa({|| GeMaster("FOG",nOpcao) },"Processando Master FOG...")
Endif

If _nQtMBou == _nQMaxBou
	Processa({|| GeMaster("BOU",nOpcao) },"Processando Master BOU...")
Endif

Return(_lRet)



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

Static Function ValidZZ4(_cTela,nOpcao)

Local _lRet := .T.

//Nใo autoriza o usuario alterar o Modelo
If !Empty(_cModelo).and. _cTela == "MOD"
	If Empty(_cModOri)
		_cModOri := _cModelo
		MsAguarde({|| ADDACOLS("MOD",nOpcao) })
	ElseIf !Empty(_cModOri) .and. _cModOri <> _cModelo
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][2])//IMEI
			MsgAlert("Nใo ้ possivel alterar o Modelo.")
			_cModelo := _cModOri
			_cDesMod := Posicione("SB1",1,xFilial("SB1")+_cModelo,"B1_DESC")
		Else
			_cModOri := _cModelo
		Endif
	Endif
Endif

//Valida Carca็a e IMEI
If _cTela == "IME"
	If Empty(_cImei) .and. _lRet
		_lRet := .F.
	ElseIf Len(AllTrim(_cImei)) <> 15
		MsgAlert("Equipamento com Erro no Imei, Favor Inserir Novamente!")
		_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
		_lRet := .F.
	ElseIf !empty(_cImei) .and. _lRet
		If nOpcao == 2
			dbSelectArea("ZZ4")
			dbSetOrder(4)
			If !dbSeek(xFilial("ZZ4")+_cImei+"3")
				dbSelectArea("ZZ4")
				dbSetOrder(4)
				If !dbSeek(xFilial("ZZ4")+_cImei+"4")
					MsgAlert("Equipamento nใo localizado com status 3-Estoque. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Else
					If ZZ4->ZZ4_LOCAL <> "18"
						MsgAlert("Equipamento nใo encontra-se no armazem 18. Favor verificar!")
						_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
						_lRet := .F.
					Endif
					
					If Alltrim(ZZ4->ZZ4_OPEBGH) <> "N11"
						MsgAlert("Equipamento nใo encontra-se na opera็ใo N11. Favor verificar!")
						_cImei	:= Space(20)
						_lRet := .F.
					Endif
				Endif
			Endif
			If _lRet
				If !EMPTY(ZZ4->ZZ4_ETQMEM)
					If Alltrim(ZZ4->ZZ4_CODCLI) == "Z00403" //CLIENTE BGH
						Begin Transaction
						RecLock("ZZ4",.F.)
						ZZ4->ZZ4_ETQMEM		:= ""
						MsUnlock()
						End Transaction
					Else
						MsgAlert("Equipamento ja possui master. Favor verificar!")
						_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
						_lRet := .F.
					Endif
				Endif
				
				If ZZ4->ZZ4_LOCAL <> "18" .and. _lRet
					MsgAlert("Equipamento nใo encontra-se no armazem 18. Favor verificar!")
					_cImei	:= Space(20)
					_lRet := .F.
				Endif
				
				If Alltrim(ZZ4->ZZ4_OPEBGH) <> "N11" .and. _lRet
					MsgAlert("Equipamento nใo encontra-se na opera็ใo N11. Favor verificar!")
					_cImei	:= Space(20)
					_lRet := .F.
				Endif
				
				If Empty(_cModelo) .and. _lRet
					_cModelo := ZZ4->ZZ4_CODPRO
				ElseIf _lRet .and. !Alltrim(_cModelo) == Alltrim(ZZ4->ZZ4_CODPRO)
					MsgAlert("Modelo do Equipamento divergente do Modelo informado no primeiro registro. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Endif
				
				If Empty(_cOpeBgh) .and. _lRet
					_cOpeBgh := ZZ4->ZZ4_OPEBGH
				ElseIf _lRet .and. !Empty(_cOpeBgh) .and. _cOpeBgh <> ZZ4->ZZ4_OPEBGH
					MsgAlert("Opera็ใo do Equipamento divergente da Opera็ใo informada no primeiro registro. Favor verificar!")
					_cImei	:= Space(20)
					_lRet := .F.
				Endif
			Endif
		ElseIf nOpcao==3
			dbSelectArea("ZZ4")
			dbSetOrder(4)
			If !dbSeek(xFilial("ZZ4")+_cImei+"4")
				MsgAlert("Equipamento nใo localizado em poder da produ็ใo (status 4). Favor verificar!")
				_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
				_lRet := .F.
			Endif
			
			/*
			dbSelectArea("SZ9")
			dbSetOrder(2)
			If dbSeek(xFilial("SZ9")+ZZ4->(ZZ4_IMEI+ZZ4_OS))
				While SZ9->(!Eof()) .AND. SZ9->(Z9_FILIAL+Z9_IMEI+Z9_NUMOS) == xFilial("SZ9")+ZZ4->(ZZ4_IMEI+ZZ4_OS)
					If !EMPTY(SZ9->Z9_PARTNR)
						MsgAlert("IMEI possui pe็a(s) apontada(s). Favor verificar!")
						_cImei	:= Space(20)
						_lRet := .F.
						Exit
					Endif
					SZ9->(dbSkip())
				EndDo
			Endif
			*/
			If _lRet
				dbSelectArea("ZA5")
				ZA5->(dbSetOrder(3))
				If ZA5->(dbSeek(xFilial("ZA5")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS  ))
					If ZA5->ZA5_STATUS <> "5"
						MsgAlert("IMEI encontra-se no processo de KIT/Caixa: "+ALLTRIM(ZA5->ZA5_CAIXA)+". Favor veriicar!")
						_cImei	:= Space(20)
						_lRet := .F.
					Endif
				Endif
			Endif
			
			If _lRet
				If Empty(_cModelo) .and. _lRet
					_cModelo := ZZ4->ZZ4_CODPRO
				ElseIf _lRet .and. !Alltrim(_cModelo) == Alltrim(ZZ4->ZZ4_CODPRO)
					MsgAlert("Modelo do Equipamento divergente do Modelo informado no primeiro registro. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Endif
				
				If Empty(_cOpeBgh) .and. _lRet
					_cOpeBgh := ZZ4->ZZ4_OPEBGH
				ElseIf _lRet .and. !Empty(_cOpeBgh) .and. _cOpeBgh <> ZZ4->ZZ4_OPEBGH
					MsgAlert("Opera็ใo do Equipamento divergente da Opera็ใo informada no primeiro registro. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Endif
				
				If Empty(_cCliOri) .and. _lRet
					_cCliOri := ZZ4->ZZ4_CODCLI
					_cLojOri := ZZ4->ZZ4_LOJA
				ElseIf !Empty(_cCliOri) .and. _cCliOri+_cLojOri <> ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA .and. _lRet
					MsgAlert("Cliente divergente. Favor verificar!")
					_cImei	:= space(TamSX3("ZZ4_IMEI")[1])//Space(20)
					_lRet := .F.
				Endif
			Endif
			
		Endif
		If _lRet
			If Alltrim(ZZ4->ZZ4_GARANT) == 'S' .and. (ZZ4->ZZ4_BOUNCE == 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
				_cMensag := "GARANTIA"
			ElseIf Alltrim(ZZ4->ZZ4_GARANT) == 'N' .and. (ZZ4->ZZ4_BOUNCE == 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
				_cMensag := "FORA GARANTIA"
			ElseIf ZZ4->ZZ4_BOUNCE > 0 .AND. ZZ4->ZZ4_BOUNCE <= 90
				_cMensag := "BOUNCE"
			Endif
			_lGrvZZO := .T.
			dbSelectArea("ZZO")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZO")+ZZ4->ZZ4_IMEI)
				While !ZZO->(EOF()) .And. xFilial("ZZO") == ZZO->ZZO_FILIAL .And. ZZO->ZZO_IMEI == ZZ4->ZZ4_IMEI
					If Alltrim(ZZO->ZZO_STATUS) $ "0/1"//Verificar com o Edson
						_lGrvZZO := .F.
					Endif
					dbSkip()
				EndDo
			Endif
			If _lGrvZZO
				If Alltrim(ZZ4->ZZ4_GARANT) == 'S' .and. (ZZ4->ZZ4_BOUNCE == 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
					If Empty(_cMGar)
						_cMGar := GetSXENum("ZZO","ZZO_NUMCX")
						_nContMax := 1
						While _nContMax == 1
							dbSelectArea("ZZO")
							dbSetOrder(4)
							If dbSeek(xFilial("ZZO")+_cMGar)
								_cMGar := GetSXENum("ZZO","ZZO_NUMCX")
							Else
								_nContMax := 0
							Endif
						EndDo
						ConfirmSX8()
					Endif
					_cNumCx := _cMGar
					_cRefGar:= "1"
				ElseIf Alltrim(ZZ4->ZZ4_GARANT) == 'N' .and. (ZZ4->ZZ4_BOUNCE == 0 .OR. ZZ4->ZZ4_BOUNCE > 90)
					If Empty(_cMFog)
						_cMFog := GetSXENum("ZZO","ZZO_NUMCX")
						_nContMax := 1
						While _nContMax == 1
							dbSelectArea("ZZO")
							dbSetOrder(4)
							If dbSeek(xFilial("ZZO")+_cMFog)
								_cMFog := GetSXENum("ZZO","ZZO_NUMCX")
							Else
								_nContMax := 0
							Endif
						EndDo
						ConfirmSX8()
					Endif
					_cNumCx := _cMFog
					_cRefGar:= "2"
				ElseIf ZZ4->ZZ4_BOUNCE > 0 .AND. ZZ4->ZZ4_BOUNCE <= 90
					If Empty(_cMBou)
						_cMBou := GetSXENum("ZZO","ZZO_NUMCX")
						_nContMax := 1
						While _nContMax == 1
							dbSelectArea("ZZO")
							dbSetOrder(4)
							If dbSeek(xFilial("ZZO")+_cMBou)
								_cMBou := GetSXENum("ZZO","ZZO_NUMCX")
							Else
								_nContMax := 0
							Endif
						EndDo
						ConfirmSX8()
					Endif
					_cNumCx := _cMBou
					_cRefGar:= "4"
				Endif
				
				_cCarca		:= ZZ4->ZZ4_CARCAC
				_cGara		:= ZZ4->ZZ4_GARANT
				_cCliente	:= ZZ4->ZZ4_CODCLI
				_cLoja		:= ZZ4->ZZ4_LOJA
				_cNF		:= ZZ4->ZZ4_NFENR
				_cSerie		:= ZZ4->ZZ4_NFESER
				_nPreco		:= ZZ4->ZZ4_VLRUNI
				_cBounce	:= IIF(ZZ4->ZZ4_BOUNCE > 0 .AND. ZZ4->ZZ4_BOUNCE <= 90,"S","N")
				_nDBounce	:= Alltrim(Str(ZZ4->ZZ4_BOUNCE))
				_cOpera		:= ZZ4->ZZ4_OPEBGH
				
				
				Begin Transaction
				RecLock("ZZO",.T.)
				ZZO->ZZO_FILIAL 	:= xFilial("ZZO")
				ZZO->ZZO_IMEI		:= _cImei
				ZZO->ZZO_CARCAC		:= _cCarca
				ZZO->ZZO_STATUS		:= '0'
				ZZO->ZZO_MODELO		:= _cModelo
				ZZO->ZZO_GARANT  	:= _cGara
				ZZO->ZZO_DTSEPA		:= dDataBase
				ZZO->ZZO_HRSEPA		:= Time()
				ZZO->ZZO_USRSEP		:= cUserName
				ZZO->ZZO_NUMCX		:= _cNumCx
				ZZO->ZZO_ORIGEM		:= _cOrigem
				ZZO->ZZO_CLIENT		:= _cCliente
				ZZO->ZZO_LOJA		:= _cLoja
				ZZO->ZZO_NF			:= _cNF
				ZZO->ZZO_SERIE		:= _cSerie
				ZZO->ZZO_PRECO		:= _nPreco
				ZZO->ZZO_DESTIN		:= "B"
				ZZO->ZZO_ENVARQ		:= "S"
				ZZO->ZZO_BOUNCE		:= _cBounce
				ZZO->ZZO_DBOUNC		:= _nDBounce
				ZZO->ZZO_OPBOUN		:= ""
				ZZO->ZZO_OPERA		:= _cOpera
				ZZO->ZZO_ORIGEM		:= IIF(nOpcao==2,"ZZ4","DEV")
				ZZO->ZZO_REFGAR		:= _cRefGar
				ZZO->ZZO_MOTIVO		:= _cMotivo
				MsUnlock()
				End Transaction
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//|Alimenta o acols e cria TM    |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				MsAguarde({|| ADDACOLS("IMEI",nOpcao) })
			Else
				MsgAlert("Triagem do IMEI "+Alltrim(_cImei)+" efetuada anteriormente.")
			Endif
		Endif
	Endif
	_cImei	    	:= space(TamSX3("ZZ4_IMEI")[1])//space(20)
	_cCarca		    := space(25)
	_lRet			:= .T.
	oGetIme:SetFocus()
	
Endif

If _nQtMGar == _nQMaxGar
	Processa({|| GeMaster("GAR",nOpcao) },"Processando Master GAR...")
Endif

If _nQtMFog == _nQMaxFog
	Processa({|| GeMaster("FOG",nOpcao) },"Processando Master FOG...")
Endif

If _nQtMBou == _nQMaxBou
	Processa({|| GeMaster("BOU",nOpcao) },"Processando Master BOU...")
Endif

Return(_lRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGarantia  บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula Grantia pela Carcaca                                บฑฑ
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

Static Function Garantia()

Local cQry

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula Garantia Pela Carcaca com Data Base                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQry	:= " SELECT DATEDIFF(MONTH, (SELECT RTRIM(X5_DESCRI) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WC' AND SUBSTRING(RTRIM('"+AllTrim(_cCarca)+"'),5,1) = X5_CHAVE) +	(SELECT LEFT(X5_DESCRI,2) FROM SX5020 WHERE X5_FILIAL = '' AND D_E_L_E_T_ = '' AND X5_TABELA = 'WD' AND SUBSTRING(RTRIM('"+AllTrim(_cCarca)+"'),6,1) = X5_CHAVE)+ '01' ,(SELECT GETDATE())) MES_GARA "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

If QRY->MES_GARA <= 14 //.And. Len(AllTrim(cRecl)) > 0 - Verificar com Edson
	_cGara := 'S'
Else
	_cGara := 'N'
EndIf

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

Return(_cGara)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBounce    บAutor  ณPaulo Francisco     บ Data ณ25/07/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณConculta Bounce Pela ultima saida BGH                       บฑฑ
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

Static Function CalBounce()

Local cQry1

#IFDEF TOP
	Local 	cZ4Temp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	cZMTemp		:= GetNextAlias()											// Pega o proximo Alias Disponivel
	Local 	_lQuery    	:= .F.
	Local  	_cQuery		:= .F.
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Consulta Ultima Entrada para Calculo Bounce                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

#IFDEF TOP
	
	_lQuery  := .T.
	BeginSql alias cZ4Temp
		SELECT TOP 1 ZZ4_NFSDT AS DTNFS, ZZ4_OPEBGH AS OPERA, ZZJ_DESCRI AS DESCRI
		FROM %table:ZZ4% ZZ4
		JOIN %table:ZZJ% ZZJ ON
		ZZJ.ZZJ_FILIAL = %xfilial:ZZJ% 				AND
		ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA				AND
		ZZJ.%notDel%
		WHERE   ZZ4.ZZ4_FILIAL = %xfilial:ZZ4% 		AND
		ZZ4.ZZ4_IMEI = 	%exp: _cImei%  	AND
		ZZ4.%notDel%
		ORDER BY ZZ4.ZZ4_NFSDT DESC
	EndSql
	
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula Periodo da Ultima Entrada com Data Base                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

cQry1	:=	" SELECT DATEDIFF(DAY, '"+(cZ4Temp)->DTNFS+"' ,'"+AllTrim(DtoS(dDatabase))+"') AS BOUNCE "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry1), "QRY1", .F., .T.)

If QRY1->BOUNCE <= 120
	_cBounce 	:= 'S'
Else
	_cBounce 	:= 'N'
EndIf

_nDBounce		:= StrZero(QRY1->BOUNCE,3)
_cOperBou		:= (cZ4Temp)->OPERA + ' - ' + (cZ4Temp)->DESCRI

If Select("QRY1") > 0
	QRY1->(dbCloseArea())
EndIf

If _lQuery
	(cZ4Temp)->( DbCloseArea())
Endif

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeMaster  บAutor  ณLuciano Siqueira    บ Data ณ  08/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizar status dos IMEI's na tabela ZZO                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeMaster(_cMaster,nOpcao)

Local _cStatus := ""
Local _cStaBou := ""
Local _lRet	   := .T.

If Alltrim(_cMaster) == "GAR"
	_cStatus := "S"
Endif

If Alltrim(_cMaster) == "FOG"
	_cStatus := "N"
Endif

If Alltrim(_cMaster) == "BOU"
	_cStaBou := "S"
Endif

For nx:=1 to Len(oGetDadM1:aCols)
	_lRet := .T.
	If Alltrim(oGetDadM1:aCols[nx][10]) == "0" .and.;
		Iif(_nTriagem==2 .and. _cValGar == "1",.T.,IIF(empty(_cStaBou),Alltrim(oGetDadM1:aCols[nx][5])==_cStatus .and. Alltrim(oGetDadM1:aCols[nx][6])=="N",;
		Alltrim(oGetDadM1:aCols[nx][6])==_cStaBou))
		dbSelectArea("ZZO")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZO")+oGetDadM1:aCols[nx][2]+oGetDadM1:aCols[nx][3]+oGetDadM1:aCols[nx][10])
			If Alltrim(ZZO->ZZO_NUMCX)==Alltrim(oGetDadM1:aCols[nx][11])
				If nOpcao == 1
					Begin Transaction
					RecLock("ZZO",.F.)
					ZZO->ZZO_DTDEST		:= dDataBase
					ZZO->ZZO_HRDEST		:= Time()
					ZZO->ZZO_USRDES		:= cUserName
					ZZO->ZZO_STATUS		:= '1'
					MsUnlock()
					End Transaction
					
					oGetDadM1:aCols[nx][10] := '1'
					oGetDadM1:aCols[nx][1] := "BR_AZUL"
					
				ElseIf nOpcao == 2
					dbSelectArea("ZZ4")
					dbSetOrder(4)
					If !dbSeek(xFilial("ZZ4")+oGetDadM1:aCols[nx][2]+"3")
						dbSelectArea("ZZ4")
						dbSetOrder(4)
						If !dbSeek(xFilial("ZZ4")+oGetDadM1:aCols[nx][2]+"4")
							MsgAlert("IMEI "+Alltrim(oGetDadM1:aCols[nx][2])+" nao encontrado na tabela ZZ4.")
							_lRet := .F.
						Else
							If ZZ4->ZZ4_LOCAL <> "18"
								MsgAlert("IMEI "+Alltrim(oGetDadM1:aCols[nx][2])+" nao encontra-se no armazem 18.")
								_lRet := .F.
							Endif
						Endif
					Endif
					If _lRet
						If Empty(ZZ4->ZZ4_ETQMEM)
							Begin Transaction
							RecLock("ZZ4",.F.)
							ZZ4->ZZ4_ETQMEM		:= oGetDadM1:aCols[nx][11]
							MsUnlock()
							End Transaction
							
							Begin Transaction
							RecLock("ZZO",.F.)
							ZZO->ZZO_DTDEST		:= dDataBase
							ZZO->ZZO_HRDEST		:= Time()
							ZZO->ZZO_USRDES		:= cUserName
							ZZO->ZZO_STATUS		:= '2'
							MsUnlock()
							End Transaction
							
							oGetDadM1:aCols[nx][10] := '1'
							oGetDadM1:aCols[nx][1] := "BR_AZUL"
						Else
							MsgAlert("IMEI "+Alltrim(oGetDadM1:aCols[nx][2])+" ja possui Etiqueta Master "+ZZ4->ZZ4_ETQMEM)
						Endif
					Endif
				ElseIf nOpcao == 3
					dbSelectArea("ZZ4")
					dbSetOrder(4)
					If !dbSeek(xFilial("ZZ4")+oGetDadM1:aCols[nx][2]+"4")
						MsgAlert("IMEI "+Alltrim(oGetDadM1:aCols[nx][2])+" nao encontrado em poder da produ็ใo. Favor verificar!")
						_lRet := .F.
					Endif
					If _lRet
						Begin Transaction
						dbSelectArea("ZZ3")
						dbSetOrder(1)
						If dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS)
							While ZZ3->(!Eof()) .AND. ZZ3->(ZZ3_FILIAL+ZZ3_IMEI+ZZ3_NUMOS) == xFilial("ZZ3")+ZZ4->(ZZ4_IMEI+ZZ4_OS)
								
								If ZZ3->ZZ3_ESTORN <> "S"
									nRegZZ3 	  := ZZ3->(recno())
									lAchPN		  := .F.	
									_cNumOS       := ZZ3->ZZ3_NUMOS
									_cCodTec      := ZZ3->ZZ3_CODTEC
									_cLab         := ZZ3->ZZ3_LAB
									_cSetor       := ZZ3->ZZ3_CODSET
									_cSetor2      := ZZ3->ZZ3_CODSE2
									_cCodFase1    := ZZ3->ZZ3_FASE1
									_cCodFase2    := ZZ3->ZZ3_FASE2
									_cSeq         := ZZ3->ZZ3_SEQ
													
									RecLock("ZZ3",.T.)
									ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
									ZZ3->ZZ3_CODTEC := _cCodTec
									ZZ3->ZZ3_LAB    := _cLab
									ZZ3->ZZ3_DATA   := date()
									ZZ3->ZZ3_HORA   := Time()
									ZZ3->ZZ3_CODSET := _cSetor2
									ZZ3->ZZ3_FASE1  := _cCodFase2
									ZZ3->ZZ3_CODSE2 := _cSetor
									ZZ3->ZZ3_FASE2  := _cCodFase1
									ZZ3->ZZ3_ENCOS  := "N"
									ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
									ZZ3->ZZ3_SWAP   := ""
									ZZ3->ZZ3_IMEISW := ""
									ZZ3->ZZ3_MODSW  := ""
									ZZ3->ZZ3_UPGRAD := ""
									ZZ3->ZZ3_NUMOS  := _cNumOS
									ZZ3->ZZ3_STATUS := "1"
									ZZ3->ZZ3_SEQ    := u_CalcSeq(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)//SOMA1(_cSeq)
									ZZ3->ZZ3_USER   := cUserName
									ZZ3->ZZ3_ACAO   := ""
									ZZ3->ZZ3_LAUDO  := ""
									ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
									ZZ3->ZZ3_ESTORN := "S"
									ZZ3->ZZ3_STATRA := "0"
									ZZ3->ZZ3_ASCRAP :=getadvfval("ZZ1","ZZ1_SCRAP",xFilial("ZZ1") + _cLab + AllTrim(_cSetor2) + _cCodFase2, 1, "N") 
									ZZ3->ZZ3_DEVEST := DTOC(date())+" - "+Alltrim(time())+" - "+Alltrim(cUserName)
									
									MsUnlock()								
									
									ZZ3->(dbGoTo(nRegZZ3))
									RecLock("ZZ3",.F.)
									ZZ3->ZZ3_ESTORN := "S"
									ZZ3->ZZ3_STATRA := "0"
									ZZ3->ZZ3_DEVEST := DTOC(date())+" - "+Alltrim(time())+" - "+Alltrim(cUserName)
									MsUnlock()
																											
									dbSelectArea("SZ9")
									SZ9->(dbsetorder(1))
									If SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
										While SZ9->(!eof()) .AND. SZ9->Z9_FILIAL == xFilial("SZ9") .AND. ;
											SZ9->Z9_NUMOS == ZZ3->ZZ3_NUMOS .AND. SZ9->Z9_CODTEC == ZZ3->ZZ3_CODTEC .AND. SZ9->Z9_SEQ == ZZ3->ZZ3_SEQ
											If !Empty(SZ9->Z9_PARTNR)
												lAchPN := .T.
												Exit
											Endif												
											SZ9->(dbSkip())
										EndDo
									Endif
									
									If !lAchPN
										dbSelectArea("SZ9")
										SZ9->(dbsetorder(1))
										If SZ9->(dbSeek(xFilial("SZ9") + ZZ3->ZZ3_NUMOS + ZZ3->ZZ3_CODTEC + ZZ3->ZZ3_SEQ))
											While SZ9->(!eof()) .AND. SZ9->Z9_FILIAL == xFilial("SZ9") .AND. ;
												SZ9->Z9_NUMOS == ZZ3->ZZ3_NUMOS .AND. SZ9->Z9_CODTEC == ZZ3->ZZ3_CODTEC .AND. SZ9->Z9_SEQ == ZZ3->ZZ3_SEQ
												If Empty(SZ9->Z9_PARTNR)
													dbSelectArea("SZ9")
													RecLock("SZ9",.F.)
													dbDelete()
													MsUnlock()
												Endif
												SZ9->(dbSkip())
											EndDo
										Endif
									Endif									
								Endif
								ZZ3->(dbSkip())
							EndDo
						Endif
												
						If !Empty(ZZ4->ZZ4_DOCSEP) .AND. !Empty(ZZ4->ZZ4_ETQMEM)
							dbSelectArea("ZZY")
							dbSetOrder(3)
							If dbSeek(xFilial("ZZY")+ZZ4->ZZ4_DOCSEP+ZZ4->ZZ4_ETQMEM)
								ZZ4->(RecLock("ZZY",.F.))
								ZZY->ZZY_QTDDEV	+= 1
								ZZ4->(MsUnlock())
							Endif
						Endif
						ZZ4->(RecLock("ZZ4",.F.))
						ZZ4->ZZ4_ETMEAN	:= ZZ4->ZZ4_ETQMEM
						ZZ4->ZZ4_DSEPAN	:= ZZ4->ZZ4_DOCSEP
						ZZ4->ZZ4_ETQMEM	:= oGetDadM1:aCols[nx][11]
						ZZ4->ZZ4_STATUS := "3"
						ZZ4->ZZ4_DOCSEP := ""
						ZZ4->ZZ4_ENDES	:= ""
						ZZ4->ZZ4_FIFO	:= ""
						ZZ4->ZZ4_SETATU := ""
						ZZ4->ZZ4_FASATU := ""
						ZZ4->(MsUnlock())
						
						RecLock("ZZO",.F.)
						ZZO->ZZO_DTDEST		:= dDataBase
						ZZO->ZZO_HRDEST		:= Time()
						ZZO->ZZO_USRDES		:= cUserName
						ZZO->ZZO_STATUS		:= '2'
						MsUnlock()
						
						End Transaction
						
						oGetDadM1:aCols[nx][10] := '1'
						oGetDadM1:aCols[nx][1] := "BR_AZUL"
						
					Endif
				Endif
			Endif
		Endif
	Endif
Next nx

If _nTriagem == 2 .and. _cValGar == "1"
	Processa({|| U_BHETQMAS(_cMPrata) },"Imprimindo Etiqueta...")
	_nQtMPra	:= 0
	_cMPrata	:= space(20)
Else
	If _cMaster == "GAR"
		Processa({|| U_BHETQMAS(_cMGar) },"Imprimindo Etiqueta...")
		_nQtMGar	:= 0
		_cMGar		:= space(20)
		If _cValGar <> "2"
			oSayGar:Refresh()
		Endif
	ElseIf _cMaster == "FOG"
		Processa({|| U_BHETQMAS(_cMFog) },"Imprimindo Etiqueta...")
		_nQtMFog	:= 0
		_cMFog		:= space(20)
		If _cValGar <> "2"
			oSayFog:Refresh()
		Endif
	ElseIf _cMaster == "BOU"
		Processa({|| U_BHETQMAS(_cMBou) },"Imprimindo Etiqueta...")
		_nQtMBou	:= 0
		_cMBou		:= space(20)
		If _cValGar <> "2"
			oSayBou:Refresh()
		Endif
	Endif
Endif

If _cValGar == "1" .and. (_nTriagem == 2 .OR. _nTriagem == 3 .OR. _nTriagem == 4)
	If ApMsgYesNo('Deseja alterar modelo de Triagem?','Alterar Modelo')
		_cModOri := space(15)
		_cModelo := space(15)
		_cDesMod := space(50)
		_nPrOri  := 0
		_nPreco  := 0
		oGetPre:SetFocus()
	Endif
Endif

oGetDadM1:Refresh()


Return

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

Static Function GRAVAZZO(nOpcao)


Local aArea     := GetArea()
Local oDlgMas
Local cTitulo	:= "Gera Etiqueta Master"
Local lMark		:= .T.
Local oOk      	:= LoadBitmap( GetResources(), "CHECKED" )
Local oNo      	:= LoadBitmap( GetResources(), "UNCHECKED" )
Local nOpcA		:= 0

Private oLbx
Private aVetor := {}

If _cValGar == "1" .and. (_nTriagem == 2 .OR. _nTriagem == 3 .OR. _nTriagem == 4)
	If _nTriagem == 2
		_cEtqMas := "PRA"
		_cNumMas := _cMPrata
		_nQtdEtq := _nQtMPra
	ElseIf _nTriagem == 3
		_cEtqMas := "GAR"
		_cNumMas := _cMGar
		_nQtdEtq := _nQtMGar
	Else
		_cEtqMas := "FOG"
		_cNumMas := _cMFog
		_nQtdEtq := _nQtMFog
	Endif
	If !Empty(_cNumMas)
		aAdd( aVetor, {.F.,_cEtqMas,Strzero(_nQtdEtq,3),_cNumMas})
	Endif
Else
	For x:=1 to 3
		_cNumMas := space(20)
		_nQtdEtq := 0
		Do Case
			Case x == 1
				_cEtqMas := "GAR"
				_cNumMas := _cMGar
				_nQtdEtq := _nQtMGar
			Case x == 2
				_cEtqMas := "FOG"
				_cNumMas := _cMFog
				_nQtdEtq := _nQtMFog
			Case x == 3
				_cEtqMas := "BOU"
				_cNumMas := _cMBou
				_nQtdEtq := _nQtMBou
		EndCase
		If !Empty(_cNumMas)
			aAdd( aVetor, {.F.,_cEtqMas,Strzero(_nQtdEtq,3),_cNumMas})
		Endif
	Next x
Endif

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existe Master a consultar", {"Ok"} )
	Return
Endif

DEFINE MSDIALOG oDlgMas TITLE cTitulo FROM 0,0 TO 200,600 PIXEL

@ 15,10 LISTBOX oLbx FIELDS HEADER ;
" ", "Opera็ใo", "Qtde IMEI's"," Num Master";
SIZE 300-30,100-20 OF oDlgMas PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4]}}

ACTIVATE MSDIALOG oDlgMas ON INIT EnchoiceBar(oDlgMas,{||nOpcA:=1,oDlgMas:End()},{||oDlgMas:End()})

If nOpcA==1
	For i:= 1 to len(aVetor)
		If aVetor[i][1] == .T.
			Processa({|| GeMaster(aVetor[i][2],nOpcao) },"Processando Master "+aVetor[i][2])
		Endif
	Next i
Endif

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegend    บ Autor ณLuciano Siqueira    บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLegenda                                                     บฑฑ
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

Static Function Legend()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Legenda                                                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCorLeg := {{"BR_MARRON"     	, "Garantia" },;
{"BR_VERDE"		, "Fora Garantia"	},;
{"BR_VERMELHO"	, "Bounce"	},;
{"BR_BRANCO"	, "Prata"	},;
{"BR_AZUL"		, "Master Finalizada"	}}

BrwLegenda("Legenda", "Legenda", aCorLeg )


Return ( .T. )

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
PutSx1(cPerg, '02', 'Triagem     ?','' ,'' , 'mv_ch2', 'N', 01, 0,01 ,'C', '',   '' , '', '', 'mv_par02',"Padrao","","","","Prata","","","Garantia","","","Fora Garantia","","")

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

Static Function ValPerg2(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Motivo    ?','' ,'' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'WG', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenZZO  บ Autor ณLuciano Siqueira    บ Data ณ  30/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLegenda                                                     บฑฑ
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

User Function LegenZZO()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Legenda                                                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCorDesc := {{"ENABLE"     	, "Triagem Efetuada" },;
{"BR_AZUL"		, "Separacao Efetuada"	},;
{"BR_PINK"		, "Entrada Massiva BGH" },;
{"BR_CANCEL"	, "Rotina Master Estoque BGH" },;
{"DISABLE"		, "Equipamento Segregado"	}}

BrwLegenda(cCadastro, "Status", aCorDesc )


Return ( .T. )


User Function BGHENTMA()

Local _aArea := GetArea()


Private cPerg		:= "BGHTRIAG"
Private _cOpeBGH	:= ""

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

_cOpeBGH	:= MV_PAR01

Processa({|| U_TECAX011("BGHTRIAG"+_cOpeBGH) },"Processando Entrada Massiva ")

RestArea(_aArea)

Return

User Function BGHEXZZO(_nOpcao)

Local _aAreaZZO := GetArea()
Local _cNuMaster := ""
Local _lExcZZO  := .T.

If _nOpcao == 1
	If ApMsgYesNo('Deseja excluir o IMEI '+Alltrim(ZZO_IMEI)+'?','Excluir IMEI')
		If !Alltrim(ZZO_STATUS) $ "0/1/S"//Em processo de Triagem
			_lExcZZO  := .F.
		Endif
		If _lExcZZO
			dbSelectArea("ZZO")
			Reclock("ZZO",.f.)
			ZZO->(dbdelete())
			Msunlock()
		Else
			MsgAlert("Nใo ้ possivel excluir o IMEI "+Alltrim(ZZO_IMEI)+". Favor verificar com o responsavel!")
		Endif
	Endif
Else
	If ApMsgYesNo('Deseja excluir a Master '+Alltrim(ZZO_NUMCX)+'?','Excluir Master')
		_cNuMaster := ZZO_NUMCX
		dbSelectArea("ZZO")
		dbGoTop()
		dbSetOrder(4)
		If dbSeek(xFilial("ZZO")+_cNuMaster)
			While ZZO->(!EOF()) .and. ZZO->(ZZO_FILIAL+ZZO_NUMCX)==xFilial("ZZO")+_cNuMaster
				If !Alltrim(ZZO_STATUS) $ "0/1/S"
					_lExcZZO  := .F.
					Exit
				Endif
				ZZO->(dbSkip())
			EndDo
		Endif
		If _lExcZZO
			Processa({|| ExcMaster(_cNuMaster) },"Excluindo Master "+Alltrim(_cNuMaster))
		Else
			MsgAlert("Nใo ้ possivel excluir a Master "+Alltrim(_cNuMaster)+". Favor verificar com o responsavel!")
		Endif
	Endif
Endif

RestArea(_aAreaZZO)

Return

Static Function ExcMaster(_cNuMaster)

dbSelectArea("ZZO")
dbGoTop()
dbSetOrder(4)
If dbSeek(xFilial("ZZO")+_cNuMaster)
	While ZZO->(!EOF()) .and. ZZO->(ZZO_FILIAL+ZZO_NUMCX)==xFilial("ZZO")+_cNuMaster
		Reclock("ZZO",.f.)
		ZZO->(dbdelete())
		Msunlock()
		ZZO->(dbSkip())
	EndDo
Endif

Return
