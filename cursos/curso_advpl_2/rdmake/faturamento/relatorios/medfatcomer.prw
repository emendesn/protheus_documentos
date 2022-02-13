#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMEDFAT    บAutor  ณLuiz Ferreira       บ Data ณ  26/02/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO MOSTRA MEDIA DE FATURAMENTO                      บฑฑ
ฑฑบ          ณ POR CLIENTE\REPRESENTANTE\REGIONAL                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function  MEDFAT ()
PRIVATE nCusult  :=0
PRIVATE nCusreps :=0
PRIVATE cPerg	 := padr("MEDFAT",10)
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
ValidPerg(cPerg) 

if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { ||Medfatcom() } ) 
Return .t.

return .T.

Static Function Medfatcom() 

Local cQry1  :=""
Local cQuery :=""
Local cQry2  :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)  
Local nTOTFat := 0
Local nTOTQtd := 0

u_GerA0003(ProcName()) 

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

DO CASE
Case MV_PAR09 == 1 
   cLinha := "CLIENTE;RAZAO SOCIAL;TOTALCLIENTE;FATOTAL;MษDIADEFAT"
Case MV_PAR09 == 2   
   cLinha := "VENDEDOR;NOME VENDEDOR;TOTALCLIENTE;FATOTAL;MษDIADEFAT;ARMAZEM"
OTHERWISE 
   cLinha := "REGIONAL;TOTAL CLIENTE;FAT TOTAL;MษDIADEFAT;ARMAZEM"
ENDCASE   

   
fWrite(nHandle, cLinha  + cCrLf)

IF Select("QRY1") <> 0 
DbSelectArea("QRY1")
DbCloseArea()
Endif       


//Faturamento Geral (busca valores de acordo com Parametros)
//Adiciona o total do faturamento 

cQuery1 := " SELECT   D2_CLIENTE 'CLIENTE'" 
cQuery1 += "         ,D2_LOCAL  'ARMAZEM'  
cQuery1 += "         ,(D2_TOTAL + D2_VALIPI)'FAT' "
cQuery1 += " FROM " +Retsqlname ("SD2") + "  SD2 (NOLOCK)  "  		   		
cQuery1 += " WHERE SD2.D2_CF IN ('5933', '6933', '5124','5102','5152','5106', '6102', '6106', '6108', '6110','5910','6910','5202','5405','5411')   "
cQuery1 += "  AND  SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"'  AND '"+dtos(MV_PAR02)+"'  "
cQuery1 += "  AND  SD2.D_E_L_E_T_ = ''  "
//cQuery1 += "  GROUP BY SD2.D2_CLIENTE,SD2.D2_LOCAL "
//cQuery1 += "  AND  SD2.D2_LOCAL LIKE '%"+alltrim(MV_PAR10)+"%' "     

//    memowrite('medfatcomer.sql',cQuery1) 
	TCQUERY cQuery1 NEW ALIAS "QRY1"
TcSetField("QRY1","EMISSAO","D")     //TRANFORMACAO DAS DATAS
                                                                         

procregua(reccount())
	DO WHILE !QRY1->(EOF()) 
		If QRY1->ARMAZEM $ (alltrim(MV_PAR10))
			        nTOTFat += QRY1->FAT   //Adicionando somat๓ria do faturamento na variavel
		Endif
      QRY1->(DBSKIP())            
    Enddo

IF Select("QRY2") <> 0 
DbSelectArea("QRY2")
DbCloseArea()
Endif       


if MV_PAR09 == 1
//Busca Valores por cliente 
cQuery2 := " SELECT SD2.D2_CLIENTE 'CABEC' , SA1.A1_NOME 'NOME' ,SUM(SD2.D2_TOTAL + SD2.D2_VALIPI ) 'TOTAL',SD2.D2_LOCAL 'ARMAZEM'  FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
cQuery2 += " INNER JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK) ON SF2.D_E_L_E_T_='' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SD2.D2_FILIAL = SF2.F2_FILIAL"
cQuery2 += " INNER JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON SA3.D_E_L_E_T_='' AND SA3.A3_COD = SF2.F2_VEND1 "
cQuery2 += " INNER JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON SA1.D_E_L_E_T_='' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA "
cQuery2 += " WHERE SD2.D2_CLIENTE BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery2 += "   AND SD2.D2_CF IN ('5933', '6933', '5124','5102','5152','5106', '6102', '6106', '6108', '6110','5910','6910','5202','5405','5411')   "
cQuery2 += "   AND SF2.F2_VEND1   BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery2 += "   AND SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery2 += "   AND SA3.A3_SUPER   BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
cQuery2 += "   AND SD2.D_E_L_E_T_=''
cQuery2 += " GROUP BY SD2.D2_CLIENTE,SD2.D2_LOCAL,SA1.A1_NOME  "
cQuery2 += " ORDER BY SUM(D2_TOTAL + D2_VALIPI) DESC  "

Elseif MV_PAR09 == 2
//Busca Valores por Vendedor
cQuery2 := " SELECT SF2.F2_VEND1  'CABEC' , SA3.A3_NOME 'NOME' , SUM(SD2.D2_TOTAL + SD2.D2_VALIPI ) 'TOTAL',SD2.D2_LOCAL 'ARMAZEM' FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
cQuery2 += " INNER JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK) ON SF2.D_E_L_E_T_='' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SD2.D2_FILIAL = SF2.F2_FILIAL"
cQuery2 += " INNER JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON SA3.D_E_L_E_T_='' AND SA3.A3_COD = SF2.F2_VEND1 "
cQuery2 += " WHERE SD2.D2_CLIENTE BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery2 += "   AND  SD2.D2_CF IN ('5933', '6933', '5124','5102','5152','5106', '6102', '6106', '6108', '6110','5910','6910','5202','5405','5411')   "
cQuery2 += "   AND SF2.F2_VEND1   BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery2 += "   AND SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery2 += "   AND SA3.A3_SUPER   BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
cQuery2 += "   AND SD2.D_E_L_E_T_=''
cQuery2 += " GROUP BY SF2.F2_VEND1,SD2.D2_LOCAL,SA3.A3_NOME   "
cQuery2 += " ORDER BY SUM(D2_TOTAL + D2_VALIPI) DESC  "

Elseif MV_PAR09 == 3
//Busca Valores por Regionais.
cQuery2 := " SELECT SA3.A3_SUPER 'CABEC' , SUM(SD2.D2_TOTAL + SD2.D2_VALIPI ) 'TOTAL',SD2.D2_LOCAL 'ARMAZEM'  FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
cQuery2 += " INNER JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK) ON SF2.D_E_L_E_T_='' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SD2.D2_FILIAL = SF2.F2_FILIAL"
cQuery2 += " INNER JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON SA3.D_E_L_E_T_='' AND SA3.A3_COD = SF2.F2_VEND1 "
cQuery2 += " WHERE SD2.D2_CLIENTE BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery2 += "   AND SD2.D2_CF IN ('5933', '6933', '5124','5102','5152','5106', '6102', '6106', '6108', '6110','5910','6910','5202','5405','5411')   "
cQuery2 += "   AND SF2.F2_VEND1   BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery2 += "   AND SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery2 += "   AND SA3.A3_SUPER   BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
cQuery2 += "   AND SD2.D_E_L_E_T_='' "
cQuery2 += " GROUP BY SA3.A3_SUPER,SD2.D2_LOCAL "
cQuery2 += " ORDER BY SUM(D2_TOTAL + D2_VALIPI) DESC  "
Endif    

//    memowrite('medfatcomer1.sql',cQuery2) 
	TCQUERY cQuery2 NEW ALIAS "QRY2"
TcSetField("QRY2","D2_EMISSAO","D")    //TRANFORMACAO DAS DATAS

//ATRIBUIR AS SOMATORIAS DAS QUERY EM VARIAVEIS

procregua(reccount())
 DO WHILE !QRY2->(EOF()) 
        DO CASE
          CASE MV_PAR09 == 1
		     	 If QRY2->ARMAZEM $ (alltrim(MV_PAR10))
		           cLinha :=QRY2->CABEC+";"+QRY2->NOME+";"+transform(QRY2->TOTAL , "@E 9,999,999,999.99")+";"+transform(nTOTFat ,"@E 9,999,999,999.99")+";"+transform(((QRY2->TOTAL/nTOTFat)*100) ,"@E 9,999,999,999.9999999 %") //  PEGAR A FATURAMENTO DO CLIENTE \ DIVIDO PELO TOTAL
			           fWrite(nHandle, cLinha  + cCrLf)
		    	 Endif
	      CASE MV_PAR09 == 2   
		  	     If QRY2->ARMAZEM $ (alltrim(MV_PAR10))
		    	   cLinha :=QRY2->CABEC+";"+QRY2->NOME+";"+transform(QRY2->TOTAL , "@E 9,999,999,999.99")+";"+transform(nTOTFat ,"@E 9,999,999,999.99")+";"+transform(((QRY2->TOTAL/nTOTFat)*100) ,"@E 9,999,999,999.9999999 %")+";"+QRY2->ARMAZEM //  PEGAR A FATURAMENTO DO CLIENTE \ DIVIDO PELO TOTAL
			       fWrite(nHandle, cLinha  + cCrLf)
			     Endif
	      OTHERWISE 
			     If QRY2->ARMAZEM $ (alltrim(MV_PAR10))
			       cLinha :=QRY2->CABEC+";"+transform(QRY2->TOTAL , "@E 9,999,999,999.99")+";"+transform(nTOTFat ,"@E 9,999,999,999.99")+";"+transform(((QRY2->TOTAL/nTOTFat)*100) ,"@E 9,999,999,999.9999999 %")+";"+QRY2->ARMAZEM //  PEGAR A FATURAMENTO DO CLIENTE \ DIVIDO PELO TOTAL
			       fWrite(nHandle, cLinha  + cCrLf)
			     Endif
        ENDCASE
      QRY2->(DBSKIP())            
   IncProc()
 Enddo


fClose(nHandle)
//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
RETURN
          
fClose(nHandle)
//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --

If ! ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf
                                	
RETURN


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j
                                                    
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
//	2			3			4						5		  		6				7			8		9			10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Data Emissao De?     ",""   			,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",	""	,""		,	""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"02","At้ a Emissao?:      ",""				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",	""	,""		,	""		,"",		""		,  "",	""		,	""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"03","Do Cliente?:         ",""				,""  			,"mv_ch3",	"C",        01      ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	""	,""		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"04","At้ o Cliente?:      ",""   			,""  			,"mv_ch4",	"C",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	""	,""		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"05","Do Vendedor?:        ",""				,""  			,"mv_ch5",	"C",        01      ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	""	,""		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"06","At้ o Vendedor?:     ",""   			,""  			,"mv_ch6",	"C",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	""	,""		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"07","Do Representante?:   ",""				,""  			,"mv_ch7",	"C",        01      ,0       ,		1 ,		"G"  ,		"",		"mv_par03",	""	,""		,	"1-Analitico"		,"",		""		,  "2-Sintetico",	"2-Sintetico"		,	"2-Sintetico"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"08","At้ o Representante: ",""   			,""  			,"mv_ch8",	"C",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	""	,""		,	"1-Yes"		,"",		""		,  "2-Nao",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"09","Cliente\Vendedor\Represen: ",""   	,""  			,"mv_ch9",	"C",		01      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",	"1-Cliente"	,"1-Cliente"		,	"1-Cliente"		,"2-Vendedor",		"2-Vendedor"		,  "2-Vendedor",	"2-No"		,	"2-No"	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})

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