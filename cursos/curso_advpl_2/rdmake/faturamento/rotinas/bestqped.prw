#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BESTQPED ºAutor  ³ Edson Rodrigues    º Data ³  12/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para gerar Pedido de Venda de retorno do poder de º±±
±±º          ³ terceiros do saldo em aberto                               º±±
±±º          ³ - Verifica Saldo Aberto                                    º±±
±±º          ³ - Verifica se entrou pelo processo Entrada/Saida massiva   º±±
±±º          ³ - Se entrou pelo processo de Entrada/saida Massiva,analisa º±±
±±º          ³ laboratorio, encerra OS, faz saída massiva e gera o pedido º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterado por M.Munhoz em 21/08/2011 para substituir o tratamento do D1_NUMSER  ³
//³ pelo D1_ITEM, uma vez que o IMEI deixara de ser gravado no SD1.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function BESTQPED()
Local aSay			:= {}
Local aButton		:= {}
Local nOpc			:= 0
Local cTitulo		:= "Geracao de Pedido de Vendas de Retorno de Terceiros"
Local cDesc1		:= "Este programa executa a geracao de Pedidos de Venda de retorno para o "
Local cDesc2		:= "saldo de terceiros em aberto. "
Local cDesc3		:= "Estão sendo considerados apenas armazens, cliente e Produtos filtrados pelo usuario. "
Local cDesc4		:= "Se os saldos em aberto forem do processo de E/S massiva, então infome fase/setor encrramento ."
Private cPerg		:= "BXESTER"
Private aGrupos		:= aClone(UsrRetGRP(CUSERNAME, __CUSERID))
Private lUsrAut		:= .F.									//Usuarios de Autorizado a excluir IMEI
Private _agpvesm	:= {}
Private _agerapv	:= {}
Private _aencmas	:= {}
Private _codtec		:= ""
Private _codfas		:= ""
Private _codset		:= ""
Private _codlab		:= ""
Private oV1,oV2,oV3
Private nTamNfe		:= TAMSX3("D1_DOC")[1]
Private nTamNfs		:= TAMSX3("D2_DOC")[1]
Private nTamser		:= TAMSX3("D2_SERIE")[1]
Private nTamcli		:= TAMSX3("A1_COD")[1]
Private nTamime		:= TAMSX3("ZZ4_IMEI")[1]
Private _cTes		:= Space(3)
Private cStartPath	:= GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )
Private _nTotal		:= 0000
Private _cDefRec	:= ""
Public cTexto		:= ""
Public UltReg		:= .F.
Public _lFechSM		:= .F.
Public _SerSai		:= {}
u_GerA0003(ProcName())
dbSelectArea("SA1")		//Cadastro de Clientes
SA1->(dbSetOrder(1))	//A1_FILIAL+A1_COD+A1_LOJA
dbSelectArea("SB1")		//Cadastro de Produtos
SB1->(dbSetOrder(1))	//B1_FILIAL+B1_COD
dbSelectArea("AB6")
AB6->(dbSetOrder(1))	// AB6_FILIAL + AB6_NUMOS
dbSelectArea("AB7")
AB7->(DBOrderNickName("AB7NUMSER"))//AB7->(dbSetOrder(6)) // AB7_FILIAL + AB7_NUMOS + AB7_NUMSER
dbSelectArea("AB1")
AB1->(dbSetOrder(1))	// AB1_FILIAL + AB1_NRCHAM
dbSelectArea("SZA")
SZA->(dbSetOrder(1))
dbSelectArea("ZZ1")
ZZ1->(dbSetOrder(1))	// ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1
dbSelectArea("AB9")
AB9->(dbSetOrder(1))	//AB9_FILIAL+AB9_NUMOS+AB9_CODTEC+AB9_SEQ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso de usuario                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aGrupos)
	//Usuarios de Autorizado a baixar saldo terceiro de armazéns obsoletos.
	If AllTrim(GRPRetName(aGrupos[i])) $ "Baixasaldoterc"
		lUsrAut := .T.
	EndIf
Next i
If !lUsrAut
	MsgAlert("Voce nao tem autorizacao para executar essa rotina. Contate o administrador do sistema.","Usuario nao Autorizado")
	Return
EndIf
If !Empty(cNumEmp)
	If left(cNumEmp,2)=="02" .AND. right(cNumEmp,2) $ ("01/02")
		If right(cNumEmp,2) ="02"
			If !ApMsgYesNo("Voce esta na Filial :  M A T R I Z. Tem certeza que deseja usar essa rotina nessa filial?","Alerta Filial")
				Return
			EndIf
		ElseIf right(cNumEmp,2) ="01"
			If !ApMsgYesNo("Voce esta na Filial : C O L U M B I A. Tem certeza que deseja usar essa rotina nessa filial?","Alerta Filial")
				Return
			EndIf
		Else
			MsgAlert("Nao é permitido executar essa rotina na empresa/filal : "+left(cNumEmp,2)+"/"+right(cNumEmp,2)+"." ,"Alerta Filial")
			Return
		EndIf
	Else
		MsgAlert("Nao é permitido executar essa rotina na empresa/filal : "+left(cNumEmp,2)+"/"+right(cNumEmp,2)+"." ,"Alerta Filial")
		Return
	EndIf
EndIf
CriaSX1()
Pergunte(cPerg,.F.)
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )		}} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch()	}} )
aAdd( aButton, { 2, .T., {|| FechaBatch()				}} )
FormBatch( cTitulo, aSay, aButton )
If nOpc <> 1
	Return Nil
Else
	_cTes:=AllTrim(MV_PAR06)
	filterc()			//Filtra estoque terceiro em aberto
	If Len(_agpvesm) > 0
		If (Empty(_codtec) .OR. Empty(_codfas) .OR. Empty(_codset))
			If Len(_agerapv) > 0
				MsgAlert("Existe saldos em aberto que envolve o processo de E/S massiva, portanto é obrigatorio o preenchimento dos parametros fase/setor e tecnico. Volte a Executar essa rotina preenchendo esses parametros." ,"Parametros nao preenchidos")
				MsgAlert("Nesse momento sera gerado os pedidos de saldos em aberto que NAO envolve o processo de E/S massiva." ,"Geracao de Pedidos")
				pvgera()
			Else
				MsgAlert("Existe saldos em aberto que envolve o processo de E/S massiva, portanto é obrigatorio o preenchimento dos parametros fase/setor e tecnico. Volte a Executar essa rotina preenchendo esses parametros." ,"Parametros nao preenchidos")
			EndIf
		Else
			encatend()
			If Len(_aencmas) > 0
				encmas()
			EndIf
			If Len(_agerapv) > 0
				pvgera()
			EndIf
		EndIf
	Else
		If Len(_agerapv) > 0
			pvgera()
		Else
			MsgAlert("Não foi encontrado saldos em aberto. Confira os parâmetros ." ,"Saldos em aberto não encontrado")
		EndIf
	EndIf
	MsgAlert("Processo Encerrado." ,"Processo Encerrado")
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ filterc  ºAutor  ³Edson Rodrigues     º Data ³  12/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que le o saldo em aberto de Terceiros e monta       º±±
±±º          ³ vetor para Encerramento do laboratorio fase e saida massivaº±±
±±º          ³ e gerar o PV devolucao ou vetor so para gerar PV devolucao º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FilTerc()
Local bAcao		:= {|lFim| Runfilt(@lFim) }
Local cTitulo	:= ""
Local cMsg		:= "Filtrando estoque de Terceiros em aberto..."
Local lAborta	:= .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RUNFILT  ºAutor  ³Edson Rodrigues     º Data ³  13/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo que le o saldo em aberto de Terceiros e monta     º±±
±±º          ³ vetor para Encerramento do laboratorio fase e saida massivaº±±
±±º          ³ e gerar o PV devolucao ou vetor so para gerar PV devolucao º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Runfilt(lFim)
Local _cQuery	:= " "
Local _nItemPV	:= 0
Local _nSalP3	:= 0
Local _cItemPV	:= "01"
Local _lFirst	:= .T.
Local _aAreaSD1	:= SD1->(GetArea())
Local _aAreaSF1	:= SF1->(GetArea())
Local _aAreaSB1	:= SB1->(GetArea())
Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSB6	:= SB6->(GetArea())
Local _aAreaZZ4	:= ZZ4->(GetArea())
Local _aAreaZZB	:= ZZB->(GetArea())
Local CR		:= chr(13) + chr(10)
Local _cimei	:= ""
Local _cLocal	:= ""
Local _cprod	:= ""
Local _cnfe		:= ""
Local _ccli		:= ""
Local _cloj		:= ""
Local _cNumOsTk	:= ""
Local _lvldem	:= .F.
ZZB->(dbSetOrder(1)) // ZZB_FILIAL + ZZB_CODTEC + ZZB_LAB + ZZB_CODSET + ZZB_CODFAS
SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
Private lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01 - Cliente                   ³
//³mv_par02 - Loja                      ³
//³mv_par03 - Armazens                  ³
//³mv_par04 - Produto Inicial           ³
//³mv_par05 - Produto Final             ³
//³mv_par06 - TES para o Pedido de Venda³
//³mv_par07 - Fase Encerramento         ³
//³mv_par08 - setor Encerramento        ³
//³mv_par09 - Tecnico Encerramento      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If select("TRA") > 0
	TRA->(dbCloseArea())
EndIf
If select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
If Empty(mv_par03)
	MsgBox("Favor digitar o(s) armazens (separados por barras '/').","Armazens","ALERT")
	Return
EndIf
If Empty(mv_par06)
	MsgBox("Favor digitar a TES .","Tipo Entrada/Saida","ALERT")
	Return
EndIf
If !Empty(mv_par09)
	If !ZZB->(dbSeek(xFilial("ZZB") + mv_par09))
		apMsgStop("Codigo de Tecnico nao cadastrado ","Codigo de Tecnico Invalido")
		Return
	Else
		_codtec	:= ZZB->ZZB_CODTEC
		_codlab	:= ZZB->ZZB_LAB
		If !Empty(mv_par08)
			If !ZZB->(dbSeek(xFilial("ZZB") + _codtec+_codlab+mv_par08))
				apMsgStop("Setor não cadastrado na amarração Tecnico x Fase ","Setor Invalido")
				Return
			Else
				_codset	:= ZZB->ZZB_CODSET
				If !Empty(mv_par07)
					If !ZZB->(dbSeek(xFilial("ZZB") + _codtec+_codlab+_codset+mv_par07))
						apMsgStop("Fase não cadastrada na amarração Tecnico x Fase ","Fase Invalido")
						Return
					Else
						_codfas	:= ZZB->ZZB_CODFAS
						If ZZ1->(dbSeek(xFilial("ZZ1") + _codlab+_codset+_codfas))
							If !ZZ1->ZZ1_ENCOS="S"
								apMsgStop("Esta nao é uma Fase de encerramento da OS. Escolha outra fase ","Fase Invalido")
								Return
							EndIf
						Else
							apMsgStop("Fase não cadastrada ","Fase Invalido")
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
_cSele2 := " SELECT COUNT(*) 'QTREG' "
//_cSele1 := CR + " SELECT B6.* , D1_ITEM, D1_QUANT,D1_VUNIT,D1_IDENTB6, ZZ4_IMEI, D1_NUMSER, D1_DIVNEG,D1_DTDIGIT,D1RECNO = D1.R_E_C_N_O_, F1RECNO = F1.R_E_C_N_O_, B6RECNO = B6.R_E_C_N_O_ "  // M.Munhoz - 21/08/2011 - Substiuicao do D1_NUMSER pelo ZZ4_IMEI
_cSele1 := CR + " SELECT B6.* , D1_ITEM, D1_QUANT,D1_VUNIT,D1_IDENTB6, ZZ4_IMEI, D1_NUMSER, D1_DIVNEG,D1_DTDIGIT,D1RECNO = D1.R_E_C_N_O_, F1RECNO = F1.R_E_C_N_O_, B6RECNO = B6.R_E_C_N_O_ "
_cQuery += CR + " FROM "+RetSqlName("SB6")+" AS B6 (nolock) "
_cQuery += CR + " JOIN "+RetSqlName("SD1")+" AS D1 (nolock) "
_cQuery += CR + " ON B6_FILIAL = D1_FILIAL AND B6_DOC = D1_DOC AND B6_SERIE = D1_SERIE AND B6_DTDIGIT = D1_DTDIGIT AND B6_IDENT = D1_IDENTB6 AND D1.D_E_L_E_T_ = '' "
_cQuery += CR + " JOIN "+RetSqlName("SF1")+" AS F1 (nolock) "
_cQuery += CR + " ON B6_FILIAL = F1_FILIAL AND B6_DOC = F1_DOC AND B6_SERIE = F1_SERIE AND B6_DTDIGIT = F1_DTDIGIT AND B6_CLIFor = F1_FORNECE AND B6_LOJA = F1_LOJA AND F1.D_E_L_E_T_ = '' "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³M.Munhoz - 21/08/2011 - Substituicao do D1_NUMSER pelo ZZ4_IMEI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery += CR + " JOIN "+RetSqlName("ZZ4")+" AS ZZ4 (nolock) "
_cQuery += CR + " ON ZZ4_FILIAL = D1_FILIAL AND ZZ4_NFENR = D1_DOC AND ZZ4_NFESER = D1_SERIE AND ZZ4_CODCLI = D1_FORNECE AND ZZ4_LOJA = D1_LOJA AND ZZ4_CODPRO = D1_COD AND ZZ4_ITEMD1 = D1_ITEM AND ZZ4.D_E_L_E_T_ = '' "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluso esse inner joins para desconsiderar produtos e ou cliente bloqueados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery += CR + " INNER JOIN ( SELECT B1_COD,B1_TIPO,B1_MSBLQL FROM "+RetSqlName("SB1")+" AS B1 (nolock) "
_cQuery += CR + " WHERE D_E_L_E_T_='' AND B1_MSBLQL<>'1' ) AS B1 "
_cQuery += CR + " ON B6_PRODUTO=B1_COD "
/*
_cQuery += CR + " INNER JOIN ( SELECT A1_COD,A1_LOJA,A1_MSBLQL FROM "+RetSqlName("SA1")+" AS A1 (nolock) "
_cQuery += CR + " WHERE D_E_L_E_T_='' AND A1_MSBLQL<>'1' ) AS A1 "
_cQuery += CR + " ON A1_COD=B6_CLIFor AND A1_LOJA=B6_LOJA "
Incluso esse inner join para desconsiderar produtos e saldo em aberto que já tem pedidos colocados
_cQuery += CR + " LEFT OUTER JOIN (SELECT C6_FILIAL,C6_CLI,C6_LOJA,C6_PRODUTO,C6_LOCAL,C6_IDENTB6,C6_QTDVEN-C6_QTDENT AS SALDOSC6 "
_cQuery += CR + " FROM "+RetSqlName("SC6")+" WHERE C6_FILIAL='"+xFilial("SC6")+"' AND '"+AllTrim(mv_par03)+"' LIKE '%'+C6_LOCAL+'%' "
_cQuery += CR + " AND D_E_L_E_T_='' AND C6_QTDVEN-C6_QTDENT > 0) AS SC6 "
_cQuery += CR + " ON C6_FILIAL=B6_FILIAL AND C6_CLI=B6_CLIFor AND C6_LOJA=B6_LOJA AND C6_PRODUTO=B6_PRODUTO "
_cQuery += CR + " AND C6_LOCAL=B6_Local AND C6_IDENTB6=B6_IDENT AND B6_LOCAL=C6_Local "
*/
_cQuery += CR + " WHERE B6.D_E_L_E_T_ = '' "
_cQuery += CR + " AND B6_FILIAL = '"+xFilial("SB6")+"' "
_cQuery += CR + " AND B6_TIPO = 'D' "
_cQuery += CR + " AND B6_PODER3 = 'R' "
_cQuery += CR + " AND B6_SALDO > 0 "
If !Empty(mv_par01)
	_cQuery += CR + " AND B6_CLIFor = '"+mv_par01+"' "
EndIf
If !Empty(mv_par02)
	_cQuery += CR + " AND B6_LOJA = '"+mv_par02+"' "
EndIf
_cQuery += CR + " AND '"+AllTrim(mv_par03)+"' LIKE '%'+B6.B6_LOCAL+'%' "
_cQuery += CR + " AND B6_PRODUTO >= '"+mv_par04+"' "
If !Empty(mv_par05)
	_cQuery += CR + " AND B6_PRODUTO <= '"+mv_par05+"' "
Else
	_cQuery += CR + " AND B6_PRODUTO <= 'ZZZZZZZZZZZZZZZ' "
EndIf
//_cQuery += CR + " AND SALDOSC6 IS NULL "
_cOrder := CR + " ORDER BY B6.B6_CLIFOR,B6.B6_LOJA,B6.B6_DOC,B6.B6_SERIE,B6.B6_PRODUTO,B6.B6_LOCAL,B6.B6_PRUNIT "
//memowrite("fata002.sql",_cSele1 + _cQuery + _cOrder)
_cSele1 := strtran(_cSele1,CR,"")
_cQuery := strtran(_cQuery,CR,"")
_cOrder := strtran(_cOrder,CR,"")
TCQUERY _cSele2 + _cQuery NEW ALIAS "TRA"
TRA->(dbGoTop())
Procregua(TRA->QTREG)
TRA->(dbCloseArea())
TCQUERY _cSele1 + _cQuery + _cOrder NEW ALIAS "TRB"
TRB->(dbGoTop())
While !TRB->(Eof())
//	_cimei		:=TRB->D1_NUMSER						// M.Munhoz - 21/08/2011 - Substiuicao do D1_NUMSER pelo ZZ4_IMEI
	_cimei		:= TRB->ZZ4_IMEI
	_cos		:= ""
	_cpv		:= ""
	_cLocal		:= TRB->B6_LOCAL
	_cprod		:= TRB->B6_PRODUTO
	_cnfe		:= TRB->B6_DOC
	_cserie		:= TRB->B6_SERIE
	_cident		:= TRB->B6_IDENT
	_citem		:= TRB->D1_ITEM
	_ccli		:= TRB->B6_CLIFOR
	_cloj		:= TRB->B6_LOJA
	_nqtde		:= TRB->D1_QUANT
	_nsald		:= TRB->B6_SALDO
	_nvunit		:= TRB->D1_VUNIT
	_divneg		:= TRB->D1_DIVNEG
	_cstazz4	:= Space(1)
	_cimei		:= Space(nTamime)
	_cos		:= Space(6)
	_cpv		:= Space(8)
	_carcac		:= Space(nTamime)
	_cswant		:= Space(nTamime)
	_cswap		:= Space(nTamime)
	_coper		:= ""
	_ckit		:= ""
	_copebgh	:= ""
	_ccor		:= ""
	_nreczz4	:= 0
	_ddtnfe		:= TRB->D1_DTDIGIT
	IncProc()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo saldo disponivel de Terceiros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nSalP3	:= SalDisP3(TRB->B6_IDENT,TRB->B6_SALDO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o IDENTB6 nao possuir saldo, procuro pelo primeiro item da NF no SB6 com saldo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nSalP3 < 1
		TRB->(dbSkip())
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se tem Entrada massiva.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZZ4->(dbSetOrder(3)) //ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_IMEI
//	If ZZ4->(dbSeek(xFilial('ZZ4')+TRB->B6_DOC+TRB->B6_SERIE+ TRB->B6_CLIFOR+TRB->B6_LOJA+TRB->B6_PRODUTO+TRB->D1_NUMSER))	// M.Munhoz - 21/08/2011 - Substiuicao do D1_NUMSER pelo ZZ4_IMEI
	If ZZ4->(dbSeek(xFilial('ZZ4')+TRB->B6_DOC+TRB->B6_SERIE+ TRB->B6_CLIFOR+TRB->B6_LOJA+TRB->B6_PRODUTO+TRB->ZZ4_IMEI))
		_lvldem := .T.
	Else
		ZZ4->(dbSetOrder(7)) //ZZ4_FILIAL+ZZ4_NFENR+ZZ4_NFESER+ZZ4_CODCLI+ZZ4_LOJA+ZZ4_CODPRO+ZZ4_ITEMD1
		If ZZ4->(dbSeek(xFilial('ZZ4')+TRB->B6_DOC+TRB->B6_SERIE+ TRB->B6_CLIFOR+TRB->B6_LOJA+TRB->B6_PRODUTO+TRB->D1_ITEM))
			_lvldem :=.T.
		EndIf
	EndIf
	If _lvldem
		_cstazz4	:= ZZ4->ZZ4_STATUS
		_cimei		:= ZZ4->ZZ4_IMEI
		_cos		:= ZZ4->ZZ4_OS
		_cpv		:= ZZ4->ZZ4_PV
		_carcac		:= ZZ4->ZZ4_CARCAC
		_cswant		:= ZZ4->ZZ4_SWANT
		_cswap		:= ZZ4->ZZ4_SWAP
		_coper		:= ZZ4->ZZ4_OPER
		_ckit		:= ZZ4->ZZ4_KIT
		_copebgh	:= ZZ4->ZZ4_OPEBGH
		_ccor		:= ZZ4->ZZ4_COR
		_ddtnfe		:= ZZ4->ZZ4_NFEDT
		_nreczz4	:= ZZ4->(RECNO())
		If Empty(MV_PAR07) .OR. Empty(MV_PAR08) .OR. Empty(MV_PAR09)
			apMsgInfo("Caro usuário, existem movimentacoes de Entrada/saida Massiva, portanto é OBRIGATORIO informar FASE, SETOR E TECNICO","Fase. setor ou tecnico não Preenchido")
			Return
		Else
			AADD(_agpvesm,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_cident,_nqtde,_nsald,_nvunit,_cstazz4,_codtec ,_codfas , _codset ,_codlab,_cpv,_carcac,_cswant,_cswap,_coper,_ckit,_copebgh,_ccor,_nreczz4,_divneg,_citem,_ddtnfe})
		EndIf
	Else
		AADD(_agerapv,{_cimei,_cos,_clocal,_cprod,_cnfe,_cserie,_ccli,_cloj,_cident,_nqtde,_nsald,_nvunit,_cstazz4,_codtec,_codfas , _codset ,_codlab,_cpv,_carcac,_cswant,_cswap,_coper,_ckit,_copebgh,_ccor,_nreczz4,_divneg,_citem,_ddtnfe})
	EndIf
	TRB->(dbSkip())
EndDo
TRB->(dbCloseArea())
RestArea(_aAreaSD1)
RestArea(_aAreaSF1)
RestArea(_aAreaSB6)
RestArea(_aAreaSB1)
RestArea(_aAreaSA1)
RestArea(_aAreaZZ4)
RestArea(_aAreaZZB)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Encatend ºAutor  ³Edson Rodrigues     º Data ³  13/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que verifica e faz o apontamento de fase e encerra  º±±
±±º          ³ o atendimento do aparelho no laboratório                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Encatend()
Local bAcao		:= {|lFim| Runatend(@lFim) }
Local cTitulo	:= ""
Local cMsg		:= "Processando apontamentos/Encerrando OS..."
Local lAborta	:= .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RUNATEND ºAutor  ³Edson Rodrigues     º Data ³  13/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo que verifica e faz o apontamento de fase e encerraº±±
±±º          ³ o atendimento do aparelho no laboratório                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Runatend(lFim)
Procregua(Len(_agpvesm))
For X:=1 to Len(_agpvesm)
	IncProc()
	lverab6		:= .F.
	lverab7		:= .F.
	ctipob6		:= ""
	ctipob7		:= ""
	cstazz30	:= ""
	cstazz31	:= ""
	linclZZ3	:= .F.
	_cVerFs0	:= ""
	_cVerFs1	:= ""
	_capontenc	:= ""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se tem apontado com status 0.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cVerFs0	:= u_verfancf(_agpvesm[x,1],AllTrim(_agpvesm[x,2]))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se tem apontamento com status 1.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cVerFs1	:= u_VerFasAtu(_agpvesm[x,1],AllTrim(_agpvesm[x,2]))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se tem apontamento confirmado encerrado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_capontenc	:= u_VerEncer(_agpvesm[x,1],AllTrim(_agpvesm[x,2]))
	If AB6->(dbSeek(xFilial("AB6") + AllTrim(_agpvesm[x,2])))
		lverab6	:=.T.
		ctipob6	:=AB6->AB6_STATUS
	EndIf
	If (AB7->(dbSeek(xFilial("AB7") + AllTrim(_agpvesm[x,2])+_agpvesm[x,1] )))
		lverab7	:=.T.
		ctipob7	:=AB7->AB7_TIPO
	EndIf
	If Empty(_cVerFs0) .AND. Empty(_cVerFs1) .AND. Empty(_capontenc)
		linclZZ3:= .T.
	ElseIf !Empty(_cVerFs0) .AND. Empty(_cVerFs1) .AND. Empty(_capontenc)
		linclZZ3:=.T.
		cstazz30:= "0"
	ElseIf Empty(_cVerFs0) .AND. !Empty(_cVerFs1) .AND. Empty(_capontenc)
		linclZZ3:=.T.
		cstazz31:= "1"
	ElseIf !Empty(_cVerFs0) .AND. !Empty(_cVerFs1) .AND. Empty(_capontenc)
		linclZZ3:=.T.
		cstazz30:="0"
		cstazz31:="1"
	ElseIf !Empty(_cVerFs0) .AND. !Empty(_cVerFs1) .AND. !Empty(_capontenc)
		cstazz30:="0"
		cstazz31:="1"
	ElseIf !Empty(_cVerFs0) .AND. Empty(_cVerFs1).AND. !Empty(_capontenc)
		cstazz30:="0"
	ElseIf Empty(_cVerFs0) .AND. !Empty(_cVerFs1).AND. !Empty(_capontenc)
		cstazz31:="1"
	EndIf
	inclapo(_agpvesm[x,1],AllTrim(_agpvesm[x,2]),_agpvesm[x,4],_agpvesm[x,7],_agpvesm[x,8],linclZZ3,cstazz30,cstazz31,_agpvesm[x,13],lverab6,ctipob6,lverab7,ctipob7,_agpvesm[x,14],_agpvesm[x,15],_agpvesm[x,16],_agpvesm[x,17],_agpvesm[x,18],_agpvesm[x,19],_agpvesm[x,20],_agpvesm[x,21],_agpvesm[x,22],_agpvesm[x,23],_agpvesm[x,24],_agpvesm[x,5],_agpvesm[x,6],_agpvesm[x,25],_agpvesm[x,26],_agpvesm[x,29],_agpvesm[x,3],_agpvesm[x,9],_agpvesm[x,10],_agpvesm[x,11],_agpvesm[x,12],_agpvesm[x,27],_agpvesm[x,28])
Next
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³inclapo   ºAutor  ³Edson Rodrigues     º Data ³  15/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Incluir e encerrar apontamento automatica.     º±±
±±º          ³ mentes                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function inclapo(cimei,cos,cprod,ccli,cloja,linclZZ3,cstazz30,cstazz31,cstazz4,lverab6,ctipob6,lverab7,ctipob7,codtec,cfase,csetor,clab,cpv,carcac,cswant,cswap,coper,ckit,copebgh,cnfe,cserie,ccor,nreczz4,ddtnfe,clocal,cident,nqtde,nsald,nvunit,divneg,citem)
Local _aAreaZZ4:= ZZ4->(GetArea())
Local _aAreaAB7:= AB7->(GetArea())
Local _aAreaAB6:= AB6->(GetArea())
lupdzz4:=.F.
lupdab6:=.F.
lupdab7:=.F.
linsab6:=.F.
linsab7:=.F.
cContVez:=0
_cdefcli:=""
_cDefSeq:= "00"
If cstazz4 >= "3" .AND. cstazz4 <= "7"
	lupdzz4:=.T.
ElseIf cstazz4 >= "8" .AND. cstazz4 <= "9" .AND. !Empty(cpv)
	lupdzz4		:=.F.
	linclZZ3	:=.F.
ElseIf cstazz4 >= "8" .AND. cstazz4 <= "9" .AND. Empty(cpv)
	lupdzz4		:=.T.
EndIf

If lverab6 .AND. ctipob6 <> "B"
	lupdab6		:=.T.
	
ElseIf !lverab6
	linsab6		:=.T.
EndIf
If lverab7 .AND. ctipob7 <> "4"
	lupdab7		:=.T.
ElseIf !lverab7
	linsab7		:=.T.
EndIf
If lupdzz4
	ZZ4->(dbgoto(nreczz4))
	RecLock("ZZ4",.F.)
	ZZ4->ZZ4_STATUS := "5"
	MsUnlock()
EndIf
ZZ4->(dbSetOrder(1)) //ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
If ZZ4->(dbSeek(xFilial("ZZ4") + cimei))
	While ZZ4->(!Eof()) .AND. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .AND. AllTrim(ZZ4->ZZ4_IMEI) == AllTrim(cimei)
		If ((ZZ4->ZZ4_NFENR <> cnfe) .OR. ZZ4->ZZ4_NFESER <> cserie ) .AND. ZZ4->ZZ4_NFEDT < ddtnfe
			cContVez++
		EndIf
		ZZ4->(dbSkip())
	EndDo
EndIf
_cNrCham := GetAdvFVal("AB2","AB2_NRCHAM",xFilial("AB2") + cimei + left(cos,6) + "01", 5,"") // AB2_FILIAL + AB2_NUMSER + AB2_NUMOS
If AB1->(dbSeek(xFilial("AB1") + _cNrCham ))
	_dChamEmis := AB1->AB1_EMISSA
	_cChamHora := AB1->AB1_HORA
Else
	_dChamEmis := date()
	_cChamHora := time()
EndIf
If linsab6
	If !AB6->(dbSeek(xFilial("AB6") + AllTrim(cos)))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ORDEM DE SERVICO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumOS:= GetSxeNum("AB6","AB6_NUMOS")
		RecLock("AB6",.T.)
		AB6->AB6_FILIAL	:= xFilial("AB6")
		AB6->AB6_NUMOS	:= cos
		AB6->AB6_CODCLI	:= ccli
		AB6->AB6_LOJA	:= cloja
		AB6->AB6_OPER	:= coper
		AB6->AB6_EMISSA	:= dDataBase
		AB6->AB6_ATEND	:= cUserName
		AB6->AB6_STATUS	:= "B"
		AB6->AB6_HORA	:= TIME()
		AB6->AB6_CONPAG	:= "001" //A vista
		AB6->AB6_BGHKIT	:= ckit
		AB6->AB6_OPER	:= coper
		AB6->AB6_NumVez	:= StrZero(cContVez+1,1)
		AB6->AB6_SWAPAN	:= Iif(!Empty(cswap),"S","N")
		MsUnlock("AB6")
		ConfirmSX8()
	EndIf
	AB6->(dbSeek(xFilial("AB6") + cos))
Else
	AB6->(dbSeek(xFilial("AB6") + cos))
EndIf
If linsab7
	AB7->(dbSetOrder(1)) //AB7_FILIAL + AB7_NUMOS + AB7_ITEM
	If !(AB7->(dbSeek(xFilial("AB7") + cOs+"01")))
		cItens:="01"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava Itens da Ordem de Serviço.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("AB7",.T.)
		AB7->AB7_FILIAL	:= xFilial("AB7")
		AB7->AB7_NUMOS	:= cOs
		AB7->AB7_NRCHAM	:= _cNrCham+"01"
		AB7->AB7_ITEM	:= cItens
		AB7->AB7_CODCLI	:= ccli
		AB7->AB7_LOJA	:= cloja
		AB7->AB7_EMISSA	:= dDatabase
		AB7->AB7_CODPRO	:= cprod
		AB7->AB7_NUMSER	:= cimei
		AB7->AB7_PRCCOM	:= 0
		AB7->AB7_TIPO	:= "1"
		AB7->AB7_CODPRB	:= "000001" //Box Failure
		AB7->AB7_NumVez	:= StrZero(cContVez+1,1)
		AB7->AB7_SWAPAN	:= cswap
		AB7->AB7_CODFAB	:= ccli
		AB7->AB7_LOJAFA	:= cloja
		MsUnlock("AB7")
		AB7->(dbSeek(xFilial("AB7") +cOs+ cimei))
	Else
		RecLock("AB7",.F.)
		AB7->AB7_CODCLI	:= ccli
		AB7->AB7_LOJA	:= cloja
		AB7->AB7_CODPRO	:= cprod
		AB7->AB7_NUMSER	:= cimei
		AB7->AB7_NumVez	:= StrZero(cContVez+1,1)
		AB7->AB7_CODFAB	:= ccli
		AB7->AB7_LOJAFA	:= cloja
		MsUnlock("AB7")
	EndIf
Else
	AB7->(dbSeek(xFilial("AB7") +cOs+ cimei))
EndIf
If lupdab6
	RecLock("AB6",.F.)
	AB6->AB6_STATUS	:= "B"
	MsUnlock()
EndIf
If lupdab7
	RecLock("AB7",.F.)
	AB7->AB7_TIPO	:= "4"
	MsUnlock()
EndIf
If linclZZ3
	_cseq:=u_CalcSeq(cimei,cos)
	If !AB9->(dbSeek(xFilial("AB9") + LEFT(cos,6)+'01'+codtec+_cseq))
		RecLock("AB9",.T.)
		AB9->AB9_FILIAL	:= xFilial("AB9")
		AB9->AB9_SN		:= AllTrim(cimei)
		AB9->AB9_NRCHAM	:= _cNrCham
		AB9->AB9_NUMOS	:= left(cos,6)+"01"
		AB9->AB9_CODTEC	:= codtec
		AB9->AB9_SEQ	:= _cseq
		AB9->AB9_DTCHEG	:= _dChamEmis
		AB9->AB9_HRCHEG	:= _cChamHora
		AB9->AB9_DTINI	:= _dChamEmis
		AB9->AB9_HRINI	:= _cChamHora
		AB9->AB9_DTSAID	:= date()
		AB9->AB9_HRSAID	:= time()
		AB9->AB9_DTFIM	:= date()
		AB9->AB9_HRFIM	:= time()
		AB9->AB9_CODPRB	:= AB7->AB7_CODPRB
		AB9->AB9_GARANT	:= "N"
		AB9->AB9_TIPO	:= "1"
		AB9->AB9_CODCLI	:= ccli
		AB9->AB9_LOJA	:= cloja
		AB9->AB9_CODPRO	:= cprod
		AB9->AB9_TOTFAT	:= "01:00"
		AB9->AB9_BGHKIT	:= AB6->AB6_BGHKIT
		AB9->AB9_STATAR	:= "1" // 1=Tarefa encerrada / 2=Tarefa em aberto
		AB9->AB9_NUMVEZ	:= AB6->AB6_NUMVEZ
		AB9->AB9_SERIAL	:= carcac
		AB9->AB9_XTREPA	:= time()
		AB9->AB9_SWAPAN	:= cswant
		AB9->AB9_XTCENC	:= codtec
		AB9->AB9_NOVOSN	:= cswap
		AB9->AB9_OPER	:= coper
		MsUnlock()
	EndIf
	_cvreccli :=Posicione("ZZJ",1,xFilial("ZZJ") + copebgh+clab, "ZZJ_VRECLI")
	//If _cvreccli="S" .AND. SZA->(dbSeek(xFilial("SZA")+ccli+cloja+cnfe+cserie+ LEFT(cimei,15)))
	If _cvreccli="S" .AND. SZA->(dbSeek(xFilial("SZA")+ccli+cloja+cnfe+cserie+ cimei))
		If !Empty(SZA->ZA_DEFRECL)
			_cdefcli:= left(SZA->ZA_DEFRECL,5)
		Else
			u_Verdef(cimei,ccli,cloja,cnfe,cserie,clab)
			_cdefcli:= left(_cDefRec,5)
		EndIf
	EndIf
	RecLock("ZZ3",.T.)
	ZZ3->ZZ3_FILIAL	:= xFilial("ZZ3")
	ZZ3->ZZ3_CODTEC	:= codtec
	ZZ3->ZZ3_LAB	:= clab
	ZZ3->ZZ3_DATA	:= date()
	ZZ3->ZZ3_HORA	:= Time()
	ZZ3->ZZ3_CODSET	:= csetor
	ZZ3->ZZ3_FASE1	:= cfase
	ZZ3->ZZ3_FASE2	:= cfase
	ZZ3->ZZ3_CODSE2	:= csetor
	ZZ3->ZZ3_DEFINF	:= _cdefcli
	ZZ3->ZZ3_DEFDET	:= ""
	ZZ3->ZZ3_ACAO	:= ""
	ZZ3->ZZ3_LAUDO	:= ""
	ZZ3->ZZ3_COR	:= ccor
	ZZ3->ZZ3_ENCOS	:= "S"
	ZZ3->ZZ3_IMEI	:= cimei
	ZZ3->ZZ3_DPYIME	:= ""
	ZZ3->ZZ3_SWAP	:= ""
	ZZ3->ZZ3_IMEISW	:= ""
	ZZ3->ZZ3_MODSW	:= ""
	ZZ3->ZZ3_DPYINV	:= ""
	ZZ3->ZZ3_CTROCA	:= ""
	ZZ3->ZZ3_UPGRAD	:= ""
	ZZ3->ZZ3_STATUS	:= "1"
	ZZ3->ZZ3_NUMOS	:= cos
	ZZ3->ZZ3_LOTIRL	:= ""
	ZZ3->ZZ3_SEQ	:= _cseq
	ZZ3->ZZ3_USER	:= cUserName
	ZZ3->ZZ3_ARTIME	:= ""
	ZZ3->ZZ3_MINUMB	:= ""
	ZZ3->ZZ3_STATRA	:= "1" // incluso Edson Rodrigues 27/07/10
	ZZ3->ZZ3_ASCRAP	:= getadvfval("ZZ1","ZZ1_SCRAP",xFilial("ZZ1") + clab + AllTrim(LEFT(csetor,6)) + cfase, 1, "N")
	MsUnlock()
	ZZ4->(dbgoto(nreczz4))
	_aFasMax := {,,,}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incluso parametro setor atual ou origem na funcao abaixo -Edson Rodrigues 13/12/10.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aFasMax := u_FasMax(ZZ4->ZZ4_LOCAL, ZZ4->ZZ4_GRMAX, Iif(!Empty( cfase), cfase, cfase),Iif(!Empty(csetor),csetor,csetor) )
	RecLock("ZZ4",.F.)
	ZZ4->ZZ4_SETATU	:= csetor
	ZZ4->ZZ4_FASATU	:= cfase
	ZZ4->ZZ4_STATUS	:= "5"
	ZZ4->ZZ4_DEFINF	:= Left(_cdefcli,5)
	ZZ4->ZZ4_COR	:= Iif( Empty(ZZ4->ZZ4_COR), ZZ3->ZZ3_COR, ZZ4->ZZ4_COR)
	ZZ4->ZZ4_ATPRI	:= Iif( Empty(ZZ4->ZZ4_ATPRI) , dtos(date())+time(), ZZ4->ZZ4_ATPRI)
	ZZ4->ZZ4_ATULT	:= dtos(date())+time()
	ZZ4->ZZ4_SEQZZ3	:= _cDefSeq
	If !Empty(_aFasMax[1])
		ZZ4->ZZ4_FASMAX	:= _aFasMax[1]
//		ZZ4->ZZ4_DFAMAX	:= _aFasMax[2]
		ZZ4->ZZ4_GRMAX	:= _aFasMax[3]
		ZZ4->ZZ4_SETMAX	:= _aFasMax[4]
	EndIf
	MsUnlock()
	aadd(_aencmas,{cos,cimei,nreczz4})
Else
	If lupdzz4
		aadd(_aencmas,{cos,cimei,nreczz4})
	ElseIf cstazz4 $ "8/9" .AND. !Empty(cpv) //Se a OS esta com pedido gerado ou já teve nota de saida
		AADD(_agerapv,{cimei,cos,clocal,cprod,cnfe,cserie,ccli,cloja,cident,nqtde,nsald,nvunit,cstazz4,codtec,cfase,csetor,clab,cpv,carcac,cswant,cswap,coper,ckit,copebgh,ccor,nreczz4,divneg,citem,ddtnfe})
	EndIf
EndIf
RestArea(_aAreaZZ4)
RestArea(_aAreaAB7)
RestArea(_aAreaAB6)
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ encmas   ºAutor  ³Edson Rodrigues     º Data ³  14/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz a saida massiva e gera o pedido de saida    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EncMas()
Local bAcao		:= {|lFim| Runencm(@lFim) }
Local cTitulo	:= ""
Local cMsg		:= "Processando saida massiva e gerando PV de saida..."
Local lAborta	:= .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Runencm  ºAutor  ³Edson Rodrigues     º Data ³  14/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz a saida massiva e gera o pedido de saida    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunEncm(lFim)
Local cVarBar	:= Replicate(" ",20)
Local cVarSIM	:= Replicate(" ",20)
Local _lAuto	:= .T.
Procregua(Len(_aencmas))
For x:=1 to Len(_aencmas)
	IncProc()
	//U_tecx012grv(_aencmas[x,2],cTexto,_aencmas[x,2],_lAuto)
	AADD(_SerSai, _aencmas[x,2])
	//Begin Transaction
	ZZ4->(dbgoto(_aencmas[x,3]))
	RecLock("ZZ4",.F.)
	ZZ4->ZZ4_STATUS	:= "6"			// Saida Massiva lida/apontada
	ZZ4->ZZ4_SMUSER	:= cUserName	// Nome do usuario que gerou a Saida Massiva
	ZZ4->ZZ4_SMDT	:= dDataBase	// Data da Saida Massiva
	ZZ4->ZZ4_SMHR	:= Time()		// Horario da Saida Massiva
	MsUnlock("ZZ4")
Next
If Len(_SerSai) > 0
	u_tecx012c(_lAuto)
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ pvgera   ºAutor  ³Edson Rodrigues     º Data ³  14/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz a saida massiva e gera o pedido de saida    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function pvgera()
Local bAcao		:= {|lFim| rungpv(@lFim) }
Local cTitulo	:= ""
Local cMsg		:= "Processando PV Sem E/S massiva..."
Local lAborta	:= .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rungpv   ºAutor  ³Edson Rodrigues     º Data ³  15/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que o pedido de saida  qdo nao tem saida massiva    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function rungpv()
Local _lAltMen	:= .F.
Local _cproduct	:= Space(15)
Local _cpropeca	:= ""
Local _nprcven	:= 0.00
Local _lRet		:= .T.
Local _ctransp	:= ""
Local _newnf	:= Space(nTamNfs)
Local _newsnf	:= Space(nTamser)
Local _newcli	:= Space(nTamcli)
Local _newloj	:= Space( 2)
Local _nConPED	:= 0
_aCabSC5		:= {}
_aIteSC6		:= {}
Procregua(Len(_agerapv))
For x:=1 to Len(_agerapv)
	IncProc()
	_nSalP3 := SalDisP3(_agerapv[x,9],_agerapv[x,11])
	If _nSalP3 >= 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Geracao dos Cabecalhos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cmenpad	:= ""
		cKit		:= ""
		_cdivneg	:= _agerapv[x,27]
		_aCabSC5	:= {}
		_aIteSC6	:= {}
		_ctransp	:= Iif(Empty(_ctransp),SA1->A1_TRANSP,_ctransp)
		_cmenpad	:= Iif(Empty(_cmenpad),SA1->A1_MENSAGE,_cmenpad)
		_cdivneg	:= Iif(Empty(_cdivneg),'09',_cdivneg)
		_aAreaSC5	:= SC5->(GetArea())
		_nConPED++
		_cnewprod	:= Space(15)
		_cnewloc	:= Space(2)
		cItens		:= "00"
		_aCabSC5	:= {;
						{"C5_TIPO"		,"N"				,Nil},;
						{"C5_CLIENTE"	,_agerapv[x,7]		,Nil},;
						{"C5_LOJACLI"	,_agerapv[x,8]		,Nil},;
						{"C5_LOJAENT"	,_agerapv[x,8]		,Nil},;
						{"C5_TIPOCLI"	,"F"				,Nil},;
						{"C5_CONDPAG"	,"001"				,Nil},;
						{"C5_TIPLIB"	,"1"				,Nil},;
						{"C5_TPCARGA"	,"2"				,Nil},;
						{"C5_B_KIT"		,cKit				,Nil},;
						{"C5_XUSER"		,AllTrim(cusername)	,Nil},;
						{"C5_TRANSP"	,_ctransp			,Nil},;
						{"C5_MENPAD"	,_cmenpad			,Nil},;
						{"C5_DIVNEG"	,_cdivneg			,Nil},;
						{"C5_MENNOTA"	,""					,Nil}}
		If ((_newnf <> _agerapv[x,5]) .OR. (_newsnf <> _agerapv[x,6]) .OR. (_newcli <> _agerapv[x,7]) .OR. (_newloj <> _agerapv[x,8]))
			_newnf		:= _agerapv[x,5]
			_newsnf		:= _agerapv[x,6]
			_newcli		:= _agerapv[x,7]
			_newloj		:= _agerapv[x,8]
			_cnewprod	:= _agerapv[x,4]
			_cnewloc	:= _agerapv[x,3]
			For ix:=_nConPED to Len(_agerapv)
				If _newnf == _agerapv[ix,5] .AND. _newsnf == _agerapv[ix,6] .AND. _newcli == _agerapv[ix,7] .AND. _newloj == _agerapv[ix,8] .AND. _agerapv[ix,3] == _cnewloc
					SB1->(dbSeek(xFilial('SB1')+_agerapv[ix,4]))
					SA1->(dbSeek(xFilial('SA1')+_agerapv[ix,7]+_agerapv[ix,8]))
					_cIdentB6	:= _agerapv[ix,9]
					_citem		:= _agerapv[ix,28]
					_nPrcVen	:= _agerapv[ix,12]
					_nqtde		:= _agerapv[ix,11]
					_citLocal	:= _agerapv[ix,3]
					_lAchouSB6	:= verester(_newnf,_newsnf,_newcli,_newloj,_cnewprod,@_citem,@_cIdentB6,_nqtde)
					If _lAchouSB6 //Incluso variavel _lAchouSB6 para retirar o loop // Edson Rodrigues - 14/06/10
						cItens	:= Soma1(cItens,2)
						Aadd(_aIteSC6,{;
										{"C6_ITEM"		,cItens				,Nil},;
										{"C6_PRODUTO"	,_cnewprod			,Nil},;
										{"C6_DESCRI"	,SB1->B1_DESC		,Nil},;
										{"C6_TES"		,_cTes				,Nil},;
										{"C6_QTDVEN"	,_nqtde				,Nil},;
										{"C6_QTDLIB"	,_nqtde				,Nil},;
										{"C6_NUMSERI"	,""					,Nil},;
										{"C6_NUMOS"		,""					,Nil},;
										{"C6_PRCVEN"	,_nPrcVen			,Nil},;
										{"C6_VALOR"		,_nqtde * _nPrcVen	,Nil},;
										{"C6_PRUNIT"	,0					,Nil},;
										{"C6_NFORI"		,_newnf				,Nil},;
										{"C6_SERIORI"	,_newsnf			,Nil},;
										{"C6_ITEMORI"	,_citem				,Nil},;
										{"C6_IDENTB6"	,_cIdentB6			,Nil},;
										{"C6_PRCCOMP"	,0					,Nil},;
										{"C6_LOCAL"		,_citLocal			,Nil},;
										{"C6_ENTREG"	,dDataBase			,Nil},;
										{"C6_AIMPGVS"	,""					,Nil}})
					EndIf
				EndIf
			Next IX
			If Len(_aCabSC5) > 0 .AND. Len(_aIteSC6) > 0
				lRet := u_geraPV(_aCabSC5,_aIteSC6, 3)		//Inclusao de novo PV
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se gerou erro no PV pela rotina padrao, forca a gravacao pelo RecLock.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !_lRet
				_lRet:=.T.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Geracao dos Cabecalhos.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SA1->(dbSeek(xFilial('SA1')+_aCabSC5[2,2]+_aCabSC5[3,2]))
				_cCFIni := "0"
				If Subs(SA1->A1_EST,1,2) == "EX"
					_cCFIni := "7"
				ElseIf AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
					_cCFIni := "6"
				Else
					_cCFIni := "5"
				EndIf
				cNrPV:= GetSxeNum("SC5","C5_NUM")
				RecLock("SC5",.T.)
				SC5->C5_FILIAL	:= xFilial("SC5")
				SC5->C5_NUM		:= cNrPV
				SC5->C5_TIPO	:= _aCabSC5[ 1,2]
				SC5->C5_CLIENTE	:= _aCabSC5[ 2,2]
				SC5->C5_LOJACLI	:= _aCabSC5[ 3,2]
				SC5->C5_CLIENT	:= _aCabSC5[ 2,2]
				SC5->C5_LOJAENT	:= _aCabSC5[ 4,2]
				SC5->C5_TIPOCLI	:= _aCabSC5[ 5,2]
				SC5->C5_CONDPAG	:= _aCabSC5[ 6,2]
				SC5->C5_EMISSAO	:= dDatabase
				SC5->C5_MOEDA	:= 1
				SC5->C5_TIPLIB	:= _aCabSC5[ 7,2]
				SC5->C5_TPCARGA	:= _aCabSC5[ 8,2]
				SC5->C5_TXMOEDA	:= 1
				SC5->C5_B_KIT	:= _aCabSC5[ 9,2]
				SC5->C5_XUSER	:= _aCabSC5[10,2]
				SC5->C5_TRANSP	:= _aCabSC5[11,2]
				SC5->C5_MENPAD	:= _aCabSC5[12,2]
				SC5->C5_DIVNEG	:= _aCabSC5[13,2]
				SC5->C5_MENNOTA	:= _aCabSC5[14,2]
				MsUnlock("SC5")
				ConfirmSX8()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLXéXé¿
				//³Geracao dos Itens.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL"Ù
				For IX := 1 to Len(_aIteSC6)
					SB1->(dbSeek(xFilial("SB1")+_aIteSC6[IX,2,2]))
					SF4->(dbSeek(xFilial("SF4")+_aIteSC6[IX,4,2]))
					RecLock("SC6",.T.)
					SC6->C6_FILIAL	:= xfilial("SC6")
					SC6->C6_ITEM	:= _aIteSC6[IX,1,2]
					SC6->C6_PRODUTO	:= _aIteSC6[IX,2,2]
					SC6->C6_UM		:= SB1->B1_UM
					SC6->C6_QTDVEN	:= _aIteSC6[IX,5,2]
					SC6->C6_PRCVEN	:= _aIteSC6[IX,9,2]
					SC6->C6_VALOR	:= _aIteSC6[IX,10,2]
					SC6->C6_TES		:= _aIteSC6[IX,4,2]
					SC6->C6_Local	:= _aIteSC6[IX,17,2]
					SC6->C6_CF		:= AllTrim(_cCFIni)+Subs(SF4->F4_CF,2,3)
					SC6->C6_ENTREG	:= dDataBase
					SC6->C6_DESCRI	:= SB1->B1_DESC
					SC6->C6_PRUNIT	:= _aIteSC6[IX,11,2]
					SC6->C6_NFORI	:= _aIteSC6[IX,12,2]
					SC6->C6_SERIORI	:= _aIteSC6[IX,13,2]
					SC6->C6_ITEMORI	:= _aIteSC6[IX,14,2]
					SC6->C6_NUMSERI	:= _aIteSC6[IX,7,2]
					SC6->C6_TPOP	:= "F" //FIRME
					SC6->C6_CLI		:= _aCabSC5[ 2,2]
					SC6->C6_LOJA	:= _aCabSC5[ 3,2]
					SC6->C6_IDENTB6	:= _aIteSC6[IX,15,2]
					SC6->C6_PRCCOMP	:= _aIteSC6[IX,16,2]
					SC6->C6_NUMOS	:= _aIteSC6[IX,8,2]
					MsUnlock("SC6")
				Next IX
			EndIf
		EndIf
	EndIf
Next Nx
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ veresterºAutor  ³Edson Rodrigues      º Data ³  16/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que verifica disponibilizadade estoque terceiroa    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Verester(_newnf,_newsnf,_newcli,_newloj,_cnewprod,_citem,_cIdentB6,_nqtde)
_lAchouSB6	:= .F.
_cB6Acum	:= ""
SF4->(dbSeek(xFilial("SF4")+_cTes))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o IDENTB6 encontrado possui saldo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFor + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
If SB6->(dbSeek(xFilial("SB6") + _newsnf+_newnf+_newcli+_newloj + _cIdentB6 + _cnewprod + "R"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo saldo disponivel de Terceiros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nSalP3 := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o IDENTB6 nao possuir saldo, procuro pelo primeiro item da NF no SB6 com saldo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nSalP3 < 1 .OR. AllTrim(SB6->B6_IDENT) $ _cB6Acum
		SB6->(dbSetOrder(5)) //B6_FILIAL + B6_SERIE + B6_DOC + B6_CLIFor + B6_LOJA + B6_IDENT + B6_PRODUTO + B6_PODER3
		If SB6->(dbSeek(xFilial("SB6") + _newsnf+_newnf+_newcli+_newloj ))
			While SB6->(!Eof()) .AND. SB6->B6_FILIAL == xFilial("SB6") .AND. ;
				SB6->B6_SERIE == _newsnf .AND. SB6->B6_DOC == _newnf .AND. ;
				SB6->B6_CLIFor == _newcli .AND. SB6->B6_LOJA == _newloj
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calculo saldo disponivel de Terceiros.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nSalP3 := SalDisP3(SB6->B6_IDENT , SB6->B6_SALDO)
				If AllTrim(SB6->B6_PRODUTO) == AllTrim(_cnewprod) .AND. ;
					_nSalP3 >= _nqtde .AND. !AllTrim(SB6->B6_IDENT) $ _cB6Acum .AND. SB6->B6_PODER3 == "R"
					_cItemOri	:= ""
					_cIdentB6	:= SB6->B6_IDENT
					_lAchouSB6	:= .T.
					_cB6Acum	+= SB6->B6_IDENT + "/"
					exit
				EndIf
				SB6->(dbSkip())
			EndDo
		EndIf
	Else
		_lAchouSB6 := .T.
		_cB6Acum += SB6->B6_IDENT + "/"
	EndIf
EndIf
Return(_lAchouSB6)
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
Static Function SalDisP3(_cIdent, _nSalSB6)
Local _aAreaSC6		:= SC6->(GetArea())
Local _nSalDisP3	:= _nQtPV3:= 0
SC6->(dbSetOrder(12))			// C6_FILIAL + C6_IDENTB6
If SC6->(dbSeek(xFilial("SC6") + _cIdent ))
	While SC6->(!Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_IDENTB6 == _cIdent
		_nQtPV3 += ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
		SC6->(dbSkip())
	EndDo
EndIf
_nSalDisP3 := _nSalSB6 - _nQtPV3
RestArea(_aAreaSC6)
Return(_nSalDisP3)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRIASX1  ºAutor  ³M.Munhoz - ERPPLUS  º Data ³  10/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para criacao automatica das perguntas (SX1)         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1()
//cGrupo,cOrdem,cPergunt					,cPerSpa					,cPerEng					,cVar		 ,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Cod. Cliente"			,"Cod. Cliente"				,"Cod. Cliente"				,"mv_ch1","C",06,0,0,"G","","SA1"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Loja"					,"Loja"						,"Loja"						,"mv_ch2","C",02,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Armazens :"				,"Armazens : "				,"Armazens :"				,"mv_ch3","C",60,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Produto Inicial"			,"Produto Inicial"			,"Produto Inicial"			,"mv_ch4","C",15,0,0,"G","","SB1"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Produto Final"			,"Produto Final"			,"Produto Final"			,"mv_ch5","C",15,0,0,"G","","SB1"	,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","TES para p PV"			,"TES para p PV"			,"TES para p PV"			,"mv_ch6","C",03,0,0,"G","","SF4"	,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Fase Encerramento"		,"Fase Encerramento"		,"Fase Encerramento"		,"mv_ch7","C",02,0,0,"G","","ZZB_1"	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Setor Encerramento"		,"Setor Encerramento"		,"Setor Encerramento"		,"mv_ch8","C",06,0,0,"G","","ZZB_2"	,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Tecnico Encerramento"	,"Tecnico Encerramento"		,"Tecnico Encerramento"		,"mv_ch9","C",06,0,0,"G","","AA1"	,"",,"mv_par05","","","","","","","","","","","","","","","","")
Return Nil