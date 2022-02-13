#INCLUDE "PROTHEUS.CH"

/*
BGHOP007 - MOVIMENTOS INTERNOS DO ESTOQUE

D3_TM
D3_COD
D3_UM
D3_QUANT
D3_OP
D3_LOCAL
D3_EMISSAO      
==============================================================


_cNumSeq         
cLocal := ""

aParam := {}
AADD(aParam,"502") 
dbselectarea("SB1")
dbsetorder(9)
dbgotop()
IF !dbseek(xfilial("SB1")+SZ9->Z9_PARTNR)
	Msgalert("Atenção, PartNr: "+SZ9->Z9_PARTNR+" nao encontrado...")
	return(.f.)
endif
AADD(aParam,SB1->B1_COD) 
AADD(aParam,SB1->B1_UM)
AADD(aPara,SZ9->Z9_QTY)
AADD(aPara,SZ9->Z9_NUMOS+"01001")
AADD(aPara,cLocal)
AADD(aPara,dDatabase) 

IF lExcl
   AADD(aPara,SZ9->Z9_NUMSEQ)
ENDIF 


*/

USER FUNCTION BGHOP007(aDados,lProc,_cNumSeq,lprod)

Local aAuto := {}
Local nOpc  := iif(lProc,3,5) 
LOcal _lRet := .t.
Local cTM      	:= aDados[1] // tipo movimento
Local cCOd     	:= aDados[2] // codigo produto 
Local cUM      	:= aDados[3] // unidade medida
Local nQuant   	:= aDados[4] // quantidade
Local cOP      	:= aDados[5] // codigo op
Local cLocal   	:= aDados[6] // local/armazem
Local dEmissao 	:= aDados[7] // emissao  
Local _cNSeq   	:= IIF(LEN(aDados) > 7, aDados[8],"0")  // NUMSEQ
//Acrescentado Edson Rodrigues - 22/03/10  
Local _clote   	:= aDados[9] // Lote
Local _csublote   := aDados[10] // SubLote
Local _dvalidlote := aDados[11] // Validade Lote
Local _cendreco   := aDados[12] // Endereço
Local _cnumseri   := aDados[13] // Numero de serie
Local _cCHAVE   	:=iif(lProc,"",aDados[14]) 
Local _NRECNO   	:=iif(lProc,0,aDados[15])      
Local _cosseq   	:=aDados[16]
Local _ccusto       :=aDados[17]
local _aAreaSD3 	:= SD3->(GetArea())

Private lMsErroAuto := .F.  // flag execauto    

u_GerA0003(ProcName()) 

IF  lProc
     AADD(aAuto,{"D3_TM"     ,cTM     ,NIL})
     AADD(aAuto,{"D3_COD"    ,cCOD    ,NIL})
     AADD(aAuto,{"D3_UM"     ,cUM     ,NIL})
     AADD(aAuto,{"D3_QUANT"  ,nQuant  ,NIL})
     if lprod // Incluso variavel para indicar se baixa de produção ou nao - Edson Rodrigues - 26/04/10
        AADD(aAuto,{"D3_OP"     ,cOP     ,NIL})
     Endif   
     AADD(aAuto,{"D3_LOCAL"  ,cLocal  ,NIL})
     AADD(aAuto,{"D3_EMISSAO",dEmissao,NIL})  
     AADD(aAuto,{"D3_CC",_ccusto,NIL})  

     //Acrescentado Edson Rodrigues - 22/03/10  
     AADD(aAuto,{"D3_LOTECTL",_clote,NIL})
     AADD(aAuto,{"D3_NUMLOTE",_csublote,NIL})
     AADD(aAuto,{"D3_DTVALID",_dvalidlote,NIL})
     AADD(aAuto,{"D3_LOCALIZ",_cendreco,NIL})
     AADD(aAuto,{"D3_NUMSERI",_cnumseri,NIL})
     AADD(aAuto,{"D3_OSTEC",_cosseq,NIL})  //Inclsuso para guardar o numero da OS gerada - 26/04/10
   //IF !lProc  Alterado Edson Rodrigues - 30/03/10
	//   AADD(aAuto,{"D3_NUMSEQ",_cNSeq,NIL})
ELSE
     //Incluso condição para excluir sempre, pois havia momento que não encontrava o registro para o estorno
      dbselectarea("SD3")          
      dbsetorder(4) 
      SD3->(dbGoto(_NRECNO))
   
      aAdd(aAuto,{"D3_FILIAL" ,XFILIAL("SD3") ,NIL})  
      aAdd(aAuto, {"D3_NUMSEQ" , _cNSeq   , Nil})
      aAdd(aAuto, {"D3_CHAVE" , _cCHAVE   , Nil})
      aAdd(aAuto, {"D3_COD" , cCOD   , Nil})
      aAdd(aAuto, {"INDEX"     , 4        , Nil})
     
ENDIF	   
	   


MSExecAuto({|x,y| MATA240(x,y)},aAuto,nOpc)  

If lMsErroAuto
    DisarmTransaction()
    Mostraerro()
	_lRet := .F. 
	RETURN(_lRet)
else
	_lRet := .T.
	_cNumSeq := SD3->D3_NUMSEQ
EndIf

restarea(_aAreaSD3)

RETURN(_lRet)