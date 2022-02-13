#include "protheus.ch"
#include "ctb.ch"
#define CTB_LAST_UPDATED "04/02/2014"
//Defines de posição do array de filiais
Static lFWCodFil := FindFunction("FWCodFil")
Static aFilProc := {}
Static nRetAviso := 0   
 
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ UPDCTB   ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Executa as funcoes de atualizacao do ambiente SIGACTB        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ UPDCTB    - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/              
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ UPDCTB   ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Executa as funcoes de atualizacao do ambiente SIGACTB        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ UPDCTB    - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UPedu(lWizard)
Local cTexto := ""

cTexto := u_UPDEDU(lWizard)

Return cTexto

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ UPDSIGACTB ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Executa as funcoes de atualizacao do ambiente SIGACTB          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ UPDSIGACTB - PARA EXECUCAO PELA TELA DE ABERTURA DO REMOTE     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function UPDEDU(lWizard)
Local cTexto   := ''
Local cFile    := ""
Local cMask    := STR0009 //"Arquivos Texto (*.TXT) |*.txt|"
Local nRecno   := 0
Local nX       := 0
Local nRecAtu
Local aAreaSM0
Local lAbriu                   

Local nCFil		:= 0
Local aSM0		:= {}

cArqEmp		:= "SigaMat.Emp"
nModulo		:= 34
__cInterNet	:= Nil

PRIVATE cMens := STR0002 + CRLF +; 	// "Esta rotina ira atualizar os dicionarios de dados"
STR0003 + CRLF +; 	// "para a utilizacao das novas funcionalidades do SIGACTB."
STR0004 + CRLF +; 	// "E importante realizar um bachup completo dos dicionarios e base de dados, "
STR0005 + CRLF +; 	// "antes da execução desta rotina."
STR0006 			// "Nao deve existir usuarios utilizando o sistema durante a atualizacao!"

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}

If ValType(lWizard) == 'U'
	lWizard := .F.
Endif
#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On

CTBOpenSm0()
DbGoTop()

If lWizard 
	cTexto :=	CtbProc()
Else

	lHistorico 	:= MsgYesNo(STR0044 + CRLF + CTB_LAST_UPDATED+ CRLF + cMens, STR0001)  // "Deseja efetuar a atualizacao do Dicionario do SIGACTB ?" ###, "Atencao !"
	lEmpenho	:= .F.
	lAtuMnu		:= .F.

	DEFINE WINDOW oMainWnd FROM 0,0 TO 01,1 TITLE STR0045 // "Atualizacao do Dicionario"

	ACTIVATE WINDOW oMainWnd ICONIZED;
	ON INIT If(lHistorico,(Processa({|lEnd| cTexto := CTBProc(@lEnd)},STR0007,"STR0008",.F.) , oMainWnd:End()),oMainWnd:End()) //### //"Processando"###"Aguarde , processando preparacao dos arquivos"

	cTexto     := STR0027+CRLF+cTexto	//	"Log da atualizacao "
	__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)

	DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
	DEFINE MSDIALOG oDlg TITLE STR0028 From 3,0 to 340,417 PIXEL //"Atualizacao concluida."
	@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,175 TYPE  1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."

	ACTIVATE MSDIALOG oDlg CENTER

Endif

Return cTexto

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Função    ³ CTBPROC  ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descrição ³ Funcao de processamento da gravacao dos arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ ATUALIZACAO SIGACTB                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBProc(lEnd)
Local cTexto   := ''
Local cFile    := ""
Local cMask    := STR0009 //"Arquivos Texto (*.TXT) |*.txt|"
Local nRecno   := 0
Local nX       := 0
Local nRecAtu
Local aAreaSM0
Local lAbriu
Local nCFil		:= 0
Local aSM0		:= {}

Private cPaisLoc := ""
Private cMvConsold := ""

ProcRegua(1)
IncProc(STR0010) //"Verificando integridade dos dicionarios...."

OpenSm0Excl()
aSM0 := AdmAbreSM0()

For nCFil := 1 to Len(aSM0)
	
	RpcSetType(3)
	RpcSetEnv(aSM0[nCFil][SM0_GRPEMP], aSM0[nCFil][SM0_CODFIL] )
	
	RpcClearEnv()
	OpenSm0Excl()
	
Next nCFil

For nCFil := 1 to Len(aSM0)
	
	aArqUpd  := {}
	
	RpcSetType(3)
	RpcSetEnv(aSM0[nCFil][SM0_GRPEMP], aSM0[nCFil][SM0_CODFIL] )

	cPaisLoc := GETMV("MV_PAISLOC",.F.,"BRA")
	cMvConsold := Alltrim(Getmv("MV_CONSOLD"))
	
	cTexto += Replicate("-",128)+CRLF
	cTexto += STR0011+aSM0[nCFil][SM0_GRPEMP]+STR0012+aSM0[nCFil][SM0_CODFIL]+"-"+aSM0[nCFil][SM0_NOME]+CRLF //"Empresa : "###" Filial : "
	ProcRegua(8)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as perguntas de relatorios.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0013) // //"Analisando Perguntas de Relatorios..."
	cTexto += CTBAtuSX1()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o dicionario de arquivos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0014) // //"Analisando Dicionario de Arquivos..."
	cTexto += CTBAtuSX2()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os grupos de campos. 			³
	//³Proceder nesta atualizacao antes do SX3  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0052) // //"Analisando Grupos de Campos..."
	cTexto += CTBAtuSXG()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o dicionario de dados.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0015) // //"Analisando Dicionario de Dados..."
	cTexto += CTBAtuSX3()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o dicionario de dados.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Atualizando helps de campos...") // //"Atualizando helps de campos..."
	cTexto += CTBAtuHlp()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os parametros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0016) // // //"Analisando Tabelas..."
	cTexto += CTBAtuSX5()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os parametros.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0017) // //"Analisando Parametros..."
	cTexto += CTBAtuSX6()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os gatilhos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0018) // //"Analisando Gatilhos..."
	cTexto += CTBAtuSX7()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os folder's de cadastro.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0019) //"Analisando Folder de Cadastro..."
	cTexto += CTBAtuSXA()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as consultas padroes.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0020) // //"Analisando Consultas Padroes..."
	cTexto += CTBAtuSXB()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza os indices.          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua(2)
	IncProc(STR0021) // //"Analisando Indices..."
	cTexto += CTBAtuSIX()
	
	__SetX31Mode(.F.)   
	aSort(aArqUpd) //-- Organiza array.
	For nX := 1 To Len(aArqUpd)
		lAbriu := .F.
		IncProc(STR0022+aArqUpd[nx]+"]") //"Atualizando estruturas. Aguarde... ["
		If Select(aArqUpd[nx])>0
			lAbriu := .T.
			dbSelecTArea(aArqUpd[nx])
			dbCloseArea()
		EndIf
		X31UpdTable(aArqUpd[nx])
		If __GetX31Error()
			Alert(__GetX31Trace())
			Aviso(STR0001,STR0023+ aArqUpd[nx] + STR0024,{STR0025},2) //"Atencao!"###"Ocorreu um erro desconhecido durante a atualizacao da tabela : "###". Verifique a integridade do dicionario e da tabela."###"Continuar"
			cTexto += STR0026+aArqUpd[nx] +CRLF //"Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "
		ElseIf ! lAbriu
			dbSelectArea(aArqUpd[nx])
			dbCloseArea()
		EndIf
	Next nX
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza a tabela CT0 incluindo as entidades padroes (CT1,CTT,CTD e CTH)|
	//|caso o pais seja PERU ou COLOMBIA inclui a entidade 05                  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AliasInDic("CT0") .And. FindFunction("CtbIncCT0")
		CtbIncCT0() // Fonte CTB0005
	ENdIf
	
	If Empty(cMvConsold)  // ajustar conteudo do campo filial de origem da tabela CT2_FILORI
		// somente nas empresas que nao sao consolidadoras
		CtbFilOri( cEmpAnt, cFilAnt )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza a Pyme                    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua(2)
	IncProc(STR0058) // "Atualizando Pyme dos Campos"
	cTexto += CTBAtuPyme()
	
	
	RpcClearEnv()
	OpenSm0Excl()
	
Next nCFil

RpcSetEnv(aSM0[1][SM0_GRPEMP],aSM0[1][SM0_CODFIL],,,,, { "AE1" }) 

cTexto := STR0031+CRLF+cTexto //"Log da atualizacao "

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³CTBAtuSIX ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Funcao de processamento da gravacao do SIX                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto := ''
Local lSIX   := .F.
Local lNew   := .F.
Local aSIX   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cAlias := ''
Local aDelSIX:= {}

If (cPaisLoc == "BRA")
	aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
Else
	aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
EndIf

// Indices do CW1
Aadd(aSIX,{	"CW1","1","CW1_FILIAL+CW1_CODIGO+CW1_SEQUEN",;
"Cod Grupo + Sequencial",;
"Cod Grupo + Secuencial",;
"Group Code + Sequential",;
"S","","","S"})
Aadd(aSIX,{	"CW1","2","CW1_FILIAL+CW1_INDICE+CW1_CONTA",;
"Indice Est + Cod Conta",;
"Indice Est + Cod Cuenta",;
"Stat Index + Acc Code",;
"S","","CW1_CONTA","S"})
Aadd(aSIX,{	"CW1","3","CW1_FILIAL+CW1_INDICE+CW1_CCUSTO",;
"Indice Est + Cod C Custo",;
"Indice Est + Cod C Costo",;
"Stat Index + C Cent Code",;
"S","","CW1_CCUSTO","S"})
Aadd(aSIX,{	"CW1","4","CW1_FILIAL+CW1_INDICE+CW1_ITEM",;
"Indice Est + Cod Item",;
"Indice Est + Cod Item",;
"Stat Index + Item Code",;
"S","","CW1_ITEM","S"})
Aadd(aSIX,{	"CW1","5","CW1_FILIAL+CW1_INDICE+CW1_CLVL",;
"Indice Est + Cod Cl Valor",;
"Indice Est + Cod Cl Valor",;
"Stat Index + Vl Cls Code",;
"S","","CW1_CLVL","S"})

// Indices do CW2
Aadd(aSIX,{	"CW2","1","CW2_FILIAL+CW2_CODIGO+CW2_STATUS",;
"Cod Amarracao + Status",;
"Cod Vinculo + Estatus",;
"Binding Code + Status",;
"S","","","S"})

Aadd(aSIX,{	"CW2","2","CW2_FILIAL+CW2_ORIGEM+CW2_CTTORI+CW2_CTDORI+CW2_CTHORI",;
"Grp.Orig.CT1+Grp.Orig.CTT+Grp.Orig.CTD+Grp.Orig.CTH",;
"Grp.Orig.CT1+Grp.Orig.CTT+Grp.Orig.CTD+Grp.Orig.CTH",;
"Src.Grp.CT1+Src.Grp.CTT+Src.Grp.CTD+Src.Grp.CTH",;
"S","","CW2_ORIGEM","S"})

Aadd(aSIX,{	"CW2","3","CW2_FILIAL+CW2_CTTORI",;
"Grp.Orig.CTT",;
"Grp.Orig.CTT",;
"Src.Grp.CTT",;
"S","","CW2_CTTORI","S"})

Aadd(aSIX,{	"CW2","4","CW2_FILIAL+CW2_CTDORI",;
"Grp.Orig.CTD",;
"Grp.Orig.CTD",;
"Src.Grp.CTD",;
"S","","CW2_CTDORI","S"})

Aadd(aSIX,{	"CW2","5","CW2_FILIAL+CW2_CTHORI",;
"Grp.Orig.CTH",;
"Grp.Orig.CTH",;
"Src.Grp.CTH",;
"S","","CW2_CTHORI","S"})

Aadd(aSIX,{	"CW2","6","CW2_FILIAL+CW2_DESTIN+CW2_CTTDES+CW2_CTDDES+CW2_CTHDES",;
"Grp.Dest.CT1+Grp.Dest.CTT+Grp.Dest.CTD+Grp.Dest.CTH",;
"Grp.Dest.CT1+Grp.Dest.CTT+Grp.Dest.CTD+Grp.Dest.CTH",;
"Dest.Grp.CT1+Dest.Grp.CTT+Dest.Grp.CTD+Dest.Grp.CTH",;
"S","","CW2_DESTIN","S"})

Aadd(aSIX,{	"CW2","7","CW2_FILIAL+CW2_CTTDES",;
"Grp.Dest.CTT",;
"Grp.Dest.CTT",;
"Dest.Grp.CTT",;
"S","","CW2_CTTDES","S"})

Aadd(aSIX,{	"CW2","8","CW2_FILIAL+CW2_CTDDES",;
"Grp.Dest.CTD",;
"Grp.Dest.CTD",;
"Dest.Grp.CTD",;
"S","","CW2_CTDDES","S"})

Aadd(aSIX,{	"CW2","9","CW2_FILIAL+CW2_CTHDES",;
"Grp.Dest.CTH",;
"Grp.Dest.CTH",;
"Dest.Grp.CTH",;
"S","","CW2_CTHDES","S"})

// INDICES QUE SERÃO REMOVIDOS DO SIX / TABELA CW2

Aadd(aDelSIX,{	"CW2","2","CW2_FILIAL+CW2_ORIGEM",;
"Grupo Origem",;
"Grupo Origem",;
"Source Group",;
"S","","","S"})

Aadd(aDelSIX,{	"CW2","3","CW2_FILIAL+CW2_DESTIN",;
"Grupo Destino",;
"Grupo Destino",;
"Destin. Group",;
"S","","","S"})

// INDICE QUE SERA REMOVIDO DO SIX / TABELA CTA
Aadd(aDelSIX,{	"CTA","1","CTA_FILIAL+CTA_REGRA",;
"Cod. Ligacao",;
"Cod. Vinculo",;
"Link Code",;
"S","","","S"})


// Indices do CW3
Aadd(aSIX,{	"CW3","1","CW3_FILIAL+CW3_CODIGO+CW3_SEQUEN",;
"Cod Indice + Sequencial",;
"Cod Indice + Secuencial",;
"Index Code + Sequential",;
"S","","","S"})

Aadd(aSIX,{	"CW3","2","CW3_FILIAL+CW3_CODIGO+CW3_ENTID+CW3_CODENT",;
"Cod Indice + Entidade + Cod Entidade",;
"Cod Indice + Entidad + Cod Entidad",;
"Index Code + Entity + Entity Code",;
"S","","","S"})

// Indices do CW8-Historico de Grupos e Natureza Contabil
Aadd(aSIX,{ "CW8","1","CW8_FILIAL+CW8_FILTAB+CW8_TABELA+CW8_CODIGO+CW8_GRUPO+CW8_CAMPO+DTOS(CW8_DATA)+CW8_SEQ",;
"Filial+Fil.da Tabela+Alias da Tabela+Grupo/Natureza+Data alteracao+Sequencia",;
"Sucursal+Sucur.de la Tabla+Alias+Grupo/Naturaleza+Fecha de modificaion+Secuencia",;
"Branch+Branch Tab.+Alias+Group/Nature Code+Date of the alteration+Sequence",;
"S","","","S"})

Aadd(aSIX,{	"CW8","2","CW8_FILIAL+DTOS(CW8_DATA)+CW8_HORA",;
"Filial + Data Alteracao + Hora Alteracao",;
"Sucursal + Fecha de modificacion + Hora de Modificacion",;
"Branch + Date of the Alteration + Hour of the Alteration",;
"S","","","S"})

// Indices do CVN
Aadd(aSIX,{	"CVN","1","CVN_FILIAL+CVN_CODPLA+CVN_LINHA",;
"Plano Ref. + Linha",;
"Plano Ref. + Linha",;
"Plano Ref. + Linha",;
"S","",""})

Aadd(aSIX,{	"CVN","2","CVN_FILIAL+CVN_CODPLA+CVN_CTAREF",;
"Plano Ref + Conta Ref",;
"Plano Ref + Conta Ref",;
"Plano Ref + Conta Ref",;
"S","","","S"})

// Novo Indice do CTQ
Aadd(aSIX,{	"CTQ","2","CTQ_FILIAL+CTQ_AMARRA+CTQ_RATEIO+CTQ_SEQUEN",;
"Amarracao + Cod Rateio + Sequencial",;
"Vinculo + Cod.Prorrat. + Secuencial",;
"Binding + Prorat.Code + Sequential",;
"S","","","S"})

// Indices do CVE
Aadd(aSIX,{	"CVE","1","CVE_FILIAL+CVE_CODIGO",;
"Cod Visao",;
"Cod Visao",;
"Cod Visao",;
"S","","","S"})

Aadd(aSIX,{	"CVE","2","CVE_FILIAL+CVE_DESCRI",;
"Desc Ent Ger",;
"Desc Ent Ger",;
"Desc Ent Ger",;
"S","","","S"})

Aadd(aSIX,{	"CVD","2","CVD_FILIAL+CVD_CODPLA+CVD_CTAREF+CVD_CONTA",;
"Codigo Plano+Conta Referencial+Conta Contabil",;
"Codigo Plan+Cuenta Referencial+Cuenta Contable",;
"Plan Code+Refer Account+Account",;
"S","","","S"})

Aadd(aSIX,{	"CVD","3","CVD_FILIAL+CVD_ENTREF+CVD_CONTA+CVD_CUSTO",;
"Entidade Referencial+Conta Contabil+Centro de Custo",;
"Ent. Referencial+Cuenta Contable+C.Costos",;
"Refer Plan+Account+Cust",;
"S","","","S"})


// Indices do CVF
Aadd(aSIX,{	"CVF","1","CVF_FILIAL+CVF_CODIGO+CVF_CONTAG+CVF_ORDEM",;
"Cod Visao+Entid Gerenc+Ordem",;
"Cod Visao+Entid Gerenc+Ordem",;
"Cod Visao+Entid Gerenc+Ordem",;
"S","","","S"})

Aadd(aSIX,{	"CVF","2","CVF_FILIAL+CVF_CODIGO+CVF_CTASUP+CVF_ORDEM+CVF_CONTAG",;
"Cod Visao+Entid Super+Ordem+Entid Gerenc",;
"Cod Visao+Entid Super+Ordem+Entid Gerenc",;
"Cod Visao+Entid Super+Ordem+Entid Gerenc",;
"S","","","S"})

Aadd(aSIX,{	"CVF","3","CVF_FILIAL+CVF_DESCCG",;
"Desc Ent Ger",;
"Desc Ent Ger",;
"Desc Ent Ger",;
"S","","","S"})

Aadd(aSIX,{	"CVF","4","CVF_FILIAL+CVF_CODIGO+CVF_ORDEM",;
"Cod Visao+Ordem",;
"Cod Visao+Ordem",;
"Cod Visao+Ordem",;
"S","","","S"})

// Indices do CTG

Aadd(aSIX,{	"CTG","4","CTG_FILIAL+CTG_EXERC+CTG_PERIOD",;
"Exercicio + Periodo",;
"Exercicio + Periodo",;
"Exercicio + Periodo",;
"S","","","S"})

// Indices do CVI
Aadd(aSIX,{	"CVI","1","CVI_FILIAL+CVI_OPER+CVI_LANPAD+CVI_SEQLAN",;
"Operacao + Lan.Padrao + Seq.Lanc.",;
"Operacion + Asiento est. + Sec. asiento",;
"Operation + Stand. Entry + Entry seq.",;
"S","","","S"})

Aadd(aSIX,{	"CVI","2","CVI_FILIAL+CVI_LANPAD+CVI_SEQLAN",;
"Lan.Padrao + Seq.Lanc.",;
"Asiento est. + Sec. asiento",;
"Stand. Entry + Entry seq.",;
"S","","","S"})

Aadd(aSIX,{	"CVI","3","CVI_FILIAL+CVI_PROCES+CVI_OPER+CVI_LANPAD+CVI_SEQLAN",;
"Processos + Operacao + Lan.Padrao + Seq.Lanc.",;
"Procesos + Operacion + Asiento est. + Sec. asiento",;
"Processes + Operation + Stand. Entry + Entry seq.",;
"S","","","S"})

// Indices do CVJ
Aadd(aSIX,{	"CVJ","1","CVJ_FILIAL+CVJ_PROCES+CVJ_MODULO",;
"Processo + Modulo",;
"Proceso + Modulo ",;
"Process + Module ",;
"S","","","S"})

Aadd(aSIX,{	"CVJ","2","CVJ_FILIAL+CVJ_MODULO+CVJ_PROCES",;
"Modulo + Processo",;
"Modulo + Proceso ",;
"Module + Process ",;
"S","","","S"})

Aadd(aSIX,{	"CVJ","3","CVJ_FILIAL+CVJ_DESCRI",;
"Descricao  ",;
"Descripcion",;
"Description",;
"S","","","S"})

// Indices do CVG
Aadd(aSIX,{	"CVG","1","CVG_FILIAL+CVG_PROCES+CVG_OPER",;
"Processo + Operacao",;
"Proceso + Operacion",;
"Process + Operation",;
"S","CVJ","","S"})

Aadd(aSIX,{	"CVG","2","CVG_FILIAL+CVG_DESCRI",;
"Descricao  ",;
"Descripcion",;
"Description",;
"S","","","S"})



// Indices do CVO
Aadd(aSIX,{	"CVO","1","CVO_FILIAL+DTOS(CVO_DATA)+CVO_LOTE+CVO_SBLOTE+CVO_LINHA",;
"Data+Lote+Sub Lote+Linha",;
"Data+Lote+Sub Lote+Linha",;
"Data+Lote+Sub Lote+Linha",;
"S","","","S"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aSIX,{"CT2","A","CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_SEQLAN+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQHIS";
,"Data Lcto + Numero Lote + Sub Lote + Numero Doc + Seq Auxiliar + Empre";
,"Fch.Asiento + Numero Lote + Sublote + Numero Doc + Sec Auxiliar + Empr";
,"Entry Date + Lot Number + Sublot + Doc Number + Auxil.Seq. + Orig.Comp";
,"S"	,"",""			,"S"})

Aadd(aSIX,{"CV3","2","CV3_FILIAL+CV3_RECDES"								,"Reg.Destino"										,"Reg. Destino"						,"Target Reg."							,"S"	,"","CV3RECDES"	,"S"})

Aadd(aSIX,{"CV7","1","CV7_FILIAL+CV7_MOEDA+CV7_TPSALD"						,"Moeda + Tipo Saldo"								,"Moneda + Tipo Saldo"				,"Currency + Balance type"				,"S"	,"",""			,"S"})

Aadd(aSIX,{"CV8","2","CV8_FILIAL+CV8_PROC+CV8_USER+DTOS(CV8_DATA)+CV8_HORA"	,"Processo + Usuario + Data + Hora"					,"Proceso + Usuario + Fecha + Hora"	,"Process + User + Date + Occur.Time"	,"S"	,"",""			,"S"})
Aadd(aSIX,{"CV8","3","CV8_FILIAL+CV8_USER+DTOS(CV8_DATA)+CV8_HORA"			,"Usuario + Data + Hora"							,"Usuario + Fecha + Hora"			,"User + Date + Occur.Time"				,"S"	,"",""			,"S"})

Aadd(aSIX,{"CV9","1","CV9_FILIAL+CV9_RATEIO+CV9_REVISA+CV9_SEQUEN"			,"Cod. Rateio + Revisao + Sequencial"				,"+ Revision + Secuencial"			,"+ Revision + Sequential"				,"S"	,"",""			,"S"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para o Novo SPED Contabil			 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSIX,{"CS0","1","CS0_FILIAL+CS0_CODREV+CS0_CODEMP+CS0_CODFIL+CS0_ECDREV","Filial+Cod. Revisao+Cod. da Empresa+Filial+Tipo da ECD" 				,"Filial+Cod. Revisao+Cod. da Empresa+Filial+Tipo da ECD","Filial+Cod. Revisao+Cod. da Empresa+Filial+Tipo da ECD","S"	,"",""			,"S"})
Aadd(aSIX,{"CS0","2","CS0_FILIAL+CS0_CODEMP+CS0_CODFIL+CS0_CODREV","Filial+Cod. da Empresa+Cod. Filial+Cod. Revisao" 	,"Filial+Cod. da Empresa+Cod. Filial+Cod. Revisao","Filial+Cod. da Empresa+Cod. Filial+Cod. Revisao","S"	,"",""			,"S"})
Aadd(aSIX,{"CS0","3","CS0_FILIAL+CS0_ECDREV+CS0_CODREV+CS0_CODEMP+CS0_CODFIL","Filial+Tipo da ECD+Cod. Revisao+Cod. da Empresa+Filial" 				,"Filial+Tipo da ECD+Cod. Revisao+Cod. da Empresa+Filial","Filial+Tipo da ECD+Cod. Revisao+Cod. da Empresa+Filial","S"	,"",""			,"S"})
Aadd(aSIX,{"CS1","1","CS1_FILIAL+CS1_CODREV+CS1_NUMLIV+CS1_NATLIV","Filial+Cod. Revisao+Num do Livro + Nat. do Liv","Filial+Cod. Revisao+Num do Livro + Nat. do Liv","Filial+Cod. Revisao+Num do Livro + Nat. do Liv"	,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS1","2","CS1_FILIAL+CS1_CODREV+CS1_NUMLIN+CS1_NUMLIV","Filial+Cod. Revisao+Linha+Num do Livro","Filial+Cod. Revisao+Linha+Num do Livro","Filial+Cod. Revisao+Linha+Num do Livro"	,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS2","1","CS2_FILIAL+CS2_CODREV+CS2_CODEMP+CS2_CODFIL","Filial+Cod. Revisao+Empresa+Filial"				,"Filial+Cod. Revisao"				,"Filial+Cod. Revisao" 					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS3","1","CS3_FILIAL+CS3_CODREV+CS3_CONTA"				,"Filial+Cod. Revisao+Cod. Conta"					,"Filial+Cod. Revisao+Cod Conta"	,"Filial+Cod. Revisao+Cod Conta"		,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS4","1","CS4_FILIAL+CS4_CODREV+CS4_CONTA+CS4_CTAREF+CS4_CCUSTO"	,"Filial+Cod. Revisao+Cod Conta+Cta. Ref.+Centro de Custo","Filial+Cod. Revisao+Cod Conta+Cta. Ref.+Centro de Custo","Filial+Cod. Revisao+Cod Conta+Cta. Ref.+Centro de Custo","S"	,"",""			,"S"})
Aadd(aSIX,{"CS5","1","CS5_FILIAL+CS5_CODREV+CS5_CUSTO" 				,"Filial+Cod. Revisao+Cod C.Custo" 							,"Filial+Cod. Revisao+Cod C.Custo"				,"Filial+Cod. Revisao+Cod C.Custo" 					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS6","1","CS6_FILIAL+CS6_CODREV+CS6_CONTA+CS6_CCUSTO"	,"Filial+Cod. Revisao+Conta+C Custo"			,"Filial+Cod. Revisao+Conta+C Custo","Filial+Cod. Revisao+Conta+C Custo"			,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS6","2","CS6_FILIAL+CS6_CODREV+CS6_CODAGL"	   		,"Filial+Cod. Revisao+Cod Aglutina"				,"Filial+Cod. Revisao+Cod Aglutina","Filial+Cod. Revisao+Cod Aglutina"			,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS7","1","CS7_FILIAL+CS7_CODREV+CS7_CODHIS"				,"Filial+Cod. Revisao+Cod. Hist"					,"Filial+Cod. Revisao+Cod. Hist"	,"Filial+Cod. Revisao+Cod. Hist" 					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS8","1","CS8_FILIAL+CS8_CODREV+CS8_CODSIG"				,"Filial+Cod. Revisao+Cod Signat" 				,"Filial+Cod. Revisao+Cod Signat","Filial+Cod. Revisao+Cod Signat" 					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CS9","1","CS9_FILIAL+CS9_CODREV+CS9_CODPAR"				,"Filial+Cod. Revisao+Cod Partic" 				,"Filial+Cod. Revisao+Cod Partic","Filial+Cod. Revisao+Cod Partic"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSA","1","CSA_FILIAL+CSA_CODREV+DTOS(CSA_DTLANC)+CSA_NUMLOT","Filial+Cod. Revisao+Data Lanc+Num Lote","Filial+Cod. Revisao+Data Lanc+Num Lote","Filial+Cod. Revisao+Data Lanc+Num Lote","S"	,"",""			,"S"})
Aadd(aSIX,{"CSB","1","CSB_FILIAL+CSB_CODREV+DTOS(CSB_DTLANC)+CSB_NUMLOT+CSB_LINHA"	,"Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha"			,"Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha","Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSC","1","CSC_FILIAL+CSC_CODREV+DTOS(CSC_DTINI)+DTOS(CSC_DTFIM)+CSC_CONTA+CSC_CCUSTO","Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo" 	,"Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo" ,"Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSD","1","CSD_FILIAL+CSD_CODREV+CSD_CODVIS"			   ,"Filial+Cod. Revisao+Cod da Visao" 			,"Filial+Cod. Revisao+Cod da Visao","Filial+Cod. Revisao+Cod da Visao"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSE","1","CSE_FILIAL+CSE_CODREV+CSE_CODVIS+CSE_CODAGL","Filial+Cod. Revisao+Cod da Visao + Cod Agluti","Filial+Cod. Revisao+Cod da Visao + Cod Agluti"				,"Filial+Cod. Revisao+Cod da Visao + Cod Agluti"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSF","1","CSF_FILIAL+CSF_CODREV+CSF_LINHA"				,"Filial+Cod. Revisao+Linha" ,"Filial+Cod. Revisao+Linha" ,"Filial+Cod. Revisao+Linha" ,"S"	,"","","S"})
Aadd(aSIX,{"CSG","1","CSG_FILIAL+CSG_CODREV+DTOS(CSG_DTBAL)+CSG_CONTA+CSG_CCUSTO","Filial+Cod. Revisao+Dt Balancete+ Cod.Conta + C.Custo" 	,"Filial+Cod. Revisao+Dt Balancete+ Cod.Conta + C.Custo" ,"Filial+Cod. Revisao+Dt Balancete+ Cod.Conta + C.Custo"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSJ","1","CSJ_FILIAL+CSJ_CODREV+CSJ_CONTA"				,"Filial+Cod. Revisao+Cod. Conta"					,"Filial+Cod. Revisao+Cod Conta"	,"Filial+Cod. Revisao+Cod Conta"		,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSK","1","CSK_FILIAL+CSK_CODREV+DTOS(CSK_DTINI)+DTOS(CSK_DTFIM)+CSK_CONTA+CSK_CCUSTO+CSK_CTAREF","Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo + Cod. Referencial" 	,"Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo + Cod. Referencial" ,"Filial+Cod. Revisao+Dt Inicial+Dt Final+ Cod.Conta + C.Custo + Cod. Referencial"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSL","1","CSL_FILIAL+CSL_CODREV+DTOS(CSL_DTLANC)+CSL_NUMLOT+CSL_LINHA"	,"Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha"			,"Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha","Filial+Cod. Revisao+Data Lanc+Num Lote+ Linha"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSM","1","CSM_FILIAL+CSM_CODREV"						,"Filial+Cod. Revisao"						,"Filial+Cod. Revisao"						,"Filial+Cod. Revisao"					,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSN","1","CSN_FILIAL+CSN_CODREV+CSN_REG+CSN_CODFAT"		,"Filial+Cod. Revisao+Registro+Cod.Fato Ct"	,"Filial+Cod. Revisao+Registro+Cod.Fato Ct"	,"Filial+Cod. Revisao+Registro+Cod.Fato Ct"	,"S"	,"",""			,"S"})
Aadd(aSIX,{"CSO","1","CSO_FILIAL+CSO_CODREV+CSO_CODAGL"				,"Filial+Cod. Revisao+Cod. Aglut."			,"Filial+Cod. Revisao+Cod. Aglut."			,"Filial+Cod. Revisao+Cod. Aglut."			,"S"	,"",""			,"S"})
#IFDEF TOP
	Aadd(aSIX,{"CSH","1","CSH_FILIAL+CSH_MODELO+CSH_ITEM+CSH_RGRVLD"		,"Filial+Modelo+Item+Regra" 	,"Filial+Modelo+Item+Regra" ,"Filial+Modelo+Item+Regra" ,"S"	,"",""			,"S"})
	Aadd(aSIX,{"CSI","1","CSI_FILIAL+CSI_MODELO+CSI_ITEM+CSI_RGRVLD"		,"Filial+Modelo+Item+Regra" 	,"Filial+Modelo+Item+Regra" ,"Filial+Modelo+Item+Regra" ,"S"	,"",""			,"S"})
	Aadd(aSIX,{"CSV","1","CSV_FILIAL+CSV_CODLAY","Filial + Cod. LayOut","Filial + Cod. LayOut","Filial + Cod. LayOut",'S',"","",'S'})
	Aadd(aSIX,{"CSW","1","CSW_FILIAL+CSW_CODLAY+CSW_ORDEM","Filial + Cod.Layout + Ordem","Filial + Cod.Layout + Ordem","Filial + Cod.Layout + Ordem",'S',"","",'S'})
	Aadd(aSIX,{"CSX","1","CSX_FILIAL+CSX_CODREV+CSX_CODLAY+CSX_ORDEM+CSX_KEY","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra",'S',"","",'S'})
	Aadd(aSIX,{"CSY","1","CSY_FILIAL+CSY_CODREV+CSY_CODLAY+CSY_ORDEM+CSY_KEY","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra","Filial + Cod.Revisao + Cod. Layout + Ordem + Quebra",'S',"","",'S'})
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim dasTabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aSIX,{"CVB","1","CVB_FILIAL+CVB_CODCTB"						,"Codigo do Contabilista"	,"Codigo do Contabilista"	,"Acct. Code"					,"S","","",	"S"})
Aadd(aSIX,{"CVB","2","CVB_FILIAL+CVB_CGC"							,"CNPJ"						,"CNPJ"						,"CNPJ"							,"S","","",	"S"})
Aadd(aSIX,{"CVB","3","CVB_FILIAL+CVB_CPF"							,"CPF"						,"CPF"						,"CPF"		   					,"S","","",	"S"})

Aadd(aSIX,{"CVC","1","CVC_FILIAL+CVC_CODPAR"						,"Codigo do Participante"	,"Codigo do Participante"	,"Participant"					,"S","","",	"S"})
Aadd(aSIX,{"CVC","2","CVC_FILIAL+CVC_CGC"							,"CNPJ/CPF"					,"CNPJ/CPF"					,"CNPJ/CPF"						,"S","","",	"S"})

Aadd(aSIX,{"CVD","1","CVD_FILIAL+CVD_CONTA+CVD_ENTREF+CVD_CTAREF+CVD_CUSTO"	,"Cod Conta+Entidade+Conta Ref.+Cod C.Custo"	,"Cuenta+Entidad+Cuenta Ref+Cod C.Custo","Account+Entity+Account Ref.+Cod C.Custo"	,"S","","",	"S"})
Aadd(aSIX,{"CVD","2","CVD_FILIAL+CVD_CODPLA+CVD_CTAREF"				,"Plano Ref. + Conta Ref"	,"Plano Ref. + Conta Ref"	,"Plano Ref. + Conta Ref"		,"S","","","S"})

// Indices do CVN
Aadd(aSIX,{	"CVN","1","CVN_FILIAL+CVN_CODPLA+CVN_LINHA"				,"Plano Ref. + Linha"		,"Plano Ref. + Linha"		,"Plano Ref. + Linha"			,"S","","","S"})
Aadd(aSIX,{	"CVN","2","CVN_FILIAL+CVN_CODPLA+CVN_CTAREF"			,"Plano Ref + Conta Ref"	,"Plano Ref + Conta Ref"	,"Plano Ref + Conta Ref"		,"S","","","S"})

Aadd(aSIX,{"CVL","1","CVL_FILIAL+CVL_COD","Codigo","Codigo","Codigo",'S',"","",'S'})

Aadd(aSIX,{"CVM","1","CVM_FILIAL+CVM_COD+DTOS(CVM_DTINI)+CVM_RAD","Codigo+Data Inicial + Quebra","Codigo+Data Inicial + Quebra","Codigo+Data Inicial + Quebra",'S',"","",'S'})
Aadd(aSIX,{"CVM","2","CVM_FILIAL+CVM_COD+CVM_TIPOSE+CVM_SEQINI+CVM_RAD","Codigo+Tipo Sequencial + Sequencial inicial + Quebra","Codigo+Tipo Sequencial + Sequencial inicial + Quebra","Codigo+Tipo Sequencial + Sequencial inicial + Quebra",'S',"","",'S'})
Aadd(aSIX,{"CVM","3","CVM_FILIAL+CVM_TIPOSE","Tipo Sequencial","Tipo Sequencial","Tipo Sequencial",'S',"","",'S'})

aAdd(aSIX,{"CT2", "C",	"CT2_FILIAL+CT2_SEGOFI+CT2_SBLOTE+DTOS(CT2_DATA)"	, "Correlativo + Sub Lote + Data Lcto"	, "Correlativo + Sub Lote + Data Lcto"	, "Correlativo + Sub Lote + Data Lcto"	, "S", "", "CT2CORRELA","S" })
aAdd(aSIX,{"CT2", "D",	"CT2_FILIAL+CT2_ORIGEM"							 			, "Origem"								, "Origem"								, "Origem"								, "S", "", "CT2ORIGEM","S"  })
aAdd(aSIX,{"CT2", "E",	"CT2_FILIAL+CT2_NODIA+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQIDX", 'Nro Diario + Data Lcto + Numero Lote + Sub Lote + Numero Doc + Numero','Nro Diario + Data Lcto + Numero Lote + Sub Lote + Numero Doc + Numero','Nro Diario + Data Lcto + Numero Lote + Sub Lote + Numero Doc + Numero','S',"","","S" })
aAdd(aSIX,{"CT2", "F",	"CT2_FILIAL+CT2_DIACTB+CT2_NODIA"				 		, "Cod.Diario + Nro Diario"				, "Cod.Diario + Nro Diario"				, "Cod.Diario + NroDiario"				, 'S', "", "","S"  })
aAdd(aSIX,{"CT2", "G",	"CT2_FILIAL+CT2_NODIA"							 			, "Nro Diario"							, "Nro Diario"							, "Nro Diario"							, 'S', "", "","S"  })

Aadd(aSIX,{"CVQ","1","CVQ_FILIAL+CVQ_CODIGO+CVQ_ITEM","Código + Item","Codigo + Item","Code + Item",'S',"","",'S'})

Aadd(aSIX,{"CTA","1","CTA_FILIAL+CTA_REGRA+CTA_ITREGR","Filial + Regra + Item","Rama + Regla + Item","Filial + Rule + Item",'S',"","",'S'})

Aadd(aSIX,{"CT0","1","CT0_FILIAL+CT0_ID","Item","Item","Item",'S',"","",'S'})

Aadd(aSIX,{"CV0","1","CV0_FILIAL+CV0_PLANO+CV0_CODIGO","Plano Contab + Codigo","Plan Contabl + Codigo","Accoun. Plan + Code",'S',"","",'S'})
Aadd(aSIX,{"CV0","2","CV0_FILIAL+CV0_CODIGO","Codigo","Codigo","Code",'S',"","",'S'})
Aadd(aSIX,{"CV0","3","CV0_FILIAL+CV0_PLANO+CV0_ENTSUP+CV0_CODIGO","Plano Contab + Entidade Superior + Codigo","Plan Contabl + Entidad Superior + Codigo ","Accoun. Plan + Superior Entity + Code",'S',"","",'S'})

Aadd(aSIX,{"CW0","1","CW0_FILIAL+CW0_TABELA+CW0_CHAVE","Tabela + Chave","Tabla + Clave","Table + Key",'S',"","",'S'})

Aadd(aSIX,{"CVX","1","CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_CHAVE+DTOS(CVX_DATA)" ,"Config. + Moeda + Chv.Concat. + Data","Config. + Moneda + Cl.Concat. + Fecha","Config + Currency + Concat. Key + Date",'S',"","",'S'})
Aadd(aSIX,{"CVX","2","CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_TPSALD+DTOS(CVX_DATA)","Config. + Moeda + Tp.Saldo + Data"   ,"Config. + Moneda + Tp.Saldo + Fecha"  ,"Config + Currency + Bal. Type + Date"  ,'S',"","",'S'})
If (cPaisLoc $ "COL|PER")
	Aadd(aSIX,{"CVX","3","CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_NIV01+CVX_NIV02+CVX_NIV03+CVX_NIV04+CVX_NIV05","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05","Config. + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05" ,"Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05" ,'S',"","",'S'})
Else
	Aadd(aSIX,{"CVX","3","CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_NIV01+CVX_NIV02+CVX_NIV03+CVX_NIV04+CVX_NIV05+CVX_NIV06","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06","Config. + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06" ,"Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05 + Level 06" ,'S',"","",'S'})
EndIf

Aadd(aSIX,{"CVY","1","CVY_FILIAL+CVY_CONFIG+CVY_MOEDA+CVY_CHAVE+DTOS(CVY_DATA)" ,"Config. + Moeda + Chv.Concat. + Data","Config. + Moneda + Clv.Concat. + Fecha","Config + Currency + Concat. Key + Date",'S',"","",'S'})
Aadd(aSIX,{"CVY","2","CVY_FILIAL+CVY_CONFIG+CVY_MOEDA+CVY_TPSALD+DTOS(CVY_DATA)","Config. + Moeda + Tp.Saldo + Data"   ,"Config. + Moneda + Tp.Saldo + Fecha"   ,"Config + Currency + Balance Tp + Date" ,'S',"","",'S'})
If (cPaisLoc $ "COL|PER")
	Aadd(aSIX,{"CVY","3","CVY_FILIAL+CVY_CONFIG+CVY_MOEDA+CVY_NIV01+CVY_NIV02+CVY_NIV03+CVY_NIV04+CVY_NIV05","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05","Config. + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05","Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05",'S',"","",'S'})
Else
	Aadd(aSIX,{"CVY","3","CVY_FILIAL+CVY_CONFIG+CVY_MOEDA+CVY_NIV01+CVY_NIV02+CVY_NIV03+CVY_NIV04+CVY_NIV05+CVY_NIV06","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06","Config. + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06","Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05 + Level 06",'S',"","",'S'})
EndIf

Aadd(aSIX,{"CVZ","1","CVZ_FILIAL+CVZ_CONFIG+CVZ_MOEDA+CVZ_CHAVE+DTOS(CVZ_DATA)" ,"Config. + Moeda + Chv.Concat. + Data","Configuracio + Moneda + Clv.Concat. + Fecha","Config + Currency + Concat. Key + Date",'S',"","",'S'})
Aadd(aSIX,{"CVZ","2","CVZ_FILIAL+CVZ_CONFIG+CVZ_MOEDA+CVZ_TPSALD+DTOS(CVZ_DATA)","Config. + Moeda + Tp.Saldo + Data"   ,"Configuracio + Moneda + Tp.Saldo + Fecha"   ,"Config + Currency + Balance Tp + Date" ,'S',"","",'S'})
If (cPaisLoc $ "COL|PER")
	Aadd(aSIX,{"CVZ","3","CVZ_FILIAL+CVZ_CONFIG+CVZ_MOEDA+CVZ_NIV01+CVZ_NIV02+CVZ_NIV03+CVZ_NIV04+CVZ_NIV05","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05","Configuracio + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05","Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05",'S',"","",'S'})
Else
	Aadd(aSIX,{"CVZ","3","CVZ_FILIAL+CVZ_CONFIG+CVZ_MOEDA+CVZ_NIV01+CVZ_NIV02+CVZ_NIV03+CVZ_NIV04+CVZ_NIV05+CVZ_NIV06","Config. + Moeda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06","Configuracio + Moneda + Nivel 01 + Nivel 02 + Nivel 03 + Nivel 04 + Nivel 05 + Nivel 06","Config + Currency + Level 01 + Level 02 + Level 03 + Level 04 + Level 05 + Level 06",'S',"","",'S'})
EndIf

Aadd(aSIX,{"CTA","1","CTA_FILIAL+CTA_REGRA+CTA_ITREGR","Filial + Regra + Item","Rama + Regla + Item","Filial + Rule + Item",'S',"","",'S'})

If cPaisLoc $ "COL" 
	Aadd(aSIX,{"CC2","1","CC2_FILIAL+CC2_EST+CC2_CODMUN","Estado+Municipio","Departamento+Municipio","State+City",'S',"","",'S'})
	Aadd(aSIX,{"CC2","2","CC2_FILIAL+CC2_MUN","Descrição","Descripcion","Description",'S',"","",'S'})
	Aadd(aSIX,{"CC2","3","CC2_FILIAL+CC2_CODMUN","Municipio","Municipio","City",'S',"","",'S'})   
EndIf                                                                                                                     

ProcRegua(Len(aSIX))

dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aDelSIX)
	If !Empty(aDelSIX[i,1])
		If dbSeek(aDelSIX[i,1]+aDelSIX[i,2])
			
			IF ALLTRIM(SIX->CHAVE) ==  ALLTRIM(aDelSIX[i,3])
				If Ascan(aArqUpd,aSIX[i,1]) == 0
					aAdd(aArqUpd,aSIX[i,1])
				EndIf
				RecLock("SIX",.F.)
				DbDelete()
				MsUnlock()
			ENDIF
			
		EndIf
		
		IncProc(STR0029) // //"Atualizando Indices..."
	EndIf
Next i

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf
		
		If  lNew .OR.;
			!(UPPER(AllTrim(CHAVE))==UPPER(Alltrim(aSIX[i,3]))) .OR.;
			!(UPPER(AllTrim(NICKNAME))==UPPER(Alltrim(aSIX[i,9]))) .OR.;
			(UPPER(aSIX[i,1])=="CVY" .AND. aSIX[i,2] == '1') 
			
			If Ascan(aArqUpd,aSIX[i,1]) == 0
				aAdd(aArqUpd,aSIX[i,1])
			EndIf
			lSIX := .T.
			
			#IFDEF TOP
			If !lNew
				If !(UPPER(AllTrim(CHAVE))==UPPER(Alltrim(aSIX[i,3])))
					TcSqlExec( "DROP INDEX " +RetSqlName(UPPER(aSIX[i,1]))+"."+RetSQLName(UPPER(aSIX[i,1]))+aSIX[i,2] )
				EndIf
			EndIf
			#ENDIF
			
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			
			RecLock("SIX",lNew)
			
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
		
		IncProc(STR0029) // //"Atualizando Indices..."
	EndIf
Next i

IncProc(STR0048) // // "Apagando Indices atualizados..."

If lSIX
	cTexto += STR0030+cAlias+CRLF //"Indices atualizados  : "
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX1 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos SX1                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX1()
//				X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL X1_PRESEL
//				X1_GSC     X1_VALID   X1_VAR01   X1_DEF01  X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
//				X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03  X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
// 				X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05  X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_GRPSXG X1_PYME
Local aSX1    	:= {}
Local aEstrut 	:= {}
Local aAjusX1	:= {}
Local i       	:= 0
Local j      	:= 0
Local lSX1	  	:= .F.
Local cTexto  	:= ''
Local cGrupo	:= ""

If (cPaisLoc == "BRA")
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO" ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL" ,;
	"X1_GSC"    ,"X1_VALID","X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02"  ,"X1_DEF02"  ,"X1_DEFSPA2",;
	"X1_DEFENG2","X1_CNT02","X1_VAR03"  ,"X1_DEF03" ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04"  ,"X1_DEF04"  ,"X1_DEFSPA4",;
	"X1_DEFENG4","X1_CNT04","X1_VAR05"  ,"X1_DEF05" ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3"     ,"X1_GRPSXG" ,"X1_PYME"}
Else
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO" ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL" ,;
	"X1_GSC"    ,"X1_VALID","X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02"  ,"X1_DEF02"  ,"X1_DEFSPA2",;
	"X1_DEFENG2","X1_CNT02","X1_VAR03"  ,"X1_DEF03" ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04"  ,"X1_DEF04"  ,"X1_DEFSPA4",;
	"X1_DEFENG4","X1_CNT04","X1_VAR05"  ,"X1_DEF05" ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3"     ,"X1_GRPSXG" ,"X1_PYME"}
EndIf

//Padr(x,10)usar apenas na versão 912
aAdd(aSX1,{Padr("CTB270",10),"01","Rateio Inicial ?"		, "Rateio Inicial ?"	, "Rateio Inicial ?" 	,"mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTQ","","S"})
aAdd(aSX1,{Padr("CTB270",10),"02","Rateio Final   ?"		, "Rateio Final   ?"	, "Rateio Final   ?" 	,"mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTQ","","S"})

aAdd(aSX1,{Padr("CTB276",10),"01","Grupo Inicial ?"		, "Grupo Inicial ?"		, "Grupo Inicial ?" 	,"mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CW1","","S"})
aAdd(aSX1,{Padr("CTB276",10),"02","Grupo Final   ?"		, "Grupo Final   ?"		, "Grupo Final   ?" 	,"mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CW1","","S"})
aAdd(aSX1,{Padr("CTB276",10),"03","Atualiza Rateios?"	, "Atualiza Rateios?"	, "Atualiza Rateios?"	,"mv_ch3","N",1,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","","","","S"})

aAdd(aSX1,{Padr("CTB277",10),"01","Amarracao Inicial ?"	, "Amarracao Inicial ?"	, "Amarracao Inicial ?" ,"mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CW2","","S"})
aAdd(aSX1,{Padr("CTB277",10),"02","Amarracao Final   ?"	, "Amarracao Final   ?"	, "Amarracao Final   ?" ,"mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CW2","","S"})
aAdd(aSX1,{Padr("CTB277",10),"03","Status da amarração?"	, "Status da amarração?", "Status da amarração?","mv_ch3","N",1,0,0,"C","","mv_par03","Pendentes/Alterados","Pendentes/Alterados","Pendentes/Alterados","","","Todos","Todos","Todos","","","","","","","","","","","","","","","","","","","S"})

aAdd(aSX1,{Padr("CTB278",10),"01","Indice Inicial ?"		, "Indice Inicial ?"	, "Indice Inicial ?" 	,"mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CW3","","S"})
aAdd(aSX1,{Padr("CTB278",10),"02","Indice Final   ?"		, "Indice Final   ?"	, "Indice Final   ?" 	,"mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CW3","","S"})
aAdd(aSX1,{Padr("CTB278",10),"03","Atualiza Rateios?"	, "Atualiza Rateios?"	, "Atualiza Rateios?"	,"mv_ch3","N",1,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","","","","S"})

// Perguntas referentes ao tipo de saldo
//         1		,2		,3						, 4					, 5					, 6			,7	,8,9,0, 11	,11
aAdd(aSX1,{"CTR165"	,"38"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_chz"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR38 , .T. )"	,"mv_par38","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR268"	,"06"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_ch6"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR06 , .T. )"	,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR500"	,"12"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_chc"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR12 , .T. )"	,"mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR510"	,"15"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_chf"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR15 , .T. )"	,"mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR511"	,"07"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_ch7"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR07 , .T. )"	,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR520"	,"10"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_cha"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR10 , .T. )"	,"mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR530"	,"07"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_ch7"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR07 , .T. )"	,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR540"	,"11"	,"Tipo de Saldo?"		, "Tipo de Saldo?"	, "Tipo de Saldo?" 	,"mv_chb"	,"C",1,0,0,"G"	,"VldTpSald( MV_PAR11 , .T. )"	,"mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})

DbSelectArea("SX1")
DbSetOrder(1) //X1_GRUPO+X1_ORDEM
If DbSeek(PADR("CTR520",10)+"10") .And. Empty(SX1->X1_F3)
	RecLock("SX1",.F.)
    X1_F3 := "SLD"
	dbCommit()
	MsUnLock()
EndIf

DbSelectArea("SX1")
DbSetOrder(1) //X1_GRUPO+X1_ORDEM
If DbSeek(PADR("CTR530",10)+"07") .And. Empty(SX1->X1_F3)
	RecLock("SX1",.F.)
    X1_F3 := "SLD"
	dbCommit()
	MsUnLock()
EndIf

// Lancamento Padronizado
aAdd(aSX1,{"CTB086"	,"01"	,"Visao por Processo?"	, "Visao por Processo?"	, "Visao por Processo?" ,"mv_ch1","N",1,0,0,"C"	,""	,"mv_par01","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","S"})

// Copia de Multiplos Tipos de Saldos
aAdd(aSX1,{"CTM300"	,"14"	,"Multiplos Tipos de Saldos?", "Multiplos Tipos de Saldos?", "Multiplos Tipos de Saldos?", "mv_che","C",1,0,0,"C"	,""	,"mv_par14","Desconsidera","Desconsidera","Desconsidera","","","Controla","Controla","Controla","","","","","","","","","","","","","S"})

// Perguntas do ajuste da rotina CTBA160(F12)
aAdd(aSX1,{"CTB160" ,"01" ,"Incrementa de ?"         ,"Incrementa de ?"         ,"Incrementa de ?"         ,"mv_ch1"	,"N",02,0,0,"G"	,""	,"mv_par01",""                     ,""                     ,""                     ,"","",""                     ,""                     ,""                     ,"","",""        ,""        ,""        ,"","","","","","","","","","","","","","S"})
aAdd(aSX1,{"CTB160" ,"02" ,"Gera Cod Entidade ? "    ,"Gera Cod Entidade ? "    ,"Gera Cod Entidade ? "    ,"mv_ch2"	,"N",01,0,0,"C"	,""	,"mv_par02","Automatico"           ,"Automatico"           ,"Automatico"           ,"","","Formula"              ,"Formula"              ,"Formula"              ,"","","Digitado","Digitado","Digitado","","","","","","","","","","","","","","S"})
aAdd(aSX1,{"CTB160" ,"03" ,"Formula Cod Entidade ?"  ,"Formula Cod Entidade ?"  ,"Formula Cod Entidade ?"  ,"mv_ch3"	,"C",30,0,0,"G"	,""	,"mv_par03",""                     ,""                     ,""                     ,"","",""                     ,""                     ,""                     ,"","",""        ,""        ,""        ,"","","","","","","","","","","","","","S"})
aAdd(aSX1,{"CTB160" ,"04" ,"Formatar Cod Entidade ?" ,"Formatar Cod Entidade ?" ,"Formatar Cod Entidade ?" ,"mv_ch4"	,"N",01,0,0,"C"	,""	,"mv_par04","Com zeros a esquerda" ,"Com zeros a esquerda" ,"Com zeros a esquerda" ,"","","Sem zeros a esquerda" ,"Sem zeros a esquerda" ,"Sem zeros a esquerda" ,"","",""        ,""        ,""        ,"","","","","","","","","","","","","","S"})

/*
Aadd(aPergs,{"Usa Classe de Valor?","¨Usa Clase de Valor?"  ,"Use Value Class    ?","mv_chv","N",1		       ,0,1,"C","","mv_par31","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",""})
*/

//Pergunta referente ao processamento na amarração
aAdd(aSX1,{"CTB250"	,"01"	,"modelo antigo?"       ,"¿Deseja utilizar espanho ?"           ,"Deseja utilizar o ing ?"        ,"mv_ch1"	,"C", 1,0,0,"C"	,""	                        ,"mv_par01","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})

// Perguntas da rotina de aglutinacao de dados configurada (CTBA231)
//         1		,2		,3						     , 4					          , 5					         , 6		,7	, 8,9,0, 11	,11
aAdd(aSX1,{"CTB231"	,"01"	,"Limpa Consolidacao ?"      ,"¿Limpia Consolidacion ?"       ,"Clear Consolidation ?"       ,"mv_ch1"	,"N", 1,0,2,"C"	,""	                        ,"mv_par01","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"02"	,"Da Data ?"                 ,"¿De Fecha ?"                   ,"From Date ?"                 ,"mv_ch2"	,"D", 8,0,0,"G"	,""	                        ,"mv_par02",""            ,""             ,""              ,"01/01/2009",""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"03"	,"Ate a Data ?"              ,"¿A Fecha ?"                    ,"To Date ?"                   ,"mv_ch3"	,"D", 8,0,0,"G"	,""	                        ,"mv_par03",""            ,""             ,""              ,"31/12/2009",""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"04"	,"Apaga ?"                   ,"¿Borra ?"                      ,"Delete ?"                    ,"mv_ch4"	,"N", 1,0,1,"C"	,""	                        ,"mv_par04","Periodo"     ,"Periodo"      ,"Period"        ,""          ,""        ,"Tudo"           ,"Todo"           ,"All"           ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"05"	,"Processa Moeda ?"          ,"¿Procesa Moneda ?"             ,"Process Currency ?"          ,"mv_ch5"	,"N", 1,0,0,"C"	,""	                        ,"mv_par05","Todas Moedas","Todas Monedas","All Currencies",""          ,""        ,"Moeda Especific","Moneda Especif.","Espec.Currency","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"06"	,"Qual Moeda ?"              ,"¿Que Moneda ?"                 ,"Which Currency ?"            ,"mv_ch6"	,"C", 2,0,0,"G"	,""	                        ,"mv_par06",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTB231"	,"07"	,"Tipo de Saldo ?"           ,"¿Tipo de Saldo ?"              ,"Balance Type ?"              ,"mv_ch7"	,"C", 1,0,0,"G"	,"VldTpSald( MV_PAR07 , .T. )","mv_par07",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTB231"	,"08"	,"Gera lanc.saldo inicial ?" ,"¿Genera reg. saldo inicial ?"  ,"Gener init. balance entry ?" ,"mv_ch8"	,"N", 1,0,0,"C"	,""	                        ,"mv_par08","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"09"	,"Lote saldo inicial ?"      ,"¿Lote saldo inicial ?"         ,"Initial balance lot ?"       ,"mv_ch9"	,"C", 6,0,0,"G"	,""	                        ,"mv_par09",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"10"	,"SubLote saldo inicial ?"   ,"¿Sublote saldo inicial ?"      ,"Initial balance Sub-lot ?"   ,"mv_cha"	,"C", 3,0,0,"G"	,""	                        ,"mv_par10",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"11"	,"Documento saldo inicial ?" ,"¿Documento saldo inicial ?"    ,"Initial balance document ?"  ,"mv_chb"	,"C", 6,0,0,"G"	,""	                        ,"mv_par11",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"12"	,"Roteiro de ?"              ,"¿De procedimiento ?"           ,"From Roadmap Code ?"         ,"mv_chc"	,"C", 3,0,0,"G"	,""			                ,"mv_par12",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","CTB","","S"})
aAdd(aSX1,{"CTB231"	,"13"	,"Roteiro ate ?"             ,"¿A procedimiento ?"            ,"To Roadmap Code ?"           ,"mv_chd"	,"C", 3,0,0,"G"	,""			                ,"mv_par13",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","CTB","","S"})
aAdd(aSX1,{"CTB231"	,"14"	,"Aglut Lancamentos ?"       ,"¿Agrupa Asientos ?"            ,"Group Entries ?"             ,"mv_che"	,"C", 1,0,0,"C"	,""	                        ,"mv_par14","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"15"	,"Historico Aglutinado ?"    ,"¿Historial Agrupado ?"         ,"Grouped history ?"           ,"mv_chf"	,"C",99,0,0,"G"	,""	                        ,"mv_par15",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTB231"	,"16"	,"Reprocessa Saldos ?"       ,"¿Reprocesa Saldos ?"           ,"Reprocess Balances ?"        ,"mv_chg"	,"C", 1,0,0,"C"	,""	                        ,"mv_par16","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek( PadR( "CTB231", 10 ) + "12" ) .And. (SX1->X1_PERGUNT != "Roteiro de ?" .Or. !Empty(SX1->X1_VALID) )
	SX1->(dbSeek( "CTB231" ))
	Do While SX1->(!EOF()) .And. ALLTRIM(SX1->X1_GRUPO) == "CTB231"
		RecLock("SX1",.F.)
		SX1->(DbDelete())
		SX1->(MsUnlock())
		SX1->(dbSkip())
	EndDo
EndIf

// Perguntas referentes aos relatórios gerenciais em formato generico
//         1		,2		,3						      , 4					           , 5					         , 6		,7	, 8,9,0, 11	,11
aAdd(aSX1,{"CTR500"	,"13"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chd"	,"N", 1,0,2,"C"	,""	                        ,"mv_par13","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR510"	,"16"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chg"	,"N", 1,0,2,"C"	,""	                        ,"mv_par16","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR511"	,"08"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_ch8"	,"N", 1,0,2,"C"	,""	                        ,"mv_par08","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR519"	,"08"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_ch8"	,"N", 1,0,2,"C"	,""	                        ,"mv_par08","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR520"	,"11"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chb"	,"N", 1,0,2,"C"	,""	                        ,"mv_par11","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR530"	,"08"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_ch8"	,"N", 1,0,2,"C"	,""	                        ,"mv_par08","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR540"	,"12"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chc"	,"N", 1,0,2,"C"	,""	                        ,"mv_par12","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR560"	,"22"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chm"	,"N", 1,0,2,"C"	,""	                        ,"mv_par22","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR570"	,"21"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chl"	,"N", 1,0,2,"C"	,""	                        ,"mv_par21","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aSX1,{"CTR700"	,"17"	,"Titulo como nome da visao ?","¿Tit como nombre de la vision?","Title as vision name ?"     ,"mv_chh"	,"N", 1,0,2,"C"	,""	                        ,"mv_par17","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aSX1,{"CT381A" ,"01" ,"Data de referencia ?"    ,"¿Fecha de referencia ?"     ,"Reference Date ?"        ,"MV_CH1" ,"D" ,8  ,0 ,0 ,"G" ,"" ,"mv_par01" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"02" ,"Numero do Lote ?"        ,"¿Numero del Lote ?"         ,"Lot Number ?"            ,"MV_CH2" ,"C" ,6  ,0 ,0 ,"G" ,"" ,"mv_par02" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"03" ,"Numero do Sub-Lote ?"    ,"¿Numero del Sublote ?"      ,"Sublot Number ?"         ,"MV_CH3" ,"C" ,3  ,0 ,0 ,"G" ,"" ,"mv_par03" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"SB"  ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"04" ,"Numero do Documento ?"   ,"¿Numero del Documento ?"    ,"Document Number ?"       ,"MV_CH4" ,"C" ,6  ,0 ,0 ,"G" ,"" ,"mv_par04" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"05" ,"Cod. Historico Padrao ?" ,"¿Cod. Historial Estandar ?" ,"Standard History Code ?" ,"MV_CH5" ,"C" ,3  ,0 ,0 ,"G" ,"" ,"mv_par05" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"CT8" ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"06" ,"Da conta ?"              ,"¿De cuenta ?"               ,"From Account ?"          ,"MV_CH6" ,"C" ,20 ,0 ,0 ,"G" ,"" ,"mv_par06" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"CT1" ,"003" ,"S"})
aAdd(aSX1,{"CT381A" ,"07" ,"Ate a conta ?"           ,"¿A cuenta ?"                ,"To account ?"            ,"MV_CH7" ,"C" ,20 ,0 ,0 ,"G" ,"" ,"mv_par07" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"CT1" ,"003" ,"S"})
aAdd(aSX1,{"CT381A" ,"08" ,"Moeda base ?"            ,"¿Moneda base ?"             ,"Currency basis ?"        ,"MV_CH8" ,"C" ,2  ,0 ,0 ,"G" ,"" ,"mv_par08" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"CTO" ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"09" ,"Tipo de saldo ?"         ,"¿Tipo de saldo ?"           ,"Balance type ?"          ,"MV_CH9" ,"C" ,1  ,0 ,0 ,"G" ,"" ,"mv_par09" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"SLD" ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"10" ,"Desmembra lancamento ?"  ,"¿Desglosa asiento ?"        ,"Split entry ?"           ,"MV_CHA" ,"N" ,1  ,0 ,0 ,"C" ,"" ,"mv_par10" ,"Sim"        ,"Si"          ,"Yes"           ,"" ,"" ,"Não"             ,"No"              ,"No"              ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"11" ,"Considera criterio ?"    ,"¿Considera criterio ?"      ,"Consider criterion ?"    ,"MV_CHB" ,"N" ,1  ,0 ,0 ,"C" ,"" ,"mv_par11" ,"Moeda"      ,"Moneda"      ,"Currency"      ,"" ,"" ,"Plano de contas" ,"Plan de cuentas" ,"Chart of Acc."   ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"12" ,"Taxa informada ?"        ,"¿Tasa informada ?"          ,"Rate informed ?"         ,"MV_CHC" ,"N" ,8  ,4 ,0 ,"G" ,"" ,"mv_par12" ,""           ,""            ,""              ,"" ,"" ,""                ,""                ,""                ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"13" ,"Considera CCusto ?"      ,"¿Considera CCosto ?"        ,"Consider cost center ?"  ,"MV_CHD" ,"N" ,1  ,0 ,2 ,"C" ,"" ,"mv_par13" ,"Sim"        ,"Si"          ,"Yes"           ,"" ,"" ,"Não"             ,"No"              ,"No"              ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"14" ,"Considera Item Cta ?"    ,"¿Considera Item Cta ?"      ,"Consider Acct. Item ?"   ,"MV_CHE" ,"N" ,1  ,0 ,2 ,"C" ,"" ,"mv_par14" ,"Sim"        ,"Si"          ,"Yes"           ,"" ,"" ,"Não"             ,"No"              ,"No"              ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"15" ,"Considera Cl.Valor ?"    ,"¿Considera Cl.Valor ?"      ,"Consider value class ?"  ,"MV_CHF" ,"N" ,1  ,0 ,2 ,"C" ,"" ,"mv_par15" ,"Sim"        ,"Si"          ,"Yes"           ,"" ,"" ,"Não"             ,"No"              ,"No"              ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})
aAdd(aSX1,{"CT381A" ,"16" ,"Metodo de Variacao ?"    ,"¿Metodo de Variacion ?"     ,"Method of Variation ?"   ,"MV_CHG" ,"N" ,1  ,0 ,1 ,"C" ,"" ,"mv_par16" ,"Moeda Base" ,"Moneda Base" ,"Base Currency" ,"" ,"" ,"Moeda Forte"     ,"Moneda Fuerte"   ,"Strong Currency" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,""    ,""    ,"S"})

//Exclui os perguntes da rotina CTBA381 para geracao correta (usa como criterio a presença do antigo código de help)
DbSelectArea("SX1")
DbSetOrder(1) //X1_GRUPO+X1_ORDEM
If DbSeek(PADR("CT381A",10)+"01") .And. "CTB380" $ SX1->X1_HELP
	Do While SX1->(!EOF()) .And. AllTrim(SX1->X1_GRUPO) == "CT381A"
		RecLock("SX1",.F.)
		SX1->(DbDelete())
		SX1->(MsUnLock())
	SX1->(DbSkip())
	EndDo
EndIf


aAdd(aSX1,{"CTA450","01","O que deseja fazer ?"			,"¿Que desea hacer ?"				,"What to do ?"					,"MV_CH1","N",1		,0	,1	,"C","!Empty(mv_par01)"	,"mv_par01","Importar Modelo"	,"Importar Modelo"	,"Import Model"		,"","","Ver/Alterar"		,"Ver/Modificar"	,"View/Edit"		,"","Excluir Visao"	,"","","","","","","","","","","","","","","",""		,"S"})
aAdd(aSX1,{"CTA450","02","Codigo da Visao Gerencial ?"	,"¿Cod. de la Vision de Gestion"	,"Managerial View Code ?"		,"MV_CH2","C",3		,0	,0	,"G","!Empty(mv_par02)"	,"mv_par02",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTS"	,""	,"S"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim dasTabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



// Grupo CTBSP2 - utilizado na geracao do SPED Contabil - funcao SPEDCTB_RA()
aAdd(aSX1,{"CTBSP2","01", "Tipo Escrituracao ?"          , "Tipo Escrituracao ?"          , "Tipo Escrituracao ?"          , "mv_ch1","N", 1,0,0,"C",""             ,"mv_par01","Sem Centraliz.","Sem Centraliz.","Sem Centraliz.","","","Com Centraliz.","Com Centraliz.","Com Centraliz.","","","","","","","","","","","","","","","","","","","S"})
aAdd(aSX1,{"CTBSP2","02", "Situacao Especial ?"          , "Situacao Especial ?"          , "Situacao Especial ?"          , "mv_ch2","C", 1,0,0,"G","ExistSitEsp(M->MV_PAR02)","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTBSP1","","S"})
aAdd(aSX1,{"CTBSP2","03", "Numero do Livro Geral ?"      , "Numero do Livro Geral ?"      , "Numero do Livro Geral ?"      , "mv_ch3","N", 4,0,0,"G",""             ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP2","04", "Numero do Livro Auxiliar ?"   , "Numero do Livro Auxiliar ?"   , "Numero do Livro Auxiliar ?"   , "mv_ch4","N", 4,0,0,"G",""             ,"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP2","05", "Natureza do Livro Auxiliar ?" , "Natureza do Livro Auxiliar ?" , "Natureza do Livro Auxiliar?"  , "mv_ch5","C",80,0,0,"G",""             ,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP2","06", "Periodo Inicial de Lcto ?"    , "Periodo Inicial de Lcto ?"    , "Periodo Inicial de Lcto ?"    , "mv_ch6","D", 8,0,0,"G",""             ,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP2","07", "Periodo Final de Lcto ?"      , "Periodo Final de Lcto ?"      , "Periodo Final de Lcto ?"      , "mv_ch7","D", 8,0,0,"G",""             ,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP2","08", "Razao Auxiliar Config ?"      , "Razao Auxiliar Config ?"      , "Razao Auxiliar Config ?"      , "mv_ch8","C",99,0,0,"G",""             ,"mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})


// Grupo CTBSP4 - utilizado na geracao do SPED Contabil - funcao SPEDCTB_LA()
aAdd(aSX1,{"CTBSP4","01", "Data Inicial ?"               , "Data Inicial das informaces ?", "Data Inicial das informaces ?", "mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP4","02", "Data Final ?"                 , "Data Final das informaces ?"  , "Data Final das informaces ?"  , "mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP4","03", "Entidade ?"                   , "Entidade ?"                   , "Entidade ?"                   , "mv_ch3","N", 1,0,0,"C","","mv_par03","Cliente","Cliente","Cliente","3","","Fornecedor","Fornecedor","Fornecedor","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","S"})
aAdd(aSX1,{"CTBSP4","04", "Data Conversao Moeda ?"       , "Data Conversao Moeda ?"       , "Data Conversao Moeda ?"       , "mv_ch4","N", 1,0,0,"C","","mv_par04","Data Geracao","Data Geracao","Data Geracao","1","","Data Base","Data Base","Data Base","","","Vencimento","Vencimento","Vencimento","","","Final Periodo","Final Periodo","Final Periodo","","","","","","","","","S"})
aAdd(aSX1,{"CTBSP4","05", "Arquivo de Destino ?"         , "Arquivo de Destino ?"         , "Arquivo de Destino ?"         , "mv_ch5","C",30,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTBSP4","06", "Diretorio ?"                  , "Diretorio ?"                  , "Diretorio ?"                  , "mv_ch6","C",60,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})

// Grupo CTR076 - Relatório de Histórico de Alterações.
aAdd(aSX1,{"CTR076","01", "Data Inicial ?"               , "¿Fecha Inicio ?"			   , "Start Date ?"					, "mv_ch1","D", 8	,0	,0	,"G",""					,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTR076","02", "Data Final ?"                 , "¿Fecha Final ?"				   , "Final Date ?"  				, "mv_ch2","D", 8	,0	,0	,"G",""					,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
aAdd(aSX1,{"CTR076","03", "Entidade ?"                   , "¿Entidad ?"                    , "Entity ?"                   	, "mv_ch3","N", 1	,0	,0	,"C",""					,"mv_par03","Conta"             ,"Cuenta"     		,"Account"      	,"","","Centro Custos"      ,"Costos"           ,"Cost"             ,"","" 				,"Item Contábil" ,"Item Contable" ,"Accounting Item","","","Classe de Valor"	,"Clase de Valor","Value Class","","",""    	,""			,""			,"","","S"})
aAdd(aSX1,{"CTR076","04", "Considera Bloqueio ?"         , "¿Considera bloque ?"           , "Considers Block ?"           	, "mv_ch4","N", 1	,0	,0	,"C",""					,"mv_par04","Sim"               ,"Sí"        		,"Yes"              ,"","","Não"          		,"No"         		,"No"           	,"",""          	,""           ,""           ,""          ,"","",""              	,""              ,""           ,"","",""        ,""         ,""         ,"","","S"})
aAdd(aSX1,{"CTR076","05", "Considera Operações ?"        , "¿Considera Operaciones ?"      , "Considers Operations ?"      	, "mv_ch5","N", 1	,0	,0	,"C",""					,"mv_par05","Inclusão"          ,"Inclusión"   		,"Inclusion"        ,"","","Alteração"    		,"Cambio"      		,"Change"          	,"",""          	,"Exclusão"   ,"Exclusion"  ,"Exclusion" ,"","","Todas"           	,"Todas"         ,"All"        ,"","",""        ,""         ,""         ,"","","S"})

// Grupo CTR580 - Demonstrativo de Resultados - Grupo x Conta x CCusto x Item x Classe de Valor.
aAdd(aSX1,{"CTR580","01","Data de referencia ?"	  		,"¿Fecha de referencia ?"			,"Reference Date ?"		   		,"MV_CH1","D",8		,0	,0	,"G",""					,"mv_par01",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR580","02","Da conta ?"			  		,"¿De cuenta ?"						,"From Account ?"		  		,"MV_CH2","C",20	,0	,0	,"G",""					,"mv_par02",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aSX1,{"CTR580","03","Ate a conta ?"		 		,"¿A cuenta ?"						,"To account ?"		   	  		,"MV_CH3","C",20	,0	,0	,"G",""					,"mv_par03",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aSX1,{"CTR580","04","Da natureza ?"		  		,"¿De la modalidad ?"				,"From Accounting Class?"		,"MV_CH4","C",9		,0	,0	,"G",""					,"mv_par04",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR580","05","Ate a natureza ?"		  		,"¿Ate la modalidad ?"				,"To Accounting Class ?"		,"MV_CH5","C",9		,0	,0	,"G",""					,"mv_par05",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR580","06","Configuracao do Libro?"  		,"¿Configuracion del Libro?"		,"CoT.Recs.Conf.Code ? "        ,"MV_CH6","C",3		,0	,0	,"G",""					,"mv_par06",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTN"	,""	,"S"})
aAdd(aSX1,{"CTR580","07","Moeda ?"			  			,"¿Moneda ?"						,"Currency ?"			  		,"MV_CH7","C",2		,0	,0	,"G",""					,"mv_par07",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTO"	,""	,"S"})
aAdd(aSX1,{"CTR580","08","Dem. Periodo Anterior ?" 		,"¿Dem. Periodo Anterior ?"			,"Display Previous Period ?"	,"MV_CH8","N",1		,0	,0	,"C",""					,"mv_par08","Sim"				,"Si"				,"Yes"				,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","","SLD"	,""	,"S"})
aAdd(aSX1,{"CTR580","09","Tipo de Saldo?"				,"Tipo de Saldo?"					,"Tipo de Saldo?" 				,"mv_CH9","C",1		,0	,0	,"G","VldTpSald( MV_PAR09 , .T. )"	,"mv_par09"			,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","SLD"	,""	,"S"})
aAdd(aSX1,{"CTR580","10","Folha Inicial ?"		  		,"¿Pagina de inicio ?"				,"Initial Payroll ?"			,"MV_CHA","N",6		,0	,0	,"G",""					,"mv_par10",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR580","11","Saldos zerados ?"				,"¿Saldos igual a cero ?"			,"Zeroed balances ?"	  		,"MV_CHB","N",1		,0	,0	,"C",""					,"mv_par11","Sim"				,"Si"				,"Yes"				,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR580","12","Considera ?"			  		,"¿Considera ?"						,"Consider ?"			   		,"MV_CHC","N",1		,0	,0	,"C",""					,"mv_par12","Mov. Periodo"		,"Mov. Periodo"		,"Period Mov."		,"","","Saldo Acumulado"	,"Saldo Acumulado"	,"Accum. Balance"	,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR580","13","Descricao na Moeda ?"	 		,"¿Descripcion en Moneda ?"			,"Description in currency ?"   	,"MV_CHD","C",2 	,0	,0	,"G",""					,"mv_par13",""     				,""      			,""        	   		,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR580","14","Titulo como nome da visao ?"	,"¿Tit como nombre de la vision?"	,"Title as vision name ?"  		,"MV_CHE","N",1		,0	,0	,"C",""					,"mv_par14","Sim"				,"Si"				,"Yes"		   		,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})

// Grupo CTR581 - Demonstrativo de Resultados - Centro de Custos x Conta x Natureza Contabil x Item x Classe de Valor.
aAdd(aSX1,{"CTR581","01","Data de referencia ?"	  		,"¿Fecha de referencia ?"			,"Reference Date ?"		   		,"MV_CH1","D",8		,0	,0	,"G",""					,"mv_par01",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR581","02","Da conta ?"			  		,"¿De cuenta ?"						,"From Account ?"		  		,"MV_CH2","C",20	,0	,0	,"G",""					,"mv_par02",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aSX1,{"CTR581","03","Ate a conta ?"		 		,"¿A cuenta ?"						,"To account ?"		   	  		,"MV_CH3","C",20	,0	,0	,"G",""					,"mv_par03",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aSX1,{"CTR581","04","Do Centro de Custos?"	  		,"¿Del Centro de Costos?"			,"From Cost Area?"				,"MV_CH4","C",9		,0	,0	,"G",""					,"mv_par04",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR581","05","Ate Centro de Custos?"		,"¿Ate Centro de Costos?"			,"To Cost Area?"				,"MV_CH5","C",9		,0	,0	,"G",""					,"mv_par05",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR581","06","Configuracao do Livro?"  		,"¿Configuracion del Libro?"		,"CoT.Recs.Conf.Code ? "        ,"MV_CH6","C",3		,0	,0	,"G",""					,"mv_par06",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTN"	,""	,"S"})
aAdd(aSX1,{"CTR581","07","Moeda ?"			  			,"¿Moneda ?"						,"Currency ?"			  		,"MV_CH7","C",2		,0	,0	,"G",""					,"mv_par07",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTO"	,""	,"S"})
aAdd(aSX1,{"CTR581","08","Dem. Periodo Anterior ?" 		,"¿Dem. Periodo Anterior ?"			,"Display Previous Period ?"	,"MV_CH8","N",1		,0	,0	,"C",""					,"mv_par08","Sim"				,"Si"				,"Yes"				,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","","SLD"	,""	,"S"})
aAdd(aSX1,{"CTR581","09","Tipo de Saldo?"				,"Tipo de Saldo?"					,"Tipo de Saldo?" 				,"mv_CH9","C",1		,0	,0	,"G","VldTpSald( MV_PAR09 , .T. )"	,"mv_par09"			,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","SLD"	,""	,"S"})
aAdd(aSX1,{"CTR581","10","Folha Inicial ?"		  		,"¿Pagina de inicio ?"				,"Initial Payroll ?"			,"MV_CHA","N",6		,0	,0	,"G",""					,"mv_par10",""					,""					,""					,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","","CTR"	,""	,"S"})
aAdd(aSX1,{"CTR581","11","Saldos zerados ?"				,"¿Saldos igual a cero ?"			,"Zeroed balances ?"	  		,"MV_CHB","N",1		,0	,0	,"C",""					,"mv_par11","Sim"				,"Si"				,"Yes"				,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR581","12","Considera ?"			  		,"¿Considera ?"						,"Consider ?"			   		,"MV_CHC","N",1		,0	,0	,"C",""					,"mv_par12","Mov. Periodo"		,"Mov. Periodo"		,"Period Mov."		,"","","Saldo Acumulado"	,"Saldo Acumulado"	,"Accum. Balance"	,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR581","13","Descricao na Moeda ?"	 		,"¿Descripcion en Moneda ?"			,"Description in currency ?"   	,"MV_CHD","C",2 	,0	,0	,"G",""					,"mv_par13",""     				,""      			,""        	   		,"","",""					,""					,""					,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})
aAdd(aSX1,{"CTR581","14","Titulo como nome da visao ?"	,"¿Tit como nombre de la vision?"	,"Title as vision name ?"  		,"MV_CHE","N",1		,0	,0	,"C",""					,"mv_par14","Sim"				,"Si"				,"Yes"		   		,"","","Näo"				,"No"				,"No"				,"",""				,"","","","","","","","","","","","","","",""		,""	,"S"})

If cPaisLoc == "COL"
	// Grupo CTR521 - Utilizado para Relatorios Pre-Impressos (Borradores 102,131,300 e 350, Colombia)
	aAdd(aSX1,{"CTR521","01", "Periodo de ?"            	 , "¿Periodo de ?"			   	   , "Period from ?"                , "mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
	aAdd(aSX1,{"CTR521","02", "Perido ate ?"                 , "¿Periodo a ?"  				   , "Period to ?"                  , "mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
	aAdd(aSX1,{"CTR521","03", "Codigo Config. Livro?"   	 , "¿Codigo Config. Libro?"	  	   , "CoT.Recs.Conf.Code ? "        , "MV_ch3","C", 3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTN"	,""	,"S"})
	aAdd(aSX1,{"CTB521","04", "Qual Moeda ?"                 , "¿Que Moneda ?"                 , "Which Currency ?"             , "mv_ch4","C", 2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","S"})
	aAdd(aSX1,{"CTB521","05", "Tipo de Saldo ?"              , "¿Tipo de Saldo ?"              , "Balance Type ?"               , "mv_ch5","C", 1,0,0,"G","VldTpSald( MV_PAR05 , .T. )","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S"})
	aAdd(aSX1,{"CTR521","06", "Titulo como nome da visao ?"  , "¿Tit como nombre de la vision?", "Title as vision name ?"       , "mv_ch6","N", 1,0,2,"C",""	                       ,"mv_par06","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
	
	// Grupo CTB950 - Programa gerador de Meios magnéticos
	aAdd(aSX1,{"CTB950","01", "Data Inicial ?"            	 , "¿Fecha Inicial ?"			   , "Initial Date ?"               , "mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
	aAdd(aSX1,{"CTB950","02", "Data Final ?"                 , "¿Fecha Final ?"  			   , "Final Date ?"                 , "mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""      ,"","S"})
	aAdd(aSX1,{"CTB950","03", "Instr. Normativa?"   	     , "¿Instruc. Normativa?"	  	   , "Normat. Instruction ? "       , "MV_ch3","C", 8,0,0,"G","mata955('*.ini','mv_par03')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","S"})
	aAdd(aSX1,{"CTB950","04", "Arq. Destino ?"               , "¿Archivo Destino ?"            , "Target File ?"                , "mv_ch4","C",40,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","S"})
	aAdd(aSX1,{"CTB950","05", "Diretório ?"                  , "¿Carpeta ?"                    , "Path ?"                       , "mv_ch5","C",30,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","S"})
	aAdd(aSX1,{"CTB950","06", "Seleciona Filiais ?"  		 , "¿Selecciona Sucursales ?"      , "Select Branchies ?"           , "mv_ch6","N", 1,0,2,"C","","mv_par06","Sim"         ,"Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
	aAdd(aSX1,{"CTB950","07", "Registros por Arquivo ?"  	 , "¿Registros por Archivo ?"      , "Record by File ?"             , "mv_ch7","N", 4,0,0,"G","","mv_par07","","","","","5000","","","","","","","","","","","","","","","","","","","","","","S"})
EndIf

// Grupo CTR051 - Relatorio de Balancete por Entidade.
aAdd(aSX1,{"CTR051","01","Data inicial?"             ,"Data inicial?"             , "Data inicial?"             ,"mv_ch1","D",8,0,0,"G",""                         ,"mv_par01",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","02","Data Final?"               ,"Data Final?"               , "Data Final?"               ,"mv_ch1","D",8,0,0,"G",""                         ,"mv_par02",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","03","Saldo Zerados?"            ,"Saldo Zerados?"            , "Saldo Zerados?"            ,"mv_ch3","N",1,0,1,"C",""                         ,"mv_par03","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","04","Moeda?"                    ,"Moeda?"                    , "Moeda?"                    ,"mv_ch4","C",2,0,0,"G",""                         ,"mv_par04",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTR051","05","Tipo de Saldo?"            ,"Tipo de Saldo?"            , "Tipo de Saldo?"            ,"mv_ch5","C",1,0,0,"G","VldTpSald( MV_PAR05 ,.T.)","mv_par05",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR051","06","Imprime Coluna Mov.?"      ,"Imprime Coluna Mov.?"      , "Imprime Coluna Mov.?"      ,"mv_ch6","N",1,0,1,"C",""                         ,"mv_par06","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","07","Imprime Valor 0.00?"       ,"Imprime Valor 0.00?"       , "Imprime Valor 0.00?"       ,"mv_ch7","N",1,0,1,"C",""                         ,"mv_par07","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","08","Num.linhas p/ o Balancete?","Num.linhas p/ o Balancete?", "Num.linhas p/ o Balancete?","mv_ch8","N",2,0,0,"G",""                         ,"mv_par08",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","09","Descricao na moeda?"       ,"Descricao na moeda?"       , "Descricao na moeda?"       ,"mv_ch9","C",2,0,0,"G",""                         ,"mv_par09",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR051","10","Impr. Ate Entidade?"       ,"Impr. Ate Entidade?"       , "Impr. Ate Entidade?"       ,"mv_cha","C",2,0,0,"G",""                         ,"mv_par10",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CT0","","S"})

// Grupo CTR403 - Relatorio de Razao por Entidade.
aAdd(aSX1,{"CTR403","01","Data inicial?"         ,"Data inicial?"         , "Data inicial?"         ,"mv_ch1","D",8,0,0,"G",""                       ,"mv_par01",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR403","02","Data Final?"           ,"Data Final?"           , "Data Final?"           ,"mv_ch2","D",8,0,0,"G",""                       ,"mv_par02",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR403","03","Moeda?"                ,"Moeda?"                , "Moeda?"                ,"mv_ch3","C",2,0,0,"G",""                       ,"mv_par03",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTR403","04","Tipo de Saldo?"        ,"Tipo de Saldo?"        , "Tipo de Saldo?"        ,"mv_ch4","C",1,0,0,"G","VldTpSald(MV_PAR04,.T.)","mv_par04",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTR403","05","Num.linhas p/ o Razão?","Num.linhas p/ o Razão?", "Num.linhas p/ o Razão?","mv_ch5","N",2,0,0,"G",""                       ,"mv_par05",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTR403","06","Descricao na moeda?"   ,"Descricao na moeda?"   , "Descricao na moeda?"   ,"mv_ch6","C",2,0,0,"G",""                       ,"mv_par06",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTR403","07","Impr. Ate Entidade?"   ,"Impr. Ate Entidade?"   , "Impr. Ate Entidade?"   ,"mv_ch7","C",2,0,0,"G",""                       ,"mv_par07",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CT0","","S"})
aAdd(aSX1,{"CTR403","08","Seleciona filiais?"    ,"Seleciona filiais?"    , "Seleciona filiais?"    ,"mv_ch8","N",1,0,0,"C",""                       ,"mv_par08","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""   ,"","S"})

// Grupo CTBC403 - Relatorio de Consulta por Entidade.
aAdd(aSX1,{"CTBC403","01","Data inicial?"           ,"Data inicial?"           ,"Data inicial?"          ,"mv_ch1","D",8,0,0,"G",""                       ,"mv_par01",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTBC403","02","Data Final?"             ,"Data Final?"             ,"Data Final?"            ,"mv_ch2","D",8,0,0,"G",""                       ,"mv_par02",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","",""   ,"","S"})
aAdd(aSX1,{"CTBC403","03","Moeda?"                  ,"Moeda?"                  ,"Moeda?"                 ,"mv_ch3","C",2,0,0,"G",""                       ,"mv_par03",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTBC403","04","Tipo de Saldo?"          ,"Tipo de Saldo?"          ,"Tipo de Saldo?"         ,"mv_ch4","C",1,0,0,"G","VldTpSald(MV_PAR04,.T.)","mv_par04",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aSX1,{"CTBC403","05","Descricao na moeda?"     ,"Descricao na moeda?"     ,"Descricao na moeda?"    ,"mv_ch5","C",2,0,0,"G",""                       ,"mv_par05",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aSX1,{"CTBC403","06","Cod Configuracao Livros?","Cod Configuracao Livros?","Cod Configuracao Livros","mv_ch6","C",3,0,0,"G",""                       ,"mv_par06",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CTN","","S"})
aAdd(aSX1,{"CTBC403","07","Consulta ate Entidade?"  ,"Consulta ate Entidade?"  ,"Consulta ate Entidade?" ,"mv_ch7","C",2,0,0,"G",""                       ,"mv_par07",""   ,""  ,""   ,"","",""   ,""  ,""  ,"","","","","","","","","","","","","","","","","CT0","","S"})
aAdd(aSX1,{"CTBC403","08","Seleciona filiais?"      ,"Seleciona filiais?"      ,"Seleciona filiais?"     ,"mv_ch8","N",1,0,2,"C",""                       ,"mv_par08","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""   ,"","S"})

ProcRegua(Len(aSX1))

dbSelectArea("SX1")
dbSetOrder(1)
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])
		If !dbSeek( PadR( aSX1[i,1], 10 ) + aSX1[i,2] )
			lSX1 := .T.
			RecLock("SX1",.T.)
			
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0031) // //"Atualizando Perguntas de Relatorios..."
		EndIf
	EndIf
Next i

// Ajusta os parametros que tem tipo de saldo e usam CtGerPlan
aAdd( aAjusX1, { "CTR040", "10" } )
aAdd( aAjusX1, { "CTR041", "10" } )
aAdd( aAjusX1, { "CTR050", "10" } )
aAdd( aAjusX1, { "CTR060", "10" } )
aAdd( aAjusX1, { "CTR100", "12" } )
aAdd( aAjusX1, { "CTR120", "10" } )
aAdd( aAjusX1, { "CTR150", "10" } )
aAdd( aAjusX1, { "CTR160", "10" } )
aAdd( aAjusX1, { "CTR170", "10" } )
aAdd( aAjusX1, { "CTR180", "12" } )
aAdd( aAjusX1, { "CTR190", "12" } )
aAdd( aAjusX1, { "CTR200", "10" } )
aAdd( aAjusX1, { "CTR210", "10" } )
aAdd( aAjusX1, { "CTR220", "12" } )
aAdd( aAjusX1, { "CTR130", "12" } )
aAdd( aAjusX1, { "CTR230", "12" } )
aAdd( aAjusX1, { "CTR240", "16" } )
aAdd( aAjusX1, { "CTR320", "12" } )
aAdd( aAjusX1, { "CTR330", "12" } )
aAdd( aAjusX1, { "CTR340", "12" } )
aAdd( aAjusX1, { "CTR045", "11" } )
aAdd( aAjusX1, { "CTR140", "12" } )
aAdd( aAjusX1, { "CTR145", "12" } )
aAdd( aAjusX1, { "CTR185", "13" } )
aAdd( aAjusX1, { "CTR195", "15" } )
aAdd( aAjusX1, { "CTR245", "13" } )
aAdd( aAjusX1, { "CTR155", "12" } )
aAdd( aAjusX1, { "CTR165", "38" } )
aAdd( aAjusX1, { "CTR171", "10" } )
aAdd( aAjusX1, { "CTR172", "10" } )
aAdd( aAjusX1, { "CTR500", "12" } )
aAdd( aAjusX1, { "CTR510", "15" } )
aAdd( aAjusX1, { "CTR520", "10" } )
aAdd( aAjusX1, { "CTR530", "07" } )
aAdd( aAjusX1, { "CTR540", "11" } )
aAdd( aAjusX1, { "CTR250", "16" } )
aAdd( aAjusX1, { "CTR260", "10" } )
aAdd( aAjusX1, { "CTR270", "12" } )
aAdd( aAjusX1, { "CTR290", "16" } )
aAdd( aAjusX1, { "CTR300", "16" } )
aAdd( aAjusX1, { "CTR310", "12" } )
aAdd( aAjusX1, { "CTR265", "10" } )
aAdd( aAjusX1, { "CTR266", "10" } )
aAdd( aAjusX1, { "CTR285", "12" } )
aAdd( aAjusX1, { "CTR255", "16" } )
aAdd( aAjusX1, { "CTR275", "16" } )
aAdd( aAjusX1, { "CTR272", "06" } )
aAdd( aAjusX1, { "CTR273", "06" } )
aAdd( aAjusX1, { "CTR274", "06" } )

For i := 1 To Len( aAjusX1 )
	DbSelectArea( "SX1" )
	SX1->( DbSetOrder( 1 ) )
	If SX1->( DbSeek( PadR( aAjusX1[i][1], 10 ) + aAjusX1[i][2] ) )
		RecLock( "SX1", .F. )
		SX1->X1_VALID := "VldTpSald( MV_PAR" + aAjusX1[i][2] + ",.T. )"
		MsUnLock()
	EndIf
Next

If lSX1
	cTexto += STR0032+CRLF //"Incluidas novas perguntas no SX1."
EndIf

lSX1 := .F.

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(PadR("CTB211",10))

While Alltrim( SX1->X1_GRUPO ) == "CTB211" .And. SX1->( !EOF() )
	
	cGrupo := ""
	
	If ( SX1->X1_ORDEM $ "07|08|14|15" ) .AND.(SX1->X1_GRPSXG != "003")
		cGrupo := "003"
	ElseIf ( SX1->X1_ORDEM $ "16|17|22|23" ) .AND.(SX1->X1_GRPSXG != "004")
		cGrupo := "004"
	ElseIf  ( SX1->X1_ORDEM $ "18|19|24|25" ) .AND.(SX1->X1_GRPSXG != "005")
		cGrupo := "005"
	ElseIf  ( SX1->X1_ORDEM $ "20|21|26|27" ) .AND.(SX1->X1_GRPSXG != "006")
		cGrupo := "006"
	EndIf
	
	If cGrupo != ""
		RecLock("SX1",.F.)
		X1_GRPSXG := cGrupo
		MsUnlock()
		lSX1 := .T.
		
	Endif
	
	Skip()
EndDo

If lSX1
	cTexto += STR0057+CRLF
EndIf


Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX2 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Funcao de processamento da gravacao do SX2                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX2()
//X2_CHAVE X2_PATH X2_ARQUIVOC,X2_NOME,X2_NOMESPAC X2_NOMEENGC X2_DELET X2_MODO X2_TTS X2_ROTINA
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODOUN","X2_MODOEMP"}
//		"X2_CHAVE"	,"X2_PATH"	,"X2_ARQUIVO"	,"X2_NOME"				,"X2_NOMESPA"			, "X2_NOMEENG"				,"X2_DELET"	,"X2_MODO"	,"X2_TTS"	,"X2_ROTINA"	,"X2_PYME"	,"X2_UNICO"
Aadd(aSX2,{"CW1","\DADOSADV\","CW1990","CADASTRO DE GRUPOS DE RATEIO" ,"CADASTRO DE GRUPOS DE RATEIO" ,"CADASTRO DE GRUPOS DE RATEIO"  ,0,"E","","","S","CW1_FILIAL+CW1_CODIGO+CW1_SEQUEN"})
Aadd(aSX2,{"CW2","\DADOSADV\","CW2990","AMARRACAO DE GRUPOS DE RATEIO","AMARRACAO DE GRUPOS DE RATEIO","AMARRACAO DE GRUPOS DE RATEIO" ,0,"E","","","S","CW2_FILIAL+CW2_CODIGO"})
Aadd(aSX2,{"CW3","\DADOSADV\","CW3990","INDICES ESTATISTICOS"         ,"INDICES ESTATISTICOS"         ,"INDICES ESTATISTICOS"          ,0,"E","","","S","CW3_FILIAL+CW3_CODIGO+CW3_SEQUEN"})
Aadd(aSX2,{"CW8","\DADOSADV\","CW8990","HISTORICO DE ALTERACOES"  	  ,"HISTORIAL DE MODIFICACIONES"  ,"HISTORICAL CHANGE"             ,0,"E","","","S","CW8_FILIAL+CW8_FILTAB+CW8_TABELA+CW8_CODIGO+CW8_GRUPO+CW8_CAMPO+DTOS(CW8_DATA)+CW8_SEQ"})
Aadd(aSX2,{"CVE","\DADOSADV\","CVE990","VISAO GERENCIAL"    		  ,"VISAO GERENCIAL"    		  ,"VISAO GERENCIAL"    		  ,0,"E","","","S","CVE_FILIAL+CVE_CODIGO"})
Aadd(aSX2,{"CVF","\DADOSADV\","CVE990","ESTRUTURA DA VISAO" 		  ,"ESTRUTURA DA VISAO" 		  ,"ESTRUTURA DA VISAO" 		  ,0,"E","","","S","CVF_FILIAL+CVF_CODIGO+CVF_ORDEM"})
Aadd(aSX2,{"CVN","\DADOSADV\","CVN990","CADASTRO PLANO REFERENCIAL"   ,"CADASTRO PLANO REFERENCIAL"   ,"CADASTRO PLANO REFERENCIAL"   ,0,"C","","","S","CVN_FILIAL+CVN_CODPLA+CVN_LINHA"             })
Aadd(aSX2,{"CVG","\DADOSADV\","CVG990","Operacoes                 ",     "Operaciones              ", "Operations                   "   ,0,"C","","","S","CVG_FILIAL+CVG_PROCES+CVG_OPER"             })
Aadd(aSX2,{"CVI","\DADOSADV\","CVI990","Operacoes Vs. Seq. Lancamentos", "Operac. vs. Sec. Asientos", "Operations vs. Entry Sequence"   ,0,"C","","","S","CVI_FILIAL+CVI_PROCES+CVI_OPER+CVI_LANPAD+CVI_SEQLAN"             })
Aadd(aSX2,{"CVJ","\DADOSADV\","CVJ990","Processos                 ",     "Procesos                 ", "Processes                    "   ,0,"C","","","S","CVJ_FILIAL+CVJ_MODULO+CVJ_PROCES"             })
Aadd(aSX2,{"CVO","\DADOSADV\","CVO990","Fila de Saldos 2"				, "Fila de Saldos 2"				, "Fila de Saldos 2"   					,0,"E","","","S",""             })

aAdd(aSX2, {"CV7","\DADOSADV\"	,"CV7990","Flag de AtualizaþÒo de Saldos"	,"Flag de Actualizacion de Saldo","Balance update flag"				  			,0,"E","","","S","CV7_FILIAL+CV7_MOEDA+CV7_TPSALD","E","E"})
aAdd(aSX2, {"CV8","\DADOSADV\"	,"CV8990","Log de Processamento	"			,"Log de Procesamiento"				,"Processing log"			  			 			,0,"E","","","S","","E","E"										})
aAdd(aSX2, {"CV9","\DADOSADV\"	,"CV9990","Historico de Rateios Off-Line"	,"Historial de prorrat.Off-Line"	,"Off-Line Proration History"		  			,0,"E","","","S","CV9_FILIAL+CV9_RATEIO+CV9_REVISA+CV9_SEQUEN","E","E"	})
If !AliasIndic("CVB")
	aAdd(aSX2, {"CVB","\DADOSADV\"	,"CVB990","Dados do contabilista"			,"Datos del contador"				,"Bookkeeper info"	   		  			,0,"C","","","S","CVB_FILIAL+CVB_CODCTB","E","E"})
EndIf
If !AliasIndic("CVC")
	aAdd(aSX2, {"CVC","\DADOSADV\"	,"CVC990","Cadastro de Participantes"		,"Archivo de participantes"			,"Participant file"	   				,0,"C","","","S","CVC_FILIAL+CVC_CODPAR","E","E"})
EndIf
aAdd(aSX2, {"CVD","\DADOSADV\"	,"CVD990","Plano de Contas Ref."			,"Plan de Cuentas Ref"	   		  		,"Accounts Plan File" 						,0,"C","","","S","CVD_FILIAL+CVD_CONTA+CVD_ENTREF+CVD_CTAREF+CVD_CUSTO","E","E"})
Aadd(aSX2, {"CVN","\DADOSADV\"	,"CVN990","Cadastro de Plando Referencial" 	,"Cadastro de Plando Referencial"	,"Cadastro de Plando Referencial"  	,0,"C","","","S","CVN_FILIAL+CVN_CODPLA+CVN_LINHA","E","E"})
aadd(asx2, {"CVL","\DADOSADV\"   ,"CVL990","Controle de diario cabec" ,"Controle de diario cabec","Controle de diario cabec"	,0,"E","","","S","CVL_FILIAL+CVL_COD","E","E"})
aadd(asx2, {"CVM","\DADOSADV\"   ,"CVM990","Controle de diario item","Controle de diario item","Controle de diario item"		  	,0,"E","","","S","CVM_FILIAL+CVM_COD+CVM_TIPOSE+CVM_SEQINI+CVM_RAD","E","E"})
aadd(asx2, {"CVQ","\DADOSADV\"   ,"CVQ990","Quadros Contab. Configuraveis","Cuadros Contab. Configurables","Config. Accounting Boards",0,"C","","","S","CVQ_FILIAL+CVQ_CODIGO+CVQ_ITEM","E","E"})
aadd(aSX2, {"CTA","\DADOSADV\" ,"CTA990","Regras de Amarração","Reglas de amarres","Mooring Rules",0,"E","","","S","CTA_FILIAL+CTA_REGRA+CTA_ITREGR","E","E"})
aadd(asx2, {"CT0","\DADOSADV\","CT0990","Conf. De Entidades Contabeis","Verif. de Entes Contables","Conf. of Accounting Entities",0,"C","","","N","","E","E"})
aadd(asx2, {"CV0","\DADOSADV\" ,"CV0990","Cadastro de Entidades","Archivo de Entes","Entities File",0,"C","","","N","","E","E"})
aadd(asx2, {"CW0","\DADOSADV\" ,"CW0990","Dados Auxiliares CTB","Datos Auxiliares CTB","CTB Auxilary Data",0,"C","","","S","CW0_FILIAL+CW0_TABELA+CW0_CHAVE+CW0_DESC01","C","C"})
aadd(asx2, {"CVX","\DADOSADV\" ,"CVX990","Saldos diarios" ,"Saldos diarios" ,"Daily Balances" ,0,"E","","","N","","E","E"})
aadd(asx2, {"CVY","\DADOSADV\" ,"CVY990","Saldos Mensais Acumulados","Saldos Mensuales Acumulados","Accrued Monthly Balances",0,"E","","","N","","E","E"})
aadd(asx2, {"CVZ","\DADOSADV\" ,"CVZ990","Saldo de Fechamento","Saldo de Cierre","Closure Balance",0,"E","","","N","","E","E"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para o Novo SPED Contabil			 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX2,{"CS0","\DADOSADV\"			,"CS0990"		,"ECD - REVISAO"								,"ECD - REVISAO" 								,"ECD - REVISAO" 					  			,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS1","\DADOSADV\"			,"CS1990"		,"ECD - Dados Comp. da Rev. "					,"Dados Comp. da Rev." 							,"Dados Comp. da Rev." 				 	  		,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS2","\DADOSADV\"			,"CS2990"		,"ECD - EMPRESA" 			   					,"ECD - EMPRESA" 								,"ECD - EMPRESA" 					 			,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS3","\DADOSADV\"			,"CS3990"		,"ECD - Plano de Contas"	   					,"ECD - Plano de Contas" 						,"ECD - Plano de Contas" 					  	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS4","\DADOSADV\"			,"CS4990"		,"ECD - Plano de Contas Ref."					,"ECD - Plano de Contas Ref." 					,"ECD - Plano de Contas Ref." 					,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS5","\DADOSADV\"			,"CS5990"		,"ECD - Centro de Custo."	   					,"ECD - Centro de Custo."   					,"ECD - Centro de Custo." 					  	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS6","\DADOSADV\"			,"CS6990"		,"ECD - Visão Gerencial / Conta Aglutinadora"	,"ECD - Visão Gerencial / Conta Aglutinadora"	,"ECD - Visão Gerencial / Conta Aglutinadora"	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS7","\DADOSADV\"			,"CS7990"		,"ECD - Histórico Padrão"				   		,"ECD - Histórico Padrão" 			  			,"ECD - Histórico Padrão" 					 	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS8","\DADOSADV\"			,"CS8990"		,"ECD - Contabilistas "  						,"ECD - Contabilistas "   				  		,"ECD - Contabilistas "   					  	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CS9","\DADOSADV\"			,"CS9990"		,"ECD - Participante" 					   		,"ECD - Participante"  				 			,"ECD - Participante"  					  		,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSA","\DADOSADV\"			,"CSA990"		,"ECD - Cab. das Movimentações "		   		,"ECD - Cab. das Movimentações" 		   		,"ECD - Cab. das Movimentações"	   			 	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSB","\DADOSADV\"			,"CSB990"		,"ECD - Itens de movimentações " 				,"ECD - Itens de movimentações "  				,"ECD - Itens de movimentações " 				,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSC","\DADOSADV\"			,"CSC990"		,"ECD - Balancete	 "	   						,"ECD - Balancete	 "	   						,"ECD - Balancete	 "	   				  		,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSD","\DADOSADV\"			,"CSD990"		,"ECD - Balanços cabeçalho  "					,"ECD - Balanços cabeçalho  " 			  		,"ECD - Balanços cabeçalho  " 					,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSE","\DADOSADV\"			,"CSE990"		,"ECD - Balanços itens 	  "						,"ECD - Balanços itens 	  " 					,"ECD - Balanços itens 	  " 					,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSF","\DADOSADV\"			,"CSF990"		,"ECD - Balanços RTF 300b  "					,"ECD - Balanços RTF 300b  " 					,"ECD - Balanços RTF 300b  " 					,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSG","\DADOSADV\"			,"CSG990"		,"ECD - Balancete Diario"						,"ECD - Balancete Diario"	   					,"ECD - Balancete Diario" 				  		,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSJ","\DADOSADV\"			,"CSJ990"		,"ECD - Identificação das Contas Resumidas"		,"ECD - Identificação das Contas Resumidas"		,"ECD - Identificação das Contas Resumidas"	  	,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSK","\DADOSADV\"			,"CSK990"		,"ECD - Saldo Conta Referencial"	   			,"ECD - Saldo Conta Referencial"	   			,"ECD - Saldo Conta Referencial"   				,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSL","\DADOSADV\"			,"CSL990"		,"ECD - Itens movimentações referencial" 		,"ECD - Itens movimentações referencial"  		,"ECD - Itens movimentações referencial" 		,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSM","\DADOSADV\"			,"CSM990"		,"ECD - Dados FCONT" 							,"ECD - Dados FCONT"  							,"ECD - Dados FCONT" 							,0			,"C"		,""			,"","S"		,"","C","C"})
//leiaute 2 da ECD
Aadd(aSX2,{"CSN","\DADOSADV\"			,"CSN990"		,"ECD - Cadastro Fatos Contabeis" 				,"ECD - Cadastro Fatos Contabeis"  				,"ECD - Cadastro Fatos Contabeis" 				,0			,"C"		,""			,"","S"		,"","C","C"})
Aadd(aSX2,{"CSO","\DADOSADV\"			,"CSO990"		,"ECD - Detalhe do Fato Contabil"				,"ECD - Detalhe do Fato Contabil"				,"ECD - Detalhe do Fato Contabil" 				,0			,"C"		,""			,"","S"		,"","C","C"})
#IFDEF TOP
	Aadd(aSX2,{"CSH","\DADOSADV\"			,"CSH990"		,"ECD - Pré-validação"							,"ECD - Pré-validação"	   				  		,"ECD - Pré-validação" 				  			,0			,"C"		,""			,"","S"		,"","C","C"})
	Aadd(aSX2,{"CSI","\DADOSADV\"			,"CSI990"		,"ECD - Formulas da Pre-Validação"				,"Formulas da Pre-Validação"					,"Formulas da Pre-Validação" 				  	,0			,"C"		,""			,"","S"		,"","C","C"})
	aadd(asx2,{"CSV","\DADOSADV\"			,"CSV990"		,"ECD - Layout de Diarios"						,"ECD - Layout de Diarios"						,"ECD - Layout de Diarios"						,0			,"C"		,""			,"","S"		,"","C","C"})
	aadd(asx2,{"CSW","\DADOSADV\"			,"CSW990"		,"ECD - Itens do Lay. de Diarios"				,"ECD - Itens do Layout de Diarios"				,"ECD - Itens do Layout de Diarios"				,0			,"C"		,""			,"","S"		,"","C","C"})
	aadd(asx2,{"CSX","\DADOSADV\"			,"CSX990"		,"ECD - Importacao de Diarios"					,"ECD - Importacao de Diarios"					,"ECD - Importacao de Diarios"					,0			,"C"		,""			,"","S"		,"","C","C"})
	aadd(asx2,{"CSY","\DADOSADV\"			,"CSY990"		,"ECD - Import de Diarios Quebras"				,"ECD - Import de Diarios Quebras"			,"ECD - Import de Diarios Quebras"			,0			,"C"		,""			,"","S"		,"","C","C"})
#ENDIF

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
dbSetOrder(1)
dbSeek("CTQ")
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
cModo := SX2->X2_MODO

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			lSX2 := .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf  
			If Ascan(aArqUpd,aSX2[i][1]) == 0
				aAdd(aArqUpd,aSX2[i][1])
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			//Comentado linha abaixo pois esta cadastrando todas
			//as tabelas com modo igual a "E", pois esta igua-
			//lando a tabela CTQ conforme definodo acima
			//SX2->X2_MODO    := cModo
			SX2->X2_PATH    := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			dbCommit()
			MsUnLock()
			IncProc(STR0033) // //"Atualizando Dicionario de Arquivos..."
		Else
			If aSX2[i,1] == "CTA"
				CTBUpdField("SX2", 1, "CTA_REGRA", "X2_UNICO", "CTA_FILIAL+CTA_REGRA+CTA_ITREGR")
			EndIf
			
			If aSX2[i,1] == "CVD"
				CTBUpdField("SX2", 1, "CVD__", "X2_UNICO", "CVD_FILIAL+CVD_CONTA+CVD_ENTREF+CVD_CTAREF+CVD_CUSTO")
			EndIf
			
			If aSX2[i,1] == "CW0"
				RecLock("SX2",.F.)
				SX2->X2_UNICO := "CW0_FILIAL+CW0_TABELA+CW0_CHAVE+CW0_DESC01"
				MSUnLock()
			EndIf
		EndIf
	EndIf
Next i

If lSX2
	cTexto += STR0049+cAlias+CRLF //"Incluidas novas perguntas no SX1."
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX3 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX3()
Local aSXG      := {}
Local aSX3      := {} // Novos campos
Local aSX3Ordem := {} // Redefine apenas a ordem dos campos informado no array
Local aEstrut   := {}
Local aSX3Copia := {}
Local i         := 0
Local j         := 0
Local lSX3	    := .F.
Local cTexto    := ''
Local cAlias    := ''
Local cUltCpo   := ''
Local nOrdSX3   := SX3->( IndexOrd() )
Local nCVNLinha := 3
Local nCTKHist := 40
Local cPicCVNLinha 	:= "999"
Local nTamFilial	:= CtbTamSXG("033",2)  //grupo ; tamanho padrao
Local nTamConta 	:= CtbTamSXG("003",20)  //grupo ; tamanho padrao
Local nTamCCusto 	:= CtbTamSXG("004",9)  //grupo ; tamanho padrao
Local nTamItCont 	:= CtbTamSXG("005",9)  //grupo ; tamanho padrao
Local nTamClVlr 	:= CtbTamSXG("006",9)  //grupo ; tamanho padrao
Local nTamEnt_05 	:= CtbTamSXG("040",6)  //grupo ; tamanho padrao
Local nTamEnt_06 	:= CtbTamSXG("042",6)  //grupo ; tamanho padrao
Local nTamEnt_07 	:= CtbTamSXG("043",6)  //grupo ; tamanho padrao
Local nTamEnt_08 	:= CtbTamSXG("044",6)  //grupo ; tamanho padrao
Local nTamEnt_09 	:= CtbTamSXG("045",6)  //grupo ; tamanho padrao
Local nTamCtaRef 	:= CtbTamSXG("027",30)  //grupo ; tamanho padrao  
Local aPHelpPor     := {}
Local aPHelpEsp     := {}
Local aPHelpEng     := {}
Local cAux			:= ""
Local aAux			:= {}
Local nX				:= 0
Local aCamposVm	:= {}

If cPaisLoc == "COL"
	nTamEnt_05 := 15
ElseIf cPaisLoc == "PER"
	nTamEnt_05 := 16
EndIf


// Tamanho do para o campo CTK_HIST
nCTKHist 		:= 40
//caso o campo já esxita no dicionario de dados, deve verificar no dicinario o tamanho atuais
If AliasIndic("CTK")
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek("CTK_HIST"))
		nCTKHist 		:= TamSX3("CTK_HIST")[1]
	EndIf
Endif


// tamanho e formato (picture) para o campo CVN_LINHA
nCVNLinha := 3
cPicCVNLinha := "999"
// caso ele exista no dicionario de dados, deve verificar no dicionario o tamanho e formato atuais
If AliasIndic("CVN")
	SX3->( DbSetOrder(2) )
	If SX3->(DbSeek("CVN_LINHA"))
		nCVNLinha 		:= TamSX3("CVN_LINHA")[1]
		cPicCVNLinha 	:= Replicate("9",nCVNLinha)
	EndIf
EndIf

aEstrut := { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER" ,"X3_PYME","ALTERA"}

/* Identificando os campos do SX3 na matriz aEstrut
01-X3_ARQUIVO  02-X3_ORDEM	  03-X3_CAMPO    04-X3_TIPO     05-X3_TAMANHO  06-X3_DECIMAL  07-X3_TITULO  08-X3_TITSPA
09-X3_TITENG   10-X3_DESCRIC  11-X3_DESCSPA  12-X3_DESCENG  13-X3_PICTURE  14-X3_VALID    15-X3_USADO   16-X3_RELACAO
17-X3_F3       18-X3_NIVEL    19-X3_RESERV   20-X3_CHECK    21-X3_TRIGGER  22-X3_PROPRI   23-X3_BROWSE  24-X3_VISUAL
25-X3_CONTEXT  26-X3_OBRIGAT  27-X3_VLDUSER  28-X3_CBOX     29-X3_CBOXSPA  30-X3_CBOXENG  31-X3_PICTVAR 32-X3_WHEN
33-X3_INIBRW   34-X3_GRPSXG   35-X3_FOLDER   36-X3_PYME
*/



//Grupos de campos para definicao de tamanho
SXG->(DbGoTop())
While SXG->(!Eof())
	aAdd(aSXG	,{SXG->XG_GRUPO,SXG->XG_SIZE})
	SXG->(DbSkip())
End

// Campos do SX3 a terem copiados o X3_USADO e X3_RESERV
// 1- campo filial
// 2-campo obrigatorio
// 3-campo nao visivel
// 4-campo nao visivel obrigatorio
aSX3Copia := {	{"CT5_FILIAL"}, {"A1_NOME"}, {"CT5_HIST"}, {"CTS_CODPLA"}, {"CTS_CTASUP"},{"CT1_DESC05"},{"CT1_CVD02"}}

SX3->( DbSetOrder(2) )
For i := 1 to Len( aSX3Copia )
	SX3->( DbSeek(aSX3Copia[i,1]) )
	Aadd( aSX3Copia[i], SX3->X3_USADO )
	Aadd( aSX3Copia[i], SX3->X3_RESERV )
Next


Aadd(aSX3,{	"CW1", "01", "CW1_FILIAL"	, "C", nTamFilial	, 0, "Filial"      , "Sucursal"	 , "Branch"		, "Filial do Sistema"			, "Sucursal del Sistema"     , "System Branch"        	, "@!"       , ""                                                         								, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "" , "", "", "", ""		, ""					, ""					, ""					, "", ""						, "", "033"   , "", "S"})
Aadd(aSX3,{	"CW1", "02", "CW1_CODIGO"	, "C", 06			, 0, "Cod. Grupo"  , "Cod. Grupo"  , "Group Code" , "Cod. Grupo de Rateio"     	, "Cod. Grupo de Prorrateo"  , "Proration group code"	, "@!"       , "ExistChav('CW1',,1) .And. FreeForUse('CW1',M->CW1_CODIGO)"								, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "A", "", "", ""	, ""					, ""					, ""					, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "03", "CW1_DESCRI"	, "C", 40			, 0, "Descricao "  , "Descripcion" , "Description", "Descricao Grupo Rateio"	   	, "Descricao Grupo Prorrateo", "Proration group descr."	, "@!"       , ""                                 	                        							, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "A", "", "", ""	, ""					, ""					, ""					, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "04", "CW1_TIPO"  	, "C", 01			, 0, "Tipo Grupo"  , "Tipo Grupo"  , "Group Type" , "Tipo do Grupo"				, "Tipo do Grupo"            , "Group type"         	, "!"        , ""                                                	        							, aSX3Copia[02,2], "'1'",    "", 1 , aSX3Copia[02,3], "", "", "", "S", "A", "", "", ""	, "1=Origem;2=Destino"	, "1=Origem;2=Destino"	, "1=Origem;2=Destino"	, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "05", "CW1_ENTID" 	, "C", 01			, 0, "Entidade"    , "Entidad"     , "Entity"     , "Entidade Contabil" 	    	, "Entidad Contable"         , "Account Entity"      	, "@!"	     , "Pertence('12345')"                                          							, aSX3Copia[02,2], "'1'",    "", 1 , aSX3Copia[02,3], "", "", "", "S", "A", "", "", "", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor;5=Combinado", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor;5=Combinado", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor;5=Combinado", "", "", "", "", "", "S"})
Aadd(aSX3,{	"CW1", "06", "CW1_SEQUEN"	, "C", 03			, 0, "Sequencial"  , "Sequencial"  , "Sequential" , "Sequencial"					, "Sequencial"               , "Sequential"            	, "@!"       , ""                                        	                							, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "07", "CW1_INDICE"	, "C", 06			, 0, "Cod. Indice" , "Cod. Indice" , "Index Code" , "Cod. Indice Estatistico"  	, "Cod. índice estadístico"  , "Statistic Index Code"  	, "@!"       , "Vazio(M->CW1_INDICE) .or. ExistCpo('CW3',M->CW1_INDICE,1)"  							, aSX3Copia[03,2],   "" , "CW3", 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "08", "CW1_CONTA" 	, "C", nTamConta	, 0, "Cod. Conta"  , "Cod. Cuenta" , "Acc. Code"  , "Codigo da Conta Contabil" 	, "Codigo de Cuenta Contable", "Ledger Account Code"   	, "@!"       , "(Vazio(M->CW1_CONTA).or.ExistCpo('CT1',M->CW1_CONTA,1)).AND.Ctb276FPrc('CW1_CONTA')"  	, aSX3Copia[03,2],   "" , "CT1", 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", "cCw1_Entidade $ '1/5'"	, "", "003", "", "S"})
Aadd(aSX3,{	"CW1", "09", "CW1_CCUSTO"	, "C", nTamCCusto	, 0, "Cod C Custo" , "Cod C Costo" , "C Cent Code", "Codigo do Centro de Custo"	, "Codigo Centro de Costo"   , "Cost Center Code"      	, "@!" 	     , "(Vazio(M->CW1_CCUSTO).or.ExistCpo('CTT',M->CW1_CCUSTO,1)).AND.Ctb276FPrc('CW1_CCUSTO')"	, aSX3Copia[03,2],   "" , "CTT", 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", "cCw1_Entidade $ '2/5'"	, "", "004", "", "S"})
Aadd(aSX3,{	"CW1", "10", "CW1_ITEM"  	, "C", nTamItCont	, 0, "Cod. Item"   , "Cod. Item"   , "Item Code"  , "Codigo do Item Contabil"  	, "Codigo Item Contable"     , "Accounting Item Code"  	, "@!" 	     , "(Vazio(M->CW1_ITEM).or.ExistCpo('CTD',M->CW1_ITEM,1)).AND.Ctb276FPrc('CW1_ITEM')"    	, aSX3Copia[03,2],   "" , "CTD", 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", "cCw1_Entidade $ '3/5'"	, "", "005", "", "S"})
Aadd(aSX3,{	"CW1", "11", "CW1_CLVL"  	, "C", nTamClVlr	, 0, "Cod Cl Valor", "Cod Cl Valor", "Vl Cls Code", "Codigo da Classe de Valor"	, "Codigo Clase de Valor"    , "Value Class Code"      	, "@!" 	     , "(Vazio(M->CW1_CLVL).or.ExistCpo('CTH',M->CW1_CLVL,1)).AND.Ctb276FPrc('CW1_CLVL')"    	, aSX3Copia[03,2],   "" , "CTH", 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""	 				, ""					, ""					, "", "cCw1_Entidade $ '4/5'"	, "", "006", "", "S"})
Aadd(aSX3,{	"CW1", "12", "CW1_PERCEN"	, "N", 06			, 2, "Percen Ratei", "Porc Prorrat", "Prorat Perc", "Percentual de Rateio"     	, "Porcentaje de Prorrateo"  , "Proration Percentage"  	, "@E 999.99", ""                                                         								, aSX3Copia[03,2],   "" , ""   , 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", ""						, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "13", "CW1_FATOR" 	, "N", 18			, 4, "Fator Ind"   , "Factor Ind"  , "Factor Ind" , "Fator índice estatístico"    	, "Fator índice estadístico" , "Statistic index factor"	, "@E 9,999,999,999.9999", ""																			, aSX3Copia[03,2], 	  "" , ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", "cCw1_Tipo == '2'"		, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "14", "CW1_FORMUL"	, "C", 60			, 0, "Form. Fator" , "Form. Fator" , "Fatcor Form.", "Formula fator destino"		, "Formula fator destino"  	 , "Destin. formula factor"	, "@!"       , "Vazio() .Or. Ctb277Form('N')"                                							, aSX3Copia[03,2], 	  "" , ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A", "", "", ""	, ""					, ""					, ""					, "", "cCw1_Tipo == '2'"		, "", ""   , "", "S"})
Aadd(aSX3,{	"CW1", "15", "CW1_STATUS"	, "C", 01			, 0, "Status"		 , "Estatus" 	 , "Status"     , "Status do indice"			, "Estatus do indice"		 , "Index status"			, "@!"       , ""                                														, aSX3Copia[03,2], 	  "" , ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "V", "", "", ""	, ""					, ""					, ""					, "", ""		   				, "", ""   , "", "S"})

Aadd(aSX3,{	"CW2", "01", "CW2_FILIAL", "C",nTamFilial	, 0, "Filial" , "Sucursal"	  	, "Branch"   	  	, "Filial do Sistema"			, "Sucursal del Sistema"     		, "System Branch"            		, "@!"		, ""                                                         						  					, aSX3Copia[01,2], ""   ,    ""	, 1 , aSX3Copia[01,3], "", "", "", "" , "" , "", "", ""	, ""					          , ""					            , ""					          	, "", "", "", "033","","S"})
Aadd(aSX3,{	"CW2", "02", "CW2_CODIGO", "C",006			, 0, "Cod. Amarra"	, "Cod. Vinculo"	, "Binding Code"	, "Cod. Amarracao de Rateio" 	, "Cod. vinculo de Prorrateo" 	, "Proration binding code"	  		, "@!"		, "ExistChav('CW2',,1) .And. FreeForUse('CW2',M->CW2_CODIGO)"						 					, aSX3Copia[02,2], ""   ,    ""	, 1 , aSX3Copia[02,3], "", "", "", "S", "A" , "", "", ""	, ""					          , ""					            , ""				              	, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "03", "CW2_DESCRI", "C",040			, 0, "Desc.Amarra"  	, "Desc.Vinculo" 	, "Binding Desc." , "Descricao de Amarracao"    , "Descricao del Vinculo"  	 	, "Binding code description" 		, "@!"      , ""                   	                       											 					, aSX3Copia[02,2], ""   ,    ""	, 1 , aSX3Copia[02,3], "", "", "", "S", "A",  "", "", ""	, ""							  , ""								, ""								, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "04", "CW2_CODCTQ", "C",200			, 0, "Codigo Rateio" 	, "Cod.Prorrateo" , "Prorat.Code" 	, "Codigo do rateio (CTQ)"    , "Codigo do prorrateo (CTQ)"  	, "Proratation Code (CTQ)"	  		, "@!"      , "Vazio() .OR. Ctb277Form('C')"                   	                      						, aSX3Copia[03,2], ""   ,    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A",  "", "", ""	, ""							  , ""								, ""								, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "05", "CW2_DSCCTQ", "C",200			, 0, "Desc.Rateio"   	, "Dsc.Prorrateo" , "Prorat.Desc." 	, "Descricao do rateio(CTQ)"  , "Desc. del prorrateo (CTQ)"  	, "Prorat. description (CTQ)"		, "@!"      , "Ctb277Form('C')"                   	                       											, aSX3Copia[02,2], ""   ,    ""	, 1 , aSX3Copia[02,3], "", "", "", "N", "A",  "", "", ""	, ""							  , ""								, ""								, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "06", "CW2_INTERC", "C",001			, 0, "Intercompany?" 	, "Intercompany?" , "Intercompany?" , "Lanctos com intercompany?"	, "Asiento com intercompany?"		, "Entry with intercompany?" 		, "@!"      , "Pertence('12')"				                                  	             		       	, aSX3Copia[03,2], "'2'",    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A",  "", "", ""	, "1=Sim;2=Não"				, "1=Sim;2=Não"					, "1=Sim;2=Não"						, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "07", "CW2_TIPO"	 , "C",001			, 0, "Tipo Rateio" 		, "Tipo Prorrat" 	, "Prorat.Type" 	, "Tipo do Rateio"				, "Tipo de Prorrateo"				, "Proration Type"			  		, "@!"      , "Pertence('12')"				                                  	             		       	, aSX3Copia[03,2], "'1'",    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A",  "", "", ""	, "1=Movimento Mes;2=Saldo Acumulado", "1=Movimiento Mes;2=Saldo Acumulado", "1=Monthly Movement;2=Accumulated Balance", "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "08", "CW2_CT1PAF", "C",200			, 0, "Frm.Part.CT1"		, "Frm.Part.CT1"	, "Entry Frm.CT1"	, "Formula: Conta Partida" 	, "Formula: Cuenta Partida"	 	, "Formula:Entry Account"  		, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 														, aSX3Copia[03,2], ""   , "" 		, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          , ""					            , ""					          	, "", "EMPTY(M->CW2_CT1PAR)", "", "","","S"})
Aadd(aSX3,{	"CW2", "09", "CW2_CT1PAR", "C",nTamConta	, 0, "Conta Part." 		, "Cuenta Part." 	, "Acct Entry" 	, "Conta Contabil - Partida" 	, "Cuenta Contabil - Partida" 	, "Ledger Acct. - Entry" 	  		, "@!"		, "Vazio() .Or. ExistCpo('CT1',M->CW2_CT1PAR,1)" 						 									, aSX3Copia[03,2], ""   , "CT1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          , ""					            , ""					          	, "", "EMPTY(M->CW2_CT1PAF)", "", "003","","S"})
Aadd(aSX3,{	"CW2", "10", "CW2_CTTPAF", "C",200			, 0, "Frm.Part.CTT"		, "Frm.Part.CTT"	, "Entry Frm.CTT"	, "Formula: C.Custo Partida" 	, "Formula: C.Costo Partida"		, "Formula:Entry C.Center"   		, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 							  							, aSX3Copia[03,2], ""   , ""		, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          , ""					            , ""					          	, "", "EMPTY(M->CW2_CTTPAR)", "", "","","S"})
Aadd(aSX3,{	"CW2", "11", "CW2_CTTPAR", "C",nTamCCusto	, 0, "Custo Part." 		, "Costo Part." 	, "C.Center Entry", "C. de Custo - Partida"		, "C. de Costo - Partida"    		, "Cost Center  - Entry"     		, "@!"		, "Vazio() .Or. ExistCpo('CTT',M->CW2_CTTPAR,1)" 						 			 						, aSX3Copia[03,2], ""   , "CTT"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          , ""					            , ""							  	, "", "EMPTY(M->CW2_CTTPAF)", "", "004","","S"})
Aadd(aSX3,{	"CW2", "12", "CW2_CTDPAF", "C",200			, 0, "Frm.Part.CTD"		, "Frm.Part.CTD"	, "Entry Frm.CTD"	, "Formula: Item Ctb.Partida" , "Formula: Item Ctb.Partida"		, "Formula:Entry Acct. Item"  	, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								 						, aSX3Copia[03,2], ""   , "" 		, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTDPAR)", "", "","","S"})
Aadd(aSX3,{	"CW2", "13", "CW2_CTDPAR", "C",nTamItCont	, 0, "Item Part."  		, "Item Part."  	, "Item Entry" 	, "Item Contabil  - Partida"  , "Item Contabil  - Partida" 		, "Acct. Item   - Entry"  	  		, "@!"		, "Vazio() .Or. ExistCpo('CTD',M->CW2_CTDPAR,1)" 						 			 						, aSX3Copia[03,2], ""   , "CTD"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					 		  	, "", "EMPTY(M->CW2_CTDPAF)", "", "005","","S"})
Aadd(aSX3,{	"CW2", "14", "CW2_CTHPAF", "C",200			, 0, "Frm.Part.CTH"		, "Frm.Part.CTH"	, "Entry Frm.CTH"	, "Formula: Cl.Valor Partida" , "Formula: Cl.Valor Partida"		, "Formula:Entry Value Class"  	, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								 						, aSX3Copia[03,2], ""   , ""		, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTHPAR)", "", "","","S"})
Aadd(aSX3,{	"CW2", "15", "CW2_CTHPAR", "C",nTamClVlr	, 0, "Clvl Part."  		, "Clvl Part."	  	, "Vl.Cl.Entry"  	, "Cl. de Valor  - Partida"	, "Cl. de Valor  - Partida"  		, "Value Class  - Entry"     		, "@!"		, "Vazio() .Or. ExistCpo('CTH',M->CW2_CTHPAR,1)" 						 									, aSX3Copia[03,2], ""   , "CTH"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""	 				         						 	, ""					            , ""							  	, "", "EMPTY(M->CW2_CTHPAF)", "", "006","","S"})
Aadd(aSX3,{	"CW2", "16", "CW2_ORIGEM", "C",006			, 0, "Grp.Orig.CT1"		, "Grp.Orig.CT1"	, "Src.Grp.CT1"	, "Grupo Origem - Conta"   	, "Grupo Origem - Cuenta"  	 	, "Source Group - Account"   		, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_ORIGEM,1) .AND. CTB277VLDGR('1/5',M->CW2_ORIGEM,'1')"	, aSX3Copia[03,2], ""  	, "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "17", "CW2_CTTORI", "C",006			, 0, "Grp.Orig.CTT"		, "Grp.Orig.CTT"	, "Src.Grp.CTT"	, "Grupo Origem - C.Custo"  	, "Grupo Origem - C.Costo" 	 	, "Source Group - C.Center"	 	, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTTORI,1) .AND. CTB277VLDGR('2',M->CW2_CTTORI,'1')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					         							, ""					            , ""					          	, "", "!_lCW2_ORICOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "18", "CW2_CTDORI", "C",006			, 0, "Grp.Orig.CTD"		, "Grp.Orig.CTD"	, "Src.Grp.CTD"	, "Grupo Origem - Item Ctb." 	, "Grupo Origem - Item Ctb." 		, "Source Group - Acct. Item"		, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTDORI,1) .AND. CTB277VLDGR('3',M->CW2_CTDORI,'1')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					         							, ""					            , ""					          	, "", "!_lCW2_ORICOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "19", "CW2_CTHORI", "C",006			, 0, "Grp.Orig.CTH"		, "Grp.Orig.CTH"	, "Src.Grp.CTH"	, "Grupo Origem - Clvl."   	, "Grupo Origem - Clvl."   	 	, "Source Group - V.Class"   		, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTHORI,1) .AND. CTB277VLDGR('4',M->CW2_CTHORI,'1')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "!_lCW2_ORICOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "20", "CW2_CT1DEF", "C",200			, 0, "Frm.Dest.CT1"		, "Frm.Dest.CT1"	, "Dest.Frm.CT1"	, "Formula: Conta Destino" 	, "Formula: Cuenta Destino"	 	, "Formula: Destin. Account"  	, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								  						, aSX3Copia[03,2], ""   , "CT1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_DESTIN)", "", "","","S"})
Aadd(aSX3,{	"CW2", "21", "CW2_DESTIN", "C",006			, 0, "Grp.Dest.CT1"		, "Grp.Dest.CT1"	, "Dest.Grp.CT1"	, "Grupo Destino - Conta"   	, "Grupo Destino - Cuenta"    	, "Destin. Group - Account"   	, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_DESTIN,1) .AND. CTB277VLDGR('1/5',M->CW2_DESTIN,'2')"	, aSX3Copia[03,2], ""  	, "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CT1DEF)", "", "","","S"})
Aadd(aSX3,{	"CW2", "22", "CW2_CTTDEF", "C",200			, 0, "Frm.Dest.CTT"		, "Frm.Dest.CTT"	, "Dest.Frm.CTT"	, "Formula: C.Custo Destino" 	, "Formula: C.Costo Destino" 		, "Formula: Destin. C.Center"		, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								  						, aSX3Copia[03,2], ""   , "CTT"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTTDES).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "23", "CW2_CTTDES", "C",006			, 0, "Grp.Dest.CTT"		, "Grp.Dest.CTT"	, "Dest.Grp.CTT"	, "Grupo Destino - C.Custo"  	, "Grupo Destino - C.Costo"  		, "Destin. Group - C.Center" 		, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTTDES,1) .AND. CTB277VLDGR('2',M->CW2_CTTDES,'2')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTTDEF).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "24", "CW2_CTDDEF", "C",200			, 0, "Frm.Dest.CTD"		, "Frm.Dest.CTD"	, "Dest.Frm.CTD"	, "Formula: Item Destino" 		, "Formula: Item Destino"	  		, "Formula: Destin. Acct. Item"	, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								  						, aSX3Copia[03,2], ""   , "CTD"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTDDES).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "25", "CW2_CTDDES", "C",006			, 0, "Grp.Dest.CTD"		, "Grp.Dest.CTD"	, "Dest.Grp.CTD"	, "Grupo Destino - Item Ctb." , "Grupo Destino - Item Ctb."		, "Destin. Group - Acct. Item"	, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTDDES,1) .AND. CTB277VLDGR('3',M->CW2_CTDDES,'2')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTDDEF).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "26", "CW2_CTHDEF", "C",200			, 0, "Frm.Dest.CTH"		, "Frm.Dest.CTH"	, "Dest.Frm.CTH"	, "Formula: Clvl. Destino" 	, "Formula: Clvl. Destino"	  		, "Formula: Destin. V.Class" 		, "@S40"		, "Vazio() .Or. Ctb277Form('C')" 						 								  						, aSX3Copia[03,2], ""   , "CTH"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					          							, ""					            , ""					          	, "", "EMPTY(M->CW2_CTHDES).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "27", "CW2_CTHDES", "C",006			, 0, "Grp.Dest.CTH"		, "Grp.Dest.CTH"	, "Dest.Grp.CTH"	, "Grupo Destino - Clvl."   	, "Grupo Destino - Clvl."    		, "Destin. Group - V.Class"   	, "@!"		, "Vazio() .Or.ExistCpo('CW1',M->CW2_CTHDES,1) .AND. CTB277VLDGR('4',M->CW2_CTHDES,'2')" 		, aSX3Copia[03,2], ""   , "CW1"	, 1 , aSX3Copia[03,3], "", "", "", "N", "A" , "", "", ""	, ""					        							   , ""					            , ""					          	, "", "EMPTY(M->CW2_CTHDEF).AND.!_lCW2_DSTCOMB", "", "","","S"})
Aadd(aSX3,{	"CW2", "28", "CW2_FORMUL", "C",060			, 0, "Form. Fator" 		, "Form. Fator" 	, "Factor Form." 	, "Formula fator destino"		, "Formula fator destino"  	 	, "Destin. formula factor"	  		, "@!"      , "Vazio() .Or. Ctb277Form('N')"                                  	                    		, aSX3Copia[03,2], ""   ,    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "A",  "", "", ""	, ""							 							   , ""								, ""								, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "29", "CW2_STATUS", "C",001			, 0, "Situacao"    		, "Situacion"   	, "Status"      	, "Situacao da Amarracao"    	, "Situacion del Vinculo"    		, "Binding Status"      	 		, "@!"		, ""                                        	             							  					, aSX3Copia[03,2], "'1'",    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "V", "", "", ""	, "1=Pendente;2=Alterado;3=Gerado;4=Bloqueado"	, "1=Pendente;2=Alterado;3=Gerado;4=Bloqueado", "1=Pendente;2=Alterado;3=Gerado;4=Bloqueado"	, "", "", "", "","","S"})
Aadd(aSX3,{	"CW2", "30", "CW2_MSBLQL", "C",001			, 0, "Bloqueado?"	  	, "Bloqueado?"  	, "Blocked?" 		, "Amarração bloqueada?"		, "Vínculo bloqueado?"  	  		, "Blocked in binding?"		  		, "@!"      , "Pertence('12')"                                  	                    			 				, aSX3Copia[03,2], "'2'",    ""	, 1 , aSX3Copia[03,3], "", "", "", "N", "V",  "", "", ""	, "1=Sim;2=Não"					  						, "1=Sim;2=Não"					, "1=Sim;2=Não"						, "", "", "", "","","S"})

Aadd(aSX3,{	"CW3", "01", "CW3_FILIAL", "C", nTamFilial	, 0, "Filial"      , "Sucursal"	  , "Branch"   	  , "Filial do Sistema"			, "Sucursal del Sistema"     , "System Branch"        	, "@!"                   , ""                                                         	, aSX3Copia[01,2], ""   ,    "", 1 , aSX3Copia[01,3]	, "", "", "",  "", ""	, "", "", "", "", "", "", "", "", "", "033","","S"})
Aadd(aSX3,{	"CW3", "02", "CW3_CODIGO", "C", 06			, 0, "Cod. Indice" , "Cod. Indice" , "Index Code"  , "Cod. Indice Estatistico"  	, "Cod. índice estadístico"  , "Statistic Index Code"  	, "@!"                   , "ExistChav('CW3',,1) .And. FreeForUse('CW3',M->CW3_CODIGO)"	, aSX3Copia[02,2], ""   ,    "", 1 , aSX3Copia[02,3]	, "", "", "", "S", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "03", "CW3_DESCRI", "C", 40			, 0, "Descricao"   , "Descripcion" , "Description" , "Descricao Indice Estat"    , "Desc.índice estadístico"  , "Index Code description"	, "@!"                   , ""                                 	                       	, aSX3Copia[02,2], ""   ,    "", 1 , aSX3Copia[02,3]	, "", "", "", "S", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "04", "CW3_ENTID" , "C", 01			, 0, "Entidade"    , "Entidad"     , "Entity"      , "Entidade Contabil" 	    , "Entidad Contable"         , "Account Entity"      	, "@!"	                 , ""                                                           , aSX3Copia[02,2], "'1'",    "", 1 , aSX3Copia[02,3]	, "", "", "", "S", "A"	, "", "", "", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor", "1=Conta Contabil;2=Centro Custo;3=Item Contabil;4=Classe Valor", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "05", "CW3_SEQUEN", "C", 03			, 0, "Sequencial"  , "Sequencial"  , "Sequential"  , "Sequencial"				, "Sequencial"               , "Sequential"            	, "@!"                   , ""                                        	               	, aSX3Copia[02,2], ""   ,    "", 1 , aSX3Copia[02,3]	, "", "", "", "N", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "06", "CW3_CODENT", "C", 20			, 0, "Cod Entidade", "Cod Entidad" , "Entity Code" , "Cod. da entidade contábil"	, "Codigo Entidad Contable"  , "Account Entity Code"  	, "@!"	                 , "CTB278VLCW3()"												, aSX3Copia[02,2], ""	,"CW3CD", 1, aSX3Copia[02,3]	, "", "", "", "N", "A"	, "", "", "", "", "", "", "", "", "", "003","","S"})
Aadd(aSX3,{	"CW3", "07", "CW3_UM"    , "C", 02			, 0, "Unid. Medida", "Unid. Medida", "Unit of Meas", "Unidade de Medida"      	, "Unidad Medida"            , "Unit of Measurement"  	, "@!"	                 , "Vazio(M->CW3_UM) .or. ExistCpo('SAH',M->CW3_UM,1)"    		, aSX3Copia[03,2], ""   , "SAH", 1 , aSX3Copia[03,3]	, "", "", "", "N", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "08", "CW3_FATOR" , "N", 18			, 4, "Fator Ind"   , "Factor Ind"  , "Factor Ind"  , "Fator do Indice Estat"     , "Fator índice estadístico" , "Statistic index factor"	, "@E 9,999,999,999.9999", ""															, aSX3Copia[03,2], ""   ,    "", 1 , aSX3Copia[03,3]	, "", "", "", "N", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CW3", "09", "CW3_FORMUL", "C", 60			, 0, "Form. Fator" , "Form. Fator" , "Form. Fator" , "Formula fator destino"		, "Formula fator destino"  	 , "Destin. formula factor"	, "@!"      			 , "Vazio() .Or. Ctb277Form('N')"                               , aSX3Copia[03,2], ""   ,    "", 1 , aSX3Copia[03,3]	, "", "", "", "N", "A"	, "", "", "", "", "", "", "", "", "", "","","S"})
//Aadd(aSX3,{	"CW3", "10", "CW3_PERCEN", "N", 06		, 2, "Percen Ratei", "Porc Prorrat", "Prorat Perc" , "Percentual de Rateio"     	, "Porcentaje de Prorrateo"  , "Proration Percentage"  	, "@E 999.99"            , ""                                                         	, aSX3Copia[01,2], ""   ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "V", "", "", "", "", "", "", "", "", "", "","","S"})
// CAMPO QUE DEVERA SER REMOVIDO DE USO DO SX3
Aadd(aSX3,{	"CW3", "10", "CW3_PERCEN", "N", 06			, 2, "Percen Ratei", "Porc Prorrat", "Prorat Perc" , "Percentual de Rateio"     	, "Porcentaje de Prorrateo"  , "Proration Percentage"  	, "@E 999.99"            , ""                                                         	, aSX3Copia[01,2], ""   ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "V", "", "", "", "", "", "", "", "", "", "","","N"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CW8 - Historico de Alteracoes do Grupo e Naturea Contabil.		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSX3,{ "CW8","01","CW8_FILIAL"  ,"C",nTamFilial	,0,"Filial"		,"Sucursal"		,"Branch"		,"Filial do sistema"			,"Sucursal del sistema"		 			,"System branch"				,""		,"",aSX3Copia[01,2],"","",1,aSX3Copia[01,3],"","","","N","A","R","","","","","","","","","033","","S"})
AADD(aSX3,{ "CW8","02","CW8_FILTAB"	 ,"C",nTamFilial	,0,"Filial Tab.","Sucursal Tab.","Branch Tab."	,"Filial da Tabela SA1/SA2"		,"Filial da Tabela SA1/SA2"				,"Branch of the table"			,""		,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","033","","S"})
AADD(aSX3,{ "CW8","03","CW8_TABELA"	 ,"C",03			,0,"Tabela"		,"Tabla"		,"Table"		,"Alias da Tabela (SA1/SA2)"	,"Alias de la Tabla SA1/SA2"			,"Alias of the table"			,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","04","CW8_CODIGO"	 ,"C",70			,0,"Entidade"	,"Entidad"		,"Entity"		,"Código da Entidade Contábil"	,"Código de Entidad Contable"			,"Account Entity Code"			,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","S","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","05","CW8_GRUPO"	 ,"C",09			,0,"Grupo/Nat." ,"Grupo/Nat"	,"Group/Nat"	,"Grupo/Natureza Contabil"		,"Grupo/Naturez Contable"				,"Group/Nature Account"			,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","S","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","06","CW8_CAMPO"	 ,"C",10			,0,"Campo"		,"Campo"		,"Field"		,"Campo alterado"				,"Campo modificado"						,"Modified Field"				,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","07","CW8_SEQ"	 ,"C",06			,0,"Sequencia"	,"Secuencia"	,"Sequencia"	,"Sequencia de Alteração"		,"Secuencia de modificación"			,"Update Sequence"				,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","08","CW8_TIPCPO"	 ,"C",01			,0,"Tipo Campo"	,"Tipeo"		,"Type"			,"Tipo do Campo"				,"Tipeo del Campoo"						,"Field Type"					,"!"	,"Pertence(12345)",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","1=Character;2=Numerico;3=Logico;4=Data;5=Memo","1=Character;2=Numerico;3=Logio;4=Fecha;5=Memo","1=Character;2=Numeric;3=Logic;4=Date;5=Memo","","","","","","S"})
AADD(aSX3,{	"CW8","09","CW8_TITULO"	 ,"C",12			,0,"Titulo"		,"Titulo"		,"Title"		,"Titulo do Campo"				,"Titulo del Campo"						,"Field Title"					,""		,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","10","CW8_VALANT"	 ,"C",60			,0,"Anterior"	,"Anterior"		,"Past"			,"Conteudo antes alteracao"		,"Contiene antes de la modificacion"	,"Content after alteration"		,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","11","CW8_VALNOV"	 ,"C",60			,0,"Atual"		,"Actual"		,"Actual"		,"Conteudo atual		"		,"Contenido Actual"						,"Content before alteration"	,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","12","CW8_DATA"	 ,"D",08			,0,"Data"		,"Fecha"		,"Date"			,"Data da Alteracao"			,"Fecha del cambio"						,"Date of the alteration"		,"@D"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","13","CW8_HORA"	 ,"C",05			,0,"Hora"		,"Horas"		,"Hour"			,"Hora da Alteracao"			,"Hora de cambio"						,"Hour of the alteration"		,"99:99","",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","A","R","","","","","","","","","","","S"})
AADD(aSX3,{	"CW8","14","CW8_OPC"	 ,"C",01			,0,"Opcão"		,"Opcion"		,"Option"		,"Opção da Rotina"				,"Opción de la Rutina"					,"Procedure Option"				,"@!"	,"Pertence(12345)",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","V","R","","","1=Pesquisa;2=Visualização;3=Inclusão;4=Alteração;5=Exclusão","1=Busca;2=Visualización;3=Inclusión;4=Modificación;5=Borrado","1=Search;2=View;3=Inserted;4=Updated;5=Deleted","","","","","","S"})
AADD(aSX3,{	"CW8","15","CW8_HISTOR"	 ,"C",06			,0,"Seq. Hist."	,"Sec. Hist."	,"Seq.Hist."	,"Sequencia do Histórico"		,"Secuencia del Historial"				,"Historical Sequence"			,"@!"	,"",aSX3Copia[03,2],"","",1,aSX3Copia[02,3],"","","","N","V","R","","","","","","","","","","","S"})

//
// Atualizando CTQ (Rateios Off-Line)

Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_UM")		, "CTQ_UM"		, "C", 02, 0, "Unidade"   		, "Unidad" 			, "Unit" 			, "Unidade de Medida"    			, "Unidad de Medida"   		  		, "Unit of Measurement"				, "@!"					, "Vazio() .Or. ExistCpo('SAH')"	, aSX3Copia[03][2]	, ""	, "SAH"	, 1	, aSX3Copia[03][3], ""	, "", "", "N", "A"	,"", ""	, "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_VALOR")	, "CTQ_VALOR"	, "N", 12, 2, "Valor"   		, "Valor" 			, "Value" 			, "Valor"    						, "Valor"   		  				, "Value"							, "@E 999,999,999.99"	, "Positivo()" 						, aSX3Copia[03][2]	, ""	, ""	, 1	, aSX3Copia[03][3], ""	, "", "", "N", "A"	,"", ""	, "", "", "", "", "", "", "", "","","S"})


Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_FORMUL")	, "CTQ_FORMUL", "C", 60, 0, "Formula"   		, "Formula" 		, "Formula" 		, "Form.atualizacao"    			, "Form.atualizacao"   		  		, "Form.atualizacao"				, "@!", "Vazio() .Or. Ctb277Form('N')"	, aSX3Copia[03][2]	, ""	, "", 1	, aSX3Copia[03][3], "", "", "", "N", "A"	,"", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_INTERC")	, "CTQ_INTERC", "C", 01, 0, "Intercompany?"		, "Intercompany?"  	, "Intercompany?"  	, "Lanctos com intercompany?"		, "Lanctos com intercompany?"		, "Lanctos com intercompany?"		, "@!", "Pertence('12')"				, aSX3Copia[03][2]	, "'2'"	, "", 1	, aSX3Copia[03][3], "", "", "", "N", "A"	,"", "", "", "1=Sim;2=Não" , "1=Sim;2=Não", "1=Sim;2=Não" , "", "", "", "","","S"})
Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_AMARRA")	, "CTQ_AMARRA", "C", 06, 0, "Amarracao"			, "Vinculo"			, "Binding"			, "Codigo da Amarracao de Rateio"	, "Codigo da Amarracao de Rateio"	, "Codigo da Amarracao de Rateio"	, "@!", ""								, aSX3Copia[01][2]	, ""	, "", 1	, aSX3Copia[01][3], "", "", "", "N", "A"	,"", "", "", "", "", "", "", "", "", "","","S"})
Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_MSBLQL")	, "CTQ_MSBLQL", "C", 01, 0, "Bloqueado?"		, "Bloqueado?"  	, "Bloqueado?"  	, "Rateio bloqueado?"	   			, "Rateio bloqueado?"  	 			, "Rateio bloqueado?"				, "@!", "Pertence('12')"				, aSX3Copia[03][2]	, "'2'"	, "", 1	, aSX3Copia[03][3], "", "", "", "N", "A"	,"", "", "", "1=Sim;2=Não" , "1=Sim;2=Não", "1=Sim;2=Não" , "", "", "", "","","S"})
Aadd(aSX3,{	"CTQ", ProxSX3("CTQ","CTQ_STATUS")	, "CTQ_STATUS", "C", 01, 0, "Status"		 	, "Status" 	 		, "Status" 	 		, "Status do rateio"				, "Status do rateio"		 		, "Status do rateio"				, "@!", ""								, aSX3Copia[03][2]	, "" 	, "", 1 , aSX3Copia[03][3], "", "", "", "N", "V"	,"", "", "", ""	, "", "", "", "", "", "","","S"})

aAdd(aSX3, {"CV7","01","CV7_FILIAL"	,"C",nTamFilial	,0	,"Filial"		,"Sucursal"		,"Branch"		,"Fililal do Sistema"		,"Sucursal del Sistema"		,"System branch"			,""						,""					,"€€€€€€€€€€€€€€€"	,""	,""		,1,"†À"	,""	,""	,"",""	,""	,""	,""	,"",""									,""										,""											,"","","","033"	,"","S"	})
aAdd(aSX3, {"CV7","02","CV7_DATA"	,"D",8			,0	,"Data"			,"Fecha"		,"Date"			,"Maior Data Atualizada"	,"Mayor Fecha Actualizada"	,"Highest updated date"		,""						,""					,"€€€€€€€€€€€€€€ "	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV7","03","CV7_MOEDA"	,"C",2			,0	,"Moeda"		,"Moneda"		,"Currency"		,"Moeda"					,"Moneda"					,"Currency"					,"@!"					,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV7","04","CV7_TPSALD"	,"C",1			,0	,"Tipo Saldo"	,"Tipo Saldo"	,"Balance type"	,"Tipo de Saldo"			,"Tipo de Saldo"			,"Balance type"				,""						,""					,"€€€€€€€€€€€€€€°"	,""	,"SLW"	,1,"‡À"	,""	,""	,"",""	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})

aAdd(aSX3, {"CV8","01","CV8_FILIAL"	,"C",nTamFilial	,0	,"Filial"		,"Sucursal"		,"Branch"		,"Filial"					,"Sucursal"					,"Branch"					,""						,""					,"€€€€€€€€€€€€€€€"	,""	,""		,1,"†À"	,""	,""	,"",""	,""	,""	,""	,"",""									,""										,""											,"","","","033"	,"","S"	})
aAdd(aSX3, {"CV8","02","CV8_DATA"	,"D",8			,0	,"Data"			,"Fecha"		,"Date"			,"Data da Ocorrencia"		,"Fecha de la Ocurrencia"	,"Occurrence Date"			,""						,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","03","CV8_HORA"	,"C",5			,0	,"Hora"			,"Hora"			,"Occur.Time"	,"Hora da Ocorrencia"		,"Fecha de la Ocurrencia"	,"Occurrence Time"			,"99:99"				,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""									   		,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","04","CV8_USER"	,"C",15			,0	,"Usuario"		,"Usuario"		,"User"			,"Usuario"					,"Usuario"					,"User"						,""						,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","05","CV8_MSG"	,"C",100		,0	,"Mensagem"		,"Mensaje"		,"Message"		,"Mensagem"					,"Mensaje"					,"Message"					,""						,""					,"€€€€€€€€€€€€€€ "	,""	,""		,1,"–À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","06","CV8_DET"	,"M",10			,0	,"Detalhes"		,"Detalles"		,"Details"		,"Detalhes"					,"Detalles"					,"Details"					,""						,""					,"€€€€€€€€€€€€€€ "	,""	,""		,1,"†À"	,""	,""	,"","N"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","07","CV8_PROC"	,"C",15			,0	,"Processo"		,"Proceso"		,"Process"		,"Processo"					,"Proceso"					,"Process"					,""						,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"‡À"	,""	,""	,"","S"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV8","08","CV8_INFO"	,"C",1			,0	,"Tipo Ocor."	,"Tipo Ocur."	,"Occur.Type"	,"Tipo de Ocorrencia"		,"Tipo de Ocurrencia"		,"Occurrence Type"			,""						,""					,"€€€€€€€€€€€€€€€"	,""	,""		,1,"‡À"	,""	,""	,"","N"	,"V",""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})

//
// Atualizando CV9 (Historicos de Rateio Off-Line)

aAdd(aSX3, {"CV9","01","CV9_FILIAL"	,"C",nTamFilial	,0	,"Filial"		,"Sucursal"		,"Branch"		,"Filial"					,"Sucursal"					,"Branch"					,"!!"					,""					,"€€€€€€€€€€€€€€€"	,""	,""		,1,"€€"	,""	,""	,"","N"	,""	,""	,""	,"",""									,""										,""											,"","","","033"	,"","S"	})
aAdd(aSX3, {"CV9","02","CV9_RATEIO"	,"C",6			,0	,"Cod Rateio"	,"Cod.Prorrat."	,"Prorat.Code"	,"Codigo do Rateio"			,"Codigo de Prorrateo"		,"Proration Code"			,"@!"					,""					,"€€€€€€€€€€€€€€"	,""	,""		,1,"ƒ€"	,""	,""	,"","N"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","03","CV9_REVISA"	,"C",4			,0	,"Revisao"		,"Revision"		,"Revision"		,"Revisao do Rateio"		,"Revision de Prorrateo"	,"Proration Revision"		,"@!"					,""					,"€€€€€€€€€€€€€€"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","04","CV9_DESC"	,"C",20			,0	,"Descricao"	,"Descripcion"	,"Description"	,"Descricao do Rateio"		,"Descripcion de Prorrateo"	,"Proration Description"	,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","05","CV9_TIPO"	,"C",1			,0	,"Tipo Rateio"	,"Tipo Prorrat"	,"Apport.Type"	,"Tipo do Rateio"			,"Tipo de Prorrateo"		,"Apportionment type"		,"!"					,""					,"€€€€‚€€€€€€€€€€"	,"1",""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"","1=Movimento Mes;2=Saldo Acumulado"	,"1=Movimiento Mes;2=Saldo Acumulado"	,"1=Monthly Movement;2=Accumulated Balance"	,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","06","CV9_PERBAS"	,"N",6			,2	,"Perc Base"	,"Porc Base"	,"Base Percen."	,"Percentual a Ratear"		,"Porcentaje por Prorratear","Percentage to apportion"	,"@E 999.99"			,""					,"€€€€‚€€€€€€€€€€"	,"100",""	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","07","CV9_CTORI"	,"C",nTamConta	,0	,"Conta Origem"	,"Cuenta Orig."	,"Src.Account"	,"Conta Origem"				,"Cuenta Origen"			,"Source Account"			,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CT1"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","003"	,"","S"	})
aAdd(aSX3, {"CV9","08","CV9_CCORI"	,"C",nTamCCusto	,0	,"C Custo Ori"	,"C Costo Or."	,"Src.Cos.Cen."	,"Centro de Custo Origem"	,"Centro de Costo Origen"	,"Source Cost Center"		,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTT"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","004"	,"","S"	})
aAdd(aSX3, {"CV9","09","CV9_ITORI"	,"C",nTamItCont	,0	,"Item Conta"	,"Item Cuenta"	,"Origin acct"	,"Item Origem"				,"Item Origen"				,"Origin Item"				,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTD"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","005"	,"","S"	})
aAdd(aSX3, {"CV9","10","CV9_CLORI"	,"C",nTamClVlr	,0	,"Cod.Cl Val"	,"Cl Origen"	,"Src.Val.Cat."	,"Cl Valor Origem"			,"Cl Valor Origen"			,"Source Value Category"	,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTH"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","006"	,"","S"	})
aAdd(aSX3, {"CV9","11","CV9_CTPAR"	,"C",nTamConta	,0	,"Conta Part"	,"Cuenta Part"	,"Entry Acc."	,"Conta Partida"			,"Cuenta Partida"			,"Entry Account"			,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CT1"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","003"	,"","S"	})
aAdd(aSX3, {"CV9","12","CV9_CCPAR"	,"C",nTamCCusto	,0	,"C Custo Part"	,"C Costo Part"	,"Ent.Cos.Cen."	,"Centro de Custo Partida"	,"Centro de Costo Partida"	,"Entry Cost Center"		,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTT"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","004"	,"","S"	})
aAdd(aSX3, {"CV9","13","CV9_ITPAR"	,"C",nTamItCont	,0	,"Item Conta"	,"Item Partida"	,"Entry Item"	,"Item Partida"				,"Item Partida"				,"Lot Item"					,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTD"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","005"	,"","S"	})
aAdd(aSX3, {"CV9","14","CV9_CLPAR"	,"C",nTamClVlr	,0	,"Cod.Cl Val"	,"Cl. Partida"	,"Ent.Val.Cl."	,"Cl Valor Partida"			,"Cl. Valor Partida"		,"Entry Value Class"		,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTH"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","006"	,"","S"	})
aAdd(aSX3, {"CV9","15","CV9_SEQUEN"	,"C",3			,0	,"Sequencial"	,"Secuencial"	,"Sequential"	,"Sequencial"				,"Secuencial"				,"Sequential"				,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","16","CV9_CTCPAR"	,"C",nTamConta	,0	,"Conta CPar"	,"Cuenta CPar"	,"Con.Ent.Acc."	,"Conta Contra-Partida"		,"Cuenta Contrapartida"		,"Contra Entry Account"		,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CT1"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","003"	,"","S"	})
aAdd(aSX3, {"CV9","17","CV9_CCCPAR"	,"C",nTamCCusto	,0	,"CCusto CPar"	,"CCosto CPar"	,"C.Ent.C Cent"	,"C Custo Contra-Partida"	,"C Costo Contrapartida"	,"Contra Entry Cost Center"	,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTT"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","004"	,"","S"	})
aAdd(aSX3, {"CV9","18","CV9_ITCPAR"	,"C",nTamItCont	,0	,"Item Conta"	,"Item Cuenta"	,"Con.Ent.Item"	,"Item Contra-Partida"		,"Item Contrapartida"		,"Contra Entry Item"		,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTD"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","005"	,"","S"	})
aAdd(aSX3, {"CV9","19","CV9_CLCPAR"	,"C",nTamClVlr	,0	,"Cod.Cl Val"	,"Cod.Cl Val"	,"Con.Ent.V.Ct"	,"Cl Valor Contra-Partida"	,"Cl Valor Contrapartida"	,"Contra Entry Value Cat."	,"@!"					,""					,"€€€€‚€€€€€€€€€€"	,""	,"CTH"	,1,"‚À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","","006"	,"","S"	})
aAdd(aSX3, {"CV9","20","CV9_UM"		,"C",2			,0	,"Unidade"		,"Unidad"		,"Measure Unit"	,"Unidade de Medida"		,"Unidad de Medida"			,"Measurement Unit"			,"@!"					,"ExistCpo('SAH')"	,"€€€€€€€€€€€€€€ "	,""	,"SAH"	,1,"‡€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"})
aAdd(aSX3, {"CV9","21","CV9_VALOR"	,"N",12			,2	,"Valor"		,"Valor"		,"Value"		,"Valor do Lancamento"		,"Valor del asiento"		,"Entry Value"				,"@E 999,999,999.99"	,""					,"€€€€€€€€€€€€€€ "	,""	,""		,1,"‡€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","22","CV9_PERCEN"	,"N",6			,2	,"Percen Ratei"	,"Porc.Prorrat"	,"Prorat.Perc."	,"Percentual de Rateio"		,"Porcentaje de Prorrateo"	,"Proration Percentage"		,"@E 999.99"			,""					,"€€€€‚€€€€€€€€€€"	,""	,""		,1,"žÀ"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"})
aAdd(aSX3, {"CV9","23","CV9_DATA"	,"D",8			,0	,"Data Lcto"	,"Fch.Asiento"	,"Entry Date"	,"Data do Lancamento Contab","Fch.de Asiento Contable"	,"Accounting Entry Date"	,"99/99/9999"			,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","24","CV9_LOTE"	,"C",6			,0	,"Numero Lote"	,"Numero Lote"	,"Lot Number"	,"Numero do Lote"			,"Numero de Lote"			,"Lot Number"				,"@!"					,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","25","CV9_SBLOTE"	,"C",3			,0	,"Sub Lote"		,"Sublote"		,"Sublot"		,"Sub Lote"					,"Sublote"					,"Sublot"					,"@!"					,""					,"€€€€€€€€€€€€€€°"	,""	,"SB"	,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","26","CV9_DOC"	,"C",6			,0	,"Numero Doc"	,"Numero Doc"	,"Doc Number"	,"Numero do Documento"		,"Numero del Documento"		,"Document Number"			,"@!"					,""					,"€€€€€€€€€€€€€€°"	,""	,""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","27","CV9_STATUS"	,"C",1			,0	,"Status"		,"Estatus"		,"Status"		,"Status do historico"		,"Estatus del historial"	,"History Status"			,"9"					,""					,"€€€€€€€€€€€€€€°"	,"1",""		,1,"ƒ€"	,""	,""	,"","S"	,""	,""	,""	,"","1=Cadastro;2=Processo"				,"1=Archivo;2=Proceso"					,"1=Record;2=Process"						,"","","",""	,"","S"	})
aAdd(aSX3, {"CV9","28","CV9_ROTINA"	,"C",10			,0	,"Rotina"		,"Rutina"		,"Routine"		,"Rotina Geradora"			,"Rutina Generadora"		,"Generator Routine"		,"@!"					,""					,"€€€€€€€€€€€€€€€"	,""	,""		,1,"’À"	,""	,""	,"","S"	,""	,""	,""	,"",""									,""										,""											,"","","",""	,"","S"	})


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If ! cPaisLoc $ "COL|PER"
	Aadd(aSX3,{"CVN","01","CVN_FILIAL","C",nTamFilial	,0,"Filial"      ,"Filial"      ,"Filial"      ,"Filial do sistema"          ,"Filial do sistema"          ,"Filial do sistema"          ,"@!"                     ,""                                                                               ,aSX3Copia[01,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"N" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"","033" ,"","S"})
	Aadd(aSX3,{"CVN","02","CVN_CODPLA","C",06 			,0,"Plano Ref."  ,"Plano Ref."  ,"Plano Ref."  ,"Codigo plano referencial"   ,"Codigo plano referencial"   ,"Codigo plano referencial"   ,"@!"                     ,"NaoVazio() .And. ExistChav('CVN',M->CVN_CODPLA)"                                ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"","INCLUI"             ,"",""    ,"","S",.T.})
	Aadd(aSX3,{"CVN","03","CVN_DSCPLA","C",40 			,0,"Descr.P.Ref.","Descr.P.Ref.","Descr.P.Ref.","Descricao plano referencial","Descricao plano referencial","Descricao plano referencial","@!S20"                  ,"NaoVazio()"                                                                     ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S"})
	Aadd(aSX3,{"CVN","04","CVN_DTVIGI","D",08 			,0,"Dt.Vig.Inic.","Dt.Vig.Inic.","Dt.Vig.Inic.","Data vigencia inicial"      ,"Data vigencia inicial"      ,"Data vigencia inicial"      ,"@D"                     ,"Vazio() .OR. IIF(!EMPTY(M->CVN_DTVIGF),(M->CVN_DTVIGF >= M->CVN_DTVIGI),.T.)"   ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S"})
	Aadd(aSX3,{"CVN","05","CVN_DTVIGF","D",08 			,0,"Dt.Vig.Fim"  ,"Dt.Vig.Fim"  ,"Dt.Vig.Fim"  ,"Data vigencia final"        ,"Data vigencia final"        ,"Data vigencia final"        ,"@D"                     ,"Vazio() .OR. IIF(!EMPTY(M->CVN_DTVIGF),(M->CVN_DTVIGF >= M->CVN_DTVIGI),.T.)"   ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S"})
	Aadd(aSX3,{"CVN","06","CVN_ENTREF","C",02 			,0,"Entidade"    ,"Entidade"    ,"Entidade"    ,"Codigo da entidade"         ,"Codigo da entidade"         ,"Codigo da entidade"         ,"@!"                     ,"ExistCpo('SX5','GP'+M->CVN_ENTREF)"                                             ,aSX3Copia[02,2] ,""     ,"GP"    ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S"})
	Aadd(aSX3,{"CVN","07","CVN_LINHA" ,"C",nCVNLinha	,0,"Linha"       ,"Linha"       ,"Linha"       ,"Linha"                      ,"Linha"                      ,"Linha"                      , cPicCVNLinha            ,"NaoVazio()"                                                             		  ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"N" ,"V" ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S"})
	Aadd(aSX3,{"CVN","08","CVN_CTAREF","C",nTamCtaRef 	,0,"Conta Ref."  ,"Conta Ref."  ,"Conta Ref."  ,"Codigo conta referencial"   ,"Codigo conta referencial"   ,"Codigo conta referencial"   ,"@!"                     ,"NaoVazio()"                                                                     ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"","027" ,"","S"})
	Aadd(aSX3,{"CVN","09","CVN_DSCCTA","C",40 			,0,"Descr.C.Ref.","Descr.C.Ref.","Descr.C.Ref.","Descricao conta referencial","Descricao conta referencial","Descricao conta referencial","@!S40"                  ,"NaoVazio()"                                                                     ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,""                                                                ,""                                                                ,""                                                               ,"",""                   ,"",""    ,"","S",.T.})
	Aadd(aSX3,{"CVN","10","CVN_TPUTIL","C",1 			,0,"Tp.Utiliz."  ,"Tp.Utiliz."  ,"Tp.Utiliz.  ","Tipo de Utilizacao"         ,"Tipo de Utilizacao"         ,"Tipo de Utilizacao"         ,"@!"                     ,"Pertence('F,S,A, ')"                                                            ,aSX3Copia[02,2] ,""     ,""      ,1 ,aSX3Copia[02,3] ,"" ,"" ,"" ,"S" ,""  ,"" ,"" ,"" ,"F=Fiscal;S=Societario;A=Ambos"								    ,"F=Fiscal;S=Societario;A=Ambos"   								   ,"F=Fiscal;S=Societario;A=Ambos"                          	     ,"",""                   ,"",""    ,"","S",.T.})
EndIf

// Atualizando as tabelas (CT2, CT5, CTK e CV3 ) para multiplos tipo de saldos
aAdd(aSX3     ,{	"CT5", ProxSX3("CT5","CT5_MLTSLD"), "CT5_MLTSLD", "C", 20, 0, "Tps Saldos", "Tps Saldos","Tps Saldos", "Tps Saldos", "Tps Saldos", "Tps Saldos"     		, "@!"  , ""						, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CT2", ProxSX3("CT2","CT2_MLTSLD"), "CT2_MLTSLD", "C", 20, 0, "Tps Saldos", "Tps Saldos","Tps Saldos", "Tps Saldos", "Tps Saldos", "Tps Saldos"     		, "@!"  , ""						, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CTK", ProxSX3("CTK","CTK_MLTSLD"), "CTK_MLTSLD", "C", 20, 0, "Tps Saldos", "Tps Saldos","Tps Saldos", "Tps Saldos", "Tps Saldos", "Tps Saldos"     		, "@!"  , ""						, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "","S"})
aAdd(aSX3     ,{	"CV3", ProxSX3("CV3","CV3_MLTSLD"), "CV3_MLTSLD", "C", 20, 0, "Tps Saldos", "Tps Saldos","Tps Saldos", "Tps Saldos", "Tps Saldos", "Tps Saldos"     		, "@!"  , ""						, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})

// Atualizando a tabela (CT2) para controlar se o lancamento ja foi copiado ou nao
aAdd(aSX3     ,{	"CT2", ProxSX3("CT2","CT2_CTLSLD"), "CT2_CTLSLD", "C", 01, 0, "Status Copia"	, "Status Copia", "Status Copia"	, "Status da Copia"	, "Status da Copia"	, "Status da Copia"	, "@!"	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})

// Atualizando CVE (Visao Gerencial)

aAdd(aSX3,{	"CVE", "01", "CVE_FILIAL", "C", nTamFilial	, 0, "Filial"      		, "Sucursal"		, "Branch"   		, "Filial do Sistema"			, "Sucursal del Sistema"     	, "System Branch"        		, "@!", ""  				, aSX3Copia[01][2]	, ""    , "", 1, aSX3Copia[01][3]	, "", "", "", "N", ""	,"", "", "", "", "", "", "", "", "","033"	, "", "S"})
aAdd(aSX3,{	"CVE", "02", "CVE_CODIGO", "C", 03			, 0, "Cod Visao" 		, "Cod Visao"		, "Cod Visao" 		, "Codigo da Visao Gerencial"  	, "Codigo da Visao Gerencial"	, "Codigo da Visao Gerencial"	, "@!", 'ExistChav("CVE")'	, aSX3Copia[02][2]	, ""	, "", 1, aSX3Copia[03][3]	, "", "", "", "S", ""	,"", "", "", "", "", "", "", "", "",""		, "", "S"})
aAdd(aSX3,{	"CVE", "03", "CVE_DESCRI", "C", 30			, 0, "Desc Ent Ger"		, "Desc Ent Ger"	, "Desc Ent Ger"  	, "Descricao Entid Gerencial"	, "Descricao Entid Gerencial"	, "Descricao Entid Gerencial"	, "@!", ""					, aSX3Copia[02][2]	, ""	, "", 1, aSX3Copia[03][3]	, "", "", "", "S", ""	,"", "", "", "", "", "", "", "", "",""		, "", "S"})
aAdd(aSX3,{	"CVE", "04", "CVE_OBS"   , "C",100			, 0, "Observação"		, "Observação"		, "Observação"		, "Observação da Visal Geren"	, "Observação da Visal Geren"	, "Observação da Visal Geren"	, "@!", ""					, aSX3Copia[03][2]	, ""	, "", 1, aSX3Copia[03][3]	, "", "", "", "N", ""	,"", "", "", "", "", "", "", "", "",""		, "", "S"})

// Atualizando CVF (Estrutura da Visao Gerencial)

aAdd(aSX3,{	"CVF", "01", "CVF_FILIAL", "C", nTamFilial	, 0, "Filial"      		, "Sucursal"		, "Branch"   		, "Filial do Sistema"			, "Sucursal del Sistema"     	, "System Branch"        		, "@!"	, ""  													, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "N", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","033", "", "S"})
aAdd(aSX3,{	"CVF", "02", "CVF_CODIGO", "C", 03			, 0, "Cod Visao" 		, "Cod Visao"		, "Cod Visao" 		, "Codigo da Visao Gerencial"  	, "Codigo da Visao Gerencial"	, "Codigo da Visao Gerencial"	, "@!"	, ""													, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "03", "CVF_CONTAG", "C", 20			, 0, "Entid Gerenc"		, "Entid Gerenc"	, "Entid Gerenc"	, "Entidade Gerencial"       	, "Entidade Gerencial"       	, "Entidade Gerencial"       	, "@!"	, 'ExistChav("CVF",M->CVF_CODIGO+M->CVF_CONTAG,1,)'		, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", "!M->CVF_TRACO"	, "","", "", "S",.T.})
aAdd(aSX3,{	"CVF", "04", "CVF_ORDEM" , "C", 10			, 0, "Ordem"       		, "Ordem"	      	, "Ordem"	      	, "Ordem de Exibicao"       	, "Ordem de Exibicao"       	, "Ordem de Exibicao"       	, "@!"	, 'ExistChav("CVF",M->CVF_CODIGO+M->CVF_ORDEM,4,)'		, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "05", "CVF_CLASSE", "C", 01			, 0, "Classe"      		, "Classe"	     	, "Classe"	     	, "Classe de Entid Gerencial"	, "Classe de Entid Gerencial"   , "Classe de Entid Gerencial"  	, "@" 	, ""													, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Sintetica;2=Analitica" , "1=Sintetica;2=Analitica"	, "1=Summarized;2=Detailed", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "06", "CVF_CTASUP", "C", 20			, 0, "Entid Super" 		, "Entid Super"    	, "Entid Super"    	, "Entidade Superior"			, "Entidade Superior"  			, "Entidade Superior"  			, "@!"	, ""													, aSX3Copia[03][2]	, "CVF->CVF_CONTAG"				, "", 1	, aSX3Copia[03][3]	, "", "" , "", "S", "A"	, "" , "", "", ""                       														, ""    , "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "07", "CVF_DESCCG", "C", 40			, 0, "Desc Ent Ger"		, "Desc Ent Ger"	, "Desc Ent Ger"  	, "Descricao Entid Gerencial"	, "Descricao Entid Gerencial"	, "Descricao Entid Gerencial"	, "@!"	, ""													, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S", .T.})
aAdd(aSX3,{	"CVF", "08", "CVF_NORMAL", "C", 01			, 0, "Cond Normal" 		, "Cond Normal"    	, "Cond Normal"    	, "Condicao Normal da Entid"	, "Condicao Normal da Entid"	, "Condicao Normal da Entid"	, "@!"	, ""													, aSX3Copia[02][2]	, ""               				, "", 1	, aSX3Copia[02][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Debito;2=Credito" , "1=Debedora;2=Acreedora"    , "1=Debtor; 2=Creditor"		, "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "09", "CVF_COLUNA", "C", 01			, 0, "Coluna"      		, "Coluna"         	, "Coluna"         	, "Coluna"						, "Coluna"						, "Coluna"						, ""	, ""													, aSX3Copia[03][2]	, "'0'"              			, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", ""	, "" , "", "", "0=Nenhuma;1=Coluna 1;2=Coluna 2;3=Coluna 3;4=Coluna 4;5=Coluna 5;6=Coluna 6"	, "0=Ninguna;1=Columna 1;2=Columna 2;3=Columna 3;4=Columna 4;5=Columna 5;6=Columna 6"	, "0=None;1=Column 1;2=Column 2;3=Column 3;4=Column 4;5=Column 5;6=Column 6", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "10", "CVF_NEGRIT", "L", 01			, 0, "Negrito"      	, "Negrito"        	, "Negrito"        	, "Negrito"						, "Negrito"						, "Negrito"						, ""	, ""													, aSX3Copia[03][2]	, "CTB161SetL(.T.,.F.,.F.,.F.)"	, "", 1	, aSX3Copia[03][3]	, "", "S", "", "N", ""	, "V", "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "11", "CVF_TOTAL" , "L", 01			, 0, "Total Geral"  	, "Total Geral"    	, "Total Geral"    	, "Total Geral"					, "Total Geral"					, "Total Geral"					, ""	, ""													, aSX3Copia[03][2]	, "CTB161SetL(.F.,.T.,.F.,.F.)"	, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", ""	, "V", "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "12", "CVF_SEPARA", "L", 01			, 0, "Sem Valor"  		, "Sem Valor"    	, "Sem Valor"    	, "Linha Sem Valor"				, "Linha Sem Valor"				, "Linha Sem Valor"				, ""	, ""													, aSX3Copia[03][2]	, "CTB161SetL(.F.,.F.,.T.,.F.)"	, "", 1	, aSX3Copia[03][3]	, "", "S", "", "N", ""	, "V", "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "13", "CVF_TRACO" , "L", 01			, 0, "Traco"      		, "Traco"    		, "Traco"    		, "Traco"						, "Traco"						, "Traco"						, ""	, ""													, aSX3Copia[03][2]	, "CTB161SetL(.F.,.F.,.F.,.T.)"	, "", 1	, aSX3Copia[03][3]	, "", "S", "", "N", ""	, "V", "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "14", "CVF_IDENT" , "C", 01			, 0, "Identificad."		, "Identificad."	, "Identificad."	, "Identificador"				, "Identificador"				, "Identificador"				, ""	, ""													, aSX3Copia[01][2]	, ""							, "", 1	, aSX3Copia[01][3]	, "", "" , "", "N", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CVF", "15", "CVF_TOTVIS", "C", 01			, 0, "Resul.Visao?"		, "Resul.Visao?"	, "Resul.Visao?"	, "Resultado da Visao?"			, "Resultado da Visao?"			, "Resultado da Visao?"			, "@!"		, ""		 										, aSX3Copia[03][2]	, "'2'"				, ""			, 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Sim;2=Nao"												, "1=Si;2=No"	, "1=Yes;2=No", "", ""	      , "", "", "", "S"})
aAdd(aSX3,{	"CVF", "16", "CVF_VISENT", "C", 01			, 0, "Vis. Entid.?"		, "Vis. Entid.?"	, "Vis. Entid.?"	, "Visualiza Entidade?"			, "Visualiza Entidade?"			, "Visualiza Entidade?"			, "@!"		, ""		  										, aSX3Copia[03][2]	, "'1'"				, ""			, 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Sim;2=Nao"												, "1=Si;2=No"	, "1=Sim;2=No", "", ""	      , "", "", "", "S"})
aAdd(aSX3,{	"CVF", "17", "CVF_SLDENT", "C", 01			, 0, "Sld. Entid.?"		, "Sld. Entid.?"	, "Sld. Entid.?"	, "Saldo Entidade?"				, "Saldo Entidade?"				, "Saldo Entidade?"				, "@!"		, ""	  											, aSX3Copia[03][2]	, "'1'"				, ""			, 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Processamento;2=Saldo Anterior;3=Saldo Atual;4=Variacao"	, "1=Procesamiento;2=Saldo Anterior;3=Saldo Actual;4=Variacion", "1=Processing;2=Previous Balance;3=Current Balance;4=Variation", "", ""	      , "", "", "", "S"})
aAdd(aSX3,{	"CVF", "18", "CVF_FATSLD", "C", 01			, 0, "Fator Entid?"		, "Fator Entid?"	, "Fator Entid?"	, "Fator Entidade?"				, "Fator Entidade?"				, "Fator Entidade?"				, "@!"		, ""												, aSX3Copia[03][2]	, "'1'"				, ""			, 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Matem;2=Inverte"											, "1=Manut.;2=Invierte"	, "1=Keeps;2=Inverts", "", ""	      , "", "", "", "S"})
aAdd(aSX3,{	"CVF", "19", "CVF_DETHCG", "C", 200			, 0, "Cont. Descr."		, "Cont. Descr."	, "Cont. Descr."  	, "Continuação Descr Ent Ger"	, "Continuação Descr Ent Ger"	, "Continuação Descr Ent Ger"	, "@!S40"	, ""												, aSX3Copia[03][2]	, ""				, ""			, 1	, aSX3Copia[03][3]	, "", "" , "", "S", ""	, "" , "", "", ""																											, "", "", "", "", "","", "", "S"})

// Atualizando CTS (Visao Gerencial)

aAdd(aSX3,{	"CTS", "02", "CTS_CODPLA", "C", 03,  0, "Cod Visao" 	, "Cod Visao"		, "Cod Visao" 		, "Codigo da Visao Gerencial" 	, "Codigo da Visao Gerencial"	, "Codigo da Visao Gerencial"	, "@!"		, ""				, aSX3Copia[04][2]	, ""				, ""			, 1	, aSX3Copia[04][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", "INCLUI"	, "","", "", "S"})
aAdd(aSX3,{	"CTS", "03", "CTS_ORDEM" , "C", 10,  0, "Ordem"       	, "Ordem"	      	, "Ordem"	      	, "Ordem de Exibicao"       	, "Ordem de Exibicao"       	, "Ordem de Exibicao"       	, "@!"		, ""				, aSX3Copia[04][2]	, ""				, ""			, 1	, aSX3Copia[04][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", "INCLUI"	, "","", "", "S"})
aAdd(aSX3,{	"CTS", "04", "CTS_CONTAG", "C", 20,  0, "Entid Gerenc"	, "Entid Gerenc"	, "Entid Gerenc"	, "Entidade Gerencial"       	, "Entidade Gerencial"       	, "Entidade Gerencial"       	, "@!"		, ""				, aSX3Copia[04][2]	, ""				, ""			, 1	, aSX3Copia[04][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", "INCLUI"	, "","", "", "S"})
aAdd(aSX3,{	"CTS", "05", "CTS_CTASUP", "C", 20,  0, "Entid Super" 	, "Entid Super"   	, "Entid Super"   	, "Entidade Superior"			, "Entidade Superior"			, "Entidade Superior"  			, "@!"		, ""				, aSX3Copia[05][2]	, ""				, "CTS001"	, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", ""                       												, ""  , "", "", ""			, "","", "", "S"})
aAdd(aSX3,{	"CTS", "08", "CTS_COLUNA", "N", 01,  0, "Coluna"      	, "Coluna"        	, "Coluna"        	, "Coluna"						, "Coluna"						, "Coluna"						, ""		, ""				, aSX3Copia[05][2]	, "0"          , ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "N", ""	, "" , "", "", "0=Nenhuma;1=Coluna 1;2=Coluna 2;3=Coluna 3;4=Coluna 4;5=Coluna 5;6=Coluna 6"	, "0=Nenhuma;1=Coluna 1;2=Coluna 2;3=Coluna 3;4=Coluna 4;5=Coluna 5;6=Coluna 6"	, "0=Nenhuma;1=Coluna 1;2=Coluna 2;3=Coluna 3;4=Coluna 4;5=Coluna 5;6=Coluna 6", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CTS", "20", "CTS_IDENT" , "C", 01,  0, "Identific." 	, "Identific."   	, "Identific."    	, "Identificador"          		, "Identificador"          		, "Identificador"          		, "@!"		, ""				, aSX3Copia[05][2]	, "'1'"			, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Soma;2=Subtrai;3=Negrito;4=Total Geral e Negrito;5=Linha sem valor;6=Linha sem valor e Negrito;7=Separador"	, "1=Soma;2=Subtrai;3=Negrito;4=Total Geral e Negrito;5=Linha sem valor;6=Linha sem valor e Negrito;7=Separador","1=Soma;2=Subtrai;3=Negrito;4=Total Geral e Negrito;5=Linha sem valor;6=Linha sem valor e Negrito;7=Separador", "","", "", ""      	, "", "S"})
aAdd(aSX3,{	"CTS", "23", "CTS_NOME"  , "C", 40,  0, "Nome Visao" 	, "Nome Visao"    	, "Nome Visao"    	, "Nome da Visao Gerencial"		, "Nome da Visao Gerencial"		, "Nome da Visao Gerencial"		, "@!"		, ""				, aSX3Copia[05][2]	, ""				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", "lTrvNome"	, "","", "", "S"})
aAdd(aSX3,{	"CTS", "24", "CTS_DETHCG", "C", 200, 0, "Cont. Descr."	, "Cont. Descr."  	, "Cont. Descr."  	, "Continuacao Descr Ent Ger"	, "Continuacao Descr Ent Ger"	, "Continuacao Descr Ent Ger"	, "@!S40"	, ""				, aSX3Copia[05][2]	, ""				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", ""																				, ""	, "", "", ""	      , "","", "", "S"})
aAdd(aSX3,{	"CTS", "25", "CTS_TOTVIS", "C",  01, 0, "Resul.Visao?"	, "Resul.Visao?"	, "Resul.Visao?"	, "Resultado da Visao?"			, "Resultado da Visao?"			, "Resultado da Visao?"			, "@!"		, ""				, aSX3Copia[05][2]	, "'2'"				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Sim;2=Nao"																	, "1=Sim;2=Nao"	, "1=Sim;2=Nao", "", ""	      , "","", "", "S"})
aAdd(aSX3,{	"CTS", "26", "CTS_VISENT", "C",  01, 0, "Vis. Entid.?"	, "Vis. Entid.?"	, "Vis. Entid.?"	, "Visualiza Entidade?"			, "Visualiza Entidade?"			, "Visualiza Entidade?"			, "@!"		, ""				, aSX3Copia[05][2]	, "'1'"				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Sim;2=Nao"																	, "1=Sim;2=Nao"	, "1=Sim;2=Nao", "", ""	      , "","", "", "S"})
aAdd(aSX3,{	"CTS", "27", "CTS_SLDENT", "C",  01, 0, "Sld. Entid.?"	, "Sld. Entid.?"	, "Sld. Entid.?"	, "Saldo Entidade?"				, "Saldo Entidade?"				, "Saldo Entidade?"				, "@!"		, ""				, aSX3Copia[05][2]	, "'1'"				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Processamento;2=Saldo Anterior;3=Saldo Atual;4=Variacao"						, "1=Processamento;2=Saldo Anterior;3=Saldo Atual;4=Variacao", "1=Processamento;2=Saldo Anterior;3=Saldo Atual;4=Variacao", "", ""	      ,"", "", "", "S"})
aAdd(aSX3,{	"CTS", "28", "CTS_FATSLD", "C",  01, 0, "Fator Entid?"	, "Fator Entid?"	, "Fator Entid?"	, "Fator Entidade?"				, "Fator Entidade?"				, "Fator Entidade?"				, "@!"		, ""				, aSX3Copia[05][2]	, "'1'"				, ""			, 1	, aSX3Copia[05][3]	, "", "" , "", "S", ""	, "" , "", "", "1=Matem;2=Inverte"																, "1=Mantem;2=Inverte"	, "1=Mantem;2=Inverte", "", ""	      , "","", "", "S"})

//
// Atualizando CVI (Operacoes Vs Seq. Lancamentos)

aAdd(aSX3     ,{    "CVI", "01", "CVI_FILIAL", "C", nTamFilial	, 0, "Filial"		,   "Sucursal    ",   "Branch         ",   "Filial                 ",   "Sucursal            ",   "Branch        "  , "@!"  , ""                        , aSX3Copia[01][2]  , ""                            , "", 1 , aSX3Copia[01][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "","033"	, "", "S"})
aAdd(aSX3     ,{    "CVI", "02", "CVI_GRUPO ", "C", 03			, 0, "Grupo"		,   "Group       ",   "Codigo de Grupo",   "Codigo de Grupo        ",   "Group code          ",   "              "  , "@!"  , ""                        , aSX3Copia[03][2]  , ""                            , "", 1 , aSX3Copia[03][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "",""		, "", "S"})
aAdd(aSX3     ,{    "CVI", "03", "CVI_LANPAD", "C", 03			, 0, "Lan.Padrao"	,   "Asiento est.",   "Stand. Entry   ",   "Lancamento Padrao      ",   "Asiento estandar    ",   "Standard Entry"  , "@!"  , ""                        , aSX3Copia[02][2]  , ""                            , "", 1 , aSX3Copia[02][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "",""		, "", "S"})
aAdd(aSX3     ,{    "CVI", "04", "CVI_OPER  ", "C", 03			, 0, "Operacao"		,   "Operacion   ",   "Operation      ",   "Operacao               ",   "Operacion           ",   "Operation     "  , "@!"  , ""                        , aSX3Copia[02][2]  , ""                            , "", 1 , aSX3Copia[02][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "",""		, "", "S"})
aAdd(aSX3     ,{    "CVI", "05", "CVI_PROCES", "C", 03			, 0, "Processos"	,   "Procesos    ",   "Processes      ",   "Codigo do Processo     ",   "Codigo del proceso  ",   "Process code  "  , "@!"  , ""                        , aSX3Copia[02][2]  , ""                            , "", 1 , aSX3Copia[02][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "",""		, "", "S"})
aAdd(aSX3     ,{    "CVI", "06", "CVI_SEQLAN", "C", 03			, 0, "Seq.Lanc."	,   "Sec. asiento",   "Entry seq.     ",   "Sequencia de Lancamento",   "Secuencia de asiento",   "Entry sequence"  , "@!"  , ""                        , aSX3Copia[02][2]  , ""                            , "", 1 , aSX3Copia[02][3]  , "", "" , "", "", "" , "" , "", "", ""                                                                              , ""    , "", "", ""                , "",""		, "", "S"})

//
// Atualizando CVJ (Processos)

aAdd(aSX3     ,{	"CVJ", "01", "CVJ_FILIAL", "C", nTamFilial	, 0, "Filial   ",   "Sucursal   ",   "Branch     ",   "Filial          ",   "Sucursal         ",   "Branch     ", "@!"  , ""									, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "N", ""	, "" , "", "", ""																			, ""	, "", "", ""				, "","033"	, "", "S"})
aAdd(aSX3     ,{	"CVJ", "02", "CVJ_MODULO", "C", 02			, 0, "Modulo   ",   "Modulo     ",   "Module     ",   "Codigo do Modulo",   "Codigo del Modulo",   "Module code", "@!"	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "",""		, "", "S"})
aAdd(aSX3     ,{	"CVJ", "03", "CVJ_PROCES", "C", 03			, 0, "Processo ",   "Proceso    ",   "Process    ",   "Processo        ",   "Proceso          ",   "Process    ", "@!"	, "ExistChav('CVJ', M->CVJ_PROCES)"	, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "",""		, "", "S"})
aAdd(aSX3     ,{	"CVJ", "04", "CVJ_DESCRI", "C", 40			, 0, "Descricao",   "Descripcion",   "Description",   "Descricao       ",   "Descripcion      ",   "Description", "@!"	, ""		                		, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "",""		, "", "S"})

//
// Atualizando CVG (Operacoes)

aAdd(aSX3     ,{	"CVG", "01", "CVG_FILIAL", "C", nTamFilial	, 0, "Filial",          "Sucursal",        "Branch",            "Filial",                   "Sucursal",                "Branch"     		, "@!"  , ""						, aSX3Copia[01][2]	, ""    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","033", "", "S"})
aAdd(aSX3     ,{	"CVG", "02", "CVG_PROCES", "C", 03			, 0, "Processo",        "Proceso",         "Process",           "Processo",                 "Proceso",                 "Process"    		, "@!"	, ""						, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CVG", "03", "CVG_OPER"	 , "C", 03			, 0, "Operacao",        "Operacion",       "Operation",         "Operacao",                 "Operacion",               "Operation"   	, "@!"	, "IsAlpha(M->CVG_OPER)"	, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CVG", "04", "CVG_DESCRI", "C", 40			, 0, "Descricao",       "Descripcion",     "Description",       "Descricao",                "Descripcion",             "Description"		, "@!"	, ""		                , aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})

//
// Atualizando a tabela (CVA) criar amarracao entre o lancamento padrao e seu respectivo modulo
aAdd(aSX3     ,{	"CVA", ProxSX3("CVA","CVA_MODULO"), "CVA_MODULO", "C", 02, 0, "Modulo   ",   "Modulo     ",   "Module     ",   "Codigo do Modulo" ,   "Codigo del Modulo",   "Module code", "@!"	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CVA", ProxSX3("CVA","CVA_PROCES"), "CVA_PROCES", "C", 03, 0, "Processo ",   "Proceso    ",   "Process    ",   "Processo        " ,   "Proceso          ",   "Process    ", "@!"	, ""								, aSX3Copia[02][2]	, ""							, "", 1	, aSX3Copia[02][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3     ,{	"CVA", ProxSX3("CVA","CVA_OPER")  , "CVA_OPER  ", "C", 03, 0, "Operacao ",   "Operacion  ",   "Operation  ",   "Operacao         ",   "Operacion        ",   "Operation  ", "@!"	, ""								, aSX3Copia[02][2]	, ""							, "CVG", 1	, aSX3Copia[02][3]	, "", "" , "", "",  ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S",.T.})

//
// Inclusao da tabela CVO - Fila de Saldos 2

aAdd(aSX3     ,{	"CVO", "01", "CVO_FILIAL"	, "C", nTamFilial	, 0, "Filial"		, "Filial"		, "Filial"			, "Filial"			, "Filial"			, "Filial"			, "@!"	, ""								, aSX3Copia[01][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", ""	, "" 	, "", "", ""	, ""	, "", "", ""				, "", "033"	,"","S"})
aAdd(aSX3     ,{	"CVO", "02", "CVO_DATA"		, "D", 08			, 0, "Data"			, "Data"		, "Data"			, "Data"			, "Data"			, "Data"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "V"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "03", "CVO_LOTE"		, "C", 06			, 0, "Lote"			, "Lote"		, "Lote"			, "Lote"			, "Lote"			, "Lote"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "04", "CVO_SBLOTE"	, "C", 03			, 0, "Sub Lote"		, "Sub Lote"	, "Sub Lote"		, "Sub Lote"		, "Sub Lote"		, "Sub Lote"		, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "05", "CVO_DOC"		, "C", 06			, 0, "Documento"	, "Documento"	, "Documento"		, "Documento"		, "Documento"		, "Documento"		, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "06", "CVO_OPCR"		, "C", 01			, 0, "Opcao"		, "Opcao"		, "Opcao"			, "Opcao"			, "Opcao"			, "Opcao"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "V"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "07", "CVO_MOEDA"	, "C", 02			, 0, "Moeda"		, "Moeda"		, "Moeda"			, "Moeda"			, "Moeda"			, "Moeda"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "08", "CVO_SOMA"		, "C", 01			, 0, "Soma"			, "Soma"		, "Soma"			, "Soma"			, "Soma"			, "Soma"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "09", "CVO_LINHA"	, "C", 03			, 0, "Linha"		, "Linha"		, "Linha"			, "Linha"			, "Linha"			, "Linha"			, "@!"	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "10", "CVO_FLAG"		, "C", 01			, 0, "Flag"			, "Flag"		, "Flag"			, "Flag"			, "Flag"			, "Flag"			, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "V"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "11", "CVO_FKINUS"	, "C", 01			, 0, "FK em uso"	, "FK em uso"	, "FK em uso"		, "FK em uso"		, "FK em uso"		, "FK em uso"		, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "12", "CVO_TPSLDA"	, "C", 01			, 0, "Tipo Saldo"	, "Tipo Saldo"	, "Tipo Saldo"		, "Tipo de Saldo"	, "Tipo de Saldo"	, "Tipo de Saldo"	, ""	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", ""	,"","S"})
aAdd(aSX3     ,{	"CVO", "13", "CVO_CODFIL"	, "C", nTamFilial	, 0, "Filial"		, "Filial"		, "Filial"			, "Filial"			, "Filial"			, "Filial"			, "@!"	, ""								, aSX3Copia[01][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", ""	, "" 	, "", "", ""	, ""	, "", "", ""				, "", "033"	,"","S"})

// Historico Aglutinado CTB
Aadd(aSX3     ,{	"CTB", "25", "CTB_HAGLUT"   , "C", 99, 0, "Hist. Aglut."  , "Hist. Agrup."   , "Group. Hist."  , "Historico Aglutinado"      , "Historial Agrupado"        , "Grouped History"	         , "@S40"     , "Vazio() .Or. Ctb240Form('C')"                             , aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "A", "R", "", ""	, ""					, ""					, ""					, "", "", "", ""   , "", "S"})

// Alteracao X3_RESERV  para o campo CTK_HIST
aAdd(aSX3,{	"CTK", "12", "CTK_HIST"	, "C", nCTKHist, 0, "Historico"	, "Historial"	, "History", "Historico Lancamento", "Historial Asiento", "Entry History"	, "@!"	, ""								, aSX3Copia[03][2]	, ""							, "", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" 	, "", "", ""	, ""	, "", "", ""				, "", "","","S"})

//
// Atualizacao da tabela CTL, inclusao de campos para o relatorio de auditoria, conhecido como Quadratura Contabil
aAdd(aSX3,{	"CTL", ProxSX3("CTL","CTL_QCDATA"), "CTL_QCDATA", "C", 010, 0, "Campo Data"	, "Campo Fecha"	, "Date field"	, "Campo para Data",   "Campo para la Fecha",   "Field to Date", "@!"	, "" , aSX3Copia[03][2]	, "" , "", 1	, aSX3Copia[03][3]	, "", "" , "", "N",  "A"	, "R" , "", "", "" , ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CTL", ProxSX3("CTL","CTL_QCDOC"), "CTL_QCDOC ", "C", 255, 0, "Campo Doc."	, "Campo Doc."	, "Doc Field"	, "Campo para o Documento", "Campo para el Documento","Field to Document", "@!"	, "" , aSX3Copia[03][2]	, "" , "", 1	, aSX3Copia[03][3]	, "", "" , "", "N",  "A"	, "R" , "", "", "" , ""	, "", "", ""				, "","", "", "S",.T.})
aAdd(aSX3,{	"CTL", ProxSX3("CTL","CTL_QCMOED"), "CTL_QCMOED", "C", 10, 0, "Campo Moeda"	,   "Campo Moneda",   "Currency Fld",   "Campo para a moeda       ",   "Campo para la moneda",   "Field to Currency", "@!"	, "" , aSX3Copia[03][2]	, "" , "", 1	, aSX3Copia[03][3]	, "", "" , "", "N",  "A"	, "R" , "", "", "" , ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CTL", ProxSX3("CTL","CTL_QCVLRD"), "CTL_QCVLRD", "C", 10, 0, "Campo Valor"	,   "Campo Valor",   "Value field",   "Campo para o valor",   "Campo para el valor",   "Field to Value", "@!"	, "" , aSX3Copia[03][2]	, "" , "", 1	, aSX3Copia[03][3]	, "", "" , "", "N",  "A"	, "R" , "", "", "" , ""	, "", "", ""				, "","", "", "S"})
aAdd(aSX3,{	"CTL", ProxSX3("CTL","CTL_QCCORR"), "CTL_QCCORR", "C", 10, 0, "Campo Correl"	,   "Campo Correl",   "Correl.Field",   "Campo para o correlativo",   "Campo para el correlativo",   "Field to Correlative", "@!"	, "" , aSX3Copia[03][2]	, "" , "", 1	, aSX3Copia[03][3]	, "", "" , "", "N",  "A"	, "R" , "", "", "" , ""	, "", "", ""				, "","", "", "S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos utilizadas para o Novo SPED Contabil			 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSx3 , {"CS0","01","CS0_FILIAL","C" ,    nTamFilial	, 0,"Filial" 			, "Sucursal"		, "Branch"			,"Filial do Sistema"				,"Sucursal"							,"Branch of the System"				,"@!","" ,"€€€€€€€€€€€€€€€" ,"","",1 ,                   "","" ,""	 ,"", "S", "" , "R"  ,"","","","","","","","","033"	,"","S" ,.T.})
aAdd( aSx3 , {'CS0','02','CS0_CODREV','C' ,    6			, 0,'Cod. Revisao' 		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','03','CS0_CODEMP','C' ,    2			, 0,'Cod. Empresa' 		,'Cod. Empresa'		,'Cod. Empresa'		,'Codigo da Empresa'				,'Codigo da Empresa'				,'Codigo da Empresa'				,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','04','CS0_CODFIL','C' ,    nTamFilial	, 0,'Cod. Filial' 		,'Cod. Filial'		,'Cod. Filial'		,'Codigo da Filial	'				,'Codigo da Filial'					,'Codigo da Filial'					,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","033"	,"","S" ,.T.})
aAdd( aSx3 , {'CS0','05','CS0_NUMLIV','C' ,    6			, 0,'Num Livro'			,'Num Livro'		,'Num Livro'		,'Numero do Livro'					,'Numero do Livro'					,'Numero do Livro'					,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','06','CS0_REVSUP','C' ,    6			, 0,'Rev. Sup.' 		,'Rev. Sup.'		,'Rev. Sup.'		,'Rev. Superior'					,'Rev. Superior'					,'Rev. Superior'					,''	 ,'' ,aSX3Copia[01,2]	,"","",0 , aSX3Copia[01,3]		,"" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S",.T.})
aAdd( aSx3 , {'CS0','07','CS0_REVCAD','C' ,    6			, 0,'Rev. Cadastral' 	,'Rev. Cadastral'	,'Rev. Cadastral'	,'Rev. Cadastral'					,'Rev. Cadastral'					,'Rev. Cadastral'					,''	 ,'' ,aSX3Copia[01,2]	,"","",0 , aSX3Copia[01,3]		,"" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S",.T. })
aAdd( aSx3 , {'CS0','08','CS0_TPESC' ,'C' ,    1			, 0,'Tipo Escritur'		,'Tipo Escritu' 	,'Tipo Escritu'		,'Tipo de Escrituração'				,'Tipo de Escrituração'				,'Tipo de Escrituração' 			,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","1=Com Centralização;2=Sem Centralização","","","","","",""		,"","S",.T.})
aAdd( aSx3 , {'CS0','09','CS0_CONSLD','L' ,    1			, 0,'Consolidado'  		,'Consolidado'		,'Consolidado'		,'Consolidadora'	    			,'Consolidadora'					,'Consolidadora'					,''	 ,'' ,aSX3Copia[01,2]	,"","",0 , aSX3Copia[01,3]		,"" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S",.T.})
aAdd( aSx3 , {'CS0','10','CS0_USER'  ,'C' ,  250			, 0,'Usuario'			,'Usuario'			,'Usuario'			,'Usuario'							,'Usuario'							,'Usuario'							,""  ,"" ,"€€€€€€€€€€€€€€€" ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','11','CS0_UPDATE','D' ,    8			, 0,'Dt Atualizac'		,'Dt Atualizac'		,'Dt Atualizac'		,'Data de Atualizacao'				,'Data de Atualizacao'				,'Data de Atualizacao'				,""  ,"" ,"€€€€€€€€€€€€€€€" ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','12','CS0_DTINI' ,'D' ,    8			, 0,'Dt Ini ECD'		,'Dt Ini ECD'		,'Dt Ini ECD'		,'Data de Inicio da Escrituração'	,'Data de Inicio da Escrituração'	,'Data de Inicio da Escrituração'	,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','13','CS0_DTFIM' ,'D' ,    8			, 0,'Dt Fim ECD'		,'Dt Fim ECD'		,'Dt Fim ECD'		,'Data de Fim da Escrituração'		,'Data de Fim da Escrituração'		,'Data de Fim da Escrituração'		,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','14','CS0_NATLIV','C' ,   80			, 0,'Nat. do Livro'		,'Nat. do Livro'	,'Nat. do Livro'	,'Nat. do Livro'					,'Nat. do Livro'					,'Nat. do Livro'					,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS0','15','CS0_TIPLIV','C' ,    1			, 0,'Tipo do Livro'		,'Tipo do Livro'	,'Tipo do Livro'	,'Tipo do Livro'					,'Tipo do Livro'					,'Tipo do Livro'					,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","G=Geral;R=Diário Resumido;A=Diário Auxiliar;B=Balancete Diário;Z=Razão Auxiliar;F=FCONT","G=Geral;R=Diário Resumido;A=Diário Auxiliar;B=Balancete Diário;Z=Razão Auxiliar;F=FCONT","G=Geral;R=Diário Resumido;A=Diário Auxiliar;B=Balancete Diário;Z=Razão Auxiliar;F=FCONT","","","",""		,"","S",.T. })
aAdd( aSx3 , {'CS0','16','CS0_ECDREV','C' ,    3			, 0,'Tipo da ECD' 		,'Tipo da ECD'		,'Tipo da ECD'		,'Tipo da ECD'						,'Tipo da ECD'						,'Tipo da ECD'						,''	 ,'' ,aSX3Copia[01,2]	,"","",0 , aSX3Copia[01,3]		,"" ,""	 ,'', 'S', 'A', 'R'  ,"","","ECD=SPED;FCO=FCONT","ECD=SPED;FCO=FCONT","ECD=SPED;FCO=FCONT","","","",""		,"","S",.T. })
aAdd( aSx3 , {'CS0','17','CS0_SITPER','C' ,    1			, 0,'Ind.Inic.Per' 		,'Ind.Inic.Per'		,'Ind.Inic.Per'		,'Indicador Inicio de Periodo'		,'Indicador Inicio de Periodo'		,'Indicador Inicio de Periodo'		,''	 ,'' ,'€€€€€€€€€€€€€€ '	,"","",0 , 					  ""	,"" ,""	 ,'', 'S', 'A', 'R'  ,"","","0=Inicio do Ano;1=Abertura;2=Res.Cisao/Fusao;3=Inicio Obrigatoriedade","0=Inicio do Ano;1=Abertura;2=Res.Cisao/Fusao;3=Inicio Obrigatoriedade","0=Inicio do Ano;1=Abertura;2=Res.Cisao/Fusao;3=Inicio Obrigatoriedade","","","",""		,"","S",.T. })
//LEIAUTE 2 DA ECD
aAdd( aSx3 , {'CS0','18','CS0_LEIAUT','C' ,    10			, 0,'Leiaute'			,'Leiaute'			,'Leiaute'			,'Leiaute'							,'Leiaute'							,'Leiaute'							,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" })
aAdd( aSx3 , {'CS0','19','CS0_INNIRE','C' ,    1			, 0,'Ind.NIRE' 			,'Ind.NIRE'			,'Ind.NIRE'			,'Indicador NIRE'					,'Indicador NIRE'					,'Indicador NIRE'					,''	 ,'Vazio .Or. Pertence("01")'   ,'€€€€€€€€€€€€€€ '	,"","",0 , 					  "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","0=Empresa sem NIRE;1=Empresa possui NIRE","0=Empresa sem NIRE;1=Empresa possui NIRE","0=Empresa sem NIRE;1=Empresa possui NIRE","","","",""		,"","S"})
aAdd( aSx3 , {'CS0','20','CS0_FINESC','C' ,    1			, 0,'Fin.Escritur' 		,'Fin.Escritur'		,'Fin.Escritur'		,'Finalidade Escrituracao'			,'Finalidade Escrituracao'			,'Finalidade Escrituracao'			,''	 ,'Vazio .Or. Pertence("0123")' ,'€€€€€€€€€€€€€€ '	,"","",0 , 					  "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","0=Original;1=Substit.com NIRE;2=Substit.sem NIRE;3=Substit.com troca NIRE","0=Original;1=Substit.com NIRE;2=Substit.sem NIRE;3=Substit.com troca NIRE","0=Original;1=Substit.com NIRE;2=Substit.sem NIRE;3=Substit.com troca NIRE","","","",""		,"","S"})
aAdd( aSx3 , {'CS0','21','CS0_HASHSB','C' ,   80			, 0,'Cd.Hash Sb'		,'Cd.Hash Sb'		,'Cd.Hash Sb'		,'Hash Escrit.substituida'			,'Hash Escrit.substituida'			,'Hash Escrit.substituida'			,''	 ,'' ,'€€€€€€€€€€€€€€ ' ,''	,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" })
aAdd( aSx3 , {'CS0','22','CS0_NIRESB','C' ,   11			, 0,'NIRE Subst.'		,'NIRE Subst.'		,'NIRE Subst.'		,'NIRE Subst.'						,'NIRE Subst.'						,'NIRE Subst.'						,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" })
aAdd( aSx3 , {'CS0','23','CS0_DATALP','D' ,    8			, 0,'Dt Ap LP'			,'Dt Ap LP'			,'Dt Ap LP'			,'Data de Apuracao Lucro/Perdas'	,'Data de Apuracao Lucro/Perdas'	,'Data de Apuracao Lucro/Perdas'	,""  ,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" })
aAdd( aSx3 , {"CS1","01","CS1_FILIAL","C" ,    nTamFilial	, 0,"Filial" 			, "Sucursal"		, "Branch"			,"Filial do Sistema"	,"Sucursal"				,"Branch of the System"	,"@!"			,"" 				,"€€€€€€€€€€€€€€€" ,""		,"",1 ,                   "","" ,""	 ,"", "S", "" , "R"  ,"","","","","","","","","033","","S" ,.T.})
aAdd( aSx3 , {'CS1','02','CS1_CODREV','C' ,    6			, 0,'Cod. Revisao' 		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'	,'Codigo da Revisao'	,'Codigo da Revisao'	,''	 			,'' 				,'€€€€€€€€€€€€€€ ' ,''		,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" ,.T.})
aAdd( aSx3 , {'CS1','03','CS1_NUMLIN','C' ,   04			, 0,'Linha'				,'Linha'			,'Linha'			,'Linha'				,'Linha'				,'Linha'				,''	 			,'' 				,'€€€€€€€€€€€€€€ ' ,''		,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" ,.T.})
aAdd( aSx3 , {'CS1','04','CS1_NUMLIV','C' ,    6			, 0,'Num do Livro'		,'Num do Livro'		,'Num do Livro'		,'Numero do Livro'		,'Numero do Livro'		,'Numero do Livro'		,'@R 999999'	,'' 				,'€€€€€€€€€€€€€€ ' ,''		,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" ,.T.})
aAdd( aSx3 , {'CS1','05','CS1_TIPAUX','C' ,   01			, 0,'Tipo Auxiliar'		,'Tipo Auxiliar'	,'Tipo Auxiliar'	,'Tipo Auxiliar'		,'Tipo Auxiliar'		,'Tipo Auxiliar'		,''	 			,'Pertence("01")' 	,'€€€€€€€€€€€€€€ ' ,"'0'"	,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","0=Digital;1=Outros","0=Digital;1=Outros","0=Digital;1=Outros","","","","","","S" ,.T.})
aAdd( aSx3 , {'CS1','06','CS1_NATLIV','C' ,   80			, 0,'Nat. do Livro'		,'Nat. do Livro'	,'Nat. do Livro'	,'Nat. do Livro'		,'Nat. do Livro'		,'Nat. do Livro'		,''	 			,'' 				,'€€€€€€€€€€€€€€ ' ,''		,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" ,.T.})
aAdd( aSx3 , {'CS1','07','CS1_CODHAS','C' ,   80			, 0,'Cod. Hash'			,'Cod. Hash'		,'Cod. Hash'		,'Cod. Hash'			,'Cod. Hash'			,'Cod. Hash'			,''	 			,'' 				,'€€€€€€€€€€€€€€ ' ,''		,'',0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","","","","S" ,.T.})

aAdd( aSx3 , {'CS2','01','CS2_FILIAL','C' ,    nTamFilial	, 0,'Filial'       		,'Sucursal'     	,'Branch'     		,'Filial do Sistema'  				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  "","" ,""  ,'', 'S',  "", "R"  ,"","","","","","","","","033"	,"","S" ,.T.})
aAdd( aSx3 , {'CS2','02','CS2_CODREV','C' ,		6			, 0,'Cod. Revisao' 		,'Cod. Revisao' 	,'Cod. Revisao' 	,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,""	 	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,					  "","" ,""  ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','03','CS2_CODEMP','C' ,		2			, 0,'Cod. Empresa' 		,'Cod. Empresa' 	,'Cod. Empresa' 	,'Codigo da Empresa'				,'Codigo da Empresa'				,'Codigo da Empresa'				,''		, '','€€€€€€€€€€€€€€ ' ,'','',0 ,					  "", "",""  ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','04','CS2_CODFIL','C' ,    nTamFilial	, 0,'Cod. Filial'		,'Cod. Filial'		,'Cod. Filial'  	,'Codigo da Filial'					,'Codigo da Filial'					,'Codigo da Filial'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'', 'S', 'A', 'R'  ,'','','','','','','','',"033"	,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','05','CS2_NOMEEM','C' ,	  250			, 0,'Nome Empresa' 		,'Nome Empresa' 	,'Nome Empresa' 	,'Nome da Empresa'					,'Nome da Empresa'					,'Nome da Empresa'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','06','CS2_CNPJ'  ,'C' ,   14			, 0,'CNPJ'				,'CNPJ'				,'CNPJ'				,'CNPJ'								,'CNPJ'								,'CNPJ'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','07','CS2_UF'	  ,'C' ,	2			, 0,'UF'				,'UF'				,'UF'				,'UF'								,'UF'								,'UF'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','08','CS2_IE'	  ,'C' ,   20			, 0,'Insc. Estadu' 		,'Insc. Estadu'		,'Insc. Estadu' 	,'Inscricao Estadual'				,'Inscricao Estadual'				,'Inscricao Estadual'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','09','CS2_IM'	  ,'C' ,   20			, 0,'Insc. Munici' 		,'Insc. Munici'		,'Insc. Munici' 	,'Inscricao Municipal'				,'Inscricao Municipal'				,'Inscricao Municipal'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','10','CS2_CODMUN','C'  ,  10			, 0,'Codigo Munic'	 	,'Codigo Munic'		,'Codigo Munic'		,'Codigo do Municipio'				,'Codigo do Municipio'				,'Codigo do Municipio'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','11','CS2_NOMFIL','C' ,  250 			,0 ,'Nome Filial'	 	,'Nome Filial' 		,'Nome Filial'		,'Nome da Filial'					,'Nome da Filial'					,'Nome da Filial'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','12','CS2_DESCMUN','C',  250 			,0 ,'Municipio'	 		,'Municipio' 		,'Municipio'		,'Municipio'						,'Municipio'						,'Municipio'						,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'' ,''  ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS2','13','CS2_SITESP','C' ,    1			, 0,'Ind Sit Esp'		,'Ind Sit Esp'		,'Ind Sit Esp'		,'Indicador de Situação Especial'	,'Indicador de Situação Especial'	,'Indicador de Situação Especial'	,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','14','CS2_ENTREF','C' ,    2			, 0,'Entidade Ref'		,'Entidade Ref'		,'Entidade Ref'		,'Entidade da Incricao'				,'Entidade da Incricao'				,'Entidade da Incricao'				,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','15','CS2_INSCR','C' ,   250			, 0,'Inscrição'			,'Inscrição'		,'Inscrição'		,'Inscrição na entidade'			,'Inscrição na entidade'			,'Inscrição na entidade'			,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','16','CS2_NIRE' ,'C' ,   011			, 0,'NIRE'				,'NIRE'				,'NIRE'				,'NIRE'								,'NIRE'								,'NIRE'								,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS2','13','CS2_DTNIRE','D' ,   08			, 0,'Data Nire'			,'Data Nire'		,'Data Nire'		,'Data Nire'						,'Data Nire'						,'Data Nire'						,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'', 'S', 'A', 'R'  ,"","","","","","","","",""		,"","S" ,.T.})

aAdd( aSx3 , {'CS3','01','CS3_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  "",'',''	 ,'','S' ,''  ,''	   ,'','','','','','','','',"033"	,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','02','CS3_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','03','CS3_CONTA' ,'C'	,30	 			,0 ,'CONTA'				,'CONTA'			,'CONTA'			,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','04','CS3_DTALT' ,'D'	,8	 			,0 ,'DT ALTER.'			,'DT ALTER.'		,'DT ALTER.'		,'Data de Alt. ou Inc'				,'Data de Alt. ou Inc'				,'Data de Alt. ou Inc'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','05','CS3_CODNAT','C'	,2	 			,0 ,'Cod Natureza' 		,'Cod Natureza'		,'Cod Natureza'		,'Codigo da Natureza'				,'Codigo da Natureza'				,'Codigo da Natureza'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','06','CS3_INDCTA','C'	,1	 			,0 ,'Ind. Conta'		,'Ind. Conta'		,'Ind. Conta'		,'Indicador da Conta'				,'Indicador da Conta'				,'Indicador da Conta'				,''	 	,'' ,'€€€€€€€€€€€€€€ '	,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','07','CS3_NIVEL' ,'N'	,2	 			,0 ,'Nivel Cta.'		,'Nivel Cta.'		,'Nivel Cta.'		,'Nivel da Conta'					,'Nivel da Conta'					,'Nivel da Conta'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','08','CS3_CTASUP','C'	,30	 			,0 ,'Cta. Sup'			,'Cta. Sup'			,'Cta. Sup'			,'Cod.da Conta Superior'			,'Cod.da Conta Superior'			,'Cod.da Conta Superior'			,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','09','CS3_NOMECT','C'	,50	 			,0 ,'Nome Conta'		,'Nome Conta'		,'Nome Conta'		,'Nome da Conta'					,'Nome da Conta'					,'Nome da Conta'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS3','10','CS3_CTASIN','C'	,01	 			,0 ,'Cta Sint ECD'		,'Cta Sint ECD'		,'Cta Sint ECD'		,'Conta Sintetica para SPED'		,'Conta Sintetica para SPED'		,'Conta Sintetica para SPED'		,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','','','','','','',''		,'',"S" ,.T.})

aAdd( aSx3 , {'CS4','01','CS4_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  "",'',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','02','CS4_CODREV','C' 	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','03','CS4_CONTA' ,'C'	,30	 			,0 ,'Cod Conta'			,'Cod Conta'		,'Cod Conta'		,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','04','CS4_CTAREF','C'	,30	 			,0 ,'Cta. Ref.'			,'Cta. Ref.'		,'Cta. Ref.'		,'Conta Referencial'				,'Conta Referencial'				,'Conta Referencial'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','05','CS4_CCUSTO','C'	,30	 			,0 ,'C. Custo'			,'C. Custo'			,'C. Custo'			,'Centro de Custo'					,'Centro de Custo'					,'Centro de Custo'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','06','CS4_ENTREF','C'	,10	 			,0 ,'Ent. Referen'		,'Ent. Referen'		,'Ent. Referen'		,'Entidade Referencial'				,'Entidade Referencial'				,'Entidade Referencial'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CS4','07','CS4_TPUTIL','C'	,01	 			,0 ,"Tp.Utiliz."		,'Tp.Utiliz.'		,'Tp.Utiliz.'		,'Tipo de Utilizacao FCONT'			,'Tipo de Utilizacao FCONT'			,'Tipo de Utilizacao FCONT'			,'@!' 	,"Pertence('F,S,A, ')" ,aSX3Copia[02,2] ,'','',0 ,aSX3Copia[02,3],'',''	 ,'','S' ,'A' ,'R'	   ,'','','F=Fiscal;S=Societario;A=Ambos','F=Fiscal;S=Societario;A=Ambos','F=Fiscal;S=Societario;A=Ambos','','','',''		,'',"S" ,.T.})

aAdd( aSx3 , {'CS5','01','CS5_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  "",'',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'','S' ,.T.})
aAdd( aSx3 , {'CS5','02','CS5_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS5','03','CS5_CUSTO' ,'C'	,30	 			,0 ,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod.do C. de Custo'				,'Cod.do C. de Custo'				,'Cod.do C. de Custo'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS5','04','CS5_DTALT' ,'D'	,8	 			,0 ,'Dt. Alter;'		,'Dt. Alter;'		,'Dt. Alter;'		,'Data de Alt. Incl.'				,'Data de Alt. Incl.'				,'Data de Alt. Incl.'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS5','05','CS5_NOME'	  ,'C'	,250 			,0 ,'Nome'				,'Nome'				,'Nome'				,'Nome do C. Custo'					,'Nome do C. Custo'					,'Nome do C. Custo'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})

aAdd( aSx3 , {'CS6','01','CS6_FILIAL','C'	,nTamFilial	 	,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  '','',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'','S' ,.T.})
aAdd( aSx3 , {'CS6','02','CS6_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS6','03','CS6_CONTA' ,'C'	,30	 			,0 ,'Cod Conta'			,'Cod Conta'		,'Cod Conta'		,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS6','04','CS6_CCUSTO','C'	,30				,0 ,'Cod. C. Cust'		,'Cod. C. Cust'		,'Cod. C. Cust'		,'Cod.do C. de Custo'				,'Cod.do C. de Custo'				,'Cod.do C. de Custo'				,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS6','05','CS6_CODAGL','C'	,30	 			,0 ,'Cod Agultina'		,'Cod Agultina'		,'Cod Agultina'		,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS6','06','CS6_AGLSUP','C'	,20	 			,0 ,'Agl. Superio'		,'Agl. Superio'		,'Agl. Superio'		,'Agl. Superior'					,'Agl. Superior'					,'Agl. Superior'					,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS6','07','CS6_CODNAT','C'	,2	 			,0	,'Cod. Naturez'		,'Cod. Naturez'		,'Cod. Naturez'		,'Codigo da Natureza'				,'Codigo da Natureza'				,'Codigo da Natureza'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})


aAdd( aSx3 , {'CS7','01','CS7_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System' 			,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  '','',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'','S' ,.T.})
aAdd( aSx3 , {'CS7','02','CS7_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ '	,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS7','03','CS7_CODHIS','C'	,30	 			,0 ,'Cod. Hist'			,'Cod. Hist'		,'Cod. Hist'		,'Código do Histórico'				,'Código do Histórico'				,'Código do Histórico'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS7','04','CS7_DESCRI','C'	,250 			,0 ,'Descricao'			,'Descricao'		,'Descricao'		,'Descrcao'							,'Descrcao'							,'Descrcao'							,''	 	,'' ,'€€€€€€€€€€€€€€ '	,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})

aAdd( aSx3 , {'CS8','01','CS8_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  '','',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'','S' ,.T.})
aAdd( aSx3 , {'CS8','02','CS8_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','03','CS8_CODSIG','C'	,30	 			,0 ,'Cod. Signat'		,'Cod. Signat'		,'Cod. Signat'		,'Codigo Signatario'				,'Codigo Signatario'				,'Codigo Signatario'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','04','CS8_NOME'	  ,'C'	,250 			,0 ,'Nome Signat'		,'Nome Signat'		,'Nome Signat'		,'Nome do Signatario'				,'Nome do Signatario'				,'Nome do Signatario'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','05','CS8_QUALIF','C'	,50	 			,0	,'Qualificacao'		,'Qualificacao'		,'Qualificacao'		,'Qualificacao'						,'Qualificacao'						,'Qualificacao'						,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','06','CS8_CODASS','C'	,3	 			,0 ,'Cod. Assinan'		,'Cod. Assinan'		,'Cod. Assinan'		,'Codigo do Assinante'				,'Codigo do Assinante'				,'Codigo do Assinante'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','07','CS8_CPF'	  ,'C'	,14	 			,0 ,'Inscr. CPF'		,'Inscr. CPF'		,'Inscr. CPF'		,'CPF'								,'CPF'								,'CPF'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS8','08','CS8_CRC'	  ,'C'	,30	 			,0 ,'CRC'				,'CRC'				,'CRC'				,'CRC'								,'CRC'								,'CRC'								,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSX3,  {'CS8','09','CS8_CGC'	  ,'C'  ,14				,0	,'CNPJ'        		,'CNPJ'				,'CNPJ'				,'CNPJ do escritório'				,'CNPJ do escritório'				,'Accountant s Office CGC'			,'@R 99.999.999/9999-99',''		,'€€€€€€€€€€€€€€ ','','',1,  ''	,'',''	 ,'','N' ,'A'	,'R'	,'','','','',''	,'','','',''		,'','S'	})
//leiaute 2 ECD
aAdd(aSX3 , {"CS8","10","CS8_UFCRC"	  ,"C",02				,0	,"Estado CRC"   	,"Estado CRC"		,"Estado CRC"		,"Estado CRC"						,"Estado CRC"						,"Estado CRC"						,"@!"					,'ExistCpo("SX5","12"+M->CS8_UFCRC)'							,"€€€€€€€€€€€€€€ "	,"","12"	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3 , {"CS8","11","CS8_SEQCRC" ,"C",11				,0	,"Seq.CRC"     		,"Seq.CRC"			,"Seq.CRC"			,"Seq.CRC"							,"Seq.CRC"							,"Seq.CRC"							,""        				,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3 , {"CS8","12","CS8_DTCRC"  ,"D",08				,0	,"Data CRC"			,"Data CRC"			,"Data CRC"			,"Data CRC"							,"Data CRC"							,"Data CRC"							,""						,""																,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"})
aAdd(aSX3 , {"CS8","13","CS8_EMAIL"  ,"C",60				,0	,"Email"     		,"Email"			,"Email"			,"Email"							,"Email"							,"Email"							,""        				,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3 , {"CS8","14","CS8_FONE"   ,"C",11				,0	,"Telefone"    		,"Telefone"			,"Telefone"			,"Telefone"							,"Telefone"							,"Telefone"							,""        				,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd( aSx3 , {'CS9','01','CS9_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'' ,'€€€€€€€€€€€€€€€' ,'','',1 ,					  '','',''	 ,'','S' ,''	,''		,'','','','','','','','',"033"	,'','S' ,.T.})
aAdd( aSx3 , {'CS9','02','CS9_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','03','CS9_CODPAR','C'	,30	 			,0 ,'Cod. Partiti'		,'Cod. Partiti'		,'Cod. Partiti'		,'Codigo Participante'				,'Codigo Participante'				,'Codigo Participante'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','04','CS9_NOME'	  ,'C'	,250 			,0 ,'NOME'				,'NOME'				,'NOME'				,'Nome do Participante'				,'Nome do Participante'				,'Nome do Participante'				,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','05','CS9_CODPAI','C'	,5	 			,0 ,'CODIGO PAIS'		,'CODIGO PAIS'		,'CODIGO PAIS'		,'Codigo do Pais'					,'Codigo do Pais'					,'Codigo do Pais'					,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','06','CS9_CNPJ'	  ,'C'	,14	 			,0 ,'CNPJ'				,'CNPJ'				,'CNPJ'				,'CNPJ'								,'CNPJ'								,'CNPJ'								,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','07','CS9_CPF'	  ,'C'	,14	 			,0 ,'CPF'				,'CPF'				,'CPF'				,'CPF'								,'CPF'								,'CPF'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','08','CS9_NIT'	  ,'C'	,11	 			,0 ,'NIT'				,'NIT'				,'NIT'				,'NIT'								,'NIT'								,'NIT'								,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','09','CS9_UF'	  ,'C'	,2 	 			,0	,'UF'				,'UF'				,'UF'				,'UF'								,'UF'								,'UF'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','10','CS9_IE'	  ,'C'	,14	 			,0 ,'IE'				,'IE'				,'IE'				,'IE'								,'IE'								,'IE'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','11','CS9_IEST'	  ,'C'	,14	 			,0 ,'IE ST'				,'IE ST'			,'IE ST'			,'IE ST'							,'IE ST'							,'IE ST'							,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','12','CS9_CODMUN','C'	,7 	 			,0 ,'Cod. Municip'		,'Cod. Municip'		,'Cod. Municip'		,'Codigo do Municipio'				,'Codigo do Municipio'				,'Codigo do Municipio'				,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','13','CS9_IM'	  ,'C'	,14	 			,0	,'IM'				,'IM'				,'IM'				,'IM'								,'IM'								,'IM'								,''	 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','14','CS9_SUFRAM','C'	,9 	 			,0 ,'SUFRAMA'			,'SUFRAMA'			,'SUFRAMA'			,'SUFRAMA'							,'SUFRAMA'							,'SUFRAMA'							,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','15','CS9_CODREL','C' 	,30	 			,0	,'Cod .Relacio'		,'Cod .Relacio'		,'Cod .Relacio'		,'Cod.do Relacionamento'			,'Cod.do Relacionamento'			,'Cod.do Relacionamento'			,''  	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  '','',''	 ,'','S' ,'A'	,'R'	,'','','','','','','','',''		,'','S' ,.T.})
aAdd( aSx3 , {'CS9','16','CS9_DTINI' ,'D'  ,8 	 			,0 ,'Dt Ini Rel'		,'Dt Ini Rel'		,'Dt Ini Rel'		,'Data de Inicio do Relacionamento'	,'Data de Inicio do Relacionamento'	,'Data de Inicio do Relacionamento'	,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'','S', 'A'	,'R'  	,"","","","","","","","",""		,"","S" ,.T.})
aAdd( aSx3 , {'CS9','17','CS9_DTFIM' ,'D'  ,8 	 			,0 ,'Dt Fim Rel'		,'Dt Fim Rel'		,'Dt Fim Rel'		,'Data de Fim do Relacionamento'	,'Data de Fim do Relacionamento'	,'Data de Fim do Relacionamento'	,""  	,"" ,'€€€€€€€€€€€€€€ ' ,"","",0 ,                   "","" ,""	 ,'','S', 'A'	,'R'  	,"","","","","","","","",""		,"","S" ,.T.})


aAdd( aSx3 , {'CSA','01','CSA_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System' 			,'@!'	,'','€€€€€€€€€€€€€€€','',''	,1	,					'','',''	 ,'','S',''	,'' 	,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSA','02','CSA_CODREV','C'	,6				,0	,'COD. REVISAO'		,'COD. REVISAO'		,'COD. REVISAO'		,'CODIGO DA REVISAO'				,'CODIGO DA REVISAO'				,'CODIGO DA REVISAO'				,''	 	,'','€€€€€€€€€€€€€€ ','',''	,0	,					'','',''	 ,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSA','03','CSA_DTLANC','D'	,8				,0	,'Data Lancto'		,'Data Lancto'		,'Data Lancto'		,'Data do Lancamento'				,'Data do Lancamento'				,'Data do Lancamento'				,''		,'','€€€€€€€€€€€€€€ ','',''	,0	,					'','',''	 ,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSA','04','CSA_NUMLOT','C'	,75				,0	,'NUM LOTE'			,'NUM LOTE'			,'NUM LOTE'			,'NUMERO DO LOTE'					,'NUMERO DO LOTE'					,'NUMERO DO LOTE'					,''		,'','€€€€€€€€€€€€€€ ','',''	,0	,					'','',''	 ,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSA','05','CSA_VLLCTO','N'	,15				,2	,'Valor Lacto'		,'Valor Lacto'		,'Valor Lacto'		,'Valor do Lcto'					,'Valor do Lcto'					,'Valor do Lcto'					,''		,'','€€€€€€€€€€€€€€ ','',''	,0	,					'','',''	 ,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSA','06','CSA_INDTIP','C'	,2				,0	,'Indic. Lcto.'		,'Indic. Lcto.'		,'Indic. Lcto.'		,'Ind. do Lancamento'				,'Ind. do Lancamento'				,'Ind. do Lancamento'				,''		,'','€€€€€€€€€€€€€€ ','',''	,0	,					'','',''	 ,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSB','01','CSB_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S',''		,''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSB','02','CSB_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','03','CSB_DTLANC','D'	,8				,0	,'Data Lancto'		,'Data Lancto'		,'Data Lancto'		,'Data do Lancamento'				,'Data do Lancamento'				,'Data do Lancamento'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','04','CSB_NUMLOT','C'	,75				,0	,'Num. Lote'		,'Num. Lote'		,'Num. Lote'		,'Numero do Lote'					,'Numero do Lote'					,'Numero do Lote'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','05','CSB_LINHA','C'	,3				,0	,'Linha'			,'Linha'			,'Linha'			,'Linha'							,'Linha'							,'Linha'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','06','CSB_CODCTA','C'	,30				,0	,'Cod Conta'		,'Cod Conta'		,'Cod Conta'		,'Cod. Conta'						,'Cod. Conta'						,'Cod. Conta'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','07','CSB_CCUSTO','C'	,30				,0	,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','08','CSB_VLPART','N'	,15				,2	,'Valor Partid'		,'Valor Partid'		,'Valor Partid'		,'Valor da Partida'					,'Valor da Partida'					,'Valor da Partida'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','09','CSB_INDDC','C'	,1				,0	,'Ind. Naturez'		,'Ind. Naturez'		,'Ind. Naturez'		,'Indicador da Natureza'			,'Indicador da Natureza'			,'Indicador da Natureza'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','10','CSB_NUMARQ','C'	,75				,0	,'NUM. ARQ'			,'NUM. ARQ'			,'NUM. ARQ'			,'Numero do Arquivo'				,'Numero do Arquivo'				,'Numero do Arquivo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','11','CSB_CODHIS','C'	,30				,0	,'Cod. Hist'		,'Cod. Hist'		,'Cod. Hist'		,'Codigo do Historico'				,'Codigo do Historico'				,'Codigo do Historico'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','12','CSB_HISTOR','C'	,250			,0	,'HIstorico'		,'HIstorico'		,'HIstorico'		,'HIstorico'						,'HIstorico'						,'HIstorico'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSB','13','CSB_CODPAR','C'	,30				,0	,'Cod. Partici'		,'Cod. Partici'		,'Cod. Partici'		,'Cod. do Participante'				,'Cod. do Participante'				,'Cod. do Participante'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSC','01','CSC_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSC','02','CSC_CODREV','C'	,6				,0	,'COD. REVISAO'		,'COD. REVISAO'		,'COD. REVISAO'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','03','CSC_DTINI','D'	,8				,0	,'Dt Inicial'		,'Dt Inicial'		,'Dt Inicial'		,'Dt Inicial'						,'Dt Inicial'						,'Dt Inicial'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','04','CSC_DTFIM','D'	,8				,0	,'Dt Final'			,'Dt Final'			,'Dt Final'			,'Dt Final'							,'Dt Final'							,'Dt Final'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','05','CSC_CONTA','C'	,30				,0	,'Cod. Conta'		,'Cod. Conta'		,'Cod. Conta'		,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','06','CSC_CCUSTO','C'	,30				,0	,'C.CUSTO'			,'C.CUSTO'			,'C.CUSTO'			,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','07','CSC_VALINI','N'	,15				,2	,'Vl Inicial'		,'Vl Inicial'		,'Vl Inicial'		,'Valor Inicial'					,'Valor Inicial'					,'Valor Inicial'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','08','CSC_VALDEB','N'	,15				,2	,'Valor Deb.'		,'Valor Deb.'		,'Valor Deb.'		,'Valor Debito'						,'Valor Debito'						,'Valor Debito'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','09','CSC_VALCRED','N'	,15				,2	,'VL CREDT'			,'VL CREDT'			,'VL CREDT'			,'Valor Credito'					,'Valor Credito'					,'Valor Credito'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','10','CSC_VALMOV','N'	,15				,2	,'Valor Mov'		,'Valor Mov'		,'Valor Mov'		,'Valor do Movimento'				,'Valor do Movimento'				,'Valor do Movimento'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','11','CSC_VALFIN','N'	,15				,2	,'Vl. Final'		,'Vl. Final'		,'Vl. Final'		,'Valor Final'						,'Valor Final'						,'Valor Final'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','12','CSC_INDINI','C'	,1				,0	,'Indic. VAL'		,'Indic. VAL'		,'Indic. VAL'		,'Indic. Valor inicial'				,'Indic. Valor inicial'				,'Indic. Valor inicial'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSC','13','CSC_INDFIM','C'	,1				,0	,'Indic. Val'		,'Indic. Val'		,'Indic. Val'		,'Indic. valor final'				,'Indic. valor final'				,'Indic. valor final'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSD','01','CSD_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSD','02','CSD_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSD','03','CSD_CODVIS','C'	,30				,0	,'Cod. Visao'		,'Cod. Visao'		,'Cod. Visao'		,'Codigo da Visao'					,'Codigo da Visao'					,'Codigo da Visao'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSD','04','CSD_DTINI','D'	,8				,0	,'Dt. Inicial'		,'Dt. Inicial'		,'Dt. Inicial'		,'Data de Inicio'					,'Data de Inicio'					,'Data de Inicio'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSD','05','CSD_DTFIN','D'	,8				,0	,'Dt Final'			,'Dt Final'			,'Dt Final'			,'Data Final'						,'Data Final'						,'Data Final'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSD','06','CSD_CABDEM','D'	,8				,0	,'CabDemons'		,'CabDemons'		,'CabDemons'		,'Cab. Demonstrativo'				,'Cab. Demonstrativo'				,'Cab. Demonstrativo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSD','07','CSD_TPDEM','C'	,1				,0	,'Tp Demonstr.'		,'Tp Demonstr.'		,'Tp Demonstr.'		,'Tipo de Demonstracao'				,'Tipo de Demonstracao'				,'Tipo de Demonstracao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSE','01','CSE_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSE','02','CSE_CODREV','C'	,6				,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','03','CSE_CODVIS','C'	,30				,0 ,'Cod. Visao'		,'Cod. Visao'		,'Cod. Visao'		,'Codigo da Visao'					,'Codigo da Visao'					,'Codigo da Visao'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','04','CSE_CODAGL','C'	,30				,0	,'Cod. Aglut.'		,'Cod. Aglut.'		,'Cod. Aglut.'		,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','05','CSE_TPDEM' ,'C'	,1				,0	,'Tp Demonstr.'		,'Tp Demonstr.'		,'Tp Demonstr.'		,'Tipo de Demonstracao'				,'Tipo de Demonstracao'				,'Tipo de Demonstracao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','06','CSE_NIVEL' ,'N'	,2				,0	,'NIVEL'			,'NIVEL'			,'NIVEL'			,'NIVEL'							,'NIVEL'							,'NIVEL'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','07','CSE_DESCRI','C'	,250			,0	,'Descricao'		,'Descricao'		,'Descricao'		,'Descricao'						,'Descricao'						,'Descricao'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','08','CSE_INDVAL','C'	,1				,0	,'Ind Valor'		,'Ind Valor'		,'Ind Valor'		,'Ind. Valor'						,'Ind. Valor'						,'Ind. Valor'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSE','09','CSE_VALOR' ,'N'	,15				,2	,'Valor'			,'Valor'			,'Valor'			,'Valor'							,'Valor'							,'Valor'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
//Leiaute 2 da ECD
aAdd( aSx3 , {'CSE','10','CSE_VLRINI' ,'N'	,15				,2	,'Valor Inic.'		,'Valor Inic.'		,'Valor Inic.'		,'Valor Inicial'					,'Valor Inicial'					,'Valor Inicial'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSE','11','CSE_INDINI' ,'C'	,1				,0	,'Ind.Vlr.Ini'		,'Ind.Vlr.Ini'		,'Ind.Vlr.Ini'		,'Ind.Valor Inicial'				,'Ind.Valor Inicial'				,'Ind.Valor Inicial'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSE','12','CSE_VLRFIM' ,'N'	,15				,2	,'Valor Final'		,'Valor Final'		,'Valor Final'		,'Valor Final'						,'Valor Final'						,'Valor Final'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSE','13','CSE_INDFIM' ,'C'	,1				,0	,'Ind.Vlr.Fim'		,'Ind.Vlr.Fim'		,'Ind.Vlr.Fim'		,'Ind.Valor Final'				,'Ind.Valor Final'				,'Ind.Valor Final'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSE','14','CSE_TIPOPE' ,'C'	,1				,0	,'Tp.Oper.Lin'		,'Tp.Oper.Lin'		,'Tp.Oper.Lin'		,'Tipo Operador da Linha'			,'Tipo Operador da Linha'			,'Tipo Operador da Linha'			,''	    ,'','€€€€€€€€€€€€€€ ',"","",0  , 					"","",""	,'','S','A','R'  	,"","","A=Adicao;S=Subtracao;L=Label;P=Subtotal positivo;N=Subtotal negativo","A=Adicao;S=Subtracao;L=Label;P=Subtotal positivo;N=Subtotal negativo","A=Adicao;S=Subtracao;L=Label;P=Subtotal positivo;N=Subtotal negativo","","","",""		,"","S"})
aAdd( aSx3 , {'CSE','15','CSE_INDSLD' ,'C'	,2				,0	,'Ind.Saldo'		,'Ind.Saldo'		,'Ind.Saldo'		,'Indicador Situacao Saldo'			,'Indicador Situacao Saldo'			,'Indicador Situacao Saldo'			,''	    ,'Vazio .Or. Pertence("SF|VI|VF")','€€€€€€€€€€€€€€ ',"","",0  , 					"","",""	,'','S','A','R'  	,"","","SF=Saldo Final;VI=Saldo Inicial-Saldo Final;VF=Saldo Final-Saldo Inicial","SF=Saldo Final;VI=Saldo Inicial-Saldo Final;VF=Saldo Final-Saldo Inicial","SF=Saldo Final;VI=Saldo Inicial-Saldo Final;VF=Saldo Final-Saldo Inicial","","","",""		,"","S"})
aAdd( aSx3 , {'CSF','01','CSF_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSF','02','CSF_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSF','03','CSF_LINHA' ,'C'	,18				,0	,'Num Linha'		,'Num Linha'		,'Num Linha'		,'Num Linha'						,'Num Linha'						,'Num Linha'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSF','04','CSF_DTINI' ,'D'	,8				,0	,'Data Inicial'		,'Data Inicial'		,'Data Inicial'		,'Data Inicial'						,'Data Inicial'						,'Data Inicial'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSF','05','CSF_DTFIM' ,'D'	,8				,0	,'Data Final'		,'Data Final'		,'Data Final'		,'Data Final'						,'Data Final'						,'Data Final'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSF','06','CSF_NOMDEM','C'	,250			,0	,'Nome Demonst'		,'Nome Demonst'		,'Nome Demonst'		,'Nome do Demonstrativo'			,'Nome do Demonstrativo'			,'Nome do Demonstrativo'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSF','07','CSF_ARQRTF','M'	,10				,0	,'Arq. Rtf'			,'Arq. Rtf'			,'Arq. Rtf'			,'Arq. Rtf'							,'Arq. Rtf'							,'Arq. Rtf'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSG','01','CSG_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSG','02','CSG_CODREV','C'	,6				,0	,'COD. REVISAO'		,'COD. REVISAO'		,'COD. REVISAO'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','03','CSG_DTBAL' ,'D'	,8	  			,0	,'Dt Balancete'		,'Dt Balancete'		,'Dt Balancete'		,'Dt Balancete'						,'Dt Balancete'						,'Dt Balancete'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','04','CSG_CONTA' ,'C'	,30  			,0	,'Cod. Conta'		,'Cod. Conta'		,'Cod. Conta'		,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','05','CSG_CCUSTO','C'	,30  			,0	,'C.CUSTO'			,'C.CUSTO'			,'C.CUSTO'			,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','06','CSG_VALINI','N'	,15  			,2	,'Vl Inicial'		,'Vl Inicial'		,'Vl Inicial'		,'Valor Inicial'					,'Valor Inicial'					,'Valor Inicial'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','07','CSG_VALDEB','N'	,15  			,2	,'Valor Deb.'		,'Valor Deb.'		,'Valor Deb.'		,'Valor Debito'						,'Valor Debito'						,'Valor Debito'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','08','CSG_VALCRE','N'	,15				,2	,'VL CREDT'			,'VL CREDT'			,'VL CREDT'			,'Valor Credito'					,'Valor Credito'					,'Valor Credito'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','09','CSG_VALMOV','N'	,15  			,2	,'Valor Mov'		,'Valor Mov'		,'Valor Mov'		,'Valor do Movimento'				,'Valor do Movimento'				,'Valor do Movimento'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','10','CSG_VALFIN','N'	,15  			,2	,'Vl. Final'		,'Vl. Final'		,'Vl. Final'		,'Valor Final'						,'Valor Final'						,'Valor Final'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','11','CSG_INDINI','C'	,1				,0	,'Indic. VAL'		,'Indic. VAL'		,'Indic. VAL'		,'Indic. Valor inicial'				,'Indic. Valor inicial'				,'Indic. Valor inicial'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSG','12','CSG_INDFIM','C'	,1				,0	,'Indic. Val'		,'Indic. Val'		,'Indic. Val'		,'Indic. valor final'				,'Indic. valor final'				,'Indic. valor final'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSJ','01','CSJ_FILIAL','C'	,nTamFilial	 	,0 ,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1 	,				 	"",'',''	,'','S' ,'' ,''	   	,'','','','','','','','',"033"	,'',"S" ,.T.})
aAdd( aSx3 , {'CSJ','02','CSJ_CODREV','C'	,6	 			,0 ,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''	 	,'','€€€€€€€€€€€€€€ ','','',0 	,					"",'',''	,'','S' ,'A','R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CSJ','03','CSJ_CONTA' ,'C'	,30	 			,0	,'Código'			,'Código'			,'Código'			,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''	 	,'','€€€€€€€€€€€€€€ ','','',0 	,					"",'',''	,'','S' ,'A','R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CSJ','04','CSJ_NOMECT','C'	,50	 			,0 ,'Descrição'			,'Descrição'		,'Descrição'		,'Descrição da Conta'				,'Descrição da Conta'				,'Descrição da Conta'				,''	 	,'','€€€€€€€€€€€€€€ ','','',0 	,					"",'',''	,'','S' ,'A','R'	,'','','','','','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CSJ','05','CSJ_IMPORT','C'	,1	 			,0 ,'Importação'		,'Importação'		,'Importação'		,'Importação'						,'Importação'						,'Importação'						,''	 	,'','€€€€€€€€€€€€€€ ','"2"','',0,					"",'',''	,'','S' ,'V','R'	,'','',"1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não",'','','','','',"S" ,.T.})
aAdd( aSx3 , {'CSJ','06','CSJ_HASH'  ,'C'	,4	 			,0 ,'Ident. Hash'		,'Ident. Hash'		,'Ident. Hash'		,'Identificação do Hash'			,'Identificação do Hash'			,'Identificação do Hash'			,''	 	,'','€€€€€€€€€€€€€€ ','"2"','',0,					"",'',''	,'','S' ,'V','R'	,'','',"","","",'','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CSK','01','CSK_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S','',''		,'','','','','','','','',"033"		,'','S'})
aAdd( aSx3 , {'CSK','02','CSK_CODREV','C'	,6				,0	,'COD. REVISAO'		,'COD. REVISAO'		,'COD. REVISAO'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','03','CSK_DTINI','D'	,8				,0	,'Dt Inicial'		,'Dt Inicial'		,'Dt Inicial'		,'Dt Inicial'						,'Dt Inicial'						,'Dt Inicial'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','04','CSK_DTFIM','D'	,8				,0	,'Dt Final'			,'Dt Final'			,'Dt Final'			,'Dt Final'							,'Dt Final'							,'Dt Final'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','05','CSK_CONTA','C'	,30				,0	,'Cod. Conta'		,'Cod. Conta'		,'Cod. Conta'		,'Codigo da Conta'					,'Codigo da Conta'					,'Codigo da Conta'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','06','CSK_CCUSTO','C'	,30				,0	,'C.CUSTO'			,'C.CUSTO'			,'C.CUSTO'			,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,'Cod. do C. de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','07','CSK_CTAREF','C'	,30				,0	,'C.Refencial'		,'C.Refencial'		,'C.Refencial'		,'Cod. da Conta Refeencial'			,'Cod. da Conta Refeencial'			,'Cod. da Conta Refeencial'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','08','CSK_VALDEB','N'	,15				,2	,'Valor Deb.'		,'Valor Deb.'		,'Valor Deb.'		,'Valor Debito'						,'Valor Debito'						,'Valor Debito'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSK','09','CSK_VALCRED','N'	,15				,2	,'VL CREDT'			,'VL CREDT'			,'VL CREDT'			,'Valor Credito'					,'Valor Credito'					,'Valor Credito'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S'})

aAdd( aSx3 , {'CSL','01','CSL_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','',''	,'','S',''	,''		,'','','','','','','','',"033"		,'','S'})
aAdd( aSx3 , {'CSL','02','CSL_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','03','CSL_DTLANC','D'	,8				,0	,'Data Lancto'		,'Data Lancto'		,'Data Lancto'		,'Data do Lancamento'				,'Data do Lancamento'				,'Data do Lancamento'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','04','CSL_NUMLOT','C'	,75				,0	,'Num. Lote'		,'Num. Lote'		,'Num. Lote'		,'Numero do Lote'					,'Numero do Lote'					,'Numero do Lote'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSL','05','CSL_LINHA','C'	,3				,0	,'Linha'			,'Linha'			,'Linha'			,'Linha'							,'Linha'							,'Linha'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','06','CSL_CODCTA','C'	,30				,0	,'Cod Conta'		,'Cod Conta'		,'Cod Conta'		,'Cod. Conta'						,'Cod. Conta'						,'Cod. Conta'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','07','CSL_CCUSTO','C'	,30				,0	,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod. C.CUSTO'		,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','08','CSL_CTAREF','C'	,30				,0	,'Cod.Referencial'	,'Cod.Referencial'	,'Cod.Referencial'	,'Cod. Conta Referencial'			,'Cod. Conta Referencial'			,'Cod. Conta Referencial'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','09','CSL_VLPART','N'	,15				,2	,'Valor Partid'		,'Valor Partid'		,'Valor Partid'		,'Valor da Partida'					,'Valor da Partida'					,'Valor da Partida'					,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','10','CSL_INDDC','C'	,1				,0	,'Ind. Naturez'		,'Ind. Naturez'		,'Ind. Naturez'		,'Indicador da Natureza'			,'Indicador da Natureza'			,'Indicador da Natureza'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S'})
aAdd( aSx3 , {'CSL','11','CSL_NUMARQ','C'	,75				,0	,'NUM. ARQ'			,'NUM. ARQ'			,'NUM. ARQ'			,'Numero do Arquivo'				,'Numero do Arquivo'				,'Numero do Arquivo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})

aAdd( aSx3 , {'CSM','01','CSM_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€' ,'','',1	,					'','',''	,'','S',''	,''			,'','','','','','','','',"033"	,'','S'})
aAdd( aSx3 , {'CSM','02','CSM_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','A'	,'R'		,'','','','','','','','',''	,'','S'})
aAdd( aSx3 , {'CSM','03','CSM_QUALPJ','C'	,2				,0	,'Qualif.PJ'		,'Qualif.PJ'		,'Qualif.PJ'		,'Qualificacao de PJ'				,'Qualificacao de PJ'				,'Qualificacao de PJ'				,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','00=(00-SUSEP);10=(10-RFB);20=(20-COSIF)'	,'00=(00-SUSEP);10=(10-RFB);20=(20-COSIF)'	,'00=(00-SUSEP);10=(10-RFB);20=(20-COSIF)'	,'','','',''		,'',"S",.T.})
aAdd( aSx3 , {'CSM','04','CSM_TPESCR','C'	,1				,0	,'Tp.Escrit.'		,'Tp.Escrit.'		,'Tp.Escrit.'		,'Tipo Escrituracao'				,'Tipo Escrituracao'				,'Tipo Escrituracao'				,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','0=0-Original;1=1-Retificadora'		,'0=0-Original;1=1-Retificadora'		,'0=0-Original;1=1-Retificadora'		,'','','',''		,'',"S", .T.})
aAdd( aSx3 , {'CSM','05','CSM_RECANT','C'	,41				,0	,'Rec.Anterior'		,'Rec.Anterior'		,'Rec.Anterior'		,'Recibo Escrituracao Anterior'		,'Recibo Escrituracao Anterior'		,'Recibo Escrituracao Anterior'		,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','','',''	,'','','',''	,'',"S"})
aAdd( aSx3 , {'CSM','06','CSM_FMAPUR','C'	,1				,0	,'Forma Apur.'		,'Forma Apur.'		,'Forma Apur.'		,'Forma de Apuracao'				,'Forma de Apuracao'				,'Forma de Apuracao'				,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','A=A-Anual;T=T-Trimestral'	,'A=A-Anual;T=T-Trimestral'		,'A=A-Anual;T=T-Trimestral'		,'','','',''		,'',"S",.T.})
aAdd( aSx3 , {'CSM','07','CSM_FMTRIB','C'	,1				,0	,'Forma Tribut.'	,'Forma Tribut.'	,'Forma Tribut.'	,'Forma de Tributacao'				,'Forma de Tributacao'				,'Forma de Tributacao'				,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','1=1-Real;2=2-Real Arbitrado;3=3-Real Presumido (Trimestral);4=4-Real Presumido Arbitrado (Trimestral)'	,'1=1-Real;2=2-Real Arbitrado;3=3-Real Presumido (Trimestral);4=4-Real Presumido Arbitrado (Trimestral)'		,'1=1-Real;2=2-Real Arbitrado;3=3-Real Presumido (Trimestral);4=4-Real Presumido Arbitrado (Trimestral)'		,'','','',''		,'',"S", .T.})
aAdd( aSx3 , {'CSM','08','CSM_TARBIT','C'	,4				,0	,'Trim.Luc.Arb.'	,'Trim.Luc.Arb.'	,'Trim.Luc.Arb.'	,'Trimestre de Lucro Arbitrado'		,'Trimestre de Lucro Arbitrado'		,'Trimestre de Lucro Arbitrado'		,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','','',''	,'','','',''	,'',"S"})
aAdd( aSx3 , {'CSM','09','CSM_APUTRI','C'	,4				,0	,'Apur.Trimestre'	,'Apur.Trimestre'	,'Apur.Trimestre'	,'Apuracao do Trimestre'			,'Apuracao do Trimestre'			,'Apuracao do Trimestre'			,'@!' 	,'','€€€€€€€€€€€€€€ ' ,'','',0 ,					"",'',''	 ,'','S' ,'A' ,'R'	   	,'','','','',''	,'','','',''	,'',"S"})
aAdd( aSx3 , {'CSM','10','CSM_APUCTA','C'	,30				,0	,'Cod Conta'		,'Cod Conta'		,'Cod Conta'		,'Cod. Conta'						,'Cod. Conta'						,'Cod. Conta'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSM','11','CSM_APUCC' ,'C'	,30				,0	,'Cod C.Custo'		,'Cod C.Custo'		,'Cod C.Custo'		,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,'Cod. Centro de Custo'				,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSM','12','CSM_CTAREF','C'	,30				,0	,'Cod Conta Ref.'	,'Cod Conta Ref.'	,'Cod Conta Ref.'	,'Cod. Conta Referencial'			,'Cod. Conta Referencial'			,'Cod. Conta Referencial'			,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSM','13','CSM_TPUTIL','C'	,01	 			,0 ,"Tp.Utiliz."		,'Tp.Utiliz.'		,'Tp.Utiliz.'		,'Tipo de Utilizacao FCONT'			,'Tipo de Utilizacao FCONT'			,'Tipo de Utilizacao FCONT'			,'@!' 	,'' ,'€€€€€€€€€€€€€€ ' ,'','',0 ,					  "",'',''	 ,'','S' ,'A' ,'R'	   ,'','','F=Fiscal;S=Societario;A=Ambos','F=Fiscal;S=Societario;A=Ambos','F=Fiscal;S=Societario;A=Ambos','','','',''		,'',"S" ,.T.})
aAdd( aSx3 , {'CSN','01','CSN_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€' ,'','',1	,					'','',''	,'','S',''	,''		,'','','','','','','','',"033"	,'','S',.T.})
aAdd( aSx3 , {'CSN','02','CSN_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ' ,'CS0->CS0_CODREV','',0	,	'','',''	,'','S','V'	,'R'	,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSN','03','CSN_REG'   ,'C'	,4				,0	,'Registro'			,'Registro'			,'Registro'			,'Registro'							,'Registro'							,'Registro'							,''		,'','€€€€€€€€€€€€€€ ' ,'"J200"','',0	,			'','',''	,'','S','V'	,'R'	,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSN','04','CSN_CODFAT','C'	,10				,0	,'Cod.Fato Ctb'		,'Cod.Fato Ctb'		,'Cod.Fato Ctb'		,'Codigo Fato Contabil'				,'Codigo Fato Contabil'				,'Codigo Fato Contabil'				,''		,'NaoVazio()','€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSN','05','CSN_DESFAT','C'	,200			,0	,'Desc.Fato '		,'Desc.Fato '		,'Desc.Fato '		,'Descricao Fato Contabil'			,'Descricao Fato Contabil'			,'Descricao Fato Contabil'			,''		,'NaoVazio()','€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','A'	,'R'	,'','','','','','','','',''	,'','S',.T.})

aAdd( aSx3 , {'CSO','01','CSO_FILIAL','C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€' ,'','',1	,					'','',''	,'','S',''	,''		,'','','','','','','','',"033"	    ,'','S',.T.})
aAdd( aSx3 , {'CSO','02','CSO_CODREV','C'	,6				,0	,'Cod. Revisao'		,'Cod. Revisao'		,'Cod. Revisao'		,'Codigo da Revisao'				,'Codigo da Revisao'				,'Codigo da Revisao'				,''		,'','€€€€€€€€€€€€€€ ' ,'CS0->CS0_CODREV','',0	,	'','',''	,'','S','V'	,'R'	,'','','','','','','','',''	    ,'','S',.T.})
aAdd( aSx3 , {'CSO','03','CSO_REG'   ,'C'	,4				,0	,'Registro'			,'Registro'			,'Registro'			,'Registro'							,'Registro'							,'Registro'							,''		,'','€€€€€€€€€€€€€€ ' ,'"J215"','',0	,			'','',''	,'','S','V'	,'R'	,'','','','','','','','',''	    ,'','S',.T.})
aAdd( aSx3 , {'CSO','04','CSO_CODVIS','C'	,30				,0  ,'Cod. Visao'		,'Cod. Visao'		,'Cod. Visao'		,'Codigo da Visao'					,'Codigo da Visao'					,'Codigo da Visao'					,''		,'','€€€€€€€€€€€€€€ ','EcdGetDMPL()','',0	,		'','',''	,'','S','V','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSO','05','CSO_CODAGL','C'	,30				,0	,'Cod. Aglut.'		,'Cod. Aglut.'		,'Cod. Aglut.'		,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,'Codigo da Aglutinacao'			,''		,'','€€€€€€€€€€€€€€ ','','CTS003',0	,				'','',''	,'','S','A','R'		,'','','','','','','','',''		,'','S',.T.})
aAdd( aSx3 , {'CSO','06','CSO_CODFAT','C'	,10				,0	,'Cod.Fato Ctb'		,'Cod.Fato Ctb'		,'Cod.Fato Ctb'		,'Codigo Fato Contabil'				,'Codigo Fato Contabil'				,'Codigo Fato Contabil'				,''		,'NaoVazio().And.CTS010FAT()'		,'€€€€€€€€€€€€€€ ' ,'','CSN',0	,				'','',''	,'','S','A'	,'R'	,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSO','07','CSO_DESFAT','C'	,200			,0	,'Desc.Fato '		,'Desc.Fato '		,'Desc.Fato '		,'Descricao Fato Contabil'			,'Descricao Fato Contabil'			,'Descricao Fato Contabil'			,''		,''									,'€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','V'	,'R'	,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSO','08','CSO_VLRFAT','N'	,15				,2	,'Valor'			,'Valor'			,'Valor'			,'Valor'							,'Valor'							,'Valor'							,"@E 999,999,999,999,999.99"		,''		,'€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''	,'','S',.T.})
aAdd( aSx3 , {'CSO','09','CSO_INDFAT','C'	,1				,0	,'Ind Valor'		,'Ind Valor'		,'Ind Valor'		,'Ind. Valor'						,'Ind. Valor'						,'Ind. Valor'						,''		,'NaoVazio().And.Pertence("DCPN") '	,'€€€€€€€€€€€€€€ ' ,'','',0	,					'','',''	,'','S','A','R'		,'','','','','','','','',''	,'','S',.T.})

#IFDEF TOP
	aAdd( aSx3 , {'CSH','01','CSH_FILIAL' ,'C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','','','','S','',''			,'','','','','','','','',"033"	,'','S',.T.})
	aAdd( aSx3 , {'CSH','02','CSH_MODELO' ,'C'	,10				,0	,'Modelo'			,'Modelo'			,'Modelo'			,'Modelo'							,'Modelo'							,'Modelo'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSH','03','CSH_ITEM'	  ,'C'	,6				,0	,'Item'				,'Item'	 			,'Item'	 			,'Item'								,'Item'								,'Item'								,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSH','04','CSH_RGRVLD' ,'C'	,100			,0	,'Regra'			,'Regra' 			,'Regra' 			,'Regra'							,'Regra'							,'Regra'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSH','05','CSH_DESCRI' ,'C'	,250			,0	,'Descrição'		,'Descrição'		,'Descrição'		,'Descrição'						,'Descrição'						,'Descrição'						,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSH','06','CSH_TIPO'	  ,'C'	,1				,0	,'Tipo'				,'Tipo'				,'Tipo'				,'Tipo'								,'Tipo'								,'Tipo'								,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	
	aAdd( aSx3 , {'CSI','01','CSI_FILIAL' ,'C'	,nTamFilial		,0	,'Filial'			,'Sucursal'			,'Branch'			,'Filial do Sistema'				,'Sucursal'							,'Branch of the System'				,'@!'	,'','€€€€€€€€€€€€€€€','','',1	,					'','','','','S','',''			,'','','','','','','','',"033"	,'','S',.T.})
	aAdd( aSx3 , {'CSI','02','CSI_MODELO' ,'C'	,10				,0	,'Modelo'			,'Modelo'			,'Modelo'			,'Modelo'							,'Modelo'							,'Modelo'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','03','CSI_ITEM'	   ,'C'	,6				,0	,'Item'				,'Item'	 			,'Item'	 			,'Item'								,'Item'								,'Item'								,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','04','CSI_RGRVLD' ,'C'	,100			,0	,'Regra'			,'Regra' 			,'Regra' 			,'Regra'							,'Regra'							,'Regra'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','05','CSI_REG'    ,'C'	,100			,0	,'Registro'			,'Registro'			,'Registro'			,'Registro'							,'Registro'							,'Registro'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','06','CSI_CAMPO'  ,'C'	,100			,0	,'Campo'			,'Campo'			,'Campo'			,'Campo'							,'Campo'							,'Campo'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','07','CSI_TABELA' ,'C'	,3				,0	,'Tabela'			,'Tabela' 			,'Tabela' 			,'Tabela'							,'Tabela'							,'Tabela'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	aAdd( aSx3 , {'CSI','08','CSI_FORMUL' ,'C'	,250			,0	,'Formula'			,'Formula' 			,'Formula' 			,'Formula'							,'Tabela'							,'Tabela'							,''		,'','€€€€€€€€€€€€€€ ','','',0	,					'','','','','S','A','R'			,'','','','','','','','',''		,'','S',.T.})
	
	//Layout de Diarios
	Aadd(aSX3, {"CSV", "01", "CSV_FILIAL" ,"C", nTamFilial		,0	, "Filial"     		, "Sucursal"		, "Branch"       	, "Filial do Sistema"  				, "Sucursal do Sistema"				, "System Branch"     				, "@!"	, "" 															, "€€€€€€€€€€€€€€€"	, "", ""	, 1, "€€","","","","S" ,"","","" ,"","","","","","","","033"	,"","S",.T.})
	Aadd(aSX3, {"CSV", "02", "CSV_CODLAY" ,"C", 3				,0	, "Cod. Layout"		, ""	   			, "	"				, "Codigo do Layout"				, ""								, ""								, "@!"	,"ExistChav('CSV',,1) .And. FreeForUse('CSV',M->CSV_CODLAY)"	, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSV", "03", "CSV_DESCRI" ,"C", 60				,0	, "Descricao"		, "Descripcion"		, "Description"		, "Descricao do Layout"				, ""								, ""	  							, ""	,"NaoVazio()"													, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	
	//Itens Layouts de Diarios
	Aadd(aSX3, {"CSW", "01", "CSW_FILIAL"	,"C", nTamFilial	,0	, "Filial"     		, "Sucursal"		, "Branch"       	, "Filial do Sistema"  				, "Sucursal do Sistema"				, "System Branch"     				, "@!"		, "" 														, "€€€€€€€€€€€€€€€"	, "", ""	, 1, "€€","","","","S" ,"","","" ,"","","","","","","","033"	,"","S",.T.})
	Aadd(aSX3, {"CSW", "02", "CSW_CODLAY"	,"C", 3				,0	, "Cod.Layout"		, ""	   			, "	"				, "Codigo do Layout"				, ""								, ""								, "@!"		,"ExistChav('CSW',,1) .And. FreeForUse('CSW',M->CSW_CODLAY)", "€€€€€€€€€€€€€€€"	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSW", "03", "CSW_ORDEM"	,"C", 3				,0	, "Ordem"			, ""	   			, "	"				, "Ordem"							, ""								, ""								, "@!"		,""															, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSW", "04", "CSW_CAMPO"	,"C", 16			,0	, "Campo"			, ""				, ""				, "Nome do Campo"					, ""								, ""	  							, ""		,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSW", "05", "CSW_DESCRI"	,"C", 50			,0	, "Descr.Campo"		, ""				, ""				, "Descricao do Campo"				, ""								, ""	  							, ""		,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSW", "06", "CSW_TIPO"		,"C", 1				,0	, "Tipo"  			, ""				,""					, "Tipo"		  					, ""								, ""	  							, "@!"		,"NaoVazio() "												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","C=Caracter;N=Numerico","C=Caracter;N=Numerico","C=Caracter;N=Numerico","","","","","","S",.T.})
	Aadd(aSX3, {"CSW", "07", "CSW_TAM"		,"N", 2				,0	, "Tamanho"			, ""				, ""				, "Tamanho do Campo"				, ""								, ""	  							, "@E 99"	,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSW", "08", "CSW_TAMDEC"	,"N", 1				,0	, "Decimais"		, ""   				, "Description"		, "Num. Casas Decimais"				, ""								, ""	  							, "@E 9" 	,""			 												, aSX3Copia[03][2]	, "", ""	, 1, aSX3Copia[03][3],"","","","S","","","","","","","","","","","","","S",.T.})
	Aadd(aSX3, {"CSW", "09", "CSW_LARG"		,"N", 3				,0	, "Largura"			, ""				, ""				, "Largura do Campo"				, ""								, ""	  							, "@E 999"	,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	
	//Importacao de Diarios
	Aadd(aSX3, {"CSX", "01", "CSX_FILIAL"	,"C", nTamFilial	,0	, "Filial"     		, "Sucursal"		, "Branch"       	, "Filial do Sistema"  				, "Sucursal do Sistema"				, "System Branch"     				, "@!"	,"", "€€€€€€€€€€€€€€€"	, "", ""	, 1, "€€","","","","S" ,"","","" ,"","","","","","","","033"	,"","S",.T.})
	Aadd(aSX3, {"CSX", "02", "CSX_CODREV"	,"C", 6				,0	, "Cod.Revisao"		, ""    	   		, "	"		   		, "Codigo da Revisao"				, ""								, ""								, "@!"	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSX", "03", "CSX_CODLAY"	,"C", 3				,0	, "Cod. Layout"		, ""    	   		, "	"				, "Codigo do Layout"				, ""								, ""								, "@!"	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSX", "04", "CSX_ORDEM"	,"C", 10			,0	, "Ordem"			, ""				, ""	 			, "Ordem"							, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSX", "05", "CSX_DESCRI"	,"C", 250			,0	, "Descricao"		, ""				, ""	 			, "Descricao"						, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSX", "06", "CSX_KEY"		,"C", 250			,0	, "Chave de Quebra"	, ""				, ""	 			, "Chave de Quebra"					, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	
	//Importacao de Diarios Quebras
	Aadd(aSX3, {"CSY", "01", "CSY_FILIAL"	,"C", nTamFilial	, 0	, "Filial"     		, "Sucursal"		, "Branch"       	, "Filial do Sistema"  				, "Sucursal do Sistema"				, "System Branch"     				, "@!"	,"", "€€€€€€€€€€€€€€€"	, "", ""	, 1, "€€","","","","S","","","" ,"","","","","","","","033"	,"","S",.T.})
	Aadd(aSX3, {"CSY", "02", "CSY_CODREV"	,"C", 6				, 0	, "Cod.Revisao"		, ""    	   		, "	"		   		, "Codigo da Revisao"				, ""								, ""								, "@!"	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSY", "03", "CSY_CODLAY"	,"C", 3				, 0	, "Cod. Layout"		, ""    	   		, "	"				, "Codigo do Layout"				, ""								, ""								, "@!"	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSY", "04", "CSY_ORDEM"	,"C", 10			, 0	, "Ordem"			, ""				, ""	 			, "Ordem"							, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSY", "05", "CSY_DESCRI"	,"C", 250			, 0	, "Descricao"		, ""				, ""	 			, "Descricao"						, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
	Aadd(aSX3, {"CSY", "06", "CSY_KEY"		,"C", 250			, 0	, "Chave de Quebra"	, ""				, ""	 			, "Chave de Quebra"					, ""								, ""	  							, ""	,"", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S",.T.})
#ENDIF


//Fim dos campos utilizados pelo novo SPED

aAdd(aSX3, {"CT1","31","CT1_DTEXSF"		,"D", 8				,0	,"Dt Fim Exist"		,"Fch Fin Exis"		,"Fin.Exist.Dt"		,"Data Final de Existencia"			,"Fecha Final de Existencia"		,"Final Existence Date"				,""				,""					,"€€€€€€€€€€€€€€ "	,""					,""	,1 	,"†A"   			,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S",.T.	})
aAdd(aSX3, {"CT1","30","CT1_DTEXIS"		,"D", 8				,0	,"Dt Ini Exist"		,"Fch Ini Exis"		,"Exst.Ini.Dt."		,"Data Inicio Existencia  "			,"Fecha Inicio Existencia  "		,"Existence Initial Date"			,"99/99/9999" 	,""					,"€€€€€€€€€€€€€€ "	,'CTOD("01/01/80")' ,""	,1 	,aSX3Copia[03][2]	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S",.T.	})
aAdd(aSX3, {"CT5","04","CT5_STATUS"		,"C", 1				,0	,"Status"			,"Estatus"			,"Status"			,"Status do Lancamento"				,"Estatus del Asiento"				,"Entry Status"						,""				,"Pertence('12 ')"	,"€€€€€€€€€€€€€€ "	,""					,""	,1	,"†A"				,""	,""	,"","S"	,""	,""	,""	,"","1=Ativo;2=Inativo"		,"1=Activo;2=Inactivo"	,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CT5","31","CT5_ROTRAS"		,"C", 60			,0	,"Rot.Rastrear"		,"Rut.Rastrear"		,"Track Rout."		,"Rotina Vis. Rastreamento"			,"Rutina Vis. Rastreo"				,"Tracking Routine"					,""				,""					,"€€€€€€€€€€€€€€ "	,""					,""	,1	,"ÖA"				,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CT5","32","CT5_TABORI"		,"C", 100			,0	,"Tabela Orig."		,"Tabla Orig."		,"Src.Table"		,"Tabela de Origem Lancto."			,"Tabla de Origen Asiento"			,"Entry Source Table"				,""				,""					,"€€€€€€€€€€€€€€ "	,""					,""	,1	,"ÖA"				,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CT5","33","CT5_RECORI"		,"C", 100			,0	,"Reg. Origem"		,"Reg. Origen"		,"Source Reg."		,"Funcao Reg. na Tab.Origem"		,"Funcion Reg. en Tab.Orig."		,"Reg.Func.in Src.Table"			,""				,""					,"€€€€€€€€€€€€€€ "	,""					,""	,1	,"ÖA"				,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})

aAdd(aSX3, {"CTD","14","CTD_DTEXSF"		,"D", 8				,0	,"Dt Fim Exist"		,"Fch Fin Exis"		,"Fin.Exist.Dt"		,"Data Final de Existencia"			,"Fecha final de Existencia"		,"Final Existence Date"				,""	   	,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"†A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S",.T.	})
aAdd(aSX3, {"CTD","25","CTD_ITVM"		,"C", nTamItCont	,0	,"It.Var.Monet"		,"It.Var.Monet"		,"Index.Item"		,"Item de Var. Monetaria"			,"Item de Var. Monetaria"			,"Indexation Item"					,"@!"	,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","005"	,"","S"	,.T.})
aAdd(aSX3, {"CTD","26","CTD_ITRED"		,"C", nTamItCont	,0	,"It.Red.V.Mon"		,"It.Red.V.Mon"		,"Index.Red.It"		,"Item Redutor Var.Monet."			,"Item Reductor Var.Monet."			,"Indexation Red.Item"				,"@!"	,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","005"	,"","S"	,.T.})

aAdd(aSX3, {"CTH","14","CTH_DTEXSF"		,"D", 8				,0	,"Dt Fim Exist"		,"Fch Fin Exis"		,"Fin.Exist.Dt"		,"Data Final de Existencia"			,"Fecha final de Existencia"		,"Final Existence Date"				,""		,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"†A"	,""	,""	,"","S"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CTH","23","CTH_CLVM"		,"C", nTamClVlr		,0	,"Cl.Var.Monet"		,"Cl.Var.Monet"		,"Indexat.Cat."		,"Classe Var. Monetaria"			,"Clase Var. Monetaria"				,""									,"@!"	,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","006"	,"","S"	,.T.})
aAdd(aSX3, {"CTH","24","CTH_CLRED"		,"C", nTamClVlr 	,0	,"Cl.Red.Var."		,"Cl.Red.Var."		,"Red.Cl.Var."		,"Classe Redutora Var. Mon."		,"Clase Reductora Var. Mon."		,"Red.Class MonetaryVariat."		,"@!"	,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","006"	,"","S"	,.T.})

aAdd(aSX3, {"CTK","34","CTK_TABORI"		,"C", 3				,0	,"Tab.Origem"		,"Tab.Origen"		,"Tab.Origin"		,"Tabela Origem Lancamento"			,"Tabla Origen Asiento"				,"Tab. Origin Entry"				,""		,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CTK","35","CTK_RECORI"		,"C", 17			,0	,"Reg. Origem"		,"Reg. Origen"		,"Source Reg."		,"Registro na Tabela Origem"		,"Registro en la Tabla Orig"		,"Regist. in Source Table"			,""		,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"þA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CTK","36","CTK_RECDES"		,"C", 17			,0	,"Reg. Destino"		,"Reg. Destino"		,"Target Reg."		,"Registro destino Lancto."			,"Registro destino Asiento"			,"Entry Target Regist."				,""		,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"þA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CTK","37","CTK_RECCV3"		,"C", 17			,0	,"Reg. Rastro."		,"Reg. Rastr."		,"Track.Reg."		,"Registro Tab.Rastreamento"		,"Registro Tab. Rastreo"			,"Tracking Table Registrati"		,""		,""					,"€€€€€€€€€€€€€€ "	,"",""	,1,"þA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})

aAdd(aSX3, {"CTT","14","CTT_DTEXSF"		,"D", 8				,0	,"Dt Fim Exist"		,"Fch Fin Exis"		,"Fin.Exist.Dt"		,"Data Final de Existencia"			,"Fecha final de Existencia"		,"Final Existence Date"				,"99/99/9999"	,""			,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"","S"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CTT","44","CTT_CCVM"		,"C", nTamCCusto	,0	,"C.C.Var.Mon."		,"C.C.Var.Mon."		,"Index.C.C."		,"CCusto Variacao Monetaria"		,"CCosto Variac. Monetaria"			,"Indexation Cost Center"			,"@!"			,""			,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","004"	,"","S"	,.T.})
aAdd(aSX3, {"CTT","45","CTT_CCRED"		,"C", nTamCCusto	,0	,"CC.Red. Var."		,"CC.Red. Var."		,"Index.R.CC"		,"C.Custo Redutor Var.Monet"		,"C.Costo Reductor Var.Mon."		,"Indexation Red.C.Center"			,"@!"			,""			,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"","004"	,"","S"	,.T.})

aAdd(aSX3, {"CV3","23","CV3_TABORI"		,"C", 3				,0	,"Tab.Origem"		,"Tab.Origen"		,"Src.Table"		,"Tabela Origem Lancamento"			,"Tabla Origen Asiento"				,"Entry Source Table"				,""			,""				,"€€€€€€€€€€€€€€ "	,"",""	,1,"ÖA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CV3","24","CV3_RECORI"		,"C", 17			,0	,"Reg.Origem"		,"Reg.Origen"		,"Source Reg."		,"Registro na Tabela Origem"		,"Registro en Tabla Origen"			,"Registration in Src.Table"		,""			,""				,"€€€€€€€€€€€€€€ "	,"",""	,1,"þA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CV3","25","CV3_RECDES"		,"C", 17			,0	,"Reg.Destino"		,"Reg. Destino"		,"Target Reg."		,"Registro Destino Lancto."			,"Registro Destino Asiento"			,"Entry Target Registration"		,""			,""				,"€€€€€€€€€€€€€€ "	,"",""	,1,"þA"	,""	,""	,"",""	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})

aAdd(aSX3, {"CVB","01","CVB_FILIAL"		,"C",nTamFilial		,0	,"Filial"      		,"Sucursal"			,"Branch"			,"Filial do Sistema"				,"Filial do Sistema"				,"System branch"					,""						,""																,"€€€€€€€€€€€€€€€"	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"","033"	,"","S"	,.T.})
aAdd(aSX3, {"CVB","02","CVB_CODCTB"		,"C",06				,0	,"Cod.Signat." 		,"Cod.Signat."		,"Cod.Signat."		,"Codigo do Signatario"				,"Codigo do Signatario"				,"Codigo Signatario"				,"@!"					,'ExistChav("CVB")'												,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","S"	,""	,""	,"€"	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","03","CVB_NOME"		,"C",40				,0	,"Nome"        		,"Nome"				,"Name"				,"Nome Contabilista/Escrit."		,"Nome Contabilista/Escrit."		,"Account./Office Name"				,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","S"	,""	,""	,"€"	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","04","CVB_CGC"		,"C",14				,0	,"CNPJ"        		,"CNPJ"				,"CNPJ"				,"CNPJ do escritório"				,"CNPJ do escritório"				,"Accountant's Office CGC"			,"@R 99.999.999/9999-99",'Vazio().Or.(Cgc(M->CVB_CGC).And.A015CGC("J",M->CVB_CGC))'		,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","05","CVB_CPF"		,"C",11				,0	,"CPF"         		,"CPF"	 			,"CPF"				,"CPF do Contabilista"				,"CPF do Contabilista"				,"Accountant's CPF"					,"@R 999.999.999-99"	,'Vazio().Or.(Cgc(M->CVB_CPF).And.A015CGC("F",M->CVB_CPF))'		,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","06","CVB_CRC"		,"C",15				,0	,"N.Inscricao" 		,"N.Inscricao"		,"Regist. Nbr."		,"N.Inscricao no Conselho"			,"N.Inscricao no Conselho"			,"Regist. Number in Council"		,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","S"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","07","CVB_ASSIN"		,"C",03				,0	,"Cod. Qualif."		,"Cod. Qualif."		,"Cod. Qualif."		,"Cod. Qualificacao Assin."			,"Cod. Qualificacao Assin."			,"Cod. Qualificacao Assin."			,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","08","CVB_QUALIF"		,"C",30				,0	,"Qualificacao"		,"Qualificacao"		,"Qualificacao"		,"Qualif. Assinante"				,"Qualif. Assinante"				,"Qualif. Assinante"				,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","09","CVB_CEP"		,"C",08				,0	,"Cep"         		,"Cep"				,"ZIP code"			,"Cep"								,"Cep"								,"ZIP code"							,"@R 99999-999"			,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","10","CVB_END"		,"C",40				,0	,"Endereco"    		,"Endereco"			,"Address"			,"Endereco"							,"Endereco"							,"Address"							,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","11","CVB_BAIRRO"		,"C",30				,0	,"Bairro"      		,"Bairro"			,"District"			,"Bairro"							,"Bairro"							,"District"							,"@!"					,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","12","CVB_UF"			,"C",02				,0	,"Estado"      		,"Estado"			,"State"			,"Estado do Contabilista"			,"Estado do Contabilista"			,"Accountant State"					,"@!"					,'ExistCpo("SX5","12"+M->CVB_UF)'								,"€€€€€€€€€€€€€€ "	,"","12"	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
aAdd(aSX3, {"CVB","15","CVB_EMAIL"		,"C",40				,0	,"E-Mail"      		,"E-Mail"			,"E-Mail"			,"E-Mail"							,"E-Mail'"							,"E-Mail"							,""        				,""																,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	,.T.})
// alterações SPED
aAdd(aSX3, {"CVB","13","CVB_TEL" 		,"C",16				,0	,"Telefone"    		,"Telefone"			,"Telephone"		,"Telefone"							,"Telefone"					  		,"Telephone"						,"@R 9999999-9999"		,""																	,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
aAdd(aSX3, {"CVB","14","CVB_FAX" 		,"C",16				,0	,"Fax"         		,"Fax"				,"Fax"				,"Fax"								,"Fax"								,"Fax"								,"@R 9999999-9999"		,""																	,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
aAdd(aSX3, {"CVB","15","CVB_EMAIL"		,"C",40				,0	,"E-Mail"      		,"E-Mail"			,"E-Mail"			,"E-Mail"							,"E-Mail'"							,"E-Mail"							,""        				,""																	,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3, {"CVB","16","CVB_DTINI" 		,"D",08				,0	,"Inicio Relac"		,"Inicio Relac"		,"Relat. Init."		,"Dt Inicio Relacionamento"			,"Dt Inicio Relacionamento"			,"Relationship Initial Date"		,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
aAdd(aSX3, {"CVB","17","CVB_DTFIM" 		,"D",08				,0	,"Fim Relac."		,"Fin Relac."		,"Relation.End"		,"Dt. Fim Relacionamento"			,"Dt. Fim Relacionamento"			,"Relationship End Date"			,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
aAdd(aSX3, {"CVB","18","CVB_PAIS" 		,"C",05				,0	,"Codigo Pais" 		,"Codigo Pais"		,"Country Code"		,"Codigo do Pais"					,"Codigo do Pais"					,"Country Code"						,"@R 99999"				,""																	,"€€€€€€€€€€€€€€ "	,"",""   	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
aAdd(aSX3, {"CVB","19","CVB_CODMUN" 	,"C",07				,0	,"Cd.Municipio"		,"Cd.Municipio"		,"City Code"		,"Codigo do Municipio"				,"Codigo do Municipio"				,"City Code"						,"@!"					,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"})
//leiaute 2 ECD
aAdd(aSX3, {"CVB","21","CVB_UFCRC"		,"C",02				,0	,"Estado CRC"   	,"Estado CRC"		,"Estado CRC"		,"Estado CRC"						,"Estado CRC"						,"Estado CRC"						,"@!"					,'ExistCpo("SX5","12"+M->CVB_UFCRC)'								,"€€€€€€€€€€€€€€ "	,"","12"	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3, {"CVB","22","CVB_SEQCRC"		,"C",11				,0	,"Seq.CRC"     		,"Seq.CRC"			,"Seq.CRC"			,"Seq.CRC"							,"Seq.CRC"							,"Seq.CRC"							,""        				,""																	,"€€€€€€€€€€€€€€ "	,"",""		,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3, {"CVB","23","CVB_DTCRC" 		,"D",08				,0	,"Data CRC"			,"Data CRC"			,"Data CRC"			,"Data CRC"							,"Data CRC"							,"Data CRC"							,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,"","","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""		,"",""		,"","S"})

aAdd(aSX3, {"CVC","01","CVC_FILIAL"		,"C",nTamFilial		,0	,"Filial"			,"Sucursal"			,"Branch"			,"Filial do Sistema"				,"Filial do Sistema"				,"System branch"					,""						,""																	,"€€€€€€€€€€€€€€€"	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"","033"		,"","S"	,.T.})
aAdd(aSX3, {"CVC","02","CVC_CODPAR"		,"C",06				,0	,"Cod.Partic." 		,"Cod.Partic."		,"Participant"		,"Codigo do Participante"			,"Codigo do Participante"			,"Code of Participant"				,"@!"					,'ExistChav("CVC")'													,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","S"	,""	,""	,"€"	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
aAdd(aSX3, {"CVC","03","CVC_CODREL"		,"C",02				,0	,"Cod.Relacion" 	,"Cod.Relacion"		,"Relat. Code"		,"Codigo do Relacionamento"			,"Codigo do Relacionamento"			,"Relationship Code"				,"@!"					,"Ctb016Valid()"													,"€€€€€€€€€€€€€€ "	,"","016"	,1,""	,""	,""	,"","S"	,""	,""	,"€"	,"",""				,""			,""			,""			,"a016TabRel()"		,"",""			,"","S"	,.T.})
aAdd(aSX3, {"CVC","04","CVC_NOME"		,"C",40				,0	,"Nome" 			,"Nombre"			,"Name"				,"Nome do Participante"				,"Nome do Participante"				,"Name of participant"				,"@!"					,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","S"	,""	,""	,"€"	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
aAdd(aSX3, {"CVC","05","CVC_TIPO"		,"C",01				,0	,"Fisica/Jurid" 	,"Fisica/Jurid"		,"Indiv./Leg.E"		,"Pessoa Fisica/Juridica"			,"Pessoa Fisica/Juridica"			,"Individual/Legal entity"			,"@!"					,'Pertence(" FJ")'													,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"","F=Fisica;J=Juridica"	,"F=Fisica;J=Juridica"	,"F=Fisica;J=Juridica"	,""	,""	,"",""	,"","S"	,.T.})
If cPaisLoc == "BRA"
	aAdd(aSX3, {"CVC","06","CVC_CGC"		,"C",14				,0	,"CNPJ/CPF" 		,"CNPJ/CPF"			,"CNPJ/CPF"		,"CNPJ/CPF do Participante"			,"CNPJ/CPF do Participante"			,"Participant's CNPJ/CPF"			,"@R 99.999.999/9999-99",'Vazio().Or.(Cgc(M->CVC_CGC).And.A016CGC(M->CVC_TIPO,M->CVC_CGC))'	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,"PicPes(M->CVC_TIPO)"			,""	,"",""		,"","S"	,.T.})
ElseIf cPaisLoc == "COL"
	aAdd(aSX3, {"CVC","06","CVC_CGC"		,"C",14				,0	,"NIT		" 		,"NIT	  "			,"NIT"			,"NIT do Contribuyente"				,"NIT do Contribuyente"				,"Participant's NIT"				,"@R 999999999-9       ",'IF(!Empty(M->CVC_CGC),CO_NIT().and.ExistChav("CVC",M->CVC_CGC,2),.T.)',"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,"PicPes(M->CVC_TIPO)"			,""	,"",""		,"","S"	,.T.})
ElseIf cPaisLoc == "PER"
	aAdd(aSX3, {"CVC","06","CVC_CGC"		,"C",14				,0	,"RUC"		 		,"RUC"				,"RUC"			,"RUC do Contribuyente"		  		,"CNPJ/CPF do Participante"			,"Participant's RUC"				,"@R 99999999999       ",'IF(!EMPTY(M->CVC_CGC),A030RUC(M->CVC_CGC).and.ExistChav("CVC",M->CVC_CGC,3),.T.)',"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,"PicPes(M->CVC_TIPO)"			,""	,"",""		,"","S"	,.T.})
EndIf
aAdd(aSX3, {"CVC","08","CVC_NUMRA"		,"C",06				,0	,"Ident.Trab." 		,"Ident.Trab."		,"Empl. Ident."		,"Identificacao Trabalhador"		,"Identificacao Trabalhador"		,"Employee Identification"			,"@!"					,'Vazio() .or. Existcpo("SRA")'										,"€€€€€€€€€€€€€€ "	,"","SRA"	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
aAdd(aSX3, {"CVC","09","CVC_UF"			,"C",02				,0	,"Estado" 			,"Estado"			,"State"			,"Estado do Participante"			,"Estado do Participante"			,"State"							,"@!"					,'ExistCpo("SX5","12"+M->CVC_UF)'									,"€€€€€€€€€€€€€€ "	,"","12" 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
If cPaisLoc == "BRA"
	aAdd(aSX3, {"CVC","10","CVC_IE"			,"C",18				,0	,"Inscr.Estad."		,"Inscr.Estat."		,"State Reg."		,"Inscricao Estadual"				,"Inscricao Estadual"				,"State Registration"				,"@!"					,"IE(M->CVC_IE,M->CVC_UF)"											,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
	aAdd(aSX3, {"CVC","11","CVC_IE_ST"		,"C",18				,0	,"Inscr.E.Subst"	,"Inscr.E.Subst"	,"Subst.St.Reg"		,"Insr.Estadual Substituto"			,"Insr.Estadual Substituto"			,"Substitute State Regist."			,"@!"					,"IE(M->CVC_IE_ST,M->CVC_UF)"										,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
	aAdd(aSX3, {"CVC","13","CVC_IM"			,"C",25				,0	,"Inscr.Munic."		,"Inscr.Munic."		,"City Reg."		,"Inscricao Municipal"				,"Inscricao Municipal"				,"City Registration"				,"@!"					,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
	aAdd(aSX3, {"CVC","14","CVC_SUFRAM"		,"C",12				,0	,"Suframa" 			,"Suframa"			,"Suframa"			,"Codigo na Suframa"				,"Codigo na Suframa"				,"Suframa Code"						,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""	,""	,""	,"","N"	,""	,""	,"" 	,"",""				,""			,""			,""			,""					,"",""			,"","S"	,.T.})
EndIf


If !cPaisLoc $ "COL|PER"
	aAdd(aSX3, {"CVC","07","CVC_PAIS"		,"C",05				,0	,"Codigo Pais" 		,"Codigo Pais"		,"Country Code"		,"Codigo do Pais"					,"Codigo do Pais"					,"Country Code"						,"@R 99999"				,""																	,"€€€€€€€€€€€€€€ "	,"",""   	,1,""				,""	,"","","N"		,"",""				,"" 		,""			,""			,""					,"",""			,""						,"",""			,"","S",.T.})
	aAdd(aSX3, {"CVC","12","CVC_CODMUN"		,"C",07				,0	,"Cod. Mun.   "		,"Cod. Mun.   "		,"City Code"		,"Codigo do Municipio"				,"Codigo do Municipio"				,"City Code"						,"@!"					,""                                      							,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""				,""	,"","","N"		,"",""				,"" 		,""			,""			,""					,"",""			,""						,"",""			,"","S",.T.})
	aAdd(aSX3, {"CVC","15","CVC_DTINI"		,"D",08				,0	,"Inicio Relac" 	,"Inicio Relac"		,"Relat. Init."		,"Dt Inicio Relacionamento"			,"Dt Inicio Relacionamento"			,"Relationship Initial Date"		,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""				,""	,"","","S"		,"",""				,"€"		,""			,""			,""					,"",""			,""						,"",""			,"","S",.T.})
	aAdd(aSX3, {"CVC","16","CVC_DTFIM"		,"D",08				,0	,"Fim Relac."	 	,"Fin Relac."		,"Relation.End"		,"Dt. Fim Relacionamento"			,"Dt. Fim Relacionamento"			,"Relationship End Date"			,""						,""																	,"€€€€€€€€€€€€€€ "	,"",""	 	,1,""				,""	,"","","N"		,"",""				,"" 		,""			,""			,""					,"",""			,""						,"",""			,"","S",.T.})

EndIf

If cPaisLoc <> "COL"
	Aadd(aSX3,{"CVD","01","CVD_FILIAL"		,"C",nTamFilial     ,0	,"Filial"      		,"Filial"      		,"Filial"      		,"Filial do sistema"          		,"Filial do sistema"          		,"Filial do sistema"          		,"@!"             		,""                                                                 ,aSX3Copia[01,2] 	,"","" 		,1,aSX3Copia[01,3] 	,"" ,"",""	,"N" 	,"","" 				,"" 		,""			,""     	,""        			,"",""			,""                   	,"","033"    	,"","S",.T.})
	Aadd(aSX3,{"CVD","02","CVD_CONTA" 		,"C",nTamConta		,0	,"Cod Conta"   		,"Cod Conta"   		,"Cod Conta"   		,"Codigo plano contas"        		,"Codigo plano contas"        		,"Codigo plano contas"        		,"@!"           		,""                                                                 ,aSX3Copia[01,2] 	,"",""  	,1,aSX3Copia[01,3] 	,"" ,"",""	,"S" 	,"","" 				,"" 		,""			,""     	,""        			,"",""			,""                   	,"","003" 		,"","S",.T.})
	Aadd(aSX3,{"CVD","03","CVD_ENTREF"	,"C",02 			,0	,"Entidade"    		,"Entidade"    		,"Entidade"    		,"Codigo da entidade"         		,"Codigo da entidade"         		,"Codigo da entidade"         		,"@!"             		,"Vazio() .OR. ExistCpo('SX5','GP'+M->CVD_ENTREF)"                  ,aSX3Copia[03,2] 	,"","GP"    ,1,aSX3Copia[03,3] ,"" ,"",""	,"S" 	,"","" 				,"" 		,"" 		,""         ,""                 ,"",""			,""                   	,"",""    		,"","S",.T.})
	Aadd(aSX3,{"CVD","04","CVD_CODPLA"	,"C",06     		,0	,"Plano Ref."  		,"Plano Ref."  		,"Plano Ref."  		,"Codigo plano referencial"   		,"Codigo plano referencial"   		,"Codigo plano referencial"   		,"@!"        			,"Vazio() .OR. ExistCpo('CVN',M->CVD_CODPLA,1)"                     ,aSX3Copia[03,2] 	,"","CVN1"  ,1,aSX3Copia[03,3] ,"" ,"S",""	,"S" 	,"","" 				,"" 		,"" 		,""         ,""                 ,"",""			,""                   	,"",""    		,"","S",.T.})
	Aadd(aSX3,{"CVD","05","CVD_CTAREF"	,"C",nTamCtaRef 	,0	,"Conta Ref."  		,"Conta Ref."  		,"Conta Ref."  		,"Codigo conta referencial"   		,"Codigo conta referencial"   		,"Codigo conta referencial"   		,"@!"             		,"Vazio() .OR. ExistCpo('CVN',cCvdCodPla+M->CVD_CTAREF,2)"          ,aSX3Copia[03,2] 	,"","CVN2"  ,1,aSX3Copia[03,3] ,"" ,"S","" ,"S" 	,"","" 				,"" 		,"" 		,""         ,""                 ,"",""			,"!Empty(cCvdCodPla)"	,"","027" 		,"","S",.T.})
	Aadd(aSX3,{"CVD","06","CVD_CUSTO" 	,"C",nTamCCusto		,0	,"Cod C.Custo" 		,"Cod C.Custo" 		,"Cod C.Custo" 		,"Codigo centro de custos"    		,"Codigo centro de custos"    		,"Codigo centro de custos"    		,"@!"         			,"Vazio() .OR. ExistCpo('CTT',M->CVD_CUSTO,1)"                      ,aSX3Copia[03,2]	,"","CTT"   ,1,aSX3Copia[03,3] ,"" ,"","" 	,"S" 	,"","" 				,"" 		,"" 		,""         ,""                 ,"",""			,"" 					,"","004" 		,"","S",.T.})
	Aadd(aSX3,{"CVD","07","CVD_TPUTIL"  ,"C",1 			    ,0  ,"Tp.Utiliz."       ,"Tp.Utiliz."       ,"Tp.Utiliz.  "     ,"Tipo de Utilizacao"               ,"Tipo de Utilizacao"              ,"Tipo de Utilizacao"               ,"@!"         	        ,"Pertence('F,S,A, ')"                                              ,aSX3Copia[02,2]    ,"",""     ,1,aSX3Copia[02,3] ,"" ,"" ,"" ,"S"    ,"V",""             ,""         ,""         ,"F=Fiscal;S=Societario;A=Ambos","F=Fiscal;S=Societario;A=Ambos"   ,"F=Fiscal;S=Societario;A=Ambos","",""                   ,"",""    ,"","S",.T.})
EndIf

//
// Atualizando CT1 (Plano de Contas) - Criando o campo CT1_NTSPED
//
Aadd(aSX3,{	"CT1",ProxSX3("CT1","CT1_NTSPED"),"CT1_NTSPED","C",02,0,"Nat. Conta"	,"Nat. Conta"		,"Nat. Conta"		,"Natureza da conta contabi"		,"Natureza da conta contabi"		,"Natureza da conta contabi"		,"@!"					,"Pertence('01,02,03,04,05,09')"									,"€€€€€€€€€€€€€€ "	,"",""		,1,"þÀ"				,"","",""	,"N"	,"",""				,""			,"","01=Conta de Ativo;02=Conta de Passivo;03=Patrimônio Líquido;04=Conta de Resultado;05=Conta de Compensação;09=Outras", "01=Conta de Ativo;02=Conta de Passivo;03=Patrimônio Líquido;04=Conta de Resultado;05=Conta de Compensação;09=Outras","01=Conta de Ativo;02=Contas de Passivo;03=Patrimônio Líquido;04=Contas de Resultado;05=Conta de Compensação;09=Outras"	,"","","","","","S"})
Aadd(aSX3,{ "CT1",ProxSX3("CT1","CT1_SPEDST"),"CT1_SPEDST","C",01,0,"SPED Sint."	,"SPED Sint."		,"SPED Sint."		,"SPED Conta Sintetica"     		,"SPED Conta Sintetica"     		,"SPED Conta Sintetica"				,"@!"					,"Pertence('1,2')"													,"€€€€€€€€€€€€€€ "	,"",""		,1,"þÀ"				,"","",""	,"N"	,"",""				,""			,"","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não"																																																																																,"","","","","","S"})

//
// Atualizando as tabelas CT2, CT5 e CTK - Criando os campos CTx_CODPAR (Codigo do Participante)
//
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_CODPAR"),"CT2_CODPAR"	,"C",06,0,"Cod.Partic."	,"Cod.Partic."		,"Participant"		,"Codigo do Participante"			,"Codigo do Participante"			,"Code of Participant"				,"@!"					,'ExistCPO("CVC")'													,"€€€€€€€€€€€€€€ "	,"","CVC"	,1,"þÀ"				,"","",""	,"S"	,"","","","","","","","","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_CODPAR"),"CT5_CODPAR"	,"C",06,0,"Cod.Partic."	,"Cod.Partic."		,"Participant"		,"Codigo do Participante"			,"Codigo do Participante"			,"Code of Participant"				,"@!"					,'ExistCPO("CVC")'													,"€€€€€€€€€€€€€€ "	,"","CVC"	,1,"þÀ"				,"","",""	,"S"	,"","","","","","","","","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_CODPAR"),"CTK_CODPAR"	,"C",06,0,"Cod.Partic."	,"Cod.Partic."		,"Participant"		,"Codigo do Participante"			,"Codigo do Participante"			,"Code of Participant"				,"@!"					,'ExistCPO("CVC")'													,"€€€€€€€€€€€€€€ "	,"","CVC"	,1,"þÀ"				,"","",""	,"S"	,"","","","","","","","","","","","","S"})

Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_FILIAL")	, "CVM_FILIAL"	, "C", nTamFilial	, 0, "Filial"        		, "Sucursal"	     	, "Branch"   	   		, "Filial do Sistema"	     							, "Sucursal del Sistema"      							, "System Branch"        	 							, "@!", ""	, aSX3Copia[01,2],   "" ,    ""		, 1 , aSX3Copia[01,3], "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", "", "", "033"	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_COD")		, "CVM_COD" 	, "C", 02			, 0, "Cod. do Diario"		, "Cod. do Diario" 		, "Cod. do Diario"		, "Cod. do Diario"     	     							, "Cod. do Diario"            							, "Cod. do Diario"     	     							, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_DESCR")	, "CVM_DESCR"  	, "C", 30			, 0, "Descricao "    		, "Descripcion"    		, "Description"   		, "Descricao do Diario" 	     						, "Descricao do Diario"       							, "Descricao do Diario"	     							, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_TIPOSE")	, "CVM_TIPOSE"	, "C", 01			, 0, "Tipo"          		, "Tipo"           		, "TIPO"          		, "Tipo do Controle do Diario"							, "Tipo do Controle do Diario"							, "Tipo do Controle do Diario"							, "@!", ""	, aSX3Copia[02,2],   "",     ""		, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, "0=Desabilitada;1=Ininterrupta;2=Mes;3=Ano\Exercicio;4=Periodo", "0=Desabilitada;1=Ininterrupta;2=Mes;3=Ano\Exercicio;4=Periodo", "0=Desabilitada;1=Ininterrupta;2=Mes;3=Ano\Exercicio;4=Periodo", "", "", "", ""   , "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_DTINI")	, "CVM_DTINI"	, "D", 08			, 0, "Data Inicio"   		, "Data Inicio"    		, "Data Inicio"   		, "Data Inicio do Controle"   							, "Data Inicio do Controle"   							, "Data Inicio do Controle"   							, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[02,2], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_DTFIM")	, "CVM_DTFIM"	, "D", 08			, 0, "Data Fim"      		, "Data Fim"       		, "Data Fim"      		, "Data Fim do Controle"  	 							, "Data Fim do Controle"      							, "Data Fim do Controle"  	 							, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_DTSEQ")	, "CVM_DTSEQ"	, "D", 08			, 0, "Data da Sequencia"	, "Data da Sequencia"	, "Data da Sequencia"	, "Data da ultima Sequencia" 							, "Data da ultima Sequencia"							, "Data da ultima Sequencia"							, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_SEQINI")	, "CVM_SEQINI"	, "C", 06			, 0, "Cod. Inicio"    		, "Cod Inicio"     		, "Cod Inicio"    		, "Codigo inicial desta sequencia"						, "Codigo inicial desta sequencia"						, "Codigo inicial desta sequencia"						, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_SEQULT")	, "CVM_SEQULT"	, "C", 06			, 0, "Cod. Fim"       		, "Cod. Fim"       		, "Cod. Fim"      		, "Ultimo codigo desta sequencia"  						, "Ultimo codigo desta sequencia" 						, "Ultimo codigo desta sequencia"						, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_INCRE")	, "CVM_INCRE"	, "N", 01			, 0, "Valor Padrao"   		, "Valor Padrao"   		, "Valor Padrao"  		, "Valor Padrao do incremento"	    					, "Valor Padrao do incremento"    						, "Valor Padrao do incremento"    						, "@!", ""	, aSX3Copia[02,2],   "1" ,   ""		, 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""	 				, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_RAD")		, "CVM_RAD"		, "C", 02			, 0, "Detalhamento"   		, "Detalhamento"   		, "Detalhamento"  		, "Detalhamento da quebra da sequencia"					, "Detalhamento da quebra da sequencia"					, "Detalhamento da quebra da sequencia"					, "@!", ""	, aSX3Copia[02,2],   "" ,    ""		, 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVM", ProxSX3("CVM","CVM_CALEND")	, "CVM_CALEND"	, "C", 03			, 0, "Calendario"     		, "Calendario"     		, "Calendario"    		, "Calendario contabil vinculado a sequencia do diario"	, "Calendario contabil vinculado a sequencia do diario"	, "Calendario contabil vinculado a sequencia do diario"	, "@!", ""	, aSX3Copia[02,2],   "" ,    "CTG"	, 1 , aSX3Copia[03,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})

Aadd(aSX3,{"CVL", ProxSX3("CVL","CVL_FILIAL")	, "CVL_FILIAL"	, "C", nTamFilial	, 0	, "Filial"        		, "Sucursal"	     	, "Branch"   	   		, "Filial do Sistema"	     	, "Sucursal del Sistema"      , "System Branch"      	, "@!"       , ""                       , aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", "", "", "033"	, "", "S"})
Aadd(aSX3,{"CVL", ProxSX3("CVL","CVL_COD")		, "CVL_COD"		, "C", 02			, 0	, "Cod. do Diario"		, "Cod. do Diario" 		, "Cod. do Diario"		, "Cod. do Diario"     	     	, "Cod. do Diario"            , "Cod. do Diario"		, "@!"       , "CVLValCod(M->CVL_COD)"	, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})
Aadd(aSX3,{"CVL", ProxSX3("CVL","CVL_DESCR")	, "CVL_DESCR"	, "C", 50			, 0	, "Descricao "    		, "Descripcion"    		, "Description"   		, "Descricao do Diario" 	 	, "Descricao do Diario"       , "Descricao do Diario"	, "@!"       , ""                       , aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S"})

Aadd(aSX3,{'CT2',ProxSx3('CT2','CT2_NODIA')		,'CT2_NODIA'	, "C", 10			, 0	," Seq. Diario"			," Sec. Diario"			," Tax Rec. Seq"		," Seq. Diario Contabilidade"	," Sec. diario Contabilidad"	," Acc. Tax Rec. Sequence"	," @!"	," "						, aSX3Copia[03,2],   " ",    " ", 1	, aSX3Copia[03,3]," "," "," "," ","V"	," "," "," "," "					," "					," "					," "," "," "," "	," ","S" })
Aadd(aSX3,{'CT2',ProxSx3('CT2','CT2_SEGOFI')	,'CT2_SEGOFI'	, "C", 10			, 0	,"Correlativo "			,"Correlativo "			,"Correlativo "			,"Numero Correlativo  "			,"Numero Correlativo  "			,"Numero Correlativo    "	," @!"	," "			  			, aSX3Copia[03,2],   " ",    " ", 1	, aSX3Copia[03,3]," "," "," "," ","V"	," "," "," "," "					," "					," "					," "," "," "," "	," ","S" })

Aadd(aSX3,{'CTK',ProxSx3('CTK','CTK_NODIA')		,'CTK_NODIA'	, "C", 10			, 0	," Seq. Diario"			," Sec. Diario"			," Tax Rec. Seq"		," Seq. Diario Contabilidade"	," Sec. diario Contabilidad"	," Acc. Tax Rec. Sequence"	," @!"," "														,aSX3Copia[03,2]," "												," "	,1	,aSX3Copia[03,3]," "," "," "," ","V"," "," "," "," "," "," "," "," "													," "," "," ","S"})
Aadd(aSX3,{'CTK',ProxSx3('CTK','CTK_DIACTB')	,'CTK_DIACTB'	, "C", 02			, 0	,"Cod Diario  "			,"Cod Diario  "			,"Tax Rec. Cd."			,"Cod Diario Contabilidade"		,"Cod Diario Contabilidad"		,"Accounting Tax Rec. Code"	," @!","IIF( FindFunction('VldCodSeq') , VldCodSeq() , .T. )"	,aSX3Copia[03,2],"IIF( FindFunction('CtbRDia') , CtbRDia() , '' )"	,"CVL"	,1	,aSX3Copia[03,3]," "," "," "," ","R"," "," "," "," "," "," "," ","IIF( FindFunction('CtbWDia') , CtbWDia() , .F. )"	," "," "," ","S"})
Aadd(aSX3,{'CT2',ProxSx3('CT2','CT2_DIACTB')	,'CT2_DIACTB'	, "C", 02			, 0	,"Cod Diario  "			,"Cod Diario  "			,"Tax Rec. Cd."			,"Cod Diario Contabilidade"		,"Cod Diario Contabilidad"		,"Accounting Tax Rec. Code"	," @!","IIF( FindFunction('VldCodSeq') , VldCodSeq() , .T. )"	,aSX3Copia[01,2],""													,"CVL"	,1	,aSX3Copia[01,3]," "," "," "," ","R"," "," "," "," "," "," "," ","AlwaysFalse()"		  								," "," "," ","S"})
Aadd(aSX3,{'CT5',ProxSx3('CT5','CT5_DIACTB')	,'CT5_DIACTB'	, "C", 50			, 0	,"Cod Diario  "			,"Cod Diario  "			,"Tax Rec. Cd."			,"Cod Diario Contabilidade"		,"Cod Diario Contabilidad"		,"Accounting Tax Rec. Code"	," @!","Ctb080Form()"											,aSX3Copia[03,2],""													,"CVL"	,1	,aSX3Copia[03,3]," "," "," "," ","R"," "," "," "," "," "," "," ","IIF( FindFunction('CtbWDia') , CtbWDia() , .F. )"	," "," "," ","S"})

//Tabela Dados Auxiliares CTB -CW0
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_FILIAL")	, "CW0_FILIAL"	, "C", nTamFilial	, 0	, "Filial"        		, "Sucursal"	     	, "Branch"   	   		, "Filial do Sistema"	     	, "Sucursal del Sistema"      	, "System Branch" 			, "@!", ""                                      				, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "",  "", "", "", "", ""	, ""					, ""					, ""					, "", "", "", "033"	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_TABELA")	, "CW0_TABELA"	, "C", 02			, 0	, "Tabela" 	  			, "Tabela" 				,"Tabela"				, "Tabela"     	     			, "Tabela"           			, "Tabela"    	     		, "@!", ""	  					  								, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_CHAVE")	, "CW0_CHAVE"	, "C", 15			, 0	, "Chave"     			, "Chave"    			, "Chave"   			, "Chave" 	     				, "Chave"       				, "Chave"	     			, "@!", "" 														, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_DESC01")	, "CW0_DESC01"	, "C", 150			, 0	, "Descric M1"    		, "Descric M1"    		, "Descric M1"   		, "Descricao Moeda 01" 	     	, "Descricao Moeda 01"        	, "Descricao Moeda 01" 		, "@!", "" 														, aSX3Copia[02,2],   "" ,    "", 1 , aSX3Copia[02,3], "", "", "", "S", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_DESC02")	, "CW0_DESC02"	, "C", 150			, 0	, "Descric M2"    		, "Descric M2"    		, "Descric M2"   		, "Descricao Moeda 02" 	     	, "Descricao Moeda 02"        	, "Descricao Moeda 02"		, "@!", "" 														, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_DESC03")	, "CW0_DESC03"	, "C", 150			, 0	, "Descric M3"    		, "Descric M3"    		, "Descric M3"   		, "Descricao Moeda 03" 	     	, "Descricao Moeda 03"        	, "Descricao Moeda 03" 		, "@!", ""														, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_DESC04")	, "CW0_DESC04"	, "C", 150			, 0	, "Descric M4"    		, "Descric M4"    		, "Descric M4"   		, "Descricao Moeda 04" 	     	, "Descricao Moeda 04"        	, "Descricao Moeda 04" 		, "@!", "" 														, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})
Aadd(aSX3,{"CW0", ProxSX3("CW0","CW0_DESC05")	, "CW0_DESC05"	, "C", 150			, 0	, "Descric M5"    		, "Descric M5"    		, "Descric M5"   		, "Descricao Moeda 05" 	     	, "Descricao Moeda 05"        	, "Descricao Moeda 05" 		, "@!", "" 														, aSX3Copia[01,2],   "" ,    "", 1 , aSX3Copia[01,3], "", "", "", "N", "", "", "", ""	, ""					, ""					, ""					, "", "", "", ""   	, "", "S",.T.})

Aadd(aSX3, {"CVQ", "01", "CVQ_FILIAL"	,"C", nTamFilial, 0	, "Filial"     		, "Sucursal"	, "Branch"       	, "Filial do Sistema"  			, "Sucursal do Sistema"			, "System Branch"     			, "@!"	, "" 														, "€€€€€€€€€€€€€€€"	, "", ""	, 1, "€€","","","","" ,"","","" ,"","","","","","","","033"	,"","S"})
Aadd(aSX3, {"CVQ", "02", "CVQ_CODIGO"	,"C", 3			, 0	, "Código"			, "Codigo"		, "Code"			, "Cod. quadro configurável"	, "Cod. cuadro configurable"	, "Code of configuring board"	, "@!"	,"ExistChav('CVQ',,1) .And. FreeForUse('CVQ',M->CVQ_CODIGO)", "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S"})
Aadd(aSX3, {"CVQ", "03", "CVQ_DESCRI"	,"C", 40		, 0	, "Descricao"		, "Descripcion"	, "Description"		, "Desc. quadro configurável"	, "Desc. cuadro configurable"	, "Desc. configuring board"		, ""	,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","S","","","","","","","","","","",""		,"","S"})
Aadd(aSX3, {"CVQ", "04", "CVQ_IMPTOT"	,"C", 1			, 0	, "Totalizador?"	, "¿Totalizad?"	, "Totalizer"		, "Imprime totalizador?"		, "¿Imprime totalizador?"		, "Print totalizer"				, "@!"	,"Pertence('12')"											, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","N","","","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","S"})
Aadd(aSX3, {"CVQ", "05", "CVQ_ITEM"		,"C", 3			, 0	, "Item"			, "Item"		, "Item"			, "Item quadro configurável"	, "Item cuadro configurable"	, "Chart item to configure"		, "@!"	,""															, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "„€","","","","N","V","","","","","","","","","",""		,"","S"})
Aadd(aSX3, {"CVQ", "06", "CVQ_DESCIT"	,"C", 40		, 0	, "Desc.Item"		, "Desc.Item"	, "Item Descr."		, "Descrição item"				, "Descripcion item"			, "Item description"			, "@!"	,"NaoVazio()"												, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "…€","","","","N","","","","","","","","","","",""		,"","S"})
Aadd(aSX3, {"CVQ", "07", "CVQ_CDVGIT"	,"C", 3			, 0	, "Cod.Vis.Ger."	, "Cod.Vis.Ges.", "Man.Vis.Cd."		, "Código Visão Gerencial"		, "Codigo Vision de  Gestion"	, "Manag. Vision Code"			, "@!"	,"Vazio() .Or. CTB115VLVIS()"								, "€€€€€€€€€€€€€€ "	, "", "CTS"	, 1, "„€","","","","N","A","","","","","","","","Empty(TMP->CVQ_FORMPA) .AND. Empty(TMP->CVQ_FORMPC)","","","","S"})
Aadd(aSX3, {"CVQ", "08", "CVQ_FORMPA"	,"C", 50		, 0	, "Frm.Per.Ant"		, "Frm.Per.Ant"	, "Form.PrevPer"	, "Form. período anterior"		, "Form. periodo anterior"		, "Form. previous period"		, "@!"	,"Vazio() .Or. Ctb277Form('N')"								, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "„€","","","","","","","","","","","","","Empty(TMP->CVQ_CDVGIT)","","","","S"})
Aadd(aSX3, {"CVQ", "09", "CVQ_FORMPC"	,"C", 50		, 0	, "Frm.Per.Cor."	, "Frm.Per.Cor.", "Frm.Cur.Per."	, "Form. período corrente"		, "Form. periodo corriente"	    , "Form current period"			, "@!"	,"Vazio() .Or. Ctb277Form('N')"								, "€€€€€€€€€€€€€€ "	, "", ""	, 1, "„€","","","","N","A","","","","","","","","Empty(TMP->CVQ_CDVGIT)","","","","S"})

// Moedas Contabeis - Vingencia
aAdd(aSX3, {"CTO","11","CTO_DTINIC"		,"D",8			, 0	, "Dt Inicial"		,"Dt. Inicial"	,"Dt. Inicial"		,"Data Inicial de Vigencia"		,"Data Inicial de Vigencia"		,"Data Inicial de Vigencia"		,""	,"CtbVigenc()"		,aSX3Copia[03,2]	,"","",1,aSX3Copia[03,3]  ,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
aAdd(aSX3, {"CTO","12","CTO_DTFINA"		,"D",8			, 0	, "Dt Final"		,"Dt. Final"	,"Dt. Final"		,"Data Final de Vigencia"	   	,"Data Final de Vigencia"	   	,"Data Final de Vigencia"		,""	,"CtbVigenc()"		,aSX3Copia[03,2]	,"","",1,aSX3Copia[03,3]  ,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})

// CTA - Regras de Amarração
aAdd(aSX3, {"CTA" ,"05","CTA_ITREGR" 	,"C",4  		, 0 , "Item regra"   	,"Regla tema"  	,"Item rule"    	,"Item sequencia da regra"  	,"Elem. de regla de secuenc" 	,"Item sequence rule"        	,"" ,"" ,"€€€€€€€€€€€€€€ " ,"","" ,1 ,"" ,"" ,"" ,"" ,"N" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" 	,"" ,"S"})
aAdd(aSX3, {"CTA" ,"06","CTA_CONTA"  	,"C",nTamConta 	, 0 , "Conta Contab" 	,"Cuenta cont."	,"account acc." 	,"Codigo da conta contabil" 	,"Codigo de cuenta contable" 	,"Account number accountant" 	,"" ,"" ,"€€€€€€€€€€€€€€ " ,"","" ,1 ,"" ,"" ,"" ,"" ,"N" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"003"	,"" ,"S"})
aAdd(aSX3, {"CTA" ,"07","CTA_CUSTO"  	,"C",nTamCCusto	, 0 , "Centro Custo" 	,"Centro coste"	,"Cost center"  	,"Centro de Custo"          	,"Centro de coste"           	,"Cost Center"               	,"" ,"" ,"€€€€€€€€€€€€€€ " ,"","" ,1 ,"" ,"" ,"" ,"" ,"N" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"004"	,"" ,"S"})
aAdd(aSX3, {"CTA" ,"08","CTA_ITEM"	 	,"C",nTamItCont	, 0 , "Item Contabi" 	,"Tema Contabil","Item Acc."    	,"Item Contabil"            	,"Tema Contabil"             	,"Item accounting"           	,"" ,"" ,"€€€€€€€€€€€€€€ " ,"","" ,1 ,"" ,"" ,"" ,"" ,"N" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"005"	,"" ,"S"})
aAdd(aSX3, {"CTA" ,"09","CTA_CLVL"	 	,"C",nTamClVlr	, 0 , "Classe Valor" 	,"Clase valor"	,"Class Value"  	,"Classe de Valor"          	,"Clase de valor"            	,"Class Value"               	,"" ,"" ,"€€€€€€€€€€€€€€ " ,"","" ,1 ,"" ,"" ,"" ,"" ,"N" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"006"	,"" ,"S"})

// CTA - Regras de Amarração (Help)
aPHelpPor := { "Informe Item sequencia da regra." }
PutHelp( "PCTA_ITREGR", aPHelpPor, aPHelpPor, aPHelpPor, .T. )

aPHelpPor := { "Informe o código da conta contábil." }
PutHelp( "PCTA_CONTA", aPHelpPor, aPHelpPor, aPHelpPor, .T. )

aPHelpPor := { "Informe Centro de Custo." }
PutHelp( "PCTA_CUSTO", aPHelpPor, aPHelpPor, aPHelpPor, .T. )

aPHelpPor := { "Informe Centro de Custo." }
PutHelp( "PCTA_ITEM", aPHelpPor, aPHelpPor, aPHelpPor, .T. )

aPHelpPor := { "Informe Item Contábil." }
PutHelp( "PCTA_CLVL", aPHelpPor, aPHelpPor, aPHelpPor, .T. )

// Visão Gerencial - Alteração no tamanho do campos
If cPaisLoc $ "COL|PER"
	// Visão Gerencial - Alteração no tamanho do campos
	aAdd(aSX3, {"CTS","11","CTS_NOME"	,"C"	,80	,0	,"Nome Visao"	,"Nomb. Vision"	,"View Name"	,"Nome da Visao Gerencial"	,"Nombre Vision Gerencial"	,"Management View Name"		,"@!"		,""					,"€€€€€€€€€€€€€€€"	,"",""		,1,"‚€"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
	aAdd(aSX3, {"CTS","12","CTS_FORMUL"	,"C"	,80	,0	,"Formula"		,"Formulal"		,"Formula"		,"Formula digitada"			,"Formula que sera digitada","Formula to be entered"	,"@S40"		,""					,"€€€€€€€€€€€€€€€"	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"","S"	})
	
	// Demonstrativos fiscais/tributarios em arquivos eletronicos.
	//
	// Cadastro de Municipios - Ajuste no tamanho do campo CC2_CODMUN   
	aAdd(aSX3, {"CC2","02","CC2_CODMUN"	,"C",005,0,"Municipio"		,"Municipio"		,"City"			,"Codigo de Municipio"			,"Codigo de Municipio"			,"City Code"				,"@9" 			,"ExistChav('CC2',M->CC2_EST+M->CC2_CODMUN)"	,"€€€€€€€€€€€€€€ "	,"",""		,1,"…€"	,""	,"S","","S"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	// Cadastro de Clientes - Criação dos campos A1_NOMESEG, A1_NOMEMAT e A1_NOMEPAT   
	If cPaisLoc == "PER"
		aAdd(aSX3, {"SA1","09","A1_COD_MUN"	,"C",005,0,"Cd.Municipio"	,"Cd.Municipio"		,"City Code"	,"Código do Municipio"			,"Codigo del Municipio"			,"Code of City"				,"@!" 			,"ExistCpo('CC2',M->A1_EST+M->A1_COD_MUN)"		,"€€€€€€€€€€€€€€ "	,"","CODMUN",1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	Else
		aAdd(aSX3, {"SA1","09","A1_COD_MUN"	,"C",005,0,"Cd.Municipio"	,"Cd.Municipio"		,"City Code"	,"Código do Municipio"			,"Codigo del Municipio"			,"Code of City"				,"@!" 			,"ExistCpo('CC2',M->A1_EST+M->A1_COD_MUN)"		,"€€€€€€€€€€€€€€ "	,"","CC2SA1",1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	EndIf
	aAdd(aSX3, {"SA1","J8","A1_NOMEPES"	,"C",015,0,"Segundo nome"	,"Segundo nomb"		,"2nd Fam.Nm."	,"Segundo nome"					,"Segundo nombre"				,"Second Name"				,"@!"  			,""												,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA1","J9","A1_NOMEMAT"	,"C",015,0,"Pri.Sobrenom"	,"Pri.Apellido"		,"1st Fam.Nm."	,"Primeiro sobrenome"			,"Primer apellido"				,"First Family Name"		,""	   			,""												,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA1","JA","A1_NOMEPAT"	,"C",015,0,"Seg.Sobrenom"	,"Seg.Apellido"		,"2nd Fam.Nm."	,"Segundo sobrenome"			,"Segundo apellido"				,"Second Family Name"		,"@!"  			,""												,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA1","JB","A1_TIPDOC"	,"C",002,0,"Tipo Doc."		,"Tipo Doc."		,"Doc. Type"	,"Tipo Documento Identidade"	,"Tipo Documento Identidad"		,"Identity Document Type"	,""	   			,"ExistCpo('SX5','TB'+M->A1_TIPDOC)"			,"€€€€€€€€€€€€€€ "	,"","TB"	,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})

	// Cadastro de Forncedores - Criação dos campos A2_NOMESEG, A2_NOMEMAT e A2_NOMEPAT   
	aAdd(aSX3, {"SA2","09","A2_COD_MUN"	,"C",005,0,"Cod. Municip"	,"Cod. Municip"		,"City Code"	,"Codigo do Municipio"			,"Codigo del Municipio"			,"City Code"				,"@!" 			,"ExistCpo('CC2',M->A2_EST+M->A2_COD_MUN,1)"	,"€€€€€€€€€€€€€€ "	,"","CC2SA2",1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA2","E6","A2_NOMEPES"	,"C",015,0,"Segundo nome"	,"Segundo nomb"		,"2nd Name"		,"Segundo nome"					,"Segundo nombre"				,"Second Name"				,"@!" 			,""				   								,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA2","E7","A2_NOMEMAT"	,"C",015,0,"Pri.Sobrenom"	,"1er Apellido"		,"1st Surname"	,"Primeiro sobrenome"			,"Primer apellido"				,"1st Surname"				,"@!" 			,""				  								,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA2","E8","A2_NOMEPAT"	,"C",015,0,"Seg.Sobrenom"	,"Seg.Apellido"		,"2nd Surname"	,"Segundo sobrenome"			,"Segundo apellido"				,"2nd Surname"				,"@!"			,""				   								,"€€€€€€€€€€€€€€ "	,"",""		,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
	aAdd(aSX3, {"SA2","E9","A2_TIPDOC"	,"C",002,0,"Tipo Doc."		,"Tipo Doc."		,"Doc. Type"	,"Tipo Documento Identidade"	,"Tipo Documento Identidad"		,"Identity Document Type"	,""	  			,"ExistCpo('SX5','TB'+M->A2_TIPDOC)"			,"€€€€€€€€€€€€€€ "	,"","TB"	,1,"’A"	,""	,""	,"","N"	,""	,""	,""	,"",""				,""			,""			,""			,""		,"",""		,"1","S",.T.	})
               
	// Cadastro de Entidades - Criação de campos.   
	aAdd(aSX3, {"CV0","17","CV0_TIPO00" ,"C"	,02	,0	,"Tip Terceiro","Tip Tercero"	,"3rdPartyType" ,"Tipo de Terceiro"				,"Tipo de Tercero"			  	,"Type of third Party"			,"@!"		  ,"ExistCpo('CW0','C1'+M->CV0_TIPO00)"		 		,"€€€€€€€€€€€€€€ " ,"","CW0TER",1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CV0","18","CV0_TIPO01" ,"C"	,06	,0	,"Tp Doc. Terc","Tp Doc. Terc"	,"3rdPrtyDocTp"	,"Tipo do Docto do Terceiro"  	,"Tipo de Docto de Tercero"		,"Third Party Document Type"   	,"@!"         ,"ExistCpo('SX5','TB'+M->CV0_TIPO01)"        		,"€€€€€€€€€€€€€€ " ,"","TB"	   ,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})

	// Cadastro de Participantes - Criação e alteração no tamanho dos campos.   
	aAdd(aSX3, {"CVC","07","CVC_PAIS"	,"C",005,0,"Codigo Pais"	,"Codigo Pais"		,"Country Cd."	,"Codigo do Pais"				,"Codigo del Pais"				,"Country Code"				,"@!" 			,"Vazio() .OR. ExistCPO('SYA',M->CVC_PAIS)"		,"€€€€€€€€€€€€€€ " ,"","SYA"	,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","09","CVC_UF"		,"C",002,0,"Estado"			,"Est/Prov/Reg"		,"State"		,"Estado"						,"Estado/Provincia/Region"		,"State"					,"@!" 			,"ExistCpo('SX5','12'+M->CVC_UF)"          		,"€€€€€€€€€€€€€€ " ,"",""  		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","12","CVC_CODMUN"	,"C",005,0,"Cod. Munic."	,"Cod. Munic."		,"City Code"	,"Código do Municipio"			,"Codigo del Municipio"			,"City Code"				,"@!" 			,"ExistCpo('CC2',M->CVC_UF + M->CVC_CODMUN)"    ,"€€€€€€€€€€€€€€ " ,"","CC2CVC"	,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","17","CVC_2NOME"	,"C",015,0,"2o. Nome"		,"2o.Nombre"		,"2nd Name"		,"Segundo Nome"					,"Segundo Nombre"				,"Second Name"				,"@!" 			,""		  										,"€€€€€€€€€€€€€€ " ,"",""  		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","18","CVC_1SNOME"	,"C",015,0,"1o.Sobrenome"	,"1er.Apellido"		,"1st Surname"	,"Primeiro Sobrenome"			,"Primer Apellido"				,"First Surname"			,"@!" 			,""		  										,"€€€€€€€€€€€€€€ " ,"","" 		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","19","CVC_2SNOME"	,"C",015,0,"2o.Sobrenome"	,"2do.Apellido"		,"2nd Surname"	,"Segundo Sobrenome"			,"Segundo Apellido"				,"Second Surname"			,"@!" 			,""		   										,"€€€€€€€€€€€€€€ " ,"",""  		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","20","CVC_TIPDOC"	,"C",002,0,"Tipo Documen"	,"Tipo Documen"		,"Tp.Document"	,"Tipo do Documento"			,"Tipo del Documento"			,"Type of Document"			,"@!" 			,"ExistCpo('SX5','TB'+M->CVC_TIPDOC)"			,"€€€€€€€€€€€€€€ " ,"","TB"		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","21","CVC_END"	,"C",040,0,"Endereco"		,"Direccion"		,"Address"		,"Endereco"						,"Direccion"					,"Address"					,"@!" 			,""           									,"€€€€€€€€€€€€€€ " ,"",""  		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","22","CVC_MUNIC"	,"C",040,0,"Municipio"		,"Municipio"		,"City"			,"Nome do Municipio"			,"Nombre del municipio"			,"City Name"				,"@!"			,""   											,"€€€€€€€€€€€€€€ " ,"",""   	,1,"’A","","","","N","","V","","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVC","23","CVC_PARTIC"	,"N",006,2,"% Part."		,"% Part."			,"Participn%"	,"Percentual Participação" 		,"Porcentaje participacion"		,"Participation Percentage"	,"@E 999.99"	,"NaoVazio()"									,"€€€€€€€€€€€€€€ " ,"",""  		,1,"’A","","","","N","","","","","","","","","","","","","S",.T.})

	// Plano de Contas Referenciais - Criação e alteração de campos.   
	aAdd(aSX3, {"CVD","04","CVD_CODPLA"	,"C",006,0,"Plano Ref."		,"Plan Ref."		,"Ref. Plan"	,"Codigo plano referencial"		,"Codigo plan referencial"		,"Referential plan code"	,"@!"			,"Vazio() .OR. ExistCpo('CVN',M->CVD_CODPLA,1)"	,"€€€€€€€€€€€€€€ ","","CVN1",1,"“€","","","","N","","","S","","","","","","","","","","S",.T.})
	aAdd(aSX3, {"CVD","07","CVD_COLUNA"	,"C",002,0,"Coluna"			,"Columna"			,"Column"		,"Numero da Coluna"				,"Numero de la Columna"			,"Column Number"			,"99"			,"NaoVazio()"									,"€€€€€€€€€€€€€€ ","","",1,"“€","","","","N","","","S","","","","","","","","","","S",.T.	})

	// Plano de Contas Referencial - Alteração no tamanho do campos CVD_CODPLA e CVN_CODPLA   
	Aadd(aSX3, {"CVN","01","CVN_FILIAL" ,"C",nTamFilial	,0,"Filial"      	,"Filial"      		,"Filial"      	,"Filial do sistema"          	,"Filial do sistema"          	,"Filial do sistema"        ,"@!"               ,""                                                                               	,"€€€€€€€€€€€€€€ ","",""        ,1  ,"“€",""    ,"" ,"","N" ,""     ,"" ,""     ,"" ,"","","","","",""  ,"033"  ,"","S",.T.})
	aAdd(aSX3, {"CVN","02","CVN_CODPLA"	,"C",006		,0,"Plano Ref."		,"Plan Ref."		,"Ref. Plan"	,"Codigo plano referencial"		,"Codigo plan referencial"		,"Referential plan code"	,"@!"				,"NaoVazio() .And. ExistChav('CVN',M->CVN_CODPLA)"  								,"€€€€€€€€€€€€€€ ","",""    	,1	,"“€",""	,"" ,"","N"	,""		,""	,""	    ,""	,""	,"","","","",""	,""		,"","S",.T.})
	aAdd(aSX3, {"CVN","03","CVN_DSCPLA"	,"C",040		,0,"Descr.P.Ref"	,"Descr.P.Ref"		,"Ref.Plan Des"	,"Descricao plano referenci"	,"Descrip. plan referenc."		,"Referenc.plan description","@!S20"	   		,"NaoVazio()"                                                                     	,"€€€€€€€€€€€€€€ ","",""      	,1 	,"“€","" 	,"" ,"","N" ,""  	,"" ,"" 	,"" ,""	,"","","","",""	,""    	,"","S",.T.})
	aAdd(aSX3, {"CVN","04","CVN_DTVIGI"	,"D",008		,0,"Dt.Vig.Inic."	,"Fch.Vig.Inic"		,"Start Eff.Dt"	,"Data vigencia inicial"		,"Fecha vigencia inicial"		,"Start effectiveness date"	,""			   		,"Vazio() .OR. IIF(!EMPTY(M->CVN_DTVIGF),(M->CVN_DTVIGF >= M->CVN_DTVIGI),.T.)"   	,"€€€€€€€€€€€€€€ ","",""      	,1 	,"“€","" 	,"" ,"","N" ,""  	,"" ,"" 	,"" ,""	,"","","","",""	,""    	,"","S",.T.})
	aAdd(aSX3, {"CVN","05","CVN_DTVIGF"	,"D",008		,0,"Dt.Vig.Fim"		,"Fch.Vig.Fin"		,"End Eff.Date"	,"Data vigencia final"			,"Fecha vigencia final"			,"End effectiveness date"	,""			   		,"Vazio() .OR. IIF(!EMPTY(M->CVN_DTVIGF),(M->CVN_DTVIGF >= M->CVN_DTVIGI),.T.)"   	,"€€€€€€€€€€€€€€ ","",""      	,1 	,"“€","" 	,"" ,"","N" ,""  	,"" ,"" 	,"" ,""	,"","","","",""	,""    	,"","S",.T.})
	aAdd(aSX3, {"CVN","06","CVN_ENTREF"	,"C",002		,0,"Entidade"		,"Ente"				,"Entity"		,"Codigo da entidade"			,"Codigo del ente"				,"Entity Code"				,"@!"		   		,"ExistCpo('SX5','GP'+M->CVN_ENTREF)"                                             	,"€€€€€€€€€€€€€€ ","","GP"    	,1 	,"“€","" 	,"" ,"","N" ,""  	,"" ,"" 	,"" ,""	,"","","","",""	,""    	,"","S",.T.})
	aAdd(aSX3, {"CVN","07","CVN_LINHA"	,"C",nCVNLinha	,0,"Linha"			,"Linea"			,"Line"			,"Linha"						,"Linea"						,"Line"						,cPicCVNLinha		,"NaoVazio()"                                                             			,"€€€€€€€€€€€€€€ ","",""      	,1 	,"“€","" 	,"" ,"","N" ,"V" 	,"" ,"" 	,"" ,""	,"","","","",""	,""    	,"","S",.T.})
	aAdd(aSX3, {"CVN","08","CVN_CTAREF"	,"C",nTamCtaRef	,0,"Conta Ref."		,"Cuenta Ref."		,"Ref.Account"	,"Codigo conta referencial"		,"Codigo cuenta referencial"	,"Refer.account code"		,"@!"				,"NaoVazio()"    																	,"€€€€€€€€€€€€€€ ","",""      	,1 	,"“€","" 	,"" ,"","N" ,""  	,"" ,"" 	,"" ,""	,"","","","",""	,"027" 	,"","S",.T.})
	aAdd(aSX3, {"CVN","09","CVN_DSCCTA"	,"C",160		,0,"Descr.C.Ref."	,"Descr.C.Ref."		,"Ref.Acc.Desc"	,"Descricao conta referenci"	,"Descripcion cta referenc"		,"Refer.Account Description","@!S60"	   		,"NaoVazio()" 																		,"€€€€€€€€€€€€€€ ","",""    	,1	,"“€",""	,"" ,"","N"	,""		,""	,""	,""	,""	,"","","","",""	,""		    ,"","S",.T.})
EndIf

// controle de hora de lançamento para portugal - SAFT-PT
IF cPaisLoc == 'PTG'
	aAdd(aSX3     ,{	"CT2", ProxSX3("CT2","CT2_HORALC"), "CT2_HORALC", "C", 8, 0, "Hora Lcto.", "Hora Lcto.","Hora Lcto.", "Hora do Lançamento", "Hora do Lançamento", "Hora do Lançamento"     		, "@99:99:99"  , ""						, aSX3Copia[01][2]	, "Time()"    						, "", 1 , aSX3Copia[01][3]	, "", "" , "", "", ""	, "" , "", "", ""																				, ""	, "", "", ""				, "","", "", "S",.T.})
Endif

If SX3->(DbSeek("CV0_TIPO00"))
	If Alltrim(SX3->X3_VALID) == "ExistCpo('CW0','C1'+M->CV0_TIPO01)"
		RecLock("SX3", .F.)
		SX3->X3_VALID := "ExistCpo('CW0','C1'+M->CV0_TIPO00)"
		MsUnlock()
	Endif
Endif

If SX3->(DbSeek("CV0_TIPO01"))
	If Alltrim(SX3->X3_VALID) == "ExistCpo('SX5','TB'+M->CV0_TIPO02)"
		RecLock("SX3", .F.)
		SX3->X3_VALID := "ExistCpo('SX5','TB'+M->CV0_TIPO01)"
		MsUnlock()
	Endif
Endif


// alteração do campos CT2_CODCLI
If SX3->(DbSeek("CT2_CODCLI"))
	If Empty(SX3->X3_VALID)
		RecLock("SX3", .F.)
		SX3->X3_ORDEM	:= ProxSX3("CT2","CT2_CODCLI")
		SX3->X3_F3		:= ''
		SX3->X3_GRPSXG	:= ''    

		If cPaisLoc == 'PTG'
			SX3->X3_USADO	:= aSX3Copia[2,2]
			SX3->X3_RESERV	:= aSX3Copia[2,3]
		Else
			SX3->X3_USADO	:= aSX3Copia[6,2]
			SX3->X3_RESERV	:= aSX3Copia[6,3]
		Endif

		MsUnlock()
	Endif
Endif

// alteração do campos CT2_CODFOR
If SX3->(DbSeek("CT2_CODFOR"))
	If Empty(SX3->X3_VALID)
		RecLock("SX3", .F.)
		SX3->X3_ORDEM	:= ProxSX3("CT2","CT2_CODFOR")
		SX3->X3_F3		:= ''
		SX3->X3_GRPSXG	:= ''

		If cPaisLoc == 'PTG'
			SX3->X3_USADO	:= aSX3Copia[2,2]
			SX3->X3_RESERV	:= aSX3Copia[2,3]
		Else
			SX3->X3_USADO	:= aSX3Copia[6,2]
			SX3->X3_RESERV	:= aSX3Copia[6,3]
		Endif

		MsUnlock()
	Endif
Endif

// alteração do campos CT5_CODCLI
If SX3->(DbSeek("CT5_CODCLI"))
	If Empty(SX3->X3_VALID)
		RecLock("SX3", .F.)
		SX3->X3_ORDEM	:= '50'
		SX3->X3_TAMANHO	:= 200
		SX3->X3_VALID	:= "Vazio() .Or. Ctb080Form()"
		SX3->X3_F3		:= ''
		SX3->X3_GRPSXG	:= ''

		If cPaisLoc == 'PTG'
			SX3->X3_USADO	:= aSX3Copia[2,2]
			SX3->X3_RESERV	:= aSX3Copia[2,3]
		Else
			SX3->X3_USADO	:= aSX3Copia[6,2]
			SX3->X3_RESERV	:= aSX3Copia[6,3]
		Endif

		MsUnlock()
	Endif
Endif

// alteração do campos CT5_CODFOR
If SX3->(DbSeek("CT5_CODFOR"))
	If Empty(SX3->X3_VALID)
		RecLock("SX3", .F.)
		SX3->X3_ORDEM	:= '51'
		SX3->X3_TAMANHO	:= 200
		SX3->X3_VALID	:= "Vazio() .Or. Ctb080Form()"
		SX3->X3_F3		:= ''

		If cPaisLoc == 'PTG'
			SX3->X3_USADO	:= aSX3Copia[2,2]
			SX3->X3_RESERV	:= aSX3Copia[2,3]
		Else
			SX3->X3_USADO	:= aSX3Copia[6,2]
			SX3->X3_RESERV	:= aSX3Copia[6,3]
		Endif

		MsUnlock()
	Endif
Endif

If cPaisLoc $ "BRA"       
	SX3->( DbSetOrder(2) )        
	If SX3->(DbSeek("CT2_CODPAR"))
		If SX3->X3_RESERV != "„À"
			RecLock("SX3", .F.)
			SX3->X3_RESERV := "„À"
			MsUnlock()			
		Endif       			
	Endif
	If SX3->(DbSeek("CT5_CODPAR"))
		If SX3->X3_RESERV != "„À"
			RecLock("SX3", .F.)
			SX3->X3_RESERV := "„À"
			MsUnlock()			
		Endif       			
	Endif
	If SX3->(DbSeek("CTK_CODPAR"))
		If SX3->X3_RESERV != "„À"
			RecLock("SX3", .F.)
			SX3->X3_RESERV := "„À"
			MsUnlock()			
		Endif       			
	Endif		
Endif 

/* Campos para os lancamentos complementares */
If cPaisLoc $ "PER|COL"
	/*
	Campos para os lancamentos complementares */
	aAdd(aSX3,{"CT1",ProxSX3("CT1","CT1_LCCMPL"),"CT1_LCCMPL","C",01,0,"Lanc. Compl.","Asiento Compl.","Asiento Compl.","Lancamento complementar","Asiento complementar","Asiento complementar","@!","Vazio() .Or. Pertence('12')",aSX3Copia[03][2],"'2'","",1,aSX3Copia[03][3],"","","","N","A","R","","","1=Sim;2=Nao","1=Si;2=No","1=yes;2=No","","","","","","S"})
	aAdd(aSX3,{"CT1",ProxSX3("CT1","CT1_CTPART"),"CT1_CTPART","C",TamSX3("CT1_CONTA")[1],0,"Cta Partida","Cta Patida","Cta Patida","Cta compl. partida","Cta compl. partida","Cta compl. partida","@!","Vazio() .or. ExistCpo('CT1',M->CT1_CTPART,1)",aSX3Copia[03][2],"","CT1",1,aSX3Copia[03][3],"","","","N","A","R","","","","","","","(M->CT1_LCCMPL == '1')","","003","","S"})
	aAdd(aSX3,{"CT1",ProxSX3("CT1","CT1_CTPART"),"CT1_CTCPAR","C",TamSX3("CT1_CONTA")[1],0,"Cta.Ctr.part.","Cta.Ctr.part.","Cta.Ctr.part.","Cta compl. contra-partida","Cta compl. contra-partida","Cta compl. contra-partida","@!","Vazio() .or. ExistCpo('CT1',M->CT1_CTCPAR,1)",aSX3Copia[03][2],"","CT1",1,aSX3Copia[03][3],"","","","N","A","R","","","","","","","(M->CT1_LCCMPL == '1')","","003","","S"})
	/*
	Ajustes no tamanho da 5a entidade contabil */
	nPosTam := Ascan(aEstrut,"X3_TAMANHO")
	nPosGrp := Ascan(aEstrut,"X3_GRPSXG")
	SX3->( DbSetOrder(2) )
	If SX3->(DbSeek("CT2_EC05DB"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	If SX3->(DbSeek("CT2_EC05CR"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	/**/
	If SX3->(DbSeek("CTK_EC05DB"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	If SX3->(DbSeek("CTK_EC05CR"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	/**/
	If SX3->(DbSeek("CV3_EC05DB"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	If SX3->(DbSeek("CV3_EC05CR"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			aCpos[nPosGrp] := "040"
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	If SX3->(DbSeek("CV0_CODIGO"))
		If SX3->(FieldGet(FieldPos("X3_TAMANHO"))) < 16
			aCpos := {}
			For i := 1 To Len(aEstrut)-1
				Aadd(aCpos,SX3->(FieldGet(FieldPos(aEstrut[i]))))
			Next
			aCpos[nPosTam] := If(cPaisLoc=="COL",15,16)
			Aadd(aCpos,.T.)
			Aadd(aSX3,Aclone(aCpos))
		Endif
	Endif
	//AJUSTE NO CAMPO NATUREZA DA CONTA -> COLOCAR COMO USADO COMO PADRAO
	If SX3->(DbSeek("CT1_NATCTA"))
		If SX3->X3_USADO != "€€€€€€€€€€€€€€ ".And. SX3->X3_RESERV != "þÀ"
			RecLock("SX3", .F.)
			SX3->X3_USADO := "€€€€€€€€€€€€€€ "
			SX3->X3_RESERV := "þÀ"
			MsUnlock()
		Endif
	Endif
ElseIf cPaisLoc == "COL"
	//Ajuste nos campos A1_NREDUZ e A2_NREDUZ, colocar-los como disponivel no Browse.	
	If SX3->(DbSeek("A1_NREDUZ"))
		If SX3->X3_BROWSE != "S"
			RecLock("SX3", .F.)
			SX3->X3_BROWSE := "S"
			MsUnlock()
		Endif
	Endif
	If SX3->(DbSeek("A2_NREDUZ"))
		If SX3->X3_BROWSE != "S"
			RecLock("SX3", .F.)
			SX3->X3_BROWSE := "S"
			MsUnlock()
		Endif
	Endif
Endif
aAdd(aSX3, {"CT0","01","CT0_FILIAL" ,"C" ,nTamFilial ,0 ,"Filial"      ,"Sucursal"    ,"Branch"      ,"Filial"                  ,"Sucursal"                 ,"Branch"              ,""  ,"","€€€€€€€€€€€€€€€","",""      ,1,"„€","","","","","" ,"","","",""           ,""         ,""            ,"",""                                   ,"","033","","N",.T.})
aAdd(aSX3, {"CT0","02","CT0_ID"     ,"C" ,2          ,0 ,"ID"          ,"ID"          ,"ID"          ,"Item da Configuração"    ,"Item de Configuracion"    ,"Configuration Item"  ,"@!","","€€€€‚€€€€€€€€€€","",""      ,1,"O€","","","","","V","","","",""           ,""         ,""            ,"",""                                   ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","03","CT0_DESC"   ,"C" ,30         ,0 ,"Descrição"   ,"Descripcion" ,"Description" ,"Descrição da Entidade"   ,"Descripcion de la Entidad","Entity Description"  ,"@!","","€€€€‚€€€€€€€€€€","",""      ,1,"×€","","","","","" ,"","","",""           ,""         ,""            ,"",""                                   ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","04","CT0_CONTR"  ,"C" ,1          ,0 ,"Controla"    ,"Controla"    ,"Control"     ,"Controla Entidade"       ,"Controla Entidad"         ,"Control Entity"      ,"@!","","€€€€‚€€€€€€€€€€","",""      ,1,"C€","","","","","" ,"","","","1=Sim;2=Nao","1=Si;2=No","1=Yes; 2=No" ,"",""                                   ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","05","CT0_ALIAS"  ,"C" ,3          ,0 ,"Tabela"      ,"Tabla"       ,"Table"       ,"Tabela Relacionada"      ,"Tabla Relacionada"        ,"Related tabel"       ,"@!","","€€€€‚€€€€€€€€€€","","HSPSX2",1,"C€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"					   ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","06","CT0_ENTIDA" ,"C" ,2          ,0 ,"Entid. Plano","Entid. Plan" ,"Entit. Plan" ,"Código da Entidade"      ,"Codigo de Entidad"        ,"Company Code"        ,"@!","","€€€€‚€€€€€€€€€€","","CV0"   ,1,"Æ€","","","","","V" ,"","","",""           ,""         ,""            ,"",""                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","07","CT0_OBRIGA" ,"C" ,1          ,0 ,"Obrigatório" ,"Obligatorio" ,"Compulsory"  ,"Obrigatório"             ,"Obligatorio"              ,"Compulsory"          ,"@!","","€€€€‚€€€€€€€€€€","",""      ,1,"C€","","","","","" ,"","","","1=Sim;2=Nao","1=Si;2=No","1=Yes; 2=No" ,"",""                                   ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","08","CT0_CPOCHV" ,"C" ,10         ,0 ,"Campo Chave" ,"Campo clave" ,"Key field"   ,"Campo chave"             ,"Campo clave"              ,"Key field"           ,"@!","","€€€€€€€€€€€€€€ ","",""      ,1,"C€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","09","CT0_CPODSC" ,"C" ,10         ,0 ,"Desc. Chave" ,"Desc. Clave" ,"Key Desc."   ,"Descrição Chave"         ,"Descripción Clave"        ,"Key Description"     ,"@!","","€€€€€€€€€€€€€€ ","",""      ,1,"C€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","10","CT0_CPOSUP" ,"C" ,10         ,0 ,"Cod Ent Sup" ,"Cod Ent Sup" ,"Cod Ent Sup" ,"Código Entidade Superior","Código Entidad Superior"  ,"Code Superior Entity","@!","","€€€€€€€€€€€€€€ ","",""      ,1,"Æ€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","11","CT0_GRPSXG" ,"C" ,3          ,0 ,"Grp. Campos" ,"Grp. Campos" ,"Grp. Fields" ,"Grupo de Campos"         ,"Grupo de Campos"          ,"Group of Fields"     ,"@!","","€€€€€€€€€€€€€€ ","",""      ,1,"Æ€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","12","CT0_F3ENTI" ,"C" ,5          ,0 ,"Cons. Padrão","Cons. Estánd","Stand. Query","Consulta Padrão"         ,"Consulta Estándar"        ,"Standard Query"      ,"@!","","€€€€€€€€€€€€€€ ","",""      ,1,"Æ€","","","","","" ,"","","",""           ,""         ,""            ,"","CTB800WHEN()"                       ,"",""   ,"","N",.T.})
aAdd(aSX3, {"CT0","13","CT0_DSCRES" ,"C" ,10         ,0 ,"Desc. Resum.","Breve Desc." ,"Brief Desc." ,"Descrição Resumida"      ,"Breve Decripción"         ,"Brief Description"   ,"@!","","€€€€€€€€€€€€€€ ","",""      ,1,"C€","","","","","" ,"","","",""           ,""         ,""            ,"",""                                   ,"",""   ,"","N",.T.})

// Help dos campos da CT0
aPHelpPor := { "Código da Filial do Sistema." }
aPHelpSpa := { "Codigo de la Sucursal del Sistema." }
aPHelpEng := { "System Branch Code" }
PutHelp( "PCT0_FILIAL", aPHelpPor, aPHelpEng, aPHelpSpa , .T. )

aPHelpPor := { "Item sequencial da configuração ", "contábil." }
aPHelpSpa := { "Item secuencial de la configuracion", "contable" }
aPHelpEng := { "Sequential item of accounting ", "setting" }
PutHelp( "PCT0_ID", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe a descrição da entidade", "contábil." }
aPHelpSpa := { "Descripcion del ente contable " }
aPHelpEng := { "Accounting entity description  " }
PutHelp( "PCT0_DESC", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define se a entidade contábil será", " controlada pelo sistema." }
aPHelpSpa := { "Define si el ente contable se ", "controlara por el sistema." }
aPHelpEng := { "Defines if the accounting entity", " is controlled by the system. " }
PutHelp( "PCT0_CONTR", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código da tabela de cadastro vinculada ", "a entidade contábil. " }
aPHelpSpa := { "Codigo de la tabla de archivo ", "vinculada al ente contable" }
aPHelpEng := { "Table code of registration ", "linked to accounting entity" }
PutHelp( "PCT0_ALIAS", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Plano da entidade contábil quando ", "utilizado o cadastro de entidades 'CV0'. " }
aPHelpSpa := { "Plan del ente contable cuando se", " utiliza el archivo de entes CV0.  " }
aPHelpEng := { "Accounting entity plan when the", " entity registration CV0 is used.   " }
PutHelp( "PCT0_ENTIDA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define se a utilização da entidade ", "contábil em lançamentos", " é obrigatória." }
aPHelpSpa := { "Define si la utilizacion del", " ente contable en asientos", " es obligatoria. " }
aPHelpEng := { "Defines if the use of the", " accounting entity in entries", " is mandatory.   " }
PutHelp( "PCT0_OBRIGA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Campo chave." }
aPHelpSpa := { "Informe Campo clave.  " }
aPHelpEng := { "Enter key field." }
PutHelp( "PCT0_CPOCHV", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Descrição Chave." }
aPHelpSpa := { "Informe Descripcion Clave. " }
aPHelpEng := { "Enter key description. " }
PutHelp( "PCT0_CPODSC", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Código Entidade Superior." }
aPHelpSpa := { "Informe Codigo Ente Superior." }
aPHelpEng := { "Enter code superior entity. " }
PutHelp( "PCT0_CPOSUP", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Grupo de Campos." }
aPHelpSpa := { "Informe Grupo de Campos.   " }
aPHelpEng := { "Enter field group" }
PutHelp( "PCT0_CPOSXG", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Consulta Padrão." }
aPHelpSpa := { "Informe Consulta Estandar. " }
aPHelpEng := { "Enter Standard Query  " }
PutHelp( "PCT0_F3ENTI", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Informe Descrição Resumida." }
aPHelpSpa := { "Informe Descripcion Resumida." }
aPHelpEng := { "Enter Summarized Description  " }
PutHelp( "PCT0_DSCRES", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aAdd(aSX3, {"CV0","01","CV0_FILIAL"	,"C"	,nTamFilial     ,0	,"Filial"	    ,"Sucursal"	    ,"Branch"		,"Filial"	                 ,"Sucursal"                  ,"Branch"		            ,""         ,""					                      ,"€€€€€€€€€€€€€€€"	,""          ,""		,1,"„€"	,""	,""	,"","S"	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,"033" ,"","N",.T.})
aAdd(aSX3, {"CV0","02","CV0_PLANO"	,"C"	,2              ,0	,"Plano Contáb"	,"Plan Contabl"	,"Accoun. Plan"	,"Código do plano contábil." ,"Codigo del plan contable"  ,"Accounting Plan code"	,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"C€"	,""	,""	,"","S"	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050SX3('CV0_PLANO')"  ,"INCLUI" ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","03","CV0_ITEM"	,"C"	,6              ,0	,"Item"	        ,"Item"	        ,"Item"		    ,"Item do Plano Contábil"	 ,"Item del Plan Contable"    ,"Accounting Plan Item"	,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"C€"	,""	,""	,"",""	,"V",""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050SX3('CV0_ITEM')"   ,""       ,""	 ,"","N",.T.})
If cPaisLoc == "COL"
	aAdd(aSX3, {"CV0","04","CV0_CODIGO"	,"C"	,15,0	,"Codigo"	    ,"Codigo"	    ,"Code"		    ,"Código da entidade"        ,"Codigo del ente"           ,"Company code"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"×€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050WHEN() .And. CTB050SX3('CV0_CODIGO')" ,""       ,""	 ,"","N",.T.})
Elseif cPaisLoc <> "PER"
	aAdd(aSX3, {"CV0","04","CV0_CODIGO"	,"C"	,6 ,0	,"Codigo"	    ,"Codigo"	    ,"Code"		    ,"Código da entidade"        ,"Codigo del ente"           ,"Company code"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"×€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050WHEN() .And. CTB050SX3('CV0_CODIGO')" ,""       ,""	 ,"","N",.T.})
EndIf
aAdd(aSX3, {"CV0","05","CV0_DESC"	,"C"	,30             ,0	,"Descrição"	,"Descripcion"	,"Description"	,"Descrição"                 ,"Descripcion"               ,"Description"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"C€"	,""	,""	,"","S"	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","06","CV0_CLASSE"	,"C"	,1              ,0	,"Classe"	    ,"Clase"	    ,"Class"		,"Classe"	                 ,"Clase"                     ,"Class"		            ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"C€"	,""	,""	,"",""	,""	,""	,""	,"","1=Sintetica;2=Analitica" ,"1=Sintetica;2=Analitica" ,"1=Synthetic; 2= Analytical"	,""			,"CTB050WHEN()"            ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","07","CV0_NORMAL"	,"C"	,1              ,0	,"Cond.Normal"	,"Cond.Normal"	,"Reg Term"		,"Condição Normal"	         ,"Condicion Normal"          ,"Regular Term"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"C€"	,""	,""	,"",""	,""	,""	,""	,"","1=Devedora;2=Credora "	  ,"1=Debedora;2=Acreedora"	 ,"1=Debtor; 2=Creditor"		,""			,"CTB050WHEN()"            ,""       ,""	 ,"","N",.T.})
If cPaisLoc == "COL"
	aAdd(aSX3, {"CV0","08","CV0_ENTSUP"	,"C"	,15             ,0	,"Entid.Sup."	,"Entid.Sup."	,"Higher Ent."	,"Entidade Superior"	     ,"Entidad Superior"          ,"Higher Entity"		    ,"@!"		,"CTB050ESup(,M->CV0_ENTSUP)"             ,"€€€€€€€€€€€€€€ "	,""          ,"CV0"		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050SX3('CV0_ENTSUP')" ,""       ,""	 ,"","N",.T.})
Elseif cPaisLoc <> "PER"
	aAdd(aSX3, {"CV0","08","CV0_ENTSUP"	,"C"	,6             ,0	,"Entid.Sup."	,"Entid.Sup."	,"Higher Ent."	,"Entidade Superior"	     ,"Entidad Superior"          ,"Higher Entity"		    ,"@!"		,"CTB050ESup(,M->CV0_ENTSUP)"             ,"€€€€€€€€€€€€€€ "	,""          ,"CV0"		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,"CTB050SX3('CV0_ENTSUP')" ,""       ,""	 ,"","N",.T.})
EndIf
aAdd(aSX3, {"CV0","09","CV0_BLOQUE"	,"C"	,1              ,0	,"Bloqueada"	,"Bloqueada"	,"Blocked"		,"Bloqueia código da Entida" ,"Bloquea codigo de Entidad" ,"Blocks Company Code"	,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,""		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"","1=Sim;2=Nao"			  ,"1=Si;2=No"			     ,"1=Yes; 2=No"			        ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","10","CV0_DTIBLQ"	,"D"	,8              ,0	,"Dt.Inic.Blq"	,"Fc.Inic.Blq"	,"Bl. Init. Dt"	,"Data Inicial do Bloqueio"	 ,"Fecha Inicial del Bloqueo" ,"Blockage Initial Date"	,""         ,""					                      ,"€€€€€€€€€€€€€€ "	,'CTOD("")'  ,""		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","11","CV0_DTFBLQ"	,"D"	,8              ,0	,"Dt.Final Blq"	,"Fc.Final Blq"	,"Bl.Fin.Dt."	,"Data Final do Bloqueio"	 ,"Fecha Final del Bloqueo"   ,"Blockage Final Date"	,""         ,""					                      ,"€€€€€€€€€€€€€€ "	,'CTOD("")'  ,""		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","12","CV0_DTIEXI"	,"D"	,8              ,0	,"Data Inicial"	,"Fecha Inicia"	,"Init date"	,"Data Inicial de existênc." ,"Fecha Inicial de existenc" ,"Existance Initial Date"	,""         ,""					                      ,"€€€€€€€€€€€€€€ "	,"dDatabase" ,""		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""			          	  ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","13","CV0_DTFEXI"	,"D"	,8              ,0	,"Data Final"	,"Fecha Final"	,"Final date"	,"Data Final de existência." ,"Fecha Final de existencia" ,"Final existance date"	,""         ,""					                      ,"€€€€€€€€€€€€€€ "	,'CTOD("")'  ,""		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","14","CV0_CFGLIV"	,"C"	,3              ,0	,"Cod.Livros"	,"Cod.Libros"	,"Books Code"	,"Código da Conf.de livros"	 ,"Codigo de Conf. de libros" ,"Code of Books Conf"		,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,"CTN"		,1,"Æ€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","15","CV0_LUCPER"	,"C"	,15             ,0	,"Lucros/Perda"	,"Ganan/Perdid"	,"Profit/Loss"	,"Lucros e Perdas."	         ,"Ganancias y Perdidas"      ,"Profit/Losses"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,"CV0"		,1,"Ö€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})
aAdd(aSX3, {"CV0","16","CV0_PONTE"	,"C"	,15             ,0	,"Conta Ponte."	,"Cta. Ponte."	,"Bridge Acc"	,"Conta Ponte."	             ,"Cuenta Ponte."             ,"Bridge Account"		    ,"@!"		,""					                      ,"€€€€€€€€€€€€€€ "	,""          ,"CV0"		,1,"Ö€"	,""	,""	,"",""	,""	,""	,""	,"",""				          ,""			             ,""			                ,""			,""		                   ,""       ,""	 ,"","N",.T.})

aPHelpPor := { "Código da filial do sistema. " }
aPHelpSpa := { "Codigo de la sucursal del sistema.  " }
aPHelpEng := { "System Branch Code  " }
PutHelp( "PCV0_FILIAL", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código do plano contábil. " }
aPHelpSpa := { "Codigo del plan contable.   " }
aPHelpEng := { "Code of accounting plan. " }
PutHelp( "PCV0_PLANO", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código sequencial do", " item do plano contábil." }
aPHelpSpa := { "Codigo secuencial del", " item del plan contable. " }
aPHelpEng := { "Sequential code of ", "accounting plan item." }
PutHelp( "PCV0_ITEM", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código da entidade contábil", " cadastrada ", "no plano. " }
aPHelpSpa := { "Codigo del ente contable", " registro en el plan." }
aPHelpEng := { "Accounting entity code ", "registered in plan. " }
PutHelp( "PCV0_CODIGO", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Descrição do plano, quando", " visualizado no cabeçalho.", "Descrição do item", " do plano quando visualizado", " nos itens do cadastro." }
aPHelpSpa := { "Descripcion del plan, cuando ", "se visualiza en el", " encabezado.Descripcion ", "del item del plan cuando ", "se visualiza en los", " items del archivo." }
aPHelpEng := { "Plan description, when viewed", " in the header.Description", " of plan when viewed", " in registration items." }
PutHelp( "PCV0_DESC", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define se o ", "registro incluído em uma ", "entidade contábil é analítco ou ", "sintético. " }
aPHelpSpa := { "Define si el", " registro incluido en un", " ente contable es analitco", " o sintetico.  " }
aPHelpEng := { "Defines if ", "registration included in ", "an accounting entity is", " analytical or synthetic.    " }
PutHelp( "PCV0_CLASSE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define se o código da entidade ", "informada é de devedora", " ou credora. " }
aPHelpSpa := { "Define si el codigo del ente", " informado es de deudor ", "o acreedor.           " }
aPHelpEng := { "Defines if entity code ", "entered is debtor ", "or creditor." }
PutHelp( "PCV0_NORMAL", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código da entidade ", "do plano, definida ", "como superior, ", "necessariamente sendo ", "uma sintética. " }
aPHelpSpa := { "Codigo del ente del", " plan, definido como", " superior, siendo ", "necesariamente un sintetico." }
aPHelpEng := { "Code of plan entity, ", "defined as superior,", " as synthetic.               " }
PutHelp( "PCV0_ENTSUP", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define se a entidade está bloqueada." }
aPHelpSpa := { "Define si el ente esta bloqueado. " }
aPHelpEng := { "Defines if entity is blocked.  " }
PutHelp( "PCV0_BLOQUE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data inicial do bloqueio da entidade." }
aPHelpSpa := { "Fecha inicial del bloqueo del ente.  " }
aPHelpEng := { "Initial date of entity blockage.   " }
PutHelp( "PCV0_DTIBLQ", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data final do bloqueio da entidade." }
aPHelpSpa := { "Fecha final de bloqueo del ente.    " }
aPHelpEng := { "Final date of entity blockage. " }
PutHelp( "PCV0_DTFBLQ", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data Inicial de existência da entidade." }
aPHelpSpa := { "Fecha Inicial de existencia del ente." }
aPHelpEng := { "Initial date of entity existence. " }
PutHelp( "PCV0_DTIEXI", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data Final de existência da entidade." }
aPHelpSpa := { "Fecha Final de existencia del ente.  " }
aPHelpEng := { "Final date of entity existence." }
PutHelp( "PCV0_DTFEXI", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Código da Configuração de livros. " }
aPHelpSpa := { "Codigo de la ", "Configuracion de libros" }
aPHelpEng := { "Code of book setting  " }
PutHelp( "PCV0_CFGLIV", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define o código da entidade para ", "apuração de lucros e perdas." }
aPHelpSpa := { "Define el codigo del ente para", " calculo de ganancias y perdidas. " }
aPHelpEng := { "Defines entity code to calculate", " profits and losses. " }
PutHelp( "PCV0_LUCPER", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Define o código da entidade", " ponte para ", "apuração de", " lucros e perdas." }
aPHelpSpa := { "Define el codigo del ente ", "puente para calculo de", " ganancias y perdidas.     " }
aPHelpEng := { "Defines bridge entity code", " to calculate profits", " and losses. " }
PutHelp( "PCV0_PONTE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aAdd(aSX3, {"CVX","01","CVX_FILIAL"	,"C" ,nTamFilial      	,0 ,"Filial"	   ,"Sucursal"	  ,"Branch"      ,"Filial"	           ,"Sucursal"           ,"Branch"		     ,""	,"" ,"€€€€€€€€€€€€€€€"	,"" ,""	,1,"€€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"033" 	,"","N",.T.})
aAdd(aSX3, {"CVX","02","CVX_CONFIG"	,"C" ,2               	,0 ,"Config."	   ,"Config."	  ,"Config"	     ,"Configuração"	   ,"Configuracion"      ,"Configuration"	 ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,""    	,"","N",.T.})
aAdd(aSX3, {"CVX","03","CVX_MOEDA"	,"C" ,2               	,0 ,"Moeda"	   ,"Moneda"	  ,"Currency"	 ,"Moeda"	           ,"Moneda"             ,"Currency"		 ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""		,""    	,"","N",.T.})
aAdd(aSX3, {"CVX","04","CVX_CHAVE"	,"C" ,120             	,0 ,"Chv.Concat." ,"Cl.Concat."  ,"Concat. Key" ,"Chave concatenada." ,"Clave concatenada." ,"Concatenated Key","@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,""    	,"","N",.T.})
aAdd(aSX3, {"CVX","05","CVX_DATA"	,"D" ,8               	,0 ,"Data"	       ,"Fecha"       ,"Date"	     ,"Data Saldo"	       ,"Fecha Saldo"        ,"Balance Date" ,""	,""	,"€€€€€€€€€€€€€€ "	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""		,""		,"","N",.T.})
aAdd(aSX3, {"CVX","06","CVX_SLDCRD"	,"N" ,16              	,2 ,"Saldo Cred." ,"Saldo Cred." ,"Cred Bal"    ,"Saldo em Credito."  ,"Saldo en Credito."  ,"Credit Balance"  ,"@E 9,999,999,999,999.99"	,""	,"€€€€€€€€€€€€€€ "	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""		,""		,"","N",.T.})
aAdd(aSX3, {"CVX","07","CVX_SLDDEB"	,"N" ,16              	,2 ,"Saldo Deb."  ,"Saldo Deb."  ,"Deb Bal"     ,"Saldo em Debito."   ,"Saldo en Debito."   ,"Debit Balance"   ,"@E 9,999,999,999,999.99"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""		,""		,"","N",.T.})
aAdd(aSX3, {"CVX","08","CVX_NIV01"	,"C" ,nTamConta			,0 ,"Nivel 01"    ,"Nivel 01"    ,"Level 01"    ,"Nivel 01"           ,"Nivel 01"           ,"Level 01"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"003"	,"","N",.T.})
aAdd(aSX3, {"CVX","09","CVX_NIV02"	,"C" ,nTamCCusto		,0 ,"Nivel 02"    ,"Nivel 02"    ,"Level 02"    ,"Nivel 02"           ,"Nivel 02"           ,"Level 02"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"004"	,"","N",.T.})
aAdd(aSX3, {"CVX","10","CVX_NIV03"	,"C" ,nTamItCont		,0 ,"Nivel 03"    ,"Nivel 03"    ,"Level 03"    ,"Nivel 03"           ,"Nivel 03"           ,"Level 03"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"005"	,"","N",.T.})
aAdd(aSX3, {"CVX","11","CVX_NIV04"	,"C" ,nTamClVlr			,0 ,"Nivel 04"    ,"Nivel 04"    ,"Level 04"    ,"Nivel 04"           ,"Nivel 04"           ,"Level 04"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"006"	,"","N",.T.})
aAdd(aSX3, {"CVX","12","CVX_NIV05"	,"C" ,nTamEnt_05		,0 ,"Nivel 05"    ,"Nivel 05"    ,"Level 05"    ,"Nivel 05"           ,"Nivel 05"           ,"Level 05"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"040"	,"","N",.T.})
aAdd(aSX3, {"CVX","13","CVX_NIV06"	,"C" ,nTamEnt_06		,0 ,"Nivel 06"    ,"Nivel 06"    ,"Level 06"    ,"Nivel 06"           ,"Nivel 06"           ,"Level 06"        ,"@!"	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""	,"042"	,"","N",.T.})
aAdd(aSX3, {"CVX","14","CVX_TPSALD"	,"C" ,2               	,0 ,"Tp.Saldo"    ,"Tp.Saldo"    ,"Bal. Type"   ,"Tipo de Saldo"      ,"Tipo de Saldo"      ,"Balance Type"    ,""	,""	,"€€€€‚€€€€€€€€€€"	,"" ,""	,1,"„€"	,""	,""	,"",""	,""	,""	,""	,"","","","","","",""		,""		,"","N",.T.})

aPHelpPor := { "Código da filial do sistema." }
aPHelpSpa := { "Codigo de la sucursal del sistema" }
aPHelpEng := { "System Branch Code" }
PutHelp( "PCVX_FILIAL", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Configuração." }
aPHelpSpa := { "Configuracion " }
aPHelpEng := { "Configuration" }
PutHelp( "PCVX_CONFIG", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Moeda." }
aPHelpSpa := { "Moneda   " }
aPHelpEng := { "Currency " }
PutHelp( "PCVX_MOEDA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Chave concatenada. " }
aPHelpSpa := { "Clave concatenada." }
aPHelpEng := { "Connecting key. " }
PutHelp( "PCVX_CHAVE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data do Saldo. " }
aPHelpSpa := { "Fecha del Saldo. " }
aPHelpEng := { "Date of balance. " }
PutHelp( "PCVX_DATA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Crédito. " }
aPHelpSpa := { "Saldo en Credito." }
aPHelpEng := { "Balance in credit.  " }
PutHelp( "PCVX_SLDCRD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Débito. " }
aPHelpSpa := { "Saldo en Debito. " }
aPHelpEng := { "Balance in Debit.  " }
PutHelp( "PCVX_SLDDEB", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 01. " }
aPHelpSpa := { "Nivel 01. " }
aPHelpEng := { "Level 01." }
PutHelp( "PCVX_NIV01", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 02. " }
aPHelpSpa := { "Nivel 02. " }
aPHelpEng := { "Level 02." }
PutHelp( "PCVX_NIV02", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 03. " }
aPHelpSpa := { "Nivel 03. " }
aPHelpEng := { "Level 03." }
PutHelp( "PCVX_NIV03", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 04. " }
aPHelpSpa := { "Nivel 04. " }
aPHelpEng := { "Level 04." }
PutHelp( "PCVX_NIV04", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 05. " }
aPHelpSpa := { "Nivel 05. " }
aPHelpEng := { "Level 05." }
PutHelp( "PCVX_NIV05", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 06. " }
aPHelpSpa := { "Nivel 06. " }
aPHelpEng := { "Level 06." }
PutHelp( "PCVX_NIV06", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Tipo de Saldo. " }
aPHelpSpa := { "Tipo de Saldo.  " }
aPHelpEng := { "Type of Balance " }
PutHelp( "PCVX_TPSALD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aAdd(aSX3, {"CVY","01","CVY_FILIAL","C",nTamFilial    	,0,"Filial"      ,"Sucursal"    ,"Branch"     ,"Filial"           ,"Sucursal"         ,"Branch"          ,""  ,"","€€€€€€€€€€€€€€€","","",1,"€€","","","","","","","","","","","","","","","033","","N",.T.})
aAdd(aSX3, {"CVY","02","CVY_CONFIG","C",2             	,0,"Config."     ,"Config."     ,"Config"     ,"Configuração"     ,"Configuracion"    ,"Configuration"   ,""  ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","03","CVY_MOEDA" ,"C",2             	,0,"Moeda"       ,"Moneda"      ,"Currency"   ,"Moeda"            ,"Moneda"           ,"Currency"        ,""  ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","04","CVY_CHAVE" ,"C",120           	,0,"Chv.Concat." ,"Clv.Concat." ,"Concat. Key","Chave Concatenada","Clave Concatenada","Concatenated Key","@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","05","CVY_DATA"  ,"D",8             	,0,"Data"        ,"Fecha"       ,"Date"       ,"Data do saldo"    ,"Fecha del saldo"  ,"Balance date"    ,""  ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","06","CVY_SLDCRD","N",16            	,2,"Saldo Cred." ,"Saldo Cred." ,"Cred. Bal." ,"Saldo em Credito.","Saldo en Credito.","Credit Balance"  ,"@E 9,999,999,999,999.99"  ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","07","CVY_SLDDEB","N",16            	,2,"Saldo Deb."  ,"Saldo Deb."  ,"Deb. Bal."  ,"Saldo em Debito." ,"Saldo en Debito." ,"Debit Balance"   ,"@E 9,999,999,999,999.99"  ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVY","08","CVY_NIV01" ,"C",nTamConta		,0,"Nivel 01"    ,"Nivel 01"    ,"Level 01"   ,"Nivel 01"         ,"Nivel 01"         ,"Level 01"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","003","","N",.T.})
aAdd(aSX3, {"CVY","09","CVY_NIV02" ,"C",nTamCCusto		,0,"Nivel 02"    ,"Nivel 02"    ,"Level 02"   ,"Nivel 02"         ,"Nivel 02"         ,"Level 02"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","004","","N",.T.})
aAdd(aSX3, {"CVY","10","CVY_NIV03" ,"C",nTamItCont		,0,"Nivel 03"    ,"Nivel 03"    ,"Level 03"   ,"Nivel 03"         ,"Nivel 03"         ,"Level 03"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","005","","N",.T.})
aAdd(aSX3, {"CVY","11","CVY_NIV04" ,"C",nTamClVlr		,0,"Nível 04"    ,"Nivel 04"    ,"Level 04"   ,"Nível 04"         ,"Nivel 04"         ,"Level 04"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","006","","N",.T.})
aAdd(aSX3, {"CVY","12","CVY_NIV05" ,"C",nTamEnt_05		,0,"Nível 05"    ,"Nivel 05"    ,"Level 05"   ,"Nível 05"         ,"Nivel 05"         ,"Level 05"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","040","","N",.T.})
aAdd(aSX3, {"CVY","13","CVY_NIV06" ,"C",nTamEnt_06		,0,"Nível 06"    ,"Nivel 06"    ,"Level 06"   ,"Nível 06"         ,"Nivel 06"         ,"Level 06"        ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","042","","N",.T.})
aAdd(aSX3, {"CVY","14","CVY_TPSALD","C",2          		,0,"Tp.Saldo"    ,"Tp.Saldo"    ,"Balance Tp" ,"Tipo de Saldo"    ,"Tipo de Saldo"    ,"Tp of Balance"   ,"@!","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})


aPHelpPor := { "Código da filial do sistema." }
aPHelpSpa := { "Codigo de la sucursal del sistema" }
aPHelpEng := { "System Branch Code" }
PutHelp( "PCVY_FILIAL", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Configuração." }
aPHelpSpa := { "Configuracion " }
aPHelpEng := { "Configuration" }
PutHelp( "PCVY_CONFIG", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Moeda." }
aPHelpSpa := { "Moneda   " }
aPHelpEng := { "Currency " }
PutHelp( "PCVY_MOEDA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Chave concatenada. " }
aPHelpSpa := { "Clave concatenada." }
aPHelpEng := { "Connecting key. " }
PutHelp( "PCVY_CHAVE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data do Saldo. " }
aPHelpSpa := { "Fecha del Saldo. " }
aPHelpEng := { "Date of balance. " }
PutHelp( "PCVY_DATA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Crédito. " }
aPHelpSpa := { "Saldo en Credito." }
aPHelpEng := { "Balance in credit.  " }
PutHelp( "PCVY_SLDCRD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Débito. " }
aPHelpSpa := { "Saldo en Debito. " }
aPHelpEng := { "Balance in Debit.  " }
PutHelp( "PCVY_SLDDEB", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 01. " }
aPHelpSpa := { "Nivel 01. " }
aPHelpEng := { "Level 01." }
PutHelp( "PCVY_NIV01", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 02. " }
aPHelpSpa := { "Nivel 02. " }
aPHelpEng := { "Level 02." }
PutHelp( "PCVY_NIV02", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 03. " }
aPHelpSpa := { "Nivel 03. " }
aPHelpEng := { "Level 03." }
PutHelp( "PCVY_NIV03", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 04. " }
aPHelpSpa := { "Nivel 04. " }
aPHelpEng := { "Level 04." }
PutHelp( "PCVY_NIV04", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 05. " }
aPHelpSpa := { "Nivel 05. " }
aPHelpEng := { "Level 05." }
PutHelp( "PCVY_NIV05", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 06. " }
aPHelpSpa := { "Nivel 06. " }
aPHelpEng := { "Level 06." }
PutHelp( "PCVY_NIV06", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Tipo de Saldo. " }
aPHelpSpa := { "Tipo de Saldo.  " }
aPHelpEng := { "Type of Balance " }
PutHelp( "PCVY_TPSALD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aAdd(aSX3, {"CVZ","01","CVZ_FILIAL","C",nTamFilial   	,0,"Filial"      ,"Sucursal"    ,"Branch"     ,"Filial"            ,"Sucursal"          ,"Branch"          ,""                         ,"","€€€€€€€€€€€€€€€","","",1,"€€","","","","","","","","","","","","","","","033","","N",.T.})
aAdd(aSX3, {"CVZ","02","CVZ_CONFIG","C",2            	,0,"Configuração","Configuracio","Config"     ,"Configuração"      ,"Configuracion"     ,"Configuration"   ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","03","CVZ_MOEDA" ,"C",2             	,0,"Moeda"       ,"Moneda"      ,"Currency"   ,"Moeda"             ,"Moneda"            ,"Currency"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","04","CVZ_CHAVE" ,"C",120          	,0,"Chv.Concat." ,"Clv.Concat." ,"Concat. Key","Chave concatenada.","Clave concatenada.","Concatenated Key","@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","05","CVZ_DATA"  ,"D",8            	,0,"Data"        ,"Fecha"       ,"Date"       ,"Data do saldo"     ,"Fecha del saldo"   ,"Balance Date"    ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","06","CVZ_SLDCRD","N",16           	,2,"Saldo Cred." ,"Saldo Cred." ,"Cred. Bal." ,"Saldo em Credito." ,"Saldo en Credito." ,"Credit Balance"  ,"@E 9,999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","07","CVZ_SLDDEB","N",16            	,2,"Saldo Deb."  ,"Saldo Deb."  ,"Deb. Bal."  ,"Saldo em Debito."  ,"Saldo en Debito."  ,"Debit Balance"   ,"@E 9,999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})
aAdd(aSX3, {"CVZ","08","CVZ_NIV01" ,"C",nTamConta		,0,"Nível 01"    ,"Nivel 01"    ,"Level 01"   ,"Nível 01"          ,"Nivel 01"          ,"Level 01"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","003","","N",.T.})
aAdd(aSX3, {"CVZ","09","CVZ_NIV02" ,"C",nTamCCusto		,0,"Nível 02"    ,"Nivel 02"    ,"Level 02"   ,"Nível 02"          ,"Nivel 02"          ,"Level 02"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","004","","N",.T.})
aAdd(aSX3, {"CVZ","10","CVZ_NIV03" ,"C",nTamItCont		,0,"Nível 03"    ,"Nivel 03"    ,"Level 03"   ,"Nível 03"          ,"Nivel 03"          ,"Level 03"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","005","","N",.T.})
aAdd(aSX3, {"CVZ","11","CVZ_NIV04" ,"C",nTamClVlr		,0,"Nível 04"    ,"Nivel 04"    ,"Level 04"   ,"Nível 04"          ,"Nivel 04"          ,"Level 04"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","006","","N",.T.})
aAdd(aSX3, {"CVZ","12","CVZ_NIV05" ,"C",nTamEnt_05		,0,"Nível 05"    ,"Nivel 05"    ,"Level 05"   ,"Nível 05"          ,"Nivel 05"          ,"Level 05"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","040","","N",.T.})
aAdd(aSX3, {"CVZ","13","CVZ_NIV06" ,"C",nTamEnt_06		,0,"Nível 06"    ,"Nivel 06"    ,"Level 06"   ,"Nível 06"          ,"Nivel 06"          ,"Level 06"        ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","","042","","N",.T.})
aAdd(aSX3, {"CVZ","14","CVZ_TPSALD","C",2         		,0,"Tp.Saldo"    ,"Tp.Saldo"    ,"Balance Tp" ,"Tipo de Saldo"     ,"Tipo de Saldo"     ,"Type of Balance" ,"@!"                       ,"","€€€€€€€€€€€€€€ ","","",1,"„€","","","","","","","","","","","","","","",""   ,"","N",.T.})

aPHelpPor := { "Código da filial do sistema." }
aPHelpSpa := { "Codigo de la sucursal del sistema" }
aPHelpEng := { "System Branch Code" }
PutHelp( "PCVZ_FILIAL", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Configuração." }
aPHelpSpa := { "Configuracion " }
aPHelpEng := { "Configuration" }
PutHelp( "PCVZ_CONFIG", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Moeda." }
aPHelpSpa := { "Moneda   " }
aPHelpEng := { "Currency " }
PutHelp( "PCVZ_MOEDA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Chave concatenada. " }
aPHelpSpa := { "Clave concatenada." }
aPHelpEng := { "Connecting key. " }
PutHelp( "PCVZ_CHAVE", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Data do Saldo. " }
aPHelpSpa := { "Fecha del Saldo. " }
aPHelpEng := { "Date of balance. " }
PutHelp( "PCVZ_DATA", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Crédito. " }
aPHelpSpa := { "Saldo en Credito." }
aPHelpEng := { "Balance in credit.  " }
PutHelp( "PCVZ_SLDCRD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Saldo em Débito. " }
aPHelpSpa := { "Saldo en Debito. " }
aPHelpEng := { "Balance in Debit.  " }
PutHelp( "PCVZ_SLDDEB", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 01. " }
aPHelpSpa := { "Nivel 01. " }
aPHelpEng := { "Level 01." }
PutHelp( "PCVZ_NIV01", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 02. " }
aPHelpSpa := { "Nivel 02. " }
aPHelpEng := { "Level 02." }
PutHelp( "PCVZ_NIV02", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 03. " }
aPHelpSpa := { "Nivel 03. " }
aPHelpEng := { "Level 03." }
PutHelp( "PCVZ_NIV03", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 04. " }
aPHelpSpa := { "Nivel 04. " }
aPHelpEng := { "Level 04." }
PutHelp( "PCVZ_NIV04", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 05. " }
aPHelpSpa := { "Nivel 05. " }
aPHelpEng := { "Level 05." }
PutHelp( "PCVZ_NIV05", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Nivel 06. " }
aPHelpSpa := { "Nivel 06. " }
aPHelpEng := { "Level 06." }
PutHelp( "PCVZ_NIV06", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

aPHelpPor := { "Tipo de Saldo. " }
aPHelpSpa := { "Tipo de Saldo.  " }
aPHelpEng := { "Type of Balance " }
PutHelp( "PCVZ_TPSALD", aPHelpPor, aPHelpEng, aPHelpSpa, .T. )

// Gestão Corporativa.
aAdd(aSX3Ordem,{"CTS","01","CTS_FILIAL"})
aAdd(aSX3Ordem,{"CTS","02","CTS_CODPLA"})
aAdd(aSX3Ordem,{"CTS","03","CTS_ORDEM"})
aAdd(aSX3Ordem,{"CTS","04","CTS_CONTAG"})
aAdd(aSX3Ordem,{"CTS","05","CTS_CTASUP"})
aAdd(aSX3Ordem,{"CTS","06","CTS_DESCCG"})
aAdd(aSX3Ordem,{"CTS","07","CTS_DETHCG"})
aAdd(aSX3Ordem,{"CTS","08","CTS_NORMAL"})
aAdd(aSX3Ordem,{"CTS","09","CTS_COLUNA"})
aAdd(aSX3Ordem,{"CTS","10","CTS_CLASSE"})
aAdd(aSX3Ordem,{"CTS","11","CTS_IDENT"})
aAdd(aSX3Ordem,{"CTS","12","CTS_NOME"})
aAdd(aSX3Ordem,{"CTS","13","CTS_LINHA"})
aAdd(aSX3Ordem,{"CTS","14","CTS_CT1INI"})
aAdd(aSX3Ordem,{"CTS","15","CTS_CT1FIM"})
aAdd(aSX3Ordem,{"CTS","16","CTS_CTTINI"})
aAdd(aSX3Ordem,{"CTS","17","CTS_CTTFIM"})
aAdd(aSX3Ordem,{"CTS","18","CTS_CTDINI"})
aAdd(aSX3Ordem,{"CTS","19","CTS_CTDFIM"})
aAdd(aSX3Ordem,{"CTS","20","CTS_CTHINI"})
aAdd(aSX3Ordem,{"CTS","21","CTS_CTHFIM"})
aAdd(aSX3Ordem,{"CTS","22","CTS_IDENTI"})
aAdd(aSX3Ordem,{"CTS","23","CTS_TPSALD"})
aAdd(aSX3Ordem,{"CTS","24","CTS_FORMUL"})
aAdd(aSX3Ordem,{"CW3","10","CW3_PERCEN"})

//ATIVIDADES COMPLEMENTARES CT1/CT2/CT5/CTD/CTH/CTK/CTT/CV3
// Atualizando as tabelas CT1,CT2,CT5,CTD,CTH,CTK,CTT,CV3
//CT1
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ACAT01"),"CT1_ACAT01"	,"C",01,0,"Ativ.01 Ac."	,"Ativ.01 Ac.","Ativ.01 Ac.","Aceita Atividade 01","Aceita Atividade 01","Aceita Atividade 01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_AT01OB"),"CT1_AT01OB"	,"C",01,0,"Ativ.01 Ob."	,"Ativ.01 Ob.","Ativ.01 Ob.","Obrigatório Ativ.01","Obrigatório Ativ.01","Obrigatório Ativ.01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ACAT02"),"CT1_ACAT02"	,"C",01,0,"Ativ.02 Ac."	,"Ativ.02 Ac.","Ativ.02 Ac.","Aceita Atividade 02","Aceita Atividade 02","Aceita Atividade 02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_AT02OB"),"CT1_AT02OB"	,"C",01,0,"Ativ.02 Ob."	,"Ativ.02 Ob.","Ativ.02 Ob.","Obrigatório Ativ.02","Obrigatório Ativ.02","Obrigatório Ativ.02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ACAT03"),"CT1_ACAT03"	,"C",01,0,"Ativ.03 Ac."	,"Ativ.03 Ac.","Ativ.03 Ac.","Aceita Atividade 03","Aceita Atividade 03","Aceita Atividade 03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_AT03OB"),"CT1_AT03OB"	,"C",01,0,"Ativ.03 Ob."	,"Ativ.03 Ob.","Ativ.03 Ob.","Obrigatório Ativ.03","Obrigatório Ativ.03","Obrigatório Ativ.03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ACAT04"),"CT1_ACAT04"	,"C",01,0,"Ativ.04 Ac."	,"Ativ.04 Ac.","Ativ.04 Ac.","Aceita Atividade 04","Aceita Atividade 04","Aceita Atividade 04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_AT04OB"),"CT1_AT04OB"	,"C",01,0,"Ativ.04 Ob."	,"Ativ.04 Ob.","Ativ.04 Ob.","Obrigatório Ativ.04","Obrigatório Ativ.04","Obrigatório Ativ.04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ACATIV"),"CT1_ACATIV"	,"C",01,0,"Ac.Outra At?","Ac.Outra At?","Ac.Outra At?","Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CT1",ProxSX3("CT1","CT1_ATOBRG"),"CT1_ATOBRG"	,"C",01,0,"Outr.At.Ob?"	,"Outr.At.Ob?" ,"Outr.At.Ob?" ,"Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})

//CT2
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT01DB"),"CT2_AT01DB"	,"C",20,0,"Ativ.01 DB "	,"Ativ.01 DB.","Ativ.01 DB.","Atividade 01 DB"    ,"Atividade 01 DB"    ,"Atividade 01 DB"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT01CR"),"CT2_AT01CR"	,"C",20,0,"Ativ.01 CR "	,"Ativ.01 CR.","Ativ.01 CR.","Atividade 01 CR"    ,"Atividade 01 CR"    ,"Atividade 01 CR"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT02DB"),"CT2_AT02DB"	,"C",20,0,"Ativ.02 DB "	,"Ativ.02 DB.","Ativ.02 DB.","Atividade 02 DB"    ,"Atividade 02 DB"    ,"Atividade 02 DB"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT02CR"),"CT2_AT02CR"	,"C",20,0,"Ativ.02 CR "	,"Ativ.02 CR.","Ativ.02 CR.","Atividade 02 CR"    ,"Atividade 02 CR"    ,"Atividade 02 CR"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT03DB"),"CT2_AT03DB"	,"C",20,0,"Ativ.03 DB "	,"Ativ.03 DB.","Ativ.03 DB.","Atividade 03 DB"    ,"Atividade 03 DB"    ,"Atividade 03 DB"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT03CR"),"CT2_AT03CR"	,"C",20,0,"Ativ.03 CR "	,"Ativ.03 CR.","Ativ.03 CR.","Atividade 03 CR"    ,"Atividade 03 CR"    ,"Atividade 03 CR"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT04DB"),"CT2_AT04DB"	,"C",20,0,"Ativ.04 DB "	,"Ativ.04 DB.","Ativ.04 DB.","Atividade 04 DB"    ,"Atividade 04 DB"    ,"Atividade 04 DB"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT2",ProxSX3("CT2","CT2_AT04CR"),"CT2_AT04CR"	,"C",20,0,"Ativ.04 CR "	,"Ativ.04 CR.","Ativ.04 CR.","Atividade 04 CR"    ,"Atividade 04 CR"    ,"Atividade 04 CR"    ,"",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})

//CT5
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT01DB"),"CT5_AT01DB"	,"C",100,0,"Ativ.01 DB "	,"Ativ.01 DB.","Ativ.01 DB.","Atividade 01 DB"    ,"Atividade 01 DB"    ,"Atividade 01 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT01CR"),"CT5_AT01CR"	,"C",100,0,"Ativ.01 CR "	,"Ativ.01 CR.","Ativ.01 CR.","Atividade 01 CR"    ,"Atividade 01 CR"    ,"Atividade 01 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT02DB"),"CT5_AT02DB"	,"C",100,0,"Ativ.02 DB "	,"Ativ.02 DB.","Ativ.02 DB.","Atividade 02 DB"    ,"Atividade 02 DB"    ,"Atividade 02 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT02CR"),"CT5_AT02CR"	,"C",100,0,"Ativ.02 CR "	,"Ativ.02 CR.","Ativ.02 CR.","Atividade 02 CR"    ,"Atividade 02 CR"    ,"Atividade 02 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT03DB"),"CT5_AT03DB"	,"C",100,0,"Ativ.03 DB "	,"Ativ.03 DB.","Ativ.03 DB.","Atividade 03 DB"    ,"Atividade 03 DB"    ,"Atividade 03 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT03CR"),"CT5_AT03CR"	,"C",100,0,"Ativ.03 CR "	,"Ativ.03 CR.","Ativ.03 CR.","Atividade 03 CR"    ,"Atividade 03 CR"    ,"Atividade 03 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT04DB"),"CT5_AT04DB"	,"C",100,0,"Ativ.04 DB "	,"Ativ.04 DB.","Ativ.04 DB.","Atividade 04 DB"    ,"Atividade 04 DB"    ,"Atividade 04 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CT5",ProxSX3("CT5","CT5_AT04CR"),"CT5_AT04CR"	,"C",100,0,"Ativ.04 CR "	,"Ativ.04 CR.","Ativ.04 CR.","Atividade 04 CR"    ,"Atividade 04 CR"    ,"Atividade 04 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})

//CTD
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ACATIV"),"CTD_ACATIV"	,"C",01,0,"Ac.Outra At?","Ac.Outra At?","Ac.Outra At?","Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ATOBRG"),"CTD_ATOBRG"	,"C",01,0,"Outr.At.Ob?"	,"Outr.At.Ob?" ,"Outr.At.Ob?" ,"Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ACAT01"),"CTD_ACAT01"	,"C",01,0,"Ativ.01 Ac."	,"Ativ.01 Ac." ,"Ativ.01 Ac." ,"Aceita Atividade 01"     ,"Aceita Atividade 01"     ,"Aceita Atividade 01"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_AT01OB"),"CTD_AT01OB"	,"C",01,0,"Ativ.01 Ob."	,"Ativ.01 Ob." ,"Ativ.01 Ob." ,"Obrigatório Ativ.01"     ,"Obrigatório Ativ.01"     ,"Obrigatório Ativ.01"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ACAT02"),"CTD_ACAT02"	,"C",01,0,"Ativ.02 Ac."	,"Ativ.02 Ac." ,"Ativ.02 Ac." ,"Aceita Atividade 02"     ,"Aceita Atividade 02"     ,"Aceita Atividade 02"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_AT02OB"),"CTD_AT02OB"	,"C",01,0,"Ativ.02 Ob."	,"Ativ.02 Ob." ,"Ativ.02 Ob." ,"Obrigatório Ativ.02"     ,"Obrigatório Ativ.02"     ,"Obrigatório Ativ.02"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ACAT03"),"CTD_ACAT03"	,"C",01,0,"Ativ.03 Ac."	,"Ativ.03 Ac." ,"Ativ.03 Ac." ,"Aceita Atividade 03"     ,"Aceita Atividade 03"     ,"Aceita Atividade 03"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_AT03OB"),"CTD_AT03OB"	,"C",01,0,"Ativ.03 Ob."	,"Ativ.03 Ob." ,"Ativ.03 Ob." ,"Obrigatório Ativ.03"     ,"Obrigatório Ativ.03"     ,"Obrigatório Ativ.03"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_ACAT04"),"CTD_ACAT04"	,"C",01,0,"Ativ.04 Ac."	,"Ativ.04 Ac." ,"Ativ.04 Ac." ,"Aceita Atividade 04"     ,"Aceita Atividade 04"     ,"Aceita Atividade 04"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTD",ProxSX3("CTD","CTD_AT04OB"),"CTD_AT04OB"	,"C",01,0,"Ativ.04 Ob."	,"Ativ.04 Ob." ,"Ativ.04 Ob." ,"Obrigatório Ativ.04"     ,"Obrigatório Ativ.04"     ,"Obrigatório Ativ.04"     ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})

//CTH
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ACATIV"),"CTH_ACATIV"	,"C",01,0,"Ac.Outra At?","Ac.Outra At?","Ac.Outra At?","Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ATOBRG"),"CTH_ATOBRG"	,"C",01,0,"Outr.At.Ob?"	,"Outr.At.Ob?" ,"Outr.At.Ob?" ,"Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ACAT01"),"CTH_ACAT01"	,"C",01,0,"Ativ.01 Ac."	,"Ativ.01 Ac.","Ativ.01 Ac.","Aceita Atividade 01","Aceita Atividade 01","Aceita Atividade 01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_AT01OB"),"CTH_AT01OB"	,"C",01,0,"Ativ.01 Ob."	,"Ativ.01 Ob.","Ativ.01 Ob.","Obrigatório Ativ.01","Obrigatório Ativ.01","Obrigatório Ativ.01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ACAT02"),"CTH_ACAT02"	,"C",01,0,"Ativ.02 Ac."	,"Ativ.02 Ac.","Ativ.02 Ac.","Aceita Atividade 02","Aceita Atividade 02","Aceita Atividade 02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_AT02OB"),"CTH_AT02OB"	,"C",01,0,"Ativ.02 Ob."	,"Ativ.02 Ob.","Ativ.02 Ob.","Obrigatório Ativ.02","Obrigatório Ativ.02","Obrigatório Ativ.02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ACAT03"),"CTH_ACAT03"	,"C",01,0,"Ativ.03 Ac."	,"Ativ.03 Ac.","Ativ.03 Ac.","Aceita Atividade 03","Aceita Atividade 03","Aceita Atividade 03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_AT03OB"),"CTH_AT03OB"	,"C",01,0,"Ativ.03 Ob."	,"Ativ.03 Ob.","Ativ.03 Ob.","Obrigatório Ativ.03","Obrigatório Ativ.03","Obrigatório Ativ.03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_ACAT04"),"CTH_ACAT04"	,"C",01,0,"Ativ.04 Ac."	,"Ativ.04 Ac.","Ativ.04 Ac.","Aceita Atividade 04","Aceita Atividade 04","Aceita Atividade 04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTH",ProxSX3("CTH","CTH_AT04OB"),"CTH_AT04OB"	,"C",01,0,"Ativ.04 Ob."	,"Ativ.04 Ob.","Ativ.04 Ob.","Obrigatório Ativ.04","Obrigatório Ativ.04","Obrigatório Ativ.04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})

//CTK
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT01DB"),"CTK_AT01DB"	,"C",20,0,"Ativ.01 DB "	,"Ativ.01 DB.","Ativ.01 DB.","Atividade 01 DB"    ,"Atividade 01 DB"    ,"Atividade 01 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT01CR"),"CTK_AT01CR"	,"C",20,0,"Ativ.01 CR "	,"Ativ.01 CR.","Ativ.01 CR.","Atividade 01 CR"    ,"Atividade 01 CR"    ,"Atividade 01 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT02DB"),"CTK_AT02DB"	,"C",20,0,"Ativ.02 DB "	,"Ativ.02 DB.","Ativ.02 DB.","Atividade 02 DB"    ,"Atividade 02 DB"    ,"Atividade 02 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT02CR"),"CTK_AT02CR"	,"C",20,0,"Ativ.02 CR "	,"Ativ.02 CR.","Ativ.02 CR.","Atividade 02 CR"    ,"Atividade 02 CR"    ,"Atividade 02 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT03DB"),"CTK_AT03DB"	,"C",20,0,"Ativ.03 DB "	,"Ativ.03 DB.","Ativ.03 DB.","Atividade 03 DB"    ,"Atividade 03 DB"    ,"Atividade 03 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT03CR"),"CTK_AT03CR"	,"C",20,0,"Ativ.03 CR "	,"Ativ.03 CR.","Ativ.03 CR.","Atividade 03 CR"    ,"Atividade 03 CR"    ,"Atividade 03 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT04DB"),"CTK_AT04DB"	,"C",20,0,"Ativ.04 DB "	,"Ativ.04 DB.","Ativ.04 DB.","Atividade 04 DB"    ,"Atividade 04 DB"    ,"Atividade 04 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CTK",ProxSX3("CTK","CTK_AT04CR"),"CTK_AT04CR"	,"C",20,0,"Ativ.04 CR "	,"Ativ.04 CR.","Ativ.04 CR.","Atividade 04 CR"    ,"Atividade 04 CR"    ,"Atividade 04 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})

//CTT
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ACATIV"),"CTT_ACATIV"	,"C",01,0,"Ac.Outra At?","Ac.Outra At?","Ac.Outra At?","Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"Aceita Outra Atividade?" ,"@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ATOBRG"),"CTT_ATOBRG"	,"C",01,0,"Outr.At.Ob?"	,"Outr.At.Ob?" ,"Outr.At.Ob?" ,"Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","Outra ativ. obrigatoria?","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ACAT01"),"CTT_ACAT01"	,"C",01,0,"Ativ.01 Ac."	,"Ativ.01 Ac.","Ativ.01 Ac.","Aceita Atividade 01","Aceita Atividade 01","Aceita Atividade 01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_AT01OB"),"CTT_AT01OB"	,"C",01,0,"Ativ.01 Ob."	,"Ativ.01 Ob.","Ativ.01 Ob.","Obrigatório Ativ.01","Obrigatório Ativ.01","Obrigatório Ativ.01","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ACAT02"),"CTT_ACAT02"	,"C",01,0,"Ativ.02 Ac."	,"Ativ.02 Ac.","Ativ.02 Ac.","Aceita Atividade 02","Aceita Atividade 02","Aceita Atividade 02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_AT02OB"),"CTT_AT02OB"	,"C",01,0,"Ativ.02 Ob."	,"Ativ.02 Ob.","Ativ.02 Ob.","Obrigatório Ativ.02","Obrigatório Ativ.02","Obrigatório Ativ.02","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ACAT03"),"CTT_ACAT03"	,"C",01,0,"Ativ.03 Ac."	,"Ativ.03 Ac.","Ativ.03 Ac.","Aceita Atividade 03","Aceita Atividade 03","Aceita Atividade 03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_AT03OB"),"CTT_AT03OB"	,"C",01,0,"Ativ.03 Ob."	,"Ativ.03 Ob.","Ativ.03 Ob.","Obrigatório Ativ.03","Obrigatório Ativ.03","Obrigatório Ativ.03","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_ACAT04"),"CTT_ACAT04"	,"C",01,0,"Ativ.04 Ac."	,"Ativ.04 Ac.","Ativ.04 Ac.","Aceita Atividade 04","Aceita Atividade 04","Aceita Atividade 04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_AT04OB"),"CTT_AT04OB"	,"C",01,0,"Ativ.04 Ob."	,"Ativ.04 Ob.","Ativ.04 Ob.","Obrigatório Ativ.04","Obrigatório Ativ.04","Obrigatório Ativ.04","@!",'PERTENCE("12")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","1=Sim;2=Não","1=Sim;2=Não","1=Sim;2=Não","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_TIPO00"),"CTT_TIPO00"	,"C",02,0,"Tipo Terc. "	,"Tipeo Terc.","Other Type ","Tipo do Terceiro.  ","Tipeo de Tercero   ","Aceita Atividade 04","@!",'PERTENCE("01|02|03")'   ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","01=Cliente;02=Fornecedor;03=Funcionarios","01=Cliente;02=Proveedor;03=Empleado","01=Client;02=Supply;03=Employer","","","","","","S"})
aAdd(aSX3, {"CTT",ProxSX3("CTT","CTT_TIPO01"),"CTT_TIPO01"	,"C",02,0,"Tp Doc Ter."	,"Tp Doc Ter.","Id Tp Other","Tipo Docto Terceiro","Tipeo Doc Tercero  ","Id. Other Document ","@!",'PERTENCE("01|02|03|04")',"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","","01=RG;02=CPF/CNPJ;03=PASSAPORTE;04=Ced.Estrangeiro","01=ID;02=CUIT;03=PASSAPORT;04=ID Estrangeria","01=ID;02=ID ;03=PASSAPORT;04=ID FOREIGN","","","","","","S"})

//CV3
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT01DB"),"CV3_AT01DB"	,"C",20,0,"Ativ.01 DB "	,"Ativ.01 DB.","Ativ.01 DB.","Atividade 01 DB"    ,"Atividade 01 DB"    ,"Atividade 01 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT01CR"),"CV3_AT01CR"	,"C",20,0,"Ativ.01 CR "	,"Ativ.01 CR.","Ativ.01 CR.","Atividade 01 CR"    ,"Atividade 01 CR"    ,"Atividade 01 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT02DB"),"CV3_AT02DB"	,"C",20,0,"Ativ.02 DB "	,"Ativ.02 DB.","Ativ.02 DB.","Atividade 02 DB"    ,"Atividade 02 DB"    ,"Atividade 02 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT02CR"),"CV3_AT02CR"	,"C",20,0,"Ativ.02 CR "	,"Ativ.02 CR.","Ativ.02 CR.","Atividade 02 CR"    ,"Atividade 02 CR"    ,"Atividade 02 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT03DB"),"CV3_AT03DB"	,"C",20,0,"Ativ.03 DB "	,"Ativ.03 DB.","Ativ.03 DB.","Atividade 03 DB"    ,"Atividade 03 DB"    ,"Atividade 03 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT03CR"),"CV3_AT03CR"	,"C",20,0,"Ativ.03 CR "	,"Ativ.03 CR.","Ativ.03 CR.","Atividade 03 CR"    ,"Atividade 03 CR"    ,"Atividade 03 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT04DB"),"CV3_AT04DB"	,"C",20,0,"Ativ.04 DB "	,"Ativ.04 DB.","Ativ.04 DB.","Atividade 04 DB"    ,"Atividade 04 DB"    ,"Atividade 04 DB"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})
aAdd(aSX3, {"CV3",ProxSX3("CV3","CV3_AT04CR"),"CV3_AT04CR"	,"C",20,0,"Ativ.04 CR "	,"Ativ.04 CR.","Ativ.04 CR.","Atividade 04 CR"    ,"Atividade 04 CR"    ,"Atividade 04 CR"    ,"@E 9,999,999.99",""              ,"€€€€€€€€€€€€€€ ","","",1,"þÀ","","","S","N","A","R","","",""           ,""           ,""           ,"","","","","","S"})


//CRIACAO DE CAMPO - INICIO
//Inclusao de Campo na tabela CT1
IF cPaisLoc $ "BOL|URU"
	aCamposVM := {"CT1_MOEDVM","CT1_CTAVM","CT1_CTARED","CT1_CVD01","CT1_CVC01"}
   
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek(aCamposVm[1]))
		If SX3->X3_USADO == aSX3Copia[01][2] //Padrao errado
			For nX := 1 To Len(aCamposVm)
				SX3->(DbSeek(aCamposVm[nX]))
				RecLock("SX3")
				SX3->(dbDelete())
				MsUnlock()			
			Next nX
		EndIf	
	EndIf

	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1",aCamposVM[1]), aCamposVM[1]	, "C", 02, 0, "Md. Variacao"	, "Md.Variacion"	, "Var.Currency"	, "Moeda forte da variacao"	, "Moneda fuerte de variac."	, "Variation Strong Currency"		, ""	, "Vazio().Or.ExistCpo('CTO',,1)"	, aSX3Copia[07][2]	, ""		, "CTO", 1	, aSX3Copia[07][3]	, "", "" , "S"	, "N", "A"	, "R" , "", "", ""	, ""	, "", "", ""				, "", "","","S"})
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1",aCamposVM[2]), aCamposVm[2] , "C", 20, 0, "Var. Monet"		, "Var. Mon."		, "Var. Mon."		, "Varariacao Monetaria"		, "Varariacao Monetaria"		, "Varariacao Monetaria"			, "@!", ""											, aSX3Copia[07][2]	, ""		, "CT1", 1	, aSX3Copia[07][3]	, "", "" , ""	, "N", "A"	, "R" , "", "", ""	, ""	, "", "", ""				, "", "","","S"})
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1",aCamposVM[3]), aCamposVm[3]	, "C", 20, 0, "Red. Var"		, "Red. Var"		, "Red. Var"		, "Reducao de Var. Monetaria"	, "Reducao de Var. Monetaria"	, "Reducao de Var. Monetaria"		, "@!", ""											, aSX3Copia[07][2]	, ""		, "CT1", 1	, aSX3Copia[07][3]	, "", "" , ""	, "N", "A"	, "R" , "", "", ""	, ""	, "", "", ""				, "", "","","S"})
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1",aCamposVM[4]), aCamposVm[4] , "C", 01, 0, "Conv M1 Deb"	, "Conv M1 Deb"	, "Deb C1 Conv"	, "Crit Conv Moeda 1 Debito"	, "Crit Conv Moeda 1 Debito"	, "Debit Crncy 1 Conv Criterio"	, "!" , "Pertence('123456789A')"				, aSX3Copia[07][2]	, '"1"'	, ""	 , 1	, aSX3Copia[07][3]	, "", "" , ""	, "N", ""	, ""  , "", "", "1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta"	, "1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento;A=No Ajust"	, "1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History; 9=Due Date;A=Not Adjust", "", ""				, "", "","","S"})
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1",aCamposVM[5]), aCamposVm[5] , "C", 01, 0, "Conv M1 Crd"	, "Conv M1 Crd"	, "Crd C1 Conv"	, "Crit Conv Moeda 1 Credito"	, "Crit Conv Moeda 1 Credito"	, "Credit Crncy 1 Conv Criterio"	, "!" , "Pertence('123456789A')"				, aSX3Copia[07][2]	, '"1"'	, ""	 , 1	, aSX3Copia[07][3]	, "", "" , ""	, "N", ""	, ""  , "", "", "1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta"	, "1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento;A=No Ajust"	, "1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History; 9=Due Date;A=Not Adjust", "", ""				, "", "","","S"})
	
	// ACERTO DA ORDEM DOS CAMPOS DA TABELA CT1 - INICIO
	aAdd(aSX3Ordem,{"CT1","17","CT1_CVD01"})
	aAdd(aSX3Ordem,{"CT1","18","CT1_CVD02"})
	aAdd(aSX3Ordem,{"CT1","19","CT1_CVD03"})
	aAdd(aSX3Ordem,{"CT1","20","CT1_CVD04"})
	aAdd(aSX3Ordem,{"CT1","21","CT1_CVD05"})
	aAdd(aSX3Ordem,{"CT1","22","CT1_CVC01"})
	aAdd(aSX3Ordem,{"CT1","23","CT1_CVC02"})
	aAdd(aSX3Ordem,{"CT1","24","CT1_CVC03"})
	aAdd(aSX3Ordem,{"CT1","25","CT1_CVC04"})
	aAdd(aSX3Ordem,{"CT1","26","CT1_CVC05"})
	aAdd(aSX3Ordem,{"CT1","27","CT1_CTASUP"})
	aAdd(aSX3Ordem,{"CT1","28","CT1_HP"})
	aAdd(aSX3Ordem,{"CT1","29","CT1_ACITEM"})
	aAdd(aSX3Ordem,{"CT1","30","CT1_ACCUST"})
	aAdd(aSX3Ordem,{"CT1","31","CT1_ACCLVL"})
	aAdd(aSX3Ordem,{"CT1","32","CT1_DTEXIS"})
	aAdd(aSX3Ordem,{"CT1","33","CT1_DTEXSF"})
	aAdd(aSX3Ordem,{"CT1","34","CT1_CTAVM"})
	aAdd(aSX3Ordem,{"CT1","35","CT1_CTARED"})
	aAdd(aSX3Ordem,{"CT1","36","CT1_MOEDVM"})
	aAdd(aSX3Ordem,{"CT1","37","CT1_CTALP" })
	aAdd(aSX3Ordem,{"CT1","38","CT1_CTAPON"})
	aAdd(aSX3Ordem,{"CT1","39","CT1_BOOK"  })
	aAdd(aSX3Ordem,{"CT1","40","CT1_GRUPO" })
	aAdd(aSX3Ordem,{"CT1","41","CT1_AGLSLD"})
	aAdd(aSX3Ordem,{"CT1","42","CT1_RGNV1" })
	aAdd(aSX3Ordem,{"CT1","43","CT1_RGNV2" })
	aAdd(aSX3Ordem,{"CT1","44","CT1_RGNV3" })
	aAdd(aSX3Ordem,{"CT1","45","CT1_CCOBRG"})
	aAdd(aSX3Ordem,{"CT1","46","CT1_ITOBRG"})
	aAdd(aSX3Ordem,{"CT1","47","CT1_CLOBRG"})
	aAdd(aSX3Ordem,{"CT1","48","CT1_TRNSEF"})
	aAdd(aSX3Ordem,{"CT1","49","CT1_AGLUT" })
	aAdd(aSX3Ordem,{"CT1","50","CT1_LALUR" })
	aAdd(aSX3Ordem,{"CT1","51","CT1_CTLALU"})
	aAdd(aSX3Ordem,{"CT1","52","CT1_TPLALU"})
	aAdd(aSX3Ordem,{"CT1","53","CT1_RATEIO"})
	aAdd(aSX3Ordem,{"CT1","54","CT1_ESTOUR"})
	aAdd(aSX3Ordem,{"CT1","55","CT1_LALHIR"})
	aAdd(aSX3Ordem,{"CT1","56","CT1_CODIMP"})
	aAdd(aSX3Ordem,{"CT1","57","CT1_AJ_INF"})
	//FIM
ENDIF

//Inclusao de novos campos para controle de variação monetaria negativa em contas diferentes
If cPaisLoc == "PER"
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1","CT1_CTAVMN" ), "CT1_CTAVMN" , "C", 20, 0, "Var. Mon Neg" , "Var. Mon Neg" , "Var. Mon Neg" , "Variação Monet Negativa" , "Variacion Monet Negativo" , "Variation Monet Negative" , "@!" , "" , aSX3Copia[03][2] , "" , "CT1", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	aAdd(aSX3     ,{	"CT1",ProxSX3("CT1","CT1_CTARDN" ), "CT1_CTARDN" , "C", 20, 0, "Red. Var Neg" , "Red. Var Neg" , "Red. Var Neg" , "Red. Var Monet Negativa" , "Red. Var Monet Negativo"  , "Red. Var. Monet Negative" , "@!" , "" , aSX3Copia[03][2] , "" , "CT1", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	
	aAdd(aSX3     ,{	"CTT",ProxSX3("CTT","CTT_CCVMN" ), "CTT_CCVMN"   , "C", 9 , 0, "CC Var Mon N" , "CC Var Mon N" , "CC Var Mon N" , "C.C Variação Monet Negat" , "C.C Variacion Monet Negat" , "C.C Variation Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTT", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	aAdd(aSX3     ,{	"CTT",ProxSX3("CTT","CTT_CCRDN" ), "CTT_CCRDN"   , "C", 9 , 0, "CC Red Var N" , "CC Red Var N" , "CC Red Var N" , "C.C Red. Var Monet Negat" , "C.C Red. Var. Monet Negat" , "C.C Red. Var. Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTT", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	
	aAdd(aSX3     ,{	"CTD",ProxSX3("CTD","CTD_ITVMN" ), "CTD_ITVMN"   , "C", 9, 0, "IT Var Mon N" , "IT Var Mon N" , "IT Var Mon N" , "I.T Variação Monet Negat" , "I.T Variacion Monet Negat" , "I.T Variation Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTD", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	aAdd(aSX3     ,{	"CTD",ProxSX3("CTD","CTD_ITRDN" ), "CTD_ITRDN"   , "C", 9, 0, "IT.Red Var N" , "IT.Red Var N" , "IT.Red Var N" , "I.T Red. Var Monet Negat" , "I.T Red. Var. Monet Negat" , "I.T Red. Var. Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTD", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	
	aAdd(aSX3     ,{	"CTH",ProxSX3("CTH","CTH_CLVMN" ), "CTH_CLVMN"   , "C", 9, 0, "CL Var Mon N" , "CL Var Mon N" , "CL Var Mon N" , "C.L Variação Monet Negat" , "C.L Variacion Monet Negat" , "C.L Variation Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTH", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
	aAdd(aSX3     ,{	"CTH",ProxSX3("CTH","CTH_CLRDN" ), "CTH_CLRDN"   , "C", 9, 0, "CL Red Var N" , "CL Red Var N" , "CL Red Var N" , "C.L Red. Var Monet Negat" , "C.L Red. Var. Monet Negat" , "C.L Red. Var. Monet Negat" , "@!" , "" , aSX3Copia[03][2] , "" , "CTH", 1	, aSX3Copia[03][3]	, "", "" , "", "N", "A"	, "R" , "", "", ""	, "" , "", "", "" , "", "","","S"})
EndIf


aAdd( aSX3, { "CT1", ProxSX3( "CT1", "CT1_TPO01" ), "CT1_TPO01", "C", 2, 0, "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "@!", "", aSX3Copia[06,2]  , "", "", 1, aSX3Copia[06,3], "", "","S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CT1", ProxSX3( "CT1", "CT1_TPO02" ), "CT1_TPO02", "C", 2, 0, "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CT1", ProxSX3( "CT1", "CT1_TPO03" ), "CT1_TPO03", "C", 2, 0, "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CT1", ProxSX3( "CT1", "CT1_TPO04" ), "CT1_TPO04", "C", 2, 0, "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )

aAdd( aSX3, { "CTT", ProxSX3( "CTT", "CTT_TPO01" ), "CTT_TPO01", "C", 2, 0, "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTT", ProxSX3( "CTT", "CTT_TPO02" ), "CTT_TPO02", "C", 2, 0, "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTT", ProxSX3( "CTT", "CTT_TPO03" ), "CTT_TPO03", "C", 2, 0, "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTT", ProxSX3( "CTT", "CTT_TPO04" ), "CTT_TPO04", "C", 2, 0, "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )

aAdd( aSX3, { "CTD", ProxSX3( "CTD", "CTD_TPO01" ), "CTD_TPO01", "C", 2, 0, "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTD", ProxSX3( "CTD", "CTD_TPO02" ), "CTD_TPO02", "C", 2, 0, "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTD", ProxSX3( "CTD", "CTD_TPO03" ), "CTD_TPO03", "C", 2, 0, "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTD", ProxSX3( "CTD", "CTD_TPO04" ), "CTD_TPO04", "C", 2, 0, "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )

aAdd( aSX3, { "CTH", ProxSX3( "CTH", "CTH_TPO01" ), "CTH_TPO01", "C", 2, 0, "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "Tipo Ctb 01", "Tipo Ctb 01", "Type Ctb 01", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTH", ProxSX3( "CTH", "CTH_TPO02" ), "CTH_TPO02", "C", 2, 0, "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "Tipo Ctb 02", "Tipo Ctb 02", "Type Ctb 02", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTH", ProxSX3( "CTH", "CTH_TPO03" ), "CTH_TPO03", "C", 2, 0, "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "Tipo Ctb 03", "Tipo Ctb 03", "Type Ctb 03", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )
aAdd( aSX3, { "CTH", ProxSX3( "CTH", "CTH_TPO04" ), "CTH_TPO04", "C", 2, 0, "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "Tipo Ctb 04", "Tipo Ctb 04", "Type Ctb 04", "@!", "", aSX3Copia[06,2], "", "", 1, aSX3Copia[06,3], "", "", "S", "N", "V", "R", "", "", "", "", "", "", "", "", "", "1", "S" } )

//Inclusão de campos para o Historico na Capa do Lote
If cPaisLoc == "ARG"
	
	aAdd( aSX3, { "CT5", ProxSX3( "CT5", "CT5_DOCHIS" ), "CT5_DOCHIS", "C", 80, 0, "Hist Documen", "Hist Documen", "Hist Documen", "Historico do Documento", "Historial del documento", "Hist. do Doc. Contabil", "@!", "", aSX3Copia[03,2], "", "", 1, "þÀ", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_DOCHIS" ), "CTC_DOCHIS", "C", 80, 0, "Hist Documen", "Hist Documen", "Hist Documen", "Historico do Documento", "Historial del documento", "Hist. do Doc. Contabil", "@!", "", aSX3Copia[03,2], "", "", 1, "þÀ", "", "", "S", "S", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	
	aPHelpPor := { "Historico do documento, de acordo com o ","Lançamento Padrão." }
	aPHelpEng := {"Document history according to Standard ","Entry."}
	aPHelpEsp := {"Historial del documento, de acuerdo con ","el Asiento Estandar."}
	PutHelp( "PCT5_DOCHIS", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	PutHelp( "PCTC_DOCHIS", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_MOEDDC" ), "CTC_MOEDDC", "C", 2, 0, "Moeda do Doc", "Moneda Doc.", "Moeda do Doc", "Moeda base do documento contábil."	, "Moneda del doc. contable"	, "Moeda do Documento Contab"	, "@!"			, "", aSX3Copia[03,2], ""	, ""	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_CRITDC" ), "CTC_CRITDC", "C", 5, 0, "Crit Con Doc", "Crit Con Doc", "Crit Con Doc", "Crit. de Conver. do Doc."	, "Crit. de Conver. del Doc."	, "Crit. de Conver. do Doc."	, "@!"			, "", aSX3Copia[03,2], ""	, ""	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_DTTXDC" ), "CTC_DTTXDC", "D", 8, 0, "Dt.Conv. Doc", "Fch.Conv.Doc", "Dt.Conv. Doc", "Data de Conv. do Doc."		, "Fecha de Conv. documento"		, "Data de Conv. do Doc."		, "99/99/9999"	, "", aSX3Copia[03,2], ""	, ""	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_TPSADC" ), "CTC_TPSADC", "C", 1, 0, "Tip Sald Doc", "Tip Sald Doc", "Tip Sald Doc", "Tipo do Saldo do Doc."		, "Tipo de Saldo del Doc."		, "Tipo do Saldo do Doc."		, "!"			, "", aSX3Copia[03,2], "1", "SLW"	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_DIACTB" ), "CTC_DIACTB", "C", 2, 0, "Livro Diario", "Libro Diario", "Livro Diario", "Livro Diario"				, "Libro Diario"				, "Livro Diario"				, "@!"			, "", aSX3Copia[03,2], "" , "CVL"	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	aAdd( aSX3, { "CTC", ProxSX3( "CTC", "CTC_NODIA" ) , "CTC_NODIA" , "C", 10, 0, "Num. Diario" , "Num. Diario" , "Num. Diario" , "Numero do Diario"			, "Num. Diario"			, "Numero do Diario"			, "@!"			, "",aSX3Copia[03,2], "" , ""	, 1, "þA", "", "", "S", "N", "A", "R", "N", "", "", "", "", "", "", "", "", "", "S" } )
	
	aPHelpPor := { "Moeda base do documento contábil." }
	aPHelpEng := {"Base currency of the accounting document"}
	aPHelpEsp := {"Moneda base del documento contable."}
	PutHelp( "PCTC_MOEDDC", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aPHelpPor := { "Criterio de conversao do documento contábil" }
	aPHelpEng := {"Criterion conversion of the accounting ","document."}
	aPHelpEsp := {"Criterio de conversion del documento ","contable."}
	PutHelp( "PCTC_CRITDC", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aPHelpPor := { "Data da taxa de conversao do documento"," contábil" }
	aPHelpEng := {"Date of conversion rate of the ","accounting document."}
	aPHelpEsp := {"Fecha de la tasa de conversion del ","documento contable."}
	PutHelp( "PCTC_DTTXDC", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aPHelpPor := { "Tipo de saldo do documento contábil" }
	aPHelpEng := {"Type of balance of the accounting ","document."}
	aPHelpEsp := {"Tipo de saldo del documento contable."}
	PutHelp( "PCTC_TPSADC", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aPHelpPor := { "Livro Diario" }
	aPHelpEng := {"Diary Book."}
	aPHelpEsp := {"Libro diario."}
	PutHelp( "PCTC_DIACTB", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
	aPHelpPor := { "Numero Diario" }
	aPHelpEng := {"Diary Number."}
	aPHelpEsp := {"Numero Diario."}
	PutHelp( "PCTC_NODIA", aPHelpPor, aPHelpEng, aPHelpEsp, .T. )
	
EndIf

If nTamFilial <> 2 .And. CTBUpdField("SX3", 2, "CT2_FILORI", "X3_TAMANHO",nTamFilial, 2)
	lSX3 := .T.
	cAlias += "/CT2"
	aAdd(aArqUpd, "CT2")
EndIf

If CTBUpdField("SX3", 2, "CT2_FILORI", "X3_GRPSXG","033")
	lSX3 := .T.
	cAlias += "/CT2"
	aAdd(aArqUpd, "CT2")
EndIf

If nTamFilial <> 2 .And. CTBUpdField("SX3", 2, "CTB_FILORI", "X3_TAMANHO",nTamFilial, 2)
	lSX3 := .T.
	cAlias += "/CTB"
	aAdd(aArqUpd, "CTB")
EndIf

If CTBUpdField("SX3", 2, "CVC_PAIS", "X3_TIPO","C")
	lSX3 := .T.
	cAlias += "/CVC"
	aAdd(aArqUpd, "CVC")
EndIf

If CTBUpdField("SX3", 2, "CVC_PAIS", "X3_TAMANHO",5)
	lSX3 := .T.
	cAlias += "/CVC"
	aAdd(aArqUpd, "CVC")
EndIf

If CTBUpdField("SX3", 2, "CVC_DTINI","X3_USADO",aSX3Copia[03][2])
	lSX3 := .T.
	cAlias += "/CVC"
	aAdd(aArqUpd, "CVC")
EndIf

If CTBUpdField("SX3", 2, "CVC_DTFIM","X3_USADO",aSX3Copia[03][2])
	lSX3 := .T.
	cAlias += "/CVC"
	aAdd(aArqUpd, "CVC")
EndIf

If CTBUpdField("SX3", 2, "CW0_CHAVE", "X3_TAMANHO",15)
	lSX3 := .T.
	cAlias += "/CW0"
	aAdd(aArqUpd, "CW0")
EndIf

If CTBUpdField("SX3", 2, "CTB_FILORI", "X3_GRPSXG","033")
	lSX3 := .T.
	cAlias += "/CTB"
	aAdd(aArqUpd, "CTB")
EndIf

If CTBUpdField("SX3", 2, "CTO_DTINIC","X3_USADO",aSX3Copia[03][2]	,"")
	lSX3 := .T.
	cAlias += "/CTO"
	aAdd(aArqUpd, "CTO")
EndIf

If CTBUpdField("SX3", 2, "CTO_DTINIC","X3_RESERV",aSX3Copia[03][3],"")
	lSX3 := .T.
	cAlias += "/CTO"
	aAdd(aArqUpd, "CTO")
EndIf

If CTBUpdField("SX3", 2, "CTO_DTFINA","X3_USADO",aSX3Copia[03][2]	,"")
	lSX3 := .T.
	cAlias += "/CTO"
	aAdd(aArqUpd, "CTO")
EndIf

If CTBUpdField("SX3", 2, "CW8_FILTAB","X3_TAMANHO",nTamFilial)
	lSX3 := .T.
	cAlias += "/CW8"
	aAdd(aArqUpd, "CW8")
EndIf

If CTBUpdField("SX3", 2, "CW8_FILIAL","X3_TAMANHO",nTamFilial)
	lSX3 := .T.
	cAlias += "/CW8"
	aAdd(aArqUpd, "CW8")
EndIf

If CTBUpdField("SX3", 2, "CW8_CODIGO","X3_TAMANHO",70)
	lSX3 := .T.
	cAlias += "/CW8"
	aAdd(aArqUpd, "CW8")
EndIf

If CTBUpdField("SX3", 2, "CW8_GRUPO","X3_TAMANHO",9)
	lSX3 := .T.
	cAlias += "/CW8"
	aAdd(aArqUpd, "CW8")
EndIf

If CTBUpdField("SX3", 2, "CTO_DTINIC","X3_RESERV",aSX3Copia[03][3],"")
	lSX3 := .T.
	cAlias += "/CTO"
	aAdd(aArqUpd, "CTO")
EndIf

If CTBUpdField("SX3", 2, "CT2_ITEMD","X3_VALID",'CTB105ITEM(m->CT2_ITEMD,"1") .And. CtbAmarra(TMP->CT2_DEBITO,TMP->CT2_CCD,TMP->CT2_ITEMD,TMP->CT2_CLVLDB,.T.)')
	lSX3 := .T.
	cAlias += "/CT2"
	aAdd(aArqUpd, "CT2")
EndIf

If CTBUpdField("SX3", 2, "CTO_DTINIC", "X3_RESERV", aSX3Copia[03][3], "")
	lSX3 := .T.
	cAlias += "/CTO"
	aAdd(aArqUpd, "CTO")
EndIf

If CTBUpdField("SX3", 2, "CV0_ENTSUP", "X3_VALID", "CTB050ESup(M->CV0_PLANO,M->CV0_ENTSUP)", "CTB050ESup(,M->CV0_ENTSUP)")
	lSX3 := .T.
	cAlias += "/CV0"
	aAdd(aArqUpd, "CV0")
EndIf

If CTBUpdField("SX3", 2, "CTT_CUSTO", "X3_VALID", "Ctb030Cus()", 'ExistChav("CTT",,1) .And. Ctb030Sup(M->CTT_CUSTO) .And. CtbCCLP(M->CTT_CUSTO) .And. FreeForUse("CTT",m->ctt_custo)')
	lSX3 := .T.
	cAlias += "/CTT"
	aAdd(aArqUpd, "CTT")
EndIf

If CTBUpdField("SX3", 2, "CTD_ITEM", "X3_VALID", "Ctb040Item()", 'ExistChav("CTD",,1) .And. Ctb040Sup(M->CTD_ITEM) .And. CtbItemLP(M->CTD_ITEM) .And. FreeForUse("CTD",m->ctd_item)')
	lSX3 := .T.
	cAlias += "/CTD"
	aAdd(aArqUpd, "CTD")
EndIf

If CTBUpdField("SX3", 2, "CTH_CLVL", "X3_VALID", "Ctb040ClVl()", 'ExistChav("CTH",,1) .And. Ctb060Sup(M->CTH_CLVL) .And. CtbCLVLLP(M->CTH_CLVL) .And. FreeForUse("CTH",m->cth_clvl)')
	lSX3 := .T.
	cAlias += "/CTH"
	aAdd(aArqUpd, "CTH")
EndIf

If CTBUpdField("SX3", 2, "CV0_PLANO", "X3_WHEN", "CTB050SX3('CV0_PLANO')")
	lSX3 := .T.
	cAlias += "/CV0"
EndIf

If CTBUpdField("SX3", 2, "CV0_ITEM", "X3_WHEN", "CTB050SX3('CV0_ITEM')")
	lSX3 := .T.
	cAlias += "/CV0"
EndIf

If CTBUpdField("SX3", 2, "CV0_CODIGO", "X3_WHEN", "CTB050WHEN() .And. CTB050SX3('CV0_CODIGO')" )
	lSX3 := .T.
	cAlias += "/CV0"
EndIf

If CTBUpdField("SX3", 2, "CV0_ENTSUP", "X3_WHEN", "CTB050SX3('CV0_ENTSUP')")
	lSX3 := .T.
	cAlias += "/CV0"
EndIf

If CTBUpdField("SX3", 2, "CW0_CHAVE", "X3_TAMANHO", 15)
	lSX3 := .T.
	cAlias += "/CW0"
	aAdd(aArqUpd, "CW0")
EndIf


If CTBUpdField("SX3", 2, "CTA_REGRA", "X3_RELACAO", "GetSXENum('CTA','CTA_REGRA')")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

If CTBUpdField("SX3", 2, "CTA_ITREGR", "X3_ORDEM", "05")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

If CTBUpdField("SX3", 2, "CTA_CONTA", "X3_ORDEM", "06")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

If CTBUpdField("SX3", 2, "CTA_CUSTO", "X3_ORDEM", "07")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

If CTBUpdField("SX3", 2, "CTA_ITEM", "X3_ORDEM", "08")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

If CTBUpdField("SX3", 2, "CTA_CLVL", "X3_ORDEM", "09")
	lSX3 := .T.
	cAlias += "/CTA"
EndIf

IF cPaisLoc $ "URU"
	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_USADO",aSX3Copia[03][2])
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf
	
	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_RESERV",aSX3Copia[03][3])
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf

	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_TITSPA","Md. Variacion")
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf
	
	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_DESCSPA","Moneda fuerte de variac.")
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf

	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_TITENG","Var.Currency")
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf
	
	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_DESCENG","Variation Strong Currency")
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf	

	If CTBUpdField("SX3", 2, "CT1_MOEDVM","X3_PROPRI","S")
		lSX3 := .T.
		cAlias += "/CT1"
		aAdd(aArqUpd, "CT1")
	EndIf
EndIf

If CTBUpdField("SX3", 2, "CTC_DATA", "X3_BROWSE","S")
	lSX3 := .T.
	cAlias += "/CTC"
	aAdd(aArqUpd, "CTC")
EndIf

dbSelectArea("SX3")
dbSetOrder(2)	// SX3->X3_CAMPO

For j := 1 To 2
	cAux := If(j == 1, "CT2_VALR", "CT2_DTTX")
	SX3->(DBSeek(cAux))
	While cAux $ SX3->X3_CAMPO
		// Adiciona os Campos conforme aEstrut
		For i := 1 To Len(aEstrut)
			If FieldPos(aEstrut[i]) > 0
				Aadd( aAux, FieldGet(FieldPos(aEstrut[i])) )
				If aEstrut[i] == "X3_VALID"
					Atail(aAux) := StrTran(Atail(aAux),If(j==1,"CT2_VALR02","CT2_DTTX02"),SX3->X3_CAMPO)
				EndIf
			EndIf
		Next i
		Aadd(aAux, .T. )	//Forca alteracao do Campo
		Aadd(aSX3, aAux)	//Atribui ao conjunto principal
		aAux := {}			//Libera variavel
		SX3->(DBSkip())		//Proximo Registro (Campo)
	End
Next j

aSort(aSx3,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
ProcRegua(Len(aSx3))

For i:= 1 To Len(aSx3)
	If !Empty(aSx3[i][1])
		If !dbSeek(aSx3[i,3])
			lSX3	:= .T.
			If !(aSx3[i,1]$cAlias)
				cAlias += aSx3[i,1]+"/"
				If Ascan(aArqUpd,aSX3[i,1]) == 0
					aAdd(aArqUpd,aSX3[i,1])
				EndIf
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If j > 36    //caso esteja criando a tabela devera considerar somente os campos - posicao 37 indica se alterou campo
					Exit
				EndIf
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc(STR0034) //"Atualizando Dicionario de Dados..."
			
		Else // Tratamento de alteracao para campos já existentes
			If Len(aSX3[i])>36 .And. ValType(aSX3[i,37]) != "L"
				CONOUT("Erro: Campo "+ aSx3[i,3] )
			EndIf
			If Len(aSX3[i])>36 .And. ValType(aSX3[i,37]) == "L" .And. aSX3[i,37] // Atualiza sob demanda, colocando .t. na 37 posição do array
				lSX3	:= .T.
				If !(aSX3[i,1]$cAlias)
					cAlias += aSX3[i,1]+"/"
					If Ascan(aArqUpd,aSX3[i,1]) == 0
						aAdd(aArqUpd,aSX3[i,1])
					EndIf
				EndIf
				
				RecLock("SX3",.F.)
				For j:=1 To Len(aSX3[i])-1   //-1 POIS POSICAO 37 INDICA ALTERACAO DA CARACTERISTICA DO CAMPO
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				Next j
				
				dbCommit()
				MsUnLock()
				IncProc(STR0034) //"Atualizando Dicionario de Dados..."
			Endif
		EndIf
	EndIf
Next i

//Atualiza ordem dos campos
ProcRegua(Len(aSX3Ordem))

For i:= 1 To Len(aSX3Ordem)
	If !Empty(aSX3Ordem[i][1]) .And. !Empty(aSX3Ordem[i][2]) .And. !Empty(aSX3Ordem[i][3])
		If DbSeek(aSX3Ordem[i,3])
			lSX3	:= .T.
			
			RecLock("SX3",.F.)
			For j:=1 To Len(aSX3Ordem[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3Ordem[i,j])
				EndIf
			Next j
			
			DbCommit()
			MsUnLock()
			IncProc(STR0034) //"Atualizando Dicionario de Dados..."
			
		EndIf
	EndIf
Next i

If lSX3
	cTexto := STR0035+cAlias+CRLF //'Tabelas atualizadas : '
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuHlp ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da atualizacao dos helps de campos    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuHlp()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpEsp	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionar aqui as tabelas atualizadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias	:= "CTQ/CW1/CW2/CW3/CVD/CVN/CTS"

If cPaisLoc == "COL"
	cAlias += "/SA1/SA2/CV0/CVC/CVD/CVN"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Help de campos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Tabela CTQ

aHelpPor :=	{	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"		,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total das demais linhas"	,;
"sendo que o sistema calculará automa-"	,	"ticamente."}
aHelpEng := {	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"		,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total das demais linhas"	,;
"sendo que o sistema calculará automa-"	,	"ticamente."}
aHelpEsp := {	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"		,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total das demais linhas"	,;
"sendo que o sistema calculará automa-"	,	"ticamente."}
PutHelp("PCTQ_VALOR",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha de detalhe do rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEng := {	"Fórmula utilizada para determinar o "	,	"fator da linha de detalhe do rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEsp := {	"Fórmula utilizada para determinar o "	,	"fator da linha de detalhe do rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
PutHelp("PCTQ_FORMUL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
aHelpEng := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
aHelpEsp := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
PutHelp("PCTQ_INTERC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código da amarração de grupos de rateio"	,	"que gerou este cadastro, caso o mesmo",;
"esteja relacionado a uma amarração."}
aHelpEng := {	"Código da amarração de grupos de rateio"	,	"que gerou este cadastro, caso o mesmo",;
"esteja relacionado a uma amarração."}
aHelpEsp := {	"Código da amarração de grupos de rateio"	,	"que gerou este cadastro, caso o mesmo",;
"esteja relacionado a uma amarração."}
PutHelp("PCTQ_AMARRA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor := {	"Indica se o rateio será considerado"	,	"no processamento de rateios off-line."	}
aHelpEng := {	"Indica se o rateio será considerado"	,	"no processamento de rateios off-line."	}
aHelpEsp := {	"Indica se o rateio será considerado"	,	"no processamento de rateios off-line."	}
PutHelp("PCTQ_MSBLQL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Indica se o cadastro de rateios está"	,	"com um percentual válido para utilização."	}
aHelpEng :=	{	"Indica se o cadastro de rateios está"	,	"com um percentual válido para utilização."	}
aHelpEsp :=	{	"Indica se o cadastro de rateios está"	,	"com um percentual válido para utilização."	}
PutHelp("PCTQ_STATUS",aHelpPor,aHelpEng,aHelpEsp,.T.)

//Tabela CW1

aHelpPor :=	{	"Código que individualiza cada Grupo"	,	"de Rateio."	}
aHelpEng := {	"Código que individualiza cada Grupo"	,	"de Rateio."	}
aHelpEsp := {	"Código que individualiza cada Grupo"	,	"de Rateio."	}
PutHelp("PCW1_CODIGO",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Descricao do Grupo de Rateio."	}
aHelpEng :=	{	"Descricao do Grupo de Rateio."	}
aHelpEsp :=	{	"Descricao do Grupo de Rateio."	}
PutHelp("PCW1_DESCRI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Tipo do Grupo de Rateio. Podera ser:"	,	"1-Origem"	,	"2-Destino"	}
aHelpEng :=	{	"Tipo do Grupo de Rateio. Podera ser:"	,	"1-Origem"	,	"2-Destino"	}
aHelpEsp :=	{	"Tipo do Grupo de Rateio. Podera ser:"	,	"1-Origem"	,	"2-Destino"	}
PutHelp("PCW1_TIPO",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Número sequencial do item do Grupo"	,	"de Rateio. Sua geração é automática."	}
aHelpEng :=	{	"Número sequencial do item do Grupo"	,	"de Rateio. Sua geração é automática."	}
aHelpEsp :=	{	"Número sequencial do item do Grupo"	,	"de Rateio. Sua geração é automática."	}
PutHelp("PCW1_SEQUEN",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Codigo do Índice Estatístico utiliza-"	,	"do no Grupo de Rateio. Não é obriga-",;
"tório, mas se for informado, uma das"	,	"entidades contábeis informada na li-",;
"nha, devera estar cadastrada neste"	,	"Índice Estatístico"					}
aHelpEng :=	{	"Codigo do Índice Estatístico utiliza-"	,	"do no Grupo de Rateio. Não é obriga-",;
"tório, mas se for informado, uma das"	,	"entidades contábeis informada na li-",;
"nha, devera estar cadastrada neste"	,	"Índice Estatístico"					}
aHelpEsp :=	{	"Codigo do Índice Estatístico utiliza-"	,	"do no Grupo de Rateio. Não é obriga-",;
"tório, mas se for informado, uma das"	,	"entidades contábeis informada na li-",;
"nha, devera estar cadastrada neste"	,	"Índice Estatístico"					}
PutHelp("PCW1_INDICE",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código da Conta Contábil."				,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Conta de Origem"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravada no"	,	"campo CTQ_CTORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Contra Partida"	,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravada no"	,;
"campo CTQ_CTCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEng :=	{	"Código da Conta Contábil."				,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Conta de Origem"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravada no"	,	"campo CTQ_CTORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Contra Partida"	,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravada no"	,;
"campo CTQ_CTCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEsp :=	{	"Código da Conta Contábil."				,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Conta de Origem"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravada no"	,	"campo CTQ_CTORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Contra Partida"	,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravada no"	,;
"campo CTQ_CTCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
PutHelp("PCW1_CONTA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Centro de Custo."			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Centro de Custo"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CCORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Centro de Custo",;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CCCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEng :=	{	"Código do Centro de Custo."			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Centro de Custo"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CCORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Centro de Custo",;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CCCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEsp :=	{	"Código do Centro de Custo."			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Centro de Custo"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CCORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Centro de Custo",;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CCCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
PutHelp("PCW1_CCUSTO",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Item Contábil."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Item Contábil"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_ITORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Item Contábil"  ,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_ITCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEng :=	{	"Código do Item Contábil."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Item Contábil"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_ITORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Item Contábil"  ,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_ITCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEsp :=	{	"Código do Item Contábil."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, este será o Item Contábil"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_ITORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, este será o Item Contábil"  ,;
"do lançamento de Rateio."				,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_ITCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
PutHelp("PCW1_ITEM",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código da Classe de Valor."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Classe de Valor"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CLORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Classe de"      ,;
"Valor do lançamento de Rateio."		,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CLCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEng :=	{	"Código da Classe de Valor."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Classe de Valor"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CLORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Classe de"      ,;
"Valor do lançamento de Rateio."		,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CLCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
aHelpEsp :=	{	"Código da Classe de Valor."  			,	"Se este Grupo de Rateio for do tipo"   ,;
"1-Origem, esta será a Classe de Valor"	,	"para obter o valor a ser rateado."     ,;
"Na geração do rateio, será gravado no"	,	"campo CTQ_CLORI."                      ,;
"Se este Grupo de Rateio for do tipo" 	,	"2-Destino, esta será a Classe de"      ,;
"Valor do lançamento de Rateio."		,	"Na geração do rateio, será gravado no"	,;
"campo CTQ_CLCPAR."	   					,	"Lembrando que a origem, a partida e a" ,;
"contra-partida de um rateio poderá "	,	"ser composta por: Conta + Centro de "  ,;
"Custo + Item Contábil + Classe Valor."	}
PutHelp("PCW1_CLVL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Se este Grupo de Rateio for do tipo"	,	"1-Origem, este percentual correspoderá"	,;
"ao Percentual Base do rateio (campo"	,	"CTQ_PERBAS), que é o percentual apli-" 	,;
"cado ao valor de origem do rateio "	,	"para encontrar o valor a ser rateado."		,;
"Se este Grupo de Rateio for do tipo"	,	"2-Destino, este percentual será da linha"	,;
"de rateio gerada pela amarração.	"	,	"Caso sejam combinadas diversos grupos de"	,;
"rateio, os percentuais serão distri-"	,	"buídos entre cada entidade."}
aHelpEng :=	{	"Se este Grupo de Rateio for do tipo"	,	"1-Origem, este percentual correspoderá"	,;
"ao Percentual Base do rateio (campo"	,	"CTQ_PERBAS), que é o percentual apli-" 	,;
"cado ao valor de origem do rateio "	,	"para encontrar o valor a ser rateado."		,;
"Se este Grupo de Rateio for do tipo"	,	"2-Destino, este percentual será da linha"	,;
"de rateio gerada pela amarração.	"	,	"Caso sejam combinadas diversos grupos de"	,;
"rateio, os percentuais serão distri-"	,	"buídos entre cada entidade."}
aHelpEsp :=	{	"Se este Grupo de Rateio for do tipo"	,	"1-Origem, este percentual correspoderá"	,;
"ao Percentual Base do rateio (campo"	,	"CTQ_PERBAS), que é o percentual apli-" 	,;
"cado ao valor de origem do rateio "	,	"para encontrar o valor a ser rateado."		,;
"Se este Grupo de Rateio for do tipo"	,	"2-Destino, este percentual será da linha"	,;
"de rateio gerada pela amarração.	"	,	"Caso sejam combinadas diversos grupos de"	,;
"rateio, os percentuais serão distri-"	,	"buídos entre cada entidade."}
PutHelp("PCW1_PERCEN",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"	,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total do grupo,"		,;
"sendo que o sistema calculará automa-"	,	"ticamente."									,;
"Este campo é utilizado apenas para "	,	"grupos do tipo destino, e caso o grupo	"		,;
"esteja vinculado a um índice estatís-"	,	"tico, ele será atualizado automaticamente"		,;
"por qualque alteração neste índice."}
aHelpEng := {	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"	,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total do grupo,"		,;
"sendo que o sistema calculará automa-"	,	"ticamente."									,;
"Este campo é utilizado apenas para "	,	"grupos do tipo destino, e caso o grupo	"		,;
"esteja vinculado a um índice estatís-"	,	"tico, ele será atualizado automaticamente"		,;
"por qualque alteração neste índice."}
aHelpEsp :=	{	"O fator é um valor relacionado a um"	,	"indicador de qualquer natureza que permita"	,;
"determinar o percentual de uma linha"	, 	"de rateio em relação ao total do grupo,"		,;
"sendo que o sistema calculará automa-"	,	"ticamente."									,;
"Este campo é utilizado apenas para "	,	"grupos do tipo destino, e caso o grupo	"		,;
"esteja vinculado a um índice estatís-"	,	"tico, ele será atualizado automaticamente"		,;
"por qualque alteração neste índice."}
PutHelp("PCW1_FATOR",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do grupo de rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEng :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do grupo de rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEsp :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do grupo de rateio."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
PutHelp("PCW1_FORMUL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Indica se o grupo de rateios está"		,	"com um percentual válido para utilização."	}
aHelpEng :=	{	"Indica se o grupo de rateios está"		,	"com um percentual válido para utilização."	}
aHelpEsp :=	{	"Indica se o grupo de rateios está"		,	"com um percentual válido para utilização."	}
PutHelp("PCW1_STATUS",aHelpPor,aHelpEng,aHelpEsp,.T.)

//Tabela CW2

aHelpPor :=	{	"Código que individualiza cada"			,	"Amarração de Grupo de Rateio."	}
aHelpEng :=	{	"Código que individualiza cada"			,	"Amarração de Grupo de Rateio."	}
aHelpEsp :=	{	"Código que individualiza cada"			,	"Amarração de Grupo de Rateio."	}
PutHelp("PCW2_CODIGO",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Descrição a ser atribuida aos rateios ",	"que forem gerados pela amarração",;
"Como este campo é do tipo fórmula "	,	"textos	simples deverão ser informados",;
"entre aspas"}
aHelpEng :=	{	"Descrição a ser atribuida aos rateios ",	"que forem gerados pela amarração",;
"Como este campo é do tipo fórmula "	,	"textos	simples deverão ser informados",;
"entre aspas"}
aHelpEsp :=	{	"Descrição a ser atribuida aos rateios ",	"que forem gerados pela amarração",;
"Como este campo é do tipo fórmula "	,	"textos	simples deverão ser informados",;
"entre aspas"}
PutHelp("PCW2_DESCRI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Campo informativo que apresenta a"		,	"situação da amarração, que pode ser:"  ,;
"1-Pendente: a Amarração foi cadastra-"	,	"da mas o rateio ainda não foi gerado;"	,;
"2-Alterada: um dos grupos desta"		,	"Amarração sofreu alteração e o rateio"	,;
"ainda não foi gerado novamente;"		,	"3-Gerada: ja foi gerado o rateio para"	,;
"esta Amarração"	}
aHelpEng :=	{	"Campo informativo que apresenta a"		,	"situação da amarração, que pode ser:"  ,;
"1-Pendente: a Amarração foi cadastra-"	,	"da mas o rateio ainda não foi gerado;"	,;
"2-Alterada: um dos grupos desta"		,	"Amarração sofreu alteração e o rateio"	,;
"ainda não foi gerado novamente;"		,	"3-Gerada: ja foi gerado o rateio para"	,;
"esta Amarração"	}
aHelpEsp :=	{	"Campo informativo que apresenta a"		,	"situação da amarração, que pode ser:"  ,;
"1-Pendente: a Amarração foi cadastra-"	,	"da mas o rateio ainda não foi gerado;"	,;
"2-Alterada: um dos grupos desta"		,	"Amarração sofreu alteração e o rateio"	,;
"ainda não foi gerado novamente;"		,	"3-Gerada: ja foi gerado o rateio para"	,;
"esta Amarração"	}
PutHelp("PCW2_STATUS",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Fórmula para definir a conta    "		,	"contabil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"conta contabil partida."}
aHelpEng :=	{	"Fórmula para definir a conta    "		,	"contabil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"conta contabil partida."}
aHelpEsp :=	{	"Fórmula para definir a conta    "		,	"contabil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"conta contabil partida."}

PutHelp("PCW2_CT1PAF",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Conta contábil que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à conta de"		,	"partida do CTQ e será gravada no"		,;
"campo CTQ_CTPAR."						,	"Este campo não aceita fórmulas."       }
aHelpEng :=	{	"Conta contábil que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à conta de"		,	"partida do CTQ e será gravada no"		,;
"campo CTQ_CTPAR."						,	"Este campo não aceita fórmulas."       }
aHelpEsp :=	{	"Conta contábil que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à conta de"		,	"partida do CTQ e será gravada no"		,;
"campo CTQ_CTPAR."						,	"Este campo não aceita fórmulas."       }

PutHelp("PCW2_CT1PAR",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Fórmula para definir o centro   "		,	"de custo de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"centro de custo partida."}
aHelpEng :=	{	"Fórmula para definir o centro   "		,	"de custo de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"centro de custo partida."}
aHelpEsp :=	{	"Fórmula para definir o centro   "		,	"de custo de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"centro de custo partida."}

PutHelp("PCW2_CTTPAF",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Centro de Custo que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao centro de"	,	"custo de partida do CTQ e será"		,;
"gravado no campo CTQ_CCPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEng :=	{	"Centro de Custo que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao centro de"   ,	"custo de partida do CTQ e será"		,;
"gravado no campo CTQ_CCPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEsp :=	{	"Centro de Custo que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao centro de"	,	"custo de partida do CTQ e será"		,;
"gravado no campo CTQ_CCPAR."			,	"Este campo não aceita fórmulas."       }

PutHelp("PCW2_CTTPAR",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Fórmula para definir o item     "		,	"contábil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"item contábil partida."}
aHelpEng :=	{	"Fórmula para definir o item     "		,	"contábil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"item contábil partida."}
aHelpEsp :=	{	"Fórmula para definir o item     "		,	"contábil de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"item contábil partida."}

PutHelp("PCW2_CTDPAF",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Item Contábil que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao item "		,	"contábil de partida do CTQ e será"		,;
"gravado no campo CTQ_ITPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEng :=	{	"Item Contábil que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao item "		,	"contábil de partida do CTQ e será"		,;
"gravado no campo CTQ_ITPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEsp :=	{	"Item Contábil que será Debitado / "	,	"Creditado na geração dos lançamentos"	,;
"de rateio. Corresponde ao item "		,	"contábil de partida do CTQ e será"		,;
"gravado no campo CTQ_ITPAR."			,	"Este campo não aceita fórmulas."       }

PutHelp("PCW2_CTDPAR",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Fórmula para definir a classe   "		,	"de valor de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"classe de valor partida."}
aHelpEng :=	{	"Fórmula para definir a classe   "		,	"de valor de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"classe de valor partida."}
aHelpEsp :=	{	"Fórmula para definir a classe   "		,	"de valor de partida do rateio.",;
"Caso este campo seja informado"		,	"não será utilizada o campo",;
"classe de valor partida."}

PutHelp("PCW2_CTHPAF",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Classe de Valor que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à Classe de "	,	"valor de partida do CTQ e será"		,;
"gravado no campo CTQ_CLPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEng :=	{	"Classe de Valor que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à Classe de "	,	"valor de partida do CTQ e será"		,;
"gravado no campo CTQ_ITPAR."			,	"Este campo não aceita fórmulas."       }
aHelpEsp :=	{	"Classe de Valor que será Debitada / "	,	"Creditada na geração dos lançamentos"	,;
"de rateio. Corresponde à Classe de "	,	"valor de partida do CTQ e será"		,;
"gravado no campo CTQ_ITPAR."			,	"Este campo não aceita fórmulas."       }

PutHelp("PCW2_CTHPAR",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Rateio origem."		,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
aHelpEng :=	{	"Código do Grupo de Rateio origem."		,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
aHelpEsp :=	{	"Código do Grupo de Rateio origem."		,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
PutHelp("PCW2_ORIGEM",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Código do Grupo de C.Custo origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de C.Custo origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de C.Custo origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
PutHelp("PCW2_CTTORI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Item Ctb. origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de Item Ctb. origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de Item Ctb. origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
PutHelp("PCW2_CTDORI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Cl.Valor origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de Cl.Valor origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de Cl.Valor origem."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a origem do valor do"		,	"rateio." }
PutHelp("PCW2_CTHORI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Rateio destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
aHelpEng :=	{	"Código do Grupo de Rateio destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
aHelpEsp :=	{	"Código do Grupo de Rateio destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio.",;
"Este campo aceita um grupo do tipo"	,	"Conta Contábil ou Combinado sendo que",;
"ao utilizar grupos combinados"			,	"não será permitido informar outro grupo."}
PutHelp("PCW2_DESTIN",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de C.Custo destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de C.Custo destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de C.Custo destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
PutHelp("PCW2_CTTDES",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Item Ctb. destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de Item Ctb. destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de Item Ctb. destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
PutHelp("PCW2_CTDDES",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código do Grupo de Cl.Valor destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEng :=	{	"Código do Grupo de Cl.Valor destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }
aHelpEsp :=	{	"Código do Grupo de Cl.Valor destino."	,	"Os dados deste grupo serão utilizados"	,;
"para compor a contra-partida do"		,	"rateio." }

PutHelp("PCW2_CTHDES",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula para definir as contas"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de conta ou combinado."}
aHelpEng :=	{	"Fórmula para definir as contas"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de conta ou combinado."}
aHelpEsp :=	{	"Fórmula para definir as contas"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de conta ou combinado."}
PutHelp("PCW2_CT1DEF",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula para definir os c.custos"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de centro de custos."}
aHelpEng :=	{	"Fórmula para definir os c.custos"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de centro de custos."}
aHelpEsp :=	{	"Fórmula para definir os c.custos"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de centro de custos."}
PutHelp("PCW2_CTTDEF",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula para definir os itens ctb."	,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de itens contábeis."}
aHelpEng :=	{	"Fórmula para definir os itens ctb."	,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de itens contábeis."}
aHelpEsp :=	{	"Fórmula para definir os itens ctb."	,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de itens contábeis."}
PutHelp("PCW2_CTDDEF",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula para definir as cl.valor"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de classes de valores."}
aHelpEng :=	{	"Fórmula para definir as cl.valor"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de classes de valores."}
aHelpEsp :=	{	"Fórmula para definir as cl.valor"		,	"de destino do rateio.",;
"Caso este campo seja informado"		,	"não será utilizado o grupo",;
"destino de classes de valores."}
PutHelp("PCW2_CTHDEF",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula para definir o fator e por"	,	"conseqüência o percentual das linhas",;
"de rateio, quando não é utilizado"		,	"nenhum grupo de entidade destino."}
aHelpEng :={	"Fórmula para definir o fator e por"	,	"conseqüência o percentual das linhas",;
"de rateio, quando não é utilizado"		,	"nenhum grupo de entidade destino."}
aHelpEsp :=	{	"Fórmula para definir o fator e por"	,	"conseqüência o percentual das linhas",;
"de rateio, quando não é utilizado"		,	"nenhum grupo de entidade destino."}
PutHelp("PCW2_FORMUL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
aHelpEng := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
aHelpEsp := {	"Indica se as linhas geradas pela execução"	,	"do rateio serão marcadas para exportação",;
"através da rotina de intercompany." }
PutHelp("PCW2_INTERC",aHelpPor,aHelpEng,aHelpEsp,.T.)

//Tabela CW3

aHelpPor :=	{	"Código que individualiza cada"			,	"Índice Estatístico."	}
aHelpEng :=	{	"Código que individualiza cada"			,	"Índice Estatístico."	}
aHelpEsp :=	{	"Código que individualiza cada"			,	"Índice Estatístico."	}
PutHelp("PCW3_CODIGO",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Descricao do Índice Estatístico."	}
aHelpEng :=	{	"Descricao do Índice Estatístico."	}
aHelpEsp :=	{	"Descricao do Índice Estatístico."	}
PutHelp("PCW3_DESCRI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Número sequencial do item do Índice"	,	"Estatístico. Sua geração é automática."}
aHelpEng :=	{	"Número sequencial do item do Índice"	,	"Estatístico. Sua geração é automática."}
aHelpEsp :=	{	"Número sequencial do item do Índice"	,	"Estatístico. Sua geração é automática."}
PutHelp("PCW3_SEQUEN",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Entidade contábil utilizada no"		,	"Índice Estatístico. Poderá ser:"		,;
"1-Conta Contábil"						,	"2-Centro de Custo"						,;
"3-Item Contábil"						,	"4-Classe de Valor"						}
aHelpEng :=	{	"Entidade contábil utilizada no"		,	"Índice Estatístico. Poderá ser:"		,;
"1-Conta Contábil"						,	"2-Centro de Custo"						,;
"3-Item Contábil"						,	"4-Classe de Valor"						}
aHelpEsp :=	{	"Entidade contábil utilizada no"		,	"Índice Estatístico. Poderá ser:"		,;
"1-Conta Contábil"						,	"2-Centro de Custo"						,;
"3-Item Contábil"						,	"4-Classe de Valor"						}
PutHelp("PCW3_ENTID",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código da Entidade contábil informada"	,	"no campo CW3_ENTID."					,;
"Tecla <F3> abre tela de consulta"	}
aHelpEng :=	{	"Código da Entidade contábil informada"	,	"no campo CW3_ENTID."					,;
"Tecla <F3> abre tela de consulta"	}
aHelpEsp :=	{	"Código da Entidade contábil informada"	,	"no campo CW3_ENTID."					,;
"Tecla <F3> abre tela de consulta"	}
PutHelp("PCW3_CODENT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Código da Unidade de Medida para o"	,	"Índice Estatístico. É um dado infor-"	,;
"mativo, e sua base é o cadastro de"	,	"Unidade de Medida SAH."				,;
"Tecla <F3> para consulta." }
aHelpEng :=	{	"Código da Unidade de Medida para o"	,	"Índice Estatístico. É um dado infor-"	,;
"mativo, e sua base é o cadastro de"	,	"Unidade de Medida SAH."				,;
"Tecla <F3> para consulta." }
aHelpEsp :=	{	"Código da Unidade de Medida para o"	,	"Índice Estatístico. É um dado infor-"	,;
"mativo, e sua base é o cadastro de"	,	"Unidade de Medida SAH."				,;
"Tecla <F3> para consulta." }
PutHelp("PCW3_UM",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"É um valor (não percentual) que re-"	,	"presenta uma parte do total deste in-"	,;
"dice. O sistema calculará auto-"		,	"maticamente o quanto este valor re-"	,;
"presenta percentualmente em relação" 	,	"ao total. É muito útil quando não se"  ,;
"tem o percentual a ser informado," 	,	"mas sim o valor ou a quantidade. Tem"  ,;
"exatamente o mesmo tratamento apli-"	,	"cado ao campo CTQ_VALOR, do cadastro" 	,;
"de Rateio Off-Line"}
aHelpEng :=	{	"É um valor (não percentual) que re-"	,	"presenta uma parte do total deste in-"	,;
"dice. O sistema calculará auto-"		,	"maticamente o quanto este valor re-"	,;
"presenta percentualmente em relação" 	,	"ao total. É muito útil quando não se"  ,;
"tem o percentual a ser informado," 	,	"mas sim o valor ou a quantidade. Tem"  ,;
"exatamente o mesmo tratamento apli-"	,	"cado ao campo CTQ_VALOR, do cadastro" 	,;
"de Rateio Off-Line"}
aHelpEsp :=	{	"É um valor (não percentual) que re-"	,	"presenta uma parte do total deste in-"	,;
"dice. O sistema calculará auto-"		,	"maticamente o quanto este valor re-"	,;
"presenta percentualmente em relação" 	,	"ao total. É muito útil quando não se"  ,;
"tem o percentual a ser informado," 	,	"mas sim o valor ou a quantidade. Tem"  ,;
"exatamente o mesmo tratamento apli-"	,	"cado ao campo CTQ_VALOR, do cadastro" 	,;
"de Rateio Off-Line"}
PutHelp("PCW3_FATOR",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do índice estatítico."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEng :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do índice estatítico."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
aHelpEsp :=	{	"Fórmula utilizada para determinar o "	,	"fator da linha do índice estatítico."		,;
"Para atualizar o fator da linha com "	,	"o resultado da fórmula é necessário"		,;
"utilizar o botão Recalcular."			,	"Somente serão aceitos retornos numéricos"}
PutHelp("PCW3_FORMUL",aHelpPor,aHelpEng,aHelpEsp,.T.)

//------------------------------------------------------------------------------------------------

aHelpPor :=	{"Código do plano referencial"}
aHelpEng :=	{"Código do plano referencial"}
aHelpEsp :=	{"Código do plano referencial"}
PutHelp("PCVD_CODPLA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Código da conta referencial"}
aHelpEng :=	{"Código da conta referencial"}
aHelpEsp :=	{"Código da conta referencial"}
PutHelp("PCVD_CTAREF",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Código do centro de custos"}
aHelpEng :=	{"Código do centro de custos"}
aHelpEsp :=	{"Código do centro de custos"}
PutHelp("PCVD_CUSTO",aHelpPor,aHelpEng,aHelpEsp,.T.)

//------------------------------------------------------------------------------------------------
If cPaisLoc <> "COL"
	aHelpPor :=	{"Código do plano referencial"}
	aHelpEng :=	{"Código do plano referencial"}
	aHelpEsp :=	{"Código do plano referencial"}
	PutHelp("PCVN_CODPLA",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Descrição do plano referencial"}
	aHelpEng :=	{"Descrição do plano referencial"}
	aHelpEsp :=	{"Descrição do plano referencial"}
	PutHelp("PCVN_DSCPLA",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Código da entidade"}
	aHelpEng :=	{"Código da entidade"}
	aHelpEsp :=	{"Código da entidade"}
	PutHelp("PCVN_ENTREF",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Data inicial da vigência"}
	aHelpEng :=	{"Data inicial da vigência"}
	aHelpEsp :=	{"Data inicial da vigência"}
	PutHelp("PCVN_DTVIGI",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Data final da vigência"}
	aHelpEng :=	{"Data final da vigência"}
	aHelpEsp :=	{"Data final da vigência"}
	PutHelp("PCVN_DTVIGF",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Linha/item do plano referencial"}
	aHelpEng :=	{"Linha/item do plano referencial"}
	aHelpEsp :=	{"Linha/item do plano referencial"}
	PutHelp("PCVN_LINHA",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Código conta referencial"}
	aHelpEng :=	{"Código conta referencial"}
	aHelpEsp :=	{"Código conta referencial"}
	PutHelp("PCVN_CTAREF",aHelpPor,aHelpEng,aHelpEsp,.T.)
	
	aHelpPor :=	{"Descrição conta referencial"}
	aHelpEng :=	{"Descrição conta referencial"}
	aHelpEsp :=	{"Descrição conta referencial"}
	PutHelp("PCVN_DSCCTA",aHelpPor,aHelpEng,aHelpEsp,.T.)
EndIf

//------------------------------------------------------------------------------------------------

aHelpPor :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
aHelpEng :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
aHelpEsp :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
PutHelp("PCTS_DETHCG",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
aHelpEng :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
aHelpEsp :=	{	"Continuação da descrição para"			,	"imprimir nos relatorios DFC e DVA"	}
PutHelp("PCCTS_CONTCG",aHelpPor,aHelpEng,aHelpEsp,.T.)

If cPaisLoc == "COL" 

	// Colombia - CC2_CODMUN 	      
	aHelpPor := { "Informe o código do município."}   
	aHelpEsp := { "Informe el codigo del municipio."}
	aHelpEng := { "Enter the municipality code."}
	PutHelp("PCC2_CODMUN",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A1_NOMEPES 
	aHelpPor := { "Nome e/ou segundo nome para pessoa","física. Por exemplo, em 'José Carlos',","o segundo nome seria 	Carlos', então","este campo poderia conter tanto 'José","Carlos' como somente 'Carlos'."}
	aHelpEsp := { "Nombre y/o segundo nombre para","persona fisica. Por ejemplo, en 'José","Carlos', el segundo nombre seria 'Carlos',","entonces este campo podria tener tanto","	José Carlos	 como solamente 'Carlos'."}
	aHelpEng := { "Name and/or second name for natural","person. For example, in 'José Carlos',","the second name would be 'Carlos,' so this","field could contain either 'José Carlos' or","'Carlos' only."}
	PutHelp("PA1_NOMEPES",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A1_NOMEMAT 
	aHelpPor := { "Primeiro sobrenome para pessoa física. Em","alguns casos, este é o sobrenome materno."}
	aHelpEsp := { "Primer apellido para persona fisica. En","algunos casos, este es el apellido materno."}
	aHelpEng := { "First surname for natural person.","In some cases, it is the mother's surname."}
	PutHelp("PA1_NOMEMAT",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A1_NOMEPAT 
	aHelpPor := { "Segundo sobrenome para pessoa física. Em","alguns casos, este é o sobrenome paterno. "}
	aHelpEsp := { "Segundo apellido para persona fisica. En","algunos casos, este es el apellido paterno. "}
	aHelpEng := { "Second surname for natural person. In some","cases, it is the father's surname. "}
	PutHelp("PA1_NOMEPAT",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A1_TIPDOC
	aHelpPor := { "Informe o tipo de documento"}
	aHelpEsp := { "Informe el tipo de documento"}
	aHelpEng := { "Inform the document type."}
	PutHelp("PA1_TIPDOC",aHelpPor,aHelpEng,aHelpEsp,.T.) 

	// Colombia - A1_COD_MUN "
	aHelpPor := { "Informe o codigo do municipio."}
	aHelpEsp := { "Informe el codigo del municipio."}
	aHelpEng := { "Enter city code."}
	PutHelp("PA1_COD_MUN",aHelpPor,aHelpEng,aHelpEsp,.T.)

	// Colombia - A2_COD_MUN "
	aHelpPor := { "Código do Municipio."}
	aHelpEsp := { "Codigo del Municipio "}
	aHelpEng := { "District Code. "}
	PutHelp("PA2_COD_MUN",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A2_NOMEPES 
	aHelpPor := { "Nome e/ou segundo nome para pessoa","física. Por exemplo, em 'José Carlos',","o segundo nome seria 	Carlos', então","este campo poderia conter tanto 'José","Carlos' como somente 'Carlos'."}
	aHelpEsp := { "Nombre y/o segundo nombre para","persona fisica. Por ejemplo, en 'José","Carlos', el segundo nombre seria 'Carlos',","entonces este campo podria tener tanto","	José Carlos	 como solamente 'Carlos'."}
	aHelpEng := { "Name and/or second name for natural","person. For example, in 'José Carlos',","the second name would be 'Carlos,' so this","field could contain either 'José Carlos' or","'Carlos' only."}
	PutHelp("PA2_NOMEPES",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A2_NOMEMAT 
	aHelpPor := { "Primeiro sobrenome para pessoa física. Em","alguns casos, este é o sobrenome materno. "}
	aHelpEsp := { "Primer apellido para persona fisica. En","algunos casos, este es el apellido materno."}
	aHelpEng := { "First surname for natural person. In some","cases, it is the mother's surname."}
	PutHelp("PA2_NOMEMAT",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A2_NOMEPAT 
	aHelpPor := { "Segundo sobrenome para pessoa física. Em","alguns casos, este é o sobrenome paterno. "}
	aHelpEsp := { "Segundo apellido para persona fisica. En","algunos casos, este es el apellido paterno."}      
	aHelpEng := { "Second surname for natural person. In","some cases, it is the father's surname. "}
	PutHelp("PA2_NOMEPAT",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - A2_TIPDOC
	aHelpPor := { "Tipo de documento de identidade do","fornecedor."}
	aHelpEsp := { "Tipo de documento de identidad del","proveedor. "}
	aHelpEng := { "Type of identity document of supplier."}
	PutHelp("PA2_TIPDOC",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CV0_TIPO00 
	aHelpPor := { "Identifica se o terceiro é cliente,fornecedor,","etc."}
	aHelpEsp := { "Identifica si el tercero es cliente, proveedor,","etc."}
	aHelpEng := { "Identifies if the third is customer, supplier,","etc."}
	PutHelp("PCV0_TIPO00",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CV0_TIPO01 "}
	aHelpPor := { "Tipo de documento usado para identificar","o terceiro no cadastro de entidades. "}
	aHelpEsp := { "Tipo de documento usado para identificar","al tercero en el archivo de entidades."}
	aHelpEng := { "Type of document used to identify the third","in the entity file."}
	PutHelp("PCV0_TIPO01",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_PAIS 
	aHelpPor := { "Código do país."}
	aHelpEsp := { "Codigo del pais."}
	aHelpEng := { "Country code."}
	PutHelp("PCVC_PAIS",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_UF
	aHelpPor := { "Sigla da unidade da federação do endereço","do participante. "}
	aHelpEsp := { "Sigla del Estado/Provincia/Region de","la direccion del participante."}
	aHelpEng := { "Acronym of the participant's address state."}
	PutHelp("PCVC_UF",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_CODMUN 
	aHelpPor := { "Código onde a unidade federativa identifica","o município do participante."}
	aHelpEsp := { "Codigo donde la unidad federativa identifica","el municipio del participante."}
	aHelpEng := { "Code where federative unit identifies the","employee's municipality."}
	PutHelp("PCVC_CODMUN",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_1SNOME 
	aHelpPor := { "Primeiro sobrenome do participante."}
	aHelpEsp := { "Primer apellido del participante."}
	aHelpEng := { "Participant first name. "}
	PutHelp("PCVC_1SNOME",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_2SNOME 
	aHelpPor := { "Segundo sobrenome. Informar quando for","pessoa física. "}
	aHelpEsp := { "Segundo apellido. Informar cuando se trate","de persona fisica. "}
	aHelpEng := { "Second last name. Inform when individual","person."}
	PutHelp("PCVC_2SNOME",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_2NOME
	aHelpPor := { "Segundo do nome do participante."}
	aHelpEsp := { "Segundo nombre del participante."}
	aHelpEng := { "Participant name description."}
	PutHelp("PCVC_2NOME",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_TIPDOC 
	aHelpPor := { "Tipo de documento para identificar o"	,"participante."	}
	aHelpEsp := { "Tipo de documento para identificar "		,"el participante."	}
	aHelpEng := { "Type of document to identify the "		,"employee."		}
	PutHelp("PCVC_TIPDOC",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_END
	aHelpPor := { "Endereço do participante."}
	aHelpEsp := { "Direccion del Participante."}
	aHelpEng := { "Participant address."}
	PutHelp("PCVC_END",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_MUNIC
	aHelpPor := { "Nome do municipio. "}
	aHelpEsp := { "Nombre del municipio"}
	aHelpEng := { "City."}
	PutHelp("PCVC_MUNIC",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVC_PARTIC 
	aHelpPor := { "Porcentagem de participação, no casode","acionista/sócio"}
	aHelpEsp := { "Porcentaje de participacion, en el caso de","accionista/socio"}
	aHelpEng := { "Share percentage for stakeholder/partner."}
	PutHelp("PCVC_PARTIC",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVD_CODPLA 
	aHelpPor := { "Código do plano referencial"}
	aHelpEsp := { "Codigo del plan referencial "}
	aHelpEng := { "Referential plan code."}
	PutHelp("PCVD_CODPLA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVD_COLUNA 
	aHelpPor := { "Coluna (ordem) em que o movimento da","conta contábil aparecerá nos relatórios"}
	aHelpEsp := { "Columna (orden) en que el movimiento de","la conta contable aparecera en los informes "}
	aHelpEng := { "Column (order) which the ledger account","movement is displayed in reports."}
	PutHelp("PCVD_COLUNA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_CODPLA 
	aHelpPor := { "Código do plano referencial "}
	aHelpEsp := { "Codigo del plan referencial"}
	aHelpEng := { "Referential plan code."}
	PutHelp("PCVN_CODPLA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_DSCPLA 
	aHelpPor := { "Descrição do plano referencial"}
	aHelpEsp := { "Descripcion del plan referencial "}
	aHelpEng := { "Referential plan description."}
	PutHelp("PCVN_DSCPLA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_DTVIGI 
	aHelpPor := { "Data inicial da vigência"}
	aHelpEsp := { "Fecha inicial de la vigencia. "}
	aHelpEng := { "Validity initial date."}
	PutHelp("PCVN_DTVIGI",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_DTVIGF 
	aHelpPor := { "Data final da vigência"}
	aHelpEsp := { "Fecha final de la vigencia"}
	aHelpEng := { "Validity final date."}
	PutHelp("PCVN_DTVIGF",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_ENTREF 
	aHelpPor := { "Código da entidade "}
	aHelpEsp := { "Codigo de la entidad. "}
	aHelpEng := { "Entity code."}
	PutHelp("PCVN_ENTREF",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_LINHA
	aHelpPor := { "Linha/item do plano referencial "}
	aHelpEsp := { "Linea/item del plan referencial "}
	aHelpEng := { "Row/item of referential plan."}
	PutHelp("PCVN_LINHA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_CTAREF 
	aHelpPor := { "Código conta referencial"}
	aHelpEsp := { "Codigo cuenta referencial"}
	aHelpEng := { "Referential account code."}
	PutHelp("PCVN_CTAREF",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	
	// Colombia - CVN_DSCCTA 
	aHelpPor := { "Descrição conta referencial "}
	aHelpEsp := { "Descripcion cuenta referencial"}
	aHelpEng := { "Referential account description."}
	PutHelp("PCVN_DSCCTA",aHelpPor,aHelpEng,aHelpEsp,.T.) 
	 
EndIf
//------------------------------------------------------------------------------------------------

//TABELA CT1

aPHelpPor :={"Em caso de geração dos livros tipo R ou", "B, deve-se informar quais contas deverão" , "ser classificadas como sintética para o", "SPED."}
aPHelpEng :={"In case of generation type of books R or","B should be informed which accounts", "should be classified as synthetic for", "SPED."}
aPHelpEsp :={"En caso de generación de libros tipo R",  "o B deben informar cuales cuentas" ,  "deberán serclassificadas como sintético", "para SPED."}
PutHelp("PCT1_SPEDST",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCT1_ACAT01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCT1_AT01OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCT1_ACAT02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCT1_AT02OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCT1_ACAT03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCT1_AT03OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCT1_ACAT04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCT1_AT04OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

If cPaisLoc == "URU"
	aPHelpPor :={"Moeda forte considerada para o cálculo","de variação monetária."         }
	aPHelpEng :={"Hard currency considered to calculate" ,"the indexation."                }
	aPHelpEsp :={"Moneda fuerte considerada para el"     ,"calculo de variacion monetaria."}
	PutHelp("PCT1_MOEDVM",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
Endif 
//TABELA CTD

aPHelpPor :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEng :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEsp :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
PutHelp("PCTD_ACATIV",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEng :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEsp :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
PutHelp("PCTD_ATOBRG",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTD_ACAT01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTD_AT01OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTD_ACAT02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTD_AT02OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTD_ACAT03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTD_AT03OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTD_ACAT04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTD_AT04OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//TABELA CTH

aPHelpPor :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEng :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEsp :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
PutHelp("PCTH_ACATIV",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEng :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEsp :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
PutHelp("PCTH_ATOBRG",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTH_ACAT01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTH_AT01OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTH_ACAT02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTH_AT02OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTH_ACAT03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTH_AT03OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTH_ACAT04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTH_AT04OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//TABELA CTT

aPHelpPor :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEng :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
aPHelpEsp :={"Define se aceita as outras informaç"  ,"ões contábeis a débito ou a crédito."}
PutHelp("PCTT_ACATIV",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEng :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
aPHelpEsp :={"Define se as outras informações con"  ,"tábeis a débito ou a crédito serão obrigatórias."}
PutHelp("PCTT_ATOBRG",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTT_ACAT01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 01 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTT_AT01OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTT_ACAT02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 02 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTT_AT02OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTT_ACAT03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 03 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTT_AT03OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 aceitara"  ,"lançamentos. 1=Sim 2=Nao."}
PutHelp("PCTT_ACAT04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEng :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
aPHelpEsp :={"Informar se a Atividade 04 é obriga"  ,"toria. 1=Sim 2=Nao."}
PutHelp("PCTT_AT04OB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//CT2
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Debito"}
PutHelp("PCT2_AT01DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Credito"}
PutHelp("PCT2_AT01CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Debito"}
PutHelp("PCT2_AT02DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Credito"}
PutHelp("PCT2_AT02CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Debito"}
PutHelp("PCT2_AT03DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Credito"}
PutHelp("PCT2_AT03CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Debito"}
PutHelp("PCT2_AT04DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Credito"}
PutHelp("PCT2_AT04CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//CT5
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Debito"}
PutHelp("PCT5_AT01DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Credito"}
PutHelp("PCT5_AT01CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Debito"}
PutHelp("PCT5_AT02DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Credito"}
PutHelp("PCT5_AT02CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Debito"}
PutHelp("PCT5_AT03DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Credito"}
PutHelp("PCT5_AT03CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Debito"}
PutHelp("PCT5_AT04DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Credito"}
PutHelp("PCT5_AT04CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//CTK
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Debito"}
PutHelp("PCTK_AT01DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Credito"}
PutHelp("PCTK_AT01CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Debito"}
PutHelp("PCTK_AT02DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Credito"}
PutHelp("PCTK_AT02CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Debito"}
PutHelp("PCTK_AT03DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Credito"}
PutHelp("PCTK_AT03CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Debito"}
PutHelp("PCTK_AT04DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Credito"}
PutHelp("PCTK_AT04CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//CV3
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Debito"}
PutHelp("PCV3_AT01DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 1"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 1"  ," a Credito"}
PutHelp("PCV3_AT01CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Debito"}
PutHelp("PCV3_AT02DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 2"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 2"  ," a Credito"}
PutHelp("PCV3_AT02CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Debito"}
PutHelp("PCV3_AT03DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 3"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 3"  ," a Credito"}
PutHelp("PCV3_AT03CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Debito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Debito"}
PutHelp("PCV3_AT04DB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
aPHelpPor :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEng :={"Informar a Atividade Complementar 4"  ," a Credito"}
aPHelpEsp :={"Informar a Atividade Complementar 4"  ," a Credito"}
PutHelp("PCV3_AT04CR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCT1_TPO01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCT1_TPO02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCT1_TPO03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCT1_TPO04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTT_TPO01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTT_TPO02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTT_TPO03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTT_TPO04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTD_TPO01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTD_TPO02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTD_TPO03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTD_TPO04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTH_TPO01",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTH_TPO02",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTH_TPO03",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :={"Campo padrão para utilizacao do cliente"," para classificacao das entidades ","contabeis dentro das necessidades"," especificas da empresa, ","viabilizando a utilizacao ","desta informacao em ","relatórios de cadastro."}
aPHelpEng :={"Field standard for customer use for the"," classification of entities within"," the accounting company's specific"," needs, enabling the use of"," this information on ","reports of record."}
aPHelpEsp :={"Campo estándar para uso del cliente para"," la clasificación de las entidades"," dentro de las necesidades ","específicas de la empresa"," de contabilidad, permitiendo"," la utilización de esta"," información en los ","informes de registro."}
PutHelp("PCTH_TPO04",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//------------------------------------------------------------------------------------------------
cTexto := "Atualizados os helps de campos das tabelas: "+cAlias+CRLF//"Atualizados os helps de campos das tabelas: "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Help de rotinas        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//INICIO ROTINA CTBA276

//				"1234567890123456789012345678901234567890"
aHelpPor :=	{	"Grupo inicial para processamento da ",;
"atualizacao de fatores pela formula."}

aHelpEsp :=	{	"Grupo inicial para processamento da ",;
"atualizacao de fatores pela formula."}

aHelpEng :=	{	"Grupo inicial para processamento da ",;
"atualizacao de fatores pela formula."}

PutSX1Help("P.CTB27601.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Grupo final para processamento da ",;
"atualizacao de fatores pela formula."}

aHelpEsp :=	{	"Grupo final para processamento da ",;
"atualizacao de fatores pela formula."}

aHelpEng :=	{	"Grupo final para processamento da ",;
"atualizacao de fatores pela formula."}

PutSX1Help("P.CTB27602.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos grupos através"	,;
"do cadastro de amarrações."}

aHelpEsp :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos grupos através"	,;
"do cadastro de amarrações."}

aHelpEng :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos grupos através"	,;
"do cadastro de amarrações."}

PutSX1Help("P.CTB27603.",aHelpPor,aHelpEng,aHelpEsp)

//TERMINO ROTINA CTBA276


//INICIO ROTINA CTBA277

//				"1234567890123456789012345678901234567890"
aHelpPor :=	{	"Amarracao inicial para processamento da ",;
"atualizacao dos rateios off-lines."}

aHelpEsp :=	{	"Amarracao inicial para processamento da ",;
"atualizacao dos rateios off-lines."}

aHelpEng :=	{	"Amarracao inicial para processamento da ",;
"atualizacao dos rateios off-lines."}

PutSX1Help("P.CTB27701.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Amarracao final para processamento da ",;
"atualizacao dos rateios off-lines."}

aHelpEsp :=	{	"Amarracao final para processamento da ",;
"atualizacao dos rateios off-lines."}

aHelpEng :=	{	"Amarracao final para processamento da ",;
"atualizacao dos rateios off-lines."}

PutSX1Help("P.CTB27702.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Status das amarrações que srão ",;
"considerados para o processamento",;
"da atualizacao dos rateios off-lines."}

aHelpEsp :=	{	"Status das amarrações que srão ",;
"considerados para o processamento",;
"da atualizacao dos rateios off-lines."}

aHelpEng :=	{	"Status das amarrações que srão ",;
"considerados para o processamento",;
"da atualizacao dos rateios off-lines."}

PutSX1Help("P.CTB27703.",aHelpPor,aHelpEng,aHelpEsp)

//TERMINO ROTINA CTBA277

//INICIO ROTINA CTBA278

aHelpPor :=	{	"Indice inicial para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

aHelpEsp :=	{	"Indice inicial para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

aHelpEng :=	{	"Indice inicial para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

PutSX1Help("P.CTB27801.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Indice final para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

aHelpEsp :=	{	"Indice final para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

aHelpEng :=	{	"Indice final para processamento da  ",;
"atualizacao dos fatores pelas fórmulas."}

PutSX1Help("P.CTB27802.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos indices através"	,;
"dos cadastros de grupos e amarrações."}

aHelpEsp :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos indices através"	,;
"dos cadastros de grupos e amarrações."}

aHelpEng :=	{	"Indica se o processamento da atualizacao"	,;
"dos fatores pela formula irá atualizar"	,;
"os rateios vinculados aos indices através"	,;
"dos cadastros de grupos e amarrações."}

PutSX1Help("P.CTB27803.",aHelpPor,aHelpEng,aHelpEsp)

//TERMINO ROTINA CTBA278


//INICIO ROTINA CTBA231

//				"1234567890123456789012345678901234567890"  "1234567890123456789012345678901234567890"
aHelpPor :=	{	"Informe se deseja ou não que todos os"   , "dados da empresa destino sejam apagados."}
aHelpEsp := {	"Informe si desea que todos los datos de" , "la empresa destino sean borrados o no."}
aHelpEng := {	"Confirm whether or not you want to erase", "all data from the destination company."}
PutSX1Help("P.CTB23101.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe a data inicial a partir da qual" , "deseja que seja efetuada a consolidação."}
aHelpEsp := {	"Informe la fecha inicial que desea"      , "hacer la consolidacion."}
aHelpEng := {	"Enter the initial date you want"         , "to do the consolidation."}
PutSX1Help("P.CTB23102.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe a data final até a qual deseja"  , "que seja efetuada a consolidação."}
aHelpEsp := {	"Informe la fecha final que desea"        , "hacer la consolidacion."}
aHelpEng := {	"Enter the final date you want"           , "to do the consolidation."}
PutSX1Help("P.CTB23103.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja apagar tudo ou somente", "o período indicado pelas datas",;
"anteriores na empresa destino."}
aHelpEsp := {	"Informe si desea borrar todo o solo el"  , "periodo indicado por las fechas",;
"anteriores en la empresa destino."}
aHelpEng := {	"Confirm if you want to erase all the"    , "periods or just the one indicated by the",;
"previous dates in destination company."}
PutSX1Help("P.CTB23104.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja processar todas"       , "as moedas ou uma moeda especifica."}
aHelpEsp := {	"Informe si desea procesar todas"         , "las monedas o una moneda especifica"}
aHelpEng := {	"Enter if you want to process all"        , "currencies or a specific currency."}
PutSX1Help("P.CTB23105.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Caso tenha escolhido processar uma moeda", "especifica, informe o código da moeda a",;
"processar. Utilize <F3> para escolher."  , ""}
aHelpEsp := {	"Si opto por procesar una moneda"         , "especifica, informe el codigo de la",;
"moneda que sera procesada."              , "Utilice la tecla <F3> para seleccionar."}
aHelpEng := {	"If you have chosen to process a specific", "currency, enter the code of the currency",;
"to process. Use the <F3> key to choose." , ""}
PutSX1Help("P.CTB23106.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	'Escolha o tipo de saldo a ser consoli-'  , 'dado. Se desejar todos os tipos de saldo',;
'preencha este campo com "*". Utilize'    , '<F3> para escolher um saldo especifico.',;
''}
aHelpEsp := {	'Seleccione el tipo de saldo que se'      , 'consolidara. Si desea todos los tipos de',;
'saldo, complete este campo con "*".'     , 'Utilice <F3> para seleccionar un saldo',;
'especifico.'}
aHelpEng := {	'Choose the balance type to be'           , 'consolidated. If you want all balance',;
'types, fill in this field with "*".'     , 'Press <F3> to choose a specific balance.',;
''}
PutSX1Help("P.CTB23107.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja gerar os"              , "lançamentos de saldo inicial."}
aHelpEsp := {	"Informe si desea generar el"             , "asientos de saldo inicial."}
aHelpEng := {	"Enter whether to generate the"           , "initial balances entries."}
PutSX1Help("P.CTB23108.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o numero do lote dos"            , "lancamentos de saldo inicial."}
aHelpEsp := {	"Indique el numero de lote de"            , "asientos de saldo inicial."}
aHelpEng := {	"Enter the number the lot of"             , "the initial balance entries."}
PutSX1Help("P.CTB23109.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o numero do sublote dos"         , "lancamentos de saldo inicial."}
aHelpEsp := {	"Indique el numero de sublote de"         , "los asientos de saldo inicial."}
aHelpEng := {	"Enter the number the sublot of"          , "the initial balance entries."}
PutSX1Help("P.CTB23110.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o numero do documento dos"       , "lancamentos de saldo inicial."}
aHelpEsp := {	"Indique el numero de documento de"       , "los asientos de saldo inicial."}
aHelpEng := {	"Enter the number the document of"        , "the initial balance entries."}
PutSX1Help("P.CTB23111.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o roteiro inicial a partir do"   , "qual deseja que seja efetuada a",;
"consolidação. Utilize <F3> para escolher"}
aHelpEsp := {	"Informe el procedimiento inicial que"    , "desea hacer la consolidacion.",;
"Utilice la tecla <F3> para seleccionar."}
aHelpEng := {	"Enter the initial roadmap code that you" , "want use to do the consolidation.",;
"Use the <F3> key to choose."}
PutSX1Help("P.CTB23112.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o roteiro final a partir do"     , "qual deseja que seja efetuada a",;
"consolidação. Utilize <F3> para escolher"}
aHelpEsp := {	"Informe el procedimiento final que desea", "hacer la consolidacion.",;
"Utilice la tecla <F3> para seleccionar."}
aHelpEng := {	"Enter the final roadmap code that you"   , "want use to do the consolidation.",;
"Use the <F3> key to choose."}
PutSX1Help("P.CTB23113.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja aglutinar"             , "os lancamentos contabeis"}
aHelpEsp := {	"Informe si desea agrupar"                , "los asientos contables"}
aHelpEng := {	"Confirm if you want to group"            , "the accounting entries."}
PutSX1Help("P.CTB23114.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	'Informe neste campo o historico do'      , 'lancamento contabil aglutinado (Ex.:',;
'"Lancamento Gerado pela Funcao CTBA231"' , 'ou CTB->CTB_CTADES). No caso de fixar um',;
'valor padrao este devera estar contido'  , 'entre aspas; se referenciar a algum',;
'campo de tabela do sistema devera'       , 'ser precedido do ALIAS->'}
aHelpEsp := {	'Informe en este campo el historico del'  , 'asiento contable agrupado (Ejemplo',;
'"Asiento Generado por la Func. CTBA231"' , 'o CTB->CTB_CTADES). En el caso de fijar',;
'un valor estándar, este debera estar'    , 'contenido entre parentesis; si hacer',;
'referencia a algun campo de la tabla del', 'sistema, debe ser precedido del ALIAS->'}
aHelpEng := {	'In this field, enter the history of the' , 'grouped accounting entry (E.g.:',;
'"Entry Generated by Function CTBA231()"' , 'or CTB->CTB_CTADES). If you are fixing a',;
'standard value, it must be quoted;'      , 'if referring to any system table field,',;
'it must be preceded by ALIAS->'          , ''}
PutSX1Help("P.CTB23115.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se ao final do processo"         , "a rotina deve efetuar o",;
"reprocessamento de saldos"}
aHelpEsp := {	"Informe si al final del proceso"         , "la rutina debe efectuar el",;
"reprocesamiento de saldos" }
aHelpEng := {	"Confirm if you want to run the"          , "balance reprocessing routine",;
"at the end of this process"}
PutSX1Help("P.CTB23116.",aHelpPor,aHelpEng,aHelpEsp)

//TERMINO ROTINA CTBA231


//INICIO HELP NOME VISAO GERENCIAL COMO TITULO

//				"1234567890123456789012345678901234567890"  "1234567890123456789012345678901234567890"
aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR50013.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR51016.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR51108.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR51908.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR52011.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR53008.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR54012.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR56022.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR57021.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR70017.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o periodo inicial a partir da qual" , "deseja que seja impreso o relatório."}
aHelpEsp := {	"Informe o periodo inicial que desea"        , "imprimir el informe."}
aHelpEng := {	"Enter the initial period you want"          , "to do printer report."}
PutSX1Help("P.CTR52101.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o periodo final a partir da qual" , "deseja que seja impreso o relatório."}
aHelpEsp := {	"Informe o periodo final que desea"        , "imprimir el informe."}
aHelpEng := {	"Enter the final period you want"          , "to do printer report."}
PutSX1Help("P.CTR52102.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor := {	"Determine a configuracao do livro que"    , "se utilizara neste informe. E",;
"obrigatorio utilizar um livro associado"  , "uma visao gerencial para imprimir este",;
"relatorio. Use <F3> para selecionar."	}
aHelpEsp := {	"Determine la configuracion de libro que"  , "se utilizara en este informe. Es",;
"obligatorio utilizar un libro asociado a" , "una vision de gestion para imprimir este",;
"informe. Utilice <F3> para elegir."	}
aHelpEng := {	"Determine a configuracao do livro que"    , "se utilizara neste informe. E",;
"obrigatorio utilizar um livro associado"  , "uma visao gerencial para imprimir este",;
"relatorio. Use <F3> para selecionar."	}
PutSX1Help("P.CTR52103.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor := {	"Digite o codigo da moeda que"				,"deseja imprimir o relatorio.",;
"Use <F3> para selecionar"	}
aHelpEsp := {	"Digite el codigo de la moneda en la cual"	,"desea imprimir el informe.",;
"Pulse la tecla <F3> para elegir."	}
aHelpEng := {	"Digite o codigo da moeda que"				,"deseja imprimir o relatorio.",;
"Use <F3> para selecionar"	}
PutSX1Help("P.CTR52104.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Digite o tipo de saldo que"    , "deseja imprimir o relatorio." }
aHelpEsp := {	"Digite el tipo de saldo que se", "desea imprimir el informe." }
aHelpEsp := {	"Digite el tipo de saldo que se", "desea imprimir el informe." }
PutSX1Help("P.CTR52105.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja utilizar no titulo"    , "do relatorio o nome da visao."}
aHelpEsp := {	"Informe si desea utilizar en el titulo"  , "del informe el nombre de la vision."}
aHelpEng := {	"Confirm if you want to use the vision"   , "name as the report title."}
PutSX1Help("P.CTR52106.",aHelpPor,aHelpEng,aHelpEsp)
//FIM HELP NOME VISAO GERENCIAL COMO TITULO

//INICIO ROTINA CTBA381
aHelpPor :=	{	"Informe a data de referência para o"   ,"cálculo da Variação Monetária."         ,"A variação será calculada até esta data" ,"informada."       }
aHelpEsp := {	"Digite la fecha de referencia para el" ,"calculo de la Variación Monetaria."     ,"La variación sera calculada hasta esta"  ,"fecha informada." }
aHelpEng := {	"Enter the reference date for the"      ,"calculation of the monetary variation." ,"The variation will be calculated until"  ,"the entered date."}
PutSX1Help("P.CT381A01.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o número do Lote a partir do"   ,"qual serão gravados os registros gerados" ,"por esta rotina."          }
aHelpEsp := {	"Digite el numero del lote a partir del" ,"cual seran grabados los registros"        ,"generados por esta rutina."}
aHelpEng := {	"Enter the lot number from which the"    ,"files generated for this routine will be" ," written."                 }
PutSX1Help("P.CT381A02.",aHelpPor,aHelpEng,aHelpEsp)
           
aHelpPor :=	{	"Informe o número do Sub-Lote a ser"       ,"gravado no lançamento contábil."  ,"Utilize <F3> para escolher."     }
aHelpEsp := {	"Digite el numero del sublote que se debe" ,"grabar en el asiento contable."   ,"Pulse la tecla <F3> para elegir."}
aHelpEng := {	"Enter the number of the sub-lot to be"    ,"written in the accounting entry." ,"Press <F3> to select it."        }
PutSX1Help("P.CT381A03.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o número do documento a partir"   ,"do qual serão gerados os lançamentos"  ,"contábeis."}
aHelpEsp := {	"Digite el numero del documento a partir"  ,"del cual seran generados los asientos" ,"contables."}
aHelpEng := {	"Enter the document number from which the" ,"accounting entries will be genereted."              }
PutSX1Help("P.CT381A04.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o código do histórico padrão"    ,"que será utilizado para gerar os"    ,"lançamentos contábeis."}
aHelpEsp := {	"Digite el codigo del historial estandar" ,"que sera utilizado para generar los" ,"asientos contables."   }
aHelpEng := {	"Enter the code of the standard history"  ,"that will be used to generate the"   ,"accounting entries."   }
PutSX1Help("P.CT381A05.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe a Conta inicial a partir da qual" ,"se deseja calcular a Variação Monetária." ,"Caso queira utilizar todas as contas,"  ,"deixe  esse campo em branco."        ,"Utilize <F3> para escolher."     }
aHelpEsp := {	"Digite la Cuenta inicial a partir de la"  ,"cual se desea calcular la Variacion"      ,"Monetaria. Si desea utilizar todas las" ,"cuentas, deje este campo en blanco." ,"Pulse la tecla <F3> para elegir."}
aHelpEng := {	"Enter the initial account from which you" ,"want to calculate the monetary"           ,"variation. If you want to use all the"  ,"accounts, let this field empty."                                        }
PutSX1Help("P.CT381A06.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe a Conta final até a qual se"     ,"desejá calcular a variação monetária." ,"Caso queira utilizar todas as Contas" ,"preencha este campo com"                                         ,"'ZZZZZZZZZZZZZZZZZZZZ'." ,"Utilize <F3> para escolher."       }
aHelpEsp := {	"Digite la Cuenta final hasta la cual"    ,"se desea calcular la variación"        ,"monetaria. Si desea utilizar todas"   , "las cuentas, llene este campo con"                              ,"'ZZZZZZZZZZZZZZZZZZZZ'." ,  "Pulse la tecla <F3> para elegir."}
aHelpEng := {	"Enter the final account until which you" ,"want to calculate the monetary"        ,"variation."                           ," If you want to use all the","accounts, fill in this field with" ,"'ZZZZZZZZZZZZZZZZZZZZZ'."                                     }
PutSX1Help("P.CT381A07.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe o codigo da moeda a  ser"         ,"considerada como base para o calculo da" ,"variacao."       }
aHelpEsp := {	"Informe el codigo de la moneda que se"    ,"considerarara como base para el calculo" ,"de la variacion."}
aHelpEng := {	"Enter the currency code to be considered" ,"as the basis for the variation"          ," calculation."   }
PutSX1Help("P.CT381A08.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe qual o tipo de saldo que deverá" ,"ser utilizado para o cálculo da Variação" ,"Monetária."           ,"Utilize <F3> para escolher."     }
aHelpEsp := {	"Informe cual es el tipo de saldo que se" ,"debe utilizar para el calculo de la"      ,"Variación Monetaria." ,"Pulse la tecla <F3> para elegir."}
aHelpEng := {	"Enter the type of balance that must be"  , "used to calculate the monetary"          ,"variation."                                              }
PutSX1Help("P.CT381A09.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Indique se os lançamentos poderão ser"," de:" ,"- Partida dobrada -> Desmembra = Não" ,"- Débito / Crédito -> Desmembra = Sim" ,"(neste caso são gerados dois lançamentos" ,"contábeis)"}
aHelpEsp := {	"Indique si los asientos podran ser de:"       ,"- Partida doble -> Desmiembra = No"   ,"- Debito / Credito -> Desmiembra = Si" ,"(en este caso son generados dos asientos" ,"contables)"}
aHelpEng := {	"Confirm if the entries can be:"               ,"- Double entry -> Separate = No"      ,"- Debit / Credit -> Separate = Yes"    ,"(two accounting entries are generated)"                }
PutSX1Help("P.CT381A10.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se deseja considerar o criterio" ,"de conversao da moeda ou do plano de"   ,"contas."     }
aHelpEsp := {	"Informe si desea considerar el criterio" ,"conversion de la moneda o el plan de"   ,"cuentas."    }
aHelpEng := {	"Inform if you want to consider the"      ,"currency conversion criterion or chart" ,"of accounts."}
PutSX1Help("P.CT381A11.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	'Informe o valor da Taxa a ser'         ,'considerada na conversão de valores.'        ,'Obs: Esta pergunta só será considerada,' ,'caso a resposta à pergunta "Considera'    ,'Critério", tenha sido "Informada".'             }
aHelpEsp := {	'Informe el valor de la tasa a'         ,'considerarse en la conversion de','valores.' ,'Obs. Solo se considerara esta pregunta'  ,'si la respuesta a la pregunta "Considera' ,'Criterio" se ha informado.'                     }
aHelpEng := {	'Inform the Tax Value to be considered' ,'while converting values.'                    ,'Obs: This question will only be'         ,'considered, if the answer to the'         ,'question "Consider Criterion", is','"Informed".'}
PutSX1Help("P.CT381A12.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se considera o c.custo: SIM ou"   ,"NÃO." }
aHelpEsp := {	"Informe si considera el c.costo: SI o"    ,"NO."  }
aHelpEng := {	"Enter if c. center is considered: YES or" ," NO." }
PutSX1Help("P.CT381A13.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se considera o item contail: SIM" ,"ou NÃO."   }
aHelpEsp := {	"Informe si considera el item cont: SI o"  ,"NO."       }
aHelpEng := {	"Enter if accounting item is considered:"  ,"YES or NO."}
PutSX1Help("P.CT381A14.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	"Informe se considera a classe de valor:" ,"SIM ou NÃO."     }
aHelpEsp := {	"Informe si se considera la clase de"     ,"valor: SI o NO." }
aHelpEng := {	"Enter whether to consider class value:"  ,"YES or NO."      }
PutSX1Help("P.CT381A15.",aHelpPor,aHelpEng,aHelpEsp)

aHelpPor :=	{	'Informe se o metodo de variacao'        ,'monetaria a ser usado sera "Moeda Base"'  ,'ou "Moeda forte".' }
aHelpEsp := {	'Informe si el metodo de variacion'      ,'monetaria a ser usado sera "Moneda Base"' ,'o "Moneda Fuerte".'}
aHelpEng := {	'Enter the method of monetary variation' ,'to be used will be "Base Currency" or'    ,'"Strong Currency".'}
PutSX1Help("P.CT381A16.",aHelpPor,aHelpEng,aHelpEsp)
//FIM TERMINO CTBA381

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Help.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aPHelpPor := {"Tabela do arquivo que originou o",;
"lançamento contabil"}
aPHelpEng := {"Tabela do arquivo que originou o",;
"lançamento contabil"}
aPHelpEsp := {"Tabela do arquivo que originou o",;
"lançamento contabil"}
PutHelp("PCTK_TABORI",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Informe o registro da tabela de origem"}
aPHelpEng := {"Informe o registro da tabela de origem"}
aPHelpEsp := {"Informe o registro da tabela de origem"}
PutHelp("PCTK_RECORI",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Regitro de destino que gerou o lançamento"}
aPHelpEng := {"Regitro de destino que gerou o lançamento"}
aPHelpEsp := {"Regitro de destino que gerou o lançamento"}
PutHelp("PCTK_RECDES",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Informe o Registro na tabela de relacionamento"}
aPHelpEng := {"Informe o Registro na tabela de relacionamento"}
aPHelpEsp := {"Informe o Registro na tabela de relacionamento"}
PutHelp("PCTK_RECCV3",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Tabela original que gerou o registro"}
aPHelpEng := {"Tabela original que gerou o registro"}
aPHelpEsp := {"Tabela original que gerou o registro"}
PutHelp("PCV3_TABORI",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Informação do registro na tabela original"}
aPHelpEng := {"Informação do registro na tabela original"}
aPHelpEsp := {"Informação do registro na tabela original"}
PutHelp("PCV3_RECORI",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Registro que foi gerado no destino"}
aPHelpEng := {"Registro que foi gerado no destino"}
aPHelpEsp := {"Registro que foi gerado no destino"}
PutHelp("PCV3_RECDES",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim dasTabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aPHelpPor := {"Código  que  individualiza  cada  um dos",;
"contabilistas."}
aPHelpEng := {"Código  que  individualiza  cada  um dos",;
"contabilistas."}
aPHelpEsp := {"Código  que  individualiza  cada  um dos",;
"contabilistas."}
PutHelp("PCVB_CODCTB",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Nome do Contabilista/Escritório de",;
"Contabilidade responsável pela",;
"escrituração."}
aPHelpEng := {"Nome do Contabilista/Escritório de",;
"Contabilidade responsável pela",;
"escrituração."}
aPHelpEsp := {"Nome do Contabilista/Escritório de",;
"Contabilidade responsável pela",;
"escrituração."}
PutHelp("PCVB_NOME",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Número da inscrição no cadastro geral de ",;
"contribuintes do  ministerio da  fazenda ",;
"para pessoas jurídicas do escritório de ",;
"contabilidade."}
aPHelpEng := {"Número da inscrição no cadastro geral de ",;
"contribuintes do  ministerio da  fazenda ",;
"para pessoas jurídicas do escritório de ",;
"contabilidade."}
aPHelpEsp := {"Número da inscrição no cadastro geral de ",;
"contribuintes do  ministerio da  fazenda ",;
"para pessoas jurídicas do escritório de ",;
"contabilidade."}
PutHelp("PCVB_CGC",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)


aPHelpPor := {"Número da inscrição no cadastro de ",;
"pessoa fisica  do  ministerio da ",;
"fazenda do contador."}
aPHelpEng := {"Número da inscrição no cadastro de ",;
"pessoa fisica  do  ministerio da ",;
"fazenda do contador."}
aPHelpEsp := {"Número da inscrição no cadastro de ",;
"pessoa fisica  do  ministerio da ",;
"fazenda do contador."}
PutHelp("PCVB_CPF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Número da inscrição do contabilista no ",;
"Conselho Regional de Contabilidade. "}
aPHelpEng := {"Número da inscrição do contabilista no ",;
"Conselho Regional de Contabilidade. "}
aPHelpEsp := {"Número da inscrição do contabilista no ",;
"Conselho Regional de Contabilidade. "}
PutHelp("PCVB_CRC",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Codigo de qualificacao do assinante,",;
"conforme tabela do Departamento Nacional",;
"de Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
aPHelpEng := {"Codigo de qualificacao do assinante,",;
"conforme tabela do Departamento Nacional",;
"de Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
aPHelpEps := {"Codigo de qualificacao do assinante,",;
"conforme tabela do Departamento Nacional",;
"de Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
PutHelp("PCVB_ASSIN",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Qualificacao do assinante, conforme",;
"tabela do Departamento Nacional de",;
"Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
aPHelpEng := {"Qualificacao do assinante, conforme",;
"tabela do Departamento Nacional de",;
"Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
aPHelpEsp := {"Qualificacao do assinante, conforme",;
"tabela do Departamento Nacional de",;
"Registro do Comercio - DNRC.",;
"Consulte www.dnrc.gov.br"}
PutHelp("PCVB_QUALIF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Código do endereçamento postal do ",;
"contabilista."}
aPHelpEng := {"Código do endereçamento postal do ",;
"contabilista."}
aPHelpEsp := {"Código do endereçamento postal do ",;
"contabilista."}
PutHelp("PCVB_CEP",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Endereço do contabilista."}
aPHelpEng := {"Endereço do contabilista."}
aPHelpEsp := {"Endereço do contabilista."}
PutHelp("PCVB_END",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Bairro do contabilista."}
aPHelpEng := {"Bairro do contabilista."}
aPHelpEsp := {"Bairro do contabilista."}
PutHelp("PCVB_BAIRRO",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Sigla da unidade da federação do endere-",;
"ço do Contabilista."}
aPHelpEng := {"Sigla da unidade da federação do endere-",;
"ço do Contabilista."}
aPHelpEsp := {"Sigla da unidade da federação do endere-",;
"ço do Contabilista."}
PutHelp("PCVB_UF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Número do telefone do contabilista."}
aPHelpEng := {"Número do telefone do contabilista."}
aPHelpEsp := {"Número do telefone do contabilista."}
PutHelp("PCVB_TEL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Número do Fax do contabilista."}
aPHelpEng := {"Número do Fax do contabilista."}
aPHelpEsp := {"Número do Fax do contabilista."}
PutHelp("PCVB_FAX",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"E-mail do contabilista."}
aPHelpEng := {"E-mail do contabilista."}
aPHelpEsp := {"E-mail do contabilista."}
PutHelp("PCVB_EMAIL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

If cPaisLoc <> "COL"
	aPHelpPor := {"Código  que  individualiza cada um dos",;
	"participantes."}
	aPHelpEng := {"Código  que  individualiza cada um dos",;
	"participantes."}
	aPHelpEsp := {"Código  que  individualiza cada um dos",;
	"participantes."}
	PutHelp("PCVC_CODPAR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Código de identificação do relacionamen-",;
	"to com o participante conforme tabela",;
	"abaixo:",;
	"01 - Matriz.",;
	"02 - Filial, inclusive agências, depen-",;
	"dências e filiais no exterior.",;
	"03 - Coligada, inclusive equiparada.",;
	"04 - Controladora.",;
	"05 - Controlada (exceto subsidiária",;
	"integral).",;
	"06 - Subsidiária integral.",;
	"07 - Controlada em conjunto.",;
	"08 - Entidade de Propósito Específico ",;
	"(conforme definição da CVM).",;
	"09 - Participante do conglomerado, con-",;
	"forme norma específica do órgão regu-",;
	"lador, exceto as que se enquadrem nos",;
	"tipos precedentes.",;
	"10 - Vinculadas (Art. 23 da Lei ",;
	"9.430/96), exceto as que se enquadrem",;
	" nos tipos precedentes.",;
	"11 - Localizada em país com tributação ",;
	"favorecida (Art. da Lei 9.430/96)."}
	aPHelpEng := {"Código de identificação do relacionamen-",;
	"to com o participante conforme tabela",;
	"abaixo:",;
	"00 - Matriz.",;
	"01 - Filial, inclusive agências, depen-",;
	"dências e filiais no exterior.",;
	"02 - Coligada, inclusive equiparada.",;
	"03 - Controladora.",;
	"04 - Controlada (exceto subsidiária",;
	"integral).",;
	"05 - Subsidiária integral.",;
	"06 - Controlada em conjunto.",;
	"07 - Entidade de Propósito Específico ",;
	"(conforme definição da CVM).",;
	"08 - Participante do conglomerado, con-",;
	"forme norma específica do órgão regu-",;
	"lador, exceto as que se enquadrem nos",;
	"tipos precedentes.",;
	"09 - Vinculadas (Art. 23 da Lei ",;
	"9.430/96), exceto as que se enquadrem",;
	" nos tipos precedentes.",;
	"10 - Localizada em país com tributação ",;
	"favorecida (Art. da Lei 9.430/96)."}
	aPHelpEsp := {"Código de identificação do relacionamen-",;
	"to com o participante conforme tabela",;
	"abaixo:",;
	"00 - Matriz.",;
	"01 - Filial, inclusive agências, depen-",;
	"dências e filiais no exterior.",;
	"02 - Coligada, inclusive equiparada.",;
	"03 - Controladora.",;
	"04 - Controlada (exceto subsidiária",;
	"integral).",;
	"05 - Subsidiária integral.",;
	"06 - Controlada em conjunto.",;
	"07 - Entidade de Propósito Específico ",;
	"(conforme definição da CVM).",;
	"08 - Participante do conglomerado, con-",;
	"forme norma específica do órgão regu-",;
	"lador, exceto as que se enquadrem nos",;
	"tipos precedentes.",;
	"09 - Vinculadas (Art. 23 da Lei ",;
	"9.430/96), exceto as que se enquadrem",;
	" nos tipos precedentes.",;
	"10 - Localizada em país com tributação ",;
	"favorecida (Art. da Lei 9.430/96)."}
	PutHelp("PCVC_CODREL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Nome pessoal ou empresarial do partici-",;
	"pante."}
	aPHelpEng := {"Nome pessoal ou empresarial do partici-",;
	"pante."}
	aPHelpEsp := {"Nome pessoal ou empresarial do partici-",;
	"pante."}
	PutHelp("PCVC_NOME",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	
	aPHelpPor := {"Brasil :Deverá ser informado J se o Par-",;
	"ticipante for pessoa Juridica ou F para ",;
	"pessoa  Fisica.",;
	"Outros paises : Verificar as opções ",;
	"disponíveis."}
	aPHelpEng := {"Brasil :Deverá ser informado J se o Par-",;
	"ticipante for pessoa Juridica ou F para ",;
	"pessoa  Fisica.",;
	"Outros paises : Verificar as opções ",;
	"disponíveis."}
	aPHelpEsp := {"Brasil :Deverá ser informado J se o Par-",;
	"ticipante for pessoa Juridica ou F para ",;
	"pessoa  Fisica.",;
	"Outros paises : Verificar as opções ",;
	"disponíveis."}
	PutHelp("PCVC_TIPO",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	
	aPHelpPor := {"Número da inscrição no cadastro geral de ",;
	"contribuintes do  ministerio da  fazenda ",;
	"para  pessoas jurídicas ou CPF para pes-",;
	"soas físicas."}
	aPHelpEng := {"Número da inscrição no cadastro geral de ",;
	"contribuintes do  ministerio da  fazenda ",;
	"para  pessoas jurídicas ou CPF para pes-",;
	"soas físicas."}
	aPHelpEsp := {"Número da inscrição no cadastro geral de ",;
	"contribuintes do  ministerio da  fazenda ",;
	"para  pessoas jurídicas ou CPF para pes-",;
	"soas físicas."}
	PutHelp("PCVC_CGC",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Preencher conforme tabela de código de ",;
	"países disponibilizado no site da Polí-",;
	"cia Federal."}
	aPHelpEng := {"Preencher conforme tabela de código de ",;
	"países disponibilizado no site da Polí-",;
	"cia Federal."}
	aPHelpEsp := {"Preencher conforme tabela de código de ",;
	"países disponibilizado no site da Polí-",;
	"cia Federal."}
	PutHelp("PCVC_PAIS",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Código da matrícula do funcionário."}
	aPHelpEng := {"Código da matrícula do funcionário."}
	aPHelpEsp := {"Código da matrícula do funcionário."}
	PutHelp("PCVC_NUMRA",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Sigla da unidade da federação do endere-",;
	"ço do participante."}
	aPHelpEng := {"Sigla da unidade da federação do endere-",;
	"ço do participante."}
	aPHelpEsp := {"Sigla da unidade da federação do endere-",;
	"ço do participante."}
	PutHelp("PCVC_UF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Número da Inscrição Estadual do partici-",;
	"pante."}
	aPHelpEng := {"Número da Inscrição Estadual do partici-",;
	"pante."}
	aPHelpEsp := {"Número da Inscrição Estadual do partici-",;
	"pante."}
	PutHelp("PCVC_IE",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Inscrição Estadual do participante na ",;
	"unidade da federação do destinatário, ",;
	"na condição de contribuinte substituto."}
	aPHelpEng := {"Inscrição Estadual do participante na ",;
	"unidade da federação do destinatário, ",;
	"na condição de contribuinte substituto."}
	aPHelpEsp := {"Inscrição Estadual do participante na ",;
	"unidade da federação do destinatário, ",;
	"na condição de contribuinte substituto."}
	PutHelp("PCVC_IE_ST",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Código onde a unidade federativa identi-",;
	"fica o município do participante."}
	aPHelpEng := {"Código onde a unidade federativa identi-",;
	"fica o município do participante."}
	aPHelpEsp := {"Código onde a unidade federativa identi-",;
	"fica o município do participante."}
	PutHelp("PCVC_CODMUN",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Inscrição Municipal do participante."}
	aPHelpEng := {"Inscrição Municipal do participante."}
	aPHelpEsp := {"Inscrição Municipal do participante."}
	PutHelp("PCVC_IM",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Código do participante na Suframa."}
	aPHelpEng := {"Código do participante na Suframa."}
	aPHelpEsp := {"Código do participante na Suframa."}
	PutHelp("PCVC_SUFRAM",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Data de Início do Relacionamento."}
	aPHelpEng := {"Data de Início do Relacionamento."}
	aPHelpEsp := {"Data de Início do Relacionamento."}
	PutHelp("PCVC_DTINI",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
	
	aPHelpPor := {"Data do término do relacionamento."}
	aPHelpEng := {"Data do término do relacionamento."}
	aPHelpEsp := {"Data do término do relacionamento."}
	PutHelp("PCVC_DTFIM",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
EndIf

aPHelpPor := {"Informe o código da entidade da refe-","rencia contabil."}
aPHelpEng := {"Informe o código da entidade da refe-","rencia contabil."}
aPHelpEsp := {"Informe o código da entidade da refe-","rencia contabil."}
PutHelp("PCVD_ENTREF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor := {"Informe o código da conta contabil da","entidade."}
aPHelpEng := {"Informe o código da conta contabil da","entidade."}
aPHelpEsp := {"Informe o código da conta contabil da","entidade."}
PutHelp("PCVD_CTAREF",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :=	{"Indica a natureza da conta contábil,"	," conforme as opções abaixo. Será uti-",;
"lizado no SPED Contábil."				,"01-Conta do Ativo"					,;
"02-Conta do Passivo"					,"03-Patrimônio Líquido"				,;
"04-Conta de Resultado"				,"05-Conta de Compensação"				,;
"09-Outras"}
aPHelpEng :=	{"Indica a natureza da conta contábil,"	," conforme as opções abaixo. Será uti-",;
"lizado no SPED Contábil."				,"01-Conta do Ativo"					,;
"02-Conta do Passivo"					,"03-Patrimônio Líquido"				,;
"04-Conta de Resultado"				,"05-Conta de Compensação"				,;
"09-Outras"}
aPHelpEsp :=	{"Indica a natureza da conta contábil,"	," conforme as opções abaixo. Será uti-",;
"lizado no SPED Contábil."				,"01-Conta do Ativo"					,;
"02-Conta do Passivo"					,"03-Patrimônio Líquido"				,;
"04-Conta de Resultado"				,"05-Conta de Compensação"				,;
"09-Outras"}

PutHelp("PCT1_NTSPED",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)


aPHelpPor :=	{"Indica o tipo de utilização da conta"	," contábil. Será utilizado no FCONT.  ",;
"F-Fiscal"								,"S-Societario"	             			,;
"A-Ambos"}

aPHelpEsp :=	{"Indica o tipo de utilização da conta"	," contábil. Será utilizado no FCONT.  ",;
"F-Fiscal"								,"S-Societario"	             			,;
"A-Ambos"}

aPHelpEng :=	{"Indica o tipo de utilização da conta"	," contábil. Será utilizado no FCONT.  ",;
"F-Fiscal"								,"S-Societario"	             			,;
"A-Ambos"}

PutHelp("PCVN_TPUTIL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
PutHelp("PCVD_TPUTIL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)
PutHelp("PCS4_TPUTIL",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aPHelpPor :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil"      }
aPHelpEng :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil"      }
aPHelpEsp :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil"      }

PutHelp("PCT2_CODPAR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)


aPHelpPor :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil."     }
aPHelpEng :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil."     }
aPHelpEsp :=	{"Informar o Código do Participante. "  ,"Na maioria dos casos este código não" ,;
"será necessário, mas há situações  "  ,"específicas que o exigem no Lançamen-",;
"to Contábil."                         ,"Será utilizado no SPED Contábil."     }

PutHelp("PCT5_CODPAR",aPHelpPor,aPHelpEng,aPHelpEsp,.T.)

aHelpPor :=	{"Código de Diario Inválido"}
aHelpEng :=	{"Código de Diario Inválido"}
aHelpEsp :=	{"Código de Diario Inválido"}

PutHelp("PNOCODDIA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Os códigos 01/02/03/04/06/07/08/09 são","reservados para uso interno"}
aHelpEng :=	{"Os códigos 01/02/03/04/06/07/08/09 são","reservados para uso interno"}
aHelpEsp :=	{"Os códigos 01/02/03/04/06/07/08/09 são","reservados para uso interno"}

PutHelp("PRESCODDIA",aHelpPor,aHelpEng,aHelpEsp,.T.)


If cPaisLoc == "PER"
	aHelpPor :=	{"Conta partida a ser usada nos lançamentos","complementares."}
	aHelpEng :=	{"Conta partida a ser usada nos lançamentos","complementares."}
	aHelpEsp :=	{"Cuenta partida para los asientos","complementares."}
	PutHelp("PCT1_CTPART",aHelpPor,aHelpEng,aHelpEsp,.T.)
	/**/
	aHelpPor :=	{"Conta contra-partida a ser usada nos","lançamentos complementares."}
	aHelpEng :=	{"Conta contra-partida a ser usada nos","lançamentos complementares."}
	aHelpEsp :=	{"Cuenta contra-partida para los","asientos complementares."}
	PutHelp("PCT1_CTCPAR",aHelpPor,aHelpEng,aHelpEsp,.T.)
	/**/
	aHelpPor :=	{"Indica se para os lançamentos feitos nesta","conta, devem ser gerados","lançamentos complementares."}
	aHelpEng :=	{"Indica se para os lançamentos feitos","nesta conta, devem ser gerados","lançamentos complementares."}
	aHelpEsp :=	{"Indica si serán generados asientos","complementares para los asientos","hechos en esta cuenta."}
	PutHelp("PCT1_LCCMPL",aHelpPor,aHelpEng,aHelpEsp,.T.)
Endif
aPHelpPor := {"Filial do Sistema."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Código da filial referente a tabela de Código de Entidade ou Natureza Contábil."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_FILTAB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Código da Tabela de Código de Entidade ou Natureza Contábil."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_TABELA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Código da Entidade Contábil (ex.: CT1, CT3, CTD ou CTH)."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_CODIGO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Código do Grupo ou Natureza Contábil."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_GRUPO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Nome do campo que sofreu alteração (ex.: CT1_CONTA, CT1_CCUSTO, CT1_ITEMD, CT1_CLVL)."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_CAMPO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Numero de Sequencia de gravação."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_SEQ",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Tipo do Campo. Ex.: Numerico, Character, Data."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_TIPCPO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Titulo do Campo correspondente ao dicionário de Campos-SX3."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_TITULO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Conteúdo do campo antes da alteração."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_VALANT",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Conteúdo do campo após a alteração."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_VALNOV",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Data em que a alteração foi realizada."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_DATA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aPHelpPor := {"Hora em que a alteração foi realizada."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("CW8_HORA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

aHelpPor :=	{	"Informe a natureza da conta contabil." }
aHelpEng := {	"Enter the nature of the account."}
aHelpEsp := {	"Introduzca la modalidade de la cuenta ", "contable."}
PutHelp("PCT1_NATCTA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Continuação da descrição para imprimir","nos relatórios DFC e DVA." }
aHelpEng := {"Continuação da descrição para imprimir","nos relatórios DFC e DVA."}
aHelpEsp := {"Continuação da descrição para imprimir","nos relatórios DFC e DVA."}
PutHelp("PCVF_DETHCG",aHelpPor,aHelpEng,aHelpEsp,.T.)

//Tabela CTL - Novos campos para utilizacao do relatorio de auditoria, conhecido como quadratura contabil

aHelpPor :=	{"Campo para uma determinada data.","Exemplo: E1_EMISSAO"}
aHelpEsp := {"Campo para una determinada fecha.","Ejemplo: E1_EMISSAO"}
aHelpEng := {"Field for a certain date.","Example: E1_EMISSAO"}

PutHelp("PCTL_QCDATA",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Conjunto de campo separados com o ","simbolo (+)","para compor o numero do","documento. Exemplo:","F2_DOC+F2_SERIE"}
aHelpEsp := {"Conjunto de campos separados por el ","simbolo (+) para componer el numero ","del documento. Ejemplo:F2_DOC+F2_SERIE"}
aHelpEng := {"Group of fields separated by the (+) ","symbol to ","create the document ","number. Example:","F2_DOC+F2_SERIE"}

PutHelp("PCTL_QCDOC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Campo para a moeda. Por exemplo:","E1_MOEDA"}
aHelpEsp := {"Campo para la moneda. Por ejemplo:","E1_MOEDA"}
aHelpEng := {"Field for the currency. For example:","E1_MOEDA"}

PutHelp("PCTL_QCMOED",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Campo para o valor. Por exemplo:","F2_VALBRUT"}
aHelpEsp := {"Campo para el valor. Por ejemplo:","F2_VALBRUT"}
aHelpEng := {"Field for the value. For example:","F2_VALBRUT"}

PutHelp("PCTL_QCVLRD",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{"Define um campo para o correlativo.","Por exemplo: E2_NODIA"}
aHelpEsp := {"Define un campo para el correlativo."," Por ejemplo: E2_NODIA"}
aHelpEng := {"It defines a field for the correlative.","For example: E2_NODIA"}

PutHelp("PCTL_QCCORR",aHelpPor,aHelpEng,aHelpEsp,.T.)
//helps leiaute 2 ECD Sped Contabil
aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"versao do leiaute a ser utilizado  ",;
				"na ECD Sped Contabil."  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"versao do leiaute a ser utilizado  ",;
				"na ECD Sped Contabil."  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"versao do leiaute a ser utilizado  ",;
				"na ECD Sped Contabil."  }
PutHelp("PCS0_LEIAUT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"indicador  do  NIRE,  se  empresa ",;
				"possui ou nao o NIRE. " }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"indicador  do  NIRE,  se  empresa ",;
				"possui ou nao o NIRE. " }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"indicador  do  NIRE,  se  empresa ",;
				"possui ou nao o NIRE. " }
PutHelp("PCS0_INNIRE",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"finalidade da escrituração."  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"finalidade da escrituração."  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"finalidade da escrituração."  }
PutHelp("PCS0_FINESC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"Hash da escrituração substituida."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"Hash da escrituração substituida."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"Hash da escrituração substituida."  }
PutHelp("PCS0_HASHSB",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"NIRE da escrituração substituida."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"NIRE da escrituração substituida."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"NIRE da escrituração substituida."  }
PutHelp("PCS0_NIRESB",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"data de Apuração de Lucros/Perdas. "  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"data de Apuração de Lucros/Perdas. "  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"data de Apuração de Lucros/Perdas. "  }
PutHelp("PCS0_DATALP",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
PutHelp("PCS8_UFCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
aHelpEng :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
aHelpEsp :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
PutHelp("PCS8_SEQCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
PutHelp("PCS8_DTCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"email do signatario da escritura- ",;
				"cao ECD Sped Contabil."  }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"email do signatario da escritura- ",;
				"cao ECD Sped Contabil."  }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"email do signatario da escritura- ",;
				"cao ECD Sped Contabil."  }
PutHelp("PCS8_EMAIL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"telefone do signatario da escritu-",;
				"racao ECD Sped Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"telefone do signatario da escritu-",;
				"racao ECD Sped Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"telefone do signatario da escritu-",;
				"racao ECD Sped Contabil." }
PutHelp("PCS8_FONE",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"valor inicial da conta aglutinadora." }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"valor inicial da conta aglutinadora." }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"valor inicial da conta aglutinadora." }
PutHelp("PCSE_VLRINI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" inicial :                        ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" inicial :                        ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" inicial :                        ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
PutHelp("PCSE_INDINI",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"valor final da conta aglutinadora." }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"valor final da conta aglutinadora." }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"valor final da conta aglutinadora." }
PutHelp("PCSE_VLRFIM",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" final :                          ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" final :                          ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"Indicador da situação do saldo    ",;
				" final :                          ",;
				"D - Devedor;                      ",;
				"C - Credor.                       " }
PutHelp("PCSE_INDFIM",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"Indicador do tipo de operação  da ",;
				" linha:                           ",;
				"A = Adição                       ",;
				"S = Subtração                    ",;
				"L = Label (linha de separação)   ",;
				"P = Subtotal ou total positivo   ",;
				"N = Subtotal ou total negativo   "}
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"Indicador do tipo de operação  da ",;
				" linha:                           ",;
				"A = Adição                       ",;
				"S = Subtração                    ",;
				"L = Label (linha de separação)   ",;
				"P = Subtotal ou total positivo   ",;
				"N = Subtotal ou total negativo   " }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"Indicador do tipo de operação  da ",;
				" linha:                           ",;
				"A = Adição                       ",;
				"S = Subtração                    ",;
				"L = Label (linha de separação)   ",;
				"P = Subtotal ou total positivo   ",;
				"N = Subtotal ou total negativo   " }
PutHelp("PCSE_TIPOPE",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o",;
				"Indicador de situação do saldo:  ",;
				"SF = Saldo final                 ",;
				"VI = Saldo Inicial – Saldo Final ",;
				"VF = Saldo Final – Saldo Inicial" }
aHelpEng :=	{	"Neste campo devera ser informado o",;
				"Indicador de situação do saldo:  ",;
				"SF = Saldo final                 ",;
				"VI = Saldo Inicial – Saldo Final ",;
				"VF = Saldo Final – Saldo Inicial" }
aHelpEsp :=	{	"Neste campo devera ser informado o",;
				"Indicador de situação do saldo:  ",;
				"SF = Saldo final                 ",;
				"VI = Saldo Inicial – Saldo Final ",;
				"VF = Saldo Final – Saldo Inicial" }
PutHelp("PCSE_INDSLD",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"Estado da CRC."  }
PutHelp("PCVB_UFCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
aHelpEng :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
aHelpEsp :=	{	"Devera   ser   informado   numero ",;
				"sequencial no seguinte formato:   ",;
				"UF/ano/numero"  }
PutHelp("PCVB_SEQCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"data do CRC."  }
PutHelp("PCVB_DTCRC",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
PutHelp("PCSN_FILIAL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
PutHelp("PCSN_CODREV",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J200)."}
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J200)."}
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J200)."}
PutHelp("PCSN_REG",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
PutHelp("PCSN_CODFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
PutHelp("PCSN_DESFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"filial do sistema.                 "  }
PutHelp("PCSO_FILIAL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo  da  revisao da ECD  - Sped ",;
				"Contabil."  }
PutHelp("PCSO_CODREV",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J215)."}
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J215)."}
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"registro do leiaute 2 da ECD(J215)."}
PutHelp("PCSO_REG",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo da  visao  gerencial   para ",;
				"leiaute 2 da ECD Sped Contabil."}
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo da  visao  gerencial   para ",;
				"leiaute 2 da ECD Sped Contabil."}
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo da  visao  gerencial   para ",;
				"leiaute 2 da ECD Sped Contabil."}
PutHelp("PCSO_CODVIS",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo da conta utilizada na visao ",;
				"gerencial para  leiaute  2  da ECD ",;
				"Sped Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo da conta utilizada na visao ",;
				"gerencial para  leiaute  2  da ECD ",;
				"Sped Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo da conta utilizada na visao ",;
				"gerencial para  leiaute  2  da ECD ",;
				"Sped Contabil." }
PutHelp("PCSO_CODAGL",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"codigo do fato contabil  necesario ",;
				"para leiaute 2 ECD Sped Contabil." }
PutHelp("PCSO_CODFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado a ",;
				"descrição do fato contabil necessá-",;
				"rio para leiaute 2 da ECD Sped     ",;
				"Contabil." }
PutHelp("PCSO_DESFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)

aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"valor  do  fato  contabil  para  o ",;
				"leiaute 2 da ECD Sped Contabil." }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"valor  do  fato  contabil  para  o ",;
				"leiaute 2 da ECD Sped Contabil." }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"valor  do  fato  contabil  para  o ",;
				"leiaute 2 da ECD Sped Contabil." }
PutHelp("PCSO_VLRFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)


aHelpPor :=	{	"Neste campo devera ser informado o ",;
				"indicador  referente ao  valor  do ",;
				"fato contabil para leiaute 2 da ECD",;
				" Sped Contabil.                    ",;
				"Conteudo para o campo:             ",;
				"D - Devedor                        ",;
				"C - Credor                         ",;
				"P - Subtotal ou total positivo     ",;
				"N - Subtotal ou total negativo     " }
aHelpEng :=	{	"Neste campo devera ser informado o ",;
				"indicador  referente ao  valor  do ",;
				"fato contabil para leiaute 2 da ECD",;
				" Sped Contabil.                    ",;
				"Conteudo para o campo:             ",;
				"D - Devedor                        ",;
				"C - Credor                         ",;
				"P - Subtotal ou total positivo     ",;
				"N - Subtotal ou total negativo     " }
aHelpEsp :=	{	"Neste campo devera ser informado o ",;
				"indicador  referente ao  valor  do ",;
				"fato contabil para leiaute 2 da ECD",;
				" Sped Contabil.                    ",;
				"Conteudo para o campo:             ",;
				"D - Devedor                        ",;
				"C - Credor                         ",;
				"P - Subtotal ou total positivo     ",;
				"N - Subtotal ou total negativo     " }
PutHelp("PCSO_INDFAT",aHelpPor,aHelpEng,aHelpEsp,.T.)

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProxSX3  ³ Autor ³ --------------------- ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a próxima ordem disponivel no SX3 para o ALIAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProxSX3(cAlias,cCpo)
Local aArea 	:= GetArea()
Local aAreaSX3 	:= SX3->(GetArea())
Local nOrdem	:= 0
Local nPosOrdem	:= 0
Local cEmpresa	:= SM0->M0_CODIGO
Local cFilAtu	:= SM0->M0_CODFIL

Static aOrdem	:= {}

Default cCpo	:= ""

IF !Empty(cCpo)
	SX3->(DbSetOrder(2))
	IF SX3->(MsSeek(cCpo))
		nOrdem := Val(RetAsc(SX3->X3_ORDEM,3,.F.))
	ENDIF
ENDIF

IF Empty(cCpo) .OR. nOrdem == 0
	
	IF (nPosOrdem := aScan(aOrdem, {|aLinha|	aLinha[1] == cAlias		.And.;
		aLinha[3] == cEmpresa	.And.;
		aLinha[4] == cFilAtu })) == 0
		SX3->(dbSetOrder(1))
		SX3->(MsSeek(cAlias))
		WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAlias
			nOrdem++
			SX3->(dbSkip())
		END
		nOrdem++
		AADD(aOrdem,{cAlias,nOrdem,cEmpresa,cFilAtu})
		
	ELSE
		aOrdem[nPosOrdem][2]++
		nOrdem := aOrdem[nPosOrdem][2]
		
	ENDIF
	
ENDIF

RestArea(aAreaSX3)
RestArea(aArea)
Return RetAsc(Str(nOrdem),2,.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX5 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX5                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX5()
//  "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"

Local aSX5   := {}
Local aSX5Del:= {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.
Local cTexto := ""
Local cFilX5 := xFilial( 'SX5' )

aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}

AADD(aSX5,{cFilX5,"00","GP","TIPOS DE PLANO DE REFERENCIA"  	,"TIPOS DE PLANO DE REFERENCIA"  	,"TIPOS DE PLANO DE REFERENCIA"  })
AADD(aSX5,{cFilX5,"GP","00","SUSEP"    ,"SUSEP"    ,"SUSEP"    })
AADD(aSX5,{cFilX5,"GP","10","RECEITA"  ,"INGRESO"  ,"REVENUE"  })
AADD(aSX5,{cFilX5,"GP","20","COSIF"    ,"COSIF"    ,"COSIF"    })
AADD(aSX5,{cFilX5,"GP","99","OUTROS"   ,"OTROS"    ,"OTHER"    })

//
AADD(aSX5Del,{cFilX5,"GP","30","SUSEP"    ,"SUSEP"    ,"SUSEP"    })

If cPaisLoc == "COL"
	//Tabela para idenficação do Tipo de Documento de Terceiros (Conforme a resolução DIAN 004837/2008, artigo 23)
	AADD(aSX5,{cFilX5,"00","TB","TIPOS DE DOCUMENTO"  		    ,"TIPOS DE DOCUMENTO" 		  		,"DOCUMENT TYPES"  })
	AADD(aSX5,{cFilX5,"TB","11","Registro Civil de Nascimento"  ,"Registro Civil de Nascimiento"	,"Record Born Date"    })
	AADD(aSX5,{cFilX5,"TB","12","Cartão de Identidade"		    ,"Cedula de Identidad"	      		,"Id. Card"  })
	AADD(aSX5,{cFilX5,"TB","13","Cédula de Cidadania"		    ,"Cedula de Ciudadania"	      		,"Citizen Card"    })
	AADD(aSX5,{cFilX5,"TB","21","Cartão Id. de Estrageiros"     ,"Tarjeta de Extranjeria" 	  		,"Foreigen Id. Card"   })
	AADD(aSX5,{cFilX5,"TB","22","Cédula para Id. de Estrangeios","Cedula de Extranjeria"	  		,"Foreigen Id. Document"   })
	AADD(aSX5,{cFilX5,"TB","31","N.I.T."					    ,"N.I.T." 					  		,"N.I.T."   })
	AADD(aSX5,{cFilX5,"TB","41","Passaporte"					,"Pasaporte"			 	 		,"Passport"   })
	AADD(aSX5,{cFilX5,"TB","42","Documento Estrangeiro"		    ,"Documento Extranjero" 	  		,"Foreigen Document"   })
	AADD(aSX5,{cFilX5,"TB","43","Sem identificação do Exterior" ,"Sin identificación del Exterior"	,"No Foreigen Id. Document"   })
EndIf
If cPaisLoc == "PER"
	//Tabela para idenficação do Tipo de Documento de Terceiros , incluir somente o "06" e "00" .
	AADD(aSX5,{cFilX5,"00","TB","TIPOS DE DOCUMENTO","TIPOS DE DOCUMENTO","DOCUMENT TYPES" })
	AADD(aSX5,{cFilX5,"TB","06","Registro Unico de Contribuinte","Registro Unico de Contribuyente" ,"R.U.C" })
	AADD(aSX5,{cFilX5,"TB","00","Outros Tipos de Documentos","Otros Tipos de Documentos","Others Documents Type" })
EndIf
ProcRegua(Len(aSX5))

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !dbSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])
			
			lSX5 := .T.
			RecLock("SX5",.T.)
			
			For j:=1 To Len(aSX5[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0036) // //"Atualizando Tabelas..."
		EndIf
	EndIf
Next i

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5Del)
	If !Empty(aSX5Del[i][2])
		If dbSeek(aSX5Del[i,1]+aSX5Del[i,2]+aSX5Del[i,3])
			RecLock("SX5",.F.)
			DbDelete()
			MsUnLock()
			IncProc(STR0036) // //"Atualizando Tabelas..."
		EndIf
	EndIf
Next i

If lSX5
	cTexto := STR0050+CRLF //'Arquivo de tabelas (SX5) atualizado.'
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX6 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX6()
//  X6_FIL   X6_VAR     X6_TIPO    X6_DESCRIC X6_DSCSPA  X6_DSCENG  X6_DESC1 X6_DSCSPA1 X6_DSCENG1
//  X6_DESC2 X6_DSCSPA2 X6_DSCENG2 X6_CONTEUD X6_CONTSPA X6_CONTENG X6_PROPRI

Local aSX6   	:= {}
Local aSX6Alter	:= {}
Local aEstrut	:= {}
Local i      	:= 0
Local j      	:= 0
Local lSX6	 	:= .F.
Local cTexto 	:= ''
Local cAlias 	:= ''
Local cConteudo := ''
Local nTamFilial:= CtbTamSXG("033",2)

If (cPaisLoc == "BRA")
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
	"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}
Else
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
	"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}
EndIf

// Limite de 50 caracteres por descrição
AADD(aSX6,{	SPACE(nTamFilial),"MV_CTQFTZR","L",;
"Define se permite que o percentual das linhas     ","Define se permite que o percentual das linhas     ","Define se permite que o percentual das linhas     ",;
"de rateio ou cadastros similares aceitarão valores","de rateio ou cadastros similares aceitarão valores","de rateio ou cadastros similares aceitarão valores",;
"zerados, se a linha possuir uma fórmula.          ","zerados, se a linha possuir uma fórmula.          ","zerados, se a linha possuir uma fórmula.          ",;
"T","T","T",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_SEGOFI" ,"C",;
"CONTROLE DO DIARIO 0-DESABILITA,1-CONTINUO,"       ,"CONTROLE DO DIARIO 0-DESABILITA,1-CONTINUO,"       ,"CONTROLE DO DIARIO 0-DESABILITA,1-CONTINUO,"       ,;
"2-MES,3-ANO,4-PERIODO,5-INTEGRADO          "	    ,"2-MES,3-ANO,4-PERIODO,5-INTEGRADO          "	     ,"2-MES,3-ANO,4-PERIODO,5-INTEGRADO          "		  ,;
"6-POR COMPROVANTE 7-POR PROCESSO"                  ,"6-POR COMPROVANTE 7-POR PROCESSO","6-POR COMPROVANTE 7-POR PROCESSO"       											  ,;
"0","0","0",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBCRPI","C",;
"PERIODO INICIAL DE ACORDO COM O MV_SEGOFI  "		,"PERIODO INICIAL DE ACORDO COM O MV_SEGOFI  "		 ,"PERIODO INICIAL DE ACORDO COM O MV_SEGOFI  "       ,;
"PARA O TIPO 4-PERIODO                      "		,"PARA O TIPO 4-PERIODO                      "		 ,"PARA O TIPO 4-PERIODO                      "	  	  ,;
""													,""													 ,""												  ,;
"0101","0101","0101",;
"S","S"})
AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBCRPF","C",;
"PERIODO FINAL   DE ACORDO COM O MV_SEGOFI  "	 	,"PERIODO FINAL   DE ACORDO COM O MV_SEGOFI  "		 ,"PERIODO FINAL   DE ACORDO COM O MV_SEGOFI  "		  ,;
"PARA O TIPO 4-PERIODO                      "		,"PARA O TIPO 4-PERIODO                      "		 ,"PARA O TIPO 4-PERIODO                      "		  ,;
""											        ,""											         ,""												  ,;
"1231","1231","1231",;
"S","S"})
AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBVLSQ","C",;
"DEFINE QUAL TIPO DE SALDO ESTA HABILITADO  "		,"DEFINE QUAL TIPO DE SALDO ESTA HABILITADO  "		 ,"DEFINE QUAL TIPO DE SALDO ESTA HABILITADO  "		  ,;
"O CONTROLE, CASO SEJA CONTROLADO NAO ACEITA LANCAMENTOS RETROATI","O CONTROLE, CASO SEJA CONTROLADO NAO ACEITA LANCAMENTOS RETROATI","O CONTROLE, CASO SEJA CONTROLADO NAO ACEITA LANCAMENTOS RETROATI",;
"VO"												,"VO"												 ,"VO"												  ,;
"1","1","1",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTMSCOR","L",;
"DEFINE SE SERA EXIBIDA MENSAGEM INFORMANDO "		,"DEFINE SE SERA EXIBIDA MENSAGEM INFORMANDO "		 ,"DEFINE SE SERA EXIBIDA MENSAGEM INFORMANDO "		  ,;
"A NUEMRACAO CORRELATIVA GRAVADA PARA A MOVIMENTACAO","A NUEMRACAO CORRELATIVA GRAVADA PARA A MOVIMENTACAO","A NUMERACAO CORRELATIVA GRAVADA PARA A MOVIMENTACAO",;
""													,""													 ,""												  ,;
".F.",".F.",".F.",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBJOB","N",;
"DEFINE SE USARA JOB PARA O PROCESSAMENTO DE"		,"DEFINE SE USARA JOB PARA O PROCESSAMENTO DE"		,"DEFINE SE USARA JOB PARA O PROCESSAMENTO DE "		  	,;
"SALDOS."                                           ,"SALDOS"											,"SALDOS"												,;
"1=Utiliza Job;2=Processamento tradicional"			, "1=Utiliza Job;2=Processamento tradicional"			,"1=Utiliza Job;2=Processamento tradicional"		,;
"2","2","2",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTB102I","N",;
"DEFINE A ACAO QUE DEVE SER TOMADA QUANDO"   		,"DEFINE A ACAO QUE DEVE SER TOMADA QUANDO"			,"DEFINE A ACAO QUE DEVE SER TOMADA QUANDO"				,;
"UTILIZADA A ATUALIZACAO DE SALDOS VIA JOB"         ,"UTILIZADA A ATUALIZACAO DE SALDOS VIA JOB"		,"UTILIZADA A ATUALIZACAO DE SALDOS VIA JOB"			,;
"1=Nao grava;2=Grava pre-lancamento;3=Pergunta"		,"1=Nao grava;2=Grava pre-lancamento;3=Pergunta"	,"1=Nao grava;2=Grava pre-lancamento;3=Pergunta"		,;
"2","2","2",;
"S","S"})


aAdd( aSX6 ,{SPACE(nTamFilial),"MV_CTBAPLA"	,"C","Indica se o SigaCTB ira limpar os flags de contabi"	,"lização (_LA/_DTLANC) ao excluir lançamentos."		,"1=Nao;2=Perguntar;3=Sim c/alertas;4=Sim s/ alertas"	,"Indica si el SigaCTB limpiara los flags de conta"		,"bilizacion (_LA/_DTLANC) al borrar asientos."		,"1=No;2=Pergunta;3-Si c/alertas;4=Si s/alertas","Indicates if SigaCTB will clear accounting flags"		,"(_LA/_DTLANC) when deleting entries. 1=No;"	,"2=Ask;3=Yes with alerts;4=Yes without alerts","1"		,"1"		,"1","S","S"	})
aAdd( aSX6 ,{SPACE(nTamFilial),"MV_CTBDEST"	,"C","Indica se os estornos de lançamentos poderão"			,"sofrer alteração de valores, contas, etc."			,"Conteudo : 1=Sim , 2=Nao"								,"Indica si las devoluciones de  asientos podran"		,"sufrir alteracion de valores, cuentas, etc."		,"Contenido : 1=Si , 2=No"						,"Indicates if the reversals of entries can be their"	,"values, accounts, etc,  modified."			,"Content : 1=Yes , 2=No.","2"		,"2"		,"2"	 	,"S","S"						})
aAdd( aSX6 ,{SPACE(nTamFilial),"MV_CTBHRAT"	,"L","Habilita historico para rotina de Rateio Off-Line"	,""														,""														,"Habilita historial para rutina de Prorrat.Off-Line"	,""													,""												,"Enables the history for off-line proration routine"	,""												,"",".F."		,".F."					,".F."	  		,"S"												})
aAdd( aSX6 ,{SPACE(nTamFilial),"MV_CTBPAIS"	,"C","Informe os códigos de país onde a contabilização é"	,"realizada por cliente ou fornecedor em vez de ent"	,"rada ou saída."										,"Informe los códigos de país donde la contabiliza"		,"cion es realizada por el cliente o proveedor en"	,"vez de entrada o salida."						,"Enter the codes of the countries where the"			,"accounting is executed by client or supplier"	,"instead of inflow or outflow.","CHI"		,"CHI"		,"CHI"	  	,"S","S"				})
aAdd( aSX6 , {SPACE(nTamFilial),"MV_CTBURL" ,"C","Parametro que indica qual o caminho a ser utilizado"	,"pelo SPED"										   		,""												  		,"Parametro que muestra cual es el camino a utilizar"	,"por los SPED"										,""												,"Parameter which indicates that the path to be "		,"used by SPED"			   						,"" ,"http://"	,"http://"	,"http://","S","S"												})


AADD(aSX6,{ SPACE(nTamFilial),"MV_SQSUB01","C",;
"Lançamentos padrão de Ingresso"	 	,"Lançamentos padrão de Ingresso"		 ,"Lançamentos padrão de Ingresso"		  ,;
""		,""		 ,""		  ,;
""											        ,""											         ,""												  ,;
"500|501|502|563|565|575|576|581","500|501|502|563|565|575|576|581","500|501|502|563|565|575|576|581",;
"S","S"})
AADD(aSX6,{ SPACE(nTamFilial),"MV_SQSUB02","C",;
"Lançamentos padrão de Egresso"	 	,"Lançamentos padrão de Egresso"		 ,"Lançamentos padrão de Egresso"		  ,;
"                      "		,"      "		 ,"                "		  ,;
""											        ,""											         ,""												  ,;
"510|513|514|560|561|562|564|570|571|590|591|597","510|513|514|560|561|562|564|570|571|590|591|597","510|513|514|560|561|562|564|570|571|590|591|597",;
"S","S"})
AADD(aSX6,{ SPACE(nTamFilial),"MV_SQSUB03","C",;
"Lançamentos padrão de Transpasso"	 	,"Lançamentos padrão de Transpasso","Lançamentos padrão de Transpasso" ,;
""		,"       "		 ,"         "		  ,;
""											        ,""											         ,""												  ,;
"","","",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_SEQCORR","C",;
"Define se o tipo para controle de criacao dos corr","Define se o tipo para controle de criacao dos corr","Define se o tipo para controle de criacao dos corr" ,;
"Elativos comprovantes contabeis sera unico ou nao,"		,"Elativos comprovantes contabeis sera unico ou nao,"		 ,"Elativos comprovantes contabeis sera unico ou nao,"		  ,;
"Com quebra mensal/anual e se vincula com sublote. ","Com quebra mensal/anual e se vincula com sublote.","Com quebra mensal/anual e se vincula com sublote. ",;
"1AN","1AN","1AN",;
"S","S"})
AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBLVPR","C",;
"Define o plano da tabela auxiliar (CW0) ","Define o plano da tabela auxiliar (CW0) ","Define o plano da tabela auxiliar (CW0) " ,;
"com a amarração livros por processo"		,"com a amarração livros por processo"		 ,"com a amarração livros por processo"		  ,;
""														,"","",;
"","","",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBAMAR","C",;
"Ativa controle de Amarracao nos lancamentos conta","Ativa controle de Amarracao nos lancamentos conta","Ativa controle de Amarracao nos lancamentos conta",;
"beis. Definicao 0=Nao tem amarracao, 1=Regra de ni","beis. Definicao 0=Nao tem amarracao, 1=Regra de ni","beis. Definicao 0=Nao tem amarracao, 1=Regra de ni",;
"veis, 2=Regra de Amarracao tabela CTA","veis, 2=Regra de Amarracao tabela CTA","veis, 2=Regra de Amarracao tabela CTA",;
"1","1","1",;
"S","S"})

AADD(aSX6,{ SPACE(nTamFilial),"MV_CTBCUBE","C",;
"Utiliza cubo de entidades contábeis?","Utiliza cubo de entidades contábeis?","Utiliza cubo de entidades contábeis?",;
"Definicao 0 = Não, 1 = Sim","Definicao 0 = Não, 1 = Sim","Definicao 0 = Não, 1 = Sim",;
"","","",;
"0","0","0",;
"S","S"})

If cPaisLoc == "COL"
	AADD(aSX6,{ SPACE(nTamFilial),"MV_FMTCONS","N",;
	"Define o numero sequencial de envio     ","Define el consecutivo de envio por año  ","Define the sequence number to year " ,;
	"dos meios magnéticos.              	 ","para los meios magnéticos.              ","that magnetic records.             " ,;
	""														,"","",;
	"0","0","0",;
	"S","S"})
EndIf


AADD( aSX6, {	SPACE(nTamFilial),"MV_CNFETHR","N",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"contabilizacao offline das notas fiscais  ",;
"contabilizacao offline das notas fiscais  ",;
"contabilizacao offline das notas fiscais  ",;
"de entrada (CTBANFE), minimo 1 maximo 15 ",;
"de entrada (CTBANFE), minimo 1 maximo 15 ",;
"de entrada (CTBANFE), minimo 1 maximo 15 ",;
"1","1","1","S" } )


AADD( aSX6, {	SPACE(nTamFilial),"MV_CNFSTHR","N",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"contabilizacao offline das notas fiscais  ",;
"contabilizacao offline das notas fiscais  ",;
"contabilizacao offline das notas fiscais  ",;
"de saida (CTBANFS), minimo 1 maximo 15 ",;
"de saida (CTBANFS), minimo 1 maximo 15 ",;
"de saida (CTBANFS), minimo 1 maximo 15 ",;
"1","1","1","S" } )


AADD( aSX6, {	SPACE(nTamFilial),"MV_CFINTHR","N",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"Quantidade de threads a serem usadas na ",;
"contabilizacao offline dos titulos  ",;
"contabilizacao offline dos titulos  ",;
"contabilizacao offline dos titulos  ",;
"financeiros (CTBAFIN), minimo 1 maximo 15 ",;
"financeiros (CTBAFIN), minimo 1 maximo 15 ",;
"financeiros (CTBAFIN), minimo 1 maximo 15 ",;
"1","1","1","S" } )

AADD( aSX6 , {	SPACE(nTamFilial),"MV_CTBLGET","L",;
"Habilita log de historico de alterações ",;
"Habilita log de historico de alterações ",;
"Habilita log de historico de alterações ",;
"das Entidades Contabeis. ",;
"das Entidades Contabeis. ",;
"das Entidades Contabeis. ",;
" ",;
" ",;
" ",;
".F.",".F.",".F.","S" } )

AADD( aSX6 , {	SPACE(nTamFilial),"MV_CTBGRUP","C",;
"Define conteudo que substituira 'Grupo  ",;
"Define conteudo que substituira 'Grupo  ",;
"Define conteudo que substituira 'Grupo  ",;
"Contabil' no dic. dados. ",;
"Contabil' no dic. dados. ",;
"Contabil' no dic. dados. ",;
" ",;
" ",;
" ",;
" "," "," ","S" } )

//MV_CTBCACH  -->Tipo Caracter onde "0"=Nao Trabalha com Cache "1"=Trabalha com Cache
aAdd( aSX6, { SPACE(nTamFilial), 'MV_CTBCACH', 'C',;
'Indica se calendario, moeda, cambio e as      ',;
'Indica si  calendario, la moneda de cambio    ',;
'Indicates whether calendar, currency, exchange',;
'entidades contabeis contas, centro de custo,  ',;
'y ent.cuentas, centro de costos, item, clase  ',;
'and accounting entities such as accounts,     ',;
' item  e classe de valor trabalham com cache ',;
'trabajo con la información en caché          ',;
' cost center,etc work with the cached        ',;
"1", "1", "1", "S" } )

AADD(aSX6,{ SPACE(nTamFilial),"MV_TPVALOR","C",;
"Indica qual o tipo de sinal sera impresso nos rela","Indica el tipo de signo que se imprimira en los in","Indicates the sign type to be printed in",;
"torios contabeis. S->Imprime sinais, P->Imprime","formes contables. S->Imprime signos, P->Imprime","accounting reports. S->Prints signs, P->Prints",;
"parenteses, D->Default, imprime D ou C.","parentesis, D->Preconf., imprime D o C.","parentheses, D->Default, prints D or C.",;
"D","D","D",;
"S","S"})

// Tratamento para atualizacao do MV_CTBHRAT
// Verificacao apenas para filial em branco
dbSelectArea("SX6")
dbSetOrder(1)
IF !DbSeek(SPACE(nTamFilial)+"MV_CTBHRAT")
	// Se o parametro nao existir, cria padrão
	
	AADD(aSX6Alter,{ SPACE(nTamFilial),"MV_CTBHRAT","C",;
	"Habilita historico para rotina de Rateio Off-Line"	,"Habilita historial para rutina de Prorrat.Off-Line" 	,"Enables the history for off-line proration routine"	,;
	""													,""														,""														,;
	""													,""													 	,""												  		,;
	"0","0","0",;
	"S","S"})
	
ELSEIF SX6->X6_TIPO == "L" // SE ACHOU E O PARAMETRO AINDA ESTA COMO LOGICO
	
	cConteudo := IIF(GETMV("MV_CTBHRAT"),"3","0")
	
	AADD(aSX6Alter,{ SPACE(nTamFilial),"MV_CTBHRAT","C",;
	"Habilita historico para rotina de Rateio Off-Line"	,"Habilita historial para rutina de Prorrat.Off-Line" 	,"Enables the history for off-line proration routine"	,;
	""													,""														,""														,;
	""													,""													 	,""												  		,;
	cConteudo,cConteudo,cConteudo,;
	"S","S"})
	
ENDIF

AADD( aSX6, {	SPACE(nTamFilial),"MV_CTBLBSQ","C",;
				"Indica se será permitido alterar o controle de ",;
				"Indica si se permite modificar el control de ",;
				"Indicates whether to allow the change of ",;
				"correlativos, permitindo a inclusão de novos  ",;
				"correlativos, lo que permite la inclusión de nuevos  ",;
				"control counterparts, allowing the inclusion of new   ",;
				"códigos. S permite, N mantém a validação padrão. ",;
				"códigos. S permite, N retiene el estándar de validación. ",;
				"codes. S allows, N retains the standard validation. ",;
				"N","N","N","S" } )
                   
AADD( aSX6, {	SPACE(nTamFilial),"MV_CTBDTXT","C",;
				"Caminho para criacao de arquivo texto ",;
				"Camino para crear archivo texto ",;
				"Path to creat text file for ",;
				"de exportacao TXT.",;
				"de exportacion TXT.",;
				"TXT export.",;
				"","","",;
				"","","","S","S" } )
				

ProcRegua(Len(aSX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0037) // //"Atualizando Parametros..."
		EndIf
	EndIf
Next i

For i:= 1 To Len(aSX6Alter)
	If !Empty(aSX6Alter[i][2])
		// Não encontrou, então inclui normalmente
		If !dbSeek(aSX6Alter[i,1]+aSX6Alter[i,2])
			lSX6	:= .T.
			If !(aSX6Alter[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6Alter[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6Alter[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc(STR0037) // //"Atualizando Parametros..."
		Else // Encontrou, então procede com a atualizacao
			lSX6	:= .T.
			If !(aSX6Alter[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.F.)
			For j:=1 To Len(aSX6Alter[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6Alter[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc(STR0037) // //"Atualizando Parametros..."
		EndIf
	EndIf
Next i

// Atualiza o Pyme dos parametros par SIM
dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If SX6->(dbSeek(aSX6[i,1]+aSX6[i,2]))
			RecLock("SX6",.F.)
			SX6->X6_PYME := "S"
			dbCommit()
			MsUnLock()
			IncProc(STR0037) // //"Atualizando Parametros..."
		EndIf
	EndIf
Next i



If lSX6
	cTexto := STR0038+cAlias+CRLF //'Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : '
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSX7 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX7()
//  X7_CAMPO X7_SEQUENC X7_REGRA X7_CDOMIN X7_TIPO X7_SEEK X7_ALIAS X7_ORDEM X7_CHAVE X7_PROPRI X7_CONDIC

Local aSX7   := {}
Local aSX7Alt:= {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSX7	 := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
Else
	aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}
EndIf

Aadd(aSX7,{"CVD_CODPLA","001","SPACE(LEN(CVD->CVD_CTAREF))","CVD_CTAREF","P","N","",0,"","S",""                                          })
Aadd(aSX7,{"CVD_CODPLA","002","SPACE(LEN(CVD->CVD_CUSTO))" ,"CVD_CUSTO" ,"P","N","",0,"","S","Empty(M->CVD_CODPLA)"                      })
Aadd(aSX7,{"CVD_CTAREF","001","CVN->CVN_TPUTIL" ,"CVD_TPUTIL" ,"P","S","CVN",2,"xFilial('CVN')+GDFIELDGET('CVD_CODPLA')+M->CVD_CTAREF","S","" })

If cPaisLoc == "COL"
	Aadd(aSX7,{"A1_PAIS","001","M->A1_PAISDES:=SYA->YA_DESCR","A1_PAISDES","P","S","SYA",1,"xFilial('SYA')+M->A1_PAIS","S","!EMPTY(M->A1_PAIS)"})
	Aadd(aSX7,{"A2_PAIS","001","M->A2_PAISDES:=SYA->YA_DESCR","A2_PAISDES","P","S","SYA",1,"xFilial('SYA')+M->A2_PAIS","S","!EMPTY(M->A2_PAIS)"})
	aAdd(aSX7Alt,{"A1_COD_MUN","001","CC2->CC2_MUN","A1_MUN","P","S","CC2",1,"xFilial('CC2')+M->A1_EST+M->A1_COD_MUN","S",""})
	aAdd(aSX7Alt,{"A2_COD_MUN","001","CC2->CC2_MUN","A2_MUN","P","S","CC2",1,"xFilial('CC2')+M->A2_EST+M->A2_COD_MUN","S",""})
EndIf
ProcRegua(Len(aSX7))

dbSelectArea("SX7")
dbSetOrder(1)
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !dbSeek(aSX7[i,1]+aSX7[i,2])
			lSX7 := .T.
			If !(aSX7[i,1]$cAlias)
				cAlias += aSX7[i,1]+"/"
			EndIf
			RecLock("SX7",.T.)
			
			For j:=1 To Len(aSX7[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0039) // //"Atualizando Gatilhos..."
		EndIf
	EndIf
Next i
/*-*/
For i:= 1 To Len(aSX7Alt)
	If !Empty(aSX7Alt[i][1])
		If dbSeek(aSX7Alt[i,1]+aSX7Alt[i,2])
			lSX7 := .T.
			If !(aSX7Alt[i,1]$cAlias)
				cAlias += aSX7Alt[i,1]+"/"
			EndIf
			RecLock("SX7",.F.)
			
			For j:=1 To Len(aSX7Alt[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7Alt[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0039) // //"Atualizando Gatilhos..."
		EndIf
	EndIf
Next i

If lSX7
	cTexto := STR0041+cAlias+CRLF //'Gatilhos atualizados : '
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSXA ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXA                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSXA()
//"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"

Local aSXA   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local aSX3	 := {}
Local nX	 := 0
Local lSXA	 := .F.
Local cAlias := ''
Local cTexto := ""

If (cPaisLoc == "BRA")
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
Else
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
EndIf

AADD(aSXA,{"CW2","1","Amarracao"			,"Amarracao"			,"Amarracao"			,"S"})
AADD(aSXA,{"CW2","2","Cabeçalho Rateio"		,"Cabeçalho Rateio"		,"Cabeçalho Rateio"		,"S"})
AADD(aSXA,{"CW2","3","Dados Origem"			,"Dados Origem"			,"Dados Origem"			,"S"})
AADD(aSXA,{"CW2","4","Dados Partida"		,"Dados Partida"		,"Dados Partida"		,"S"})
AADD(aSXA,{"CW2","5","Dados Contra-Partida"	,"Dados Contra-Partida"	,"Dados Contra-Partida"	,"S"})

AADD(aSX3,{ "CW2_FILIAL"	,"1"})
AADD(aSX3,{ "CW2_CODIGO"	,"1"})
AADD(aSX3,{ "CW2_DESCRI"	,"1"})
AADD(aSX3,{ "CW2_STATUS"	,"1"})
AADD(aSX3,{ "CW2_MSBLQL"	,"1"})

AADD(aSX3,{ "CW2_CODCTQ"	,"2"})
AADD(aSX3,{ "CW2_DSCCTQ"	,"2"})
AADD(aSX3,{ "CW2_INTERC"	,"2"})
AADD(aSX3,{ "CW2_TIPO"		,"2"})

AADD(aSX3,{ "CW2_ORIGEM"	,"3"})
AADD(aSX3,{ "CW2_CTTORI"	,"3"})
AADD(aSX3,{ "CW2_CTDORI"	,"3"})
AADD(aSX3,{ "CW2_CTHORI"	,"3"})

AADD(aSX3,{ "CW2_CT1PAF"	,"4"})
AADD(aSX3,{ "CW2_CT1PAR"	,"4"})
AADD(aSX3,{ "CW2_CTTPAF"	,"4"})
AADD(aSX3,{ "CW2_CTTPAR"	,"4"})
AADD(aSX3,{ "CW2_CTDPAF"	,"4"})
AADD(aSX3,{ "CW2_CTDPAR"	,"4"})
AADD(aSX3,{ "CW2_CTHPAF"	,"4"})
AADD(aSX3,{ "CW2_CTHPAR"	,"4"})

AADD(aSX3,{ "CW2_CT1DEF"	,"5"})
AADD(aSX3,{ "CW2_DESTIN"	,"5"})
AADD(aSX3,{ "CW2_CTTDEF"	,"5"})
AADD(aSX3,{ "CW2_CTTDES"	,"5"})
AADD(aSX3,{ "CW2_CTDDEF"	,"5"})
AADD(aSX3,{ "CW2_CTDDES"	,"5"})
AADD(aSX3,{ "CW2_CTHDEF"	,"5"})
AADD(aSX3,{ "CW2_CTHDES"	,"5"})
AADD(aSX3,{ "CW2_FORMUL"	,"5"})

ProcRegua(Len(aSXA))

dbSelectArea("SXA")
dbSetOrder(1)
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !dbSeek(aSXA[i,1]+aSXA[i,2])
			lSXA := .T.
			
			If !(aSXA[i,1]$cAlias)
				cAlias += aSXA[i,1]+"/"
			EndIf
			
			RecLock("SXA",.T.)
			For j:=1 To Len(aSXA[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0040) // //"Atualizando Folder de Cadastro..."
		EndIf
	EndIf
Next i

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aSX3)
	If dbSeek(aSX3[nx][1])
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := aSX3[nx][2]
		MsUnlock()
	EndIf
Next

If lSXA
	cTexto := STR0051+cAlias+CRLF //'Atualizado arquivos de folders (SXA).'
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuSXB ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXB                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSXB()
//  XB_ALIAS XB_TIPO XB_SEQ XB_COLUNA XB_DESCRI XB_DESCSPA XB_DESCENG XB_CONTEM

Local aSXB   := {}
Local aAjSXB := {}
Local aDelSXB:= {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local cAlias := ''
Local lSXB   := .F.

If (cPaisLoc == "BRA")
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
Else
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
EndIf

// Consulta para Operacoes (CVG)
aAdd(aSXB,{"CVG","6","01",""  ,""               ,""               ,""               ,'CVG->CVG_PROCES = M->CVA_PROCES'})

// Consulta para o Grupo de Rateio (CW1)
aAdd(aSXB,{"CW1","1","01","DB","Grupo de Rateio","Grupo de Rateio","Grupo de Rateio","CW1"})
aAdd(aSXB,{"CW1","2","01","01","Codigo"         ,"Codigo"         ,"Code"           ,""} )
aAdd(aSXB,{"CW1","4","01","01","Codigo"         ,"Codigo"         ,"Code"           ,"CW1_CODIGO"} )
aAdd(aSXB,{"CW1","4","01","02","Descricao"      ,"Descripcion"    ,"Description"    ,"CW1_DESCRI"} )
aAdd(aSXB,{"CW1","4","01","03","Entidade"       ,"Entidad"        ,"Entity"	     ,"CW1_ENTID"} )
aAdd(aSXB,{"CW1","4","01","04","Tipo Grupo"     ,"Tipo Grupo"     ,"Group Type"     ,"CW1_TIPO"} )
aAdd(aSXB,{"CW1","5","01",""  ,""               ,""               ,""               ,"CW1->CW1_CODIGO"} )
aAdd(aSXB,{"CW1","6","01",""  ,""               ,""               ,""               ,'CW1->CW1_SEQUEN=@#"001"'} )

// Consulta para a Amarracao de Grupos de Rateio (CW2)
aAdd(aSXB,{"CW2","1","01","DB","Amarracao Gr Rateio" , "Amarracao Gr Rateio" , "Amarracao Gr Rateio" , "CW2"})
aAdd(aSXB,{"CW2","2","01","01","Cod Amarracao + Stat", "Cod Vinculo + Estatu", "Binding Code + Statu", ""} )
aAdd(aSXB,{"CW2","4","01","01","Cod Amarrac"         , "Cod Vinculo"         , "Binding Code"        , "CW2_CODIGO"} )
aAdd(aSXB,{"CW2","5","01",""  ,""                    , ""                    , ""                    , "CW2->CW2_CODIGO"} )

// Consulta para os Indices Estatisticos de Rateio (CW3)
aAdd(aSXB,{"CW3","1","01","DB","Indices Estatisticos","Indices Estatisticos","Indices Estatisticos","CW3"})
aAdd(aSXB,{"CW3","2","01","01","Codigo"              ,"Codigo"              ,"Code"                ,""} )
aAdd(aSXB,{"CW3","4","01","01","Codigo"              ,"Codigo"              ,"Code"                ,"CW3_CODIGO"} )
aAdd(aSXB,{"CW3","4","01","02","Descricao"           ,"Descripcion"         ,"Description"         ,"CW3_DESCRI"} )
aAdd(aSXB,{"CW3","4","01","03","Entidade"            ,"Entidad"             ,"Entity"              ,"CW3_ENTID"} )
aAdd(aSXB,{"CW3","5","01",""  ,""                    ,""                    ,""                    ,"CW3->CW3_CODIGO"} )
aAdd(aSXB,{"CW3","6","01",""  ,""                    ,""                    ,""                    ,'CW3->CW3_SEQUEN=@#"001"'} )

// Consulta para o campo entidade do cadastro de indices estatisticos (CW3)
aAdd(aSXB,{"CW3CD","1","01","RE","Codigo da Entidade" 	, "Codigo da Entidade" 	, "Codigo da Entidade" 	, "CW3"})
aAdd(aSXB,{"CW3CD","2","01","01",""						, ""					, ""					, "ConPadCW3()"} )
aAdd(aSXB,{"CW3CD","5","01",""  ,""                    , ""                    , ""                    , "M->CW3_CODENT"} )

// -------------------------------------------------------
aAdd(aSXB,{"CTS001","1","01","DB","Indices Estatisticos","Ent. Plano Gerencial","Ent. Plano Gerencial","CTS"})
aAdd(aSXB,{"CTS001","2","01","02","Cod Visao + Entid Ge","Codigo Plan + Entid ","Plan Code + Manag.en",""})
aAdd(aSXB,{"CTS001","4","01","01","Cod Visao           ","Codigo Plan         ","Plan Code           ","CTS_CODPLA"})
aAdd(aSXB,{"CTS001","4","01","02","Entid Gerenc        ","Entid Gerenc        ","Manag.Entity        ","CTS_CONTAG "})
aAdd(aSXB,{"CTS001","4","01","03","Entid Super         ","Entid Sup.          ","Sup.Entity          ","CTS_CTASUP "})
aAdd(aSXB,{"CTS001","4","01","04","Entid Super         ","Entid Sup.          ","Sup.Entity          ","CTS_DESCCG "})
aAdd(aSXB,{"CTS001","5","01",""  ,""                    ,""                    ,""                    ,"CTS->CTS_CONTAG"})
aAdd(aSXB,{"CTS001","6","01",""  ,""                    ,""                    ,""                    ,"CTS->CTS_CODPLA = M->CTS_CODPLA .AND. CTS->CTS_CLASSE='1'"})

// -------------------------------------------------------
aAdd(aSXB,{"CTS002","1","01","DB","Valor Adicionado"    ,"Valor Adicionado"    ,"Valor Adicionado"    ,"CTS"})
aAdd(aSXB,{"CTS002","2","01","02","Cod Visao + Entid Ge","Codigo Plan + Entid ","Plan Code + Manag.en",""})
aAdd(aSXB,{"CTS002","4","01","01","Cod Visao           ","Codigo Plan         ","Plan Code           ","CTS_CODPLA"})
aAdd(aSXB,{"CTS002","4","01","02","Entid Gerenc        ","Entid Gerenc        ","Manag.Entity        ","CTS_CONTAG "})
aAdd(aSXB,{"CTS002","4","01","03","Entid Super         ","Entid Sup.          ","Sup.Entity          ","CTS_CTASUP "})
aAdd(aSXB,{"CTS002","4","01","04","Entid Super         ","Entid Sup.          ","Sup.Entity          ","CTS_DESCCG "})
aAdd(aSXB,{"CTS002","5","01",""  ,""                    ,""                    ,""                    ,"CTS->CTS_CONTAG"})
aAdd(aSXB,{"CTS002","6","01",""  ,""                    ,""                    ,""                    ,"CTS->CTS_CLASSE=='1'"})

// -------------------------------------------------------
aAdd(aSXB,{"SX5SL","1","01","RE","SELECAO SALDOS CTB","SELECAO SALDOS CTB","SELECAO SALDOS CTB","SX5"         })
aAdd(aSXB,{"SX5SL","2","01","01",""                  ,""                  ,""                  ,"CTR560SX5(1)"})
aAdd(aSXB,{"SX5SL","5","01",""  ,""                  ,""                  ,""                  ,"cRetSX5SL"   })

// -------------------------------------------------------
aAdd(aSXB,{"CTB"   ,"1","01","DB","Roteiro Consolidacao","Procedimiento Conso.","Consolidation Proc. ","CTB"})
aAdd(aSXB,{"CTB"   ,"2","01","02","Codigo"              ,"Codigo"              ,"Code"                ,""})
aAdd(aSXB,{"CTB"   ,"4","01","01","Cod Roteiro"         ,"Cod Planejamiento"   ,"Roadmap Code"        ,"CTB_CODIGO "})
aAdd(aSXB,{"CTB"   ,"4","01","02","Empresa Destino"     ,"Empresa Destino"     ,"Target Company"      ,"CTB_EMPDES "})
aAdd(aSXB,{"CTB"   ,"4","01","03","Filial Destino"      ,"Sucursal Destino"    ,"Target Branch"       ,"CTB_FILDES "})
aAdd(aSXB,{"CTB"   ,"4","01","04","Conta Destino"       ,"Cuenta Destino"      ,"Target Account"      ,"CTB_CTADES "})
aAdd(aSXB,{"CTB"   ,"4","01","05","C C Destino"         ,"C C Destino"         ,"Target C.C."         ,"CTB_CCDES  "})
aAdd(aSXB,{"CTB"   ,"4","01","06","Item Destino"        ,"Item Destino"        ,"Target Item"         ,"CTB_ITEMDES"})
aAdd(aSXB,{"CTB"   ,"4","01","07","CLVL Destino"        ,"CLVL Destino"        ,"Target VlCls"        ,"CTB_CLVLDES"})
aAdd(aSXB,{"CTB"   ,"4","01","08","Tipo Saldo Destino"  ,"Tipo Saldo Destino"  ,"Target Balance Type" ,"CTB_TPSLDE "})
aAdd(aSXB,{"CTB"   ,"5","01",""  ,""                    ,""                    ,""                    ,"CTB->CTB_CODIGO"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aSXB,{"CTD001"	,"1","01","DB"	,"Item Contabil"  		,"Item Contable"		,"Accounting Item"		,"CTD"							})
aAdd(aSXB,{"CTD001"	,"2","01","01"	,"Codigo"		 		,"Codigo"				,"Code"					,""					 			})
aAdd(aSXB,{"CTD001"	,"2","02","04"	,"Descricao"	 		,"Descripcion"			,"Description"			,""								})
aAdd(aSXB,{"CTD001"	,"2","03","03"	,"Cod. Reduzido"		,"Cod. Reducido"		,"Reduced Code"			,""								})
aAdd(aSXB,{"CTD001"	,"3","01","01"	,"Cadastra Novo" 		,"Registra Nuevo"		,"Add New"				,"01"							})
aAdd(aSXB,{"CTD001"	,"4","01","01"	,"Codigo"		 		,"Codigo"				,"Code"					,"CTD_ITEM"						})
aAdd(aSXB,{"CTD001"	,"4","01","02"	,"Descricao"	 		,"Descripcion"			,"Description"			,"CTD_DESC01"					})
aAdd(aSXB,{"CTD001"	,"4","02","01"	,"Descricao"	 		,"Descripcion" 			,"Description"			,"CTD_DESC01"					})
aAdd(aSXB,{"CTD001"	,"4","02","02"	,"Codigo"				,"Codigo"				,"Code"					,"CTD_ITEM"						})
aAdd(aSXB,{"CTD001"	,"4","03","01"	,"Cod. Reduzido" 		,"Cod. Reducido"		,"Reduced Code"			,"CTD_RES"						})
aAdd(aSXB,{"CTD001"	,"4","03","02"	,"Descricao"	 		,"Descripcion"			,"Description"			,"CTD_DESC01"					})
aAdd(aSXB,{"CTD001"	,"5","01",""	,""				 		,""						,""						,'"'+'RTrim(CTD->CTD_ITEM)'+'"'	})

aAdd(aSXB,{"CTH001"	,"1","01","DB"	,"Classe Valor"	 		,"Clase Valor"			,"Value Class"			,"CTH"							})
aAdd(aSXB,{"CTH001"	,"2","01","01"	,"Codigo"		 		,"Codigo"				,"Code"					,""	   							})
aAdd(aSXB,{"CTH001"	,"2","02","04"	,"Descricao"	 		,"Descripcion"			,"Description"			,""								})
aAdd(aSXB,{"CTH001"	,"2","03","03"	,"Cod. Reduzido" 		,"Cod. Reducido"		,"Reduced Code"			,""		  						})
aAdd(aSXB,{"CTH001"	,"3","01","01"	,"Cadastra Novo" 		,"Registra Nuevo"		,"Add New"				,"01"							})
aAdd(aSXB,{"CTH001"	,"4","01","01"	,"Codigo"		 		,"Codigo"				,"Code"					,"CTH_CLVL"						})
aAdd(aSXB,{"CTH001"	,"4","01","02"	,"Descricao"  			,"Descripcion"			,"Description"			,"CTH_DESC01"					})
aAdd(aSXB,{"CTH001"	,"4","02","01"	,"Descricao"			,"Descripcion"			,"Description"			,"CTH_DESC01"					})
aAdd(aSXB,{"CTH001"	,"4","02","02"	,"Codigo"  	   			,"Codigo"				,"Code"					,"CTH_CLVL"						})
aAdd(aSXB,{"CTH001"	,"4","03","01"	,"Cod. Reduzido" 		,"Cod. Reducido"		,"Reduced Code"			,"CTH_RES"						})
aAdd(aSXB,{"CTH001"	,"4","03","02"	,"Descricao"			,"Descripcion"			,"Description"			,"CTH_DESC01"					})
aAdd(aSXB,{"CTH001"	,"5","01",""	,""			   			,""						,""						,'"'+'RTrim(CTH->CTH_CLVL)'+'"'	})

aAdd(aSXB,{"CTT001"	,"1","01","DB"	,"Centro Custo"	 		,"Centro Costo"			,"Cost Center"			,"CTT"							})
aAdd(aSXB,{"CTT001"	,"2","01","01"	,"Codigo"				,"Codigo"				,"Code"					,""								})
aAdd(aSXB,{"CTT001"	,"2","02","04"	,"Descricao"			,"Descripcion"			,"Description"			,""								})
aAdd(aSXB,{"CTT001"	,"2","03","03"	,"Cod. Reduzido" 		,"Cod. Reducido"		,"Reduced Code"			,""								})
aAdd(aSXB,{"CTT001"	,"3","01","01"	,"Cadastra Novo"  		,"Registra Nuevo"		,"Add New"				,"#CtbA030Inc"					})
aAdd(aSXB,{"CTT001"	,"4","01","01"	,"Codigo"				,"Codigo"				,"Code"					,"CTT_CUSTO"					})
aAdd(aSXB,{"CTT001"	,"4","01","02"	,"Descricao"			,"Descripcion"			,"Description"			,"CTT_DESC01"					})
aAdd(aSXB,{"CTT001"	,"4","02","01"	,"Descricao"			,"Descripcion"			,"Description"	  		,"CTT_DESC01"					})
aAdd(aSXB,{"CTT001"	,"4","02","02"	,"Codigo"				,"Codigo"				,"Code"					,"CTT_CUSTO"					})
aAdd(aSXB,{"CTT001"	,"4","03","01"	,"Cod. Reduzido"		,"Cod. Reducido"		,"Reduced Code"			,"CTT_RES"						})
aAdd(aSXB,{"CTT001"	,"4","03","02"	,"Descricao"			,"Descripcion"			,"Description"			,"CTT_DESC01"					})
aAdd(aSXB,{"CTT001"	,"5","01",""	,""				  		,""						,""						,"'+RTrim(CTT->CTT_CUSTO)+'"	})

aAdd(aSXB,{"CTTFSB"	,"1","01","RE"	,"Contatos no Assunto"	,"Contactos en Asunto"	,"Contacts in Subject"	,"SX5"							})
aAdd(aSXB,{"CTTFSB"	,"2","01","01"	,""						,""						,""						,"GVA008Cpad(M->FSB_CODCLI)"	})
aAdd(aSXB,{"CTTFSB"	,"5","01",""	,""						,""						,""						,"If(Empty(M->FSB_CODCLI),SU5->U5_CODCONT,AC8->AC8_CODCON)"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim dasTabelas utilizadas para compatibilizacao do SPED com P8 R1   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Consulta para o Codigo de Relacionamento do Participante
aAdd(aSXB,{"016"	,"1","01","RE"	,"Relacionamento"		,"Relacionamento"		,"Relacionamento"		,"SX5"							})
aAdd(aSXB,{"016"	,"2","01","01"	,""              		,""              		,""              		,"a016TabRel()"					})
aAdd(aSXB,{"016"	,"5","01",""  	,""              		,""              		,""              		,"Ctb016Cons()"					})

// Consulta para o Codigo da "Situacao Especial" - utilizado na geracao do SPED Contabil
aAdd(aSXB,{"CTBSP1","1","01","RE","Situacao Esp. - SPED","Situacao Esp. - SPED","Situacao Esp. - SPED","SX5"})
aAdd(aSXB,{"CTBSP1","2","01","01",""                    ,""                    ,""                    ,"SitEsp()"})
aAdd(aSXB,{"CTBSP1","5","01",""  ,""                    ,""                    ,""                    ,"SitEspCons()"})

// Consulta para o Codigo de "Outras Inscricoes" - utilizado na geracao do SPED Contabil
aAdd(aSXB,{"CTBSP2","1","01","RE","Outras Inscr. - SPED","Outras Inscr. - SPED","Outras Inscr. - SPED","SX5"})
aAdd(aSXB,{"CTBSP2","2","01","01",""                    ,""                    ,""                    ,"OutraInscr()"})
aAdd(aSXB,{"CTBSP2","5","01",""  ,""                    ,""                    ,""                    ,"OutraInCons()"})

// Consulta para o Codigo de Participantes (CVC)
aAdd(aSXB,{"CVC","1","01","DB","Participantes","Participantes","Participantes","CVC" })
aAdd(aSXB,{"CVC","2","01","01","Codigo"       ,"Codigo"       ,"Code"         ,"" })
aAdd(aSXB,{"CVC","4","01","01","Descrição"    ,"Descripcion"  ,"Description"  ,"CVC_CODPAR" })
aAdd(aSXB,{"CVC","4","01","02",""             ,""             ,""             ,"CVC_NOME" })
aAdd(aSXB,{"CVC","5","01",""  ,""             ,""             ,""             ,"CVC->CVC_CODPAR" })

// Consulta para Planos Referenciais/Planos
aAdd(aSXB,{"CVN1","1","01","DB" ,"Grupos Planos Refer." ,"Grupos Planos Refer." ,"Grupos Planos Refer." ,"CVN"                                   } )
aAdd(aSXB,{"CVN1","2","01","01" ,"Plano Ref. + Linha"   ,"Plano Ref. + Linha"   ,"Plano Ref. + Linha"   ,""                                      } )
aAdd(aSXB,{"CVN1","4","01","01" ,"Plano Ref."           ,"Plano Ref."           ,"Plano Ref."           ,"CVN_CODPLA"                            } )
aAdd(aSXB,{"CVN1","4","01","02" ,"Descr.P.Ref."         ,"Descr.P.Ref."         ,"Descr.P.Ref."         ,"CVN_DSCPLA"                            } )
aAdd(aSXB,{"CVN1","5","01",""   ,""                     ,""                     ,""                     ,"CVN->CVN_CODPLA"                       } )
aAdd(aSXB,{"CVN1","6","01",""   ,""                     ,""                     ,""                     ,'Val( CVN->CVN_LINHA ) == 1'} )

// Consulta para Planos Referenciais/Itens do plano
aAdd(aSXB,{"CVN2","1","01","DB" ,"Contas Planos Refer."  ,"Contas Planos Refer."  ,"Contas Planos Refer."  ,"CVN"                                   } )
aAdd(aSXB,{"CVN2","2","01","01" ,"Plano Ref + Conta Ref","Plano Ref + Conta Ref","Plano Ref + Conta Ref",""                                      } )
aAdd(aSXB,{"CVN2","4","01","01" ,"Conta Ref."           ,"Conta Ref."           ,"Conta Ref."           ,"CVN_CTAREF"                            } )
aAdd(aSXB,{"CVN2","4","01","02" ,"Descr.C.Ref."         ,"Descr.C.Ref."         ,"Descr.C.Ref."         ,"CVN_DSCCTA"                            } )
aAdd(aSXB,{"CVN2","4","01","03" ,"Dt.Vig.Inic."         ,"Dt.Vig.Inic."         ,"Dt.Vig.Inic."         ,"CVN_DTVIGI"                            } )
aAdd(aSXB,{"CVN2","4","01","04" ,"Dt.Vig.Fim"           ,"Dt.Vig.Fim"           ,"Dt.Vig.Fim"           ,"CVN_DTVIGF"                            } )
aAdd(aSXB,{"CVN2","5","01",""   ,""                     ,""                     ,""                     ,"CVN->CVN_CTAREF"                       } )
aAdd(aSXB,{"CVN2","6","01",""   ,""                     ,""                     ,""                     ,"CVN->CVN_CODPLA = @#cCvdCodPla"        } )

// -------------------------------------------------------
aAdd(aSXB,{"CVL"   ,"1","01","DB","Codigo do diario    " ,"Codigo do diario    " ,"Codigo do diario    " 	,"CVL"})
aAdd(aSXB,{"CVL"   ,"2","01","01","Codigo"              	,"Codigo"             	,"Code"                		,""})
aAdd(aSXB,{"CVL"   ,"2","02","02","Descricao"           	,"Descricao"            ,"Descricao"              	,""})
aAdd(aSXB,{"CVL"   ,"4","01","01","Codigo"         		,"Codigo"   				,"Codigo"        				,"CVL_COD "})
aAdd(aSXB,{"CVL"   ,"4","01","02","Descricao "     	  	,"Descricao "      		,"Descricao "       			,"CVL_DESCR"})
aAdd(aSXB,{"CVL"   ,"4","02","03","Codigo"        			,"Codigo"   				,"Codigo"        				,"CVL_COD "})
aAdd(aSXB,{"CVL"   ,"4","02","04","Descricao "     	 	,"Descricao "      		,"Descricao "     		  ,"CVL_DESCR"})
aAdd(aSXB,{"CVL"   ,"5","01",""  ,""                   	 ,""                    ,""               	     ,"CVL->CVL_COD"})

// Consulta Entidades Contábeis - CV0
aAdd(aSXB,{"CV0","1","01","RE","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0"})
aAdd(aSXB,{"CV0","2","01","01",""                    ,""                    ,""                    	,"CTB050SXB()"})
aAdd(aSXB,{"CV0","5","01",""  ,""                    ,""                    ,""                    	,"CV0->CV0_CODIGO"})

// Consulta Entidades Contábeis - CV01
aAdd(aSXB,{"CV01","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV01","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV01","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV01","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV01","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV01","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV01","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV01","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=cPlano .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CV02
aAdd(aSXB,{"CV02","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV02","2","01","01","Plano Contab + Codig"	,"Plan Contab. + Codig"	,"Account.plan + Code "	,"" 			})
aAdd(aSXB,{"CV02","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV02","4","01","02","Plano Contab        " 	,"Plan Contab.        "	,"Account.Plan        "	,"CV0_PLANO" 	})
aAdd(aSXB,{"CV02","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV02","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO" })
aAdd(aSXB,{"CV02","6","01",""  ,""             			,""             		,""             		,"EMPTY(CV0->CV0_CODIGO)" })

// Consulta Entidades Contábeis - CV05 - Entidade 05
aAdd(aSXB,{"CV05","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV05","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV05","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV05","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV05","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV05","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV05","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV05","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=CTB050PLANO('05') .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CV06 - Entidade 06
aAdd(aSXB,{"CV06","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV06","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV06","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV06","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV06","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV06","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV06","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV06","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=CTB050PLANO('06') .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CV07 - Entidade 07
aAdd(aSXB,{"CV07","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV07","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV07","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV07","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV07","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV07","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV07","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV07","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=CTB050PLANO('07') .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CV08 - Entidade 08
aAdd(aSXB,{"CV08","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV08","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV08","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV08","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV08","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV08","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV08","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV08","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=CTB050PLANO('08') .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CV09 - Entidade 09
aAdd(aSXB,{"CV09","1","01","DB","Entidade Contabil   ","Entidad Contable    ","Account Entities"		,"CV0" 			})
aAdd(aSXB,{"CV09","2","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"" 			})
aAdd(aSXB,{"CV09","4","01","01","Filial              "  ,"Sucursal            " ,"Branch              " ,"CV0_FILIAL" 	})
aAdd(aSXB,{"CV09","4","01","02","Codigo"       			,"Codigo"       		,"Code"         		,"CV0_CODIGO" 	})
aAdd(aSXB,{"CV09","4","01","03","Descricao           "	,"Descripcion         "	,"Description         "	,"CV0_DESC" 	})
aAdd(aSXB,{"CV09","4","01","04","Classe              "	,"Clase               "	,"Class               "	,"CV0_CLASSE" 	})
aAdd(aSXB,{"CV09","5","01",""  ,""             			,""             		,""             		,"CV0->CV0_CODIGO" })
aAdd(aSXB,{"CV09","6","01",""  ,""             			,""             		,""             		,"CV0->CV0_PLANO=CTB050PLANO('09') .AND. !EMPTY(CV0->CV0_CODIGO) .AND. CV0->CV0_CODIGO<>cCodigo" })

// Consulta Entidades Contábeis - CT0
aAdd(aSXB,{"CT0","1","01","DB","Entidades contabeis","Entidades Contables","Account Entities","CT0"        })
aAdd(aSXB,{"CT0","2","01","01","Item"               ,"Item"               ,"Item"            ,""           })
aAdd(aSXB,{"CT0","4","01","01","ID"                 ,"ID"                 ,"ID"              ,"CT0_ID"     })
aAdd(aSXB,{"CT0","4","01","02","Descricao"          ,"Descripcion"        ,"Description"     ,"CT0_DESC"   })
aAdd(aSXB,{"CT0","5","01",""  ,""                   ,""                   ,""                ,"CT0->CT0_ID"})

//
// Consulta CT0SX3
//
aAdd( aSXB, {'CT0SX3','1','01',	'RE','Campos Cad. de Ativo','Campos Arch. Activo','','SX3'} )
aAdd( aSXB, {'CT0SX3','2','01',	'01','','','','CT0F3SX3()'} )
aAdd( aSXB, {'CT0SX3','5','01','','','','','CT0SX3->X3_CAMPO'} )

// Consulta ECD - Layout de Diarios - CSV
aAdd(aSXB,{"CSV","1","01","DB","ECD - Layout Diarios" 	,"ECD - Layout Diarios ","ECD - Layout Diarios"	,"CSV" 			})
aAdd(aSXB,{"CSV","2","01","01","Cod. Layout"	,"Cod. Layout"	,"Cod. Layout"	,"" 			})
aAdd(aSXB,{"CSV","4","01","01","Cod. Layout         "  ,"Cod. Layout		  " ,"Cod. Layout		"   ,"CSV_CODLAY" 	})
aAdd(aSXB,{"CSV","4","01","02","Descricao	        " 	,"Descricao		      "	,"Descricao        "	,"CSV_DESCRI" 	})
aAdd(aSXB,{"CSV","5","01",""  ,""             			,""             		,""             		,"CSV->CSV_CODLAY" })
// Consulta ECD - Fato Contabil - CSN
aAdd(aSXB,{"CSN","1","01","DB","ECD - Fatos Contabeis" 	,"ECD - Fatos Contabeis"	,"ECD - Fatos Contabeis"	,"CSN" 			})
aAdd(aSXB,{"CSN","2","01","01","Filial + Cod. Revisao"	,"Filial + Cod. Revisao"	,"Filial + Cod. Revisao"	,"" 			})
aAdd(aSXB,{"CSN","4","01","01","Cod.Fato Ctb"  			,"Cod.Fato Ctb" 			,"Cod.Fato Ctb"   			,"CSN_CODFAT" 	})
aAdd(aSXB,{"CSN","4","01","02","Descricao	        " 	,"Descricao		      "		,"Descricao        "		,"CSN_DESFAT" 	})
aAdd(aSXB,{"CSN","5","01",""  ,""             			,""             			,""             	  		,"CSN->CSN_CODFAT" })
aAdd(aSXB,{"CSN","6","01",""  ,""             			,""             			,""             	  		,"CSN_FILIAL==XFILIAL('CSN') .And. CSN_CODREV == CS0->CS0_CODREV .And. CSN_REG = 'J200'" })

// Consulta ECD - Entid.Gerenc.DMPL/DLPA utilizado em Detalhe do Fato Contabil - CSO
aAdd(aSXB,{"CTS003","1","01","DB","Entid.Gerenc.DMPL/DLPA"	,"Entid.Gerenc.DMPL/DLPA"	,"Entid.Gerenc.DMPL/DLPA"	,"CTS" 			})
aAdd(aSXB,{"CTS003","2","01","01","Filial + Cod. Revisao"	,"Filial + Cod. Revisao"	,"Filial + Cod. Revisao"	,"" 			})
aAdd(aSXB,{"CTS003","4","01","01","Entid Gerenc"  			,"Entid Gerenc" 			,"Entid Gerenc"   			,"CTS_CONTAG" 	})
aAdd(aSXB,{"CTS003","4","01","02","Desc Ent Ger" 			,"Desc Ent Ger"				,"Desc Ent Ger"				,"CTS_DESCCG" 	})
aAdd(aSXB,{"CTS003","5","01",""  ,""             			,""             			,""             	  		,"ECDGetDMPL()+CTS->CTS_CONTAG" })
aAdd(aSXB,{"CTS003","6","01",""  ,""             			,""             			,""             	  		,"CTS_FILIAL==XFILIAL('CTS') .And. CTS_CODPLA==ECdGetDMPL() .And. CTS_CLASSE == '2'" })
//Consulta CW0LP
If FindFunction("CW0RETSZ")
	aAdd( aSXB, {'CW0LP','1','01','DB','Dt Apuracäo L/P CW0','Dt Apuracäo L/P CW0','Dt Apuracäo L/P CW0','CW0'} )
	aAdd( aSXB, {'CW0LP','2','01','01','Data','Fecha','Date',''} )
	aAdd( aSXB, {'CW0LP','4','01','01','Data Apuracao','Data Apuracao','Data Apuracao','CW0SXBDTLP()'} )
	aAdd( aSXB, {'CW0LP','4','01','02','Moeda','Moneda','Moeda','CW0SXBMOED()'} )
	aAdd( aSXB, {'CW0LP','4','01','03','Tipo de Saldo','Tipo de Saldo','Tipo de Saldo','CW0SXBTPSL()'} )
	aAdd( aSXB, {'CW0LP','5','01','','','','','CW0RETSZ()'} )
	aAdd( aSXB, {'CW0LP','6','01','','','','','CW0FLTSZ()'} )
	
	//Consulta SX5LP
	aAdd( aSXB, {'SX5LP','1','01','DB','Dt Apuracäo L/P SX5','Dt Apuracäo L/P SX5','Dt Apuracäo L/P SX5','SX5'} )
	aAdd( aSXB, {'SX5LP','2','01','01','Data','Fecha','Data',''} )
	aAdd( aSXB, {'SX5LP','4','01','01','Data Apuracao','Data Apuracao','Data Apuracao','CTBSXBDTLP()'} )
	aAdd( aSXB, {'SX5LP','4','01','02','Moeda','Moneda','Moeda','CTBSXBMOED()'} )
	aAdd( aSXB, {'SX5LP','4','01','03','Tipo de Saldo','Tipo de Saldo','Tipo de Saldo','CTBSXBTPSL()'} )
	aAdd( aSXB, {'SX5LP','5','01','','','','','CTBRETSZ()'} )
	aAdd( aSXB, {'SX5LP','6','01','','','','','LP CTBFLTSZ()'} )
	
	//Consulta CTZ - Alteração
	aAdd( aSXB, {'CTZ','1','01','RE','Data Apuracäo L/P','Data Apuracäo L/P','Data Apuracäo L/P','SX5'} )
	aAdd( aSXB, {'CTZ','2','01','01','','','','CW0LPSXB()'} )
	aAdd( aSXB, {'CTZ','5','01','  ','','','','CW0RETLP()'} )
	
	dbSelectArea("SXB")
	dbSetOrder(1)
	
	If SXB->(dbSeek(PadR("CTZ", Len(SXB->XB_ALIAS))+'1'+'01')) .And. Alltrim(SXB->XB_COLUNA) != "RE"
		While SXB->(!EOF()) .AND. ALLTRIM(SXB->XB_ALIAS) == "CTZ"
			RecLock("SXB",.F.)
			dbDelete()
			dbCommit()
			MsUnLock()
			SXB->(dbSkip())
		End
	EndIf
	
EndIf
If cPaisLoc == "COL"
	// Consulta tabela de Contatos Municipios - CC2
	Aadd(aSXB,{"CC2SA1","1","01","DB","Municipios clientes","Municipios clientes","Customer City","CC2"})
	Aadd(aSXB,{"CC2SA1","2","01","01","Estado + Municipio","Estado + Municipio","State + City",""}) 
	Aadd(aSXB,{"CC2SA1","2","02","02","Municipio","Municipio","City",""})
	Aadd(aSXB,{"CC2SA1","4","01","01","Estado","Estado","State","CC2_EST"})
	Aadd(aSXB,{"CC2SA1","4","01","02","Municipio","Municipio","City","CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA1","4","01","03","Desc. Mun.","Desc. Mun.","City Desc.","CC2_MUN"})
	Aadd(aSXB,{"CC2SA1","4","02","04","Estado","Estado","State","CC2_EST"})
	Aadd(aSXB,{"CC2SA1","4","02","05","Municipio","Municipio","City","CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA1","4","02","06","Desc. Mun.","Desc. Mun.","City Desc.","CC2_MUN"})
	Aadd(aSXB,{"CC2SA1","5","01","","","","","CC2->CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA1","6","01","","","","","CC2->CC2_EST==M->A1_EST"})   
		
	// Consulta tabela de Contatos Municipios - CC2
	Aadd(aSXB,{"CC2SA2","1","01","DB","Municipios Forneced.","Municipios Proveedor","Supplier City","CC2"})
	Aadd(aSXB,{"CC2SA2","2","01","01","Estado + Municipio","Estado + Municipio","State + City",""}) 
	Aadd(aSXB,{"CC2SA2","2","02","02","Municipio","Municipio","City",""})
	Aadd(aSXB,{"CC2SA2","4","01","01","Estado","Estado","State","CC2_EST"})
	Aadd(aSXB,{"CC2SA2","4","01","02","Municipio","Municipio","City","CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA2","4","01","03","Desc. Mun.","Desc. Mun.","City Desc.","CC2_MUN"})
	Aadd(aSXB,{"CC2SA2","4","02","04","Estado","Estado","State","CC2_EST"})
	Aadd(aSXB,{"CC2SA2","4","02","05","Municipio","Municipio","City","CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA2","4","02","06","Desc. Mun.","Desc. Mun.","City Desc.","CC2_MUN"})
	Aadd(aSXB,{"CC2SA2","5","01","","","","","CC2->CC2_CODMUN"})
	Aadd(aSXB,{"CC2SA2","6","01","","","","","CC2->CC2_EST==M->A2_EST"})   

	// Consulta tabela de Contatos Municipios - CC2
	aAdd(aSXB,{"CC2CVC","1","01","DB","Municipios Contatos"		,"Municipios Contactos"		,"Contact Cities"	,"CC2" 			})
	aAdd(aSXB,{"CC2CVC","2","01","02","Codigo do Estado"		,"Codigo Departamento"		,"State Code"		,"" 			})
	aAdd(aSXB,{"CC2CVC","2","02","02","Municipio"				,"Municipio"				,"City" 	   		,""			 	})
	aAdd(aSXB,{"CC2CVC","4","01","01","Estado"					,"Estado"					,"State"			,"CC2_EST"		})
	aAdd(aSXB,{"CC2CVC","4","01","02","Codigo do Estado"		,"Codigo Departamento"		,"State Code"		,"CC2_CODMUN"	})
	aAdd(aSXB,{"CC2CVC","4","02","03","Municipio"				,"Municipio"				,"City" 			,"CC2_MUN"	 	})
	aAdd(aSXB,{"CC2CVC","4","02","04","Estado"					,"Estado"					,"State"			,"CC2_EST"		})
	aAdd(aSXB,{"CC2CVC","4","02","05","Codigo do Estado"		,"Codigo Departamento"		,"State Code"  		,"CC2_CODMUN"	})
	aAdd(aSXB,{"CC2CVC","4","02","06","Municipio"				,"Municipio"				,"City" 			,"CC2_MUN"	 	})
	aAdd(aSXB,{"CC2CVC","5","01",""  ,""             		    ,""             			,""             	,"CC2->CC2_CODMUN"})
	aAdd(aSXB,{"CC2CVC","6","01",""  ,""             		    ,""             			,""             	,"CC2->CC2_EST==M->CVC_UF" })
	
	// Consulta tabela de Países - SYA
	aAdd(aSXB,{"SYA","1","01","DB","Paises              "	,"Paises              " ,"Countries			  "	,"SYA" 			})
	aAdd(aSXB,{"SYA","2","01","02","Descrição			"	,"Descripción 		  "	,"Description		  "	,"" 			})
	aAdd(aSXB,{"SYA","3","01","01","Cadastra Novo       "  	,"Registra Nuevo      " ,"Add New             " ,"01"		 	})
	aAdd(aSXB,{"SYA","4","01","01","Descrição			"	,"Descripción 		  "	,"Description		  "	,"YA_DESCR"		})
	aAdd(aSXB,{"SYA","4","01","02","Codigo	            "	,"Codigo		      "	,"Code			      "	,"YA_CODGI" 	})
	aAdd(aSXB,{"SYA","4","02","01","Codigo	            "	,"Codigo		      "	,"Code			      "	,"YA_CODGI" 	})
	aAdd(aSXB,{"SYA","4","02","02","Descrição			"	,"Descripción 		  "	,"Description		  "	,"YA_DESCR"		})
	aAdd(aSXB,{"SYA","5","01",""  ,""             		    ,""             		,""             		,"SYA->YA_CODGI" })
	
	// Consulta CW0TER
	aAdd( aSXB, {'CW0TER','1','01','RE','Tipos de terceiros','Tipos de terceros','Third Party Type','CW0'} )
	aAdd( aSXB, {'CW0TER','2','01','01','','','',"CW0CONS('C1','01')"} )
	aAdd( aSXB, {'CW0TER','5','01','','','','','CW0->CW0_CHAVE'} )
EndIf

//

/*EXEMPLO AJUSTE SXB
Aadd(aSXB,{"AJ8","1","01","DB","Consulta Gerencial","Consulta Gerencial","Consulta Gerencial","AJ8"})
Aadd(aSXB,{"AJ8","2","01","03","Codigo+Entidade Superior","Codigo+Entidade Superior","Codigo+Entidade Superior",""})
Aadd(aSXB,{"AJ8","4","01","01","Codigo","Codigo","Codigo","AJ8_CODPLA"})
Aadd(aSXB,{"AJ8","4","01","02","Codigo da Entidade","Codigo da Entidade","Codigo da Entidade","AJ8_CONTAG"})
Aadd(aSXB,{"AJ8","5","","","","","","AJ8->AJ8_CONTAG"})
Aadd(aSXB,{"AJ8","6","01","01","","","","PmsAJ8F3()"})
*/
/*
ou assim quando for para ajustar somente um campo
aAdd(aAjSXB, {"AL1","4","01","03",{"XB_CONTEM", "AL1_DESCRI"}})
*/
/*
ou assim quando for para remover uma opcao de um SXB existente

aAdd(aDelSXB,{"AL1","3","01","01"})
*/

aAdd(aDelSXB,{"CW1","3","01","01"}) // Opcao de inclusao de grupo via F3
aAdd(aDelSXB,{"CW2","3","01","01"}) // Opcao de inclusao de amarracao via F3
aAdd(aDelSXB,{"CW3","3","01","01"}) // Opcao de inclusao de indice via F3

//excluindo cunsulta padrão pois já esta no SX5 Caio Quiqueto dos Santos
aAdd(aDelSXB,{"TB","1","01","DB"})
aAdd(aDelSXB,{"TB","2","01","01"})
aAdd(aDelSXB,{"TB","4","01","01"})
aAdd(aDelSXB,{"TB","4","01","02"})
aAdd(aDelSXB,{"TB","4","01","03"})
aAdd(aDelSXB,{"TB","5","01","  "})
aAdd(aDelSXB,{"TB","6","01","  "})

ProcRegua(Len(aSXB))

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			lSXB := .T.
			If !(aSXB[i,1]$cAlias)
				cAlias += aSXB[i,1]+"/"
			EndIf
			
			RecLock("SXB",.T.)
			
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc(STR0042) // //"Atualizando Consultas Padroes..."
		EndIf
	EndIf
Next i

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aAjSXB)
	If !Empty(aAjSXB[i][1])
		If dbSeek(PadR(aAjSXB[i,1], Len(SXB->XB_ALIAS))+aAjSXB[i,2]+aAjSXB[i,3]+aAjSXB[i,4])
			If Upper(AllTrim(FieldGet(FieldPos(aAjSXB[i,5,1])))) # Upper(AllTrim(aAjSXB[i,5,2]))
				lSXB := .T.
				If !(aAjSXB[i,1]$cAlias)
					cAlias += aAjSXB[i,1]+"/"
				EndIf
				RecLock("SXB",.F.)
				If !Empty(FieldName(FieldPos(aAjSXB[i,5,1])))
					FieldPut(FieldPos(aAjSXB[i,5,1]),aAjSXB[i,5,2])
				EndIf
				dbCommit()
				MsUnLock()
				IncProc(STR0042) // //"Atualizando Consultas Padroes..."
			EndIf
		EndIf
	EndIf
Next i

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aDelSXB)
	If !Empty(aDelSXB[i][1])
		If dbSeek(PadR(aDelSXB[i,1], Len(SXB->XB_ALIAS))+aDelSXB[i,2]+aDelSXB[i,3]+aDelSXB[i,4])
			RecLock("SXB",.F.)
			dbDelete()
			dbCommit()
			MsUnLock()
			IncProc(STR0042) // //"Atualizando Consultas Padroes..."
		EndIf
	EndIf
Next i

// Atualizacao pontual dos campo X3_F3 afetados pela inclusao das novas consultas
CTBAtuX3F3()

If lSXB
	cTexto := STR0043+cAlias+CRLF //'Consultas Padroes Atualizadas : '
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³CTBATUSXG ³ Autor   ³ Eduardo Nunes Cirqueir³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Funcao de processamento da gravacao do SXG                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBATUSXG()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto := ''
Local lSXG   := .F.
Local lNew   := .F.
Local aSXG   := {}
Local aSX1	 := {}
Local aSX3	 := {}
Local aEstrut:= {}
Local i,j,nX := 0
Local nTamCpo:= 6
Local cAlias := ''

aEstrut := {"XG_GRUPO","XG_DESCRI","XG_DESSPA","XG_DESENG","XG_SIZEMAX","XG_SIZEMIN","XG_SIZE","XG_PICTURE"}

// Grupo de Campos
Aadd(aSXG,{"027","Codigo do Plano Referencial","Codigo do Plano Referencial","Codigo do Plano Referencial",40,30,30,"@!"})
Aadd(aSXG,{"028","Rateios Off-Line","Rateios Off-Line","Rateios Off-Line",6,12,6,"@!"})

//Exemplo aSX1:
//Aadd(aSX1,{"","",""}) // GRUPOSX1,ORDEM,GRUPOSXG

Aadd(aSX1,{"CTB270","01","028"})
Aadd(aSX1,{"CTB270","02","028"})
Aadd(aSX1,{"CTB280","06","028"})
Aadd(aSX1,{"CTB280","07","028"})
Aadd(aSX1,{"CTB281","07","028"})
Aadd(aSX1,{"CTB281","08","028"})

// Grupo de Campos dos Tipos de Saldos
aAdd( aSXG, { "029", "Tipos de Saldos", "Tipos de Saldos", "Tipos de Saldos", 6, 12, 6, "@!" } )

// Definicao do tamanho minimo para as entidades contabeis
Do Case
	Case cPaisLoc == "COL"
		nTamCpo := 15
	Case cPaisLoc == "PER"
		nTamCpo := 16
	OtherWise
		nTamCpo := 6
EndCase
aAdd(aSXG,{"040","Entidade Contábil 05","Ente Contable 05","Accounting Entity 05",20,6,nTamCpo,"@!"})
aAdd(aSXG,{"042","Entidade Contábil 06","Ente Contable 06","Accounting Entity 06",20,6,nTamCpo,"@!"})
aAdd(aSXG,{"043","Entidade Contábil 07","Ente Contable 07","Accounting Entity 07",20,6,nTamCpo,"@!"})
aAdd(aSXG,{"044","Entidade Contábil 08","Ente Contable 08","Accounting Entity 08",20,6,nTamCpo,"@!"})
aAdd(aSXG,{"045","Entidade Contábil 09","Ente Contable 09","Accounting Entity 09",20,6,nTamCpo,"@!"})

//Exemplo aSX3:
//Aadd(aSX3,{"",""}) // CAMPO,GRUPOSXG

ProcRegua(Len(aSXG))
dbSelectArea("SXG")
dbSetOrder(1)

For i:= 1 To Len(aSXG)
	If !Empty(aSXG[i,1])
		If !dbSeek(aSXG[i,1])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf
		If lNew
			lSXG := .T.
			RecLock("SXG",lNew)
			For j:=1 To Len(aSXG[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSXG[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
		IncProc(STR0053)  //"Atualizando grupos de campos..."
	EndIf
Next i

dbSelectArea("SX1")
dbSetOrder(1)
For nx := 1 to Len(aSX1)
	If dbSeek(aSX1[nx][1]+aSX1[nx][2])
		RecLock("SX1",.F.)
		SX1->X1_GRPSXG := aSX1[nx][3]
		MsUnlock()
	EndIf
Next

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aSX3)
	If dbSeek(aSX3[nx][1])
		RecLock("SX3",.F.)
		SX3->X3_GRPSXG := aSX3[nx][2]
		MsUnlock()
	EndIf
Next

If lSXG
	cTexto += STR0054+cAlias+CRLF  // "Grupos de Campos Atualizados: "
EndIf

Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBOpenSM0 ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 16/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza abertura do SIGAMAT.EMP de forma exclusiva             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBOpenSM0()

Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea(.T., , "SIGAMAT.EMP", "SM0", .T., .F.)
	If !Empty(Select("SM0"))
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep(500)
Next nLoop

If !lOpen
	Aviso( STR0001, STR0046 , {STR0047}, 2)		//"Atencao!"###"Nao foi possivel a abertura da tabela de empresas de forma exclusiva!"###"Finalizar"
EndIf

Return lOpen

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDCTBHI  ºAutor  ³ Acacio Egas        º Data ³  03/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste do campo Historico do CT2.                          º±±
±±º          ³ Retira os caratreres CHR(13) E CHR(10).                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function updct_x()

#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On

If !CTBOpenSM0()
	
	Return
	
EndIf

DbGoTop()

lHistorico := MsgYesNo("Rotina de Ajuste das inconsistencias no Historrico Inteligente."+CRLF+"Confirma a operacao ?",;
"Contabilidade Gerencial - Ajuste de Historico Inteligente")

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,1 TITLE "Atualizacao do Dicionario"

ACTIVATE WINDOW oMainWnd ICONIZED;
ON INIT If(lHistorico,(Processa({|lEnd| AjustHist(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.F.) , oMainWnd:End()),oMainWnd:End())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDCTBHI  ºAutor  ³ Acacio Egas        º Data ³  03/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste do campo Historico do CT2.                          º±±
±±º          ³ Retira os caratreres CHR(13) E CHR(10).                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ U_UPDCTBHI                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustHist()

Local _cEmpAtu := ''
Local cTexto   := ''
Local cFile    :=""
Local cMask    := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno   := 0
Local nX       :=0
Local nRecAtu
Local aAreaSM0
Local dIni,dFim
Local nCFil		:= 0
Local aSM0		:= {}

Private __cInternet
Private cArqEmp := "SigaMat.Emp"

ProcRegua(1)
IncProc("Verificando integridade dos dicionarios....")

OpenSm0Excl()
aSM0 := AdmAbreSM0()

For nCFil := 1 to Len(aSM0)
	RpcSetType(3)
	RpcSetEnv(aSM0[nCFil][SM0_GRPEMP], aSM0[nCFil][SM0_CODFIL] )
	
	RpcClearEnv()
	OpenSm0Excl()
Next nCFil

dbSelectArea("SM0")
dbGotop()
For nCFil := 1 to Len(aSM0)
	
	RpcSetType(3)
	RpcSetEnv(aSM0[nCFil][SM0_GRPEMP], aSM0[nCFil][SM0_CODFIL],,,,, { "SX1","CT2" })
	
	If dIni==nil .or. dFim==nil
		PutSx1( "UPDHI", "01", "Data de ?" , "", "", "mv_ch1", "D",8,0,0,"G",""	,""	,""	,""	,"mv_par01"	,"","","","","","","","","","","","","","","","" )
		PutSx1( "UPDHI", "02", "Data Ate?" , "", "", "mv_ch2", "D",8,0,0,"G",""	,""	,""	,""	,"mv_par02"	,"","","","","","","","","","","","","","","","" )
		
		__cInternet := nil
		Pergunte("UPDHI",.T.)
		__cInternet := "AUTOMATICO"
		
		dIni	:= MV_PAR01
		dFim    := MV_PAR02
	Endif
	
	// Caso a tabela CT2 esteja compartilhada ajusta por empresa
	If _cEmpAtu=='' .or. _cEmpAtu <> aSM0[nCFil][SM0_GRPEMP]
		
		cTexto += Replicate("-",128)+CRLF
		cTexto += STR0011+aSM0[nCFil][SM0_GRPEMP]+STR0012+aSM0[nCFil][SM0_CODFIL]+"-"+aSM0[nCFil][SM0_NOME]+CRLF //"Empresa : "###" Filial : "
		ProcRegua(8)
		
		DbSelectArea("CT2")
		DbSetOrder(1)
		DbSeek(xFilial("CT2"))
		
		Do While CT2->(!Eof())
			
			If CT2->(CT2_FILIAL+DTOS(CT2_DATA)) >= xFilial("CT2")+DTOS(MV_PAR01) .and.;
				CT2->(CT2_FILIAL+DTOS(CT2_DATA)) <= xFilial("CT2")+DTOS(MV_PAR02)
				
				If AT(CHR(13),CT2->CT2_HIST)>0 .and. AT(CHR(10),CT2->CT2_HIST)>0
					
					RecLock("CT2",.F.)
					
					CT2->CT2_HIST	:= StrTran( StrTran( CT2->CT2_HIST,CHR(13)," ") ,CHR(10)," ")
					cTexto += "Lote : "+CT2->CT2_LOTE + " Sub-Lote : " + CT2->CT2_SBLOTE + " Documento : " + CT2->CT2_DOC + " Item : " + CT2->CT2_LINHA + CRLF
					
					MsUnlock()
					
				Endif
				
			Endif
			
			CT2->(DbSkip())
		EndDo
		
		If Alltrim(xFilial("CT2")) == ''
			_cEmpAtu := aSM0[nCFil][SM0_GRPEMP]
		EndIf
	EndIf
	
Next nCFil

RpcSetEnv(aSM0[1][SM0_GRPEMP], aSM0[1][SM0_CODFIL],,,,, { "CT2" })


cTexto := "Log da atualizacao "+CRLF+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL


ACTIVATE MSDIALOG oDlg CENTER

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBAtuPymeºAutor  ³Alvaro Camillo Neto º Data ³  10/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta o Pyme dos campos do CTB                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuPyme()
Local lPyme 	:=  GetPvProfString("GENERAL","PYME","0",GetAdv97()) == "1"
Local aTabelas := {}
Local aPergunt	:= {}
Local nX			:= 0
Local cTexto	:= ""
Local aAreaSX1	:= SX1->(GetArea())
Local aAreaSX2	:= SX2->(GetArea())
Local aAreaSX3	:= SX3->(GetArea())

SX1->(dbSetOrder(1)) //X1_GRUPO + X1_ORDEM
SX2->(dbSetOrder(1)) //X2_CHAVE
SX3->(dbSetOrder(1)) //X3_ARQUIVO + X3_ORDEM

If lPyme
	aADD(aTabelas,"CT")
	aADD(aTabelas,"CW")
	aADD(aTabelas,"CV")
	aADD(aPergunt,"CTB")
	aADD(aPergunt,"CTR")
	aADD(aPergunt,"CTC")
	aADD(aPergunt,"CTA")
	
	//Ajusta SX1 para PYME = 'S"
	For nX := 1 to Len(aPergunt)
		SX1->(dbSeek(aPergunt[nX] , .F. ))
		While  Left(SX1->X1_GRUPO,3) == aPergunt[nX]  .And. SX1->(!EOF())
			If SX1->X1_PYME != "S"
				RecLock("SX1",.F.)
				SX1->X1_PYME := "S"
				MsUnlock()
				cTexto := STR0059 //"Atualizando Pyme dos Campos"
			EndIf
			SX1->(dbSkip())
		EndDo
	Next nX
	
	//Ajusta SX2 para PYME = 'S"
	For nX := 1 to Len(aTabelas)
		SX2->(dbSeek(aTabelas[nX] , .F. ))
		While  Left(SX2->X2_CHAVE,2) == aTabelas[nX]  .And. SX2->(!EOF())
			If SX2->X2_PYME != "S"
				RecLock("SX2",.F.)
				SX2->X2_PYME := "S"
				MsUnlock()
				cTexto := STR0059 //"Atualizando Pyme dos Campos"
			EndIf
			SX2->(dbSkip())
		EndDo
	Next nX
	
	//Ajusta SX3 para PYME = 'S"
	For nX := 1 to Len(aTabelas)
		SX3->(dbSeek(aTabelas[nX] , .F. ))
		While  Left(SX3->X3_ARQUIVO,2) == aTabelas[nX]  .And. SX3->(!EOF())
			If SX3->X3_PYME != "S"
				RecLock("SX3",.F.)
				SX3->X3_PYME := "S"
				MsUnlock()
				cTexto := STR0059 //"Atualizando Pyme dos Campos"
			EndIf
			SX3->(dbSkip())
		EndDo
	Next nX
	
	
	
EndIf

RestArea(aAreaSX3)
RestArea(aAreaSX2)
RestArea(aAreaSX1)


Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuX3F3³ Autor ³ ----------------------- ³ Data ³ 30/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do campo X3_F3            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuX3F3()

Local aSX3	 := {}
Local nX	 := 0

AADD(aSX3,{ "CT0_ENTIDA"	,"CV0"})
AADD(aSX3,{ "CT2_EC05DB"	,"CV0"})
AADD(aSX3,{ "CT2_EC05CR"	,"CV0"})
AADD(aSX3,{ "CT5_EC05DB"	,"CV0"})
AADD(aSX3,{ "CT5_EC05CR"	,"CV0"})
AADD(aSX3,{ "CV0_ENTSUP"	,"CV0"})
AADD(aSX3,{ "CV0_LUCPER"	,"CV0"})
AADD(aSX3,{ "CV0_PONTE"		,"CV0"})

dbSelectArea("SX3")
dbSetOrder(2)
For nx := 1 to Len(aSX3)
	If SX3->(dbSeek(aSX3[nx][1])) .And. Empty(SX3->X3_F3)
		RecLock("SX3",.F.)
		SX3->X3_F3 := aSX3[nx][2]
		MsUnlock()
	EndIf
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
		IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
		"",;
		"",;
		"",;
		SM0->M0_NOME,;
		SM0->M0_FILIAL }
		
		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )
Return aRetSM0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³TamSXG ³ Autor ³ Alvaro Camillo Neto  	³ Data ³ 14/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função que retorna tamanho do campo                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbTamSXG(cGrupo,nTamPad)
Local nSize := 0

DbSelectArea("SXG")
DbSetOrder(1)

IF DbSeek(cGrupo)
	nSize := SXG->XG_SIZE
Else
	nSize := nTamPad
Endif

Return nSize

Static Function CTBUpdField(cAlias, nOrder, cIndexKey, cField, uNewValue, uTestValue, bBlockValue)
Local aArea       := (cAlias)->(GetArea())
Local lRet        := .F.
Local nFieldPos   := 0
Local aStruct     := {}
Local nPosField   := 0
Local uValueField := 0

dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(nOrder))

// verifica se o registro existe no alias
If !(cAlias)->(dbSeek(cIndexKey))
	RestArea(aArea)
	Return lRet
EndIf

// verificar se o campo existe no alias
nFieldPos := (cAlias)->(FieldPos(cField))

If nFieldPos == 0
	RestArea(aArea)
	Return lRet
EndIf

aStruct := (cAlias)->(dbStruct())
nPosFIELD := aScan( aStruct ,{|aField|Alltrim(Upper(aField[1])) == Alltrim(Upper(cField)) } )
uValueField := (cAlias)->(FieldGet(nFieldPos))

If bBlockValue == Nil
	
	// teste por valor
	If uTestValue == Nil
		
		If nPosFIELD >0
			If aStruct[nPosFIELD][2] == "C"
				uValueField := AllTrim(uValueField)
				uTestValue  := AllTrim(uNewValue)
			EndIf
		EndIf
		
		// Somente atualiza se o valor gravado no campo (uValueField) for diferente do novo valor (uNewValue)
		lRet := !(uValueField == uTestValue)
		
		If lRet
			RecLock(cAlias, .F.)
			(cAlias)->(FieldPut(nFieldPos, uNewValue))
			MsUnlock()
		EndIf
		
		RestArea(aArea)
		
	Else
		
		If nPosFIELD >0
			// se for caracter deve retirar os brancos e maiusculas antes de comparar.
			If aStruct[nPosFIELD][2] == "C"
				uValueField := AllTrim(Upper(uValueField))
				uTestValue  := AllTrim(Upper(uTestValue))
			EndIf
		EndIf
		
		// se o teste existe, testa e altera o valor
		If uTestValue == uValueField
			RecLock(cAlias, .F.)
			(cAlias)->(FieldPut(nFieldPos, uNewValue))
			MsUnlock()
			
			RestArea(aArea)
			lRet := .T.
		EndIf
	EndIf
Else
	// teste por bloco - nao implementado
EndIf

RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbFilOri ºAutor  ³Microsiga           º Data ³  04/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Preenche o campo CT2_FILORI que estavam truncados por conta º±±
±±º          ³de updctb com problema no passado em modo gestao corporat.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CtbFilOri(cEmpAnt, cFilAnt)
Local cLayoutEmp 	:= FWSM0Layout()
Local lGestao		:= Iif( lFWCodFil, ( "E" $ cLayoutEmp .And. "U" $ cLayoutEmp ), .F. )	// Indica se usa Gestao Corporativa
Local aModoCompCT2 	:= {}
Local cQuery
Local lMessage 		:= .F.

#IFDEF TOP
	Local lDefTop := .T.
#ELSE
	Local lDefTop := .F.
#ENDIF

If lGestao
	
	lDefTop := lDefTop .And. TcSrvType() <> "AS/400"
	
	aAdd(aModoCompCT2, FWModeAccess("CT2",1) )
	aAdd(aModoCompCT2, FWModeAccess("CT2",2) )
	aAdd(aModoCompCT2, FWModeAccess("CT2",3) )
	
	dbSelectArea("CT2")
	dbSetOrder(1)
	If dbSeek(xFilial("CT2"))
		
		If Len(Alltrim(cFilAnt)) <> Len(Alltrim(CT2_FILORI))
			
			If Type('lMsHelpAuto') <> 'U'
				lMessage := lMsHelpAuto
				lMsHelpAuto := .F.
			EndIf
			
			If nRetAviso < 3
				nRetAviso := Aviso(STR0001, STR0011+cEmpant+STR0012+cFilAnt+CRLF+;  //"Atencao"##"Empresa: "##" Filial: "
				STR0060+CRLF+;  //" Campo CT2_FILORI incompleto. Deseja Compatiblizar ? (Este processo pode demorar varios minutos)"
				STR0061+CRLF+;  //"Sim - Atualiza Empresa/Filial "
				STR0062+CRLF+;  //"Nao - Nao Atualiza Empresa/Filial "
				STR0063+CRLF+;  //"Sim p/ Todas - Atualiza todas Empresas/Filiais "
				STR0064, ;      //"Nao p/ Todas - Nao Atualiza Nenhuma empresa/Filial "
				{STR0065, STR0066, STR0067, STR0068})  //"Sim"##"Nao"##"Sim p/ Todas "##"Nao p/ Todas"
			EndIf
			
			If nRetAviso == 1 .OR. nRetAviso == 3
				lCompFilOri := .T.
			Else
				lCompFilOri := .F.
			EndIf
			
			If Type('lMsHelpAuto') <> 'U'
				lMsHelpAuto := lMessage
			EndIf
			
			If lCompFilOri
				
				If 		aModoCompCT2[1]+aModoCompCT2[2]+aModoCompCT2[3] == 'EEE'  //tudo exclusivo
					//copiar conteudo CT2_FILIAL para CT2_FILORI
					If lDefTop
						cQuery := " UPDATE "
						cQuery += " "+RetSqlName("CT2")
						cQuery += " SET CT2_FILORI = CT2_FILIAL"
						cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"'"
						cQuery += " AND D_E_L_E_T_ = ' '"
						
						If TcSqlExec(cQuery) <> 0
							
							UserException(STR0069  ;  //"Erro na selecao de movimentos contabeis"
							+ CRLF + STR0070+ CRLF + TCSqlError() )  //"Processo cancelado..."
							lRet	:=	.F.
							
						Endif
					Else
						dbSelectArea("CT2")
						While CT2->( !Eof() .And. CT2_FILIAL = xFilial("CT2") )
							RecLock("CT2", .F.)
							CT2->CT2_FILORI := CT2->CT2_FILIAL
							MsUnLock()
							CT2->( dbSkip() )
						EndDo
						
					EndIf
					
				Else 	//aModoCompCT2[1]+aModoCompCT2[2]+aModoCompCT2[3] == 'EEC' // empresa unid negocio exclusivo filial compartilhada
					//aModoCompCT2[1]+aModoCompCT2[2]+aModoCompCT2[3] == 'ECC' // empresa exclusivo unid negocio filial compartilhada
					//aModoCompCT2[1]+aModoCompCT2[2]+aModoCompCT2[3] == 'CCC' // tudo compartilhado
					//gravar 1a. filial dentro da empresa e unid negocio
					If aScan(aFilProc, cEmpAnt+xFilial("CT2") ) == 0
						If lDefTop
							cQuery := " UPDATE "
							cQuery += " "+RetSqlName("CT2")
							cQuery += " SET CT2_FILORI = '"+cFilAnt+"' "
							cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"'"
							cQuery += " AND D_E_L_E_T_ = ' '"
							
							If TcSqlExec(cQuery) <> 0
								
								UserException(STR0069  ;  //"Erro na selecao de movimentos contabeis"
								+ CRLF + STR0070+ CRLF + TCSqlError() )  //"Processo cancelado..."
								lRet	:=	.F.
								
							Endif
						Else
							dbSelectArea("CT2")
							dbSetOrder(1)
							dbSeek(xFilial("CT2"))
							
							While CT2->( !Eof() .And. CT2_FILIAL = xFilial("CT2") )
								RecLock("CT2", .F.)
								CT2->CT2_FILORI := cFilAnt
								MsUnLock()
								CT2->( dbSkip() )
							EndDo
							
						EndIf
						aAdd(aFilProc, cEmpAnt+xFilial("CT2"))
					EndIf
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
EndIf

Return
