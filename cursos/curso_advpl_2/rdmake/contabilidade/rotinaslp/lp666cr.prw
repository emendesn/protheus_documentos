# Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP666CR   ºAutor  ³ Edson Rodrigues    º Data ³17/12/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno da conta a credito e custo das        º±±
±±º          ³movimentacoes de Transferências Saída de saldo em estoque    ±±º 
±±º          (requisição)- movimento origem.                             -º±±
±±º                                                                      -º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso   BGH   ³                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP666CR(_ltipo)

//Definicao de variaveis
Local _cRet , _cTm , _nCusto , _cDoc , _nRet , _cOp, _cseq,_clocori,_ccod,_cchave,_clocdest
local _aAreaSD3 := SD3->(GetArea())
//Inicia variaveis
_cRet    := ""						  //Conta/historico para retorno.
_nRet    := 0						  //Valor para retorno.
_cTm     := Alltrim(SD3->D3_TM) 	  //Codigo do tipo da movimentacao.
_cDoc    := Alltrim(SD3->D3_DOC)	  //Numero do documento da movimentacao.
_cOp     := Alltrim(SD3->D3_OP)		  //Numero da Ordem de Producao.
_cseq    := Alltrim(SD3->D3_NUMSEQ)   //Sequencia movimentacao
_clocori := Alltrim(SD3->D3_LOCAL)    //Armazem mov. origem
_ccod    := SD3->D3_COD                //codigo
_cchave  := IIF(_cTm="499","E0",IIF(_cTm="999","E9","")) //Verifica o TM para pegar a chave contraria a ser usada no DSEEK
_nCusto  := SD3->D3_CUSTO1

u_GerA0003(ProcName())


SD3->(dbSetOrder(4))  // D3_FILIAL + D3_NUMSEQ + D3_CHAVE + D3_COD
if SD3->(dbSeek(xFilial("SD3") + _cseq + _cchave + _ccod)) .and. SD3->D3_ESTORNO<>'S'
   IF _cTm="999" .AND. _clocori $ "21/28/29" .AND. SD3->D3_LOCAL ="34" //Quando as pecas sao transferidas para o armazem de processo
      _cRet:="1140400001"
      _nRet:=_nCusto
      
   ELSEIF _cTm="999" .AND. _clocori = "34" .AND. SD3->D3_LOCAL ="35"  //Quando o produto acabado é transferido para o armazem de acabados
      _cRet:="1140300001"
      _nRet:=_nCusto

   ENDIF 
Endif

restarea(_aAreaSD3)

Return(iif(_ltipo,_cRet,_nRet))
