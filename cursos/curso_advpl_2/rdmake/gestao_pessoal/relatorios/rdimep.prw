/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: rDimep                                                                                                                                                                        |
|Autor:                                                                                                                                                                                  |
|Data Aplicação: 01/04/2013                                                                                                                                                              |
|Descrição: arquivo texto para Cadastro de Funcionários conforme Leiaute DIMEP                                                                                                           |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:   /  /                                                                                                                                                                  |
|Motivo:                                                                                                                                                                                 |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function RDIMEP()    // Relatorios / Customizados / Cadastro DIMEP
PRIVATE cPerg :="RDIMEP"

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()
Local cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Local cArquivo   := alltrim(cRootPath) + alltrim(cStartPath) + alltrim(MV_PAR07)
Local cQry1      := ""
Local cDirDocs   := __RelDir
Local cCrLf      := Chr(13)+Chr(10)
Local cArquivo   := CriaTrab(,.F.)
Local cPath      := AllTrim(GetTempPath())

nHandle := MsfCreate(alltrim(MV_PAR07),0)

IF Select("QRY1") <> 0
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

cQuery := " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_DEMISSA, RA_SITFOLH, RA_CRACHA, RA_PIS, RA_CODFUNC, RA_CATFUNC  "
cQuery += " FROM " + RetSqlName("SRA") + " SRA (NOLOCK)"
cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_DEMISSA = ' ' "
//cQuery += " AND SRA.RA_CATFUNC = 'M' "
cQuery += " AND SRA.RA_FILIAL BETWEEN '"+MV_PAR01+"'  AND '"+MV_PAR02+"' "
cQuery += " AND SRA.RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND SRA.RA_ADMISSA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
cQuery += " ORDER BY RA_FILIAL,RA_MAT "

MEMOWRITE("%TMP%\TESTE.txt",cQuery)

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())

DO WHILE !QRY1->(EOF())
	clinha := StrZero(Val(Alltrim(RA_CRACHA)),20)                                                         //001 a 020 – Número do Crachá (será o código de cadastro).
	clinha = clinha + StrZero(Val(Alltrim(RA_PIS)),11)                                                    //021 a 031 – Número do PIS do funcionário
	clinha = clinha + "000000"                                                                            //032 a 037 – Senha do funcionário (preencher com 000000).
	clinha = clinha + StrZero(DAY(STOD(RA_ADMISSA)),2) + StrZero(Month(STOD(RA_ADMISSA)),2) + RIGHT(Str(Year(STOD(RA_ADMISSA)),4),4)  //038 a 045 – Data de admissão (DDMMYYYY)
	clinha = clinha + PadR(Alltrim(RA_NOME),52," ")                                                       //046 a 097 – Nome do Funcionário com 52 posições (completar com espaço)
	clinha = clinha + PadR(Alltrim(Posicione("SRJ",1,xFilial("SRJ") + RA_CODFUNC,"RJ_DESC")),30," ")      //098 a 127 – Função do Funcionário com 30 posições (completar com espaço)
	//clinha = clinha + Space(20)                                                                         //128 a 147 – Número da Credencial utilizada pelo Funcionário.
	fWrite(nHandle, cLinha  + cCrLf )
	DbSkip()
EndDo
fClose(nHandle)
MsgAlert( "Arquivo Gerado!" )
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
  AAdd(aRegs,{cPerg,"01","Filial de?        ","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"02","Filial ate?       ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"03","Matricula de?     ","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"04","Matricula ate?    ","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"05","Admissão de?      ","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"06","Admissão ate?     ","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"07","Arquivo Destino:  ","","","mv_ch7","C",70,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})
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
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------