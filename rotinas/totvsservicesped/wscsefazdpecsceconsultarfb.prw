#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \system\SCEConsultaRFB.asmx
Gerado em        12/22/08 14:27:52
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RTMZMGN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDpecConsulta
------------------------------------------------------------------------------- */

WSCLIENT WSDpecConsulta

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD dpecConsultaDP

	WSDATA   _URL                       AS String
	WSDATA	 cdpecCabecMsg              AS String
	WSDATA   cdpecDadosMsg              AS string
	WSDATA   cDpecConsultaDPResult      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDpecConsulta
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081104] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDpecConsulta
Return

WSMETHOD RESET WSCLIENT WSDpecConsulta
	::cDpecCabecMsg              := NIL 
	::cDpecDadosMsg              := NIL 
	::dpecConsultaDPResult       := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDpecConsulta
Local oClone := WSDpecConsulta():New()
	oClone:_URL          := ::_URL 
	oClone:cDpecCabecMsg              := ::cDpecCabecMsg
	oClone:cDpecDadosMsg              := ::cDpecDadosMsg
	oClone:cDpecConsultaDPResult      := ::cDpecConsultaDPResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method dpecConsultaDP of Service WSDpecConsulta
------------------------------------------------------------------------------- */

WSMETHOD dpecConsultaDP WSSEND cDpecCabecMsg,cDpecDadosMsg WSRECEIVE cDpecConsultaDPResult WSCLIENT WSDpecConsulta
Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := "" 

BEGIN WSMETHOD

cSoap += '<sceDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/SCEConsultaRFB">'
cSoap += ::cDpecDadosMsg
cSoap += "</sceDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/SCEConsultaRFB/sceConsultaDPEC",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/SCEConsultaRFB",::cDpecCabecMsg,,; 
	"https://hom.nfe.fazenda.gov.br/SCEConsultaRFB/SCEConsultaRFB.asmx")
                                                                        
                                                                         
::Init()
::cDpecConsultaDPResult           :=  Upper (XMLSaveStr(WSAdvValue( oXmlRet,"_SCECONSULTADPECRESULT:_RETCONSDPEC","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.)) 
If Empty(::cDpecConsultaDPResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('SCECONSULTADPECRESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cDpecConsultaDPResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_SCECONSULTADPECRESULT:"+"_"+cPrefixo+"_RETCONS","string",NIL,NIL,NIL,NIL,NIL)
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.