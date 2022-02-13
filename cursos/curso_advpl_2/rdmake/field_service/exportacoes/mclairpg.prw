#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCLAIRPG  º Autor ³ Edson Rodrigues    º Data ³  05/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera arquivo MCLAIRPG - Motorola coma as OS dos            º±±
±±º          ³ Processo Nextel                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Mclairpg()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Private oGeraTxt
	Private cString := "SD2"
	Private cPerg := "MCLRPG"
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³mv_par01 - Dt. NF. Saida Inicial                  ³
    //³mv_par02 - Dt. NF. Saida Final                    ³
    //³mv_par03 - Armazens RPG                           |
    //|mv_par04 - Notas Fiscais Saida                    ³
    //|mv_par05 - Serie(s) Notas Fiscais Saida           |
    //|mv_par08 - Nome do arquivo                        |
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	u_GerA0003(ProcName())
	
	dbSelectArea("SD2")
	dbSetOrder(3)    //D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM
	
	CriaSX1()
	Pergunte(cPerg,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa gera um arquivo texto, conforme os parametros "
	@ 18,018 Say " definidos  pelo usuario,  com os registros da Nota de saida "
	@ 26,018 Say " dos processos RPG Nextel/Motorola "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	
	Activate Dialog oGeraTxt Centered
Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
	±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Static Function OkGeraTxt
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cArqTxt := lower(AllTrim(__RELDIR)+ Alltrim(mv_par06)) + ".TXT"
	Private csoftout,csoftin,cqual,ctransc,cartime,cminumb,_cproblem1,_cproblem2,_crepair1,_crepair2,_cLab,_ccodrecl
	
	If FILE(cArqTxt)
		If !msgbox("Já existe um arquivo com este nome. Deseja substituir?","Atencao!","YESNO")
			Close(oGeraTxt)
		Return
		Endif
	Endif
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"
	Private aerros :={}
	
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Processa({|| RunCont() },"Processando...")
	
	If len(aerros) > 0
		apMsgStop("Ocorreram erros na geracao do arquvio MClaims.  Imprima e verifique e corrija os erros encontrados.")
		U_tecrx038(aerros)
		aerros:={}
	Endif

	
Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  08/05/03   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
	±±º          ³ monta a janela com a regua de processamento.               º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Static Function RunCont

	Local _ccpfclie,_cnomcons,_cendcons,_ccidcons,_cestcons,_ccepcons,_ctelcons,_cemacons,_cendcons3,_ccompcon,_ctranspo
	Local _cstrepmo,_ctrakout,_ctemprep,_ctcycler,_ctcyclec,_cflagnfc,_cdtnfcom,ccpfclie,_cnomcons,_cendcons,_ccidcons,_ccompcon
	Local _cestcons,_ccepcons,_ctelcons,_cemacons,_cendcons3
	Local  cidregL1  :='HDR'
	Local  cidregL2  :='HDR2'
	Local  cidregL3  :='HDR3'
	Local  cidregL4  :='CLM'
	Local  cidregL5  :='CMP'//Detalhes do Componente (pecas)
	Local  cidregL6  :='CLD'
	Local  cidregL7  :='CCD'
	Local  cidregL8  :='SLK'
	Local  cidregL9  :='TRA'
	Local  cCLMCRT   :='CLMCRT'
	Local  ccodmask  :='BR000536'
	Local  CR        :=""
	Local coperac    :=""
	Local aoperac    :={}
	Local _cTARRPG   := GetMV("MV_XARTRPG")
	Local _cTRARPG   := GetMV("MV_TRANRPG")
	local aAreaZZ4   := ZZ4->(getarea())
	
	Local   cDtcriOS:=substr(dtos(ddatabase),7,2)+'/'+substr(dtos(ddatabase),5,2)+'/'+left(dtos(ddatabase),4)
	Local nTamLin, cLin, cCpo
    
	If !empty(alltrim(mv_par03))
		_ccontarm:=alltrim(mv_par03)
		for x:=1 to len(_ccontarm)
			ndiv:=AT("/",_ccontarm)
			If !ndiv = nil .and. ndiv > 0
				_carm:=substr(_ccontarm,1,ndiv-1)
				_ccontarm:=substr(_ccontarm,ndiv+1)
				If  !_carm $ _cTARRPG
					MsgAlert("Armazem : "+_carm+" digitado nao pertence ao processo RPG, Favor digitar um armazem valido ou inclui-lo no parametro : MV_XARTRPG","Atencao")
				RETURN
				Endif
			Elseif !_ccontarm $ _cTARRPG
				MsgAlert("Armazem : "+_ccontarm+" digitado nao pertence ao processo RPG, Favor digitar um armazem valido ou inclui-lo no parametro : MV_XARTRPG","Atencao")
			RETURN
			Endif
		Next
	Else
		MsgAlert("Deve ser digitado pelo menos um armazem valido. Favor digitar o armazem","Atencao")
	ENDIF
  
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	dbSelectArea("SD2")
	SD2->(dbSetOrder(1))
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	dbSelectArea("ZAD")
	ZAD->(dbsetOrder(1))  // ZAD_FILIAL + ZAD_MODEL + ZAD_FINIME + ZAD_VERSOF
	dbSelectArea("SZ9")
	SZ9->(dbsetOrder(1))  // Z9_FILIAL + Z9_PARTNR + Z9_PEDPECA
	ZZ4->(dbSetOrder(4))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_STATUS

	_cCount  := CR + " SELECT COUNT(*) NRREG "
	_cSelect := CR + " SELECT F2_CLIENTE,F2_LOJA,'' AS NFCOMPR,'' AS DTNFCOM,'C0022' AS CODRECL,'' AS DEFRECL,'NEX' AS CODOPER, "
	_cSelect += CR + " '' AS CODTRAN,'' AS CODAUTO ,'' AS TRACKIN,'' AS OSAUTOR,'' AS INFACES,'' AS CTRLACR,'' AS CPFCLI, "
	_cSelect += CR + " '' AS CNPJNFC,'' AS SERNFC,SD2.D2_DOC,SD2.D2_ITEM,'BR536'+ RIGHT(RTRIM(SD2.D2_DOC),5)+RIGHT(RTRIM(SD2.D2_ITEM),2) AS 'MASC_CODE', "
	_cSelect += CR + " '' AS 'TRANS_CODE','' AS IMEI,'' AS CARCAC,SD2.D2_COD,SD2.D2_PEDIDO,SD2.D2_ITEMPV,SD2.D2_QUANT,B1_CODMOTO,B1_XCODAPC,B1_CREFDES,B1_NREFDES,D1_EMISSAO,F1_HORA,D1_DTDIGIT,D1_DTDOCA,D1_HRDOCA,F2_SAIROMA, "
	_cSelect += CR + " F2_HSAIROM,SD2.D2_SERIE,SD2.D2_EMISSAO,F2_HORA,D1_DOC NFENTRADA,A1.A1_NOME,A1.A1_NREDUZ "
    
	_cFrom   := CR + " FROM   "+RetSqlName("SD2")+" AS SD2 (nolock) "
   
     
	_cJoin   := CR + " LEFT OUTER JOIN (SELECT D1_FILIAL,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD,D1_ITEM,D1_EMISSAO,F1_HORA,D1_DTDIGIT,D1_DTDOCA,D1_HRDOCA  "
	_cJoin   += CR + "                  FROM  "+RetSqlName("SD1")+"  D1 (NOLOCK)
	_cJoin   += CR + "                         INNER JOIN (SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_HORA FROM SF1020 WHERE D_E_L_E_T_='' AND F1_FILIAL='02') AS F1 "
	_cJoin   += CR + "                         ON F1_FILIAL=D1_FILIAL AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA "
	_cJoin   += CR + "                  WHERE D1.D_E_L_E_T_='' AND D1_FILIAL='"+xFilial("SD1")+"') AS SD1 "
	_cJoin   += CR + " ON D1_FILIAL=SD2.D2_FILIAL AND D1_DOC=SD2.D2_NFORI AND D1_SERIE=SD2.D2_SERIORI AND D1_ITEM=SD2.D2_ITEMORI AND D1_COD=SD2.D2_COD "
	_cJoin   += CR + " INNER JOIN (SELECT B1_COD,B1_XCODAPC,B1_CREFDES,B1_NREFDES,B1_CODMOTO FROM "+RetSqlName("SB1")+" B1 (NOLOCK)  WHERE B1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"') AS SB1 "
	_cJoin   += CR + " ON B1_COD=SD2.D2_COD "
	_cJoin   += CR + " INNER JOIN "+RETSQLNAME("SA1")+" A1 ON A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+XFILIAL("SA1")+"'  "
	_cJoin   += CR + "              AND A1.A1_COD = SD2.D2_CLIENTE AND A1.A1_LOJA = SD2.D2_LOJA "
	_cJoin   += CR + " INNER JOIN "+RETSQLNAME("SF2")+" F2 ON F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+XFILIAL("SF2")+"'  "
	_cJoin   += CR + "              AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE  "
    
	_cWhere  := CR + " WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D2_EMISSAO>='"+dtos(mv_par01)+"' AND SD2.D2_EMISSAO<='"+dtos(mv_par02)+"' "
	_cWhere  += CR + " AND '"+alltrim(mv_par03)+"' LIKE '%'+RTRIM(SD2.D2_LOCAL)+'%' "
	If ! empty(mv_par04)
		_cWhere  += CR + " AND '"+alltrim(mv_par04)+"' LIKE '%'+RTRIM(SD2.D2_DOC)+'%' "
		_cWhere  += CR + " AND '"+alltrim(mv_par05)+"' LIKE '%'+RTRIM(SD2.D2_SERIE)+'%' "
	Endif
     /*
     If !empty(mv_par06)
         _cWhere  += CR + " AND '"+alltrim(mv_par06)+"' LIKE '%'+RTRIM(SD2.D2_TES)+'%' "   
     Endif
     */
	_cOrder  := CR + " ORDER BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM,D2_LOCAL "
	_cQryReg := _cCount + _cFrom + _cJoin + _cWhere
	_cQryReg := strtran(_cQryReg, CR, "")
     //memowrite("mclaims_rpg.sql",_cQryReg)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryReg),"REG",.T.,.T.)
	dbselectarea("REG")
	REG->(dbgotop())
	_nReg := REG->NRREG
	Procregua(_nReg)
	REG->(dbCloseArea())
     
    // Grava query em arquivo texto pra ser utilizado pelo Query Analiser
	_cQuery := _cSelect + _cFrom + _cJoin + _cWhere + _cOrder
	memowrite("MCLAIMS_RPG.SQL",_cQuery )
	_cQuery := strtran(_cQuery, CR, "")
     

	If select("QRY") > 0
		QRY->(dbCloseArea())
	endif

     // Gera arquivos temporario com resultado da Query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
	TcSetField("QRY", "D2_EMISSAO","D")
	TcSetField("QRY", "D1_EMISSAO","D")
	TcSetField("QRY", "D1_DTDIGIT","D")
	TcSetField("QRY", "F2_SAIROMA","D")
	TcSetField("QRY", "D1_DTDOCA","D")
	TcSetField("QRY", "DTNFCOM","D")
     
     
    //LINHA 1
	cLin:=cidregL1+"|"+cCLMCRT+"|"+cDtcriOS+"|"+'00:00'+"|"+ccodmask+"||"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
		Endif
	Endif

    //LINHA 2
	cLin:=cidregL2+"|"+"|"+"|"+"|"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
		Endif
	Endif
	    
	//LINHA 3
	cLin:=cidregL3+"|"+"|"+"|"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
		Endif
	Endif
	    
	//LINHA 4
	QRY->(dbGoTop())
	If QRY->(!EOF())
		While QRY->(!EOF())
			_lpassou  :=.t.
			_lyespprg :=.t.
			_lgerouOS :=.f.
	            
			_xCodAPC	:= QRY->B1_XCODAPC
			_cIMEIIN	:= QRY->IMEI
			_cIMEIOUT	:= QRY->IMEI
			_cMascCode	:= QRY->MASC_CODE
			_cDtRepar	:= ""
			_cMSNIN	:= QRY->CARCAC
			_cMSNOUT	:= QRY->CARCAC
			cModel		:= ""
			_cDtBalca	:= ""
			_cHrBalca	:= ""
	            
			dbSelectArea("SC6")
			IF SC6->(dbseek(xFilial("SC6")+ QRY->D2_PEDIDO+QRY->D2_ITEMPV+QRY->D2_COD))
				_cOSnext:=ALLTRIM(SC6->C6_OSGVS)
				ctransc :=ALLTRIM(SC6->C6_XTRANSC)
				_cpeditem:=ALLTRIM(SC6->C6_NUM)+ALLTRIM(SC6->C6_ITEM)
				IF !EMPTY(SC6->C6_NUMOS)
	                  //If !ApmsgYesNo("Ja foi gerado arquivo para o Mclaim do partnumber: "+ALLTRIM(QRY->D2_COD)+ " nessa NFS/SERIE/ITEM : "+ALLTRIM(QRY->D2_DOC)+"/"+ALLTRIM(QRY->D2_SERIE)+"/"+ALLTRIM(QRY->D2_ITEM)+". Deseja gerar o arquivo para Mclaims novamente ? ", "Partnumber ja Enviado ao Mclaims !!")
	                  //   QRY->(dbSkip())
	                  //   loop	                  
	                  //Else
					_lgerouOS:=.t.
	                  //Endif 
				ENDIF
	               
					// Busca informacoes do IMEI velho (nao reparado)
				if !empty(SC6->C6_XIMEOLD) .and. !empty(SC6->C6_IMEINOV)
					// Procura ultima passagem do IMEI no laboratorio
					if ZZ4->(dbSeek(xFilial('ZZ4') + SC6->C6_XIMEOLD))
						_nRecZZ4 := 0
						while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial('ZZ4') .and. ZZ4->ZZ4_IMEI == SC6->C6_XIMEOLD
							_nRecZZ4 := ZZ4->(recno())
							ZZ4->(dbSkip())
							if ZZ4->ZZ4_IMEI <> SC6->C6_XIMEOLD
								exit
							endif
						enddo
						ZZ4->(dbGoTo(_nRecZZ4))
						_dEntrDoca := ZZ4->ZZ4_DOCDTE
						_dFaturam  := ZZ4->ZZ4_NFSDT
						_xCodAPC   := posicione('SB1',1,xFilial('SB1')+ZZ4->ZZ4_CODPRO, 'B1_XCODAPC')
						cCodMoto	:= posicione('SB1',1,xFilial('SB1')+ZZ4->ZZ4_CODPRO, 'B1_CODMOTO')
						_cIMEIIN	:= SC6->C6_XIMEOLD
						_cIMEIOUT	:= SC6->C6_IMEINOV
						//_cMascCode	:= 'BR5360' + left(ZZ4->ZZ4_OS,6) 
						_cdtdespc	:= substr(DTOS(ZZ4->ZZ4_DOCDTS),7,2)+'/'+substr(DTOS(ZZ4->ZZ4_DOCDTS),5,2)+'/'+left(DTOS(ZZ4->ZZ4_DOCDTS),4)
						_chrdespc	:= left(ZZ4->ZZ4_DOCHRS,2)+":"+substr(ZZ4->ZZ4_DOCHRS,3,2)
						_cDtRepar	:= substr(ZZ4->ZZ4_ATULT,7,2)+'/'+substr(ZZ4->ZZ4_ATULT,5,2)+'/'+left(ZZ4->ZZ4_ATULT,4) 
						_cMSNIN	:= ZZ4->ZZ4_CARCAC
						_cMSNOUT	:= _cMSNOUT
						_cDtBalca	:= substr(dtos(ZZ4->ZZ4_NFEDT),7,2)+'/'+substr(dtos(ZZ4->ZZ4_NFEDT),5,2)+'/'+left(dtos(ZZ4->ZZ4_NFEDT),4)
						_cHrBalca	:= left(ZZ4->ZZ4_NFENR,5) 
						
						if !empty(cCodMoto)
							cModel	:= Posicione("SB1",1,xFilial("SB1") + cCodMoto, "B1_GRUPO")
						else 
							cModel	:= Posicione("SB1",1,xFilial("SB1") + ZZ4->ZZ4_CODPRO, "B1_GRUPO")
						endif
                
					endif
					
				endif
					
			ENDIF
	            
			If  empty(ctransc)
				dbSelectArea("SZ9")
				IF SZ9->(dbseek(xFilial("SZ9")+ QRY->D2_COD+_cpeditem))
					_lyespprg:=.f.
				ELSEIF SZ9->(dbseek(xFilial("SZ9")+ QRY->B1_CODMOTO+_cpeditem))
					_lyespprg:=.f.
				ENDIF
			ENDIF
	            
	               
			csoftin   :=''
			cartime   :="00000000000000000000"
			cminumb   :="NA"
			_ccodrecl :=""
                
                //Incluso validação, conforme solicitação da Marcia Nery - Edson rodrigues - 30/09/10
                //Para os processos de RPG (IPC, IPF, IPR e IPT) solicito que seja utilizada a combinação abaixo:
                //Atual: C0022 P0021 R0003
                //Correto: C0022 P0008 R0003
                //Para o processo de Amostras ( IR2 E IRF )
                //Atual: C0022 P0021 R0003
                // Correto: C0022 P0008 R0037
			cCODTEC :="RPG001"
                
			IF ctransc $ "IPC/IPF/IPR/IPT"
				_cproblem1:="P0008"
				_cproblem2:=""
				_crepair1 :="R0003"
				_crepair2 :=""
			ELSEIF ctransc $ "IR2/IRF"
				_cproblem1:="P0008"
				_cproblem2:=""
				_crepair1 :="R0037"
				_crepair2 :=""
                
			ELSE  //Caso não seja nenhum dos transcode, pega o padrão como estava - Edson Rodrigues - 30/09/10.
				_cproblem1:="P0021"
				_cproblem2:=""
				_crepair1 :="R0003"
				_crepair2 :=""
			ENDIF

			_cpartnr  :=IIF(!EMPTY(QRY->B1_CODMOTO),ALLTRIM(QRY->B1_CODMOTO),ALLTRIM(QRY->D2_COD))
                  
			// Alimenta cModel apenas quando nao tiver sido alimentado pelo ZZ4 (aparelho velho)
			if empty(cModel)
				cmodel  :=Posicione("SB1",1,xFilial("SB1") + QRY->B1_CODMOTO, "B1_GRUPO")
			endif
			_cOSnext  :=""
                
			IF empty(cmodel)
				cmodel  :=Posicione("SB1",1,xFilial("SB1") + QRY->D2_COD, "B1_GRUPO")
			Endif
                
			dbSelectArea("ZAD")
			IF ZAD->(dbseek(xFilial("ZAD")+ cmodel))
				csoftout:=ZAD->ZAD_VERSOF
			ELSE
				csoftout:=""
			ENDIF
				
                
			If (!empty(ctransc))
                   
				IF !alltrim(ctransc) $ _cTRARPG
					AADD(aerros,{'ERRO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->D2_COD),"Transaction Code "+alltrim(ctransc)+ " nao e um transaction ("+_cTRARPG+") da operacao RPG : Transaction Code Errado, Corrija o pedido/item : "+_cpeditem,"OK gravado no arquivo."})
				ENDIF
                   
				IF EMPTY(QRY->B1_CODMOTO)
					AADD(aerros,{'ERRO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->D2_COD),"Codigo alternativo nao cadastrado, produto : "+ALLTRIM(QRY->D2_COD),"Corrija o cadastro do produto. OK gravado no arquivo."})
                      //MsgAlert("Informacao importante faltando no cadastro de produtos. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
		              //Return
					_lpassou:=.t.
				Endif
              
				IF EMPTY(cmodel)
					AADD(aerros,{'ERRO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->B1_CODMOTO),"Grupo (modelo) Produto não cadastrado : "+ALLTRIM(QRY->D2_COD),"Corrija o cadastro do  produto. OK gravado no arquivo."})
                     //MsgAlert("Informacao importante faltando no cadastro de produtos. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
		             //Return
					_lpassou:=.t.
				Endif

				_ccpfclie :=""
				_cnomcons :=""
				_cendcons :=""
				_ccidcons :=""
				_cestcons :=""
				_ccepcons :=""
				_ctelcons :=""
				_cemacons :=""
				_cendcons3:=""
				_ccompcon :=""
				_ctranspo := ALLTRIM(Posicione("SA4",1,xFilial("SA4") + QRY->CODTRAN,"A4_CODTRAM"))
				_cstrepmo :="SHP"
				_ctrakout :=""
				_ccopoer  := ALLTRIM(QRY->CODOPER)
		          //Incluir ponto de entrada na NFS para solicitar ao usuário a inclusao da gravacao do Lacre, F2_TRACKOU 
				_codpro   := cmodel
				_codnewpro:=""
				_ccodrecl :=ALLTRIM(QRY->CODRECL)
				_codautfor:=""
				_nhora    :=0
				_chora    :=""
				_hrdocent :=""
				_hrdocsai :=""
				_hrnfent  :=""
				_hrnfsai  :=""
			      
			      
			      //hora de Emissao Entrada X hora da Doca entrada
				If empty(QRY->F1_HORA) .and.  !empty(QRY->D1_HRDOCA)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->D1_HRDOCA))
						If substr(ALLTRIM(QRY->D1_HRDOCA),I,1) $ "0123456789"
							_hrnfent:=_hrnfent+substr(ALLTRIM(QRY->D1_HRDOCA),I,1)
							_hrdocent:=_hrdocent+substr(ALLTRIM(QRY->D1_HRDOCA),I,1)
						Endif
					Next
				ELSEIF empty(QRY->F1_HORA) .and.  empty(QRY->D1_HRDOCA)
					_hrnfent :="080000"
					_hrdocent:="080000"
			      
				ELSEIF !empty(QRY->F1_HORA) .and.  !empty(QRY->D1_HRDOCA)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->D1_HRDOCA))
						If substr(ALLTRIM(QRY->D1_HRDOCA),I,1) $ "0123456789"
							_hrdocent:=_hrdocent+substr(ALLTRIM(QRY->D1_HRDOCA),I,1)
						Endif
					Next
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F1_HORA))
						If substr(ALLTRIM(QRY->F1_HORA),I,1) $ "0123456789"
							_hrnfent:=_hrnfent+substr(ALLTRIM(QRY->F1_HORA),I,1)
						Endif
					Next
				ELSEIF !empty(QRY->F1_HORA) .and.  empty(QRY->D1_HRDOCA)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F1_HORA))
						If substr(ALLTRIM(QRY->F1_HORA),I,1) $ "0123456789"
							_hrnfent:=_hrnfent+substr(ALLTRIM(QRY->F1_HORA),I,1)
							_hrdocent:=_hrdocent+substr(ALLTRIM(QRY->F1_HORA),I,1)
						Endif
					Next
				ENDIF

                  

                  //hora de Emissao Saida X hora da Doca Saida
				If empty(QRY->F2_HORA) .and.  !empty(QRY->F2_HSAIROM)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F2_HSAIROM))
						If substr(ALLTRIM(QRY->F2_HSAIROM),I,1) $ "0123456789"
							_hrnfsai  := _hrnfsai+substr(ALLTRIM(QRY->F2_HSAIROM),I,1)
							_hrdocsai := _hrdocsai+substr(ALLTRIM(QRY->F2_HSAIROM),I,1)
						Endif
					Next
				ELSEIF empty(QRY->F2_HORA) .and.  empty(QRY->F2_HSAIROM)
					_hrnfsai :="080000"
					_hrdocsai:="080000"
			      
				ELSEIF !empty(QRY->F2_HORA) .and.  !empty(QRY->F2_HSAIROM)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F2_HSAIROM))
						If substr(ALLTRIM(QRY->F2_HSAIROM),I,1) $ "0123456789"
							_hrdocsai:=_hrdocsai+substr(ALLTRIM(QRY->F2_HSAIROM),I,1)
						Endif
					Next
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F2_HORA))
						If substr(ALLTRIM(QRY->F2_HORA),I,1) $ "0123456789"
							_hrnfsai:=_hrnfsai+substr(ALLTRIM(QRY->F2_HORA),I,1)
						Endif
					Next
				ELSEIF !empty(QRY->F2_HORA) .and.  empty(QRY->F2_HSAIROM)
					FOR I:= 1 TO LEN(ALLTRIM(QRY->F2_HORA))
						If substr(ALLTRIM(QRY->F2_HORA),I,1) $ "0123456789"
							_hrnfsai:=_hrnfsai+substr(ALLTRIM(QRY->F2_HORA),I,1)
							_hrdocsai:=_hrdocsai+substr(ALLTRIM(QRY->F2_HORA),I,1)
						Endif
					Next
				ENDIF
                                

				_hrdocent :=TRANSFORM(PADR(_hrdocent,8,'0'),'99:99:99')
				_hrdocsai :=TRANSFORM(PADR(_hrdocsai,8,'0'),'99:99:99')
				_hrnfent  :=TRANSFORM(PADR(_hrnfent,8,'0') ,'99:99:99')
				_hrnfsai  :=TRANSFORM(PADR(_hrnfsai,8,'0') ,'99:99:99')


			      
			      
				for x :=1 to len(_codpro)
					if substr(_codpro,x,1) $ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
						_codnewpro:=_codnewpro+substr(_codpro,x,1)
					Endif
				next

				IF QRY->D1_DTDOCA <= QRY->D2_EMISSAO
					_ctemprep :=STRZERO(QRY->D2_EMISSAO-QRY->D1_DTDOCA,10)
					_chemprep :=ELAPTIME(_hrdocent,_hrnfsai)
				ELSE
					_ctemprep :=STRZERO(ddatabase-QRY->D1_DTDOCA,10)//+':00:00'
					_chemprep :=ELAPTIME(_hrdocent,TIME())
				ENDIF
				_ctemprep:=IIF(VAL(_ctemprep) > 99 ,'99'+':23:59',right(_ctemprep,2)+':'+substr(_chemprep,1,5))

		          
				IF QRY->D1_DTDIGIT <= QRY->D2_EMISSAO
					_ctcycler :=STRZERO(QRY->D2_EMISSAO-QRY->D1_DTDIGIT,10)//+':00:00'
					_hcycler :=ELAPTIME(_hrnfent,_hrnfsai)
				ELSE
					_ctcycler :=STRZERO(ddatabase-QRY->D1_DTDIGIT,10)//+':00:00'
					_hcycler :=ELAPTIME(_hrnfent,TIME())
				ENDIF
				_ctcycler:=IIF(val(_ctcycler) > 99 ,'99'+':23:59',right(_ctcycler,2)+':'+substr(_hcycler,1,5))

				IF QRY->D1_DTDOCA > QRY->DTNFCOM
					_ctcyclec:= IIF(QRY->D1_DTDOCA <= QRY->F2_SAIROMA,STRZERO(QRY->F2_SAIROMA-QRY->D1_DTDOCA,10),STRZERO(ddatabase-QRY->D1_DTDOCA,10))//+':00:00'
					_chcyclec:= IIF(QRY->D1_DTDOCA <= QRY->F2_SAIROMA,ELAPTIME(_hrdocent,_hrdocsai),ELAPTIME(_hrdocent,TIME()))//+':00:00'
				ELSE
					_ctcyclec:= IIF(QRY->DTNFCOM <= QRY->F2_SAIROMA,STRZERO(QRY->F2_SAIROMA-QRY->DTNFCOM,10),STRZERO(ddatabase-QRY->DTNFCOM,10))//+':00:00'
					_chcyclec:= IIF(QRY->DTNFCOM <= QRY->F2_SAIROMA,ELAPTIME(_hrnfent,_hrdocsai),ELAPTIME(_hrnfent,TIME()))//+':00:00'
				ENDIF
				_ctcyclec:=IIF(val(_ctcyclec) > 99 ,'99'+':23:59',right(_ctcyclec,2)+':'+substr(_chcyclec,1,5))
		          
				_cflagnfc :=iif(EMPTY(QRY->DTNFCOM),'N','Y')
				_cdtnfcom :=iif(_cflagnfc="Y",substr(DTOS(QRY->DTNFCOM),7,2)+'/'+substr(DTOS(QRY->DTNFCOM),5,2)+'/'+left(DTOS(QRY->DTNFCOM),4),"")
				_cdtbalca :=iif(!empty(_cdtbalca),_cdtbalca,substr(DTOS(QRY->D1_DTDIGIT),7,2)+'/'+substr(DTOS(QRY->D1_DTDIGIT),5,2)+'/'+left(DTOS(QRY->D1_DTDIGIT),4))

				if empty(_cHrBalca)
					IF !EMPTY(QRY->F1_HORA)
						_chrbalca :=QRY->F1_HORA
					ELSE
						_chrbalca :=LEFT(QRY->D1_HRDOCA,2)+":"+SUBSTR(QRY->D1_HRDOCA,3,2)
					ENDIF
					_chrbalca :=TRANSFORM(PADR(_chrbalca,5,'0'),'99:99')
				endif
		         
				IF !EMPTY(QRY->F2_SAIROMA)
					_cdtdespc :=substr(DTOS(QRY->F2_SAIROMA),7,2)+'/'+substr(DTOS(QRY->F2_SAIROMA),5,2)+'/'+left(DTOS(QRY->F2_SAIROMA),4)
					_chrdespc :=left(QRY->F2_HSAIROM,2)+":"+substr(QRY->F2_HSAIROM,3,2)
				ELSE
					_cdtdespc :=substr(DTOS(QRY->D2_EMISSAO),7,2)+'/'+substr(DTOS(QRY->D2_EMISSAO),5,2)+'/'+left(DTOS(QRY->D2_EMISSAO),4)
					_nhora:=VAL(left(QRY->F2_HORA,2))+2
					_chora:=iif(_nhora > 24,STR(_nhora-24,2),STR(_nhora))
					_chrdespc :=alltrim(_chora)+":"+substr(QRY->F2_HORA,4,2)
				ENDIF
				_cdtrepar :=iif(!empty(_cdtrepar),_cdtrepar,substr(DTOS(QRY->D2_EMISSAO),7,2)+'/'+substr(DTOS(QRY->D2_EMISSAO),5,2)+'/'+left(DTOS(QRY->D2_EMISSAO),4))
				_chrbalca :=iif(!empty(_cHrBalca),_cHrBalca,TRANSFORM(PADR(_chrdespc,5,'0'),'99:99'))
		            
		          //BUSCAR DADOS ADICIONAIS PELO CPF/CNPJ DO CONSUMIDOR NO CADASTRO DO CLIENTE E ADICIONAR A LINHA
				IF !EMPTY(QRY->CPFCLI)
					SA1->(DBSETORDER(3))
					IF SA1->(dbSeek(xFilial("SA1") + QRY->CPFCLI))
						ccpfclie:=QRY->CPFCLI
						_cnomcons:=ALLTRIM(LEFT(SA1->A1_NOME,40))
						_cendcons:=ALLTRIM(LEFT(SA1->A1_END,50))
						_ccidcons:=ALLTRIM(LEFT(SA1->A1_MUN,50))
						_ccompcon:=ALLTRIM(LEFT(SA1->A1_XNUMCOM,50))
						_cestcons:=ALLTRIM(LEFT(SA1->A1_EST,2))
						_ccepcons:=ALLTRIM(LEFT(SA1->A1_CEP,8))
						_ctelcons:=ALLTRIM(LEFT(SA1->A1_TEL,30))
						_cemacons:=ALLTRIM(LEFT(SA1->A1_EMAIL,100))
					ENDIF
				ENDIF
			    
			      //PEGAR OS DADOS DA NF DA ENTRADA OU OS SAM
				IF QRY->NFCOMPR<>''
					_cendcons3:=ALLTRIM(QRY->CNPJNFC)+ALLTRIM(QRY->NFCOMPR)+ALLTRIM(QRY->SERNFC)
				ENDIF
				_c1_3 := ALLTRIM(QRY->A1_NREDUZ)
				_c1_7 := "NFE_ENTR: "+ ALLTRIM(QRY->NFENTRADA)
	
			      
				IF !empty(_cOSnext)
					_c1_7 :=_c1_7+" OS NEXTEL: "+_cOSnext
				Endif
			      
			      
				IF EMPTY(ALLTRIM(QRY->B1_CREFDES))
					AADD(aerros,{'ERR0',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->B1_CODMOTO),'REF. DESIGNATOR nao preenchido para a Peca : '+ALLTRIM(QRY->B1_CODMOTO),'Corrija o cadastro do produto. OK gravado no arquivo.'})
		                 //MsgAlert("Codigo REF. DESIGNATOR nao Preenchido para o Peca :"+ALLTRIM(QRY->B1_CODMOTO)+"  essa OS. Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
                         //Return
					_lpassou:=.t.
				ENDIF
                                                                                                                                                                                                                                                  
				IF QRY->D2_QUANT > 99
					AADD(aerros,{'ERRO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->D2_COD),"Quuantida digitada "+STRZERO(QRY->D2_QUANT,3)+"  ,na NFS/SERIE/ITEM : "+ALLTRIM(QRY->D2_DOC)+"/"+ALLTRIM(QRY->D2_SERIE)+"/"+ALLTRIM(QRY->D2_ITEM)+" maior que 99","Abra o arquivo e desmembre as linhas do pedido : "+QRY->D2_PEDIDO+"ou cancele a NF e refaça o pedido"})
					_lpassou:=.t.
				ENDIF

			      
				If _lpassou
			          
					If _lgerouOS
						AADD(aerros,{'INFO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->D2_COD),"Ja foi gerado arq. Mclaims para partnumber: "+ALLTRIM(QRY->D2_COD)+ " NFS/SERIE/ITEM : "+ALLTRIM(QRY->D2_DOC)+"/"+ALLTRIM(QRY->D2_SERIE)+"/"+ALLTRIM(QRY->D2_ITEM),"Confirmado nova geracao do arquivo"})
					Endif
			         //LINHA4			                                                                                                
					cLin:=cidregL4+"||"+_c1_3+"|"+_cnomcons+"|"+_cendcons+"|"+_ccompcon+"|"+_c1_7+"||"+_ccidcons+"|"
					//cLin+=_cestcons+"|"+_ccepcons+"||"+_ctelcons+"|"+_cemacons+"|||"+_ctranspo+"|BR|"+ALLTRIM(QRY->TRACKIN)+"|"+_ctrakout+"|"+ALLTRIM(QRY->MASC_CODE)+"|"
					cLin+=_cestcons+"|"+_ccepcons+"||"+_ctelcons+"|"+_cemacons+"|||"+_ctranspo+"|BR|"+ALLTRIM(QRY->TRACKIN)+"|"+_ctrakout+"|"+ALLTRIM(_cMascCode)+"|"
			         //cLin+=_ccpfclie+"|"+_ccopoer+"|"+ALLTRIM(ctransc)+"|"+ALLTRIM(QRY->B1_XCODAPC)+"|"+_codnewpro+"|||"+ALLTRIM(LEFT(QRY->CARCAC,14))+"|"+ALLTRIM(LEFT(QRY->CARCAC,14))+"|"+ALLTRIM(QRY->IMEI)+"|"+ALLTRIM(QRY->IMEI)+"||||"
					cLin+=_ccpfclie+"|"+_ccopoer+"|"+ALLTRIM(ctransc)+"|"+_xCodAPC+"|"+_codnewpro+"|||"+ALLTRIM(LEFT(_cMSNIN,14))+"|"+ALLTRIM(LEFT(_cMSNOUT,14))+"|"+ALLTRIM(_cIMEIIN)+"|"+ALLTRIM(_cIMEIOUT)+"||||"
					cLin+=alltrim(_cstrepmo)+"|||"+_cdtbalca+"|"+_chrbalca+"|||"+_cdtdespc+"|"+_chrdespc+"|"+_cdtrepar+"|"+alltrim(_ctemprep)+"|"+alltrim(_ctcycler)+"|"+alltrim(_ctcyclec)+"|"+_cflagnfc+"|"+_cdtnfcom+"|||"
					cLin+=alltrim(csoftin)+"|"+alltrim(csoftout)+"|"+_ccodrecl+"|"+cCODTEC+"|"+alltrim(_cproblem1)+"|"+alltrim(_cproblem2)+"|"+alltrim(_crepair1)+"|"+alltrim(_crepair2)+"|"+ALLTRIM(QRY->CODAUTO)+"|"+alltrim(cartime)+"||||||||"+alltrim(cminumb)+"|||||||||"+cEOL
			
					If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Return
						EndIf
					Endif
	            
	                 //PARTUNMBERS    
			         //LINHA5
					cLin:=cidregL5+"|"+ccodmask+"|"+ALLTRIM(QRY->MASC_CODE)+"|"+_cpartnr+"|"+STRZERO(QRY->D2_QUANT,2)+"|"+'0'+"|"+'R'+"|"+ALLTRIM(QRY->B1_CREFDES)+"|"+ALLTRIM(QRY->B1_NREFDES)+"|"+'S'+"|"+'RPC'+"|||"+cEOL
			  
					If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Return
						EndIf
					Endif
	         
					IncProc()
					dbSelectArea("SC6")
					IF SC6->(dbseek(xFilial("SC6")+ QRY->D2_PEDIDO+QRY->D2_ITEMPV+QRY->D2_COD))
						RecLock("SC6",.F.)
						SC6->C6_NUMOS  :=SUBSTR(QRY->MASC_CODE,6,7)
						MsUnlock()
					ENDIF
				Endif
			Else
				IF _lyespprg .or. !QRY->D2_PEDIDO $ "793680/796525/798432/803648/802239/802240/802402/802404"
					AADD(aerros,{'ERRO',ALLTRIM(QRY->MASC_CODE),'',ALLTRIM(QRY->D2_COD),'Transaction Code nao Preenchido para essa OS','Verifique se foi preenchido no pedido :'+QRY->D2_PEDIDO+' OS nao gravada no arquivo.'})
	      	            //MsgAlert("Transaction Code nao preenchido para OS : "+ALLTRIM(QRY->MASC_CODE)+". Arquivo nao foi gerado ! Imprima Relatorio de erros e corrija o problema.","Atencao!")
		                //Return
				ENDIF
			Endif
		       
			QRY->(dbSkip())
		Enddo
	Endif
	QRY->(dbCloseArea())
	
	//LINHA6
	/*
	cLin:=cidregL6+"||||"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	  	 Return
	   Endif
	Endif
	     
	
	//LINHA7
	cLin:=cidregL7+"||||||||"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	  	 Return
	   Endif
	Endif
	
	//LINHA8
	cLin:=cidregL8+"|||||"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	  	 Return
	   Endif
	Endif
	*/
	
	
	//LINHA9
	cLin:=cidregL9+"||||"+cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
		Endif
	Endif
	
	fClose(nHdl)
	Close(oGeraTxt)
	restarea(aAreaZZ4)
	
Return
                  


//Cria perguntas no SX1
Static Function CriaSX1()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Data NF Saida Inicial?"	,"Data NF Saida Inicial?"	,"Data NF Saida Inicial?" ,"mv_ch1","D",08,0,0,"G","",""	,"",,"mv_par01",""	,"","","",""	,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"02","Data NF Saida Final?"	,"Data NF Saida Final?"	    ,"Data NF Saida Final?"	  ,"mv_ch2","D",08,0,0,"G","",""	,"",,"mv_par02",""	,"","","",""	,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"03","Armazens RPG ? "			,"Armazens RPG ?"			,"Armazens RPG ?"	      ,"mv_ch3","C",20,0,0,"G","",""	,"",,"mv_par03",""	,"","","",""	,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"04","Notas Fiscais ?"		    ,"Notas Fiscais ?"			,"Notas Fiscais ?"		  ,"mv_ch4","C",99,0,0,"G","",""	,"",,"mv_par04",""	,"","","",""	,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"05","Serie(s) NFS ?"		    ,"Serie(s) NFS ?"			,"Serie(s) NFS ?"		  ,"mv_ch5","C",12,0,0,"G","",""	,"",,"mv_par05",""  ,"","","",""	,"","",""	,"","","","","","","","")
//PutSX1(cPerg,"06","TES Saida ?"		        ,"TES Saida ?"			    ,"TES Saida ?"		      ,"mv_ch6","C",20,0,0,"G","",""	,"",,"mv_par06",""	 ,"","","",""	,"","",""	,"","","","","","","","")
//PutSX1(cPerg,"07","Trans. Code ?"		    ,"Trans. Code ?"			,"Trans. Code ?"		  ,"mv_ch7","C",03,0,0,"G","",""	,"",,"mv_par07",""	 ,"","","",""	,"","",""	,"","","","","","","","")
	PutSX1(cPerg,"06","Nome Arquivo"		    ,"Nome Arquivo"			    ,"Nome Arquivo"			  ,"mv_ch6","C",40,0,0,"G","",""	,"",,"mv_par06",""	 ,"","","",""	,"","",""	,"","","","","","","","")

                                                                                           
Return Nil
