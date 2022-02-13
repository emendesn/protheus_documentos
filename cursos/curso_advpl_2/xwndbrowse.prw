/*
----- ----------  ----------------------
Ordem	Par�metros	Descri��o do par�metro
----- ----------  ----------------------
01		nLin1     	Coordenada do ponto inicial, n�o obrigat�rio
02		nCol1     	Coordenada do ponto inicial, n�o obrigat�rio
03		nLin2     	Coordenada da largura da tela, n�o obrigat�rio
04		nCol2     	Coordenada de altura da, n�o obrigat�rio
05		cTitle    	T�tulo da janela obrigat�rio
06		uAlias    	Alias da tabela corrente, pode ser utilizado tamb�m com tabelas tempor�rias
07		aCampos   	Se o par�metro lDic = .T. utilizar� o SX3, do contr�rio utilizar� os campos atribu�do ao vetor o aCampos 
						da seguinte forma: aAdd( aCampo, { X3_CAMPO, X3_PICTURE, X3_TITULO, X3_TAMANHO } ).
08		aRotina   	Id�ntico ao aRotina para fun��o mBrowse
09		cFun      	Fun��o que dever� retornar um valor l�gico e com isso ser� atribu�do semaf�ro na primeira coluna do browse
10		cTopFun   	Mostrar os registros com a chave de
11		cBotFun   	Mostrar os registros com a chave ate
12		lCentered 	Valor verdadeiro centraliza
13		aResource 	aAdd( aResource, {"IMAGEM", "Texto significativo" } )
14		nModelo   	Se 1 = menu com bot�es no topo do browser
      		      Se 2 = menu com bot�es do lado esquerdo do browse
            		Se 3 = menu com bot�es no rodap� do browse
15		aPesqui   	Pesquisa espec�fica, aAdd( aPesqui, { "T�tulo", nOrdem } ), se n�o passado ser� utilizado o AxPesqui
16		cSeek     	Chave principal para a busca, exemplo: xFilial(<alias>), s� se o par�metro lPesq = .T.
17		lDic      	Indica se utiliza os campos do dicion�rio, valor padr�o .T.
18		lSavOrd   	Estabelecer a ordem ap�s pesquisas
19		lParPad		Indica se deve enviar os tr�s par�metros padr�es da fun��o 
						referenciada -> Alias(),RecNo(),nOpcX -> valor padr�o .T.
20		lPesq			Indica se deve incluir o bot�o pesquisar, valor padr�o .T.
21		bViewReg		CodeBlock para a��o do duplo click no browse
22		oBrowse		Vari�vel com os atributos do met�do da classe TcBrowse():New()
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