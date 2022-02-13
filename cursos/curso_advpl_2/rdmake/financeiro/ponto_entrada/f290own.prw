// Ponto de Entrada após seleção dos títulos a pagar para a geração da FATURA
user function F290OWN()

local _cFiltro := ""

if apMsgYesNo('Deseja filtrar os títulos a pagar pela data contábil?','Filtro data contábil x emissão')
	_cFiltro += '.AND.DTOS(E2_EMIS1)>="' + DTOS( dDataDe ) + '"'
	_cFiltro += '.AND.DTOS(E2_EMIS1)<="' + DTOS( dDataAte ) + '"'
else
	_cFiltro += '.AND.DTOS(E2_EMISSAO)>="' + DTOS( dDataDe ) + '"'
	_cFiltro += '.AND.DTOS(E2_EMISSAO)<="' + DTOS( dDataAte ) + '"'
endif

return(_cFiltro)
