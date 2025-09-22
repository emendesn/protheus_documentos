#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN01    บAutor  ณMarcos Zanetti GZ   บ Data ณ  19/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo de fluxo de caixa                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico 		                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function PFIN01()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Gera็ใo de planilha de Fluxo de Caixa"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"PFIN01"
private _cArq	:= 	"PFIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilSE5:= xFilial("SE5")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
private _nSaldoIni 	:= 0
Private _aRegSimul	:= {} // matriz com os recnos do TRB1 e do SZ3, respectivamente

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"

Private _aGrpSint:= {}

ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o fluxo de caixa de acordo com os ")
AADD(aSays,"parโmetros fornecidos pelo usuแrio. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"automแtica pelo Excel.")
AADD(aSays,"Movimentos ap๓s a data de refer๊ncia sใo considerados previstos e anteriores ")
AADD(aSays,"ou iguais a ela, realizados.")
AADD(aSays,"")
AADD(aSays,"Especํfico Presstecnica")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
	
	// Se confirmado o processamento
	if nOpcA == 1
		
		pergunte(cPerg,.F.)
		
		_dDataIni 	:= mv_par01 // Data inicial
		_dDataFim 	:= mv_par02 // Data Final
		_dDtRef  	:= mv_par03 // Data de referencia
		_lPedCompra	:= mv_par04 == 1 // Considera pedido de compras
		_lPedVenda	:= mv_par05 == 1 // Considera pedido de vendas
		_lVencRec	:= mv_par06 == 1 .or. mv_par06 == 3 // Considera Vencidos a receber
		_lVencPag	:= mv_par06 == 2 .or. mv_par06 == 3 // Considera Vencidos a pagar
		_nDiasPer	:= max(1 , mv_par07) // Quantidade de dias por periodo (minimo de 1 dia)
		_lSelBancos	:= mv_par08 == 1 // Seleciona Bancos
		
		// Faz consistencias iniciais para permitir a execucao da rotina
		if !VldParam() .or. !AbreArq()
			return
		endif
		
		dDataBase := _dDtRef // muda a database para a data de referencia, para calculo de saldos
		
		MSAguarde({||ProcBco(_lSelBancos)},"Processando Bancos") // Calcula saldos bancarios iniciais
		
		MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
		
		// Processa titulos em aberto
		MSAguarde({|| PFIN01TIT()},"Tํtulos em aberto")
		
		// Processa previsoes
		if mv_par09 == 1
			MSAguarde({|| PFIN01PREV()},"Processando previs๕es")
		endif
		
		if _lPedCompra
			// Processa os pedidos de compras
			MSAguarde({|| PFIN01PC()},"Pedidos de compra")
		endif
		
		if _lPedVenda
			// Processa os pedidos de compras
			MSAguarde({|| PFIN01PV()},"Pedidos de Venda")
		endif
		
		MSAguarde({||PFIN01SINT()},"Gerando arquivo sint้tico.") // *** Funcao de gravacao do arquivo sintetico ***
		
		MontaTela()
		
		dDataBase := _cOldData // restaura a database
		
		TRB1->(dbclosearea())
		TRB11->(dbclosearea())
		TRB2->(dbclosearea())
		BANCOS->(dbclosearea())
		
	endif
	
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPROCBCO   บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Processa o saldo inicial dos bancos e define bancos usados บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function ProcBco(_lSelBco)
	Local cMarca	 := GetMark()
	Local aCampos	:= {	 {"A6_OK"        ,"C",02,0 },;
	{"A6_COD"     ,"C",03,0 },;
	{"A6_AGENCIA" ,"C",05,0 },;
	{"A6_NUMCON"  ,"C",10,0 },;
	{"A6_NREDUZ"  ,"C",15,0 },;
	{"A6_SALATU"  ,"N",17,2 } }
	
	Local aCampos2 := {	 {"A6_OK",,"  ",""},;
	{"A6_COD"     ,,"Banco","@X"}   ,;
	{"A6_AGENCIA" ,,"Agencia","@X"} ,;
	{"A6_NUMCON"  ,,"Conta","@X"}   ,;
	{"A6_NREDUZ"  ,,"Nome","@X"}    ,;
	{"A6_SALATU"  ,,"Saldo","@E 9,999,999,999.99"} }
	
	Local oDlg
	Local _cQuery	:= ""
	local lInverte	:= .F.
	
	Local _lE8SalReco := SE8->(fieldpos("E8_SALRECO")) > 0
	
	Local _nSaldo := 0
	
	SA6->(dbsetorder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
	SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)
	
	dbcreate(cArqTrb3,aCampos)
	dbUseArea(.T.,,cArqTrb3,"BANCOS",.F.,.F.)
	IndRegua("BANCOS",CriaTrab(NIL,.F.),"A6_COD+A6_AGENCIA+A6_NUMCON",,,"Indexando Bancos")
	
	SA6->(dbgotop())
	while SA6->(!eof())
		
		SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))
		SE8->(dbSkip(-1))
		
		if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
			SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == SA6->(A6_COD + A6_AGENCIA + A6_NUMCON)
			_nSaldo := iif(_lE8SalReco, SE8->E8_SALRECO , SE8->E8_SALATUA)
		else
			_nSaldo := 0
		endif
		
		RecLock("BANCOS",.T.)
		BANCOS->A6_COD 		:= SA6->A6_COD
		BANCOS->A6_AGENCIA 	:= SA6->A6_AGENCIA
		BANCOS->A6_NUMCON 	:= SA6->A6_NUMCON
		BANCOS->A6_NREDUZ 	:= SA6->A6_NREDUZ
		BANCOS->A6_SALATU 	:= _nSaldo
		if SA6->A6_FLUXCAI <> 'N'
			BANCOS->A6_OK := cMarca
		endif
		MsUnlock()
		SA6->(dbskip())
	enddo
	
	if _lSelBco
		
		BANCOS->( dbGotop() )
		DEFINE MSDIALOG oDlg TITLE "Selecione os Bancos que deverใo ser considerados" From 009,000 To 030,063 OF oMainWnd
		oMark := MsSelect():New("BANCOS","A6_OK","",aCampos2,@lInverte,@cMarca,{20,2,140,248})
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2}) CENTERED
		
	endif
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01REALบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Processa o fluxo de caixa realizado                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01REAL()
	local _cQuery := ""
	Local _cFilSE2 := xFilial("SE2")
	Local _cFilSE5 := xFilial("SE5")
	Local _cFilSED := xFilial("SED")
	Local _cFilSEF := xFilial("SEF")
	local _cNatureza
	
	SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	SEF->(dbsetorder(1)) // EF_FILIAL + EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM
	
	ChkFile("SE5",.F.,"QUERY") // Alias dos movimentos bancarios
	IndRegua("QUERY",CriaTrab(NIL,.F.),"DTOS(E5_DTDISPO)+E5_NATUREZ",,,"Selecionando Registros...")
	
	ChkFile("SE5",.F.,"SE5_EC") // Alias para estorno de cheques
	IndRegua("SE5_EC",CriaTrab(NIL,.F.),"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ",,,"Selecionando Registros...")
	
	ProcRegua(QUERY->(reccount()))
	
	QUERY->(dbseek(dtos(_dDataIni),.T.))
	while QUERY->(!eof()) .and. dtos(QUERY->E5_DTDISPO) <= dtos(_dDtRef) .and. QUERY->E5_FILIAL == _cFilSE5
		
		if BANCOS->(!dbseek(QUERY->(E5_BANCO + E5_AGENCIA + E5_CONTA))) .or. empty(BANCOS->A6_OK)
			QUERY->(dbskip())
			Loop
		endif
		
		if  (QUERY->E5_VENCTO > QUERY->E5_DATA) .or. ;
			(right(alltrim(QUERY->E5_NUMCHEQ),1) == '*') .or. ;
			(QUERY->E5_SITUACA == 'C') .or. ;
			(QUERY->E5_VALOR == 0) .or. ;
			(QUERY->E5_TIPODOC $ 'DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA') .or. ;
			(QUERY->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. Empty(QUERY->E5_NUMCHEQ) .and. !(QUERY->E5_TIPODOC $ "TR#TE")) 	.or. ;
			(QUERY->E5_TIPODOC $ "TR/TE" .and. Empty(QUERY->E5_NUMERO) .and. !(QUERY->E5_MOEDA $ "R$/DO/TB/TC/CH")) 	.or. ;
			(QUERY->E5_TIPODOC $ "TR/TE" .and. (Substr(QUERY->E5_NUMCHEQ,1,1)=="*" .or. Substr(QUERY->E5_DOCUMEN,1,1) == "*" )) .or. ;
			(QUERY->E5_MOEDA == "CH" .and. IsCaixaLoja(QUERY->E5_BANCO)) 	.or. ;
			(!Empty( QUERY->E5_MOTBX ) .and. !MovBcoBx( QUERY->E5_MOTBX ))	.or. ;
			(left(QUERY->E5_NUMCHEQ,1) == "*"  .or. left(QUERY->E5_DOCUMEN,1) == "*") .or. ;
			QUERY->E5_TIPODOC == "EC"
			
			QUERY->(dbskip())
			Loop
			
		endif
		
		if SED->(dbseek(_cFilSED+QUERY->E5_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
		endif
		
		if alltrim(QUERY->E5_TIPODOC) <> "CH"
			
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
			TRB1->NATUREZA	:= QUERY->E5_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->HISTORICO	:= QUERY->E5_HISTOR
			TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , QUERY->E5_VALOR , -QUERY->E5_VALOR)
			TRB1->RECPAG	:= QUERY->E5_RECPAG
			TRB1->TIPO		:= "R"
			TRB1->ORIGEM	:= "MB"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			MsUnlock()
			
		else // Se for um cheque aglutinado - pesquisa pelos titulos pagos no cheque
			
			_nRegQry := 0
			
			if SE5_EC->(dbseek(QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))
				while SE5_EC->(!eof()) .and. QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) == SE5_EC->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					if SE5_EC->E5_SEQ == QUERY->E5_SEQ .and. SE5_EC->E5_TIPODOC = 'EC' .and. SE5_EC->(recno()) > QUERY->(recno())
						_nRegQry++
					endif
					SE5_EC->(dbskip())
				enddo
			endif
			
			if _nRegQry > 0
				QUERY->(dbskip())
				Loop
			endif
			
			_cChave := _cFilSEF+QUERY->E5_BANCO+QUERY->E5_AGENCIA+QUERY->E5_CONTA+QUERY->E5_NUMCHEQ
			
			if SEF->(dbseek(_cChave))
				
				while SEF->(!eof()) .and. SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM == _cChave
					
					if !empty(SEF->EF_TITULO) .and. SE2->(dbseek(_cFilSE2+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
						
						if SED->(dbseek(_cFilSED+SE2->E2_NATUREZ))
							_cNatureza := SED->ED_DESCRIC
						else
							_cNatureza := "NATUREZA NAO DEFINIDA"
						endif
						
						RecLock("TRB1",.T.)
						TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
						TRB1->NATUREZA	:= SE2->E2_NATUREZ
						TRB1->DESC_NAT	:= _cNatureza //GetAdvFVal("SED","ED_DESCRIC",_cFilSED+SE2->E2_NATUREZ,1,"NATUREZA NAO DEFINIDA")
						TRB1->HISTORICO	:= "PAGAMENTO TITULO " + alltrim(SE2->E2_PREFIXO) + " " + SE2->E2_NUM + " " + alltrim(SE2->E2_PARCELA) + " " + SE2->E2_TIPO
						TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , SEF->EF_VALOR , -SEF->EF_VALOR)
						TRB1->RECPAG	:= QUERY->E5_RECPAG
						TRB1->TIPO		:= "R"
						TRB1->ORIGEM	:= "MB"
						TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
						TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
						MsUnlock()
						
					endif
					SEF->(dbskip())
					
				enddo
				
			endif
			
		endif
		
		QUERY->(dbskip())
		
	enddo
	
	QUERY->(dbclosearea())
	SE5_EC->(dbclosearea())
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01TIT บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa Titulos em aberto                                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01TIT()
	Local _cFilSE1 := xFilial("SE1")
	Local _cFilSE2 := xFilial("SE2")
	Local _cFilSED := xFilial("SED")
	local _cQuery := ""
	local _nSaldo := 0
	local _lNatFluxo := SED->(fieldpos("ED_XFLUXO")) > 0
	
	SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	
	// TITULOS A RECEBER EM ABERTO
	ChkFile("SE1",.F.,"QUERY") // Alias dos titulos a receber
	QUERY->(dbsetorder(7)) // E1_FILIAL + DTOS(E1_VENCREA) + E1_NOMCLI + E1_PREFIXO + E1_NUM + E1_PARCELA
	QUERY->(dbseek(_cFilSE1+iif(_lVencRec,"",dtos(_dDtRef)),.T.))
	while QUERY->(!eof()) .and. SE1->E1_FILIAL == _cFilSE1 .and. QUERY->E1_VENCREA <= _dDataFim
		
		if 	substr(QUERY->E1_TIPO,3,1) == "-" .or. ;
			!(QUERY->E1_SALDO > 0 .OR. dtos(QUERY->E1_BAIXA) > dtos(_dDtRef)) .or. ;
			QUERY->E1_EMISSAO > _dDataFim
			QUERY->(dbskip())
			loop
		endif
		
		if SED->(dbseek(_cFilSED+QUERY->E1_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
			if _lNatFluxo .and. SED->ED_XFLUXO == "N"
				QUERY->(dbskip())
				loop
			endif
		endif
		
		_nSaldo :=_CalcSaldo("SE1", QUERY->(recno()))
		
		if _nSaldo <> 0
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= max(DataValida(QUERY->E1_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
			TRB1->NATUREZA	:= QUERY->E1_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->VALOR		:= _nSaldo
			TRB1->TIPO		:= "P"
			TRB1->RECPAG	:= "R"
			TRB1->ORIGEM	:= "CR"
			TRB1->HISTORICO	:= "Tit. Receber: " + ;
			alltrim(QUERY->E1_PREFIXO + " " + QUERY->E1_NUM + " " + QUERY->E1_PARCELA + " " + QUERY->E1_TIPO) + ;
			iif(!empty(QUERY->E1_HIST) , " - " + QUERY->E1_HIST ,"")
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			MsUnlock()
		endif
		
		QUERY->(dbskip())
	enddo
	
	QUERY->(dbclosearea())
	
	// TITULOS A PAGAR EM ABERTO
	ChkFile("SE2",.F.,"QUERY") // Alias dos titulos a pagar
	QUERY->(dbsetorder(3)) // E2_FILIAL + DTOS(E2_VENCREA) + E2_NOMFOR + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
	QUERY->(dbseek(_cFilSE2+iif(_lVencRec,"",dtos(_dDtRef)),.T.))
	while QUERY->(!eof()) .and. SE2->E2_FILIAL == _cFilSE2 .and. QUERY->E2_VENCREA <= _dDataFim
		
		if 	substr(QUERY->E2_TIPO,3,1) == "-" .or. ;
			!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ;
			QUERY->E2_EMISSAO > _dDataFim
			QUERY->(dbskip())
			loop
		endif
		
		if SED->(dbseek(_cFilSED+QUERY->E2_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
			if _lNatFluxo .and. SED->ED_XFLUXO == "N"
				QUERY->(dbskip())
				loop
			endif
		endif
		
		_nSaldo :=_CalcSaldo("SE2", QUERY->(recno()))
		
		if _nSaldo <> 0
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= max(DataValida(QUERY->E2_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
			TRB1->NATUREZA	:= QUERY->E2_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->VALOR		:= _nSaldo
			TRB1->TIPO		:= "P"
			TRB1->RECPAG	:= "P"
			TRB1->ORIGEM	:= "CP"
			TRB1->HISTORICO	:= "Tit. Pagar: " + ;
			alltrim(QUERY->E2_PREFIXO + " " + QUERY->E2_NUM + " " + QUERY->E2_PARCELA + " " + QUERY->E2_TIPO) + ;
			iif(!empty(QUERY->E2_HIST) , " - " + QUERY->E2_HIST ,"")
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			MsUnlock()
		endif
		
		QUERY->(dbskip())
	enddo
	
	QUERY->(dbclosearea())
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01PREVบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa Previsoes do fluxo de caixa                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01PREV()
	local _cQuery := ""
	local _nSaldo := 0
	
	SZ3->(dbsetorder(2)) // Z3_FILIAL + dtos(Z3_DATA) + Z3_GRUPO
	
	SZ3->(dbseek(xFilial("SZ3")+dtos(_dDtRef),.T.))
	while SZ3->(!eof()) .and. dtos(SZ3->Z3_DATA) <= dtos(_dDataFim)
		
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= SZ3->Z3_DATA
		TRB1->DESC_NAT	:= "SIMULACAO"
		TRB1->HISTORICO	:= SZ3->Z3_HIST
		TRB1->VALOR		:= iif(SZ3->Z3_RECPAG == "P" , -(SZ3->Z3_VALOR) , SZ3->Z3_VALOR)
		TRB1->RECPAG	:= SZ3->Z3_RECPAG
		TRB1->GRUPONAT 	:= SZ3->Z3_GRUPO
		TRB1->CAMPO		:= RetCampo(SZ3->Z3_DATA)
		TRB1->SIMULADO	:= "S"
		MsUnlock()
		
		aadd(_aRegSimul, {TRB1->(recno()), SZ3->(recno())})
		
		SZ3->(dbskip())
	enddo
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ_CalcSaldoบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Calcula o saldo do titulo na data de referencia            บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function _CalcSaldo(_cAlias, _nRecno)
	local _nSaldo := 0
	
	if _cAlias == "SE1"
		
		SE1->(dbgoto(_nRecno))
		
		dbselectarea("SE1")
		
		_nSaldo	:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
		SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,;
		_dDtRef,_dDtRef,SE1->E1_LOJA,_cFilSE5)
		
		dbselectarea("SE1")
		
		_nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,;
		_dDtRef,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
		
		if SE1->E1_TIPO $ (MV_CRNEG + "/" + MVRECANT) // O normal de um titulo a receber e ser positivo
			_nSaldo := -1 * _nSaldo
		endif
		
	else
		
		SE2->(dbgoto(_nRecno))
		
		dbselectarea("SE2")
		
		_nSaldo	:= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
		SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,;
		_dDtRef,_dDtRef,SE2->E2_LOJA,_cFilSE5)
		
		dbselectarea("SE2")
		
		_nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,;
		_dDtRef,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)
		
		if !(SE2->E2_TIPO $ (MV_CPNEG + "/" + MVPAGANT)) // O normal de um titulo a pagar e ser negativo
			_nSaldo := -1 * _nSaldo
		endif
		
	endif
	
	return(_nSaldo)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01PC  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa  Pedidos de compra                                 บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01PC()
	local _cQuery 		:= ""
	local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
	local _aparcelas	:= {}
	local _nValor       := 0
	local _nValIPI      := 0
	local _nPos			:= 0
	local _nConta		:= 0
	local _lNatSC7		:= SC7->(fieldpos("C7_NATUREZ")) > 0
	
	
	cQuery := " SELECT * FROM "+RetSqlName("SC7")+" C7, "+RetSqlName("SE4")+" E4"
	cQuery += " WHERE E4_CODIGO = C7_COND "
	cQuery += " AND C7_QUJE < C7_QUANT AND C7_RESIDUO <> 'S'  AND C7_FLUXO <> 'N' AND C7.D_E_L_E_T_ <> '*'
	
	MemoWrit("PFIN01C7.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	TcSetField("TRB","C7_DATPRF","D")
	
	COUNT TO nRecCount
	//CASO TENHA DADOS
	If nRecCount = 0
		Return
	EndIf
//	SetRegua(nRecCount)
	dbSelectArea("TRB")
	dbGoTop()
	
	while !eof()
		// Considera o TES do Pedido de Compras e, se ele estiver vazio, considera o do Produto
		cB1Tes := Posicione("SB1",1,xFilial("SB1")+TRB->C7_PRODUTO,"B1_TE")
		_cTES := iif(!empty(TRB->C7_TES), TRB->C7_TES, cB1Tes)
		
		_lTES := !empty(_cTES)
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		
		if _lTES .and. SF4->(dbseek(xFilial()+_cTES))
			if SF4->F4_DUPLIC == "N"
				TRB->(dbskip())
				loop
			endif
		endif
		
		_dDtEnt := Iif( TRB->C7_DATPRF < _dDtRef, _dDtRef, DataValida(TRB->C7_DATPRF))
		
		_nValPC := (1+TRB->E4_ACRSFIN/100) * ((TRB->C7_QUANT-TRB->C7_QUJE)/TRB->C7_QUANT) * (TRB->C7_TOTAL - TRB->C7_VLDESC)
		
		_nValor := iif(str(TRB->C7_MOEDA,1,0) <> "1",xMoeda(_nValPC,TRB->C7_MOEDA,1,_dDtEnt) ,_nValPC)
		if TRB->C7_IPI > 0 .and. (!_lTES .or. SF4->F4_IPI <> "N")
			_nValIPI := (TRB->C7_IPI/100) * _nValor
			if _lTES .and. SF4->F4_BASEIPI > 0
				_nValIPI *= (SF4->F4_BASEIPI/100)
			elseif SF4->F4_IPI == "R"
				_nValIPI := _nValIPI/2
			endif
		endif
		_nValor += _nValIPI
		
		_aParcelas := Condicao(_nValor,TRB->C7_COND,_nValIpi,_dDtEnt)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C7_FORNECE+TRB->C7_LOJA)
		
		_cNatureza := if(_lNatSC7 .and. !empty(TRB->C7_NATUREZ) , TRB->C7_NATUREZ, SA2->A2_NATUREZ)
		
		for _nConta := 1 to len(_aParcelas)
			_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==_cNatureza .and. x[4]==TRB->C7_NUM})
			if _nPos == 0
				aadd(_aVencimentos, {_aParcelas[_nConta,1],_cNatureza,_aParcelas[_nConta,2],TRB->C7_NUM})
			else
				_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
			endif
			
		next _nConta
		
		TRB->(dbskip())
		
	enddo
	TRB->(dbCloseArea())
	
	for _nConta := 1 to len(_aVencimentos)
		if _aVencimentos[_nConta,1] <= _dDataFim
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(_aVencimentos[_nConta,1])
			TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
			TRB1->HISTORICO	:= "PEDIDO DE COMPRA " + _aVencimentos[_nConta,4]
			TRB1->VALOR		:= -_aVencimentos[_nConta,3]
			TRB1->RECPAG	:= "P"
			TRB1->TIPO		:= "P"
			TRB1->ORIGEM	:= "PC"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			dbSelectarea("SED")
			dbSetOrder(1)
			if SED->(dbseek(xFilial()+_aVencimentos[_nConta,2]))
				TRB1->DESC_NAT := SED->ED_DESCRIC
			else
				TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
			endif
			MsUnlock()
		endif
	next _nConta
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01PV  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa  Pedidos de venda                                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01PV()
	local _cQuery 		:= ""
	local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
	local _aparcelas	:= {}
	local _nValor       := 0
	local _nValIPI      := 0
	local _nPos			:= 0
	local _nConta		:= 0
	
	cQuery := " SELECT C6_ENTREG,E4_ACRSFIN,C6_QTDVEN,C6_QTDENT,C6_QTDVEN,C6_VALOR,C5_MOEDA,C6_PRODUTO,F4_IPI, F4_BASEIPI,C5_CONDPAG,C5_CLIENTE,C5_LOJACLI,C6_NUM"
	cQuery += " FROM "+RetSqlName("SC6")+" C6, "+RetSqlName("SC5")+" C5, "+RetSqlName("SE4")+" E4, "+RetSqlName("SF4")+" F4"
	cQuery += " WHERE C5_NUM = C6_NUM AND E4_CODIGO = C5_CONDPAG AND F4_CODIGO = C6_TES "
	cQuery += " AND C5_TIPO IN ('N','C','P') AND F4_DUPLIC = 'S'  AND C5.D_E_L_E_T_ <> '*' AND C6.D_E_L_E_T_ <> '*' "
	
	MemoWrit("PFIN01C6.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	TcSetField("TRB","C6_ENTREG","D")
	
	COUNT TO nRecCount
	//CASO TENHA DADOS
	If nRecCount = 0
		Return
	EndIf
//	SetRegua(nRecCount)
	dbSelectArea("TRB")
	dbGoTop()
	
	while !eof()
		
		
		_dDtEnt := max( _dDtRef, (DataValida(TRB->C6_ENTREG)) )
		
		_nValPV := (1+TRB->E4_ACRSFIN/100) * ((TRB->C6_QTDVEN-TRB->C6_QTDENT)/TRB->C6_QTDVEN) * TRB->C6_VALOR
		
		_nValor := iif(str(TRB->C5_MOEDA,1,0) <> "1",xMoeda(_nValPV,TRB->C5_MOEDA,1,_dDtEnt) ,_nValPV)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C6_PRODUTO)
		
		if SB1->B1_IPI > 0 .and. TRB->F4_IPI <> "N"
			_nValIPI := (TRB->B1_IPI/100) * _nValor
			if TRB->F4_BASEIPI > 0
				_nValIPI *= (TRB->F4_BASEIPI/100)
			endif
		endif
		
		_nValor += _nValIPI
		
		_aParcelas := Condicao(_nValor,TRB->C5_CONDPAG,_nValIpi,_dDtEnt)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C5_CLIENTE+TRB->C5_LOJACLI)
		
		for _nConta := 1 to len(_aParcelas)
			_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==SA1->A1_NATUREZ .and. x[4]==TRB->C6_NUM})
			if _nPos == 0
				aadd(_aVencimentos, {_aParcelas[_nConta,1],SA1->A1_NATUREZ,_aParcelas[_nConta,2],TRB->C6_NUM})
			else
				_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
			endif
			
		next _nConta
		
		TRB->(dbskip())
		
	enddo
	
	for _nConta := 1 to len(_aVencimentos)
		if _aVencimentos[_nConta,1] <= _dDataFim
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(_aVencimentos[_nConta,1])
			TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
			//TRB1->DESC_NAT	:= GetAdvFVal("SED","ED_DESCRIC",xFilial("SED")+_aVencimentos[_nConta,2],1,"SEM NATUREZA")
			TRB1->HISTORICO	:= "PEDIDO DE VENDA " + _aVencimentos[_nConta,4]
			TRB1->VALOR		:= _aVencimentos[_nConta,3]
			TRB1->RECPAG	:= "R"
			TRB1->TIPO		:= "P"
			TRB1->ORIGEM	:= "PV"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			if SED->(dbseek(_cFilSED+_aVencimentos[_nConta,2]))
				TRB1->DESC_NAT := SED->ED_DESCRIC
			else
				TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
			endif
			MsUnlock()
		endif
	next _nConta
	TRB->(dbCloseArea())
	return
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN01SINTบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN01SINT()
	local _nPos 	:= 0
	local _cQuery 	:= ""
	local cFiltra 	:= " ORDEM <> '000001' "
	local _nSaldo 	:= 0
	private _cOrdem := "000001"
	
	ProcRegua(SZ2->(reccount())+TRB1->(reccount())+BANCOS->(reccount()))
	
	BANCOS->(dbgotop())
	while BANCOS->(!eof())
		if BANCOS->A6_OK <> ' '
			_nSaldo += BANCOS->A6_SALATU
		endif
		incproc()
		BANCOS->(dbskip())
	enddo
	
	
	RecLock("TRB2",.T.)
	TRB2->DESCRICAO	:= "SALDO INICIAL"
	TRB2->ORDEM		:= _cOrdem
	TRB2->TOTAL 	:= _nSaldo
	FieldPut(TRB2->(fieldpos(_aCpos[1])) , _nSaldo) // Campo do primeiro dia de movimento
	MsUnlock()
	
	_nSaldoIni	:= _nSaldo
	
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	
	_cOrdem := soma1(_cOrdem)
	
	// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas
	RecLock("TRB2",.T.)
	TRB2->DESCRICAO := "SEM NATUREZA OU GRUPO"
	TRB2->ORDEM		:= _cOrdem
	MsUnlock()
	
	_cOrdem := soma1(_cOrdem)
	
	// Carga com todos os grupos de naturezas existentes
	SZ2->(dbsetorder(1)) // Z2_FILIAL + Z2_GRUPO
	SZ2->(dbgotop())
	while SZ2->(!eof())
		RecLock("TRB2",.T.)
		TRB2->GRUPO 	:= SZ2->Z2_GRUPO
		TRB2->DESCRICAO	:= SZ2->Z2_DESCRI
		TRB2->ORDEM		:= _cOrdem
		TRB2->GRUPOSUP 	:= SZ2->Z2_CODSUP
		MsUnlock()
		if ascan(_aGrpSint,SZ2->Z2_CODSUP) == 0
			aadd(_aGrpSint,SZ2->Z2_CODSUP)
		endif
		SZ2->(dbskip())
		_cOrdem := soma1(_cOrdem)
	enddo
	
	//_cFilTRB1 := TRB1->(dbfilter())
	TRB1->(dbclearfil())
	
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	TRB1->(dbgotop())
	while TRB1->(!eof())
		_nPos 	:= TRB2->(fieldpos(TRB1->CAMPO))
		if _nPos > 0
			GravaVlr(TRB1->GRUPONAT,TRB1->VALOR,_nPos)
		endif
		TRB1->(dbskip())
	enddo
	
	//msgstop(_cFilTRB1)
	//TRB1->(dbsetfilter({|| &(_cFilTRB1)} , _cFilTRB1))
	
	TRB2->(dbclearfil())
	
	AtuSaldo()
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGravaVlr  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Grava valor no arquivo sintetico                           บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function GravaVlr(_cGrupo, _nValor, _nPosCpo)
	local _nValAtual := 0
	
	if TRB2->(dbseek(_cGrupo))
		
		_nValAtual := TRB2->(FieldGet(_nPosCpo))
		
		RecLock("TRB2",.F.)
		FieldPut(_nPosCpo , _nValor + _nValAtual)
		TRB2->TOTAL += _nValor
		MsUnlock()
		
	else // Se o grupo nao existir
		
		RecLock("TRB2",.T.)
		TRB2->GRUPO 	:= _cGrupo
		TRB2->DESCRICAO	:= "GRUPO INEXISTENTE"
		TRB2->ORDEM		:= _cOrdem
		FieldPut( _nPosCpo , _nValor )
		TRB2->TOTAL += _nValor
		MsUnlock()
		_cOrdem := soma1(_cOrdem)
		
	endif
	
	if !empty(TRB2->GRUPOSUP)
		GravaVlr(TRB2->GRUPOSUP, _nValor, _nPosCpo)
	endif
	
	AtuSaldo() // Atualiza os saldo iniciais
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณAtuSaldo  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Atualiza o Saldo inicial de todos os dias no TRB2          บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function AtuSaldo()
	local _cQuery 	:= ""
	local _aSaldos	:= {}
	local _nPos		:= 0
	
	/*
	for _ni := 1 to _nCampos
	aAdd(_aSaldos,{_aCpos[_ni] ,0})
	next _ni
	
	TRB2->(dbgotop())
	while TRB2->(!eof())
	if TRB2->(recno())<>_nRecSaldo .and. !empty(TRB2->GRUPOSUP) .and. ascan(_aGrpSint,TRB2->GRUPO) == 0 ;
	.or. alltrim(TRB2->DESCRICAO) == "SEM NATUREZA OU GRUPO"
	for _ni := 1 to _nCampos
	_nPos := Ascan(_aSaldos,{|x| x[1]==_aCpos[_ni]})
	if _nPos > 0
	_aSaldos[_nPos,2] += &("TRB2->" + _aCpos[_ni])
	endif
	next _ni
	endif
	TRB2->(dbskip())
	enddo
	
	TRB2->(dbgoto(_nRecSaldo)) // Posiciona no registro de saldo inicial
	
	_nSaldo := _nSaldoIni
	for _ni := 1 to _nCampos-1
	_nSaldo += _aSaldos[_ni,2]
	&("TRB2->" + _aCpos[_ni+1] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
	next _ni
	
	*/
	
	/* TRECHO NOVO  */
	for _ni := 1 to _nCampos
		aAdd(_aSaldos,{_aCpos[_ni] ,0})
	next _ni
	
	TRB11->(dbgotop())
	while TRB11->(!eof())
		//for _ni := 1 to _nCampos
		_nPos := Ascan(_aSaldos,{|x| x[1]==TRB11->CAMPO})
		if _nPos > 0
			_aSaldos[_nPos,2] += TRB11->VALOR
		endif
		//next _ni
		TRB11->(dbskip())
	enddo
	
	TRB2->(dbgoto(_nRecSaldo)) // Posiciona no registro de saldo inicial
	
	_nSaldo := _nSaldoIni
	for _ni := 1 to _nCampos-1
		_nSaldo += _aSaldos[_ni,2]
		&("TRB2->" + _aCpos[_ni+1] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
	next _ni
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณMontaTela บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Monta a tela de visualizacao do Fluxo Sintetico            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function MontaTela()
	private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
	Private aSize   := MsAdvSize(,.F.,400)
	Private aObjects:= { { 450, 450, .T., .T. } }
	Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
	Private aHeader	:= {}
	Private lRefresh:= .T.
	Private aButton := {}
	Private _oGetDbSint
	Private _oDlgSint
	
	// Monta aHeader do TRB2
	aadd(aHeader, {"Grupo","GRUPO","",06,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Descri็ใo","DESCRICAO","",30,0,"","","C","TRB2","R"})
	for _ni := 1 to len(_aCpos) // Monta campos com as datas
		aadd(aHeader, {_aLegPer[_ni],_aCpos[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	next _dData
	aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	
	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Fluxo de caixa - Sint้tico - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - Perํodo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Diแrio") ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB2")
	
	_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}
	
	aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simula็ใo" } )
	aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
	
	ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณShowAnalitบAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function ShowAnalit(_cCampo,_cPeriodo)
	local cFiltra 	:= ""
	
	private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
	Private aSize   := MsAdvSize(,.F.,400)
	Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
	Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
	Private aHeader	:= {}
	Private lRefresh:= .T.
	Private aButton	:= {}
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
	if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
		return
	endif
	
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(GRUPONAT) == '" + alltrim(TRB2->GRUPO) + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	// Monta aHeader do TRB1
	aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB2","R"})
	aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Descri็ใo"	,"DESC_NAT"	,"",30,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Hist๓rico"	,"HISTORICO","",50,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})
	
	DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Analํtico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
	"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")
	
	@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: MB - Movimento Bancแrio / CR - Contas a Receber / CP - Contas a Pagar / PC - Pedido de Compras / PV - Pedido de Vendas"
	
	aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula็ใo" } )
	aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula็ใo" } )
	aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
	
	ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)
	
	TRB1->(dbclearfil())
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ GerSimul บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Inclui Simulacao no Fluxo de Caixa                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function GerSimul(_cCampo, _cPeriodo)
	local _nOpca := 0
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
	if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0
		return
	endif
	
	private _nOpcoes 	:= 1
	private _aOpcoes 	:= {"Simula็ใo a Pagar ","Simula็ใo a Receber"}
	private _cGrupo	 	:= TRB2->DESCRICAO
	private _cLegPer 	:= _aLegPer[ascan(_aCpos,_cCampo)]
	private _nValor	 	:= 0
	private _cHistorico	:= space(50)
	
	@ 000,000 To 280,350 Dialog _oDlgSimul Title "Simula็ใo"
	
	@ 010,005 Say "Grupo"
	@ 010,035 Get _cGrupo Size 125,10 When .F.
	
	@ 025,005 Say "Perํodo"
	@ 025,035 Get _cLegPer Size 55,10 When .F.
	
	@ 045,005 Radio _aOpcoes Var _nOpcoes
	
	@ 070,005 Say "Valor"
	@ 070,035 Get _nValor Picture "@E 999,999,999.99" Valid positivo() Size 55,10
	
	@ 085,005 Say "Hist๓rico"
	@ 085,035 Get _cHistorico Picture "@!" Size 125,10
	
	@ 110,110 BmpButton Type 1 Action iif(_nValor > 0, (_nOpca:=1,_oDlgSimul:End()) , _oDlgSimul:End())
	@ 110,140 BmpButton Type 2 Action (_oDlgSimul:End())
	
	Activate Dialog _oDlgSimul centered
	
	if _nOpca == 1 // Se confirmada a inclusao da simulacao
		
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= _aDatas[Ascan(_aDatas , { |x| x[2] == _cCampo }),1] // Pega a primeira data do periodo como data da simulacao
		TRB1->DESC_NAT	:= "SIMULACAO"
		TRB1->HISTORICO	:= _cHistorico
		TRB1->VALOR		:= iif(_nOpcoes == 1 , -(_nValor) , _nValor)
		TRB1->RECPAG	:= iif(_nOpcoes == 1 , "P", "R")
		TRB1->GRUPONAT 	:= TRB2->GRUPO
		TRB1->CAMPO		:= _cCampo
		TRB1->SIMULADO	:= "S"
		MsUnlock()
		
		if msgyesno("Deseja guardar essa simula็ใo para consultas futuras?")
			RecLock("SZ3",.T.)
			SZ3->Z3_FILIAL 	:= xFilial("SZ3")
			SZ3->Z3_GRUPO 	:= TRB1->GRUPONAT
			SZ3->Z3_DATA 	:= TRB1->DATAMOV
			SZ3->Z3_HIST 	:= TRB1->HISTORICO
			SZ3->Z3_VALOR	:= abs(TRB1->VALOR)
			SZ3->Z3_RECPAG	:= TRB1->RECPAG
			MsUnlock()
			
			aadd(_aRegSimul, {TRB1->(recno()), SZ3->(recno())} )
			
		endif
		
		// Limpa e recria o Arquivo sintetico - TRB2
		DbSelectArea("TRB2")
		zap
		
		MSAguarde({||PFIN01SINT()},"Gerando arquivo sint้tico.")
		
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ DelSimul บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Excluir Simulacao no Fluxo de Caixa                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function DelSimul()
	local _nOpca := 0
	local _nPos
	local _nRecTRB1
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
	if TRB1->SIMULADO <> "S"
		
		MsgStop("Apenas movimentos de simula็ใo podem ser excluํdos.")
		
	elseif msgyesno("Confirma exclusใo do movimento de simula็ใo?")
		
		_nRecTRB1 := TRB1->(recno())
		RecLock("TRB1",.F.)
		dbdelete()
		MsUnlock()
		
		if msgyesno("Deseja excluir essa simula็ใo de consultas futuras?")
			_nPos := Ascan(_aRegSimul,{|x| x[1] == _nRecTRB1})
			if _nPos > 0
				SZ3->(dbgoto(_aRegSimul[_nPos,2]))
				RecLock("SZ3",.F.)
				dbdelete()
				MsUnlock()
			endif
		endif
		
		// Limpa e recria o Arquivo sintetico - TRB2
		DbSelectArea("TRB2")
		zap
		MSAguarde({||PFIN01SINT()},"Gerando arquivo sint้tico.")
		
		//_oDlgAnalit:End()
		TRB1->(dbgotop())
		TRB2->(dbgotop())
		
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGeraExcel บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function GeraExcel(_cAlias,_cFiltro,aHeader)
	
	MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)
	
	/*
	_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
	
	if !empty(_cFiltro)
	copy to &(_cArq) VIA "DBFCDXADS" for &(_cFiltro)
	else
	copy to &(_cArq) VIA "DBFCDXADS"
	endif
	
	MsAguarde({||AbreDoc( _cArq ) },"Aguarde","Abrindo Arquivo",.F.)
	*/
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGeraCSV   บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)
	
	local cDirDocs  := MsDocPath()
	Local cArquivo 	:= CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX
	
	local _cArq		:= ""
	
	_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
	
	if !empty(_cFiltro)
		(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
	endif
	
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
	
	If nHandle > 0
		
		// Grava o cabecalho do arquivo
		aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
		fWrite(nHandle, cCrLf ) // Pula linha
		
		(_cAlias)->(dbgotop())
		while (_cAlias)->(!eof())
			
			for _ni := 1 to len(aHeader)
				
				_uValor := ""
				
				if aHeader[_ni,8] == "D" // Trata campos data
					_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
				elseif aHeader[_ni,8] == "N" // Trata campos numericos
					_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
				elseif aHeader[_ni,8] == "C" // Trata campos caracter
					_uValor := &(_cAlias + "->" + aHeader[_ni,2])
				endif
				
				if _ni <> len(aHeader)
					fWrite(nHandle, _uValor + ";" )
				endif
				
			next _ni
			
			fWrite(nHandle, cCrLf )
			
			(_cAlias)->(dbskip())
			
		enddo
		
		fClose(nHandle)
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
		
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert("Falha na cria็ใo do arquivo")
	Endif
	
	(_cAlias)->(dbclearfil())
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณAbreArq   บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function AbreArq()
	local aStru 	:= {}
	local _dData
	local _nDias	:= 1
	local _cCpoAtu
	local _ni
	
	if file(_cArq) .and. ferase(_cArq) == -1
		msgstop("Nใo foi possํvel abrir o arquivo PFIN01.XLS pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
	
	_cCpoAtu := "D_" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","_") // Primeiro campo que sera criado
	if _nDiasPer == 1 // Se for diario, grava a data
		aadd(_aLegPer , dtoc(DataValida(_dDataIni),"dd/mm/yy"))
	else // Senao grava dd/mm a dd/mm
		aadd(_aLegPer , left(dtoc(DataValida(_dDataIni),"dd/mm/yy"),5) + " a ")
	endif
	for _dData := _dDataIni to _dDataFim step 1 // Monta campos com as datas
		
		if _dData == DataValida(_dData) // Apenas dias uteis
			
			if _nDias > _nDiasPer // Se ja acumulou mais que o necessario
				if _nDiasPer == 1 // Se for diario, grava a data
					aadd(_aLegPer , dtoc(_dData,"dd/mm/yy")) // Grava o dia como label do campo
				else // Grava a data inicial no campo
					_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
					aadd(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),5) + " a ")
				endif
				
				_cCpoAtu 	:= "D_" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","_") // gera o nome do campo
				_nDias 		:= 1 // reinicia o contador
			endif
			
			_nDias++
			
			aadd(_aDatas , {_dData, _cCpoAtu})
			
			if ascan(_aCpos , _cCpoAtu) == 0
				aadd(_aCpos , _cCpoAtu)
			endif
			
		endif
		
	next _dData
	
	_nCampos := len(_aCpos)
	
	if _nDiasPer <> 1
		_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
	endif
	
	// monta arquivo analitico
	aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
	aAdd(aStru,{"NATUREZA"	,"C",10,0}) // Codigo da Natureza
	aAdd(aStru,{"DESC_NAT"	,"C",30,0}) // Descricao da Natureza
	aAdd(aStru,{"HISTORICO"	,"C",50,0}) // Historico
	aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
	aAdd(aStru,{"RECPAG"	,"C",01,0}) // (R)eceber ou (P)agar
	aAdd(aStru,{"TIPO"		,"C",01,0}) // Tipo - (P)revisto ou (R)ealizado
	aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
	aAdd(aStru,{"GRUPONAT"	,"C",06,0}) // Grupos de Natureza
	aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
	aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao
	
	dbcreate(cArqTrb1,aStru)
	dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
	dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)
	
	aStru := {}
	aAdd(aStru,{"GRUPO"		,"C",06,0}) // Codigo da Natureza
	aAdd(aStru,{"DESCRICAO"	,"C",30,0}) // Descricao da Natureza
	for _ni := 1 to len(_aCpos) // Monta campos com as datas
		aAdd(aStru,{_aCpos[_ni] ,"N",15,2}) // Valor do movimento no dia
	next _dData
	aAdd(aStru,{"TOTAL"		,"N",15,2}) // Valor total dos movimentos
	aAdd(aStru,{"ORDEM"		,"C",06,0}) // Ordem de apresentacao
	aAdd(aStru,{"GRUPOSUP"	,"C",06,0}) // Codigo do grupo superior
	
	dbcreate(cArqTrb2,aStru)
	dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
	index on ORDEM to &(cArqTrb2+"2")
	index on GRUPO+DESCRICAO to &(cArqTrb2+"1")
	set index to &(cArqTrb2+"1")
	
	return(.T.)
	
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ RETGRUPO บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function RetGrupo(_cNaturez)
	local _cRet := ""
	
	if empty(_cNaturez)
		_cRet := space(6)
	else
		SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
		if SED->(dbseek(xFilial("SED")+_cNaturez))
			_cRet := SED->ED_XGRUPO
		endif
		
	endif
	
	return(_cRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ RETCAMPO บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function RetCampo(_dData)
	local _cRet := ""
	
	_nPos := Ascan(_aDatas , { |x| x[1] == _dData })
	
	if _nPos > 0
		_cRet := _aDatas[_nPos,2]
	endif
	
	return(_cRet)
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณVLDPARAM  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Valida os parametros digitados                             บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function VldParam()
	
	if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
		msgstop("Todas as datas dos parโmetros devem ser informadas.")
		return(.F.)
	endif
	
	if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
		msgstop("A data de inํcio do processamento deve ser menor ou igual a data de refer๊ncia.")
		return(.F.)
	endif
	
	if _dDataFim < _dDtRef // Data de fim menor que data de referencia
		msgstop("A data de final do processamento deve ser maior ou igual a data de refer๊ncia.")
		return(.F.)
	endif
	
	return(.T.)
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณABREDOC   บAutor  ณMarcos Zanetti G&Z  บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre o XLS com os dados do fluxo de caixa                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function AbreDoc( _cFile )
	LOCAL cDrive     := ""
	LOCAL cDir       := ""
	
	cTempPath := "C:\"
	cPathTerm := cTempPath + _cFile
	
	ferase(cTempPath + _cFile)
	
	If CpyS2T( "\SIGAADV\"+_cFile, cTempPath, .T. )
		SplitPath(cPathTerm, @cDrive, @cDir )
		cDir := Alltrim(cDrive) + Alltrim(cDir)
		nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
	else
		MsgStop("Ocorreram problemas na c๓pia do arquivo.")
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณVALIDPERG บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function VALIDPERG()
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
	// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Data Inicial"			,"Data Inicial"			,"Data Inicial"			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","",{"Data de inicio do processamento"})
	PutSX1(cPerg,"02","Data Final"				,"Data Final"			,"Data Final"			,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","",{"Data final do processamento"})
	PutSX1(cPerg,"03","Data de Referencia"		,"Data de Referencia"	,"Data de Referencia"	,"mv_ch3","D",08,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","",{"Data de referencia do processamento","movimentos apos essa data sao","previstos e o restante, realizados"})
	PutSX1(cPerg,"04","Considera Ped. Compra" 	,"Considera Ped. Compra","Considera Ped. Compra","mv_ch4","N",01,0,0,"C","",""		,"",,"mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"05","Considera Ped. Venda" 	,"Considera Ped. Venda"	,"Considera Ped. Venda"	,"mv_ch5","N",01,0,0,"C","",""		,"",,"mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"06","Considera Vencidos"		,"Considera Vencidos"	,"Considera Vencidos"	,"mv_ch6","N",01,0,0,"C","",""		,"",,"mv_par06","A Receber","","","","A Pagar","","","Ambos","","","Nenhum","","","","","")
	PutSX1(cPerg,"07","Dias por periodo"		,"Dias por periodo"		,"Dias por periodo"		,"mv_ch7","N",02,0,0,"G","",""		,"",,"mv_par07","","","","","","","","","","","","","","","","",{"Indica quantos dias serใo considerados","por perํodo (coluna) do relat๓rio"})
	PutSX1(cPerg,"08","Seleciona Bancos"		,"Seleciona Bancos"		,"Seleciona Bancos"		,"mv_ch8","N",01,0,0,"C","",""		,"",,"mv_par08","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"09","Considera Previsoes"	    ,"Considera Previsoes"	,"Considera Previsoes"	,"mv_ch9","N",01,0,0,"C","",""		,"",,"mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	
	return
