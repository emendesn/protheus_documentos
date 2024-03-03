#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \WSDL\CTECONSULTA.HTML
Gerado em        11/21/08 11:02:43
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.080707
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _HQYFLKB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCteConsulta
------------------------------------------------------------------------------- */

WSCLIENT WSCteConsulta

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD cteConsultaCT

	WSDATA   _URL                      AS String
	WSDATA	 ccteCabecMsg              AS String
	WSDATA   ccteDadosMsg              AS string
	WSDATA   cCTeConsultaCTResult      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCteConsulta
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.080806P-20081117] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCteConsulta
Return

WSMETHOD RESET WSCLIENT WSCteConsulta
	::ccteCabecMsg              := NIL 
	::ccteDadosMsg              := NIL 
	::cteConsultaCTResult       := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCteConsulta
Local oClone := WSCteConsulta():New()
	oClone:_URL                      := ::_URL 
	oClone:ccteCabecMsg              := ::ccteCabecMsg
	oClone:ccteDadosMsg              := ::ccteDadosMsg
	oClone:ccteConsultaCTResult      := ::ccteConsultaCTResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method cteConsultaCT of Service WSCteConsulta
------------------------------------------------------------------------------- */

WSMETHOD cteConsultaCT WSSEND ccteCabecMsg,ccteDadosMsg WSRECEIVE ccteConsultaCTResult WSCLIENT WSCteConsulta
Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := ""

BEGIN WSMETHOD

cSoap += '<cteDadosMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta">'
cSoap += ::ccteDadosMsg
cSoap += "</cteDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta",::ccteCabecMsg,,; 
	"https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx")

::Init()
::ccteConsultaCTResult        :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_CTECONSULTACTRESULT:_RETCONSSITCTE","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.))
If Empty(::ccteConsultaCTResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CTECONSULTACTRESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::ccteConsultaCTResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_CTECONSULTACTRESULT:"+"_"+cPrefixo+"_RETCONSSITCTE","string",NIL,NIL,NIL,NIL,NIL)
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.

