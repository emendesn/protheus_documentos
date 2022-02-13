#INCLUDE 'rwmake.ch'
#INCLUDE "topconn.ch"

#define CMD_OPENWORKBOOK	   		1
#define CMD_CLOSEWORKBOOK		 	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPMRP    บAutor  ณDiego Fernandes     บ Data ณ  23/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Importa็ใo de Planilhas                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IMPMRP()

Private cPerg      := PADR("IMPMRP",10)    	// Nome da Pergunte

AjustaSX1()             				// Atualiza o SX1 com as Perguntes necessarias

If !Pergunte(cPerg,.T.)                // Pergunta no SX1
	Return Nil
EndIf

If MsgYesNo("Processar importa็ใo?")
	Processa( {|| OkProc() } )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OkProc   บAutor  ณDeltaDecisao DF     บ Data ณ  06/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Importa็ใo de Planilha de Dentes                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc()

Local cBuffer	:= ''
Local cFile		:= ''
Local aCells	:= {} //array com as celulas a serem lidas
Local aItens 	:= {}
Local nI		:= 0
Local nCelini   := 2 //posicao da primeira celula com valor
Local cPasta    := UPPER(MV_PAR03) //nome da pasta dentro da planilha
Local nQtd      := 0
Local nQtdMax   := 0
Local nQtdPP	:= 0
Local nEntrega  := 0 
Local cEndereco := ""
Local cCelPos1  := "A"
Local cCelPos2  := "B"
Local cCelPos3  := "C"
Local cCelPos4  := "D"
Local cCelPos5  := "E"
Local cCelPos6  := "F"
Local cCelPos7  := "G"
Local aplanilha :={}
Local nQuant    :=0
Local cCamDLL   := Getmv("BH_DLLEXCE",.F.,"\\172.16.0.6\Microsiga\Protheus_Data\dll\readexcel.dll")
//Local cCamDLL      		:= "C:\readexcel.dll "

Private lGatilho := .F.
Private cMsg := ""

cFile := ALLTRIM(MV_PAR01)+ALLTRIM(MV_PAR02)  //ACaminho do arquivo

nCont := 1
cMV_PLAN:=ALLTRIM(MV_PAR02)
Do while nCont<len(cMV_PLAN)
	nAt:=AT(";",SUBSTR(cMV_PLAN,nCont,len(cMV_PLAN)) )
	if nAt=0
		nAt:=len(cMV_PLAN)+1
	endif
	aAdd(aPlanilha,ALLTRIM(MV_PAR01)+substr(cMV_PLAN,nCont,nAt-1))
	nCont:=nAt+1
Enddo

ProcRegua(0)

For nCont:=1 To Len(aPlanilha)
	
	nHdl    := ExecInDLLOpen(cCamDLL)
	cBuffer := ""
	nCelini := 2 //posicao da primeira celula com valor
	nQtd    := 0
	nQtdMax := 0
	nQtdPP  := 0
	nEntrega:= 0
	nLE     := 0
	cFile	:= aPlanilha[nCont]
	aCells	:= {}
	
	// Monta array das celulas que serao lidas
	Aadd(aCells,{   cCelPos1+alltrim(str(nCelini)),;   //Produto
	cCelPos2+alltrim(str(nCelini)),;   //Produto alternativo
	cCelPos3+alltrim(str(nCelini)),; //Estoque seguranca
	cCelPos4+alltrim(str(nCelini)),; //Estoque Maximo
	cCelPos5+alltrim(str(nCelini)),; //Ponto de Pedido
	cCelPos6+alltrim(str(nCelini)),; //Entrega
	cCelPos7+alltrim(str(nCelini))} ) //Lote Economico
	
	If ( nHdl >= 0 )
		
		// Carrega o Excel e Abre o arquivo
		cBuffer := cFile + Space(512)
		nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
		
		If ( nBytes < 0 )
			// Erro critico na abertura do arquivo sem msg de erro
			MsgStop('Nใo foi possivel abrir o arquivo : ' + cFile)
		ElseIf ( nBytes > 0 )
			// Erro critico na abertura do arquivo com msg de erro
			MsgStop(Subs(cBuffer, 1, nBytes))
		EndIf
		
		// Seleciona a worksheet
		cBuffer := cPasta + Space(512)
		ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
		nI := 1
		
		nCont := 0
		
		Do while .T.
			
			nCont++
			
			IncProc("Importando Planilha, aguarde... " + StrZero(nCont,4) )
			
			// Le as celulas Pos1
			cBuffer := aCells[nI,1] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			cCodPro := Subs(cBuffer, 1, nBytes)
			
			// Le as celulas Pos2
			cBuffer := aCells[nI,2] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			cAltCodPro := Subs(cBuffer, 1, nBytes)
			
			// Le as celulas Pos3
			cBuffer := aCells[nI,3] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nQtd    := Subs(cBuffer, 1, nBytes)
			
			// Le as celulas Pos4
			cBuffer := aCells[nI,4] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nQtdMax:= Subs(cBuffer, 1, nBytes)
			
			// Le as celulas Pos5
			cBuffer := aCells[nI,5] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nQtdPP:= Subs(cBuffer, 1, nBytes)
			
			// Le as celulas Pos6
			cBuffer := aCells[nI,6] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nEntrega:= Subs(cBuffer, 1, nBytes) 
			
			// Le as celulas Pos7
			cBuffer := aCells[nI,7] + Space(1024)
			nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
			nLE:= Subs(cBuffer, 1, nBytes) 
			
			//verifica se o fim do arquivo
			If Empty(cCodPro)
				Exit
			EndIf
			
			nI++
			++nCelini
			
			Aadd(aCells,{   cCelPos1+alltrim(str(nCelini)),;
			cCelPos2+alltrim(str(nCelini)),;
			cCelPos3+alltrim(str(nCelini)),; 
			cCelPos4+alltrim(str(nCelini)),; 
			cCelPos5+alltrim(str(nCelini)),; 
			cCelPos6+alltrim(str(nCelini)),;
			cCelPos7+alltrim(str(nCelini))} )
			
			//Adiciona matriz
			Aadd(aItens,{ Alltrim(cCodPro)  ,;
			Alltrim(cAltCodPro),;
			Round(VAL(STRTRAN(nQtd,",",".")),0),;
			Round(VAL(STRTRAN(nQtdMax,",",".")),0),;
			Round(VAL(STRTRAN(nQtdPP,",",".")),0),;
			Round(VAL(STRTRAN(nEntrega,",",".")),0),;
			Round(VAL(STRTRAN(nLE,",",".")),0)})
		Enddo
		
		// Fecha o arquivo e remove o excel da memoria
		cBuffer := Space(512)
		ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
		ExecInDLLClose(nHdl)
		
	Else
		
		MsgStop('Nao foi possivel carregar a DLL')
		Exit
		
	EndIf
	
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza endereco na tabela SB1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nY := 1 To Len(aItens)
	
	IncProc("Atualizando cadastro de produtos, aguarde... " + StrZero(nY,4) )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza produto Principalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	If SB1->(dbSeek(xFilial("SB1")+ PADR(aItens[nY,1],15) ))		                   
		SB1->(RecLock("SB1",.F.))			
		SB1->B1_ESTSEG := aItens[nY,3]
		SB1->B1_EMAX   := aItens[nY,4]
		SB1->B1_EMIN   := aItens[nY,5]
		SB1->B1_PE     := aItens[nY,6] 	
		SB1->B1_LE     := aItens[nY,7] 	
		SB1->(MsUnLock())
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza produto Alternativo ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SB1")
		dbSetOrder(1)
		
		If SB1->(dbSeek(xFilial("SB1")+ PADR(aItens[nY,2],15) ))		
			SB1->(RecLock("SB1",.F.))			
			SB1->B1_ESTSEG := aItens[nY,3]
			SB1->B1_EMAX   := aItens[nY,4]
			SB1->B1_EMIN   := aItens[nY,5]
			SB1->B1_PE     := aItens[nY,6]
			SB1->B1_LE     := aItens[nY,7] 	
			SB1->(MsUnLock())
		Else
			AutoGrLog("PRODUTO ALTERNATIVO NAO ENCONTRADO - " + aItens[nY,2] +"/" + Alltrim(Str(aItens[nY,3]))+"/" + Alltrim(Str(aItens[nY,4]))+"/" + Alltrim(Str(aItens[nY,5]))+"/" + Alltrim(Str(aItens[nY,6]))+"/" + Alltrim(Str(aItens[nY,7])) )
		EndIf
		
	Else
		AutoGrLog("PRODUTO NAO ENCONTRADO - " + aItens[nY,1] +"/" + Alltrim(Str(aItens[nY,3])) +"/" + Alltrim(Str(aItens[nY,4]))+"/" + Alltrim(Str(aItens[nY,5]))+"/" + Alltrim(Str(aItens[nY,6])) +"/" + Alltrim(Str(aItens[nY,7])))
	EndIf
	
Next nY

GERALOG()

MsgInfo("Processo finalizado")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณDeltaDecisao DF     บ Data ณ  06/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pergunta que gera os parametros para o rotina              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

aRegs :={}

// Perguntas para o AP8
aAdd(aRegs,{cPerg,"01","Diretorio:       ","","","mv_ch1" ,"C",30,0,0,"G","naovazio"       ,"MV_PAR01",""      ,"","","","",""       ,"","","" ,"","","","","" ,"","","","","" ,"","","","","",""   ,""})
aAdd(aRegs,{cPerg,"02","Nome do arquivo: ","","","mv_ch2" ,"C",30,0,0,"G","naovazio"       ,"MV_PAR02",""      ,"","","","",""       ,"","","" ,"","","","","" ,"","","","","" ,"","","","","",""   ,""})
aAdd(aRegs,{cPerg,"03","Nome da Lista    ","","","mv_ch3" ,"C",10,0,0,"G","naovazio"       ,"MV_PAR03",""      ,"","","","",""       ,"","","" ,"","","","","" ,"","","","","" ,"","","","","",""   ,""})

For i:=1 to Len(aRegs)
	If !dbSeek(PADR(cPerg,10)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณGERALOG   | Autor ณDiego Fernandes        |      |18/08/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Log de erro												  |ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ BGH								                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GERALOG()

Local cFileLog := ""
Local cPath    := "C:\log\"

cFileLog := NomeAutoLog()

If !cFileLog == Nil
	AutoGrLog("")
	AutoGrLog("---------------------------------------------")
	AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
	AutoGrLog("DATA...............: "+Dtoc(MsDate()))
	AutoGrLog("HORA...............: "+Time())
	AutoGrLog("USUมRIO............: "+SubStr(cUsuario,7,15))
	
	cFileLog := NomeAutoLog()
	MostraErro(cPath,"OK - " + cMV_PLAN)
Endif

Return
