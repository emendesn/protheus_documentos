#include "rwmake.ch"
User Function M460MARK()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460MARK ºAutor  ³ Edson Rodrigues    º Data ³  08/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao para emissao da N.Fiscal                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Local _Retorno := .T.
Local _Area    :={"SC5","SC6","SC9","SA1","SA2","SB1","SB2","SF4","SE1","SF2","SD2"}
Local AreaLocal:={}
Local _cAlias
Local _nOrdem
Local _nRecno
Local _Produto := {}
Local _Qtde    := {}
Local _Posicao := 0
Local _Query   := ""
Local _cProduto:= ""
Local _cmensa  := ''

u_GerA0003(ProcName())

// Armazena a area corrente no inicio do ponto de entrada
_cAlias := Alias()
_nOrdem := DbSetOrder()
_nRecno := Recno()

// Grava a posicao nas area de acordo com a matriz _Area

_AreaLocal  := {}
For _n := 1 To Len(_Area)
	DbSelectArea(_Area)
	AaDd(_AreaLocal,{Alias(),DbSetOrder(),Recno()})
Next _n
SA1->(DbSetOrder(1))
If Select("VALIDA") > 0
	DbSelectArea("VALIDA")
	DbCloseArea()
Endif
_Query := "Select * from "+RetSqlName("SC9")+ " (nolock) Where C9_FILIAL='"+xFilial("SC9")+"' AND C9_OK = '"+PARAMIXB[1]+"' AND D_E_L_E_T_ = ' '"
_Query := ChangeQuery(_Query)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_Query),"VALIDA",.T.,.T.)
DbSelectArea("VALIDA")
DbGoTop()
While !Eof()
	
	// Verifica se esta marcado
	// Funcao esta retornando Falso quando selecionado.
	
	// A matriz PARAMIXB no elemento 1 esta guardado qual a marca utilizada no momento.
	If VALIDA->C9_OK == PARAMIXB[1] .AND. SUBSTR(VALIDA->C9_BLINF,1,1)=="2"
		ALERT("Pedido : "+VALIDA->C9_PEDIDO+"    Esta Bloqueado manualmente para Faturamento")
		_Retorno := .F.
	Else
		
		If VALIDA->C9_OK == PARAMIXB[1] // Claudia - testar dados cadastrais obrigatorios do cliente
			SC5->(dbSetOrder(1))
			SC5->(dbSeek(xFilial("SC5")+VALIDA->C9_PEDIDO))
			IF !SC5->C5_TIPO$"DB" .And. !SC5->C5_TIPOCLI$"X"
				IF SA1->(DbSeek( XFILIAL("SA1") + VALIDA->C9_CLIENTE + VALIDA->C9_LOJA))
					If Empty(SA1->A1_NOME) .OR. EMPTY(SA1->A1_TIPO) .OR. EMPTY(SA1->A1_CEP) .OR. EMPTY(SA1->A1_END) ;
						.OR. EMPTY(SA1->A1_BAIRRO) .OR. EMPTY(SA1->A1_COD_MUN)  ;
						.OR. EMPTY(SA1->A1_EST) 	   .OR. EMPTY(SA1->A1_MUN) .OR. EMPTY(SA1->A1_DDD) .OR. EMPTY(SA1->A1_TEL) ;
						.OR. EMPTY(SA1->A1_PAIS)   .OR. EMPTY(SA1->A1_CODPAIS) .OR. EMPTY(SA1->A1_CGC) .OR. EMPTY(SA1->A1_EMAIL) ;
						.OR. EMPTY(SA1->A1_TRANSP) .OR. EMPTY(SA1->A1_MENSAGE) .OR. EMPTY(SA1->A1_ENDENT) .OR. EMPTY(SA1->A1_BAIRROE) ;
						.OR. EMPTY(SA1->A1_MUNE)   .OR. EMPTY(SA1->A1_ESTE) .OR. EMPTY(SA1->A1_CEPE)
						_Retorno := .F.
						_cMensa += "Pedido : "+VALIDA->C9_PEDIDO + " esta com cliente com dados cadastrais invalido."
					EndIf
				ELSE
					_cMensa += "O cliente " + VALIDA->C9_CLIENTE + " - Loja  " + VALIDA->C9_LOJA + " nao esta cadastrado -  Pedido : "
					_Retorno := .F.
				ENDIF
				If !Empty(_cMensa)
					Alert(_cMensa)
					_cMensa := ''
				EndIF
			ENDIF
		EndIF
		
	EndIf
	
	_cContSe := Posicione("SB1",1,xFilial("SB1")+VALIDA->C9_PRODUTO,"B1_XCONTSE")
	If _cContSe == "S" .and. _Retorno
		_cQryAA3 := " SELECT "
		_cQryAA3 += " AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER "
		_cQryAA3 += " FROM   "+RetSqlName("AA3")+" AS AA3 (nolock), "+RetSqlName("SB1")+" AS SB1 (nolock) "
		_cQryAA3 += " WHERE AA3.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND AA3_FILIAL='"+xFilial("AA3")+"' "
		_cQryAA3 += " AND AA3_NUMPED='"+VALIDA->C9_PEDIDO+"' "
		_cQryAA3 += " AND AA3_CODCLI='"+VALIDA->C9_CLIENTE+"' "
		_cQryAA3 += " AND AA3_LOJA='"+VALIDA->C9_LOJA+"' "
		_cQryAA3 += " AND AA3_CODPRO='"+VALIDA->C9_PRODUTO+"' "
		_cQryAA3 += " AND AA3_NFVEND='' "
		_cQryAA3 += " AND AA3_XCLASS='S' "
		_cQryAA3 += " AND SB1.D_E_L_E_T_ = '' "
		_cQryAA3 += " AND B1_FILIAL='"+xFilial("SB1")+"' "
		_cQryAA3 += " AND B1_COD=AA3_CODPRO "
		_cQryAA3 += " AND B1_XCONTSE='S' "
		
		_cQryAA3 := ChangeQuery(_cQryAA3)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryAA3),"QRY1",.T.,.T.)
		
		_nQtAA3 := 0
		
		QRY1->(dbGoTop())
		Do While QRY1->(!Eof())
			_nQtAA3++
			dbSelectArea("QRY1")
			DbSkip()
		Enddo
		
		If _nQtAA3 < VALIDA->C9_QTDLIB
			ALERT("Favor Baixar Base Instalada antes de Faturar!!!", "Base Instalada.")
			_Retorno := .F.
		Endif
		QRY1->(dbCloseArea())
	Endif
	DbSelectArea("VALIDA")
	DbSkip()
End-While



// Executa a validacao do ponto de entrada
DbSelectArea("VALIDA")
DbCloseArea()

// Restaura as areas de acordo com a variavel _AreaLocal
For _n := 1 To Len(_AreaLocal)
	DbSelectArea(_AreaLocal[_n,1])
	DbSetOrder(_AreaLocal[_n,2])
	DbGoTo(_AreaLocal[_n,3])
Next _n

// Restaura a area corrente guardada anteriormente
DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoTo(_nRecno)
Return(_Retorno)
