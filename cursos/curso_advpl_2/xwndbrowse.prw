/*
----- ----------  ----------------------
Ordem	Parâmetros	Descrição do parâmetro
----- ----------  ----------------------
01		nLin1     	Coordenada do ponto inicial, não obrigatório
02		nCol1     	Coordenada do ponto inicial, não obrigatório
03		nLin2     	Coordenada da largura da tela, não obrigatório
04		nCol2     	Coordenada de altura da, não obrigatório
05		cTitle    	Título da janela obrigatório
06		uAlias    	Alias da tabela corrente, pode ser utilizado também com tabelas temporárias
07		aCampos   	Se o parâmetro lDic = .T. utilizará o SX3, do contrário utilizará os campos atribuído ao vetor o aCampos 
						da seguinte forma: aAdd( aCampo, { X3_CAMPO, X3_PICTURE, X3_TITULO, X3_TAMANHO } ).
08		aRotina   	Idêntico ao aRotina para função mBrowse
09		cFun      	Função que deverá retornar um valor lógico e com isso será atribuído semafóro na primeira coluna do browse
10		cTopFun   	Mostrar os registros com a chave de
11		cBotFun   	Mostrar os registros com a chave ate
12		lCentered 	Valor verdadeiro centraliza
13		aResource 	aAdd( aResource, {"IMAGEM", "Texto significativo" } )
14		nModelo   	Se 1 = menu com botões no topo do browser
      		      Se 2 = menu com botões do lado esquerdo do browse
            		Se 3 = menu com botões no rodapé do browse
15		aPesqui   	Pesquisa específica, aAdd( aPesqui, { "Título", nOrdem } ), se não passado será utilizado o AxPesqui
16		cSeek     	Chave principal para a busca, exemplo: xFilial(<alias>), só se o parâmetro lPesq = .T.
17		lDic      	Indica se utiliza os campos do dicionário, valor padrão .T.
18		lSavOrd   	Estabelecer a ordem após pesquisas
19		lParPad		Indica se deve enviar os três parâmetros padrões da função 
						referenciada -> Alias(),RecNo(),nOpcX -> valor padrão .T.
20		lPesq			Indica se deve incluir o botão pesquisar, valor padrão .T.
21		bViewReg		CodeBlock para ação do duplo click no browse
22		oBrowse		Variável com os atributos do metódo da classe TcBrowse():New()
*/

User Function xWndBrowse()
Local cAlias := "SA6"
Local cTitulo := "Cadastro de Bancos"
Local aRotina := {}
Local nModelo := 2
Local lCentered := .T.
Local lPesq := .F.
Local bViewReg

Private cCadastro := cTitulo

aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
aAdd(aRotina,{"Visualizar","AxVisual",0,2})
aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})

bViewReg := &("{|| "+aRotina[2,2]+"('"+cAlias+"',RecNo(),"+LTrim(Str(aRotina[2,4],2,0))+")}")

MaWndBrowse(/*nLin1*/,/*nCol1*/,/*nLin2*/,/*nCol2*/,cTitulo,cAlias,/*aCampos*/,aRotina,/*cFun*/,/*cTopFun*/,/*cBotFun*/,lCentered,;
            /*aResource*/,nModelo,/*aPesqui*/,/*cSeek*/,/*lDic*/,/*lSavOrd*/,/*lParPad*/,lPesq,bViewReg,/*oBrowse*/)

Return                                                                                                               	