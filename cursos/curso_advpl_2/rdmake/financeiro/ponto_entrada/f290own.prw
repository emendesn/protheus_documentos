// Ponto de Entrada ap�s sele��o dos t�tulos a pagar para a gera��o da FATURA
user function F290OWN()

local _cFiltro := ""

if apMsgYesNo('Deseja filtrar os t�tulos a pagar pela data cont�bil?','Filtro data cont�bil x emiss�o')
	_cFiltro += '.AND.DTOS(E2_EMIS1)>="' + DTOS( dDataDe ) + '"'
	_cFiltro += '.AND.DTOS(E2_EMIS1)<="' + DTOS( dDataAte ) + '"'
else
	_cFiltro += '.AND.DTOS(E2_EMISSAO)>="' + DTOS( dDataDe ) + '"'
	_cFiltro += '.AND.DTOS(E2_EMISSAO)<="' + DTOS( dDataAte ) + '"'
endif

return(_cFiltro)
