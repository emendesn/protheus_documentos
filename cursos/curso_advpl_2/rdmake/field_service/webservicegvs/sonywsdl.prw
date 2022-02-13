//http://www.servicesony.com.br/WSProd/WSServiceOrder.asmx?WSDL
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.servicesony.com.br/WSProd/WSServiceOrder.asmx?WSDL
Gerado em        02/06/15 16:32:54
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _EKZRTSL ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSServiceOrder 
------------------------------------------------------------------------------- */

WSCLIENT WSWSServiceOrder

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Login
	WSMETHOD DataUploadFile
	WSMETHOD DataUpdate

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cASCCode                  AS string
	WSDATA   cPassword                 AS string
	WSDATA   oWSgvsSession             AS WSServiceOrder_TGvsSession
	WSDATA   nLoginResult              AS int
	WSDATA   nHandle                   AS int
	WSDATA   nSeq                      AS int
	WSDATA   cFile                     AS string
	WSDATA   cWCNumber                 AS string
	WSDATA   cType                     AS string
	WSDATA   oWSDataUploadFileResult   AS WSServiceOrder_TDataUploadFileResult
	WSDATA   oWSserviceOrders          AS WSServiceOrder_ArrayOfTServiceOrder
	WSDATA   oWSDataUpdateResult       AS WSServiceOrder_TDataUpdateResult

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSServiceOrder
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20140829] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSServiceOrder
	::oWSgvsSession      := WSServiceOrder_TGVSSESSION():New()
	::oWSDataUploadFileResult := WSServiceOrder_TDATAUPLOADFILERESULT():New()
	::oWSserviceOrders   := WSServiceOrder_ARRAYOFTSERVICEORDER():New()
	::oWSDataUpdateResult := WSServiceOrder_TDATAUPDATERESULT():New()
Return

WSMETHOD RESET WSCLIENT WSWSServiceOrder
	::cASCCode           := NIL 
	::cPassword          := NIL 
	::oWSgvsSession      := NIL 
	::nLoginResult       := NIL 
	::nHandle            := NIL 
	::nSeq               := NIL 
	::cFile              := NIL 
	::cWCNumber          := NIL 
	::cType              := NIL 
	::oWSDataUploadFileResult := NIL 
	::oWSserviceOrders   := NIL 
	::oWSDataUpdateResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSServiceOrder
Local oClone := WSWSServiceOrder():New()
	oClone:_URL          := ::_URL 
	oClone:cASCCode      := ::cASCCode
	oClone:cPassword     := ::cPassword
	oClone:oWSgvsSession :=  IIF(::oWSgvsSession = NIL , NIL ,::oWSgvsSession:Clone() )
	oClone:nLoginResult  := ::nLoginResult
	oClone:nHandle       := ::nHandle
	oClone:nSeq          := ::nSeq
	oClone:cFile         := ::cFile
	oClone:cWCNumber     := ::cWCNumber
	oClone:cType         := ::cType
	oClone:oWSDataUploadFileResult :=  IIF(::oWSDataUploadFileResult = NIL , NIL ,::oWSDataUploadFileResult:Clone() )
	oClone:oWSserviceOrders :=  IIF(::oWSserviceOrders = NIL , NIL ,::oWSserviceOrders:Clone() )
	oClone:oWSDataUpdateResult :=  IIF(::oWSDataUpdateResult = NIL , NIL ,::oWSDataUpdateResult:Clone() )
Return oClone

// WSDL Method Login of Service WSWSServiceOrder

WSMETHOD Login WSSEND cASCCode,cPassword,BYREF oWSgvsSession WSRECEIVE nLoginResult WSCLIENT WSWSServiceOrder
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Login xmlns="http://www.servicesony.com.br/WS/">'
cSoap += WSSoapValue("ASCCode", ::cASCCode, cASCCode , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Password", ::cPassword, cPassword , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("gvsSession", ::oWSgvsSession, oWSgvsSession , "TGvsSession", .F. , .F., 0 , NIL, .F.) 
cSoap += "</Login>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.servicesony.com.br/WS/Login",; 
	"DOCUMENT","http://www.servicesony.com.br/WS/",,,; 
	"http://www.servicesony.com.br/WSProd/WSServiceOrder.asmx")

::Init()
::nLoginResult       :=  WSAdvValue( oXmlRet,"_LOGINRESPONSE:_LOGINRESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 
::oWSgvsSession:SoapRecv( WSAdvValue( oXmlRet,"_LOGINRESPONSE:_GVSSESSION","TGvsSession",NIL,NIL,NIL,NIL,@oWSgvsSession,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DataUploadFile of Service WSWSServiceOrder

WSMETHOD DataUploadFile WSSEND oWSgvsSession,nHandle,nSeq,cFile,cASCCode,cWCNumber,cType WSRECEIVE oWSDataUploadFileResult WSCLIENT WSWSServiceOrder
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DataUploadFile xmlns="http://www.servicesony.com.br/WS/">'
cSoap += WSSoapValue("gvsSession",	::oWSgvsSession,	oWSgvsSession,	"TGvsSession",	.F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Handle",		::nHandle,			nHandle,		"int",			.T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Seq",			::nSeq,				nSeq,			"int",			.T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("File",		::cFile,			cFile,			"string",		.F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ASCCode",		::cASCCode,			cASCCode,		"string",		.F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("WCNumber",	::cWCNumber,		cWCNumber,		"string",		.F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Type",		::cType,			cType,			"string",		.F. , .F., 0 , NIL, .F.) 
cSoap += "</DataUploadFile>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.servicesony.com.br/WS/DataUploadFile",; 
	"DOCUMENT","http://www.servicesony.com.br/WS/",,,; 
	"http://www.servicesony.com.br/WSProd/WSServiceOrder.asmx")

Alert(cSoap)

::Init()
::oWSDataUploadFileResult:SoapRecv( WSAdvValue( oXmlRet,"_DATAUPLOADFILERESPONSE:_DATAUPLOADFILERESULT","TDataUploadFileResult",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DataUpdate of Service WSWSServiceOrder

WSMETHOD DataUpdate WSSEND oWSgvsSession,oWSserviceOrders WSRECEIVE oWSDataUpdateResult WSCLIENT WSWSServiceOrder
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DataUpdate xmlns="http://www.servicesony.com.br/WS/">'
cSoap += WSSoapValue("gvsSession", ::oWSgvsSession, oWSgvsSession , "TGvsSession", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("serviceOrders", ::oWSserviceOrders, oWSserviceOrders , "ArrayOfTServiceOrder", .F. , .F., 0 , NIL, .F.) 
cSoap += "</DataUpdate>"
oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.servicesony.com.br/WS/DataUpdate",; 
	"DOCUMENT","http://www.servicesony.com.br/WS/",,,; 
	"http://www.servicesony.com.br/WSProd/WSServiceOrder.asmx")

::Init()
::oWSDataUpdateResult:SoapRecv( WSAdvValue( oXmlRet,"_DATAUPDATERESPONSE:_DATAUPDATERESULT","TDataUpdateResult",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TGvsSession

WSSTRUCT WSServiceOrder_TGvsSession
	WSDATA   cId                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TGvsSession
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TGvsSession
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TGvsSession
	Local oClone := WSServiceOrder_TGvsSession():NEW()
	oClone:cId                  := ::cId
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TGvsSession
	Local cSoap := ""
	cSoap += WSSoapValue("Id", ::cId, ::cId , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TGvsSession
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cId                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure TDataUploadFileResult

WSSTRUCT WSServiceOrder_TDataUploadFileResult
	WSDATA   nResultCode               AS int
	WSDATA   cResultMsg                AS string OPTIONAL
	WSDATA   nhandle                   AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TDataUploadFileResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TDataUploadFileResult
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TDataUploadFileResult
	Local oClone := WSServiceOrder_TDataUploadFileResult():NEW()
	oClone:nResultCode          := ::nResultCode
	oClone:cResultMsg           := ::cResultMsg
	oClone:nhandle              := ::nhandle
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TDataUploadFileResult
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nResultCode        :=  WSAdvValue( oResponse,"_RESULTCODE","int",NIL,"Property nResultCode as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cResultMsg         :=  WSAdvValue( oResponse,"_RESULTMSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nhandle            :=  WSAdvValue( oResponse,"_HANDLE","int",NIL,"Property nhandle as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure TDataUpdateResult

WSSTRUCT WSServiceOrder_TDataUpdateResult
	WSDATA   nResultCode               AS int
	WSDATA   cResultMsg                AS string OPTIONAL
	WSDATA   oWSserviceOrdersProtocol  AS WSServiceOrder_ArrayOfTServiceOrder OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TDataUpdateResult
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TDataUpdateResult
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TDataUpdateResult
	Local oClone := WSServiceOrder_TDataUpdateResult():NEW()
	oClone:nResultCode          := ::nResultCode
	oClone:cResultMsg           := ::cResultMsg
	oClone:oWSserviceOrdersProtocol := IIF(::oWSserviceOrdersProtocol = NIL , NIL , ::oWSserviceOrdersProtocol:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TDataUpdateResult
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nResultCode        :=  WSAdvValue( oResponse,"_RESULTCODE","int",NIL,"Property nResultCode as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cResultMsg         :=  WSAdvValue( oResponse,"_RESULTMSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_SERVICEORDERSPROTOCOL","ArrayOfTServiceOrder",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSserviceOrdersProtocol := WSServiceOrder_ArrayOfTServiceOrder():New()
		::oWSserviceOrdersProtocol:SoapRecv(oNode3)
	EndIf
Return

// WSDL Data Structure ArrayOfTServiceOrder

WSSTRUCT WSServiceOrder_ArrayOfTServiceOrder
	WSDATA   oWSTServiceOrder          AS WSServiceOrder_TServiceOrder OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_ArrayOfTServiceOrder
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_ArrayOfTServiceOrder
	::oWSTServiceOrder     := {} // Array Of  WSServiceOrder_TSERVICEORDER():New()
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_ArrayOfTServiceOrder
	Local oClone := WSServiceOrder_ArrayOfTServiceOrder():NEW()
	oClone:oWSTServiceOrder := NIL
	If ::oWSTServiceOrder <> NIL 
		oClone:oWSTServiceOrder := {}
		aEval( ::oWSTServiceOrder , { |x| aadd( oClone:oWSTServiceOrder , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_ArrayOfTServiceOrder
	Local cSoap := ""
	aEval( ::oWSTServiceOrder , {|x| cSoap := cSoap  +  WSSoapValue("TServiceOrder", x , x , "TServiceOrder", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_ArrayOfTServiceOrder
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TSERVICEORDER","TServiceOrder",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTServiceOrder , WSServiceOrder_TServiceOrder():New() )
			::oWSTServiceOrder[len(::oWSTServiceOrder)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TServiceOrder

WSSTRUCT WSServiceOrder_TServiceOrder
	WSDATA   cASCCode                  AS string OPTIONAL
	WSDATA   cSONo                     AS string OPTIONAL
	WSDATA   oWSSOInfo                 AS WSServiceOrder_TSOInfo OPTIONAL
	WSDATA   cGvsReadedSignature       AS string OPTIONAL
	WSDATA   nResultCode               AS int
	WSDATA   cResultMsg                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TServiceOrder
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TServiceOrder
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TServiceOrder
	Local oClone := WSServiceOrder_TServiceOrder():NEW()
	oClone:cASCCode             := ::cASCCode
	oClone:cSONo                := ::cSONo
	oClone:oWSSOInfo            := IIF(::oWSSOInfo = NIL , NIL , ::oWSSOInfo:Clone() )
	oClone:cGvsReadedSignature  := ::cGvsReadedSignature
	oClone:nResultCode          := ::nResultCode
	oClone:cResultMsg           := ::cResultMsg
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TServiceOrder
	Local cSoap := ""
	cSoap += WSSoapValue("ASCCode", ::cASCCode, ::cASCCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SONo", ::cSONo, ::cSONo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SOInfo", ::oWSSOInfo, ::oWSSOInfo , "TSOInfo", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("GvsReadedSignature", ::cGvsReadedSignature, ::cGvsReadedSignature , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ResultCode", ::nResultCode, ::nResultCode , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ResultMsg", ::cResultMsg, ::cResultMsg , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TServiceOrder
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cASCCode           :=  WSAdvValue( oResponse,"_ASCCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSONo              :=  WSAdvValue( oResponse,"_SONO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_SOINFO","TSOInfo",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSSOInfo := WSServiceOrder_TSOInfo():New()
		::oWSSOInfo:SoapRecv(oNode3)
	EndIf
	::cGvsReadedSignature :=  WSAdvValue( oResponse,"_GVSREADEDSIGNATURE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nResultCode        :=  WSAdvValue( oResponse,"_RESULTCODE","int",NIL,"Property nResultCode as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cResultMsg         :=  WSAdvValue( oResponse,"_RESULTMSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure TSOInfo

WSSTRUCT WSServiceOrder_TSOInfo
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cOriginASCCode            AS string OPTIONAL
	WSDATA   cOriginASCSONo            AS string OPTIONAL
	WSDATA   cBrandName                AS string OPTIONAL
	WSDATA   cModelCode                AS string OPTIONAL
	WSDATA   cSerialNo                 AS string OPTIONAL
	WSDATA   oWSCustomer               AS WSServiceOrder_TCustomer OPTIONAL
	WSDATA   cSODate                   AS dateTime
	WSDATA   cExpectedRepairDate       AS dateTime
	WSDATA   cOperator                 AS string OPTIONAL
	WSDATA   cRegisteredNo             AS string OPTIONAL
	WSDATA   cCoverCode                AS string OPTIONAL
	WSDATA   cAttendanceSite           AS string OPTIONAL
	WSDATA   cOriginCode               AS string OPTIONAL
	WSDATA   cManufacturerDate         AS string OPTIONAL
	WSDATA   oWSPurchaseData           AS WSServiceOrder_TPurchaseData OPTIONAL
	WSDATA   cServiceTypeCode          AS string OPTIONAL
	WSDATA   cProductFeature           AS string OPTIONAL
	WSDATA   cProductAccessories       AS string OPTIONAL
	WSDATA   cAttendantName            AS string OPTIONAL
	WSDATA   cReceivingDate            AS dateTime
	WSDATA   cReceivingInvoiceNo       AS string OPTIONAL
	WSDATA   cFaultDescription         AS string OPTIONAL
	WSDATA   cProductConditions        AS string OPTIONAL
	WSDATA   cRemarks                  AS string OPTIONAL
	WSDATA   nStep                     AS int
	WSDATA   cSOStatusCode             AS string OPTIONAL
	WSDATA   cSOStatusDate             AS dateTime
	WSDATA   cTechnicalEvaluationDate  AS dateTime
	WSDATA   cRepairDate               AS dateTime
	WSDATA   cFinalInspectionDate      AS dateTime
	WSDATA   cModelOut                 AS string OPTIONAL
	WSDATA   cSerialNoOut              AS string OPTIONAL
	WSDATA   cFeatureOut               AS string OPTIONAL
	WSDATA   cSwapControlNo            AS string OPTIONAL
	WSDATA   cFaultClaimedByCustomer   AS string OPTIONAL
	WSDATA   cFaultEvaluatedByTechnician AS string OPTIONAL
	WSDATA   oWSSymptomsEncoded        AS WSServiceOrder_ArrayOfTSymptomEncoded OPTIONAL
	WSDATA   oWSFaults                 AS WSServiceOrder_ArrayOfTFault OPTIONAL
	WSDATA   oWSDeliveryData           AS WSServiceOrder_TDeliveryData OPTIONAL
	WSDATA   cSwRevision               AS string OPTIONAL
	WSDATA   oWSFollowUp               AS WSServiceOrder_ArrayOfTFollowUp OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TSOInfo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TSOInfo
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TSOInfo
	Local oClone := WSServiceOrder_TSOInfo():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cOriginASCCode       := ::cOriginASCCode
	oClone:cOriginASCSONo       := ::cOriginASCSONo
	oClone:cBrandName           := ::cBrandName
	oClone:cModelCode           := ::cModelCode
	oClone:cSerialNo            := ::cSerialNo
	oClone:oWSCustomer          := IIF(::oWSCustomer = NIL , NIL , ::oWSCustomer:Clone() )
	oClone:cSODate              := ::cSODate
	oClone:cExpectedRepairDate  := ::cExpectedRepairDate
	oClone:cOperator            := ::cOperator
	oClone:cRegisteredNo        := ::cRegisteredNo
	oClone:cCoverCode           := ::cCoverCode
	oClone:cAttendanceSite      := ::cAttendanceSite
	oClone:cOriginCode          := ::cOriginCode
	oClone:cManufacturerDate    := ::cManufacturerDate
	oClone:oWSPurchaseData      := IIF(::oWSPurchaseData = NIL , NIL , ::oWSPurchaseData:Clone() )
	oClone:cServiceTypeCode     := ::cServiceTypeCode
	oClone:cProductFeature      := ::cProductFeature
	oClone:cProductAccessories  := ::cProductAccessories
	oClone:cAttendantName       := ::cAttendantName
	oClone:cReceivingDate       := ::cReceivingDate
	oClone:cReceivingInvoiceNo  := ::cReceivingInvoiceNo
	oClone:cFaultDescription    := ::cFaultDescription
	oClone:cProductConditions   := ::cProductConditions
	oClone:cRemarks             := ::cRemarks
	oClone:nStep                := ::nStep
	oClone:cSOStatusCode        := ::cSOStatusCode
	oClone:cSOStatusDate        := ::cSOStatusDate
	oClone:cTechnicalEvaluationDate := ::cTechnicalEvaluationDate
	oClone:cRepairDate          := ::cRepairDate
	oClone:cFinalInspectionDate := ::cFinalInspectionDate
	oClone:cModelOut            := ::cModelOut
	oClone:cSerialNoOut         := ::cSerialNoOut
	oClone:cFeatureOut          := ::cFeatureOut
	oClone:cSwapControlNo       := ::cSwapControlNo
	oClone:cFaultClaimedByCustomer := ::cFaultClaimedByCustomer
	oClone:cFaultEvaluatedByTechnician := ::cFaultEvaluatedByTechnician
	oClone:oWSSymptomsEncoded   := IIF(::oWSSymptomsEncoded = NIL , NIL , ::oWSSymptomsEncoded:Clone() )
	oClone:oWSFaults            := IIF(::oWSFaults = NIL , NIL , ::oWSFaults:Clone() )
	oClone:oWSDeliveryData      := IIF(::oWSDeliveryData = NIL , NIL , ::oWSDeliveryData:Clone() )
	oClone:cSwRevision          := ::cSwRevision
	oClone:oWSFollowUp          := IIF(::oWSFollowUp = NIL , NIL , ::oWSFollowUp:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TSOInfo
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OriginASCCode", ::cOriginASCCode, ::cOriginASCCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OriginASCSONo", ::cOriginASCSONo, ::cOriginASCSONo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("BrandName", ::cBrandName, ::cBrandName , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ModelCode", ::cModelCode, ::cModelCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SerialNo", ::cSerialNo, ::cSerialNo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Customer", ::oWSCustomer, ::oWSCustomer , "TCustomer", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SODate", ::cSODate, ::cSODate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ExpectedRepairDate", ::cExpectedRepairDate, ::cExpectedRepairDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Operator", ::cOperator, ::cOperator , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("RegisteredNo", ::cRegisteredNo, ::cRegisteredNo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CoverCode", ::cCoverCode, ::cCoverCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AttendanceSite", ::cAttendanceSite, ::cAttendanceSite , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OriginCode", ::cOriginCode, ::cOriginCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ManufacturerDate", ::cManufacturerDate, ::cManufacturerDate , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PurchaseData", ::oWSPurchaseData, ::oWSPurchaseData , "TPurchaseData", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ServiceTypeCode", ::cServiceTypeCode, ::cServiceTypeCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ProductFeature", ::cProductFeature, ::cProductFeature , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ProductAccessories", ::cProductAccessories, ::cProductAccessories , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AttendantName", ::cAttendantName, ::cAttendantName , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ReceivingDate", ::cReceivingDate, ::cReceivingDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ReceivingInvoiceNo", ::cReceivingInvoiceNo, ::cReceivingInvoiceNo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FaultDescription", ::cFaultDescription, ::cFaultDescription , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ProductConditions", ::cProductConditions, ::cProductConditions , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Remarks", ::cRemarks, ::cRemarks , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Step", ::nStep, ::nStep , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SOStatusCode", ::cSOStatusCode, ::cSOStatusCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SOStatusDate", ::cSOStatusDate, ::cSOStatusDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("TechnicalEvaluationDate", ::cTechnicalEvaluationDate, ::cTechnicalEvaluationDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("RepairDate", ::cRepairDate, ::cRepairDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FinalInspectionDate", ::cFinalInspectionDate, ::cFinalInspectionDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ModelOut", ::cModelOut, ::cModelOut , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SerialNoOut", ::cSerialNoOut, ::cSerialNoOut , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FeatureOut", ::cFeatureOut, ::cFeatureOut , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SwapControlNo", ::cSwapControlNo, ::cSwapControlNo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FaultClaimedByCustomer", ::cFaultClaimedByCustomer, ::cFaultClaimedByCustomer , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FaultEvaluatedByTechnician", ::cFaultEvaluatedByTechnician, ::cFaultEvaluatedByTechnician , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SymptomsEncoded", ::oWSSymptomsEncoded, ::oWSSymptomsEncoded , "ArrayOfTSymptomEncoded", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Faults", ::oWSFaults, ::oWSFaults , "ArrayOfTFault", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DeliveryData", ::oWSDeliveryData, ::oWSDeliveryData , "TDeliveryData", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SwRevision", ::cSwRevision, ::cSwRevision , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FollowUp", ::oWSFollowUp, ::oWSFollowUp , "ArrayOfTFollowUp", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TSOInfo
	Local oNode7
	Local oNode16
	Local oNode38
	Local oNode39
	Local oNode40
	Local oNode42
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOriginASCCode     :=  WSAdvValue( oResponse,"_ORIGINASCCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOriginASCSONo     :=  WSAdvValue( oResponse,"_ORIGINASCSONO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBrandName         :=  WSAdvValue( oResponse,"_BRANDNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cModelCode         :=  WSAdvValue( oResponse,"_MODELCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSerialNo          :=  WSAdvValue( oResponse,"_SERIALNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode7 :=  WSAdvValue( oResponse,"_CUSTOMER","TCustomer",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSCustomer := WSServiceOrder_TCustomer():New()
		::oWSCustomer:SoapRecv(oNode7)
	EndIf
	::cSODate            :=  WSAdvValue( oResponse,"_SODATE","dateTime",NIL,"Property cSODate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cExpectedRepairDate :=  WSAdvValue( oResponse,"_EXPECTEDREPAIRDATE","dateTime",NIL,"Property cExpectedRepairDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cOperator          :=  WSAdvValue( oResponse,"_OPERATOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRegisteredNo      :=  WSAdvValue( oResponse,"_REGISTEREDNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCoverCode         :=  WSAdvValue( oResponse,"_COVERCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAttendanceSite    :=  WSAdvValue( oResponse,"_ATTENDANCESITE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOriginCode        :=  WSAdvValue( oResponse,"_ORIGINCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cManufacturerDate  :=  WSAdvValue( oResponse,"_MANUFACTURERDATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode16 :=  WSAdvValue( oResponse,"_PURCHASEDATA","TPurchaseData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSPurchaseData := WSServiceOrder_TPurchaseData():New()
		::oWSPurchaseData:SoapRecv(oNode16)
	EndIf
	::cServiceTypeCode   :=  WSAdvValue( oResponse,"_SERVICETYPECODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProductFeature    :=  WSAdvValue( oResponse,"_PRODUCTFEATURE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProductAccessories :=  WSAdvValue( oResponse,"_PRODUCTACCESSORIES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAttendantName     :=  WSAdvValue( oResponse,"_ATTENDANTNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cReceivingDate     :=  WSAdvValue( oResponse,"_RECEIVINGDATE","dateTime",NIL,"Property cReceivingDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cReceivingInvoiceNo :=  WSAdvValue( oResponse,"_RECEIVINGINVOICENO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFaultDescription  :=  WSAdvValue( oResponse,"_FAULTDESCRIPTION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProductConditions :=  WSAdvValue( oResponse,"_PRODUCTCONDITIONS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRemarks           :=  WSAdvValue( oResponse,"_REMARKS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nStep              :=  WSAdvValue( oResponse,"_STEP","int",NIL,"Property nStep as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cSOStatusCode      :=  WSAdvValue( oResponse,"_SOSTATUSCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSOStatusDate      :=  WSAdvValue( oResponse,"_SOSTATUSDATE","dateTime",NIL,"Property cSOStatusDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTechnicalEvaluationDate :=  WSAdvValue( oResponse,"_TECHNICALEVALUATIONDATE","dateTime",NIL,"Property cTechnicalEvaluationDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cRepairDate        :=  WSAdvValue( oResponse,"_REPAIRDATE","dateTime",NIL,"Property cRepairDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFinalInspectionDate :=  WSAdvValue( oResponse,"_FINALINSPECTIONDATE","dateTime",NIL,"Property cFinalInspectionDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cModelOut          :=  WSAdvValue( oResponse,"_MODELOUT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSerialNoOut       :=  WSAdvValue( oResponse,"_SERIALNOOUT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFeatureOut        :=  WSAdvValue( oResponse,"_FEATUREOUT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSwapControlNo     :=  WSAdvValue( oResponse,"_SWAPCONTROLNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFaultClaimedByCustomer :=  WSAdvValue( oResponse,"_FAULTCLAIMEDBYCUSTOMER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFaultEvaluatedByTechnician :=  WSAdvValue( oResponse,"_FAULTEVALUATEDBYTECHNICIAN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode38 :=  WSAdvValue( oResponse,"_SYMPTOMSENCODED","ArrayOfTSymptomEncoded",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode38 != NIL
		::oWSSymptomsEncoded := WSServiceOrder_ArrayOfTSymptomEncoded():New()
		::oWSSymptomsEncoded:SoapRecv(oNode38)
	EndIf
	oNode39 :=  WSAdvValue( oResponse,"_FAULTS","ArrayOfTFault",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode39 != NIL
		::oWSFaults := WSServiceOrder_ArrayOfTFault():New()
		::oWSFaults:SoapRecv(oNode39)
	EndIf
	oNode40 :=  WSAdvValue( oResponse,"_DELIVERYDATA","TDeliveryData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode40 != NIL
		::oWSDeliveryData := WSServiceOrder_TDeliveryData():New()
		::oWSDeliveryData:SoapRecv(oNode40)
	EndIf
	::cSwRevision        :=  WSAdvValue( oResponse,"_SWREVISION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode42 :=  WSAdvValue( oResponse,"_FOLLOWUP","ArrayOfTFollowUp",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode42 != NIL
		::oWSFollowUp := WSServiceOrder_ArrayOfTFollowUp():New()
		::oWSFollowUp:SoapRecv(oNode42)
	EndIf
Return

// WSDL Data Structure TCustomer

WSSTRUCT WSServiceOrder_TCustomer
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cName                     AS string OPTIONAL
	WSDATA   cTaxId                    AS string OPTIONAL
	WSDATA   cID                       AS string OPTIONAL
	WSDATA   cAddressKind              AS string OPTIONAL
	WSDATA   nAddressNo                AS int
	WSDATA   cAddress1                 AS string OPTIONAL
	WSDATA   cAddress2                 AS string OPTIONAL
	WSDATA   cAddress3                 AS string OPTIONAL
	WSDATA   cCity                     AS string OPTIONAL
	WSDATA   cState                    AS string OPTIONAL
	WSDATA   cZIPCode                  AS string OPTIONAL
	WSDATA   cLocalArea1               AS string OPTIONAL
	WSDATA   cPhone1                   AS string OPTIONAL
	WSDATA   cLocalArea2               AS string OPTIONAL
	WSDATA   cPhone2                   AS string OPTIONAL
	WSDATA   cLocalArea3               AS string OPTIONAL
	WSDATA   cPhone3                   AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cContactName              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TCustomer
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TCustomer
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TCustomer
	Local oClone := WSServiceOrder_TCustomer():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cName                := ::cName
	oClone:cTaxId               := ::cTaxId
	oClone:cID                  := ::cID
	oClone:cAddressKind         := ::cAddressKind
	oClone:nAddressNo           := ::nAddressNo
	oClone:cAddress1            := ::cAddress1
	oClone:cAddress2            := ::cAddress2
	oClone:cAddress3            := ::cAddress3
	oClone:cCity                := ::cCity
	oClone:cState               := ::cState
	oClone:cZIPCode             := ::cZIPCode
	oClone:cLocalArea1          := ::cLocalArea1
	oClone:cPhone1              := ::cPhone1
	oClone:cLocalArea2          := ::cLocalArea2
	oClone:cPhone2              := ::cPhone2
	oClone:cLocalArea3          := ::cLocalArea3
	oClone:cPhone3              := ::cPhone3
	oClone:cEmail               := ::cEmail
	oClone:cContactName         := ::cContactName
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TCustomer
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Name", ::cName, ::cName , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("TaxId", ::cTaxId, ::cTaxId , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ID", ::cID, ::cID , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AddressKind", ::cAddressKind, ::cAddressKind , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AddressNo", ::nAddressNo, ::nAddressNo , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Address1", ::cAddress1, ::cAddress1 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Address2", ::cAddress2, ::cAddress2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Address3", ::cAddress3, ::cAddress3 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("City", ::cCity, ::cCity , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("State", ::cState, ::cState , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ZIPCode", ::cZIPCode, ::cZIPCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("LocalArea1", ::cLocalArea1, ::cLocalArea1 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Phone1", ::cPhone1, ::cPhone1 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("LocalArea2", ::cLocalArea2, ::cLocalArea2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Phone2", ::cPhone2, ::cPhone2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("LocalArea3", ::cLocalArea3, ::cLocalArea3 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Phone3", ::cPhone3, ::cPhone3 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ContactName", ::cContactName, ::cContactName , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TCustomer
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cName              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTaxId             :=  WSAdvValue( oResponse,"_TAXID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cID                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAddressKind       :=  WSAdvValue( oResponse,"_ADDRESSKIND","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nAddressNo         :=  WSAdvValue( oResponse,"_ADDRESSNO","int",NIL,"Property nAddressNo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cAddress1          :=  WSAdvValue( oResponse,"_ADDRESS1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAddress2          :=  WSAdvValue( oResponse,"_ADDRESS2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAddress3          :=  WSAdvValue( oResponse,"_ADDRESS3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCity              :=  WSAdvValue( oResponse,"_CITY","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cState             :=  WSAdvValue( oResponse,"_STATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cZIPCode           :=  WSAdvValue( oResponse,"_ZIPCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocalArea1        :=  WSAdvValue( oResponse,"_LOCALAREA1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPhone1            :=  WSAdvValue( oResponse,"_PHONE1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocalArea2        :=  WSAdvValue( oResponse,"_LOCALAREA2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPhone2            :=  WSAdvValue( oResponse,"_PHONE2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocalArea3        :=  WSAdvValue( oResponse,"_LOCALAREA3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPhone3            :=  WSAdvValue( oResponse,"_PHONE3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContactName       :=  WSAdvValue( oResponse,"_CONTACTNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure TPurchaseData

WSSTRUCT WSServiceOrder_TPurchaseData
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cDate                     AS dateTime
	WSDATA   cSupplierTaxId            AS string OPTIONAL
	WSDATA   cSupplierName             AS string OPTIONAL
	WSDATA   cInvoiceNo                AS string OPTIONAL
	WSDATA   nCost                     AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TPurchaseData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TPurchaseData
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TPurchaseData
	Local oClone := WSServiceOrder_TPurchaseData():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cDate                := ::cDate
	oClone:cSupplierTaxId       := ::cSupplierTaxId
	oClone:cSupplierName        := ::cSupplierName
	oClone:cInvoiceNo           := ::cInvoiceNo
	oClone:nCost                := ::nCost
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TPurchaseData
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Date", ::cDate, ::cDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SupplierTaxId", ::cSupplierTaxId, ::cSupplierTaxId , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SupplierName", ::cSupplierName, ::cSupplierName , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("InvoiceNo", ::cInvoiceNo, ::cInvoiceNo , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Cost", ::nCost, ::nCost , "decimal", .T. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TPurchaseData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDate              :=  WSAdvValue( oResponse,"_DATE","dateTime",NIL,"Property cDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSupplierTaxId     :=  WSAdvValue( oResponse,"_SUPPLIERTAXID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSupplierName      :=  WSAdvValue( oResponse,"_SUPPLIERNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cInvoiceNo         :=  WSAdvValue( oResponse,"_INVOICENO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCost              :=  WSAdvValue( oResponse,"_COST","decimal",NIL,"Property nCost as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfTSymptomEncoded

WSSTRUCT WSServiceOrder_ArrayOfTSymptomEncoded
	WSDATA   oWSTSymptomEncoded        AS WSServiceOrder_TSymptomEncoded OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_ArrayOfTSymptomEncoded
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_ArrayOfTSymptomEncoded
	::oWSTSymptomEncoded   := {} // Array Of  WSServiceOrder_TSYMPTOMENCODED():New()
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_ArrayOfTSymptomEncoded
	Local oClone := WSServiceOrder_ArrayOfTSymptomEncoded():NEW()
	oClone:oWSTSymptomEncoded := NIL
	If ::oWSTSymptomEncoded <> NIL 
		oClone:oWSTSymptomEncoded := {}
		aEval( ::oWSTSymptomEncoded , { |x| aadd( oClone:oWSTSymptomEncoded , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_ArrayOfTSymptomEncoded
	Local cSoap := ""
	aEval( ::oWSTSymptomEncoded , {|x| cSoap := cSoap  +  WSSoapValue("TSymptomEncoded", x , x , "TSymptomEncoded", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_ArrayOfTSymptomEncoded
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TSYMPTOMENCODED","TSymptomEncoded",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTSymptomEncoded , WSServiceOrder_TSymptomEncoded():New() )
			::oWSTSymptomEncoded[len(::oWSTSymptomEncoded)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfTFault

WSSTRUCT WSServiceOrder_ArrayOfTFault
	WSDATA   oWSTFault                 AS WSServiceOrder_TFault OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_ArrayOfTFault
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_ArrayOfTFault
	::oWSTFault            := {} // Array Of  WSServiceOrder_TFAULT():New()
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_ArrayOfTFault
	Local oClone := WSServiceOrder_ArrayOfTFault():NEW()
	oClone:oWSTFault := NIL
	If ::oWSTFault <> NIL 
		oClone:oWSTFault := {}
		aEval( ::oWSTFault , { |x| aadd( oClone:oWSTFault , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_ArrayOfTFault
	Local cSoap := ""
	aEval( ::oWSTFault , {|x| cSoap := cSoap  +  WSSoapValue("TFault", x , x , "TFault", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_ArrayOfTFault
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TFAULT","TFault",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTFault , WSServiceOrder_TFault():New() )
			::oWSTFault[len(::oWSTFault)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TDeliveryData

WSSTRUCT WSServiceOrder_TDeliveryData
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cDate                     AS dateTime
	WSDATA   cAttendantName            AS string OPTIONAL
	WSDATA   nInvoiceNo                AS int
	WSDATA   nInvoiceSeqNo             AS int
	WSDATA   nInvoiceTotalItems        AS int
	WSDATA   cAWB                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TDeliveryData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TDeliveryData
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TDeliveryData
	Local oClone := WSServiceOrder_TDeliveryData():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cDate                := ::cDate
	oClone:cAttendantName       := ::cAttendantName
	oClone:nInvoiceNo           := ::nInvoiceNo
	oClone:nInvoiceSeqNo        := ::nInvoiceSeqNo
	oClone:nInvoiceTotalItems   := ::nInvoiceTotalItems
	oClone:cAWB                 := ::cAWB
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TDeliveryData
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Date", ::cDate, ::cDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AttendantName", ::cAttendantName, ::cAttendantName , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("InvoiceNo", ::nInvoiceNo, ::nInvoiceNo , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("InvoiceSeqNo", ::nInvoiceSeqNo, ::nInvoiceSeqNo , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("InvoiceTotalItems", ::nInvoiceTotalItems, ::nInvoiceTotalItems , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("AWB", ::cAWB, ::cAWB , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TDeliveryData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDate              :=  WSAdvValue( oResponse,"_DATE","dateTime",NIL,"Property cDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cAttendantName     :=  WSAdvValue( oResponse,"_ATTENDANTNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nInvoiceNo         :=  WSAdvValue( oResponse,"_INVOICENO","int",NIL,"Property nInvoiceNo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nInvoiceSeqNo      :=  WSAdvValue( oResponse,"_INVOICESEQNO","int",NIL,"Property nInvoiceSeqNo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nInvoiceTotalItems :=  WSAdvValue( oResponse,"_INVOICETOTALITEMS","int",NIL,"Property nInvoiceTotalItems as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cAWB               :=  WSAdvValue( oResponse,"_AWB","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfTFollowUp

WSSTRUCT WSServiceOrder_ArrayOfTFollowUp
	WSDATA   oWSTFollowUp              AS WSServiceOrder_TFollowUp OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_ArrayOfTFollowUp
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_ArrayOfTFollowUp
	::oWSTFollowUp         := {} // Array Of  WSServiceOrder_TFOLLOWUP():New()
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_ArrayOfTFollowUp
	Local oClone := WSServiceOrder_ArrayOfTFollowUp():NEW()
	oClone:oWSTFollowUp := NIL
	If ::oWSTFollowUp <> NIL 
		oClone:oWSTFollowUp := {}
		aEval( ::oWSTFollowUp , { |x| aadd( oClone:oWSTFollowUp , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_ArrayOfTFollowUp
	Local cSoap := ""
	aEval( ::oWSTFollowUp , {|x| cSoap := cSoap  +  WSSoapValue("TFollowUp", x , x , "TFollowUp", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_ArrayOfTFollowUp
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TFOLLOWUP","TFollowUp",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTFollowUp , WSServiceOrder_TFollowUp():New() )
			::oWSTFollowUp[len(::oWSTFollowUp)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TSymptomEncoded

WSSTRUCT WSServiceOrder_TSymptomEncoded
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   nSeq                      AS int
	WSDATA   cCode                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TSymptomEncoded
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TSymptomEncoded
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TSymptomEncoded
	Local oClone := WSServiceOrder_TSymptomEncoded():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:nSeq                 := ::nSeq
	oClone:cCode                := ::cCode
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TSymptomEncoded
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Seq", ::nSeq, ::nSeq , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Code", ::cCode, ::cCode , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TSymptomEncoded
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nSeq               :=  WSAdvValue( oResponse,"_SEQ","int",NIL,"Property nSeq as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCode              :=  WSAdvValue( oResponse,"_CODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure TFault

WSSTRUCT WSServiceOrder_TFault
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cCode                     AS string OPTIONAL
	WSDATA   cSolutionCode             AS string OPTIONAL
	WSDATA   cPartSessionCode          AS string OPTIONAL
	WSDATA   cSymptomEncodedCode       AS string OPTIONAL
	WSDATA   cFaultCodeReason          AS string OPTIONAL
	WSDATA   cRepairCodeLevel          AS string OPTIONAL
	WSDATA   cGoNoGoFaultCode          AS string OPTIONAL
	WSDATA   oWSPart                   AS WSServiceOrder_ArrayOfTParts OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TFault
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TFault
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TFault
	Local oClone := WSServiceOrder_TFault():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cCode                := ::cCode
	oClone:cSolutionCode        := ::cSolutionCode
	oClone:cPartSessionCode     := ::cPartSessionCode
	oClone:cSymptomEncodedCode  := ::cSymptomEncodedCode
	oClone:cFaultCodeReason     := ::cFaultCodeReason
	oClone:cRepairCodeLevel     := ::cRepairCodeLevel
	oClone:cGoNoGoFaultCode     := ::cGoNoGoFaultCode
	oClone:oWSPart              := IIF(::oWSPart = NIL , NIL , ::oWSPart:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TFault
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Code", ::cCode, ::cCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SolutionCode", ::cSolutionCode, ::cSolutionCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PartSessionCode", ::cPartSessionCode, ::cPartSessionCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SymptomEncodedCode", ::cSymptomEncodedCode, ::cSymptomEncodedCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FaultCodeReason", ::cFaultCodeReason, ::cFaultCodeReason , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("RepairCodeLevel", ::cRepairCodeLevel, ::cRepairCodeLevel , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("GoNoGoFaultCode", ::cGoNoGoFaultCode, ::cGoNoGoFaultCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Part", ::oWSPart, ::oWSPart , "ArrayOfTParts", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TFault
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCode              :=  WSAdvValue( oResponse,"_CODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSolutionCode      :=  WSAdvValue( oResponse,"_SOLUTIONCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPartSessionCode   :=  WSAdvValue( oResponse,"_PARTSESSIONCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSymptomEncodedCode :=  WSAdvValue( oResponse,"_SYMPTOMENCODEDCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFaultCodeReason   :=  WSAdvValue( oResponse,"_FAULTCODEREASON","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRepairCodeLevel   :=  WSAdvValue( oResponse,"_REPAIRCODELEVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cGoNoGoFaultCode   :=  WSAdvValue( oResponse,"_GONOGOFAULTCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode9 :=  WSAdvValue( oResponse,"_PART","ArrayOfTParts",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSPart := WSServiceOrder_ArrayOfTParts():New()
		::oWSPart:SoapRecv(oNode9)
	EndIf
Return

// WSDL Data Structure TFollowUp

WSSTRUCT WSServiceOrder_TFollowUp
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   cDate                     AS dateTime
	WSDATA   nSeqNo                    AS int
	WSDATA   cFollowUp                 AS string OPTIONAL
	WSDATA   cUser                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TFollowUp
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TFollowUp
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TFollowUp
	Local oClone := WSServiceOrder_TFollowUp():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:cDate                := ::cDate
	oClone:nSeqNo               := ::nSeqNo
	oClone:cFollowUp            := ::cFollowUp
	oClone:cUser                := ::cUser
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TFollowUp
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Date", ::cDate, ::cDate , "dateTime", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SeqNo", ::nSeqNo, ::nSeqNo , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FollowUp", ::cFollowUp, ::cFollowUp , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("User", ::cUser, ::cUser , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TFollowUp
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDate              :=  WSAdvValue( oResponse,"_DATE","dateTime",NIL,"Property cDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nSeqNo             :=  WSAdvValue( oResponse,"_SEQNO","int",NIL,"Property nSeqNo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cFollowUp          :=  WSAdvValue( oResponse,"_FOLLOWUP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUser              :=  WSAdvValue( oResponse,"_USER","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfTParts

WSSTRUCT WSServiceOrder_ArrayOfTParts
	WSDATA   oWSTParts                 AS WSServiceOrder_TParts OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_ArrayOfTParts
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_ArrayOfTParts
	::oWSTParts            := {} // Array Of  WSServiceOrder_TPARTS():New()
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_ArrayOfTParts
	Local oClone := WSServiceOrder_ArrayOfTParts():NEW()
	oClone:oWSTParts := NIL
	If ::oWSTParts <> NIL 
		oClone:oWSTParts := {}
		aEval( ::oWSTParts , { |x| aadd( oClone:oWSTParts , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_ArrayOfTParts
	Local cSoap := ""
	aEval( ::oWSTParts , {|x| cSoap := cSoap  +  WSSoapValue("TParts", x , x , "TParts", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_ArrayOfTParts
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TPARTS","TParts",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTParts , WSServiceOrder_TParts():New() )
			::oWSTParts[len(::oWSTParts)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TParts

WSSTRUCT WSServiceOrder_TParts
	WSDATA   cDataVersion              AS string OPTIONAL
	WSDATA   nSeq                      AS int
	WSDATA   cSessionCode              AS string OPTIONAL
	WSDATA   cCode                     AS string OPTIONAL
	WSDATA   nPartQty                  AS int
	WSDATA   cSchemaCode               AS string OPTIONAL
	WSDATA   cPrevCorrect              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSServiceOrder_TParts
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSServiceOrder_TParts
Return

WSMETHOD CLONE WSCLIENT WSServiceOrder_TParts
	Local oClone := WSServiceOrder_TParts():NEW()
	oClone:cDataVersion         := ::cDataVersion
	oClone:nSeq                 := ::nSeq
	oClone:cSessionCode         := ::cSessionCode
	oClone:cCode                := ::cCode
	oClone:nPartQty             := ::nPartQty
	oClone:cSchemaCode          := ::cSchemaCode
	oClone:cPrevCorrect         := ::cPrevCorrect
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSServiceOrder_TParts
	Local cSoap := ""
	cSoap += WSSoapValue("DataVersion", ::cDataVersion, ::cDataVersion , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Seq", ::nSeq, ::nSeq , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SessionCode", ::cSessionCode, ::cSessionCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Code", ::cCode, ::cCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PartQty", ::nPartQty, ::nPartQty , "int", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("SchemaCode", ::cSchemaCode, ::cSchemaCode , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PrevCorrect", ::cPrevCorrect, ::cPrevCorrect , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSServiceOrder_TParts
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataVersion       :=  WSAdvValue( oResponse,"_DATAVERSION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nSeq               :=  WSAdvValue( oResponse,"_SEQ","int",NIL,"Property nSeq as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cSessionCode       :=  WSAdvValue( oResponse,"_SESSIONCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCode              :=  WSAdvValue( oResponse,"_CODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPartQty           :=  WSAdvValue( oResponse,"_PARTQTY","int",NIL,"Property nPartQty as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cSchemaCode        :=  WSAdvValue( oResponse,"_SCHEMACODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPrevCorrect       :=  WSAdvValue( oResponse,"_PREVCORRECT","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return