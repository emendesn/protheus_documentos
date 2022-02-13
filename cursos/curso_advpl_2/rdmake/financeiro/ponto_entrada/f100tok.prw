#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F100tok  ºAutor  ³ E.Rodrigues - BGH  º Data ³  06/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para validar dados das movimentacoes      º±±
±±º          ³ bancarias                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
user function F100TOK()

u_GerA0003(ProcName())

_nTcodpr := TAMSX3("CTT_CUSTO")[1]
_nTcondb := TAMSX3("CT2_DEBITO")[1] 
_nTconcr := TAMSX3("CT2_CREDIT")[1]
_cCcustd := Space(_nTcodpr) 
_cCcustc := Space(_nTcodpr) 
_cCcondb := Space(_nTcondb) 
_cCconcr := Space(_nTconcr)
_aconini :={'323','3240103','3240104'}
_ancaract:={3,7,7} 
_lreturn :=.T. 
_cCcondb := M->E5_DEBITO
_cCconcr := M->E5_CREDITO
_cCcustd := M->E5_CCD
_cCcustc := M->E5_CCC

//Valida o Centro de custo debito para qualquer movimentacao 
IF empty(_cCcustd)
       _lreturn:=.f.
       MsgAlert("Centro de Custo Debito nao digitado","CCD nao digitado")                          
Endif 
    
IF _lreturn 
  //Valida centro de custo debito ou credito caso a conta debito ou credito estejam preenchida.
  For xccsp:=1 to 3
   
     IF  !empty(_cCcondb) .or. !empty(_cCconcr)
          
          If  substr(_cCcondb,1,_ancaract[xccsp]) == _aconini[xccsp] .and.  !empty(_cCcustd) .and. !substr(_cCcustd,1,1) = alltrim(str(xccsp))
		             _lreturn:=.f.           
                     MsgAlert("Para contas debito iniciadas com "+_aconini[xccsp]+", o centro de Custo debito tem de iniciar com "+alltrim(str(xccsp))+".","CCD Invalido")
		             exit
		   
		   Elseif !empty(_cCconcr) .and. empty(_cCcustc) 
		             _lreturn:=.f.         
                     MsgAlert("Conta credito preenchida, favor preencher o centro de Custo credito","CCC Invalido")
                     exit
		   
		   Elseif substr(_cCconcr,1,_ancaract[xccsp]) ==_aconini[xccsp] .and. !empty(_cCcustc) .and. !substr(_cCcustc,1,1) = alltrim(str(xccsp))
		             _lreturn:=.f.         
                     MsgAlert("Para contas credito iniciadas com "+_aconini[xccsp]+ ", o centro de Custo credito tem de iniciar com "+alltrim(str(xccsp))+".","CCD Invalido")
		      		 exit     
           Endif
    
     ENDIF
     
  Next        

ENDIF  
        
return(_lreturn)