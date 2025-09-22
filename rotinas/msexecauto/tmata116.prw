User Function Tmata116()

Local aCabNFR   :={}
Local aItensNFR := {}

lMsErroAuto := .F.

aadd(aCabNFR,{"MV_PAR11",Ctod('01/01/01') ,nil})
aadd(aCabNFR,{"MV_PAR12",Ctod('31/12/01') ,nil})
aadd(aCabNFR,{"MV_PAR13",2             ,nil})  //2 GERA 1 EXCLUI
aadd(aCabNFR,{"MV_PAR14",'999999'         ,nil})
aadd(aCabNFR,{"MV_PAR15",'01'             ,nil})
aadd(aCabNFR,{"MV_PAR16",1                ,nil})
aadd(aCabNFR,{"MV_PAR17",2                ,nil})
aadd(aCabNFR,{"MV_PAR18",'SP'             ,nil})

aadd(aCabNFR,{"MV_PAR21",150      ,nil})           //so p/ inclusao
aadd(aCabNFR,{"MV_PAR22",1        ,nil})
aadd(aCabNFR,{"MV_PAR23","999999" ,nil})
aadd(aCabNFR,{"MV_PAR24",'FRE'    ,nil})
aadd(aCabNFR,{"MV_PAR25",'999999' ,nil})
aadd(aCabNFR,{"MV_PAR26",'01'     ,nil})
aadd(aCabNFR,{"MV_PAR27",'110'    ,nil})
aadd(aCabNFR,{"MV_PAR28",0        ,nil})
aadd(aCabNFR,{"MV_PAR29",0        ,nil})
aadd(aCabNFR,{"MV_PAR31","001" ,nil})

aItensNFR := {	{{"AUTNOTA","999999   ",nil}}}

MsExecAuto({|x,y| MATA116(x,y)},aCabNFR,aItensNFR)

/*
aadd(aCabNFR,{"MV_PAR11",Ctod('01/01/01')	,nil})
aadd(aCabNFR,{"MV_PAR12",Ctod('31/12/01')	,nil})
aadd(aCabNFR,{"MV_PAR13",1             	,nil})  //2 GERA 1 EXCLUI
aadd(aCabNFR,{"MV_PAR14",'999999'         	,nil})
aadd(aCabNFR,{"MV_PAR15",'01'             	,nil})
aadd(aCabNFR,{"MV_PAR16",1                	,nil})
aadd(aCabNFR,{"MV_PAR17",2                	,nil})
aadd(aCabNFR,{"MV_PAR18",'SP'             	,nil})

aItensNFR := {	{{"AUTNOTA","999999   ",nil}}}

MsExecAuto({|x,y| MATA116(x,y)},aCabNFR,aItensNFR)
*/

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return
