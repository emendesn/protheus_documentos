/*--------------------------------------------------------------------------------------------------------------------------------------------------------+
|Programa: RFOLHA                                                                                                                                         |
|Autor:                                                                                                                                                   |
|Data Aplicação:                                                                                                                                          |
|Descrição: relatorio FOLHA DE PAGAMENTO E PROVISÕES                                                                                                      |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 18/03/2011                                                                                                                               |
|Motivo: A pedido da Luciana, inclusão do campo "PREMIO"                                                                                                  |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|Data Alteração: 03/09/2012                                                                                                                               |
|Motivo: A pedido da Luciana, correção do campo "AMEMPRESA"                                                                                               |
|Resposável: Maintech Information & Solution                                                                                                              |
|Validado por: Luciana Benicio  ambiente DEVEL_MAINTECH                                                                                                   |
+--------------------------------------------------------------------------------------------------------------------------------------------------------*/
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

User Function RFOLHA  //(menu Relatorios\Customizados\Folha Pagto e Provisoes

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local cDesc1        := "Este Programa tem como Objetivo Imprimir o Relatório "
Local cDesc2        := "de acordo com os Parâmetros informados pelo Usuário. "
Local cDesc3        := "FOLHA DE PAGAMENTO E PROVISÕES"
Local cPict         := ""
Local Titulo        := " " //"FOLHA DE PAGAMENTO E PROVISÕES. MES " + right(MV_PAR05,2) + "/" + left(MV_PAR05,4)
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local Imprime       := .t.
Local aOrd          := {}

Private lEnd        := .f.
Private lAbortPrint := .f.
Private Limite      := 132
Private Tamanho     := "M"
Private NomeProg    := "RFOLHA"
Private nTipo       := 15
Private aReturn     := {"Zebrado",1,"Administração",1,2,1,"",1}
Private nLastKey    := 0
Private cBTxt       := Space(10)
Private cBCont      := 0
Private ContFl      := 1
Private m_pag       := 1
Private wnrel       := "RFOLHA"
Private cString     := "SX2"

u_GerA0003(ProcName())

DbSelectArea("SX2")
DbSetOrder(1)

//------------------------------------------------------
// 1) Criando arquivo Temporario
//------------------------------------------------------

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	DbSelectArea("SRA")
EndIf

_aCampos := {} // criando um array vazio....

AADD(_aCampos,{"CCCUSTO"    ,"C",tamsx3("RA_CC")[1],tamsx3("RA_CC")[2]})
AADD(_aCampos,{"DCCUSTO"    ,"C",tamsx3("CTT_DESC01")[1],tamsx3("CTT_DESC01")[2]})
AADD(_aCampos,{"MATRICULA"  ,"C",tamsx3("RA_MAT")[1],tamsx3("RA_MAT")[2]})
AADD(_aCampos,{"NOME"       ,"C",tamsx3("RA_NOME")[1],tamsx3("RA_NOME")[2]})
AADD(_aCampos,{"SALARIO"    ,"N",tamsx3("RA_SALARIO")[1],tamsx3("RA_SALARIO")[2]})
AADD(_aCampos,{"PREMIO"     ,"N",tamsx3("RD_HORAS")[1],tamsx3("RD_HORAS")[2]})     //PARA SRD->RD_PD    = "187","356","357"
AADD(_aCampos,{"INSSBASE"   ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "701+702"
AADD(_aCampos,{"INSSEMPR"   ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "819+820+822 OU 701x??%"
AADD(_aCampos,{"INSSFUNC"   ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "401+402+403+404+405"
AADD(_aCampos,{"FGTS"       ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "730+733+736+737+738
AADD(_aCampos,{"PROVFER"    ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRT->RT_VERBA = "830+831+832+833+834"
AADD(_aCampos,{"PROV13"     ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRT->RT_VERBA = "845+846+847+848"
AADD(_aCampos,{"PROVFGTS"   ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "858"
AADD(_aCampos,{"VREMPRESA"  ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "788"
AADD(_aCampos,{"VTEMPRESA"  ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = "786"
AADD(_aCampos,{"AMEMPRESA"  ,"N",tamsx3("RD_VALOR")[1],tamsx3("RD_VALOR")[2]})     //PARA SRD->RD_PD    = ""725","726","789""


_cArq1 := CriaTrab(_aCampos,.t.)
DbUseArea(.t.,,_cArq1,"TRB",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("TRB",_cInd1,"CCCUSTO + NOME",,,"Selecionando Registros...")

// +----------------------------------------+
// | Monta a Interface Padrão com o Usuário |
// +----------------------------------------+

PERGUNTE("RFOLHA",.f.) //forca que pegue os parametros pre-existentes para a memoria

wnrel := SetPrint(cString,NomeProg,"RFOLHA",@Titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.t.,Tamanho,,.f.)

Titulo := "FOLHA DE PAGAMENTO E PROVISÕES. MES " + right(MV_PAR05,2) + "/" + left(MV_PAR05,4)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

nTipo := IIF(aReturn[4] == 1,15,18)

// +--------------------------------------------+
// | Monta Janela com a Régua de Processamento. |
// +--------------------------------------------+

Processa({|| RunCont() },"Processando...")
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},Titulo)

Return // fim user funcion

//+---------+---------+------------------------+----------------------+
//| Função: | RunCont | Autor: Ronaldo Silva   | Data: 02/2010        |
//+---------+---------+------------------------+----------------------+
//| Uso:    | BGH                                                     |
//+---------+---------------------------------------------------------+

Static Function RunCont

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cQrySRA    := ""
Local _lSR8       := .f.
Local _nQhe		  := "0"
Local _nThe		  := "0"
Local _nQdsr	  := "0"
Local _nTdsr	  := "0"
Local _nValor     := "0"
Local _nTValor    := "0"
Local _dfimFerias := "0"

// +---------------------------------------------+
// | Grava Informações Solicitadas DBF           |
// +---------------------------------------------+

ProcRegua(RecCount())

	DbSelectarea("SRA")
	DbSetorder(2) //FILIAL + C.CUSTO  + MATRICULA 
	DbGotop()
	DbSeek (xfilial("SRA") + MV_PAR01 + MV_PAR03,.T.) 

	while !eof() .and. xFilial() == RA_FILIAL .and. RA_CC <= MV_PAR02 .and. RA_MAT <= MV_PAR04
	      
		If SRA->RA_SITFOLH == "D" .and. MV_PAR05 > left(dtos(SRA->RA_DEMISSA),6) // exclui demitidos anterior ao mês de referência
		DbSkip()
		Loop
		EndIF
				
			While !RecLock("TRB",.t.)
			Enddo                                                                                
				
			TRB->CCCUSTO     := SRA->RA_CC
			TRB->DCCUSTO     := Posicione("CTT",1,xFilial("CTT") + SRA->RA_CC,"CTT_DESC01")
			TRB->MATRICULA   := SRA->RA_MAT
			TRB->NOME        := SRA->RA_NOME
			TRB->SALARIO     := SRA->RA_SALARIO
			TRB->PREMIO      := rSRD({"187","356","357"})			
			TRB->INSSBASE    := rSRD({"701","702"})
			TRB->INSSEMPR    := TRB->INSSBASE*0.2958//20,0%(EMPRESA) + 5,80%(TERCEIROS) + 3,78%(SAT+FAP)
			TRB->INSSFUNC    := rSRD({"401","402","403","404","405"})
			TRB->FGTS        := rSRD({"730","733","736","737","738"})
			TRB->PROVFER     := rSRT({"830","831","832","833","834"})
			TRB->PROV13      := rSRT({"845","846","847","848"}) 
			TRB->PROVFGTS    := rSRD({"858"})
			TRB->VREMPRESA   := rSRD({"788"})
			TRB->VTEMPRESA   := rSRD({"786"})
			TRB->AMEMPRESA   := rSRD({"725","726","789"})
			MsUnLock()

		DbSelectArea("SRA")
		DbSkip()
		                      	
	Enddo

return //fim static funcion

//--------------------------------------------------------------------------------------------------------------------------------------------
static function rSRD(aVerbas) //srd
	Local aSaveArea := GetArea()
	Local nTotal	:= 0.0
	
	dbSelectArea("SRD")
	dbSetOrder(1) //FILIAL  +MATRICULA  +DT ARQ  +VERBA
	For i:=1 to Len(aVerbas)
		dbSeek(xFilial("SRD")+SRA->RA_MAT+MV_PAR05+aVerbas[i])
		nTotal += SRD->RD_VALOR
	Next
	
	RestArea(aSaveArea)
return nTotal //FIM rSRD
//-------------------------------------------------------------------------------------------------------------------------------------------
static function rSRT(aVerbas) //srt
	Local aSaveArea := GetArea()
	Local nTotal	:= 0.0
	
	dbSelectArea("SRT")
	DBOrderNickName("SRT_MATRIC") //FILIAL  +MATRICULA  +VERBA     +DT CÁLC  (CRIAR INDICE)
	For i:=1 to Len(aVerbas)
		dbSeek(xFilial("SRT")+SRA->RA_MAT+aVerbas[i]+MV_PAR05)
		nTotal += SRT->RT_VALOR
	Next
	
	RestArea(aSaveArea)
return nTotal  //FIM rSRT
//-------------------------------------------------------------------------------------------------------------------------------------------
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
cCusto := " "

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

//_cCC := _cFunc := ""

// +------------------------------+
// | Monta Cabeçalho do Relatório |
// +------------------------------+
//                                                                                                          1         1         1         1         1         1         1         1         1         1         2         2         2         2         2
//                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4
//      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99  9.999.999,99
Cabec1 :=  "MATRIC  NOME                                                              SALARIO        PREMIO          BASE          INSS          INSS          FGTS      PROVISAO      PROVISAO      PROVISAO          V.R.          V.T.    ASS.MEDICA
Cabec2 :=  "                                                                           MENSAL                  CALC. INSS       EMPRESA      FUNCION.        DO MES     DE FERIAS        DE 13o          FGTS       EMPRESA       EMPRESA       EMPRESA

DbSelectArea("TRB")
DbSetOrder(1)

SetRegua(RecCount())

DbGoTop()

While !Eof()
		IncRegua()

		// +---------------------------------------------+
		// | Verifica se houve Cancelamento pelo Usuário |
		// +---------------------------------------------+

		If lAbortPrint
			@ nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf

		// +-------------------------------------+
		// | Impressão do Cabeçalho do Relatório |
		// +-------------------------------------+

		If	nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf

		// +-------------------------------------------------------+
		// | Impressão da Quebra do Relatório por Centro de Custos |
		// +-------------------------------------------------------+

		If cCusto != TRB->DCCUSTO
			@ nLin , 000 Psay ""
			nLin++
			@ nLin , 000 Psay "CENTRO DE CUSTO: "+TRB->DCCUSTO
			nLin++
			cCusto := TRB->DCCUSTO
      Endif

		@ nLin , 000 Psay TRB->MATRICULA
		@ nLin , 011 Psay TRB->NOME
		@ nLin , 072 Psay Str(TRB->SALARIO,12,2) 
		@ nLin , 086 Psay Str(TRB->PREMIO,12,2)
		@ nLin , 100 Psay Str(TRB->INSSBASE,12,2)
		@ nLin , 114 Psay Str(TRB->INSSEMPR,12,2)
		@ nLin , 128 Psay Str(TRB->INSSFUNC,12,2)
		@ nLin , 142 Psay Str(TRB->FGTS,12,2)
		@ nLin , 156 Psay Str(TRB->PROVFER,12,2)
		@ nLin , 170 Psay Str(TRB->PROV13,12,2)
		@ nLin , 184 Psay Str(TRB->PROVFGTS,12,2)
		@ nLin , 198 Psay Str(TRB->VREMPRESA,12,2)
		@ nLin , 212 Psay Str(TRB->VTEMPRESA,12,2)
		@ nLin , 226 Psay Str(TRB->AMEMPRESA,12,2)
		nLin += 1			

		DbSelectArea("TRB")
		DbSkip()
Enddo

// +----------------------------------+
// | Finaliza a Execução do Relatório |
// +----------------------------------+

Set Device to Screen

// +---------------------------------------------------------+
// | Se Impressão em Disco, chama o Gerenciador de Impressão |
// +---------------------------------------------------------+

If aReturn[5] == 1
	DbCommitAll()
	Set Printer to
	OurSpool(wnrel)
EndIf

Ms_Flush()

Return