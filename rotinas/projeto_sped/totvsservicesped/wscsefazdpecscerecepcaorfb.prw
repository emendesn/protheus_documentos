#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \system\SCERecepcaoRFB.asmx
Gerado em        12/22/08 11:57:48
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _GGIKYDZ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDpecRecepcao
------------------------------------------------------------------------------- */

WSCLIENT WSDpecRecepcao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD DpecRecepcaoDp

	WSDATA   _URL                      
	WSDATA   cDpecCabecMsg             AS string
	WSDATA   cDpecDadosMsg             AS string
	WSDATA   cDpecRecepcaoDPResult     AS string
ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDpecRecepcao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081104] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDpecRecepcao
Return

WSMETHOD RESET WSCLIENT WSSDpecRecepcao
	::cDpecCabecMsg       	:= NIL 
	::cDpecDadosMsg     	:= NIL 
	::DpecRecepcaoDPResult   := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDpecRecepcao
Local oClone := WSDepcRecepcao():New()
	oClone:_URL          			 := ::_URL 
	oClone:cDpecCabecMsg              := ::cDpecCabecMsg
	oClone:cDpecDadosMsg              := ::cDpecDadosMsg
	oClone:cDPECRecepcaoDPResult      := ::cDpecRecepcaoDPResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method DpecRecepcaoDP of Service WSDpecRecepcao
------------------------------------------------------------------------------- */

WSMETHOD DpecRecepcaoDP WSSEND cDpecCabecMsg,cDpecDadosMsg WSRECEIVE cdpecDPResult WSCLIENT WSDpecRecepcao
Local cSoap    := ""
Local oXmlRet
Local nX       := 0
Local nY       := 0
Local cPrefixo := "" 

BEGIN WSMETHOD

cSoap +='<sceDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/SCERecepcaoRFB">'
cSoap += ::cDpecDadosMsg
cSoap += "</sceDadosMsg>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"http://www.portalfiscal.inf.br/nfe/wsdl/SCERecepcaoRFB/sceRecepcaoDPEC",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/SCERecepcaoRFB",::cDpecCabecMsg,,; 
	"https://hom.nfe.fazenda.gov.br/SCERecepcaoRFB/SCERecepcaoRFB.asmx")
	
::Init()
::cDpecRecepcaoDPResult := Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_SCERECEPCAODPECRESULT:_RETDPEC","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.)) 

If Empty(::cDpecRecepcaoDPResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('SCERECEPCAODPECRESULT',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::ccteConsultaCTResult := WSAdvValue( oXmlRet,"_"+cPrefixo+"_SCERECEPCAODPECRESULT:"+"_"+cPrefixo+"_RETDPEC","string",NIL,NIL,NIL,NIL,NIL)
	EndIf
EndIf

END WSMETHOD
oXmlRet := NIL
Return .T.
