#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function relcardu()    
PRIVATE cPerg	 	:="XRCARD" 
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))    
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQry1 :=""
//Local _cDir    := "\relato\docs\"

Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.f.)
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local nLin := 0

u_GerA0003(ProcName())

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif                 
           


cQuery := " SELECT DISTINCT D2_COD,D2_QUANT,D2_PRCVEN,D2_DOC,D2_EMISSAO,D2_NFORI,D2_NUMSERI,ZZ4_CARDU "
cQuery += " FROM " + RetSqlname("SD2") + " SD2 (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SC6") +" SC6 "
cQuery += "  ON "
cQuery += " SD2.D2_PEDIDO = SC6.C6_NUM  "
cQuery += " AND SD2.D2_ITEMPV = SC6.C6_ITEM "
cQuery += " AND SD2.D2_FILIAL = SC6.C6_FILIAL "
cQuery += " AND SD2.D2_COD    = SC6.C6_PRODUTO "
cQuery += " LEFT OUTER JOIN (SELECT ZZ4_FILIAL,ZZ4_CARDU,ZZ4_OS,ZZ4_IMEI FROM " + RetSqlname("ZZ4") + " ZZ4 (nolock) WHERE  ZZ4_FILIAL='" + xFilial("ZZ4") + "'  AND ZZ4.D_E_L_E_T_=''  AND ZZ4_CARDU <> '' ) AS ZZ4"
cQuery += " ON "
cQuery += " C6_FILIAL = ZZ4_FILIAL "
cQuery += " AND C6_NUMSERI = ZZ4.ZZ4_IMEI "
cQuery += " AND SUBSTRING(C6_NUMOS,1,6) = ZZ4.ZZ4_OS "
cQuery += "  WHERE SD2.D2_FILIAL='" + xFilial("SD2") + "' AND  SC6.C6_FILIAL='" + xFilial("SC6") + "' "
cQuery += " AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND SC6.D_E_L_E_T_ = '' "
IF !empty(MV_PAR04)
	cQuery += "     AND SD2.D2_SERIE = '" + MV_PAR04 + "' " 
ENDIF	                                                     
If !empty(MV_PAR05)
	cQuery += "     AND SD2.D2_CLIENTE = '" + MV_PAR05 + "' "       
Endif              
If !empty(MV_PAR06)
	cQuery += "     AND SD2.D2_LOJA = '" + MV_PAR06 + "' "       
Endif
IF !EMPTY(MV_PAR01)
	cQuery += "     AND SD2.D2_EMISSAO = '" + DTOS(MV_PAR01) + "' " 
ENDIF       
cQuery += " ORDER BY SD2.D2_COD "
TCQUERY cQuery NEW ALIAS "QRY0"
nTotsRec := QRY0->(RECCOUNT())
ProcRegua(nTotsRec)               
cLinha := 'Produto'           + ';'
cLinha += 'Quantidade'        + ';'
cLinha += 'Vlr Unitario'      + ';'
cLinha += 'Num Docto'         + ';'
cLinha += 'Emissao'           + ';'
cLinha += 'NF. Original'      + ';'
cLinha += 'Num. de Serie'     + ';'
cLinha += 'Card-u'            + ';'
fWrite(nHandle, cLinha  + cCrLf)
While !QRY0->(Eof())
	IncProc()      
	cLinha := QRY0->D2_COD 										         + ';'
	cLinha += TRANSFORM(QRY0->D2_QUANT,"@E 999,999,999.99999")  	     + ';'
	cLinha += TRANSFORM(QRY0->D2_PRCVEN,"@E 999,999,999,999.99") 	     + ';'
	cLinha += QRY0->D2_DOC      									     + ';'
	cLinha += RIGHT(QRY0->D2_EMISSAO,2)+'/'+SUBSTR(QRY0->D2_EMISSAO,5,2)+'/'+LEFT(QRY0->D2_EMISSAO,4) + ';'
	cLinha += QRY0->D2_NFORI	     									 + ';'
	cLinha += QRY0->D2_NUMSERI										     + ';'
	cLinha += QRY0->ZZ4_CARDU											 + ';'
	fWrite(nHandle, cLinha  + cCrLf)
	QRY0->(DbSkip())
EndDo
fClose(nHandle)
//CpyS2T(cDirDocs+carquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
   //oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha 	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha 	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif   

dbSelectArea("SD2")
dbSetOrder(1)
Return .t.