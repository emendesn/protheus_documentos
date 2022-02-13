/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: rMARCIMP                                                                                                                                                                     |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 12/08/2013                                                                                                                                                             |
|Descrição: Relação de Marcações Ímpares                                                                                                                                                |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Carina Gonçalves                                                                                                                                                         |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 11/11/2013                                                                                                                                                             |
|Motivo: correção critério de P8_DATA para P8_ORDEM                                                                                                                                     |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Carina Gonçalves                                                                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function rMARCIMP()    // Relatorios\Customizados\Marc. Impares (arquivo rMarcImp.CSV)

PRIVATE cPerg := "RMARCIMP"
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
Local _cArqTmp   := lower(AllTrim(__RELDIR)+"rMarcImp.csv")
Local cPath      := AllTrim(GetTempPath())     
nHandle          := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SP8") // MARCAÇÕES
DbSetOrder(1)

cQuery := "SELECT P8_FILIAL, RA_CC, P8_MAT, RA_NOME, COUNT(P8_ORDEM) MARCACOES FROM " + RetSqlName("SP8") + " AS SP8 "
cQuery += "LEFT JOIN " + RetSqlName("SRA") + " AS SRA ON P8_FILIAL+P8_MAT = RA_FILIAL+RA_MAT "
cQuery += "WHERE SP8.D_E_L_E_T_ = ' ' "
cQuery += "AND P8_FLAG != 'A' "
cQuery += "AND P8_TPMCREP = ' ' "
cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND P8_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "GROUP BY P8_FILIAL, RA_CC, P8_MAT, RA_NOME, P8_ORDEM "
cQuery += "HAVING COUNT (P8_ORDEM) IN ('1','3','5','7','9','11','13','15','17','19','21','23','25','27','29','31','33','35','37','39') "
cQuery += "ORDER BY P8_FILIAL, RA_CC, P8_MAT, P8_ORDEM "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := "" + ";" + "" + ";" + "Marcações Ímpares" + ";" + "" + ";" + ""
fWrite(nHandle, cLinha  + cCrLf)

clinha := 	"FILIAL"	+ ";" + ;
			"MATRICULA"	+ ";" + ;
			"NOME"		+ ";" + ;
			"C.CUSTO"	+ ";" + ;
			"MARCAÇÕES"	+ ";"
fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())
	clinha := AllTrim(P8_FILIAL) + ";"			// FILIAL
	clinha = clinha + AllTrim(P8_MAT) + ";"		// MATRICULA
	clinha = clinha + AllTrim(RA_NOME) + ";"	// NOME
	clinha = clinha + AllTrim(RA_CC) + ";"		// C.CUSTO
	clinha = clinha + Transform (MARCACOES, "@E 999,999" ) + ";"	// MARCAÇÕES
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