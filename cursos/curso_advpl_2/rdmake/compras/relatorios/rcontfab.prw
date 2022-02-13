#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function RCONTFAB()    
PRIVATE cPerg	 :="XCONFAB"
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))     
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local aStru := SE1->(dbStruct())
Local cDataE1    := dtos(dDatabase)
Local cDataE2    := dtos(dDatabase)
Local nLin := 0
Local nMaxant := 0
Local cMOTIVO := ''            
Local cAliasTOP	:= "TMPZZE"               
Local cValMot := ''  
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

If !Empty(MV_PAR03)
	cDataE1 = Dtos(MV_PAR03)
EndIf
If !Empty(MV_PAR04)
	cDataE2 = Dtos(MV_PAR04)
EndIf

Private dBaixa := dDataBase                  

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
/*--------         Seleciona SALDO DOS FABRICANTES --------*/
IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   
dbSelectArea("ZZE")
DbSetOrder(1)
dbSelectArea("SA2")
DbSetOrder(1)
DbSelectArea("SD1")
DbSetOrder(1)
cQuery := "SELECT * "
cQuery += "  FROM " +	RetSqlName("ZZE") + " ZZE (NOLOCK) WHERE " 
cQuery += "   ZZE.D_E_L_E_T_ =  ' ' "           
IF !Empty(mv_par01)
	cQuery += " AND ZZE_COD >='" + mv_par01 + "' "
Endif     
IF !Empty(mv_par02)
	cQuery += " AND ZZE_COD <='" + mv_par02 + "' "
Endif     
If !Empty(mv_par03)
	cQuery += " AND ZZE_EMISSA >= '" + cDataE1 + "'"
ENDIF	                                    
IF !Empty(mv_par04)
	cQuery += " AND ZZE_EMISSA <= '" + cDataE2 + "'"
EndIF	
IF !Empty(mv_par05)
	cQuery += " AND ZZE_FORNEC = '" + MV_PAR05 + "'"
EndIF	                                   
If !Empty(mv_par06)
	cQuery += " AND ZZE_LOJA = '" + MV_PAR06 + "'"
ENDIF	                                    
cQuery += " ORDER BY ZZE_DOC, ZZE_SERIE, ZZE_FORNEC,ZZE_LOJA,ZZE_COD"
	
TCQUERY cQuery NEW ALIAS "QRY1"

ProcRegua(Reccount())                                    
cLinha := 'N.Fiscal' + ";" + 'Serie' + ";" + 'Emissao' + ';' +'Cod. Forn.' + ';'  + 'Fornecedor' +  ';'+ 'Loja'+ ';' + 'Cod Prod. ' + ';' + 'Desc.Produto' + ';'+ 'Quantidade' + ";" + ' Vlr. Unitario' + ';' + 'Tab.Politica' + ';' + ' Dif.Unit.' + ';' + 'Dif. Total'
fWrite(nHandle, cLinha  + cCrLf)
While  !Eof() 
	IncProc()
	SA2->(DBSEEK(XFILIAL("SA2") + QRY1->ZZE_FORNEC  + QRY1->ZZE_LOJA))     
	SB1->(DBSEEK(XFILIAL("SB1") + QRY1->ZZE_COD  )) 		           
	cLinha := ''
	cLinha += QRY1->ZZE_DOC   + ";"
	cLinha += QRY1->ZZE_SERIE + ";"    
	cLinha += DTOC(STOD(QRY1->ZZE_EMISSA)) + ';'                          
	cLinha += QRY1->ZZE_FORNEC + ';' 
	cLinha += ALLTRIM(SA2->A2_NREDUZ)+ ";" 
	cLinha += QRY1->ZZE_LOJA + ";" 	
	cLinha += QRY1->ZZE_COD + ";" 	                     
	cLinha += SUBSTR(SB1->B1_DESC,1,60) + ";" 	                     		
	cLinha += Transform(QRY1->ZZE_QUANT, "@E 99,999,999.99")+";" 
	cLinha += Transform(QRY1->ZZE_VUNIT, "@E 99,999,999.99999")+";" 
	cLinha += Transform(QRY1->ZZE_TABPOL, "@E 99,999,999.99999")+";" 
	cLinha += Transform(QRY1->ZZE_DIFUN, "@E 99,999,999.99999")+";" 
	cLinha += Transform(QRY1->ZZE_DIFTOT, "@E 99,999,999.99999")+";" 
	fWrite(nHandle, cLinha  + cCrLf)
	DbSelectArea("QRY1")
	dbSkip()
Enddo                                 
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

//CRIACAO DA PERGUNTA
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
        //X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
         //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  AAdd(aRegs,{cPerg,"01","Produto de     : "        ,"Produto de    "   			    ,"Produto de    "  			,"mv_ch1",	"C",		15      ,0       ,		0 ,		"G"  ,		"",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",			""})
  AAdd(aRegs,{cPerg,"02","Produto ate    : "        ,"Produto ate   "   			    ,"Produto Ate   "  			,"mv_ch2",	"C",		15      ,0       ,		0 ,		"G"  ,		"",		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",			""})
  AAdd(aRegs,{cPerg,"03","Dt.Emissao de  : "        ,"Dt.Emissao de "   				,"Dt.Emissao de "  			,"mv_ch3",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"04","Dt.Emissao ate : "        ,"Dt.Emissao ate"   				,"Dt.Emissao ate"  			,"mv_ch4",	"D",		08      ,0       ,		0 ,		"G"  ,		"",		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"05","Fornecedor     : "        ,"Fornecedor    " 			        ,"Fornecedor    "  		   	,"mv_ch5",	"C",		06      ,0       ,		0 ,		"G"  ,		"",		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SA2",			""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"06","Loja           : "        ,"Loja          "   		    	,"Loja          " 			,"mv_ch6",	"C",		02      ,0       ,		0 ,		"G"  ,		"",		"mv_par06",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                   
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