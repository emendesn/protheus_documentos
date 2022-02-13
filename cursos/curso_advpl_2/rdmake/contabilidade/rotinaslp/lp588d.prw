#include 'rwmake.ch'                 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP588D   ºAutor  ³Edson Rodrigues     º Data ³  07/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar conta contabil  de  Credito           º±±
±±º          ³ NDC outros na compensacao de Contas a Receber              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cTipo -> "D" = conta debito                               º±±
±±º          ³           "C" = conta credito                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function lp588D(_cTipo)

Local _cConta   := ""
Local _ccontcli := "1120100001"
Local _cdocument:= ""
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())
local _aAreaSE5 := SE5->(GetArea())


u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regra contabil definida pelo Roberto/Aldemir da NetWorth em 07/11/2008,                          |
//| conforme informado pelo Edson.  ³                                                                |
//³ Contabilizacao de Contas a Receber (NDC/OUTROS)                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Posiciona E5
SE5->(dbSetOrder(10))

// Posiciona SE1 e SED pelo titulo gerador da compensacao (pode ser NCC/RA ou o titulo principal/NF)
SE1->(dbSetOrder(1))
SE1->(dbSeek(xFilial("SE1") + strlctpad))

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))



// Tratamento para titulo NDC
if alltrim(substr(strlctpad,14,3)) == "NDC"
     _cConta := iif(_cTipo == "D", SED->ED_CONTA,"")
else
   If alltrim(substr(strlctpad,14,3)) == "RA"	
       _cConta := iif(_cTipo == "D", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,_ccontcli),"") 
   Else
       _cConta := iif(_cTipo == "D", SED->ED_XCTCRED,"") 
   Endif 	
    	
endif
	
	


   // Passo por todos os titulos qundo nao for RA ou NCC, verificando qual esta marcado para compensacao
   for _na := 1 to len(aTitulos)
   
    _cdocument:=aTitulos[_na,1]+aTitulos[_na,2]+aTitulos[_na,3]+aTitulos[_na,4]+aTitulos[_na,5] 
    
    if !alltrim(aTitulos[_na,4]) $ "RA/NCC"	
      if aTitulos[_na,11]  // o Titulo estas marcado no markbrowse
		
		SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
	   	SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))
		SE5->(dbSeek(xFilial("SE5") + _cdocument))
		// Tratamento para titulo RA
		if alltrim(aTitulos[_na,4]) == "NDC"
		     _cConta := iif(_cTipo == "D", SED->ED_CONTA,"")
        else 
            IF ALLTRIM(SE5->E5_TIPO) = "RA" 
               _cConta := iif(_cTipo == "D", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,_ccontcli),"") 
            ELSE
     	       _cConta := iif(_cTipo == "D", SED->ED_XCTCRED,"")
     	    ENDIF     
		endif
	  endif	
    
    Else    
       IF alltrim(aTitulos[_na,4]) == "RA"
           if aTitulos[_na,11]  // o Titulo estas marcado no markbrowse
    	  	   _cConta := iif(_cTipo == "D", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,_ccontcli),"") 
           ENDIF
       ENDIF
    Endif
   next _na                           
   

   

restarea(_aAreaSED)
restarea(_aAreaSE1)
restarea(_aAreaSE5)

return(_cConta)
