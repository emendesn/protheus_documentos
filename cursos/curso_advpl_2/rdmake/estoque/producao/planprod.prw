#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PLANPROD บ Autor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Planejamento de Produ็ใo Por documento x Master   บฑฑ
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

User Function PlanProD()

Local aCores := {{"ZZY_QTDSEP == 0 ",'ENABLE' },;		//Separacao Nao Iniciada
{ "ZZY_QTDSEP == ZZY_QTDMAS" ,'DISABLE'},;		   	//Separacao Finalizada
{ "ZZY_QTDSEP <> 0 .AND. ZZY_QTDSEP <> ZZY_QTDMAS  ",'BR_AMARELO'}} // Separacao Iniciada

Private aRotina 	 := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","U_PLANPRO",0,2} ,;
{"Incluir","U_PLANPRO",0,3},;
{"Alterar","U_PLANPRO",0,4},;
{"Excluir","U_PLANPRO",0,5},;
{"Lista Separacao","U_LISTSEP",0,6},;
{"Acessorios","U_BGERACES",0,7},;
{"Legenda","U_PLALEG",0,0,0 ,.F.}}

u_GerA0003(ProcName())


dbSelectArea("ZZY")
dbSetOrder(1)

MBrowse( 6,1,22,75,'ZZY',,,,,,aCores)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PLANPRO บ Autor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela para Planejamento de Produ็ใo Por documento x Master   บฑฑ
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

User Function PLANPRO(cAlias, nReg, nOpc)

Local cLinOK   := "AllwaysTrue"
Local lTudoOK  := .T.
Local cFieldOK := "AllwaysTrue"
Local lRet     := .F.
Local nOptx    := nOpc
Local aCampos  := {"ZZY_NUMDOC"}
Local aAreaATU := GetArea()
Local aAreaZZY :=ZZY->(GetArea())
Local aButtons   := {}

Private _cNumDoc  	 := IIF(nOpc==3," ",ZZY->ZZY_NUMDOC)
Private	n			 := 1
Private aHeader      := {}
Private aCols        := {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
Private aAlt         := {}
Private oGetTM1      := Nil
Private oDlgTMP		 := Nil
Private oQtdSel		 := Nil
Private aSize      	 := MsAdvSize(.T.)
Private aCpoGet   	 := {"ZZY_OPERAC","ZZY_NUMDOC","ZZY_CODPLA","ZZY_QTDPLA","ZZY_QTDPER","ZZY_DATPLA","ZZY_CELPLA","ZZY_EMISSA","ZZY_SEQUEN"}
Private aPosicao 	 := 0
Private aEdit    	 := {"ZZY_OPERAC","ZZY_NUMDOC","ZZY_CODPLA","ZZY_QTDPLA","ZZY_QTDPER","ZZY_DATPLA","ZZY_CELPLA"}
Private lColuna   	 := .F.
Private _aMasSep	 := {} /// Etiqueta Master Que Possuem Separacao

Private cPerg		:= "PLANPROD"

If nOpc==3
	ValPerg(cPerg) // Ajusta as Perguntas do SX1
	If !Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1
		Return()
	Endif
Endif

// Se possuir Separacao Iniciada Nao Permite Alteracao e nem Exclusao

/*/
If nOpc == 4 .OR. nOpc == 5
	DbSelectArea("ZZY")
	DbSetOrder(1)
	_cNumdoc := ZZY->ZZY_NUMDOC
	_nRegZZy := Recno()
	DbSeek(xFilial("ZZY")+_cNumDoc,.F.)
	While ! Eof() .AND.  ZZY->(ZZY_FILIAL+ZZY_NUMDOC) == xFilial("ZZY")+_cNumDoc
		If ZZY->ZZY_QTDSEP <> 0
			MsgAlert("Separacao Iniciada, Opcao Nao Permitida")
			DbGoTo(_nRegZZY)
			Return
		Endif
		DbSkip()
	Enddo
	// Retorna ao Primeiro Registro do Documento
	DbGoTo(_nRegZZY)
Endif
/*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria Header e Acolsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaHeader()
CriaCols(nOpc)

If nOpc == 3 // Inclusao Cria Campos em Branco
	RegToMemory("ZZY",.T.)
Else
	RegToMemory("ZZY",.F.) // Considera Conteudo do registro posicionado
Endif

// Inclusใo do Botใo Para sele็ใo da Master
aadd(aButtons,{"SOLICITA",     {|| U_PLAPROZ() },"Modelo x Master","Master"})	//"Solicitacoes"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|Monta tela  |
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
aAdd( aObjects, {100,100, .T., .T.})
aAdd( aObjects, {100,100, .T., .T.})
//aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	:= MsObjSize( ainfo, aObjects )

//DEFINE MSDIALOG oDlgTMP TITLE "Planejamento de Producao" FROM aSize[1],00 TO aSize[4],aSize[3] PIXEL
DEFINE MSDIALOG oDlgTMP TITLE "Planejamento de Producao" FROM aSize[7], 0 TO aSize[6],aSize[5] PIXEL
oDlgTMP:lMaximized := .F.
aPosicao := {aPosObj[1,1]+20, aPosObj[1,2]+11, aPosObj[1,3]+13, aPosObj[1,4]-10}
oEnchoice := MsMGet():New("ZZY", ,nOptx, , , , aCpoGet, aPosicao, aEdit, , , , , oDlgTMP, , , lColuna)
oGetTM1 := MSGETDADOS():NEW(aPosObj[2,1]+25, aPosObj[2,2]+11, aPosObj[2,3]+5, aPosObj[2,4]-10,nOptx,"AllwaysTrue","AllwaysTrue","",.T., aCampos, , .F., 200,,, ,, oDlgTMP)
ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{|| GRVZZY(nOptx)},{||Rollbacksx8(),oDlgTMP:End()},,aButtons)
RestArea(aAreaATU)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaHeader บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCria็ใo do aHeader   										  บฑฑ
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

Static Function CriaHeader()

aHeader      := {}
aCpoHeader   := {"ZZY_NUMMAS","ZZY_CODMAS","ZZY_QTDMAS","ZZY_TPRESE","ZZY_QTDSEP","ZZY_ENDES","ZZY_FIFO"}
aAltEnchoice := {}
For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo ้ usado.
			cNivel >= SX3->X3_Nivel                  // Nivel do Usuario ้ maior que o Nivel do Campo.
			
			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
			SX3->X3_Campo       ,;
			SX3->X3_Picture     ,;
			SX3->X3_Tamanho     ,;
			SX3->X3_Decimal     ,;
			SX3->X3_Valid       ,;
			SX3->X3_Usado       ,;
			SX3->X3_Tipo        ,;
			SX3->X3_Arquivo     ,;
			SX3->X3_Context})
		EndIf
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaCol บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCria็ใo do aCols                                            บฑฑ
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

Static Function CriaCols(nOpcao)

Local nQtdCpo := 0
Local i       := 0
Local nCols   := 0
Local nPosMasPro:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_CODMAS" })
Local nPosMasEtq:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_NUMMAS" })
Local nPosMasQtd:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_QTDMAS" })
Local nPosMasTip:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_TPRESE" })
Local nPosMasSep:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_QTDSEP" })
Local nPosEndEs :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_ENDES"  })
Local nPosFifo  :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_FIFO"  })

nQtdCpo := Len(aHeader)
aCols   := {}
n:=0

If nOpcao == 3 // Inclusao
	AAdd(aCols, Array(nQtdCpo+1))
	n++
	aCols[n][nQtdCpo+1] := .F.
Else
	_cNumDoc := ZZY->ZZY_NUMDOC
	DbSelectArea("ZZY")
	DbSetOrder(1)
	DbSeek(xFilial("ZZY")+_cNumDoc,.F.)
	While ! Eof() .AND. ZZY->(ZZY_FILIAL+ZZY_NUMDOC) == xFilial("ZZY")+_cNumDoc
		AAdd(aCols, Array(nQtdCpo+1))
		n++
		aCols[n][nQtdCpo+1] := .F.
		Acols[n][nPosMasPro] 	  := ZZY->ZZY_CODMAS
		Acols[n][nPosMasEtq] 	  := ZZY->ZZY_NUMMAS
		Acols[n][nPosMasQtd] 	  := ZZY->ZZY_QTDMAS
		Acols[n][nPosMasTip] 	  := ZZY->ZZY_TPRESE
		Acols[n][nPosMasSep] 	  := ZZY->ZZY_QTDSEP
		Acols[n][nPosEndEs] 	  := ZZY->ZZY_ENDES
		Acols[n][nPosFifo]  	  := ZZY->ZZY_FIFO
		
		aCols[n][Len(aHeader)+1] := .F.
		// Alimenta Array para identificar as Etiquetas que ja possuem separacao
		If ZZY->ZZY_QTDSEP > 0
			AADD(_aMasSep,{ZZY->ZZY_CODMAS,ZZY->ZZY_NUMMAS,ZZY->ZZY_QTDSEP,ZZY->ZZY_TPRESE,ZZY->ZZY_QTDSEP,ZZY->ZZY_ENDES,ZZY->ZZY_FIFO})
		Endif
		DbSelectArea("ZZY")
		DbSkip()
	Enddo
	// Posiciona Novamente no Primeiro Registro do Documento
	DbSelectArea("ZZY")
	DbSetOrder(1)
	DbSeek(xFilial("ZZY")+_cNumDoc,.F.)
Endif

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GRVZZY   บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava็ใo Dos Dados na Tabela ZZY - Planejamento Producao    บฑฑ
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

Static Function GRVZZY(_nOpcao)

Local _lGravaDoc := .F.
Local _lApagaDoc := .F.

// Valida se Possui Master Selecionada
If Empty(Acols[01,01]) .and. !aCols[n,len(aHeader)+1]
	MsgAlert("Inclusao Nao Permitida, Selecione os Itens ")
	Return
Endif

If _nOpcao == 3 // Inclusao
	If MsgYesNo(OemToAnsi("Confirma Inclusใo do Documento ? "))
		_lGravaDoc := .T.
		ConfirmSX8()
	Endif
Endif

If _nOpcao == 4 // Altera็ใo
	If MsgYesNo(OemToAnsi("Confirma Altera็ใo do Documento ? "))
		_lApagaDoc := .T.
		_lGravaDoc := .T.
	Endif
Endif

If _nOpcao == 5 // Exclusao
	If MsgYesNo(OemToAnsi("Confirma Exclusใo do Documento ? "))
		_lApagaDoc := .T.
	Endif
Endif

If _lApagaDoc
	_cNumDoc := M->ZZY_NUMDOC
	DbSelectArea("ZZY")
	DbSetOrder(1)
	DbSeek(xFilial("ZZY")+_cNumDoc,.F.)
	While ! Eof() .AND. ZZY->(ZZY_FILIAL+ZZY_NUMDOC) == xFilial("ZZY")+_cNumDoc
		//If ZZY->ZZY_QTDSEP == 0 // Nao Houve Separacao
		RecLock("ZZY",.F.)
		DbDelete()
		MsUnlock()
		//Endif
		DbSkip()
	Enddo
Endif

If _lGravaDoc
	For _nElemCols := 1 To Len(aCols)
		If !aCols[_nElemCols][len(aHeader)+1]
			RecLock("ZZY",.T.)
			ZZY->ZZY_FILIAL := xFilial("ZZY")
			// Gravacao dos Itens do Cabecalho
			For _nElemGet := 1 To Len(aCpoGet)
				_cCampo := aCpoGet[_nElemGet]
				If ZZY->(FieldPos(_cCampo)) > 0
					ZZY->(&_cCampo) := &("M->"+_cCampo)
				Endif
			Next _nElemGet
			// Gravacao do Item da Master Com Conteudo do Acols
			For _nElemHead := 1 To Len(aHeader)
				_cCampo := aHeader[_nElemHead][2]
				If ZZY->(FieldPos(_cCampo)) > 0
					ZZY->(&_cCampo) :=  aCols[_nElemCols,_nElemHead]
				Endif
			Next _nElemHead
			MsUnlock()
		Endif
	Next _nElemCols
Endif

If Type("oDlgTMP") <> "U"
	oDlgTMP:End()
EndIf


Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PRAPROZ    บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMontagem da Tela de Sele็ใo de Master                       บฑฑ
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
User Function PLAPROZ()

Local aSvArea:=GetArea()
Local _cIniPro := IIF(M->ZZY_OPERAC<>"2",Left(M->ZZY_CODPLA,4),M->ZZY_CODPLA)
Local _cEndBuf := GetMv("MV_XENDBUF",.F.,"BUFFER")


DEFINE FONT oFontV09 NAME "Verdana" SIZE 50, 08

If ! INCLUI .AND. ! ALTERA
	MsgAlert("SELECAO NAO DISPONIVEL NESTA OPCAO ")
	Return
Endif

If M->ZZY_OPERAC=="1"
	If EMPTY(M->ZZY_CODPLA)
		MsgAlert("INFORME O CODIGO DO PRODUTO")
		Return
	Endif
	If M->ZZY_QTDPLA <=0
		MsgAlert("INFORME UMA QUANTIDADE VALIDA")
		Return
	Endif
Endif

// Criacao dos Campos Para Montagem do TRB
aCampos:={}
AADD(aCampos,{"OK"    ,"C",02,0})
AADD(aCampos,{"MOTDEV","C",20,0})
AADD(aCampos,{"CODPRO","C",15,0})
AADD(aCampos,{"QTDE"  ,"N",12,2})
AADD(aCampos,{"MASTER","C",20,0})
AADD(aCampos,{"ENDES","C",20,0})
AADD(aCampos,{"FIFO","C",06,0})
AADD(aCampos,{"ALMOX","C",02,0})
AADD(aCampos,{"DIAEST","N",10,0})
AADD(aCampos,{"DESC","C",35,0})
AADD(aCampos,{"OPEBGH","C",03,0})
AADD(aCampos,{"QTDESEL","N",12,2})
AADD(aCampos,{"DISPONIVEL","C",1,0})
AADD(aCampos,{"REFGAR","C",20,0})
AADD(aCampos,{"TIPODISP","C",1,0})

cArqMas := CriaTrab(aCampos,.t.)

If SELE("TRB")<>0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,cArqMas,"TRB",.F.)
//IndRegua("TRB",cArqMas,"REFGAR+MASTER+CODPRO",,,"Criando Indice")

//Muda o Array informando descritivos do Browse

aCampos:={}
AADD(aCampos,{"OK"    ,"OK"})
AADD(aCampos,{"MOTDEV","Motivo Devolu็ใo"})
AADD(aCampos,{"CODPRO","Modelo"})
AADD(aCampos,{"QTDE"  ,"Qtde Master"})
AADD(aCampos,{"QTDESEL","Qtd Selecionada"})
AADD(aCampos,{"REFGAR","Classificacao"})
AADD(aCampos,{"MASTER","Etq Master"})
AADD(aCampos,{"ENDES","Endereco"})
AADD(aCampos,{"FIFO","Lote"})
AADD(aCampos,{"ALMOX","Armazem"})
AADD(aCampos,{"DIAEST","Dias no Estoque"})
AADD(aCampos,{"DESC","Descricao"})
AADD(aCampos,{"OPEBGH","Operacao"})
AADD(aCampos,{"DISPONIVEL","Disponivel"})
AADD(aCampos,{"TIPODISP","Tipo Disponivel"})

// STATUS PARA IDENTIFICAR SE POSSUI ENTRADA MASSIVA
// ZZO_STATUS == '0'  .And. ZZO_SEGREG <>  'S'"                      , "ENABLE"    	})    // Triando
// aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG <>  'S'"                      , "BR_AZUL"   	})    // Separacao Efetuada
// aAdd(aCores, {"ZZO_STATUS == '1'  .And. ZZO_SEGREG ==  'S'"                      , "DISABLE"   	})    // Equipamento Segregado
// aAdd(aCores, {"ZZO_STATUS == '2'"                                                , "BR_PINK"   	})    // Entrada Massiva BGH
// aAdd(aCores, {"ZZO_STATUS == '9'"                                                , "BR_CANCEL" 	})    // Rotina Master Estoque BGH

// STATUS PARA IDENTIFICAR O QUE ษ GARANTIA OU NAO
// ZZO_REFGAR = '1'-> REFURBISH-GAR  /// ESTE TEM DE SAIR PRIMEIRO
// ZZO_REFGAR = '2'-> REFURBISH-FOG
// ZZO_REFGAR = '3'-> REPARO-GAR     /// ESTE TBM TEM DE SAIR PRIMEIRO
// ZZO_REFGAR = '4'-> BOUNCE
// ZZO_REFGAR = '5'-> PRATA

// Executa Query com as master disponiveis para alimentar o TRB
//cQuery:= " SELECT ZZ4_CODPRO,ZZ4_ETQMEM,COUNT(*) AS QTDE, GAR_FOG = CASE	WHEN ZZO_REFGAR = '1' THEN 'A-REFURBISH-GAR' WHEN ZZO_REFGAR = '2' THEN 'B-REFURBISH-FOG' WHEN ZZO_REFGAR = '3' THEN 'C-REPARO-GAR'	WHEN ZZO_REFGAR = '4' THEN 'D-BOUNCE' WHEN ZZO_REFGAR = '5' THEN 'E-PRATA' ELSE 'F-INEXISTENTE' END "
If 	M->ZZY_OPERAC <> "2"
	cQuery:= " SELECT ZZ4_CODPRO,ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZ4_OPEBGH, ZZ4_LOCAL, MAX(ZZ4_NFEDT) AS DTENT,ZZO_MOTIVO AS MOTDEV,
	cQuery+= " COUNT(*) AS QTDE, GAR_FOG = CASE WHEN ZZO_REFGAR = '1' THEN 'A-REFURBISH-GAR' WHEN ZZO_REFGAR = '2' THEN 'B-REFURBISH-FOG' WHEN ZZO_REFGAR = '4' THEN 'C-BOUNCE' WHEN ZZO_REFGAR = '3' THEN 'D-REPARO-GAR' WHEN ZZO_REFGAR = '5' THEN 'E-PRATA' ELSE 'F-INEXISTENTE' END "
	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4, "+RETSQLNAME("ZZO")+" ZZO "
	cQuery+= " WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"'"
	cQuery+= " AND ZZO_FILIAL='"+xFilial("ZZO")+"'"
	cQuery+= " AND ZZ4.D_E_L_E_T_='' "
	cQuery+= " AND ZZO.D_E_L_E_T_='' "
	// Relacionamento das Tabelas
	cQuery+= " AND ZZ4_IMEI   = ZZO_IMEI  "
	cQuery+= " AND ZZ4_ETQMEM = ZZO_NUMCX "
	//cQuery+= " AND ZZO_REFGAR IN ('1','2','4') "
	//Regras para a Tabela ZZ4
	cQuery+= " AND ZZ4_STATUS ='3' " // NFE GERADA
	cQuery+= " AND ZZ4_ETQMEM <>'' " // Etiqueta Master
	cQuery+= " AND ZZ4_DOCSEP ='' " // Documento Separa็ใo
	cQuery+= " AND ZZ4_ENDES <> ('%"+_cEndBuf+"%')" // Endere็o Buffer
	cQuery+= " AND ZZ4_CODPRO LIKE ('%"+_cIniPro+"%')" // Etiqueta Master
	// Regras para a Tabela ZZO
	cQuery+= " AND ZZO_STATUS ='2' " // Entrada Massiva BGH
	cQuery+= " GROUP BY ZZ4_CODPRO,ZZ4_LOCAL,ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZO_REFGAR,ZZ4_OPEBGH,ZZO_MOTIVO "
	cQuery+= " ORDER BY GAR_FOG,ZZ4_LOCAL,MAX(ZZ4_NFEDT),ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZ4_OPEBGH "
Else
	cQuery:= " SELECT ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZ4_OPEBGH,ZZ4_LOCAL, MAX(ZZ4_NFEDT) AS DTENT,COUNT(*) AS QTDE "
	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4 "
	cQuery+= " WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"'"
	cQuery+= " AND ZZ4.D_E_L_E_T_='' "
	cQuery+= " AND ZZ4_STATUS ='3' " // NFE GERADA
	cQuery+= " AND ZZ4_ETQMEM <>'' " // Etiqueta Master
	cQuery+= " AND ZZ4_OPEBGH ='"+MV_PAR01+"' "
	cQuery+= " GROUP BY ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZ4_OPEBGH,ZZ4_LOCAL "
	cQuery+= " ORDER BY MAX(ZZ4_NFEDT),ZZ4_ETQMEM,ZZ4_ENDES,ZZ4_FIFO,ZZ4_OPEBGH "
Endif


// Verifica se o ALIAS da tabela esta aberta na memoria e fecha a mesma
If Select("TPSQ") > 0
	DbSelectArea("TPSQ")
	DbCloseArea()
Endif
// Executa
TCQUERY cQuery NEW ALIAS "TPSQ"

TcSetField("TPSQ","QTDE","N",14,2)
TcSetField("TPSQ","DTENT","D",10,0)
_nQtdSel := 0
_nSaldo := IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER,0)
_nQtdSep := 0
For _nElemMas := 1 To Len(_aMasSep)
	_nQtdSep := _nQtdSep+_aMasSep[_nElemMas][5]
Next _nElemMas
_nSaldo := _nSaldo - _nQtdSep
DbSelectArea("TPSQ")
While ! Eof()
	
	_cCodMast := IIF(M->ZZY_OPERAC=="1",TPSQ->ZZ4_CODPRO,"")
	_nQtdDisp := TPSQ->QTDE
	_cEtqMaste:= TPSQ->ZZ4_ETQMEM
	// Abate Saldos Planejados da Etiqueta.
	DbSelectArea("ZZY")
	DbSetOrder(2)  // ZZY_FILIAL, ZZY_NUMMAS, ZZY_CODMAS, ZZY_CODPLA, R_E_C_N_O_, D_E_L_E_T_
	//DbSeek(xFilial("ZZY")+_cEtqMaste + _cCodMast ,.F.)
	DbSeek(xFilial("ZZY")+_cEtqMaste,.F.)
	While ! Eof() .AND. ZZY->(ZZY_FILIAL+ZZY_NUMMAS) == xFilial("ZZY")+_cEtqMaste// + _cCodMast
		_nQtdDisp := _nQtdDisp - (ZZY->ZZY_QTDMAS-ZZY->ZZY_QTDSEP)
		DbSkip()
	Enddo
	DbSelectArea("TPSQ")
	If _nQtdDisp <=0
		DbSkip()
		Loop
	Endif
	
	_lSel := .T.
	If Empty(TPSQ->ZZ4_ENDES) .AND. Alltrim(TPSQ->ZZ4_OPEBGH) $ "N01/N08/N09/N10/N11"
		_lSel := .F.
		_nQuant := 0
	Else
		If M->ZZY_OPERAC=="1"
			If !Empty(TPSQ->MOTDEV)
				_lSel := .F.
				_nQuant := 0
			Else
				_nQuant := MIN(_nQtdDisp,_nSaldo)
			Endif
		Else
			_nQuant := MIN(_nQtdDisp,_nSaldo)
		Endif
	Endif
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->OK 	:= " "
	TRB->MOTDEV   	:= IIF(M->ZZY_OPERAC=="1",AllTrim(Posicione("SX5", 1, xFilial("SX5")+'WG'+TPSQ->MOTDEV, "X5_DESCRI")),"")
	TRB->CODPRO 	:= _cCodMast
	TRB->QTDE   	:= _nQtdDisp
	TRB->QTDESEL	:= _nQuant
	TRB->MASTER		:= _cEtqMaste
	TRB->ENDES		:= TPSQ->ZZ4_ENDES
	TRB->FIFO		:= TPSQ->ZZ4_FIFO
	TRB->ALMOX		:= TPSQ->ZZ4_LOCAL
	TRB->DIAEST		:= dDataBase-TPSQ->DTENT
	TRB->OPEBGH		:= TPSQ->ZZ4_OPEBGH
	TRB->DISPONIVEL := IIF(_nQuant>0 .and. _lSel," ","N")
	TRB->TIPODISP 	:= IIF(_nQtdDisp == TPSQ->QTDE,"T","P")
	TRB->REFGAR   	:= IIF(M->ZZY_OPERAC=="1",TPSQ->GAR_FOG,"")
	TRB->DESC		:= Posicione("SB1",1,xFilial("SB1")+_cCodMast,"B1_DESC")
	MsUnlock()
	If _lSel
		_nSaldo := _nSaldo - _nQuant
		_nQtdSEl := _nQtdSel + _nQuant
	Endif
	
	DbSelectArea("TPSQ")
	DbSkip()
Enddo

/*
If 	M->ZZY_OPERAC == "2"
//inclui opcao sem master no ultimo registro para permitir a selecao caso o fisica esteja diferente do sistema
//If _nSaldo > 0

DbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->OK   		:= " "
TRB->MOTDEV 	:= " "
TRB->CODPRO 	:= M->ZZY_CODPLA
TRB->QTDE   	:= M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep
TRB->QTDESEL	:= _nSaldo
TRB->MASTER		:= "SEM_MASTER"
TRB->DISPONIVEL := IIF(_nSaldo > 0,"","N")
TRB->TIPODISP 	:= "T"
TRB->REFGAR   	:= "SEMMASTER"
TRB->DESC		:= Posicione("SB1",1,xFilial("SB1")+M->ZZY_CODPLA,"B1_DESC")
MsUnlock()
_nQtdSEl := IIF(_nSaldo > 0 ,_nQtdSEl + _nSaldo,_nQtdSel)
//Endif
Endif
*/

/// Montagem de tela Para a Selecao da Master
DbSelectarea("TRB")
DbGoTop()
If TRB->(!EOF())
	
	@ 001,001 TO 395,1000 DIALOG oDlg TITLE OemtoAnsi("Sele็ใo Produto x Etiqueta Master")
	@ 005,005 TO 175,495 BROWSE "TRB" MARK "OK" Enable "DISPONIVEL" FIELDS aCampos Object oBrowse
	oBrowse:BMARK:={||VldObrigat()}
	
	@ 180,200 Say "Qtde Planejada+Perda"   //   FONT oFontV09 COLOR CLR_HRED
	@ 180,250 Say Transform(IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep,0),"@E 999,999.99") //FONT oFontV09 COLOR CLR_HBLUE PIXEL Of oDlg
	@ 180,300 Say "Qtde Selecionada"    //FONT oFontV09 COLOR CLR_HRED
	@ 180,350 MsGet oQtdSel  Var _nQtdSel  When .F. PIXEL Of oDlg Size 50,08
	
	@ 180,435 BMPBUTTON TYPE 01 ACTION GRAVCOLS()
	@ 180,465 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	
Else
	MsgAlert("Dados nใo encontrado. Favor verificar!")
Endif

//Apaga arquivo temporario
If SELE("TRB")<>0
	DbSelectArea("TRB")
	DbCloseArea()
	FErase(cArqMas+OrdBagExt())
Endif
//Restaura Area
RestArea(aSvArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldObrigat บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao Efetuada na Tela de Sele็ใo da Master             บฑฑ
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

Static Function VldObrigat()

Local _lRetVal := .T.
DbSelectArea("TRB")
If !Empty(TRB->DISPONIVEL)  //
	If _nQtdSel == IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep,0) .and. M->ZZY_OPERAC=="1"
		MsgAlert("Quantidade Selecionada acima da Quantidade Planejada")
		_lRetVal := .F.
	Else
		If Empty(TRB->ENDES) //.AND. Alltrim(TRB->OPEBGH) $ "N01/N08/N09/N10/N11"
			_lRetVal := .F.
		ElseIf !Empty(TRB->MOTDEV)
			If !MsgYesNo(OemToAnsi("Master possui Motivo de devolu็ใo ao estoque. Deseja selecionar ? "))
				_lRetVal := .F.
			Endif
		Endif
		If _lRetVal
			_nSaldo := IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep- _nQtdSel,0)
			_nQuant := IIF(M->ZZY_OPERAC=="1",MIN(TRB->QTDE,_nSaldo),TRB->QTDE)
			RecLock("TRB",.F.)
			TRB->DISPONIVEL := " "
			TRB->OK 		  := "X"
			TRB->QTDESEL    := _nQuant
			msUnlock()
			_nQtdSel := _nQtdSel+_nQuant
		Else
			MsgAlert("Master nใo possui Endere็o. Favor verificar!")
		Endif
	Endif
Else
	If TRB->(Marked("OK"))
		If _nQtdSel < IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep,0)
			_nSaldo := IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER -_nQtdSep - _nQtdSel,0)
			_nQuant := MIN(TRB->QTDE,_nSaldo)
			RecLock("TRB",.F.)
			TRB->QTDESEL    := _nQuant
			msUnlock()
			_nQtdSel := _nQtdSel+_nQuant
		Endif
	Else
		_nQtdSel := _nQtdSel - TRB->QTDESEL
		RecLock("TRB",.F.)
		TRB->QTDESEL    := 0
		TRB->DISPONIVEL := "N"
		msUnlock()
	Endif
Endif
oQtdSel:Refresh()
oBrowse:Obrowse:Refresh()
Odlg:Refresh()
Return _lRetVal

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GravCols   บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGravacao do Acols Apos selecao das etiquetas Master         บฑฑ
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

Static Function GravCols()

Local _aArea 	:= GetArea()
Local _lPrimeiro:= .T.
Local nPosMasPro:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_CODMAS" })
Local nPosMasEtq:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_NUMMAS" })
Local nPosMasQtd:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_QTDMAS" })
Local nPosMasTip:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_TPRESE" })
Local nPosMasSep:=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_QTDSEP" })
Local nPosEndEs :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_ENDES"  })
Local nPosFifo  :=  ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZZY_FIFO"  })

If _nQtdSel <> IIF(M->ZZY_OPERAC=="1",M->ZZY_QTDPLA+M->ZZY_QTDPER-_nQtdSep,0) .AND. M->ZZY_OPERAC=="1"
	MsgAlert("Quantidade Selecionada Diferente da Quantidade Planejada")
	Return
Endif


//Grava as Novas Etiquetas Selecionadas
DbSelectArea("TRB")
DbGotop()
_lGrvTrb := .F.
While ! Eof ()
	If TRB->QTDESEL > 0
		_lGrvTrb := .T.
		If _lPrimeiro
			aCols := {}
			n:= 0
			_lPrimeiro := .F.
		Endif
		// Verifica se a Master Selecionada esta no mesmo documento e ja foi separada
		_nPosMas := Ascan(_aMasSep,{|x| x[2] == TRB->MASTER})
		If _nPosMas > 0
			_aMasSep[_nElemMas][03] := _aMasSep[_nElemMas][03] + TRB->MASTER
		Endif
		AAdd(aCols, Array(Len(aHeader)+1))
		n++
		Acols[n][nPosMasPro] 	  := TRB->CODPRO
		Acols[n][nPosMasEtq] 	  := TRB->MASTER
		Acols[n][nPosMasQtd] 	  := TRB->QTDESEL
		Acols[n][nPosMasTip] 	  := IIF(TRB->QTDE == TRB->QTDESEL .AND. TRB->TIPODISP == "T" ,"T" ,"P")
		Acols[n][nPosEndEs] 	  := TRB->ENDES
		Acols[n][nPosFifo]  	  := TRB->FIFO
		aCols[n][Len(aHeader)+1] := .F.
	Endif
	DbSelectArea("TRB")
	DbSkip()
Enddo


// Grava no acols as etiquetas que ja foram separadas
For _nElemMas := 1 To Len(_aMasSep)
	AAdd(aCols, Array(Len(aHeader)+1))
	n++
	Acols[n][nPosMasPro] 	  := _aMasSep[_nElemMas][01]
	Acols[n][nPosMasEtq] 	  := _aMasSep[_nElemMas][02]
	Acols[n][nPosMasQtd] 	  := _aMasSep[_nElemMas][03]
	Acols[n][nPosMasTip] 	  := _aMasSep[_nElemMas][04]
	Acols[n][nPosMasSep] 	  := _aMasSep[_nElemMas][05]
	Acols[n][nPosEndEs] 	  := _aMasSep[_nElemMas][06]
	Acols[n][nPosFifo]  	  := _aMasSep[_nElemMas][07]
	aCols[n][Len(aHeader)+1] := .F.
Next _nElemMas

// Fecha o Browse
Close(oDlg)
oGetTM1:Refresh()
oDlgTMP:Refresh()
RestArea(_aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PLALEG    บAutor ณEduardo Barbosa-Deltaบ Data ณ  02/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLegenda do Browser                                         บฑฑ
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

User Function PLALEG()

Local aCores := {}

aCores := {{"ENABLE",OemToAnsi("Separa็ใo Nใo Iniciada")},;
{"BR_AMARELO",OemToAnsi("Separa็ใo Iniciada")},;
{"DISABLE",OemToAnsi("Separa็ใo Finalizada")}}

BrwLegenda(OemToAnsi("Planejamento de Produ็ใo"),OemToAnsi("Status Planejamento"),aCores)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg   บ Autor ณLuciano Siqueira    บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPerguntas                                                   บฑฑ
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

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Operacao    ?','' ,'' , 'mv_ch1', 'C', 3, 0, 0, 'G', '', 'ZZJ', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBGERACES  บAutor  ณLuciano Siqueira    บ Data ณ  25/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gerar documento de separa็ใo dos acessorios     บฑฑ
ฑฑบDesc.     ณ			 												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BGERACES()

Local bOk			:=	{ || Processa( {|| BGeMovAC() } ), oDlgRV:End() }
Local bCancel		:=	{ || oDlgRV:End() }
Local aButtons		:=	{}
Local nOpcGet		:=	0
Local _lAltera		:=	.T.
Local cLinOk		:=	"U_BGERACEL"
Local cDelOk		:= 	"AllwaysTrue"
Local CTUDOOK       :=  "U_BGERACET"
Local aAux			:=	{}
Local aLocEndOrig	:=	{}
Local cCadastro     := "Acessorios"

Private oOk    		:= LoadBitmap( GetResources(), "CHECKED" )
Private oNo    		:= LoadBitmap( GetResources(), "UNCHECKED" )
Private oBlk   		:= LoadBitmap( GetResources(), "NOCHECKED" )
Private oDlgRV
Private aSize     	:= 	{}
Private aInfo     	:= 	{}
Private aPosObj   	:= 	{}
Private aObjects  	:= 	{}
Private aHeaderAC	:=	{}
Private aColsAC		:=	{}
Private nOpcao		:= 	3
Private aAlterGet	:=	{"QUANT"}
Private oDoc
Private cDoc		:=	ZZY->ZZY_NUMDOC//Space(9)
Private oModelo
Private cModelo		:=	ZZY->ZZY_CODPLA//Space(15)
Private oCodAces
Private cCodAces	:=	Space(15)
Private oQtdAces
Private nQtdAces	:=	0
Private oGetItens
Private aArmazem	:= {}


dbSelectArea("SD3")
SD3->(DBOrderNickName('XDOCORI'))
If dbSeek(xFilial("SD3")+cDoc)
	While SD3->(!EOF()) .and. SD3->(D3_FILIAL+D3_XDOCORI)==xFilial("SD3")+cDoc
		If SD3->D3_ESTORNO <> "S"
			MsgAlert("Documento de Acessorios gerado anteriormente!")
			Return
		Endif
		dbSelectArea("SD3")
		dbSkip()
	EndDo
Endif


_cQuery := " SELECT "
_cQuery += " DISTINCT ZZ4_CODCLI,ZZ4_LOCAL, ZZY_QTDMAS AS QUANT, ZZY_QTDPER AS QTDPER "
_cQuery += " FROM "+RetSqlName("ZZY")+" ZZY, "+RetSqlName("ZZ4")+" ZZ4 "
_cQuery += " WHERE "
_cQuery += " 	ZZY_FILIAL='"+xFilial("ZZY")+"' AND "
_cQuery += "	ZZY_NUMDOC='"+cDoc+"' AND "
_cQuery += "	ZZY_QTDMAS-ZZY_QTDSEP > 0 AND "
_cQuery += "	ZZY.D_E_L_E_T_='' AND "
_cQuery += "	ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND "
_cQuery += "	ZZ4_CODPRO=ZZY_CODMAS AND "
_cQuery += "	ZZ4_ETQMEM=ZZY_NUMMAS AND "
_cQuery += "	ZZ4_STATUS='3' AND "
_cQuery += "	ZZ4.D_E_L_E_T_ = '' "

If Select("TSQL")>0
	dbSelectArea("TSQL")
	dbCloseArea()
EndIf

TcQuery _cQuery New Alias "TSQL"

TcSetField("TSQL","QUANT","N",14,2)


dbSelectArea("TSQL")
TSQL->(dbGotop())

If TSQL->(Eof())
	MsgInfo("Dados nใo encontrados!!!")
	Return
Else
	nQtdPer := TSQL->QTDPER
	While !TSQL->(Eof())
		nQtdAces += TSQL->QUANT
		AADD(aArmazem,{TSQL->ZZ4_LOCAL,TSQL->QUANT,TSQL->ZZ4_CODCLI})
		TSQL->(dbSkip())
	EndDo
	nPercTot := Round(nQtdPer*100/nQtdAces,2)
	If nPercTot > 0 
		For i:= 1 to Len(aArmazem)
			nQtdItem := Round(aArmazem[i,2]/100*nPercTot,0)
			aArmazem[i,2] := aArmazem[i,2]-nQtdItem	
		Next i	
		nQtdAces -= nQtdPer
	Endif
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta aHeaderณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aHeaderAC,{"Produto"		,"COD"			,"@!",TamSx3("B1_COD")[1],0,,,"C",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Descri็ใo"		,"DESCR_PRO"	,"@!",30,0,,,"C",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Principal"		,"PRODORI"		,"@!",TamSx3("B1_COD")[1],0,,,"C",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Estrutura"		,"ESTRUC"		,"@!",15,0,,,"C",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Local"			,"LOCAL"		,"@!",2,0,,,"C",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Saldo"	    	,"SALDO" 	    ,"@E 999,999,999.99",TamSx3("D1_QUANT")[1],TamSx3("D1_QUANT")[2],,,"N",,"V",,,.F.,,,,})
aAdd(aHeaderAC,{"Qtde Sugerida"	,"QUANT" 	    ,"@E 999,999,999.99",TamSx3("D1_QUANT")[1],TamSx3("D1_QUANT")[2],,,"N",,"V",,,.F.,,,,})


dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"WH")
While SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == "WH"
	If ALLTRIM(SX5->X5_CHAVE)$ ALLTRIM(cModelo)
		cCodAces := Left(SX5->X5_DESCRI,15)
		Exit
	EndIf
	SX5->(dbSkip())
EndDo

nOpcGet				:= 	GD_UPDATE+GD_DELETE

AAdd( aObjects, { 100, 020, .T., .T. } )
AAdd( aObjects, { 100, 080, .T., .T. } )

aSize 				:= 	MsAdvSize()
aInfo   			:= 	{ aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj 			:= 	MsObjSize( aInfo, aObjects,.T.)

DEFINE FONT oFont  NAME "Arial"	SIZE 7,12
DEFINE FONT oFont1 NAME "Arial"	SIZE 7,12 BOLD

DEFINE MSDIALOG oDlgRV 	TITLE cCadastro FROM 00,00 TO aSize[6],aSize[5] PIXEL STYLE DS_MODALFRAME STATUS

oDlgRV:lMaximized 	:= .T.

oPanel1				:= 	TPanel():New( aPosObj[1,1],aPosObj[1,2],"",oDlgRV,,.F.,.F.,,,aPosObj[1,4]-5,aPosObj[1,3],.T.,.F. )
oPanel1:l3DLook		:=	.F.
oGrp1 				:= 	TGroup():New( aPosObj[1,1]-10,aPosObj[1,2],aPosObj[1,3]-5,aPosObj[1,4]-10,"",oPanel1,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ 010, 010 Say "Documento: "	   										SIZE 040,010 OF oGrp1 PIXEL FONT oFont1
@ 017, 010 MsGet oDoc 		VAR cDoc	 When .F.						SIZE 050,010 OF oGrp1 PIXEL FONT oFont1 COLOR CLR_BLUE

@ 010, 080 Say "Modelo: "												SIZE 040,010 OF oGrp1 PIXEL FONT oFont1
@ 017, 080 MsGet oModelo 	VAR cModelo	 When .F.						SIZE 050,010 OF oGrp1 PIXEL FONT oFont1 COLOR CLR_BLUE


@ 035, 010 Say "Acessorio: "											SIZE 040,010 OF oGrp1 PIXEL FONT oFont1
@ 042, 010 MsGet oCodAces 	VAR cCodAces When .T. F3 "SB1"  Valid LoadDoc()		SIZE 050,010 OF oGrp1 PIXEL FONT oFont1 COLOR CLR_BLUE

@ 035, 080 Say "Quantidade: "											SIZE 040,010 OF oGrp1 PIXEL FONT oFont1
@ 042, 080 MsGet oQtdAces 	VAR Transform(nQtdAces,"@E 999,999.99")	When .F.					SIZE 050,010 OF oGrp1 PIXEL FONT oFont1 COLOR CLR_BLUE


oPanel2				:= 	TPanel():New( aPosObj[2,1]+20,aPosObj[2,2],"",oDlgRV,,.F.,.F.,,,aPosObj[2,4]-5,aPosObj[2,3]-80,.T.,.F. )
oPanel2:l3DLook		:=	.F.
oGrp2 				:= 	TGroup():New( aPosObj[2,1]-65,aPosObj[2,2],aPosObj[2,3]-85,aPosObj[2,4]-10,"",oPanel2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oGetItens			:=	MsNewGetDados():New(aPosObj[2,2]+5,aPosObj[2,2]+5,aPosObj[2,3]*0.65,aPosObj[2,4]-15,nOpcGet,cLinOk,cTudoOk,/*ITEM*/,aAlterGet,,9999,,,cDelOk,oGrp2,aHeaderAC,aColsAC )

//ACTIVATE MSDIALOG oDlgRV CENTER ON INIT EnchoiceBar( oDlgRV , bOk , bCancel , , aButtons )    

ACTIVATE MSDIALOG oDlgRV ON INIT EnchoiceBar(oDlgRv,{||nOpcA:=1,Iif(U_BGERACET(),Processa({|| BGeMovAC(),oDlgRV:End()}),nOpcA:=0)},{||oDlgRV:End()},,aButtons)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadDoc  บAutor  ณDelta Decisao DF    บ Data ณ  26/06/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para carregar itens da estrutura de acessorios      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Brasil                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadDoc()

Local _cArmAce := GetMv("MV_XARMACE",.F.,"10;11")

Private cNextSp		:= GetMv("MV_NEXTSP")
Private cNextRj     := GetMv("MV_NEXTRJ")

_cQryAc := " SELECT "
_cQryAc += " 	G1_COMP,B1_DESC,G1_QUANT,B2_LOCAL,B2_QATU, 0 AS QUANT "
_cQryAc += " FROM "+RetSqlName("SG1")+" SG1  "
_cQryAc += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
_cQryAc += " 	B1_FILIAL='"+xFilial("SB1")+"' AND "
_cQryAc += " 	B1_COD=G1_COMP AND "
_cQryAc += " 	B1_FANTASM <> 'S' AND "
_cQryAc += "	SB1.D_E_L_E_T_ = '' "
_cQryAc += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON "
_cQryAc += " 	B2_FILIAL='"+xFilial("SB2")+"' AND "
_cQryAc += "	B2_COD=G1_COMP AND "
_cQryAc += "	B2_LOCAL IN "+FormatIn(_cArmAce,";")+" AND "
_cQryAc += "	SB2.D_E_L_E_T_ = '' "
_cQryAc += " WHERE "
_cQryAc += " 	G1_FILIAL='"+xFilial("SG1")+"' AND "
_cQryAc += "	G1_COD='"+cCodAces+"' AND "
_cQryAc += "	G1_INI <= '"+DTOS(dDataBase)+"' AND "
_cQryAc += "	G1_FIM >= '"+DTOS(dDataBase)+"' AND "
_cQryAc += "	SG1.D_E_L_E_T_ = '' "
_cQryAc += " ORDER BY B2_LOCAL,B2_COD "

If Select("TSQL")>0
	dbSelectArea("TSQL")
	dbCloseArea()
EndIf

TcQuery _cQryAC New Alias "TSQL"

TcSetField("TSQL","B2_QATU","N",14,2)
TcSetField("TSQL","QUANT","N",14,2)

dbSelectArea("TSQL")
TSQL->(dbGotop())

If TSQL->(Eof())
	MsgInfo("Dados nใo encontrados!!!")
	Return
EndIf

oGetItens:aCols := {}

For nx := 1 to Len(aArmazem)
	
	dbSelectArea("TSQL")
	TSQL->(dbGotop())
	
	While !TSQL->(Eof())
	
		//cArmazem := IIF(aArmazem[nx,3]=="000016","10","11")
		
		cArmazem := IIF(aArmazem[nx,3] $ Alltrim(cNextSp),"10",IIF(aArmazem[nx,3] $ Alltrim(cNextRj),"11",aArmazem[nx,1]))
		
		//cCliAces := IIF(cArmazem=="10","000016","000680")
		
		cCliAces := aArmazem[nx,3]
		
		If cArmazem==TSQL->B2_LOCAL
				
			nSaldoP3 := ConsPd3(TSQL->G1_COMP,cCliAces)
									
			Aadd(oGetItens:aCols, Array( Len(aHeaderAC)+1 ) )
			
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("COD",aHeaderAC)]  		:= TSQL->G1_COMP
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("DESCR_PRO",aHeaderAC)]	:= TSQL->B1_DESC
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("LOCAL",aHeaderAC)]	    := TSQL->B2_LOCAL
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("SALDO",aHeaderAC)]		:= IIF(nSaldoP3 >= TSQL->B2_QATU,TSQL->B2_QATU,nSaldoP3)
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("QUANT",aHeaderAC)]		:= aArmazem[nx,2]
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("ESTRUC",aHeaderAC)]		:= "PRINCIPAL"
			oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("PRODORI",aHeaderAC)]  	:= TSQL->G1_COMP
			
			oGetItens:aCols[Len(oGetItens:aCols)][Len(aHeaderAC)+1]	:= 	.F.
			
			dbSelectArea("SGI")
			dbSetOrder(1)
			If dbSeek(xFilial("SGI")+TSQL->G1_COMP)
				While SGI->(!EOF()) .and. SGI->(GI_FILIAL+GI_PRODORI)==xFilial("SGI")+TSQL->G1_COMP
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+SGI->GI_PRODALT)
					If SB1->B1_FANTASM <> "S"
						
						dbSelectArea("SB2")
						dbSetOrder(1)
						If dbSeek(xFilial("SB2")+SGI->GI_PRODALT+cArmazem)
						    
							nSaldoP3 := ConsPd3(SGI->GI_PRODALT,cCliAces)
							
							Aadd(oGetItens:aCols, Array( Len(aHeaderAC)+1 ) )
							
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("COD",aHeaderAC)]  		:= SGI->GI_PRODALT
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("DESCR_PRO",aHeaderAC)]	:= SB1->B1_DESC
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("LOCAL",aHeaderAC)]	    := SB2->B2_LOCAL
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("SALDO",aHeaderAC)]		:= IIF(nSaldoP3 >= SB2->B2_QATU,SB2->B2_QATU,nSaldoP3)
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("QUANT",aHeaderAC)]		:= 0
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("ESTRUC",aHeaderAC)]		:= "ALTERNATIVO"
							oGetItens:aCols[Len(oGetItens:aCols)][GdFieldPos("PRODORI",aHeaderAC)]  	:= TSQL->G1_COMP
							
							oGetItens:aCols[Len(oGetItens:aCols)][Len(aHeaderAC)+1]	:= 	.F.
							
						Endif
					Endif
					SGI->(dbSkip())
				EndDo
			Endif
		Endif
		
		TSQL->(dbSkip())
		
	EndDo
	
Next nx

oGetItens:ReFresh()

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ FUNCAO PARA VALIDACAO DE TUDO - TUDO OK                               บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function BGERACET()

Local lRet 		:= .T.
Local nQtdSel 	:= 0

For nx := 1 to Len(oGetItens:aCols)
	nQtdSel := 0
	If oGetItens:aCols[nx][GdFieldPos("SALDO",aHeaderAC)] < oGetItens:aCols[nx][GdFieldPos("QUANT",aHeaderAC)]
		MsgAlert("Produto "+Alltrim(oGetItens:aCols[nx][GdFieldPos("COD",aHeaderAC)])+" nใo possui saldo no armazem "+;
		oGetItens:aCols[nx][GdFieldPos("LOCAL",aHeaderAC)]+" para atender a Qtde Sugerida!")
		lRet := .F.
		Exit
	Endif
	If lRet
		dbSelectArea("SG1")
		dbSetOrder(1)
		If dbSeek(xFilial("SG1")+cCodAces+oGetItens:aCols[nx][GdFieldPos("COD",aHeaderAC)])
			If !empty(SG1->G1_CODDEPE)
				For i:=1 To Len(oGetItens:aCols)
					If Alltrim(oGetItens:aCols[i][GdFieldPos("COD",aHeaderAC)])==Alltrim(SG1->G1_CODDEPE) .and.;
						oGetItens:aCols[nx][GdFieldPos("QUANT",aHeaderAC)] <> oGetItens:aCols[i][GdFieldPos("QUANT",aHeaderAC)]
						MsgAlert("Quantidade do item "+Alltrim(oGetItens:aCols[nx][GdFieldPos("COD",aHeaderAC)])+;
						" diferente da quantidade do item "+Alltrim(oGetItens:aCols[i][GdFieldPos("COD",aHeaderAC)])+". Favor verificar! ")
						lRet := .F.
					Endif
				Next i
			Endif
		Endif
	Endif
	If lRet
		For i:=1 To Len(oGetItens:aCols)
			If oGetItens:aCols[i][GdFieldPos("PRODORI",aHeaderAC)]==oGetItens:aCols[nx][GdFieldPos("PRODORI",aHeaderAC)]
				nQtdSel += oGetItens:aCols[i][GdFieldPos("QUANT",aHeaderAC)]
			Endif
		Next i
		If nQtdSel > nQtdAces
			MsgAlert("Quantidade sugerida do produto "+Alltrim(oGetItens:aCols[nx][GdFieldPos("PRODORI",aHeaderAC)])+;
			" maior que a necessidade. Favor verificar!")
			lRet := .F.
		Endif
	Endif
Next nx


Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ FUNCAO PARA VALIDACAO DA LINHA - LINHA OK                             บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function BGERACEL()

Local lRet := .T.
Local nQtdSel := 0

If oGetItens:aCols[n][GdFieldPos("SALDO",aHeaderAC)] < oGetItens:aCols[n][GdFieldPos("QUANT",aHeaderAC)]
	MsgAlert("Produto "+Alltrim(oGetItens:aCols[n][GdFieldPos("COD",aHeaderAC)])+" nใo possui saldo no armazem "+;
	oGetItens:aCols[n][GdFieldPos("LOCAL",aHeaderAC)]+" para atender a Qtde Sugerida!")
	lRet := .F.
Endif
If lRet
	For i:=1 To Len(oGetItens:aCols)
		If oGetItens:aCols[i][GdFieldPos("PRODORI",aHeaderAC)]==oGetItens:aCols[n][GdFieldPos("PRODORI",aHeaderAC)]
			nQtdSel += oGetItens:aCols[i][GdFieldPos("QUANT",aHeaderAC)]
		Endif
	Next i
	If nQtdSel > nQtdAces
		MsgAlert("Quantidade sugerida maior que a necessidade. Favor verificar!")
		lRet := .F.
	Endif
Endif

oGetItens:ReFresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraMov  บAutor  ณ                    บ Data ณ    /  /     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BGeMovAC()
Local aAreaAnt	:= GetArea()
Private aMovSD3		:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas pela funcao wmsexedcfณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLibSDB	:= {}
Private aWmsAviso:= {}
dbSelectArea("SD3")
nSavReg     := RecNo()
cNumDoc		:= space(6)
cNumDoc    	:= IIf(Empty(cNumDoc),NextNumero("SD3",2,"D3_DOC",.T.),cNumDoc)
cNumDoc    	:= A261RetINV(cNumDoc)
dbSetOrder(2)
dbSeek(xFilial()+cNumDoc)
cMay := "SD3"+Alltrim(xFilial())+cNumDoc
While D3_FILIAL+D3_DOC==xFilial()+cNumDoc .Or.!MayIUseCode(cMay)
	If D3_ESTORNO # "S"
		cNumDoc := Soma1(cNumDoc)
		cMay := "SD3"+Alltrim(xFilial())+cNumDoc
	Endif
	dbSkip()
EndDo
aCab := {;
{"D3_DOC"		,cNumDoc			,NIL},;
{"D3_TM"		,"998"     		,NIL},;
{"D3_EMISSAO"	,dDataBase		,Nil}}
For i:=1 To Len(oGetItens:aCols)
	If oGetItens:aCols[i][GdFieldPos("QUANT",aHeaderAC)] > 0
		aadd(aMovSD3,{{"D3_COD"		,oGetItens:aCols[i][GdFieldPos("COD",aHeaderAC)],NIL},;
		{"D3_LOCAL"		,oGetItens:aCols[i][GdFieldPos("LOCAL",aHeaderAC)],NIL},;
		{"D3_QUANT"		,oGetItens:aCols[i][GdFieldPos("QUANT",aHeaderAC)],NIL},;
		{"D3_XGRMOVI"	,Left(cModelo,4),NIL},;
		{"D3_XDOCORI"	,cDoc,NIL},;
		{"D3_SERVIC"	,"014",NIL}})
	Endif
Next i
If Len(aMovSD3) > 0
	MSExecAuto({|x,y| MATA241(x,y)},aCab,aMovSD3)
	If lMsErroAuto
		MostraErro()
	Else
		MsgInfo("Documento "+Alltrim(cNumDoc)+" gerado com sucesso!!!")
	Endif
Endif
RestArea(aAreaAnt)
Return

Static Function ConsPd3(cCodPro,cCliAces)

Local nSaldo := 0 

cQuery := " SELECT "
cQuery += "		B6_CLIFOR, "
cQuery += "		B6_PRODUTO, "
cQuery += "		SUM(B6_SALDO) AS SALDO "
cQuery += "	FROM "+RetSqlName("SB6")+" SB6  "
cQuery += "	WHERE "
cQuery += "		B6_FILIAL='"+xFilial("SB6")+"' AND "
cQuery += "		B6_PRODUTO='"+cCodPro+"' AND "
cQuery += "		B6_PODER3='R' AND "
cQuery += "		B6_SALDO > 0 AND "
cQuery += "		B6_CLIFOR='"+cCliAces+"' AND "
cQuery += "		SB6.D_E_L_E_T_='' "
cQuery += "	GROUP BY B6_CLIFOR,B6_PRODUTO "

If Select("TSQLP3")>0
	dbSelectArea("TSQLP3")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TSQLP3"

TcSetField("TSQLP3","SALDO","N",14,2)

dbSelectArea("TSQLP3")
TSQLP3->(dbGotop())

If TSQLP3->SALDO > 0 
	nSaldo := TSQLP3->SALDO
Endif

Return(nSaldo)