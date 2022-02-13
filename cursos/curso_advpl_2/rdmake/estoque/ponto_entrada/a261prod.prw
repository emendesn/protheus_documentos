#include 'rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO6     ºAutor  ³Microsiga           º Data ³  05/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function a261prod()

Local _nPosCODOri	   	:= 1 							//Codigo do Produto Origem
local _nPosDOri			:= 2							//Descricao do Produto Origem
local _nPosUMOri	   	:= 3							//Unidade de Medida Origem
local _nPosLOCOri	   	:= 4							//Armazem Origem
local _nPosLcZOri	   	:= 5							//Localizacao Origem
local _nPosCODDes	   	:= Iif(!__lpyme,6,5)				//Codigo do Produto Destino
local _nPosDDes			:= Iif(!__lpyme,7,6)				//Descricao do Produto Destino
local _nPosUMDes	   	:= Iif(!__lpyme,8,7)				//Unidade de Medida Destino
local _nPosLOCDes	   	:= Iif(!__lpyme,9,8)				//Armazem Destino
local _nPosLcZDes	   	:= 10							//Localizacao Destino
local _nPosLoTCTL	   	:= 12							//Lote de Controle
local _nPosNLOTE	   	:= 13							//Numero do Lote
local _nPosDTVAL	   	:= 14							//Data Valida
local _nPosPotenc	   	:= 15							//Data Valida
local _nPosQUANT	   	:= Iif(!__lpyme,16,9)				//Quantidade
local _nPosQTSEG	   	:= Iif(!__lpyme,17,10)			//Quantidade na 2a. Unidade de Medida
u_GerA0003(ProcName())

if paramixb[2] == 1 .and. alltrim(ReadVar()) == "M->D3_COD"

	aCols[n,_nPosCODDes] := aCols[n,_nPosCODOri]
	aCols[n,_nPosDDes]   := aCols[n,_nPosDOri]
	aCols[n,_nPosUMDes]  := aCols[n,_nPosUMOri]
	aCols[n,_nPosLOCDes] := aCols[n,_nPosLOCOri]
	aCols[n,_nPosLCZDes] := aCols[n,_nPosLCZOri]

endif

return
