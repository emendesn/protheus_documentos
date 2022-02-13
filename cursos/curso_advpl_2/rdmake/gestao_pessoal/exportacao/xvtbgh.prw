/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: xVTBGH                                                                                                                                                                   |
|Autor: Daniel Cardoso                                                                                                                                                                               |
|Data Aplicação: Outubro/20140                                                                                                                                                         |
|Descrição: Compra de Vale Transporte de acordo com layOut VB                                                                                                                          |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function xvtbgh()    // Miscelanea\Exportacao\VB (arquivos vb.txt)
PRIVATE cPerg	 :="XVALEB"     
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()
Local nAfasta := 0
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
Local aTotCC := {}
Local yy := 0     
Local nTotReg := 0
Local nTotEmp := 0
Local nTotEnd := 0
Local nTotFunc := 0  
Local nTotBene := 0
Local nTotInsu := 0    
Private ndiaAfasta := 0
Private nUteis     := 0
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
DbSelectArea("SR0") // VALE TRANSPORTE X FUNCIONARIOS
DbSetOrder(1)
DbSelectArea("SRX")
DbSetOrder(1)                                           

cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CODFUNC,RA_NASC,RA_CEP,RA_CIC,RA_RG,RA_SEXO, "
cQuery += " RA_MAE,RA_PAI,RA_ENDEREC,RA_MUNICIP,RA_ESTADO,RA_VALEREF,RA_SEQTURN,RA_TNOTRAB,RA_SITFOLH, RA_RGUF "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (NOLOCK) "
cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_SITFOLH NOT IN ('D','A')"
cQuery += " AND SRA.RA_FILIAL BETWEEN '" + MV_PAR04  + "' AND '" + MV_PAR05  + "' "
cQuery += " AND SRA.RA_CC BETWEEN '" + MV_PAR06  + "' AND '" + MV_PAR07  + "' "
cQuery += " AND SRA.RA_MAT BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09  + "' "
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "

MEMOWRITE("%TMP%\TESTE.txt",cQuery)

TCQUERY cQuery NEW ALIAS "QRY1"
TCSETFIELD("QRY1", "RA_NASC", "D")

TCQUERY "SELECT RCG_TNOTRA, COUNT(RCG_TNOTRA) as DIAS_TOTAIS FROM RCG020 WHERE D_E_L_E_T_ <> '*' AND RCG_TIPDIA = 1 AND RCG_DIAMES BETWEEN '"+DTOS(FIRSTDAY(MV_PAR02+30))+"' AND '"+DTOS(LASTDAY(MV_PAR02+30))+"' GROUP BY RCG_TNOTRA" NEW ALIAS "QRY2"

//Limpa tabela SRK

DbSelectArea("SRK")
SRK->(DbSetOrder(1)) 
While SRK->(!EoF()) 

	If SRK->RK_PD = "491"
   	   SRK->(RecLock("SRK",.F.))
	   SRK->(DbDelete())
	   SRK->(MsUnLock())
	EndIf
	SRK->(DbSkip())
EndDo


DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())
QRY2->(DBGOTOP())

clinha := "MATRÍCULA;NOME COMPLETO;ENDEREÇO;ATIVO;CARGO;DEPARTAMENTO;DIAS;CPF;NO.;DG;EST;DT. NASCIM.;NOME DA MÃE;CÓD;QTD;BLOQ;DIAS;VALOR;CÓD;QTD;BLOQ;DIAS;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;CÓD;QTD;BLOQ;VALOR;LOGRADOURO;NÚMERO;COMPLEMENTO;BAIRRO;CEP;CIDADE;EST."
fWrite(nHandle, cLinha  + cCrLf )

cSeq := Soma1(cSeq,6)
DO WHILE !QRY1->(EOF())
		IF ! eMPTY(QRY1->RA_DEMISSA)
			QRY1->(Dbskip())
			Loop
		eNDIF
		
DbSelectArea("SR0") // VALE TRANSPORTE X FUNCIONARIOS
DbSetOrder(1)

	 DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT,.f.) 

		IF SR0->R0_CODIGO < "0"
			QRY1->(Dbskip())
			Loop
		EndIF
 
		dDtAfas  := dDtRet := ctod("")
		cTipAfas := " "
		fChkAfas(QRY1->RA_FILIAL,QRY1->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao considera funcionarios admitidos apos o periodo do movimento ³
		//³ e nem os demitidos anterior ao periodo.						     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		_nTotBen := 0
//		_nTotBen := 10
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

			IF SR8->(DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT ))			

				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SR8->R8_FILIAL + SR8->R8_MAT  
						dinifer := FIRSTDAY(mv_par02 + 30)
						dfimfer := LASTDAY(mv_par02 + 30)                                                
				   
						If SR8->R8_TIPO $ 'P/O/Q/F'
							if SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dinifer	.and. SR8->R8_DATAFIM <= dfimfer// as ferias comecaram antes do mes de calculo e acabaram no mes de calculo											
							   		nAfasta += U_xxafasta(dInifer,SR8->R8_DATAFIM)
							Elseif SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dfimfer// as ferias comecaram antes do mes de calculo e acabaram depois do mes de calculo											
							   		nAfasta += U_xxafasta(dInifer,dfimfer)
            				ElseIf SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  // as ferias estao no mes de calculo
								nAfasta += U_xxafasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)               //29
							ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAINI <= dfimfer .and. SR8->R8_DATAFIM >= dfimfer // as ferias comecaram no mes de calcule e acabaram depois do mes de calculo
									nAfasta += U_xxafasta(SR8->R8_DATAINI,dfimfer)
							Else // as ferias estao fora do periodo de calculo		
								nAfasta += 0 
							EndIf		
				    	EndIf

						DbSelectArea("SR8")
						DbSkip()
				Enddo
	
				DbSelectArea("SR8")
				dbSkip(-1)
			EndIf			

			nUteis := nUteis - nAfasta - nFaltas + nHe

			If nUteis < 0
				nUteis := 0
			Endif
			
			dbSelectArea( "QRY1" )
			/* ---------------------------- fim do ponto eletronico*/
			QRY2->(dbGoTop())
			while !QRY2->(EOF()) .and. QRY2->&("RCG_TNOTRA") != cTurno
				QRY2->(dbSkip())
			enddo
			Iif(QRY2->&("RCG_TNOTRA") == cTurno, nDiasTotais := QRY2->&("DIAS_TOTAIS"), nDiasTotais := 0)
			CTT->(Dbseek(xFilial("CTT") + QRY1->RA_CC))
			SRJ->(Dbseek(xFilial("SRJ") + QRY1->RA_CODFUNC))


			/* REGISTRO FUNCIONARIOS */                     
			cLinha := ALLTRIM(QRY1->RA_MAT) + ";"  // MATRICULA
			cLinha += substr(QRY1->RA_NOME,1,40) + ";"
			cLinha += Alltrim(MV_PAR10) + ";" // ENDERECO DO FUNCIONARIO
            cLinha += "X;"  // ativo
            cLinha += SRJ->RJ_DESC + ";"  // cargo
			cLinha += Alltrim(CTT->CTT_DESC01) + ";" // DEPARTAMENTO
			clinha += STRZERO(nUteis, 3)  + ";" //( nDiasTotais - nAfasta ) ,3) // DIAS TRABALHOS DIA_TOTAL   - nAfasta
			cLinha += QRY1->RA_CIC + ";" // CPF DO FUNCIONARIO 
			cLinha += Streeper(QRY1->RA_RG,14) + ";"   // RG DO FUNCIONARIO
            cLinha += ";"  // dg
            cLinha += QRY1->RA_RGUF + ";"  // estado
//			clinha += StrZero(DAY(STOD(QRY1->RA_NASC)),2) + StrZero(Month(STOD(QRY1->RA_NASC)),2) + RIGHT(Str(Year(STOD(QRY1->RA_NASC)),4),2)  + ";" //DATA DE NASCIMENTO DO FUNCIONARIO
			clinha += dtoc(QRY1->RA_NASC)  + ";" //DATA DE NASCIMENTO DO FUNCIONARIO
			cLinha += ALLTRIM(QRY1->RA_MAE)  + ";" // NOME DA MAE DO FUNCIONARIO

			/* -------------- FIM ENDERECOS ----------------------*/
            
//	        SR0->(DbSeek(XFilial("SR0") + QRY1->RA_MAT))
			SR0->(DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT,.f.)) 
	        DbSelectArea("QRY1")        
	        Do While ! SR0->(eof()) .and. SR0->R0_FILIAL = QRY1->RA_FILIAL .and. SR0->R0_MAT = QRY1->RA_MAT
//				_nTotBen --
				_nTotBen ++
	        	SRN->(DbSeek(QRY1->RA_FILIAL + SR0->R0_CODIGO))                                              
	        	
				cLinha += SR0->R0_CODIGO + ";"  // CODIGO DO ITEM
				cLinha += str(SR0->R0_QDIAINF) + ";"  // STRZERO(nUteis * SR0->R0_QDIAINF,14) // QUANTIDADE DE ITENS
	        	cLinha += ";"          
		     	clinha += STRZERO(nUteis, 3)  + ";" //( nDiasTotais - nAfasta ) ,3) // DIAS TRABALHOS DIA_TOTAL   - nAfasta

                gerafut()

				if ALLTRIM(SR0->R0_CODIGO) == '641'
//					cLinha += STRZERO(SR0->R0_XVALORU  *100,14) + ";" // VALOR DO VALE TRANSPORTE				
//					cLinha += Transform(SR0->R0_VLRVALE ,"@E 99,999,999.99") + ";" // VALOR DO VALE TRANSPORTE				
					cLinha += Transform(SR0->R0_VLRVALE ,"@E 99,999,999.99") + ";" // VALOR DO VALE TRANSPORTE				
				ELSE
					cLinha += STRZERO(0 *100,14) + ";" // VALOR DO VALE TRANSPORTE
//					cLinha += STR(0 *100,14) + ";" // VALOR DO VALE TRANSPORTE
				ENDIF	

				SR0->(DbSkip())
			EndDo	
			
//			do while _nTotBen > 0
//				cLinha += ";;;;"  
//				_nTotBen--
//			enddo

			If _nTotBen = 1
				cLinha += ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"  
			Endif

			If _nTotBen = 2
				cLinha += ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"  
			Endif

			If _nTotBen = 3
				cLinha += ";;;;;;;;;;;;;;;;;;;;;;;;;;;"  
			Endif


			cLinha += Alltrim(QRY1->RA_ENDEREC) + ";" // ENDERECO DO FUNCIONARIO
			cLinha += ";" // NUMERO DO ENDERECO DO FUNCIONARIO - O NUMERO JA ESTA NO ENDERECO
			cLinha += ";" // COMPLEMENTO DO ENDERECO DO FUNCIONARIO                                                        
			cLinha += ";" // BAIRRO
			cLinha += QRY1->RA_CEP + ";" // CEP
			cLinha += ALLTRIM(QRY1->RA_MUNICIP) + ";" // CIDADE DO ENDERECO DO FUNCIONARIO
			cLinha += ALLTRIM(QRY1->RA_ESTADO) + ";" // UF DO ENDERECO DO FUNCIONARIO
			
			fWrite(nHandle, cLinha  + cCrLf )

			nTotReg++
	        nTotFUNC++	
			DbSelectArea("QRY1")
			/* FIM DE ITENS DE FUNCIONARIOS ------------------------*/ 
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

//If Posicione("RCG",1, xFilial("RCG") + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
If Posicione("RCG",1, QRY1->RA_FILIAL + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
	_Turno := QRY1->RA_TNOTRAB
Else
	_Turno := "   "
EndIf

For nC := 1 To nDat
	cDt := RetTipoDia(dDtEntr + (nC-1))	

SdDtEntr := dDtEntr +1

			DbSelectArea("RCG")
			DbSetOrder(2)
//			DbSeek(xFilial("RCG") + _cMes + _cAno + _Turno + DTOS(sdDtEntr),.f.)
			DbSeek(xFilial("RCG")+ SPACE(LEN(RCG_PROCES)) + SPACE(LEN(RCG_PER)) + SPACE(LEN(RCG_SEMANA)) + SPACE(LEN(RCG_ROTEIR)) + _Turno + DTOS(dDtEntr + (nC-1)),.f.)

			If RCG->RCG_TIPDIA == "1"
				nuteis++
			EndIf

Next nC


Return(nUteis) 
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function nHEAtestado(cTipo,cFilMat,cTurno)
	Local nDias := 0
	Local cSQL := ""
	DEFAULT cTipo := 'FALTAS'
	
	IF Select("QRY3") <> 0 
		QRY3->(DbCloseArea())
	Endif
	
	If Posicione("RCG",1, QRY1->RA_FILIAL + StrZero(Year(MV_PAR01),4) + StrZero(Month(MV_PAR01+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
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
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
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
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
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
		SPJ->(DbSeek(QRY1->RA_FILIAL + QRY1->RA_TNOTRAB + "01" + "7" ))
		If SPJ->PJ_HRTOTAL > 0	
			nUteis ++                                                                         
			nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
		EndIF	
		SPJ->(DbSeek(QRY1->RA_FILIAL + QRY1->RA_TNOTRAB + "01" + "2" ))	 
	Else 
		nUteis = nUteis								
	EndIf
Next nC

Return(nTotHoras) 
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
User FuncTion xxAfasta(dDtEntr,dDtSai)

Local nDia      := 0
Local _nSem     := 1
Local nDat      := 0
Local nC
Local cDt 
Local nafa      := 0         
Local ntothoras := 0
Local _cAno     := Strzero(Year(dDtSai),4)
Local _cMes     := Strzero(Month(dDtSai),2)
//Local _Turno	:= QRY1->RA_TNOTRAB //Posicione("SPF",1,"02" + QRY1->RA_MAT + DTOS(MV_PAR01), "PF_TURNOPA") //_dTurno,"PF_TURNOPA")
Local mSQL 	    := ""

nDat := dDtSai - dDtEntr + 1

//If Posicione("RCG",1, QRY1->RA_FILIAL + StrZero(Year(MV_PAR01),4) + StrZero(Month((MV_PAR01)+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB

If Posicione("RCG",1, QRY1->RA_FILIAL + StrZero(Year(MV_PAR01),4) + StrZero(Month((MV_PAR01)+30),2) + QRY1->RA_TNOTRAB, "RCG->RCG_TNOTRAB") == QRY1->RA_TNOTRAB
	_Turno := QRY1->RA_TNOTRAB
Else
	_Turno := "   "
EndIf

For nC := 1 To nDat
	cDt := RetTipoDia(dDtEntr + (nC-1))
           
			DbSelectArea("RCG")
			DbSetOrder(2)
//			DbSeek(xFilial("RCG") + _cMes + _cAno +  _Turno + DTOS(dDtEntr ))
			DbSeek(xfilial("RCG")+ SPACE(LEN(RCG_PROCES)) + SPACE(LEN(RCG_PER)) + SPACE(LEN(RCG_SEMANA)) + SPACE(LEN(RCG_ROTEIR)) + _Turno + DTOS(dDtEntr + (nC-1)),.f.)
            
				If RCG->RCG_TIPDIA == "1"
					nAfa++
				EndIf

Next nC

//If nAfa == 0
//	nAfa := 1
//EndIf

RCG->( dbCloseArea() )

Return(nAfa) 

Return .t.

//gera lançamento futuro do vt

Static Function gerafut()

mesfol := CTOD("01/"+SUBSTR(GetMv("MV_FOLMES"),5,2)+"/"+SUBSTR(GetMv("MV_FOLMES"),1,4))

dtdesc := LastDay(mesfol)+35


DbSelectArea("SRA")
DbSetOrder(1)      	

	If !DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT)
	   Return
    Endif

//      if ALLTRIM(SR0->R0_CODIGO) == '641'
//	   Return
//	  ENDIF	

nuteis1 := nuteis * SR0->R0_QDIAINF  
  
//nsalbas := (SRA->RA_SALARIO / 30 * nuteis)
nsalbas   :=  SRA->RA_SALARIO
nvaldes   := (nsalbas * 6 /100)
nvalcalc1 := (nuteis1 * SR0->R0_VLRVALE)

	If DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT + "491")		   
       nvalcalc1 := nvalcalc1 + SRK->RK_VALORTO
    Endif
     
	If nvaldes >= nvalcalc1
	   nvaldes := nvalcalc1
	endif
	
DbSelectArea("SRK")
DbSetOrder(1)      	
	
	If !DbSeek(QRY1->RA_FILIAL + QRY1->RA_MAT + "491")		   
//       nvaldes := nvaldes + SRK->RK_VALORTO
  
    RecLock("SRK", .T.)
     
    SRK->RK_FILIAL  := QRY1->RA_FILIAL
    SRK->RK_MAT     := QRY1->RA_MAT
    SRK->RK_PD      := "491"
    SRK->RK_VALORTO := nvaldes
    SRK->RK_PARCELA := 01
    SRK->RK_VALORPA := nvaldes
    SRK->RK_VLSALDO := nvaldes
    SRK->RK_DTVENC  := dtdesc
    SRK->RK_CC      := QRY1->RA_CC
    SRK->RK_DOCUMENT:= "1"

/*
	   RecLock("SRK", .F.)
       SRK->RK_VALORTO := nvaldes
       SRK->RK_VALORPA := nvaldes
       SRK->RK_VLSALDO := nvaldes

	MsUnlock("SRK")
	
    Else
*/
    Endif
       
	MsUnlock("SRK")
                  
Return
       
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
//CRIACAO DA PERGUNTA //
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
            //X1_GRUPO X1_ORDEM X1_PERGUNT            X1_PERSPA X1_PERENG X1_VARIAVL X1_TIPO X1_TAMANHO X1_DECIMAL X1_PRESEL X1_GSC X1_VALID   X1_VAR01	 X1_DEF01 X1_DEFSPA1 X1_DEFENG1 X1_CNT01 X1_VAR02 X1_DEF02 X1_DEFSPA2 X1_DEFENG2 X1_CNT02 X1_VAR03 X1_DEF03 X1_DEFSPA3 X1_DEFENG3 X1_CNT03 X1_VAR04 X1_DEF04 X1_DEFSPA4 X1_DEFENG4 X1_CNT04 X1_VAR05 X1_DEF05 X1_DEFSPA5 X1_DEFENG5 X1_CNT05 X1_F3 X1_PYME X1_GRPSXG X1_HELP X1_PICTURE X1_IDFIL
            //  2         3          4                   5           6         7        8         9         10         11      12      13         14         15			16        17        18       19       20        21         22        23       24       25        26         27        28       29       30        31         32        33       34       35        36         37        38     39     40        41       42       43        44
  AAdd(aRegs,{cPerg,"01","Per.Apontam. de?  ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"02","Per.Apontam. ate? ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"03","Arquivo Destino   ","","","mv_ch3","C",70,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"04","Filial de?        ","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"05","Filial ate?       ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"06","Centro Custo de?  ","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"07","Centro Custo ate? ","","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"08","Matricula de?     ","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"09","Matricula ate?    ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"10","Codigo endereço?  ","","","mv_ch10","C",12,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
//+-----------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function Streeper(cVar,nlen)
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'.','')
cVar = StrTran(cvar,'-','')
cVar = Alltrim(cVar)
cVar = cVar + space(nLen - Len(cvar))
Return(cVar)