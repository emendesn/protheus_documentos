#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+---------------+-------+------------+
| Programa:  | BATFR01 | Autor: | Flávio Sardão | Data: | Junho/2011 |
+------------+---------+--------+---------------+-------+------------+
| Descrição: | Relatório Sintético de Movimentação do Ativo Fixo.    |
+------------+-------------------------------------------------------+
| Uso:       | BGH do Brasil Ltda.                                   |
+------------+----------------------------------+--------------------+
| Variáveis de Usuário Utilizadas em Parâmetros |
+----------+------------------------------------+
| mv_par01 | Data Inicial            ?          |
| mv_par02 | Data Final              ?          |
| mv_par03 | Conta Inicial           ?          |
| mv_par04 | Conta Final             ?          |
| mv_par05 | Relatório em qual Moeda ?          |
+----------+------------------------------------+
*/

User Function BATFR01

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local cDesc1        := "Este Programa tem como Objetivo imprimir o Relatório "
Local cDesc2        := "de acordo com os Parâmetros informados pelo Usuário. "
Local cDesc3        := "Movimentação Sintética do Ativo Fixo."
Local cPict         := ""
Local Titulo        := "Movimentação Sintética do Ativo Fixo"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local Imprime       := .t.
Local aOrd          := {}
Local _cArq1        := ""
Local _cInd1        := ""
Local _aStru1       := {}

Private lEnd        := .f.
Private lAbortPrint := .f.
Private Limite      := 220
Private Tamanho     := "G"
Private NomeProg    := "BATFR01"
Private nTipo       := 15
Private aReturn     := {"Zebrado",1,"Administração",1,2,1,"",1}
Private nLastKey    := 0
Private cPerg       := "BATFR01   "
Private cBTxt       := Space(10)
Private cBCont      := 0
Private ContFl      := 1
Private m_pag       := 1
Private wnrel       := "BATFR01"
Private cString     := "SN4"


u_GerA0003(ProcName())

// +---------------------------------------------------------+
// | Monta Tabela Temporária para Gravar dados do Ativo Fixo |
// +---------------------------------------------------------+

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	DbSelectArea("SN4")
EndIf

AADD(_aStru1,{"CONTA" ,"C",20,0})
AADD(_aStru1,{"SLDINI","N",18,4})
AADD(_aStru1,{"ADICAO","N",18,4})
AADD(_aStru1,{"DEPREC","N",18,4})
AADD(_aStru1,{"BAIXAS","N",18,4})
AADD(_aStru1,{"TRANSF","N",18,4})
AADD(_aStru1,{"SLDFIM","N",18,4})

_cArq1 := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,_cArq1,"TRB1",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("TRB1",_cInd1,"CONTA",,,"Selecionando Registros...")

DbSelectArea("SN4")
DbSetOrder(1)

_fValPerg()

Pergunte(cPerg,.f.)

// +--------------------------------------+
// | Monta Interface Padrão com o Usuário |
// +--------------------------------------+

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.f.,Tamanho,,.t.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

nTipo := IIF(aReturn[4] == 1,15,18)

// +-----------------------------------------+
// | Processa Dados para a Tabela Temporária |
// +-----------------------------------------+

Processa({|| RunCont() },"Processando...")

// +-------------------------------------------+
// | Monta Janela com a Régua de Processamento |
// +-------------------------------------------+

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},Titulo)

// +---------------------------+
// | Apaga Tabelas Temporárias |
// +---------------------------+

DbSelectArea("TRB1")
DbCloseArea()

fErase(_cInd1 + OrdBagExt())
fErase(_cArq1 + ".DTC")

Return

/*
+---------+---------+--------+---------------+-------+------------+
| Função: | RunCont | Autor: | Flávio Sardão | Data: | Junho/2011 |
+---------+---------+--------+---------------+-------+------------+
| Uso:    | BGH do Brasil Ltda.                                   |
+---------+-------------------------------------------------------+
*/

Static Function RunCont

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cQrySN4  := ""
Local _lOk      := .t.
Local _cConta   := ""
Local _nSldIni1 := 0
Local _nSldIni3 := 0
Local _nAdicao1 := 0
Local _nAdicao3 := 0
Local _nDeprec1 := 0
Local _nDeprec3 := 0
Local _nBaixas1 := 0
Local _nBaixas3 := 0
Local _nBaixas1 := 0
Local _nBaixas3 := 0
Local _nTransf1 := 0
Local _nTransf3 := 0
Local _nSldFim1 := 0
Local _nSldFim3 := 0

// +---------------------------------------------+
// | Monta Query para trazer dados da Tabela SN4 |
// +---------------------------------------------+

DbSelectArea("SN4")

_cQrySN4 := "Select SN4.* "
_cQrySN4 += "From " + RetSqlName("SN4") + " SN4 "
_cQrySN4 += "Where SN4.N4_CONTA >= '" +      mv_par03  + "' And SN4.N4_CONTA <= '" + mv_par04 + "' "
_cQrySN4 +=   "And SN4.N4_DATA  <= '" + DTOS(mv_par02) + "' And SN4.D_E_L_E_T_ <> '*' "
_cQrySN4 += "Order by N4_CONTA,N4_DATA,N4_CBASE "

If Select("SN4Q") > 0
	DbSelectArea("SN4Q")
	DbCloseArea()
EndIf

TcQuery _cQrySN4 New Alias "SN4Q"

TcSetField("SN4Q","N4_VLROC1","N",18,4)
TcSetField("SN4Q","N4_VLROC3","N",18,4)
TcSetField("SN4Q","N4_DATA"  ,"D")

DbSelectArea("SN4Q")

ProcRegua(RecCount())

DbGoTop()

While !Eof()
		IncProc("(Calc.Saldos) - Conta/Data: " + Alltrim(SN4Q->N4_CONTA) + " - " +;
															Strzero(Day(SN4Q->N4_DATA),2)   + "/" + ;
															Strzero(Month(SN4Q->N4_DATA),2) + "/" + ;
															Strzero(Year(SN4Q->N4_DATA),4))

		// +--------------------------------+
		// | Calcula Saldo Inicial da Conta |
		// +--------------------------------+

		If DTOS(SN4Q->N4_DATA) < DTOS(mv_par01)

			_nSldIni1 += IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "05",SN4Q->N4_VLROC1,0)
			_nSldIni1 += IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "04",SN4Q->N4_VLROC1,0)
			_nSldIni1 += IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC1,0)
			_nSldIni1 += IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "03",SN4Q->N4_VLROC1,0)
			_nSldIni1 += IIF(SN4Q->N4_TIPOCNT == "3" .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC1,0)

			_nSldIni1 -= IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC1,0)
			_nSldIni1 -= IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "03",SN4Q->N4_VLROC1,0)
			_nSldIni1 -= IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "04",SN4Q->N4_VLROC1,0)
			_nSldIni1 -= IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC1,0)

			_nSldIni3 += IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "05",SN4Q->N4_VLROC3,0)
			_nSldIni3 -= IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC3,0)
			_nSldIni3 -= IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "03",SN4Q->N4_VLROC3,0)
			_nSldIni3 += IIF(SN4Q->N4_TIPOCNT == "1" .And. SN4Q->N4_OCORR == "04",SN4Q->N4_VLROC3,0)
			_nSldIni3 -= IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC3,0)
			_nSldIni3 += IIF(SN4Q->N4_TIPOCNT == "4" .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC3,0)
			_nSldIni3 += IIF(SN4Q->N4_TIPOCNT == "3" .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC3,0)
		EndIf

		// +------------------------------------------------------------+
		// | Calcula Adições, Depreciações e Baixas da Conta no Período |
		// +------------------------------------------------------------+

		If DTOS(SN4Q->N4_DATA) >= DTOS(mv_par01) .And. DTOS(SN4Q->N4_DATA) <= DTOS(mv_par02)
			_nAdicao1 += IIF(SN4Q->N4_TIPOCNT $ "1"   .And. SN4Q->N4_OCORR == "05",SN4Q->N4_VLROC1,0)
			_nDeprec1 -= IIF(SN4Q->N4_TIPOCNT $ "4"   .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC1,0)
			_nDeprec1 += IIF(SN4Q->N4_TIPOCNT $ "3"   .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC1,0)
			_nBaixas1 -= IIF(SN4Q->N4_TIPOCNT $ "1"   .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC1,0)
			_nBaixas1 += IIF(SN4Q->N4_TIPOCNT $ "4"   .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC1,0)
			_nTransf1 += IIF(SN4Q->N4_TIPOCNT $ "1/4" .And. SN4Q->N4_OCORR == "03",SN4Q->N4_VLROC1,0)
			_nTransf1 -= IIF(SN4Q->N4_TIPOCNT $ "1/4" .And. SN4Q->N4_OCORR == "04",SN4Q->N4_VLROC1,0)

			_nAdicao3 += IIF(SN4Q->N4_TIPOCNT $ "1"   .And. SN4Q->N4_OCORR == "05",SN4Q->N4_VLROC3,0)
			_nDeprec3 -= IIF(SN4Q->N4_TIPOCNT $ "4"   .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC3,0)
			_nDeprec3 += IIF(SN4Q->N4_TIPOCNT $ "3"   .And. SN4Q->N4_OCORR == "06",SN4Q->N4_VLROC3,0)
			_nBaixas3 -= IIF(SN4Q->N4_TIPOCNT $ "1"   .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC3,0)
			_nBaixas3 += IIF(SN4Q->N4_TIPOCNT $ "4"   .And. SN4Q->N4_OCORR == "01",SN4Q->N4_VLROC3,0)
			_nTransf3 += IIF(SN4Q->N4_TIPOCNT $ "1/4" .And. SN4Q->N4_OCORR == "03",SN4Q->N4_VLROC3,0)
			_nTransf3 -= IIF(SN4Q->N4_TIPOCNT $ "1/4" .And. SN4Q->N4_OCORR == "04",SN4Q->N4_VLROC3,0)
		EndIf

		_cConta := SN4Q->N4_CONTA

		DbSelectArea("SN4Q")
		DbSkip()

		If _cConta != SN4Q->N4_CONTA
			_nSldFim1 := _nSldIni1 + _nAdicao1 + _nDeprec1 + _nBaixas1 + _nTransf1
			_nSldFim3 := _nSldIni3 + _nAdicao3 + _nDeprec3 + _nBaixas3 + _nTransf3

			DbSelectArea("TRB1")

			_lOk := !DbSeek(SN4Q->N4_CONTA,.f.)

			While !RecLock("TRB1",_lOk)
			Enddo
			TRB1->CONTA  := _cConta
			TRB1->SLDINI := IIF(mv_par05 == 1,_nSldIni1,_nSldIni3)
			TRB1->ADICAO := IIF(mv_par05 == 1,_nAdicao1,_nAdicao3)
			TRB1->DEPREC := IIF(mv_par05 == 1,_nDeprec1,_nDeprec3)
			TRB1->BAIXAS := IIF(mv_par05 == 1,_nBaixas1,_nBaixas3)
			TRB1->TRANSF := IIF(mv_par05 == 1,_nTransf1,_nTransf3)
			TRB1->SLDFIM := IIF(mv_par05 == 1,_nSldFim1,_nSldFim3)
			MsUnLock()

			_nSldIni1 := _nAdicao1 := _nDeprec1 := _nBaixas1 := _nTransf1 := _nSldFim1 := 0
			_nSldIni3 := _nAdicao3 := _nDeprec3 := _nBaixas3 := _nTransf3 := _nSldFim3 := 0
		EndIf

Enddo

Return

/*
+---------+-----------+--------+---------------+-------+------------+
| Função: | RunReport | Autor: | Flávio Sardão | Data: | Junho/2011 |
+---------+-----------+--------+---------------+-------+------------+
| Uso:    | BGH do Brasil Ltda.                                     |
+---------+---------------------------------------------------------+
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _nTotIni := 0
Local _nTotAdi := 0
Local _nTotDep := 0
Local _nTotBai := 0
Local _nTotTrf := 0
Local _nTotFim := 0
Local _cDatIni := Strzero(Day(mv_par01),2) + "/" + Strzero(Month(mv_par01),2) + "/" + Strzero(Year(mv_par01),4)
Local _cDatFim := Strzero(Day(mv_par02),2) + "/" + Strzero(Month(mv_par02),2) + "/" + Strzero(Year(mv_par02),4)
//                                                                                                                   1         1         1         1         1         1         1         1         1         1         2         2
//                         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
//               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//               XXXXXXXXX1XXXXXXXXX2 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXXXXXXXX5 9,999,999,999,999.9999 9,999,999,999,999.9999 9,999,999,999,999.9999 9,999,999,999,999.9999 9,999,999,999,999.9999 9,999,999,999,999.9999
//               CONTA                DESCRIÇÃO                                             SALDO EM DD/MM/AAAA                ADIÇÕES           DEPRECIAÇÕES                 BAIXAS         TRANSFERENCIAS    SALDO EM DD/MM/AAAA
Local Cabec1 := "CONTA                DESCRIÇÃO                                             SALDO EM " + _cDatIni + "                ADIÇÕES           DEPRECIAÇÕES                 BAIXAS         TRANSFERENCIAS    SALDO EM " + _cDatFim
Local Cabec2 := ""

DbSelectArea("TRB1")

SetRegua(RecCount())

DbGoTop()

While !Eof()
		IncRegua()

		// +---------------------------------------------+
		// | Verifica se houve Cancelamento pelo Usuário |
		// +---------------------------------------------+

		If lAbortPrint
			@ nLin , 000 Psay "CANCELADO PELO USUÁRIO..."
			Exit
		EndIf

		// +-------------------------------------+
		// | Impressão do Cabeçalho do Relatório |
		// +-------------------------------------+

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf

		DbSelectArea("CT1")
		DbSetOrder(1)
		DbSeek(xFilial("CT1") + TRB1->CONTA,.f.)

		@ nLin , 000 Psay TRB1->CONTA
		@ nLin , 021 Psay CT1->CT1_DESC01
		@ nLin , 072 Psay TRB1->SLDINI					Picture "@E 9,999,999,999,999.9999"
		@ nLin , 095 Psay TRB1->ADICAO					Picture "@E 9,999,999,999,999.9999"
		@ nLin , 118 Psay TRB1->DEPREC					Picture "@E 9,999,999,999,999.9999"
		@ nLin , 141 Psay TRB1->BAIXAS					Picture "@E 9,999,999,999,999.9999"
		@ nLin , 164 Psay TRB1->TRANSF					Picture "@E 9,999,999,999,999.9999"
		@ nLin , 187 Psay TRB1->SLDFIM					Picture "@E 9,999,999,999,999.9999"
		nLin += 1

		_nTotIni += TRB1->SLDINI
		_nTotAdi += TRB1->ADICAO
		_nTotDep += TRB1->DEPREC
		_nTotBai += TRB1->BAIXAS
		_nTotTrf += TRB1->TRANSF
		_nTotFim += TRB1->SLDFIM

		DbSelectArea("TRB1")
		DbSkip()
Enddo

If nLin != 80
	nLin += 2

	@ nLin , 021 Psay "TOTAIS"
	@ nLin , 072 Psay _nTotIni						Picture "@E 9,999,999,999,999.9999"
	@ nLin , 095 Psay _nTotAdi						Picture "@E 9,999,999,999,999.9999"
	@ nLin , 118 Psay _nTotDep						Picture "@E 9,999,999,999,999.9999"
	@ nLin , 141 Psay _nTotBai						Picture "@E 9,999,999,999,999.9999"
	@ nLin , 164 Psay _nTotTrf						Picture "@E 9,999,999,999,999.9999"
	@ nLin , 187 Psay _nTotFim						Picture "@E 9,999,999,999,999.9999"
EndIf

// +----------------------------------+
// | Finaliza a Execução do Relatório |
// +----------------------------------+

Set Device to Screen

// +---------------------------------------------------------+
// | Se Impressão em Disco, Chama o Gerenciador de Impressão |
// +---------------------------------------------------------+

If aReturn[5] == 1
	DbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf

Ms_Flush()

Return

/*
+---------+-----------+--------+---------------+-------+------------+
| Função: | _fValPerg | Autor: | Flávio Sardão | Data: | Junho/2011 |
+---------+-----------+--------+---------------+-------+------------+
| Uso:    | BGH do Brasil Ltda.                                     |
+---------+---------------------------------------------------------+
*/

Static Function _fValPerg()

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg + "01",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Data Inicial            ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	MsUnLock()

EndIf

If !DbSeek(cPerg + "02",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Data Final              ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par02"
	MsUnLock()

EndIf

If !DbSeek(cPerg + "03",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Conta Inicial           ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_DECIMAL := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3      := "CT2"
	MsUnLock()

EndIf

If !DbSeek(cPerg + "04",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Conta Final             ?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_DECIMAL := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := "CT2"
	MsUnLock()

EndIf

If !DbSeek(cPerg + "05",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Relatório em qual Moeda ?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "C"
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := "Reais"
	SX1->X1_DEF02   := "UFIR"
	MsUnLock()

EndIf

Return