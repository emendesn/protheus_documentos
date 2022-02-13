#INCLUDE "protheus.ch"
//#INCLUDE "rfatr03.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR03   บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de inventory.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFatR03(_aParam)

Local aSay := {}
Local aButton := {}
Local nOpc := 0
//Local Titulo := STR0001 //'Arquivo de Inventory.'
Local Titulo := 'Arquivo de Inventory.'
DEFAULT _aParam :={"02","02"}
//Private cDesc1 := STR0002 //'Esta rotina irแ gerar um arquivo para o Excel de acordo'
//Private cDesc2 := STR0003 //'com os parโmetros escolhidos pelo usuแrio.'
Private cDesc1 := 'Esta rotina irแ gerar um arquivo para o Excel de acordo'
Private cDesc2 := 'com os parโmetros escolhidos pelo usuแrio.'
Private cDesc3 := ''
Private cDesc4 := ''
Private cDesc5 := ''
Private cPerg := "RFATR03   "                 
Private lDireto := IIf(ValType(_aParam)!="U",.T.,.F.)

//------------------------------ Seta a empresa e filial-----------------
If ValType(_aParam) != "U"
	If !Empty(_aParam[1]) .and. !Empty(_aParam[2])
		RPCSETTYPE(3)
		If FindFunction('WFPREPENV')
			WfPrepEnv(_aParam[1],_aParam[2])
		Else
		   Prepare Environment Empresa _aParam[1] Filial _aParam[2]
		Endif	
    EndIf
Endif	
//----------------------------------------------------------------------- 		

ValidPerg(cPerg)

If !lDireto
	If !Pergunte(cPerg,.t.)
		Return()
	Endif
Endif	

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

If !lDireto
	FormBatch( Titulo, aSay, aButton )

	If nOpc == 1
		// RptStatus({|| _fGera() },STR0004) //"Gerando Arquivo..."
		RptStatus({|| _fGera() },"Gerando Arquivo") //"Gerando Arquivo..."
	EndIf
Else
	mv_par01 := " "
	mv_par02 := "Z"
	_fGera()	
Endif	
If ValType(_aParam) != "U"
	If !Empty(_aParam[1]) .and. !Empty(_aParam[2])
    	  Reset Environment
	endif
endif

//Envio de relat๓rio para efeito de verifica็ใo de schedule
U_ACMAILJB("Arquivo de inventory","Arquivo de inventory. Finalizado.","RFATR03")

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณ_FGERA    บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fGera()

Local cDirDocs := MsDocPath()
Local cPath := IIf(!lDireto,AllTrim(GetTempPath()),"")
Local oExcelApp
Local nHandle
Local cCrLf	:= Chr(13) + Chr(10)
Local nRec := 0
Local cCabec := ""
Local cItem := ""
Local nDet := 0
Local cTimeStamp := Subs(dTos(dDataBase),1,4)+Subs(dTos(dDataBase),5,2)+Subs(dTos(dDataBase),7,2)+StrTran(Time(),":","")
Local cArquivo := "Inventory_"+cTimeStamp //CriaTrab(,.F.)
Local lExcel := .F.

If !lDireto .and. Empty(mv_par03)
	// MsgStop(STR0014) //"Parโmetro 'Diret๓rio para grava็ใo ?' nใo preenchido. Verifique."
	MsgStop("Parโmetro 'Diret๓rio para grava็ใo ?' nใo preenchido. Verifique.") //"Parโmetro 'Diret๓rio para grava็ใo ?' nใo preenchido. Verifique."

	Return()
Endif	

// faz a selecao dos dados	
nRec := Filtra()

If nRec = 0
	If !lDireto
		// MsgStop(STR0005) //"Nใo hแ registros na sele็ใo de parโmetros, verifique."
		MsgStop("Nใo hแ registros na sele็ใo de parโmetros, verifique.") //"Nใo hแ registros na sele็ใo de parโmetros, verifique."
	Endif	
	
	_TRA->(dbCloseArea())
	Return()
Endif	
	
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

// grava o cabecalho do arquivo, campo + "TAB"
cCabec := "Division " + ";"
cCabec += "Warehouse " + ";"
cCabec += "Inventory Location " + ";"
cCabec += "Product number " + ";"
cCabec += "Product class " + ";"
cCabec += "Product model " + ";"
cCabec += "Product family " + ";"
cCabec += "Brand Name " + ";"
cCabec += "Product Description " + ";"
cCabec += "System-maintained total on-hand " + ";"
cCabec += "WH-MIT " + ";"
cCabec += "SO-MIT Qtys " + ";"
cCabec += "Average material cost " + ";"
cCabec += "Inventory $ " + ";"
cCabec += "Average Material Cost(Functional currency) " + ";"
cCabec += "Inventory Total Value(Functional currency) " + ";"
cCabec += "Average Material Cost(USD$) " + ";"
cCabec += "Inventory Total Value(USD$) " + ";"
cCabec += "AGE in days without any movement " + ";"
cCabec += "Last Usage of Product(Date:MMDDYY) " + ";"
cCabec += "UPC Code " + ";"
cCabec += "TimeStamp(yyyymmddhhmmss) " + ";"
cCabec += cCrLf

nDet := Len(cCabec)
lGravou := IIf(fWrite(nHandle,cCabec) == nDet,.T.,.F.)
	
If !lGravou
	If !lDireto
	//	MsgStop(STR0006+chr(13) + ;
	//	STR0007+AllTrim(Str(fError()))) //"Erro ao gravar o cabecalho no arquivo de saida" / "Codigo do erro: "
		MsgStop("Erro ao gravar o cabecalho no arquivo de saida" +chr(13) + ;
		"Codigo do erro: "+AllTrim(Str(fError()))) //"Erro ao gravar o cabecalho no arquivo de saida" / "Codigo do erro: "
	
	
	Endif	
				
	_TRA->(dbCloseArea())
	Return()
EndIf
	
dbSelectArea("_TRA")

If !lDireto
	SetRegua(nRec)	
Endif	
While !Eof()
	If !lDireto
		// IncRegua(STR0004) //"Gerando arquivo...
		 IncRegua("Gerando arquivo...") //"Gerando arquivo...
		If lAbortPrint
			Exit
		Endif
	Endif	

	SM2->(dbSetOrder(1))
	SM2->(dbSeek(dTos(dDataBase)))

   // grava os itens do arquivo
	cItem := IIf(lExcel,'=CONCATENAR("',"")+_TRA->B2_FILIAL+IIf(lExcel,'")',"") + ";"	   
	cItem += IIf(lExcel,'=CONCATENAR("',"")+_TRA->B2_LOCAL+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+Transform(_TRA->QTDENSAI,"@E 999,999,999.99")+IIf(lExcel,'")',"") + ";"	
	cItem += IIf(lExcel,'=CONCATENAR("',"")+_TRA->B2_COD+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+StrTran(StrTran(_TRA->B1_GRUPO,'"',""),";","")+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+StrTran(StrTran(_TRA->B1_X_MODEL,'"',""),";","")+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+StrTran(StrTran(_TRA->B1_X_FAMIL,'"',""),";","")+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+StrTran(StrTran(_TRA->B1_X_BRAND,'"',""),";","")+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+StrTran(StrTran(_TRA->B1_DESC,'"',""),";","")+IIf(lExcel,'")',"") + ";"
	cItem += Transform(_TRA->B2_QATU,"@E 999,999,999.99") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+Transform(_TRA->QTDENSAI,"@E 999,999,999.99")+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+Transform(_TRA->QTDETRANS,"@E 999,999,999.99")+IIf(lExcel,'")',"") + ";"
	cItem += Transform(_TRA->B2_CM1,"@E 999,999,999.99") + ";"
	cItem += Transform(_TRA->B2_VATU1,"@E 999,999,999.99") + ";"
	cItem += Transform(_TRA->B2_CM1,"@E 999,999,999.99") + ";"
	cItem += Transform(_TRA->B2_VATU1,"@E 999,999,999.99") + ";"
	cItem += Transform(_TRA->B2_CM1/IIf(SM2->(Found() .and. !Empty(SM2->M2_MOEDA2)),SM2->M2_MOEDA2,1),"@E 999,999,999.99") + ";"
	cItem += Transform(_TRA->B2_VATU1/IIf(SM2->(Found() .and. !Empty(SM2->M2_MOEDA2)),SM2->M2_MOEDA2,1),"@E 999,999,999.99") + ";"
	cItem += Transform(IIf(!Empty(_TRA->B2_USAI),dDataBase-_TRA->B2_USAI,0),"@E 999,999,999.99") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+Subs(dTos(_TRA->B2_USAI),5,2)+Subs(dTos(_TRA->B2_USAI),7,2)+Subs(dTos(_TRA->B2_USAI),3,2)+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+_TRA->B1_CODBAR+IIf(lExcel,'")',"") + ";"
	cItem += IIf(lExcel,'=CONCATENAR("',"")+cTimeStamp+IIf(lExcel,'")',"") + ";"
	cItem += cCrLf

	nDet := Len(cItem)
	lGravou := IIf(fWrite(nHandle,cItem) == nDet,.T.,.F.)
	If !lGravou
		If !lDireto
			// MsgStop(STR0009+chr(13) + ;
			// STR0007+AllTrim(Str(fError()))) //"Erro ao gravar itens no arquivo de saida" / "Codigo do erro: "
			 MsgStop("Erro ao gravar itens no arquivo de saida"+chr(13) + ;
			 "Codigo do erro: "+AllTrim(Str(fError()))) //"Erro ao gravar itens no arquivo de saida" / "Codigo do erro: "

		Endif	
		Return()
	EndIf
		
	cItem := ""
	nDet := 0
		
	dbSelectArea("_TRA")
	dbSkip()
Enddo	
	
If !lGravou
	If !lDireto
		// MsgStop(STR0010) //"Nใo gerou arquivo, verifique !!!"
		MsgStop("Nใo gerou arquivo, verifique !!!") //"Nใo gerou arquivo, verifique !!!"
	Endif	
Else
	If !lDireto
		// MsgInfo(STR0011,"Info") //"Arquivo(s) gerado(s) com sucesso."
		MsgInfo("Arquivo(s) gerado(s) com sucesso.","Info") //"Arquivo(s) gerado(s) com sucesso."
	Endif	
Endif
	
If nHandle <> 0
	If fClose(nHandle) 
		If lDireto
			U_EnvFtp(cDirDocs+"\"+cArquivo+".CSV",cArquivo+".CSV")	
		Endif	
	Else
		If !lDireto
			// MsgStop(STR0012+AllTrim(Str(fError()))) //"Nao foi possivel finalizar o arquivo de saida! Codigo do erro: "
    		MsgStop("Nao foi possivel finalizar o arquivo de saida! Codigo do erro: " +AllTrim(Str(fError()))) //"Nao foi possivel finalizar o arquivo de saida! Codigo do erro: "
		Endif	
	EndIf
Endif	

If !lDireto	
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

	If lExcel	
		If ! ApOleClient( 'MsExcel' )
		   //	MsgAlert(STR0013) //'MsExcel nao instalado'
		   	MsgAlert('MsExcel nao instalado') //'MsExcel nao instalado'
			_TRA->(dbCloseArea())	
	
			Return()
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , mv_par03, .T. )		
	Endif	
Else
	// copia o arquivo para uma outra pasta para redundancia
	IIf(!ExistDir("\Ftp_Acer"),{|| MakeDir("\Ftp_Acer"),__CopyFile(cDirDocs+"\"+cArquivo+".CSV","\Ftp_Acer\"+cArquivo+".CSV")},__CopyFile(cDirDocs+"\"+cArquivo+".CSV","\Ftp_Acer\"+cArquivo+".CSV"))
Endif	

If Select("_TRA") > 0
	_TRA->(dbCloseArea())
Endif	

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณFILTRA    บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Filtra()

Local cQ := ""
Local nReg := 0

cQ := "SELECT "
// cQ += "B2_LOCAL,B2_COD,B1_X_MODEL,B1_X_FAMIL,B1_X_BRAND,B1_DESC,B2_QATU,B2_VATU1,B2_CM1,B2_USAI,B1_CODBAR,B1_GRUPO,B2_FILIAL, "
cQ += "B2_LOCAL,B2_COD,'' AS B1_X_MODEL,'' AS B1_X_FAMIL,'' AS B1_X_BRAND,B1_DESC,B2_QATU,B2_VATU1,B2_CM1,B2_USAI,B1_CODBAR,B1_GRUPO,B2_FILIAL, "
// cQ += " NVL((SELECT SUM(D2_QUANT-D2_QTDEDEV) FROM "+RetSqlName("SD2")+" SD2, "+;
cQ += " ISNULL((SELECT SUM(D2_QUANT-D2_QTDEDEV) FROM "+RetSqlName("SD2")+" SD2, "+;
                                                  RetSqlName("SF2")+" SF2,"+RetSqlName("SF4")+" SF4  "+;
       "WHERE SD2.D_E_L_E_T_=' ' AND SF2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' AND D2_TIPO='N' AND D2_TES=F4_CODIGO  "+;
       " AND F2_FILIAL=D2_FILIAL AND D2_SERIE=F2_SERIE AND D2_DOC=F2_DOC AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "+;
       " AND D2_FILIAL = B2_FILIAL AND D2_COD=B2_COD AND B2_LOCAL=D2_LOCAL "
//       " AND (F2_XDTSAID = '"+Space(8)+"' ) AND D2_TES IN "+FormatIn(GetMv("MV_XTESFAT"),"/")+" AND D2_FILIAL='04'  ),0) AS QTDENSAI, "  //AND F2_EMISSAO >= '20111201'
cQ +=  " AND (F2_SAIROMA = '"+Space(8)+"' ) AND D2_TES IN "+FormatIn(GetMv("MV_XTESFAT"),"/")+" AND D2_FILIAL= '"+xFilial("SD2")+"'  ),0) AS QTDENSAI, " 
// cQ += " NVL((SELECT SUM(D2_QUANT-D2_QTDEDEV) FROM "+RetSqlName("SD2")+" SD2, "+;
//                                                  RetSqlName("SF2")+" SF2,"+RetSqlName("SF4")+" SF4  "+;
//        "WHERE SD2.D_E_L_E_T_=' ' AND SF2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' AND D2_TIPO='N' AND D2_TES=F4_CODIGO  "+;
//        " AND F2_FILIAL=D2_FILIAL AND D2_SERIE=F2_SERIE AND D2_DOC=F2_DOC AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "+;
//        " AND D2_FILIAL = B2_FILIAL AND D2_COD=B2_COD AND B2_LOCAL=D2_LOCAL "+;
//        " AND (F2_XDTSAID <> '"+Space(8)+"' AND  F2_DTENTR = '"+Space(8)+"') AND D2_TES IN "+FormatIn(GetMv("MV_XTESFAT"),"/")+"AND D2_FILIAL='04'  AND D2_EMISSAO >= '"+substr(dtos(ddatabase-60),1,6)+"01' ),0) AS QTDETRANS "  //AND F2_EMISSAO >= '20111201'
cQ += " 0 AS QTDETRANS "
cQ += "FROM "
cQ += RetSqlName("SB2")+" SB2, "
cQ += RetSqlName("SB1")+" SB1 "
cQ += "WHERE "  
/*If !lDireto // soh processa a filial corrente se nao for em schedule
	cQ += "B2_FILIAL = '"+xFilial("SB2")+"' "
	cQ += "AND B1_FILIAL = '"+xFilial("SB1")+"' AND "
Endif	*/                                   
cQ += "B2_FILIAL = '"+xFilial("SB2")+"' "
cQ += "AND B2_LOCAL IN "+FormatIn(GetMv("MV_XARMACE"),"/")+" "
cQ += "AND B1_COD = B2_COD "
cQ += "AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQ += "AND SB2.D_E_L_E_T_ = ' ' "
cQ += "AND SB1.D_E_L_E_T_ = ' ' "
cQ += "ORDER BY B2_FILIAL,B2_COD "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"_TRA",.F.,.T.)

tcSetField("_TRA","B2_QATU","N",TamSx3("B2_QATU")[1],TamSx3("B2_QATU")[2])
tcSetField("_TRA","B2_VATU1","N",TamSx3("B2_VATU1")[1],TamSx3("B2_VATU1")[2])
tcSetField("_TRA","B2_CM1","N",TamSx3("B2_CM1")[1],TamSx3("B2_CM1")[2])
tcSetField("_TRA","B2_USAI","D")

_TRA->(dbEval({ || nReg++ },,{||!Eof()} ))
dbGotop()

Return(nReg)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณVALIDPERG บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

LOCAL _aAlias  := GETAREA()
LOCAL _ni      := 0
LOCAL _nj      := 0
LOCAL _cPerg   := PADR(cPerg,LEN(SX1->X1_GRUPO))
LOCAL _aPerg   := {}

AADD(_aPerg,{_cPerg,'01','Produto de ?                  ','ฟDe Producto ?                ',;
			'From Product ?                             ','mv_ch1','C',15,0,0,'G','','mv_par01','','','',;
			'','','','','','','','','','','','','','','','','','','','','','SB1','S','','','',''})
AADD(_aPerg,{_cPerg,'02','Produto ate ?                 ','ฟA Producto ?                 ',;
			'To Product ?                               ','mv_ch2','C',15,0,0,'G','','mv_par02','','','',;
			'','','','','','','','','','','','','','','','','','','','','','SB1','S','','','',''})
AADD(_aPerg,{_cPerg,'03','Diretorio para gravacao ?     ','ฟDiretorio para gravacao ?    ',;
			'Generation folder ?                        ','mv_ch3','C',99,0,0,'G','!Empty(mv_par03)','mv_par03','','','',;
			'','','','','','','','','','','','','','','','','','','','','','','S','','','',''})

dbSelectArea('SX1')
dbSetOrder(1)	// X1_GRUPO + X1_ORDEM
FOR _ni := 1 TO LEN(_aPerg)
	IF !dbSeek(_cPerg+_aPerg[_ni,2])
		RECLOCK('SX1',.T.)
		FOR _nj := 1 TO FCOUNT()
			IF LEN(_aPerg[_ni]) >= _nj	// Se for menor, o comando abaixo estoura o array.
				FIELDPUT(_nj,_aPerg[_ni,_nj])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT

RESTAREA(_aAlias)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณENVFTP    บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnvFtp(cDir,cFile)

Local cServer := Alltrim(GetMv("MV_XFTPAGP")) //"kore.gateway.com" 

Private lConnected := .F.

If DoConnect(cServer, cFile )

	DoUpLoad(cServer, cFile, cDir ) 

	DoDisconnect()
	
Endif	

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณDOCONNECT บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DoConnect(cServer, cFile )

Local cUser	:= Alltrim(GetMv("MV_XFTPUSU")) 
Local cSenha:= Alltrim(GetMv("MV_XFTPPAS")) 

cUser 	:= IIf(Empty(cUser), Nil, cUser)
cSenha	:= IIf(Empty(cSenha), Nil, cSenha)

If lConnected
	ConOut( "Ja existe uma conexao ativa com um servidor FTP")
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Variแvel Global identificadora da exist๊ncia de um FireWall ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lFireWall := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Conecta ao Servidor FTP ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lConnected := FTPConnect(cServer,,cUser,cSenha)

If !lConnected
	ConOut( "Falha de conexใo ao servidor FTP. Verifique se os parametros MV_XFTPAGP/MV_XFTPUSU/MV_XFTPPAS... estao configurados corretamente.")
Else
	lConnected := DoRefresh()
Endif

Return lConnected
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณDODISCONNECTบAutor  ณ TOTVS            บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DoDisconnect()

If !lConnected
	Return .F.
Endif
                 
lConnected := !FTPDisconnect()

If lConnected
	ConOut("Falha ao tentar desconectar")
Endif

Return lConnected
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณDOUPLOAD  บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DoUpLoad(cServer,cFile,cDir)

Local lRet

If !lConnected
	ConOunt("Nao conectado a um servidor FTP")
	Return .F.
Endif

lRet := FTPUpLoad(cDir,cFile)
If lRet  
 	ConOut("Arquivo gravado com Sucesso.")
Else 
	ConOut("Arquivo nao foi gravado.")
EndIf                      
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ     
ฑฑบPrograma  ณDOREFRESH บAutor  ณ TOTVS              บ Data ณ 10/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo de backlog de faturamento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 / Agp                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DoRefresh()

Local lDir := .F.

If !lConnected
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Informa diretorio do Servidor ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lDir := FTPDirChange(Alltrim(GetMv("MV_XFTPDIR")))
If !lDir
	ConOut( "Falha de conexใo ao diret๓rio de FTP. Verifique se o parametro MV_XFTPDIR esta configurado corretamente.")
	Return .F.
EndIf

Return .T.