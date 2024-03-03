#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeCancelamentoSoap/wsdl/NfeCancelamento.wsdl
Gerado em        06/18/07 21:42:11
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QVUTOSA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeCancelamento
------------------------------------------------------------------------------- */

WSCLIENT WSNfeCancelamento

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeCancelamentoNF

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeCancelamentoNFResult  AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeCancelamento
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeCancelamento
Return

WSMETHOD RESET WSCLIENT WSNfeCancelamento
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeCancelamentoNFResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeCancelamento
Local oClone := WSNfeCancelamento():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeCancelamentoNFResult := ::cnfeCancelamentoNFResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeCancelamentoNF of Service WSNfeCancelamento
------------------------------------------------------------------------------- */

WSMETHOD nfeCancelamentoNF WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeCancelamentoNFResult WSCLIENT WSNfeCancelamento
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

If "/dec/" $ Self:_URL
	cSoap += '<nfeCancelamentoNF xmlns="http://nfe.fazenda.df.gov.br/nfe">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 
Else
	cSoap += '<nfeCancelamentoNF xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeCancelamentoNF>"

If "/dec/" $ Self:_URL
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://nfe.fazenda.df.gov.br/nfe/nfeCancelamentoNF",; 
		"DOCUMENT","http://nfe.fazenda.df.gov.br/nfe",,,; 
		"https://dec.fazenda.df.gov.br/dec/ServiceCancelamento.asmx")
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento/nfeCancelamentoNF",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeCancelamentoSoap")
EndIf

::Init()
::cnfeCancelamentoNFResult :=  WSAdvValue( oXmlRet,"_NFECANCELAMENTONFRESPONSE:_NFECANCELAMENTONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If ::cnfeCancelamentoNFResult==Nil
	::cnfeCancelamentoNFResult :=  WSAdvValue( oXmlRet,"_P301_NFECANCELAMENTONFRESPONSE:_P301_NFECANCELAMENTONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If ::cnfeCancelamentoNFResult==Nil
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFECANCELAMENTONFRESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeCancelamentoNFResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFECANCELAMENTONFRESPONSE:_"+cPrefixo+"_NFECANCELAMENTONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL)
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.