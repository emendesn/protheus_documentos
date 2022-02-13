#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function SmtAtFim()

Private cPerg    := "SMTATFIM"

ValPerg(cPerg)
If Pergunte(cPerg,.T.)
	Processa({|| AtuQFim()})
Endif


Return

Static Function AtuQFim()

Private dDtFech := MV_PAR01
Private cCodIni := MV_PAR02
Private cCodFim	:= MV_PAR03
Private cArmIni	:= MV_PAR04
Private cArmFim	:= MV_PAR05

cQuery := " SELECT "
cQuery += " 	B2_COD, "
cQuery += " 	B2_LOCAL, "
cQuery += " 	SB2.R_E_C_N_O_ AS RECSB2 "
cQuery += " FROM "+RetSQLName("SB2")+" SB2 "
cQuery += " WHERE "
cQuery += " 	B2_FILIAL='"+xFilial("SB2")+"' "
cQuery += "     AND B2_COD   BETWEEN '"+cCodIni+"'    AND '"+cCodFim+"'"
cQuery += "     AND B2_LOCAL BETWEEN '"+cArmIni+"'    AND '"+cArmFim+"'"
cQuery += " 	AND SB2.D_E_L_E_T_ = '' "
cQuery += " ORDER BY B2_LOCAL, B2_COD "

If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL1",.F.,.T.)

dbSelectArea("TSQL1")
dbGotop()

Do While TSQL1->(!Eof())
	
	nQFim	  := 0
	nVFim1    := 0
	nVFim2    := 0
	nVFim3    := 0
	nVFim4    := 0
	nVFim5    := 0
	
	dbSelectArea("SB2")
	SB2->(dbGoTo(TSQL1->RECSB2))	

	aSaldoIni := CalcEst(SB2->B2_COD,SB2->B2_LOCAL,dDtFech+1,nil)
	
	nQFim	  := aSaldoIni[01]
	nVFim1    := aSaldoIni[02]//ROUND(aSaldoIni[01] * SB2->B2_CM1,3)
	nVFim2    := ROUND(aSaldoIni[01] * SB2->B2_CM2,3)
	nVFim3    := ROUND(aSaldoIni[01] * SB2->B2_CM3,3)
	nVFim4    := ROUND(aSaldoIni[01] * SB2->B2_CM4,3)
	nVFim5    := ROUND(aSaldoIni[01] * SB2->B2_CM5,3)
	
	Reclock("SB2",.F.)
	SB2->B2_QFIM := nQFim 
	SB2->B2_CM1  := round(nVFim1/nQFim,2)
	SB2->B2_VFIM1:= nVFim1
	SB2->B2_VFIM2:= nVFim2
	SB2->B2_VFIM3:= nVFim3
	SB2->B2_VFIM4:= nVFim4
	SB2->B2_VFIM5:= nVFim5
	Msunlock()

	dbSelectArea("TSQL1")
	DbSkip()
Enddo


Return

Static Function ValPerg(cPerg)
Local aHelp	:= {}

PutSx1(cPerg, '01', 'Fechamento            ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Produto de            ?','' ,'' , 'mv_ch2', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Produto Ate           ?','' ,'' , 'mv_ch3', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Armazem de            ?','' ,'' , 'mv_ch4', 'C', 02, 0,0, 'G', '', '', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Armazem Ate           ?','' ,'' , 'mv_ch5', 'C', 02, 0,0, 'G', '', '', '', ''   , 'mv_par05',,,'','','','','','','','','','','','','','')


Return     