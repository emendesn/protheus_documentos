#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8080/ws/NFESBRA.apw?WSDL
Gerado em        11/25/08 06:10:19
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.080707
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _DNIQLMN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFESBRA
------------------------------------------------------------------------------- */

WSCLIENT WSNFESBRA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CANCELAFAIXA
	WSMETHOD CANCELANOTAS
	WSMETHOD CONSULTACONTRIBUINTE
	WSMETHOD CONSULTAPROTOCOLONFE
	WSMETHOD ESTATISTICAS
	WSMETHOD MONITORFAIXA
	WSMETHOD MONITORSEFAZ
	WSMETHOD MONITORSEFAZEX
	WSMETHOD MONITORSEFAZMODELO
	WSMETHOD MONITORSTATUSSEFAZ
	WSMETHOD MONITORTEMPO
	WSMETHOD REMESSA
	WSMETHOD RETORNAFAIXA
	WSMETHOD RETORNANOTAS
	WSMETHOD SCHEMA

	WSDATA   _URL                      AS String
	WSDATA   cUSERTOKEN                AS string
	WSDATA   cID_ENT                   AS string
	WSDATA   cIDINICIAL                AS string
	WSDATA   cIDFINAL                  AS string
	WSDATA   oWSCANCELAFAIXARESULT     AS NFESBRA_NFESID
	WSDATA   oWSNFE                    AS NFESBRA_NFE
	WSDATA   oWSCANCELANOTASRESULT     AS NFESBRA_NFESID
	WSDATA   cUF                       AS string
	WSDATA   cCNPJ                     AS string
	WSDATA   cCPF                      AS string
	WSDATA   cIE                       AS string
	WSDATA   oWSCONSULTACONTRIBUINTERESULT AS NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	WSDATA   cNFECONSULTAPROTOCOLOID   AS string
	WSDATA   cCHVNFE                   AS string
	WSDATA   oWSCONSULTAPROTOCOLONFERESULT AS NFESBRA_NFEPROTOCOLOCONSULTA
	WSDATA   dDATAINICIAL              AS date
	WSDATA   dDATAFINAL                AS date
	WSDATA   oWSESTATISTICASRESULT     AS NFESBRA_ARRAYOFESTATISTICANFE
	WSDATA   oWSMONITORFAIXARESULT     AS NFESBRA_ARRAYOFMONITORNFE
	WSDATA   cMONITORSEFAZRESULT       AS string
	WSDATA   oWSMONITORSEFAZEXRESULT   AS NFESBRA_MONITORSTATUSSEFAZ
	WSDATA   oWSMONITORSEFAZMODELORESULT AS NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	WSDATA   oWSMONITORSTATUSSEFAZRESULT AS NFESBRA_ARRAYOFMONITORONLINESEFAZ
	WSDATA   nINTERVALO                AS integer
	WSDATA   oWSMONITORTEMPORESULT     AS NFESBRA_ARRAYOFMONITORNFE
	WSDATA   oWSREMESSARESULT          AS NFESBRA_NFESID
	WSDATA   nDIASPARAEXCLUSAO         AS integer
	WSDATA   dDATADE                   AS date
	WSDATA   dDATAATE                  AS date
	WSDATA   cCNPJDESTINICIAL          AS string
	WSDATA   cCNPJDESTFINAL            AS string
	WSDATA   oWSRETORNAFAIXARESULT     AS NFESBRA_NFE3
	WSDATA   oWSNFEID                  AS NFESBRA_NFES2
	WSDATA   nDANFE                    AS integer
	WSDATA   oWSRETORNANOTASRESULT     AS NFESBRA_NFE3
	WSDATA   oWSSCHEMARESULT           AS NFESBRA_ARRAYOFNFES4

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNFESBRA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080806P-20081023] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFESBRA
	::oWSCANCELAFAIXARESULT := NFESBRA_NFESID():New()
	::oWSNFE             := NFESBRA_NFE():New()
	::oWSCANCELANOTASRESULT := NFESBRA_NFESID():New()
	::oWSCONSULTACONTRIBUINTERESULT := NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE():New()
	::oWSCONSULTAPROTOCOLONFERESULT := NFESBRA_NFEPROTOCOLOCONSULTA():New()
	::oWSESTATISTICASRESULT := NFESBRA_ARRAYOFESTATISTICANFE():New()
	::oWSMONITORFAIXARESULT := NFESBRA_ARRAYOFMONITORNFE():New()
	::oWSMONITORSEFAZEXRESULT := NFESBRA_MONITORSTATUSSEFAZ():New()
	::oWSMONITORSEFAZMODELORESULT := NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO():New()
	::oWSMONITORSTATUSSEFAZRESULT := NFESBRA_ARRAYOFMONITORONLINESEFAZ():New()
	::oWSMONITORTEMPORESULT := NFESBRA_ARRAYOFMONITORNFE():New()
	::oWSREMESSARESULT   := NFESBRA_NFESID():New()
	::oWSRETORNAFAIXARESULT := NFESBRA_NFE3():New()
	::oWSNFEID           := NFESBRA_NFES2():New()
	::oWSRETORNANOTASRESULT := NFESBRA_NFE3():New()
	::oWSSCHEMARESULT    := NFESBRA_ARRAYOFNFES4():New()

Return

WSMETHOD RESET WSCLIENT WSNFESBRA
	::cUSERTOKEN         := NIL 
	::cID_ENT            := NIL 
	::cIDINICIAL         := NIL 
	::cIDFINAL           := NIL 
	::oWSCANCELAFAIXARESULT := NIL 
	::oWSNFE             := NIL 
	::oWSCANCELANOTASRESULT := NIL 
	::cUF                := NIL 
	::cCNPJ              := NIL 
	::cCPF               := NIL 
	::cIE                := NIL 
	::oWSCONSULTACONTRIBUINTERESULT := NIL 
	::cNFECONSULTAPROTOCOLOID := NIL 
	::cCHVNFE            := NIL 
	::oWSCONSULTAPROTOCOLONFERESULT := NIL 
	::dDATAINICIAL       := NIL 
	::dDATAFINAL         := NIL 
	::oWSESTATISTICASRESULT := NIL 
	::oWSMONITORFAIXARESULT := NIL 
	::cMONITORSEFAZRESULT := NIL 
	::oWSMONITORSEFAZEXRESULT := NIL 
	::oWSMONITORSEFAZMODELORESULT := NIL 
	::oWSMONITORSTATUSSEFAZRESULT := NIL 
	::nINTERVALO         := NIL 
	::oWSMONITORTEMPORESULT := NIL 
	::oWSREMESSARESULT   := NIL 
	::nDIASPARAEXCLUSAO  := NIL 
	::dDATADE            := NIL 
	::dDATAATE           := NIL 
	::cCNPJDESTINICIAL   := NIL 
	::cCNPJDESTFINAL     := NIL 
	::oWSRETORNAFAIXARESULT := NIL 
	::oWSNFEID           := NIL 
	::nDANFE             := NIL 
	::oWSRETORNANOTASRESULT := NIL 
	::oWSSCHEMARESULT    := NIL 

	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFESBRA
Local oClone := WSNFESBRA():New()
	oClone:_URL          := ::_URL 
	oClone:cUSERTOKEN    := ::cUSERTOKEN
	oClone:cID_ENT       := ::cID_ENT
	oClone:cIDINICIAL    := ::cIDINICIAL
	oClone:cIDFINAL      := ::cIDFINAL
	oClone:oWSCANCELAFAIXARESULT :=  IIF(::oWSCANCELAFAIXARESULT = NIL , NIL ,::oWSCANCELAFAIXARESULT:Clone() )
	oClone:oWSNFE        :=  IIF(::oWSNFE = NIL , NIL ,::oWSNFE:Clone() )
	oClone:oWSCANCELANOTASRESULT :=  IIF(::oWSCANCELANOTASRESULT = NIL , NIL ,::oWSCANCELANOTASRESULT:Clone() )
	oClone:cUF           := ::cUF
	oClone:cCNPJ         := ::cCNPJ
	oClone:cCPF          := ::cCPF
	oClone:cIE           := ::cIE
	oClone:oWSCONSULTACONTRIBUINTERESULT :=  IIF(::oWSCONSULTACONTRIBUINTERESULT = NIL , NIL ,::oWSCONSULTACONTRIBUINTERESULT:Clone() )
	oClone:cNFECONSULTAPROTOCOLOID := ::cNFECONSULTAPROTOCOLOID
	oClone:cCHVNFE       := ::cCHVNFE
	oClone:oWSCONSULTAPROTOCOLONFERESULT :=  IIF(::oWSCONSULTAPROTOCOLONFERESULT = NIL , NIL ,::oWSCONSULTAPROTOCOLONFERESULT:Clone() )
	oClone:dDATAINICIAL  := ::dDATAINICIAL
	oClone:dDATAFINAL    := ::dDATAFINAL
	oClone:oWSESTATISTICASRESULT :=  IIF(::oWSESTATISTICASRESULT = NIL , NIL ,::oWSESTATISTICASRESULT:Clone() )
	oClone:oWSMONITORFAIXARESULT :=  IIF(::oWSMONITORFAIXARESULT = NIL , NIL ,::oWSMONITORFAIXARESULT:Clone() )
	oClone:cMONITORSEFAZRESULT := ::cMONITORSEFAZRESULT
	oClone:oWSMONITORSEFAZEXRESULT :=  IIF(::oWSMONITORSEFAZEXRESULT = NIL , NIL ,::oWSMONITORSEFAZEXRESULT:Clone() )
	oClone:oWSMONITORSEFAZMODELORESULT :=  IIF(::oWSMONITORSEFAZMODELORESULT = NIL , NIL ,::oWSMONITORSEFAZMODELORESULT:Clone() )
	oClone:oWSMONITORSTATUSSEFAZRESULT :=  IIF(::oWSMONITORSTATUSSEFAZRESULT = NIL , NIL ,::oWSMONITORSTATUSSEFAZRESULT:Clone() )
	oClone:nINTERVALO    := ::nINTERVALO
	oClone:oWSMONITORTEMPORESULT :=  IIF(::oWSMONITORTEMPORESULT = NIL , NIL ,::oWSMONITORTEMPORESULT:Clone() )
	oClone:oWSREMESSARESULT :=  IIF(::oWSREMESSARESULT = NIL , NIL ,::oWSREMESSARESULT:Clone() )
	oClone:nDIASPARAEXCLUSAO := ::nDIASPARAEXCLUSAO
	oClone:dDATADE       := ::dDATADE
	oClone:dDATAATE      := ::dDATAATE
	oClone:cCNPJDESTINICIAL := ::cCNPJDESTINICIAL
	oClone:cCNPJDESTFINAL := ::cCNPJDESTFINAL
	oClone:oWSRETORNAFAIXARESULT :=  IIF(::oWSRETORNAFAIXARESULT = NIL , NIL ,::oWSRETORNAFAIXARESULT:Clone() )
	oClone:oWSNFEID      :=  IIF(::oWSNFEID = NIL , NIL ,::oWSNFEID:Clone() )
	oClone:nDANFE        := ::nDANFE
	oClone:oWSRETORNANOTASRESULT :=  IIF(::oWSRETORNANOTASRESULT = NIL , NIL ,::oWSRETORNANOTASRESULT:Clone() )
	oClone:oWSSCHEMARESULT :=  IIF(::oWSSCHEMARESULT = NIL , NIL ,::oWSSCHEMARESULT:Clone() )

Return oClone

/* -------------------------------------------------------------------------------
WSDL Method CANCELAFAIXA of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD CANCELAFAIXA WSSEND cUSERTOKEN,cID_ENT,cIDINICIAL,cIDFINAL WSRECEIVE oWSCANCELAFAIXARESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CANCELAFAIXA xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDINICIAL", ::cIDINICIAL, cIDINICIAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDFINAL", ::cIDFINAL, cIDFINAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CANCELAFAIXA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/CANCELAFAIXA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSCANCELAFAIXARESULT:SoapRecv( WSAdvValue( oXmlRet,"_CANCELAFAIXARESPONSE:_CANCELAFAIXARESULT","NFESID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CANCELANOTAS of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD CANCELANOTAS WSSEND cUSERTOKEN,cID_ENT,oWSNFE WSRECEIVE oWSCANCELANOTASRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CANCELANOTAS xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFE", ::oWSNFE, oWSNFE , "NFE", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CANCELANOTAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/CANCELANOTAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSCANCELANOTASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CANCELANOTASRESPONSE:_CANCELANOTASRESULT","NFESID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CONSULTACONTRIBUINTE of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD CONSULTACONTRIBUINTE WSSEND cUSERTOKEN,cID_ENT,cUF,cCNPJ,cCPF,cIE WSRECEIVE oWSCONSULTACONTRIBUINTERESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTACONTRIBUINTE xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IE", ::cIE, cIE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTACONTRIBUINTE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/CONSULTACONTRIBUINTE",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSCONSULTACONTRIBUINTERESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTACONTRIBUINTERESPONSE:_CONSULTACONTRIBUINTERESULT","ARRAYOFNFECONSULTACONTRIBUINTE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method CONSULTAPROTOCOLONFE of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD CONSULTAPROTOCOLONFE WSSEND cUSERTOKEN,cID_ENT,cNFECONSULTAPROTOCOLOID,cCHVNFE WSRECEIVE oWSCONSULTAPROTOCOLONFERESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTAPROTOCOLONFE xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFECONSULTAPROTOCOLOID", ::cNFECONSULTAPROTOCOLOID, cNFECONSULTAPROTOCOLOID , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CHVNFE", ::cCHVNFE, cCHVNFE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTAPROTOCOLONFE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/CONSULTAPROTOCOLONFE",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSCONSULTAPROTOCOLONFERESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTAPROTOCOLONFERESPONSE:_CONSULTAPROTOCOLONFERESULT","NFEPROTOCOLOCONSULTA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method ESTATISTICAS of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD ESTATISTICAS WSSEND cUSERTOKEN,cID_ENT,dDATAINICIAL,dDATAFINAL WSRECEIVE oWSESTATISTICASRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ESTATISTICAS xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DATAINICIAL", ::dDATAINICIAL, dDATAINICIAL , "date", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DATAFINAL", ::dDATAFINAL, dDATAFINAL , "date", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ESTATISTICAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/ESTATISTICAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSESTATISTICASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_ESTATISTICASRESPONSE:_ESTATISTICASRESULT","ARRAYOFESTATISTICANFE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORFAIXA of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORFAIXA WSSEND cUSERTOKEN,cID_ENT,cIDINICIAL,cIDFINAL WSRECEIVE oWSMONITORFAIXARESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORFAIXA xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDINICIAL", ::cIDINICIAL, cIDINICIAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDFINAL", ::cIDFINAL, cIDFINAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORFAIXA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORFAIXA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSMONITORFAIXARESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORFAIXARESPONSE:_MONITORFAIXARESULT","ARRAYOFMONITORNFE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORSEFAZ of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORSEFAZ WSSEND cUSERTOKEN,cID_ENT WSRECEIVE cMONITORSEFAZRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORSEFAZ xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORSEFAZ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORSEFAZ",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::cMONITORSEFAZRESULT :=  WSAdvValue( oXmlRet,"_MONITORSEFAZRESPONSE:_MONITORSEFAZRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORSEFAZEX of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORSEFAZEX WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSMONITORSEFAZEXRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORSEFAZEX xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORSEFAZEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORSEFAZEX",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSMONITORSEFAZEXRESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORSEFAZEXRESPONSE:_MONITORSEFAZEXRESULT","MONITORSTATUSSEFAZ",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORSEFAZMODELO of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORSEFAZMODELO WSSEND cUSERTOKEN,cID_ENT WSRECEIVE oWSMONITORSEFAZMODELORESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORSEFAZMODELO xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORSEFAZMODELO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORSEFAZMODELO",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSMONITORSEFAZMODELORESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORSEFAZMODELORESPONSE:_MONITORSEFAZMODELORESULT","ARRAYOFMONITORSTATUSSEFAZMODELO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORSTATUSSEFAZ of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORSTATUSSEFAZ WSSEND cUSERTOKEN WSRECEIVE oWSMONITORSTATUSSEFAZRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORSTATUSSEFAZ xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORSTATUSSEFAZ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORSTATUSSEFAZ",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSMONITORSTATUSSEFAZRESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORSTATUSSEFAZRESPONSE:_MONITORSTATUSSEFAZRESULT","ARRAYOFMONITORONLINESEFAZ",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method MONITORTEMPO of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD MONITORTEMPO WSSEND cUSERTOKEN,cID_ENT,nINTERVALO WSRECEIVE oWSMONITORTEMPORESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MONITORTEMPO xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("INTERVALO", ::nINTERVALO, nINTERVALO , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MONITORTEMPO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/MONITORTEMPO",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSMONITORTEMPORESULT:SoapRecv( WSAdvValue( oXmlRet,"_MONITORTEMPORESPONSE:_MONITORTEMPORESULT","ARRAYOFMONITORNFE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method REMESSA of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD REMESSA WSSEND cUSERTOKEN,cID_ENT,oWSNFE WSRECEIVE oWSREMESSARESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<REMESSA xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFE", ::oWSNFE, oWSNFE , "NFE", .T. , .F., 0 , NIL, .F.) 
cSoap += "</REMESSA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/REMESSA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSREMESSARESULT:SoapRecv( WSAdvValue( oXmlRet,"_REMESSARESPONSE:_REMESSARESULT","NFESID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method RETORNAFAIXA of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD RETORNAFAIXA WSSEND cUSERTOKEN,cID_ENT,cIDINICIAL,cIDFINAL,nDIASPARAEXCLUSAO,dDATADE,dDATAATE,cCNPJDESTINICIAL,cCNPJDESTFINAL WSRECEIVE oWSRETORNAFAIXARESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETORNAFAIXA xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDINICIAL", ::cIDINICIAL, cIDINICIAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDFINAL", ::cIDFINAL, cIDFINAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DIASPARAEXCLUSAO", ::nDIASPARAEXCLUSAO, nDIASPARAEXCLUSAO , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DATADE", ::dDATADE, dDATADE , "date", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DATAATE", ::dDATAATE, dDATAATE , "date", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNPJDESTINICIAL", ::cCNPJDESTINICIAL, cCNPJDESTINICIAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNPJDESTFINAL", ::cCNPJDESTFINAL, cCNPJDESTFINAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</RETORNAFAIXA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/RETORNAFAIXA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSRETORNAFAIXARESULT:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAFAIXARESPONSE:_RETORNAFAIXARESULT","NFE3",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method RETORNANOTAS of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD RETORNANOTAS WSSEND cUSERTOKEN,cID_ENT,oWSNFEID,nDIASPARAEXCLUSAO,nDANFE WSRECEIVE oWSRETORNANOTASRESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETORNANOTAS xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFEID", ::oWSNFEID, oWSNFEID , "NFES2", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DIASPARAEXCLUSAO", ::nDIASPARAEXCLUSAO, nDIASPARAEXCLUSAO , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DANFE", ::nDANFE, nDANFE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += "</RETORNANOTAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/RETORNANOTAS",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSRETORNANOTASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_RETORNANOTASRESPONSE:_RETORNANOTASRESULT","NFE3",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method SCHEMA of Service WSNFESBRA
------------------------------------------------------------------------------- */

WSMETHOD SCHEMA WSSEND cUSERTOKEN,cID_ENT,oWSNFE WSRECEIVE oWSSCHEMARESULT WSCLIENT WSNFESBRA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SCHEMA xmlns="http://webservices.totvs.com.br/nfsebra.apw">'
cSoap += WSSoapValue("USERTOKEN", ::cUSERTOKEN, cUSERTOKEN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ID_ENT", ::cID_ENT, cID_ENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFE", ::oWSNFE, oWSNFE , "NFE", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SCHEMA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/nfsebra.apw/SCHEMA",; 
	"DOCUMENT","http://webservices.totvs.com.br/nfsebra.apw",,"1.031217",; 
	"http://localhost:8080/ws/NFESBRA.apw")

::Init()
::oWSSCHEMARESULT:SoapRecv( WSAdvValue( oXmlRet,"_SCHEMARESPONSE:_SCHEMARESULT","ARRAYOFNFES4",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure NFESID
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFESID
	WSDATA   oWSID                     AS NFESBRA_ARRAYOFSTRING OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFESID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFESID
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFESID
	Local oClone := NFESBRA_NFESID():NEW()
	oClone:oWSID                := IIF(::oWSID = NIL , NIL , ::oWSID:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFESID
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ID","ARRAYOFSTRING",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSID := NFESBRA_ARRAYOFSTRING():New()
		::oWSID:SoapRecv(oNode1)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFE
	WSDATA   oWSNOTAS                  AS NFESBRA_ARRAYOFNFES
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFE
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFE
	Local oClone := NFESBRA_NFE():NEW()
	oClone:oWSNOTAS             := IIF(::oWSNOTAS = NIL , NIL , ::oWSNOTAS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_NFE
	Local cSoap := ""
	cSoap += WSSoapValue("NOTAS", ::oWSNOTAS, ::oWSNOTAS , "ARRAYOFNFES", .T. , .F., 0 , NIL, .F.) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFECONSULTACONTRIBUINTE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	WSDATA   oWSNFECONSULTACONTRIBUINTE AS NFESBRA_NFECONSULTACONTRIBUINTE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	::oWSNFECONSULTACONTRIBUINTE := {} // Array Of  NFESBRA_NFECONSULTACONTRIBUINTE():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	Local oClone := NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE():NEW()
	oClone:oWSNFECONSULTACONTRIBUINTE := NIL
	If ::oWSNFECONSULTACONTRIBUINTE <> NIL 
		oClone:oWSNFECONSULTACONTRIBUINTE := {}
		aEval( ::oWSNFECONSULTACONTRIBUINTE , { |x| aadd( oClone:oWSNFECONSULTACONTRIBUINTE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NFECONSULTACONTRIBUINTE","NFECONSULTACONTRIBUINTE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNFECONSULTACONTRIBUINTE , NFESBRA_NFECONSULTACONTRIBUINTE():New() )
			::oWSNFECONSULTACONTRIBUINTE[len(::oWSNFECONSULTACONTRIBUINTE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFEPROTOCOLOCONSULTA
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFEPROTOCOLOCONSULTA
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   cCODRETNFE                AS string OPTIONAL
	WSDATA   cID                       AS string
	WSDATA   cMSGRETNFE                AS string OPTIONAL
	WSDATA   cPROTOCOLO                AS string OPTIONAL
	WSDATA   dRECBTO                   AS date OPTIONAL
	WSDATA   cVERSAO                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFEPROTOCOLOCONSULTA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFEPROTOCOLOCONSULTA
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFEPROTOCOLOCONSULTA
	Local oClone := NFESBRA_NFEPROTOCOLOCONSULTA():NEW()
	oClone:nAMBIENTE            := ::nAMBIENTE
	oClone:cCODRETNFE           := ::cCODRETNFE
	oClone:cID                  := ::cID
	oClone:cMSGRETNFE           := ::cMSGRETNFE
	oClone:cPROTOCOLO           := ::cPROTOCOLO
	oClone:dRECBTO              := ::dRECBTO
	oClone:cVERSAO              := ::cVERSAO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFEPROTOCOLOCONSULTA
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nAMBIENTE          :=  WSAdvValue( oResponse,"_AMBIENTE","integer",NIL,"Property nAMBIENTE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCODRETNFE         :=  WSAdvValue( oResponse,"_CODRETNFE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMSGRETNFE         :=  WSAdvValue( oResponse,"_MSGRETNFE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPROTOCOLO         :=  WSAdvValue( oResponse,"_PROTOCOLO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::dRECBTO            :=  WSAdvValue( oResponse,"_RECBTO","date",NIL,NIL,NIL,"D",NIL,NIL) 
	::cVERSAO            :=  WSAdvValue( oResponse,"_VERSAO","string",NIL,"Property cVERSAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFESTATISTICANFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFESTATISTICANFE
	WSDATA   oWSESTATISTICANFE         AS NFESBRA_ESTATISTICANFE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFESTATISTICANFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFESTATISTICANFE
	::oWSESTATISTICANFE    := {} // Array Of  NFESBRA_ESTATISTICANFE():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFESTATISTICANFE
	Local oClone := NFESBRA_ARRAYOFESTATISTICANFE():NEW()
	oClone:oWSESTATISTICANFE := NIL
	If ::oWSESTATISTICANFE <> NIL 
		oClone:oWSESTATISTICANFE := {}
		aEval( ::oWSESTATISTICANFE , { |x| aadd( oClone:oWSESTATISTICANFE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFESTATISTICANFE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ESTATISTICANFE","ESTATISTICANFE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSESTATISTICANFE , NFESBRA_ESTATISTICANFE():New() )
			::oWSESTATISTICANFE[len(::oWSESTATISTICANFE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFMONITORNFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFMONITORNFE
	WSDATA   oWSMONITORNFE             AS NFESBRA_MONITORNFE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFMONITORNFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFMONITORNFE
	::oWSMONITORNFE        := {} // Array Of  NFESBRA_MONITORNFE():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFMONITORNFE
	Local oClone := NFESBRA_ARRAYOFMONITORNFE():NEW()
	oClone:oWSMONITORNFE := NIL
	If ::oWSMONITORNFE <> NIL 
		oClone:oWSMONITORNFE := {}
		aEval( ::oWSMONITORNFE , { |x| aadd( oClone:oWSMONITORNFE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFMONITORNFE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MONITORNFE","MONITORNFE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMONITORNFE , NFESBRA_MONITORNFE():New() )
			::oWSMONITORNFE[len(::oWSMONITORNFE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure MONITORSTATUSSEFAZ
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_MONITORSTATUSSEFAZ
	WSDATA   cLOGAUDITORIA             AS string OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cOBSERVACAO               AS string OPTIONAL
	WSDATA   cSTATUSCODIGO             AS string
	WSDATA   cSTATUSMENSAGEM           AS string
	WSDATA   cSUGESTAO                 AS string OPTIONAL
	WSDATA   nTEMPOMEDIOSEF            AS integer OPTIONAL
	WSDATA   cUFORIGEM                 AS string
	WSDATA   cUFRESPOSTA               AS string OPTIONAL
	WSDATA   cVERSAOMENSAGEM           AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_MONITORSTATUSSEFAZ
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_MONITORSTATUSSEFAZ
Return

WSMETHOD CLONE WSCLIENT NFESBRA_MONITORSTATUSSEFAZ
	Local oClone := NFESBRA_MONITORSTATUSSEFAZ():NEW()
	oClone:cLOGAUDITORIA        := ::cLOGAUDITORIA
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cOBSERVACAO          := ::cOBSERVACAO
	oClone:cSTATUSCODIGO        := ::cSTATUSCODIGO
	oClone:cSTATUSMENSAGEM      := ::cSTATUSMENSAGEM
	oClone:cSUGESTAO            := ::cSUGESTAO
	oClone:nTEMPOMEDIOSEF       := ::nTEMPOMEDIOSEF
	oClone:cUFORIGEM            := ::cUFORIGEM
	oClone:cUFRESPOSTA          := ::cUFRESPOSTA
	oClone:cVERSAOMENSAGEM      := ::cVERSAOMENSAGEM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_MONITORSTATUSSEFAZ
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLOGAUDITORIA      :=  WSAdvValue( oResponse,"_LOGAUDITORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMOTIVO            :=  WSAdvValue( oResponse,"_MOTIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOBSERVACAO        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTATUSCODIGO      :=  WSAdvValue( oResponse,"_STATUSCODIGO","string",NIL,"Property cSTATUSCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSTATUSMENSAGEM    :=  WSAdvValue( oResponse,"_STATUSMENSAGEM","string",NIL,"Property cSTATUSMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSUGESTAO          :=  WSAdvValue( oResponse,"_SUGESTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTEMPOMEDIOSEF     :=  WSAdvValue( oResponse,"_TEMPOMEDIOSEF","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cUFORIGEM          :=  WSAdvValue( oResponse,"_UFORIGEM","string",NIL,"Property cUFORIGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUFRESPOSTA        :=  WSAdvValue( oResponse,"_UFRESPOSTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVERSAOMENSAGEM    :=  WSAdvValue( oResponse,"_VERSAOMENSAGEM","string",NIL,"Property cVERSAOMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFMONITORSTATUSSEFAZMODELO
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	WSDATA   oWSMONITORSTATUSSEFAZMODELO AS NFESBRA_MONITORSTATUSSEFAZMODELO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	::oWSMONITORSTATUSSEFAZMODELO := {} // Array Of  NFESBRA_MONITORSTATUSSEFAZMODELO():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	Local oClone := NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO():NEW()
	oClone:oWSMONITORSTATUSSEFAZMODELO := NIL
	If ::oWSMONITORSTATUSSEFAZMODELO <> NIL 
		oClone:oWSMONITORSTATUSSEFAZMODELO := {}
		aEval( ::oWSMONITORSTATUSSEFAZMODELO , { |x| aadd( oClone:oWSMONITORSTATUSSEFAZMODELO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFMONITORSTATUSSEFAZMODELO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MONITORSTATUSSEFAZMODELO","MONITORSTATUSSEFAZMODELO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMONITORSTATUSSEFAZMODELO , NFESBRA_MONITORSTATUSSEFAZMODELO():New() )
			::oWSMONITORSTATUSSEFAZMODELO[len(::oWSMONITORSTATUSSEFAZMODELO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFMONITORONLINESEFAZ
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFMONITORONLINESEFAZ
	WSDATA   oWSMONITORONLINESEFAZ     AS NFESBRA_MONITORONLINESEFAZ OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFMONITORONLINESEFAZ
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFMONITORONLINESEFAZ
	::oWSMONITORONLINESEFAZ := {} // Array Of  NFESBRA_MONITORONLINESEFAZ():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFMONITORONLINESEFAZ
	Local oClone := NFESBRA_ARRAYOFMONITORONLINESEFAZ():NEW()
	oClone:oWSMONITORONLINESEFAZ := NIL
	If ::oWSMONITORONLINESEFAZ <> NIL 
		oClone:oWSMONITORONLINESEFAZ := {}
		aEval( ::oWSMONITORONLINESEFAZ , { |x| aadd( oClone:oWSMONITORONLINESEFAZ , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFMONITORONLINESEFAZ
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MONITORONLINESEFAZ","MONITORONLINESEFAZ",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMONITORONLINESEFAZ , NFESBRA_MONITORONLINESEFAZ():New() )
			::oWSMONITORONLINESEFAZ[len(::oWSMONITORONLINESEFAZ)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFE3
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFE3
	WSDATA   oWSNOTAS                  AS NFESBRA_ARRAYOFNFES3 OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFE3
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFE3
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFE3
	Local oClone := NFESBRA_NFE3():NEW()
	oClone:oWSNOTAS             := IIF(::oWSNOTAS = NIL , NIL , ::oWSNOTAS:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFE3
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_NOTAS","ARRAYOFNFES3",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSNOTAS := NFESBRA_ARRAYOFNFES3():New()
		::oWSNOTAS:SoapRecv(oNode1)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFES2
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFES2
	WSDATA   oWSNOTAS                  AS NFESBRA_ARRAYOFNFESID2
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFES2
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFES2
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFES2
	Local oClone := NFESBRA_NFES2():NEW()
	oClone:oWSNOTAS             := IIF(::oWSNOTAS = NIL , NIL , ::oWSNOTAS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_NFES2
	Local cSoap := ""
	cSoap += WSSoapValue("NOTAS", ::oWSNOTAS, ::oWSNOTAS , "ARRAYOFNFESID2", .T. , .F., 0 , NIL, .F.) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFES4
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFNFES4
	WSDATA   oWSNFES4                  AS NFESBRA_NFES4 OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFNFES4
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFNFES4
	::oWSNFES4             := {} // Array Of  NFESBRA_NFES4():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFNFES4
	Local oClone := NFESBRA_ARRAYOFNFES4():NEW()
	oClone:oWSNFES4 := NIL
	If ::oWSNFES4 <> NIL 
		oClone:oWSNFES4 := {}
		aEval( ::oWSNFES4 , { |x| aadd( oClone:oWSNFES4 , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFNFES4
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NFES4","NFES4",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNFES4 , NFESBRA_NFES4():New() )
			::oWSNFES4[len(::oWSNFES4)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFSTRING
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFSTRING
	WSDATA   cSTRING                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFSTRING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFSTRING
	::cSTRING              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFSTRING
	Local oClone := NFESBRA_ARRAYOFSTRING():NEW()
	oClone:cSTRING              := IIf(::cSTRING <> NIL , aClone(::cSTRING) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFSTRING
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cSTRING ,  x:TEXT  ) } )
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFES
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFNFES
	WSDATA   oWSNFES                   AS NFESBRA_NFES OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFNFES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFNFES
	::oWSNFES              := {} // Array Of  NFESBRA_NFES():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFNFES
	Local oClone := NFESBRA_ARRAYOFNFES():NEW()
	oClone:oWSNFES := NIL
	If ::oWSNFES <> NIL 
		oClone:oWSNFES := {}
		aEval( ::oWSNFES , { |x| aadd( oClone:oWSNFES , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_ARRAYOFNFES
	Local cSoap := ""
	aEval( ::oWSNFES , {|x| cSoap := cSoap  +  WSSoapValue("NFES", x , x , "NFES", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure NFECONSULTACONTRIBUINTE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFECONSULTACONTRIBUINTE
	WSDATA   dBAIXA                    AS date OPTIONAL
	WSDATA   cCNAE                     AS string OPTIONAL
	WSDATA   cCNPJ                     AS string
	WSDATA   cCPF                      AS string
	WSDATA   oWSENDERECO               AS NFESBRA_NFECONSULTACONTRIBUINTEENDERECO OPTIONAL
	WSDATA   cFANTASIA                 AS string OPTIONAL
	WSDATA   cIE                       AS string
	WSDATA   cIEATUAL                  AS string OPTIONAL
	WSDATA   cIEUNICA                  AS string OPTIONAL
	WSDATA   dINICIOATIVIDADE          AS date OPTIONAL
	WSDATA   cRAZAOSOCIAL              AS string
	WSDATA   cREGIMEAPURACAO           AS string OPTIONAL
	WSDATA   cSITUACAO                 AS string
	WSDATA   cUF                       AS string
	WSDATA   dULTIMASITUACAO           AS date OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTE
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTE
	Local oClone := NFESBRA_NFECONSULTACONTRIBUINTE():NEW()
	oClone:dBAIXA               := ::dBAIXA
	oClone:cCNAE                := ::cCNAE
	oClone:cCNPJ                := ::cCNPJ
	oClone:cCPF                 := ::cCPF
	oClone:oWSENDERECO          := IIF(::oWSENDERECO = NIL , NIL , ::oWSENDERECO:Clone() )
	oClone:cFANTASIA            := ::cFANTASIA
	oClone:cIE                  := ::cIE
	oClone:cIEATUAL             := ::cIEATUAL
	oClone:cIEUNICA             := ::cIEUNICA
	oClone:dINICIOATIVIDADE     := ::dINICIOATIVIDADE
	oClone:cRAZAOSOCIAL         := ::cRAZAOSOCIAL
	oClone:cREGIMEAPURACAO      := ::cREGIMEAPURACAO
	oClone:cSITUACAO            := ::cSITUACAO
	oClone:cUF                  := ::cUF
	oClone:dULTIMASITUACAO      := ::dULTIMASITUACAO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTE
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::dBAIXA             :=  WSAdvValue( oResponse,"_BAIXA","date",NIL,NIL,NIL,"D",NIL,NIL) 
	::cCNAE              :=  WSAdvValue( oResponse,"_CNAE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,"Property cCNPJ as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,"Property cCPF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_ENDERECO","NFECONSULTACONTRIBUINTEENDERECO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSENDERECO := NFESBRA_NFECONSULTACONTRIBUINTEENDERECO():New()
		::oWSENDERECO:SoapRecv(oNode5)
	EndIf
	::cFANTASIA          :=  WSAdvValue( oResponse,"_FANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIE                :=  WSAdvValue( oResponse,"_IE","string",NIL,"Property cIE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cIEATUAL           :=  WSAdvValue( oResponse,"_IEATUAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIEUNICA           :=  WSAdvValue( oResponse,"_IEUNICA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::dINICIOATIVIDADE   :=  WSAdvValue( oResponse,"_INICIOATIVIDADE","date",NIL,NIL,NIL,"D",NIL,NIL) 
	::cRAZAOSOCIAL       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,"Property cRAZAOSOCIAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cREGIMEAPURACAO    :=  WSAdvValue( oResponse,"_REGIMEAPURACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSITUACAO          :=  WSAdvValue( oResponse,"_SITUACAO","string",NIL,"Property cSITUACAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,"Property cUF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::dULTIMASITUACAO    :=  WSAdvValue( oResponse,"_ULTIMASITUACAO","date",NIL,NIL,NIL,"D",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ESTATISTICANFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ESTATISTICANFE
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   oWSDETALHE                AS NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	WSDATA   cSERVICO                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ESTATISTICANFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ESTATISTICANFE
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ESTATISTICANFE
	Local oClone := NFESBRA_ESTATISTICANFE():NEW()
	oClone:nAMBIENTE            := ::nAMBIENTE
	oClone:oWSDETALHE           := IIF(::oWSDETALHE = NIL , NIL , ::oWSDETALHE:Clone() )
	oClone:cSERVICO             := ::cSERVICO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ESTATISTICANFE
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nAMBIENTE          :=  WSAdvValue( oResponse,"_AMBIENTE","integer",NIL,"Property nAMBIENTE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_DETALHE","ARRAYOFDETALHEESTATISTICANFESEF",NIL,"Property oWSDETALHE as s0:ARRAYOFDETALHEESTATISTICANFESEF on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSDETALHE := NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF():New()
		::oWSDETALHE:SoapRecv(oNode2)
	EndIf
	::cSERVICO           :=  WSAdvValue( oResponse,"_SERVICO","string",NIL,"Property cSERVICO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure MONITORNFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_MONITORNFE
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   oWSERRO                   AS NFESBRA_ARRAYOFLOTENFE OPTIONAL
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

WSMETHOD NEW WSCLIENT NFESBRA_MONITORNFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_MONITORNFE
Return

WSMETHOD CLONE WSCLIENT NFESBRA_MONITORNFE
	Local oClone := NFESBRA_MONITORNFE():NEW()
	oClone:nAMBIENTE            := ::nAMBIENTE
	oClone:oWSERRO              := IIF(::oWSERRO = NIL , NIL , ::oWSERRO:Clone() )
	oClone:cID                  := ::cID
	oClone:nMODALIDADE          := ::nMODALIDADE
	oClone:cPROTOCOLO           := ::cPROTOCOLO
	oClone:cRECOMENDACAO        := ::cRECOMENDACAO
	oClone:cTEMPODEESPERA       := ::cTEMPODEESPERA
	oClone:nTEMPOMEDIOSEF       := ::nTEMPOMEDIOSEF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_MONITORNFE
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nAMBIENTE          :=  WSAdvValue( oResponse,"_AMBIENTE","integer",NIL,"Property nAMBIENTE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_ERRO","ARRAYOFLOTENFE",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSERRO := NFESBRA_ARRAYOFLOTENFE():New()
		::oWSERRO:SoapRecv(oNode2)
	EndIf
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nMODALIDADE        :=  WSAdvValue( oResponse,"_MODALIDADE","integer",NIL,"Property nMODALIDADE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPROTOCOLO         :=  WSAdvValue( oResponse,"_PROTOCOLO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRECOMENDACAO      :=  WSAdvValue( oResponse,"_RECOMENDACAO","string",NIL,"Property cRECOMENDACAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTEMPODEESPERA     :=  WSAdvValue( oResponse,"_TEMPODEESPERA","string",NIL,"Property cTEMPODEESPERA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nTEMPOMEDIOSEF     :=  WSAdvValue( oResponse,"_TEMPOMEDIOSEF","integer",NIL,"Property nTEMPOMEDIOSEF as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure MONITORSTATUSSEFAZMODELO
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_MONITORSTATUSSEFAZMODELO
	WSDATA   cLOGAUDITORIA             AS string OPTIONAL
	WSDATA   cMODELO                   AS string
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cOBSERVACAO               AS string OPTIONAL
	WSDATA   cSTATUSCODIGO             AS string
	WSDATA   cSTATUSMENSAGEM           AS string
	WSDATA   cSUGESTAO                 AS string OPTIONAL
	WSDATA   nTEMPOMEDIOSEF            AS integer OPTIONAL
	WSDATA   cUFORIGEM                 AS string
	WSDATA   cUFRESPOSTA               AS string OPTIONAL
	WSDATA   cVERSAOMENSAGEM           AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_MONITORSTATUSSEFAZMODELO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_MONITORSTATUSSEFAZMODELO
Return

WSMETHOD CLONE WSCLIENT NFESBRA_MONITORSTATUSSEFAZMODELO
	Local oClone := NFESBRA_MONITORSTATUSSEFAZMODELO():NEW()
	oClone:cLOGAUDITORIA        := ::cLOGAUDITORIA
	oClone:cMODELO              := ::cMODELO
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cOBSERVACAO          := ::cOBSERVACAO
	oClone:cSTATUSCODIGO        := ::cSTATUSCODIGO
	oClone:cSTATUSMENSAGEM      := ::cSTATUSMENSAGEM
	oClone:cSUGESTAO            := ::cSUGESTAO
	oClone:nTEMPOMEDIOSEF       := ::nTEMPOMEDIOSEF
	oClone:cUFORIGEM            := ::cUFORIGEM
	oClone:cUFRESPOSTA          := ::cUFRESPOSTA
	oClone:cVERSAOMENSAGEM      := ::cVERSAOMENSAGEM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_MONITORSTATUSSEFAZMODELO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLOGAUDITORIA      :=  WSAdvValue( oResponse,"_LOGAUDITORIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMODELO            :=  WSAdvValue( oResponse,"_MODELO","string",NIL,"Property cMODELO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMOTIVO            :=  WSAdvValue( oResponse,"_MOTIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOBSERVACAO        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTATUSCODIGO      :=  WSAdvValue( oResponse,"_STATUSCODIGO","string",NIL,"Property cSTATUSCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSTATUSMENSAGEM    :=  WSAdvValue( oResponse,"_STATUSMENSAGEM","string",NIL,"Property cSTATUSMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSUGESTAO          :=  WSAdvValue( oResponse,"_SUGESTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTEMPOMEDIOSEF     :=  WSAdvValue( oResponse,"_TEMPOMEDIOSEF","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cUFORIGEM          :=  WSAdvValue( oResponse,"_UFORIGEM","string",NIL,"Property cUFORIGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUFRESPOSTA        :=  WSAdvValue( oResponse,"_UFRESPOSTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVERSAOMENSAGEM    :=  WSAdvValue( oResponse,"_VERSAOMENSAGEM","string",NIL,"Property cVERSAOMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure MONITORONLINESEFAZ
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_MONITORONLINESEFAZ
	WSDATA   nAMBIENTE                 AS integer
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cOBSERVACAO               AS string OPTIONAL
	WSDATA   cSTATUSCODIGO             AS string
	WSDATA   cSTATUSMENSAGEM           AS string
	WSDATA   cSUGESTAO                 AS string OPTIONAL
	WSDATA   nTEMPOMEDIOSEF            AS integer OPTIONAL
	WSDATA   cUFORIGEM                 AS string
	WSDATA   cUFRESPOSTA               AS string OPTIONAL
	WSDATA   cVERSAOMENSAGEM           AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_MONITORONLINESEFAZ
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_MONITORONLINESEFAZ
Return

WSMETHOD CLONE WSCLIENT NFESBRA_MONITORONLINESEFAZ
	Local oClone := NFESBRA_MONITORONLINESEFAZ():NEW()
	oClone:nAMBIENTE            := ::nAMBIENTE
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cOBSERVACAO          := ::cOBSERVACAO
	oClone:cSTATUSCODIGO        := ::cSTATUSCODIGO
	oClone:cSTATUSMENSAGEM      := ::cSTATUSMENSAGEM
	oClone:cSUGESTAO            := ::cSUGESTAO
	oClone:nTEMPOMEDIOSEF       := ::nTEMPOMEDIOSEF
	oClone:cUFORIGEM            := ::cUFORIGEM
	oClone:cUFRESPOSTA          := ::cUFRESPOSTA
	oClone:cVERSAOMENSAGEM      := ::cVERSAOMENSAGEM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_MONITORONLINESEFAZ
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nAMBIENTE          :=  WSAdvValue( oResponse,"_AMBIENTE","integer",NIL,"Property nAMBIENTE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cMOTIVO            :=  WSAdvValue( oResponse,"_MOTIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOBSERVACAO        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTATUSCODIGO      :=  WSAdvValue( oResponse,"_STATUSCODIGO","string",NIL,"Property cSTATUSCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSTATUSMENSAGEM    :=  WSAdvValue( oResponse,"_STATUSMENSAGEM","string",NIL,"Property cSTATUSMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSUGESTAO          :=  WSAdvValue( oResponse,"_SUGESTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTEMPOMEDIOSEF     :=  WSAdvValue( oResponse,"_TEMPOMEDIOSEF","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cUFORIGEM          :=  WSAdvValue( oResponse,"_UFORIGEM","string",NIL,"Property cUFORIGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUFRESPOSTA        :=  WSAdvValue( oResponse,"_UFRESPOSTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVERSAOMENSAGEM    :=  WSAdvValue( oResponse,"_VERSAOMENSAGEM","string",NIL,"Property cVERSAOMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFES3
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFNFES3
	WSDATA   oWSNFES3                  AS NFESBRA_NFES3 OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFNFES3
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFNFES3
	::oWSNFES3             := {} // Array Of  NFESBRA_NFES3():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFNFES3
	Local oClone := NFESBRA_ARRAYOFNFES3():NEW()
	oClone:oWSNFES3 := NIL
	If ::oWSNFES3 <> NIL 
		oClone:oWSNFES3 := {}
		aEval( ::oWSNFES3 , { |x| aadd( oClone:oWSNFES3 , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFNFES3
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NFES3","NFES3",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNFES3 , NFESBRA_NFES3():New() )
			::oWSNFES3[len(::oWSNFES3)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFNFESID2
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFNFESID2
	WSDATA   oWSNFESID2                AS NFESBRA_NFESID2 OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFNFESID2
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFNFESID2
	::oWSNFESID2           := {} // Array Of  NFESBRA_NFESID2():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFNFESID2
	Local oClone := NFESBRA_ARRAYOFNFESID2():NEW()
	oClone:oWSNFESID2 := NIL
	If ::oWSNFESID2 <> NIL 
		oClone:oWSNFESID2 := {}
		aEval( ::oWSNFESID2 , { |x| aadd( oClone:oWSNFESID2 , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_ARRAYOFNFESID2
	Local cSoap := ""
	aEval( ::oWSNFESID2 , {|x| cSoap := cSoap  +  WSSoapValue("NFESID2", x , x , "NFESID2", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure NFES4
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFES4
	WSDATA   cID                       AS string
	WSDATA   cMENSAGEM                 AS string OPTIONAL
	WSDATA   cXML                      AS base64binary
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFES4
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFES4
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFES4
	Local oClone := NFESBRA_NFES4():NEW()
	oClone:cID                  := ::cID
	oClone:cMENSAGEM            := ::cMENSAGEM
	oClone:cXML                 := ::cXML
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFES4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMENSAGEM          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cXML               :=  WSAdvValue( oResponse,"_XML","base64binary",NIL,"Property cXML as s:base64binary on SOAP Response not found.",NIL,"SB",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFES
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFES
	WSDATA   cID                       AS string
	WSDATA   cXML                      AS base64binary
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFES
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFES
	Local oClone := NFESBRA_NFES():NEW()
	oClone:cID                  := ::cID
	oClone:cXML                 := ::cXML
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_NFES
	Local cSoap := ""
	cSoap += WSSoapValue("ID", ::cID, ::cID , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XML", ::cXML, ::cXML , "base64binary", .T. , .F., 0 , NIL, .F.) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure NFECONSULTACONTRIBUINTEENDERECO
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFECONSULTACONTRIBUINTEENDERECO
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cCODIGOMUNICIPIO          AS string OPTIONAL
	WSDATA   cCOMPLEMENTO              AS string OPTIONAL
	WSDATA   cLOGRADOURO               AS string OPTIONAL
	WSDATA   cMUNICIPIO                AS string OPTIONAL
	WSDATA   cNUMERO                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTEENDERECO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTEENDERECO
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTEENDERECO
	Local oClone := NFESBRA_NFECONSULTACONTRIBUINTEENDERECO():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCEP                 := ::cCEP
	oClone:cCODIGOMUNICIPIO     := ::cCODIGOMUNICIPIO
	oClone:cCOMPLEMENTO         := ::cCOMPLEMENTO
	oClone:cLOGRADOURO          := ::cLOGRADOURO
	oClone:cMUNICIPIO           := ::cMUNICIPIO
	oClone:cNUMERO              := ::cNUMERO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFECONSULTACONTRIBUINTEENDERECO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCODIGOMUNICIPIO   :=  WSAdvValue( oResponse,"_CODIGOMUNICIPIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCOMPLEMENTO       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLOGRADOURO        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMUNICIPIO         :=  WSAdvValue( oResponse,"_MUNICIPIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNUMERO            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFDETALHEESTATISTICANFESEF
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	WSDATA   oWSDETALHEESTATISTICANFESEF AS NFESBRA_DETALHEESTATISTICANFESEF OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	::oWSDETALHEESTATISTICANFESEF := {} // Array Of  NFESBRA_DETALHEESTATISTICANFESEF():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	Local oClone := NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF():NEW()
	oClone:oWSDETALHEESTATISTICANFESEF := NIL
	If ::oWSDETALHEESTATISTICANFESEF <> NIL 
		oClone:oWSDETALHEESTATISTICANFESEF := {}
		aEval( ::oWSDETALHEESTATISTICANFESEF , { |x| aadd( oClone:oWSDETALHEESTATISTICANFESEF , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFDETALHEESTATISTICANFESEF
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DETALHEESTATISTICANFESEF","DETALHEESTATISTICANFESEF",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDETALHEESTATISTICANFESEF , NFESBRA_DETALHEESTATISTICANFESEF():New() )
			::oWSDETALHEESTATISTICANFESEF[len(::oWSDETALHEESTATISTICANFESEF)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure ARRAYOFLOTENFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_ARRAYOFLOTENFE
	WSDATA   oWSLOTENFE                AS NFESBRA_LOTENFE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_ARRAYOFLOTENFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_ARRAYOFLOTENFE
	::oWSLOTENFE           := {} // Array Of  NFESBRA_LOTENFE():New()
Return

WSMETHOD CLONE WSCLIENT NFESBRA_ARRAYOFLOTENFE
	Local oClone := NFESBRA_ARRAYOFLOTENFE():NEW()
	oClone:oWSLOTENFE := NIL
	If ::oWSLOTENFE <> NIL 
		oClone:oWSLOTENFE := {}
		aEval( ::oWSLOTENFE , { |x| aadd( oClone:oWSLOTENFE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_ARRAYOFLOTENFE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LOTENFE","LOTENFE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSLOTENFE , NFESBRA_LOTENFE():New() )
			::oWSLOTENFE[len(::oWSLOTENFE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFES3
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFES3
	WSDATA   cID                       AS string
	WSDATA   oWSNFE                    AS NFESBRA_NFEPROTOCOLO
	WSDATA   oWSNFECANCELADA           AS NFESBRA_NFEPROTOCOLO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFES3
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFES3
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFES3
	Local oClone := NFESBRA_NFES3():NEW()
	oClone:cID                  := ::cID
	oClone:oWSNFE               := IIF(::oWSNFE = NIL , NIL , ::oWSNFE:Clone() )
	oClone:oWSNFECANCELADA      := IIF(::oWSNFECANCELADA = NIL , NIL , ::oWSNFECANCELADA:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFES3
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,"Property cID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_NFE","NFEPROTOCOLO",NIL,"Property oWSNFE as s0:NFEPROTOCOLO on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSNFE := NFESBRA_NFEPROTOCOLO():New()
		::oWSNFE:SoapRecv(oNode2)
	EndIf
	oNode3 :=  WSAdvValue( oResponse,"_NFECANCELADA","NFEPROTOCOLO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSNFECANCELADA := NFESBRA_NFEPROTOCOLO():New()
		::oWSNFECANCELADA:SoapRecv(oNode3)
	EndIf
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFESID2
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFESID2
	WSDATA   cID                       AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFESID2
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFESID2
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFESID2
	Local oClone := NFESBRA_NFESID2():NEW()
	oClone:cID                  := ::cID
Return oClone

WSMETHOD SOAPSEND WSCLIENT NFESBRA_NFESID2
	Local cSoap := ""
	cSoap += WSSoapValue("ID", ::cID, ::cID , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

/* -------------------------------------------------------------------------------
WSDL Data Structure DETALHEESTATISTICANFESEF
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_DETALHEESTATISTICANFESEF
	WSDATA   cCODMSGSEF                AS string
	WSDATA   cMENSAGEM                 AS string
	WSDATA   nQUANTIDADE               AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_DETALHEESTATISTICANFESEF
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_DETALHEESTATISTICANFESEF
Return

WSMETHOD CLONE WSCLIENT NFESBRA_DETALHEESTATISTICANFESEF
	Local oClone := NFESBRA_DETALHEESTATISTICANFESEF():NEW()
	oClone:cCODMSGSEF           := ::cCODMSGSEF
	oClone:cMENSAGEM            := ::cMENSAGEM
	oClone:nQUANTIDADE          := ::nQUANTIDADE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_DETALHEESTATISTICANFESEF
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODMSGSEF         :=  WSAdvValue( oResponse,"_CODMSGSEF","string",NIL,"Property cCODMSGSEF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMENSAGEM          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,"Property cMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nQUANTIDADE        :=  WSAdvValue( oResponse,"_QUANTIDADE","integer",NIL,"Property nQUANTIDADE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure LOTENFE
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_LOTENFE
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

WSMETHOD NEW WSCLIENT NFESBRA_LOTENFE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_LOTENFE
Return

WSMETHOD CLONE WSCLIENT NFESBRA_LOTENFE
	Local oClone := NFESBRA_LOTENFE():NEW()
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

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_LOTENFE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODENVLOTE        :=  WSAdvValue( oResponse,"_CODENVLOTE","string",NIL,"Property cCODENVLOTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCODRETNFE         :=  WSAdvValue( oResponse,"_CODRETNFE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCODRETRECIBO      :=  WSAdvValue( oResponse,"_CODRETRECIBO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::dDATALOTE          :=  WSAdvValue( oResponse,"_DATALOTE","date",NIL,"Property dDATALOTE as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::cHORALOTE          :=  WSAdvValue( oResponse,"_HORALOTE","string",NIL,"Property cHORALOTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nLOTE              :=  WSAdvValue( oResponse,"_LOTE","integer",NIL,"Property nLOTE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cMSGENVLOTE        :=  WSAdvValue( oResponse,"_MSGENVLOTE","string",NIL,"Property cMSGENVLOTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMSGRETNFE         :=  WSAdvValue( oResponse,"_MSGRETNFE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMSGRETRECIBO      :=  WSAdvValue( oResponse,"_MSGRETRECIBO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nRECIBOSEFAZ       :=  WSAdvValue( oResponse,"_RECIBOSEFAZ","integer",NIL,"Property nRECIBOSEFAZ as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

/* -------------------------------------------------------------------------------
WSDL Data Structure NFEPROTOCOLO
------------------------------------------------------------------------------- */

WSSTRUCT NFESBRA_NFEPROTOCOLO
	WSDATA   cPROTOCOLO                AS string OPTIONAL
	WSDATA   cXML                      AS string
	WSDATA   cXMLPROT                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFESBRA_NFEPROTOCOLO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFESBRA_NFEPROTOCOLO
Return

WSMETHOD CLONE WSCLIENT NFESBRA_NFEPROTOCOLO
	Local oClone := NFESBRA_NFEPROTOCOLO():NEW()
	oClone:cPROTOCOLO           := ::cPROTOCOLO
	oClone:cXML                 := ::cXML
	oClone:cXMLPROT             := ::cXMLPROT
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFESBRA_NFEPROTOCOLO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cPROTOCOLO         :=  WSAdvValue( oResponse,"_PROTOCOLO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cXML               :=  WSAdvValue( oResponse,"_XML","string",NIL,"Property cXML as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cXMLPROT           :=  WSAdvValue( oResponse,"_XMLPROT","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return
