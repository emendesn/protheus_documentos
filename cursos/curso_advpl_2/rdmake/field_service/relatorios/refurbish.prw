#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function XREFURB()    
PRIVATE cPerg	 :="XREFUR" 


    
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cCrLf		:=Chr(13)+Chr(10)
Local cArquivo	:=CriaTrab(,.f.)
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
Local cPath		:=AllTrim(GetTempPath())     
Local cQuery  	:= ''
Local cQry		
Local nLin    	:= 0
//Local _cOpe 	:= mv_par06
//Local _cLAB		:=Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par06,"ZZJ_LAB")
//Local _lvda		:=U_VLDPROD() 
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

u_GerA0003(ProcName())

nHandle := MsfCreate( _cArqTmp +".CSV",0)
                               
IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif

IF Select("QRY") <> 0 
	DbSelectArea("QRY")
	DbCloseArea()
Endif                         
                 

cQry := "SELECT ZZJ_CODPRO CODPRO, ZZJ_ALMPRO ALMPRO "
cQry += "FROM " + RetSqlName ("ZZJ") + " ZZJ "
cQry += "WHERE ZZJ_FILIAL='" + xFilial("ZZJ") + "' AND ZZJ_OPERA = '" + mv_par06 + "' " 


TCQUERY cQry NEW ALIAS "QRY"  
	   
If EMPTY(QRY->CODPRO).And. EMPTY(QRY->ALMPRO)
	ApMsgInfo("Não foi cadastrar a operacao para OS. ","Operacao não localizada!")
   Return
EndIf
	
cQuery := " SELECT     LEFT(D3_OP, 6) 'D3_OP' , ZZ3_IMEI, D3_COD, TIPO = CASE WHEN D3_CF = 'PR0' THEN 'PROD.ACABADO' WHEN D3_CF = 'RE1' AND " 
cQuery += "                      D3_COD = 'MOD1011' THEN 'MAO-DE-OBRA' ELSE 'PECAS' END, ZZ3_FASE1, D3_TM, D3_CF, D3_LOCAL, D3_EMISSAO 'EMISSAOPROD' "
cQuery += "                        , D3_QUANT, D3_CUSTO1, FORNECEDOR, CLIENTE, ZZ4_EMDT  'ENTMASSDT', ZZ4_NFENR, ZZ4_NFESER, "
cQuery += "                       F1_DTDIGIT  'EMISSANFE', ZZ4_SMDT  'SAIMASSDT', ZZ4_PV, CLIENTE_SAI, ZZ4_NFSNR, ZZ4_NFSSER, "
cQuery += "                       ZZ4_NFSDT   'DTNFSSAIDA' "
cQuery += " FROM " + RETSQLNAME("SD3") + " (NOLOCK) INNER JOIN "
cQuery += "                           (SELECT     C2_NUM, C2_APRATU1 "
cQuery += "                             FROM " + RETSQLNAME("SC2") + " (NOLOCK)  "
cQuery += "                             WHERE   C2_FILIAL='" + xFilial("SC2") + "' AND   C2_QUJE > 0.00 AND D_E_L_E_T_ = '') AS SC2 ON LEFT(C2_NUM, 6) = LEFT(D3_OP, 6) INNER JOIN "
cQuery += "                           (SELECT     MAX(R_E_C_N_O_) AS RECNO, ZZ3_NUMOS, ZZ3_IMEI, ZZ3_FASE1 "
cQuery += "                             FROM " + RETSQLNAME("ZZ3")
cQuery += "                             WHERE  ZZ3_FILIAL='" + xFilial("ZZ3") + "'  AND    D_E_L_E_T_ = '' AND ZZ3_ENCOS = 'S' AND ZZ3_LAB = '1'  AND ZZ3_ESTORN<>'S' "
cQuery += "                             GROUP BY ZZ3_NUMOS, ZZ3_IMEI, ZZ3_FASE1) AS ZZ3 ON LEFT(ZZ3_NUMOS, 6) = LEFT(D3_OP, 6) INNER JOIN "
cQuery += "                           (SELECT     ZZ4_FILIAL, ZZ4_OS, ZZ4_IMEI, ZZ4_CODCLI + '/' + ZZ4_LOJA AS CLIENTE, ZZ4_EMDT, ZZ4_NFENR, ZZ4_NFESER, F1_DTDIGIT, FORNECEDOR, "
cQuery += "                                                    ZZ4_SMDT, ZZ4_PV, ZZ4_NFSNR, ZZ4_NFSSER, ZZ4_NFSDT, ZZ4_NFSCLI + '/' + ZZ4_NFSLOJ AS CLIENTE_SAI "
cQuery += "                             FROM " + RETSQLNAME("ZZ4") + " INNER JOIN "
cQuery += "                                                        (SELECT     F1_FILIAL, F1_DOC, F1_SERIE, F1_DTDIGIT, F1_FORNECE + '/' + F1_LOJA AS FORNECEDOR "
cQuery += "                                                          FROM " + RETSQLNAME("SF1")
cQuery += "                                                          WHERE   F1_FILIAL='" + xFilial("SF1") + "' AND   D_E_L_E_T_ = '' AND F1_TIPO = 'N') AS SF1 ON ZZ4_NFENR = F1_DOC AND ZZ4_NFESER = F1_SERIE "
cQuery += "                             WHERE    ZZ4_FILIAL='" + xFilial("ZZ4") + "'  AND  D_E_L_E_T_ = '' AND ZZ4_OPEBGH = '" + mv_par06 + "'   " 
//Acrescentado o parametro 5 para filtrar Op faturadas sim, nao ou todas. Edson Rodrigues 11/03/10
If  !mv_par05==3
   if mv_par05 == 1
	   cQuery += " AND ZZ4_NFSNR <> ' ' " 
   Elseif mv_par05 == 2
       cQuery += " AND ZZ4_NFSNR = ' ' " 
   Endif
Endif   
cQuery += " ) AS ZZ4 ON LEFT(ZZ4_OS, 6) = LEFT(D3_OP, 6) "
cQuery += " WHERE  D3_FILIAL='" + xFilial("SD3") + "' AND   D_E_L_E_T_ = '' AND D3_ESTORNO <> 'S' " 
If !Empty(mv_par01)
	cQuery += " AND D3_EMISSAO >= '" +DTOS(mv_par01) + "' " 
endif
If !Empty(mv_par02)
	cQuery += " AND D3_EMISSAO <= '" +DTOS(mv_par02) + "' " 
endif
If !Empty(mv_par03)
	cQuery += " AND LEFT(D3_OP, 6) >= '" +mv_par03 + "' " 
endif
If !Empty(mv_par04)
	cQuery += " AND LEFT(D3_OP, 6) <= '" +mv_par04 + "' " 
endif

    
   

TCQUERY cQuery NEW ALIAS "QRY0"  
                                             
/* cabecalho do relatorio */
cLinha := "0S/OP" + ';'
cLinha += "ZZ3_IMEI" + ';' 	
cLinha += "D3_COD" + ';'	
cLinha += "TIPO" + ';'	
cLinha += "ZZ3_FASE1" + ';'
cLinha += "D3_TM" + ';'
cLinha += "D3_CF" + ';'
cLinha += "D3_LOCAL" + ';'
cLinha += "EMISSAOPROD" + ';'
cLinha += "D3_QUANT" + ';'
cLinha += "D3_CUSTO1" + ';'
cLinha += "FORNECEDOR" + ';'
cLinha += "CLIENTE" + ';'
cLinha += "ENTMASSDT" + ';'
cLinha += "ZZ4_NFENR" + ';'
cLinha += "ZZ4_NFESER" + ';'
cLinha += "EMISSANFE" + ';'
cLinha += "SAIMASSDT" + ';'
cLinha += "ZZ4_PV" + ';'
cLinha += "CLIENTE_SAI" + ';'
cLinha += "ZZ4_NFSNR" + ';'
cLinha += "ZZ4_NFSSER" + ';'
cLinha += "DTNFSSAIDA" + ';'
fWrite(nHandle, cLinha  + cCrLf)
/* ------ FIM DO CABECALHO DO RELATORIO -------- */ 
nTotsRec := QRY0->(RECCOUNT())
ProcRegua(nTotsRec)               

Do  While ! QRY0->(EOF())
	IncProc()  
	clinha := ''
	cLinha += QRY0->D3_OP 		+ ';'
	cLinha += QRY0->ZZ3_IMEI 	+ ';' 	
	cLinha += QRY0->D3_COD 		+ ';'	
	cLinha += QRY0->TIPO		+ ';'	
	cLinha += QRY0->ZZ3_FASE1 	+ ';'
	cLinha += QRY0->D3_TM 		+ ';'
	cLinha += QRY0->D3_CF		+ ';'
	cLinha += QRY0->D3_LOCAL	+ ';'
	cLinha += Right(QRY0->EMISSAOPROD,2)+'/'+Substr(QRY0->EMISSAOPROD,5,2)+'/'+left(QRY0->EMISSAOPROD,4) 	+ ';'
	cLinha += Transform(QRY0->D3_QUANT , "@E 999999999")	+ ';'
	cLinha += Transform(QRY0->D3_CUSTO1  , "@E 999,999,999.99")	+ ';'
	cLinha += QRY0->FORNECEDOR	+ ';'
	cLinha += QRY0->CLIENTE		+ ';'
	cLinha += Right(QRY0->ENTMASSDT,2)+'/'+Substr(QRY0->ENTMASSDT,5,2)+'/'+left(QRY0->ENTMASSDT,4)	+ ';'
	cLinha += QRY0->ZZ4_NFENR	+ ';'
	cLinha += QRY0->ZZ4_NFESER	+ ';'
	cLinha += Right(QRY0->EMISSANFE,2)+'/'+Substr(QRY0->EMISSANFE,5,2)+'/'+left(QRY0->EMISSANFE,4)	+ ';'
	cLinha += Right(QRY0->SAIMASSDT,2)+'/'+Substr(QRY0->SAIMASSDT,5,2)+'/'+left(QRY0->SAIMASSDT,4)	+ ';'
	cLinha += QRY0->ZZ4_PV		+ ';'
	cLinha += QRY0->CLIENTE_SAI	+ ';'
	cLinha += QRY0->ZZ4_NFSNR	+ ';'
	cLinha += QRY0->ZZ4_NFSSER	+ ';'
	cLinha += Right(QRY0->DTNFSSAIDA,2)+'/'+Substr(QRY0->DTNFSSAIDA,5,2)+'/'+left(QRY0->DTNFSSAIDA,4)	+ ';'
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
dbSelectArea("SB2")
dbSetOrder(1)
Return .t.