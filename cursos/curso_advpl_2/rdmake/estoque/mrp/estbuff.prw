#INCLUDE "PROTHEUS.CH"

User Function EstBuff()

Local _aArea	:= GetArea()
Local _aAreaSB1	:= SB1->(GetArea())
Local _cLocBuff := GetMv("MV_LOCBUF",.F.,"BUFFER")
Local _cArmBuff := GetMv("MV_ARMBUF",.F.,"01")
Local _cArmBufA := GetMv("BH_ARMBUA",.F.,"00")
Local _cNConsid := GetNewPar("MV_XENDNCO","QUALIDADE")
Local _cAmzNCon := GetNewPar("MV_XAMZNCO","01")
Local nSldQua   := 0

_cLocBuff := _cLocBuff+Space(15-Len(_cLocBuff))
_cNConsid := _cNConsid+Space(15-Len(_cNConsid))

u_GerA0003(ProcName())

nSaldoSBF := BuscaSBF(SB1->B1_COD,_cArmBuff,_cLOcBuff)//SaldoSBF(_cArmBuff, _cLOcBuff, SB1->B1_COD, NIL, NIL, NIL, .F.)

nSaldoA  := BuscaSBF(SB1->B1_COD,_cArmBufA,_cLOcBuff)//SaldoSBF(_cArmBufA, _cLOcBuff, SB1->B1_COD, NIL, NIL, NIL, .F.)

If !Empty(_cNConsid)
	nSldQua := BuscaSBF(SB1->B1_COD,_cAmzNCon,_cNConsid)//SaldoSBF(_cAmzNCon, _cNConsid, SB1->B1_COD, NIL, NIL, NIL, .F.)
	nSldQua := nSldQua + BuscaSBF(SB1->B1_COD,"20",_cNConsid)//SaldoSBF("20", _cNConsid, SB1->B1_COD, NIL, NIL, NIL, .F.)
EndIf

nSaldoSBF := nSaldoSBF + nSaldoA + nSldQua

RestArea(_aArea)
RestArea(_aAreaSB1)

Return nSaldoSBF


Static Function BuscaSBF(cpeca,carmpeca,cEndpeca)

Local nSalbf := 0 

dbselectarea("SBF")
SBF->(dbsetorder(1))
If SBF->(DBSeek(xFilial('SBF')+left(carmpeca,2)+left(cEndpeca,15)+cpeca))
	nSalbf+=QtdComp(SaldoSBF(left(carmpeca,2),SBF->BF_LOCALIZ,cpeca,SBF->BF_NUMSERI,SBF->BF_LOTECTL,If(Rastro(cpeca, 'S'),SBF->BF_NUMLOTE,'')))
Endif

Return(nSalbf)