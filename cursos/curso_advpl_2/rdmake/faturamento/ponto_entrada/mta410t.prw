#include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA410T  ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  14/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada apos a gravacao do Pedido de Venda        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Edson Rodrigues em 08/09/08                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function mta410t()

local _cUpdate := '' 
local _clibfat:=ALLTRIM(SC5->C5_XLIBFAT)
u_GerA0003(ProcName())

                                                          
if Inclui .or. Altera
	_cUpdate += " UPDATE "+RetSqlName("SC9")+" SET C9_XTES = C6_TES,C9_RETOPER='2' " 
	_cUpdate += " FROM   "+RetSqlName("SC6")+" AS C6 "
	_cUpdate += " JOIN   "+RetSqlName("SC9")+" AS C9 "
	_cUpdate += " ON     C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND C9_NFISCAL = '' AND C9.D_E_L_E_T_ = '' "
	_cUpdate += " WHERE  C6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = '"+SC5->C5_NUM+"' "
	
	tcsqlexec(_cUpdate)                                               
	TCRefresh(RetSqlName("SC9"))
	
endif      

If !empty(_clibfat) .AND. ALLTRIM(_clibfat)=="2"
  _cUpdate := ''
  _cUpdate += " UPDATE "+RetSqlName("SC9")+" SET C9_BLINF = '"+_clibfat+"-BLOQUEADO PARA FATURAMENTO',C9_RETOPER='2'" 
  _cUpdate += " FROM   "+RetSqlName("SC5")+" AS C5 "
  _cUpdate += " JOIN   "+RetSqlName("SC9")+" AS C9 "
  _cUpdate += " ON     C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C9_NFISCAL = '' AND C9.D_E_L_E_T_ = '' "
  _cUpdate += " WHERE  C5.D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = '"+SC5->C5_NUM+"'"

  tcsqlexec(_cUpdate)  
  TCRefresh(RetSqlName("SC9"))   
  
Endif

return