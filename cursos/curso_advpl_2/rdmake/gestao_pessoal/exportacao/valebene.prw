#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function ValeBene()
PRIVATE cPerg	 :="XVALEB"
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
Local dInicio := FirstDay(mv_par01)
Local dFim := LastDay(mv_par01)
Local dDtPesqAf
Local aTotCC := {}
Local yy := 0
Local cTipAfas    := " "
Local cSeq := '000001'
Local nTotReg := 0
Local nTotEmp := 0
Local nTotEnd := 0
Local nTotFunc := 0
Local nTotBene := 0
Local nTotInsu := 0

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
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_CC,RA_NOME,RA_ADMISSA,RA_DEMISSA, RA_CODFUNC, RA_NASC, RA_CEP, RA_CIC, RA_RG, RA_SEXO, "
cQuery += " RA_MAE, RA_PAI, RA_ENDEREC, RA_MUNICIP, RA_ESTADO,RA_VALEREF,RA_SEQTURN, RA_TNOTRAB"
cQuery += " FROM " + RetSqlName("SRA") + " SRA (NOLOCK) "
cQuery += " WHERE  "
cQuery += "	SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_SITFOLH NOT IN('D')"
cQuery += " AND SRA.RA_CATFUNC NOT IN('A')"
cQuery += " AND SRA.RA_CC >= '" + MV_PAR06  + "' "
cQuery += " AND SRA.RA_CC <= '" + MV_PAR07  + "' "
//cQuery += " AND RA_MAT IN ('010293') "
cQuery += " ORDER BY RA_FILIAL,RA_CC,RA_NOME "
TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())
/*GRAVACAO DO HEADER */
clinha := "0" // IDENTIFICADOR
clinha = clinha + "0100" //CD_VERSAO
clinha = clinha +  StrZero(DAY(dDatabase),2) + StrZero(Month(dDataBase),2) + right(Str(Year(dDataBase),4),2) //DATA DE EMISSAO
clinha = clinha + SUBSTR(SM0->M0_CGC,1,14)  // CGC DA EMPRESA PRINCIPAL
clinha = clinha + SUBSTR(SM0->M0_NOMECOM,1,40)+ SPACE(20)  // NOME DA EMPRESA
cLinha = clinha + space(509) // COMPLEMENTO (BRANCOS)
cLinha = cLinha + cSeq
nTotReg++
fWrite(nHandle, cLinha  + cCrLf )
/* ---------FIM HEADER ----- */
cSeq := Soma1(cSeq,6)
/* GRAVACAO DAS EMPRESAS  */
clinha := "1" // IDENTIFICADOR
clinha = clinha + "010198605" // IDENTIFICADOR DA EMPRESA NA VB
clinha = clinha + SUBSTR(SM0->M0_CGC,1,14)  // CGC DA EMPRESA PRINCIPAL
clinha = clinha + SUBSTR(SM0->M0_NOMECOM,1,40)+ SPACE(20)  // NOME DA EMPRESA
cLinha = cLinha + SUBSTR(SM0->M0_NOMECOM,1,40) // NOME FANTASIA DA EMPRESA
cLinha = cLinha + '206259407112' + space(8) // inscricao estadual
cLinha = cLinha + '5514454' + space(13) // INSCRICAO MUNICIPAL
cLinha = clinha + '19' + SPACE(2) // RAMO DE ATIVIDADE (INDUSTRIA ELETRONICOS/ELETRICA)
cLinha = cLinha + '11' // DDD DO TELEFONE
cLinha = cLinha + '34880700' + SPACE(2)  // NUMERO DO TELEFONE
cLinha = cLinha + '22' + SPACE(8)  // RAMAL DO TELEFONE
cLinha = cLinha + 'ANDREIA SOARES ANDRADE' + SPACE(60-LEN('ANDREIA SOARES ANDRADE'))  // NOME DO RESPONSAVEL PELO PEDIDO
cLinha = cLinha + '15' + SPACE(2)  // IDENTIFICACAO DO DEPARTAMENTO RESPONSAVEL (DEPARTAMENTO PESSOAL)
cLinha = cLinha + '17' + SPACE(2)  // CARGO DO CONTATO (COORDENADOR)
cLinha = cLinha + 'F'               // SEXO DO CONTATO
cLinha = cLinha + '080873'        // DATA DE NASCIMENTO DO CONTATO
clinha = clinha + 'andreia.andrade@bgh.com.br' + SPACE(50-LEN('andreia.andrade@bgh.com.br')) // e-mail do contato
cLinha = cLinha + space(279) // COMPLEMENTOS (BRANCOS)
cLinha = cLinha + cSeq
nTotReg++
nTotEmp++
fWrite(nHandle, cLinha  + cCrLf )
/* ---------FIM EMPRESAS  ----- */
cSeq := Soma1(cSeq,6)
/* GRAVACAO  ENDERECOS ----------------------*/
clinha := "2" // IDENTIFICADOR
clinha = clinha + SUBSTR(SM0->M0_CGC,1,14)  // CGC DA EMPRESA PRINCIPAL
clinha = clinha + "0001"   // IDENTIFICADOR DO ENDERECO
cLinha = cLinha + '1' // TIPO DE ENDERECO (FATURAMENTO E ENTREGA)
cLinha = cLinha + '06455010' // CEP
cLinha = cLinha + 'AV. JURUA ' + SPACE(60-LEN('AV. JURUA '))// LOGRADOURO
cLinha = cLinha + '314/320' + SPACE(10-LEN('314/320'))// NUMERO DO ENDERECO
cLinha = cLinha + SPACE(40) // COMPLEMENTO DO ENDERECO
cLinha = cLinha + 'andreia.andrade@bgh.com.br' + SPACE(60-LEN('andreia.andrade@bgh.com.br')) // RESPONSAVEL PELO RECEBIMENTO
cLinha = cLinha + space(396) // COMPLEMENTOS (BRANCOS)
cLinha = cLinha + cSeq
nTotReg++
nTotEnd++
fWrite(nHandle, cLinha  + cCrLf )
/* -------------- FIM ENDERECOS ----------------------*/
cSeq := Soma1(cSeq,6)
DO WHILE !QRY1->(EOF())
	If	SR0->(DbSeek(XFilial("SR0") + QRY1->RA_MAT)) .AND. EMPTY(QRY1->RA_DEMISSA) // funcionario tem Vale Transporte
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
			Endif
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
		//		If MesAno(stod(QRY1->RA_ADMISSA)) <= MesAno(dDtPesqAf) .and.;
		//			(Empty(QRY1->RA_DEMISSA) .or. MesAno(stod(QRY1->RA_DEMISSA)) >= MesAno(dDtPesqAf))
		If MesAno(stod(QRY1->RA_ADMISSA)) <= MesAno(mv_par02) .and.;
			(Empty(QRY1->RA_DEMISSA) .or. MesAno(stod(QRY1->RA_DEMISSA)) >= MesAno(dDtPesqAf))
			dbSelectArea( "QRY1" )
			/* testa dias trabalhados */
			nUteis := 0
			IF cTipAfas = 'F'
				/* claudia 18/09/2009 -pagar beneficio proporcional quando o funcionario for sair de ferias
				If dDtRet >= mv_par01 .and. dDtRet <= mv_par02
				nFerias := diaUtil(dDtAfas,dDtRet)
				Else
				If dDtRet < mv_par01
				nFerias := 0
				Endif
				
				if dDtRet > mv_par02
				nFerias := diaUtil(mv_par02,dDtRet)
				Endif
				Endif
				nUteis := 0
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02) + 30)) // - nFerias
				nUteis  := nUteis - nFerias
				*/
				nUteis := 0
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02) + 30))
			else
				nUteis := 0
				nUteis := diaUtil(FIRSTDAY((mv_par02)+30),LASTDAY((mv_par02) + 30))
			ENDIF
			nAfasta := 0
			IF SR8->(DbSeek(Xfilial("SR8") + QRY1->RA_MAT ))
				dbSelectArea("SR8")
				While !SR8->(Eof()) .And. (SR8->R8_FILIAL + SR8->R8_MAT == QRY1->RA_FILIAL + QRY1->RA_MAT)
					dinifer := FIRSTDAY(mv_par02+30)
					dfimfer := LASTDAY(mv_par02 +30)
					If SR8->R8_TIPO $ 'P/O/Q'  .AND. SR8->R8_DATAFIM <= mv_par02    .and. SR8->R8_DATAINI >= mv_par01
						iF SR8->R8_DATAFIM <= mv_par02
							nAfasta += U_afasta(Iif (SR8->R8_DATAINI >= mv_par01,SR8->R8_DATAINI,MV_PAR01),SR8->R8_DATAFIM) + 1
						Else
							nAfasta += U_afasta(Iif (SR8->R8_DATAINI >= mv_par01,SR8->R8_DATAINI,MV_PAR01),mv_par02) + 1
						EndIF
						/* claudia 18/09/2009 -pagar beneficio proporcional quando o funcionario for sair de ferias */
					ElseIf SR8->R8_TIPO = 'F'
						if SR8->R8_DATAINI >= dinifer .and.  SR8->R8_DATAFIM <= dfimfer  // as ferias estao no mes de calculo
							nAfasta += U_afasta(SR8->R8_DATAINI,SR8->R8_DATAFIM)	+ 1
						Elseif SR8->R8_DATAINI < dinifer .and.  SR8->R8_DATAFIM <= dfimfer .and. SR8->R8_DATAFIM > dinifer	// as ferias comecaram antes do mes de calculo e acabaram no mes de calculo
							nAfasta += U_afasta(dInifer,SR8->R8_DATAFIM) + 1
						ElseIf SR8->R8_DATAINI >= dinifer .and. SR8->R8_DATAINI < dfimfer .and. SR8->R8_DATAFIM > dfimfer // as ferias comecaram no mes de calcule e acabaram depois do mes de calculo
							nAfasta += U_afasta(SR8->R8_DATAINI,dfimfer) + 1
						else // as ferias estao fora do periodo de calculo
							nAfasta += 0
						endif
					Endif
					dbSkip()
				Enddo
				dbSkip(-1)
				dbSelectArea("QRY1")
			EndIf
			nUteis = nUteis - nAfasta
			If nUteis < 0
				nUteis := 0
			Endif
			
			
			If NUteis <= 0
				QRY1->(Dbskip())
				Loop
			Endif
			aMarcacoes	:= {}
			aTabCalend	:= {}
			/* testa faltas, feriados e DSR */
			//nUteis += TestaPonto()
			U_TestaPonto()
			dbSelectArea( "QRY1" )
			/* ---------------------------- fim do ponto eletronico*/
			CTT->(Dbseek(xfilial("CTT") + QRY1->RA_CC))
			SRJ->(Dbseek(xfilial("SRJ") + QRY1->RA_CODFUNC))
			/* REGISTRO FUNCIONARIOS */
			//clinha = clinha + transform(aTotcc[zz,3],"@E 99,999.99")+ ';'  // Horas total
			clinha := "3" // IDENTIFICADOR
			clinha = clinha + SUBSTR(SM0->M0_CGC,1,14)  // CGC DA EMPRESA PRINCIPAL
			clinha = clinha + "0001"   // IDENTIFICADOR DO ENDERECO
			cLinha = cLinha + ALLTRIM(QRY1->RA_MAT) + SPACE(15-LEN(ALLTRIM(QRY1->RA_MAT)))  // MATRICULA
			clinha = clinha + STRZERO(NUTEIS,3) // DIAS TRABALHOS
			cLinha = cLinha + substr(QRY1->RA_NOME,1,40)
			cLinha = clinha + Alltrim(CTT->CTT_DESC01) + SPACE(40-LEN(Alltrim(CTT->CTT_DESC01))) // DEPARTAMENTO
			cLinha = cLinha + Alltrim(SRJ->RJ_DESC) + SPACE(30-LEN(Alltrim(SRJ->RJ_DESC)))
			clinha = clinha +  StrZero(DAY(STOD(QRY1->RA_NASC)),2) + StrZero(Month(STOD(QRY1->RA_NASC)),2) + RIGHT(Str(Year(STOD(QRY1->RA_NASC)),4),2) //DATA DE NASCIMENTO DO FUNCIONARIO
			cLinha = clinha + QRY1->RA_CEP // CEP DO ENDERECO DO FUNCIONARIO
			cLinha = clinha + SPACE(1) // ESTADO CIVIL DO FUNCIONARIO - NAO OBRIGATORIO
			cLinha = clinha + QRY1->RA_CIC + SPACE(3) // CPF DO FUNCIONARIO
			cLinha = cLinha + Streeper(QRY1->RA_RG,14)   // RG DO FUNCIONARIO
			cLinha = cLinha + Replicate('0',8) // DATA DE EMISSAO DO RG - NAO OBRIGATORIO
			cLinha = cLinha + space(1) // SEXO DO FUNCIONARIO - NAO OBRIGATORIO
			cLinha = cLinha + ALLTRIM(QRY1->RA_MAE) + SPACE(40 - LEN(ALLTRIM(QRY1->RA_MAE))) // NOME DA MAE DO FUNCIONARIO
			cLinha = cLinha + Alltrim(QRY1->RA_PAI) + SPACE(40 - LEN(ALLTRIM(QRY1->RA_PAI))) // NOME DO PAI DO FUNCIONARIO
			clinha = clinha +  StrZero(DAY(STOD(QRY1->RA_ADMISSA)),2) + StrZero(Month(STOD(QRY1->RA_ADMISSA)),2) + RIGHT(Str(Year(STOD(QRY1->RA_ADMISSA)),4),4) //DATA DE ADMISSAO DO FUNCIONARIO
			cLinha = cLinha + Alltrim(QRY1->RA_ENDEREC) + SPACE(60 - LEN(ALLTRIM(QRY1->RA_ENDEREC))) // ENDERECO DO FUNCIONARIO
			cLinha = cLinha + space(10) // NUMERO DO ENDERECO DO FUNCIONARIO - O NUMERO JA ESTA NO ENDERECO
			cLinha = cLinha + space(40) // COMPLEMENTO DO ENDERECO DO FUNCIONARIO
			cLinha = cLinha + ALLTRIM(QRY1->RA_MUNICIP) + SPACE(60 - LEN(ALLTRIM(QRY1->RA_MUNICIP))) // CIDADE DO ENDERECO DO FUNCIONARIO
			cLinha = cLinha + ALLTRIM(QRY1->RA_ESTADO) // UF DO ENDERECO DO FUNCIONARIO
			cLinha = cLinha + SPACE(2) // DIGITO DO RG DO FUNCIONARIO - NAO OBRIGATORIO
			cLinha = cLinha + space(133) // COMPLEMENTOS (BRANCOS)
			cLinha = cLinha + cSeq
			fWrite(nHandle, cLinha  + cCrLf )
			cSeq := Soma1(cSeq,6)
			/* -------------- FIM ENDERECOS ----------------------*/
			
			/* ----- REGISTRO DE ITENS DE FUNCIONARIOS	*/
			dbSelectArea( "SRX" )
			nValCesta := 0
			If FPHIST82( QRY1->RA_FILIAL , "35" , QRY1->RA_FILIAL + QRY1->RA_VALEREF )
				nValCesta := Val(Substr(SRX->RX_TXT,01,11))
			Endif
			SR0->(DbSeek(XFilial("SR0") + QRY1->RA_MAT))
			DbSelectArea("QRY1")
			Do While ! SR0->(eof()) .and. SR0->R0_FILIAL = Xfilial("SR0") .and. SR0->R0_MAT = QRY1->RA_MAT
				SRN->(DbSeek(XFilial("SRN") + SR0->R0_MEIO))
				clinha := "5" // IDENTIFICADOR
				clinha = clinha + SUBSTR(SM0->M0_CGC,1,14)  // CGC DA EMPRESA PRINCIPAL
				cLinha = cLinha + ALLTRIM(QRY1->RA_MAT) + SPACE(15-LEN(ALLTRIM(QRY1->RA_MAT)))  // MATRICULA
				cLinha = cLinha  + SR0->R0_MEIO  // CODIGO DO ITEM
				cLinha = cLinha + SRN->RN_DESC // DESCRICAO DO ITEM
				cLinha = cLinha +  STRZERO( SR0->R0_QDIAINF,14)  // STRZERO(nUteis * SR0->R0_QDIAINF,14) // QUANTIDADE DE ITENS
				if ALLTRIM(SR0->R0_MEIO) = '518'
					cLinha = cLinha + STRZERO(SR0->R0_XVALORU  *100,14) // VALOR DO VALE TRANSPORTE
				ELSE
					cLinha = cLinha + STRZERO(SRN->RN_VUNIATU *100,14) // VALOR DO VALE TRANSPORTE
				ENDIF
				cLinha = cLinha + replicate('0',6) // QUANTIDADE DE FOLHAS NO TALAO
				cLinha = cLinha + SPACE(10)  // NUMERO DO CARTAO QUANDO ELETRONICO
				cLinha = cLinha + 'N'
				cLinha = cLinha + STRZERO(1,6) // FORNECEDOR (SP)
				cLinha = cLinha + space(20) // REDE PARA RECARGA
				cLinha = cLinha + SPACE(3)  //OPERADORA DO CELULAR
				cLinha = cLinha + SPACE(1)  // IDENTIFICADOR DO PROPRIETARIO DO CELULAR
				cLinha = cLinha + SPACE(2)  // DDD DO CELULAR
				cLinha = cLinha + SPACE(8)  // NUMERO DO CELULAR
				cLinha = cLinha + SPACE(404)  // COMPLEMENTOS
				cLinha = cLinha + cSeq // SEQUENCIAL DO REGISTRO
				nTotReg++
				nTotInsu++
				fWrite(nHandle, cLinha  + cCrLf )
				cSeq := Soma1(cSeq,6)
				SR0->(DbSkip())
			EndDo
			nTotReg++
			nTotFUNC++
			DbSelectArea("QRY1")
			/* FIM DE ITENS DE FUNCIONARIOS ------------------------*/
		ENDIF
	endIf
	QRY1->(DbSkip())
	Incproc()
EndDo
/* ------------------- GRAVACAO  TRAILLER    ----------------------*/
clinha := "9" // IDENTIFICADOR
clinha = clinha + STRZERO(nTotReg,6)  // CONTADOR DE LINHAS DO ARQUIVO
clinha = clinha + STRZERO(nTotemp,6)  // CONTADOR DE REGISTRO TIPO 1
clinha = clinha + STRZERO(nTotEND,6)  // CONTADOR DE REGISTRO TIPO 2
clinha = clinha + STRZERO(nTotFUNC,6)  // CONTADOR DE REGISTRO TIPO 3
clinha = clinha + STRZERO(nTotBENE,6)  // CONTADOR DE REGISTRO TIPO 4
clinha = clinha + STRZERO(nTotINSU,6)  // CONTADOR DE REGISTRO TIPO 5
clinha = clinha + SPACE(557)
cLinha = cLinha + cSeq
nTotReg++
nTotEnd++
fWrite(nHandle, cLinha  + cCrLf )
fClose(nHandle)
MsgAlert( "Arquivo Gerado !" )
Return .T.

/************************************************************/
Static FuncTion DiaUtil(dDtEntr,dDtSai)
Local nDia:=0
Local nDat:=0
Local nC
Local cDt
nDat := dDtSai-dDtEntr + 1
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
				nUteis ++
			EndIF
			SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))
		Else
			nUteis = nUteis
		EndIf
	ENDIF
Next nC
Return(nUteis)

/*
Static Function TestaPonto()
Local cDt
Local cAcessaSPC := &("{ || " + ChkRH("PONR050","SPC","2") + "}")
Local dInicio := MV_PAR01 //FirstDay(mv_par01)
Local dFim := MV_PAR02 // LastDay(mv_par01)
Local aAutorizado  := {}
Local cCodNAut 	:= "007,009,011,013,017,019,021,033,035,463,461,416,415,414,408" //-- Codigos nao Autorizados
Local cCodAut 	:= "008,010,012,014,018,020,022,032,034" //-- Codigos Autorizados
//Local cCodNAut 	:= "" //-- Codigos nao Autorizados
//Local cCodAut 	:= "" //-- Codigos Autorizados
//Local cExtra    := "120,121,122,123,127,128,129,130" // horas extras
Local cExtra    := "120,121,122,123,127,128,129,130" // horas extras
Local cFalta    := "009"
Local cCodigos  := ""
Local cAbona    := "014,015,019,016,022"
Local cNaoAbona := "001,003,004,005,011,012,013"
Local cFilCompara := SP9->P9_FILIAL
Local aPrevFun   :={}
aDet := {}
cCodigos := cCodAut + cCodNAut + cExtra + cFalta
DbSelectArea("SP9")
DbSeek(cFilCompara)
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

dbSelectArea( "SPC" )
If DbSeek(QRY1->RA_Filial + QRY1->RA_Mat )
While !Eof() .And. SPC->PC_Filial+SPC->PC_Mat == QRY1->RA_filial+QRY1->RA_Mat
If ! SPC->PC_PD $ cCodigos
SPC->(dbSkip())
Loop
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consiste controle de acessos e filiais validas               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Eval(cAcessaSPC)
SPC->(dbSkip())
Loop
EndIf
//-- Verifica o Periodo Solicitado
If Empty(SPC->PC_DATA) .OR. SPC->PC_DATA < dInicio .OR. SPC->PC_DATA > dFim
DbSkip()
Loop
Endif
If SPC->PC_PD $ cNaoAbona
DbSkip()
Loop
endif
If SPC->PC_PD $ '009' .and. SPC->PC_QTABONO > 0 .AND. SPC->PC_ABONO $ cAbona // Verifica se e treinamento, compensacao ou trabalho externo
DbSkip()
Loop
Endif
//-- Verifica as Faltas e Horas nao realizadas

//If SPC->PC_PD = '009' .AND. SPC->PC_QTABONO > 0
//	nUteis = nuteis
//ElseIf SPC->PC_PD = '009' .AND. SPC->PC_QTABONO <= 0
//	nUteis--

If SPC->PC_PD $ '005|006|007|009'
nUteis--
Else
cDt:= RetTipoDia(SPC->PC_DATA)
If cDt = "3" // DSR
nUteis ++ //
SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7" )) // noturno
If SPJ->PJ_HRTOTAL > 0
nUteis ++
Endif
Elseif cDt  = "2" // sabado
SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "7" ))
//If SPJ->PJ_HRTOTAL > 0	.OR. SP3->(DBSEEK(XFILIAL("SP3") + DTOS(SPC->PC_DATA) )) // SE O FUNCIONARIO NAO EH DO TURNO DE SABADO E NAO EH FERIADO RECEBE MAIS 1 VALE

//If SPJ->PJ_HRTOTAL > 0	.and. SP3->(DBSEEK(XFILIAL("SP3") + DTOS(SPC->PC_DATA) )) // SE O FUNCIONARIO EH DO TURNO DE SABADO e EH FERIADO RECEBE MAIS 1 VALE
//	nUteis += 2
//EndIF

If SPJ->PJ_HRTOTAL <= 0
nUteis ++ // horas extras
endif
SPJ->(DbSeek(Xfilial("SPJ") + QRY1->RA_TNOTRAB + "01" + "2" ))

else
If SP3->(DBSEEK(XFILIAL("SP3") + DTOS(SPC->PC_DATA) ))
nUteis ++
Endif
endif
Endif
DbSkip()
EndDo
Endif

Return //(aDet)

*/

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

/*------------------------------------*/
Return .t.


//CRIACAO DA PERGUNTA //
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
AAdd(aRegs,{cPerg,"01","Data de         : "        ,""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
AAdd(aRegs,{cPerg,"02","Data ate        : "        ,""   				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
AAdd(aRegs,{cPerg,"03","Arquivo destino : "        ,""   				,""  			,"mv_ch3",	"C",		70      ,0       ,		0 ,		"G"  ,		"",		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
AAdd(aRegs,{cPerg,"04","Filial de       : "        ,""   				,""  			,"mv_ch4",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})
AAdd(aRegs,{cPerg,"05","Filial ate      : "        ,""   				,""  			,"mv_ch5",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})
AAdd(aRegs,{cPerg,"06","Centro Custo de : "        ,"Centro Custo de:","Centro Custo de:","mv_ch6","C",	09      ,0       ,		0 ,		"G"  ,		"",		"mv_par06",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"CTT",			""})
AAdd(aRegs,{cPerg,"07","Centro Custo ate : "        ,"Centro Custo ate:","Centro Custo ate:","mv_ch7","C",	09      ,0       ,		0 ,		"G"  ,		"",		"mv_par07",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"CTT",			""})
//AAdd(aRegs,{cPerg,"04","Divisao Neg. de : "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})
//AAdd(aRegs,{cPerg,"05","Divisao Neg. ate: "        ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"ZM",			""})
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