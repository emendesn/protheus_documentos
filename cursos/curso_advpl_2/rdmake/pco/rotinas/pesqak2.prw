#INCLUDE "PROTHEUS.CH"
                                         
User Function PESQAK2(_cConta,_cTabela,_cTes,_cValor,_cPedido,_cTpLan)

Local _nRet     := 0
Local _cConta   := Left(_cConta,12)
Local _cTabela  := Upper(_cTabela)
Default _cTpLan := "L"

conout("NO BLOQUEIO DO PEDIDO DE COMPRAS")
conout(_cConta)
conout(_cTabela)
conout(_cTes)
conout(_cValor)
conout(_cPedido)
conout(_cTpLan)
//CONOUT(FUNNAME())

If _cTabela == "SD1"
// Posiciona na TES para bloquear somente se gerar Duplicata        
   dbSelectarea("SF4")
   dbSetorder(1)
   dbSeek(xFilial("SF4")+_cTes)                             
   
   If (Substr(_cConta,1,1) >= "3") .And. (SF4->F4_DUPLIC == "S")
		 _nRet    := _cValor
   else
		_nRet    := 0
   endif   
Endif

If _cTabela == "SD2"
// Posiciona na TES para bloquear somente se gerar Duplicata        
   dbSelectarea("SF4")
   dbSetorder(1)
   dbSeek(xFilial("SF4")+_cTes)                             
   
   If (SF4->F4_DUPLIC == "S")
		 _nRet    := _cValor
   else
		_nRet    := 0
   endif   
Endif

If _cTabela == "SE2"
   If (Substr(_cConta,1,1) >= "3")
		 _nRet    := _cValor
   else
		_nRet    := 0
   endif   
Endif

If _cTabela == "CT2"
	If (Substr(_cConta,1,1) >= "3")
    	IF CT2->CT2_LOTE $ "008890/008840/008860/000001"
			_nRet    := CT2->CT2_VALOR
		else
			_nRet    := 0
        endif
	else
		_nRet    := 0
    endif
Endif

conout(_nRet)

Return _nRet
