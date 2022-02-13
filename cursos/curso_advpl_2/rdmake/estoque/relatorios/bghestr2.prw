#include "protheus.ch"

User Function BGHESTR2()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New("BGHESTR1","Analise Fechamento","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir analise do fehamento antes de processar a virada de saldo.")

oSection1 := TRSection():New(oReport,OemToAnsi("Analise Fechamento"),{"TSQL"})

TRCell():New(oSection1,"PRODUTO","TSQL","Produto","@!",15)
TRCell():New(oSection1,"DESCRI","TSQL","Descrição","@!",50)
TRCell():New(oSection1,"ARMAZ","TSQL","Armazem","@!",02)
TRCell():New(oSection1,"QTDFIM","TSQL","Saldo Fisico Final","@E 99,999,999.99",20)
TRCell():New(oSection1,"QTDSBF","TSQL","Saldo Endereço Final","@E 99,999,999.99",20)
TRCell():New(oSection1,"VFIM","TSQL","Valor Final","@E 99,999,999.99",20)
TRCell():New(oSection1,"OK","TSQL","OK","@!",15)

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

Local dDataMes   := GetMv("MV_ULMES")
Local dDataFec   := dDataBase-7
Local aLocaliz   :={{}}
Local l300SalNeg := GetMV("MV_MT300NG",.F.,.T.) // Indica se permite saldo negativo

Private nSaldoSBF := 0

// Selecao dos dados a Serem Impressos
MsAguarde({|| fSelReg()},"Selecionando Registros")

dbSelectArea("TSQL")
dbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()

Do While TSQL->(!Eof())
	If oReport:Cancel()
		Exit
	EndIf
	
	nSaldoSBF := 0
	aLocaliz  :={{}}
	
	//-- Alimenta SBK com base no SBF para Localiza‡ao
	dbSelectArea('SBF')
	dbSetOrder(2)
	If dbSeek(cSeekSBF := xFilial('SBF') + TSQL->PRODUTO+TSQL->ARMAZ, .F.)
		Do While !SBF->(Eof()) .And. cSeekSBF == SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL
			// Filtra qtd igual a zero
			If QtdComp(SBF->BF_QUANT) == QtdComp(0)
				SBF->(dbSkip())
				Loop
			EndIf
			If QtdComp(SBF->BF_QUANT) < QtdComp(0) .And. !l300SalNeg
				SBF->(dbSkip())
				Loop
			EndIf
			For i:=1 to Len(aLocaliz)
				nAchou:=ASCAN(aLocaliz[i],{|x| x[1] == BF_LOCALIZ .And. x[2] == BF_NUMSERI .And. x[3] == BF_LOTECTL .And. x[4] == BF_NUMLOTE})
				If nAchou > 0
					Exit
				EndIf
			Next i
			If nAchou == 0
				If Len(aLocaliz[Len(aLocaliz)]) > 4095
					AADD(aLocaliz,{})
				EndIf
				AADD(aLocaliz[Len(aLocaliz)],{BF_LOCALIZ,BF_NUMSERI,BF_LOTECTL,BF_NUMLOTE})
			EndIf
			SBF->(dbSkip())
		EndDo
	EndIf
	
	// Varre saldos iniciais
	dbSelectArea("SBK")
	dbSetOrder(3)
	dbSeek(xFilial("SBK")+TSQL->PRODUTO+TSQL->ARMAZ+DTOS(dDataMes),.T.)
	While !Eof() .And. BK_FILIAL+BK_COD+BK_LOCAL == xFilial("SBK")+TSQL->PRODUTO+TSQL->ARMAZ .And. DTOS(BK_DATA) < DTOS(dDataFec)
		For i:=1 to Len(aLocaliz)
			nAchou:=ASCAN(aLocaliz[i],{|x| x[1] == BK_LOCALIZ .And. x[2] == BK_NUMSERI .And. x[3] == BK_LOTECTL .And. x[4] == BK_NUMLOTE})
			If nAchou > 0
				Exit
			EndIf
		Next i
		If nAchou == 0
			//-- Se o produto trabalha com controle de numero de serie e
			//-- a quantidade do registro SBK e igual a Zero, nao gravar
			//-- novo registro na tabela SBK para o fechamento atual
			If !Empty(BK_NUMSERI) .And. QtdComp(BK_QINI) == QtdComp(0)
				dbSkip()
				Loop
			Else
				If Len(aLocaliz[Len(aLocaliz)]) > 4095
					AADD(aLocaliz,{})
				EndIf
				AADD(aLocaliz[Len(aLocaliz)],{BK_LOCALIZ,BK_NUMSERI,BK_LOTECTL,BK_NUMLOTE})
			EndIf
		EndIf
		dbSkip()
	End
	
	// Varre movimentacao interna
	dbSelectArea("SDB")
	dbSetOrder(10)
	dbSeek(xFilial("SDB")+TSQL->PRODUTO+TSQL->ARMAZ+DTOS(dDataMes),.T.)
	While !Eof() .And. DB_FILIAL+DB_PRODUTO+DB_LOCAL == xFilial("SDB")+TSQL->PRODUTO+TSQL->ARMAZ .And. DTOS(DB_DATA) <= DTOS(dDataFec)
		For i:=1 to Len(aLocaliz)
			nAchou:=ASCAN(aLocaliz[i],{|x| x[1] == DB_LOCALIZ .And. x[2] == DB_NUMSERI .And. x[3] == DB_LOTECTL .And. x[4] == DB_NUMLOTE})
			If nAchou > 0
				Exit
			EndIf
		Next i
		If nAchou == 0
			If Len(aLocaliz[Len(aLocaliz)]) > 4095
				AADD(aLocaliz,{})
			EndIf
			AADD(aLocaliz[Len(aLocaliz)],{DB_LOCALIZ,DB_NUMSERI,DB_LOTECTL,DB_NUMLOTE})
		EndIf
		dbSkip()
	End
	
	
	If Len(aLocaliz[1]) > 0
		For i:=1 to Len(aLocaliz)
			For z:=1 to Len(aLocaliz[i])
				aSaldo		:=CalcEstL(TSQL->PRODUTO,TSQL->ARMAZ,(dDataFec+1),aLocaliz[i,z,3],aLocaliz[i,z,4],aLocaliz[i,z,1],aLocaliz[i,z,2])
				// Caso tenha tido movimento que deixou saldo negativo zera saldo
				If QtdComp(aSaldo[1]) < QtdComp(0) .And. !l300SalNeg
					aSaldo[1]	:= 0
					aSaldo[7]	:= 0
				EndIf
				nSaldoSBF += aSaldo[1]
			Next z
		Next i
	EndIf
		
	If TSQL->QTDFIM == nSaldoSBF
		cOk:="OK"
	Else
		cOk :="Analisar"
	Endif
	oSection1:Cell("QTDSBF"):SetBlock( { ||nSaldoSBF})
	oSection1:Cell("OK"):SetBlock( { ||cOk})
	
	oSection1:PrintLine()
	
	dbSelectArea("TSQL")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()


If Select("TSQL") > 0
	dbSelectArea("TSQL")
	DbCloseArea()
EndIf

Return

Static Function fSelReg()

cQuery := " SELECT B2_COD AS PRODUTO, "
cQuery += " 	   B1_DESC AS DESCRI, "
cQuery += " 	   B2_LOCAL AS ARMAZ, "
cQuery += " 	   B2_QFIM AS QTDFIM, "
cQuery += "        B2_VFIM1 AS VFIM, "
cQuery += " 	   B2_CM1 AS CM, "
cQuery += " 	   (CASE WHEN B2_QFIM > 0 AND B2_VFIM1 > 0 THEN (B2_VFIM1/B2_QFIM) ELSE 0 END) as UNITARIO "
cQuery += " FROM "+RetSqlName("SB2")+" SB2 (NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (B1_COD = B2_COD AND SB1.D_E_L_E_T_ <> '*' ) "
cQuery += " AND SB2.D_E_L_E_T_ <> '*'  "
cQuery += " AND SB1.B1_LOCALIZ = 'S' "
//cQuery += " AND SB2.B2_COD = '01000358411' "
//cQuery += " AND SB2.B2_LOCAL = '01' "
cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += " ORDER BY B2_COD, B2_LOCAL "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria alias  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)

Return
