#Include "PROTHEUS.Ch"
/* 
   Fonte:  SF1100I
   Função: Ponto de entrada após a gravação da nota fiscal de entrada e dos títulos a pagar
   Autor:  -
   Data:   -
   
   Alteração: Marcelo Munhoz
   Objetivo:  Gravar a natureza do título a pagar com a descrição da natureza
   Data:      16/09/2013
*/
 
User Function  SF1100I()

local _aAreaSE2 := SE2->(getarea())
local _aAreaSED := SED->(getarea())
local _aAreaSD1 := SD1->(getarea())
local _aAreaSF4 := SF4->(getarea())
local _lNFServ  := .f.

u_GerA0003(ProcName())

SED->(dbSetOrder(1)) // ED_FILIAL + ED_CODIGO
SE2->(dbSetOrder(6)) // E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
SD1->(dbSetOrder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
SF4->(dbSetOrder(1)) // F4_FILIAL + F4_CODIGO 

if SD1->(dbSeek(xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )) .and. SD1->D1_TES == '385' .or.; 
SF4->(dbSeek(xFilial('SF4') + SD1->D1_TES)) .and. SF4->F4_ISS == 'S'
	_lNFServ  := .T.
endif

if SE2->(dbSeek(xFilial('SE2') + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC ))
	while SE2->(!eof()) .and. SE2->E2_FILIAL == xFilial('SE2') .and. SE2->E2_FORNECE == SF1->F1_FORNECE .and. SE2->E2_LOJA == SF1->F1_LOJA .and. ;
	SE2->E2_PREFIXO == SF1->F1_SERIE .and. SE2->E2_NUM == SF1->F1_DOC 
	
		if SED->(dbSeek(xFilial('SED') + SE2->E2_NATUREZ ))
			reclock('SE2',.f.)
			SE2->E2_HIST := alltrim(SED->ED_DESCRIC)
			if _lNFServ
				 SE2->E2_MULTNAT := '2'
			endif
			msunlock()
		endif
		SE2->(dbSkip())
	enddo
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mostra tela para digitacao do numero do chamado ³
//³que fica nos dados adicionais da nota           ³
//³D.FERNANDES - 28/11/2013                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SF1->F1_TIPO == "B" 
                                    
	cOpeBgh := GetNewPar("MV_XOPEENT","P01/P02/P03/P04/P05")
	
	cQuery := " SELECT DISTINCT D1_XOPEBGH "
	cQuery += " FROM "+RetSqlName("SD1")+" (NOLOCK)  "
	cQuery += " WHERE D1_DOC = '"+SF1->F1_DOC+"'  "
	cQuery += " AND D1_SERIE = '"+SF1->F1_SERIE+"' "
	cQuery += " AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "	          
	cQuery += " AND D1_LOJA = '"+SF1->F1_LOJA+"' "	          	          
	cQuery += " AND D1_XOPEBGH IN "+FormatIn(cOpeBgh,"/")+" "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND D1_FILIAL = '"+xFilial("SD1")+"' "
	                                                 
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSQL",.T.,.T.)
    
	dbSelectArea("TSQL") 
	TSQL->(dbGotop())
	
	If TSQL->(!Eof())
	
		aRetBox	:= {}
		cMens   := "Informe o número do chamado impresso na Danfe "
		If ParamBox({{1,"Informe N° Chamado:",Space(TamSx3("F1_XCHAMAD")[1]),"","","","",0,.F.}},cMens,@aRetBox)
			SF1->(RecLock("SF1",.F.))
			SF1->F1_XCHAMAD := aRetBox[1]
			SF1->(MsUnLock())
		EndIf
	            
	EndIf
EndIf

restarea(_aAreaSE2)
restarea(_aAreaSED)
restarea(_aAreaSD1)
restarea(_aAreaSF4)

//EXCLUIDO POIS OS DADOS SERÃO GRAVADOS DIRETAMENTE NA CD5 - GRAZIELLA - 17/11/2011
/*If  type('cF1Numdi') != "U"
	If !Empty(cF1NumDI)
		Reclock("SF1",.F.)
		SF1->F1_XNUMDI := cF1NumDI
		SF1->F1_XDTDI := cF1DTDI 
		SF1->F1_LOCALDM := cF1LcDm 
		SF1->F1_UFDESEM := cF1UfDe 
		SF1->F1_DT_DESE := cF1DtDe
		MsUnlock()
        
    	
		/*BEGINDOC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
		//³DATA: 27/09/2001    ANALISTA: GRAZIELLA BIANCHIN³
		//³ALTERAÇÃO DO FONTE PARA QUANDO DA INCLUSÃO      ³
		//³DE UMA NOTA DE IMPORTAÇÃO OS DADOS DA D.I. BEM  ³
		//³COMO OS IMPOSTOS SEJAM PREENCHIDOS NA TABELA    ³
		//³CD5. TABELA UTILIZADA NO SPED PIS/COFINS        ³
		//³                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
		ENDDOC*/
    	/*Reclock("CD5",.T.)
		//SEGUNDO ROBERTO TODAS AS NOTAS DE IMPORTACAO SAO DO TIPO 0 - DECLARACAO DE IMPOTACAO
		CD5->CD5_FILIAL := SF1->F1_FILIAL
		CD5->CD5_DOC    := SF1->F1_DOC
		CD5->CD5_SERIE  := SF1->F1_SERIE
		CD5->CD5_ESPEC  := SF1->F1_ESPECIE
		CD5->CD5_FORNEC := SF1->F1_FORNECE
		CD5->CD5_LOJA   := SF1->F1_LOJA
		CD5->CD5_TPIMP  := "0"
		CD5->CD5_DOCIMP := SF1->F1_XNUMDI
		CD5->CD5_BSPIS  := SF1->F1_BASIMP6
		CD5->CD5_ALPIS  := GETMV("MV_TXPIS")
		CD5->CD5_VLPIS  := SF1->F1_VALIMP6
		CD5->CD5_BSCOF  := SF1->F1_BASIMP5
		CD5->CD5_ALCOF  := GETMV("MV_TXCOFIN")
		CD5->CD5_VLCOF  := SF1->F1_VALIMP5
		MsUnlock()
	Endif
	cF1Numdi 	:= ''
	cF1Dtdi  	:= Ctod('')
	cF1LcDm		:= ''
	cF1UfDe		:= ''
	cF1DtDe		:= Ctod('')
Endif*/
	
Return .t.
