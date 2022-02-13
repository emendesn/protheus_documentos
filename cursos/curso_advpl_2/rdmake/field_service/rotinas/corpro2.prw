#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#DEFINE OPEN_FILE_ERROR -1
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CorProd  บAutor  ณEdson Rodrigues     บ Data ณ  28/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que corrige o processo  Producao na(s) seguinte(s)บฑฑ
ฑฑบ          ณ Situacao(oes) : Nao apontamento do componente na producao  บฑฑ
ฑฑบ          | Ja encerrada                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CorPro2()
Local  cqry
Local  _nopcao
Local ccorrige := "2"


u_GerA0003(ProcName())

PREPARE ENVIRONMENT EMPRESA  '02' FILIAL '02'  TABLES "SD1","SC2","ZZ4","SD3","SB1","SBM","SB2","SX5","ZZ4","ZZ3"

Private nTamNfe  := TAMSX3("D1_DOC")[1]
Private nTamNfs  := TAMSX3("D2_DOC")[1]
Private nTdocD3  := TAMSX3("D3_DOC")[1]
Private nTcodpr  := TAMSX3("B1_COD")[1]



IF ccorrige $ "1/3"
                                                                            
    
    IF ccorrige = "1"              
    
        //Seleciona os Registros
        cqry:=" SELECT * FROM SD3020 WHERE D3_COD IN ('1224-9495','1224-9494') AND D_E_L_E_T_='' AND "
        cqry+=" D3_TM='502' AND D3_EMISSAO='20110311' AND D3_ESTORNO<>'S'"
    ELSE
      cqry:=" SELECT  ZZ4_CODPRO,A.* FROM SC2020 A  "
      cqry+=" INNER JOIN (SELECT ZZ4_FILIAL,ZZ4_OS,ZZ4_CODPRO FROM ZZ4020 B WHERE D_E_L_E_T_='' AND ZZ4_OPEBGH='S03') AS ZZ4 "
      cqry+=" ON ZZ4_OS=C2_NUM                                                                                     "
      cqry+=" LEFT OUTER JOIN (SELECT D3_OP,D3_COD,D3_DOC FROM SD3020  WHERE D3_OP<>'' AND D_E_L_E_T_='' AND D3_ESTORNO<>'S') AS D3 "
      cqry+=" ON LEFT(C2_NUM,6)=LEFT(D3_OP,6)                                                                                       "
      cqry+=" WHERE C2_PRODUTO='RF1224-9495' AND D_E_L_E_T_='' AND YEAR(C2_EMISSAO)=2011                                            "
      cqry+=" AND C2_QUJE=0 AND D3_OP IS NULL                                                                                       "
                                                                                                                                    
    ENDIF    
        

    dbselectarea("ZZJ")
    ZZJ->(dbsetOrder(1)) // ZZJ_FILIAL + ZZJ_OPEBGH+ ZZJ_LAB

    dbselectarea("SB2")
    SB2->(DBSetOrder(1)) //B1_FILIAL+B1_COD

   if select("TRB") > 0
     	TRB->(dbclosearea())
   endif


   TCQUERY cqry NEW ALIAS "TRB"
   ProcRegua(TRB->(reccount()))

   TRB->(dbGoTop())
   While TRB->(!eof())
	
     // Incrementa a regua
	 IncProc()
	  
	 IF ccorrige = "1" 
	   _cNumOS    := LEFT(TRB->D3_OP,6)
	   _cprod     := TRB->D3_COD
	   _cunmed    := TRB->D3_UM
	   _nqtde     := TRB->D3_QUANT
	    carmproc   := TRB->D3_LOCAL       
	   cnumseq    := TRB->D3_NUMSEQ                                 
	   cCchave    := TRB->D3_CHAVE                                 
	   nrecno     := TRB->R_E_C_N_O_                                                                                                                                    
	   lInclui    := .F.
	    nOpcao    :=3
	 ELSE
	   _cNumOS    := LEFT(TRB->C2_NUM,6)
	   _cprod     := TRB->ZZ4_CODPRO
	   _cunmed    := TRB->C2_UM
	   _nqtde     := TRB->C2_QUANT
       carmproc   := TRB->C2_LOCAL       
	   cnumseq    := NIL                                 
	   cCchave    := NIL                                 
	   nrecno     := 0                                                                                                                                    
	   lInclui    := .T.
	    nOpcao    := 1
	 ENDIF  
	   
	   
	   
	   _atransp   := {}
	   ltransf    := .T.	   
	   _lgertrans := .T.
	   CPARTNR    := SPACE(15)          
	   _cFaseenc  := ""
	   _lencrrado := iif(empty(_cFaseenc),.f.,.t.)
	   _lexctrapo := .f.
	   _linclreq  := .f.
	   _lprod     := .T.
	   _cdocto    :=""
	   coperac    :="S03"                         
	  
	
	
	  If ZZJ->(dbseek(xFilial("ZZJ")+coperac))
		carmcomp   :=LEFT(ZZJ->ZZJ_ARMENT,2)
		carmpeca   :=ZZJ->ZZJ_ALMEP
		carmpacab  :=ZZJ->ZZJ_ALMPRO
		cmovprod   :=ZZJ->ZZJ_CODPRO
		carmscrap  :=ZZJ->ZZJ_ALMSCR
		cprefixpa  :=ALLTRIM(ZZJ->ZZJ_PREFPA)
		_cfascrap  :=ZZJ->ZZJ_FASSCR
		_clab      :=ZZJ->ZZJ_LAB
		cmovcons   :=ZZJ->ZZJ_CODSF5    
		_ccoper   :=ZZJ->ZZJ_CC
	  Else
		Return
	  Endif
	
	  _linclreq:=u_REQ_EST(nOpcao,_cprod,carmproc,_nqtde,_cNumOS+'01001',DATE(),cnumseq,cmovcons,cCchave,nrecno,_lprod,_cNumOS+'01001',_ccoper)
	
	  TRB->(DBSKIP())
   ENDDO                               

ELSEIF  ccorrige=="2"

   cqry:=" SELECT C2_FILIAL,C2_NUM,ZZ4_OS,C2_QUJE,C2_EMISSAO,C2_QUANT,C2_ITEM,C2_PRODUTO,C2_LOCAL,C2_CC,C2_UM " 
   cqry+=" FROM SC2020 LEFT JOIN "
   cqry+=" (SELECT ZZ4_FILIAL,ZZ4_OS FROM ZZ4020 WHERE D_E_L_E_T_='' AND ZZ4_OPEBGH='S03') AS ZZ4020 "
   cqry+=" ON C2_FILIAL=ZZ4_FILIAL AND C2_NUM=ZZ4_OS "
   cqry+=" WHERE D_E_L_E_T_='' AND ZZ4_OS IS NULL  "
   cqry+=" ORDER BY C2_EMISSAO "

   if select("TRB") > 0
	TRB->(dbclosearea())
   endif

   TCQUERY cqry NEW ALIAS "TRB"
   ProcRegua(TRB->(reccount()))

   TRB->(dbGoTop())
   While TRB->(!eof())    
     _ageraop :={}
     lInclui:=.F.
	 // Incrementa a regua
	 IncProc()             
	
	 AADD(_ageraop,TRB->C2_NUM)
	 AADD(_ageraop,TRB->C2_ITEM)
	 AADD(_ageraop,"001")
	 AADD(_ageraop,TRB->C2_PRODUTO)
	 AADD(_ageraop,TRB->C2_LOCAL)
	 AADD(_ageraop,ALLTRIM(TRB->C2_CC))
	 AADD(_ageraop,TRB->C2_QUANT)
	 AADD(_ageraop,TRB->C2_UM)


     lretop:= U_BGHOP001(_ageraop,lInclui)   
      
     TRB->(DBSKIP())
   Enddo
Endif   
   
Return