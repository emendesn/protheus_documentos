/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: RREAJUSTES                                                                                                                                                                   |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 30/09/2013                                                                                                                                                             |
|Descrição: Relação de Marcações Ímpares                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Priscila Freitas                                                                                                                                                       |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 28/10/2013                                                                                                                                                             |
|Motivo: Alteração do Leiaute                                                                                                                                                           |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Priscila Freitas                                                                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function RREAJUSTES()    // Relatorios\Customizados\Rel. de Reajustes (arquivo RREAJUSTES.CSV)

PRIVATE cPerg := "RREAJUSTES"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
EndIf

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath	:= GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath:= GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
Local cQry1		:= ""
Local cCrLf		:= Chr(13)+Chr(10)
Local cArquivo	:= CriaTrab(,.F.)
Local _csrvapl	:= ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp	:= lower(AllTrim(__RELDIR)+"Reajustes.csv")
Local cFilial	:= " "
Local cMat		:= " "
Local vSalAnt	:= 0.00
Local cFuncAnt	:= " "
Local cPath		:= AllTrim(GetTempPath())     
Local vSalAnt	:= 0.00
Local cFuncAnt	:= " "
nHandle			:= MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SP8") // MARCAÇÕES
DbSetOrder(1)

cQuery := "SELECT R3_FILIAL, RA_CC, R3_MAT, RA_NOME, R3_DATA, R3_TIPO, R3_VALOR, R7_FUNCAO, RJ_DESC, R7_SEQ, RA_SITFOLH "
cQuery += "FROM " + RetSqlName("SR3") + " AS SR3 "
cQuery += "LEFT JOIN " + RetSqlName("SR7") + " ON R3_FILIAL+R3_MAT+R3_DATA+R3_SEQ = R7_FILIAL+R7_MAT+R7_DATA+R7_SEQ "
cQuery += "LEFT JOIN " + RetSqlName("SRA") + " ON R3_FILIAL+R3_MAT = RA_FILIAL+RA_MAT "
cQuery += "LEFT JOIN " + RetSqlName("SRJ") + " ON R7_FUNCAO = RJ_FUNCAO "
cQuery += "WHERE SR3.D_E_L_E_T_ =  ' ' "
cQuery += "AND R3_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND R3_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND R3_FILIAL != '03' "
cQuery += "AND RA_SITFOLH != 'D' "
cQuery += "ORDER BY R3_FILIAL, RA_CC, R3_MAT, R3_DATA, R7_SEQ "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := " " + ";"
fWrite(nHandle, cLinha  + cCrLf )
clinha := "" + ";" + "" + ";" + "" + ";" + "Alterações de Salário/Função - Periodo de " + StrZero(Day(MV_PAR07),2) + "/" + StrZero(Month(MV_PAR07),2) + "/" + StrZero(Year(MV_PAR07),4) + ;
" a " + StrZero(Day(MV_PAR08),2) + "/" + StrZero(Month(MV_PAR08),2) + "/" + StrZero(Year(MV_PAR08),4) + ";" + "" + ";" + ""
fWrite(nHandle, cLinha  + cCrLf)
clinha := " " + ";"
fWrite(nHandle, cLinha  + cCrLf )


clinha := 	"FILIAL"				+ ";" + ;
			"C.CUSTO"				+ ";" + ;
			"MATRÍCULA"				+ ";" + ;
			"NOME"					+ ";" + ;
			"DATA"					+ ";" + ;
			"TIPO"					+ ";" + ;
			"SAL.ANTERIOR"			+ ";" + ;
			"SAL.POSTERIOR"			+ ";" + ;
			"FUNÇÃO ANTERIOR"		+ ";" + ;
			"FUNÇÃO POSTERIOR"		+ ";" 
fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())

	If cFilial != R3_FILIAL .AND. + cMat != R3_MAT
		cFilial	:= R3_FILIAL 
		cMat    := R3_MAT
		vSalAnt	:= 0.00
		cFuncAnt:= " "
	EndIf
	
	If R3_DATA >= DTOS(MV_PAR07) .AND. R3_DATA <= DTOS(MV_PAR08)
		clinha := AllTrim(R3_Filial) + ";"	// FILIAL
		clinha += AllTrim(Posicione("CTT",1,xFilial("CTT") + RA_CC,"CTT_DESC01")) + ";"	// C.CUSTO
		clinha += AllTrim(R3_MAT) + ";"	// MATRICULA
		clinha += AllTrim(RA_NOME) + ";" // NOME
		clinha += StrZero(DAY(STOD(R3_DATA)),2) + "/" + StrZero(Month(STOD(R3_DATA)),2) + "/" + RIGHT(Str(Year(STOD(R3_DATA)),4),4) + ";"  // DATA
		clinha += AllTrim(Posicione("SX5",1,xFilial("SX5") + "41" + R3_TIPO,"X5_DESCRI")) + ";"	// TIPO
		clinha += Transform (vSalAnt, "@E 999,999.99" ) + ";" // SAL.ANTERIOR
		clinha += Transform (R3_VALOR, "@E 999,999.99" ) + ";" // SAL.POSTERIOR
		clinha += AllTrim(Posicione("SRJ",1,xFilial("SRJ") + cFuncAnt,"RJ_DESC")) + ";"	// FUNÇÃO ANTERIOR
		clinha += AllTrim(Posicione("SRJ",1,xFilial("SRJ") + R7_FUNCAO,"RJ_DESC")) + ";" // FUNÇÃO POSTERIOR
		fWrite(nHandle, cLinha  + cCrLf )
		Incproc()
	EndIf

	vSalAnt	:= R3_VALOR
	cFuncAnt:= R7_FUNCAO
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
//  AAdd(aRegs,{cPerg,"09","Tipo De?          ","","","mv_ch9","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//  AAdd(aRegs,{cPerg,"10","Tipo Ate?         ","","","mv_cha","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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