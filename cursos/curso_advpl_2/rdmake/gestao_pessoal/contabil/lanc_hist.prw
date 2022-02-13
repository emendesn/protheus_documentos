#include "rwmake.ch"        

User Function Lanc_Hist()    
// Retorna  verba e a descricao :
Local cMes:= ''
cMes := STR(MONTH(DDATABASE),2)+'/'+ALLTRIM(STR(YEAR(DDATABASE),4))
_Area := GetArea()
_cConta := Space(64)

u_GerA0003(ProcName())

dbSelectArea("SRV")
Posicione("SRV",1,xFilial()+SRZ->RZ_PD,"RV_DESC" )
_cConta := ALLTRIM(SRV->RV_COD+'/'+SRV->RV_DESC)+" CF FL. "+cMes
RestArea(_Area)
Return(_cConta)
