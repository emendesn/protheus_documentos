#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDLAYOUTTAX.apw?WSDL
Gerado em        12/08/08 13:22:18
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080519
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QMOUPJN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDLAYOUTTAX
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDLAYOUTTAX

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD EXPORT
	WSMETHOD STATUS

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   cFILELAYOUT               AS string
	WSDATA   cVERSION                  AS string
	WSDATA   oWSPARAMS                 AS SPEDLAYOUTTAX_SPED_PARAMETERS
	WSDATA   cFILEOUT                  AS string
	WSDATA   cEXPORTRESULT             AS string
	WSDATA   cIDTHREAD                 AS string
	WSDATA   cSTATUSRESULT             AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSPED_PARAMETERS        AS SPEDLAYOUTTAX_SPED_PARAMETERS

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDLAYOUTTAX
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20080818] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDLAYOUTTAX
	::oWSPARAMS          := SPEDLAYOUTTAX_SPED_PARAMETERS():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_PARAMETERS := ::oWSPARAMS
Return

WSMETHOD RESET WSCLIENT WSSPEDLAYOUTTAX
	::cUSERTOKEN         := NIL 
	::cFILELAYOUT        := NIL 
	::cVERSION           := NIL 
	::oWSPARAMS          := NIL 
	::cFILEOUT           := NIL 
	::cEXPORTRESULT      := NIL 
	::cIDTHREAD          := NIL 
	::cSTATUSRESULT      := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_PARAMETERS := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDLAYOUTTAX
Local oClone := WSSPEDLAYOUTTAX():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:cFILELAYOUT   := ::cFILELAYOUT
	oClone:cVERSION      := ::cVERSION
	oClone:oWSPARAMS     :=  IIF(::oWSPARAMS = NIL , NIL ,::oWSPARAMS:Clone() )
	oClone:cFILEOUT      := ::cFILEOUT
	oClone:cEXPORTRESULT := ::cEXPORTRESULT
	oClone:cIDTHREAD     := ::cIDTHREAD
	oClone:cSTATUSRESULT := ::cSTATUSRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSPED_PARAMETERS := oClone:oWSPARAMS
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method EXPORT of Service WSSPEDLAYOUTTAX
------------------------------------------------------------------------------- */

WSMETHOD EXPORT WSSEND cUSERTOKEN,cFILELAYOUT,cVERSION,oWSPARAMS,cFILEOUT WSRECEIVE cEXPORTRESULT WSCLIENT WSSPEDLAYOUTTAX
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EXPORT xmlns="http://webservices.totvs.com.br/spedlayouttax.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("FILELAYOUT", ::cFILELAYOUT, cFILELAYOUT , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("VERSION", ::cVERSION, cVERSION , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("PARAMS", ::oWSPARAMS, oWSPARAMS , "SPED_PARAMETERS", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("FILEOUT", ::cFILEOUT, cFILEOUT , "string", .T. , .F., 0 , NIL) 
cSoap += "</EXPORT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedlayouttax.apw/EXPORT",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedlayouttax.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDLAYOUTTAX.apw")

::Init()
::cEXPORTRESULT      :=  WSAdvValue( oXmlRet,"_EXPORTRESPONSE:_EXPORTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method STATUS of Service WSSPEDLAYOUTTAX
------------------------------------------------------------------------------- */

WSMETHOD STATUS WSSEND cUSERTOKEN,cIDTHREAD WSRECEIVE cSTATUSRESULT WSCLIENT WSSPEDLAYOUTTAX
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<STATUS xmlns="http://webservices.totvs.com.br/spedlayouttax.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("IDTHREAD", ::cIDTHREAD, cIDTHREAD , "string", .T. , .F., 0 , NIL) 
cSoap += "</STATUS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedlayouttax.apw/STATUS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedlayouttax.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDLAYOUTTAX.apw")

::Init()
::cSTATUSRESULT      :=  WSAdvValue( oXmlRet,"_STATUSRESPONSE:_STATUSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PARAMETERS
------------------------------------------------------------------------------- */

WSSTRUCT SPEDLAYOUTTAX_SPED_PARAMETERS
	WSDATA   oWSINFO                   AS SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDLAYOUTTAX_SPED_PARAMETERS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDLAYOUTTAX_SPED_PARAMETERS
Return

WSMETHOD CLONE WSCLIENT SPEDLAYOUTTAX_SPED_PARAMETERS
	Local oClone := SPEDLAYOUTTAX_SPED_PARAMETERS():NEW()
	oClone:oWSINFO              := IIF(::oWSINFO = NIL , NIL , ::oWSINFO:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDLAYOUTTAX_SPED_PARAMETERS
	Local cSoap := ""
	cSoap += WSSoapValue("INFO", ::oWSINFO, ::oWSINFO , "ARRAYOFSPED_GENERICPARAMETER", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_GENERICPARAMETER
------------------------------------------------------------------------------- */

WSSTRUCT SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	WSDATA   oWSSPED_GENERICPARAMETER  AS SPEDLAYOUTTAX_SPED_GENERICPARAMETER OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	::oWSSPED_GENERICPARAMETER := {} // Array Of  SPEDLAYOUTTAX_SPED_GENERICPARAMETER():New()
Return

WSMETHOD CLONE WSCLIENT SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	Local oClone := SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER():NEW()
	oClone:oWSSPED_GENERICPARAMETER := NIL
	If ::oWSSPED_GENERICPARAMETER <> NIL 
		oClone:oWSSPED_GENERICPARAMETER := {}
		aEval( ::oWSSPED_GENERICPARAMETER , { |x| aadd( oClone:oWSSPED_GENERICPARAMETER , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDLAYOUTTAX_ARRAYOFSPED_GENERICPARAMETER
	Local cSoap := ""
	aEval( ::oWSSPED_GENERICPARAMETER , {|x| cSoap := cSoap  +  WSSoapValue("SPED_GENERICPARAMETER", x , x , "SPED_GENERICPARAMETER", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_GENERICPARAMETER
------------------------------------------------------------------------------- */

WSSTRUCT SPEDLAYOUTTAX_SPED_GENERICPARAMETER
	WSDATA   cVALUE                    AS string
	WSDATA   cVARIABLE                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDLAYOUTTAX_SPED_GENERICPARAMETER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDLAYOUTTAX_SPED_GENERICPARAMETER
Return

WSMETHOD CLONE WSCLIENT SPEDLAYOUTTAX_SPED_GENERICPARAMETER
	Local oClone := SPEDLAYOUTTAX_SPED_GENERICPARAMETER():NEW()
	oClone:cVALUE               := ::cVALUE
	oClone:cVARIABLE            := ::cVARIABLE
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDLAYOUTTAX_SPED_GENERICPARAMETER
	Local cSoap := ""
	cSoap += WSSoapValue("VALUE", ::cVALUE, ::cVALUE , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VARIABLE", ::cVARIABLE, ::cVARIABLE , "string", .T. , .F., 0 , NIL ) 
Return cSoap

