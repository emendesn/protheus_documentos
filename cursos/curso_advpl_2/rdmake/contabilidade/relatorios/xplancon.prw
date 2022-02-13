#Include "PROTHEUS.CH"
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXPLANCON  บAutor  ณ Edson Rodrigues    บ Data ณ  14/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Plano de Contas que relaciona com Plano Contasบฑฑ 
ฑฑบ            Referencial da Receita federal                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     

User Function XPLANCON()    
  
Processa( { || MyRel() } ) 
Return .t.                     


Static Function MyRel()                 
Local cDirDocs	:= __RelDir
Local cCrLf		:=Chr(13)+Chr(10)
Local cArquivo	:=CriaTrab(,.f.)
Local cPath		:=AllTrim(GetTempPath())     
Local cQuery  	:= ''
Local cQry		:= ''
Local nLin    	:= 0  
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
                               
IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif

	
cQuery := " SELECT CT1_CONTA,CT1_DESC01, "
cQuery += " NAT_SPED=CASE WHEN CT1_NTSPED IS NULL THEN '' ELSE CT1_NTSPED END , "
cQuery += " CONTA_REF=CASE WHEN CVD_CTAREF IS NULL THEN '' ELSE CVD_CTAREF END ,  "
cQuery += " DESCON_REF=CASE WHEN CVN_DSCCTA IS NULL THEN '' ELSE CVN_DSCCTA END , "
cQuery += " CCUSTO_REF=CASE WHEN CVD_CUSTO IS NULL THEN '' ELSE CVD_CUSTO END ,  "
cQuery += " CODPLAN_REF=CASE WHEN CVD_CODPLA IS NULL THEN '' ELSE CVD_CODPLA END , "
cQuery += " LINHA_REF=CASE WHEN CVN_LINHA IS NULL THEN '' ELSE CVN_LINHA END "
cQuery += " FROM "+ RETSQLNAME("CT1")+"  CT1 "
cQuery += " LEFT OUTER JOIN (SELECT CVD_CONTA,CVD_CTAREF,CVD_CUSTO,CVD_CODPLA,CVN_CTAREF,CVN_LINHA,CVN_DSCCTA FROM "+ RETSQLNAME("CVD")+" " 
cQuery += "                   LEFT OUTER JOIN (SELECT CVN_CODPLA,CVN_CTAREF,CVN_LINHA,CVN_DSCCTA FROM "+ RETSQLNAME("CVN")+" WHERE CVN_FILIAL='"+ xFilial("CVN")+"' AND D_E_L_E_T_='') AS CVN "
cQuery += "                   ON CVD_CODPLA = CVN_CODPLA AND CVD_CTAREF = CVN_CTAREF "
cQuery += "                 WHERE CVD_FILIAL='"+ xFilial("CVD")+"' AND D_E_L_E_T_='') AS CVD " 
cQuery += " ON CT1.CT1_CONTA = CVD_CONTA "                 
cQuery += " WHERE CT1.CT1_FILIAL='" + xFilial("CT1") + "' AND CT1.D_E_L_E_T_=''  "
cQuery += " ORDER BY CT1_CONTA "
  

TCQUERY cQuery NEW ALIAS "QRY0"  

                                             
/* cabecalho do relatorio */
cLinha := "CONTA_BGH" + ';'
cLinha += "DESCCONTA_BGH" + ';' 	
cLinha += "NATUREZA_SPED" + ';'	
cLinha += "CONTA_REF" + ';'	
cLinha += "DESCCONTA_REF" + ';'
cLinha += "CCUSTO_REF" + ';'
cLinha += "CODPLAN_REF" + ';'
cLinha += "LINHA_REF" + ';'
fWrite(nHandle, cLinha  + cCrLf)
/* ------ FIM DO CABECALHO DO RELATORIO -------- */ 
nTotsRec := QRY0->(RECCOUNT())
ProcRegua(nTotsRec)               

Do  While ! QRY0->(EOF())
	IncProc()  
	clinha := ''
	cLinha += QRY0->CT1_CONTA	+ ';'
	cLinha += QRY0->CT1_DESC01 	+ ';' 	
	cLinha += QRY0->NAT_SPED 		+ ';'	
	cLinha += QRY0->CONTA_REF		+ ';'	
	cLinha += QRY0->DESCON_REF 	+ ';'
	cLinha += QRY0->CCUSTO_REF 		+ ';'
	cLinha += QRY0->CODPLAN_REF		+ ';'
	cLinha += QRY0->LINHA_REF	+ ';'
	fWrite(nHandle, cLinha  + cCrLf)						
	QRY0->(DBSKIP())
EndDo
fClose(nHandle)
//CpyS2T(cdirdocs+carquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha		-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif   
Return .t.