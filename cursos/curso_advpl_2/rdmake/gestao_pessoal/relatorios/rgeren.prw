/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: RGEREN                                                                                                                                                                        |
|Autor:                                                                                                                                                                                  |
|Data Aplicação:                                                                                                                                                                         |
|Descrição: relatorio CONTROLE DE PESSOAL E FOLHA DE PAGAMENTO                                                                                                                           |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 01/12/2010 20:00                                                                                                                                                        |
|Motivo: A pedido da Luciana, inclusão dos campos "QUANTIDADE FALTA+ATRASO" e "VALOR FALTA+ATRASO"                                                                                       |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 16/02/2011 20:30                                                                                                                                                        |
|Motivo: A pedido da Andreia, inclusão do campo "PREMIO"                                                                                                                                 |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 09/03/2011                                                                                                                                                              |
|Motivo: A pedido da Luciana, exclusão do campo "PREMIO" e correção ortografia colunas QUATIDADE HORA EXTRA e QUATIDADE FALTA+ATRASO                                                     |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 03/09/2012                                                                                                                                                              |
|Motivo: A pedido da Luciana, inclusão dos campos "V.R. EMPRESA", "V.T. EMPRESA" e "ASS.MEDICA EMPRESA"                                                                                  |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 24/09/2012                                                                                                                                                              |
|Motivo: Convertido para Excel                                                                                                                                                           |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 15/07/2013                                                                                                                                                              |
|Motivo: Correção de Duplicidade por conta das Transferências                                                                                                                            |
|Resposável: ANADI                                                                                                                                                                       |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                                                  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function RGEREN			//(menu Relatorios\Customizados\Contr Pessoal e FoPag

PRIVATE cPerg	 :="RGEREN"
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
Local _cArqTmp   := lower(AllTrim(__RELDIR)+"RGEREN.csv")
Local cPath      := AllTrim(GetTempPath())
nHandle          := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRA") // FUNCIONARIOS
DbSetOrder(1)

cQuery := "SELECT RA_FILIAL, RA_MAT, RA_CC, RA_NOME, RA_ADMISSA, RA_CODFUNC, RA_SALARIO, RA_DEMISSA, RA_SITFOLH, RA_AFASFGT, RF_DATAINI, RF_DFEPRO1 FROM SRA020 AS SRA "
cQuery += "LEFT JOIN SRF020 ON RA_FILIAL = RF_FILIAL AND RA_MAT = RF_MAT "
cQuery += "WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "AND NOT SRA.RA_AFASFGT = '5' "
cQuery += "AND RA_CC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA_ADMISSA <= '"+dtos(lastday(stod(MV_PAR05+"01")))+"' "
cQuery += "AND (RA_DEMISSA = '' OR RA_DEMISSA >= '"+MV_PAR05+"01"+"') "
cQuery += "ORDER BY RA_CC, RA_NOME "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")
procregua(reccount())
QRY1->(DBGOTOP())

clinha := "CONTROLE DE PESSOAL E FOLHA DE PAGAMENTO. MES " + right(MV_PAR05,2) + "/" + left(MV_PAR05,4)
fWrite(nHandle, cLinha  + cCrLf)
cCCUSTO := ""

Do While !QRY1->(EOF())

	If cCCUSTO != QRY1->RA_CC

		clinha := AllTrim(QRY1->RA_CC) + ": " + AllTrim(Posicione("CTT",1,"  "+QRY1->RA_CC,"CTT_DESC01")) + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";" + ";" + ";" + ";" + "PROGRAMAÇÃO DE FÉRIAS"
		fWrite(nHandle, cLinha  + cCrLf)

		clinha := 	"MATRÍCULA"                 + ";" + ;
					"NOME"                      + ";" + ;
					"ADMISSÃO"                  + ";" + ;
					"FUNÇÃO"                    + ";" + ;
					"DESCRIÇÃO"                 + ";" + ;
					"ÚLTIMA ALT.SALÁRIO"        + ";" + ;
					"SALÁRIO ATUAL"             + ";" + ;
					"QTDE HORAS EXTRAS"         + ";" + ;
					"QTDE DSR"                  + ";" + ;
					"VALOR HE+DSR"              + ";" + ;
					"QTDE FALTA+ATRASO"         + ";" + ;
					"VALOR FALTA+ATRASO"        + ";" + ;
					"V.R. EMPRESA"              + ";" + ;
					"V.T. EMPRESA"              + ";" + ;
					"ASS.MÉDICA EMPRESA"        + ";" + ;
					"DATA FÉRIAS"               + ";" + ;
					"DIAS FÉRIAS"               + ";" 
		fWrite(nHandle, cLinha  + cCrLf)

	EndIf
	clinha := AllTrim(QRY1->RA_MAT) + ";"                                                          // MATRÍCULA
	clinha = clinha + AllTrim(QRY1->RA_NOME) + ";"                                                 // NOME
	clinha = clinha + StrZero(DAY(STOD(QRY1->RA_ADMISSA)),2) + "/" + StrZero(Month(STOD(QRY1->RA_ADMISSA)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RA_ADMISSA)),4),4) + ";" //ADMISSAO
	clinha = clinha + AllTrim(QRY1->RA_CODFUNC) + ";"                                              // FUNÇÃO
	clinha = clinha + AllTrim(Posicione("SRJ",1,"  "+QRY1->RA_CODFUNC,"RJ_DESC")) + ";"            // DESCRIÇÃO FUNCAO
	clinha = clinha + "" + ";"                                                                     // ÚLTIMA ALT.SALÁRIO
	clinha = clinha + AllTrim(TRANSFORM(QRY1->RA_SALARIO,'@E 9,999,999.99')) + ";"                 // SALÁRIO ATUAL
	clinha = clinha + AllTrim(TRANSFORM(rQTDE({"080","081","082","083","084","085","086","087","088"}),'@E 9,999,999.99')) + ";" // QTDE HORAS EXTRAS
	clinha = clinha + AllTrim(TRANSFORM(rQTDE({"022","029","090","196"}),'@E 9,999,999.99')) + ";" // QTDE DSR
	clinha = clinha + AllTrim(TRANSFORM(rVALOR({"080","081","082","083","084","085","086","087","088","022","029","090","196"}),'@E 9,999,999.99')) + ";" //VALOR HE+DSR
	clinha = clinha + AllTrim(TRANSFORM(rQTDE({"420","421","422","423","424","426","431","466"}),'@E 9,999,999.99')) + ";" // QTDE FALTA+ATRASO
	clinha = clinha + AllTrim(TRANSFORM(rVALOR({"420","421","422","423","424","426","431","466"}),'@E 9,999,999.99')) + ";" // VALOR FALTA+ATRASO
	clinha = clinha + AllTrim(TRANSFORM(rVALOR({"788"}),'@E 9,999,999.99')) + ";"                  // V.R. EMPRESA
	clinha = clinha + AllTrim(TRANSFORM(rVALOR({"786"}),'@E 9,999,999.99')) + ";"                  // V.T. EMPRESA
	clinha = clinha + AllTrim(TRANSFORM(rVALOR({"725","726","789"}),'@E 9,999,999.99')) + ";"      // ASS.MÉDICA EMPRESA
	clinha = clinha + Iif(!Empty(QRY1->RF_DATAINI),StrZero(DAY(STOD(QRY1->RF_DATAINI)),2) + "/" + StrZero(Month(STOD(QRY1->RF_DATAINI)),2) + "/" + RIGHT(Str(Year(STOD(QRY1->RF_DATAINI)),4),4), "")+ ";" // DATA FÉRIAS
	clinha = clinha + Iif(!Empty(QRY1->RF_DATAINI),AllTrim(TRANSFORM(QRY1->RF_DFEPRO1,'@E 9,999,999.99')),"") + ";" // DIAS FÉRIAS
	fWrite(nHandle, cLinha  + cCrLf )
	cCCUSTO := QRY1->RA_CC
	Incproc()
	QRY1->(DbSkip())
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
MsgAlert( "Arquivo Gerado!" )
Return .T.                                                    
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//CRIACAO DA PERGUNTA 
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
            //X1_GRUPO X1_ORDEM X1_PERGUNT            X1_PERSPA X1_PERENG X1_VARIAVL X1_TIPO X1_TAMANHO X1_DECIMAL X1_PRESEL X1_GSC X1_VALID   X1_VAR01	 X1_DEF01 X1_DEFSPA1 X1_DEFENG1 X1_CNT01 X1_VAR02 X1_DEF02 X1_DEFSPA2 X1_DEFENG2 X1_CNT02 X1_VAR03 X1_DEF03 X1_DEFSPA3 X1_DEFENG3 X1_CNT03 X1_VAR04 X1_DEF04 X1_DEFSPA4 X1_DEFENG4 X1_CNT04 X1_VAR05 X1_DEF05 X1_DEFSPA5 X1_DEFENG5 X1_CNT05 X1_F3 X1_PYME X1_GRPSXG X1_HELP X1_PICTURE X1_IDFIL
            //  2         3          4                   5           6         7        8         9         10         11      12      13         14         15			16        17        18       19       20        21         22        23       24       25        26         27        28       29       30        31         32        33       34       35        36         37        38     39     40        41       42       43        44
  AAdd(aRegs,{cPerg,"01","Centro Custo de?              ","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"02","Centro Custo ate?             ","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg,"03","Matricula de?                 ","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"04","Matricual ate?                ","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
  AAdd(aRegs,{cPerg,"05","Ano e Mês Referência (AAAAMM) ","","","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
//--------------------------------------------------------------------------------------------------------------------------------------------
static function rVALOR(aVerbas) //VALOR
	Local aSaveArea := GetArea()
	Local nTotal	:= 0.0
	
	dbSelectArea("SRD")
	dbSetOrder(1) //FILIAL  +MATRICULA  +DT ARQ  +VERBA
	For i:=1 to Len(aVerbas)
		dbSeek(xFilial("SRD")+QRY1->RA_MAT+MV_PAR05+aVerbas[i])
		nTotal += SRD->RD_VALOR
	Next
	
	RestArea(aSaveArea)
return nTotal
//----------------------------------------------------------------------------------------------------------------------------------------------------------
static function rQTDE(aVerbas) //QUANTIDADE
	Local aSaveArea := GetArea()
	Local nTotal	:= 0.0
	
	dbSelectArea("SRD")
	dbSetOrder(1) //FILIAL  +MATRICULA  +DT ARQ  +VERBA
	For i:=1 to Len(aVerbas)
		dbSeek(xFilial("SRD")+QRY1->RA_MAT+MV_PAR05+aVerbas[i])
		nTotal += SRD->RD_HORAS
	Next
	
	RestArea(aSaveArea)
return nTotal
//----------------------------------------------------------------------------------------------------------------------------------------------------------