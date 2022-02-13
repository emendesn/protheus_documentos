/*--------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: DARF                                                                                                                                           |
|Autor:                                                                                                                                                   |
|Data Aplicação: 12/01/2011                                                                                                                               |
|Descrição: Relação de IRRF no mês, discriminando a competência da Folha de Pagamento                                                                     |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Claudio Bispo                                                                                                                              |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 06/04/2011                                                                                                                               |
|Motivo: Correção dos totalizadores de IRRF                                                                                                               |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Claudio Bispo                                                                                                                              |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 29/04/2011                                                                                                                               |
|Motivo: Correção do cálculo IRRF sobre 13o. Salário na Rescisão                                                                                          |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Claudio Bispo                                                                                                                              |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 02/09/2011                                                                                                                               |
|Motivo: Correção da apuração de valores para quem teve rescisão no período                                                                               |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Claudio Bispo                                                                                                                              |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 04/12/2012                                                                                                                               |
|Motivo: Correção V411 IR Dif Férias e V413 IRRF Férias Outros Períodos                                                                                   |
|Resposável: Anadi                                                                                                                                        |
|Validado por: Claudio Bispo                                                                                                                              |
+--------------------------------------------------------------------------------------------------------------------------------------------------------*/

#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function xDARF()    // Relatorios\Customizados\Relacao DARF (arquivo DARF.CSV)             
PRIVATE cPerg	 :="XDARF"

u_GerA0003(ProcName())

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
//Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo 	:= CriaTrab(,.F.)
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+"RELACAO DARF.csv") //Local _cArqTmp  := lower(AllTrim(__RELDIR)+alltrim(cArquivo)+".csv")
Local cPath     :=AllTrim(GetTempPath())     
Local cMesAnoRef
Local cSeq      := '000001'
Local mesFOLHA  := "      "
Local CCUSTO
Local irFOLHA   := 0.00
Local irFOLHAt1 := 0.00
Local irFOLHAt2 := 0.00
Local mesFOLHA1 := "      "
Local irADTO    := 0.00
Local irADTOt1  := 0.00
Local irADTOt2  := 0.00
Local mesFOLHA2 := "      "
Local irFERIAS  := 0.00
Local irFERIASt1:= 0.00
Local irFERIASt2:= 0.00
Local mesFOLHA3 := "      "
Local ir13	    := 0.00
Local ir13t1	:= 0.00
Local ir13t2	:= 0.00
Local mesFOLHA4 := "      "
Local matricula := ""
nHandle         := MsfCreate(_cArqTmp,0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif

DbSelectArea("SRC") // MOVIMENTO MENSAL
DbSetOrder(2)
DbSelectArea("SRD") // MOVIMENTO ACUMULADO
DbSetOrder(2)                           
DbSelectArea("SRR") // MOVIMENTO FÉRIAS E RESCISÃO
DbSetOrder(2)                           
DbSelectArea("SRI") // MOVIMENTO 13 SALARIO
DbSetOrder(2)                           

cQuery := " SELECT RC_FILIAL AS FILIAL, RC_CC AS CCUSTO, RC_MAT AS MATRICULA, RC_PD AS VERBA, RC_VALOR AS VALOR, RC_DATA AS DATAPGTO, RC_SEMANA AS MESFOLHA FROM SRC020 AS RC3 "
cQuery += "	WHERE RC3.D_E_L_E_T_ = ' ' "
cQuery += "	AND RC3.RC_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "	AND RC3.RC_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
//cQuery += "	AND RC3.RC_MAT = '010009'
cQuery += "	AND RC3.RC_DATA BETWEEN '"+DTOS(FIRSTDAY(MV_PAR05))+"' AND '"+DTOS(LASTDAY(MV_PAR05))+"' "
cQuery += "	AND RC3.RC_PD IN (410,411,413,414,416,576,719) "
cQuery += "	UNION ALL "
cQuery += "	SELECT RD_FILIAL AS FILIAL, RD_CC AS CCUSTO, RD_MAT AS MATRICULA, RD_PD AS VERBA, RD_VALOR AS VALOR, RD_DATPGT AS DATAPGTO, RD_DATARQ AS MESFOLHA  FROM SRD020 AS RD3 "
cQuery += "	WHERE RD3.D_E_L_E_T_ = ' ' "
cQuery += "	AND RD3.RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "	AND RD3.RD_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
//cQuery += "	AND RD3.RD_MAT = '010009'
cQuery += "	AND RD3.RD_DATPGT BETWEEN '"+DTOS(FIRSTDAY(MV_PAR05))+"' AND '"+DTOS(LASTDAY(MV_PAR05))+"' "
cQuery += "	AND RD3.RD_PD IN (410,411,413,414,416,576,719) "
cQuery += "	UNION ALL "
cQuery += "	SELECT RI_FILIAL AS FILIAL, RI_CC AS CCUSTO, RI_MAT AS MATRICULA, RI_PD AS VERBA, RI_VALOR AS VALOR, RI_DATA AS DATAPGTO, RI_TIPO1 AS MESFOLHA FROM SRI020 AS RI3 "
cQuery += "	WHERE RI3.D_E_L_E_T_ = ' ' "
cQuery += "	AND RI3.RI_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "	AND RI3.RI_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
//cQuery += "	AND RI3.RI_MAT = '010009'
cQuery += "	AND RI3.RI_DATA BETWEEN '"+DTOS(FIRSTDAY(MV_PAR05))+"' AND '"+DTOS(LASTDAY(MV_PAR05))+"' "
cQuery += "	AND RI3.RI_PD IN (414) " 
cQuery += "	UNION ALL "
cQuery += "	SELECT RR_FILIAL AS FILIAL, RR_CC AS CCUSTO, RR_MAT AS MATRICULA, RR_PD AS VERBA, RR_VALOR AS VALOR, RR_DATA AS DATAPGTO, RR_TIPO1 AS MESFOLHA FROM SRR020 AS RR3 "
cQuery += "	WHERE RR3.D_E_L_E_T_ = ' ' "
cQuery += "	AND RR3.RR_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "	AND RR3.RR_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
//cQuery += "	AND RR3.RR_MAT = '010009'
cQuery += "	AND RR3.RR_DATA BETWEEN '"+DTOS(FIRSTDAY(MV_PAR05))+"' AND '"+DTOS(LASTDAY(MV_PAR05))+"' "
cQuery += "	AND RR3.RR_PD IN (412) "
//EndIf

cQuery += "	ORDER BY FILIAL, CCUSTO, MATRICULA, VERBA, DATAPGTO "

TCQUERY cQuery NEW ALIAS "QRY1"

DBSELECTAREA("QRY1")     
procregua(reccount())
QRY1->(DBGOTOP())

/*GRAVACAO DO HEADER */ 
clinha := "C.CUSTO" + ";" + "MATRICULA" + ";"+ "VERBA" + ";" + "VALOR" + ";" + "MÊS FOLHA" + ";" + "DATA PAGTO" 
fWrite(nHandle, cLinha  + cCrLf)
cLinha := ' '                   
fWrite(nHandle, cLinha  + cCrLf)
/* ---------FIM HEADER ----- */
DO WHILE !QRY1->(EOF())

	mesFOLHA := QRY1->MESFOLHA
	ccusto := QRY1->CCUSTO
	
	If VERBA $ "412" //IR FERIAS TABELA SRR
		dDATAINI := posicione("SRH",3,xfilial("SRH")+QRY1->MATRICULA+"   "+QRY1->DATAPGTO,"RH_DATAINI")
		mesFOLHA := ALLTRIM(STR(YEAR(dDATAINI)))+ALLTRIM(STRZERO(MONTH(dDATAINI),2))
	EndIf

	If mesFOLHA == "V     "
		mesFOLHA := "      "
	EndIf

	If mesFOLHA == "      "
		mesFOLHA := substr(dtos (mv_par05),1,6)
	EndIf

	clinha := QRY1->CCUSTO + ";" // CENTRO DE CUSTO
	clinha = clinha + QRY1->MATRICULA + ";" //MATRICULA
	clinha = clinha + QRY1->VERBA + ";" //VERBA
	clinha = clinha + IIf (QRY1->VALOR > 0.00 , TRANSFORM (QRY1->VALOR, "@E 999,999.99" ) + ";", " " + ";") //IRRF
	cLinha = cLinha + Right(MesFolha,2) + "/" + Left(MesFolha,4) + ";" //MÊS FOLHA
	cLinha = cLinha + dtoc(stod(QRY1->DATAPGTO)) + ";" //DATA PAGTO

	fWrite(nHandle, cLinha  + cCrLf )
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
MsgAlert( "Arquivo Gerado !" )
Return .T.                                                    
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//CRIACAO DA PERGUNTA //
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
            //X1_GRUPO X1_ORDEM X1_PERGUNT            X1_PERSPA X1_PERENG X1_VARIAVL X1_TIPO X1_TAMANHO X1_DECIMAL X1_PRESEL X1_GSC X1_VALID   X1_VAR01	 X1_DEF01 X1_DEFSPA1 X1_DEFENG1 X1_CNT01 X1_VAR02 X1_DEF02 X1_DEFSPA2 X1_DEFENG2 X1_CNT02 X1_VAR03 X1_DEF03 X1_DEFSPA3 X1_DEFENG3 X1_CNT03 X1_VAR04 X1_DEF04 X1_DEFSPA4 X1_DEFENG4 X1_CNT04 X1_VAR05 X1_DEF05 X1_DEFSPA5 X1_DEFENG5 X1_CNT05 X1_F3 X1_PYME X1_GRPSXG X1_HELP X1_PICTURE X1_IDFIL
            //  2         3          4                   5           6         7        8         9         10         11      12      13         14         15			16        17        18       19       20        21         22        23       24       25        26         27        28       29       30        31         32        33       34       35        36         37        38     39     40        41       42       43        44
  AAdd(aRegs,{cPerg   ,"01"    ,"Filial De?            : ",""       ,""       ,"mv_ch1"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par01",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg   ,"02"    ,"Filial Ate?           : ",""       ,""       ,"mv_ch2"  ,"C"    ,02        ,0         ,0        ,"G"   ,""        ,"mv_par02",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","XM0",""})
  AAdd(aRegs,{cPerg   ,"03"    ,"Centro Custo De?      : ",""       ,""       ,"mv_ch3"  ,"C"    ,09        ,0         ,0        ,"G"   ,""        ,"mv_par03",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg   ,"04"    ,"Centro Custo Ate?     : ",""       ,""       ,"mv_ch4"  ,"C"    ,09        ,0         ,0        ,"G"   ,""        ,"mv_par04",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","CTT",""})
  AAdd(aRegs,{cPerg   ,"05"    ,"Data Referencia       : ",""       ,""       ,"mv_ch5"  ,"D"    ,08        ,0         ,0        ,"G"   ,""        ,"mv_par05",""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,"","","","","","","","","","","","","","",""})

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