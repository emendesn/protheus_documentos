#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://hnfe.sefaz.ba.gov.br/webservices/nfe/CadConsultaCadastro.asmx?wsdl
Gerado em        11/01/07 18:40:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MJZMCZA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCadConsultaCadastro
------------------------------------------------------------------------------- */

WSCLIENT WSCadConsultaCadastro

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD consultaCadastro
	WSMETHOD consultaCadastro_1

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cconsultaCadastroResult   AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCadConsultaCadastro
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070910P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCadConsultaCadastro
Return

WSMETHOD RESET WSCLIENT WSCadConsultaCadastro
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cconsultaCadastroResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCadConsultaCadastro
Local oClone := WSCadConsultaCadastro():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cconsultaCadastroResult := ::cconsultaCadastroResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method consultaCadastro of Service WSCadConsultaCadastro
------------------------------------------------------------------------------- */

WSMETHOD consultaCadastro WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cconsultaCadastroResult WSCLIENT WSCadConsultaCadastro
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<consultaCadastro xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro">'
cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
cSoap += "</consultaCadastro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro/consultaCadastro",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro",,,; 
	"https://hnfe.sefaz.ba.gov.br/webservices/nfe/CadConsultaCadastro.asmx")

::Init()
::cconsultaCadastroResult :=  WSAdvValue( oXmlRet,"_CONSULTACADASTRORESPONSE:_CONSULTACADASTRORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method consultaCadastro_1 of Service WSCadConsultaCadastro
------------------------------------------------------------------------------- */

WSMETHOD consultaCadastro_1 WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cconsultaCadastroResult WSCLIENT WSCadConsultaCadastro
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

cSoap += '<consultaCadastro xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro">'
cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
cSoap += "</consultaCadastro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro/consultaCadastro",; 
	"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro",,,; 
	"https://hnfe.sefaz.ba.gov.br/webservices/nfe/CadConsultaCadastro.asmx")

::Init()
::cconsultaCadastroResult :=  WSAdvValue( oXmlRet,"_CONSULTACADASTRORESPONSE:_CONSULTACADASTRORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If Empty(::cconsultaCadastroResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('CONSULTACADASTRORESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cconsultaCadastroResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_CONSULTACADASTRORESPONSE:_"+cPrefixo+"_CONSULTACADASTRORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
	EndIf
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

