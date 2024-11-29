#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDCFGNFE.apw?WSDL
Gerado em        11/25/08 05:54:29
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _DWNJKJG ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDCFGNFE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CFGAMBIENTE
	WSMETHOD CFGAMBIENTEEX
	WSMETHOD CFGCERTIFICATE
	WSMETHOD CFGCERTIFICATEPFX
	WSMETHOD CFGCONNECT
	WSMETHOD CFGCONNECTEX
	WSMETHOD CFGHSM
	WSMETHOD CFGMODALIDADE
	WSMETHOD CFGMODALIDADEEX
	WSMETHOD CFGPOPMAIL
	WSMETHOD CFGREADY
	WSMETHOD CFGREADYEX
	WSMETHOD CFGSMTPMAIL
	WSMETHOD CFGSTATUSCERTIFICATE
	WSMETHOD CFGTEMPOESPERA
	WSMETHOD CFGTSSVERSAO
	WSMETHOD CFGVERSAO
	WSMETHOD CFGVERSAOCTE
	WSMETHOD CFGVERSAODPEC
	WSMETHOD GETPOPMAIL
	WSMETHOD GETSMTPMAIL

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   cID_ENT                   AS string
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   cCFGAMBIENTERESULT        AS string
	WSDATA   nCFGAMBIENTEEXRESULT      AS integer
	WSDATA   cCERTIFICATE              AS base64binary
	WSDATA   cPRIVATEKEY               AS base64binary
	WSDATA   cPASSWORD                 AS base64binary
	WSDATA   cCFGCERTIFICATERESULT     AS string
	WSDATA   cCFGCERTIFICATEPFXRESULT  AS string
	WSDATA   cCFGCONNECTRESULT         AS string
	WSDATA   nCFGCONNECTEXRESULT       AS integer
	WSDATA   cSLOT                     AS base64binary
	WSDATA   cLABEL                    AS base64binary
	WSDATA   cMODULE                   AS base64binary
	WSDATA   cCFGHSMRESULT             AS string
	WSDATA   nMODALIDADE               AS integer
	WSDATA   cCFGMODALIDADERESULT      AS string
	WSDATA   nCFGMODALIDADEEXRESULT    AS integer
	WSDATA   oWSPOP                    AS SPEDCFGNFE_POPSERVER
	WSDATA   cCFGPOPMAILRESULT         AS string
	WSDATA   cCFGREADYRESULT           AS string
	WSDATA   nCFGREADYEXRESULT         AS integer
	WSDATA   oWSSMTP                   AS SPEDCFGNFE_SMTPSERVER
	WSDATA   cCFGSMTPMAILRESULT        AS string
	WSDATA   oWSCFGSTATUSCERTIFICATERESULT AS SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	WSDATA   nTEMPOESPERA              AS integer
	WSDATA   nCFGTEMPOESPERARESULT     AS integer
	WSDATA   cCFGTSSVERSAORESULT       AS string
	WSDATA   cVERSAO                   AS string
	WSDATA   cCFGVERSAORESULT          AS string
	WSDATA   cCFGVERSAOCTERESULT       AS string
	WSDATA   cCFGVERSAODPECRESULT      AS string
	WSDATA   oWSGETPOPMAILRESULT       AS SPEDCFGNFE_POPSERVER
	WSDATA   oWSGETSMTPMAILRESULT      AS SPEDCFGNFE_SMTPSERVER

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSPOPSERVER              AS SPEDCFGNFE_POPSERVER
	WSDATA   oWSSMTPSERVER             AS SPEDCFGNFE_SMTPSERVER

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDCFGNFE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081023] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDCFGNFE
	::oWSPOP             := SPEDCFGNFE_POPSERVER():New()
	::oWSSMTP            := SPEDCFGNFE_SMTPSERVER():New()
	::oWSCFGSTATUSCERTIFICATERESULT := SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE():New()
	::oWSGETPOPMAILRESULT := SPEDCFGNFE_POPSERVER():New()
	::oWSGETSMTPMAILRESULT := SPEDCFGNFE_SMTPSERVER():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPOPSERVER       := ::oWSPOP
	::oWSSMTPSERVER      := ::oWSSMTP
Return

WSMETHOD RESET WSCLIENT WSSPEDCFGNFE
	::cUSERTOKEN         := NIL 
	::cID_ENT            := NIL 
	::nAMBIENTE          := NIL 
	::cCFGAMBIENTERESULT := NIL 
	::nCFGAMBIENTEEXRESULT := NIL 
	::cCERTIFICATE       := NIL 
	::cPRIVATEKEY        := NIL 
	::cPASSWORD          := NIL 
	::cCFGCERTIFICATERESULT := NIL 
	::cCFGCERTIFICATEPFXRESULT := NIL 
	::cCFGCONNECTRESULT  := NIL 
	::nCFGCONNECTEXRESULT := NIL 
	::cSLOT              := NIL 
	::cLABEL             := NIL 
	::cMODULE            := NIL 
	::cCFGHSMRESULT      := NIL 
	::nMODALIDADE        := NIL 
	::cCFGMODALIDADERESULT := NIL 
	::nCFGMODALIDADEEXRESULT := NIL 
	::oWSPOP             := NIL 
	::cCFGPOPMAILRESULT  := NIL 
	::cCFGREADYRESULT    := NIL 
	::nCFGREADYEXRESULT  := NIL 
	::oWSSMTP            := NIL 
	::cCFGSMTPMAILRESULT := NIL 
	::oWSCFGSTATUSCERTIFICATERESULT := NIL 
	::nTEMPOESPERA       := NIL 
	::nCFGTEMPOESPERARESULT := NIL 
	::cCFGTSSVERSAORESULT := NIL 
	::cVERSAO            := NIL 
	::cCFGVERSAORESULT   := NIL 
	::cCFGVERSAOCTERESULT := NIL 
	::cCFGVERSAODPECRESULT := NIL 
	::oWSGETPOPMAILRESULT := NIL 
	::oWSGETSMTPMAILRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPOPSERVER       := NIL
	::oWSSMTPSERVER      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDCFGNFE
Local oClone := WSSPEDCFGNFE():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:cID_ENT       := ::cID_ENT
	oClone:nAMBIENTE     := ::nAMBIENTE
	oClone:cCFGAMBIENTERESULT := ::cCFGAMBIENTERESULT
	oClone:nCFGAMBIENTEEXRESULT := ::nCFGAMBIENTEEXRESULT
	oClone:cCERTIFICATE  := ::cCERTIFICATE
	oClone:cPRIVATEKEY   := ::cPRIVATEKEY
	oClone:cPASSWORD     := ::cPASSWORD
	oClone:cCFGCERTIFICATERESULT := ::cCFGCERTIFICATERESULT
	oClone:cCFGCERTIFICATEPFXRESULT := ::cCFGCERTIFICATEPFXRESULT
	oClone:cCFGCONNECTRESULT := ::cCFGCONNECTRESULT
	oClone:nCFGCONNECTEXRESULT := ::nCFGCONNECTEXRESULT
	oClone:cSLOT         := ::cSLOT
	oClone:cLABEL        := ::cLABEL
	oClone:cMODULE       := ::cMODULE
	oClone:cCFGHSMRESULT := ::cCFGHSMRESULT
	oClone:nMODALIDADE   := ::nMODALIDADE
	oClone:cCFGMODALIDADERESULT := ::cCFGMODALIDADERESULT
	oClone:nCFGMODALIDADEEXRESULT := ::nCFGMODALIDADEEXRESULT
	oClone:oWSPOP        :=  IIF(::oWSPOP = NIL , NIL ,::oWSPOP:Clone() )
	oClone:cCFGPOPMAILRESULT := ::cCFGPOPMAILRESULT
	oClone:cCFGREADYRESULT := ::cCFGREADYRESULT
	oClone:nCFGREADYEXRESULT := ::nCFGREADYEXRESULT
	oClone:oWSSMTP       :=  IIF(::oWSSMTP = NIL , NIL ,::oWSSMTP:Clone() )
	oClone:cCFGSMTPMAILRESULT := ::cCFGSMTPMAILRESULT
	oClone:oWSCFGSTATUSCERTIFICATERESULT :=  IIF(::oWSCFGSTATUSCERTIFICATERESULT = NIL , NIL ,::oWSCFGSTATUSCERTIFICATERESULT:Clone() )
	oClone:nTEMPOESPERA  := ::nTEMPOESPERA
	oClone:nCFGTEMPOESPERARESULT := ::nCFGTEMPOESPERARESULT
	oClone:cCFGTSSVERSAORESULT := ::cCFGTSSVERSAORESULT
	oClone:cVERSAO       := ::cVERSAO
	oClone:cCFGVERSAORESULT := ::cCFGVERSAORESULT
	oClone:cCFGVERSAOCTERESULT := ::cCFGVERSAOCTERESULT
	oClone:cCFGVERSAODPECRESULT := ::cCFGVERSAODPECRESULT
	oClone:oWSGETPOPMAILRESULT :=  IIF(::oWSGETPOPMAILRESULT = NIL , NIL ,::oWSGETPOPMAILRESULT:Clone() )
	oClone:oWSGETSMTPMAILRESULT :=  IIF(::oWSGETSMTPMAILRESULT = NIL , NIL ,::oWSGETSMTPMAILRESULT:Clone() )

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSPOPSERVER  := oClone:oWSPOP
	oClone:oWSSMTPSERVER := oClone:oWSSMTP
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CFGAMBIENTE of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGAMBIENTE WSSEND cUSERTOKEN,cID_ENT,nAMBIENTE WSRECEIVE cCFGAMBIENTERESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGAMBIENTE xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AMBIENTE", ::nAMBIENTE, nAMBIENTE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGAMBIENTE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGAMBIENTE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGAMBIENTERESULT :=  WSAdvValue( oXmlRet,"_CFGAMBIENTERESPONSE:_CFGAMBIENTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGAMBIENTEEX of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGAMBIENTEEX WSSEND cUSERTOKEN,cID_ENT,nAMBIENTE WSRECEIVE nCFGAMBIENTEEXRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGAMBIENTEEX xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AMBIENTE", ::nAMBIENTE, nAMBIENTE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGAMBIENTEEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGAMBIENTEEX",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::nCFGAMBIENTEEXRESULT :=  WSAdvValue( oXmlRet,"_CFGAMBIENTEEXRESPONSE:_CFGAMBIENTEEXRESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGCERTIFICATE of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGCERTIFICATE WSSEND cUSERTOKEN,cID_ENT,cCERTIFICATE,cPRIVATEKEY,cPASSWORD WSRECEIVE cCFGCERTIFICATERESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGCERTIFICATE xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CERTIFICATE", ::cCERTIFICATE, cCERTIFICATE , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PRIVATEKEY", ::cPRIVATEKEY, cPRIVATEKEY , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PASSWORD", ::cPASSWORD, cPASSWORD , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGCERTIFICATE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGCERTIFICATE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGCERTIFICATERESULT :=  WSAdvValue( oXmlRet,"_CFGCERTIFICATERESPONSE:_CFGCERTIFICATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGCERTIFICATEPFX of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGCERTIFICATEPFX WSSEND cUSERTOKEN,cID_ENT,cCERTIFICATE,cPASSWORD WSRECEIVE cCFGCERTIFICATEPFXRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGCERTIFICATEPFX xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CERTIFICATE", ::cCERTIFICATE, cCERTIFICATE , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PASSWORD", ::cPASSWORD, cPASSWORD , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGCERTIFICATEPFX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGCERTIFICATEPFX",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGCERTIFICATEPFXRESULT :=  WSAdvValue( oXmlRet,"_CFGCERTIFICATEPFXRESPONSE:_CFGCERTIFICATEPFXRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGCONNECT of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGCONNECT WSSEND cUSERTOKEN WSRECEIVE cCFGCONNECTRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGCONNECT xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGCONNECT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGCONNECT",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGCONNECTRESULT  :=  WSAdvValue( oXmlRet,"_CFGCONNECTRESPONSE:_CFGCONNECTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGCONNECTEX of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGCONNECTEX WSSEND cUSERTOKEN WSRECEIVE nCFGCONNECTEXRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGCONNECTEX xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGCONNECTEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGCONNECTEX",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::nCFGCONNECTEXRESULT :=  WSAdvValue( oXmlRet,"_CFGCONNECTEXRESPONSE:_CFGCONNECTEXRESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGHSM of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGHSM WSSEND cUSERTOKEN,cID_ENT,cSLOT,cLABEL,cMODULE,cPASSWORD WSRECEIVE cCFGHSMRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGHSM xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("SLOT", ::cSLOT, cSLOT , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("LABEL", ::cLABEL, cLABEL , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MODULE", ::cMODULE, cMODULE , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PASSWORD", ::cPASSWORD, cPASSWORD , "base64binary", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGHSM>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGHSM",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGHSMRESULT      :=  WSAdvValue( oXmlRet,"_CFGHSMRESPONSE:_CFGHSMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGMODALIDADE of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGMODALIDADE WSSEND cUSERTOKEN,cID_ENT,nMODALIDADE WSRECEIVE cCFGMODALIDADERESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGMODALIDADE xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MODALIDADE", ::nMODALIDADE, nMODALIDADE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGMODALIDADE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGMODALIDADE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGMODALIDADERESULT :=  WSAdvValue( oXmlRet,"_CFGMODALIDADERESPONSE:_CFGMODALIDADERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGMODALIDADEEX of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGMODALIDADEEX WSSEND cUSERTOKEN,cID_ENT,nMODALIDADE WSRECEIVE nCFGMODALIDADEEXRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGMODALIDADEEX xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MODALIDADE", ::nMODALIDADE, nMODALIDADE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGMODALIDADEEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGMODALIDADEEX",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::nCFGMODALIDADEEXRESULT :=  WSAdvValue( oXmlRet,"_CFGMODALIDADEEXRESPONSE:_CFGMODALIDADEEXRESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGPOPMAIL of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGPOPMAIL WSSEND cUSERTOKEN,cID_ENT,oWSPOP WSRECEIVE cCFGPOPMAILRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGPOPMAIL xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("POP", ::oWSPOP, oWSPOP , "POPSERVER", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGPOPMAIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGPOPMAIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGPOPMAILRESULT  :=  WSAdvValue( oXmlRet,"_CFGPOPMAILRESPONSE:_CFGPOPMAILRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGREADY of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGREADY WSSEND cUSERTOKEN,cID_ENT WSRECEIVE cCFGREADYRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGREADY xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGREADY>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGREADY",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGREADYRESULT    :=  WSAdvValue( oXmlRet,"_CFGREADYRESPONSE:_CFGREADYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGREADYEX of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGREADYEX WSSEND cUSERTOKEN,cID_ENT WSRECEIVE nCFGREADYEXRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGREADYEX xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGREADYEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGREADYEX",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::nCFGREADYEXRESULT  :=  WSAdvValue( oXmlRet,"_CFGREADYEXRESPONSE:_CFGREADYEXRESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGSMTPMAIL of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGSMTPMAIL WSSEND cUSERTOKEN,cID_ENT,oWSSMTP WSRECEIVE cCFGSMTPMAILRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGSMTPMAIL xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("SMTP", ::oWSSMTP, oWSSMTP , "SMTPSERVER", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGSMTPMAIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGSMTPMAIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGSMTPMAILRESULT :=  WSAdvValue( oXmlRet,"_CFGSMTPMAILRESPONSE:_CFGSMTPMAILRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGSTATUSCERTIFICATE of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGSTATUSCERTIFICATE WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSCFGSTATUSCERTIFICATERESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGSTATUSCERTIFICATE xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGSTATUSCERTIFICATE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGSTATUSCERTIFICATE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::oWSCFGSTATUSCERTIFICATERESULT:SoapRecv( WSAdvValue( oXmlRet,"_CFGSTATUSCERTIFICATERESPONSE:_CFGSTATUSCERTIFICATERESULT","ARRAYOFDIGITALCERTIFICATE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGTEMPOESPERA of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGTEMPOESPERA WSSEND cUSERTOKEN,cID_ENT,nTEMPOESPERA WSRECEIVE nCFGTEMPOESPERARESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGTEMPOESPERA xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("TEMPOESPERA", ::nTEMPOESPERA, nTEMPOESPERA , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGTEMPOESPERA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGTEMPOESPERA",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::nCFGTEMPOESPERARESULT :=  WSAdvValue( oXmlRet,"_CFGTEMPOESPERARESPONSE:_CFGTEMPOESPERARESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGTSSVERSAO of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGTSSVERSAO WSSEND cUSERTOKEN WSRECEIVE cCFGTSSVERSAORESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGTSSVERSAO xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGTSSVERSAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGTSSVERSAO",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGTSSVERSAORESULT :=  WSAdvValue( oXmlRet,"_CFGTSSVERSAORESPONSE:_CFGTSSVERSAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGVERSAO of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGVERSAO WSSEND cUSERTOKEN,cID_ENT,cVERSAO WSRECEIVE cCFGVERSAORESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGVERSAO xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VERSAO", ::cVERSAO, cVERSAO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGVERSAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGVERSAO",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGVERSAORESULT   :=  WSAdvValue( oXmlRet,"_CFGVERSAORESPONSE:_CFGVERSAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGVERSAOCTE of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGVERSAOCTE WSSEND cUSERTOKEN,cID_ENT,cVERSAO WSRECEIVE cCFGVERSAOCTERESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGVERSAOCTE xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VERSAO", ::cVERSAO, cVERSAO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGVERSAOCTE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGVERSAOCTE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGVERSAOCTERESULT :=  WSAdvValue( oXmlRet,"_CFGVERSAOCTERESPONSE:_CFGVERSAOCTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CFGVERSAODPEC of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD CFGVERSAODPEC WSSEND cUSERTOKEN,cID_ENT,cVERSAO WSRECEIVE cCFGVERSAODPECRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CFGVERSAODPEC xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VERSAO", ::cVERSAO, cVERSAO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CFGVERSAODPEC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/CFGVERSAODPEC",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::cCFGVERSAODPECRESULT :=  WSAdvValue( oXmlRet,"_CFGVERSAODPECRESPONSE:_CFGVERSAODPECRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.
/* -------------------------------------------------------------------------------
WSDL Method GETPOPMAIL of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD GETPOPMAIL WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSGETPOPMAILRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPOPMAIL xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETPOPMAIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/GETPOPMAIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::oWSGETPOPMAILRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETPOPMAILRESPONSE:_GETPOPMAILRESULT","POPSERVER",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETSMTPMAIL of Service WSSPEDCFGNFE
------------------------------------------------------------------------------- */

WSMETHOD GETSMTPMAIL WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSGETSMTPMAILRESULT WSCLIENT WSSPEDCFGNFE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETSMTPMAIL xmlns="http://webservices.totvs.com.br/spedcfgnfe.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETSMTPMAIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedcfgnfe.apw/GETSMTPMAIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedcfgnfe.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCFGNFE.apw")

::Init()
::oWSGETSMTPMAILRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETSMTPMAILRESPONSE:_GETSMTPMAILRESULT","SMTPSERVER",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure POPSERVER
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCFGNFE_POPSERVER
	WSDATA   cLOGINACCOUNT             AS string
	WSDATA   cMAILPASSWORD             AS base64binary
	WSDATA   cMAILSERVER               AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCFGNFE_POPSERVER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCFGNFE_POPSERVER
Return

WSMETHOD CLONE WSCLIENT SPEDCFGNFE_POPSERVER
	Local oClone := SPEDCFGNFE_POPSERVER():NEW()
	oClone:cLOGINACCOUNT        := ::cLOGINACCOUNT
	oClone:cMAILPASSWORD        := ::cMAILPASSWORD
	oClone:cMAILSERVER          := ::cMAILSERVER
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCFGNFE_POPSERVER
	Local cSoap := ""
	cSoap += WSSoapValue("LOGINACCOUNT", ::cLOGINACCOUNT, ::cLOGINACCOUNT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILPASSWORD", ::cMAILPASSWORD, ::cMAILPASSWORD , "base64binary", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILSERVER", ::cMAILSERVER, ::cMAILSERVER , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDCFGNFE_POPSERVER
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLOGINACCOUNT      :=  WSAdvValue( oResponse,"_LOGINACCOUNT","string",NIL,"Property cLOGINACCOUNT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMAILPASSWORD      :=  WSAdvValue( oResponse,"_MAILPASSWORD","base64binary",NIL,"Property cMAILPASSWORD as s:base64binary on SOAP Response not found.",NIL,"SB",NIL,NIL) 
	::cMAILSERVER        :=  WSAdvValue( oResponse,"_MAILSERVER","string",NIL,"Property cMAILSERVER as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure SMTPSERVER
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCFGNFE_SMTPSERVER
	WSDATA   lAUTHENTICATIONREQUERED   AS boolean OPTIONAL
	WSDATA   cLOGINACCOUNT             AS string OPTIONAL
	WSDATA   cMAILACCOUNT              AS string
	WSDATA   cMAILADMIN                AS string OPTIONAL
	WSDATA   cMAILPASSWORD             AS base64binary
	WSDATA   cMAILSERVER               AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCFGNFE_SMTPSERVER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCFGNFE_SMTPSERVER
Return

WSMETHOD CLONE WSCLIENT SPEDCFGNFE_SMTPSERVER
	Local oClone := SPEDCFGNFE_SMTPSERVER():NEW()
	oClone:lAUTHENTICATIONREQUERED := ::lAUTHENTICATIONREQUERED
	oClone:cLOGINACCOUNT        := ::cLOGINACCOUNT
	oClone:cMAILACCOUNT         := ::cMAILACCOUNT
	oClone:cMAILADMIN           := ::cMAILADMIN
	oClone:cMAILPASSWORD        := ::cMAILPASSWORD
	oClone:cMAILSERVER          := ::cMAILSERVER
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCFGNFE_SMTPSERVER
	Local cSoap := ""
	cSoap += WSSoapValue("AUTHENTICATIONREQUERED", ::lAUTHENTICATIONREQUERED, ::lAUTHENTICATIONREQUERED , "boolean", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("LOGINACCOUNT", ::cLOGINACCOUNT, ::cLOGINACCOUNT , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILACCOUNT", ::cMAILACCOUNT, ::cMAILACCOUNT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILADMIN", ::cMAILADMIN, ::cMAILADMIN , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILPASSWORD", ::cMAILPASSWORD, ::cMAILPASSWORD , "base64binary", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MAILSERVER", ::cMAILSERVER, ::cMAILSERVER , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDCFGNFE_SMTPSERVER
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lAUTHENTICATIONREQUERED :=  WSAdvValue( oResponse,"_AUTHENTICATIONREQUERED","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cLOGINACCOUNT      :=  WSAdvValue( oResponse,"_LOGINACCOUNT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMAILACCOUNT       :=  WSAdvValue( oResponse,"_MAILACCOUNT","string",NIL,"Property cMAILACCOUNT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMAILADMIN         :=  WSAdvValue( oResponse,"_MAILADMIN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMAILPASSWORD      :=  WSAdvValue( oResponse,"_MAILPASSWORD","base64binary",NIL,"Property cMAILPASSWORD as s:base64binary on SOAP Response not found.",NIL,"SB",NIL,NIL) 
	::cMAILSERVER        :=  WSAdvValue( oResponse,"_MAILSERVER","string",NIL,"Property cMAILSERVER as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFDIGITALCERTIFICATE
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	WSDATA   oWSDIGITALCERTIFICATE     AS SPEDCFGNFE_DIGITALCERTIFICATE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	::oWSDIGITALCERTIFICATE := {} // Array Of  SPEDCFGNFE_DIGITALCERTIFICATE():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	Local oClone := SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE():NEW()
	oClone:oWSDIGITALCERTIFICATE := NIL
	If ::oWSDIGITALCERTIFICATE <> NIL 
		oClone:oWSDIGITALCERTIFICATE := {}
		aEval( ::oWSDIGITALCERTIFICATE , { |x| aadd( oClone:oWSDIGITALCERTIFICATE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDCFGNFE_ARRAYOFDIGITALCERTIFICATE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DIGITALCERTIFICATE","DIGITALCERTIFICATE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDIGITALCERTIFICATE , SPEDCFGNFE_DIGITALCERTIFICATE():New() )
			::oWSDIGITALCERTIFICATE[len(::oWSDIGITALCERTIFICATE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure DIGITALCERTIFICATE
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCFGNFE_DIGITALCERTIFICATE
	WSDATA   nCERTIFICATETYPE          AS integer
	WSDATA   cISSUER                   AS base64binary
	WSDATA   cSUBJECT                  AS string
	WSDATA   dVALIDFROM                AS date
	WSDATA   dVALIDTO                  AS date
	WSDATA   cVERSION                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCFGNFE_DIGITALCERTIFICATE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCFGNFE_DIGITALCERTIFICATE
Return

WSMETHOD CLONE WSCLIENT SPEDCFGNFE_DIGITALCERTIFICATE
	Local oClone := SPEDCFGNFE_DIGITALCERTIFICATE():NEW()
	oClone:nCERTIFICATETYPE     := ::nCERTIFICATETYPE
	oClone:cISSUER              := ::cISSUER
	oClone:cSUBJECT             := ::cSUBJECT
	oClone:dVALIDFROM           := ::dVALIDFROM
	oClone:dVALIDTO             := ::dVALIDTO
	oClone:cVERSION             := ::cVERSION
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDCFGNFE_DIGITALCERTIFICATE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCERTIFICATETYPE   :=  WSAdvValue( oResponse,"_CERTIFICATETYPE","integer",NIL,"Property nCERTIFICATETYPE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cISSUER            :=  WSAdvValue( oResponse,"_ISSUER","base64binary",NIL,"Property cISSUER as s:base64binary on SOAP Response not found.",NIL,"SB",NIL,NIL) 
	::cSUBJECT           :=  WSAdvValue( oResponse,"_SUBJECT","string",NIL,"Property cSUBJECT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::dVALIDFROM         :=  WSAdvValue( oResponse,"_VALIDFROM","date",NIL,"Property dVALIDFROM as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::dVALIDTO           :=  WSAdvValue( oResponse,"_VALIDTO","date",NIL,"Property dVALIDTO as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::cVERSION           :=  WSAdvValue( oResponse,"_VERSION","string",NIL,"Property cVERSION as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


