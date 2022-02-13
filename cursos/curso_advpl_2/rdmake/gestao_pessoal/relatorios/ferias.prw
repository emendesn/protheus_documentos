/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: PROGRAMACAO DE FERIAS                                                                                                                                                       |
|Autor:                                                                                                                                                                                |
|Data Aplicação: 02/02/2011                                                                                                                                                            |
|Descrição: Relação de Férias Vencidas e sua respectiva Programação                                                                                                                    |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Andreia Andrade                                                                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 02/09/2011                                                                                                                                                            |
|Motivo: Inclusão dos campos ÁREA, DESCRIÇÃO DA ÁREA, TURNO e DESCRIÇÃO DO TURNO                                                                                                       |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Claudio Bispo                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 28/03/2012                                                                                                                                                            |
|Motivo: Inclusão do filtro e campo CELULA                                                                                                                                             |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Luciana Souza                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 04/06/2012                                                                                                                                                            |
|Motivo: Data limite concessão de 45 para 60 dias                                                                                                                                      |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Claudio Bispo                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 15/10/2012                                                                                                                                                            |
|Motivo: Inclusão CELULA B, CELULA C, CELULA D e CELULA E                                                                                                                              |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Claudio Bispo                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 04/01/2013                                                                                                                                                            |
|Motivo: Alteração Cabeçalho                                                                                                                                                           |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Claudio Bispo                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 29/04/2013                                                                                                                                                            |
|Motivo: Controle de Acesso de Usuário                                                                                                                                                 |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Luciana Souza                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 24/06/2013                                                                                                                                                            |
|Motivo: Ajuste Filtros para Controle de Acesso de Usuário                                                                                                                             |
|Resposável: Anadi                                                                                                                                                                     |
|Validado por: Luciana Souza                                                                                                                                                           |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 01/07/2013                                                                                                                                                             |
|Motivo: Readequação das Celulas                                                                                                                                                        |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Luciana Souza                                                                                                                                                            |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function xFERIAS()    // Relatorios\Customizados\Programacao de Ferias (arquivo PROGRAMACAO DE FERIAS.CSV)
PRIVATE cPerg	 :="XFERIAS"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
EndIf

Processa( { || MyRel() } )
Return .t.

Static Function MyRel()
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Local cQry1 :=""
Local cCrLf:=Chr(13)+Chr(10)
//
Local cArquivo 	:= CriaTrab(,.F.)
Local _csrvapl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+"PROGRAMACAO DE FERIAS.csv") //Local _cArqTmp  := lower(AllTrim(__RELDIR)+alltrim(cArquivo)+".csv")
Local cPath     :=AllTrim(GetTempPath())
Local cSeq      := '000001'
Local CCUSTO
nHandle         := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRA") // FUNCIONARIOS
DbSetOrder(1)
DbSelectArea("SRF") // PROGRAMACAO DE FERIAS
DbSetOrder(1)
DbSelectArea("SRF") // FUNCOES
DbSetOrder(1)

//cQuery := "SELECT RA_FILIAL, RA_CC, RA__DEPTO, QB_DESCRIC, RA_MAT, RA_NOME, RA_TNOTRAB, RJ_DESC, R6_DESC, RA__CELULA, ZK_DESCRIC, RA_CODFUNC, RA_SITFOLH, RA_ADMISSA,  RF_DATABAS, RF_DFERVAT, RF_DFERAAT, RF_DATAINI, RF_DFEPRO1, RF_DABPRO1, RF_DATINI2, RF_DFEPRO2, RF_PERC13S, RF_DATINI2, RF_DFEPRO2, RF_DABPRO2, RF_DATINI3, RF_DFEPRO3, RF_DABPRO3 FROM SRF020 AS SRA "
cQuery := "SELECT RA_FILIAL, RA_CC, RA__DEPTO, QB_DESCRIC, RA_MAT, RA_NOME, RA_TNOTRAB, RJ_DESC, R6_DESC, RA__CELULA, ZK_DESCRIC, RA_CODFUNC, RA_SITFOLH, RA_ADMISSA,  RF_DATABAS, RF_DFERVAT, RF_DFERAAT, RF_DATAINI, RF_DFEPRO1, RF_DABPRO1, RF_PERC13S, RF_DATINI2, RF_DFEPRO2, RF_DABPRO2, RF_DATINI3, RF_DFEPRO3, RF_DABPRO3 FROM SRF020 AS SRA "
cQuery += "INNER JOIN SRA020 ON RF_FILIAL = RA_FILIAL AND RF_MAT = RA_MAT "    
cQuery += "LEFT JOIN SQB020 ON RA__DEPTO = QB_DEPTO "
cQuery += "LEFT JOIN SR6020 ON RA_TNOTRAB = R6_TURNO "
cQuery += "LEFT JOIN SRJ020 ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "LEFT JOIN SZK020 ON RA__CELULA = ZK_CODIGO "
cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "AND RA_SITFOLH <> 'D' "
cQuery += "AND RA_CATFUNC IN ('M','H') "
cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += +IIF(!Empty(MV_PAR03),"AND RA_CC IN ('"+Alltrim(MV_PAR03)+"')","AND RA_CC NOT IN (' ')")
cQuery += "AND RA__CELULA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery += "ORDER BY RA_FILIAL, RA_CC, RF_DATABAS "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := ""          + ";" + ""                + ";" + ""     + ";" + ""                  + ";" + "PROGRAMAÇÃO DE FÉRIAS - " + StrZero(Month(dDataBase),2) + "/" + StrZero(Year(dDataBase),4) //+ ";"
fWrite(nHandle, cLinha  + cCrLf)

clinha := ""          + ";" + ""                + ";" + ""     + ";" + ""                  + ";" + ""     + ";" + ""      + ";" + ""                   + ";" + ""       + ";" + ""         + ";" + ""                   + ";" + ""                    + ";" + ""                           + ";" + ""            + ";" + ""              + ";" + "" + ";" + ""             + ";" + ""               +  ";" + ""             + ";"
fWrite(nHandle, cLinha  + cCrLf)

clinha :=	"MATR"				+ ";" + ;
			"CC"				+ ";" + ;
			"ÁREA"				+ ";" + ;
			"DESCRIÇÃO DA ÁREA"	+ ";" + ;
			"NOME"				+ ";" + ;
			"SITUAÇÃO"  		+ ";" + ;
			"TURNO"				+ ";" + ;
			"DESCRIÇÃO TURNO"	+ ";" + ;
			"CELULA"			+ ";" + ;
			"FUNCAO"			+ ";" + ;
			"ADMISSAO"			+ ";" + ;
			"PERIODO AQUISITIVO"+ ";" + ;
			"VENC"				+ ";" + ;
			"PROPORC"			+ ";" + ;
			"LIMITE  "			+ ";" + ;
			"FÉR.PROG.1º PER."  + ";" + ;
			"DIAS"				+ ";" + ;
			"13?"				+ ";" + ;
			"FÉR.PROG.2º PER."  + ";" + ;
			"DIAS"				+ ";" + ;
			"13?"				+ ";" + ;
			"DESCANSO"			+ ";" + ;
			"DIAS"				+ ";" + ;
			"13?"				+ ";"


fWrite(nHandle, cLinha  + cCrLf)

DO WHILE !QRY1->(EOF())
	
	CCUSTO := QRY1->RA_CC
	
	Do While QRY1->RA_CC == CCUSTO
		
		clinha := QRY1->RA_MAT + ";"															// MATR
		clinha = clinha + CCUSTO + ";" 															// CC
		clinha = clinha + QRY1->RA__DEPTO + ";"													// AREA
		clinha = clinha + Alltrim (QRY1->QB_DESCRIC) + ";"										// DESCRIÇÃO DA AREA
		clinha = clinha + QRY1->RA_NOME + ";"													// NOME
		clinha = clinha + QRY1->RA_SITFOLH + ";"												// SITUAÇÃO
		clinha = clinha + QRY1->RA_TNOTRAB + ";"												// TURNO
		clinha = clinha + Alltrim(QRY1->R6_DESC) + ";"											// DESCRIÇÃO DO TURNO
		clinha = clinha + Alltrim(QRY1->ZK_DESCRIC) + ";"              							// DESCRIÇÃO DA CELULA
		clinha = clinha + Alltrim(QRY1->RJ_DESC) + ";"											// DESCRIÇÃO DA FUNCAO
		clinha = clinha + StrZero(DAY(STOD(QRY1->RA_ADMISSA)),2) + "/" + StrZero(Month(STOD(QRY1->RA_ADMISSA)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RA_ADMISSA)),4),4) + ";" // ADMISSAO
		clinha = clinha + "DE" + " " + StrZero(DAY(STOD(QRY1->RF_DATABAS)),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATABAS)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATABAS)),4),4) + " " + "A" + " " + StrZero(DAY(STOD(QRY1->RF_DATABAS) + 364),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATABAS) + 364),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATABAS) + 364),4),4) + ";" // PERIODO AQUISITIVO
		clinha = clinha + IIF (QRY1->RF_DFERVAT > 0, (TRANSFORM (QRY1->RF_DFERVAT, "@E 999,999.99" ) + ";"), " "  + ";") // VENC
		clinha = clinha + IIF (QRY1->RF_DFERAAT > 0, (TRANSFORM (QRY1->RF_DFERAAT, "@E 999,999.99" ) + ";"), " "  + ";") // PROPORC
		clinha = clinha + StrZero(DAY(STOD(QRY1->RF_DATABAS) + 668),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATABAS) + 668),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATABAS) + 668),4),4) + ";" // LIMITE
		
		IF QRY1->RF_DATAINI <> "        "
			dDataINI := StrZero(DAY(STOD(QRY1->RF_DATAINI)),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATAINI)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATAINI)),4),4)
		Else
			dDataINI := "        "
		EndIf
		
		clinha = clinha + dDataINI + ";"														// DESCANSO
		clinha = clinha + IIF (dDataINI <> "        ", (TRANSFORM (QRY1->RF_DFEPRO1, "@E 999,999.99" ) + ";"), "        " + ";")	// DIAS

		clinha = clinha + IIF (dDataINI <> "        ", (IIF (QRY1->RF_PERC13S > 0, "SIM", "NAO") + ";"), "        " + ";")			// 13?
		

		IF QRY1->RF_DATINI2 <> "        "
			dDatINI2 := StrZero(DAY(STOD(QRY1->RF_DATINI2)),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATINI2)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATINI2)),4),4)
		Else
			dDatINI2 := "        "
		EndIf
		
		clinha = clinha + dDatINI2 + ";"														// DESCANSO
		clinha = clinha + IIF (dDatINI2 <> "        ", (TRANSFORM (QRY1->RF_DFEPRO2, "@E 999,999.99" ) + ";"), "        " + ";")	// DIAS

		clinha = clinha + IIF (dDatINI2 <> "        ", (IIF (QRY1->RF_PERC13S > 0, "SIM", "NAO") + ";"), "        " + ";")			// 13?


		fWrite(nHandle, cLinha  + cCrLf )

		Incproc()
		QRY1->(DbSkip())
		
	EndDo
	
EndDo

DbSelectArea("QRY1")

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
Else
	if 'C:' $ __RELDIR        // alterado por Rodrigo Salomão GLPI ID10003
		ShellExecute( "Open" , _cArqTmp ,"", "" , 3 )
	else
		ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )
	endif
EndIf
fClose(nHandle)
MsgAlert( "Arquivo Gerado !" )
Return .T.
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
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
AAdd(aRegs,{cPerg,"01","Filial De?"        ,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
AAdd(aRegs,{cPerg,"02","Filial Ate?"       ,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
AAdd(aRegs,{cPerg,"03","Centro Custo?"     ,"","","mv_ch3","C",50,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
AAdd(aRegs,{cPerg,"04","Celula De?"        ,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})
AAdd(aRegs,{cPerg,"05","Celula Ate?"       ,"","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})


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