#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROESTR1  ºAutor  ³LUCIANO / DIEGO     º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio para conferencia do fechamento de estoque        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos BGH                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BGHESTR1()

Local oReport 

Local cPerg := PADR("BGHESTR1",10)

//cria perguntas 
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return	
EndIf

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³LUCIANO / DIEGO     º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao especifica de impressao					          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos BGH                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("BGHESTR1","Analise Fechamento","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir analise do fehamento antes de processar a virada de saldo.")

oSection1 := TRSection():New(oReport,OemToAnsi("Analise Fechamento"),{"TSQL"})

TRCell():New(oSection1,"PRODUTO","TSQL","Produto","@!",15)
TRCell():New(oSection1,"ARMAZ","TSQL","Armazem","@!",02)
TRCell():New(oSection1,"QTDFIM","TSQL","Saldo Fisico Final","@E 99,999,999.99",20)
TRCell():New(oSection1,"QTDSBF","TSQL","Saldo Endereço Final","@E 99,999,999.99",20)
TRCell():New(oSection1,"OK","TSQL","OK","@!",15)
TRCell():New(oSection1,"OBS","","OBS","@!",999)

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PrintReportºAutor  ³LUCIANO / DIEGO     º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao especifica de impressao					          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especificos BGH                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

Local dDtProces  := MV_PAR01
Local dDataMes   := GetMv("MV_ULMES")
Local dDataFec   := dDtProces
Local aLocaliz   :={{}}
Local l300SalNeg := GetMV("MV_MT300NG",.F.,.T.) // Indica se permite saldo negativo
Local nSaldoB2   := 0

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
	        
	//Calcula o saldo fisico do periodo selecionado pelo usuario
	aSaldos := CalcEst(TSQL->PRODUTO, TSQL->ARMAZ, dDtProces+1)
	nSaldoB2:= aSaldos[1]                        
	
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
//				nAchou := ASCAN(aLocaliz[i],{|x| x[1] == BF_LOCALIZ .And. x[2] == BF_NUMSERI .And. x[3] == BF_LOTECTL .And. x[4] == BF_NUMLOTE})
				nAchou := ASCAN(aLocaliz[i],{|x| x[1] == BF_LOCALIZ})
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
//			nAchou := ASCAN(aLocaliz[i],{|x| x[1] == BK_LOCALIZ .And. x[2] == BK_NUMSERI .And. x[3] == BK_LOTECTL .And. x[4] == BK_NUMLOTE})
			nAchou := ASCAN(aLocaliz[i],{|x| x[1] == BK_LOCALIZ})
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
//				nAchou := ASCAN(aLocaliz[i],{|x| x[1] == BK_LOCALIZ .And. x[2] == BK_NUMSERI .And. x[3] == BK_LOTECTL .And. x[4] == BK_NUMLOTE})

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
	dbSeek(xFilial("SDB")+TSQL->PRODUTO+TSQL->ARMAZ+DTOS(dDataMes+1),.T.)
	While !Eof() .And. DB_FILIAL+DB_PRODUTO+DB_LOCAL == xFilial("SDB")+TSQL->PRODUTO+TSQL->ARMAZ .And. DTOS(DB_DATA) <= DTOS(dDataFec)
		For i:=1 to Len(aLocaliz)
//			nAchou := ASCAN(aLocaliz[i],{|x| x[1] == DB_LOCALIZ .And. x[2] == DB_NUMSERI .And. x[3] == DB_LOTECTL .And. x[4] == DB_NUMLOTE})
			nAchou := ASCAN(aLocaliz[i],{|x| x[1] == DB_LOCALIZ})
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
				aSaldo		:= CalcEstL(TSQL->PRODUTO,TSQL->ARMAZ,(dDataFec+1),aLocaliz[i,z,3],aLocaliz[i,z,4],aLocaliz[i,z,1],aLocaliz[i,z,2])
				// Caso tenha tido movimento que deixou saldo negativo zera saldo

				If QtdComp(aSaldo[1]) < QtdComp(0) .And. !l300SalNeg
					aSaldo[1]	:= 0
					aSaldo[7]	:= 0
				EndIf

				/*If aSaldo[1] > 0 
					dbSelectArea('SBK')
					dbSetOrder(1)
					If !dbSeek(xFilial('SBK') + TSQL->PRODUTO+TSQL->ARMAZ + aLocaliz[i,z,3] + aLocaliz[i,z,4] + aLocaliz[i,z,1] + aLocaliz[i,z,2] + DtoS(dDataFec), .F.)
						RecLock('SBK', .T.)
						Replace BK_FILIAL  With xFilial('SBK')
						Replace BK_COD     With TSQL->PRODUTO
						Replace BK_LOCAL   With TSQL->ARMAZ
						Replace BK_LOTECTL With aLocaliz[i,z,3]
						Replace BK_NUMLOTE With aLocaliz[i,z,4]
						Replace BK_LOCALIZ With aLocaliz[i,z,1]
						Replace BK_NUMSERI With aLocaliz[i,z,2]
						Replace BK_DATA    With dDataFec
						Replace BK_QINI    With aSaldo[1]
						MsUnlock()
					EndIf
				Endif*/
				nSaldoSBF += aSaldo[1]
			Next z
		Next i
	EndIf
			
	If nSaldoB2 == nSaldoSBF
		cOk:="OK"           
		oSection1:Cell("OBS"):SetBlock( { || "" })
			
		If MV_PAR06 == 2 //Lista somente itens com problema
			dbSelectArea("TSQL")
			DbSkip()
			oReport:IncMeter()						
			Loop
		EndIf
	Else
		cOk :="Analisar"
		oSection1:Cell("OBS"):SetBlock( { || "INFORMAR O DEPARTAMENTO DE ESTOQUE PARA VERIFICAR O ENDERECAMENTO DE PRODUTOS" })
	Endif               

	oSection1:Cell("QTDFIM"):SetBlock( { ||nSaldoB2})
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analisa documentos a serem baixados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT D3_COD PRODUTO, D3_QUANT QTDFIM, D3_LOCAL ARMAZ, D3_DOC"
cQuery += " FROM "+RetSqlName("SD3")+"  "
cQuery += " WHERE D3_TM = '998' "
cQuery += " AND D3_QUANT > 0 "
cQuery += " AND D3_ESTORNO = '' "
cQuery += " AND D3_EMISSAO > '"+DTOS(dDataMes+1)+"' "
cQuery += " AND D3_EMISSAO <= '"+DTOS(dDtProces)+"' "
cQuery += " AND D3_COD BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery += " AND D3_LOCAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria alias  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)

dbSelectArea("TSQL")
TSQL->(dbGotop())

If TSQL->(!Eof())

	oSection1:Init()
	
	While TSQL->(!Eof())
		
		oSection1:Cell("QTDFIM"):SetBlock( { || TSQL->QTDFIM })
		oSection1:Cell("QTDSBF"):SetBlock( { || TSQL->QTDFIM })
		oSection1:Cell("OK"):SetBlock( { || "ANALISAR"})
		oSection1:Cell("OBS"):SetBlock( { || "INFORMAR O DEPTO PCP PARA VERIFICAR O ESTORNO OU EXECUCAO DO DOCUMENTO "+TSQL->D3_DOC })		
		
		oSection1:PrintLine()
		oReport:IncMeter()		
		
		TSQL->(dbSkip())
	EndDo
	
	oSection1:Finish()
	
EndIf

If Select("TSQL") > 0
	dbSelectArea("TSQL")
	DbCloseArea()
EndIf             


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSelReg   ºAutor  ³D.FERNANDES         º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra dados especificos na tabela SB2                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
cQuery += " AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += " AND SB2.B2_COD BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery += " AND SB2.B2_LOCAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
cQuery += " ORDER BY B2_COD, B2_LOCAL "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria alias  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCriaSX1  ºAutor  ³D.FERNANDES         º Data ³  10/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra dados especificos na tabela SB2                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Declaracao de variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Data Base		    	?","","","mv_ch1","D",08,0,0,"G","","" ,"","","mv_par01",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Amz de	           		?","","","mv_ch2","C",02,0,0,"G","","" ,"","","mv_par02",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Amz ate	           		?","","","mv_ch3","C",02,0,0,"G","","" ,"","","mv_par03",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Produto de         		?","","","mv_ch4","C",15,0,0,"G","","SB1" ,"","","mv_par04",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Produto ate         		?","","","mv_ch5","C",15,0,0,"G","","SB1" ,"","","mv_par05",""		,"","","","",""			,"","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Lista Todos              ?","","","mv_ch6","N",01,0,0,"C","",""	,"",,"mv_par06","Sim","","","","Não"	,"","",""	,"","","","","","","","")
  
Return


//Querys para conuslta de divergências, usadas somente por tecnicos
//Query usada para tratar B9 não gerados
/*cQuery := " SELECT "
cQuery += " 	DISTINCT B9_COD AS PRODUTO,B9_LOCAL AS ARMAZ,B9_QINI AS QTDFIM "
cQuery += " FROM SB9020 SB9 (NOLOCK) "
cQuery += " INNER JOIN SB1020 SB1 (NOLOCK) ON "
cQuery += "		B1_FILIAL='' AND "
cQuery += "		B1_COD=B9_COD AND "
cQuery += "		B1_LOCALIZ='S' AND "
cQuery += "		SB1.D_E_L_E_T_ = '' "
cQuery += "	LEFT JOIN SBK020 SBK (NOLOCK) ON "
cQuery += "		BK_FILIAL=B9_FILIAL AND "
cQuery += "		BK_COD=B9_COD AND "
cQuery += "		BK_LOCAL=B9_LOCAL AND "
cQuery += "		BK_DATA=B9_DATA AND "
cQuery += "		SBK.D_E_L_E_T_ ='' "
cQuery += "	WHERE "
cQuery += "		B9_FILIAL='06' AND "
cQuery += "		B9_DATA='20130930' AND "
//cQuery += "		B9_COD='01000358411' AND "
cQuery += "		B9_QINI > 0 AND "
cQuery += "		SB9.D_E_L_E_T_ = '' AND "
cQuery += "		BK_COD IS NULL "
cQuery += "	ORDER BY B9_LOCAL,B9_COD "*/

/*cQuery := " SELECT DISTINCT B9_COD AS PRODUTO,B9_LOCAL AS ARMAZ, SALDO_FISICO AS QTDFIM FROM (  "
cQuery += " 	SELECT B9_DATA,  "
cQuery += " 		   B9_COD,  "
cQuery += " 		   B9_LOCAL,  "
cQuery += " 		   B9_QINI AS SALDO_FISICO, "
cQuery += " 		   ISNULL( (  "
cQuery += " 				SELECT SUM(BK_QINI) FROM SBK020 SBK  "
cQuery += " 				WHERE SBK.D_E_L_E_T_ = '' "
cQuery += " 				AND BK_COD = B9_COD "
cQuery += " 				AND BK_LOCAL = B9_LOCAL "
cQuery += " 				AND BK_DATA = B9_DATA "
cQuery += " 				AND BK_FILIAL = '06'   "
cQuery += " 		   ),0)  AS QTD_ENDERECO	    "
cQuery += " 	FROM SB9020 SB9 "
cQuery += " 	LEFT JOIN SB1020 SB1 ON (B1_COD = B9_COD AND SB1.D_E_L_E_T_ = '' ) "
cQuery += " 	WHERE SB9.D_E_L_E_T_ = '' "
cQuery += " 	AND B1_LOCALIZ = 'S' "
cQuery += " 	AND B9_FILIAL = '06' "
cQuery += " 	AND B9_DATA = '20130930'  "
cQuery += " 	) AS TRB "
cQuery += " WHERE SALDO_FISICO <> QTD_ENDERECO "*/
//cQuery += " AND B9_COD = '56014369002    '  "
