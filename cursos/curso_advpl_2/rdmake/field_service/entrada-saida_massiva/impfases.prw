
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPFASES ºAutor  ³Microsiga           º Data ³  19/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa registros das tabelas ZZ3/SZ9/ZZ7/ZZY/ da filial   º±±
±±º          ³ Alphaville para Osasco                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function ImpFases(_cOS, _cIMEI, _cEtqMast, _cDocSep)

local _aAlias    := { "ZZ3",  "SZ9",  "ZZ7",  "ZZY"} // Lista de tabelas a copiar da filial Alphaville para Osasco
local _aAliasTmp := {"TZZ3", "TSZ9", "TZZ7", "TZZY"} // Lista alias temporarios das tabelas a copiar 
local _aSetOrder := {1     , 2     , 2     , 3}      // Lista numero de indices a utilizar no dbSeek
local _lRet      := .f.

local _aAreaZZ3  := ZZ3->(getarea()) // (4) ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ
local _aAreaSZ9  := SZ9->(getarea()) // (1) Z9_FILIAL + Z9_IMEI + Z9_NUMOS + Z9_SEQ + Z9_ITEM
local _aAreaZZ7  := ZZ7->(getarea()) // (2) ZZ7_FILIAL + ZZ7_IMEI + ZZ7_NUMOS + ZZ7_SEQ + ZZ7_ITEM
local _aAreaZZY  := ZZY->(getarea()) // (3) ZZY_FILIAL + ZZY_NUMDOC + ZZY_NUMMAS

local _cFilDest  := getmv("MV_MUDFDES")
local _cFilOrig  := getmv("MV_MUDFORI")

ZZY->(dbSetOrder(3)) // ZZY_FILIAL + ZZY_NUMDOC + ZZY_NUMMAS

Begin Transaction

for _nx := 1 to len(_aAlias)

	// Seleciono a tabela a ser copiada definindo um alias temporario pra ele
	ChkFile(_aAlias[_nx],.f.,_aAliasTmp[_nx])

	// Defino a chave de pesquisa da tabela para o alias temporario
	(_aAliasTmp[_nx])->(dbSetOrder(_aSetOrder[_nx]))

	// Posiciono registro do Alias Temporario a ser copiado 
	dbSelectArea(_aAliasTmp[_nx])

	if _aAlias[_nx] == "ZZ3"

		if TZZ3->(dbSeek(_cFilOrig + _cIMEI + left(_cOs,6)))
			while TZZ3->(!eof()) .and. TZZ3->ZZ3_FILIAL == _cFilOrig .and. TZZ3->ZZ3_IMEI == _cIMEI .and. left(TZZ3->ZZ3_NUMOS,6) == left(_cOs,6)

				if TZZ3->ZZ3_ENCOS == "S" .and. TZZ3->ZZ3_ESTORN <> "S"
					TZZ3->(dbSkip())
				else
					_lRet := .t.
					// Grava os dados na tabela do sistema na filial Osasco
					RecLock(_aAlias[_nx],.T.)
					For _ni := 1 TO FCount()
						if "_FILIAL" $ Field(_ni)
							FieldPut(_ni, _cFilDest )
						else
							FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
						endif
					Next _ni
					MsUnlock()
					TZZ3->(dbSkip())
				endif
			enddo
		endif

	elseif _aAlias[_nx] == "SZ9"

		if TSZ9->(dbSeek(_cFilOrig + _cIMEI + left(_cOs,6)))
			while TSZ9->(!eof()) .and. TSZ9->Z9_FILIAL == _cFilOrig .and. TSZ9->Z9_IMEI == _cIMEI .and. left(TSZ9->Z9_NUMOS,6) == left(_cOs,6)

				// Grava os dados na tabela do sistema na filial Osasco
				RecLock(_aAlias[_nx],.T.)
				For _ni := 1 TO FCount()
					if "_FILIAL" $ Field(_ni)
						FieldPut(_ni, _cFilDest )
					else
						FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
					endif
				Next _ni
				MsUnlock()
				TSZ9->(dbSkip())

			enddo

		endif

	elseif _aAlias[_nx] == "ZZ7"

		if TZZ7->(dbSeek(_cFilOrig + _cIMEI + left(_cOs,6)))
			while TZZ7->(!eof()) .and. TZZ7->ZZ7_FILIAL == _cFilOrig .and. TZZ7->ZZ7_IMEI == _cIMEI .and. left(TZZ7->ZZ7_NUMOS,6) == left(_cOs,6)

				// Grava os dados na tabela do sistema na filial Osasco
				RecLock(_aAlias[_nx],.T.)
				For _ni := 1 TO FCount()
					if "_FILIAL" $ Field(_ni)
						FieldPut(_ni, _cFilDest )
					else
						FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
					endif
				Next _ni
				MsUnlock()
				TZZ7->(dbSkip())

			enddo

		endif

	elseif _aAlias[_nx] == "ZZY"

		if TZZY->(dbSeek(_cFilOrig + _cDocSep)) .and. !ZZY->(dbSeek(_cFilDest + _cDocSep))
			while TZZY->(!eof()) .and. TZZY->ZZY_FILIAL == _cFilOrig .and. TZZY->ZZY_NUMDOC == _cDocSep

				// Grava os dados na tabela do sistema na filial Osasco
				RecLock(_aAlias[_nx],.T.)
				For _ni := 1 TO FCount()
					if "_FILIAL" $ Field(_ni)
						FieldPut(_ni, _cFilDest )
					else
						FieldPut(_ni,(_aAliasTmp[_nx])->( FieldGet(_ni) ))
					endif
				Next _ni
				MsUnlock()
				TZZY->(dbSkip())

			enddo

		endif

	endif

	(_aAliasTmp[_nx])->(dbCloseArea())

next _nx

End Transaction

restarea(_aAreaZZ3)
restarea(_aAreaSZ9)
restarea(_aAreaZZ7)
restarea(_aAreaZZY)

return(_lRet)
