#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100AGR ºAutor  ³ M.Munhoz - ERP PLUSº Data ³  16/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos a inclusao da Nota Fiscal de Entrada º±±
±±º          ³ para imprimir as etiquetas da Entrada Massiva              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 21/08/2011 para substituir o tratamento do D1_NUMSER  ³
//³ pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MT100AGR()

local _aImpEtiq := {}
local _cCCusto  := ""
local _cdivneg  := ""
local _cTES     := ""
local _cXLOTE   := ""
Local _cctrlote := "N"

	u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava natureza no SE1 para NFE de devolucao de vendas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Edson ROdrigues
if SF1->F1_TIPO == "D"
		_aAreaSD1 := SD1->(GetArea())
		
		SD1->(dbSetOrder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
		// Posiciona o SD1 no primeiro item da NFE
		if SD1->(DbSeek(xfilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			while !SD1->(eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC     == SF1->F1_DOC     .and. ;
			  SD1->D1_SERIE  == SF1->F1_SERIE  .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. ;
			  SD1->D1_LOJA   == SF1->F1_LOJA

				_nRecno:=SD1->(RECNO())
				u_GrvNatSE1(SD1->D1_DOC,SD1->D1_SERIE,SF1->F1_DUPL,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD,SD1->D1_TES,SD1->D1_NFORI,SD1->D1_SERIORI,_nRecno)
				
				SD1->(dbSkip())

			enddo
		endif
		restarea(_aAreaSD1)
endif



if Inclui
	
	_aAreaAB7 := AB7->(GetArea())
	_aAreaZZ4 := ZZ4->(GetArea())
	_aAreaSD1 := SD1->(GetArea())
	AB7->(DBOrderNickName('AB7NUMSER'))//	AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER
//	ZZ4->(dbSetOrder(3)) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_IMEI
	ZZ4->(DBOrderNickName('ZZ4ITEMD1')) // ZZ4_FILIAL + ZZ4_NFENR + ZZ4_NFESER + ZZ4_CODCLI + ZZ4_LOJA + ZZ4_CODPRO + ZZ4_ITEMD1 // M.Munhoz - 21/08/2011 - Substituicao do D1_NUMSER pelo D1_ITEM
	SD1->(dbSetOrder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
	
	// Posiciona o SD1 no primeiro item da NFE
	if SD1->(DbSeek(xfilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		
		_cCCusto := iif(!empty(SD1->D1_CC) .and. empty(_cCCusto), SD1->D1_CC, _cCCusto)
		_cdivneg := iif(!empty(SD1->D1_DIVNEG) .and. empty(_cdivneg), SD1->D1_DIVNEG, _cdivneg)
		_cTES    := iif(empty(_cTES), SD1->D1_TES, _cTES)
		_cXLOTE  := SD1->D1_XLOTE
		
/*		
		// Posiciona no arquivo de Entrada Massiva
		if ZZ4->(dbSeek(xFilial("ZZ4")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER)))
		   _cctrlote:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_CTRLOT")                         	
		   _nqtlotcx:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_QTDLCX") 
			// Se existir entrada massiva, questiona se devera imprimir etiqueta
			if ApMsgYesNo("Deseja imprimir as etiquetas referentes à ENTRADA MASSIVA ?", "Imprime Etiquetas")
				
				// Se confirmado, monta matriz com as etiquetas a serem impressas
				while !SD1->(eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC     == SF1->F1_DOC     .and. ;
					SD1->D1_SERIE  == SF1->F1_SERIE  .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. ;
					SD1->D1_LOJA   == SF1->F1_LOJA
					if ZZ4->(dbSeek(xFilial("ZZ4") + SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER))) .and. ;
						ZZ4->ZZ4_STATUS == '3' .and. ;
						AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + SD1->D1_NUMSER ))
						
						aAdd(_aImpEtiq, {SD1->D1_NUMSER, ZZ4->ZZ4_OS, AB7->AB7_ITEM, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_COD, SD1->D1_DTDIGIT, SD1->(recno()), SD1->D1_FORNECE, SD1->D1_LOJA , SD1->D1_XLOTE })
					endif
					SD1->(dbSkip())
				enddo
				// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
				if len(_aImpEtiq) > 0
					U_etqentr1(_aImpEtiq)
				endif
				
			endif                                              
			
			If _cctrlote="S"
			   IF ApMsgYesNo("Deseja imprimir as etiquetas de ARMAZENAGEM ?", "Imprime Etiquetas Armazenagem")
			       _aImpEtiq:=u_Etqarmz(SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SF1->F1_EST,_nqtlotcx)
			       If len(_aImpEtiq) > 0
			          U_Etqarmaz(_aImpEtiq)
			       Endif   
			   Endif
			Endif
			
		endif
*/		

		// Posiciona no arquivo de Entrada Massiva  // Se existir entrada massiva, questiona se devera imprimir etiqueta
		if ZZ4->(dbSeek(xFilial("ZZ4")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD))) .and. ;
		ApMsgYesNo("Deseja imprimir as etiquetas referentes à ENTRADA MASSIVA ?", "Imprime Etiquetas")

			_cctrlote:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_CTRLOT")
			_nqtlotcx:=POSICIONE("ZZJ",1,xFilial("ZZJ") + ZZ4->ZZ4_OPEBGH,"ZZJ_QTDLCX")
			
			// Se confirmado, monta matriz com as etiquetas a serem impressas
			while !SD1->(eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == SF1->F1_DOC .and. ;
			SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. ;
			SD1->D1_LOJA  == SF1->F1_LOJA

				if ZZ4->(dbSeek(xFilial("ZZ4") + SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM))) 
				
					while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFENR == SF1->F1_DOC .and. ;
					ZZ4->ZZ4_NFESER == SF1->F1_SERIE .and. ZZ4->ZZ4_CODCLI == SF1->F1_FORNECE .and. ;
					ZZ4->ZZ4_LOJA  == SF1->F1_LOJA .and. ZZ4->ZZ4_ITEMD1 == SD1->D1_ITEM

						if ZZ4->ZZ4_STATUS == '3' .and. AB7->(dbSeek(xFilial("AB7") + left(ZZ4->ZZ4_OS,6) + ZZ4->ZZ4_IMEI ))
//							aAdd(_aImpEtiq, {SD1->D1_NUMSER, ZZ4->ZZ4_OS, AB7->AB7_ITEM, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_COD, SD1->D1_DTDIGIT, SD1->(recno()), SD1->D1_FORNECE, SD1->D1_LOJA , SD1->D1_XLOTE })
							aAdd(_aImpEtiq, {ZZ4->ZZ4_IMEI, ZZ4->ZZ4_OS, AB7->AB7_ITEM, SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_COD, SD1->D1_DTDIGIT, SD1->(recno()), SD1->D1_FORNECE, SD1->D1_LOJA , SD1->D1_XLOTE,,,,,,ZZ4->(RECNO()), ZZ4->ZZ4_ITEMD1 })
						endif

						ZZ4->(dbSkip())

					enddo
				endif

				SD1->(dbSkip())

			enddo

			// Se matriz nao estiver vazia, executa funcao de impressao de etiquetas
			if len(_aImpEtiq) > 0
				if apMsgYesNo('Deseja usar a impressora Zebra? Informe Sim para Zebra ou Nao para Argox.','Escolha a impressora')
					u_EtqMass(_aImpEtiq)
				else
					U_etqentr1(_aImpEtiq)
				endif
			endif
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava acessorios SONY no SZC                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		u_GrvAcess()
	
	//if !empty(SF1->F1_DUPL) - Desabilitado esse "IF" Pois para gravar o CCusto e Div. Negocio em todos os titulos do C.PAgar  - Edson Rodrigues - 01/04/09
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava centro de custo no SE2                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		u_GrvCcSE2(SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DUPL , _cCCusto, "D",_cdivneg)
	//endif
	
restarea(_aAreaSD1)
restarea(_aAreaAB7)
restarea(_aAreaZZ4)
endif


Return()                       
                       

