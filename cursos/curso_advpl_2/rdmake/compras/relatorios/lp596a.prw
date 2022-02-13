#include 'rwmake.ch'                     
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP596    �Autor  �M.Munhoz - ERPPLUS  � Data �  31/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar conta contabil na contabilizacao de   ���
���          � NCC e RA na compensacao de Contas a Receber                ���
�������������������������������������������������������������������������͹��
���Parametros� _cTipo -> "D" = conta debito                               ���
���          �           "C" = conta credito                              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BGH                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function lp596A(_cTipo)

local _cConta   := ""
local _nvalor   := ""
local _aAreaSE1 := SE1->(GetArea())
local _aAreaSED := SED->(GetArea())  
local _aAreaSA1 := SA1->(GetArea())

u_GerA0003(ProcName())


//��������������������������������������������������������������������������������������������������Ŀ
//� Regra contabil definida pelo Roberto da Net Worth em 14/04/2008, conforme informado pelo Edson.  �
//� Contabilizacao de Contas a Receber (NCC/RA)                                                      �
//� Debito  = conta credito da natureza do titulo de NCC ou RA                                       �
//� Credito = conta credito da natureza do titulo principal                                          �
//����������������������������������������������������������������������������������������������������

// Conta RA: 2160500001
// Conta NCC: 1120100999


 // Posiciona SE1 e SED pelo titulo gerador da compensacao (pode ser NCC/RA ou o titulo principal/NF)
 SE1->(dbSetOrder(1))
 SE1->(dbSeek(xFilial("SE1") + strlctpad))

 SED->(dbSetOrder(1))
 SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))   

 SA1->(dbSetOrder(1))
 SA1->(dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA))   


 // if alltrim(substr(strlctpad,11,3)) $ "RA/NCC" --> alterado - Edson Rodrigues - 09//07/11

 if alltrim(substr(strlctpad,14,3)) $ "RA/NCC" .AND.  EMPTY(_cConta)
	// Tratamento para titulo RA
	if alltrim(substr(strlctpad,14,3)) == "RA"
	    _nvalor:=VALOR
		_cConta := iif(_cTipo == "D", IIF(EMPTY(SA1->A1_XCTCRED),SED->ED_DEBITO,SA1->A1_XCTCRED), "2160500001") //ALTERADO CONFORME ALDEMIR - 10/05/09 // Alterado Edson Rodrigues 09/07/11 
	else
		_cConta := iif(_cTipo == "D", "", SED->ED_DEBITO)
	endif
	
	// Tratamento para titulo NCC
	If EMPTY(_cConta)
	
	   if alltrim(substr(strlctpad,14,3)) =="NCC" .AND. alltrim(substr(strlctpad,1,3)) == "NCC" 
		   _cConta := iif(_cTipo == "D", SED->ED_CREDIT, "")
	
	   Elseif 	alltrim(substr(strlctpad,14,3)) =="NCC" .AND. alltrim(substr(strlctpad,1,3)) <> "NCC" 
	      _cConta := iif(_cTipo == "D", IIF(EMPTY(SA1->A1_CONTA),SED->ED_CREDIT,SA1->A1_CONTA), "") //ALTERADO CONFORME ALDEMIR - 25/05/09
       else
		_cConta := iif(_cTipo == "D", "", SED->ED_CREDIT)
	   endif
	Endif   
endif


if alltrim(substr(strlctpad,14,3)) == "NDC"
     _cConta := IIF(_cTipo == "D", SED->ED_XCTCRED,"")
Endif                         

// Passo por todos os titulos, verificando qual esta marcado para compensacao
for _na := 1 to len(aTitulos)
	
	if aTitulos[_na,8]  // o Titulo estas marcado no markbrowse
		
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1") + aTitulos[_na,1] + aTitulos[_na,2] + aTitulos[_na,3] + aTitulos[_na,4] ))
		
		SED->(dbSetOrder(1))
		SED->(dbSeek(xFilial("SED") + SE1->E1_NATUREZ))
		
		SA1->(dbSetOrder(1))
        SA1->(dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA))   

		
		// Tratamento para titulo RA
		if alltrim(aTitulos[_na,4]) == "RA"
		    _nvalor:=VALOR
			_cConta := iif(_cTipo == "D",IIF(EMPTY(SA1->A1_XCTCRED),SED->ED_DEBITO,SA1->A1_XCTCRED),"2160500001") //ALTERADO CONFORME ALDEMIR - 10/05/09   // Alterado Edson Rodrigues 09/07/11
		else
			_cConta := iif(_cTipo == "D", _cConta, SED->ED_DEBITO)
		endif                                                                  
		
		// Tratamento para titulo NCC
		if alltrim(aTitulos[_na,4]) == "NCC" .AND. aTitulos[_na,1] == "NCC" 
			_cConta := iif(_cTipo == "D", SED->ED_CREDIT, _cConta)    

		elseif alltrim(aTitulos[_na,4]) == "NCC" .AND. aTitulos[_na,1] <> "NCC" 
            _cConta := iif(_cTipo == "D",IIF(EMPTY(SA1->A1_CONTA),SED->ED_CREDIT,SA1->A1_CONTA), _cConta) //ALTERADO CONFORME ALDEMIR - 25/05/09
		else
			_cConta := iif(_cTipo == "D", _cConta, SED->ED_CREDIT)
		endif
		
		if alltrim(aTitulos[_na,4]) == "NDC"
     		_cConta := IIF(_cTipo == "D", SED->ED_XCTCRED,"")
		Endif

		exit
		
	endif
	
next _na

restarea(_aAreaSED)
restarea(_aAreaSE1)
restarea(_aAreaSA1)

return(IIF(_cTipo=='V',_nvalor,_cConta))
