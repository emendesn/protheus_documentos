#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \wsdl\CteRecepcao.html
Gerado em        11/21/08 11:23:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _JZLQWLB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCteRecepcao
------------------------------------------------------------------------------- */

WSCLIENT WSCteRecepcao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CteRecepcaoCT

	WSDATA   _URL                  `
	WSDATA	 ccteCabecMsg              AS String
	WSDATA   ccteDadosMsg              AS string
	WSDATA   cCteRecepcaoCTResult  AS string
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCteRecepcao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081117] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCteRecepcao
Return

WSMETHOD RESET WSCLIENT WSCteRecepcao
	::ccteCabecMsg              := NIL 
	::ccteDadosMsg              := NIL 
	::CteRecepcaoCTResult   := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCteRecepcao
Local oClone := WSCteRecepcao():New()
	oClone:_URL                      := ::_URL 
	oClone:ccteCabecMsg              := ::ccteCabecMsg
	oClone:ccteDadosMsg              := ::ccteDadosMsg
	oClone:cCteRecepcaoCTResult      := ::cCteRecepcaoCTResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CteRecepcaoCT of Service WSCteRecepcao
------------------------------------------------------------------------------- */

WSMETHOD CteRecepcaoCT WSSEND ccteCabecMsg,ccteDadosMsg WSRECEIVE cCteRecepcaoCTResult WSCLIENT WSCteRecepcao

Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := ""


BEGIN WSMETHOD

cSoap += '<cteDadosMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao">'
cSoap += ::ccteDadosMsg
cSoap += "</cteDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao/CteRecepcaoCT",; 
	"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao",::cCTeCabecMsg,,; 
	"https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/CteRecepcao.asmx")

::Init()
::cCteRecepcaoCTResult        :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_CTERECEPCAOLOTERESULT:_RETENVICTE","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.))
If Empty(::cCteRecepcaoCTResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CTERECEPCAOLOTERESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cCteRecepcaoCTResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_CTERECEPCAOLOTERESULT:"+"_"+cPrefixo+"_RETENVICTE","string",NIL,NIL,NIL,NIL,NIL) 	
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.

