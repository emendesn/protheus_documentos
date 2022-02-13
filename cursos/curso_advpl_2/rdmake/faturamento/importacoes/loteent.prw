#Include "PROTHEUS.CH"
#include 'topconn.ch'
User Function LoteEnt()       	
Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local cChave := ''
Local nSaldo := 0
Local aSaida := {}
Local aEntrada := {}
Local nAt    := 0
Local nMax   := 0 
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

IF Select("QRYENT") <> 0 
	DbSelectArea("QRYENT")
	DbCloseArea()
Endif   

IF Select("QRYSAI") <> 0 
	DbSelectArea("QRYSAI")
	DbCloseArea()
Endif   

                
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

cQuery := "Select D1_DOC,D1_SERIE,D1_EMISSAO,D1_ITEM,D1_COD,D1_LOCAL,D1_QUANT,D1_FORNECE,D1_LOJA,D1_FILIAL "
cQuery += " FROM " + RETSQLNAME("SD1") + " SD1 (NOLOCK) "
cQuery += " WHERE D1_LOCAL IN('70','71','72','73') AND "
cQuery += " SD1.D_E_L_E_T_ = ' '  "
cQuery += " ORDER BY D1_EMISSAO,D1_COD "        
TCQUERY cQuery NEW ALIAS "QRYENT" 


cQuery := "Select D2_DOC,D2_SERIE,D2_QUANT,D2_COD,D2_EMISSAO,D2_CLIENTE,D2_LOJA,D2_FILIAL,D2_LOCAL,D2_LOTECTL  "
cQuery += " FROM " + RETSQLNAME("SD2") + " SD2 (NOLOCK) "
cQuery += " WHERE D2_LOCAL IN('70','71','72','73') AND "
cQuery += " SD2.D2_LOTECTL <> ''  AND "
cQuery += " SD2.D_E_L_E_T_ = ' '  "
cQuery += " ORDER BY D2_EMISSAO,D2_COD "        
TCQUERY cQuery NEW ALIAS "QRYSAI" 
ProcRegua(QRYSAI->(RecCount()))
Do While ! QRYSAI->(Eof())              
	IncProc()
	AADD(aSaida, { QRYSAI->D2_EMISSAO	,;
				QRYSAI->D2_COD			,;
				QRYSAI->D2_DOC 			,;
				QRYSAI->D2_SERIE		,;
				QRYSAI->D2_QUANT		,;
				QRYSAI->D2_CLIENTE		,;
				QRYSAI->D2_LOJA			,;
				QRYSAI->D2_FILIAL		,;
				QRYSAI->D2_LOCAL		,;
				QRYSAI->D2_LOTECTL		,;
				QRYSAI->D2_QUANT    })
	QRYSAI->(DbSkip())
EndDo


DBSELECTAREA("QRYENT")
PROCREGUA(QRYENT->(RECCOUNT()))
Do While ! QRYENT->(Eof())
	cchave := QRYENT->D1_EMISSAO+QRYENT->D1_COD
	Do While ! QRYENT->(Eof()) .AND. QRYENT->D1_EMISSAO+QRYENT->D1_COD = cChave
		Incproc()
		nAt := aScan(aSaida, { |x| x[1] > QRYENT->D1_EMISSAO .And. X[2] = QRYENT->D1_COD ;
							 .AND. X[8] = QRYENT->D1_FILIAL .AND. X[9] = QRYENT->D1_LOCAL .AND. X[11] > 0  })
		nSaldo := QRYENT->D1_QUANT							 
		if nAt > 0 .and. ( nSaldo - aSaida[nAt,5]) >= 0
			AAdd(aEntrada,{ QRYENT->D1_FILIAL   ,;
							QRYENT->D1_DOC		,;
							QRYENT->D1_SERIE	,;
							QRYENT->D1_FORNECE	,;
							QRYENT->D1_LOJA		,;
							QRYENT->D1_LOCAL	,;
							QRYENT->D1_COD		,;
							ASAIDA[nat,3]  		,;
							ASAIDA[nat,4]  		,;
							ASAIDA[nat,6]  		,;
							ASAIDA[nat,7]  		,;
							ASAIDA[nat,5]  		,;
							ASAIDA[nat,10]  	,;
							QRYENT->D1_QUANT })
			ASAIDA[nAt,11] -=  NSaldo				
		ELSE
			AAdd(aEntrada,{ QRYENT->D1_FILIAL   ,;
							QRYENT->D1_DOC		,;
							QRYENT->D1_SERIE	,;
							QRYENT->D1_FORNECE	,;
							QRYENT->D1_LOJA		,;
							QRYENT->D1_LOCAL	,;
							QRYENT->D1_COD	    ,;
							"SEM RELACIONAMENTO" ,;
							"" 		,;
							""  		,;
							""  		,;
							0  		,;
							""  	,;
							QRYENT->D1_QUANT })
		endIf								 
		
		QRYENT->(DbSkip())
	EndDo
EndDo   
cLinha := 'FILIAL'       + ';'
cLinha += 'NF. ENT.'     + ';'
cLinha += 'SERIE'        + ';'
cLinha += 'FORNECEDOR'   + ';'
cLinha += 'LOJA'         + ';'
cLinha += 'LOCAL'        + ';'
cLinha += 'PRODUTO'      + ';'
cLinha += 'QTDE ENTRADA' + ';'
cLinha += 'NF. SAIDA'    + ';'
cLinha += 'SERIE'        + ';'
cLinha += 'CLIENTE'      + ';'
cLinha += 'LOJA'         + ';'
cLinha += 'QTDE SAIDA'   + ';'
cLinha += 'LOTE'         + ';'

fWrite(nHandle, cLinha  + cCrLf)                               

nMax := Len(aEntrada)
For x:= 1 to nMax
	cLinha := aEntrada[x,1] + ';' 
	cLinha += aEntrada[x,2] + ';'
	cLinha += aEntrada[x,3] + ';'
	cLinha += aEntrada[x,4] + ';'
	cLinha += aEntrada[x,5] + ';'
	cLinha += aEntrada[x,6] + ';'
	cLinha += "'" + aEntrada[x,7] + ';'
	cLinha += Transform( aEntrada[x,14], "@E 999,999.99999") + ';'
	cLinha += aEntrada[x,8] + ';'
	cLinha += aEntrada[x,9] + ';'
	cLinha += aEntrada[x,10] + ';'
	cLinha += aEntrada[x,11] + ';'
	cLinha += Transform( aEntrada[x,12], "@E 999,999.99999" )+ ';'
	cLinha += aEntrada[x,13] + ';'
	fWrite(nHandle, cLinha  + cCrLf)                               
Next	

fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRYENT") <> 0 
	DbSelectArea("QRYENT")
	DbCloseArea()
Endif   
DBSELECTAREA("SD1")
IF Select("QRYSAI") <> 0 
	DbSelectArea("QRYSAI")
	DbCloseArea()
Endif        
DBSELECTAREA("SD2")
Return .t.