#Include "PROTHEUS.CH"
#include 'topconn.ch'

User Function XDIFEST()    
PRIVATE cPerg	 :="XDIFEST     
ValidPerg(cPerg)
if ! Pergunte(cPerg,.T.)
 Return()
Endif

Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQry1 :=""
Local cDirDocs:= __RelDir
Local _cRel	:= GetMv("MV_RELATO") 				 // Diretorio do compartilhamento pasta relato
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.f.)
Local cPath:=AllTrim(GetTempPath())     
Local cQuery := ''
Local nLin := 0
Local dData := DTOS( FIRSTDAY(dDatabase) - 1 )
Local dDtfecha := DTOS(GetMv("MV_ULMES") )
Local aDiverge := {}
Local nAt := 0
Local lDiverge := .f.
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)

u_GerA0003(ProcName())

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IF Select("QRY0") <> 0 
	DbSelectArea("QRY0")
	DbCloseArea()
Endif                 

IF dData > dDtFecha // data maior que a data do ultimo fechamento, assume dt do fechamento
	cQuery := " SELECT B9_FILIAL,B9_LOCAL,MAX(B9_DATA) 'B9_DATA'   "
	cQuery += " FROM " + RetSqlName("SB9") + " SB9 (NOLOCK) "
	cQuery += " WHERE SB9.D_E_L_E_T_ = ' '  "
	cQuery += " AND  SB9.B9_FILIAL >= '" + mv_par03 + "' " 
	cQuery += " AND  SB9.B9_FILIAL <= '" + mv_par04 + "' "
	cQuery += " AND  SB9.B9_LOCAL >= '"  + mv_par01  + "' "
	cQuery += " AND  SB9.B9_LOCAL <= '"  + mv_par02  + "' "
	cQuery += " GROUP BY B9_FILIAL,B9_LOCAL"
	TCQUERY cQuery NEW ALIAS "QRY0"

	nTotsRec := QRY0->(RECCOUNT())
	ProcRegua(nTotsRec)               
	While !QRY0->(Eof())
		IncProc()      
		If dData > QRY0->B9_DATA  .and. !empty(QRY0->B9_DATA)
			dData := QRY0->B9_DATA
		EndIf
		QRY0->(DbSkip())
    EndDo
Endif

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

IF Select("QRY4") <> 0 
	DbSelectArea("QRY4")
	DbCloseArea()
Endif   

IF Select("QRY5") <> 0 
	DbSelectArea("QRY5")
	DbCloseArea()
Endif   


IF Select("QRY6") <> 0 
	DbSelectArea("QRY6")
	DbCloseArea()
Endif   



dbSelectArea("SB2")
dbsetorder(1)		

dbSelectArea("SB6")
dbsetorder(1)		


dbSelectArea("SB9")
dbsetorder(1)	 


cQuery := " SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_RESERVA,XSB9.B9_FILIAL,XSB9.B9_COD,XSB9.B9_LOCAL,XSB9.B9_QINI,XSB9.B9_DATA "
cQuery += " FROM " + RetSqlName("SB2") + " SB2 (NOLOCK) LEFT OUTER JOIN " 
cQuery += " (SELECT SB9.B9_FILIAL,SB9.B9_COD,SB9.B9_LOCAL,SB9.B9_QINI,SB9.B9_DATA "
cQuery += " FROM " + RetSQlName("SB9") + " SB9 (NOLOCK) INNER JOIN "
cQuery += " (SELECT B9_FILIAL,B9_COD,B9_LOCAL,MAX(B9_DATA) 'B9_DATA' "
cQuery += " FROM " + RetSqlName("SB9") + " SB9 (NOLOCK) "
cQuery += " WHERE  SB9.D_E_L_E_T_ = ' '  "
cQuery += " AND  SB9.B9_FILIAL >= '" + mv_par03 + "' " 
cQuery += " AND  SB9.B9_FILIAL <= '" + mv_par04 + "' "
cQuery += " AND  SB9.B9_LOCAL >= '"  + mv_par01  + "' "
cQuery += " AND  SB9.B9_LOCAL <= '"  + mv_par02  + "' "
cQuery += " GROUP BY B9_FILIAL,B9_COD,B9_LOCAL) AS B9 ON "
cQuery += " SB9.B9_COD = B9.B9_COD AND "
cQuery += " SB9.B9_FILIAL = B9.B9_FILIAL AND  "
cQuery += " SB9.B9_LOCAL = B9.B9_LOCAL AND "
cQuery += " SB9.B9_DATA = B9.B9_DATA "
cQuery += " WHERE  SB9.D_E_L_E_T_ = ' '  ) AS XSB9 ON "
cQuery += " XSB9.B9_COD = SB2.B2_COD AND " 
cQuery += " XSB9.B9_FILIAL = SB2.B2_FILIAL AND "
cQuery += " XSB9.B9_LOCAL = SB2.B2_LOCAL "
cQuery += " WHERE  SB2.D_E_L_E_T_ = ' '  "
cQuery += " AND  SB2.B2_FILIAL >= '" + mv_par03 + "' " 
cQuery += " AND  SB2.B2_FILIAL <= '" + mv_par04 + "' "
cQuery += " AND  SB2.B2_LOCAL >= '"  + mv_par01  + "' "
cQuery += " AND  SB2.B2_LOCAL <= '"  + mv_par02  + "' "
TCQUERY cQuery NEW ALIAS "QRY1"  
                                             
cQuery := " SELECT DISTINCT BK.BK_FILIAL,BK.BK_COD,BK.BK_LOCAL,BK.BK_QINI,BK.BK_DATA "
cQuery += " FROM  " + RetSqlName("SBK") + " SBK LEFT OUTER JOIN                                "
cQuery += "         (SELECT BK_FILIAL,BK_COD,BK_LOCAL,BK_DATA,SUM(BK_QINI) BK_QINI"
cQuery += "            FROM " + RetSqlName("SBK") + " SBK (NOLOCK)                                    "
cQuery += "            WHERE  SBK.D_E_L_E_T_ = ' '                                 "
cQuery += " 				AND  SBK.BK_FILIAL >= '" + MV_PAR03 + "' "
cQuery += " 				AND  SBK.BK_FILIAL <= '" + MV_PAR04 + "' "
cQuery += " 				AND  SBK.BK_LOCAL >= '"  + MV_PAR01 + "' "
cQuery += " 				AND  SBK.BK_LOCAL <= '"  + MV_PAR02 + "' "
cQuery += "                 AND  SBK.BK_DATA = '" + dData + "' "                  
cQuery += "     GROUP BY BK_FILIAL,BK_COD,BK_LOCAL,BK_DATA) "
cQuery += "            AS BK ON "
cQuery += " SBK.BK_FILIAL=BK.BK_FILIAL AND"
cQuery += " SBK.BK_COD=BK.BK_COD AND   "
cQuery += " SBK.BK_LOCAL=BK.BK_LOCAL AND"    
cQuery += " SBK.BK_DATA = BK.BK_DATA "
cQuery += " WHERE SBK.D_E_L_E_T_=''   "
TCQUERY cQuery NEW ALIAS "QRY2"              


cQuery := " SELECT DISTINCT  SBJ.BJ_FILIAL,SBJ.BJ_COD,SBJ.BJ_LOCAL, BJ.BJ_QINI ,SBJ.BJ_DATA,BJ.BJ_LOTECTL,BJ.BJ_NUMLOTE  "
cQuery += " FROM " + RETSQLNAME("SBJ") + " SBJ (NOLOCK) INNER JOIN "
cQuery += " (SELECT DISTINCT BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_LOTECTL,SBJ.BJ_NUMLOTE,SUM(BJ_QINI) BJ_QINI,MAX(BJ_DATA) 'BJ_DATA'   "
cQuery += " FROM " + RETSQLNAME("SBJ") + " SBJ (NOLOCK) "
cQuery += " WHERE  SBJ.D_E_L_E_T_ = ' '  "
cQuery += " AND  SBJ.BJ_FILIAL >= '" + MV_PAR03 + "' "
cQuery += " AND  SBJ.BJ_FILIAL <= '" + MV_PAR04 + "' "
cQuery += " AND  SBJ.BJ_LOCAL >= '"  + MV_PAR01 + "' "
cQuery += " AND  SBJ.BJ_LOCAL <= '"  + MV_PAR02 + "' "    
cQuery += " AND  SBJ.BJ_DATA ='" + dData + "' "
cQuery += " GROUP BY BJ_FILIAL,BJ_COD,BJ_LOCAL,BJ_LOTECTL,SBJ.BJ_NUMLOTE) AS BJ ON "
cQuery += " SBJ.BJ_COD = BJ.BJ_COD AND "
cQuery += " SBJ.BJ_FILIAL = BJ.BJ_FILIAL AND "
cQuery += " SBJ.BJ_LOCAL = BJ.BJ_LOCAL AND "
cQuery += " SBJ.BJ_DATA = BJ.BJ_DATA "
cQuery += " WHERE  SBJ.D_E_L_E_T_ = ' ' "   
TCQUERY cQuery NEW ALIAS "QRY3"  

cQuery := " SELECT B8_FILIAL,B8_PRODUTO,B8_LOCAL,SUM(B8_EMPENHO)'B8_EMPENHO',SUM(B8_SALDO) 'B8_SALDO' "
cQuery += " FROM " + RETSQLNAME("SB8") + " SB8 (NOLOCK) "
cQuery += " WHERE  SB8.D_E_L_E_T_ = ' '  "
cQuery += " AND  SB8.B8_FILIAL >= '" + MV_PAR03 + "' " 
cQuery += " AND  SB8.B8_FILIAL <= '" + MV_PAR04 + "' "
cQuery += " AND  SB8.B8_LOCAL >= '"  + MV_PAR01 + "' "
cQuery += " AND  SB8.B8_LOCAL <= '"  + MV_PAR02 + "' "
cQuery += " GROUP BY B8_FILIAL,B8_PRODUTO,B8_LOCAL "
TCQUERY cQuery NEW ALIAS "QRY4"  

cQuery := " SELECT BF_FILIAL,BF_PRODUTO,BF_LOCAL,SUM(BF_EMPENHO)'BF_EMPENHO',SUM(BF_QUANT) 'BF_QUANT' "
cQuery += " FROM " + RETSQLNAME("SBF") + " SBF (NOLOCK) "
cQuery += " WHERE  SBF.D_E_L_E_T_ = ' '  "
cQuery += " AND  SBF.BF_FILIAL >= '" + MV_PAR03 + "' " 
cQuery += " AND  SBF.BF_FILIAL <= '" + MV_PAR04 + "' "
cQuery += " AND  SBF.BF_LOCAL >= '"  + MV_PAR01 + "' "
cQuery += " AND  SBF.BF_LOCAL <= '"  + MV_PAR02 + "' "
cQuery += " GROUP BY BF_FILIAL,BF_PRODUTO,BF_LOCAL "
TCQUERY cQuery NEW ALIAS "QRY5"  



/* ANALISE SALDO DE TERCEIROS */ 
cQuery := " SELECT B6_FILIAL, B6_PRODUTO,B6_LOCAL, SUM(B6_SALDO) 'SALDO' "
cQuery += " FROM " + RetSqlName("SB6") + " SB6 (NOLOCK)"
cQuery += " WHERE  SB6.D_E_L_E_T_ = '' " 
cQuery += " AND SB6.B6_LOCAL >='" + MV_PAR01 + "' "
cQuery += " AND SB6.B6_LOCAL <='" + MV_PAR02 + "' "
cQuery += " AND SB6.B6_FILIAL >='" + MV_PAR03 + "' "
cQuery += " AND SB6.B6_FILIAL <='" + MV_PAR04 + "' "
cQuery += " AND SB6.B6_SALDO >= 0 "
//cQuery += " AND B6_ATEND <> 'S' "
cQuery += " AND B6_TES < '500' " 
cQuery += " GROUP BY B6_FILIAL,B6_PRODUTO,B6_LOCAL "
TCQUERY cQuery NEW ALIAS "QRY6"  

nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY1->(Eof())
	IncProc()       
	aadd(ADiverge,{QRY1->B2_FILIAL,QRY1->B2_COD,QRY1->B2_LOCAL,QRY1->B2_QATU,0,0,QRY1->B9_QINI,0,0,QRY1->B9_DATA,QRY1->B2_RESERVA,0,0,0,.T.})
	QRY1->(DbSkip())
EndDo


nTotsRec := QRY2->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY2->(Eof())
	IncProc() 
    nAt := Ascan(aDiverge, { |x| x[1]+ x[2] + x[3] = QRY2->BK_FILIAL + QRY2->BK_COD + QRY2->BK_LOCAL } )
    If nAt = 0 
	    aadd(ADiverge,{QRY2->BK_FILIAL,QRY2->BK_COD,QRY2->BK_LOCAL,0,0,0,0,QRY2->BK_QINI,0,QRY2->BK_DATA,0,0,0,0,.T.})
    Else
    	aDiverge[nAt,8] += QRY2->BK_QINI
	Endif
    QRY2->(DbSkip())
EndDo

nTotsRec := QRY3->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY3->(Eof())
	IncProc() 
    nAt := Ascan(aDiverge, { |x| x[1]+ x[2] + x[3] = QRY3->BJ_FILIAL + QRY3->BJ_COD + QRY3->BJ_LOCAL } )
    If nAt = 0 
	    aadd(ADiverge,{QRY3->BJ_FILIAL,QRY3->BJ_COD,QRY3->BJ_LOCAL,0,0,0,0,0,QRY3->BJ_QINI,QRY3->BJ_DATA,0,0,0,0,.T.})
    Else
    	aDiverge[nAt,9] += QRY3->BJ_QINI
	Endif
    QRY3->(DbSkip())
EndDo   


nTotsRec := QRY4->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY4->(Eof())
	IncProc() 
    nAt := Ascan(aDiverge, { |x| x[1]+ x[2] + x[3] = QRY4->B8_FILIAL + QRY4->B8_PRODUTO + QRY4->B8_LOCAL } )
    If nAt = 0 
	    aadd(ADiverge,{QRY4->B8_FILIAL,QRY4->B8_PRODUTO,QRY4->B8_LOCAL,0,0,QRY4->B8_SALD0,0,0,0,QRY4->B8_DATA,0,0,QRY4->B8_EMPENHO,0,.T.})
    Else
    	aDiverge[nAt,06] += QRY4->B8_SALDO
    	aDiverge[nAt,13] += QRY4->B8_EMPENHO
	Endif
    QRY4->(DbSkip())
EndDo

nTotsRec := QRY5->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY5->(Eof())
	IncProc() 
    nAt := Ascan(aDiverge, { |x| x[1]+ x[2] + x[3] = QRY5->BF_FILIAL + QRY5->BF_PRODUTO + QRY5->BF_LOCAL } )
    If nAt = 0 
	    aadd(ADiverge,{QRY5->BF_FILIAL,QRY5->BF_PRODUTO,QRY5->BF_LOCAL,0,QRY5->BF_QUANT,0,0,0,0,ctod(''),0,QRY5->BF_EMPENHO,0,0,.t.})
    Else
    	aDiverge[nAt,05] += QRY5->BF_QUANT
    	aDiverge[nAt,12] += QRY5->BF_EMPENHO
	Endif
    QRY5->(DbSkip())
EndDo


nTotsRec := QRY6->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY6->(Eof())
	IncProc() 
    nAt := Ascan(aDiverge, { |x| x[1]+ x[2] + x[3] = QRY6->B6_FILIAL + QRY6->B6_PRODUTO + QRY6->B6_LOCAL } )
    If nAt = 0 
	    aadd(ADiverge,{QRY6->B6_FILIAL,QRY6->B6_PRODUTO,QRY6->B6_LOCAL,0,0,0,0,0,0,CTOD(''),0,0,0,QRY6->SALDO,.t.})
    Else
    	aDiverge[nAt,14] += QRY6->SALDO
		aDiverge[nAt,15] := .t.    	                               
	Endif
    QRY6->(DbSkip())                                                                                             
EndDo

cLinha := 'Filial'           + ';'
cLinha += 'Produto'          + ';'
cLinha += 'Descricao'        + ';'
cLinha += 'Armazem'          + ';'
cLinha += 'Saldo Atual'      + ';'
cLinha += 'Saldo endereco'   + ';'
cLinha += 'Saldo do Lote'    + ';'
cLinha += 'Saldo do Terceiro'+ ';'
cLinha += 'Saldo Inicial'    + ';'
cLinha += 'Saldo Inicial endereco'       + ';'
cLinha += 'Saldo Inicial lote'          + ';'
cLinha += 'Data do Saldo'          + ';'
cLinha += 'Empenho Atual'      + ';'
cLinha += 'Empenho endereco'   + ';'
cLinha += 'Empenho Lote'    + ';'

fWrite(nHandle, cLinha  + cCrLf)


nTotsRec := Len(aDiverge)
ProcRegua(nTotsRec)               

For nAt := 1 to ntotsrec
	IncProc() 
	lDiverge := .f.
	SB1->(DbSeek(Xfilial("SB1") + aDiverge[nAt,2] ) )
	IF SB1->B1_MSBLQL <> '1' // PRODUTO NAO ESTA BLOQUEADO
		If SB1->B1_RASTRO $ 'LS' // verifica saldo do lote
		   If aDiverge[nAt,4] <> aDiverge[nAt,6] 
		   		lDiverge := .T.
		   EndIF                                                                   
		   If aDiverge[nAt,15] .and. (aDiverge[nAt,4] <> aDiverge[nAt,14] ) // verifica saldo de terceiro
		   		lDiverge := .t.
		   Endif
		   /*
		   If aDiverge[nAt,7] <> aDiverge[nAt,9] .and. aDiverge[nAt,10] > '20090430'
		   		lDiverge := .T.
		   EndIF
		   */
		   If aDiverge[nAt,11] <> aDiverge[nAt,13] 
		   		lDiverge := .T.
		   EndIF
		ENDIF                                  
		If SB1->B1_LOCALIZ = 'S'//  verifica saldo do endereco
		   If aDiverge[nAt,4] <> aDiverge[nAt,5] 
		   		lDiverge := .T.
		   EndIF
		   If aDiverge[nAt,15] .and. (aDiverge[nAt,4] <> aDiverge[nAt,14] ) // verifica saldo de terceiro
		   		lDiverge := .t.
		   Endif
		   /*
		   If aDiverge[nAt,7] <> aDiverge[nAt,8] 
		   		lDiverge := .T.
		   EndIF                                 
		   */
		   If aDiverge[nAt,11] <> aDiverge[nAt,12] 
		   		lDiverge := .T.
		   EndIF
		   If SB1->B1_RASTRO $  'LS'  // compara saldo do endereco com saldo do lote
	    	   If aDiverge[nAt,5] <> aDiverge[nAt,6]  // atual de endereço e lote
			   		lDiverge := .T.
			   EndIF                                                            
			   /*
			   If aDiverge[nAt,8] <> aDiverge[nAt,9]  // inicial de endereco e lote
			   		lDiverge := .T.
			   EndIF                             
			   */
			   If aDiverge[nAt,12] <> aDiverge[nAt,13]  // reserva de endereco e lote
		   		    lDiverge := .T.
	 	       EndIF
		   EndIF
		ENDIF   
		If aDiverge[nAt,15] .and. (aDiverge[nAt,4] <> aDiverge[nAt,14] ) // verifica saldo de terceiro
			lDiverge := .t.
	    Endif                                                                    
		// verifica saldos negativos
		If  aDiverge[nAt,4]  < 0  .or. aDiverge[nAt,5] < 0 .or. aDiverge[nAt,6] < 0 .or. ;
			aDiverge[nAt,7]  < 0  .or. aDiverge[nAt,8] < 0 .or. aDiverge[nAt,9] < 0 .or. ;
			aDiverge[nAt,11] < 0  .or. aDiverge[nAt,12] < 0 .or. aDiverge[nAt,13] < 0 
		   		lDiverge := .T.
		EndIF   
		If aDiverge[nAt,15] .and. ( aDiverge[nAt,14] < 0 ) // verifica saldo de terceiro
		   		lDiverge := .t.
		   Endif
		If lDiverge 
			cLinha := adiverge[nAt,01]           + ";" // FILIAL         
			cLinha += aDiverge[nAt,02]           + ";" // PRODUTO
			cLinha += Alltrim(SB1->B1_DESC)      + ";" // DESCRICAO DO PRODUTO
			cLinha += adiverge[nAt,03]           + ";" // ARMAZEM
			cLinha += Transform(aDiverge[nAt,04]  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO ATUAL DO PRODUTO
			cLinha += Transform(aDiverge[nAt,05]  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO ATUAL DO ENDERECO DO PRODUTO
			cLinha += Transform(aDiverge[nAt,06]  , "@E 999,999,999.99999") + ";" // QUANTIDADE DO ATUAL DO LOTE PRODUTO
			cLinha += Transform(aDiverge[nAt,14]  , "@E 999,999,999.99999") + ";" // QUANTIDADE SALDO DE TERCEIROS DO PRODUTO
			cLinha += Transform(aDiverge[nAt,07]  , "@E 999,999,999.99999") + ";" // QUANTIDADE INICIAL DO PRODUTO
			cLinha += Transform(aDiverge[nAt,08]  , "@E 999,999,999.99999") + ";" // QUANTIDADE INICIAL DO ENDERECO DO PRODUTO
			cLinha += Transform(aDiverge[nAt,09]  , "@E 999,999,999.99999") + ";" // QUANTIDADE INICIAL  DO LOTE DO PRODUTO
			cLinha += Right(aDiverge[nAt,10],2)+'/'+Substr(aDiverge[nAt,10],5,2)+'/'+left(aDiverge[nAt,10],4)+ ";" // DATA DO SALDO INICIAL DO PRODUTO
			cLinha += Transform(aDiverge[nAt,11]  , "@E 999,999,999.99999") + ";" // QUANTIDADE EMPENHO DO PRODUTO
			cLinha += Transform(aDiverge[nAt,12]  , "@E 999,999,999.99999") + ";" // QUANTIDADE EMPENHO DO ENDERECO DO PRODUTO
			cLinha += Transform(aDiverge[nAt,13]  , "@E 999,999,999.99999") + ";" // QUANTIDADE EMPENHO  DO LOTE DO PRODUTO
			fWrite(nHandle, cLinha  + cCrLf)						
		EndIf	
	Endif		
Next

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
IF Select("QRY4") <> 0 
	DbSelectArea("QRY4")
	DbCloseArea()
Endif   

IF Select("QRY5") <> 0 
	DbSelectArea("QRY5")
	DbCloseArea()
Endif   

IF Select("QRY6") <> 0 
	DbSelectArea("QRY6")
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
  
  AAdd(aRegs,{cPerg,"01","Armazem de  : "  ,""   				,""  			,"mv_ch1",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par01",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"02","Armazem ate : "  ,""   				,""  			,"mv_ch2",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par02",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"03","Filial de   : "  ,""   				,""  			,"mv_ch3",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par03",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  AAdd(aRegs,{cPerg,"04","Filial ate  : "  ,""   				,""  			,"mv_ch4",	"C",		02      ,0       ,		0 ,		"G"  ,		""			,		"mv_par04",		""	   ,	""		,		""		,"",		""		,		"",		""		,		""	,		""		,"",			""		,"",			""		,"",			"",			"",			"",			"",			"",			"",			"",			"",			"",			"",		"XM0",	""})                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  
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
