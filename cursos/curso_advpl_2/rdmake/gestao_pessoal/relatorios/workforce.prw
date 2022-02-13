/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: xWORKF                                                                                                                                                                       |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 10/09/2012                                                                                                                                                             |
|Descrição: HC WorkForce                                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 12/11/2012                                                                                                                                                             |
|Motivo: Inclusão CELULA B, CELULA C, CELULA D e CELULA E                                                                                                                               |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 04/02/2013                                                                                                                                                             |
|Motivo: Inclusão FILIAL                                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 01/03/2013                                                                                                                                                             |
|Motivo: Inclusão DEMISSAO                                                                                                                                                              |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 08/04/2013                                                                                                                                                             |
|Motivo: Inclusão Filtro ADMISSÃO                                                                                                                                                       |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo                                                                                                                                                            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 01/07/2013                                                                                                                                                             |
|Motivo: Readequação das Celulas                                                                                                                                                        |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Cláudio Bispo                                                                                                                                                            |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function xWORKF()    // Relatorios\Customizados\HC WorkForce (arquivo WorkForce.CSV)

PRIVATE cPerg	 :="XWORKF"
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
Local cArquivo 	:= CriaTrab(,.F.)
Local _csrvapl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+"HC WorkForce.csv")
Local cPath     :=AllTrim(GetTempPath())     
nHandle         := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRA") // FUNCIONARIOS
DbSetOrder(1)

cQuery := "SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_CC AS CCUSTO, CTT_DESC01 AS DCCUSTO, RA__DEPTO AS AREA, QB_DESCRIC AS DAREA, ZK_DESCRIC AS DCELULA, RA_NOME AS NOME, RA_ADMISSA AS ADMISSAO, "
cQuery += "RA_DEMISSA AS DEMISSAO, RA_SITFOLH AS SIT_FOLHA, RA_TNOTRAB AS TURNO, R6_DESC AS DTURNO, RA_CODFUNC AS FUNCAO, RJ_DESC AS DFUNCAO FROM SRA020 AS SRA "
cQuery += "LEFT JOIN CTT020 ON RA_CC = CTT_CUSTO "
cQuery += "LEFT JOIN SQB020 ON RA__DEPTO = QB_DEPTO "
cQuery += "LEFT JOIN SR6020 ON RA_TNOTRAB = R6_TURNO "
cQuery += "LEFT JOIN SRJ020 ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "LEFT JOIN SZK020 ON RA__CELULA = ZK_CODIGO "
cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "AND (RA_ADMISSA <= '"+DtoS(LastDay(StoD(GetMV("MV_FOLMES")+"01")))+"') "
cQuery += "AND (RA_DEMISSA = '' OR RA_DEMISSA >= '"+GetMV("MV_FOLMES")+"01"+"') "
cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA__DEPTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND RA__CELULA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "AND RA_MAT BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += "ORDER BY CCUSTO, MATRICULA "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := "" + ";" + "" + ";" + "" + ";" + "" + ";" + "HC WORKFORCE - " + Right(GetMV("MV_FOLMES"),2) + "/" + Left(GetMV("MV_FOLMES"),4)
fWrite(nHandle, cLinha  + cCrLf)

clinha := 	"FIL"		+ ";" + ;
			"MATR"		+ ";" + ;
			"NOME"		+ ";" + ;
			"CC"		+ ";" + ;
			"DESCRIÇÃO"	+ ";" + ;
			"ÁREA"		+ ";" + ;
			"DESCRIÇÃO"	+ ";" + ;
			"CELULA"	+ ";" + ;
			"ADMISSÃO"	+ ";" + ;
			"SIT"		+ ";" + ;
			"DEMISSAO"	+ ";" + ;
			"TURNO"		+ ";" + ;
			"DESCRIÇÃO"	+ ";" + ;
			"FUNÇÃO"	+ ";" + ;
			"DESCRIÇÃO"	+ ";"
fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())

	clinha := AllTrim(FILIAL) + ";"                                              // FIL
	clinha = clinha + AllTrim(MATRICULA) + ";"                                   // MATR
	clinha = clinha + AllTrim(NOME) + ";"                                        // NOME
	clinha = clinha + AllTrim(CCUSTO) + ";"                                      // CC
	clinha = clinha + AllTrim(DCCUSTO) + ";"  									 // DESCRIÇÃO CENTRO DE CUSTO		
	clinha = clinha + AllTrim(AREA) + ";"                                        // ÁREA
	clinha = clinha + AllTrim(DAREA) + ";"                                       // DESCRIÇÃO ÁREA
	clinha = clinha + AllTrim(DCELULA) + ";"                                     // CELULA
	clinha = clinha + StrZero(DAY(STOD(ADMISSAO)),2) + "/" + StrZero(Month(STOD(ADMISSAO)),2) + "/" + RIGHT(Str(Year(STOD(ADMISSAO)),4),4) + ";" //ADMISSAO	
	clinha = clinha + AllTrim(SIT_FOLHA) + ";"                                   // SIT
	clinha = clinha + IIF (!Empty(DEMISSAO),StrZero(DAY(STOD(DEMISSAO)),2) + "/" + StrZero(Month(STOD(DEMISSAO)),2) + "/" + RIGHT(Str(Year(STOD(DEMISSAO)),4),4),"") + ";" //DEMISSAO	
	clinha = clinha + AllTrim(TURNO) + ";"                                       // TURNO
	clinha = clinha + AllTrim(DTURNO) + ";"     								 // DESCRIÇÃO DO TURNO
	clinha = clinha + AllTrim(FUNCAO) + ";"                                      // FUNÇÃO
	clinha = clinha + AllTrim(DFUNCAO) + ";"								     // DESCRIÇÃO FUNCAO		
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
  AAdd(aRegs,{cPerg,"05","Area De?          ","","","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SQB",""})
  AAdd(aRegs,{cPerg,"06","Area Ate?         ","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SQB",""})
  AAdd(aRegs,{cPerg,"07","Celula De?        ","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})
  AAdd(aRegs,{cPerg,"08","Celula Ate?       ","","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})
  AAdd(aRegs,{cPerg,"09","Matricula De?     ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"10","Matricula Ate?    ","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})

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