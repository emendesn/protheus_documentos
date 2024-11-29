#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \wsdl\CteInutilizacao.html
Gerado em        11/21/08 11:23:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _JZLQWLA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCteInutilizacao
------------------------------------------------------------------------------- */

WSCLIENT WSCteInutilizacao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CteInutilizacaoCT

	WSDATA   _URL                  `
	WSDATA	 ccteCabecMsg              AS String
	WSDATA   ccteDadosMsg              AS string
	WSDATA   cCteInutilizacaoCTResult  AS string
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCteInutilizacao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081117] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCteInutilizacao
Return

WSMETHOD RESET WSCLIENT WSCteInutilizacao
	::ccteCabecMsg              := NIL 
	::ccteDadosMsg              := NIL 
	::CteInutilizacaoCTResult   := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCteInutilizacao
Local oClone := WSCteInutilizacao():New()
	oClone:_URL                      := ::_URL 
	oClone:ccteCabecMsg              := ::ccteCabecMsg
	oClone:ccteDadosMsg              := ::ccteDadosMsg
	oClone:cCteInutilizacaoCTResult := ::cCteInutilizacaoCTResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CteInutilizacaoCT of Service WSCteInutilizacao
------------------------------------------------------------------------------- */

WSMETHOD CteInutilizacaoCT WSSEND ccteCabecMsg,ccteDadosMsg WSRECEIVE cCteInutilizacaoCTResult WSCLIENT WSCteInutilizacao

Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := ""


BEGIN WSMETHOD

cSoap += '<cteDadosMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao">'
cSoap += ::ccteDadosMsg
cSoap += "</cteDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao/CteInutilizacaoCT",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao",::cCTeCabecMsg,,; 
	"https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/CteInutilizacao.asmx")

::Init()
::cCteInutilizacaoCTResult        :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_CTEINUTILIZACAOCTRESULT:_RETINUTCTE","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.))
If Empty(::cCteInutilizacaoCTResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CTEINUTILIZACAOCTRESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cCteInutilizacaoCTResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_CTEINUTILIZACAOCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 	
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.

