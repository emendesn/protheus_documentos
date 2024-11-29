#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeRetRecepcaoSoap/wsdl/NfeRetRecepcao.wsdl
Gerado em        06/18/07 21:43:00
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QQFAKKO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeRetRecepcao
------------------------------------------------------------------------------- */

WSCLIENT WSNfeRetRecepcao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeRetRecepcao

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeRetRecepcaoResult     AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeRetRecepcao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeRetRecepcao
Return

WSMETHOD RESET WSCLIENT WSNfeRetRecepcao
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeRetRecepcaoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeRetRecepcao
Local oClone := WSNfeRetRecepcao():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeRetRecepcaoResult := ::cnfeRetRecepcaoResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeRetRecepcao of Service WSNfeRetRecepcao
------------------------------------------------------------------------------- */

WSMETHOD nfeRetRecepcao WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeRetRecepcaoResult WSCLIENT WSNfeRetRecepcao
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

If "/dec/" $ Self:_URL
	cSoap += '<nfeRetRecepcao xmlns="http://nfe.fazenda.df.gov.br/">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.)
Else
	cSoap += '<nfeRetRecepcao xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeRetRecepcao>"

If "/dec/" $ Self:_URL
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://nfe.fazenda.df.gov.br/nfeRetRecepcao",; 
		"DOCUMENT","http://nfe.fazenda.df.gov.br/",,,; 
		"https://dec.fazenda.df.gov.br/dec/ServiceRetRecepcao.asmx")	
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao/nfeRetRecepcao",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeRetRecepcaoSoap")
EndIf	
::Init()
::cnfeRetRecepcaoResult :=  WSAdvValue( oXmlRet,"_NFERETRECEPCAORESPONSE:_NFERETRECEPCAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If ::cnfeRetRecepcaoResult == Nil
	::cnfeRetRecepcaoResult :=  WSAdvValue( oXmlRet,"_P748_NFERETRECEPCAORESPONSE:_P748_NFERETRECEPCAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If ::cnfeRetRecepcaoResult == Nil
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFERETRECEPCAORESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeRetRecepcaoResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFERETRECEPCAORESPONSE:_"+cPrefixo+"_NFERETRECEPCAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.

