#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LC13R    บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE COMPRAS (Emissao em formato Grafico)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LC13R()
Private	lEnd		:= .f.,;
		aAreaSC7	:= SC7->(GetArea()),;
		aAreaSA2	:= SA2->(GetArea()),;
		aAreaSA5	:= SA5->(GetArea()),;   
		aAreaSF4	:= SF4->(GetArea()),;
	 	cPerg		:= 'LC13R '            
	 	//	aAreaSZF	:= SZF->(GetArea()),;

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjusta os parametros.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		AjustaSX1(cPerg)

		If	( ! Pergunte(cPerg,.T.) )
			Return
		Else
			Private	cNumPed  	:= mv_par01			// Numero do Pedido de Compras
			Private	lImpPrc		:= (mv_par02==2)	// Imprime os Precos ?
			Private	nTitulo 	:= mv_par03			// Titulo do Relatorio ?
			Private	cObserv1	:= mv_par04			// 1a Linha de Observacoes
			Private	cObserv2	:= mv_par05			// 2a Linha de Observacoes
			Private	cObserv3	:= mv_par06			// 3a Linha de Observacoes
			Private	cObserv4	:= mv_par07			// 4a Linha de Observacoes
			Private	lPrintCodFor:= (mv_par08==1)	// Imprime o Codigo do produto no fornecedor ?
		EndIf

		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
		If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
			Help('',1,'LC13R',,OemToAnsi('Pedido nใo encontrado.'),1)
			Return .f.
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta a rotina de impressao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRestaura a area anterior ao processamento. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RestArea(aAreaSC7)
		RestArea(aAreaSA2)
		RestArea(aAreaSA5)
	 //	RestArea(aAreaSZF)
		RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณLuis Henrique Robustoบ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
Private	oPrint		:= TMSPrinter():New(OemToAnsi('Pedido de Compras')),;
		oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP',;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
		oFont12n	:= TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont16		:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

Private	lFlag		:= .t.,;	// Controla a impressao do fornecedor
		nLinha		:= 3000,;	// Controla a linha por extenso
		nLinFim		:= 0,;		// Linha final para montar a caixa dos itens
		lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
		cRepres		:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDesc	:= 0,;		// Valor de Desconto
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0		// Valor do ICMS Retido

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona nos arquivos necessarios. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea('SA2')
		SA2->(DbSetOrder(1))
		If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
			Help('',1,'REGNOIS')
			Return .f.
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDefine que a impressao deve ser RETRATOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SetPortrait()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta query !ณ    //SC7.C7_CODPRF, 
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cSELECT :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, '+;
					'SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, '+;
					'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
					'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET '

		cFROM   :=	RetSqlName('SC7') + ' SC7 '

		cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
					'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
					'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39) 

		cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

		cQuery  :=	' SELECT '   + cSELECT + ; 
					' FROM '     + cFROM   + ;
					' WHERE '    + cWHERE  + ;
					' ORDER BY ' + cORDER

		TCQUERY cQuery NEW ALIAS 'TRA'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

		DbSelectArea('TRA')
		Count to _nQtdReg
		ProcRegua(_nQtdReg)
		TRA->(DbGoTop())

		While 	TRA->( ! Eof() )

				xVerPag()

				If	( lFlag )
					//ฺฤฤฤฤฤฤฤฤฤฤฟ
					//ณFornecedorณ
					//ภฤฤฤฤฤฤฤฤฤฤู
					oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
					oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont13)
					oPrint:Say(0580,0100,OemToAnsi('Endere็o:'),oFont10)
					oPrint:Say(0580,0430,SA2->A2_END,oFont11)
					oPrint:Say(0630,0100,OemToAnsi('Municํpio/U.F.:'),oFont10)
					oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
					oPrint:Say(0630,1200,OemToAnsi('Cep:'),oFont10)
					oPrint:Say(0630,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
					oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
					oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
					oPrint:Say(0680,1200,OemToAnsi('Fax:'),oFont10)
					oPrint:Say(0680,1370,SA2->A2_FAX,oFont11)
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณNumero/Emissaoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					oPrint:Box(0530,1900,0730,2300)
					oPrint:FillRect({0530,1900,0730,2300},oBrush)
					oPrint:Say(0535,1960,OemToAnsi('Numero documento'),oFont08)
					oPrint:Say(0570,2000,SC7->C7_NUM,oFont18)
					oPrint:Say(0650,2000,Dtoc(SC7->C7_EMISSAO),oFont12)
					lFlag := .f.
				EndIf
				
				If	( lPrintDesTab )
					oPrint:Line(nLinha,100,nLinha,2300)
					oPrint:Line(nLinha,100,nLinha+70,100)
					oPrint:Line(nLinha,290,nLinha+70,290)
					oPrint:Line(nLinha,740,nLinha+70,740)
					oPrint:Line(nLinha,1390,nLinha+70,1390)
					oPrint:Line(nLinha,1590,nLinha+70,1590)
					oPrint:Line(nLinha,1840,nLinha+70,1840)
					oPrint:Line(nLinha,2040,nLinha+70,2040)
					oPrint:Line(nLinha,2300,nLinha+70,2300)
					oPrint:Say(nLinha,0120,OemToAnsi('Item'),oFont12)
					oPrint:Say(nLinha,0300,OemToAnsi('C๓digo'),oFont12)
					oPrint:Say(nLinha,0750,OemToAnsi('Descri็ใo'),oFont12)
					oPrint:Say(nLinha,1400,OemToAnsi('Qtde'),oFont12)
					oPrint:Say(nLinha,1620,OemToAnsi('Vlr.Unit.'),oFont12)
					oPrint:Say(nLinha,1850,OemToAnsi('IPI (%)'),oFont12)
					oPrint:Say(nLinha,2050,OemToAnsi('Valor Total'),oFont12)
					lPrintDesTab := .f.
					nLinha += 70
					oPrint:Line(nLinha,100,nLinha,2300)
				EndIf

				oPrint:Line(nLinha,100,nLinha+60,100)
				oPrint:Line(nLinha,290,nLinha+60,290)
				oPrint:Line(nLinha,740,nLinha+60,740)
				oPrint:Line(nLinha,1390,nLinha+60,1390)
				oPrint:Line(nLinha,1590,nLinha+60,1590)
				oPrint:Line(nLinha,1840,nLinha+60,1840)
				oPrint:Line(nLinha,2040,nLinha+60,2040)
				oPrint:Line(nLinha,2300,nLinha+60,2300)

				oPrint:Say(nLinha,0120,TRA->C7_ITEM,oFont12n)
				If	( lPrintCodFor )
					DbSelectArea('SA5')
					SA5->(DbSetOrder(1))
					If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
						oPrint:Say(nLinha,0300,SA5->A5_CODPRF,oFont12n)
					Else
						oPrint:Say(nLinha,0300,TRA->C7_PRODUTO,oFont12n)
					EndIf
				Else
					oPrint:Say(nLinha,0300,TRA->C7_PRODUTO,oFont12n)
				EndIf	
				oPrint:Say(nLinha,0750,SubStr(TRA->C7_DESCRI,1,25),oFont12n)
				oPrint:Say(nLinha,1555,AllTrim(TransForm(TRA->C7_QUANT,'@E 99,999.99')),oFont12n,,,,1)
				If	( lImpPrc )
					oPrint:Say(nLinha,1805,AllTrim(TransForm(TRA->C7_PRECO,'@R 999,999.9999')),oFont12n,,,,1)
					oPrint:Say(nLinha,2005,AllTrim(TransForm(TRA->C7_IPI,'@R 999,999.99')),oFont12n,,,,1)
					oPrint:Say(nLinha,2260,AllTrim(TransForm(TRA->C7_TOTAL,'@R 999,999.99')),oFont12n,,,,1)
				EndIf
				nLinha += 60
				oPrint:Line(nLinha,100,nLinha,2300)

				_nValMerc 		+= TRA->C7_TOTAL
				_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
				_nValDesc		+= TRA->C7_VLDESC
				_nTotAcr		+= TRA->C7_DESPESA
				_nTotSeg		+= TRA->C7_SEGURO
				_nTotFre		+= TRA->C7_VALFRE

				If	( Empty(TRA->C7_TES) )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				Else
					DbSelectArea('SF4')
					SF4->(DbSetOrder(1))
					If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
						If	( AllTrim(SF4->F4_INCSOL) == 'S' )
							_nTotIcmsRet	+= TRA->C7_ICMSRET
						EndIf
					EndIf
				EndIf

				

			IncProc()
			TRA->(DbSkip())	

		End

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE MERCADORIASณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Mercadorias ',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nValMerc,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE I.P.I. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValIpi > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de I. P. I. (+)',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nValIpi,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE DESCONTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValDesc > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Desconto (-)',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nValDesc,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE ACRESCIMO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotAcr > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Acresc. (+)',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nTotAcr,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE SEGURO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotSeg > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Seguro (+)',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nTotSeg,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE FRETE ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotFre > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Frete (+)',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nTotFre,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime ICMS RETIDO    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotIcmsRet > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de ICMS Retido',oFont12)
			oPrint:Say(nLinha+10,2000,TransForm(_nTotIcmsRet,'@R 9,999,999.99'),oFont13)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o VALOR TOTAL !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:FillRect({nLinha,1390,nLinha+80,2300},oBrush)
		oPrint:Line(nLinha,1390,nLinha+80,1390)
		oPrint:Line(nLinha,1840,nLinha+80,1840)
		oPrint:Line(nLinha,2300,nLinha+80,2300)
		oPrint:Say(nLinha+10,1400,'VALOR TOTAL ',oFont12)
		If	( lImpPrc )
			oPrint:Say(nLinha+10,1950,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@R 9,999,999.99'),oFont14)
		EndIf
		nLinha += 80
		xVerPag()
		oPrint:Line(nLinha,1390,nLinha,2300)
		nLinha += 70

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime as observacoes dos parametros. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es:'),oFont12)
		oPrint:Say(nLinha,0500,cObserv1,oFont12n)
		nLinha += 60
		xVerPag()
		If	( ! Empty(cObserv2) )
			oPrint:Say(nLinha,0500,cObserv2,oFont12n)
			nLinha += 60
			xVerPag()
		EndIf	
		If	( ! Empty(cObserv3) )
			oPrint:Say(nLinha,0500,cObserv3,oFont12n)
			xVerPag()
			nLinha += 60
		EndIf	
		If	( ! Empty(cObserv4) )
			oPrint:Say(nLinha,0500,cObserv4,oFont12n)
			xVerPag()
			nLinha += 60
			xVerPag()
		EndIf

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Representante comercial do fornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
		/*
		DbSelectArea('SZF')
		SZF->(DbSetOrder(1))
		If	SZF->(DbSeek(xFilial('SZF') + SA2->A2_COD + SA2->A2_LOJA))
			If	( ! Empty(SZF->ZF_REPRES) )
				oPrint:Say(nLinha,0100,OemToAnsi('Representante:'),oFont12)
				oPrint:Say(nLinha,0500,AllTrim(SZF->ZF_REPRES) + Space(5) + AllTrim(SZF->ZF_TELREPR) + Space(5) + AllTrim(SZF->ZF_FAXREPR),oFont12n)
				nLinha += 60
				xVerPag()
			EndIf
		EndIf	
        */
		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de prazo pagamento/entrega!ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLinha,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
		oPrint:Say(nLinha,0500,'_____________________',oFont12n)
		oPrint:Say(nLinha,1120,OemToAnsi('Prazo Entrega:'),oFont12)
		oPrint:Say(nLinha,1500,'___________________________',oFont12n)
		nLinha += 60
		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de transportadora !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
		oPrint:Say(nLinha,0500,'____________________________________________________',oFont12n)
		nLinha += 60
		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Contato.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( ! Empty(SA2->A2_CONTATO) )
			oPrint:Say(nLinha,0100,OemToAnsi('Contato: '),oFont12)
			oPrint:Say(nLinha,0500,SA2->A2_CONTATO,oFont12n)
			nLinha += 60
			xVerPag()
		EndIf

		oPrint:Line(nLinha,0100,nLinha,2300)
		nLinha += 10
		xVerPag()

		TRA->(DbCloseArea())

		xRodape()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime em Video, e finaliza a impressao. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o cabecalho da empresa. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SayBitmap(050,100,cFileLogo,1050,260)
		oPrint:Say(050,1300,AllTrim(Upper(SM0->M0_NOMECOM)),oFont16)
		oPrint:Say(135,1300,AllTrim(SM0->M0_ENDCOB),oFont11)
		oPrint:Say(180,1300,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
		oPrint:Say(225,1300,AllTrim('www.microsiga.com.br'),oFont11)
		oPrint:Line(285,1300,285,2270)
		oPrint:Say(300,1300,TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
		oPrint:Say(300,1850,SM0->M0_INSC,oFont12)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTitulo do Relatorioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( nTitulo == 1 ) // Cotacao
			oPrint:Say(0400,0800,OemToAnsi('Cota็ใo de Mercadorias'),oFont22)
		Else
			oPrint:Say(0400,0800,OemToAnsi('Pedido de Mercadorias'),oFont22)
		EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()

	oPrint:Line(3100,0100,3100,2300)
   //oPrint:Say(3120,1050,AllTrim(SM0->M0_TEL),oFont16)
	oPrint:Say(3120,1050,AllTrim("SM0->M0_TEL"),oFont16)
	oPrint:Line(3200,0100,3200,2300)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia a montagem da impressao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( nLinha >= 3000 )

		If	( ! lFlag )
			xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf

		oPrint:StartPage()
		xCabec()

		lPrintDesTab := .t.

	EndIf
	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCampos a serem grav. no SX1ณ
		//ณaRegs[nx][01] - X1_GRUPO   ณ
		//ณaRegs[nx][02] - X1_ORDEM   ณ
		//ณaRegs[nx][03] - X1_PERGUNTEณ
		//ณaRegs[nx][04] - X1_PERSPA  ณ
		//ณaRegs[nx][05] - X1_PERENG  ณ
		//ณaRegs[nx][06] - X1_VARIAVL ณ
		//ณaRegs[nx][07] - X1_TIPO    ณ
		//ณaRegs[nx][08] - X1_TAMANHO ณ
		//ณaRegs[nx][09] - X1_DECIMAL ณ
		//ณaRegs[nx][10] - X1_PRESEL  ณ
		//ณaRegs[nx][11] - X1_GSC     ณ
		//ณaRegs[nx][12] - X1_VALID   ณ
		//ณaRegs[nx][13] - X1_VAR01   ณ
		//ณaRegs[nx][14] - X1_DEF01   ณ
		//ณaRegs[nx][15] - X1_DEF02   ณ
		//ณaRegs[nx][16] - X1_DEF03   ณ
		//ณaRegs[nx][17] - X1_F3      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria uma array, contendo todos os valores...ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAdd(aRegs,{cPerg,'01','Numero do Pedido   ?','Numero do Pedido   ?','Numero do Pedido   ?','mv_ch1','C', 6,0,0,'G','','mv_par01','','','',''})
		aAdd(aRegs,{cPerg,'02','Imprime precos     ?','Imprime precos     ?','Imprime precos     ?','mv_ch2','N', 1,0,1,'C','','mv_par02',OemToAnsi('Nใo'),'Sim','',''})
		aAdd(aRegs,{cPerg,'03','Titulo do Relatorio?','Titulo do Relatorio?','Titulo do Relatorio?','mv_ch3','N', 1,0,1,'C','','mv_par03',OemToAnsi('Cota็ใo'),'Pedido','',''})
		aAdd(aRegs,{cPerg,'04',OemToAnsi('Observa็๕es'),'Observa็๕es         ','Observa็๕es         ','mv_ch4','C',70,0,1,'G','','mv_par04','','','',''})
		aAdd(aRegs,{cPerg,'05','                    ','                    ','                    ','mv_ch5','C',70,0,1,'G','','mv_par05','','','',''})
		aAdd(aRegs,{cPerg,'06','                    ','                    ','                    ','mv_ch6','C',70,0,0,'G','','mv_par06','','','',''})
		aAdd(aRegs,{cPerg,'07','                    ','                    ','                    ','mv_ch7','C',70,0,0,'G','','mv_par07','','','',''})
		aAdd(aRegs,{cPerg,'08','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','mv_ch8','N', 1,0,1,'C','','mv_par08',OemToAnsi('Sim'),OemToAnsi('Nใo'),'',''})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If	RecLock('SX1',Iif(!SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])),.t.,.f.))
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				Replace SX1->X1_PRESEL		With aRegs[nx][10]
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				MsUnlock('SX1')
			Else
				Help('',1,'REGNOIS')
			Endif
		Next nX

Return