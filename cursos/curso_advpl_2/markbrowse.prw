///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarkBrw()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Demonstra a utilizacao da funcao MarkBrow()                     |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+----------------------------------------------------------------------------
| Parâmetros do MarkBrow()
+----------------------------------------------------------------------------
| MarkBrow( cAlias, cCampo, cCpo, aCampos, lInverte, cMarca, cCtrlM, uPar, 
|            cExpIni, cExpFim, cAval )
+----------------------------------------------------------------------------
| MarkBrow chama MarkBrowse que chama a classe MsSelect()
+----------------------------------------------------------------------------
| cAlias...: Alias do arquivo a ser exibido no browse 
| cCampo...: Campo do arquivo onde será feito o controle (gravação) da marca
| cCpo.....: Campo onde será feita a validação para marcação e exibição do bitmap de status
| aCampos..: Colunas a serem exibidas
| lInverte.: Inverte a marcação
| cMarca...: String a ser gravada no campo especificado para marcação
| cCtrlM...: Função a ser executada caso deseje marcar todos elementos
| uPar.....: Parâmetro reservado
| cExpIni..: Função que retorna o conteúdo inicial do filtro baseada na chave de índice selecionada
| cExpFim..: Função que retorna o conteúdo final do filtro baseada na chave de índice selecionada
| cAval....: Função a ser executada no duplo clique em um elemento no browse
+----------------------------------------------------------------------------
*/

#Include "Protheus.Ch"

User Function MarkBrw()
//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local aCpos   := {}
Local aCampos := {}
Local nI      := 0

Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := "Exemplo da MarkBrowse"
Private cPerg       := "MARK01"

//+----------------------------------------------------------------------------
//| Monta tela de interacao com usuario
//+----------------------------------------------------------------------------
aAdd(aSay,"Este programa exemplifica a utilização da função MarkBrow() ou MarkBrowse()")
aAdd(aSay,"que utiliza a classe de objeto MsSelect")

aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})

//FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
FormBatch(cCadastro,aSay,aButton)

//+----------------------------------------------------------------------------
//| Se cancelar sair
//+----------------------------------------------------------------------------
If nOpcao <> 1
   Return
Endif

//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Data Emissao de    ? 99/99/99               |
//| mv_par02 - Data Emissao ate   ? 99/99/99               |
//| mv_par03 - Forncedor de       ? 999999                 |
//| mv_par04 - Fornecedor ate     ? 999999                 |
//| mv_par05 - Filtrar            ? Todos/Manutenção       |
//+--------------------------------------------------------+
//+----------------------------------------------------------------------------
//| Cria as perguntas em SX1
//+----------------------------------------------------------------------------
CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
If !Pergunte(cPerg,.T.)
   Return
Endif

//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()" ,0,1})
aAdd( aRotina ,{"Marcar"    ,"u_Marcar()" ,0,3})
aAdd( aRotina ,{"Legenda"   ,"u_xLegend()",0,4})
             
//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"F1_OK","F1_DOC","F1_SERIE","F1_FORNECE","F1_LOJA","F1_EMISSAO","F1_VALBRUT","F1_TIPO"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
Next

//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
dbSelectArea("SF1")
cKey  := IndexKey()
cFiltro := "Dtos(F1_EMISSAO) >= '"+Dtos(mv_par01)+"' .And. "
cFiltro += "Dtos(F1_EMISSAO) <= '"+Dtos(mv_par02)+"' .And. "
cFiltro += "F1_FORNECE >= '"+mv_par03+"' .And. "
cFiltro += "F1_FORNECE <= '"+mv_par04+"' "
If mv_par05 == 2
   cFiltro += ".And. Empty(F1_REMITO)"
Endif
cArq := CriaTrab( Nil, .F. )
IndRegua("SF1",cArq,cKey,,cFiltro)
nIndex := RetIndex("SF1")
nIndex := nIndex + 1
dbSelectArea("SF1")
#IFNDEF TOP
   dbSetIndex(cArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex)
dbGoTop()

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario se houver dados
//+----------------------------------------------------------------------------
If !EOF() .And. !BOF()
	cMarca := GetMark()
	MarkBrow("SF1","F1_OK","SF1->F1_REMITO",aCampos,(mv_par06==1),cMarca,"u_OMarcaBox(1)",,,,"u_OMarcaBox(2)")
Else
	MsgInfo("Não há dados para apresentar. Verifique os parâmetros.")
Endif

//+----------------------------------------------------------------------------
//| Desfaz o indice e filtro temporario
//+----------------------------------------------------------------------------
dbSelectArea("SF1")
RetIndex("SF1")
Set Filter To
cArq += OrdBagExt()
FErase( cArq )
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_OMarcaBox()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Marca ou desmarca o registro para processamento                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function OMarcaBox(nOpc)

If nOpc == 1 // Marcar todos
	dbSelectArea("SF1")
	dbGoTop()
	While !EOF()
		RecLock("SF1",.F.)
		SF1->F1_OK := Iif(SF1->F1_OK==cMarca,"",cMarca)
		MsUnLock()
		dbSkip()
	End
	dbGoTop()
Elseif nOpc == 2  // Marcar somente o registro posicionado
	RecLock("SF1",.F.)
	SF1->F1_OK := Iif(SF1->F1_OK==cMarca,"",cMarca)
	MsUnLock()
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Marcar()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Transfere os registros marcados                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Marcar()

If MsgYesNo("Confirma a marcação?",cCadastro)
	dbSelectArea("SF1")
	dbGoTop()
	While !Eof()
		If SF1->F1_OK <> cMarca
			dbSkip()
			Loop
		Endif
		RecLock("SF1",.F.)
		SF1->F1_REMITO := "S"
		MsUnLock()
		dbSkip()
	End
Endif

Return 

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Legenda()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria legenda para usuario identificar os registros              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function xLegend()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"NF Não Transferida"})
aAdd(aCor,{"BR_VERMELHO","NF Transferida"    })

BrwLegenda(cCadastro,"Status dos Registros",aCor)

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria o grupo de perguntas se caso nao existir                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local aP := {}
Local i := 0
Local cSeq
Local cMvCh
Local cMvPar
Local aHelp := {}

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
       cOrdem,;
       cPergunt,cPerSpa,cPerEng,;
       cVar,;
       cTipo,;
       nTamanho,;
       nDecimal,;
       nPresel,;
       cGSC,;
       cValid,;
       cF3,;
       cGrpSxg,;
       cPyme,;
       cVar01,;
       cDef01,cDefSpa1,cDefEng1,;
       cCnt01,;
       cDef02,cDefSpa2,cDefEng2,;
       cDef03,cDefSpa3,cDefEng3,;
       cDef04,cDefSpa4,cDefEng4,;
       cDef05,cDefSpa5,cDefEng5,;
       aHelpPor,aHelpEng,aHelpSpa,;
       cHelp)

Característica do vetor p/ utilização da função SX1
---------------------------------------------------
[n,1] --> texto da pergunta
[n,2] --> tipo do dado
[n,3] --> tamanho
[n,4] --> decimal
[n,5] --> objeto G=get ou C=choice
[n,6] --> validacao
[n,7] --> F3
[n,8] --> definicao 1
[n,9] --> definicao 2
[n,10] -> definicao 3
[n,11] -> definicao 4
[n,12] -> definicao 5
***/

aAdd(aP,{"Emissao de"                ,"D",8,0,"G",""                    ,""   ,""   ,""   ,"","",""})
aAdd(aP,{"Emissao ate"               ,"D",8,0,"G","(mv_par02>=mv_par01)",""   ,""   ,""   ,"","",""})
aAdd(aP,{"Fornecedor de"             ,"C",6,0,"G",""                    ,"SA2",""   ,""   ,"","",""})
aAdd(aP,{"Fornecedor ate"            ,"C",6,0,"G","(mv_par04>=mv_par03)","SA2",""   ,""   ,"","",""})
aAdd(aP,{"Mostrar todos os registros","N",1,0,"C",""                    ,""   ,"Sim","Nao","","",""})
aAdd(aP,{"Trazer marcados"           ,"N",1,0,"C",""                    ,""   ,"Sim","Nao","","",""})

aAdd(aHelp,{"Informe a data de emissão incial."})
aAdd(aHelp,{"Informe a data de emissão final."})
aAdd(aHelp,{"Digite o código do fornecedor incial."})
aAdd(aHelp,{"Digite o código do fornecedor final."})
aAdd(aHelp,{"Mostrar todos os registros, independente","de ter sido já processado."})
aAdd(aHelp,{"Trazer todos os registros ","marcados, sim ou não?"})

For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	cMvPar := "mv_par"+cSeq
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	{},;
	"")
Next i

Return