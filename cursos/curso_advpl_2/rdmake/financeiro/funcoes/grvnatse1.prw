#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRVNATSE1 ºAutor  ³ M.Munhoz - ERPPLUS º Data ³  25/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava natureza no contas a receber de devolucoes de vendas º±±
±±º          ³ e grava Centro de Custo e Divisão de Negocio               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH DO BRASIL                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterado  ³ Edson Rodrigues em 03/03/08                                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      

user function GrvNatSE1(_cdoc,_cserie,_cPrefNum,_cFornece,_cloja,_cod,_cTES,_cnfori,_cserori,_nRecno)

local _aAreaSE1 := SE1->(GetArea())
local _aAreaSA1 := SA1->(GetArea())
local _aAreaSD2 := SD2->(GetArea())
local _aAreaSC5 := SC5->(GetArea())
local _cpedido  := SPACE(6)
local _cccusto  := ""
local _cdivneg  := SPACE(2)
local _cNaturez := ""  
local _ccfop    := ""                 
LOCAL _cLocal   := ""                 

u_GerA0003(ProcName())
                          
SC5->(dbSetOrder(1)) // C5_FILIAL + C5_NUM
SD2->(dbSetOrder(3)) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM

//Buscar nota Fiscal de Origem D1_NFORI.D1_SERIORI e Olhar pedido de origem no SD2020 e pegar o centro de custo 
if SD2->(DbSeek(xfilial("SD2") + _cnfori + _cserori + _cFornece + _cloja + _cod)) 
   _cpedido  := SD2->D2_PEDIDO
   _cccusto := SD2->D2_CCUSTO 
   _ccfop    := SD2->D2_CF            
   _cLocal    := SD2->D2_LOCAL            	   
   
   // buscar no SC5 o numero do pedido e pega a divisão de negocio original
   dbSelectArea("SC5")
   if SC5->(DbSeek(xfilial("SC5") + _cpedido)) 
      _cdivneg := SC5->C5_DIVNEG
   Endif   
   // gravar a divisão de negocio e o centro custo no SD1
   dbSelectArea("SD1")
   DbGoto(_nRecno)
   RecLock("SD1",.F.)
    SD1->D1_DIVNEG    := _cdivneg
    SD1->D1_CC       := _cccusto 
   MsUnLock()

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
	     dbSelectArea("SA1")
		 if SA1->(dbSeek(xFilial("SA1") + _cFornece)) 
			if SA1->A1_TIPO <> "X" .and. _cTES $ "207/208/209/210/258/271"
				_cNaturez := "FIN22"
			elseif SA1->A1_TIPO == "X" .and. _cTES $ "243/244"
				_cNaturez := "FIN25"
		    endif
			ALERT(_cNaturez)
	     endif
	endif
   
endif


if !empty(_cNaturez)
   SE1->(dbSetOrder(2))  // E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
   if SE1->(dbSeek(xFilial("SE1") + _cFornece + _cdoc))
	  while SE1->(!eof()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. ;
			SE1->E1_PREFIXO + SE1->E1_NUM == _cserie+_cdoc .and. SE1->E1_CLIENTE + SE1->E1_LOJA == _cFornece + _cloja
			reclock("SE1",.f.)
			  SE1->E1_NATUREZ := _cNaturez  
			  SE1->E1_CCD     := _cccusto
			msunlock()
		SE1->(dbSkip())
	  enddo
   endif
endif
restarea(_aAreaSE1)
restarea(_aAreaSA1)
restarea(_aAreaSD2)
restarea(_aAreaSC5)
return()