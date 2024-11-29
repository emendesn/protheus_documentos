#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeRecepcaoSoap/wsdl/NfeRecepcao.wsdl
Gerado em        06/18/07 21:26:27
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ERLXXSJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeRecepcao
------------------------------------------------------------------------------- */

WSCLIENT WSNfeRecepcao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeRecepcaoLote

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeRecepcaoLoteResult    AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeRecepcao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeRecepcao
Return

WSMETHOD RESET WSCLIENT WSNfeRecepcao
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeRecepcaoLoteResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeRecepcao
Local oClone := WSNfeRecepcao():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeRecepcaoLoteResult := ::cnfeRecepcaoLoteResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeRecepcaoLote of Service WSNfeRecepcao
------------------------------------------------------------------------------- */

WSMETHOD nfeRecepcaoLote WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeRecepcaoLoteResult WSCLIENT WSNfeRecepcao
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

If "/dec/" $ Self:_URL
	cSoap += '<nfeRecepcaoLote xmlns="http://nfe.fazenda.df.gov.br/nfe">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 
Else
	cSoap += '<nfeRecepcaoLote xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeRecepcaoLote>"

If "/dec/" $ Self:_URL
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://nfe.fazenda.df.gov.br/nfe/nfeRecepcaoLote",; 
		"DOCUMENT","http://nfe.fazenda.df.gov.br/nfe",,,; 
		"https://dec.fazenda.df.gov.br/dec/ServiceRecepcao.asmx")	
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao/nfeRecepcaoLote",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeRecepcaoSoap")
EndIf

::Init()
::cnfeRecepcaoLoteResult :=  WSAdvValue( oXmlRet,"_NFERECEPCAOLOTERESPONSE:_NFERECEPCAOLOTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If ::cnfeRecepcaoLoteResult==Nil //SP
	::cnfeRecepcaoLoteResult :=  WSAdvValue( oXmlRet,"_P49_NFERECEPCAOLOTERESPONSE:_P49_NFERECEPCAOLOTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If ::cnfeRecepcaoLoteResult==Nil
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFERECEPCAOLOTERESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeRecepcaoLoteResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFERECEPCAOLOTERESPONSE:_"+cPrefixo+"_NFERECEPCAOLOTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.

