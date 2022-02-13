#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHPDCLI³ Autor ³ Luciano Siqueira      ³ Data ³ 09/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerar pedido de Venda com base nos parametros informados    ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BGHPDCLI()

Private cPerg		:= "BHPDCLI"
//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015
Private cNextSp		:= GetMv("MV_NEXTSP")
Private cNextRj     := GetMv("MV_NEXTRJ")

ValidPerg() // Ajusta as Perguntas do SX1
If Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
	MsAguarde({|| MOSTNF()},OemtoAnsi("Processando..."))
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MOSTNF    ³ Autor ³ Luciano Siqueira    ³ Data ³ 09/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra Notas de Entrada para seleção e Geração dos Pedidos  ±±
±±³          ³ de Venda                            						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MOSTNF()

Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca 	:= 0 //Opcao da confirmacao
Local _cArqEmp	:= "" //Arquivo temporario com as empresas a serem escolhidas
Local _aBrowse 	:= {} //array do browse para demonstracao das empresas
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 	:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local aButtons  := {}
Local _aStruTrb	:= {;
{"OK"		, "C", 02, 0},;
{"NF"		, "C", TamSX3("F1_DOC")[1],0},;
{"SERIE" 	, "C", TamSX3("F1_SERIE")[1],0}}

Private lInverte:= .F. //Variaveis para o MsSelect
Private cMarca 	:= GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect
Private oDlg

Private dDtDe	:= MV_PAR01
Private dDtAte	:= MV_PAR02
Private cDocDe	:= MV_PAR03
Private cDocAte	:= MV_PAR04
Private cSerDe	:= MV_PAR05
Private cSerAte	:= MV_PAR06
Private cFornece:= MV_PAR07
Private cLoja	:= MV_PAR08
Private cTES	:= MV_PAR09

AADD(_aBrowse,{"OK"		,,	""})
AADD(_aBrowse,{"NF"	,,	"Nota Fiscal"})
AADD(_aBrowse,{"SERIE"	,,	"Serie"})

If Select("fMark") > 0
	fMark->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)

dbUseArea(.T.,__LocalDriver,_cArqEmp,"fMark")

//Aqui você monta sua query que serve para gravar os dados no arquivo temporario...
cQuery := " SELECT F1_DOC, F1_SERIE "
cQuery += " FROM "+ RETSQLNAME("SF1")+" SF1 (nolock) "
cQuery += " WHERE "
cQuery += " F1_FILIAL = '"+xFilial("SF1")+"' "
cQuery += " AND F1_DTDIGIT BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "
cQuery += " AND F1_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "
cQuery += " AND F1_SERIE BETWEEN '"+cSerDe+"' AND '"+cSerAte+"' "
cQuery += " AND F1_FORNECE = '"+cFornece+"' "
cQuery += " AND F1_LOJA = '"+cLoja+"' "
cQuery += " AND SF1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY F1_DOC,F1_SERIE "

TCQuery cQuery new Alias (cAlias:=GetNextAlias())

dbSelectArea(cAlias)
dbGotop()
If (cAlias)->(!Eof())
	While (cAlias)->(!Eof())
		RecLock("fMARK",.T.)
		fMark->OK		:= cMarca
		fMark->NF	 	:= (cAlias)->F1_DOC
		fMark->SERIE 	:= (cAlias)->F1_SERIE
		fMARK->(MSUNLOCK())
		(cAlias)->(DbSkip())
	Enddo
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
	nGetLin := aPosObj[3,1]
	
	DEFINE MSDIALOG oDlg TITLE "Gera Pedido de Vendas" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	oBrwTrb := MsSelect():New("fMARK","OK","",_aBrowse,@lInverte,@cMarca,{005,005,420,900})
	
	oBrwTrb:oBrowse:lHasMark    := .t.
	oBrwTrb:oBrowse:lCanAllMark := .t.
	Eval(oBrwTrb:oBrowse:bGoTop)
	oBrwTrb:oBrowse:bAllMark := { || MarcaIte(1) }
	oBrwTrb:oBrowse:bLDblClick:={||MarcaIte(2)}
	oBrwTrb:oBrowse:Refresh()
	
	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered VALID _lRetorno
	
	fMark->(DbGotop())
	
	If _nOpca == 1
		If ApMsgYesNo('Deseja gerar Pedido de Venda?','Pedido de Venda')
			MsAguarde({|| GERATRB()},OemtoAnsi("Filtrando Dados..."))
		Endif
	Endif
Else
	MsgAlert("Não existem dados para processamento.")
Endif

(cAlias)->(DbCloseArea())

//fecha area de trabalho e arquivo temporário criados
If Select("fMARK") > 0
	DbSelectArea("fMARK")
	DbCloseArea()
	Ferase(_cArqEmp+OrdBagExt())
Endif


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MarcaIte  ³ Autor ³ Luciano Siqueira    ³ Data ³ 09/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marcar Itens                                                ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MarcaIte(nOpc)

If nOpc == 1 // Marcar todos
	fMark->(DbGotop())
	Do While fMark->(!EOF())
		RecLock("fMark",.F.)
		fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
		fMark->(MsUnlock())
		fMark->(DbSkip())
	Enddo
	dbGoTop()
Elseif nOpc == 2  // Marcar somente o registro posicionado
	RecLock("fMark",.F.)
	fMark->OK := Iif(fMark->OK==cMarca,"",cMarca)
	MsUnLock()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAPV    ºAutor  ³Luciano Siqueira    º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Pedidos de Venda e NF de Saida                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GERATRB()

Local aArea  	:= GetArea()
Local _aStru	:= {;
{"CLIENTE"	, "C", TamSX3("A1_COD")[1],0},;
{"LOJA" 	, "C", TamSX3("A1_LOJA")[1],0},;
{"NF"		, "C", TamSX3("D1_DOC")[1],0},;
{"SERIE" 	, "C", TamSX3("D1_SERIE")[1],0},;
{"ITEM" 	, "C", TamSX3("D1_ITEM")[1],0},;
{"PRODUTO"	, "C", TamSX3("B1_COD")[1],0},;
{"LOCAL"	, "C", TamSX3("B2_LOCAL")[1],0},;
{"OPEBGH"	, "C", TamSX3("ZZ4_OPEBGH")[1],0},;
{"OS"		, "C", TamSX3("ZZ4_OS")[1],0},;
{"IMEI" 	, "C", TamSX3("ZZ4_IMEI")[1],0},;
{"VLRUNI"   , "N", TamSX3("C6_VALOR") [1],4}}

Private cFilMDes := Alltrim(GetMv("MV_MUDFDES",.F.,"02")) 

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

_cChaveInd	:= "CLIENTE+LOJA+NF+SERIE"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

dbSelectArea("fMark")
dbGotop()
If fMark->(!EOF())
	While fMark->(!EOF())
		If !EMPTY(fMark->OK)
			cQuery := " SELECT ZZ4_CODPRO,ZZ4_LOCAL,ZZ4_OPEBGH,ZZ4_IMEI,ZZ4_OS,ZZ4_VLRUNI,ZZ4_CHVFIL  "
			cQuery += " FROM "+RETSQLNAME("ZZ4")+" ZZ4  "
			cQuery += " WHERE ZZ4.D_E_L_E_T_ <> '*'  "
			cQuery += " AND ZZ4_FILIAL='"+cFilMDes+"' "
			cQuery += " AND ZZ4_NFSNR = '"+fMark->NF+"' "
			cQuery += " AND ZZ4_NFSSER = '"+fMark->SERIE+"' "
			cQuery += " AND ZZ4_CHVFIL <> '' "
			
			If Select("TSQL1") > 0
				TSQL1->(dbCloseArea())
			EndIf
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "TSQL1", .F., .T.)
			
			dbSelectArea("TSQL1")
			TSQL1->(dbGotop())
			While TSQL1->(!Eof())
				dbSelectArea("ZZ4")
				dbSetOrder(1)
				If dbSeek(xFilial("ZZ4")+TSQL1->ZZ4_IMEI+LEFT(TSQL1->ZZ4_CHVFIL,6))//LEFT(TSQL1->ZZ4_OS,6))
					If Empty(ZZ4->ZZ4_GVSARQ)
						RecLock("TRB",.T.)
						TRB->CLIENTE		:= SUBSTR(TSQL1->ZZ4_CHVFIL,7,6)
						TRB->LOJA 		 	:= SUBSTR(TSQL1->ZZ4_CHVFIL,13,2)
						TRB->NF 		 	:= SUBSTR(TSQL1->ZZ4_CHVFIL,15,9)
						TRB->SERIE 		 	:= SUBSTR(TSQL1->ZZ4_CHVFIL,24,3)
						TRB->ITEM 		 	:= SUBSTR(TSQL1->ZZ4_CHVFIL,27,4)
						TRB->PRODUTO 		:= TSQL1->ZZ4_CODPRO
						TRB->LOCAL	 		:= TSQL1->ZZ4_LOCAL
						TRB->OPEBGH 		:= TSQL1->ZZ4_OPEBGH
						TRB->OS		 		:= LEFT(TSQL1->ZZ4_CHVFIL,6)//TSQL1->ZZ4_OS
						TRB->IMEI	 		:= TSQL1->ZZ4_IMEI
						TRB->VLRUNI			:= TSQL1->ZZ4_VLRUNI
						TRB->(MSUNLOCK())
					Endif
				Endif
				TSQL1->(dbSkip())
			EndDo
			If Select("TSQL1") > 0
				TSQL1->(dbCloseArea())
			EndIf
		Endif
		dbSelectArea("fMark")
		dbSkip()
	EndDo
Endif

dbSelectArea("TRB")
dbGoTop()
If !TRB->(EOF())
	MsAguarde({|| GERAPV()},OemtoAnsi("Processando Pedidos de Venda..."))
Else
	MsgAlert("Não existem dados para geração dos Pedidos. Favor verificar!")
Endif

RestArea(aArea)

Return


Static Function GERAPV()

Local nITCham    := 0 		// Contador de Itens do Chamado
Local cItens//     := '01'
Local cChaveOS   := ''

Local _aCabSC5 := {}
Local _aIteSC6 := {}

Local _lRet     :=.t.
Local _nConIMEI := 0  //Conta quantos IMEIS gerado os pedidos - Incluso Edson Rodrigues - 15/04/10
Local _nConPED  := 0  //Conta quantos Pedidos gerados - Incluso Edson Rodrigues - 15/04/10
Local _ncItkit  := 0  //Conta quantos itens de Kit foram gerados no total - Edson Rodrigues 15/04/10
Local  nItkit   := 0  //Conta quantos itens de Kit foram gerados por produto - Edson Rodrigues 15/04/10
Local _nPrcVen  := 0

Private _cMenSC5:= ""
Private aNfOk	:= 	{}
Private aPedido	:= 	{}
Private _cTesEtq:= cTes
Private _cgeraNF   := "N"
Private _cGePeca   := "N"
Private _cSerNF	   := "1"
Private _cMenNota  := "N"
Private _cAglPed   := "N"
Private	_cLayETQ   := ""
Private	_clab      := ""
Private	_ctransp   :=""
Private	_cmenpad   :=""
Private	_cmenpTES  :=""
Private	_cdivneg   :=""
Private	_clibPvS   :="N"
Private	_carmzen   :=""
Private	_cSepEnt  := ""

dbSelectArea("TRB")
dbGoTop()
While !TRB->(EOF())
	
	cChaveOS   := TRB->(CLIENTE+LOJA+NF+SERIE)
	cItens     := '00'
	nContIt    := 0
	_lAltMen   := .f.
	_coperbgh  := alltrim(TRB->OPEBGH)
	_cgerapvpc := "N"
	_cgeraNF   := "N"
	_cGePeca   := "N"
	_cSerNF	   := "1"
	_cMenNota  := "N"
	_cAglPed   := "N"
	_cLayETQ   := ""
	_clab     := ""
	_ctransp  :=""
	_cmenpad  :=""
	_cmenpTES :=""
	_cdivneg  :=""
	_clibPvS  :="N"
	_carmzen  :=""
	_cSepEnt  := ""
	
	dbSelectArea('ZZJ')
	IF ZZJ->(DBSeek(xFilial('ZZJ')+alltrim(TRB->OPEBGH)))
		_coperbgh  := ZZJ->ZZJ_OPERA  // cria variavel da operacao - Edson Rodrigues - 20/03/10
		_cgerapvpc := ZZJ->ZZJ_PVPECA // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
		_cgeraNF   := ZZJ->ZZJ_GERANF // cria variavel de gera NF de Saida sim ou nao - Luciano - 30/04/12
		_cGePeca   :=  ZZJ->ZZJ_GEPECA
		_cSerNF	   := IIF(Alltrim(_coperbgh) $ GetMV("BH_SERI004"),"4","1")
		_cMenNota  := ZZJ->ZZJ_MENNOT // cria variavel de Mensagem para nota sim ou nao - Luciano - 20/05/12
		_cAglPed   := ZZJ->ZZJ_AGLPED // cria variavel de Aglutina Pedidos Venda sim ou nao - Luciano - 17/05/12
		_cLayETQ   := ZZJ->ZZJ_LAYETQ // cria variavel de Layout Etiqueta - Luciano - 17/05/12
		_clab      := ZZJ->ZZJ_LAB    // cria variavel do Laboratorio - Edson Rodrigues - 13/04/10
		_ctransp  := ZZJ->ZZJ_TRANSP
		_cmenpTES :=Posicione("SF4",1,xFilial("SF4") + cTes, "F4_FORMULA")//Alterado conforme solicitação do Carlos - Luciano 10/05/12
		_cmenpad  := IIF(EMPTY(_cmenpTES),ZZJ->ZZJ_MENPAD,_cmenpTES)
		_cdivneg  := ZZJ->ZZJ_DIVNEG
		_clibPvS  := ZZJ->ZZJ_LIBPVS
		_carmzen  := ALLTRIM(ZZJ->ZZJ_ARMENT)
		_cSepEnt  := Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 13/06/2012
	ELSE
		ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+TRB->OS+" e IMEI "+TRB->IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
		TRB->(dbSkip())
		loop
	ENDIF
	
	_citlocal := TRB->LOCAL
	_cproduto := TRB->PRODUTO
	
	
	//**********************************************
	//          Geracao dos Cabecalhos             *
	//**********************************************
	//Incluso DBseek no SB1 para buscar o local padrao do produto - Edson Rodrigues - 26/04/07
	SB1->(DBSeek(xFilial('SB1')+_cproduto))
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DBSeek(xFilial('SA1')+TRB->(CLIENTE+LOJA)))
	
	_aCabSC5  := {}
	_aIteSC6  := {}
	_ctransp  := IIF(Empty(_ctransp),SA1->A1_TRANSP,_ctransp)
	_cmenpad  := IIF(Empty(_cmenpad),SA1->A1_MENSAGE,_cmenpad)
	_cdivneg  := IIF(Empty(_cdivneg),'09',_cdivneg)
	_aAreaSC5 := SC5->(GetArea())
	_nConPED++
	
	If _cMenNota == "S"
		If ApMsgYesNo('Informar mensagem para NF?','Mensagem Padrão')
			MENNOTA()
		Endif
	Endif
	
	If Alltrim(_coperbgh) $ UPPER(GetMv("MV_ZZOPTRA"))//    "N04/N07"  &&Incluido para parametrizar operações que podem mudar transportadora na entrada massiva
		If ApMsgYesNo('Deseja informar transportadora?','Transportadora')
			TRANSP()
		Endif
	Endif
	
	_aCabSC5  := {	{"C5_TIPO"		,"N"					,Nil},;
	{"C5_CLIENTE"	,TRB->CLIENTE							,Nil},;
	{"C5_LOJACLI"	,TRB->LOJA								,Nil},;
	{"C5_LOJAENT"	,TRB->LOJA								,Nil},;
	{"C5_TIPOCLI"	,"F"					    			,Nil},;
	{"C5_CONDPAG"	,'001'	   								,Nil},;
	{"C5_TIPLIB"	,'1'	   								,Nil},;
	{"C5_TPCARGA"	,'2'	   								,Nil},;
	{"C5_B_KIT"		,""		   								,Nil},;
	{"C5_XUSER"		,alltrim(cusername)						,Nil},;
	{"C5_TRANSP"    ,_ctransp			                    ,Nil},;
	{"C5_MENPAD"    ,_cmenpad             			        ,Nil},;
	{"C5_DIVNEG"    ,_cdivneg                  				,Nil},;
	{"C5_MENNOTA"	,_cMenSC5      							,Nil}}
	
	
	_cB6Acum   := ""
	_aB6Acum   := {} // Acumula IDENT de poder de terceiros utilizados e calcula saldo disponivel para novos registros - Munhoz 01/11/2011
	_cMenMast  := ""
	DBSelectArea("TRB")
	WHILE (cChaveOS == TRB->(CLIENTE+LOJA+NF+SERIE) ) .and. !TRB->(EOF()) // Nicoletti 17/05/05
		
		_cItemOri := Space(2)
		_citlocal := Space(2) //Edson Rodrigues -- 03/11/08
		_cIdentB6 := Space(6)
		_coperbgh  := alltrim(TRB->OPEBGH)
		_cSepEnt  := ""
		
		dbSelectArea('ZZJ')
		IF ZZJ->(DBSeek(xFilial('ZZJ')+alltrim(TRB->OPEBGH)))
			_coperbgh := ZZJ->ZZJ_OPERA  // cria variavel da operacao - Edson Rodrigues - 20/03/10
			_cgerapvpc:= ZZJ->ZZJ_PVPECA // cria variavel de gera pedido de peças sim ou nao - Edson Rodrigues - 20/03/10
			_cgeraNF   := ZZJ->ZZJ_GERANF // cria variavel de gera NF de Saida sim ou nao - Luciano - 30/04/12
			_cGePeca  :=  ZZJ->ZZJ_GEPECA
			_cSerNF	   := IIF(Alltrim(_coperbgh) $ GetMV("BH_SERI004"),"4","1")
			_cMenNota  := ZZJ->ZZJ_MENNOT // cria variavel de Mensagem para nota sim ou nao - Luciano - 20/05/12
			_cAglPed   := ZZJ->ZZJ_AGLPED // cria variavel de Aglutina Pedidos Venda sim ou nao - Luciano - 17/05/12
			_cLayETQ   := ZZJ->ZZJ_LAYETQ // cria variavel de Layout Etiqueta - Luciano - 17/05/12
			_clab     := ZZJ->ZZJ_LAB    // cria variavel do Laboratorio - Edson Rodrigues - 13/04/10
			_ctransp  := ZZJ->ZZJ_TRANSP
			_cmenpTES :=Posicione("SF4",1,xFilial("SF4") + cTes, "F4_FORMULA")//Alterado conforme solicitação do Carlos - Luciano 10/05/12
			_cmenpad  := IIF(EMPTY(_cmenpTES),ZZJ->ZZJ_MENPAD,_cmenpTES)
			_cdivneg  := ZZJ->ZZJ_DIVNEG
			_clibPvS  := ZZJ->ZZJ_LIBPVS
			_carmzen  :=  ALLTRIM(ZZJ->ZZJ_ARMENT)
			_cSepEnt  := Posicione("ZZJ",1,xFilial("ZZJ") + _coperbgh, "ZZJ_SEPENT")//Incluido conforme solicitação do Edson 13/06/2012
			
		ELSE
			ApMsgInfo("Não foi encontrado a operacao cadastrada para OS "+TRB->OS+" e IMEI "+TRB->IMEI+" no arquivo de Operacoes (ZZJ). Favor cadastrar.","Operacao não localizada!")
			TRB->(dbSkip())
			Loop
		ENDIF
		
		
		_cproduto :=TRB->PRODUTO
		
		SB1->(DBSeek(xFilial('SB1')+_cproduto))
		SF4->(DBSeek(xFilial('SF4')+cTes))
		
		
		
		// Verifica item e IDENTB6 na Nota Fiscal de Entrada para informar nos campos de NF Original no Pedido de Venda
		_lAchouSB6 := .f.
		DbSelectArea("SD1")
		//DbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER
		// Alterado pois assim poderemos ter problema num possível atualizacao da TOTVS - Edson Rodrigues - 08/04/11
		//             SD1->(DBOrderNickName('D1NUMSER')) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_NUMSER
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alterado por M.Munhoz em 16/08/2011 - Posicionar SD1 sem utilizar o D1_NUMSER. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		//		     If SD1->(DbSeek(xFilial('SD1')+(cAliasTop5)->(ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+Substr(ZZ4_IMEI,1,20))) )
		If SD1->(DbSeek(xFilial('SD1')+TRB->(NF+SERIE+CLIENTE+LOJA+PRODUTO+ITEM)) )
			
			// Identifico o IDENTB6 do item que esta sendo retornado
			If SD1->D1_ITEM == TRB->ITEM  //M.Munhoz 16/08/2011
				_cItemOri := SD1->D1_ITEM
				_cIdentB6 := SD1->D1_IDENTB6
				_citlocal := SD1->D1_LOCAL
			EndIf
			
			// Verifica primeiro a matriz de saldos de terceiros // Munhoz 01/11/2011
			_nPosTerc := aScan(_aB6Acum, { |X| X[1] == _cIdentB6 })
			if _nPosTerc > 0 .and. _aB6Acum[_nPosTerc,2] >= 1
				_lAchouSB6 := .t.
				_aB6Acum[_nPosTerc,2] := _aB6Acum[_nPosTerc,2] - 1
			else
				
				// Verifico se o IDENTB6 encontrado possui saldo na tabela SB6 (primeira pesquisa no SB6 pelo IDENT correto do SD1)
				SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFOR + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
				If _nPosTerc == 0 .and. SB6->(dbSeek(xFilial('SB6') + TRB->(SERIE + NF + CLIENTE + LOJA) + _cIdentB6 + TRB->PRODUTO + "R")) .AND. SD1->(!eof())  //M.Munhoz 16/08/2011
					
					// Calculo saldo disponivel de Terceiros
					IF SB6->B6_SALDO > 0
						_nSalP3  := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
					ELSE
						_nSalP3  := 0
					ENDIF
					if _nSalP3 >= 1
						_lAchouSB6 := .t.
						aAdd(_aB6Acum, {SB6->B6_IDENT, _nSalP3 - 1 }) // Calcula saldo disponivel (B6_SALDO - PVs em aberto) e desconta 1 do item processado neste momento
					endif
					
					//else Retirado esse Else e acrescentado o endif / If para fazer validacao quando o produto não tiver saldo pelo ident e tiver que buscar pela nota - Edson Rodrigues 09/11/11
				Endif
				
				If 	 !_lAchouSB6
					// Se o IDENTB6 nao estiver na matriz e nao for encontrado no SB6 ou nao possuir saldo, procuro pelo primeiro item da NF com mesmo produto no SB6 com saldo maior que 1
					SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFOR + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
					IF SB6->(dbSeek(xFilial('SB6') + TRB->(SERIE + NF + CLIENTE + LOJA) ))
						
						While SB6->(!eof()) .and. SB6->B6_FILIAL == xFilial("SB6") .and. ;
							SB6->B6_SERIE  == TRB->SERIE  .and. SB6->B6_DOC  == TRB->NF .and. ;
							SB6->B6_CLIFOR == TRB->CLIENTE .and. SB6->B6_LOJA == TRB->LOJA
							
							_nPosTerc := aScan(_aB6Acum, { |X| X[1] == SB6->B6_IDENT })
							If _nPosTerc == 0 .and. alltrim(SB6->B6_PRODUTO) == alltrim(TRB->PRODUTO)
								
								If  SB6->B6_SALDO > 0
									_nSalP3 := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
								Else
									_nSalP3 :=  0
								Endif
								
								If _nSalP3 >= 1 .and. SB6->B6_PODER3 == 'R'
									_lAchouSB6 := .t.
									_cItemOri  := ""
									_cIdentB6  := SB6->B6_IDENT
									aAdd(_aB6Acum, {SB6->B6_IDENT, _nSalP3 - 1 }) // Calcula saldo disponivel (B6_SALDO - PVs em aberto) e desconta 1 do item processado neste momento
									exit
								Endif
							ElseIf _nPosTerc > 0 .and. _aB6Acum[_nPosTerc,2] >= 1 .and. alltrim(SB6->B6_PRODUTO) == alltrim(TRB->PRODUTO)//Adicionado para resolver problema de Saldo - Luciano Delta Decisao 08/05/2012
								_lAchouSB6 := .t.
								_cItemOri  := ""
								_cIdentB6  := _aB6Acum[_nPosTerc,1]
								_aB6Acum[_nPosTerc,2] := _aB6Acum[_nPosTerc,2] - 1
								exit
							endif
							SB6->(dbSkip())
							
						Enddo
					Endif
					
				Endif
			Endif
		EndIf
		
		// Se nao encontrou saldo disponivel no SB6, pula item da saida massiva e nao gera PV pra ele
		If !_lAchouSB6
			ApMsgInfo("Não foi possível localizar saldo de terceiros para o IMEI " + TRB->IMEI + ". Por favor, contate RESPONSÁVEL pelo almoxarifado e solicite análise.","Saldo insuficiente de Terceiros")
			TRB->(dbSkip())
		Endif
		
		//Verifica se o saldo total do estoque SB2 é menor que o saldo saldo total disponivel //Desabilitado - Edson Rodrigues
		//_lretsterc:=Sestterc((cAliasTop5)->ZZ4_CODPRO,IIF(EMPTY(_citlocal),SB1->B1_LOCPAD,_citlocal),1)
		_lretsterc:=.t.
		
		
		If !_lretsterc .and. _lAchouSB6  //Incluso variavael _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
			
			If !ApMsgYesNo("Não há saldo disponivel no Estoque(SB2) para atender o estoque de terceiro(SB6) do IMEI/PRODUTO : "+alltrim(TRB->IMEI)+"/"+TRB->PRODUTO+". Há um desbalanceamento de tabelas SB2 X SB6","Deseja Gerar o Pedido de venda para esse IMEI ?")
				TRB->(dbSkip())
				_lAchouSB6:= .f. //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
			Endif
			
		Endif
		
		If _lAchouSB6 //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
			cItens := Soma1(cItens,2)
			
			_cCodPro   := TRB->PRODUTO
			_nPrcVen   := A410Arred(TRB->VLRUNI,"C6_VALOR")
			
			Aadd(_aIteSC6,{	{"C6_ITEM"		,cItens	  ,Nil},;
			{"C6_PRODUTO"	,_cCodPro 				  ,Nil},;
			{"C6_DESCRI"	,SB1->B1_DESC	 		  ,Nil},;
			{"C6_TES"		,cTes					  ,Nil},;
			{"C6_QTDVEN"	,1						  ,Nil},;
			{"C6_QTDLIB"	,iif(_clibPvS='S', 1, 0)  ,Nil},;
			{"C6_NUMSERI"	,TRB->IMEI	  			  ,Nil},;
			{"C6_NUMOS"		,TRB->OS				  ,Nil},;
			{"C6_PRCVEN"	,_nPrcVen    			  ,Nil},;
			{"C6_VALOR"		,_nPrcVen 				  ,Nil},;
			{"C6_PRUNIT"	,0						  ,Nil},;
			{"C6_NFORI"		,TRB->NF				  ,Nil},;
			{"C6_SERIORI"	,TRB->SERIE				  ,Nil},;
			{"C6_ITEMORI"	,_cItemOri                ,Nil},;
			{"C6_IDENTB6"	,_cIdentB6                ,Nil},;
			{"C6_PRCCOMP"	,0                        ,Nil},;
			{"C6_LOCAL"		,_citlocal                ,Nil},;
			{"C6_ENTREG"	,dDataBase				  ,Nil},;
			{"C6_OSGVS"		,""						  ,Nil},;
			{"C6_AIMPGVS"	,""						  ,Nil},;
			{	,                      				  ,Nil} })
			
			
			//VERIFICA NOVAMENTE O ARMAZEM ORIGINAL - EDSON RODRIGUES - 02/12/08
			DbSelectArea("SD1")
			//		       DbSetOrder(12)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER  // M.Munhoz - 16/08/2011
			DbSetOrder(1)       // D1_FILIAL + D1_DOC + D2_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_NUMSER
			If SD1->(DbSeek(xFilial('SD1')+TRB->(NF+SERIE+CLIENTE+LOJA+PRODUTO+ITEM)) )
				//		         	If Substr(SD1->D1_NUMSER,1,20) == substr((cAliasTop5)->ZZ4_IMEI,1,20)  // M.Munhoz - 16/08/2011
				If SD1->D1_ITEM == TRB->ITEM
					_citlocal := SD1->D1_LOCAL
				Else
					If SD1->(DbSeek(xFilial('SD1')+TRB->(NF+SERIE+CLIENTE+LOJA+PRODUTO)) )
						_citlocal := SD1->D1_LOCAL
					Endif
				EndIf
			ENDIF
			
			_citlocal:=IIF(empty(_citlocal),IIF(EMPTY(_carmzen),SB1->B1_LOCPAD,LEFT(_carmzen,2)),_citlocal)
			_nPostran := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_TRANSP" })
			_nPosMens := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_MENPAD" })
			_nPosdivn := Ascan( _aCabSC5 ,{ |x| x[1] == "C5_DIVNEG" })
			
			//Faz algumas validacoes conforme regras acima - Edson 14/04/10
			IF SD1->D1_PICM == 7 .AND. _citlocal=='23' .AND. _aCabSC5[_nPosMens,2]<>'023'
				_aCabSC5[_nPosMens,2]:='023'
				
			ELSEIF SD1->D1_PICM <> 7 .AND. _citlocal=='23' .AND. _aCabSC5[_nPosMens,2]<>'024'
				_aCabSC5[_nPosMens,2]:='024'
				
			ELSEIF _citlocal == '10' .and. cTes == AllTrim(GetMV("MV_TESSAIM")) .AND. (_aCabSC5[_nPosMens,2]<>'002' .OR. _aCabSC5[_nPostran,2]<>'024')
				_aCabSC5[_nPosMens,2]:='002'
				_aCabSC5[_nPostran,2]:='024'
				
			ELSEIF _citlocal == '10' .and. cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. (_aCabSC5[_nPosMens,2]<>'007' .OR. _aCabSC5[_nPostran,2]<>'024')
				_aCabSC5[_nPosMens,2]:='007'
				_aCabSC5[_nPostran,2]:='024'
			//Alterado para Comportar novos Clientes Nextel CD  Uiran Almeida 29.01.2015	
			//Elseif _citlocal == '11' .and. !cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. TRB->CLIENTE =='000680' .and. (_aCabSC5[_nPosMens,2]<>'002' .OR. _aCabSC5[_nPostran,2]<>'024')
 	        Elseif _citlocal == '11' .and. !cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. TRB->CLIENTE $ Alltrim(cNextRj) .and. (_aCabSC5[_nPosMens,2]<>'002' .OR. _aCabSC5[_nPostran,2]<>'024')
				_aCabSC5[_nPosMens,2]:='002'
				_aCabSC5[_nPostran,2]:='024'
//			Elseif _citlocal == '11' .and.  cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. TRB->CLIENTE =='000680' .and. (_aCabSC5[_nPosMens,2]<>'007' .OR. _aCabSC5[_nPostran,2]<>'024')
			Elseif _citlocal == '11' .and.  cTes == AllTrim(GetMV("MV_TESUSAN")) .AND. TRB->CLIENTE $ Alltrim(cNextRj) .and. (_aCabSC5[_nPosMens,2]<>'007' .OR. _aCabSC5[_nPostran,2]<>'024')
				_aCabSC5[_nPosMens,2]:='007'
				_aCabSC5[_nPostran,2]:='024'
			Endif
			
			
			IncProc()
			
			nITCham++
			nContIt++
			_nConIMEI++
			
			TRB->(dbSkip())
			
		Endif
	EndDo
	
	Begin Transaction //Alterado conforme solicitação do Edson - 02/05/12 - Luciano Delta
	// Se existir cabec e itens, gera PV
	IF len(_aCabSC5) > 0 .and. len(_aIteSC6) > 0
		
		_lRet := u_geraPV(_aCabSC5, _aIteSC6, 3)  //Inclusao de novo PV    //Retirado para fixar abaixo gravacao do pedido no prg, 12/10/07 - Edson Rodrigues
		If _lRet
			aadd(aPedido,SC5->C5_NUM)
		Endif
		
		
		// Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RECLOCK, cfe exigido pela BGH em 15/10/2007 - M.Munhoz
		if !_lRet
			_lRet:=.t.
			
			//**********************************************
			//          Geracao dos Cabecalhos             *
			//**********************************************
			SA1->(DBSeek(xFilial('SA1')+_aCabSC5[2,2]+_aCabSC5[3,2]))
			_cCFIni := "0"
			If Subs(SA1->A1_EST,1,2) == "EX"
				_cCFIni := "7"
			ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
				_cCFIni := "6"
			Else
				_cCFIni := "5"
			EndIf
			cNrPV:= GetSxeNum('SC5','C5_NUM')
			
			RecLock('SC5',.T.)
			SC5->C5_FILIAL  := xFilial('SC5')
			SC5->C5_NUM     := cNrPV
			SC5->C5_TIPO    := _aCabSC5[ 1,2]//'N' //Normal
			SC5->C5_CLIENTE := _aCabSC5[ 2,2]
			SC5->C5_LOJACLI := _aCabSC5[ 3,2]
			SC5->C5_CLIENT  := _aCabSC5[ 2,2]
			SC5->C5_LOJAENT := _aCabSC5[ 4,2]
			SC5->C5_TIPOCLI := 'F'   //Consumidor Final
			SC5->C5_CONDPAG := '001' //A VISTA
			SC5->C5_EMISSAO := dDatabase
			SC5->C5_MOEDA   := 1
			SC5->C5_TIPLIB  := '1'   //Liberacao por Pedido
			SC5->C5_TPCARGA := '2'
			SC5->C5_TXMOEDA := 1
			SC5->C5_B_KIT   := _aCabSC5[ 9,2]
			SC5->C5_XUSER   := _aCabSC5[10,2]
			SC5->C5_TRANSP  := _aCabSC5[11,2]
			SC5->C5_MENPAD  := _aCabSC5[12,2]
			SC5->C5_DIVNEG  := _aCabSC5[13,2]
			SC5->C5_MENNOTA := _aCabSC5[14,2]
			MsUnLock('SC5')
			ConfirmSX8()
			
			//**********************************************
			//          Geracao dos Itens                  *
			//**********************************************
			for nX := 1 to len(_aIteSC6)
				SB1->(DBSeek(xFilial('SB1')+_aIteSC6[nX,2,2]))
				SF4->(DBSeek(xFilial('SF4')+_aIteSC6[nX,4,2]))
				RecLock('SC6',.T.)
				SC6->C6_FILIAL := xFilial('SC6')
				SC6->C6_NUM    := cNrPV
				SC6->C6_ITEM   := _aIteSC6[nX,1,2]
				SC6->C6_PRODUTO:= _aIteSC6[nX,2,2]
				SC6->C6_UM     := SB1->B1_UM
				SC6->C6_QTDVEN := _aIteSC6[nX,5,2]
				SC6->C6_PRCVEN := _aIteSC6[nX,9,2]
				SC6->C6_VALOR  := _aIteSC6[nX,10,2]
				// SC6->C6_QTDEMP := 1
				SC6->C6_TES    := _aIteSC6[nX,4,2]
				SC6->C6_LOCAL  := _aIteSC6[nX,17,2]
				SC6->C6_LOCALIZ:= _aIteSC6[nX,21,2]
				SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
				SC6->C6_ENTREG := dDataBase
				SC6->C6_DESCRI := SB1->B1_DESC
				SC6->C6_PRUNIT := 0.00
				SC6->C6_NFORI  := _aIteSC6[nX,12,2]
				SC6->C6_SERIORI:= _aIteSC6[nX,13,2]
				SC6->C6_ITEMORI:= _aIteSC6[nX,14,2]
				SC6->C6_NUMSERI:= _aIteSC6[nX,7,2]
				SC6->C6_TPOP   := 'F' //FIRME
				SC6->C6_CLI    := _aCabSC5[2,2]
				SC6->C6_LOJA   := _aCabSC5[3,2]
				SC6->C6_IDENTB6:= _aIteSC6[nX,15,2]
				SC6->C6_PRCCOMP:= _aIteSC6[nX,16,2]
				SC6->C6_NUMOS  := _aIteSC6[nX,8,2]
				MsUnLock('SC6')
				
				If _clibPvS='S'//libera item do pedido de venda
					MaLibDoFat(SC6->(RECNO()),_aIteSC6[nX,5,2],@.T.,@.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,_aIteSC6[nX,5,2])
				Endif
				
			next nX
			
			
			apMsgInfo("Tentativa OK !. Pedido gerado com sucesso.")
			
			
		endif
		
	Endif
	
	If !_lRet
		ApMsgInfo("Não foi possível gerar o Pedido de Venda. Favor contatar o administrador do sistema.","Erro na geração do PV!")
		_nConPED :=_nConPED-1
		_nConIMEI:=_nConIMEI-nContIt
		_ncItkit :=_ncItkit-nItkit
	Endif
	
	
	IF _lRet
		For nX := 1 to len(_aIteSC6)
		
			DbSelectArea("SC6")
			_aSavSC6 := GetArea()
			DbSetOrder(1)
			If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM + _aIteSC6[nX,1,2] )) .and. (!empty(_aIteSC6[nX,7,2]) .or. !empty(_aIteSC6[nX,8,2]) )
				reclock("SC6",.f.)
				SC6->C6_NUMSERI := _aIteSC6[nX,7,2]
				SC6->C6_NUMOS   := _aIteSC6[nX,8,2]
				SC6->C6_TES     :=	ctes
				msunlock()
			Endif
			RestArea(_aSavSC6)
			
			DbSelectArea("ZZ4")
			_aSavZZ4 := GetArea()
			DbSetOrder(1)  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
			
			If ZZ4->(dbSeek(xFilial("ZZ4") + _aIteSC6[nX,7,2] + left(_aIteSC6[nX,8,2],8) ))
				RecLock('ZZ4',.F.)
				ZZ4->ZZ4_GVSARQ   := SC5->C5_NUM + SC6->C6_ITEM
				MsUnLock('ZZ4')
			EndIf
			RestArea(_aSavZZ4)
		Next nX
	Endif
	
	End Transaction//Alterado conforme solicitação do Edson - 02/05/12 - Luciano Delta
EndDo


//GERAR NF PARA PEDIDOS LIBERADOS
If _cgeraNF == "S" .and. _clibPvS == "S"
	If ApMsgYesNo('Deseja gerar NF?','Nota Fiscal')
		If _cAglPed == "S"
			If ApMsgYesNo('Aglutinar Pedidos?','Aglutinar Pedidos')
				_cAglPed := "S"
			Else
				_cAglPed := "N"
			Endif
		Endif
		If Len(aPedido) > 0
			GERANF(aPedido,_cAglPed)
			//Imprime Etiqueta com as Notas Fiscais geradas - Luciano 03/05/12
			If len(aNFOK) > 0
				aCliMas:={}
			    For i:=1 to Len(aNfOk)
			    	aEtqMas := {}
			    	nPos 	:= aScan(aCliMas, { |X| X[1] == aNfOk[i,1] })
				    If nPos == 0 
				    	cCliMas:= aNfOk[i,1]
				    	aAdd(aCliMas, {aNfOk[i,1]})
				    	_cNumEtq:= GETSXENUM('SF2','F2_XNUMETQ')
						ConfirmSX8()
			    		For j:=1 to Len(aNfOk)
			    			If aNfOk[j,1]==cCliMas
			    				dbSelectArea("SF2")
			    				dbSetOrder(2)
			    				If dbSeek(xFilial("SF2")+aNfOk[j,1]+aNfOk[j,3]+aNfOk[j,2])
			    					RecLock("SF2",.F.)
									SF2->F2_XNUMETQ := _cNumEtq
									SF2->(MsUnlock())
			    					aADD(aEtqMas,{aNfOk[j,2],aNfOk[j,3],_cNumEtq})
			    				Endif
			    			Endif
			    		Next j
			    		If Len(aEtqMas) > 0
			    			aAreaEtq:= GetArea()
			    			U_BGHETQNF(aEtqMas,_cTesEtq,_cLayETQ)
			    			RestArea(aAreaEtq)
			    		Endif
			    	Endif
			    Next i
			Endif
		Endif
	Endif
Endif


If len(_aIteSC6) == 0
	//	Aviso('Pedidos de Venda','Não existe Pedido de venda gerado!',{'OK'})
Elseif !_lRet .and. _nConPED=0
	Aviso('Pedidos Saida','Não foi possível gerar nenhum Pedidos de Saida!',{'OK'})
Else
	IF _ncItkit > 0
		Aviso('Pedidos Saida','Foram Gerados '+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis .",{'OK'})
	Else
		Aviso('Pedidos Saida','Foram Gerados '+STRZERO(_nConPED,3)+" Pedidos de Saida e "+STRZERO(_nConIMEI,4)+" Imeis e "+STRZERO(_ncItkit,3)+"  .",{'OK'})
	Endif
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SalDisP3  ºAutor  ³Microsiga           º Data ³  09/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular saldo disponivel de Terceiros.        º±±
±±º          ³ Desconta PV abertos do SB6->B6_SALDO                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function SalDisP3(_cIdent, _nSalSB6)

local _aAreaSC6  := SC6->(GetArea())
local _nSalDisP3 := _nQtPV3:= 0
Local _cqry      := ""

SC6->(dbSetOrder(12))

If Select("Qrysc6") > 0
	Qrysc6->(dbCloseArea())
Endif

_cqry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) AS QTDSC6 "
_cqry += " FROM "+RETSQLNAME("SC6")+" (NOLOCK) WHERE C6_FILIAL='"+xFILIAL("SC6")+"' AND C6_IDENTB6='"+_cIdent+"' AND D_E_L_E_T_='' AND (C6_QTDVEN-C6_QTDENT) > 0 "

TCQUERY _cqry ALIAS "Qrysc6" NEW

dbSelectArea("Qrysc6")

If Select("Qrysc6") > 0
	_nQtPV3 :=Qrysc6->QTDSC6
Endif

_nSalDisP3 := _nSalSB6 - _nQtPV3

restarea(_aAreaSC6)

return(_nSalDisP3)


Static Function MENNOTA()

Local aAreaAtu := GetArea()
Local oDlg
Local cFile   := Space( 180 )
Local nOpc    := 0
Local bOk     := { || If( !Empty( cFile ),(nOpc := 1, oDlg:End()), MsgStop( "Informe a Mensagem!" ) ) }
Local bCancel := { || oDlg:End() }
Local cTitle  := "Mensagem Padrão"


//*******************************************
//Inicializa tela para selecionar arquivo.
//*******************************************
Define MSDialog oDlg Title cTitle From 1 , 1 To 100 , 550 Of oMainWnd Pixel

oPanel := TPanel():New( ,,, oDlg )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

TGroup():New( 02 , 02 , 134 , 274 , "" , oPanel ,,, .T. )

@10 , 05 Say "Informe a Mensagem:" Of oPanel Pixel
@20 , 05 MsGet oGet Var cFile Size 255 , 10 Of oPanel Pixel


Activate MSDialog oDlg On Init EnchoiceBar( oDlg , bOk , bCancel ) Centered

_cMenSC5:= Alltrim(cFile)

RestArea(aAreaAtu)

Return

Static Function TRANSP()

Local aAreaAtu := GetArea()
Local oDlg
Local cFile   := Space(6)
Local nOpc    := 0
Local bOk     := { || If( !Empty( cFile ),(nOpc := 1, oDlg:End()), MsgStop( "Informe a Transportadora!" ) ) }
Local bCancel := { || oDlg:End() }
Local cTitle  := "Transportadora"

//*******************************************
//Inicializa tela para selecionar arquivo.
//*******************************************
Define MSDialog oDlg Title cTitle From 1 , 1 To 100 , 550 Of oMainWnd Pixel

oPanel := TPanel():New( ,,, oDlg )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

TGroup():New( 02 , 02 , 134 , 274 , "" , oPanel ,,, .T. )

@10 , 05 Say "Informe a Transportadora:" Of oPanel Pixel
@20 , 05 MsGet oGet Var cFile Size 255,10 PICTURE "@!" valid ExistCPO('SA4',cFile)  F3 'SA4' Of oPanel Pixel

Activate MSDialog oDlg On Init EnchoiceBar( oDlg , bOk , bCancel ) Centered

_cTransp:= Alltrim(cFile)

RestArea(aAreaAtu)

Return



Static Function GeraNF(aPedido,_cAglPed)

Local aAreaAtu  := GetArea()
Local aPvlNfs   := {}
Local aBloqueio := {{"","","","","","","",""}}
Local aNotas    := {}
Local cSerie	:=	_cSerNF//"001"

If _cAglPed == "S"//ApMsgYesNo('Aglutinar Pedidos de Venda na mesma NF?','Aglutinar Pedido de Venda')
	For i:=1 to len(aPedido)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+aPedido[i])
			//Liberando Bloqueios do Pedido
			SC9->(DBSetOrder(1))
			If SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM))
				While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
					RecLock("SC9",.F.)
					If SC9->C9_BLEST <> "10"
						SC9->C9_BLEST  := ""
					EndIf
					If SC9->C9_BLCRED <> "10"
						SC9->C9_BLCRED := ""
					EndIf
					SC9->(MsUnlock())
					SC9->(DbSkip())
				EndDo
			EndIf
			
			// Checa itens liberados
			IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		Endif
	Next i
	//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
	cNotaFeita :=""
	If Empty(aBloqueio) .And. !Empty(aPvlNfs)
		nItemNf  := a460NumIt(cSerie)
		aadd(aNotas,{})
		// Efetua as quebras de acordo com o numero de itens
		For nX := 1 To Len(aPvlNfs)
			If Len(aNotas[Len(aNotas)])>=nItemNf
				aadd(aNotas,{})
			EndIf
			aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
		Next nX
		For nX := 1 To Len(aNotas)
			//Gera a Nota Fiscal
			IncProc( "Gerando Nota Fiscal " )
			cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
			aADD(aNfOk,{SF2->F2_CLIENTE+SF2->F2_LOJA,SF2->F2_SERIE,SF2->F2_DOC})
		Next nX
	endIf
Else
	For i:=1 to len(aPedido)
		aPvlNfs   := {}
		aBloqueio := {{"","","","","","","",""}}
		aNotas    := {}
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+aPedido[i])
			//Liberando Bloqueios do Pedido
			SC9->(DBSetOrder(1))
			If SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM))
				While !SC9->(Eof()) .AND. xFilial("SC9")+SC9->C9_PEDIDO==xFilial("SC9")+SC5->C5_NUM
					RecLock("SC9",.F.)
					If SC9->C9_BLEST <> "10"
						SC9->C9_BLEST  := ""
					EndIf
					If SC9->C9_BLCRED <> "10"
						SC9->C9_BLCRED := ""
					EndIf
					SC9->(MsUnlock())
					SC9->(DbSkip())
				EndDo
			EndIf
			
			// Checa itens liberados
			IncProc( "Verificando bloqueios para Pedido " + SC5->C5_NUM)
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
			
			//Verifica se Existe Itens Liberados para gerar a Nota Fiscal
			cNotaFeita :=""
			If Empty(aBloqueio) .And. !Empty(aPvlNfs)
				nItemNf  := a460NumIt(cSerie)
				aadd(aNotas,{})
				// Efetua as quebras de acordo com o numero de itens
				For nX := 1 To Len(aPvlNfs)
					If Len(aNotas[Len(aNotas)])>=nItemNf
						aadd(aNotas,{})
					EndIf
					aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
				Next nX
				For nX := 1 To Len(aNotas)
					//Gera a Nota Fiscal
					IncProc( "Gerando Nota para Pedido " + SC5->C5_NUM)
					cNotaFeita := MaPvlNfs(aNotas[nX],cSerie)
					aADD(aNfOk,{SF2->F2_CLIENTE+SF2->F2_LOJA,SF2->F2_SERIE,SF2->F2_DOC})
				Next nX
			endIf
		Endif
	Next i
Endif

RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG  ºAutor  ³Delta Decisao      º Data ³  21/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDPERG()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
cPerg        := PADR(cPerg,len(sx1->x1_grupo))

AAdd(aHelpPor,"Data de Entrada Inicial ")
PutSx1(cPerg,"01","Entrada De ?","Entrada De ?","Entrada De ?","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

AAdd(aHelpPor,"Data de Entrada Final ")
PutSx1(cPerg,"02","Entrada Ate ?","Entrada Ate ?","Entrada Ate ?","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"NF Inicial")
PutSx1(cPerg,"03","NF De ?","NF De ?","NF De ?","mv_ch3","C",09,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"NF Final")
PutSx1(cPerg,"04","NF Ate ?","NF Ate ?","NF Ate ?","mv_ch4","C",09,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


aHelpPor :={}
AAdd(aHelpPor,"Serie Inicial")
PutSx1(cPerg,"05","Serie De ?","Serie De ?","Serie De ?","mv_ch5","C",03,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Serie Final")
PutSx1(cPerg,"06","Serie Ate ?","Serie Ate ?","Serie Ate ?","mv_ch6","C",03,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Fornecedor ")
PutSx1(cPerg,"07","Fornecedor ?","Fornecedor ?","Fornecedor ?","mv_ch7","C",06,0,0,"G","","SA2","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Loja ?")
PutSx1(cPerg,"08","Loja ?","Loja ?","Loja ?","mv_ch8","C",02,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


aHelpPor :={}
AAdd(aHelpPor,"Informe a TES")
PutSx1(cPerg,"09","TES ?","TES ?","TES ?","mv_ch9","C",03,0,0,"G","","SF4","","","MV_PAR09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


Return
