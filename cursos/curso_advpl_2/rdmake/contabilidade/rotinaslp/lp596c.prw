#include 'rwmake.ch'                                                   
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP596C   ºAutor  ³Edson Rodrigues     º Data ³  07/11/08   º±±
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
user function lp596C(_cTipo)

local _cConta   := ""                 
local _ccontcli := "1120100001"
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())
local _aAreaSA1 := SA1->(GetArea())


u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regra contabil definida pelo Roberto/Aldemir da NetWorth em 07/11/2008,                          |
//| conforme informado pelo Edson.  ³                                                                |
//³ Contabilizacao de Contas a Receber (NDC/OUTROS)                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Posiciona SE1 e SED pelo titulo gerador da compensacao (pode ser NCC/RA ou o titulo principal/NF)
SE1->(dbSetOrder(1))
SE1->(dbSeek(xFilial("SE1") + strlctpad))

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))  

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA))  

// Tratamento para titulo NDC
if alltrim(substr(strlctpad,14,3)) == "NDC"
     _cConta := iif(_cTipo == "C", SED->ED_CONTA,"")

Elseif alltrim(substr(strlctpad,11,3)) == "NCC" .AND. alltrim(substr(strlctpad,1,3)) == "NCC" 
     _cConta := iif(_cTipo == "C", Iif(!Empty(SED->ED_XCTCRED),SED->ED_XCTCRED,SA1->A1_CONTA),"")
else
	 _cConta := iif(_cTipo == "C", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,_ccontcli),"") 
endif
	
	


   // Passo por todos os titulos qundo nao for RA ou NCC, verificando qual esta marcado para compensacao
   for _na := 1 to len(aTitulos)

    if !alltrim(aTitulos[_na,4]) $ "RA/NCC"		
	  if aTitulos[_na,8]  // o Titulo estas marcado no markbrowse
		
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
		
		SED->(dbSetOrder(1))
		SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))
		
		SA1->(dbSetOrder(1))
        SA1->(dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA))  

		
		// Tratamento para titulo RA
		if alltrim(aTitulos[_na,4]) == "NDC"
		     _cConta := iif(_cTipo == "C", SED->ED_CONTA,"")
    
        Elseif alltrim(aTitulos[_na,4]) == "NCC" .AND. aTitulos[_na,1] == "NCC" 
             _cConta := iif(_cTipo == "C", Iif(!Empty(SED->ED_XCTCRED),SED->ED_XCTCRED,SA1->A1_CONTA),"")
    
        else
	         _cConta := iif(_cTipo == "C", Iif(!Empty(SA1->A1_CONTA),SA1->A1_CONTA,_ccontcli),"") 
        endif

	  Endif	
    endif
   next _na


	


restarea(_aAreaSED)
restarea(_aAreaSE1)
restarea(_aAreaSA1)

return(_cConta)
