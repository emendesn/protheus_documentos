#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDCTBDEMONSTRACOESCONTABEIS.apw?WSDL
Gerado em        12/12/08 16:23:37
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080519
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QKVDFPM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDCTBDEMONSTRACOESCONTABEIS
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CTBBALANCOPATRIMONIAL
	WSMETHOD CTBDRE
	WSMETHOD CTBOUTRASRTF

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   oWSDEMONSTRATIVO          AS SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	WSDATA   cCTBBALANCOPATRIMONIALRESULT AS string
	WSDATA   cCTBDRERESULT             AS string
	WSDATA   oWSDEMONSTRATIVORTF       AS SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
	WSDATA   cCTBOUTRASRTFRESULT       AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSPED_CTBDEMONSTRATIVOS AS SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	WSDATA   oWSSPED_CTBDEMONSTRATIVORTF AS SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20080818] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
	::oWSDEMONSTRATIVO   := SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS():New()
	::oWSDEMONSTRATIVORTF := SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CTBDEMONSTRATIVOS := ::oWSDEMONSTRATIVO
	::oWSSPED_CTBDEMONSTRATIVORTF := ::oWSDEMONSTRATIVORTF
Return

WSMETHOD RESET WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
	::cUSERTOKEN         := NIL 
	::oWSDEMONSTRATIVO   := NIL 
	::cCTBBALANCOPATRIMONIALRESULT := NIL 
	::cCTBDRERESULT      := NIL 
	::oWSDEMONSTRATIVORTF := NIL 
	::cCTBOUTRASRTFRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CTBDEMONSTRATIVOS := NIL
	::oWSSPED_CTBDEMONSTRATIVORTF := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
Local oClone := WSSPEDCTBDEMONSTRACOESCONTABEIS():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:oWSDEMONSTRATIVO :=  IIF(::oWSDEMONSTRATIVO = NIL , NIL ,::oWSDEMONSTRATIVO:Clone() )
	oClone:cCTBBALANCOPATRIMONIALRESULT := ::cCTBBALANCOPATRIMONIALRESULT
	oClone:cCTBDRERESULT := ::cCTBDRERESULT
	oClone:oWSDEMONSTRATIVORTF :=  IIF(::oWSDEMONSTRATIVORTF = NIL , NIL ,::oWSDEMONSTRATIVORTF:Clone() )
	oClone:cCTBOUTRASRTFRESULT := ::cCTBOUTRASRTFRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSPED_CTBDEMONSTRATIVOS := oClone:oWSDEMONSTRATIVO
	oClone:oWSSPED_CTBDEMONSTRATIVORTF := oClone:oWSDEMONSTRATIVORTF
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CTBBALANCOPATRIMONIAL of Service WSSPEDCTBDEMONSTRACOESCONTABEIS
------------------------------------------------------------------------------- */

WSMETHOD CTBBALANCOPATRIMONIAL WSSEND cUSERTOKEN,oWSDEMONSTRATIVO WSRECEIVE cCTBBALANCOPATRIMONIALRESULT WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBBALANCOPATRIMONIAL xmlns="http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("DEMONSTRATIVO", ::oWSDEMONSTRATIVO, oWSDEMONSTRATIVO , "SPED_CTBDEMONSTRATIVOS", .T. , .F., 0 , NIL) 
cSoap += "</CTBBALANCOPATRIMONIAL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw/CTBBALANCOPATRIMONIAL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBDEMONSTRACOESCONTABEIS.apw")

::Init()
::cCTBBALANCOPATRIMONIALRESULT :=  WSAdvValue( oXmlRet,"_CTBBALANCOPATRIMONIALRESPONSE:_CTBBALANCOPATRIMONIALRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBDRE of Service WSSPEDCTBDEMONSTRACOESCONTABEIS
------------------------------------------------------------------------------- */

WSMETHOD CTBDRE WSSEND cUSERTOKEN,oWSDEMONSTRATIVO WSRECEIVE cCTBDRERESULT WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBDRE xmlns="http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("DEMONSTRATIVO", ::oWSDEMONSTRATIVO, oWSDEMONSTRATIVO , "SPED_CTBDEMONSTRATIVOS", .T. , .F., 0 , NIL) 
cSoap += "</CTBDRE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw/CTBDRE",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBDEMONSTRACOESCONTABEIS.apw")

::Init()
::cCTBDRERESULT      :=  WSAdvValue( oXmlRet,"_CTBDRERESPONSE:_CTBDRERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBOUTRASRTF of Service WSSPEDCTBDEMONSTRACOESCONTABEIS
------------------------------------------------------------------------------- */

WSMETHOD CTBOUTRASRTF WSSEND cUSERTOKEN,oWSDEMONSTRATIVORTF WSRECEIVE cCTBOUTRASRTFRESULT WSCLIENT WSSPEDCTBDEMONSTRACOESCONTABEIS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBOUTRASRTF xmlns="http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("DEMONSTRATIVORTF", ::oWSDEMONSTRATIVORTF, oWSDEMONSTRATIVORTF , "SPED_CTBDEMONSTRATIVORTF", .T. , .F., 0 , NIL) 
cSoap += "</CTBOUTRASRTF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw/CTBOUTRASRTF",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbdemonstracoescontabeis.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBDEMONSTRACOESCONTABEIS.apw")

::Init()
::cCTBOUTRASRTFRESULT :=  WSAdvValue( oXmlRet,"_CTBOUTRASRTFRESPONSE:_CTBOUTRASRTFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBDEMONSTRATIVOS
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	WSDATA   oWSDEMONSTRACAO           AS SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINI                    AS date
	WSDATA   cID_ENT                   AS string
	WSDATA   nORDEM                    AS integer
	WSDATA   cTEXTO                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
Return

WSMETHOD CLONE WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	Local oClone := SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS():NEW()
	oClone:oWSDEMONSTRACAO      := IIF(::oWSDEMONSTRACAO = NIL , NIL , ::oWSDEMONSTRACAO:Clone() )
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
	oClone:cID_ENT              := ::cID_ENT
	oClone:nORDEM               := ::nORDEM
	oClone:cTEXTO               := ::cTEXTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVOS
	Local cSoap := ""
	cSoap += WSSoapValue("DEMONSTRACAO", ::oWSDEMONSTRACAO, ::oWSDEMONSTRACAO , "ARRAYOFSPED_CTBLCTODODEMONSTRATIVO", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("TEXTO", ::cTEXTO, ::cTEXTO , "string", .F. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBDEMONSTRATIVORTF
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
	WSDATA   cARQRTF                   AS base64binary
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINI                    AS date
	WSDATA   cID_ENT                   AS string
	WSDATA   cNOMEDEM                  AS string
	WSDATA   nORDEM                    AS integer
	WSDATA   cTEXTO                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
Return

WSMETHOD CLONE WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
	Local oClone := SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF():NEW()
	oClone:cARQRTF              := ::cARQRTF
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
	oClone:cID_ENT              := ::cID_ENT
	oClone:cNOMEDEM             := ::cNOMEDEM
	oClone:nORDEM               := ::nORDEM
	oClone:cTEXTO               := ::cTEXTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBDEMONSTRATIVORTF
	Local cSoap := ""
	cSoap += WSSoapValue("ARQRTF", ::cARQRTF, ::cARQRTF , "base64binary", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NOMEDEM", ::cNOMEDEM, ::cNOMEDEM , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ORDEM", ::nORDEM, ::nORDEM , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("TEXTO", ::cTEXTO, ::cTEXTO , "string", .F. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	WSDATA   oWSSPED_CTBLCTODODEMONSTRATIVO AS SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	::oWSSPED_CTBLCTODODEMONSTRATIVO := {} // Array Of  SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	Local oClone := SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO():NEW()
	oClone:oWSSPED_CTBLCTODODEMONSTRATIVO := NIL
	If ::oWSSPED_CTBLCTODODEMONSTRATIVO <> NIL 
		oClone:oWSSPED_CTBLCTODODEMONSTRATIVO := {}
		aEval( ::oWSSPED_CTBLCTODODEMONSTRATIVO , { |x| aadd( oClone:oWSSPED_CTBLCTODODEMONSTRATIVO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_ARRAYOFSPED_CTBLCTODODEMONSTRATIVO
	Local cSoap := ""
	aEval( ::oWSSPED_CTBLCTODODEMONSTRATIVO , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CTBLCTODODEMONSTRATIVO", x , x , "SPED_CTBLCTODODEMONSTRATIVO", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CTBLCTODODEMONSTRATIVO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO
	WSDATA   cCOD_CTA_AGL              AS string
	WSDATA   cDESCRICAO                AS string
	WSDATA   cIND_VALOR                AS string
	WSDATA   nNIVEL_CTA_AGL            AS integer
	WSDATA   nVALOR                    AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO
	Local oClone := SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO():NEW()
	oClone:cCOD_CTA_AGL         := ::cCOD_CTA_AGL
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:cIND_VALOR           := ::cIND_VALOR
	oClone:nNIVEL_CTA_AGL       := ::nNIVEL_CTA_AGL
	oClone:nVALOR               := ::nVALOR
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBDEMONSTRACOESCONTABEIS_SPED_CTBLCTODODEMONSTRATIVO
	Local cSoap := ""
	cSoap += WSSoapValue("COD_CTA_AGL", ::cCOD_CTA_AGL, ::cCOD_CTA_AGL , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IND_VALOR", ::cIND_VALOR, ::cIND_VALOR , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NIVEL_CTA_AGL", ::nNIVEL_CTA_AGL, ::nNIVEL_CTA_AGL , "integer", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("VALOR", ::nVALOR, ::nVALOR , "float", .T. , .F., 0 , NIL ) 
Return cSoap


