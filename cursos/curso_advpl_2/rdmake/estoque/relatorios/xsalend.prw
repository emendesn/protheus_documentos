#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function XSALEND()    
PRIVATE cPerg	 :="XSALEND"   
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))  
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local aSaldos := {}
Local nCustoUn  := 0
Local dOldData := dDataBase
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local ni:= 0
Local nAt := 0
Local cDivisao := ''
Local cData    := dtos(dDatabase)
Local xx := 0
Local cDiv := "01"
Local nLin := 0
Local cValdiv := ''            
Local cDivNeg := ''
Local cDescDiv := space(100)
Local cNF      := space(6)
Local cSerie   := space(3)
Local cCliente := space(6)
Local cLoja    := space(6)
Local dDtTaxa  := dDatabase 
Local nTaxaEnt := 0
Local aEntrada := {} 
Local nAt      := 0
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

dbSelectArea("SB2")
dbsetorder(1)		

DbSelectArea("SB1")
DbSetOrder(1)

cQuery := "SELECT SBF.BF_FILIAL,LTRIM(SBF.BF_PRODUTO) AS BF_PRODUTO,SB1.B1_DESC,SBF.BF_LOCAL,SBF.BF_LOCALIZ,"
cQuery += "SBF.BF_LOTECTL,SBF.BF_QUANT,SBF.BF_EMPENHO,B2_CM1,(B2_CM1 * BF_QUANT)'CUSTOTOTAL' "
cQuery += " FROM " + RetSqlName("SBF") + " SBF (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) "
cQuery += " ON SBF.BF_PRODUTO = SB1.B1_COD "
cQuery += " INNER JOIN " + RetSqlName("SB2") + " SB2 (NOLOCK) "
cQuery += " ON SBF.BF_PRODUTO = SB2.B2_COD AND "
cQuery += " SBF.BF_LOCAL = SB2.B2_LOCAL AND "
cQuery += " SBF.BF_FILIAL = SB2.B2_FILIAL "
cQuery += " WHERE SBF.D_E_L_E_T_  = '' AND "
cQuery += " SB1.D_E_L_E_T_ = '' AND "       
cQuery += " SB2.D_E_L_E_T_ = '' AND "
If !Empty(mv_par01)
	cQuery += " SBF.BF_LOCALIZ >= '" + mv_par01 + "' AND "
EndIf
If !Empty(mv_par02)                                       
	cQuery += " SBF.BF_LOCALIZ <= '" + mv_par02 + "' AND "
EndIf
If !Empty(mv_par03)                            
	cQuery += " SBF.BF_PRODUTO >= '" + mv_par03 + "' AND "
EndIf
If !Empty(mv_par04)                            
	cQuery += " SBF.BF_PRODUTO <= '" + mv_par04 + "' AND "
EndIf
If !Empty(mv_par05)             
	cQuery += " SBF.BF_FILIAL >= '"  + mv_par05 + "' AND "	
EndIf
If !Empty(mv_par06)                  
	cQuery += " SBF.BF_FILIAL <= '" + mv_par06 + "' AND "
EndIf
If !Empty(mv_par07)           
	cQuery += " SBF.BF_LOCAL >= '" + mv_par07 + "' AND "
EndIf                       
If !Empty(mv_par08)           
	cQuery += " SBF.BF_LOCAL <= '" + mv_par08 + "' AND "
EndIf                       
cQuery += " SB2.D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "QRY1"  

DbSelectArea("QRY1")
nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               

cLinha := 'Filial-Teste'     + ';'
cLinha += 'Produto'          + ';'
cLinha += 'Descricao'        + ';'
cLinha += 'Armazem'          + ';'
cLinha += 'Localizacao'      + ';'   
cLinha += 'Lote'		     + ';'
cLinha += 'Quantidade'       + ';'
cLinha += 'Empenho'          + ';'
cLinha += 'Vlr. Unitario'    + ';'
cLinha += 'Valor Total'      + ';'
fWrite(nHandle, cLinha  + cCrLf)
While !QRY1->(Eof())
	IncProc()
	aSaldos   := CalcEst(QRY1->BF_PRODUTO,QRY1->BF_LOCAL,dDatabase)
	nCustoUn  := aSaldos[2] / aSaldos[1] // custo total retornado da funcao / pela quantidade do saldo em estoque retornado da funcao
	cLinha := QRY1->BF_FILIAL           + ";" // FILIAL   
	
	If left(ALLTRIM(QRY1->BF_PRODUTO),1)== '0' 
	        cLinha += "'"+Upper(AllTrim(QRY1->BF_PRODUTO))       + ";"//(RTRIM(BF_PRODUTO,15,1))	
		Else
	    cLinha += Upper(AllTrim(QRY1->BF_PRODUTO))       + ";"//(RTRIM(BF_PRODUTO,15,1))
	Endif
	
	cLinha += QRY1->B1_DESC             + ";" // DESCRICAO DO PRODUTO
	cLinha += QRY1->BF_LOCAL            + ";" // ARMAZEM
	cLinha += QRY1->BF_LOCALIZ          + ";" // LOCALIZACAO
	cLinha += QRY1->BF_LOTECTL          + ";" // LOTE DO PRODUTO
	cLinha += Transform(QRY1->BF_QUANT  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO PRODUTO
	cLinha += Transform(QRY1->BF_EMPENHO, "@E 999,999,999.99999") + ";" // QUANTIDADE EMPENHADA
	cLinha += Transform( nCustoUn, "@E 99,999,999,999.99")  + ";" // VALOR UNITARIO
	cLinha += Transform( nCustoUn * QRY1->BF_QUANT , "@E 99,999,999,999.99")  + ";" // VALOR TOTAL
	fWrite(nHandle, cLinha  + cCrLf)						
	QRY1->(DBSKIP())
Enddo
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo,+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) // Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   


dbSelectArea("SB2")
dbSetOrder(1)
Return .t.

// **********************CRIACAO DA PERGUNTA
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
        //X1_GRUPO	X1_ORDEM	X1_PERGUNT				X1_PERSPA  		X1_PERENG 		X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP	X1_PICTURE	X1_IDFIL
         //	2     3			4						5		  		  6					7		8		9			  10			11			12		13			14			15			16			17			18			19			20			21			22			23			24			25			26			27			28			29			30			31			32			33			34			35			36			37 			38		39			40		41			42		43			44
  
  AAdd(aRegs,{cPerg,"01","Localizacao de : "  ,""   				,""  			,"mv_ch1",	"C",		15      ,0       ,		0 ,		"G"  ,		""          ,		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SBE",	""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"02","Localizacao ate: "  ,""   				,""  			,"mv_ch2",	"C",		15      ,0       ,		0 ,		"G"  ,		""          ,		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SBE",	""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"03","Produto de     : "  ,""   				,""  			,"mv_ch3",	"C",		15      ,0       ,		0 ,		"G"  ,		""			,		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",	""})
  AAdd(aRegs,{cPerg,"04","Produto ate    : "  ,""   				,""  			,"mv_ch4",	"C",		15      ,0       ,		0 ,		"G"  ,		""			,		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"05","Filial de      : "  ,""   				,""  			,"mv_ch5",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"06","Filial ate     : "  ,""   				,""  			,"mv_ch6",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par06",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"07","Armazem de     : "  ,""   				,""  			,"mv_ch7",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par07",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"08","Armazem ate    : "  ,""   				,""  			,"mv_ch8",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par07",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  
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