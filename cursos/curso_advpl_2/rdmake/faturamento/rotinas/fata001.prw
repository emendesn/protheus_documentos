#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATA001  บAutor  ณMicrosiga           บ Data ณ  24/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de manutencao em Romaneios.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH DO BRASIL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATA001()
// Atribuicao de variaveis
Local aArea     	:= {}
Local cFiltro   	:= ""
Local cKey      	:= ""
Local cArq      	:= ""
Local nIndex    	:= 0
Local aSay      	:= {}
Local aButton   	:= {}
Local nOpcao    	:= 0
Local cDesc1    	:= "Este programa tem o objetivo de Gerar Romaneios de entregas para as "
Local cDesc2    	:= "Transportadoras."
Local cDesc3    	:= ""
Local aCpos     	:= {}
Local aCampos   	:= {}
Local cMsg      	:= ""
Local _cQuery   	:= ""
Local _cArqTrab 	:= CriaTrab(,.F.)
Private aRotina   	:= {}
Private cMarca    	:= ""
Private cCadastro 	:= OemToAnsi("Controle de Romaneio")
Private cPerg    	:= "FATA01"
Private nTotal    	:= 0
Private cArquivo 	:= ""

u_GerA0003(ProcName())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Cria dicionario de perguntas  - Alterado Paulo Francisco - 19/05/10  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
fCriaSX1(cPerg)

If !Pergunte(cPerg,.T.)     
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtribui as variaveis de funcionalidades                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aRotina, {"Parametros"     ,"U_Paramet(.T.)",0,1})
aAdd( aRotina ,{"Gerar Romaneio" ,"U_GrvRoman()" ,0,3})
aAdd( aRotina ,{"Estornar Rom."  ,"U_EstRoman()" ,0,3})
aAdd( aRotina ,{"Imprimir"       ,"U_Fatr001()"  ,0,3})
aAdd( aRotina ,{"Legenda"        ,"U_LegRoman()" ,0,4})
aAdd( aRotina ,{"Marcar Todos"   ,"U_MDRoma(.T.)" ,0,4})
aAdd( aRotina ,{"Des. Todos"     ,"U_MDRoma(.F.)" ,0,4})
aAdd( aRotina ,{"Data Saida Doca" ,"U_saidoca()" ,0,4})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtribui as variaveis os campos que aparecerao no mBrowse()           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCpos := {"F2_XROMA","F2_TRANSP","F2_NRROMA","F2_DTROMA","F2_DOC","F2_SERIE","F2_CLIENTE","F2_LOJA","F2_EMISSAO","F2_SAIROMA","F2_HSAIROM"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
	dbSeek(aCpos[nI])
	aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta funcao para ifico para MarkBrow()                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_Paramet(.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApresenta o MarkBrowse para o usuario                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
| MarkBrow( cAlias, cCampo, cCpo, aCampos, lInverte, cMarca, cCtrlM, uPar,
|           cExpIni, cExpFim, cAval )
+----------------------------------------------------------------------------
| cAlias...: Alias do arquivo a ser exibido no browse
| cCampo...: Campo do arquivo onde serแ feito o controle (grava็ใo) da marca
| cCpo.....: Campo onde serแ feita a valida็ใo para marca็ใo e exibi็ใo do bitmap de status
| aCampos..: Colunas a serem exibidas
| lInverte.: Inverte a marca็ใo
| cMarca...: String a ser gravada no campo especificado para marca็ใo
| cCtrlM...: Fun็ใo a ser executada caso deseje marcar todos elementos
| uPar.....: Parโmetro reservado
| cExpIni..: Fun็ใo que retorna o conte๚do inicial do filtro baseada na chave de ํndice selecionada
| cExpFim..: Fun็ใo que retorna o conte๚do final do filtro baseada na chave de ํndice selecionada
| cAval....: Fun็ใo a ser executada no duplo clique em um elemento no browse
*/
cMarca := GetMark()
MarkBrow("TRB", "F2_XROMA", "TRB->F2_NRROMA", aCampos,, cMarca, ,,,, "U_BoxRoma()")
TRB->(dbCloseArea())
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BoxRoma()

If IsMark("F2_XROMA",cMarca )
	nRecno := TRB->Registro
	RecLock("TRB",.F.)
	TRB->F2_XROMA := Space(2)
	MsUnLock()
	DBSelectArea("SF2")
	DBGoto(nRecno)
	RecLock("SF2",.F.)
	SF2->F2_XROMA := Space(2)
	MsUnLock()
	DBSelectArea("TRB")
Else
	If Empty(TRB->F2_NRROMA)
		nRecno := TRB->Registro
		RecLock("TRB",.F.)
		TRB->F2_XROMA := cMarca
		MsUnLock()
		DBSelectArea("SF2")
		DBGoto(nRecno)
		RecLock("SF2",.F.)
		SF2->F2_XROMA := cMarca
		MsUnLock()
		DBSelectArea("TRB")
	EndIf
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvRoman()
Local cMsg   := "Nota fiscal marcada:"+Chr(10)+Chr(13)+"Pre/N๚mero"+Chr(10)+Chr(13)
Local aNotas := {}
Private aNF  := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGuarda os dados chave de todas as Notas Fiscais marcadas             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	If TRB->F2_XROMA <> cMarca .or. !Empty(TRB->F2_NRROMA)
		dbSkip()
		Loop
	Endif
	aAdd(aNotas,  TRB->F2_SERIE + "/" + TRB->F2_DOC )
	aAdd(aNF	, {TRB->F2_TRANSP, TRB->F2_DOC + TRB->F2_SERIE + TRB->F2_CLIENTE + TRB->F2_LOJA})
	dbSkip()
EndDo
cMsg := OemToAnsi("Confirma gera็ใo do Romaneio para as Notas Fiscais marcadas?")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSolicita a confirmacao das Notas Fiscais                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aNotas)>0
	If apMsgYesNo(cMsg,"Confirma็ใo")
		TelaRoma()
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LegRoman()

Local aCor := {}
aAdd(aCor,{"BR_VERDE"   ,"NF Sem Romaneio"})
aAdd(aCor,{"BR_VERMELHO","NF Com Romaneio"})
BrwLegenda(cCadastro,OemToAnsi("Romaneio"),aCor)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MDRoma(lMarca)

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	If !Empty(TRB->F2_NRROMA)
		dbSkip()
		Loop
	EndIf
	If lMarca
		RecLock("TRB",.F.)
		TRB->F2_XROMA := cMarca
		MsUnLock()
	Else
		RecLock("TRB",.F.)
		TRB->F2_XROMA := Space(2)
		MsUnLock()
	EndIf
	dbSkip()
EndDo
dbGoTop()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ok_GrvRoma( aNF )

Local aNFs      := {}
Local nI        := 0
Local cFilTRB   := xFilial("TRB")
Local cMsg      := ""
Local nGrv      := 0
Local nItem     := 0

aNFs := aClone( aNF )
aNFs := aSort( aNFs,,,{|x,y| x[1] < y[1] } )
_cTransp := aNFs[1,1]

dbSelectArea("TRB")
dbGoTop()
nI := 1
While !Eof()

	If TRB->F2_XROMA <> cMarca .Or. !Empty(TRB->F2_NRROMA)
		dbSkip()
		Loop
	Endif
	
	nRecno  := TRB->Registro
	nRecTRB := TRB->(recno())

	// Posiciona no SF2 e Grava informacao do Romaneio
	DBSelectArea("SF2")
	DBGoto(nRecno)
	if empty(SF2->F2_NRROMA)
		RecLock("SF2",.F.)
		SF2->F2_NRROMA := _cNumRoma
		SF2->F2_DTROMA := dDataBase
		MsUnLock()

		// Grava no TRB
		DBSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->F2_NRROMA := _cNumRoma
		TRB->F2_DTROMA := dDataBase
		MsUnLock()
	else
		// Atualiza TRB com dados do Romaneio ja existente
		DBSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->F2_NRROMA := SF2->F2_NRROMA
		TRB->F2_DTROMA := SF2->F2_DTROMA
		MsUnLock()
	endif

	_cTransp := aNFs[nI,1]
	nI++
	TRB->(dbGoTo(nRecTRB))
	TRB->(DBSkip())

EndDo

If _cNumRoma = _cNumRAnt
	If SX6->(dbSeek(Space(2)+"MV_XROMA"))
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := Soma1(_cNumRoma)
		MsUnlock()
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  09/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ      Rotina para estornar Romaneio !                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EstRoman()

local _cUpdate := ""

If !Empty(TRB->F2_NRROMA)

	If apMsgYesNo("Confirma estorno do romaneio da Nota Fiscal posicionada?","Estorno de Romaneio" )

		_cNRRoma := TRB->F2_NRROMA
		nRecno   := TRB->Registro

		// Posiciona no SF2 e Grava informa็ใo do Romaneio
		DBSelectArea("SF2")
		DBGoto(nRecno)
		RecLock("SF2",.F.)
		SF2->F2_XROMA  := Space(2)
		SF2->F2_NRROMA := Space(6)
		SF2->F2_DTROMA := ctod("  /  /  ")
		SF2->F2_SAIROMA:= ctod("  /  /  ") //Alterado, Uiran Almeida 22.10.13 - Zera a Data de Saํda do Romaneio Chamado ID - 15 777
		SF2->F2_HSAIROM:= ""				//Alterado, Uiran Almeida 22.10.13 - Zera a Hora de Saํda do Romaneio Chamado ID - 15 777		
		MsUnLock()
                                                                          
		// Grava no TRB
		DBSelectArea("TRB")
		Reclock("TRB",.F.)
		TRB->F2_XROMA  := Space(2)
		TRB->F2_NRROMA := Space(6)
		TRB->F2_DTROMA := ctod("  /  /  ")
		TRB->F2_SAIROMA:= ctod("  /  /  ")	//Alterado,	Uiran Almeida 22.10.13 Zera a Data de Saํda do Romaneio Chamado	ID - 15 777
		TRB->F2_HSAIROM:= ""				//Alterado, Uiran Almeida 22.10.13 Zera a Hora de Saํda do Romaneio Chamado	ID - 15 777
		MsUnlock()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Limpa campos referentes a saida da doca na nova            ณ
		//ณ entrada massiva (ZZ4).                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		// Limpa campos de data e hora de saida da doca no arquivo ZZ4 para NF de retorno de aparelho
		ZZ4->(dbSetOrder(5)) // ZZ4_FILIAL + ZZ4_NFSNR  + ZZ4_NFSSER + ZZ4_IMEI
		if ZZ4->(dbSeek(xFilial("ZZ4") + SF2->F2_DOC + SF2->F2_SERIE))
			while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_NFSNR == SF2->F2_DOC .and. ZZ4->ZZ4_NFSSER == SF2->F2_SERIE
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_DOCDTS := ctod("  /  /  ")
				ZZ4->ZZ4_DOCHRS := ""
				msunlock()
				ZZ4->(dbSkip())
			enddo
		endif
		// Limpa campos de data e hora de saida da doca no arquivo ZZ4 para NF de SWAP
		ZZ4->(dbSetOrder(6)) // ZZ4_FILIAL + ZZ4_SWNFNR + ZZ4_SWNFSE + ZZ4_SWAP	
		if ZZ4->(dbSeek(xFilial("ZZ4") + SF2->F2_DOC + SF2->F2_SERIE))
			while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. ZZ4->ZZ4_SWNFNR == SF2->F2_DOC .and. ZZ4->ZZ4_SWNFSE == SF2->F2_SERIE
				reclock("ZZ4",.f.)
				ZZ4->ZZ4_SWSADC := ctod("  /  /  ")
				msunlock()
				ZZ4->(dbSkip())
			enddo
		endif

		ApMsgInfo("Romaneio estornado com sucesso."," Estorno do Romaneio ")

	EndIf

Else
	apMsgInfo("Apenas Notas Fiscais com Romaneio podem ser estornadas. Selecione outra NF para efetuar o estorno.","Estorno nใo permitido")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  10/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Paramet(_lPerg)
Local _cArqTrab := CriaTrab(,.F.)
If _lPerg
	Pergunte(cPerg,.T.)
	TRB->(dbCloseArea())
EndIf
_cQuery := " Select F2_FILIAL, F2_XROMA, F2_TRANSP, F2_NRROMA, F2_DTROMA,F2_SAIROMA,F2_HSAIROM, F2_DOC, "
_cQuery += " F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, R_E_C_N_O_ As Registro "
_cQuery += " FROM "+RetSqlName("SF2") + " (nolock) "
_cQuery += " Where F2_FILIAL='"+xFilial("SF2")+"' AND F2_EMISSAO Between '"+Dtos(mv_par07)+"' AND '"+Dtos(mv_par08)+"' "
_cQuery += " AND   F2_TRANSP  Between '"+     mv_par01 +"' AND '"+     mv_par02 +"' "
_cQuery += " AND   F2_DOC     Between '"+ AllTrim(mv_par03) +"' AND '"+     AllTrim(mv_par04) +"' "
_cQuery += " AND   F2_SERIE   Between '"+     mv_par05 +"' AND '"+     mv_par06 +"' "
_cQuery += " AND   F2_CLIENTE Between '"+     mv_par10 +"' AND '"+     mv_par11 +"' "
If mv_par09 == 2  		// Com Romaneio
	_cQuery += " AND F2_NRROMA <> '' "
ElseIf mv_par09 == 3  	// Sem Romaneio
	_cQuery += " AND F2_NRROMA =  '' "
EndIf
_cQuery += " AND D_E_L_E_T_ <> '*' "
_cQuery += " ORDER BY F2_FILIAL, F2_DOC, F2_SERIE "

MemoWrite("fata001.sql", _cQuery )

// Executa a Query com o Filtro
DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQuery), "TRA", .T., .T.)
TcSetField("TRA","F2_EMISSAO" ,"D")
TcSetField("TRA","F2_DTROMA"  ,"D")     
TcSetField("TRA","F2_SAIROMA"  ,"D")

DBSelectArea("TRA")
TRA->(DBGotop())                                  
        
//Incluso - Edson Rodrigues em 08/09/08
if Select("TRB") > 0                               
	TRB->(dbCloseArea())
endif
// Copia para o Arquivo de Trabalho para permitir alteracao no arquivo temporario criado
Copy To &_cArqTrab
dbUseArea(.T.,,_cArqTrab,"TRB",.F.,.F.)
//IndRegua( "TRB", _cArqTrab, "F2_NRROMA + F2_DOC + F2_SERIE",,, )
IndRegua( "TRB", _cArqTrab, "F2_DOC + F2_SERIE + F2_NRROMA",,, )

TRA->(dbCloseArea())

//Conta a quantidade de registros
//SetRegua(TRB->(RecCount()))
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATA001   บAutor  ณMicrosiga           บ Data ณ  12/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaRoma()

Private oDlg
Private oV1,oV2
Private _cNumRoma := GetMV("MV_XROMA")
Private _cNumRAnt := GetMV("MV_XROMA")

@ 000,000 TO 180,450 DIALOG oDlg TITLE "Gera็ใo de Romaneio"
@ 015,010 SAY "Caro usuแrio. Confirme a gera็ใo de novo Romaneio com o n๚mero informado, "
@ 025,010 SAY "ou informe o n๚mero de um Romaneio jแ existente para adicionar novas NFs. "
@ 060,010 GET _cNumRoma 	SIZE 050,013
@ 060,110 BUTTON "OK"		    SIZE 040,013 ACTION {Processa({|| WndConfirma() })}
@ 060,160 BUTTON "CANCELA"	SIZE 040,013 ACTION Close(oDlg)

Activate MSDialog oDlg Centered
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO6     บAutor  ณMicrosiga           บ Data ณ  10/30/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function WndConfirma()
If _cNumRoma <= _cNumRAnt
	Ok_GrvRoma( aNF )
	Close(oDlg)
Else
	Alert("Nใo pode ser informado um N๚mero de Romaneio maior que o N๚mero Atual.")
EndIf
return                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณsaidoca   บAutor   Edson Rodrigues     บ Data ณ  24/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava a data de saida da Doca no SF2                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function saidoca()

Local _dtsaida:=Ddatabase 
Local _hrsaida:=SPACE(8)
Local _cNumRoma := GetMV("MV_XROMA")
Local cStartPath := GetPvProfString( GetEnvServer(), "StartPath", "ERROR", GetADV97() )

If mv_par09 == 1 .OR. mv_par09 == 2
    oFnt1  := TFont():New("Arial",08,14,,.T.,,,,.T.,.F.)   
	@ 0,0 TO 260,250 DIALOG oDlg TITLE "Grava data de Saํda da Doca"
	oBmp := TBitmap():New( 00, 00, 50, 50,NIL, cStartPath+"BGHSMALL.bmp",.T.,oDlg)
	@ 10,010 SAY oV1 var "Informe o Numero do Romaneio:" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
	@ 20,010 GET _cNumRoma Size 50,080 PICTURE "@!" 
	@ 35,010 SAY oV2 var "Informe a data de saida da doca :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE   
	@ 45,010 GET _dtsaida Size 30,050 Picture "99/99/99" VALID !Empty(_dtsaida) .and. valdoca(_dtsaida) 
    @ 60,010 SAY oV3 var "Informe a Hora de saida da doca :" of oDlg FONT oFnt1 PIXEL SIZE 155,010 COLOR CLR_BLUE
    @ 70,010 GET _hrsaida Size 30,050 Picture "@R 99:99:99" VALID !Empty(_hrsaida) .and. _hrsaida < "240000" .and. _hrsaida >= "000000" .and. substr(_hrsaida,3,2) < "60" .and. substr(_hrsaida,5,2) < "60"
	@ 82,020 BMPBUTTON TYPE 1 ACTION Processa({|| xConfirma(_cNumRoma,_dtsaida,_hrsaida,oDlg) })
	@ 82,050 BMPBUTTON TYPE 2 ACTION Close(oDlg)
	Activate MSDialog oDlg Centered
	
Else	
  	Alert("Informe nos parametros iniciais romaneios gerados igual a sim ou todos ")
Endif  	

Return                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxconfirma บAutor: ณRodrigues           บ Data ณ  24/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava a data de saida da Doca no SF2                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xConfirma(_cNumRoma,_dtsaida,_hrsaida)

local _aAreaZZ4 := ZZ4->(GetArea())
local _aAreaSD2 := SD2->(GetArea())

ZZ4->(dbSetOrder(1))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_OS
SD2->(dbSetOrder(3))  // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA

dbSelectArea("TRB")
TRB->(dbGoTop())

	While !TRB->(Eof()) //.and. TRB->F2_NRROMA == _cNumRoma
	
	 	// Posiciona no SF2 e Grava informacao do Romaneio
		DBSelectArea("SF2")
		SF2->(DBGoto(TRB->Registro))
		if !empty(SF2->F2_NRROMA) .AND. alltrim(SF2->F2_NRROMA) == alltrim(_cNumRoma)

			RecLock("SF2",.F.)
			SF2->F2_SAIROMA := _dtsaida
			SF2->F2_HSAIROM := _hrsaida
			MsUnLock()
	
			// Grava no TRB
			DBSelectArea("TRB")
			RecLock("TRB",.F.)
			 TRB->F2_SAIROMA := _dtsaida 
			 TRB->F2_HSAIROM := _hrsaida 
		 	MsUnLock()
	
			// Grava data e hora de saida da doca no arquivo ZZ4 para NF de retorno de aparelho
			ZZ4->(dbSetOrder(5)) // ZZ4_FILIAL + ZZ4_NFSNR  + ZZ4_NFSSER + ZZ4_IMEI
			if ZZ4->(dbSeek(xFilial("ZZ4") + AllTrim(SF2->F2_DOC) + SF2->F2_SERIE))
				while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. AllTrim(ZZ4->ZZ4_NFSNR) == AllTrim(SF2->F2_DOC) .and. ZZ4->ZZ4_NFSSER == SF2->F2_SERIE
					reclock("ZZ4",.f.)
					ZZ4->ZZ4_DOCDTS := SF2->F2_SAIROMA
					ZZ4->ZZ4_DOCHRS := SF2->F2_HSAIROM
					msunlock()
					ZZ4->(dbSkip())
				enddo
			endif

			// Grava data e hora de saida da doca no arquivo ZZ4 para NF de SWAP
			ZZ4->(dbSetOrder(6)) // ZZ4_FILIAL + ZZ4_SWNFNR + ZZ4_SWNFSE + ZZ4_SWAP	
			if ZZ4->(dbSeek(xFilial("ZZ4") + AllTrim(SF2->F2_DOC) + SF2->F2_SERIE))
				while ZZ4->(!eof()) .and. ZZ4->ZZ4_FILIAL == xFilial("ZZ4") .and. AllTrim(ZZ4->ZZ4_SWNFNR) == AllTrim(SF2->F2_DOC) .and. ZZ4->ZZ4_SWNFSE == SF2->F2_SERIE
					reclock("ZZ4",.f.)
//					ZZ4->ZZ4_SWSADC := AllTrim(SF2->F2_SAIROMA)
					ZZ4->ZZ4_SWSADC := SF2->F2_SAIROMA
					msunlock()
					ZZ4->(dbSkip())
				enddo
			endif

		else
			// Atualiza TRB com dados do Romaneio ja existente
			DBSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->F2_DTROMA := SF2->F2_DTROMA
			MsUnLock()
		endif
	    TRB->(DBSkip())
	EndDo      

//endif

restarea(_aAreaZZ4)
restarea(_aAreaSD2)

oDlg:End()

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvaldoca   บAutor   Edson Rodrigues     บ Data ณ  24/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a data de saida da Doca                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function Valdoca(_dtsaida)
local _lRet    := .t.
local _cusdoca :=GETMV('MV_UDTDOCA')

If _cusdoca $ __cUserID
	   _lRet := .t.
Else                                                                                  
	   _lRet := dDataBase-_dtsaida<=1 .and. dDataBase>=_dtsaida
Endif                                             
                                                                                              
If !_lRet
   Aviso('Data da Doca','Data da Doca nao pode ser inferior ou maior que um dia da data do sistema, peca para um usuario autorizado mudar ou contate o administrador do sistema',{'OK'})  
Endif

return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIASX1  บ Autor ณPaulo Lopez         บ Data ณ  18/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGERA DICIONARIO DE PERGUNTAS                                บฑฑ
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
Static Function fCriaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Declaracao de variaveis                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

PutSX1(cPerg,"01","Da Transportadora		?","","","mv_ch1","C",06,0,0,"G","","SA4"	,"","mv_par01",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate a Transportadora		?","","","mv_ch2","C",06,0,0,"G","","SA4"	,"","mv_par02",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Da Nota Fiscal			?","","","mv_ch3","C",09,0,0,"G","","SF2"	,"","mv_par03",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate a Nota Fiscal		?","","","mv_ch4","C",09,0,0,"G","","SF2"	,"","mv_par04",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Da Serie					?","","","mv_ch5","C",03,0,0,"G","",""	 	,"","mv_par05",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Ate a Serie				?","","","mv_ch6","C",03,0,0,"G","",""	 	,"","mv_par06",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Da Emissao				?","","","mv_ch7","D",08,0,0,"G","",""	 	,"","mv_par07",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Ate a Emissao			?","","","mv_ch8","D",08,0,0,"G","",""	 	,"","mv_par08",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Apresentar NF			?","","","mv_ch9","N",01,0,0,"C","",""	 	,"","mv_par09",,"Todas","","","","Com Romaneio","","","Sem Romaneio",,"","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Cliente De				?","","","mv_chA","C",06,0,0,"G","","SA1" 	,"","mv_par10",,"","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Cliente Ate				?","","","mv_chB","C",06,0,0,"G","","SA1" 	,"","mv_par11",,"","","","","","","","","","","","","","","","","","","","","","","")

cKey     := "P." + cPerg + "01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Transportadora Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Transportadora Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Nota Fiscal Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Nota Fiscal Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Serie da Nota Fiscal Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)  

cKey     := "P." + cPerg + "06."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Serie da Nota Fiscal Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "07."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Emissใo Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)        

cKey     := "P." + cPerg + "08."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Emissใo Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P." + cPerg + "09."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Apresenta Nota Fiscal.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

cKey     := "P." + cPerg + "10."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Cliente Inicial.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

cKey     := "P." + cPerg + "11."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Emissใo Final.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
