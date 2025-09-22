/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ A010TOK  ³ Autor ³ Paulo Bindo           ³ Data ³ 28/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada chamado apos inclusao/alteracao de produto³±±
±±³          ³ Verifica se os campos B1_TIPO, B1_CONTA estao preenchidos  ³±±
±±³          ³ com conteudos validos, nao permite usar contas contabeis   ³±±
±±³          ³ bloqueadas ou invalidas e envia email caso o tipo nao este-³±±
±±³          ³ ja cadastrado na tabela PA0.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³           Descricao da Alteracao      ³  Data   ³ Autor    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                  ³         ³Rogerio/HF³±±
±±³                                                  ³         ³          ³±±
±±³                                                  ³         ³          ³±±
±±³                                                  ³         ³          ³±±
±±³                                                  ³         ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TELEMATICA                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A010TOK()
Local _aArea := GetArea()
_lB1_CONTA := .T.
_cUserNome := AllTrim(U_UsrRetNome(__CUSERID))
_cMensagem := "O produto <b>"+AllTrim(SB1->B1_COD)+"-"+AllTrim(SB1->B1_DESC)+'</b><br>'
_cMensagem += "foi alterado na empresa <b>"+AllTrim(SM0->M0_NOME)+"-"+AllTrim(SM0->M0_FILIAL)+"</b>"
//_cMensagem += " pelo usuário "+AllTrim(CUSERNAME)+'.<br>'
_cMensagem += " pelo usuário "+AllTrim(_cUserNome)+'.<br>'
_cMensagem += "Inconsistências encontradas:<br>"
_cProblemas := ""
_cUserEmail := AllTrim(U_UsrRetMail(__CUSERID))
// se eh alteracao do produto e o usuario nao pertence ao grupo que recebe aviso, o email ser enviado
If Altera
	// criterios de envio de arquivo:
	//// B1_CONTA vazio
	//// B1_POSIPI vazio e B1_TIPO <> "MO"
	//// B1_CONTA nao existe no plano de contas
	//// B1_TIPO nao existe na tabela PA0
	// Conta contabil diferente da conta cadastrada na PA0
	If Empty(M->B1_CONTA) // campo B1_CONTA nao esta preenchido
		_cProblemas += "Campo conta contábil não preenchido.<br>"
	Else // campo B1_CONTA esta preenchido
		CT1->(dbSetOrder(1))
		_lB1_CONTA := CT1->(dbSeek(xFilial("CT1")+M->B1_CONTA))
		If _lB1_CONTA
			If CT1->CT1_BLOQ <> "2" // se a conta nao esta desbloqueada
				_cProblemas += "Conta Contábil informada está bloqueada.<br>"
			Endif
			If CT1->CT1_CLASSE <> "2" // se a classe nao eh sintetica
				_cProblemas += "Conta Contábil informada é sintética.<br>"
			Endif
		Else // Nao existe a conta contabil cadastrada
			_cProblemas += "Conta Contábil não está cadastrada.<br>"
		Endif
	Endif
	If Empty(M->B1_POSIPI) .And. M->B1_TIPO <> "MO" // campo B1_POSIPI nao esta preenchido e tipo <> "MO"
		_cProblemas += "Campo classificação fiscal não preenchido.<br>"
	Endif
	If SB1->B1_MSBLQL == "1" .And. M->B1_MSBLQL == "2" // campo bloqueado alterado de Nao para Sim 1=Sim;2=Näo
		_cProblemas += "O produto foi desbloqueado.<br>"
	Endif
	PA0->(dbSetOrder(1))
	If PA0->(dbSeek(xFilial("PA0")+M->B1_TIPO))
		If AllTrim(PA0->PA0_CONTA) <> AllTrim(M->B1_CONTA) .And. !Empty(M->B1_CONTA)
			_cProblemas += "Conta Contábil do produto diferente da tabela de Tipo de Produto x Conta Contábil.<br>"
		Endif	
	Endif
Endif
RestArea(_aArea)
If !Empty(_cProblemas) .And. !(_cUserEmail $ AllTrim(GetMv("MV_MAILCTB")))
//	MsgAlert(_cMensagem+_cProblemas,"ALERTA -->> "+ProcName())
	_cEmail := AllTrim(GetMv("MV_MAILCTB"))
	_cTitulo := "Alteração de Produto"
	U_ENVIAEMAIL(_cTitulo,_cEmail,"",_cMensagem+_cProblemas,"")
	// a funcao ENVIAEMAIL esta no fonte PTMK003
Endif
Return(.T.)