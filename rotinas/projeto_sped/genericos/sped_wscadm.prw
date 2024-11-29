#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/SPEDADM.apw?WSDL
Gerado em        09/19/08 16:28:06
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080519
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ITSZNMA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSPEDADM
------------------------------------------------------------------------------- */

WSCLIENT WSSPEDADM

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ADMCLEAR
	WSMETHOD ADMEMPRESAS
	WSMETHOD ADMPARTICIPANTES
	WSMETHOD ADMSIGNATARIOS
	WSMETHOD GETADMEMPRESAS
	WSMETHOD GETADMEMPRESASID

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   cID_ENT                   AS string
	WSDATA   cADMCLEARRESULT           AS string
	WSDATA   oWSEMPRESA                AS SPEDADM_SPED_ENTIDADE
	WSDATA   oWSOUTRASINSCRICOES       AS SPEDADM_SPED_ENTIDADEREFERENCIAL
	WSDATA   cADMEMPRESASRESULT        AS string
	WSDATA   oWSPARTICIPANTE           AS SPEDADM_SPED_PARTICIPANTE
	WSDATA   cADMPARTICIPANTESRESULT   AS string
	WSDATA   oWSSIGNATARIO             AS SPEDADM_SPED_SIGNATARIO
	WSDATA   cADMSIGNATARIOSRESULT     AS string
	WSDATA   cCNPJ                     AS string
	WSDATA   cCPF                      AS string
	WSDATA   cIE                       AS string
	WSDATA   cUF                       AS string
	WSDATA   oWSGETADMEMPRESASRESULT   AS SPEDADM_ARRAYOFSPED_ENTIDADE
	WSDATA   cGETADMEMPRESASIDRESULT   AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSPED_ENTIDADE          AS SPEDADM_SPED_ENTIDADE
	WSDATA   oWSSPED_ENTIDADEREFERENCIAL AS SPEDADM_SPED_ENTIDADEREFERENCIAL
	WSDATA   oWSSPED_PARTICIPANTE      AS SPEDADM_SPED_PARTICIPANTE
	WSDATA   oWSSPED_SIGNATARIO        AS SPEDADM_SPED_SIGNATARIO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSPEDADM
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20080818] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSPEDADM
	::oWSEMPRESA         := SPEDADM_SPED_ENTIDADE():New()
	::oWSOUTRASINSCRICOES := SPEDADM_SPED_ENTIDADEREFERENCIAL():New()
	::oWSPARTICIPANTE    := SPEDADM_SPED_PARTICIPANTE():New()
	::oWSSIGNATARIO      := SPEDADM_SPED_SIGNATARIO():New()
	::oWSGETADMEMPRESASRESULT := SPEDADM_ARRAYOFSPED_ENTIDADE():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_ENTIDADE   := ::oWSEMPRESA
	::oWSSPED_ENTIDADEREFERENCIAL := ::oWSOUTRASINSCRICOES
	::oWSSPED_PARTICIPANTE := ::oWSPARTICIPANTE
	::oWSSPED_SIGNATARIO := ::oWSSIGNATARIO
Return

WSMETHOD RESET WSCLIENT WSSPEDADM
	::cUSERTOKEN         := NIL 
	::cID_ENT            := NIL 
	::cADMCLEARRESULT    := NIL 
	::oWSEMPRESA         := NIL 
	::oWSOUTRASINSCRICOES := NIL 
	::cADMEMPRESASRESULT := NIL 
	::oWSPARTICIPANTE    := NIL 
	::cADMPARTICIPANTESRESULT := NIL 
	::oWSSIGNATARIO      := NIL 
	::cADMSIGNATARIOSRESULT := NIL 
	::cCNPJ              := NIL 
	::cCPF               := NIL 
	::cIE                := NIL 
	::cUF                := NIL 
	::oWSGETADMEMPRESASRESULT := NIL 
	::cGETADMEMPRESASIDRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSPED_ENTIDADE   := NIL
	::oWSSPED_ENTIDADEREFERENCIAL := NIL
	::oWSSPED_PARTICIPANTE := NIL
	::oWSSPED_SIGNATARIO := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSPEDADM
Local oClone := WSSPEDADM():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:cID_ENT       := ::cID_ENT
	oClone:cADMCLEARRESULT := ::cADMCLEARRESULT
	oClone:oWSEMPRESA    :=  IIF(::oWSEMPRESA = NIL , NIL ,::oWSEMPRESA:Clone() )
	oClone:oWSOUTRASINSCRICOES :=  IIF(::oWSOUTRASINSCRICOES = NIL , NIL ,::oWSOUTRASINSCRICOES:Clone() )
	oClone:cADMEMPRESASRESULT := ::cADMEMPRESASRESULT
	oClone:oWSPARTICIPANTE :=  IIF(::oWSPARTICIPANTE = NIL , NIL ,::oWSPARTICIPANTE:Clone() )
	oClone:cADMPARTICIPANTESRESULT := ::cADMPARTICIPANTESRESULT
	oClone:oWSSIGNATARIO :=  IIF(::oWSSIGNATARIO = NIL , NIL ,::oWSSIGNATARIO:Clone() )
	oClone:cADMSIGNATARIOSRESULT := ::cADMSIGNATARIOSRESULT
	oClone:cCNPJ         := ::cCNPJ
	oClone:cCPF          := ::cCPF
	oClone:cIE           := ::cIE
	oClone:cUF           := ::cUF
	oClone:oWSGETADMEMPRESASRESULT :=  IIF(::oWSGETADMEMPRESASRESULT = NIL , NIL ,::oWSGETADMEMPRESASRESULT:Clone() )
	oClone:cGETADMEMPRESASIDRESULT := ::cGETADMEMPRESASIDRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSPED_ENTIDADE := oClone:oWSEMPRESA
	oClone:oWSSPED_ENTIDADEREFERENCIAL := oClone:oWSOUTRASINSCRICOES
	oClone:oWSSPED_PARTICIPANTE := oClone:oWSPARTICIPANTE
	oClone:oWSSPED_SIGNATARIO := oClone:oWSSIGNATARIO
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method ADMCLEAR of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD ADMCLEAR WSSEND cUSERTOKEN,cID_ENT WSRECEIVE cADMCLEARRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ADMCLEAR xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL) 
cSoap += "</ADMCLEAR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/ADMCLEAR",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::cADMCLEARRESULT    :=  WSAdvValue( oXmlRet,"_ADMCLEARRESPONSE:_ADMCLEARRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method ADMEMPRESAS of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD ADMEMPRESAS WSSEND cUSERTOKEN,oWSEMPRESA,oWSOUTRASINSCRICOES WSRECEIVE cADMEMPRESASRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ADMEMPRESAS xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("EMPRESA", ::oWSEMPRESA, oWSEMPRESA , "SPED_ENTIDADE", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("OUTRASINSCRICOES", ::oWSOUTRASINSCRICOES, oWSOUTRASINSCRICOES , "SPED_ENTIDADEREFERENCIAL", .T. , .F., 0 , NIL) 
cSoap += "</ADMEMPRESAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/ADMEMPRESAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::cADMEMPRESASRESULT :=  WSAdvValue( oXmlRet,"_ADMEMPRESASRESPONSE:_ADMEMPRESASRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method ADMPARTICIPANTES of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD ADMPARTICIPANTES WSSEND cUSERTOKEN,oWSPARTICIPANTE WSRECEIVE cADMPARTICIPANTESRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ADMPARTICIPANTES xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("PARTICIPANTE", ::oWSPARTICIPANTE, oWSPARTICIPANTE , "SPED_PARTICIPANTE", .T. , .F., 0 , NIL) 
cSoap += "</ADMPARTICIPANTES>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/ADMPARTICIPANTES",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::cADMPARTICIPANTESRESULT :=  WSAdvValue( oXmlRet,"_ADMPARTICIPANTESRESPONSE:_ADMPARTICIPANTESRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method ADMSIGNATARIOS of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD ADMSIGNATARIOS WSSEND cUSERTOKEN,oWSSIGNATARIO WSRECEIVE cADMSIGNATARIOSRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ADMSIGNATARIOS xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("SIGNATARIO", ::oWSSIGNATARIO, oWSSIGNATARIO , "SPED_SIGNATARIO", .T. , .F., 0 , NIL) 
cSoap += "</ADMSIGNATARIOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/ADMSIGNATARIOS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::cADMSIGNATARIOSRESULT :=  WSAdvValue( oXmlRet,"_ADMSIGNATARIOSRESPONSE:_ADMSIGNATARIOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETADMEMPRESAS of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD GETADMEMPRESAS WSSEND cUSERTOKEN,cCNPJ,cCPF,cIE,cUF WSRECEIVE oWSGETADMEMPRESASRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETADMEMPRESAS xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("IE", ::cIE, cIE , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .T. , .F., 0 , NIL) 
cSoap += "</GETADMEMPRESAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/GETADMEMPRESAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::oWSGETADMEMPRESASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETADMEMPRESASRESPONSE:_GETADMEMPRESASRESULT","ARRAYOFSPED_ENTIDADE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GETADMEMPRESASID of Service WSSPEDADM
------------------------------------------------------------------------------- */

WSMETHOD GETADMEMPRESASID WSSEND cUSERTOKEN,cCNPJ,cCPF,cIE,cUF WSRECEIVE cGETADMEMPRESASIDRESULT WSCLIENT WSSPEDADM
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETADMEMPRESASID xmlns="http://webservices.totvs.com.br/spedadm.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("IE", ::cIE, cIE , "string", .T. , .F., 0 , NIL) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .T. , .F., 0 , NIL) 
cSoap += "</GETADMEMPRESASID>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/spedadm.apw/GETADMEMPRESASID",; 
	"DOCUMENT","http://webservices.totvs.com.br/spedadm.apw",,"1.031217",; 
	"http://localhost:8080/ws/SPEDADM.apw")

::Init()
::cGETADMEMPRESASIDRESULT :=  WSAdvValue( oXmlRet,"_GETADMEMPRESASIDRESPONSE:_GETADMEMPRESASIDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_ENTIDADEREFERENCIAL
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_SPED_ENTIDADEREFERENCIAL
	WSDATA   oWSINSCRICAO              AS SPEDADM_ARRAYOFSPED_GENERICSTRUCT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_SPED_ENTIDADEREFERENCIAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_SPED_ENTIDADEREFERENCIAL
Return

WSMETHOD CLONE WSCLIENT SPEDADM_SPED_ENTIDADEREFERENCIAL
	Local oClone := SPEDADM_SPED_ENTIDADEREFERENCIAL():NEW()
	oClone:oWSINSCRICAO         := IIF(::oWSINSCRICAO = NIL , NIL , ::oWSINSCRICAO:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_SPED_ENTIDADEREFERENCIAL
	Local cSoap := ""
	cSoap += WSSoapValue("INSCRICAO", ::oWSINSCRICAO, ::oWSINSCRICAO , "ARRAYOFSPED_GENERICSTRUCT", .F. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_PARTICIPANTE
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_SPED_PARTICIPANTE
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cCEP                      AS string
	WSDATA   cCEP_CP                   AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cCOD_MUN                  AS string
	WSDATA   cCOD_PAIS                 AS string
	WSDATA   cCOD_REL                  AS string OPTIONAL
	WSDATA   cCOMPL                    AS string OPTIONAL
	WSDATA   cCP                       AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDDD                      AS string OPTIONAL
	WSDATA   dDTFIM                    AS date OPTIONAL
	WSDATA   dDTINI                    AS date
	WSDATA   cENDERECO                 AS string
	WSDATA   cFAX                      AS string OPTIONAL
	WSDATA   cFONE                     AS string OPTIONAL
	WSDATA   cID_ENT                   AS string
	WSDATA   cIE                       AS string OPTIONAL
	WSDATA   cIE_ST                    AS string OPTIONAL
	WSDATA   cIM                       AS string OPTIONAL
	WSDATA   cMUN                      AS string OPTIONAL
	WSDATA   cNIT                      AS string OPTIONAL
	WSDATA   cNOME                     AS string
	WSDATA   cNUM                      AS string OPTIONAL
	WSDATA   cSUFRAMA                  AS string OPTIONAL
	WSDATA   cUF                       AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_SPED_PARTICIPANTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_SPED_PARTICIPANTE
Return

WSMETHOD CLONE WSCLIENT SPEDADM_SPED_PARTICIPANTE
	Local oClone := SPEDADM_SPED_PARTICIPANTE():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCEP                 := ::cCEP
	oClone:cCEP_CP              := ::cCEP_CP
	oClone:cCNPJ                := ::cCNPJ
	oClone:cCOD_MUN             := ::cCOD_MUN
	oClone:cCOD_PAIS            := ::cCOD_PAIS
	oClone:cCOD_REL             := ::cCOD_REL
	oClone:cCOMPL               := ::cCOMPL
	oClone:cCP                  := ::cCP
	oClone:cCPF                 := ::cCPF
	oClone:cDDD                 := ::cDDD
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
	oClone:cENDERECO            := ::cENDERECO
	oClone:cFAX                 := ::cFAX
	oClone:cFONE                := ::cFONE
	oClone:cID_ENT              := ::cID_ENT
	oClone:cIE                  := ::cIE
	oClone:cIE_ST               := ::cIE_ST
	oClone:cIM                  := ::cIM
	oClone:cMUN                 := ::cMUN
	oClone:cNIT                 := ::cNIT
	oClone:cNOME                := ::cNOME
	oClone:cNUM                 := ::cNUM
	oClone:cSUFRAMA             := ::cSUFRAMA
	oClone:cUF                  := ::cUF
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_SPED_PARTICIPANTE
	Local cSoap := ""
	cSoap += WSSoapValue("BAIRRO", ::cBAIRRO, ::cBAIRRO , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CEP_CP", ::cCEP_CP, ::cCEP_CP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_MUN", ::cCOD_MUN, ::cCOD_MUN , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_PAIS", ::cCOD_PAIS, ::cCOD_PAIS , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_REL", ::cCOD_REL, ::cCOD_REL , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COMPL", ::cCOMPL, ::cCOMPL , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CP", ::cCP, ::cCP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DDD", ::cDDD, ::cDDD , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ENDERECO", ::cENDERECO, ::cENDERECO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FAX", ::cFAX, ::cFAX , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FONE", ::cFONE, ::cFONE , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IE", ::cIE, ::cIE , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IE_ST", ::cIE_ST, ::cIE_ST , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IM", ::cIM, ::cIM , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("MUN", ::cMUN, ::cMUN , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NIT", ::cNIT, ::cNIT , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NUM", ::cNUM, ::cNUM , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("SUFRAMA", ::cSUFRAMA, ::cSUFRAMA , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("UF", ::cUF, ::cUF , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_SIGNATARIO
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_SPED_SIGNATARIO
	WSDATA   cCOD_ASSIN                AS string
	WSDATA   cCRC                      AS string
	WSDATA   cID_ENT                   AS string
	WSDATA   cID_PART                  AS string
	WSDATA   cIDENT_QUALIF             AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_SPED_SIGNATARIO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_SPED_SIGNATARIO
Return

WSMETHOD CLONE WSCLIENT SPEDADM_SPED_SIGNATARIO
	Local oClone := SPEDADM_SPED_SIGNATARIO():NEW()
	oClone:cCOD_ASSIN           := ::cCOD_ASSIN
	oClone:cCRC                 := ::cCRC
	oClone:cID_ENT              := ::cID_ENT
	oClone:cID_PART             := ::cID_PART
	oClone:cIDENT_QUALIF        := ::cIDENT_QUALIF
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_SPED_SIGNATARIO
	Local cSoap := ""
	cSoap += WSSoapValue("COD_ASSIN", ::cCOD_ASSIN, ::cCOD_ASSIN , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CRC", ::cCRC, ::cCRC , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_ENT", ::cID_ENT, ::cID_ENT , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_PART", ::cID_PART, ::cID_PART , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IDENT_QUALIF", ::cIDENT_QUALIF, ::cIDENT_QUALIF , "string", .T. , .F., 0 , NIL ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_ENTIDADE
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_ARRAYOFSPED_ENTIDADE
	WSDATA   oWSSPED_ENTIDADE          AS SPEDADM_SPED_ENTIDADE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_ARRAYOFSPED_ENTIDADE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_ARRAYOFSPED_ENTIDADE
	::oWSSPED_ENTIDADE     := {} // Array Of  SPEDADM_SPED_ENTIDADE():New()
Return

WSMETHOD CLONE WSCLIENT SPEDADM_ARRAYOFSPED_ENTIDADE
	Local oClone := SPEDADM_ARRAYOFSPED_ENTIDADE():NEW()
	oClone:oWSSPED_ENTIDADE := NIL
	If ::oWSSPED_ENTIDADE <> NIL 
		oClone:oWSSPED_ENTIDADE := {}
		aEval( ::oWSSPED_ENTIDADE , { |x| aadd( oClone:oWSSPED_ENTIDADE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDADM_ARRAYOFSPED_ENTIDADE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_SPED_ENTIDADE","SPED_ENTIDADE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSPED_ENTIDADE , SPEDADM_SPED_ENTIDADE():New() )
			::oWSSPED_ENTIDADE[len(::oWSSPED_ENTIDADE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSPED_GENERICSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_ARRAYOFSPED_GENERICSTRUCT
	WSDATA   oWSSPED_GENERICSTRUCT     AS SPEDADM_SPED_GENERICSTRUCT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_ARRAYOFSPED_GENERICSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_ARRAYOFSPED_GENERICSTRUCT
	::oWSSPED_GENERICSTRUCT := {} // Array Of  SPEDADM_SPED_GENERICSTRUCT():New()
Return

WSMETHOD CLONE WSCLIENT SPEDADM_ARRAYOFSPED_GENERICSTRUCT
	Local oClone := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():NEW()
	oClone:oWSSPED_GENERICSTRUCT := NIL
	If ::oWSSPED_GENERICSTRUCT <> NIL 
		oClone:oWSSPED_GENERICSTRUCT := {}
		aEval( ::oWSSPED_GENERICSTRUCT , { |x| aadd( oClone:oWSSPED_GENERICSTRUCT , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_ARRAYOFSPED_GENERICSTRUCT
	Local cSoap := ""
	aEval( ::oWSSPED_GENERICSTRUCT , {|x| cSoap := cSoap  +  WSSoapValue("SPED_GENERICSTRUCT", x , x , "SPED_GENERICSTRUCT", .F. , .F., 0 , NIL )  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_ENTIDADE
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_SPED_ENTIDADE
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cCEP                      AS string
	WSDATA   cCEP_CP                   AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cCOD_MUN                  AS string
	WSDATA   cCOD_PAIS                 AS string
	WSDATA   cCOMPL                    AS string OPTIONAL
	WSDATA   cCP                       AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDDD                      AS string OPTIONAL
	WSDATA   dDTRE                     AS date OPTIONAL
	WSDATA   cEMAIL                    AS string OPTIONAL
	WSDATA   cENDERECO                 AS string
	WSDATA   cFANTASIA                 AS string OPTIONAL
	WSDATA   cFAX                      AS string OPTIONAL
	WSDATA   cFONE                     AS string OPTIONAL
	WSDATA   cID_MATRIZ                AS string OPTIONAL
	WSDATA   cIE                       AS string OPTIONAL
	WSDATA   cIM                       AS string OPTIONAL
	WSDATA   cINDSITESP                AS string OPTIONAL
	WSDATA   cMUN                      AS string OPTIONAL
	WSDATA   cNIRE                     AS string
	WSDATA   cNIT                      AS string OPTIONAL
	WSDATA   cNOME                     AS string
	WSDATA   cNUM                      AS string OPTIONAL
	WSDATA   cSUFRAMA                  AS string OPTIONAL
	WSDATA   cUF                       AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_SPED_ENTIDADE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_SPED_ENTIDADE
Return

WSMETHOD CLONE WSCLIENT SPEDADM_SPED_ENTIDADE
	Local oClone := SPEDADM_SPED_ENTIDADE():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCEP                 := ::cCEP
	oClone:cCEP_CP              := ::cCEP_CP
	oClone:cCNPJ                := ::cCNPJ
	oClone:cCOD_MUN             := ::cCOD_MUN
	oClone:cCOD_PAIS            := ::cCOD_PAIS
	oClone:cCOMPL               := ::cCOMPL
	oClone:cCP                  := ::cCP
	oClone:cCPF                 := ::cCPF
	oClone:cDDD                 := ::cDDD
	oClone:dDTRE                := ::dDTRE
	oClone:cEMAIL               := ::cEMAIL
	oClone:cENDERECO            := ::cENDERECO
	oClone:cFANTASIA            := ::cFANTASIA
	oClone:cFAX                 := ::cFAX
	oClone:cFONE                := ::cFONE
	oClone:cID_MATRIZ           := ::cID_MATRIZ
	oClone:cIE                  := ::cIE
	oClone:cIM                  := ::cIM
	oClone:cINDSITESP           := ::cINDSITESP
	oClone:cMUN                 := ::cMUN
	oClone:cNIRE                := ::cNIRE
	oClone:cNIT                 := ::cNIT
	oClone:cNOME                := ::cNOME
	oClone:cNUM                 := ::cNUM
	oClone:cSUFRAMA             := ::cSUFRAMA
	oClone:cUF                  := ::cUF
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_SPED_ENTIDADE
	Local cSoap := ""
	cSoap += WSSoapValue("BAIRRO", ::cBAIRRO, ::cBAIRRO , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CEP_CP", ::cCEP_CP, ::cCEP_CP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_MUN", ::cCOD_MUN, ::cCOD_MUN , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COD_PAIS", ::cCOD_PAIS, ::cCOD_PAIS , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("COMPL", ::cCOMPL, ::cCOMPL , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CP", ::cCP, ::cCP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DDD", ::cDDD, ::cDDD , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DTRE", ::dDTRE, ::dDTRE , "date", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("EMAIL", ::cEMAIL, ::cEMAIL , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ENDERECO", ::cENDERECO, ::cENDERECO , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FANTASIA", ::cFANTASIA, ::cFANTASIA , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FAX", ::cFAX, ::cFAX , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("FONE", ::cFONE, ::cFONE , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("ID_MATRIZ", ::cID_MATRIZ, ::cID_MATRIZ , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IE", ::cIE, ::cIE , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("IM", ::cIM, ::cIM , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("INDSITESP", ::cINDSITESP, ::cINDSITESP , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("MUN", ::cMUN, ::cMUN , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NIRE", ::cNIRE, ::cNIRE , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NIT", ::cNIT, ::cNIT , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("NUM", ::cNUM, ::cNUM , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("SUFRAMA", ::cSUFRAMA, ::cSUFRAMA , "string", .F. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("UF", ::cUF, ::cUF , "string", .T. , .F., 0 , NIL ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SPEDADM_SPED_ENTIDADE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,"Property cCEP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCEP_CP            :=  WSAdvValue( oResponse,"_CEP_CP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCOD_MUN           :=  WSAdvValue( oResponse,"_COD_MUN","string",NIL,"Property cCOD_MUN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOD_PAIS          :=  WSAdvValue( oResponse,"_COD_PAIS","string",NIL,"Property cCOD_PAIS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOMPL             :=  WSAdvValue( oResponse,"_COMPL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCP                :=  WSAdvValue( oResponse,"_CP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDD               :=  WSAdvValue( oResponse,"_DDD","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::dDTRE              :=  WSAdvValue( oResponse,"_DTRE","date",NIL,NIL,NIL,"D",NIL,NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cENDERECO          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,"Property cENDERECO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFANTASIA          :=  WSAdvValue( oResponse,"_FANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFAX               :=  WSAdvValue( oResponse,"_FAX","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFONE              :=  WSAdvValue( oResponse,"_FONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cID_MATRIZ         :=  WSAdvValue( oResponse,"_ID_MATRIZ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIE                :=  WSAdvValue( oResponse,"_IE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIM                :=  WSAdvValue( oResponse,"_IM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cINDSITESP         :=  WSAdvValue( oResponse,"_INDSITESP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMUN               :=  WSAdvValue( oResponse,"_MUN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNIRE              :=  WSAdvValue( oResponse,"_NIRE","string",NIL,"Property cNIRE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNIT               :=  WSAdvValue( oResponse,"_NIT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNUM               :=  WSAdvValue( oResponse,"_NUM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSUFRAMA           :=  WSAdvValue( oResponse,"_SUFRAMA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,"Property cUF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure SPED_GENERICSTRUCT
------------------------------------------------------------------------------- */

WSSTRUCT SPEDADM_SPED_GENERICSTRUCT
	WSDATA   cCODE                     AS string
	WSDATA   cDESCRIPTION              AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SPEDADM_SPED_GENERICSTRUCT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SPEDADM_SPED_GENERICSTRUCT
Return

WSMETHOD CLONE WSCLIENT SPEDADM_SPED_GENERICSTRUCT
	Local oClone := SPEDADM_SPED_GENERICSTRUCT():NEW()
	oClone:cCODE                := ::cCODE
	oClone:cDESCRIPTION         := ::cDESCRIPTION
Return oClone

WSMETHOD SOAPSEND WSCLIENT SPEDADM_SPED_GENERICSTRUCT
	Local cSoap := ""
	cSoap += WSSoapValue("CODE", ::cCODE, ::cCODE , "string", .T. , .F., 0 , NIL ) 
	cSoap += WSSoapValue("DESCRIPTION", ::cDESCRIPTION, ::cDESCRIPTION , "string", .T. , .F., 0 , NIL ) 
Return cSoap