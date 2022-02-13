#include 'protheus.ch'
#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LOGMCL   ºAutor  ³ M.Munhoz           º Data ³  13/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para gravacao do LOG MCLAIM                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BGH - NEXTEL                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function LOGMCL(_cTipo, _cArqNome, _cArqData, _cArqTam)

local _cCodigo  := ""
local _aAreaSZQ := SZQ->(getarea())

u_GerA0003(ProcName())

if !empty(_cArqNome)

	SZQ->(dbSetOrder(2)) // ZQ_FILIAL + ZQ_ARQNOM
	if SZQ->(dbSeek(xFilial("SZQ")+alltrim(_cArqNome)))
		apMsgStop('Caro usuário. O arquivo '+alltrim(_cArqNome)+' já foi processado anteriormente! Esta rotina será cancelada. Favor verificar.','Arquivo já processado!')
	else
		SZQ->(dbGoBottom())
		_cCodigo := GetSXENum("SZQ","ZQ_CODIGO",,1) //iif(empty(SZQ->ZQ_CODIGO),"000001",Soma1(SZQ->ZQ_CODIGO))
		reclock("SZQ",.t.)
		SZQ->ZQ_FILIAL  := xFilial("SZQ")
		SZQ->ZQ_CODIGO  := _cCodigo
		SZQ->ZQ_LAB     := "2"
		SZQ->ZQ_TIPO    := _cTipo
		SZQ->ZQ_ARQNOM  := _cArqNome
		SZQ->ZQ_ARQDT   := _cArqData
		SZQ->ZQ_ARQTAM  := _cArqTam
		SZQ->ZQ_USER    := cUserName
		SZQ->ZQ_DATA    := dDataBase
		SZQ->ZQ_HORA    := time()
		SZQ->ZQ_ANOMCL  := mv_par01
		SZQ->ZQ_MESMCL  := mv_par02
		SZQ->ZQ_BATCH   := mv_par03
		msunlock()
		ConfirmSX8(.t.)
	endif
endif

restarea(_aAreaSZQ)

return(_cCodigo)
