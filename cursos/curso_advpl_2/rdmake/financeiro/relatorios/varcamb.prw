#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function VarCamb()    
PRIVATE cPerg	 :="XVARCA"     
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
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
Local cDescDiv  := space(100)
Local cNF       := space(6)
Local cSerie    := space(3)
Local cCliente  := space(6)
Local cLoja     := space(6)
Local dDtTaxa   := dDatabase 
Local nTaxaEnt  := 0
Local aEntrada  := {} 
Local nAt       := 0     
Local nQuant    := 0
Local nQuantAux := 0
Local cItem     := 0
Local cProd     := space(15)
Local xx        := 0
Local lImpItem  := .t.
Local aSaldoE   := {}
Local aItem     := {} 
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

u_GerA0003(ProcName())

IF Select("QRY1") <> 0 
	DbSelectArea("QRY1")
	DbCloseArea()
Endif   

dbSelectArea("SF2")
dbsetorder(1)		

DbSelectArea("SF1")
DbSetOrder(1)

cFilDe  := MV_PAR03
cFilAte := MV_PAR04
                  
cDivisao := MV_PAR01          
If Len(cDivisao) < 16 // nao quer todas as Divisoes  
	For xx = 1 to LEN(cDivisao)
		cValida := Substr(cDivisao,xx,1)    
		cValida := u_VerDivisao(cValida)
		if xx == Len(cDivisao)
			cVALDIV += cValida+ "|"                      
		ELSE
			cvaldiv += cValida+"|"			
		endIF
	Next          
EndIF           
	
cQuery := "SELECT D2_FILIAL,D2_COD,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_VALIPI,D2_PRCVEN,D2_TOTAL,D2_VALICM,D2_CUSTO1,D2_VALIMP5,D2_VALIMP6,D2_BRICMS,D2_PEDIDO,D2_ITEM,D2_QUANT,"
cQuery += "D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_EMISSAO,D1_TOTAL,D1_VALICM,D1_CUSTO,D1_FILIAL,"
cQuery += "D1_VALICM,D1_CUSTO,D1_VALIMP5,D1_VALIMP6,D1_VALIPI,D1_ITEM,D1_QUANT,D1_DTDIGIT,"
cQuery += "C5_DIVNEG,C5_MOEDA,C5_TXMOEDA"
cQuery += " FROM " + RetSqlName("SD2") + " SD2 (nolock) "
cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 (nolock) "
cQuery += " ON SD2.D2_PEDIDO = SC5.C5_NUM  "
cQuery += " AND SC5.C5_FILIAL  = SD2.D2_FILIAL "
cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 (nolock) "
cQuery += " ON SD1.D1_DTDIGIT < SD2.D2_EMISSAO "
cQuery += "  AND SD1.D1_COD 	= SD2.D2_COD    "
cQuery += "  AND SD1.D1_FILIAL = SD2.D2_FILIAL  "
cQuery += " WHERE  SD2.D_E_L_E_T_ = ' ' "        
cQuery += " AND SD1.D_E_L_E_T_ = ' ' "                     
cQuery += " AND SC5.D_E_L_E_T_ = ' ' " 
cQuery += "  AND D1_QUANT > 0 "   
cQuery += " AND SC5.C5_MOEDA > 1 " 
cQuery += " AND SD1.D1_NFORI = '' "   
cQuery += " AND SD1.D1_SERIORI = '' "   
IF !EMPTY(MV_PAR02)
	cQuery += " AND D2_EMISSAO >= '" + DtoS(mv_par02) + "' "
EndIf	
IF !EMPTY(MV_PAR03)
	cQuery += " AND D2_EMISSAO <= '" + DtoS(mv_par03) + "' "
EndIf	
If !Empty(mv_par04)
	cQuery += " AND  D2_FILIAL >= '" + MV_PAR04 + "' "
EndIF	                                               
If !Empty(mv_par05)
	cQuery += " AND  D2_FILIAL <= '" + MV_PAR05 + "' "
EndIF	             
cQuery += " ORDER BY SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_CLIENTE,D2_LOJA,D2_COD,D1_DTDIGIT,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA"
TCQUERY cQuery NEW ALIAS "QRY1"  
DbSelectArea("QRY1")
nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               
cNf      := "@#@$%"
cSerie   := "@#$"
cCliente := "@#$%&*"
cLoja    := "#%"                
cLinha := '  '               + ';'
cLinha += '  '               + ';'
cLinha += 'Qtde Faturada'    + ';'
cLinha += 'Valor Faturado'   + ';'
cLinha += 'Dolar Ptax Fat.'  + ';'   
cLinha += 'ICMS'		     + ';'
cLinha += 'IPI'              + ';'
cLinha += 'PIS/COFINS'       + ';'
cLinha += 'NF Entrada'       + ';'
cLinha += 'Ptax Entrada'     + ';'
cLinha += 'Custo Unitario'   + ';' 
cLinha += 'ICMS'		     + ';'
cLinha += 'IPI'              + ';'
cLinha += 'PIS/COFINS'       + ';'
cLinha += 'Fat. Liq. em USD' + ';'
cLinha += 'Custo em USD'
fWrite(nHandle, cLinha  + cCrLf)
cProd     := "@#@"
cItem     := "@#"
lZerouSaldo := .f.
While !QRY1->(Eof())
	IncProc()
	If Len(cDivisao) < 16 // nao quer todas as Divisoes  
		If !SC5->C5_DIVNEG $ cValdiv
			Dbskip()
			Loop
		EndIf
	EndIF  
	If 	cNf      <> QRY1->D2_DOC    .OR. cSerie   <> QRY1->D2_SERIE  .OR. ;
		cCliente <> QRY1->D2_CLIENTE .OR. cLoja    <> QRY1->D2_LOJA 
		if cNf  <> "@#@$%" // pula uma linha entre as NFs
			cLinha := ' ' + ';'
			fWrite(nHandle, cLinha  + cCrLf)			
		endif                                                              
		IF Select("QRY2") <> 0 
			DbSelectArea("QRY2")
			DbCloseArea()
		Endif                 
		cQuery := "SELECT SUM(D2_VALIMP5) COFINS,SUM(D2_VALIMP6) PIS "
		cQuery += "FROM " + RETSQLNAME('SD2') + " SD2 (NOLOCK) "
		cQuery += "WHERE SD2.D_E_L_E_T_ = '' AND "
		cQuery += "SD2.D2_DOC = '" 		+ QRY1->D2_DOC 		+ "' AND "
		cQuery += "SD2.D2_SERIE = '" 	+ QRY1->D2_SERIE 	+ "' AND "		
		cQuery += "SD2.D2_CLIENTE = '" 	+ QRY1->D2_CLIENTE 	+ "' AND "
		cQuery += "SD2.D2_LOJA = '" 	+ QRY1->D2_LOJA 	+ "' AND "
		cQuery += "SD2.D2_FILIAL = '" 	+ QRY1->D2_FILIAL 	+ "' "
		TCQUERY cQuery NEW ALIAS "QRY2"  
		QRY2->(DbGotop())
		SF2->(DBSEEK(QRY1->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
		cNf      := QRY1->D2_DOC 
		cSerie   := QRY1->D2_SERIE 
		cCliente := QRY1->D2_CLIENTE 
		cLoja    := QRY1->D2_LOJA                                          
		lImpItem := .T.
		cProd := "!@!@!@!"
		lZerouSaldo := .f.
		aItem := {}
	EndIF   
	nQuant    := 0
	nQuantaux := 0
	xx        := 0
	Do While ! QRY1->(Eof()) .and. cNf      = QRY1->D2_DOC  .and. ;
			cSerie   = QRY1->D2_SERIE .AND. ;
			cCliente = QRY1->D2_CLIENTE .AND. ; 
			cLoja    = QRY1->D2_LOJA 
			If cProd <> QRY1->D2_COD
				cProd  := QRY1->D2_COD
				nquant := QRY1->D2_QUANT
				cItem  := QRY1->D2_ITEM
				lZerouSaldo := .F.
				aadd(aItem,{ QRY1->D2_COD + QRY1->D2_ITEM })
			Else
				If cItem <> QRY1->D2_ITEM
					xx := Ascan(aItem,{ |X| x[1] = QRY1->D2_COD + QRY1->D2_ITEM  })
					If xx = 0 // Não achou o Produto + item, entao ainda nao imprimiu
						aadd(aItem,{ QRY1->D2_COD + QRY1->D2_ITEM })
						nquant := QRY1->D2_QUANT
						cItem  := QRY1->D2_ITEM
						lZerouSaldo := .F.
					Else // ja imprimiu esse item e nao deve imprimir mais
						lZerouSaldo := .T.						
					Endif	
				EndIF	
			EndIf    
			xx := Ascan(aSaldoE, { |X| x[1]= QRY1->D1_DOC .AND. X[2] = QRY1->D1_SERIE .AND. X[3] = QRY1->D1_FORNECE .AND. X[4] = QRY1->D1_LOJA .AND. X[5] = QRY1->D2_COD } )
			IF XX = 0
				AADD (aSaldoE,{QRY1->D1_DOC,QRY1->D1_SERIE,QRY1->D1_FORNECE,QRY1->D1_LOJA,QRY1->D2_COD,QRY1->D1_QUANT})
			ENDIF                                                                                                     
			XX := Ascan(aSaldoE, { |X| X[5] = QRY1->D2_COD .and. x[6] > 0 } )
			If XX > 0 
				If  aSaldoE[xx,6] >= nQuant // se o saldo da NF de entrada e maior que o saldo da saida
					nQuantAux := nQuant// guarda quanto conseguiu utilizar na saida do saldo da NF de entrada
					aSaldoE[xx,6] -= nquant // baixa o saldo da saida na NF de entrada
					nQuant    := 0 // guarda quanto falta usar de saldo da NF de saida
				else              // se o salda da entrada e menor que o da saida
					nQuant    -= aSaldoE[xx,6] // guarda quanto falta usar de saldo da NF de saida
					nQuantAux := aSaldoE[xx,6] // guarda quanto conseguiu utilizarna saida do saldo da NF de entrada
					aSaldoE[xx,6] := 0 // zera o saldo da entrada
				Endif	    
				SF1->(DBSEEK((XFilial("SF1")+aSaldoe[xx,1]+aSaldoe[xx,2]+aSaldoe[xx,3]+aSaldoe[xx,4])))
				SD1->((DBSEEK((XFilial("SD1")+aSaldoe[xx,1]+aSaldoe[xx,2]+aSaldoe[xx,3]+aSaldoe[xx,4]+aSaldoe[xx,5]))))
			Endif
			
			//nAt := Ascan(aEntrada,{ |x| x[1] = cNf+cSerie+cCliente+cLoja+QRY1->D2_ITEM})
			//If nAt = 0
			//	aAdd(aEntrada,{cNf+cSerie+cCliente+cLoja+QRY1->D2_ITEM } )
				
				
				dDtTaxa  := Iif(!Empty(SF1->F1_XDTDI),SF1->F1_XDTDI,SD1->D1_EMISSAO)
			   //	DDTTAXA:= CTOD(RIGHT(DDTTAXA,2)+'/'+SUBSTR(DDTTAXA,5,2)+'/'+LEFT(DDTTAXA,4))
				nTaxaEnt := Posicione("SM2",1,DTOS(dDtTaxa),"M2_MOEDA"+Str(QRY1->C5_MOEDA,1)) 
				If nTaxaent = 0 
					If SM2->M2_MOEDA2 > 0
						nTaxaEnt  := SM2->M2_MOEDA2
					EndIf
				endIf
				If lImpItem // imprime os dados da capa da NF de saida/entrada
					cLinha := QRY1->D2_DOC                                       + ";" // NF DE VENDA
					cLinha += QRY1->D2_SERIE                                     + ";" // SERIE NF VENDA 
					cLinha += '' + ';' 
					cLinha += Transform(SF2->F2_VALFAT, "@E 99,999,999,999.99") + ";" // VALOR FATURADO
					cLinha += Transform(QRY1->C5_TXMOEDA,"@E 999.9999")          + ";" // TAXA PTAX FATURADA
					cLinha += Transform(SF2->F2_VALICM, "@E 99,999,999,999.99") + ";" // VALOR ICMS FATURADO
					cLinha += Transform(SF2->F2_VALIPI, "@E 99,999,999,999.99") + ";" // VALOR IPI  FATURADO		
					cLinha += Transform(QRY2->(PIS+COFINS), "@E 99,999,999,999.99") + ";" // VALOR PIS/COFINS FATURADO
					cLinha += Transform( (SD1->D1_TOTAL / SD1->D1_QUANT )* nQuantAux, "@E 99,999,999,999.99")  + ";" // NF DE ENTRADA
					cLinha += ''  + ";" // TAXA PTAX ENTRADA
					cLinha += ''  + ";" // CUSTO ENTRADA
					cLinha += ''  + ";" // VALOR ICMS ENTRADA
					cLinha += ''  + ";" // VALOR IPI  ENTRADA
					cLinha += ''  + ";" // VALOR PIS/COFINS ENTRADA
					cLinha += Transform(SF2->(F2_VALFAT-F2_VALICM-F2_VALIPI)-QRY2->(PIS+COFINS), "@E 99,999,999,999.99") + ";" // VALOR LIQ.FATURADO
					cLinha += ''  + ";" // CUSTO EM USD							
					fWrite(nHandle, cLinha  + cCrLf)
					lImpItem := .F.
				EndIF                                                                                
				If nQuantAux > 0 .and. !lZerouSaldo                     
				    // /QRY1->D2_QUANT*nQuantAux
					cLinha := QRY1->D2_DOC                                       + ";" // NF DE VENDA
					cLinha += QRY1->D2_SERIE                                     + ";" // SERIE NF VENDA 
					cLinha += Transform(nQuantAux, "@E 999,999,999.99999") + ";" // QTDE FATURADO		
					cLinha += Transform(QRY1->D2_TOTAL/QRY1->D2_QUANT*nQuantAux, "@E 99,999,999,999.99") + ";" // VALOR FATURADO
					cLinha += Transform(QRY1->C5_TXMOEDA,"@E 999.9999")          + ";" // TAXA PTAX FATURADA
					cLinha += Transform(QRY1->D2_VALICM, "@E 99,999,999,999.99") + ";" // VALOR ICMS FATURADO
					cLinha += Transform(QRY1->D2_VALIPI, "@E 99,999,999,999.99") + ";" // VALOR IPI  FATURADO		
					cLinha += Transform((QRY1->D2_VALIMP5+QRY1->D2_VALIMP6), "@E 99,999,999,999.99") + ";" // VALOR PIS/COFINS FATURADO
					cLinha += Transform( (SD1->D1_TOTAL / SD1->D1_QUANT )* nQuantAux, "@E 99,999,999,999.99")  + ";" // NF DE ENTRADA
					cLinha += Transform(nTaxaEnt,"@E 999.9999")                  + ";" // TAXA PTAX ENTRADA
					cLinha += Transform((SD1->D1_CUSTO / SD1->D1_QUANT )* nQuantAux  , "@E 99,999,999,999.99")  + ";" // CUSTO ENTRADA
					cLinha += Transform((SD1->D1_VALICM / SD1->D1_QUANT )* nQuantAux , "@E 99,999,999,999.99") + ";" // VALOR ICMS ENTRADA
					cLinha += Transform((SD1->D1_VALIPI / SD1->D1_QUANT )* nQuantAux , "@E 99,999,999,999.99") + ";" // VALOR IPI  ENTRADA
					cLinha += Transform((QRY1->(D1_VALIMP5+D1_VALIMP6) /  SD1->D1_QUANT) * nQuantAux, "@E 99,999,999,999.99") + ";" // VALOR PIS/COFINS ENTRADA
					cLinha += Transform(QRY1->((D2_TOTAL-D2_VALICM-D2_VALIPI-D2_VALIMP5-D2_VALIMP6)/C5_TXMOEDA), "@E 99,999,999,999.99") + ";" // VALOR LIQ.FATURADO
					cLinha += Transform((( QRY1->(D1_TOTAL-D1_VALICM-D1_VALIPI-D1_VALIMP5-D1_VALIMP6)/SD1->D1_QUANT  ) * nQuantAux / nTaxaEnt), "@E 99,999,999,999.99") + ";" // CUSTO EM USD		
					cLinha += SD1->D1_DOC + ' ' + SD1->D1_SERIE			
					fWrite(nHandle, cLinha  + cCrLf)						
					nQuantAux := 0    
					If nQuant = 0 // zerou o saldo da NF de saida
						lZerouSaldo := .t.
					Endif
				Endif
			//EndIf	
			QRY1->(DBSKIP())
	EndDo	
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

dbSelectArea("Sf2")
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
  
  AAdd(aRegs,{cPerg,"01","Divisao de Negocio : "  ,""   				,""  			,"mv_ch1",	"C",		16      ,0       ,		0 ,		"G"  ,		"u_fdivisao",		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                   
  AAdd(aRegs,{cPerg,"02","Data de            : "  ,""   				,""  			,"mv_ch2",	"D",		08      ,0       ,		0 ,		"G"  ,		""			,		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})
  AAdd(aRegs,{cPerg,"03","Data Ate           : "  ,""   				,""  			,"mv_ch3",	"D",		08      ,0       ,		0 ,		"G"  ,		""			,		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"04","Filial de          : "  ,""   				,""  			,"mv_ch4",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"05","Filial ate         : "  ,""   				,""  			,"mv_ch5",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par05",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",			""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
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