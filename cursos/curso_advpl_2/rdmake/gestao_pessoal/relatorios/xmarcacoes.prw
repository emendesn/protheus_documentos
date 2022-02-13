/*--------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: xMarcAlt                                                                                                                                       |
|Autor:                                                                                                                                                   |
|Data Aplicação: 09/2011                                                                                                                                  |
|Descrição: Relação de Marcações Alteradas Manualmente                                                                                                    |      |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração:   /  /2011                                                                                                                               |
|Motivo:                                                                                                                                                  |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Luciana Benicio de Souza                                                                                                                   |
+--------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch" 
//------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function xMarcAlt()    // PONTO ELETRÔNICO Relatorios\Customizados\Marcações Alteradas
PRIVATE cPerg	 :="xMarcAlt"
ValidPerg(cPerg) 

If ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     
//------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function MyRel()                 
Local cQry1 :=""
Local cCrLf:=Chr(13)+Chr(10)
Local cMesAnoRef
Local dInicio := mv_par01
Local dFim := mv_par02
Local dDtPesqAf
//	Local aTotCC  := {}
Local aTotMAT := {}	
Local yy := 0
Local cTipAfas    := " "
Local aXAfast := {}
Local nTur
Local nAfasta := nFerias := 0
//
//	Local cArquivo := CriaTrab(,.F.)
Local _csrvapl := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp := lower(AllTrim(__RELDIR)+"MARCACOES ALTERADAS.CSV")
	
dDataRef := mv_par01      
//	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
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
Private axFalta    :={}
//	Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)
//	dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
	

u_GerA0003(ProcName())

nHandle := MsfCreate(_cArqTmp,0)
//------------------------------------------------------------------------------------------------------------------------------------------------------------
cLinha := "RELAÇÃO DE MARCAÇÕES ALTERADAS MANUALMENTE. PERÍODO DE " + StrZero(Day(MV_PAR07),2) + "/" + StrZero(Month(MV_PAR07),2) + "/" + StrZero(Year(MV_PAR07),4) + " A " + StrZero(Day(MV_PAR08),2) + "/" + StrZero(Month(MV_PAR08),2) + "/" + StrZero(Year(MV_PAR08),4)
fWrite(nHandle, cLinha  + cCrLf)
cLinha := ' '                   
fWrite(nHandle, cLinha  + cCrLf)
//------------------------------------------------------------------------------------------------------------------------------------------------------------	
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

cLinha := Posicione("CTT",1, xFilial("CTT") + SRA->RA_CC,"CTT_DESC01") + ';'  // CENTRO DE CUSTO
clinha = clinha + posicione("SQB",1,xfilial("SQB")+SRA->RA__DEPTO,"QB_DESCRIC") + ";"  //DESCRIÇÃO DA AREA		
cLinha = clinha + SRA->RA_NOME + ';' + ';'  // NOME
cLinha = clinha + Posicione("SR6",1,xFilial("SR6")+SRA->RA_TNOTRAB,"R6_DESC")  + ';'  // TURNO
cLinha = clinha + Posicione("SPA",1,xFilial("SPA")+SRA->RA_REGRA,"PA_DESC")  + ';'  // REGRA
	
cQuery := " SELECT RA_CC, RA__DEPTO, RA_NOME, RA_TNOTRAB, RA_REGRA, P8_FILIAL, P8_MAT, P8_DATA, P8_HORA, P8_CC,  P8_TIPOREG, P8_MOTIVRG, P8_DATAALT, P8_HORAALT, P8_USUARIO FROM SP8020 AS SP8 "
cQuery += " INNER JOIN SRA020 ON P8_FILIAL = RA_FILIAL AND P8_MAT = RA_MAT "
cQuery += " WHERE SP8.D_E_L_E_T_ = '' "
cQuery += " AND RA_REGRA <> '03' "
cQuery += " AND SP8.P8_MOTIVRG  <> '' "
cQuery += " AND SP8.P8_MOTIVRG NOT LIKE '%AUTOMATIC%' "
cQuery += " AND SP8.P8_FILIAL = '02' "
cQuery += " AND SP8.P8_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND SP8.P8_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND SP8.P8_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += " UNION ALL "
cQuery += " SELECT RA_CC, RA__DEPTO, RA_NOME, RA_TNOTRAB, RA_REGRA, PG_FILIAL, PG_MAT, PG_DATA, PG_HORA, PG_CC,  PG_TIPOREG, PG_MOTIVRG, PG_DATAALT, PG_HORAALT, PG_USUARIO FROM SPG020 AS SPG "
cQuery += " INNER JOIN SRA020 ON PG_FILIAL = RA_FILIAL AND PG_MAT = RA_MAT "
cQuery += " WHERE SPG.D_E_L_E_T_ = '' "
cQuery += " AND RA_REGRA <> '03' "
cQuery += " AND SPG.PG_MOTIVRG  <> '' "
cQuery += " AND SPG.PG_MOTIVRG NOT LIKE '%AUTOMATIC%' "
cQuery += " AND SPG.PG_FILIAL = '02' "
cQuery += " AND SPG.PG_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND SPG.PG_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND SPG.PG_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += " ORDER BY P8_CC, P8_MAT, P8_DATA, P8_HORA "

MEMOWRITE("C:\TESTE.txt",cQuery)
		
TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())   

//cSRAmat := ""
//------------------------------------------------------------------------------------------------------------------------------------------------------------
DO WHILE !QRY1->(EOF())

	DbSelectArea("SRA") // FUNCIONARIOS
	DbSetOrder(1)
	DbSeek(xFilial("SRA") + QRY1->P8_MAT)

	cLinha := Posicione("CTT",1, xFilial("CTT") + SRA->RA_CC,"CTT_DESC01") + ';'  // CENTRO DE CUSTO
	clinha = clinha + posicione("SQB",1,xfilial("SQB")+SRA->RA__DEPTO,"QB_DESCRIC") + ";"  //DESCRIÇÃO DA AREA		
	cLinha = clinha + SRA->RA_NOME + ';' + ';'  // NOME
	cLinha = clinha + Posicione("SR6",1,xFilial("SR6")+SRA->RA_TNOTRAB,"R6_DESC")  + ';'  // TURNO
	cLinha = clinha + Posicione("SPA",1,xFilial("SPA")+SRA->RA_REGRA,"PA_DESC")  + ';'  // REGRA
	fWrite(nHandle, cLinha  + cCrLf )
	IncProc()

	clinha := "" + ';' +"DATA MARCAÇÃO" + ';' + "HORA MARCAÇÃO" + ';' + "MOTIVO ALTERAÇÃO" + ';' + "QUEM ALTEROU" + ';' + "DATA ALTERAÇÃO"
	fWrite(nHandle, cLinha  + cCrLf )
	IncProc()		                          	

	cSRAmat := QRY1->P8_MAT

	Do While cSRAmat == QRY1->P8_MAT
		cLinha := "" + ';' + StrZero(DAY(STOD(QRY1->P8_DATA)),2) +"/"+ StrZero(Month(STOD(QRY1->P8_DATA)),2) +"/"+ StrZero(Year(STOD(QRY1->P8_DATA)),4) + ';'  // DATA MARCAÇÃO
		clinha = clinha + StrZero(Val(Left(Transform(QRY1->P8_HORA,"99.99"),2)),2) + ":" + StrZero(Val(Right(Alltrim(Transform(QRY1->P8_HORA,"999.99")),2)),2) + ";"  //HORA MARCAÇÃO
		cLinha = clinha + QRY1->P8_MOTIVRG + ';'  // MOTIVO ALTERAÇÃO
//		cNOMEuser := U_xNOMEuser(QRY1->P8_USUARIO)
//		cLinha = clinha + cNOMEuser  + ';'  // USUÁRIO

		cNameUser := ""
		If QRY1->P8_USUARIO == "000872    "
			cNameUser := "Filipe Sartorato"
			ElseIf QRY1->P8_USUARIO == "000580    "
				cNameUser := "Ariane das Dores Alexandrino"
			ElseIf QRY1->P8_USUARIO == "000561    "
				cNameUser := "Luciana Benicio de Souza"
			ElseIf QRY1->P8_USUARIO == "000354    "
				cNameUser := "Claudio Mauricio Bispo"
		EndIf

		cLinha = clinha + cNameUser  + ';'  // USUÁRIO
		cLinha = clinha + StrZero(DAY(STOD(QRY1->P8_DATAALT)),2) +"/"+ StrZero(Month(STOD(QRY1->P8_DATAALT)),2) +"/"+ StrZero(Year(STOD(QRY1->P8_DATAALT)),4) + ';'  // DATA ALTERAÇÃO
		cSRAmat := QRY1->P8_MAT
		fWrite(nHandle, cLinha  + cCrLf )
		IncProc()
		QRY1->(DbSkip())
	EndDO

EndDo 
//------------------------------------------------------------------------------------------------------------------------------------------------------------
DbSelectArea("QRY1")

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado')
	Return
Else
    ShellExecute( "Open" , "\\"+_csrvapl+_cArqTmp ,"", "" , 3 )           
EndIf

fClose(nHandle)
MsgAlert( "Arquivo Gerado !" )
Return .T.                                                    
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
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
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function ValidPerg() //CRIACAO DA PERGUNTA
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
  AAdd(aRegs,{cPerg,"01","Filial de?"        ,""  ,""  ,"mv_ch1"  ,"C"  ,02  ,0  ,0  ,"G"  ,""  ,"MV_PAR01"  ,"","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"02","Filial ate?"       ,""  ,""  ,"mv_ch2"  ,"C"  ,02  ,0  ,0  ,"G"  ,""  ,"MV_PAR02"  ,"","","","","","","","","","","","","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg,"03","Centro Custo de?"  ,""  ,""  ,"mv_ch3"  ,"C"  ,09  ,0  ,0  ,"G"  ,""  ,"mv_par03"  ,"","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"04","Centro Custo ate?" ,""  ,""  ,"mv_ch4"  ,"C"  ,09  ,0  ,0  ,"G"  ,""  ,"mv_par04"  ,"","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"05","Matricula De?"     ,""  ,""  ,"mv_ch5"  ,"C"  ,06  ,0  ,0  ,"G"  ,""  ,"mv_par05"  ,"","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"06","Matricula Ate?"    ,""  ,""  ,"mv_ch6"  ,"C"  ,06  ,0  ,0  ,"G"  ,""  ,"mv_par06"  ,"","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"07","Periodo de:"       ,""  ,""  ,"mv_ch7"  ,"D"  ,08  ,0  ,0  ,"G"  ,""  ,"mv_par07"  ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
  AAdd(aRegs,{cPerg,"08","Periodo ate?"      ,""  ,""  ,"mv_ch8"  ,"D"  ,08  ,0  ,0  ,"G"  ,""  ,"mv_par08"  ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
//------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function xNOMEuser(cUsuario)
//Local aUsuario:= {}
//aUsuario      := ALLUSERS()

//Local cUserID
PswOrder(2)// seleciona ordem de indexação

If PswSeek(cUsuario, .T.)
	cUsuario := PswRet[1,2]
Endif  

Return