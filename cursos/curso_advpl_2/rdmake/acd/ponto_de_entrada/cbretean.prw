#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

User Function CBRETEAN()     

Local aArea   	:= GetArea()
Local cId 		:= PARAMIXB[1] 
Local aRet 		:= {}                                   
Local cLote     := ''
Local dValid    := ctod('')
Local cNumSerie := Space(20)
Local nQE   	:= 0

dbSelectArea("SB1")
SB1->( DbSetOrder(1) )
SB1->( DBSeek(xFilial("SB1")+cId) )

aRet := {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECTL")[1]),dValid,Padr(cNumSerie,20)}

RestArea(aArea)

Return aRet