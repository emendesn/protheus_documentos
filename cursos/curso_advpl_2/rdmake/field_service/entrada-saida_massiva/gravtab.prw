
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRAVTAB  ºAutor  ³ M.Munhoz           º Data ³  16/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para gravar os dados de Alphaville na filial Osasco.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function GravTab(_cEtqMast, _aItMast, _cCodCli, _cLoja, _cNfeNr, _cNfeSer) // Nr etiqueta master, itens da etiqueta master

local _aAlias    := { "ZZ4",  "SZA",  "SZC",  "AB6",  "AB7",  "AB2",  "AB1",  "AA3"} // Lista de tabelas a copiar da filial Alphaville para Osasco
local _aAliasTmp := {"TZZ4", "TSZA", "TSZC", "TAB6", "TAB7", "TAB2", "TAB1", "TAA3"} // Lista alias temporarios das tabelas a copiar 
//local _aSetorder := {11,2,3,1,1,6,1,6} // Lista alias temporarios das tabelas a copiar 
local _aSetorder := {11,4,3,1,1,6,1,6} // Lista alias temporarios das tabelas a copiar 

local _aAreaZZ4 := ZZ4->(getarea())
local _aAreaSZA := SZA->(getarea())
local _aAreaSZC := SZC->(getarea())
local _aAreaAB6 := AB6->(getarea())
local _aAreaAB7 := AB7->(getarea())
local _aAreaAB2 := AB2->(getarea())
local _aAreaAB1 := AB1->(getarea())
local _aAreaAA3 := AA3->(getarea())
local _aAreaZZO := ZZO->(getarea())

local _nPosOS    := 1
local _nPosIMEI  := 2
local _nPosNF    := 3
local _nPosSerie := 4
local _cNrCham   := ""

local _cFilDest  := getmv("MV_MUDFDES")
local _cFilOrig  := getmv("MV_MUDFORI")

/*
TZZ4->(dbsetOrder(11)) // ZZ4_FILIAL + ZZ4_OS + ZZ4_IMEI
TSZA->(dbsetOrder( 2)) //  ZA_FILIAL + ZA_IMEI + ZA_STATUS
TSZA->(dbsetOrder( 4)) //  ZA_FILIAL + ZA_IMEI + ZA_CLIENTE + ZA_LOJA + ZA_NFISCAL + ZA_STATUS
TSZC->(dbsetOrder( 3)) //  ZC_FILIAL + ZC_IMEI + ZC_DOC + ZC_SERIE (INDICE NOVO)
TAB6->(dbsetOrder( 1)) // AB6_FILIAL + AB6_NUMOS
TAB7->(dbsetOrder( 1)) // AB7_FILIAL + AB7_NUMOS + AB7_ITEM
TAB2->(dbsetOrder( 6)) // AB2_FILIAL + AB2_NUMOS (usar AB2_NRCHAM para posicionar o AB1)
TAB1->(dbsetOrder( 1)) // AB1_FILIAL + AB1_NRCHAM
TAA3->(dbsetOrder( 6)) // AA3_FILIAL + AA3_NUMSER
*/
Begin Transaction

//for _nx := 1 to len(_aAlias)
for _na := 1 to len(_aItMast)

	_cNrCham := ""

	for _nx := 1 to len(_aAlias)

		_cStatus := iif(_aAlias[_nx] == "ZZ4", "2", iif(_aAlias[_nx] == "SZA", "V", iif(_aAlias[_nx] == "SZC", "0", "")))

		// Seleciono a tabela a ser copiada com um alias temporario 
		ChkFile(_aAlias[_nx],.f.,_aAliasTmp[_nx])

		// Defino a chave de pesquisa da tabela com o alias temporario
		(_aAliasTmp[_nx])->(dbSetOrder(_aSetOrder[_nx]))

	// Processo todos os itens da etiqueta master
//	for _na := 1 to len(_aItMast)

		// Posiciono registro do Alias Temporario a ser copiado 
		dbSelectArea(_aAliasTmp[_nx])

		_cChave := ""
		_cNFCli := _cSerCli := ""
		
			// Crio a chave a ser gravada no campo ZZ4_CHVFIL e atualizo o numero/serie da NF de entrada do cliente para posterior pesquisa no SZC
			if _aAlias[_nx] == "ZZ4"
				_cChvFil := left(TZZ4->ZZ4_OS,6)+TZZ4->ZZ4_CODCLI+TZZ4->ZZ4_LOJA+TZZ4->ZZ4_NFENR+TZZ4->ZZ4_NFESER+TZZ4->ZZ4_ITEMD1
			endif

		// Pego um novo numero de chamado ao passar pelo AB7 porque este eh o primeiro Alias que possui numero do chamado
		if _aAlias[_nx] == "AB7"
			_cNrCham := GetSxeNum('AB1','AB1_NRCHAM')
			ConfirmSX8()
		endif

		if _aAlias[_nx] $ "ZZ4/AB6/AB7/AB2"
			_cChave  := _cFilOrig+_aItMast[_na,_nPosOS]
		elseif _aAlias[_nx] $ "SZC"
  			_cChave := _cFilOrig+_aItMast[_na,_nPosIMEI]+_aItMast[_na,_nPosNF]+_aItMast[_na,_nPosSerie]
		elseif _aAlias[_nx] $ "SZA" //9B7QKT-001041-01-000061055-91 -0001
			_cChave := _cFilOrig + _aItMast[_na,_nPosIMEI] + substr(_cChvFil,7,17) + "V"
		elseif _aAlias[_nx] $ "AA3"
			_cChave := "  "+_aItMast[_na,_nPosIMEI]
		elseif _aAlias[_nx] $ "AB1"
			_cChave := _cFilOrig+_aItMast[_na,5]
		endif

		(_aAliasTmp[_nx])->(dbseek(_cChave)) // Pesquiso o registro correspondente na filial de origem 
		if found()

			// Atualizo o numero do chamado na matriz de itens da etiqueta master para posterior pesquisa no AB1
			// Continuo pegando o numero do chamado da filial Alphaville porque ele eh utilizado para posicionar o AB1 corretamente 
			if _aAlias[_nx] == "AB2"
				_aItMast[_na,5] := TAB2->AB2_NRCHAM
			endif

			// Crio a chave a ser gravada no campo ZZ4_CHVFIL e atualizo o numero/serie da NF de entrada do cliente para posterior pesquisa no SZC
			if _aAlias[_nx] == "ZZ4"
				_cChvFil := left(TZZ4->ZZ4_OS,6)+TZZ4->ZZ4_CODCLI+TZZ4->ZZ4_LOJA+TZZ4->ZZ4_NFENR+TZZ4->ZZ4_NFESER+TZZ4->ZZ4_ITEMD1
				_aItMast[_na,3] := TZZ4->ZZ4_NFENR
				_aItMast[_na,4] := TZZ4->ZZ4_NFESER
				//_cNFCli  := TZZ4->ZZ4_NFENR
				//_cSerCli := TZZ4->ZZ4_NFESER
			endif
 
			if _aAlias[_nx] == "SZC"

				// Grava os dados na tabela do sistema na filial Osasco (com While exclusivo pro SZC)
				//while TSZC->(!eof()) .and. TSZC->ZC_FILIAL == "02" .and. TSZC->ZC_IMEI == left(_aItMast[_na,_nPosIMEI],15) .and. ;
				while TSZC->(!eof()) .and. TSZC->ZC_FILIAL == "02" .and. TSZC->ZC_IMEI == _aItMast[_na,_nPosIMEI] .and. ;
				TSZC->ZC_DOC == _cNFCli .and. TSZC->ZC_SERIE == _cSerCli

					RecLock(_aAlias[_nx],.T.)
					For _ni := 1 TO FCount()
						if "_FILIAL" $ Field(_ni)
//							FieldPut(_ni, "06" )
							FieldPut(_ni, _cFilDest )
						elseif "_CODCLI" $ Field(_ni) .or. "_CLIENTE" $ Field(_ni) .or. "_FORNECE" $ Field(_ni) .or. "_CODFAB" $ Field(_ni)
							FieldPut(_ni, _cCodCli )
						elseif "_LOJA" $ Field(_ni) 
							FieldPut(_ni, _cLoja )
						elseif "_NFENR" $ Field(_ni) .or. "_NFISCAL" $ Field(_ni) .or. "ZC_DOC" $ Field(_ni) 
							FieldPut(_ni, _cNfeNr )
						elseif "_NFESER" $ Field(_ni) .or. "_SERIE" $ Field(_ni)
							FieldPut(_ni, _cNfeSer )
						elseif "_STATUS" $ Field(_ni)
							FieldPut(_ni, _cStatus )
						elseif "_EMISSA" $ Field(_ni) .or. "_BXDATA" $ Field(_ni) .or. "_EMDT" $ Field(_ni) 
							FieldPut(_ni, dDataBase )
						elseif "_EMUSER" $ Field(_ni) .or. "_ATEND" $ Field(_ni)
							FieldPut(_ni, cUserName )
						elseif "_HORA" $ Field(_ni) .or. "_BXHORA" $ Field(_ni) .or. "_EMHR" $ Field(_ni) 
							FieldPut(_ni, time() )
						else
							FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
						endif
					Next _ni
					MsUnlock()
					TSZC->(dbSkip())
				enddo
			elseif _aAlias[_nx] == "AA3"

				_aAreaAA3b := AA3->(getarea())
				AA3->(dbSetOrder(1)) //AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
				if (_aAliasTmp[_nx])->(dbseek(_cChave)) .and. AA3->(!dbSeek(xFilial("AA3")+_cCodCli+_cLoja+TAA3->AA3_CODPRO+TAA3->AA3_NUMSER))
					AA3->(dbGoTo(TAA3->(recno())))
					RecLock("AA3",.F.)
					AA3->AA3_CODCLI := _cCodCli
					AA3->AA3_LOJA   := _cLoja
					AA3->AA3_CODFAB := _cCodCli
					AA3->AA3_LOJAFA := _cLoja
					MsUnlock() 
				endif
				restarea(_aAreaAA3b)
			else

				// Grava os dados na tabela do sistema na filial Osasco
				RecLock(_aAlias[_nx],.T.)
				For _ni := 1 TO FCount()
					if "_FILIAL" $ Field(_ni)
//						FieldPut(_ni, "06" )
						FieldPut(_ni, _cFilDest )
					elseif "_CODCLI" $ Field(_ni) .or. "_CLIENTE" $ Field(_ni) .or. "_FORNECE" $ Field(_ni) .or. "_CODFAB" $ Field(_ni)
						FieldPut(_ni, _cCodCli )
					elseif "_LOJA" $ Field(_ni) 
						FieldPut(_ni, _cLoja )
					elseif "_NFENR" $ Field(_ni) .or. "_NFISCAL" $ Field(_ni) .or. "ZC_DOC" $ Field(_ni) 
						FieldPut(_ni, _cNfeNr )
					elseif "_NFESER" $ Field(_ni) .or. "_SERIE" $ Field(_ni)
						FieldPut(_ni, _cNfeSer )
					elseif "_STATUS" $ Field(_ni)
						FieldPut(_ni, _cStatus )
					elseif "_EMISSA" $ Field(_ni) .or. "_BXDATA" $ Field(_ni) .or. "_EMDT" $ Field(_ni) 
						FieldPut(_ni, dDataBase )
					elseif "_EMUSER" $ Field(_ni) .or. "_ATEND" $ Field(_ni)
						FieldPut(_ni, cUserName )
					elseif "_HORA" $ Field(_ni) .or. "_BXHORA" $ Field(_ni) .or. "_EMHR" $ Field(_ni) 
						FieldPut(_ni, time() )
					elseif "ZZ4_CHVFIL" $ Field(_ni)
						FieldPut(_ni, _cChvFil )
					elseif "_NRCHAM" $ Field(_ni)
						FieldPut(_ni, _cNrCham )
					elseif alltrim(Field(_ni)) $ "ZZ4_NFSCLI/ZZ4_NFSLOJ/ZZ4_NFSTES/ZZ4_NFSHR/ZZ4_NFSNR/ZZ4_NFSSER/ZZ4_DOCHRS/ZZ4_SMUSER/ZZ4_SMHR/ZZ4_PV/"
						FieldPut(_ni, "" )
					elseif alltrim(Field(_ni)) $ "ZZ4_NFSDT/ZZ4_DOCDTS/ZZ4_SMDT"
						FieldPut(_ni, ctod("  /  /  ") )
					elseif alltrim(Field(_ni)) $ "ZZ4_ETQMEM"
						FieldPut(_ni, strzero(TZZ4->ZZ4_ETQMAS,20) )
					elseif alltrim(Field(_ni)) $ "ZZ4_ETQMAS"
						FieldPut(_ni, 0 )
					else
						FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
					endif
				Next _ni
				MsUnlock()
				
			endif
//		else
//			apMsgStop('O registro de chave '+_cChave+' não foi encontrado na tabela '+_aAliasTmp[_nx]+'. Favor verificar com o administrador do sistema.' ,'Registro não encontrado: '+_aAliasTmp[_nx])
		endif
			
		(_aAliasTmp[_nx])->(dbCloseArea())

//	next _na
	next _nx
	_cNrCham := ""

//next _nx
next _na

ZZO->(dbSetOrder(3)) // ZZO_FILIAL + ZZO_IMEI + ZZO_STATUS
for _nb := 1 to len(_aItMast)
	if ZZO->(dbSeek(xFilial("ZZO") + left(_aItMast[_nb,_nPosIMEI]+space(10),TamSX3("ZZ4_IMEI")[1]) + "E")) .or. ZZO->(dbSeek(xFilial("ZZO") + left(_aItMast[_nb,_nPosIMEI]+space(10),TamSX3("ZZ4_IMEI")[1]) + "P"))
		reclock("ZZO",.f.)
		ZZO->ZZO_STATUS := '2'
		msunlock()
	endif
next _nb

End Transaction

restarea(_aAreaZZ4)
restarea(_aAreaSZA)
restarea(_aAreaSZC)
restarea(_aAreaAB6)
restarea(_aAreaAB7)
restarea(_aAreaAB2)
restarea(_aAreaAB1)
restarea(_aAreaAA3)
restarea(_aAreaZZO)

//apMsgInfo('A gravação da entrada massiva de ALPHAVILLE foi concluída em OSASCO com sucesso.','Gravação concluída')
apMsgInfo('A gravação da entrada massiva de '+_cFilOrig+' foi concluída em '+_cFilDest+' com sucesso.','Gravação concluída')
u_fechentmas(.f.) // fecha entrada massiva

return
