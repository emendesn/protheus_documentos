#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONEXLAB  บAutor  ณLuciano Siqueira    บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia Expedi็ใo X Laboratorio                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CONEXLAB()

Private cCadastro := "Conferencia LAB x EXP"
Private aCores    := {}

Private aRotina := {}

Private lUsrAut  	:= .F.
Private aGrupos  	:= aClone(UsrRetGRP())

aAdd(aRotina, {"Pesquisar","AxPesqui",0,1})
aAdd(aRotina, {"Visualizar","AxVisual",0,2})
aAdd(aRotina, {"Conferencia","U_CONEXLA1()",0,3,, .f.})
aAdd(aRotina, {"Legenda"         ,'U_LegenZB1()',0,6,,})



aAdd(aCores, {"ZB1_CONF == '1'"      							                 , "ENABLE"    	})    // LAB NAO EXP
aAdd(aCores, {"ZB1_CONF == '2'"  							                     , "DISABLE"	})    // LAB E EXP
aAdd(aCores, {"ZB1_CONF == '3'" 												 , "BR_AZUL"   	})    // EXP E NAO LAB


dbSelectArea("ZB1")
dbSetOrder(1)

MBrowse( 6,1,22,75, "ZB1",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONEXLAB  บAutor  ณLuciano Siqueira    บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia Expedi็ใo X Laboratorio                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CONEXLA1()

Private _cPerg	:= "CONEXLAB"

ValPerg(_cPerg)
If !Pergunte(_cPerg,.T.)
	Return
Endif

cOpera := MV_PAR01
cTurno := Alltrim(str(MV_PAR02))
dData  := MV_PAR03

VisuItens()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISUITENSบAutor  ณLuciano Siqueira     บ Data ณ  04/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza itens para conferencia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VISUITENS()

Local aPosObj    	:= {}
Local aObjects   	:= {}
Local aSize      	:= MsAdvSize()
Local cLinOK     	:= "AllwaysTrue"
Local cTudoOK       := "AllwaysTrue"
Local aButtons    	:= {}

Private aColsM1    	:= {}
Private aHeadM1 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados

Private nFreeze 	:= 0
Private cAliaM1     := "TRB"
Private oGetDadM1 := Nil
Private oDlgConf := Nil
Private nQtdOri := 0
Private nQtdDes := 0

Private _cImei	    	:= Space(TamSX3("ZZ4_IMEI")[1])//space(20)

oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito


// Cracao dos arquivos de Trabalho
MsAguarde({|| FCRIATRB() })

// Alimenta Arquivos de Trabalho
MsAguarde({|| FSELEDADOS() })

//Alimenta o aheader

MsAguarde({|| ADDAHEAD() })

//Alimenta o acols e cria TMP
MsAguarde({|| ADDACOLS(1) })

dbSelectArea("TRB")
dbGoTop()
If TRB->(EOF())
	MsgAlert("Nใo existem dados para os parametros informado!")
Else
	
	DEFINE MSDIALOG oDlgConf TITLE "Conferencia Expedi็ใo x Laborat๓rio" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL
	
	aObjects := {}
	
	aAdd( aObjects, {100,100, .T., .T.})
	aAdd( aObjects, {100,100, .T., .T.})
	
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj		:= MsObjSize( ainfo, aObjects )
	
	Aadd(aButtons,{"RELATORIO",{|| RELCONF()  },"Conferencia","Conferencia"})
	
	@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[1,3]-125,aPosObj[1,4]-5 LABEL "" OF oDlgConf PIXEL
	
	oSayIme := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+010,{||"IMEI"},oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetIme := tGet():New( aPosObj[1,1]+25,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cImei := u, _cImei)},oDlgConf,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cImei")
	oGetIme:bValid 		:= {|| ExeConf() }     
	
	oSayOri := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+160,{||"Quantidade" },oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetOri	:= TGet():New( aPosObj[1,1]+25,aPosObj[1,2]+220,{|u| Iif( PCount() > 0, nQtdOri := u, nQtdOri)},oDlgConf,60,,"@E 99,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","nQtdOri",,)
	
	oSayDes := TSay():New( aPosObj[1,1]+25,aPosObj[1,2]+300,{||"Qtde Conferida" },oDlgConf,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetDes	:= TGet():New( aPosObj[1,1]+25,aPosObj[1,2]+365,{|u| Iif( PCount() > 0, nQtdDes := u, nQtdDes)},oDlgConf,60,,"@E 99,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","nQtdDes",,)
	
	oGetDadM1 := MsNewGetDados():New(aPosObj[2,1]-125,aPosObj[2,2]+5,aPosObj[2,3]-10,aPosObj[2,4]-5,GD_UPDATE,"AllwaysTrue",cTudoOK,"",aEdiCpo,nFreeze,9999,,,.T.,oDlgConf,aHeadM1,aColsM1)
	oGetDadM1:oBrowse:bChange := {|| (oGetDadM1:nat) }
	
	//ACTIVATE MSDIALOG oDlgConf ON INIT EnchoiceBar(oDlgConf,{|| Processa({|| IIF(MSGYESNO("Deseja Finalizar a Conferencia?"),GRAVATAB(),)},"Processando..."), oDlgConf:End()},{||oDlgConf:End()},,aButtons)
	ACTIVATE MSDIALOG oDlgConf ON INIT EnchoiceBar(oDlgConf,{|| oDlgConf:End(), Close(oDlgConf)},{||oDlgConf:End()},,aButtons)
Endif

If Select(cAliaM1) > 0
	dbSelectArea(cAliaM1)
	(cAliaM1)->(dbCloseArea())
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIATRB  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria็ใo das Tabelas Temporarias           		          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AOC                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FCRIATRB()

Local _aStru := {}

AADD(_aStru,{"BGH_CONF"		,"C",TamSX3("B1_DESC")[1],0})
AADD(_aStru,{"BGH_OPERA"	,"C",TamSX3("ZB1_OPEBGH")[1],0})
AADD(_aStru,{"BGH_MODELO"	,"C",TamSX3("ZB1_CODPRO")[1],0})
AADD(_aStru,{"BGH_IMEI"		,"C",TamSX3("ZB1_IMEI")[1],0})
AADD(_aStru,{"BGH_OS"	    ,"C",TamSX3("ZB1_NUMOS")[1],0})
AADD(_aStru,{"BGH_DATA"		,"D",TamSX3("ZB1_DATA")[1],0})
AADD(_aStru,{"BGH_HORA"		,"C",TamSX3("ZB1_HORA")[1],0})
AADD(_aStru,{"BGH_CODANA"	,"C",TamSX3("ZB1_CODANA")[1],0})
AADD(_aStru,{"BGH_CELULA"  	,"C",TamSX3("ZB1_CODANA")[1],0})
AADD(_aStru,{"BGH_TURNO" 	,"C",TamSX3("ZB1_CODANA")[1],0})
AADD(_aStru,{"BGH_DTEXP"	,"D",TamSX3("ZB1_DTEXP")[1],0})
AADD(_aStru,{"BGH_OBS"  	,"C",TamSX3("ZB1_OBS")[1],0})

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	 := "BGH_IMEI+BGH_OS"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSELEDADOSบAutor  ณLuciano Siqueira    บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria os a headers para a tela 							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Promaquina                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSELEDADOS()

Local lAchZB1 := .F.

_cQuery := " SELECT "
_cQuery += "	ZB1_CODPRO AS BGH_MODELO, "
_cQuery += "	ZB1_IMEI AS BGH_IMEI, "
_cQuery += "    ZB1_NUMOS AS BGH_OS, "
_cQuery += "    ZB1_HORA AS BGH_HORA, "
_cQuery += "    ZB1_CODANA AS BGH_CODANA, "
_cQuery += "    SUBSTRING(ZB1_CODANA,2,1) AS BGH_CELULA, "
_cQuery += "    SUBSTRING(ZB1_CODANA,3,1) AS BGH_TURNO, "
_cQuery += "    ZB1_CONF AS BGH_CONF "
_cQuery += " FROM " + RetSQlName("ZB1") + " ZB1 "
_cQuery += " WHERE  ZB1_FILIAL = '"+xFilial("ZB1")+"' AND "
_cQuery += "       (ZB1_DATA = '"+DTOS(dData)+"' AND "
_cQuery += "       ZB1_HORA > '06:00' "
_cQuery += "       OR "
_cQuery += "       ZB1_DATA = '"+DTOS(dData)+"' AND ZB1_HORA <= '06:00') "
_cQuery += "       AND ZB1_OPEBGH = '"+cOpera+"' "
_cQuery += "   	   AND SUBSTRING(ZB1_CODANA,3,1) ='"+cTurno+"' "
_cQuery += "       AND ZB1.D_E_L_E_T_ = '' "
_cQuery += " ORDER BY ZB1_IMEI, ZB1_NUMOS "

If Select("TSCONF") > 0
	dbSelectArea("TSCONF")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSCONF",.F.,.T.)

dbSelectArea("TSCONF")
dbGotop()
If TSCONF->(Eof())
	
	_cQuery := " SELECT ZZ4_CODPRO AS BGH_MODELO, "
	_cQuery += "	   ZZ4_IMEI AS BGH_IMEI, "
	_cQuery += "	   ZZ4_OS AS BGH_OS, "
	_cQuery += "	   ZZ3.ZZ3_HORA AS BGH_HORA, "
	_cQuery += "	   ZZ3.ZZ3_CODANA AS BGH_CODANA, "
	_cQuery += "       SUBSTRING(ZZ3_CODANA,2,1) AS BGH_CELULA, "
	_cQuery += "       SUBSTRING(ZZ3_CODANA,3,1) AS BGH_TURNO, "
	_cQuery += "       BGH_CONF    = '' "
	_cQuery += " FROM  " + RetSQlName("ZZ3") + " AS ZZ3(NOLOCK) "
	_cQuery += " JOIN  " + RetSQlName("ZZ4") + " AS ZZ4 (NOLOCK) "
	_cQuery += " ON    ZZ4.ZZ4_FILIAL = ZZ3.ZZ3_FILIAL AND ZZ4.ZZ4_IMEI = ZZ3.ZZ3_IMEI AND ZZ4.ZZ4_OS = ZZ3.ZZ3_NUMOS "
	_cQuery += "       AND ZZ4.D_E_L_E_T_ = '' "
	_cQuery += " JOIN  " + RetSQlName("ZZJ") + " AS ZZJ (NOLOCK) "
	_cQuery += " ON    ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND ZZ4.ZZ4_OPEBGH = ZZJ.ZZJ_OPERA AND ZZJ.D_E_L_E_T_ = '' "
	_cQuery += " JOIN  (SELECT ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1,ZZ1_SCRAP,ZZ1_DESFA1, "
	_cQuery += "              SCRAP    = CASE WHEN ZZ1_SCRAP  = 'S' THEN 1 ELSE 0 END, "
	_cQuery += "              NAOSCRAP = CASE WHEN ZZ1_SCRAP <> 'S' THEN 1 ELSE 0 END "
	_cQuery += "       FROM " + RetSQlName("ZZ1") + " (NOLOCK) "
	_cQuery += "       WHERE  ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND D_E_L_E_T_ = '') AS ZZ1 "
	_cQuery += " ON     ZZ1.ZZ1_LAB = ZZ3.ZZ3_LAB AND ZZ1.ZZ1_CODSET = ZZ3.ZZ3_CODSET AND ZZ1.ZZ1_FASE1 = ZZ3.ZZ3_FASE1 "
	_cQuery += " WHERE  ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND "
	_cQuery += "       (ZZ3.ZZ3_DATA = '"+DTOS(dData)+"' AND "
	_cQuery += "        ZZ3.ZZ3_HORA > '06:00' "
	_cQuery += "        OR "
	_cQuery += "        ZZ3.ZZ3_DATA = '"+DTOS(dData)+"' AND ZZ3.ZZ3_HORA <= '06:00') "
	_cQuery += "       AND ZZ3.ZZ3_ENCOS = 'S' "
	_cQuery += "       AND ZZ3.ZZ3_ESTORN = '' "
	_cQuery += "       AND ZZ1.ZZ1_DESFA1  NOT LIKE '%EOL%' "
	_cQuery += "       AND ZZ4_OPEBGH = '"+cOpera+"' "
	_cQuery += "   	   AND SUBSTRING(ZZ3_CODANA,3,1) ='"+cTurno+"' "
	_cQuery += "       AND ZZ3.D_E_L_E_T_ = '' "
	_cQuery += " ORDER BY ZZ4.ZZ4_IMEI, ZZ4.ZZ4_OS "
	
	If Select("TSCONF") > 0
		dbSelectArea("TSCONF")
		DbCloseArea()
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSCONF",.F.,.T.)
	dbSelectArea("TSCONF")
	dbGotop()
Else
	lAchZB1 := .T.
Endif


While TSCONF->(!Eof())
	_cConf := ""
	If TSCONF->BGH_CONF=="1" .OR. EMPTY(TSCONF->BGH_CONF)
		_cConf := "LABORATORIO E NAO EXPEDICAO"
	ElseIf TSCONF->BGH_CONF=="2"
		_cConf := "LABORATORIO E EXPEDICAO"
		nQtdDes ++
	ElseIf TSCONF->BGH_CONF=="3"
		_cConf := "EXPEDICAO E NAO LABORATORIO"
		nQtdDes ++
	Endif
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->BGH_CONF   	:= _cConf
	TRB->BGH_OPERA   	:= cOpera
	TRB->BGH_MODELO   	:= TSCONF->BGH_MODELO
	TRB->BGH_IMEI   	:= TSCONF->BGH_IMEI
	TRB->BGH_OS   		:= TSCONF->BGH_OS
	TRB->BGH_DATA   	:= dData
	TRB->BGH_HORA   	:= TSCONF->BGH_HORA
	TRB->BGH_CODANA   	:= TSCONF->BGH_CODANA
	TRB->BGH_CELULA   	:= TSCONF->BGH_CELULA
	TRB->BGH_TURNO   	:= TSCONF->BGH_TURNO
	If lAchZB1
		DbSelectArea("ZB1") 
		dbSetOrder(1)
		If dbSeek(xFilial("ZB1")+TSCONF->BGH_IMEI+TSCONF->BGH_OS)
			TRB->BGH_DTEXP   	:= ZB1->ZB1_DTEXP
			TRB->BGH_OBS    	:= ZB1->ZB1_OBS
		Endif	
	Endif
	MsUnlock()
	nQtdOri ++
	dbSelectArea("TSCONF")
	dbSkip()
Enddo

If !lAchZB1
	dbSelectArea("TRB")
	dbGotop()
	While TRB->(!Eof())
		_cConf := ""
		If Alltrim(TRB->BGH_CONF)=="LABORATORIO E NAO EXPEDICAO" .OR. EMPTY(TRB->BGH_CONF)
			_cConf := "1"
		ElseIf Alltrim(TRB->BGH_CONF)=="LABORATORIO E EXPEDICAO"
			_cConf := "2"
		ElseIf Alltrim(TRB->BGH_CONF)=="EXPEDICAO E NAO LABORATORIO"
			_cConf := "3"
		Endif
		
		DbSelectArea("ZB1") 
		dbSetOrder(1)
		If !dbSeek(xFilial("ZB1")+TRB->BGH_IMEI+TRB->BGH_OS)
			RecLock("ZB1",.T.)
			ZB1->ZB1_FILIAL	:= xFilial("ZB1")
			ZB1->ZB1_CONF	:= _cConf
			ZB1->ZB1_USER	:= cUserName
			ZB1->ZB1_OPEBGH	:= TRB->BGH_OPERA
			ZB1->ZB1_CODPRO	:= TRB->BGH_MODELO
			ZB1->ZB1_IMEI	:= TRB->BGH_IMEI
			ZB1->ZB1_NUMOS	:= TRB->BGH_OS
			ZB1->ZB1_DATA	:= TRB->BGH_DATA
			ZB1->ZB1_HORA	:= TRB->BGH_HORA
			ZB1->ZB1_CODANA	:= TRB->BGH_CODANA
			MsUnlock()
		Endif
		dbSelectArea("TRB")
		dbSkip()
	Enddo
Endif

If Select("TSCONF") > 0
	dbSelectArea("TSCONF")
	DbCloseArea()
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaHead  บAutor  ณLuciano Siqueira    บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria os a headers para a tela 							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Promaquina                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDAHEAD()

aCmp 	:= {"ZB1_CODPRO","ZB1_IMEI","ZB1_NUMOS","ZB1_DATA","ZB1_HORA","ZB1_CODANA","ZB1_CODANA","ZB1_CODANA","B1_DESC","ZB1_DTEXP","ZB1_OBS"}

aCmpTRB := {"BGH_MODELO","BGH_IMEI","BGH_OS","BGH_DATA","BGH_HORA","BGH_CODANA","BGH_CELULA","BGH_TURNO","BGH_CONF","BGH_DTEXP","BGH_OBS"}

aTitTRB := {"Modelo","IMEI","OS","Dt Encerramento","Hora","Analista","Celula","Turno","Conferencia","DT Expedicao","OBS"}

aAdd(aHeadM1,{" ","LEGENDA","@BMP",2,0,,,"C",,"V"})

dbSelectArea("SX3")
dbSetOrder(2)
For i := 1 To Len(aCmp)
	If SX3->(dbSeek(aCmp[i]))
		AAdd(aHeadM1, {aTitTRB[i],;
		aCmpTRB[i],;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	Endif
Next i

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADDACOLS  บAutor  ณDeltaDecisao        บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDACOLS(nParam)

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local aCampos	 := TRB->(dbStruct())

If nParam == 1
	dbSelectArea("TRB")
	DbGoTop()
	While !Eof()
		AAdd(aColsM1, Array(nQtdM1+1))
		nColuna := Len(aColsM1)
		If Alltrim(TRB->BGH_CONF)=="LABORATORIO E NAO EXPEDICAO"
			aColsM1[nColuna][1]:="BR_VERDE"
		ElseIf Alltrim(TRB->BGH_CONF)=="LABORATORIO E EXPEDICAO"
			aColsM1[nColuna][1]:="BR_VERMELHO"
		ElseIf Alltrim(TRB->BGH_CONF)=="EXPEDICAO E NAO LABORATORIO"
			aColsM1[nColuna][1]:="BR_AZUL"
		Endif
		For nM := 1 To Len(aCampos)
			cCpoTRB := "TRB->" + aCampos[nM][1]
			_cConteudo := &cCpoTRB
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPreenche o acols ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
			If nPos > 0
				aColsM1[nColuna][nPos] := _cConteudo
			EndIf
		Next nM
		aColsM1[nColuna][nQtdM1+1]  := .F.
		dbSkip()
	EndDo
ElseIf nParam == 2
	dbSelectArea("TRB")
	DbGoTop()
	If dbSeek(_cImei)
		AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
		nColuna := Len(oGetDadM1:aCols)
		oGetDadM1:aCols[nColuna][1]:="BR_AZUL"
		For nM := 1 To Len(aCampos)
			cCpoTRB := "TRB->" + aCampos[nM][1]
			_cConteudo := &cCpoTRB
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPreenche o acols ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
			If nPos > 0
				oGetDadM1:aCols[nColuna][nPos] := _cConteudo
			EndIf
		Next nM
		oGetDadM1:aCols[nColuna][nQtdM1+1]  := .F.
	Endif
Endif



Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExeConf   บAutor  ณLuciano Siqueira      บ Data ณ  22/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa Separa็ใo da Pe็a                                    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExeConf()

Local _nPosImei	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "BGH_IMEI"})
Local _nPosOs	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "BGH_OS"})
Local _nPosConf	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "BGH_CONF"})
Local _nPosDtEx	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "BGH_DTEXP"})
Local _nPosObs	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "BGH_OBS"})
Local lAchou	:= .F.

If !empty(_cImei)
	If Len(AllTrim(_cImei)) <> 15
		MsgAlert("Equipamento com Erro no Imei, Favor Inserir Novamente!")
	Else
		For i:=1 to Len(oGetDadM1:aCols)
			If Alltrim(oGetDadM1:aCols[i,_nPosImei])==Alltrim(_cImei)
				dbSelectArea("TRB")
				If dbSeek(oGetDadM1:aCols[i,_nPosImei]+oGetDadM1:aCols[i,_nPosOS])
					lAchou	:= .T.
					If oGetDadM1:aCols[i][1]=="BR_VERMELHO"
						MsgAlert("Conferencia ja efetuada!")
					ElseIf oGetDadM1:aCols[i][1]=="BR_AZUL"
						MsgAlert("EXPEDICAO E NAO LABORATORIO, Favor verificar!")
					Else
						oGetDadM1:aCols[i][1]:="BR_VERMELHO"
						oGetDadM1:aCols[i,_nPosConf]:= "LABORATORIO E EXPEDICAO"
						oGetDadM1:aCols[i,_nPosDtEx]:= dDataBase 
						oGetDadM1:aCols[i,_nPosObs] := "LAB: "+SUBSTR(TRB->BGH_CODANA,3,1)+" - "+DTOC(TRB->BGH_DATA)+" EXP: "+cTurno+" - "+ DTOC(dData)
						DbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->BGH_CONF   	:= "LABORATORIO E EXPEDICAO"   
						TRB->BGH_DTEXP		:= dDataBase
						TRB->BGH_OBS		:= "LAB: "+SUBSTR(TRB->BGH_CODANA,3,1)+" - "+DTOC(TRB->BGH_DATA)+" EXP: "+cTurno+" - "+ DTOC(dData)
						MsUnlock()
						nQtdDes ++
						dbSelectArea("ZB1")
						dbSetOrder(1)
						If dbSeek(xFilial("ZB1")+oGetDadM1:aCols[i,_nPosImei]+oGetDadM1:aCols[i,_nPosOS])
							RecLock("ZB1",.F.)
							ZB1->ZB1_CONF  	:= "2"
							ZB1->ZB1_USER	:= cUserName
							ZB1->ZB1_DTEXP	:= dDataBase
							ZB1->ZB1_OBS	:= "LAB: "+SUBSTR(TRB->BGH_CODANA,3,1)+" - "+DTOC(TRB->BGH_DATA)+" EXP: "+cTurno+" - "+ DTOC(dData)
							MsUnlock()
						Endif
						Exit
					Endif
				Endif
			Endif
		Next i
		If !lAchou
			dbSelectArea("ZZ4")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ4")+_cImei)
				While ZZ4->(!EOF()) .and. ZZ4->(ZZ4_FILIAL+ZZ4_IMEI)==xFilial("ZZ4")+_cImei
					If ZZ4->ZZ4_STATUS>="5" .AND. ZZ4->ZZ4_OPEBGH==cOpera
						DbSelectArea("ZB1")
						dbSetOrder(1)
						If !dbSeek(xFilial("ZB1")+ZZ4->(ZZ4_IMEI+ZZ4_OS))
							RecLock("ZB1",.T.)
							ZB1->ZB1_FILIAL	:= xFilial("ZB1")
							ZB1->ZB1_CONF	:= "3"
							ZB1->ZB1_USER	:= cUserName
							ZB1->ZB1_OPEBGH	:= ZZ4->ZZ4_OPEBGH
							ZB1->ZB1_CODPRO	:= ZZ4->ZZ4_CODPRO
							ZB1->ZB1_IMEI	:= ZZ4->ZZ4_IMEI
							ZB1->ZB1_NUMOS	:= ZZ4->ZZ4_OS
							ZB1->ZB1_DATA	:= dData
							ZB1->ZB1_CODANA	:= "XX"+cTurno
							ZB1->ZB1_DTEXP	:= dDataBase
							MsUnlock()
							
							DbSelectArea("TRB")
							RecLock("TRB",.T.)
							TRB->BGH_CONF   	:= "EXPEDICAO E NAO LABORATORIO"
							TRB->BGH_IMEI   	:= ZZ4->ZZ4_IMEI
							TRB->BGH_OPERA   	:= ZZ4->ZZ4_OPEBGH
							TRB->BGH_MODELO   	:= ZZ4->ZZ4_CODPRO
							TRB->BGH_OS   		:= ZZ4->ZZ4_OS
							TRB->BGH_DATA   	:= dData
							TRB->BGH_CODANA   	:= "XX"+cTurno
							TRB->BGH_DTEXP   	:= dDataBase
							MsUnlock()
							nQtdDes ++
						Else
							DbSelectArea("TRB")
							RecLock("TRB",.T.)
							TRB->BGH_CONF   	:= "LABORATORIO E EXPEDICAO"
							TRB->BGH_IMEI   	:= ZB1->ZB1_IMEI
							TRB->BGH_OPERA   	:= ZB1->ZB1_OPEBGH
							TRB->BGH_MODELO   	:= ZB1->ZB1_CODPRO
							TRB->BGH_OS   		:= ZB1->ZB1_NUMOS
							TRB->BGH_DATA   	:= ZB1->ZB1_DATA
							TRB->BGH_CODANA   	:= ZB1->ZB1_CODANA 
							TRB->BGH_HORA   	:= ZB1->ZB1_HORA
							TRB->BGH_CELULA   	:= SUBSTR(ZB1->ZB1_CODANA,2,1) 
							TRB->BGH_TURNO   	:= SUBSTR(ZB1->ZB1_CODANA,3,1) 
							TRB->BGH_DTEXP		:= dDataBase
							TRB->BGH_OBS		:= "LAB: "+SUBSTR(ZB1->ZB1_CODANA,3,1)+" - "+DTOC(ZB1->ZB1_DATA)+" EXP: "+cTurno+" - "+ DTOC(dData)
							MsUnlock()
							nQtdDes ++
								
							RecLock("ZB1",.F.)
							ZB1->ZB1_CONF	:= "2"
							ZB1->ZB1_DTEXP	:= dDataBase
							ZB1->ZB1_OBS	:=  "LAB: "+SUBSTR(ZB1->ZB1_CODANA,3,1)+" - "+DTOC(ZB1->ZB1_DATA)+" EXP: "+cTurno+" - "+ DTOC(dData)
							MsUnlock()
												
						Endif						
						ADDACOLS(2)
						lAchou := .T.                                       
						Exit
					Endif
					ZZ4->(dbSkip())
				EndDo
			Endif
			If !lAchou
				MsgAlert("Imei nao localizado, Favor verificar!")
			Endif
		Endif
	Endif
Endif


_cImei  := Space(TamSX3("ZZ4_IMEI")[1])//Space(20)

oGetDadM1:Refresh()
oGetIme:SetFocus()      
oGetDes:Refresh()


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

User Function LegenZB1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Legenda                                                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aCorDesc := {{"ENABLE"     	, "LABORATORIO E NAO EXPEDICAO" },;
{"BR_AZUL"		, "EXPIDACAO E NAO LABORATORIO"	},;
{"DISABLE"		, "LABORATORIO E EXPIDACAO"	}}

BrwLegenda(cCadastro, "Status", aCorDesc )


Return ( .T. )

Static Function RELCONF()

Local aArea := GetArea()

If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

RestArea(aArea)

Return

Static Function ReportDef()

Local oReport

oReport := TReport():New("CONEXLAB","Conferencia Expedi็ใo x Laboratorio","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Conferencia Expedi็ใo x Laboratorio")
oReport:SetLandScape(.T.)

oSection1 := TRSection():New(oReport,OemToAnsi("Conferencia Expedi็ใo x Laboratorio"),{"TRB"})


TRCell():New(oSection1,"BGH_CONF","TRB","Conferencia","@!",30)
TRCell():New(oSection1,"BGH_OPERA","TRB","Opera็ใo","@!",06)
TRCell():New(oSection1,"BGH_MODELO","TRB","Modelo","@!",15)
TRCell():New(oSection1,"BGH_IMEI","TRB","IMEI","@!",TamSX3("ZZ4_IMEI")[1])
TRCell():New(oSection1,"BGH_DATA","TRB","Data","@!",10)
TRCell():New(oSection1,"BGH_HORA","TRB","Hora","@!",10)
TRCell():New(oSection1,"BGH_CODANA","TRB","Analista","@!",06)
TRCell():New(oSection1,"BGH_CELULA","TRB","Celula","@!",02)
TRCell():New(oSection1,"BGH_TURNO","TRB","Turno","@!",02)
TRCell():New(oSection1,"BGH_DTEXP","TRB","DT Expedicao","@!",10)
TRCell():New(oSection1,"BGH_OBS","TRB","Obs","@!",40)


Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Init()

DbSelectArea("TRB")
DbGoTop()
oReport:SetMeter(RecCount())
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	DbSkip()
	oReport:IncMeter()
End
oSection1:Finish()

Return

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Operacao    ?','' ,'' , 'mv_ch1', 'C', 3, 0, 0, 'G', '', 'ZZJ', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Turno       ?','' ,'' , 'mv_ch2', 'N', 01, 0,01 ,'C', '',   '' , '', '', 'mv_par02',"1ฐ","","","","2ฐ","","","3ฐ","","","4ฐ","","")
PutSx1(cPerg, '03', 'Data        ?','' ,'' , 'mv_ch3', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')

Return
