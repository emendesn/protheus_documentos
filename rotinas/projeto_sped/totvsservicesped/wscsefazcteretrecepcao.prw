#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \wsdl\cteRetRecepcao.html
Gerado em        11/21/08 11:23:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _JZLQWLC ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WScteRetRecepcao
------------------------------------------------------------------------------- */

WSCLIENT WScteRetRecepcao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CteRetRecepcao

	WSDATA   _URL                  `
	WSDATA	 ccteCabecMsg              AS String
	WSDATA   ccteDadosMsg              AS string
	WSDATA   cCteRetRecepcaoResult     AS string
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WScteRetRecepcao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081117] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WScteRetRecepcao
Return

WSMETHOD RESET WSCLIENT WScteRetRecepcao
	::ccteCabecMsg              := NIL 
	::ccteDadosMsg              := NIL 
	::CteRetRecepcaoResult   := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WScteRetRecepcao
Local oClone := WScteRetRecepcao():New()
	oClone:_URL                      := ::_URL 
	oClone:ccteCabecMsg              := ::ccteCabecMsg
	oClone:ccteDadosMsg              := ::ccteDadosMsg
	oClone:cCteRetRecepcaoResult      := ::cCteRetRecepcaoResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CteRetRecepcao of Service WScteRetRecepcao
------------------------------------------------------------------------------- */

WSMETHOD CteRetRecepcao WSSEND ccteCabecMsg,ccteDadosMsg WSRECEIVE cCteRetRecepcaoResult WSCLIENT WScteRetRecepcao

Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := ""


BEGIN WSMETHOD

cSoap += '<cteDadosMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao">'
cSoap += ::ccteDadosMsg
cSoap += "</cteDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,;     
	"http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao",::cCTeCabecMsg,,; 
	"https://homologacao.cte.sefaz.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx")
	

::Init()
::cCteRetRecepcaoResult        :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_CTERETRECEPCAORESULT:_RETCONSRECICTE","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.))
If Empty(::cCteRetRecepcaoResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CTERETRECEPCAORESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cCteRetRecepcaoResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_CTERETRECEPCAORESULT:"+"_"+cPrefixo+"_RETCONSRECICTE","string",NIL,NIL,NIL,NIL,NIL) 	
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.

