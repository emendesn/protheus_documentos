#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BCONSKIT  º Autor ³ Luciano Siqueira   º Data ³  26/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta Saldo do KIT                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BCONSKIT()

Local aArea := GetArea()


u_GerA0003(ProcName())

Private cPerg		:= "BCONSKIT"

ValPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Else
	Processa({|| EXPSG1()}, "Processando...")
Endif

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EXPSG1  ³ Autor ³ Luciano Siqueira      ³ Data ³ 26/04/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Explode Estrutura - SG1                                     ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function EXPSG1()

Local oDlg
Local cVar     := ""
Local cTitulo  := "Consulta Saldo do KIT"
Local lMark    := .T.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk1
Local oChk2
Local cSaldo
Local nOpcA	:= 0
Local aButtons    	:= {}

Private lChk1 := .F.
Private lChk2 := .F.
Private oLbx
Private aVetor := {}


Private aEstru 	:= {}
Private nEstru 	:= 0
Private nX 		:= 1
Private _cModelo := MV_PAR01
Private _cProduto:= MV_PAR02
Private _cCliente:= MV_PAR03
Private _cLoja   := MV_PAR04

aEstru  := Estrut(_cModelo)

If Len(aEstru) == 0
	MsgInfo("O Kit informado não possui BOM!","Abortar processo")
	Return
Endif

_aStru	:= {}

AADD(_aStru,{"PECA","C",15,0})
AADD(_aStru,{"DESPECA","C",40,0})
AADD(_aStru,{"SALDP3","N",12,2})
AADD(_aStru,{"QTDPED","N",12,2})
AADD(_aStru,{"SALDO","N",12,2})
AADD(_aStru,{"SALDB2","N",12,2})
AADD(_aStru,{"SALDBF","N",12,2})
AADD(_aStru,{"ESTR","C",30,0})
AADD(_aStru,{"OBS","C",30,0})

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

_cChaveInd	:= "PECA"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")


Do While nX <= Len(aEstru)
	If aEstru[nX,2] == _cModelo  .and. aEstru[nX,3] <> _cProduto
		
		_cprodalt	:=Posicione("SB1",1,xFilial("SB1") +aEstru[nX,3], "B1_ALTER")
		_nCont 		:= 1
		
		If !Empty(_cprodalt)
			_nCont := 2
		Endif
		
		For i:= 1 to _nCont
			
			IIF(i==1,_cComp:=aEstru[nX,3],_cComp:=_cprodalt)
			IIF(i==1,_cEstru:="PRINCIPAL",_cEstru:="ALTERNATIVO")
			
			_cDescri	:= POSICIONE('SB1',1,xFilial('SB1')+_cComp,'B1_DESC')
			
			_cQry := " SELECT B6_LOCAL,SUM(B6_SALDO) AS SALDO "
			_cQry += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
			_cQry += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
			_cQry += "        B6_PRODUTO = '"+_cComp+"' AND "
			_cQry += "        B6_CLIFOR  = '"+_cCliente+"' AND "
			_cQry += "        B6_LOJA    = '"+_cLoja+"' AND "
			_cQry += "        B6_SALDO    > 0 AND "
			_cQry += "        B6.D_E_L_E_T_ = '' "
			_cQry += " GROUP BY B6_LOCAL "
			_cQry += " ORDER BY B6_LOCAL "
			//* Verifica se a Query Existe, se existir fecha
			If Select("TSQL1") > 0
				dbSelectArea("TSQL1")
				DbCloseArea()
			EndIf
			
			//* Cria a Query e da Um Apelido
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"TSQL1",.F.,.T.)
			
			
			dbSelectArea("TSQL1")
			dbGotop()
			nSldSB2 := 0
			nSldSBF := 0
			nSldSB6 := 0
			nSldSC6 := 0
			Do While TSQL1->(!Eof())
				
				nSldSB6 += TSQL1->SALDO
				_cArmASP := GetMv("MV_XARMASP",.F.,"10;1S")
				_cArmARJ := GetMv("MV_XARMARJ",.F.,"11;1R")
				_cEnd    := GetMv("MV_XENDFAT",.F.,"FATURAR")
				
				_cArmazem := IIF(TSQL1->B6_LOCAL=="10",_cArmASP,IIF(TSQL1->B6_LOCAL=="11",_cArmARJ,TSQL1->B6_LOCAL))
								
				_cQrySC6 := " SELECT C6_LOCAL,SUM(C6_QTDVEN-C6_QTDENT) AS QTDPED "
				_cQrySC6 += " FROM   "+RetSqlName("SC6")+" AS C6 (nolock) "
				_cQrySC6 += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 (nolock) "
				_cQrySC6 += " 	ON (F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=C6_TES "
				_cQrySC6 += " 	AND SF4.D_E_L_E_T_ = '') "
				_cQrySC6 += " WHERE  C6_FILIAL = '"+xFilial("SC6")+"' AND "
				_cQrySC6 += "   C6_CLI	  = '"+_cCliente+"' AND "
				_cQrySC6 += "   C6_LOJA    = '"+_cLoja+"' AND "
				_cQrySC6 += " 	C6_PRODUTO = '"+_cComp+"' AND "
				_cQrySC6 += "   C6_LOCAL IN "+FormatIn(_cArmazem,";")+" AND "//'"+TSQL1->B6_LOCAL+"' AND "
				_cQrySC6 += "   C6_LOCALIZ = '"+_cEnd+"' AND "
				_cQrySC6 += "   C6_QTDVEN-C6_QTDENT > 0 AND "
				_cQrySC6 += "   F4_PODER3 = 'D' AND " 
				_cQrySC6 += "   C6.D_E_L_E_T_ = '' "
				_cQrySC6 += " GROUP BY C6_LOCAL "
				
				//* Verifica se a Query Existe, se existir fecha
				If Select("TSQL2") > 0
					dbSelectArea("TSQL2")
					DbCloseArea()
				EndIf
			
				//* Cria a Query e da Um Apelido
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySC6),"TSQL2",.F.,.T.)
				
				
				dbSelectArea("TSQL2")
				dbGotop()
				If TSQL2->QTDPED > 0 
					nSldSC6 += TSQL2->QTDPED
				Endif
				
				If Select("TSQL2") > 0
					dbSelectArea("TSQL2")
					DbCloseArea()
				EndIf
				
				_cQrySB2 := " SELECT SB2.R_E_C_N_O_ AS RECSB2 "
				_cQrySB2 += " FROM   "+RetSqlName("SB2")+" AS SB2 (nolock) "
				_cQrySB2 += " WHERE  B2_FILIAL = '"+xFilial("SB2")+"' AND "
				_cQrySB2 += " 	B2_COD = '"+_cComp+"' AND "
				_cQrySB2 += "   B2_LOCAL IN "+FormatIn(_cArmazem,";")+" AND "
				_cQrySB2 += "   SB2.D_E_L_E_T_ = '' "
				
				//* Verifica se a Query Existe, se existir fecha
				If Select("TSQL2") > 0
					dbSelectArea("TSQL2")
					DbCloseArea()
				EndIf
			
				//* Cria a Query e da Um Apelido
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySB2),"TSQL2",.F.,.T.)				
																				
				DbSelectArea("TSQL2")
				DbGotop()
				
				Do While TSQL2->(!Eof())
				
					/*
					DbSelectArea("SB2")
					DbSetOrder(1)
					If DbSeek(xFilial("SB2")+_cComp+TSQL1->B6_LOCAL)
						nSldSB2 += SaldoSB2()
					Endif
					*/
					
					DbSelectArea("SB2")
					dbGoto(TSQL2->RECSB2)
					nSldSB2 += SaldoSB2()
										
					dbSelectArea("TSQL2")
					DbSkip()
				EndDo
				
				_cArmPSP := GetMv("MV_XARMPSP",.F.,"1S")
				_cArmPRJ := GetMv("MV_XARMPRJ",.F.,"1R")
				_cEnd	 := GetMv("MV_XENDFAT",.F.,"FATURAR")				
				
				_cArmazem := IIF(TSQL1->B6_LOCAL=="10",_cArmPSP,IIF(TSQL1->B6_LOCAL=="11",_cArmPRJ,TSQL1->B6_LOCAL))				
								
				nSldSBF += SaldoSBF(_cArmazem, _cEnd, Left(_cComp,15), NIL, NIL, NIL, .F.)
				
				
				If Select("TSQL2") > 0
					dbSelectArea("TSQL2")
					DbCloseArea()
				EndIf
				
				dbSelectArea("TSQL1")
				DbSkip()
			EndDo
			
			If nSldSB6 > 0
				Do Case
					Case nSldSB6 > nSldSB2
						_cObs:="SALDO P3 MAIOR QUE B2.
					Case nSldSB6 <= nSldSB2
						_cObs:="OK"
				EndCase
			Else
				_cObs:="SEM SALDO"
			Endif
				
				
			aAdd( aVetor, {_cComp,_cDescri,TransForm(nSldSB6,"@E 999,999.99"),TransForm(nSldSC6,"@E 999,999.99"),;
			TransForm(nSldSB6-nSldSC6,"@E 999,999.99"),TransForm(nSldSB2,"@E 999,999.99"),	TransForm(nSldSBF-nSldSC6,"@E 999,999.99"),_cEstru,_cObs})
				
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PECA		:= _cComp
			TRB->DESPECA	:= _cDescri
			TRB->SALDP3		:= nSldSB6
			TRB->QTDPED		:= nSldSC6				
			TRB->SALDO		:= nSldSB6-nSldSC6				
			TRB->SALDB2		:= nSldSB2
			TRB->SALDBF		:= nSldSBF-nSldSC6				
			TRB->ESTR		:= _cEstru
			TRB->OBS		:= _cObs
			MsUnlock()
									
			If Select("TSQL1") > 0
				dbSelectArea("TSQL1")
				DbCloseArea()
			EndIf
		Next i
	Endif
	nX++
Enddo

Aadd(aButtons,{"RELATORIO",{|| IMPSKIT()  },"RELATORIO","RELATORIO"}) //RELATORIO


DEFINE MSDIALOG oDlg TITLE Alltrim(cTitulo)+ " - " + _cModelo FROM 0,0 TO 680,1250 PIXEL

@ 15,05 LISTBOX oLbx FIELDS HEADER ;
"Peça", "Descrição","Saldo P3","Qtde Pedido","Saldo (P3-Pedido)","Saldo B2","Saldo (Faturar)","Estrutura","Observação";
SIZE 610,250 OF oDlg PIXEL

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {aVetor[oLbx:nAt,1],aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5],aVetor[oLbx:nAt,6],;
aVetor[oLbx:nAt,7],aVetor[oLbx:nAt,8],aVetor[oLbx:nAt,9]}}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},,aButtons)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return


Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Codigo do KIT          ?','' ,'' , 'mv_ch1', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Produto                ?','' ,'' , 'mv_ch2', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Cliente                ?','' ,'' , 'mv_ch3', 'C', 06, 0,0, 'G', '', 'SA1', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Loja                   ?','' ,'' , 'mv_ch4', 'C', 02, 0,0, 'G', '', ''   , '', '', 'mv_par04',,,'','','','','','','','','','','','','','')


Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AOCIMPCKD³ Autor ³ Edson Estevam         ³ Data ³ 25.06.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de CKD e OP's abertas do mesmo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AOC                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function IMPSKIT()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()                                                                                           	
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("IMPSKIT","Imprime Saldo do KIT","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir saldo do KIT.")

oSection1 := TRSection():New(oReport,"Imprime Saldo do KIT",{"TRB"})

TRCell():New(oSection1,"PECA","TRB","PECA","@!",15)
TRCell():New(oSection1,"DESPECA","TRB","DESCRICAO PECA","@!",40)
TRCell():New(oSection1,"SALDP3","TRB","SALDO P3","@E 99,999,999.99",20) 
TRCell():New(oSection1,"QTDPED","TRB","QTD PEDIDO","@E 99,999,999.99",20) 
TRCell():New(oSection1,"SALDO","TRB","SALDO (P3-PEDIDO)","@E 99,999,999.99",20) 
TRCell():New(oSection1,"SALDB2","TRB","SALDO B2","@E 99,999,999.99",20) 
TRCell():New(oSection1,"SALDBF","TRB","SALDO (Faturar)","@E 99,999,999.99",20) 
TRCell():New(oSection1,"ESTR","TRB","ESTRUTURA","@!",30)
TRCell():New(oSection1,"OBS","TRB","Observação","@!",30)

                                                               
oSection1:Cell("SALDP3"):SetHeaderAlign("RIGHT")
oSection1:Cell("QTDPED"):SetHeaderAlign("RIGHT")
oSection1:Cell("SALDO"):SetHeaderAlign("RIGHT")
oSection1:Cell("SALDB2"):SetHeaderAlign("RIGHT")
oSection1:Cell("SALDBF"):SetHeaderAlign("RIGHT")


Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:PrintLine()
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

Return
