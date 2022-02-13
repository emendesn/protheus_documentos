#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  01/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ValAB9SN(cAB9SN)
Local cQryAtend    
Local cResult   :=''
Local aSaveArea := GetArea()   
Local cAB9SN    := alltrim(cAB9SN)+(SPACE(20)-LEN(ALLTRIM(cAB9SN))) 


u_GerA0003(ProcName())
    
cQryAtend:=' Select AB7_NUMOS,AB7_ITEM '                  //Conta quantos registros
cQryAtend+=' FROM '+RetSQLName('AB7')+' AB7 (nolock)'    //Ordem de Servico
cQryAtend+=" where AB7_FILIAL='"+xFilial('AB7')+"' and " //Filtra por filial
cQryAtend+=" AB7.D_E_L_E_T_<>'*' AND"                     //Filtra deletados    
cQryAtend+=" (AB7_TIPO='1' OR "                           //Filtra OS
cQryAtend+=" AB7_TIPO='3' ) AND"                          //Filtra Em Atendimento
cQryAtend+=" AB7_NUMSER='"+cAB9SN+"'"          //Filtra Numero de Serie

TCQUERY cQryAtend NEW ALIAS "QRYAtend"                             

if !QRYAtend->(EOF())
   cResult:=QRYAtend->(AB7_NUMOS+AB7_ITEM)
else           
   cResult:=''
   Aviso("Atendimento","OS nao cadastrada ou atendida!",{"OK"})
endif   
	
DBSelectArea('QRYAtend')
//DBCloseArea('QRYAtend')
QRYAtend->(DBCloseArea())   
RestArea(aSaveArea)
Return(cResult)