#INCLUDE 'RWMAKE.CH'
#DEFINE OPEN_FILE_ERROR -1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ INTTFONE บAutor  ณVinicius Leonardo   บ Data ณ  23/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importar o arquivo CSV    Integracao IRL paraบฑฑ
ฑฑบ          ณ a tabela SZA do Protheus.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function INTTFONE()

Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Importa็ใo de Planilha CSV"
Local cDesc1  := "Este programa executa a importa็ใo da planilha Excel para o arquivo SZA, para opera็๕es TROCAFONE"
Local cDesc2  := "permitindo sua valida็ใo junto เ Entrada Massiva da NF do cliente."

Private cPerg := "INTTF1"
Private nTamNfe  := TAMSX3("D1_DOC")[1]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Cliente                             ณ
//ณmv_par02 - Loja                                ณ
//ณmv_par03 - Nota Fiscal                         ณ
//ณmv_par04 - Serie                               ณ
//ณmv_par05 - Operacao                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

u_GerA0003(ProcName())

CriaSX1()

Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando Planilha CSV", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNPROC  บAutor  ณVinicius Leonardo	 บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que executa a importacao da planilha Excel do       บฑฑ
ฑฑบ          ณ cliente para a tabela SZA.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

local _aAreaSZA  := SZA->(GetArea())
local _aAreaSA1  := SA1->(GetArea())
local _aAreaSB1  := SB1->(GetArea())
local _nCnt      := 0
local _nRegImp   := 0
local _cNomeArq  := ""
Local cNumOS     := Space(10)
Local ddataOS    := Date()
Local cCodPost   := Space(10)
Local cProdFab   := Space(20)
Local cImei      := space(TamSX3("ZZ4_IMEI")[1])//Space(20)
Local cOpecel    := Space(30)
Local clocaten   := Space(10)
Local cCodcob    := Space(20)
Local cCodProc   := Space(10)
Local cDatfab    := Space(04)
Local ctpserv    := Space(20)
Local cnatend    := Space(10)
Local cNFentr    := Space(nTamNfe)
Local dDtNfcp    := Date()
Local cNReven    := Space(50)
Local cCompra    := Space(10)
Local nVal	     := 0
Local dtrecpro	 := Date()
Local cDefrec    := Space(255)
Local csincod    := space(255)
Local cNome      := Space(50)
Local cCpfCnpj   := Space(18)
Local cRgIe      := Space(18)
Local cLogra	 := Space(20)
Local cEnder	 := Space(60)
Local cCompl	 := Space(40)
Local cBair      := Space(30)
Local cCidad	 := Space(40)
Local cCodUf     := Space(3)
Local cCEP	     := Space(9)
Local cDDD1	     := Space(10)
Local cTel1  	 := Space(15)
Local cDDD2      := Space(10)
Local cTel2  	 := Space(15)
Local cDDD3	     := Space(10)
Local cTel3	     := Space(15)
Local cEmail	 := Space(64)
Local cContat	 := Space(64)
Local cCodic     := ""
Local cempres    := "" 
Local cModelo    := ""
Local cLOCAL     := Space(2)
Local nqtde      := 0
Local cchave     :=Space(10)
Local cmodel     :=Space(20)
local _aCliente  := {}
local _aDados    := {}
Local cPath      := "/IMPIMEI/"					   		// Local de gera็ใo do arquivo
Local aDirectory := Directory (cPath + "*.*")      		// Tipo de arquivo a serem exc
Local _coper     := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par05,"ZZJ_OPERA")
Local _calment   := Posicione("ZZJ", 1, xFilial("ZZJ") + mv_par05,"ZZJ_ARMENT")

If _coper == 'TF1'

	SZA->(dbSetOrder(1))
	SA1->(dbSetOrder(1))  // A1_FILIAL + A1_COD
	SB1->(dbSetOrder(1))  //B1_FILIAL + B1_COD
	ZZJ->(dbSetOrder(1))  //ZZJ_FILIAL + ZZJ_OPERA + ZZJ_LAB
	
	//Incluso para validar operacao digitada pelo usuario - edson Rodrigues - 17-08-10
	If 	empty(mv_par05)
		ApMsgInfo("Favor informar a operacao.","Operacao Invalida")
	    Return                                    
	Endif    
	If !ZZJ->(dbSeek(xFilial("ZZJ") + mv_par05))
	   	ApMsgInfo("operacao nao cadastrada. Cadastre ou informe uma opera็ใo vแlida.","Operacao Invalida")
	    Return                                    
	Else
	   ZZJ->(dbSeek(xFilial("ZZJ") + mv_par05))
	   IF ZZJ->ZZJ_BLOQ="S"
	   	    ApMsgInfo("Operacao Bloqueada.","Operacao Invalida")
	        Return                                    
	   ENDIF   
	Endif
	
	// Verifica se ja existe registros no SZA para os parametros informados
	if SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + mv_par03 + mv_par04))
		If Found()
			if ApMsgYesNos("Jแ existem IMEI's importados para esta NF. Deseja importแ-los novamente? ","Nota Fiscal jแ importada")
				while SZA->(!eof()) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_CLIENTE == mv_par01 .and. SZA->ZA_LOJA == mv_par02 .and. ;
					SZA->ZA_NFISCAL == mv_par03 .and. SZA->ZA_SERIE == mv_par04
					RecLock("SZA",.f.)
					dbDelete()
					MsUnlock()
					SZA->(dbSkip())
				enddo
			else
				ApMsgInfo("Voc๊ optou por nใo importar o arquivo novamente. O programa serแ interrompido agora.","Arquivo nใo importado")
				Return
			endif
		endif
	endif
	// Fecha o arquivo temporario caso esteja aberto
	if select("EXC") > 0
		EXC->(dbCloseArea())
	endif
	
	// Abre o arquivo DBF gerado pelo Excel do cliente
	_cTipo := "Arquivo Cliente (*.CSV)    | *.CSV | "
	_cExcelCSV := cGetFile(_cTipo,"Selecione o arquivo a ser importado")
	If Empty(_cExcelCSV)
		Aviso("Cancelada a Sele็ใo!","Voce cancelou a sele็ใo do arquivo.",{"Ok"})
		Return
	Endif
	
	if !file(_cExcelCSV)
		return
	else
		CpyT2S(_cExcelCSV,cPath)
	endif
	
	_clocalArq := alltrim(_cExcelCSV)
	_nPos     := rat("\",_clocalArq)
	if _nPos > 0
		_cNomeArq := substr(_clocalArq,_nPos+1,len(_clocalArq)-_nPos)
	endif
	
	cRootPath  := GetPvProfString( GetEnvServer(), "RootPath", "ERROR", GetADV97() )
	cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
	__CopyFile(_clocalArq, cRootPath + cPath + alltrim(_cNomeArq))
	cFile :=  cPath + alltrim(_cNomeArq)
	LPrim := .T.
	
	If FT_FUSE( cfile ) = OPEN_FILE_ERROR
		MSGINFO("Arquivo " + cFile + " nao encontrado!")
		Return
	Endif
	
	ProcRegua( FT_FLASTREC() )
	lPrim   := .f.
	clotirl := GetSx8Num("SZA","ZA_LOTEIRL")                                  
	ConfirmSX8()
	cLocal := _calment
	
	While !FT_FEOF()
		
		lMsErroAuto := .F.
		lPass :=.t.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ L linha do arquivo retorno ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		xBuffer := FT_FREADLN()
		
		IncProc()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVinicius Leonardo - Delta Decisใo 01/06/2015                          ณ
		//ณTratamento para opera็ใo TrocaFone, que tem uma planilha diferenciada.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		/* MODELO */
		nDivi   := At(";",xBuffer)
		cModelo := Substr( xBuffer , 1, nDivi - 1)
		cModelo := alltrim(cModelo)
		
		If Upper(Alltrim(cModelo)) == "ID PRODUTO" 
			FT_FSKIP()
			Loop
		EndIf	
		
		/* Codigo IMEI */
		xBuffer  := Substr(xBuffer , nDivi+1)
		nDivi    := At(";",xBuffer)
		cImei    := Substr(xBuffer,1,  nDivi - 1) 
		
		/* Valor do aparelho na NF */
		xBuffer  := Substr(xBuffer , nDivi+1)
		nDivi    := At(";",xBuffer)
		nVal     :=Val(STRTRAN(Substr(xBuffer,1,  nDivi - 1),",","."))
		
		cnfreme  := mv_par03
		
		cProdFab := cModelo	
		
	
		If !SZA->(dbSeek(xFilial("SZA") + mv_par01 + mv_par02 + cnfreme + mv_par04+cImei)) .and. !empty(cImei)
			
			// Faz verificaao se a nota e igual a que esta vindo no arquivo
			If !EMPTY(MV_PAR03) .AND. alltrim(mv_par03)<>alltrim(cnfreme)
			    ApMsgInfo("Nota Fiscal Digitada : "+alltrim(mv_par03)+"/"+mv_par04+" Nใo ้ igual a nota descriminada no arquivo. Favor verificar. ")
				lPass := .f.
			endif
			
			//Faz verificaao se o cliente digitado existe no cadastro de clientes
			SA1->(dbSetOrder(1))
			if !SA1->(dbSeek(xFilial("SA1") + mv_par01+mv_par02))
				ApMsgInfo("C๓digo Cliente : "+mv_par01+"/"+mv_par02+" Nใo cadastrado. Favor Cadastrar esse Cliente. ")
				lPass := .f.
			endif
			
			//Faz verificaao se o produto digitado existe no cadastro de clientes
			if !SB1->(dbSeek(xFilial("SB1") + cProdFab))
				ApMsgInfo("C๓digo : "+cProdFab+" Nใo cadastrado. Favor Cadastrar esse Produto. ")
				lPass := .f.
			Else
				If SB1->B1_LOCALIZ=="S"
					ApMsgInfo("C๓digo : "+cProdFab+" esta configurado como * Ultiliza Endere็o *. Favor tirar essa opcao no Cadastro de Produto.")
					lPass := .f.
				ENDIF
				If SB1->B1_RASTRO $ ("LS")
					ApMsgInfo("C๓digo : "+cProdFab+" esta configurado como * Ultiliza Lote *. Favor tirar essa opcao no Cadastro de Produto.")
					lPass := .f.
				ENDIF
				
			endif
			
			if  lPass
				reclock("SZA",.t.)			
				
					SZA->ZA_FILIAL  := xFilial("SZA") 
					SZA->ZA_CLIENTE := AvKey(mv_par01,"ZA_CLIENTE")
					SZA->ZA_LOJA    := AvKey(mv_par02,"ZA_LOJA")
					SZA->ZA_NFISCAL := AvKey(mv_par03,"ZA_NFISCAL")
					SZA->ZA_SERIE   := AvKey(mv_par04,"ZA_SERIE") 
					SZA->ZA_DATA 	:= dDataBase
					SZA->ZA_CODPRO  := AvKey(cModelo,"ZA_CODPRO")
					SZA->ZA_PRECO   := nVal
					SZA->ZA_IMEI    := AvKey(cImei,"ZA_IMEI")
					SZA->ZA_STATUS  := "N"
					SZA->ZA_MARCA	:= "TROCAFONE"
					SZA->ZA_LOCAL   := AvKey(cLocal,"ZA_LOCAL")
					SZA->ZA_LOTEIRL := AvKey(clotirl,"ZA_LOTEIRL")
					SZA->ZA_OPERBGH := AvKey(_coper,"ZA_OPERBGH") 
					
				msunlock()
				_nRegImp++
			endif		
			
		else
			
			reclock("SZA",.F.)
			
			SZA->ZA_FILIAL  := xFilial("SZA") 
			SZA->ZA_CLIENTE := AvKey(mv_par01,"ZA_CLIENTE")
			SZA->ZA_LOJA    := AvKey(mv_par02,"ZA_LOJA")
			SZA->ZA_NFISCAL := AvKey(mv_par03,"ZA_NFISCAL")
			SZA->ZA_SERIE   := AvKey(mv_par04,"ZA_SERIE")
			SZA->ZA_DATA 	:= dDataBase
			SZA->ZA_CODPRO  := AvKey(cModelo,"ZA_CODPRO")
			SZA->ZA_PRECO   := nVal
			SZA->ZA_IMEI    := AvKey(cImei,"ZA_IMEI")
			SZA->ZA_STATUS  := "N"
			SZA->ZA_MARCA	:= "TROCAFONE"
			SZA->ZA_LOCAL   := AvKey(cLocal,"ZA_LOCAL")
			SZA->ZA_LOTEIRL := AvKey(clotirl,"ZA_LOTEIRL")
			SZA->ZA_OPERBGH := AvKey(_coper,"ZA_OPERBGH") 
			
			msunlock()
			_nRegImp++
			
		endif
		
		FT_FSKIP()
	EndDo
	
	if _nRegImp > 0
		ConfirmSx8()
		ApMsgInfo("Foram importados " + alltrim(str(_nRegImp)) + " IMEI's.")
	else
		ApMsgInfo("Nenhum IMEI foi importado. Verificar o arquivo selecionado para importa็ใo. ")
	endif
Else
	ApMsgInfo("Rotina permitida apenas para opera็๕es TROCAFONE","Operacao Invalida")	
EndIf	

RestArea(_aAreaSZA)
RestArea(_aAreaSA1)
RestArea(_aAreaSB1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRIASX1  บAutor  ณVinicius Leonardo	 บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para a criacao automatica das perguntas no SX1      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Cliente ?"       		,"Cliente ?"       			,"Cliente ?"       			,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja ?"					,"Loja ?"					,"Loja ?"					,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Nr. Nota Fiscal ? "		,"Nr. Nota Fiscal ? "		,"Nr. Nota Fiscal ? "		,"mv_ch3","C",09,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Serie NF ?"				,"Serie NF ?"				,"Serie NF ?"				,"mv_ch4","C",03,0,0,"G","",""		,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Operacao ?"		   		,"Operacao ?"				,"Operacao ?"				,"mv_ch5","C",03,0,0,"G","","ZZJ"	,"",,"mv_par05","","","","","","","","","","","","","","","","")

Return Nil
