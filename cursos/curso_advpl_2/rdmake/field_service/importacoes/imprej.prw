#INCLUDE 'RWMAKE.CH'               
#DEFINE OPEN_FILE_ERROR -1  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPREJ   บAutor  ณ M.Munhoz           บ Data ณ  15/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa arquivo enviado pela Motorola com as OSs do MCLAIM บฑฑ
ฑฑบ          ณ que foram aprovadas ou reprovadas                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH - Motorola                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function IMPREJ()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de OSs aprovadas e rejeitadas do MCLAIM"
Local cDesc1  := "Este programa executa a importa็ใo do arquivo enviado pela Motorola"
Local cDesc2  := "com as OSs do MCLAIM que foram aprovadas ou reprovadas. "

Private cPerg := "IMPMCL"

u_GerA0003(ProcName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Ano                                 ณ
//ณ mv_par02 - Mes                                 ณ
//ณ mv_par03 - Batch                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1()

Pergunte(cPerg,.F.)
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

//aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1 .or. !pergunte(cPerg,.t.)
   Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando arquivo de aprovados x reprovados ...", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNPROC   บAutor  ณ M.Munhoz           บ Data ณ  13/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona o arquivo e executa a importacao                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _nRegImp   := 0
local _cNomeArq  := ""
local _cLogMCL   := ""
local aDirectory := {}
local _lImpAprov := .f.
local _lImpRej   := .f.
local _aAreaSZR  := SZR->(getarea())
local _aAreaSZU  := SZU->(getarea())
local _cNumOS    := ""
local _cLab      := "2" // Inicialmente o codigo do laboratorio esta fixo para Nextel. Caso seja necessario alterar esta rotina para outros laboratorios basta alterar o preenchimento desta variavel.
local _dDataIni  := ctod("  /  /  ")
local _dDataFim  := ctod("  /  /  ")
local _aAreaZZ4  := ZZ4->(getarea())

// Utiliza como padrao a pasta RELATO do usuario que esta processando a rotina.
PswOrder(1)
PswSeek(__cUserID)
_apswdet2  := PswRet(2)
//_usrrelat  := _aPswDet2[1,3] // diret๓rio da pasta relato
_usrrelat   := "c:\crm\"
cPath      := StrTran(alltrim(_usrrelat), "\", "/" )
aDirectory := Directory (cPath + "*.TXT")    // Tipo de arquivo   

If empty(mv_par01) .or. empty(mv_par02) .or. empty(mv_par03)
	ApMsgInfo("Favor informar Ano e Batch do arquivo.","Parโmetros incompletos")
    Return
Endif

_cTipo   := "Arquivo MCLAIM Aprov x Rejeit (*.TXT)    | *.TXT | "
_cArqRej := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cArqRej)
	apMsgStop("Voce cancelou a sele็ใo do arquivo.","Cancelada a Sele็ใo!")
	Return
Endif
if !file(_cArqRej)
	apMsgStop("Arquivo nใo localizado ou corrompido.","Arquivo invแlido!")
	return
endif

_clocalArq := alltrim(_cArqRej)
_nPos      := rat("\",_clocalArq)
if _nPos > 0
	_cNomeArq := substr(_cArqRej,_nPos+1,len(_clocalArq)-_nPos)
endif

If FT_FUSE( _clocalArq ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + _clocalArq + " nao encontrado!")
	Return
else
	_cArqData := dDataBase
	_cArqTam  := "123"
	_xNomeArq := alltrim(mv_par01) + alltrim(str(mv_par02)) + alltrim(mv_par03) + _cNomeArq
	_cLogMCL  := u_LOGMCL(_cLab, _xNomeArq, _cArqData, _cArqTam)
	if empty(_cLogMCL)
		apMsgStop('Nใo foi possํvel gravar o Log MCLAIM desta rotina. Importa็ใo interrompida.')
		return()
	endif
Endif

ProcRegua( FT_FLASTREC() )

// Ordena arquivo de itens do MCLAIM
SZR->(dbSetOrder(3)) // ZR_FILIAL + ZR_OS  + ZR_STATUS
SZU->(dbSetOrder(1)) // ZU_FILIAL + ZU_LAB + ZU_REJCOD
ZZ4->(dbSetOrder(11)) // ZZ4_FILIAL + ZZ4_OS + ZZ4_IMEI

While !FT_FEOF()             

	xBuffer := FT_FREADLN()
	            
	IncProc()

	// Habilita importacao dos itens Aprovados
	if alltrim(upper(xBuffer)) == "ACCEPTED CLAIMS"

		// Pula linha ACCEPTED CLAIMS
		IncProc()
		FT_FSKIP()
		// Pula linha de cabecalho e le conteudo da linha seguinte que eh o primeiro registro a ser importado
		IncProc()
		FT_FSKIP()

		while !FT_FEOF()

			xBuffer := FT_FREADLN()
			if empty(xBuffer) .or. left(xBuffer,2) <> "BR"
				exit
			endif
			xBuffer := strtran(xBuffer,"|"," ;")
			_aDados := {}
			_aDados := strtokarr(xBuffer, ';')
			// Foi necessario colocar este tratamento aqui porque existem linhas enviadas no arquivo Motorola com estrutura diferente. 
			// P.E. Faltando campo de IMEI, o que gera uma matriz com 10 posicoes ao inves de 11.
			_nTPrice := iif(len(_aDados)==11,val(_aDados[11]),val(_aDados[10]))
			_cReparo := iif(len(_aDados)==11,_aDados[5],_aDados[4])
			_nRegImp++
			if ZZ4->(dbSeek('06'+substr(_aDados[1],7,6) ))
				_cFilial := '06'
			elseif ZZ4->(dbSeek('02'+substr(_aDados[1],7,6) ))
				_cFilial := '02'
			else
				_cFilial := xFilial("SZR")
			endif
//			if SZR->(dbSeek(xFilial("SZR") + _aDados[1] ))
			if SZR->(dbSeek(_cFilial + _aDados[1] ))
			
				alert("alert entrei")
				reclock("SZR",.f.)
				SZR->ZR_STATUS := "A"
				SZR->ZR_TPRICE := _nTPrice
				msunlock()
				if empty(_dDataIni) .or. _dDataIni > SZR->ZR_DESPDT
					_dDataIni := SZR->ZR_DESPDT
				endif
				if empty(_dDataFim) .or. _dDataFim < SZR->ZR_DESPDT
					_dDataFim := SZR->ZR_DESPDT
				endif
			else
				_cReparo := strtran(_cReparo,"(","")
				_cReparo := alltrim(_cReparo)
				_cReparo := left(_cReparo,5)
				reclock("SZR",.t.)
//				SZR->ZR_FILIAL := xFilial("SZR")
				SZR->ZR_FILIAL := _cFilial //xFilial("SZR")
				SZR->ZR_CODIGO := _cLogMCL
				SZR->ZR_LAB    := _cLab
				SZR->ZR_OS     := _aDados[1]
				SZR->ZR_IMEIENT:= _aDados[2]
				SZR->ZR_IMEISAI:= _aDados[2]
				SZR->ZR_REPARO := _cReparo
				SZR->ZR_STATUS := "A"
				SZR->ZR_TPRICE := _nTPrice
				SZR->ZR_ANOMCL := mv_par01
				SZR->ZR_MESMCL := mv_par02
				SZR->ZR_BATCH  := mv_par03
				SZR->ZR_OSZZ4  := iif(len(_aDados[1])>=12,substr(_aDados[1],7,6),"")
				msunlock()
			endif

			if empty(_dDataIni) .or. _dDataIni > SZR->ZR_DESPDT
				_dDataIni := SZR->ZR_DESPDT
			endif
			if empty(_dDataFim) .or. _dDataFim < SZR->ZR_DESPDT
				_dDataFim := SZR->ZR_DESPDT
			endif

			IncProc()
			FT_FSKIP()

		enddo

	endif

	// Habilita importacao dos itens Rejeitados
	if alltrim(upper(xBuffer)) == "REJECTED CLAIMS"

		// Pula linha REJECTED CLAIMS
		IncProc()
		FT_FSKIP()
		// Pula linha de cabecalho e le conteudo da linha seguinte que eh o primeiro registro a ser importado
		IncProc()
		FT_FSKIP()

		while !FT_FEOF()

			xBuffer := FT_FREADLN()
			if empty(xBuffer) 
				exit
			endif

			if left(xBuffer,2) == "BR"

				// Tratamento para a linha de Item Rejeitado
				xBuffer := strtran(xBuffer,"|"," ;")
				_aDados := {}
				_aDados := strtokarr(xBuffer, ';')
				_nTPrice := iif(len(_aDados)==11,val(_aDados[11]),val(_aDados[10]))

				if ZZ4->(dbSeek('06'+substr(_aDados[1],7,6) ))
					_cFilial := '06'
				elseif ZZ4->(dbSeek('02'+substr(_aDados[1],7,6) ))
					_cFilial := '02'
				else
					_cFilial := xFilial("SZR") 
				endif

//				if SZR->(dbSeek(xFilial("SZR") + alltrim(_aDados[1]) ))
				if SZR->(dbSeek(_cFilial + alltrim(_aDados[1]) ))
					_cNumOS := _aDados[1]
					_nRegImp++
					reclock("SZR",.f.)
					SZR->ZR_STATUS := "R"
					SZR->ZR_TPRICE := _nTPrice
					msunlock()

					// Passa para a proxima linha do arquivo com os motivos da rejeicao
					IncProc()
					FT_FSKIP()

					// Tratamento para a linha de Motivos da Rejeicao. Note que existe mais de um motivo de rejeicao na mesma linha.
					xBuffer := FT_FREADLN()
					xBuffer := strtran(xBuffer,"|"," ;")
					xBuffer := strtran(xBuffer,"."," ;")
					_aRejeit:= {}
					_aDados := {}
					_aDados := strtokarr(xBuffer, ';')
					_nRegImp++
					// Tratamento para diversos tipos de rejeicao na mesma linha.
					for x := 1 to len(_aDados)
						if x > 3 .and. val(_aDados[x]) > 0
							_cCodRej := _aDados[x]
							_cDesRej := iif(x < len(_aDados),_aDados[x+1],"")
							aAdd(_aRejeit, {_cNumOS, strzero(val(_cCodRej),3), alltrim(_cDesRej)})
						endif
					next x 
					if len(_aRejeit) > 0
						for y := 1 to len(_aRejeit)
							reclock("SZT",.t.)
//							SZT->ZT_FILIAL  := xFilial("SZT")
							SZT->ZT_FILIAL  := _cFilial 
							SZT->ZT_CODIGO  := _cLogMCL
							SZT->ZT_LAB     := _cLab
							SZT->ZT_OS      := _aRejeit[y,1]
							SZT->ZT_REJCOD  := _aRejeit[y,2]
							SZT->ZT_REJDES  := _aRejeit[y,3]
							SZT->ZT_ANOMCL  := mv_par01
							SZT->ZT_MESMCL  := mv_par02
							SZT->ZT_BATCH   := mv_par03
							msunlock()
//							if !empty(_aRejeit[y,2]) .and. !SZU->(dbSeek(xFilial("SZU")+_cLab+_aRejeit[y,2] ))
							if !empty(_aRejeit[y,2]) .and. !SZU->(dbSeek(_cFilial+_cLab+_aRejeit[y,2] ))
								reclock("SZU",.t.)
//								SZU->ZU_FILIAL := xFilial("SZU")
								SZU->ZU_FILIAL := _cFilial
								SZU->ZU_LAB    := _cLab
								SZU->ZU_REJCOD := _aRejeit[y,2]
								SZU->ZU_REJDES := _aRejeit[y,3]
								msunlock()
							endif
						next y
					endif
				endif
			endif

			IncProc()
			FT_FSKIP()

		enddo

	endif

	FT_FSKIP()

EndDo

restarea(_aAreaZZ4)

if !empty(_dDataIni) .and. !empty(_dDataFim)
	tcSqlExec('EXEC PROTHEUS_BI.dbo.STP_CARGA_MCLAIMSIFT '+dtos(_dDataIni)+', '+dtos(_dDataFim))
endif

if _nRegImp > 0
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " registros.")
else
	ApMsgInfo("Nenhum registro foi importado. Verificar o arquivo selecionado para importa็ใo. ")
endif

restarea(_aAreaSZR)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณ M.Munhoz           บ Data ณ  15/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria grupo de perguntas no SX1 automaticamente             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CriaSX1()

PutSX1(cPerg,'01','Ano'                           ,'Ano'                           ,'Ano'                           ,'mv_ch1','C',4 ,0,0,'G',''                    ,''      ,'','S','mv_par01',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'02','Mes'                           ,'Mes'                           ,'Mes'                           ,'mv_ch2','N',2 ,0,0,'G',''                    ,''      ,'','S','mv_par02',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')
PutSX1(cPerg,'03','Batch'                         ,'Batch'                         ,'Batch'                         ,'mv_ch3','C',1 ,0,0,'G',''                    ,''      ,'','S','mv_par03',''               ,''               ,''               ,'',''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,''               ,'','','')

return
