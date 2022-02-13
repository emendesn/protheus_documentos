#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE MAXMENLIN 067
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor ³Carlos Vieira       º Data ³  03/01/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BGH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PE01NFESEFAZ()
Local aArea		:= GetArea()
Local aAreaSA1
Local aAreaSA5
Local aAreaSB1
Local aAreaSB5
Local aAreaSC5
Local aAreaSC6
Local aAreaSD2
Local cPerg		:= "PERGNFE"
Local cTes		:= ""
Local aParam	:= PARAMIXB
Local aProd		:= PARAMIXB[01]
Local cMensCli	:= PARAMIXB[02]
Local cMensFis	:= PARAMIXB[03]
Local aDest		:= PARAMIXB[04]
Local aNota		:= PARAMIXB[05]
Local aInfoItem	:= PARAMIXB[06]
Local aICMS		:= {}
Local aIPI		:= {}
Local aICMSST	:= {}
Local aPIS		:= {}
Local aPISST	:= {}
Local aCOFINS	:= {}
Local aCOFINSST	:= {}
Local aISSQN	:= {}
Local aEspVol	:= {}
Local aDI		:= {}
Local aAdi		:= {}
Local aExp		:= {}
Local aCST		:= {}
Local cNatoper  := {}
Local aRetorno	:= {}
Local aCompKit	:= {} //Thomas
Local aNumSer	:= {} //Thomas
Local nPosIni	:= 0
Local cCgcRaiz	:= SuperGetMv("BH_CCGRAI",.F.,"43708379")
Local cQryDifC	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajuste para NF de entrada referente a diferença de centavos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aNota[4] == "0" .AND. aNota[5] == "B" .AND. Alltrim(aNota[1]) == "3"
	cQryDifC := "UPDATE " + RetSqlName("SD1") + " SET D1_TOTAL = round(D1_QUANT*D1_VUNIT,2) "
	cQryDifC += "WHERE D_E_L_E_T_ = '' "
	cQryDifC += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
	cQryDifC += "AND D1_SERIE = '" + aNota[1] + "' "
	cQryDifC += "AND D1_DOC = '" + aNota[2] + "' "
	cQryDifC += "AND (round(D1_QUANT*D1_VUNIT,2) - D1_TOTAL) <> 0 "
	TcSQlExec(cQryDifC)
	TCRefresh(RetSQLName("SD1"))
EndIf

If Len(PARAMIXB) > 12 
    aICMS		:= PARAMIXB[13]
    aIPI		:= PARAMIXB[14]
    aICMSST		:= PARAMIXB[15]
    aPIS		:= PARAMIXB[16]
    aPISST		:= PARAMIXB[17]
    aCOFINS		:= PARAMIXB[18]
    aCOFINSST	:= PARAMIXB[19]
    aISSQN		:= PARAMIXB[20]
    aEspVol		:= PARAMIXB[21]
    aDI			:= PARAMIXB[22]
    aAdi		:= PARAMIXB[23]
    aExp		:= PARAMIXB[24]
    aCST		:= PARAMIXB[25]
    cNatoper	:= PARAMIXB[26]
EndIf  
//+------------------------------------------------------------------------
//|ALTERAÇÃO DA NATUREZA DA OPERAÇÃO PARA O CONTEUDO DESCRITO NO F4_MENNOTA
//+------------------------------------------------------------------------
if aNota[5] $ ("C/N")
	if aDest[9] $ "EX"
	   cTes := Posicione ("SD1",1,xFilial("SD1")+aNota[2]+aNota[1],"D1_TES")
	   cNatoper := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_MENNOTA")
	elseif ! (aDest[9] $ ("EX"))
		cNatoper := Posicione("SF4",1,xFilial("SF4")+aProd[1][27],"F4_MENNOTA")
	endif   
	
elseif aNota[5] $ ("B")
	cNatoper := Posicione("SF4",1,xFilial("SF4")+aProd[1][27],"F4_MENNOTA")
	
elseif !(aNota[5] $ ("C/B"))
	cNatoper := Posicione("SF4",1,xFilial("SF4")+aProd[1][27],"F4_MENNOTA")
	 
endif

//+-----------------------------------------------------------------

//+---------------------------------------------------------
//|Zeragem do CODBAR até tratamento do cadastro de produtos
//+---------------------------------------------------------
For nX:=1 to Len(aProd)
	aProd[nX,3] := ""
Next nX
//+---------------------------------------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata mensagem para equipamentos e peças³
//³D.FERNANDES - 07/10/2013 			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosIni := AT("MSG1", cMensCli)
If nPosIni > 0
	If Len(aNumSer) > 0 //Para equipamento nao considera a mensagem "referente a nota XXXXXXXXX" contem 32 caracteres
		cMensCli := Alltrim(STUFF(cMensCli, nPosIni, 32, " " ) )
	EndIf
EndIf 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alteração referente a implantação do Quiosque - D.FERNANDES - 21/10/2013 - GLPI: 15759	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaSC5:=GetArea("SC5")
aAreaSC6:=GetArea("SC6")
aAreaSA1:=GetArea("SA1")
aAreaSA5:=GetArea("SA5")
aAreaSB1:=GetArea("SB1")
aAreaSB5:=GetArea("SB5")
aAreaSD2:=GetArea("SD2")

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(3)
dbSeek(xFilial("SA1")+ aDest[1])

dbSelectArea("SA5")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB5")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)

dbSelectArea("ZZ4")

For nX := 1 to Len(aProd)
	SB1->(dbSeek(xFilial("SB1") + aProd[nX,2]))
	//SB5->(dbSeek(xFilial("SB5") + aDest[2]))
	//Alterado Uiran Almeida 30.10.2014 GLPI - []
	SB5->(dbSeek(xFilial("SB5") + aProd[nX,2]))
//	aProd[nX,4] := Alltrim(Iif(Empty(SB5->B5_CEME),SB1->B1_DESC,SB5->B5_CEME))
	If !Empty(SB5->B5_CEME)
		aProd[nX,4] := SB5->B5_CEME
	ElseIf !Empty(SB1->B1_DESC)
		aProd[nX,4] := SB1->B1_DESC
	EndIf
	If !Empty(aProd[nX,19])
		aProd[nX,4] += "  Lote: "  + aProd[nX,19]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for devolucao mostra o código do fornecedor referente a implantação do Quiosque - D.FERNANDES - 21/10/2013 - GLPI: 15759³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aNota[5] $ "D"       
			If SA5->(MsSeek( xFilial("SA5") + SA1->A1_COD + SA1->A1_LOJA )) .AND. !Empty(SA5->A5_CODPRF)
				aProd[nX,4] += " Cod.For: " + ALLTrim(SA5->A5_CODPRF)
			EndIf
			
		EndIf                      
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Vinicius Leonardo - Delta Decisão                                                                                  ³
	//³Tratamento para quando for o cliente FAST SHOP, preencher o array com o EAN do item para ser enviado ao XML da Nota³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Substr(SA1->A1_CGC,1,8) $ cCgcRaiz 
		If !Empty(SB1->B1_EAN) 
			aProd[nX,3] := SB1->B1_EAN		
		Else
			MsgAlert("Código EAN para o produto " + Alltrim(SB1->B1_COD) + " não foi cadastrado. Por favor, realize o cadastro.") 
			PARAMIXB[05] := {}
			Return aParam
		EndIf		                  
	EndIf                           
	
	SD2->(dbSeek(xFilial("SD2")+aNota[2]+aNota[1]+SA1->A1_COD+SA1->A1_LOJA+aProd[nX,2]))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
	SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))

	aAdd(aProd[nX], SC5->C5_B_KIT)
	aAdd(aProd[nX], SC5->C5_QTDKIT)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Edson rodrigues                                      ³
	//³Adiciona Informações de Kit, componente -  - 05/08/10³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC5->C5_B_KIT) .And. Empty(SC6->C6_NUMSERI)
		aAdd(aCompKit,{SD2->D2_COD})
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Thomas Galvão - GLPI 9299                                                                                   ³
	//³Pega os Números de séries de todas as Operações, exceto N01 e N10, para impressão nas informações adicionais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZZ4->(dbSetOrder(5)) //ZZ4_FILIAL+ZZ4_NFSNR+ZZ4_NFSSER+ZZ4_IMEI
	If ZZ4->(dbSeek(xFilial("ZZ4") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_NUMSERI ))
    	If ! ZZ4->ZZ4_OPEBGH $ GetMv('ZZ_EXCOPER') //Excessão de Operações para Incluir Numeros de Serie em Informações adicionais
    		aAdd(aNumSer, SD2->D2_NUMSERI)
    	EndIf
 	Else
 		If !Empty(SD2->D2_NUMSERI)
	 		If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)
	 			If !Empty(SC6->C6_NUMSERI) .AND. !Empty(SC6->C6_NUMOS)
					ZZ4->(dbSetOrder(1)) //ZZ4_FILIAL+ZZ4_IMEI+ZZ4_OS
					If ZZ4->(dbSeek(xFilial("ZZ4") + SC6->C6_NUMSERI + LEFT(SC6->C6_NUMOS,6) ))
	    				If ! ZZ4->ZZ4_OPEBGH $ GetMv('ZZ_EXCOPER') //Excessão de Operações para Incluir Numeros de Serie em Informações adicionais
	    					aAdd(aNumSer, SD2->D2_NUMSERI)
	    				EndIf
	 		    	Endif
	 		 	Endif
	 		Endif
	 	Endif
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna as áreas resgatadas no inicio do fonte³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSB5)
RestArea(aAreaSB1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA5)
RestArea(aAreaSA1)
ZZ4->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera as Informações carregadas para o XML³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //Param := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque}
	//aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aICMS,aIPI,aICMSST,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aEspVol,aDI,aAdi,aExp,aCST,cNatoper}
	//              01,      02,      03,   04,   05,       06,   07,     08,      09,       10,      11,      12,   13,  14,     15,  16,    17,     18,       19,    20,     21, 22,  23,  24,  25,      26

AltInfo(@aProd,@cMensCli,@cMensFis,@aDest,@aNota,aInfoItem,@aICMS,@aIPI,@aICMSST,@aPIS,@aPISST,@aCOFINS,@aCOFINSST,@aISSQN,@aEspVol,@aDI,@aAdi,@aExp,aCompKit,aNumSer,@aCST,@cNatoper)

aAdd(aRetorno , aProd)			//01
aAdd(aRetorno , cMensCli)		//02
aAdd(aRetorno , cMensFis)		//03
aAdd(aRetorno , aDest)			//04
aAdd(aRetorno , aNota)			//05
aAdd(aRetorno , aInfoItem)		//06
aAdd(aRetorno , PARAMIXB[07])	//07 
aAdd(aRetorno , PARAMIXB[08])	//08
aAdd(aRetorno , PARAMIXB[09])	//09
aAdd(aRetorno , PARAMIXB[10])	//10
aAdd(aRetorno , PARAMIXB[11])	//11
aAdd(aRetorno , PARAMIXB[11])	//12

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alteracões em Relação ao Padrão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aRetorno , aICMS)			//13
aAdd(aRetorno , aIPI)			//14
aAdd(aRetorno , aICMSST)			//15
aAdd(aRetorno , aPIS)			//16
aAdd(aRetorno , aPISST)			//17
aAdd(aRetorno , aCOFINS)			//18
aAdd(aRetorno , aCOFINSST)		//19
aAdd(aRetorno , aISSQN)			//20
aAdd(aRetorno , aEspVol)			//21
aAdd(aRetorno , aDI)				//22
aAdd(aRetorno , aAdi)			//23
aAdd(aRetorno , aExp)			//24
aAdd(aRetorno , aCST)			//25
aAdd(aRetorno , cNatoper)			//26
RestArea(aArea)
Return (aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AltInfo    ºAutor  ³                    º Data ³  03/01/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que Altera as Informações do Arrays do XML da NF     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
Static Function AltInfo(aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aICMS,aIPI,aICMSST,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aEspVol,aDI,aAdi,aExp,aCompKit, aNumSer, aCST, cNatoper)
Local cSerie	:= aNota[01]
Local cDoc		:= aNota[02]
Local cTipo		:= aNota[04] //Tipo de Entrada/Saída - 0=Entrada / 1=Saída
Local cTipoNF	:= aNota[05] //Tipo da NF - F2_TIPO / F1_TIPO
Local cCliFor	:= Iif(cTipo=="0",SF1->F1_FORNECE,SF2->F2_CLIENTE) //Considera SF1/SF2 posicionados
Local cLoja		:= Iif(cTipo=="0",SF1->F1_LOJA,SF2->F2_LOJA) //Considera SF1/SF2 posicionados
Local cProduto	:= ""
Local cTempAlias:= ""
Local cTextoDev	:= ""
Local cNumDI	:= ""
Local cBaseKit 	:= ""
Local cDesc		:= ""
Local cUmdIPI	:= ""
Local cMsgAux	:= ""
Local cMsgAux2	:= ""
Local cLocadm	:= ""
Local cUfDese	:= ""
Local nCont	:= 0
Local nPos		:= 0
Local nCampo	:= 0
Local nVlrUnit	:= 0
Local nQtdKit	:= 0
Local nOrig	:= 0
Local nI		:= 0
Local nValMerc	:= 0
Local nVOutros	:= 0
Local nIcms	:= 0
Local aProdAgrp	:= {} //Para os Produtos Aglutinados
Local aICMS_		:= {}
Local aICMSST_		:=	{}
Local aIPI_		:= {}
Local aPis_		:= {}
Local aCOFINS_		:= {}
Local aCOFINSST_	:= {}
Local aCST_ 		:= {}
Local aPisst_		:= {}
Local aISSQN_		:={}
Local aDi_			:= {}
Local aProdBkp	:= {}
Local aKit		:= {}
Local aOri		:= {}
Local aNfOrig	:= {}
Local aCompEst	:= {}
Local aOrigem	:= {}
Local aAreaSF2	:= {}
Local aAreaSF1	:= {}
Local aProdImpos:= aClone(aProd)
Local lAglutina	:= Iif(Alltrim(left(adest[1],8)) == "66970229",.T.,.F.)
Local dDataDI   := CToD("")
Local dDtDese   := CToD("")
Local lEasy		:= SuperGetMV("MV_EASY") == "S"
Local cChave	:= ""

 
If cTipo == "1" //Nota Fiscal de Saída
	//verificando se o imposto existe realmente
	For nCont:=1 to Len(aICMS)
		If Len(aICMS[nCont])>0
			If aICMS[nCont,6] == 4
				nIcms++				 
			Endif 
		Endif 
	Next nCont
	
	If nIcms > 0
		cMensFis += "RESOLUÇÃO DO SENANDO FEDERAL SF13/2012"
	endif
	//01-Tratamento para Aglutinar Produtos marcados para serem aglutinados
	//01.01-Aglutina os Produtos
	For nCont:=1 to Len(aProd)
		//Define Dados do Produto sendo Processado
		cProduto 	:= aProd[nCont,02]
		If lAglutina
			nPos := aScan(aProdAgrp , {|Registro| Registro[02] == aProd[nCont,02] .And. Registro[16] == aProd[nCont,16] })
		Else
			nPos := 0
		EndIf

		//Se não encontrado
		If nPos == 0
			//Adiciona o Registro Inteiro do Array aProd sendo Processado
			aAdd( aProdAgrp	, aProd[nCont] )

			aAdd( aICMS_, aICMS[nCont] )
			aICMS_ := aClone(aICMS_)
			
			aAdd( aICMSST_ , aICMSST[nCont] )
			aICMSST_ := aClone(aICMSST_)
			
			aAdd( aIPI_ , aIPI[nCont] )
			aIPI_ := aClone(aIPI_)
			
			aAdd( aPIS_ ,aPIS[nCont] )
			aPIS_ := aClone(aPIS_)
			
			aAdd( aPISST_ , aPISST[nCont] )
			aPISST_ := aClone(aPISST_)
			
			aAdd( aCOFINS_ , aCOFINS[nCont] )
			aCOFINS_ := aClone(aCOFINS_)
			
			aAdd( aCOFINSST_ , aCOFINSST[nCont] )
			aCOFINSST_ := aClone(aCOFINSST_)
			
			aAdd( aISSQN_ , aISSQN[nCont] )
			aISSQN_ := aClone(aISSQN_)
			
			aAdd( aCST_ , aCST[nCont] )
			aCST_ := aClone(aCST_)
				
			
		Else //Se encontrado aglutina os Valores
			
			aProdAgrp[nPos,09]	+= aProd[nCont,09] //Qtde
			aProdAgrp[nPos,10]	+= aProd[nCont,10] //Valor Total do Item
			aProdAgrp[nPos,12]	+= aProd[nCont,12] //Qtde Segunda Unid.
			//aProdAgrp[nPos,16]	+= aProd[nCont,16] //Valor Unitário
			aProdAgrp[nPos,16]	:= aProd[nCont,16] //Valor Unitário //Ajuste em 28/10/2011

			//aICMS
			if len(aicms[ncont])>0
				aICMS_[nPos,05] += aICMS[nCont,05]
				aICMS_[nPos,07] += aICMS[nCont,07]
				aICMS_[nPos,09] += aICMS[nCont,09]				
			endif
			
			//aicmsst
			if len (aICMSST[ncont])>0
				aICMSST_[nPos,05] += aICMSST[nCont,05]
				aICMSST_[nPos,07] += aICMSST[nCont,07]
				aICMSST_[nPos,09] += aICMSST[nCont,09]
			endif
			
			//aIPI
			if len (aipi[ncont])>0
				aIPI_[nPos,06] += aIPI[nCont,06]
				aIPI_[nPos,07] += aIPI[nCont,07]
				aIPI_[nPos,10] += aIPI[nCont,10]
			endif
			
			//aPIS
			if len (aPIs[ncont])>0
				aPIS_[nPos,02] += aPIS[nCont,02]
				aPIS_[nPos,04] += aPIS[nCont,04]
				aPIS_[nPos,05] += aPIS[nCont,05]
			endif
			
			//aPisst
			if len (aPISST[ncont])>0
				aPISST_[nPos,02] += aPISST[nCont,02]
				aPISST_[nPos,04] += aPISST[nCont,04]
				aPISST_[nPos,05] += aPISST[nCont,05]
			endif			
			
			//aCOFINS
			if len (acofins[ncont])>0
				aCOFINS_[nPos,02] += aCOFINS[nCont,02]
				aCOFINS_[nPos,04] += aCOFINS[nCont,04]
				aCOFINS_[nPos,05] += aCOFINS[nCont,05]
			endif
			
			//aCOFINSST
			if len (acofinsst[ncont])>0
				aCOFINSST_[nPos,02] += aCOFINSST[nCont,02]
				aCOFINSST_[nPos,04] += aCOFINSST[nCont,04]
				aCOFINSST_[nPos,05] += aCOFINSST[nCont,05]
			endif
						
			//aISSQN
			if len (aipi[ncont])>0
				aIPI_[nPos,01] += aIPI[nCont,01]
				aIPI_[nPos,03] += aIPI[nCont,03]
			endif
					
			//aCST
			//omitido devido
			//estrutura do imposto não varia em função do código do produto
						
		Endif
		
		
	Next nCont

	//Atualiza o Array de Produtos
	If Len(aProdAgrp) > 0
		aProd 		:= aClone(aProdAgrp)
		aProdAgrp := {}

		//aICMS
		aICMS 	:= aClone(aICMS_)
		aICMS_:= {}
		
		//aICMSST
		aICMSST:= aClone(aICMSST_)
		aICMSST_:={}
		
		//aipi
		aIPI := aClone(aIPI_)
		aIPI_:= {}
		
		//aPIS
		aPIS := aClone(aPIS_)
		aPIS_:= {}
		
		//aPisst
		aPisst:= aclone(aPisst_)
		aPisst_:= {}
		
		//aCOFINS
		aCOFINS := aClone(aCOFINS_)
		aCOFINS_:={}
		
		//aCOFINSST
		aCOFINSST := aClone(aCOFINSST_)
		aCOFINSST_:={}
		
		//aISSQN
		aISSQN := aClone(aISSQN_)
		aISSQN_:= {}
		
		//aCST
		aCST := aClone(aCST_)
		aCST_:= {}
 
		
	Endif
	
	
	&&Correção dos Itens
	For nCont := 1 To Len(aProd)
		aProd[nCont,1] := nCont

		//aICMS
		If Len(aICMS[ncont])>0
			If aICMS[nCont,01] == 'APAGAR'
				aICMS[nCont] := {}
			EndIf
		Endif
		
		//aICMSST
		If Len(aicmsst[ncont])>0
			If aICMSST[nCont,01] == 'APAGAR'
				aICMSST[nCont] := {}
			Endif
		Endif
		
		//aipi
		If Len(aipi[ncont])>0
			If aIPI[nCont,01] == 'APAGAR'
				aIPI[nCont] := {}
			EndIf
		endif
		
		//apis
		if Len(apis[nCont])>0
			if aPis[nCont,01] == 'APAGAR'
				aPis[nCont] := {}
			Endif		
		EndIf
		
		//aPisst
		if len(aPISST[ncont])>0
			If aPISST[nCont,01] == 'APAGAR'
				aPISST[nCont] := {}
			endif	
		EndIf
		
		//aCofins
		if len(aCOFINS[ncont])>0
			If aCOFINS[nCont,01] == 'APAGAR'
				aCOFINS[nCont] := {}
			EndIf
		Endif
			
		//aCofinsst
		if len(aCOFINSST[ncont])>0
			If aCOFINSST[nCont,01] == 'APAGAR'
				aCOFINSST[nCont] := {}			
			EndIf
		Endif
			
		//aISSQN
		if len(aISSQN[ncont])>0
			If aISSQN[nCont,01] == 'APAGAR'
				aISSQN[nCont] := {}
			EndIf
		Endif
		
		//aCST
		If Len(acst[ncont])>0
			If aCST[nCont,01] == 'APAGAR'
				aCST[nCont] := {}
			EndIf
		endif	
		
			
	Next nCont
	
	//Kits
	If !Empty(AllTrim(aNota))
		//Separa os kits
		aKit := {}
		For nI := 1 To Len(aProd)
			If !Empty(aProd[nI,Len(aProd)-1])
				If aScan(aKit,{|x| AllTrim(x[1]) == AllTrim((aProd[nI,Len(aProd)-1]))}) == 0
					aAdd(aKit, {aProd[nI,Len(aProd)-1],aProd[nI,Len(aProd)],aProd[nI,10], aProd[nI,19], aProd[nI,20], aProd[nI,22], aProd[nI,23], aProd[nI,24], aProd[nI,25], aProd[nI,26], aProd[nI,27]})
					cBaseKit := aProd[nI,Len(aProd)-1] //SC5->C5_B_KIT
					nQtdKit  += aProd[nI,Len(aProd)] //SC5->C5_QTDKIT
					nVOutros += aProd[nI,21]
				EndIf
			EndIf
		Next
		
		If !Empty(cBaseKit) .and. nQtdKit > 0
			aProdBkp := aClone(aProd) //Backup do array aProd
			cMsgAux  := ""
			aProd    := {} //Limpa Variavel
			
			cCFOP := aProdBkp[01,07] //Pega apenas o cfop do primeiro item
			
			//Soma campos
			For nI := 1 To Len(aProdBkp)
				If nQuant = 0
					nQuant   := aProdBkp[nI,Len(aProd)]
				EndIf
				nTotal   += aProdBkp[nI,10]
				nFrete   += aProdBkp[nI,13]
				nSeguro  += aProdBkp[nI,14]
				nDescont += aProdBkp[nI,15]
				nVUnit   += aProdBkp[nI,16]
			Next
			
			dbSelectArea("SB1")
			dbSelectArea("SB5")
			
			For nI := 1 To Len(aKit)
				
				SB1->(dbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1") + aKit[nI,1]))
					
					SB5->(dbSetOrder(1))
					If SB5->(DbSeek(xFilial("SB5")+aKit[nI,1]))
						cDesc 	:= IIF(Empty(SB5->B5_CEME)	,SB1->B1_DESC,SB5->B5_CEME)
						cUmdIPI:= IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI)
					Else
						cDesc 	:= SB1->B1_DESC
						cUmdIPI := SB1->B1_UM
					EndIf
					
					nValMerc := aKit[nI,3]
					
					aAdd(aProd,	{Len(aProd)+1,; 		//1
					SB1->B1_COD,; 	   		//2
					"",; 					//3 IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;//3
					cDesc,;			   		//4        // Alteração Feita Substituindo B1_DESC >> B5_CEME- Paulo Lopez - 01/04/10 - Incluso para buscar do B1_DESC quando B5_CEME estiver vazio - Edson Rodrigues 28/04/10.
					SB1->B1_POSIPI,;		//5
					SB1->B1_EX_NCM,;		//6
					cCFOP,;					//7
					SB1->B1_UM,;			//8
					nQuant,;				//9
					nValMerc,;				//10
					cUmdIPI,;				//11
					nQuant,;				//12
					nFrete,;				//13
					nSeguro,;				//14
					nDescont,;				//15
					nValMerc/nQuant,;		//16
					IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //17 - codigo ANP do combustivel//17
					IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,""),; 	//18
					aKit[nI,04],;  			//19
					aKit[nI,05],;           //20
					nVOutros,;            	//21
					aKit[nI,06],;           //22
					aKit[nI,07],;           //23
					aKit[nI,08],;           //24
					aKit[nI,09],;           //25
					aKit[nI,10],; 			//26
					aKit[nI,11]}) 			//27 TES
				EndIf
			Next
			
			//Monta Mensagem com a composicao do kit
			DbSelectArea("SG1")
			For nI := 1 To Len(aKit)
				SG1->(dbsetorder(1))
				If SG1->(DbSeek(xfilial("SG1") + aKit[nI,1]))
					cMsgAux := "ESTE KIT E COMPOSTO POR:"
					cMsgAux := cMsgAux + Space(MAXMENLIN - Len(cMsgAux))
					
					aCompEst:={}
					While !SG1->(EoF()) .And. SG1->G1_FILIAL == xFilial("SG1") .And. SG1->G1_COD == aKit[nI,1]
						If aScan(aCompKit,{|x| AllTrim(x[1]) == AllTrim(SG1->G1_COMP)}) > 0
							cMsgAux2 := StrZero(SG1->G1_QUANT,Len(cValToChar(SG1->G1_QUANT))) + " " + AllTrim(SG1->G1_COMP)
							cMsgAux  += cMsgAux2 + Space(MAXMENLIN - Len(cMsgAux2))
							aAdd(aCompEst,{AllTrim(SG1->G1_COMP)})
						Endif
						SG1->(dbSkip())
					EndDo
					
					If Len(aCompKit) > 0
						CompNoKit:=""
						For nI:=1 to len(aCompKit)
							If aScan(aCompEst,{|x| AllTrim(x[1]) == AllTrim(aCompKit[nI,1])}) == 0 .And. AllTrim(aCompKit[nI,1])<>AllTrim(aCompKit)
								CompNoKit:=aCompKit[nI,1]
								cMsgAux2 := StrZero(1,Len(cValToChar(1))) + " " + aCompKit[nI,1]
								cMsgAux  += cMsgAux2 + Space(MAXMENLIN - Len(cMsgAux2))
							Endif
						Next
					Endif
				Endif
				If !Empty(cMsgAux)
					cMensCli += cMsgAux
				EndIf
			Next
		EndIf
	EndIf

	&&Impressão dos números de Séries
	cTextoDev := ''
	For nI := 1 To Len(aNumSer)
		If !Empty(aNumSer[nI]) .and. !AllTrim(aNumSer[nI]) $ cTextoDev
			cTextoDev += Iif(!Empty(cTextoDev)," / ", "")
			cTextoDev += AllTrim(aNumSer[nI])
		Endif
	Next nI
	
	If !Empty(cTextoDev)
		cTextoDev := "Números de Série: " + cTextoDev
		While !Empty(cTextoDev)
			cMensCli 	+= Substr(cTextoDev,1,MAXMENLIN) + Space(MAXMENLIN - Len(cTextoDev))
			cTextoDev	:= SubStr(cTextoDev,MAXMENLIN+1,Len(cTextoDev))
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime campo com número do chamado que ³
	//³foi digitado na entrada massiva         ³
	//³D.FERNANDES - 29/11/2013 	GLPI: 16302³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aOriCli  := {}
	aAreaSD2 := SD2->(GetArea())
	aAreaSF1 := SF1->(GetArea())	
	
	dbSelectArea("SD2")
	dbSetOrder(3) 
	If MsSeek( xFilial("SD2")+SF2->(F2_DOC+F2_SERIE) )
		While SD2->(!Eof()) .And. xFilial("SD2")+SF2->(F2_DOC+F2_SERIE) ==;
									SD2->( D2_FILIAL+D2_DOC+D2_SERIE )
			If !Empty(SD2->D2_NFORI)
			
				_nPos  := aScan(aOriCli,{|x| x[3]+x[4] == SD2->D2_NFORI + SD2->D2_SERIORI })
				
				If _nPos == 0 				
					AADD( aOriCli , {SD2->D2_CLIENTE,;
								  SD2->D2_LOJA,;	
								  SD2->D2_NFORI,;
								  SD2->D2_SERIORI} )
				EndIf								  
			EndIf
			
			SD2->(dbSkip())
		EndDo
	EndIf
	
	If Len(aOriCli) > 0
		For nOriCli := 1 To Len(aOriCli)
		
			dbSelectArea("SF1")
			dbSetOrder(1)
			If MsSeek(xFilial("SF1")+aOriCli[nOriCli][3]+aOriCli[nOriCli][4]+aOriCli[nOriCli][1]+aOriCli[nOriCli][2])
				If !Empty(SF1->F1_XCHAMAD)
					cMensCli += "Chamado: " + SF1->F1_XCHAMAD
				EndIf
			EndIf               
			
		Next nOriCli			
	EndIf
	
	Restarea(aAreaSD2)
	RestArea(aAreaSF1)
				
EndIf

If cTipo == "0" //Nota de entrada
	
	dbSelectArea("SF1")
	SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	SF1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cCliFor+cLoja))
	
	
	If !Empty(AllTrim(cNumDI))
		cMsgAux := "Ref. D.I no. " + AllTrim(cNumDI)  + " de " + DToC(dDataDI) + " Local Desemb. " +  AllTrim(cLocadm)	 + " - " + AllTrim(cUfDese) + " Data Desemb. " +	DToC(dDtDese)
		If SF1->(F1_VALIMP5+F1_VALIMP6) > 0 
			cMsgAux := cMsgAux + "Valor COFINS: R$ " + Alltrim(Str(SF1->F1_VALIMP5, 14, 2)) + " - " + "Valor PIS: R$ " + Alltrim(Str(SF1->F1_VALIMP6, 14, 2))
		Endif
		cMensCli += cMsgAux + Space(MAXMENLIN - Len(cMsgAux))
		
	Elseif AllTrim(aNota[5]) <> 'C'  // COMPLEMENTAR
		//PROGRAMACAO CRIADA PARA NOTAS DE IMPORTACAO QUE NAO UTILIZAM MAIS A TELA D.I. NO DOCUMENTO DE ENTRADA
		If !lEasy 
			DbSelectArea("CD5")
			CD5->(DbSetOrder(1))
			CD5->(DbSeek(xFilial("CD5") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))
			cMsgAux := "Ref. D.I no. " + AllTrim(CD5->CD5_NDI)  + " de " + DToC(CD5->CD5_DTDI) + " Local Desemb. " +  AllTrim(CD5->CD5_LOCDES)	 + " - " + AllTrim(CD5->CD5_UFDES) + " Data Desemb. " +	DToC(CD5->CD5_DTDES)
			If SF1->(F1_VALIMP5+F1_VALIMP6) > 0 
				cMsgAux := cMsgAux + "Valor COFINS: R$ " + Alltrim(Str(SF1->F1_VALIMP5, 14, 2)) + " - " + "Valor PIS: R$ " + Alltrim(Str(SF1->F1_VALIMP6, 14, 2))
			Endif
		Else  //Vinicius Leonardo - 21/05/2014 - Carrega as informações na nota quando vindas do EIC
			IF AllTrim(aNota[5]) <> 'B' //Carlos/Vinicius - 26/06/2014 - Exclusão das informações para notas de entrada tipo beneficiamento
				For nI := 1 to Len(aDi)
					If Len(aDi[nI]) > 0 .and. !(Alltrim(aDI[nI,4,3]) $ Alltrim(cMsgAux))					
						If cChave#Alltrim(aDI[nI,4,3])+DtoC(aDI[nI,5,3])+AllTrim(aDI[nI,6,3])+ AllTrim(aDI[nI,7,3])+DtoC(aDI[nI,8,3])
							cMsgAux += "Ref. D.I no. " + Alltrim(aDI[nI,4,3])  + " de " + DtoC(aDI[nI,5,3]) + " Local Desemb. " +  AllTrim(aDI[nI,6,3]) + " - " + AllTrim(aDI[nI,7,3]) + " Data Desemb. " + DtoC(aDI[nI,8,3])
						EndIf
						cChave:=Alltrim(aDI[nI,4,3])+DtoC(aDI[nI,5,3])+AllTrim(aDI[nI,6,3])+ AllTrim(aDI[nI,7,3])+DtoC(aDI[nI,8,3])
					EndIf
				Next nI
			ENDIF 
			If SF1->(F1_VALIMP5+F1_VALIMP6) > 0 
				cMsgAux := cMsgAux + "Valor COFINS: R$ " + Alltrim(Str(SF1->F1_VALIMP5, 14, 2)) + " - " + "Valor PIS: R$ " + Alltrim(Str(SF1->F1_VALIMP6, 14, 2))
			Endif
		EndIf
		cMensCli += cMsgAux + Space(MAXMENLIN - Len(cMsgAux))
	EndIf
	
	
	If AllTrim(aNota[5]) = 'C' // COMPLEMENTAR

		aAreaSF1 := SF1->(GetArea())
		DbSelectArea("SF1")
		SF1->(DbSetOrder(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		DbSelectArea("SF8")
		SF8->(DbSetOrder(1))
		If !lEasy
			MsSeek(xFilial("SF8") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
			cMsgAux := "Ref. NF de Entrada no. "
		 
			Do while !SF8->(EOF()) .and. SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN) = SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
				SF1->( DbSeek( XFilial("SF1") + SF8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)) )
				cMsgAux += AllTrim(SF8->F8_NFORIG) + '/' + AllTrim(SF8->F8_SERORIG)+ ', de '+ DToC(SF1->F1_EMISSAO) + ', '
				DbSelectArea("CD5")
				CD5->(DbSetOrder(1))
				CD5->(DbSeek(xFilial("CD5") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))
				cMsgAux += " Ref. D.I no. " + AllTrim(CD5->CD5_NDI)  + " de " + DToC(CD5->CD5_DTDI)
				SF8->(DbSkip())
			EndDo
		Else
			For nI := 1 to Len(aDi)
				If !(Alltrim(aDI[nI,2,3]) $ Alltrim(cMsgAux))
					cMsgAux += "Ref. D.I no. " + Alltrim(aDI[nI,2,3])  + " de " + DtoC(aDI[nI,3,3]) + " Local Desemb. " +  AllTrim(aDI[nI,4,3]) + " - " + AllTrim(aDI[nI,5,3]) + " Data Desemb. " + DtoC(aDI[nI,6,3])
				EndIf
			Next
		EndIf
		cMensCli += cMsgAux + Space(MAXMENLIN - Len(cMsgAux))
		cMsgAux  := AllTrim(Formula("040"))
		cMensFis += cMsgAux + Space(MAXMENLIN - Len(cMsgAux)) //acrescentado mensagem fiscal para nota fiscal de complementar de importacao - 18/09/09
		RestArea(aAreaSF1)
	Endif
	
EndIf

Return Nil
