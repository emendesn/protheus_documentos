/*--------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: Holerith                                                                                                                                       |
|Autor:                                                                                                                                                   |
|Data Aplicação:                                                                                                                                          |
|Descrição: Gerar arquivo para impressão do Recibo de Pagamento                                                                                           |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 10/11/2010 17:00                                                                                                                         |
|Motivo: Alterada a ordem do arquivo para Filial, Centro de Custo, Turno de Trabalho e Nome                                                               |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 22/11/2010 17:00                                                                                                                         |
|Motivo: Correcao Valor Liquido e filtro por tipo de pagamento                                                                                            |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 15/12/2010 19:30                                                                                                                         |
|Motivo: Alteração na competência de MM/AAAA para MM/AA-N (N=TIPO DE RECIBO, 1=ADTO, 2=FOLHA, 3=ADTO13, 4=13SAL)                                          |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 30/09/2011                                                                                                                               |
|Motivo: Ordem de Impressão para FILIAL, TURNO, C.CUSTO, DEPTO/AREA, NOME                                                                                 |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 04/11/2011                                                                                                                               |
|Motivo: Ordem de Impressão para FILIAL, TURNO, C.CUSTO, NOME                                                                                             |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 25/11/2011                                                                                                                               |
|Motivo: Ordem de Impressão para FILIAL, C.CUSTO, TURNO, ÁREA, NOME                                                                                       |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 02/12/2011                                                                                                                               |
|Motivo: Correção Total de Descontos e Líquido para 1a Parcela do 13o Salário                                                                             |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 12/03/2012                                                                                                                               |
|Motivo: Ordem de Impressão para FILIAL, TURNO, CELULA E NOME                                                                                             |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------/
|Data Alteração: 23/04/2012                                                                                                                               |
|Motivo: Inclusão de parâmetro "Ordem" com 5 opções                                                                                                       |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Cláudio Bispo no ambiente DEVEL_MAINTECH                                                                                                   |
+--------------------------------------------------------------------------------------------------------------------------------------------------------*/
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function Holerith()  //Miscelanea / Exportação / Holerith
PRIVATE cPerg := space(10)

u_GerA0003(ProcName())

cPerg :="XHOLER"
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
	Return()
Endif

Processa( { || MyRel() } )
Return .t.

Static Function MyRel()
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
//Local cArquivo   := alltrim(cRootPath) + alltrim(cStartPath) + alltrim(mv_par03)
Local cArquivo   := alltrim(mv_par03)
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local cMesAnoRef
//Local dInicio := FirstDay(mv_par01)
//Local dFim := LastDay(mv_par01)
Local dDtPesqAf
Local aTotCC := {}
Local yy := 0
Local cTipAfas    := " "
Local NVencto := 0
Local nDescto := 0
Local cSalLiq := 0
Local cBaseIss := 0
Local cBaseIrr := 0
Local cFgts    := 0
Local cIrrFer := 0
Private nMax       := 0
Private Nachou     := 0
cMesAnoRef := StrZero(Month(MV_PAR01),2) + StrZero(Year(MV_PAR01),4)
Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)
Private nRelat := mv_par07
If !Empty(MV_PAR01)
	cData = Dtos(MV_PAR01)
EndIf
nHandle := MsfCreate(alltrim(MV_PAR02),0)
cData := STOD( CdATA)
dDataRef := mv_par01
dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif
DbSelectArea("SRV")
DbSetOrder(1)
DbSelectArea("SRI")
DbSetOrder(1)
DbSelectArea("SRC")
DbSetOrder(1)
DbSelectArea("CTT")
DbSetOrder(1)
DbSelectArea("SRJ") // FUNCOES
DbSetOrder(1)
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA__DEPTO,RA_NOME,RA_DEPIR,RA_DEPSF,RA_BCDEPSA,RA_CTDEPSA,RA_CODFUNC,RA_SALARIO,RA_DEMISSA,RA_ADMISSA,RA_TNOTRAB "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (nolock) "
cQuery += " WHERE  "
cQuery += "	SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_CATFUNC NOT IN('A')"
if !empty(mv_par03) // centro de custo
	cQuery += " AND SRA.RA_CC >= '" + MV_PAR03 + "' "
Endif
if !empty(mv_par04) // centro de custo
	cQuery += " AND SRA.RA_CC <= '" + MV_PAR04 + "' "
Endif
if !empty(mv_par05) // MATRICULA
	cQuery += " AND SRA.RA_MAT >= '" + MV_PAR05 + "' "
Endif
if !empty(mv_par06) // MATRICULA
	cQuery += " AND SRA.RA_MAT <= '" + MV_PAR06 + "' "
Endif

If MV_PAR12 == 1 // CC+Turno+Area+Nome
	cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_TNOTRAB,RA__DEPTO,RA_NOME "
	ElseIf MV_PAR12 == 2 //CC+Turno+Cel+Nome
		cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_TNOTRAB,RA__CELULA,RA_NOME "
	ElseIf MV_PAR12 == 3 //CC+Turno+Nome
		cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_TNOTRAB,RA_NOME "
	ElseIf MV_PAR12 == 4 //Turno+CC+Nome
		cQuery += " ORDER BY RA_FILIAL,RA_TNOTRAB,RA_CC,RA_NOME "
	ElseIf MV_PAR12 == 5 //Turno+Cel+Nome
		cQuery += " ORDER BY RA_FILIAL,RA_TNOTRAB,RA__CELULA,RA_NOME "
EndIf
//cQuery += "AND RA_MAT IN ('010497') " //and RA_CC IN ('3041') "


TCQUERY cQuery NEW ALIAS "QRY1"
DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())
DO WHILE !QRY1->(EOF())
	dDtAfas  := dDtRet := ctod("")
	cTipAfas    := " "
	
	fChkAfas(QRY1->RA_FILIAL,QRY1->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"HIJKLMNSU234" .Or.;
		(!Empty(QRY1->RA_DEMISSA) .And. MesAno(stod(QRY1->RA_DEMISSA))<= MesAno(dDtPesqAf))
		cTipAfas := "D"
		QRY1->(Dbskip())
		Loop
	Else
		cTipAfas := " "
	EndIf
	If MesAno(dDtAfas) > MesAno(dDtPesqAf)
		cTipAfas := " "
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao considera funcionarios admitidos apos o periodo do movimento ³
	//³ e nem os demitidos anterior ao periodo.						     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MesAno(stod(QRY1->RA_ADMISSA)) <= MesAno(dDtPesqAf) .and.;
		(Empty(QRY1->RA_DEMISSA) .or. MesAno(stod(QRY1->RA_DEMISSA)) >= MesAno(dDtPesqAf))
		dbSelectArea( "QRY1" )
		nVencto  := 0.00
		nDescto  := 0.00
		cSalLiq  := 0.00
		cBaseIss := 0.00
		cBaseIrr := 0.00
		cFgts    := 0.00
		cIrrFer  := 0.00
		IF iif( nRelat <>  4, SRC->(dbSeek(XFILIAL("SRC") + QRY1->RA_MAT)) , SRI->(dbSeek(XFILIAL("SRI") + QRY1->RA_MAT)) )
			CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
			SRJ->(Dbseek(xfilial("SRJ") + QRY1->RA_CODFUNC))
//			If !TemValor()
//				QRY1->(Dbskip())
//				Loop
//			Endif
			SRC->(dbSeek(XFILIAL("SRC") + QRY1->RA_MAT))
			SRI->(dbSeek(XFILIAL("SRI") + QRY1->RA_MAT))
			/*GRAVACAO DO REGISTRO TIPO-1 */
			clinha := "1" // TIPO DO REGISTRO
			clinha = clinha + padr(AllTrim(SM0->M0_NOMECOM),40) //AllTrim(SM0->M0_NOMECOM) + space(13) + space(40 - len(SM0->M0_NOMECOM))  // NOME DA EMPRESA
			clinha = clinha + SUBSTR(SM0->M0_CGC,1,2) + '.' + SUBSTR(SM0->M0_CGC,3,3) + '.' + SUBSTR(SM0->M0_CGC,6,3) +  '/' + SUBSTR(SM0->M0_CGC,9,4) + '-' +  SUBSTR(SM0->M0_CGC,13,2)  // CGC DA EMPRESA PRINCIPAL
			cLinha = cLinha + Right(QRY1->RA_MAT,5) // MATRICULA DO FUNCIONARIO
			cLinha = cLinha + QRY1->RA_NOME + space(5) // NOME DO FUNCIONARIO
			cLinha = cLinha + LEFT(QRY1->RA_CC,4) // COD SECAO

			If nRelat = 1 // adiantamento mostra o mes corrente
				cLinha = cLinha + Left(cMesAnoRef,2) + '/' + Right(cMesAnoRef,2) + "-" + Right(str(mv_par07),1) // MES-ANO
			elseIF nRelat = 3 // Primeira parcela 13o Salario
				clinha = clinha + strzero(MONTH(MV_PAR01),2)  + '/' + Right(str(year(MV_PAR01,2),4),2) + "-" + Right(str(mv_par07),1)
			elseIF nRelat = 4 // Segunda parcela 13o Salario
				clinha = clinha + strzero(MONTH(MV_PAR01),2)  + '/' + Right(str(year(MV_PAR01,2),4),2) + "-" + Right(str(mv_par07),1)
			else //folha de pagamento
				clinha = clinha +  iif (MONTH(MV_PAR01) > 1, strzero(MONTH(MV_PAR01)-1,2) + '/' + Right(str(year(MV_PAR01,2),4),2) + "-" + Right(str(mv_par07),1), "12" + '/' + Right(str(year(MV_PAR01,2)-1,4),2) + "-" + Right(str(mv_par07),1))
			endif

			cLinha = cLinha + SRJ->RJ_DESC + SPACE(40-LEN(SRJ->RJ_DESC)) // CARGO DO FUNCIONARIO
			cLinha = cLinha + TRANSFORM(QRY1->RA_SALARIO,'@E 9,999,999.99') // SALARIO BASE
			cLinha = cLinha + iif(empty(RIGHT(QRY1->RA_DEPIR,1)),'0',RIGHT(QRY1->RA_DEPIR,1)) // DEPENDENTES DE IR
			cLinha = cLinha + iif(empty(RIGHT(QRY1->RA_DEPSF,1)),'0',RIGHT(QRY1->RA_DEPSF,1)) // DEPENDENTES DE SALARIO FAMILIA
			cLinha = cLinha + CTT->CTT_DESC01 + SPACE(40-LEN(CTT->CTT_DESC01)) // DESCRICAO DA SECAO
			fWrite(nHandle, cLinha  + cCrLf )
			If nRelat  <> 4 // nao e 2 parcela do 13 salari ler dados do SRC
				Do While !SRC->(Eof()) .and. SRC->RC_FILIAL = XFILIAL("SRC") .and. SRC->RC_MAT =  QRY1->RA_MAT
					// Testar Data do pagamento
//					IF nRelat <> 3 .and. nRelat <> 4 // para pagamentos diferentes de  13o Salario
//						if SRC->RC_DATA <> MV_PAR01  .AND. !MONTH(SRC->RC_DATA) = iif(MONTH(MV_PAR01)>1,(MONTH(MV_PAR01)-1),12) .AND. !YEAR(SRC->RC_DATA) = iif(MONTH(MV_PAR01)=1,(YEAR(MV_PAR01)-1),YEAR(MV_PAR01)) // .and. !SRC->RC_PD $ '430'
//							SRC->(DbSkip())
//							Loop
//						endif
//					Else      // pagamento 13o salario
//						if SRC->RC_DATA <> MV_PAR01 .and. ! SRC->RC_PD  $ '733'
//							SRC->(DbSkip())
//							Loop
//						endif
//					Endif
					If  SRC->RC_PD <= '699' // so envia proventos e descontos
						SRV->(dbSeek(XFILIAL("SRV") + SRC->RC_PD ,.T.))
						If SRV->RV_TIPOCOD = '3' // VERBA DO TIPO BASE
							SRC->(DbSkip())
							Loop
						ENDIF
						if nrelat = 3 .AND. !SRC->RC_PD $ '220/473' // 1a. parcela do 13o Sal.
							SRC->(DbSkip())
							Loop
						endif
						if nrelat = 4 .AND. !SRC->RC_PD $ '221/224/226/227/474/414/460/403' // 2a. parcela do 13o Sal.
							SRC->(DbSkip())
							Loop
						endif
						IF NRELAT = 1 .AND. !SRC->RC_PD $ '430/001/417' // DAY(MV_PAR01) > 10 ADIANTAMENTO  NAO ENVIAR VERBAS QUE NÃO SEJAM REF. A  ADTO.
							SRC->(DbSkip())
							Loop
						ENDIF
						
						/* GRAVACAO DO REGISTRO TIPO-2 */
						clinha := "2" // TIPO DO REGISTRO
						If !SRC->RC_PD $ '430'
							clinha = clinha + Iif(SRC->RC_PD <= '399', 'P', 'D')  // FLAG DE PROVENTOS OU DESCONTOS
						ELSE
							clinha = clinha + IIF(nRelat = 1,'P','D')  // FLAG DE PROVENTOS OU DESCONTOS
						ENDIF
						cLinha = cLinha + SRC->RC_PD + space(1) // CODIGO DA VERBA
						cLinha = cLinha + TRANSFORM(SRC->RC_HORAS,"@Z 999.99") // REFERENCIA
						cLinha = cLinha + SRV->RV_DESC + SPACE(30-(LEN(SRV->RV_DESC))) // DESCRICAO DA VERBA
						cLinha = cLinha + TRANSFORM(SRC->RC_VALOR,"@E 999,999.99") // VALOR
						fWrite(nHandle, cLinha  + cCrLf)
					endif
//					If  nRelat = 3  // verbas do 13 salario - primeira parcela
//						IF SRC->RC_PD $ '220'
//							cSalLiq := SRC->RC_VALOR
//						ENDIF
//					endif
					If  nRelat = 4  // verbas do 13 salario - 2 parcela
						IF SRC->RC_PD $ '224'
							cSalLiq := SRC->RC_VALOR
						ENDIF
					endif
					IF SRC->RC_PD $ '715'
						cIrrFer := SRC->RC_VALOR
					endif
					IF SRC->RC_PD $ '730' .and.  nRelat <> 3  .and. nRelat <> 4
						cFgts := SRC->RC_VALOR
					endif
					IF SRC->RC_PD $ '733' .and. ( nRelat = 3  .or. nRelat = 4 )
						cFgts := SRC->RC_VALOR
					endif
					IF SRC->RC_PD $ '716/719/722' .AND.  NRELAT <> 3 .AND. NRELAT <> 4
						IF nRelat = 1 .AND. SRC->RC_PD $ '719'  // ADIANTAMENTO DE SALARIO DESCONTAR IRRF
							SRV->(dbSeek(XFILIAL("SRV") + SRC->RC_PD ,.T.))
							clinha := "2" // TIPO DO REGISTRO
							clinha = clinha + 'D'  // FLAG DE PROVENTOS OU DESCONTOS
							cLinha = cLinha + SRC->RC_PD + space(1) // CODIGO DA VERBA
							cLinha = cLinha + TRANSFORM(SRC->RC_HORAS,"@Z 999.99") // REFERENCIA
							cLinha = cLinha + SRV->RV_DESC + SPACE(30-(LEN(SRV->RV_DESC))) // DESCRICAO DA VERBA
							cLinha = cLinha + TRANSFORM(SRC->RC_VALOR,"@E 999,999.99") // VALOR
							fWrite(nHandle, cLinha  + cCrLf)
							cBaseIRR := SRC->RC_VALOR
						ENDIF
						iF 	nRelat = 2 .AND. SRC->RC_PD $ '716'
							cBaseIRR := SRC->RC_VALOR
						ENDIF
						If SRC->RC_PD $ '722' .and. nRelat = 1
							cBaseIRR := SRC->RC_VALOR
						endif
						If nDescto = 0  .and. SRC->RC_PD $ '719' .AND. NRELAT = 1 //IRRF ADIANTAMENTO
							nDescto:= SRC->RC_VALOR
						EndIF
					endif
					IF SRC->RC_PD $ '701' .and. nRelat <> 3  // INNS NAO ENTRA NO 13 SALARIO
						cBaseIss := SRC->RC_VALOR
					endif
					IF SRC->RC_PD $ '705' .and. nRelat = 4   // INNS 13o salario -segunda parcela
						cBaseIss := SRC->RC_VALOR
					endif
					// Carlos Rocha - 15/07/10
					//If SRC->RC_PD $ '987/998/430'  .and. nRelat <> 3
					If SRC->RC_PD $ '987/430'  .and. nRelat <> 3 .and. nRelat <> 2
						cSalLiq := SRC->RC_VALOR
						If nVencto = 0  .and. SRC->RC_PD $ '430'
							nVencto := SRC->RC_VALOR
						EndIF
						IF nRelat = 2 .AND. SRC->RC_PD $ '430'
							nDescto += SRC->RC_VALOR
						Endif
					EndIF

					// Carlos Rocha - 15/07/10
					// Não trata a verba 998 p/ adiantamento
					If SRC->RC_PD $ '998'  .and. nRelat <> 3 .and. nRelat <> 1
						cSalLiq := SRC->RC_VALOR
					EndIF			
					// Fim - CR
					
					if SRC->RC_PD <= '399'
						nVencto += SRC->RC_VALOR
					ENDIF
					If SRC->RC_PD > '399' .AND. SRC->RC_PD <= '699'  .and. (nRelat = 2 .or. nRelat = 3)//.and. !SRC->RC_PD $ '430'
						nDescto += SRC->RC_VALOR
					EndIF
					SRC->(DbSkip())
				EndDo
				If cSalLiq = nVencto .and. nDescto <> 0
					cSalLiq = cSalLiq - nDescto
				Endif
			Else // 2 Parcela do 13 Salario LER DADOS DO SRI
				Do While !SRI->(Eof()) .and. SRI->RI_FILIAL = XFILIAL("SRI") .and. SRI->RI_MAT =  QRY1->RA_MAT
					// Testar Data do pagamento
//					IF nRelat <> 3 .and. nRelat <> 4 // para pagamentos diferentes de  13o Salario
//						if SRI->RI_DATA <> MV_PAR01  .AND. !MONTH(SRI->RI_DATA)=iif(MONTH(MV_PAR01) >1,(MONTH(MV_PAR01)-1),12) .AND. ! YEAR(SRI->RI_DATA) = iif(MONTH(MV_PAR01) = 1,(YEAR(MV_PAR01)-1),YEAR(MV_PAR01)) // .and. !SRI->RI_PD $ '430'
//							SRI->(DbSkip())
//							Loop
//						endif
//					Else      // pagamento 13o salario
//						if SRI->RI_DATA <> MV_PAR01 .and. ! SRI->RI_PD  $ '733'
//							SRI->(DbSkip())
//							Loop
//						endif
//					Endif
					If  SRI->RI_PD <= '699' // so envia proventos e descontos
						SRV->(dbSeek(XFILIAL("SRV") + SRI->RI_PD ,.T.))
						If SRV->RV_TIPOCOD = '3' // VERBA DO TIPO BASE
							SRI->(DbSkip())
							Loop
						ENDIF
						if nrelat = 3 .AND.! SRI->RI_PD $ '220/473' // 1a. parcela do 13o Sal.
							SRI->(DbSkip())
							Loop
						EndIf
						if nrelat = 4 .AND.!SRI->RI_PD $ '197/198/221/224/226/227/474/414/460/403' // 2a. parcela do 13o Sal.
							SRI->(DbSkip())
							Loop
						endif
						IF NRELAT = 1 .AND.! SRI->RI_PD $ '430/001/417' // DAY(MV_PAR01) > 10 ADIANTAMENTO  NAO ENVIAR VERBAS QUE NÃO SEJAM REF. A  ADTO.
							SRI->(DbSkip())
							Loop
						ENDIF
						
						/* GRAVACAO DO REGISTRO TIPO-2 */
						clinha := "2" // TIPO DO REGISTRO
						If !SRI->RI_PD $ '430'
							clinha = clinha + Iif(SRI->RI_PD <= '399', 'P', 'D')  // FLAG DE PROVENTOS OU DESCONTOS
						ELSE
							clinha = clinha + IIF(nRelat = 1,'P','D')  // FLAG DE PROVENTOS OU DESCONTOS
						ENDIF
						cLinha = cLinha + SRI->RI_PD + space(1) // CODIGO DA VERBA
						cLinha = cLinha + TRANSFORM(SRI->RI_HORAS,"@Z 999.99") // REFERENCIA
						cLinha = cLinha + SRV->RV_DESC + SPACE(30-(LEN(SRV->RV_DESC))) // DESCRICAO DA VERBA
						cLinha = cLinha + TRANSFORM(SRI->RI_VALOR,"@E 999,999.99") // VALOR
						fWrite(nHandle, cLinha  + cCrLf)
					endif
					If  nRelat = 3  // verbas do 13 salario - primeira parcela
						IF SRI->RI_PD $ '220'
							cSalLiq := SRI->RI_VALOR
						ENDIF
					endif
					If  nRelat = 4  // verbas do 13 salario - 2 parcela
						IF SRI->RI_PD $ '224'
							cSalLiq := SRI->RI_VALOR
						ENDIF
					endif
					
					IF SRI->RI_PD $ '715'
						cIrrFer := SRI->RI_VALOR
					endif
					IF SRI->RI_PD $ '730' .and.  nRelat <> 3  .and. nRelat <> 4
						cFgts := SRI->RI_VALOR
					endif
					IF SRI->RI_PD $ '733' .and. ( nRelat = 3  .or. nRelat = 4 )
						cFgts := SRI->RI_VALOR
					endif
					IF SRI->RI_PD $ '717/716/719' .AND.  NRELAT <> 3
						IF nRelat = 3 .AND. SRI->RI_PD $ '719'  // ADIANTAMENTO DE SALARIO DESCONTAR IRRF
							SRV->(dbSeek(XFILIAL("SRV") + SRI->RI_PD ,.T.))
							clinha := "2" // TIPO DO REGISTRO
							clinha = clinha + 'D'  // FLAG DE PROVENTOS OU DESCONTOS
							cLinha = cLinha + SRI->RI_PD + space(1) // CODIGO DA VERBA
							cLinha = cLinha + TRANSFORM(SRI->RI_HORAS,"@Z 999.99") // REFERENCIA
							cLinha = cLinha + SRV->RV_DESC + SPACE(30-(LEN(SRV->RV_DESC))) // DESCRICAO DA VERBA
							cLinha = cLinha + TRANSFORM(SRI->RI_VALOR,"@E 999,999.99") // VALOR
							fWrite(nHandle, cLinha  + cCrLf)
							cBaseIRR := SRI->RI_VALOR
						ENDIF
						If SRI->RI_PD $ '717'
							cBaseIRR := SRI->RI_VALOR
						endif
						iF 	nRelat = 4 .AND. SRI->RI_PD $ '716'
							cBaseIRR := SRI->RI_VALOR
						ENDIF
						
						If nDescto = 0  .and. SRI->RI_PD $ '719' .AND. NRELAT = 1
							nDescto:= SRI->RI_VALOR
						EndIF
					endif
					
					IF SRI->RI_PD $ '701' .and. nRelat <> 3  // INNS NAO ENTRA NO 13 SALARIO
						cBaseIss := SRI->RI_VALOR
					endif
					IF SRI->RI_PD $ '705' .and. nRelat = 4   // INNS 13o salario -segunda parcela
						cBaseIss := SRI->RI_VALOR
					endif
					If SRI->RI_PD $ '987/998/430'  .and. nRelat <> 3
						cSalLiq := SRI->RI_VALOR
						If nVencto = 0  .and. SRI->RI_PD $ '430'
							nVencto := SRI->RI_VALOR
						EndIF
						IF nRelat = 4 .AND. SRI->RI_PD $ '430'
							nDescto += SRI->RI_VALOR
						Endif
					EndIF
					
					if SRI->RI_PD <= '399'
						nVencto += SRI->RI_VALOR
					ENDIF
					If SRI->RI_PD > '399' .AND. SRI->RI_PD <= '699'  .and. !SRI->RI_PD $ '430'
						nDescto += SRI->RI_VALOR
					EndIF
					SRI->(DbSkip())
				EndDo
				If cSalLiq = nVencto .and. nDescto <> 0
					cSalLiq += cSalLiq - nDescto
				Endif
			EndIf
			/* REGISTRO TIPO -3 */              
			cSalLiq := nVencto - nDescto
			clinha := "3" // TIPO DO REGISTRO
			clinha = clinha + LEFT(QRY1->RA_BCDEPSA,3)  // BANCO DEPOSITO DO SALARIO
			cLinha = cLinha + RIGHT(QRY1->RA_BCDEPSA,4) // AGENCIA DEPOSITO DO SALARIO
			cLinha = cLinha + LEFT(QRY1->RA_CTDEPSA,11) // CONTA DEPOSITO SALARIO
			cLinha = cLinha + TRANSFORM(nVencto,"@E 9,999,999.99") // TOTAL DE VENCIMENTOS
			cLinha = cLinha + TRANSFORM(nDescto,"@E 9,999,999.99") // TOTAL DE DESCONTOS
			cLinha = cLinha + TRANSFORM(cSalLiq,"@E 9,999,999.99") // SALARIO LIQUIDO
			cLinha = cLinha + TRANSFORM(cBaseIss,"@E 9,999,999.99") // BASE DE INSS
			cLinha = cLinha + TRANSFORM(cBaseIRR,"@E 9,999,999.99") //BASE DE IRR FOLHA
			cLinha = cLinha + TRANSFORM(cFgts,"@E 9,999,999.99") // VALOR FGTS
			cLinha = cLinha + MV_PAR08 + SPACE(80-(LEN(MV_PAR08))) // MENSAGEM  1
			cLinha = cLinha + MV_PAR09 + SPACE(80-(LEN(MV_PAR09))) // MENSAGEM  2
			cLinha = cLinha + MV_PAR10 + SPACE(80-(LEN(MV_PAR10))) // MENSAGEM  3
			cLinha = cLinha + MV_PAR11 + SPACE(74-(LEN(MV_PAR11))) // MENSAGEM  4
			cLinha = cLinha + LEFT(DTOC(MV_PAR01),5) + '/20' + RIGHT (DTOC(MV_PAR01),2)  //  DATA CREDITO
			cLinha = cLinha + TRANSFORM(cIRRFer,"@E 9,999,999.99") //BASE IRR FERIAS
			fWrite(nHandle, cLinha  + cCrLf)
		ENDIF
	ENDIF
	QRY1->(DbSkip())
	Incproc()
EndDo
fClose(nHandle)
MsgAlert( "Arquivo Gerado !" )
Return .T.
//---------------------------------------------------------------------------------------------------------------------------------------------------------//
Static Function fChkSX1( dPerIni , dPerFim , cPerg )

Local aAreaSX1	:= SX1->( GetArea() )
Local dVar      := Ctod("//")

SX1->(dbSetOrder(1))

IF SX1->(dbSeek(cPerg+"14",.F.))
	dVar := Ctod(SX1->X1_CNT01,'ddmmyy')
	IF dVar < dPerIni .or. dVar > dPerFim
		RecLock("SX1")
		SX1->X1_CNT01 := Dtoc(dPerIni)
		SX1->( MsUnlock() )
	EndIF
	SX1->( dbSkip() )
	IF SX1->( X1_GRUPO + X1_ORDEM ) == cPerg+"15"
		dVar := Ctod(SX1->X1_CNT01,'ddmmyy')
		IF dVar < dPerIni .Or. dVar > dPerFim
			RecLock("SX1")
			SX1->X1_CNT01 := Dtoc(dPerFim)
			SX1->( MsUnlock() )
		EndIF
	EndIF
EndIF

RestArea( aAreaSX1 )

Return( NIL )
Return .t.
//---------------------------------------------------------------------------------------------------------------------------------------------------------//
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
AAdd(aRegs,{cPerg,"01","Data Pagamento : "      ,""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
AAdd(aRegs,{cPerg,"02","Arquivo destino : "      ,""   				,""  			,"mv_ch2",	"C",		70      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return
//---------------------------------------------------------------------------------------------------------------------------------------------------------//
Static Function Streeper(cVar,nlen)
cVar = StrTran('\',cvar,'')
cVar = StrTran('/',cvar,'')
cVar = StrTran('.',cvar,'')
cVar = StrTran('-',cvar,'')
cVar = Alltrim(cVar)
cVar = alltrim(cVar) + space(nLen - Len(alltrim(cvar)))
Return(cVar)
//---------------------------------------------------------------------------------------------------------------------------------------------------------//
Static Function TemValor()
/* Verifica se o funcionario tem valor para receber antes de imprimir o Holerith */
Local lGravou := .F.
Local cSalLiq := nVencto := nDescto := 0
If nRelat <> 4 // nao e 2 parcela do 13 salario, BUSCAR DADOS DO SRC
	IF SRC->(dbSeek(XFILIAL("SRC") + QRY1->RA_MAT))
		SRC->(dbSeek(XFILIAL("SRC") + QRY1->RA_MAT))
		Do While !SRC->(Eof()) .and. SRC->RC_FILIAL = XFILIAL("SRC") .and. SRC->RC_MAT =  QRY1->RA_MAT
			// Testar Data do pagamento
//			IF nRelat <> 3 .and. nRelat <> 4 // para pagamentos diferentes de  13o Salario
//				if SRC->RC_DATA <> MV_PAR01  .AND. !MONTH(SRC->RC_DATA)=iif(MONTH(MV_PAR01) >1,(MONTH(MV_PAR01)-1),12) .AND. ! YEAR(SRC->RC_DATA) = iif(MONTH(MV_PAR01) = 1,(YEAR(MV_PAR01)-1),YEAR(MV_PAR01)) // .and. !SRC->RC_PD $ '430'
//					SRC->(DbSkip())
//					Loop
//				endif
//			Else      // pagamento 13o salario
//				if SRC->RC_DATA <> MV_PAR01 .and. ! SRC->RC_PD  $ '733'
//					SRC->(DbSkip())
//					Loop
//				endif
//			Endif
			If  SRC->RC_PD <= '699' // so envia proventos e descontos
				SRV->(dbSeek(XFILIAL("SRV") + SRC->RC_PD ,.T.))
				If SRV->RV_TIPOCOD = '3' // VERBA DO TIPO BASE
					SRC->(DbSkip())
					Loop
				ENDIF
				if nrelat = 3 .AND.! SRC->RC_PD $ '220/473' // 1a. parcela do 13o Sal.
					SRC->(DbSkip())
					Loop
				endif
				if nrelat = 4 .AND.!SRC->RC_PD $ '197/198/221/224/226/227/474/414/460/403' // 2a. parcela do 13o Sal.
					SRC->(DbSkip())
					Loop
				endif
				IF NRELAT = 1 .AND.! SRC->RC_PD $ '430/001/417' // DAY(MV_PAR01) > 10 ADIANTAMENTO  NAO ENVIAR VERBAS QUE NÃO SEJAM REF. A  ADTO.
					SRC->(DbSkip())
					Loop
				ENDIF
				
			endif
			If  nRelat = 3  // verbas do 13 salario - primeira parcela
				IF SRC->RC_PD $ '220'
					cSalLiq := SRC->RC_VALOR
				ENDIF
			endif
			If  nRelat = 4  // verbas do 13 salario - 2 parcela
				IF SRC->RC_PD $ '224'
					cSalLiq := SRC->RC_VALOR
				ENDIF
			endif
			
			IF SRC->RC_PD $ '715'
				cIrrFer := SRC->RC_VALOR
			endif
			IF SRC->RC_PD $ '730' .and.  nRelat <> 3  .and. nRelat <> 4
				cFgts := SRC->RC_VALOR
			endif
			IF SRC->RC_PD $ '733' .and. ( nRelat = 3  .or. nRelat = 4 )
				cFgts := SRC->RC_VALOR
			endif
			IF SRC->RC_PD $ '716/719' .AND.  NRELAT <> 3 .AND. NRELAT <> 4
				IF nRelat = 1 .AND. SRC->RC_PD $ '719'  // ADIANTAMENTO DE SALARIO DESCONTAR IRRF
					SRV->(dbSeek(XFILIAL("SRV") + SRC->RC_PD ,.T.))
					cBaseIRR := SRC->RC_VALOR
				ENDIF
				iF 	nRelat = 2 .AND. SRC->RC_PD $ '716'
					cBaseIRR := SRC->RC_VALOR
				ENDIF
				
				If nDescto = 0  .and. SRC->RC_PD $ '719' .AND. NRELAT = 1 //IRRF ADIANTAMENTO
					nDescto:= SRC->RC_VALOR
				EndIF
			endif
			
			IF SRC->RC_PD $ '701' .and. nRelat <> 3  // INNS NAO ENTRA NO 13 SALARIO
				cBaseIss := SRC->RC_VALOR
			endif
			IF SRC->RC_PD $ '705' .and. nRelat = 4   // INNS 13o salario -segunda parcela
				cBaseIss := SRC->RC_VALOR
			endif
			//If SRC->RC_PD $ '987/998/430'  .and. nRelat <> 3
			If SRC->RC_PD $ '987/430'  .and. nRelat <> 3 .and. nRelat <> 2
				cSalLiq := SRC->RC_VALOR
				If nVencto = 0  .and. SRC->RC_PD $ '430'
					nVencto := SRC->RC_VALOR
				EndIF
				IF nRelat = 1 .AND. SRC->RC_PD $ '430'
					nDescto += SRC->RC_VALOR
				Endif                       
			EndIF
			// Carlos Rocha - 15/07/10
			// Não trata a verba 998 p/ adiantamento
			If SRC->RC_PD $ '998'  .and. nRelat <> 3 .and. nRelat <> 1
				cSalLiq := SRC->RC_VALOR
			EndIF			
			// Fim - CR
			
			if SRC->RC_PD <= '399'
				nVencto += SRC->RC_VALOR
			ENDIF
			If SRC->RC_PD > '399' .AND. SRC->RC_PD <= '699'  .and. nRelat = 2
				nDescto += SRC->RC_VALOR
			EndIF
			SRC->(DbSkip())
		EndDo
		If cSalLiq = nVencto .and. nDescto <> 0
			cSalLiq := cSalLiq - nDescto
		Endif
		If cSalLiq >= 0
			LGravou := .t.
		EndIf
	Else
		lGravou := .F.
	Endif
ELSE // 2 PARCELA 13 SALARIO, BUSCAR DADOS DO SRI
	SRI->(dbSeek(XFILIAL("SRI") + QRY1->RA_MAT))
	If SRI->(dbSeek(XFILIAL("SRI") + QRY1->RA_MAT))
		Do While !SRI->(Eof()) .and. SRI->RI_FILIAL = XFILIAL("SRI") .and. SRI->RI_MAT =  QRY1->RA_MAT
			// Testar Data do pagamento
//			IF nRelat <> 3 .and. nRelat <> 4 // para pagamentos diferentes de  13o Salario
//				if SRI->RI_DATA <> MV_PAR01  .AND. !MONTH(SRI->RI_DATA)=iif(MONTH(MV_PAR01) >1,(MONTH(MV_PAR01)-1),12) .AND. ! YEAR(SRI->RI_DATA) = iif(MONTH(MV_PAR01) = 1,(YEAR(MV_PAR01)-1),YEAR(MV_PAR01)) // .and. !SRI->RI_PD $ '430'
//					SRI->(DbSkip())
//					Loop
//				endif
//			Else      // pagamento 13o salario
//				if SRI->RI_DATA <> MV_PAR01 .and. ! SRI->RI_PD  $ '733'
//					SRI->(DbSkip())
//					Loop
//				endif
//			Endif
			If  SRI->RI_PD <= '699' // so envia proventos e descontos
				SRV->(dbSeek(XFILIAL("SRV") + SRI->RI_PD ,.T.))
				If SRV->RV_TIPOCOD = '3' // VERBA DO TIPO BASE
					SRI->(DbSkip())
					Loop
				ENDIF
				if nrelat = 3 .AND.! SRI->RI_PD $ '220/473' // 1a. parcela do 13o Sal.
					SRI->(DbSkip())
					Loop
				endif
				if nrelat = 4 .AND.!SRI->RI_PD $ '197/198/221/224/226/227/474/414/460/403' // 2a. parcela do 13o Sal.
					SRI->(DbSkip())
					Loop
				endif
				IF NRELAT = 1 .AND.! SRI->RI_PD $ '430/001/417' // DAY(MV_PAR01) > 10 ADIANTAMENTO  NAO ENVIAR VERBAS QUE NÃO SEJAM REF. A  ADTO.
					SRI->(DbSkip())
					Loop
				ENDIF
			endif
			If  nRelat = 3  // verbas do 13 salario - primeira parcela
				IF SRI->RI_PD $ '220'
					cSalLiq := SRI->RI_VALOR
				ENDIF
			endif
			If  nRelat = 4  // verbas do 13 salario - 2 parcela
				IF SRI->RI_PD $ '224'
					cSalLiq := SRI->RI_VALOR
				ENDIF
			endif
			
			IF SRI->RI_PD $ '715'
				cIrrFer := SRI->RI_VALOR
			endif
			IF SRI->RI_PD $ '730' .and.  nRelat <> 3  .and. nRelat <> 4
				cFgts := SRI->RI_VALOR
			endif
			IF SRI->RI_PD $ '733' .and. ( nRelat = 3  .or. nRelat = 4 )
				cFgts := SRI->RI_VALOR
			endif
			IF SRI->RI_PD $ '716/719' .AND.  NRELAT <> 3 .AND. NRELAT <> 4
				IF nRelat = 3 .AND. SRI->RI_PD $ '719'  // ADIANTAMENTO DE SALARIO DESCONTAR IRRF
					SRV->(dbSeek(XFILIAL("SRV") + SRI->RI_PD ,.T.))
					cBaseIRR := SRI->RI_VALOR
				ENDIF
				iF 	nRelat = 4 .AND. SRI->RI_PD $ '716'
					cBaseIRR := SRI->RI_VALOR
				ENDIF
				
				If nDescto = 0  .and. SRI->RI_PD $ '719' .AND. NRELAT = 1
					nDescto:= SRI->RI_VALOR
				EndIF
			endif
			
			IF SRI->RI_PD $ '701' .and. nRelat <> 3  // INNS NAO ENTRA NO 13 SALARIO
				cBaseIss := SRI->RI_VALOR
			endif
			IF SRI->RI_PD $ '705' .and. nRelat = 4   // INNS 13o salario -segunda parcela
				cBaseIss := SRI->RI_VALOR
			endif
			If SRI->RI_PD $ '987/998/430'  .and. nRelat <> 3
				cSalLiq := SRI->RI_VALOR
				If nVencto = 0  .and. SRI->RI_PD $ '430'
					nVencto := SRI->RI_VALOR
				EndIF
				IF nRelat = 2 .AND. SRI->RI_PD $ '430'
					nDescto += SRI->RI_VALOR
				Endif
			EndIF
			
			if SRI->RI_PD <= '399'
				nVencto += SRI->RI_VALOR
			ENDIF
			If SRI->RI_PD > '399' .AND. SRI->RI_PD <= '699'  .and. !SRI->RI_PD $ '430'
				nDescto += SRI->RI_VALOR
			EndIF
			SRI->(DbSkip())
		EndDo
		If cSalLiq = nVencto .and. nDescto <> 0
			cSalLiq = cSalLiq - nDescto
		Endif
		If cSalLiq > 0
			lGravou := .T.
		Endif
	Else
		lGravou := .F.
	Endif
ENDIF

Return lGravou
//---------------------------------------------------------------------------------------------------------------------------------------------------------//