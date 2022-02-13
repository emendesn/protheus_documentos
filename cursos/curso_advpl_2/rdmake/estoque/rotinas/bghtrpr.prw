#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGHTRPR   บAutor  ณLuciano Siqueira    บ Data ณ  22/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Analise e transferencia das pe็as existentes no 01 - Bufferบฑฑ
ฑฑบ          ณ para 1P - Produ็ใo                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BGHTRPR()

Local _lProcessa:= .T.

Private _cPerg	:= "BGHTRPR"

ValPerg(_cPerg)
If Pergunte(_cPerg,.T.)
	dbSelectArea("SD3")
	dbGotop()
	SD3->(DBOrderNickName('XDOCORI'))
	If dbSeek(xFilial("SD3")+MV_PAR01)
		While SD3->(!EOF()) .and. SD3->(D3_FILIAL+D3_XDOCORI)==xFilial("SD3")+MV_PAR01
			If SD3->D3_ESTORNO <> "S" .and. SD3->D3_TM <> "998"
				_lProcessa:= .F.
				Exit
			Endif
			dbSelectArea("SD3")
			dbSkip()
		EndDo
	Endif
Else
	Return
Endif

If _lProcessa
	VisuDOC()
Else
	MsgAlert("Documento Gerado Anteriormente")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISUPMP  บAutor  ณLuciano Siqueira     บ Data ณ  04/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Analise PMP               		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisuDOC()

Local aPosObj    	:= {}
Local aObjects   	:= {}
Local aSize      	:= MsAdvSize()
Local cLinOK     	:= "AllwaysTrue"
Local cTudoOK       := "u_AltTudOk()"
Local aButtons    	:= {}

Private aColsM1    	:= {}
Private aHeadM1 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados

Private nFreeze 	:= 0
Private cAliaM1     := "TRB"
Private oGetDadM1 := Nil
Private oDlg := Nil

Private cDocOri	:= MV_PAR01
Private cArmDes := MV_PAR02
Private cEndDes := MV_PAR03
Private nQtdOri := 0
Private nQtdDes := 0
Private aItens 	:= {}

oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parโmetro negrito


// Cracao dos arquivos de Trabalho
MsAguarde({|| FCRIATRB() })

// Alimenta Arquivos de Trabalho
MsAguarde({|| FSELEDADOS() })

//Alimenta o aheader

MsAguarde({|| ADDAHEAD() })

//Alimenta o acols e cria TMP
MsAguarde({|| ADDACOLS() })

dbSelectArea("TRB")
dbGoTop()
If TRB->(EOF())
	MsgAlert("Nใo existem dados para os parametros informado!")
Else
	
	DEFINE MSDIALOG oDlg TITLE OemtoAnsi("Transfer๊ncia para Produ็ใo") FROM aSize[ 7 ], 0 TO   aSize[ 6 ],  aSize[ 5 ] OF oDlg PIXEL
	
	aObjects := {}
	AAdd( aObjects, { aSize[ 6 ], 010, .F., .F. } )
	AAdd( aObjects, { aSize[ 6 ], 250, .F., .F. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	Aadd(aButtons,{"SOLICITA",{|| U_SEPPECA()  },"Separa Pe็a","Separa Pe็a"})
	
	oSayOri := TSay():New( aPosObj[1,1]+290,aPosObj[1,2]+100,{||"Quantidade" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetOri	:= TGet():New( aPosObj[1,1]+290,aPosObj[1,2]+160,{|u| Iif( PCount() > 0, nQtdOri := u, nQtdOri)},oDlg,60,,"@E 99,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","nQtdOri",,)
	
	oSayDes := TSay():New( aPosObj[1,1]+290,aPosObj[1,2]+260,{||"Qtde Separada" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
	oGetDes	:= TGet():New( aPosObj[1,1]+290,aPosObj[1,2]+320,{|u| Iif( PCount() > 0, nQtdDes := u, nQtdDes)},oDlg,60,,"@E 99,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","nQtdDes",,)
	
	oGetDadM1   :=MsNewGetDados():New(aPosObj[2,1],aPosObj[1,2]+10,aPosObj[2,3]+15,aPosObj[2,4],GD_UPDATE,cLinOK,cTudoOk,"",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_AltTudOk(),Processa({|| TRANSDOC(),oDlg:End()}),nOpcA:=0)},{||oDlg:End()},,aButtons)
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

AADD(_aStru,{"DOC"			,"C",TamSX3("D3_DOC")[1],0})
AADD(_aStru,{"PECA"		,"C",TamSX3("D3_COD")[1],0})
AADD(_aStru,{"DESPECA"		,"C",TamSX3("B1_DESC")[1],0})
AADD(_aStru,{"ARMAZEM"		,"C",TamSX3("D3_LOCAL")[1],0})
AADD(_aStru,{"LOCALIZ"		,"C",TamSX3("D3_LOCALIZ")[1],0})
AADD(_aStru,{"QUANT"  		,"N",12,2})
AADD(_aStru,{"QTDSEPA" 		,"N",12,2})


// Criacao Temporario dos Modelos
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	 := "PECA+ARMAZEM"

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

_cQuery := " SELECT "
_cQuery += " 	D3_DOC AS DOC, "
_cQuery += " 	D3_COD AS PECA, "
_cQuery += " 	B1_DESC AS DESPECA, "
_cQuery += " 	D3_LOCAL AS ARMAZEM, "
_cQuery += " 	D3_LOCALIZ AS LOCALIZ, "
_cQuery += " 	D3_QUANT AS QUANT "
_cQuery += " 	FROM "+RetSQLName("SD3")+" SD3 "
_cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
_cQuery += " 	B1_FILIAL='"+xFilial("SB1")+"' AND "
_cQuery += " 	B1_COD=D3_COD AND "
_cQuery += " 	SB1.D_E_L_E_T_ = '' "
_cQuery += " WHERE "
_cQuery += " 	D3_FILIAL='"+xFilial("SD3")+"' AND "
_cQuery += " 	D3_DOC='"+cDocOri+"' AND "
_cQuery += " 	D3_TM='499' AND "
_cQuery += " 	D3_ESTORNO<>'S' AND "
_cQuery += " 	SD3.D_E_L_E_T_='' "
_cQuery += " ORDER BY D3_DOC,D3_COD "

If Select("TSQD3") > 0
	dbSelectArea("TSQD3")
	DbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQD3",.F.,.T.)

dbSelectArea("TSQD3")
dbGotop()
While TSQD3->(!Eof())
	DbSelectArea("TRB")
	If dbSeek(TSQD3->PECA+TSQD3->ARMAZEM)
		RecLock("TRB",.F.)
		TRB->QUANT	+= TSQD3->QUANT
		MsUnlock()	
	Else
		RecLock("TRB",.T.)
		TRB->DOC   	:= TSQD3->DOC
		TRB->PECA	:= TSQD3->PECA
		TRB->DESPECA:= TSQD3->DESPECA
		TRB->ARMAZEM:= TSQD3->ARMAZEM
		TRB->LOCALIZ:= TSQD3->LOCALIZ
		TRB->QUANT	:= TSQD3->QUANT
		MsUnlock()
	Endif
	
	nQtdOri += TSQD3->QUANT
	
	dbSelectArea("TSQD3")
	dbSkip()
Enddo

If Select("TSQD3") > 0
	dbSelectArea("TSQD3")
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

aCmp 	:= {"D3_DOC","D3_COD","B1_DESC","D3_LOCAL","D3_LOCALIZ","D3_QUANT","D3_QUANT"}

aCmpTRB := {"DOC","PECA","DESPECA","ARMAZEM","LOCALIZ","QUANT","QTDSEPA"}

aTitTRB := {"Documento","Pe็a","Descri็ใo","Armazem","Endere็o","Quantidade","Qtde Separada"}

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
Static Function ADDACOLS()

Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local aCampos	 := TRB->(dbStruct())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta Acols do Modelo
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
DbGoTop()
While !Eof()
	AAdd(aColsM1, Array(nQtdM1+1))
	nColuna := Len(aColsM1)
	aColsM1[nColuna][1]:="BR_VERDE"
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

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEPPECA   บAutor  ณLuciano Siqueira      บ Data ณ  22/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta para apontamento de Pe็as                           บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEPPECA()

//+----------------------------------------------------------------------------
//| Declara็๕es das varแveis
//+----------------------------------------------------------------------------
Local aSvArea:=GetArea()

Private oDlgPeca:= Nil
Private cViaF3  := Space(20)
Private nQtdSel := 0
Private oGetQSep   
Private oGetQtd                                                      


//+----------------------------------------------------------------------------
//| Defini็ใo da janela e seus conte๚dos
//+----------------------------------------------------------------------------
DEFINE MSDIALOG oDlgPeca TITLE "Separa็ใo de Pe็as" FROM 0,0 TO 100,500 OF oDlgPeca PIXEL

//@ 06,06 TO 46,242 LABEL "Separar" OF oDlgPeca PIXEL

@ 015,010 SAY   "Produto" 	SIZE 150,10 PIXEL OF oDlgPeca
@ 015,040 MSGET oGetQSep var cViaF3 PICTURE "@!" SIZE 150,10 PIXEL OF oDlgPeca//Valid oGetQtd:SetFocus()

@ 030,010 SAY   "Quantidade" 	SIZE 150,10 PIXEL OF oDlgPeca
@ 030,040 MSGET oGetQtd var nQtdSel PICTURE "@E 999999999.99" Valid ExecSep() SIZE 080,10 PIXEL OF oDlgPeca

//@ 11,200 BUTTON "Separar" SIZE 36,17 PIXEL ACTION ExecSep()

ACTIVATE MSDIALOG oDlgPeca CENTER

RestArea(aSvArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecSep   บAutor  ณLuciano Siqueira      บ Data ณ  22/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa Separa็ใo da Pe็a                                    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExecSep()

Local _nPosProd	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "PECA"})
Local _nPosArmz	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "ARMAZEM"})
Local _nPosEnd	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "LOCALIZ"})
Local _nPosQtd	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "QUANT"})
Local _nPosSep	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "QTDSEPA"})
Local cProduto	:= ""
Local cArmazem  := ""
Local cLocaliz	:= ""
Local nQuant  	:= ""
Local _lRet		:= .F.

For i:=1 to Len(oGetDadM1:aCols)
	cProduto	:= oGetDadM1:aCols[i,_nPosProd]
	cArmazem	:= oGetDadM1:aCols[i,_nPosArmz]
	cLocaliz	:= oGetDadM1:aCols[i,_nPosEnd]
	nQuant  	:= oGetDadM1:aCols[i,_nPosQtd]
	If Alltrim(cProduto)==Alltrim(cViaF3) .and. nQuant==nQtdSel .and. oGetDadM1:aCols[i,_nPosSep]==0
	
		_cArmPSP := GetMv("MV_XARMPSP",.F.,"1S")
		_cArmPRJ := GetMv("MV_XARMPRJ",.F.,"1R")
		_cEndPro := GetMv("MV_XENDPRO",.F.,"PROC")
		
		cArmDes := IIF(cArmazem=="10",_cArmPSP,IIF(cArmazem=="11",_cArmPRJ,cArmDes))
		cEndDes := IIF(cArmazem$"10/11",_cEndPro,cEndDes)
	
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+cProduto)
		
		dbselectarea("SB2")
		dbSetOrder(1)
		SB2->(DBSeek(xFilial('SB2') + cProduto + cArmazem))
		_nSalb2:=SaldoSB2(nil,nil,date(),.T.,.T.,nil,0,0,.T.)
		_nSalBF := SaldoSBF(cArmazem, cLocaliz, cProduto, NIL, NIL, NIL, .F.)
		If _nSalb2 >= nQtdSel .and. _nSalBF >= nQtdSel
			oGetDadM1:aCols[i][1]:="BR_VERMELHO"
			oGetDadM1:aCols[i,_nPosSep] := nQtdSel
			nQtdDes += nQtdSel
			
			aAdd(aItens,{cProduto,;						// Produto Origem
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Origem
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			cArmazem,;                           		// Local Origem
			cLocaliz,;    			         			// Ender Origem
			cProduto,;	 			                 	// Produto Destino
			Left(SB1->B1_DESC,30),;                   	// Desc. Produto Destino
			AllTrim(SB1->B1_UM),;                     	// Unidade Medida
			cArmDes,;                  				// Local Destino
			cEndDes,;			     					// Ender Destino
			Space(20),;                               	// Num Serie
			Space(10),;                               	// Lote
			Space(06),;                              	// Sub Lote
			CtoD("//"),;                              	// Validade
			0,;                                        	// Potencia
			nQtdSel,;                       			// Quantidade
			0,;                                       	// Qt 2aUM
			"N",;                                     	// Estornado
			Space(06),;                               	// Sequencia
			Space(10),;                               	// Lote Desti
			CtoD("//"),;                              	// Validade Lote
			Space(3),;                              	// Cod.Servic //Acrescentado edson Rodrigues
			Space(03)})									// Item Grade
		Else
			MsgAlert("Produto nใo possui saldo para efetuar transfer๊ncia. Favor verificar com o Estoque!")
		Endif
		_lRet := .T.
		Exit
	Endif
Next i

If _lRet==.F.
	MsgAlert("Produto nใo localizado ou quantidade nใo confere!")
Endif

cViaF3  := Space(20)
nQtdSel := 0
oGetQSep:SetFocus()

oGetDadM1:Refresh()

oGetDes:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltTudOk  บAutor  ณLuciano Siqueira    บ Data ณ  31/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AltTudOk()

Local aSvArea:=GetArea()
Local lRet := .T.
Local _nPosQtd	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "QUANT"})
Local _nPosSep	:=	Ascan(aHeadM1,{|x| Alltrim(x[2]) == "QTDSEPA"})
Local nQuant  	:= 0
Local nQtdSep  	:= 0

For i:=1 to Len(oGetDadM1:aCols)
	nQuant  	+= oGetDadM1:aCols[i,_nPosQtd]
	nQtdSep  	+= oGetDadM1:aCols[i,_nPosSep]
Next i

If nQtdSep <> nQuant
	lRet:=.F.
	MsgAlert("Quantidade Separada nใo confere com a Quantidade do Documento!")
Endif

RestArea(aSvArea)

Return(lRet)

Static Function TRANSDOC()

Private cDocumento := Space(6)
Private cGrMovi    := Posicione("SD3",2,xFilial("SD3")+cDocOri,"D3_XGRMOVI")

If Len(aItens) > 0
	//-- Inicializa o numero do Documento com o ultimo + 1
	dbSelectArea("SD3")
	nSavReg     := RecNo()
	cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
	cDocumento	:= A261RetINV(cDocumento)
	dbSetOrder(2)
	dbSeek(xFilial()+cDocumento)
	cMay := "SD3"+Alltrim(xFilial())+cDocumento
	While D3_FILIAL+D3_DOC==xFilial()+cDocumento.Or.!MayIUseCode(cMay)
		If D3_ESTORNO # "S"
			cDocumento := Soma1(cDocumento)
			cMay := "SD3"+Alltrim(xFilial())+cDocumento
		EndIf
		dbSkip()
	EndDo
	lRet := u_BaixPeca(cDocumento,aItens,3)
	If lRet
		dbSelectArea("SD3")
		dbGotop()
		dbSetOrder(2)
		If dbSeek(xFilial("SD3")+cDocumento)
			While SD3->(!EOF()) .and. SD3->(D3_FILIAL+D3_DOC)==xFilial("SD3")+cDocumento
				dbSelectArea("SD3")
				RecLock("SD3",.F.)
				SD3->D3_XDOCORI := cDocOri
				SD3->D3_XGRMOVI	:= cGrMovi
				MsUnLock()
				dbSelectArea("SD3")
				dbSkip()
			EndDo
		Endif
		
		//AtFildWeb(cDocOri)
		
		cMensagem:="Transfer๊ncia Efetuada com Sucesso!"+Chr(13)+Chr(10)
		cMensagem+= "Documento Origem: "+cDocOri+Chr(13)+Chr(10)
		cMensagem+= "Documento Destino: "+cDocumento
		MsgAlert(cMensagem)
	Endif
Endif
Return

Static Function AtFildWeb(_cDocOri)

Local _aArea 	:= GetArea()
Local _nMinRec	:= 0
Local _nMinNov	:= 0
Local _nMinMis	:= 0

Private _cArmRec	:= "AA"
Private _cArmNov	:= "AB"
Private _cArmEq		:= "AC"

_cQuery := " SELECT "
_cQuery += "	DISTINCT D3_OP AS OP,C2_PRODUTO AS MODELO, B1_XCAPHOR AS XCAPHOR "
_cQuery += "FROM "+RetSQLName("SD3")+" SD3 "
_cQuery += "INNER JOIN "+RetSQLName("SC2")+" SC2 ON "
_cQuery += "	C2_FILIAL='"+xFilial("SC2")+"' AND "
_cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN=D3_OP AND "
_cQuery += "	SC2.D_E_L_E_T_='' "
_cQuery += "INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
_cQuery += "	B1_FILIAL='' AND "
_cQuery += "	B1_COD=C2_PRODUTO AND "
_cQuery += "	SB1.D_E_L_E_T_='' "
_cQuery += "WHERE "
_cQuery += "	D3_FILIAL='"+xFilial("SD3")+"' AND "
_cQuery += "	D3_DOC='"+_cDocOri+"' AND "
_cQuery += "	D3_OP <> '' AND "
_cQuery += "	(D3_LOCAL ='"+_cArmRec+"' OR D3_LOCAL ='"+_cArmNov+"') AND "
_cQuery += "	SD3.D_E_L_E_T_='' "

If Select("TSQOP") > 0
	dbSelectArea("TSQOP")
	DbCloseArea()
EndIf
	
//* Cria a Query e da Um Apelido
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQOP",.F.,.T.)

TcSetField("TSQOP","TSQOP->XCAPHOR","N",14,2)
	
dbSelectArea("TSQOP")
dbGotop()

If TSQOP->(!Eof())
	
	//Retorna Quantidade Caixas Recuperadas e Caixas Novas
	_cQuery := " SELECT "
	_cQuery += " 	ARMAZ, "
	_cQuery += " 	Floor(MIN(QTDMIN)) AS QTDMIN "
	_cQuery += " FROM "
	_cQuery += " 	(SELECT "
	_cQuery += "		G1_COMP AS PECA, "
	_cQuery += "		B2_LOCAL AS ARMAZ, "
	_cQuery += "		CASE WHEN D3_QUANT > 0 THEN ((D3_QUANT/G1_QUANT)/B1_XCAPHOR) ELSE 0 END AS QTDMIN "
	_cQuery += "	FROM "+RetSQLName("SG1")+" SG1 "         
	_cQuery += "	INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
	_cQuery += "		B1_FILIAL='"+xFilial("SB1")+"' AND
	_cQuery += "		B1_COD=G1_COD AND "
	_cQuery += "		SB1.D_E_L_E_T_='' "
	_cQuery += "	INNER JOIN "+RetSQLName("SB2")+" SB2 ON "
	_cQuery += " 		B2_FILIAL='"+xFilial("SB2")+"' AND "
	_cQuery += "		B2_COD=G1_COMP AND "
	_cQuery += "		(B2_LOCAL ='"+_cArmRec+"' OR B2_LOCAL ='"+_cArmNov+"') AND "
	_cQuery += "		SB2.D_E_L_E_T_='' "
	_cQuery += "	LEFT JOIN "+RetSQLName("SD3")+" SD3 ON "
	_cQuery += "		D3_FILIAL='"+xFilial("SD3")+"' AND "
	_cQuery += "		D3_DOC='"+_cDocOri+"' AND "
	_cQuery += "		D3_COD=B2_COD AND "
	_cQuery += "		D3_LOCAL=B2_LOCAL AND "
	_cQuery += "		D3_TM='499' AND "
	_cQuery += " 		D3_ESTORNO<>'S' AND "
	_cQuery += "		SD3.D_E_L_E_T_='' "
	_cQuery += "	WHERE "
	_cQuery += "		G1_FILIAL='"+xFilial("SG1")+"' AND "
	_cQuery += "		G1_COD='"+TSQOP->MODELO+"' AND "
	_cQuery += "		G1_INI <= '" + DtoS(dDataBase) + "' AND "
	_cQuery += "		G1_FIM >= '" + DtoS(dDataBase) + "' AND "
	_cQuery += "		SG1.D_E_L_E_T_='') AS TRB "
	_cQuery += " GROUP BY ARMAZ "
	
	If Select("TSQMIN") > 0
		dbSelectArea("TSQMIN")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQMIN",.F.,.T.)
	
	dbSelectArea("TSQMIN")
	dbGotop()
	While TSQMIN->(!Eof())
		If TSQMIN->ARMAZ == _cArmRec
			_nMinRec	:= TSQMIN->QTDMIN
		ElseIf TSQMIN->ARMAZ == _cArmNov
			_nMinNov	:= TSQMIN->QTDMIN
		Endif
		dbSelectArea("TSQMIN")
		dbSkip()
	Enddo
	
	If Select("TSQMIN") > 0
		dbSelectArea("TSQMIN")
		DbCloseArea()
	EndIf
	
	//Retorna Quantidade de Caixas Mistas
	_cQuery := " SELECT "
	_cQuery += " 	Ceiling(MIN(QTDMIN)) AS QTDMIN "
	_cQuery += " FROM "
	_cQuery += " 	(SELECT "
	_cQuery += "		G1_COMP AS PECA, "
	_cQuery += "		SUM((D3_QUANT/G1_QUANT)/B1_XCAPHOR) AS QTDMIN "
	_cQuery += "	FROM "+RetSQLName("SG1")+" SG1 "
	_cQuery += "	INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
	_cQuery += "		B1_FILIAL='"+xFilial("SB1")+"' AND
	_cQuery += "		B1_COD=G1_COD AND "
	_cQuery += "		SB1.D_E_L_E_T_='' "
	_cQuery += "	INNER JOIN "+RetSQLName("SB2")+" SB2 ON "
	_cQuery += " 		B2_FILIAL='"+xFilial("SB2")+"' AND "
	_cQuery += "		B2_COD=G1_COMP AND "
	_cQuery += "		(B2_LOCAL ='"+_cArmRec+"' OR B2_LOCAL ='"+_cArmNov+"') AND "
	_cQuery += "		SB2.D_E_L_E_T_='' "
	_cQuery += "	LEFT JOIN "+RetSQLName("SD3")+" SD3 ON "
	_cQuery += "		D3_FILIAL='"+xFilial("SD3")+"' AND "
	_cQuery += "		D3_DOC='"+_cDocOri+"' AND "
	_cQuery += "		D3_COD=B2_COD AND "
	_cQuery += "		D3_LOCAL=B2_LOCAL AND "
	_cQuery += "		D3_TM='499' AND "
	_cQuery += " 		D3_ESTORNO<>'S' AND "
	_cQuery += "		SD3.D_E_L_E_T_='' "
	_cQuery += "	WHERE "
	_cQuery += "		G1_FILIAL='"+xFilial("SG1")+"' AND "
	_cQuery += "		G1_COD='"+TSQOP->MODELO+"' AND "
	_cQuery += "		G1_INI <= '" + DtoS(dDataBase) + "' AND "
	_cQuery += "		G1_FIM >= '" + DtoS(dDataBase) + "' AND "
	_cQuery += "		SG1.D_E_L_E_T_=''
	_cQuery += " 	GROUP BY G1_COMP) AS TRB "
	
	If Select("TSQMIN") > 0
		dbSelectArea("TSQMIN")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQMIN",.F.,.T.)
	
	dbSelectArea("TSQMIN")
	dbGotop()
	If TSQMIN->(!Eof())
		_nMinMis	:= IIF(_nMinRec > 0 .and. _nMinNov > 0 ,TSQMIN->QTDMIN-(_nMinRec+_nMinNov),0)
	Endif
	
	If Select("TSQMIN") > 0
		dbSelectArea("TSQMIN")
		DbCloseArea()
	EndIf
	
	
	If _nMinRec+_nMinNov+_nMinMis > 0
		dbSelectArea("SC2")
		dbSetOrder(1)
		If dbSeek(xFilial("SC2")+TSQOP->OP)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
			RecLock("ZA3",.T.)
			ZA3->ZA3_FILIAL := xFilial("ZA3")
			ZA3->ZA3_OP		:= SC2->C2_NUM
			ZA3->ZA3_ESTSER := SC2->C2_PRODUTO
			ZA3->ZA3_EMISSA := dDataBase
			ZA3->ZA3_SEPEFT := "N"
			ZA3->ZA3_QTDEQT := SC2->C2_QUANT
			ZA3->ZA3_CAPROH := SB1->B1_XCAPHOR
			ZA3->ZA3_QTTKIT := _nMinRec+_nMinNov+_nMinMis
			ZA3->ZA3_QKREME	:= _nMinRec
			ZA3->ZA3_QKREEL := _nMinRec
			ZA3->ZA3_QKNOME := _nMinNov
			ZA3->ZA3_QKNOEL := _nMinNov
			ZA3->ZA3_QKRNME := _nMinMis
			ZA3->ZA3_QKRNEL := _nMinMis
			ZA3->ZA3_DOCSEP := SC2->C2_NUM
			ZA3->ZA3_STATUS := "1"
			ZA3->ZA3_MODELO := "I290FU"         
			ZA3->ZA3_ARMEQT := _cArmEq
			MsUnlock()
			dbSelectArea("SD3")
			dbGotop()
			dbSetOrder(2)
			If dbSeek(xFilial("SD3")+_cDocOri)
				While SD3->(!EOF()) .and. SD3->(D3_FILIAL+D3_DOC)==xFilial("SD3")+_cDocOri
					If SD3->D3_TM=="499" .AND. SD3->D3_ESTORNO<>"S" .AND. (SD3->D3_LOCAL == _cArmRec .OR. SD3->D3_LOCAL == _cArmNov)
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+SD3->D3_COD)
						RecLock("ZA4",.T.)
						ZA4->ZA4_FILIAL := xFilial("ZA4")
						ZA4->ZA4_OP		:= SC2->C2_NUM
						ZA4->ZA4_ARMAZE := SD3->D3_LOCAL
						ZA4->ZA4_PECA 	:= SD3->D3_COD
						ZA4->ZA4_QTDINI := SD3->D3_QUANT
						ZA4->ZA4_APLICA := SB1->B1_XMECELE
						MsUnlock()
					Endif
					dbSelectArea("SD3")
					dbSkip()
				EndDo
			Endif
		Endif
	Endif
Endif

RestArea(_aArea)

Return


Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Docto Original         ?','' ,'' , 'mv_ch1', 'C', 09, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Armazem Destino        ?','' ,'' , 'mv_ch2', 'C', 02, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Endere็o Destino       ?','' ,'' , 'mv_ch3', 'C', 15, 0,0, 'G', '', '', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')

Return
