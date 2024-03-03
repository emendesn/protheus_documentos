#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDCTBENTIDADES.apw?WSDL
Gerado em        12/12/08 16:23:55
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080519
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _GLDTNYB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDCTBENTIDADES

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CTBCENTRODECUSTOS
	WSMETHOD CTBDEMONSTRATIVOS
	WSMETHOD CTBHISTORICOPADRAO
	WSMETHOD CTBPLANODECONTAS
	WSMETHOD CTBPLANOREFERENCIAL

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   oWSCENTRODECUSTOS         AS SPEDCTBENTIDADES_SPED_CCUSTO
	WSDATA   cCTBCENTRODECUSTOSRESULT  AS string
	WSDATA   oWSPLANODEMONSTRATIVO     AS SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	WSDATA   cCTBDEMONSTRATIVOSRESULT  AS string
	WSDATA   oWSHISTORICOPADRAO        AS SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	WSDATA   cCTBHISTORICOPADRAORESULT AS string
	WSDATA   oWSPLANODECONTAS          AS SPEDCTBENTIDADES_SPED_PLANODECONTA
	WSDATA   cCTBPLANODECONTASRESULT   AS string
	WSDATA   oWSPLANOREFERENCIAL       AS SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
	WSDATA   cCTBPLANOREFERENCIALRESULT AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSPED_CCUSTO            AS SPEDCTBENTIDADES_SPED_CCUSTO
	WSDATA   oWSSPED_PLANODEMONSTRATIVOS AS SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	WSDATA   oWSSPED_HISTORICOPADRAO   AS SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	WSDATA   oWSSPED_PLANODECONTA      AS SPEDCTBENTIDADES_SPED_PLANODECONTA
	WSDATA   oWSSPED_PLANODECONTASREFERENCIAL AS SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDCTBENTIDADES
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20080818] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDCTBENTIDADES
	::oWSCENTRODECUSTOS  := SPEDCTBENTIDADES_SPED_CCUSTO():New()
	::oWSPLANODEMONSTRATIVO := SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS():New()
	::oWSHISTORICOPADRAO := SPEDCTBENTIDADES_SPED_HISTORICOPADRAO():New()
	::oWSPLANODECONTAS   := SPEDCTBENTIDADES_SPED_PLANODECONTA():New()
	::oWSPLANOREFERENCIAL := SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CCUSTO     := ::oWSCENTRODECUSTOS
	::oWSSPED_PLANODEMONSTRATIVOS := ::oWSPLANODEMONSTRATIVO
	::oWSSPED_HISTORICOPADRAO := ::oWSHISTORICOPADRAO
	::oWSSPED_PLANODECONTA := ::oWSPLANODECONTAS
	::oWSSPED_PLANODECONTASREFERENCIAL := ::oWSPLANOREFERENCIAL
Return

WSMETHOD RESET WSCLIENT WSSPEDCTBENTIDADES
	::cUSERTOKEN         := NIL 
	::oWSCENTRODECUSTOS  := NIL 
	::cCTBCENTRODECUSTOSRESULT := NIL 
	::oWSPLANODEMONSTRATIVO := NIL 
	::cCTBDEMONSTRATIVOSRESULT := NIL 
	::oWSHISTORICOPADRAO := NIL 
	::cCTBHISTORICOPADRAORESULT := NIL 
	::oWSPLANODECONTAS   := NIL 
	::cCTBPLANODECONTASRESULT := NIL 
	::oWSPLANOREFERENCIAL := NIL 
	::cCTBPLANOREFERENCIALRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_CCUSTO     := NIL
	::oWSSPED_PLANODEMONSTRATIVOS := NIL
	::oWSSPED_HISTORICOPADRAO := NIL
	::oWSSPED_PLANODECONTA := NIL
	::oWSSPED_PLANODECONTASREFERENCIAL := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDCTBENTIDADES
Local oClone := WSSPEDCTBENTIDADES():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:oWSCENTRODECUSTOS :=  IIF(::oWSCENTRODECUSTOS = NIL , NIL ,::oWSCENTRODECUSTOS:Clone() )
	oClone:cCTBCENTRODECUSTOSRESULT := ::cCTBCENTRODECUSTOSRESULT
	oClone:oWSPLANODEMONSTRATIVO :=  IIF(::oWSPLANODEMONSTRATIVO = NIL , NIL ,::oWSPLANODEMONSTRATIVO:Clone() )
	oClone:cCTBDEMONSTRATIVOSRESULT := ::cCTBDEMONSTRATIVOSRESULT
	oClone:oWSHISTORICOPADRAO :=  IIF(::oWSHISTORICOPADRAO = NIL , NIL ,::oWSHISTORICOPADRAO:Clone() )
	oClone:cCTBHISTORICOPADRAORESULT := ::cCTBHISTORICOPADRAORESULT
	oClone:oWSPLANODECONTAS :=  IIF(::oWSPLANODECONTAS = NIL , NIL ,::oWSPLANODECONTAS:Clone() )
	oClone:cCTBPLANODECONTASRESULT := ::cCTBPLANODECONTASRESULT
	oClone:oWSPLANOREFERENCIAL :=  IIF(::oWSPLANOREFERENCIAL = NIL , NIL ,::oWSPLANOREFERENCIAL:Clone() )
	oClone:cCTBPLANOREFERENCIALRESULT := ::cCTBPLANOREFERENCIALRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSPED_CCUSTO := oClone:oWSCENTRODECUSTOS
	oClone:oWSSPED_PLANODEMONSTRATIVOS := oClone:oWSPLANODEMONSTRATIVO
	oClone:oWSSPED_HISTORICOPADRAO := oClone:oWSHISTORICOPADRAO
	oClone:oWSSPED_PLANODECONTA := oClone:oWSPLANODECONTAS
	oClone:oWSSPED_PLANODECONTASREFERENCIAL := oClone:oWSPLANOREFERENCIAL
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CTBCENTRODECUSTOS of Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSMETHOD CTBCENTRODECUSTOS WSSEND cUSERTOKEN,oWSCENTRODECUSTOS WSRECEIVE cCTBCENTRODECUSTOSRESULT WSCLIENT WSSPEDCTBENTIDADES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBCENTRODECUSTOS xmlns="http://webservices.totvs.com.br/spedctbentidades.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("CENTRODECUSTOS", ::oWSCENTRODECUSTOS, oWSCENTRODECUSTOS , "SPED_CCUSTO", .T. , .F., 0 , NIL) 
cSoap += "</CTBCENTRODECUSTOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbentidades.apw/CTBCENTRODECUSTOS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbentidades.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBENTIDADES.apw")

::Init()
::cCTBCENTRODECUSTOSRESULT :=  WSAdvValue( oXmlRet,"_CTBCENTRODECUSTOSRESPONSE:_CTBCENTRODECUSTOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBDEMONSTRATIVOS of Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSMETHOD CTBDEMONSTRATIVOS WSSEND cUSERTOKEN,oWSPLANODEMONSTRATIVO WSRECEIVE cCTBDEMONSTRATIVOSRESULT WSCLIENT WSSPEDCTBENTIDADES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBDEMONSTRATIVOS xmlns="http://webservices.totvs.com.br/spedctbentidades.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("PLANODEMONSTRATIVO", ::oWSPLANODEMONSTRATIVO, oWSPLANODEMONSTRATIVO , "SPED_PLANODEMONSTRATIVOS", .T. , .F., 0 , NIL) 
cSoap += "</CTBDEMONSTRATIVOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbentidades.apw/CTBDEMONSTRATIVOS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbentidades.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBENTIDADES.apw")

::Init()
::cCTBDEMONSTRATIVOSRESULT :=  WSAdvValue( oXmlRet,"_CTBDEMONSTRATIVOSRESPONSE:_CTBDEMONSTRATIVOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBHISTORICOPADRAO of Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSMETHOD CTBHISTORICOPADRAO WSSEND cUSERTOKEN,oWSHISTORICOPADRAO WSRECEIVE cCTBHISTORICOPADRAORESULT WSCLIENT WSSPEDCTBENTIDADES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBHISTORICOPADRAO xmlns="http://webservices.totvs.com.br/spedctbentidades.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("HISTORICOPADRAO", ::oWSHISTORICOPADRAO, oWSHISTORICOPADRAO , "SPED_HISTORICOPADRAO", .T. , .F., 0 , NIL) 
cSoap += "</CTBHISTORICOPADRAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbentidades.apw/CTBHISTORICOPADRAO",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbentidades.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBENTIDADES.apw")

::Init()
::cCTBHISTORICOPADRAORESULT :=  WSAdvValue( oXmlRet,"_CTBHISTORICOPADRAORESPONSE:_CTBHISTORICOPADRAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBPLANODECONTAS of Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSMETHOD CTBPLANODECONTAS WSSEND cUSERTOKEN,oWSPLANODECONTAS WSRECEIVE cCTBPLANODECONTASRESULT WSCLIENT WSSPEDCTBENTIDADES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBPLANODECONTAS xmlns="http://webservices.totvs.com.br/spedctbentidades.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("PLANODECONTAS", ::oWSPLANODECONTAS, oWSPLANODECONTAS , "SPED_PLANODECONTA", .T. , .F., 0 , NIL) 
cSoap += "</CTBPLANODECONTAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbentidades.apw/CTBPLANODECONTAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbentidades.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBENTIDADES.apw")

::Init()
::cCTBPLANODECONTASRESULT :=  WSAdvValue( oXmlRet,"_CTBPLANODECONTASRESPONSE:_CTBPLANODECONTASRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CTBPLANOREFERENCIAL of Service WSSPEDCTBENTIDADES
------------------------------------------------------------------------------- */

WSMETHOD CTBPLANOREFERENCIAL WSSEND cUSERTOKEN,oWSPLANOREFERENCIAL WSRECEIVE cCTBPLANOREFERENCIALRESULT WSCLIENT WSSPEDCTBENTIDADES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CTBPLANOREFERENCIAL xmlns="http://webservices.totvs.com.br/spedctbentidades.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("PLANOREFERENCIAL", ::oWSPLANOREFERENCIAL, oWSPLANOREFERENCIAL , "SPED_PLANODECONTASREFERENCIAL", .T. , .F., 0 , NIL) 
cSoap += "</CTBPLANOREFERENCIAL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedctbentidades.apw/CTBPLANOREFERENCIAL",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedctbentidades.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDCTBENTIDADES.apw")

::Init()
::cCTBPLANOREFERENCIALRESULT :=  WSAdvValue( oXmlRet,"_CTBPLANOREFERENCIALRESPONSE:_CTBPLANOREFERENCIALRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CCUSTO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_CCUSTO
	WSDATA   oWSCCUSTO                 AS SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	WSDATA   cID_ENT                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_CCUSTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_CCUSTO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_CCUSTO
	Local oClone := SPEDCTBENTIDADES_SPED_CCUSTO():NEW()
	oClone:oWSCCUSTO            := IIF(::oWSCCUSTO = NIL , NIL , ::oWSCCUSTO:Clone() )
	oClone:cID_ENT              := ::cID_ENT
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_CCUSTO
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::oWSCCUSTO, ::oWSCCUSTO , "ARRAYOFSPED_CENTRODECUSTO", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PLANODEMONSTRATIVOS
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	WSDATA   oWSDEMONSTRATIVO          AS SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	WSDATA   cID_ENT                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	Local oClone := SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS():NEW()
	oClone:oWSDEMONSTRATIVO     := IIF(::oWSDEMONSTRATIVO = NIL , NIL , ::oWSDEMONSTRATIVO:Clone() )
	oClone:cID_ENT              := ::cID_ENT
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_PLANODEMONSTRATIVOS
	Local cSoap := ""
	cSoap += WSSoapValue("DEMONSTRATIVO", ::oWSDEMONSTRATIVO, ::oWSDEMONSTRATIVO , "ARRAYOFSPED_DEMONSTRATIVO", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_HISTORICOPADRAO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	WSDATA   oWSHISTORICO              AS SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	WSDATA   cID_ENT                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	Local oClone := SPEDCTBENTIDADES_SPED_HISTORICOPADRAO():NEW()
	oClone:oWSHISTORICO         := IIF(::oWSHISTORICO = NIL , NIL , ::oWSHISTORICO:Clone() )
	oClone:cID_ENT              := ::cID_ENT
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_HISTORICOPADRAO
	Local cSoap := ""
	cSoap += WSSoapValue("HISTORICO", ::oWSHISTORICO, ::oWSHISTORICO , "ARRAYOFSPED_HISTPAD", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PLANODECONTA
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_PLANODECONTA
	WSDATA   oWSCONTA                  AS SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	WSDATA   cID_ENT                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTA
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTA
	Local oClone := SPEDCTBENTIDADES_SPED_PLANODECONTA():NEW()
	oClone:oWSCONTA             := IIF(::oWSCONTA = NIL , NIL , ::oWSCONTA:Clone() )
	oClone:cID_ENT              := ::cID_ENT
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTA
	Local cSoap := ""
	cSoap += WSSoapValue("CONTA", ::oWSCONTA, ::oWSCONTA , "ARRAYOFSPED_CONTACONTABIL", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PLANODECONTASREFERENCIAL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
	WSDATA   cID_ENT                   AS string
	WSDATA   oWSREFERENCIA             AS SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
	Local oClone := SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL():NEW()
	oClone:cID_ENT              := ::cID_ENT
	oClone:oWSREFERENCIA        := IIF(::oWSREFERENCIA = NIL , NIL , ::oWSREFERENCIA:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_PLANODECONTASREFERENCIAL
	Local cSoap := ""
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("REFERENCIA", ::oWSREFERENCIA, ::oWSREFERENCIA , "ARRAYOFSPED_PLANOREFERENCIAL", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CENTRODECUSTO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	WSDATA   oWSSPED_CENTRODECUSTO     AS SPEDCTBENTIDADES_SPED_CENTRODECUSTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	::oWSSPED_CENTRODECUSTO := {} // Array Of  SPEDCTBENTIDADES_SPED_CENTRODECUSTO():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	Local oClone := SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO():NEW()
	oClone:oWSSPED_CENTRODECUSTO := NIL
	If ::oWSSPED_CENTRODECUSTO <> NIL 
		oClone:oWSSPED_CENTRODECUSTO := {}
		aEval( ::oWSSPED_CENTRODECUSTO , { |x| aadd( oClone:oWSSPED_CENTRODECUSTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CENTRODECUSTO
	Local cSoap := ""
	aEval( ::oWSSPED_CENTRODECUSTO , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CENTRODECUSTO", x , x , "SPED_CENTRODECUSTO", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_DEMONSTRATIVO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	WSDATA   oWSSPED_DEMONSTRATIVO     AS SPEDCTBENTIDADES_SPED_DEMONSTRATIVO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	::oWSSPED_DEMONSTRATIVO := {} // Array Of  SPEDCTBENTIDADES_SPED_DEMONSTRATIVO():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	Local oClone := SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO():NEW()
	oClone:oWSSPED_DEMONSTRATIVO := NIL
	If ::oWSSPED_DEMONSTRATIVO <> NIL 
		oClone:oWSSPED_DEMONSTRATIVO := {}
		aEval( ::oWSSPED_DEMONSTRATIVO , { |x| aadd( oClone:oWSSPED_DEMONSTRATIVO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_DEMONSTRATIVO
	Local cSoap := ""
	aEval( ::oWSSPED_DEMONSTRATIVO , {|x| cSoap := cSoap  +  WSSoapValue("SPED_DEMONSTRATIVO", x , x , "SPED_DEMONSTRATIVO", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_HISTPAD
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	WSDATA   oWSSPED_HISTPAD           AS SPEDCTBENTIDADES_SPED_HISTPAD OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	::oWSSPED_HISTPAD      := {} // Array Of  SPEDCTBENTIDADES_SPED_HISTPAD():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	Local oClone := SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD():NEW()
	oClone:oWSSPED_HISTPAD := NIL
	If ::oWSSPED_HISTPAD <> NIL 
		oClone:oWSSPED_HISTPAD := {}
		aEval( ::oWSSPED_HISTPAD , { |x| aadd( oClone:oWSSPED_HISTPAD , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_HISTPAD
	Local cSoap := ""
	aEval( ::oWSSPED_HISTPAD , {|x| cSoap := cSoap  +  WSSoapValue("SPED_HISTPAD", x , x , "SPED_HISTPAD", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_CONTACONTABIL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	WSDATA   oWSSPED_CONTACONTABIL     AS SPEDCTBENTIDADES_SPED_CONTACONTABIL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	::oWSSPED_CONTACONTABIL := {} // Array Of  SPEDCTBENTIDADES_SPED_CONTACONTABIL():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	Local oClone := SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL():NEW()
	oClone:oWSSPED_CONTACONTABIL := NIL
	If ::oWSSPED_CONTACONTABIL <> NIL 
		oClone:oWSSPED_CONTACONTABIL := {}
		aEval( ::oWSSPED_CONTACONTABIL , { |x| aadd( oClone:oWSSPED_CONTACONTABIL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_CONTACONTABIL
	Local cSoap := ""
	aEval( ::oWSSPED_CONTACONTABIL , {|x| cSoap := cSoap  +  WSSoapValue("SPED_CONTACONTABIL", x , x , "SPED_CONTACONTABIL", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_PLANOREFERENCIAL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	WSDATA   oWSSPED_PLANOREFERENCIAL  AS SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	::oWSSPED_PLANOREFERENCIAL := {} // Array Of  SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL():New()
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	Local oClone := SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL():NEW()
	oClone:oWSSPED_PLANOREFERENCIAL := NIL
	If ::oWSSPED_PLANOREFERENCIAL <> NIL 
		oClone:oWSSPED_PLANOREFERENCIAL := {}
		aEval( ::oWSSPED_PLANOREFERENCIAL , { |x| aadd( oClone:oWSSPED_PLANOREFERENCIAL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_ARRAYOFSPED_PLANOREFERENCIAL
	Local cSoap := ""
	aEval( ::oWSSPED_PLANOREFERENCIAL , {|x| cSoap := cSoap  +  WSSoapValue("SPED_PLANOREFERENCIAL", x , x , "SPED_PLANOREFERENCIAL", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CENTRODECUSTO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_CENTRODECUSTO
	WSDATA   cCCUSTO                   AS string
	WSDATA   cDESCRI                   AS string
	WSDATA   dDTINI                    AS date
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_CENTRODECUSTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_CENTRODECUSTO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_CENTRODECUSTO
	Local oClone := SPEDCTBENTIDADES_SPED_CENTRODECUSTO():NEW()
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cDESCRI              := ::cDESCRI
	oClone:dDTINI               := ::dDTINI
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_CENTRODECUSTO
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, ::cCCUSTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DESCRI", ::cDESCRI, ::cDESCRI , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_DEMONSTRATIVO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_DEMONSTRATIVO
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCOD_CTA_AGL              AS string
	WSDATA   cCOD_CTA_AGLSUP           AS string
	WSDATA   cCOD_NAT                  AS string OPTIONAL
	WSDATA   cCODCTA                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_DEMONSTRATIVO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_DEMONSTRATIVO
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_DEMONSTRATIVO
	Local oClone := SPEDCTBENTIDADES_SPED_DEMONSTRATIVO():NEW()
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cCOD_CTA_AGL         := ::cCOD_CTA_AGL
	oClone:cCOD_CTA_AGLSUP      := ::cCOD_CTA_AGLSUP
	oClone:cCOD_NAT             := ::cCOD_NAT
	oClone:cCODCTA              := ::cCODCTA
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_DEMONSTRATIVO
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, ::cCCUSTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_CTA_AGL", ::cCOD_CTA_AGL, ::cCOD_CTA_AGL , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_CTA_AGLSUP", ::cCOD_CTA_AGLSUP, ::cCOD_CTA_AGLSUP , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_NAT", ::cCOD_NAT, ::cCOD_NAT , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTA", ::cCODCTA, ::cCODCTA , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_HISTPAD
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_HISTPAD
	WSDATA   cCODIGO                   AS string
	WSDATA   cDESCRICAO                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_HISTPAD
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_HISTPAD
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_HISTPAD
	Local oClone := SPEDCTBENTIDADES_SPED_HISTPAD():NEW()
	oClone:cCODIGO              := ::cCODIGO
	oClone:cDESCRICAO           := ::cDESCRICAO
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_HISTPAD
	Local cSoap := ""
	cSoap += WSSoapValue("CODIGO", ::cCODIGO, ::cCODIGO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_CONTACONTABIL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_CONTACONTABIL
	WSDATA   cCOD_NAT                  AS string
	WSDATA   cCODCTA                   AS string
	WSDATA   cCODCTASUP                AS string OPTIONAL
	WSDATA   cDESCRI                   AS string
	WSDATA   dDTINI                    AS date
	WSDATA   cIND_CTA                  AS string
	WSDATA   nNIVEL                    AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_CONTACONTABIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_CONTACONTABIL
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_CONTACONTABIL
	Local oClone := SPEDCTBENTIDADES_SPED_CONTACONTABIL():NEW()
	oClone:cCOD_NAT             := ::cCOD_NAT
	oClone:cCODCTA              := ::cCODCTA
	oClone:cCODCTASUP           := ::cCODCTASUP
	oClone:cDESCRI              := ::cDESCRI
	oClone:dDTINI               := ::dDTINI
	oClone:cIND_CTA             := ::cIND_CTA
	oClone:nNIVEL               := ::nNIVEL
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_CONTACONTABIL
	Local cSoap := ""
	cSoap += WSSoapValue("COD_NAT", ::cCOD_NAT, ::cCOD_NAT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTA", ::cCODCTA, ::cCODCTA , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTASUP", ::cCODCTASUP, ::cCODCTASUP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DESCRI", ::cDESCRI, ::cDESCRI , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IND_CTA", ::cIND_CTA, ::cIND_CTA , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NIVEL", ::nNIVEL, ::nNIVEL , "integer", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PLANOREFERENCIAL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCOD_CTA_REF              AS string
	WSDATA   cCOD_ENT_REF              AS string
	WSDATA   cCODCTA                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL
Return

WSMETHOD CLONE WSCLIENT SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL
	Local oClone := SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL():NEW()
	oClone:cCCUSTO              := ::cCCUSTO
	oClone:cCOD_CTA_REF         := ::cCOD_CTA_REF
	oClone:cCOD_ENT_REF         := ::cCOD_ENT_REF
	oClone:cCODCTA              := ::cCODCTA
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDCTBENTIDADES_SPED_PLANOREFERENCIAL
	Local cSoap := ""
	cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, ::cCCUSTO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_CTA_REF", ::cCOD_CTA_REF, ::cCOD_CTA_REF , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_ENT_REF", ::cCOD_ENT_REF, ::cCOD_ENT_REF , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CODCTA", ::cCODCTA, ::cCODCTA , "string", .T. , .F., 0 , NIL ) 
Return cSoap


