#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw?WSDL
Gerado em        12/12/08 16:24:15
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080519
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _BENIQQM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDCTBMOVIMENTOS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CTBLCTOCONTABIL
	WSMETHOD CTBLIVROCONTABIL
	WSMETHOD CTBRAZAOAUXILIAR
	WSMETHOD CTBRAZAOAUXILIARLAYOUT
	WSMETHOD CTBSALDOSDOPERIODO

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   oWSLCTOCTB                AS SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	WSDATA   cCTBLCTOCONTABILRESULT    AS string
	WSDATA   oWSLIVROCONTABIL          AS SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	WSDATA   cCTBLIVROCONTABILRESULT   AS string
	WSDATA   oWSLCTOAUX                AS SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	WSDATA   cCTBRAZAOAUXILIARRESULT   AS string
	WSDATA   oWSLAYOUT                 AS SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	WSDATA   cCTBRAZAOAUXILIARLAYOUTRESULT AS string
	WSDATA   oWSSALDOSDOPERIODO        AS SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
	WSDATA   cCTBSALDOSDOPERIODORESULT AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSPED_CTBLCTOCONTABIL   AS SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	WSDATA   oWSSPED_LIVROCONTABIL     AS SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	WSDATA   oWSSPED_CTBLCTOAUXILIAR   AS SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	WSDATA   oWSSPED_CTBLAYOUTAUXILIAR AS SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	WSDATA   oWSSPED_CTBSALDOSDOPERIODO AS SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDCTBMOVIMENTOS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20080818] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDCTBMOVIMENTOS
	::oWSLCTOCTB         := SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL():New()
	::oWSLIVROCONTABIL   := SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL():New()
	::oWSLCTOAUX         := SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR():New()
	::oWSLAYOUT          := SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR():New()
	::oWSSALDOSDOPERIODO := SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CTBLCTOCONTABIL := ::oWSLCTOCTB
	::oWSSPED_LIVROCONTABIL := ::oWSLIVROCONTABIL
	::oWSSPED_CTBLCTOAUXILIAR := ::oWSLCTOAUX
	::oWSSPED_CTBLAYOUTAUXILIAR := ::oWSLAYOUT
	::oWSSPED_CTBSALDOSDOPERIODO := ::oWSSALDOSDOPERIODO
Return

WSMETHOD RESET WSCLIENT WSSPEDCTBMOVIMENTOS
	::cUSERTOKEN         := NIL 
	::oWSLCTOCTB         := NIL 
	::cCTBLCTOCONTABILRESULT := NIL 
	::oWSLIVROCONTABIL   := NIL 
	::cCTBLIVROCONTABILRESULT := NIL 
	::oWSLCTOAUX         := NIL 
	::cCTBRAZAOAUXILIARRESULT := NIL 
	::oWSLAYOUT          := NIL 
	::cCTBRAZAOAUXILIARLAYOUTRESULT := NIL 
	::oWSSALDOSDOPERIODO := NIL 
	::cCTBSALDOSDOPERIODORESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CTBLCTOCONTABIL := NIL
	::oWSSPED_LIVROCONTABIL := NIL
	::oWSSPED_CTBLCTOAUXILIAR := NIL
	::oWSSPED_CTBLAYOUTAUXILIAR := NIL
	::oWSSPED_CTBSALDOSDOPERIODO := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDCTBMOVIMENTOS
Local oClone := WSSPEDCTBMOVIMENTOS():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:oWSLCTOCTB    :=  IIF(::oWSLCTOCTB = NIL , NIL ,::oWSLCTOCTB:Clone() )
	oClone:cCTBLCTOCONTABILRESULT := ::cCTBLCTOCONTABILRESULT
	oClone:oWSLIVROCONTABIL :=  IIF(::oWSLIVROCONTABIL = NIL , NIL ,::oWSLIVROCONTABIL:Clone() )
	oClone:cCTBLIVROCONTABILRESULT := ::cCTBLIVROCONTABILRESULT
	oClone:oWSLCTOAUX    :=  IIF(::oWSLCTOAUX = NIL , NIL ,::oWSLCTOAUX:Clone() )
	oClone:cCTBRAZAOAUXILIARRESULT := ::cCTBRAZAOAUXILIARRESULT
	oClone:oWSLAYOUT     :=  IIF(::oWSLAYOUT = NIL , NIL ,::oWSLAYOUT:Clone() )
	oClone:cCTBRAZAOAUXILIARLAYOUTRESULT := ::cCTBRAZAOAUXILIARLAYOUTRESULT
	oClone:oWSSALDOSDOPERIODO :=  IIF(::oWSSALDOSDOPERIODO = NIL , NIL ,::oWSSALDOSDOPERIODO:Clone() )
	oClone:cCTBSALDOSDOPERIODORESULT := ::cCTBSALDOSDOPERIODORESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSPED_CTBLCTOCONTABIL := oClone:oWSLCTOCTB
	oClone:oWSSPED_LIVROCONTABIL := oClone:oWSLIVROCONTABIL
	oClone:oWSSPED_CTBLCTOAUXILIAR := oClone:oWSLCTOAUX
	oClone:oWSSPED_CTBLAYOUTAUXILIAR := oClone:oWSLAYOUT
	oClone:oWSSPED_CTBSALDOSDOPERIODO := oClone:oWSSALDOSDOPERIODO
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CTBLCTOCONTABIL of Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSMETHOD CTBLCTOCONTABIL WSSEND cUSERTOKEN,oWSLCTOCTB WSRECEIVE cCTBLCTOCONTABILRESULT WSCLIENT WSSPEDCTBMOVIMENTOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBLCTOCONTABIL xmlns="http://webservices.totvs.com.br/spedctbmovimentos.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("LCTOCTB", ::oWSLCTOCTB, oWSLCTOCTB , "SPED_CTBLCTOCONTABIL", .T. , .F., 0 , NIL) 
cSoap += "</CTBLCTOCONTABIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbmovimentos.apw/CTBLCTOCONTABIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbmovimentos.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw")

::Init()
::cCTBLCTOCONTABILRESULT :=  WSAdvValue( oXmlRet,"_CTBLCTOCONTABILRESPONSE:_CTBLCTOCONTABILRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBLIVROCONTABIL of Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSMETHOD CTBLIVROCONTABIL WSSEND cUSERTOKEN,oWSLIVROCONTABIL WSRECEIVE cCTBLIVROCONTABILRESULT WSCLIENT WSSPEDCTBMOVIMENTOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBLIVROCONTABIL xmlns="http://webservices.totvs.com.br/spedctbmovimentos.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("LIVROCONTABIL", ::oWSLIVROCONTABIL, oWSLIVROCONTABIL , "SPED_LIVROCONTABIL", .T. , .F., 0 , NIL) 
cSoap += "</CTBLIVROCONTABIL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbmovimentos.apw/CTBLIVROCONTABIL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbmovimentos.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw")

::Init()
::cCTBLIVROCONTABILRESULT :=  WSAdvValue( oXmlRet,"_CTBLIVROCONTABILRESPONSE:_CTBLIVROCONTABILRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBRAZAOAUXILIAR of Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSMETHOD CTBRAZAOAUXILIAR WSSEND cUSERTOKEN,oWSLCTOAUX WSRECEIVE cCTBRAZAOAUXILIARRESULT WSCLIENT WSSPEDCTBMOVIMENTOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBRAZAOAUXILIAR xmlns="http://webservices.totvs.com.br/spedctbmovimentos.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("LCTOAUX", ::oWSLCTOAUX, oWSLCTOAUX , "SPED_CTBLCTOAUXILIAR", .T. , .F., 0 , NIL) 
cSoap += "</CTBRAZAOAUXILIAR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbmovimentos.apw/CTBRAZAOAUXILIAR",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbmovimentos.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw")

::Init()
::cCTBRAZAOAUXILIARRESULT :=  WSAdvValue( oXmlRet,"_CTBRAZAOAUXILIARRESPONSE:_CTBRAZAOAUXILIARRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBRAZAOAUXILIARLAYOUT of Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSMETHOD CTBRAZAOAUXILIARLAYOUT WSSEND cUSERTOKEN,oWSLAYOUT WSRECEIVE cCTBRAZAOAUXILIARLAYOUTRESULT WSCLIENT WSSPEDCTBMOVIMENTOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBRAZAOAUXILIARLAYOUT xmlns="http://webservices.totvs.com.br/spedctbmovimentos.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("LAYOUT", ::oWSLAYOUT, oWSLAYOUT , "SPED_CTBLAYOUTAUXILIAR", .T. , .F., 0 , NIL) 
cSoap += "</CTBRAZAOAUXILIARLAYOUT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbmovimentos.apw/CTBRAZAOAUXILIARLAYOUT",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbmovimentos.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw")

::Init()
::cCTBRAZAOAUXILIARLAYOUTRESULT :=  WSAdvValue( oXmlRet,"_CTBRAZAOAUXILIARLAYOUTRESPONSE:_CTBRAZAOAUXILIARLAYOUTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBSALDOSDOPERIODO of Service WSSPEDCTBMOVIMENTOS
------------------------------------------------------------------------------- */

WSMETHOD CTBSALDOSDOPERIODO WSSEND cUSERTOKEN,oWSSALDOSDOPERIODO WSRECEIVE cCTBSALDOSDOPERIODORESULT WSCLIENT WSSPEDCTBMOVIMENTOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBSALDOSDOPERIODO xmlns="http://webservices.totvs.com.br/spedctbmovimentos.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("SALDOSDOPERIODO", ::oWSSALDOSDOPERIODO, oWSSALDOSDOPERIODO , "SPED_CTBSALDOSDOPERIODO", .T. , .F., 0 , NIL) 
cSoap += "</CTBSALDOSDOPERIODO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbmovimentos.apw/CTBSALDOSDOPERIODO",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbmovimentos.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBMOVIMENTOS.apw")

::Init()
::cCTBSALDOSDOPERIODORESULT :=  WSAdvValue( oXmlRet,"_CTBSALDOSDOPERIODORESPONSE:_CTBSALDOSDOPERIODORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBLCTOCONTABIL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	WSDATA   cCPLLOTE                  AS string OPTIONAL
	WSDATA   dDTLCTO                   AS date
	WSDATA   cID_ENT                   AS string
	WSDATA   cINDLCTO                  AS string
	WSDATA   oWSLCTOS                  AS SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	WSDATA   cLOTE                     AS string
	WSDATA   nORDEM                    AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL():NEW()
	oClone:cCPLLOTE             := ::cCPLLOTE
	oClone:dDTLCTO              := ::dDTLCTO
	oClone:cID_ENT              := ::cID_ENT
	oClone:cINDLCTO             := ::cINDLCTO
	oClone:oWSLCTOS             := IIF(::oWSLCTOS = NIL , NIL , ::oWSLCTOS:Clone() )
	oClone:cLOTE                := ::cLOTE
	oClone:nORDEM               := ::nORDEM
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOCONTABIL
	Local cSoap := ""
	cSoap += WSSoapValue("CPLLOTE", ::cCPLLOTE, ::cCPLLOTE , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTLCTO", ::dDTLCTO, ::dDTLCTO , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("INDLCTO", ::cINDLCTO, ::cINDLCTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("LCTOS", ::oWSLCTOS, ::oWSLCTOS , "ARRAYOFSPED_CTBPARTIDAS", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("LOTE", ::cLOTE, ::cLOTE , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_LIVROCONTABIL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	WSDATA   dDT_ARQ                   AS date
	WSDATA   dDT_ARQ_CONV              AS date OPTIONAL
	WSDATA   cID_ENT                   AS string
	WSDATA   cIND_ESC                  AS string
	WSDATA   cNATUREZA                 AS string
	WSDATA   nORDEM                    AS integer
	WSDATA   nORDEMSUP                 AS integer OPTIONAL
	WSDATA   cTIPO_ESC                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	Local oClone := SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL():NEW()
	oClone:dDT_ARQ              := ::dDT_ARQ
	oClone:dDT_ARQ_CONV         := ::dDT_ARQ_CONV
	oClone:cID_ENT              := ::cID_ENT
	oClone:cIND_ESC             := ::cIND_ESC
	oClone:cNATUREZA            := ::cNATUREZA
	oClone:nORDEM               := ::nORDEM
	oClone:nORDEMSUP            := ::nORDEMSUP
	oClone:cTIPO_ESC            := ::cTIPO_ESC
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_LIVROCONTABIL
	Local cSoap := ""
	cSoap += WSSoapValue("DT_ARQ", ::dDT_ARQ, ::dDT_ARQ , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DT_ARQ_CONV", ::dDT_ARQ_CONV, ::dDT_ARQ_CONV , "date", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IND_ESC", ::cIND_ESC, ::cIND_ESC , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NATUREZA", ::cNATUREZA, ::cNATUREZA , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEMSUP", ::nORDEMSUP, ::nORDEMSUP , "integer", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("TIPO_ESC", ::cTIPO_ESC, ::cTIPO_ESC , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBLCTOAUXILIAR
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINI                    AS date
	WSDATA   cID_ENT                   AS string
	WSDATA   cID_LAYOUT                AS string
	WSDATA   oWSLINHAS                 AS SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	WSDATA   nORDEM                    AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR():NEW()
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
	oClone:cID_ENT              := ::cID_ENT
	oClone:cID_LAYOUT           := ::cID_LAYOUT
	oClone:oWSLINHAS            := IIF(::oWSLINHAS = NIL , NIL , ::oWSLINHAS:Clone() )
	oClone:nORDEM               := ::nORDEM
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLCTOAUXILIAR
	Local cSoap := ""
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_LAYOUT", ::cID_LAYOUT, ::cID_LAYOUT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("LINHAS", ::oWSLINHAS, ::oWSLINHAS , "ARRAYOFSPED_CTBPARTIDAAUXILIAR", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBLAYOUTAUXILIAR
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	WSDATA   oWSCAMPOS                 AS SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	WSDATA   cID_ENT                   AS string
	WSDATA   cID_LAYOUT                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR():NEW()
	oClone:oWSCAMPOS            := IIF(::oWSCAMPOS = NIL , NIL , ::oWSCAMPOS:Clone() )
	oClone:cID_ENT              := ::cID_ENT
	oClone:cID_LAYOUT           := ::cID_LAYOUT
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBLAYOUTAUXILIAR
	Local cSoap := ""
	cSoap += WSSoapValue("CAMPOS", ::oWSCAMPOS, ::oWSCAMPOS , "ARRAYOFFIELDSTRUCT", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_LAYOUT", ::cID_LAYOUT, ::cID_LAYOUT , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBSALDOSDOPERIODO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
	WSDATA   cID_ENT                   AS string
	WSDATA   nORDEM                    AS integer
	WSDATA   oWSSALDOS                 AS SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO():NEW()
	oClone:cID_ENT              := ::cID_ENT
	oClone:nORDEM               := ::nORDEM
	oClone:oWSSALDOS            := IIF(::oWSSALDOS = NIL , NIL , ::oWSSALDOS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOSDOPERIODO
	Local cSoap := ""
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("SALDOS", ::oWSSALDOS, ::oWSSALDOS , "ARRAYOFSPED_CTBSALDOPERIODO", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CTBPARTIDAS
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	WSDATA   oWSSPED_CTBPARTIDAS       AS SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	::oWSSPED_CTBPARTIDAS  := {} // Array Of  SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	Local oClone := SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS():NEW()
	oClone:oWSSPED_CTBPARTIDAS := NIL
	If ::oWSSPED_CTBPARTIDAS <> NIL 
		oClone:oWSSPED_CTBPARTIDAS := {}
		aEval( ::oWSSPED_CTBPARTIDAS , { |x| aadd( oClone:oWSSPED_CTBPARTIDAS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAS
	Local cSoap := ""
	aEval( ::oWSSPED_CTBPARTIDAS , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CTBPARTIDAS", x , x , "SPED_CTBPARTIDAS", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CTBPARTIDAAUXILIAR
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	WSDATA   oWSSPED_CTBPARTIDAAUXILIAR AS SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	::oWSSPED_CTBPARTIDAAUXILIAR := {} // Array Of  SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	Local oClone := SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR():NEW()
	oClone:oWSSPED_CTBPARTIDAAUXILIAR := NIL
	If ::oWSSPED_CTBPARTIDAAUXILIAR <> NIL 
		oClone:oWSSPED_CTBPARTIDAAUXILIAR := {}
		aEval( ::oWSSPED_CTBPARTIDAAUXILIAR , { |x| aadd( oClone:oWSSPED_CTBPARTIDAAUXILIAR , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBPARTIDAAUXILIAR
	Local cSoap := ""
	aEval( ::oWSSPED_CTBPARTIDAAUXILIAR , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CTBPARTIDAAUXILIAR", x , x , "SPED_CTBPARTIDAAUXILIAR", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFFIELDSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	WSDATA   oWSFIELDSTRUCT            AS SPEDCTBMOVIMENTOS_FIELDSTRUCT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	::oWSFIELDSTRUCT       := {} // Array Of  SPEDCTBMOVIMENTOS_FIELDSTRUCT():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	Local oClone := SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT():NEW()
	oClone:oWSFIELDSTRUCT := NIL
	If ::oWSFIELDSTRUCT <> NIL 
		oClone:oWSFIELDSTRUCT := {}
		aEval( ::oWSFIELDSTRUCT , { |x| aadd( oClone:oWSFIELDSTRUCT , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFFIELDSTRUCT
	Local cSoap := ""
	aEval( ::oWSFIELDSTRUCT , {|x| cSoap := cSoap  +  WSSoapValue("FIELDSTRUCT", x , x , "FIELDSTRUCT", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CTBSALDOPERIODO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	WSDATA   oWSSPED_CTBSALDOPERIODO   AS SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	::oWSSPED_CTBSALDOPERIODO := {} // Array Of  SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	Local oClone := SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO():NEW()
	oClone:oWSSPED_CTBSALDOPERIODO := NIL
	If ::oWSSPED_CTBSALDOPERIODO <> NIL 
		oClone:oWSSPED_CTBSALDOPERIODO := {}
		aEval( ::oWSSPED_CTBSALDOPERIODO , { |x| aadd( oClone:oWSSPED_CTBSALDOPERIODO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_ARRAYOFSPED_CTBSALDOPERIODO
	Local cSoap := ""
	aEval( ::oWSSPED_CTBSALDOPERIODO , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CTBSALDOPERIODO", x , x , "SPED_CTBSALDOPERIODO", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBPARTIDAS
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCNPJ_PART                AS string
	WSDATA   cCODCTA                   AS string
	WSDATA   cCPF_PART                 AS string
	WSDATA   cDC                       AS string
	WSDATA   cEMPORI                   AS string
	WSDATA   cFILORI                   AS string
	WSDATA   cHISTORICO                AS string
	WSDATA   cHISTPAD                  AS string
	WSDATA   cIE_PART                  AS string
	WSDATA   cNUMARQ                   AS string
	WSDATA   cUF_PART                  AS string
	WSDATA   nVALOR                    AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS():NEW()
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cCNPJ_PART           := ::cCNPJ_PART
	oClone:cCODCTA              := ::cCODCTA
	oClone:cCPF_PART            := ::cCPF_PART
	oClone:cDC                  := ::cDC
	oClone:cEMPORI              := ::cEMPORI
	oClone:cFILORI              := ::cFILORI
	oClone:cHISTORICO           := ::cHISTORICO
	oClone:cHISTPAD             := ::cHISTPAD
	oClone:cIE_PART             := ::cIE_PART
	oClone:cNUMARQ              := ::cNUMARQ
	oClone:cUF_PART             := ::cUF_PART
	oClone:nVALOR               := ::nVALOR
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAS
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, ::cCCUSTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CNPJ_PART", ::cCNPJ_PART, ::cCNPJ_PART , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTA", ::cCODCTA, ::cCODCTA , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CPF_PART", ::cCPF_PART, ::cCPF_PART , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DC", ::cDC, ::cDC , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("EMPORI", ::cEMPORI, ::cEMPORI , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FILORI", ::cFILORI, ::cFILORI , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("HISTORICO", ::cHISTORICO, ::cHISTORICO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("HISTPAD", ::cHISTPAD, ::cHISTPAD , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IE_PART", ::cIE_PART, ::cIE_PART , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NUMARQ", ::cNUMARQ, ::cNUMARQ , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("UF_PART", ::cUF_PART, ::cUF_PART , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VALOR", ::nVALOR, ::nVALOR , "float", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBPARTIDAAUXILIAR
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR
	WSDATA   cCONTEUDO                 AS string
	WSDATA   nID_LINHA                 AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR():NEW()
	oClone:cCONTEUDO            := ::cCONTEUDO
	oClone:nID_LINHA            := ::nID_LINHA
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBPARTIDAAUXILIAR
	Local cSoap := ""
	cSoap += WSSoapValue("CONTEUDO", ::cCONTEUDO, ::cCONTEUDO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_LINHA", ::nID_LINHA, ::nID_LINHA , "integer", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure FIELDSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_FIELDSTRUCT
	WSDATA   nFLDDEC                   AS integer
	WSDATA   cFLDNAME                  AS string
	WSDATA   nFLDSIZE                  AS integer
	WSDATA   cFLDTYPE                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_FIELDSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_FIELDSTRUCT
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_FIELDSTRUCT
	Local oClone := SPEDCTBMOVIMENTOS_FIELDSTRUCT():NEW()
	oClone:nFLDDEC              := ::nFLDDEC
	oClone:cFLDNAME             := ::cFLDNAME
	oClone:nFLDSIZE             := ::nFLDSIZE
	oClone:cFLDTYPE             := ::cFLDTYPE
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_FIELDSTRUCT
	Local cSoap := ""
	cSoap += WSSoapValue("FLDDEC", ::nFLDDEC, ::nFLDDEC , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FLDNAME", ::cFLDNAME, ::cFLDNAME , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FLDSIZE", ::nFLDSIZE, ::nFLDSIZE , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FLDTYPE", ::cFLDTYPE, ::cFLDTYPE , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBSALDOPERIODO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCODCTA                   AS string
	WSDATA   cDCFIN                    AS string
	WSDATA   cDCINI                    AS string
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINI                    AS date
	WSDATA   nVLCRED                   AS float
	WSDATA   nVLDEB                    AS float
	WSDATA   nVLSLDFIN                 AS float
	WSDATA   nVLSLDINI                 AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO
	Local oClone := SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO():NEW()
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cCODCTA              := ::cCODCTA
	oClone:cDCFIN               := ::cDCFIN
	oClone:cDCINI               := ::cDCINI
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
	oClone:nVLCRED              := ::nVLCRED
	oClone:nVLDEB               := ::nVLDEB
	oClone:nVLSLDFIN            := ::nVLSLDFIN
	oClone:nVLSLDINI            := ::nVLSLDINI
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBMOVIMENTOS_SPED_CTBSALDOPERIODO
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, ::cCCUSTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTA", ::cCODCTA, ::cCODCTA , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DCFIN", ::cDCFIN, ::cDCFIN , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DCINI", ::cDCINI, ::cDCINI , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VLCRED", ::nVLCRED, ::nVLCRED , "float", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VLDEB", ::nVLDEB, ::nVLDEB , "float", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VLSLDFIN", ::nVLSLDFIN, ::nVLSLDFIN , "float", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VLSLDINI", ::nVLSLDINI, ::nVLSLDINI , "float", .T. , .F., 0 , NIL ) 
Return cSoap


