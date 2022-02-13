/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: ESOCIAL                                                                                                                                                                      |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 11/2013                                                                                                                                                                |
|Descrição: CAMPOS ALTERADOS PARA ESOCIAL                                                                                                                                               |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:                                                                                                                                                                        |
|Motivo:                                                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Fabio                                                                                                                                                                    |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function ESOCIAL()    // Relatorios\E-Social

PRIVATE cPerg := "ESOCIAL"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
EndIf

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
Local cQry1      :=""
Local cCrLf      :=Chr(13)+Chr(10)
Local cArquivo 	 := CriaTrab(,.F.)
//Local _csrvapl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp   := lower(AllTrim(MV_PAR08) + ".CSV") //lower(AllTrim(__RELDIR)+"ESOCIAL.csv")
Local cPath      :=AllTrim(GetTempPath())     
nHandle          := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

If MV_PAR09 = 1
	DbSelectArea("SRA") // FUNCIONARIOS
	DbSetOrder(1)
	DbSelectArea("CTT") // CENTRO DE CUSTO
	DbSetOrder(1)
	DbSelectArea("CCH") // PAIS
	DbSetOrder(2)
	DbSelectArea("CC2") // MUNICIPIO
	DbSetOrder(2)
	
	cQuery := "SELECT RA_FILIAL, RA_CC, CTT_DESC01, RA_MAT, RA_NOME, RA_SITFOLH, "
	cQuery += "RA_CPAISOR, CCH_PAIS, "
	cQuery += "RA_NATURAL, RA_MUNNASC, RA_CODMUNN, "
	cQuery += "RA_LOGRTP, RA_LOGRDSC, RA_LOGRNUM, RA_COMPLEM, RA_BAIRRO, RA_ESTADO, RA_CODMUN, CC2_MUN, RA_CEP "
	cQuery += "FROM " + RetSqlName("SRA") + "  AS SRA "
	cQuery += "LEFT JOIN " + RetSqlName("CTT") + " AS CTT ON RA_CC = CTT_CUSTO "
	cQuery += "LEFT JOIN " + RetSqlName("CCH") + " AS CCH ON RA_CPAISOR = CCH_CODIGO "
	cQuery += "LEFT JOIN " + RetSqlName("CC2") + " AS CC2 ON RA_ESTADO = CC2_EST AND RA_CODMUN = CC2_CODMUN "
	cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
	cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += "AND RA_SITFOLH IN ('"+SUBSTR(MV_PAR07,1,1)+"','"+SUBSTR(MV_PAR07,2,1)+"','"+SUBSTR(MV_PAR07,3,1)+"','"+SUBSTR(MV_PAR07,4,1)+"','"+SUBSTR(MV_PAR07,5,1)+"') "
	cQuery += "ORDER BY RA_FILIAL, RA_CC, RA_MAT "

ElseIf MV_PAR09 = 2
	DbSelectArea("SRA") // FUNCIONARIOS
	DbSetOrder(1)
	DbSelectArea("CTT") // CENTRO DE CUSTO
	DbSetOrder(1)
	DbSelectArea("SRB") // DEPENDENTES
	DbSetOrder(1)
	
	cQuery := "SELECT RA_FILIAL, RA_CC, CTT_DESC01, RA_MAT, RA_NOME, RA_SITFOLH, "
	cQuery += "RB_FILIAL, RB_MAT, RB_COD, RB_NOME, RB_DTNASC, RB_SEXO, RB_GRAUPAR, "
	cQuery += "RB_TPDEP "
	cQuery += "FROM " + RetSqlName("SRB") + "  AS SRB "
	cQuery += "LEFT JOIN " + RetSqlName("SRA") + " AS SRA ON RA_FILIAL = RB_FILIAL AND RA_MAT = RB_MAT "
	cQuery += "LEFT JOIN " + RetSqlName("CTT") + " AS CTT ON RA_CC = CTT_CUSTO "
	cQuery += "WHERE SRB.D_E_L_E_T_ = '' "
	cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += "AND RA_SITFOLH IN ('"+SUBSTR(MV_PAR07,1,1)+"','"+SUBSTR(MV_PAR07,2,1)+"','"+SUBSTR(MV_PAR07,3,1)+"','"+SUBSTR(MV_PAR07,4,1)+"','"+SUBSTR(MV_PAR07,5,1)+"') "
	cQuery += "ORDER BY RA_FILIAL, RA_CC, RA_MAT "

ElseIf MV_PAR09 = 3
	DbSelectArea("SRA") // FUNCIONARIOS
	DbSetOrder(1)
	DbSelectArea("CTT") // CENTRO DE CUSTO
	DbSetOrder(1)
	DbSelectArea("SR8") // AFASTAMENTOS
	DbSetOrder(1)
	
	cQuery := "SELECT RA_FILIAL, RA_CC, CTT_DESC01, RA_MAT, RA_NOME, RA_SITFOLH, "
	cQuery += "R8_FILIAL, R8_MAT, R8_SEQ, R8_DATAINI, R8_DATAFIM, R8_TIPO, "
	cQuery += "R8_TPEFD, R8_TIPOAT, R8_NMMED, R8_CRMMED, R8_UFCRM, R8_CID "
	cQuery += "FROM " + RetSqlName("SR8") + "  AS SR8 "
	cQuery += "LEFT JOIN " + RetSqlName("SRA") + " AS SRA ON RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT "
	cQuery += "LEFT JOIN " + RetSqlName("CTT") + " AS CTT ON RA_CC = CTT_CUSTO "
	cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
	cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += "AND RA_SITFOLH IN ('"+SUBSTR(MV_PAR07,1,1)+"','"+SUBSTR(MV_PAR07,2,1)+"','"+SUBSTR(MV_PAR07,3,1)+"','"+SUBSTR(MV_PAR07,4,1)+"','"+SUBSTR(MV_PAR07,5,1)+"') "
	cQuery += "AND R8_TIPO <> 'F' "
	cQuery += "ORDER BY RA_FILIAL, RA_CC, RA_MAT "

EndIf               

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

If MV_PAR09 = 1
	clinha := "" + ";" + "" + ";" + "" + ";" + "" + ";" + "CADASTRO DE FUNCIONARIOS - " + Right(GetMV("MV_FOLMES"),2) + "/" + Left(GetMV("MV_FOLMES"),4)
	fWrite(nHandle, cLinha  + cCrLf)
	
	clinha := 	"FILIAL"		+ ";" + ;
				"C.CUSTO"		+ ";" + ;
				"DESCRIÇÃO"		+ ";" + ;
				"MATRICULA"		+ ";" + ;
				"NOME"			+ ";" + ;
				"SIT.FOLHA"		+ ";" + ;
				"PAIS"			+ ";" + ;
				"UF.NASC."		+ ";" + ;
				"CÓD.MUN.NASC."	+ ";" + ;
				"MUNIC.NASC."	+ ";" + ;
				"TP"			+ ";" + ;
				"LOGRADOURO"	+ ";" + ;
				"NUMERO"		+ ";" + ;
				"COMPLEMENTO"	+ ";" + ;
				"BAIRRO"		+ ";" + ;
				"UF MUNICIPIO"	+ ";" + ;
				"CÓD.MUNICIPIO"	+ ";" + ;
				"MUNICIPIO"		+ ";" + ;
				"CEP"			+ ";" + ;
				""				+ ";"
	fWrite(nHandle, cLinha  + cCrLf)
	
	Do While !QRY1->(EOF())
		clinha := IIF (!Empty(RA_FILIAL) , "'" + AllTrim(RA_FILIAL) , + AllTrim(RA_FILIAL)) + ";"  // FILIAL
		clinha = clinha + IIF (!Empty(RA_CC) , "'" + AllTrim(RA_CC) , AllTrim(RA_CC)) + ";"  // C.CUSTO
		clinha = clinha + AllTrim(CTT_DESC01) + ";"  // DESCRIÇÃO
		clinha = clinha + IIF (!Empty(RA_MAT) , "'" + AllTrim(RA_MAT) , AllTrim(RA_MAT)) + ";"  // MATRICULA
		clinha = clinha + AllTrim(RA_NOME) + ";"  // NOME
		clinha = clinha + AllTrim(RA_SITFOLH) + ";"  // SIT.FOLHA
		clinha = clinha + IIF (!Empty(CCH_PAIS) , "'" + AllTrim(CCH_PAIS) , AllTrim(CCH_PAIS)) + ";"  // PAIS
		clinha = clinha + AllTrim(RA_NATURAL) + ";"  // UF NASC.
		clinha = clinha + AllTrim(Posicione("CC2",2,xFilial("CC2")+RA_NATURAL+RA_MUNNASC,"CC2_MUN")) + ";"  // CÓD.MUN.NASC.
		clinha = clinha + AllTrim(RA_MUNNASC) + ";"  // MUNIC.NASC.
		clinha = clinha + IIF (!Empty(RA_LOGRTP) , "'" + AllTrim(RA_LOGRTP) , AllTrim(RA_LOGRTP)) + ";"  // TP
		clinha = clinha + AllTrim(RA_LOGRDSC) + ";"  // LOGRADOURO
		clinha = clinha + AllTrim(RA_LOGRNUM) + ";"  // NUMERO
		clinha = clinha + AllTrim(RA_COMPLEM) + ";"  // COMPLEMENTO
		clinha = clinha + AllTrim(RA_BAIRRO) + ";"  // BAIRRO
		clinha = clinha + AllTrim(RA_ESTADO) + ";"  // UF MUNICIPIO
		clinha = clinha + IIF (!Empty(RA_CODMUN) , "'" + AllTrim(RA_CODMUN) , AllTrim(RA_CODMUN)) + ";"  // CÓD.MUNICIPIO
		clinha = clinha + AllTrim(CC2_MUN) + ";"  // MUNICIPIO
		clinha = clinha + IIF (!Empty(RA_CEP) , "'" + AllTrim(RA_CEP) , AllTrim(RA_CEP)) + ";"  // CEP
		fWrite(nHandle, cLinha  + cCrLf )
		Incproc()
		QRY1->(DbSkip())
	EndDo                

ElseIf MV_PAR09 = 2
	clinha := "" + ";" + "" + ";" + "" + ";" + "" + ";" + "CADASTRO DE DEPENDENTES - " + Right(GetMV("MV_FOLMES"),2) + "/" + Left(GetMV("MV_FOLMES"),4)
	fWrite(nHandle, cLinha  + cCrLf)
	
	clinha := 	"FILIAL"		+ ";" + ;
				"C.CUSTO"		+ ";" + ;
				"DESCRIÇÃO"		+ ";" + ;
				"MATRICULA"		+ ";" + ;
				"NOME"			+ ";" + ;
				"SIT.FOLHA"		+ ";" + ;
				"COD.DEP"		+ ";" + ;
				"NOME DEP"		+ ";" + ;
				"DATA NASC."	+ ";" + ;
				"SEXO"			+ ";" + ;
				"PARENTESCO"	+ ";" + ;
				"TIPO DEP."		+ ";" + ;
				""				+ ";"
	fWrite(nHandle, cLinha  + cCrLf)
	
	Do While !QRY1->(EOF())
		clinha := IIF (!Empty(RA_FILIAL) , "'" + AllTrim(RA_FILIAL) , AllTrim(RA_FILIAL)) + ";"  // FILIAL
		clinha = clinha + IIF (!Empty(RA_CC) , "'" + AllTrim(RA_CC) , AllTrim(RA_CC)) + ";"  // C.CUSTO
		clinha = clinha + AllTrim(CTT_DESC01) + ";"  // DESCRIÇÃO
		clinha = clinha + IIF (!Empty(RA_MAT) , "'" + AllTrim(RA_MAT) , AllTrim(RA_MAT)) + ";"  // MATRICULA
		clinha = clinha + AllTrim(RA_NOME) + ";"  // NOME
		clinha = clinha + AllTrim(RA_SITFOLH) + ";"  // SIT.FOLHA
		clinha = clinha + IIF (!Empty(RB_COD) , "'" + AllTrim(RB_COD) , AllTrim(RB_COD)) + ";"  // COD.DEP
		clinha = clinha + AllTrim(RB_NOME) + ";"		// NOME DEP
		clinha = clinha + StrZero(DAY(STOD(RB_DTNASC)),2) + "/" + StrZero(Month(STOD(RB_DTNASC)),2) + "/" + RIGHT(Str(Year(STOD(RB_DTNASC)),4),4) + ";"	// DATA NASC.
		clinha = clinha + AllTrim(RB_SEXO) + ";"  // SEXO

		If RB_GRAUPAR == "C"
			cGRAUPAR := "Conjuge"
			ElseIf RB_GRAUPAR == "F"
				cGRAUPAR := "Filho(a)"
			ElseIf RB_GRAUPAR == "E"
				cGRAUPAR := "Enteado(a)"
			ElseIf RB_GRAUPAR == "P"
				cGRAUPAR := "Pai/Mae"
			Else
				cGRAUPAR := "Outros"
		EndIf
		clinha = clinha + AllTrim(cGRAUPAR) + ";"  // PARENTESCO
			
		If RB_TPDEP == "01"
			cTPDEP := "Conjuge"
			ElseIf RB_TPDEP == "02"
				cTPDEP := "Filho(a)/Enteado(a), ate 21 anos"
			ElseIf RB_TPDEP == "03"
				cTPDEP := "Filho(a)/Enteado(a), Estudante, ate 24 anos"
			ElseIf RB_TPDEP == "04"
				cTPDEP := "Filho(a)/Enteado(a), Deficiente"
			ElseIf RB_TPDEP == "05"
				cTPDEP := "Irmao(a)/Neto(a)/Bisneto(a), ate 21 anos"
			ElseIf RB_TPDEP == "06"
		   		cTPDEP := "Irmao(a)/Neto(a)/Bisneto(a), Estudante, ate 24 anos"
			ElseIf RB_TPDEP == "07"
				cTPDEP := "Irmao(a)/Neto(a)/Bisneto(a), Deficiente"
			ElseIf RB_TPDEP == "08"
				cTPDEP := "Pais/Avos/Bisavos"
			ElseIf RB_TPDEP == "09"
				cTPDEP := "Filho(a) Adotivo(a), ate 21 anos"
			Else
				cTPDEP := "Pessoa Incapaz"
		EndIf
		clinha = clinha + AllTrim(cTPDEP) + ";"  // TIPO DEP.
			
		fWrite(nHandle, cLinha  + cCrLf )
		Incproc()
		QRY1->(DbSkip())
	EndDo                

ElseIf MV_PAR09 = 3
	clinha := "" + ";" + "" + ";" + "" + ";" + "" + ";" + "CADASTRO DE AFASTAMENTOS - " + Right(GetMV("MV_FOLMES"),2) + "/" + Left(GetMV("MV_FOLMES"),4)
	fWrite(nHandle, cLinha  + cCrLf)
	
	clinha := 	"FILIAL"		+ ";" + ;
				"C.CUSTO"		+ ";" + ;
				"DESCRIÇÃO"		+ ";" + ;
				"MATRICULA"		+ ";" + ;
				"NOME"			+ ";" + ;
				"SIT.FOLHA"		+ ";" + ;
				"DATA INICIO"	+ ";" + ;
				"DATA FIM"		+ ";" + ;
				"TIPO"			+ ";" + ;
				"TIPO E-SOCIAL"	+ ";" + ;
				"TIPO ACID.TRAB"+ ";" + ;
				"NOME MEDICO"	+ ";" + ;
				"CRM MEDICO"	+ ";" + ;
				"UF CRM"		+ ";" + ;
				"CID"			+ ";" + ;
				""				+ ";"
	fWrite(nHandle, cLinha  + cCrLf)
	
	Do While !QRY1->(EOF())
		clinha := IIF (!Empty(RA_FILIAL) , "'" + AllTrim(RA_FILIAL) , AllTrim(RA_FILIAL)) + ";"  // FILIAL
		clinha = clinha + IIF (!Empty(RA_CC) , "'" + AllTrim(RA_CC) , AllTrim(RA_CC)) + ";"  // C.CUSTO
		clinha = clinha + AllTrim(CTT_DESC01) + ";"  // DESCRIÇÃO
		clinha = clinha + IIF (!Empty(RA_MAT) , "'" + AllTrim(RA_MAT) , AllTrim(RA_MAT)) + ";"  // MATRICULA
		clinha = clinha + AllTrim(RA_NOME) + ";"  // NOME
		clinha = clinha + AllTrim(RA_SITFOLH) + ";"  // SIT.FOLHA
		clinha = clinha + StrZero(DAY(STOD(R8_DATAINI)),2) + "/" + StrZero(Month(STOD(R8_DATAINI)),2) + "/" + RIGHT(Str(Year(STOD(R8_DATAINI)),4),4) + ";"	// DATA INICIO
		clinha = clinha + StrZero(DAY(STOD(R8_DATAFIM)),2) + "/" + StrZero(Month(STOD(R8_DATAFIM)),2) + "/" + RIGHT(Str(Year(STOD(R8_DATAFIM)),4),4) + ";"	// DATA FIM
		clinha = clinha + AllTrim(R8_TIPO) + ";"  // TIPO
		clinha = clinha + IIF (!Empty(R8_TPEFD) , "'" + AllTrim(R8_TPEFD) , AllTrim(R8_TPEFD)) + ";"  // TIPO E-SOCIAL
		clinha = clinha + IIF (!Empty(R8_TIPOAT) , "'" + AllTrim(R8_TIPOAT) , AllTrim(R8_TIPOAT)) + ";"  // TIPO ACID.TRAB
		clinha = clinha + AllTrim(R8_NMMED) + ";"  // NOME MEDICO
		clinha = clinha + IIF (!Empty(R8_CRMMED) , "'" + AllTrim(R8_CRMMED) , AllTrim(R8_CRMMED)) + ";"  // CRM MEDICO
		clinha = clinha + AllTrim(R8_UFCRM) + ";"  // UF CRM
		clinha = clinha + IIF (!Empty(R8_CID) , "'" + AllTrim(R8_CID) , AllTrim(R8_CID)) + ";"  // CID
		fWrite(nHandle, cLinha  + cCrLf )
		Incproc()
		QRY1->(DbSkip())
	EndDo                

EndIf               

DbSelectArea("QRY1")

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
	Else
	    /*If 'C:' $ __RELDIR
	        ShellExecute( "Open" , _cArqTmp ,"", "" , 3 )           
			Else
				ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )
		EndIf*/
		ShellExecute( "Open" , _cArqTmp ,"", "" , 3 )           
EndIf
fClose(nHandle)
MsgAlert( "Arquivo Gerado!" )
Return .T.                                                    
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//CRIACAO DA PERGUNTA //
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
  AAdd(aRegs,{cPerg,"01","Filial De?        ","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
  AAdd(aRegs,{cPerg,"02","Filial Ate?       ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
  AAdd(aRegs,{cPerg,"03","Centro Custo De?  ","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"04","Centro Custo Ate? ","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"05","Matricula De?     ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"06","Matricula Ate?    ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"07","Sit.Folha?        ","","","mv_ch7","C",05,0,0,"G","fSituacao","mv_par07","","",""," ADFT","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"08","Caminho:          ","","","mv_ch8","C",70,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})
  AAdd(aRegs,{cPerg,"09","Cadastro de?      ","","","mv_ch9","N",01,0,2,"C","","mv_par09","Funcionarios","","","","","Dependentes","","","","","Afatados","","","","","","","","","","","","","","",""})

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