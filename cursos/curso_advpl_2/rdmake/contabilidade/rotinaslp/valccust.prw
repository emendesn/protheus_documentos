#include "rwmake.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³valccust  ºAutor  ³ Edson Rodrigues    º Data ³06/01/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para validar o centro de custo em :                º±±
±±º          |Lançamentos Conabeis Manual/Automatico da contabilidade     º±±
±±º          ³Movimentacao bancaria                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso   BGH ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function valccust(_nopc)   

                 
_nTcodpr := TAMSX3("CTT_CUSTO")[1]
_nTcondb := TAMSX3("CT2_DEBITO")[1] 
_nTconcr := TAMSX3("CT2_CREDIT")[1]
_cCcustd := Space(_nTcodpr) 
_cCcustc := Space(_nTcodpr) 
_cCcondb := Space(_nTcondb) 
_cCconcr := Space(_nTconcr)
_aconini :={'323','3240103','3240104'}  
_ccexces :='3061'   //Centro de custo excessão quando a conta iniciar com 3 e obrigatorio usar quando a conta inicar com 1 ou 2
_ancaract:={3,7,7}
_lreturn := .t.
_creterro:=nil
_nopc    :=iif(_nopc==nil,0,_nopc)  
_cCcondb := TMP->CT2_DEBITO
_cCconcr := TMP->CT2_CREDIT
_cCcustd := TMP->CT2_CCD
_cCcustc := TMP->CT2_CCC
_ctpldc  := TMP->CT2_DC

u_GerA0003(ProcName())
 

IF _nopc==1
    
   IF _ctpldc='1' .and. empty(_cCcustd)
        _lreturn:=.f.   
        MsgAlert("Centro de Custo Debito nao digitado","CCD nao digitado")                       
        
   ELSEIF _ctpldc='2' .and. empty(_cCcustc)
        _lreturn:=.f.                              
        MsgAlert("Centro de Custo Credito nao digitado","CCC nao digitado")                        
   
   ELSEIF _ctpldc='3' .and. (empty(_cCcustc) .or. empty(_cCcustd))
        _lreturn:=.f.                                                  
        MsgAlert("Centro de Custo Debito ou Credito nao digitado","CCD ou CCC nao digitado")
   ENDIF  

ENDIF


IF _lreturn 
  
  For xccsp:=1 to 3
   
//     IF  _ctpldc=alltrim(str(xccsp))         
     
       
         IF (substr(_cCcondb,1,_ancaract[xccsp]) == _aconini[xccsp] .or. substr(_cCconcr,1,_ancaract[xccsp]) ==_aconini[xccsp])
       
		       If  substr(_cCcondb,1,_ancaract[xccsp]) == _aconini[xccsp] .and.  !empty(_cCcustd) .and. !substr(_cCcustd,1,1) = alltrim(str(xccsp))
		           _lreturn:=.f.           
                   MsgAlert("Para contas debito iniciadas com "+_aconini[xccsp]+ ", o centro de Custo debito tem de iniciar com "+alltrim(str(xccsp))+".","CCD Invalido")
		           exit
		       Elseif substr(_cCconcr,1,_ancaract[xccsp]) ==_aconini[xccsp] .and. !empty(_cCcustc) .and. !substr(_cCcustc,1,1) = alltrim(str(xccsp))
		           _lreturn:=.f.         
                   MsgAlert("Para contas credito iniciadas com "+_aconini[xccsp]+ ", o centro de Custo credito tem de iniciar com "+alltrim(str(xccsp))+".","CCD Invalido")
		           exit
		       Endif
    
    
         ELSEIF  ( (substr(_cCcondb,1,1)=="3" .and. alltrim(_cCcustd)==alltrim(_ccexces)) .or. (substr(_cCconcr,1,1)=="3" .and. alltrim(_cCcustc)==alltrim(_ccexces)) )
              _lreturn:=.f.         
              If xccsp==1 
                  MsgAlert("Para conta debito iniciada com 3, o centro de Custo debito nao pode ser o "+alltrim(_ccexces)+".","CCD Invalido")
              Elseif xccsp==2
                  MsgAlert("Para conta credito iniciada com 3, o centro de Custo credito nao pode ser o "+alltrim(_ccexces)+".","CCC Invalido")
              Elseif xccsp==3
                  MsgAlert("Para conta credito ou debito iniciada com 3, o centro de Custo credito ou debito nao pode ser o "+alltrim(_ccexces)+".","CCC ou CCD Invalido")              
              Endif    
              exit
         
         ELSEIF  ( (substr(_cCcondb,1,1) $ "12" .and. alltrim(_cCcustd)<>alltrim(_ccexces)) .or. (substr(_cCconcr,1,1) $ "12" .and. alltrim(_cCcustc)<>alltrim(_ccexces)) )         
         
              //_lreturn:=.f.         
              If _ctpldc="1" .and. xccsp==1  .and. (substr(_cCcondb,1,1) $ "12" .and. alltrim(_cCcustd)<>alltrim(_ccexces)) 
                  //MsgAlert("Para conta debito iniciada com 1 ou 2, e obrigatorio que o Centro de Custo debito seja "+alltrim(_ccexces)+".","CCD Invalido")
                  _cCcustd := TMP->CT2_CCD
                  	RecLock("TMP",.f.)
                       TMP->CT2_CCD:=_ccexces
                    msunlock()
                  exit
              Elseif _ctpldc="2" .and. xccsp==2  .and. (substr(_cCconcr,1,1) $ "12" .and. alltrim(_cCcustc)<>alltrim(_ccexces))
                  //MsgAlert("Para conta credito iniciada com 1 ou 2, e obrigatorio que o Centro de Custo credito seja "+alltrim(_ccexces)+".","CCC Invalido")
                      RecLock("TMP",.f.)
                       TMP->CT2_CCC:=_ccexces
                      msunlock()
                  exit
              Elseif _ctpldc="3" .and. xccsp==3
                  //MsgAlert("Para conta credito ou debito iniciada com 1 ou 2, e o obrigatorio que o Centro de Custo debito e credito sejam "+alltrim(_ccexces)+".","CCC ou CCD Invalido")              
                  IF (substr(_cCcondb,1,1) $ "12" .and. alltrim(_cCcustd)<>alltrim(_ccexces)) 
                       RecLock("TMP",.f.)
                          TMP->CT2_CCD:=_ccexces
                       msunlock()
                  ENDIF
                  IF (substr(_cCconcr,1,1) $ "12" .and. alltrim(_cCcustc)<>alltrim(_ccexces))
                      RecLock("TMP",.f.)
                       TMP->CT2_CCC:=_ccexces
                      msunlock()
                  
                  ENDIF
                  exit
              Endif    
         ENDIF
   //   ENDIF
  Next        

ENDIF  


Return(_lreturn)       