/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: rFUNCION                                                                                                                                                                     |
|Autor: Ronaldo Silva                                                                                                                                                                   |
|Data Aplicação: 12/2013                                                                                                                                                                |
|Descrição: Relação de Funcionários                                                                                                                                                     |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Viviane / Daniela                                                                                                                                                        |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:   /  /                                                                                                                                                                 |
|Motivo:                                                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por:                                                                                                                                                                          |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function rFUNCION()    // Relatorios\Customizados\Rel.Func (arquivo Rel.Funcionarios.CSV)

PRIVATE cPerg := "rFUNCION"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
EndIf

Processa( { || MyRel() } )
Return .t.

Static Function MyRel()
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Local cQry1      := ""
Local cCrLf      := Chr(13)+Chr(10)
Local cArquivo 	 := CriaTrab(,.F.)
Local _csrvapl   := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp   := lower(AllTrim(__RELDIR)+"Rel.Funcionarios.csv")
Local cPath      := AllTrim(GetTempPath())
nHandle          := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRA") // FUNCIONARIOS
DbSetOrder(1)

cQuery := "SELECT RA_MAT, RA_NOME, RA_CC, CTT_DESC01, RA__CELULA, ZK_DESCRIC, RA_ADMISSA, RA_DEMISSA, RA_SITFOLH, RA_SALARIO, RA_CODFUNC, RJ_DESC, RA_TNOTRAB, R6_DESC, "
cQuery += "RA_RESCRAI, RA_TPDEFFI, RA_SEXO, RA_FILIAL, RA_NASC, RA_DDDFONE, RA_TELEFON, RA_DDDCELU, RA_NUMCELU, RA_RG, RA_CIC, RA_VCTEXP2 "
cQuery += "FROM "+ RetSqlName("SRA") +" AS SRA "
cQuery += "LEFT JOIN "+ RetSqlName("CTT") +" AS CTT ON RA_CC = CTT_CUSTO "
cQuery += "LEFT JOIN "+ RetSqlName("SRJ") +" AS SRJ ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "LEFT JOIN "+ RetSqlName("SR6") +" AS SR6 ON RA_TNOTRAB = R6_TURNO "
cQuery += "LEFT JOIN "+ RetSqlName("SZK") +" AS SZK ON RA__CELULA = ZK_CODIGO "
cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA__CELULA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += ;
+IIF (MV_PAR07 == ('****T'),; 
 "AND RA_SITFOLH = 'D' AND RA_RESCRAI = '31' ",;
IIF (SUBSTR(MV_PAR07,5,1) == 'T',;
 "AND RA_SITFOLH IN ('"+SUBSTR(MV_PAR07,1,1)+"','"+SUBSTR(MV_PAR07,2,1)+"','D','"+SUBSTR(MV_PAR07,4,1)+"') ",;
 "AND RA_SITFOLH IN ('"+SUBSTR(MV_PAR07,1,1)+"','"+SUBSTR(MV_PAR07,2,1)+"','"+SUBSTR(MV_PAR07,3,1)+"','"+SUBSTR(MV_PAR07,4,1)+"') AND RA_RESCRAI <> '31' "))
cQuery += "AND RA_MAT BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
cQuery += "ORDER BY RA_FILIAL, RA_MAT "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := "" + ";" + "RELAÇÃO DE FUNCIONÁRIOS" + ";" + StrZero(DAY(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ right(Str(Year(dDataBase),4),4)
fWrite(nHandle, cLinha  + cCrLf)

clinha := 	"MATRICULA"		+ ";" + ;
			"NOME"			+ ";" + ;
			"C.CUSTO"		+ ";" + ;
			"DESCRIÇÃO"		+ ";" + ;
			"CÉLULA"		+ ";" + ;
			"DESCRIÇÃO"		+ ";" + ;
			"ADMISSÃO"		+ ";" + ;
			"DEMISSÃO"		+ ";" + ;
			"SIT.FOLHA"		+ ";" + ;
			"SALÁRIO"		+ ";" + ;
			"FUNÇÃO"		+ ";" + ;
			"DESCRIÇÃO"		+ ";" + ;
			"TURNO"			+ ";" + ;
			"DESCRIÇÃO"		+ ";" + ;
			"RESCISÃO RAIS"	+ ";" + ;
			"DEFICIÊNCIA"	+ ";" + ;
			"SEXO"			+ ";" + ;
			"FILIAL"		+ ";" + ;
			"NASCIMENTO"	+ ";" + ;
			"TELEFONE"		+ ";" + ;
			"CELULAR"		+ ";" + ;
			"RG"			+ ";" + ;
			"CPF"			+ ";" + ;
			"EXPERIÊNCIA"	+ ";" 

fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())
	cDefic  := " "
	cFilFun := " "
	clinha := AllTrim(RA_MAT) + ";"										// MATRICULA
	clinha += AllTrim(RA_NOME) + ";"									// NOME
	clinha += AllTrim(RA_CC) + ";"										// C.CCUSTO
	clinha += AllTrim(CTT_DESC01) + ";"									// DESCRIÇÃO CENTRO DE CUSTO
	clinha += AllTrim(RA__CELULA) + ";"									// CÉLULA
	clinha += AllTrim(ZK_DESCRIC) + ";"									// DESCRIÇÃO
	clinha += StrZero(DAY(STOD(RA_ADMISSA)),2) + "/" + StrZero(Month(STOD(RA_ADMISSA)),2) + "/" + RIGHT(Str(Year(STOD(RA_ADMISSA)),4),4) + ";" //ADMISSÃO
	clinha += IIF (!Empty(RA_DEMISSA),StrZero(DAY(STOD(RA_DEMISSA)),2) + "/" + StrZero(Month(STOD(RA_DEMISSA)),2) + "/" + RIGHT(Str(Year(STOD(RA_DEMISSA)),4),4),"") + ";" //DEMISSÃO
	clinha += AllTrim(RA_SITFOLH) + ";"									// SIT.FOLHA
	cLinha += TRANSFORM(RA_SALARIO,'@E 9,999,999.99') + ";"				// SALÁRIO
	clinha += AllTrim(RA_CODFUNC) + ";"									// FUNÇÃO
	clinha += AllTrim(RJ_DESC) + ";"									// DESCRIÇÃO FUNÇÃO
	clinha += AllTrim(RA_TNOTRAB) + ";"									// TURNO
	clinha += AllTrim(R6_DESC) + ";"									// DESCRIÇÃO TURNO
	clinha += AllTrim(Posicione("SX5",1,xFilial("SX5") + "27" + RA_RESCRAI,"X5_DESCRI")) + ";"	// RESCISÃO RAIS
	
	IIF(RA_TPDEFFI=="1",cDefic:="FÍSICA",IIF(RA_TPDEFFI=="2",cDefic:="AUDITIVA",IIF(RA_TPDEFFI=="3",cDefic:="VISUAL", ;
	IIF(RA_TPDEFFI=="4",cDefic:="INTELECTUAL",IIF(RA_TPDEFFI=="5",cDefic:="MULTIPLA",IIF(RA_TPDEFFI=="6",cDefic:="REABILITADO"," "))))))
	
	clinha += cDefic + ";"										// DEFICIÊNCIA
	clinha += AllTrim(RA_SEXO) + ";"									// SEXO

 	IIF(RA_FILIAL=="02",cFilFun:="MATRIZ",IIF(RA_FILIAL=="03",cFilFun:="TEMPORARIO",IIF(RA_FILIAL=="06",cFilFun:="OSASCO",IIF(RA_FILIAL=="07",cFilFun:="ELDORADO",cFilFun:=RA_FILIAL))))
	clinha += cFilFun + ";"									// FILIAL
	clinha += StrZero(DAY(STOD(RA_NASC)),2) + "/" + StrZero(Month(STOD(RA_NASC)),2) + "/" + RIGHT(Str(Year(STOD(RA_NASC)),4),4) + ";" //NASCIMENTO
	clinha += IIF (!Empty(RA_TELEFON),AllTrim(RA_DDDFONE + " " + RA_TELEFON), "") + ";"	// TELEFONE
	clinha += IIF (!Empty(RA_NUMCELU),AllTrim(RA_DDDCELU + " " + RA_NUMCELU), "") + ";"	// CELULAR
	clinha += AllTrim(RA_RG) + ";"										// RG
	clinha += AllTrim(TRANSFORM(RA_CIC,'@R 999.999.999-99')) + ";"		// CPF
	clinha += IIF (!Empty(RA_VCTEXP2),StrZero(DAY(STOD(RA_VCTEXP2)),2) + "/" + StrZero(Month(STOD(RA_VCTEXP2)),2) + "/" + RIGHT(Str(Year(STOD(RA_VCTEXP2)),4),4),"") + ";" //EXPERIÊNCIA
	fWrite(nHandle, cLinha  + cCrLf )
	Incproc()
	QRY1->(DbSkip())
EndDo

DbSelectArea("QRY1")

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
Else
	If 'C:' $ __RELDIR
		ShellExecute( "Open" , _cArqTmp ,"", "" , 3 )
	Else
		ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )
	EndIf
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
AAdd(aRegs,{cPerg,"05","Celula De?        ","","","mv_ch5","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SZK_01",""})
AAdd(aRegs,{cPerg,"06","Celula Ate?       ","","","mv_ch6","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SZK_01",""})
AAdd(aRegs,{cPerg,"07","Sit.Folha?        ","","","mv_ch7","C",05,0,0,"G","fSituacao","mv_par07","","",""," ADFT","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"08","Matricula De?     ","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
AAdd(aRegs,{cPerg,"09","Matricula Ate?    ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})

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
