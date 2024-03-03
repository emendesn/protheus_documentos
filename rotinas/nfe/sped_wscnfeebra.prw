#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/NFEEBRA.apw?WSDL
Gerado em        07/20/07 08:51:12
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _GPFNHFB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSCLIENT WSNFEEBRA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD EXCLUINOTA
	WSMETHOD MONITORSEFAZ
	WSMETHOD MONITORWF
	WSMETHOD RETORNANOTA
	WSMETHOD VALIDANFE

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   cID_ENT                   AS string
	WSDATA   oWSNFEID                  AS NFEEBRA_NFESID
	WSDATA   oWSEXCLUINOTARESULT       AS NFEEBRA_NFESID
	WSDATA   cMONITORSEFAZRESULT       AS string
	WSDATA   oWSMONITORWFRESULT        AS NFEEBRA_ARRAYOFMONITORNFE
	WSDATA   oWSRETORNANOTARESULT      AS NFEEBRA_NFE
	WSDATA   oWSNFE                    AS NFEEBRA_NFE
	WSDATA   oWSVALIDANFERESULT        AS NFEEBRA_NFESID

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNFEEBRA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.060906P] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFEEBRA
	::oWSNFEID           := NFEEBRA_NFESID():New()
	::oWSEXCLUINOTARESULT := NFEEBRA_NFESID():New()
	::oWSMONITORWFRESULT := NFEEBRA_ARRAYOFMONITORNFE():New()
	::oWSRETORNANOTARESULT := NFEEBRA_NFE():New()
	::oWSNFE             := NFEEBRA_NFE():New()
	::oWSVALIDANFERESULT := NFEEBRA_NFESID():New()

Return

WSMETHOD RESET WSCLIENT WSNFEEBRA
	::cUSERTOKEN         := NIL 
	::cID_ENT            := NIL 
	::oWSNFEID           := NIL 
	::oWSEXCLUINOTARESULT := NIL 
	::cMONITORSEFAZRESULT := NIL 
	::oWSMONITORWFRESULT := NIL 
	::oWSRETORNANOTARESULT := NIL 
	::oWSNFE             := NIL 
	::oWSVALIDANFERESULT := NIL 

	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFEEBRA
Local oClone := WSNFEEBRA():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:cID_ENT       := ::cID_ENT
	oClone:oWSNFEID      :=  IIF(::oWSNFEID = NIL , NIL ,::oWSNFEID:Clone() )
	oClone:oWSEXCLUINOTARESULT :=  IIF(::oWSEXCLUINOTARESULT = NIL , NIL ,::oWSEXCLUINOTARESULT:Clone() )
	oClone:cMONITORSEFAZRESULT := ::cMONITORSEFAZRESULT
	oClone:oWSMONITORWFRESULT :=  IIF(::oWSMONITORWFRESULT = NIL , NIL ,::oWSMONITORWFRESULT:Clone() )
	oClone:oWSRETORNANOTARESULT :=  IIF(::oWSRETORNANOTARESULT = NIL , NIL ,::oWSRETORNANOTARESULT:Clone() )
	oClone:oWSNFE        :=  IIF(::oWSNFE = NIL , NIL ,::oWSNFE:Clone() )
	oClone:oWSVALIDANFERESULT :=  IIF(::oWSVALIDANFERESULT = NIL , NIL ,::oWSVALIDANFERESULT:Clone() )

Return oClone

/* -------------------------------------------------------------------------------
WSDL Method EXCLUINOTA of Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSMETHOD EXCLUINOTA WSSEND cUSERTOKEN,cID_ENT,oWSNFEID WSRECEIVE oWSEXCLUINOTARESULT WSCLIENT WSNFEEBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EXCLUINOTA xmlns="http://webservices.totvs.com.br/nfeebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NFEID", ::oWSNFEID, oWSNFEID , "NFESID", .T. , .F., 0 ) 
cSoap += "</EXCLUINOTA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfeebra.apw/EXCLUINOTA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfeebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFEEBRA.apw")

::Init()
::oWSEXCLUINOTARESULT:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUINOTARESPONSE:_EXCLUINOTARESULT","NFESID",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORSEFAZ of Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORSEFAZ WSSEND cUSERTOKEN,cID_ENT WSRECEIVE cMONITORSEFAZRESULT WSCLIENT WSNFEEBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORSEFAZ xmlns="http://webservices.totvs.com.br/nfeebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 ) 
cSoap += "</MONITORSEFAZ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfeebra.apw/MONITORSEFAZ",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfeebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFEEBRA.apw")

::Init()
::cMONITORSEFAZRESULT :=  WSAdvValue( oXmlRet,"_MONITORSEFAZRESPONSE:_MONITORSEFAZRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORWF of Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORWF WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSMONITORWFRESULT WSCLIENT WSNFEEBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORWF xmlns="http://webservices.totvs.com.br/nfeebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 ) 
cSoap += "</MONITORWF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfeebra.apw/MONITORWF",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfeebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFEEBRA.apw")

::Init()
::oWSMONITORWFRESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORWFRESPONSE:_MONITORWFRESULT","ARRAYOFMONITORNFE",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method RETORNANOTA of Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSMETHOD RETORNANOTA WSSEND cUSERTOKEN,cID_ENT,oWSNFEID WSRECEIVE oWSRETORNANOTARESULT WSCLIENT WSNFEEBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETORNANOTA xmlns="http://webservices.totvs.com.br/nfeebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NFEID", ::oWSNFEID, oWSNFEID , "NFESID", .T. , .F., 0 ) 
cSoap += "</RETORNANOTA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfeebra.apw/RETORNANOTA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfeebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFEEBRA.apw")

::Init()
::oWSRETORNANOTARESULT:SoapRecv( WSAdvValue( oXmlRet,"_RETORNANOTARESPONSE:_RETORNANOTARESULT","NFE",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method VALIDANFE of Service WSNFEEBRA
------------------------------------------------------------------------------- */

WSMETHOD VALIDANFE WSSEND cUSERTOKEN,cID_ENT,oWSNFE WSRECEIVE oWSVALIDANFERESULT WSCLIENT WSNFEEBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VALIDANFE xmlns="http://webservices.totvs.com.br/nfeebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 ) 
cSoap += WSSoapValue("NFE", ::oWSNFE, oWSNFE , "NFE", .T. , .F., 0 ) 
cSoap += "</VALIDANFE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfeebra.apw/VALIDANFE",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfeebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFEEBRA.apw")

::Init()
::oWSVALIDANFERESULT:SoapRecv( WSAdvValue( oXmlRet,"_VALIDANFERESPONSE:_VALIDANFERESULT","NFESID",NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure NFESID
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_NFESID
	WSDATA   oWSID                     AS NFEEBRA_ARRAYOFSTRING OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_NFESID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_NFESID
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_NFESID
	Local oClone := NFEEBRA_NFESID():NEW()
	oClone:oWSID                := IIF(::oWSID = NIL , NIL , ::oWSID:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFEEBRA_NFESID
	Local cSoap := ""
	cSoap += WSSoapValue("ID", ::oWSID, ::oWSID , "ARRAYOFSTRING", .F. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_NFESID
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ID","ARRAYOFSTRING",NIL,NIL,NIL,"O",NIL) 
	If oNode1 != NIL
		::oWSID := NFEEBRA_ARRAYOFSTRING():New()
		::oWSID:SoapRecv(oNode1)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFMONITORNFE
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_ARRAYOFMONITORNFE
	WSDATA   oWSMONITORNFE             AS NFEEBRA_MONITORNFE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_ARRAYOFMONITORNFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_ARRAYOFMONITORNFE
	::oWSMONITORNFE        := {} // Array Of  NFEEBRA_MONITORNFE():New()
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_ARRAYOFMONITORNFE
	Local oClone := NFEEBRA_ARRAYOFMONITORNFE():NEW()
	oClone:oWSMONITORNFE := NIL
	If ::oWSMONITORNFE <> NIL 
		oClone:oWSMONITORNFE := {}
		aEval( ::oWSMONITORNFE , { |x| aadd( oClone:oWSMONITORNFE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_ARRAYOFMONITORNFE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MONITORNFE","MONITORNFE",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMONITORNFE , NFEEBRA_MONITORNFE():New() )
			::oWSMONITORNFE[len(::oWSMONITORNFE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFE
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_NFE
	WSDATA   oWSNOTAS                  AS NFEEBRA_ARRAYOFNFES
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_NFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_NFE
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_NFE
	Local oClone := NFEEBRA_NFE():NEW()
	oClone:oWSNOTAS             := IIF(::oWSNOTAS = NIL , NIL , ::oWSNOTAS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFEEBRA_NFE
	Local cSoap := ""
	cSoap += WSSoapValue("NOTAS", ::oWSNOTAS, ::oWSNOTAS , "ARRAYOFNFES", .T. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_NFE
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_NOTAS","ARRAYOFNFES",NIL,"Property oWSNOTAS as s0:ARRAYOFNFES on SOAP Response not found.",NIL,"O",NIL) 
	If oNode1 != NIL
		::oWSNOTAS := NFEEBRA_ARRAYOFNFES():New()
		::oWSNOTAS:SoapRecv(oNode1)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSTRING
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_ARRAYOFSTRING
	WSDATA   cSTRING                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_ARRAYOFSTRING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_ARRAYOFSTRING
	::cSTRING              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_ARRAYOFSTRING
	Local oClone := NFEEBRA_ARRAYOFSTRING():NEW()
	oClone:cSTRING              := IIf(::cSTRING <> NIL , aClone(::cSTRING) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFEEBRA_ARRAYOFSTRING
	Local cSoap := ""
	aEval( ::cSTRING , {|x| cSoap := cSoap  +  WSSoapValue("STRING", x , x , "string", .F. , .F., 0 )  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_ARRAYOFSTRING
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL) 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cSTRING ,  x:TEXT  ) } )
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure MONITORNFE
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_MONITORNFE
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   oWSERRO                   AS NFEEBRA_ARRAYOFLOTENFE OPTIONAL
	WSDATA   cID                       AS string
	WSDATA   nMODALIDADE               AS integer
	WSDATA   cPROTOCOLO                AS string OPTIONAL
	WSDATA   cRECOMENDACAO             AS string
	WSDATA   cTEMPODEESPERA            AS string
	WSDATA   nTEMPOMEDIOSEF            AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_MONITORNFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_MONITORNFE
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_MONITORNFE
	Local oClone := NFEEBRA_MONITORNFE():NEW()
	oClone:nAMBIENTE            := ::nAMBIENTE
	oClone:oWSERRO              := IIF(::oWSERRO = NIL , NIL , ::oWSERRO:Clone() )
	oClone:cID                  := ::cID
	oClone:nMODALIDADE          := ::nMODALIDADE
	oClone:cPROTOCOLO           := ::cPROTOCOLO
	oClone:cRECOMENDACAO        := ::cRECOMENDACAO
	oClone:cTEMPODEESPERA       := ::cTEMPODEESPERA
	oClone:nTEMPOMEDIOSEF       := ::nTEMPOMEDIOSEF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_MONITORNFE
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nAMBIENTE          :=  WSAdvValue( oResponse,"_AMBIENTE","integer",NIL,"Property nAMBIENTE as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_ERRO","ARRAYOFLOTENFE",NIL,NIL,NIL,"O",NIL) 
	If oNode2 != NIL
		::oWSERRO := NFEEBRA_ARRAYOFLOTENFE():New()
		::oWSERRO:SoapRecv(oNode2)
	EndIf
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nMODALIDADE        :=  WSAdvValue( oResponse,"_MODALIDADE","integer",NIL,"Property nMODALIDADE as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cPROTOCOLO         :=  WSAdvValue( oResponse,"_PROTOCOLO","string",NIL,NIL,NIL,"S",NIL) 
	::cRECOMENDACAO      :=  WSAdvValue( oResponse,"_RECOMENDACAO","string",NIL,"Property cRECOMENDACAO as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cTEMPODEESPERA     :=  WSAdvValue( oResponse,"_TEMPODEESPERA","string",NIL,"Property cTEMPODEESPERA as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nTEMPOMEDIOSEF     :=  WSAdvValue( oResponse,"_TEMPOMEDIOSEF","integer",NIL,"Property nTEMPOMEDIOSEF as s:integer on SOAP Response not found.",NIL,"N",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFES
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_ARRAYOFNFES
	WSDATA   oWSNFES                   AS NFEEBRA_NFES OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_ARRAYOFNFES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_ARRAYOFNFES
	::oWSNFES              := {} // Array Of  NFEEBRA_NFES():New()
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_ARRAYOFNFES
	Local oClone := NFEEBRA_ARRAYOFNFES():NEW()
	oClone:oWSNFES := NIL
	If ::oWSNFES <> NIL 
		oClone:oWSNFES := {}
		aEval( ::oWSNFES , { |x| aadd( oClone:oWSNFES , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFEEBRA_ARRAYOFNFES
	Local cSoap := ""
	aEval( ::oWSNFES , {|x| cSoap := cSoap  +  WSSoapValue("NFES", x , x , "NFES", .F. , .F., 0 )  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_ARRAYOFNFES
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NFES","NFES",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNFES , NFEEBRA_NFES():New() )
			::oWSNFES[len(::oWSNFES)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFLOTENFE
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_ARRAYOFLOTENFE
	WSDATA   oWSLOTENFE                AS NFEEBRA_LOTENFE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_ARRAYOFLOTENFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_ARRAYOFLOTENFE
	::oWSLOTENFE           := {} // Array Of  NFEEBRA_LOTENFE():New()
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_ARRAYOFLOTENFE
	Local oClone := NFEEBRA_ARRAYOFLOTENFE():NEW()
	oClone:oWSLOTENFE := NIL
	If ::oWSLOTENFE <> NIL 
		oClone:oWSLOTENFE := {}
		aEval( ::oWSLOTENFE , { |x| aadd( oClone:oWSLOTENFE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_ARRAYOFLOTENFE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LOTENFE","LOTENFE",{},NIL,.T.,"O",NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLOTENFE , NFEEBRA_LOTENFE():New() )
			::oWSLOTENFE[len(::oWSLOTENFE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFES
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_NFES
	WSDATA   cID                       AS string
	WSDATA   cXML                      AS base64binary
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_NFES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_NFES
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_NFES
	Local oClone := NFEEBRA_NFES():NEW()
	oClone:cID                  := ::cID
	oClone:cXML                 := ::cXML
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFEEBRA_NFES
	Local cSoap := ""
	cSoap += WSSoapValue("ID", ::cID, ::cID , "string", .T. , .F., 0 ) 
	cSoap += WSSoapValue("XML", ::cXML, ::cXML , "base64binary", .T. , .F., 0 ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_NFES
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cXML               :=  WSAdvValue( oResponse,"_XML","base64binary",NIL,"Property cXML as s:base64binary on SOAP Response not found.",NIL,"SB",NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure LOTENFE
------------------------------------------------------------------------------- */

WSSTRUCT NFEEBRA_LOTENFE
	WSDATA   cCODENVLOTE               AS string
	WSDATA   cCODRETNFE                AS string OPTIONAL
	WSDATA   cCODRETRECIBO             AS string OPTIONAL
	WSDATA   dDATALOTE                 AS date
	WSDATA   cHORALOTE                 AS string
	WSDATA   nLOTE                     AS integer
	WSDATA   cMSGENVLOTE               AS string
	WSDATA   cMSGRETNFE                AS string OPTIONAL
	WSDATA   cMSGRETRECIBO             AS string OPTIONAL
	WSDATA   nRECIBOSEFAZ              AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEEBRA_LOTENFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEEBRA_LOTENFE
Return

WSMETHOD CLONE WSCLIENT NFEEBRA_LOTENFE
	Local oClone := NFEEBRA_LOTENFE():NEW()
	oClone:cCODENVLOTE          := ::cCODENVLOTE
	oClone:cCODRETNFE           := ::cCODRETNFE
	oClone:cCODRETRECIBO        := ::cCODRETRECIBO
	oClone:dDATALOTE            := ::dDATALOTE
	oClone:cHORALOTE            := ::cHORALOTE
	oClone:nLOTE                := ::nLOTE
	oClone:cMSGENVLOTE          := ::cMSGENVLOTE
	oClone:cMSGRETNFE           := ::cMSGRETNFE
	oClone:cMSGRETRECIBO        := ::cMSGRETRECIBO
	oClone:nRECIBOSEFAZ         := ::nRECIBOSEFAZ
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEEBRA_LOTENFE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODENVLOTE        :=  WSAdvValue( oResponse,"_CODENVLOTE","string",NIL,"Property cCODENVLOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cCODRETNFE         :=  WSAdvValue( oResponse,"_CODRETNFE","string",NIL,NIL,NIL,"S",NIL) 
	::cCODRETRECIBO      :=  WSAdvValue( oResponse,"_CODRETRECIBO","string",NIL,NIL,NIL,"S",NIL) 
	::dDATALOTE          :=  WSAdvValue( oResponse,"_DATALOTE","date",NIL,"Property dDATALOTE as s:date on SOAP Response not found.",NIL,"D",NIL) 
	::cHORALOTE          :=  WSAdvValue( oResponse,"_HORALOTE","string",NIL,"Property cHORALOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::nLOTE              :=  WSAdvValue( oResponse,"_LOTE","integer",NIL,"Property nLOTE as s:integer on SOAP Response not found.",NIL,"N",NIL) 
	::cMSGENVLOTE        :=  WSAdvValue( oResponse,"_MSGENVLOTE","string",NIL,"Property cMSGENVLOTE as s:string on SOAP Response not found.",NIL,"S",NIL) 
	::cMSGRETNFE         :=  WSAdvValue( oResponse,"_MSGRETNFE","string",NIL,NIL,NIL,"S",NIL) 
	::cMSGRETRECIBO      :=  WSAdvValue( oResponse,"_MSGRETRECIBO","string",NIL,NIL,NIL,"S",NIL) 
	::nRECIBOSEFAZ       :=  WSAdvValue( oResponse,"_RECIBOSEFAZ","integer",NIL,"Property nRECIBOSEFAZ as s:integer on SOAP Response not found.",NIL,"N",NIL) 
Return

