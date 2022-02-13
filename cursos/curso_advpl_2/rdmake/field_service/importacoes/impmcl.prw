#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPMCL   บAutor  ณ M.Munhoz           บ Data ณ  13/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa arquivo MCLAIM enviado para a Motorola atraves do  บฑฑ
ฑฑบ          ณ sistema SIFT                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH - NEXTEL                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function IMPMCL()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de arquivo MCLAIM enviado a Motorola atrav้s do sistema SIFT"
Local cDesc1  := "Este programa executa a importa็ใo do arquivo MCLAIM. "
Local cDesc2  := "Esta rotina s๓ deve ser executada ap๓s a transmissใo para o sistema SIFT."

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

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando arquivo MCLAIM...", .T. )

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
Local aDirectory := {}
local _dDataIni  := ctod("  /  /  ")
local _dDataFim  := ctod("  /  /  ")
local _aAreaZZ4  := ZZ4->(getarea())

// Utiliza como padrao a pasta RELATO do usuario que esta processando a rotina.
PswOrder(1)
PswSeek(__cUserID)
_apswdet2  := PswRet(2)
_usrrelat  := _aPswDet2[1,3] // diret๓rio da pasta relato
cPath      := StrTran(alltrim(_usrrelat), "\", "/" )
aDirectory := Directory (cPath + "*.TXT")    // Tipo de arquivo   

If empty(mv_par01) .or. empty(mv_par02) .or. empty(mv_par03)
	ApMsgInfo("Favor informar Ano, Mes e Batch do arquivo.","Parโmetros incompletos")
    Return
Endif

_cTipo   := "Arquivo MCLAIM (*.TXT)    | *.TXT | "
_cArqMCL := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
If Empty(_cArqMCL)
	apMsgStop("Voce cancelou a sele็ใo do arquivo.","Cancelada a Sele็ใo!")
	Return
Endif
if !file(_cArqMCL)
	apMsgStop("Arquivo nใo localizado ou corrompido.","Arquivo invแlido!")
	return
endif

_clocalArq := alltrim(_cArqMCL)
_nPos      := rat("\",_clocalArq)
if _nPos > 0
	_cNomeArq := substr(_cArqMCL,_nPos+1,len(_clocalArq)-_nPos)
endif

If FT_FUSE( _clocalArq ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + _clocalArq + " nao encontrado!")
	Return
else
	_cArqData := dDataBase
	_cArqTam  := "123"
	_cLogMCL  := u_LOGMCL("1", _cNomeArq, _cArqData, _cArqTam)
	if empty(_cLogMCL)
		apMsgStop('Nใo foi possํvel gravar o Log MCLAIM desta rotina. Importa็ใo interrompida.')
		return()
	endif
Endif

ZZ4->(dbSetOrder(11)) // ZZ4_FILIAL + ZZ4_OS + ZZ4_IMEI

ProcRegua( FT_FLASTREC() )

FT_FSKIP() // Pula a linha HDR  do cabe็alho
FT_FSKIP() // Pula a linha HDR2 do cabe็alho
FT_FSKIP() // Pula a linha HDR3 do cabe็alho

_lAvisaFil := .f.

While !FT_FEOF()             

	xBuffer := FT_FREADLN()
	            
	IncProc()

	xBuffer := strtran(xBuffer,"|"," ;")
	_aDados := {}
	_aDados := strtokarr(xBuffer, ';')

    if len(_aDados) > 0 //.and. !empty(_cLogMCL)
		if alltrim(_aDados[1]) == "CLM"
			if ZZ4->(dbSeek('06'+substr(_aDados[21],7,6) ))
				_cFilial := '06'
			elseif ZZ4->(dbSeek('02'+substr(_aDados[21],7,6) ))
				_cFilial := '02'
			else
				_cFilial := xFilial("SZR")
				_lAvisaFil := .t. 
			endif
		   	reclock("SZR",.T.)
		  	SZR->ZR_FILIAL  := _cFilial //xFilial("SZR")
			SZR->ZR_CODIGO  := _cLogMCL
			SZR->ZR_LAB     := "2" // Nextel
			SZR->ZR_DTIMP   := dDataBase
			SZR->ZR_CIDADE  := _aDados[ 3]
			SZR->ZR_NFE     := _aDados[ 7]
			SZR->ZR_CODAUTO := _aDados[ 8]
			SZR->ZR_PAIS    := _aDados[18]
			SZR->ZR_TRKIN   := _aDados[19]
			SZR->ZR_TRKOUT  := _aDados[20]
			SZR->ZR_MASCC   := _aDados[61]
			SZR->ZR_OS      := _aDados[21]
			SZR->ZR_OSZZ4   := iif(len(_aDados[21])>=12,substr(_aDados[21],7,6),"")
			SZR->ZR_CODOPE  := _aDados[23]
			SZR->ZR_TRANS   := _aDados[24]
			SZR->ZR_APCCOD  := _aDados[25]
			SZR->ZR_MODELO  := _aDados[26]
			SZR->ZR_MSNENT  := _aDados[29]
			SZR->ZR_MSNSAI  := _aDados[30]
			SZR->ZR_IMEIENT := _aDados[31]
			SZR->ZR_IMEISAI := _aDados[32]
			SZR->ZR_STREPA  := _aDados[36]
			SZR->ZR_BALCDT  := ctod(_aDados[39])
			SZR->ZR_BALCHR  := _aDados[40]
			SZR->ZR_DESPDT  := ctod(_aDados[43])
			SZR->ZR_DESPHR  := _aDados[44]
			SZR->ZR_REPDT   := ctod(_aDados[45])
			SZR->ZR_REPTMP  := _aDados[46]
			SZR->ZR_REPCTMP := _aDados[47]
			SZR->ZR_CONCTMP := _aDados[48]
			SZR->ZR_NFC     := _aDados[49]
			SZR->ZR_NFCDT   := ctod(_aDados[50])
			SZR->ZR_VSIN    := _aDados[53]
			SZR->ZR_VSOUT   := _aDados[54]
			SZR->ZR_RECLAM  := _aDados[55]
			SZR->ZR_TECN    := _aDados[56]
			SZR->ZR_PROBL   := _aDados[57]
			SZR->ZR_REPARO  := _aDados[59]
			SZR->ZR_ANOMCL  := mv_par01
			SZR->ZR_MESMCL  := mv_par02
			SZR->ZR_BATCH   := mv_par03
			SZR->ZR_SPC     := _aDados[64]
			//SZR->ZR_STATUS  := _aDados[  ]
			//SZR->ZR_TPRICE  := _aDados[  ]
			msunlock()
			_nRegImp++
			if empty(_dDataIni) .or. _dDataIni > ctod(_aDados[43])
				_dDataIni := ctod(_aDados[43])
			endif
			if empty(_dDataFim) .or. _dDataFim < ctod(_aDados[43])
				_dDataFim := ctod(_aDados[43])
			endif
		elseif alltrim(_aDados[1]) == "CMP"
			if ZZ4->(dbSeek('06'+substr(_aDados[3],7,6) ))
				_cFilial := '06'
			elseif ZZ4->(dbSeek('02'+substr(_aDados[3],7,6) ))
				_cFilial := '02'
			else
				_cFilial := xFilial("SZS")
				_lAvisaFil := .t. 
			endif
		   	reclock("SZS",.T.)
		  	SZS->ZS_FILIAL  	:= _cFilial //xFilial("SZS")
			SZS->ZS_CODIGO  	:= _cLogMCL
			SZS->ZS_LAB     	:= "2" // Nextel
			SZS->ZS_DTIMP   	:= dDataBase
			SZS->ZS_CODAUTO 	:= _aDados[ 2]
			SZS->ZS_OS      	:= _aDados[ 3]
			SZS->ZS_OSZZ4   	:= iif(len(_aDados[ 3])>=12,substr(_aDados[ 3],7,6),"")
			SZS->ZS_PECA    	:= _aDados[ 4]
			SZS->ZS_QUANT   	:= val(_aDados[ 5])
			SZS->ZS_TPPECA  	:= _aDados[ 7]
			SZS->ZS_REFDESI 	:= _aDados[ 8]
			SZS->ZS_FALHA   	:= _aDados[10]
			SZS->ZS_TPREPAR 	:= _aDados[11]
			SZS->ZS_ANOMCL  	:= mv_par01
			SZS->ZS_MESMCL  	:= mv_par02
			SZS->ZS_BATCH   	:= mv_par03
			msunlock()
			_nRegImp++
		endif
	endif

	FT_FSKIP()

EndDo

if _lAvisaFil
	apMsgAlert('Caro usuแrio. Algumas OSs nใo foram encontradas na base de dados e foram gravadas com a filial logada neste momento: '+_cFilial+'. Caso a filial logada nใo seja a desejada, serแ necessแria excluir o MCLAIM importado e reimportแ-lo na filial correta.','Filial de processamento') 
endif 

restarea(_aAreaZZ4)

if !empty(_dDataIni) .and. !empty(_dDataFim)
	tcSqlExec("EXEC PROTHEUS_BI.dbo.STP_CARGA_MCLAIMSIFT '"+dtos(_dDataIni)+"', '"+dtos(_dDataFim)+"'")                                                   
endif

if _nRegImp > 0
	ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " registros.")
else
	ApMsgInfo("Nenhum registro foi importado. Verificar o arquivo selecionado para importa็ใo. ")
endif

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
