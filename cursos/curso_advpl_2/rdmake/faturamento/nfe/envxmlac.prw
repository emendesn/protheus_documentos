#INCLUDE "TOTVS.CH"
#Include "TBICONN.CH"




User Function EnvXmlAc(aParam)

Private cTpUser := "J"
Private nNumUser := 0
Private cQuery := ""
Private cEndWs := ""
Private cLogMail := ""
Private lErro := .F.
Private cDtIni := ""
Private lAtualizou := .F.     
DEFAULT aParam :={"02","02"}

RPCSETTYPE(3)
If FindFunction('WFPREPENV')
	WfPrepENV(aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIf
MsgLog(" EnvXmlAc --> PROCESSO INICIADO!")

//busca cnpj da acer...

cQuery := " SELECT F2_SERIE,F2_DOC,F2_EMISSAO,A1_CGC,SF2.R_E_C_N_O_ SF2RECNO,F2_CHVNFE FROM "+RetSqlName("SF2")+ " SF2 "
cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 ON SA1.D_E_L_E_T_='' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1_FILIAL='"+xFilial("SA1")+"'"   
cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 ON SC6.D_E_L_E_T_='' AND C6_NOTA=F2_DOC AND C6_SERIE=F2_SERIE AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUMPCOM<>''"   
cQuery += " WHERE SF2.D_E_L_E_T_='' AND "
cQuery += " A1_CGC LIKE '11068167%'  "                                                           
//cQuery += " AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_EMISSAO>='20150515'"
cQuery += " AND F2_XFTPXML = ' ' AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_EMISSAO>='20150515'   AND F2_CHVNFE <> '' "
cQuery += " GROUP BY F2_SERIE,F2_DOC,F2_EMISSAO,A1_CGC,SF2.R_E_C_N_O_,F2_CHVNFE
cQuery += " ORDER BY F2_SERIE+F2_DOC"


cQuery := ChangeQuery(cQuery)
			
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB")
While(!TRB->(Eof()))                                      


  //processo a busca do xml no ws de nf-e local e envia para ftp
  EnvXmlNF(TRB->F2_SERIE, TRB->F2_DOC, StoD(TRB->F2_EMISSAO), TRB->A1_CGC,TRB->F2_CHVNFE)
  
  TRB->(DbSkip())
EndDo
TRB->(DbCloseArea())
 
MsgLog(" EnvXmlAc --> PROCESSO FINALIZADO!") 

RESET ENVIRONMENT
Return()





Static Function EnvXmlNF(cSerNf,cNumNf,dEmissao,cCnpj,cnomexml)
Local cXml,nHandle
Local lOk        := .T.                                      
Local lDir       := .F.
Local CENDFTP    :=Alltrim(GetMv("MV_XFTPAGP"))        
Local CUSERFTP   :=Alltrim(GetMv("MV_XFTPUSU"))             
Local CPASSFTP   :=Alltrim(GetMv("MV_XFTPPAS")) 
Local CPATH      :=alltrim(GetMv("MV_XFTPDXM"))

cnomexml := alltrim(cnomexml)+"-nfe"



MsgLog(" EnvXmlAc --> CARREGANDO XML DA NF "+cSerNf+"-"+cNumNf+"....")
    
cXml := SpedPExp(GetIdEnt(),cSerNf,cNumNf,cNumNf,"",.F., dEmissao,dEmissao,cCnpj,cCnpj)

lOk := !Empty(cXml)
If lOk
	nHandle := FCreate("\data\"+cnomexml+".xml")
	If nHandle > 0
		FWrite(nHandle,cXml)
		FClose(nHandle)
	Else 
	  lOk := .F.
	EndIf
Endif

if lOk .AND. !FTPCONNECT( CENDFTP , , CUSERFTP ,CPASSFTP )
		MsgLog(" EnvXmlAc --> Nao foi possivel se conectar ao FTP!!" )		
		lOk := .F.
EndIf   		      

lDir := FTPDirChange(Alltrim(GetMv("MV_XFTPDXM")))
If lOk .and. !lDir
	ConOut( "Falha de conexЦo ao diretСrio de FTP. Verifique se o parametro MV_XFTPDXM esta configurado corretamente.")
	lOk := .F.
EndIf

//Tenta realizar o upload de um item qualquer no array   	
//Armazena no local indicado pela constante PATH	
if lOk .AND. !FTPUPLOAD("\data\"+cnomexml+".xml", cnomexml+".xml")		
	MsgLog(" EnvXmlAc --> Nao foi possivel realizar o upload no FTP!!" )   		
	lOk := .F.  	
EndIf		

FErase("\data\"+cnomexml+".xml") 

//Tenta desconectar do servidor ftp		
FTPDISCONNECT()

if lOk 
	DbSelectArea("SF2")
	SF2->(DbGoTo(TRB->SF2RECNO))
	RecLock("SF2")
	  SF2->F2_XFTPXML := "S"
	MsUnLock()
Endif


Return()



//зддддддддддддддддддддддддддддддддддддддддддд??
//?UNCAO QUE BUSCA O XML NO WEBSERVICE DA NF-E?
//юддддддддддддддддддддддддддддддддддддддддддд??

Static Function SpedPExp(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd, dDataDe,dDataAte,cCnpjDIni,cCnpjDFim)

Local aDeleta  := {}
Local nHandle  := 0
Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cChvNFe  := ""
Local cDestino := ""
Local cDrive   := ""
Local cModelo  := ""
Local cPrefixo := ""
Local cCNPJDEST := Space(14)                
Local cNFes     := ""
Local cIdflush  := cSerie+cNotaIni
Local cXmlInut  := ""
Local cAnoInut  := ""
Local cAnoInut1 := ""
Local nX        := 0
Local oWS
Local oRetorno
Local oXML
Local lOk      := .F.
Local lFlush   := .T.
Local lFinal   := .F.
Local cXmlRet := ""

ProcRegua(Val(cNotaFim)-Val(cNotaIni))
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//?Corrigi diretorio de destino                                           ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SplitPath(cDirDest,@cDrive,@cDestino,"","")
cDestino := cDrive+cDestino
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//?Inicia processamento                                                   ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Do While lFlush
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt 
		oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial        := cIdflush // cNotaIni
		oWS:cIdFinal          := cSerie+cNotaFim
		oWS:dDataDe           := dDataDe
		oWS:dDataAte          := dDataAte
		oWS:cCNPJDESTInicial  := cCnpjDIni
		oWS:cCNPJDESTFinal    := cCnpjDFim
		oWS:nDiasparaExclusao := 0
		lOk := oWS:RETORNAFX()
		oRetorno := oWS:oWsRetornaFxResult
	
		If lOk
		 	ProcRegua(Len(oRetorno:OWSNOTAS:OWSNFES3))
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//?Exporta as notas                                                       ?
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
		    For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3) 
		    
		    	/*
			    //Ponto de Entrada para permitir filtrar as NF
         		If ExistBlock("SPDNFE01")
		        	If !ExecBlock("SPDNFE01",.f.,.f.,{oRetorno:OWSNOTAS:OWSNFES3[nX]})
            			loop
			        Endif
       			Endif
    			*/
		 		oXml := oRetorno:OWSNOTAS:OWSNFES3[nX]
				oXmlExp   := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
				cXmlRet := ""
				If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U" 
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)				
				Else
	    			cCNPJDEST := ""
    			EndIf	
                cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
			    cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')  
		 		If !Empty(oXml:oWSNFe:cProtocolo)
			    	cNotaIni := oXml:cID	 		
					cIdflush := cNotaIni
			 		cNFes := cNFes+cNotaIni+CRLF
			 		cChvNFe  := SpedNfeId(oXml:oWSNFe:cXML,"Id")	 			
					cModelo := cChvNFe
					cModelo := StrTran(cModelo,"NFe","")
					cModelo := StrTran(cModelo,"CTe","")
					cModelo := SubStr(cModelo,21,02)
					
					Do Case
						Case cModelo == "57"
							cPrefixo := "CTe"
						OtherWise
							cPrefixo := "NFe"
					EndCase	 
					
					cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
					If cModelo == "57"
						cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
						cRodap := '</cteProc>'
					Else
						Do Case
							Case cVerNfe <= "1.07"
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
							Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
								cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
							OtherWise
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
						EndCase
						cRodap := '</nfeProc>'
					EndIf
				
					aadd(aDeleta,oXml:cID)
		 	 			
	 			    // cXmlRet := AllTrim(oXml:oWSNFe:cXML)//+AllTrim(oXml:oWSNFe:cXMLPROT)
	 			    // cXmlRet := AllTrim(oXml:oWSNFe:cXMLPROT)
	 			    cXmlRet := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(oXml:oWSNFe:cXMLPROT)+AllTrim(cRodap)
	 			    
	 			    If !Empty(cXmlRet)
						If ExistBlock("FISEXPNFE")
							ExecBlock("FISEXPNFE",.f.,.f.,{cXmlRet})
						Endif
					EndIF
         			MsgLog(" NFeSBRA --> Xml da nf-e "+Alltrim(oXml:cID)+" processado com sucesso...")	
			 					
			 	EndIf      
			 	
			 	
			 	
			 	If oXml:OWSNFECANCELADA<>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
					cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
					cNotaIni := oXml:cID
					cIdflush := cNotaIni
					cNFes    := cNFes+cNotaIni+CRLF
					If "INUT"$oXml:oWSNFeCancelada:cXML
						cXmlInut  := oXml:OWSNFECANCELADA:CXML
						cAnoInut1 := At("<ano>",cXmlInut)+5
						cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
					EndIf
			    EndIf
			    
			    IncProc()

				
		    Next nX
			aDeleta  := {}
		    If Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes)
			   MsgLog(" NFeSBRA -->  N? h?dados")//	Aviso("SPED",STR0106,{"Ok"})	// "N? h?dados"
				lFlush := .F.	
		    EndIf
		Else
			MsgLog(" NFeSBRA -->  ",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			lFinal := .T.
		EndIf

		cIdflush := AllTrim(Substr(cIdflush,1,3) + StrZero((Val( Substr(cIdflush,4,Len(AllTrim(mv_par02))))) + 1 ,Len(AllTrim(mv_par02))))
		If cIdflush <= AllTrim(cNotaIni) .Or. Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .Or. Empty(cNfes) .Or. ;
		   cIdflush <= Substr(cNotaIni,1,3)+Replicate('0',Len(AllTrim(mv_par02))-Len(Substr(Rtrim(cNotaIni),4)))+Substr(Rtrim(cNotaIni),4)// Importou o range completo
			lFlush := .F.
			If !Empty(cNfes)
			    MsgLog(" NFeSBRA -->  Solicitacao das nf-e "+Alltrim(cNotaIni)+"-"+Alltrim(cNotaFim)+" processada com sucesso...")	
			EndIf
		EndIf
EndDo

Return(cXmlRet)




//busca Ident do TSS
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//?btem o codigo da entidade                                              ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	MsgLog("SPED "+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
EndIf

RestArea(aArea)
Return(cIdEnt)


Static Function MsgLog(_cMsg)
cLogMail += "["+DToS(Date())+"-"+Time()+"]"+_cMsg + "<br>" 
ConOut("["+DToS(Date())+"-"+Time()+"]"+_cMsg)
Return()