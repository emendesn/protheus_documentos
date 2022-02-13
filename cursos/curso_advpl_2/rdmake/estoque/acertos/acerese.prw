#Include "PROTHEUS.CH"
#include 'topconn.ch'
/*
Função de acerto do campo B2_RESERVA 
Claudia Cabral - 18/12/2009  
*/
User Function ACERESE()    
Processa( { || MyRel() } ) 
Return .t.                     

Static Function MyRel()                 
Local cQuery :=""
Local cDirDocs:= __RelDir
Local cCrLf:=Chr(13)+Chr(10)
Local cArquivo:=CriaTrab(,.f.)
Local cPath:=AllTrim(GetTempPath())     
Local nLin := 0
Local nMax := 0
//Local dData := DTOS( FIRSTDAY(dDatabase) - 1 )
//Local dDtfecha := DTOS(GetMv("MV_ULMES") )
Local aReserva := {}
Local aDiverge := {}
Local nAt := 0
Local lDiverge := .f.
Local _csrvapl    := ALLTRIM(GetMV("MV_SERVAPL"))
Local _cArqTmp  := lower(AllTrim(__RELDIR)+cArquivo)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

u_GerA0003(ProcName())

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


/*
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
*/

cQuery := " SELECT C0_FILIAL,C0_PRODUTO, C0_LOCAL, SUM(C0_QUANT)AS 'RESERVA' " 
cQuery += " FROM " + RetSqlName("SC0") + " SC0 "
cQuery += " WHERE SC0.D_E_L_E_T_ = ''"
cQuery += " AND SC0.C0_QUANT <> 0 "
cQuery += " AND C0_FILIAL = '" + xFilial("SC0")   + "'"
cQuery += " AND C0_VALIDA >= '" + dToS(dDataBase) + "' "
cQuery += " GROUP BY C0_FILIAL , C0_PRODUTO  , C0_LOCAL"
TCQUERY cQuery NEW ALIAS "QRY1"  

cQuery := " SELECT C9_FILIAL,C9_PRODUTO,C9_LOCAL, SUM (C9_QTDLIB) AS 'LIBERADO' "
cQuery += " FROM " + RetSqlName("SC9") + " SC9 "
cQuery += " WHERE SC9.D_E_L_E_T_ = '' "
cQuery += " AND SC9.C9_BLEST = ''"
cQuery += " AND SC9.C9_BLCRED = ''"
cQuery += " AND C9_FILIAL = '" + xFilial("SC9") + "'"
cQuery += " GROUP BY C9_FILIAL, C9_PRODUTO, C9_LOCAL"
TCQUERY cQuery NEW ALIAS "QRY2"  


cQuery := " SELECT CP_FILIAL,CP_PRODUTO,CP_LOCAL, SUM(CP_QUANT - CP_QUJE) AS 'SOLICITADO'"
cQuery += " FROM " + RetSqlName("SCP") + " SCP "
cQuery += " WHERE SCP.D_E_L_E_T_ = '' "
cQuery += " AND SCP.CP_STATUS = '' "
cQuery += " AND SCP.CP_QUANT - SCP.CP_QUJE  > 0 "
cQuery += " AND CP_FILIAL = '" + xFilial("SCP") + "'"
cQuery += " AND CP_PREREQU = 'S' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " GROUP BY CP_FILIAL,CP_PRODUTO,CP_LOCAL "
TCQUERY cQuery NEW ALIAS "QRY3"  

nTotsRec := QRY1->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY1->(Eof())
	IncProc()       
	aadd(aReserva,{QRY1->C0_FILIAL,QRY1->C0_PRODUTO,QRY1->C0_LOCAL,QRY1->RESERVA,0})
	QRY1->(DbSkip())
EndDo


nTotsRec := QRY2->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY2->(Eof())
	IncProc()       
	nAt :=  Ascan( aReserva, { |X| X[1] + X[2] + X[3] = QRY2->(C9_FILIAL+C9_PRODUTO+C9_LOCAL) } )
	If nAt = 0
		aadd(aReserva,{QRY2->C9_FILIAL,QRY2->C9_PRODUTO,QRY2->C9_LOCAL,QRY2->LIBERADO,0})
	Else 
		aReserva[nAt,4] += QRY2->LIBERADO
	EndIf	                                                                                     
	nAt :=  Ascan( aReserva, { |X| X[1] + X[2] + X[3] = QRY2->(C9_FILIAL+C9_PRODUTO+C9_LOCAL) } ) 
	If SB2->(DbSeek(QRY2->(C9_FILIAL+C9_PRODUTO+C9_LOCAL)  ))                   
		If SB2->B2_RESERVA <> aReserva[nAt,4] // Verifica se as quantidades de reservas sao divergentes
			AAdd(aDiverge , {aReserva[nAt,1], aReserva[nAt,2], aReserva[nAt,3], SB2->B2_RESERVA, aReserva[nAt,4],SB2->B2_QACLASS,0} )	
		Endif
	Endif	
	QRY2->(DbSkip())
EndDo


nTotsRec := QRY3->(RECCOUNT())
ProcRegua(nTotsRec)               

While !QRY3->(Eof())
	IncProc()       
	nAt :=  Ascan( aReserva, { |X| X[1] + X[2] + X[3] = QRY3->(CP_FILIAL+CP_PRODUTO+CP_LOCAL) } )
	If nAt = 0
		aadd(aReserva,{QRY3->CP_FILIAL,QRY3->CP_PRODUTO,QRY3->CP_LOCAL,0,QRY3->SOLICITADO})
	Else 
		aReserva[nAt,5] += QRY3->SOLICITADO
	EndIf	                                                                                     
	nAt :=  Ascan( aReserva, { |X| X[1] + X[2] + X[3] = QRY3->(CP_FILIAL+CP_PRODUTO+CP_LOCAL) } ) 
	If SB2->(DbSeek(QRY3->(CP_FILIAL+CP_PRODUTO+CP_LOCAL)  ))                   
		If SB2->B2_QACLASS <> aReserva[nAt,5] // Verifica se as quantidades de reservas sao divergentes
			AAdd(aDiverge , {aReserva[nAt,1], aReserva[nAt,2], aReserva[nAt,3], SB2->B2_RESERVA, aReserva[nAt,4],SB2->B2_QACLASS,aReserva[nat,5]} )	
		Endif
	Endif	
	QRY3->(DbSkip())
EndDo


cLinha := 'Filial'           					+ ';'
cLinha += 'Produto'          					+ ';'
cLinha += 'Armazem'        						+ ';'
cLinha += 'Reserva Atual'    					+ ';'
cLinha += 'Reserva Correta'  					+ ';'
cLinha += 'Reserva Solic. Almoxarifado'     	+ ';'
cLinha += 'Reserva Solic. almoxarifado Correta' + ';'


Fwrite(nHandle, cLinha  + cCrLf)
nMax := Len(aDiverge)
For x =1 to nMax
	cLinha := ''
	cLinha += aDiverge[x,1] + ';'
	cLinha += aDiverge[x,2] + ';'
	cLinha += aDiverge[x,3] + ';'	
	cLinha += Transform(aDiverge[x,04]  , "@E 999,999,999.99999") + ";" // QUANTIDADE RESERVADA ATUAL DO PRODUTO
	cLinha += Transform(aDiverge[x,05]  , "@E 999,999,999.99999") + ";" // QUANTIDADE RESERVADA CORRETA DO PRODUTO
	cLinha += Transform(aDiverge[x,06]  , "@E 999,999,999.99999") + ";" // QUANTIDADE RESERVADA ATUAL DO PRODUTO
	cLinha += Transform(aDiverge[x,07]  , "@E 999,999,999.99999") + ";" // QUANTIDADE RESERVADA CORRETA DO PRODUTO
	fWrite(nHandle, cLinha  + cCrLf)						
Next	

fClose(nHandle)
//CpyS2T(cdirdocs+carquivo+".CSV" , cPath, .T. )	-- Removido a pedido do Carlos Rocha 14/07/10 --
	
If !ApOleClient( 'MsExcel' )
	MsgAlert( "Ms Excel nao Instalado" ) //'MsExcel nao instalado'
Else
	oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha	-- Removido a pedido do Carlos Rocha 14/07/10 --
	oExcelApp:WorkBooks:Open( "\\" + _csrvapl+_cArqTmp+".CSV" ) 	// Abre uma planilha	-- Alterado a pedido do Carlos Rocha 14/07/10 --
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


dbSelectArea("SB2")
dbSetOrder(1)
Return .t.