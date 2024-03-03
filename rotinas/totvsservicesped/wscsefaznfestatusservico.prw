#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeStatusServicoSoap/wsdl/NfeStatusServico.wsdl
Gerado em        06/20/07 11:51:11
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MOLXFLK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeStatusServico
------------------------------------------------------------------------------- */

WSCLIENT WSNfeStatusServico

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeStatusServicoNF

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeStatusServicoNFResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeStatusServico
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeStatusServico
Return

WSMETHOD RESET WSCLIENT WSNfeStatusServico
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeStatusServicoNFResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeStatusServico
Local oClone := WSNfeStatusServico():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeStatusServicoNFResult := ::cnfeStatusServicoNFResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeStatusServicoNF of Service WSNfeStatusServico
------------------------------------------------------------------------------- */

WSMETHOD nfeStatusServicoNF WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeStatusServicoNFResult WSCLIENT WSNfeStatusServico
Local cSoap    := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

If "/dec/" $ Self:_URL 
	cSoap += '<nfeStatusServicoNF xmlns="http://nfe.fazenda.df.gov.br/">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 
Else
	cSoap += '<nfeStatusServicoNF xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeStatusServicoNF>"


If "/dec/" $ Self:_URL 
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://nfe.fazenda.df.gov.br/nfeStatusServicoNF",; 
		"DOCUMENT","http://nfe.fazenda.df.gov.br/",,,; 
		"https://dec.fazenda.df.gov.br/dec/ServiceStatus.asmx")
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico/nfeStatusServicoNF",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeStatusServicoSoap")
EndIf

::Init()
::cnfeStatusServicoNFResult :=  WSAdvValue( oXmlRet,"_NFESTATUSSERVICONFRESPONSE:_NFESTATUSSERVICONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If Empty(::cnfeStatusServicoNFResult)
	::cnfeStatusServicoNFResult :=  WSAdvValue( oXmlRet,"_P870_NFESTATUSSERVICONFRESPONSE:_P870_NFESTATUSSERVICONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If Empty(::cnfeStatusServicoNFResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFESTATUSSERVICONFRESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeStatusServicoNFResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFESTATUSSERVICONFRESPONSE:_"+cPrefixo+"_NFESTATUSSERVICONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 	
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.

