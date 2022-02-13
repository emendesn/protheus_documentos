'#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSOAM01   บAutor  ณEduardo Nakamatu    บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInterface Soa para webservice cliente                       บฑฑ
ฑฑบ          ณ- Integracao Ordem Servico Sony-Ericsson                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function JOBSONY(aParam)
//Local cHist := ""
Local cArq  := DTOS(DATE())+"-"+SubSTR(TIME(),1,2)+SubSTR(TIME(),1,2)+".TXT"
Private nRegI := 0  // inclusoes na base
Private nRegA := 0  // altera็oes na base
Private nRegE := 0  // envio de dados

default aParam := {'02','02'}

//u_GerA0003(ProcName())
//ConOut("***********************************************")
//ConOut("|||||***** iniciando   processo sony *****|||||")
//ConOut("|||||***** "+Dtoc(date())+" "+time()+" *****|||||")
//ConOut("***********************************************")
//cHist += Replicate("=",50)+CRLF
//cHist += "   [JOBSONY] Iniciando   INTWGVS "+DTOC(DATE())+" "+TIME()+CRLF
U_INTWGVS(@nRegI,@nRegA,aParam)
//cHist += "   [JOBSONY] Finalizando INTWGVS "+DTOC(DATE())+" "+TIME()+CRLF
SLEEP(180)
//cHist += "   [JOBSONY] Iniciando   RSOAM01 "+DTOC(DATE())+" "+TIME()+CRLF
/*
For i:=1 to 50
	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
	U_RSOAM01(@nRegE)
Next
*/
U_RSOAM01(@nRegE)

//cHist += "   [JOBSONY] Finalizando RSOAM01 "+DTOC(DATE())+" "+TIME()+CRLF
//cHist += "   [JOBSONY] ZZ8 Inclusao : "+STRZERO(nRegI,6)+CRLF
//cHist += "   [JOBSONY] ZZ8 Alteracao: "+STRZERO(nRegA,6)+CRLF
//cHist += "   [JOBSONY] ZZ8 Envio    : "+STRZERO(nRegE,6)+CRLF
//cHist += Replicate("=",50)+CRLF
//ConOut("***********************************************")
//ConOut("|||||***** finalizando processo sony *****|||||")
//ConOut("|||||***** "+Dtoc(date())+" "+time()+" *****|||||")
//ConOut("***********************************************")
//ccc()
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณRSOAM01   บAutor  ณ                          บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RSOAM01(nRegE)
Local cMsgEmail := ""
Local nContEmail := 0
Default nRegE := 0
WSDLDbgLevel(2)
Sleep(120)
//ConOut(Replicate("=",50))
//ConOut(Replicate("=",50))
//ConOut(Replicate("=",50))
//ConOut("   ||-----| [SONY-INICIO] "+DTOC(DATE())+" "+Time())
//ConOut("   ||-----| [SONY]   Iniciando trabalho webservice client...")
//ConOut("   ||-----| [SONY]   PREPARANDO ENVIROMENT 02/02")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveis.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Dados dos Objetos de Conexao
Private oSoa
Private oSession
Private oCopia
Private nResult := 0
Private lResult := .F.
Private cQry := ""
Private aStru := {}
Private nQtdOS := 0
Private aUpdate := {}
Private aReturn := {}
Private cIDACOM, cDTACOM, cSEQACO, cACOMPA,cUSERAC
Private cIDEXPE, cDTEXPE, cATEENT, nNFSAID, nITEMNF,nTOTINF, cAWB
Private cIDPECA,cSEQPEC, cCGRSO2, cCODPEC, cPECQTD, cPOSPEC, cPREVPC
Private cIDSINT, cCODDEF, cCODSOL, cCGRPSO, cSINREC, cMOTDEV, cNIVREP, cFGONGO, aFParts
Private cIDFALH, cSEQSIN, cSINTCO
Private cIDNFCO, cDTNFCO, cNOMREV, cCNPJRE, cNFCOMP, cVLRNFC
Private cIDCLIE, cNOME, cCGC, cINSCR, cEND, cNUMERO, cENDERECO, cCOMPLEMENTO
Private cBAIRRO, cMUN, cEST, cCEP, cDDD, cTEL, cDDD2, cTEL2
Private cDDD3, cTEL3, cEMAIL, cNREDUZ
Private coSession, cIDOS, cCODAT, cMARCA, cMODPRO, cIMEI, cDTOS, cOPERAD, cNUMCEL
Private cDPYNUM, cCODCOB, cLOCATE, cPROCPR, cDTFABR, aSPurchaseData , cCODSER, cATNAME
Private cNFENTR, cDTRECE, aSCustomer , cDTPREV, cACESSO, cDEFCON, cESTAPA, cDTAVAL
Private cSFTREV, cDTREPA, cOBSREP, cETAPOS, cCODSOS, cDTSTOS, cCODMNV, cIMEINV, cDPYIMN
Private cCTROCA, cDEFREC, cSINTAV, cDTINSF, aSSymptomEncod, aFParts,aSDeliveryData ,aSFollowUp
Private cCODPOS, cNUMOS, cNUMOS_O, aOInfo,cRESCOD, cRCODOS ,aServOrder, cRMSGOS, cRESMSG
Private cSTACOM, cSTAPUR, cSTASYM, cSTAFAU, cSTADEL,cSTACLI,cSTPECA
Private n1,nDivi, lSonyMRC
Private cRet1,  cRet2, cRet3, cRet4, cRet5
Private cInfo1, cInfo2
Private _lcep:=.f.
Private _nRegZZ8 := 0
*
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga de dados para Objeto.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ConOut("   ||-----| ")
//ConOut("   ||-----|  Carga de dados do objeto...CARGADBX()")
CargaDBXX()  // vendo base de dados, executando query
//ConOut("   ||-----| AREADB(): "+STRZERO(SELECT("TMP"),5))
*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariavel declarada para auxiolio nos trabalhos de erro da lib.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public cID := ""
*
dbSelectArea("TMP")
dbGoTop()
While TMP->(!Eof())
	If nQtdOS = 0
		//ConOut("   ||-----| ")
		//ConOut("   ||-----| Conectando ...:http://www.sesms.com.br/prod/WS/...")
		//ConOut("   ||-----| ")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDefinindo objeto principal, que ficara com a conexao ativa.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oSoa:= WSWSServiceOrder():New()
		oSoa:cASCCode  := "0000057685"
		oSoa:cPassword := "X7F6H8"
		//ConOut("   ||-----|=========================================================== ")
		//ConOut("   ||-----|=========================================================== ")
		//ConOut("   ||-----|=========================================================== ")
		//ConOut("   ||-----| "+Time())
		//ConOut("   ||-----| Methodo Login() - ANALISE")
		oSoa:Login()
		cGVS := oSoa:oWSgvsSession:cID
		cID := cGVS
		If cID = Nil
			If nContEmail >= 100
				cMsgEmail := '<p><font face="Courier New" size="4" color="#4F81BD">Caros,<br /><br />'
				cMsgEmail += 'O Acesso ao m&eacute;todo Login do WebService WSServiceOrder n&atilde;o esta retornando se&ccedil;&atilde;o.<br />'
				cMsgEmail += 'Solicita&ccedil;&atilde;o efetuada em <strong>'
				cMsgEmail += DTOC(dDataBase)
				cMsgEmail += '</strong> &agrave;s <strong>'
				cMsgEmail += Time()
				cMsgEmail += '</strong>.<br />'
				cMsgEmail += 'Pe&ccedil;o que verifiquem.<br /><br />'
				cMsgEmail += 'No aguardo.</p>'
				U_ENVIAEMAIL("WSServiceOrder.asmx: Problemas comunica็ใo","erro.gvs@bgh.com.br","",cMsgEmail,"")
				nContEmail := 0
				Sleep(60000)
			Else
				nContEmail += 1
			EndIf
			Loop
		EndIf
	EndIf
	nQtdOS++
	CargaVar() // executa a carga das memvars do registro posicionado
	//ConOut("   ||-----|| CARGA DE DADOS WS: "+STRZERO(nQtdOS,6))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefinindo Objetos.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*
	oDelivery := WSServiceOrder_TDeliveryData():New()
	oDelivery:cDataVersion       := cIDEXPE
	oDelivery:cDate              := cDTEXPE
	oDelivery:cAttendantName     := cATEENT
	oDelivery:nInvoiceNo         := nNFSAID
	oDelivery:nInvoiceSeqNo      := nITEMNF
	oDelivery:nInvoiceTotalItems := nTOTINF
	oDelivery:cAWB               := cAWB
	*
	oPurchase := WSServiceOrder_TPurchaseData():New()
	oPurchase:cDataVersion   := cIDNFCO
	oPurchase:cDate          := cDTNFCO
	oPurchase:cSupplierName  := cNOMREV
	oPurchase:cSupplierTaxId := cCNPJRE
	oPurchase:cInvoiceNo     := cNFCOMP
	oPurchase:nCost          := cVLRNFC
	*
	oCustomer := WSServiceOrder_TCustomer():New()
	oCustomer:cDataVersion := AllTrim(cIDCLIE)
	oCustomer:cName        := cNOME
	oCustomer:cTaxId       := cCGC
	oCustomer:cID          := cINSCR
	oCustomer:cAddressKind := cEND
	oCustomer:nAddressNo   := cNUMERO
	oCustomer:cAddress1    := cENDERECO
	oCustomer:cAddress2    := cCOMPLEMENTO
	oCustomer:cAddress3    := cBAIRRO
	oCustomer:cCity        := cMUN
	oCustomer:cState       := cEST
	oCustomer:cZIPCode     := cCEP
	oCustomer:cLocalArea1  := cDDD
	oCustomer:cPhone1      := cTEL
	oCustomer:cLocalArea2  := cDDD2
	oCustomer:cPhone2      := cTEL2
	oCustomer:cLocalArea3  := cDDD3
	oCustomer:cPhone3      := cTEL3
	oCustomer:cEmail       := cEMAIL
	oCustomer:cContactName := cNREDUZ
	*
	oInfo:= WSServiceOrder_TSOInfo():New()
	oInfo:cDataVersion              := AllTrim(cIDOS)
	oInfo:cOriginASCCode            := cCODAT

	oInfo:cBrandName                := cMARCA
	oInfo:cModelCode                := cMODPRO
	oInfo:cSerialNo                 := cIMEI
	oInfo:cSODate                   := cDTOS
	oInfo:cOperator                 := cOPERAD
	If Alltrim(cNUMCEL) <> "00000000"
		oInfo:cRegisteredNo             := cNUMCEL
	EndIf
	oInfo:cProductFeature           := cDPYNUM
	oInfo:cCoverCode                := cCODCOB
	oInfo:cAttendanceSite           := cLOCATE
	oInfo:cOriginCode               := cPROCPR
	oInfo:cManufacturerDate         := cDTFABR
	If cSTAPUR $ "0/2/ "
		oInfo:oWSPurchaseData := oPurchase
	EndIf
	oInfo:cServiceTypeCode          := cCODSER
	oInfo:cAttendantName            := cATNAME
	oInfo:cReceivingInvoiceNo     	:= cNFENTR
	oInfo:cReceivingDate            := cDTRECE
	If (cSTACLI $ "0/2/ " .OR. !SubSTR(AllTrim(cIDCLIE),1,6)="000146")
		oInfo:oWSCustomer := oCustomer
	EndIf
	oInfo:cExpectedRepairDate      := cDTPREV
	oInfo:cProductAccessories      := cACESSO
	oInfo:cFaultDescription        := cDEFCON
	oInfo:cProductConditions       := cESTAPA
	oInfo:cTechnicalEvaluationDate := cDTAVAL
	oInfo:cSwRevision 		       := cSFTREV
	oInfo:cRepairDate              := cDTREPA
	oInfo:cRemarks                 := cOBSREP
	oInfo:nStep                    := cETAPOS
	oInfo:cSOStatusCode            := cCODSOS
	oInfo:cSOStatusDate            := cDTSTOS
	oInfo:cModelOut                := cCODMNV
	oInfo:cSerialNoOut             := cIMEINV
	oInfo:cFeatureOut              := cDPYIMN
	oInfo:cSwapControlNo           := cCTROCA
	oInfo:cFaultClaimedByCustomer  	  := cDEFREC
	oInfo:cFaultEvaluatedByTechnician := cSINTAV
	oInfo:cFinalInspectionDate    	  := cDTINSF
	If cSTASYM $ "0/2/ "
		oInfo:oWSSymptomsEncoded := WSServiceOrder_ArrayOfTSymptomEncoded():New()
		oInfo:oWSSymptomsEncoded:oWSTSymptomEncoded := GetSymptom(cIDSINT)
	EndIf
	If cSTAFAU $ "0/2/ "
		oInfo:oWSFaults   := WSServiceOrder_ArrayOfTFault():New()
		oInfo:oWSFaults:oWSTFault := GetFault(cIDFALH,cFGONGO,cSTPECA)
	EndIf
	If cSTADEL = "1"
		oInfo:oWSDeliveryData    := oDelivery
	EndIf
	If cSTACOM $ "0/2/ "
		oInfo:oWSFollowUp:= WSServiceOrder_ArrayOfTFollowUp():New()
		oInfo:oWSFollowUp:oWSTFollowUp := GetFollowUp(cImei,cIDOS)
	EndIf
	*
	oInfo:cOriginASCSONo				:= cNUMOS_O
	oService := WSServiceOrder_TServiceOrder():New()
	If lSonyMRC .AND. cNUMOS_O == cNUMOS
		oService:cSONo				:= ""
	Else
		oService:cSONo				:= cNUMOS
	EndIf
	oService:cASCCode  := cCODPOS
	oService:oWSSOInfo := oInfo
	oService:nResultCode                 := 0
	oService:cResultMsg                  := ""

	aAdd(OSOA:OWSSERVICEORDERS:OWSTSERVICEORDER, oService)
	If nQtdOS >= 10
		wsupdgvs()
		nQtdOS:=0
	EndIf
	dbSelectArea("TMP")
	TMP->(dbSkip())
EndDo
wsupdgvs()
nQtdOS:=0
RESET ENVIRONMENT
Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณwsupdgvs  บAutor  ณ                          บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function wsupdgvs()
nRegE  := nQtdOS

If nQtdOS > 0 	
	aoszz8 := OSOA:OWSSERVICEORDERS:OWSTSERVICEORDER
	//aUpdate := aClone(oCopia:oWSServiceorders:oWSTServiceOrder)
	//ConOut("   ||-----|  Quantidade OS: "+strzero(nQtdOS,4)+"  Sincronizando Webservice!")
	//ConOut("   ||-----| ")
	//ConOut("   ||-----| ")
	//ConOut("   ||-----| ")
	//ConOut("   ||-----| Methodo Update()")
	oSoa:DataUpdate()
	//ConOut(Replicate("*",50))
	//ConOut("***** ANALISANDO ERROS - INICIO")
	//ConOut("erro 1")
	//ConOut(GetWSCError())
	//ConOut("erro 2")
	//ConOut(GetWSCError(2))
	//ConOut("erro 3")
	//ConOut(GetWSCError(3))
	//ConOut("***** ANALISANDO ERROS - FINAL")
	//ConOut("   ||-----|============================================================================================= ")
	//ConOut("   ||-----| ")
	//ConOut("   ||-----| ")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDescarregando dados.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ConOut("   ||-----| ")
	//ConOut("   ||-----|  Tratando retorno...!")
	//ConOut("   ||-----| ")
	//oSoa:oWSDataUpdateResult:oWSserviceOrdersProtocol:WSServiceOrder_TServiceOrder // vetor com dados  ServideOrder Retornados
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRetorno Carga aServOrder.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	cCODPOS  := oSoa:oWSDataUpdateResult:nResultCode  // resposta  0=OK, -1=Erro
	//cNUMOS	 :=
	//aOInfo	 :=
	aupdate := {}
	cRESMSG	 := oSoa:oWSDataUpdateResult:cResultMsg   // Resposta
	If Valtype(oSoa) == "O"
		If Valtype(oSoa:oWSDataUpdateResult) == "O"
			If Valtype(oSoa:oWSDataUpdateResult:oWSserviceOrdersProtocol) == "O"
				aupdate  := aClone(oSoa:oWSDataUpdateResult:oWSserviceOrdersProtocol:oWSTServiceOrder)
			EndIf
		EndIf
	EndIf
	n1 := 0
	For n1:= 1 to Len(aupdate)    //desmembrando o conteudo (oSoa:oUpdData)
		//CargaUpd(n1)  // Carregando dados do vetor aUpdate para variaveis no ambiente
		If Len(aoszz8) >= n1
			CargaRet(n1,aoszz8[n1]:CSONO,aoszz8[n1]:OWSSOINFO:CSERIALNO)  // Carregando dados do vetor aRetorn para variaveis no ambiente
		EndIf
		//TrataRet()    // Funcao para tratamento e uso das variavei retornadas
	Next n1
Else
	//ConOut("||-----|| ***** nenhum dados exportado base vazia***")
	//ConOut("||-----|| ***** nenhum dados exportado base vazia***")
	//ConOut("||-----|| ***** nenhum dados exportado base vazia***")
Endif
//ConOut("   ||-----| [SONY-FINAL] "+DTOC(DATE())+" "+TIME())
//ConOut(Replicate("=",50))
//ConOut(Replicate("=",50))
//ConOut(Replicate("=",50))
Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARGAVAR  บAutor  ณEduardo Nakamatu    บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarga de dados das variaveis com informacoes                บฑฑ
ฑฑบ          ณda query                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CARGAVAR()
Local dBranco := CTOD("01/01/0001")   //01/01/0001 00:00:00
lSonyMRC	:= .F.
dbSelectArea("ZZ8")
dbgoto(TMP->ZZ8NREC)
cSTACOM := AllTrim(TMP->ZZ8_STACOM)
cSTACLI := AllTrim(TMP->ZZ8_STACLI)
cSTAPUR := AllTrim(TMP->ZZ8_STAPUR)
cSTASYM := AllTrim(TMP->ZZ8_STASYM)
cSTAFAU := AllTrim(TMP->ZZ8_STAFAU)
cSTADEL := AllTrim(TMP->ZZ8_STADEL)
cSTPECA := AllTrim(TMP->ZZ8_STAPEC)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSFollowUp.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDACOM := TMP->ZZ8_IDACOM
cDTACOM := Iif(Empty(TMP->ZZ8_DTACOM), dBranco ,TMP->ZZ8_DTACOM)
cSEQACO := TMP->ZZ8_SEQACO
cACOMPA := AllTrim(TMP->ZZ8_ACOMPA)
cUSERAC := AllTrim(TMP->ZZ8_USERAC)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSDeliveryData.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDEXPE := Iif(!Empty(AllTrim(TMP->ZZ8_IDEXPE)),AllTrim(TMP->ZZ8_IDEXPE),SubSTR(TMP->ZZ8_IDEXPE,1,1))
//cDTEXPE := Iif(Empty(TMP->ZZ8_DTEXPE),dBranco,TMP->ZZ8_DTEXPE)
cDTEXPE := Iif(Empty(TMP->ZZ8_DTEXPE),CTOD("  /  /  "),TMP->ZZ8_DTEXPE)
cATEENT := Iif(!Empty(AllTrim(TMP->ZZ8_ATEENT)),Iif(AllTrim(TMP->ZZ8_ATEENT)<>"UPS",AllTrim(TMP->ZZ8_ATEENT),SPACE(3)),SPACE(3))
nNFSAID := Iif(Empty(TMP->ZZ8_NFSAID),Iif(Empty(SubSTR(TMP->ZZ8_IDEXPE,1,6)),1,VAL(SubSTR(TMP->ZZ8_IDEXPE,1,6))),VAL(TMP->ZZ8_NFSAID))
nITEMNF := Iif(Empty(TMP->ZZ8_ITEMNF),0,TMP->ZZ8_ITEMNF)
nTOTINF	:= Iif(Empty(TMP->ZZ8_TOTINF),0,TMP->ZZ8_TOTINF)
cAWB	:= Iif(Empty(TMP->ZZ8_AWB),Nil,TMP->ZZ8_AWB)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aFParts.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDPECA := AllTrim(TMP->ZZ8_IDPECA)
cSEQPEC := TMP->ZZ8_SEQPEC
cCGRSO2 := AllTrim(TMP->ZZ8_CGRSO2)
cCODPEC := AllTrim(TMP->ZZ8_CODPEC)
cPECQTD := TMP->ZZ8_PECQTD
cPOSPEC	:= AllTrim(TMP->ZZ8_POSPEC)
cPREVPC := AllTrim(TMP->ZZ8_PREVPC)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSFault.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDSINT	:=AllTrim(TMP->ZZ8_IDSINT)
cCODDEF	:= AllTrim(TMP->ZZ8_CODDEF)
cCODSOL	:= AllTrim(TMP->ZZ8_CODSOL)
cCGRPSO	:= AllTrim(TMP->ZZ8_CGRPSO)
cSINREC	:= AllTrim(TMP->ZZ8_SINREC)
cMOTDEV	:= AllTrim(TMP->ZZ8_MOTDEV)
cNIVREP	:= AllTrim(TMP->ZZ8_NIVREP)
cFGONGO	:= TMP->ZZ8_FGONGO
//aFParts	// vetor tratado por fora
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSSymptomEncodณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDFALH	:= AllTrim(TMP->ZZ8_IDFALH)
cSEQSIN	:= TMP->ZZ8_SEQSIN
cSINTCO	:= AllTrim(TMP->ZZ8_SINTCO)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSPurchaseData.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cIDNFCO	 := AllTrim(TMP->ZZ8_IDNFCO)
cDTNFCO	 := Iif(Empty(TMP->ZZ8_DTNFCO), TMP->ZZ8_DTOS ,Iif(TMP->ZZ8_DTOS<TMP->ZZ8_DTNFCO,TMP->ZZ8_DTOS,TMP->ZZ8_DTNFCO))
cNOMREV  := Iif(!Empty(AllTrim(TMP->ZZ8_NOMREV)),Iif(Len(AllTrim(TMP->ZZ8_NOMREV))<4,LEFT(TMP->ZZ8_NOMREV,4),AllTrim(TMP->ZZ8_NOMREV)),SubSTR(TMP->ZZ8_NOMREV,1,4))
cCNPJRE	 := Iif(Empty(SubSTR(TMP->ZZ8_CNPJRE,1,14)),Nil,SubSTR(TMP->ZZ8_CNPJRE,1,14))
cNFCOMP	 := Iif(Empty(AllTrim(TMP->ZZ8_NFCOMP)),Iif(!Empty(AllTrim(TMP->ZZ8_IDNFCO)),SubSTR(TMP->ZZ8_IDNFCO,1,6),"1"),AllTrim(TMP->ZZ8_NFCOMP))
cVLRNFC	 := TMP->ZZ8_VLRNFC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aSCustomer.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("Z07")
dbSetOrder(1)
If Z07->(dbSeek(xFilial("Z07") + AllTrim(TMP->A1_CEP)))
	_lcep:=.t.
EndIf
cIDCLIE	      := TMP->ZZ8_IDCLIE
cNOME	      := AllTrim(TMP->A1_NOME)
cCGC	      := AllTrim(TMP->A1_CGC)
cINSCR	      := AllTrim(TMP->A1_INSCR)
nDivi         := At(" ",AllTrim(TMP->A1_END))
cEND	      := Iif(_lcep,AllTrim(Z07->Z07_TPLOGR),AllTrim(SubSTR(TMP->A1_END, 1, nDivi - 1)))
cNUMERO	      := VAL(Iif(Empty(TMP->TA1_NUMERO),"000000",TMP->TA1_NUMERO))
cENDERECO     := Iif(_lcep,AllTrim(SubSTR(TMP->A1_END,  nDivi+1,60)),AllTrim(TMP->A1_END))
cCOMPLEMENTO  := Iif(Empty(TMP->TA1_COMPLEMENTO),Nil,AllTrim(TMP->TA1_COMPLEMENTO))
cBAIRRO	      := Iif(_lcep,AllTrim(SubSTR(Z07->Z07_BAIRRO,1,30)),AllTrim(SubSTR(TMP->A1_BAIRRO,1,30)))
cMUN	      := Iif(_lcep,AllTrim(Z07->Z07_MUNIC),AllTrim(TMP->A1_MUN))
cEST	      := Iif(_lcep,AllTrim(Z07->Z07_UF),AllTrim(TMP->A1_EST))
cCEP	      := AllTrim(TMP->A1_CEP)
cDDD	      := Iif(Empty(TMP->A1_DDD),"00",TMP->A1_DDD)
cTEL	      := AllTrim(TMP->A1_TEL)
cDDD2	      := Iif(Empty(TMP->TA1_DDD2),"00",TMP->TA1_DDD2)
cTEL2	      := Iif(Empty(TMP->A1_TEL2),Nil,AllTrim(TMP->A1_TEL2))
cDDD3	      := Iif(Empty(TMP->TA1_DDD3),Nil,TMP->TA1_DDD3)
cTEL3	      := Iif(Empty(TMP->TA1_TEL3),"000000000000000",TMP->TA1_TEL3)
cEMAIL	      := AllTrim(TMP->A1_EMAIL)
cNREDUZ	      := AllTrim(TMP->A1_NREDUZ)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aOInfo ok.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
coSession      := oSession
cIDOS	       := TMP->ZZ8_IDOS
cCODAT	       := Iif(!Empty(AllTrim(TMP->ZZ8_CODAT)),AllTrim(TMP->ZZ8_CODAT),"4266")
cMARCA	       := AllTrim(TMP->ZZ8_MARCA)
cMODPRO	       := AllTrim(TMP->ZZ8_CODPRO)
cIMEI	       := AllTrim(TMP->ZZ8_IMEI)
cDTOS	       := TMP->ZZ8_DTOS
cOPERAD	       := Iif(!Empty(AllTrim(TMP->ZZ8_OPERAD)),Iif((AllTrim(TMP->ZZ8_OPERAD))="Generico","Gen้rico",Iif((AllTrim(TMP->ZZ8_OPERAD))="Amazonia","Amaz๔nia",AllTrim(TMP->ZZ8_OPERAD))),"Gen้rico")
cNUMCEL	       := AllTrim(TMP->ZZ8_NUMCEL)
cDPYNUM	       := AllTrim(TMP->ZZ8_DPYNUM)	      //10
cCODCOB	       := Iif(!Empty(AllTrim(TMP->ZZ8_CODCOB)),AllTrim(TMP->ZZ8_CODCOB),"SE")
cLOCATE	       := Iif(!Empty(AllTrim(TMP->ZZ8_LOCATE)) .AND. Len(AllTrim(TMP->ZZ8_LOCATE))>=2 ,Iif(AllTrim(TMP->ZZ8_LOCATE)='UPS',SPACE(2),AllTrim(TMP->ZZ8_LOCATE)),SPACE(2))
cPROCPR	       := Iif(!Empty(AllTrim(TMP->ZZ8_PROCPR)).AND. Len(AllTrim(TMP->ZZ8_PROCPR)) >=2,AllTrim(TMP->ZZ8_PROCPR),"Consumidor")
cDTFABR	       := STRZERO(VAL(AllTrim(TMP->ZZ8_DTFABR)),4)
//aSPurchaseData 	// vetor tratado por fora
cCODSER	       := Iif(!Empty(AllTrim(SubSTR(TMP->ZZ8_CODSER,1,10))),AllTrim(SubSTR(TMP->ZZ8_CODSER,1,10)),"SEG")
cATNAME	       := Iif(!Empty(AllTrim(TMP->ZZ8_ATNAME)),Iif(AllTrim(TMP->ZZ8_ATNAME)='UPS',SPACE(3),AllTrim(TMP->ZZ8_ATNAME)),SPACE(3))
cNFENTR	       := AllTrim(TMP->ZZ8_NFENTR)
cDTRECE	       := Iif(Empty(TMP->ZZ8_DTRECE),dBranco,TMP->ZZ8_DTRECE)
//aSCustomer  	// vetor tratado por fora     //20
cDTPREV	       := Iif(Empty(TMP->ZZ8_DTPREV),TMP->ZZ8_DTOS,Iif(TMP->ZZ8_DTPREV<TMP->ZZ8_DTOS,TMP->ZZ8_DTOS,TMP->ZZ8_DTPREV))
cACESSO	       := Iif(Empty(SubSTR(TMP->ZZ8_ACESSO,1,120)),Nil,AllTrim(SubSTR(TMP->ZZ8_ACESSO,1,120)))
cDEFCON	       := Iif(!Empty(AllTrim(TMP->ZZ8_DEFCON)),AllTrim(TMP->ZZ8_DEFCON),SPACE(1))
cESTAPA	       := Iif(!Empty(SubSTR(TMP->ZZ8_ESTAPA,1,120)),AllTrim(SubSTR(TMP->ZZ8_ESTAPA,1,120)),SubSTR(TMP->ZZ8_ESTAPA,1,5))
//cDTAVAL	       := Iif(Empty(TMP->ZZ8_DTAVAL),TMP->ZZ8_DTOS ,Iif(TMP->ZZ8_DTAVAL-TMP->ZZ8_DTOS < 0,TMP->ZZ8_DTOS,TMP->ZZ8_DTAVAL))
cDTAVAL	       := TMP->ZZ8_DTAVAL
cSFTREV	       := Iif(!Empty(AllTrim(TMP->ZZ8_SFTREV)),AllTrim(TMP->ZZ8_SFTREV),SubSTR(TMP->ZZ8_SFTREV,1,1))
//cDTREPA	       := Iif(Empty(TMP->ZZ8_DTREPA),cDTAVAL,Iif(cDTAVAL<TMP->ZZ8_DTREPA,TMP->ZZ8_DTREPA,cDTAVAL))
cDTREPA	       := TMP->ZZ8_DTREPA
cOBSREP	       := Iif(!Empty(AllTrim(TMP->ZZ8_OBSREP)),AllTrim(TMP->ZZ8_OBSREP),SubSTR(TMP->ZZ8_OBSREP,1,1))
cETAPOS	       := Iif(Empty(TMP->ZZ8_ETAPOS),05,val(TMP->ZZ8_ETAPOS))
cCODSOS	       := Iif(Empty(TMP->ZZ8_CODSOS),'2',SubSTR(TMP->ZZ8_CODSOS,1,2))
cDTSTOS	       := Iif(Empty(TMP->ZZ8_DTSTOS),TMP->ZZ8_DTOS,Iif(TMP->ZZ8_DTSTOS< TMP->ZZ8_DTOS,TMP->ZZ8_DTOS,TMP->ZZ8_DTSTOS))
cCODMNV	       := Iif(Empty(TMP->ZZ8_CODMNV),Nil,AllTrim(TMP->ZZ8_CODMNV))
cIMEINV	       := Iif(Empty(TMP->ZZ8_IMEINV),Nil,AllTrim(TMP->ZZ8_IMEINV))
cDPYIMN	       := Iif(Empty(TMP->ZZ8_DPYIMN),Nil,AllTrim(TMP->ZZ8_DPYIMN))
cCTROCA	       := Iif(Empty(TMP->ZZ8_CTROCA),Nil,AllTrim(TMP->ZZ8_CTROCA))
cDEFREC	       := Iif(!Empty(AllTrim(TMP->ZZ8_DEFREC)),AllTrim(TMP->ZZ8_DEFREC),"NAO ESPECIFICADO")
cSINTAV	       := Iif(!Empty(AllTrim(TMP->ZZ8_SINTAV)),AllTrim(TMP->ZZ8_SINTAV),SubSTR(TMP->ZZ8_SINTAV,1,2))
cDTINSF	       := Iif( Empty(TMP->ZZ8_DTINSF),cDTREPA,Iif(TMP->ZZ8_DTINSF<cDTREPA,cDTREPA,TMP->ZZ8_DTINSF))
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida datas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
//aSSymptomEncod 	// vetor tratado por fora
//aFParts	       	// vetor tratado por fora         40
//aSDeliveryData 	// vetor tratado por fora
//aSFollowUp     	// vetor tratado por fora
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarga aServOrder ok.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCODPOS  := AllTrim(TMP->ZZ8_CODPOS)
cNUMOS	 := AllTrim(TMP->ZZ8_NUMOS)
cNUMOS_O := AllTrim(TMP->ZZ8_OSGVSO)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine se oper็ใo ้ Sony MRC pois ้ necessแrio enviar emณ
//ณbranco a OS GVS e deixar o sistema deles gerar a OS que ณ
//ณserแ replicada internamente no retorno.                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lSonyMRC := IIf(TMP->TSONYMRC=="S",.T.,.F.)
//aOInfo	 := TMP->ZZ8_OInfo
cRESMSG	 := AllTrim(ZZ8->ZZ8_RESMSG)	  //TMO->ZZ8_RESMSG
cRMSGOS	 := AllTrim(ZZ8->ZZ8_RMSGOS)  //TMP->ZZ8_RMSGOS
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMONTAGEM DE CARGA PARA RECNO/GERACAO DE LOG.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nRegZZ8 := TMP->ZZ8NREC
Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARGAUPD  บAutor  ณEduardo Nakamatu    บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCARGA DE VARIAVEIS DO AMBIENTE COM DADOS DO VETOR UPDATE    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณBGH                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CargaUpd(n1)
cCODPOS := aupdate[n1]:CASCCODE
cNUMOS  := aupdate[n1]:CGVSREADESIGNATURE
//aOInfo  := aUpdate[ n1 ,NATURE 3]
coSession := aupdate[n1]:CGVSREADESIGNATURE
cIDOS	  := aupdate[n1]:CDATAVERSION
cCODAT	  := aupdate[n1]:CORIGINASCODE
cMARCA	  := aupdate[n1]:CBRANDNAME
cMODPRO	  := aupdate[n1]:CMANUFACTURERDATE
cIMEI	  := aupdate[n1]:CSERIALNO
cDTOS	  := aupdate[n1]:CASCCODE
cOPERAD	  := aupdate[n1]:CASCCODE
cNUMCEL	  := aupdate[n1]:CASCCODE
cDPYNUM	  := aupdate[n1]:CASCCODE
cCODCOB	  := aupdate[n1]:CASCCODE
cLOCATE	  := aupdate[n1]:CASCCODE
cPROCPR	  := aupdate[n1]:CASCCODE
cDTFABR	  := aupdate[n1]:CMANUFACTURERDATE
//aSPurchaseData := aUpdate[ n1 , 3 , 15 ]
cIDNFCO	:= aupdate[n1]:CASCCODE
cDTNFCO	:= aupdate[n1]:CASCCODE
cNOMREV	:= aupdate[n1]:CASCCODE
cCNPJRE	:= aupdate[n1]:CASCCODE
cNFCOMP	:= aupdate[n1]:CASCCODE
cVLRNFC	:= aupdate[n1]:CASCCODE
cCODSER	:= aupdate[n1]:CASCCODE
cATNAME	:= aupdate[n1]:CASCCODE
cNFENTR	:= aupdate[n1]:CASCCODE
cDTRECE	:= aupdate[n1]:CASCCODE
//aSCustomer :=  aUpdate[ n1 , 3 , 20 ]
cDTPREV :=  aupdate[n1]:CASCCODE
cACESSO :=  aupdate[n1]:CASCCODE
cDEFCON :=  aupdate[n1]:CASCCODE
cESTAPA :=  aupdate[n1]:CASCCODE
cDTAVAL :=  aupdate[n1]:CASCCODE
cSFTREV :=  aupdate[n1]:CASCCODE
cDTREPA :=  aupdate[n1]:CASCCODE
cOBSREP :=  aupdate[n1]:CASCCODE
cETAPOS :=  aupdate[n1]:CASCCODE
cCODSOS :=  aupdate[n1]:CASCCODE
cDTSTOS :=  aupdate[n1]:CASCCODE
cCODMNV := aupdate[n1]:CASCCODE
cIMEINV :=  aupdate[n1]:CASCCODE
cDPYIMN :=  aupdate[n1]:CASCCODE
cCTROCA := aupdate[n1]:CASCCODE
cDEFREC :=  aupdate[n1]:CASCCODE
cSINTAV :=  aupdate[n1]:CASCCODE
cDTINSF :=  aupdate[n1]:CASCCODE
cDTPREV	:= aupdate[n1]:CASCCODE
cACESSO	:= aupdate[n1]:CASCCODE
cDEFCON	:= aupdate[n1]:CASCCODE
cESTAPA	:= aupdate[n1]:CASCCODE
cDTAVAL	:= aupdate[n1]:CASCCODE
cSFTREV	:= aupdate[n1]:CASCCODE
cDTREPA	:= aupdate[n1]:CASCCODE
cOBSREP	:= aupdate[n1]:CASCCODE
cETAPOS	:= aupdate[n1]:CASCCODE
cCODSOS	:=aupdate[n1]:CASCCODE
cDTSTOS	:= aupdate[n1]:CASCCODE
cCODMNV	:= aupdate[n1]:CASCCODE
cIMEINV	:= aupdate[n1]:CASCCODE
cDPYIMN	:= aupdate[n1]:CASCCODE
cCTROCA	:=aupdate[n1]:CASCCODE
cDEFREC	:= aupdate[n1]:CASCCODE
cSINTAV	:= aupdate[n1]:CASCCODE
cDTINSF	:=aupdate[n1]:CASCCODE
//aSSymptomEncod := aUpdate[ n1 , 3 , 39 ]
cIDFALH	:= aupdate[n1]:CASCCODE
cSEQSIN	:= aupdate[n1]:CASCCODE
cSINTCO	:=aupdate[n1]:CASCCODE
//aFParts := aUpdate[ n1 , 3 , 40 ]
cIDPECA :=  aupdate[n1]:CASCCODE
cSEQPEC := aupdate[n1]:CASCCODE
cCGRSO2 :=  aupdate[n1]:CASCCODE
cCODPEC := aupdate[n1]:CASCCODE
cPECQTD := aupdate[n1]:CASCCODE
cPOSPEC	:=  aupdate[n1]:CASCCODE
cPREVPC := aupdate[n1]:CASCCODE
//aSDeliveryData  := aUpdate[ n1 , 3 , 41 ]
cIDEXPE := aupdate[n1]:CASCCODE
cDTEXPE := aupdate[n1]:CASCCODE
cATEENT :=aupdate[n1]:CASCCODE
nNFSAID := aupdate[n1]:CASCCODE
nITEMNF :=aupdate[n1]:CASCCODE
nTOTINF	:=aupdate[n1]:CASCCODE
cAWB	:= aupdate[n1]:CASCCODE
//aSFollowUp := aUpdate[ n1 , 3 , 42 ]
cIDACOM := aupdate[n1]:CASCCODE
cDTACOM := aupdate[n1]:CASCCODE
cSEQACO := aupdate[n1]:CASCCODE
cACOMPA :=aupdate[n1]:CASCCODE
cUSERAC := aupdate[n1]:CASCCODE
cRESMSG := aupdate[n1]:CASCCODE
cRMSGOS := aupdate[n1]:CASCCODE
Return(nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCargaRet  บAutor  ณEduardo Nakamatu    บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarga de variaveis de retorno                               บฑฑ
ฑฑบ          ณ- implemnetar variaveis conforme necessidade                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ bgh                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CargaRet(n1,coszz8,cimeizz8)
Local _ResMsg := DTOS(Date())+Replace(Time(),":","")+"|"
Local lAchouZZ8 := .F.
_cimei:=Space(25)       
cRet1 := aupdate[n1]:cAscCode
cRet2 := aupdate[n1]:cGVSReadedSignature
cRet3 := aupdate[n1]:cResultMsg
cRet5 := aupdate[n1]:nResultCode
cRet6 := AllTrim(aupdate[n1]:OWSSOINFO:CSERIALNO)
cRet7 := AvKey(aupdate[n1]:CSONO,"ZZ8_NUMOS")
cRet8 := AvKey(aupdate[n1]:OWSSOINFO:CMODELCODE,"ZZ8_CODPRO")
cRet9 := AvKey(AllTrim(Transform(AUPDATE[n1]:OWSSOINFO:nStep,"@ 999")),"ZZ8_ETAPOS")
_cIMEI := AvKey(cRet6,"ZZ8_IMEI")
_cOsOrig := AvKey(aupdate[n1]:OWSSOINFO:CORIGINASCSONO,"ZZ8_OSGVSO")

dbSelectArea("ZZ8")
ZZ8->(dbSetOrder(3)) //ZZ8_FILIAL+ZZ8_IMEI+ZZ8_NUMOS+ZZ8_CODPRO+ZZ8_ETAPOS
ZZ8->(dbGoTop())

If cRet7 == _cOsOrig // CALL CENTER *Mesma OS Original e OS GVS
	lAchouZZ8 := ZZ8->(dbSeek(xFilial("ZZ8")+_cIMEI+cRet7+cRet8))
ElseIf Empty(cRet7) .AND. !Empty(_cOsOrig) // MRC Com erro no retorno busca pela OS Original
	cRet7 := _cOsOrig
	lAchouZZ8 := ZZ8->(dbSeek(xFilial("ZZ8")+_cIMEI+cRet7+cRet8))
ElseIf !Empty(_cOsOrig) .AND. cRet7 <> _cOsOrig // MRC Update OK ou OS GVS jแ gerada anteriormente. Por isso a segunda tentativa do seek.
	lAchouZZ8 := ZZ8->(dbSeek(xFilial("ZZ8")+_cIMEI+cRet7+cRet8))
	If !lAchouZZ8
		lAchouZZ8 := ZZ8->(dbSeek(xFilial("ZZ8")+_cIMEI+_cOsOrig+cRet8))
	EndIf
EndIf

If lAchouZZ8
	RecLock("ZZ8",.F.)
	ZZ8->ZZ8_GVSASS := Iif(cRet5=0,cRet2,"ERRO_RETORNO")
	ZZ8->ZZ8_RESMSG := _ResMsg + cRet3
	ZZ8->ZZ8_RESCOD := Iif(cRet5=0,.T.,.F.)
	ZZ8->ZZ8_RCODOS := Iif(cRet5=0,.T.,.F.)
	ZZ8->ZZ8_RMSGOS := cRet3
	If cRet5=0
		ZZ8->ZZ8_NUMOS := cRet7
	EndIf
	ZZ8->ZZ8_STATUS := Iif(cRet5=0,'1','4')
	ZZ8->ZZ8_STACOM := Iif(cSTACOM $ "0/2" .AND. cRet5=0,"1","2")
	ZZ8->ZZ8_STAPUR := Iif(cSTAPUR $ "0/2" .AND. cRet5=0,"1","2")
	ZZ8->ZZ8_STASYM := Iif(cSTASYM $ "0/2" .AND. cRet5=0,"1","2")
	ZZ8->ZZ8_STAFAU := Iif(cSTAFAU $ "0/2" .AND. cRet5=0,"1","2")
//	ZZ8->ZZ8_STADEL := cSTADEL
	ZZ8->ZZ8_STACLI := Iif(cSTACLI $ "0/2" .AND. cRet5=0,"1","2")
	ZZ8->ZZ8_STAPEC := Iif(cSTPECA $ "0/2" .AND. cRet5=0,"1","2")
	MsUnLock("ZZ8")
	If cRet5=0
		dbSelectArea("ZZ4")
		If ZZ4->(dbSeek(xfilial("ZZ4")+ZZ8->ZZ8_IMEI+SubSTR(ZZ8->ZZ8_IDOS,1,6)))
			Reclock("ZZ4",.F.)
			ZZ4->ZZ4_GVSOS := cRet7
			If	(ZZ4->ZZ4_STATUS <= "4" .AND. cRet9 = "5") .OR.;
				(ZZ4->ZZ4_STATUS  = "5" .AND. cRet9 = "6") .OR.;
				(ZZ4->ZZ4_STATUS >= "6" .AND. cRet9 = "7")
				 ZZ4->ZZ4_MSEXP:="1"
			EndIf
			MsUnLock('ZZ4')
		EndIf
		dbSelectArea("SZ9")
		SZ9->(dbSetOrder(2))//Z9_FILIAL, Z9_IMEI+Z9_NUMOS,Z9_SEQ, Z9_ITEM
		If SZ9->(dbSeek(xfilial("SZ9")+ZZ8->ZZ8_IMEI+SubSTR(ZZ8->ZZ8_IDOS,1,6)))
			Reclock("SZ9",.F.)
			 SZ9->Z9_MSEXP:="1"
			MsUnLock('SZ9')
		EndIf
		dbSelectArea("SZA")
		SZA->(dbGoTop())
		SZA->(dbSetOrder(4)) // ZA_FILIAL, ZA_IMEI, ZA_CLIENTE, ZA_LOJA, ZA_NFISCAL, ZA_STATUS
		If SZA->(dbSeek(xFilial("SZA") + AvKey(Alltrim(ZZ4->ZZ4_IMEI),"ZA_IMEI") + ZZ4->ZZ4_CODCLI + ZZ4->ZZ4_LOJA))
			While 		!SZA->(Eof()) ;
						.AND. SZA->ZA_FILIAL == xFilial("SZA");
						.AND. SZA->ZA_IMEI == AvKey(Alltrim(ZZ4->ZZ4_IMEI),"ZA_IMEI");
						.AND. SZA->ZA_CLIENTE = ZZ4->ZZ4_CODCLI;
						.AND. SZA->ZA_LOJA == ZZ4->ZZ4_LOJA
				If SZA->ZA_NFISCAL == ZZ4->ZZ4_NFENR .OR. SZA->ZA_LOTEIRL == ZZ4->ZZ4_LOTIRL
					Reclock("SZA",.F.)
					 SZA->ZA_OSGVS := cRet7
					MsUnLock("SZA")
					Exit
				EndIf
				SZA->(dbSkip())
			EndDo
		EndIf
	EndIf
EndIf

//cInfo1 := aupdate[n1]:oWSSOInfo:cATTENDANCESIZE
//cInfo2 := aupdate[n1]:oWSSOInfo:cATTENDANTName
//(...)  continue
Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataRet  บAutor  ณEduardo Nakamatu    บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para utilizar os dados do retorno                   บฑฑ
ฑฑบ          ณ - IMPLEMENTACAO POR PARTE DA BGH                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BGH                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function TrataRet()
Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณRSOAM01   บAutor  ณMicrosiga                 บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CargaDBXX()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmontando query.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ConOut("   ||-----| ")
//ConOut("   ||-----| Lendo a base de dados...")
//ConOut("   ||-----| ")
cQry := "SELECT	ZZ8_FILIAL, ZZ8_CODPOS, ZZ8_NUMOS, ZZ8_CODPRO, ZZ8_IMEI, ZZ8_DPYNUM, ZZ8_CODAT, ZZ8_MARCA, ZZ8_DTOS, ZZ8_OPERAD, ZZ8_NUMCEL, ZZ8_CODCOB, " + CRLF
cQry += "	ZZ8_LOCATE, ZZ8_PROCPR, ZZ8_DTFABR, ZZ8_CODSER, ZZ8_ATNAME, ZZ8_NFENTR, ZZ8_DTRECE, ZZ8_DTPREV, ZZ8_ACESSO, ZZ8_NOMREV, ZZ8_CNPJRE, ZZ8_NFCOMP, " + CRLF
cQry += "	ZZ8_DTNFCO, ZZ8_VLRNFC, ZZ8_DEFCON, ZZ8_ESTAPA, ZZ8_DTAVAL, ZZ8_SFTREV, ZZ8_DTREPA, ZZ8_OBSREP, ZZ8_ETAPOS, ZZ8_CODSOS, ZZ8_DTSTOS, ZZ8_CODMNV, " + CRLF
cQry += "	ZZ8_IMEINV, ZZ8_DPYIMN, ZZ8_CTROCA, ZZ8_DEFREC, ZZ8_SINTAV, ZZ8_DTINSF, ZZ8_SEQSIN, ZZ8_SINTCO, ZZ8_CODDEF, ZZ8_CODSOL, ZZ8_CGRPSO, ZZ8_SINREC, " + CRLF
cQry += "	ZZ8_MOTDEV, ZZ8_NIVREP, ZZ8_FGONGO, ZZ8_SEQPEC, ZZ8_CGRSO2, ZZ8_CODPEC, ZZ8_PECQTD, ZZ8_POSPEC, ZZ8_PREVPC, ZZ8_DTEXPE, ZZ8_ATEENT, ZZ8_NFSAID, " + CRLF
cQry += "	ZZ8_ITEMNF, ZZ8_TOTINF, ZZ8_AWB, ZZ8_DTACOM, ZZ8_SEQACO, ZZ8_ACOMPA, ZZ8_USERAC, ZZ8_IDOS, ZZ8_IDCLIE, ZZ8_IDNFCO, ZZ8_IDFALH, ZZ8_IDSINT, " + CRLF
cQry += "	ZZ8_IDPECA, ZZ8_IDACOM, ZZ8_IDEXPE, ZZ8_STACOM, ZZ8_STAPUR, ZZ8_STASYM, ZZ8_STAFAU, ZZ8_STADEL, ZZ8_STACLI, ZZ8_STAPEC, ZZ8_GVSASS, ZZ8_HORAOS, " + CRLF
cQry += "	ZZ8_HRREPA, ZZ8_HRETOS, ZZ8_HRINSV, ZZ8_HREXPE, SA1.A1_NOME, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_EST, " + CRLF
cQry += "	SA1.A1_CEP, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_TEL2, SA1.A1_EMAIL, SA1.A1_NREDUZ, ZZ8_OSGVSO, " + CRLF
cQry += "	cast((	CASE " + CRLF
cQry += "				WHEN ZZ8_RESCOD = 'T' THEN 0 " + CRLF
cQry += "				ELSE -1 " + CRLF
cQry += "			END ) AS INT)     ZZ8_RESCOD, " + CRLF
cQry += "	cast((	CASE " + CRLF
cQry += "				WHEN ZZ8_RCODOS = 'T' THEN 0 " + CRLF
cQry += "				ELSE -1 " + CRLF
cQry += "			END ) AS INT)     ZZ8_RCODOS, " + CRLF
cQry += "	cast(' ' AS VARCHAR(10))		as TA1_DDD2, " + CRLF
cQry += "	ZZ8.R_E_C_N_O_					as T_RECNO, " + CRLF
cQry += "	Space(2)						as TA1_NUMERO, " + CRLF
cQry += "	Space(60)						as TA1_ENDERECO, " + CRLF
cQry += "	Space(40)						as TA1_COMPLEMENTO, " + CRLF
cQry += "	Cast('  ' AS VARCHAR(3))		as TA1_DDD3, " + CRLF
cQry += "	Cast(' ' AS VARCHAR(15))		as TA1_TEL3, " + CRLF
cQry += "	ZZ8.R_E_C_N_O_					as ZZ8NREC, " + CRLF
cQry += "	CASE " + CRLF
cQry += "		WHEN isnull(ZZ4.ZZ4_OPEBGH,'***') = 'S06' THEN 'S' " + CRLF
cQry += "		WHEN isnull(ZZ4.ZZ4_OPEBGH,'***') in ('S05','S06','S08','S09') AND (Len(A1_CGC) = 14 OR SA1.A1_PESSOA = 'J') THEN 'S' " + CRLF
cQry += "		ELSE 'N' " + CRLF
cQry += "	END as TSONYMRC " + CRLF
cQry += "FROM "+RetSQLName("ZZ8")+" as ZZ8 (NOLOCK) " + CRLF
cQry += "	INNER JOIN "+RetSQLName("SA1")+" SA1 (NOLOCK) " + CRLF
cQry += "		ON SA1.D_E_L_E_T_ = '' " + CRLF
cQry += "		AND SA1.A1_COD = Substring(ZZ8.ZZ8_IDCLIE, 1, 6) " + CRLF
cQry += "		AND SA1.A1_LOJA = Substring(ZZ8.ZZ8_IDCLIE, 7, 2) " + CRLF
cQry += "		AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' " + CRLF
cQry += "	 LEFT JOIN ZZ4020 ZZ4 (NOLOCK) " + CRLF
cQry += "		ON ZZ4.D_E_L_E_T_ = '' " + CRLF
cQry += "		AND ZZ4.ZZ4_FILIAL = ZZ8.ZZ8_FILIAL " + CRLF
cQry += "		AND ZZ4.ZZ4_IMEI = ZZ8.ZZ8_IMEI " + CRLF
cQry += "		AND ZZ4.ZZ4_CODCLI = SA1.A1_COD " + CRLF
cQry += "		AND ZZ4.ZZ4_LOJA = SA1.A1_LOJA " + CRLF
cQry += "		AND ZZ4.ZZ4_LOTIRL <> '' " + CRLF
cQry += "		AND ZZ8.ZZ8_NUMOS = ZZ4_GVSOS " + CRLF
cQry += "WHERE  ZZ8.D_E_L_E_T_ = '' " + CRLF
cQry += "	AND ZZ8.ZZ8_FILIAL = '"+xFilial("ZZ8")+"' " + CRLF
cQry += "	AND ZZ8.ZZ8_GVSASS IN ( '', 'ERRO_RETORNO' ) " + CRLF
cQry += "	AND (ZZ8.ZZ8_DTOS >= '20150101' OR ZZ8.ZZ8_DTOS = '')" + CRLF
//cQry += "	AND ZZ8.ZZ8_STATUS IN ( ' ', '0', '3', '4' ) " + CRLF
cQry += "	AND isnull(ZZ4.ZZ4_OPEBGH,'') in ('S05','S06','S08','S09') " + CRLF
//Criado essa tabela pois existem muitos casos com erro de duplicidade. Analisar posteriormente.
//cQry += "	AND NOT(ZZ8_FILIAL + ZZ8_IMEI + ZZ8_NUMOS in (SELECT FILIAL+IMEI+OS FROM IMEI_PROBLEMA_GVS)) " + CRLF
//cQry += "	AND ZZ8_FILIAL+ZZ8_IMEI+ZZ8_NUMOS in (SELECT FILIAL+IMEI+GVSOS FROM ENVIA) " + CRLF // B2X
//cQry += "	AND ZZ8_IMEI = '353004060021446' " + CRLF // B2X
cQry += "ORDER BY ZZ8_FILIAL, ZZ8_IMEI, ZZ8_NUMOS, ZZ8_CODPRO"
//MEMOWRIT("D:\a\EMERGENCIA.SQL",cQry)
//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TMP", .F., .T.)
TCQUERY cQry NEW ALIAS "TMP"
dbSelectArea("TMP")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTrata retorno query campos data e numerico,ณ
//ณutilizando TCSetField                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aStru := TMP->(dbstruct())
For y := 1 to Len(aStru)
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbGoTop()
	If !dbSeek(aStru[y,1]) .or. !SX3->X3_TIPO $ "D/N" // EXISTE NO SX3 EH NUMERICO OU DATA
		Loop
	EndIf
	SX3->(TCSetField("TMP",X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL))
Next
TCSetField("TMP","ZZ8NREC","N",17,0)
dbSelectArea("TMP")
dbGoTop()
Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณGetSymptomบAutor  ณMicrosiga                 บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetSymptom(cIDSINT)
Local aDados := {}
Local cQry   := ""
If AllTrim(cIDSINT) <> ''
	cQry := "   SELECT Z9_NUMOS,Z9_IMEI, Z9_SYMPTO, Z9_SINTCOD, Z9_SEQ,Z9_ITEM  "
	cQry += "  FROM "+retsqlname("SZ9")+" (NOLOCK)  "
	cQry += "  WHERE "
	cQry += "  Z9_FILIAL = '"+xFilial("SZ9")+"' AND "
	cQry += "  SubSTRING(Z9_NUMOS,1,6) = '"+AllTrim(SubSTR(cIDSINT,1,6))+"'  AND "
	cQry += "  Z9_SEQ ='"+SubSTR(cIDSINT,7,2)+"'  AND "
	cQry += "  Z9_ITEM='"+SubSTR(cIDSINT,9,2)+"'  AND "
	cQry += "  Z9_SYMPTO <> ''  AND "
	cQry += "  D_E_L_E_T_ <> '*' "
	cQry += "  GROUP BY Z9_NUMOS,Z9_IMEI, Z9_SYMPTO, Z9_SINTCOD, Z9_SEQ,Z9_ITEM "
	TCQUERY cQry NEW ALIAS "TSYM"
	dbSelectArea("TSYM")
	dbGoTop()
	While !TSYM->(Eof())
		oSymptom:= WSServiceOrder_TSymptomEncoded():New()
		oSymptom:cDataVersion := TSYM->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM)+AllTrim(Z9_SINTCOD))
		oSymptom:nSeq         := VAL(TSYM->Z9_SEQ)
		oSymptom:cCode        := TSYM->Z9_SINTCOD
		aAdd(aDados,oSymptom)
		TSYM->(dbSkip())
	EndDo
	dbSelectArea("TSYM")
	TSYM->(DBCLOSEArea())
Endif
Return(aDados)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณGetFault  บAutor  ณMicrosiga                 บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetFault(cIDFALH,cFGONGO,cSTPECA)
Local aDados := {}
Local cQry := ""
If AllTrim(cIDFALH) <> ''
//	cQry := "     SELECT Z9_NUMOS, Z9_IMEI, Z9_FAULID, Z9_ACTION ,Z9_SEQ,Z9_ITEM,Z9_SINTCOD,Z9_MOTDEFE, Z9_NIVELRE   "
	cQry := "     SELECT Z9_NUMOS, Z9_IMEI, right(rtrim(ltrim(Z9_ACTION)),2) as Z9_ACTION ,Z9_SEQ,Z9_ITEM,Z9_SINTCOD,Z9_MOTDEFE, Z9_NIVELRE, "
	cQry += "	CASE "
	cQry += "		WHEN Patindex('%[a-z,A-Z]%', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('-', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('.', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('*', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('+', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('[', Z9_FAULID) = 0 "
	cQry += "			AND Charindex(']', Z9_FAULID) = 0 "
	cQry += "			AND Charindex('''', Z9_FAULID) = 0 "
	cQry += "			AND Charindex(' ', Rtrim(Ltrim(Z9_FAULID))) = 0 THEN Rtrim(Ltrim(CONVERT(VARCHAR(30), CONVERT(INT, Z9_FAULID)))) "
	cQry += "		ELSE Z9_FAULID "
	cQry += "	END AS Z9_FAULID "
	cQry += "     FROM "+RETSQLNAME("SZ9")+" (NOLOCK) WHERE "
	cQry += "     Z9_FILIAL = '"+xFilial("SZ9")+"' AND "
	cQry += "     SubSTRING(Z9_NUMOS,1,6) = '"+SubSTR(cIDFALH,1,6)+"' AND "
	cQry += "     Z9_FAULID <> '' AND "
	cQry += "     D_E_L_E_T_ <> '*' "
	cQry += "     GROUP BY Z9_NUMOS, Z9_IMEI, Z9_FAULID, Z9_ACTION ,Z9_SEQ,Z9_ITEM,Z9_SINTCOD, Z9_SEQ, Z9_MOTDEFE, Z9_NIVELRE "
	TCQUERY cQry NEW ALIAS "TFAU"
	dbSelectArea("TFAU")
	dbGoTop()
	While !TFAU->(Eof())
		oFault := WSServiceOrder_TFault	():New()
		oFault:cDataVersion         := TFAU->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM)+AllTrim(Z9_FAULID))
		oFault:cCode                := Alltrim(TFAU->Z9_FAULID)
		oFault:cSolutionCode        := TFAU->Z9_ACTION
		oFault:cPartSessionCode     := "NC"
		oFault:cSymptomEncodedCode  := TFAU->Z9_SINTCOD
		oFault:cFaultCodeReason     := IIF(Empty(TFAU->Z9_MOTDEFE),"1",TFAU->Z9_MOTDEFE)
		oFault:cRepairCodeLevel     := IIF(Empty(TFAU->Z9_NIVELRE),"1",TFAU->Z9_NIVELRE)
		oFault:cGoNoGoFaultCode     := cFGONGO
		oFault:oWSPart:= WSServiceOrder_ArrayOfTParts():New()
		aAdd(aDados,oFault)
		//oFault:oWSPart:oWSTParts
		*
		aTPart := {}
		cindfaut:=TFAU->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM))
		aTPart := GetTPart(cindfaut)
		If Len(aTPart) > 0
			oParts := WSServiceOrder_TParts():New()
			For t := 1 to Len(aTPart)
				cIDPECA := aTPart[t,1]
				cSEQPEC := aTPart[t,2]
				cCGRSO2 := aTPart[t,3]
				cCODPEC := aTPart[t,4]
				cPECQTD := aTPart[t,5]
				cPOSPEC := aTPart[t,6]
				cPREVPC := aTPart[t,7]
				oParts:cDataVersion := cIDPECA
				oParts:nSeq         := cSEQPEC
				oParts:cSessionCode := cCGRSO2
				oParts:cCode        := AllTrim(cCODPEC)
				oParts:nPartQty     := cPECQTD
				oParts:cSchemaCode  := cPOSPEC
				oParts:cPrevCorrect := cPREVPC
				If cSTPECA $ "0/2/ "
					aAdd(oFault:oWSPart:oWSTParts, oParts ) // ATRIBUTO DO TFault
				EndIf
			Next
		Endif
		TFAU->(dbSkip())
	EndDo
	dbSelectArea("TFAU")
	TFAU->(DBCLOSEArea())
EndIf
Return(aDados)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma  ณGetTPart  บAutor  ณMicrosiga                 บData ณ  /  /  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetTPart(cindfaut)
Local aDadpec := {}
// ATENCAO, NAO ALTERAR A ORDEM NO VETOR
Local _cIDPECA := ""
Local _cSEQPEC := ""
Local _cCGRSO2 := ""
Local _cCODPEC := ""
Local _cPECQTD := ""
Local _cPOSPEC := ""
Local _cPREVPC := ""
If AllTrim(cindfaut) <> ""
	cQry := "     SELECT Z9_NUMOS, Z9_IMEI, Z9_PARTNR,Z9_PREVCOR,Z9_POSESQU,Z9_SEQ,Z9_ITEM,SUM(Z9_QTY) AS QTY "
	cQry += "     FROM "+RETSQLNAME("SZ9")+" (NOLOCK)  WHERE "
	cQry += "                             Z9_FILIAL = '"+xFilial("SZ9")+"' "
	cQry += "                             AND SubSTRING(Z9_NUMOS,1,6) = '"+SubSTR(cindfaut,1,6)+"'  "
	cQry += "                             AND Z9_SEQ ='"+SubSTR(cindfaut,7,2)+"'  "
	cQry += "                             AND Z9_ITEM='"+SubSTR(cindfaut,9,2)+"'  "
	cQry += "                             AND Z9_PARTNR <> ''   "
	cQry += "     GROUP BY Z9_NUMOS, Z9_IMEI, Z9_PARTNR,Z9_PREVCOR,Z9_POSESQU,Z9_SEQ,Z9_ITEM "
	TCQUERY cQry NEW ALIAS "TPEC"
	dbSelectArea("TPEC")
	dbGoTop()
	While !TPEC->(Eof())
		_cIDPECA := TPEC->(SubSTR(Z9_NUMOS,1,6)+AllTrim(Z9_SEQ)+AllTrim(Z9_ITEM))   //""
		_cSEQPEC := Val(TPEC->Z9_SEQ)   //""
		_cCGRSO2 := "NC"  //""
		_cCODPEC := TPEC->Z9_PARTNR  //""
		_cPECQTD := TPEC->QTY  //""
		_cPOSPEC := Iif(Empty(SZ9->Z9_POSESQU),"12",SZ9->Z9_POSESQU)  //""
		_cPREVPC := TPEC->Z9_PREVCOR  //""
		aAdd(aDadpec,{_cIDPECA,_cSEQPEC,_cCGRSO2,_cCODPEC,_cPECQTD,_cPOSPEC,_cPREVPC})
		TPEC->(dbSkip())
	EndDo
	dbSelectArea("TPEC")
	TPEC->(DBCLOSEArea())
Endif
Return(aDadpec)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออหอออออออัออออออออออออออออออออออออออหอออออัออออออออปฑฑ
ฑฑบPrograma ณGetFollowUpบAutor  ณMicrosiga                 บData ณ  /  /  บฑฑ
ฑฑฬอออออออออุอออออออออออสอออออออฯออออออออออออออออออออออออออสอออออฯออออออออนฑฑ
ฑฑบDesc.    ณ                                                             บฑฑ
ฑฑบ         ณ                                                             บฑฑ
ฑฑฬอออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ                                                             บฑฑ
ฑฑศอออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetFollowUp(_xImei,_xOS)
Local aDados := {}
Local cQry   := ""
Default _xImei := "XXXXXX"
Default _xOS   := "XXXXXX"
oFollowUP := WSServiceOrder_TFollowUp():New()
oFollowUP:cDataVersion   := cIDACOM
oFollowUP:cDate          := cDTACOM
oFollowUP:nSeqNo         := cSEQACO
oFollowUP:cFollowUp      := cACOMPA
oFollowUP:cUser	         := cUSERAC
aAdd(aDados,oFollowUP)
Return(aDados)