#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include "hbutton.ch"
#include "TcBrowse.ch"
#include "apwizard.ch"

#define CTRL chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSS02FOG  ºAutor  ³Luciano Siqueira    º Data ³  24/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar Saida Orçamento Aprovado Acer                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSS02FOG()

Local aButtons    	:= {}

Private _cTicket   	:= Space(TamSX3("Z14_CSSNUM")[1])
Private _nQtdEq   	:= 0
Private aColsM1	    := {}
Private aHeadM1 	:= {}
Private aColsM2	    := {}
Private aHeadM2 	:= {}
Private aEdiCpo	  	:= {} //Campos a serem editados
Private aPosObj    	:= {}
Private aObjects   	:= {}
Private oGetDadM1   := Nil
Private oGetDadM2   := Nil
Private oDlg		:= Nil

Private aSize      	:= MsAdvSize(.T.)
Private nFreeze 	:= 2

Private cCodServ := GetMv("MV_XSERVAC",.F.,"SVCREPNOT")

oFont   := tFont():New('Tahoma',,-15,.t.,.t.) // 5o. Parâmetro negrito

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Alimenta o aheader 	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsAguarde({|| ADDAHEAD() })
MsAguarde({|| CRIATRB() })
MsAguarde({|| ADDACOLS(1) })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da Tela                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Saida Orçamento Aprovado" FROM aSize[7], 0 TO  aSize[6],  aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Getdados para Forecast |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}

aAdd( aObjects, {100,100, .T., .T.})
aAdd( aObjects, {100,100, .T., .T.})

aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj		:= MsObjSize( ainfo, aObjects )


@aPosObj[1,1],aPosObj[1,2]+5 To aPosObj[2,3]-5,aPosObj[2,4]-5 LABEL "" OF oDlg PIXEL

oSayDoc := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+010,{||"Ticket"},oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetDoc := tGet():New( aPosObj[1,1]+5,aPosObj[1,2]+060,{|u| Iif( PCount() > 0, _cTicket := u, _cTicket)},oDlg,60,,"@!",,,,,,,.T.,,,,,,,,,"","_cTicket")
oGetDoc:bValid 		:= {|| ValidZ14()}

oSayQSep := TSay():New( aPosObj[1,1]+5,aPosObj[1,2]+160,{||"Qtde" },oDlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,016)
oGetQSep := TGet():New( aPosObj[1,1]+5,aPosObj[1,2]+210,{|u| Iif( PCount() > 0, _nQtdEq := u, _nQtdEq)},oDlg,60,,'@E',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","_nQtdSep",,)


oGetDadM1 := MsNewGetDados():New(aPosObj[2,1]+15,aPosObj[2,2]+11,aPosObj[2,3]-10,aPosObj[2,4]-10,GD_UPDATE,"AllwaysTrue","AllwaysTrue","",aEdiCpo,nFreeze,9999,,,.T.,oDlg,aHeadM1,aColsM1)
oGetDadM1:oBrowse:bChange := {|| (oGetDadM1:nat) }

oGetDadM2 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2]+355,aPosObj[1,3]-35,aPosObj[1,4]-5,3,"AllwaysTrue","AllwaysTrue","",aEdiCpo,0,9999,,,.T.,oDlg,aHeadM2,aColsM2)
oGetDadM2:oBrowse:bChange := {|| (oGetDadM2:nat) }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| Processa({|| IIF(MSGYESNO("Gerar Pedido de Venda?"),ProcSaida(),)},"Processando..."), oDlg:End()},{||oDlg:End()},,aButtons)

If SELE("TRBFG")<>0
	TRBFG->(DbCloseArea())
Endif

If SELE("TRBFG1")<>0
	TRBFG1->(DbCloseArea())
Endif

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

Local cField := "Z14_CSSNUM/Z14_CLIENT/Z14_LOJA/Z14_PRODUT/Z14_SERIE/Z14_QUANT/Z14_VUNIT/Z14_NOTAE/Z14_SERIEE"
Local cField2:= "ZA9_CSSNUM/ZA9_PNCONS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Header para o primeiro get da tela |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to 2
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek(IIF(nI==1,"Z14","ZA9"))
	While !SX3->(EOF()) .And. SX3->X3_Arquivo == IIF(nI==1,"Z14","ZA9")
		If Trim(SX3->X3_Campo) $ IIF(nI==1,cField,cField2)
			AAdd(IIF(nI==1,aHeadM1,aHeadM2), {Trim(SX3->X3_Titulo),;
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
Next nI

Return

Static Function CRIATRB()

Local aCampos	:={}

AADD(aCampos,{"CSSNUM","C",TamSX3("Z14_CSSNUM")[1],0})

cArq := CriaTrab(aCampos,.t.)

If SELE("TRBFG")<>0
	TRBFG->(DbCloseArea())
Endif

dbUseArea(.T.,,cArq,"TRBFG",.F.)

IndRegua("TRBFG",cArq,"CSSNUM",,,"Criando Indice")

aCampos	:={}

AADD(aCampos,{"IDENTB6","C",TamSX3("B6_IDENT")[1],0})
AADD(aCampos,{"QUANT","N",TamSX3("B6_SALDO")[1],2})

cArq := CriaTrab(aCampos,.t.)

If SELE("TRBFG1")<>0
	TRBFG1->(DbCloseArea())
Endif

dbUseArea(.T.,,cArq,"TRBFG1",.F.)

IndRegua("TRBFG1",cArq,"IDENTB6",,,"Criando Indice")


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidZ14  ºAutor  ³Luciano Siqueira    º Data ³  31/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidZ14()

Local lRet := .T.

If !Empty(_cTicket)
	dbSelectArea("TRBFG")
	If dbSeek(_cTicket)
		MsgAlert("Ticket informado anteriormente. Favor verificar!")
	Else
		dbSelectArea("Z14")
		dbSetOrder(2)
		If dbSeek(xFilial("Z14")+_cTicket)
			If EMPTY(Z14->Z14_PEDIDO)
				lRet := .T.
				dbSelectArea("ZA9")
				dbSetOrder(1)
				If dbSeek(xFilial("ZA9")+Z14->Z14_CSSNUM)
					If ALLTRIM(UPPER(ZA9_TIPCLI)) == "DEALER"
						lRet := .F.
					Endif
				Endif
				If lRet
					dbSelectArea("ZZ4")
					ZZ4->(dbSetOrder(15))//ZZ4_FILIAL+ZZ4_IMEI+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA
					If dbSeek(xFilial("ZZ4")+Left(Z14->Z14_SERIE,TamSX3("ZZ4_IMEI")[1])+SPACE(3)+Z14->Z14_NOTAE+Z14->Z14_SERIEE+Z14->Z14_CLIENT+Z14->Z14_LOJA)//+Z14->Z14_PRODUT
						dbSelectArea("ZZ3")
						dbSetOrder(1)
						If !dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"01")
							U_GEZZ3AC(Z14->Z14_CSSNUM)
						Endif
						If Z14->Z14_WARRAN == "O"
							u_Issued({"02","02"},Z14->Z14_CSSNUM)
							lRet := .T.
							nVlrTit := ExistSE1()
							If nVlrTit == 0
								If MSGYESNO("Titulo Financeiro não encontrado. Deseja efetuar devolução do equipamento?")
									lRet := .T.
								Else
									lRet := .F.
								Endif
							Else
								lRet := ResPeGar()
								If !lRet
									MsgAlert("Existem peças que não foram reservadas para o ticket. Favor verificar!")
								Endif
							Endif
							If lRet
								lRetTer := .T.
								dbSelectArea("SD1")
								SD1->(dbSetOrder(1))
								If dbSeek(xFilial("SD1")+ZZ4->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_ITEMD1))
									dbSelectArea("SB6")//B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3
									dbSetOrder(3)
									If dbSeek(xFilial("SB6")+SD1->(D1_IDENTB6+D1_COD)+"R")
										If SB6->B6_SALDO == 0
											lRetTer := .F.
										Endif
									Endif
								Endif
								If lRetTer
									dbSelectArea("ZZ3")
									dbSetOrder(1)
									If dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"01")
										If nVlrTit > 0
											MsAguarde({|| ADDACOLS2() })
										Endif
										If ApMsgYesNo('Confere(m) a(s) peça(s) apontada(s) no Protheus x CSS?')
											MsAguarde({|| ADDACOLS(2) })
											_nQtdEq += 1
											oGetQSep:Refresh()
											DbSelectArea("TRBFG")
											RecLock("TRBFG",.T.)
											TRBFG->CSSNUM := _cTicket
											MsUnlock()
											dbSelectArea("ZZ4")
											RecLock("ZZ4",.F.)
											ZZ4->ZZ4_STATUS  := "7"
											ZZ4->ZZ4_SMUSER	 := Upper(Substr(cUserName,1,13))
											MsUnlock()
										Endif
										oGetDadM2:aCols:= {}
										AAdd(oGetDadM2:aCols, Array(Len(aHeadM2)+1))
										oGetDadM2:aCols[Len(oGetDadM2:aCols)][Len(aHeadM2)+1] := .F.
										oGetDadM2:Refresh()
									Else
										MsgAlert("Equipamento não encontrado em poder da produção. Favor verificar!")
									Endif
								Else
									MsgAlert("Equipamento sem saldo. Favor verificar se o mesmo ja foi faturado anteriormente!")
								Endif
							Endif
						Else
							MsgAlert("Equipamento não é fora de garantia. Favor verificar!")
						Endif
					Else
						MsgAlert("Entrada do equipamento não localizada nas tabelas do Protheus. Favor verificar!")
					Endif
				Else
					MsgAlert("Equipamento de Varejo efetuar saida pela rotina Devolução Varejo. Favor verificar!")
				Endif
			Else
				MsgAlert("Pedido gerado anteriormente. Favor verificar!")
			Endif
		Endif
	Endif
Endif
_cTicket:= Space(TamSX3("Z14_CSSNUM")[1])
oGetDoc:SetFocus()

Return(lRet)



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
Static Function ADDACOLS(nOpcao)

Local aArea 	 := GetArea()
Local nQtdM1  	 := Len(aHeadM1)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := Z14->(dbStruct())
Local cAliasTop5 := ""

If nOpcao == 1
	
	cAliasTop5	:= GetNextAlias()
	
	cQuery := " SELECT ZZ4_GVSOS, ZZ4.R_E_C_N_O_ AS RECZZ4 "
	cQuery += " FROM "+ RETSQLNAME("ZZ4")+" ZZ4 (nolock) "
	cQuery += " WHERE ZZ4_FILIAL  = '"+xFilial("ZZ4")+"' AND "
	cQuery += "      ZZ4_STATUS  = '7' AND "  // OS Encerrada
	cQuery += "      ZZ4_OPEBGH  = 'A01' AND "
	cQuery += "      ZZ4_PV      = ''  AND "
	cQuery += "      ZZ4.D_E_L_E_T_  = ''  AND "
	cQuery += "      SUBSTRING(ZZ4_SMUSER,1,13) = '"+Upper(Substr(cUserName,1,13))+"' "
	cQuery += "ORDER BY 1 "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cquery),cAliasTop5,.T.,.T.)
	(cAliasTop5)->(dbGoTop())
	
	If !(cAliasTop5)->(Eof())
		If ApMsgYesNo('Existe(m) Ticket(s) apontado(s) com o seu usuario. Deseja limpar os dados?')
			While !((cAliasTop5)->(Eof()))
				dbSelectArea("ZZ4")
				dbGoto((cAliasTop5)->RECZZ4)
				RecLock("ZZ4",.F.)
				ZZ4->ZZ4_STATUS  := "4"
				ZZ4->ZZ4_SMUSER	 := ""
				MsUnlock()
				(cAliasTop5)->(dbSkip())
			EndDo
		Else
			While !((cAliasTop5)->(Eof()))
				
				_cTicket := (cAliasTop5)->ZZ4_GVSOS
				
				cChave   := xFilial("Z14")+_cTicket
				
				dbSelectArea("Z14")
				dbSetOrder(2)
				
				If MsSeek(cChave)
					
					AAdd(aColsM1, Array(nQtdM1+1))
					
					nColuna := Len(aColsM1)
					
					For nM := 1 To Len(aCampos)
						
						cCpoZO := "Z14->" + aCampos[nM][1]
						
						nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
						If nPos > 0
							aColsM1[nColuna][nPos] := &cCpoZO
						EndIf
						
					Next nM
					
					aColsM1[nColuna][nQtdM1+1] := .F.
					
					_nQtdEq += 1
					
					DbSelectArea("TRBFG")
					RecLock("TRBFG",.T.)
					TRBFG->CSSNUM := _cTicket
					MsUnlock()
					
				EndIf
				
				(cAliasTop5)->(dbSkip())
			EndDo
		Endif
	Endif
	_cTicket   	:= Space(TamSX3("Z14_CSSNUM")[1])
	dbSelectArea(cAliasTop5)
	dbCloseArea()
Else
	
	cChave     := xFilial("Z14")+_cTicket
	
	dbSelectArea("Z14")
	dbSetOrder(2)
	
	If MsSeek(cChave)
		
		If !Empty(oGetDadM1:aCols[Len(oGetDadM1:aCols)][1])//IMEI
			AAdd(oGetDadM1:aCols, Array(nQtdM1+1))
		Endif
		
		nColuna := Len(oGetDadM1:aCols)
		
		For nM := 1 To Len(aCampos)
			
			cCpoZO := "Z14->" + aCampos[nM][1]
			
			nPos := AScan(aHeadM1, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
			If nPos > 0
				oGetDadM1:aCols[nColuna][nPos] := &cCpoZO
			EndIf
			
		Next nM
		
		oGetDadM1:aCols[nColuna][nQtdM1+1] := .F.
		
	EndIf
	oGetDadM1:Refresh()
Endif



RestArea(aArea)

Return



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
Static Function ADDACOLS2()

Local nQtdM2  	 := Len(aHeadM2)
Local nColuna 	 := 0
Local nPos		 := 0
Local cChave     := ""
Local aCampos	 := ZA9->(dbStruct())

cChave     := xFilial("ZA9")+_cTicket

dbSelectArea("ZA9")
dbSetOrder(1)

If MsSeek(cChave)
	
	While ZA9->(!EOF()) .and. ZA9->(ZA9_FILIAL+ZA9_CSSNUM) == xFilial("ZA9")+_cTicket
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+ZA9->ZA9_PNCONS) .and. !cCodServ$ZA9->ZA9_PNCONS
			If !Empty(oGetDadM2:aCols[Len(oGetDadM2:aCols)][1])
				AAdd(oGetDadM2:aCols, Array(nQtdM2+1))
			Endif
			
			nColuna := Len(oGetDadM2:aCols)
			
			For nM := 1 To Len(aCampos)
				
				cCpoZO := "ZA9->" + aCampos[nM][1]
				
				nPos := AScan(aHeadM2, {|aX| Alltrim(aX[2]) == Alltrim(aCampos[nM][1]) })
				If nPos > 0
					oGetDadM2:aCols[nColuna][nPos] := &cCpoZO
				EndIf
				
			Next nM
			
			oGetDadM2:aCols[nColuna][nQtdM2+1] := .F.
		Endif
		ZA9->(dbSkip())
	EndDo
EndIf

oGetDadM2:Refresh()

Return


Static Function ProcSaida()

Local aArea:=GetArea()
Local aCab 		:= {}
Local aItens   	:= {}
Local cItens    := '00'
Local lRet 		:= .T.

Private aPedSer		:= {}
Private aPedPGar	:= {}
Private aPedPFog	:= {}
Private aPedEqui	:= {}
Private aPedido 	:= {}

Private cFasFim   	:= GetMv("MV_XACAP02",.F.,"000001/01")
Private _cclifor	:= GetMv("ES_CLIACER",,"Z006HT")
Private _ccliloj 	:= GetMv("ES_LOJACER",,"01")
Private _cAntclfo 	:= GetMv("ES_ANCLACE",,"Z006HT")
Private _cAntcllj 	:= GetMv("ES_ANLJACE",,"01")
Private cTes 		:= GetMv("ES_TESPPAC",,"715")
Private cTesVenda 	:= GetMv("ES_TSVENPP",,"501")
Private cAmrzWO 	:= GetMv("ES_ARMZWO",,"AO")
Private cTesServ	:= SuperGetMV("BH_ACTESSV",  ,"804")
Private aNfOk		:= 	{}
Private nVlrDif		:= 0

dbSelectArea("TRBFG")
TRBFG->(dbGotop())
nCont  := 0
If TRBFG->(!EOF())
	While TRBFG->(!EOF())
		nCont ++
		IncProc("Processando, aguarde... " + StrZero(nCont,5) )
		dbSelectArea("Z14")
		dbSetOrder(2)
		If dbSeek(xFilial("Z14")+TRBFG->CSSNUM)
			lRet := .T.
			nVlrTit := ExistSE1()
			nVlrDif := nVlrTit
			If nVlrTit == 0
				lRet := .T.
			Else
				lRet := ResPeGar()
				If !lRet
					MsgAlert("Existem peças que não foram reservadas para o ticket "+ALLTRIM(Z14->Z14_CSSNUM)+". Favor verificar!")
				Endif
			Endif
			If lRet
				cItens    	:= '00'
				aCab 		:= {}
				aItens   	:= {}
				aPedSer		:= {}
				aPedPGar	:= {}
				aPedPFog	:= {}
				aPedEqui	:= {}
				aPedido 	:= {}
				aNFOK		:= {}
				
				dbSelectArea("ZZ4")
				ZZ4->(dbSetOrder(15))//ZZ4_FILIAL+ZZ4_IMEI+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA
				If dbSeek(xFilial("ZZ4")+Left(Z14->Z14_SERIE,TamSX3("ZZ4_IMEI")[1])+SPACE(3)+Z14->Z14_NOTAE+Z14->Z14_SERIEE+Z14->Z14_CLIENT+Z14->Z14_LOJA)//+Z14->Z14_PRODUT
					dbSelectArea("ZZ3")
					dbSetOrder(1)
					If dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"01")
						dbSelectArea("SD1")
						SD1->(dbSetOrder(1))
						If dbSeek(xFilial("SD1")+ZZ4->ZZ4_NFENR+ZZ4->ZZ4_NFESER+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA+ZZ4->ZZ4_CODPRO+ZZ4->ZZ4_ITEMD1)
							dbSelectArea("ZZJ")
							dbSetOrder(1)
							dbSeek(xFilial("ZZJ")+ZZ4->ZZ4_OPEBGH)
							If len(aCab) == 0
								dbSelectArea("SA1")
								dbSetOrder(1)
								dbSeek(xFilial("SA1")+Z14->Z14_CLIENT+Z14->Z14_LOJA)
								aCab  := {	{"C5_TIPO"		,"N"					,Nil},;
								{"C5_CLIENTE"	,SA1->A1_COD						,Nil},;
								{"C5_LOJACLI"	,SA1->A1_LOJA						,Nil},;
								{"C5_LOJAENT"	,SA1->A1_LOJA						,Nil},;
								{"C5_CONDPAG"	,'001'	   							,Nil},;
								{"C5_MENNOTA"	, Alltrim(Z14->Z14_CSSNUM)			,Nil},;
								{"C5_MENPAD"	, ""								,Nil},;
								{"C5_XUSER"		,alltrim(cusername)					,Nil},;
								{"C5_TRANSP"    ,ZZJ->ZZJ_TRANSP	                ,Nil},;
								{"C5_DIVNEG"    ,ZZJ->ZZJ_DIVNEG           			,Nil}}
							Endif
							
							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1")+ZZ4->ZZ4_CODPRO)
							
							_nQuant := Z14->Z14_QUANT
							_nVlUni := A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")
							_nVlTot := A410Arred(_nVlUni*_nQuant,"C6_VALOR")
							
							cNumPCom := Alltrim(Z14->Z14_CSSNUM)+Right(Alltrim(SD1->D1_DOC),6)
							cItemPC  := SD1->D1_ITEM
							
							cItens := Soma1(cItens,2)
							Aadd(aItens,{	{"C6_ITEM"		,cItens	        ,Nil},;
							{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
							{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
							{"C6_TES"		,"727"							,Nil},;
							{"C6_QTDVEN"	,_nQuant				  		,Nil},;
							{"C6_QTDLIB"	,_nQuant						,Nil},;
							{"C6_PRCVEN"	,_nVlUni						,Nil},;
							{"C6_VALOR"		,_nVlTot			   			,Nil},;
							{"C6_PRUNIT"	,_nVlUni						,Nil},;
							{"C6_NFORI"		,SD1->D1_DOC					,Nil},;
							{"C6_SERIORI"	,SD1->D1_SERIE					,Nil},;
							{"C6_ITEMORI"	,SD1->D1_ITEM					,Nil},;
							{"C6_IDENTB6"	,SD1->D1_IDENTB6				,Nil},;
							{"C6_LOCAL"		,SD1->D1_LOCAL					,Nil},;
							{"C6_NUMSERI"	,ZZ4->ZZ4_IMEI	  				,Nil},;
							{"C6_NUMOS"		,ZZ4->ZZ4_OS	                ,Nil},;
							{"C6_NUMPCOM"	,cNumPCom						,Nil},;
							{"C6_ITEMPC"	,cItemPC						,Nil},;
							{"C6_ENTREG"	,dDataBase						,Nil}})
							
							AADD(aPedEqui,{cItens,SB1->B1_COD})
							
							If nVlrTit > 0
								dbSelectArea("SC0")
								dbSetOrder(3)
								If dbSeek(xFilial("SC0")+Z14->Z14_CSSNUM)
									While SC0->(!EOF()) .and. SC0->(C0_FILIAL+C0_XCSSNUM) == xFilial("SC0")+Z14->Z14_CSSNUM
										If SC0->C0_QUANT > 0
											dbSelectArea("SB1")
											dbSetOrder(1)
											dbSeek(xFilial("SB1")+SC0->C0_PRODUTO)
											
											dbselectarea("SB2")
											dbsetorder(1)
											dbseek(xFilial("SB2")+SB1->B1_COD+SC0->C0_LOCAL)
											
											If SC0->C0_LOCAL <> cAmrzWO
												nPreco	:= SB2->B2_CM1
												aItemTerc := salp3alt(SC0->C0_PRODUTO,_cclifor,_ccliloj,SC0->C0_QUANT,SC0->C0_LOCAL)
												
												If Len(aItemTerc) > 0
													For nT := 1 to Len(aItemTerc)
														If SC0->C0_LOCAL == "AN" //ACER NACIONAL
															cTes := "903"
														ElseIf SC0->C0_LOCAL == "AI" //ACER IMPORTADA
															cTes := "743"
														ElseIf SC0->C0_LOCAL == "AT"
															If aItemTerc[nT][7] == "338" //ACER TRIBUTOS ICMS/ST
																cTes := "841"
															ElseIf aItemTerc[nT][7] == "329" //PEÇAS IMPORTADAS C/ ICMS/ICMS/ST E IPI
																cTes := "855"
															ElseIf aItemTerc[nT][7] == "326" //PEÇAS NACIONAIS SEM  ICMS/ ICMS/ST
																cTes := "831"
															EndIf
														ElseIf SC0->C0_LOCAL == "AR" //ACER RECUPERADA
															cTes := "715" //716
														ElseIf SC0->C0_LOCAL == "AD" //ACER DEVOLUÇÃO
															cTes := "762"
														ElseIf SC0->C0_LOCAL == "SA" //SCRAP ACER
															cTes := "762"
														ElseIf SC0->C0_LOCAL == "AE" //ACER EQUIPAMENTOS
															cTes := "727"
														ElseIf SC0->C0_LOCAL == "AF" //COMPRA ACER FORA DE GARANTIA
															cTes := "787"
														EndIf
														
														cNumPCom := Alltrim(Z14->Z14_CSSNUM)+Right(Alltrim(aItemTerc[nT][1]),6)
														cItemPC  := aItemTerc[nT][8]
														cItens  := Soma1(cItens,2)
														Aadd(aItens,{	{"C6_ITEM"		,cItens        ,Nil},;
														{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
														{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
														{"C6_TES"		,cTes							,Nil},;
														{"C6_QTDVEN"	,aItemTerc[nT][5]		  		,Nil},;
														{"C6_QTDLIB"	,aItemTerc[nT][5]				,Nil},;
														{"C6_PRCVEN"	,aItemTerc[nT][6]				,Nil},;
														{"C6_VALOR"		,aItemTerc[nT][5]*aItemTerc[nT][6],Nil},;
														{"C6_PRUNIT"	,aItemTerc[nT][6]				,Nil},;
														{"C6_NFORI"		,aItemTerc[nT][1]				,Nil},;
														{"C6_SERIORI"	,aItemTerc[nT][2]				,Nil},;
														{"C6_ITEMORI"	,aItemTerc[nT][8]				,Nil},;
														{"C6_IDENTB6"	,aItemTerc[nT][4]				,Nil},;
														{"C6_LOCAL"		,SC0->C0_LOCAL					,Nil},;
														{"C6_RESERVA"	,SC0->C0_NUM	  				,Nil},;
														{"C6_NUMPCOM"	,cNumPCom						,Nil},;
														{"C6_ITEMPC"	,cItemPC						,Nil},;
														{"C6_ENTREG"	,dDataBase						,Nil}})
														
														AADD(aPedPGar,{cItens,SB1->B1_COD})
														
													Next nT
												Else
													cNumPCom := Alltrim(Z14->Z14_CSSNUM)
													cItemPC  := ""
													cItens  := Soma1(cItens,2)
													Aadd(aItens,{	{"C6_ITEM"		,cItens         ,Nil},;
													{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
													{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
													{"C6_TES"		,cTes							,Nil},;
													{"C6_QTDVEN"	,SC0->C0_QUANT			  		,Nil},;
													{"C6_QTDLIB"	,SC0->C0_QUANT					,Nil},;
													{"C6_PRCVEN"	,nPreco							,Nil},;
													{"C6_VALOR"		,nPreco*SC0->C0_QUANT			,Nil},;
													{"C6_PRUNIT"	,nPreco							,Nil},;
													{"C6_NFORI"		,""								,Nil},;
													{"C6_SERIORI"	,""								,Nil},;
													{"C6_ITEMORI"	,""								,Nil},;
													{"C6_IDENTB6"	,""								,Nil},;
													{"C6_LOCAL"		,SC0->C0_LOCAL					,Nil},;
													{"C6_RESERVA"	,SC0->C0_NUM	  				,Nil},;
													{"C6_NUMPCOM"	,cNumPCom						,Nil},;
													{"C6_ITEMPC"	,cItemPC						,Nil},;
													{"C6_ENTREG"	,dDataBase						,Nil}})
													
													AADD(aPedPGar,{cItens,SB1->B1_COD})
												Endif
											Else
												_cTesFog :="787"
												_cCFCom	 :=""
												If SB1->B1_ORIGEM == "0"
													_cTesFog :="787"
													_cCFCom  :=""
												ElseIf SB1->B1_ORIGEM  == "1"
													_cCFCom := SD1->D1_CF
												Endif
												
												IF _cCFCom == "1403" .and. SA1->A1_EST = "SP"
													_cTesFog :="858"
												ElseIf _cCFCom == "1403" .AND. ((SA1->A1_EST <> "SP" .AND. SA1->A1_PESSOA <> "J") .OR. (SA1->A1_EST <> "SP" .AND. SA1->A1_PESSOA = "J" .AND. (EMPTY(SA1->A1_INSCR) .OR. ALLTRIM(SA1->A1_INSCR)="ISENTO")))
													_cTesFog :="937"
												ElseIf  SA1->A1_EST <> "SP" .AND. SA1->A1_PESSOA = "J" .AND. !EMPTY(SA1->A1_INSCR) .AND. ALLTRIM(SA1->A1_INSCR)<>"ISENTO"
													_cTesFog :="837"
												Endif
												
												nPrcVen 	:= GetPrcVen(SC0->C0_PRODUTO,Z14->Z14_CLIENT,Z14->Z14_LOJA)
												nVlrDif 	-= IIF(nVlrTit > 0, nPrcVen, 0)
												cNumPCom 	:= Alltrim(Z14->Z14_CSSNUM)
												cItemPC  	:= ""
												cItens  	:= Soma1(cItens,2)
												Aadd(aItens,{	{"C6_ITEM"		,cItens        ,Nil},;
												{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
												{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
												{"C6_TES"		,_cTesFog						,Nil},;
												{"C6_QTDVEN"	,SC0->C0_QUANT			  		,Nil},;
												{"C6_QTDLIB"	,SC0->C0_QUANT					,Nil},;
												{"C6_PRCVEN"	,nPrcVen						,Nil},;
												{"C6_VALOR"		,nPrcVen*SC0->C0_QUANT			,Nil},;
												{"C6_PRUNIT"	,nPrcVen						,Nil},;
												{"C6_NFORI"		,""								,Nil},;
												{"C6_SERIORI"	,""								,Nil},;
												{"C6_ITEMORI"	,""								,Nil},;
												{"C6_IDENTB6"	,""								,Nil},;
												{"C6_LOCAL"		,SC0->C0_LOCAL					,Nil},;
												{"C6_RESERVA"	,SC0->C0_NUM	  				,Nil},;
												{"C6_NUMPCOM"	,cNumPCom						,Nil},;
												{"C6_ITEMPC"	,cItemPC						,Nil},;
												{"C6_ENTREG"	,dDataBase						,Nil}})
												
												AADD(aPedPFog,{cItens,SB1->B1_COD})
											Endif
										Endif
										SC0->(dbSkip())
									EndDo
								Endif
							Endif
							dbSelectArea("ZA9")
							dbSetOrder(1)
							If dbSeek(xFilial("ZA9")+Z14->Z14_CSSNUM)
								While ZA9->(!EOF()) .and. ZA9->(ZA9_FILIAL+ZA9_CSSNUM) == xFilial("ZA9")+Z14->Z14_CSSNUM
									If Alltrim(ZA9->ZA9_PNCONS)==Alltrim(cCodServ)
										cProSer := "800071.9"
										dbSelectArea("SB1")
										dbSetOrder(1)
										dbSeek(xFilial("SB1")+cProSer)
										
										nPrcVen := ZA9->ZA9_PRECO
										nVlrDif -= IIF(nVlrTit > 0,nPrcVen,0)
										If nVlrDif > 0
											nPrcVen := nPrcVen+nVlrDif
										Endif
										
										cNumPCom := Alltrim(Z14->Z14_CSSNUM)
										cItemPC  := ""
										cItens  := Soma1(cItens,2)
										Aadd(aItens,{	{"C6_ITEM"		,cItens         ,Nil},;
										{"C6_PRODUTO"	,SB1->B1_COD				    ,Nil},;
										{"C6_DESCRI"	,SB1->B1_DESC			   		,Nil},;
										{"C6_TES"		,cTesServ						,Nil},;
										{"C6_QTDVEN"	,1						  		,Nil},;
										{"C6_QTDLIB"	,1								,Nil},;
										{"C6_PRCVEN"	,nPrcVen						,Nil},;
										{"C6_VALOR"		,nPrcVen						,Nil},;
										{"C6_PRUNIT"	,nPrcVen						,Nil},;
										{"C6_NFORI"		,""								,Nil},;
										{"C6_SERIORI"	,""								,Nil},;
										{"C6_ITEMORI"	,""								,Nil},;
										{"C6_IDENTB6"	,""								,Nil},;
										{"C6_LOCAL"		,"51"							,Nil},;
										{"C6_RESERVA"	,""				  				,Nil},;
										{"C6_NUMPCOM"	,cNumPCom						,Nil},;
										{"C6_ITEMPC"	,cItemPC						,Nil},;
										{"C6_ENTREG"	,dDataBase						,Nil}})
										
										AADD(aPedSer,{cItens,SB1->B1_COD})
									Endif
									ZA9->(dbSkip())
								EndDo
							Endif
							If len(aCab) > 0 .and. len(aItens) > 0
								lMsErroAuto := .F.
								MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3)
								If lMsErroAuto
									MsgAlert("Problema na geração do pedido. Favor verificar!")
									MostraErro()
								Else
									aadd(aPedido,{SC5->C5_NUM})
									AtuDados()
									If ApMsgYesNo("Pedido "+SC5->C5_NUM+" gerado com sucesso. Deseja gerar a(s) NF(s)?")
										GeraNFAC()
										cMsgNF:=""
										If len(aNFOK) > 0
											For nx:=1 To Len(aNfOk)
												dbSelectArea("SE1")
												dbSetOrder(2)
												If dbSeek(xFilial("SE1")+aNfOk[nx][3]+aNfOk[nx][4]+aNfOk[nx][1]+aNfOk[nx][2])
													RecLock("SE1",.F.)
													SE1->E1_XCSSNUM := Z14->Z14_CSSNUM
													If nVlrDif < 0 .and. SE1->E1_PREFIXO <> "RPS"
														nVlrDif := nVlrDif * -1
														SE1->E1_DECRESC := nVlrDif
														nVlrDif := 0
													Endif
													SE1->(MsUnlock())
												Endif
												cMsgNF+="NF: "+Alltrim(aNfOk[nx][2])+" Serie: "+Alltrim(aNfOk[nx][1])+CRLF
											Next nx
											MsgInfo(cMsgNF)
										EndIf
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
		TRBFG->(!dbSkip())
	EndDo
Endif

RestArea(aArea)

Return

Static Function AtuDados()

Local aArea:=GetArea()

For nI := 1 to Len(aPedPGar)
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SC5->C5_NUM+aPedPGar[nI][1]+aPedPGar[nI][2])
		While SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO)==xFilial("SC6")+SC5->C5_NUM+aPedPGar[nI][1]+aPedPGar[nI][2]
			cCodTec := Posicione("AA1",4,xFilial("AA1") + __cUserID,"AA1_CODTEC")
			nQtdGar := QtdeGar()
			dbSelectArea("SZ9")
			dbSetORder(4)
			If !dbSeek(xFilial("SZ9")+ZZ3->ZZ3_NUMOS+ZZ3->ZZ3_SEQ+SC6->C6_PRODUTO,.F.)
				RecLock("SZ9",.T.)
				SZ9->Z9_FILIAL 	:= 	xFilial("SZ9")
				SZ9->Z9_NUMOS	:=	ZZ4->ZZ4_OS
				SZ9->Z9_SEQ		:=	ZZ3->ZZ3_SEQ
				SZ9->Z9_CODTEC	:= 	ZZ3->ZZ3_CODTEC
				SZ9->Z9_ITEM	:=	"01"
				SZ9->Z9_QTY		:=	SC6->C6_QTDVEN
				SZ9->Z9_PARTNR	:=	SC6->C6_PRODUTO
				SZ9->Z9_USED	:=	"0"
				SZ9->Z9_IMEI	:= 	ZZ4->ZZ4_IMEI
				SZ9->Z9_STATUS	:=	"1"
				SZ9->Z9_FASE1	:=	ZZ3->ZZ3_FASE1
				SZ9->Z9_PREVCOR	:=	"C"
				SZ9->Z9_LOCAL	:=	SC6->C6_LOCAL
				SZ9->Z9_COLETOR	:=	"S"
				SZ9->Z9_USRINCL	:= AllTrim(cCodTec)  + " - " + AllTrim(cUsername)
				SZ9->Z9_SYSORIG	:= "9"//Verificar qual a origem utilizaremos
				MSUnlock()
			Else
				
				RecLock("SZ9",.F.)
				SZ9->Z9_QTY		:= 	nQtdGar
				MSUnlock()
			Endif
			dbSelectArea("ZZQ")
			dbSetOrder(3)
			If !dbSeek(xFilial("ZZQ")+SC6->C6_PRODUTO+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS,.F.)
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
				dbSelectArea("SB6")
				dbSetOrder(3)
				dbSeek(xFilial("SB6")+SC6->C6_IDENTB6+SC6->C6_PRODUTO+"R")
				cArmPeca := ArmPeca(Z14->Z14_CSSNUM,SC6->C6_PRODUTO)
				dbSelectArea("ZZQ")
				Reclock("ZZQ",.T.)
				ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
				ZZQ->ZZQ_IMEI   := ZZ4->ZZ4_IMEI
				ZZQ->ZZQ_NUMOS  := ZZ4->ZZ4_OS
				ZZQ->ZZQ_MODELO := ZZ4->ZZ4_CODPRO
				ZZQ->ZZQ_CODEST := SB1->B1_GRUPO
				ZZQ->ZZQ_DTSAID := dDataBase
				ZZQ->ZZQ_PV     := SC6->C6_NUM
				ZZQ->ZZQ_ITEMPV := SC6->C6_ITEM
				ZZQ->ZZQ_CLISAI := SC6->C6_CLI
				ZZQ->ZZQ_LOJSAI := SC6->C6_LOJA
				ZZQ->ZZQ_PECA   := SC6->C6_PRODUTO
				ZZQ->ZZQ_QTDE   := SC6->C6_QTDVEN
				ZZQ->ZZQ_VLRUNI := SC6->C6_PRCVEN
				ZZQ->ZZQ_VLRTOT := SC6->C6_VALOR
				ZZQ->ZZQ_NFORI  := SC6->C6_NFORI
				ZZQ->ZZQ_SERORI := SC6->C6_SERIORI
				ZZQ->ZZQ_CLIORI := SB6->B6_CLIFOR
				ZZQ->ZZQ_LOJORI := SB6->B6_LOJA
				ZZQ->ZZQ_OPEBGH := ZZ4->ZZ4_OPEBGH
				ZZQ->ZZQ_ARMAZ	:= cArmPeca
				msunlock()
			Else
				RecLock("ZZQ",.F.)
				ZZQ->ZZQ_QTDE := nQtdGar
				MSUnlock()
			Endif
			SC6->(dbSkip())
		EndDo
	Endif
Next nI

For nI := 1 to Len(aPedEqui)
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SC5->C5_NUM+aPedEqui[nI][1]+aPedEqui[nI][2])
		While SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO)==xFilial("SC6")+SC5->C5_NUM+aPedEqui[nI][1]+aPedEqui[nI][2]
			cCodTec := Posicione("AA1",4,xFilial("AA1") + __cUserID,"AA1_CODTEC")
			cLab 	:= Posicione("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_LAB")
			dbSelectArea("Z14")
			RecLock("Z14",.F.)
			Z14->Z14_STATUS := "S"
			Z14->Z14_PEDIDO := SC5->C5_NUM
			Z14->Z14_USRSAI := cUserName
			MSUnLock()
			dbSelectArea("ZZ4")
			RecLock("ZZ4",.F.)
			ZZ4->ZZ4_PV     := SC5->C5_NUM + SC6->C6_ITEM
			ZZ4->ZZ4_STATUS := "8"
			msunlock()
			dbSelectArea("ZZ3")
			dbSetOrder(1)
			If !dbSeek(xFilial("ZZ3")+ZZ4->ZZ4_IMEI+ZZ4->ZZ4_OS+"02")
				dbSelectArea("ZZ3")
				RecLock("ZZ3",.T.)
				ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
				ZZ3->ZZ3_CODTEC := cCodTec
				ZZ3->ZZ3_LAB    := cLab
				ZZ3->ZZ3_DATA   := date()
				ZZ3->ZZ3_HORA   := Time()
				ZZ3->ZZ3_CODSET := Substr(cFasFim,1,6)
				ZZ3->ZZ3_FASE1  := Substr(cFasFim,8,2)
				ZZ3->ZZ3_CODSE2 := Substr(cFasFim,1,6)
				ZZ3->ZZ3_FASE2  := Substr(cFasFim,8,2)
				ZZ3->ZZ3_ENCOS  := "S"
				ZZ3->ZZ3_IMEI   := ZZ4->ZZ4_IMEI
				ZZ3->ZZ3_SWAP   := ""
				ZZ3->ZZ3_IMEISW := ""
				ZZ3->ZZ3_MODSW  := ""
				ZZ3->ZZ3_UPGRAD := ""
				ZZ3->ZZ3_NUMOS  := ZZ4->ZZ4_OS
				ZZ3->ZZ3_STATUS := "1"
				ZZ3->ZZ3_SEQ    := u_CalcSeq(ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS)
				ZZ3->ZZ3_USER   := cUserName
				ZZ3->ZZ3_ACAO   := ""
				ZZ3->ZZ3_LAUDO  := ""
				ZZ3->ZZ3_COR    := ZZ4->ZZ4_COR
				ZZ3->ZZ3_ESTORN := "N"
				ZZ3->ZZ3_STATRA := "0"
				ZZ3->ZZ3_ASCRAP := "N"
				MsUnlock()
			Endif
			SC6->(dbSkip())
		EndDo
	Endif
Next nI

RestArea(aArea)

Return

Static Function salp3alt(_cprodalt,_cclifor,_ccliloj,nsalpalt,_cArmC0)

Local _aselpalt := {}
Local _nsapalp3 := 0

If select("P3PALT") > 0
	P3PALT->(dbCloseArea())
EndIf

_cQryP3 := " SELECT B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT,B6_TES,D1_ITEM "
_cQryP3 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
_cQryP3 += " INNER JOIN "+RetSqlName("SD1")+" AS SD1 (nolock) ON "
_cQryP3 += "        D1_FILIAL = '"+xFilial("SD1")+"' AND "
_cQryP3 += "        D1_DOC=B6_DOC AND "
_cQryP3 += "        D1_SERIE=B6_SERIE AND "
_cQryP3 += "        D1_FORNECE=B6_CLIFOR AND "
_cQryP3 += "        D1_LOJA=B6_LOJA AND "
_cQryP3 += "        D1_COD=B6_PRODUTO AND "
_cQryP3 += "        D1_IDENTB6=B6_IDENT AND "
_cQryP3 += "        SD1.D_E_L_E_T_ = '' "
_cQryP3 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
_cQryP3 += "        B6_PRODUTO = '"+_cprodalt+"' AND "
_cQryP3 += "        B6_CLIFOR  = '"+_cclifor+"' AND "
_cQryP3 += "        B6_LOJA    = '"+_ccliloj+"' AND "
_cQryP3 += "        B6_SALDO >= CAST('"+AllTrim(str(nsalpalt))+"' AS NUMERIC) AND "
_cQryP3 += "        B6_LOCAL <> 'AE' AND "
_cQryP3 += "        B6.D_E_L_E_T_ = '' "
_cQryP3 += " ORDER BY B6_IDENT DESC "
TCQUERY _cQryP3 NEW ALIAS "P3PALT"

P3PALT->(dbGoTop())

While P3PALT->(!Eof()) .and. nsalpalt > 0
	_nsapalp3 := SalDisP3(P3PALT->B6_IDENT, P3PALT->B6_SALDO)
	_nQtRet3 := iif(_nsapalp3 >= nsalpalt, nsalpalt,_nsapalp3)
	
	If _nQtRet3 > 0
		nsalpalt  := nsalpalt - _nQtRet3
		AADD(_aselpalt,{P3PALT->B6_DOC,P3PALT->B6_SERIE,P3PALT->B6_LOCAL,P3PALT->B6_IDENT,_nQtRet3,P3PALT->B6_PRUNIT,P3PALT->B6_TES,P3PALT->D1_ITEM})
		DbSelectArea("TRBFG1")
		If dbSeek(P3PALT->B6_IDENT)
			RecLock("TRBFG1",.F.)
			TRBFG1->QUANT := TRBFG1->QUANT+_nQtRet3
			MsUnlock()
		Else
			RecLock("TRBFG1",.T.)
			TRBFG1->IDENTB6 	:= P3PALT->B6_IDENT
			TRBFG1->QUANT 	:= _nQtRet3
			MsUnlock()
		Endif
	EndIf
	P3PALT->(dbSkip())
EndDo
Return(_aselpalt)

Static Function SalDisP3(_cIdent, _nSalSB6)
Local _aAreaSC6  := SC6->(GetArea())
Local _nSalDisP3 := _nQtPV3:= 0
Local _cqry      := ""
SC6->(dbSetOrder(12))  // C6_FILIAL + C6_IDENTB6
If Select("Qrysc6") > 0
	Qrysc6->(dbCloseArea())
EndIf
_cqry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDSC6 "+CTRL
_cqry += " FROM "+RETSQLNAME("SC6")+" (NOLOCK) WHERE C6_FILIAL='"+xFILIAL("SC6")+"' AND C6_IDENTB6='"+_cIdent+"' AND D_E_L_E_T_='' AND (C6_QTDVEN-C6_QTDENT) > 0 "+CTRL
TCQUERY _cqry ALIAS "Qrysc6" NEW
dbSelectArea("Qrysc6")
If Select("Qrysc6") > 0
	_nQtPV3 :=Qrysc6->QTDSC6
EndIf
_nSalDisP3 := _nSalSB6 - _nQtPV3

dbSelectArea("TRBFG1")
If dbSeek(_cIdent)
	_nSalDisP3 := _nSalSB6 - TRBFG1->QUANT
Endif

restarea(_aAreaSC6)
return(_nSalDisP3)


Static Function ArmPeca(cCssNum,cPeca)

Local cArmPeca 	:= ""
Local cTOWH 	:= GetMv("ES_XTOWH",,"502;701")

cq := " SELECT "
cq += "		Z18.Z18_TOWH "
cq += " FROM "
cq += "		( "
cq += "			SELECT "
cq += "				MAX(TRBZ18.R_E_C_N_O_) AS RECZ18 "
cq += "			FROM "+RETSQLNAME("Z18")+ "  TRBZ18 "
cq += "			WHERE "
cq += "				Z18_FILIAL='"+xFilial("Z18")+"' AND "
cq += "				Z18_CSSNUM = '"+cCssNum+"' AND "
cq += "				Z18_PRODUT = '"+cPeca+"' AND "
cq += "				Z18_TOWH IN "+FormatIn(cTOWH,';')+ " AND "
cq += "				TRBZ18.D_E_L_E_T_ = '' "
cq += "		) AS TRB "
cq += "	INNER JOIN "+RETSQLNAME("Z18")+ " Z18 ON "
cq += "		Z18_FILIAL='"+xFilial("Z18")+"' AND "
cq += "		Z18.R_E_C_N_O_= TRB.RECZ18 AND "
cq += "		Z18.D_E_L_E_T_ = '' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERYZ18",.F.,.T.)

IF(!QUERYZ18->(eof()))
	cArmPeca := IIF(QUERYZ18->Z18_TOWH=="502","AD","SA")
ENDIF

QUERYZ18->(dbclosearea())

Return(cArmPeca)


Static Function GeraNFAC()

Local aAreaAtu  := GetArea()
Local aPvlNfs   := {}
Local aBloqueio := {{"","","","","","","",""}}
Local aNotas    := {}
Local cSerie	:=	"1"
Private aAuxNF	:=  {}

For i:=1 to len(aPedido)
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+aPedido[i,1])
		//Liberando Bloqueios do Pedido
		SC9->(dbSetOrder(1))
		If SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM))
			While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
				RecLock("SC9",.F.)
				If SC9->C9_BLEST <> "10"
					SC9->C9_BLEST  := ""
				EndIf
				If SC9->C9_BLCRED <> "10"
					SC9->C9_BLCRED := ""
				EndIf
				SC9->(MsUnlock())
				SC9->(dbSkip())
			EndDo
		EndIf
		
		// Checa itens liberados
		IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
	EndIf
Next i
//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
cNotaFeita :=""
If Empty(aBloqueio) .And. !Empty(aPvlNfs)
	nItemNf  := a460NumIt(cSerie)
	
	If Len(aPedEqui) > 0
		aadd(aNotas,{})
		For nX := 1 To Len(aPvlNfs)
			For i:=1 to Len(aPedEqui)
				If aPvlNfs[nX][2] == aPedEqui[i][1]
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
				EndIf
			Next i
		Next nX
	EndIf
	
	If Len(aPedPGar) > 0
		aadd(aNotas,{})
		For nX := 1 To Len(aPvlNfs)
			For i:=1 to Len(aPedPGar)
				If aPvlNfs[nX][2] == aPedPGar[i][1]
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
				EndIf
			Next i
		Next nX
	EndIf
	
	If Len(aPedPFog) > 0
		aadd(aNotas,{})
		For nX := 1 To Len(aPvlNfs)
			For i:=1 to Len(aPedPFog)
				If aPvlNfs[nX][2] == aPedPFog[i][1]
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
				EndIf
			Next i
		Next nX
	EndIf
	
	If Len(aPedSer) > 0
		aadd(aNotas,{})
		For nX := 1 To Len(aPvlNfs)
			For i:=1 to Len(aPedSer)
				If aPvlNfs[nX][2] == aPedSer[i][1]
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
				EndIf
			Next i
		Next nX
	EndIf
	
	For nX := 1 To Len(aNotas)
		//Gera a Nota Fiscal
		IncProc( "Gerando Nota Fiscal " )
		IF aNotas[nX][1][2] = aPedSer[1][1]
			cSerie := "RPS"
		ELSE
			cSerie := "1"
		ENDIF
		cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
		aADD(aNfOk,{SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA})
	Next nX
EndIf

RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESPEGAR  ºAutor  ³Luciano Siqueira    º Data ³  17/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function ResPeGar()

Local lRet := .T.

If Select("QRYSC0") > 0
	QRYSC0->(dbCloseArea())
EndIf
_cQryC0 := " SELECT "
_cQryC0 += " 	ZA9_CSSNUM, "
_cQryC0 += " 	ZA9_PNCONS, "
_cQryC0 += " 	COUNT(1) AS QTDZA9, "
_cQryC0 += " 	( "
_cQryC0 += " 		SELECT "
_cQryC0 += " 			ISNULL(SUM(C0_QUANT) ,0) "
_cQryC0 += " 		FROM "+RETSQLNAME("SC0")+" SC0 (NOLOCK) "
_cQryC0 += " 		WHERE "
_cQryC0 += " 			C0_FILIAL='"+xFILIAL("SC0")+"' AND "
_cQryC0 += " 			C0_XCSSNUM=ZA9_CSSNUM AND "
_cQryC0 += " 			C0_PRODUTO=ZA9_PNCONS AND "
_cQryC0 += " 			SC0.D_E_L_E_T_ ='' "
_cQryC0 += " 	) AS QTDSC0 "
_cQryC0 += " FROM "+RETSQLNAME("ZA9")+" ZA9 (NOLOCK) "
_cQryC0 += " WHERE "
_cQryC0 += " 	ZA9_FILIAL='"+xFILIAL("ZA9")+"' AND "
_cQryC0 += " 	ZA9_CSSNUM = '"+Z14->Z14_CSSNUM+"' AND "
_cQryC0 += " 	ZA9_PNCONS <> '"+cCodServ+"' AND "
_cQryC0 += " 	ZA9.D_E_L_E_T_='' "
_cQryC0 += " GROUP BY ZA9_CSSNUM,ZA9_PNCONS "

TCQUERY _cQryC0 NEW ALIAS "QRYSC0"

QRYSC0->(dbGoTop())
While QRYSC0->(!EOF())
	If QRYSC0->QTDZA9 > QRYSC0->QTDSC0
		lRet := .F.
	Endif
	QRYSC0->(dbSkip())
EndDo

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESPEGAR  ºAutor  ³Luciano Siqueira    º Data ³  17/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExistSE1()

Local nVlrTit := 0

If Select("QRYSE1") > 0
	QRYSE1->(dbCloseArea())
EndIf
_cQryE1 := " SELECT "
_cQryE1 += " 	SUM(E1_VALOR) AS VLRTIT "
_cQryE1 += " FROM "+RETSQLNAME("SE1")+" SE1 (NOLOCK) "
_cQryE1 += " WHERE "
_cQryE1 += " 	E1_FILIAL='"+xFILIAL("SE1")+"' AND "
_cQryE1 += " 	E1_CLIENTE = '"+Z14->Z14_CLIENT+"' AND "
_cQryE1 += " 	E1_LOJA = '"+Z14->Z14_LOJA+"' AND "
_cQryE1 += " 	E1_TIPO = 'RA' AND "
_cQryE1 += " 	E1_XCSSNUM = '"+Z14->Z14_CSSNUM+"' AND "
_cQryE1 += " 	SE1.D_E_L_E_T_='' "

TCQUERY _cQryE1 NEW ALIAS "QRYSE1"

QRYSE1->(dbGoTop())
If QRYSE1->(!EOF())
	nVlrTit := QRYSE1->VLRTIT
Endif

Return(nVlrTit)
/*
=============================================================================================================================================================
Programa  : GetPrcVen
=============================================================================================================================================================
*/
Static Function GetPrcVen(cProd,cCliente,cLoja)

Local cCodTab := ""
Local nPrecVen := 0
Local aArea := GetArea()

If Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_PESSOA") == "F"
	cCodTab := "AC2"
ElseIf Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_PESSOA") == "J"
	cCodTab := "AC1"
EndIf

If Select("DA1") == 0
	DbSelectArea("DA1")
EndIf
DA1->(DbSetOrder(1))
DA1->(DbGoTop())

If DA1->(DbSeek(xFilial("DA1")+cCodTab+cProd))
	While DA1->(!EOF()) .and. cProd == DA1->DA1_CODPRO
		nPrecVen := DA1->DA1_PRCVEN
		DA1->(DbSkip())
	EndDo
EndIf

RestArea(aArea)

Return nPrecVen

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QTDEGAR   ºAutor  ³Luciano Siqueira    º Data ³  17/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QtdeGar()

Local nQtde:= 0

If Select("QRYSC6") > 0
	QRYSC6->(dbCloseArea())
EndIf

_cQryC6 := " SELECT "
_cQryC6 += " 	SUM(C6_QTDVEN) AS QTD "
_cQryC6 += " FROM "+RETSQLNAME("SC6")+" SC6 (NOLOCK) "
_cQryC6 += " WHERE "
_cQryC6 += " 	C6_FILIAL='"+xFILIAL("SC6")+"' AND "
_cQryC6 += " 	C6_NUM = '"+SC6->C6_NUM+"' AND "
_cQryC6 += " 	C6_PRODUTO = '"+SC6->C6_PRODUTO+"' AND "
_cQryC6 += " 	C6_LOCAL <> 'AO' AND "
_cQryC6 += " 	SC6.D_E_L_E_T_ = '' "

TCQUERY _cQryC6 NEW ALIAS "QRYSC6"

QRYSC6->(dbGoTop())
If QRYSC6->(!EOF())
	nQtde := QRYSC6->QTD
Endif

Return(nQtde)
