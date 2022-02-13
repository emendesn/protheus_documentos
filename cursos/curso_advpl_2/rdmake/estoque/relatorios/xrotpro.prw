#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function XROTPRO()    
PRIVATE cPerg	 := "XROTPRO" 
Private _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))

ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQry1 :=""
Local cDirDocs:=__RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.F.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local nLin := 0
Local dData1 := dTos(ctod("01/01/1900"))
Local dData2 := dTos(dDatabase)
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

IF Select("QRY2") <> 0 
	DbSelectArea("QRY2")
	DbCloseArea()
Endif                 

IF Select("QRY3") <> 0 
	DbSelectArea("QRY3")
	DbCloseArea()
Endif   

dbSelectArea("SD1")
dbsetorder(1)		

DbSelectArea("SB1")
DbSetOrder(1)


If !Empty(mv_par01) 
	dData1 := Dtos(mv_par01)
EndIF              

If !Empty(mv_par02)
	dData2 := Dtos(mv_par02)
EndIF           


//cQuery := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_COD,D1_QUANT,D1_USERLGI,D1_USERLGA,D1_TES,D1_LOCAL "
cQuery := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_COD,D1_QUANT,D1_TES,D1_LOCAL,D1_CUSTO "
cQuery += " FROM " + RetSqlName("SD1") + " SD1 (NOLOCK) "
cQuery += " WHERE SD1.D_E_L_E_T_ = '' "
cQuery += " AND SD1.D1_EMISSAO >= '" + dData1 + "' "
cQuery += " AND SD1.D1_EMISSAO <= '" + dData2 + "' "
If !Empty(mv_par03)                            
	cQuery += " AND SD1.D1_COD >= '" + mv_par03 + "'  "
EndIf
If !Empty(mv_par04)                            
	cQuery += " AND SD1.D1_COD <= '" + mv_par04 + "' "
EndIf
If !Empty(mv_par05)             
	cQuery += " AND SD1.D1_FILIAL >= '"  + mv_par05 + "' "	
EndIf
If !Empty(mv_par06)                  
	cQuery += " AND SD1.D1_FILIAL <= '" + mv_par06 + "'  "
EndIf
If !Empty(mv_par07)           
	cQuery += " AND SD1.D1_LOCAL >= '" + mv_par07 + "'  "
EndIf                       
If !Empty(mv_par08)           
	cQuery += " AND SD1.D1_LOCAL <= '" + mv_par08 + "'  "
EndIf                       
TCQUERY cQuery NEW ALIAS "QRY1"  

//cQuery := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_COD,D2_QUANT,D2_USERLGI,D2_USERLGA,D2_TES,D2_LOCAL "
cQuery := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_COD,D2_QUANT,D2_TES,D2_LOCAL,D2_CUSTO1 "
cQuery += " FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
cQuery += " WHERE SD2.D_E_L_E_T_ = '' "           
cQuery += " AND SD2.D2_EMISSAO >= '" + dData1 + "' "  
cQuery += " AND SD2.D2_EMISSAO <= '" + dData2 + "' " 
If !Empty(mv_par03)                            
	cQuery += " AND SD2.D2_COD >= '" + mv_par03 + "'  "
EndIf
If !Empty(mv_par04)                            
	cQuery += " AND SD2.D2_COD <= '" + mv_par04 + "'  "
EndIf
If !Empty(mv_par05)             
	cQuery += " AND SD2.D2_FILIAL >= '"  + mv_par05 + "'  "	
EndIf
If !Empty(mv_par06)                  
	cQuery += " AND SD2.D2_FILIAL <= '" + mv_par06 + "'  "
EndIf
If !Empty(mv_par07)           
	cQuery += " AND SD2.D2_LOCAL >= '" + mv_par07 + "'  "
EndIf                       
If !Empty(mv_par08)           
	cQuery += " AND SD2.D2_LOCAL <= '" + mv_par08 + "'  "
EndIf                       
TCQUERY cQuery NEW ALIAS "QRY2"  

cQuery := " SELECT D3_FILIAL,D3_DOC,D3_COD,D3_LOCAL,D3_QUANT,D3_USUARIO,D3_ESTORNO,D3_TM,D3_CUSTO1 "
cQuery += " FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
cQuery += " WHERE SD3.D_E_L_E_T_ = '' AND SD3.D3_ESTORNO = '' "
cQuery += " AND SD3.D3_EMISSAO >= '" + dData1 + "' "
cQuery += " AND SD3.D3_EMISSAO <= '" + dData2 + "' "
If !Empty(mv_par03)                            
	cQuery += " AND SD3.D3_COD >= '" + mv_par03 + "'  "
EndIf
If !Empty(mv_par04)                            
	cQuery += " AND SD3.D3_COD <= '" + mv_par04 + "'  "
EndIf
If !Empty(mv_par05)             
	cQuery += " AND SD3.D3_FILIAL >= '"  + mv_par05 + "' "	
EndIf
If !Empty(mv_par06)                  
	cQuery += " AND SD3.D3_FILIAL <= '" + mv_par06 + "'  "
EndIf
TCQUERY cQuery NEW ALIAS "QRY3"  

cLinha := " ************* ROTATIVIDADE DE PRODUTOS NO PERIODO DE : " + DTOC(MV_PAR01) + " ATE " + DTOC(MV_PAR02)
fWrite(nHandle, cLinha  + cCrLf)
cLinha := " ************* ENTRADAS ******************* "
fWrite(nHandle, cLinha  + cCrLf)
cLinha := 'Filial'           + ';'
//cLinha += 'Documento'        + ';'
//cLinha += 'Serie'            + ';'
//cLinha += 'TES'              + ';'
cLinha += 'Produto'          + ';'
cLinha += 'Descricao'        + ';'
cLinha += 'Armazem'          + ';'
cLinha += 'Quantidade'       + ';'
cLinha += 'Valor'            + ';'
//cLinha += 'Usuario'          + ';'
fWrite(nHandle, cLinha  + cCrLf)

DbSelectArea("QRY1")
nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY1->(Eof())
	IncProc() 
	SB1->(DbSeek(Xfilial("SB1") + QRY1->D1_COD ) )
	cLinha := QRY1->D1_FILIAL           + ";" // FILIAL         
	//cLinha += QRY1->D1_DOC              + ";" // DOCUMENTO
	//cLinha += QRY1->D1_SERIE            + ";" // SERIE
	//cLinha += QRY1->D1_TES              + ";" // TES
	cLinha += QRY1->D1_COD              + ";" // PRODUTO
	cLinha += SB1->B1_DESC              + ";" // DESCRICAO DO PRODUTO
	cLinha += QRY1->D1_LOCAL            + ";" // ARMAZEM
	cLinha += Transform(QRY1->D1_QUANT  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO PRODUTO
	cLinha += Transform(QRY1->D1_CUSTO  , "@E 99,999,999,999.99") + ";" // QUANTIDADE DO PRODUTO
	//cLinha += IIF(!EMPTY(QRY1->D1_USERLGI),SUBSTR(EMBARALHA(QRY1->D1_USERLGI,1),1,15),"" )   + ";" // USUARIO
	fWrite(nHandle, cLinha  + cCrLf)						
	QRY1->(DBSKIP())
Enddo               
cLinha := " ************* SAIDAS ******************* "
fWrite(nHandle, cLinha  + cCrLf)


DbSelectArea("QRY2")
nTotsRec := QRY2->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY2->(Eof())
	IncProc() 
	SB1->(DbSeek(Xfilial("SB1") + QRY2->D2_COD ) )
	cLinha := QRY2->D2_FILIAL           + ";" // FILIAL         
	//cLinha += QRY2->D2_DOC              + ";" // DOCUMENTO
	//cLinha += QRY2->D2_SERIE            + ";" // SERIE
	//cLinha += QRY2->D2_TES              + ";" // TES
	cLinha += QRY2->D2_COD              + ";" // PRODUTO
	cLinha += SB1->B1_DESC              + ";" // DESCRICAO DO PRODUTO
	cLinha += QRY2->D2_LOCAL            + ";" // ARMAZEM
	cLinha += Transform(QRY2->D2_QUANT  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO PRODUTO
	cLinha += Transform(QRY2->D2_CUSTO1  , "@E 99,999,999,999.99") + ";" // QUANTIDADE DO PRODUTO
	//cLinha += IIF(!EMPTY(QRY2->D2_USERLGI),SUBSTR(EMBARALHA(QRY2->D2_USERLGI,1),1,15),"" )   + ";" // USUARIO
	fWrite(nHandle, cLinha  + cCrLf)						
	QRY2->(DBSKIP())
Enddo
cLinha := " ************* OUTRAS MOVIMENTACOES ******************* "
fWrite(nHandle, cLinha  + cCrLf)
               

DbSelectArea("QRY3")
nTotsRec := QRY3->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY3->(Eof())
	IncProc() 
	SB1->(DbSeek(Xfilial("SB1") + QRY3->D3_COD ) )
	cLinha := QRY3->D3_FILIAL           + ";" // FILIAL         
	//cLinha += QRY3->D3_DOC              + ";" // DOCUMENTO
	//cLinha += ""                        + ";" // SERIE
	//cLinha += QRY3->D3_TM              + ";" // TES
	cLinha += QRY3->D3_COD              + ";" // PRODUTO
	cLinha += SB1->B1_DESC              + ";" // DESCRICAO DO PRODUTO
	cLinha += QRY3->D3_LOCAL            + ";" // ARMAZEM
	cLinha += Transform(QRY3->D3_QUANT  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO PRODUTO
	cLinha += Transform(QRY3->D3_CUSTO1  , "@E 99,999,999,999.99") + ";" // QUANTIDADE DO PRODUTO
	//cLinha += QRY3->D3_USUARIO // IIF(!EMPTY(QRY1->D_USERLGI),SUBSTR(EMBARALHA(QRY1->D1_USERLGI,1),1,15),"" )   + ";" // USUARIO
	fWrite(nHandle, cLinha  + cCrLf)						
	QRY3->(DBSKIP())
Enddo
fClose(nHandle)
//CpyS2T(cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" )	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:SetVisible(.T.)
EndIf

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   
IF Select("QRY2") <> 0 
	DbSelectArea("QRY2")
	DbCloseArea()
Endif                 

IF Select("QRY3") <> 0 
	DbSelectArea("QRY3")
	DbCloseArea()
Endif   
dbSelectArea("SD2")
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
  
  AAdd(aRegs,{cPerg,"01","Data  de    : "  ,""   				,""  			,"mv_ch1",	"D",		08      ,0       ,		0 ,		"G"  ,		""          ,		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SBE",	""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"02","Data  ate   : "  ,""   				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		""          ,		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SBE",	""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"03","Produto de  : "  ,""   				,""  			,"mv_ch3",	"C",		15      ,0       ,		0 ,		"G"  ,		""			,		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",	""})
  AAdd(aRegs,{cPerg,"04","Produto ate : "  ,""   				,""  			,"mv_ch4",	"C",		15      ,0       ,		0 ,		"G"  ,		""			,		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"SB1",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"05","Filial de   : "  ,""   				,""  			,"mv_ch5",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"06","Filial ate  : "  ,""   				,""  			,"mv_ch6",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par06",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"07","Armazem de  : "  ,""   				,""  			,"mv_ch7",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par07",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"08","Armazem ate : "  ,""   				,""  			,"mv_ch8",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par08",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
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
