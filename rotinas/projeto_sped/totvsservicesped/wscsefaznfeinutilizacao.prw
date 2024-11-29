#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/NfeInutilizacaoSoap/wsdl/NfeInutilizacao.wsdl
Gerado em        06/18/07 21:46:54
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MYWVSHP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNfeInutilizacao
------------------------------------------------------------------------------- */

WSCLIENT WSNfeInutilizacao

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeInutilizacaoNF

	WSDATA   _URL                      AS String
	WSDATA   cnfeCabecMsg              AS string
	WSDATA   cnfeDadosMsg              AS string
	WSDATA   cnfeInutilizacaoNFResult  AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfeInutilizacao
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfeInutilizacao
Return

WSMETHOD RESET WSCLIENT WSNfeInutilizacao
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeInutilizacaoNFResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfeInutilizacao
Local oClone := WSNfeInutilizacao():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeInutilizacaoNFResult := ::cnfeInutilizacaoNFResult
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeInutilizacaoNF of Service WSNfeInutilizacao
------------------------------------------------------------------------------- */

WSMETHOD nfeInutilizacaoNF WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeInutilizacaoNFResult WSCLIENT WSNfeInutilizacao
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0

BEGIN WSMETHOD

If "/dec/" $ Self:_URL
	cSoap += '<nfeInutilizacaoNF xmlns="http://nfe.fazenda.df.gov.br/nfe">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 
Else
	cSoap += '<nfeInutilizacaoNF xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao">'
	cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
	cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
EndIf
cSoap += "</nfeInutilizacaoNF>"

If "/dec/" $ Self:_URL
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://nfe.fazenda.df.gov.br/nfe/nfeInutilizacaoNF",; 
		"DOCUMENT","http://nfe.fazenda.df.gov.br/nfe",,,; 
		"https://dec.fazenda.df.gov.br/dec/ServiceInutilizacao.asmx")
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
		"http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao/nfeInutilizacaoNF",; 
		"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao",,,; 
		"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeInutilizacaoSoap")
EndIf	
::Init()
::cnfeInutilizacaoNFResult :=  WSAdvValue( oXmlRet,"_NFEINUTILIZACAONFRESPONSE:_NFEINUTILIZACAONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
If Empty(::cnfeInutilizacaoNFResult)
	::cnfeInutilizacaoNFResult :=  WSAdvValue( oXmlRet,"_P795_NFEINUTILIZACAONFRESPONSE:_P795_NFEINUTILIZACAONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
EndIf
If Empty(::cnfeInutilizacaoNFResult)
	//--------------------------------------------------
	//Procura o namespace criado pela SEF
	//--------------------------------------------------
	cXML := Upper(XMLSaveStr(oxmlret,.F.))
	nX   := At('NFEINUTILIZACAONFRESPONSE',cXml)-1
	nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
	cPrefixo := SubStr(cXml,nY,nX-nY)
	If !Empty(cPrefixo)
		::cnfeInutilizacaoNFResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFEINUTILIZACAONFRESPONSE:_"+cPrefixo+"_NFEINUTILIZACAONFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
	EndIf
EndIf

END WSMETHOD

oXmlRet := NIL
Return .T.