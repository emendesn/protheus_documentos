#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BGHPDVEN ³ Autor ³ Luciano Siqueira      ³ Data ³ 09/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerar pedido de Venda com base nos parametros informados    ±±
±±³          ³ somente para produtos com controle de endereço              ±±                                                                                                  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BGHPDVEN()

Private cPerg		:= "BHPDVEN"
Private aGrupos := aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private	lUsrAut :=.F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para log do uso de rotina.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_GerA0003(ProcName())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aGrupos)
	//Usuarios de Autorizado a fazer troca de IMEI
	If Upper(AllTrim(GRPRetName(aGrupos[nX]))) $ "FATURAMENTO/ADMINISTRADORES"
		lUsrAut  := .T.
		Exit
	EndIf
Next nX
// Alterado para atender o pessol do Faturamento - Uiran Almeida 02.02.2015
//If cUserName  $ "delta.consultoria"
If(lUsrAut)
	ValidPerg() // Ajusta as Perguntas do SX1
	If Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		MsAguarde({|| IMPPDVEN()},OemtoAnsi("Processando..."))
	Endif
Else
	Alert("usuário não autorizado!")
EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPPDVEN  ³ Autor ³ Luciano Siqueira    ³ Data ³ 09/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Pedidos de Venda                                       ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function IMPPDVEN()

Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca 	:= 0 //Opcao da confirmacao
Local _cArqEmp	:= "" //Arquivo temporario com as empresas a serem escolhidas
Local _aBrowse 	:= {} //array do browse para demonstracao das empresas
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 	:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local aButtons  := {}
Local _aStruTrb	:= {;
{"OK"		, "C", 02, 0},;
{"CLIENTE"	, "C", TamSX3("A1_COD")[1],0},;
{"LOJA" 	, "C", TamSX3("A1_LOJA")[1],0},;
{"TRANSP"	, "C", TamSX3("A4_COD")[1],0},;
{"CONDPAG"	, "C", TamSX3("C5_CONDPAG")[1],0},;
{"DIVNEG"	, "C", 02,0},;
{"TES"		, "C", TamSX3("F4_CODIGO")[1],0},;
{"CLIORI"	, "C", TamSX3("A1_COD")[1],0},;
{"LOJORI"	, "C", TamSX3("A1_LOJA")[1],0},;
{"ARMORI"	, "C", TamSX3("B2_LOCAL")[1],0},;
{"PRODUTO"	, "C", TamSX3("B1_COD")[1],0},;
{"DESCRI"   , "C", 50,0},;
{"ARMAZ"    , "C", TamSX3("B2_LOCAL")[1],0},;
{"LOCALIZ"  , "C", TamSX3("BF_LOCALIZ")[1],0},;
{"D1_VALIPI" , "N", TamSX3("D1_VALIPI")[1],2},;
{"BF_LOTECTL" , "C", TamSX3("BF_LOTECTL")[1],0},;
{"QTDE"	    , "N", TamSX3("BF_QUANT") [1],2}}

Private lInverte:= .F. //Variaveis para o MsSelect
Private cMarca 	:= GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect
Private oDlg

Private cArmaz	  		:= Alltrim(MV_PAR01)
Private cLocaliz  		:= Alltrim(MV_PAR02)
Private nTipoPV  		:= MV_PAR03
Private cCliPv	  		:= Alltrim(MV_PAR04)
Private cLojPv	  		:= Alltrim(MV_PAR05)
Private cTransp	  		:= Alltrim(MV_PAR06)
Private cCondpgto		:= Alltrim(MV_PAR07)
Private cDivNeg	  		:= Alltrim(MV_PAR08)
Private cTES		 	:= Alltrim(MV_PAR09)
Private cPoder3         := Posicione("SF4",1,xFilial("SF4") + cTES, "F4_PODER3")
Private cCliOri	  		:= IIF(cPoder3 == "D",Alltrim(MV_PAR10),"")
Private cLojOri	  		:= IIF(cPoder3 == "D",Alltrim(MV_PAR11),"")
Private cArmOri	  		:= IIF(cPoder3 == "D",Alltrim(MV_PAR12),"")
Private _aStruLog   	:= {}
Private _cLog			:= ""

//Tratamento conforme solicitação do Rafael
If Empty(cTES)
	
	If Alltrim(cArmaz) == "20"
		cPoder3 := ""
		cCliOri	:= ""
		cLojOri	:= ""
		cArmOri	:= ""
	Else	
		cPoder3 := "D"
		cCliOri	:= Alltrim(MV_PAR10)
		cLojOri	:= Alltrim(MV_PAR11)
		cArmOri	:= Alltrim(MV_PAR12)
	EndIf
EndIf

AADD(_aStruLog,{"LOG","C",90,0})

_cArq     := CriaTrab(_aStruLog,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
_cChaveInd	:= "LOG"

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,_cChaveInd,,,"Selecionando Registros...")

If nTipoPV==2
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	If !dbSeek(xFilial("SA2")+cCliPv+cLojPv)
		_cLog := "Cod Fornecedor do PV: "+cCliPv+" - "+cLojPv+" - não localizado no cadastro."
		GERLOG(_cLog)
	Endif
Else
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If !dbSeek(xFilial("SA1")+cCliPv+cLojPv)
		_cLog := "Cod Cliente do PV: "+cCliPv+" - "+cLojPv+" - não localizado no cadastro."
		GERLOG(_cLog)
	Endif
Endif
         
If !Empty(cTES)
	dbSelectArea("SF4")
	SF4->(dbSetOrder(1))
	If !dbSeek(xFilial("SF4")+cTES)
		_cLog := "TES: "+cTES+" - não localizada no cadastro."
		GERLOG(_cLog)
	Endif
EndIf	

dbSelectArea("SE4")
dbSetOrder(1)
If !dbSeek(xFilial("SE4")+cCondpgto)
	_cLog := "Cond. Pagto.: "+cCondpgto+" - não localizada no cadastro."
	GERLOG(_cLog)
Endif

dbSelectArea("SA4")
dbSetOrder(1)
If !dbSeek(xFilial("SA4")+cTransp)
	_cLog := "Transportadora: "+cTransp+" - não localizada no cadastro."
	GERLOG(_cLog)
Endif


If cPoder3=="D" .and. (EMPTY(cCliOri) .or. EMPTY(cLojOri) .or. EMPTY(cArmOri))
	_cLog := "Para TES que controla Poder3 é necessario informar Cliente, Loja e Armazem de Origem."
	GERLOG(_cLog)
Endif

If cPoder3=="D"
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If !dbSeek(xFilial("SA1")+cCliOri+cLojOri)
		_cLog := "Cod Cliente Origem: "+cCliOri+" - "+cLojOri+" - não localizado no cadastro."
		GERLOG(_cLog)
	Endif
Endif

dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
	If Sele("TRB")<>0
		TRB->(DbCloseArea())
	Endif
	Return
Endif

AADD(_aBrowse,{"OK"	     	,,""})
AADD(_aBrowse,{"CLIENTE"	,,"Cliente"})
AADD(_aBrowse,{"LOJA"	    ,,"Loja"})
AADD(_aBrowse,{"TRANSP"	    ,,"Transp"})
AADD(_aBrowse,{"CONDPAG"	,,"Cond. Pagto."})
AADD(_aBrowse,{"QTDE"	    ,,"Quantidade","@E 999,999,999.99"})
AADD(_aBrowse,{"DIVNEG"	    ,,"Div. Negocio"})
AADD(_aBrowse,{"TES"		,,"TES"})
AADD(_aBrowse,{"CLIORI"	    ,,"Cli Origem"})
AADD(_aBrowse,{"LOJORI"	    ,,"Lj Origem"})
AADD(_aBrowse,{"ARMORI"	    ,,"Armz Origem"})
AADD(_aBrowse,{"PRODUTO"	,,"Produto"})
AADD(_aBrowse,{"DESCRI"	    ,,"Descrição"})
AADD(_aBrowse,{"ARMAZ"	    ,,"Armazem"})
AADD(_aBrowse,{"LOCALIZ"	,,"Endereço"})

If Select("fMark") > 0
	fMark->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)

dbUseArea(.T.,__LocalDriver,_cArqEmp,"fMark")

//Aqui você monta sua query que serve para gravar os dados no arquivo temporario...
cQuery := " SELECT BF_PRODUTO, B1_DESC, BF_LOCAL, BF_LOCALIZ, (BF_QUANT-BF_EMPENHO) AS SALDOBF, BF_LOTECTL, "

//If cArmaz == "20"
If cArmaz $ "20/01"
	cQuery += " (SELECT SUM(D1_VALIPI) "
	cQuery += "  FROM SD1020 SD1 (NOLOCK)"
	cQuery += "  JOIN SF4020 SF4 (NOLOCK)"
	cQuery += "  ON   F4_FILIAL = '' AND F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ = '' AND F4_LFIPI = 'T' "
	cQuery += " 		WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += " 		AND D1_COD = B1_COD "
	cQuery += " 		AND SD1.D_E_L_E_T_ = '') AS D1_VALIPI "
Else
	cQuery += "  0 as D1_VALIPI "
EndIf	

cQuery += " FROM "+ RETSQLNAME("SBF")+" SBF (nolock) "
cQuery += " INNER JOIN "+ RETSQLNAME("SB1")+" SB1 (nolock) "
cQuery += " ON (B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND B1_COD=BF_PRODUTO AND SB1.D_E_L_E_T_ = '') " 
cQuery += " WHERE "
cQuery += " BF_FILIAL = '"+xFilial("SBF")+"' "
cQuery += " AND BF_LOCAL = '"+cArmaz+"' "
cQuery += " AND BF_LOCALIZ <> 'QUALIDADE' "
If !Empty(cLocaliz)
	cQuery += " AND BF_LOCALIZ = '"+cLocaliz+"' "
Endif	
cQuery += " AND BF_QUANT-BF_EMPENHO > 0 "
cQuery += " AND SBF.D_E_L_E_T_ = '' "
cQuery += " ORDER BY BF_FILIAL,BF_PRODUTO "

TCQuery cQuery new Alias (cAlias:=GetNextAlias())

dbSelectArea(cAlias)
dbGotop()
If (cAlias)->(!Eof())
	While (cAlias)->(!Eof())
		 
		//Excluir		                    		
		If (cAlias)->D1_VALIPI > 0 .And. cTES == "790"		
			(cAlias)->(dbSkip())                      
			Loop
		EndIf
		
		If (cAlias)->D1_VALIPI == 0 .And. cTES == "789"		
			(cAlias)->(dbSkip())                      
			Loop
		EndIf
		
		RecLock("fMARK",.T.)
		fMark->OK		:= cMarca
		fMark->CLIENTE 	:= cCliPv
		fMark->LOJA 	:= cLojPv
		fMark->TRANSP 	:= cTransp
		fMark->CONDPAG 	:= cCondpgto
		fMark->DIVNEG 	:= cDivNeg
		fMark->TES	 	:= cTES
		
		If cPoder3 == "D"
			fMark->CLIORI 	:= cCliOri
			fMark->LOJORI 	:= cLojOri
			fMark->ARMORI 	:= cArmOri
		Endif
		
		fMark->PRODUTO 	:= (cAlias)->BF_PRODUTO
		fMark->DESCRI   := (cAlias)->B1_DESC
		fMark->ARMAZ    := (cAlias)->BF_LOCAL
		fMark->LOCALIZ  := (cAlias)->BF_LOCALIZ
		fMark->QTDE	    := (cAlias)->SALDOBF   
		
		fMark->BF_LOTECTL  := (cAlias)->BF_LOTECTL
		fMark->D1_VALIPI  := (cAlias)->D1_VALIPI
		
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
	
	Aadd(aButtons,{"GRAVAR",{|| AltQtd() },"Altera Qtde","Altera Qtde"})
	
	
	DEFINE MSDIALOG oDlg TITLE "Geração de Pedido Venda" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	oBrwTrb := MsSelect():New("fMARK","OK","",_aBrowse,@lInverte,@cMarca,{005,005,230,650})
	
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
			MsAguarde({|| GERAPV()},OemtoAnsi("Processando Pedido de Venda..."))
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

dbSelectArea("TRB")
dbGotop()
If TRB->(!EOF())
	Processa({|| IMPEXC() },"Gerando Relatorio de Log...")
Endif

If Sele("TRB")<>0
	TRB->(DbCloseArea())
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AltQtd    ³ Autor ³ Luciano Siqueira    ³ Data ³ 09/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Alterar Quantidade para Geração da NF Saida                 ±±
±±³          ³                                  						   ±±                                                                                                                     ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BGH                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function AltQtd()

Local aAreaAtu  := GetArea()
Local oDlgx
Local nOpcB  	:= 0
Local nQtdeOri 	:= fMark->QTDE
Local nQtde 	:= 0

DEFINE MSDIALOG oDlgx TITLE "Alterar Quantidade" FROM 0,0 TO 100,400 PIXEL


@ 16, 006 SAY "Quantidade.:"   SIZE 70,7 PIXEL OF oDlgx
@ 15, 050 MSGET nQtde  When .T. PICTURE "@E 999,999.99" SIZE 30,7 PIXEL OF oDlgx

ACTIVATE MSDIALOG oDlgx ON INIT EnchoiceBar(oDlgx,{||nOpcB:=1,oDlgx:End()},{||oDlgx:End()})

If nOpcB == 1
	If nQtde <= 0
		MsgAlert("Quantidade tem que ser maior que zero.")
	Else
		If nQtde > nQtdeOri
			MsgAlert("Quantidade maior que quantidade existente no endereço.")
		Else
			RecLock("fMark",.F.)
			fMark->QTDE := nQtde
			MsUnLock()
		Endif
	Endif
Endif

RestArea(aAreaAtu)

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

Static Function GERAPV()

Local aAreaAtu  	:= GetArea()
Local aCabPV      	:=	{}
Local aItemPV     	:=	{}
Local aItem       	:=	{}
Local nOpc		    :=	3
Local nItPv	 	    := 	'00'

dbSelectArea("fMark")
dbGotop()

If fMark->(!EOF())
	While fMark->(!EOF())
		If Len(aCabPv) == 0 .and. Len(aItem) == 0
			aCabPV := {;
			{"C5_TIPO"   ,IIF(nTipoPV==1,"N","B")	,Nil},;
			{"C5_CLIENTE",fMark->CLIENTE   			,Nil},;
			{"C5_LOJACLI",fMark->LOJA	  			,Nil},;
			{"C5_CONDPAG",fMark->CONDPAG   			,Nil},;
			{"C5_TRANSP" ,fMark->TRANSP    			,Nil},;
			{"C5_DIVNEG" ,fMark->DIVNEG    			,Nil},;
			{"C5_CLIENT",fMark->CLIENTE   			,Nil},;
			{"C5_LOJAENT",fMark->LOJA	  			,Nil}}
		Endif
		If !EMPTY(fMark->OK)
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+fMark->PRODUTO)
				If cPoder3 <> "D"
					nPreco := 0
					nValor := 0
					dbSelectArea("SB2")
					dbSetOrder(1)
					If dbSeek(xFilial("SB2")+fMark->PRODUTO+fMark->ARMAZ)
						nPreco := SB2->B2_CM1
					Endif
					If nPreco <= 0
						nPreco:=u_verultcom(fMark->PRODUTO,ddatabase,fMark->ARMAZ)
					Endif
					If nPreco > 0
						nValor  := A410Arred(nPreco*fMark->QTDE,"C6_VALOR")
						nItPv	:= Soma1(nItPv,2)
						
						//Busca a configuracao da TES 
						If fMark->TES $ "789/790"
							If fMark->D1_VALIPI > 0
								cTesOri := "789"
							Else                           
								cTesOri := "790"
							EndIf							
						Else
							cTesOri := fMark->TES
						EndIf
						
						aItemPV:={;
						{"C6_ITEM"   	,	nItPv		,Nil},;
						{"C6_PRODUTO"	,	fMark->PRODUTO			,Nil},;
						{"C6_QTDVEN" 	,	fMark->QTDE				,Nil},;
						{"C6_QTDLIB"	,	fMark->QTDE				,Nil},;
						{"C6_PRCVEN" 	,	nPreco					,Nil},;
						{"C6_VALOR"		,	nValor				    ,Nil},;
						{"C6_TES"		,	cTesOri					,Nil},;
						{"C6_NFORI"		,	""						,Nil},;
						{"C6_SERIORI"	,	""						,Nil},;
						{"C6_ITEMORI"	,	""						,Nil},;
						{"C6_IDENTB6"	,	""						,Nil},;
						{"C6_LOCAL" 	,	fMark->ARMAZ			,Nil},;
						{"C6_LOCALIZ" 	,	fMark->LOCALIZ			,Nil},;
						{"C6_LOTECTL" 	,	fMark->BF_LOTECTL   	,Nil},;
						{"C6_PRUNIT"	,	0						,Nil}}
						aADD(aItem,aItempv)
						
						If len(aItem) == 999
							If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
								lMsErroAuto := .F.
								MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
								If lMsErroAuto
									//MostraErro()
									GERPVMAN(aCabPv,aItem) 
								Else
									MsgAlert("Pedido gerado - "+SC5->C5_NUM)
								Endif
								aCabPV      	:=	{}
								aItemPV     	:=	{}
								aItem       	:=	{}
								nItPv	 	    := 	'00'
							Endif
						Endif
					Else
						_cLog := "Custo do Produto: "+fMark->PRODUTO+" - não localizado no sistema."
						GERLOG(_cLog)
					Endif
				Else
					nSaldo := fMark->QTDE
					DbSelectArea("SB6")
					SB6->(dbSetOrder(1)) //B6_FILIAL + B6_PRODUTO + B6_CLIFOR + B6_LOJA + B6_IDENT
					   
					// Incluso INNER JOIN, para buscar o Item Origem do Produto
					/*
					_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT, B6_TES "
					_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) "
					_cQrySB6 += " WHERE  B6_FILIAL = '"+xFilial("SB6")+"' AND "
					_cQrySB6 += "        B6_PRODUTO = '"+fMark->PRODUTO+"' AND "
					_cQrySB6 += "        B6_CLIFOR  = '"+fMark->CLIORI+"' AND "
					_cQrySB6 += "        B6_LOJA    = '"+fMark->LOJORI+"' AND "
					_cQrySB6 += "		 B6_LOCAL ='"+fMark->ARMORI+"' AND "
					_cQrySB6 += "        B6_SALDO > 0 AND "
					_cQrySB6 += "		 B6.D_E_L_E_T_ = '' "
					_cQrySB6 += " ORDER BY B6_FILIAL,B6_IDENT "
					*/
					_cQrySB6 := " SELECT B6_PRODUTO,B6_IDENT,B6_DOC,B6_SERIE,B6_LOCAL,B6_SALDO,B6_PRUNIT, B6_TES,D1_IDENTB6, D1_ITEM "
					_cQrySB6 += " FROM   "+RetSqlName("SB6")+" AS B6 (nolock) " 
					_cQrySB6 += " INNER JOIN "+RetSqlName("SD1")+" As SD1(NOLOCK) "
					_cQrySB6 += " ON ( "
					_cQrySB6 += " 		B6.D_E_L_E_T_   = SD1.D_E_L_E_T_ "
					_cQrySB6 += " 	And	B6.B6_FILIAL	= SD1.D1_FILIAL " 
					_cQrySB6 += " 	And B6.B6_DOC		= SD1.D1_DOC "	 
					_cQrySB6 += " 	And B6.B6_SERIE		= SD1.D1_SERIE " 
					_cQrySB6 += " 	And B6.B6_CLIFOR	= SD1.D1_FORNECE "	 
					_cQrySB6 += " 	And B6.B6_LOJA		= SD1.D1_LOJA "	 
					_cQrySB6 += " 	And B6.B6_EMISSAO	= SD1.D1_EMISSAO "	 
					_cQrySB6 += " 	And B6.B6_IDENT		= SD1.D1_IDENTB6 "	 
					_cQrySB6 += "    ) "
					_cQrySB6 += " WHERE  B6_FILIAL 	= '"+xFilial("SB6")+"' AND "
					_cQrySB6 += "        B6_PRODUTO = '"+fMark->PRODUTO+"' AND "
					_cQrySB6 += "        B6_CLIFOR  = '"+fMark->CLIORI+"' AND "
					_cQrySB6 += "        B6_LOJA    = '"+fMark->LOJORI+"' AND "
					_cQrySB6 += "		 B6_LOCAL 	= '"+fMark->ARMORI+"' AND "
					_cQrySB6 += "        B6_SALDO > 0 AND "
					_cQrySB6 += "		 B6.D_E_L_E_T_ = '' "
					_cQrySB6 += " ORDER BY B6_FILIAL,B6_IDENT "
					
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySB6),"TSQLSB6",.T.,.T.)
					
					TSQLSB6->(DBGoTop())
					
					While TSQLSB6->(!EOF()) .and. nSaldo > 0
						nSalP3  := SalDisP3(TSQLSB6->B6_IDENT, TSQLSB6->B6_SALDO)
						nQtRet3 := iif(nSalP3 >= nSaldo, nSaldo, nSalP3)
						
						IF nQtRet3 > 0
							nItPv	:= Soma1(nItPv,2)
							nSaldo  := nSaldo - nQtRet3
							nPreco  := A410Arred(TSQLSB6->B6_PRUNIT,"C6_VALOR")
							nValor  := A410Arred(TSQLSB6->B6_PRUNIT * nQtRet3,"C6_VALOR")
							
							//Busca TES de orige - D.FERNANDES - 08/01/2013
							If Empty(fMark->TES)
								cTesOri := Posicione("SF4",1,xFilial("SF4")+TSQLSB6->B6_TES,"F4_TESDV")
							Else
								cTesOri := fMark->TES
							EndIf
							
							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1")+TSQLSB6->B6_PRODUTO)
							
							aItemPV:={;
							{"C6_ITEM"   	,	nItPv		,Nil},;
							{"C6_PRODUTO"	,	fMark->PRODUTO			,Nil},;
							{"C6_QTDVEN" 	,	nQtRet3					,Nil},;
							{"C6_QTDLIB"	,	nQtRet3 				,Nil},;
							{"C6_PRCVEN" 	,	nPreco					,Nil},;
							{"C6_VALOR"		,	nValor				    ,Nil},;
							{"C6_TES"		,	cTesOri					,Nil},;
							{"C6_NFORI"		,	TSQLSB6->B6_DOC			,Nil},;
							{"C6_SERIORI"	,	TSQLSB6->B6_SERIE		,Nil},;
							{"C6_ITEMORI"	,	TSQLSB6->D1_ITEM		,Nil},;
							{"C6_IDENTB6"	,	TSQLSB6->B6_IDENT		,Nil},;
							{"C6_LOCAL" 	,	fMark->ARMAZ			,Nil},;
							{"C6_LOCALIZ" 	,	fMark->LOCALIZ			,Nil},;
							{"C6_PRUNIT"	,	0						,Nil}}
							aADD(aItem,aItempv)
							
							If len(aItem) == 999
								If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
									lMsErroAuto := .F.
									MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
									If lMsErroAuto
										//MostraErro()
										GERPVMAN(aCabPv,aItem)
									Else
										MsgAlert("Pedido gerado - "+SC5->C5_NUM)
									Endif
									aCabPV      	:=	{}
									aItemPV     	:=	{}
									aItem       	:=	{}
									nItPv	 	    := 	'00'
								Endif
							Endif
							
						Endif
						TSQLSB6->(dbSkip())
					Enddo
					
					If nSaldo > 0
						_cLog := "Produto: "+fMark->PRODUTO+" - não possui a quantidade "+Alltrim(str(nSaldo))+" na tabela de terceiro."
						GERLOG(_cLog)
					Endif
					If Select("TSQLSB6") > 0
						dbSelectArea("TSQLSB6")
						DbCloseArea()
					EndIf
				Endif
			Else
				_cLog := "Produto: "+fMark->PRODUTO+" - não localizado no cadastro."
				GERLOG(_cLog)
			Endif
		Endif
		dbSelectArea("fMark")
		dbSkip()
	EndDo
	If 	Len(aCabPv) > 0 .and. Len(aItem) > 0
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)
		
		If lMsErroAuto
			//MostraErro()
			GERPVMAN(aCabPv,aItem)
		Else
			MsgAlert("Pedido gerado - "+SC5->C5_NUM)
		Endif
	Endif
	
Endif

RestArea(aAreaAtu)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERLOG    ºAutor  ³Luciano Siqueira    º Data ³  03/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava log das inconsistencias encontradas                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SUNNY                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GERLOG(_cLog)

dbSelectArea("TRB")
If !dbSeek(_cLog)
	RecLock("TRB",.T.)
	TRB->LOG := _cLog
	MsUnlock()
Endif

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


Static Function GERPVMAN(aCabPv,aItem)

Local aAreaAtu	:= GetArea()
Local cNrPV		:= GetSxeNum('SC5','C5_NUM')

If nTipoPv == 1
	dbSelectArea("SA1")
	dbSetOrder(1)
	SA1->(DBSeek(xFilial('SA1')+aCabPv[2,2]+aCabPv[3,2]))

	_cCFIni := "0"
	If Subs(SA1->A1_EST,1,2) == "EX"
		_cCFIni := "7"
	ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
		_cCFIni := "6"
	Else
		_cCFIni := "5"
	EndIf
Else 
	dbSelectArea("SA2")
	dbSetOrder(1)
	SA2->(DBSeek(xFilial('SA2')+aCabPv[2,2]+aCabPv[3,2]))
	
	_cCFIni := "0"
	If Subs(SA2->A2_EST,1,2) == "EX"
		_cCFIni := "7"
	ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA2->A2_EST)
		_cCFIni := "6"
	Else
		_cCFIni := "5"
	EndIf

Endif

dbSelectArea("SC5")
RecLock('SC5',.T.)
SC5->C5_FILIAL  := xFilial('SC5')
SC5->C5_NUM     := cNrPV
SC5->C5_TIPO    := aCabPv[1,2]
SC5->C5_CLIENTE := aCabPv[2,2]
SC5->C5_LOJACLI := aCabPv[3,2]
SC5->C5_CLIENT  := aCabPv[2,2]
SC5->C5_LOJAENT := aCabPv[3,2]
SC5->C5_TIPOCLI := 'F'   //Consumidor Final
SC5->C5_CONDPAG := aCabPv[4,2]
SC5->C5_TRANSP  := aCabPv[5,2]
SC5->C5_DIVNEG  := aCabPv[6,2]
SC5->C5_EMISSAO := dDatabase
SC5->C5_MOEDA   := 1
SC5->C5_TIPLIB  := '1'   //Liberacao por Pedido
SC5->C5_TPCARGA := '2'
SC5->C5_TXMOEDA := 1
SC5->C5_LIBEROK := "S"
MsUnLock('SC5')
ConfirmSX8()

for nX := 1 to len(aItem)
	SB1->(DBSeek(xFilial('SB1')+aItem[nX,2,2]))
	SF4->(DBSeek(xFilial('SF4')+aItem[nX,7,2])) 
	dbSelectArea("SC6")
	RecLock('SC6',.T.)
	SC6->C6_FILIAL := xFilial('SC6')
	SC6->C6_NUM    := cNrPV
	SC6->C6_ITEM   := aItem[nX,1,2]
	SC6->C6_PRODUTO:= aItem[nX,2,2]
	SC6->C6_UM     := SB1->B1_UM
	SC6->C6_QTDVEN := aItem[nX,3,2]
	SC6->C6_QTDLIB := aItem[nX,4,2]
	SC6->C6_PRCVEN := aItem[nX,5,2]
	SC6->C6_VALOR  := aItem[nX,6,2]
	SC6->C6_TES    := aItem[nX,7,2]
	SC6->C6_LOCAL  := aItem[nX,12,2]
	SC6->C6_LOCALIZ:= aItem[nX,13,2]
	SC6->C6_CF     := AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
	SC6->C6_ENTREG := dDataBase
	SC6->C6_DESCRI := SB1->B1_DESC
	SC6->C6_PRUNIT := 0.00
	SC6->C6_NFORI  := aItem[nX,8,2]
	SC6->C6_SERIORI:= aItem[nX,9,2]
	SC6->C6_ITEMORI:= aItem[nX,10,2]
	SC6->C6_TPOP   := 'F' //FIRME
	SC6->C6_CLI    := aCabPv[2,2]
	SC6->C6_LOJA   := aCabPv[3,2]
	SC6->C6_IDENTB6:= aItem[nX,11,2]
	MsUnLock('SC6')
	
	MaLibDoFat(SC6->(RECNO()),aItem[nX,4,2],@.T.,@.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,aItem[nX,4,2])
next nX

MsgAlert("Pedido gerado - "+cNrPV)

RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPEXC    ºAutor  ³Luciano Siqueira    º Data ³  12/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Log das Inconsistencias encontradas                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BGH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPEXC()

Local oReport

Private _cQuebra := " "

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()
EndIf
Return


Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("IMPEXC","Log",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir Log")


oSection1 := TRSection():New(oReport,OemToAnsi("Log"),{"TRB"})

TRCell():New(oSection1,"LOG","TRB","LOG","@!",90)


Return oReport


// Impressao do Relatorio

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText("Total Geral  ")  // Imprime Titulo antes do Totalizador da Secao
oReport:OnPageBreak(,.T.)


// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()

oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()

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

AAdd(aHelpPor,"Armazem a ser considerado ")
PutSx1(cPerg,"01","Armazem ?","Armazem ?","Armazem ?","mv_ch1","C",02,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Endereço a ser considerado ")
PutSx1(cPerg,"02","Endereço ?","Endereço ?","Endereço ?","mv_ch2","C",15,0,0,"G","","SBE","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


aHelpPor :={}
AAdd(aHelpPor,"Tipo Pedido Normal ou Utiliza Fornecedor")
PutSx1(cPerg,"03","Tipo Pedido ?","Tipo Pedido ?","Tipo Pedido ?","mv_ch3","N",01,0,0,"C","","","","","MV_PAR03","Normal","","","","Utiliza Fornecedor","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Cliente/Fornecedor ")
PutSx1(cPerg,"04","Cliente/Fornecedor ?","Cliente/Fornecedor ?","Cliente/Fornecedor ?","mv_ch4","C",06,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Loja do Pedido de Venda")
PutSx1(cPerg,"05","Loja PV ?","Loja PV ?","Loja PV ?","mv_ch5","C",02,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Transportadora")
PutSx1(cPerg,"06","Transp. ?","Transp. ?","Transp. ?","mv_ch6","C",06,0,0,"G","","SA4","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Condição Pagto.")
PutSx1(cPerg,"07","Cond. Pagto. ?","Cond. Pagto. ?","Cond. Pagto. ?","mv_ch7","C",03,0,0,"G","","SE4","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Divisao Negocio")
PutSx1(cPerg,"08","Div. Neg. ?","Div. Neg. ?","Div. Neg. ?","mv_ch8","C",02,0,0,"G","","ZM","","","MV_PAR08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"TES")
PutSx1(cPerg,"09","TES ?","TES ?","TES ?","mv_ch9","C",03,0,0,"G","","SF4","","","MV_PAR09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

AAdd(aHelpPor,"Cliente Origem Poder Terceiro ")
PutSx1(cPerg,"10","Cli Origem ?","Cli Origem ?","Cli Origem ?","mv_cha","C",06,0,0,"G","","SA1","","","MV_PAR10","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Loja Cli Origem Poder Terceiro")
PutSx1(cPerg,"11","Lj Origem ?","Lj Origem ?","Lj Origem ?","mv_chb","C",02,0,0,"G","","","","","MV_PAR11","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Armazem Origem Poder Terceiro")
PutSx1(cPerg,"12","Armaz Origem?","Armaz Origem?","Armaz Origem?","mv_chc","C",02,0,0,"G","","","","","MV_PAR12","Sim","","","","Nao","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


Return
