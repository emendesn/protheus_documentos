#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeConsultaSoap/wsdl/NfeConsulta.wsdl
Gerado em        06/18/07 21:44:52
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _STLPOSY ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeConsulta
------------------------------------------------------------------------------- */

WSCLIENT WSNfeConsulta

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeConsultaNF

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeConsultaNFResult      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeConsulta
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeConsulta
Return

WSMETHOD RESET WSCLIENT WSNfeConsulta
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeConsultaNFResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeConsulta
Local oClone := WSNfeConsulta():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeConsultaNFResult := ::cnfeConsultaNFResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeConsultaNF of Service WSNfeConsulta
------------------------------------------------------------------------------- */

WSMETHOD nfeConsultaNF WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeConsultaNFResult WSCLIENT WSNfeConsulta
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD
If "/dec/"$Self:_URL
	cSoap += '<nfeConsultaNF xmlns="http://nfe.fazenda.df.gov.br/">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 	
Else
	cSoap += '<nfeConsultaNF xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeConsultaNF>"
If "/dec/"$Self:_URL
	oXmlRet := SvcSoapCall(	Self,cSoap,; 	
	"http://nfe.fazenda.df.gov.br/nfeConsultaNF",; 
	"DOCUMENT","http://nfe.fazenda.df.gov.br/",,,; 
	"https://dec.fazenda.df.gov.br/dec/ServiceConsulta.asmx")
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta/nfeConsultaNF",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeConsultaSoap")
EndIf
::Init()
::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_NFECONSULTANFRESPONSE:_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If ::cnfeConsultaNFResult==Nil
	::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_P152_NFECONSULTANFRESPONSE:_P152_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If ::cnfeConsultaNFResult==Nil
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFECONSULTANFRESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFECONSULTANFRESPONSE:_"+cPrefixo+"_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.

