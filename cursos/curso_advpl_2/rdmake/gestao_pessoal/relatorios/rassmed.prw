/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: rAssMed                                                                                                                                                                      |
|Autor:                                                                                                                                                                                 |
|Data Aplicação: 28/01/2013                                                                                                                                                             |
|Descrição: Relação de Funcionários para Cadastrar Assistência Médica                                                                                                                   |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Claudio Bispo e Luciana Benicio                                                                                                                                          |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 01/07/2013                                                                                                                                                             |
|Motivo: Readequação das Celulas                                                                                                                                                        |
|Resposável: Anadi                                                                                                                                                                      |
|Validado por: Luciana                                                                                                                                                                  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function rAssMed()    // Relatorios\Customizados\Inc.Ass.Medica (arquivo rAssMed.csv)

PRIVATE cPerg	 :="RASSMED"
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
 Return()
EndIf

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )    
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() ) 
lOCAL cMatr := ""
Local cQry1 :=""
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo 	:= CriaTrab(,.F.)
Local _cSrvApl  := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+"IncAssMed.csv")
Local cPath     := AllTrim(GetTempPath())     
nHandle         := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRA") // FUNCIONARIOS
DbSetOrder(1)

cQuery := "SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_CC AS CCUSTO, CTT_DESC01 AS DCCUSTO, ZK_DESCRIC AS CELULA, R6_DESC AS TURNO, RA_NOME AS NOME, RA_ADMISSA AS ADMISSAO, RJ_DESC AS FUNCAO, RA_DEMISSA AS DEMISSAO, RB_COD AS SEQ, RB_NOME AS DEPENDENTE, RB_DTNASC AS NASCIMENTO, RB_GRAUPAR AS PARENTESCO FROM SRA020 AS SRA "
cQuery += "LEFT JOIN SRB020 ON RB_FILIAL = RA_FILIAL AND RB_MAT = RA_MAT "
cQuery += "LEFT JOIN SZK020 ON RA__CELULA = ZK_CODIGO "
cQuery += "LEFT JOIN CTT020 ON RA_CC = CTT_CUSTO "
cQuery += "LEFT JOIN SR6020 ON RA_TNOTRAB = R6_TURNO "
cQuery += "LEFT JOIN SRJ020 ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "AND RA_CATFUNC = 'M' "
cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA__CELULA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND RA_TNOTRAB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "AND RA_MAT BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += "AND DATEADD(DAY,120,RA_ADMISSA) BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' "
cQuery += "AND (RA_DEMISSA = '' OR RA_DEMISSA >= '"+DTOS(MV_PAR11)+"') "
cQuery += "ORDER BY FILIAL, MATRICULA "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha :=    ""                  + ";" + ;
             ""                  + ";" + ;
             "FUNCIONÁRIOS PARA INCLUSÃO ASSISTÊNCIA MÉDICA" + ";" + ;
             StrZero(DAY(MV_PAR11),2) + "/" + StrZero(Month(MV_PAR11),2) + "/" + RIGHT(Str(Year(MV_PAR11),4),4) + ";" + ;
             StrZero(DAY(MV_PAR12),2) + "/" + StrZero(Month(MV_PAR12),2) + "/" + RIGHT(Str(Year(MV_PAR12),4),4) + ";"
fWrite(nHandle, cLinha  + cCrLf)

clinha := 	"FILIAL"              + ";" + ;
			"MATRÍCULA"           + ";" + ;
			"NOME"                + ";" + ;
			"CÓD.C.CUSTO"         + ";" + ;
			"DESC.C.CUSTO"        + ";" + ;
			"CELULA"              + ";" + ;
			"DESC. TURNO"         + ";" + ;
			"ADMISSÃO"            + ";" + ;
			"DESC. FUNÇÃO"        + ";" + ;
			"INCLUSAO ASS.MÉDICA" + ";"
fWrite(nHandle, cLinha  + cCrLf)

Do While !QRY1->(EOF())

	If cMatr <> MATRICULA
	cMatr := MATRICULA
	clinha := AllTrim(FILIAL) + ";"                                              // FILIAL
	clinha = clinha + AllTrim(MATRICULA) + ";"                                   // MATRÍCULA
	clinha = clinha + AllTrim(NOME) + ";"                                        // NOME
	clinha = clinha + AllTrim(CCUSTO) + ";"                                      // CÓD.C.CUSTO
	clinha = clinha + AllTrim(DCCUSTO) + ";" 									 // DESC.C.CUSTO
	clinha = clinha + AllTrim(CELULA) + ";" 									 // CELULA
	clinha = clinha + AllTrim(TURNO) + ";"     									 // DESC. TURNO
	clinha = clinha + StrZero(DAY(STOD(ADMISSAO)),2) + "/" + StrZero(Month(STOD(ADMISSAO)),2) + "/" + RIGHT(Str(Year(STOD(ADMISSAO)),4),4) + ";" //ADMISSÃO	
	clinha = clinha + AllTrim(FUNCAO) + ";"    									 // DESC. FUNCAO		
	clinha = clinha + StrZero(DAY(STOD(ADMISSAO)+120),2) + "/" + StrZero(Month(STOD(ADMISSAO)+120),2) + "/" + RIGHT(Str(Year(STOD(ADMISSAO)+120),4),4) + ";" //INCLUSAO ASS.MÉDICA
	fWrite(nHandle, cLinha  + cCrLf )
	EndIf
	If cMatr == MATRICULA .AND. SEQ >= "01"
		clinha := "" + ";"                                                       // FILIAL
		clinha = clinha + AllTrim(SEQ) + ";"                                     // SEQ
		clinha = clinha + AllTrim(DEPENDENTE) + ";"                              // DEPENDENTE
		clinha = clinha + StrZero(DAY(STOD(NASCIMENTO)),2) + "/" + StrZero(Month(STOD(NASCIMENTO)),2) + "/" + RIGHT(Str(Year(STOD(NASCIMENTO)),4),4) + ";" //NASCIMENTO
		clinha = clinha + AllTrim(PARENTESCO) + ";"                              // PARENTESCO
		fWrite(nHandle, cLinha  + cCrLf )
		Incproc()
//		QRY1->(DbSkip())
//		cMatr := MATRICULA
	EndIf
//	Incproc()
	QRY1->(DbSkip())
EndDo

DbSelectArea("QRY1")

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
Else
    if 'C:' $ __RELDIR
        ShellExecute( "Open" , _cArqTmp ,"", "" , 3 )           
	else
		ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )
	endif       
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
  AAdd(aRegs,{cPerg,"01","Filial De?         ","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"02","Filial Ate?        ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"03","Centro Custo De?   ","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"04","Centro Custo Ate?  ","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"05","Celula De?         ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})
  AAdd(aRegs,{cPerg,"06","Celula Ate?        ","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZK",""})
  aAdd(aRegs,{cPerg,"07","Turno De?          ","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})
  aAdd(aRegs,{cPerg,"08","Turno Ate?         ","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})
  AAdd(aRegs,{cPerg,"09","Matricula De?      ","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"10","Matricula Ate?     ","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  aAdd(aRegs,{cPerg,"11","Inc.Ass.Médica De? ","","","mv_chb","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"12","Inc.Ass.Médica Ate?","","","mv_chc","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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