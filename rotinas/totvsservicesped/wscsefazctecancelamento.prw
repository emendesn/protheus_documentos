#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \wsdl\cteCancelamento.html
Gerado em        11/21/08 11:23:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _JZLQWLP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCteCancelamento
------------------------------------------------------------------------------- */

WSCLIENT WSCteCancelamento

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD cteCancelamentoCT

	WSDATA   _URL                  `
	WSDATA	 ccteCabecMsg              AS String
	WSDATA   ccteDadosMsg              AS string
	WSDATA   cCTeCancelamentoCTResult  AS string
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCteCancelamento
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081117] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCteCancelamento
Return

WSMETHOD RESET WSCLIENT WSCteCancelamento
	::ccteCabecMsg              := NIL 
	::ccteDadosMsg              := NIL 
	::CTeCancelamentoCTResult   := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCteCancelamento
Local oClone := WSCteCancelamento():New()
	oClone:_URL                      := ::_URL 
	oClone:ccteCabecMsg              := ::ccteCabecMsg
	oClone:ccteDadosMsg              := ::ccteDadosMsg
	oClone:cCTeCancelamentoCTResult := ::cCTeCancelamentoCTResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method cteCancelamentoCT of Service WSCteCancelamento
------------------------------------------------------------------------------- */

WSMETHOD cteCancelamentoCT WSSEND ccteCabecMsg,ccteDadosMsg WSRECEIVE cCTeCancelamentoCTResult WSCLIENT WSCteCancelamento

Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := ""


BEGIN WSMETHOD

cSoap += '<cteDadosMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteCancelamento">'
cSoap += ::ccteDadosMsg
cSoap += "</cteDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/cte/wsdl/CteCancelamento/cteCancelamentoCT",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/cte/wsdl/CteCancelamento",::cCTeCabecMsg,,; 
	"https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteCancelamento.asmx")

::Init()
::cCTeCancelamentoCTResult        :=  WSAdvValue( oXmlRet,"_CTECANCELAMENTOCTRESULT:_ANYOUT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
If Empty(::cCTeCancelamentoCTResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CTECANCELAMENTOCTRESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cCTeCancelamentoCTResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_CTECANCELAMENTOCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 	
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.

