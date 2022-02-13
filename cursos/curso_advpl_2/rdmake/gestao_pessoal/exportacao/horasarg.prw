#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function HORASARG()    
PRIVATE cPerg	 :="XHORAR"
ValidPerg(cPerg) 

if ! Pergunte(cPerg,.T.)
 Return()
Endif

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
Local dInicio := mv_par01
Local dFim := mv_par02
Local dDtPesqAf
Local yy := 0     
Local cTipAfas    := " "
Local aXAfast := {}
Local nhNormal := 0 
Local nHmenosfer := 0
Local ntotnorm   := 0
Local nTotExtra  := 0
Local nFaltainjus := 0 
Local nAbsente    := 0 
dDataRef := mv_par01      
cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
Private nUteis := 0
Private aTot := {}
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
Private axFalta    :={}
Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)

u_GerA0003(ProcName())


dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
nHandle := MsfCreate(alltrim(MV_PAR03),0)
//nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".xls",0)
//cLinha := ' '                   
//fWrite(nHandle, cLinha  + cCrLf)

DbSelectArea("SP3") // FERIADOS
DbSetOrder(1)

DbSelectArea("CTT") // CENTRO DE CUSTOS
DbSetOrder(1)


IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   
                                             
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_DEMISSA,RA_TPCONTR,RA_ADMISSA,RA_TNOTRAB,RA_SEQTURN,RA_XMO,RA_XHORA "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (nolock) "
cQuery += " WHERE  "
cQuery += "	SRA.RA_ADMISSA <= '" + DTOS(dFim) + "'  AND "       
//cQuery += " SRA.RA_MAT = '010290' AND "              
cQuery += "	SRA.D_E_L_E_T_ = ' ' "                     
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "
TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())   
clinha := "PERIODO" + ';'+"ORIGEM"+ ';' +"MATRICULA" + ';' +"NOME" + ';' +"C.CUSTO" + ';' +"TP.MO" + ';' +"COMPANHIA" + ';' +"CUMPRE HORARIO" + ';' +"HORAS BRUTAS ESP" + ';' +"HORAS ALMOCO" + ';' +"HORAS COMISON" + ';' +"HORAS NORMAIS" + ';' +"FERIAS" + ';' +"COMP FERIAS" + ';' 
cLinha += "HR MENOS FERIAS" + ';' +"EXTRA 50%" + ';' +"EXTRA 100%" + ';' +"TOTAL HR EXTRA" + ';' +"HR ADICIONAIS" + ';' +"TOTAL HR NORM" + ';' +"FALTAS INUST" + ';' +"DESC HR NAO TRAB" + ';' +"PERM SI GOCE SUEDO" + ';' +"LICENCAS LEGAIS" + ';' +"LIC. PESS (AT.MED)" + ';' +"PERMISOS GREMIALES" + ';' 
cLinha += "MOT OPERATIVOS" + ';' +"OUTROS AUSENT" + ';' +"AUSENT CATEGORI" + ';' +"TOTAL AUSENTISMO" + ';' +"HORA CAPACITACION" + ';' +"HR MOI PLANTAS" + ';' +"HR SUPERVISAO" + ';' +"TOTAL HR N APL PROD" + ';' +"HR CEDIDAS A MOI" + ';' +"HR CEDIDAS A MOD" + ';' +"TOTAL HRS APLICADAS" + ';' +"TOTAL HRS DISPON" + ';' 
fWrite(nHandle, cLinha  + cCrLf)
DO WHILE !QRY1->(EOF())
	aTot := {}
	dDtAfas  := dDtRet := ctod("")
	cTipAfas    := " "
	fChkAfas(QRY1->RA_FILIAL,QRY1->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"HIJKLMNSU234" .Or.;
		(!Empty(QRY1->RA_DEMISSA) .And. MesAno(stod(QRY1->RA_DEMISSA))<= MesAno(dDtPesqAf))
		cTipAfas := "D"
	Elseif cTipAfas $"OPQRXYV8W1"
		cTipAfas := "A"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
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
		yy := Ascan(aTot , {|x| x[1] =  QRY1->RA_MAT })
		If yy = 0                                       
			SI3->(MsSeek(Xfilial("SI3") + QRY1->RA_CC))                                  
		//	                     1   2 3 4 5 6 7 8 9 1011 12          13 14 15 16 17 18 19 20 21 22  23  24  25 26
			aadd (aTot,{QRY1->RA_MAT,0,0,0,0,0,0,0,0,0,0,SI3->I3_DESC,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 , 0 , 0 , 0, 0})
		Endif                
		nUteis := 0                            
		yy := Ascan(aTot , {|x| x[1] =  QRY1->RA_MAT })                      
		aTot[yy,16] += DiaUtil(mv_par01,mv_par02)          		
        If mesano(stod(QRY1->RA_ADMISSA)) = MesAno(dDtPesqAf) // admitidos      
        	aTot[yy,3] += HrUtil(mv_par01,mv_par02)          
			aTot[yy,9] += 1
        Endif
 		If cTipAfas == " " // situacao normal
 			aTot[yy,3] += HrUtil(mv_par01,mv_par02)          
 			aTot[yy,8]  += 1  //-- Total de Funcionarios
		Elseif cTipAfas == "A" // afastados
			dbSelectArea( "SR8" )
			axAfast := {}
			IF SR8->(DbSeek(Xfilial("SR8") + QRY1->RA_MAT ))			
				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SR8->R8_FILIAL + SR8->R8_MAT
				    If SR8->R8_TIPO <> 'F'
				    	if len(aXAfast) > 0
				    		aXAfast [1,1] := Iif(SR8->R8_DATAINI < mv_par01,mv_par01,SR8->R8_DATAINI)
				    		aXAfast [1,2] := Iif(SR8->R8_DATAFIM > mv_par02,mv_par02,SR8->R8_DATAFIM)
				    	Else
				    		aadd(aXAfast,{Iif(SR8->R8_DATAINI < mv_par01,mv_par01,SR8->R8_DATAINI),Iif(SR8->R8_DATAFIM > mv_par02,mv_par02,SR8->R8_DATAFIM)})	
				    	Endif
				    Endif
					dbSkip()
				Enddo
				dbSkip(-1)
				
			EndIf			
			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))
		   	aTot[yy,13] += HrUtil(aXAfast[1,1],aXAfast[1,2])                    
		   	SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))
		   	aTot[yy,3] += HrUtil(mv_par01,mv_par02)       
			aTot[yy,2] += 1                                            
			aTot[yy,8]  += 1  //-- Total de Funcionarios
			DbSelectArea("QRY1")
		Elseif cTipAfas == "D"                                           
			nUteis := 0
			aTot[yy,3] += HrUtil(mv_par01,Iif(stod(QRY1->RA_DEMISSA) < mv_par02, stod(QRY1->RA_DEMISSA), mv_par02))          
			aTot[yy,10] += 1           
		Elseif cTipAfas == "F"                                           
			dbSelectArea( "SRH" )
			If dbSeek( QRY1->RA_FILIAL + QRY1->RA_MAT )
				While !Eof() .And. QRY1->RA_FILIAL + QRY1->RA_MAT == SRH->RH_FILIAL + SRH->RH_MAT
					dbSkip()
				Enddo
				dbSkip(-1)
						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Se Esta Dentro Das Datas Selecionadas               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If  SRH->RH_DATAINI > mv_par02 .or. SRH->RH_DATAFIM < MV_PAR01 // SITUACAO NORMAL
					aTot[yy,3] += HrUtil(mv_par01,mv_par02)       
				Else // FERIAS                                                   
					aTot[yy,3] += HrUtil(mv_par01,mv_par02)          
					SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))
					aTot[yy,4]  += 1     
					nUteis := 0
					aTot[yy,11] += (diaUtil(Iif(SRH->RH_DATAINI < mv_par01, mv_par01, SRH->RH_DATAINI),Iif(SRH->RH_DATAFIM > mv_par02, mv_par02 , SRH->RH_DATAFIM  )) * iif(SPJ->PJ_HRTOTAL < 8 , SPJ->PJ_HRTOTAL , SPJ->PJ_HRTOTAL - 1 ))
				Endif
				aTot[yy,8]  += 1  //-- Total de Funcionarios
			Endif
			dbSelectArea( "QRY1" )
		Else
		  	dbSelectArea( "QRY1" )
		Endif
		/*
		testa eventos abonados do ponto eletronico - FALTAS, ATRASOS ETC*/
		aMarcacoes	:= {}
		aTabCalend	:= {}	
		axFalta     := {}
		adet:= TestaPonto()
		dbSelectArea( "QRY1" )
		nMax := len(aDet)
		For zz = 1 to nMax
			aTot[yy,6] += aDet[zz,3]
		Next             
		aTot[yy,5] += xExtra
		aTot[yy,14] += Iif(len(axfalta) > 0,axFalta[1,1],0) // Falta nao abonada
		aTot[yy,15] += Iif(len(axfalta) > 0,axFalta[1,2],0) // Falta abonada								
		/* ---------------------------- fim do ponto eletronico*/
	ENDIF                                              
	yy := Ascan(aTot , {|x| x[1] =  QRY1->RA_MAT })
	IF YY > 0
		nHnormal    := aTot[yy,3]// - aTot[yy,16] // horas normais  - horas brutas - horas de almoco
		nHmenosfer  := nHnormal - aTot[yy,11]   // horas - ferias
		nTotExtra   :=  (aTot[yy,17] + aTot[yy,18] ) // total de horas extra ( horas  50 % + horas 100%) 
		ntotnorm    := nHmenosfer + nTotExtra  // total de horas normais
		nFaltainjus := (aTot[yy,6]-aTot[yy,15]) // falta injustificada
		nAbsente    := ( nFaltaInjus + aTot[yy,21] + aTot[yy,19]+aTot[yy,20] + aTot[yy,13] + aTot[yy,22] )  // total de absenteismo
		If QRY1->RA_XMO = "SUP"
			aTot[YY,23] +=  nHmenosfer // horas de supervisao
		ElseIf QRY1->RA_XMO = "MOD"
			aTot[YY,25] +=  nHmenosfer  // horas-de-mao-de-obra direta
		ElseIf QRY1->RA_XMO = "MOI"		
			aTot[YY,26] +=  nHmenosfer // horas mao-de-obra-indireta
		Else
			aTot[YY,24] +=  nHmenosfer // horas de producao
		EndIF         
		CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
		cLinha := ''
		cLinha += Right(cMesAnoRef,4)+Left(cMesAnoRef,2)	+ ';' // periodo
		cLinha += '500' 									+ ';' 			 // origem          
		cLinha += PADL(ALLTRIM(QRY1->RA_MAT),7,'0')			+ ';' // Matricula
		cLinha += alltrim(QRY1->RA_NOME)					+ ';' // Nome 
		cLinha += IIF(EMPTY(CTT->CTT_XCCARG),'08028',CTT->CTT_XCCARG) 	+ ';' // centro de  custo
		cLinha += IIF(EMPTY(QRY1->RA_XMO),'MOD',QRY1->RA_XMO) 			+ ';' // tipo de mao de obra 
		cLinha += '00023' 												+ ';' // companhia
		cLinha += IIF(EMPTY(QRY1->RA_XHORA),'1',QRY1->RA_XHORA)			+ ';' // cumpre horario
		cLinha += STRZERO( ( aTot[yy,3]  +  aTot[yy,16] ) * 100 , 8)    			+ ';' // horas brutas esperada
		cLinha += STRZERO(aTot[yy,16] * 100 , 8)    			+ ';' // horas de almoco 
		cLinha += '00000000'   								+ ';' // horas de comissao
		cLinha += STRZERO( nHnormal * 100 , 8) 				+ ';' // Horas normais (horas brutas - horas de almoco)
		cLinha += STRZERO(aTot[yy,11]  * 100 , 8) 			+ ';' // horas de ferias
		clinha += STRZERO(0 , 8) 							+ ';' // comp de ferias - nao se aplica a BGH
		clinha += STRZERO( nHmenosfer * 100  , 8)			+ ';' // horas normais  - ferias       
		cLinha += STRZERO(aTot[yy,17]  * 100 , 8)    		+ ';' // total de hora extra 50%
		cLinha += STRZERO(aTot[yy,18]  * 100 , 8)    		+ ';' // total de hora extra 100%	
		cLinha += STRZERO(nTotExtra * 100 , 8)      			+ ';' // total de hora extra STRZERO(aTot[yy,5]  * 100 , 8)
		clinha += STRZERO(0 , 8) 							+ ';' // horas adicionais
		cLinha += STRZERO(nTotnorm * 100 , 8)      			+ ';' // total de hora normal
		cLinha += STRZERO(nFaltaInjus * 100,8)				+ ';' // faltas injustificadas
		cLinha += STRZERO(aTot[yy,21]* 100,8)					+ ';' // desc hr nao trabalhadas (hrs de atraso)
		cLinha += STRZERO((aTot[yy,19]+aTot[yy,20])*100,8)	+ ';' // saida antecipada e saida durante expediente   
		clinha += STRZERO(0 , 8) 							+ ';' // licensas legais nao remuneradas
		cLinha += STRZERO(aTot[yy,13]  * 100 , 8)    		+ ';' // licensas pessoais  (atestados + atestados 1/2 periodo)		
		clinha += STRZERO(0 , 8) 							+ ';' // permissoes de gremios - nao se aplicam a BGH	
		clinha += STRZERO(0 , 8) 							+ ';' // motivos operativos - nao se aplicam a BGH	
		cLinha += STRZERO(aTot[yy,22]  * 100 , 8)    		+ ';' // outras ausencias
		clinha += STRZERO(0 , 8) 							+ ';' // ausencia categoria
		cLinha += STRZERO( nAbsente * 100 , 8) 				+ ';' // total absenteismo	
		cLinha += STRZERO(aTot[yy,07]  * 100 , 8)    		+ ';' // horas de treinamento
		clinha += STRZERO(0 , 8) 							+ ';' // horas MOI plantas - nao se aplica a BGH                       
		cLinha += STRZERO(aTot[yy,23]  * 100 , 8)    		+ ';' // horas de supervisao
		cLinha += STRZERO(( nAbsente + aTot[yy,07] + aTot[yy,23] )  * 100 , 8)    		+ ';' // horas nao aplicada de producao
		cLinha += STRZERO(aTot[yy,25]  * 100 , 8)    		+ ';' // horas de mao-de-obra indireta
		cLinha += STRZERO(aTot[yy,26]  * 100 , 8)    		+ ';' // horas de mao-de-obra direta
		cLinha += STRZERO((nTotnorm -( nAbsente + aTot[yy,07] + aTot[yy,23])+ aTot[yy,25] + aTot[yy,26] ) * 100 , 8)    		+ ';' // Total de horas aplicadas   
		cLinha += STRZERO(( ntotNorm - nAbsente  )* 100 , 8)    		+ ';' // horas disponiveis
		fWrite(nHandle, cLinha  + cCrLf)
	EndIF	
	QRY1->(DbSkip())
	Incproc()
EndDo
/*
8
3  Horas total 
11 Horas de Ferias 
3  - 11  Horas Disponiveis
5 Horas Extras
6 Faltas 
7 Treinamento 
3 - 11 - 6 - 13 - 5 Horas Trabalhadas
9  No. funcionarios admitidos
10 No. funcionarios	demitidos
4  No. funcionarios em ferias 
2 No. funcionarios afastados     
13  Horas total de afastamento
6 - 15 Horas de falta nao abonada
15 Horas de falta abonada
*/
fClose(nHandle)
CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
/*	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
EndIf
*/
Return .T.                                                    

/************************************************************/
Static FuncTion DiaUtil(dDtEntr,dDtSai)
Local nDia:=0
Local nDat:=0
Local nC
Local cDt         
If Month(dDtSai) = 2
	nDat := dDtSai-dDtEntr+1
Else	                    
	nDat := dDtSai-dDtEntr+1
EndIf
dDtEntr:= dDtEntr-1
For nC := 1 To nDat
	cDt:= RetTipoDia(dDtEntr+nC)	
	If !SP3->(DBSEEK(XFILIAL("SP3") + DTOS(dDtEntr+nC) ))
		If cDt = "1" // dias trabalhados 
			nuteis ++
		ElseIf cDt = "3" // DSR
			nUteis = nUteis
		ElseIf cDt  = "2" // sabado 
			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7" ))
			If SPJ->PJ_HRTOTAL > 0	
				nUteis += 2 // funcionario de Sabado recebe um vale a mais
			EndIF	
			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))	 
		Else 
			nUteis = nUteis								
		EndIf
	ENDIF
Next nC
Return(nUteis) 


Static Function TestaPonto()
Local cAcessaSPC := &("{ || " + ChkRH("PONR050","SPH","2") + "}")
Local dInicio := mv_par01
Local dFim := mv_par02
Local aAutorizado  := {}
Local cCodNAut 	:= "001,007,009,011,013,017,019,021,033,035,463,461,416,415,414,408" //-- Codigos nao Autorizados
Local cCodAut 	:= "008,010,012,014,018,020,022,032,034" //-- Codigos Autorizados
Local cExtra    := "120,121,122,123,127,128,129,130" // horas extras
Local cCodigos  := ""
Local cFilCompara := SP9->P9_FILIAL       
Local aPrevFun   :={}
aDet := {}
cCodigos := cCodAut + cCodNAut
DbSelectArea("SP9")
DbSeek(cFilCompara)
aAutorizado := {}
While ! Eof() .AND. SP9->P9_FILIAL = cFilCompara
	If Subs(P9_IDPON,1,3) $ cCodigos
		Aadd(aAutorizado,{Left(P9_CODIGO,3),P9_DESC})
	Endif
	DbSkip()
EndDo
xExtra :=  0
	//-- Carrega as Marcacoes do Periodo
	IF !GetMarcacoes( @aMarcacoes		,;	//01 -> Marcacoes dos Funcionarios
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
    EndIF
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

	dbSelectArea( "SPH" ) 
	DbSetOrder(2)
	If DbSeek(QRY1->RA_Filial + QRY1->RA_Mat + Dtos(dInicio) )
		While !Eof() .And. SPH->PH_Filial+SPH->PH_Mat == QRY1->RA_filial+QRY1->RA_Mat   .and. SPH->PH_DATA <= dFim

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste controle de acessos e filiais validas               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Eval(cAcessaSPC)
				SPH->(dbSkip())
				Loop
			EndIf

			//-- Verifica o Periodo So	licitado
			If Empty(SPH->PH_DATA) .OR. SPH->PH_DATA < dInicio .OR. SPH->PH_DATA > dFim
				DbSkip()
				Loop
			Endif

		           
			//-- Utiliza o codigo informado qdo houver
			cPD := If(Empty(SPH->PH_PDI),SPH->PH_PD,SPH->PH_PDI)

			//-- Verifica se e um codigo contido na relacao de codigos 
			//-- definidas segundo avariavel cCodigos
			nPos := Ascan(aAutorizado,{ |x| x[1] = cPD })
            //-- Se o Codigo do Evento apontado  eh Valido
			If nPos > 0   
			
				//-- Obtem a quantidade do evento apontando
				xQuant := If(SPH->PH_QUANTI>0,SPH->PH_QUANTI,SPH->PH_QUANTC)
               
				aJustifica := {}
				
				//-- Verifica se existe abonos e posiciona registro de abono
				fAbonos(SPH->PH_DATA, aAutorizados[nPos,1],,@aJustifica,SPH->PH_TPMARCA,SPH->PH_CC)
        						
			    //-- Sintetiza por Evento
				If (nPosDet:=Ascan(aDet,{ |x| x[1] = cPD })) > 0
					aDet[nPosDet,3]:=SomaHoras(aDet[nPosDet,3],xQuant)
			    Else
					aAdd(aDet,{ aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant})
				Endif	              
				If !EMPTY(SPH->PH_ABONO) .AND. SPH->PH_QTABONO > 0 // SOMA EVENTOS ABONADOS
					If Len(aXFalta) >  0
						aXFalta [1,2] += xQuant	
					Else
						aAdd(aXFalta,{0,xQuant})
					Endif		
				Else       // SOMA EVENTOS NAO ABONADOS
					If Len(aXFalta) >  0
						aXFalta [1,1] += xQuant	
					Else
						aAdd(aXFalta,{xQuant,0})
					Endif					  									  
				EndIF
				yy := Ascan(aTot , {|x| x[1] =  QRY1->RA_MAT })                      
				If alltrim(cPd) = '014' // saida antecipada
					aTot[yy,19] += xQuant
				endif
				If alltrim(cPd) = '019' // saida durante expediente 
					aTot[yy,20] += xQuant
				endif         
				If alltrim(cPd) = '463' // atrasos
					aTot[yy,21] += xQuant
				endif   
				If alltrim(cPd) = '001' // hora extra nao autorizada
					aTot[yy,22] += xQuant
				endif   
				
				If alltrim(cPd) = '408' // atestadp de 1/2 periodo
					aTot[yy,13] += 5 // sempre soma 5 horas 
				endif
			Else            
				If  cPd $ cExtra
					xExtra += If(SPH->PH_QUANTI>0,SPH->PH_QUANTI,SPH->PH_QUANTC)				
					yy := Ascan(aTot , {|x| x[1] =  QRY1->RA_MAT })                      
					If alltrim(cPD) = '120'  //  horas 50 %
						aTot[yy,17] += If(SPH->PH_QUANTI>0,SPH->PH_QUANTI,SPH->PH_QUANTC)
					Endif	                                                             
					If alltrim(cPD) $ '123|128|129|130'  //  horas 100 %
						aTot[yy,18] += If(SPH->PH_QUANTI>0,SPH->PH_QUANTI,SPH->PH_QUANTC)
					Endif	                                                             
				EndIF			
			Endif                                                                        
			
			DbSkip()
		EndDo
	Endif

Return(aDet)

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
Local nDia:=0
Local nDat:=0
Local nC
Local cDt 
Local nuteis := 0         
Local ntothoras := 0

nDat := dDtSai-dDtEntr

dDtEntr:= dDtEntr-1

For nC := 1 To nDat             
	
	cDt:= RetTipoDia(dDtEntr+nC)
	If !SP3->(DBSEEK(XFILIAL("SP3") + DTOS(dDtEntr+nc) )) // verifica se nao eh feriado
		If cDt = "1" // dias trabalhados 
			nuteis ++
			nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
		ElseIf cDt = "3" // DSR
			nUteis = nUteis   
		   //	nTotHoras = nTotHoras + Iif(SPJ->PJ_HRTOTAL > 8, SPJ->PJ_HRTOTAL -1 , SPJ->PJ_HRTOTAL)
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
	EnDIf		
Next nC

Return(nTotHoras) 


//CRIACAO DA PERGUNTA
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
          //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Data de : "        ,"Data de : "   				,"Data de : "  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","Data ate: "        ,"Data ate: "   				,"Data ate: "  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
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
