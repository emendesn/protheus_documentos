/*
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: xValeRefe                                                                                                                                      |
|Autor:                                                                                                                                                   |
|Data Aplicação:                                                                                                                                          |
|Descrição: Compra de Vale Alimentação ou Vale Refeição de acordo com layOut Visa Vale.                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: Abril/2010                                                                                                                               |
|Motivo: Correção na quantidade de dias para concessão do Benefício.                                                                                      |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Luciana Benito da Silva                                                                                                                    |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
*/

#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function xValeRefe()    // Miscelanea\Exportacao\Vale Refeição (arquivos va.csv e vr.csv)
PRIVATE cPerg	 :="XREFEI"     
//ValidPerg(cPerg)
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

u_GerA0003(ProcName())

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
cValRef := ''

cRefeicao := STRTRAN(Alltrim(mv_par06),"*","")

For xx = 1 to Len(cRefeicao)
	cValida := Substr(cRefeicao,xx,1)    
	cValida := u_xVerRefe(cValida)
	cVALREF += cvalida+ "|"                      
Next          

cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_ADMISSA,RA_DEMISSA, RA_CODFUNC, RA_NASC, RA_CEP, RA_CIC, RA_RG, RA_SEXO, "
cQuery += " RA_MAE, RA_PAI, RA_ENDEREC, RA_MUNICIP, RA_ESTADO,RA_VALEREF,RA_SEQTURN, RA_TNOTRAB, RA_SITFOLH, DIA_TOTAL "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (NOLOCK), "
cQuery += " ( Select ZA1_TURNO,COUNT(ZA1_HRTOTA)DIA_TOTAL " 
cQuery += " From " + RetSqlName("ZA1") + " "
cQuery += " WHERE ZA1_FILIAL='"+xFilial("ZA1")+"' AND D_E_L_E_T_<> '*' AND ZA1_HRTOTA > 0 "
cQuery += " GROUP BY ZA1_TURNO ) ZA1 " 
cQuery += " WHERE  "
cQuery += "	SRA.D_E_L_E_T_ = ' ' "                       
cQuery += " AND SRA.RA_SITFOLH NOT IN('D')"   
cQuery += " AND SRA.RA_CATFUNC NOT IN('A')"        
cQuery += " AND SRA.RA_CC >= '" + MV_PAR07  + "' "
cQuery += " AND SRA.RA_CC <= '" + MV_PAR08  + "' "
cQuery += " AND SRA.RA_TNOTRAB=ZA1.ZA1_TURNO "
//cQuery += " AND RA_MAT = '010055'  "              //010456 ADAO 010109 ADILSON
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "
TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())   
/*GRAVACAO DO HEADER */ 
//clinha := ";" + "NOME DO USUARIO" + ";" + "CPF" + ";" + "DATA DE NASCIMENTO" + ";" + "CODIGO DO SEXO" + ";" + "VALOR" + ";" + "TIPO DE LOCAL DE ENTREGA" + ";" + "LOCAL DE ENTREGA" + ";" + "MATRICULA"
//fWrite(nHandle, cLinha  + cCrLf )
/* ---------FIM HEADER ----- */
DO WHILE !QRY1->(EOF())
		IF ! eMPTY(QRY1->RA_DEMISSA)
			QRY1->(Dbskip())
			Loop
		eNDIF
		
		IF ! QRY1->RA_VALEREF $ cValRef
			QRY1->(Dbskip())
			Loop
		EndIF
		
		dDtAfas  := dDtRet := ctod("")
		cTipAfas    := " "
		fChkAfas(QRY1->RA_FILIAL,QRY1->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
		
		If cTipAfas $"HIJKLMNSU234" .Or.;
			(!Empty(QRY1->RA_DEMISSA) .And. MesAno(stod(QRY1->RA_DEMISSA))<= MesAno(dDtPesqAf))
			cTipAfas := "D"
			QRY1->(Dbskip())
			Loop
			Elseif cTipAfas $"OPQRXYV8W1"  
				iF dDtRet > MV_PAR02
					cTipAfas := "A"          
					QRY1->(Dbskip())
					Loop
				Endif	
			ElseIf cTipAfas == "F"
				iF dDtRet > MV_PAR02  	
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
	   
		If MesAno(stod(QRY1->RA_ADMISSA)) <= MesAno(mv_par02) .and.;
			(Empty(QRY1->RA_DEMISSA) .or. MesAno(stod(QRY1->RA_DEMISSA)) >= MesAno(dDtPesqAf))
			dbSelectArea( "QRY1" )
			/* testa dias trabalhados */
	 	    nUteis := 0         
		    
		    IF cTipAfas = 'F'
	  	    	nUteis := 0
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02) + 30))
		    	else	 
		    	nUteis := 0
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02) + 30))
			EndIf 
			
			If nuteis <= 0 
				nUteis := 0
			EndIf
			
			aMarcacoes	:= {}
			aTabCalend	:= {}	      
			
			/* testa faltas, feriados e DSR */
			//nUteis += xTestaPonto()
	 		
	 		U_xTestaPonto()           

			DbSelectArea("SR8")
			nAfasta := 0

			IF SR8->(DbSeek(Xfilial("SR8") + QRY1->RA_MAT ))			

				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SR8->R8_FILIAL + SR8->R8_MAT  
						dinifer := FIRSTDAY(mv_par02 + 30)
						dfimfer := LASTDAY(mv_par02 + 30)                                                
					



						If SR8->R8_TIPO $ 'P/O/Q'  .AND. SR8->R8_DATAFIM <= mv_par02    .and. SR8->R8_DATAINI >= mv_par01
				   
				    		iF SR8->R8_DATAFIM <= mv_par02    
				    			nAfasta += U_xafasta(Iif (SR8->R8_DATAINI >= mv_par01,SR8->R8_DATAINI,MV_PAR01),SR8->R8_DATAFIM)
				    		Else	                                                                                          
				    			nAfasta += U_xafasta(Iif (SR8->R8_DATAINI >= mv_par01,SR8->R8_DATAINI,MV_PAR01),mv_par02) 
				    		EndIF                                                                               
				   
				   		/* claudia 18/09/2009 -pagar beneficio proporcional quando o funcionario for sair de ferias */
						ElseIf SR8->R8_TIPO = 'F'  					

							if SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  // as ferias estao no mes de calculo
								nAfasta += U_xafasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)	- 1

							Elseif SR8->R8_DATAINI <= dinifer .and. SR8->R8_DATAFIM >= dinifer	// as ferias comecaram antes do mes de calculo e acabaram no mes de calculo											
								nAfasta += U_xafasta(dInifer,SR8->R8_DATAFIM) //+ 1

							ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAFIM >= dfimfer // as ferias comecaram no mes de calcule e acabaram depois do mes de calculo
								nAfasta += U_xafasta(SR8->R8_DATAINI,dfimfer) //+ 1								

							else // as ferias estao fora do periodo de calculo		
								nAfasta += 0 
							endif		

				    	Endif

						DbSelectArea("SR8")
						DbSkip()
				Enddo

				DbSelectArea("SR8")
				DbSkip(-1)
			EndIf			

			nUteis = nUteis - nAfasta

			If nUteis < 0
				nUteis := 0
			Endif

			DbSelectArea( "QRY1" )
			/* ---------------------------- fim do ponto eletronico*/
 			CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
			SRJ->(Dbseek(xfilial("SRJ") + QRY1->RA_CODFUNC))
			dbSelectArea( "SRX" )                                
			nValCesta := 0
			If FPHIST82( QRY1->RA_FILIAL , "26" , QRY1->RA_FILIAL + QRY1->RA_VALEREF )
	        	nValCesta := Val(Substr(SRX->RX_TXT,23,10))		
	        Endif                                                                                    
	        
	       	clinha := "%" + ";" + SUBSTR(QRY1->RA_NOME,1,40) + ";"

			clinha = clinha + QRY1->RA_CIC + ";"
			clinha = clinha + StrZero(DAY(STOD(QRY1->RA_NASC)),2)+ "/" + StrZero(Month(STOD(QRY1->RA_NASC)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RA_NASC)),4),2) + ";"
			cLinha = cLinha + ALLTRIM(QRY1->RA_SEXO) + ";" 
			clinha = clinha + TRANSFORM ((QRY1->DIA_TOTAL - nAfasta) * nValCesta, "@E 999,999.99" ) + ";" 
			clinha = clinha + "FI" + ";" 
			clinha = clinha + "50" + ";" 
			clinha = clinha + QRY1->RA_MAT + ";"       
//			clinha = clinha + QRY1->RA_CC + ";"       
			clinha = clinha + "%" 
			fWrite(nHandle, cLinha  + cCrLf )
	        DbSelectArea("QRY1")        
		ENDIF
	QRY1->(DbSkip())
	Incproc()
EndDo                
fClose(nHandle)                         
MsgAlert( "Arquivo Gerado !" )
Return .T.                                                    

/************************************************************/
/*Static FuncTion DiaUtil(dDtEntr,dDtSai)

Local nDia  := 0
Local _nSem := 1
Local nDat  := 0
Local nC
Local cDt     

If Month(dDtSai) == 2
	nDat := dDtSai - dDtEntr + 1
Else	                    
	nDat := dDtSai - dDtEntr + 1
EndIf

dDtEntr := dDtEntr - 1

For nC := 1 To nDat
	cDt := RetTipoDia(dDtEntr + nC)

	If !SP3->(DbSeek(xFilial("SP3") + DTOS(dDtEntr + nC),.f.))

		If cDt == "1" // dias trabalhados
			nuteis++
		ElseIf cDt == "3" // DSR
			nUteis := nUteis
		ElseIf cDt == "2" // sabado
			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + Strzero(_nSem,2) + "7" ))

			If SPJ->PJ_HRTOTAL > 0
				nUteis++ // += 2 // funcionario de Sabado recebe um vale a mais // CLAUDIA 30/01/2010 = RETIRADO POR CAUSA DA TROCA DE TURNOS
			EndIf

			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + Strzero(_nSem,2) + "2" ))
			_nSem := IIF(_nSem == 1,2,1)
		Else 
			nUteis := nUteis
		EndIf

	EndIf

Next nC

Return(nUteis) */

/*User  Function xTestaPonto()
Local cDt 
Local cAcessaSPC := &("{ || " + ChkRH("PONR050","SPC","2") + "}")
Local dInicio := MV_PAR01 //FirstDay(mv_par01)
Local dFim := MV_PAR02 // LastDay(mv_par01)
Local aAutorizado  := {}
Local cCodNAut 	:= "007,009,011,013,017,019,021,033,035,463,461,416,415,414,408" //-- Codigos nao Autorizados
Local cCodAut 	:= "010,012,014,018,020,022,032,034" //-- Codigos Autorizados
//Local cCodNAut 	:= "" //-- Codigos nao Autorizados
//Local cCodAut 	:= "" //-- Codigos Autorizados
Local cExtra    := "120,121,122,123,127,128,129,130" // horas extras
Local cFalta    := "009"
Local cAbona    := "008,014,015,016,019,022"
Local cCodigos  := ""
Local cFilCompara := SP9->P9_FILIAL       
Local cNaoAbona := "001,003,004,005,011,012,013,023"
Local aPrevFun   :={}
Loca aDatas := {}
aDet := {}
cCodigos := cCodAut + "," + cCodNAut + "," + cExtra + "," + cFalta
DbSelectArea("SP9")
DbSeek(cFilCompara)
	//-- Carrega as Marcacoes do Periodo
If !GetMarcacoes( @aMarcacoes		,;	//01 -> Marcacoes dos Funcionarios
					  @aTabCalend		,;	//02 -> Calendario de Marcacoes
					  @aTabPadrao		,;	//03 -> Tabela Padrao
					  NIL				,;	//04 -> Turnos de Trabalho
					  dPerIni 			,;	//05 -> Periodo Inicial
					  dPerFim			,;	//06 -> Periodo Final
					  QRY1->RA_FILIAL	,;	//07 -> Filial
					  QRY1->RA_MAT		,;	//08 -> Matricula
					  SRA->RA_TNOTRAB	,;	//09 -> Turno
					  QRY1->RA_SEQTURN	,;	//10 -> Sequencia de Turno
					  QRY1->RA_CC		,;	//11 -> Centro de Custo
					  "SP8"				,;	//12 -> Alias para Carga das Marcacoes
					  .F.    			,;	//13 -> Se carrega Recno em aMarcacoes
					  .T.      			,;	//14 -> Se considera Apenas Ordenadas
					  .T.      			,;	//15 -> Se Verifica as Folgas Automaticas
					  .F.      			,;	//16 -> Se Grava Evento de Folga Automatica Periodo Anterior
					  NIL				,;	//17 -> Se Carrega as Marcacoes Automaticas
					  NIL				,;	//18 -> Registros de Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//19 -> Bloco para avaliar as Marcacoes Automaticas que deverao ser Desprezadas
					  NIL				,;	//20 -> Se Considera o Periodo de Apontamento das Marcacoes
					  .F.				 ;	//21 -> Se Efetua o Sincronismo dos Horarios na Criacao do Calendario
					)
		Help(' ',1,'PONSCALEND')
EndIf */
	//-- Obtem Qtde de Marcacoes
nLenMarc:=Len(aMarcacoes)

aDet := {}

// 1 - Data
// 2 - Codigo do Evento
// 3 - Descricao do Evento
// 4 - Descricao do Abono
// 5 - Descricao do Abono
// 6 - Quantidade de horas Abonadas
// 7 - Marcacoes

DbSelectArea("SPC")
DbSetOrder(1)

If DbSeek(QRY1->RA_Filial + QRY1->RA_Mat,.f.)
	aDatas := {}

	While !Eof() .And. SPC->PC_Filial + SPC->PC_Mat == QRY1->RA_FILIAL + QRY1->RA_MAT

			If aScan(aDatas,{|X| x[1] == DTOC(SPC->PC_DATA) + SPC->PC_PD}) > 0
				DbSelectArea("SPC")
				DbSkip()
				Loop
			Else
				AADD(aDatas,{DTOS(SPC->PC_DATA) + SPC->PC_PD})
			EndIf

			If !SPC->PC_PD $ cCodigos
				DbSelectArea("SPC")
				DbSkip()
				Loop
			EndIf

			// +------------------------------------------------+
			// | Consiste Controle de Acessos e Filiais Validas |
			// +------------------------------------------------+

			If !Eval(cAcessaSPC)
				DbSelectArea("SPC")
				DbSkip()
				Loop
			EndIf

			//-- Verifica o Periodo Solicitado

			If Empty(SPC->PC_DATA) .Or. SPC->PC_DATA < dInicio .Or. SPC->PC_DATA > dFim
				DbSelectArea("SPC")
				DbSkip()
				Loop
			EndIf

			If SPC->PC_PD $ cNaoAbona
				DbSelectArea("SPC")
				DbSkip()
				Loop
			EndIf
                            
			If SPC->PC_PD $ "009" .And. SPC->PC_QTABONO > 0 .And. SPC->PC_ABONO $ cAbona // Verifica se e treinamento, compensacao ou trabalho externo
				DbSelectArea("SPC")
				DbSkip()
				Loop
			EndIf

			//-- Verifica as Faltas e Horas nao realizadas
			/*
			If SPC->PC_PD = '009' .AND. SPC->PC_QTABONO > 0 
				nUteis = nuteis
			ElseIf SPC->PC_PD = '009' .AND. SPC->PC_QTABONO <= 0 
				nUteis--	
			*/	                 

			If SPC->PC_PD $ "005|006|007|009"
				nUteis--
			Else
				cDt := RetTipoDia(SPC->PC_DATA)

				If cDt == "3" // DSR
					nUteis ++ //                                                  

				/* CLAUDIA 30/01/2010 - RETIRADO DEVIDO A TROCA DE TURNO
				SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7" )) // noturno
				If SPJ->PJ_HRTOTAL > 0
					nUteis ++
				Endif
				*/

				ElseIf cDt == "2" // sabado 
					DbSelectArea("SPJ")
					DbSeek(xFilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7",.f.)

				/*
				If SPJ->PJ_HRTOTAL > 0	//.and. SP3->(DBSEEK(XFILIAL("SP3") + DTOS(SPC->PC_DATA) )) // SE O FUNCIONARIO  EH DO TURNO DE SABADO  RECEBE MAIS 1 VALE 
					nUteis += 2
				EndIF	               
				*/

					If SPJ->PJ_HRTOTAL <= 0
						nUteis ++ // horas extras	   
					EndIf

					DbSelectArea("SPJ")
					DbSeek(xFilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2",.f.)

				Else

					If SP3->(DbSeek(xFilial("SP3") + DTOS(SPC->PC_DATA),.f.))
						nUteis ++
					EndIf

				EndIf

			EndIf

			DbSelectArea("SPC")
			DbSkip()
	Enddo

EndIf

Return //(aDet)

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fChkSX1  ³ Autor ³ Marinaldo de Jesus    ³ Data ³13/02/2002³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Verifica se os Parametros de Periodo estao corretos        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ PONM040                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

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
/*
User FuncTion xAfasta(dDtEntr,dDtSai)

Local nDia      := 0
Local _nSem     := 1
Local nDat      := 0
Local nC
Local cDt 
Local nafa      := 0         
Local ntothoras := 0
Local _cAno     := Strzero(Year(dDtSai),4)
Local _cMes     := Strzero(Month(dDtSai),2)

nDat := dDtSai - dDtEntr + 1

If nDat == 0
	nDat := 1
EndIf

dDtEntr := dDtEntr - 1

For nC := 1 To nDat
	cDt := RetTipoDia(dDtEntr + nC)

	If !SP3->(DbSeek(xFilial("SP3") + DTOS(dDtEntr + nC),.f.))

		If cDt == "1" // dias trabalhados
			nAfa ++
		ElseIf cDt == "2" // sabado

			DbSelectArea("RCG")
			DbSetOrder(2)
			DbSeek(xFilial("RCG") + _cAno + _cMes + QRY1->RA_TNOTRAB + DTOS(dDtEntr + nC),.f.)

//			SPJ->(DbSeek(xFilial("SPJ") + QRY1->RA_TNOTRAB + Strzero(_nSem,2) + "7"))

			If RCG->RCG_TIPDIA == "1"
				nAfa ++ // += 2 // funcionario de Sabado recebe um vale a mais // CLAUDIA 30/01/2010 = RETIRADO POR CAUSA DA TROCA DE TURNOS
			EndIf

//			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + Strzero(_nSem,2) + "2" ))
//			_nSem := IIF(_nSem == 1,2,1)
		Else 
			nAfa := nAfa
		EndIf

	EndIf

Next nC

If nAfa == 0
	nAfa := 1
EndIf

Return(nAfa) 
*/
/*------------------------------------*/
Return .t.


//CRIACAO DA PERGUNTA //
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
            //X1_GRUPO X1_ORDEM X1_PERGUNT            X1_PERSPA X1_PERENG X1_VARIAVL X1_TIPO X1_TAMANHO X1_DECIMAL X1_PRESEL X1_GSC X1_VALID   X1_VAR01	 X1_DEF01 X1_DEFSPA1 X1_DEFENG1 X1_CNT01 X1_VAR02 X1_DEF02 X1_DEFSPA2 X1_DEFENG2 X1_CNT02 X1_VAR03 X1_DEF03 X1_DEFSPA3 X1_DEFENG3 X1_CNT03 X1_VAR04 X1_DEF04 X1_DEFSPA4 X1_DEFENG4 X1_CNT04 X1_VAR05 X1_DEF05 X1_DEFSPA5 X1_DEFENG5 X1_CNT05 X1_F3 X1_PYME X1_GRPSXG X1_HELP X1_PICTURE X1_IDFIL
            //  2         3          4                   5           6         7        8         9         10         11      12      13         14         15			16        17        18       19       20        21         22        23       24       25        26         27        28       29       30        31         32        33       34       35        36         37        38     39     40        41       42       43        44
  AAdd(aRegs,{cPerg   ,"01"    ,"Data de          : ",""       ,""       ,"mv_ch1"  ,"D"    ,08        ,0         ,0        ,"G"   ,""        ,"mv_par01",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""       ,""})
  AAdd(aRegs,{cPerg   ,"02"    ,"Data ate         : ",""       ,""       ,"mv_ch2"  ,"D"    ,08        ,0         ,0        ,"G"   ,""        ,"mv_par02",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","",""   ,""})
  AAdd(aRegs,{cPerg   ,"03"    ,"Arquivo destino  : ",""       ,""       ,"mv_ch3"  ,"C"    ,70        ,0         ,0        ,"G"   ,""        ,"mv_par03",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","",""   ,""})
  AAdd(aRegs,{cPerg   ,"04"    ,"Filial de        : ",""       ,""       ,"mv_ch4"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par04",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg   ,"05"    ,"Filial ate       : ",""       ,""       ,"mv_ch5"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par05",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg   ,"06"    ,"Tipo de Vale     : ",""       ,""       ,"mv_ch6"  ,"C"    ,05        ,0         ,0        ,"G"   ,"u_xFvale","mv_par06",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","",""   ,""})
  AAdd(aRegs,{cPerg   ,"07"    ,"Centro Custo de  : ",""       ,""       ,"mv_ch7"  ,"C"    ,09        ,0         ,0        ,"G"   ,""        ,"mv_par07",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg   ,"08"    ,"Centro Custo ate : ",""       ,""       ,"mv_ch8"  ,"C"    ,09        ,0         ,0        ,"G"   ,""        ,"mv_par08",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","CTT",""})
//AAdd(aRegs,{cPerg   ,"04"    ,"Divisao Neg. de  : ",""       ,""       ,"mv_ch3"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par04",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","ZM" ,""})
//AAdd(aRegs,{cPerg   ,"05"    ,"Divisao Neg. ate : ",""       ,""       ,"mv_ch3"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par04",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","ZM" ,""})

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

Static Function Streeper(cVar,nlen)
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'\','')
cVar = StrTran(cvar,'.','')
cVar = StrTran(cvar,'-','')
cVar = Alltrim(cVar)
cVar = cVar + space(nLen - Len(cvar))
Return(cVar)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³xfVale   ³ Autor ³ Claudia Cabral  	    ³ Data ³ 29/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar o motivo de cancelamento   	    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ xfVale()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function xfVale(l1Elem,lTipoRet)

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
		  "E - Visa Refeicao 10,50"}
	
	MvParDef := "ABCDE"
	cTitulo  := "Tipos de Vale Refeicao"

If lTipoRet

	If f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,38,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := mvpar										 // Devolve Resultado
	EndIf
EndIf

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )        


User Function xVERREFE(cValida)
Local aValida  := {}   
Local nDiv     := 0
Local cMotivo  := " "
aadd(aValida, {"A","01" })
aadd(aValida, {"B","02" })
aadd(aValida, {"C","03" })
aadd(aValida, {"D","04" })
aadd(aValida, {"E","06" })
nDiv := Ascan(aValida, { |X| X[1] = cValida})				
If nDiv > 0    
	cMotivo := aValida[ndiv,2]
EndIF
Return(cMotivo)

//RONALDO 14/04/2010 19:00hs