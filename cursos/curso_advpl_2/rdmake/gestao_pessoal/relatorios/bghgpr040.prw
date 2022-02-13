#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHGPR040ºAutor  ³ Vinicius Leonardo  º Data ³  21/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Mensal Resumo Argentina (Excel)   	              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BGHGPR040()

Private cPerg   := PADR("BHGPR040",10) 

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf

Processa( {|| OkProc() },,"Processando Relatório Mensal Resumo Argentina")

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OkProc()

Local _aXML := {}
Local cCrLf:=Chr(13)+Chr(10)
Local cMesAnoRef
Local dInicio := mv_par01
Local dFim := mv_par02
Local dDtPesqAf

Local yy := 0
Local cTipAfas    := " "
Local aXAfast := {}
Local nTur
Local nAfasta := nFerias := 0

Local _csrvapl := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp := "" //lower(AllTrim(__RELDIR)+"resumo argentina.csv") //Local _cArqTmp := lower(AllTrim(__RELDIR)+alltrim(cArquivo)+".csv")
Local Matricula1 := " "
Local Matricula2 := " " 
Local lFirst	 := .T. 
Local lFixosWork := .F. 
Local nContGer	 := 0

dDataRef := mv_par01
cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
Private dPerIni := CTOD("")
Private dPerFim := CTOD("")
Private aMarcFun   := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aMarcacoes := {}
Private nPosMarc   := 0
Private nLenMarc   := 0
Private nMax       := 0
Private Nachou     := 0
Private ZZ         := 0
Private aHorasP    := {}
Private xExtra     := 0
Private axFalta    := {}
Private cAnoMesRef := Right(cMesAnoRef,4) + Left(cMesAnoRef,2) 
Private QRY1 
Private aTotCC	   := {} 
Private aInss	   := {}
Private nHrAtDiv   := 0

Private nContGrp   := 0 
Private aTotGer	   := {}
Private cGrupoCC   := "" 
Private nAdim 	   := 0
Private	nDemi 	   := 0 
Private aTotFab	   := {} 
Private aGrpCus    := {}
Private cCustGrp   := SuperGetMV("BH_ARGRFA", ," ")
Private nPerCont   := 0  
Private nPEfet	   := 0 
Private llPerEfet  := .F.

dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")

//Gestão de Pessoal
MsgRun("Selecionando Registros, Aguarde...",,{|| AbrirQuery("QRY1") })

IF Select("TMPHR") <> 0
	DbSelectArea("TMPHR")
	DbCloseArea()
Endif
TCqUERY "SELECT PJ_TURNO , (PJ_HRSTRAB+PJ_HRSTRA2) AS HORAS FROM SPJ020 WHERE PJ_DIA = 2 AND PJ_SEMANA = '01' AND D_E_L_E_T_ = ' ' ORDER BY PJ_TURNO" NEW ALIAS "TMPHR"

DBSelectArea("QRY1")

_nRegs := 0
DbEval({|| _nRegs++ })
QRY1->(DBGoTop())
ProcRegua(_nRegs)

_Cabecalho(@_aXml,_nRegs)

If !QRY1->(Eof()) .AND. !QRY1->(Bof())
	
	While !QRY1->(Eof())
		IncProc("Gerando Relatorio, aguarde...")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao considera funcionarios admitidos apos o periodo do movimento ³
		//³ e nem os demitidos anterior ao periodo.						     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If MesAno(stod(QRY1->RA_ADMISSA)) <= MesAno(dDtPesqAf) .and. (Empty(QRY1->RA_DEMISSA) .or. MesAno(stod(QRY1->RA_DEMISSA)) >= MesAno(dDtPesqAf))
			yy := Ascan(aTotCC , {|x| x[1] =  QRY1->RA_CC })
			If yy = 0
				CTT->(MsSeek(Xfilial("CTT") + QRY1->RA_CC))
				aadd (aTotCC,;
				{QRY1->RA_CC,;		//01 CENTRO DE CUSTO
				0,;		 			//02 FUNCIONÁRIOS AFASTADOS INSS
				0,;		 			//03 HORAS PREVISTAS
				0,;		 			//04 FUNCIONARIOS EM FERIAS
				0,;		 			//05 HORAS EXTRAS
				0,;		 			//06 HORAS FALTAS/ATRASOS TOTAL
				0,;		 			//07 HORAS EM TREINAMENTO
				0,;		 			//08 TOTAL DE FUNCIONÁRIOS (ANTERIOR)
				0,;		 			//09 ADMITIDO
				0,;		 			//10 DEMITIDO
				0,;		 			//11 HORAS EM FERIAS
				CTT->CTT_DESC01,;	//12 DESCRIÇÃO CENTRO DE CUSTO
				0,;		 			//13 HORAS AFASTAMENTO INSS
				0,;		 			//14 HORAS FALTAS/ATRASOS DESCONTADO
				0,;		 			//15 HORAS FALTAS/ATRASOS ABONADO
				0,;		 			//16 HORAS EFETIVAS
				0,;		 			//17 SALDO BANCO DE HORAS				
				CTT->CTT_XGRPCC,;	//18 GRUPO DE CENTRO DE CUSTOS
				0,;		 			//19 BANCO DE HORAS(+) 
				0,;		 			//20 BANCO DE HORAS(-)
				0})   				//21 BANCO HORAS
			Endif
			yy := Ascan(aTotCC , {|x| x[1] == QRY1->RA_CC })
			
			If stod(QRY1->RA_ADMISSA) >= MV_PAR01 .And. stod(QRY1->RA_ADMISSA) <= MV_PAR02 //If mesano(stod(QRY1->RA_ADMISSA)) == MesAno(dDtPesqAf)
				aTotCC[yy,9] += 1 //ADMITIDO
			Endif
			
			If (stod(QRY1->RA_DEMISSA)) >= MV_PAR01 .And. (stod(QRY1->RA_DEMISSA)) <= MV_PAR02 //MesAno(stod(QRY1->RA_DEMISSA)) = MesAno(dDtPesqAf)) //demitidos
				cTipAfas := "D"
				aTotCC[yy,10] += 1 //DEMITIDO
			EndIf
			
			DbSelectArea("SR8")
			
			If SR8->(DbSeek(Xfilial("SR8") + QRY1->RA_MAT ))
				
				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SR8->R8_FILIAL + SR8->R8_MAT
					dinifer := mv_par01 //FIRSTDAY(mv_par02 + 30)
					dfimfer := mv_par02 //LASTDAY(mv_par02 + 30)
					
					If SR8->R8_TIPO $ 'O/P/Q' .and. SR8->R8_DATAFIM >= dinifer .and. SR8->R8_DATAINI <= dfimfer
						nAfasta := 0
						If SR8->R8_TIPO $ 'O/P' .and. (SR8->R8_DATAFIM - SR8->R8_DATAINI) >= 15
							If SR8->R8_DATAINI+15 <= dinifer .and. SR8->R8_DATAFIM >= dinifer	.and. SR8->R8_DATAFIM <= dfimfer//afastamento comecou antes do mes de calculo e acabou no mes de calculo
								nAfasta += xafasta(dInifer,SR8->R8_DATAFIM)
								cTipAfas := "A"
							Elseif SR8->R8_DATAINI+15 <= dinifer .and. SR8->R8_DATAFIM >= dfimfer//afastamento comecou antes do mes de calculo e acabou depois do mes de calculo
								nAfasta += xafasta(dInifer,dfimfer)
								cTipAfas := "A"
							ElseIf SR8->R8_DATAINI+15 >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  //afastamento está no mes de calculo
								nAfasta += xafasta(SR8->R8_DATAINI+15,SR8->R8_DATAFIM)
								cTipAfas := "A"
							ElseIf SR8->R8_DATAINI+15 >= dinifer .and. SR8->R8_DATAINI+14 <= dfimfer .and. SR8->R8_DATAFIM >= dfimfer //afastamento comecou no mes de calculo e acabou depois
								nAfasta += xafasta(SR8->R8_DATAINI+15,dfimfer)
								cTipAfas := "A"
							EndIf
						ElseIf SR8->R8_TIPO $ 'Q'
							If SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dinifer	.and. SR8->R8_DATAFIM <= dfimfer//afastamento comecou antes do mes de calculo e acabaram no mes de calculo
								nAfasta += xafasta(dInifer,SR8->R8_DATAFIM)
								cTipAfas := "A"
							Elseif SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dfimfer//afastamento comecou antes do mes de calculo e acabaram depois do mes de calculo
								nAfasta += xafasta(dInifer,dfimfer)
								cTipAfas := "A"
							ElseIf SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  //afastamento estao no mes de calculo
								nAfasta += xafasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)
								cTipAfas := "A"
							ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAINI <= dfimfer .and. SR8->R8_DATAFIM >= dfimfer //afastamento comecou no mes de calculo e acabaram depois
								nAfasta += xafasta(SR8->R8_DATAINI,dfimfer)
								cTipAfas := "A"
							EndIf
						EndIf
						
						If cTipAfas == 'A'
							Matricula1 := QRY1->RA_MAT
							If Matricula1 <> Matricula2
								aTotCC[yy,2] += 1 //FUNCIONÁRIOS AFASTADOS INSS
								Matricula2 := SR8->R8_MAT 
								//If QRY1->RA_SITFOLH == 'A'								
									Aadd(aInss,{SR8->R8_MAT+DTOS(SR8->R8_DATAINI)+SR8->R8_TIPO})
								//EndIf	
							EndIf 							
							aTotCC[yy,13] := SomaHoras(aTotCC[yy,13],ConvHr(nAfasta,TMPHR->HORAS)) //HORAS AFASTAMENTO INSS
						EndIf
					EndIf
					
					If SR8->R8_TIPO $ 'F'
						nFerias := 0
						if SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dinifer	.and. SR8->R8_DATAFIM <= dfimfer//as ferias comecaram antes do mes de calculo e acabaram no mes de calculo
							nFerias += xafasta(dInifer,SR8->R8_DATAFIM)
							cTipAfas := "F"
						Elseif SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dfimfer//as ferias comecaram antes do mes de calculo e acabaram depois do mes de calculo
							nFerias += xafasta(dInifer,dfimfer)
							cTipAfas := "F"
						ElseIf SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  //as ferias estao no mes de calculo
							nFerias += xafasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)               //29
							cTipAfas := "F"
						ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAINI <= dfimfer .and. SR8->R8_DATAFIM >= dfimfer //as ferias comecaram no mes de calcule e acabaram depois do mes de calculo
							nFerias += xafasta(SR8->R8_DATAINI,dfimfer)
							cTipAfas := "F"
						Else //as ferias estao fora do periodo de calculo
							nFerias += 0
							cTipAfas := " "
						EndIf
						
						If cTipAfas == 'F'
							aTotCC[yy,4]  += 1 //FUNCIONARIOS EM FERIAS
							aTotCC[yy,11] := SomaHoras(aTotCC[yy,11],ConvHr(nFerias,TMPHR->HORAS)) //HORAS EM FERIAS
						EndIf
						
					EndIf
					
					DbSelectArea("SR8")
					DbSkip()
				Enddo
				DbSelectArea("QRY1")
				
			Else
				dbSelectArea( "QRY1" )
			Endif
			//		testa eventos abonados do ponto eletronico - FALTAS, ATRASOS ETC*/
			aMarcacoes	:= {}
			aTabCalend	:= {}
			axFalta     := {}
			//adet:= TestaPonto()
			
			If (stod(QRY1->RA_ADMISSA)) < MV_PAR02
				aTotCC[yy,8]   += 1  //TOTAL DE FUNCIONÁRIOS (ANTERIOR)
			EndIf
			
			aTotCC[yy,3]   := SomaHoras(aTotCC[yy,3],HrUtil(mv_par01,mv_par02))		//HORAS PREVISTAS
			aTotCC[yy,14]  := SomaHoras(aTotCC[yy,14],getFaltas(QRY1->RA_MAT,.F.))	//HORAS FALTAS/ATRASOS DESCONTADO
			aTotCC[yy,15]  := SomaHoras(aTotCC[yy,15],getFaltas(QRY1->RA_MAT,.T.))	//HORAS FALTAS/ATRASOS ABONADO 			
			//nHrAtDiv := nHrAtDiv+aTotCC[yy,15]
			
			aTotCC[yy,7]   := SomaHoras(aTotCC[yy,7],getTreina(QRY1->RA_MAT))		//HORAS EM TREINAMENTO
			aTotCC[yy,17]  := SomaHoras(aTotCC[yy,17],getBanco(QRY1->RA_MAT,"="))	//SALDO BANCO DE HORAS 
			
			aTotCC[yy,19]  := SomaHoras(aTotCC[yy,19],getBanco(QRY1->RA_MAT,"+"))	//BANCO HORAS (+)
			aTotCC[yy,20]  := SomaHoras(aTotCC[yy,20],getBanco(QRY1->RA_MAT,"-"))	//BANCO HORAS (-)
			
			dbSelectArea( "QRY1" )
			
			aTotCC[yy,21]  := getBancoHoras(QRY1->RA_MAT) //BANCO DE HORAS       
			//ATotCC[yy,14] := SubHoras(ATotCC[yy,14],_nTotBanco) //HORAS FALTAS/ATRASOS DESCONTADO
			
			ATotCC[yy,5] := SomaHoras(ATotCC[yy,5],getHe(QRY1->RA_MAT)) //HORAS EXTRAS
			
		ENDIF				

		QRY1->(DBSkip())
	EndDo
		
	ASORT(aTotCC,,, { |x, y| x[18] < y[18] })
	zz := 0
	nMax := Len(aTotCC)
	
	For zz = 1 to nMax
		If !Empty(aTotcc[zz,18]) 
			If !lFixosWork
				FixosWork(@_aXml,_nRegs)
				lFixosWork := .T.
			EndIf				    
			If cGrupoCC != aTotcc[zz,18]
				If !lFirst         
					// imprime total do grupo de centro de custos					
					_Body(@_aXml,_nRegs,.T.,.F.) 
					
					// adiciona no array para fórmula de soma de total geral
					nContGer:= nContGer+1
					aAdd(aTotGer,{nContGrp,nContGer,cGrupoCC})
										 
					// zera contador para fórmula de soma de totais por grupo
					nContGrp := 0					
				Else
					lFirst := .F.
				EndIf
			EndIf 
			
			nHDisp := SomaHoras(aTotCC[zz,3],'-' + AllTrim(Str(aTotCC[zz,11])))
			
			nHFalta := subHoras(SomaHoras(SomaHoras(aTotCC[zz,15],aTotCC[zz,14]),aTotCC[zz,7]), aTotCC[zz,21]) 

			if nHFalta < 0
				nHFalta := 0
			endif
			
			iif ( nHFalta <= nHDisp , aTotCC[zz,14] := nHFalta , aTotCC[zz,14] := nHDisp)			
			
			// imprime valores por cada centro de custo
			_Body(@_aXml,_nRegs,.F.,.F.)
			
			// soma para os totais de admissão
			nAdim := nAdim + aTotcc[zz,9] 
			
			// soma para os totais de demissão
			nDemi := nDemi + aTotcc[zz,10]
			
			// soma no contador para fórmula de soma de totais por grupo
			nContGrp := nContGrp+1 
			
			// soma no contador para fórmula de soma Personal Efectivos
			nPerCont := nPerCont+1
			
			// soma no contador para fórmula de soma Personal Efectivos
			If llPerEfet .and. cGrupoCC # aTotcc[zz,18]
				nPEfet := nPEfet+1 
			EndIf
			
			// adiciona no array para impressão de total fábrica (Personal Efectivos)
			If Alltrim(aTotcc[zz,1]) $ cCustGrp
				Aadd(aGrpCus,{nPerCont,Alltrim(aTotcc[zz,1])})
				llPerEfet :=  .T. 
			EndIf	
			
			cGrupoCC := aTotcc[zz,18]
		EndIf	
	Next zz	
	// imprime total do grupo de centro de custos					
	_Body(@_aXml,_nRegs,.T.,.F.) 
	
	// adiciona no array para fórmula de soma de total geral
	nContGer:= nContGer+1
	aAdd(aTotGer,{nContGrp,nContGer,cGrupoCC}) 
	
	// adiciona no array para impressão de total fábrica (controle argentina)
	aTotFab := aTotGer
	
	// imprime total geral
	_Body(@_aXml,_nRegs,.T.,.T.)
	
	FixHeadCount(@_aXml,_nRegs)
	
	_Rodape(@_aXML) 
	
	aadd(_aXML,'</Workbook>')
	
	cArqTxt := CriaTrab(NIL,.F.)
	cArqTxt := Alltrim(cArqTxt)+".XML"
	n_arq   := fcreate(cArqTxt)
	
	For nI := 1 to len(_aXML)
		fWrite(n_arq,_aXML[nI]+CRLF)
	Next
	
	fclose(n_arq)
	
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.") //--- Microsoft Excel nao instalado ---
		Return
	EndIf
	
	cPath := AllTrim(GetTempPath())
	CpyS2T( cArqTxt, cPath, .F. )
	
	oExcelApp   := NIL
	oExcelApp	:= MsExcel():New()
	oExcelApp	:WorkBooks:Open(cPath+cArqTxt)
	oExcelApp	:SetVisible(.T.)
	lIntExcel	:= .T.
	oExcelApp   := NIL
Else
	Alert("Não existem dados a serem exportados")
Endif

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ _Body³	  Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _Body(_aXml,_nRegs,lTotGrp,lTotGer) 

Local nQtdAcu := 0 

DEFAULT _aXML := {}		

If !lTotGrp .and. !lTotGer
			
	//LINHA QUE INFORMA OS CENTROS DE CUSTOS E SEUS VALORES 
		
	aadd(_aXML,'   <Row ss:Height="12.75">')
	aadd(_aXML,'    <Cell ss:Index="2" ss:StyleID="s105"><Data ss:Type="Number">'+Alltrim(aTotcc[zz,1])+'</Data></Cell>')		// C.C
	aadd(_aXML,'    <Cell ss:StyleID="s106"><Data ss:Type="String">'+lower(Alltrim(aTotcc[zz,12]))+'</Data></Cell>') 			// BDB
	aadd(_aXML,'    <Cell ss:Index="5" ss:StyleID="s107"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,8]))+'</Data></Cell>')	// PESSOAS
	aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,3]))+'</Data></Cell>') 				// HORAS ÚTEIS
	aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,5]))+'</Data></Cell>') 				// HORAS EXTRAS
	aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,11]))+'</Data></Cell>') 				// FÉRIAS
	//If aTotCC[zz,17] >= 0.00
		aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotCC[zz,19]))+'</Data></Cell>') 			// BANCO HORAS (+)
	//Else
		//aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">0</Data></Cell>') 										// BANCO HORAS (+)
	//EndIf	
	//If aTotCC[zz,17] < 0.00
		aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotCC[zz,20]))+'</Data></Cell>') 			//BANCO HORAS (-)
	//Else 
		//aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">0</Data></Cell>') 										//BANCO HORAS (-)
	//EndIf	
	aadd(_aXML,'    <Cell ss:StyleID="s109" ss:Formula="=RC[-5]+RC[-4]-RC[-3]+RC[-2]+RC[-1]"><Data')  							// HORAS DISP
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>') 	
	aadd(_aXML,'    <Cell ss:StyleID="s110"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,14]))+'</Data></Cell>')				// FALTAS/ATRASOS/ATESTADOS MÉDICOS/SAÍDA ANTECIPADA
	aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,13]))+'</Data></Cell>') 				// AFASTAMENTO/INSS
	aadd(_aXML,'    <Cell ss:StyleID="s108"><Data ss:Type="Number">'+alltrim(str(aTotcc[zz,7]))+'</Data></Cell>') 				// TREINAMENTO
	aadd(_aXML,'    <Cell ss:StyleID="s109" ss:Formula="=RC[-4]-RC[-3]-RC[-2]-RC[-1]"><Data') 									// HORAS TRAB.
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s111" ss:Formula="=IF(RC[-11]=0,0,RC[-10]/RC[-11])"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s112"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s112"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s112"/>')
	aadd(_aXML,'   </Row>')
	
ElseIf lTotGrp .and. !lTotGer  
	
	//LINHA TOTAL POR GRUPO 
	aadd(_aXML,'   <Row ss:Height="13.5">')
	aadd(_aXML,'    <Cell ss:Index="2" ss:StyleID="s119"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s120"><Data ss:Type="String">Total '+lower(Alltrim(Posicione("SX5",1,xFilial("SX5") + "VB"+cGrupoCC, "X5_DESCRI")))+'</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s121"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s122" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s123" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s124" ss:Formula="=SUM(R[-'+alltrim(str(nContGrp))+']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'   </Row>')
	
	// LINHA EM BRANCO
	aadd(_aXML,'   <Row ss:Height="13.5">')
	aadd(_aXML,'    <Cell ss:StyleID="s75"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s75"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
	aadd(_aXML,'   </Row>')
	
ElseIf lTotGrp .and. lTotGer
	
	ASORT(aTotGer,,, { |x, y| x[2] > y[2] })
	aTotais := Array(Len(aTotGer)-1)
	nQtdAcu := 2
	cFormul := "R[-2]C"
	
	For nx:=1 to Len(aTotGer)	    
	 	If nx!=Len(aTotGer)
			aTotais[nx] := nQtdAcu + aTotGer[nx][1] + 2 			
			nQtdAcu := aTotais[nx]
		EndIf	
	Next nx
	For nx:=1 to Len(aTotais)
		cFormul := "R[-"+alltrim(str(aTotais[nx]))+"]C+"+cFormul 
	Next nx		
	
	//LINHA TOTAL GERAL 
	aadd(_aXML,'   <Row ss:Height="13.5">')
	aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s152"><Data ss:Type="String">Total BGH</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s153"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s154" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s155" ss:Formula="='+cFormul+'"><Data')
	aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s67"/>')
	aadd(_aXML,'   </Row>')
	
	//LINHA EM BRANCO
	aadd(_aXML,'   <Row ss:Height="12.75"/>')
	
	//LINHA EM BRANCO
	aadd(_aXML,'   <Row ss:Height="13.5"/>')
	
EndIf	

Return 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FixosWork³ 	Autor ³ DeltaDecisao      ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FixosWork(_aXml,_nRegs)

DEFAULT _aXML := {}

//NOME DA WORKSHEET
aadd(_aXML,'<Worksheet ss:Name="Horas mes ">')

//DEFINIÇÃO DA EXPANSÃO DE LINHAS E COLUNAS
aadd(_aXML,' <Table ss:ExpandedColumnCount="21" ss:ExpandedRowCount="'+Alltrim(str(Len(aTotCC)+100))+'" x:FullColumns="1"') 
aadd(_aXML,'  x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="0" ss:DefaultRowHeight="0">') 

//DEFINIÇÃO DAS COLUNAS E SEUS TAMANHOS
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="13.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s63" ss:Width="29.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Width="197"/>')          
aadd(_aXML,'   <Column ss:StyleID="s64" ss:AutoFitWidth="0" ss:Width="13.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s65" ss:AutoFitWidth="0" ss:Width="77.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="124.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s67" ss:Width="71.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Width="53.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Width="70.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="69"/>')
aadd(_aXML,'   <Column ss:StyleID="s68" ss:Width="73.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Width="143.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="98.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="71.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s68" ss:AutoFitWidth="0" ss:Width="69.75"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="53.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="13.5"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="59.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="65.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="33.75"/>')
aadd(_aXML,'   <Column ss:StyleID="s62" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="59.25"/>')

//DEFINIÇÃO DAS LINHAS E SEUS CONTEÚDOS 

DbSelectArea("SP3")
SP3->(DbSetOrder(1))

nNorCont:=nQuiCont:=nEstCont:=nDias:= Last_Day(STOD(AnoMes(mv_par01)+'01')) 

For nx:=1 to nDias 
	SP3->(DbGoTop())   
	If SP3->(DbSeek(xFilial("SP3")+AnoMes( mv_par01 )+Strzero(nx,2)))				
		nNorCont := nNorCont - 1
		nEstCont := nEstCont - 1
		nQuiCont := nQuiCont - 1 
	Else
		If DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 1 .or. DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 7
			nNorCont := nNorCont - 1
		EndIf 
		If DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 1 .or. DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 6 .or. DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 7
			nEstCont := nEstCont - 1
		EndIf
		If DOW( STOD(AnoMes( mv_par01 )+Strzero(nx,2)) ) == 1 
			nQuiCont := nQuiCont - 1
		EndIf
	EndIf
Next nx			

//LINHA DIAS ÚTEIS - MANHÃ
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s69"/>')
aadd(_aXML,'    <Cell ss:StyleID="s70"/>')
aadd(_aXML,'    <Cell ss:Index="6" ss:StyleID="s72"><Data ss:Type="String">DIAS UTEIS:</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s73"><Data ss:Type="Number">'+alltrim(str(nNorCont))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74" ss:Formula="=RC[-1]*8.8"><Data ss:Type="Number">184.8</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s68"><Data ss:Type="String">Normal</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'   </Row>')

//LINHA QUIOSQUE
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="6" ss:StyleID="s75"/>')
aadd(_aXML,'    <Cell ss:StyleID="s73"><Data ss:Type="Number">'+alltrim(str(nQuiCont))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74" ss:Formula="=RC[-1]*7.3"><Data ss:Type="Number">228.8</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s68"><Data ss:Type="String">Quiosque</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'   </Row>')

//LINHA MENOR APRENDIZ
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s76"><Data ss:Type="String">Resumo Horas Trabalhadas em:</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s77"/>')
aadd(_aXML,'    <Cell ss:Index="6" ss:StyleID="s75"/>')
aadd(_aXML,'    <Cell ss:StyleID="s73"><Data ss:Type="Number">'+alltrim(str(nEstCont))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74" ss:Formula="=RC[-1]*6"><Data ss:Type="Number">126</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s68"><Data ss:Type="String">Menor Aprendiz</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'   </Row>') 

//LINHA QUE INFORMA A DATA DO RELATÓRIO
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s78"><Data ss:Type="DateTime">'+Substr(DTOS(MV_PAR01),1,4)+'-'+Substr(DTOS(MV_PAR01),5,2)+'-'+Substr(DTOS(MV_PAR01),7,2)+'T00:00:00.000</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s79"/>')
aadd(_aXML,'    <Cell ss:Index="7" ss:StyleID="s80"/>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'   </Row>')

//LINHA EM BRANCO
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="8" ss:StyleID="s80"/>')
aadd(_aXML,'    <Cell ss:StyleID="s80"/>')
aadd(_aXML,'    <Cell ss:StyleID="s80"/>')
aadd(_aXML,'    <Cell ss:StyleID="s80"/>')
aadd(_aXML,'    <Cell ss:StyleID="s74"/>')
aadd(_aXML,'   </Row>')

//LINHA CABEÇALHO 
aadd(_aXML,'   <Row ss:Height="39">')
aadd(_aXML,'    <Cell ss:Index="2" ss:StyleID="s81"><Data ss:Type="String">C.C.</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s82"><Data ss:Type="String">BdB</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s83"/>')
aadd(_aXML,'    <Cell ss:StyleID="s84"><Data ss:Type="String">Pessoas</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s85"><Data ss:Type="String">Horas Uteis (Dias uteis x Horas dia x numero de func)</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Horas Extras</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Ferias</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Banco Horas (+)</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Banco Horas (-)</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s87"><Data ss:Type="String">Horas Disp</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Faltas-Atrasos-Atestados medicos-saida antecip</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Afastamento-INSS</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Treinamento</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s86"><Data ss:Type="String">Horas Trab.</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s88"/>')
aadd(_aXML,'   </Row>')

//LINHA EM BRANCO
aadd(_aXML,'   <Row ss:Height="13.5" ss:StyleID="s90">')
aadd(_aXML,'    <Cell ss:Index="2" ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s94"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'    <Cell ss:StyleID="s755"/>')
aadd(_aXML,'   </Row>')

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FixHeadCount³ Autor ³ DeltaDecisao      ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FixHeadCount(_aXml,_nRegs)

Local lPrimeiro	:= .T. 
Local cFormFab	:= ""    
Local cFSomAusAb:= ""
Local cFDivAusAb:= ""
Local nLin		:= 0 
Local cGrpProd	:= SuperGetMV("BH_ARTOTFA", ," ")    
Local aAusAb	:= {} 
Local cFHrExt   := ""
Local cFDivHrExt:= ""
Local cFFerias 	:= ""
Local cFDivFer 	:= "" 
Local cPeEfetForm := ""  
Local nEstag	:= 0 	
Local nEfet		:= 0 
Local nContrat	:= 0

DEFAULT _aXML := {}

nLin := 7
For nx:=1 To Len(aTotFab)  
	If aTotFab[nx][3] $ cGrpProd 
		If lPrimeiro
			cFormFab := '=R[-'+alltrim(str(nLin))+']C[-8]'
			cPeEfetForm := '=R[-'+alltrim(str(nLin-1))+']C[-8]'	  
					
			cFSomAusAb := '=(R[-'+alltrim(str(nLin+1))+']C[-1]+R[-'+alltrim(str(nLin+1))+']C+R[-'+alltrim(str(nLin+1))+']C[1]' 
			cFDivAusAb := '/(R[-'+alltrim(str(nLin+1))+']C[-7]'	 
							
			cFHrExt		:= '=(R[-'+alltrim(str(nLin+2))+']C[-6]'
			cFDivHrExt	:= '/(R[-'+alltrim(str(nLin+2))+']C[-7]' 
			
			cFFerias	:= '=(R[-'+alltrim(str(nLin+3))+']C[-5]'
			cFDivFer	:= '/(R[-'+alltrim(str(nLin+3))+']C[-7]'
				
			lPrimeiro := .F.		
		Else
			cFormFab := cFormFab + '+R[-'+alltrim(str(nLin))+']C[-8]' 	 
			cPeEfetForm := cPeEfetForm + '+R[-'+alltrim(str(nLin-1))+']C[-8]' 	 
				
			cFSomAusAb := cFSomAusAb + '+R[-'+alltrim(str(nLin+1))+']C[-1]+R[-'+alltrim(str(nLin+1))+']C+R[-'+alltrim(str(nLin+1))+']C[1]'   
			cFDivAusAb := cFDivAusAb + '+R[-'+alltrim(str(nLin+1))+']C[-7]'     
			
			cFHrExt		:= cFHrExt + '+R[-'+alltrim(str(nLin+2))+']C[-6]'
			cFDivHrExt	:= cFDivHrExt + '+R[-'+alltrim(str(nLin+2))+']C[-7]'
			
			cFFerias	:= cFFerias + '+R[-'+alltrim(str(nLin+3))+']C[-5]'
			cFDivFer	:= cFDivFer + '+R[-'+alltrim(str(nLin+3))+']C[-7]'
			
		EndIf	
	EndIf
	nLin := nLin + aTotFab[nx][1] + 2
Next nx      
cFSomAusAb := cFSomAusAb + ')'
cFDivAusAb := cFDivAusAb + ')'
cFHrExt    := cFHrExt + ')'
cFDivHrExt := cFDivHrExt + ')'
cFFerias   := cFFerias + ')'
cFDivFer   := cFDivFer + ')'  

lPrimeiro := .T.
nLin:=5
nFixo:=2
For nx:= 1 To nPEfet
	nFixo := nFixo+2
Next nx	 

For nx:=1 To Len(aGrpCus)
	If lPrimeiro 	
		cPeEfetForm := cPeEfetForm + '+R[-'+alltrim(str(nLin+nFixo+nPerCont-aGrpCus[nx][1]))+']C[-8]'		
		lPrimeiro	:= .F.
	Else 	
		cPeEfetForm := cPeEfetForm + '+R[-'+alltrim(str(nLin+nFixo+nPerCont-aGrpCus[nx][1]))+']C[-8]' 	
	EndIf 
Next nx 

//LINHAS ABAIXO DO TOTAL - HEADCOUNT
aadd(_aXML,'   <Row ss:Height="15.75">')
aadd(_aXML,'    <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="m35090432"><Data')
aadd(_aXML,'      ss:Type="String">Headcount - BdB</Data></Cell>')
aadd(_aXML,'    <Cell ss:MergeAcross="2" ss:StyleID="m35090452"><Data ss:Type="String">TurnOver</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s165"/>')
aadd(_aXML,'    <Cell ss:StyleID="s165"/>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s166"><Data ss:Type="String">Total Fabrica</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s167"><Data ss:Type="DateTime">'+Substr(DTOS(MV_PAR01),1,4)+'-'+Substr(DTOS(MV_PAR01),5,2)+'-'+Substr(DTOS(MV_PAR01),7,2)+'T00:00:00.000</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s168"><Data ss:Type="String">Efetivos</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s169"/>')

cSQL := " SELECT count(*) AS QTD "   
cSQL += " FROM SRA020 SRA "    
cSQL += " WHERE D_E_L_E_T_ = '' "  
cSQL += " AND RA_ADMISSA <= '" + DTOS(MV_PAR02) + "' " 
cSQL += " AND (RA_DEMISSA = '' OR RA_DEMISSA >= '" + DTOS(MV_PAR01) + "') "
cSQL += " AND RA_MAT NOT BETWEEN '700000' AND '800000'  " 
cSQL += " AND RA_CODFUNC NOT IN ('0230','0106')  "
cSQL += " AND RA_FILIAL <> '03'  "
 
TcQuery cSQL NEW Alias "EFET"
DbSelectArea("EFET")
While EFET->(!Eof())	
	nEfet:=EFET->QTD
	EFET->(DbSkip())
EndDo
DbCloseArea("EFET")

cSQL := " SELECT count(*) AS QTD  "  
cSQL += " FROM SRA020 SRA  "   
cSQL += " WHERE D_E_L_E_T_ = ''  " 
cSQL += " AND RA_ADMISSA <= '" + DTOS(MV_PAR02) + "' "  
cSQL += " AND (RA_DEMISSA = '' OR RA_DEMISSA >= '" + DTOS(MV_PAR01) + "') "
cSQL += " AND RA_MAT NOT BETWEEN '700000' AND '800000'  " 
cSQL += " AND (RA_CODFUNC IN ('0230','0106') OR RA_FILIAL = '03') " 
 
TcQuery cSQL NEW Alias "TEMPOR"
DbSelectArea("TEMPOR")
While TEMPOR->(!Eof())	
	nEstag:=TEMPOR->QTD
	TEMPOR->(DbSkip())
EndDo
DbCloseArea("TEMPOR")

cSQL := " SELECT COUNT(*) AS QTD FROM SRA020 WHERE D_E_L_E_T_ <> '*' AND RA_FILIAL = '06' "
cSQL += " AND RA_MAT BETWEEN '700000' AND '800000' " 

TcQuery cSQL NEW Alias "CONTRAT"
DbSelectArea("CONTRAT")
If CONTRAT->(!Eof())	
	nContrat:=CONTRAT->QTD
	CONTRAT->(DbSkip())
EndIf
DbCloseArea("CONTRAT")

aadd(_aXML,'    <Cell ss:StyleID="s170"><Data ss:Type="Number">'+alltrim(str(nEfet))+'</Data></Cell>')	
aadd(_aXML,'    <Cell ss:StyleID="s171"><Data ss:Type="String">Admissao</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s172"/>')
aadd(_aXML,'    <Cell ss:StyleID="s173"><Data ss:Type="Number">'+alltrim(str(nAdim))+'</Data></Cell>')   
aadd(_aXML,'    <Cell ss:StyleID="s70"/>')
aadd(_aXML,'    <Cell ss:StyleID="s70"/>') 
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s174"><Data ss:Type="String">Personal Efectivos</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s175"')
aadd(_aXML,'     ss:Formula="'+cPeEfetForm+'"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s171"><Data ss:Type="String">Temporarios - Estagiarios-Aprendiz</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s169"/>')
aadd(_aXML,'    <Cell ss:StyleID="s176"><Data ss:Type="Number">'+alltrim(str(nEstag))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s177"><Data ss:Type="String">Demissao</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s178"/>')
aadd(_aXML,'    <Cell ss:StyleID="s179"><Data ss:Type="Number">'+alltrim(str(nDemi))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s70"/>')
aadd(_aXML,'    <Cell ss:StyleID="s70"/>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s174"><Data ss:Type="String">MOD + MOI APLIC.</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s175" ss:Formula="'+cFormFab+'"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="3" ss:StyleID="s180"><Data ss:Type="String">TOTAIS</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s169"/>')
aadd(_aXML,'    <Cell ss:StyleID="s181" ss:Formula="=SUM(R[-2]C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s180"><Data ss:Type="String">TurnOver</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s182"/>')
aadd(_aXML,'    <Cell ss:StyleID="s184" ss:Formula="=R[-1]C/R[-2]C[-3]"><Data ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s185"/>')
aadd(_aXML,'    <Cell ss:StyleID="s185"/>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s186"><Data ss:Type="String">% Ausentismo-Absenteismo</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s187"')                
aadd(_aXML,'     ss:Formula="'+cFSomAusAb+cFDivAusAb+'"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="5" ss:StyleID="s188" ss:Formula="=R[-7]C-R[-1]C"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s189"><Data ss:Type="String">% Horas extras</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s190"')  
aadd(_aXML,'     ss:Formula="'+cFHrExt+cFDivHrExt+'"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="6" ss:StyleID="s62"/>')
aadd(_aXML,'    <Cell ss:StyleID="s191"><Data ss:Type="String">Ultimo dia do mes</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s192" ss:Formula="=R[-8]C[-3]-R[-3]C"><Data ss:Type="Number">397</Data></Cell>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s193"><Data ss:Type="String">%Ferias</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s194"')   
aadd(_aXML,'     ss:Formula="'+cFFerias+cFDivFer+'"><Data')
aadd(_aXML,'      ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="9" ss:StyleID="s195"/>')
aadd(_aXML,'    <Cell ss:StyleID="s195"/>')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s196"/>')
aadd(_aXML,'    <Cell ss:StyleID="s197"/>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="15.75">')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s166"><Data ss:Type="String">Total Fabrica</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s167"><Data ss:Type="DateTime">'+Substr(DTOS(MV_PAR01),1,4)+'-'+Substr(DTOS(MV_PAR01),5,2)+'-'+Substr(DTOS(MV_PAR01),7,2)+'T00:00:00.000</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s198"><Data ss:Type="String">Efectivos</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s199"><Data ss:Type="Number">'+alltrim(str(nEfet+nEstag))+'</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75">')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s174"><Data ss:Type="String">Contratados</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s200"><Data ss:Type="Number">'+alltrim(str(nContrat))+'</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:Index="12" ss:StyleID="s201"><Data ss:Type="String">Total empleados</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s202" ss:Formula="=SUM(R[-2]C:R[-1]C)"><Data ss:Type="Number">425</Data></Cell>')
aadd(_aXML,'   </Row>')
aadd(_aXML,'   <Row ss:Height="12.75" ss:Span="1"/>')
aadd(_aXML,'   <Row ss:Index="59" ss:Height="12.75" ss:Hidden="1"/>')

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AbrirQuery(cAliasQ)

Local cQuery   

cQuery := " SELECT RA_FILIAL, RA_MAT, RA_CC, RA_NOME, RA_DEMISSA, RA_TPCONTR, RA_ADMISSA, RA_TNOTRAB, RA_SEQTURN, RA_AFASFGT, RA_SITFOLH FROM SRA020 SRA "
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += "	AND NOT SRA.RA_CATFUNC in ('A','P') "  //tab 28 - tipo de remuneração / A - AUTONOMO P - PRO LABORE
//cQuery += "	AND NOT SRA.RA_AFASFGT = '5' "         //tab 30 - codigo afastamento fgts / 5 - TRANSF. P/ OUTRO ESTABELEC. DA MESMA EMPRESA
cQuery += "	AND RA_ADMISSA <= '" + DTOS(MV_PAR02) + "' "
cQuery += "	AND (RA_DEMISSA = '' OR RA_DEMISSA >= '" + DTOS(MV_PAR01) + "') "
cQuery += "	AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "	AND RA__CELULA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND RA_TNOTRAB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " 
//cQuery += " AND RA_MAT = '000599' "
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME"

//* Verifica se a Query Existe, se existir fecha
If Select(cAliasQ) > 0
	dbSelectArea(cAliasQ)
	dbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
//Aviso("OK",cQuery,{"OK"},3)
TCQUERY cQuery NEW ALIAS &cAliasQ

dbSelectArea(cAliasQ)

Return
Static FuncTion HrUtil(dDtEntr,dDtSai)
Local nDia      := 0
Local _nSem     := 1
Local nDat      := 0
Local nUteis    := 0
Local nC
Local cDt
Local ntothoras := 0
Local _cAno     := Strzero(Year(dDtSai),4)
Local _cMes     := Strzero(Month(dDtSai),2)
Local _Turno	:= QRY1->RA_TNOTRAB //Posicione("SPF",1,"02" + QRY1->RA_MAT + DTOS(MV_PAR01),"PF_TURNOPA") //_dTurno,"PF_TURNOPA")

If STOD(QRY1->RA_ADMISSA) > dDtEntr //admissão dentro do período selecionado
	dDtEntr := STOD(QRY1->RA_ADMISSA)
EndIf

If !eMPTY(QRY1->RA_DEMISSA) .and. STOD(QRY1->RA_DEMISSA) < dDtSai //demissão dentro do período selecionado
	dDtSai := STOD(QRY1->RA_DEMISSA)
EndIf

nDat := dDtSai - dDtEntr + 1

If nDat == 0
	nDat := 1
EndIf

If Posicione("RCG",1, xFilial("RCG") + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
	_Turno := QRY1->RA_TNOTRAB
Else
	_Turno := "   "
EndIf

For nC  := 1 To nDat
	cDt := RetTipoDia(dDtEntr + (nC-1))
	
	DbSelectArea("RCG")
	DbSetOrder(2)
	DbSeek(xFilial("RCG") + SPACE(LEN(RCG_PROCES)) + SPACE(LEN(RCG_PER)) + SPACE(LEN(RCG_SEMANA)) + SPACE(LEN(RCG_ROTEIR)) + _Turno + DTOS(dDtEntr + (nC-1)),.f.)
	
	If RCG->RCG_TIPDIA == "1"
		nuteis++
	EndIf
	
Next nC

TMPHR->(DBGOTOP())
WHILE !TMPHR->(eof()) .AND. TMPHR->PJ_TURNO <> QRY1->RA_TNOTRAB
	TMPHR->(DBSKIP())
ENDDO
ntothoras := TMPHR->HORAS
FOR I:=1 TO NUTEIS-1
	NTOTHORAS := SOMAHORAS(NTOTHORAS,TMPHR->HORAS)
NEXT
If nUteis < 1
	nTotHoras := 0
EndIf
Return(nTotHoras)

Static FuncTion xAfasta(dDtEntr,dDtSai)
Local nDia      := 0
Local _nSem     := 1
Local nDat      := 0
Local nC
Local cDt
Local nafa      := 0
Local ntothoras := 0
Local _cAno     := Strzero(Year(dDtSai),4)
Local _cMes     := Strzero(Month(dDtSai),2)
Local _Turno	:= QRY1->RA_TNOTRAB
Local mSQL 	    := ""
DEFAULT dDtEntr := MV_PAR01
DEFAULT dDtSai  := MV_PAR02

nDat := dDtSai - dDtEntr + 1

If Posicione("RCG",1, xFilial("RCG") + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
	_Turno := QRY1->RA_TNOTRAB
Else
	_Turno := "   "
EndIf

For nC := 1 To nDat
	cDt := RetTipoDia(dDtEntr + (nC-1))
	
	DbSelectArea("RCG")
	DbSetOrder(2)
	DbSeek(xFilial("RCG") + SPACE(LEN(RCG_PROCES)) + SPACE(LEN(RCG_PER)) + SPACE(LEN(RCG_SEMANA)) + SPACE(LEN(RCG_ROTEIR)) + _Turno + DTOS(dDtEntr + (nC-1)),.f.)
	
	If RCG->RCG_TIPDIA == "1"
		nAfa++
	EndIf
	
Next nC

RCG->( dbCloseArea() )

Return(nAfa)

Static Function ConvHr(nUteis,nHoras)
Local NTOTHORAS := 0
TMPHR->(DBGOTOP())
WHILE !TMPHR->(eof()) .AND. TMPHR->PJ_TURNO <> QRY1->RA_TNOTRAB
	TMPHR->(DBsKIP())
ENDDO
ntothoras := TMPHR->HORAS
FOR I:=1 TO NUTEIS-1
	NTOTHORAS := SOMAHORAS(NTOTHORAS,TMPHR->HORAS)
NEXT
If nUteis < 1
	nTotHoras := 0
EndIf
Return NTOTHORAS

Static Function getHe(cMat)
Local cExtra := "120,121,122,123,127,128,129,130,140,141,142,143" //HORAS EXTRAS
Local cSQL   := ""
Local nQtd   := 0

IF Select("TMPHE") <> 0
	DbSelectArea("TMPHE")
	DbCloseArea()
Endif
/*cSQL := "SELECT PC_MAT AS MATRICULA,  PC_DATA AS DATA, PC_PD AS VERBA, PC_ABONO AS ABONO, PC_QUANTC AS HORAS FROM SPC020 AS PC3 "
cSQL += "WHERE PC3.D_E_L_E_T_ = ' ' "
cSQL += "AND PC3.PC_MAT = '"+cMat+"' "
cSQL += "AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += "AND PC3.PC_PD IN ("+cExtra+") "
cSQL += "AND PC3.PC_ABONO NOT IN ('027') "
cSQL += "AND PC3.PC_FILIAL = '" + QRY1->RA_FILIAL + "' "
cSQL += "UNION ALL "
cSQL += "SELECT PH_MAT AS MATRICULA,  PH_DATA AS DATA, PH_PD AS VERBA, PH_ABONO AS ABONO, PH_QUANTC AS HORAS FROM SPH020 AS PH3 "
cSQL += "WHERE PH3.D_E_L_E_T_ = ' ' "
cSQL += "AND PH3.PH_FILIAL = '" + QRY1->RA_FILIAL + "' "
cSQL += "AND PH3.PH_MAT = '"+cMat+"' "
cSQL += "AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += "AND PH3.PH_PD IN ("+cExtra+") "
cSQL += "AND PH3.PH_ABONO NOT IN ('027') " */

cSQL := " SELECT RD_HORAS AS HORAS FROM SRD020 WHERE D_E_L_E_T_ <> '*' AND RD_FILIAL = '" + QRY1->RA_FILIAL + "' " 
cSQL += " AND RD_DATARQ = '"+SubStr(DtoS(MV_PAR01),1,6)+"' AND RD_PD IN ('080','083') AND RD_MAT = '"+cMat+"' "

TcQuery cSQL NEW Alias "TMPHE"
DbSelectArea("TMPHE")
While !Eof()
	nQtd := SomaHoras(nQtd,TMPHE->HORAS)
	DbSkip()
EndDo
DbCloseArea("TMPHE")
Return nQtd

Static Function getFaltas(cMat,lAbonada)      //.T. HORAS FALTAS/ATRASOS ABONADO , .F. HORAS FALTAS/ATRASOS DESCONTADO
Local cFaltas    := "009,014,019,408,463" //EVENTOS DE DESCONTO
Local cAbona     := "001,002,003,004,005,006,007,008,009,010,011,012,013,017,018,020,021,022,023,024,025,026,028" //HORAS FALTAS/ATRASOS ABONADO
Local cNAbona    := "001,002,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,020,021,022,023,024,025,026,028" //HORAS FALTAS/ATRASOS DESCONTADO
Local cSQL       := ""
Local nQtd       := 0
DEFAULT lAbonada := .F.

IF Select("TMPFL") <> 0
	DbSelectArea("TMPFL")
	DbCloseArea()
Endif
cSQL := "SELECT PC_MAT AS MATRICULA,  PC_DATA AS DATA, PC_PD AS VERBA, PC_ABONO AS ABONO, PC_QUANTC AS HORAS FROM SPC020 AS PC3 "
cSQL += "WHERE PC3.D_E_L_E_T_ = ' ' "
cSQL += "AND PC3.PC_MAT = '"+cMat+"' "
cSQL += "AND PC3.PC_FILIAL = '" + QRY1->RA_FILIAL + "' "
//	cSQL += "AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += + Iif(Empty(QRY1->RA_DEMISSA) .OR. STOD(QRY1->RA_DEMISSA) >= MV_PAR02," AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "," AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+QRY1->RA_DEMISSA+"' ")
cSQL += " AND PC3.PC_PD IN ("+cFaltas+")"
cSQL += + Iif(lAbonada, " AND PC3.PC_ABONO IN ("+cAbona+") "," AND PC3.PC_ABONO NOT IN ("+cNAbona+") ")
cSQL += "UNION ALL "
cSQL += "SELECT PH_MAT AS MATRICULA,  PH_DATA AS DATA, PH_PD AS VERBA, PH_ABONO AS ABONO, PH_QUANTC AS HORAS FROM SPH020 AS PH3 " 
cSQL += "WHERE PH3.D_E_L_E_T_ = ' ' "
cSQL += "AND PH3.PH_FILIAL = '" + xFilial() + "' "
cSQL += "AND PH3.PH_MAT = '"+cMat+"' "
cSQL += "AND PH3.PH_FILIAL = '" + QRY1->RA_FILIAL + "' "
//	cSQL += "AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += + Iif(Empty(QRY1->RA_DEMISSA) .OR. STOD(QRY1->RA_DEMISSA) >= MV_PAR02,"AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' ","AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+QRY1->RA_DEMISSA+"' ")
cSQL += "AND PH3.PH_PD IN ("+cFaltas+")"
cSQL += + Iif(lAbonada, " AND PH3.PH_ABONO IN ("+cAbona+") "," AND PH3.PH_ABONO NOT IN ("+cNAbona+") ")

TcQuery cSQL NEW Alias "TMPFL"
DbSelectArea("TMPFL")
While !Eof()
	nQtd := SomaHoras(nQtd,TMPFL->HORAS)
	DbSkip()
EndDo
DbCloseArea("TMPFL")
Return nQtd

Static Function getAbono(cMat,cAbono)  
	Local cFaltas    := "009,014,019,408,463" //EVENTOS DE DESCONTO
	Local cSQL       := ""
	Local nQtd       := 0
	
	cSQL := "SELECT PC_MAT AS MATRICULA,  PC_DATA AS DATA, PC_PD AS VERBA, PC_ABONO AS ABONO, PC_QUANTC AS HORAS FROM SPC020 AS PC3 "
	cSQL += "WHERE PC3.D_E_L_E_T_ = ' ' "
	cSQL += "AND PC3.PC_MAT = '"+cMat+"' "
	cSQL += "AND PC3.PC_FILIAL = '"+QRY1->RA_FILIAL+"' "
	cSQL += "AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
	cSQL += "AND PC3.PC_PD IN ("+cFaltas+")"
	cSQL += "AND PC3.PC_ABONO IN ("+cAbono+") "
	cSQL += "UNION ALL "
	cSQL += "SELECT PH_MAT AS MATRICULA,  PH_DATA AS DATA, PH_PD AS VERBA, PH_ABONO AS ABONO, PH_QUANTC AS HORAS FROM SPH020 AS PH3 "
	cSQL += "WHERE PH3.D_E_L_E_T_ = ' ' "
	cSQL += "AND PH3.PH_MAT = '"+cMat+"' "
	cSQL += "AND PH3.PH_FILIAL = '"+QRY1->RA_FILIAL+"' "
	cSQL += "AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
	cSQL += "AND PH3.PH_PD IN ("+cFaltas+")"
	cSQL += "AND PH3.PH_ABONO IN ("+cAbono+") "
	
	TcQuery cSQL NEW Alias "TMPAB"
	DbSelectArea("TMPAB")
	While !Eof()
		nQtd := SomaHoras(nQtd,TMPAB->HORAS)
		DbSkip()
	EndDo
	DbCloseArea("TMPAB")
Return nQtd







Static Function getTreina(cMat)
Local cTreina  := "014" //Abono por Treinamento
Local cSQL     := ""
Local nQtd     := 0

IF Select("TMPTR") <> 0
	DbSelectArea("TMPTR")
	DbCloseArea()
Endif

cSQL := "SELECT PC_MAT AS MATRICULA,  PC_DATA AS DATA, PC_PD AS VERBA, PC_ABONO AS ABONO, PC_QUANTC AS HORAS FROM SPC020 AS PC3 "
cSQL += "WHERE PC3.D_E_L_E_T_ = ' ' "
cSQL += "AND PC3.PC_MAT = '"+cMat+"' "
cSQL += "AND PC3.PC_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += "AND PC3.PC_ABONO IN ("+cTreina+") "
cSQL += "AND PC3.PC_FILIAL = '" + QRY1->RA_FILIAL + "' "
cSQL += "UNION ALL "
cSQL += "SELECT PH_MAT AS MATRICULA,  PH_DATA AS DATA, PH_PD AS VERBA, PH_ABONO AS ABONO, PH_QUANTC AS HORAS FROM SPH020 AS PH3 "
cSQL += "WHERE PH3.D_E_L_E_T_ = ' ' "
cSQL += "AND PH3.PH_FILIAL = '" + QRY1->RA_FILIAL + "' "
cSQL += "AND PH3.PH_MAT = '"+cMat+"' "
cSQL += "AND PH3.PH_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cSQL += "AND PH3.PH_ABONO IN ("+cTreina+")"

TcQuery cSQL NEW Alias "TMPTR"
DbSelectArea("TMPTR")
While !Eof()
	nQtd := SomaHoras(nQtd,TMPTR->HORAS)
	DbSkip()
EndDo
DbCloseArea("TMPTR")
Return nQtd

Static Function getBanco(cMat,cSinal)  //Calcula o saldo do Banco de Horas
Local cSQL      := ""
Local nQtd      := 0
nSaldo:= nSaldoAnt := nValor := nPosSaldo := nNegSaldo := 0
dDataAux  := CTOD("  /  /  ")

_cSQL := " Select PI_FILIAL,PI_MAT,PI_DATA,PI_PD,PI_STATUS,PI_QUANT,P9_TIPOCOD From " + RetSqlName("SPI") + " _PI "
_cSQL += " Inner Join " + RetSqlName("SP9") + " _P9 on P9_FILIAL = '" + xFilial("SP9") + "' And P9_CODIGO = PI_PD And _P9.D_E_L_E_T_ = ' ' "
_cSQL += " Where PI_MAT = '" + cMat + "' And PI_DATA <= '" + DTOS(MV_PAR02) + "' And _PI.D_E_L_E_T_ = ' ' and PI_FILIAL = '" + QRY1->RA_FILIAL + "' "
_cSQL += " Order By PI_FILIAL,PI_MAT,PI_DATA,PI_PD "

_cSQL := ChangeQuery(_cSQL)

If Select("xPI") > 0
	DbSelectArea("xPI")
	DbCloseArea()
EndIf

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cSQL),"xPI", .T., .T.)

DbSelectArea("xPI")
DbGoTop()

While !Eof()
	If xPI->P9_TIPOCOD $  "1/3"
		
		nValor 	  := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)
		dDataAux  := IIF(Empty(nValor), dDataAux, STOD(xPI->PI_DATA)) //Para valor nao nulo considera a Data para Referencia do Saldo
		nPosSaldo := __TimeSum(nPosSaldo,nValor)
		nSaldoAnt := __TimeSum(nSaldoAnt,nValor)
		
	Else
		
		nValor 	  := IIF(xPI->PI_STATUS == "B",0,xPI->PI_QUANT)
		dDataAux  := IIF(Empty(nValor), dDataAux, STOD(xPI->PI_DATA)) //Para valor nao nulo considera a Data para Referencia do Saldo
		nNegSaldo := __TimeSub(nNegSaldo,nValor)
		nSaldoAnt := __TimeSub(nSaldoAnt,nValor)
		
	Endif
	If cSinal == "="
		nSaldo := nSaldoAnt
	ElseIf cSinal == "+" 
		nSaldo := nPosSaldo
	ElseIf cSinal == "-"
		nSaldo := nNegSaldo
	EndIf	
	
	DbSelectArea("xPI")
	DbSkip()
	
EndDo
Return nSaldo

Static Function getBancoHoras(cMat)  
	Local cBanco:= "999" //EVENTOS DE BANCO DE HORAS  
	Local nQtd	:= 0
	
	cSQL := "SELECT PI_QUANT AS HORAS FROM SPI020 AS SPI "
	cSQL += "WHERE SPI.D_E_L_E_T_ <> '*' "
	cSQL += "AND SPI.PI_MAT = '"+cMat+"' "
	cSQL += "AND SPI.PI_PD IN ("+cBanco+")"
	cSQL += "AND SPI.PI_FILIAL = '"+QRY1->RA_FILIAL+"' "
//	cSQL += "AND SPI.PI_STATUS <> 'B' "
	cSQL += "AND SPI.PI_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
	
	TcQuery cSQL NEW Alias "TMPSPI"
	DbSelectArea("TMPSPI")
	While !Eof()
		nQtd := SomaHoras(nQtd,TMPSPI->HORAS)
		DbSkip()
	EndDo
	DbCloseArea("TMPSPI")
Return nQtd

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg() //CRIACAO DA PERGUNTA
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
AAdd(aRegs,{cPerg,"01","Data De?          ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Data Ate?         ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Centro Custo De?  ","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
AAdd(aRegs,{cPerg,"04","Centro Custo Ate? ","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
AAdd(aRegs,{cPerg,"05","Celula De?        ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"06","Celula Ate?       ","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"07","Turno De?         ","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})
AAdd(aRegs,{cPerg,"08","Turno De?         ","","","mv_ch7","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})

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
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _Cabecalho(_aXml,_nRegs) 

DEFAULT _aXML := {}  

aadd(_aXML,'<?xml version="1.0"?>')
aadd(_aXML,'<?mso-application progid="Excel.Sheet"?>')
aadd(_aXML,'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
aadd(_aXML,' xmlns:o="urn:schemas-microsoft-com:office:office"')
aadd(_aXML,' xmlns:x="urn:schemas-microsoft-com:office:excel"')
aadd(_aXML,' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
aadd(_aXML,' xmlns:html="http://www.w3.org/TR/REC-html40">')
aadd(_aXML,' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
aadd(_aXML,'  <Author>julia.schreurs</Author>')
aadd(_aXML,'  <LastAuthor>Vinicius</LastAuthor>')
aadd(_aXML,'  <LastPrinted>2014-07-04T11:57:11Z</LastPrinted>')
aadd(_aXML,'  <Created>2011-09-13T20:50:19Z</Created>')
aadd(_aXML,'  <LastSaved>2014-10-28T20:10:20Z</LastSaved>')
aadd(_aXML,'  <Version>12.00</Version>')
aadd(_aXML,' </DocumentProperties>')
aadd(_aXML,' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">')
aadd(_aXML,'  <WindowHeight>5025</WindowHeight>')
aadd(_aXML,'  <WindowWidth>15480</WindowWidth>')
aadd(_aXML,'  <WindowTopX>-15</WindowTopX>')
aadd(_aXML,'  <WindowTopY>5100</WindowTopY>')
aadd(_aXML,'  <TabRatio>557</TabRatio>')
aadd(_aXML,'  <ActiveSheet>1</ActiveSheet>')
aadd(_aXML,'  <ProtectStructure>False</ProtectStructure>')
aadd(_aXML,'  <ProtectWindows>False</ProtectWindows>')
aadd(_aXML,' </ExcelWorkbook>')
aadd(_aXML,' <Styles>')
aadd(_aXML,'  <Style ss:ID="Default" ss:Name="Normal">')
aadd(_aXML,'   <Alignment ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat/>')
aadd(_aXML,'   <Protection/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s20" ss:Name="Porcentagem">')
aadd(_aXML,'   <NumberFormat ss:Format="0%"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s16" ss:Name="Separador de milhares">')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="m35090432" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="m35090452" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s62">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s63">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Italic="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s64">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s65">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s67" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s68">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s69">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s70">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s72" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s73">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s74" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.0_);_(* \(#,##0.0\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s75" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s76">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s77">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s78">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"')
aadd(_aXML,'    ss:Italic="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="mmm/yy"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s79">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"')
aadd(_aXML,'    ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="mmm/yy"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s80">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s81">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')   

aadd(_aXML,'  <Style ss:ID="s755">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'  </Style>')

aadd(_aXML,'  <Style ss:ID="s82">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s83">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s84">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s85" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s86">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s87" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s88">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s90">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s93">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s94">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s95" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s96" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s97">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s98">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s99">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s100" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s101" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s102" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s103" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s104" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s105">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s106">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s107" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s108" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s109" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s110" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s111" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s112">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s113">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s114">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s115">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s116">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s117" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s118">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s119">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s120">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s121">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s122">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s123" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s124" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s125" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s126" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s127" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s128" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s129" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s130" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s131" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s132">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s134">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s135">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s136">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s137">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s138" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s139">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s140">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s141" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s142">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s143">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s144" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s145" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s146" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s147" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s148" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s149">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0000"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s150" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s151" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s152">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s153">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s154" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s155" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s165" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s166">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"')
aadd(_aXML,'    ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s167">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"')
aadd(_aXML,'    ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="mmm/yy"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s168" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s169" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s170">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s171" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s172" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s173">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s174">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s175">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s176">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s177" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s178" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s179">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s180" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s181" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s182" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s184" ss:Parent="s20">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#DDD9C3" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s185" ss:Parent="s20">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s186">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s187" ss:Parent="s20">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="Percent"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s188" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s189">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s190" ss:Parent="s20">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="Percent"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s191" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s192">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s193">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s194" ss:Parent="s20">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Italic="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="Percent"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s195">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s196">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s197">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s198">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s199">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s200">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFCC" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s201">')
aadd(_aXML,'   <Alignment ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s202">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="0"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s203">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s204">')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s206">')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s208">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s209">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s210">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s211">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>')
aadd(_aXML,'   <Interior ss:Color="#376091" ss:Pattern="Solid"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s213">')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s215">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s216">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s217">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s218" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"')
aadd(_aXML,'    ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s219">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s220" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s221" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s222">')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s223" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s224" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s225">')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s226" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_(* #,##0.000_);_(* \(#,##0.000\);_(* &quot;-&quot;??_);_(@_)"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s227" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss"/>')
aadd(_aXML,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s228">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s229" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000" ss:Bold="1"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s230" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000" ss:Bold="1"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s231">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s232" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s233" ss:Parent="s16">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s234">')
aadd(_aXML,'   <Borders>')
aadd(_aXML,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
aadd(_aXML,'   </Borders>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#003366"/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s235">')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#333399"/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s236">')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Interior/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s238">')
aadd(_aXML,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s239">')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s240">')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,'  <Style ss:ID="s241">')
aadd(_aXML,'   <Borders/>')
aadd(_aXML,'   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#333399"/>')
aadd(_aXML,'  </Style>')
aadd(_aXML,' </Styles>')

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _Rodape(_aXml)

DEFAULT _aXML := {}

aadd(_aXML,'</Table>')
aadd(_aXML,'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
aadd(_aXML,'   <PageSetup>')
aadd(_aXML,'    <Layout x:Orientation="Landscape"/>')
aadd(_aXML,'    <Header x:Margin="0.31496062992125984"/>')
aadd(_aXML,'    <Footer x:Margin="0.31496062992125984"/>')
aadd(_aXML,'    <PageMargins x:Bottom="0.78740157480314965" x:Left="0.45"')
aadd(_aXML,'     x:Right="0.15748031496062992" x:Top="0.78740157480314965"/>')
aadd(_aXML,'   </PageSetup>')
aadd(_aXML,'   <ZeroHeight/>')
aadd(_aXML,'   <Print>')
aadd(_aXML,'    <ValidPrinterInfo/>')
aadd(_aXML,'    <PaperSizeIndex>9</PaperSizeIndex>')
aadd(_aXML,'    <Scale>60</Scale>')
aadd(_aXML,'    <HorizontalResolution>600</HorizontalResolution>')
aadd(_aXML,'    <VerticalResolution>600</VerticalResolution>')
aadd(_aXML,'   </Print>')
aadd(_aXML,'   <TabColorIndex>63</TabColorIndex>')
aadd(_aXML,'   <Zoom>96</Zoom>')
aadd(_aXML,'   <Selected/>')
aadd(_aXML,'   <DoNotDisplayGridlines/>')
aadd(_aXML,'   <FreezePanes/>')
aadd(_aXML,'   <FrozenNoSplit/>')
aadd(_aXML,'   <SplitHorizontal>6</SplitHorizontal>')
aadd(_aXML,'   <TopRowBottomPane>6</TopRowBottomPane>')
aadd(_aXML,'   <SplitVertical>3</SplitVertical>')
aadd(_aXML,'   <LeftColumnRightPane>3</LeftColumnRightPane>')
aadd(_aXML,'   <ActivePane>0</ActivePane>')
aadd(_aXML,'   <Panes>')
aadd(_aXML,'    <Pane>')
aadd(_aXML,'     <Number>3</Number>')
aadd(_aXML,'    </Pane>')
aadd(_aXML,'    <Pane>')
aadd(_aXML,'     <Number>1</Number>')
aadd(_aXML,'    </Pane>')
aadd(_aXML,'    <Pane>')
aadd(_aXML,'     <Number>2</Number>')
aadd(_aXML,'    </Pane>')
aadd(_aXML,'    <Pane>')
aadd(_aXML,'     <Number>0</Number>')
aadd(_aXML,'     <ActiveRow>8</ActiveRow>')
aadd(_aXML,'     <ActiveCol>5</ActiveCol>')
aadd(_aXML,'    </Pane>')
aadd(_aXML,'   </Panes>')
aadd(_aXML,'   <ProtectObjects>False</ProtectObjects>')
aadd(_aXML,'   <ProtectScenarios>False</ProtectScenarios>')
aadd(_aXML,'  </WorksheetOptions>')
aadd(_aXML,' </Worksheet>') 
AbaMotivos(@_aXml)

Return 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHIMPBLC³ Autor ³ DeltaDecisao         ³ Data ³ 06/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ 															   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AbaMotivos(_aXml)

Local nInss := 0

DEFAULT _aXML := {}    

aadd(_aXML,'<Worksheet ss:Name="Motivos">')
aadd(_aXML,'  <Table ss:ExpandedColumnCount="10" ss:ExpandedRowCount="'+Alltrim(str(Len(aTotCC)+100))+'" x:FullColumns="1"')
aadd(_aXML,'   x:FullRows="1" ss:DefaultColumnWidth="167.25">')
aadd(_aXML,'   <Column ss:StyleID="s203" ss:Width="60.75"/>')
aadd(_aXML,'   <Column ss:AutoFitWidth="0" ss:Width="1058.25"/>')
aadd(_aXML,'   <Column ss:StyleID="s204" ss:Width="59.25"/>')
aadd(_aXML,'   <Column ss:AutoFitWidth="0" ss:Width="327.75"/>')

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="13.5" ss:StyleID="s206">')
aadd(_aXML,'    <Cell ss:StyleID="s208"><Data ss:Type="String">COD.</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s209"><Data ss:Type="String">Faltas/Atrasos/Atestados medicos/saida antecipada</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s210"/>')
aadd(_aXML,'   </Row>')

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="15.75" ss:StyleID="s213">')
aadd(_aXML,'    <Cell ss:StyleID="s215"><Data ss:Type="String">TOTAL</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s216"><Data ss:Type="String">HORAS</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s217" ss:Formula="=R[7]C+R[6]C"><Data ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'   </Row>')

If SubStr(DTOS(MV_PAR01),5,2) == "12" 
	cMesFal := "01"
	cAnoFal := StrZero(Val(SubStr(DTOS(MV_PAR01),1,4)) + 1,4)
Else
	cMesFal := StrZero(Val(SubStr(DTOS(MV_PAR01),5,2)) + 1,2)
	cAnoFal := SubStr(DTOS(MV_PAR01),1,4)
EndIf	

cSQL := " SELECT RD_PD, 'HORAS - '+RV_DESC AS RV_DESC, SUM(RD_HORAS) AS RD_HORAS " + CRLF
cSQL += " FROM " + RetSqlName("SRD") + " SRD (NOLOCK)  " + CRLF 
cSQL += " INNER JOIN " + RetSqlName("SRV") + " SRV (NOLOCK) ON SRV.D_E_L_E_T_ <> '*' AND RV_COD = RD_PD  " + CRLF
cSQL += " WHERE SRD.D_E_L_E_T_ <> '*' AND RD_FILIAL = '" + xFilial("SDR") + "'  " + CRLF
cSQL += " AND RD_PD IN ('420','426','421','431','036')  " + CRLF
cSQL += " AND RD_DATPGT BETWEEN '" + cAnoFal+cMesFal+"01" + "' AND '" + cAnoFal+cMesFal+"05" + "'  " + CRLF
cSQL += " GROUP BY RD_PD, RV_DESC  " + CRLF
cSQL += " ORDER BY RD_PD  " + CRLF   

TcQuery cSQL NEW Alias "HRNJ"
DbSelectArea("HRNJ")
While HRNJ->(!Eof()) 

	aadd(_aXML,'   <Row>')
	aadd(_aXML,'    <Cell ss:StyleID="s219"><Data ss:Type="Number">'+alltrim(HRNJ->RD_PD)+'</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s220"><Data ss:Type="String">'+alltrim(HRNJ->RV_DESC)+'</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s233"><Data ss:Type="Number">'+alltrim(str(HRNJ->RD_HORAS))+'</Data></Cell>')
	aadd(_aXML,'   </Row>')  

	HRNJ->(DbSkip())
EndDo
DbCloseArea("HRNJ") 

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:StyleID="s228"><Data ss:Type="String">SUB TOTAL</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s229"><Data ss:Type="String">FOLHA DE PAGAMENTO</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s230" ss:Formula="=SUM(R[-5]C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'   </Row>')   

cSQL := " SELECT SUM(PK_HRSABO) HORAABO FROM SPK020 WHERE D_E_L_E_T_ <> '*' AND PK_FILIAL = '"+xFilial("SPK")+"'  " + CRLF 
cSQL += " AND PK_CODABO IN ('001','002','005','013','017','025') AND PK_DATA >= '" + DTOS(MV_PAR01) + "' AND  " + CRLF 
cSQL += " PK_DATA <= '" + DTOS(MV_PAR02) + "'  " + CRLF

TcQuery cSQL NEW Alias "HRABO"
DbSelectArea("HRABO")
If HRABO->(!Eof())
	nHrAtDiv := HRABO->HORAABO
EndIf
DbCloseArea("HRABO") 

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="13.5">')
aadd(_aXML,'    <Cell ss:StyleID="s231"><Data ss:Type="String">SPK</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s232"><Data ss:Type="String">Horas justificadas com atestados diversos.</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s233"><Data ss:Type="Number">'+alltrim(str(nHrAtDiv))+'</Data></Cell>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
aadd(_aXML,'   </Row>')

cSQL := " SELECT DISTINCT(TMR_DOENCA)  " + CRLF
cSQL += " FROM " + RetSqlName("SR8") + " SR8 (NOLOCK)  " + CRLF 
cSQL += " INNER JOIN " + RetSqlName("TMR") + " TMR (NOLOCK) ON TMR.D_E_L_E_T_ <> '*' AND TMR_CID = R8_CID  " + CRLF
cSQL += " WHERE SR8.D_E_L_E_T_ <> '*' AND R8_FILIAL = '" + xFilial("SR8") + "'  " + CRLF
cSQL += " AND (R8_DATAINI >= '" + DTOS(MV_PAR01) + "' AND R8_DATAINI <= '" + DTOS(MV_PAR02) + "'  " + CRLF 
cSQL += " AND R8_DATAFIM >= '" + DTOS(MV_PAR01) + "' AND R8_DATAFIM <= '" + DTOS(MV_PAR02) + "')  " + CRLF

TcQuery cSQL NEW Alias "HRJAT"
DbSelectArea("HRJAT")
While HRJAT->(!Eof())

	aadd(_aXML,'   <Row>')
	aadd(_aXML,'    <Cell ss:Index="2" ss:StyleID="s234"><Data ss:Type="String">'+alltrim(HRJAT->TMR_DOENCA)+'</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s235"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'   </Row>')
	
	HRJAT->(DbSkip())
EndDo
DbCloseArea("HRJAT") 	

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="13.5" ss:StyleID="s206">') 
aadd(_aXML,'    <Cell ss:StyleID="s238"/>')
aadd(_aXML,'    <Cell ss:StyleID="s211"><Data ss:Type="String">Afastamento/INSS</Data></Cell>')
aadd(_aXML,'   </Row>')

aadd(_aXML,'   <Row ss:AutoFitHeight="0" ss:Height="15.75" ss:StyleID="s213">')  
aadd(_aXML,'    <Cell ss:StyleID="s238"/>')
aadd(_aXML,'    <Cell ss:StyleID="s218"><Data ss:Type="String">0</Data></Cell>')
aadd(_aXML,'   </Row>') 

cSQL := " SELECT COUNT(R8_MAT) PESSOAS, TMR_DOENCA  " + CRLF
cSQL += " FROM " + RetSqlName("SR8") + " SR8 (NOLOCK)  " + CRLF 
cSQL += " INNER JOIN " + RetSqlName("TMR") + " TMR (NOLOCK) ON TMR.D_E_L_E_T_ <> '*' AND TMR_CID = R8_CID  " + CRLF
cSQL += " WHERE SR8.D_E_L_E_T_ <> '*' AND R8_FILIAL = '" + xFilial("SR8") + "'  " + CRLF
cSQL += " AND R8_MAT+R8_DATAINI+R8_TIPO IN (  " + CRLF 
For nx:= 1 To Len(aInss)
	If nx == Len(aInss)
		cSQL += "'" + aInss[nx][1] + "')" + CRLF 
	Else
		cSQL += "'" + aInss[nx][1] + "'," + CRLF
	EndIf 
Next nx  
cSQL += " GROUP BY TMR_DOENCA  " + CRLF

TcQuery cSQL NEW Alias "AFINSS"
DbSelectArea("AFINSS")
While AFINSS->(!Eof())

	aadd(_aXML,'   <Row ss:StyleID="s239">')
	aadd(_aXML,'    <Cell ss:StyleID="s238"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s226"><Data ss:Type="String">'+alltrim(str(AFINSS->PESSOAS))+' '+AFINSS->TMR_DOENCA+'</Data></Cell>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'    <Cell ss:StyleID="s213"/>')
	aadd(_aXML,'   </Row>')
	
	nInss:= nInss+AFINSS->PESSOAS

	AFINSS->(DbSkip())
EndDo
DbCloseArea("AFINSS")

aadd(_aXML,'   <Row ss:StyleID="s239">')
aadd(_aXML,'    <Cell ss:StyleID="s238"/>')
aadd(_aXML,'    <Cell ss:StyleID="s222"><Data ss:Type="String">'+alltrim(str(nInss))+' funcionarios afastados pelo INSS</Data></Cell>') 
aadd(_aXML,'   </Row>')

aadd(_aXML,'  </Table>')
aadd(_aXML,'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
aadd(_aXML,'   <PageSetup>')
aadd(_aXML,'    <Header x:Margin="0.31496062000000002"/>')
aadd(_aXML,'    <Footer x:Margin="0.31496062000000002"/>')
aadd(_aXML,'    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"')
aadd(_aXML,'     x:Right="0.511811024" x:Top="0.78740157499999996"/>')
aadd(_aXML,'   </PageSetup>')
aadd(_aXML,'   <Print>')
aadd(_aXML,'    <ValidPrinterInfo/>')
aadd(_aXML,'    <PaperSizeIndex>9</PaperSizeIndex>')
aadd(_aXML,'    <HorizontalResolution>600</HorizontalResolution>')
aadd(_aXML,'    <VerticalResolution>600</VerticalResolution>')
aadd(_aXML,'   </Print>')
aadd(_aXML,'   <Zoom>80</Zoom>')
aadd(_aXML,'   <Selected/>')
aadd(_aXML,'   <DoNotDisplayGridlines/>')
aadd(_aXML,'   <TopRowVisible>6</TopRowVisible>')
aadd(_aXML,'   <Panes>')
aadd(_aXML,'    <Pane>')
aadd(_aXML,'     <Number>3</Number>')
aadd(_aXML,'     <ActiveRow>23</ActiveRow>')
aadd(_aXML,'     <ActiveCol>1</ActiveCol>')
aadd(_aXML,'    </Pane>')
aadd(_aXML,'   </Panes>')
aadd(_aXML,'   <ProtectObjects>False</ProtectObjects>')
aadd(_aXML,'   <ProtectScenarios>False</ProtectScenarios>')
aadd(_aXML,'  </WorksheetOptions>')
aadd(_aXML,' </Worksheet>')

Return
 