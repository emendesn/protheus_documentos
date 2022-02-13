#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFIN02   บ Autor ณ M.Munhoz - ERPPLUS บ Data ณ  30/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Comissoes de Vendas                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFIN02()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat๓rio de Comiss๕es"
Local cPict          := ""
Local titulo         := "Relat๓rio de Comiss๕es"

//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//999999    XXX   X   99/99/99  99/99/99  XXXXXXXXXXXXXXXXXXXX XX  99,999,999.99  99,999,999.99     99,999,999.99    99,999,999.99    99/99/99    XXXXXXXXXXXXXXX 999999  99  99,999,999.99     999.99  99,999,999.99
//N.Fiscal  Ser   Par  Emissao   Vencim   Nome Cliente         UF   Valor Titulo   Saldo Titulo     B.C. Comissao    Val. Comissao    Dt.Pagto    Cod. Produto    Pedido  It  Valor Mercad.     % Com.  Val. Comissao
Local Cabec1         := "NOTAS FISCAIS  |                               TITULOS A RECEBER                                |           PAGAMENTO DAS COMISSOES                     |                      ITENS DAS NOTAS FISCAIS                      "
Local Cabec2         := "N๚mero    Ser  |Par  Emissao   Vencim   Nome Cliente         UF   Valor Titulo   Saldo Titulo   | B.C. Comissao    Val. Comissao    Dt.Emis.  Dt.Pagto  | Cod. Produto    Pedido  It  Valor Mercad.     % Com.  Val.Comissao"
Local imprime        := .T.
Local aOrd           := {}

Private nLin         := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFIN02"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RFIN02"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFIN02"
Private cString      := "SE1"

u_GerA0003(ProcName())

dbSelectArea("SE1")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  30/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

local nOrdem
private _cVend   := ""
private _aComiss := {}
private _cSerie  := _cNF := _cCliente := _cLoja := _cCodVen := ""
		
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ mv_par03 -> Considera qual estado?                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Executa query para retornar os dados de titulos a receber
ExecQry()

// Executa contagem para alimentar regua de processamento
_nRegua:=0
TRB1->(dbGoTop())
while TRB1->(!eof())
	_nRegua++
	TRB1->(dbSkip())
enddo

SetRegua(_nRegua)

// Processa arquivo de titulos a receber, alimentando matrizes para posterior impressao
TRB1->(dbGoTop())
while TRB1->(!eof())

	_cVend    := TRB1->CODVEND
	_nNF      := ""      

	while TRB1->(!eof()) .and. _cVend == TRB1->CODVEND       

		_cSerie   := TRB1->E1_PREFIXO
		_cNF      := TRB1->E1_NUM 
		_cCliente := TRB1->E1_CLIENTE
		_cLoja    := TRB1->E1_LOJA
		_nIdVend  := TRB1->IDVEND     
		_aNF      := {}
		_aTitulos := {}

		while TRB1->(!eof()) .and. _cVend == TRB1->CODVEND .and. _cNF == TRB1->E1_NUM .and. _cSerie == TRB1->E1_PREFIXO

			// Pesquisa comissoes ja calculadas para cada parcela
			_aComCalc := {}
			SE3->(dbSetOrder(2))  // E3_FILIAL + E3_VEND + E3_PREFIXO + E3_NUM + E3_PARCELA + E3_SEQ
			if SE3->(dbSeek(xFilial("SE3") + _cVend + _cSerie + _cNF + TRB1->E1_PARCELA))

				while SE3->(!eof()) .and. SE3->E3_FILIAL == xFilial("SE3") .and. SE3->E3_VEND == _cVend .and. ;
					  SE3->E3_PREFIXO == _cSerie .and. SE3->E3_NUM == _cNF .and. SE3->E3_PARCELA == TRB1->E1_PARCELA //.and. ; 

					  //Acrescentado essa condicao, pois estava desconsiderando mesma parcela paga em periodos diferentes - 03/04/09 -Edson Rodrigues 
					  IF SE3->E3_EMISSAO >= mv_par07 .and. SE3->E3_EMISSAO <= mv_par08
						  aAdd(_aComCalc , {SE3->E3_BASE, SE3->E3_PORC, SE3->E3_COMIS, SE3->E3_DATA, SE3->E3_TIPO, SE3->E3_SEQ, SE3->E3_EMISSAO } )
                      ENDIF
						
					  SE3->(dbSkip())

				enddo

			endif

			if mv_par15 <> 1 .or. mv_par15 == 1 .and. len(_aComCalc) > 0
				aAdd(_aTitulos , {	TRB1->E1_PREFIXO, TRB1->E1_NUM, TRB1->E1_PARCELA, TRB1->E1_CLIENTE, TRB1->E1_LOJA, ;
									TRB1->E1_EMISSAO, TRB1->E1_VENCREA, TRB1->E1_VALOR, TRB1->E1_SALDO, _aComCalc } )
			endif
			TRB1->(dbSkip())

		enddo

		// Busca itens de NF correspondente ao titulo
		_aItensNF := {}
		if len(_aTitulos) > 0

			SD2->(dbSetOrder(3)) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
			if SD2->(dbSeek(xFilial("SD2") + _cNF + _cSerie + _cCliente + _cLoja ))
	
				while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == _cNF .and. SD2->D2_SERIE == _cSerie .and. ;
					  SD2->D2_CLIENTE == _cCliente .and. SD2->D2_LOJA == _cLoja
	
					if _nIdVend <> 0
						_nAliqCom := &( "SD2->D2_COMIS" + alltrim(str(_nIdVend)) )
						aAdd(_aItensNF , {	SD2->D2_COD, SD2->D2_PEDIDO, SD2->D2_ITEMPV, SD2->D2_TOTAL, _nAliqCom } )
					endif
					SD2->(dbSkip())
	
				enddo
	
			endif

			aAdd(_aComiss, {_cVend, _cNF, _cSerie, _aTitulos, _aItensNF } )
			_aTitulos := {}
			_aItensNF := {}

		endif

	enddo

enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport2(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  30/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport2(Cabec1,Cabec2,Titulo,nLin)

local _nBCCom  	:= _nValCom  := _nValMerc  := _nValCom2  := 0
local _nTBCCom 	:= _nTValCom := _nTValMerc := _nTValCom2 := _nTValTit := _nTSalTit := 0
local _cLinha  	:= _cLinTit  := ""
local _lGeraCSV 	:= iif(mv_par16 == 1,.T.,.F.)

private _cCodVen 	:= ""
private _aImpTit 	:= {}
private _aImpCom 	:= {}
private _aImpINF 	:= {}

Private cArqTxt 	:= __reldir+"\comissoes.csv"
Private nHdl    	:= fCreate(cArqTxt)
Private cEOL    	:= "CHR(13)+CHR(10)"

if _lGeraCSV
	// Prepara variavel com identificacao do fim de linha
	If Empty(cEOL)
	    cEOL := CHR(13)+CHR(10)
	Else
	    cEOL := Trim(cEOL)
	    cEOL := &cEOL
	Endif
	
	// Verifica permissao para criar o arquivo texto
	If nHdl == -1
	    apMsgAlert("Nใo foi possํvel criar o arquivo de nome "+cArqTxt+"! O programa continuarแ sem criar o arquivo mencionado.","Aten็ใo!")
	    _lGeraCSV := .f.
	else
		_cLinha := "Cod Vend;Numero NF;Serie;Parcela;Dt Emissao;Dt Vencto;Cliente;UF;Valor Titulo;Saldo Titulo;Base Comissao;Valor Comissao;Data Pagamento;Cod Produto;Pedido de Venda;Item PV;Valor Mercadoria;Perc Comiss;Valor Comissao"+cEOL
		If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
		    apMsgAlert("Nใo foi possํvel criar o arquivo de nome "+cArqTxt+"! O programa continuarแ sem criar o arquivo mencionado.","Aten็ใo!")
		    _lGeraCSV := .f.
		Endif
	Endif
endif

// Habilita regua com a quantidade de registros a processar
SetRegua(len(_aComiss))

// Passa pela matriz de vendedores para impressao
for x := 1 to len(_aComiss)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	IncRegua()

	nLin := ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)

	if _cCodVen <> _aComiss[x,1]
		@nLin,000 PSAY "Perํodo: de " + dtoc(mv_par03) + " a " + dtoc(mv_par04)
		nLin+=2
		@nLin,000 PSAY "Vendedor: " + alltrim(_aComiss[x,01]) + " - " + alltrim(Posicione("SA3",1,xFilial("SA3") + _aComiss[x,01], "A3_NOME"))
		nLin+=2
		_cCodVen := _aComiss[x,01]
	endif

	@nLin,000 PSAY _aComiss[x,02]  // Nota Fiscal
	@nLin,010 PSAY _aComiss[x,03]  // Serie

	if _lGeraCSV 
		_cLinTit := _cCodVen + ";"
		_cLinTit += "'"+_aComiss[x,02] + ";"
		_cLinTit += "'"+_aComiss[x,03] + ";"
	endif

	_aImpTit := _aComiss[x,04]
	_aImpINF := _aComiss[x,05]
	_nINF    := 0

	// Imprime cada parcela de titulos da Nota Fiscal
	for y := 1 to len(_aImpTit)

		nLin := ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)

		SA1->(dbSeek(xFilial("SA1") + _aImpTit[y,04] + _aImpTit[y,05]))
		@nLin,016 PSAY _aImpTit[y,03]  // Parcela
		@nLin,020 PSAY _aImpTit[y,06]  // Data de Emissao
		@nLin,030 PSAY _aImpTit[y,07]  // Data de Vencimento
		@nLin,040 PSAY  SUBSTRING(alltrim(SA1->A1_NOME),1,20)
		@nLin,061 PSAY SA1->A1_EST
		@nLin,065 PSAY _aImpTit[y,08] Picture "@E 99,999,999.99" // Valor Total Titulo
		@nLin,080 PSAY _aImpTit[y,09] Picture "@E 99,999,999.99" // Valor Saldo em Aberto
		_nTValTit += _aImpTit[y,08]
		_nTSalTit += _aImpTit[y,09]
		_aImpCom  := _aImpTit[y,10]

		if _lGeraCSV 
			_cLinTit  += "'"+_aImpTit[y,03] + ";" 
			_cLinTit  += dtoc(_aImpTit[y,06]) + ";" 
			_cLinTit  += dtoc(_aImpTit[y,07]) + ";" 
			_cLinTit  += SUBSTRING(alltrim(SA1->A1_NOME),1,20) + ";" 
			_cLinTit  += SA1->A1_EST + ";"
			_cLinTit  += transform(_aImpTit[y,08], "@E 99,999,999.99") + ";" 
			_cLinTit  += transform(_aImpTit[y,09], "@E 99,999,999.99") + ";" 
		endif

		// Imprime as comissoes calculadas para cada parcela de titulo
		if len(_aImpCom) > 0

			for w := 1 to len(_aImpCom)
	
				nLin := ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)
				nLin := nLin + iif(w <> 1, 1, 0)
				@nLin,098 PSAY _aImpCom[w,01] Picture "@E 99,999,999.99" 	// Base Calculo Comissao
				@nLin,115 PSAY _aImpCom[w,03] Picture "@E 99,999,999.99" 	// Valor Comissao
				@nLin,132 PSAY dtoc(_aImpCom[w,07])  								// Data Geracao da Comissao
				@nLin,142 PSAY dtoc(_aImpCom[w,04])  								// Data Pagamento
	
				_nTBCCom  += _aImpCom[w,01]
				_nTValCom += _aImpCom[w,03] 

				if _lGeraCSV
					_cLinCom := ""
					_cLinCom += transform(_aImpCom[w,01], "@E 99,999,999.99") + ";" 
					_cLinCom += transform(_aImpCom[w,03], "@E 99,999,999.99") + ";"
					_cLinCom += dtoc(_aImpCom[w,04]) + ";"
				endif

				// Imprime itens da NF a cada impressao de comissao calculada  
				if _nINF < len(_aImpINF)					
	
					_cLinINF := ";;;;;;"
					_nINF++
					@nLin,154 PSAY _aImpINF[_nINF,01]  							  			// Codigo Produto
					@nLin,170 PSAY _aImpINF[_nINF,02]  							  			// Numero Pedido 
					@nLin,178 PSAY _aImpINF[_nINF,03]  										// Item Pedido
					@nLin,182 PSAY _aImpINF[_nINF,04] Picture "@E 99,999,999.99"  	// Valor Mercadoria
					@nLin,200 PSAY _aImpINF[_nINF,05] Picture "@E 999.99"         	// Percentual Comissao
					@nLin,207 PSAY round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2) Picture "@E 99,999,999.99" // Valor Comissao
					_nTValMerc += _aImpINF[_nINF,04]
					_nTValCom2 += round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2)

					if _lGeraCSV
						_cLinINF := _aImpINF[_nINF,01] + ";"
						_cLinINF += _aImpINF[_nINF,02] + ";"
						_cLinINF += "'"+_aImpINF[_nINF,03] + ";"
						_cLinINF += transform(_aImpINF[_nINF,04],"@E 99,999,999.99") + ";"
						_cLinINF += transform(_aImpINF[_nINF,05],"@E 999.99") + ";"
						_cLinINF += transform(round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2),"@E 99,999,999.99") + ";"
					endif

				endif

				if _lGeraCSV
					_cLinha  := _cLinTit + _cLinCom + _cLinINF + cEOL
					_cLinCom := _cLinINF := ""
					If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
						If !apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
							Exit
						Endif
					Endif
				endif

			next w

		// Imprime itens da NF quando nao existir comissao calculada
		elseif _nINF < len(_aImpINF)

			_nINF++
			@nLin,154 PSAY _aImpINF[_nINF,01]
			@nLin,170 PSAY _aImpINF[_nINF,02]
			@nLin,178 PSAY _aImpINF[_nINF,03]
			@nLin,182 PSAY _aImpINF[_nINF,04] Picture "@E 99,999,999.99"
			@nLin,200 PSAY _aImpINF[_nINF,05] Picture "@E 999.99"
			@nLin,207 PSAY round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2) Picture "@E 99,999,999.99" // Valor Comissao
			_nTValMerc += _aImpINF[_nINF,04]
			_nTValCom2 += round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2)

			if _lGeraCSV
				_cLinINF := ""
				_cLinCom := ";;;" 
				_cLinINF += _aImpINF[_nINF,01] + ";"
				_cLinINF += _aImpINF[_nINF,02] + ";"
				_cLinINF += "'"+_aImpINF[_nINF,03] + ";"
				_cLinINF += transform(_aImpINF[_nINF,04],"@E 99,999,999.99") + ";"
				_cLinINF += transform(_aImpINF[_nINF,05],"@E 999.99") + ";"
				_cLinINF += transform(round(_aImpINF[_nINF,04] * _aImpINF[_nINF,05] / 100,2),"@E 99,999,999.99") + ";"
				_cLinha  := _cLinTit + _cLinCom + _cLinINF + cEOL
				_cLinCom := _cLinINF := ""
				If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
					If !apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					Endif
				Endif
			endif

		endif

		nLin++

	next y

	// Imprime itens da NF quando existir mais itens que titulos x comissoes calculadas
	if y-1 < len(_aImpINF) .and. _nINF < len(_aImpINF)

		for z := _nINF+1 to len(_aImpINF)
			nLin := ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)
			nLin := nLin + iif(z <> _nINF + 1, 1, 0)
			@nLin,154 PSAY _aImpINF[z,01]
			@nLin,170 PSAY _aImpINF[z,02]
			@nLin,178 PSAY _aImpINF[z,03]
			@nLin,182 PSAY _aImpINF[z,04] Picture "@E 99,999,999.99"
			@nLin,200 PSAY _aImpINF[z,05] Picture "@E 999.99"
			@nLin,207 PSAY round(_aImpINF[z,04] * _aImpINF[z,05] / 100,2) Picture "@E 99,999,999.99" // Valor Comissao
			_nTValMerc += _aImpINF[z,04]
			_nTValCom2 += round(_aImpINF[z,04] * _aImpINF[z,05] / 100,2)

			if _lGeraCSV
				_cLinINF := ""
				_cLinCom := ";;;" 
				_cLinINF += _aImpINF[z,01] + ";"
				_cLinINF += _aImpINF[z,02] + ";"
				_cLinINF += "'"+_aImpINF[z,03] + ";"
				_cLinINF += transform(_aImpINF[z,04],"@E 99,999,999.99") + ";"
				_cLinINF += transform(_aImpINF[z,05],"@E 999.99") + ";"
				_cLinINF += transform(round(_aImpINF[z,04] * _aImpINF[z,05] / 100,2),"@E 99,999,999.99") + ";"
				_cLinha  := _cLinTit + _cLinCom + _cLinINF + cEOL
				_cLinCom := _cLinINF := ""
				If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
					If !apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					Endif
				Endif
			endif

		next z

	endif

	if len(_aImpINF) > 1 .or. len(_aImpCom) > 1

		nLin := ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)

		_nBCCom := _nValCom := _nValMerc := _nValCom2 := 0
		for nx := 1 to len(_aImpCom)
			_nBCCom   += _aImpCom[nx,01]
			_nValCom  += _aImpCom[nx,03]
		next nx
		for ny := 1 to len(_aImpINF)
			_nValMerc += _aImpINF[ny,04]
			_nValCom2 += _aImpINF[ny,04] * _aImpINF[ny,05] / 100
		next ny
    	nLin++
		@nLin,097 PSAY Replicate("-",14)
		@nLin,114 PSAY Replicate("-",14)
		@nLin,181 PSAY Replicate("-",14)
		@nLin,207 PSAY Replicate("-",14)
		nLin++
		@nLin,000 PSAY "Sub-Total da NF:"
		@nLin,098 PSAY _nBCCom   Picture "@E 99,999,999.99" // Base Calculo Comissao
		@nLin,115 PSAY _nValCom  Picture "@E 99,999,999.99" // Valor Comissao
		@nLin,182 PSAY _nValMerc Picture "@E 99,999,999.99" // Valor Mercadoria
		@nLin,207 PSAY _nValCom2 Picture "@E 99,999,999.99" // Valor Comissao Calculado pelos itens da NF
		nLin++
		_nBCCom := _nValCom := _nValMerc := _nValCom2 := 0

	endif

	@nLin,000 PSAY Replicate("-",220)
	nLin++

	if x == len(_aComiss) .or. _cCodVen <> _aComiss[x+1,01]

		// Imprime devolucoes de venda do periodo no final das comissoes
		ExecDev(_cCodVen)
		_lImpTit := .t.
		while TRB2->(!eof())
		
			if _lImpTit
				@nLin,000 PSAY "Devolu็๕es: "
				nLin+=2
				_lImpTit := .f.
			endif
			SA1->(dbSeek(xFilial("SA1") + TRB2->E1_CLIENTE + TRB2->E1_LOJA ))
			@nLin,000 PSAY TRB2->E1_NUM            // Nota Fiscal
			@nLin,010 PSAY TRB2->E1_PREFIXO        // Serie
			@nLin,016 PSAY TRB2->E1_PARCELA        // Parcela
			@nLin,020 PSAY dtoc(TRB2->E1_EMISSAO)  // Data de Emissao
			@nLin,030 PSAY dtoc(TRB2->E1_VENCREA)  // Data de Vencimento
			@nLin,040 PSAY SUBSTRING(alltrim(SA1->A1_NOME),1,20)
			@nLin,061 PSAY SA1->A1_EST
			@nLin,065 PSAY TRB2->E1_VALOR * (-1) Picture "@E 99,999,999.99" // Valor Total Titulo
			@nLin,080 PSAY TRB2->E1_SALDO * (-1) Picture "@E 99,999,999.99" // Valor Saldo em Aberto

			@nLin,098 PSAY TRB2->E3_BASE  Picture "@E 99,999,999.99" // Base Calculo Comissao
			@nLin,115 PSAY TRB2->E3_COMIS Picture "@E 99,999,999.99" // Valor Comissao
			@nLin,132 PSAY dtoc(TRB2->E3_EMISSAO)  // Data de Geracao da Comissao
			@nLin,142 PSAY dtoc(TRB2->E3_DATA)     // Data Pagamento

			if _lGeraCSV 
				_cLinTit := _cCodVen + ";"
				_cLinTit += "'"+TRB2->E1_NUM + ";"
				_cLinTit += "'"+TRB2->E1_PREFIXO + ";"
				_cLinTit += "'"+TRB2->E1_PARCELA + ";" 
				_cLinTit += dtoc(TRB2->E1_EMISSAO) + ";" 
				_cLinTit += dtoc(TRB2->E1_VENCREA) + ";" 
				_cLinTit += SUBSTRING(alltrim(SA1->A1_NOME),1,20) + ";" 
				_cLinTit += SA1->A1_EST + ";"
				_cLinTit += transform(TRB2->E1_VALOR * (-1), "@E 99,999,999.99") + ";" 
				_cLinTit += transform(TRB2->E1_SALDO * (-1), "@E 99,999,999.99") + ";"
				_cLinCom := ""
				_cLinCom += transform(TRB2->E3_BASE, "@E 99,999,999.99")+ ";"
				_cLinCom += transform(TRB2->E3_COMIS, "@E 99,999,999.99")+ ";"
				_cLinCom += dtoc(TRB2->E3_DATA)+ ";"
				_cLinINF := ";;;;;;"
			endif

			SD1->(dbSetOrder(1))  // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
			if SD1->(dbSeek(xFilial("SD1") + TRB2->E1_NUM + TRB2->E1_PREFIXO + TRB2->E1_CLIENTE + TRB2->E1_LOJA ))

				_cLinINF := ""
				while SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == TRB2->E1_NUM .and. ;
					  SD1->D1_SERIE == TRB2->E1_PREFIXO .and. SD1->D1_FORNECE == TRB2->E1_CLIENTE .and. SD1->D1_LOJA == TRB2->E1_LOJA

					if SD2->(dbSeek(xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI ))
					
						@nLin,154 PSAY SD1->D1_COD   							  		// Codigo Produto
						@nLin,170 PSAY SD2->D2_PEDIDO  								// Numero Pedido 
						@nLin,178 PSAY SD2->D2_ITEMPV  								// Item Pedido
						@nLin,182 PSAY SD1->D1_TOTAL * (-1) Picture "@E 99,999,999.99"  	// Valor Mercadoria
						SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO ))
						if SC5->C5_VEND1 == _cCodVen
							_nPcComDev := SD2->D2_COMIS1
						elseif SC5->C5_VEND2 == _cCodVen
							_nPcComDev := SD2->D2_COMIS2
						elseif SC5->C5_VEND3 == _cCodVen
							_nPcComDev := SD2->D2_COMIS3
						elseif SC5->C5_VEND4 == _cCodVen
							_nPcComDev := SD2->D2_COMIS4
						elseif SC5->C5_VEND5 == _cCodVen
							_nPcComDev := SD2->D2_COMIS5
						else
							_nPcComDev := 0
						endif
						@nLin,200 PSAY _nPcComDev 	Picture "@E 999.99"         	// Percentual Comissao
						@nLin,207 PSAY round(SD1->D1_TOTAL * _nPcComDev * (-1) / 100,2) Picture "@E 99,999,999.99" // Valor Comissao
						_nTValMerc += SD1->D1_TOTAL * (-1)
						_nTValCom2 += round(SD1->D1_TOTAL * _nPcComDev * (-1) / 100,2)
						nLin++
						if _lGeraCSV  
						     If nLin > 55 
	                          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	                           nLin := iif(empty(cabec2),8,9)
                             Endif
							_cLinINF   += SD1->D1_COD+ ";"
							_cLinINF   += SD2->D2_PEDIDO+ ";"
							_cLinINF   += "'"+SD2->D2_ITEMPV+ ";"
							_cLinINF   += transform(SD1->D1_TOTAL * (-1),"@E 99,999,999.99") + ";"
							_cLinINF   += transform(_nPcComDev,"@E 999.99") + ";"
							_cLinINF   += transform(round(SD1->D1_TOTAL * _nPcComDev * (-1) / 100,2),"@E 99,999,999.99") + ";"
							_cLinha  := _cLinTit + _cLinCom + _cLinINF + cEOL
							_cLinINF := ""
							_cLinCom := ";;;"
							If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
								If !apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
									Exit
								Endif
							Endif
						endif
					endif

					SD1->(dbSkip())

				enddo
			else
				nLin++
				if _lGeraCSV
					_cLinha  := _cLinTit + _cLinCom + _cLinINF + cEOL
					If fWrite(nHdl,_cLinha,Len(_cLinha)) != Len(_cLinha)
						If !apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
							Exit
						Endif
					Endif
				endif
			endif
			@nLin,000 PSAY Replicate("-",220)
			nLin++
			_nTBCCom  += TRB2->E3_BASE
			_nTValCom += TRB2->E3_COMIS
			_nTValTit += TRB2->E1_VALOR * (-1)
			_nTSalTit += TRB2->E1_SALDO * (-1)

			TRB2->(dbSkip())

		enddo

		// Imprime totais do Vendedor
		nLin++
		@nLin,064 PSAY Replicate("=",14)
		@nLin,080 PSAY Replicate("=",14)
		@nLin,097 PSAY Replicate("=",14)
		@nLin,114 PSAY Replicate("=",14)
		@nLin,181 PSAY Replicate("=",14)
		@nLin,207 PSAY Replicate("=",14)
		nLin++
		@nLin,000 PSAY "Total do Vendedor: " + alltrim(_cCodVen) + " - " + alltrim(Posicione("SA3",1,xFilial("SA3") + _cCodVen, "A3_NOME"))
		@nLin,065 PSAY _nTValTit  Picture "@E 99,999,999.99" // Valor Total Titulos
		@nLin,080 PSAY _nTSalTit  Picture "@E 99,999,999.99" // Saldo em Aberto Titulos
		@nLin,098 PSAY _nTBCCom   Picture "@E 99,999,999.99" // Base Calculo Comissao
		@nLin,115 PSAY _nTValCom  Picture "@E 99,999,999.99" // Valor Comissao
		@nLin,182 PSAY _nTValMerc Picture "@E 99,999,999.99" // Valor Mercadoria
		@nLin,207 PSAY _nTValCom2 Picture "@E 99,999,999.99" // Valor Comissao Calculado pelos itens da NF
		nLin++
		_nTValTit := _nTSalTit := _nTBCCom := _nTValCom := _nTValMerc := _nTValCom2 := 0

	endif

next x

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fClose(nHdl)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFIN02   บAutor  ณMicrosiga           บ Data ณ  09/30/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ExecQry()

local _cQuery := ""
local CR := chr(13) + chr(10)

if select("TRB1") > 0
	TRB1->(dbCloseArea())
endif

_cWhere := CR + " WHERE  SE1.E1_FILIAL = '"+xFilial("SE1")+"' " 
_cWhere += CR + "        AND SE1.E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' " 
_cWhere += CR + "        AND SE1.E1_VENCREA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' " 
_cWhere += CR + "        AND SE1.E1_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' " 
_cWhere += CR + "        AND SE1.E1_LOJA    BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' " 
_cWhere += CR + "        AND SE1.E1_PEDIDO  BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' " 
_cWhere += CR + "        AND SE1.D_E_L_E_T_ = ' '  " 

_cQuery += CR + " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCREA,  " 
_cQuery += CR + "        SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_PEDIDO, SE1.E1_VALOR, SE1.E1_SALDO,  " 
_cQuery += CR + "        SE1.E1_VEND1 CODVEND, IDVEND = 1 " 
_cQuery += CR + " FROM   "+RetSqlName("SE1")+" AS SE1 (nolock)  " 
_cQuery += CR + _cWhere
_cQuery += CR + "        AND SE1.E1_VEND1 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SE1.E1_VEND1 <> '' " 
_cQuery += CR + " UNION ALL " 
_cQuery += CR + " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCREA,  " 
_cQuery += CR + "        SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_PEDIDO, SE1.E1_VALOR, SE1.E1_SALDO,  " 
_cQuery += CR + "        SE1.E1_VEND2 CODVEND, IDVEND = 2 " 
_cQuery += CR + " FROM   "+RetSqlName("SE1")+" AS SE1 (nolock)  " 
_cQuery += CR + _cWhere
_cQuery += CR + "        AND SE1.E1_VEND2 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SE1.E1_VEND2 <> '' " 
_cQuery += CR + " UNION ALL " 
_cQuery += CR + " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCREA,  " 
_cQuery += CR + "        SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_PEDIDO, SE1.E1_VALOR, SE1.E1_SALDO,  " 
_cQuery += CR + "        SE1.E1_VEND3 CODVEND, IDVEND = 3 " 
_cQuery += CR + " FROM   "+RetSqlName("SE1")+" AS SE1 (nolock)  " 
_cQuery += CR + _cWhere
_cQuery += CR + "        AND SE1.E1_VEND3 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SE1.E1_VEND3 <> '' " 
_cQuery += CR + " UNION ALL " 
_cQuery += CR + " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCREA,  " 
_cQuery += CR + "        SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_PEDIDO, SE1.E1_VALOR, SE1.E1_SALDO,  " 
_cQuery += CR + "        SE1.E1_VEND4 CODVEND, IDVEND = 4 " 
_cQuery += CR + " FROM   "+RetSqlName("SE1")+" AS SE1 (nolock)  " 
_cQuery += CR + _cWhere
_cQuery += CR + "        AND SE1.E1_VEND4 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SE1.E1_VEND4 <> '' " 
_cQuery += CR + " UNION ALL " 
_cQuery += CR + " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCREA,  " 
_cQuery += CR + "        SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SE1.E1_PEDIDO, SE1.E1_VALOR, SE1.E1_SALDO,  " 
_cQuery += CR + "        SE1.E1_VEND5 CODVEND, IDVEND = 5 " 
_cQuery += CR + " FROM   "+RetSqlName("SE1")+" AS SE1 (nolock)  " 
_cQuery += CR + _cWhere
_cQuery += CR + "        AND SE1.E1_VEND5 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SE1.E1_VEND5 <> '' " 
_cQuery += CR + " ORDER BY SE1.E1_FILIAL, CODVEND, E1_VENCREA, E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA  " 

//memowrite("RFIN02.SQL",_cQuery)
_cQuery := strtran(_cQuery,CR,"")
_cQuery := CHANGEQUERY(_cQuery)
TcQuery _cQuery ALIAS TRB1 NEW

TcSetField("TRB1", "E1_EMISSAO", "D", 8, 0)
TcSetField("TRB1", "E1_VENCREA", "D", 8, 0)

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN02    บAutor  ณMicrosiga           บ Data ณ  10/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ExecDev(_cCodVend)

local _cQryDev := ""

if select("TRB2") > 0
	TRB2->(dbCloseArea())
endif

_cQryDev += " SELECT E3_VEND, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_EMISSAO,E3_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_TIPO, "
_cQryDev += "        E3_BASE, E3_PORC, E3_COMIS, E3_VENCTO, E3_DATA "
_cQryDev += " FROM   "+RetSqlName("SE1")+" AS E1 (nolock) "
_cQryDev += " JOIN   "+RetSqlName("SE3")+" AS E3 (nolock) "
_cQryDev += " ON     E3_FILIAL = E1_FILIAL AND E3_PREFIXO = E1_PREFIXO AND E3_NUM = E1_NUM AND E3.D_E_L_E_T_ = '' "
_cQryDev += " WHERE  E1.D_E_L_E_T_ = '' "
_cQryDev += "        AND E1_FILIAL = '"+xFilial("SE1")+"' "
_cQryDev += "        AND E1_TIPO   = 'NCC' "
_cQryDev += "        AND E1.E1_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' " 
_cQryDev += "        AND E1.E1_VENCREA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' " 
_cQryDev += "        AND E1.E1_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' " 
_cQryDev += "        AND E1.E1_LOJA    BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' " 
_cQryDev += "        AND E3.E3_VEND = '"+_cCodVend+"' "
_cQryDev += " ORDER  BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA "

//memowrite ("LUIZ.SQL",_cQryDev)
_cQryDev := CHANGEQUERY(_cQryDev)
TcQuery _cQryDev ALIAS TRB2 NEW

TcSetField("TRB2", "E1_EMISSAO", "D", 8, 0)
TcSetField("TRB2", "E1_VENCREA", "D", 8, 0)
TcSetField("TRB2", "E3_VENCTO" , "D", 8, 0)
TcSetField("TRB2", "E3_DATA"   , "D", 8, 0)
TcSetField("TRB2", "E3_EMISSAO", "D", 8, 0)

TRB2->(dbGoTop())

return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria perguntas no SX1                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local i,j
Local _sAlias := Alias()
Local aRegs   := {}

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
AAdd(aRegs,{cPerg,"01","Do Vendedor         ?",".?",".?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"02","Ate Vendedor        ?",".?",".?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Da  Emissใo         ?",".?",".?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"04","Ate Emissใo         ?",".?",".?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"05","Do Vencimento       ?",".?",".?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"06","Ate Vencimento      ?",".?",".?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"07","Data Comissao de    ?",".?",".?","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"08","Data Comissao ate   ?",".?",".?","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"09","Do  Cliente         ?",".?",".?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"10","Ate Cliente         ?",".?",".?","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"11","Da Loja             ?",".?",".?","mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"12","Ate Loja            ?",".?",".?","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"13","Do  Pedido          ?",".?",".?","mv_chd","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"14","Ate Pedido          ?",".?",".?","mv_che","C",06,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"15","Somente Baixados    ?",".?",".?","mv_chf","N",01,0,0,"C","","mv_par15","Sim","","","","","Nใo","","","","","Ambos","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"16","Gera Excel          ?",".?",".?","mv_chg","N",01,0,0,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"17","Comissao Pagas      ?",".?",".?","mv_chh","N",01,0,0,"C","","mv_par17","Sim","","","","","Nใo","","","","","Ambos","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"18","Do  Armazem         ?",".?",".?","mv_chi","C",02,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"19","Ate Armazem         ?",".?",".?","mv_chj","C",02,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(len(SX1->X1_GRUPO)-LEN(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN02    บAutor  ณMicrosiga           บ Data ณ  10/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ImpCabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)

If nLin > 55 .or. _cCodVen <> _aComiss[x,1]
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := iif(empty(cabec2),8,9)
Endif

return(nLin)