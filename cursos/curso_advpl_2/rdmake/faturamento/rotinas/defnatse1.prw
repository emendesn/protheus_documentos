user function DefNatSE1()

local  _aArea	:= GetArea()
local _cNaturez := ""


u_GerA0003(ProcName())
/*
if SC5->C5_DIVNEG == '01'     // Distribuicao Suldeste  (Antes Distribuicao Motorola)
	_cNaturez := 'FAT01'
elseif SC5->C5_DIVNEG == '02'  // Distribuicao Sul (antes Distribuicao BGH)
	_cNaturez := 'FAT02'
elseif SC5->C5_DIVNEG == '03'  // Service Sony/Ericsson
	_cNaturez := 'FAT03'
elseif SC5->C5_DIVNEG == '04'  // Service Nextel
	_cNaturez := 'FAT04'   
elseif SC5->C5_DIVNEG == '05'  // DISTRIBUICAO DIVERSAS REGIOES (antes Distribuicao Outros)
	_cNaturez := 'FAT05'
elseif SC5->C5_DIVNEG == '06'  // Distribuicao Motorola
	_cNaturez := 'FAT06'     
elseif SC5->C5_DIVNEG == '07'  // Distribuicao Sony Ericson
	_cNaturez := 'FAT08'	
elseif SC5->C5_DIVNEG == '08'  // Distribuicao Nordeste
	_cNaturez := 'FAT10'	
elseif SC5->C5_DIVNEG == '09'  // DIVERSOS SERVICE  (antes : Distribuicao BGH e  outros )
	_cNaturez := 'FAT07'			                               
elseif SC5->C5_DIVNEG == '10'  // Televendas
	_cNaturez := 'FAT11'				    
elseif SC5->C5_DIVNEG == '11'  // Distribuicao Norte
	_cNaturez := 'FAT12'					                          
elseif SC5->C5_DIVNEG == '12'  // Holding
	_cNaturez := 'FAT13'						
elseif SC5->C5_DIVNEG == '14'  // AIB
	_cNaturez := 'FAT50'						
elseif SC5->C5_DIVNEG == '15'  // AUDIO E VIDEO
	_cNaturez := 'FAT60'	
elseif SC5->C5_DIVNEG == '16'  // ITSA
	_cNaturez := 'FAT15'
elseif SC5->C5_DIVNEG == '18'  // SONY INDUSTRIAL
	_cNaturez := 'FAT18'
elseif SC5->C5_DIVNEG == '19'  // POSITIVO
	_cNaturez := 'FAT19'
elseif SC5->C5_DIVNEG == '20'  // ITAUTEC
	_cNaturez := 'FAT20'
elseif SC5->C5_DIVNEG == '21'  // SONY CONSULTORIA
	_cNaturez := 'FAT17'
	
else        
	_cNaturez := SA1->A1_NATUREZ
endif
*/

dbSelectArea("ZZ0")
dbSetOrder(1)

if dbSeek(xFilial("ZZ0")+SC5->C5_DIVNEG)		
	if len(alltrim(ZZ0->ZZ0_REGNAF)) == 0
		_cNaturez := ZZ0->ZZ0_NATFAT
	else                         
		_formula := ZZ0->ZZ0_REGNAF
		_cNaturez := &_formula
	endif
else
	_cNaturez := SA1->A1_NATUREZ
endif

restarea(_aArea)
return(_cNaturez)