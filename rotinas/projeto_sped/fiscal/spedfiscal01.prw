User Function SpedFiscal
Local 	cIdEnt 		:= 	"01"
Local	oSpedFiscal	:=	Nil
Local	oSpedEmpresa:=	Nil

oSpedFiscal 	:= 	WSSPEDFISCALENTIDADES():New()
oSpedEmpresa 	:=	WsSPEDAdm():New()

If oSpedEmpresa:ADMEMPRESAS()
	cIdEnt  := oSpedEmpresa:cADMEMPRESASRESULT
EndIf

oSpedFiscal:cUSERTOKEN	:=	"TOTVS"

oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_IDENTIFICACAO_ITEM")
oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM := {}
aAdd(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO					:=	"000001"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_BARRAS			:=	"000001"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_EX_TIPI			:=	"000"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_NCM				:=	"21011000"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cDESCRICAO				:=	"MERCADORIA"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):nTIPO						:=	1
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cUM_ESTOQUE				:=	"UN"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):dDATA_INICIAL_UTILIZACAO	:=	CToD("01/01/01")

aAdd(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO					:=	"000002"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_BARRAS			:=	"000002"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_EX_TIPI			:=	"000"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_NCM				:=	""
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cDESCRICAO				:=	"SERVICO"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):nTIPO						:=	1
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cUM_ESTOQUE				:=	"UN"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):dDATA_INICIAL_UTILIZACAO	:=	CToD("01/01/01")

aAdd(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO					:=	"000003"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_BARRAS			:=	"000003"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_EX_TIPI			:=	"000"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_NCM				:=	""
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cDESCRICAO				:=	"COMBUSTIVEL"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):nTIPO						:=	1
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cUM_ESTOQUE				:=	"LT"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):dDATA_INICIAL_UTILIZACAO	:=	CToD("01/01/01")

aAdd(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO					:=	"000004"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_BARRAS			:=	"000004"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_EX_TIPI			:=	"000"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cCODIGO_NCM				:=	""
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cDESCRICAO				:=	"COMBUSTIVEL NOVO"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):nTIPO						:=	1
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):cUM_ESTOQUE				:=	"LT"
aTail(oSpedFiscal:oWSCADASTRO_IDENTIFICACAO_ITEM:oWSIDENTIFICACAO_ITEM:oWSSTR_IDENTIFICACAO_ITEM):dDATA_INICIAL_UTILIZACAO	:=	CToD("01/01/01")

oSpedFiscal:IDENTIFICACAO_ITEM()
Alert(oSpedFiscal:cIDENTIFICACAO_ITEMRESULT)

oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_COMPLEMENTO_IDENTIFICACAO_ITEM")
oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_COMPLEMENTO_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO					:=	"000002"
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_PRODUTO_ANTERIOR	:=	""
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):nCODIGO_SERVICO			:=	2001
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_ANP_COMBUSTIVEL	:=	""

aAdd(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_COMPLEMENTO_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO					:=	"000003"
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_PRODUTO_ANTERIOR	:=	""
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):nCODIGO_SERVICO			:=	0
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_ANP_COMBUSTIVEL	:=	"GASOLINA"

aAdd(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_COMPLEMENTO_IDENTIFICACAO_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cID_ENT					:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO					:=	"000004"
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_PRODUTO_ANTERIOR	:=	"000003"
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):nCODIGO_SERVICO			:=	0
aTail(oSpedFiscal:oWSCADASTRO_COMPLEMENTO_IDENTIFICACAO_ITEM:oWSCOMPLEMENTO_IDENTIFICACAO_ITEM:oWSSTR_COMPLEMENTO_IDENTIFICACAO_ITEM):cCODIGO_ANP_COMBUSTIVEL	:=	"GASOLINA"

oSpedFiscal:COMPLEMENTO_IDENTIFICACAO_ITEM()
Alert(oSpedFiscal:cCOMPLEMENTO_IDENTIFICACAO_ITEMRESULT)

oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_CONVERSAO_UM_ITEM")
oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM,WsClassNew("SPEDFISCALENTIDADES_STR_CONVERSAO_UM_ITEM"))
aTail(oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM):cID_ENT				:=	cIdEnt
aTail(oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM):cCODIGO				:=	"000004"
aTail(oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM):nFATOR_CONVERSAO		:=	10
aTail(oSpedFiscal:oWSCADASTRO_CONVERSAO_UM_ITEM:oWSCONVERSAO_UM_ITEM:oWSSTR_CONVERSAO_UM_ITEM):cUM_CONVERTIDA 		:=	"GL"

oSpedFiscal:CONVERSAO_UM_ITEM()
Alert(oSpedFiscal:cCONVERSAO_UM_ITEMRESULT)

oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:cID_ENT	:=	cIdEnt
oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:oWSINFORMACAO_COMPLEMENTAR	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO")
oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:oWSINFORMACAO_COMPLEMENTAR:oWSSTR_GENERICA_CODIGO_DESCRICAO	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:oWSINFORMACAO_COMPLEMENTAR:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:oWSINFORMACAO_COMPLEMENTAR:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO	:=	"000001"
aTail(oSpedFiscal:oWSCADASTRO_INFORMACAO_COMPLEMENTAR:oWSINFORMACAO_COMPLEMENTAR:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO	:=	"INFORMACAO COMPLEMENTAR"

oSpedFiscal:INFORMACAO_COMPLEMENTAR()
Alert(oSpedFiscal:cINFORMACAO_COMPLEMENTARRESULT)

oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:cID_ENT	:=	cIdEnt
oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:oWSNATUREZA_OPERACAO	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO")
oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:oWSNATUREZA_OPERACAO:oWSSTR_GENERICA_CODIGO_DESCRICAO	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:oWSNATUREZA_OPERACAO:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:oWSNATUREZA_OPERACAO:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO		:=	"000001"
aTail(oSpedFiscal:oWSCADASTRO_NATUREZA_OPERACAO:oWSNATUREZA_OPERACAO:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO	:=	"NATUREZA OPERACAO"

oSpedFiscal:NATUREZA_OPERACAO()
Alert(oSpedFiscal:cNATUREZA_OPERACAORESULT)
                                         
oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:cID_ENT	:=	cIdEnt
oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:oWSOBSERVACAO_LANCAMENTO_FISCAL	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO")
oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:oWSOBSERVACAO_LANCAMENTO_FISCAL:oWSSTR_GENERICA_CODIGO_DESCRICAO	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:oWSOBSERVACAO_LANCAMENTO_FISCAL:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:oWSOBSERVACAO_LANCAMENTO_FISCAL:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO		:=	"000001"
aTail(oSpedFiscal:oWSCADASTRO_OBSERVACAO_LANCAMENTO_FISCAL:oWSOBSERVACAO_LANCAMENTO_FISCAL:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO	:=	"OBSERVACAO LANCAMENTO FISCAL"

oSpedFiscal:OBSERVACAO_LANCAMENTO_FISCAL()
Alert(oSpedFiscal:cOBSERVACAO_LANCAMENTO_FISCALRESULT)

oSpedFiscal:oWSCADASTRO_UM:cID_ENT:=	cIdEnt
oSpedFiscal:oWSCADASTRO_UM:oWSUM	:=	WsClassNew("SPEDFISCALENTIDADES_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO")
oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO	:=	{}
aAdd(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO		:=	"UN"
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO		:=	"UNIDADE"

aAdd(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO		:=	"LT"
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO		:=	"LITRO"

aAdd(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO,WsClassNew("SPEDFISCALENTIDADES_STR_GENERICA_CODIGO_DESCRICAO"))
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO		:=	"GL"
aTail(oSpedFiscal:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDESCRICAO		:=	"GALAO"

oSpedFiscal:UM()
Alert(oSpedFiscal:cUMRESULT)

Return