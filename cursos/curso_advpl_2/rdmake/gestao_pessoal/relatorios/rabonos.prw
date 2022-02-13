/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: rABONOS                                                                                                                                                                      |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 12/08/2013                                                                                                                                                             |
|Descrição: Relação de Marcações Ímpares                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Carina Gonçalves                                                                                                                                                         |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:   /  /2013                                                                                                                                                             |
|Motivo:                                                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Carina Gonçalves                                                                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function rABONOS()    // Relatorios\Customizados\Rel. Abonos (arquivo rAbonos.CSV)

PRIVATE cPerg := "rABONOS"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
EndIf

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
Local cQry1 	 := ""
Local cCrLf		 := Chr(13)+Chr(10)
Local cArquivo 	 := CriaTrab(,.F.)
Local _csrvapl   := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp   := lower(AllTrim(__RELDIR)+"rAbonos.csv")
Local cPath      := AllTrim(GetTempPath())     
nHandle          := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SPC") // APONTAMENTO MES
DbSetOrder(1)
DbSelectArea("SPH") // APONTAMENTO ACUMULADO
DbSetOrder(1)

cQuery := "SELECT PC_FILIAL AS FILIAL, PC_CC AS CCUSTO, PC_MAT AS MATR, RA_NOME AS NOME, PC_TURNO AS TURNO, PC_DATA AS DATA, PC_PD AS CCALCULADO, P9_DESC AS DCALCULADO, "
cQuery += "PC_QUANTC AS QCALCULADO, PC_ABONO AS CABONO, P6_DESC AS DABONO, PC_QTABONO AS QABONO, PC_USUARIO AS USUARIO FROM SPC020 AS SPC "
cQuery += "LEFT JOIN SRA020 AS SRA ON PC_FILIAL+PC_MAT = RA_FILIAL+RA_MAT "
cQuery += "LEFT JOIN SP9020 AS SP9 ON PC_PD = P9_CODIGO "
cQuery += "LEFT JOIN SP6020 AS SP6 ON PC_ABONO = P6_CODIGO "
cQuery += "WHERE SPC.D_E_L_E_T_ = ' ' "
cQuery += "AND PC_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND PC_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND PC_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND PC_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND PC_ABONO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += "AND PC_ABONO <> ' ' "
cQuery += "UNION ALL "
cQuery += "SELECT PH_FILIAL AS FILIAL, PH_CC AS CCUSTO, PH_MAT AS MATR, RA_NOME AS NOME, PH_TURNO AS TURNO, PH_DATA AS DATA, PH_PD AS CCALCULADO, P9_DESC AS DCALCULADO, "
cQuery += "PH_QUANTC AS QCALCULADO, PH_ABONO AS CABONO, P6_DESC AS DABONO, PH_QTABONO AS QABONO, PH_USUARIO AS USUARIO FROM SPH020 AS SPH "
cQuery += "LEFT JOIN SRA020 AS SRA ON PH_FILIAL+PH_MAT = RA_FILIAL+RA_MAT "
cQuery += "LEFT JOIN SP9020 AS SP9 ON PH_PD = P9_CODIGO "
cQuery += "LEFT JOIN SP6020 AS SP6 ON PH_ABONO = P6_CODIGO "
cQuery += "WHERE SPH.D_E_L_E_T_ = ' ' "
cQuery += "AND PH_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND PH_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND PH_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND PH_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND PH_ABONO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += "AND PH_ABONO <> ' ' "
cQuery += "ORDER BY FILIAL, CCUSTO, MATR, DATA "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := "" + ";" + "" + ";" + "Relação de Abonos - Periodo de " + StrZero(Day(MV_PAR07),2) + "/" + StrZero(Month(MV_PAR07),2) + "/" + StrZero(Year(MV_PAR07),4) + ;
" a " + StrZero(Day(MV_PAR08),2) + "/" + StrZero(Month(MV_PAR08),2) + "/" + StrZero(Year(MV_PAR08),4) + ";" + "" + ";" + ""
fWrite(nHandle, cLinha  + cCrLf)

clinha := 	"FILIAL"	+ ";" + ;
			"C.CUSTO"	+ ";" + ;
			"MATRICULA"	+ ";" + ;
			"NOME"		+ ";" + ;
			"TURNO"		+ ";" + ;
			"DATA"		+ ";" + ;
			"VERBA"		+ ";" + ;
			"DESCRIÇÃO"	+ ";" + ;
			"HORAS"		+ ";" + ;
			"ABONO"		+ ";" + ;
			"DESCRIÇÃO"	+ ";" + ;
			"HORAS"		+ ";" + ;
			"USUÁRIO"	+ ";"

fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())
	clinha := AllTrim(FILIAL) + ";"				// FILIAL
	clinha = clinha + AllTrim(CCUSTO) + ";"		// C.CUSTO
	clinha = clinha + AllTrim(MATR) + ";"		// MATRICULA
	clinha = clinha + AllTrim(NOME) + ";"		// NOME
	clinha = clinha + AllTrim(TURNO) + ";"		// TURNO
	clinha = clinha + StrZero(DAY(STOD(DATA)),2) + "/" + StrZero(Month(STOD(DATA)),2) + "/" + RIGHT(Str(Year(STOD(DATA)),4),4) + ";"	// DATA
	clinha = clinha + AllTrim(CCALCULADO) + ";"	// VERBA
	clinha = clinha + AllTrim(DCALCULADO) + ";"	// DESCRIÇÃO
	clinha = clinha + Alltrim(Left(Transform(QCALCULADO,"@E 999999.99"),6) + ":" + Right(StrZero(QCALCULADO,10,2),2)) + ";"	// QUANTIDADE
	clinha = clinha + AllTrim(CABONO) + ";"		// ABONO
	clinha = clinha + AllTrim(DABONO) + ";"		// DESCRIÇÃO
	clinha = clinha + Alltrim(Left(Transform(QABONO,"@E 999999.99"),6) + ":" + Right(StrZero(QABONO,10,2),2)) + ";"	// QUANTIDADE
	clinha = clinha + AllTrim(USUARIO) + ";"	// USUÁRIO
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
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
  AAdd(aRegs,{cPerg,"07","Data De?          ","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"08","Data Ate?         ","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"09","Abono De?         ","","","mv_ch9","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SP6",""})
  AAdd(aRegs,{cPerg,"10","Abono Ate?        ","","","mv_chA","C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SP6",""})

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
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function xNOMEuser(cUsuario)
Local aUsuario:= {}
aUsuario      := ALLUSERS()
//Local cUserID

PswOrder(2) // seleciona ordem de indexação

If PswSeek(cUsuario, .T.)
	cUsuario := PswRet[1,2]
Endif  

Return