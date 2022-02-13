/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: xVRABGH                                                                                                                                                             |
|Autor: Daniel CArdoso                                                                                                                                                          |
|Data Aplicação: outubro/2014                                                                                                                                                         |
|Descrição: Compra de Vale Alimentação ou Vale Refeição de acordo com layOut Visa Vale.                                                                                                |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "prtopdef.ch"

User Function xVrabgh()    // Miscelanea\Exportacao\Vale Refeição (arquivos va.csv e vr.csv)
PRIVATE cPerg	 :="XVALER"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
EndIf

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
Local cArquivo   := alltrim(cRootPath) + alltrim(cStartPath) + alltrim(mv_par03)   
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cMesAnoRef
Local dInicio := FirstDay(mv_par01)
Local dFim := LastDay(mv_par01)                  
Local dDtPesqAf
Local cTipAfas    := " "        
Local cSeq := '000001'
Local nferias := 0
Local nAfasta := 0
Private ndiaAfasta := 0
Private nUteis    := 0
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
cMesAnoRef := StrZero(Month(MV_PAR01),2) + StrZero(Year(MV_PAR01),4)
Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)
If !Empty(MV_PAR01)
	cData = Dtos(MV_PAR01)
EndIf
nHandle := MsfCreate(alltrim(MV_PAR03),0)
cData := STOD( CdATA)
dDataRef := mv_par01      
dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif
IF Select("QRY2") <> 0 
	QRY2->(DbCloseArea())
Endif
DbSelectArea("SP3") // FERIADOS
DbSetOrder(1)
DbSelectArea("CTT") // CENTRO DE CUSTO
DbSetOrder(1)                           
DbSelectArea("SRJ") // FUNCOES
DbSetOrder(1)               
DbSelectArea("SRN") // MEIOS DE TRANSPORTE
DbSetOrder(1)
DbSelectArea("RFO") // REFEICAO/ALIMENTACAO X FUNCIONARIOS
DbSetOrder(1)
DbSelectArea("SRX")
DbSetOrder(1)                                                
cValRef := ''

//cRefeicao := STRTRAN(Alltrim(mv_par04),"*","")

//For xx = 1 to Len(cRefeicao)
//	cValida := Substr(cRefeicao,xx,1)    
//	cValida := u_xxVerRefe(cValida)
//	cVALREF += cvalida+ "|"                      
//Next          

cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CODFUNC,RA_NASC,RA_CEP,RA_CIC,RA_RG,RA_VALEALI,RA_SEXO, "
cQuery += " RA_MAE,RA_PAI,RA_ENDEREC,RA_MUNICIP,RA_ESTADO,RA_VALEREF,RA_SEQTURN,RA_TNOTRAB,RA_SITFOLH "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (NOLOCK) "
cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_SITFOLH NOT IN ('D')"
cQuery += " AND SRA.RA_FILIAL BETWEEN '" + MV_PAR05  + "' AND '" + MV_PAR06  + "' "
cQuery += " AND SRA.RA_CC BETWEEN '" + MV_PAR07  + "' AND '" + MV_PAR08  + "' "
cQuery += " AND SRA.RA_MAT BETWEEN '" + MV_PAR09  + "' AND '" + MV_PAR10  + "' "
//cQuery += " AND SRA.RA_ADMISSA BETWEEN '" + DTOS(MV_PAR09)  + "' AND '" + DTOS(MV_PAR10)  + "' "
//cQuery += " AND RA_MAT = '010332'  "
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "

TCQUERY cQuery NEW ALIAS "QRY1"
TCQUERY "SELECT RCG_TNOTRA, COUNT(RCG_TNOTRA) as DIAS_TOTAIS FROM RCG020 WHERE D_E_L_E_T_ <> '*' AND RCG_TIPDIA = 1 AND RCG_DIAMES BETWEEN '"+DTOS(FIRSTDAY(MV_PAR02+30))+"' AND '"+DTOS(LASTDAY(MV_PAR02+30))+"' GROUP BY RCG_TNOTRA" NEW ALIAS "QRY2"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())
QRY2->(DBGOTOP())

/*GRAVACAO DO HEADER */ 
clinha := ";" + "NOME DO USUARIO" +";"+ "CPF" +";"+ "DATA DE NASCIMENTO" +";"+ "CODIGO DO SEXO" +";"+ "VALOR" +";"+ "TIPO DE LOCAL DE ENTREGA" +";"+ "LOCAL DE ENTREGA" +";"+ "MATRICULA" +";"+ "C.CUSTO" +";"+ "TURNO"
fWrite(nHandle, cLinha  + cCrLf )
/* ---------FIM HEADER ----- */

DO WHILE !QRY1->(EOF())
		IF ! eMPTY(QRY1->RA_DEMISSA)
			QRY1->(Dbskip())
			Loop
		eNDIF

//		IF ! QRY1->RA_VALEREF $ cValRef
//			QRY1->(Dbskip())
//			Loop
//		EndIF
		
		dDtAfas  := dDtRet := ctod("")
		cTipAfas    := " "
		fChkAfas(QRY1->RA_FILIAL,QRY1->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
		
		If cTipAfas $"HIJKLMNSU234" .Or.;
			(!Empty(QRY1->RA_DEMISSA) .And. MesAno(stod(QRY1->RA_DEMISSA))<= MesAno(dDtPesqAf))
			cTipAfas := "D"
			QRY1->(Dbskip())
			Loop
			Elseif cTipAfas $"OPQRXYV8W1"  
				iF dDtRet > LASTDAY((mv_par02) + 30)//MV_PAR02
					cTipAfas := "A"          
					QRY1->(Dbskip())
					Loop
				Endif	
			ElseIf cTipAfas == "F"
				iF dDtRet > LASTDAY((mv_par02) + 30)//MV_PAR02  	
					cTipAfas := "F"
					QRY1->(Dbskip())
					Loop
				ELSE
					cTipAfas := "F"
				eNDIF	
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
	   
		If stod(QRY1->RA_ADMISSA) <= LASTDAY((mv_par02)+30) .and.	(Empty(QRY1->RA_DEMISSA) .or. stod(QRY1->RA_DEMISSA) >= LASTDAY((mv_par02) + 30))
			dbSelectArea( "QRY1" )

			/* testa dias trabalhados */
	 	    nUteis := nAfasta := nFaltas := nHe := 0
		    
			If stod(QRY1->RA_ADMISSA) >= FIRSTDAY((mv_par02)+30)
				nUteis := diaUtil(STOD(QRY1->RA_ADMISSA),LASTDAY((mv_par02)+30))
			Else
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02)+30))
			EndIf
			
			If nUteis <= 0 
			   nUteis := 0
			EndIf
			
			aMarcacoes	:= {}
			aTabCalend	:= {}	      
			
	 		//U_xTestaPonto()
	 		nFaltas := nHEAtestado('FALTAS',QRY1->RA_FILIAL + QRY1->RA_MAT)
	 		
	 		// TURNO DE ACORDO COM A ULTIMA ALTERACAO
			cTurno := QRY1->RA_TNOTRAB
	 		nHE := nHEAtestado('HE',QRY1->RA_FILIAL + QRY1->RA_MAT, cTurno)

			DbSelectArea("SR8")

			IF SR8->(DbSeek(Xfilial("SR8") + QRY1->RA_MAT ))			

				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SR8->R8_FILIAL + SR8->R8_MAT  
						dinifer := FIRSTDAY(mv_par02 + 30)
						dfimfer := LASTDAY(mv_par02 + 30)                                                
				   
						If SR8->R8_TIPO $ 'P/O/Q/F'
							if SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dinifer	.and. SR8->R8_DATAFIM <= dfimfer// as ferias comecaram antes do mes de calculo e acabaram no mes de calculo
							   		nAfasta += U_xafasta(dInifer,SR8->R8_DATAFIM)
							Elseif SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dfimfer// as ferias comecaram antes do mes de calculo e acabaram depois do mes de calculo
							   		nAfasta += U_xafasta(dInifer,dfimfer)
            				ElseIf SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  // as ferias estao no mes de calculo
								nAfasta += U_xafasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)               //29
							ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAINI <= dfimfer .and. SR8->R8_DATAFIM >= dfimfer // as ferias comecaram no mes de calcule e acabaram depois do mes de calculo
									nAfasta += U_xafasta(SR8->R8_DATAINI,dfimfer)
							Else // as ferias estao fora do periodo de calculo		
								nAfasta += 0 
							EndIf		
				    	EndIf

						DbSelectArea("SR8")
						DbSkip()
				Enddo

				DbSelectArea("SR8")
				DbSkip(-1)
			EndIf			

			nUteis := nUteis - nAfasta - nFaltas + nHe

			If nUteis < 0
				nUteis := 0
			Endif

			DbSelectArea( "QRY1" )
			/* ---------------------------- fim do ponto eletronico*/
 			CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
			SRJ->(Dbseek(xfilial("SRJ") + QRY1->RA_CODFUNC))

                            
			nValCesta := 0
			
             tpvale := MV_PAR04
	               
				If MV_PAR04 = 1 .and. !empty(QRY1->RA_VALEREF)
					
					DbSelectArea("RFO")
					dbsetOrder(1)
					
					IF RFO->(DbSeek(QRY1->RA_FILIAL + cvaltochar(tpvale) + QRY1->RA_VALEREF ))			
               	       nValCesta := RFO->RFO_VALOR
		            Endif
		         Endif   

				If MV_PAR04 = 2 .and. !empty(QRY1->RA_VALEALI)
					
					DbSelectArea("RFO")
					dbsetOrder(1)
					
					IF RFO->(DbSeek(QRY1->RA_FILIAL + cvaltochar(tpvale) + QRY1->RA_VALEALI ))			
               	       nValCesta := RFO->RFO_VALOR
		            Endif
		         Endif   

		IF 	nValCesta = 0
			QRY1->(Dbskip())
			Loop
		EndIF		



			 gerafut1()

	        //Endif                                                                                    
	        
	       	clinha := "%" + ";" + AllTrim(QRY1->RA_NOME) + ";"
			clinha = clinha + QRY1->RA_CIC + ";"
			clinha = clinha + StrZero(DAY(STOD(QRY1->RA_NASC)),2)+ "/" + StrZero(Month(STOD(QRY1->RA_NASC)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RA_NASC)),4),2) + ";"
			cLinha = cLinha + ALLTRIM(QRY1->RA_SEXO) + ";" 
			clinha = clinha + TRANSFORM ((nUteis /*QRY1->DIA_TOTAL - nAfasta*/) * nValCesta, "@E 999,999.99" ) + ";" 
			clinha = clinha + "FI" + ";"
			If QRY1->RA_FILIAL == "02"
				clinha = clinha + "150" + ";"
				ElseIf QRY1->RA_FILIAL == "06"
				clinha = clinha + "1121" + ";"
			EndIf
			clinha = clinha + QRY1->RA_MAT + ";"
			clinha = clinha + QRY1->RA_CC + ";"
			clinha = clinha + QRY1->RA_TNOTRAB + ";"
			clinha = clinha + "%" 
			fWrite(nHandle, cLinha  + cCrLf )
	        DbSelectArea("QRY1")        

			DbSelectArea("SRA")
			DbSeek(QRY1->RA_FILIAL+QRY1->RA_MAT)
			RecLock("SRA", .F.)
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
//DESCONTO EM FOLHA
			If strzero(MONTH((MV_PAR02)+30),2) $ ("01,03,05,07,09,11")
				SRA->RA__VRTOT1 := (nUteis * nValCesta) * 0.10
				ElseIf strzero(MONTH((MV_PAR02)+30),2) $ ("02,04,06,08,10,12")
					SRA->RA__VRTOT2 := (nUteis * nValCesta) * 0.10
			EndIf 

//ROTEIRO DE CÁLCULO
//VA ou VR BGH / SubStr(GetMV("MV_FOLMES"),5,2) $ ("01,03,05,07,09,11") / fGeraVerba("490",SRA->RA__VRTOT1,,,,,,,,,.T.,) / fGeraVerba("490",SRA->RA__VRTOT2,,,,,,,,,.T.,)
			
			MsUnLock()
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
		ENDIF
	QRY1->(DbSkip())
	Incproc()
EndDo                
fClose(nHandle)                         
MsgAlert( "Arquivo Gerado !" )
Return .T.                                                    
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
Static FuncTion DiaUtil(dDtEntr,dDtSai)

Local nDia  := 0
Local _nSem := 1
Local nDat  := 0
Local nC
Local cDt 
Local ntothoras := 0
Local _cAno     := Strzero(Year(dDtSai),4)
Local _cMes     := Strzero(Month(dDtSai),2)
//Local _Turno	:= QRY1->RA_TNOTRAB //Posicione("SPF",1,"02" + QRY1->RA_MAT + DTOS(MV_PAR01),"PF_TURNOPA") //_dTurno,"PF_TURNOPA")

nDat := dDtSai - dDtEntr + 1

If nDat == 0
	nDat := 1
EndIf

//dDtEntr := dDtEntr - 1

If Posicione("RCG",1, xFilial("RCG") + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
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
				nuteis++
			EndIf

Next nC

Return(nUteis) 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function nHEAtestado(cTipo,cFilMat,cTurno)
	Local nDias := 0
	Local cSQL := ""
	DEFAULT cTipo := 'FALTAS'
	
	IF Select("QRY3") <> 0 
		QRY3->(DbCloseArea())
	Endif
	
	If Posicione("RCG",1, xFilial("RCG") + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
		cTurno := QRY1->RA_TNOTRAB
	Else
		cTurno := "   "
	EndIf
	
	If cTipo == 'FALTAS'
		TcQuery "SELECT PC_FILIAL, PC_MAT, PC_PD, COUNT(PC_PD) DIAS FROM SPC020 WHERE D_E_L_E_T_ <> '*' AND PC_FILIAL+PC_MAT = '" + cFilMat + "' AND (PC_PD = '009' AND PC_ABONO IN ('   ','001','003','004','005','011','012','013','023','025','028','030')) GROUP BY PC_FILIAL, PC_MAT, PC_PD" New Alias "QRY3"
		nDias := QRY3->&("DIAS")
	ElseIf cTipo == 'HE'
		cSQL := "SELECT PC_FILIAL, PC_MAT, COUNT(PC_PD) DIAS FROM "+ RetSqlName("SPC") +" " + ;
			" inner join "+ RetSqlName("RCG") +" on "+ RetSqlName("RCG") +".D_E_L_E_T_ <> '*' and RCG_DIAMES = PC_DATA and RCG_TNOTRA = '"+cTurno+"' " + ;
			" where "+ RetSqlName("SPC") +".D_E_L_E_T_ <> '*' and PC_FILIAL+PC_MAT = '"+cFilMat+"' AND RCG_TIPDIA <> 1 and PC_PD IN ('120','121','122','123','127','128','129','130','131','132','133') AND PC_ABONO IN ('   ')" + ;
			" GROUP BY PC_FILIAL, PC_MAT"
		TcQuery cSQL New Alias "QRY3"
		nDias := QRY3->&("DIAS")
	EndIf
Return nDias
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//gera lançamento futuro
Static Function gerafut1()

mesfol := CTOD("01/"+SUBSTR(GetMv("MV_FOLMES"),5,2)+"/"+SUBSTR(GetMv("MV_FOLMES"),1,4))

dtdesc := LastDay(mesfol)+36


DbSelectArea("SRA")
DbSetOrder(1)      	

	If nValCesta = 0
	   Return
    Endif

	If !DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT)
	   Return
    Endif
    
nvaldes := (nUteis * nValCesta) * 0.10 

		
DbSelectArea("SRK")
DbSetOrder(1)      	

	If DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT + "490")		   

	   RecLock("SRK", .F.)
       SRK->RK_VALORTO := nvaldes
       SRK->RK_VALORPA := nvaldes
       SRK->RK_VLSALDO := nvaldes

	MsUnlock("SRK")
	
    Else

    RecLock("SRK", .T.)
     
       SRK->RK_FILIAL  := QRY1->RA_FILIAL
       SRK->RK_MAT     := QRY1->RA_MAT
       SRK->RK_PD      := "490"
       SRK->RK_VALORTO := nvaldes
       SRK->RK_PARCELA := 01
       SRK->RK_VALORPA := nvaldes
       SRK->RK_VLSALDO := nvaldes
       SRK->RK_DTVENC  := dtdesc
       SRK->RK_CC      := QRY1->RA_CC
       SRK->RK_DOCUMENT:= "1"
    Endif
       
	MsUnlock("SRK")
                  
Return

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static FuncTion HrUtil(dDtEntr,dDtSai)

Local nDia := 0
Local nDat := 0
Local nC
Local cDt 
Local nuteis    := 0         
Local ntothoras := 0

nDat := dDtSai - dDtEntr

dDtEntr:= dDtEntr - 1

For nC := 1 To nDat
	cDt:= RetTipoDia(dDtEntr+nC)
	If cDt = "1" // dias trabalhados 
		nuteis ++
		nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
	ElseIf cDt = "3" // DSR
		nUteis = nUteis   
		nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
	ElseIf cDt  = "2" // sabado 
		SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7" ))
		If SPJ->PJ_HRTOTAL > 0	
			nUteis ++                                                                         
			nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
		EndIF	
		SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))	 
	Else 
		nUteis = nUteis								
	EndIf
Next nC

Return(nTotHoras) 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function Streeper(cVar,nlen)
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'.','')
cVar = StrTran(cvar,'-','')
cVar = Alltrim(cVar)
cVar = cVar + space(nLen - Len(cvar))
Return(cVar)
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function xxfVale(l1Elem,lTipoRet)

Local cTitulo  := ""
Local MvPar
Local MvParDef := ""
Local x        := 1               
Local aValida  := {}
Private aCat   := {}
                 
aadd(aValida,{"A","01"})
aadd(aValida,{"B","02"})
aadd(aValida,{"C","03"})
aadd(aValida,{"D","04"})
aadd(aValida,{"E","06"})
aadd(aValida,{"F","07"})

lTipoRet := .t.
l1Elem   := IIF(l1Elem == Nil,.f.,.t.)

cAlias := Alias() 					 // Salva Alias Anterior

If lTipoRet
	MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

aCat :={"A - Visa Refeicao DIA"     ,;
		  "B - Visa Alimentacao DIA"  ,;
		  "C - Visa Refeicao NOITE"   ,;
		  "D - Visa Alimentacao NOITE",;
		  "E - Visa Refeicao 10,50",;
		  "F - Visa Lanche Menor Aprendiz R$ 5,00"}		  
	
	MvParDef := "ABCDEF"
	cTitulo  := "Tipos de Vale Refeicao"

If lTipoRet

	If f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,38,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := mvpar										 // Devolve Resultado
	EndIf
EndIf

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )        
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function xxVERREFE(cValida)
Local aValida  := {}   
Local nDiv     := 0
Local cMotivo  := " "
aadd(aValida, {"A","01" })
aadd(aValida, {"B","02" })
aadd(aValida, {"C","03" })
aadd(aValida, {"D","04" })
aadd(aValida, {"E","06" })
aadd(aValida, {"F","07" })
nDiv := Ascan(aValida, { |X| X[1] = cValida})				
If nDiv > 0    
	cMotivo := aValida[ndiv,2]
EndIF
Return(cMotivo)
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//CRIACAO DA PERGUNTA //
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
  AAdd(aRegs,{cPerg,"01","Per.Apontam.de?   ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"02","Per.Apontam.ate?  ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"03","Arquivo Destino?  ","","","mv_ch3","C",70,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"04","Tipode Vale?      ","","","mv_ch4","C",0,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"05","Filial de?        ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"06","Filial ate?       ","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"07","Centro Custo de?  ","","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"08","Centro Custo ate? ","","","mv_ch8","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"09","Matricula de?     ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"10","Matricula ate?    ","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})

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