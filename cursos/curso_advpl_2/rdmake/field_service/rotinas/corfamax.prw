#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"              
#include "tbiconn.ch"                                
#DEFINE OPEN_FILE_ERROR -1  
#define ENTER CHR(10)+CHR(13)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Corfamax บAutor  ณEdson Rodrigues     บ Data ณ  14/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para correcao da fase Max / setor Max e Grau Max  บฑฑ
ฑฑบ          ณ gravado no ZZ4                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico BGH                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/              
                                      
User function Corfamax()
_cqry :=""                                                              
_clab :="1"
_nrecno:=0

u_GerA0003(ProcName())
                                                
//PREPARE ENVIRONMENT EMPRESA  "02" FILIAL  "02" TABLES "ZZ1","ZZ3","ZZ4"

//CORGRREC()                

_cqry:= " SELECT ZZ30.ZZ3_FILIAL AS FILIAL,ZZ30.ZZ3_IMEI AS IMEI ,ZZ30.ZZ3_NUMOS AS OS,MAX(ZZ1_GRAU) AS GRAU "+ENTER
_cqry+= " FROM "+RETSQLNAME("ZZ3")+" ZZ30 (NOLOCK)                                                            "+ENTER
_cqry+= " INNER JOIN                                                                                          "+ENTER
_cqry+= "     (SELECT ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1,ZZ1_GRAU                                                   "+ENTER
_cqry+= "      FROM "+RETSQLNAME("ZZ1")+" (NOLOCK)                                                            "+ENTER
_cqry+= "      WHERE ZZ1_FILIAL='"+XFILIAL("ZZ1")+"' AND D_E_L_E_T_='') AS ZZ1                                "+ENTER
_cqry+= " ON ZZ1_LAB=ZZ3_LAB AND ZZ1_CODSET=ZZ3_CODSE2 AND ZZ3_FASE2=ZZ1_FASE1                                 "+ENTER
_cqry+= " WHERE ZZ30.ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ30.ZZ3_LAB='"+_clab+"' AND ZZ30.D_E_L_E_T_=''      "+ENTER 
_cqry+= "       AND ZZ30.ZZ3_STATUS='1' AND ZZ30.ZZ3_ESTORN<>'S'                                               "+ENTER
//_cqry+= "       AND ZZ30.ZZ3_DATA>='20100101' AND ZZ30.ZZ3_ESTORN<>'S'                                         "+ENTER
_cqry+= "        AND ZZ30.ZZ3_ESTORN<>'S'                                                                      "+ENTER
_cqry+= " GROUP BY ZZ30.ZZ3_FILIAL,ZZ30.ZZ3_IMEI,ZZ30.ZZ3_NUMOS                                                "+ENTER
_cqry+= " ORDER BY ZZ30.ZZ3_FILIAL,ZZ30.ZZ3_NUMOS DESC                                                         "+ENTER
   

Dbselectarea("ZZ4")
ZZ4->(dbSetOrder(1))  // ZZ4_FILIAL + ZZ4_IMEI + ZZ4_NUMOS 

Dbselectarea("ZZ3")
ZZ3->(dbSetOrder(1))  // ZZ3_FILIAL + ZZ3_IMEI + ZZ3_NUMOS + ZZ3_SEQ 

ZZ1->(dbSetOrder(1))  // ZZ1_FILIAL + ZZ1_LAB + ZZ1_CODSET + ZZ1_FASE1




if select("TRB") > 0
	TRB->(dbclosearea())
endif


TCQUERY _cqry NEW ALIAS "TRB"

TRB->(dbGoTop())
While TRB->(!eof())
_nrecno:=_nrecno+1
   TRB->(DBSKIP())
Enddo                          


ProcRegua(_nrecno)

Dbselectarea("TRB")
TRB->(dbGoTop())
While TRB->(!eof())

    _cos     := TRB->OS
    _cimei   := TRB->IMEI
    _cgrau   := TRB->GRAU
    _nreczz3 := 0
    _afased  := {}
    lexitzz4 := .f.   
    lexitzz1 := .f.
    _cChave  := ""
    _cdfmax  := ""
         
    If empty(_cgrau) 
       _nreczz3:=BUSFSULT(_cos,_cimei)          
	   
	   If ZZ4->(dbSeek(xFilial("ZZ4") + _cimei  + _cos )) 
	         lexitzz4:=.t.
	   Endif				
          
	
	   If _nreczz3 > 0 .and. lexitzz4
          
          ZZ3->(dbgoto(_nreczz3))
          _cChave := xFilial("ZZ1") + ZZ3->ZZ3_LAB + ZZ3->ZZ3_CODSE2 + ZZ3->ZZ3_FASE2
        
          if ZZ1->(dbSeek(_cChave)) 
            lexitzz1 :=.t.
            _cdfmax  :=ZZ1->ZZ1_DESFA1
          Endif
         
          IF  !EMPTY(ZZ4->ZZ4_GRMAX) .or. !ZZ4->ZZ4_FASMAX==ZZ3->ZZ3_FASE2 .or. !ZZ4->ZZ4_SETMAX==ZZ3->ZZ3_CODSE2 .or. !ZZ4->ZZ4_DFAMAX==_cdfmax
      
              reclock("ZZ4",.f.)      
                ZZ4->ZZ4_FASMAX := ZZ3->ZZ3_FASE2
				ZZ4->ZZ4_DFAMAX := _cdfmax
				ZZ4->ZZ4_GRMAX  := ""
				ZZ4->ZZ4_SETMAX := ZZ3->ZZ3_CODSE2
         	  msunlock()          
       
          Endif 
       Endif
    
    Else
       _afased :=BUSCFSGR(_cos,_cimei,_cgrau)
       If ZZ4->(dbSeek(xFilial("ZZ4") + _cimei  + _cos )) 
	      lexitzz4:=.t.
	   Endif				
       
       If len(_afased) > 0 .and. lexitzz4
          For x:=1 to len(_afased)
             
             IF !ZZ4->ZZ4_GRMAX==_afased[x,4] .or. !ZZ4->ZZ4_FASMAX==_afased[x,1] .or. !ZZ4->ZZ4_SETMAX==_afased[x,2] .or. !ZZ4->ZZ4_DFAMAX==_afased[x,3]
                   reclock("ZZ4",.f.)      
                   	ZZ4->ZZ4_FASMAX := _afased[x,1]
					ZZ4->ZZ4_DFAMAX := _afased[x,3]
					ZZ4->ZZ4_GRMAX  := _afased[x,4]
					ZZ4->ZZ4_SETMAX := _afased[x,2]
           		  msunlock()          
             ENDIF                               
          Next 
       Endif 
    Endif                                   
   IncProc( "Proc dados...OS :"+TRB->OS+" " )
   TRB->(DBSKIP())
Enddo                          
Return()




//Busca Fase,  Setor e Descricao do grau maior 
STATIC FUNCTION BUSCFSGR(_cos,_cimei,_cgrau)
Local _cqry :=""
_areturn    :={}

_cqry:= " SELECT ZZ30.ZZ3_FILIAL AS FILIAL ,ZZ30.ZZ3_IMEI AS IMEI ,ZZ30.ZZ3_NUMOS AS OS,MAX(ZZ1_GRAU) AS GRAU,"+ENTER
_cqry+= " ZZ3_CODSE2,ZZ3_FASE2,ZZ1_DESFA1                                                                     "+ENTER
_cqry+= " FROM "+RETSQLNAME("ZZ3")+" ZZ30 (NOLOCK)                                                            "+ENTER
_cqry+= " INNER JOIN                                                                                          "+ENTER
_cqry+= "     (SELECT ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1,ZZ1_GRAU,ZZ1_DESFA1                                                   "+ENTER
_cqry+= "      FROM "+RETSQLNAME("ZZ1")+" (NOLOCK)                                                            "+ENTER
_cqry+= "      WHERE ZZ1_FILIAL='"+XFILIAL("ZZ1")+"' AND D_E_L_E_T_='') AS ZZ1                                "+ENTER
_cqry+= " ON ZZ1_LAB=ZZ3_LAB AND ZZ1_CODSET=ZZ3_CODSE2 AND ZZ3_FASE2=ZZ1_FASE1                                 "+ENTER
_cqry+= " WHERE ZZ30.ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ30.ZZ3_LAB='"+_clab+"'                             "+ENTER
_cqry+= "       AND ZZ30.ZZ3_IMEI='"+_cimei+"' AND ZZ30.ZZ3_NUMOS='"+_cos+"' AND ZZ30.ZZ3_STATUS='1'           "+ENTER
_cqry+= "       AND ZZ1.ZZ1_GRAU='"+_cgrau+"' AND ZZ30.ZZ3_ESTORN<>'S' AND ZZ30.D_E_L_E_T_=''                     "+ENTER                                                
_cqry+= " GROUP BY ZZ30.ZZ3_FILIAL,ZZ30.ZZ3_IMEI,ZZ30.ZZ3_NUMOS,ZZ3_CODSE2,ZZ3_FASE2,ZZ1_DESFA1                "+ENTER
_cqry+= " ORDER BY ZZ30.ZZ3_FILIAL,ZZ30.ZZ3_IMEI,ZZ30.ZZ3_NUMOS,ZZ3_CODSE2,ZZ3_FASE2,ZZ1_DESFA1                "+ENTER


if select("TRB2") > 0
	TRB2->(dbclosearea())
endif


TCQUERY _cqry NEW ALIAS "TRB2"
ProcRegua(TRB2->(reccount()))

Dbselectarea("TRB2")
TRB2->(dbGoTop())
While TRB2->(!eof())
    AADD(_areturn,{TRB2->ZZ3_FASE2,TRB2->ZZ3_CODSE2,TRB2->ZZ1_DESFA1,TRB2->GRAU})
  TRB2->(Dbskip())
Enddo

Return(_areturn)



//Busca Ultimo Regitstro ZZ3
STATIC FUNCTION BUSFSULT(_cos,_cimei)
Local _cqry := ""
_nreturn    := 0

_cqry:= " SELECT MAX(R_E_C_N_O_) AS RECNOZZ3         "+ENTER
_cqry+= " FROM "+Retsqlname("ZZ3")+" ZZ323 (NOLOCK)  "+ENTER  
_cqry+= " WHERE ZZ3_FILIAL='02' AND ZZ3_LAB='2'      "+ENTER
_cqry+= " AND ZZ3_IMEI='"+_cimei+"' AND ZZ3_NUMOS='"+_cos+"'  "+ENTER
_cqry+= " AND D_E_L_E_T_=''                                    "+ENTER
_cqry+= " GROUP BY ZZ3_FILIAL,ZZ3_IMEI,ZZ3_NUMOS               "+ENTER


if select("TRB3") > 0
	TRB3->(dbclosearea())
endif


TCQUERY _cqry NEW ALIAS "TRB3"
ProcRegua(TRB3->(reccount()))

Dbselectarea("TRB3")
TRB3->(dbGoTop())
While TRB3->(!eof())
    _nreturn:=TRB3->RECNOZZ3
  TRB3->(Dbskip())
Enddo

Return(_nreturn)



// Programa para corrigir fase/setor em que o grau maior nao corresponde fase/setor do maior recno 
// devido a duplicidade de registro de apontamento da fase/setor 2.
STATIC FUNCTION CORGRREC()

// FAZER PROGRAMA PARA PEGAR A FASE/SETOR DE MAIOR GRAU REFERENTE AO MAIOR RECNO
_cqry:= " SELECT ZZ4_FILIAL,ZZ4_IMEI,ZZ4_OS,ZZ4_FASMAX,ZZ4_SETMAX,ZZ4_GRMAX,GRAU,ZZ3_CODSE2,ZZ3_FASE2,SEQ "+ENTER
_cqry+= " FROM "+RETSQLNAME("ZZ4")+" AS ZZ4 "+ENTER 
_cqry+= " INNER JOIN "+ENTER 
_cqry+= "       (SELECT ZZ3_FILIAL,ZZ3_IMEI,ZZ3_NUMOS,ZZ3_FASE2,ZZ3_CODSE2,MAX(ZZ1_GRAU) AS GRAU,COUNT(ZZ3_SEQ) AS SEQ "+ENTER 
_cqry+= "        FROM "+RETSQLNAME("ZZ3")+" AS ZZ31 "+ENTER  
_cqry+= "        INNER JOIN ( SELECT ZZ1_LAB,ZZ1_CODSET,ZZ1_FASE1,ZZ1_GRAU "+ENTER 
_cqry+= "                     FROM "+RETSQLNAME("ZZ1")+" WHERE ZZ1_FILIAL='"+XFILIAL("ZZ1")+"' AND D_E_L_E_T_='') AS ZZ1 "+ENTER 
_cqry+= "        ON ZZ1_LAB=ZZ3_LAB AND ZZ1_CODSET=ZZ3_CODSE2 AND ZZ3_FASE2=ZZ1_FASE1 "+ENTER 
_cqry+= "        WHERE ZZ3_FILIAL='"+XFILIAL("ZZ3")+"' AND ZZ3_LAB='"+_clab+"' AND ZZ31.D_E_L_E_T_='' AND ZZ3_STATUS='1' AND ZZ3_ESTORN<>'S' "+ENTER  
_cqry+= "        GROUP BY ZZ3_FILIAL,ZZ3_IMEI,ZZ3_NUMOS,ZZ3_FASE2,ZZ3_CODSE2) AS ZZ3 "+ENTER 
_cqry+= " ON ZZ4_FILIAL=ZZ3_FILIAL AND ZZ4_IMEI=ZZ3_IMEI AND LEFT(ZZ4_OS,6)=LEFT(ZZ3_NUMOS,6) "+ENTER  
_cqry+= " WHERE ZZ4_FILIAL='"+XFILIAL("ZZ4")+"' AND D_E_L_E_T_='' AND ZZ4_GRMAX=GRAU AND ZZ4_GRMAX<>'' "+ENTER 
_cqry+= " AND (ZZ4_SETMAX<>ZZ3_CODSE2 OR ZZ4_FASMAX<>ZZ3_FASE2) "+ENTER 
_cqry+= " ORDER BY ZZ4_FILIAL,ZZ4_IMEI,ZZ4_OS,SEQ "+ENTER 


Return()

