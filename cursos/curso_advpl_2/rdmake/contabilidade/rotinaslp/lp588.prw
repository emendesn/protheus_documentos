#include 'rwmake.ch'          
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP588    ºAutor  ³M.Munhoz - ERPPLUS  º Data ³  31/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar conta contabil na contabilizacao de   º±±
±±º          ³ NCC e RA no ESTORNO de compensacao de Contas a Receber     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cTipo -> "D" = conta debito                               º±±
±±º          ³           "C" = conta credito                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function lp588(_cTipo)

local _cConta   := ""
Local _nvalor   := 0.00
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())
local _clanpad  := CT5->CT5_LANPAD

u_GerA0003(ProcName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regra contabil definida pelo Roberto da Net Worth em 14/04/2008, conforme informado pelo Edson.  ³
//³ Contabilizacao de Contas a Receber (NCC/RA)                                                      ³
//³ Debito  = conta credito da natureza do titulo de NCC ou RA                                       ³
//³ Credito = conta credito da natureza do titulo principal                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Conta RA: 2160500001
// Conta NCC: 1120100999


// Posiciona SE1 e SED pelo titulo gerador da compensacao (pode ser NCC/RA ou o titulo principal/NF)
SE1->(dbSetOrder(1))
SE1->(dbSeek(xFilial("SE1") + strlctpad))

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA))



//if alltrim(substr(strlctpad,11,3)) $ "RA/NCC" //alterado Edson Rodrigues em 09/07/11

if alltrim(substr(strlctpad,14,3)) $ "RA/NCC" //alterado Edson Rodrigues em 09/07/11
	// Tratamento para titulo RA
	
	
	if alltrim(substr(strlctpad,14,3)) == "RA" .AND. EMPTY(_cConta)
		_nvalor   :=VALOR
		//_cConta := iif(_cTipo == "C", SED->ED_DEBITO, "") Alterado Edson Rodrigues em 09/07/11
		_cConta := iif(_cTipo == "C", IIF(EMPTY(SA1->A1_XCTCRED),iif(empty(SED->ED_DEBITO),"2160500001",SED->ED_DEBITO),SA1->A1_XCTCRED), "")
	else
		_cConta := iif(_cTipo == "C", "", SED->ED_DEBITO)
	endif
	
	// Tratamento para titulo NCC
	IF EMPTY(_cConta)
		if alltrim(substr(strlctpad,14,3)) =="NCC"
			_cConta := iif(_cTipo == "C", SED->ED_CREDIT, "")
		else
			_cConta := iif(_cTipo == "C", "", SED->ED_CREDIT)
		endif
	ENDIF
endif

// Passo por todos os titulos, verificando qual esta marcado para compensacao
for _na := 1 to len(aTitulos)
	
	if aTitulos[_na,iif(_clanpad='596',8,11)]  // o Titulo esta marcado no markbrowse
		
		IF _clanpad='596'
 		    SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
		ELSE
		    SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,7] ))
		ENDIF    
		    
	
		SED->(dbSetOrder(1))
		SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))
		
		
		// Tratamento para titulo RA
		if alltrim(SE1->E1_TIPO) == "RA"
			//_nvalor := IIF(_clanpad='596',aTitulos[_na,7],VALOR)
			_nvalor := VALOR
			_cConta := iif(_cTipo == "C", IIF(EMPTY(SA1->A1_XCTCRED),iif(empty(SED->ED_DEBITO),"2160500001",SED->ED_DEBITO),SA1->A1_XCTCRED),"")
			
			// Tratamento para titulo NCC
		elseif alltrim(SE1->E1_TIPO) == "NCC"
			_cConta := iif(_cTipo == "C", SED->ED_CREDIT, _cConta)
		else
		   	IF EMPTY(_cConta)
     			_cConta := SED->ED_XCTCRED
     		ENDIf	
		endif
		
		exit
		
	endif
	
next _na


restarea(_aAreaSED)
restarea(_aAreaSE1)

return(IIF(_cTipo=='V',_nvalor,_cConta))
