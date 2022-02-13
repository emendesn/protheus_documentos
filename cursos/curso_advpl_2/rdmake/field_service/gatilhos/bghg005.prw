#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BGHG005  ºAutor  ³M.Munhoz - ERPPLUS  º Data ³  24/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para verificar se o IMEI OLD informado no PV ja    º±±
±±º          ³ sofreu saida como SWAP ANTECIPADO anteriormente.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function bghg005()

local _nPosIMEI := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_XIMEOLD" }) // IMEI OLD - Swap Antecipado
local _cImeiOld := aCols[n,_nPosIMEI]
local _aArea    := GetArea()
//local _aAreaSC6 := SC6->(GetArea())
//local _nRegSC6  := SC6->(recno())
local _cQrySwap := ""

u_GerA0003(ProcName())

if select("SWAP") > 0
	SWAP->(dbCloseArea())
endif 


//Incluso IF para nao dar a mensagem quando o campos estiver em branco
If empty(_cImeiOld)
   return(_cImeiOld)
Endif   

_cQrySwap += " SELECT C6_NUM, C6_ITEM, C6_CLI, C6_LOJA, C6_NOTA, C6_SERIE "
_cQrySwap += " FROM "+RetSqlName("SC6")+" AS C6 (nolock) "    
if  cNumEmp=='0202'   //Edson Rodrigues   15/06/08      
   _cQrySwap += " WHERE C6_FILIAL IN ('01','02') AND C6.D_E_L_E_T_ = '' AND C6_XIMEOLD = '"+_cImeiOld+"' "
Else
   _cQrySwap += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6.D_E_L_E_T_ = '' AND C6_XIMEOLD = '"+_cImeiOld+"' "     
Endif     
TCQUERY _cQrySwap NEW ALIAS "SWAP"
SWAP->(dbGoTop())
if SWAP->(!eof()) .and. SWAP->(!bof())


//SC6->(dbSetOrder(10))  // C6_FILIAL + C6_XIMEOLD + C6_NUM + C6_ITEM

//if SC6->(dbSeek(xFilial("SC6") + _cImeiOld))  
	If Upper(Alltrim(FunName())) # "TECAX012"
		if !ApMsgYesNo("Este aparelho já foi informado como SWAP ANTECIPADO no PV/Item "+SC6->C6_NUM+"/"+SC6->C6_ITEM+". Confirma nova inclusão de SWAP ANTECIPADO para o mesmo IMEI OLD?","Swap antecipado!")
			_cImeiOld := Space(TamSX3("ZZ4_IMEI")[1])
			aCols[n,_nPosIMEI] := _cImeiOld
		endif
	EndIf	
endif

SWAP->(dbCloseArea())
RestArea(_aArea)
//RestArea(_aAreaSC6)
//SC6->(dbGoTo(_nRegSC6))
M->C6_XIMEOLD := _cImeiOld

return(_cImeiOld)