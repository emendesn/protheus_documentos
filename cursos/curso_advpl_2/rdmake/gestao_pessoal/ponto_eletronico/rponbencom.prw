#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*
+------------+---------+--------+---------------+-------+--------------+
| Programa:  | RFECPO  | Autor: | Ronaldo Silva | Data: | Novembro/2009|
+------------+---------+--------+---------------+-------+--------------+
| Descrição: | FECHAMENTO DO PONTO PARA COMPRAR BENEFÍCIOS ADICIONAIS  |
+------------+---------------------------------------------------------+
| Uso:       | BGH                                                     |
+------------+---------------------------------------------------------+
*/

User Function RFECPO

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local cDesc1        := "Este Programa tem como Objetivo Imprimir o Relatório "
Local cDesc2        := "de acordo com os Parâmetros informados pelo Usuário. "
Local cDesc3        := "FECHAMENTO DO PONTO PARA COMPRAR BENEFICIOS ADICIONAIS"
Local cPict         := ""
Local Titulo        := "FECHAMENTO DO PONTO PARA COMPRAR BENEFICIOS ADICIONAIS"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local Imprime       := .t.
Local aOrd          := {}

Private lEnd        := .f.
Private lAbortPrint := .f.
Private Limite      := 132
Private Tamanho     := "M"
Private NomeProg    := "RFECPO"
Private nTipo       := 15
Private aReturn     := {"Zebrado",1,"Administração",1,2,1,"",1}
Private nLastKey    := 0
Private cBTxt       := Space(10)
Private cBCont      := 0
Private ContFl      := 1
Private m_pag       := 1
Private wnrel       := "RFECPO"
Private cString     := "SX2"

u_GerA0003(ProcName())

DbSelectArea("SX2")
DbSetOrder(1)

//------------------------------------------------------
// 1) Criando arquivo Temporario
//------------------------------------------------------

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	DbSelectArea("SPC")
EndIf

_aCampos := {} // criando um array vazio....

AADD(_aCampos,{"CCCUSTO"    ,"C",9 ,0}) //SRA->RA_CC 
AADD(_aCampos,{"DCCUSTO"    ,"C",40,0}) //CTT->CTT_DESC01
AADD(_aCampos,{"MATRICULA"  ,"C",6 ,0}) //SRA->RA_MAT
AADD(_aCampos,{"NOME"       ,"C",30,0}) //SRA->RA_NOME
//
AADD(_aCampos,{"TIPAFASTAM" ,"C",1 ,0}) //SR8->R8_TIPO
AADD(_aCampos,{"DESAFASTAM" ,"C",20,0}) //SX5->X5_DESCRI
AADD(_aCampos,{"INIAFASTAM" ,"D",8 ,0}) //SR8->R8_DATAINI
AADD(_aCampos,{"FIMAFASTAM" ,"D",8 ,0}) //SR8->R8_DATAFIM
//
AADD(_aCampos,{"APDATA"     ,"D",8 ,0}) //SPC->PC_DATA
AADD(_aCampos,{"CEVENTO"    ,"C",3 ,0}) //SPC->PC_PD
AADD(_aCampos,{"DEVENTO"    ,"C",20,0}) //SP9->P9_DESC
AADD(_aCampos,{"HEVENTO"    ,"N",6 ,2}) //SPC->PC_QUANTC
AADD(_aCampos,{"CABONO"     ,"C",3 ,0}) //SPC->PC_ABONO
AADD(_aCampos,{"DABONO"     ,"C",25,0}) //SP6->P6_DESC
AADD(_aCampos,{"HABONO"     ,"N",6 ,2}) //SPC->PC_QTABONO

_cArq1 := CriaTrab(_aCampos,.t.)
DbUseArea(.t.,,_cArq1,"TRB1",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("TRB1",_cInd1,"NOME + DTOS(APDATA)",,,"Selecionando Registros...")

// +----------------------------------------+
// | Monta a Interface Padrão com o Usuário |
// +----------------------------------------+

PERGUNTE("RFECPO",.f.) //forca que pegue os parametros pre-existentes para a memoria

wnrel := SetPrint(cString,NomeProg,"RFECPO",@Titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.t.,Tamanho,,.f.)

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

Return

//+---------+---------+--------+---------------+-------+--------------+
//| Função: | RunCont | Autor: | Flávio Sardão | Data: | Outubro/2009 |
//+---------+---------+--------+---------------+-------+--------------+
//| Uso:    | Repom S/A.                                              |
//+---------+---------------------------------------------------------+

Static Function RunCont

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cQrySPC := ""
Local _lSR8    := .f.

// +---------------------------------------------+
// | Grava Informações Solicitadas               |
// +---------------------------------------------+

DbSelectArea("SPC")
DbSetOrder(2)

_cQrySPC :=        "SPC->PC_CC         >= '" +      mv_par01  + "' .And. SPC->PC_CC           <= '" +      mv_par02  + "' "
_cQrySPC += ".And.  SPC->PC_MAT        >= '" +      mv_par03  + "' .And. SPC->PC_MAT          <= '" +      mv_par04  + "' "
_cQrySPC += ".And.  DTOS(SPC->PC_DATA) >= '" + DTOS(mv_par05) + "' .And. DTOS(SPC->PC_DATA)   <= '" + DTOS(mv_par06) + "' "
_cQrySPC += ".And. (SPC->PC_PD         $ '009/127/128/129/130'     .Or.  SPC->PC_ABONO         $ '001/003/004/005/011/012/013/023') "

Set Filter to &_cQrySPC

ProcRegua(RecCount())

DbGoTop()

While !Eof()

		DbSelectArea("SR8")
		DbSetOrder(1)
		DbSeek(xFilial("SR8") + SPC->PC_MAT,.f.)

		While !Eof() .And. SR8->R8_MAT == SPC->PC_MAT

				If SR8->R8_DATAFIM >= mv_par05 .And. SR8->R8_TIPO $ "O/P/Q"
					_lSR8 := .t.
					Exit
				EndIf

				DbSelectArea("SR8")
				DbSkip()
		Enddo

		While !RecLock("TRB1",.t.)
		Enddo
		TRB1->CCCUSTO     := SPC->PC_CC
		TRB1->DCCUSTO     := Posicione("CTT",1,xFilial("CTT") + SPC->PC_CC,"CTT_DESC01")
		TRB1->MATRICULA   := SPC->PC_MAT
		TRB1->NOME        := Posicione("SRA",1,xFilial("SRA") + SPC->PC_MAT,"RA_NOME")
		TRB1->TIPAFASTAM  := SR8->R8_TIPO
		TRB1->DESAFASTAM  := IIF(_lSR8,Posicione("SX5",1,xFilial("SX5") + "30" + SR8->R8_TIPO,"X5_DESCRI"),"")
		TRB1->INIAFASTAM  := IIF(_lSR8,SR8->R8_DATAINI,CTOD("  /  /  "))
		TRB1->FIMAFASTAM  := IIF(_lSR8,SR8->R8_DATAFIM,CTOD("  /  /  "))
		TRB1->APDATA      := SPC->PC_DATA
		TRB1->CEVENTO     := SPC->PC_PD
		TRB1->DEVENTO     := Posicione("SP9",1,xFilial("SP9") + SPC->PC_PD,"P9_DESC")
		TRB1->HEVENTO     := SPC->PC_QUANTC
		TRB1->CABONO      := SPC->PC_ABONO
		TRB1->DABONO      := Posicione("SP6",1,xFilial("SP6") + SPC->PC_ABONO,"P6_DESC")
		TRB1->HABONO      := SPC->PC_QTABONO
		MsUnLock()

		DbSelectArea("SPC")
		DbSkip()
Enddo

/*
+---------+-----------+--------+---------------+-------+--------------+
| Função: | RunReport | Autor: | Ronaldo Silva | Data: | Novembro/2009|
+---------+-----------+--------+---------------+-------+--------------+
| Uso:    | BGH                                                       |
+---------+-----------------------------------------------------------+
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

_cCC := _cFunc := ""

// +------------------------------+
// | Monta Cabeçalho do Relatório |
// +------------------------------+
//                                                                                                             1         1         1         1
//                   1         2         3         4         5         6         7         8         9         0         1         2         3
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//         DD/MM/AA  XXX  XXXXXXXXXXXXXXXXXXXX  XXXXXX  XXX  XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXX
Cabec1 := "DATA      COD  EVENTO                HORAS   COD  ABONO                       HORAS"     

DbSelectArea("TRB1")
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

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf

		// +-------------------------------------------------------+
		// | Impressão da Quebra do Relatório por Centro de Custos |
		// +-------------------------------------------------------+

		If TRB1->NOME != _cFunc
			nLin += IIF(nLin == 8,0,1)

			@ nLin , 000 Psay "Funcionário: " + TRB1->MATRICULA + " " + TRB1->NOME + " - " //+ "Afastamento:" + TRB1->DESAFASTAM //+ " " + "Início:" + TRB1->INIAFASTAM + " " + "Fim:" + TRB1->FIMAFASTAM
			nLin += 1
		EndIf

		@ nLin , 000 Psay TRB1->APDATA
		@ nLin , 010 Psay TRB1->CEVENTO
		@ nLin , 015 Psay TRB1->DEVENTO
		@ nLin , 037 Psay Strzero(TRB1->HEVENTO,5,2)
		@ nLin , 045 Psay TRB1->CABONO
		@ nLin , 050 Psay TRB1->DABONO
		@ nLin , 077 Psay Strzero(TRB1->HABONO,5,2)
		nLin += 1

		_cFunc := TRB1->NOME

		DbSelectArea("TRB1")
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