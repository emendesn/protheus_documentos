#Include 'Protheus.ch'
User Function TstWS()





Local oObjWS := NIL

oObjWS := WSSPEDFISCAL():New()

oObjWS:cUSERTOKEN := ''
 
oObjWS:oWSCADASTRO_UM:oWSUM := WsClassNew( 'SPEDFISCAL_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO' )
oObjWS:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO := {}
AAdd( oObjWS:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO, WsClassNew( 'SPEDFISCAL_STR_GENERICA_CODIGO_DESCRICAO' ) )

Atail(oObjWS:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cCODIGO := 'XYZ'
Atail(oObjWS:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cDescricao := 'ALDSJF'
Atail(oObjWS:oWSCADASTRO_UM:oWSUM:oWSSTR_GENERICA_CODIGO_DESCRICAO):cId_ent := 'teste'



oObjWS:SPED_CADASTROS()

//AAdd( oObjWS:oWSCADASTRO_UM:SPEDFISCAL_SPED_UM, WsClassNew( 'SPEDFISCAL_ARRAYOFSTR_GENERICA_CODIGO_DESCRICAO' ) )




Return