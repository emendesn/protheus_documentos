#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Etqarma3 บAutor  ณ Luciano Siqueira   บ Data ณ 18/10/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para impressao da etiqueta de Armazenagem         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Etqarma3()

Local nX
Local _aLin := {10,20,30,40,50,60,70,80,90,100,110}
Local _aCol := {03,06,40}  //05,30
Local cPorta	:= "LPT1"

Private cPerg		:= "ETARM3"
Private _aEtiquet   := {}
Private _cMaster	:= ""

u_GerA0003(ProcName())

ValPerg(cPerg) // Ajusta as Perguntas do SX1
If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	Return()
Endif

If !IsPrinter(cPorta)
	apMsgStop("Impressora nใo encontrada na porta LPT1!")
	Return
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQry := " SELECT ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFEDT, ZZ4_NFENR, ZZ4_NFESER,ZZO_REFGAR,
cQry += " ZZ4_CODPRO,ZZ4_LOCAL, ZZ4_ENDES,ZZ4_FIFO,COUNT(*) AS QTDREG "
cQry += " FROM " + RetSQlName("ZZO") + " ZZO(NOLOCK), "+ RetSQlName("ZZ4") + " ZZ4(NOLOCK) "
cQry += " WHERE ZZO.D_E_L_E_T_ = '' "
cQry += " AND ZZO_FILIAL='"+xFilial("ZZO")+"' "
cQry += " AND ZZO_NUMCX BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQry += " AND ZZO_STATUS = '2' "
cQry += " AND ZZ4_FILIAL='"+xFilial("ZZ4")+"' "
cQry += " AND ZZ4_IMEI=ZZO_IMEI "
cQry += " AND ZZ4_CARCAC=ZZO_CARCAC "
cQry += " AND ZZ4_ETQMEM=ZZO_NUMCX "
cQry += " AND ZZ4_DOCSEP='' "
cQry += " AND ZZ4_STATUS='3' "
cQry += " AND ZZ4_ENDES BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQry += " AND ZZ4.D_E_L_E_T_ ='' "
cQry += " GROUP BY ZZ4_CODCLI,ZZ4_LOJA,ZZ4_NFEDT, ZZ4_NFENR, ZZ4_NFESER,"
cQry += " ZZ4_CODPRO,ZZ4_LOCAL, ZZ4_ENDES,ZZ4_FIFO,ZZO_REFGAR "

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "QRY", .F., .T.)

TcSetField("QRY","ZZ4_NFEDT","D",10,0)

dbSelectArea("QRY")
dbGoTop()

If QRY->(EOF())
	apMsgStop("Etiqueta Master nใo Encontrada!")
	Return
Else
	While QRY->(!EOF())
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+QRY->ZZ4_CODCLI+QRY->ZZ4_LOJA)
		
		AADD(_aEtiquet,{QRY->ZZ4_CODPRO,QRY->ZZ4_NFENR,QRY->ZZ4_NFESER,QRY->ZZ4_LOCAL,;
		DTOC(QRY->ZZ4_NFEDT),QRY->ZZ4_FIFO,SA1->A1_EST,QRY->QTDREG,QRY->ZZ4_ENDES,QRY->ZZO_REFGAR,ZZ4->ZZ4_ETQMEM})
		
		dbSelectArea("QRY")
		dbSkip()
	EndDo
Endif



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura da Matriz                                                         ณ
//ณ 01 - ARMAZEM                                                                ณ
//ณ 02 - LOTE                                                                   ณ
//ณ 03 - ORIGEM                                                                 ณ
//ณ 04 - MODELO                                                                 ณ
//ณ 05 - NFE ENTRADA                                                            ณ                                                                 ณ
//ณ 06 - SERIE NFE                                                              ณ
//ณ 07 - DATA ENTRADA                                                           ณ
//ณ 08 - QUANTIDADE PROD POR CAIXA                                              |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Etiqueta                              ณ
//ณ ฺ--------------- 100 mm -----------------------ฟณ
//ณ |  NOTA ENTRADA : XXXXXXXXX  SERIE : XXX      | ณ
//ณ |  MODELO : XXXXXXXXXXXXXXX                 144ณ
//ณ |  ARMAZEM : XX                               mmณ
//ณ |  ORIGEM  : XX                               ณ ณ
//ณ |  LOTE    : XXXXXXX                          ณ ณ
//ณ |  QTDE CAIXA : 999                           ณ ณ
//ณ ภ---------------------------------------------ู ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MSCBPRINTER("ELTRON","LPT1",,022,.F.,,,,,,.T.)
MSCBPRINTER("Z90XI",cPorta,,144,.F.,,,,,,.T.)

//_aEtiquet:={}
//AADD(_aEtiquet,{'XXXXXXXXXXXXXXX','999999999','999','10',DATE(),'YYYYYYY','SP',300})

If Len(_aEtiquet) > 0
	For nX := 1 to Len(_aEtiquet)
		
		MSCBBEGIN(1,6,144)
		
		// Alimenta variaveis
		_cModelo  := Alltrim(_aEtiquet[nX, 1])
		_cNFNum   := Alltrim(_aEtiquet[nX, 2])
		_cNFSer   := Alltrim(_aEtiquet[nX, 3])
		_carmaz   := Alltrim(_aEtiquet[nX, 4])
		_cDtEntr  := Alltrim(_aEtiquet[nX, 5])
		_clote    := Alltrim(_aEtiquet[nX, 6])
		_corigem  := Alltrim(_aEtiquet[nX,7])
		_cqtdecx  := STRZERO(_aEtiquet[nX,8],3)
		_cEndEs   := Alltrim(_aEtiquet[nX,9])
		_cRefGar  := Alltrim(_aEtiquet[nX,10])
		_cMaster  := Alltrim(_aEtiquet[nX,11])
		
		_cOperacao := ""
		
		If _cRefGar = '1'
			_cOperacao := "REFURBISH GARANTIA"
		ElseIf _cRefGar = '2'
			_cOperacao := "FORA DE GARANTIA"
		ElseIf _cRefGar = '3'
			_cOperacao := "REPARO GARANTIA"
		ElseIf _cRefGar = '4'
			_cOperacao := "BOUNCE"
		ElseIf _cRefGar = '5'
			_cOperacao := "PRATA"
		Endif
		
		
		MSCBBOX(004,007,087,130,4)
		
		MSCBBOX(056,007,087,030,4)
				
		MSCBSAY(060,010 ,_cLote  ,"N","0","090,090")  // Coluna 1 - Linha 2
		
		MSCBSAY(058,020 ,_cOperacao  ,"N","0","035,035")  // Coluna 1 - Linha 2
		
		MSCBSAY(_aCol[2],_aLin[1] ,"ARMAZEM : " + _carmaz ,"N","0","070,070")  // Coluna 1 - Linha 1
		MSCBSAY(_aCol[2],_aLin[2] ,"LOTE    : " + _cLote  ,"N","0","070,070")  // Coluna 1 - Linha 2
		MSCBSAY(_aCol[2],_aLin[3] ,"ORIGEM  : " + _cOrigem,"N","0","070,070")  // Coluna 1 - Linha 3
		MSCBSAY(_aCol[2],_aLin[4] ,"MODELO  : " + _cModelo,"N","0","070,070")  // Coluna 1 - Linha 4
		MSCBSAY(_aCol[2],_aLin[5] ,"ENTRADA : " +_cDtEntr ,"N","0","070,070")  // Coluna 1 - Linha 5
		MSCBSAY(_aCol[2],_aLin[6] ,"NFE     : " + _cNFNum ,"N","0","070,070")  // Coluna 1 - Linha 6
		MSCBSAY(_aCol[2],_aLin[7] ,"SERIE   : " + _cNFSer ,"N","0","070,070")  // Coluna 1 - Linha 7
		MSCBSAY(_aCol[2],_aLin[8] ,"QTDE CX : " + _cqtdecx,"N","0","065,065")  // Coluna 1 - Linha 8
		MSCBSAY(_aCol[2],_aLin[9],"Endereco: " + _cEndEs ,"N","0","065,065")  // Coluna 1 - Linha 8
		MSCBSAY(_aCol[2],_aLin[10] ,"Master  : " + _cMaster,"N","0","065,065")  // Coluna 1 - Linha 8
		
		MSCBSAYBAR(_aCol[3],_aLin[11],_cMaster,"N","MB07",08,.F.,.F.,.F.,,2,1)
		
		MSCBEND()
		
	Next nX
Endif


MSCBCLOSEPRINTER()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณLuciano Siqueira    บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPerguntas                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Master De    ?','' ,'' , 'mv_ch1', 'C', 20, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Master Ate   ?','' ,'' , 'mv_ch2', 'C', 20, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Endereco De  ?','' ,'' , 'mv_ch3', 'C', 20, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Endereco Ate ?','' ,'' , 'mv_ch4', 'C', 20, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')

Return
